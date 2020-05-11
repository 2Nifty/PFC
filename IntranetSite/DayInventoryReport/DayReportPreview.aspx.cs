#region Namespace

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
using PFC.Intranet.DayInventoryReport; 

#endregion

public partial class DayInventoryReport_DayReportPreview : System.Web.UI.Page
{
    #region Global Variables

    private DataTable dtTotal = new DataTable();
    private DataSet dsDayReport = new DataSet();
    private string keyColumn = "CategoryGroup";
    private string sortExpression = string.Empty;
    protected string strStatus = string.Empty;
    private string sortColumn = string.Empty;
    protected DayInventoryReport DayInventoryReport = new DayInventoryReport();
    string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(); 

    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        sortColumn = Request.QueryString["Sort"].ToString();
        strStatus = Request.QueryString["status"];
        if (strStatus == "withExclusion")
            lblMenuName.Text = "365 Day Inventory Report - With Exclusions";
        else if (strStatus == "withoutExclusion")
            lblMenuName.Text = "365 Day Inventory Report - Without Exclusions";
        else if (strStatus == "36MonthUsage")
            lblMenuName.Text = "365 Day Inventory Report - Without Exclusions - Using 36 Month Usage";

        if (!IsPostBack)
            BindDataGrid();
    } 

    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        if (sortColumn == "")
            sortExpression = " ORDER BY CategoryGroup";
        else
            sortExpression = " ORDER BY " + sortColumn;
        dsDayReport = DayInventoryReport.GetDayReport(strStatus, sortExpression);
        dtTotal = dsDayReport.Tables[0].DefaultView.ToTable();


        if (dtTotal.Rows.Count > 0)
        {
            GetTotal();
            dgDayReport.DataSource = dsDayReport.Tables[0];
            dgDayReport.DataBind();
            lblStatus.Visible = false;
        }
        else
        {
            lblStatus.Visible = true;
            lblStatus.Text = "No Records Found";
        }
        
    }

    private void GetTotal()
    {
        dtTotal.Clear();
        DataRow drow = dtTotal.NewRow();
        drow["CategoryGroup"] = 0;
        drow["ContainersOH"] = Convert.ToInt32(dsDayReport.Tables[0].Compute("sum(ContainersOH)", "")).ToString();
        drow["InvExtCost"] = Convert.ToInt32(dsDayReport.Tables[0].Compute("sum(InvExtCost)", "")).ToString();
        drow["AvgCstPerDay"] = Convert.ToInt32(dsDayReport.Tables[0].Compute("sum(AvgCstPerDay)", "")).ToString();
        drow["DaysOH"] = Convert.ToInt32(dsDayReport.Tables[0].Compute("sum(DaysOH)", "")).ToString();
        drow["OHover150Days"] = Convert.ToInt32(dsDayReport.Tables[0].Compute("sum(OHover150Days)", "")).ToString();
        drow["OHover365Days"] = Convert.ToInt32(dsDayReport.Tables[0].Compute("sum(OHover365Days)", "")).ToString();
        drow["CategoryDsc"] = "";
        dtTotal.Rows.Add(drow);
    } 

    #endregion

    #region Event

    protected void dgDayReport_ItemDataBound(object sender, DataGridItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[1].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["ContainersOH"]);
            e.Item.Cells[2].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["InvExtCost"]);
            e.Item.Cells[3].Text = String.Format("{0:#,##0.00}", dtTotal.Rows[0]["AvgCstPerDay"]);
            e.Item.Cells[4].Text = String.Format("{0:#,##0.000}", dtTotal.Rows[0]["DaysOH"]);
            e.Item.Cells[5].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["OHover150Days"]);
            e.Item.Cells[6].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["OHover365Days"]);
            e.Item.Cells[7].Text = "&nbsp;";
           
        }


    } 

    #endregion

}
