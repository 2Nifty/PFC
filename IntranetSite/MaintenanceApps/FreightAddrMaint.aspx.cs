using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Web.Security;
using System.Threading;
using System.Reflection;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using PFC.Intranet;
using PFC.Intranet.Securitylayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.MaintenanceApps;

public partial class FreightAddrMaint : System.Web.UI.Page
{
    SqlConnection cnx;
    DataSet dsAddr, dsLoc;
    SqlDataReader drAddr;
    string strSQL, lockUser;
    string FromLocation, ToLocation, LTLRatePerLb, LineHaulRatePerLb,
           EntryID, EntryDt, ChangeID, ChangeDt, StatusCd;

    SalesReportUtils salesReportUtils = new SalesReportUtils();
    MaintenanceUtility freightAddr = new MaintenanceUtility();

    private const string
    SCRIPT_DOFOCUS =
        @"window.setTimeout('DoFocus()', 1);
            function DoFocus()
            {
                try {
                    document.getElementById('REQUEST_LASTFOCUS').focus();
                    document.getElementById('REQUEST_LASTFOCUS').select();
                } catch (ex) {}
            }";

    protected void Page_Load(object sender, EventArgs e)
    {
        cnx = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
        Ajax.Utility.RegisterTypeForAjax(typeof(FreightAddrMaint));
        //Response.Write(Environment.UserInteractive.ToString());

        lblMessage.Text = "";

        ScriptManager.RegisterStartupScript(
            this,
            typeof(FreightAddrMaint),
            "ScriptDoFocus",
            SCRIPT_DOFOCUS.Replace("REQUEST_LASTFOCUS", Request["hidFocus"]),
            true);

        if (!Page.IsPostBack)
        {
            Session["UserID"] = ((Session["UserID"] != null) ? Session["UserID"].ToString() : "01");
            Session["UserName"] = ((Session["UserName"] != null) ? Session["UserName"].ToString() : "intranet");
            Session["FAMLockStatus"] = "";
            Session["FAMRecID"] = "";

            GetSecurity();

            HookOnFocus(this.Page as Control);
            ddlFromLocSearch.Focus();
            hidFocus.Value = "ddlFromLocSearch";
            //hidCheckLoc.Value = "No";

            FillBranches();     // Fill The Branches in the Combo
            BindDataGrid();
        }
    }

    private void FillBranches()
    {
        //salesReportUtils.FillBranchesAndChainSession(Session["UserID"].ToString());
        //salesReportUtils.GetALLBranches(ddlFromLocSearch, Session["UserID"].ToString());
        //salesReportUtils.GetALLBranches(ddlToLocSearch, Session["UserID"].ToString());

        //salesReportUtils.GetALLBranches(ddlFromLocEdit, Session["UserID"].ToString());
        //ddlFromLocEdit.Items[0].Text = "Select From Location";
        //salesReportUtils.GetALLBranches(ddlToLocEdit, Session["UserID"].ToString());
        //ddlToLocEdit.Items[0].Text = "Select To Location";

        strSQL = "SELECT LocID as Location, LocID + ' - ' + LocName as [Desc] " +
                 "FROM LocMaster (NoLock) " +
                 "WHERE	MaintainIMQtyInd='Y' AND LocType='B' ORDER BY LocID";
        dsLoc = SqlHelper.ExecuteDataset(cnx, CommandType.Text, strSQL);

        //Fill From Location search field
        ddlFromLocSearch.DataSource = dsLoc;
        ddlFromLocSearch.DataValueField = dsLoc.Tables[0].Columns["Location"].ToString();
        ddlFromLocSearch.DataTextField = dsLoc.Tables[0].Columns["Desc"].ToString();
        ddlFromLocSearch.DataBind();
        ddlFromLocSearch.Items.Insert(0, new ListItem("All", "All"));

        //Fill To Location search field
        ddlToLocSearch.DataSource = dsLoc;
        ddlToLocSearch.DataValueField = dsLoc.Tables[0].Columns["Location"].ToString();
        ddlToLocSearch.DataTextField = dsLoc.Tables[0].Columns["Desc"].ToString();
        ddlToLocSearch.DataBind();
        ddlToLocSearch.Items.Insert(0, new ListItem("All", "All"));

        //Fill From Location edit field
        ddlFromLocEdit.DataSource = dsLoc;
        ddlFromLocEdit.DataValueField = dsLoc.Tables[0].Columns["Location"].ToString();
        ddlFromLocEdit.DataTextField = dsLoc.Tables[0].Columns["Desc"].ToString();
        ddlFromLocEdit.DataBind();
        ddlFromLocEdit.Items.Insert(0, new ListItem("Select From Location", "Select From Location"));

        //Fill To Location edit field
        ddlToLocEdit.DataSource = dsLoc;
        ddlToLocEdit.DataValueField = dsLoc.Tables[0].Columns["Location"].ToString();
        ddlToLocEdit.DataTextField = dsLoc.Tables[0].Columns["Desc"].ToString();
        ddlToLocEdit.DataBind();
        ddlToLocEdit.Items.Insert(0, new ListItem("Select To Location", "Select To Location"));

        cnx.Close();
    }

