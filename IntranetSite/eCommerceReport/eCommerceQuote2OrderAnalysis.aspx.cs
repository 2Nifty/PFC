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
using PFC.Intranet.eCommerceReport;

#endregion

public partial class eCommerceQuoteToOrderAnalysis : System.Web.UI.Page
{
    #region Global Variables

    private string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    private DataTable dtQuoteAndOrder = new DataTable();
    private DataTable dtQuote2Order = new DataTable();

    private string keyColumn = "customerNumber";
    private string sortExpression = string.Empty;
    private string WhereMonth = string.Empty;

    string periodMonth = string.Empty;
    string periodYear = string.Empty;
    string startDate = string.Empty;
    string endDate = string.Empty;
    string locationCode = string.Empty;
    string repNo = "";
    string repName = "";
    string priceCdCtl = "";

    int pagesize = 19;
    string customerNo = string.Empty;
    
    protected eCommerceReport eCommerceReport = new eCommerceReport();
    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(eCommerceQuoteToOrderAnalysis));

        SystemCheck systemCheck = new SystemCheck();
        //Comment should be removed
        //systemCheck.SessionCheck();

        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");        

        periodMonth = (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "";
        periodYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";

        customerNo = (Request.QueryString["CustNo"] != null) ? Request.QueryString["CustNo"].ToString().Trim() : "";
        startDate = (Request.QueryString["StartDate"] != null) ? Request.QueryString["StartDate"].ToString().Trim() : "";
        endDate = (Request.QueryString["EndDate"] != null) ? Request.QueryString["EndDate"].ToString().Trim() : "";
        locationCode = (Request.QueryString["Branch"] != null) ? Request.QueryString["Branch"].ToString().Trim() : "";
        repNo = Request.QueryString["RepNo"].ToString().Trim();
        repName = Request.QueryString["RepName"].ToString().Trim();
        priceCdCtl = (Request.QueryString["PriceCdCtl"] != null) ? Request.QueryString["PriceCdCtl"].ToString().Trim() : "false";

        hidFileName.Value = "eCommerceQuote2Order"+Session["SessionID"].ToString()  + name + ".xls";
        if (!IsPostBack)
            BindDataGrid();
    } 

    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        sortExpression = ((hidSort.Value != "") ?  hidSort.Value : keyColumn);

        //dtQuoteAndOrder = eCommerceReport.GetQuote2OrderData(periodMonth, periodYear,customerNo);
        //dtQuote2Order = eCommerceReport.CreateJoins(dtQuoteAndOrder, GetCustomers());
        //dtQuote2Order.DefaultView.Sort = hidSort.Value;

        dtQuote2Order = eCommerceReport.GetQuote2OrderData(periodMonth, periodYear, startDate, endDate, locationCode, customerNo, repNo, priceCdCtl);
        

        if (dtQuote2Order != null && dtQuote2Order.Rows.Count > 0)
        {
            dtQuote2Order.DefaultView.Sort = hidSort.Value;
            dgQuote2Order.DataSource = dtQuote2Order.DefaultView.ToTable();
            Pager1.Visible = true;
            Pager1.InitPager(dgQuote2Order, pagesize);
            lblStatus.Visible = false;
        }
        else
        {
            Pager1.Visible = false;
            lblStatus.Visible = true;
            lblStatus.Text = "No Records Found";
        }
    }
   
    #endregion

    #region Events

    protected void dgQuote2Order_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            HyperLink hplButton = e.Item.FindControl("hplNoOfQuotes") as HyperLink;
            hplButton.ForeColor = System.Drawing.Color.Blue;
            hplButton.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'Quote', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");

            HyperLink hplOrders = e.Item.FindControl("hplNoOfOrders") as HyperLink;
            hplOrders.ForeColor = System.Drawing.Color.Blue;
            hplOrders.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'Order', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");
        }
    //   " <Div onclick=\"javascript:BindValue('NoOfQuotes');">&nbsp;# of Quotes</div>
        if (e.Item.ItemType == ListItemType.Header)
        {
            e.Item.Cells[3].ColumnSpan = 3;
            e.Item.Cells[3].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr>"+
                                "<td class='GridHead splitBorder' colspan=3 nowrap >Quotes</td></tr><tr>"+
                                "<td width='35' class='GridHead splitBorders' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('NoOfQuotes');\">&nbsp;# of Quotes</div></center>"+
                                "</td><td width='100' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('ExtAmount');\">&nbsp;Extended $ Amnt</div></td>"+
                                "<td width='100' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('ExtWeight');\">&nbsp;Extended Weight</div></td></tr></table>";
            e.Item.Cells[4].Visible = false;
            e.Item.Cells[5].Visible = false;
            e.Item.Cells[6].ColumnSpan = 3;
            e.Item.Cells[6].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr>"+
                                "<td class='GridHead splitBorder' colspan=3 nowrap >Orders</td></tr><tr>"+
                                "<td width='35' class='GridHead splitBorders' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('NoOfOrders');\">&nbsp;# of Orders</div></center></td>"+
                                "<td width='100' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('ExtOrdAmount');\">Extended $ Amnt</div></td>"+
                                "<td width='100' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('ExtOrdWeight');\">Extended Weight</div></td></tr></table>";
            e.Item.Cells[7].Visible = false;
            e.Item.Cells[8].Visible = false;
        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].ColumnSpan = 3;
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[1].Visible = false;
            e.Item.Cells[2].Visible = false;
            e.Item.Cells[3].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtQuote2Order.Compute("sum(NoOfQuotes)", "")));
            e.Item.Cells[4].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuote2Order.Compute("sum(ExtAmount)", "")));
            e.Item.Cells[5].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuote2Order.Compute("sum(ExtWeight)", "")));
            e.Item.Cells[6].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtQuote2Order.Compute("sum(NoOfOrders)", "")));
            e.Item.Cells[7].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuote2Order.Compute("sum(ExtOrdAmount)", "")));
            e.Item.Cells[8].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuote2Order.Compute("sum(ExtOrdWeight)", "")));
        }
    }


    public DataTable GetCustomers()
    {
        string _connectionString = ConfigurationManager.AppSettings["NavisionConnectionString"].ToString();
        string _tableName = "Porteous$Customer";
        string _columnName = "[No_],[Location Code]";
        string _whereClause = "1=1";

        DataSet dsCustomers = (DataSet)SqlHelper.ExecuteDataset(_connectionString, "UGEN_SP_Select",
                                                   new SqlParameter("@tableName", _tableName),
                                                   new SqlParameter("@columnNames", _columnName),
                                                   new SqlParameter("@whereClause", _whereClause));
        return dsCustomers.Tables[0];

    }


    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgQuote2Order.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void dgQuote2Order_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgQuote2Order.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
    }
    protected void btnSort_Click(object source, EventArgs e)
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

        hidSort.Value = hidSortExpression.Value+  " " + hidSort.Attributes["sortType"].ToString();
        BindDataGrid();
    }
    protected void dgQuote2Order_SortCommand(object source, DataGridSortCommandEventArgs e)
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

    #endregion

    #region Write to Excel

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        string sortExpression = ((hidSort.Value != "") ? hidSort.Value : keyColumn);

        //dtQuoteAndOrder = eCommerceReport.GetQuote2OrderData(periodMonth, periodYear, customerNo);
        //dtQuote2Order = eCommerceReport.CreateJoins(dtQuoteAndOrder, GetCustomers());
        //dtQuote2Order.DefaultView.Sort = sortExpression;

        dtQuote2Order = eCommerceReport.GetQuote2OrderData(periodMonth, periodYear, startDate, endDate, locationCode, customerNo, repNo, priceCdCtl);
        dtQuote2Order.DefaultView.Sort = hidSort.Value;
        string custNumber = (Request.QueryString["CustNo"].ToString() == "") ? "All" : Request.QueryString["CustNo"].ToString();
        headerContent = "<table border='1'>";
        headerContent += "<tr><th colspan='9' style='color:blue'>eCommerce Quote and Order Analysis Report</th></tr>";
        headerContent += "<tr id=trHead class=PageBg ><td colspan=9><b><table cellpadding=1 cellspacing=0 width=100<tr><td class=LeftPadding TabHead style=width:110px>Customer # " + custNumber + "</td>" +
            "<td class=LeftPadding TabHead style=width:180px>Branch: " + Request.QueryString["BranchName"].ToString() + "</td><td class=TabHead  style=width:200px>Period: " + Request.QueryString["MonthName"].ToString() + Request.QueryString["StartDate"].ToString() + "-" + Request.QueryString["Year"].ToString() + Request.QueryString["EndDate"].ToString() +
            "</td><td width=200px;>CSR Name: "+ repName +"</td><td width=200px;>&nbsp;</td><td class=TabHead style=width:130px>Run By: " + Session["UserName"].ToString() + "</td><td class=TabHead style=width:130px>Run Date :" + DateTime.Now.ToShortDateString() + "</td></tr></table></b></td></tr>";

        headerContent += "<tr><th>Cust #</th><th>Name</th><th>Brn</th><th># of Quotes</th><th>Extended $ Amnt</th><th>Extended Weight</th><th># of Orders</th><th>Extended $ Amnt</th><th>Extended Weight</th>";

        if (dtQuote2Order.Rows.Count > 0)
        {
            foreach (DataRow eComQuoteAndOrder in dtQuote2Order.DefaultView.ToTable().Rows)
            {
                excelContent += "<tr><td>&nbsp;" + eComQuoteAndOrder["customerNumber"].ToString() + "</td><td>" +
                     eComQuoteAndOrder["customerName"].ToString() + "</td><td>&nbsp;" +
                     eComQuoteAndOrder["SalesLocationCode"].ToString() + "</td><td>" +
                     String.Format("{0:#,##}", eComQuoteAndOrder["NoOfQuotes"]) + "</td><td>" +
                     String.Format("{0:#,##0.00}", eComQuoteAndOrder["ExtAmount"]) + "</td><td>" +
                     String.Format("{0:#,##0.0}", eComQuoteAndOrder["ExtWeight"]) + "</td><td>" +
                     String.Format("{0:#,##0.0}", eComQuoteAndOrder["NoOfOrders"]) + "</td><td>" +
                     String.Format("{0:#,##0.00}", eComQuoteAndOrder["ExtOrdAmount"]) + "</td><td>" +
                     String.Format("{0:#,##0.0}", eComQuoteAndOrder["ExtOrdWeight"]) + "</td></tr>";
            }

            footerContent = "<tr style='font-weight:bold;' align='right'><td colspan='3' style='align:center;'>" + "Grand Total" + "</td><td>" +
                      String.Format("{0:#,##}", Convert.ToDecimal(dtQuote2Order.Compute("sum(NoOfQuotes)", ""))) + "</td><td>" +
                      String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuote2Order.Compute("sum(ExtAmount)", ""))) + "</td><td>" +
                      String.Format("{0:#,##0.0}", Convert.ToDecimal(dtQuote2Order.Compute("sum(ExtWeight)", ""))) + "</td><td>" +
                      String.Format("{0:#,##}", Convert.ToDecimal(dtQuote2Order.Compute("sum(NoOfOrders)", ""))) + "</td><td>" +
                      String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuote2Order.Compute("sum(ExtOrdAmount)", ""))) + "</td><td>" +
                      String.Format("{0:#,##0.0}", Convert.ToDecimal(dtQuote2Order.Compute("sum(ExtOrdWeight)", ""))) + "</td></tr></table>";
        }
        reportWriter.WriteLine(headerContent + excelContent + footerContent);
        reportWriter.Close();


        //
        // Downloding Process
        //
        FileStream fileStream = File.Open(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()), FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        //
        // Download Process
        //
        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString())));
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

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\eCommerceReport\\Common\\ExcelUploads"));

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
