using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using PFC.Intranet.DataAccessLayer;

namespace PFC.Intranet.eCommerceReport
{
    /// <summary>
    /// Summary description for ROISalesReport
    /// </summary>
    public class eCommerceReport
    {
        //
        // Global Variables Declaration
        //
        string connectionString = ConfigurationManager.AppSettings["QuotesSystemConnectionString"].ToString();
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string NavisioConnectionString = ConfigurationManager.AppSettings["NVConnectionString"].ToString();

        public DataTable GetQuote2OrderData(string PeriodMonth,string PeriodYear,string startDate,string endDate,string locationCode,string CustomerNo,string repNo,string PriceCdCtl)                                                   
        {
            try
            {
                DataSet dseCommerceAnalysisData = new DataSet();
                DataTable dtResult = new DataTable();

                dseCommerceAnalysisData = SqlHelper.ExecuteDataset(connectionString, "pQuoteAndOrder",
                                    new SqlParameter("@PeriodMonth", PeriodMonth),
                                    new SqlParameter("@PeriodYear", PeriodYear),
                                    new SqlParameter("@StartDate", startDate),
                                    new SqlParameter("@EndDate", endDate),
                                    new SqlParameter("@LocationCode", locationCode),
                                    new SqlParameter("@CustNo", CustomerNo),
                                    new SqlParameter("@PriceCdCtl", PriceCdCtl));
                if (dseCommerceAnalysisData != null)
                {
                    DataTable dtCustomerMaster = GetCustomerName(dseCommerceAnalysisData.Tables[0]);
                    dtResult = CustomerNoAndNameJoins(dseCommerceAnalysisData.Tables[0], dtCustomerMaster);

                    // Do Repname filter
                    if (repNo != "")
                    {
                        dtResult.DefaultView.RowFilter = "RepNo='" + repNo + "'";
                        dtResult = dtResult.DefaultView.ToTable();
                    }
                }

                return dtResult;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetQuoteData(string PeriodMonth, string PeriodYear,string startDate,string endDate,string locationCode, string CustomerNo)
        {
            try
            {
                DataSet dseCommerceAnalysisData = new DataSet();
                dseCommerceAnalysisData = SqlHelper.ExecuteDataset(connectionString, "pQuoteAnalysis",
                                    new SqlParameter("@PeriodMonth", PeriodMonth),
                                    new SqlParameter("@PeriodYear", PeriodYear),
                                    new SqlParameter("@StartDate", startDate),
                                    new SqlParameter("@EndDate", endDate),
                                    new SqlParameter("@LocationCode", locationCode),
                                    new SqlParameter("@CustNo", CustomerNo));
                return dseCommerceAnalysisData;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetOrderData(string PeriodMonth, string PeriodYear,string startDate,string endDate,string locationCode, string CustomerNo)
        {
            try
            {
                DataSet dseCommerceAnalysisData = new DataSet();
                dseCommerceAnalysisData = SqlHelper.ExecuteDataset(connectionString, "pOrderAnalysis",
                                    new SqlParameter("@PeriodMonth", PeriodMonth),
                                    new SqlParameter("@PeriodYear", PeriodYear),
                                    new SqlParameter("@StartDate", startDate),
                                    new SqlParameter("@EndDate", endDate),
                                    new SqlParameter("@LocationCode", locationCode),
                                    new SqlParameter("@CustNo", CustomerNo));

                return dseCommerceAnalysisData;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable AverageCostJoins(DataTable dtQuoteAnalysis, DataTable dtAverageCost)
        {
            try
            {
                DataSet dsFinalResult = new DataSet();
                dtQuoteAnalysis.TableName = "QuoteAnalysis"; // Master
                dtAverageCost.TableName = "AverageCost";

                DataColumn dcAvgCost = new DataColumn("AvgCost", typeof(decimal));
                dcAvgCost.DefaultValue = "0";
                dtQuoteAnalysis.Columns.Add(dcAvgCost); // Br
                dsFinalResult.Tables.Add(dtQuoteAnalysis.Copy());
                dsFinalResult.Tables.Add(dtAverageCost.Copy());

                DataRelation customerNumberRelation =
                dsFinalResult.Relations.Add("Avg",
                new DataColumn[] { dsFinalResult.Tables["QuoteAnalysis"].Columns["PFCItemNo"], dsFinalResult.Tables["QuoteAnalysis"].Columns["SalesBranchofRecord"] },
                new DataColumn[] { dsFinalResult.Tables["AverageCost"].Columns["ItemNo"], dsFinalResult.Tables["AverageCost"].Columns["Location"] }, false);

                foreach (DataRow pfcBranchRow in dsFinalResult.Tables["QuoteAnalysis"].Rows)
                {
                    foreach (DataRow AvgCostRow in pfcBranchRow.GetChildRows(customerNumberRelation))
                    {
                        pfcBranchRow["AvgCost"] = AvgCostRow["AvgCost"].ToString();
                    }
                }

                return dsFinalResult.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable OrderAverageCostJoins(DataTable dtQuoteAnalysis, DataTable dtAverageCost)
        {
            try
            {
                DataSet dsFinalResult = new DataSet();
                dtQuoteAnalysis.TableName = "QuoteAnalysis"; // Master
                dtAverageCost.TableName = "AverageCost";

                DataColumn dcAvgCost = new DataColumn("AvgCost", typeof(decimal));
                dcAvgCost.DefaultValue = "0";
                dtQuoteAnalysis.Columns.Add(dcAvgCost); // Br
                dsFinalResult.Tables.Add(dtQuoteAnalysis.Copy());
                dsFinalResult.Tables.Add(dtAverageCost.Copy());

                DataRelation customerNumberRelation =
                dsFinalResult.Relations.Add("Avg",
                new DataColumn[] { dsFinalResult.Tables["QuoteAnalysis"].Columns["PFCItemNo"], dsFinalResult.Tables["QuoteAnalysis"].Columns["SalesLocationCode"] },
                new DataColumn[] { dsFinalResult.Tables["AverageCost"].Columns["ItemNo"], dsFinalResult.Tables["AverageCost"].Columns["Location"] }, false);

                foreach (DataRow pfcBranchRow in dsFinalResult.Tables["QuoteAnalysis"].Rows)
                {
                    foreach (DataRow AvgCostRow in pfcBranchRow.GetChildRows(customerNumberRelation))
                    {
                        pfcBranchRow["AvgCost"] = AvgCostRow["AvgCost"].ToString();
                    }
                }

                return dsFinalResult.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
  
        private DataTable GetCustomerName(DataTable dtQuoteData)
        {
            try
            {
                DataTable dtQuote = dtQuoteData.DefaultView.ToTable(true, "customerNumber");
                int _count = dtQuote.Rows.Count;
                int _roundTripCount = ((_count % 100 == 0) ? _count / 100 : ((_count / 100) + 1));

                DataSet dtCustName;

                string pfcCustNoCSV = Utility.Utility.ConvertColumnvaluesToCSV(dtQuote, "customerNumber");

                dtCustName = new DataSet();
                dtCustName = SqlHelper.ExecuteDataset(ERPConnectionString, "[pSOESelect]",
                                new SqlParameter("@tableName", "CustomerMaster"),
                                new SqlParameter("@columnNames", "CustNo,CustName,SupportRepNo"),
                                new SqlParameter("@whereCondition", "CustNo in (" + pfcCustNoCSV + ")"));
                    
                return dtCustName.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable CustomerNoAndNameJoins(DataTable dtOrderData, DataTable dtCustomerMaster)
        {
            try
            {
                DataSet dsFinalResult = new DataSet();
                dtOrderData.TableName = "QuoteAnalysis"; // Master
                dtCustomerMaster.TableName = "CustomerMaster";

                DataColumn dcCustName = new DataColumn("CustomerName", typeof(string));
                DataColumn dcRepNo = new DataColumn("RepNo", typeof(string));
                dcCustName.DefaultValue = "0";
                dtOrderData.Columns.Add(dcCustName); // Br
                dtOrderData.Columns.Add(dcRepNo); // rep no
                dsFinalResult.Tables.Add(dtOrderData.Copy());
                dsFinalResult.Tables.Add(dtCustomerMaster.Copy());

                DataRelation customerNumberRelation =
                dsFinalResult.Relations.Add("CustomerName",
                new DataColumn[] { dsFinalResult.Tables["QuoteAnalysis"].Columns["customerNumber"] },
                new DataColumn[] { dsFinalResult.Tables["CustomerMaster"].Columns["CustNo"] }, false);

                foreach (DataRow pfcBranchRow in dsFinalResult.Tables["QuoteAnalysis"].Rows)
                {
                    foreach (DataRow CustNameRow in pfcBranchRow.GetChildRows(customerNumberRelation))
                    {
                        pfcBranchRow["CustomerName"] = CustNameRow["CustName"].ToString();
                        pfcBranchRow["RepNo"] = CustNameRow["SupportRepNo"].ToString();
                    }
                }

                return dsFinalResult.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetCSRNames(string branchID)
        {
            try
            {
                DataSet dsCSR = new DataSet();
                dsCSR = SqlHelper.ExecuteDataset(ERPConnectionString, "pGetCSRs",
                                    new SqlParameter("@branchID", branchID));

                return dsCSR;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}