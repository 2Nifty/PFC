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

public partial class eCommerceSalesAnalysisHdrRpt : System.Web.UI.Page
{
    #region Global Variables
    protected eCommerceReportV2 eCommerceReport = new eCommerceReportV2();
    
    private DataSet dsSalesAnalysisHdr = new DataSet();
    private DataTable dtSalesAnalysisHdr = new DataTable();
    
    private string sortExpression = string.Empty;
    int pagesize = 19;

    string periodMonth = string.Empty;
    string periodYear = string.Empty;
    string branchNo = string.Empty;
    string customerNo = string.Empty;
    string customerName = string.Empty;
    string startDate = string.Empty;
    string endDate = string.Empty;
    string orderSource = "";
    string repNo = "";
    string repName = "";
    string itemNotOrd = "";
    string sourceType = string.Empty;
    #endregion

    #region Page Load
    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        Ajax.Utility.RegisterTypeForAjax(typeof(eCommerceSalesAnalysisHdrRpt));

        #region URL Parameters
        periodMonth = (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "";
        periodYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";
        branchNo = (Request.QueryString["BranchNumber"] != null) ? Request.QueryString["BranchNumber"].ToString().Trim() : "";
        customerNo = (Request.QueryString["CustomerNumber"] != null) ? Request.QueryString["CustomerNumber"].ToString().Trim() : "";
        customerName = (Request.QueryString["CustomerName"] != null) ? Request.QueryString["CustomerName"].ToString().Trim() : "";
        startDate = (Request.QueryString["StartDate"] != null) ? Request.QueryString["StartDate"].ToString().Trim() : "";
        endDate = (Request.QueryString["EndDate"] != null) ? Request.QueryString["EndDate"].ToString().Trim() : "";
        orderSource = (Request.QueryString["OrdSrc"] != null) ? Request.QueryString["OrdSrc"].ToString().Trim() : "";
        repNo = (Request.QueryString["repNo"] != null) ? Request.QueryString["repNo"].ToString().Trim() : "";
        repName = (Request.QueryString["repName"] != null) ? Request.QueryString["repName"].ToString().Trim() : "";
        itemNotOrd = (Request.QueryString["ItemNotOrd"] != null) ? Request.QueryString["ItemNotOrd"].ToString().Trim() : "false";
        sourceType = (Request.QueryString["SrcTyp"] != null) ? Request.QueryString["SrcTyp"].ToString().Trim() : "";
        #endregion

        #region XLS File Name
        string fileTime = DateTime.Now.ToString().Replace("/", "");
        fileTime = fileTime.Replace(" ", "");
        fileTime = fileTime.Replace(":", "");
        hidFileName.Value = "eCommerceSalesAnalysisHdrRpt" + Session["SessionID"].ToString() + fileTime + ".xls";
        //hidFileName.Value = "eCommerceSalesAnalysisHdrRpt" + fileTime + ".xls";
        #endregion

        if (!IsPostBack)
        {
            switch (sourceType)
            {
                case "ECOMM":
                    lblSourceType.Text = "eCommerce Quotes";
                    break;
                case "MANUAL":
                    lblSourceType.Text = "Manual Quotes";
                    break;
                case "ECOMM_ORD":
                    lblSourceType.Text = "eCommerce Orders";
                    break;
                case "MANUAL_ORD":
                    lblSourceType.Text = "Manual Orders";
                    break;
                case "MISSED_ECOMM":
                    lblSourceType.Text = "Missed eCommerce Quotes";
                    break;
                case "MISSED_MANUAL":
                    lblSourceType.Text = "Missed Manual Quotes";
                    break;
            }
            BindDataGrid();
        }
    }
    #endregion

    #region DataGrid
    private void BindDataGrid()
    {
        sortExpression = ((hidSort.Value != "") ? hidSort.Value : "QuoteNumber");

        dsSalesAnalysisHdr = eCommerceReport.GetHdrData(periodMonth, periodYear, startDate, endDate, branchNo, customerNo, orderSource, sourceType, itemNotOrd);
        dtSalesAnalysisHdr = dsSalesAnalysisHdr.Tables[0].DefaultView.ToTable();
        dtSalesAnalysisHdr.DefaultView.Sort = sortExpression;

        if (dtSalesAnalysisHdr.Rows.Count > 0)
        {
            dgSalesAnalysisHdr.DataSource = dtSalesAnalysisHdr.DefaultView.ToTable();
            Pager1.Visible = true;
            Pager1.InitPager(dgSalesAnalysisHdr, pagesize);
            lblStatus.Visible = false;
        }
        else
        {
            Pager1.Visible = false;
            lblStatus.Visible = true;
            lblStatus.Text = "No Records Found";
        }
    }

    protected void dgSalesAnalysisHdr_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        #region Grid Items
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            HyperLink _hplLineCount = e.Item.FindControl("hplLineCount") as HyperLink;
            _hplLineCount.ForeColor = System.Drawing.Color.Blue;
            _hplLineCount.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'eCommDTL', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");

