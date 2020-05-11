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

public partial class MonthlyPurchasingBudget : System.Web.UI.Page
{
    #region Global Variables

    private DataTable dtTotal = new DataTable();
    private DataSet dsPurchBudget = new DataSet();
    private string keyColumn = "RecSort";
    private string reportRecs = "G";
    private string reportFilter = "";
    private string sortExpression = string.Empty;
    protected string reportLevel = string.Empty;
    int pagesize = 20;
    protected MnthlyPrchasingBdgt MnthlyPrchasingBdgtData = new MnthlyPrchasingBdgt();

    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(MonthlyPurchasingBudget));
        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");

        hidSort.Value = keyColumn;
        hidFileName.Value = "MonthlyPurchasingBudget" + Session["SessionID"].ToString() + name + ".xls";
        lblMenuName.Text = "Monthly Purchasing Budget";
        reportLevel = "C";
        if (Request.QueryString["ReportType"] != null)
        {
            reportRecs = Request.QueryString["ReportType"].ToString();
            reportFilter = Request.QueryString["ReportFilter"].ToString();
            lblMenuName.Text = "Detail for " + reportFilter + " - " + Request.QueryString["ReportDesc"].ToString();
            reportLevel = "I";
        }

        if (!IsPostBack)
            BindDataGrid();
    } 

    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        sortExpression = ((hidSort.Value != "") ? hidSort.Value : keyColumn);
        switch (reportRecs)
        { 
            case "I":
                dsPurchBudget = MnthlyPrchasingBdgtData.GetCatItems(reportFilter);
                break;
            case "C":
                dsPurchBudget = MnthlyPrchasingBdgtData.GetGroupsCats(reportFilter);
                break;
            default:
                dsPurchBudget = MnthlyPrchasingBdgtData.GetAllBdgt();
                break;
        }

        dtTotal = dsPurchBudget.Tables[0];
        dtTotal.DefaultView.Sort = sortExpression;
        dtTotal = dsPurchBudget.Tables[0].DefaultView.ToTable();
        if (dtTotal.Rows.Count > 0)
        {
            GetTotal();
            dgPurchBudget.DataSource = dsPurchBudget.Tables[0].DefaultView.ToTable();
            dgPurchBudget.DataBind();
            Pager1.InitPager(dgPurchBudget, pagesize);
            Pager1.Visible = true;

        }
        else
            Pager1.Visible = false;
        lblStatus.Text = "No Records Found";
        lblStatus.Visible = (dgPurchBudget.Items.Count < 1) ? true : false;
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

    protected void dgPurchBudget_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgPurchBudget.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
    }

    protected void dgPurchBudget_SortCommand(object source, DataGridSortCommandEventArgs e)
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

    protected void dgPurchBudget_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {

            HyperLink hplButton = e.Item.Cells[0].Controls[1] as HyperLink;
            if (reportRecs == "I")
            {
                hplButton.Visible = false;
                Label _lblCatGroup = e.Item.Cells[0].FindControl("lblCatGroup") as Label;
                _lblCatGroup.Visible = true;
            }
            else
            {
                hplButton.ForeColor = System.Drawing.Color.Blue;
                hplButton.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'popupwindow" + reportRecs + "', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");
            }

        }

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

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgPurchBudget.CurrentPageIndex = Pager1.GotoPageNumber;
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
        switch (reportRecs)
        {
            case "I":
                dsPurchBudget = MnthlyPrchasingBdgtData.GetCatItems(reportFilter);
                break;
            case "C":
                dsPurchBudget = MnthlyPrchasingBdgtData.GetGroupsCats(reportFilter);
                break;
            default:
                dsPurchBudget = MnthlyPrchasingBdgtData.GetAllBdgt();
                break;
        }
        dtTotal = dsPurchBudget.Tables[0];
        dtTotal.DefaultView.Sort = sortExpression;
        dtTotal = dsPurchBudget.Tables[0].DefaultView.ToTable();
        headerContent = "<table border='1'>";
        headerContent += "<tr><th colspan='18' style='color:blue'>" + lblMenuName.Text + "</th></tr>";
        headerContent += "<tr><th colspan='6' align='left'>Fiscal Period :" + MnthlyPrchasingBdgtData.GetDateCondition() + "&nbsp;&nbsp;" + "</th><th colspan='6'>Run By : " + Session["UserName"].ToString() + "</th><th colspan='6'>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>";
        headerContent += "<tr><th></th><th colspan='7' align='center' style='background-color:aliceblue;'>Pounds</th><th colspan='6' style='background-color:lightgreen;'>Months</th><th colspan='4'></th></tr>";
        headerContent += "<tr><th align=center>Grp</th><th style='background-color:aliceblue;'>Usage</th><th style='background-color:aliceblue;'>Avail</th><th style='width:80px;background-color:aliceblue;'>OTW</th>";
        headerContent += "<th style='background-color:aliceblue;'>In Transit</th><th style='width:100px;background-color:aliceblue;'>SubTotal</th><th style='width:100px;background-color:aliceblue;'>On Order</th>";
        headerContent += "<th style='background-color:aliceblue;'>Total</th><th style='background-color:lightgreen;'>Avail</th><th style='background-color:lightgreen;'>OTW</th><th style='background-color:lightgreen;'>In Transit</th><th style='background-color:lightgreen;'>SubTotal</th><th style='background-color:lightgreen;'>On Order</th><th style='background-color:lightgreen;'>Total</th>";
        headerContent += "<th>Factor</th><th>Cartons</th><th>Buy Months</th><th>Category Description </th></tr>";
        foreach (DataRow roiReader in dtTotal.Rows)
        {
            excelContent += "<tr><td align=center>" + roiReader["RecordKey"].ToString() + "</td><td>" +
                 String.Format("{0:#,##0}", roiReader["MonthlyUseLbs"]) + "</td><td>" +
                 String.Format("{0:#,##0}", roiReader["AvailableLbs"]) + "</td><td>" +
                 String.Format("{0:#,##0}", roiReader["OWLbs"]) + "</td><td>" +
                 String.Format("{0:#,##0}", roiReader["TransferLbs"]) + "</td><td>" +
                 String.Format("{0:#,##0}", roiReader["AvailTransferOWLbs"]) + "</td><td>" +
                 String.Format("{0:#,##0}", roiReader["OnOrderLbs"]) + "</td><td>" +
                 String.Format("{0:#,##0}", roiReader["AvailTransferOWOnOrderLbs"]) + "</td><td>" +
                 String.Format("{0:#,##0.0}", roiReader["AvailableMonths"]) + "</td><td>" +
                 String.Format("{0:#,##0.0}", roiReader["OWMonths"]) + "</td><td>" +
                 String.Format("{0:#,##0.0}", roiReader["TransferMonths"]) + "</td><td>" +
                 String.Format("{0:#,##0.0}", roiReader["AvailTransferOWMonths"]) + "</td><td>" +
                 String.Format("{0:#,##0.0}", roiReader["OnOrderMonths"]) + "</td><td>" +
                 String.Format("{0:#,##0.0}", roiReader["AvailTransferOWOnOrderMonths"]) + "</td><td>" +
                 String.Format("{0:#,##0.0}", roiReader["CPRFactor"]) + "</td><td>" +
                 String.Format("{0:#,##0}", roiReader["CPRBuyCartons"]) + "</td><td>" +
                 String.Format("{0:#,##0.0}", roiReader["CPRBuyMonths"]) + "</td><td>" +
                 roiReader["RecordDesc"].ToString() + "</td></tr>";

        }
        GetTotal();

        footerContent = "<tr style='font-weight:bold;'><td align=center>Total</td><td>" +
                  String.Format("{0:#,##0}", dtTotal.Rows[0]["MonthlyUseLbs"]) + "</td><td>" +
                  String.Format("{0:#,##0}", dtTotal.Rows[0]["AvailableLbs"]) + "</td><td>" +
                  String.Format("{0:#,##0.00}", dtTotal.Rows[0]["OWLbs"]) + "</td><td>" +
                  String.Format("{0:#,##0.000}", dtTotal.Rows[0]["TransferLbs"]) + "</td><td>" +
                  String.Format("{0:#,##0}", dtTotal.Rows[0]["AvailTransferOWLbs"]) + "</td><td>" +
                  String.Format("{0:#,##0}", dtTotal.Rows[0]["OnOrderLbs"]) + "</td><td>" +
                  String.Format("{0:#,##0}", dtTotal.Rows[0]["AvailTransferOWOnOrderLbs"]) + "</td><td>" +
                  String.Format("{0:#,##0.0}", dtTotal.Rows[0]["AvailableMonths"]) + "</td><td>" +
                  String.Format("{0:#,##0.0}", dtTotal.Rows[0]["OWMonths"]) + "</td><td>" +
                  String.Format("{0:#,##0.0}", dtTotal.Rows[0]["TransferMonths"]) + "</td><td>" +
                  String.Format("{0:#,##0.0}", dtTotal.Rows[0]["AvailTransferOWMonths"]) + "</td><td>" +
                  String.Format("{0:#,##0.0}", dtTotal.Rows[0]["OnOrderMonths"]) + "</td><td>" +
                  String.Format("{0:#,##0.0}", dtTotal.Rows[0]["AvailTransferOWOnOrderMonths"]) + "</td><td></td><td>" +
                  String.Format("{0:#,##0}", dtTotal.Rows[0]["CPRBuyCartons"]) + "</td><td>" +
                  String.Format("{0:#,##0}", dtTotal.Rows[0]["CPRBuyMonths"]) + "</td>" +
                  "<td></td></tr>";


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
        /*
        */
    }

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\DayInventoryReport\\Common\\ExcelUploads"));

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
