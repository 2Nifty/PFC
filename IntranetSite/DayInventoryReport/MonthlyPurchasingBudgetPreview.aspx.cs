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
using PFC.Intranet.MnthlyPrchasingBdgt;

#endregion

public partial class MonthlyPurchasingBudget_Preview : System.Web.UI.Page
{
    #region Global Variables

    private DataTable dtTotal = new DataTable();
    private DataSet dsPurchBudget = new DataSet();
    private string keyColumn = "RecSort";
    private string sortExpression = string.Empty;
    private string reportRecs = "G";
    private string reportFilter = "";
    private string sortColumn = string.Empty;
    protected MnthlyPrchasingBdgt MnthlyPrchasingBdgtData = new MnthlyPrchasingBdgt();

    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        sortColumn = Request.QueryString["Sort"].ToString();
        lblMenuName.Text = "Monthly Purchasing Budget";
        if (Request.QueryString["ReportType"] != null)
        {
            reportRecs = Request.QueryString["ReportType"].ToString();
            reportFilter = Request.QueryString["ReportFilter"].ToString();
            lblMenuName.Text = "Detail for " + reportFilter + " - " + Request.QueryString["ReportDesc"].ToString();
        }

        if (!IsPostBack)
            BindDataGrid();
    } 

    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        if (sortColumn == "")
            sortExpression = "RecSort";
        else
            sortExpression = sortColumn;
        dsPurchBudget = MnthlyPrchasingBdgtData.GetAllBdgt();
        dtTotal = dsPurchBudget.Tables[0];
        dtTotal.DefaultView.Sort = sortExpression;
        dtTotal = dsPurchBudget.Tables[0].DefaultView.ToTable();


        if (dtTotal.Rows.Count > 0)
        {
            GetTotal();
            dgPurchBudget.DataSource = dsPurchBudget.Tables[0].DefaultView.ToTable();
            dgPurchBudget.DataBind();
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
        drow["RecordKey"] = "0";
        drow["MonthlyUseLbs"] = Convert.ToInt32(dsPurchBudget.Tables[0].Compute("sum(MonthlyUseLbs)", "")).ToString();
        drow["OHLbs"] = Convert.ToInt32(dsPurchBudget.Tables[0].Compute("sum(OHLbs)", "")).ToString();
        drow["AvailableLbs"] = Convert.ToInt32(dsPurchBudget.Tables[0].Compute("sum(AvailableLbs)", "")).ToString();
        drow["OWLbs"] = Convert.ToInt32(dsPurchBudget.Tables[0].Compute("sum(OWLbs)", "")).ToString();
        drow["TransferLbs"] = Convert.ToInt32(dsPurchBudget.Tables[0].Compute("sum(TransferLbs)", "")).ToString();
        drow["OnOrderLbs"] = Convert.ToInt32(dsPurchBudget.Tables[0].Compute("sum(OnOrderLbs)", "")).ToString();
        drow["AvailTransferOWLbs"] = Convert.ToInt32(dsPurchBudget.Tables[0].Compute("sum(AvailTransferOWLbs)", "")).ToString();
        drow["AvailTransferOWOnOrderLbs"] = Convert.ToInt32(dsPurchBudget.Tables[0].Compute("sum(AvailTransferOWOnOrderLbs)", "")).ToString();
        drow["AvailableMonths"] = Convert.ToDecimal((decimal)drow["AvailableLbs"] / (decimal)drow["MonthlyUseLbs"]).ToString();
        drow["OWMonths"] = Convert.ToDecimal((decimal)drow["OWLbs"] / (decimal)drow["MonthlyUseLbs"]).ToString();
        drow["TransferMonths"] = Convert.ToDecimal((decimal)drow["TransferLbs"] / (decimal)drow["MonthlyUseLbs"]).ToString();
        drow["OnOrderMonths"] = Convert.ToDecimal((decimal)drow["OnOrderLbs"] / (decimal)drow["MonthlyUseLbs"]).ToString();
        drow["AvailTransferOWMonths"] = Convert.ToDecimal((decimal)drow["AvailTransferOWLbs"] / (decimal)drow["MonthlyUseLbs"]).ToString();
        drow["AvailTransferOWOnOrderMonths"] = Convert.ToDecimal((decimal)drow["AvailTransferOWOnOrderLbs"] / (decimal)drow["MonthlyUseLbs"]).ToString();
        drow["CPRBuyLBS"] = Convert.ToInt32(dsPurchBudget.Tables[0].Compute("sum(CPRBuyLBS)", "")).ToString();
        drow["CPRBuyCartons"] = Convert.ToInt32(dsPurchBudget.Tables[0].Compute("sum(CPRBuyCartons)", "")).ToString();
        drow["CPRBuyMonths"] = Convert.ToDecimal((decimal)drow["CPRBuyLBS"] / (decimal)drow["MonthlyUseLbs"]).ToString();
        dtTotal.Rows.Add(drow);
    } 


    #endregion

    #region Event

    protected void dgPurchBudget_ItemDataBound(object sender, DataGridItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[1].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["MonthlyUseLbs"]);
            e.Item.Cells[2].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["AvailableLbs"]);
            e.Item.Cells[3].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["OWLbs"]);
            e.Item.Cells[4].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["TransferLbs"]);
            e.Item.Cells[5].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["AvailTransferOWLbs"]);
            e.Item.Cells[6].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["OnOrderLbs"]);
            e.Item.Cells[7].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["AvailTransferOWOnOrderLbs"]);
            e.Item.Cells[8].Text = String.Format("{0:#,##0.0}", dtTotal.Rows[0]["AvailableMonths"]);
            e.Item.Cells[9].Text = String.Format("{0:#,##0.0}", dtTotal.Rows[0]["OWMonths"]);
            e.Item.Cells[10].Text = String.Format("{0:#,##0.0}", dtTotal.Rows[0]["TransferMonths"]);
            e.Item.Cells[11].Text = String.Format("{0:#,##0.0}", dtTotal.Rows[0]["AvailTransferOWMonths"]);
            e.Item.Cells[12].Text = String.Format("{0:#,##0.0}", dtTotal.Rows[0]["OnOrderMonths"]);
            e.Item.Cells[13].Text = String.Format("{0:#,##0.0}", dtTotal.Rows[0]["AvailTransferOWOnOrderMonths"]);
            e.Item.Cells[15].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["CPRBuyCartons"]);
            e.Item.Cells[16].Text = String.Format("{0:#,##0.0}", dtTotal.Rows[0]["CPRBuyMonths"]);

        }


    } 

    #endregion

}
