using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Globalization;
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

public partial class CustNextYearBudgetReport : System.Web.UI.Page
{
    # region Variable Declaration

    CustomerBudget customerBudget = new CustomerBudget();    
    DataTable dtExcelData = new DataTable();
    DataSet dsCustBudgetData = new DataSet();
    GridView gvExportExcel = new GridView();

    int pageCount = 1;
    string border = "0";// Border is a dynamic variable because we need to print grid headers without border
    string branchCd = "";
    string branchDesc = "";
    string salesRepNo = "";
    string salesRepDesc = "";    
    string chainCd = "";
    string chainDesc = "";
    string custNo = "";    
    string sortExpression = string.Empty;    
    string excelFilePath = "../Common/ExcelUploads/";
    bool DisplayBranchGrid = false;
    string MouseOverStyle = "this.style.backgroundColor='#FFFFCC'";
    string MouseOutStyle = "this.style.backgroundColor='white';";
    string sortType = "SalesDol";
    string SummaryRptType = "";
    string ShowFSNL = "";

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Cache.SetCacheability(HttpCacheability.NoCache);

        branchCd = Request.QueryString["BranchCd"].ToString();
        branchDesc = Request.QueryString["BranchDesc"].ToString();
        salesRepNo = Request.QueryString["SalesRepNo"].ToString();
        salesRepDesc = Request.QueryString["SalesRepDesc"].ToString();
        chainCd = Request.QueryString["ChainCd"].ToString();
        chainDesc = Request.QueryString["ChainDesc"].ToString();
        custNo = Request.QueryString["CustNo"].ToString();
        sortType = Request.QueryString["SortType"].ToString();
        SummaryRptType = Request.QueryString["SummaryReportType"].ToString();
        ShowFSNL = Request.QueryString["ShowFSNL"].ToString();

        if (chainCd == "" && custNo == "" && salesRepNo == "")
        {
            DisplayBranchGrid = true;
            tblBranchBudget.Visible = true;
            tblSalesRepBudget.Visible = false;
        }
        else
        {
            tblBranchBudget.Visible = false;
            tblSalesRepBudget.Visible = true;
        }

