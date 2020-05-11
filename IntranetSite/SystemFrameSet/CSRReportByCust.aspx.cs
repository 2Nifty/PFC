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

public partial class SystemFrameSet_CSRReportByCust : System.Web.UI.Page
{
    private string curMonth = string.Empty;
    private string curYear = string.Empty;
    private string _whereCon = string.Empty;
    private string strBRNID = string.Empty;
    private const string SP_GENERALSELECT = "UGEN_SP_Select";
    
    SalesReportUtils salesReportUtils = new SalesReportUtils();
    CSRReports csrReport = new CSRReports();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        Response.Expires = -1;

        if (!Page.IsPostBack)
        {
            if (Request.QueryString["BranchID"] != null)
            {
                strBRNID = Request.QueryString["BranchID"].ToString();
                
                GetALLBranches();

                DataTable dtRepNames = csrReport.GetSalesRepNames(Request.QueryString["BranchID"].ToString());
                if (dtRepNames.Rows.Count <= 0)
                    lblNorecords.Visible = true;
                else
                    lblNorecords.Visible = false;
                
                dlRegion.DataSource = dtRepNames;
                dlRegion.DataBind();
            }
        }
    }
    
    protected void dlRegion_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Label lblBrID = e.Item.Controls[1] as Label;
            Table tblBrPerformance = e.Item.Controls[3] as Table;
            LoadCSRPerformance(lblBrID.Text,  tblBrPerformance);
        }
    }

    public void GetALLBranches()
    {
        try
        {
            salesReportUtils.GetAuthorizedBranches(ddlBranch, Session["UserID"].ToString());
            ddlBranch.SelectedValue = Request.QueryString["BranchID"].ToString();           
        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
    }

    protected void ddlBranch_SelectedIndexChanged(object sender, EventArgs e)
    {
        DataTable dtRepNames = csrReport.GetSalesRepNames(ddlBranch.SelectedValue.ToString());
        strBRNID = ddlBranch.SelectedValue.ToString();
        if (dtRepNames.Rows.Count <= 0)
            lblNorecords.Visible = true;
        else
            lblNorecords.Visible = false;

        dlRegion.DataSource = dtRepNames;
        dlRegion.DataBind();

        UpdatePanel1.Update();
    }

    /// <summary>
    /// ibtnPrint_Click : Method used to print  report
    /// </summary>
    /// <param name="sender">object</param>
    /// <param name="e">ImageClickEventArgs</param>
    protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
    {
        string strURL = "BranchID=" + ddlBranch.SelectedValue + "&BranchName=" + ddlBranch.SelectedItem.Text ;
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "PrintReport('" + strURL + "');", true);
    }

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

    private void LoadCSRPerformance(string CSRID, Table tblCSRPerfRpt)
    {
        string RepDisplayName = "";
        string RepNo = "";
        string CurDateBegin = "";
        string CurDateEnd = "";
        string MothBegDate = "";
        string MothEndDate = "";

        DataSet dsCSRReport = GetCSTReportData(CSRID);
        if (dsCSRReport != null)
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
                return;
            #endregion
            
            #region Row: G/M $
            tblCSRPerfRpt.Rows[1].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["GMDolAvg"]);
            tblCSRPerfRpt.Rows[1].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["GMDolFcst"]);
            tblCSRPerfRpt.Rows[1].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", dtGoalCSRData.Rows[0]["GMDolGoal"]);

            // To display Day-Margin Report
            string DayMarginDolRptURL = "../DashboardDrilldown/CSRMarginRpt.aspx?Range=Daily&CSRName=" + CSRID;
            HyperLink lnkDayMrgDol = new HyperLink();
            lnkDayMrgDol.Target = "new";
            lnkDayMrgDol.Attributes["onclick"] = "return doOpen(this.href, 'GMDol')";
            lnkDayMrgDol.NavigateUrl = DayMarginDolRptURL;
            lnkDayMrgDol.Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["GMDol"]);
            tblCSRPerfRpt.Rows[1].Cells[1].Controls.Add(lnkDayMrgDol);

            // To display MTD-Margin Report
            string MTDMarginDolRptURL = "../DashboardDrilldown/CSRMarginRpt.aspx?Range=MTD&CSRName=" + CSRID;
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
            string DaySalesRptURL = "../DashboardDrilldown/CSRSalesRpt.aspx?Range=Daily&CSRName=" + CSRID;
            HyperLink lnkDaySalesDol = new HyperLink();
            lnkDaySalesDol.Target = "new";
            lnkDaySalesDol.Attributes["onclick"] = "return doOpen(this.href, 'SlsDol')";
            lnkDaySalesDol.NavigateUrl = DaySalesRptURL;
            lnkDaySalesDol.Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["SlsDol"]);
            tblCSRPerfRpt.Rows[3].Cells[1].Controls.Add(lnkDaySalesDol);

            // To display MTD-Sales Report
            string MTDSalesRptURL = "../DashboardDrilldown/CSRSalesRpt.aspx?Range=MTD&CSRName=" + CSRID;
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
            string urlDayOrdHdrByInvoice = "../DashboardDrilldown/ProgressBar.aspx?destPage=CSRSOHeaderRpt.aspx?Location=00~LocName=Corporate~Customer=******~Invoice=0000000000~Range=Daily~CSRName=" + CSRID;
            string urlDayOrdHdrByCustomer = "../DashboardDrilldown/ProgressBar.aspx?destPage=CSRSOCustomerRpt.aspx?Location=00~LocName=Corporate~Customer=000000~Invoice=**********~Range=Daily~CSRName=" + CSRID;
            lnkDayOrd.Text = "<div onmouseover=\"title='Right click for more options'\" style='cursor:hand; text-decoration: underline;' oncontextmenu=\"Javascript:return false;\" id=divCSRCorpOrderRptDaily onmousedown=\"ShowToolTip(event,'" + urlDayOrdHdrByInvoice + "','" + urlDayOrdHdrByCustomer + "',this.id);\">" + String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["Ord"]) + "</div>";
            tblCSRPerfRpt.Rows[4].Cells[1].Controls.Add(lnkDayOrd);

            //Link Right Click Options for MTD Order Count
            HyperLink lnkMTDOrd = new HyperLink();
            string urlMTDOrdHdrByInvoice = "../DashboardDrilldown/ProgressBar.aspx?destPage=CSRSOHeaderRpt.aspx?Location=00~LocName=Corporate~Customer=******~Invoice=0000000000~Range=MTD~CSRName=" + CSRID;
            string urlMTDOrdHdrByCustomer = "../DashboardDrilldown/ProgressBar.aspx?destPage=CSRSOCustomerRpt.aspx?Location=00~LocName=Corporate~Customer=000000~Invoice=**********~Range=MTD~CSRName=" + CSRID;
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
            lnkDayLns.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=CSRSODetailRpt.aspx?Customer=000000~Invoice=0000000000~Range=Daily~CSRName=" + CSRID;
            lnkDayLns.Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["Lns"]);
            tblCSRPerfRpt.Rows[5].Cells[1].Controls.Add(lnkDayLns);

            // To display MTD-SOdetail report
            HyperLink lnkMTDLns = new HyperLink();
            lnkMTDLns.Target = "new";
            lnkMTDLns.Attributes["onclick"] = "return doOpen(this.href, 'Detail')";
            lnkMTDLns.NavigateUrl = "../DashboardDrilldown/ProgressBar.aspx?destPage=CSRSODetailRpt.aspx?Customer=000000~Invoice=0000000000~Range=MTD~CSRName=" + CSRID;
            lnkMTDLns.Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["LnsMTD"]);
            tblCSRPerfRpt.Rows[5].Cells[3].Controls.Add(lnkMTDLns);
            #endregion

            #region Row: # Cust Assigned
            //tblCSRPerfRpt.Rows[6].Cells[1].Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["CustCnt"]);
            // To display Day-Invoice Analysis Report
            string DaySalesPerfRptURL = "../InvoiceAnalysis/InvoiceAnalysisByCustNo.aspx?" +
                                        "StartDate=" + CurDateBegin +
                                        "&EndDate=" + CurDateEnd +
                                        "&OrderType=&Branch=&CustNo=&Chain=&WeightFrom=&WeightTo=&ShipToState=&BranchDesc=ALL&OrderTypeDesc=ALL" +
                                        "&SalesPerson=" + RepDisplayName +
                                        "&SalesRepNo=" + RepNo +
                                        "&PriceCd=&OrderSource=&OrderSourceDesc=*All Orders*&ShipMethod=&ShipMethodName=&SubTotal=0" +
                                        "&SubTotalDesc=&SubTotalFlag=false&TerritoryCd=&TerritoryDesc=ALL&CSRName=ALL&CSRNo=&RegionalMgr=ALL" +
                                        "&AllCustFlag=true";
            HyperLink lnkDayActCnt = new HyperLink();
            lnkDayActCnt.Target = "new";
            lnkDayActCnt.Attributes["onclick"] = "return doOpen(this.href, 'actcnt')";
            lnkDayActCnt.NavigateUrl = DaySalesPerfRptURL;
            lnkDayActCnt.Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["CustCnt"]);
            tblCSRPerfRpt.Rows[6].Cells[1].Controls.Add(lnkDayActCnt);
            
            tblCSRPerfRpt.Rows[6].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["CustCntAvg"]);

            //tblCSRPerfRpt.Rows[6].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["CustCntMTD"]);
            // To display MTD-Invoice Analysis Report
            string MTDSalesPerfRptURL = "../InvoiceAnalysis/InvoiceAnalysisByCustNo.aspx?" +
                                        "StartDate=" + MothBegDate +
                                        "&EndDate=" + MothEndDate +
                                        "&OrderType=&Branch=&CustNo=&Chain=&WeightFrom=&WeightTo=&ShipToState=&BranchDesc=ALL&OrderTypeDesc=ALL" +
                                        "&SalesPerson=" + RepDisplayName +
                                        "&SalesRepNo=" + RepNo +
                                        "&PriceCd=&OrderSource=&OrderSourceDesc=*All Orders*&ShipMethod=&ShipMethodName=&SubTotal=0" +
                                        "&SubTotalDesc=&SubTotalFlag=false&TerritoryCd=&TerritoryDesc=ALL&CSRName=ALL&CSRNo=&RegionalMgr=ALL" +
                                        "&AllCustFlag=true";
            HyperLink lnkMTDActCnt = new HyperLink();
            lnkMTDActCnt.Target = "new";
            lnkMTDActCnt.Attributes["onclick"] = "return doOpen(this.href, 'actcnt')";
            lnkMTDActCnt.NavigateUrl = MTDSalesPerfRptURL;
            lnkMTDActCnt.Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["CustCntMTD"]);
            tblCSRPerfRpt.Rows[6].Cells[3].Controls.Add(lnkMTDActCnt);
            
            //tblCSRPerfRpt.Rows[6].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["CustCntFcst"]);
            tblCSRPerfRpt.Rows[6].Cells[4].Text = "-";
            tblCSRPerfRpt.Rows[6].Cells[5].Text = "-";
            #endregion

            #region Row: # Cust Bought
            // To display Day-Invoice Analysis Report
            DaySalesPerfRptURL = "../InvoiceAnalysis/InvoiceAnalysisByCustNo.aspx?" +
                                        "StartDate=" + CurDateBegin +
                                        "&EndDate=" + CurDateEnd +
                                        "&OrderType=&Branch=&CustNo=&Chain=&WeightFrom=&WeightTo=&ShipToState=&BranchDesc=ALL&OrderTypeDesc=ALL" +
                                        "&SalesPerson=" + RepDisplayName +
                                        "&SalesRepNo=" + RepNo +
                                        "&PriceCd=&OrderSource=&OrderSourceDesc=*All Orders*&ShipMethod=&ShipMethodName=&SubTotal=0" +
                                        "&SubTotalDesc=&SubTotalFlag=false&TerritoryCd=&TerritoryDesc=ALL&CSRName=ALL&CSRNo=&RegionalMgr=ALL" +
                                        "&AllCustFlag=false";
            lnkDayActCnt = new HyperLink();
            lnkDayActCnt.Target = "new";
            lnkDayActCnt.Attributes["onclick"] = "return doOpen(this.href, 'actcnt')";
            lnkDayActCnt.NavigateUrl = DaySalesPerfRptURL;
            lnkDayActCnt.Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["ActCnt"]);
            tblCSRPerfRpt.Rows[7].Cells[1].Controls.Add(lnkDayActCnt);

            tblCSRPerfRpt.Rows[7].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["ActCntAvg"]);

            // To display MTD-Invoice Analysis Report
            MTDSalesPerfRptURL = "../InvoiceAnalysis/InvoiceAnalysisByCustNo.aspx?" +
                                        "StartDate=" + MothBegDate +
                                        "&EndDate=" + MothEndDate +
                                        "&OrderType=&Branch=&CustNo=&Chain=&WeightFrom=&WeightTo=&ShipToState=&BranchDesc=ALL&OrderTypeDesc=ALL" +
                                        "&SalesPerson=" + RepDisplayName +
                                        "&SalesRepNo=" + RepNo +
                                        "&PriceCd=&OrderSource=&OrderSourceDesc=*All Orders*&ShipMethod=&ShipMethodName=&SubTotal=0" +
                                        "&SubTotalDesc=&SubTotalFlag=false&TerritoryCd=&TerritoryDesc=ALL&CSRName=ALL&CSRNo=&RegionalMgr=ALL" +
                                        "&AllCustFlag=false";
            lnkMTDActCnt = new HyperLink();
            lnkMTDActCnt.Target = "new";
            lnkMTDActCnt.Attributes["onclick"] = "return doOpen(this.href, 'actcnt')";
            lnkMTDActCnt.NavigateUrl = MTDSalesPerfRptURL;
            lnkMTDActCnt.Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["ActCntMTD"]);
            tblCSRPerfRpt.Rows[7].Cells[3].Controls.Add(lnkMTDActCnt);

            //tblCSRPerfRpt.Rows[7].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["ActCntFcst"]);
            tblCSRPerfRpt.Rows[7].Cells[4].Text = "-";
            tblCSRPerfRpt.Rows[7].Cells[5].Text = "-";
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
            // To display Day-eCommerce report
            string DayeCommRptURL = "../eCommerceReport/eCommerceQuote2OrderAnalysis.aspx?Month=&Year=&Branch=&CustNo=" +
                                        "&StartDate=" + CurDateBegin +
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
            
            tblCSRPerfRpt.Rows[11].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["eComLnsAvg"]);
            //tblCSRPerfRpt.Rows[11].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["eComLnsMTD"]);
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
            
            tblCSRPerfRpt.Rows[11].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["eComLnsFcst"]);
            tblCSRPerfRpt.Rows[11].Cells[5].Text = "-";
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
                                    "&SalesPerson=" + CSRID;
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
                                    "&SalesPerson=" + CSRID;
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

    protected void ibtnClose_Click(object sender, ImageClickEventArgs e)
    {
        ScriptManager.RegisterClientScriptBlock(ibtnClose, ibtnClose.GetType(), "CloseForm", "this.window.close();", true);
    }
}
