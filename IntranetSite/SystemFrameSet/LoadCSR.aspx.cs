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

public partial class SystemFrameSet_LoadCSR : System.Web.UI.Page
{
    private string curMonth = string.Empty;
    private string curYear = string.Empty;
    private const string SP_GENERALSELECT = "UGEN_SP_Select";
    UserValidation objUser = new UserValidation();

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();

        if (!Page.IsPostBack)
        {
             if (Request.QueryString["BranchID"] != null)        
                 LoadCSRUser();
        }
        
    }
    
    private void LoadCSRUser()
    {
        try
        {
            DataSet dsCsr = (DataSet)SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, "[UGEN_SP_Select]",
                                  new SqlParameter("@TableName", "dbo.UCOR_UserSetup a join  dbo.UCOR_UserType b on a.UserType=b.typeID"),
                                  new SqlParameter("@columnNames", "a.username as UserName"),
                                  new SqlParameter("@whereClause", "a.CompanyId='" + Request.QueryString["BranchID"].ToString() + "' and b.Type='Customer Sales Rep' order by username"));
            ddlCsr.DataSource = dsCsr.Tables[0];
            ddlCsr.DataTextField = "UserName";
            ddlCsr.DataValueField = "UserName";
            ddlCsr.DataBind();
            LoadSalesPerformance();
        }
        catch (Exception ex)
        {
            throw;
        }
    }

    protected void ddlBranch_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadSalesPerformance();
    }
    
    private void LoadSalesPerformance()
    {       
          try 
	        {	        
    		    string _tableName = string.Empty;
                string _columnName = string.Empty;
                string _whereClause = string.Empty;
                //Local variable declaration
                GetCurDateTime();
                
                _columnName = "TD_GrossmarginDollar,MTD_GrossmarginDollar,AVG_GrossmarginDollar,LMTD_GrossmarginDollar,TD_GrossmarginPct,MTD_GrossmarginPct,AVG_Grossmarginpct,LMTD_Grossmarginpct,TD_SalesDollar,MTD_SalesDollar,AVG_SalesDollar,LMTD_SalesDollar," +
                                "TD_OrderCount,MTD_OrderCount,AVG_OrderCount,LMTD_OrderCount,TD_LineCount,MTD_LineCount,AVG_LineCount,LMTD_LineCount,TD_LbsShipped,MTD_LbsShipped,AVG_LbsShipped,LMTD_LbsShipped,TD_PriceperLB,MTD_PriceperLB,AVG_PriceperLB,LMTD_PriceperLB,"+
                                "TD_GMPerLb,MTD_GMPerLb,AVG_GMPerLb";
                _tableName = "Dashboard_UserLoc";
                _whereClause = "[UserID] = '" + ddlCsr.SelectedValue.ToString() + "' and [Loc_No] = '" + Request.QueryString["BranchID"].ToString() + "'";
                dtUserProfile.Rows[0].Cells[2].Text = "Br Avg";
                dtUserProfile.Rows[0].Cells[4].Text = "LMTD";
             
                DataSet dsuserprofile = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, SP_GENERALSELECT,
                                                        new SqlParameter("@tableName", _tableName),
                                                        new SqlParameter("@columnNames", _columnName),
                                                        new SqlParameter("@whereCondition", _whereClause));


                // Check whether any value has returned
                if (dsuserprofile.Tables[0].Rows.Count > 0)
                {

                    dtUserProfile.Rows[1].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginDollar"].ToString()), 2));
                    dtUserProfile.Rows[1].Cells[3].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginDollar"].ToString()), 2));
                    dtUserProfile.Rows[1].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GrossmarginDollar"].ToString()), 2));

                    dtUserProfile.Rows[2].Cells[1].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GrossmarginPct"].ToString()), 3) * 100, 1));
                    dtUserProfile.Rows[2].Cells[3].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GrossmarginPct"].ToString()), 3) * 100, 1));
                    dtUserProfile.Rows[2].Cells[2].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GrossmarginPct"].ToString()), 3) * 100, 1));

                    dtUserProfile.Rows[3].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_SalesDollar"].ToString()), 0));
                    dtUserProfile.Rows[3].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_SalesDollar"].ToString());
                    dtUserProfile.Rows[3].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_SalesDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_SalesDollar"].ToString()), 0)); ;

                    dtUserProfile.Rows[4].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_OrderCount"].ToString()), 0));
                    dtUserProfile.Rows[4].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_OrderCount"].ToString());
                    dtUserProfile.Rows[4].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_OrderCount"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_OrderCount"].ToString()), 0)); ;

                    dtUserProfile.Rows[5].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LineCount"].ToString()), 0));
                    dtUserProfile.Rows[5].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_LineCount"].ToString());
                    dtUserProfile.Rows[5].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LineCount"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LineCount"].ToString()), 0)); ;

                    dtUserProfile.Rows[6].Cells[1].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LbsShipped"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_LbsShipped"].ToString()), 0));
                    dtUserProfile.Rows[6].Cells[3].Text = RoundOffMTD(dsuserprofile.Tables[0].Rows[0]["MTD_LbsShipped"].ToString());
                    dtUserProfile.Rows[6].Cells[2].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LbsShipped"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_LbsShipped"].ToString()), 0)); ;

                    dtUserProfile.Rows[7].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_PriceperLB"].ToString()), 2));
                    dtUserProfile.Rows[7].Cells[3].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_PriceperLB"].ToString()), 2));
                    dtUserProfile.Rows[7].Cells[2].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_PriceperLB"].ToString()), 2));

                    // To display gross margin per lbs
                    dtUserProfile.Rows[8].Cells[1].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["TD_GMPerLb"].ToString()), 2));
                    dtUserProfile.Rows[8].Cells[2].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["AVG_GMPerLb"].ToString()), 2));
                    dtUserProfile.Rows[8].Cells[3].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["MTD_GMPerLb"].ToString()), 2));
                    dtUserProfile.Rows[8].Cells[4].Text = "0.00";


                    dtUserProfile.Rows[1].Cells[4].Text = (System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_GrossmarginDollar"].ToString()), 0) == 0) ? "0" : String.Format("{0:#,###}", System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_GrossmarginDollar"].ToString()), 2));
                    dtUserProfile.Rows[2].Cells[4].Text = Convert.ToString(System.Math.Round(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_GrossmarginPct"].ToString()), 3) * 100, 1));
                    dtUserProfile.Rows[3].Cells[4].Text = RoundOff(dsuserprofile.Tables[0].Rows[0]["LMTD_SalesDollar"].ToString());
                    dtUserProfile.Rows[4].Cells[4].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_OrderCount"].ToString()), 0));
                    dtUserProfile.Rows[5].Cells[4].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_LineCount"].ToString()), 0));
                    dtUserProfile.Rows[6].Cells[4].Text = RoundOff(dsuserprofile.Tables[0].Rows[0]["LMTD_LbsShipped"].ToString());
                    dtUserProfile.Rows[7].Cells[4].Text = Convert.ToString(System.Math.Round(Convert.ToDecimal(dsuserprofile.Tables[0].Rows[0]["LMTD_PriceperLB"].ToString()), 2));

                }
                else
                {

                    dtUserProfile.Rows[1].Cells[1].Text = "0";
                    dtUserProfile.Rows[1].Cells[2].Text = "0";
                    dtUserProfile.Rows[1].Cells[3].Text = "0";
                    dtUserProfile.Rows[1].Cells[4].Text = "0";
                    dtUserProfile.Rows[2].Cells[1].Text = "0.0";
                    dtUserProfile.Rows[2].Cells[2].Text = "0.0";
                    dtUserProfile.Rows[2].Cells[3].Text = "0.0";
                    dtUserProfile.Rows[2].Cells[4].Text = "0.0";
                    dtUserProfile.Rows[3].Cells[1].Text = "0";
                    dtUserProfile.Rows[3].Cells[2].Text = "0";
                    dtUserProfile.Rows[3].Cells[3].Text = "0";
                    dtUserProfile.Rows[3].Cells[4].Text = "0";
                    dtUserProfile.Rows[4].Cells[1].Text = "0";
                    dtUserProfile.Rows[4].Cells[2].Text = "0";
                    dtUserProfile.Rows[4].Cells[3].Text = "0";
                    dtUserProfile.Rows[4].Cells[4].Text = "0";
                    dtUserProfile.Rows[5].Cells[1].Text = "0";
                    dtUserProfile.Rows[5].Cells[2].Text = "0";
                    dtUserProfile.Rows[5].Cells[3].Text = "0";
                    dtUserProfile.Rows[5].Cells[4].Text = "0";
                    dtUserProfile.Rows[6].Cells[1].Text = "0";
                    dtUserProfile.Rows[6].Cells[2].Text = "0";
                    dtUserProfile.Rows[6].Cells[3].Text = "0";
                    dtUserProfile.Rows[6].Cells[4].Text = "0";
                    dtUserProfile.Rows[7].Cells[1].Text = "0.00";
                    dtUserProfile.Rows[7].Cells[2].Text = "0.00";
                    dtUserProfile.Rows[7].Cells[3].Text = "0.00";
                    dtUserProfile.Rows[7].Cells[4].Text = "0.00";
                    dtUserProfile.Rows[8].Cells[1].Text = "0.00";
                    dtUserProfile.Rows[8].Cells[2].Text = "0.00";
                    dtUserProfile.Rows[8].Cells[3].Text = "0.00";
                    dtUserProfile.Rows[8].Cells[4].Text = "0.00";

                }
	        }
	        catch (Exception ex)
	        {        		
		        throw ex;
	        }
               
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
        }
        catch (Exception ex)
        {
            throw ex;
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
}
