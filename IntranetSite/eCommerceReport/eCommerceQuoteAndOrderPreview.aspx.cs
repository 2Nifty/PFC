
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

public partial class eCommerceQuoteAndOrderPreview : System.Web.UI.Page
{
    #region Global Variables

    private string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();

    private DataTable dtQuoteAndOrder = new DataTable();
    private DataTable dtQuote2Order = new DataTable();

    private string keyColumn = "";
    private string sortExpression = string.Empty;

    private string sortColumn = string.Empty;
    string customerNo = "";
    string periodMonth = string.Empty;
    string periodYear = string.Empty;
    string startDate = string.Empty;
    string endDate = string.Empty;
    string locationCode = string.Empty;
    string repNo = "";
    string repName = "";
    string priceCdCtl = "";

    protected eCommerceReport eCommerceReport = new eCommerceReport();
    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        //SystemCheck systemCheck = new SystemCheck();
        //systemCheck.SessionCheck();
        periodMonth = (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "";
        periodYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";

        customerNo = (Request.QueryString["CustNo"] != null) ? Request.QueryString["CustNo"].ToString().Trim() : "";
        startDate = (Request.QueryString["StartDate"] != null) ? Request.QueryString["StartDate"].ToString().Trim() : "";
        endDate = (Request.QueryString["EndDate"] != null) ? Request.QueryString["EndDate"].ToString().Trim() : "";
        locationCode = (Request.QueryString["Branch"] != null) ? Request.QueryString["Branch"].ToString().Trim() : "";
        repNo = Request.QueryString["RepNo"].ToString(); 
        repName = Request.QueryString["RepName"].ToString();
        priceCdCtl = (Request.QueryString["PriceCdCtl"] != null) ? Request.QueryString["PriceCdCtl"].ToString().Trim() : "false";

        sortColumn = Request.QueryString["Sort"].ToString();      
     
        if (!IsPostBack)
            BindDataGrid();
    }

    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        if (sortColumn == "")
            sortExpression = "customerNumber asc";
        else
            sortExpression = sortColumn;

        //dtQuoteAndOrder = eCommerceReport.GetQuote2OrderData(periodMonth, periodYear, customerNo);
        //dtQuote2Order = eCommerceReport.CreateJoins(dtQuoteAndOrder, GetCustomers());
        //dtQuote2Order.DefaultView.Sort = sortExpression;

        dtQuote2Order = eCommerceReport.GetQuote2OrderData(periodMonth, periodYear, startDate, endDate, locationCode, customerNo,repNo, priceCdCtl);
        dtQuote2Order.DefaultView.Sort = sortExpression;


        if (dtQuote2Order.Rows.Count > 0)
        {
            dgQuote2Order.DataSource = dtQuote2Order.DefaultView.ToTable();
            dgQuote2Order.DataBind();
            lblStatus.Visible = false;
        }
        else
        {
            lblStatus.Visible = true;
            lblStatus.Text = "No Records Found";
        }
    }

    #endregion

    #region Events

    protected void dgQuote2Order_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Header)
        {
            e.Item.Cells[3].ColumnSpan = 3;
            e.Item.Cells[3].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' colspan=3 nowrap >Quotes</td></tr><tr><td width='35' class='GridHead splitBorders'><center>&nbsp;# of Quotes</center></td><td width='100' class='GridHead' nowrap align='center'>Extended $ Amnt</td><td width='100' class='GridHead' nowrap align='center'>Extended Weight</td></tr></table>";
            e.Item.Cells[4].Visible = false;
            e.Item.Cells[5].Visible = false;
            e.Item.Cells[6].ColumnSpan = 3;
            e.Item.Cells[6].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' colspan=3 nowrap >Orders</td></tr><tr><td width='35' class='GridHead splitBorders'><center>&nbsp;# of Orders</center></td><td width='100' class='GridHead' nowrap align='center'>Extended $ Amnt</td><td width='100' class='GridHead' nowrap align='center'>Extended Weight</td></tr></table>";
            e.Item.Cells[7].Visible = false;
            e.Item.Cells[8].Visible = false;
        }
        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].ColumnSpan = 3;
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[1].Visible = false;
            e.Item.Cells[2].Visible = false;
            e.Item.Cells[3].Text = String.Format("{0:#,##}", Convert.ToDecimal(dtQuote2Order.Compute("sum(NoOfQuotes)", "")));
            e.Item.Cells[4].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuote2Order.Compute("sum(ExtAmount)", "")));
            e.Item.Cells[5].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuote2Order.Compute("sum(ExtWeight)", "")));
            e.Item.Cells[6].Text = String.Format("{0:#,##}", Convert.ToDecimal(dtQuote2Order.Compute("sum(NoOfOrders)", "")));
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
 
    #endregion   
   
}
