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

public partial class eCommerceSalesAnalysisCustRptPreview : System.Web.UI.Page
{
    #region Global Variables
    protected eCommerceReportV2 eCommerceReportV2 = new eCommerceReportV2();

    private DataTable dtECommSales = new DataTable();

    private string keyColumn = "";
    private string sortColumn = string.Empty;
    private string sortExpression = string.Empty;

    string customerNo = "";
    string periodMonth = string.Empty;
    string periodYear = string.Empty;
    string startDate = string.Empty;
    string endDate = string.Empty;
    string locationCode = string.Empty;
    string repNo = string.Empty;
    string repName = string.Empty;
    string priceCdCtl = string.Empty;
    string orderSource = string.Empty;
    string itemNotOrd = string.Empty;
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
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
        sortColumn = Request.QueryString["Sort"].ToString();   
        #endregion

        if (!IsPostBack)
            BindDataGrid();
    }

    #region DataGrid
    private void BindDataGrid()
    {
        if (sortColumn == "")
            sortExpression = "CustomerNumber asc";
        else
            sortExpression = sortColumn;

        dtECommSales = eCommerceReportV2.GetQuoteAndOrderData(periodMonth, periodYear, startDate, endDate, locationCode, customerNo, repNo, priceCdCtl, orderSource, itemNotOrd);
        dtECommSales.DefaultView.Sort = sortExpression;


        if (dtECommSales.Rows.Count > 0)
        {
            dgECommSales.DataSource = dtECommSales.DefaultView.ToTable();
            dgECommSales.DataBind();
            lblStatus.Visible = false;
        }
        else
        {
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
            e.Item.Cells[3].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%' Height='10px'><tr>" +
                                    "<td class='GridHead splitBorder' colspan=3 nowrap >eComm Quotes</td></tr><tr>" +
                                    "<td width='35' class='GridHead splitBorders' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('NoOfECommQuotes');\">&nbsp;# of Quotes</div></center>" +
                                    "</td><td width='100' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('eCommExtAmount');\">&nbsp;Extended $ Amt</div></td>" +
                                    "<td width='100' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('eCommExtWeight');\">&nbsp;Extended Weight</div></td></tr></table>";
            e.Item.Cells[4].Visible = false;
            e.Item.Cells[5].Visible = false;

            //eComm Order Columns
            e.Item.Cells[6].ColumnSpan = 3;
            e.Item.Cells[6].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%' Height='10px'><tr>" +
                                    "<td class='GridHead splitBorder' colspan=3 nowrap >eComm Orders</td></tr><tr>" +
                                    "<td width='35' class='GridHead splitBorders' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('NoOfECommOrders');\">&nbsp;# of Orders</div></center></td>" +
                                    "<td width='100' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('eCommExtOrdAmount');\">Extended $ Amt</div></td>" +
                                    "<td width='100' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('eCommExtOrdWeight');\">Extended Weight</div></td></tr></table>";
            e.Item.Cells[7].Visible = false;
            e.Item.Cells[8].Visible = false;

            //Manual Quote Columns
            e.Item.Cells[9].ColumnSpan = 3;
            e.Item.Cells[9].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%' Height='10px'><tr>" +
                                    "<td class='GridHead splitBorder' colspan=3 nowrap >Manual Quotes</td></tr><tr>" +
                                    "<td width='35' class='GridHead splitBorders' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('NoOfManualQuotes');\">&nbsp;# of Quotes</div></center>" +
                                    "</td><td width='100' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('ManualExtAmount');\">&nbsp;Extended $ Amt</div></td>" +
                                    "<td width='100' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('ManualExtWeight');\">&nbsp;Extended Weight</div></td></tr></table>";
            e.Item.Cells[10].Visible = false;
            e.Item.Cells[11].Visible = false;

            //Manual Order Columns
            e.Item.Cells[12].ColumnSpan = 3;
            e.Item.Cells[12].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%' Height='10px'><tr>" +
                                    "<td class='GridHead splitBorder' colspan=3 nowrap >Manual Orders</td></tr><tr>" +
                                    "<td width='35' class='GridHead splitBorders' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('NoOfManualOrders');\">&nbsp;# of Orders</div></center></td>" +
                                    "<td width='100' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('ManualExtOrdAmount');\">Extended $ Amt</div></td>" +
                                    "<td width='100' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('ManualExtOrdWeight');\">Extended Weight</div></td></tr></table>";
            e.Item.Cells[13].Visible = false;
            e.Item.Cells[14].Visible = false;

            //Missed eComm Quote Columns
            e.Item.Cells[15].ColumnSpan = 3;
            e.Item.Cells[15].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%' Height='10px'><tr>" +
                                    "<td class='GridHead splitBorder' colspan=3 nowrap >Missed eComm Quotes</td></tr><tr>" +
                                    "<td width='35' class='GridHead splitBorders' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('NoOfMissedECommQuotes');\">&nbsp;# of Quotes</div></center>" +
                                    "</td><td width='100' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('MissedECommExtAmount');\">&nbsp;Extended $ Amt</div></td>" +
                                    "<td width='100' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('MissedECommExtWeight');\">&nbsp;Extended Weight</div></td></tr></table>";
            e.Item.Cells[16].Visible = false;
            e.Item.Cells[17].Visible = false;

            //Missed Manual Quote Columns
            e.Item.Cells[18].ColumnSpan = 3;
            e.Item.Cells[18].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%' Height='10px'><tr>" +
                                    "<td class='GridHead splitBorder' colspan=3 nowrap >Missed Manual Quotes</td></tr><tr>" +
                                    "<td width='35' class='GridHead splitBorders' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('NoOfMissedManualQuotes');\">&nbsp;# of Quotes</div></center></td>" +
                                    "<td width='100' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('MissedManualExtAmount');\">Extended $ Amt</div></td>" +
                                    "<td width='100' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('MissedManualExtWeight');\">Extended Weight</div></td></tr></table>";
            e.Item.Cells[19].Visible = false;
            e.Item.Cells[20].Visible = false;
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
    #endregion
 }
