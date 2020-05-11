
/********************************************************************************************
 * File	Name			:	CategorySalesAnalysis.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Retrive Data From Curvalsum Table - Categorywise.
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
using System.IO;

public partial class CategorySalesAnalysis : System.Web.UI.Page
{
    SqlConnection cn = new SqlConnection(PFC.Intranet.Global.ReportsConnectionString);
    SqlCommand cmd;

    DataTable dtCategorySales = new DataTable();
    DataTable dt2 = new DataTable();
    DataTable dtReportCategorySales = new DataTable();
    DataTable temp = new DataTable();


    #region QueryString Variable Declaration

    string strYear = string.Empty;
    string strMonth = string.Empty;
    string strCatFrom = string.Empty;
    string strCatTo = string.Empty;
    string strVarianceFrom = string.Empty;
    string strVarianceTo = string.Empty;
    string strPreYear = string.Empty;
    bool isGrandTotal = false;
    System.IO.FileStream fStream;

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        #region Get QueryString Values

        strYear = Request.QueryString["Year"].ToString();
        strMonth = Request.QueryString["Month"].ToString();
        strCatFrom = (Request.QueryString["CategoryFrom"] != null) ? Request.QueryString["CategoryFrom"].ToString().Trim() : "";
        strCatTo = (Request.QueryString["CategoryTo"] != null) ? Request.QueryString["CategoryTo"].ToString().Trim() : "";
        strVarianceFrom = (Request.QueryString["VarianceFrom"] != null) ? Request.QueryString["VarianceFrom"].ToString().Trim() : "";
        strVarianceTo = (Request.QueryString["VarianceTo"] != null) ? Request.QueryString["VarianceTo"].ToString().Trim() : "";
        strPreYear = Convert.ToString((Convert.ToInt32(strYear) - 1));

        #endregion

        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(CategorySalesAnalysis));

        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");
        ViewState["ExcelFileName"] = "CategorySalesAnalysis" + Session["SessionID"].ToString() + name + ".xls";

        if (!IsPostBack)
        {
            hidPeriod.Value = "ytd";
            hidVersion.Value = "long";
            GetData();
            BindDataToGrid();
        }
    }

    #region Function to Get the informations in the Data Table

    public void GetData()
    {
        DataSet dsUserInfo1 = new DataSet();
        using (SqlConnection conn = new SqlConnection(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString()))
        {
            SqlDataAdapter adp;
            SqlCommand Cmd = new SqlCommand();
            Cmd.CommandTimeout = 0;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Connection = conn;
            conn.Open();
            Cmd.CommandText = "[PFC_RPT_SP_CategorySalesAnalysis]";
            Cmd.Parameters.Add(new SqlParameter("@PeriodMonth", strMonth));
            Cmd.Parameters.Add(new SqlParameter("@PeriodYear", strYear));
            Cmd.Parameters.Add(new SqlParameter("@CatFrom", strCatFrom));
            Cmd.Parameters.Add(new SqlParameter("@CatTo", strCatTo));
            Cmd.Parameters.Add(new SqlParameter("@VarianceFrom", strVarianceFrom));
            Cmd.Parameters.Add(new SqlParameter("@VarianceTo", strVarianceTo));
            adp = new SqlDataAdapter(Cmd);
            adp.Fill(dsUserInfo1);
            dtReportCategorySales = dsUserInfo1.Tables[1];
        }

        try
        {
            if (dtReportCategorySales.Rows.Count > 0 || dtReportCategorySales != null)
            {
                DataRow drow = dtReportCategorySales.NewRow();
                drow[0] = "Grand Total";
                dtReportCategorySales.Rows.Add(drow);
                Session["dtReportCategorySales"] = dtReportCategorySales;

                dtCategorySales.Clear();
                dtCategorySales = dsUserInfo1.Tables[0];

                // Function to get the GrandTotal
                if (dtReportCategorySales.Rows.Count > 0)
                    GetGrandTotal();

                Session["dtCategorySales"] = dtCategorySales;
            }
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message.ToString());
        }
    }

    #endregion

    #region Function To Bind The Data in The Grid

    public void BindDataToGrid()
    {
        try
        {
            RestoreSession();
            if (dtReportCategorySales != null)
            {
                
                ExcelExport();
                dgReport.DataSource = dtReportCategorySales;
                Pager1.InitPager(dgReport, 1);
                tdGrid.Visible = (dgReport.Items.Count < 1) ? false : true;
                lblMsg.Visible = (dgReport.Items.Count < 1) ? true : false;
                tdPager.Visible = (dgReport.Items.Count < 1) ? false : true;

                #region Code to Bind The inner DataGrid

                foreach (DataGridItem dgItem in dgReport.Items)
                {
                    Label lblCategory = dgItem.FindControl("lblCategory") as Label;
                    DataGrid dgAnalysis = dgItem.FindControl("dgAnalysis") as DataGrid;
                    Label lblHead = dgItem.FindControl("lblHead") as Label;
                    lblCategory.Visible = (lblCategory.Text != "Grand Total") ? true : false;
                    isGrandTotal = (lblCategory.Text != "Grand Total") ? false : true;
                    lblHead.Visible = (lblCategory.Text != "Grand Total") ? true : false;
                    BindDataGridHeader(dgAnalysis);
                    //dtCategorySales.DefaultView.RowFilter = "Category='" + lblCategory.Text + "' and Brn in ("";
                    dtCategorySales.DefaultView.RowFilter = "Category='" + lblCategory.Text + "' and Brn in (" + Session["AuthorizedBranch"] + ",'Grand Total')";
                    string sortExpression = ((hidSort.Value != "") ? " " + hidSort.Value : "");
                    dtCategorySales.DefaultView.Sort = sortExpression;
                    BindCurrentTotal();
                    dgAnalysis.DataSource = dtCategorySales.DefaultView;
                    dgAnalysis.DataBind();
                    dgAnalysis.Width = (rdoDate2.Checked && rdoReportVersion1.Checked) ? 980 :
                        (rdoDate2.Checked && rdoReportVersion2.Checked) ? 980 : (rdoDate1.Checked && rdoReportVersion1.Checked) ? 350 : 300;
                }

                #endregion
            }
            else
            {
                tdGrid.Visible = false ;
                lblMsg.Visible = true ;
                tdPager.Visible = false;
            }
        }
        catch (Exception ex) {
                   }
    }

    #endregion

    #region Function To Bind The Current Total in The Footer
    public void BindCurrentTotal()
    {
        try
        {
            temp = dtCategorySales.DefaultView.ToTable();
            temp.Clear();
            DataRow drow = temp.NewRow();
            drow[0] = "Tot";
            drow[1] = "Grand Total";
            drow[2] = dtCategorySales.DefaultView.ToTable().Compute("sum(CM_YYSales)", "").ToString();
            drow[3] = Convert.ToString(Math.Round(Convert.ToDecimal(dtCategorySales.DefaultView.ToTable().Compute("Avg(CM_GMPer)", "")), 1));
            drow[4] = Convert.ToString(Math.Round(Convert.ToDecimal(dtCategorySales.DefaultView.ToTable().Compute("Avg(CM_Total)", "")), 1));
            drow[5] = Convert.ToString(Math.Round(Convert.ToDecimal(dtCategorySales.DefaultView.ToTable().Compute("Avg(CM_LB)", "")), 2));
            drow[6] = Convert.ToString(Math.Round(Convert.ToDecimal(dtCategorySales.DefaultView.ToTable().Compute("Avg(CM_GMLB)", "")), 2));
            drow[7] = dtCategorySales.DefaultView.ToTable().Compute("sum(CY_YYSales)", "").ToString();
            drow[8] = Convert.ToString(Math.Round(Convert.ToDecimal(dtCategorySales.DefaultView.ToTable().Compute("Avg(CY_GMPer)", "")), 1));
            drow[9] = Convert.ToString(Math.Round(Convert.ToDecimal(dtCategorySales.DefaultView.ToTable().Compute("Avg(CY_Tot)", "")), 1));
            drow[10] = Convert.ToString(Math.Round(Convert.ToDecimal(dtCategorySales.DefaultView.ToTable().Compute("Avg(CY_LB)", "")), 2));
            drow[11] = Convert.ToString(Math.Round(Convert.ToDecimal(dtCategorySales.DefaultView.ToTable().Compute("Avg(CY_GMLB)", "")), 2));
            drow[12] = dtCategorySales.DefaultView.ToTable().Compute("sum(PY_YYSales)", "").ToString();
            drow[13] = Convert.ToString(Math.Round(Convert.ToDecimal(dtCategorySales.DefaultView.ToTable().Compute("Avg(PY_GMPer)", "")), 1));
            drow[14] = Convert.ToString(Math.Round(Convert.ToDecimal(dtCategorySales.DefaultView.ToTable().Compute("Avg(PY_Total)", "")), 1));
            drow[15] = Convert.ToString(Math.Round(Convert.ToDecimal(dtCategorySales.DefaultView.ToTable().Compute("Avg(PY_LB)", "")), 2));
            drow[16] = Convert.ToString(Math.Round(Convert.ToDecimal(dtCategorySales.DefaultView.ToTable().Compute("Avg(PY_GMLB)", "")), 2));
            temp.Rows.Add(drow);
        }
        catch (Exception ex) { }
    }
    #endregion

    #region Bind the GrandTotal in the DataGrid

    public void GetGrandTotal()
    {
        DataTable dtTotal = new DataTable();
        dtCategorySales.DefaultView.RowFilter = " Brn in (" + Session["AuthorizedBranch"] + ")";
        dtTotal = dtCategorySales.DefaultView.ToTable();

        DataRow dr = dtCategorySales.NewRow();
        dr[0] = "Grand Total";
        dr[1] = "Grand Total";
        dr[2] = dtTotal.Compute("sum(CM_YYSales)", "").ToString();
        dr[3] = Convert.ToString(Math.Round(Convert.ToDecimal(dtTotal.Compute("Avg(CM_GMPer)", "")), 1));
        dr[4] = Convert.ToString(Math.Round(Convert.ToDecimal(dtTotal.Compute("Avg(CM_Total)", "")), 1));
        dr[5] = Convert.ToString(Math.Round(Convert.ToDecimal(dtTotal.Compute("Avg(CM_LB)", "")), 2));
        dr[6] = Convert.ToString(Math.Round(Convert.ToDecimal(dtTotal.Compute("Avg(CM_GMLB)", "")), 2));
        dr[7] = dtTotal.Compute("sum(CY_YYSales)", "").ToString();
        dr[8] = Convert.ToString(Math.Round(Convert.ToDecimal(dtTotal.Compute("Avg(CY_GMPer)", "")), 1));
        dr[9] = Convert.ToString(Math.Round(Convert.ToDecimal(dtTotal.Compute("Avg(CY_Tot)", "")), 1));
        dr[10] = Convert.ToString(Math.Round(Convert.ToDecimal(dtTotal.Compute("Avg(CY_LB)", "")), 2));
        dr[11] = Convert.ToString(Math.Round(Convert.ToDecimal(dtTotal.Compute("Avg(CY_GMLB)", "")), 2));
        dr[12] = dtTotal.Compute("sum(PY_YYSales)", "").ToString();
        dr[13] = Convert.ToString(Math.Round(Convert.ToDecimal(dtTotal.Compute("Avg(PY_GMPer)", "")), 1));
        dr[14] = Convert.ToString(Math.Round(Convert.ToDecimal(dtTotal.Compute("Avg(PY_Total)", "")), 1));
        dr[15] = Convert.ToString(Math.Round(Convert.ToDecimal(dtTotal.Compute("Avg(PY_LB)", "")), 2));
        dr[16] = Convert.ToString(Math.Round(Convert.ToDecimal(dtTotal.Compute("Avg(PY_GMLB)", "")), 2));
        dtCategorySales.Rows.Add(dr);
        Session["dtCategorySales"] = dtCategorySales;
    }

    #endregion

    protected string GetFileURL()
    {
        string url = "../Common/ExcelUploads/" + ViewState["ExcelFileName"].ToString();
        return url;
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

    #region Event To Export The Data To Excel

    protected void ExcelExport()
    {
        try
        {
            string strCurYear = ((Convert.ToInt16(strMonth) <= 8) ? strYear : Convert.ToString(Convert.ToInt32(strYear) + 1));
            string strPreviousYear = Convert.ToString(Convert.ToInt32(strCurYear) - 1);

            //
            // Restore Session values on button click to rebind the grid
            //
            RestoreSession();
            DataTable dtRpt = (DataTable)Session["dtReportCategorySales"];
            DataTable dt = (DataTable)Session["dtCategorySales"];

            #region CreateFile

            FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + ViewState["ExcelFileName"].ToString()));
            StreamWriter reportWriter;
            reportWriter = fnExcel.CreateText();

            #endregion

            #region YTDLongVersion

            if (rdoReportVersion1.Checked && rdoDate2.Checked)
            {

                reportWriter.WriteLine("<table cellpadding=5 cellspacing=5 border=2px>");
                reportWriter.WriteLine("<tr><td colspan=16 align=center><font color=blue size=15px><b>Category Sales Analysis Report</b></font></td></tr>");
                reportWriter.WriteLine("<tr><td colspan=16></td></tr>");
                reportWriter.WriteLine("<tr>" +
                                        "<th align=left>Category  :</th>" +
                                        "<th colspan=3 align=left>" + ((strCatFrom != "" || strCatTo != "") ? Request.QueryString["CategoryFrom"].ToString().Trim() + "-" + Request.QueryString["CategoryTo"].ToString().Trim() : "All") + "</th> " +
                                   "<th align=left>Variance :</th>" +
                                   "<th colspan=3>" + (((strVarianceFrom != "") || (strVarianceTo != "")) ? Request.QueryString["VarianceFrom"].ToString().Trim() + "-" + Request.QueryString["VarianceTo"].ToString().Trim() : "All") + "</th>" +
                                   "<th align=left>" + "Month Year :" + "</th>" +
                                   "<th colspan=3 align=left>" + Request.QueryString["Period"].ToString().Trim() + "</th>" +
                                   "<th align=left> Run Date :</th><th colspan=3>" + DateTime.Now.ToShortDateString() + "</th></tr>");

                reportWriter.WriteLine("<tr><td colpan=16></td></tr>");

                foreach (DataRow drow in dtRpt.Rows)
                {
                    isGrandTotal = (drow["Category"].ToString() != "Grand Total" ? false : true);

                    if (isGrandTotal != true)
                        reportWriter.WriteLine("<tr><th>Category : </th><th colspan=15 align=left>" + drow["Category"].ToString() + "  " + GetDescription(drow["Category"].ToString()) + "</th></tr>");

                    dt.DefaultView.RowFilter = "Category='" + drow["Category"].ToString() + "' and Brn in (" + Session["AuthorizedBranch"] + ",'Grand Total')";
                    dt.DefaultView.Sort = hidSort.Value;
                    DataTable dtData = dt.DefaultView.ToTable();

                    reportWriter.WriteLine("<tr align=right>" +
                        "<th>" + ((isGrandTotal != true) ? "Brn" : "") + "</th>" +
                                            "<th>" + strCurYear.Remove(strCurYear.Length - 4, 2) + "Sales </th>" +
                                            "<th>GM% </th>" +
                                            "<th>" + "% of Tot Sales </th>" +
                                            "<th>$/Lb</th>" +
                                            "<th>GM$/Lb </th>" +
                                            "<th>YTD '" + strCurYear.Remove(strCurYear.Length - 4, 2) + "Sales </th>" +
                                            "<th>GM% </th>" +
                                            "<th>YTD '" + strCurYear.Remove(strCurYear.Length - 4, 2) + "% of Tot Sales</th>" +
                                            "<th>$/Lb </th>" +
                                            "<th>GM$/Lb </th>" +
                                            "<th>YTD '" + strPreviousYear.Remove(strPreviousYear.Length - 4, 2) + " Sales</th>" +
                                            "<th>GM%</th>" +
                                            "<th>YTD '" + strPreviousYear.Remove(strPreviousYear.Length - 4, 2) + "% of Tot Sales </th>" +
                                            "<th>$/Lb</th>" +
                                            "<th>GM$/Lb</th></tr>");

                    foreach (DataRow drow1 in dtData.Rows)
                    {
                        reportWriter.WriteLine("<tr align=right>" +
                                     "<td>" + drow1[0].ToString() + "</td>" +
                                     "<td>" + String.Format("{0:#,0}", Convert.ToDecimal((drow1[2].ToString() != "") ? drow1[2] : 0)) + "</td>" +
                                      "<td>" + drow1[3].ToString() + "</td>" +
                                      "<td>" + drow1[4].ToString() + "</td>" +
                                      "<td>" + drow1[5].ToString() + "</td>" +
                                       "<td>" + String.Format("{0:0.00}", Convert.ToDecimal((drow1[6].ToString() != "") ? drow1[6] : 0)) + "</td>" +
                                      "<td>" + String.Format("{0:#,0}", Convert.ToDecimal((drow1[7].ToString() != "") ? drow1[7] : 0)) + "</td>" +
                                      "<td>" + drow1[8].ToString() + "</td>" +
                                      "<td>" + drow1[9].ToString() + "</td>" +
                                      "<td>" + drow1[10].ToString() + "</td>" +
                                       "<td>" + String.Format("{0:0.00}", Convert.ToDecimal((drow1[11].ToString() != "") ? drow1[11] : 0)) + "</td>" +
                                      "<td>" + String.Format("{0:#,0}", Convert.ToDecimal((drow1[12].ToString() != "") ? drow1[12] : 0)) + "</td>" +
                                      "<td>" + drow1[13].ToString() + "</td>" +
                                      "<td>" + drow1[14].ToString() + "</td>" +
                                      "<td>" + drow1[15].ToString() + "</td>" +
                                      "<td>" + String.Format("{0:0.00}", Convert.ToDecimal((drow1[12].ToString() != "") ? drow1[16] : 0)) + "</td></tr>");

                    }

                    #region Code To Bind The Current Total

                    try
                    {
                        string curSum = String.Format("{0:#,0}", Convert.ToDecimal((dtData.Compute("sum(CM_YYSales)", "").ToString() != "") ? dtData.Compute("sum(CM_YYSales)", "") : 0));
                        string curyrSale = String.Format("{0:#,0}", Convert.ToDecimal((dtData.Compute("sum(CY_YYSales)", "").ToString() != "") ? dtData.Compute("sum(CY_YYSales)", "") : 0));
                        string preYrSale = String.Format("{0:#,0}", Convert.ToDecimal((dtData.Compute("sum(PY_YYSales)", "").ToString() != "") ? dtData.Compute("sum(PY_YYSales)", "") : 0));
                        string strFooter = string.Empty;
                        if (isGrandTotal != true)
                        {
                            reportWriter.WriteLine("<tr align=right>" +
                             "<th align=right>Tot </th>" +
                             "<th align=right>" + curSum.ToString() + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(CM_GMPer)", "").ToString() != "") ? dtData.Compute("Avg(CM_GMPer)", "") : 0), 1)) + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(CM_Total)", "").ToString() != "") ? dtData.Compute("Avg(CM_Total)", "") : 0), 1)) + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(CM_LB)", "").ToString() != "") ? dtData.Compute("Avg(CM_LB)", "") : 0), 2)) + "</th>" +
                             "<th align=right>" + String.Format("{0:0.00}", Convert.ToDecimal((dtData.Compute("Avg(CM_GMLB)", "").ToString() != "") ? dtData.Compute("Avg(CM_GMLB)", "") : 0)) + "</th>" +

                             "<th align=right>" + curyrSale + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(CY_GMPer)", "").ToString() != "") ? dtData.Compute("Avg(CY_GMPer)", "") : 0), 1)) + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(CY_Tot)", "").ToString() != "") ? dtData.Compute("Avg(CY_Tot)", "") : 0), 1)) + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(CY_LB)", "").ToString() != "") ? dtData.Compute("Avg(CY_LB)", "") : 0), 2)) + "</th>" +
                             "<th align=right>" + String.Format("{0:0.00}", Convert.ToDecimal((dtData.Compute("Avg(CY_GMLB)", "").ToString() != "") ? dtData.Compute("Avg(CY_GMLB)", "") : 0)) + "</th>" +
                             "<th align=right>" + preYrSale + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(PY_GMPer)", "").ToString() != "") ? dtData.Compute("Avg(PY_GMPer)", "") : 0), 1)) + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(PY_Total)", "").ToString() != "") ? dtData.Compute("Avg(PY_Total)", "") : 0), 1)) + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(PY_LB)", "").ToString() != "") ? dtData.Compute("Avg(PY_LB)", "") : 0), 2)) + "</th>" +
                             "<th align=right>" + String.Format("{0:0.00}", Convert.ToDecimal((dtData.Compute("Avg(PY_GMLB)", "").ToString() != "") ? dtData.Compute("Avg(PY_GMLB)", "") : 0)) + "</th></tr>");
                        }


                    }
                    finally { }

                    #endregion

                    reportWriter.WriteLine("");
                }
            }
            #endregion

            #region YTDShortVersion
            if (rdoReportVersion2.Checked && rdoDate2.Checked)
            {
                reportWriter.WriteLine("<table cellpadding=5 cellspacing=5 border=2px>");
                reportWriter.WriteLine("<tr><td colspan=13 align=center><font color=blue size=15px><b>Category Sales Analysis Report</b></font></td></tr>");
                reportWriter.WriteLine("<tr><td colspan=13></td></tr>");
                reportWriter.WriteLine("<tr align=right>" +
                                        "<th>Category  :</th>" +
                                        "<th colspan=2>" + ((strCatFrom != "" || strCatTo != "") ? Request.QueryString["CategoryFrom"].ToString().Trim() + "-" + Request.QueryString["CategoryTo"].ToString().Trim() : "All") + "</th> " +
                                   "<th>Variance :</th>" +
                                   "<th colspan=2>" + (((strVarianceFrom != "") || (strVarianceTo != "")) ? Request.QueryString["VarianceFrom"].ToString().Trim() + "-" + Request.QueryString["VarianceTo"].ToString().Trim() : "All") + "</th>" +
                                   "<th>" + "Month Year" + "</th>" +
                                   "<th colspan=2>" + Request.QueryString["Period"].ToString().Trim() + "</th>" +
                                   "<th> Run Date :</th><th colspan=3>" + DateTime.Now.ToShortDateString() + "</th></tr>");

                reportWriter.WriteLine("<tr><td colpan=13></td></tr>");


                foreach (DataRow drow in dtRpt.Rows)
                {
                    isGrandTotal = (drow["Category"].ToString() != "Grand Total" ? false : true);

                    if (isGrandTotal != true)
                        reportWriter.WriteLine("<tr><th>Category : </th><th colspan=12 align=left>" + drow["Category"].ToString() + "  " + GetDescription(drow["Category"].ToString()) + "</th></tr>");

                    dt.DefaultView.RowFilter = "Category='" + drow["Category"].ToString() + "' and Brn in (" + Session["AuthorizedBranch"] + ",'Grand Total')";
                    dt.DefaultView.Sort = hidSort.Value;
                    DataTable dtData = dt.DefaultView.ToTable();

                    reportWriter.WriteLine("<tr align=right>" +
                        "<th>" + ((isGrandTotal != true) ? "Brn" : "") + "</th>" +
                                            "<th>" + strYear.Remove(strPreYear.Length - 4, 2) + "Sales </th>" +
                                            "<th>GM% </th>" +
                                            "<th>" + "% of Tot Sales </th>" +
                                            "<th>$/Lb</th>" +
                                            "<th>YTD '" + strCurYear.Remove(strCurYear.Length - 4, 2) + "Sales </th>" +
                                            "<th>GM% </th>" +
                                            "<th>YTD '" + strCurYear.Remove(strCurYear.Length - 4, 2) + "% of Tot Sales</th>" +
                                            "<th>$/Lb </th>" +
                                            "<th>YTD '" + strPreviousYear.Remove(strPreviousYear.Length - 4, 2) + " Sales</th>" +
                                            "<th>GM%</th>" +
                                            "<th>YTD '" + strPreviousYear.Remove(strPreviousYear.Length - 4, 2) + "% of Tot Sales </th>" +
                                            "<th>$/Lb</th>" +
                                            "</tr>");

                    foreach (DataRow drow1 in dtData.Rows)
                    {
                        reportWriter.WriteLine("<tr align=right>" +
                                     "<td>" + drow1[0].ToString() + "</td>" +
                                     "<td>" + String.Format("{0:#,0}", Convert.ToDecimal((drow1[2].ToString() != "") ? drow1[2] : 0)) + "</td>" +
                                      "<td>" + drow1[3].ToString() + "</td>" +
                                      "<td>" + drow1[4].ToString() + "</td>" +
                                      "<td>" + drow1[5].ToString() + "</td>" +
                                      "<td>" + String.Format("{0:#,0}", Convert.ToDecimal((drow1[7].ToString() != "") ? drow1[7] : 0)) + "</td>" +
                                      "<td>" + drow1[8].ToString() + "</td>" +
                                      "<td>" + drow1[9].ToString() + "</td>" +
                                      "<td>" + drow1[10].ToString() + "</td>" +
                                      "<td>" + String.Format("{0:#,0}", Convert.ToDecimal((drow1[12].ToString() != "") ? drow1[12] : 0)) + "</td>" +
                                      "<td>" + drow1[13].ToString() + "</td>" +
                                      "<td>" + drow1[14].ToString() + "</td>" +
                                      "<td>" + drow1[15].ToString() + "</td>" +
                                      "</tr>");

                    }


                    #region Code To Bind The Current Total

                    try
                    {
                        string curSum = String.Format("{0:#,0}", Convert.ToDecimal((dtData.Compute("sum(CM_YYSales)", "").ToString() != "") ? dtData.Compute("sum(CM_YYSales)", "") : 0));
                        string curyrSale = String.Format("{0:#,0}", Convert.ToDecimal((dtData.Compute("sum(CY_YYSales)", "").ToString() != "") ? dtData.Compute("sum(CY_YYSales)", "") : 0));
                        string preYrSale = String.Format("{0:#,0}", Convert.ToDecimal((dtData.Compute("sum(PY_YYSales)", "").ToString() != "") ? dtData.Compute("sum(PY_YYSales)", "") : 0));
                        string strFooter = string.Empty;
                        if (isGrandTotal != true)
                        {
                            reportWriter.WriteLine("<tr align=right>" +
                             "<th align=right>Tot </th>" +
                             "<th align=right>" + curSum.ToString() + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(CM_GMPer)", "").ToString() != "") ? dtData.Compute("Avg(CM_GMPer)", "") : 0), 1)) + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(CM_Total)", "").ToString() != "") ? dtData.Compute("Avg(CM_Total)", "") : 0), 1)) + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(CM_LB)", "").ToString() != "") ? dtData.Compute("Avg(CM_LB)", "") : 0), 2)) + "</th>" +
                             "<th align=right>" + curyrSale + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(CY_GMPer)", "").ToString() != "") ? dtData.Compute("Avg(CY_GMPer)", "") : 0), 1)) + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(CY_Tot)", "").ToString() != "") ? dtData.Compute("Avg(CY_Tot)", "") : 0), 1)) + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(CY_LB)", "").ToString() != "") ? dtData.Compute("Avg(CY_LB)", "") : 0), 2)) + "</th>" +
                             "<th align=right>" + preYrSale + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(PY_GMPer)", "").ToString() != "") ? dtData.Compute("Avg(PY_GMPer)", "") : 0), 1)) + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(PY_Total)", "").ToString() != "") ? dtData.Compute("Avg(PY_Total)", "") : 0), 1)) + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(PY_LB)", "").ToString() != "") ? dtData.Compute("Avg(PY_LB)", "") : 0), 2)) + "</th>" +
                             "</tr>");
                        }


                    }
                    finally { }
                }

                    #endregion
            }
            #endregion

            #region MTDShortVersion
            if (rdoReportVersion2.Checked && rdoDate1.Checked)
            {
                reportWriter.WriteLine("<table cellpadding=5 cellspacing=5 border=2px>");
                reportWriter.WriteLine("<tr><td colspan=5 align=center><font color=blue size=15px><b>Category Sales Analysis Report</b></font></td></tr>");
                reportWriter.WriteLine("<tr><td colspan=5></td></tr>");
                reportWriter.WriteLine("<tr align=right>" +
                                        "<th>Category  :" + ((strCatFrom != "" || strCatTo != "") ? Request.QueryString["CategoryFrom"].ToString().Trim() + "-" + Request.QueryString["CategoryTo"].ToString().Trim() : "All") + "</th> " +
                                   "<th colspan=2>Variance :" + (((strVarianceFrom != "") || (strVarianceTo != "")) ? Request.QueryString["VarianceFrom"].ToString().Trim() + "-" + Request.QueryString["VarianceTo"].ToString().Trim() : "All") + "</th>" +
                                   "<th>" + "Month Year :" + Request.QueryString["Period"].ToString().Trim() + "</th>" +
                                   "<th> Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>");

                reportWriter.WriteLine("<tr><td colpan=5></td></tr>");


                foreach (DataRow drow in dtRpt.Rows)
                {
                    isGrandTotal = (drow["Category"].ToString() != "Grand Total" ? false : true);

                    if (isGrandTotal != true)
                        reportWriter.WriteLine("<tr><th>Category : </th><th colspan=4 align=left>" + drow["Category"].ToString() + "  " + GetDescription(drow["Category"].ToString()) + "</th></tr>");

                    dt.DefaultView.RowFilter = "Category='" + drow["Category"].ToString() + "' and Brn in (" + Session["AuthorizedBranch"] + ",'Grand Total')";
                    dt.DefaultView.Sort = hidSort.Value;
                    DataTable dtData = dt.DefaultView.ToTable();

                    reportWriter.WriteLine("<tr align=right>" +
                        "<th>" + ((isGrandTotal != true) ? "Brn" : "") + "</th>" +
                                            "<th>" + strCurYear.Remove(strCurYear.Length - 4, 2) + "Sales </th>" +
                                            "<th>GM% </th>" +
                                            "<th>" + "% of Tot Sales </th>" +
                                            "<th>$/Lb</th>" +
                                            "</tr>");

                    foreach (DataRow drow1 in dtData.Rows)
                    {
                        reportWriter.WriteLine("<tr align=right>" +
                                    "<td>" + drow1[0].ToString() + "</td>" +
                                     "<td>" + String.Format("{0:#,0}", Convert.ToDecimal((drow1[2].ToString() != "") ? drow1[2] : 0)) + "</td>" +
                                      "<td>" + drow1[3].ToString() + "</td>" +
                                      "<td>" + drow1[4].ToString() + "</td>" +
                                      "<td>" + drow1[5].ToString() + "</td>" +
                                      "</tr>");
                    }


                    #region Code To Bind The Current Total

                    try
                    {
                        string curSum = String.Format("{0:#,0}", Convert.ToDecimal((dtData.Compute("sum(CM_YYSales)", "").ToString() != "") ? dtData.Compute("sum(CM_YYSales)", "") : 0));
                        string curyrSale = String.Format("{0:#,0}", Convert.ToDecimal((dtData.Compute("sum(CY_YYSales)", "").ToString() != "") ? dtData.Compute("sum(CY_YYSales)", "") : 0));
                        string preYrSale = String.Format("{0:#,0}", Convert.ToDecimal((dtData.Compute("sum(PY_YYSales)", "").ToString() != "") ? dtData.Compute("sum(PY_YYSales)", "") : 0));
                        string strFooter = string.Empty;
                        if (isGrandTotal != true)
                        {
                            reportWriter.WriteLine("<tr align=right>" +
                             "<th align=right>Tot </th>" +
                             "<th align=right>" + curSum.ToString() + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(CM_GMPer)", "").ToString() != "") ? dtData.Compute("Avg(CM_GMPer)", "") : 0), 1)) + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(CM_Total)", "").ToString() != "") ? dtData.Compute("Avg(CM_Total)", "") : 0), 1)) + "</th>" +
                             "<th align=right>" + Convert.ToString(Math.Round(Convert.ToDecimal((dtData.Compute("Avg(CM_LB)", "").ToString() != "") ? dtData.Compute("Avg(CM_LB)", "") : 0), 2)) + "</th>" +
                            "</tr>");
                        }


                    }
                    finally { }
                }

                    #endregion
            }
            #endregion

            #region MTDLongVersion

            if (rdoReportVersion1.Checked && rdoDate1.Checked)
            {

                reportWriter.WriteLine("<table cellpadding=5 cellspacing=5 border=2px>");
                reportWriter.WriteLine("<tr><td colspan=6 align=center><font color=blue size=15px><b>Category Sales Analysis Report</b></font></td></tr>");
                reportWriter.WriteLine("<tr><td colspan=6></td></tr>");
                reportWriter.WriteLine("<tr align=right>" +
                                        "<th>Category  :</th>" +
                                        "<th>" + ((strCatFrom != "" || strCatTo != "") ? Request.QueryString["CategoryFrom"].ToString().Trim() + "-" + Request.QueryString["CategoryTo"].ToString().Trim() : "All") + "</th> " +
                                   "<th colspan=2>Variance :" +
                                   (((strVarianceFrom != "") || (strVarianceTo != "")) ? Request.QueryString["VarianceFrom"].ToString().Trim() + "-" + Request.QueryString["VarianceTo"].ToString().Trim() : "All") + "</th>" +
                                   "<th>" + "Month Year" + Request.QueryString["Period"].ToString().Trim() + "</th>" +
                                   "<th> Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>");

                reportWriter.WriteLine("<tr><td colpan=6></td></tr>");

                foreach (DataRow drow in dtRpt.Rows)
                {
                    isGrandTotal = (drow["Category"].ToString() != "Grand Total" ? false : true);

                    if (isGrandTotal != true)
                        reportWriter.WriteLine("<tr><th>Category : </th><th colspan=5 align=left>" + drow["Category"].ToString() + "  " + GetDescription(drow["Category"].ToString()) + "</th></tr>");

                    dt.DefaultView.RowFilter = "Category='" + drow["Category"].ToString() + "' and Brn in (" + Session["AuthorizedBranch"] + ",'Grand Total')";
                    dt.DefaultView.Sort = hidSort.Value;
                    DataTable dtData = dt.DefaultView.ToTable();

                    reportWriter.WriteLine("<tr align=right>" +
                        "<th>" + ((isGrandTotal != true) ? "Brn" : "") + "</th>" +
                                            "<th>" + strCurYear.Remove(strCurYear.Length - 4, 2) + "Sales </th>" +
                                            "<th>GM% </th>" +
                                            "<th>" + "% of Tot Sales </th>" +
                                            "<th>$/Lb</th>" +
                                            "<th>GM$/Lb </th>" +
                                            "</tr>");

                    foreach (DataRow drow1 in dtData.Rows)
                    {
                        reportWriter.WriteLine("<tr align=right>" +
                                     "<td>" + drow1[0].ToString() + "</td>" +
                                     "<td>" + String.Format("{0:#,0}", Convert.ToDecimal((drow1[2].ToString() != "") ? drow1[2] : 0)) + "</td>" +
                                      "<td>" + drow1[3].ToString() + "</td>" +
                                      "<td>" + drow1[4].ToString() + "</td>" +
                                      "<td>" + drow1[5].ToString() + "</td>" +
                                       "<td>" + String.Format("{0:0.00}", Convert.ToDecimal((drow1[6].ToString() != "") ? drow1[6] : 0)) + "</td>" +
                                      "</tr>");

                    }

                    #region Code To Bind The Current Total

                    try
                    {
                        string curSum = String.Format("{0:#,0}", Convert.ToDecimal((dtData.Compute("sum(CM_YYSales)", "").ToString() != "") ? dtData.Compute("sum(CM_YYSales)", "") : 0));
                        string curyrSale = String.Format("{0:#,0}", Convert.ToDecimal((dtData.Compute("sum(CY_YYSales)", "").ToString() != "") ? dtData.Compute("sum(CY_YYSales)", "") : 0));
                        string preYrSale = String.Format("{0:#,0}", Convert.ToDecimal((dtData.Compute("sum(PY_YYSales)", "").ToString() != "") ? dtData.Compute("sum(PY_YYSales)", "") : 0));
                        string strFooter = string.Empty;
                        if (isGrandTotal != true)
                        {
                            reportWriter.WriteLine("<tr align=right>" +
                             "<th align=right>Tot </th>" +
                             "<th align=right>" + curSum.ToString() + "</th>" +
                             "<th align=right>" + String.Format("{0:0.0}", Convert.ToDecimal((dtData.Compute("Avg(CM_GMPer)", "").ToString() != "") ? dtData.Compute("Avg(CM_GMPer)", "") : 0)) + "</th>" +
                             "<th align=right>" + String.Format("{0:0.0}", Convert.ToDecimal((dtData.Compute("Avg(CM_Total)", "").ToString() != "") ? dtData.Compute("Avg(CM_Total)", "") : 0)) + "</th>" +
                             "<th align=right>" + String.Format("{0:0.00}", Convert.ToDecimal((dtData.Compute("Avg(CM_LB)", "").ToString() != "") ? dtData.Compute("Avg(CM_LB)", "") : 0)) + "</th>" +
                             "<th align=right>" + String.Format("{0:0.00}", Convert.ToDecimal((dtData.Compute("Avg(CM_GMLB)", "").ToString() != "") ? dtData.Compute("Avg(CM_GMLB)", "") : 0)) + "</th>" +
                             "</tr>");
                        }


                    }
                    finally { }

                    #endregion

                    reportWriter.WriteLine("");
                }
            }
            #endregion
            reportWriter.WriteLine("</table>");
            reportWriter.Close();


        }
        catch (Exception ex) { }
    }

    #endregion

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        RestoreSession();
        dgReport.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataToGrid();
    }

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

    protected void dgAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        try
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {

                // Code added by sathish to display hyper link in Branch column
                string url = string.Empty;
                // Code to display progress bar on page load
                url = "BranchItemSalesAnalysis.aspx?Month=" + Request.QueryString["Month"].ToString() + "~Year=" + Request.QueryString["year"].ToString() + "~Branch=" + e.Item.Cells[0].Text + "~MonthName=" + Request.QueryString["MonthName"].ToString() + "~BranchName=" + e.Item.Cells[0].Text + "~CategoryFrom=" + e.Item.Cells[1].Text + "~CategoryTo=~VarianceFrom=" + Request.QueryString["VarianceFrom"].ToString() + "~VarianceTo=" + Request.QueryString["VarianceTo"].ToString()
                    + "~SalesRep=" + string.Empty + "~Period=" + ((rdoDate1.Checked) ? "mtd" : "ytd") + "~Version=" + ((rdoReportVersion1.Checked) ? "long" : "short");

                url = "ProgressBar.aspx?destPage=" + url;
                if (isGrandTotal != true)
                {
                    HyperLink hplButton = new HyperLink();
                    hplButton.Text = e.Item.Cells[0].Text;
                    hplButton.NavigateUrl = url;
                    hplButton.Attributes.Add("onclick", "window.open(this.href, 'popupwindow', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES'); return false;");
                    e.Item.Cells[0].Controls.Add(hplButton);
                }
                //else
                //{
                //    HyperLink hplButton1 = new HyperLink();
                //    hplButton1.Text = e.Item.Cells[0].Text;
                //}
                

            }
            if (e.Item.ItemType == ListItemType.Footer)
            {
                #region Current Total

                string curSum = String.Format("{0:#,0}", Convert.ToDecimal(temp.Rows[0][2].ToString()));
                string curyrSale = String.Format("{0:#,0}", Convert.ToDecimal(temp.Rows[0][7].ToString()));
                string preYrSale = String.Format("{0:#,0}", Convert.ToDecimal(temp.Rows[0][12].ToString()));
                curSum = (curSum.IndexOf("$") != -1) ? curSum.Replace("$", "") : curSum;
                curyrSale = (isGrandTotal != true ? ((curyrSale.IndexOf("$") != -1) ? curyrSale.Replace("$", "") : curyrSale) : "");
                preYrSale = (isGrandTotal != true ? ((preYrSale.IndexOf("$") != -1) ? preYrSale.Replace("$", "") : preYrSale) : "");

                e.Item.Cells[0].Text = (isGrandTotal != true ? "Tot" : "");
                e.Item.Cells[2].Text = (isGrandTotal != true ? curSum : "");
                e.Item.Cells[3].Text = (isGrandTotal != true ? temp.Rows[0][3].ToString() : "");
                e.Item.Cells[4].Text = (isGrandTotal != true ? temp.Rows[0][4].ToString() : "");
                e.Item.Cells[5].Text = (isGrandTotal != true ? temp.Rows[0][5].ToString() : "");
                e.Item.Cells[6].Text = (isGrandTotal != true ? temp.Rows[0][6].ToString() : "");

                e.Item.Cells[7].Text = (isGrandTotal != true ? curyrSale : "");
                e.Item.Cells[8].Text = (isGrandTotal != true ? temp.Rows[0][8].ToString() : "");
                e.Item.Cells[9].Text = (isGrandTotal != true ? temp.Rows[0][9].ToString() : "");
                e.Item.Cells[10].Text = (isGrandTotal != true ? temp.Rows[0][10].ToString() : "");
                e.Item.Cells[11].Text = (isGrandTotal != true ? temp.Rows[0][11].ToString() : "");


                e.Item.Cells[12].Text = (isGrandTotal != true ? preYrSale : "");
                e.Item.Cells[13].Text = (isGrandTotal != true ? temp.Rows[0][13].ToString() : "");
                e.Item.Cells[14].Text = (isGrandTotal != true ? temp.Rows[0][14].ToString() : "");
                e.Item.Cells[15].Text = (isGrandTotal != true ? temp.Rows[0][15].ToString() : "");
                e.Item.Cells[16].Text = (isGrandTotal != true ? temp.Rows[0][16].ToString() : "");

                #endregion

            }

        }
        catch (Exception ex) { }

    }

    protected void dgAnalysis_ItemCreated(object sender, DataGridItemEventArgs e)
    {
        e.Item.Cells[1].Visible = false;
    }

    public string GetDescription(string category)
    {
        SqlConnection cnNavision = new SqlConnection(PFC.Intranet.Global.NavisionConnectionString);
        
        try
        {
            if (cnNavision.State.ToString() == "Open") cnNavision.Close();
            cnNavision.Open();
            cmd = new SqlCommand("select Top 1 [Description 2] from [Porteous$Item] where No_ like '" + category + "%' and [Description 2]<>''", cnNavision);
            string strDesc = cmd.ExecuteScalar().ToString();
            cmd.Dispose();
            cnNavision.Close();
            return strDesc;
        }
        catch (Exception ex) { cn.Close(); return ""; }
    }

    private void RestoreSession()
    {
        dtCategorySales =((Session["dtCategorySales"]!=null)?(DataTable)Session["dtCategorySales"]:null);
        dtReportCategorySales = ((Session["dtReportCategorySales"]!=null) ? (DataTable)Session["dtReportCategorySales"] : null);
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
        BindDataToGrid();
    }

    #region Function To Bind The DataGrid Header

    public void BindDataGridHeader(DataGrid dgAnalysis)
    {
        string strCurYear = ((Convert.ToInt16(strMonth) <= 8) ? strYear : Convert.ToString(Convert.ToInt32(strYear) + 1));
        string strPreviousYear = Convert.ToString(Convert.ToInt32(strCurYear) - 1);

        dgAnalysis.Columns[0].HeaderText = (isGrandTotal != true ? "Brn" : "");
        dgAnalysis.Columns[1].HeaderText = (isGrandTotal != true ? "Brn" : "");
        dgAnalysis.Columns[2].HeaderText = "'" + strCurYear.Remove(strCurYear.Length - 4, 2) + " Sales $";
        dgAnalysis.Columns[3].HeaderText = "GM%";
        dgAnalysis.Columns[4].HeaderText = "% of Tot Sales";
        dgAnalysis.Columns[5].HeaderText = "$/Lb";
        dgAnalysis.Columns[6].HeaderText = "GM$/Lb";
        dgAnalysis.Columns[7].HeaderText = "YTD '" + strCurYear.Remove(strCurYear.Length - 4, 2) + " Sales $";
        dgAnalysis.Columns[8].HeaderText = "GM%";
        dgAnalysis.Columns[9].HeaderText = "YTD '" + strCurYear.Remove(strCurYear.Length - 4, 2) + "  % of Tot Sales";
        dgAnalysis.Columns[10].HeaderText = "$/Lb";
        dgAnalysis.Columns[11].HeaderText = "GM$/Lb";
        dgAnalysis.Columns[12].HeaderText = "YTD '" + strPreviousYear.Remove(strPreviousYear.Length - 4, 2) + " Sales $";
        dgAnalysis.Columns[13].HeaderText = "GM%";
        dgAnalysis.Columns[14].HeaderText = "YTD '" + strPreviousYear.Remove(strPreviousYear.Length - 4, 2) + "% of Tot Sales";
        dgAnalysis.Columns[15].HeaderText = "$/Lb";
        dgAnalysis.Columns[16].HeaderText = "GM$/Lb";

        bool periodYtd = (rdoDate2.Checked) ? true : false;
        bool periodMtd = (rdoDate1.Checked || rdoDate2.Checked) ? true : false;

        dgAnalysis.Columns[0].Visible = true;
        dgAnalysis.Columns[2].Visible = periodMtd;
        dgAnalysis.Columns[3].Visible = periodMtd;
        dgAnalysis.Columns[4].Visible = periodMtd;
        dgAnalysis.Columns[5].Visible = periodMtd;

        dgAnalysis.Columns[7].Visible = periodYtd;
        dgAnalysis.Columns[8].Visible = periodYtd;
        dgAnalysis.Columns[9].Visible = periodYtd;
        dgAnalysis.Columns[10].Visible = periodYtd;

        dgAnalysis.Columns[12].Visible = periodYtd;
        dgAnalysis.Columns[13].Visible = periodYtd;
        dgAnalysis.Columns[14].Visible = periodYtd;
        dgAnalysis.Columns[15].Visible = periodYtd;

        dgAnalysis.Columns[6].Visible = (rdoDate2.Checked && rdoReportVersion1.Checked) ? true :
                                        (rdoDate1.Checked && rdoReportVersion1.Checked) ? true : false;
        dgAnalysis.Columns[11].Visible = (rdoDate2.Checked && rdoReportVersion1.Checked) ? true : false;
        dgAnalysis.Columns[16].Visible = (rdoDate2.Checked && rdoReportVersion1.Checked) ? true : false;



    }

    #endregion

    # region MTD & YTD Option  With Short &  Long Version
    protected void rdoReportVersion1_CheckedChanged(Object sender, System.EventArgs e)
    {
        hidVersion.Value = "long";
        ExcelExport();
        BindDataToGrid();
    }
    protected void rdoReportVersion2_CheckedChanged(Object sender, System.EventArgs e)
    {
        hidVersion.Value = "short";
        ExcelExport();
        BindDataToGrid();
    }
    protected void rdoDate1_CheckedChanged(object sender, EventArgs e)
    {
        hidPeriod.Value = "mtd";
        ExcelExport();
        BindDataToGrid();
    }
    protected void rdoDate2_CheckedChanged(object sender, EventArgs e)
    {
        hidPeriod.Value = "ytd";
        ExcelExport();
        BindDataToGrid();
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