            //Set the URL for Quote detail or Order detail
            if (sourceType == "ECOMM_ORD" || sourceType == "MANUAL_ORD")
            {
                _hplLineCount.NavigateUrl = "OrderAnalysisDtlRpt.aspx";
            }
            else
            {
                _hplLineCount.NavigateUrl = "QuoteAnalysisDtlRpt.aspx";
            }
            _hplLineCount.NavigateUrl += "?Month=" + periodMonth +
                                         "&Year=" + periodYear +
                                         "&StartDate=" + startDate +
                                         "&EndDate=" + endDate +
                                         "&CustomerNumber=" + customerNo +
                                         "&CustomerName=" + customerName +
                                         "&RepName=" + repName +
                                         "&RepNo=" + repNo +
                                         "&OrdSrc=" + orderSource +
                                         "&ItemNotOrd=" + itemNotOrd +
                                         "&SrcTyp=" + sourceType +
                                         "&QuoteNumber=" + e.Item.Cells[3].Text.ToString().Trim();
        }
        #endregion

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

            e.Item.Cells[5].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtSalesAnalysisHdr.Compute("sum(LineCount)", "")));
            e.Item.Cells[6].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtSalesAnalysisHdr.Compute("sum(RequestQuantity)", "")));
            e.Item.Cells[7].Text = String.Format("{0:c}", Convert.ToDecimal(dtSalesAnalysisHdr.Compute("sum(ExtPrice)", "")));
            e.Item.Cells[8].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtSalesAnalysisHdr.Compute("sum(ExtWeight)", "")));
        }
        #endregion
    }

    protected void dgSalesAnalysisHdr_SortCommand(object source, DataGridSortCommandEventArgs e)
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

    protected void dgSalesAnalysisHdr_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page # and rebind data grid
        dgSalesAnalysisHdr.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
    }
    
    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgSalesAnalysisHdr.CurrentPageIndex = Pager1.GotoPageNumber;
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

        dsSalesAnalysisHdr = eCommerceReport.GetHdrData(periodMonth, periodYear, startDate, endDate, branchNo, customerNo, orderSource, sourceType, itemNotOrd);
        dtSalesAnalysisHdr = dsSalesAnalysisHdr.Tables[0].DefaultView.ToTable();
        dtSalesAnalysisHdr.DefaultView.Sort = sortExpression;

        #region XLS Title & Headers
        //XLS Title
        headerContent = "<table border='1'>";
        headerContent += "<tr><th colspan='9' style='color:blue; font-size:large;'>Quote and Order Header Report</th></tr>";
        headerContent += "<tr><th colspan='9' style='color:blue'><center>" + lblSourceType.Text.ToString().Trim() + "</center></th></tr>";
        headerContent += "<tr><th colspan='9' style='color:blue'><center>";
        headerContent += "Customer # " + Request.QueryString["CustomerNumber"].ToString() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        headerContent += "Customer Name: " + Request.QueryString["CustomerName"].ToString() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        headerContent += "Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        headerContent += "Run Date: " + DateTime.Now.ToShortDateString() + "</center></th></tr>";
        //XLS Header
        headerContent += "<tr><th>Quote Method</th>";
        headerContent += "<th>Quote Date</th>";
        headerContent += "<th>Expiry Date</th>";
        headerContent += "<th>Quote No</th>";
        headerContent += "<th>Brn</th>";
        headerContent += "<th>Line Count</th>";
        headerContent += "<th>Total Req Qty</th>";
        headerContent += "<th>Total Price</th>";
        headerContent += "<th>Total Weight</th></tr>";
        #endregion

        #region XLS Detail & Footers
        if (dtSalesAnalysisHdr.Rows.Count > 0)
        {
            foreach (DataRow SalesAnalysisHdr in dtSalesAnalysisHdr.DefaultView.ToTable().Rows)
            {
                excelContent += "<tr><td>" + SalesAnalysisHdr["QuoteMethod"].ToString().Trim() + "</td>" + 
                                    "<td>" + String.Format("{0:MM/dd/yyyy}", SalesAnalysisHdr["QuotationDate"]) + "</td>" +
                                    "<td>" + String.Format("{0:MM/dd/yyyy}", SalesAnalysisHdr["ExpiryDate"]) + "</td>" +
                                    "<td>" + SalesAnalysisHdr["QuoteNumber"].ToString().Trim() + "</td>" + 
                                    "<td>" + SalesAnalysisHdr["SalesBranchofRecord"].ToString().Trim() + "</td>" +
                                    "<td>" + String.Format("{0:#,##0}", SalesAnalysisHdr["LineCount"]) + "</td>" +
                                    "<td>" + String.Format("{0:#,##0}", SalesAnalysisHdr["RequestQuantity"]) + "</td>" +
                                    "<td>" + String.Format("{0:#,##0.00}", SalesAnalysisHdr["ExtPrice"]) + "</td>" +
                                    "<td>" + String.Format("{0:#,##0.00}", SalesAnalysisHdr["ExtWeight"]) + "</td></tr>";
            }

            //XLS Footer
            footerContent = "<tr style='font-weight:bold;' align='right'><td colspan='5'><center>" + "Grand Total" + "</center></td><td>";
            footerContent += String.Format("{0:#,##0}", Convert.ToDecimal(dtSalesAnalysisHdr.Compute("sum(LineCount)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0}", Convert.ToDecimal(dtSalesAnalysisHdr.Compute("sum(RequestQuantity)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0.00}", Convert.ToDecimal(dtSalesAnalysisHdr.Compute("sum(ExtPrice)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0.00}", Convert.ToDecimal(dtSalesAnalysisHdr.Compute("sum(ExtWeight)", ""))) + "</td></tr></table>";
        }
        #endregion

        reportWriter.WriteLine(headerContent + excelContent + footerContent);
        reportWriter.Close();

        #region Download & Open
        FileStream fileStream = File.Open(Server.MapPath("..//Common//ExcelUploads//" + hidFileName.Value.ToString()), FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath("..//Common//ExcelUploads//" + hidFileName.Value.ToString())));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
        #endregion
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
