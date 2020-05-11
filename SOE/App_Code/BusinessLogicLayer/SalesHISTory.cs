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
using PFC.SOE.DataAccessLayer;

/// <summary>
/// Summary description for SalesHistory
/// </summary>

namespace PFC.SOE.BusinessLogicLayer
{
    public class SalesHISTory
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string tableName = "";
        string columnName = "";
        string whereClause = "";

        public DataTable GetSalesHistory(string customerNumber, DateTime stdate,DateTime enddate )
        {
            try
            {

                //tableName = "CustomerSalesSummary";
                //columnName = "ItemNo,ItemDesc,CustomerItemNo,BaseUM,sum(SalesDollars)as [Period Sales],sum(QtyShipped)/Count(*) as PeriodAvgQty," +
                //            "QtyShipped, QtyShipped*TotalWeight as UsagePerLb ,LatestSalesPrice,(LatestSalesPrice/UnitWeight) as PricePerLb," +
                //            "(LatestSalesCost/UnitWeight) as CostPerLb ,(SalesDollars-SalesCost)/TotalWeight as GpPerLb";
                //whereClause = "CustomerNo='" + customerNumber + "'";

                DataSet dsSalesHist = SqlHelper.ExecuteDataset(ERPConnectionString, "[pSOESalesHistory]",
                                      new SqlParameter("@whereclause", customerNumber),
                                      new SqlParameter("@columnName", stdate),
                                      new SqlParameter("@columnName", enddate))
                                      ;

                return dsSalesHist.Tables[0];

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetCustomerDetails(string customerNumber)
        {
            try
            {
                DataSet dsSalesHist = SqlHelper.ExecuteDataset(ERPConnectionString, "[pSOECustomerDetails]",
                                      new SqlParameter("@whereclause", customerNumber));

                return dsSalesHist.Tables[0];

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        //public DataTable GetMonth()
        //{

        //    try
        //    {
        //        //tableName = "FiscalCalendar";
        //        //columnName = "FiscalYear";
        //        //whereClause = "1=1";

        //        DataSet dsMonth = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOMonth");
                                
        //        return dsMonth.Tables[0]; ;
        //    }
        //    catch (Exception ex)
        //    {
        //        return null;

        //    }
        //}

        public DataTable GetYear()
        {

            try
            {
                //tableName = "FiscalCalendar";
                //columnName = "FiscalMonth,FiscalYear";
                //whereClause = "1=1";

                DataSet dsYear = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOYear");
                                   //new SqlParameter("@tableName", tableName),
                                   //new SqlParameter("@columnName", columnName),
                                   //new SqlParameter("@whereClause", whereClause));
                return dsYear.Tables[0]; ;
            }
            catch (Exception ex)
            {
                return null;

            }
        }


        public DataTable ValidateCustomer(string customerNumber)
        {

            try
            {
                tableName = "CustomerMaster left outer join RepMaster on CustomerMaster.SlsRepNo = RepMaster.RepNo";
                columnName = "ContractNo,SlsRepNo,CustNo,RepName";
                whereClause = "CustNo='" + customerNumber.Trim() + "' or CustSearchKey='" + customerNumber.Trim() + "'";


                DataSet dsCustomer = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName",  tableName),
                                    new SqlParameter("@columnNames", columnName),
                                    new SqlParameter("@whereClause", whereClause));
                return dsCustomer.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet ExecuteSelectQuery(string tableName, string columnNames, string whereClause)
        {

            try
            {
                DataSet dsSelect = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                                 new SqlParameter("@tableName", tableName),
                                                 new SqlParameter("@columnNames", columnNames),
                                                 new SqlParameter("@whereClause", whereClause));
                return dsSelect;
            }
            catch (Exception ex)
            {

                return null;
            }


        }

        public string GetSalesRepName(string Number)
        {
            try
            {
                
                string _whereClause = "RepNo='" + Number + "'";
                string CustomerName = SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", "RepMaster"),
                                    new SqlParameter("@columnNames", "RepName"),
                                    new SqlParameter("@whereClause", _whereClause)).ToString();
                return CustomerName;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public string GetSalesRepNo(string custNumber)
        {
            try
            {

                string _whereClause = "CustNo='" + custNumber + "'";
                string CustomerName = SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", "CustomerMaster"),
                                    new SqlParameter("@columnNames", "SlsRepNo"),
                                    new SqlParameter("@whereClause", _whereClause)).ToString();
                return CustomerName;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        

    }
    
}