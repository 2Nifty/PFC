
using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.BusinessLogicLayer;

public partial class Partner : System.Web.UI.Page
{

    TradingPartner partner = new TradingPartner();
    string whereCondition = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(Partner));
        lnkCustNo.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");
        if (!IsPostBack)
        {
            Session["Security"] = partner.GetSecurityCode(Session["UserName"].ToString());
            ibtnSave.Visible = (Session["Security"] != "") ? true : false;

            BindLocationDetails(whereCondition);
            BindTradingCodeValues();
            BindTradingTypeValues();
            
            ClearControl();
            ViewState["Mode"] = "Add";
        }
    }
 
    protected void BindUserInfo()
    {
        partner.DisplayMessage(MessageType.Failure, "", lblMessage);
        int recCount;
        bool user;
        DataTable dtUsersearch;
       // HiddenField hidLeftFrame = ucUser.FindControl("hidLeftFrameBindMode") as HiddenField;
        Session["Group"] = ddlSearch.SelectedItem.Value;
        if (txtSearch.Text != "")
        {

            if (ddlSearch.SelectedItem.Value == "LocationCustomerNo")
                whereCondition = "TP.LocationCustomerNo like '" + txtSearch.Text.Trim() + "%'";

            else
            {
                whereCondition = "TP.AssignedVendorNo like '" + txtSearch.Text.Trim() + "%'";
            }
            dtUsersearch = partner.GetLocationView(whereCondition);
            if (dtUsersearch.Rows.Count > 0 && dtUsersearch != null)
            {
                user = true;
                hidTradingID.Value = dtUsersearch.Rows[0]["pEDITradingPartnerID"].ToString();
                hidCustNo.Value = dtUsersearch.Rows[0]["CustNo"].ToString();
            }
            else
            {
                user = false;
            }
            if (user)
            {
                UserInfo = txtSearch.Text.Trim().ToString();
                hidLeftFrameBindMode.Value = "";

               // ViewState["Mode"] = "Add";

                foreach (DataRow drow1 in dtUsersearch.Rows)
                {
                    SelectedNode = drow1["CustNo"].ToString();
                }

            }
            else
            {
                //lblMessage.Text = "No Records found";
                partner.DisplayMessage(MessageType.Failure, "No Records Found", lblMessage);
                whereCondition = "";
                BindLocationDetails(whereCondition);
                ClearControl();
                ViewState["Mode"] = "Add";
            }
        }
        else
        {
           
            whereCondition="";
            BindLocationDetails(whereCondition);
            ClearControl();
            ViewState["Mode"] = "Add";
        }
           // ViewState["LocWhereClause"] = whereCondition;
        txtSearch.Text = "";
    }

    private string  GetWhereClause()
    {
        string _whereClause="";
        if (ddlSearch.SelectedItem.Value == "LocationCustomerNo")
            _whereClause = "TP.LocationCustomerNo like '" + txtSearch.Text.Trim() + "%'";

        else
            _whereClause = "TP.AssignedVendorNo like '" + txtSearch.Text.Trim() + "%'";
        ViewState["LocWhereClause"] = _whereClause;
        return _whereClause;

    }
    protected void ibtnSearchByButton_Click(object sender, ImageClickEventArgs e)
    {
        BindUserInfo();
        //BindLocationDetails(GetWhereClause()); 

        upnlData.Update();
        upnlMenu.Update();
    }

    protected void ibtnAdd_Click(object sender, ImageClickEventArgs e)
    {
        ClearControl();
        ViewState["Mode"] = "Add";    
    }
   

    protected void ibtnSearch_Click(object sender, EventArgs e)
    {

        //ucEmpData.NewEmployee = "Save";
        Session["CustNo"] = hidCustNo.Value;
        BindTradingInfo(hidTradingID.Value);
        hidLeftFrameBindMode.Value = "";

    }


    #region Data Entry

    string columnValue = "";
    SecurityInfo employee = new SecurityInfo();   
    HiddenField hidID = new HiddenField();
   
    private void ClearControl()
    {
        txtAssignedVendNo.Text = "";
        txtEmail.Text = "";
        txtCustNo.Text = "";
        ddlTradingCode.SelectedIndex = 0;
        ddlTradingType.SelectedIndex = 0;
        lblAddress.Text = "";
        lblCity.Text = "";
        lblPhone.Text = "";
        lblCustName.Text = "";
    }

    private void BindTradingCodeValues()
    {
        string status = "LM.ListName = 'EDITrdPrtnrCds' And LD.fListMasterID = LM.pListMasterID";
        employee.BindListControls(ddlTradingCode, "ListDesc", "ListValue", partner.GetBindCodeData(status), "--Select--");

    }

    private void BindTradingTypeValues()
    {
        string status = "LM.ListName = 'EDITrdPrtnrType' And LD.fListMasterID = LM.pListMasterID";
        employee.BindListControls(ddlTradingType, "ListDesc", "ListValue", partner.GetBindTypeData(status), "--Select--");

    }

    private void SelectItem(DropDownList ddlControl, string value)
    {
        ListItem lItem = ddlControl.Items.FindByValue(value) as ListItem;
        if (lItem != null)
            ddlControl.SelectedValue = value.Trim();
        else
            ddlControl.ClearSelection();
    }

    private void BindTradingInfo(string TradingID)
    {

        DataTable dtTradingInformation = partner.getTrading(TradingID);

        if (dtTradingInformation != null && dtTradingInformation.Rows.Count > 0)
        {
            
            txtCustNo.Text = dtTradingInformation.Rows[0]["LocationCustomerNo"].ToString();
            txtEmail.Text = dtTradingInformation.Rows[0]["CustomerEDIEmailAddress"].ToString();
            txtAssignedVendNo.Text = dtTradingInformation.Rows[0]["AssignedVendorNo"].ToString();
            SelectItem(ddlTradingCode, dtTradingInformation.Rows[0]["TradingPartnerCd"].ToString());
            SelectItem(ddlTradingType, dtTradingInformation.Rows[0]["EDIType"].ToString().Trim());
            BindCustomerInformation(hidCustNo.Value);
            Session["TradingID"] = TradingID;
            lblEntryID.Text = dtTradingInformation.Rows[0]["EntryID"].ToString().Trim();
            lblEntryDate.Text =   dtTradingInformation.Rows[0]["EntryDt"].ToString().Trim();
            lblChangeID.Text = dtTradingInformation.Rows[0]["ChangeID"].ToString().Trim();
            lblChangeDate.Text =  dtTradingInformation.Rows[0]["ChangeDt"].ToString().Trim();

        }
        ViewState["Mode"] = "Save";

    }

    protected void BindCustomerInformation(string CustNo)
    {
        DataTable dtCustInformation = partner.CustInformation(CustNo);
        if (dtCustInformation != null && dtCustInformation.Rows.Count > 0)
        {
            lblCustName.Text = dtCustInformation.Rows[0]["CustName"].ToString();
            lblAddress.Text = dtCustInformation.Rows[0]["addrline1"].ToString();
            lblCity.Text = dtCustInformation.Rows[0]["city"].ToString() + "," + dtCustInformation.Rows[0]["state"].ToString() + " " + dtCustInformation.Rows[0]["country"].ToString();
            lblPhone.Text = dtCustInformation.Rows[0]["phoneno"].ToString();
        }
    }

    protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
    {
        if (ViewState["Mode"].ToString() == "Add")
        {
            DataTable dtCheckCustNo = partner.CheckTradingCustNo(txtCustNo.Text.ToString().Replace("'", "''"));
            if (dtCheckCustNo.Rows.Count > 0)
            {
                
                partner.DisplayMessage(MessageType.Failure, "Customer Number already exists", lblMessage);

            }
            else
            {

                string tradingID;
                columnValue = "'" + txtCustNo.Text.Replace("'", "''") + "'," +
                               "'" + ddlTradingType.SelectedItem.Value.ToString().Replace("'", "''") + "'," +
                               "'" + ddlTradingCode.SelectedItem.Value.ToString().Replace("'", "''") + "'," +
                               "'" + txtEmail.Text.Replace("'", "''") + "'," +
                               "'" + txtAssignedVendNo.Text.Replace("'", "''").Trim() + "'," +
                               "'" + Session["fCustomerMasterID"].ToString() + "'," +
                               "'" + Session["UserName"].ToString() + "'," +
                               "'" + DateTime.Now.ToShortDateString() + "'";

                tradingID = partner.InsertTradingInformation(columnValue);
               
                partner.DisplayMessage(MessageType.Success, "Data is Successfully added", lblMessage);
                //ClearControl();
            }

        }
        else
        {

            string updateValue;
            if (txtCustNo.Text.ToString().Replace("'", "''") != Session["CustNo"].ToString().Replace("''", "''"))
            {

                DataTable dtCheckCustNo = partner.CheckTradingCustNo(txtCustNo.Text.ToString().Replace("'", "''"));
                if (dtCheckCustNo.Rows.Count > 0)
                {
                   // lbl.Text = "Customer Number already exists";
                    partner.DisplayMessage(MessageType.Failure, "Customer Number already exists ", lblMessage);
                }
                else
                {

                    updateValue = "LocationCustomerNo='" + txtCustNo.Text.Replace("'", "").Trim() + "'," +
                                           "EDIType='" + ddlTradingType.SelectedItem.Value.ToString() + "'," +
                                            "TradingPartnerCd='" + ddlTradingCode.SelectedItem.Value.ToString() + "'," +
                                              "AssignedVendorNo='" + txtAssignedVendNo.Text.ToString() + "'," +
                                           "CustomerEDIEmailAddress='" + txtEmail.Text.Replace("'", "") + "'," +
                                           "fCustomerMasterID='" + Session["fCustomerMasterID"].ToString() + "'," +
                                           "ChangeID='"+Session["UserName"].ToString()+"'," +
                                           "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";
                    partner.UpdateTradingInformation(updateValue, Session["TradingID"].ToString());
                   
                    partner.DisplayMessage(MessageType.Success, "Data is Successfully updated ", lblMessage);
                   // ClearControl();
                    ViewState["Mode"] = "Add";
                }

            }
            else
            {

                updateValue = "LocationCustomerNo='" + txtCustNo.Text.Replace("'", "").Trim() + "'," +
                                     "EDIType='" + ddlTradingType.SelectedItem.Value.ToString() + "'," +
                                      "TradingPartnerCd='" + ddlTradingCode.SelectedItem.Value.ToString() + "'," +
                                       "AssignedVendorNo='" + txtAssignedVendNo.Text.ToString() + "'," +
                                     "CustomerEDIEmailAddress='" + txtEmail.Text.Replace("'", "") + "'," +
                                     "ChangeID='" + Session["UserName"].ToString() + "'," +
                                     "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";
                partner.UpdateTradingInformation(updateValue, Session["TradingID"].ToString());
               
                partner.DisplayMessage(MessageType.Success, "Data is Successfully updated", lblMessage);
               // ClearControl();
                ViewState["Mode"] = "Add";

            }

        }
        ViewState["CustomerNo"] = txtCustNo.Text;
        string value = "";
        BindLocationDetails(value);
        SelectedNode = ViewState["CustomerNo"].ToString();
            ClearControl();
        upnlMessage.Update();
        upnlData.Update();
        upnlMenu.Update();


    }

    protected void ibtnDelete_Click(object sender, ImageClickEventArgs e)
    {
        Label lbl = Page.FindControl("lblMessage") as Label;
        UpdatePanel pnl = Page.FindControl("upnlMessage") as UpdatePanel;
        if (ViewState["Mode"].ToString() == "Save")
        {

            partner.DeleteTradingInforamtion(Session["TradingID"].ToString());
            ViewState["Mode"] = "Add";
            partner.DisplayMessage(MessageType.Success, "Data is Successfully deleted", lbl);
            ClearControl();
            string value = "";
            BindLocationDetails(value);
            pnl.Update();
            upnlMessage.Update();
            upnlData.Update();
            upnlMenu.Update();
        }
    }

    protected void txtCustNo_TextChanged(object sender, EventArgs e)
    {
        TextBox txtCustomerNo = sender as TextBox;

        DataTable dt = partner.GetCustMasterID(txtCustomerNo.Text.ToString());
        if (dt.Rows.Count > 0 && dt != null)
        {
            Session["fCustomerMasterID"] = dt.Rows[0]["pCustMstrID"].ToString();
            BindCustomerInformation(txtCustomerNo.Text.ToString());
            ScriptManager scriptManager = Page.FindControl("ScriptManager1") as ScriptManager;
            scriptManager.SetFocus(ddlTradingCode);
        }
        else
        {

            Label lbl = Page.FindControl("lblMessage") as Label;
            partner.DisplayMessage(MessageType.Failure , "Invalid customer Number", lbl);
            UpdatePanel pnl = Page.FindControl("upnlMessage") as UpdatePanel;
            pnl.Update();
            ScriptManager scriptManager = Page.FindControl("ScriptManager1") as ScriptManager;
            scriptManager.SetFocus(txtCustomerNo);
        }
    }

    #endregion



    #region Left Menu   

    public string SelectedNode
    {
        set
        {

            SetSelectedNode(value);

        }

    }

    public string UserInfo
    {
        set
        {
            ViewState["UserInfo"] = value;
            if (value != "")
            {
                BindLocationDetails(GetWhereClause());
                BindTradingInfo(hidTradingID.Value);
            }
            else
            {
                BindLocationDetails(value);
            }
         
          Session["CustNo"] = hidCustNo.Value;
         
        }
    }

    

    public void BindLocationDetails( string whereCondition)
    {
        try
        {

           
            MenuFrameTV.Nodes.Clear();
            DataTable dsDetails = partner.GetLocationView(whereCondition);

            if (dsDetails != null && dsDetails.Rows.Count > 0)
            {
                TreeNode tvLoc = new TreeNode("Location", "Location");

                MenuFrameTV.Nodes.Add(tvLoc);
                tvLoc.SelectAction = TreeNodeSelectAction.Expand;
                string[] locInfo ={ "LocName", "LocID" };
                DataTable dtLocName = dsDetails.DefaultView.ToTable(true, locInfo);
                dtLocName.DefaultView.Sort = "LocName asc";
                DataTable dtCust = dsDetails.Copy();
                foreach (DataRow drow in dtLocName.Rows)
                {
                    TreeNode tvGroupName = new TreeNode(drow["LocName"].ToString(), drow["LocName"].ToString());
                    tvLoc.ChildNodes.Add(tvGroupName);
                    tvGroupName.SelectAction = TreeNodeSelectAction.Expand;
                   // DataTable dtCustInfo = partner.GetLocationView("LocID='" + drow["LocID"].ToString() + "'");
                  
                    
                    dtCust.DefaultView.RowFilter = "LocName='" + drow["LocName"].ToString()+"'";
                    string[] CustInfo ={ "CustNo", "CustName", "pEDITradingPartnerID" };
                    DataTable  dtCustInfo = dtCust.DefaultView.ToTable(true, CustInfo);
                    if (dtCustInfo != null && dtCustInfo.Rows.Count > 0)
                    {
                        foreach (DataRow drow1 in dtCustInfo.Rows)
                        {

                            string strName = drow1["CustName"].ToString().Replace("'", "~") + "&nbsp;&nbsp;&nbsp;" + "- &nbsp;&nbsp;" + drow1["CustNo"].ToString();
                            string strValue = "<div onclick=\"javascript:GetTradingInformation('" + drow1["pEDITradingPartnerID"].ToString() + "','" + drow1["CustNo"].ToString() + "');\" style=width:500px;cursor:hand; >";
                            strValue += strName;
                            strValue += "</div>";
                            TreeNode tvCustInfo = new TreeNode(strValue, drow1["CustNo"].ToString());

                            tvGroupName.ChildNodes.Add(tvCustInfo);
                            tvCustInfo.SelectAction = TreeNodeSelectAction.Expand;

                        }
                    }
                    else
                    {
                        TreeNode tvTrading = new TreeNode("", "");
                        tvGroupName.ChildNodes.Add(tvTrading);
                        tvTrading.SelectAction = TreeNodeSelectAction.Expand;
                    }

                }

            }
        }
        catch (Exception ex) { }
    }
    
    public void SetSelectedNode(string Node)
    {
        try
        {

            foreach (TreeNode tn in MenuFrameTV.Nodes)
            {
                if (tn.Value.Trim() == Node.Trim())
                {
                    tn.Selected = true;
                    tn.Expand();
                    break;
                }
                else
                    CheckChildNode(tn, Node);

            }

        }
        catch (Exception ex) { }
    }

    public void CheckChildNode(TreeNode tnCheck, string nodeValue)
    {
        try
        {

            foreach (TreeNode tn in tnCheck.ChildNodes)
            {
                if (tn.Value.Trim() == nodeValue.Trim())
                {
                    tn.Selected = true;
                    tn.Parent.Expand();
                    tn.ExpandAll();
                    if (tn.Parent.Parent != null)
                    {
                        tn.Parent.Parent.Expand();
                    }
                    break;

                }
                else
                    //CheckChildNode(tn, nodeValue);
                    CheckChildNode(tn, nodeValue);
            }
        }
        catch (Exception ex) { }
    }

    #endregion
}
