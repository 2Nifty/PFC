/********************************************************************************************
 * File	Name			:	CustomerSalesAnalysis.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Retrive Data From Curvalsum Table - Customerwise.
 * Created By			:	Senthilkumar
 * Created Date			:	08/07/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/12/2006		    Version 1		Menaka		        Created
 * 08/19/2006		    Version 2		Senthilkumar 		Store Procedure Name Changed
 * 09/19/2006		    Version 3		Senthilkumar 		Change The Format of The Excel Sheet
 * 09/20/2006           Version 4		Mahesh      		Implemented Ajax To Delete Excel Files on Page Unload & Comments Added
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
using PFC.Intranet;
using PFC.Intranet.Utility;
using System.Reflection;


public partial class CustomerSalesAnalysis : System.Web.UI.Page
{
    SqlConnection cn = new SqlConnection(PFC.Intranet.Global.ReportsConnectionString);
    System.Data.DataTable dt = new System.Data.DataTable();
    DataSet ds = new DataSet();
    DataSet dsCustomerInfo = new DataSet();
    DataRow Total;
    Utility utility = new Utility();

    string strMonth = string.Empty;
    string strYear = string.Empty;
    string strBranch = string.Empty;
    string strChain = string.Empty;
    string strCustNo = string.Empty;
    string strZipFrom = string.Empty;
    string strZipTo = string.Empty;
    string strOrdType = string.Empty;
    System.IO.FileStream fStream;
    string strSalesRep = string.Empty;
    int pagesize = 16;

    protected void Page_Load(object sender, EventArgs e)
    {
        utility.CheckBrowserCompatibility(Request, dgAnalysis, ref pagesize);

        #region Get QueryString Values

        strOrdType = (Request.QueryString["OrdType"] != null) ? Request.QueryString["OrdType"].ToString().Trim() : "";
        strMonth = (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "";
        strYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";
        //strYear = ((Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) ? Request.QueryString["Year"].ToString().Trim() :                   Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString().Trim()) + 1));
        strBranch = (Request.QueryString["Branch"] != "0") ? Request.QueryString["Branch"].ToString().Trim() : "";
        strChain = (Request.QueryString["Chain"] != null) ? ((Request.QueryString["Chain"].ToString().Trim() != "All") ? Request.QueryString["Chain"].ToString().Trim().Replace('`', '&') : "") : "";
        strCustNo = (Request.QueryString["CustNo"] != null) ? Request.QueryString["CustNo"].ToString().Trim() : "";
        strSalesRep = (Request.QueryString["SalesRep"] != null) ? ((Request.QueryString["SalesRep"].ToString().Trim() != "All") ? Request.QueryString["SalesRep"].ToString().Trim().Replace("|", "'") : "") : "";
        strZipFrom = (Request.QueryString["ZipFrom"] != null) ? Request.QueryString["ZipFrom"].ToString().Trim() : "";
        strZipTo = (Request.QueryString["ZipTo"] != null) ? Request.QueryString["ZipTo"].ToString().Trim() : "";

        #endregion

        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");
        ViewState["ExcelFileName"] = "CustomerSalesAnalysis" + Session["SessionID"].ToString() + name + ".xls";

        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(CustomerSalesAnalysis));
        if (hidSort.Value == "")
            hidSort.Value = " SalesLoc,CustNo";

        if (!IsPostBack)
        {
            hidReport.Value = "ytd"; hidVersion.Value = "long";
            CustomerDataDisplay();
        }

        DataTable dtFooter = Session["GrandTotal"] as DataTable;
        Total = dtFooter.Rows[0];
    }

    public void CustomerDataDisplay()
    {
        GetCustomerData();
        ExcelExport();
        ChangeVersion();
        DetVersion();
    }

    public void BindDataGridHeader()
    {

        string strYearNew = ((Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) ? Request.QueryString["Year"].ToString().Trim() :
                     Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString().Trim()) + 1));

        string strYearDis = "'" + strYearNew.Substring(2);
        string strPreYearDis = "'" + (Convert.ToInt16(strYearNew) - 1).ToString().Substring(2);

        dgAnalysis.Columns[0].HeaderText = "Cust #";
        dgAnalysis.Columns[1].HeaderText = "Name";
        dgAnalysis.Columns[2].HeaderText = "City";
        dgAnalysis.Columns[3].HeaderText = "Brn";
        dgAnalysis.Columns[4].HeaderText = "Chain";
        dgAnalysis.Columns[5].HeaderText = strYearDis + " Sales $";
        dgAnalysis.Columns[6].HeaderText = strPreYearDis + " Sales $";
        dgAnalysis.Columns[7].HeaderText = strYearDis + " GM$";
        dgAnalysis.Columns[8].HeaderText = strYearDis + " GM%";
        dgAnalysis.Columns[9].HeaderText = strPreYearDis + " GM$";
        dgAnalysis.Columns[10].HeaderText = strPreYearDis + " GM%";
        dgAnalysis.Columns[11].HeaderText = strYearDis + " Wgt";
        dgAnalysis.Columns[12].HeaderText = strYearDis + " $/Lb";
        dgAnalysis.Columns[13].HeaderText = strPreYearDis + " Wgt";
        dgAnalysis.Columns[14].HeaderText = strPreYearDis + " $/Lb";
        dgAnalysis.Columns[15].HeaderText = "YTD " + strYearDis + " Sales $";
        dgAnalysis.Columns[16].HeaderText = "YTD " + strPreYearDis + " Sales $";
        dgAnalysis.Columns[17].HeaderText = "YTD " + strYearDis + " GM$";
        dgAnalysis.Columns[18].HeaderText = "YTD " + strYearDis + " GM%";
        dgAnalysis.Columns[19].HeaderText = "YTD " + strYearDis + " Exp$";
        dgAnalysis.Columns[20].HeaderText = "YTD " + strYearDis + " NP$";
        dgAnalysis.Columns[21].HeaderText = "Accum " + strYearDis + " NP$";
        dgAnalysis.Columns[22].HeaderText = "YTD " + strPreYearDis + " GM$";
        dgAnalysis.Columns[23].HeaderText = "YTD " + strPreYearDis + " GM%";
        dgAnalysis.Columns[24].HeaderText = "YTD " + strPreYearDis + " Exp$";
        dgAnalysis.Columns[25].HeaderText = "YTD " + strPreYearDis + " NP$";
        dgAnalysis.Columns[26].HeaderText = "Accum " + strPreYearDis + " NP$";
        dgAnalysis.Columns[27].HeaderText = "YTD " + strYearDis + " Wgt";
        dgAnalysis.Columns[28].HeaderText = "YTD " + strYearDis + " $/Lb";
        dgAnalysis.Columns[29].HeaderText = "YTD " + strPreYearDis + " Wgt";
        dgAnalysis.Columns[30].HeaderText = "YTD " + strPreYearDis + " $/Lb";
        dgAnalysis.Columns[31].HeaderText = "Rep";
        dgAnalysis.Columns[32].HeaderText = "Group";
        dgAnalysis.Columns[33].HeaderText = "Zip";
        dgAnalysis.Columns[34].HeaderText = "PFC Rep";
        dgAnalysis.Columns[35].HeaderText = "ABC";
        dgAnalysis.Columns[36].HeaderText = "YTD Budget$";

        dgAnalysis.Columns[34].HeaderStyle.Wrap = false;
        dgAnalysis.Columns[36].HeaderStyle.Wrap = false;

        dgAnalysis.Columns[0].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[1].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[2].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[3].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[4].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[31].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[32].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[34].HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
        dgAnalysis.Columns[36].HeaderStyle.HorizontalAlign = HorizontalAlign.Center;
    }

    public void GetCustomerData()
    {
        try
        {

            dsCustomerInfo = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[PFC_RPT_SP_CustomerSalesAnalysis]",
                new SqlParameter("@PeriodMonth", strMonth),
                new SqlParameter("@PeriodYear", strYear),
                new SqlParameter("@OrdType", strOrdType),
                new SqlParameter("@Branch", strBranch),
                new SqlParameter("@Chain", strChain),
                new SqlParameter("@CustNo", strCustNo),
                new SqlParameter("@CustRep", strSalesRep.Replace("'", "''")),
                new SqlParameter("@ZipFrom", strZipFrom),
                new SqlParameter("@ZipTo", strZipTo),
                new SqlParameter("@OrdBy", hidSort.Value));


            dt.Clear();
            dt = dsCustomerInfo.Tables[0];
            if (dsCustomerInfo.Tables[1] != null)
            {
                Session["GrandTotal"] = dsCustomerInfo.Tables[1];
            }

            dt.DefaultView.Sort = "CustNo" + " " + "asc";
            Session["CustomerSale"] = dt;
            ViewState["SortField"] = "CustNo";
            ViewState["SortMode"] = "asc";

        }
        catch (Exception ex) { Response.Write(ex.Message.ToString()); }
    }

    protected string GetFileURL()
    {
        string url = "../Common/ExcelUploads/" + ViewState["ExcelFileName"].ToString();
        return url;
    }

    public void BindDataToGrid()
    {
        try
        {

            BindDataGridHeader();
            // dt = (DataTable)Session["CustomerSale"];
            //  dt.DefaultView.Sort = hidSort.Value;
            ds = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[PFC_RPT_SP_CustomerSalesAnalysis]",
                new SqlParameter("@PeriodMonth", strMonth),
                new SqlParameter("@PeriodYear", strYear),
                new SqlParameter("@OrdType", strOrdType),
                new SqlParameter("@Branch", strBranch),
                new SqlParameter("@Chain", strChain),
                new SqlParameter("@CustNo", strCustNo),
                new SqlParameter("@CustRep", strSalesRep.Replace("'", "''")),
                new SqlParameter("@ZipFrom", strZipFrom),
                new SqlParameter("@ZipTo", strZipTo),
                new SqlParameter("@OrdBy", hidSort.Value));

            dt = ds.Tables[0];
            Session["CustomerSale"] = dt.DefaultView.ToTable();
            if (ds.Tables[1] != null)
            {
                Session["GrandTotal"] = ds.Tables[1];
            }
            dgAnalysis.DataSource = dt.DefaultView.ToTable();
            Pager1.InitPager(dgAnalysis, pagesize);

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
                tblPager.Visible = false;
                lblStatus.Visible = true;
            }
            else
            {
                dgAnalysis.Visible = true;
                tblPager.Visible = true;
                lblStatus.Visible = false;
            }

        }
        catch (Exception ex) { Response.Write(ex.Message.ToString()); }
    }

    protected void dgAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            string url = string.Empty;
            string casURL = Global.IntranetSiteURL + "CustomerActivitySheet/FrameSet/CASFrameSet.aspx?Month=" + Request.QueryString["Month"].Trim() + "&Year=" + Request.QueryString["Year"].Trim() + "&Branch=" + e.Item.Cells[3].Text + "&Chain=" + e.Item.Cells[4].Text.Replace("&", "||") + "&CustNo=" + e.Item.Cells[0].Text + "&MonthName=" + Request.QueryString["MonthName"].Trim() + "&BranchName=" + Request.QueryString["BranchName"].Trim() + "&SalesRep=" + strSalesRep;

            // Code to display progress bar on page load
            url = "ItemSalesAnalysis.aspx?Chain=~CustNo=" + e.Item.Cells[0].Text + "~MonthName=" + Request.QueryString["MonthName"] + "~Month=" + Request.QueryString["Month"] + "~Year=" + Request.QueryString["Year"] + "~Branch=" + e.Item.Cells[3].Text + "~BranchName=" + e.Item.Cells[3].Text + "~Version=" + hidVersion.Value + "~Format=" + hidReport.Value + "~SalesRep=" + strSalesRep.Replace("'", "|") + "~ZipFrom=" + strZipFrom + "~ZipTo=" + strZipTo + "~OrdType=" + Request.QueryString["OrdType"];
            url = "ProgressBar.aspx?destPage=" + url;
            HyperLink hplButton = new HyperLink();
            hplButton.Text = "<div oncontextmenu=\"Javascript:return false;\" id=div" + e.Item.ItemIndex + "CAS onmousedown=\"ShowToolTip(event,'" + casURL + "','" + Global.IntranetSiteURL + "SalesAnalysisReport/" + url + "',this.id);\">" + e.Item.Cells[0].Text + "</div>";
            hplButton.NavigateUrl = url;
            hplButton.Attributes.Add("onclick", "window.open(this.href, 'popupwindow', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO'); return false;");
            e.Item.Cells[0].Controls.Add(hplButton);
            e.Item.Cells[0].CssClass = "GridItemLink";

            casURL = Global.IntranetSiteURL + "CustomerActivitySheet/FrameSet/CASFrameSet.aspx?Month=" + Request.QueryString["Month"].Trim() + "&Year=" + Request.QueryString["Year"].Trim() + "&Branch=" + e.Item.Cells[3].Text + "&Chain=" + e.Item.Cells[4].Text.Replace("&", "||") + "&CustNo=" + e.Item.Cells[0].Text + "&MonthName=" + Request.QueryString["MonthName"].Trim() + "&BranchName=" + Request.QueryString["BranchName"].Trim() + "&SalesRep=" + strSalesRep + "&CASMode=Chain";
            // Code to display progress bar on page load
            url = "ItemSalesAnalysis.aspx?CustNo=~Chain=" + e.Item.Cells[4].Text.Replace('&', '`') + "~MonthName=" + Request.QueryString["MonthName"] + "~Month=" + Request.QueryString["Month"] + "~Year=" + Request.QueryString["Year"] + "~Branch=" + e.Item.Cells[3].Text + "~BranchName=" + e.Item.Cells[3].Text + "~SalesRep=" + strSalesRep.Replace("'", "|") + "~ZipFrom=" + strZipFrom + "~ZipTo=" + strZipTo + "~Version=" + hidVersion.Value + "~Format=" + hidReport.Value + "~OrdType=" + Request.QueryString["OrdType"];
            url = "ProgressBar.aspx?destPage=" + url;
            HyperLink hplButton1 = new HyperLink();
            hplButton1.Text = "<div oncontextmenu=\"Javascript:return false;\" id=div" + e.Item.ItemIndex + "Report onmousedown=\"ShowToolTip(event,'" + casURL + "','" + Global.IntranetSiteURL + "SalesAnalysisReport/" + url + "',this.id);\">" + e.Item.Cells[4].Text + "</div>";
            hplButton1.NavigateUrl = url;
            hplButton1.Attributes.Add("onclick", "ItemSales=window.open(this.href, 'ItemSales', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO'); return false;");
            e.Item.Cells[4].Controls.Add(hplButton1);
            e.Item.Cells[4].CssClass = "GridItemLink";
        }
        else if (e.Item.ItemType == ListItemType.Footer && Session["GrandTotal"] != null)
        {

            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[0].CssClass = "GridHead";

            DataTable dtGrandTotal = Session["GrandTotal"] as DataTable;
            Total = dtGrandTotal.Rows[0];
            decimal dmlGrandTotal;
            for (int i = 1; i <= 32; i++)
            {
                dmlGrandTotal = 0;
                if (i == 0 || (i > 4 && i < 31))
                {
                    if (i != 21 && i != 26)
                    {
                        dmlGrandTotal = Convert.ToDecimal(((Total[i].ToString() != "") ? Total[i] : 0));
                        e.Item.Cells[i].Text = (i == 8 || i == 10 || i == 18 || i == 12 || i == 14 || i == 23 || i == 28 || i == 30) ?
                            dmlGrandTotal.ToString() : ((dmlGrandTotal.ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(dmlGrandTotal)) : "0");
                    }
                }

                e.Item.Cells[i].HorizontalAlign = HorizontalAlign.Right;
                e.Item.Cells[i].CssClass = "GridHead";
            }

        }

        e.Item.Cells[0].CssClass = "locked";
        e.Item.Cells[1].CssClass = "locked";

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
        ChangeVersion();
        DetVersion();
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
        ExcelExport();
        ChangeVersion();
        DetVersion();
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

    protected void ExcelExport()
    {
        try
        {
            string strYearNew = ((Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) ? Request.QueryString["Year"].ToString().Trim() :
                  Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString().Trim()) + 1));

            string strYearDis = "'" + strYearNew.Substring(2);
            string strPreYearDis = "'" + (Convert.ToInt16(strYearNew) - 1).ToString().Substring(2);


            FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + ViewState["ExcelFileName"].ToString()));


            StreamWriter reportWriter;
            reportWriter = fnExcel.CreateText();

            reportWriter.WriteLine("<table border=2px cellpadding=5 cellspacing=5>");
            if (rdoDate2.Checked == true && rdoReportVersion1.Checked == true)
            {

                reportWriter.WriteLine("<tr><td colspan=38  align=center valign=middle><font color=blue size=15px><b>Customer Sales Analysis Report</b></font></td></tr>");
                reportWriter.WriteLine("<tr><td colspan=38></td></tr>");

                reportWriter.WriteLine("<tr align=right><th align=left bgcolor=whitesmoke>Period :</th>" +
                                        "<th>" + Request.QueryString["MonthName"].ToString() + "</th>" +
                                        "<th>" + Request.QueryString["Year"].ToString() + "</th>" +
                                        "<th>Order Type : </th>" +
                                        "<th>" + ((Request.QueryString["OrdType"] != "Non-Mill") ? Request.QueryString["OrdType"].ToString().Trim() : "Warehouse") + "</th>" +
                                        "<th>Branch : </th>" +
                                        "<th>" + Request.QueryString["BranchName"].ToString() + "</th>" +
                                        "<th> Chain : </th>" + ((Request.QueryString["Chain"] != "") ? "<th colspan=2>" + Request.QueryString["Chain"].ToString().Trim() + "</th>" : "<th>All </th>") +
                                        "<th>Customer :</th>" + ((Request.QueryString["CustNo"] != "") ? "<th colspan=2>" + Request.QueryString["CustNo"].ToString().Trim() + "\t" : "<th>All </th>") +
                                        "<th>Fiscal Year :</th>" + "<th colspan=3>" + Request.QueryString["Year"].ToString() + "Vs" +
                                        Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString()) - 1) + "</th>" +
                                        "<th>Sales Rep :</th>" + "<th>" + Request.QueryString["SalesRep"].ToString().Replace("|", "'") + "</th>" +
                                        "<th>Zip :</th>" + "<th>" + ((Request.QueryString["ZipFrom"] == "" && Request.QueryString["ZipTo"] == "") ? "All" : Request.QueryString["ZipFrom"].ToString() + " - " + Request.QueryString["ZipTo"].ToString()) + "</th>" +
                                        "<th>Run By :</th>" +
                                        "<th>" + Session["UserName"].ToString() + "</th>" +
                                        " <th>Run Date :</th><th colspan=3>" + DateTime.Now.Month.ToString() +
                                        "/" + DateTime.Now.Day.ToString() + "/" + DateTime.Now.Year + "</th></tr>");


                reportWriter.WriteLine("<tr><td colspan=38></td></tr>");
                reportWriter.WriteLine("<th>Cust #</th><th>Name</th><th>City</th><th>Brn</th><th>Chain</th>" +
                                         "<th>" + strYearDis + " Sales $" + "</th>" +
                                         "<th>" + strPreYearDis + " Sales $" + "</th>" +
                                         "<th>" + strYearDis + " GM$" + "</th>" +
                                         "<th>" + strYearDis + " GM%" + "</th>" +
                                         "<th>" + strPreYearDis + " GM$" + "</th>" +
                                         "<th>" + strPreYearDis + " GM%" + "</th>" +
                                         "<th>" + strYearDis + " Wgt" + "</th>" +
                                         "<th>" + strYearDis + " $/Lb" + "</th>" +
                                         "<th>" + strPreYearDis + " Wgt" + "</th>" +
                                         "<th>" + strPreYearDis + " $/Lb" + "</th>" +
                                         "<th>YTD " + strYearDis + " Sales $" + "</th>" +
                                         "<th>YTD " + strPreYearDis + " Sales $" + "</th>" +
                                         "<th>YTD " + strYearDis + " GM$" + "</th>" +
                                         "<th>YTD " + strYearDis + " GM%" + "</th>" +
                                         "<th>YTD " + strYearDis + " Exp$" + "</th>" +
                                         "<th>YTD " + strYearDis + " NP$" + "</th>" +
                                         "<th>Accum " + strYearDis + " NP$" + "</th>" +
                                         "<th>YTD " + strPreYearDis + " GM$" + "</th>" +
                                         "<th>YTD " + strPreYearDis + " GM%" + "</th>" +
                                         "<th>YTD " + strPreYearDis + " Exp$" + "</th>" +
                                         "<th>YTD " + strPreYearDis + " NP$" + "</th>" +
                                         "<th>Accum " + strPreYearDis + " NP$" + "</th>" +
                                         "<th>YTD " + strYearDis + " Wgt" + "</th>" +
                                         "<th>YTD " + strYearDis + " $/Lb" + "</th>" +
                                         "<th>YTD " + strPreYearDis + " Wgt" + "</th>" +
                                         "<th>YTD " + strPreYearDis + " $/Lb" + "</th>" +
                                         "<th>Rep</th>" +
                                         "<th align=left>Group</th>" +
                                         "<th align=left>Zip</th>" +
                                         "<th>PFC Rep</th>" +
                                         "<th>ABC</th>" +
                                         "<th>YTD Budget$</th>" +
                                         "<th>Ind Type</th>");

                DataTable dtTemp = (DataTable)Session["CustomerSale"];
                dtTemp.DefaultView.Sort = hidSort.Value;
                DataTable dt1 = dtTemp.DefaultView.ToTable();

                for (int j = 0; j < dt1.Rows.Count; j++)
                {
                    string lineContent = string.Empty;
                    for (int i = 0; i <= 37; i++)
                    {
                        lineContent +=
                         (i == 4) ?
                         "<td align=left>" + dt1.Rows[j][i].ToString() + "</td>" :
                         (i < 3 || i == 8 || i == 10 || i == 18 || i == 12 || i == 14 || i == 23 || i == 28 || i == 30 || i == 31 || i == 32 || i == 33 || i == 34 || i == 35 || i == 37) ?
                          "<td>" + dt1.Rows[j][i].ToString() + "</td>" :
                         "<td>" + ((dt1.Rows[j][i].ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(((dt1.Rows[j][i].ToString() != "") ? dt1.Rows[j][i] : 0))) : "0") + "</td>";

                    }
                    reportWriter.WriteLine("<tr>" + lineContent.ToString() + "</tr>");
                }

                string lineFooter = string.Empty;

                DataTable dtFooter = Session["GrandTotal"] as DataTable;
                Total = dtFooter.Rows[0];
                lineFooter = "<th  align=right>Grand Total</th>";

                for (int i = 1; i <= 36; i++)
                {

                    lineFooter += (i <= 4 || i == 8 || i == 10 || i == 18 || i == 12 || i == 14 || i == 23 || i == 28 || i == 30 || i == 31 || i == 32 || i == 33 || i == 34 || i == 35 || i == 37) ?
                            "<th align=right>" + Total[i].ToString() + "</th>" :
                                        "<th  align=right>" + ((Total[i].ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(((Total[i].ToString() != "") ? Total[i] : 0))) : "0") + "</th>";
                }
                reportWriter.WriteLine("<tr>" + lineFooter.ToString() + "</tr>");
            }



            if (rdoDate2.Checked == true && rdoReportVersion2.Checked == true)
            {

                reportWriter.WriteLine("<tr><td colspan=30  align=center valign=middle><font color=blue size=15px><b>Customer Sales Analysis Report</b></font></td></tr>");
                reportWriter.WriteLine("<tr><td colspan=30></td></tr>");

                reportWriter.WriteLine("<tr align=right><th align=left bgcolor=whitesmoke>Period :</th>" +
                                        "<th>" + Request.QueryString["MonthName"].ToString() + "</th>" +
                                        "<th>" + Request.QueryString["Year"].ToString() + "</th>" +
                                        "<th>Order Type : </th>" +
                                        "<th>" + ((Request.QueryString["OrdType"] != "Non-Mill") ? Request.QueryString["OrdType"].ToString().Trim() : "Warehouse") + "</th>" +
                                        "<th>Branch : </th>" +
                                        "<th>" + Request.QueryString["BranchName"].ToString() + "</th>" +
                                        "<th> Chain : </th>" + ((Request.QueryString["Chain"] != "") ? "<th colspan=1>" + Request.QueryString["Chain"].ToString().Trim() + "</th>" : "<th>All </th>") +
                                        "<th>Customer :</th>" + ((Request.QueryString["CustNo"] != "") ? "<th colspan=2>" + Request.QueryString["CustNo"].ToString().Trim() + "\t" : "<th>All </th>") +
                                        "<th>Fiscal Year :</th>" + "<th colspan=1>" + Request.QueryString["Year"].ToString() + "Vs" +
                                        Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString()) - 1) + "</th>" +
                                        "<th>Sales Rep :</th>" + "<th>" + Request.QueryString["SalesRep"].ToString().Replace("|", "'") + "</th>" +
                                        "<th>Zip :</th>" + "<th>" + ((Request.QueryString["ZipFrom"] == "" && Request.QueryString["ZipTo"] == "") ? "All" : Request.QueryString["ZipFrom"].ToString() + " - " + Request.QueryString["ZipTo"].ToString()) + "</th>" +
                                        "<th>Run By :</th>" +
                                        "<th>" + Session["UserName"].ToString() + "</th>" +
                                        " <th>Run Date :</th><th colspan=1>" + DateTime.Now.Month.ToString() +
                                        "/" + DateTime.Now.Day.ToString() + "/" + DateTime.Now.Year + "</th></tr>");

                reportWriter.WriteLine("<tr><td colspan=30></td></tr>");
                reportWriter.WriteLine("<th>Cust #</th><th>Name</th><th>City</th><th>Brn</th><th>Chain</th>" +
                                         "<th>" + strYearDis + " Sales $" + "</th>" +
                                         "<th>" + strPreYearDis + " Sales $" + "</th>" +
                                         "<th>" + strYearDis + " GM%" + "</th>" +
                                         "<th>" + strPreYearDis + " GM%" + "</th>" +
                                         "<th>" + strYearDis + " $/Lb" + "</th>" +
                                         "<th>" + strPreYearDis + " $/Lb" + "</th>" +
                                         "<th>YTD " + strYearDis + " Sales $" + "</th>" +
                                         "<th>YTD " + strPreYearDis + " Sales $" + "</th>" +
                                         "<th>YTD " + strYearDis + " GM%" + "</th>" +
                                          "<th>YTD " + strYearDis + " Exp$" + "</th>" +
                                         "<th>YTD " + strYearDis + " NP$" + "</th>" +
                                         "<th>Accum " + strYearDis + " NP$" + "</th>" +
                                         "<th>YTD " + strPreYearDis + " GM%" + "</th>" +
                                         "<th>YTD " + strPreYearDis + " Exp$" + "</th>" +
                                         "<th>YTD " + strPreYearDis + " NP$" + "</th>" +
                                         "<th>Accum " + strPreYearDis + " NP$" + "</th>" +
                                         "<th>YTD " + strYearDis + " $/Lb" + "</th>" +
                                         "<th>YTD " + strPreYearDis + " $/Lb" + "</th>" +
                                         "<th>Rep</th>" +
                                         "<th align=left>Group</th>" +
                                          "<th align=left>Zip</th>" +
                                         "<th>PFC Rep</th>" +
                                         "<th>ABC</th>" +
                                         "<th>YTD Budget$</th>" +
                                         "<th>Ind Type</th>");

                DataTable dtTemp = (DataTable)Session["CustomerSale"];
                dtTemp.DefaultView.Sort = hidSort.Value;
                DataTable dt1 = dtTemp.DefaultView.ToTable();

                for (int j = 0; j < dt1.Rows.Count; j++)
                {
                    string lineContent = string.Empty;
                    for (int i = 0; i <= 37; i++)
                    {
                        if (i < 4)
                            lineContent += "<td align=left>" + dt1.Rows[j][i].ToString() + "</td>";
                        if (i > 3 && i != 7 && i != 9 && i != 11 && i != 13 && i != 17 && i != 22 && i != 27 && i != 29)
                            lineContent +=
                         (i == 4) ?
                         "<td align=left>" + dt1.Rows[j][i].ToString() + "</td>" :
                         (i < 3 || i == 8 || i == 10 || i == 18 || i == 12 || i == 14 || i == 19 || i == 20 || i == 21 || i == 23 || i == 24 || i == 25 || i == 26 || i == 28 || i == 30 || i == 31 || i == 32 || i == 33 || i == 34 || i == 35 || i==37) ?
                          "<td>" + dt1.Rows[j][i].ToString() + "</td>" :
                         "<td>" + ((dt1.Rows[j][i].ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(((dt1.Rows[j][i].ToString() != "") ? dt1.Rows[j][i] : 0))) : "0") + "</td>";
                        //lineContent += "<td>" + dt1.Rows[j][i].ToString() + "</td>";


                    }
                    reportWriter.WriteLine("<tr>" + lineContent.ToString() + "</tr>");
                }
                string lineFooter = string.Empty;
                lineFooter = "<th align=right>Grand Total</th>";

                DataTable dtFooter = Session["GrandTotal"] as DataTable;
                Total = dtFooter.Rows[0];
                for (int i = 1; i <= 33; i++)
                {
                    if (i > 1 && i <= 4)
                        lineFooter += "<th align=right></th>";
                    if (i > 3 && i != 7 && i != 9 && i != 11 && i != 13 && i != 17 && i != 19 && i != 20 && i != 21 && i != 22 && i != 24 && i != 25 && i != 26 && i != 27 && i != 29)
                        lineFooter += (i <= 4 || i == 8 || i == 10 || i == 18 || i == 12 || i == 14 || i == 23 || i == 28 || i == 30 || i == 31 || i == 32 || i == 33 || i == 34 || i == 35|| i == 35) ?
                            "<th align=right>" + Total[i].ToString() + "</th>" :
                                        "<th  align=right>" + ((Total[i].ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(((Total[i].ToString() != "") ? Total[i] : 0))) : "0") + "</th>";


                }
                reportWriter.WriteLine("<tr>" + lineFooter.ToString() + "</tr>");
            }


            if (rdoDate1.Checked == true && rdoReportVersion1.Checked == true)
            {
                reportWriter.WriteLine("<tr><td colspan=22  align=center valign=middle><font color=blue size=15px><b>Customer Sales Analysis Report</b></font></td></tr>");
                reportWriter.WriteLine("<tr><td colspan=22></td></tr>");

                reportWriter.WriteLine("<tr align=right><th align=left bgcolor=whitesmoke>Period :</th>" +
                                        "<th>" + Request.QueryString["MonthName"].ToString() + "</th>" +
                                        "<th>" + Request.QueryString["Year"].ToString() + "</th>" +
                                        "<th>Order Type : </th>" +
                                        "<th>" + ((Request.QueryString["OrdType"] != "Non-Mill") ? Request.QueryString["OrdType"].ToString().Trim() : "Warehouse") + "</th>" +
                                        "<th>Branch : </th>" +
                                        "<th>" + Request.QueryString["BranchName"].ToString() + "</th>" +
                                        "<th> Chain : " + ((Request.QueryString["Chain"] != "") ? Request.QueryString["Chain"].ToString().Trim() : "All") + "</th>" +
                                        "<th>Customer :</th>" + ((Request.QueryString["CustNo"] != "") ? "<th colspan=1>" + Request.QueryString["CustNo"].ToString().Trim() + "\t" : "<th>All </th>") +
                                        "<th>Fiscal Year :</th>" + "<th colspan=1>" + Request.QueryString["Year"].ToString() + "Vs" +
                                        Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString()) - 1) + "</th>" +
                                        "<th>Sales Rep :</th>" + "<th>" + Request.QueryString["SalesRep"].ToString().Replace("|", "'") + "</th>" +
                                        "<th>Zip :</th>" + "<th>" + ((Request.QueryString["ZipFrom"] == "" && Request.QueryString["ZipTo"] == "") ? "All" : Request.QueryString["ZipFrom"].ToString() + " - " + Request.QueryString["ZipTo"].ToString()) + "</th>" +
                                        "<th>Run By :</th>" +
                                        "<th>" + Session["UserName"].ToString() + "</th>" +
                                        " <th>Run Date :</th><th colspan=1>" + DateTime.Now.Month.ToString() +
                                        "/" + DateTime.Now.Day.ToString() + "/" + DateTime.Now.Year + "</th></tr>");

                reportWriter.WriteLine("<tr><td colspan=22></td></tr>");
                reportWriter.WriteLine("<th>Cust #</th><th>Name</th><th>City</th><th>Brn</th><th>Chain</th>" +
                                         "<th>" + strYearDis + " Sales $" + "</th>" +
                                         "<th>" + strPreYearDis + " Sales $" + "</th>" +
                                         "<th>" + strYearDis + " GM$" + "</th>" +
                                         "<th>" + strYearDis + " GM%" + "</th>" +
                                         "<th>" + strPreYearDis + " GM$" + "</th>" +
                                         "<th>" + strPreYearDis + " GM%" + "</th>" +
                                         "<th>" + strYearDis + " Wgt" + "</th>" +
                                         "<th>" + strYearDis + " $/Lb" + "</th>" +
                                         "<th>" + strPreYearDis + " Wgt" + "</th>" +
                                         "<th>" + strPreYearDis + " $/Lb" + "</th>" +
                                         "<th>Rep</th>" +
                                         "<th align=left>Group</th>" +
                                         "<th width=60px>Zip</th>" +
                                         "<th>PFC Rep</th>" +
                                         "<th>ABC</th>" +
                                         "<th>YTD Budget$</th>" +
                                         "<th>Ind Type</th>");

                DataTable dtTemp = (DataTable)Session["CustomerSale"];
                dtTemp.DefaultView.Sort = hidSort.Value;
                DataTable dt1 = dtTemp.DefaultView.ToTable();

                for (int j = 0; j < dt1.Rows.Count; j++)
                {
                    string lineContent = string.Empty;
                    for (int i = 0; i <= 37; i++)
                    {
                        if (i < 4)
                            lineContent += "<td align=left>" + dt1.Rows[j][i].ToString() + "</td>";
                        if (i > 3 && i != 15 && i != 16 && i != 17 && i != 18 && i != 19 && i != 20 && i != 21 && i != 22 && i != 23 && i != 24 && i != 25 && i != 26 && i != 27 && i != 28 && i != 29 && i != 30)
                            lineContent += (i == 4) ? "<td align=left>" + dt1.Rows[j][i].ToString() + "</td>" : (i < 3 || i == 8 || i == 10 || i == 18 || i == 12 || i == 14 || i == 23 || i == 28 || i == 30 || i == 31 || i == 32 || i == 33 || i == 34 || i == 35 || i == 37) ?
                          "<td>" + dt1.Rows[j][i].ToString() + "</td>" :
                         "<td>" + ((dt1.Rows[j][i].ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(((dt1.Rows[j][i].ToString() != "") ? dt1.Rows[j][i] : 0))) : "0") + "</td>";

                    }
                    reportWriter.WriteLine("<tr>" + lineContent.ToString() + "</tr>");
                }

                string lineFooter = string.Empty;
                lineFooter = "<th  align=right>Grand Total</th>";


                DataTable dtFooter = Session["GrandTotal"] as DataTable;
                Total = dtFooter.Rows[0];

                for (int i = 1; i <= 36; i++)
                {
                    if (i > 1 && i <= 4)
                        lineFooter += "<th align=right></th>";
                    if (i > 3 && i != 15 && i != 16 && i != 17 && i != 18 && i != 19 && i != 20 && i != 21 && i != 22 && i != 23 && i != 24 && i != 25 && i != 26 && i != 27 && i != 28 && i != 29 && i != 30 )
                        lineFooter += (i <= 4 || i == 8 || i == 10 || i == 18 || i == 12 || i == 14 || i == 19 || i == 20 || i == 21 || i == 23 || i == 24 || i == 25 || i == 26 || i == 28 || i == 30 || i == 31 || i == 32 || i == 33 || i == 34 || i == 35 || i == 37) ?
                            "<th align=right>" + Total[i].ToString() + "</th>" :
                                       "<th  align=right>" + ((Total[i].ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(((Total[i].ToString() != "") ? Total[i] : 0))) : "0") + "</th>";
                }
                reportWriter.WriteLine("<tr>" + lineFooter.ToString() + "</tr>");
            }


            if (rdoDate1.Checked == true && rdoReportVersion2.Checked == true)
            {
                reportWriter.WriteLine("<tr><td colspan=18  align=center valign=middle><font color=blue size=15px><b>Customer Sales Analysis Report</b></font></td></tr>");
                reportWriter.WriteLine("<tr><td colspan=18></td></tr>");

                reportWriter.WriteLine("<tr align=right>" +
                                        "<th align=left>Period :</th>" +
                                        "<th>" + Request.QueryString["MonthName"].ToString() + "</th>" +
                                        "<th>" + Request.QueryString["Year"].ToString() + "</th>" +
                                        "<th>Order Type : </th>" +
                                        "<th>" + ((Request.QueryString["OrdType"] != "Non-Mill") ? Request.QueryString["OrdType"].ToString().Trim() : "Warehouse") + "</th>" +
                                        "<th>Branch : </th>" +
                                        "<th>" + Request.QueryString["BranchName"].ToString() + "</th>" +
                                        "<th> Chain :" + ((Request.QueryString["Chain"] != "") ? Request.QueryString["Chain"].ToString().Trim() : "All") + "</th>" +
                                        "<th>Customer :" + ((Request.QueryString["CustNo"] != "") ? Request.QueryString["CustNo"].ToString().Trim() : "All") + " </th>" +
                                        "<th>Fiscal Year :</th>" +
                                        "<th colspan=1>" + Request.QueryString["Year"].ToString() + "Vs" +
                                        Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString()) - 1) + "</th>" +
                                        "<th>Sales Rep :" + Request.QueryString["SalesRep"].ToString().Replace("|", "'") + "</th>" +
                                        "<th>Zip :" + ((Request.QueryString["ZipFrom"] == "" && Request.QueryString["ZipTo"] == "") ? "All" : Request.QueryString["ZipFrom"].ToString() + " - " + Request.QueryString["ZipTo"].ToString()) + "</th>" +
                                        "<th>Run By :</th>" +
                                        "<th>" + Session["UserName"].ToString() + "</th>" +
                                        " <th>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>");


                reportWriter.WriteLine("<tr><td colspan=18></td></tr>");
                reportWriter.WriteLine("<th>Cust #</th><th>Name</th><th>City</th><th>Brn</th><th>Chain</th>" +
                                         "<th>" + strYearDis + " Sales $" + "</th>" +
                                         "<th>" + strPreYearDis + " Sales $" + "</th>" +
                                         "<th>" + strYearDis + " GM%" + "</th>" +
                                         "<th>" + strPreYearDis + " GM%" + "</th>" +
                                         "<th>" + strYearDis + " $/Lb" + "</th>" +
                                         "<th>" + strPreYearDis + " $/Lb" + "</th>" +
                                         "<th>Rep</th>" +
                                         "<th align=left>Group</th>" +
                                         "<th width=60px>Zip</th>" +
                                         "<th>PFC Rep</th>" +
                                         "<th>ABC</th>" +
                                          "<th>YTD Budget$</th>" +
                                         "<th>Ind Type</th>");

                DataTable dtTemp = (DataTable)Session["CustomerSale"];
                dtTemp.DefaultView.Sort = hidSort.Value;
                DataTable dt1 = dtTemp.DefaultView.ToTable();


                for (int j = 0; j < dt1.Rows.Count; j++)
                {
                    string lineContent = string.Empty;
                    for (int i = 0; i <= 37; i++)
                    {
                        if (i < 4)
                            lineContent += "<td align=left>" + dt1.Rows[j][i].ToString() + "</td>";
                        if (i > 3 && i != 15 && i != 16 && i != 17 && i != 18 && i != 19 && i != 20 && i != 21 && i != 22 && i != 23 && i != 24 && i != 25 && i != 26 && i != 27 && i != 28 && i != 29 && i != 30 && i != 7 && i != 9 && i != 11 && i != 13)
                            lineContent += (i == 4) ? "<td align=left>" + dt1.Rows[j][i].ToString() + "</td>" : (i < 3 || i == 8 || i == 10 || i == 18 || i == 12 || i == 14 || i == 26 || i == 28 || i == 30 || i == 31 || i == 32 || i == 33 || i == 34 || i == 35 || i == 37) ?
                          "<td>" + dt1.Rows[j][i].ToString() + "</td>" :
                         "<td>" + ((dt1.Rows[j][i].ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(((dt1.Rows[j][i].ToString() != "") ? dt1.Rows[j][i] : 0))) : "0") + "</td>";

                    }
                    reportWriter.WriteLine("<tr>" + lineContent.ToString() + "</tr>");
                }

                string lineFooter = string.Empty;
                lineFooter = "<th align=right>Grand Total</th>";

                DataTable dtFooter = Session["GrandTotal"] as DataTable;
                Total = dtFooter.Rows[0];

                for (int i = 1; i <= 36; i++)
                {
                    if (i > 1 && i <= 4)
                        lineFooter += "<th align=right></th>";
                    if (i > 3 && i != 15 && i != 16 && i != 17 && i != 18 && i != 19 && i != 20 && i != 21 && i != 22 && i != 23 && i != 24 && i != 25 && i != 26 && i != 27 && i != 28 && i != 29 && i != 30 && i != 7 && i != 9 && i != 11 && i != 13)
                        lineFooter += (i <= 4 || i == 8 || i == 10 || i == 18 || i == 12 || i == 14 || i == 23 || i == 28 || i == 30 || i == 31 || i == 32 || i == 33 || i == 34 || i == 35) ?
                            "<th align=right>" + Total[i].ToString() + "</th>" :
                                       "<th  align=right>" + ((Total[i].ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(((Total[i].ToString() != "") ? Total[i] : 0))) : "0") + "</th>";
                }
                reportWriter.WriteLine("<tr>" + lineFooter.ToString() + "</tr>");
            }


            reportWriter.WriteLine("</table>");

            reportWriter.Close();

        }
        catch (Exception ex) { Response.Write(ex.ToString()); }
    }

    protected void rdoReportVersion1_CheckedChanged(Object sender, System.EventArgs e)
    {
        hidReport.Value = ((rdoDate1.Checked) ? "mtd" : "ytd");

        hidVersion.Value = ((rdoReportVersion1.Checked) ? "long" : "short");
        ExcelExport();
        ChangeVersion();
        DetVersion();
    }

    protected void rdoReportVersion2_CheckedChanged(Object sender, System.EventArgs e)
    {
        hidReport.Value = ((rdoDate1.Checked) ? "mtd" : "ytd");

        hidVersion.Value = ((rdoReportVersion1.Checked) ? "long" : "short");
        ExcelExport();
        ChangeVersion();
        DetVersion();
    }

    public void DetVersion()
    {
        bool longVersionmtd = ((rdoReportVersion1.Checked && rdoDate1.Checked) || (rdoReportVersion1.Checked && rdoDate2.Checked)) ? true : false;

        dgAnalysis.Columns[7].Visible = longVersionmtd;
        dgAnalysis.Columns[9].Visible = longVersionmtd;
        dgAnalysis.Columns[11].Visible = longVersionmtd;
        dgAnalysis.Columns[13].Visible = longVersionmtd;

        bool longVersionYtd = (rdoReportVersion1.Checked) ? ((rdoDate2.Checked) ? true : false) : false;
        //dgAnalysis.Columns[17].Visible = longVersionYtd;
        //dgAnalysis.Columns[19].Visible = longVersionYtd;
        //dgAnalysis.Columns[20].Visible = longVersionYtd;
        //dgAnalysis.Columns[21].Visible = longVersionYtd;
        //dgAnalysis.Columns[22].Visible = longVersionYtd;
        //dgAnalysis.Columns[24].Visible = longVersionYtd;
        //dgAnalysis.Columns[25].Visible = longVersionYtd;
        //dgAnalysis.Columns[26].Visible = longVersionYtd;
        //dgAnalysis.Columns[27].Visible = longVersionYtd;
        //dgAnalysis.Columns[29].Visible = longVersionYtd;
        dgAnalysis.Columns[17].Visible = longVersionYtd;
        dgAnalysis.Columns[22].Visible = longVersionYtd;
        dgAnalysis.Columns[27].Visible = longVersionYtd;
        dgAnalysis.Columns[29].Visible = longVersionYtd;

        dgAnalysis.Width = (rdoReportVersion1.Checked && rdoDate2.Checked)
                                   ? 2500 :
                                   ((rdoReportVersion2.Checked && rdoDate2.Checked) ? 1600 : 1100);

        BindDataToGrid();
    }

    protected void rdoDate1_CheckedChanged(object sender, EventArgs e)
    {
        // Move the Report Fomat to hidden Field to display subreport in YTD or MTD format
        hidReport.Value = ((rdoDate1.Checked) ? "mtd" : "ytd");

        hidVersion.Value = ((rdoReportVersion1.Checked) ? "long" : "short");
        ExcelExport();
        ChangeVersion();
        DetVersion();

    }

    protected void rdoDate2_CheckedChanged(object sender, EventArgs e)
    {
        // Move the Report Fomatto hidden Field to display subreport in YTD or MTD format
        hidReport.Value = ((rdoDate1.Checked) ? "mtd" : "ytd");

        hidVersion.Value = ((rdoReportVersion1.Checked) ? "long" : "short");
        ExcelExport();
        ChangeVersion();
        DetVersion();

    }

    // Function To show the datagrid columns according to the version selected
    public void ChangeVersion()
    {
        bool ytdVisible = ((rdoDate2.Checked) ? true : false);
        dgAnalysis.Columns[15].Visible = ytdVisible;
        dgAnalysis.Columns[16].Visible = ytdVisible;
        dgAnalysis.Columns[18].Visible = ytdVisible;
        dgAnalysis.Columns[23].Visible = ytdVisible;
        dgAnalysis.Columns[28].Visible = ytdVisible;
        dgAnalysis.Columns[30].Visible = ytdVisible;
        dgAnalysis.Columns[19].Visible = ytdVisible;
        dgAnalysis.Columns[20].Visible = ytdVisible;
        dgAnalysis.Columns[21].Visible = ytdVisible;
        dgAnalysis.Columns[24].Visible = ytdVisible;
        dgAnalysis.Columns[25].Visible = ytdVisible;
        dgAnalysis.Columns[26].Visible = ytdVisible;
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
