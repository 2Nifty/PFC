
/********************************************************************************************
 * File	Name			:	BranchItemSalesAnalysis.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Retrive Data From Curvaldtl Table - Branchwise.
 * Created By			:	Senthilkumar
 * Created Date			:	08/07/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/12/2006		    Version 1		Senthilkumar		Excel Report Added 
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


public partial class BranchCustomerSalesAnalysis : System.Web.UI.Page
{
    SqlConnection cn = new SqlConnection(PFC.Intranet.Global.ReportsConnectionString);
    Utility utility = new Utility();
    System.Data.DataTable dt = new System.Data.DataTable();
    DataSet dsCustomerInfo = new DataSet();

    string strVersion = string.Empty;
    string strPeriod = string.Empty;
    string strMonth = string.Empty;
    string strYear = string.Empty;
    string strBranch = string.Empty;
    string strItem = string.Empty;
    string strCustNo = string.Empty;
    string strSalesRep = string.Empty;
    System.IO.FileStream fStream;

    DataRow ColTotal;
    int iTotalCols;

    int pagesize = 17;

    protected void Page_Load(object sender, EventArgs e)
    {
        utility.CheckBrowserCompatibility(Request, dgAnalysis, ref pagesize);

        #region Get QueryString Values

        strMonth = (Request.QueryString["Month"] != null) ? Request.QueryString["Month"].ToString().Trim() : "";
        strYear = (Request.QueryString["Year"] != null) ? Request.QueryString["Year"].ToString().Trim() : "";
        strBranch = (Request.QueryString["Branch"] != "0") ? Request.QueryString["Branch"].ToString().Trim() : "";
        strItem = (Request.QueryString["item"] != null) ? Request.QueryString["item"].ToString().Trim() : "";
        strSalesRep = (Request.QueryString["SalesRep"] != null) ? Request.QueryString["SalesRep"].ToString().Trim().Replace("|", "'") : "";
        strVersion = (Request.QueryString["Version"] != null) ? Request.QueryString["Version"].ToString().Trim() : "";
        strPeriod = (Request.QueryString["Period"] != null) ? Request.QueryString["Period"].ToString().Trim() : "";

        #endregion

        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(BranchCustomerSalesAnalysis));

        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");
        ViewState["ExcelFileName"] = "BranchCustomerSalesAnalysis" + Session["SessionID"].ToString() + name + ".xls";

        if (!IsPostBack)
        {
            CustomerDataDisplay();
        }
        
        
        System.Data.DataTable dtFooter = Session["dtBranchCustomerSalesGrandTotal"] as System.Data.DataTable;
        ColTotal = dtFooter.Rows[0];
        
    }
    public void CustomerDataDisplay()
    {
       
        GetCustomerData();
        ExcelExport();
        ChangeFormat();

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
        dgAnalysis.Columns[5].HeaderText = strYearDis + " Sales";
        dgAnalysis.Columns[6].HeaderText = strPreYearDis + " Sales";
        dgAnalysis.Columns[7].HeaderText = strYearDis + " GM$";
        dgAnalysis.Columns[8].HeaderText = strYearDis + " GM%";
        dgAnalysis.Columns[9].HeaderText = strPreYearDis + " GM$";
        dgAnalysis.Columns[10].HeaderText = strPreYearDis + " GM%";
        dgAnalysis.Columns[11].HeaderText = strYearDis + " Wgt";
        dgAnalysis.Columns[12].HeaderText = strYearDis + " $/Lb";
        dgAnalysis.Columns[13].HeaderText = strPreYearDis + " Wgt";
        dgAnalysis.Columns[14].HeaderText = strPreYearDis + " $/Lb";
        dgAnalysis.Columns[15].HeaderText = "YTD " + strYearDis + " Sales";
        dgAnalysis.Columns[16].HeaderText = "YTD " + strPreYearDis + " Sales";
        dgAnalysis.Columns[17].HeaderText = "YTD " + strYearDis + " GM$";
        dgAnalysis.Columns[18].HeaderText = "YTD " + strYearDis + " GM%";
        dgAnalysis.Columns[19].HeaderText = "YTD " + strPreYearDis + " GM$";
        dgAnalysis.Columns[20].HeaderText = "YTD " + strPreYearDis + " GM%";
        dgAnalysis.Columns[21].HeaderText = "YTD " + strYearDis + " Wgt";
        dgAnalysis.Columns[22].HeaderText = "YTD " + strYearDis + " $/Lb";
        dgAnalysis.Columns[23].HeaderText = "YTD " + strPreYearDis + " Wgt";
        dgAnalysis.Columns[24].HeaderText = "YTD " + strPreYearDis + " $/Lb";
        dgAnalysis.Columns[25].HeaderText = "Rep";
        dgAnalysis.Columns[26].HeaderText = "Group";

        dgAnalysis.Columns[0].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[1].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[2].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[3].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[4].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[25].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[26].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;
        dgAnalysis.Columns[27].HeaderStyle.HorizontalAlign = HorizontalAlign.Left;

    }

    public void GetCustomerData()
    {
        try
        {
            dsCustomerInfo = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[PFC_RPT_SP_BranchCustomerSalesAnalysis]",
                new SqlParameter("@PeriodMonth", strMonth),
                new SqlParameter("@PeriodYear", strYear),
                new SqlParameter("@Branch", strBranch),
                new SqlParameter("@Item", strItem),
                new SqlParameter("@SalesRep", strSalesRep.Replace("'", "''"))

              );

            dt.Clear();
            dt = dsCustomerInfo.Tables[0];
            dt.DefaultView.Sort = "CustNo" + " " + "asc";

            // Footer table
            if (dsCustomerInfo.Tables[1] != null)
            {
                Session["dtBranchCustomerSalesGrandTotal"] = dsCustomerInfo.Tables[1];
            }

            Session["BranchCustomer"] = dt;
            ViewState["SortField"] = "CustNo";
            ViewState["SortMode"] = "asc";
        }
        catch (Exception ex) { Response.Write(ex.Message.ToString()); }
    }
    
    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgAnalysis.CurrentPageIndex = Pager1.GotoPageNumber;
        ChangeFormat();
    }

    protected void btnPrint_Click(Object sender, System.EventArgs e)
    {

        //if (rdoReportVersion1.Checked == true)
        //    RegisterClientScriptBlock("PopUp", "<script>PrintReport('long')</script>");
        //if (rdoReportVersion2.Checked == true)
        //    RegisterClientScriptBlock("PopUp", "<script>PrintReport('short')</script>");


        if (strPeriod == "ytd" && strVersion == "long")
            RegisterClientScriptBlock("PopUp", "<script>PrintReport('long','ytd')</script>");
        if (strPeriod == "ytd" && strVersion == "short")
            RegisterClientScriptBlock("PopUp", "<script>PrintReport('short','ytd')</script>");
        if (strPeriod == "mtd" && strVersion == "long")
            RegisterClientScriptBlock("PopUp", "<script>PrintReport('long','mtd')</script>");
        if (strPeriod == "mtd" && strVersion == "short")
            RegisterClientScriptBlock("PopUp", "<script>PrintReport('short','mtd')</script>");


        ExcelExport();
        ChangeFormat();
    }

    #region DataGrid Functionalities
    public void BindDataToGrid()
    {
        try
        {
            BindDataGridHeader();
            DataTable dt1 = (DataTable)Session["BranchCustomer"];
            dt1.DefaultView.Sort = hidSortField.Value;
            Session["BranchCustomer"] = dt1.DefaultView.ToTable();
            dgAnalysis.DataSource = dt1.DefaultView.ToTable();


            Pager1.InitPager(dgAnalysis, 17);
            DropDownList ddl = Pager1.FindControl("ddlPages") as DropDownList;
            if (ddl.SelectedItem != null && ddl.SelectedItem.Value.ToString() == ddl.Items.Count.ToString())
            {
                dgAnalysis.ShowFooter = true;
            }
            else
            {
                dgAnalysis.ShowFooter = false;
            }


            System.Data.DataTable dt = (System.Data.DataTable)Session["BranchCustomer"];
            dgAnalysis.DataSource = dt;
            Pager1.InitPager(dgAnalysis, pagesize);

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
        if (hidSort.Value == "")
        {

            hidSort.Value = "Asc";
            hidSortField.Value = e.SortExpression + " " + hidSort.Value;
        }
        else
        {
            if (hidSort.Value == "Asc")
            {
                hidSort.Value = "Desc";
                hidSortField.Value = e.SortExpression + " " + hidSort.Value;
            }
            else
            {
                if (hidSort.Value == "Desc")
                {
                    hidSort.Value = "Asc";
                    hidSortField.Value = e.SortExpression + " " + hidSort.Value;
                }
            }
        }
        ExcelExport();
        ChangeFormat();
    }
    protected void dgAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {


        if (e.Item.ItemType == ListItemType.Footer && Session["dtBranchCustomerSalesGrandTotal"] != null)
        {
            e.Item.Cells[0].Text = "Grand Total";
            e.Item.Cells[0].CssClass = "GridHead";

            System.Data.DataTable dtFooter = Session["dtBranchCustomerSalesGrandTotal"] as System.Data.DataTable;

            DataRow ColTotal = dtFooter.Rows[0];
            decimal dmlGrandTotal;
            for (int iCnt = 5; iCnt <= 26; iCnt++)
            {
                dmlGrandTotal = 0;
                if (ColTotal[iCnt].ToString() != "")
                    dmlGrandTotal = Convert.ToDecimal(ColTotal[iCnt].ToString());

                if (iCnt == 8 || iCnt == 10 || iCnt == 18 || iCnt == 20)
                    e.Item.Cells[iCnt].Text = String.Format("{0:0.0}", dmlGrandTotal);
                else if (iCnt == 12 || iCnt == 14 || iCnt == 22 || iCnt == 24)
                    e.Item.Cells[iCnt].Text = String.Format("{0:0.00}", dmlGrandTotal);
                else
                    e.Item.Cells[iCnt].Text = String.Format("{0:#,###}", dmlGrandTotal);

                
                e.Item.Cells[iCnt].HorizontalAlign = HorizontalAlign.Right;
                e.Item.Cells[iCnt].CssClass = "GridHead";
            }
        }
        e.Item.Cells[0].CssClass = "locked";
        e.Item.Cells[1].CssClass = "locked";
    }
    protected void dgAnalysis_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgAnalysis.CurrentPageIndex = e.NewPageIndex;
        ChangeFormat();

    }
    #endregion

    protected string GetFileURL()
    {
        string url = "../Common/ExcelUploads/" + ViewState["ExcelFileName"].ToString();
        return url;
    }

    #region  Write to Excel

    protected void ExcelExport()
    {
        try
        {
            
            string fileName =string.Empty;
            if( strPeriod == "ytd" && strVersion == "long" )
                CreateXMLFileYTDLongVersion(ViewState["ExcelFileName"].ToString());
            if (strPeriod == "ytd" && strVersion == "short")
                CreateXMLFileYTDShortVersion(ViewState["ExcelFileName"].ToString());
            if (strPeriod == "mtd" && strVersion == "short")
                CreateExcelForMTDShortVersion(ViewState["ExcelFileName"].ToString());
            if (strPeriod == "mtd" && strVersion == "long")
                CreateExcelForMTDLongVersion(ViewState["ExcelFileName"].ToString());
            
        }
        catch (Exception ex) { Response.Write(ex.ToString()); }
    }

    private void CreateXMLFileYTDLongVersion(string fileName)
    {

        
        FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + fileName ));


        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        reportWriter.WriteLine("<table cellpadding=5 cellspacing=5 border=2px>");
        reportWriter.WriteLine("<tr><th colspan=28><font size=15px color=blue><b>Branch Customer Sales Analysis Report</b></font></th></tr>");
        
        reportWriter.WriteLine("<tr>" +
                "<th>" + "Period :</th><th align=left colspan=3>" + Request.QueryString["MonthName"].ToString() + " " + strYear + "</th>" +
                "<th>Branch :</th><th align=left colspan=3>" + strBranch + "</th>" +
                "<th>Item :</th><th align=left colspan=5>" + strItem + "</th>" +
                "<th>Run By :</th><th align=left colspan=5>" + Session["UserName"].ToString() + "</th>" +
                "<th colspan=2>Run Date :</th><th align=left colspan=3>" + DateTime.Now.ToShortDateString() + "</th></tr>");

        reportWriter.WriteLine("<tr><td colspan=28></td></tr>");

        System.Data.DataTable dtTemp = (System.Data.DataTable)Session["BranchCustomer"];

        dtTemp.DefaultView.Sort = hidSortField.Value;
        System.Data.DataTable dt1 = dtTemp.DefaultView.ToTable();
        string lineHeading = string.Empty;

        string strYearNew = ((Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) ? Request.QueryString["Year"].ToString().Trim() :
                   Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString().Trim()) + 1));

        string strYearDis = "'" + strYearNew.Substring(2);
        string strPreYearDis = "'" + (Convert.ToInt16(strYearNew) - 1).ToString().Substring(2);


        reportWriter.WriteLine("<tr>" + "<th align=left>" + "Cust #" + "</th>" +
                                "<th align=left>" + "Name" + "</th>" +
                                "<th align=left>" + "City" + "</th>" +
                                "<th align=left>" + "Brn" + "</th>" +
                                "<th align=left>" + "Chain" + "</th>" +
                                "<th align=right>" + strYearDis + " Sales" + "</th>" +
                                "<th align=right>" + strPreYearDis + " Sales" + "</th>" +
                                "<th align=right>" + strYearDis + " GM$" + "</th>" +
                                "<th align=right>" + strYearDis + " GM%" + "</th>" +
                                "<th align=right>" + strPreYearDis + " GM$" + "</th>" +
                                "<th align=right>" + strPreYearDis + " GM%" + "</th>" +
                                "<th align=right>" + strYearDis + " Wgt" + "</th>" +
                                "<th align=right>" + strYearDis + " $/Lb" + "</th>" +
                                "<th align=right>" + strPreYearDis + " Wgt" + "</th>" +
                                "<th align=right>" + strPreYearDis + " $/Lb" + "</th>" +
                                "<th align=right>" + "YTD " + strYearDis + " Sales" + "</th>" +
                                "<th align=right>" + "YTD " + strPreYearDis + " Sales" + "</th>" +
                                "<th align=right>" + "YTD " + strYearDis + " GM$" + "</th>" +
                                "<th align=right>" + "YTD " + strYearDis + " GM%" + "</th>" +
                                "<th align=right>" + "YTD " + strPreYearDis + " GM$" + "</th>" +
                                "<th align=right>" + "YTD " + strPreYearDis + " GM%" + "</th>" +
                                "<th align=right>" + "YTD " + strYearDis + " Wgt" + "</th>" +
                                "<th align=right>" + "YTD " + strYearDis + " $/Lb" + "</th>" +
                                "<th align=right>" + "YTD " + strPreYearDis + " Wgt" + "</th>" +
                                "<th align=right>" + "YTD " + strPreYearDis + " $/Lb" + "</th>" +
                                "<th align=right>" + "Rep" + "</th>" +
                                "<th align=right>" + "Group" + "</th>" + "<th>" + "Zip" + "</th>" + "</tr>");

        try
        {
            foreach (DataRow drow in dt1.Rows)
            {
                string lineContent = string.Empty;
                for (int i = 0; i <= 27; i++)
                {

                    lineContent += ((i == 4) ?
                         "<td align=left>" + drow[i].ToString() + "</td>" : "<td>" + ((i <= 4 || i == 8 || i == 10 || i == 12 || i == 18 || i == 20 || i == 14 || i == 22 || i >= 24) ?
                        drow[i].ToString() : 
                       ((drow[i].ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(((drow[i].ToString() != "") ? drow[i] : 0))) : "0")) + "</td>");
                }
                reportWriter.WriteLine("<tr>" + lineContent.ToString() + "</tr>");
            }

            System.Data.DataTable dtTotal = (System.Data.DataTable)Session["dtBranchCustomerSalesGrandTotal"];
            foreach (DataRow drow in dtTotal.Rows)
            {
                string lineContent = string.Empty;
                lineContent = "<th colspan=5 align=right>GrandTotal</th>";
                for (int i = 5; i <= 26; i++)
                {
                    lineContent += ((i == 8 || i == 10 || i == 12 || i == 14 || i == 18 || i == 20 || i == 22 || i >= 24) ? "<th align=right>" + (drow[i] == null ? "" : drow[i].ToString()) + "</th>" : "<th align=right>" + ((drow[i].ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(((drow[i].ToString() != "") ? drow[i] : 0))) : "0")) + "</th>";
                }
                reportWriter.WriteLine("<tr align=right>" + lineContent.ToString() + "</th></tr>");
            }

            reportWriter.WriteLine("</table>");

            reportWriter.Close();

            
        }
        catch (Exception ex) 
        { 
            reportWriter.Close();
            
        }
    }

    private void CreateXMLFileYTDShortVersion(string fileName)
    {

        FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + fileName));

        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        reportWriter.WriteLine("<table cellpadding=5 cellspacing=5 border=2px>");
        reportWriter.WriteLine("<tr><th colspan=20><font size=15px color=blue><b>Branch Customer Sales Analysis Report</b></font></th></tr>");

        reportWriter.WriteLine("<tr>" +
                "<th>" + "Period :</th><th align=left colspan=2>" + Request.QueryString["MonthName"].ToString() + " " + strYear + "</th>" +
                "<th>Branch :</th><th align=left colspan=2>" + strBranch + "</th>" +
                "<th>Item :</th><th align=left colspan=2>" + strItem + "</th>" +
                "<th>Run By :</th><th align=left colspan=2>" + Session["UserName"].ToString() + "</th>" +
                "<th colspan=2>Run Date :</th><th align=left colspan=3>" + DateTime.Now.ToShortDateString() + "</th></tr>");

        reportWriter.WriteLine("<tr><td colspan=20></td></tr>");

        System.Data.DataTable dtTemp = (System.Data.DataTable)Session["BranchCustomer"];

        dtTemp.DefaultView.Sort = hidSortField.Value;
        System.Data.DataTable dt1 = dtTemp.DefaultView.ToTable();
        
        string lineHeading = string.Empty;

        string strYearNew = ((Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) ? Request.QueryString["Year"].ToString().Trim() :
                    Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString().Trim()) + 1));

        string strYearDis = "'" + strYearNew.Substring(2);
        string strPreYearDis = "'" + (Convert.ToInt16(strYearNew) - 1).ToString().Substring(2);


        reportWriter.WriteLine("<tr>" + "<th align=left>" + "Cust #" + "</th>" +
                                "<th align=left>" + "Name" + "</th>" +
                                "<th align=left>" + "City" + "</th>" +
                                "<th align=left>" + "Brn" + "</th>" +
                                "<th align=left>" + "Chain" + "</th>" +
                                "<th align=right>" + strYearDis + " Sales" + "</th>" +
                                "<th align=right>" + strPreYearDis + " Sales" + "</th>" +
                                "<th align=right>" + strYearDis + " GM%" + "</th>" +
                                "<th align=right>" + strPreYearDis + " GM%" + "</th>" +
                                "<th align=right>" + strYearDis + " $/Lb" + "</th>" +
                                "<th align=right>" + strPreYearDis + " $/Lb" + "</th>" +
                                "<th align=right>" + "YTD " + strYearDis + " Sales" + "</th>" +
                                "<th align=right>" + "YTD " + strPreYearDis + " Sales" + "</th>" +
                                "<th align=right>" + "YTD " + strYearDis + " GM%" + "</th>" +
                                "<th align=right>" + "YTD " + strPreYearDis + " GM%" + "</th>" +
                                "<th align=right>" + "YTD " + strYearDis + " $/Lb" + "</th>" +
                                "<th align=right>" + "YTD " + strPreYearDis + " $/Lb" + "</th>" +
                                "<th align=right>" + "Rep" + "</th>" +
                                "<th align=right>" + "Group" + "</th>" + "<th>" + "Zip" + "</th>" + "</tr>");

        try
        {
            foreach (DataRow drow in dt1.Rows)
            {
                string lineContent = string.Empty;
                for (int i = 0; i <= 27; i++)
                {
                    if (i != 7 && i != 9 && i != 11 && i != 13 && i != 17 && i != 19 && i != 21 && i != 23)
                        lineContent += ((i == 4) ?
                         "<td align=left>" + drow[i].ToString() + "</td>" : "<td>" + ((i <= 5 || i == 8 || i == 10 || i == 12 || i == 14 || i == 18 || i == 20 || i == 22 || i >= 24) ? drow[i].ToString() : ((drow[i].ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(((drow[i].ToString() != "") ? drow[i] : 0))) : "0")) + "</td>");
                }
                reportWriter.WriteLine("<tr>" + lineContent.ToString() + "</tr>");
            }

            System.Data.DataTable dtTotal = (System.Data.DataTable)Session["dtBranchCustomerSalesGrandTotal"];
            foreach (DataRow drow in dtTotal.Rows)
            {
                string lineContent = string.Empty;
                lineContent = "<th colspan=5 align=right>GrandTotal</th>";
                for (int i = 5; i <= 26; i++)
                {
                    if (i != 7 && i != 9 && i != 11 && i != 13 && i != 17 && i != 19 && i != 21 && i != 23)
                        lineContent += ((i == 8 || i == 10 || i == 12 || i == 14 || i == 18 || i == 20 || i == 22 || i >= 24) ? "<th align=right>" + (drow[i] == null ? "" : drow[i].ToString()) + "</th>" : "<th align=right>" + ((drow[i].ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(((drow[i].ToString() != "") ? drow[i] : 0))) : "0")) + "</th>";
                }
                reportWriter.WriteLine("<tr align=right>" + lineContent.ToString() + "<th></th></tr>");
            }

            reportWriter.WriteLine("</table>");

            reportWriter.Close();

           
        }
        catch (Exception ex)
        {
           
           
        }
    }

    private void CreateExcelForMTDShortVersion(string fileName)
    {

        FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + fileName));


        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        reportWriter.WriteLine("<table cellpadding=5 cellspacing=5 border=2px>");
        reportWriter.WriteLine("<tr><th colspan=14><font size=15px color=blue><b>Branch Customer Sales Analysis Report</b></font></th></tr>");

        reportWriter.WriteLine("<tr>" +
                "<th>" + "Period :</th><th align=left colspan=1>" + Request.QueryString["MonthName"].ToString() + " " + strYear + "</th>" +
                "<th>Branch :</th><th align=left colspan=1>" + strBranch + "</th>" +
                "<th>Item :</th><th align=left colspan=1>" + strItem + "</th>" +
                "<th>Run By :</th><th align=left colspan=2>" + Session["UserName"].ToString() + "</th>" +
                "<th colspan=1>Run Date :</th><th align=left colspan=1>" + DateTime.Now.ToShortDateString() + "</th></tr>");

        reportWriter.WriteLine("<tr><td colspan=14></td></tr>");

        System.Data.DataTable dtTemp = (System.Data.DataTable)Session["BranchCustomer"];

        dtTemp.DefaultView.Sort = hidSortField.Value;
        System.Data.DataTable dt1 = dtTemp.DefaultView.ToTable();
        
        string lineHeading = string.Empty;

        string strYearNew = ((Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) ? Request.QueryString["Year"].ToString().Trim() :
                    Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString().Trim()) + 1));

        string strYearDis = "'" + strYearNew.Substring(2);
        string strPreYearDis = "'" + (Convert.ToInt16(strYearNew) - 1).ToString().Substring(2);


        reportWriter.WriteLine("<tr>" + "<th align=left>" + "Cust #" + "</th>" +
                                "<th align=left>" + "Name" + "</th>" +
                                "<th align=left>" + "City" + "</th>" +
                                "<th align=left>" + "Brn" + "</th>" +
                                "<th align=left>" + "Chain" + "</th>" +
                                "<th align=right>" + strYearDis + " Sales" + "</th>" +
                                "<th align=right>" + strPreYearDis + " Sales" + "</th>" +
                                "<th align=right>" + strYearDis + " GM%" + "</th>" +
                                "<th align=right>" + strPreYearDis + " GM%" + "</th>" +
                                "<th align=right>" + strYearDis + " $/Lb" + "</th>" +
                                "<th align=right>" + strPreYearDis + " $/Lb" + "</th>" +
                                "<th align=right>" + "Rep" + "</th>" +
                                "<th align=right>" + "Group" + "</th>" + "<th>" + "Zip" + "</th>" + "</tr>");

        try
        {
            foreach (DataRow drow in dt1.Rows)
            {
                string lineContent = string.Empty;
                for (int i = 0; i <= 27; i++)
                {
                    if (i != 7 && i != 9 && i != 11 && i != 13 && i != 15 && i != 16 && i != 17 && i != 18 && i != 19 && i != 20 && i != 21 && i != 22 && i != 23 && i != 24)
                        lineContent += ((i == 4) ?
                         "<td align=left>" + drow[i].ToString() + "</td>" : "<td>" + ((i <= 5 || i == 8 || i == 10 || i == 12 || i == 14 || i == 18 || i == 20 || i == 22 || i >= 24) ? drow[i].ToString() : ((drow[i].ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(((drow[i].ToString() != "") ? drow[i] : 0))) : "0")) + "</td>");
                }
                reportWriter.WriteLine("<tr>" + lineContent.ToString() + "</tr>");
            }

            System.Data.DataTable dtTotal = (System.Data.DataTable)Session["dtBranchCustomerSalesGrandTotal"];
            foreach (DataRow drow in dtTotal.Rows)
            {
                string lineContent = string.Empty;
                lineContent = "<th colspan=5 align=right>GrandTotal</th>";
                for (int i = 5; i <= 26; i++)
                {
                    if (i != 7 && i != 9 && i != 11 && i != 13 && i != 15 && i != 16 && i != 17 && i != 18 && i != 19 && i != 20 && i != 21 && i != 22 && i != 23 && i != 24)
                        lineContent += ((i == 8 || i == 10 || i == 12 || i == 14 || i == 18 || i == 20 || i == 22 || i >= 24) ? "<th align=right>" + (drow[i] == null ? "" : drow[i].ToString()) + "</th>" : "<th align=right>" + ((drow[i].ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(((drow[i].ToString() != "") ? drow[i] : 0))) : "0")) + "</th>";
                }
                reportWriter.WriteLine("<tr align=right>" + lineContent.ToString() + "<th></th></tr>");
            }

            reportWriter.WriteLine("</table>");

            reportWriter.Close();

        }
        catch (Exception ex)
        {
            reportWriter.Close();
           
        }
    }

    private void CreateExcelForMTDLongVersion(string fileName)
    {

        FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + fileName));

        if (File.Exists(Server.MapPath("..//Common//ExcelUploads//" + ViewState["ExcelFileName"].ToString())))
            File.Delete(Server.MapPath("..//Common//ExcelUploads//" + ViewState["ExcelFileName"].ToString()));

        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        reportWriter.WriteLine("<table cellpadding=5 cellspacing=5 border=2px>");
        reportWriter.WriteLine("<tr><th colspan=18><font size=15px color=blue><b>Branch Customer Sales Analysis Report</b></font></th></tr>");

        reportWriter.WriteLine("<tr>" +
                "<th>" + "Period :</th><th align=left colspan=2>" + Request.QueryString["MonthName"].ToString() + " " + strYear + "</th>" +
                "<th>Branch :</th><th align=left colspan=2>" + strBranch + "</th>" +
                "<th>Item :</th><th align=left colspan=2>" + strItem + "</th>" +
                "<th>Run By :</th><th align=left colspan=3>" + Session["UserName"].ToString() + "</th>" +
                "<th colspan=1>Run Date :</th><th align=left colspan=2>" + DateTime.Now.ToShortDateString() + "</th></tr>");

        reportWriter.WriteLine("<tr><td colspan=18></td></tr>");

        System.Data.DataTable dtTemp = (System.Data.DataTable)Session["BranchCustomer"];
        dtTemp.DefaultView.Sort = hidSortField.Value;
        System.Data.DataTable dt1 = dtTemp.DefaultView.ToTable();
        string lineHeading = string.Empty;

        string strYearNew = ((Convert.ToInt32(Request.QueryString["Month"].ToString()) <= 08) ? Request.QueryString["Year"].ToString().Trim() :
                    Convert.ToString(Convert.ToInt16(Request.QueryString["Year"].ToString().Trim()) + 1));

        string strYearDis = "'" + strYearNew.Substring(2);
        string strPreYearDis = "'" + (Convert.ToInt16(strYearNew) - 1).ToString().Substring(2);


        reportWriter.WriteLine("<tr>" + "<th align=left>" + "Cust #" + "</th>" +
                                "<th align=left>" + "Name" + "</th>" +
                                "<th align=left>" + "City" + "</th>" +
                                "<th align=left>" + "Brn" + "</th>" +
                                "<th align=left>" + "Chain" + "</th>" +
                                "<th align=right>" + strYearDis + " Sales" + "</th>" +
                                "<th align=right>" + strPreYearDis + " Sales" + "</th>" +
                                "<th align=right>" + strYearDis + " GM$" + "</th>" +
                                "<th align=right>" + strYearDis + " GM%" + "</th>" +
                                "<th align=right>" + strPreYearDis + " GM$" + "</th>" +
                                "<th align=right>" + strPreYearDis + " GM%" + "</th>" +
                                "<th align=right>" + strYearDis + " Wgt" + "</th>" +
                                "<th align=right>" + strYearDis + " $/Lb" + "</th>" +
                                "<th align=right>" + strPreYearDis + " Wgt" + "</th>" +
                                "<th align=right>" + strPreYearDis + " $/Lb" + "</th>" +
                                "<th align=right>" + "Rep" + "</th>" +
                                "<th align=right>" + "Group" + "</th>" + "<th>" + "Zip" + "</th>" + "</tr>");

        try
        {
            foreach (DataRow drow in dt1.Rows)
            {
                string lineContent = string.Empty;
                for (int i = 0; i <= 27; i++)
                {
                    if ( i != 15 && i != 16 && i != 17 && i != 18 && i != 19 && i != 20 && i != 21 && i != 22 && i != 23 && i != 24)
                        lineContent +=((i == 4) ?
                            "<td align=left>" + drow[i].ToString() + "</td>": "<td>" + ((i <= 5 || i == 8 || i == 10 || i == 12 || i == 14 || i == 18 || i == 20 || i == 22 || i >= 24) ? drow[i].ToString() : ((drow[i].ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(((drow[i].ToString() != "") ? drow[i] : 0))) : "0")) + "</td>");
                }
                reportWriter.WriteLine("<tr>" + lineContent.ToString() + "</tr>");
            }

            System.Data.DataTable dtTotal = (System.Data.DataTable)Session["dtBranchCustomerSalesGrandTotal"];
            foreach (DataRow drow in dtTotal.Rows)
            {
                string lineContent = string.Empty;
                lineContent = "<th colspan=5 align=right>GrandTotal</th>";
                for (int i = 5; i <= 26; i++)
                {
                    if ( i != 15 && i != 16 && i != 17 && i != 18 && i != 19 && i != 20 && i != 21 && i != 22 && i != 23 && i != 24)
                        lineContent += ((i == 8 || i == 10 || i == 12 || i == 14 || i == 18 || i == 20 || i == 22 || i >= 24) ? "<th align=right>" + (drow[i] == null ? "" : drow[i].ToString()) + "</th>" : "<th align=right>" + ((drow[i].ToString() != "0") ? String.Format("{0:#,###}", Convert.ToDecimal(((drow[i].ToString() != "") ? drow[i] : 0))) : "0")) + "</th>";
                }
                reportWriter.WriteLine("<tr align=right>" + lineContent.ToString() + "<th></th></tr>");
            }

            reportWriter.WriteLine("</table>");

            reportWriter.Close();

            
        }
        catch (Exception ex)
        {
            reportWriter.Close();
            
        }
    }
        
    #endregion

    #region short & Long Version 

    public void ChangeFormat()
    {
    
        bool version1 = ((strVersion == "long" && strPeriod == "ytd") || (strVersion == "long" && strPeriod == "mtd")) ? true : false;
        dgAnalysis.Columns[7].Visible  = version1;
        dgAnalysis.Columns[9].Visible  = version1;
        dgAnalysis.Columns[11].Visible = version1;
        dgAnalysis.Columns[13].Visible = version1;

        bool version = (strVersion == "long" && strPeriod=="ytd") ? true : false;
        dgAnalysis.Columns[17].Visible = version;
        dgAnalysis.Columns[19].Visible = version;
        dgAnalysis.Columns[21].Visible = version;
        dgAnalysis.Columns[23].Visible = version;


        bool period = (strPeriod == "ytd") ? true : false;
        dgAnalysis.Columns[15].Visible =period ;
        dgAnalysis.Columns[16].Visible = period;
        dgAnalysis.Columns[18].Visible = period;
        dgAnalysis.Columns[20].Visible = period;
        dgAnalysis.Columns[22].Visible = period;
        dgAnalysis.Columns[24].Visible = period;

        dgAnalysis.Width = (strPeriod == "ytd" && strVersion=="long") 
                            ? 1700 :
                            ((strPeriod == "ytd" && strVersion == "short") ? 1600 : 1000);

        BindDataToGrid();
    }

    
    #endregion

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
