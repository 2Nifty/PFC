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

public partial class QuoteAnalysisDtlRptPreview : System.Web.UI.Page
{
    #region Global Variables
    protected eCommerceReportV2 eCommerceReport = new eCommerceReportV2();
    
    private DataTable dtQuoteAnalysis = new DataTable();
    private DataSet dsQuoteAnalysis = new DataSet();
    
    private string sortExpression = string.Empty;
    private string sortColumn = string.Empty;

    string periodMonth = string.Empty;
    string periodYear = string.Empty;
    string branchNo = string.Empty;
    string customerNo = string.Empty;
    string startDate = string.Empty;
    string endDate = string.Empty;
    string orderSource = string.Empty;
    string itemNotOrd = string.Empty;
    string sourceType = string.Empty;
    string quoteNumber = string.Empty;
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        #region URL Parameters
        periodMonth = (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "";
        periodYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";
        branchNo = (Request.QueryString["BranchNumber"] != null) ? Request.QueryString["BranchNumber"].ToString().Trim() : "";
        customerNo = (Request.QueryString["CustomerNumber"] != null) ? Request.QueryString["CustomerNumber"].ToString().Trim() : "";
        startDate = (Request.QueryString["StartDate"] != null) ? Request.QueryString["StartDate"].ToString().Trim() : "";
        endDate = (Request.QueryString["EndDate"] != null) ? Request.QueryString["EndDate"].ToString().Trim() : "";
        orderSource = (Request.QueryString["OrdSrc"] != null) ? Request.QueryString["OrdSrc"].ToString().Trim() : "";
        itemNotOrd = (Request.QueryString["ItemNotOrd"] != null) ? Request.QueryString["ItemNotOrd"].ToString().Trim() : "false";
        sourceType = (Request.QueryString["SrcTyp"] != null) ? Request.QueryString["SrcTyp"].ToString().Trim() : "";
        quoteNumber = (Request.QueryString["QuoteNumber"] != null) ? Request.QueryString["QuoteNumber"].ToString().Trim() : "";

        sortColumn = Request.QueryString["Sort"].ToString();   
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

    #region DataGrid
    private void BindDataGrid()
    {
        if (sortColumn == "")
            sortExpression = "QuotationDate";
        else
            sortExpression = sortColumn;

        dsQuoteAnalysis = eCommerceReport.GetDtlData(periodMonth, periodYear, startDate, endDate, branchNo, customerNo, orderSource, sourceType, itemNotOrd, quoteNumber);

        if (dsQuoteAnalysis.Tables[0].Rows.Count > 0)
        {
            dtQuoteAnalysis = eCommerceReport.AverageCostJoins(dsQuoteAnalysis.Tables[0], eCommerceReport.GetAverageCost(dsQuoteAnalysis.Tables[0])); 

            DataColumn dcAverageCost = new DataColumn("MarginPercentage", System.Type.GetType("System.Double"));
            dcAverageCost.Expression = "IIF([UnitPrice]=0, 0,(((UnitPrice - AvgCost) / UnitPrice) * 100))";
            dtQuoteAnalysis.Columns.Add(dcAverageCost);
            dtQuoteAnalysis.DefaultView.Sort = sortExpression;

            if (dtQuoteAnalysis.Rows.Count > 0)
            {
                dgQuoteAnalysis.DataSource = dtQuoteAnalysis.DefaultView.ToTable();
                dgQuoteAnalysis.DataBind();
                lblStatus.Visible = false;
            }
            else
            {
                lblStatus.Text = "No Records Found";
                lblStatus.Visible = true;
            }
        }
        else
        {
            lblStatus.Text = "No Records Found";
            lblStatus.Visible = true;
        }
    }

    protected void dgQuoteAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        #region Grid Footer
        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].ColumnSpan = 4;
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[1].Visible = false;
            e.Item.Cells[2].Visible = false;
            e.Item.Cells[3].Visible = false;
            e.Item.Cells[7].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(RequestQuantity)", "")));
            e.Item.Cells[8].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(RunningAvailQty)", "")));
            e.Item.Cells[10].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtQuoteAnalysis.Compute("Avg(MarginPercentage)", "")));
            e.Item.Cells[11].Text = String.Format("{0:c}", Convert.ToDecimal(dtQuoteAnalysis.Compute("Avg(AvgCost)", "")));
            e.Item.Cells[13].Text = String.Format("{0:c}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(TotalPrice)", "")));
            e.Item.Cells[14].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(GrossWeight)", "")));
        }
        #endregion
    }
    #endregion
}