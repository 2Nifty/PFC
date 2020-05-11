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
using PFC.Intranet.MaintenanceApps;

public partial class RepMaster : System.Web.UI.Page
{
    string lockUser;
    DataTable dtRepInfo;
  
    RepMasterBl RepMasterBl = new RepMasterBl();
    MaintenanceUtility MaintUtil = new MaintenanceUtility();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Ajax.Utility.RegisterTypeForAjax(typeof(RepMaster));

            Session["RepLockStatus"] = "";
            Session["RepID"] = "";

            GetSecurity();
            BindRepDDL();
            tblFooter.Visible = false;
            tblContent.Visible = false;
        }
    }

    #region RepSearch
    //
    //Change tree view based on View by selection
    //  
    protected void ddlViewOption_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlViewOption.SelectedItem.Text == "Rep")
        {
            //
            //Display the Rep Tree; Hide the Loc Tree
            //
            divRep.Style.Add(HtmlTextWriterStyle.Display, "");
            divLocation.Style.Add(HtmlTextWriterStyle.Display, "none");
        }
        else
        {
            //
            //Display the Loc Tree; Hide the Rep Tree
            //
            divRep.Style.Add(HtmlTextWriterStyle.Display, "none");
            divLocation.Style.Add(HtmlTextWriterStyle.Display, "");
        }
    }

    //
    //Search for specified Rep Name or Rep No
    //
    protected void ibtnFindRep_Click(object sender, ImageClickEventArgs e)
    {
        ViewState["Mode"] = "Search";
        hidSearch.Value = "click";
        hidSearchBy.Value = ddlSearch.SelectedValue.ToString();
        hidSearchTxt.Value = txtSearch.Text;
        BindRepData();    
        upnlData.Update();
        upnlTree.Update();
    }

    //
    //Find the specified Rep Name or Rep No and display the data
    //
    protected void BindRepData()
    {
        lblSearch.Text = "";
        lblMessage.Text = "";
        pnlStatus.Update();

        if (txtSearch.Text != "")
        {
            dtRepInfo = RepMasterBl.GetRep(ddlSearch.SelectedItem.Value, txtSearch.Text);
            if (dtRepInfo.Rows.Count > 0 && dtRepInfo != null)
            {
                //DisplaStatusMessage("Records Found" + dtRepInfo.Rows.Count.ToString(), "success");
                lblSearch.Text = dtRepInfo.Rows.Count.ToString().Trim() + " record(s) found";
                hidRepMasterID.Value = dtRepInfo.Rows[0]["pRepMasterID"].ToString();
                hidRepNo.Value = dtRepInfo.Rows[0]["RepNo"].ToString();
                DispRepInfo();
            }
            else
            {
                //lblMessage.Text = "No Records found";
                //DisplaStatusMessage("No Records Found", "fail");
                ucRep.filterRepName = "";
                lblSearch.Text = "No record(s) found";
            }
        }
    }

    //
    //Display the current RepMaster record data
    //
    //private void DispRepInfo(string RepMastID)
    private void DispRepInfo()
    {
        //
        //Check for Record Lock
        //
        CheckLock();
        if (Session["RepLockStatus"].ToString() == "L")
        {
            tblContent.Visible = false;
            tblFooter.Visible = false;
            ScriptManager.RegisterClientScriptBlock(upnlData, typeof(UpdatePanel), "Script", "alert('Record Locked By " + lockUser.ToString() + "');", true);
        }
        else
        {
            ViewState["Mode"] = "Edit";
            tblContent.Visible = true;
            tblFooter.Visible = true;

            MaintUtil.SetValueListControl(ddlLocation, dtRepInfo.Rows[0]["LocationNo"].ToString());
            txtRepNo.Text = dtRepInfo.Rows[0]["RepNo"].ToString();
            txtRepNo.Enabled = false;
            txtName.Text = dtRepInfo.Rows[0]["RepName"].ToString();
            MaintUtil.SetValueListControl(ddlStatus, dtRepInfo.Rows[0]["RepStatus"].ToString().Trim());
            txtPhone.Text = dtRepInfo.Rows[0]["RepPhoneNo"].ToString();
            txtFax.Text = dtRepInfo.Rows[0]["RepFaxNo"].ToString();
            txtContact.Text = dtRepInfo.Rows[0]["Contact"].ToString();
            txtEmail.Text = dtRepInfo.Rows[0]["RepEmail"].ToString();
            MaintUtil.SetValueListControl(ddlTerritory, dtRepInfo.Rows[0]["TerritoryNo"].ToString());
            MaintUtil.SetValueListControl(ddlSalesOrganization, dtRepInfo.Rows[0]["SalesOrgNo"].ToString());
            MaintUtil.SetValueListControl(ddlManager, dtRepInfo.Rows[0]["ManagersNo"].ToString());
            MaintUtil.SetValueListControl(ddlRegion, dtRepInfo.Rows[0]["SalesRegionNo"].ToString());
            //ddlVendorNo.Enabled = false;    // Disable Drop down, per Charles we need a procedure for pay to level, commision reps
            MaintUtil.SetValueListControl(ddlVendorNo, dtRepInfo.Rows[0]["RepVendNo"].ToString());
            MaintUtil.SetValueListControl(ddlClass, dtRepInfo.Rows[0]["RepClass"].ToString().Trim());  //Maintenance List needs to add R & C 
            txtNotes.Text = dtRepInfo.Rows[0]["RepNotes"].ToString();
            txtFromZip.Text = dtRepInfo.Rows[0]["FromzipRange"].ToString();
            txtToZip.Text = dtRepInfo.Rows[0]["TozipRange"].ToString();
            txtCommPct.Text = dtRepInfo.Rows[0]["stdCommissionPct"].ToString();

            smRepMaster.SetFocus(txtName);
        }

        if (hidSearch.Value == "click")
            BindTree();
    }
    #endregion

    #region RepAdd
    //
    //Display empty content panel to allow entry of new RepMaster data
    //
    protected void ibtnAdd_Click(object sender, ImageClickEventArgs e)
    {
        ViewState["Mode"] = "Add";
        lblSearch.Text = "";
        lblMessage.Text = "";
        pnlStatus.Update();

        tblContent.Visible = true;
        txtRepNo.Enabled = true;
        tblFooter.Visible = true;
        ClearControls();
        MaintUtil.ReleaseLock("RepMaster", Session["RepID"].ToString(), "Rep", Session["RepLockStatus"].ToString());
        smRepMaster.SetFocus(ddlLocation);
    }
    #endregion

    #region RepSave
    //
    //Save the new/updated RepMaster record
    //
    protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
    {
        DataTable saveRep, dupRep;

        string _repNo, _repName, _repClass, _repStatus, _repVendor, _RepOrg, _repLoc, _repTerr, _RepMgr;
        int _repRegion;
        decimal _commPct;

        lblMessage.Text = "";
        pnlStatus.Update();

        _repNo = txtRepNo.Text.ToString().Trim();
        _repName = txtName.Text.ToString().Trim();

        if (ddlClass.SelectedIndex == 0)
            _repClass = null;
        else
            _repClass = ddlClass.SelectedValue;

        if (ddlStatus.SelectedIndex == 0)
            _repStatus = null;
        else
            _repStatus = ddlStatus.SelectedValue;

        if (ddlVendorNo.SelectedIndex == 0)
            _repVendor = null;
        else
            _repVendor = ddlVendorNo.SelectedValue;

        if (ddlSalesOrganization.SelectedIndex == 0)
            _RepOrg = null;
        else
            _RepOrg = ddlSalesOrganization.SelectedValue;

        if (ddlLocation.SelectedIndex == 0)
            _repLoc = null;
        else
            _repLoc = ddlLocation.SelectedValue;

        if (ddlTerritory.SelectedIndex == 0)
            _repTerr = null;
        else
            _repTerr = ddlTerritory.SelectedValue;

        if (ddlRegion.SelectedIndex == 0)
            _repRegion = 0;
        else
            _repRegion = Convert.ToInt32(ddlRegion.SelectedValue);

        if (ddlManager.SelectedIndex == 0)
            _RepMgr = null;
        else
            _RepMgr = ddlManager.SelectedValue;

        if (string.IsNullOrEmpty(txtCommPct.Text.Trim()))
            _commPct = 0;
        else
            _commPct = Convert.ToDecimal(txtCommPct.Text);

        try
        {
            if (ViewState["Mode"].ToString() == "Add")
            {
                //
                //Add mode: INSERT new record
                //
                if (!string.IsNullOrEmpty(_repNo) && !string.IsNullOrEmpty(_repName))
                {
                    dupRep = RepMasterBl.DupRep(txtRepNo.Text);
                    if (dupRep.Rows.Count > 0)
                    {
                        //
                        //Duplicate record found
                        //
                        DisplaStatusMessage("Rep #" + txtRepNo.Text + " already on file for " + dupRep.Rows[0]["RepName"], "fail");
                        smRepMaster.SetFocus(txtRepNo);
                    }
                    else
                    {
                        //
                        //Insert the new RepMaster Record
                        //
                        saveRep = RepMasterBl.SaveRep("0", txtRepNo.Text, txtName.Text, txtPhone.Text, txtFax.Text,
                                                      txtEmail.Text, _repClass, _repStatus, "", _repVendor, "", "0", txtNotes.Text,
                                                      "0", txtContact.Text, _RepOrg, _repLoc, "", _repTerr, _repRegion, _RepMgr, "0",
                                                      "0", _commPct, txtFromZip.Text, txtToZip.Text, Session["UserName"].ToString(), "Add");

                        hidRepMasterID.Value = saveRep.Rows[0]["pRepMasterID"].ToString();
                        DisplaStatusMessage("Record added", "success");
                        ViewState["Mode"] = "Edit";
                        CheckLock();
                        RefreshTree();
                        ClearControls();
                        smRepMaster.SetFocus(txtName);
                    }
                }
                else
                {
                    if (string.IsNullOrEmpty(_repNo))
                    {
                        DisplaStatusMessage("Please enter a value for Rep No.", "fail");
                        smRepMaster.SetFocus(txtRepNo);
                    }
                    else
                    {
                        if (string.IsNullOrEmpty(_repName))
                        {
                            DisplaStatusMessage("Please enter a value for Rep Name", "fail");
                            smRepMaster.SetFocus(txtName);
                        }
                    }
                }
            }
            else
            {
                //
                //Edit mode: UPDATE the selected RepMaster Record
                //
                if (!string.IsNullOrEmpty(_repName))
                {
                    saveRep = RepMasterBl.SaveRep(hidRepMasterID.Value, txtRepNo.Text, txtName.Text, txtPhone.Text, txtFax.Text,
                              txtEmail.Text, _repClass, _repStatus, "", _repVendor, "", "0", txtNotes.Text,
                              "0", txtContact.Text, _RepOrg, _repLoc, "", _repTerr, _repRegion, _RepMgr, "0",
                              "0", _commPct, txtFromZip.Text, txtToZip.Text, Session["UserName"].ToString(), "Update");

                    hidRepMasterID.Value = saveRep.Rows[0]["pRepMasterID"].ToString();
                    DisplaStatusMessage("Record updated", "success");
                    RefreshTree();
                    tblContent.Visible = false;
                    tblFooter.Visible = false;
                    smRepMaster.SetFocus(txtSearch);
                }
                else
                {
                    DisplaStatusMessage("Please enter a value for Rep Name", "fail");
                    smRepMaster.SetFocus(txtName);
                }
            }

            pnlStatus.Update();
            upnlData.Update();
            upnlTree.Update();
        }
        catch (Exception EX)
        {
            DisplaStatusMessage(EX.ToString(), "fail");
        }
    }
    #endregion

    #region RepDel
    //
    //Delete the current RepMaster record
    //
    protected void ibtnDelete_Click(object sender, ImageClickEventArgs e)
    {
        if (hidRepMasterID.Value == "none")
        {
            DisplaStatusMessage("You must select a valid Rep record to delete", "fail");
        }
        else
        {
            RepMasterBl.DelRep(hidRepMasterID.Value);
            DisplaStatusMessage("Record Successfully Deleted", "success");
            ClearControls();
            MaintUtil.ReleaseLock("RepMaster", Session["RepID"].ToString(), "Rep", Session["RepLockStatus"].ToString());
            //if (ViewState["Mode"].ToString() == "Add")
            //    smRepMaster.SetFocus(txtName);
            //else
            //{
                tblContent.Visible = false;
                tblFooter.Visible = false;
                smRepMaster.SetFocus(txtSearch);
            //}
            RefreshTree();
        }
    }
    #endregion

    #region TreeView
    //
    //Refresh TreeView
    //
    protected void ibtnRefresh_Click(object sender, ImageClickEventArgs e)
    {
        hidSearchBy.Value = "";
        ddlSearch.SelectedValue = "RepName";
        hidSearchTxt.Value = "";
        txtSearch.Text = "";
        //RefreshTree();
        lblSearch.Text = "";
        ucRep.filterRepName = "";
        tblContent.Visible = false;
        tblFooter.Visible = false;
        smRepMaster.SetFocus(txtSearch);
    }

    protected void RefreshTree()
    {
        if (!string.IsNullOrEmpty(hidSearchBy.Value) && !string.IsNullOrEmpty(hidSearchTxt.Value))
        {
            ddlSearch.SelectedValue = hidSearchBy.Value;
            txtSearch.Text = hidSearchTxt.Value;
            BindTree();
        }
        else
        {
            //lblSearch.Text = "";
            //ucRep.filterRepName = "";
        }
    }

    //
    //Bind the TreeView based on the current search parameter
    //
    protected void BindTree()
    {
        //
        //Force the display of the Rep Tree during search
        //
        ddlViewOption.SelectedValue = "Rep";
        divRep.Style.Add(HtmlTextWriterStyle.Display, "");
        divLocation.Style.Add(HtmlTextWriterStyle.Display, "none");

        if (ddlSearch.SelectedValue == "RepName")
            ucRep.filterRepName = txtSearch.Text.Trim().ToString();
        else
            ucRep.filterRepNo = txtSearch.Text.Trim().ToString();
    }

    //
    //Search for TreeView selected node
    //
    protected void btnHidSearch_Click(object sender, EventArgs e)
    {
        ddlSearch.SelectedValue = "RepNo";
        hidSearch.Value = "node";
        BindRepData();
        upnlData.Update();
        if (ddlViewOption.SelectedValue == "Rep")
            ucRep.SelectedNode = hidRepNode.Value;
        else
            ucLocation.SelectedNode = hidRepNode.Value;
        upnlTree.Update();
    }
    #endregion

    //
    //Bind DropDownLists
    //
    private void BindRepDDL()
    {
        RepMasterBl.BindListControls(ddlLocation, "LocMaster (NoLock)", "LocName", "LocID", "1=1 ORDER BY LocID", "--Select--", "LocID + ' - ' + LocName as LocName");
        //RepMasterBl.BindListControls(ddlLocation, "LocMaster (NoLock)", "LocName", "LocID", "MaintainIMQtyInd='Y' ORDER BY LocID", "--Select--", "LocID +'-'+ LocName as LocName");
        MaintUtil.BindListControls(ddlStatus, "ListDesc", "ListValue", RepMasterBl.GetListDetails("SalesRepStatus"), "-- Select --");
        MaintUtil.BindListControls(ddlTerritory, "ListDesc", "ListValue", RepMasterBl.GetListDetails("SalesTerritory"), "-- Select --");
        RepMasterBl.BindListControls(ddlSalesOrganization, "LocMaster (NoLock)", "LocName", "LocID", "(MaintainIMQtyInd = 'Y') ORDER BY LocID", "--Select --", "LocID + ' - ' + LocName as LocName");
        RepMasterBl.BindListControls(ddlManager, "RepMaster (NoLock)", "RepName", "RepNo", "RepClass = 'O' AND RepStatus <> 'I' ORDER BY RepName", "--Select--", "RepNo + ' - ' + RepName as RepName");
        MaintUtil.BindListControls(ddlRegion, "ListDesc", "ListValue", RepMasterBl.GetListDetails("SalesRegionRpt"), "-- Select --");
        //bind ddlVendor (Outstanding)
        MaintUtil.BindListControls(ddlClass, "ListDesc", "ListValue", RepMasterBl.GetListDetails("SalesRepClass"), "-- Select --");
    }

    //
    //Clear user input controls
    //
    private void ClearControls()
    {
        //txtSearch.Text = ""; //Pete Added
        ddlLocation.SelectedIndex = 0;
        txtRepNo.Text = "";
        txtName.Text = "";
        ddlStatus.SelectedIndex = 0;
        txtPhone.Text = "";
        txtFax.Text = "";
        txtContact.Text = "";
        txtEmail.Text = "";
        ddlTerritory.SelectedIndex = 0;
        ddlSalesOrganization.SelectedIndex = 0;
        ddlManager.SelectedIndex = 0;
        ddlRegion.SelectedIndex = 0;
        //ddlVendorNo.SelectedIndex = 0;    //Clear after Vendor bind is added
        ddlClass.SelectedIndex = 0;
        txtNotes.Text = "";
        txtFromZip.Text = "";
        txtCommPct.Text = "";
        txtToZip.Text = "";
    }

    //
    //Display status messages 
    //
    private void DisplaStatusMessage(string message, string messageType)
    {
        lblMessage.Visible = true;
        if (messageType.ToLower() == "success")
        {
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = message;
        }
        else if (messageType.ToLower() == "fail")
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = message;
        }
        pnlStatus.Update();
    }

    //
    //Determine user security for this page
    //For RepMaster: ADMIN (W); MAINTENANCE (W); RepMasterMaint (W)
    //
    private void GetSecurity()
    {
        hidSecurity.Value = MaintUtil.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.RepMaster);
        if (hidSecurity.Value.ToString() == "")
            hidSecurity.Value = "Query";
        else
            hidSecurity.Value = "Full";

        //
        //If the page does not allow 'Query' only, change to 'None'
        //
        if (hidSecurity.Value.ToString() == "Query")
            hidSecurity.Value = "None";


        //Hard code the security value(s) until specific security is implemented
        //Toggle between Query, Full and None
        //hidSecurity.Value = "Query";
        //hidSecurity.Value = "Full"; //
        //hidSecurity.Value = "None";


        switch (hidSecurity.Value.ToString())
        {
            case "None":
                Response.Redirect("~/Common/ErrorPage/unauthorizedpage.aspx", true);
                break;
            case "Full":
                break;
        }
    }

    public void CheckLock()
    {

        //if (!string.IsNullOrEmpty(Session["RepID"].ToString()))
            MaintUtil.ReleaseLock("RepMaster", Session["RepID"].ToString(), "Rep", Session["RepLockStatus"].ToString());
        Session["RepID"] = hidRepMasterID.Value;
        DataTable dtLock = MaintUtil.SetLock("RepMaster", Session["RepID"].ToString(), "Rep");
        Session["RepLockStatus"] = dtLock.DefaultView.ToTable().Rows[0]["Status"].ToString();
        lockUser = dtLock.DefaultView.ToTable().Rows[0]["EntryID"].ToString();
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void ReleaseLock()
    {
        MaintUtil.ReleaseLock("RepMaster", Session["RepID"].ToString(), "Rep", Session["RepLockStatus"].ToString());
    }
}