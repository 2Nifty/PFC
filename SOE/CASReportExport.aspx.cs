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
using PFC.SOE.DataAccessLayer;

public partial class CASReport : System.Web.UI.Page
{

    #region variable declaration
    string connectionString = ConfigurationManager.AppSettings["PFCReportConnectionString"].ToString();
    string strTable = "CAS_CustomerData";
    string strWhere = string.Empty;
    protected string AgingCur, Aging30, Aging60, AgingOver90, AgingTot, Aging30Pct, Aging60Pct, Aging90Pct, AgingCurPct, AgingPctTot = "";
    protected string branchNo, curYear, curMonth, custNo, monthname = "";

    string strDisplayColumns = "CurYear, CurMonth, CustNo, CustName, CustAddress, CustCity, CustState, CustZip, CustPhone,YTDCustRank," +
                                "CustFax,CustContact, Chain, Terms, DSO,InsideSls, SalesPerson, BuyGrp, SalesRep, HubSatellites, MTDCustRank," +
                                "LMTDCustRank,MTDShipPattern,LYTDCustRank,CustType, BranchNo, BranchDesc,LMTDShipPattern,CreditLimit," +
                                "KeyCustRebate,AnnualRebate," +
                                "replace(convert(varchar,cast((cast(isnull(MTDSales,0) as bigint)) as money),1),'.00','') as MTDSales," +
                                "replace(convert(varchar,cast((cast(isnull(YTDSales,0) as bigint)) as money),1),'.00','') as YTDSales," +
                                "replace(convert(varchar,cast((cast(isnull(LMTDSales,0) as bigint)) as money),1),'.00','') as LMTDSales," +
                                "replace(convert(varchar,cast((cast(isnull(LYTDSales,0) as bigint)) as money),1),'.00','') as LYTDSales," +
                                "cast(isnull(MTDGMPct,0) as decimal(25,1)) as MTDGMPct,cast(isnull(YTDGMPct,0) as decimal(25,1)) as YTDGMPct," +
                                "cast(isnull(LMTDGMPct,0) as decimal(25,1)) as LMTDGMPct,cast(isnull(LYTDGMPct,0) as decimal(25,1)) as LYTDGMPct," +
                                "cast(isnull(MTDGM,0) as bigint) as MTDGM,cast(isnull(YTDGM,0) as bigint) as YTDGM," +
                                "cast(isnull(LMTDGM,0) as bigint) as LMTDGM,cast(isnull(LYTDGM,0) as bigint) as LYTDGM," +
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
                                "cast(isnull(MarginPctCorpAvg,0) as decimal(15,1)) as MarginPctCorpAvg," +
                                "cast(isnull(PricePerLBCorpAvg ,0) as decimal(15,2)) as PricePerLBCorpAvg ," +
                                "replace(round(isnull(OrdDolPerSoCorpAvg,0),0),'.0','') as OrdDolPerSoCorpAvg," +
                                "replace(round(isnull(OrdDolPerSOLineCorpAvg,0),0),'.0','') as OrdDolPerSOLineCorpAvg," +
                                "replace(convert(varchar,cast((cast(isnull(AgingTot,0) as bigint)) as money),1),'.00','') as AgingTot," +
                                "cast(isnull(AgingPctTot,0) as decimal(15,1)) as AgingPctTot," +
                                "CustProfile" ;


    DataTable dtCustomerData = new DataTable();

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        custNo = Request.QueryString["CustNo"].ToString();
        
        //Method used to form Where Condition
        GetWhereClause();