    private void BindDataGrid()
    {
        string SearchText = "";
        String sortExpression = (hidSort.Value == "") ? " FromLocation ASC, ToLocation ASC" : hidSort.Value;

        if (ddlFromLocSearch.SelectedIndex.ToString() != "0")
            SearchText = SearchText + "FromLocation = '" + ddlFromLocSearch.SelectedValue + "'";

        if (ddlToLocSearch.SelectedIndex.ToString() != "0")
        {
            if (SearchText != "")
                SearchText = SearchText + " AND ";
            SearchText = SearchText + "ToLocation = '" + ddlToLocSearch.SelectedValue + "'";
        }

        if (SearchText != "")
            SearchText = " WHERE " + SearchText;

        strSQL = "SELECT * FROM FreightAdder WITH (NOLOCK)" + SearchText;
        dsAddr = SqlHelper.ExecuteDataset(cnx, CommandType.Text, strSQL);
        dsAddr.Tables[0].DefaultView.Sort = sortExpression;
        dgFreight.DataSource = dsAddr.Tables[0].DefaultView.ToTable();
        dgFreight.DataBind();
        cnx.Close();
    }


    protected void btnSearch_Click(object sender, ImageClickEventArgs e)
    {
        BindDataGrid();
        UpdatePanels();
    }

    public void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
        freightAddr.ReleaseLock("FreightAdder", Session["FAMRecID"].ToString(), "FAM", Session["FAMLockStatus"].ToString());
        
        hidEditMode.Value = "Add";
        
        ContentTable.Visible = true;
        btnSave.Visible = true;
        btnCancel.Visible = true;

        ddlFromLocEdit.SelectedIndex = 0;
        ddlFromLocEdit.Enabled = true;
        lblFromAddress.Text = "";
        ddlToLocEdit.SelectedIndex = 0;
        ddlToLocEdit.Enabled = true;
        lblToAddress.Text = "";
        txtLTL.Text = "";
        txtLineHaul.Text = "";
        //hidCheckLoc.Value = "No";

