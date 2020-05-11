
/********************************************************************************************
 * File	Name			:	ContactData.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	To display the customer Data
 * Created By			:	MaheshKumar.S
 * Created Date			:	11/14/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 11/14/2006		    Version 1		Mahesh      		Created 
 *
 * 4/9/2007             Version 2       Sathya              Edited 
 *********************************************************************************************/


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
using System.Reflection;
using System.IO;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.Securitylayer;

public partial class CustomerActivitySheet_CustomerData : System.Web.UI.Page
{
    #region variable declaration

    string strTable = "CAS_CustomerData";
    string strWhere = string.Empty;

    string strDisplayColumns = "CurYear, CurMonth, CustNo, CustName, CustAddress, CustCity, CustState, CustZip, CustPhone,YTDCustRank," +
                                "CustFax,CustContact, Chain, Terms, DSO,InsideSls, SalesPerson, BuyGrp, SalesRep, HubSatellites, MTDCustRank," +
                                "LMTDCustRank,MTDShipPattern,LYTDCustRank,CustType, BranchNo, BranchDesc,LMTDShipPattern,CreditLimit," +
                                "KeyCustRebate,AnnualRebate," +
                                "cast(isnull(Aging30Pct,0) as decimal(15,1)) as Aging30Pct ," +
                                "cast(isnull(Aging60Pct,0) as decimal(15,1)) as Aging60Pct," +
                                "cast(isnull(Aging90Pct,0) as decimal(15,1)) as Aging90Pct," +
                                "cast(isnull(AgingCurPct,0) as decimal(15,1)) as AgingCurPct," +
                                "replace(convert(varchar,cast((cast(isnull(AgingCur,0) as bigint)) as money),1),'.00','') as AgingCur," +
                                "replace(convert(varchar,cast((cast(isnull(Aging30,0) as bigint)) as money),1),'.00','') as Aging30," +
                                "replace(convert(varchar,cast((cast(isnull(Aging60,0) as bigint)) as money),1),'.00','') as Aging60," +
                                "replace(convert(varchar,cast((cast(isnull(AgingOver90,0) as bigint)) as money),1),'.00','') as AgingOver90," +
                                "replace(convert(varchar,cast((cast(isnull(MTDSales,0) as bigint)) as money),1),'.00','') as MTDSales," +
                                "replace(convert(varchar,cast((cast(isnull(YTDSales,0) as bigint)) as money),1),'.00','') as YTDSales," +
                                "replace(convert(varchar,cast((cast(isnull(LMTDSales,0) as bigint)) as money),1),'.00','') as LMTDSales," +
                                "replace(convert(varchar,cast((cast(isnull(LYTDSales,0) as bigint)) as money),1),'.00','') as LYTDSales," +
                                "cast(isnull(MTDGMPct,0) as decimal(25,1)) as MTDGMPct,cast(isnull(YTDGMPct,0) as decimal(25,1)) as YTDGMPct," +
                                "cast(isnull(LMTDGMPct,0) as decimal(25,1)) as LMTDGMPct,cast(isnull(LYTDGMPct,0) as decimal(25,1)) as LYTDGMPct," +
                                "cast(isnull(MTDGM,0) as bigint) as MTDGM,cast(isnull(YTDGM,0) as bigint) as YTDGM," +
                                "cast(isnull(LMTDGM,0) as bigint) as LMTDGM,cast(isnull(LYTDGM,0) as bigint) as LYTDGM," +
                                "cast(isnull(MTDFillRate,0) as bigint) as MTDFillRate,cast(isnull(YTDFillRate,0) as bigint) as YTDFillRate," +
                                "cast(isnull(LMTDFillRate,0) as bigint) as LMTDFillRate,cast(isnull(LYTDFillRate,0) as bigint) as LYTDFillRate," +
                                "cast(isnull(MTDFillRate_Lines,0) as bigint) as MTDFillRate_Lines,cast(isnull(YTDFillRate_Lines,0) as bigint) as YTDFillRate_Lines," +
                                "cast(isnull(LMTDFillRate_Lines,0) as bigint) as LMTDFillRate_Lines,cast(isnull(LYTDFillRate_Lines,0) as bigint) as LYTDFillRate_Lines," +
                                "cast(isnull(MTDOrd_OE,0) as bigint) as MTDOrd_OE, cast(isnull(YTDOrd_OE,0) as bigint) as YTDOrd_OE," +
                                "cast(isnull(LMTDOrd_OE,0) as bigint) as LMTDOrd_OE,cast(isnull(LYTDOrd_OE,0) as bigint) as LYTDOrd_OE," +
                                "cast(isnull(MTDLines_OE,0) as bigint) as MTDLines_OE,cast(isnull(YTDLines_OE,0) as bigint) as YTDLines_OE," +
                                "cast(isnull(LMTDLines_OE,0) as bigint) as LMTDLines_OE,cast(isnull(LYTDLines_OE,0) as bigint) as LYTDLines_OE," +
                                "cast(isnull(MTDOrd_EComm,0) as bigint) as MTDOrd_EComm, cast(isnull(YTDOrd_EComm,0) as bigint) as YTDOrd_EComm," +
                                "cast(isnull(LMTDOrd_EComm,0) as bigint) as LMTDOrd_EComm,cast(isnull(LYTDOrd_EComm,0) as bigint) as LYTDOrd_EComm," +
                                "cast(isnull(MTDLines_EComm,0) as bigint) as MTDLines_EComm,cast(isnull(YTDLines_EComm,0) as bigint) as YTDLines_EComm," +
                                "cast(isnull(LMTDLines_EComm,0) as bigint) as LMTDLines_EComm,cast(isnull(LYTDLines_EComm,0) as bigint) as LYTDLines_EComm," +
                                "replace(convert(varchar,cast((cast(isnull(MTDLbs_EComm,0) as bigint)) as money),1),'.00','') as MTDLbs_EComm," +
                                "replace(convert(varchar,cast((cast(isnull(YTDLbs_EComm,0) as bigint)) as money),1),'.00','') as YTDLbs_EComm , " +
                                "replace(convert(varchar,cast((cast(isnull(LMTDLbs_EComm,0) as bigint)) as money),1),'.00','') as LMTDLbs_EComm," +
                                "replace(convert(varchar,cast((cast(isnull(LYTDLbs_EComm,0) as bigint)) as money),1),'.00','') as LYTDLbs_EComm," +
                                "replace(convert(varchar,cast((cast(isnull(MTDLbs_OE,0) as bigint)) as money),1),'.00','') as MTDLbs_OE," +
                                "replace(convert(varchar,cast((cast(isnull(YTDLbs_OE,0) as bigint)) as money),1),'.00','') as YTDLbs_OE , " +
                                "replace(convert(varchar,cast((cast(isnull(LMTDLbs_OE,0) as bigint)) as money),1),'.00','') as LMTDLbs_OE," +
                                "replace(convert(varchar,cast((cast(isnull(LYTDLbs_OE,0) as bigint)) as money),1),'.00','') as LYTDLbs_OE, " +
                                "replace(convert(varchar,cast((cast(isnull(SalesDollarVolume,0) as bigint)) as money),1),'.00','') as SalesDollarVolume," +
                                "replace(convert(varchar,cast((cast(isnull(MarginDollars,0) as bigint)) as money),1),'.00','') as MarginDollars," +
                                "replace(convert(varchar,cast((cast(isnull(OrderMarginDollars,0) as bigint)) as money),1),'.00','') as OrderMarginDollars," +
                                "replace(convert(varchar,cast((cast(isnull(LineMarginDollars,0) as bigint)) as money),1),'.00','') as LineMarginDollars," +
                                "cast(isnull(Average,0) as decimal(15,1)) as Average," +
                                "cast(isnull(MarginPercent,0) as Decimal(25,1)) as MarginPercent," +
                                "cast(isnull(PricePerLB,0) as Decimal(15,2)) as PricePerLB," +
                                "cast(isnull(MTDPricePerLB,0) as decimal(15,2)) as MTDPricePerLB,cast(isnull(LMTDPricePerLB,0) as decimal(15,2)) as LMTDPricePerLB," +
                                "cast(isnull(YTDPricePerLB,0) as decimal(15,2)) as YTDPricePerLB,cast(isnull(LYTDPricePerLB,0) as decimal(15,2)) as LYTDPricePerLB," +
                                "replace(convert(varchar,cast((cast(isnull(OrderDollarPerSO,0) as bigint)) as money),1),'.00','') as OrderDollarPerSO," +
                                "replace(convert(varchar,cast((cast(isnull(OrderDollarPerSOLine,0) as bigint)) as money),1),'.00','') as OrderDollarPerSOLine," +
                                "cast(isnull(RebatePct,0) as Decimal(25,1)) as RebatePct," +
                                "cast(isnull(LMTDSales_PctChng,0) as decimal(15,1)) as LMTDSales_PctChng," +
                                "cast(isnull(LYTDSales_PctChng,0) as decimal(15,1)) as LYTDSales_PctChng," +
                                "cast(isnull(LMTDPricePerLB_PctChng,0) as decimal(15,1)) as LMTDPricePerLB_PctChng," +
                                "cast(isnull(LYTDPricePerLB_PctChng,0) as decimal(15,1)) as LYTDPricePerLB_PctChng," +
                                "cast(isnull(MarginPctCorpAvg,0) as decimal(15,1)) as MarginPctCorpAvg," +
                                "cast(isnull(PricePerLBCorpAvg ,0) as decimal(15,2)) as PricePerLBCorpAvg ," +
                                "replace(round(isnull(OrdDolPerSoCorpAvg,0),0),'.0','') as OrdDolPerSoCorpAvg," +
                                "replace(round(isnull(OrdDolPerSOLineCorpAvg,0),0),'.0','') as OrdDolPerSOLineCorpAvg," +
                                "replace(convert(varchar,cast((cast(isnull(AgingTot,0) as bigint)) as money),1),'.00','') as AgingTot," +
                                "cast(isnull(AgingPctTot,0) as decimal(15,1)) as AgingPctTot," +
                                "replace(convert(varchar,cast((cast(isnull(CYTDDolMarginFY,0) as bigint)) as money),1),'.00','') as CYTDDolMarginFY," +
                                "replace(convert(varchar,cast((cast(isnull(CYTDDolMarginFM,0) as bigint)) as money),1),'.00','') as CYTDDolMarginFM," +
                                "replace(convert(varchar,cast((cast(isnull(LYTDDolMarginFY,0) as bigint)) as money),1),'.00','') as LYTDDolMarginFY," +
                                "replace(convert(varchar,cast((cast(isnull(LYTDDolMarginFM,0) as bigint)) as money),1),'.00','') as LYTDDolMarginFM," +
                                "replace(convert(varchar,cast((cast(isnull(CYTDExpenseFY,0) as bigint)) as money),1),'.00','') as CYTDExpenseFY," +
                                "replace(convert(varchar,cast((cast(isnull(CYTDExpenseFM,0) as bigint)) as money),1),'.00','') as CYTDExpenseFM," +
                                "replace(convert(varchar,cast((cast(isnull(LYTDExpenseFY,0) as bigint)) as money),1),'.00','') as LYTDExpenseFY," +
                                "replace(convert(varchar,cast((cast(isnull(LYTDExpenseFM,0) as bigint)) as money),1),'.00','') as LYTDExpenseFM," +
                                "replace(convert(varchar,cast((cast(isnull(CYTDProfitFY,0) as bigint)) as money),1),'.00','') as CYTDProfitFY," +
                                "replace(convert(varchar,cast((cast(isnull(CYTDProfitFM,0) as bigint)) as money),1),'.00','') as CYTDProfitFM," +
                                "replace(convert(varchar,cast((cast(isnull(LYTDProfitFY,0) as bigint)) as money),1),'.00','') as LYTDProfitFY," +
                                "replace(convert(varchar,cast((cast(isnull(LYTDProfitFM,0) as bigint)) as money),1),'.00','') as LYTDProfitFM," +
                                "CustProfile," +
                                "convert(decimal(10,1),CASE isnull(MTDSales,0) WHEN 0 THEN 0 ELSE  (isnull(CYTDDolMarginFM,0) / isnull(MTDSales,0)) * 100  END) as CYTDDolMarginPctFM," +
                                "convert(decimal(10,1),CASE isnull(LMTDSales,0) WHEN 0 THEN 0 ELSE  (isnull(LYTDDolMarginFM,0) / isnull(LMTDSales,0)) * 100  END) as LYTDDolMarginPctFM," +
                                "convert(decimal(10,1),CASE isnull(YTDSales,0) WHEN 0 THEN 0 ELSE  (isnull(CYTDDolMarginFY,0) / isnull(YTDSales,0)) * 100  END) as CYTDDolMarginPctFY," +
                                "convert(decimal(10,1),CASE isnull(LYTDSales,0) WHEN 0 THEN 0 ELSE  (isnull(LYTDDolMarginFY,0) / isnull(LYTDSales,0)) * 100  END) as LYTDDolMarginPctFY," +
                                "convert(decimal(10,1),CASE isnull(MTDOrd_OE,0) WHEN 0 THEN 0 ELSE  (cast(isnull(MTDLines_OE,0) as float) / cast(isnull(MTDOrd_OE,0) as float)) END) as CustCYTDLnPerOrdFM," +
                                "convert(decimal(10,1),CASE isnull(LMTDOrd_OE,0) WHEN 0 THEN 0 ELSE  (cast(isnull(LMTDLines_OE,0) as float) / cast(isnull(LMTDOrd_OE,0) as float)) END) as CustLYTDLnPerOrdFM," +
                                "convert(decimal(10,1),CASE isnull(YTDOrd_OE,0) WHEN 0 THEN 0 ELSE  (cast(isnull(YTDLines_OE,0) as float) / cast(isnull(YTDOrd_OE,0) as float)) END) as CustCYTDLnPerOrdFY," +
                                "convert(decimal(10,1),CASE isnull(LYTDOrd_OE,0) WHEN 0 THEN 0 ELSE  (cast(isnull(LYTDLines_OE,0) as float) / cast(isnull(LYTDOrd_OE,0) as float)) END) as CustLYTDLnPerOrdFY";

                                    

