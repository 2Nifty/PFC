using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.IO;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Data.Sql;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.InvoiceRegister;
using System.Text.RegularExpressions;

public partial class BranchBudgetReport : System.Web.UI.Page
{
    # region Variable Declaration

    CustomerBudget customerBudget = new CustomerBudget();    
    DataTable dtExcelData = new DataTable();
    DataSet dsBranchBudgetData = new DataSet();
    GridView gvExportExcel = new GridView();

    int pageCount = 2;
    string branchCd = "";
    string salesRepNo = "";
    string chainCd = "";
    string custNo = "";    
    string sortExpression = string.Empty;    
    string excelFilePath = "../Common/ExcelUploads/";
    bool DisplayBranchGrid = false;
    string sortType = "SalesDol";
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(BranchBudgetReport));
        Response.Cache.SetCacheability(HttpCacheability.NoCache);

        if (!IsPostBack)
        {
            hidFileName.Value = "BranchBudgetReport" + Session["SessionID"].ToString() + ".xls";           
            BindDataGrid();
        }
    }

    #region Bind Branch Sales Grid

    private void BindDataGrid()
    {
        DataSet dsBranches = customerBudget.GetCustomerBudgetData("getbudgetbranches", "");
        

        if (dsBranches != null)
        {

            DataTable dtBranches = dsBranches.Tables[0];
            if (dtBranches != null && dtBranches.Rows.Count > 0)
            {
                gvCustBudget.DataSource = dtBranches;
                pager.InitPager(gvCustBudget, pageCount);
            }
            else
            {
                gvCustBudget.Visible = false;
                lblStatus.Visible = true;
                pager.Visible = false;
            }
        }        
        upnlCustomerGrid.Update();               

    }

    protected void gvCustBudget_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {            
            HiddenField _hidBranchId = e.Row.FindControl("hidBranchId") as HiddenField;
            Table _tblBrBudget = e.Row.FindControl("tblBranchBudget") as Table;
            
            // Get the record for single branch
            dsBranchBudgetData = customerBudget.GetCustomerBudgetReport(_hidBranchId.Value, "", "", "", "BRANCH", sortType, "yes", "");
            
            if(dsBranchBudgetData != null)
                BindBranchSummaryGrid(_tblBrBudget, dsBranchBudgetData.Tables[0]);
            
        }
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        gvCustBudget.PageIndex = pager.GotoPageNumber;

        BindDataGrid();
    }

    #endregion

    #region Bind Branch Summary Grid

    private void BindBranchSummaryGrid(Table tblBranchBudget, DataTable dtBranchdata)
    {
        string MouseOverStyle = "this.style.backgroundColor='#FFFFCC'";
        string MouseOutStyle = "this.style.backgroundColor='white';";

        #region Year 1 - Sales Dollar Row       
        
        tblBranchBudget.Rows[1].Attributes["onmouseover"] = MouseOverStyle;
        tblBranchBudget.Rows[1].Attributes["onmouseout"] = MouseOutStyle;

        tblBranchBudget.Rows[1].Cells[0].Text = dtBranchdata.Rows[0]["FiscalYear"].ToString();
        tblBranchBudget.Rows[1].Cells[1].Text = "Actual";
        tblBranchBudget.Rows[1].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[0]["SepSales"].ToString()));
        tblBranchBudget.Rows[1].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[0]["OctSales"].ToString()));
        tblBranchBudget.Rows[1].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[0]["NovSales"].ToString()));
        tblBranchBudget.Rows[1].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[0]["DecSales"].ToString()));

        tblBranchBudget.Rows[1].Cells[6].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[0]["JanSales"].ToString()));
        tblBranchBudget.Rows[1].Cells[7].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[0]["FebSales"].ToString()));
        tblBranchBudget.Rows[1].Cells[8].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[0]["MarSales"].ToString()));
        tblBranchBudget.Rows[1].Cells[9].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[0]["AprSales"].ToString()));

        tblBranchBudget.Rows[1].Cells[10].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[0]["MaySales"].ToString()));
        tblBranchBudget.Rows[1].Cells[11].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[0]["JunSales"].ToString()));
        tblBranchBudget.Rows[1].Cells[12].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[0]["JulSales"].ToString()));
        tblBranchBudget.Rows[1].Cells[13].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[0]["AugSales"].ToString()));

        tblBranchBudget.Rows[1].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[0]["AnnualSalesAmt"].ToString()));

        #endregion

        #region Year 2 - Sales Dollar Row

        tblBranchBudget.Rows[2].Attributes["onmouseover"] = MouseOverStyle;
        tblBranchBudget.Rows[2].Attributes["onmouseout"] = MouseOutStyle;

        tblBranchBudget.Rows[2].Cells[0].Text = dtBranchdata.Rows[1]["FiscalYear"].ToString();
        tblBranchBudget.Rows[2].Cells[1].Text = (dtBranchdata.Rows[1]["RecordType"].ToString() == "AC" ? "Actual" : "Act Fcst");
        tblBranchBudget.Rows[2].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[1]["SepSales"].ToString()));
        tblBranchBudget.Rows[2].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[1]["OctSales"].ToString()));
        tblBranchBudget.Rows[2].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[1]["NovSales"].ToString()));
        tblBranchBudget.Rows[2].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[1]["DecSales"].ToString()));

        tblBranchBudget.Rows[2].Cells[6].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[1]["JanSales"].ToString()));
        tblBranchBudget.Rows[2].Cells[7].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[1]["FebSales"].ToString()));
        tblBranchBudget.Rows[2].Cells[8].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[1]["MarSales"].ToString()));
        tblBranchBudget.Rows[2].Cells[9].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[1]["AprSales"].ToString()));

        tblBranchBudget.Rows[2].Cells[10].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[1]["MaySales"].ToString()));
        tblBranchBudget.Rows[2].Cells[11].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[1]["JunSales"].ToString()));
        tblBranchBudget.Rows[2].Cells[12].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[1]["JulSales"].ToString()));
        tblBranchBudget.Rows[2].Cells[13].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[1]["AugSales"].ToString()));

        tblBranchBudget.Rows[2].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchdata.Rows[1]["AnnualSalesAmt"].ToString()));

        #endregion

        #region Year 3 - Fixed Forecasted Sales Dollar Row

        DataRow[] drBrFFAData = dtBranchdata.Select("RecordType='FFA'");
        if (drBrFFAData != null && drBrFFAData.Length > 0)
        {
            tblBranchBudget.Rows[3].Attributes["onmouseover"] = MouseOverStyle;
            tblBranchBudget.Rows[3].Attributes["onmouseout"] = MouseOutStyle;

            tblBranchBudget.Rows[3].Cells[0].Text = drBrFFAData[0]["FiscalYear"].ToString();
            tblBranchBudget.Rows[3].Cells[1].Text = "Corp Fcst";
            tblBranchBudget.Rows[3].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["SepSales"].ToString()));
            tblBranchBudget.Rows[3].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["OctSales"].ToString()));
            tblBranchBudget.Rows[3].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["NovSales"].ToString()));
            tblBranchBudget.Rows[3].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["DecSales"].ToString()));

            tblBranchBudget.Rows[3].Cells[6].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["JanSales"].ToString()));
            tblBranchBudget.Rows[3].Cells[7].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["FebSales"].ToString()));
            tblBranchBudget.Rows[3].Cells[8].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["MarSales"].ToString()));
            tblBranchBudget.Rows[3].Cells[9].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["AprSales"].ToString()));

            tblBranchBudget.Rows[3].Cells[10].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["MaySales"].ToString()));
            tblBranchBudget.Rows[3].Cells[11].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["JunSales"].ToString()));
            tblBranchBudget.Rows[3].Cells[12].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["JulSales"].ToString()));
            tblBranchBudget.Rows[3].Cells[13].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["AugSales"].ToString()));

            tblBranchBudget.Rows[3].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["AnnualSalesAmt"].ToString()));
        }
        #endregion

        #region Year 3 - Branch Forecasted Sales Dollar Row

        DataRow[] drBrFCData = dtBranchdata.Select("RecordType='F'");
        if (drBrFCData != null)
        {
            tblBranchBudget.Rows[4].Attributes["onmouseover"] = MouseOverStyle;
            tblBranchBudget.Rows[4].Attributes["onmouseout"] = MouseOutStyle;

            tblBranchBudget.Rows[4].Cells[0].Text = drBrFCData[0]["FiscalYear"].ToString();
            tblBranchBudget.Rows[4].Cells[1].Text = "Branch Fcst";
            tblBranchBudget.Rows[4].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["SepSales"].ToString()));
            tblBranchBudget.Rows[4].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["OctSales"].ToString()));
            tblBranchBudget.Rows[4].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["NovSales"].ToString()));
            tblBranchBudget.Rows[4].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["DecSales"].ToString()));

            tblBranchBudget.Rows[4].Cells[6].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["JanSales"].ToString()));
            tblBranchBudget.Rows[4].Cells[7].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["FebSales"].ToString()));
            tblBranchBudget.Rows[4].Cells[8].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["MarSales"].ToString()));
            tblBranchBudget.Rows[4].Cells[9].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["AprSales"].ToString()));

            tblBranchBudget.Rows[4].Cells[10].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["MaySales"].ToString()));
            tblBranchBudget.Rows[4].Cells[11].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["JunSales"].ToString()));
            tblBranchBudget.Rows[4].Cells[12].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["JulSales"].ToString()));
            tblBranchBudget.Rows[4].Cells[13].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["AugSales"].ToString()));

            tblBranchBudget.Rows[4].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["AnnualSalesAmt"].ToString()));
        }
        #endregion

        #region Year 3 - Forcast Dollar Variance Pct

        if (drBrFFAData != null && drBrFFAData.Length >0)
        {
            tblBranchBudget.Rows[5].Attributes["onmouseover"] = MouseOverStyle;
            tblBranchBudget.Rows[5].Attributes["onmouseout"] = MouseOutStyle;

            tblBranchBudget.Rows[5].Cells[0].Text = drBrFFAData[0]["FiscalYear"].ToString();
            tblBranchBudget.Rows[5].Cells[1].Text = "Variance Pct";

            decimal _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["SepSales"].ToString());
            decimal _BranchFSales = Convert.ToDecimal(drBrFCData[0]["SepSales"].ToString());
            decimal _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[5].Cells[2].Text = _variancePct.ToString("N2");


            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["OctSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["OctSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[5].Cells[3].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["NovSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["NovSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[5].Cells[4].Text = _variancePct.ToString("N2");


            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["DecSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["DecSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[5].Cells[5].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["JanSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["JanSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[5].Cells[6].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["FebSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["FebSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[5].Cells[7].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["MarSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["MarSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[5].Cells[8].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["AprSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["AprSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[5].Cells[9].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["MaySales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["MaySales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[5].Cells[10].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["JunSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["JunSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[5].Cells[11].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["JulSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["JulSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[5].Cells[12].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["AugSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["AugSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[5].Cells[13].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["AnnualSalesAmt"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["AnnualSalesAmt"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[5].Cells[14].Text = _variancePct.ToString("N2");
        }

        #endregion

        #region Growth % Calculation

        // Formula = ( (2011 - 2010) / 2010 ) * 100
        decimal _lastYearSales = Convert.ToDecimal(dtBranchdata.Rows[0]["AnnualSalesAmt"].ToString());
        decimal _currentYearSales = Convert.ToDecimal(dtBranchdata.Rows[1]["AnnualSalesAmt"].ToString());
        decimal _growthPct = (_lastYearSales == 0 ? 0 : (((_currentYearSales - _lastYearSales) / _lastYearSales) * 100)); 
        tblBranchBudget.Rows[2].Cells[15].Text = Math.Round(_growthPct, 1).ToString(); // For 2011


        //PFCTextBox _txtDolFYearGrowthPct = _tblCustBudget.Rows[3].Cells[15].FindControl("txtDolFYearGrowthPct") as PFCTextBox;
        _lastYearSales = Convert.ToDecimal(dtBranchdata.Rows[1]["AnnualSalesAmt"].ToString());
        _currentYearSales = Convert.ToDecimal(drBrFCData[0]["AnnualSalesAmt"].ToString());
        _growthPct = (_lastYearSales == 0 ? 0 : (((_currentYearSales - _lastYearSales) / _lastYearSales) * 100));
        tblBranchBudget.Rows[4].Cells[15].Text = Math.Round(_growthPct, 1).ToString(); // For 2012

        #endregion

        #region Year 1 - GM Pct Row

        tblBranchBudget.Rows[7].Attributes["onmouseover"] = MouseOverStyle;
        tblBranchBudget.Rows[7].Attributes["onmouseout"] = MouseOutStyle;

        tblBranchBudget.Rows[7].Cells[0].Text = dtBranchdata.Rows[0]["FiscalYear"].ToString();
        tblBranchBudget.Rows[7].Cells[1].Text = "Actual";
        tblBranchBudget.Rows[7].Cells[2].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["SepGMPct"].ToString()));
        tblBranchBudget.Rows[7].Cells[3].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["OctGMPct"].ToString()));
        tblBranchBudget.Rows[7].Cells[4].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["NovGMPct"].ToString()));
        tblBranchBudget.Rows[7].Cells[5].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["DecGMPct"].ToString()));

        tblBranchBudget.Rows[7].Cells[6].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["JanGMPct"].ToString()));
        tblBranchBudget.Rows[7].Cells[7].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["FebGMPct"].ToString()));
        tblBranchBudget.Rows[7].Cells[8].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["MarGMPct"].ToString()));
        tblBranchBudget.Rows[7].Cells[9].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["AprGMPct"].ToString()));

        tblBranchBudget.Rows[7].Cells[10].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["MayGMPct"].ToString()));
        tblBranchBudget.Rows[7].Cells[11].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["JunGMPct"].ToString()));
        tblBranchBudget.Rows[7].Cells[12].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["JulGMPct"].ToString()));
        tblBranchBudget.Rows[7].Cells[13].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["AugGMPct"].ToString()));

        tblBranchBudget.Rows[7].Cells[14].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["AnnualGMPct"].ToString()));

        #endregion

        #region Year 2 - GM Pct Row

        tblBranchBudget.Rows[8].Attributes["onmouseover"] = MouseOverStyle;
        tblBranchBudget.Rows[8].Attributes["onmouseout"] = MouseOutStyle;

        tblBranchBudget.Rows[8].Cells[0].Text = dtBranchdata.Rows[1]["FiscalYear"].ToString();
        tblBranchBudget.Rows[8].Cells[1].Text = (dtBranchdata.Rows[1]["RecordType"].ToString() == "AC" ? "Actual" : "Act Fcst");
        tblBranchBudget.Rows[8].Cells[2].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["SepGMPct"].ToString()));
        tblBranchBudget.Rows[8].Cells[3].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["OctGMPct"].ToString()));
        tblBranchBudget.Rows[8].Cells[4].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["NovGMPct"].ToString()));
        tblBranchBudget.Rows[8].Cells[5].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["DecGMPct"].ToString()));

        tblBranchBudget.Rows[8].Cells[6].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["JanGMPct"].ToString()));
        tblBranchBudget.Rows[8].Cells[7].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["FebGMPct"].ToString()));
        tblBranchBudget.Rows[8].Cells[8].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["MarGMPct"].ToString()));
        tblBranchBudget.Rows[8].Cells[9].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["AprGMPct"].ToString()));

        tblBranchBudget.Rows[8].Cells[10].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["MayGMPct"].ToString()));
        tblBranchBudget.Rows[8].Cells[11].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["JunGMPct"].ToString()));
        tblBranchBudget.Rows[8].Cells[12].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["JulGMPct"].ToString()));
        tblBranchBudget.Rows[8].Cells[13].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["AugGMPct"].ToString()));

        tblBranchBudget.Rows[8].Cells[14].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["AnnualGMPct"].ToString()));

        #endregion

        #region Year 3 - Fixed Forecasted GM Pct Row

        if (drBrFFAData != null && drBrFFAData.Length > 0)
        {
            tblBranchBudget.Rows[9].Attributes["onmouseover"] = MouseOverStyle;
            tblBranchBudget.Rows[9].Attributes["onmouseout"] = MouseOutStyle;

            tblBranchBudget.Rows[9].Cells[0].Text = drBrFFAData[0]["FiscalYear"].ToString();
            tblBranchBudget.Rows[9].Cells[1].Text = "Corp Fcst";
            tblBranchBudget.Rows[9].Cells[2].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["SepGMPct"].ToString()));
            tblBranchBudget.Rows[9].Cells[3].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["OctGMPct"].ToString()));
            tblBranchBudget.Rows[9].Cells[4].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["NovGMPct"].ToString()));
            tblBranchBudget.Rows[9].Cells[5].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["DecGMPct"].ToString()));

            tblBranchBudget.Rows[9].Cells[6].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["JanGMPct"].ToString()));
            tblBranchBudget.Rows[9].Cells[7].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["FebGMPct"].ToString()));
            tblBranchBudget.Rows[9].Cells[8].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["MarGMPct"].ToString()));
            tblBranchBudget.Rows[9].Cells[9].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["AprGMPct"].ToString()));

            tblBranchBudget.Rows[9].Cells[10].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["MayGMPct"].ToString()));
            tblBranchBudget.Rows[9].Cells[11].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["JunGMPct"].ToString()));
            tblBranchBudget.Rows[9].Cells[12].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["JulGMPct"].ToString()));
            tblBranchBudget.Rows[9].Cells[13].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["AugGMPct"].ToString()));

            tblBranchBudget.Rows[9].Cells[14].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["AnnualGMPct"].ToString()));
        }

        #endregion

        #region Year 3 - Branch Forecasted GM Pct Row

        if (drBrFCData != null && drBrFCData.Length > 0)
        {
            tblBranchBudget.Rows[10].Attributes["onmouseover"] = MouseOverStyle;
            tblBranchBudget.Rows[10].Attributes["onmouseout"] = MouseOutStyle;

            tblBranchBudget.Rows[10].Cells[0].Text = drBrFCData[0]["FiscalYear"].ToString();
            tblBranchBudget.Rows[10].Cells[1].Text = "Branch Fcst";
            tblBranchBudget.Rows[10].Cells[2].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["SepGMPct"].ToString()));
            tblBranchBudget.Rows[10].Cells[3].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["OctGMPct"].ToString()));
            tblBranchBudget.Rows[10].Cells[4].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["NovGMPct"].ToString()));
            tblBranchBudget.Rows[10].Cells[5].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["DecGMPct"].ToString()));

            tblBranchBudget.Rows[10].Cells[6].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["JanGMPct"].ToString()));
            tblBranchBudget.Rows[10].Cells[7].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["FebGMPct"].ToString()));
            tblBranchBudget.Rows[10].Cells[8].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["MarGMPct"].ToString()));
            tblBranchBudget.Rows[10].Cells[9].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["AprGMPct"].ToString()));

            tblBranchBudget.Rows[10].Cells[10].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["MayGMPct"].ToString()));
            tblBranchBudget.Rows[10].Cells[11].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["JunGMPct"].ToString()));
            tblBranchBudget.Rows[10].Cells[12].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["JulGMPct"].ToString()));
            tblBranchBudget.Rows[10].Cells[13].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["AugGMPct"].ToString()));

            tblBranchBudget.Rows[10].Cells[14].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["AnnualGMPct"].ToString()));
        }

        #endregion

        #region Year 3 - Forcast GM Variance Pct

        if (drBrFFAData != null && drBrFFAData.Length > 0 )
        {
            tblBranchBudget.Rows[11].Attributes["onmouseover"] = MouseOverStyle;
            tblBranchBudget.Rows[11].Attributes["onmouseout"] = MouseOutStyle;

            tblBranchBudget.Rows[11].Cells[0].Text = drBrFFAData[0]["FiscalYear"].ToString();
            tblBranchBudget.Rows[11].Cells[1].Text = "Variance Pct";

            decimal _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["SepGMPct"].ToString());
            decimal _BranchFSales = Convert.ToDecimal(drBrFCData[0]["SepGMPct"].ToString());
            decimal _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[11].Cells[2].Text = _variancePct.ToString("N2");


            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["OctGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["OctGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[11].Cells[3].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["NovGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["NovGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[11].Cells[4].Text = _variancePct.ToString("N2");


            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["DecGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["DecGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[11].Cells[5].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["JanGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["JanGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[11].Cells[6].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["FebGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["FebGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[11].Cells[7].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["MarGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["MarGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[11].Cells[8].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["AprGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["AprGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[11].Cells[9].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["MayGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["MayGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[11].Cells[10].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["JunGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["JunGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[11].Cells[11].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["JulGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["JulGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[11].Cells[12].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["AugGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["AugGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[11].Cells[13].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["AnnualGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["AnnualGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[11].Cells[14].Text = _variancePct.ToString("N2");
        }

        #endregion
        
    }

    #endregion

    #region Excel Export Options

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        string _excelData = GenerateExportData("Excel");

        FileInfo fnExcel = new FileInfo(Server.MapPath(excelFilePath + hidFileName.Value.ToString()));             
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();        
        reportWriter.WriteLine(_excelData);
        reportWriter.Close();

        // Downloding Process
        FileStream fileStream = File.Open(Server.MapPath(excelFilePath + hidFileName.Value.ToString()), FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        // Download Process
        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath(excelFilePath + hidFileName.Value.ToString())));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }

    private string GenerateExportData(string dataFormat)
    {
        DataSet dsBranches = customerBudget.GetCustomerBudgetData("getbudgetbranches", "");

        string styleSheet = "<style>.text { mso-number-format:\\@; } </style>";
        string headerContent = string.Empty;
        string branchTableContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;

        // Step 1: Create Report Header
        headerContent  =    "<table border='1' width='100%'>";
        headerContent +=    "<tr><th colspan='16' style='color:blue' align=left><center>Branch Sales Forecast Report</center></th></tr>";      
        headerContent +=    "<tr><th colspan='16' style='color:blue' align=left></th></tr>";
        if (dsBranches != null)
        {
            DataTable dtBranchHdr = dsBranches.Tables[0];
            foreach (DataRow drBranchHdr in dtBranchHdr.Rows)
            {

                DataSet _dsBrBudgetData = customerBudget.GetCustomerBudgetReport(drBranchHdr["LocID"].ToString(), "", "", "", "BRANCH", sortType, "yes", "");

                branchTableContent += CreateBranchTableExcelContent(_dsBrBudgetData.Tables[0], drBranchHdr["LocDisp"].ToString());
            }

        }
        else
        {
            excelContent = "<tr  ><th width='100%' align ='center' colspan='18' > No records found</th></tr> </table>";
        }      

        return  styleSheet + 
                headerContent + 
                branchTableContent +
                excelContent;        
    }
    
    private string CreateBranchTableExcelContent(DataTable dtBranchBudget,string branchName)
    {
        string branchTableContent = string.Empty;


        branchTableContent = "<table border='1' width='100%'>";
        branchTableContent += "<tr><th colspan='16' align=left style='color:blue;font-weight:bold;'>" + branchName + "</th></tr>";
        branchTableContent += "<tr style='font-weight:bold;'>" +
                                    "<td align=center>Fiscal Year</td><td align=center>Type</td>" +
                                    "<td align=right>Sep</td><td align=right>Oct</td><td align=right>Nov</td><td align=right>Dec</td>" +
                                    "<td align=right>Jan</td><td align=right>Feb</td><td align=right>Mar</td><td align=right>Apr</td>" +
                                    "<td align=right>May</td><td align=right>Jun</td><td align=right>Jul</td><td align=right>Aug</td>" +
                                    "<td align=center>Annual</td><td align=center>Growth %</td>" +
                                "</tr>";

        #region Create Sales Dollar Rows

        #region 2010  A-Sales

        branchTableContent += "<tr>" +
                                    "<td align=center>" + dtBranchBudget.Rows[0]["FiscalYear"].ToString() + "</td><td align=center>A-Sales</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["SepSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["OctSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["NovSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["DecSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["JanSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["FebSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["MarSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["AprSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["MaySales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["JunSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["JulSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["AugSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["AnnualSalesAmt"].ToString())) + "</td>" +
                                    "<td align=right></td>" +
                                "</tr>";

        #endregion

        #region 2011  A-Sales

        // Formula = ( (2011 - 2010) / 2010 ) * 100
        decimal _lastYearSales = Convert.ToDecimal(dtBranchBudget.Rows[0]["AnnualSalesAmt"].ToString());
        decimal _currentYearSales = Convert.ToDecimal(dtBranchBudget.Rows[1]["AnnualSalesAmt"].ToString());
        decimal _growthPct = (_lastYearSales == 0 ? 0 : (((_currentYearSales - _lastYearSales) / _lastYearSales) * 100));

        branchTableContent += "<tr>" +
                                    "<td align=center>" + dtBranchBudget.Rows[1]["FiscalYear"].ToString() + "</td><td align=center>A-Sales</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["SepSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["OctSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["NovSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["DecSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["JanSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["FebSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["MarSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["AprSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["MaySales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["JunSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["JulSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["AugSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["AnnualSalesAmt"].ToString())) + "</td>" +
                                    "<td align=right>" + Math.Round(_growthPct, 1).ToString() + "</td>" +
                                "</tr>";

        #endregion

        #region 2012  FFA-Sales

        DataRow[] drBrFFAData = dtBranchBudget.Select("RecordType='FFA'");
        if (drBrFFAData.Length > 0)
        {
            branchTableContent += "<tr>" +
                                        "<td align=center>" + drBrFFAData[0]["FiscalYear"].ToString() + "</td><td align=center>Fixed F-Sales</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["SepSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["OctSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["NovSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["DecSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["JanSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["FebSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["MarSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["AprSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["MaySales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["JunSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["JulSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["AugSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFFAData[0]["AnnualSalesAmt"].ToString())) + "</td>" +
                                        "<td align=right></td>" +
                                    "</tr>";
        }
        #endregion

        #region 2012  F-Sales
        DataRow[] drBrFCData = dtBranchBudget.Select("RecordType='F'");
        if (drBrFCData.Length > 0)
        {
            _lastYearSales = Convert.ToDecimal(dtBranchBudget.Rows[1]["AnnualSalesAmt"].ToString());
            _currentYearSales = Convert.ToDecimal(drBrFCData[0]["AnnualSalesAmt"].ToString());
            _growthPct = (_lastYearSales == 0 ? 0 : (((_currentYearSales - _lastYearSales) / _lastYearSales) * 100));

            branchTableContent += "<tr>" +
                                        "<td align=center>" + drBrFCData[0]["FiscalYear"].ToString() + "</td><td align=center>Branch F-Sales</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["SepSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["OctSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["NovSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["DecSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["JanSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["FebSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["MarSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["AprSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["MaySales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["JunSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["JulSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["AugSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBrFCData[0]["AnnualSalesAmt"].ToString())) + "</td>" +
                                        "<td align=right>" + Math.Round(_growthPct, 1).ToString() + "</td>" +
                                    "</tr>";
        }
        #endregion

        #region 2012 Variance Pct

        decimal _fixedFSales;
        decimal _BranchFSales;
        decimal _variancePct;

        if (drBrFFAData.Length > 0)
        {
            branchTableContent += "<tr><td align=center>" + drBrFFAData[0]["FiscalYear"].ToString() + "</td><td align=center>Variance Pct</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["SepSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["SepSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["OctSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["OctSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["NovSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["NovSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["DecSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["DecSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["JanSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["JanSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["FebSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["FebSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["MarSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["MarSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["AprSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["AprSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["MaySales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["MaySales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["JunSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["JunSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["JulSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["JulSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["AugSales"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["AugSales"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["AnnualSalesAmt"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["AnnualSalesAmt"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            branchTableContent += "<td align=right></td></tr>";
        }

        branchTableContent += "<tr><th colspan='16' align=left></th></tr>";


        #endregion

        #endregion

        #region Create GM Pct Rows

        #region 2010  A - GM Pct

        branchTableContent += "<tr>" +
                                    "<td align=center>" + dtBranchBudget.Rows[0]["FiscalYear"].ToString() + "</td><td align=center>A-GM Pct</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["SepGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["OctGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["NovGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["DecGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["JanGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["FebGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["MarGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["AprGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["MayGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["JunGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["JulGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["AugGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[0]["AnnualGMPct"].ToString())) + "</td>" +
                                    "<td align=right></td>" +
                                "</tr>";
        #endregion

        #region 2011  A-GM Pct
        branchTableContent += "<tr>" +
                                    "<td align=center>" + dtBranchBudget.Rows[1]["FiscalYear"].ToString() + "</td><td align=center>A-GM Pct</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["SepGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["OctGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["NovGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["DecGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["JanGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["FebGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["MarGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["AprGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["MayGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["JunGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["JulGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["AugGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchBudget.Rows[1]["AnnualGMPct"].ToString())) + "</td>" +
                                    "<td align=right></td>" +
                                "</tr>";
        #endregion

        #region 2012  Fixed F-GM Pct

        if (drBrFFAData.Length > 0)
        {
            branchTableContent += "<tr>" +
                                        "<td align=center>" + drBrFFAData[0]["FiscalYear"].ToString() + "</td><td align=center>Fixed F-GM Pct</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["SepGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["OctGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["NovGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["DecGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["JanGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["FebGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["MarGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["AprGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["MayGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["JunGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["JulGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["AugGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["AnnualGMPct"].ToString())) + "</td>" +
                                        "<td align=right></td>" +
                                    "</tr>";
        }

        #endregion

        #region 2012 Branch GM-Pct

        if (drBrFCData.Length > 0)
        {
            branchTableContent += "<tr>" +
                                        "<td align=center>" + drBrFCData[0]["FiscalYear"].ToString() + "</td><td align=center>Branch F-GM Pct</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["SepGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["OctGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["NovGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["DecGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["JanGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["FebGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["MarGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["AprGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["MayGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["JunGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["JulGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["AugGMPct"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["AnnualGMPct"].ToString())) + "</td>" +
                                        "<td align=right></td>" +
                                    "</tr>";
        }
        #endregion

        #region 2012 Variance GM Pct

        if (drBrFFAData.Length > 0)
        {
            branchTableContent += "<tr><td align=center>" + drBrFFAData[0]["FiscalYear"].ToString() + "</td><td align=center>Variance Pct</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["SepGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["SepGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["OctGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["OctGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["NovGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["NovGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["DecGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["DecGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["JanGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["JanGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["FebGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["FebGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["MarGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["MarGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["AprGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["AprGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["MayGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["MayGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["JunGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["JunGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["JulGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["JulGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["AugGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["AugGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["AnnualGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["AnnualGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            branchTableContent += "<td align=right>" + _variancePct.ToString("N2") + "</td>";

            branchTableContent += "<td align=right></td></tr>";
        }

        branchTableContent += "<tr><th colspan='16' align=left></th></tr>";

        #endregion


        branchTableContent += "<tr><th colspan='16' align=left></th></tr>";

        #endregion

        return branchTableContent;

    }

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath(excelFilePath));

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


