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

public partial class eCommerceSalesAnalysisCustRpt : System.Web.UI.Page
{
    protected eCommerceReportV2 eCommerceReportV2 = new eCommerceReportV2();

    #region Global Variables
    private DataTable dtQuoteAndOrder = new DataTable();
    private DataTable dtECommSales = new DataTable();

    int pagesize = 17;
    private string keyColumn = "customerNumber";
    private string sortExpression = string.Empty;
    private string WhereMonth = string.Empty;

    string periodMonth = string.Empty;
    string periodYear = string.Empty;
    string locationCode = string.Empty;
    string customerNo = string.Empty;
    string startDate = string.Empty;
    string endDate = string.Empty;
    string orderSource = "";
    string repNo = "";
    string repName = "";
    string priceCdCtl = "";
    string itemNotOrd = "";
    #endregion

    #region Page Load
    protected void Page_Load(object sender, EventArgs e)
    {
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(eCommerceSalesAnalysisCustRpt));

        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");
        hidFileName.Value = "eCommerceSalesAnalysis" + Session["SessionID"].ToString() + name + ".xls";

        #region URL Parameters
        periodMonth = (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "";
        periodYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";
        locationCode = (Request.QueryString["Branch"] != null) ? Request.QueryString["Branch"].ToString().Trim() : "";
        customerNo = (Request.QueryString["CustNo"] != null) ? Request.QueryString["CustNo"].ToString().Trim() : "";
        startDate = (Request.QueryString["StartDate"] != null) ? Request.QueryString["StartDate"].ToString().Trim() : "";
        endDate = (Request.QueryString["EndDate"] != null) ? Request.QueryString["EndDate"].ToString().Trim() : "";
        orderSource = (Request.QueryString["OrdSrc"] != null) ? Request.QueryString["OrdSrc"].ToString().Trim() : "";
        repNo = Request.QueryString["RepNo"].ToString().Trim();
        repName = Request.QueryString["RepName"].ToString().Trim();
        priceCdCtl = (Request.QueryString["PriceCdCtl"] != null) ? Request.QueryString["PriceCdCtl"].ToString().Trim() : "false";
        itemNotOrd = (Request.QueryString["ItemNotOrd"] != null) ? Request.QueryString["ItemNotOrd"].ToString().Trim() : "false";
        #endregion

        if (!IsPostBack)
            BindDataGrid();
    }
    #endregion

    #region DataGrid
    private void BindDataGrid()
    {
        sortExpression = ((hidSort.Value != "") ? hidSort.Value : keyColumn);

        dtECommSales = eCommerceReportV2.GetQuoteAndOrderData(periodMonth, periodYear, startDate, endDate, locationCode, customerNo, repNo, priceCdCtl, orderSource, itemNotOrd);

        if (dtECommSales != null && dtECommSales.Rows.Count > 0)
        {
            dtECommSales.DefaultView.Sort = hidSort.Value;
            dgECommSales.DataSource = dtECommSales.DefaultView.ToTable();
            Pager1.Visible = true;
            Pager1.InitPager(dgECommSales, pagesize);
            lblStatus.Visible = false;
        }
        else
        {
            Pager1.Visible = false;
            lblStatus.Visible = true;
            lblStatus.Text = "No Records Found";
        }
    }

