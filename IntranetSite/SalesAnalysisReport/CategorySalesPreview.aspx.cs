/********************************************************************************************
 * File	Name			:	CategorySalesAnalysisPreview.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Retrive Data From Curvalsum Table - Customerwise.
 * Created By			:	Senthilkumar
 * Created Date			:	08/07/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/12/2005		    Version 1		Mahesh      		Created 
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
using PFC.Intranet;


public partial class SalesAnalysisReport_ReportPreview : System.Web.UI.Page
{
    SqlConnection cn = new SqlConnection(PFC.Intranet.Global.ReportsConnectionString);
    SqlCommand cmd;

    DataTable dtCategorySales = new DataTable();
    DataTable dt2 = new DataTable();
    DataTable dtReportCategorySales = new DataTable();
    DataTable temp = new DataTable();

    string strYear = string.Empty;
    string strMonth = string.Empty;
    string strCatFrom = string.Empty;
    string strCatTo = string.Empty;
    string strVarianceFrom = string.Empty;
    string strVarianceTo = string.Empty;
    string strPreYear = string.Empty;
    bool isGrandTotal = false;
    string strPeriod = string.Empty;
    string strVersion = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {
        strYear = Request.QueryString["Year"].ToString();
        strMonth = Request.QueryString["Month"].ToString();
        strCatFrom = (Request.QueryString["CategoryFrom"] != null) ? Request.QueryString["CategoryFrom"].ToString().Trim() : "";
        strCatTo = (Request.QueryString["CategoryTo"] != null) ? Request.QueryString["CategoryTo"].ToString().Trim() : "";
        strVarianceFrom = (Request.QueryString["VarianceFrom"] != null) ? Request.QueryString["VarianceFrom"].ToString().Trim() : "";
        strVarianceTo = (Request.QueryString["VarianceTo"] != null) ? Request.QueryString["VarianceTo"].ToString().Trim() : "";
        strPreYear = Convert.ToString((Convert.ToInt32(strYear) - 1));
        strPeriod = Request.QueryString["PeriodType"].ToString().Trim();
        strVersion = Request.QueryString["Version"].ToString().Trim();

        if (!IsPostBack)
        {
            BindDataToGrid();
        }
    }
    public void BindDataToGrid()
    {
        try
        {
            RestoreSession();
            dgReport.DataSource = dtReportCategorySales;
            dgReport.DataBind();
            tdGrid.Visible = (dgReport.Items.Count < 1) ? false : true;

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
                dtCategorySales.DefaultView.RowFilter = "Category='" + lblCategory.Text + "' and Brn in (" + Session["AuthorizedBranch"] + ",'Grand Total')";
                dtCategorySales.DefaultView.Sort = Request.QueryString["Sort"].ToString();
                BindCurrentTotal();
                dgAnalysis.DataSource = dtCategorySales.DefaultView;
                dgAnalysis.DataBind();

                dgAnalysis.Width = (strPeriod == "ytd" && strVersion == "long") ? 980 :
                   (strPeriod == "ytd" && strVersion == "short") ? 980 : (strPeriod == "mtd" && strVersion == "long") ? 350 : 300;
            }

            #endregion

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

    protected void dgAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        try
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                if (isGrandTotal) e.Item.CssClass = "GridHead";

                // Code added by sathish to display hyper link in Branch column
                string url = string.Empty;
                // Code to display progress bar on page load
                url = "BranchItemSalesAnalysis.aspx?Month=" + Request.QueryString["Month"].ToString() + "~Year=" + Request.QueryString["year"].ToString() + "~Branch=" + e.Item.Cells[0].Text + "~MonthName=" + Request.QueryString["MonthName"].ToString() + "~BranchName=" + e.Item.Cells[0].Text + "~CategoryFrom=" + Request.QueryString["CategoryFrom"].ToString() + "~CategoryTo=" + Request.QueryString["CategoryTo"].ToString() + "~VarianceFrom=" + Request.QueryString["VarianceFrom"].ToString() + "~VarianceTo=" + Request.QueryString["VarianceTo"].ToString();

                url = "ProgressBar.aspx?destPage=" + url;
                HyperLink hplButton = new HyperLink();
                hplButton.Text = e.Item.Cells[0].Text;
                hplButton.NavigateUrl = url;
                hplButton.Attributes.Add("onclick", "window.open(this.href, 'popupwindow', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES'); return false;");
                e.Item.Cells[0].Controls.Add(hplButton);


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
        catch (Exception ex) { cnNavision.Close(); return ""; }
    }
        
    private void RestoreSession()
    {
        dtCategorySales = (DataTable)Session["dtCategorySales"];
        dtReportCategorySales = (DataTable)Session["dtReportCategorySales"];
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
        dgAnalysis.Columns[12].HeaderText = "YTD '" + strCurYear.Remove(strCurYear.Length - 4, 2) + " Sales $";
        dgAnalysis.Columns[13].HeaderText = "GM%";
        dgAnalysis.Columns[14].HeaderText = "YTD '" + strPreviousYear.Remove(strPreviousYear.Length - 4, 2) + "% of Tot Sales";
        dgAnalysis.Columns[15].HeaderText = "$/Lb";
        dgAnalysis.Columns[16].HeaderText = "GM$/Lb";

        bool periodYtd = (strPeriod == "ytd") ? true : false;
        bool periodMtd = (strPeriod == "mtd" || strPeriod == "ytd") ? true : false;

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

        dgAnalysis.Columns[6].Visible = (strPeriod == "ytd" && strVersion == "long") ? true :
                                         (strPeriod == "mtd" && strVersion == "long") ? true : false;
        dgAnalysis.Columns[11].Visible = (strPeriod == "ytd" && strVersion == "long") ? true : false;
        dgAnalysis.Columns[16].Visible = (strPeriod == "ytd" && strVersion == "long") ? true : false;


    }

    #endregion
}
