
/********************************************************************************************
 * File	Name			:	DocumentSalesAnalysis.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Retrive Data From Curvalsum Table - Customerwise.
 * Created By			:	Senthilkumar
 * Created Date			:	08/07/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/12/2006		    Version 1		Menaka      		Created 
 * 08/19/2006		    Version 2		Senthilkumar 		Store Procedure Name Changed
 * 09/20/2006           Version 3		Mahesh      		Implemented Ajax To Delete Excel Files on Page Unload & Comments Added
 *********************************************************************************************/

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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Utility;
using PFC.Intranet;



public partial class DocumentSalesAnalysis : System.Web.UI.Page
{
    SqlConnection cn = new SqlConnection(PFC.Intranet.Global.ReportsConnectionString);
    System.Data.DataTable dt = new System.Data.DataTable();
    DataSet dsDocumentInfo = new DataSet();
    Utility utility = new Utility();
    string strSalesRep = string.Empty;
    string strMonth = string.Empty;
    string strYear = string.Empty;
    string strBranch = string.Empty;
    string strItem = string.Empty;
    string strCustNo = string.Empty;
    string strChain = string.Empty;
    string strVersion = string.Empty;
    string strZipFrom = string.Empty;
    string strZipTo = string.Empty;
    string strOrdType = string.Empty;
    int pageSize = 16;
    System.IO.FileStream fStream;

    DataRow Total;

    protected void Page_Load(object sender, EventArgs e)
    {
        #region Get QueryString Values

        strMonth = (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "";
        strYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";
        strItem = (Request.QueryString["Item"] != null) ? Request.QueryString["Item"].ToString().Trim() : "";
        strCustNo = (Request.QueryString["CustNo"] != null) ? Request.QueryString["CustNo"].ToString().Trim() : "";
        strVersion = (Request.QueryString["Version"] != null) ? Request.QueryString["Version"].ToString().Trim() : "";
        strChain = (Request.QueryString["Chain"] != null) ? ((Request.QueryString["Chain"].ToString().Trim() != "All") ? Request.QueryString["Chain"].ToString().Trim().Replace('`', '&') : "") : "";
        strBranch = (Request.QueryString["Branch"] != null) ? Request.QueryString["Branch"].ToString().Trim() : "";
        strSalesRep = (Request.QueryString["SalesRep"] != null) ? ((Request.QueryString["SalesRep"].ToString().Trim() != "All") ? Request.QueryString["SalesRep"].ToString().Trim().Replace("|","'") : "") : "";
        strZipFrom = (Request.QueryString["ZipFrom"] != null) ? Request.QueryString["ZipFrom"].ToString().Trim() : "";
        strZipTo = (Request.QueryString["ZipTo"] != null) ? Request.QueryString["ZipTo"].ToString().Trim() : "";
        strOrdType = (Request.QueryString["OrdType"] != null) ? Request.QueryString["OrdType"].ToString().Trim() : "";

        #endregion

        utility.CheckBrowserCompatibility(Request, dgAnalysis,ref pageSize);
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(DocumentSalesAnalysis));

        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");
        ViewState["ExcelFileName"] = "DocumentSalesAnalysis" + Session["SessionID"].ToString() + name + ".xls";

        if (!IsPostBack)
        {
            DocumentDataDisplay();
        }
        DataTable dtFooter = Session["DocumentSalesGrandTotal"] as DataTable;
        Total = dtFooter.Rows[0];
    }

    public void DocumentDataDisplay()
    {

        GetDocumentData();
        ExcelExport();
        if (strVersion == "long") LongVersion(); else ShortVersion();
    }

