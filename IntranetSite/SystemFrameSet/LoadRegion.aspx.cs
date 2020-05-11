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

public partial class SystemFrameSet_LoadRegion : System.Web.UI.Page
{
    private string curMonth = string.Empty;
    private string curYear = string.Empty;
    private string _whereCon = string.Empty;
    private const string SP_GENERALSELECT = "UGEN_SP_Select";
    UserValidation objUser = new UserValidation();
    FiscalCalendar fiscalCalendar;
    private int brnCount = 0;
    string erpConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        GetCurDateTime();

        if (!Page.IsPostBack)
        {
            if (Request.QueryString["RegionID"] != null)
            {
                if (Request.QueryString["RegionID"] == "ALL")
                    _whereCon = "(ISNULL(RTRIM(LTRIM(LocSalesGrp)), '') <> '')  AND LocType in ('B','S') ORDER BY LOCID";
                else
                    _whereCon = "[LocSalesGrp] = '" + Request.QueryString["RegionID"].ToString() + "'  AND LocType in ('B','S') ORDER BY LOCID";

                GetALLRegions();

                DataSet dsRegion = SqlHelper.ExecuteDataset(erpConnectionString, SP_GENERALSELECT,
                           new SqlParameter("@tableName", "LocMaster"),
                           new SqlParameter("@columnNames", "LOCID,LOCNAME"),
                           new SqlParameter("@whereCondition", _whereCon));

                dlRegion.DataSource = FilterAuthorizedBranch(dsRegion);
                dlRegion.DataBind();
                if (dlRegion.Items.Count <= 0)
                {
                    lblStatus.Text = "No Records Found";
                    lblStatus.Visible = true;
                }
            }
        }
    }

    /// <summary>
    /// ibtnPrint_Click : Method used to print  report
    /// </summary>
    /// <param name="sender">object</param>
    /// <param name="e">ImageClickEventArgs</param>
    protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
    {
        string strURL = "RegionID=" + ddlRegion.SelectedValue + "&RegionName=" + ddlRegion.SelectedItem.Text;

        ScriptManager.RegisterClientScriptBlock(ibtnPrint, typeof(ImageButton), "Print", "PrintReport('" + strURL + "');", true);
    }

    private void DisplayBranch(string BrnID, Table tblBrID)
    {
        try
        {
            string _tableName = "Dashboard_Branch";

            string _columnName = "TD_GrossmarginDollar,MTD_GrossmarginDollar,AVG_GrossmarginDollar,BUD_GrossmarginDollar,TD_GrossmarginPct,MTD_GrossmarginPct,AVG_Grossmarginpct,BUD_Grossmarginpct,TD_SalesDollar,MTD_SalesDollar,AVG_SalesDollar,BUD_SalesDollar," +
                                 "TD_OrderCount,MTD_OrderCount,AVG_OrderCount,BUD_OrderCount,TD_LineCount,MTD_LineCount,AVG_LineCount,BUD_LineCount,TD_LbsShipped,MTD_LbsShipped,AVG_LbsShipped,BUD_LbsShipped,TD_PriceperLB,MTD_PriceperLB,AVG_PriceperLB,BUD_PriceperLB," +
                                 "TD_GMPerLb,MTD_GMPerLb,AVG_GMPerLb,BUD_GMPerLb," +
                                 "isnull(TDBrnExpBud,'0') as TDBrnExpBud, isnull(MTDBrnExpBud,'0') as MTDBrnExpBud, isnull(AvgBrnExpBud,'0') as AvgBrnExpBud, isnull(BUDBrnExpBud,'0') as BUDBrnExpBud";

            string _whereClause = "[Loc_No] = '" + BrnID + "'";

            DataSet dsuserprofile = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, SP_GENERALSELECT,
                                            new SqlParameter("@tableName", _tableName),
                                            new SqlParameter("@columnNames", _columnName),
                                            new SqlParameter("@whereCondition", _whereClause));

            // Check whether any value has returned
            if (dsuserprofile.Tables[0].Rows.Count > 0)
            {


                tblBrID.Rows[1].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 0));
                tblBrID.Rows[1].Cells[3].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 0));
                tblBrID.Rows[1].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GrossmarginDollar"].ToString()), 0));
                tblBrID.Rows[1].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_GrossmarginDollar"].ToString()), 0));

                tblBrID.Rows[2].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TDBrnExpBud"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TDBrnExpBud"].ToString()), 0));
                tblBrID.Rows[2].Cells[3].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTDBrnExpBud"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTDBrnExpBud"].ToString()), 0)); //dsuserprofile.Tables[0].Rows[0]["MTDBrnExpBud"].ToString();
                tblBrID.Rows[2].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AvgBrnExpBud"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AvgBrnExpBud"].ToString()), 0));
                tblBrID.Rows[2].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUDBrnExpBud"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUDBrnExpBud"].ToString()), 0));
                //dtBrPerformance.Rows[2].Cells[2].Text = "-";

                tblBrID.Rows[4].Cells[1].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginPct"].ToString()), 3) * 100, 1));
                tblBrID.Rows[4].Cells[3].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginPct"].ToString()), 3) * 100, 1));
                tblBrID.Rows[4].Cells[2].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GrossmarginPct"].ToString()), 3) * 100, 1));
                tblBrID.Rows[4].Cells[5].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_GrossmarginPct"].ToString()), 3) * 100, 1));

                tblBrID.Rows[5].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_SalesDollar"].ToString()), 0));
                tblBrID.Rows[5].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_SalesDollar"].ToString());
                tblBrID.Rows[5].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_SalesDollar"].ToString()), 0));
                tblBrID.Rows[5].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_SalesDollar"].ToString()), 0));

                tblBrID.Rows[6].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_OrderCount"].ToString()), 0));
                tblBrID.Rows[6].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_OrderCount"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_OrderCount"].ToString()), 0));
                tblBrID.Rows[6].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_OrderCount"].ToString());
                tblBrID.Rows[6].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_OrderCount"].ToString()), 0));

                tblBrID.Rows[7].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LineCount"].ToString()), 0));
                tblBrID.Rows[7].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LineCount"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LineCount"].ToString()), 0));
                tblBrID.Rows[7].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_LineCount"].ToString());
                tblBrID.Rows[7].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_LineCount"].ToString()), 0));

                tblBrID.Rows[8].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LbsShipped"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LbsShipped"].ToString()), 0));
                tblBrID.Rows[8].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_LbsShipped"].ToString());
                tblBrID.Rows[8].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LbsShipped"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LbsShipped"].ToString()), 0));
                tblBrID.Rows[8].Cells[5].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_LbsShipped"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_LbsShipped"].ToString()), 0));


                tblBrID.Rows[9].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_PriceperLB"].ToString()), 3));
                tblBrID.Rows[9].Cells[3].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_PriceperLB"].ToString()), 3));
                tblBrID.Rows[9].Cells[2].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_PriceperLB"].ToString()), 3));
                tblBrID.Rows[9].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_PriceperLB"].ToString()), 3));

                tblBrID.Rows[10].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GMPerLb"].ToString()), 3));
                tblBrID.Rows[10].Cells[3].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GMPerLb"].ToString()), 3));
                tblBrID.Rows[10].Cells[2].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GMPerLb"].ToString()), 3));
                tblBrID.Rows[10].Cells[5].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["BUD_GMPerLb"].ToString()), 3));

                #region Fill Forecast Field

                int workDayofMonth = fiscalCalendar.CurrentWorkDay;
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


                    tblBrID.Rows[1].Cells[4].Text = forecastGPDol;
                    tblBrID.Rows[2].Cells[4].Text = (forecastBrExpBudget == "" ? "0" : forecastBrExpBudget);
                    tblBrID.Rows[5].Cells[4].Text = RoundOffMTD(forecastSaleDol);
                    tblBrID.Rows[6].Cells[4].Text = RoundOffMTD(forecastNoOfOrder);
                    tblBrID.Rows[7].Cells[4].Text = RoundOffMTD(forecastNoOfLines);
                    tblBrID.Rows[8].Cells[4].Text = RoundOffMTD(forecastNoOfLbsShipped);
                    //dtBrPerformance.Rows[2].Cells[4].Text = "-";

                    // Display brach Profit [ Profit = GM$ - Exp Bud ]                        
                    tblBrID.Rows[3].Cells[1].Text = String.Format("{0:#,###}", (Convert.ToInt32(tblBrID.Rows[1].Cells[1].Text.Replace(",", "")) - Convert.ToInt32(tblBrID.Rows[2].Cells[1].Text.Replace(",", ""))));
                    tblBrID.Rows[3].Cells[2].Text = String.Format("{0:#,###}", (Convert.ToInt32(tblBrID.Rows[1].Cells[2].Text.Replace(",", "")) - Convert.ToInt32(tblBrID.Rows[2].Cells[2].Text.Replace(",", ""))));
                    tblBrID.Rows[3].Cells[3].Text = String.Format("{0:#,###}", (Convert.ToInt32(tblBrID.Rows[1].Cells[3].Text.Replace(",", "")) - Convert.ToInt32(tblBrID.Rows[2].Cells[3].Text.Replace(",", ""))));
                    tblBrID.Rows[3].Cells[4].Text = String.Format("{0:#,###}", (Convert.ToInt32(tblBrID.Rows[1].Cells[4].Text.Replace(",", "")) - Convert.ToInt32(tblBrID.Rows[2].Cells[4].Text.Replace(",", ""))));
                    tblBrID.Rows[3].Cells[5].Text = String.Format("{0:#,###}", (Convert.ToInt32(tblBrID.Rows[1].Cells[5].Text.Replace(",", "")) - Convert.ToInt32(tblBrID.Rows[2].Cells[5].Text.Replace(",", ""))));


                }
                #endregion

            }
            else
            {
                tblBrID.Rows[1].Cells[1].Text = "0";
                tblBrID.Rows[1].Cells[3].Text = "0";
                tblBrID.Rows[1].Cells[2].Text = "0";
                tblBrID.Rows[1].Cells[4].Text = "0";
                tblBrID.Rows[2].Cells[1].Text = "0.0";
                tblBrID.Rows[2].Cells[3].Text = "0.0";
                tblBrID.Rows[2].Cells[2].Text = "0.0";
                tblBrID.Rows[2].Cells[4].Text = "0.0";
                tblBrID.Rows[3].Cells[1].Text = "0";
                tblBrID.Rows[3].Cells[3].Text = "0";
                tblBrID.Rows[3].Cells[2].Text = "0";
                tblBrID.Rows[3].Cells[4].Text = "0";

                tblBrID.Rows[4].Cells[1].Text = "0";
                tblBrID.Rows[4].Cells[3].Text = "0";
                tblBrID.Rows[4].Cells[2].Text = "0";
                tblBrID.Rows[4].Cells[4].Text = "0";
                tblBrID.Rows[5].Cells[1].Text = "0";
                tblBrID.Rows[5].Cells[3].Text = "0";
                tblBrID.Rows[5].Cells[2].Text = "0";
                tblBrID.Rows[5].Cells[4].Text = "0";
                tblBrID.Rows[6].Cells[1].Text = "0";
                tblBrID.Rows[6].Cells[3].Text = "0";
                tblBrID.Rows[6].Cells[2].Text = "0";
                tblBrID.Rows[6].Cells[4].Text = "0";
                tblBrID.Rows[7].Cells[1].Text = "0";
                tblBrID.Rows[7].Cells[3].Text = "0";
                tblBrID.Rows[7].Cells[2].Text = "0";
                tblBrID.Rows[7].Cells[4].Text = "0";
                tblBrID.Rows[8].Cells[1].Text = "0.00";
                tblBrID.Rows[8].Cells[3].Text = "0.00";
                tblBrID.Rows[8].Cells[2].Text = "0.00";
                tblBrID.Rows[8].Cells[4].Text = "0.00";
                tblBrID.Rows[9].Cells[1].Text = "0.000";
                tblBrID.Rows[9].Cells[3].Text = "0.000";
                tblBrID.Rows[9].Cells[2].Text = "0.000";
                tblBrID.Rows[9].Cells[4].Text = "0.000";
                tblBrID.Rows[10].Cells[1].Text = "0.000";
                tblBrID.Rows[10].Cells[2].Text = "0.000";
                tblBrID.Rows[10].Cells[3].Text = "0.000";
                tblBrID.Rows[10].Cells[4].Text = "0.000";
            }
        }
        catch (Exception ex)
        {

        }


    }

    protected void dlRegion_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Label lblBrID = e.Item.FindControl("lblBrID") as Label;
            Label lblBrName = e.Item.FindControl("lblBrName") as Label;
            Table tblBrPerformance = e.Item.FindControl("dtBrPerformance") as Table;

            DisplayBranch(lblBrID.Text, tblBrPerformance);

            HtmlImage ibtnDailySales = e.Item.FindControl("ibtnDailySales") as HtmlImage;
            ibtnDailySales.Attributes.Add("onclick", "LoadSalesReport('" + lblBrID.Text + "');");

            HtmlImage ibtnCSR = e.Item.FindControl("ibtnCSR") as HtmlImage;
            ibtnCSR.Attributes.Add("onclick", "LoadCSRReport('" + lblBrID.Text + "');");
        }
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

    public void GetALLRegions()
    {

        try
        {
            DataSet dsRegion = SqlHelper.ExecuteDataset(erpConnectionString, SP_GENERALSELECT,
                                       new SqlParameter("@tableName", "LocMaster"),
                                       new SqlParameter("@columnNames", "DISTINCT LocSalesGrp"),
                                       new SqlParameter("@whereCondition", " (ISNULL(RTRIM(LTRIM(LocSalesGrp)), '') <> '')"));

            ddlRegion.DataSource = dsRegion.Tables[0];
            ddlRegion.DataTextField = "LocSalesGrp";
            ddlRegion.DataValueField = "LocSalesGrp";
            ddlRegion.DataBind();
            ddlRegion.Items.Insert(0, new ListItem("ALL", "ALL"));
            ddlRegion.SelectedValue = Request.QueryString["RegionID"].ToString();
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    protected void ddlRegion_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlRegion.SelectedValue.ToString() == "ALL")
            _whereCon = "(ISNULL(RTRIM(LTRIM(LocSalesGrp)), '') <> '') AND LocType in ('B','S') ORDER BY LOCID ";
        else
            _whereCon = "[LocSalesGrp] = '" + ddlRegion.SelectedValue.ToString() + "'  AND LocType in ('B','S') ORDER BY LOCID";

        DataSet dsRegion1 = SqlHelper.ExecuteDataset(erpConnectionString, SP_GENERALSELECT,
                   new SqlParameter("@tableName", "LocMaster"),
                   new SqlParameter("@columnNames", "LOCID,LOCNAME"),
                   new SqlParameter("@whereCondition", _whereCon));
        dlRegion.DataSource = FilterAuthorizedBranch(dsRegion1);
        dlRegion.DataBind();
        if (dlRegion.Items.Count <= 0)
        {
            lblStatus.Text = "No Records Found";
            lblStatus.Visible = true;
        }
        else
        {
            lblStatus.Visible = false;
        }

    }

    private DataTable FilterAuthorizedBranch(DataSet BranchByRegion)
    {
        string[] AuthorizedBranch = Session["BranchIDForALL"].ToString().Split(',');
        string _BrFilter = "";

        for (int i = 0; i <= AuthorizedBranch.Length - 1; i++)
            _BrFilter += " LOCID=" + AuthorizedBranch[i] + " OR ";

        if (_BrFilter.Length > 0)
            _BrFilter = _BrFilter.Remove(_BrFilter.Length - 3, 3);

        BranchByRegion.Tables[0].DefaultView.RowFilter = _BrFilter;
        return BranchByRegion.Tables[0].DefaultView.ToTable();
    }

    protected void imgClose_Click(object sender, ImageClickEventArgs e)
    {
        ScriptManager.RegisterClientScriptBlock(imgClose, imgClose.GetType(), "CloseForm", "this.window.close();", true);
    }
}
