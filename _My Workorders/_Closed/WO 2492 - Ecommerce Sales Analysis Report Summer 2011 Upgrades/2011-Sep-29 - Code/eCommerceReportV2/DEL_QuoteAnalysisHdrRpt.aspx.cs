#region Namespaces
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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
using PFC.Intranet.eCommerceReportV2;
#endregion

public partial class QuoteAnalysisHdrRpt : System.Web.UI.Page
{
    #region Global Variables
    private DataSet dsQuoteAnalysis = new DataSet();
    private DataTable dtQuoteAnalysis = new DataTable();
    
    private string sortExpression = string.Empty;
    int pagesize = 19;

    string periodMonth = string.Empty;
    string periodYear = string.Empty;
    string customerNo = string.Empty;
    string branchNo = string.Empty;
    string startDate = string.Empty;
    string endDate = string.Empty;
    string orderSource = "";
    string sourceType = "";
    string itemNotOrd = "";

    protected eCommerceReportV2 eCommerceReport = new eCommerceReportV2();
    #endregion

    #region Page Load
    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        Ajax.Utility.RegisterTypeForAjax(typeof(QuoteAnalysisHdrRpt));

        #region URL Parameters
        periodMonth = (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "";
        periodYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";
        customerNo = (Request.QueryString["CustomerNumber"] != null) ? Request.QueryString["CustomerNumber"].ToString().Trim() : "";
        branchNo = (Request.QueryString["BranchNumber"] != null) ? Request.QueryString["BranchNumber"].ToString().Trim() : "";
        startDate = (Request.QueryString["StartDate"] != null) ? Request.QueryString["StartDate"].ToString().Trim() : "";
        endDate = (Request.QueryString["EndDate"] != null) ? Request.QueryString["EndDate"].ToString().Trim() : "";
        orderSource = (Request.QueryString["OrdSrc"] != null) ? Request.QueryString["OrdSrc"].ToString().Trim() : "";
        sourceType = (Request.QueryString["SrcTyp"] != null) ? Request.QueryString["SrcTyp"].ToString().Trim() : "";
        itemNotOrd = (Request.QueryString["ItemNotOrd"] != null) ? Request.QueryString["ItemNotOrd"].ToString().Trim() : "false";
        #endregion

        #region XLS File Name
        string fileTime = DateTime.Now.ToString().Replace("/", "");
        fileTime = fileTime.Replace(" ", "");
        fileTime = fileTime.Replace(":", "");
        hidFileName.Value = "QuoteAnalysisHdrRpt" + Session["SessionID"].ToString() + fileTime + ".xls";
        //hidFileName.Value = "QuoteAnalysisHdrRpt" + fileTime + ".xls";
        #endregion

        if (!IsPostBack)
            BindDataGrid();
    }
    #endregion

    #region DataGrid
    private void BindDataGrid()
    {
        sortExpression = ((hidSort.Value != "") ? hidSort.Value : "QuoteNumber");

        dsQuoteAnalysis = eCommerceReport.GetQuoteData(periodMonth, periodYear, startDate, endDate, branchNo, customerNo, orderSource, sourceType, itemNotOrd, "HDR");
        dtQuoteAnalysis = dsQuoteAnalysis.Tables[0].DefaultView.ToTable();
        dtQuoteAnalysis.DefaultView.Sort = sortExpression;

        if (dtQuoteAnalysis.Rows.Count > 0)
        {
            dgQuoteAnalysis.DataSource = dtQuoteAnalysis.DefaultView.ToTable();
            Pager1.Visible = true;
            Pager1.InitPager(dgQuoteAnalysis, pagesize);
            lblStatus.Visible = false;
        }
        else
        {
            Pager1.Visible = false;
            lblStatus.Visible = true;
            lblStatus.Text = "No Records Found";
        }
    }

