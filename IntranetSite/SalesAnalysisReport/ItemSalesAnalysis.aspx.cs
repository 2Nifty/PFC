
/********************************************************************************************
 * File	Name			:	ItemSalesAnalysis.aspx.cs
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
using PFC.Intranet;
using PFC.Intranet.Utility;
using System.Reflection;


public partial class ItemSalesAnalysis : System.Web.UI.Page
{
    SqlConnection cn = new SqlConnection(PFC.Intranet.Global.ReportsConnectionString);
    Utility utility = new Utility();

    System.Data.DataTable dt = new System.Data.DataTable();
    DataSet dsItemInfo = new DataSet();

    string strMonth = string.Empty;
    string strYear = string.Empty;
    string strBranch = string.Empty;
    string strChain = string.Empty;
    string strCustNo = string.Empty;
    string strMonthName = string.Empty;
    string strPeriodType = string.Empty;
    string strRdoVersion = string.Empty;
    string strRdoPeriod = string.Empty;
    string strFormat = string.Empty;
    string strVersion = string.Empty;
    string strSalesRep = string.Empty;
    string strZipFrom = string.Empty;
    string strZipTo = string.Empty;
    string strOrdType = string.Empty;
    int pageSize = 16;
    DataRow Total;

    protected void Page_Load(object sender, EventArgs e)
    {
        utility.CheckBrowserCompatibility(Request,dgAnalysis,ref pageSize);
        #region Get QueryString Values

        strMonth = (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "";
        strYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";
        strBranch = (Request.QueryString["Branch"] != null) ? Request.QueryString["Branch"].ToString().Trim() : "";
        strChain = (Request.QueryString["Chain"] != null) ? Request.QueryString["Chain"].ToString().Trim().Replace('`', '&') : "";
        strCustNo = (Request.QueryString["CustNo"] != null) ? Request.QueryString["CustNo"].ToString().Trim() : "";
        strMonthName = (Request.QueryString["MonthName"] != null) ? Request.QueryString["MonthName"].ToString().Trim() : "";
        strFormat = (Request.QueryString["Format"] != null) ? Request.QueryString["Format"].ToString().Trim() : "";
        strVersion = (Request.QueryString["Version"] != null) ? Request.QueryString["Version"].ToString().Trim() : "";
        strSalesRep = (Request.QueryString["SalesRep"] != null) ? ((Request.QueryString["SalesRep"].ToString().Trim() != "All") ? Request.QueryString["SalesRep"].ToString().Trim().Replace("|", "'") : "") : "";
        strZipFrom = (Request.QueryString["ZipFrom"] != null) ? ((Request.QueryString["ZipFrom"].ToString().Trim() != "All") ? Request.QueryString["ZipFrom"].ToString().Trim() : "") : "";
        strZipTo = (Request.QueryString["ZipTo"] != null) ? ((Request.QueryString["ZipTo"].ToString().Trim() != "All") ? Request.QueryString["ZipTo"].ToString().Trim() : "") : "";
        strOrdType = (Request.QueryString["OrdType"] != null) ? Request.QueryString["OrdType"].ToString().Trim() : "";

        #endregion

        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(ItemSalesAnalysis));

        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");
        ViewState["ExcelFileName"] = "ItemSalesAnalysis" + Session["SessionID"].ToString() + name + ".xls";

        GetVersionPeriod();
        if (!IsPostBack)
        {
            ItemDataDisplay();
        }

        DataTable dtFooter = Session["ItemSalesGrandTotal"] as DataTable;
        Total = dtFooter.Rows[0];
    }

    public void GetVersionPeriod()
    {
        strRdoPeriod = strFormat;
        strRdoVersion = strVersion;
    }

    public void ItemDataDisplay()
    {
        GetItemData();
        ExcelExport();
        ChangeColumns();
    }

    public void BindDataGridHeader()
    {
        string strYearNew = ((Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) ? Request.QueryString["Year"].ToString().Trim() :
                   Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString().Trim()) + 1));

        string strYearDis = "'" + strYearNew.Substring(2);
        string strPreYearDis = "'" + (Convert.ToInt16(strYearNew) - 1).ToString().Substring(2);


        dgAnalysis.Columns[0].HeaderText = "Item";
        dgAnalysis.Columns[1].HeaderText = "Item Desc";
        dgAnalysis.Columns[2].HeaderText = "UOM";
        dgAnalysis.Columns[3].HeaderText = strYearDis + " Qty";
        dgAnalysis.Columns[4].HeaderText = strYearDis + " Sales $";
        dgAnalysis.Columns[5].HeaderText = strYearDis + " GM $";
        dgAnalysis.Columns[6].HeaderText = strYearDis + " GM %";
        dgAnalysis.Columns[7].HeaderText = strYearDis + " SellWgt";
        dgAnalysis.Columns[8].HeaderText = strYearDis + " $/Lb";
        dgAnalysis.Columns[9].HeaderText = strYearDis + " Ord";

        dgAnalysis.Columns[10].HeaderText = "YTD " + strYearDis + " Qty";
        dgAnalysis.Columns[11].HeaderText = "YTD " + strPreYearDis + " Qty";
        dgAnalysis.Columns[12].HeaderText = "YTD " + strYearDis + " Sales $";
        dgAnalysis.Columns[13].HeaderText = "YTD " + strPreYearDis + " Sales $";
        dgAnalysis.Columns[14].HeaderText = "YTD " + strYearDis + " GM$";
        dgAnalysis.Columns[15].HeaderText = "YTD " + strPreYearDis + " GM$";
        dgAnalysis.Columns[16].HeaderText = "YTD " + strYearDis + " GM%";
        dgAnalysis.Columns[17].HeaderText = "YTD " + strPreYearDis + " GM%";
        dgAnalysis.Columns[18].HeaderText = "YTD " + strYearDis + " SellWgt";
        dgAnalysis.Columns[19].HeaderText = "YTD " + strPreYearDis + " SellWgt";
        dgAnalysis.Columns[20].HeaderText = "YTD " + strYearDis + " $/Lb";
        dgAnalysis.Columns[21].HeaderText = "YTD " + strPreYearDis + " $/Lb";
        dgAnalysis.Columns[22].HeaderText = "YTD " + strYearDis + " Ord";
        dgAnalysis.Columns[23].HeaderText = "YTD " + strPreYearDis + " Ord";

        dgAnalysis.Columns[0].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[1].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[2].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
    }

    public void GetItemData()
    {
        try
        {
            SqlConnection conn = new SqlConnection(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString());
            SqlDataAdapter adp;
            SqlCommand Cmd = new SqlCommand();

            if (strChain.ToString().Trim() != "")
            {
                //dsItemInfo = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[PFC_RPT_SP_ChainItemSalesAnalysis]",
                //            new SqlParameter("@PeriodMonth", strMonth),
                //            new SqlParameter("@PeriodYear", strYear),
                //            new SqlParameter("@OrderType", strOrdType),
                //            new SqlParameter("@Branch", strBranch),
                //            new SqlParameter("@Chain", strChain),
                //            new SqlParameter("@CustRep", strSalesRep.Replace("'", "''")),
                //            new SqlParameter("@ZipFrom", string.Empty),
                //            new SqlParameter("@ZipTo", string.Empty),
                //            new SqlParameter("@Option", strFormat.Trim().ToUpper()));

                string strSPName = "[PFC_RPT_SP_ChainItemSalesAnalysis]";
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = strSPName;

                Cmd.Parameters.Add(new SqlParameter("@PeriodMonth", strMonth));
                Cmd.Parameters.Add(new SqlParameter("@PeriodYear", strYear));
                Cmd.Parameters.Add(new SqlParameter("@OrderType", strOrdType));
                Cmd.Parameters.Add(new SqlParameter("@Branch", strBranch));
                Cmd.Parameters.Add(new SqlParameter("@Chain", strChain));
                Cmd.Parameters.Add(new SqlParameter("@CustRep", strSalesRep.Replace("'", "''")));
                Cmd.Parameters.Add(new SqlParameter("@ZipFrom", string.Empty));
                Cmd.Parameters.Add(new SqlParameter("@ZipTo", string.Empty));
                Cmd.Parameters.Add(new SqlParameter("@Option", strFormat.Trim().ToUpper()));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsItemInfo);
                conn.Close();

            }
            else
            {
                string strSPName = "[PFC_RPT_SP_CustomerItemSalesAnalysis]";
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = strSPName;

                Cmd.Parameters.Add(new SqlParameter("@PeriodMonth", strMonth));
                Cmd.Parameters.Add(new SqlParameter("@PeriodYear", strYear));
                Cmd.Parameters.Add(new SqlParameter("@OrdType", strOrdType));
                Cmd.Parameters.Add(new SqlParameter("@Branch", strBranch));
                Cmd.Parameters.Add(new SqlParameter("@CustNo", strCustNo));
                Cmd.Parameters.Add(new SqlParameter("@CustRep", strSalesRep.Replace("'", "''")));
                Cmd.Parameters.Add(new SqlParameter("@ZipFrom", string.Empty));
                Cmd.Parameters.Add(new SqlParameter("@ZipTo", string.Empty));
                Cmd.Parameters.Add(new SqlParameter("@Option", strFormat.Trim().ToUpper()));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsItemInfo);
                conn.Close();

            }
            dt.Clear();
            dt = dsItemInfo.Tables[0];

            if (dsItemInfo.Tables[1] != null)
            {
                Session["ItemSalesGrandTotal"] = dsItemInfo.Tables[1];
            }

            dt.DefaultView.Sort = "Item" + " " + "asc";
            Session["ItemSale"] = dt;
            ViewState["SortField"] = "Item";
            ViewState["SortMode"] = "asc";

        }
        catch (Exception ex) { Response.Write(ex.Message.ToString()); }
    }

    public string GetCustomerName()
    {
        try
        {
            if (cn.State.ToString() == "Open") cn.Close();
            cn.Open();
            SqlCommand cmd = new SqlCommand("select Top 1 [Name] from CuvnalTempCustomer where No_='" + Request.QueryString["CustNo"].ToString() + "'", cn);
            string strCustomer = cmd.ExecuteScalar().ToString();
            cmd.Dispose();
            cn.Close();
            return strCustomer.Replace("'", "|");
        }
        catch (Exception ex) { cn.Close(); return ""; }
    }

    public void BindDataToGrid()
    {
        try
        {
            BindDataGridHeader();
            dt = (DataTable)Session["ItemSale"];
            dt.DefaultView.Sort = hidSort.Value;
            Session["ItemSale"] = dt.DefaultView.ToTable();
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

    protected void dgAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            string url = string.Empty;
            // Code to display progress bar on page load
            url = "DocumentSalesAnalysis.aspx?Item=" + e.Item.Cells[0].Text + "~MonthName=" + Request.QueryString["MonthName"] + "~Month=" + Request.QueryString["Month"] + "~Year=" + Request.QueryString["Year"] + "~Branch=" + Request.QueryString["Branch"] + "~CustNo=" + Request.QueryString["CustNo"] + "~Chain=" + Request.QueryString["Chain"] + "~Version=" + strRdoVersion + "~SalesRep=" + strSalesRep.Replace("'", "|") + "~ZipFrom=" + strZipFrom + "~ZipTo=" + strZipTo + "~Period=" + strRdoPeriod + "~OrdType=" + Request.QueryString["OrdType"];
            url = "ProgressBar.aspx?destPage=" + url;

            //url = "DocumentSalesAnalysis.aspx?Item=" + e.Item.Cells[0].Text + "&MonthName=" + Request.QueryString["MonthName"] + "&Month=" + Request.QueryString["Month"] + "&Year=" + Request.QueryString["Year"] + "&Branch=" + Request.QueryString["Branch"] + "&CustNo=" + Request.QueryString["CustNo"] + "&Chain=" + Request.QueryString["Chain"]; ;
            HyperLink hplButton = new HyperLink();
            hplButton.Text = e.Item.Cells[0].Text;
            hplButton.NavigateUrl = url;

            hplButton.Attributes.Add("onclick", "DocumentSales=window.open(this.href, 'DocumentSales', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO'); return false;");
            e.Item.Cells[0].Controls.Add(hplButton);
            e.Item.Cells[0].CssClass = "GridItemLink";

        }
        else if (e.Item.ItemType == ListItemType.Footer && Session["ItemSalesGrandTotal"] != null)
        {
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[0].CssClass = "GridHead";
            DataTable dtGrandTotal = Session["ItemSalesGrandTotal"] as DataTable;
            Total = dtGrandTotal.Rows[0];
            decimal dmlGrandTotal;
            for (int i = 1; i <= 23; i++)
            {
                dmlGrandTotal = 0;
                if (Total[i].ToString() != "")
                {

                    dmlGrandTotal = Convert.ToDecimal(Total[i].ToString());

                    e.Item.Cells[i].Text = (i == 6 || i == 16 || i == 17 || i == 21 || i == 22 || i == 8 || i == 20 || i == 22 || i == 23) ?
                                            dmlGrandTotal.ToString() :
                                            String.Format("{0:#,##0}", dmlGrandTotal);
                    e.Item.Cells[i].HorizontalAlign = HorizontalAlign.Right;
                    e.Item.Cells[i].CssClass = "GridHead";
                }
            }
        }
        e.Item.Cells[0].CssClass = "locked";
        e.Item.Cells[1].CssClass = "locked";
    }

    protected string GetFileURL()
    {
        string url = "../Common/ExcelUploads/" + ViewState["ExcelFileName"].ToString();
        return url;
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
        ChangeColumns();
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
        ChangeColumns();
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
        ChangeColumns();
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

            FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + ViewState["ExcelFileName"].ToString()));
            StreamWriter reportWriter;
            reportWriter = fnExcel.CreateText();



            string chain = string.Empty;

            if (Request.QueryString["CustNo"].ToString() != "")
                chain = "Customer :" + Request.QueryString["CustNo"].ToString() + " - " + GetCustomerName();
            if (Request.QueryString["Chain"].ToString() != "")
                chain = "Chain :" + Request.QueryString["Chain"].ToString().Replace('`', '&');



            DataTable dtTemp = (DataTable)Session["ItemSale"];
            dtTemp.DefaultView.Sort = hidSort.Value;
            DataTable dt1 = dtTemp.DefaultView.ToTable();


            DataTable dtFooter = Session["ItemSalesGrandTotal"] as DataTable;
            Total = dtFooter.Rows[0];
            string lineHeading = string.Empty;

            string strYearNew = ((Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) ? Request.QueryString["Year"].ToString().Trim() :
                   Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString().Trim()) + 1));

            string strYearDis = "'" + strYearNew.Substring(2);
            string strPreYearDis = "'" + (Convert.ToInt16(strYearNew) - 1).ToString().Substring(2);


            #region ytd Long
            if (strFormat.Trim() == "ytd" && strVersion.Trim() == "long")
            {
                reportWriter.WriteLine("<table border=2px cellpadding=5 cellspacing=5>");
                reportWriter.WriteLine("<tr><td colspan=24  align=center><font color=blue size=15px><b>Item Sales Analysis Report</b></font></td></tr>");
                reportWriter.WriteLine("<tr><td colspan=24></td></tr>");
                reportWriter.WriteLine("<tr><td><th align=left bgcolor=whitesmoke>Period : " + "  " + Request.QueryString["MonthName"].ToString() + "-" + Request.QueryString["Year"].ToString() + "</th></td>" +
                                "<td><th align=left bgcolor=whitesmoke>Order Type :" + ((Request.QueryString["OrdType"] != "Non-Mill") ? Request.QueryString["OrdType"].ToString().Trim() : "Warehouse") + "</th></td>" +
                                  "<td><th align=left bgcolor=whitesmoke>Branch :" + Request.QueryString["BranchName"].ToString() + "</th></td>" +
                                  "<th colspan=2>" + chain + "</th>" + "<th>Sales Rep :</th>" + "<th>" + ((Request.QueryString["SalesRep"].ToString() != "") ? Request.QueryString["SalesRep"].ToString().Replace("|", "'") : "All") + "</th>" +
                                  "<th>Zip :</th>" + "<th>" + ((Request.QueryString["ZipFrom"] == "" && Request.QueryString["ZipTo"] == "") ? "All" : Request.QueryString["ZipFrom"].ToString() + " - " + Request.QueryString["ZipTo"].ToString()) + "</th>" +
                                  "<td><th align=left>Run By :" + Session["UserName"].ToString() + "</th></td>" +
                                  "<td><th align=left>Run Date :" + "  " + DateTime.Now.Month.ToString() + "/" + DateTime.Now.Day.ToString() + "/" + DateTime.Now.Year + "</th></tr>");
                reportWriter.WriteLine("<tr><td colspan=24></td></tr>");

                reportWriter.WriteLine("<tr><th>Item</th><th>Item Desc</th><th>UOM</th>" +
                "<th>" + strYearDis + " Qty" + "</th>" +
                "<th>" + strYearDis + " Sales $" + "</th>" +
                "<th>" + strYearDis + " GM $" + "</th>" +
                "<th>" + strYearDis + " GM %" + "</th>" +
                "<th>" + strYearDis + " SellWgt" + "</th>" +
                "<th>" + strYearDis + " $/Lb" + "</th>" +
                "<th>" + strYearDis + " Ord" + "</th>" +
                "<th>" + "YTD " + strYearDis + " Qty" + "</th>" +
                "<th>" + "YTD " + strPreYearDis + " Qty" + "</th>" +
                "<th>" + "YTD " + strYearDis + " Sales $" + "</th>" +
                "<th>" + "YTD " + strPreYearDis + " Sales $" + "</th>" +
                "<th>" + "YTD " + strYearDis + " GM$" + "</th>" +
                "<th>" + "YTD " + strPreYearDis + " GM$" + "</th>" +
                "<th>" + "YTD " + strYearDis + " GM%" + "</th>" +
                "<th>" + "YTD " + strPreYearDis + " GM%" + "</th>" +
                "<th>" + "YTD " + strYearDis + " SellWgt" + "</th>" +
                "<th>" + "YTD " + strPreYearDis + " SellWgt" + "</th>" +
                "<th>" + "YTD " + strYearDis + " $/Lb" + "</th>" +
                "<th>" + "YTD " + strPreYearDis + " $/Lb" + "</th>" +
                "<th>" + "YTD " + strYearDis + " Ord" + "</th>" +
                "<th>" + "YTD " + strPreYearDis + " Ord" + "</th></tr>");


                foreach (DataRow drow in dt1.Rows)
                {
                    reportWriter.WriteLine(
                                            "<tr><td>" + drow[0].ToString() + "</td>" +
                                            "<td>" + drow[1].ToString() + "</td>" +
                                            "<td>" + drow[2].ToString() + "</td>" +
                                            "<td>" + drow[3].ToString() + "</td>" +
                                            "<td>" + ((drow[4].ToString() != "0") ? ((drow[4].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[4])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[5].ToString() != "0") ? ((drow[5].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[5])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[6].ToString() != "0") ? ((drow[6].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(drow[6])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[7].ToString() != "0") ? ((drow[7].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[7])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[8].ToString() != "0") ? ((drow[8].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(drow[8])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[9].ToString() != "0") ? ((drow[9].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[9])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[10].ToString() != "0") ? ((drow[10].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[10])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[11].ToString() != "0") ? ((drow[11].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[11])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[12].ToString() != "0") ? ((drow[12].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[12])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[13].ToString() != "0") ? ((drow[13].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[13])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[14].ToString() != "0") ? ((drow[14].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[14])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[15].ToString() != "0") ? ((drow[15].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[15])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[16].ToString() != "0") ? ((drow[16].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(drow[16])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[17].ToString() != "0") ? ((drow[17].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(drow[17])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[18].ToString() != "0") ? ((drow[18].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[18])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[19].ToString() != "0") ? ((drow[19].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[19])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[20].ToString() != "0") ? ((drow[20].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(drow[20])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[21].ToString() != "0") ? ((drow[21].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(drow[21])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[22].ToString() != "0") ? ((drow[22].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[22])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[23].ToString() != "0") ? ((drow[23].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[23])) : "0") : "0") + "</td></tr>");

                }


                reportWriter.WriteLine(

                                           "<tr><th colspan=3 align=right>Grand Total</th>" +
                                           "<th align=right>" + Total[3].ToString() + "</th>" +
                                           "<th align=right>" + ((Total[4].ToString() != "0") ? ((Total[4].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[4])) : "0") : "0") + "</th>" +
                                            "<th align=right>" + ((Total[5].ToString() != "0") ? ((Total[5].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[5])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[6].ToString() != "0") ? ((Total[6].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(Total[6])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[7].ToString() != "0") ? ((Total[7].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[7])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[8].ToString() != "0") ? ((Total[8].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(Total[8])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[9].ToString() != "0") ? ((Total[9].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[9])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[10].ToString() != "0") ? ((Total[10].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[10])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[11].ToString() != "0") ? ((Total[11].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[11])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[12].ToString() != "0") ? ((Total[12].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[12])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[13].ToString() != "0") ? ((Total[13].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[13])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[14].ToString() != "0") ? ((Total[14].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[14])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[15].ToString() != "0") ? ((Total[15].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[15])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[16].ToString() != "0") ? ((Total[16].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(Total[16])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[17].ToString() != "0") ? ((Total[17].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(Total[17])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[18].ToString() != "0") ? ((Total[18].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[18])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[19].ToString() != "0") ? ((Total[19].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[19])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[20].ToString() != "0") ? ((Total[20].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(Total[20])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[21].ToString() != "0") ? ((Total[21].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(Total[21])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[22].ToString() != "0") ? ((Total[22].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[22])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[23].ToString() != "0") ? ((Total[23].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[23])) : "0") : "0") + "</th></tr>");
            }
            #endregion

            #region Ytd SHort
            if (strFormat.Trim() == "ytd" && strVersion.Trim() == "short")
            {

                reportWriter.WriteLine("<table border=2px cellpadding=5 cellspacing=5>");
                reportWriter.WriteLine("<tr><td colspan=18  align=center><font color=blue size=15px><b>Item Sales Analysis Report</b></font></td></tr>");
                reportWriter.WriteLine("<tr><td colspan=18></td></tr>");
                reportWriter.WriteLine("<tr>" +
                                    "<th align=left colspan=2>Period : " + "  " + Request.QueryString["MonthName"].ToString() + "-" + Request.QueryString["Year"].ToString() + "</th>" +
                                    "<td><th align=left bgcolor=whitesmoke>Order Type :" + ((Request.QueryString["OrdType"] != "Non-Mill") ? Request.QueryString["OrdType"].ToString().Trim() : "Warehouse") + "</th></td>" +
                                  "<th align=left colspan=2>Branch :" + Request.QueryString["BranchName"].ToString() + "</th>" +
                                  "<th colspan=2>" + chain + "</th>" +
                                  "<th>Sales Rep :</th>" + "<th>" + ((Request.QueryString["SalesRep"].ToString() != "") ? Request.QueryString["SalesRep"].ToString().Replace("|", "'") : "All") + "</th>" +
                                  "<th colspan=2>Zip :</th>" +
                                  "<th>" + ((Request.QueryString["ZipFrom"] == "" && Request.QueryString["ZipTo"] == "") ? "All" : Request.QueryString["ZipFrom"].ToString() + " - " + Request.QueryString["ZipTo"].ToString()) + "</th>" +
                                  "<th align=left colspan=3>Run By :" + Session["UserName"].ToString() + "</th>" +
                                  "<th align=left colspan=3>Run Date :" + "  " + DateTime.Now.ToShortDateString() + "</th></tr>");
                reportWriter.WriteLine("<tr><td colspan=18></td></tr>");

                reportWriter.WriteLine("<tr><th>Item</th><th>Item Desc</th><th>UOM</th>" +
                "<th>" + strYearDis + " Qty" + "</th>" +
                "<th>" + strYearDis + " Sales $" + "</th>" +
                "<th>" + strYearDis + " GM %" + "</th>" +
                "<th>" + strYearDis + " $/Lb" + "</th>" +
                "<th>" + strYearDis + " Ord" + "</th>" +
                "<th>" + "YTD " + strYearDis + " Qty" + "</th>" +
                "<th>" + "YTD " + strPreYearDis + " Qty" + "</th>" +
                "<th>" + "YTD " + strYearDis + " Sales $" + "</th>" +
                "<th>" + "YTD " + strPreYearDis + " Sales $" + "</th>" +
                "<th>" + "YTD " + strYearDis + " GM%" + "</th>" +
                "<th>" + "YTD " + strPreYearDis + " GM%" + "</th>" +
                "<th>" + "YTD " + strYearDis + " $/Lb" + "</th>" +
                "<th>" + "YTD " + strPreYearDis + " $/Lb" + "</th>" +
                "<th>" + "YTD " + strYearDis + " Ord" + "</th>" +
                "<th>" + "YTD " + strPreYearDis + " Ord" + "</th></tr>");


                foreach (DataRow drow in dt1.Rows)
                {



                    reportWriter.WriteLine(
                                            "<tr><td>" + drow[0].ToString() + "</td>" +
                                            "<td>" + drow[1].ToString() + "</td>" +
                                            "<td>" + drow[2].ToString() + "</td>" +
                                            "<td>" + drow[3].ToString() + "</td>" +
                                            "<td>" + ((Total[4].ToString() != "0") ? ((Total[4].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[4])) : "0") : "0") + "</td>" +
                                             "<td>" + ((drow[6].ToString() != "0") ? ((drow[6].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(drow[6])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[8].ToString() != "0") ? ((drow[8].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(drow[8])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[9].ToString() != "0") ? ((drow[9].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[9])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[10].ToString() != "0") ? ((drow[10].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[10])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[11].ToString() != "0") ? ((drow[11].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[11])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[12].ToString() != "0") ? ((drow[12].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[12])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[13].ToString() != "0") ? ((drow[13].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[13])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[16].ToString() != "0") ? ((drow[16].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(drow[16])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[17].ToString() != "0") ? ((drow[17].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(drow[17])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[20].ToString() != "0") ? ((drow[20].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(drow[20])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[21].ToString() != "0") ? ((drow[21].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(drow[21])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[22].ToString() != "0") ? ((drow[22].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[22])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[23].ToString() != "0") ? ((drow[23].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[23])) : "0") : "0") + "</td></tr>");

                }


                reportWriter.WriteLine(

                                           "<tr><th colspan=3 align=right>Grand Total</th>" +
                                           "<th align=right>" + String.Format("{0:#,###}", Convert.ToDecimal(((Total[3].ToString() != "") ? Total[3] : 0))) + "</th>" +
                                           "<th align=right>" + ((Total[4].ToString() != "0") ?((Total[4].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[4])):"0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[6].ToString() != "0") ? ((Total[6].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(Total[6])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[8].ToString() != "0") ? ((Total[8].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(Total[8])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[9].ToString() != "0") ? ((Total[9].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[9])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[10].ToString() != "0") ? ((Total[10].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[10])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[11].ToString() != "0") ? ((Total[11].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[11])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[12].ToString() != "0") ? ((Total[12].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[12])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[13].ToString() != "0") ? ((Total[13].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[13])) : "0") : "0") + "</th>" +
                                            "<th align=right>" + ((Total[16].ToString() != "0") ? ((Total[16].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(Total[16])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[17].ToString() != "0") ? ((Total[17].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(Total[17])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[20].ToString() != "0") ? ((Total[20].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(Total[20])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[21].ToString() != "0") ? ((Total[21].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(Total[21])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[22].ToString() != "0") ? ((Total[22].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[22])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[23].ToString() != "0") ? ((Total[23].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[23])) : "0") : "0") + "</th></tr>");
            }
            #endregion

            #region MTDShort

            if (strFormat.Trim() == "mtd" && strVersion.Trim() == "short")
            {

                reportWriter.WriteLine("<table border=2px cellpadding=5 cellspacing=5>");
                reportWriter.WriteLine("<tr><td colspan=8  align=center><font color=blue size=15px><b>Item Sales Analysis Report</b></font></td></tr>");
                reportWriter.WriteLine("<tr><td colspan=8></td></tr>");
                reportWriter.WriteLine("<tr>" +
                                    "<th align=left>Period : " + "  " + Request.QueryString["MonthName"].ToString() + "-" + Request.QueryString["Year"].ToString() + "</th>" +
                                  "<td><th align=left bgcolor=whitesmoke>Order Type :" + ((Request.QueryString["OrdType"] != "Non-Mill") ? Request.QueryString["OrdType"].ToString().Trim() : "Warehouse") + "</th></td>" +
                                    "<th align=left>Branch :" + Request.QueryString["BranchName"].ToString() + "</th>" +
                                  "<th >" + chain + "</th>" +
                                  "<th>Sales Rep :" + ((Request.QueryString["SalesRep"].ToString() != "") ? Request.QueryString["SalesRep"].ToString().Replace("|", "'") : "All") + "</th>" +
                                  "<th >Zip :</th>" +
                                  "<th>" + ((Request.QueryString["ZipFrom"] == "" && Request.QueryString["ZipTo"] == "") ? "All" : Request.QueryString["ZipFrom"].ToString() + " - " + Request.QueryString["ZipTo"].ToString()) + "</th>" +
                                  "<th align=left >Run By :" + Session["UserName"].ToString() + "</th>" +
                                  "<th align=left>Run Date :" + "  " + DateTime.Now.ToShortDateString() + "</th></tr>");
                reportWriter.WriteLine("<tr><td colspan=8></td></tr>");




                reportWriter.WriteLine("<tr><th>Item</th><th>Item Desc</th><th>UOM</th>" +
                                       "<th>" + strYearDis + " Qty" + "</th>" +
                                       "<th>" + strYearDis + " Sales $" + "</th>" +
                                       "<th>" + strYearDis + " GM %" + "</th>" +
                                       "<th>" + strYearDis + " $/Lb" + "</th>" + "<th align=right>" + strYearDis + " Ord</th>" +
                                       "</tr>");



                foreach (DataRow drow in dt1.Rows)
                {

                    reportWriter.WriteLine(
                                            "<tr><td>" + drow[0].ToString() + "</td>" +
                                            "<td>" + drow[1].ToString() + "</td>" +
                                            "<td>" + drow[2].ToString() + "</td>" +
                                            "<td>" + ((drow[3].ToString() != "0") ? ((drow[3].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[3])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[4].ToString() != "0") ? ((drow[4].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[4])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[6].ToString() != "0") ? ((drow[6].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(drow[6])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[9].ToString() != "0") ? ((drow[9].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(drow[9])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[8].ToString() != "0") ? ((drow[8].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[8])) : "0") : "0") + "</td>" +
                                            "</tr>");

                }

                reportWriter.WriteLine(

                                           "<tr align=right><th colspan=3 align=right>Grand Total</th>" +
                                           "<th align=right>" + String.Format("{0:#,###}", Convert.ToDecimal(((Total[3].ToString() != "") ? Total[3] : 0))) + "</th>" +
                                           "<th align=right>" + ((Total[4].ToString() != "0") ? ((Total[4].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[4])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[6].ToString() != "0") ? ((Total[6].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(Total[6])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[8].ToString() != "0") ? ((Total[8].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(Total[8])) : "0") : "0") + "</th>" + "<th align=right>" + ((Total[9].ToString() != "0") ? ((Total[9].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[9])) : "0") : "0") + "</th>" +
                                           "</tr>");

            }

            #endregion

            #region MTDLong

            if (strFormat.Trim() == "mtd" && strVersion.Trim() == "long")
            {

                reportWriter.WriteLine("<table border=2px cellpadding=5 cellspacing=5>");
                reportWriter.WriteLine("<tr><td colspan=10  align=center><font color=blue size=15px><b>Item Sales Analysis Report</b></font></td></tr>");
                reportWriter.WriteLine("<tr><td colspan=10></td></tr>");
                reportWriter.WriteLine("<tr>" +
                                    "<th align=left>Period : " + "  " + Request.QueryString["MonthName"].ToString() + "-" + Request.QueryString["Year"].ToString() + "</th>" +
                                    "<td><th align=left bgcolor=whitesmoke>Order Type :" + ((Request.QueryString["OrdType"] != "Non-Mill") ? Request.QueryString["OrdType"].ToString().Trim() : "Warehouse") + "</th></td>" +
                                  "<th align=left>Branch :" + Request.QueryString["BranchName"].ToString() + "</th>" +
                                  "<th >" + chain + "</th>" +
                                  "<th>Sales Rep :" + ((Request.QueryString["SalesRep"].ToString() != "") ? Request.QueryString["SalesRep"].ToString().Replace("|", "'") : "All") + "</th>" +
                                  "<th >Zip :</th>" +
                                  "<th>" + ((Request.QueryString["ZipFrom"] == "" && Request.QueryString["ZipTo"] == "") ? "All" : Request.QueryString["ZipFrom"].ToString() + " - " + Request.QueryString["ZipTo"].ToString()) + "</th>" +
                                  "<th align=left colspan=2 >Run By :" + Session["UserName"].ToString() + "</th>" +
                                  "<th align=left colspan=2>Run Date :" + "  " + DateTime.Now.ToShortDateString() + "</th></tr>");
                reportWriter.WriteLine("<tr><td colspan=10></td></tr>");




                reportWriter.WriteLine("<tr><th>Item</th><th>Item Desc</th><th>UOM</th>" +
                "<th>" + strYearDis + " Qty" + "</th>" +
                "<th>" + strYearDis + " Sales $" + "</th>" +
                "<th>" + strYearDis + " GM $" + "</th>" +
                "<th>" + strYearDis + " GM %" + "</th>" +
                "<th>" + strYearDis + " SellWgt" + "</th>" +
                "<th>" + strYearDis + " $/Lb" + "</th>" + "<th>" + strYearDis + " Ord</th></th>" +
                "</tr>");


                foreach (DataRow drow in dt1.Rows)
                {

                    reportWriter.WriteLine(
                                           "<tr><td>" + drow[0].ToString() + "</td>" +
                                            "<td>" + drow[1].ToString() + "</td>" +
                                            "<td>" + drow[2].ToString() + "</td>" +
                                            "<td>" + ((drow[3].ToString() != "0") ? ((drow[3].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[3])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[4].ToString() != "0") ? ((drow[4].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[4])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[5].ToString() != "0") ? ((drow[5].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[5])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[6].ToString() != "0") ? ((drow[6].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(drow[6])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[7].ToString() != "0") ? ((drow[7].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[7])) : "0") : "0") + "</td>" +
                                            "<td>" + ((drow[9].ToString() != "0") ? ((drow[9].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(drow[9])) : "0") : "0") + "</td>" + "<td>" + ((drow[8].ToString() != "0") ? ((drow[8].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(drow[8])) : "0") : "0") + "</td></tr>");

                }


                reportWriter.WriteLine(

                                          "<tr align=right><th colspan=3 align=right>Grand Total</th>" +
                                           "<th align=right>" + Total[3].ToString() + "</th>" +
                                           "<th align=right>" + ((Total[4].ToString() != "0") ? ((Total[4].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[4])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[5].ToString() != "0") ? ((Total[5].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[5])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[6].ToString() != "0") ? ((Total[6].ToString() != "") ? String.Format("{0:0.0}", Convert.ToDecimal(Total[6])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[7].ToString() != "0") ? ((Total[7].ToString() != "") ? String.Format("{0:#,###}", Convert.ToDecimal(Total[7])) : "0") : "0") + "</th>" +
                                           "<th align=right>" + ((Total[8].ToString() != "0") ? ((Total[8].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(Total[8])) : "0") : "0") + "</th><th align=right>" + ((Total[9].ToString() != "0") ? ((Total[9].ToString() != "") ? String.Format("{0:0.00}", Convert.ToDecimal(Total[9])) : "0") : "0") + "</th>" + "</tr>"
                                           );
            }

            #endregion

            reportWriter.WriteLine("</table>");
            reportWriter.Close();
        }
        catch (Exception ex) { Response.Write(ex.ToString()); }
    }

    #region YTD & MTD
    private void ChangeColumns()
    {
        if (strVersion == "long" && strFormat == "ytd")
        {
            for (int i = 0; i <= 23; i++)
                dgAnalysis.Columns[i].Visible = true;
        }

        if (strVersion == "long" && strFormat == "mtd")
        {
            for (int i = 10; i <= 23; i++)
                dgAnalysis.Columns[i].Visible = false;

            dgAnalysis.Width = 1000;
            dgAnalysis.Columns[2].Visible = true;
            dgAnalysis.Columns[3].Visible = true;
            dgAnalysis.Columns[4].Visible = true;
            dgAnalysis.Columns[5].Visible = true;
            dgAnalysis.Columns[6].Visible = true;
            dgAnalysis.Columns[7].Visible = true;
            dgAnalysis.Columns[8].Visible = true;
            dgAnalysis.Columns[9].Visible = true;


        }
        if (strVersion == "short" && strFormat == "ytd")
        {
            for (int i = 0; i <= 23; i++)
                dgAnalysis.Columns[i].Visible = true;

            dgAnalysis.Columns[5].Visible = false;
            dgAnalysis.Columns[7].Visible = false;
            dgAnalysis.Columns[14].Visible = false;
            dgAnalysis.Columns[15].Visible = false;
            dgAnalysis.Columns[18].Visible = false;
            dgAnalysis.Columns[19].Visible = false;

        }
        if (strVersion == "short" && strFormat == "mtd")
        {
            for (int i = 10; i <= 23; i++)
                dgAnalysis.Columns[i].Visible = false;

            dgAnalysis.Columns[5].Visible = false;
            dgAnalysis.Columns[7].Visible = false;
            dgAnalysis.Columns[14].Visible = false;
            dgAnalysis.Columns[15].Visible = false;
            dgAnalysis.Columns[18].Visible = false;
            dgAnalysis.Columns[19].Visible = false;


        }

        dgAnalysis.Width = (strFormat == "ytd" && strVersion == "long")
                           ? 1825 :
                           ((strFormat == "ytd" && strVersion == "short") ? 1550 : 
                           (strFormat == "mtd" && strVersion == "long")?800:700);


        BindDataToGrid();
    }
    protected void rdoReportVersion1_CheckedChanged(Object sender, System.EventArgs e)
    {
        ExcelExport();
        ChangeColumns();
    }

    protected void rdoReportVersion2_CheckedChanged(Object sender, System.EventArgs e)
    {
        ExcelExport();
        ChangeColumns();

    }

    protected void rdoPeriod1_CheckedChanged(Object sender, System.EventArgs e)
    {
        ExcelExport();
        ChangeColumns();

    }

    protected void rdoPeriod2_CheckedChanged(Object sender, System.EventArgs e)
    {
        ExcelExport();
        ChangeColumns();

    }
    #endregion

    protected void btnPrint_Click(Object sender, System.EventArgs e)
    {

        RegisterClientScriptBlock("PopUp", "<script>PrintReport('" + strRdoVersion + "','" + strRdoPeriod + "')</script>");
        ExcelExport();
        ChangeColumns();
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
