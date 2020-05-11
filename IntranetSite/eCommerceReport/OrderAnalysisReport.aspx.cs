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

public partial class OrderAnalysisReport : System.Web.UI.Page
{
    #region Global Variables

    private string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    private DataTable dtOrderAnalysis = new DataTable();
    private DataSet dsOrderAnalysis = new DataSet();

    private string keyColumn = "PurchaseOrderNo";
    private string sortExpression = string.Empty;
    private string WhereMonth = string.Empty;

    string periodMonth = string.Empty;
    string periodYear = string.Empty;

    int pagesize = 20;
    string branch = "";
    string customerNo = string.Empty;
    string branchNo = string.Empty;
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
        //systemCheck.SessionCheck();

        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(OrderAnalysisReport));
        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");        

        periodMonth = (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "";
        periodYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";
        customerNo = (Request.QueryString["CustomerNumber"] != null) ? Request.QueryString["CustomerNumber"].ToString().Trim() : "";
        branchNo = (Request.QueryString["BranchNumber"] != null) ? Request.QueryString["BranchNumber"].ToString().Trim() : "";
        startDate = (Request.QueryString["StartDate"] != null) ? Request.QueryString["StartDate"].ToString().Trim() : "";
        endDate = (Request.QueryString["EndDate"] != null) ? Request.QueryString["EndDate"].ToString().Trim() : "";

        //hidFileName.Value = "OrderAnalysisReport" + Session["SessionID"].ToString() + name + ".xls";
        hidFileName.Value = "OrderAnalysisReport"+Session["SessionID"].ToString() + name + ".xls";
        if (!IsPostBack)
            BindDataGrid();
    } 

    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        sortExpression = ((hidSort.Value != "") ?  hidSort.Value : keyColumn);

        dsOrderAnalysis = eCommerceReport.GetOrderData(periodMonth, periodYear,startDate,endDate,branchNo, customerNo);
        dtOrderAnalysis = eCommerceReport.OrderAverageCostJoins(dsOrderAnalysis.Tables[0], GetAverageCost(dsOrderAnalysis.Tables[0]));        

        DataColumn dcAverageCost = new DataColumn("MarginPercentage",System.Type.GetType("System.Double"));
        dcAverageCost.Expression = "IIF([UnitPrice]=0, 0,(((UnitPrice - AvgCost) / UnitPrice) * 100))";
        dtOrderAnalysis.Columns.Add(dcAverageCost);

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

    public DataTable GetAverageCost(DataTable dtOrder)
    {
        string brIDs = "";
        DataView dv = dtOrder.DefaultView;
        DataTable tbl = dv.ToTable(true, "SalesLocationCode");
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

    #region Events

    protected void dgOrderAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        //e.Item.Cells[0].CssClass = "locked";
        //e.Item.Cells[1].CssClass = "locked";
        //e.Item.Cells[2].CssClass = "locked";
        //e.Item.Cells[3].CssClass = "locked";

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Label _lblPONo = e.Item.FindControl("lblPONo") as Label;
            Label _lblPhone = e.Item.FindControl("lblPhone") as Label;
            HtmlGenericControl _divToolTips = e.Item.FindControl("divToolTips") as HtmlGenericControl;

            _lblPhone.Text = utility.FormatePhoneNumber(_lblPhone.Text);
            _lblPONo.Attributes.Add("onmouseover", "javascript:ShowGridtooltip('" + _divToolTips.ClientID + "','" + _lblPONo.ClientID + "');");
            _lblPONo.Attributes.Add("onmouseout", "javascript:document.getElementById('" + _divToolTips.ClientID + "').style.display='none';");
        }
        else if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].ColumnSpan = 4;
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[1].Visible = false;
            e.Item.Cells[2].Visible = false;
            e.Item.Cells[3].Visible = false;

            e.Item.Cells[7].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(RequestQuantity)", "")));
            e.Item.Cells[8].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(AvailableQuantity)", "")));
            //e.Item.Cells[11].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(UnitPrice)", "")));
            e.Item.Cells[10].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtOrderAnalysis.Compute("avg(MarginPercentage)", "")));
            e.Item.Cells[11].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtOrderAnalysis.Compute("avg(AvgCost)", "")));
            e.Item.Cells[13].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(TotalPrice)", "")));
            e.Item.Cells[14].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(Weight)", "")));
        }
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgOrderAnalysis.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void dgOrderAnalysis_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgOrderAnalysis.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
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

        dsOrderAnalysis = eCommerceReport.GetOrderData(periodMonth, periodYear,startDate,endDate,branchNo, customerNo);
        dtOrderAnalysis = eCommerceReport.OrderAverageCostJoins(dsOrderAnalysis.Tables[0], GetAverageCost(dsOrderAnalysis.Tables[0]));
        
        DataColumn dcAverageCost = new DataColumn("MarginPercentage", System.Type.GetType("System.Double"));
        dcAverageCost.Expression = "IIF([UnitPrice]=0, 0,(((UnitPrice - AvgCost) / UnitPrice) * 100))";
        dtOrderAnalysis.Columns.Add(dcAverageCost);

        dtOrderAnalysis.DefaultView.Sort = sortExpression;

        headerContent = "<table border='1'>";
        headerContent += "<tr><th colspan='15' style='color:blue'>eCommerce Order Analysis Report</th></tr>";
        headerContent += "<tr><th>Customer #</th><th colspan='2' align='left'>&nbsp;" + Request.QueryString["CustomerNumber"].ToString() + "</th>";
        headerContent += "<th>Customer Name</th><th colspan='5' align='left'>" + Request.QueryString["CustomerName"].ToString() + "</th>";
        headerContent += "<th>Run By</th><th colspan='2' align='left'>" + Session["UserName"].ToString() + "</th>";
        headerContent += "<th>Run Date</th><th colspan='2' align='left'>" + DateTime.Now.ToShortDateString() + "</th></tr>";
        
        headerContent += "<tr><th>Order Method</th><th>P.O. Number</th><th>P.O. Date</th><th>User Item #</th><th>PFC Item #</th><th>Description</th><th>Sales Branch of Record</th><th>Req. Qty</th><th>Ava. Qty</th><th>Unit Price</th><th>Margin %</th><th>Average Cost</th><th>Price UOM</th><th>Total Price</th><th>Total Weight</th>";

        if (dtOrderAnalysis.Rows.Count > 0)
        {
            foreach (DataRow eComOrderAnalysis in dtOrderAnalysis.DefaultView.ToTable().Rows)
            {
                excelContent += "<tr><td>"+
                     eComOrderAnalysis["OrderMethod"].ToString() + "</td><td>" +
                     eComOrderAnalysis["PurchaseOrderNo"].ToString() + "</td><td>" +
                     String.Format("{0:MM/dd/yyyy}", eComOrderAnalysis["PurchaseOrderDate"]) + "</td><td align='left'>" +
                     eComOrderAnalysis["UserItemNo"].ToString() + "</td><td>" +
                     eComOrderAnalysis["PFCItemNo"].ToString() + "</td><td>" +
                     eComOrderAnalysis["Description"].ToString() + "</td><td>&nbsp;" +
                     eComOrderAnalysis["SalesLocationCode"].ToString() + "</td><td>" +
                     String.Format("{0:#,##0}", eComOrderAnalysis["RequestQuantity"]) + "</td><td>" +
                     String.Format("{0:#,##0}", eComOrderAnalysis["AvailableQuantity"]) + "</td><td>" +
                     String.Format("{0:#,##0.00}", eComOrderAnalysis["UnitPrice"]) + "</td><td>" +
                     String.Format("{0:#,##0.0}", eComOrderAnalysis["MarginPercentage"]) + "</td><td>" +
                     String.Format("{0:#,##0.00}", eComOrderAnalysis["AvgCost"]) + "</td><td>" +
                     eComOrderAnalysis["PriceUOM"].ToString() + "</td><td>" +
                     String.Format("{0:#,##0.00}", eComOrderAnalysis["TotalPrice"]) + "</td><td>" +
                     String.Format("{0:#,##0.00}", eComOrderAnalysis["Weight"]) + "</td></tr>";
            }
            footerContent = "<tr style='font-weight:bold;' align='right'><td colspan='4'>" + "Grand Total" + "</td><td>" +                     
                     " " + "</td><td>" +
                     " " + "</td><td>" +
                     " " + "</td><td>" +
                     String.Format("{0:#,##0}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(RequestQuantity)", ""))) + "</td><td>" +
                     String.Format("{0:#,##0}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(AvailableQuantity)", ""))) + "</td><td>" +
                     "" + "</td><td>" +
                     String.Format("{0:#,##0.0}", Convert.ToDecimal(dtOrderAnalysis.Compute("avg(MarginPercentage)", ""))) + "</td><td>" +
                     String.Format("{0:#,##0.00}", Convert.ToDecimal(dtOrderAnalysis.Compute("avg(AvgCost)", ""))) + "</td><td>" +
                     " " + "</td><td>" +
                     String.Format("{0:#,##0.00}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(TotalPrice)", ""))) + "</td><td>" +
                     String.Format("{0:#,##0.00}", Convert.ToDecimal(dtOrderAnalysis.Compute("sum(Weight)", ""))) + "</td></tr></table>";

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
