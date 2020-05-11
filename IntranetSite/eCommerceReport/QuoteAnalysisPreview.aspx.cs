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

public partial class QuoteAnalysisPreview : System.Web.UI.Page
{
    #region Global Variables

    private string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    private DataTable dtQuoteAnalysis = new DataTable();
    private DataSet dsQuoteAnalysis = new DataSet();
    private string keyColumn = "QuotationDate";
    private string sortExpression = string.Empty;
    string periodMonth = string.Empty;
    string periodYear = string.Empty;
    private string sortColumn = string.Empty;
    string customerNo = string.Empty;
    string branchNo = string.Empty;
    string startDate = string.Empty;
    string endDate = string.Empty;

    protected eCommerceReport eCommerceReport = new eCommerceReport();
    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        //SystemCheck systemCheck = new SystemCheck();
        //systemCheck.SessionCheck();
        periodMonth = (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "";
        periodYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";
        customerNo = (Request.QueryString["CustomerNumber"] != null) ? Request.QueryString["CustomerNumber"].ToString().Trim() : "";
        branchNo = (Request.QueryString["BranchNumber"] != null) ? Request.QueryString["BranchNumber"].ToString().Trim() : "";
        startDate = (Request.QueryString["StartDate"] != null) ? Request.QueryString["StartDate"].ToString().Trim() : "";
        endDate = (Request.QueryString["EndDate"] != null) ? Request.QueryString["EndDate"].ToString().Trim() : "";
        
        sortColumn = Request.QueryString["Sort"].ToString();      
     
        if (!IsPostBack)
            BindDataGrid();
    }

    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        if (sortColumn == "")
            sortExpression = "QuotationDate";
        else
            sortExpression = sortColumn;

        dsQuoteAnalysis = eCommerceReport.GetQuoteData(periodMonth, periodYear,startDate,endDate,branchNo, customerNo);
        dtQuoteAnalysis = eCommerceReport.AverageCostJoins(dsQuoteAnalysis.Tables[0], GetAverageCost(dsQuoteAnalysis.Tables[0]));
        
        DataColumn dcAverageCost = new DataColumn("MarginPercentage", System.Type.GetType("System.Double"));
        dcAverageCost.Expression = "IIF([UnitPrice]=0, 0,(((UnitPrice - AvgCost) / UnitPrice) * 100))";
        dtQuoteAnalysis.Columns.Add(dcAverageCost);

        dtQuoteAnalysis.DefaultView.Sort = sortExpression;


        //dtTotal = dsQuoteAnalysis.Tables[0].DefaultView.ToTable();
        if (dtQuoteAnalysis.Rows.Count > 0)
        {
            dgQuoteAnalysis.DataSource = dtQuoteAnalysis.DefaultView.ToTable();
            dgQuoteAnalysis.DataBind();
        }
        lblStatus.Text = "No Records Found";
        lblStatus.Visible = (dgQuoteAnalysis.Items.Count < 1) ? true : false;
    }

    #endregion

    #region Events

    protected void dgQuoteAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].ColumnSpan = 4;
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[1].Visible = false;
            e.Item.Cells[2].Visible = false;
            e.Item.Cells[3].Visible = false;

            e.Item.Cells[7].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(RequestQuantity)", "")));
            e.Item.Cells[8].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(RunningAvalQty)", "")));
            e.Item.Cells[10].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtQuoteAnalysis.Compute("Avg(MarginPercentage)", "")));
            e.Item.Cells[11].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuoteAnalysis.Compute("Avg(AvgCost)", "")));
            e.Item.Cells[13].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(TotalPrice)", "")));
            e.Item.Cells[14].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(GrossWeight)", "")));
        }
    }

    public DataTable GetAverageCost(DataTable dtMasterRecord)
    {
        //
        // Select distinct Br from Master table
        //
        string brIDs = "";
        DataView dv = dtMasterRecord.DefaultView;
        string[] distinct = { "SalesBranchofRecord" };

        DataTable tbl = dv.ToTable(true, distinct);
        foreach (DataRow dr in tbl.Rows)
            brIDs += ",'" + dr[0].ToString() + "'";

        if (brIDs != string.Empty)
            brIDs = brIDs.Remove(0, 1);
        
        string _connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
        string _tableName = "itemBranch IB,itemmaster IM";
        string _columnName = "IB.AvgCost,IB.Location,IM.itemno";

        string _whereClause = "IB.fItemmasterId = IM.pItemmasterId and IB.Location in (" + brIDs + ")";

        DataSet dsCustomers = (DataSet)SqlHelper.ExecuteDataset(_connectionString, "UGEN_SP_Select",
                                                   new SqlParameter("@tableName", _tableName),
                                                   new SqlParameter("@columnNames", _columnName),
                                                   new SqlParameter("@whereClause", _whereClause));
        return dsCustomers.Tables[0];
    }

    
    #endregion   
}