    public void GetDocumentData()
    {
        try
        {
            int option = ((Request.QueryString["Period"].ToString().Trim() != "mtd") ? 0 : 1);
            dsDocumentInfo = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[PFC_RPT_SP_DocumentSalesAnalysis]",
                new SqlParameter("@PeriodMonth", strMonth),
                new SqlParameter("@PeriodYear", strYear),
                new SqlParameter("@OrdType", strOrdType),
                new SqlParameter("@Item", strItem),
                new SqlParameter("@CustNo", strCustNo),
                new SqlParameter("@Chain", strChain),
                new SqlParameter("@Branch", strBranch),
                new SqlParameter("@CustRep", strSalesRep.Replace("'", "''")),
                new SqlParameter("@ZipFrom", strZipFrom),
                new SqlParameter("@ZipTo", strZipTo),
                new SqlParameter("@option", option));
            dt.Clear();
            dt = dsDocumentInfo.Tables[0];

            if (dsDocumentInfo.Tables[0] != null)
            {
                Session["DocumentSalesGrandTotal"] = dsDocumentInfo.Tables[1];
            }

            dt.DefaultView.Sort = "SO#" + " " + "asc";
            Session["DocSale"] = dt;
            ViewState["SortField"] = "SO#";
            ViewState["SortMode"] = "asc";
        }
        catch (Exception ex) { Response.Write(ex.Message.ToString()); }
    }

    public void BindDataGridHeader()
    {
        dgAnalysis.Columns[0].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[1].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[2].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[3].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[4].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[5].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[6].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
    }

    public void BindDataToGrid()
    {
        try
        {
            BindDataGridHeader();
            dt = (DataTable)Session["DocSale"];
            dt.DefaultView.Sort = hidSort.Value;
            Session["DocSale"] = dt.DefaultView.ToTable();
            dgAnalysis.DataSource = dt.DefaultView.ToTable();

            Pager1.InitPager(dgAnalysis, pageSize);

            DropDownList ddl = Pager1.FindControl("ddlPages") as DropDownList;
            if (ddl.SelectedItem != null && ddl.SelectedItem.Value.ToString() == ddl.Items.Count.ToString())
            {
                dgAnalysis.ShowFooter = true;
            }
            else
                dgAnalysis.ShowFooter = false;

            if (dgAnalysis.Items.Count <= 0)
            {
                dgAnalysis.Visible = false;
                btnPrint.Visible = false;
                tblPager.Visible = false;
                lblStatus.Visible = true;
            }
            else
            {
                dgAnalysis.Visible = true;
                btnPrint.Visible = true;
                tblPager.Visible = true;
                lblStatus.Visible = false;
            }
        }
        catch (Exception ex) { Response.Write(ex.Message.ToString()); }
    }

    protected void dgAnalysis_SortCommand(object source, DataGridSortCommandEventArgs e)
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
        ExcelExport();
        if (strVersion == "long") LongVersion(); else ShortVersion();
    }

    /// <summary>
    /// Function used to change the pager index when user change the grid pager controls
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    /// <remarks></remarks>
    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgAnalysis.CurrentPageIndex = Pager1.GotoPageNumber;
        if (strVersion != "Both")
            if (strVersion == "long") LongVersion(); else ShortVersion();
        else
            BindDataToGrid();
    }

    /// <summary>
    /// Function used to change the pager index when user change the grid pager controls
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    /// <remarks></remarks>
    protected void dgAnalysis_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgAnalysis.CurrentPageIndex = e.NewPageIndex;
        if (strVersion != "Both")
            if (strVersion == "long") LongVersion(); else ShortVersion();
        else
            BindDataToGrid();

    }

    #region Web Form Designer generated code
    override protected void OnInit(EventArgs e)
    {
        //
        // CODEGEN: This call is required by the ASP.NET Web Form Designer.
        //
        InitializeComponent();
        base.OnInit(e);
    }

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
        this.Pager1.BubbleClick += new EventHandler(this.Pager_PageChanged);
    }
    #endregion

    #region Excel Export
    protected void ExcelExport()
    {
        try
        {

            if (strVersion == "long")
                CreateExcelForLongVersion(ViewState["ExcelFileName"].ToString());
            else
                CreateExcelForShortVersion(ViewState["ExcelFileName"].ToString());

            if (strVersion == "long") LongVersion(); else ShortVersion();

        }
        catch (Exception ex) { Response.Write(ex.ToString()); }
    }

    private void CreateExcelForLongVersion(string fileName)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + fileName));

        // get pathname to download excel file
        string StrPathname = Server.MapPath("..//Common//ExcelUploads//" + fileName);

        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();

        reportWriter.WriteLine("<table border=2px cellpadding=5 cellspacing=5>");
        reportWriter.WriteLine("<tr><td colspan=17  align=center><font color=blue size=15px><b>Document Sales Analysis Report</b></font></td></tr>");
        reportWriter.WriteLine("<tr><td colspan=17></td></tr>");


        reportWriter.WriteLine("<tr align=right><th align=left bgcolor=whitesmoke>Period :</th>" +
                                "<th>" + Request.QueryString["MonthName"].ToString() + "</th>" +
                                "<th>" + Request.QueryString["Year"].ToString() + "</th>" +
                                "<th>Order Type : </th>" +
                                "<th>" + ((Request.QueryString["OrdType"] != "Non-Mill") ? Request.QueryString["OrdType"].ToString().Trim() : "Warehouse") + "</th>" +
                                "<th>Branch : </th>" +
                                "<th>" + Request.QueryString["Branch"].ToString() + "</th>" +
                                "<th>Sales Rep :</th>" + "<th>" + ((Request.QueryString["SalesRep"].ToString() != "") ? Request.QueryString["SalesRep"].ToString().Replace("|","'") : "All") + "</th>" +
                                "<th colspan=2> Item :"+strItem+"</th>"+
                               "<th>Zip :</th>" + "<th>" + ((Request.QueryString["ZipFrom"] == "" && Request.QueryString["ZipTo"] == "") ? "All" : Request.QueryString["ZipFrom"].ToString() + " - " + Request.QueryString["ZipTo"].ToString()) + "</th>" +
                                "<th >Run By :</th>" +
                                "<th>" + Session["UserName"].ToString() + "</th>" +
                                " <th>Run Date :</th><th >" + DateTime.Now.ToShortDateString() + "</th></tr>");
        reportWriter.WriteLine("<tr><td colspan=17></td></tr>");

        reportWriter.WriteLine("<tr><th>" + "SO#" + "</th>" +
                                 "<th>" + "INV#" + "</th>" +
                                 "<th>" + "TYPE" + "</th>" +
                                 "<th>" + "Date" + "</th>" +
                                 "<th>" + "Sale Brn" + "</th>" +
                                 "<th>" + "Ship Brn" + "</th>" +
                                 "<th>" + "Salesperson" + "</th>" +
                                 "<th>" + "Qty" + "</th>" +
                                 "<th align=right>" + "Price Per Unit $" + "</th>" +
                                 "<th align=right>" + "Cost Per Unit $" + "</th>" +
                                 "<th align=right>" + "ExtPrice $" + "</th>" +
                                 "<th align=right>" + "ExtGM$" + "</th>" +
                                 "<th align=right>" + "GM%" + "</th>" +
                                 "<th align=right>" + "Wgt Per Unit" + "</th>" +
                                 "<th align=right>" + "ExtWgt" + "</th>" +
                                 "<th align=right>" + "$/Lb" + "</th>" +
                                 "<th align=Left>" + "Cust PO" + "</th><tr>");

        DataTable dtTemp = (DataTable)Session["DocSale"];
        dtTemp.DefaultView.Sort = hidSort.Value;
        DataTable dt1 = dtTemp.DefaultView.ToTable();

        string lineHeading = string.Empty;

        string strYearDis = "'" + strYear.Substring(2);
        string strPreYearDis = "'" + (Convert.ToInt16(strYear) - 1).ToString().Substring(2);

        foreach (DataRow dRow in dt1.Rows)
        {
            reportWriter.WriteLine("<tr><td>" + dRow[0].ToString() + "</td>" +
                                "<td align=right>" + dRow[1].ToString() + "</td>" +
                                "<td align=right>" + dRow[2].ToString() + "</td>" +
                                "<td align=right>" + dRow[3].ToString() + "</td>" +
                                "<td align=right>" + dRow[4].ToString() + "</td>" +
                                "<td align=right>" + dRow[5].ToString() + "</td>" +
                                "<td align=right>" + dRow[6].ToString() + "</td>" +
                                "<td align=right>" + ((dRow[7].ToString() != "0") ? ((dRow[7].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(dRow[7])) : "0") : "0") + "</td>" +
                                "<td align=right>" + ((dRow[8].ToString() != "0") ? ((dRow[8].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(dRow[8])) : "0") : "0") + "</td>" +
                                "<td align=right>" + ((dRow[9].ToString() != "0") ? ((dRow[9].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(dRow[9])) : "0") : "0") + "</td>" +
                                "<td align=right>" + ((dRow[10].ToString() != "0") ? ((dRow[10].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(dRow[10])) : "0") : "0") + "</td>" +
                                "<td align=right>" + ((dRow[11].ToString() != "0") ? ((dRow[11].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(dRow[11])) : "0") : "0") + "</td>" +
                                "<td align=right>" + ((dRow[12].ToString() != "0") ? ((dRow[12].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(dRow[12])) : "0") : "0") + "</td>" +
                                "<td align=right>" + ((dRow[13].ToString() != "0") ? ((dRow[13].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(dRow[13])) : "0") : "0") + "</td>" +
                                "<td align=right>" + ((dRow[14].ToString() != "0") ? ((dRow[14].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(dRow[14])) : "0") : "0") + "</td>" +
                                "<td align=right>" + ((dRow[15].ToString() != "0") ? ((dRow[15].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(dRow[15])) : "0") : "0") + "</td>" +
                                "<td align=Left>" + dRow[16].ToString() + "</td></tr>");
        }


        string lineFooter = string.Empty;
        DataTable dtFooter = Session["DocumentSalesGrandTotal"] as DataTable;
        Total = dtFooter.Rows[0];

        reportWriter.WriteLine("<tr><th align=right>Total</th>" +
                             "<th align=right> </th>" +
                             "<th align=right> </th>" +
                             "<th align=right> </th>" +
                             "<th align=right> </th>" +
                             "<th align=right> </th>" +
                             "<th align=right> </th>" +
                             "<th align=right> " + ((Total[7].ToString() != "0") ? ((Total[7].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[7])) : "0") : "0") + "</th>" +
                             "<th align=right> </th>" +
                             "<th align=right> </th>" +
                             "<th align=right> " + ((Total[10].ToString() != "0") ? ((Total[10].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[10])) : "0") : "0") + "</th>" +
                             "<th align=right> " + ((Total[11].ToString() != "0") ? ((Total[11].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[11])) : "0") : "0") + "</th>" +
                             "<th align=right> " + ((Total[12].ToString() != "0") ? ((Total[12].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(Total[12])) : "0") : "0") + "</th>" +
                             "<th align=right> </th>" +
                             "<th align=right>" + ((Total[14].ToString() != "0") ? ((Total[14].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[14])) : "0") : "0") + " </th>" +
                             "<th align=right>" + ((Total[15].ToString() != "0") ? ((Total[15].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(Total[15])) : "0") : "0") + " </th>" +
                             "<th align=right> </th></tr>");



        reportWriter.WriteLine("</table>");

        reportWriter.Close();
    }

    private void CreateExcelForShortVersion(string fileName)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + fileName));

        // get pathname to download excel file
        string StrPathname = Server.MapPath("..//Common//ExcelUploads//" + fileName);
        string strYearDis = "'" + strYear.Substring(2);
        string strPreYearDis = "'" + (Convert.ToInt16(strYear) - 1).ToString().Substring(2);
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();

        reportWriter.WriteLine("<table border=2px cellpadding=5 cellspacing=5>");
        reportWriter.WriteLine("<tr><td colspan=14  align=center><font color=blue size=15px><b>Document Sales Analysis Report</b></font></td></tr>");
        reportWriter.WriteLine("<tr><td colspan=14></td></tr>");


        reportWriter.WriteLine("<tr align=right><th align=left bgcolor=whitesmoke>Period :</th>" +
                                "<th>" + Request.QueryString["MonthName"].ToString() + " " +
                                Request.QueryString["Year"].ToString() + "</th>" +
                                "<th>Branch : </th>" +
                                "<th>" + Request.QueryString["Branch"].ToString() + "</th>" +
                                "<th>Sales Rep :</th>" + "<th>" + ((Request.QueryString["SalesRep"].ToString() != "") ? Request.QueryString["SalesRep"].ToString().Replace("|", "'") : "All") + "</th>" +
                                "<th colspan=2> Item :" + strItem + "</th>" +
                                "<th>Zip :</th>" + "<th>" + ((Request.QueryString["ZipFrom"] == "" && Request.QueryString["ZipTo"] == "") ? "All" : Request.QueryString["ZipFrom"].ToString() + " - " + Request.QueryString["ZipTo"].ToString()) + "</th>" +
                                "<th >Run By :</th>" +
                                "<th>" + Session["UserName"].ToString() + "</th>" +
                                " <th>Run Date :</th><th>" + DateTime.Now.Month.ToString() +
                                "/" + DateTime.Now.Day.ToString() + "/" + DateTime.Now.Year + "</th></tr>");
        reportWriter.WriteLine("<tr><td colspan=14></td></tr>");

        reportWriter.WriteLine("<th>" + "SO#" + "</th>" +
                                 "<th>" + "INV#" + "</th>" +
                                 "<th>" + "TYPE" + "</th>" +
                                 "<th>" + "Date" + "</th>" +
                                 "<th>" + "Sale Brn" + "</th>" +
                                 "<th>" + "Ship Brn" + "</th>" +
                                 "<th>" + "Salesperson" + "</th>" +
                                 "<th>" + "Qty" + "</th>" +
                                 "<th>" + "Price Per Unit $" + "</th>" +
                                 "<th>" + "Cost Per Unit $" + "</th>" +
                                 "<th>" + "ExtPrice $" + "</th>" +
                                 "<th>" + "GM%" + "</th>" +
                                 "<th>" + "$/Lb" + "</th>" +
                                 "<th align=Left>" + "Cust PO" + "</th>");

        DataTable dtTemp = (DataTable)Session["DocSale"];
        dtTemp.DefaultView.Sort = hidSort.Value;
        DataTable dt1 = dtTemp.DefaultView.ToTable();

        foreach (DataRow dRow in dt1.Rows)
        {
            reportWriter.WriteLine("<tr><td>" + dRow[0].ToString() + "</td>" +
                                "<td>" + dRow[1].ToString() + "</td>" +
                                "<td>" + dRow[2].ToString() + "</td>" +
                                "<td>" + dRow[3].ToString() + "</td>" +
                                "<td>" + dRow[4].ToString() + "</td>" +
                                "<td>" + dRow[5].ToString() + "</td>" +
                                "<td>" + dRow[6].ToString() + "</td>" +
                                "<td>" + ((dRow[7].ToString() != "0") ? ((dRow[7].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(dRow[7])) : "0") : "0") + "</td>" +
                                "<td>" + ((dRow[8].ToString() != "0") ? ((dRow[8].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(dRow[8])) : "0") : "0") + "</td>" +
                                "<td>" + ((dRow[9].ToString() != "0") ? ((dRow[9].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(dRow[9])) : "0") : "0") + "</td>" +
                                "<td>" + ((dRow[10].ToString() != "0") ? ((dRow[10].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(dRow[10])) : "0") : "0") + "</td>" +
                                "<td>" + ((dRow[12].ToString() != "0") ? ((dRow[12].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(dRow[12])) : "0") : "0") + "</td>" +
                                "<td>" + ((dRow[15].ToString() != "0") ? ((dRow[15].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(dRow[15])) : "0") : "0") + "</td>" +
                                "<td align=Left>" + dRow[16].ToString() + "</td></tr>");
        }
        DataTable dtFooter = Session["DocumentSalesGrandTotal"] as DataTable;
        Total = dtFooter.Rows[0];
        string lineHeading = string.Empty;



        reportWriter.WriteLine("<tr><th>Total</th>" +
                             "<th> </th>" +
                             "<th> </th>" +
                             "<th> </th>" +
                             "<th> </th>" +
                             "<th> </th>" +
                             "<th> </th>" +
                             "<th align=right> " + ((Total[7].ToString() != "0") ? ((Total[7].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[7])) : "0") : "0") + "</th>" +
                             "<th> </th>" +
                             "<th> </th>" +
                             "<th align=right> " + ((Total[10].ToString() != "0") ? ((Total[10].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[10])) : "0") : "0") + "</th>" +
                             "<th align=right> " + ((Total[12].ToString() != "0") ? ((Total[12].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(Total[12])) : "0") : "0") + "</th>" +
                             "<th align=right>" + ((Total[15].ToString() != "0") ? ((Total[15].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(Total[15])) : "0") : "0") + " </th>" +
                             "<th> </th></tr>");

        reportWriter.WriteLine("</table>");
        reportWriter.Close();

    }
    #endregion

    protected void rdoReportVersion1_CheckedChanged(Object sender, System.EventArgs e)
    {
        ExcelExport();
        LongVersion();
    }

    protected string GetFileURL()
    {
        string url = "../Common/ExcelUploads/" + ViewState["ExcelFileName"].ToString();
        return url;
    }

    public void LongVersion()
    {
        dgAnalysis.Columns[11].Visible = true;
        dgAnalysis.Columns[13].Visible = true;
        dgAnalysis.Columns[14].Visible = true;
        dgAnalysis.Width = 1200;
        BindDataToGrid();
    }

    protected void rdoReportVersion2_CheckedChanged(Object sender, System.EventArgs e)
    {
        ExcelExport();
        ShortVersion();
    }

    public void ShortVersion()
    {
        dgAnalysis.Columns[11].Visible = false;
        dgAnalysis.Columns[13].Visible = false;
        dgAnalysis.Columns[14].Visible = false;
        dgAnalysis.Width = 1000;
        BindDataToGrid();
    }

    protected void btnPrint_Click(Object sender, System.EventArgs e)
    {

        RegisterClientScriptBlock("PopUp", "<script>PrintReport('" + strVersion + "')</script>");
        ExcelExport();
        if (strVersion == "long") LongVersion(); else ShortVersion();
    }

    protected void dgAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.Footer && Session["DocumentSalesGrandTotal"] != null)
        {
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[0].CssClass = "GridHead";
            DataTable dtGrandTotal = Session["DocumentSalesGrandTotal"] as DataTable;
            Total = dtGrandTotal.Rows[0];
            decimal dmlGrandTotal;
            for (int i = 1; i <= 16; i++)
            {
                dmlGrandTotal = 0;
                if (Total[i].ToString() != "")
                    dmlGrandTotal = Convert.ToDecimal(Total[i].ToString());

                e.Item.Cells[i].Text = (i == 12 || i == 15) ? (i == 12) ? String.Format("{0:0.0}", dmlGrandTotal) : String.Format("{0:0.00}", dmlGrandTotal) : String.Format("{0:#,###}", dmlGrandTotal);

                e.Item.Cells[i].HorizontalAlign = HorizontalAlign.Right;
                e.Item.Cells[i].CssClass = "GridHead";
            }
        }

       

    }

    #region Ajax Function To Delete The Excel Files

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\Common\\ExcelUploads"));

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