    protected void dgECommSales_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        #region Grid Header
        if (e.Item.ItemType == ListItemType.Header)
        {

            //eComm Quote Columns
            e.Item.Cells[3].ColumnSpan = 3;
            e.Item.Cells[3].Text = "<table border='0' cellpadding='0' cellspacing='0' Height='10px'><tr>" +
                                    "<td class='GridPad Border1' colspan=3 nowrap >eComm Quotes</td></tr><tr>" +
                                    "<td width='35' class='GridPad Border2' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('NoOfECommQuotes');\">&nbsp;# of Quotes</div></center>" +
                                    "</td><td width='100' class='GridPad Border2' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('eCommExtAmount');\">&nbsp;Extended $ Amt</div></td>" +
                                    "<td width='100' class='GridPad' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('eCommExtWeight');\">&nbsp;Extended Weight</div></td></tr></table>";
            e.Item.Cells[4].Visible = false;
            e.Item.Cells[5].Visible = false;

            //eComm Order Columns
            e.Item.Cells[6].ColumnSpan = 3;
            e.Item.Cells[6].Text = "<table border='0' cellpadding='0' cellspacing='0' Height='10px'><tr>" +
                                    "<td class='GridPad Border1' colspan=3 nowrap >eComm Orders</td></tr><tr>" +
                                    "<td width='35' class='GridPad Border2' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('NoOfECommOrders');\">&nbsp;# of Orders</div></center></td>" +
                                    "<td width='100' class='GridPad Border2' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('eCommExtOrdAmount');\">Extended $ Amt</div></td>" +
                                    "<td width='100' class='GridPad' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('eCommExtOrdWeight');\">Extended Weight</div></td></tr></table>";
            e.Item.Cells[7].Visible = false;
            e.Item.Cells[8].Visible = false;

            //Manual Quote Columns
            e.Item.Cells[9].ColumnSpan = 3;
            e.Item.Cells[9].Text = "<table border='0' cellpadding='0' cellspacing='0' Height='10px'><tr>" +
                                    "<td class='GridPad Border1' colspan=3 nowrap >Manual Quotes</td></tr><tr>" +
                                    "<td width='35' class='GridPad Border2' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('NoOfManualQuotes');\">&nbsp;# of Quotes</div></center>" +
                                    "</td><td width='100' class='GridPad Border2' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('ManualExtAmount');\">&nbsp;Extended $ Amt</div></td>" +
                                    "<td width='100' class='GridPad' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('ManualExtWeight');\">&nbsp;Extended Weight</div></td></tr></table>";
            e.Item.Cells[10].Visible = false;
            e.Item.Cells[11].Visible = false;

            //Manual Order Columns
            e.Item.Cells[12].ColumnSpan = 3;
            e.Item.Cells[12].Text = "<table border='0' cellpadding='0' cellspacing='0' Height='10px'><tr>" +
                                    "<td class='GridPad Border1' colspan=3 nowrap >Manual Orders</td></tr><tr>" +
                                    "<td width='35' class='GridPad Border2' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('NoOfManualOrders');\">&nbsp;# of Orders</div></center></td>" +
                                    "<td width='100' class='GridPad Border2' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('ManualExtOrdAmount');\">Extended $ Amt</div></td>" +
                                    "<td width='100' class='GridPad' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('ManualExtOrdWeight');\">Extended Weight</div></td></tr></table>";
            e.Item.Cells[13].Visible = false;
            e.Item.Cells[14].Visible = false;

            //Missed eComm Quote Columns
            e.Item.Cells[15].ColumnSpan = 3;
            e.Item.Cells[15].Text = "<table border='0' cellpadding='0' cellspacing='0' Height='10px'><tr>" +
                                    "<td class='GridPad Border1' colspan=3 nowrap >Missed eComm Quotes</td></tr><tr>" +
                                    "<td width='35' class='GridPad Border2' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('NoOfMissedECommQuotes');\">&nbsp;# of Quotes</div></center>" +
                                    "</td><td width='100' class='GridPad Border2' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('MissedECommExtAmount');\">&nbsp;Extended $ Amt</div></td>" +
                                    "<td width='100' class='GridPad' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('MissedECommExtWeight');\">&nbsp;Extended Weight</div></td></tr></table>";
            e.Item.Cells[16].Visible = false;
            e.Item.Cells[17].Visible = false;

            //Missed Manual Quote Columns
            e.Item.Cells[18].ColumnSpan = 3;
            e.Item.Cells[18].Text = "<table border='0' cellpadding='0' cellspacing='0' Height='10px'><tr>" +
                                    "<td class='GridPad Border1' colspan=3 nowrap >Missed Manual Quotes</td></tr><tr>" +
                                    "<td width='35' class='GridPad Border2' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('NoOfMissedManualQuotes');\">&nbsp;# of Quotes</div></center></td>" +
                                    "<td width='100' class='GridPad Border2' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('MissedManualExtAmount');\">Extended $ Amt</div></td>" +
                                    "<td width='100' class='GridPad' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('MissedManualExtWeight');\">Extended Weight</div></td></tr></table>";
            e.Item.Cells[19].Visible = false;
            e.Item.Cells[20].Visible = false;
        }
        #endregion

        #region Grid Items
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            //eComm Quote & Order Links
            HyperLink _hplNoOfECommQuotes = e.Item.FindControl("hplNoOfECommQuotes") as HyperLink;
            _hplNoOfECommQuotes.ForeColor = System.Drawing.Color.Blue;
            _hplNoOfECommQuotes.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'eCommHDR', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");

