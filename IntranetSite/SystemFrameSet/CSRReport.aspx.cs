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

public partial class SystemFrameSet_CSRReport : System.Web.UI.Page
{
    private string curMonth = string.Empty;
    private string curYear = string.Empty;
    private string _whereCon = string.Empty;
    private string strBRNID = string.Empty;
    private const string SP_GENERALSELECT = "UGEN_SP_Select";
    private string reportsConnectionString = Global.ReportsConnectionString;
    //private string reportsConnectionString = "workstation id=PFCSQLP;packet size=4096;user id=pfcnormal;data source=PFCSQLP;persist security info=True;initial catalog=pfcreports;password=pfcnormal";
    
    SalesReportUtils salesReportUtils = new SalesReportUtils();
    CSRReports csrReport = new CSRReports();
    FiscalCalendar fiscalCalendar;

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        GetCurDateTime();

        if (!Page.IsPostBack)
        {
            if (Request.QueryString["BranchID"] != null)
            {
                strBRNID = Request.QueryString["BranchID"].ToString();
                
                GetALLBranches();

                DataTable dtRepNames = csrReport.GetRepMasterNames(Request.QueryString["BranchID"].ToString());
                if (dtRepNames.Rows.Count <= 0)
                    lblNorecords.Visible = true;
                else
                    lblNorecords.Visible = false;
                
                dlRegion.DataSource = dtRepNames;
                dlRegion.DataBind();
    
            }
        }
    }
    
    private void LoadSalesPerformance(string CSRID, string BrnID, Table tblBrID)
    {
        try
        {
            string _tableName = string.Empty;
            string _columnName = string.Empty;
            string _whereClause = string.Empty;
            //Local variable declaration
            GetCurDateTime();

            _columnName = "TD_GrossmarginDollar,MTD_GrossmarginDollar,AVG_GrossmarginDollar,LMTD_GrossmarginDollar,TD_GrossmarginPct,MTD_GrossmarginPct,AVG_Grossmarginpct,LMTD_Grossmarginpct,TD_SalesDollar,MTD_SalesDollar,AVG_SalesDollar,LMTD_SalesDollar," +
                            "TD_OrderCount,MTD_OrderCount,AVG_OrderCount,LMTD_OrderCount,TD_LineCount,MTD_LineCount,AVG_LineCount,LMTD_LineCount,TD_LbsShipped,MTD_LbsShipped,AVG_LbsShipped,LMTD_LbsShipped,TD_PriceperLB,MTD_PriceperLB,AVG_PriceperLB,LMTD_PriceperLB," +
                            "TD_GMPerLb,MTD_GMPerLb,AVG_GMPerLb";
            _tableName = "Dashboard_UserLoc";
            _whereClause = "[UserID] = '" + CSRID + "' and [Loc_No] = '" + BrnID + "'";
            tblBrID.Rows[0].Cells[2].Text = "Br Avg";
            tblBrID.Rows[0].Cells[4].Text = "LMTD";

            DataSet dsuserprofile = SqlHelper.ExecuteDataset(reportsConnectionString, SP_GENERALSELECT,
                                                    new SqlParameter("@tableName", _tableName),
                                                    new SqlParameter("@columnNames", _columnName),
                                                    new SqlParameter("@whereCondition", _whereClause));


            // Check whether any value has returned
            if (dsuserprofile.Tables[0].Rows.Count > 0)
            {

                tblBrID.Rows[1].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 2));
                tblBrID.Rows[1].Cells[3].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 2));
                tblBrID.Rows[1].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GrossmarginDollar"].ToString()), 2));

                tblBrID.Rows[2].Cells[1].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginPct"].ToString()), 3) * 100, 1));
                tblBrID.Rows[2].Cells[3].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginPct"].ToString()), 3) * 100, 1));
                tblBrID.Rows[2].Cells[2].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GrossmarginPct"].ToString()), 3) * 100, 1));

                tblBrID.Rows[3].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_SalesDollar"].ToString()), 0));
                tblBrID.Rows[3].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_SalesDollar"].ToString());
                tblBrID.Rows[3].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_SalesDollar"].ToString()), 0)); ;

                tblBrID.Rows[4].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_OrderCount"].ToString()), 0));
                tblBrID.Rows[4].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_OrderCount"].ToString());
                tblBrID.Rows[4].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_OrderCount"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_OrderCount"].ToString()), 0)); ;

                tblBrID.Rows[5].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LineCount"].ToString()), 0));
                tblBrID.Rows[5].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_LineCount"].ToString());
                tblBrID.Rows[5].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LineCount"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LineCount"].ToString()), 0)); ;

                tblBrID.Rows[6].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LbsShipped"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LbsShipped"].ToString()), 0));
                tblBrID.Rows[6].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_LbsShipped"].ToString());
                tblBrID.Rows[6].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LbsShipped"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LbsShipped"].ToString()), 0)); ;

                tblBrID.Rows[7].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_PriceperLB"].ToString()), 2));
                tblBrID.Rows[7].Cells[3].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_PriceperLB"].ToString()), 2));
                tblBrID.Rows[7].Cells[2].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_PriceperLB"].ToString()), 2));

                // To display gross margin per lbs
                tblBrID.Rows[8].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GMPerLb"].ToString()), 2));
                tblBrID.Rows[8].Cells[2].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GMPerLb"].ToString()), 2));
                tblBrID.Rows[8].Cells[3].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GMPerLb"].ToString()), 2));
                tblBrID.Rows[8].Cells[4].Text = "0.00";


                tblBrID.Rows[1].Cells[4].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_GrossmarginDollar"].ToString()), 2));
                tblBrID.Rows[2].Cells[4].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_GrossmarginPct"].ToString()), 3) * 100, 1));
                tblBrID.Rows[3].Cells[4].Text = RoundOff(dsuserprofile.Tables[0].Rows[0]["LMTD_SalesDollar"].ToString());
                tblBrID.Rows[4].Cells[4].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_OrderCount"].ToString()), 0));
                tblBrID.Rows[5].Cells[4].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_LineCount"].ToString()), 0));
                tblBrID.Rows[6].Cells[4].Text = RoundOff(dsuserprofile.Tables[0].Rows[0]["LMTD_LbsShipped"].ToString());
                tblBrID.Rows[7].Cells[4].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_PriceperLB"].ToString()), 2));

            }
            else
            {

                tblBrID.Rows[1].Cells[1].Text = "0";
                tblBrID.Rows[1].Cells[2].Text = "0";
                tblBrID.Rows[1].Cells[3].Text = "0";
                tblBrID.Rows[1].Cells[4].Text = "0";
                tblBrID.Rows[2].Cells[1].Text = "0.0";
                tblBrID.Rows[2].Cells[2].Text = "0.0";
                tblBrID.Rows[2].Cells[3].Text = "0.0";
                tblBrID.Rows[2].Cells[4].Text = "0.0";
                tblBrID.Rows[3].Cells[1].Text = "0";
                tblBrID.Rows[3].Cells[2].Text = "0";
                tblBrID.Rows[3].Cells[3].Text = "0";
                tblBrID.Rows[3].Cells[4].Text = "0";
                tblBrID.Rows[4].Cells[1].Text = "0";
                tblBrID.Rows[4].Cells[2].Text = "0";
                tblBrID.Rows[4].Cells[3].Text = "0";
                tblBrID.Rows[4].Cells[4].Text = "0";
                tblBrID.Rows[5].Cells[1].Text = "0";
                tblBrID.Rows[5].Cells[2].Text = "0";
                tblBrID.Rows[5].Cells[3].Text = "0";
                tblBrID.Rows[5].Cells[4].Text = "0";
                tblBrID.Rows[6].Cells[1].Text = "0";
                tblBrID.Rows[6].Cells[2].Text = "0";
                tblBrID.Rows[6].Cells[3].Text = "0";
                tblBrID.Rows[6].Cells[4].Text = "0";
                tblBrID.Rows[7].Cells[1].Text = "0.00";
                tblBrID.Rows[7].Cells[2].Text = "0.00";
                tblBrID.Rows[7].Cells[3].Text = "0.00";
                tblBrID.Rows[7].Cells[4].Text = "0.00";
                tblBrID.Rows[8].Cells[1].Text = "0.00";
                tblBrID.Rows[8].Cells[2].Text = "0.00";
                tblBrID.Rows[8].Cells[3].Text = "0.00";
                tblBrID.Rows[8].Cells[4].Text = "0.00";

            }
        }
        catch (Exception ex)
        {
            throw ex;
        }

    }

    protected void dlRegion_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Label lblBrID = e.Item.Controls[1] as Label;
            Table tblBrPerformance = e.Item.Controls[3] as Table;
            LoadSalesPerformance(lblBrID.Text, strBRNID, tblBrPerformance);
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
        DataTable dtRepNames = csrReport.GetRepMasterNames(ddlBranch.SelectedValue.ToString());
        strBRNID = ddlBranch.SelectedValue.ToString();
        if (dtRepNames.Rows.Count <= 0)
            lblNorecords.Visible = true;
        else
            lblNorecords.Visible = false;

        dlRegion.DataSource = dtRepNames;
        dlRegion.DataBind();
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

    private void GetCurDateTime()
    {
        try
        {
            string _tableName = "DashboardRanges";
            string _columnName = "MonthValue,YearValue";
            string _whereClause = "DashboardParameter='CurrentMonth'";

            DataSet dsDashboardRange = SqlHelper.ExecuteDataset(reportsConnectionString, SP_GENERALSELECT,
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


}
