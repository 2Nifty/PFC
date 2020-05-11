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

public partial class SystemFrameSet_CSRReportByCustPreview : System.Web.UI.Page
{
    private string curMonth = string.Empty;
    private string curYear = string.Empty;
    private string _whereCon = string.Empty;
    private string strBRNID = string.Empty;
    private const string SP_GENERALSELECT = "UGEN_SP_Select";
    private string reportsConnectionString = Global.ReportsConnectionString;
    
    SalesReportUtils salesReportUtils = new SalesReportUtils();
    CSRReports csrReport = new CSRReports();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        
        if (!Page.IsPostBack)
        {
            if (Request.QueryString["BranchID"] != null)
            {
                strBRNID = Request.QueryString["BranchID"].ToString();

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
            Label lblBrID = e.Item.FindControl("lblBrID") as Label;
            Table tblBrPerformance = e.Item.FindControl("tblCSRPerfRpt") as Table;
            LoadCSRPerformance(lblBrID.Text, tblBrPerformance);
            if (e.Item.ItemIndex > 0 && (e.Item.ItemIndex + 1) % 6 == 0)
            {
                HtmlContainerControl tblHeader = e.Item.FindControl("divHeader") as HtmlContainerControl;
                tblHeader.Style.Add("page-break-after", "always");
            }
        }
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
            tblCSRPerfRpt.Rows[1].Cells[1].Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["GMDol"]);
            tblCSRPerfRpt.Rows[1].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["GMDolAvg"]);
            tblCSRPerfRpt.Rows[1].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["GMDolMTD"]);
            tblCSRPerfRpt.Rows[1].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["GMDolFcst"]);
            tblCSRPerfRpt.Rows[1].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", dtGoalCSRData.Rows[0]["GMDolGoal"]);
            #endregion

            #region Row: G/M %
            tblCSRPerfRpt.Rows[2].Cells[1].Text = dtDayCSRData.Rows[0]["GMPct"].ToString();
            tblCSRPerfRpt.Rows[2].Cells[2].Text = dtAvgCSRData.Rows[0]["GMPctAvg"].ToString();
            tblCSRPerfRpt.Rows[2].Cells[3].Text = dtMTDCSRData.Rows[0]["GMPctMTD"].ToString();
            tblCSRPerfRpt.Rows[2].Cells[4].Text = "-";
            tblCSRPerfRpt.Rows[2].Cells[5].Text = dtGoalCSRData.Rows[0]["GMPctGoal"].ToString();

            #endregion

            #region Row: Sales $
            tblCSRPerfRpt.Rows[3].Cells[1].Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["SlsDol"]);
            tblCSRPerfRpt.Rows[3].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["SlsDolAvg"]);
            tblCSRPerfRpt.Rows[3].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["SlsDolMTD"]);
            tblCSRPerfRpt.Rows[3].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["SlsDolFcst"]);
            tblCSRPerfRpt.Rows[3].Cells[5].Text = String.Format("{0:#,###;(#,###);0}", dtGoalCSRData.Rows[0]["SlsGoal"]);
            #endregion

            #region Row: # Orders
            tblCSRPerfRpt.Rows[4].Cells[1].Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["Ord"]);
            tblCSRPerfRpt.Rows[4].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["OrdAvg"]);
            tblCSRPerfRpt.Rows[4].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["OrdMTD"]);
            tblCSRPerfRpt.Rows[4].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["OrdFcst"]);
            tblCSRPerfRpt.Rows[4].Cells[5].Text = "-";
            #endregion

            #region Row: # Lines

            tblCSRPerfRpt.Rows[5].Cells[1].Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["Lns"]);
            tblCSRPerfRpt.Rows[5].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["LnsAvg"]);
            tblCSRPerfRpt.Rows[5].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["LnsMTD"]);
            tblCSRPerfRpt.Rows[5].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["LnsFcst"]);
            tblCSRPerfRpt.Rows[5].Cells[5].Text = "-";

            #endregion

            #region Row: # Cust Assigned

            tblCSRPerfRpt.Rows[6].Cells[1].Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["CustCnt"]);
            tblCSRPerfRpt.Rows[6].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["CustCntAvg"]);
            tblCSRPerfRpt.Rows[6].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["CustCntMTD"]);
            tblCSRPerfRpt.Rows[6].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["CustCntFcst"]);
            tblCSRPerfRpt.Rows[6].Cells[5].Text = "-";

            #endregion

            #region Row: # Cust Bought
            tblCSRPerfRpt.Rows[7].Cells[1].Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["ActCnt"]);
            tblCSRPerfRpt.Rows[7].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["ActCntAvg"]);
            tblCSRPerfRpt.Rows[7].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["ActCntMTD"]);
            tblCSRPerfRpt.Rows[7].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["ActCntFcst"]);
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

            tblCSRPerfRpt.Rows[11].Cells[1].Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["eComLns"]);
            tblCSRPerfRpt.Rows[11].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["eComLnsAvg"]);
            tblCSRPerfRpt.Rows[11].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["eComLnsMTD"]);
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
            tblCSRPerfRpt.Rows[13].Cells[1].Text = String.Format("{0:#,###;(#,###);0}", dtDayCSRData.Rows[0]["CSRLns"]);
            tblCSRPerfRpt.Rows[13].Cells[2].Text = String.Format("{0:#,###;(#,###);0}", dtAvgCSRData.Rows[0]["CSRLnsAvg"]);
            tblCSRPerfRpt.Rows[13].Cells[3].Text = String.Format("{0:#,###;(#,###);0}", dtMTDCSRData.Rows[0]["CSRLnsMTD"]);
            tblCSRPerfRpt.Rows[13].Cells[4].Text = String.Format("{0:#,###;(#,###);0}", dtFcstCSRData.Rows[0]["CSRLnsFcst"]);
            tblCSRPerfRpt.Rows[13].Cells[5].Text = "-";
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
            DataSet dsCSRReport = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pDashboardCSRPerformance]",
                                            new SqlParameter("@userId", csrName));

            //DataSet dsCSRReport = SqlHelper.ExecuteDataset(System.Configuration.ConfigurationManager.AppSettings["LivePFCERPConnectionString"].ToString(), "[pDashboardCSRPerformance]",
            //                                new SqlParameter("@userId", csrName));

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

}
