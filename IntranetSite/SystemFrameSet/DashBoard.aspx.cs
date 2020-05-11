#region Namespaces
using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet;
using PFC.Intranet.Securitylayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;
#endregion

namespace PFC.Intranet
{
    public partial class DashBoard : System.Web.UI.Page
    {
        #region Variable declaration
        // Constant declaration
        private const string TBLUSERSETUP = "UCOR_UserSetup";
        private const string SP_GENERALSELECT = "UGEN_SP_Select";
        // Public variable
        private string curMonth = string.Empty;
        private string curYear = string.Empty;
        public string AnnouncementTitle = string.Empty;
        public string Announcement = string.Empty;
        UserValidation objUser = new UserValidation();
        SalesReportUtils salesReportUtils = new SalesReportUtils();
        FiscalCalendar fiscalCalendar;
        #endregion

        #region Page Load Event
        /// <summary>
        /// Page Load Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            SystemCheck systemCheck = new SystemCheck();
            try
            {   //
                //Used to check User session
                //
                systemCheck.SessionCheck();

                if (!Page.IsPostBack)
                {
                    GetALLBranches();
                    GetALLRegions();                   
                }                
                
                //method used to display corporate repotr                
                DisplayCorpSalesReport();

                //method used to display branch report                
                DisplayBranchReport();
                
                //method Used to Load Announcement
                LoadAnnouncement();               
                
                //method Used to Load ShortCuts                
                LoadShortCuts();

                //method Used to Load Favourites                
                LoadFavourites();

                //method Used to Load Do list                
                LoadDolist();

                //method Used to Load Marketing Tips                
                LoadMarketing();

                // load last working day in hidden field                
                hidLastBusiDay.Value = fiscalCalendar.LastBusinessDay;

                int securityLevel = Convert.ToInt16(Session["MaxSensitivity"].ToString());

                #region Developer Code
                if (Session["UserType"].ToString().Trim() == "Executive Management" || securityLevel >= 3)
                {
                    ibtnCsr.Visible = true;
                    ibtnDailySales.Visible = true;
                }
                #endregion

                //
                // Display region performance report if user is not a sales rep
                //
                if (Session["UserType"].ToString().Trim() == "Customer Sales Rep")
                {
                    tblRegion.Visible = false;
                    tblCorpSalesReport.Visible = false;
                    tblCSRPerfRptPanel.Visible = true;

                    DisplayCSRPerformanceReport();
                    ibtnCsr.Attributes.Add("onclick", "LoadCSRByCustAssigned();");
                }
                else
                {
                    tblCSRPerfRptPanel.Visible = false;
                    tblCorpSalesReport.Visible = true;
                    ibtnCsr.Attributes.Add("onclick", "LoadCsr();");
                }
                                
                //ibtnDailySales.Attributes.Add("onclick", "<script>alert('test');LoadSalesReport(" + BegDate + "," + endDate + ");</script>");
            }
            catch (Exception ex)
            {
                
            }
        }
        #endregion

        #region Developer Code

        private void GetCurDateTime()
        {
            try
            {
                string _tableName = "DashboardRanges";
                string _columnName = "MonthValue,YearValue";
                string _whereClause = "DashboardParameter='CurrentMonth'";

                DataSet dsDashboardRange = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));
                if (dsDashboardRange != null && dsDashboardRange.Tables[0].Rows.Count > 0)
                {
                    curMonth = dsDashboardRange.Tables[0].Rows[0]["MonthValue"].ToString();
                    curYear = dsDashboardRange.Tables[0].Rows[0]["YearValue"].ToString();
                }

                fiscalCalendar = new FiscalCalendar(curMonth, curYear);

                int test = fiscalCalendar.CurrentWorkDay;

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void DisplayBranchReport()
        {
            try
            {
                string _dayProfit = string.Empty;
                string _MTDProfit = string.Empty;
                
                string _tableName = "Dashboard_Branch";

                string _columnName = "TD_GrossmarginDollar,MTD_GrossmarginDollar,AVG_GrossmarginDollar,BUD_GrossmarginDollar,TD_GrossmarginPct,MTD_GrossmarginPct,AVG_Grossmarginpct,BUD_Grossmarginpct,TD_SalesDollar,MTD_SalesDollar,AVG_SalesDollar,BUD_SalesDollar," +
                                     "TD_OrderCount,MTD_OrderCount,AVG_OrderCount,BUD_OrderCount,TD_LineCount,MTD_LineCount,AVG_LineCount,BUD_LineCount,TD_LbsShipped,MTD_LbsShipped,AVG_LbsShipped,BUD_LbsShipped,TD_PriceperLB,MTD_PriceperLB,AVG_PriceperLB,BUD_PriceperLB,"+
                                     "TD_GMPerLb,MTD_GMPerLb,AVG_GMPerLb,BUD_GMPerLb,"+                                     
                                     "isnull(TDBrnExpBud,'0') as TDBrnExpBud, isnull(MTDBrnExpBud,'0') as MTDBrnExpBud, isnull(AvgBrnExpBud,'0') as AvgBrnExpBud, isnull(BUDBrnExpBud,'0') as BUDBrnExpBud";

                string _whereClause = "[Loc_No] = '" + ddlBranch.SelectedValue.ToString() + "'";
                                
                DataSet dsuserprofile = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));

