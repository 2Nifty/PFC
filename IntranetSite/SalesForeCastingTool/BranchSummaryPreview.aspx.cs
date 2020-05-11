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
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
using PFC.Intranet.Utility;

public partial class SalesForeCastingTool_BranchSummaryPreview : System.Web.UI.Page
{
    SalesForecastingTool salesSorecastingTool = new SalesForecastingTool();
    private DataSet dsBranchSummary = new DataSet();
    private string branchID = "";
    private string sortExpression = string.Empty;
    #region page events

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        //Comment should be removed
        //systemCheck.SessionCheck();

        branchID = Request.QueryString["Branch"].ToString();
        // lblMessage.Text = "";

        if (!Page.IsPostBack)
        {
            lblHeaderBranch.Text = Request.QueryString["HeaderText"].ToString();
            FillCASHeader();
            BindDataGrid();

        }
    }


    #endregion

    #region Developer Methods


    public void FillCASHeader()
    {
        try
        {

            // Bind the datagrid with datatable
            dgCas.DataSource = salesSorecastingTool.GetCASHeaderRecord(branchID);
            dgCas.DataBind();
            // Display the info to the user when table contains no records
            // lblStatus.Visible = (dgCas.Items.Count <= 0 ? true : false);

        }
        catch (Exception ex) { Response.Write(ex.ToString()); }
    }

    private void BindDataGrid()
    {
        string keyColumn = "OrderType,AnnualActualLbs";
        string sortExpression = ((Request.QueryString["Sort"] != null && Request.QueryString["Sort"] != "") ? " ORDER BY  " + Request.QueryString["Sort"].ToString() : " ORDER BY " + keyColumn + " DESC");
        dsBranchSummary = salesSorecastingTool.GetBranchSummary(branchID, sortExpression);
        dgBranchSummary.DataSource = dsBranchSummary.Tables[0];

        dgBranchSummary.DataBind();        
    }



    #endregion
    protected void dgBranchSummary_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Header)
        {            
            e.Item.Cells[0].Visible = false;
            e.Item.Cells[0].Width = Unit.Pixel(0);
            e.Item.Style.Add(HtmlTextWriterStyle.BackgroundColor, "#DFF3F9");
            e.Item.Cells[1].ColumnSpan = 2;
            e.Item.Cells[1].Text = "<table cellpadding=\"0\" border='0' bgcolor='#dff3f9'  width='101%' cellspacing='0' height=\"20\">" +
                                    "<tr height=\"20\" align=\"right\"> <td align=\"right\" class=\"GridHead splitBorder\" colspan=\"2\" >&nbsp;</td> <tr>" +
                                    "<tr height=\"20\" align=\"right\"> <td align=\"center\" class=\"GridHead splitBorders\" width=\"65\" ><center> Cust </center> </td>" +
                                    " <td align=\"center\" class=\"GridHead splitBorders\" width=\"170\">  <center>  Name </center></td> <tr></table>";

            e.Item.Cells[2].Visible = false;
            e.Item.Cells[3].ColumnSpan = 2;
            e.Item.Cells[3].Text = "<table cellpadding=\"0\" border='0' bgcolor='#dff3f9' width='101%' cellspacing='0' height=\"20\">" +
                                    "<tr height=\"20\" align=\"right\"><td align=\"right\" class=\"GridHead splitBorder\" colspan=\"2\" > <center>Q1</center></td> <tr>" +
                                    "<tr height=\"20\" align=\"right\"><td align=\"center\" class=\"GridHead splitBorders\" width=\"60\" >  <center>  Actual </center> </td>" +
                                    "<td align=\"center\" class=\"GridHead splitBorders\" width=\"60\" > <center> Forecast</center></td> <tr></table>";

            e.Item.Cells[4].Visible = false;
            e.Item.Cells[5].ColumnSpan = 2;
            e.Item.Cells[5].Text = "<table cellpadding=\"0\" border='0' bgcolor='#dff3f9' width='101%' cellspacing='0' height=\"20\">" +
                                    "<tr height=\"20\" align=\"right\"><td align=\"right\" class=\"GridHead splitBorder\" colspan=\"2\" > <center>Q2</center></td> <tr>" +
                                    "<tr height=\"20\" align=\"right\"><td align=\"center\" class=\"GridHead splitBorders\" width=\"60\" >  <center>  Actual </center> </td>" +
                                    "<td align=\"center\" class=\"GridHead splitBorders\" width=\"60\" > <center> Forecast</center></td> <tr></table>";

            e.Item.Cells[6].Visible = false;
            e.Item.Cells[7].ColumnSpan = 2;
            e.Item.Cells[7].Text = "<table cellpadding=\"0\" border='0' bgcolor='#dff3f9' width='101%' cellspacing='0' height=\"20\">" +
                                    "<tr height=\"20\" align=\"right\"><td align=\"right\" class=\"GridHead splitBorder\" colspan=\"2\" > <center>Q3</center></td> <tr>" +
                                    "<tr height=\"20\" align=\"right\"><td align=\"center\" class=\"GridHead splitBorders\" width=\"60\" >  <center>  Actual </center> </td>" +
                                    "<td align=\"center\" class=\"GridHead splitBorders\" width=\"60\" > <center> Forecast</center></td> <tr></table>";
            e.Item.Cells[8].Visible = false;
            e.Item.Cells[9].ColumnSpan = 2;
            e.Item.Cells[9].Text = "<table cellpadding=\"0\" border='0' bgcolor='#dff3f9' width='101%' cellspacing='0' height=\"20\">" +
                                    "<tr height=\"20\" align=\"right\"><td align=\"right\" class=\"GridHead splitBorder\" colspan=\"2\" > <center>Q4</center></td> <tr>" +
                                    "<tr height=\"20\" align=\"right\"><td align=\"center\" class=\"GridHead splitBorders\" width=\"60\" >  <center>  Actual </center> </td>" +
                                    "<td align=\"center\" class=\"GridHead splitBorders\" width=\"60\" > <center> Forecast</center></td> <tr></table>";
            e.Item.Cells[10].Visible = false;
            e.Item.Cells[11].ColumnSpan = 2;
            e.Item.Cells[11].Text = "<table cellpadding=\"0\" border='0' bgcolor='#dff3f9' width='101%' cellspacing='0' height=\"20\">" +
                                    "<tr height=\"20\" align=\"right\"><td align=\"right\" class=\"GridHead splitBorder\" colspan=\"2\" ><center>Annual</center></td> <tr>" +
                                    "<tr height=\"20\" align=\"right\"><td align=\"center\" class=\"GridHead splitBorders\" width=\"60\" >  <center>  Actual </center> </td>" +
                                    "<td align=\"center\" class=\"GridHead splitBorders\" width=\"60\" > <center> Forecast</center></td> <tr></table>";

            e.Item.Cells[12].Text = " %Diff ";



        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            DataTable temp = dsBranchSummary.Tables[0];
            if (temp.Rows.Count > 0)
            {
                e.Item.Cells[0].ColumnSpan = 2;
                e.Item.Cells[1].Visible = false;
                e.Item.Cells[0].HorizontalAlign = HorizontalAlign.Center;
                e.Item.Cells[0].Text = "Grand Total";

                e.Item.Cells[2].Text = (temp.Compute("sum(Q1ActualLbs)", "").ToString() != "" ? String.Format("{0:#,##0}", Math.Round(Convert.ToDecimal(temp.Compute("sum(Q1ActualLbs)", "").ToString()), 0)).ToString() : "");
                e.Item.Cells[3].Text = (temp.Compute("sum(Q1ForecastLbs)", "").ToString() != "" ? String.Format("{0:#,##0}", Math.Round(Convert.ToDecimal(temp.Compute("sum(Q1ForecastLbs)", "").ToString()), 0)).ToString() : "");
                e.Item.Cells[4].Text = (temp.Compute("sum(Q2ActualLbs)", "").ToString() != "" ? String.Format("{0:#,##0}", Math.Round(Convert.ToDecimal(temp.Compute("sum(Q2ActualLbs)", "").ToString()), 0)).ToString() : "");
                e.Item.Cells[5].Text = (temp.Compute("sum(Q2ForecastLbs)", "").ToString() != "" ? String.Format("{0:#,##0}", Math.Round(Convert.ToDecimal(temp.Compute("sum(Q2ForecastLbs)", "").ToString()), 0)).ToString() : "");

                e.Item.Cells[6].Text = (temp.Compute("sum(Q3ActualLbs)", "").ToString() != "" ? String.Format("{0:#,##0}", Math.Round(Convert.ToDecimal(temp.Compute("sum(Q3ActualLbs)", "").ToString()), 0)).ToString() : "");
                e.Item.Cells[7].Text = (temp.Compute("sum(Q3ForecastLbs)", "").ToString() != "" ? String.Format("{0:#,##0}", Math.Round(Convert.ToDecimal(temp.Compute("sum(Q3ForecastLbs)", "").ToString()), 0)).ToString() : "");
                e.Item.Cells[8].Text = (temp.Compute("sum(Q4ActualLbs)", "").ToString() != "" ? String.Format("{0:#,##0}", Math.Round(Convert.ToDecimal(temp.Compute("sum(Q4ActualLbs)", "").ToString()), 0)).ToString() : "");
                e.Item.Cells[9].Text = (temp.Compute("sum(Q4ForecastLbs)", "").ToString() != "" ? String.Format("{0:#,##0}", Math.Round(Convert.ToDecimal(temp.Compute("sum(Q4ForecastLbs)", "").ToString()), 0)).ToString() : "");

                decimal _annualActual = (temp.Compute("sum(AnnualActualLbs)", "").ToString() != "" ? Math.Round(Convert.ToDecimal(temp.Compute("sum(AnnualActualLbs)", "").ToString()), 0) : 0);
                decimal _annualforecast = (temp.Compute("sum(AnnualForecastLbs)", "").ToString() != "" ? Math.Round(Convert.ToDecimal(temp.Compute("sum(AnnualForecastLbs)", "").ToString()), 0) : 0);
                decimal _pctDiff = ((_annualforecast - _annualActual) / _annualActual) * 100;

                e.Item.Cells[10].Text = String.Format("{0:#,##0}", _annualActual);
                e.Item.Cells[11].Text = String.Format("{0:#,##0}", _annualforecast);
                e.Item.Cells[12].Text = String.Format("{0:#,##0.0}", _pctDiff);
            }
        }

    }
}
