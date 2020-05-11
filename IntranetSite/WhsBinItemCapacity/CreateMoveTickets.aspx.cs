#region Name Space
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
using System.Data.SqlClient;
using System.Threading;
using System.IO;
using System.Reflection;
using Microsoft.Web.UI;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
using System.Drawing;
#endregion

public partial class CreateMoveTickets : System.Web.UI.Page 
{
    BinItemCapacityData binItemCapacityData = new BinItemCapacityData();
    ddlBind _ddlBind = new ddlBind();

    int ExcelpageSize = 23;
    int TicketpageSize = 22;
    private string ExcelKeyColumn = "pPFCBinItemCapacityID";
    private string TicketKeyColumn = "TicketNo";
    private string sortExpression = string.Empty;
    private string securityCode = string.Empty;
    DataTable dt;

    #region Auto generated event
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            securityCode = GetSecurityCode(Session["UserName"].ToString());
            if ((securityCode == "MOVT(W)") || (securityCode == "MOVTP(W)"))
            {
                hidSecurityGroup.Value = securityCode;
                SetDefaults();
                ClearSessions();
                dgExcelData.PageSize = ExcelpageSize;
                dgTicketData.PageSize = TicketpageSize;
                FillFileGrid();
                ShowPanel(pnlExcelDir);
            }
            else
            {
                pnlCommand.Visible = false;
                updCommandPanel.Update();
                ShowPanel(pnlNoAccess);
            }
        }
        Session["FooterTitle"] = "Move Forward and Bin Consolidation";
    }
    #endregion

    #region Input (Excel) file processing and review

    private void AddFileInfoToTable(string ExcelFile, DataTable GridTable)
    {
        FileInfo fi = new FileInfo(ExcelFile);
        GridTable.Rows.Add(new Object[] { fi.Name, fi.LastWriteTime.ToLongDateString() + " " + fi.LastWriteTime.ToLongTimeString() });
    }
    private void SetDefaults()
    {
        //
        //To set the default directory for capacity files
        //
        DefaultDirLabel.Text = binItemCapacityData.GetAppPref("DIR");
        //
        //To set the last file processed
        //
        FileProcessed.Text = binItemCapacityData.GetAppPref("LastFile");
    }

    private void FillFileGrid()
    {
        DataTable dtFiles = new DataTable();
        dtFiles.Columns.Add("Ready For Review", typeof(String));
        dtFiles.Columns.Add("Date Modified", typeof(String));
        string targetDirectory = DefaultDirLabel.Text;
        // Process the list of files found in the directory.
        string[] fileEntries = Directory.GetFiles(targetDirectory);
        foreach (string fileName in fileEntries)
        {
            AddFileInfoToTable(fileName, dtFiles);
        }
        FilesGridView.DataSource = dtFiles;
        FilesGridView.DataBind();
    }

    protected void btnLoadFile_Click(object sender, ImageClickEventArgs e)
    {
        // The 'Include local directory path when uploading files to server' must be enabled
        // in the Internet Explorer security miscellaneous settings for this to work.
        if (SingleFileName.Value.Length > 0)
        {
            ProcessExcelFile(SingleFileName.Value);
        }
        else
        {
            // Notify the user that a file was not uploaded.
            ShowPageMessages("You did not specify a file to upload.", "");
        }
    }

    protected void btnLoadExcel_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        ShowPanel(pnlExcelDir);
    }

    private void ProcessExcelFile(string ExcelFileName)
    {
        //
        //send the file through the parsing engine 
        //
        ClearPageMessages();
        FileProcessed.Text = ExcelFileName;
        binItemCapacityData.SetLastFile(ExcelFileName);
        updCommandPanel.Update();
        pnlExcelDir.Visible = false;
        string UserName = Session["UserName"].ToString();
        binItemCapacityData.ParseEngine(ExcelFileName, UserName);
        dgExcelData.CurrentPageIndex = 0;
        ShowPanel(pnlWorking);
        ShowPageMessages("", "Processed " + ExcelFileName);
    }

    protected void btnShowExcel_Click(object sender, ImageClickEventArgs e)
    {
        // Show the current Excel data
        BindExcelGrid();
    }

    private void BindExcelGrid()
    {
        // Show the data from the current excel file.
        sortExpression = ((hidExcelSort.Value != "") ? hidExcelSort.Value : ExcelKeyColumn);
        dt = binItemCapacityData.GetExcelData(); 
        dt.DefaultView.Sort = sortExpression;
        dgExcelData.DataSource = dt.DefaultView.ToTable();
        dgExcelData.DataBind();
        if (dgExcelData.Items.Count > 0)
        {
            ExcelPager.InitPager(dgExcelData, ExcelpageSize);
            ExcelPager.Visible = true;

        }
        else
            ExcelPager.Visible = false;
        ShowPanel(pnlExcelData);
    }

    protected void UpdateFromGrid(object sender, GridViewEditEventArgs e)
    {
        GridViewRow row = FilesGridView.Rows[e.NewEditIndex];
        string FileToProcess = DefaultDirLabel.Text + row.Cells[1].Text;
        ProcessExcelFile(FileToProcess);
    }

    protected void dgExcelData_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgExcelData.CurrentPageIndex = e.NewPageIndex;
        BindExcelGrid();
    }

    protected void dgExcelData_SortCommand(object source, DataGridSortCommandEventArgs e)
    {
        if (hidExcelSort.Attributes["sortType"] != null)
        {
            if (hidExcelSort.Attributes["sortType"].ToString() == "ASC")
                hidExcelSort.Attributes["sortType"] = "DESC";
            else
                hidExcelSort.Attributes["sortType"] = "ASC";
        }
        else
            hidExcelSort.Attributes.Add("sortType", "ASC");

        hidExcelSort.Value = e.SortExpression + " " + hidExcelSort.Attributes["sortType"].ToString();
        BindExcelGrid();

    }

    protected void ExcelPager_PageChanged(Object sender, System.EventArgs e)
    {
        dgExcelData.CurrentPageIndex = ExcelPager.GotoPageNumber;
        BindExcelGrid();
    }

 
    #endregion

    #region Ticket Processing

    protected void btnCreateTickets_Click(object sender, ImageClickEventArgs e)
    {
        ClearPageMessages();
        LoadLocDDL(ddlLocation);
        BindPrinterDropDown(ddlPrinterName);
        ddlPrinterName.Enabled = false;
        if (chkAutoPrint.Checked)
        {
            ddlPrinterName.Enabled = true;
        }
        btnProcessSubmit.Visible = true;
        lblProcessStatus.Text = "Select a branch. You can set the filters but they are not required. "
       + "You can set a beginning without an ending and visa versa. " 
       + " If you do this you will set all the records from or up to the filter.";
        ShowPanel(pnlProcess);
        updProcess.Update();
    }

    protected bool ValidProcessFilters()
    {
        // check the ranges. Empty boxes mean all
        bool IsValid = true;
        if ((txtBegItem.Text.Trim().Length > 0) & (txtEndItem.Text.Trim().Length > 0) & (txtBegItem.Text.CompareTo(txtEndItem.Text) == 1))
        {
            ShowPageMessages("Beginning Item number must be less than Ending Item Number.", "");
            IsValid = false;
        }
        //if ((txtBegFrom.Text.Trim().Length > 0) & (txtEndFrom.Text.Trim().Length > 0) & (txtBegFrom.Text.CompareTo(txtEndFrom.Text) == 1))
        //{
        //    ShowPageMessages("Beginning From Bin must be less than Ending From Bin.", "");
        //    IsValid = false;
        //}
        if ((txtBegTo.Text.Trim().Length > 0) & (txtEndTo.Text.Trim().Length > 0) & (txtBegTo.Text.CompareTo(txtEndTo.Text) == 1))
        {
            ShowPageMessages("Beginning To Bin must be less than Ending To Bin.", "");
            IsValid = false;
        }
        if ((chkAutoPrint.Checked) & (ddlPrinterName.SelectedValue.Trim().Length == 0))
        {
            ShowPageMessages("IF you want to print, you must select a printer.", "");
            IsValid = false;
        }
        return IsValid;
    }

    protected void btnProcessSubmit_Click(object sender, ImageClickEventArgs e)
    {
        // flag the excel records as ready to be processed into move tickets
        string FilterValue = "";
        string AutoPrint = "0";
        if (chkAutoPrint.Checked)
        {
            AutoPrint = "1";
        }
        string SelectedPrinter = ddlPrinterName.SelectedValue;
        ClearPageMessages();
        if (ValidProcessFilters())
        {
            btnProcessSubmit.Visible = false;
            updProcess.Update();
            FilterValue = txtBegItem.Text.Trim() + ":" + txtEndItem.Text.Trim() + ";";
            //FilterValue += txtBegFrom.Text.Trim() + ":" + txtEndFrom.Text.Trim() + ";";
            FilterValue += txtBegTo.Text.Trim() + ":" + txtEndTo.Text.Trim() + ";";
            dt = binItemCapacityData.SetToProcess(ddlLocation.SelectedValue, FilterValue, AutoPrint, SelectedPrinter, Session["UserName"].ToString());
            lblProcessStatus.Text = dt.Rows[0]["Processed"].ToString() + " records are now set to process. "
            + "This totals inludes all capacity records ready to process for branch " + ddlLocation.SelectedValue
            + ". These records will process this evening and the Move Tickets can be reviewed tomorrow.";
        }
        else
        {
            if (chkAutoPrint.Checked)
            {
                ddlPrinterName.Enabled = true;
            }
            updProcess.Update();
        }
    }

 
    #endregion

    #region Ticket Review and Print

    protected void btnReview_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            ClearPageMessages();
            LoadLocDDL(ddlReviewLoc);
            ClearSessions();
            if (hidSecurityGroup.Value == "MOVTP(W)")
            {
                BindPrinterDropDown(ddlReviewPrinter);
                btnReviewPrint.Visible = true;
                pnlTicketPrint.Visible = true;
            }
            else
            {
                pnlTicketPrint.Visible = false;
            }
            btnReviewSelect.Visible = true;
            if (ddlReviewLoc.Items.Count == 1)
            {
                ShowReviewSummary(ddlReviewLoc.SelectedValue);
            }
            ShowPanel(pnlTicketsData);
            updProcess.Update();
        }
        catch (Exception ex) 
        {
            ShowPageMessages(ex.ToString(), "");
        }
    }

    protected void btnReviewSelect_Click(object sender, ImageClickEventArgs e)
    {
        ShowReviewSummary(ddlReviewLoc.SelectedValue);
    }

    protected void btnReviewPrint_Click(object sender, ImageClickEventArgs e)
    {
        // print all the tickets for the branch

        ClearPageMessages();
        //if (ValidProcessFilters())
        //{
        string FilterValue = ""; 
        btnReviewPrint.Visible = false;
        updTicketPrint.Update();
        dt = binItemCapacityData.PrintOK(ddlReviewLoc.SelectedValue, ddlReviewPrinter.SelectedValue, FilterValue, Session["UserName"].ToString());
        ShowPageMessages("", "The Tickets in the Grid have been Queued (" + ddlReviewLoc.SelectedValue + ":" + ddlReviewPrinter.SelectedValue + ".");
        //    FilterValue = txtBegItem.Text.Trim() + ":" + txtEndItem.Text.Trim() + ";";
        //    //FilterValue += txtBegFrom.Text.Trim() + ":" + txtEndFrom.Text.Trim() + ";";
        //    FilterValue += txtBegTo.Text.Trim() + ":" + txtEndTo.Text.Trim() + ";";
        //    lblProcessStatus.Text = dt.Rows[0]["Processed"].ToString() + " records are now set to process. "
        //    + "This totals inludes all capacity records ready to process for branch " + ddlLocation.SelectedValue
        //    + ". These records will process this evening and the Move Tickets can be reviewed tomorrow.";
        //}
        //else
        //{
        //    if (chkAutoPrint.Checked)
        //    {
        //        ddlPrinterName.Enabled = true;
        //    }
        //    updProcess.Update();
        //}
    }

    private void ShowReviewSummary(string Branch)
    {
        // Show the summary ticket status for a branch
        dt = binItemCapacityData.GetTicketSummary(Branch); 
        dgSummary.DataSource = dt;
        dgSummary.DataBind();
        BindTicketGrid(Branch, dt.Rows[0]["BinStatus"].ToString());
    }

    private void BindTicketGrid(string Loc, string Status)
    {
        // show the current ticket data
        hidTicketStatus.Value = Status;
        sortExpression = ((hidTicketSort.Value != "") ? hidTicketSort.Value : TicketKeyColumn);
        dt = binItemCapacityData.GetTicketData(Loc, Status);
        dt.DefaultView.Sort = sortExpression;
        dgTicketData.DataSource = dt.DefaultView.ToTable();
        dgTicketData.DataBind();
        if (dgTicketData.Items.Count > 0)
        {
            TicketPager.InitPager(dgTicketData, TicketpageSize);
            TicketPager.Visible = true;

        }
        else
            TicketPager.Visible = false;
        updTicketsPanel.Update();
    }

    protected void dgSummary_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        hidTicketStatus.Value = e.Item.Cells[1].Text;
        if ((hidTicketStatus.Value == "OK") && (hidSecurityGroup.Value == "MOVTP(W)"))
        {
            pnlTicketPrint.Visible = true;
            updTicketPrint.Update();
        }
        else
        {
            pnlTicketPrint.Visible = false;
            updTicketPrint.Update();
        }
        BindTicketGrid(ddlReviewLoc.SelectedValue, hidTicketStatus.Value);
    }

    protected void dgTicketData_PageIndexChanged(Object sender, System.EventArgs e)
    {
        dgTicketData.CurrentPageIndex = TicketPager.GotoPageNumber;
        BindTicketGrid(ddlReviewLoc.SelectedValue, hidTicketStatus.Value);
    }

    protected void dgTicketData_SortCommand(object source, DataGridSortCommandEventArgs e)
    {
        if (hidTicketSort.Attributes["sortType"] != null)
        {
            if (hidTicketSort.Attributes["sortType"].ToString() == "ASC")
                hidTicketSort.Attributes["sortType"] = "DESC";
            else
                hidTicketSort.Attributes["sortType"] = "ASC";
        }
        else
            hidTicketSort.Attributes.Add("sortType", "ASC");

        hidTicketSort.Value = e.SortExpression + " " + hidTicketSort.Attributes["sortType"].ToString();
        BindTicketGrid(ddlReviewLoc.SelectedValue, hidTicketStatus.Value);

    }

    protected void dgTicketData_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {

            string TicketNo = e.Item.Cells[2].Text;
            System.Web.UI.ScriptManager.RegisterClientScriptBlock(this.Page, this.GetType(), "PreviewExport", "PreviewReport('" + TicketNo + "');", true);
        }
    }

    public void dgTicketData_ItemDataBound(Object sender, DataGridItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            //Label OverPick = (Label)e.Item.FindControl("OverPickQty");
            if (e.Item.Cells[8].Text.Trim() != "OK")
            {
                e.Item.Cells[0].Text = "";
            }
            else
            {
                if (e.Item.DataSetIndex > 0)
                {
                    if ((Session["BICPrevTickNo"].ToString().CompareTo(e.Item.Cells[2].Text.Trim()) == 0))
                    {
                        Session["BICPrevTickNo"] = e.Item.Cells[2].Text;
                        e.Item.Cells[0].Text = "";
                        e.Item.Cells[1].Text = "";
                        e.Item.Cells[2].Text = "";
                    }
                    else
                    {
                        Session["BICPrevTickNo"] = e.Item.Cells[2].Text;
                    }
                    if ((Session["BICPrevFrom"].ToString().CompareTo(e.Item.Cells[4].Text.Trim() + e.Item.Cells[3].Text) == 0))
                    {
                        Session["BICPrevFrom"] = e.Item.Cells[4].Text + e.Item.Cells[3].Text;
                        e.Item.Cells[4].Text = "";
                        e.Item.Cells[3].Text = "";
                        e.Item.Cells[5].Text = "";
                    }
                    else
                    {
                        Session["BICPrevFrom"] = e.Item.Cells[4].Text + e.Item.Cells[3].Text;
                    }
                }
                else
                {
                    Session["BICPrevTickNo"] = e.Item.Cells[2].Text;
                    //Session["BICPrevItem"] = e.Item.Cells[3].Text;
                    Session["BICPrevFrom"] = e.Item.Cells[4].Text + e.Item.Cells[3].Text;
                    //Session["PrevTo"] = e.Item.Cells[3].Text;
                }
            }
        }

    }
    
    protected void TicketPager_PageChanged(Object sender, System.EventArgs e)
    {
        ClearPageMessages();
        dgTicketData.CurrentPageIndex = TicketPager.GotoPageNumber;
        BindTicketGrid(ddlReviewLoc.SelectedValue, hidTicketStatus.Value);
    }

    #endregion

    #region Misc Page Methods

    private void LoadLocDDL(DropDownList LocDDL)
    {
        // Load the branch drop down list 
        LocDDL.DataSource = binItemCapacityData.GetLocations();
        LocDDL.DataBind();
        if (LocDDL.Items.Count > 0)
        {
            LocDDL.SelectedValue = LocDDL.Items[0].Value;
        }
    }

    private void BindPrinterDropDown(DropDownList PrinterDDL)
    {
        try
        {
            DataSet dsPrinterName = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "UGEN_SP_Select",
                                new SqlParameter("@tableName", " PrinterList "),
                                new SqlParameter("@columnNames", "PrinterPath,PrinterNetworkAddress"),
                                new SqlParameter("@whereClause", "1=1"));
            _ddlBind.ddlBindControl(PrinterDDL, dsPrinterName.Tables[0], "PrinterNetworkAddress", "PrinterPath", "", "------ Select Printer ------");

            // Get user default printer 
            object userDefaultPrinter = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "UGEN_SP_Select",
                                        new SqlParameter("@tableName", "SecurityUsers"),
                                        new SqlParameter("@columnNames", "isnull(DefaultPackSlipPrinter,'') as DefaultPackSlipPrinter"),
                                        new SqlParameter("@whereClause", "UserName='" + Session["UserName"].ToString() + "'"));

            if (userDefaultPrinter != null)
            {
                PrinterDDL.SelectedValue = userDefaultPrinter.ToString().Trim();
            }


        }
        catch (Exception exe)
        {

        }
    }

    private void ShowPanel(Panel ToShow)
    {
        // Show the selected panel and hide all the rest
        pnlNoAccess.Visible = (pnlNoAccess.ID == ToShow.ID) ? true : false;
        pnlWorking.Visible = (pnlWorking.ID == ToShow.ID) ? true : false;
        pnlExcelDir.Visible = (pnlExcelDir.ID == ToShow.ID) ? true : false;
        pnlExcelData.Visible = (pnlExcelData.ID == ToShow.ID) ? true : false;
        pnlTicketsData.Visible = (pnlTicketsData.ID == ToShow.ID) ? true : false;
        pnlProcess.Visible = (pnlProcess.ID == ToShow.ID) ? true : false;
        updOptions.Update();
    }

    protected void ShowPageMessages(string ErrorText, string SuccessText)
    {
        lblErrorMessage.Text = ErrorText;
        lblSuccessMessage.Text = SuccessText;
        updMessage.Update();
    }

    protected void ClearPageMessages()
    {
        lblErrorMessage.Text = "";
        lblSuccessMessage.Text = "";
        updMessage.Update();
    }

    protected void ClearSessions()
    {
        Session["BICPrevTickNo"] = null;
        Session["BICPrevFrom"] = null;
    }

    /// <summary>
    /// get User security code
    /// </summary>
    /// <param name="userName">Parameter:username</param>
    /// <returns>User security code</returns>
    protected string GetSecurityCode(string userName)
    {
        try
        {
            object objSecurityCode = (object)SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                new SqlParameter("@tableName", "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU"),
                new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and (SU.DeleteDt is null or SU.DeleteDt = '') and (SM.DeleteDt is null or SM.DeleteDt = '') and (SG.DeleteDt is null or SG.DeleteDt = '') and SU.UserName='" + userName + "' AND (SG.groupname='MOVT(W)' OR  SG.groupname='MOVTP(W)')"));

            if (objSecurityCode != null)
                return objSecurityCode.ToString().Trim();
            else
                return "";

        }
        catch (Exception Ex) { return ""; }
    }

    #endregion
}