            HyperLink _hplNoOfECommOrders = e.Item.FindControl("hplNoOfECommOrders") as HyperLink;
            _hplNoOfECommOrders.ForeColor = System.Drawing.Color.Blue;
            _hplNoOfECommOrders.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'eCommHDR', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");

            //Manual Quote & Order Links
            HyperLink _hplNoOfManualQuotes = e.Item.FindControl("hplNoOfManualQuotes") as HyperLink;
            _hplNoOfManualQuotes.ForeColor = System.Drawing.Color.Blue;
            _hplNoOfManualQuotes.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'eCommHDR', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");

            HyperLink _hplNoOfManualOrders = e.Item.FindControl("hplNoOfManualOrders") as HyperLink;
            _hplNoOfManualOrders.ForeColor = System.Drawing.Color.Blue;
            _hplNoOfManualOrders.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'eCommHDR', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");

            //Missed eComm & Manual Quote Links
            HyperLink _hplNoOfMissedECommQuotes = e.Item.FindControl("hplNoOfMissedECommQuotes") as HyperLink;
            _hplNoOfMissedECommQuotes.ForeColor = System.Drawing.Color.Blue;
            _hplNoOfMissedECommQuotes.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'eCommHDR', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");

            HyperLink _hplNoOfMissedManualQuotes = e.Item.FindControl("hplNoOfMissedManualQuotes") as HyperLink;
            _hplNoOfMissedManualQuotes.ForeColor = System.Drawing.Color.Blue;
            _hplNoOfMissedManualQuotes.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'eCommHDR', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");
        }
        #endregion

        #region Grid Footer
        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].ColumnSpan = 3;
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[1].Visible = false;
            e.Item.Cells[2].Visible = false;

            //eComm Quote Totals
            e.Item.Cells[3].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtECommSales.Compute("sum(NoOfECommQuotes)", "")));
            e.Item.Cells[4].Text = String.Format("{0:c}", Convert.ToDecimal(dtECommSales.Compute("sum(ECommExtAmount)", "")));
            e.Item.Cells[5].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtECommSales.Compute("sum(ECommExtWeight)", "")));

            //eComm Order Totals
            e.Item.Cells[6].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtECommSales.Compute("sum(NoOfECommOrders)", "")));
            e.Item.Cells[7].Text = String.Format("{0:c}", Convert.ToDecimal(dtECommSales.Compute("sum(ECommExtOrdAmount)", "")));
            e.Item.Cells[8].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtECommSales.Compute("sum(ECommExtOrdWeight)", "")));

            //Manual Quote Totals
            e.Item.Cells[9].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtECommSales.Compute("sum(NoOfManualQuotes)", "")));
            e.Item.Cells[10].Text = String.Format("{0:c}", Convert.ToDecimal(dtECommSales.Compute("sum(ManualExtAmount)", "")));
            e.Item.Cells[11].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtECommSales.Compute("sum(ManualExtWeight)", "")));

            //Manual Order Totals
            e.Item.Cells[12].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtECommSales.Compute("sum(NoOfManualOrders)", "")));
            e.Item.Cells[13].Text = String.Format("{0:c}", Convert.ToDecimal(dtECommSales.Compute("sum(ManualExtOrdAmount)", "")));
            e.Item.Cells[14].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtECommSales.Compute("sum(ManualExtOrdWeight)", "")));

            //Missed eComm Quote Totals
            e.Item.Cells[15].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtECommSales.Compute("sum(NoOfMissedECommQuotes)", "")));
            e.Item.Cells[16].Text = String.Format("{0:c}", Convert.ToDecimal(dtECommSales.Compute("sum(MissedECommExtAmount)", "")));
            e.Item.Cells[17].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtECommSales.Compute("sum(MissedECommExtWeight)", "")));

            //Missed Manual Quote Totals
            e.Item.Cells[18].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtECommSales.Compute("sum(NoOfMissedManualQuotes)", "")));
            e.Item.Cells[19].Text = String.Format("{0:c}", Convert.ToDecimal(dtECommSales.Compute("sum(MissedManualExtAmount)", "")));
            e.Item.Cells[20].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtECommSales.Compute("sum(MissedManualExtWeight)", "")));
        }
        #endregion
    }

    protected void dgECommSales_SortCommand(object source, DataGridSortCommandEventArgs e)
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

    protected void dgECommSales_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        dgECommSales.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgECommSales.CurrentPageIndex = Pager1.GotoPageNumber;
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

        hidSort.Value = hidSortExpression.Value + " " + hidSort.Attributes["sortType"].ToString();
        BindDataGrid();
    }
    #endregion

    #region XLS Export
    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + hidFileName.Value.ToString()));
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        string sortExpression = ((hidSort.Value != "") ? hidSort.Value : keyColumn);

        dtECommSales = eCommerceReportV2.GetQuoteAndOrderData(periodMonth, periodYear, startDate, endDate, locationCode, customerNo, repNo, priceCdCtl, orderSource, itemNotOrd);
        dtECommSales.DefaultView.Sort = hidSort.Value;
        string custNumber = (Request.QueryString["CustNo"].ToString() == "") ? "All" : Request.QueryString["CustNo"].ToString();

        #region XLS Title & Headers
        //XLS Title
        headerContent = "<table border='1'>";
        headerContent += "<tr><th colspan='21' style='color:blue; font-size:large;'>eCommerce Quote and Order Customer Report</th></tr>";
        headerContent += "<tr><th colspan='21' style='color:blue'><center>";
        headerContent += "Customer # " + custNumber + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        headerContent += "Branch: " + Request.QueryString["BranchName"].ToString().Trim() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        headerContent += "Period: " + Request.QueryString["MonthName"].ToString().Trim() + Request.QueryString["StartDate"].ToString().Trim() + "-" + Request.QueryString["Year"].ToString().Trim() + Request.QueryString["EndDate"].ToString().Trim() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        headerContent += "CSR: " + repName + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        headerContent += "Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        headerContent += "Run Date :" + DateTime.Now.ToShortDateString() + "</center></th></tr>";

        //XLS Header Line 1
        headerContent += "<tr><th colspan='3'>&nbsp;</th>";
        headerContent += "<th colspan='3'>eComm Quotes</th>";
        headerContent += "<th colspan='3'>eComm Orders</th>";
        headerContent += "<th colspan='3'>Manual Quotes</th>";
        headerContent += "<th colspan='3'>Manual Orders</th>";
        headerContent += "<th colspan='3'>Missed eComm Quotes</th>";
        headerContent += "<th colspan='3'>Missed Manual Quotes</th></tr>";

        //XLS Header Line 2
        headerContent += "<tr><th>Cust #</th>";
        headerContent += "<th>Name</th>";
        headerContent += "<th>Brn</th>";
        //eComm Quotes & Orders
        headerContent += "<th># of Quotes</th>";
        headerContent += "<th>Extended $ Amt</th>";
        headerContent += "<th>Extended Weight</th>";
        headerContent += "<th># of Orders</th>";
        headerContent += "<th>Extended $ Amt</th>";
        headerContent += "<th>Extended Weight</th>";
        //Manual Quotes & Orders
        headerContent += "<th># of Quotes</th>";
        headerContent += "<th>Extended $ Amt</th>";
        headerContent += "<th>Extended Weight</th>";
        headerContent += "<th># of Orders</th>";
        headerContent += "<th>Extended $ Amt</th>";
        headerContent += "<th>Extended Weight</th>";
        //Missed eComm & Manual Quotes
        headerContent += "<th># of Quotes</th>";
        headerContent += "<th>Extended $ Amt</th>";
        headerContent += "<th>Extended Weight</th>";
        headerContent += "<th># of Quotes</th>";
        headerContent += "<th>Extended $ Amt</th>";
        headerContent += "<th>Extended Weight</th></tr>";
        #endregion

        #region XLS Detail & Footers
        excelContent = string.Empty;
        if (dtECommSales.Rows.Count > 0)
        {
            //XLS Detail
            foreach (DataRow eComQuoteAndOrder in dtECommSales.DefaultView.ToTable().Rows)
            {
                excelContent += "<tr><td>&nbsp;" + eComQuoteAndOrder["customerNumber"].ToString() + "</td><td>";
                excelContent += eComQuoteAndOrder["customerName"].ToString() + "</td><td>&nbsp;";
                excelContent += eComQuoteAndOrder["SalesLocationCode"].ToString() + "</td><td>";

                excelContent += String.Format("{0:#,##0}", eComQuoteAndOrder["NoOfECommQuotes"]) + "</td><td>";
                excelContent += String.Format("{0:#,##0.00}", eComQuoteAndOrder["ECommExtAmount"]) + "</td><td>";
                excelContent += String.Format("{0:#,##0.0}", eComQuoteAndOrder["ECommExtWeight"]) + "</td><td>";
                excelContent += String.Format("{0:#,##0}", eComQuoteAndOrder["NoOfECommOrders"]) + "</td><td>";
                excelContent += String.Format("{0:#,##0.00}", eComQuoteAndOrder["ECommExtOrdAmount"]) + "</td><td>";
                excelContent += String.Format("{0:#,##0.0}", eComQuoteAndOrder["ECommExtOrdWeight"]) + "</td><td>";

                excelContent += String.Format("{0:#,##0}", eComQuoteAndOrder["NoOfManualQuotes"]) + "</td><td>";
                excelContent += String.Format("{0:#,##0.00}", eComQuoteAndOrder["ManualExtAmount"]) + "</td><td>";
                excelContent += String.Format("{0:#,##0.0}", eComQuoteAndOrder["ManualExtWeight"]) + "</td><td>";
                excelContent += String.Format("{0:#,##0}", eComQuoteAndOrder["NoOfManualOrders"]) + "</td><td>";
                excelContent += String.Format("{0:#,##0.00}", eComQuoteAndOrder["ManualExtOrdAmount"]) + "</td><td>";
                excelContent += String.Format("{0:#,##0.0}", eComQuoteAndOrder["ManualExtOrdWeight"]) + "</td><td>";

                excelContent += String.Format("{0:#,##0}", eComQuoteAndOrder["NoOfMissedECommQuotes"]) + "</td><td>";
                excelContent += String.Format("{0:#,##0.00}", eComQuoteAndOrder["MissedECommExtAmount"]) + "</td><td>";
                excelContent += String.Format("{0:#,##0.0}", eComQuoteAndOrder["MissedECommExtWeight"]) + "</td><td>";
                excelContent += String.Format("{0:#,##0}", eComQuoteAndOrder["NoOfMissedManualQuotes"]) + "</td><td>";
                excelContent += String.Format("{0:#,##0.00}", eComQuoteAndOrder["MissedManualExtAmount"]) + "</td><td>";
                excelContent += String.Format("{0:#,##0.0}", eComQuoteAndOrder["MissedManualExtWeight"]) + "</td></tr>";
            }

            //XLS Footer
            footerContent = "<tr style='font-weight:bold;'><td colspan='3'><center>" + "Grand Total" + "</center></td><td>";
            footerContent += String.Format("{0:#,##0}", Convert.ToDecimal(dtECommSales.Compute("sum(NoOfECommQuotes)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0.00}", Convert.ToDecimal(dtECommSales.Compute("sum(ECommExtAmount)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0.0}", Convert.ToDecimal(dtECommSales.Compute("sum(ECommExtWeight)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0}", Convert.ToDecimal(dtECommSales.Compute("sum(NoOfECommOrders)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0.00}", Convert.ToDecimal(dtECommSales.Compute("sum(ECommExtOrdAmount)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0.0}", Convert.ToDecimal(dtECommSales.Compute("sum(ECommExtOrdWeight)", ""))) + "</td><td>";

            footerContent += String.Format("{0:#,##0}", Convert.ToDecimal(dtECommSales.Compute("sum(NoOfManualQuotes)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0.00}", Convert.ToDecimal(dtECommSales.Compute("sum(ManualExtAmount)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0.0}", Convert.ToDecimal(dtECommSales.Compute("sum(ManualExtWeight)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0}", Convert.ToDecimal(dtECommSales.Compute("sum(NoOfManualOrders)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0.00}", Convert.ToDecimal(dtECommSales.Compute("sum(ManualExtOrdAmount)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0.0}", Convert.ToDecimal(dtECommSales.Compute("sum(ManualExtOrdWeight)", ""))) + "</td><td>";

            footerContent += String.Format("{0:#,##0}", Convert.ToDecimal(dtECommSales.Compute("sum(NoOfMissedECommQuotes)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0.00}", Convert.ToDecimal(dtECommSales.Compute("sum(MissedECommExtAmount)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0.0}", Convert.ToDecimal(dtECommSales.Compute("sum(MissedECommExtWeight)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0}", Convert.ToDecimal(dtECommSales.Compute("sum(NoOfMissedManualQuotes)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0.00}", Convert.ToDecimal(dtECommSales.Compute("sum(MissedManualExtAmount)", ""))) + "</td><td>";
            footerContent += String.Format("{0:#,##0.0}", Convert.ToDecimal(dtECommSales.Compute("sum(MissedManualExtWeight)", ""))) + "</td></tr></table>";
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