    DataTable dtCustomerData = new DataTable();

    #endregion
    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    /// 
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["PrintMode"] == null)
        {
            SystemCheck systemCheck = new SystemCheck();
            systemCheck.SessionCheck();
        }
        // Call the function to fill the customer details
        FillCAS();
        if (Session["DetailType"] == null)
            Session["DetailType"] = "PFC Employee";
    }

    #region Developer Code
    /// <summary>
    /// Function to fill the customer details
    /// </summary>
    public void FillCAS()
    {
        try
        {
            //Method used to form Where Condition
            GetWhereClause();

            SqlConnection cn = new SqlConnection(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString());
            try
            {
                cn.Open();
                SqlCommand cmd = new SqlCommand("Select " + strDisplayColumns + " From " + strTable + " where " + strWhere, cn);
                SqlDataAdapter dap = new SqlDataAdapter(cmd);
                dap.Fill(dtCustomerData);
                cn.Close();
            }
            catch (Exception ex) { if (cn.State == ConnectionState.Open)cn.Close(); }


            // Bind the datagrid with datatable
            dgCas.DataSource = dtCustomerData;
            dgCas.DataBind();

            // Display the info to the user when table contains no records
            lblStatus.Visible = (dgCas.Items.Count <= 0 ? true : false);

            // Store the customer name in the session variable
            if (dtCustomerData != null)
            {
                Session["CustomerName"] = (dtCustomerData.Rows.Count != 0) ? dtCustomerData.Rows[0]["CustName"].ToString() : "";

                // Display Corp line per order information
                DisplayCorpLinePerOrder();
            }

        }
        catch (Exception ex) { Response.Write(ex.ToString()); }
    }
    /// <summary>
    /// GetWhereClause :Method used to form Where Condition
    /// </summary>
    private void GetWhereClause()
    {
        if (Request.QueryString["CASMode"] == null)
        {
            if (Request.QueryString["Branch"].Trim() != "0")
                strWhere = "curmonth=" + Request.QueryString["Month"].Trim() + " and " +
                           "curYear=" + Request.QueryString["Year"].Trim() +
                           " and CustNo='" + Request.QueryString["CustNo"].Trim().Replace("||", "&") +
                           "' and BranchNo='" + Request.QueryString["Branch"].Trim() + "'";
            else
                strWhere = "curmonth=" + Request.QueryString["Month"].Trim() + " and " +
                               "curYear=" + Request.QueryString["Year"].Trim() +
                               " and CustNo='" + Request.QueryString["CustNo"].Trim().Replace("||", "&") + "'";
        }
        else
        {
            strWhere = "curmonth=" + Request.QueryString["Month"].Trim() + " and " +
                       "curYear=" + Request.QueryString["Year"].Trim() +
                       " and Chain='" + Request.QueryString["Chain"].Trim().Replace("||", "&") + "'";
            strTable = "CAS_ChainData";
        }
    }

    private void DisplayCorpLinePerOrder()
    {
        try
        {
            

        }
        catch (Exception ex) { }
        
    }
    #endregion

    protected void dgCas_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            DataSet dsCorpLine = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "pCASGetCorpOrderPerLine");
            
            Label _lblCorpCYTDLnPerOrdFM = e.Item.FindControl("lblCorpCYTDLnPerOrdFM") as Label;
            Label _lblCorpLYTDLnPerOrdFM = e.Item.FindControl("lblCorpLYTDLnPerOrdFM") as Label;
            Label _lblCorpCYTDLnPerOrdFY = e.Item.FindControl("lblCorpCYTDLnPerOrdFY") as Label;
            Label _lblCorpLYTDLnPerOrdFY = e.Item.FindControl("lblCorpLYTDLnPerOrdFY") as Label;

            _lblCorpCYTDLnPerOrdFM.Text = (dsCorpLine.Tables[0].Rows.Count >0 ? dsCorpLine.Tables[0].Rows[0]["CurFMLnPerOrd"].ToString() : "0.0");
            _lblCorpLYTDLnPerOrdFM.Text = (dsCorpLine.Tables[1].Rows.Count >0 ? dsCorpLine.Tables[1].Rows[0]["LastFMLnPerOrd"].ToString() : "0.0");
            _lblCorpCYTDLnPerOrdFY.Text = (dsCorpLine.Tables[2].Rows.Count >0 ? Math.Round(Convert.ToDecimal(dsCorpLine.Tables[2].Rows[0]["CurFYLnPerOrd"].ToString()),1).ToString() : "0.0");
            _lblCorpLYTDLnPerOrdFY.Text = (dsCorpLine.Tables[3].Rows.Count > 0 ? Math.Round(Convert.ToDecimal(dsCorpLine.Tables[3].Rows[0]["LastFYLnPerOrd"].ToString()), 1).ToString() : "0.0");
        }
    }
}
