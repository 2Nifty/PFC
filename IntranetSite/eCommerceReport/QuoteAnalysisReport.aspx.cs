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
using PFC.Intranet.Utility;

#endregion

public partial class QuoteAnalysisReport : System.Web.UI.Page
{
    #region Global Variables

    private string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    private DataTable dtQuoteAnalysis = new DataTable();

    private DataSet dsQuoteAnalysis = new DataSet();

    private string keyColumn = "QuotationDate";
    private string sortExpression = string.Empty;
    private string WhereMonth = string.Empty;

    string periodMonth = string.Empty;
    string periodYear = string.Empty;

    int pagesize = 18;
    string branch = "";
    string customerNo = string.Empty;
    string branchNo=string.Empty;
    string startDate = string.Empty;
    string endDate = string.Empty;
    string ordBy = "";

    protected eCommerceReport eCommerceReport = new eCommerceReport();
    Utility utility = new Utility();
    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        //Comment should be removed
        systemCheck.SessionCheck();

        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(QuoteAnalysisReport));
        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");        

        periodMonth = (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "";
        periodYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";
        customerNo = (Request.QueryString["CustomerNumber"] != null) ? Request.QueryString["CustomerNumber"].ToString().Trim() : "";
        branchNo = (Request.QueryString["BranchNumber"] != null) ? Request.QueryString["BranchNumber"].ToString().Trim() : "";
        startDate = (Request.QueryString["StartDate"] != null) ? Request.QueryString["StartDate"].ToString().Trim() : "";
        endDate = (Request.QueryString["EndDate"] != null) ? Request.QueryString["EndDate"].ToString().Trim() : "";
        
        hidFileName.Value = "QuoteAnalysisReport" + Session["SessionID"].ToString() + name + ".xls";
        //hidFileName.Value = "QuoteAnalysisReport" + name + ".xls";
        if (!IsPostBack)
            BindDataGrid();
    } 

    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        sortExpression = ((hidSort.Value != "") ?  hidSort.Value : keyColumn);

        dsQuoteAnalysis = eCommerceReport.GetQuoteData(periodMonth, periodYear,startDate,endDate,branchNo, customerNo);
        dtQuoteAnalysis = eCommerceReport.AverageCostJoins(dsQuoteAnalysis.Tables[0], GetAverageCost(dsQuoteAnalysis.Tables[0]));        

        DataColumn dcAverageCost = new DataColumn("MarginPercentage", System.Type.GetType("System.Double"));
        dcAverageCost.Expression = "IIF([UnitPrice]=0, 0,(((UnitPrice - AvgCost) / UnitPrice) * 100))";
        dtQuoteAnalysis.Columns.Add(dcAverageCost);
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

    public DataTable GetAverageCost(DataTable dtMasterRecord)
    {
        try
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
            
            if(brIDs != string.Empty)
                brIDs= brIDs.Remove(0,1);
                         
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
        catch (Exception ex)
        {
            throw null;
        }
    }
    
    #endregion

    #region Events

    protected void dgQuoteAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        //e.Item.Cells[0].CssClass = "locked";
        //e.Item.Cells[1].CssClass = "locked";
        //e.Item.Cells[2].CssClass = "locked";
        //e.Item.Cells[3].CssClass = "locked";

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Label _lblQuoteDate =  e.Item.FindControl("lblQuoteDate") as Label;
            Label _lblPhone = e.Item.FindControl("lblPhone") as Label;
            HtmlGenericControl _divToolTips = e.Item.FindControl("divToolTips") as HtmlGenericControl;

            _lblPhone.Text = utility.FormatePhoneNumber(_lblPhone.Text);
            //_lblQuoteDate.Attributes.Add("onmouseover", "javascript:document.getElementById('" + _divToolTips.ClientID + "').style.display='';");
            _lblQuoteDate.Attributes.Add("onmouseover", "javascript:ShowGridtooltip('" + _divToolTips.ClientID + "','" + _lblQuoteDate.ClientID + "');");
            
            _lblQuoteDate.Attributes.Add("onmouseout", "javascript:document.getElementById('" + _divToolTips.ClientID + "').style.display='none';");
        }
        else if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].ColumnSpan = 4;
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[1].Visible = false;
            e.Item.Cells[2].Visible = false;
            e.Item.Cells[3].Visible = false;
            e.Item.Cells[7].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(RequestQuantity)", "")));
            e.Item.Cells[8].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(RunningAvalQty)", "")));
            //e.Item.Cells[11].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(UnitPrice)", "")));
            e.Item.Cells[10].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtQuoteAnalysis.Compute("Avg(MarginPercentage)", "")));
            e.Item.Cells[11].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuoteAnalysis.Compute("Avg(AvgCost)", "")));
            e.Item.Cells[13].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(TotalPrice)", "")));
            e.Item.Cells[14].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtQuoteAnalysis.Compute("sum(GrossWeight)", "")));
        }


    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgQuoteAnalysis.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void dgQuoteAnalysis_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgQuoteAnalysis.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
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

        dsQuoteAnalysis = eCommerceReport.GetQuoteData(periodMonth, periodYear,startDate,endDate,branchNo, customerNo);
        dtQuoteAnalysis = eCommerceReport.AverageCostJoins(dsQuoteAnalysis.Tables[0], GetAverageCost(dsQuoteAnalysis.Tables[0]));        
        DataColumn dcAverageCost = new DataColumn("MarginPercentage", System.Type.GetType("System.Double"));
        dcAverageCost.Expression = "IIF([UnitPrice]=0, 0,(((UnitPrice - AvgCost) / UnitPrice) * 100))";
        //dcAverageCost.Expression = "(((UnitPrice - AvgCost) / UnitPrice) * 100)";
        dtQuoteAnalysis.Columns.Add(dcAverageCost);

        dtQuoteAnalysis.DefaultView.Sort = sortExpression;

        headerContent = "<table border='1'>";
        headerContent += "<tr><th colspan='15' style='color:blue'>eCommerce Quote Analysis Report</th></tr>";

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
