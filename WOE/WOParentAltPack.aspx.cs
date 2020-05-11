using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.WOE;
using PFC.WOE.BusinessLogicLayer;
using PFC.WOE.DataAccessLayer;
using PFC.WOE.SecurityLayer;

public partial class WOParentAltPack : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

    DataSet dsWorkSheet = new DataSet();
    DataTable dtWorkSheet = new DataTable();

    int PageSize = 17;
    int dgOffSet = 3;

    string PreviewURL;

    DataUtility DataUtil = new DataUtility();
    WorksheetData WSData = new WorksheetData();
    SecurityUtility SecurityUtil = new SecurityUtility();
    Common BusinessLogic = new Common();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            Ajax.Utility.RegisterTypeForAjax(typeof(WOParentAltPack));

            Session["UserName"] = ((Session["UserName"] != null) ? Session["UserName"].ToString() : "[null]");

            GetSecurity();

            DataUtil.BindListControls(ddlActionStatus, "ListDesc", "ListValue", DataUtil.GetListDetails("WOActions"), "--- ALL ---");
            DataUtil.BindListFromTables("--- ALL ---", ddlPriorityCd, "TableType='PRI' AND WOApp='Y' ORDER BY TableCd");
            DataUtil.BindLocList("--- ALL ---", ddlBranch, "AssemblyLoc='Y' ORDER BY LocID");
            DataUtil.BindWorkSheetUserList("--- ALL ---", ddlEntryID);

            ClearGrid();
        }
    }

    #region Filters
    protected void txtCat_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtCat.Text.ToString()))
            txtCat.Text = txtCat.Text.PadLeft(5, '0').ToString();
        smWorkSheet.SetFocus(txtSize);
    }

    protected void txtSize_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtSize.Text.ToString()))
            txtSize.Text = txtSize.Text.PadLeft(4, '0').ToString();
        smWorkSheet.SetFocus(txtVar);
    }

    protected void txtVar_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtVar.Text.ToString()))
            txtVar.Text = txtVar.Text.PadLeft(3, '0').ToString();
        smWorkSheet.SetFocus(btnSubmit);
    }

    protected void btnSubmit_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            lblMessage.Text = "";
            pnlStatus.Update();
            string ActionStatus = "";
            string PriorityCd = "";
            string EntryID = "";
            string WOBranch = "";
            string Category = "";
            string Size = "";
            string Variance = "";
            string AltVariance = "1";

            PreviewURL = "WOParentAltPackExport.aspx?ActionStatus=";

            if (ddlActionStatus.SelectedIndex > 0)
            {
                ActionStatus = ddlActionStatus.SelectedValue.ToString();
                PreviewURL = PreviewURL + ddlActionStatus.SelectedValue.ToString();
            }

            PreviewURL = PreviewURL + "&PriorityCd=";
            if (ddlPriorityCd.SelectedIndex > 0)
            {
                PriorityCd = ddlPriorityCd.SelectedValue.ToString();
                PreviewURL = PreviewURL + ddlPriorityCd.SelectedValue.ToString();
            }

            PreviewURL = PreviewURL + "&EntryID=";
            if (ddlEntryID.SelectedIndex > 0)
            {
                EntryID = ddlEntryID.SelectedValue.ToString();
                PreviewURL = PreviewURL + ddlEntryID.SelectedValue.ToString();
            }

            //PreviewURL = PreviewURL + "&Branch=";
            if (ddlBranch.SelectedIndex > 0)
            {
                WOBranch = ddlBranch.SelectedValue.ToString();
                PreviewURL = PreviewURL + "&Branch=" + ddlBranch.SelectedValue.ToString() + "&BranchDesc=" + ddlBranch.SelectedItem.ToString();
            }
            else
            {
                PreviewURL = PreviewURL + "&Branch=&BranchDesc=";
            }

            PreviewURL = PreviewURL + "&Category=";
            if (!string.IsNullOrEmpty(txtCat.Text.ToString()))
            {
                Category = txtCat.Text.ToString();
                PreviewURL = PreviewURL + txtCat.Text.ToString();
            }

            PreviewURL = PreviewURL + "&Size=";
            if (!string.IsNullOrEmpty(txtSize.Text.ToString()))
            {
                Size = txtSize.Text.ToString();
                PreviewURL = PreviewURL + txtSize.Text.ToString();
            }

            PreviewURL = PreviewURL + "&Variance=";
            if (!string.IsNullOrEmpty(txtVar.Text.ToString()))
            {
                Variance = txtVar.Text.ToString();
                PreviewURL = PreviewURL + txtVar.Text.ToString();
            }

            hidPreviewURL.Value = PreviewURL;
            PrintDialogue1.PageUrl = hidPreviewURL.Value + "&SortCommand=";
            pnlExport.Update();

            dsWorkSheet = SqlHelper.ExecuteDataset(connectionString, "pWOWorksheetAltItemList"
                , new SqlParameter("@ActionStatus", ActionStatus)
                , new SqlParameter("@PriorityCode", PriorityCd)
                , new SqlParameter("@UserID", EntryID)
                , new SqlParameter("@Branch", WOBranch)
                , new SqlParameter("@Category", Category)
                , new SqlParameter("@Size", Size)
                , new SqlParameter("@Variance", Variance)
                , new SqlParameter("@AltVariance", AltVariance)
                );
            Session["dtWS"] = dsWorkSheet.Tables[0].DefaultView.ToTable();
            hidSort.Value = "";
            hidSort.Attributes["sortType"] = "ASC";

            if (dsWorkSheet.Tables[0].Rows.Count > 0)
            {
                Pager1.GotoPageNumber = 0;
                dgWorkSheet.CurrentPageIndex = 0;
                pnlPager.Update();
                BindDataGrid();
                //DisplayStatusMessage(PrintDialogue1.PageUrl.ToString(), "fail");
            }
            else
            {
                DisplayStatusMessage("No matching records found", "fail");
                ClearGrid();
            }
        }
        catch (Exception ex)
        {
            DisplayStatusMessage(ex.ToString(), "fail");
            ClearGrid();
        }
    }
    #endregion

    #region Bind Grid
    private void BindDataGrid()
    {
        dtWorkSheet = (DataTable)Session["dtWS"];
        dtWorkSheet.DefaultView.Sort = (hidSort.Value == "") ? "ActionStatus ASC, FinishedItemNo ASC, PriorityCd ASC" : hidSort.Value;
        dgWorkSheet.DataSource = dtWorkSheet.DefaultView.ToTable();
        dgWorkSheet.AllowPaging = true;
        dgWorkSheet.DataBind();
        pnlWSGrid.Update();

        hidRowCount.Value = dtWorkSheet.Rows.Count.ToString();
        Session["dtWS"] = dtWorkSheet.DefaultView.ToTable();

        Pager1.InitPager(dgWorkSheet, PageSize);
        Pager1.Visible = true;
        divdatagrid.Style["width"] = hidDetailGridWidth.Value.ToString() + "px";
        pnlPager.Update();
    }

    protected void PageChanged(Object sender, System.EventArgs e)
    {
        dgWorkSheet.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void dgWorkSheet_SortCommand(object source, DataGridSortCommandEventArgs e)
    {
        if (hidSort.Attributes["sortType"] != null)
        {
            if (hidSort.Attributes["sortType"].ToString() == "ASC")
                hidSort.Attributes["sortType"] = "DESC";
            else
                hidSort.Attributes["sortType"] = "ASC";
        }
        else
            hidSort.Attributes.Add("sortType", "DESC");

        hidSort.Value = e.SortExpression + " " + hidSort.Attributes["sortType"].ToString();
        BindDataGrid();

        PrintDialogue1.PageUrl = hidPreviewURL.Value + "&SortCommand=" + hidSort.Value;
        pnlExport.Update();
    }
    #endregion

    protected void btnCancel_Click(object sender, ImageClickEventArgs e)
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        ClearGrid();
    }

    private void ClearGrid()
    {
        //ddlActionStatus.SelectedIndex = 0;
        //ddlPriorityCd.SelectedIndex = 0;
        //ddlBranch.SelectedIndex = 0;
        //txtCat.Text = "";
        //txtSize.Text = "";
        //txtVar.Text = "";
        smWorkSheet.SetFocus(ddlActionStatus);

        Session["dtWS"] = "";
        dgWorkSheet.DataSource = "";
        dgWorkSheet.AllowPaging = false;
        dgWorkSheet.DataBind();
        pnlWSGrid.Update();

        Pager1.Visible = false;
        Pager1.GotoPageNumber = 0;
        dgWorkSheet.CurrentPageIndex = 0;
        pnlPager.Update();

        PreviewURL = "WOWorkSheet/WOWorkSheetPreview.aspx?ActionStatus=&PriorityCd=&Category=&Size=&Variance=";
        hidPreviewURL.Value = PreviewURL;
        PrintDialogue1.PageUrl = hidPreviewURL.Value + "&SortCommand=";
        pnlExport.Update();
    }

    #region App Utilities
    public bool IsDate(string sdate)
    {
        DateTime dt;
        try
        {
            dt = DateTime.Parse(sdate);
        }
        catch
        {
            return false;
        }
        return true;
    } 

    private void DisplayStatusMessage(string message, string messageType)
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
    //For WOWorkSheet: MRP (W); WOS (W)
    //
    private void GetSecurity()
    {
        hidSecurity.Value = SecurityUtil.GetSecurityCode(Session["UserName"].ToString(), "WOWorkSheet");
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
        //hidSecurity.Value = "Full";
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

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void UnloadPage()
    {
        Session["dtWS"] = "";
    }
    #endregion
}