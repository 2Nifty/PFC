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

namespace PFC.Intranet.eCommerceReportV2
{
    public class eCommerceReportV2
    {
        string csQuotes = ConfigurationManager.AppSettings["QuotesSystemConnectionString"].ToString();
        string csERP = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string csReports = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();

        #region Get Quote & Order Data
        //[pQuoteAndOrderV2] returns the QUOTE & ORDER Data for eCommerceSalesAnalysisCustRpt (based on the filters set from eCommerceSalesAnalysisUserPrompt)
        //TMD - 09/22/11 - Changed to run from ERP
        public DataTable GetQuoteAndOrderData(string PeriodMonth, string PeriodYear, string startDate, string endDate, string locationCode, string CustomerNo, string repNo, string PriceCdCtl, string orderSource, string itemNotOrd)
        {
//            try
//            {
                DataSet dseCommerceAnalysisData = new DataSet();
                DataTable dtResult = new DataTable();
                dseCommerceAnalysisData = SqlHelper.ExecuteDataset(csERP, "pQuoteAndOrderV2",
                                    new SqlParameter("@PeriodMonth", PeriodMonth),
                                    new SqlParameter("@PeriodYear", PeriodYear),
                                    new SqlParameter("@StartDate", startDate),
                                    new SqlParameter("@EndDate", endDate),
                                    new SqlParameter("@LocationCode", locationCode),
                                    new SqlParameter("@CustNo", CustomerNo),
                                    new SqlParameter("@PriceCdCtl", PriceCdCtl),
                                    new SqlParameter("@OrderSource", orderSource),
                                    new SqlParameter("@ItemNotOrdFlg", itemNotOrd));
                if (dseCommerceAnalysisData != null)
                {
                    DataTable dtCustomerMaster = GetCustomerName(dseCommerceAnalysisData.Tables[0]);
                    dtResult = CustomerNoAndNameJoins(dseCommerceAnalysisData.Tables[0], dtCustomerMaster);

                    // Do RepName (CSR) filter
                    if (repNo != "")
                    {
                        dtResult.DefaultView.RowFilter = "RepNo='" + repNo + "'";
                        dtResult = dtResult.DefaultView.ToTable();
                    }
                }
                return dtResult;
//            }
//            catch (Exception ex)
//            {
//                return null;
//            }
        }

        //[pQuoteAndOrderHdrV2] returns the Header data from ERP
        public DataSet GetHdrData(string PeriodMonth, string PeriodYear, string startDate, string endDate, string locationCode, string CustomerNo, string orderSource, string sourceType, string itemNotOrd)
        {
//            try
//            {
                DataSet dseCommerceAnalysisData = new DataSet();
                dseCommerceAnalysisData = SqlHelper.ExecuteDataset(csERP, "pQuoteAndOrderHdrV2",
                                    new SqlParameter("@PeriodMonth", PeriodMonth),
                                    new SqlParameter("@PeriodYear", PeriodYear),
                                    new SqlParameter("@StartDate", startDate),
                                    new SqlParameter("@EndDate", endDate),
                                    new SqlParameter("@LocationCode", locationCode),
                                    new SqlParameter("@CustNo", CustomerNo),
                                    new SqlParameter("@OrderSource", orderSource),
                                    new SqlParameter("@SourceType", sourceType),
                                    new SqlParameter("@ItemNotOrdFlg", itemNotOrd));
                return dseCommerceAnalysisData;
//            }
//            catch (Exception ex)
//            {
//                return null;
//            }
        }