        if (!IsPostBack)
        {
            Session["CustBudgetData"] = null;

            DataSet dsFicalCal = customerBudget.GetNextYearFiscalPeriod();
            if (dsFicalCal != null && dsFicalCal.Tables[0].Rows.Count > 0)
            {
                ViewState["FiscalPeriod"] = dsFicalCal.Tables[0].Rows[0]["FiscalPeriod"].ToString();
                ViewState["FiscalYear"] = dsFicalCal.Tables[0].Rows[0]["FiscalYear"].ToString();
            }
            else
            {
                ViewState["FiscalPeriod"] = "0";
                ViewState["FiscalYear"] = "0";
            }
            hidFileName.Value = "CustomerForecastReport" + Session["SessionID"].ToString() + ".xls";

            lblInsideRep.Text = (salesRepDesc == "" ? "ALL" : salesRepDesc);
            lblBranch.Text = branchDesc;            
            BindDataGrid();
        }
        Ajax.Utility.RegisterTypeForAjax(typeof(CustNextYearBudgetReport));
    }

    #region Bind Customer Sales Grid

    private void BindDataGrid()
    {
        dsCustBudgetData = customerBudget.GetCustomerNextYearReport(branchCd, salesRepNo, chainCd, custNo, SummaryRptType, sortType, "no", ShowFSNL);                
        
        if (dsCustBudgetData != null)
        {

            DataTable dtCustBudgetData = dsCustBudgetData.Tables[0];
            if (dtCustBudgetData != null && dtCustBudgetData.Rows.Count > 0)
            {
                gvCustBudget.DataSource = dtCustBudgetData;
                //gvCustBudget.DataBind();
                pager.InitPager(gvCustBudget, pageCount);

                if (DisplayBranchGrid)
                {
                    BindBranchSummaryGrid(dsCustBudgetData.Tables[2]);
                    lblBranchCaption.Text = branchDesc + " Branch";   
                }
                else
                {
                    BindSalesRepOrChainGrid(dsCustBudgetData.Tables[2]);
                    
                    if (SummaryRptType == "SALESREP" && custNo == "")
                        lblBranchCaption.Text = lblInsideRep.Text;
                    else if (SummaryRptType == "SALESREP" && custNo != "")
                        lblBranchCaption.Text = dtCustBudgetData.Rows[0]["InsideSalesRep"].ToString();
                    else
                        lblBranchCaption.Text = chainDesc;
                }
                                
                if (branchCd == "" && lblBranch.Text == "")
                {
                    lblBranch.Text = dtCustBudgetData.Rows[0]["LocID"].ToString() + " - " + dtCustBudgetData.Rows[0]["LocName"].ToString();
                    pnlBranchDesc.Update();
                }
            }
            else
            {
                tdBranchGridHdr.Visible = false;
                tblBranchBudget.Visible = false;
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
            Label _lblCustNo = e.Row.FindControl("lblCustNo") as Label;
            HiddenField _hidBranchName = e.Row.FindControl("hidBranchName") as HiddenField;
            HiddenField _hidBranchId = e.Row.FindControl("hidBranchId") as HiddenField;

            Table _tblCustBudget = e.Row.FindControl("tblCustBudget") as Table;           

            if (_tblCustBudget != null)
            {
                // Filter the record set to single customer
                dsCustBudgetData.Tables[1].DefaultView.RowFilter = "CustNo='" + _lblCustNo.Text + "'";
                dsCustBudgetData.Tables[1].DefaultView.Sort = "RecordType Asc";
                DataTable dtBranchSalesDol = dsCustBudgetData.Tables[1].DefaultView.ToTable();
                int _fiscalPeriod = Convert.ToInt32(ViewState["FiscalPeriod"].ToString());
                int _fiscalYear = Convert.ToInt32(ViewState["FiscalYear"].ToString());
                _lblCustNo.Attributes.Add("onclick", "ShowCatPriceSchedule('" + _lblCustNo.Text + "');");
                lblBranch.Text = _hidBranchId.Value + " - " + _hidBranchName.Value;
                pnlBranchDesc.Update();
                #region Year 1 - Sales Dollar Row

                _tblCustBudget.Rows[1].Cells[0].Text = dtBranchSalesDol.Rows[0]["FiscalYear"].ToString();
                _tblCustBudget.Rows[1].Cells[1].Text = "Actual";
                _tblCustBudget.Rows[1].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["SepSales"].ToString()));
                _tblCustBudget.Rows[1].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["OctSales"].ToString()));
                _tblCustBudget.Rows[1].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["NovSales"].ToString()));
                _tblCustBudget.Rows[1].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["DecSales"].ToString()));

                _tblCustBudget.Rows[1].Cells[6].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["JanSales"].ToString()));
                _tblCustBudget.Rows[1].Cells[7].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["FebSales"].ToString()));
                _tblCustBudget.Rows[1].Cells[8].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["MarSales"].ToString()));
                _tblCustBudget.Rows[1].Cells[9].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["AprSales"].ToString()));

                _tblCustBudget.Rows[1].Cells[10].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["MaySales"].ToString()));
                _tblCustBudget.Rows[1].Cells[11].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["JunSales"].ToString()));
                _tblCustBudget.Rows[1].Cells[12].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["JulSales"].ToString()));
                _tblCustBudget.Rows[1].Cells[13].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["AugSales"].ToString()));

                _tblCustBudget.Rows[1].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["AnnualSalesAmt"].ToString()));

                #endregion

                #region Year 2 - Sales Dollar Row

                _tblCustBudget.Rows[2].Cells[0].Text = dtBranchSalesDol.Rows[1]["FiscalYear"].ToString();
                _tblCustBudget.Rows[2].Cells[1].Text = (dtBranchSalesDol.Rows[1]["RecordType"].ToString() == "AC" ? "Actual" : "Act Fcst");
                HiddenField _hidLYpCustSalForecastId = _tblCustBudget.Rows[3].Cells[2].FindControl("hidLYpCustSalForecastId") as HiddenField;
                _hidLYpCustSalForecastId.Value = dtBranchSalesDol.Rows[1]["pCustSalesNextYearForecastID"].ToString();

                _tblCustBudget.Rows[2].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["SepSales"].ToString()));
                _tblCustBudget.Rows[2].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["OctSales"].ToString()));
                _tblCustBudget.Rows[2].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["NovSales"].ToString()));
                _tblCustBudget.Rows[2].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["DecSales"].ToString()));

                _tblCustBudget.Rows[2].Cells[6].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["JanSales"].ToString()));
                _tblCustBudget.Rows[2].Cells[7].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["FebSales"].ToString()));
                _tblCustBudget.Rows[2].Cells[8].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["MarSales"].ToString()));
                _tblCustBudget.Rows[2].Cells[9].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["AprSales"].ToString()));

                _tblCustBudget.Rows[2].Cells[10].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["MaySales"].ToString()));
                _tblCustBudget.Rows[2].Cells[11].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["JunSales"].ToString()));
                _tblCustBudget.Rows[2].Cells[12].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["JulSales"].ToString()));
                _tblCustBudget.Rows[2].Cells[13].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["AugSales"].ToString()));

                _tblCustBudget.Rows[2].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["AnnualSalesAmt"].ToString()));

                #endregion

                #region Year 3 - Sales Dollar Row (Forecast Row)

                _tblCustBudget.Rows[3].Cells[0].Text = dtBranchSalesDol.Rows[2]["FiscalYear"].ToString();
                _tblCustBudget.Rows[3].Cells[1].Text = "Forecast";
                HiddenField _hidpCustSalForecastId = _tblCustBudget.Rows[3].Cells[2].FindControl("hidpCustSalForecastId") as HiddenField;
                _hidpCustSalForecastId.Value = dtBranchSalesDol.Rows[2]["pCustSalesNextYearForecastID"].ToString();
                int _custBudgetFiscalYear = Convert.ToInt32(_tblCustBudget.Rows[3].Cells[0].Text);

                PFCTextBox _txtDolFYearSep = _tblCustBudget.Rows[3].Cells[2].FindControl("txtDolFYearSep") as PFCTextBox;
                _txtDolFYearSep.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["SepSales"].ToString()));
                PFCTextBox _txtDolFYearOct = _tblCustBudget.Rows[3].Cells[3].FindControl("txtDolFYearOct") as PFCTextBox;
                _txtDolFYearOct.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["OctSales"].ToString()));
                PFCTextBox _txtDolFYearNov = _tblCustBudget.Rows[3].Cells[4].FindControl("txtDolFYearNov") as PFCTextBox;
                _txtDolFYearNov.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["NovSales"].ToString()));
                PFCTextBox _txtDolFYearDec = _tblCustBudget.Rows[3].Cells[5].FindControl("txtDolFYearDec") as PFCTextBox;
                _txtDolFYearDec.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["DecSales"].ToString()));

                PFCTextBox _txtDolFYearJan = _tblCustBudget.Rows[3].Cells[6].FindControl("txtDolFYearJan") as PFCTextBox;
                _txtDolFYearJan.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["JanSales"].ToString()));
                PFCTextBox _txtDolFYearFeb = _tblCustBudget.Rows[3].Cells[7].FindControl("txtDolFYearFeb") as PFCTextBox;
                _txtDolFYearFeb.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["FebSales"].ToString()));
                PFCTextBox _txtDolFYearMar = _tblCustBudget.Rows[3].Cells[8].FindControl("txtDolFYearMar") as PFCTextBox;
                _txtDolFYearMar.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["MarSales"].ToString()));
                PFCTextBox _txtDolFYearApr = _tblCustBudget.Rows[3].Cells[9].FindControl("txtDolFYearApr") as PFCTextBox;
                _txtDolFYearApr.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["AprSales"].ToString()));
                

                PFCTextBox _txtDolFYearMay = _tblCustBudget.Rows[3].Cells[10].FindControl("txtDolFYearMay") as PFCTextBox;
                _txtDolFYearMay.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["MaySales"].ToString()));
                PFCTextBox _txtDolFYearJun = _tblCustBudget.Rows[3].Cells[11].FindControl("txtDolFYearJun") as PFCTextBox;
                _txtDolFYearJun.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["JunSales"].ToString()));
                PFCTextBox _txtDolFYearJul = _tblCustBudget.Rows[3].Cells[12].FindControl("txtDolFYearJul") as PFCTextBox;
                _txtDolFYearJul.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["JulSales"].ToString()));
                PFCTextBox _txtDolFYearAug = _tblCustBudget.Rows[3].Cells[13].FindControl("txtDolFYearAug") as PFCTextBox;
                _txtDolFYearAug.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["AugSales"].ToString()));
                
                _tblCustBudget.Rows[3].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["AnnualSalesAmt"].ToString()));

                //if (_fiscalYear == _custBudgetFiscalYear)
                //{
                //    _txtDolFYearSep.ReadOnly = (_fiscalPeriod <= 1 ? false : true);
                //    _txtDolFYearOct.ReadOnly = (_fiscalPeriod <= 2 ? false : true);
                //    _txtDolFYearNov.ReadOnly = (_fiscalPeriod <= 3 ? false : true);
                //    _txtDolFYearDec.ReadOnly = (_fiscalPeriod <= 4 ? false : true);

                //    _txtDolFYearJan.ReadOnly = (_fiscalPeriod <= 5 ? false : true);
                //    _txtDolFYearFeb.ReadOnly = (_fiscalPeriod <= 6 ? false : true);
                //    _txtDolFYearMar.ReadOnly = (_fiscalPeriod <= 7 ? false : true);
                //    _txtDolFYearApr.ReadOnly = (_fiscalPeriod <= 8 ? false : true);

                //    _txtDolFYearMay.ReadOnly = (_fiscalPeriod <= 9 ? false : true);
                //    _txtDolFYearJun.ReadOnly = (_fiscalPeriod <= 10 ? false : true);
                //    _txtDolFYearJul.ReadOnly = (_fiscalPeriod <= 11 ? false : true);
                //    _txtDolFYearAug.ReadOnly = (_fiscalPeriod <= 12 ? false : true);
                //}

                #endregion

                #region Daily Forecast Row

                decimal FrcstPerDay;
                DataRow DaysRow = dsCustBudgetData.Tables[3].Rows[0];
                _tblCustBudget.Rows[4].Cells[0].Text = "";
                _tblCustBudget.Rows[4].Cells[1].Text = "Per Day";

                _tblCustBudget.Rows[0].Cells[2].ToolTip = DaysRow["SepDays"].ToString() + " Days";
                _tblCustBudget.Rows[0].Cells[3].ToolTip = DaysRow["OctDays"].ToString() + " Days";
                _tblCustBudget.Rows[0].Cells[4].ToolTip = DaysRow["NovDays"].ToString() + " Days";
                _tblCustBudget.Rows[0].Cells[5].ToolTip = DaysRow["DecDays"].ToString() + " Days";
                _tblCustBudget.Rows[0].Cells[6].ToolTip = DaysRow["JanDays"].ToString() + " Days";
                _tblCustBudget.Rows[0].Cells[7].ToolTip = DaysRow["FebDays"].ToString() + " Days";
                _tblCustBudget.Rows[0].Cells[8].ToolTip = DaysRow["MarDays"].ToString() + " Days";
                _tblCustBudget.Rows[0].Cells[9].ToolTip = DaysRow["AprDays"].ToString() + " Days";
                _tblCustBudget.Rows[0].Cells[10].ToolTip = DaysRow["MayDays"].ToString() + " Days";
                _tblCustBudget.Rows[0].Cells[11].ToolTip = DaysRow["JunDays"].ToString() + " Days";
                _tblCustBudget.Rows[0].Cells[12].ToolTip = DaysRow["JulDays"].ToString() + " Days";
                _tblCustBudget.Rows[0].Cells[13].ToolTip = DaysRow["AugDays"].ToString() + " Days";
                _tblCustBudget.Rows[0].Cells[14].ToolTip = DaysRow["TotalDays"].ToString() + " Days";

                FrcstPerDay = (decimal)dtBranchSalesDol.Rows[2]["SepSales"] / (int)DaysRow["SepDays"];
                _tblCustBudget.Rows[4].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(FrcstPerDay.ToString()));
                FrcstPerDay = (decimal)dtBranchSalesDol.Rows[2]["OctSales"] / (int)DaysRow["OctDays"];
                _tblCustBudget.Rows[4].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(FrcstPerDay.ToString()));
                FrcstPerDay = (decimal)dtBranchSalesDol.Rows[2]["NovSales"] / (int)DaysRow["NovDays"];
                _tblCustBudget.Rows[4].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(FrcstPerDay.ToString()));
                FrcstPerDay = (decimal)dtBranchSalesDol.Rows[2]["DecSales"] / (int)DaysRow["DecDays"];
                _tblCustBudget.Rows[4].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(FrcstPerDay.ToString()));

                FrcstPerDay = (decimal)dtBranchSalesDol.Rows[2]["JanSales"] / (int)DaysRow["JanDays"];
                _tblCustBudget.Rows[4].Cells[6].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(FrcstPerDay.ToString()));
                FrcstPerDay = (decimal)dtBranchSalesDol.Rows[2]["FebSales"] / (int)DaysRow["FebDays"];
                _tblCustBudget.Rows[4].Cells[7].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(FrcstPerDay.ToString()));
                FrcstPerDay = (decimal)dtBranchSalesDol.Rows[2]["MarSales"] / (int)DaysRow["MarDays"];
                _tblCustBudget.Rows[4].Cells[8].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(FrcstPerDay.ToString()));
                FrcstPerDay = (decimal)dtBranchSalesDol.Rows[2]["AprSales"] / (int)DaysRow["AprDays"];
                _tblCustBudget.Rows[4].Cells[9].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(FrcstPerDay.ToString()));

                FrcstPerDay = (decimal)dtBranchSalesDol.Rows[2]["MaySales"] / (int)DaysRow["MayDays"];
                _tblCustBudget.Rows[4].Cells[10].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(FrcstPerDay.ToString()));
                FrcstPerDay = (decimal)dtBranchSalesDol.Rows[2]["JunSales"] / (int)DaysRow["JunDays"];
                _tblCustBudget.Rows[4].Cells[11].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(FrcstPerDay.ToString()));
                FrcstPerDay = (decimal)dtBranchSalesDol.Rows[2]["JulSales"] / (int)DaysRow["JulDays"];
                _tblCustBudget.Rows[4].Cells[12].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(FrcstPerDay.ToString()));
                FrcstPerDay = (decimal)dtBranchSalesDol.Rows[2]["AugSales"] / (int)DaysRow["AugDays"];
                _tblCustBudget.Rows[4].Cells[13].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(FrcstPerDay.ToString()));

                FrcstPerDay = (decimal)dtBranchSalesDol.Rows[2]["AnnualSalesAmt"] / (int)DaysRow["TotalDays"];
                _tblCustBudget.Rows[4].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(FrcstPerDay.ToString()));
  
                #endregion

                #region Growth % Calculation

                // Formula = ( (2011 - 2010) / 2010 ) * 100
                decimal _lastYearSales = Convert.ToDecimal(dtBranchSalesDol.Rows[0]["AnnualSalesAmt"].ToString());
                decimal _currentYearSales = Convert.ToDecimal(dtBranchSalesDol.Rows[1]["AnnualSalesAmt"].ToString());
                decimal _growthPct = (_lastYearSales == 0 ? 0 : (((_currentYearSales - _lastYearSales) / _lastYearSales) * 100));
                _tblCustBudget.Rows[2].Cells[15].Text = Math.Round(_growthPct, 1).ToString(); // For 2011


                PFCTextBox _txtDolFYearGrowthPct = _tblCustBudget.Rows[3].Cells[15].FindControl("txtDolFYearGrowthPct") as PFCTextBox;
                _lastYearSales = Convert.ToDecimal(dtBranchSalesDol.Rows[1]["AnnualSalesAmt"].ToString());
                _currentYearSales = Convert.ToDecimal(dtBranchSalesDol.Rows[2]["AnnualSalesAmt"].ToString());
                _growthPct = (_lastYearSales == 0 ? 0 : (((_currentYearSales - _lastYearSales) / _lastYearSales) * 100));
                _txtDolFYearGrowthPct.Text = Math.Round(_growthPct, 1).ToString(); // For 2012

                #endregion

                #region Year 1 - Pct Row

                _tblCustBudget.Rows[5].Cells[0].Text = dtBranchSalesDol.Rows[0]["FiscalYear"].ToString();
                _tblCustBudget.Rows[5].Cells[1].Text = "Actual";
                _tblCustBudget.Rows[5].Cells[2].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["SepGMPct"].ToString()));
                _tblCustBudget.Rows[5].Cells[3].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["OctGMPct"].ToString()));
                _tblCustBudget.Rows[5].Cells[4].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["NovGMPct"].ToString()));
                _tblCustBudget.Rows[5].Cells[5].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["DecGMPct"].ToString()));

                _tblCustBudget.Rows[5].Cells[6].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["JanGMPct"].ToString()));
                _tblCustBudget.Rows[5].Cells[7].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["FebGMPct"].ToString()));
                _tblCustBudget.Rows[5].Cells[8].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["MarGMPct"].ToString()));
                _tblCustBudget.Rows[5].Cells[9].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["AprGMPct"].ToString()));

                _tblCustBudget.Rows[5].Cells[10].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["MayGMPct"].ToString()));
                _tblCustBudget.Rows[5].Cells[11].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["JunGMPct"].ToString()));
                _tblCustBudget.Rows[5].Cells[12].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["JulGMPct"].ToString()));
                _tblCustBudget.Rows[5].Cells[13].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["AugGMPct"].ToString()));

                _tblCustBudget.Rows[5].Cells[14].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[0]["AnnualGMPct"].ToString()));

                #endregion

                #region Year 2 - Pct Row

                _tblCustBudget.Rows[6].Cells[0].Text = dtBranchSalesDol.Rows[1]["FiscalYear"].ToString();
                _tblCustBudget.Rows[6].Cells[1].Text = (dtBranchSalesDol.Rows[1]["RecordType"].ToString() == "AC" ? "Actual" : "Act Fcst");
                //_tblCustBudget.Rows[6].Cells[1].Text = "Act Fcst";
                _tblCustBudget.Rows[6].Cells[2].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["SepGMPct"].ToString()));
                _tblCustBudget.Rows[6].Cells[3].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["OctGMPct"].ToString()));
                _tblCustBudget.Rows[6].Cells[4].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["NovGMPct"].ToString()));
                _tblCustBudget.Rows[6].Cells[5].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["DecGMPct"].ToString()));

                _tblCustBudget.Rows[6].Cells[6].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["JanGMPct"].ToString()));
                _tblCustBudget.Rows[6].Cells[7].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["FebGMPct"].ToString()));
                _tblCustBudget.Rows[6].Cells[8].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["MarGMPct"].ToString()));
                _tblCustBudget.Rows[6].Cells[9].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["AprGMPct"].ToString()));

                _tblCustBudget.Rows[6].Cells[10].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["MayGMPct"].ToString()));
                _tblCustBudget.Rows[6].Cells[11].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["JunGMPct"].ToString()));
                _tblCustBudget.Rows[6].Cells[12].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["JulGMPct"].ToString()));
                _tblCustBudget.Rows[6].Cells[13].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["AugGMPct"].ToString()));

                _tblCustBudget.Rows[6].Cells[14].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[1]["AnnualGMPct"].ToString()));

                #endregion

                #region Year 3 - Pct Row (Forecast Row)

                _tblCustBudget.Rows[7].Cells[1].Text = "Forecast";
                PFCTextBox _txtPctFYearSep = _tblCustBudget.Rows[7].Cells[2].FindControl("txtPctFYearSep") as PFCTextBox;
                _txtPctFYearSep.Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["SepGMPct"].ToString()));
                PFCTextBox _txtPctFYearOct = _tblCustBudget.Rows[7].Cells[2].FindControl("txtPctFYearOct") as PFCTextBox;
                _txtPctFYearOct.Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["OctGMPct"].ToString()));
                PFCTextBox _txtPctFYearNov = _tblCustBudget.Rows[7].Cells[2].FindControl("txtPctFYearNov") as PFCTextBox;
                _txtPctFYearNov.Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["NovGMPct"].ToString()));
                PFCTextBox _txtPctFYearDec = _tblCustBudget.Rows[7].Cells[2].FindControl("txtPctFYearDec") as PFCTextBox;
                _txtPctFYearDec.Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["DecGMPct"].ToString()));
                

                PFCTextBox _txtPctFYearJan = _tblCustBudget.Rows[7].Cells[2].FindControl("txtPctFYearJan") as PFCTextBox;
                _txtPctFYearJan.Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["JanGMPct"].ToString()));
                PFCTextBox _txtPctFYearFeb = _tblCustBudget.Rows[7].Cells[2].FindControl("txtPctFYearFeb") as PFCTextBox;
                _txtPctFYearFeb.Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["FebGMPct"].ToString()));
                PFCTextBox _txtPctFYearMar = _tblCustBudget.Rows[7].Cells[2].FindControl("txtPctFYearMar") as PFCTextBox;
                _txtPctFYearMar.Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["MarGMPct"].ToString()));
                PFCTextBox _txtPctFYearApr = _tblCustBudget.Rows[7].Cells[2].FindControl("txtPctFYearApr") as PFCTextBox;
                _txtPctFYearApr.Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["AprGMPct"].ToString()));
                
                PFCTextBox _txtPctFYearMay = _tblCustBudget.Rows[7].Cells[2].FindControl("txtPctFYearMay") as PFCTextBox;
                _txtPctFYearMay.Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["MayGMPct"].ToString()));
                PFCTextBox _txtPctFYearJun = _tblCustBudget.Rows[7].Cells[2].FindControl("txtPctFYearJun") as PFCTextBox;
                _txtPctFYearJun.Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["JunGMPct"].ToString()));
                PFCTextBox _txtPctFYearJul = _tblCustBudget.Rows[7].Cells[2].FindControl("txtPctFYearJul") as PFCTextBox;
                _txtPctFYearJul.Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["JulGMPct"].ToString()));
                PFCTextBox _txtPctFYearAug = _tblCustBudget.Rows[7].Cells[2].FindControl("txtPctFYearAug") as PFCTextBox;
                _txtPctFYearAug.Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["AugGMPct"].ToString()));
                
                _tblCustBudget.Rows[7].Cells[14].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchSalesDol.Rows[2]["AnnualGMPct"].ToString()));

                //if (_fiscalYear == _custBudgetFiscalYear)
                //{
                //    _txtPctFYearSep.ReadOnly = (_fiscalPeriod <= 1 ? false : true);
                //    _txtPctFYearOct.ReadOnly = (_fiscalPeriod <= 2 ? false : true);
                //    _txtPctFYearNov.ReadOnly = (_fiscalPeriod <= 3 ? false : true);
                //    _txtPctFYearDec.ReadOnly = (_fiscalPeriod <= 4 ? false : true);

                //    _txtPctFYearJan.ReadOnly = (_fiscalPeriod <= 5 ? false : true);
                //    _txtPctFYearFeb.ReadOnly = (_fiscalPeriod <= 6 ? false : true);
                //    _txtPctFYearMar.ReadOnly = (_fiscalPeriod <= 7 ? false : true);
                //    _txtPctFYearApr.ReadOnly = (_fiscalPeriod <= 8 ? false : true);

                //    _txtPctFYearMay.ReadOnly = (_fiscalPeriod <= 9 ? false : true);
                //    _txtPctFYearJun.ReadOnly = (_fiscalPeriod <= 10 ? false : true);
                //    _txtPctFYearJul.ReadOnly = (_fiscalPeriod <= 11 ? false : true);
                //    _txtPctFYearAug.ReadOnly = (_fiscalPeriod <= 12 ? false : true);
                //}

                #endregion

            }
        }
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        gvCustBudget.PageIndex = pager.GotoPageNumber;

        BindDataGrid();
    }

    #endregion

    #region Bind Branch Summary Grid

    private void BindBranchSummaryGrid(DataTable dtBranchdata)
    {

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

        if (drBrFFAData != null && drBrFFAData.Length > 0)
        {
            tblBranchBudget.Rows[5].Attributes["onmouseover"] = MouseOverStyle;
            tblBranchBudget.Rows[5].Attributes["onmouseout"] = MouseOutStyle;

            tblBranchBudget.Rows[5].Cells[0].Text = drBrFFAData[0]["FiscalYear"].ToString();

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

        #region Act Per Day

        DataRow[] drAdRecord = dtBranchdata.Select("RecordType='AD'");
        if (drAdRecord.Length > 0)
        {

            tblBranchBudget.Rows[6].Attributes["onmouseover"] = MouseOverStyle;
            tblBranchBudget.Rows[6].Attributes["onmouseout"] = MouseOutStyle;

            tblBranchBudget.Rows[6].Cells[0].Text = "";
            tblBranchBudget.Rows[6].Cells[1].Text = "Act Per Day";
            tblBranchBudget.Rows[6].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["SepSales"].ToString()));
            tblBranchBudget.Rows[6].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["OctSales"].ToString()));
            tblBranchBudget.Rows[6].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["NovSales"].ToString()));
            tblBranchBudget.Rows[6].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["DecSales"].ToString()));

            tblBranchBudget.Rows[6].Cells[6].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["JanSales"].ToString()));
            tblBranchBudget.Rows[6].Cells[7].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["FebSales"].ToString()));
            tblBranchBudget.Rows[6].Cells[8].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["MarSales"].ToString()));
            tblBranchBudget.Rows[6].Cells[9].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["AprSales"].ToString()));

            tblBranchBudget.Rows[6].Cells[10].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["MaySales"].ToString()));
            tblBranchBudget.Rows[6].Cells[11].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["JunSales"].ToString()));
            tblBranchBudget.Rows[6].Cells[12].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["JulSales"].ToString()));
            tblBranchBudget.Rows[6].Cells[13].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["AugSales"].ToString()));

            tblBranchBudget.Rows[6].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["AnnualSalesAmt"].ToString()));
        }

        #endregion

        #region Br Fcst Per Day

        DataRow[] drBDRecord = dtBranchdata.Select("RecordType='BD'");
        if (drBDRecord.Length > 0)
        {

            tblBranchBudget.Rows[7].Attributes["onmouseover"] = MouseOverStyle;
            tblBranchBudget.Rows[7].Attributes["onmouseout"] = MouseOutStyle;

            tblBranchBudget.Rows[7].Cells[0].Text = "";
            tblBranchBudget.Rows[7].Cells[1].Text = "Br Fcst Per Day";
            tblBranchBudget.Rows[7].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["SepSales"].ToString()));
            tblBranchBudget.Rows[7].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["OctSales"].ToString()));
            tblBranchBudget.Rows[7].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["NovSales"].ToString()));
            tblBranchBudget.Rows[7].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["DecSales"].ToString()));

            tblBranchBudget.Rows[7].Cells[6].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["JanSales"].ToString()));
            tblBranchBudget.Rows[7].Cells[7].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["FebSales"].ToString()));
            tblBranchBudget.Rows[7].Cells[8].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["MarSales"].ToString()));
            tblBranchBudget.Rows[7].Cells[9].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["AprSales"].ToString()));

            tblBranchBudget.Rows[7].Cells[10].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["MaySales"].ToString()));
            tblBranchBudget.Rows[7].Cells[11].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["JunSales"].ToString()));
            tblBranchBudget.Rows[7].Cells[12].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["JulSales"].ToString()));
            tblBranchBudget.Rows[7].Cells[13].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["AugSales"].ToString()));

            tblBranchBudget.Rows[7].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["AnnualSalesAmt"].ToString()));
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

        #region Empty Row

        tblBranchBudget.Rows[8].Cells[0].Text = "";
        tblBranchBudget.Rows[8].Cells[1].Text = "";
        tblBranchBudget.Rows[8].Cells[2].Text = "";
        tblBranchBudget.Rows[8].Cells[3].Text = "";
        tblBranchBudget.Rows[8].Cells[4].Text = "";
        tblBranchBudget.Rows[8].Cells[5].Text = "";

        tblBranchBudget.Rows[8].Cells[6].Text = "";
        tblBranchBudget.Rows[8].Cells[7].Text = "";
        tblBranchBudget.Rows[8].Cells[8].Text = "";
        tblBranchBudget.Rows[8].Cells[9].Text = "";

        tblBranchBudget.Rows[8].Cells[10].Text = "";
        tblBranchBudget.Rows[8].Cells[11].Text = "";
        tblBranchBudget.Rows[8].Cells[12].Text = "";
        tblBranchBudget.Rows[8].Cells[13].Text = "";

        tblBranchBudget.Rows[8].Cells[14].Text = "";
        #endregion

        #region Year 1 - GM Pct Row

        tblBranchBudget.Rows[9].Attributes["onmouseover"] = MouseOverStyle;
        tblBranchBudget.Rows[9].Attributes["onmouseout"] = MouseOutStyle;

        tblBranchBudget.Rows[9].Cells[0].Text = dtBranchdata.Rows[0]["FiscalYear"].ToString();
        tblBranchBudget.Rows[9].Cells[1].Text = "Actual";
        tblBranchBudget.Rows[9].Cells[2].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["SepGMPct"].ToString()));
        tblBranchBudget.Rows[9].Cells[3].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["OctGMPct"].ToString()));
        tblBranchBudget.Rows[9].Cells[4].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["NovGMPct"].ToString()));
        tblBranchBudget.Rows[9].Cells[5].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["DecGMPct"].ToString()));

        tblBranchBudget.Rows[9].Cells[6].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["JanGMPct"].ToString()));
        tblBranchBudget.Rows[9].Cells[7].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["FebGMPct"].ToString()));
        tblBranchBudget.Rows[9].Cells[8].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["MarGMPct"].ToString()));
        tblBranchBudget.Rows[9].Cells[9].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["AprGMPct"].ToString()));

        tblBranchBudget.Rows[9].Cells[10].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["MayGMPct"].ToString()));
        tblBranchBudget.Rows[9].Cells[11].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["JunGMPct"].ToString()));
        tblBranchBudget.Rows[9].Cells[12].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["JulGMPct"].ToString()));
        tblBranchBudget.Rows[9].Cells[13].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["AugGMPct"].ToString()));

        tblBranchBudget.Rows[9].Cells[14].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[0]["AnnualGMPct"].ToString()));

        #endregion

        #region Year 2 - GM Pct Row

        tblBranchBudget.Rows[10].Attributes["onmouseover"] = MouseOverStyle;
        tblBranchBudget.Rows[10].Attributes["onmouseout"] = MouseOutStyle;

        tblBranchBudget.Rows[10].Cells[0].Text = dtBranchdata.Rows[1]["FiscalYear"].ToString();
        tblBranchBudget.Rows[10].Cells[2].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["SepGMPct"].ToString()));
        tblBranchBudget.Rows[10].Cells[3].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["OctGMPct"].ToString()));
        tblBranchBudget.Rows[10].Cells[4].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["NovGMPct"].ToString()));
        tblBranchBudget.Rows[10].Cells[5].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["DecGMPct"].ToString()));

        tblBranchBudget.Rows[10].Cells[6].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["JanGMPct"].ToString()));
        tblBranchBudget.Rows[10].Cells[7].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["FebGMPct"].ToString()));
        tblBranchBudget.Rows[10].Cells[8].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["MarGMPct"].ToString()));
        tblBranchBudget.Rows[10].Cells[9].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["AprGMPct"].ToString()));

        tblBranchBudget.Rows[10].Cells[10].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["MayGMPct"].ToString()));
        tblBranchBudget.Rows[10].Cells[11].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["JunGMPct"].ToString()));
        tblBranchBudget.Rows[10].Cells[12].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["JulGMPct"].ToString()));
        tblBranchBudget.Rows[10].Cells[13].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["AugGMPct"].ToString()));

        tblBranchBudget.Rows[10].Cells[14].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtBranchdata.Rows[1]["AnnualGMPct"].ToString()));

        #endregion

        #region Year 3 - Fixed Forecasted GM Pct Row

        if (drBrFFAData != null && drBrFFAData.Length > 0)
        {
            tblBranchBudget.Rows[11].Attributes["onmouseover"] = MouseOverStyle;
            tblBranchBudget.Rows[11].Attributes["onmouseout"] = MouseOutStyle;

            tblBranchBudget.Rows[11].Cells[0].Text = drBrFFAData[0]["FiscalYear"].ToString();
            tblBranchBudget.Rows[11].Cells[2].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["SepGMPct"].ToString()));
            tblBranchBudget.Rows[11].Cells[3].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["OctGMPct"].ToString()));
            tblBranchBudget.Rows[11].Cells[4].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["NovGMPct"].ToString()));
            tblBranchBudget.Rows[11].Cells[5].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["DecGMPct"].ToString()));

            tblBranchBudget.Rows[11].Cells[6].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["JanGMPct"].ToString()));
            tblBranchBudget.Rows[11].Cells[7].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["FebGMPct"].ToString()));
            tblBranchBudget.Rows[11].Cells[8].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["MarGMPct"].ToString()));
            tblBranchBudget.Rows[11].Cells[9].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["AprGMPct"].ToString()));

            tblBranchBudget.Rows[11].Cells[10].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["MayGMPct"].ToString()));
            tblBranchBudget.Rows[11].Cells[11].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["JunGMPct"].ToString()));
            tblBranchBudget.Rows[11].Cells[12].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["JulGMPct"].ToString()));
            tblBranchBudget.Rows[11].Cells[13].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["AugGMPct"].ToString()));

            tblBranchBudget.Rows[11].Cells[14].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFFAData[0]["AnnualGMPct"].ToString()));
        }

        #endregion

        #region Year 3 - Branch Forecasted GM Pct Row

        if (drBrFCData != null)
        {
            tblBranchBudget.Rows[12].Attributes["onmouseover"] = MouseOverStyle;
            tblBranchBudget.Rows[12].Attributes["onmouseout"] = MouseOutStyle;

            tblBranchBudget.Rows[12].Cells[0].Text = drBrFCData[0]["FiscalYear"].ToString();
            tblBranchBudget.Rows[12].Cells[2].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["SepGMPct"].ToString()));
            tblBranchBudget.Rows[12].Cells[3].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["OctGMPct"].ToString()));
            tblBranchBudget.Rows[12].Cells[4].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["NovGMPct"].ToString()));
            tblBranchBudget.Rows[12].Cells[5].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["DecGMPct"].ToString()));

            tblBranchBudget.Rows[12].Cells[6].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["JanGMPct"].ToString()));
            tblBranchBudget.Rows[12].Cells[7].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["FebGMPct"].ToString()));
            tblBranchBudget.Rows[12].Cells[8].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["MarGMPct"].ToString()));
            tblBranchBudget.Rows[12].Cells[9].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["AprGMPct"].ToString()));

            tblBranchBudget.Rows[12].Cells[10].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["MayGMPct"].ToString()));
            tblBranchBudget.Rows[12].Cells[11].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["JunGMPct"].ToString()));
            tblBranchBudget.Rows[12].Cells[12].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["JulGMPct"].ToString()));
            tblBranchBudget.Rows[12].Cells[13].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["AugGMPct"].ToString()));

            tblBranchBudget.Rows[12].Cells[14].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(drBrFCData[0]["AnnualGMPct"].ToString()));
        }

        #endregion

        #region Year 3 - Forcast GM Variance Pct

        if (drBrFFAData != null && drBrFFAData.Length > 0)
        {
            tblBranchBudget.Rows[13].Attributes["onmouseover"] = MouseOverStyle;
            tblBranchBudget.Rows[13].Attributes["onmouseout"] = MouseOutStyle;

            tblBranchBudget.Rows[13].Cells[0].Text = drBrFFAData[0]["FiscalYear"].ToString();
            decimal _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["SepGMPct"].ToString());
            decimal _BranchFSales = Convert.ToDecimal(drBrFCData[0]["SepGMPct"].ToString());
            decimal _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[13].Cells[2].Text = _variancePct.ToString("N2");


            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["OctGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["OctGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[13].Cells[3].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["NovGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["NovGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[13].Cells[4].Text = _variancePct.ToString("N2");


            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["DecGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["DecGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[13].Cells[5].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["JanGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["JanGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[13].Cells[6].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["FebGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["FebGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[13].Cells[7].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["MarGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["MarGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[13].Cells[8].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["AprGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["AprGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[13].Cells[9].Text = String.Format("{0:0.0;0.0}", _variancePct);

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["MayGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["MayGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[13].Cells[10].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["JunGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["JunGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[13].Cells[11].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["JulGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["JulGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[13].Cells[12].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["AugGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["AugGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[13].Cells[13].Text = _variancePct.ToString("N2");

            _fixedFSales = Convert.ToDecimal(drBrFFAData[0]["AnnualGMPct"].ToString());
            _BranchFSales = Convert.ToDecimal(drBrFCData[0]["AnnualGMPct"].ToString());
            _variancePct = (_BranchFSales == 0 ? 0 : (((_BranchFSales - _fixedFSales) / _BranchFSales) * 100));
            tblBranchBudget.Rows[13].Cells[14].Text = _variancePct.ToString("N2");
        }

        #endregion

    }

    #endregion

    #region Sales Rep or Chain Summary Grid

    private void BindSalesRepOrChainGrid(DataTable dtSalesRep)
    {
        #region Year 1 - Sales Dollar Row

        tblSalesRepBudget.Rows[1].Cells[0].Text = dtSalesRep.Rows[0]["FiscalYear"].ToString();
        tblSalesRepBudget.Rows[1].Cells[1].Text = "Actual";
        tblSalesRepBudget.Rows[1].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[0]["SepSales"].ToString()));
        tblSalesRepBudget.Rows[1].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[0]["OctSales"].ToString()));
        tblSalesRepBudget.Rows[1].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[0]["NovSales"].ToString()));
        tblSalesRepBudget.Rows[1].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[0]["DecSales"].ToString()));

        tblSalesRepBudget.Rows[1].Cells[6].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[0]["JanSales"].ToString()));
        tblSalesRepBudget.Rows[1].Cells[7].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[0]["FebSales"].ToString()));
        tblSalesRepBudget.Rows[1].Cells[8].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[0]["MarSales"].ToString()));
        tblSalesRepBudget.Rows[1].Cells[9].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[0]["AprSales"].ToString()));

        tblSalesRepBudget.Rows[1].Cells[10].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[0]["MaySales"].ToString()));
        tblSalesRepBudget.Rows[1].Cells[11].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[0]["JunSales"].ToString()));
        tblSalesRepBudget.Rows[1].Cells[12].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[0]["JulSales"].ToString()));
        tblSalesRepBudget.Rows[1].Cells[13].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[0]["AugSales"].ToString()));

        tblSalesRepBudget.Rows[1].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[0]["AnnualSalesAmt"].ToString()));

        #endregion

        #region Year 2 - Sales Dollar Row

        tblSalesRepBudget.Rows[2].Cells[0].Text = dtSalesRep.Rows[1]["FiscalYear"].ToString();
        tblSalesRepBudget.Rows[2].Cells[1].Text = (dtSalesRep.Rows[1]["RecordType"].ToString() == "AC" ? "Actual" : "Act Fcst");

        tblSalesRepBudget.Rows[2].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[1]["SepSales"].ToString()));
        tblSalesRepBudget.Rows[2].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[1]["OctSales"].ToString()));
        tblSalesRepBudget.Rows[2].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[1]["NovSales"].ToString()));
        tblSalesRepBudget.Rows[2].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[1]["DecSales"].ToString()));

        tblSalesRepBudget.Rows[2].Cells[6].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[1]["JanSales"].ToString()));
        tblSalesRepBudget.Rows[2].Cells[7].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[1]["FebSales"].ToString()));
        tblSalesRepBudget.Rows[2].Cells[8].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[1]["MarSales"].ToString()));
        tblSalesRepBudget.Rows[2].Cells[9].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[1]["AprSales"].ToString()));

        tblSalesRepBudget.Rows[2].Cells[10].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[1]["MaySales"].ToString()));
        tblSalesRepBudget.Rows[2].Cells[11].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[1]["JunSales"].ToString()));
        tblSalesRepBudget.Rows[2].Cells[12].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[1]["JulSales"].ToString()));
        tblSalesRepBudget.Rows[2].Cells[13].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[1]["AugSales"].ToString()));

        tblSalesRepBudget.Rows[2].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[1]["AnnualSalesAmt"].ToString()));

        #endregion

        #region Year 3 - Sales Dollar Row (Forecast Row)

        tblSalesRepBudget.Rows[3].Cells[0].Text = dtSalesRep.Rows[2]["FiscalYear"].ToString();
        tblSalesRepBudget.Rows[3].Cells[1].Text = "Forecast";

        tblSalesRepBudget.Rows[3].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[2]["SepSales"].ToString()));
        tblSalesRepBudget.Rows[3].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[2]["OctSales"].ToString()));
        tblSalesRepBudget.Rows[3].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[2]["NovSales"].ToString()));
        tblSalesRepBudget.Rows[3].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[2]["DecSales"].ToString()));

        tblSalesRepBudget.Rows[3].Cells[6].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[2]["JanSales"].ToString()));
        tblSalesRepBudget.Rows[3].Cells[7].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[2]["FebSales"].ToString()));
        tblSalesRepBudget.Rows[3].Cells[8].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[2]["MarSales"].ToString()));
        tblSalesRepBudget.Rows[3].Cells[9].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[2]["AprSales"].ToString()));

        tblSalesRepBudget.Rows[3].Cells[10].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[2]["MaySales"].ToString()));
        tblSalesRepBudget.Rows[3].Cells[11].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[2]["JunSales"].ToString()));
        tblSalesRepBudget.Rows[3].Cells[12].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[2]["JulSales"].ToString()));
        tblSalesRepBudget.Rows[3].Cells[13].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[2]["AugSales"].ToString()));

        tblSalesRepBudget.Rows[3].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtSalesRep.Rows[2]["AnnualSalesAmt"].ToString()));

        #endregion

        #region Act Per Day

        DataRow[] drAdRecord = dtSalesRep.Select("RecordType='AD'");
        if (drAdRecord.Length > 0)
        {
            tblSalesRepBudget.Rows[4].Cells[0].Text = "";
            tblSalesRepBudget.Rows[4].Cells[1].Text = "Act Per Day";
            tblSalesRepBudget.Rows[4].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["SepSales"].ToString()));
            tblSalesRepBudget.Rows[4].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["OctSales"].ToString()));
            tblSalesRepBudget.Rows[4].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["NovSales"].ToString()));
            tblSalesRepBudget.Rows[4].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["DecSales"].ToString()));

            tblSalesRepBudget.Rows[4].Cells[6].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["JanSales"].ToString()));
            tblSalesRepBudget.Rows[4].Cells[7].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["FebSales"].ToString()));
            tblSalesRepBudget.Rows[4].Cells[8].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["MarSales"].ToString()));
            tblSalesRepBudget.Rows[4].Cells[9].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["AprSales"].ToString()));

            tblSalesRepBudget.Rows[4].Cells[10].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["MaySales"].ToString()));
            tblSalesRepBudget.Rows[4].Cells[11].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["JunSales"].ToString()));
            tblSalesRepBudget.Rows[4].Cells[12].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["JulSales"].ToString()));
            tblSalesRepBudget.Rows[4].Cells[13].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["AugSales"].ToString()));

            tblSalesRepBudget.Rows[4].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drAdRecord[0]["AnnualSalesAmt"].ToString()));
        }

        #endregion

        #region Br Fcst Per Day

        DataRow[] drBDRecord = dtSalesRep.Select("RecordType='BD'");
        if (drBDRecord.Length > 0)
        {
            tblSalesRepBudget.Rows[5].Cells[0].Text = "";
            tblSalesRepBudget.Rows[5].Cells[1].Text = "Br Fcst Per Day";
            tblSalesRepBudget.Rows[5].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["SepSales"].ToString()));
            tblSalesRepBudget.Rows[5].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["OctSales"].ToString()));
            tblSalesRepBudget.Rows[5].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["NovSales"].ToString()));
            tblSalesRepBudget.Rows[5].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["DecSales"].ToString()));

            tblSalesRepBudget.Rows[5].Cells[6].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["JanSales"].ToString()));
            tblSalesRepBudget.Rows[5].Cells[7].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["FebSales"].ToString()));
            tblSalesRepBudget.Rows[5].Cells[8].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["MarSales"].ToString()));
            tblSalesRepBudget.Rows[5].Cells[9].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["AprSales"].ToString()));

            tblSalesRepBudget.Rows[5].Cells[10].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["MaySales"].ToString()));
            tblSalesRepBudget.Rows[5].Cells[11].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["JunSales"].ToString()));
            tblSalesRepBudget.Rows[5].Cells[12].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["JulSales"].ToString()));
            tblSalesRepBudget.Rows[5].Cells[13].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["AugSales"].ToString()));

            tblSalesRepBudget.Rows[5].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["AnnualSalesAmt"].ToString()));
        }

        #endregion

        #region Growth % Calculation

        // Formula = ( (2011 - 2010) / 2010 ) * 100
        decimal _lastYearSales = Convert.ToDecimal(dtSalesRep.Rows[0]["AnnualSalesAmt"].ToString());
        decimal _currentYearSales = Convert.ToDecimal(dtSalesRep.Rows[1]["AnnualSalesAmt"].ToString());
        decimal _growthPct = (_lastYearSales == 0 ? 0 : (((_currentYearSales - _lastYearSales) / _lastYearSales) * 100));
        tblSalesRepBudget.Rows[2].Cells[15].Text = Math.Round(_growthPct, 1).ToString(); // For 2011


        //PFCTextBox _txtDolFYearGrowthPct = _tblCustBudget.Rows[3].Cells[15].FindControl("txtDolFYearGrowthPct") as PFCTextBox;
        //_lastYearSales = Convert.ToDecimal(_tblCustBudget.Rows[2].Cells[14].Text);
        //_currentYearSales = Convert.ToDecimal(_tblCustBudget.Rows[3].Cells[14].Text);
        //_growthPct = (_lastYearSales == 0 ? 0 : (((_currentYearSales - _lastYearSales) / _lastYearSales) * 100));
        //_txtDolFYearGrowthPct.Text = Math.Round(_growthPct, 1).ToString(); // For 2012

        #endregion

        #region Year 1 - Pct Row

        tblSalesRepBudget.Rows[7].Cells[0].Text = dtSalesRep.Rows[0]["FiscalYear"].ToString();
        tblSalesRepBudget.Rows[7].Cells[1].Text = "Actual";
        tblSalesRepBudget.Rows[7].Cells[2].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[0]["SepGMPct"].ToString()));
        tblSalesRepBudget.Rows[7].Cells[3].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[0]["OctGMPct"].ToString()));
        tblSalesRepBudget.Rows[7].Cells[4].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[0]["NovGMPct"].ToString()));
        tblSalesRepBudget.Rows[7].Cells[5].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[0]["DecGMPct"].ToString()));

        tblSalesRepBudget.Rows[7].Cells[6].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[0]["JanGMPct"].ToString()));
        tblSalesRepBudget.Rows[7].Cells[7].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[0]["FebGMPct"].ToString()));
        tblSalesRepBudget.Rows[7].Cells[8].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[0]["MarGMPct"].ToString()));
        tblSalesRepBudget.Rows[7].Cells[9].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[0]["AprGMPct"].ToString()));

        tblSalesRepBudget.Rows[7].Cells[10].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[0]["MayGMPct"].ToString()));
        tblSalesRepBudget.Rows[7].Cells[11].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[0]["JunGMPct"].ToString()));
        tblSalesRepBudget.Rows[7].Cells[12].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[0]["JulGMPct"].ToString()));
        tblSalesRepBudget.Rows[7].Cells[13].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[0]["AugGMPct"].ToString()));

        tblSalesRepBudget.Rows[7].Cells[14].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[0]["AnnualGMPct"].ToString()));

        #endregion

        #region Year 2 - Pct Row

        tblSalesRepBudget.Rows[8].Cells[0].Text = dtSalesRep.Rows[1]["FiscalYear"].ToString();
        tblSalesRepBudget.Rows[8].Cells[1].Text = (dtSalesRep.Rows[1]["RecordType"].ToString() == "AC" ? "Actual" : "Act Fcst");
        tblSalesRepBudget.Rows[8].Cells[2].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[1]["SepGMPct"].ToString()));
        tblSalesRepBudget.Rows[8].Cells[3].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[1]["OctGMPct"].ToString()));
        tblSalesRepBudget.Rows[8].Cells[4].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[1]["NovGMPct"].ToString()));
        tblSalesRepBudget.Rows[8].Cells[5].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[1]["DecGMPct"].ToString()));

        tblSalesRepBudget.Rows[8].Cells[6].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[1]["JanGMPct"].ToString()));
        tblSalesRepBudget.Rows[8].Cells[7].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[1]["FebGMPct"].ToString()));
        tblSalesRepBudget.Rows[8].Cells[8].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[1]["MarGMPct"].ToString()));
        tblSalesRepBudget.Rows[8].Cells[9].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[1]["AprGMPct"].ToString()));

        tblSalesRepBudget.Rows[8].Cells[10].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[1]["MayGMPct"].ToString()));
        tblSalesRepBudget.Rows[8].Cells[11].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[1]["JunGMPct"].ToString()));
        tblSalesRepBudget.Rows[8].Cells[12].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[1]["JulGMPct"].ToString()));
        tblSalesRepBudget.Rows[8].Cells[13].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[1]["AugGMPct"].ToString()));

        tblSalesRepBudget.Rows[8].Cells[14].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[1]["AnnualGMPct"].ToString()));

        #endregion

        #region Year 3 - Pct Row (Forecast Row)

        tblSalesRepBudget.Rows[9].Cells[0].Text = dtSalesRep.Rows[2]["FiscalYear"].ToString();
        tblSalesRepBudget.Rows[9].Cells[1].Text = "Forecast";
        tblSalesRepBudget.Rows[9].Cells[2].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[2]["SepGMPct"].ToString()));
        tblSalesRepBudget.Rows[9].Cells[3].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[2]["OctGMPct"].ToString()));
        tblSalesRepBudget.Rows[9].Cells[4].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[2]["NovGMPct"].ToString()));
        tblSalesRepBudget.Rows[9].Cells[5].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[2]["DecGMPct"].ToString()));

        tblSalesRepBudget.Rows[9].Cells[6].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[2]["JanGMPct"].ToString()));
        tblSalesRepBudget.Rows[9].Cells[7].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[2]["FebGMPct"].ToString()));
        tblSalesRepBudget.Rows[9].Cells[8].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[2]["MarGMPct"].ToString()));
        tblSalesRepBudget.Rows[9].Cells[9].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[2]["AprGMPct"].ToString()));

        tblSalesRepBudget.Rows[9].Cells[10].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[2]["MayGMPct"].ToString()));
        tblSalesRepBudget.Rows[9].Cells[11].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[2]["JunGMPct"].ToString()));
        tblSalesRepBudget.Rows[9].Cells[12].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[2]["JulGMPct"].ToString()));
        tblSalesRepBudget.Rows[9].Cells[13].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[2]["AugGMPct"].ToString()));

        tblSalesRepBudget.Rows[9].Cells[14].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtSalesRep.Rows[2]["AnnualGMPct"].ToString()));

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
        //border = (dataFormat == "Print" ? "0" : "1");
        //DataSet _dsCustPriceData = Session["CustPriceRptData"] as DataSet;
        //dtExcelData = new DataTable();
        dsCustBudgetData = customerBudget.GetCustomerNextYearReport(branchCd, salesRepNo, chainCd, custNo, SummaryRptType, sortType, "no", ShowFSNL);

        string styleSheet = "<style>.text { mso-number-format:\\@; } </style>";
        string headerContent = string.Empty;
        string customerHeaderContent = string.Empty;   
        string customerTableContent = string.Empty;
        string branchTableContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;

        // Step 1: Create Report Header
        headerContent  =    "<table border='1' width='100%'>";
        headerContent +=    "<tr><th colspan='16' style='color:blue' align=left><center>Customer Sales Forecast Report</center></th></tr>";
        headerContent +=    "<tr><td colspan='4'><b>Inside Rep:" + lblInsideRep.Text + "</b></td>" +
                            "<td  colspan='4'><b>Branch:" + lblBranch.Text + "</b></td>" +
                            "<td colspan='8'></td></tr>";
        headerContent +=    "<tr><th colspan='16' style='color:blue' align=left></th></tr>";
        if (dsCustBudgetData != null)
        {
            DataTable dtCustomerHdr = dsCustBudgetData.Tables[0];
            foreach (DataRow drCustHdr in dtCustomerHdr.Rows)
            {
                // Step 2: Create Customer Header
                customerHeaderContent +=     "<table border='1' width='100%'>";
                customerHeaderContent +=    "<tr><th colspan='16' align=left>" + drCustHdr["CustNo"].ToString() + "  " + drCustHdr["CustName"].ToString() + "</th></tr>";
                customerHeaderContent +=    "<tr><td colspan='3'><b>Credit Ind:" + drCustHdr["CreditInd"].ToString() + "</b></td>" +
                                            "<td  colspan='3'><b>Delete Status:" + drCustHdr["DeleteStatus"].ToString() + "</b></td>" +
                                            "<td colspan='3'><b>Price Cd:" + drCustHdr["PriceCd"].ToString() + "</b></td>" +
                                            "<td colspan='4'><b>Sales Grp:" + drCustHdr["SalTerritoryDesc"].ToString() + "</b></td>" +
                                            "<td colspan='3'><b>Chain:" + drCustHdr["ChainCd"].ToString() + "</b></td>" + 
                                            "</tr>";

                // Step 3: Create Customer Budget Table
                dsCustBudgetData.Tables[1].DefaultView.RowFilter = "CustNo='" + drCustHdr["CustNo"].ToString() +"'";
                dsCustBudgetData.Tables[1].DefaultView.Sort = "RecordType Asc";
                customerTableContent = CreateCustomerTableExcelContent(dsCustBudgetData.Tables[1].DefaultView.ToTable());
                customerHeaderContent += customerTableContent;

            }

            if (DisplayBranchGrid)
            {
                branchTableContent = CreateBranchTableExcelContent(dsCustBudgetData.Tables[2]);
            }
            else
            {
                branchTableContent = "<table border='1' width='100%'>";
                branchTableContent += "<tr><th colspan='16' align=left style='color:blue;font-weight:bold;'>" + lblBranchCaption.Text + "</th></tr></table>";

                branchTableContent += CreateSalesRepOrChainExcelContent(dsCustBudgetData.Tables[2]);
            }


        }
        else
        {
            excelContent = "<tr  ><th width='100%' align ='center' colspan='18' > No records found</th></tr> </table>";
        }      

        return  styleSheet + 
                headerContent + 
                customerHeaderContent + 
                branchTableContent +
                excelContent;        
    }
    
    private string CreateCustomerTableExcelContent(DataTable dtCustBudget)
    {
        string customerTableContent = string.Empty;


        customerTableContent= "<table border='1' width='100%'>";
        customerTableContent += "<tr style='font-weight:bold;'>" +
                                    "<td align=center>Fiscal Year</td><td align=center>Type</td>" +
                                    "<td align=right>Sep</td><td align=right>Oct</td><td align=right>Nov</td><td align=right>Dec</td>" +
                                    "<td align=right>Jan</td><td align=right>Feb</td><td align=right>Mar</td><td align=right>Apr</td>" +
                                    "<td align=right>May</td><td align=right>Jun</td><td align=right>Jul</td><td align=right>Aug</td>" +   
                                    "<td align=center>Annual</td><td align=center>Growth %</td>" +
                                "</tr>";

        #region Create Sales Dollar Rows

        // 2010  A - Sales
        customerTableContent+= "<tr>" + 
                                    "<td align=center>" + dtCustBudget.Rows[0]["FiscalYear"].ToString() + "</td><td align=center>" + dtCustBudget.Rows[0]["RecordTypeDesc"].ToString() + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["SepSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["OctSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["NovSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["DecSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["JanSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["FebSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["MarSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["AprSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["MaySales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["JunSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["JulSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["AugSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["AnnualSalesAmt"].ToString())) + "</td>" +
                                    "<td align=right></td>" +
                                "</tr>";

        // 2011  A - Sales
        // Formula = ( (2011 - 2010) / 2010 ) * 100
        decimal _lastYearSales = Convert.ToDecimal(dtCustBudget.Rows[0]["AnnualSalesAmt"].ToString());
        decimal _currentYearSales = Convert.ToDecimal(dtCustBudget.Rows[1]["AnnualSalesAmt"].ToString());
        decimal _growthPct = (_lastYearSales == 0 ? 0 : (((_currentYearSales - _lastYearSales) / _lastYearSales) * 100));
        
        customerTableContent += "<tr>" +
                                    "<td align=center>" + dtCustBudget.Rows[1]["FiscalYear"].ToString() + "</td><td align=center>" + (dtCustBudget.Rows[1]["RecordType"].ToString() == "AC" ? "Actual" : "Act Fcst") + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["SepSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["OctSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["NovSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["DecSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["JanSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["FebSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["MarSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["AprSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["MaySales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["JunSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["JulSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["AugSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["AnnualSalesAmt"].ToString())) + "</td>" +
                                    "<td align=right>" + Math.Round(_growthPct, 1).ToString() +"</td>" +
                                "</tr>";


        // 2012  F - Sales        
        _lastYearSales = Convert.ToDecimal(dtCustBudget.Rows[1]["AnnualSalesAmt"].ToString());
        _currentYearSales = Convert.ToDecimal(dtCustBudget.Rows[2]["AnnualSalesAmt"].ToString());
        _growthPct = (_lastYearSales == 0 ? 0 : (((_currentYearSales - _lastYearSales) / _lastYearSales) * 100));        

        customerTableContent += "<tr>" +
                                    "<td align=center>" + dtCustBudget.Rows[2]["FiscalYear"].ToString() + "</td><td align=center>Forecast</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["SepSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["OctSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["NovSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["DecSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["JanSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["FebSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["MarSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["AprSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["MaySales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["JunSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["JulSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["AugSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["AnnualSalesAmt"].ToString())) + "</td>" +
                                    "<td align=right>" + Math.Round(_growthPct, 1).ToString() +" </td>" +
                                "</tr>";

        customerTableContent += "<tr><th colspan='16' align=left></th></tr>";

        #endregion

        #region Create GM Pct Rows

        // 2010  A - GM Pct
        customerTableContent += "<tr>" +
                                    "<td align=center>" + dtCustBudget.Rows[0]["FiscalYear"].ToString() + "</td><td align=center>" + dtCustBudget.Rows[0]["RecordTypeDesc"].ToString() + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["SepGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["OctGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["NovGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["DecGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["JanGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["FebGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["MarGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["AprGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["MayGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["JunGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["JulGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["AugGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["AnnualGMPct"].ToString())) + "</td>" +
                                    "<td align=right></td>" +
                                "</tr>";

        // 2011  A - GM Pct
        customerTableContent += "<tr>" +
                                    "<td align=center>" + dtCustBudget.Rows[1]["FiscalYear"].ToString() + "</td><td align=center>" + (dtCustBudget.Rows[1]["RecordType"].ToString() == "AC" ? "Actual" : "Act Fcst") + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["SepGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["OctGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["NovGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["DecGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["JanGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["FebGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["MarGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["AprGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["MayGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["JunGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["JulGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["AugGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["AnnualGMPct"].ToString())) + "</td>" +
                                    "<td align=right></td>" +
                                "</tr>";

        // 2011  A - GM Pct
        customerTableContent += "<tr>" +
                                    "<td align=center>" + dtCustBudget.Rows[2]["FiscalYear"].ToString() + "</td><td align=center>Forecast</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["SepGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["OctGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["NovGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["DecGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["JanGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["FebGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["MarGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["AprGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["MayGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["JunGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["JulGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["AugGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["AnnualGMPct"].ToString())) + "</td>" +
                                    "<td align=right></td>" +
                                "</tr>";

        customerTableContent += "<tr><th colspan='16' align=left></th></tr>";

        #endregion

        return customerTableContent;

    }

    private string CreateBranchTableExcelContent(DataTable dtBranchBudget)
    {
        string branchTableContent = string.Empty;


        branchTableContent = "<table border='1' width='100%'>";
        branchTableContent += "<tr><th colspan='16' align=left style='color:blue;font-weight:bold;'>" + lblBranchCaption.Text + "</th></tr>";
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
                                    "<td align=center>" + dtBranchBudget.Rows[0]["FiscalYear"].ToString() + "</td><td align=center>Actual</td>" +
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
                                    "<td align=center>" + dtBranchBudget.Rows[1]["FiscalYear"].ToString() + "</td><td align=center>" + (dtBranchBudget.Rows[1]["RecordType"].ToString() == "AC" ? "Actual" : "Act Fcst") + "</td>" +
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
                                        "<td align=center>" + drBrFFAData[0]["FiscalYear"].ToString() + "</td><td align=center>Corp Fcst</td>" +
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
                                        "<td align=center>" + drBrFCData[0]["FiscalYear"].ToString() + "</td><td align=center>Branch Fcst</td>" +
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
            branchTableContent += "<td align=right>" +  _variancePct.ToString("N2") + "</td>";

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

        #endregion

        #region Act Per Day

        DataRow[] drADRecord = dtBranchBudget.Select("RecordType='AD'");
        if (drADRecord.Length > 0)
        {
            branchTableContent += "<tr>" +
                                        "<td align=center></td><td align=center>Act Per Day</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["SepSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["OctSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["NovSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["DecSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["JanSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["FebSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["MarSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["AprSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["MaySales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["JunSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["JulSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["AugSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["AnnualSalesAmt"].ToString())) + "</td>" +
                                        "<td align=right></td>" +
                                    "</tr>";
        }

        #endregion

        #region Br Fcst Per Day

        DataRow[] drBDRecord = dtBranchBudget.Select("RecordType='BD'");
        if (drBDRecord.Length > 0)
        {
            branchTableContent += "<tr>" +
                                        "<td align=center></td><td align=center>Brn Fcst Per Day</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["SepSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["OctSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["NovSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["DecSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["JanSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["FebSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["MarSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["AprSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["MaySales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["JunSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["JulSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["AugSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["AnnualSalesAmt"].ToString())) + "</td>" +
                                        "<td align=right></td>" +
                                    "</tr>";

            branchTableContent += "<tr><th colspan='16' align=left></th></tr>";
        }

        #endregion

        #endregion

        #region Create GM Pct Rows

        #region 2010  A - GM Pct

        branchTableContent += "<tr>" +
                                    "<td align=center>" + dtBranchBudget.Rows[0]["FiscalYear"].ToString() + "</td><td align=center>Actual</td>" +
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
                                    "<td align=center>" + dtBranchBudget.Rows[1]["FiscalYear"].ToString() + "</td><td align=center>" + (dtBranchBudget.Rows[1]["RecordType"].ToString() == "AC" ? "Actual" : "Act Fcst") + "</td>" +
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
                                        "<td align=center>" + drBrFFAData[0]["FiscalYear"].ToString() + "</td><td align=center>Corp Fcst</td>" +
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
                                        "<td align=center>" + drBrFCData[0]["FiscalYear"].ToString() + "</td><td align=center>Branch Fcst</td>" +
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
               
        #endregion


        branchTableContent += "<tr><th colspan='16' align=left></th></tr>";

        #endregion

        return branchTableContent;

    }

    private string CreateSalesRepOrChainExcelContent(DataTable dtCustBudget)
    {
        string customerTableContent = string.Empty;


        customerTableContent= "<table border='1' width='100%'>";
        customerTableContent += "<tr style='font-weight:bold;'>" +
                                    "<td align=center>Fiscal Year</td><td align=center>Type</td>" +
                                    "<td align=right>Sep</td><td align=right>Oct</td><td align=right>Nov</td><td align=right>Dec</td>" +
                                    "<td align=right>Jan</td><td align=right>Feb</td><td align=right>Mar</td><td align=right>Apr</td>" +
                                    "<td align=right>May</td><td align=right>Jun</td><td align=right>Jul</td><td align=right>Aug</td>" +   
                                    "<td align=center>Annual</td><td align=center>Growth %</td>" +
                                "</tr>";

        #region Create Sales Dollar Rows

        // 2010  A - Sales
        customerTableContent+= "<tr>" + 
                                    "<td align=center>" + dtCustBudget.Rows[0]["FiscalYear"].ToString() + "</td><td align=center>Actual</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["SepSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["OctSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["NovSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["DecSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["JanSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["FebSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["MarSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["AprSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["MaySales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["JunSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["JulSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["AugSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[0]["AnnualSalesAmt"].ToString())) + "</td>" +
                                    "<td align=right></td>" +
                                "</tr>";

        // 2011  A - Sales
        // Formula = ( (2011 - 2010) / 2010 ) * 100
        decimal _lastYearSales = Convert.ToDecimal(dtCustBudget.Rows[0]["AnnualSalesAmt"].ToString());
        decimal _currentYearSales = Convert.ToDecimal(dtCustBudget.Rows[1]["AnnualSalesAmt"].ToString());
        decimal _growthPct = (_lastYearSales == 0 ? 0 : (((_currentYearSales - _lastYearSales) / _lastYearSales) * 100));
        
        customerTableContent += "<tr>" +
                                    "<td align=center>" + dtCustBudget.Rows[1]["FiscalYear"].ToString() + "</td><td align=center>" + (dtCustBudget.Rows[1]["RecordType"].ToString() == "AC" ? "Actual" : "Act Fcst") + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["SepSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["OctSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["NovSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["DecSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["JanSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["FebSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["MarSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["AprSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["MaySales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["JunSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["JulSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["AugSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[1]["AnnualSalesAmt"].ToString())) + "</td>" +
                                    "<td align=right>" + Math.Round(_growthPct, 1).ToString() +"</td>" +
                                "</tr>";


        // 2012  F - Sales                
        customerTableContent += "<tr>" +
                                    "<td align=center>" + dtCustBudget.Rows[2]["FiscalYear"].ToString() + "</td><td align=center>Forecast</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["SepSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["OctSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["NovSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["DecSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["JanSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["FebSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["MarSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["AprSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["MaySales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["JunSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["JulSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["AugSales"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dtCustBudget.Rows[2]["AnnualSalesAmt"].ToString())) + "</td>" +
                                    "<td align=right> </td>" +
                                "</tr>";

        // Act Per Day      
        DataRow[] drADRecord = dtCustBudget.Select("RecordType='AD'");
        if (drADRecord.Length > 0)
        {
            customerTableContent += "<tr>" +
                                        "<td align=center></td><td align=center>Act Per Day </td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["SepSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["OctSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["NovSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["DecSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["JanSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["FebSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["MarSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["AprSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["MaySales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["JunSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["JulSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["AugSales"].ToString())) + "</td>" +
                                        "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drADRecord[0]["AnnualSalesAmt"].ToString())) + "</td>" +
                                        "<td align=right> </td>" +
                                    "</tr>";
        }

        DataRow[] drBDRecord = dtCustBudget.Select("RecordType='BD'");
        if (drBDRecord.Length > 0)
        {
             // Br Fcst Per Day               
             customerTableContent += "<tr>" +
                                         "<td align=center></td><td align=center>Forecast</td>" +
                                         "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["SepSales"].ToString())) + "</td>" +
                                         "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["OctSales"].ToString())) + "</td>" +
                                         "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["NovSales"].ToString())) + "</td>" +
                                         "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["DecSales"].ToString())) + "</td>" +
                                         "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["JanSales"].ToString())) + "</td>" +
                                         "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["FebSales"].ToString())) + "</td>" +
                                         "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["MarSales"].ToString())) + "</td>" +
                                         "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["AprSales"].ToString())) + "</td>" +
                                         "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["MaySales"].ToString())) + "</td>" +
                                         "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["JunSales"].ToString())) + "</td>" +
                                         "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["JulSales"].ToString())) + "</td>" +
                                         "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["AugSales"].ToString())) + "</td>" +
                                         "<td align=right>" + String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(drBDRecord[0]["AnnualSalesAmt"].ToString())) + "</td>" +
                                         "<td align=right> </td>" +
                                     "</tr>";
        }

        customerTableContent += "<tr><th colspan='16' align=left></th></tr>";

        #endregion

        #region Create GM Pct Rows

        // 2010  A - GM Pct
        customerTableContent += "<tr>" +
                                    "<td align=center>" + dtCustBudget.Rows[0]["FiscalYear"].ToString() + "</td><td align=center>Actual</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["SepGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["OctGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["NovGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["DecGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["JanGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["FebGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["MarGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["AprGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["MayGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["JunGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["JulGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["AugGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[0]["AnnualGMPct"].ToString())) + "</td>" +
                                    "<td align=right></td>" +
                                "</tr>";

        // 2011  A - GM Pct
        customerTableContent += "<tr>" +
                                    "<td align=center>" + dtCustBudget.Rows[1]["FiscalYear"].ToString() + "</td><td align=center>" + (dtCustBudget.Rows[1]["RecordType"].ToString() == "AC" ? "Actual" : "Act Fcst") + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["SepGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["OctGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["NovGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["DecGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["JanGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["FebGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["MarGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["AprGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["MayGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["JunGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["JulGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["AugGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[1]["AnnualGMPct"].ToString())) + "</td>" +
                                    "<td align=right></td>" +
                                "</tr>";

        // 2011  A - GM Pct
        customerTableContent += "<tr>" +
                                    "<td align=center>" + dtCustBudget.Rows[2]["FiscalYear"].ToString() + "</td><td align=center>Forecast</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["SepGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["OctGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["NovGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["DecGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["JanGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["FebGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["MarGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["AprGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["MayGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["JunGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["JulGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["AugGMPct"].ToString())) + "</td>" +
                                    "<td align=right>" + String.Format("{0:0.0;0.0}", Convert.ToDecimal(dtCustBudget.Rows[2]["AnnualGMPct"].ToString())) + "</td>" +
                                    "<td align=right></td>" +
                                "</tr>";

        customerTableContent += "<tr><th colspan='16' align=left></th></tr>";

        #endregion

        return customerTableContent;

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
    
    #region Dollar ForeCast TextBox Change Events

    protected void txtDolFYearSep_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastDolAmt("txtDolFYearSep", "txtDolFYearOct", "SepSales"); 
    }
    protected void txtDolFYearOct_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastDolAmt("txtDolFYearOct", "txtDolFYearNov", "OctSales");        
    }
    protected void txtDolFYearNov_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastDolAmt("txtDolFYearNov", "txtDolFYearDec", "NovSales");
    }
    protected void txtDolFYearDec_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastDolAmt("txtDolFYearDec", "txtDolFYearJan", "DecSales");
    }
    
    protected void txtDolFYearJan_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastDolAmt("txtDolFYearJan", "txtDolFYearFeb", "JanSales");
    }
    protected void txtDolFYearFeb_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastDolAmt("txtDolFYearFeb", "txtDolFYearMar", "FebSales");
    }
    protected void txtDolFYearMar_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastDolAmt("txtDolFYearMar", "txtDolFYearApr", "MarSales");
    }
    protected void txtDolFYearApr_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastDolAmt("txtDolFYearApr", "txtDolFYearMay", "AprSales");
    }
    
    protected void txtDolFYearMay_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastDolAmt("txtDolFYearMay", "txtDolFYearJun", "MaySales");
    }
    protected void txtDolFYearJun_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastDolAmt("txtDolFYearJun", "txtDolFYearJul", "JunSales");
    }
    protected void txtDolFYearJul_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastDolAmt("txtDolFYearJul", "txtDolFYearAug", "JulSales");
    }
    protected void txtDolFYearAug_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastDolAmt("txtDolFYearAug", "txtDolFYearGrowthPct", "AugSales");
    }

    private void UpdateForeCastDolAmt(string txtBoxId, string nextControlId, string columnName)
    {
        try
        {
            Table tblCustBudgetTemp = gvCustBudget.Rows[0].FindControl("tblCustBudget") as Table;
            HiddenField hidpCustSalForecastIdTemp = tblCustBudgetTemp.Rows[3].Cells[2].FindControl("hidpCustSalForecastId") as HiddenField;
            PFCTextBox _CurrentTxtDolFYearCtl = tblCustBudgetTemp.Rows[3].Cells[2].FindControl(txtBoxId) as PFCTextBox;
            PFCTextBox _txtDolFYearGrowthPct = tblCustBudgetTemp.Rows[3].Cells[15].FindControl("txtDolFYearGrowthPct") as PFCTextBox;
            string pCustSalForecastId = hidpCustSalForecastIdTemp.Value;

            // Update current forecast value 
            string updateQuery = "Update CustomerSalesNextYearForecast " +
                                 "Set " + columnName + "='" + _CurrentTxtDolFYearCtl.Text.Replace(",", "") + "', ChangeID='" + Session["UserName"].ToString() + "', ChangeDt='" + DateTime.Now.ToString() + "' " +
                                 "Where pCustSalesNextYearForecastID=" + pCustSalForecastId;

            PFCDBHelper.ExecuteERPUpdateQuery(updateQuery);
            DataSet dsSummaryData = customerBudget.ReExtendNextYearGrids(pCustSalForecastId, branchCd, "0", "0", "forecastdol", salesRepNo, chainCd, custNo, SummaryRptType, ShowFSNL);

            tblCustBudgetTemp.Rows[3].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dsSummaryData.Tables[0].Rows[0]["AnnualSalesAmt"].ToString()));

            // Recalculate Growth %
            decimal _lastYearSales = Decimal.Parse(tblCustBudgetTemp.Rows[2].Cells[14].Text, NumberStyles.Number | NumberStyles.AllowParentheses);
            decimal _currentYearSales = Decimal.Parse(tblCustBudgetTemp.Rows[3].Cells[14].Text, NumberStyles.Number | NumberStyles.AllowParentheses);
            decimal _growthPct = (_lastYearSales == 0 ? 0 : (((_currentYearSales - _lastYearSales) / _lastYearSales) * 100));
            _txtDolFYearGrowthPct.Text = Math.Round(_growthPct, 1).ToString(); // For 2012

            if (DisplayBranchGrid)
                BindBranchSummaryGrid(dsSummaryData.Tables[1]);
            else
                BindSalesRepOrChainGrid(dsSummaryData.Tables[1]);

            scmCustBudget.SetFocus(_CurrentTxtDolFYearCtl.TextBoxClientID.Replace(txtBoxId, nextControlId));

            upnlCustomerGrid.Update();
            pnlBranchGrid.Update();
        }
        catch (Exception ex)
        {
            lblInsideRep.Text = ex.ToString();
            pnlBranchDesc.Update();
        }
    }

    protected void txtDolFYearGrowthPct_TextChanged(object sender, EventArgs e)
    {
        Table tblCustBudgetTemp = gvCustBudget.Rows[0].FindControl("tblCustBudget") as Table;
        HiddenField hidpCustSalForecastIdTemp = tblCustBudgetTemp.Rows[3].Cells[2].FindControl("hidpCustSalForecastId") as HiddenField;
        HiddenField hidLYpCustSalForecastIdTemp = tblCustBudgetTemp.Rows[3].Cells[2].FindControl("hidLYpCustSalForecastId") as HiddenField;
        PFCTextBox _txtDolFYearGrowthPct = tblCustBudgetTemp.Rows[3].Cells[15].FindControl("txtDolFYearGrowthPct") as PFCTextBox;

        // Validate growth factor
        if (_txtDolFYearGrowthPct.Text != "")
        {
            decimal _growthFactor = Convert.ToDecimal(_txtDolFYearGrowthPct.Text);
            _growthFactor = _growthFactor / 100;

            DataSet dsSummaryData = customerBudget.ReExtendNextYearGrids(hidpCustSalForecastIdTemp.Value,
                                                             branchCd,
                                                            _growthFactor.ToString(),
                                                             hidLYpCustSalForecastIdTemp.Value,
                                                             "growthpct",
                                                             salesRepNo,
                                                             chainCd,
                                                             custNo,
                                                             SummaryRptType, 
                                                             ShowFSNL);

            PFCTextBox _txtDolFYearSep = tblCustBudgetTemp.Rows[3].Cells[2].FindControl("txtDolFYearSep") as PFCTextBox;
            PFCTextBox _txtDolFYearOct = tblCustBudgetTemp.Rows[3].Cells[2].FindControl("txtDolFYearOct") as PFCTextBox;
            PFCTextBox _txtDolFYearNov = tblCustBudgetTemp.Rows[3].Cells[2].FindControl("txtDolFYearNov") as PFCTextBox;
            PFCTextBox _txtDolFYearDec = tblCustBudgetTemp.Rows[3].Cells[2].FindControl("txtDolFYearDec") as PFCTextBox;

            PFCTextBox _txtDolFYearJan = tblCustBudgetTemp.Rows[3].Cells[2].FindControl("txtDolFYearJan") as PFCTextBox;
            PFCTextBox _txtDolFYearFeb = tblCustBudgetTemp.Rows[3].Cells[2].FindControl("txtDolFYearFeb") as PFCTextBox;
            PFCTextBox _txtDolFYearMar = tblCustBudgetTemp.Rows[3].Cells[2].FindControl("txtDolFYearMar") as PFCTextBox;
            PFCTextBox _txtDolFYearApr = tblCustBudgetTemp.Rows[3].Cells[2].FindControl("txtDolFYearApr") as PFCTextBox;

            PFCTextBox _txtDolFYearMay = tblCustBudgetTemp.Rows[3].Cells[2].FindControl("txtDolFYearMay") as PFCTextBox;
            PFCTextBox _txtDolFYearJun = tblCustBudgetTemp.Rows[3].Cells[2].FindControl("txtDolFYearJun") as PFCTextBox;
            PFCTextBox _txtDolFYearJul = tblCustBudgetTemp.Rows[3].Cells[2].FindControl("txtDolFYearJul") as PFCTextBox;
            PFCTextBox _txtDolFYearAug = tblCustBudgetTemp.Rows[3].Cells[2].FindControl("txtDolFYearAug") as PFCTextBox;

            _txtDolFYearSep.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dsSummaryData.Tables[0].Rows[0]["SepSales"].ToString()));
            _txtDolFYearOct.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dsSummaryData.Tables[0].Rows[0]["OctSales"].ToString()));
            _txtDolFYearNov.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dsSummaryData.Tables[0].Rows[0]["NovSales"].ToString()));
            _txtDolFYearDec.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dsSummaryData.Tables[0].Rows[0]["DecSales"].ToString()));
            
            _txtDolFYearJan.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dsSummaryData.Tables[0].Rows[0]["JanSales"].ToString()));
            _txtDolFYearFeb.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dsSummaryData.Tables[0].Rows[0]["FebSales"].ToString()));
            _txtDolFYearMar.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dsSummaryData.Tables[0].Rows[0]["MarSales"].ToString()));
            _txtDolFYearApr.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dsSummaryData.Tables[0].Rows[0]["AprSales"].ToString()));

            _txtDolFYearMay.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dsSummaryData.Tables[0].Rows[0]["MaySales"].ToString()));
            _txtDolFYearJun.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dsSummaryData.Tables[0].Rows[0]["JunSales"].ToString()));
            _txtDolFYearJul.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dsSummaryData.Tables[0].Rows[0]["JulSales"].ToString()));
            _txtDolFYearAug.Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dsSummaryData.Tables[0].Rows[0]["AugSales"].ToString()));

            tblCustBudgetTemp.Rows[3].Cells[14].Text = String.Format("{0:#,###;(#,###);0}", Convert.ToDecimal(dsSummaryData.Tables[0].Rows[0]["AnnualSalesAmt"].ToString()));

            if (DisplayBranchGrid)
                BindBranchSummaryGrid(dsSummaryData.Tables[1]);
            else
                BindSalesRepOrChainGrid(dsSummaryData.Tables[1]);

            pnlBranchGrid.Update();
                    
            scmCustBudget.SetFocus(_txtDolFYearSep.TextBoxClientID.Replace("txtDolFYearSep", "txtPctFYearSep"));
        }
        else
            ScriptManager.RegisterClientScriptBlock(gvCustBudget, gvCustBudget.GetType(), "invalidgrowthpct", "alert('Invalid Growth %.');", true);


    }

    #endregion
    
    #region Pct Forcast Textbox Change Events

    protected void txtPctFYearSep_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastPct("txtPctFYearSep", "txtPctFYearOct", "SepGMPct");
    }
    protected void txtPctFYearOct_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastPct("txtPctFYearOct", "txtPctFYearNov", "OctGMPct");
    }
    protected void txtPctFYearNov_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastPct("txtPctFYearNov", "txtPctFYearDec", "NovGMPct");

    }
    protected void txtPctFYearDec_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastPct("txtPctFYearDec", "txtPctFYearJan", "DecGMPct");
    }

    protected void txtPctFYearJan_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastPct("txtPctFYearJan", "txtPctFYearFeb", "JanGMPct");
    }
    protected void txtPctFYearFeb_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastPct("txtPctFYearFeb", "txtPctFYearMar", "FebGMPct");
    }
    protected void txtPctFYearMar_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastPct("txtPctFYearMar", "txtPctFYearApr", "MarGMPct");

    }
    protected void txtPctFYearApr_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastPct("txtPctFYearApr", "txtPctFYearMay", "AprGMPct");
    }
    
    protected void txtPctFYearMay_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastPct("txtPctFYearMay", "txtPctFYearJun", "MayGMPct");
    }
    protected void txtPctFYearJun_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastPct("txtPctFYearJun", "txtPctFYearJul", "JunGMPct");
    }
    protected void txtPctFYearJul_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastPct("txtPctFYearJul", "txtPctFYearAug", "JulGMPct");

    }
    protected void txtPctFYearAug_TextChanged(object sender, EventArgs e)
    {
        UpdateForeCastPct("txtPctFYearAug", "txtPctFYearSep", "AugGMPct");
    }
    
    private void UpdateForeCastPct(string txtBoxId, string nextControlId, string columnName)
    {
        Table tblCustBudgetTemp = gvCustBudget.Rows[0].FindControl("tblCustBudget") as Table;
        HiddenField hidpCustSalForecastIdTemp = tblCustBudgetTemp.Rows[3].Cells[2].FindControl("hidpCustSalForecastId") as HiddenField;
        PFCTextBox _CurrentTxtPctFYearCtl = tblCustBudgetTemp.Rows[3].Cells[2].FindControl(txtBoxId) as PFCTextBox;        
        string pCustSalForecastId = hidpCustSalForecastIdTemp.Value;

        decimal _newForecatPct;
        try
        {
            _newForecatPct = Convert.ToDecimal(_CurrentTxtPctFYearCtl.Text);
            _newForecatPct = _newForecatPct / 100;
        }
        catch (Exception ex)
        {
            ScriptManager.RegisterClientScriptBlock(gvCustBudget, gvCustBudget.GetType(), "invalidgrowthpct", "alert('Invalid forecast percentage.');", true);
            return;
        }

        // Update current forecast value 
        string updateQuery = "Update CustomerSalesNextYearForecast " +
                             "Set " + columnName + "='" + _newForecatPct + "', ChangeID='" + Session["UserName"].ToString() + "', ChangeDt='" + DateTime.Now.ToString() + "' " +
                             "Where pCustSalesNextYearForecastID=" + pCustSalForecastId;

        PFCDBHelper.ExecuteERPUpdateQuery(updateQuery);
        DataSet dsSummaryData = customerBudget.ReExtendNextYearGrids(pCustSalForecastId, branchCd, "0", "0", "forecastdol", salesRepNo, chainCd, custNo, SummaryRptType, ShowFSNL);

        tblCustBudgetTemp.Rows[7].Cells[14].Text = String.Format("{0:0.0;0.0}", Convert.ToDecimal(dsSummaryData.Tables[0].Rows[0]["AnnualGMPct"].ToString()));

        if (DisplayBranchGrid)
            BindBranchSummaryGrid(dsSummaryData.Tables[1]);
        else
            BindSalesRepOrChainGrid(dsSummaryData.Tables[1]);

        scmCustBudget.SetFocus(_CurrentTxtPctFYearCtl.TextBoxClientID.Replace(txtBoxId, nextControlId));
        
        upnlCustomerGrid.Update();
        pnlBranchGrid.Update();
    }

    #endregion

}


