/********************************************************************************************
 * File	Name			:	CategoryTrendAnalysis.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Retrive Data From Curvalsum Table - Customerwise.
 * Created By			:	Senthilkumar
 * Created Date			:	08/07/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/12/2005		    Version 1		Mahesh      		Created 
 * 09/20/2006           Version 2		Mahesh      		Implemented Ajax To Delete Excel Files on Page Unload & Comments Added
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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
using PFC.Intranet.Utility;
using System.IO;

public partial class CategoryTrendAnalysis : System.Web.UI.Page
{
    Utility utility = new Utility();
    SqlConnection cn = new SqlConnection(PFC.Intranet.Global.ReportsConnectionString);
    SqlCommand cmd;
    DataTable dt = new DataTable();
    DataTable dtReport = new DataTable();
    string strStartDate = string.Empty;
    string strEndDate = string.Empty;
    string strBranch = string.Empty;
    string strCatFrom = string.Empty;
    string strCatTo = string.Empty;
    string strVarianceFrom = string.Empty;
    string strVarianceTo = string.Empty;
    string strCategory = string.Empty;
    string strFiscalMonth = string.Empty;
    string strFiscalYear = string.Empty;
    string strSalesRep = string.Empty;
    System.IO.FileStream fStream;
    
    // New 
    string strStartMonth = string.Empty;
    string strStartYear = string.Empty;
    string strEndMonth = string.Empty;
    string strEndYear = string.Empty;



    protected void Page_Load(object sender, EventArgs e)
    {

        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(CategoryTrendAnalysis));

        #region Get QueryString Values

        if (Request.QueryString["EndDate"] != null)
        {
            string[] strEnddate = Request.QueryString["EndDate"].ToString().Trim().Split('/');
            strEndMonth = strEnddate[0];
            strEndYear = strEnddate[1];

            string[] strStartdate = Request.QueryString["StDate"].ToString().Trim().Split('/');
            strStartMonth = strStartdate[0];
            strStartYear = strStartdate[1];
        }
        strBranch = (Request.QueryString["BranchID"] != "0") ? Request.QueryString["BranchID"].ToString().Trim() : "";
        strCatFrom = (Request.QueryString["CategoryFrom"] != null) ? Request.QueryString["CategoryFrom"].ToString().Trim() : "";
        strCatTo = (Request.QueryString["CategoryTo"] != null) ? Request.QueryString["CategoryTo"].ToString().Trim() : "";
        strVarianceFrom = (Request.QueryString["VarianceFrom"] != null) ? Request.QueryString["VarianceFrom"].ToString().Trim() : "";
        strVarianceTo = (Request.QueryString["VarianceTo"] != null) ? Request.QueryString["VarianceTo"].ToString().Trim() : "";
        strSalesRep = (Request.QueryString["SalesRep"] != null) ? ((Request.QueryString["SalesRep"].ToString().Trim() != "All") ? Request.QueryString["SalesRep"].ToString().Trim().Replace("|", "'") : "") : "";

        #endregion

        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");
        ViewState["ExcelFileName"] = "CategoryTrendAnalysis" + Session["SessionID"].ToString() + name + ".xls";

        if (!IsPostBack)
        {
            hidVersion.Value = "long";
            GetData();
            BindDataToGrid();
        }
        dtReport = (DataTable)Session["dtReport"];
        dt = (DataTable)Session["dt"];

    }

    public void GetData()
    {
        try
        {
            // Code to execute the stored procedure
            DataSet dsUserInfo = new DataSet();
            SqlConnection conn = new SqlConnection(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString());
            SqlDataAdapter adp;
            SqlCommand Cmd = new SqlCommand();
            Cmd.CommandTimeout = 0;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Connection = conn;
            conn.Open();
            Cmd.CommandText = "PFC_RPT_SP_CategoryTrendAnalysis";
            Cmd.Parameters.Add(new SqlParameter("@FromMonth", strStartMonth));
            Cmd.Parameters.Add(new SqlParameter("@FromYear", strStartYear));
            Cmd.Parameters.Add(new SqlParameter("@ToMonth", strEndMonth));
            Cmd.Parameters.Add(new SqlParameter("@ToYear", strEndYear));
            Cmd.Parameters.Add(new SqlParameter("@branch", strBranch));
            Cmd.Parameters.Add(new SqlParameter("@CatFrom", strCatFrom));
            Cmd.Parameters.Add(new SqlParameter("@CatTo", strCatTo));
            Cmd.Parameters.Add(new SqlParameter("@VarianceFrom", strVarianceFrom));
            Cmd.Parameters.Add(new SqlParameter("@VarianceTo", strVarianceTo));
            Cmd.Parameters.Add(new SqlParameter("@salesRep", strSalesRep.Replace("'","''")));
            adp = new SqlDataAdapter(Cmd);
            adp.Fill(dsUserInfo);


            // Clear the datatables
            dt.Clear(); 
            dtReport.Clear();
            
            // Store the data's in the datatable
            dt = dsUserInfo.Tables[0];
            dtReport = dsUserInfo.Tables[1];

            // Store the datatable in the session variables
            Session["dt"] = dt;
            Session["dtReport"] = dtReport;
        }
        catch (Exception ex) { Response.Write(ex.Message); }
    }

    public void BindDataToGrid()
    {
        try
        {
            ExcelExport();
            utility.CheckBrowserCompatibility(Request, dgReport);
            dgReport.DataSource = dtReport;
            Pager1.InitPager(dgReport, 2);
            tdGrid.Visible = (dgReport.Items.Count < 1) ? false : true;
            lblMsg.Visible = (dgReport.Items.Count < 1) ? true : false;
            tdPager.Visible = (dgReport.Items.Count < 1) ? false : true;

            foreach (DataGridItem dgItem in dgReport.Items)
            {
                Label lblCategory = dgItem.FindControl("lblCategory") as Label;
                Label lblVariance = dgItem.FindControl("lblVariance") as Label;
                Label lblPlating = dgItem.FindControl("lblPlating") as Label;
                Label lblPlatingDescription = dgItem.FindControl("lblPlatingDescription") as Label;
                Label lblFiscalMonth = dgItem.FindControl("FiscalMonth") as Label;
                Label lblFiscalYear = dgItem.FindControl("FiscalYear") as Label;
                Label lblMessage = dgItem.FindControl("lblMessage") as Label;
                DataGrid dgData = dgItem.FindControl("dgAnalysis") as DataGrid;
                utility.CheckBrowserCompatibility(Request, dgData);
                // to pass parameter in get url function
                strCategory = lblCategory.Text;

                try
                {
                    dt.DefaultView.RowFilter = "Category=" + lblCategory.Text + " and Plating='" + lblPlating.Text + "' and PlatingDescription='" + lblPlatingDescription.Text + "' and Variance='" + lblVariance.Text + "'";
                    string sortExpression = ((hidSort.Value != "") ? " " + hidSort.Value : "");
                    dt.DefaultView.Sort = sortExpression;
                    dgData.DataSource = dt.DefaultView;
                    dgData.DataBind();
                    dgData.Columns[6].Visible = (rdoReportVersion1.Checked == true) ? true : false;
                    dgData.Columns[9].Visible = (rdoReportVersion1.Checked == true) ? true : false;
                    dgData.Width = (rdoReportVersion1.Checked) ? 815 : 650;
                    
                    
                }
                catch (Exception ex) { }
                lblMessage.Visible = (dgData.Items.Count >= 1) ? false : true;
            }

        }
        catch (Exception ex) { }
    }

    public string GetDescription(object container)
    {
        SqlConnection cnNavision = new SqlConnection(PFC.Intranet.Global.NavisionConnectionString);
        
        try
        {
            if (cnNavision.State.ToString() == "Open") cnNavision.Close();
            cnNavision.Open();
            cmd = new SqlCommand("select Top 1 [Description 2] from [Porteous$Item] where No_ like '" + DataBinder.Eval(container, "DataItem.Category").ToString() + "%' and [Description 2]<>''", cnNavision);
            string strDesc = cmd.ExecuteScalar().ToString();
            cmd.Dispose();
            cnNavision.Close();
            return strDesc;
        }
        catch (Exception ex) { cnNavision.Close(); return ""; }
    }

    public string GetText(object container)
    {
        string strMonth = DataBinder.Eval(container, "DataItem.FiscalMonth").ToString().Trim();
        string strYear = DataBinder.Eval(container, "DataItem.FiscalYear").ToString().Trim();
        strYear = strYear.Remove(strYear.Length - 4, 2);
        switch (strMonth)
        {
            case "1": strMonth = "January"; break;
            case "2": strMonth = "February"; break;
            case "3": strMonth = "March"; break;
            case "4": strMonth = "April"; break;
            case "5": strMonth = "May"; break;
            case "6": strMonth = "June"; break;
            case "7": strMonth = "July"; break;
            case "8": strMonth = "August"; break;
            case "9": strMonth = "September"; break;
            case "10": strMonth = "October"; break;
            case "11": strMonth = "November"; break;
            case "12": strMonth = "December"; break;
        }
        return strMonth + strYear;
    }

    protected void ExcelExport()
    {
        try
        {

            FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + ViewState["ExcelFileName"].ToString()));

            StreamWriter reportWriter;
            reportWriter = fnExcel.CreateText();
            reportWriter.WriteLine("<table border=2px cellpadding=5 cellspacing=5>");
            reportWriter.WriteLine("<tr><td colspan=10  align=center valign=middle><font color=blue size=15px><b>Category Trend Analysis Report</b></font></td></tr>");
            reportWriter.WriteLine("<tr><td colspan=10></td></tr>");

            reportWriter.WriteLine("<tr><th align=left bgcolor=whitesmoke>Category : " + "  " + ((strCatFrom != "" || strCatTo != "") ? Request.QueryString["CategoryFrom"].ToString().Trim() + "-" + Request.QueryString["CategoryTo"].ToString().Trim() : "All") + "</th>" +
                                   "<th align=left bgcolor=whitesmoke>Branch :" + Request.QueryString["Branch"].ToString() + "</th>" +
                                   "<th>Variance :" + (((strVarianceFrom != "") || (strVarianceTo != "")) ? Request.QueryString["VarianceFrom"].ToString().Trim() + "-" + Request.QueryString["VarianceTo"].ToString().Trim() : "All") + "</th>" +
                                   "<th align=left bgcolor=whitesmoke>Period :" + Request.QueryString["Period"].ToString() + "</th></tr>");



            DataTable dtRpt = (DataTable)Session["dtReport"];
            DataTable dt1 = (DataTable)Session["dt"];
            if (rdoReportVersion1.Checked == true)
            {
                foreach (DataRow drow in dtRpt.Rows)
                {

                    reportWriter.WriteLine("<tr><th>Category : " + "  " + drow["Category"].ToString() + "-" + GetDescription(drow["Category"].ToString()) + "</th>" +
                                           "<th colspan=3>Plating :" + drow["Plating"].ToString() + " - " + drow["PlatingDescription"].ToString() + "</th>" +
                                           "<th>Branch :" + Request.QueryString["Branch"].ToString() + "</th>" +
                                           "<th colspan=3>Variance :" + (((strVarianceFrom != "") || (strVarianceTo != "")) ? Request.QueryString["VarianceFrom"].ToString().Trim() + "-" + Request.QueryString["VarianceTo"].ToString().Trim() : "All") + "</th><th></th><th></th></tr>");

                    reportWriter.WriteLine("<tr><td colspan=10></td></tr>");
                    dt1.DefaultView.RowFilter = "Category='" + drow["Category"].ToString() + "' and Plating='" + drow["Plating"].ToString() + "' and PlatingDescription='" + drow["PlatingDescription"].ToString() + "'"; ;
                    dt1.DefaultView.Sort = hidSort.Value;
                    DataTable dtData = dt1.DefaultView.ToTable();

                    reportWriter.WriteLine("<tr><th font =arial size = 8pt>" + " Period" + "</th>" +
                    "<th>" + "Qty" + "</th>" +
                    "<th>" + "Sales" + "</th>" +
                    "<th>" + "Cost" + "</th>" +
                    "<th>" + "GM%" + "</th>" +
                    "<th>" + "% of Tot Sales" + "</th>" +
                    "<th>" + "Ext Wgt" + "</th>" +
                    "<th>" + "Sell $/Lb" + "</th>" +
                    "<th>" + "Cost $/Lb" + "</th>" +
                    "<th>" + "GM $/Lb" + "</th></tr>");

                    foreach (DataRow drow1 in dtData.Rows)
                    {
                        string strPeriod = GetPeriod(drow1["FiscalMonth"].ToString(), drow1["FiscalYear"].ToString());

                        reportWriter.WriteLine("<tr><td align='left'>" + strPeriod + "</td>" +
                                               "<td>" + drow1["Qty"].ToString() + "</td>" +
                                               "<td>" + String.Format("{0:#,###}", Convert.ToDecimal(((drow1["Sales"].ToString() != "") ? drow1["Sales"] : 0))) + "</td>" +
                                               "<td>" + String.Format("{0:#,###}", Convert.ToDecimal(((drow1["Cost"].ToString() != "") ? drow1["Cost"] : 0))) + "</td>" +
                                               "<td>" + String.Format("{0:0.0}", Convert.ToDecimal(((drow1["GM"].ToString() != "") ? drow1["GM"] : 0))) + "</td>" +
                                                "<td>" + drow1["Totsales"].ToString() + "</td>" +
                                                "<td>" + String.Format("{0:#,###}", Convert.ToDecimal(((drow1["ExtWgt"].ToString() != "") ? drow1["ExtWgt"] : 0))) + "</td>" +
                                                "<td>" + drow1["SellLb"].ToString() + "</td>" +
                                                "<td>" + drow1["CostLb"].ToString() + "</td>" +
                                                "<td>" + drow1["GMLb"].ToString() + "</td></tr>");
                    }
                    reportWriter.WriteLine("<tr><td colspan=8></td></tr>");
                }
            }
            else
            {
                foreach (DataRow drow in dtRpt.Rows)
                {

                    reportWriter.WriteLine("<tr><th>Category : " + "  " + drow["Category"].ToString() + "-" + GetDescription(drow["Category"].ToString()) + "</th>" +
                                           "<th colspan=2>Plating :" + drow["Plating"].ToString() + " - " + drow["PlatingDescription"].ToString() + "</th>" +
                                           "<th>Branch :" + Request.QueryString["Branch"].ToString() + "</th>" +
                                           "<th colspan=2>Variance :" + (((strVarianceFrom != "") || (strVarianceTo != "")) ? Request.QueryString["VarianceFrom"].ToString().Trim() + "-" + Request.QueryString["VarianceTo"].ToString().Trim() : "All") + "</th><th></th><th></th></tr>");

                    reportWriter.WriteLine("<tr><td colspan=8></td></tr>");
                    dt1.DefaultView.RowFilter = "Category='" + drow["Category"].ToString() + "' and Plating='" + drow["Plating"].ToString() + "' and PlatingDescription='" + drow["PlatingDescription"].ToString() + "'"; ;
                    dt1.DefaultView.Sort = hidSort.Value;
                    DataTable dtData = dt1.DefaultView.ToTable();

                    reportWriter.WriteLine("<tr><th font =arial size = 8pt>" + " Period" + "</th>" +
                    "<th>" + "Qty" + "</th>" +
                    "<th>" + "Sales" + "</th>" +
                    "<th>" + "Cost" + "</th>" +
                    "<th>" + "GM%" + "</th>" +
                    "<th>" + "% of Tot Sales" + "</th>" +
                    "<th>" + "Sell $/Lb" + "</th>" +
                    "<th>" + "Cost $/Lb" + "</th>" +
                    "</tr>");

                    foreach (DataRow drow1 in dtData.Rows)
                    {
                        string strPeriod = GetPeriod(drow1["FiscalMonth"].ToString(), drow1["FiscalYear"].ToString());

                        reportWriter.WriteLine("<tr><td align='left'>" + strPeriod + "</td>" +
                                               "<td>" + drow1["Qty"].ToString() + "</td>" +
                                               "<td>" + String.Format("{0:#,###}", Convert.ToDecimal(((drow1["Sales"].ToString() != "") ? drow1["Sales"] : 0))) + "</td>" +
                                               "<td>" + String.Format("{0:#,###}", Convert.ToDecimal(((drow1["Cost"].ToString() != "") ? drow1["Cost"] : 0))) + "</td>" +
                                                "<td>" + String.Format("{0:0.0}", Convert.ToDecimal(((drow1["GM"].ToString() != "") ? drow1["GM"] : 0))) + "</td>" +
                                                "<td>" + drow1["Totsales"].ToString() + "</td>" +
                                                "<td>" + drow1["SellLb"].ToString() + "</td>" +
                                                "<td>" + drow1["CostLb"].ToString() + "</td>" +
                                                "</tr>");
                    }
                    reportWriter.WriteLine("<tr><td colspan=8></td></tr>");
                    reportWriter.WriteLine("");
                }
            }

            reportWriter.WriteLine("</table>");
            reportWriter.Close();

        }
        catch (Exception ex) { }


    }

   
    public string GetPeriod(string strMonth, string strYear)
    {
        switch (strMonth)
        {
            case "1": strMonth = "January"; break;
            case "2": strMonth = "February"; break;
            case "3": strMonth = "March"; break;
            case "4": strMonth = "April"; break;
            case "5": strMonth = "May"; break;
            case "6": strMonth = "June"; break;
            case "7": strMonth = "July"; break;
            case "8": strMonth = "August"; break;
            case "9": strMonth = "September"; break;
            case "10": strMonth = "October"; break;
            case "11": strMonth = "November"; break;
            case "12": strMonth = "December"; break;
        }
        return strMonth + "-" + strYear;

    }

    public string GetDescription(string category)
    {
        SqlConnection cnNavision = new SqlConnection(PFC.Intranet.Global.NavisionConnectionString);
        
        try
        {
            if (cnNavision.State.ToString() == "Open") cnNavision.Close();
            cnNavision.Open();
            cmd = new SqlCommand("select Top 1 [Description 2] from  [Porteous$Item] where No_ like '" + category + "%' and [Description 2]<>''", cnNavision);
            string strDesc = cmd.ExecuteScalar().ToString();
            cmd.Dispose();
            cnNavision.Close();
            return strDesc;
        }
        catch (Exception ex) { cnNavision.Close(); return ""; }
    }

    protected void dgAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {

        e.Item.HorizontalAlign = HorizontalAlign.Right;
        e.Item.Width = 150;
        e.Item.Cells[0].HorizontalAlign = HorizontalAlign.Left;

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            e.Item.Cells[0].CssClass = "GridItemLink";
            HyperLink hpl = e.Item.Cells[0].Controls[1] as HyperLink;
            hpl.Attributes.Add("onclick", "window.open(this.href, 'popupwindow', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES'); return false;");
        }

    }

    /// <summary>
    /// Function used to change the pager index when user change the grid pager controls
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    /// <remarks></remarks>
    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgReport.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataToGrid();
    }

    /// <summary>
    /// Function used to change the pager index when user change the grid pager controls
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    /// <remarks></remarks>
    protected void dgReport_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgReport.CurrentPageIndex = e.NewPageIndex;
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

    public string GetUrl(object container)
    {
        string url = string.Empty;

        string strMonth1 = DataBinder.Eval(container, "DataItem.FiscalMonth").ToString().Trim();
        string strYear1 = DataBinder.Eval(container, "DataItem.FiscalYear").ToString().Trim();
        string category = DataBinder.Eval(container, "DataItem.Category").ToString().Trim();
        strYear1 = strYear1.Remove(strYear1.Length - 4, 2);

        // Code to display progress bar on page load
        string[] strDateMonth = Request.QueryString["StDate"].ToString().Trim().Split('/');
        string strMonth = GetPeriod(strDateMonth[0].ToString(), strDateMonth[1].ToString());
        string[] month = strMonth.Split('-');
        url = "BranchItemSalesAnalysis.aspx?Month=" + strMonth1.ToString() + "~Year=" + DataBinder.Eval(container, "DataItem.FiscalYear").ToString().Trim() + "~Branch=" + strBranch + "~MonthName=" + month[0].ToString() + "~BranchName=" + Request.QueryString["BranchName"].ToString() +
             "~CategoryFrom=" + category + "~CategoryTo=" + string.Empty + "~VarianceFrom=" + strVarianceFrom + "~VarianceTo=" + strVarianceTo + "~Version=" + ((rdoReportVersion1.Checked) ? "long" : "short");
        url = "ProgressBar.aspx?destPage=" + url;

        //url = "javascript:window.open('"+url+"', 'popupwindow', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES'); return false;";
        return url;

    }

    protected void rdoReportVersion1_CheckedChanged(Object sender, System.EventArgs e)
    {
        hidVersion.Value = "long";
        ExcelExport();
        BindDataToGrid();
    }

    protected void rdoReportVersion2_CheckedChanged(Object sender, System.EventArgs e)
    {
        hidVersion.Value="short";
        ExcelExport();
        BindDataToGrid();
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
        BindDataToGrid();
    }

    protected string GetFileURL()
    {
        string url = "../Common/ExcelUploads/" + ViewState["ExcelFileName"].ToString();
        return url;
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
