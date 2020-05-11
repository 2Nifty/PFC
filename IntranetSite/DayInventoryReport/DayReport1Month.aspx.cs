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

public partial class DayReport : System.Web.UI.Page
{
    #region Global Variables

    private DataTable dtTotal = new DataTable();
    private DataSet dsDayReport = new DataSet();
    private string keyColumn = "CategoryGroup";
    private string sortExpression = string.Empty;
    protected string strStatus = string.Empty;
    int pagesize = 20;
    protected DayInventoryReport DayInventoryReport = new DayInventoryReport();

    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(DayReport));
        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");

        hidFileName.Value = "DayReport" + Session["SessionID"].ToString() + name + ".xls";
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
        sortExpression = ((hidSort.Value != "") ? " ORDER BY  " + hidSort.Value : " ORDER BY " + keyColumn);
        dsDayReport = DayInventoryReport.GetDayReport(strStatus, sortExpression);
        dtTotal = dsDayReport.Tables[0].DefaultView.ToTable();

        if (dtTotal.Rows.Count > 0)
        {
            GetTotal();
            dgDayReport.DataSource = dsDayReport.Tables[0];
            dgDayReport.DataBind();
            Pager1.InitPager(dgDayReport, pagesize);
            Pager1.Visible = true;

        }
        else
            Pager1.Visible = false;
        lblStatus.Text = "No Records Found";
        lblStatus.Visible = (dgDayReport.Items.Count < 1) ? true : false;
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

        //drow["pctCorp"] = Convert.ToString(Math.Round(Convert.ToDecimal(dsCatGroup.Tables[0].Compute("avg(pctCorp)", "")), 1));
        //drow["pctCorpGM"] = Convert.ToString(Math.Round(Convert.ToDecimal(dsCatGroup.Tables[0].Compute("avg(pctCorpGM)", "")), 1));

        dtTotal.Rows.Add(drow);
    } 

    #endregion

    #region Event

    protected void dgDayReport_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgDayReport.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
    }

    protected void dgDayReport_SortCommand(object source, DataGridSortCommandEventArgs e)
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

    protected void dgDayReport_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {

            HyperLink hplButton = e.Item.Cells[0].Controls[1] as HyperLink;
            if (strStatus == "36MonthUsage")
            {
                hplButton.Visible = false;
                Label _lblCatGroup = e.Item.Cells[0].FindControl("lblCatGroup") as Label;
                _lblCatGroup.Visible = true;
            }
            else
            {
                hplButton.ForeColor = System.Drawing.Color.Blue;
                hplButton.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'popupwindow2', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");
            }

        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[1].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["ContainersOH"]);
            e.Item.Cells[2].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["InvExtCost"]);
            e.Item.Cells[3].Text = String.Format("{0:#,##0.00}", dtTotal.Rows[0]["AvgCstPerDay"]);
            e.Item.Cells[4].Text = String.Format("{0:#,##0.000}", dtTotal.Rows[0]["DaysOH"]);
            e.Item.Cells[5].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["OHover150Days"]);
            e.Item.Cells[6].Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["OHover365Days"]);
            e.Item.Cells[7].Text = dtTotal.Rows[0]["CategoryDsc"].ToString();

        }


    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgDayReport.CurrentPageIndex = Pager1.GotoPageNumber;
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
        string sortExpression = ((hidSort.Value != "") ? " ORDER BY  " + hidSort.Value : " ORDER BY " + keyColumn);
        dsDayReport = DayInventoryReport.GetDayReport(strStatus,sortExpression);
        dtTotal = dsDayReport.Tables[0].DefaultView.ToTable();
        headerContent = "<table border='1'>";
        headerContent += "<tr><th colspan='8' style='color:blue'>" + lblMenuName.Text + "</th></tr>";
        headerContent += "<tr><th colspan='4' align='left'>Fiscal Period :" + DayInventoryReport.GetDateCondition() + "&nbsp;&nbsp;" + Request.QueryString["Year"] + "</th><th colspan='2'>Run By : " + Session["UserName"].ToString() + "</th><th colspan='2'>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>";
        headerContent += "<tr><th align=center>Cat Grp</th><th>Qty O/H</th><th>$ O/H</th><th style='width:80px;'>Daily Usg $ @ Avg Cost</th><th>Days Supply</th><th style='width:100px;'>$ Value Days Supply > 150D</th><th style='width:100px;'>$ Value Days Supply > 365D </th><th>Category Description </th></tr>";
        foreach (DataRow roiReader in dtTotal.Rows)
        {
            excelContent += "<tr><td align=center>" + roiReader["CategoryGroup"].ToString() + "</td><td>" +
                 String.Format("{0:#,##0}", roiReader["ContainersOH"]) + "</td><td>" +
                 String.Format("{0:#,##0}", roiReader["InvExtCost"]) + "</td><td>" +
                 String.Format("{0:#,##0.00}", roiReader["AvgCstPerDay"]) + "</td><td>" +
                 String.Format("{0:#,##0.000}", roiReader["DaysOH"]) + "</td><td>" +
                 String.Format("{0:#,##0}", roiReader["OHover150Days"]) + "</td><td>" +
                 String.Format("{0:#,##0}", roiReader["OHover365Days"]) + "</td><td>" +
                 roiReader["CategoryDsc"].ToString() + "</td></tr>";

        }
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

        footerContent = "<tr style='font-weight:bold;'><td align=center>Grand Total</td><td>" +
                  String.Format("{0:#,##0}", dtTotal.Rows[0]["ContainersOH"]) + "</td><td>" +
                  String.Format("{0:#,##0}", dtTotal.Rows[0]["InvExtCost"]) + "</td><td>" +
                  String.Format("{0:#,##0.00}", dtTotal.Rows[0]["AvgCstPerDay"]) + "</td><td>" +
                  String.Format("{0:#,##0.000}", dtTotal.Rows[0]["DaysOH"]) + "</td><td>" +
                  String.Format("{0:#,##0}", dtTotal.Rows[0]["OHover150Days"]) + "</td><td>" +
                  String.Format("{0:#,##0}", dtTotal.Rows[0]["OHover365Days"]) + "</td><td></td></tr>";


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