                // Check whether any value has returned
                if (dsuserprofile.Tables[0].Rows.Count > 0)
                {
                    //Link Daily Branch Margin
                    HyperLink HLinkDBrnMgn = new HyperLink();
                    HLinkDBrnMgn.Target = "new";
                    HLinkDBrnMgn.Attributes["onclick"] = "return doOpen(this.href,'Margin')";
                    HLinkDBrnMgn.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=MarginRpt.aspx?Location=" + ddlBranch.SelectedValue + "~LocName=" + ddlBranch.SelectedItem + "~Range=Daily";
                    HLinkDBrnMgn.Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 0));
                    dtBrPerformance.Rows[1].Cells[1].Controls.Add(HLinkDBrnMgn);
                    _dayProfit = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 0));
                    //dtBrPerformance.Rows[1].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 0));

                    //Link MTD Branch Margin
                    HyperLink HLinkMBrnMgn = new HyperLink();
                    HLinkMBrnMgn.Target = "new";
                    HLinkMBrnMgn.Attributes["onclick"] = "return doOpen(this.href,'Margin')";
                    HLinkMBrnMgn.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=MarginRpt.aspx?Location=" + ddlBranch.SelectedValue + "~LocName=" + ddlBranch.SelectedItem + "~Range=MTD";
                    HLinkMBrnMgn.Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 0));
                    dtBrPerformance.Rows[1].Cells[3].Controls.Add(HLinkMBrnMgn);
                    _MTDProfit = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 0));
                    //dtBrPerformance.Rows[1].Cells[3].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 0));

                    dtBrPerformance.Rows[1].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GrossmarginDollar"].ToString()), 0));
                    dtBrPerformance.Rows[1].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_GrossmarginDollar"].ToString()), 0));

                    dtBrPerformance.Rows[2].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TDBrnExpBud"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TDBrnExpBud"].ToString()), 0));
                    dtBrPerformance.Rows[2].Cells[3].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTDBrnExpBud"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTDBrnExpBud"].ToString()), 0)); //dsuserprofile.Tables[0].Rows[0]["MTDBrnExpBud"].ToString();
                    dtBrPerformance.Rows[2].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AvgBrnExpBud"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AvgBrnExpBud"].ToString()), 0));
                    dtBrPerformance.Rows[2].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUDBrnExpBud"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUDBrnExpBud"].ToString()), 0));
                    //dtBrPerformance.Rows[2].Cells[2].Text = "-";

                    dtBrPerformance.Rows[4].Cells[1].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginPct"].ToString()), 4) * 100, 2));
                    dtBrPerformance.Rows[4].Cells[3].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginPct"].ToString()), 4) * 100, 2));
                    dtBrPerformance.Rows[4].Cells[2].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GrossmarginPct"].ToString()), 4) * 100, 2));
                    dtBrPerformance.Rows[4].Cells[5].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_GrossmarginPct"].ToString()), 4) * 100, 2));


                    //Link Daily Branch Sales
                    HyperLink HLinkDBrnSls = new HyperLink();
                    HLinkDBrnSls.Target = "new";
                    HLinkDBrnSls.Attributes["onclick"] = "return doOpen(this.href,'Sales')";
                    HLinkDBrnSls.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=SalesRpt.aspx?Location=" + ddlBranch.SelectedValue + "~LocName=" + ddlBranch.SelectedItem + "~Range=Daily";
                    HLinkDBrnSls.Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_SalesDollar"].ToString()), 0));
                    dtBrPerformance.Rows[5].Cells[1].Controls.Add(HLinkDBrnSls);
                    //dtBrPerformance.Rows[5].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_SalesDollar"].ToString()), 0));

                    //Link MTD Branch Sales
                    HyperLink HLinkMBrnSls = new HyperLink();
                    HLinkMBrnSls.Target = "new";
                    HLinkMBrnSls.Attributes["onclick"] = "return doOpen(this.href,'Sales')";
                    HLinkMBrnSls.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=SalesRpt.aspx?Location=" + ddlBranch.SelectedValue + "~LocName=" + ddlBranch.SelectedItem + "~Range=MTD";
                    HLinkMBrnSls.Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_SalesDollar"].ToString());
                    dtBrPerformance.Rows[5].Cells[3].Controls.Add(HLinkMBrnSls);
                    //dtBrPerformance.Rows[5].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_SalesDollar"].ToString());

                    dtBrPerformance.Rows[5].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_SalesDollar"].ToString()), 0));
                    dtBrPerformance.Rows[5].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_SalesDollar"].ToString()), 0));

                    //Link Right Click Options for Daily Branch Order Count
                    HyperLink HLinkDBrnOrders = new HyperLink();
                    string urlDBrnOrdHeader = "../DashboardDrilldown/ProgressBar.aspx?destPage=SOHeaderRpt.aspx?Location=" + ddlBranch.SelectedValue + "~LocName=" + ddlBranch.SelectedItem + "~Customer=******~Invoice=0000000000~Range=Daily";
                    string urlDBrnOrdCustomer = "../DashboardDrilldown/ProgressBar.aspx?destPage=SOCustomerRpt.aspx?Location=" + ddlBranch.SelectedValue + "~LocName=" + ddlBranch.SelectedItem + "~Customer=000000~Invoice=**********~Range=Daily";
                    HLinkDBrnOrders.Text = "<div onmouseover=\"title='Right click for more options'\" style='cursor:hand; text-decoration: underline;' oncontextmenu=\"Javascript:return false;\" id=divBrnOrderRptDaily onmousedown=\"ShowToolTip(event,'" + urlDBrnOrdHeader + "','" + urlDBrnOrdCustomer + "',this.id);\">" + Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_OrderCount"].ToString()), 0)) + "</div>";
                    dtBrPerformance.Rows[6].Cells[1].Controls.Add(HLinkDBrnOrders);
                    //dtBrPerformance.Rows[6].Cells[1].CssClass = "GridItemLink";
                    //dtBrPerformance.Rows[6].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_OrderCount"].ToString()), 0));
                    
                    dtBrPerformance.Rows[6].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_OrderCount"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_OrderCount"].ToString()), 0));
                    
                    //Link Right Click Options for MTD Branch Order Count
                    HyperLink HLinkMBrnOrders = new HyperLink();
                    string urlMBrnOrdHeader = "../DashboardDrilldown/ProgressBar.aspx?destPage=SOHeaderRpt.aspx?Location=" + ddlBranch.SelectedValue + "~LocName=" + ddlBranch.SelectedItem + "~Customer=******~Invoice=0000000000~Range=MTD";
                    string urlMBrnOrdCustomer = "../DashboardDrilldown/ProgressBar.aspx?destPage=SOCustomerRpt.aspx?Location=" + ddlBranch.SelectedValue + "~LocName=" + ddlBranch.SelectedItem + "~Customer=000000~Invoice=**********~Range=MTD";
                    HLinkMBrnOrders.Text = "<div onmouseover=\"title='Right click for more options'\" style='cursor:hand; text-decoration: underline;' oncontextmenu=\"Javascript:return false;\" id=divBrnOrderRptMTD onmousedown=\"ShowToolTip(event,'" + urlMBrnOrdHeader + "','" + urlMBrnOrdCustomer + "',this.id);\">" + RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_OrderCount"].ToString()) + "</div>";
                    dtBrPerformance.Rows[6].Cells[3].Controls.Add(HLinkMBrnOrders);
                    //dtBrPerformance.Rows[6].Cells[3].CssClass = "GridItemLink";
                    //dtBrPerformance.Rows[6].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_OrderCount"].ToString());
                    
                    dtBrPerformance.Rows[6].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_OrderCount"].ToString()), 0));

                    //Link Daily Branch Detail Line Count
                    HyperLink HLinkDBrnDtl = new HyperLink();
                    HLinkDBrnDtl.Target = "new";
                    HLinkDBrnDtl.Attributes["onclick"] = "return doOpen(this.href, 'Detail')";
                    HLinkDBrnDtl.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=SODetailRpt.aspx?Location=" + ddlBranch.SelectedValue + "~LocName=" + ddlBranch.SelectedItem + "~Customer=000000~Invoice=0000000000~Range=Daily";
                    HLinkDBrnDtl.Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LineCount"].ToString()), 0));
                    dtBrPerformance.Rows[7].Cells[1].Controls.Add(HLinkDBrnDtl);
                    //dtBrPerformance.Rows[7].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LineCount"].ToString()), 0));

                    dtBrPerformance.Rows[7].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LineCount"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LineCount"].ToString()), 0));

                    //Link MTD Branch Detail Line Count
                    HyperLink HLinkMBrnDtl = new HyperLink();
                    HLinkMBrnDtl.Target = "new";
                    HLinkMBrnDtl.Attributes["onclick"] = "return doOpen(this.href, 'Detail')";
                    HLinkMBrnDtl.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=SODetailRpt.aspx?Location=" + ddlBranch.SelectedValue + "~LocName=" + ddlBranch.SelectedItem + "~Customer=000000~Invoice=0000000000~Range=MTD";
                    HLinkMBrnDtl.Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_LineCount"].ToString());
                    dtBrPerformance.Rows[7].Cells[3].Controls.Add(HLinkMBrnDtl);                    
                    //dtBrPerformance.Rows[7].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_LineCount"].ToString());
                    
                    dtBrPerformance.Rows[7].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_LineCount"].ToString()), 0));

                    dtBrPerformance.Rows[8].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LbsShipped"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LbsShipped"].ToString()), 0));
                    dtBrPerformance.Rows[8].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_LbsShipped"].ToString());
                    dtBrPerformance.Rows[8].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LbsShipped"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LbsShipped"].ToString()), 0));
                    dtBrPerformance.Rows[8].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_LbsShipped"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_LbsShipped"].ToString()), 0));
                    

                    dtBrPerformance.Rows[9].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_PriceperLB"].ToString()), 3));
                    dtBrPerformance.Rows[9].Cells[3].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_PriceperLB"].ToString()), 3));
                    dtBrPerformance.Rows[9].Cells[2].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_PriceperLB"].ToString()), 3));
                    dtBrPerformance.Rows[9].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_PriceperLB"].ToString()), 3));

                    // Link Daily Branch GM Per Lb
                    HyperLink HLinkDBrnProfitLb = new HyperLink();
                    HLinkDBrnProfitLb.Target = "new";
                    HLinkDBrnProfitLb.Attributes["onclick"] = "return doOpen(this.href,'ProfitLb')";
                    HLinkDBrnProfitLb.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=ProfitLbRpt.aspx?Location=" + ddlBranch.SelectedValue + "~LocName=" + ddlBranch.SelectedItem + "~Range=Daily";
                    HLinkDBrnProfitLb.Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GMPerLb"].ToString()), 3));
                    dtBrPerformance.Rows[10].Cells[1].Controls.Add(HLinkDBrnProfitLb);
                    //dtBrPerformance.Rows[10].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GMPerLb"].ToString()), 3));

                    // Link MTD Branch GM Per Lb
                    HyperLink HLinkMBrnProfitLb = new HyperLink();
                    HLinkMBrnProfitLb.Target = "new";
                    HLinkMBrnProfitLb.Attributes["onclick"] = "return doOpen(this.href,'ProfitLb')";
                    HLinkMBrnProfitLb.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=ProfitLbRpt.aspx?Location=" + ddlBranch.SelectedValue + "~LocName=" + ddlBranch.SelectedItem + "~Range=MTD";
                    HLinkMBrnProfitLb.Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GMPerLb"].ToString()), 3));
                    dtBrPerformance.Rows[10].Cells[3].Controls.Add(HLinkMBrnProfitLb);
                    //dtBrPerformance.Rows[10].Cells[3].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GMPerLb"].ToString()), 3));

                    dtBrPerformance.Rows[10].Cells[2].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GMPerLb"].ToString()), 3));
                    dtBrPerformance.Rows[10].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_GMPerLb"].ToString()), 3));
                                        
                    #region Fill Forecast Field

                    int workDayofMonth =  fiscalCalendar.CurrentWorkDay;
                    int MoTotWorkDay = fiscalCalendar.MonthTotalWorkDay;

                    if (workDayofMonth > 0)
                    {
                        decimal MTDGPDol = Convert.ToDecimal(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 2));
                        decimal MTDBrExpBudget = Convert.ToDecimal(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTDBrnExpBud"].ToString()), 2));
                        decimal MTDSaleDol = Convert.ToDecimal(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_SalesDollar"].ToString()), 2));
                        decimal MTDNoOfOrder = Convert.ToDecimal(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_OrderCount"].ToString()), 2));
                        decimal MTDNoOfLines = Convert.ToDecimal(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_LineCount"].ToString()), 2));
                        decimal MTDNoOfLbShipped = Convert.ToDecimal(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_LbsShipped"].ToString()), 2));

                        string forecastGPDol = String.Format("{0:#,###}", Math.Round((((MTDGPDol / workDayofMonth)) * MoTotWorkDay), 0)).ToString();
                        string forecastBrExpBudget = String.Format("{0:#,###}", Math.Round((((MTDBrExpBudget / workDayofMonth)) * MoTotWorkDay), 0)).ToString();
                        string forecastSaleDol = String.Format("{0:#,###}", Math.Round((((MTDSaleDol / workDayofMonth)) * MoTotWorkDay), 0)).ToString();
                        string forecastNoOfOrder = String.Format("{0:#,###}", Math.Round((((MTDNoOfOrder / workDayofMonth)) * MoTotWorkDay), 0)).ToString();
                        string forecastNoOfLines = String.Format("{0:#,###}", Math.Round((((MTDNoOfLines / workDayofMonth)) * MoTotWorkDay), 0)).ToString();
                        string forecastNoOfLbsShipped = String.Format("{0:#,###}", Math.Round((((MTDNoOfLbShipped / workDayofMonth)) * MoTotWorkDay), 0)).ToString();


                        dtBrPerformance.Rows[1].Cells[4].Text = forecastGPDol;
                        dtBrPerformance.Rows[2].Cells[4].Text = (forecastBrExpBudget == "" ? "0" : forecastBrExpBudget);
                        dtBrPerformance.Rows[5].Cells[4].Text = RoundOffMTD(forecastSaleDol);
                        dtBrPerformance.Rows[6].Cells[4].Text = RoundOffMTD(forecastNoOfOrder);
                        dtBrPerformance.Rows[7].Cells[4].Text = RoundOffMTD(forecastNoOfLines);
                        dtBrPerformance.Rows[8].Cells[4].Text = RoundOffMTD(forecastNoOfLbsShipped);
                        //dtBrPerformance.Rows[2].Cells[4].Text = "-";

                        //Display branch Profit [ Profit = GM$ - Exp Bud ]                        
                        // Link Daily Branch Profit
                        HyperLink HLinkDBrnProfit = new HyperLink();
                        HLinkDBrnProfit.Target = "new";
                        HLinkDBrnProfit.Attributes["onclick"] = "return doOpen(this.href,'Profit')";
                        HLinkDBrnProfit.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=ProfitRpt.aspx?Location=" + ddlBranch.SelectedValue + "~LocName=" + ddlBranch.SelectedItem + "~Range=Daily";
                        HLinkDBrnProfit.Text = String.Format("{0:#,###}", (Convert.ToInt32(_dayProfit.Replace(",", "")) - Convert.ToInt32(dtBrPerformance.Rows[2].Cells[1].Text.Replace(",", ""))));
                        dtBrPerformance.Rows[3].Cells[1].Controls.Add(HLinkDBrnProfit);
                        //dtBrPerformance.Rows[3].Cells[1].Text = String.Format("{0:#,###}", (Convert.ToInt32(dtBrPerformance.Rows[1].Cells[1].Text.Replace(",", "")) - Convert.ToInt32(dtBrPerformance.Rows[2].Cells[1].Text.Replace(",", ""))));
                        
                        dtBrPerformance.Rows[3].Cells[2].Text = String.Format("{0:#,###}",(Convert.ToInt32(dtBrPerformance.Rows[1].Cells[2].Text.Replace(",", "")) - Convert.ToInt32(dtBrPerformance.Rows[2].Cells[2].Text.Replace(",", ""))));

                        // Link MTD Branch Profit
                        HyperLink HLinkMBrnProfit = new HyperLink();
                        HLinkMBrnProfit.Target = "new";
                        HLinkMBrnProfit.Attributes["onclick"] = "return doOpen(this.href,'Profit')";
                        HLinkMBrnProfit.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=ProfitRpt.aspx?Location=" + ddlBranch.SelectedValue + "~LocName=" + ddlBranch.SelectedItem + "~Range=MTD";
                        HLinkMBrnProfit.Text = String.Format("{0:#,###}", (Convert.ToInt32(_MTDProfit.Replace(",", "")) - Convert.ToInt32(dtBrPerformance.Rows[2].Cells[3].Text.Replace(",", ""))));
                        dtBrPerformance.Rows[3].Cells[3].Controls.Add(HLinkMBrnProfit);
                        //dtBrPerformance.Rows[3].Cells[3].Text = String.Format("{0:#,###}",(Convert.ToInt32(dtBrPerformance.Rows[1].Cells[3].Text.Replace(",", "")) - Convert.ToInt32(dtBrPerformance.Rows[2].Cells[3].Text.Replace(",", ""))));

                        dtBrPerformance.Rows[3].Cells[4].Text = String.Format("{0:#,###}",(Convert.ToInt32(dtBrPerformance.Rows[1].Cells[4].Text.Replace(",", "")) - Convert.ToInt32(dtBrPerformance.Rows[2].Cells[4].Text.Replace(",", ""))));
                        dtBrPerformance.Rows[3].Cells[5].Text = String.Format("{0:#,###}",(Convert.ToInt32(dtBrPerformance.Rows[1].Cells[5].Text.Replace(",", "")) - Convert.ToInt32(dtBrPerformance.Rows[2].Cells[5].Text.Replace(",", ""))));
                      
                    }
                    #endregion

                }
                else
                {
                    dtBrPerformance.Rows[1].Cells[1].Text = "0";
                    dtBrPerformance.Rows[1].Cells[3].Text = "0";
                    dtBrPerformance.Rows[1].Cells[2].Text = "0";
                    dtBrPerformance.Rows[1].Cells[4].Text = "0";
                    dtBrPerformance.Rows[2].Cells[1].Text = "0.0";
                    dtBrPerformance.Rows[2].Cells[3].Text = "0.0";
                    dtBrPerformance.Rows[2].Cells[2].Text = "0.0";
                    dtBrPerformance.Rows[2].Cells[4].Text = "0.0";
                    dtBrPerformance.Rows[3].Cells[1].Text = "0";
                    dtBrPerformance.Rows[3].Cells[3].Text = "0";
                    dtBrPerformance.Rows[3].Cells[2].Text = "0";
                    dtBrPerformance.Rows[3].Cells[4].Text = "0";

                    dtBrPerformance.Rows[4].Cells[1].Text = "0.00";
                    dtBrPerformance.Rows[4].Cells[3].Text = "0.00";
                    dtBrPerformance.Rows[4].Cells[2].Text = "0.00";
                    dtBrPerformance.Rows[4].Cells[4].Text = "0.00";
                    dtBrPerformance.Rows[5].Cells[1].Text = "0";
                    dtBrPerformance.Rows[5].Cells[3].Text = "0";
                    dtBrPerformance.Rows[5].Cells[2].Text = "0";
                    dtBrPerformance.Rows[5].Cells[4].Text = "0";
                    dtBrPerformance.Rows[6].Cells[1].Text = "0";
                    dtBrPerformance.Rows[6].Cells[3].Text = "0";
                    dtBrPerformance.Rows[6].Cells[2].Text = "0";
                    dtBrPerformance.Rows[6].Cells[4].Text = "0";
                    dtBrPerformance.Rows[7].Cells[1].Text = "0";
                    dtBrPerformance.Rows[7].Cells[3].Text = "0";
                    dtBrPerformance.Rows[7].Cells[2].Text = "0";
                    dtBrPerformance.Rows[7].Cells[4].Text = "0";
                    dtBrPerformance.Rows[8].Cells[1].Text = "0.00";
                    dtBrPerformance.Rows[8].Cells[3].Text = "0.00";
                    dtBrPerformance.Rows[8].Cells[2].Text = "0.00";
                    dtBrPerformance.Rows[8].Cells[4].Text = "0.00";
                    dtBrPerformance.Rows[9].Cells[1].Text = "0.000";
                    dtBrPerformance.Rows[9].Cells[3].Text = "0.000";
                    dtBrPerformance.Rows[9].Cells[2].Text = "0.000";
                    dtBrPerformance.Rows[9].Cells[4].Text = "0.000";
                    dtBrPerformance.Rows[10].Cells[1].Text = "0.000";
                    dtBrPerformance.Rows[10].Cells[2].Text = "0.000";
                    dtBrPerformance.Rows[10].Cells[3].Text = "0.000";
                    dtBrPerformance.Rows[10].Cells[4].Text = "0.000";                    
                }
            }
            catch (Exception ex)
            {
               
            }


        }
        /// <summary>
        ///  method Used to Get ALL Branches
        /// </summary>
        public void GetALLBranches()
        {

            try
            {
                salesReportUtils.GetAuthorizedBranches(ddlBranch, Session["UserID"].ToString());
                ddlBranch.SelectedValue = (Session["DefaultCompanyID"].ToString().Trim().Length == 1) ? "0" + Session["DefaultCompanyID"].ToString() : Session["DefaultCompanyID"].ToString();
                Session["DefaultBranchName"] = ddlBranch.SelectedItem.Text;
            }
            catch (Exception ex)
            {
                Response.Write(ex.Message);
            }
        }
        /// <summary>
        ///  method Used to Get ALL Regions
        /// </summary>
        public void GetALLRegions()
        {

            try
            {
                DataSet dsRegion = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, SP_GENERALSELECT,
                                           new SqlParameter("@tableName", "LocMaster"),
                                           new SqlParameter("@columnNames", "DISTINCT LocSalesGrp"),
                                           new SqlParameter("@whereCondition", " (ISNULL(RTRIM(LTRIM(LocSalesGrp)), '') <> '')"));

                ddlRegion.DataSource = dsRegion.Tables[0];
                ddlRegion.DataTextField = "LocSalesGrp";
                ddlRegion.DataValueField = "LocSalesGrp";
                ddlRegion.DataBind();
                ddlRegion.Items.Insert(0, new ListItem("ALL", "ALL"));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }        
        /// <summary>
        /// method Used to Load Announcement
        /// </summary>
        private void LoadAnnouncement()
        {
            try
            {
                // Local variable declaration
                string _tableName = "PFC_Announcements";
                string _columnName = "ID,[ShortDescription],Description,AnnouncementHeading,PlayFileName";
                string _whereClause = "1=1 and Status=1 order by ID Desc";

                DataSet dsAnnouncement = SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));


                // Check whether any value has returned
                if (dsAnnouncement.Tables[0].Rows.Count > 0)
                {
                    dgAnnouncement.DataSource = dsAnnouncement.Tables[0];
                    dgAnnouncement.DataBind();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        /// <summary>
        /// method Used to Load ShortCuts
        /// </summary>
        private void LoadShortCuts()
        {

            try
            {
                // Local variable declaration
                string _tableName = "PFC_UserFavourites";
                string _columnName = "[Content],[NavigateURL],ModuleID,Description,REqDashBoard,ClientExtAppsURL";
                string _whereClause = "[UserID] = '" + Session["UserID"].ToString() + "' and [Mode]=1";

                DataSet dsuserShortcuts = SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));


                // Check whether any value has returned
                if (dsuserShortcuts.Tables[0].Rows.Count > 0)
                {
                    dgShortCuts.DataSource = dsuserShortcuts.Tables[0];
                    dgShortCuts.DataBind();
                }
            }
            catch (Exception ex)
            {

            }
        }
        /// <summary>
        ///  method Used to LoadFavourites
        /// </summary>
        private void LoadFavourites()
        {
            try
            {
                // Local variable declaration
                string _tableName = "PFC_UserFavourites";
                string _columnName = "Content,NavigateURL";
                string _whereClause = "[UserID] = '" + Session["UserID"].ToString() + "' and Mode=2";

                DataSet dsuserFavourites = SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));


                // Check whether any value has returned
                if (dsuserFavourites.Tables[0].Rows.Count > 0)
                {
                    dgFavourite.DataSource = dsuserFavourites.Tables[0];
                    dgFavourite.DataBind();
                }
            }
            catch (Exception ex)
            {

            }
        }
        /// <summary>
        /// method Used to Get URL
        /// </summary>
        /// <param name="Container"></param>
        /// <returns>string NAvigate URL</returns>
        public string GetURL(object Container)
        {
            if (DataBinder.Eval(Container, "DataItem.NavigateURL") != null)
            {
                string URL = "";
                URL = Global.UmbrellaSiteURL + DataBinder.Eval(Container, "DataItem.NavigateURL").ToString();
                URL = "ModulePreprocessor.aspx?DestPage=" + Server.UrlEncode(PFC.Intranet.Securitylayer.Cryptor.Encrypt(URL)) + "&ModuleID=" + DataBinder.Eval(Container, "DataItem.ModuleID").ToString();
                return URL;
            }
            else
                return "#";
        }
        /// <summary>
        /// method Used to Get URL
        /// </summary>
        /// <param name="Container"></param>
        /// <returns>string NAvigate URL</returns>
        public string GetRedirectURL(object Container)
        {
            if (DataBinder.Eval(Container, "DataItem.NavigateURL") != null)
            {
                string URL = "";
                if (DataBinder.Eval(Container, "DataItem.NavigateURL").ToString().ToLower().StartsWith("www"))
                {
                    URL = "http://" + DataBinder.Eval(Container, "DataItem.NavigateURL").ToString().Replace("http://", "").ToString();                    
                }
                else
                {
                    URL = DataBinder.Eval(Container, "DataItem.NavigateURL").ToString();
                }
                return URL;
            }
            else
                return "#";
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="Container"></param>
        /// <returns></returns>
        public string GetAnnouncementURL(object Container)
        {
            if (DataBinder.Eval(Container, "DataItem.ID") != null)
            {
                string URL = "";

                if (DataBinder.Eval(Container, "DataItem.PlayFileName").ToString() == string.Empty || DataBinder.Eval(Container, "DataItem.PlayFileName").ToString() == null)
                {
                    URL = Global.IntranetSiteURL + "News/Announcement.aspx?NewsID='" + DataBinder.Eval(Container, "DataItem.ID").ToString() + "'&Type=" + DataBinder.Eval(Container, "DataItem.AnnouncementHeading").ToString();
                    return URL;
                }
                else
                {
                    URL = Global.UmbrellaSiteURL + "Applications/AppModule/Announcement/NewsFiles/" + DataBinder.Eval(Container, "DataItem.PlayFileName").ToString();
                    return URL;
                }
            }
            else
                return "#";
        }
        /// <summary>
        /// method Used to Get URL
        /// </summary>
        /// <param name="Container"></param>
        /// <returns>string NAvigate URL</returns>
        public string GetDoURL(object Container)
        {
            if (DataBinder.Eval(Container, "DataItem.ID") != null)
            {
                string URL = "";
                URL = "Description.aspx?DolistID=" + DataBinder.Eval(Container, "DataItem.ID").ToString();
                return URL;
            }
            else
                return "#";
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="Container"></param>
        /// <returns></returns>
        public string GetTipsURL(object Container)
        {
            if (DataBinder.Eval(Container, "DataItem.ID") != null)
            {
                string URL = "";


                if (DataBinder.Eval(Container, "DataItem.PlayFileName").ToString() == string.Empty || DataBinder.Eval(Container, "DataItem.PlayFileName").ToString() == null)
                {
                    URL = Global.IntranetSiteURL + "News/MarketingTips.aspx?NewsID='" + DataBinder.Eval(Container, "DataItem.ID").ToString() + "'&Type=" + DataBinder.Eval(Container, "DataItem.TipsHeading").ToString();
                    return URL;
                }
                else
                {
                    URL = Global.UmbrellaSiteURL + "Applications/AppModule/MarketingTips/NewsFiles/" + DataBinder.Eval(Container, "DataItem.PlayFileName").ToString();
                    return URL;
                }
            }
            else
                return "#";
        }
        /// <summary>
        ///  method Used to Load Do list
        /// </summary>
        private void LoadDolist()
        {
            try
            {
                // Local variable declaration
                string _tableName = "PFC_UserFavourites";
                string _columnName = "ID,[Content],Description";
                string _whereClause = "[UserID] = '" + Session["UserID"].ToString() + "' and Mode=3";

                DataSet dsuserDolist = SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));


                // Check whether any value has returned
                if (dsuserDolist.Tables[0].Rows.Count > 0)
                {
                    dgDolist.DataSource = dsuserDolist.Tables[0];
                    dgDolist.DataBind();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        /// <summary>
        /// method Used to Display User Profile
        /// </summary>
        private void DisplayCorpSalesReport()
        {
            try
            {
                string _tableName = string.Empty;
                string _columnName = string.Empty;
                string _whereClause = string.Empty;
                string _dayProfit = string.Empty;
                string _MTDProfit = string.Empty;
                //Local variable declaration
                GetCurDateTime();

                if (Session["UserType"].ToString().Trim() == "Customer Sales Rep" || Session["UserType"].ToString().Trim() == "Regional Manager")
                {
                    _columnName = "'' as 'GrossmarginDollar',isnull(TD_GrossmarginDollar,'0') as TD_GrossmarginDollar,isnull(MTD_GrossmarginDollar,'0') as MTD_GrossmarginDollar,isnull(AVG_GrossmarginDollar,'0') as AVG_GrossmarginDollar," +
                                    "isnull(LMTD_GrossmarginDollar,'0') as LMTD_GrossmarginDollar,'' as 'GrossmarginDollarpct',isnull(TD_GrossmarginPct,'0') as TD_GrossmarginPct,isnull(MTD_GrossmarginPct,'0') as MTD_GrossmarginPct," +
                                    "isnull(AVG_Grossmarginpct,'0') as AVG_Grossmarginpct,isnull(LMTD_Grossmarginpct,'0') as LMTD_Grossmarginpct,'' as 'SalesDollar',isnull(TD_SalesDollar,'0') as TD_SalesDollar," +
                                    "isnull(MTD_SalesDollar,'0') as MTD_SalesDollar,isnull(AVG_SalesDollar,'0') as AVG_SalesDollar,isnull(LMTD_SalesDollar,'0') as LMTD_SalesDollar,'' as 'NoofOrder'," +
                                    "isnull(TD_OrderCount,'0') as TD_OrderCount,isnull(MTD_OrderCount,'0') as MTD_OrderCount,isnull(AVG_OrderCount,'0') as AVG_OrderCount,isnull(LMTD_OrderCount,'0') as LMTD_OrderCount," +
                                    "'' as 'NoofLines'," +
                                    "isnull(TD_LineCount,'0') as TD_LineCount,isnull(MTD_LineCount,'0') as MTD_LineCount,isnull(AVG_LineCount,'0') as AVG_LineCount,isnull(LMTD_LineCount,'0') as LMTD_LineCount,'' as 'lbsShipped'," +
                                    "isnull(TD_LbsShipped,'0') as TD_LbsShipped,isnull(MTD_LbsShipped,'0') as MTD_LbsShipped,isnull(AVG_LbsShipped,'0') as AVG_LbsShipped,isnull(LMTD_LbsShipped,'0') as LMTD_LbsShipped,'' as 'priceperlbs'," +
                                    "isnull(TD_PriceperLB,'0') as TD_PriceperLB,isnull(MTD_PriceperLB,'0') as MTD_PriceperLB,isnull(AVG_PriceperLB,'0') as AVG_PriceperLB,isnull(LMTD_PriceperLB,'0') as LMTD_PriceperLB" +
                                    ",isnull(TD_GMPerLb,'0') as TD_GMPerLb,isnull(MTD_GMPerLb,'0') as MTD_GMPerLb,isnull(AVG_GMPerLb,'0') as AVG_GMPerLb";
                    _tableName = "Dashboard_UserLoc";
                    _whereClause = "[UserID] = '" + Session["UserName"].ToString() + "' and [Loc_No] = '" + Session["BranchID"].ToString() + "'";
                    dtUserProfile.Rows[0].Cells[2].Text = "Br Avg";
                    dtUserProfile.Rows[0].Cells[5].Text = "LMTD";
                }
                else if (Session["UserType"].ToString().Trim() == "Executive Management")
                {
                    _columnName = "'' as 'GrossmarginDollar',TD_GrossmarginDollar,MTD_GrossmarginDollar,AVG_GrossmarginDollar,BUD_GrossmarginDollar,'' as 'GrossmarginDollarpct',TD_GrossmarginPct,MTD_GrossmarginPct,AVG_Grossmarginpct,BUD_Grossmarginpct,'' as 'SalesDollar',TD_SalesDollar,MTD_SalesDollar,AVG_SalesDollar,BUD_SalesDollar,'' as 'NoofOrder'," +
                                    "TD_OrderCount,MTD_OrderCount,AVG_OrderCount,BUD_OrderCount,'' as 'NoofLines',TD_LineCount,MTD_LineCount,AVG_LineCount,BUD_LineCount,'' as 'lbsShipped',TD_LbsShipped,MTD_LbsShipped,AVG_LbsShipped,BUD_LbsShipped,'' as 'priceperlbs',TD_PriceperLB,MTD_PriceperLB,AVG_PriceperLB,BUD_PriceperLB,"+
                                    "TD_GMPerLb,MTD_GMPerLb,AVG_GMPerLb,BUD_GMPerLb,"+
                                    "isnull(TDBrnExpBud,'0') as TDBrnExpBud,isnull(MTDBrnExpBud,'0') as MTDBrnExpBud, isnull(AvgBrnExpBud,'0') as AvgBrnExpBud, isnull(BUDBrnExpBud,'0') as BUDBrnExpBud";
                    _tableName = "Dashboard_Company";
                    _whereClause = "1=1";
                    dtUserProfile.Rows[0].Cells[2].Text = "Corp Avg";
                    dtUserProfile.Rows[0].Cells[5].Text = "Budget";

                }
                else if (Session["UserType"].ToString().Trim() == "Vice President of East Coast Sales")
                {
                    _columnName = "TD_GrossmarginDollar,MTD_GrossmarginDollar,AVG_GrossmarginDollar,BUD_GrossmarginDollar,'' as 'GrossmarginDollarpct',TD_GrossmarginPct,MTD_GrossmarginPct,AVG_Grossmarginpct,BUD_Grossmarginpct,'' as 'SalesDollar',TD_SalesDollar,MTD_SalesDollar,AVG_SalesDollar,BUD_SalesDollar,'' as 'NoofOrder'," +
                                   "TD_OrderCount,MTD_OrderCount,AVG_OrderCount,BUD_OrderCount,'' as 'NoofLines',TD_LineCount,MTD_LineCount,AVG_LineCount,BUD_LineCount,'' as 'lbsShipped',TD_LbsShipped,MTD_LbsShipped,AVG_LbsShipped,BUD_LbsShipped,'' as 'priceperlbs',TD_PriceperLB,MTD_PriceperLB,AVG_PriceperLB,BUD_PriceperLB,"+
                                   "TD_GMPerLb,MTD_GMPerLb,AVG_GMPerLb,BUD_GMPerLb";
                    _tableName = "Dashboard_EastRegion";
                    _whereClause = "1=1";
                    dtUserProfile.Rows[0].Cells[2].Text = "Reg Avg";
                    dtUserProfile.Rows[0].Cells[5].Text = "Budget";
                }
                else if (Session["UserType"].ToString().Trim() == "Vice President of West Coast Sales")
                {
                    _columnName = "'' as 'GrossmarginDollar',TD_GrossmarginDollar,MTD_GrossmarginDollar,AVG_GrossmarginDollar,BUD_GrossmarginDollar,'' as 'GrossmarginDollarpct',TD_GrossmarginPct,MTD_GrossmarginPct,AVG_Grossmarginpct,BUD_Grossmarginpct,'' as 'SalesDollar',TD_SalesDollar,MTD_SalesDollar,AVG_SalesDollar,BUD_SalesDollar,'' as 'NoofOrder'," +
                                  "TD_OrderCount,MTD_OrderCount,AVG_OrderCount,BUD_OrderCount,'' as 'NoofLines',TD_LineCount,MTD_LineCount,AVG_LineCount,BUD_LineCount,'' as 'lbsShipped',TD_LbsShipped,MTD_LbsShipped,AVG_LbsShipped,BUD_LbsShipped,'' as 'priceperlbs',TD_PriceperLB,MTD_PriceperLB,AVG_PriceperLB,BUD_PriceperLB,"+
                                  "TD_GMPerLb,MTD_GMPerLb,AVG_GMPerLb,BUD_GMPerLb";
                    _tableName = "Dashboard_WestRegion";
                    _whereClause = "1=1";
                    dtUserProfile.Rows[0].Cells[2].Text = "Reg Avg";
                    dtUserProfile.Rows[0].Cells[5].Text = "Budget";
                }
                else
                {
                    _tableName = "Dashboard_UserLoc";
                    dtUserProfile.Rows[0].Cells[2].Text = "Br Avg";
                    dtUserProfile.Rows[0].Cells[5].Text = "LMTD";
                    _whereClause = "[UserID] = '" + Session["UserName"].ToString() + "' and [Curmonth]='" + curMonth + "' and  [CurYear]='" + curYear + "' and [Loc_No] = '" + Session["BranchID"].ToString() + "'";
                    _columnName =   "'' as 'GrossmarginDollar',TD_GrossmarginDollar,MTD_GrossmarginDollar,AVG_GrossmarginDollar,LMTD_GrossmarginDollar,'' as 'GrossmarginDollarpct',TD_GrossmarginPct,MTD_GrossmarginPct,AVG_Grossmarginpct,LMTD_Grossmarginpct,'' as 'SalesDollar',TD_SalesDollar,MTD_SalesDollar,AVG_SalesDollar,LMTD_SalesDollar,'' as 'NoofOrder'," +
                                    "TD_OrderCount,MTD_OrderCount,AVG_OrderCount,LMTD_OrderCount,'' as 'NoofLines',TD_LineCount,MTD_LineCount,AVG_LineCount,LMTD_LineCount,'' as 'lbsShipped',TD_LbsShipped,MTD_LbsShipped,AVG_LbsShipped,LMTD_LbsShipped,'' as 'priceperlbs',TD_PriceperLB,MTD_PriceperLB,AVG_PriceperLB,LMTD_PriceperLB"+
                                    ",TD_GMPerLb,MTD_GMPerLb,AVG_GMPerLb"; 
                }

                DataSet dsuserprofile = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));

                

                // Check whether any value has returned
                if (dsuserprofile.Tables[0].Rows.Count > 0)
                {
                    //Link Daily Corporate Margin
                    HyperLink HLinkDCorpMgn = new HyperLink();
                    HLinkDCorpMgn.Target = "new";
                    HLinkDCorpMgn.Attributes["onclick"] = "return doOpen(this.href, 'Margin')";
                    HLinkDCorpMgn.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=MarginRpt.aspx?Location=00~LocName=Corporate~Range=Daily";
                    HLinkDCorpMgn.Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 2));
                    dtUserProfile.Rows[1].Cells[1].Controls.Add(HLinkDCorpMgn);
                    _dayProfit = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 2));
                    //dtUserProfile.Rows[1].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 2));
 
                    //Link MTD Corporate Margin
                    HyperLink HLinkMCorpMgn = new HyperLink();
                    HLinkMCorpMgn.Target = "new";
                    HLinkMCorpMgn.Attributes["onclick"] = "return doOpen(this.href, 'Margin')";
                    HLinkMCorpMgn.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=MarginRpt.aspx?Location=00~LocName=Corporate~Range=MTD";
                    HLinkMCorpMgn.Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 2));
                    dtUserProfile.Rows[1].Cells[3].Controls.Add(HLinkMCorpMgn);
                    _MTDProfit = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 2));
                    //dtUserProfile.Rows[1].Cells[3].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 2));

                    dtUserProfile.Rows[1].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GrossmarginDollar"].ToString()), 2));

                    dtUserProfile.Rows[4].Cells[1].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginPct"].ToString()), 4) * 100, 2));
                    dtUserProfile.Rows[4].Cells[3].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginPct"].ToString()), 4) * 100, 2));
                    dtUserProfile.Rows[4].Cells[2].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GrossmarginPct"].ToString()), 4) * 100, 2));

                    //Link Daily Corporate Sales
                    HyperLink HLinkDCorpSls = new HyperLink();
                    HLinkDCorpSls.Target = "new";
                    HLinkDCorpSls.Attributes["onclick"] = "return doOpen(this.href, 'Sales')";
                    HLinkDCorpSls.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=SalesRpt.aspx?Location=00~LocName=Corporate~Range=Daily";
                    HLinkDCorpSls.Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_SalesDollar"].ToString()), 0));
                    dtUserProfile.Rows[5].Cells[1].Controls.Add(HLinkDCorpSls);
                    //dtUserProfile.Rows[5].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_SalesDollar"].ToString()), 0));

                    //Link MTD Corporate Sales
                    HyperLink HLinkMCorpSls = new HyperLink();
                    HLinkMCorpSls.Target = "new";
                    HLinkMCorpSls.Attributes["onclick"] = "return doOpen(this.href, 'Sales')";
                    HLinkMCorpSls.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=SalesRpt.aspx?Location=00~LocName=Corporate~Range=MTD";
                    HLinkMCorpSls.Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_SalesDollar"].ToString());
                    dtUserProfile.Rows[5].Cells[3].Controls.Add(HLinkMCorpSls);
                    //dtUserProfile.Rows[5].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_SalesDollar"].ToString());

                    dtUserProfile.Rows[5].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_SalesDollar"].ToString()), 0)); ;

                    //Link Right Click Options for Daily Corporate Order Count
                    HyperLink HLinkDCorpOrders = new HyperLink();
                    string urlDCorpOrdHeader = "../DashboardDrilldown/ProgressBar.aspx?destPage=SOHeaderRpt.aspx?Location=00~LocName=Corporate~Customer=******~Invoice=0000000000~Range=Daily";
                    string urlDCorpOrdCustomer = "../DashboardDrilldown/ProgressBar.aspx?destPage=SOCustomerRpt.aspx?Location=00~LocName=Corporate~Customer=000000~Invoice=**********~Range=Daily";
                    HLinkDCorpOrders.Text = "<div onmouseover=\"title='Right click for more options'\" style='cursor:hand; text-decoration: underline;' oncontextmenu=\"Javascript:return false;\" id=divCorpOrderRptDaily onmousedown=\"ShowToolTip(event,'" + urlDCorpOrdHeader + "','" + urlDCorpOrdCustomer + "',this.id);\">" + Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_OrderCount"].ToString()), 0)) + "</div>";
                    dtUserProfile.Rows[6].Cells[1].Controls.Add(HLinkDCorpOrders);
                    //dtUserProfile.Rows[6].Cells[1].CssClass = "GridItemLink";
                    //dtUserProfile.Rows[6].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_OrderCount"].ToString()), 0));

                    //Link Right Click Options for MTD Corporate Order Count
                    HyperLink HLinkMCorpOrders = new HyperLink();
                    string urlMCorpOrdHeader = "../DashboardDrilldown/ProgressBar.aspx?destPage=SOHeaderRpt.aspx?Location=00~LocName=Corporate~Customer=******~Invoice=0000000000~Range=MTD";
                    string urlMCorpOrdCustomer = "../DashboardDrilldown/ProgressBar.aspx?destPage=SOCustomerRpt.aspx?Location=00~LocName=Corporate~Customer=000000~Invoice=**********~Range=MTD";
                    HLinkMCorpOrders.Text = "<div onmouseover=\"title='Right click for more options'\" style='cursor:hand; text-decoration: underline;' oncontextmenu=\"Javascript:return false;\" id=divCorpOrderRptMTD onmousedown=\"ShowToolTip(event,'" + urlMCorpOrdHeader + "','" + urlMCorpOrdCustomer + "',this.id);\">" + RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_OrderCount"].ToString()) + "</div>";
                    dtUserProfile.Rows[6].Cells[3].Controls.Add(HLinkMCorpOrders);
                    //dtUserProfile.Rows[6].Cells[3].CssClass = "GridItemLink";                    
                    //dtUserProfile.Rows[6].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_OrderCount"].ToString());

                    dtUserProfile.Rows[6].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_OrderCount"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_OrderCount"].ToString()), 0)); ;

                    //Link Daily Corporate Detail Line Count
                    HyperLink HLinkDCorpDtl = new HyperLink();
                    HLinkDCorpDtl.Target = "new";
                    HLinkDCorpDtl.Attributes["onclick"] = "return doOpen(this.href, 'Detail')";
                    HLinkDCorpDtl.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=SODetailRpt.aspx?Location=00~LocName=Corporate~Customer=000000~Invoice=0000000000~Range=Daily";
                    HLinkDCorpDtl.Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LineCount"].ToString()), 0));
                    dtUserProfile.Rows[7].Cells[1].Controls.Add(HLinkDCorpDtl);
                    //dtUserProfile.Rows[7].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LineCount"].ToString()), 0));

                    //Link MTD Corporate Detail Line Count
                    HyperLink HLinkMCorpDtl = new HyperLink();
                    HLinkMCorpDtl.Target = "new";
                    HLinkMCorpDtl.Attributes["onclick"] = "return doOpen(this.href, 'Detail')";
                    HLinkMCorpDtl.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=SODetailRpt.aspx?Location=00~LocName=Corporate~Customer=000000~Invoice=0000000000~Range=MTD";
                    HLinkMCorpDtl.Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_LineCount"].ToString());
                    dtUserProfile.Rows[7].Cells[3].Controls.Add(HLinkMCorpDtl);
                    //dtUserProfile.Rows[7].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_LineCount"].ToString());

                    dtUserProfile.Rows[7].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LineCount"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LineCount"].ToString()), 0)); ;

                    dtUserProfile.Rows[8].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LbsShipped"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LbsShipped"].ToString()), 0));
                    dtUserProfile.Rows[8].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_LbsShipped"].ToString());
                    dtUserProfile.Rows[8].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LbsShipped"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LbsShipped"].ToString()), 0)); ;

                    dtUserProfile.Rows[9].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_PriceperLB"].ToString()), 3));
                    dtUserProfile.Rows[9].Cells[2].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_PriceperLB"].ToString()), 3));
                    dtUserProfile.Rows[9].Cells[3].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_PriceperLB"].ToString()), 3));
                    

                    //To display Gross margin per lbs field
                    // Link Daily Corporate Profit Per Lb
                    HyperLink HLinkDCorpProfitLb = new HyperLink();
                    HLinkDCorpProfitLb.Target = "new";
                    HLinkDCorpProfitLb.Attributes["onclick"] = "return doOpen(this.href, 'ProfitLb')";
                    HLinkDCorpProfitLb.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=ProfitLbRpt.aspx?Location=00~LocName=Corporate~Range=Daily";
                    HLinkDCorpProfitLb.Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GMPerLb"].ToString()), 3));
                    dtUserProfile.Rows[10].Cells[1].Controls.Add(HLinkDCorpProfitLb);
                    //dtUserProfile.Rows[10].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GMPerLb"].ToString()), 3));
                    
                    dtUserProfile.Rows[10].Cells[2].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GMPerLb"].ToString()), 3));

                    // Link MTD Corporate Profit Per Lb
                    HyperLink HLinkMCorpProfitLb = new HyperLink();
                    HLinkMCorpProfitLb.Target = "new";
                    HLinkMCorpProfitLb.Attributes["onclick"] = "return doOpen(this.href, 'ProfitLb')";
                    HLinkMCorpProfitLb.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=ProfitLbRpt.aspx?Location=00~LocName=Corporate~Range=MTD";
                    HLinkMCorpProfitLb.Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GMPerLb"].ToString()), 3));
                    dtUserProfile.Rows[10].Cells[3].Controls.Add(HLinkMCorpProfitLb);
                    //dtUserProfile.Rows[10].Cells[3].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GMPerLb"].ToString()), 3));
                    
                    dtUserProfile.Rows[10].Cells[5].Text = "0.000";

                    if (Session["UserType"].ToString().Trim() == "Customer Sales Rep" || Session["UserType"].ToString().Trim() == "Regional Manager")
                    {
                        dtUserProfile.Rows[1].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_GrossmarginDollar"].ToString()), 2));
                        dtUserProfile.Rows[4].Cells[5].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_GrossmarginPct"].ToString()), 4) * 100, 2));
                        dtUserProfile.Rows[5].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_SalesDollar"].ToString()), 2));
                        dtUserProfile.Rows[6].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_OrderCount"].ToString()), 0));
                        dtUserProfile.Rows[7].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_LineCount"].ToString()), 0));
                        dtUserProfile.Rows[8].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_LbsShipped"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_LbsShipped"].ToString()), 2));
                        dtUserProfile.Rows[9].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_PriceperLB"].ToString()), 3));
                    }
                    else if (Session["UserType"].ToString().Trim() == "Vice President of East Coast Sales" || Session["UserType"].ToString().Trim() == "Vice President of West Coast Sales" || Session["UserType"].ToString().Trim() == "Executive Management")
                    {
                        dtUserProfile.Rows[1].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_GrossmarginDollar"].ToString()), 0));
                        dtUserProfile.Rows[4].Cells[5].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_GrossmarginPct"].ToString()), 4) * 100, 2));
                        dtUserProfile.Rows[5].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_SalesDollar"].ToString()), 0));
                        dtUserProfile.Rows[6].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_OrderCount"].ToString()), 0));
                        dtUserProfile.Rows[7].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_LineCount"].ToString()), 0));
                        dtUserProfile.Rows[8].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_LbsShipped"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_LbsShipped"].ToString()), 0));
                        dtUserProfile.Rows[9].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_PriceperLB"].ToString()), 3));
                        dtUserProfile.Rows[10].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_GMPerLb"].ToString()), 3));
                    }
                    else
                    {
                        dtUserProfile.Rows[1].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_GrossmarginDollar"].ToString()), 2));
                        dtUserProfile.Rows[4].Cells[5].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_GrossmarginPct"].ToString()), 4) * 100, 2));
                        dtUserProfile.Rows[5].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_SalesDollar"].ToString()), 2));
                        dtUserProfile.Rows[6].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_OrderCount"].ToString()), 0));
                        dtUserProfile.Rows[7].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_LineCount"].ToString()), 0));
                        dtUserProfile.Rows[8].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_LbsShipped"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_LbsShipped"].ToString()), 2));
                        dtUserProfile.Rows[9].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_PriceperLB"].ToString()), 3));
                    }

                    if (Session["UserType"].ToString().Trim() == "Executive Management")
                    {
                        // To display Br Exp Budget
                        dtUserProfile.Rows[2].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TDBrnExpBud"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TDBrnExpBud"].ToString()), 2));
                        dtUserProfile.Rows[2].Cells[3].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTDBrnExpBud"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTDBrnExpBud"].ToString()), 2));
                        dtUserProfile.Rows[2].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUDBrnExpBud"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUDBrnExpBud"].ToString()), 2));
                        dtUserProfile.Rows[2].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AvgBrnExpBud"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AvgBrnExpBud"].ToString()), 2));

                        #region  Fill Forecast & Profit Field

                        int workDayofMonth = fiscalCalendar.CurrentWorkDay;
                        int MoTotWorkDay = fiscalCalendar.MonthTotalWorkDay;

                        if (workDayofMonth > 0)
                        {
                            decimal MTDGPDol = Convert.ToDecimal(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 2));

                            decimal MTDSaleDol = Convert.ToDecimal(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_SalesDollar"].ToString()), 2));
                            decimal MTDNoOfOrder = Convert.ToDecimal(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_OrderCount"].ToString()), 2));
                            decimal MTDNoOfLines = Convert.ToDecimal(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_LineCount"].ToString()), 2));
                            decimal MTDNoOfLbShipped = Convert.ToDecimal(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_LbsShipped"].ToString()), 2));

                            decimal MTDExpBud = Convert.ToDecimal(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTDBrnExpBud"].ToString()), 2));

                            string forecastGPDol = String.Format("{0:#,###}", Math.Round((((MTDGPDol / workDayofMonth)) * MoTotWorkDay), 0)).ToString();
                            string forecastSaleDol = String.Format("{0:#,###}", Math.Round((((MTDSaleDol / workDayofMonth)) * MoTotWorkDay), 0)).ToString();
                            string forecastNoOfOrder = String.Format("{0:#,###}", Math.Round((((MTDNoOfOrder / workDayofMonth)) * MoTotWorkDay), 0)).ToString();
                            string forecastNoOfLines = String.Format("{0:#,###}", Math.Round((((MTDNoOfLines / workDayofMonth)) * MoTotWorkDay), 0)).ToString();
                            string forecastNoOfLbsShipped = String.Format("{0:#,###}", Math.Round((((MTDNoOfLbShipped / workDayofMonth)) * MoTotWorkDay), 0)).ToString();
                            string forecastExpBud = String.Format("{0:#,###}", Math.Round((((MTDExpBud / workDayofMonth)) * MoTotWorkDay), 0)).ToString();


                            dtUserProfile.Rows[1].Cells[4].Text = forecastGPDol;
                            dtUserProfile.Rows[5].Cells[4].Text = RoundOffMTD(forecastSaleDol);
                            dtUserProfile.Rows[6].Cells[4].Text = RoundOffMTD(forecastNoOfOrder);
                            dtUserProfile.Rows[7].Cells[4].Text = RoundOffMTD(forecastNoOfLines);
                            dtUserProfile.Rows[8].Cells[4].Text = RoundOffMTD(forecastNoOfLbsShipped);
                            dtUserProfile.Rows[2].Cells[4].Text = forecastExpBud;

                            //Display Corp Profit [ Profit = GM$ - Exp Bud ]                        
                            // Link Daily Corporate Profit
                            HyperLink HLinkDCorpProfit = new HyperLink();
                            HLinkDCorpProfit.Target = "new";
                            HLinkDCorpProfit.Attributes["onclick"] = "return doOpen(this.href, 'Profit')";
                            HLinkDCorpProfit.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=ProfitRpt.aspx?Location=00~LocName=Corporate~Range=Daily";
                            HLinkDCorpProfit.Text = String.Format("{0:#,###}", (Convert.ToInt32(_dayProfit.Replace(",", "")) - Convert.ToInt32(dtUserProfile.Rows[2].Cells[1].Text.Replace(",", ""))));
                            dtUserProfile.Rows[3].Cells[1].Controls.Add(HLinkDCorpProfit);
                            //dtUserProfile.Rows[3].Cells[1].Text = String.Format("{0:#,###}", (Convert.ToInt32(dtUserProfile.Rows[1].Cells[1].Text.Replace(",", "")) - Convert.ToInt32(dtUserProfile.Rows[2].Cells[1].Text.Replace(",", ""))));
                            
                            dtUserProfile.Rows[3].Cells[2].Text = String.Format("{0:#,###}", (Convert.ToInt32(dtUserProfile.Rows[1].Cells[2].Text.Replace(",", "")) - Convert.ToInt32(dtUserProfile.Rows[2].Cells[2].Text.Replace(",", ""))));

                            // Link MTD Corporate Profit
                            HyperLink HLinkMCorpProfit = new HyperLink();
                            HLinkMCorpProfit.Target = "new";
                            HLinkMCorpProfit.Attributes["onclick"] = "return doOpen(this.href, 'Profit')";
                            HLinkMCorpProfit.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=ProfitRpt.aspx?Location=00~LocName=Corporate~Range=MTD";
                            HLinkMCorpProfit.Text = String.Format("{0:#,###}", (Convert.ToInt32(_MTDProfit.Replace(",", "")) - Convert.ToInt32(dtUserProfile.Rows[2].Cells[3].Text.Replace(",", ""))));
                            dtUserProfile.Rows[3].Cells[3].Controls.Add(HLinkMCorpProfit);
                            //dtUserProfile.Rows[3].Cells[3].Text = String.Format("{0:#,###}", (Convert.ToInt32(dtUserProfile.Rows[1].Cells[3].Text.Replace(",", "")) - Convert.ToInt32(dtUserProfile.Rows[2].Cells[3].Text.Replace(",", ""))));
                            
                            dtUserProfile.Rows[3].Cells[4].Text = String.Format("{0:#,###}", (Convert.ToInt32(dtUserProfile.Rows[1].Cells[4].Text.Replace(",", "")) - Convert.ToInt32(dtUserProfile.Rows[2].Cells[4].Text.Replace(",", ""))));
                            dtUserProfile.Rows[3].Cells[5].Text = String.Format("{0:#,###}", (Convert.ToInt32(dtUserProfile.Rows[1].Cells[5].Text.Replace(",", "")) - Convert.ToInt32(dtUserProfile.Rows[2].Cells[5].Text.Replace(",", ""))));

                        }

                        #endregion
                    }                                    
                    
                }
                else
                {

                    dtUserProfile.Rows[1].Cells[1].Text = "0";
                    dtUserProfile.Rows[1].Cells[2].Text = "0";
                    dtUserProfile.Rows[1].Cells[3].Text = "0";
                    dtUserProfile.Rows[1].Cells[4].Text = "0";
                    dtUserProfile.Rows[1].Cells[5].Text = "0";
                    dtUserProfile.Rows[2].Cells[1].Text = "0";
                    dtUserProfile.Rows[2].Cells[2].Text = "0";
                    dtUserProfile.Rows[2].Cells[3].Text = "0";
                    dtUserProfile.Rows[2].Cells[4].Text = "0";
                    dtUserProfile.Rows[2].Cells[5].Text = "0";

                    dtUserProfile.Rows[3].Cells[1].Text = "0";
                    dtUserProfile.Rows[3].Cells[2].Text = "0";
                    dtUserProfile.Rows[3].Cells[3].Text = "0";
                    dtUserProfile.Rows[3].Cells[4].Text = "0";
                    dtUserProfile.Rows[3].Cells[5].Text = "0";

                    dtUserProfile.Rows[4].Cells[1].Text = "0.00";
                    dtUserProfile.Rows[4].Cells[2].Text = "0.00";
                    dtUserProfile.Rows[4].Cells[3].Text = "0.00";
                    dtUserProfile.Rows[4].Cells[4].Text = "0.00";
                    dtUserProfile.Rows[4].Cells[5].Text = "0.00";
                    dtUserProfile.Rows[5].Cells[1].Text = "0";
                    dtUserProfile.Rows[5].Cells[2].Text = "0";
                    dtUserProfile.Rows[5].Cells[3].Text = "0";
                    dtUserProfile.Rows[5].Cells[4].Text = "0";
                    dtUserProfile.Rows[5].Cells[5].Text = "0";
                    dtUserProfile.Rows[6].Cells[1].Text = "0";
                    dtUserProfile.Rows[6].Cells[2].Text = "0";
                    dtUserProfile.Rows[6].Cells[3].Text = "0";
                    dtUserProfile.Rows[6].Cells[4].Text = "0";
                    dtUserProfile.Rows[6].Cells[5].Text = "0";
                    dtUserProfile.Rows[7].Cells[1].Text = "0";
                    dtUserProfile.Rows[7].Cells[2].Text = "0";
                    dtUserProfile.Rows[7].Cells[3].Text = "0";
                    dtUserProfile.Rows[7].Cells[4].Text = "0";
                    dtUserProfile.Rows[7].Cells[5].Text = "0";
                    dtUserProfile.Rows[8].Cells[1].Text = "0";
                    dtUserProfile.Rows[8].Cells[2].Text = "0";
                    dtUserProfile.Rows[8].Cells[3].Text = "0";
                    dtUserProfile.Rows[8].Cells[4].Text = "0";
                    dtUserProfile.Rows[8].Cells[5].Text = "0";

                    dtUserProfile.Rows[9].Cells[1].Text = "0.000";
                    dtUserProfile.Rows[9].Cells[2].Text = "0.000";
                    dtUserProfile.Rows[9].Cells[3].Text = "0.000";
                    dtUserProfile.Rows[9].Cells[4].Text = "0.000";
                    dtUserProfile.Rows[9].Cells[5].Text = "0.000";
                    dtUserProfile.Rows[10].Cells[1].Text = "0.000";
                    dtUserProfile.Rows[10].Cells[2].Text = "0.000";
                    dtUserProfile.Rows[10].Cells[3].Text = "0.000";
                    dtUserProfile.Rows[10].Cells[4].Text = "0.000";
                    dtUserProfile.Rows[10].Cells[5].Text = "0.000";
                                        
                }

            }
            catch (Exception ex)
            {
               
            }


        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        private string RoundOffMTD(string value)
        {
            string rValue = string.Empty;
            if (System.Math.Round(Convert.ToDecimal(value), 0) > 999)
            {
                rValue = System.Math.Round(((Convert.ToDecimal(value) / 1000)), 1) + "K";
            }
            else
            {
                rValue = Convert.ToString(System.Math.Round(Convert.ToDecimal(value), 0));
            }

            return rValue;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="value"></param>
        /// <returns></returns>
        private string RoundOff(string value)
        {
            string rValue = string.Empty;
            if (System.Math.Round(Convert.ToDecimal(value), 0) > 999)
            {
                rValue = System.Math.Truncate((Convert.ToDecimal(value) / 1000)) + "K";
            }
            else
            {
                rValue = Convert.ToString(System.Math.Round(Convert.ToDecimal(value), 0));
            }

            return rValue;
        }
        /// <summary>
        /// 
        /// </summary>
        private void LoadMarketing()
        {
            try
            {
                // Local variable declaration
                string _tableName = "PFC_MarketingTipsMaster";
                string _columnName = "ID,[ShortDescription],Description,TipsHeading,PlayFileName";
                string _whereClause = "1=1 and Status=1 order by ID Desc";

                DataSet dsMargeting = SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));


                // Check whether any value has returned
                if (dsMargeting.Tables[0].Rows.Count > 0)
                {
                    dgMargeting.DataSource = dsMargeting.Tables[0];
                    dgMargeting.DataBind();
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        #endregion

        #region CSR Performance Report

        private void DisplayCSRPerformanceReport()
        {
            string RepDisplayName ="";
			string RepNo ="";			
			string CurDateBegin ="";
			string CurDateEnd ="";
			string MothBegDate ="";
            string MothEndDate = "";

            DataSet dsCSRReport = GetCSTReportData(Session["UserName"].ToString());
            if(dsCSRReport!=null)
            {
                DataTable dtDayCSRData = dsCSRReport.Tables[0];
                DataTable dtAvgCSRData = dsCSRReport.Tables[1];
                DataTable dtMTDCSRData = dsCSRReport.Tables[2];
                DataTable dtFcstCSRData = dsCSRReport.Tables[3];
                DataTable dtGoalCSRData = dsCSRReport.Tables[4];
                DataTable dtDashboardData = dsCSRReport.Tables[5];
                
                #region Global variable for CSR report

                if (dtDashboardData.Rows.Count > 0)
                {
                    RepDisplayName = dtDashboardData.Rows[0]["RepName"].ToString();
                    RepNo = dtDashboardData.Rows[0]["RepNo"].ToString();
                    CurDateBegin = Convert.ToDateTime(dtDashboardData.Rows[0]["CurDateBegin"].ToString()).ToShortDateString();
                    CurDateEnd = Convert.ToDateTime(dtDashboardData.Rows[0]["CurDateEnd"].ToString()).ToShortDateString();
                    MothBegDate = Convert.ToDateTime(dtDashboardData.Rows[0]["MothBegDate"].ToString()).ToShortDateString();
                    MothEndDate = Convert.ToDateTime(dtDashboardData.Rows[0]["MothEndDate"].ToString()).ToShortDateString();                    
                }
                else
                {
                    // if we are not finding data for rep then display the old CSR dashboard 
                    tblCorpSalesReport.Visible = true;
                    tblCSRPerfRptPanel.Visible = false;
                    return;
                }

                lblCSRName.Text = RepDisplayName;

                #endregion

                #region Row: G/M $
                tblCSRPerfRpt.Rows[1].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["GMDolAvg"]);
                tblCSRPerfRpt.Rows[1].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["GMDolFcst"]);
                tblCSRPerfRpt.Rows[1].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", dtGoalCSRData.Rows[0]["GMDolGoal"]);

                // To display Day-Margin Report
                string DayMarginDolRptURL = "../DashboardDrilldown/CSRMarginRpt.aspx?Range=Daily&CSRName=" + Session["UserName"].ToString();
                HyperLink lnkDayMrgDol = new HyperLink();
                lnkDayMrgDol.Target = "new";
                lnkDayMrgDol.Attributes["onclick"] = "return doOpen(this.href, 'GMDol')";
                lnkDayMrgDol.NavigateUrl = DayMarginDolRptURL;
                lnkDayMrgDol.Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["GMDol"]);
                tblCSRPerfRpt.Rows[1].Cells[1].Controls.Add(lnkDayMrgDol);


                // To display MTD-Margin Report
                string MTDMarginDolRptURL = "../DashboardDrilldown/CSRMarginRpt.aspx?Range=MTD&CSRName=" + Session["UserName"].ToString();
                HyperLink lnkMTDMrgDol = new HyperLink();
                lnkMTDMrgDol.Target = "new";
                lnkMTDMrgDol.Attributes["onclick"] = "return doOpen(this.href, 'GMDol')";
                lnkMTDMrgDol.NavigateUrl = MTDMarginDolRptURL;
                lnkMTDMrgDol.Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["GMDolMTD"]);
                tblCSRPerfRpt.Rows[1].Cells[3].Controls.Add(lnkMTDMrgDol);
                #endregion

                #region Row: G/M %
                tblCSRPerfRpt.Rows[2].Cells[1].Text = dtDayCSRData.Rows[0]["GMPct"].ToString();
                tblCSRPerfRpt.Rows[2].Cells[2].Text = dtAvgCSRData.Rows[0]["GMPctAvg"].ToString();
                tblCSRPerfRpt.Rows[2].Cells[3].Text = dtMTDCSRData.Rows[0]["GMPctMTD"].ToString();
                tblCSRPerfRpt.Rows[2].Cells[4].Text = "-";
                tblCSRPerfRpt.Rows[2].Cells[5].Text = dtGoalCSRData.Rows[0]["GMPctGoal"].ToString();

                #endregion
                
                #region Row: Sales $ 

                tblCSRPerfRpt.Rows[3].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["SlsDolAvg"]);                
                tblCSRPerfRpt.Rows[3].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["SlsDolFcst"]);
                tblCSRPerfRpt.Rows[3].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", dtGoalCSRData.Rows[0]["SlsGoal"]);

                // To display Day-Sales Report
                string DaySalesRptURL = "../DashboardDrilldown/CSRSalesRpt.aspx?Range=Daily&CSRName=" + Session["UserName"].ToString();
                HyperLink lnkDaySalesDol = new HyperLink();
                lnkDaySalesDol.Target = "new";
                lnkDaySalesDol.Attributes["onclick"] = "return doOpen(this.href, 'SlsDol')";
                lnkDaySalesDol.NavigateUrl = DaySalesRptURL;
                lnkDaySalesDol.Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["SlsDol"]);
                tblCSRPerfRpt.Rows[3].Cells[1].Controls.Add(lnkDaySalesDol);


                // To display MTD-Sales Report
                string MTDSalesRptURL = "../DashboardDrilldown/CSRSalesRpt.aspx?Range=MTD&CSRName=" + Session["UserName"].ToString();
                HyperLink lnkMTDSalesDol = new HyperLink();
                lnkMTDSalesDol.Target = "new";
                lnkMTDSalesDol.Attributes["onclick"] = "return doOpen(this.href, 'SlsDolMTD')";
                lnkMTDSalesDol.NavigateUrl = MTDSalesRptURL;
                lnkMTDSalesDol.Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["SlsDolMTD"]);
                tblCSRPerfRpt.Rows[3].Cells[3].Controls.Add(lnkMTDSalesDol);

                #endregion

                #region Row: # Orders 
                
                tblCSRPerfRpt.Rows[4].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["OrdAvg"]);
                tblCSRPerfRpt.Rows[4].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["OrdFcst"]);
                tblCSRPerfRpt.Rows[4].Cells[5].Text = "-";

                //Link Right Click Options for Daily Order Count
                HyperLink lnkDayOrd = new HyperLink();
                string urlDayOrdHdrByInvoice = "../DashboardDrilldown/ProgressBar.aspx?destPage=CSRSOHeaderRpt.aspx?Location=00~LocName=Corporate~Customer=******~Invoice=0000000000~Range=Daily~CSRName=" + Session["UserName"].ToString();
                string urlDayOrdHdrByCustomer = "../DashboardDrilldown/ProgressBar.aspx?destPage=CSRSOCustomerRpt.aspx?Location=00~LocName=Corporate~Customer=000000~Invoice=**********~Range=Daily~CSRName=" + Session["UserName"].ToString();
                lnkDayOrd.Text = "<div onmouseover=\"title='Right click for more options'\" style='cursor:hand; text-decoration: underline;' oncontextmenu=\"Javascript:return false;\" id=divCSRCorpOrderRptDaily onmousedown=\"ShowToolTip(event,'" + urlDayOrdHdrByInvoice + "','" + urlDayOrdHdrByCustomer + "',this.id);\">" + String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["Ord"]) + "</div>";
                tblCSRPerfRpt.Rows[4].Cells[1].Controls.Add(lnkDayOrd);
                
                //Link Right Click Options for MTD Order Count
                HyperLink lnkMTDOrd = new HyperLink();
                string urlMTDOrdHdrByInvoice = "../DashboardDrilldown/ProgressBar.aspx?destPage=CSRSOHeaderRpt.aspx?Location=00~LocName=Corporate~Customer=******~Invoice=0000000000~Range=MTD~CSRName=" + Session["UserName"].ToString();
                string urlMTDOrdHdrByCustomer = "../DashboardDrilldown/ProgressBar.aspx?destPage=CSRSOCustomerRpt.aspx?Location=00~LocName=Corporate~Customer=000000~Invoice=**********~Range=MTD~CSRName=" + Session["UserName"].ToString();
                lnkMTDOrd.Text = "<div onmouseover=\"title='Right click for more options'\" style='cursor:hand; text-decoration: underline;' oncontextmenu=\"Javascript:return false;\" id=divCSRCorpOrderRptMTD onmousedown=\"ShowToolTip(event,'" + urlMTDOrdHdrByInvoice + "','" + urlMTDOrdHdrByCustomer + "',this.id);\">" + String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["OrdMTD"]) + "</div>";
                tblCSRPerfRpt.Rows[4].Cells[3].Controls.Add(lnkMTDOrd);                

                #endregion

                #region Row: # Lines

                //tblCSRPerfRpt.Rows[5].Cells[1].Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["Lns"]);
                tblCSRPerfRpt.Rows[5].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["LnsAvg"]);
                //tblCSRPerfRpt.Rows[5].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["LnsMTD"]);
                tblCSRPerfRpt.Rows[5].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["LnsFcst"]);
                tblCSRPerfRpt.Rows[5].Cells[5].Text = "-";

                // To display Day-SOdetail report
                HyperLink lnkDayLns = new HyperLink();
                lnkDayLns.Target = "new";
                lnkDayLns.Attributes["onclick"] = "return doOpen(this.href, 'Detail')";
                lnkDayLns.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=CSRSODetailRpt.aspx?Customer=000000~Invoice=0000000000~Range=Daily~CSRName=" + Session["UserName"].ToString();
                lnkDayLns.Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["Lns"]);
                tblCSRPerfRpt.Rows[5].Cells[1].Controls.Add(lnkDayLns);

                // To display MTD-SOdetail report
                HyperLink lnkMTDLns = new HyperLink();
                lnkMTDLns.Target = "new";
                lnkMTDLns.Attributes["onclick"] = "return doOpen(this.href, 'Detail')";
                lnkMTDLns.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=CSRSODetailRpt.aspx?Customer=000000~Invoice=0000000000~Range=MTD~CSRName=" + Session["UserName"].ToString();
                lnkMTDLns.Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["LnsMTD"]);
                tblCSRPerfRpt.Rows[5].Cells[3].Controls.Add(lnkMTDLns);

                #endregion

                #region Row: # Cust Assigned

                tblCSRPerfRpt.Rows[6].Cells[1].Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["CustCnt"]);
                tblCSRPerfRpt.Rows[6].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["CustCntAvg"]);
                tblCSRPerfRpt.Rows[6].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["CustCntMTD"]);
                //tblCSRPerfRpt.Rows[6].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["CustCntFcst"]);
                tblCSRPerfRpt.Rows[6].Cells[4].Text = "-";
                tblCSRPerfRpt.Rows[6].Cells[5].Text = "-";

                #endregion

                #region Row: # Cust Bought

                tblCSRPerfRpt.Rows[7].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["ActCntAvg"]);                
                //tblCSRPerfRpt.Rows[7].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["ActCntFcst"]);
                tblCSRPerfRpt.Rows[7].Cells[4].Text = "-";
                tblCSRPerfRpt.Rows[7].Cells[5].Text = "-";

                // To display Day-Invoice Analysis Report
                string DaySalesPerfRptURL = "../InvoiceAnalysis/InvoiceAnalysisByCustNo.aspx?" + 
                                            "StartDate=" + CurDateBegin +
                                            "&EndDate=" + CurDateEnd +
                                            "&OrderType=&Branch=&CustNo=&Chain=&WeightFrom=&WeightTo=&ShipToState=&BranchDesc=ALL&OrderTypeDesc=ALL"+ 
                                            "&SalesPerson=" + RepDisplayName + 
                                            "&SalesRepNo=" + RepNo +
                                            "&PriceCd=&OrderSource=&OrderSourceDesc=*All Orders*&ShipMethod=&ShipMethodName=&SubTotal=0" + 
                                            "&SubTotalDesc=&SubTotalFlag=false&TerritoryCd=&TerritoryDesc=ALL&CSRName=ALL&CSRNo=&RegionalMgr=ALL" + 
                                            "&AllCustFlag=false";
                HyperLink lnkDayActCnt = new HyperLink();
                lnkDayActCnt.Target = "new";
                lnkDayActCnt.Attributes["onclick"] = "return doOpen(this.href, 'actcnt')";
                lnkDayActCnt.NavigateUrl = DaySalesPerfRptURL;
                lnkDayActCnt.Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["ActCnt"]);
                tblCSRPerfRpt.Rows[7].Cells[1].Controls.Add(lnkDayActCnt);

                // To display MTD-Invoice Analysis Report
                string MTDSalesPerfRptURL = "../InvoiceAnalysis/InvoiceAnalysisByCustNo.aspx?" +
                                            "StartDate=" + MothBegDate +
                                            "&EndDate=" + MothEndDate +
                                            "&OrderType=&Branch=&CustNo=&Chain=&WeightFrom=&WeightTo=&ShipToState=&BranchDesc=ALL&OrderTypeDesc=ALL"+ 
                                            "&SalesPerson=" + RepDisplayName + 
                                            "&SalesRepNo=" + RepNo +
                                            "&PriceCd=&OrderSource=&OrderSourceDesc=*All Orders*&ShipMethod=&ShipMethodName=&SubTotal=0" + 
                                            "&SubTotalDesc=&SubTotalFlag=false&TerritoryCd=&TerritoryDesc=ALL&CSRName=ALL&CSRNo=&RegionalMgr=ALL" + 
                                            "&AllCustFlag=false";
                HyperLink lnkMTDActCnt = new HyperLink();
                lnkMTDActCnt.Target = "new";
                lnkMTDActCnt.Attributes["onclick"] = "return doOpen(this.href, 'actcnt')";
                lnkMTDActCnt.NavigateUrl = MTDSalesPerfRptURL;
                lnkMTDActCnt.Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["ActCntMTD"]);
                tblCSRPerfRpt.Rows[7].Cells[3].Controls.Add(lnkMTDActCnt);

                #endregion

                #region Row: eCom Sales $

                tblCSRPerfRpt.Rows[8].Cells[1].Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["eComOrdDol"]);
                tblCSRPerfRpt.Rows[8].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["eComOrdDolAvg"]);
                tblCSRPerfRpt.Rows[8].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["eComOrdDolMTD"]);
                tblCSRPerfRpt.Rows[8].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["eComOrdDolFcst"]);
                tblCSRPerfRpt.Rows[8].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", dtGoalCSRData.Rows[0]["eComSlsGoal"]);

                #endregion

                #region Row: eCom GM %

                tblCSRPerfRpt.Rows[9].Cells[1].Text = dtDayCSRData.Rows[0]["eComGMPct"].ToString();
                tblCSRPerfRpt.Rows[9].Cells[2].Text = dtAvgCSRData.Rows[0]["eComGMPctAvg"].ToString();
                tblCSRPerfRpt.Rows[9].Cells[3].Text = dtMTDCSRData.Rows[0]["eComGMPctMTD"].ToString();
                tblCSRPerfRpt.Rows[9].Cells[4].Text = "-";
                tblCSRPerfRpt.Rows[9].Cells[5].Text = dtGoalCSRData.Rows[0]["eComGMPctGoal"].ToString();

                #endregion

                #region Row: eCom Q Orders

                tblCSRPerfRpt.Rows[10].Cells[1].Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["eComOrd"]);
                tblCSRPerfRpt.Rows[10].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["eComOrdAvg"]);
                tblCSRPerfRpt.Rows[10].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["eComOrdMTD"]);
                tblCSRPerfRpt.Rows[10].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["eComOrdFcst"]);
                tblCSRPerfRpt.Rows[10].Cells[5].Text = "-";

                #endregion

                #region Row: eCom Q Lines

                //tblCSRPerfRpt.Rows[11].Cells[1].Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["eComLns"]);
                tblCSRPerfRpt.Rows[11].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["eComLnsAvg"]);
                //tblCSRPerfRpt.Rows[11].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["eComLnsMTD"]);
                tblCSRPerfRpt.Rows[11].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["eComLnsFcst"]);
                tblCSRPerfRpt.Rows[11].Cells[5].Text = "-";
                
                // To display Day-eCommerce report
                string DayeCommRptURL = "../eCommerceReport/eCommerceQuote2OrderAnalysis.aspx?Month=&Year=&Branch=&CustNo=" + 
                                            "&StartDate="+ CurDateBegin +
                                            "&EndDate=" + CurDateEnd +
                                            "&MonthName=&BranchName=ALL" +
                                            "&RepNo=" + RepNo +
                                            "&RepName=" + RepDisplayName;
                   
                HyperLink lnkDayeComm = new HyperLink();
                lnkDayeComm.Target = "new";
                lnkDayeComm.Attributes["onclick"] = "return doOpen(this.href, 'eComm')";
                lnkDayeComm.NavigateUrl = DayeCommRptURL;
                lnkDayeComm.Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["eComLns"]);
                tblCSRPerfRpt.Rows[11].Cells[1].Controls.Add(lnkDayeComm);

                // To display MTD-eCommerce report
                string MTDeCommRptURL = "../eCommerceReport/eCommerceQuote2OrderAnalysis.aspx?Month=&Year=&Branch=&CustNo=" +
                                            "&StartDate=" + MothBegDate +
                                            "&EndDate=" + MothEndDate +
                                            "&MonthName=&BranchName=ALL" +
                                            "&RepNo=" + RepNo +
                                            "&RepName=" + RepDisplayName;

                HyperLink lnkMTDeComm = new HyperLink();
                lnkMTDeComm.Target = "new";
                lnkMTDeComm.Attributes["onclick"] = "return doOpen(this.href, 'eComm')";
                lnkMTDeComm.NavigateUrl = MTDeCommRptURL;
                lnkMTDeComm.Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["eComLnsMTD"]);
                tblCSRPerfRpt.Rows[11].Cells[3].Controls.Add(lnkMTDeComm);

                #endregion

                #region Row: CSR Q Orders

                tblCSRPerfRpt.Rows[12].Cells[1].Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["CSROrd"]);
                tblCSRPerfRpt.Rows[12].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["CSROrdAvg"]);
                tblCSRPerfRpt.Rows[12].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["CSROrdMTD"]);
                tblCSRPerfRpt.Rows[12].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["CSROrdFcst"]);
                tblCSRPerfRpt.Rows[12].Cells[5].Text = "-";

                #endregion

                #region Row: CSR Q Lines

                
                tblCSRPerfRpt.Rows[13].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["CSRLnsAvg"]);
                //tblCSRPerfRpt.Rows[13].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["CSRLnsMTD"]);
                tblCSRPerfRpt.Rows[13].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["CSRLnsFcst"]);
                tblCSRPerfRpt.Rows[13].Cells[5].Text = "-";

                // To display Day-Quote metrics report
                string DayQuoteRptURL = "../QuoteMetrics/CSRQuoteMetricsReport.aspx?" + 
                                        "StartDate=" + CurDateBegin + 
                                        "&EndDate=" + CurDateEnd +
                                        "&Branch=" +
                                        "&BranchName=ALL" + 
                                        "&SalesPerson=" + Session["UserName"].ToString();                                        

                HyperLink lnkDayCSRLns = new HyperLink();
                lnkDayCSRLns.Target = "new";
                lnkDayCSRLns.Attributes["onclick"] = "return doOpen(this.href, 'eComm')";
                lnkDayCSRLns.NavigateUrl = DayQuoteRptURL;
                lnkDayCSRLns.Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["CSRLns"]);
                tblCSRPerfRpt.Rows[13].Cells[1].Controls.Add(lnkDayCSRLns);

                // To display MTD-Quote metrics report
                string MTDQuoteRptURL = "../QuoteMetrics/CSRQuoteMetricsReport.aspx?" +
                                        "StartDate=" + MothBegDate +
                                        "&EndDate=" + MothEndDate +
                                        "&Branch=" +
                                        "&BranchName=ALL" +
                                        "&SalesPerson=" + Session["UserName"].ToString();

                HyperLink lnkMTDCSRLns = new HyperLink();
                lnkMTDCSRLns.Target = "new";
                lnkMTDCSRLns.Attributes["onclick"] = "return doOpen(this.href, 'eComm')";
                lnkMTDCSRLns.NavigateUrl = MTDQuoteRptURL;
                lnkMTDCSRLns.Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["CSRLnsMTD"]);
                tblCSRPerfRpt.Rows[13].Cells[3].Controls.Add(lnkMTDCSRLns);
                #endregion

                #region Row: Lbs Ship

                tblCSRPerfRpt.Rows[14].Cells[1].Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["Lbs"]);
                tblCSRPerfRpt.Rows[14].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["LbsAvg"]);
                tblCSRPerfRpt.Rows[14].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["LbsMTD"]);
                tblCSRPerfRpt.Rows[14].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["LbsFcst"]);
                tblCSRPerfRpt.Rows[14].Cells[5].Text = "-";

                #endregion

                #region Row: Price Lbs

                tblCSRPerfRpt.Rows[15].Cells[1].Text = dtDayCSRData.Rows[0]["PriceLb"].ToString();
                tblCSRPerfRpt.Rows[15].Cells[2].Text = dtAvgCSRData.Rows[0]["PriceLbAvg"].ToString();
                tblCSRPerfRpt.Rows[15].Cells[3].Text = dtMTDCSRData.Rows[0]["PriceLbMTD"].ToString();
                tblCSRPerfRpt.Rows[15].Cells[4].Text = "-";
                tblCSRPerfRpt.Rows[15].Cells[5].Text = dtGoalCSRData.Rows[0]["PriceLbGoal"].ToString();

                #endregion

                #region Row: GM $ Lbs

                tblCSRPerfRpt.Rows[16].Cells[1].Text = dtDayCSRData.Rows[0]["GMLb"].ToString();
                tblCSRPerfRpt.Rows[16].Cells[2].Text = dtAvgCSRData.Rows[0]["GMLbAvg"].ToString();
                tblCSRPerfRpt.Rows[16].Cells[3].Text = dtMTDCSRData.Rows[0]["GMLbMTD"].ToString();
                tblCSRPerfRpt.Rows[16].Cells[4].Text = "-";
                tblCSRPerfRpt.Rows[16].Cells[5].Text = dtGoalCSRData.Rows[0]["GMLbGoal"].ToString();

                #endregion
            }
            
        }

        private DataSet GetCSTReportData(string csrName)
        {
            try
            {
                //DataSet dsCSRReport = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pDashboardCSRPerformance]",
                //                                new SqlParameter("@userId", csrName));

                DataSet dsCSRReport = SqlHelper.ExecuteDataset(System.Configuration.ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString(), "[pDashboardCSRPerformance]",
                                                new SqlParameter("@userId", csrName));

                if (dsCSRReport != null && dsCSRReport.Tables.Count == 6)
                {
                    return dsCSRReport;
                }

                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        #endregion

        #region Event Handler
        /// <summary>
        /// dgShortCuts_ItemDataBound:Datagrid item data bound event handler
        /// </summary>
        /// <param name="sender">Object:Datagrid dgShortCuts</param>
        /// <param name="e">DataGridItemEventArgs</param>
        protected void dgShortCuts_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.DataItem != null)
                e.Item.ToolTip = DataBinder.Eval(e.Item.DataItem, "Description").ToString();
            //if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.Header || e.Item.ItemType == ListItemType.AlternatingItem)
            //{
            //    HyperLink lnk = e.Item.FindControl("HyperLink1") as HyperLink;

            //    if (e.Item.Cells[1].Text.ToLower() == "false")
            //    {
            //        lnk.NavigateUrl = "#";
            //        lnk.Attributes.Add("onclick", "OpenWin('" + e.Item.Cells[2].Text + "');");
            //    }
            //}

        }
        /// <summary>
        /// dgDolist_ItemDataBound:Datagrid item data bound event handler
        /// </summary>
        /// <param name="sender">object sender</param>
        /// <param name="e">DataGridItemEventArgs</param>
        protected void dgDolist_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.DataItem != null)
            {
                HyperLink hplButton = e.Item.Cells[0].Controls[1] as HyperLink;
                hplButton.Text = e.Item.Cells[0].Text;
                hplButton.ToolTip = DataBinder.Eval(e.Item.DataItem, "Description").ToString();
                hplButton.Text = DataBinder.Eval(e.Item.DataItem, "Content").ToString();
                hplButton.Attributes.Add("onclick", "window.open(this.href, 'Description', 'height=220,width=515,scrollbars=no,status=no,top='+((screen.height/2) - (480/2))+',left='+((screen.width/2) - (500/2))+',resizable=YES'); return false;");
            }

        }
        /// <summary>
        /// ddlBranch_SelectedIndexChanged:Selected index change event handler
        /// </summary>
        /// <param name="sender">object sender</param>
        /// <param name="e">EventArgs</param>
        protected void ddlBranch_SelectedIndexChanged(object sender, EventArgs e)
        {
           // DisplayBranch();
        }
        /// <summary>
        /// 
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgMargeting_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.DataItem != null)
            {
                HyperLink hplButton = e.Item.Cells[0].Controls[1] as HyperLink;
                hplButton.Text = e.Item.Cells[0].Text;
                hplButton.ToolTip = DataBinder.Eval(e.Item.DataItem, "ShortDescription").ToString();
                hplButton.Text = DataBinder.Eval(e.Item.DataItem, "ShortDescription").ToString();
                hplButton.Target = "_blank";
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgAnnouncement_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.DataItem != null)
            {
                HyperLink hplButton = e.Item.Cells[0].Controls[1] as HyperLink;
                hplButton.Text = e.Item.Cells[0].Text;
                hplButton.ToolTip = DataBinder.Eval(e.Item.DataItem, "ShortDescription").ToString();
                hplButton.Text = DataBinder.Eval(e.Item.DataItem, "AnnouncementHeading").ToString();
                hplButton.Target = "_blank";
            }
        }

       #endregion


    }//End Class 

}//End NameSpace