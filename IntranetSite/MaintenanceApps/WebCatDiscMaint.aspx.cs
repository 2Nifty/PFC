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

public partial class WebCatDiscMaint : System.Web.UI.Page
{
    SqlConnection cnWebCatDisc, cnCat, cnCVC;
    DataSet dsWebCatDisc, dsCat, dsCVC;
    Boolean DupRecord;
    string strSQL, lockUser;

    MaintenanceUtility WebCatDisc = new MaintenanceUtility();

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
        cnWebCatDisc = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
        cnCat = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
        cnCVC = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);

        Ajax.Utility.RegisterTypeForAjax(typeof(WebCatDiscMaint));
        //Response.Write(Environment.UserInteractive.ToString());

        ScriptManager.RegisterStartupScript(
            this,
            typeof(WebCatDiscMaint),
            "ScriptDoFocus",
            SCRIPT_DOFOCUS.Replace("REQUEST_LASTFOCUS", Request["hidFocus"]),
            true);

        if (!Page.IsPostBack)
        {
            Session["SessionID"] = ((Session["SessionID"] != null) ? Session["SessionID"].ToString() : "null");
            Session["UserID"] = ((Session["UserID"] != null) ? Session["UserID"].ToString() : "01");
            Session["UserName"] = ((Session["UserName"] != null) ? Session["UserName"].ToString() : "intranet");
            Session["WCDLockStatus"] = "";
            Session["WCDRecID"] = "";

            GetSecurity();

            HookOnFocus(this.Page as Control);

            FillCVC();
            BindDataGrid();
        }

        lblMessage.Text = "";
    }

    private void FillCVC()
    {
        strSQL = "SELECT AppOptionValue as CVC, AppOptionValue + ' - ' + AppOptionTypeDesc as CVCDesc " +
                 "FROM   AppPref (NoLock) " +
                 "WHERE  ApplicationCd = 'vlcd' AND AppOptionType = 'VelocityCode' ORDER BY AppOptionValue";
        dsCVC = SqlHelper.ExecuteDataset(cnCVC, CommandType.Text, strSQL);

        Session["CVC"] = dsCVC;

        ddlItemCVC.DataSource = dsCVC;
        ddlItemCVC.DataValueField = dsCVC.Tables[0].Columns["CVC"].ToString();
        ddlItemCVC.DataTextField = dsCVC.Tables[0].Columns["CVCDesc"].ToString();
        ddlItemCVC.DataBind();
        ddlItemCVC.Items.Insert(0, new ListItem("Select CVC", "Select CVC"));
        ddlItemCVC.Items.Add(new ListItem("All", "All"));
        cnCVC.Close();
    }

    private void BindDataGrid()
    {
        String sortExpression = (hidSort.Value == "") ? " Category ASC, ItemCVC ASC" : hidSort.Value;

        strSQL = "SELECT *, DiscountPercent / 100 AS GridDiscPct FROM WebCategoryDiscount (NoLock)";
        //strSQL = "SELECT *, DiscountPercent / 100 AS GridDiscPct FROM WebCategoryDiscount (NoLock)";
        if (chkDelRec.Checked == false)
            strSQL = strSQL + " WHERE DeleteDt = '' OR DeleteDt is null";
        strSQL = strSQL + " ORDER BY " + sortExpression;
        dsWebCatDisc = SqlHelper.ExecuteDataset(cnWebCatDisc, CommandType.Text, strSQL);
        dsWebCatDisc.Tables[0].DefaultView.Sort = sortExpression;
        dgWebCatDisc.DataSource = dsWebCatDisc.Tables[0].DefaultView.ToTable();
        dgWebCatDisc.DataBind();
        cnWebCatDisc.Close();

        Pager1.InitPager(dgWebCatDisc, Convert.ToInt16(hidPageSize.Value));
        pnlCatGrid.Update();
    }

    protected void chkDelRec_CheckedChanged(object sender, EventArgs e)
    {
        BindDataGrid();
        UpdatePanels();
    }

    public void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
        WebCatDisc.ReleaseLock("WebCategoryDiscount", Session["WCDRecID"].ToString(), "WCD", Session["WCDLockStatus"].ToString());

        hidEditMode.Value = "Add";

        divdatagrid.Attributes["style"] = "overflow: auto; width: 1020px; position: relative; top: 0px; left: 0px; height: 287px; border: 0px solid; vertical-align: top;";
        //dgWebCatDisc.PageSize = 10;
        //hidPageSize.Value = "10";
        //BindDataGrid();
        //pnlPager.Update();

        ContentTable.Visible = true;
        btnSave.Visible = true;
        btnCancel.Visible = true;

        txtCat.Text = "";
        txtCat.Enabled = true;
        lblCatDesc.Text = "";
        ddlItemCVC.SelectedIndex = 0;
        ddlItemCVC.Enabled = true;
        txtDisc.Text = "";
        dtEffectiveStart.SelectedDate = "";
        dtEffectiveEnd.SelectedDate = "";

        txtCat.Focus();
        hidFocus.Value = "txtCat";

        UpdatePanels();
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        if (hidEditMode.Value == "Add" && lblCatDesc.Text == "Invalid Category")
        {
            DisplaStatusMessage("Please enter a valid Category", "fail");
            return;
        }

        if (hidEditMode.Value == "Add" && ddlItemCVC.SelectedIndex.ToString() == "0")
        {
            DisplaStatusMessage("Please select a valid Item CVC", "fail");
            return;
        }

        if (string.IsNullOrEmpty(txtDisc.Text.ToString()))
            txtDisc.Text = "0";

        try
        {
            Convert.ToDateTime(dtEffectiveStart.SelectedDate.ToString());
        }
        catch (Exception ex)
        {
            dtEffectiveStart.SelectedDate = "";
        }

        if (string.IsNullOrEmpty(dtEffectiveStart.SelectedDate.ToString()))
        {
            DisplaStatusMessage("Please select a valid Start Date", "fail");
            return;
        }

        try
        {
            Convert.ToDateTime(dtEffectiveEnd.SelectedDate.ToString());
        }
        catch (Exception ex)
        {
            dtEffectiveEnd.SelectedDate = "";
        }

        if (string.IsNullOrEmpty(dtEffectiveEnd.SelectedDate.ToString()))
        {
            DisplaStatusMessage("Please select a valid End Date", "fail");
            return;
        }

        switch (hidEditMode.Value)
        {
            case "Add":
                InsertCat();
                break;
            case "Edit":
                UpdateCat();
                WebCatDisc.ReleaseLock("WebCategoryDiscount", Session["WCDRecID"].ToString(), "WCD", Session["WCDLockStatus"].ToString());
                divdatagrid.Attributes["style"] = "overflow: auto; width: 1020px; position: relative; top: 0px; left: 0px; height: 492px; border: 0px solid; vertical-align: top;";
                //dgWebCatDisc.PageSize = 18;
                //hidPageSize.Value = "18";
                //BindDataGrid();
                //pnlPager.Update();

                ContentTable.Visible = false;
                btnSave.Visible = false;
                btnCancel.Visible = false;
                break;
        }

        BindDataGrid();

        if ((hidEditMode.Value == "Add" && DupRecord == false) || (hidEditMode.Value == "Edit"))
        {
            txtCat.Text = "";
            txtCat.Enabled = true;
            lblCatDesc.Text = "";
            ddlItemCVC.SelectedIndex = 0;
            ddlItemCVC.Enabled = true;
            txtDisc.Text = "";
            dtEffectiveStart.SelectedDate = "";
            dtEffectiveEnd.SelectedDate = "";
        }

        UpdatePanels();
    }

    protected void btnCancel_Click(object sender, ImageClickEventArgs e)
    {
        WebCatDisc.ReleaseLock("WebCategoryDiscount", Session["WCDRecID"].ToString(), "WCD", Session["WCDLockStatus"].ToString());
        divdatagrid.Attributes["style"] = "overflow: auto; width: 1020px; position: relative; top: 0px; left: 0px; height: 492px; border: 0px solid; vertical-align: top;";
        //dgWebCatDisc.PageSize = 18;
        //hidPageSize.Value = "18";
        //BindDataGrid();
        //pnlPager.Update();
        
        ContentTable.Visible = false;
        btnSave.Visible = false;
        btnCancel.Visible = false;
        UpdatePanels();
    }

    private void InsertCat()
    {
        DupRecord = CheckDup();
        if (DupRecord == true)
            DuplicateRecord();
        else
            if (ddlItemCVC.SelectedValue.ToString() == "All")
            {
                dsCVC = (DataSet)Session["CVC"];
                foreach (DataRow CVCRow in dsCVC.Tables[0].Rows)
                {
                    string AddRec = "true";

                    foreach (DataRow Row in dsWebCatDisc.Tables[0].Rows)
                        if (CVCRow["CVC"].ToString() == Row["ItemCVC"].ToString())
                            AddRec = "false";

                    if (AddRec == "true")
                    {
                        //INSERT the new record
                        strSQL = "INSERT INTO WebCategoryDiscount (Category, ItemCVC, DiscountPercent, EffectiveStartDt, EffectiveEndDt, EntryID, EntryDt) VALUES ('" +
                                    txtCat.Text.ToString() + "', '" + CVCRow["CVC"].ToString() + "', '" + txtDisc.Text.ToString() + "', '" +
                                    dtEffectiveStart.SelectedDate.ToString() + "', '" + dtEffectiveEnd.SelectedDate.ToString() + "', '" +
                                    Session["UserName"].ToString().Trim() + "', " + "GETDATE())";
                        SqlHelper.ExecuteReader(cnWebCatDisc, CommandType.Text, strSQL);
                        cnWebCatDisc.Close();
                        DisplaStatusMessage("Record(s) Added", "success");
                    }
                }
            }
            else
            {
                //INSERT the new record
                strSQL = "INSERT INTO WebCategoryDiscount (Category, ItemCVC, DiscountPercent, EffectiveStartDt, EffectiveEndDt, EntryID, EntryDt) VALUES ('" +
                            txtCat.Text.ToString() + "', '" + ddlItemCVC.SelectedValue.ToString() + "', '" + txtDisc.Text.ToString() + "', '" +
                            dtEffectiveStart.SelectedDate.ToString() + "', '" + dtEffectiveEnd.SelectedDate.ToString() + "', '" +
                            Session["UserName"].ToString().Trim() + "', " + "GETDATE())";
                SqlHelper.ExecuteReader(cnWebCatDisc, CommandType.Text, strSQL);
                cnWebCatDisc.Close();
                DisplaStatusMessage("Record Added", "success");
            }

        txtCat.Focus();
        hidFocus.Value = "txtCat";
    }

    private void UpdateCat()
    {
        //UPDATE the selected record
        strSQL = "UPDATE WebCategoryDiscount SET DiscountPercent = '" + txtDisc.Text.ToString().Trim() + "', " +
                                                "EffectiveStartDt = '" + dtEffectiveStart.SelectedDate.ToString().Trim() + "', " +
                                                "EffectiveEndDt = '" + dtEffectiveEnd.SelectedDate.ToString().Trim() + "', " +
                                                "ChangeID = '" + Session["UserName"].ToString().Trim() + "', ChangeDt = GETDATE()" +
                 "WHERE pWebCategoryDiscID = " + Session["WCDRecID"].ToString();
        SqlHelper.ExecuteReader(cnWebCatDisc, CommandType.Text, strSQL);
        cnWebCatDisc.Close();
        DisplaStatusMessage("Record Updated", "success");
    }

    protected void dgWebCatDisc_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        hidRecID.Value = e.CommandArgument.ToString().Trim();

        if (e.CommandName == "Edit")
        {
            CheckLock();
            if (Session["WCDLockStatus"].ToString() == "L")
            {
                ScriptManager.RegisterClientScriptBlock(pnlCatGrid, typeof(UpdatePanel), "Script", "alert('Record Locked By " + lockUser.ToString() + "');", true);
                divdatagrid.Attributes["style"] = "overflow: auto; width: 1020px; position: relative; top: 0px; left: 0px; height: 492px; border: 0px solid; vertical-align: top;";
                //dgWebCatDisc.PageSize = 18;
                //hidPageSize.Value = "18";
                //BindDataGrid();
                //pnlPager.Update();

                ContentTable.Visible = false;
                btnSave.Visible = false;
                btnCancel.Visible = false;
                UpdatePanels();
            }
            else
            {
                //DisplaStatusMessage("NOT LOCKED - " + lockUser.ToString(), "success");

                hidEditMode.Value = "Edit";

                divdatagrid.Attributes["style"] = "overflow: auto; width: 1020px; position: relative; top: 0px; left: 0px; height: 287px; border: 0px solid; vertical-align: top;";
                //dgWebCatDisc.PageSize = 10;
                //hidPageSize.Value = "10";
                //BindDataGrid();
                //pnlPager.Update();
                
                ContentTable.Visible = true;
                btnSave.Visible = true;
                btnCancel.Visible = true;

                txtCat.Text = e.Item.Cells[1].Text.ToString().Trim();
                txtCat.Enabled = false;
                GetCatDesc();

                ddlItemCVC.SelectedValue = e.Item.Cells[2].Text.ToString();
                ddlItemCVC.Enabled = false;

                txtDisc.Text = e.Item.Cells[3].Text.ToString().Trim().Replace("%", "");

                if (e.Item.Cells[4].Text.ToString().Trim() == "&nbsp;")
                    dtEffectiveStart.SelectedDate = "";
                else
                    dtEffectiveStart.SelectedDate = e.Item.Cells[4].Text.ToString().Trim();

                if (e.Item.Cells[5].Text.ToString().Trim() == "&nbsp;")
                    dtEffectiveEnd.SelectedDate = "";
                else
                    dtEffectiveEnd.SelectedDate = e.Item.Cells[5].Text.ToString().Trim();

                UpdatePanels();
            }
        }

        if (e.CommandName == "Delete")
        {
            if (hidDelConf.Value == "true")
            {
                CheckLock();
                if (Session["WCDLockStatus"].ToString() == "L")
                    ScriptManager.RegisterClientScriptBlock(pnlCatGrid, typeof(UpdatePanel), "Script", "alert('Record Locked By " + lockUser.ToString() + "');", true);
                else
                {
                    //DisplaStatusMessage("NOT LOCKED - " + lockUser.ToString(), "success");

                    //DELETE the selected record
                    //strSQL = "DELETE FROM WebCategoryDiscount WHERE pWebCategoryDiscID = " + Session["WCDRecID"].ToString();
                    strSQL = "UPDATE WebCategoryDiscount " +
                             "SET ChangeID = '" + Session["UserName"].ToString().Trim() + "', ChangeDt = GETDATE(), DeleteDt = GETDATE() " +
                             "WHERE pWebCategoryDiscID = " + Session["WCDRecID"].ToString();
                    SqlHelper.ExecuteReader(cnWebCatDisc, CommandType.Text, strSQL);              
                    cnWebCatDisc.Close();
                    DisplaStatusMessage("Record Deleted", "success");

                    BindDataGrid();
                }
                WebCatDisc.ReleaseLock("WebCategoryDiscount", Session["WCDRecID"].ToString(), "WCD", Session["WCDLockStatus"].ToString());
                divdatagrid.Attributes["style"] = "overflow: auto; width: 1020px; position: relative; top: 0px; left: 0px; height: 492px; border: 0px solid; vertical-align: top;";
                //dgWebCatDisc.PageSize = 18;
                //hidPageSize.Value = "18";
                //BindDataGrid();
                //pnlPager.Update();

                ContentTable.Visible = false;
                btnSave.Visible = false;
                btnCancel.Visible = false;
                UpdatePanels();
            }
        }
    }

    protected void dgWebCatDisc_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            if (hidSecurity.Value.ToString() == "Full" && (string.IsNullOrEmpty(e.Item.Cells[10].Text.ToString()) || e.Item.Cells[10].Text.ToString() == "&nbsp;"))
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

    protected void dgWebCatDisc_SortCommand(object source, DataGridSortCommandEventArgs e)
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

    protected void txtCat_TextChanged(object sender, EventArgs e)
    {
        ddlItemCVC.SelectedIndex = 0;
        GetCatDesc();
    }

    private void GetCatDesc()
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        lblCatDesc.Text = "";
        txtCat.Text = txtCat.Text.ToString().PadLeft(5, '0');

        strSQL = "SELECT Category, CatalogDesc FROM ItemCategory (NoLock) WHERE Category = '" + txtCat.Text.ToString() + "'";
        dsCat = SqlHelper.ExecuteDataset(cnCat, CommandType.Text, strSQL);

        if (dsCat.Tables[0].Rows.Count > 0)
            lblCatDesc.Text = dsCat.Tables[0].DefaultView.ToTable().Rows[0]["CatalogDesc"].ToString();
        else
        {
            DisplaStatusMessage("Invalid Category", "fail");
            lblCatDesc.Text = "Invalid Category";
            txtCat.Focus();
            hidFocus.Value = "txtCat";
        }

        cnCat.Close();
    }

    protected void ddlItemCVC_SelectedIndexChanged(object sender, EventArgs e)
    {
        DupRecord = CheckDup();
        if (DupRecord == true)
            DuplicateRecord();
    }

    protected void txtDisc_TextChanged(object sender, EventArgs e)
    {
        txtDisc.Text = ValidatePercent(txtDisc.Text.ToString());

        if (txtDisc.Text == "NotNum")
        {
            txtDisc.Text = "";
            hidFocus.Value = "txtDisc";
        }
        else
        {
            txtDisc.Text = String.Format("{0:0.00%}", Convert.ToDecimal(txtDisc.Text) / 100).ToString().Trim().Replace("%", "");
            hidFocus.Value = "dtEffectiveStart";
        }

        if (hidEditMode.Value == "Edit")
        {
            txtCat.Enabled = false;
            ddlItemCVC.Enabled = false;
        }
    }

    private Boolean CheckDup()
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        //Check if record already exists
        strSQL = "SELECT * FROM WebCategoryDiscount (NoLock) WHERE (DeleteDt = '' OR DeleteDt is null) AND Category = '" + txtCat.Text.ToString();
        if (ddlItemCVC.SelectedValue != "All")
            strSQL = strSQL + "' AND ItemCVC = '" + ddlItemCVC.SelectedValue.ToString();
        strSQL = strSQL + "'";
        dsWebCatDisc = SqlHelper.ExecuteDataset(cnWebCatDisc, CommandType.Text, strSQL);

        if ((ddlItemCVC.SelectedValue == "All" && dsWebCatDisc.Tables[0].DefaultView.ToTable().Rows.Count == ddlItemCVC.Items.Count - 2) ||
            (ddlItemCVC.SelectedValue != "All" && dsWebCatDisc.Tables[0].DefaultView.ToTable().Rows.Count > 0))
        {
            //Session["WebCatDisc"] = dsWebCatDisc;
            cnWebCatDisc.Close();
            return true;
        }
        else
        {
            cnWebCatDisc.Close();
            return false;
        }
    }

    private void DuplicateRecord()
    {
        string LockID = "None";
        string StartDt = "", EndDt = "";
        if (ddlItemCVC.SelectedValue != "All")
        {
            hidRecID.Value = dsWebCatDisc.Tables[0].DefaultView.ToTable().Rows[0]["pWebCategoryDiscID"].ToString();
            CheckLock();
            if (Session["WCDLockStatus"].ToString() == "L")
                LockID = lockUser.ToString();
        }

        if (!string.IsNullOrEmpty(dsWebCatDisc.Tables[0].DefaultView.ToTable().Rows[0]["EffectiveStartDt"].ToString()))
            StartDt = Convert.ToDateTime(dsWebCatDisc.Tables[0].DefaultView.ToTable().Rows[0]["EffectiveStartDt"].ToString()).ToShortDateString().ToString();

        if (!string.IsNullOrEmpty(dsWebCatDisc.Tables[0].DefaultView.ToTable().Rows[0]["EffectiveEndDt"].ToString()))
            EndDt = Convert.ToDateTime(dsWebCatDisc.Tables[0].DefaultView.ToTable().Rows[0]["EffectiveEndDt"].ToString()).ToShortDateString().ToString();

        ScriptManager.RegisterClientScriptBlock(pnlWebCatDsc, typeof(UpdatePanel), "Script",
            "<script language='javascript'>EditConf('" +
                ddlItemCVC.SelectedValue.ToString() + "', '" +
                String.Format("{0:0.00%}", Convert.ToDecimal(dsWebCatDisc.Tables[0].DefaultView.ToTable().Rows[0]["DiscountPercent"].ToString()) / 100).ToString().Trim().Replace("%", "") + "', '" +
                StartDt.ToString() + "', '" +
                dtEffectiveStart.FindControl("textBox").ClientID + "', '" +
                EndDt.ToString() + "', '" +
                dtEffectiveEnd.FindControl("textBox").ClientID + "', '" +
                LockID.ToString() + "');" +
            "</script>", false);
    }

    private string ValidatePercent(string fld)
    {
        lblMessage.Text = "";
        pnlProgress.Update();

        string tValue = fld.ToString().Trim();
        tValue = tValue.ToString().Trim().Replace("%", "");
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
        pnlTop.Update();
        pnlContent.Update();
        pnlLink.Update();
        pnlCatGrid.Update();
        pnlProgress.Update();
    }

    public void CheckLock()
    {
        //if (!string.IsNullOrEmpty(Session["WCDRecID"].ToString()))
            WebCatDisc.ReleaseLock("WebCategoryDiscount", Session["WCDRecID"].ToString(), "WCD", Session["WCDLockStatus"].ToString());
        Session["WCDRecID"] = hidRecID.Value;
        DataTable dtLock = WebCatDisc.SetLock("WebCategoryDiscount", Session["WCDRecID"].ToString(), "WCD");
        Session["WCDLockStatus"] = dtLock.DefaultView.ToTable().Rows[0]["Status"].ToString();
        lockUser = dtLock.DefaultView.ToTable().Rows[0]["EntryID"].ToString();
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void ReleaseLock()
    {
        WebCatDisc.ReleaseLock("WebCategoryDiscount", Session["WCDRecID"].ToString(), "WCD", Session["WCDLockStatus"].ToString());
    }

    private void GetSecurity()
    {
        hidSecurity.Value = WebCatDisc.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.WebCatDisc);
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

    protected void ExportRpt_Click(object sender, ImageClickEventArgs e)
    {
        BindDataGrid();

        char tab = '\t';

        String xlsFile = "WebCatDiscMaint" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//MaintenanceApps//Common//Excel//") + xlsFile;

        StreamWriter swExcel = new StreamWriter(ExportFile, false);

        swExcel.WriteLine("Category" + tab + "Item CVC" + tab + "Discount" + tab + "Effective Start" + tab + "Effecitive End" + tab + 
                          "Entry ID" + tab + "Entry Date" + tab + "Change ID" + tab + "Change Date" + tab + "Delete Date");

        foreach (DataRow WCDRow in dsWebCatDisc.Tables[0].Rows)
            swExcel.WriteLine(WCDRow["Category"].ToString() + tab + WCDRow["ItemCVC"].ToString() + tab + String.Format("{0:0.00%}", WCDRow["GridDiscPct"]) + tab +
                              String.Format("{0:d}", WCDRow["EffectiveStartDt"]) + tab + String.Format("{0:d}", WCDRow["EffectiveEndDt"]) + tab +
                              WCDRow["EntryID"].ToString() + tab + String.Format("{0:d}", WCDRow["EntryDt"]) + tab +
                              WCDRow["ChangeID"].ToString() + tab + String.Format("{0:d}", WCDRow["ChangeDt"]) + tab +
                              String.Format("{0:d}", WCDRow["DeleteDt"]));

        swExcel.Close();

        Response.Redirect("WebCatDiscMaintXLS.aspx?Filename=../MaintenanceApps/Common/Excel/" + xlsFile, true);
    }

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {
            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..//MaintenanceApps//Common//Excel//"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(strSession))
                    fn.Delete();
            }

            return "";
        }
        catch (Exception ex) { return ""; }
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

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgWebCatDisc.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    private void HookOnFocus(Control CurrentControl)
    {
        if ((CurrentControl is TextBox) || (CurrentControl is DropDownList) || (CurrentControl is ListBox) || (CurrentControl is ImageButton))
            (CurrentControl as WebControl).Attributes.Add("onfocus", "try{document.getElementById('hidFocus').value=this.id} catch(e) {}");

        if (CurrentControl.HasControls())
            foreach (Control CurrentChildControl in CurrentControl.Controls)
                HookOnFocus(CurrentChildControl);
    }

    protected string GetSiteURL()
    {
        string url = "'Common/DatePicker/DatePicker_ClientInterface.aspx'";
        return url;
    }
}
