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

public partial class eCommerceSalesAnalysisHdrRptPreview : System.Web.UI.Page
{
    #region Global Variables
    protected eCommerceReportV2 eCommerceReport = new eCommerceReportV2();

    private DataSet dsSalesAnalysisHdr = new DataSet();
    private DataTable dtSalesAnalysisHdr = new DataTable();

    private string sortExpression = string.Empty;

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

    string sortColumn = string.Empty;
    #endregion

    #region Page Load
    protected void Page_Load(object sender, EventArgs e)
    {
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

        sortColumn = Request.QueryString["Sort"].ToString(); 
        #endregion

        if (!IsPostBack)
        {
            switch (sourceType)
            {
                case "ECOMM":
                    dgSalesAnalysisHdr.Width = 995;
                    lblSourceType.Text = "eCommerce Quotes";
                    break;
                case "MANUAL":
                    dgSalesAnalysisHdr.Width = 995;
                    lblSourceType.Text = "Manual Quotes";
                    break;
                case "ECOMM_ORD":
                    dgSalesAnalysisHdr.Width = 670;
                    lblSourceType.Text = "eCommerce Orders";
                    break;
                case "MANUAL_ORD":
                    dgSalesAnalysisHdr.Width = 670;
                    lblSourceType.Text = "Manual Orders";
                    break;
                case "MISSED_ECOMM":
                    dgSalesAnalysisHdr.Width = 670;
                    lblSourceType.Text = "Missed eCommerce Quotes";
                    break;
                case "MISSED_MANUAL":
                    dgSalesAnalysisHdr.Width = 670;
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
        if (sortColumn == "")
            sortExpression = "QuoteNumber";
        else
            sortExpression = sortColumn;

        dsSalesAnalysisHdr = eCommerceReport.GetHdrData(periodMonth, periodYear, startDate, endDate, branchNo, customerNo, orderSource, sourceType, itemNotOrd);
        dtSalesAnalysisHdr = dsSalesAnalysisHdr.Tables[0].DefaultView.ToTable();
        dtSalesAnalysisHdr.DefaultView.Sort = sortExpression;

        if (dtSalesAnalysisHdr.Rows.Count > 0)
        {
            dgSalesAnalysisHdr.DataSource = dtSalesAnalysisHdr.DefaultView.ToTable();
            dgSalesAnalysisHdr.DataBind();
            lblStatus.Visible = false;
        }
        else
        {
            lblStatus.Text = "No Records Found";
            lblStatus.Visible = true;
        }
    }

    protected void dgSalesAnalysisHdr_ItemDataBound(object sender, DataGridItemEventArgs e)
    {

        #region Grid Header
        if (e.Item.ItemType == ListItemType.Header)
        {
            if (sourceType == "ECOMM" || sourceType == "MANUAL")
            {
                //Quote Columns
                e.Item.Cells[5].ColumnSpan = 4;
                e.Item.Cells[5].Text = "<table border='0' cellpadding='0' cellspacing='0' width='100%' Height='10px'><tr>" +
                                        "<td class='GridPad Border1' colspan=4 nowrap > - - - - - All Quotes - - - - - </td></tr><tr>" +
                                        "<td width='50' class='GridPad Border2' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('LineCount');\">&nbsp;Lines</div></center></td>" +
                                        "<td width='75' class='GridPad Border2' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('RequestQuantity');\">&nbsp;Tot Req Qty</div></center></td>" +
                                        "<td width='100' class='GridPad Border2' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('ExtPrice');\">&nbsp;Total Price</div></td>" +
                                        "<td width='100' class='GridPad' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('ExtWeight');\">&nbsp;Total Weight</div></td></tr></table>";
                e.Item.Cells[6].Visible = false;
                e.Item.Cells[7].Visible = false;
                e.Item.Cells[8].Visible = false;

                //Missed Columns
                e.Item.Cells[9].ColumnSpan = 4;
                e.Item.Cells[9].Text = "<table border='0' cellpadding='0' cellspacing='0' width='100%' Height='10px'><tr>" +
                                        "<td class='GridPad Border1' colspan=4 nowrap > - - - - - Missed Quotes - - - - - </td></tr><tr>" +
                                        "<td width='50' class='GridPad Border2' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('MissedLineCount');\">&nbsp;Lines</div></center></td>" +
                                        "<td width='75' class='GridPad Border2' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('MissedRequestQuantity');\">&nbsp;Tot Req Qty</div></center></td>" +
                                        "<td width='100' class='GridPad Border2' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('MissedExtPrice');\">&nbsp;Total Price</div></td>" +
                                        "<td width='100' class='GridPad' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('MissedExtWeight');\">&nbsp;Total Weight</div></td></tr></table>";
                e.Item.Cells[10].Visible = false;
                e.Item.Cells[11].Visible = false;
                e.Item.Cells[12].Visible = false;
            }
            else
            {
                e.Item.Cells[9].Visible = false;
                e.Item.Cells[10].Visible = false;
                e.Item.Cells[11].Visible = false;
                e.Item.Cells[12].Visible = false;
            }
        }
        #endregion

        #region Grid Items
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            if (sourceType != "ECOMM" && sourceType != "MANUAL")
            {
                e.Item.Cells[9].Visible = false;
                e.Item.Cells[10].Visible = false;
                e.Item.Cells[11].Visible = false;
                e.Item.Cells[12].Visible = false;
            }
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

            if (sourceType == "ECOMM" || sourceType == "MANUAL")
            {
                e.Item.Cells[9].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtSalesAnalysisHdr.Compute("sum(MissedLineCount)", "")));
                e.Item.Cells[10].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtSalesAnalysisHdr.Compute("sum(MissedRequestQuantity)", "")));
                e.Item.Cells[11].Text = String.Format("{0:c}", Convert.ToDecimal(dtSalesAnalysisHdr.Compute("sum(MissedExtPrice)", "")));
                e.Item.Cells[12].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtSalesAnalysisHdr.Compute("sum(MissedExtWeight)", "")));
            }
            else
            {
                e.Item.Cells[9].Visible = false;
                e.Item.Cells[10].Visible = false;
                e.Item.Cells[11].Visible = false;
                e.Item.Cells[12].Visible = false;
            }
        }
        #endregion
    }
    #endregion
}
