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

public partial class SalesForeCastingTool_BranchSummary : System.Web.UI.Page
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
        lblMessage.Text = "";

        if (!Page.IsPostBack)
        {
            lblHeaderBranch.Text = Request.QueryString["HeaderText"].ToString();
            FillCASHeader();
            BindDataGrid();

        }
    }

    protected void dgBranchSummary_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgBranchSummary.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
        pnldgrid.Update();
    }

    protected void dgBranchSummary_SortCommand(object sender, DataGridSortCommandEventArgs e)
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
        pnldgrid.Update();
    }

    protected void dgBranchSummary_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Footer)
        {
            DataTable temp = dsBranchSummary.Tables[0];
            if( temp.Rows.Count >0)
            {
                e.Item.Cells[0].ColumnSpan = 2;
                e.Item.Cells[1].Visible = false;
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

                e.Item.Cells[10].Text = String.Format("{0:#,##0}",_annualActual) ;
                e.Item.Cells[11].Text = String.Format("{0:#,##0}", _annualforecast);
                e.Item.Cells[12].Text = String.Format("{0:#,##0.0}", _pctDiff);
            }
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
            // tblHeader.Visible = (dgCas.Items.Count <= 0 ? false : true);


        }
        catch (Exception ex) { Response.Write(ex.ToString()); }
    }

    private void BindDataGrid()
    {
        sortExpression = ((hidSort.Value != "") ? " ORDER BY  " + hidSort.Value : " ORDER BY OrderType,AnnualActualLbs DESC");
        dsBranchSummary = salesSorecastingTool.GetBranchSummary(branchID, sortExpression);
        dgBranchSummary.DataSource = dsBranchSummary.Tables[0];
        dgBranchSummary.DataBind();
        pnldgrid.Update();
    }
    
    protected void btnSort_Click(object sender, EventArgs e)
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

        hidSort.Value = hidSortExpression.Value + " " + hidSort.Attributes["sortType"].ToString();
        BindDataGrid();
        pnldgrid.Update();
    }
    #endregion

    
}
