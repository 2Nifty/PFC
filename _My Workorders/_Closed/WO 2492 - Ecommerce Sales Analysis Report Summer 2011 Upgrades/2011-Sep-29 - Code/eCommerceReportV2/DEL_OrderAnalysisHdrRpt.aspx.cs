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

public partial class OrderAnalysisHdrRpt : System.Web.UI.Page
{
    #region Global Variables
    private DataSet dsOrderAnalysis = new DataSet();
    private DataTable dtOrderAnalysis = new DataTable();
    
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
        Ajax.Utility.RegisterTypeForAjax(typeof(OrderAnalysisHdrRpt));

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
        hidFileName.Value = "OrderAnalysisHdrRpt" + Session["SessionID"].ToString() + fileTime + ".xls";
        //hidFileName.Value = "OrderAnalysisHdrRpt" + fileTime + ".xls";
        #endregion

        if (!IsPostBack)
            BindDataGrid();
    }
    #endregion

    #region DataGrid
    private void BindDataGrid()
    {
        sortExpression = ((hidSort.Value != "") ? hidSort.Value : "OrderNumber");

        dsOrderAnalysis = eCommerceReport.GetOrderData(periodMonth, periodYear, startDate, endDate, branchNo, customerNo, orderSource, sourceType, itemNotOrd, "HDR");
        dtOrderAnalysis = dsOrderAnalysis.Tables[0].DefaultView.ToTable();
        dtOrderAnalysis.DefaultView.Sort = sortExpression;

        if (dtOrderAnalysis.Rows.Count > 0)
        {
            dgOrderAnalysis.DataSource = dtOrderAnalysis.DefaultView.ToTable();
            Pager1.Visible = true;
            Pager1.InitPager(dgOrderAnalysis, pagesize);
            lblStatus.Visible = false;
        }
        else
        {
            Pager1.Visible = false;
            lblStatus.Visible = true;
            lblStatus.Text = "No Records Found";
        }
    }

    protected void dgOrderAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
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

            e.Item.Cells[5].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(LineCount)", "")));
            e.Item.Cells[6].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(RequestQuantity)", "")));
            e.Item.Cells[7].Text = String.Format("{0:c}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(ExtPrice)", "")));
            e.Item.Cells[8].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(ExtWeight)", "")));
        }
        #endregion
    }

    protected void dgOrderAnalysis_SortCommand(object source, DataGridSortCommandEventArgs e)
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

    protected void dgOrderAnalysis_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page # and rebind data grid
        dgOrderAnalysis.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
    }
    
    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgOrderAnalysis.CurrentPageIndex = Pager1.GotoPageNumber;
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
        string sortExpression = ((hidSort.Value != "") ? hidSort.Value : "OrderNumber");

        dsOrderAnalysis = eCommerceReport.GetOrderData(periodMonth, periodYear, startDate, endDate, branchNo, customerNo, orderSource, sourceType, itemNotOrd, "HDR");
        dtOrderAnalysis = dsOrderAnalysis.Tables[0].DefaultView.ToTable();
        //dtOrderAnalysis = eCommerceReport.AverageCostJoins(dsOrderAnalysis.Tables[0], GetAverageCost(dsOrderAnalysis.Tables[0]));
        //DataColumn dcAverageCost = new DataColumn("MarginPercentage", System.Type.GetType("System.Double"));
        //dcAverageCost.Expression = "IIF([UnitPrice]=0, 0,(((UnitPrice - AvgCost) / UnitPrice) * 100))";
        //dcAverageCost.Expression = "(((UnitPrice - AvgCost) / UnitPrice) * 100)";
        //dtOrderAnalysis.Columns.Add(dcAverageCost);

        dtOrderAnalysis.DefaultView.Sort = sortExpression;

        headerContent = "<table border='1'>";
        headerContent += "<tr><th colspan='15' style='color:blue'>eCommerce Order Header Analysis Report</th></tr>";

        headerContent += "<tr><th>Customer #</th><th colspan='2' align='left'>&nbsp;" + Request.QueryString["CustomerNumber"].ToString() + "</th>";
        headerContent += "<th>Customer Name</th><th colspan='5' align='left'>" + Request.QueryString["CustomerName"].ToString() + "</th>";
        headerContent += "<th>Run By</th><th colspan='2' align='left'>" + Session["UserName"].ToString() + "</th>";
        headerContent += "<th>Run Date</th><th colspan='2' align='left'>" + DateTime.Now.ToShortDateString() + "</th></tr>";
        headerContent += "<tr><th>Order Method</th><th>Quotation Date</th><th>Expiry Date</th><th>User Item #</th><th>PFCItem No</th><th>Description</th><th>Sales Branch of Record</th><th>Req. Qty</th><th>Ava. Qty</th><th>Unit Price</th><th>Margin %</th><th>Average Cost</th><th>Price Uom</th><th>Total Price</th><th>Total Weight</th>";

        if (dtOrderAnalysis.Rows.Count > 0)
        {
            foreach (DataRow eComOrderAnalysis in dtOrderAnalysis.DefaultView.ToTable().Rows)
            {
                excelContent += "<tr><td>" +
                     String.Format("{0:#,##0}", eComOrderAnalysis["OrderMethod"]) + "</td><td>" +
                     String.Format("{0:MM/dd/yyyy}", eComOrderAnalysis["QuotationDate"]) + "</td><td>" +
                     String.Format("{0:MM/dd/yyyy}", eComOrderAnalysis["ExpiryDate"]) + "</td><td align=left>" +
                     eComOrderAnalysis["UserItemNo"].ToString() + "</td><td>" +
                     eComOrderAnalysis["PFCItemNo"].ToString() + "</td><td>" +
                     eComOrderAnalysis["Description"].ToString() + "</td><td>&nbsp;" +
                     eComOrderAnalysis["SalesBranchofRecord"].ToString() + "</td><td>" +
                     String.Format("{0:#,##0}", eComOrderAnalysis["RequestQuantity"]) + "</td><td>" +
                     String.Format("{0:#,##0}", eComOrderAnalysis["RunningAvalQty"]) + "</td><td>" +
                     String.Format("{0:#,##0.00}", eComOrderAnalysis["UnitPrice"]) + "</td><td>" +
                     String.Format("{0:#,##0.0}", eComOrderAnalysis["MarginPercentage"]) + "</td><td>" +
                     String.Format("{0:#,##0.00}", eComOrderAnalysis["AvgCost"]) + "</td><td>" +
                     eComOrderAnalysis["PriceUOM"].ToString() + "</td><td>" +
                     String.Format("{0:#,##0.00}", eComOrderAnalysis["TotalPrice"]) + "</td><td>" +
                     String.Format("{0:#,##0.00}", eComOrderAnalysis["GrossWeight"]) + "</td></tr>";
            }

            footerContent = "<tr style='font-weight:bold;' align='right'><td colspan='4'>" + "Grand Total" + "</td><td>" +
                     " " + "</td><td>" +
                     " " + "</td><td>" +
                     " " + "</td><td>" +
                     String.Format("{0:#,##0}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(RequestQuantity)", ""))) + "</td><td>" +
                     String.Format("{0:#,##0}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(RunningAvalQty)", ""))) + "</td><td>" +
                     "" + "</td><td>" +
                     String.Format("{0:#,##0.0}", Convert.ToDecimal(dtOrderAnalysis.Compute("Avg(MarginPercentage)", ""))) + "</td><td>" +
                     String.Format("{0:#,##0.00}", Convert.ToDecimal(dtOrderAnalysis.Compute("Avg(AvgCost)", ""))) + "</td><td>" +
                     " " + "</td><td>" +
                     String.Format("{0:#,##0.00}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(TotalPrice)", ""))) + "</td><td>" +
                     String.Format("{0:#,##0.00}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(GrossWeight)", ""))) + "</td></tr></table>";

            //String.Format("{0:#,##0.00}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(GrossWeight)", ""))) + "</td></tr></table>";

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