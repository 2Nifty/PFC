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

public partial class DayInventoryReport_CategoryDayReportPreview : System.Web.UI.Page
{
    #region Global Variables

    protected DayInventoryReport DayInventoryReport = new DayInventoryReport();
    private string strStatus = string.Empty;
    private string strCategory = string.Empty;
    private string keyColumn = "ItemNo";
    private string sortExpression = string.Empty;
    private string sortColumn = string.Empty;
    public DataSet dsReport = new DataSet();
    private DataTable dtTotal = new DataTable();
 
    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        sortColumn = Request.QueryString["Sort"].ToString();
        strStatus = Request.QueryString["status"];
        strCategory = Request.QueryString["CategoryGroup"];
        if (sortColumn == "")
            sortExpression = " ORDER BY " + keyColumn;
        else
            sortExpression = " ORDER BY " + sortColumn;

        if (strStatus == "withExclusion")
            lblMenuName.Text = "365 Day Inventory Report - With Exclusions";
        else
            lblMenuName.Text = "365 Day Inventory Report - Without Exclusions";
        
        if (!IsPostBack)
        {

            dsReport = DayInventoryReport.GetCategoryReport(strStatus, strCategory, Request.QueryString["BranchCode"], sortExpression);
            dtTotal = dsReport.Tables[0].DefaultView.ToTable();
            BindDataGrid();
        }

    } 

    #endregion

    #region Developer Code

    private void BindReport()
    {
        try
        {
            dsReport = DayInventoryReport.GetCategoryReport(strStatus, strCategory, Request.QueryString["BranchCode"], sortExpression);
            dtTotal = dsReport.Tables[0].DefaultView.ToTable();
            dsReport.Tables[0].DefaultView.Sort = sortExpression;
            BindDataGrid();
        }
        catch (Exception ex) { }
    }

    private void GetTotal()
    {
        dtTotal.Clear();
        DataRow drow = dtTotal.NewRow();
        drow["ItemNo"] = "0";
        drow["OnHand"] = Convert.ToInt32(dsReport.Tables[0].Compute("sum(OnHand)", "")).ToString();
        drow["OnHandValue"] = Convert.ToInt32(dsReport.Tables[0].Compute("sum(OnHandValue)", "")).ToString();
        drow["DailySalesValue"] = Convert.ToInt32(dsReport.Tables[0].Compute("sum(DailySalesValue)", "")).ToString();
        drow["DaysOnHand"] = Convert.ToInt32(dsReport.Tables[0].Compute("sum(DaysOnHand)", "")).ToString();
        drow["OHgt150Days"] = Convert.ToInt32(dsReport.Tables[0].Compute("sum(OHgt150Days)", "")).ToString();
        drow["OHgt365Days"] = Convert.ToInt32(dsReport.Tables[0].Compute("sum(OHgt365Days)", "")).ToString();
        drow["ItemDesc"] = "";
        dtTotal.Rows.Add(drow);
    }

    private void BindDataGrid()
    {

        try
        {
            if (dtTotal.Rows.Count > 0)
            {
                GetTotal();
                dgDayReport.DataSource = dsReport.Tables[0];
                dgDayReport.DataBind();
                dgDayReport.Visible = true;
                lblStatus.Visible = false;
            }
            else
            {
                dgDayReport.Visible = false;
                lblStatus.Visible = true;
                lblStatus.Text = "No Records Found";

            }
        }
        catch (Exception ex)
        {

            throw ex;
        }

    }

    #endregion

    #region Event

    protected void dgDayReport_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Footer)
        {
            if (dtTotal.Rows.Count > 0)
            {
                e.Item.Cells[0].Text = "Grand Total";
                e.Item.Cells[1].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["OnHand"]);
                e.Item.Cells[2].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["OnHandValue"]);
                e.Item.Cells[3].Text = String.Format("{0:#,##0.00}", dtTotal.Rows[0]["DailySalesValue"]);
                e.Item.Cells[4].Text = String.Format("{0:#,##0.000}", dtTotal.Rows[0]["DaysOnHand"]);
                e.Item.Cells[5].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["OHgt150Days"]);
                e.Item.Cells[6].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["OHgt365Days"]);
                e.Item.Cells[7].Text = "&nbsp;";
                
            }

        }

    } 

    #endregion
}