    protected void dgQuoteAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        #region Grid Footer
        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].ColumnSpan = 5;
            e.Item.Cells[0].HorizontalAlign = HorizontalAlign.Center;
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[1].Visible = false;
            e.Item.Cells[2].Visible = false;
            e.Item.Cells[3].Visible = false;
            e.Item.Cells[4].Visible = false;

            e.Item.Cells[5].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(LineCount)", "")));
            e.Item.Cells[6].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(RequestQuantity)", "")));
            e.Item.Cells[7].Text = String.Format("{0:c}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(ExtPrice)", "")));
            e.Item.Cells[8].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(ExtWeight)", "")));
        }
        #endregion
    }

    protected void dgQuoteAnalysis_SortCommand(object source, DataGridSortCommandEventArgs e)
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

    protected void dgQuoteAnalysis_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page # and rebind data grid
        dgQuoteAnalysis.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
    }
    
    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgQuoteAnalysis.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }
    #endregion

    #region Write to Excel

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + hidFileName.Value.ToString()));
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        string sortExpression = ((hidSort.Value != "") ? hidSort.Value : "QuoteNumber");

        dsQuoteAnalysis = eCommerceReport.GetQuoteData(periodMonth, periodYear, startDate, endDate, branchNo, customerNo, orderSource, sourceType, itemNotOrd, "HDR");
        dtQuoteAnalysis = dsQuoteAnalysis.Tables[0].DefaultView.ToTable();
        //dtQuoteAnalysis = eCommerceReport.AverageCostJoins(dsQuoteAnalysis.Tables[0], GetAverageCost(dsQuoteAnalysis.Tables[0]));
        //DataColumn dcAverageCost = new DataColumn("MarginPercentage", System.Type.GetType("System.Double"));
        //dcAverageCost.Expression = "IIF([UnitPrice]=0, 0,(((UnitPrice - AvgCost) / UnitPrice) * 100))";
        //dcAverageCost.Expression = "(((UnitPrice - AvgCost) / UnitPrice) * 100)";
        //dtQuoteAnalysis.Columns.Add(dcAverageCost);

        dtQuoteAnalysis.DefaultView.Sort = sortExpression;

        headerContent = "<table border='1'>";
        headerContent += "<tr><th colspan='15' style='color:blue'>eCommerce Quote Header Analysis Report</th></tr>";

        headerContent += "<tr><th>Customer #</th><th colspan='2' align='left'>&nbsp;" + Request.QueryString["CustomerNumber"].ToString() + "</th>";
        headerContent += "<th>Customer Name</th><th colspan='5' align='left'>" + Request.QueryString["CustomerName"].ToString() + "</th>";
        headerContent += "<th>Run By</th><th colspan='2' align='left'>" + Session["UserName"].ToString() + "</th>";
        headerContent += "<th>Run Date</th><th colspan='2' align='left'>" + DateTime.Now.ToShortDateString() + "</th></tr>";
        headerContent += "<tr><th>Quote Method</th><th>Quotation Date</th><th>Expiry Date</th><th>User Item #</th><th>PFCItem No</th><th>Description</th><th>Sales Branch of Record</th><th>Req. Qty</th><th>Ava. Qty</th><th>Unit Price</th><th>Margin %</th><th>Average Cost</th><th>Price Uom</th><th>Total Price</th><th>Total Weight</th>";

        if (dtQuoteAnalysis.Rows.Count > 0)
        {
            foreach (DataRow eComQuoteAnalysis in dtQuoteAnalysis.DefaultView.ToTable().Rows)
            {
                excelContent += "<tr><td>" +
                     String.Format("{0:#,##0}", eComQuoteAnalysis["QuoteMethod"]) + "</td><td>" +
                     String.Format("{0:MM/dd/yyyy}", eComQuoteAnalysis["QuotationDate"]) + "</td><td>" +
                     String.Format("{0:MM/dd/yyyy}", eComQuoteAnalysis["ExpiryDate"]) + "</td><td align=left>" +
                     eComQuoteAnalysis["UserItemNo"].ToString() + "</td><td>" +
                     eComQuoteAnalysis["PFCItemNo"].ToString() + "</td><td>" +
                     eComQuoteAnalysis["Description"].ToString() + "</td><td>&nbsp;" +
                     eComQuoteAnalysis["SalesBranchofRecord"].ToString() + "</td><td>" +
                     String.Format("{0:#,##0}", eComQuoteAnalysis["RequestQuantity"]) + "</td><td>" +
                     String.Format("{0:#,##0}", eComQuoteAnalysis["RunningAvalQty"]) + "</td><td>" +
                     String.Format("{0:#,##0.00}", eComQuoteAnalysis["UnitPrice"]) + "</td><td>" +
                     String.Format("{0:#,##0.0}", eComQuoteAnalysis["MarginPercentage"]) + "</td><td>" +
                     String.Format("{0:#,##0.00}", eComQuoteAnalysis["AvgCost"]) + "</td><td>" +
                     eComQuoteAnalysis["PriceUOM"].ToString() + "</td><td>" +
                     String.Format("{0:#,##0.00}", eComQuoteAnalysis["TotalPrice"]) + "</td><td>" +
                     String.Format("{0:#,##0.00}", eComQuoteAnalysis["GrossWeight"]) + "</td></tr>";
            }

            footerContent = "<tr style='font-weight:bold;' align='right'><td colspan='4'>" + "Grand Total" + "</td><td>" +
                     " " + "</td><td>" +
                     " " + "</td><td>" +
                     " " + "</td><td>" +
                     String.Format("{0:#,##0}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(RequestQuantity)", ""))) + "</td><td>" +
                     String.Format("{0:#,##0}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(RunningAvalQty)", ""))) + "</td><td>" +
                     "" + "</td><td>" +
                     String.Format("{0:#,##0.0}", Convert.ToDecimal(dtQuoteAnalysis.Compute("Avg(MarginPercentage)", ""))) + "</td><td>" +
                     String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuoteAnalysis.Compute("Avg(AvgCost)", ""))) + "</td><td>" +
                     " " + "</td><td>" +
                     String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(TotalPrice)", ""))) + "</td><td>" +
                     String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(GrossWeight)", ""))) + "</td></tr></table>";

            //String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(GrossWeight)", ""))) + "</td></tr></table>";

        }
        reportWriter.WriteLine(headerContent + excelContent + footerContent);
        reportWriter.Close();


        //
        // Downloding Process
        //
        FileStream fileStream = File.Open(Server.MapPath("..//Common//ExcelUploads//" + hidFileName.Value.ToString()), FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        //
        // Download Process
        //
        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath("..//Common//ExcelUploads//" + hidFileName.Value.ToString())));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }

    #endregion

    #region Delete Excel using sessionid

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {
            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\Common\\ExcelUploads"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(strSession))
                    fn.Delete();
            }
            return "";
        }
        catch (Exception ex) { return ""; }
    }
    #endregion
}