        if (!Page.IsPostBack)
        {            
            GetWhereClause();
            FillCAS();

            
        }
    }

    protected void dgSalesDetails_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            if (e.Item.Cells[0].Text == "TOTALS")
            {
                for (int i = 0; i <= 9; i++)
                {
                    e.Item.Cells[i].HorizontalAlign = (i == 0) ? HorizontalAlign.Left : HorizontalAlign.Right;
                    e.Item.Cells[i].Font.Bold = true;
                    e.Item.Cells[8].Text = "&nbsp;";
                }
            }
        }
    }

    protected void rbtnlCustType_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rbtnlCustType.Items[0].Selected)
        {
            dgSalesDetails.Columns[2].Visible = false;
            dgSalesDetails.Columns[4].Visible = false;
            dgSalesDetails.Columns[5].Visible = false;
            dgSalesDetails.Columns[7].Visible = false;
            dgSalesDetails.Columns[9].Visible = false;
            Session["CustomerType"] = "";
        }
        else
        {
            dgSalesDetails.Columns[2].Visible = true;
            dgSalesDetails.Columns[4].Visible = true;
            dgSalesDetails.Columns[5].Visible = true;
            dgSalesDetails.Columns[7].Visible = true;
            dgSalesDetails.Columns[9].Visible = true;
            Session["CustomerType"] = "PFC Employee";
        }
    }

    public void FillCAS()
    {
        try
        {
            SqlConnection cn = new SqlConnection(connectionString);
            try
            {
                cn.Open();
                SqlCommand cmd = new SqlCommand("Select " + strDisplayColumns + " From " + strTable + " NOLOCK where " + strWhere, cn);
                SqlDataAdapter dap = new SqlDataAdapter(cmd);
                dap.Fill(dtCustomerData);
                cn.Close();

                FillCustomerAging();
            }
            catch (Exception ex) { if (cn.State == ConnectionState.Open)cn.Close(); }

            if (dtCustomerData != null && dtCustomerData.Rows.Count > 0)
            {
                // Bind the datagrid with datatable
                dgCas.DataSource = dtCustomerData;
                dgCas.DataBind();
                BindTop5Category();
                lblCustName.Text = dtCustomerData.Rows[0]["CustName"].ToString();

                // Display the info to the user when table contains no records
                lblStatus.Visible = (dgCas.Items.Count <= 0 ? true : false);

                // Store the customer name in the session variable
                if (dtCustomerData != null)
                {
                    Session["CustomerName"] = (dtCustomerData.Rows.Count != 0) ? dtCustomerData.Rows[0]["CustName"].ToString() : "";
                }
            }
            else
            {
                // Display the info to the user when table contains no records
                lblStatus.Visible = true;
                tblControls.Visible = false;
            }

        }
        catch (Exception ex) { Response.Write(ex.ToString()); }
    }


    private void FillCustomerAging()
    {
        DataSet dsARAgingData = SqlHelper.ExecuteDataset(connectionString, "pSOEReturnCustomerAging",
                                new SqlParameter("@billToCustNo", custNo));
        if (dsARAgingData != null && dsARAgingData.Tables[0].Rows.Count > 0)
        {
            AgingCur = dsARAgingData.Tables[0].Rows[0]["Current"].ToString() != "" ? String.Format("{0:#,##0}", Convert.ToDecimal(dsARAgingData.Tables[0].Rows[0]["Current"].ToString())) : "0";
            Aging30 = dsARAgingData.Tables[0].Rows[0]["Over 30"].ToString() != "" ? String.Format("{0:#,##0}", Convert.ToDecimal(dsARAgingData.Tables[0].Rows[0]["Over 30"].ToString())) : "0";
            Aging60 = dsARAgingData.Tables[0].Rows[0]["Over 60"].ToString() != "" ? String.Format("{0:#,##0}", Convert.ToDecimal(dsARAgingData.Tables[0].Rows[0]["Over 60"].ToString())) : "0";
            AgingOver90 = dsARAgingData.Tables[0].Rows[0]["Over 90"].ToString() != "" ? String.Format("{0:#,##0}", Convert.ToDecimal(dsARAgingData.Tables[0].Rows[0]["Over 90"].ToString())) : "0";
            AgingTot = dsARAgingData.Tables[0].Rows[0]["Total Due"].ToString() != "" ? String.Format("{0:#,##0}", Convert.ToDecimal(dsARAgingData.Tables[0].Rows[0]["Total Due"].ToString())) : "0";
            Aging30Pct = dsARAgingData.Tables[0].Rows[0]["Over30Pct"].ToString() != "" ? String.Format("{0:#,##0.0}", Convert.ToDecimal(dsARAgingData.Tables[0].Rows[0]["Over30Pct"].ToString())) : "0.0";
            Aging60Pct = dsARAgingData.Tables[0].Rows[0]["Over60Pct"].ToString() != "" ? String.Format("{0:#,##0.0}", Convert.ToDecimal(dsARAgingData.Tables[0].Rows[0]["Over60Pct"].ToString())) : "0.0";
            Aging90Pct = dsARAgingData.Tables[0].Rows[0]["Over90Pct"].ToString() != "" ? String.Format("{0:#,##0.0}", Convert.ToDecimal(dsARAgingData.Tables[0].Rows[0]["Over90Pct"].ToString())) : "0.0";
            AgingCurPct = dsARAgingData.Tables[0].Rows[0]["CurrPct"].ToString() != "" ? String.Format("{0:#,##0.0}", Convert.ToDecimal(dsARAgingData.Tables[0].Rows[0]["CurrPct"].ToString())) : "0.0";
            //AgingPctTot = dsARAgingData.Tables[0].Rows[0]["Total Due"].ToString() != "" ? String.Format("{0:#,##0.0}", Convert.ToDecimal(dsARAgingData.Tables[0].Rows[0]["Total Due"].ToString())) : "0.0"; ; ;
            AgingPctTot = "100.0";
        }
    }

    private void BindTop5Category()
    {
        try
        {

            DataSet dsCategories = GetCategorySalesData(curMonth, curYear, custNo);
            if (dsCategories != null)
            {
                if (dsCategories.Tables[0].Rows.Count > 0)
                {
                    dgSalesDetails.DataSource = dsCategories.Tables[0];
                    dgSalesDetails.DataBind();
                    lblStatus.Visible = false;
                }
                else
                {
                    dgSalesDetails.Visible = false;
                    lblStatus.Visible = true;
                }
            }
            else
            {
                dgSalesDetails.Visible = false;
                lblStatus.Text = "No Record Found";
                lblStatus.Visible = true;
            }


        }
        catch (Exception ex)
        {
            throw;
        }
    }

    private void GetWhereClause()
    {
        string _tableName = "CuvnalRanges";
        string _columnName = "MonthValue,YearValue";
        string _whereClause = "CuvnalParameter='CurrentMonth'";

        DataSet dsFicalPeriod = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                            new SqlParameter("@tableName", _tableName),
                            new SqlParameter("@columnNames", _columnName),
                            new SqlParameter("@whereClause", _whereClause));

        curYear = dsFicalPeriod.Tables[0].Rows[0]["YearValue"].ToString();
        curMonth = dsFicalPeriod.Tables[0].Rows[0]["MonthValue"].ToString();

        strWhere = "curmonth=" + dsFicalPeriod.Tables[0].Rows[0]["MonthValue"].ToString() +
                   " and curYear=" + dsFicalPeriod.Tables[0].Rows[0]["YearValue"].ToString() +
                   " and CustNo='" + custNo + "'";

        int monthNumber = Convert.ToInt32(curMonth);
        string[] myMonthsList = System.Globalization.CultureInfo.CurrentCulture.DateTimeFormat.MonthNames;
        monthname = (myMonthsList[monthNumber - 1]);
    }

    public DataSet GetCategorySalesData(string strMonth, string strYear, string strCustNo)
    {
        try
        {
            DataSet dsCategoryInfo = SqlHelper.ExecuteDataset(connectionString, "[PFC_SP_CASCategories]",
                  new SqlParameter("@PeriodMonth", strMonth),
                  new SqlParameter("@PeriodYear", strYear),
                  new SqlParameter("@Branch", ""),
                  new SqlParameter("@CustNo", strCustNo));

            return dsCategoryInfo;
        }
        catch (Exception ex)
        {
            return null;
        }
    }
}