        UpdatePanels();
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        //if (hidCheckLoc.Value == "Yes")
        if (ddlToLocEdit.SelectedIndex.ToString() != "0" && ddlFromLocEdit.SelectedIndex.ToString() != "0" && ddlToLocEdit.SelectedIndex.ToString() != ddlFromLocEdit.SelectedIndex.ToString())
        {
            if (string.IsNullOrEmpty(txtLTL.Text.ToString()))
                txtLTL.Text = "0";

            if (string.IsNullOrEmpty(txtLineHaul.Text.ToString()))
                txtLineHaul.Text = "0";

            switch (hidEditMode.Value)
            {
                case "Add":
                    InsertFreight();
                    break;
                case "Edit":
                    UpdateFreight();
                    freightAddr.ReleaseLock("FreightAdder", Session["FAMRecID"].ToString(), "FAM", Session["FAMLockStatus"].ToString());
                    ContentTable.Visible = false;
                    btnSave.Visible = false;
                    btnCancel.Visible = false;
                    break;
            }

            BindDataGrid();

            ddlFromLocEdit.SelectedIndex = 0;
            lblFromAddress.Text = "";
            ddlToLocEdit.SelectedIndex = 0;
            lblToAddress.Text = "";
            txtLTL.Text = "";
            txtLineHaul.Text = "";
            //hidCheckLoc.Value = "No";

            UpdatePanels();
        }
        else
            DisplaStatusMessage("Invalid Location", "fail");
    }

    protected void btnCancel_Click(object sender, ImageClickEventArgs e)
    {
        freightAddr.ReleaseLock("FreightAdder", Session["FAMRecID"].ToString(), "FAM", Session["FAMLockStatus"].ToString());
        ContentTable.Visible = false;
        btnSave.Visible = false;
        btnCancel.Visible = false;
        UpdatePanels();
    }

    private void InsertFreight()
    {
        //Check if record already exists
        strSQL = "SELECT * FROM FreightAdder WITH (NOLOCK) WHERE FromLocation = '" + ddlFromLocEdit.SelectedValue.ToString() + "' AND ToLocation = '" + ddlToLocEdit.SelectedValue.ToString() + "'";
        drAddr = SqlHelper.ExecuteReader(cnx, CommandType.Text, strSQL);
        
        if (drAddr.HasRows)
        {
            cnx.Close();
            DisplaStatusMessage("Already on file", "fail");
        }
        else
        {
            cnx.Close();
            //INSERT the new record
            strSQL = "INSERT INTO FreightAdder (FromLocation, ToLocation, FromZipCd, ToZipCd, LTLRatePerLb, LineHaulRatePerLb, EntryID, EntryDt) VALUES ('" +
                        ddlFromLocEdit.SelectedValue.ToString() + "', '" + ddlToLocEdit.SelectedValue.ToString() + "', '" +
                        hidFromZipCd.Value.ToString() + "', '" + hidToZipCd.Value.ToString() + "', " +
                        txtLTL.Text.ToString().Trim().Replace("$", "").Replace(",", "") + ", " +
                        txtLineHaul.Text.ToString().Trim().Replace("$", "").Replace(",", "") + ", '" +
                        Session["UserName"].ToString().Trim() + "', " + "GETDATE())";
            SqlHelper.ExecuteReader(cnx, CommandType.Text, strSQL);
            cnx.Close();
            DisplaStatusMessage("Record Added", "success");
        }
    }

    private void UpdateFreight()
    {
        //UPDATE the selected record
        strSQL = "UPDATE FreightAdder SET LTLRatePerLb = " + txtLTL.Text.ToString().Trim().Replace("$", "").Replace(",", "") + ", " +
                                            "LineHaulRatePerLb = " + txtLineHaul.Text.ToString().Trim().Replace("$", "").Replace(",", "") + ", " +
                                            "ChangeID = '" + Session["UserName"].ToString().Trim() + "', ChangeDt = GETDATE() " +
                                            "WHERE pFreightAdderId = " + Session["FAMRecID"].ToString();
        SqlHelper.ExecuteReader(cnx, CommandType.Text, strSQL);
        cnx.Close();
        DisplaStatusMessage("Record Updated", "success");
    }
    
    protected void dgFreight_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        hidRecID.Value = e.CommandArgument.ToString().Trim();

        if (e.CommandName == "Edit")
        {
            CheckLock();
            if (Session["FAMLockStatus"].ToString() == "L")
            {
                ScriptManager.RegisterClientScriptBlock(pnlFreightGrid, typeof(UpdatePanel), "Script", "alert('Record Locked By " + lockUser.ToString() + "');", true);
                ContentTable.Visible = false;
                btnSave.Visible = false;
                btnCancel.Visible = false;
                UpdatePanels();
            }
            else
            {
                //DisplaStatusMessage("NOT LOCKED - " + lockUser.ToString(), "success");

                hidEditMode.Value = "Edit";
                //hidCheckLoc.Value = "Yes";

                ContentTable.Visible = true;
                btnSave.Visible = true;
                btnCancel.Visible = true;

                //ddlFromLocEdit.SelectedIndex = Convert.ToInt16(e.Item.Cells[1].Text.ToString().Trim());
                ddlFromLocEdit.SelectedValue = e.Item.Cells[1].Text.ToString().Trim();
                FromLocAddress();
                ddlFromLocEdit.Enabled = false;

                //ddlToLocEdit.SelectedIndex = Convert.ToInt16(e.Item.Cells[2].Text.ToString().Trim());
                ddlToLocEdit.SelectedValue = e.Item.Cells[2].Text.ToString().Trim();
                ToLocAddress();
                ddlToLocEdit.Enabled = false;

                if (e.Item.Cells[5].Text.ToString().Trim() == "&nbsp;")
                    txtLTL.Text = String.Format("{0:$#,0.000000}", 0);
                else
                    txtLTL.Text = e.Item.Cells[5].Text.ToString().Trim();

                if (e.Item.Cells[6].Text.ToString().Trim() == "&nbsp;")
                    txtLineHaul.Text = String.Format("{0:$#,0.000000}", 0);
                else
                    txtLineHaul.Text = e.Item.Cells[6].Text.ToString().Trim();

                UpdatePanels();
            }
        }

        if (e.CommandName == "Delete")
        {
            if (hidDelConf.Value == "true")
            {
                CheckLock();
                if (Session["FAMLockStatus"].ToString() == "L")
                    ScriptManager.RegisterClientScriptBlock(pnlFreightGrid, typeof(UpdatePanel), "Script", "alert('Record Locked By " + lockUser.ToString() + "');", true);
                else
                {
                    //DisplaStatusMessage("NOT LOCKED - " + lockUser.ToString(), "success");

                    //DELETE the selected record
                    strSQL = "DELETE FROM FreightAdder WHERE pFreightAdderId = " + Session["FAMRecID"].ToString();
                    SqlHelper.ExecuteReader(cnx, CommandType.Text, strSQL);
                    cnx.Close();
                    DisplaStatusMessage("Record Deleted", "success");

                    BindDataGrid();
                }
                freightAddr.ReleaseLock("FreightAdder", Session["FAMRecID"].ToString(), "FAM", Session["FAMLockStatus"].ToString());
                ContentTable.Visible = false;
                btnSave.Visible = false;
                btnCancel.Visible = false;
                UpdatePanels();
            }
        }
    }

    protected void dgFreight_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            if (hidSecurity.Value.ToString() == "Full")
            {
                Label lblNoAction = e.Item.FindControl("lblNoAction") as Label;
                lblNoAction.Visible = false;

                LinkButton lnkEdit = e.Item.FindControl("lnkEdit") as LinkButton;
                lnkEdit.Visible = true;

                LinkButton lnkDelete = e.Item.FindControl("lnkDelete") as LinkButton;
                lnkDelete.Visible = true;
            }
            else
            {
                Label lblNoAction = e.Item.FindControl("lblNoAction") as Label;
                lblNoAction.Visible = true;

                LinkButton lnkEdit = e.Item.FindControl("lnkEdit") as LinkButton;
                lnkEdit.Visible = false;

                LinkButton lnkDelete = e.Item.FindControl("lnkDelete") as LinkButton;
                lnkDelete.Visible = false;
            }
        }
    }

    protected void dgFreight_SortCommand(object source, DataGridSortCommandEventArgs e)
    {
        if (hidSort.Attributes["sortType"] != null)
        {
            if (hidSort.Attributes["sortType"].ToString() == "ASC")
                hidSort.Attributes["sortType"] = "DESC";
            else
                hidSort.Attributes["sortType"] = "ASC";
        }
        else
            hidSort.Attributes.Add("sortType", "ASC");

        hidSort.Value = e.SortExpression + " " + hidSort.Attributes["sortType"].ToString();
        BindDataGrid();
    }

    protected void ddlFromLocEdit_SelectedIndexChanged(object sender, EventArgs e)
    {
        //hidCheckLoc.Value = "No";

        if (ddlFromLocEdit.SelectedIndex.ToString() != "0")
        {
            FromLocAddress();
            UpdatePanels();

            //if (ddlToLocEdit.SelectedIndex.ToString() != "0" && ddlToLocEdit.SelectedIndex.ToString() != ddlFromLocEdit.SelectedIndex.ToString())
            //    hidCheckLoc.Value = "Yes";
        }
        else
        {
            lblFromAddress.Text = "";
        }
    }

    protected void ddlToLocEdit_SelectedIndexChanged(object sender, EventArgs e)
    {
        //hidCheckLoc.Value = "No";

        if (ddlToLocEdit.SelectedIndex.ToString() != "0")
        {
            ToLocAddress();
            UpdatePanels();

            //if (ddlFromLocEdit.SelectedIndex.ToString() != "0" && ddlFromLocEdit.SelectedIndex.ToString() != ddlToLocEdit.SelectedIndex.ToString())
            //    hidCheckLoc.Value = "Yes";
        }
        else
        {
            lblToAddress.Text = "";
        }
    }

    protected void FromLocAddress()
    {
        LocAddress(ddlFromLocEdit.SelectedValue);

        lblFromAddress.Text = dsLoc.Tables[0].DefaultView.ToTable().Rows[0]["LocAdress1"].ToString() + " - " +
            dsLoc.Tables[0].DefaultView.ToTable().Rows[0]["LocCity"].ToString() + ", " +
            dsLoc.Tables[0].DefaultView.ToTable().Rows[0]["LocState"].ToString() + "  " +
            dsLoc.Tables[0].DefaultView.ToTable().Rows[0]["LocPostCode"].ToString();
        hidFromZipCd.Value = dsLoc.Tables[0].DefaultView.ToTable().Rows[0]["LocPostCode"].ToString();
    }

    protected void ToLocAddress()
    {
        LocAddress(ddlToLocEdit.SelectedValue);

        lblToAddress.Text = dsLoc.Tables[0].DefaultView.ToTable().Rows[0]["LocAdress1"].ToString() + " - " +
            dsLoc.Tables[0].DefaultView.ToTable().Rows[0]["LocCity"].ToString() + ", " +
            dsLoc.Tables[0].DefaultView.ToTable().Rows[0]["LocState"].ToString() + "  " +
            dsLoc.Tables[0].DefaultView.ToTable().Rows[0]["LocPostCode"].ToString();
        hidToZipCd.Value = dsLoc.Tables[0].DefaultView.ToTable().Rows[0]["LocPostCode"].ToString();
    }

    protected void LocAddress(string Loc)
    {
        strSQL = "SELECT LocAdress1, LocCity, LocState, LocPostCode FROM LocMaster WITH (NOLOCK) WHERE LocID = '" + Loc.ToString() + "'";
        dsLoc = SqlHelper.ExecuteDataset(cnx, CommandType.Text, strSQL);
        cnx.Close();
    }

    protected void txtLTL_TextChanged(object sender, EventArgs e)
    {
        txtLTL.Text = ValidateCurrency(txtLTL.Text.ToString());
        
        if (txtLTL.Text == "NotNum")
        {
            txtLTL.Text = "";
            hidFocus.Value = "txtLTL";
        }
        else
        {
            txtLTL.Text = String.Format("{0:$#,0.000000}", Convert.ToDecimal(txtLTL.Text));
            hidFocus.Value = "txtLineHaul";
        }
    }

    protected void txtLineHaul_TextChanged(object sender, EventArgs e)
    {
        txtLineHaul.Text = ValidateCurrency(txtLineHaul.Text.ToString());

        if (txtLineHaul.Text == "NotNum")
        {
            txtLineHaul.Text = "";
            hidFocus.Value = "txtLineHaul";
        }
        else
        {
            txtLineHaul.Text = String.Format("{0:$#,0.000000}", Convert.ToDecimal(txtLineHaul.Text));
            hidFocus.Value = "btnSearch";
        }
    }

    private string ValidateCurrency(string fld)
    {
        string tValue = fld.ToString().Trim();

        tValue = tValue.ToString().Trim().Replace("$", "");
        tValue = tValue.ToString().Trim().Replace(",", "");
        tValue = tValue.ToString().Trim().Replace(" ", "");
        
        if (tValue.ToString() == "")
        {
            tValue = "0";
            return tValue.ToString();
        }

        if (System.Text.RegularExpressions.Regex.IsMatch(tValue.ToString(), @"[^-.0-9]"))
        {
            DisplaStatusMessage("Entry must be numeric", "fail");
            tValue = "NotNum";
        }

        return tValue.ToString();
    }

    private void UpdatePanels()
    {
        pnlSearch.Update();
        pnlContent.Update();
        pnlLink.Update();
        pnlFreightGrid.Update();
        pnlProgress.Update();
    }

    public void CheckLock()
    {
        freightAddr.ReleaseLock("FreightAdder", Session["FAMRecID"].ToString(), "FAM", Session["FAMLockStatus"].ToString());
        Session["FAMRecID"] = hidRecID.Value;
        DataTable dtLock = freightAddr.SetLock("FreightAdder", Session["FAMRecID"].ToString(), "FAM");
        Session["FAMLockStatus"] = dtLock.DefaultView.ToTable().Rows[0]["Status"].ToString();
        lockUser = dtLock.DefaultView.ToTable().Rows[0]["EntryID"].ToString();
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void ReleaseLock()
    {
        freightAddr.ReleaseLock("FreightAdder", Session["FAMRecID"].ToString(), "FAM", Session["FAMLockStatus"].ToString());
    }

    private void GetSecurity()
    {
        hidSecurity.Value = freightAddr.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.FreightAddr);
        if (hidSecurity.Value.ToString() == "")
            hidSecurity.Value = "Query";
        else
            hidSecurity.Value = "Full";

        //Response.Write(Session["UserName"].ToString());
        //Response.Write("<br>");
        //Response.Write(hidSecurity.Value.ToString());

        switch (hidSecurity.Value.ToString())
        {
            case "None":
                Response.Redirect("~/Common/ErrorPage/unauthorizedpage.aspx", true);
            break;
            case "Full":
                btnAdd.Visible = true;
            break;
        }
    }

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
        pnlProgress.Update();
    }

    private void HookOnFocus(Control CurrentControl)
    {
        if ((CurrentControl is TextBox) || (CurrentControl is DropDownList) || (CurrentControl is ListBox) || (CurrentControl is ImageButton))
            (CurrentControl as WebControl).Attributes.Add("onfocus", "try{document.getElementById('hidFocus').value=this.id} catch(e) {}");

        if (CurrentControl.HasControls())
            foreach (Control CurrentChildControl in CurrentControl.Controls)
                HookOnFocus(CurrentChildControl);
    }
}