        //[pQuoteAndOrderDtlV2] returns the Detail data from ERP
        public DataSet GetDtlData(string PeriodMonth, string PeriodYear, string startDate, string endDate, string locationCode, string CustomerNo, string orderSource, string sourceType, string itemNotOrd, string quoteNumber)
        {
//            try
//            {
                DataSet dseCommerceAnalysisData = new DataSet();
                dseCommerceAnalysisData = SqlHelper.ExecuteDataset(csERP, "pQuoteAndOrderDtlV2",
                                    new SqlParameter("@PeriodMonth", PeriodMonth),
                                    new SqlParameter("@PeriodYear", PeriodYear),
                                    new SqlParameter("@StartDate", startDate),
                                    new SqlParameter("@EndDate", endDate),
                                    new SqlParameter("@LocationCode", locationCode),
                                    new SqlParameter("@CustNo", CustomerNo),
                                    new SqlParameter("@OrderSource", orderSource),
                                    new SqlParameter("@SourceType", sourceType),
                                    new SqlParameter("@ItemNotOrdFlg", itemNotOrd),
                                    new SqlParameter("@QuoteNumber", quoteNumber));
                return dseCommerceAnalysisData;
//            }
//            catch (Exception ex)
//            {
//                return null;
//            }
        }
        #endregion

        #region Avg Cost Joins
        #region Quotes
        public DataTable GetAverageCost(DataTable dtMasterRecord)
        {
            string brIDs = "";
            DataView dv = dtMasterRecord.DefaultView;
            string[] distinct = { "SalesBranchofRecord" };

            DataTable tbl = dv.ToTable(true, distinct);
            foreach (DataRow dr in tbl.Rows)
                brIDs += ",'" + dr[0].ToString() + "'";

            if (brIDs != string.Empty)
                brIDs = brIDs.Remove(0, 1);

            string _tableName = "itemBranch IB,itemmaster IM";
            string _columnName = "IB.AvgCost,IB.Location,IM.itemno";
            string _whereClause = "IB.fItemmasterId = IM.pItemmasterId and IB.Location in (" + brIDs + ")";

            DataSet dsCustomers = (DataSet)SqlHelper.ExecuteDataset(csReports, "UGEN_SP_Select",
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnName),
                                                       new SqlParameter("@whereClause", _whereClause));
            return dsCustomers.Tables[0];
        }
    
        public DataTable AverageCostJoins(DataTable dtQuoteAnalysis, DataTable dtAverageCost)
        {
//            try
//            {
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
//            }
//            catch (Exception ex)
//            {
//                return null;
//            }
        }
        #endregion

        #region Orders
        public DataTable GetOrderAverageCost(DataTable dtOrder)
        {
            string brIDs = "";
            DataView dv = dtOrder.DefaultView;
            //DataTable tbl = dv.ToTable(true, "SalesLocationCode");
            DataTable tbl = dv.ToTable(true, "SalesBranchofRecord");
            foreach (DataRow dr in tbl.Rows)
                brIDs += ",'" + dr[0].ToString() + "'";

            if (brIDs != string.Empty)
                brIDs = brIDs.Remove(0, 1);

            string _tableName = "itemBranch IB,itemmaster IM";
            string _columnName = "IB.AvgCost,IB.Location,IM.itemno";
            string _whereClause = "IB.fItemmasterId = IM.pItemmasterId and IB.Location in (" + brIDs + ")";

            DataSet dsCustomers = (DataSet)SqlHelper.ExecuteDataset(csReports, "UGEN_SP_Select",
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnName),
                                                       new SqlParameter("@whereClause", _whereClause));
            return dsCustomers.Tables[0];
        }
        
        public DataTable OrderAverageCostJoins(DataTable dtQuoteAnalysis, DataTable dtAverageCost)
        {
//            try
//            {
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
                    //new DataColumn[] { dsFinalResult.Tables["QuoteAnalysis"].Columns["PFCItemNo"], dsFinalResult.Tables["QuoteAnalysis"].Columns["SalesLocationCode"] },
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
//            }
//            catch (Exception ex)
//            {
//                return null;
//            }
        }
        #endregion
        #endregion

        #region Get Customer Info
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
                dtCustName = SqlHelper.ExecuteDataset(csERP, "[pSOESelect]",
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
                dsCSR = SqlHelper.ExecuteDataset(csERP, "pGetCSRs",
                                    new SqlParameter("@branchID", branchID));

                return dsCSR;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        #endregion
    }
}