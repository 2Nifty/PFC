/********************************************************************************************
 * File	Name			:	CategoryTrendPreview.aspx.cs
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
    DataTable dt = new DataTable();
    DataTable dtReport = new DataTable();
    string strStartDate = string.Empty;
    string strEndDate = string.Empty;
    string strBranch = string.Empty;
    string strCatFrom = string.Empty;
    string strCatTo = string.Empty;
    string strVarianceFrom = string.Empty;
    string strVarianceTo = string.Empty;

    protected void Page_Load(object sender, EventArgs e)
    {

        strStartDate = (Request.QueryString["StDate"] != null) ? Request.QueryString["StDate"].ToString().Trim() : "";
        strEndDate = Request.QueryString["EndDate"].ToString().Trim();
        strBranch = (Request.QueryString["BranchID"] != "0") ? Request.QueryString["BranchID"].ToString().Trim() : "";
        strCatFrom = (Request.QueryString["CategoryFrom"] != null) ? Request.QueryString["CategoryFrom"].ToString().Trim() : "";
        strCatTo = (Request.QueryString["CategoryTo"] != null) ? Request.QueryString["CategoryTo"].ToString().Trim() : "";
        strVarianceFrom = (Request.QueryString["VarianceFrom"] != null) ? Request.QueryString["VarianceFrom"].ToString().Trim() : "";
        strVarianceTo = (Request.QueryString["VarianceTo"] != null) ? Request.QueryString["VarianceTo"].ToString().Trim() : "";
        

        if (!IsPostBack)
        {
            BindDataToGrid();
        }
    }

    public void BindDataToGrid()
    {
        try
        {
            dtReport = (DataTable)Session["dtReport"];
            dt = (DataTable)Session["dt"];
            try
            {

                try
                {
                    dgReport.DataSource = dtReport;
                    dgReport.DataBind();
                    lblMsg.Visible = (dgReport.Items.Count < 1) ? true : false;
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
                        try
                        {
                            dt.DefaultView.RowFilter = "Category=" + lblCategory.Text + " and Plating='" + lblPlating.Text + "' and PlatingDescription='" + lblPlatingDescription.Text + "' and Variance='" + lblVariance.Text + "'";
                            dt.DefaultView.Sort = Request.QueryString["Sort"].ToString();
                            dgData.DataSource = dt.DefaultView;
                            dgData.DataBind();
                            dgData.Width = (Request.QueryString["Version"].ToString().Trim() == "long") ? 815 : 650;
                            dgData.Columns[6].Visible =(Request.QueryString["Version"].ToString().Trim()=="long")? true:false;
                            dgData.Columns[9].Visible = (Request.QueryString["Version"].ToString().Trim() == "long") ? true : false;
                        }
                        catch (Exception ex) { }
                        lblMessage.Visible = (dgData.Items.Count >= 1) ? false : true;
                    }
                }
                catch (Exception ex) { cn.Close(); }
            }
            catch (Exception ex) { }
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

    protected void dgAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        e.Item.HorizontalAlign = HorizontalAlign.Right;
        e.Item.Width = 150;
        e.Item.Cells[0].HorizontalAlign = HorizontalAlign.Left;
    }
}
