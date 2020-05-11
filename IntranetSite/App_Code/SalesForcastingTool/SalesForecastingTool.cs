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
using PFC.Intranet.BusinessLogicLayer;

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for CarrierCode
    /// </summary>
    public class SalesForecastingTool
    {
        //For Security Code
        string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
        string whereClause = string.Empty;


        public DataTable GetCASHeaderRecord(string BranchID)
        {

            try
            {
                DataSet dsCasHeader = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                            new SqlParameter("@tableName", "vSlsFrcstCustSelectHead"),
                                            new SqlParameter("@columnNames", "*"),
                                            new SqlParameter("@whereClause", "CustNo='Branch-" + BranchID.Trim() + "'"));

                return dsCasHeader.Tables[0];
            }
            catch (Exception ex)
            {

                return null;
            }

        }
        public DataTable GetCustomerRecord(string custID)
        {

            try
            {
                DataSet dsCasHeader = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                            new SqlParameter("@tableName", "vSlsFrcstCustSelectHead"),
                                            new SqlParameter("@columnNames", "*"),
                                            new SqlParameter("@whereClause", "CustNo='" + custID.Trim() + "'"));

                return dsCasHeader.Tables[0];
            }
            catch (Exception ex)
            {

                return null;
            }

        }

        public DataSet GetCustomerSalesData(string BranchID, string orderType, string sortExpression)
        {

            try
            {
                string viewName = "vSlsFrcstCustSelectWhse";

                if (orderType == "m")
                    viewName = "vSlsFrcstCustSelectMill";

                DataSet dsCasHeader = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                            new SqlParameter("@tableName", viewName),
                                            new SqlParameter("@columnNames", "*"),
                                            new SqlParameter("@whereClause", "SalesLoc='" + BranchID.Trim() + "' " + sortExpression));

                return dsCasHeader;
            }
            catch (Exception ex)
            {

                return null;
            }

        }

        public DataTable GetExistingCustomerList(string location, string orderType)
        {
            try
            {
                whereClause = "Location ='" + location + "' and OrderType='" + orderType + "'";
                DataSet dsExistingData = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                            new SqlParameter("@tableName", "SalesForecastCustList"),
                                            new SqlParameter("@columnNames", "*"),
                                            new SqlParameter("@whereClause", whereClause));

                return dsExistingData.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public void InsertCustomerForecastData(string location, string customer, string orderType)
        {
            try
            {
                //
                // if any data exist for this combination,delete first and write the new record
                //
                whereClause = "Location ='" + location + "' and Customer='" + customer + "' and OrderType='" + orderType + "'";
                SqlHelper.ExecuteNonQuery(connectionString, "UGEN_SP_Delete",
                                             new SqlParameter("@tableName", "SalesForecastCustList"),
                                             new SqlParameter("@whereClause", whereClause));
                //
                // write new record
                //
                string columnValues = "'" + location + "','" + customer + "','" + orderType + "','" +
                                            HttpContext.Current.Session["UserName"].ToString() + "','" + DateTime.Now.ToString() + "'";

                SqlHelper.ExecuteDataset(connectionString, "[ugen_sp_insert]",
                                 new SqlParameter("@tableName", "SalesForecastCustList"),
                                 new SqlParameter("@columnNames", "Location,Customer,OrderType,EntryID,EntryDt"),
                                 new SqlParameter("@columnValues", columnValues));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateCustomerSalesForecastData(string columnValues, string branchID, string orderType, string custNumber, string whereClause)
        {
            try
            {
                string whereCondition = "Location='" + branchID + "' and Customer ='" + custNumber + "' and OrderType='" + orderType + "' and " + whereClause;

                SqlHelper.ExecuteNonQuery(connectionString, "[ugen_sp_update]",
                             new SqlParameter("@tableName", "SalesForecastPounds"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public void DeleteCustomerForecastData(string location, string customer, string orderType)
        {
            try
            {
                //
                // if any data exist for this combination,delete first and write the new record
                //
                whereClause = "Location ='" + location + "' and Customer='" + customer + "' and OrderType='" + orderType + "'";
                SqlHelper.ExecuteNonQuery(connectionString, "UGEN_SP_Delete",
                                             new SqlParameter("@tableName", "SalesForecastCustList"),
                                             new SqlParameter("@whereClause", whereClause));

            }
            catch (Exception ex)
            {

                throw ex;
            }

        }

        public void ClearAllForecastData(string location, string orderType)
        {
            try
            {
                whereClause = "Location ='" + location + "' and OrderType='" + orderType + "'";

                SqlHelper.ExecuteNonQuery(connectionString, "UGEN_SP_Delete",
                                             new SqlParameter("@tableName", "SalesForecastCustList"),
                                             new SqlParameter("@whereClause", whereClause));

                SqlHelper.ExecuteNonQuery(connectionString, "UGEN_SP_Delete",
                                             new SqlParameter("@tableName", "SalesForecastPounds"),
                                             new SqlParameter("@whereClause", whereClause));

            }
            catch (Exception ex)
            {

                throw ex;
            }

        }

        public void UpdateCustomerList(string location, string orderType)
        {
            try
            {
                whereClause = "Location ='" + location + "' and OrderType='" + orderType + "'";

                SqlHelper.ExecuteNonQuery(connectionString, "[ugen_sp_update]",
                             new SqlParameter("@tableName", "SalesForecastCustList"),
                             new SqlParameter("@columnNames", "AcceptDt='" + DateTime.Now.ToString() + "'"),
                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {

            }
        }

        public DataSet GetBranchSummary(string BranchID, string sortExpression)
        {
		string columnName = "Location,Customer,Customer+ ' (' + rtrim(OrderType) + ')' as  CustOrdDesc,CustomerName,OrderType," +
                                "round(isnull(sum(Q1ActualLbs),0),0) as Q1ActualLbs,round(isnull(sum(Q2ActualLbs),0),0) as Q2ActualLbs,round(isnull(sum(Q3ActualLbs),0),0) as Q3ActualLbs,round(isnull(sum(Q4ActualLbs),0),0) as Q4ActualLbs," +
                                "round(isnull(sum(Q1ForecastLbs),0),0) as Q1ForecastLbs,round(isnull(sum(Q2ForecastLbs),0),0) as Q2ForecastLbs,round(isnull(sum(Q3ForecastLbs),0),0) as Q3ForecastLbs,round(isnull(sum(Q4ForecastLbs),0),0) as Q4ForecastLbs," +
                                "round(isnull(sum(Q1ActualLbs+Q2ActualLbs+Q3ActualLbs+Q4ActualLbs),0),0) as AnnualActualLbs," +
                                "round(sum(isnull(Q1ForecastLbs,0)+isnull(Q2ForecastLbs,0)+isnull(Q3ForecastLbs,0)+isnull(Q4ForecastLbs,0)),0) as AnnualForecastLbs," +
                                "case sum(Q1ActualLbs+Q2ActualLbs+Q3ActualLbs+Q4ActualLbs ) when 0 then 0 " +
                                "else  case(sum(isnull(((isnull(Q1ForecastLbs,0)+isnull(Q2ForecastLbs,0)+isnull(Q3ForecastLbs,0)+isnull(Q4ForecastLbs,0)) -  (Q1ActualLbs+Q2ActualLbs+Q3ActualLbs+Q4ActualLbs )),0)) / sum((Q1ActualLbs+Q2ActualLbs+Q3ActualLbs+Q4ActualLbs )) * 100 ) when -100 then 0 " +
                                "else sum(isnull(((isnull(Q1ForecastLbs,0)+isnull(Q2ForecastLbs,0)+isnull(Q3ForecastLbs,0)+isnull(Q4ForecastLbs,0)) -  (Q1ActualLbs+Q2ActualLbs+Q3ActualLbs+Q4ActualLbs )),0)) / sum((Q1ActualLbs+Q2ActualLbs+Q3ActualLbs+Q4ActualLbs )) * 100 end " +
                                "end as PctDiff";

            string groupBy = " group by Customer,Location,OrderType,CustomerName ";

            string whereClause = "Location='" + BranchID.Trim() + "' " + groupBy + sortExpression;
            try
            {

                // Code to execute the stored procedure
                DataSet dsBranchSummary = new DataSet();
                SqlConnection conn = new SqlConnection(connectionString);
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = "UGEN_SP_Select";
                Cmd.Parameters.Add(new SqlParameter("@tableName", "SalesForecastPounds"));
                Cmd.Parameters.Add(new SqlParameter("@columnNames", columnName));
                Cmd.Parameters.Add(new SqlParameter("@whereClause", whereClause));
           
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsBranchSummary);

                return dsBranchSummary;
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet GetBranchPoundsDetail(string BranchID, string OrderType, string CustomerNumber, string sortExpression)
        {
            string columnName = "CatGrpNo,CatGrpDesc,Q1ActualLbs,Q2ActualLbs,Q3ActualLbs,Q4ActualLbs,Isnull(Q1ForecastLbs,0) as Q1ForecastLbs,Isnull(Q2ForecastLbs,0) as Q2ForecastLbs ," +
                                "Isnull(Q3ForecastLbs,0) As Q3ForecastLbs ,Isnull(Q4ForecastLbs,0) as Q4ForecastLbs," +
                                "IsNull(Q1ActualLbs,0)+IsNull(Q2ActualLbs,0)+IsNull(Q3ActualLbs,0)+IsNull(Q4ActualLbs,0) as AnnualActualLbs," +
                                "IsNull(Q1ForecastLbs,0)+IsNull(Q2ForecastLbs,0)+IsNull(Q3ForecastLbs,0)+IsNull(Q4ForecastLbs,0) as AnnualForecastLbs," +
                                "case (IsNull(Q1ActualLbs,0)+IsNull(Q2ActualLbs,0)+IsNull(Q3ActualLbs,0)+IsNull(Q4ActualLbs,0) ) when 0 then 0 " +
                                "else round((((IsNull(Q1ForecastLbs,0)+IsNull(Q2ForecastLbs,0)+IsNull(Q3ForecastLbs,0)+IsNull(Q4ForecastLbs,0)) -  (Isnull(Q1ActualLbs,0)+Isnull(Q2ActualLbs,0)+Isnull(Q3ActualLbs,0)+Isnull(Q4ActualLbs,0)))/  (Isnull(Q1ActualLbs,0)+Isnull(Q2ActualLbs,0)+Isnull(Q3ActualLbs,0)+Isnull(Q4ActualLbs,0))),2) * 100 end as PctDiff," +
                                "case (isnull(Q1ActualLbs,0)) when 0 then 0 else round(((isnull(Q1ForecastLbs,0) - isnull(Q1ActualLbs,0))/isnull(Q1ActualLbs,0)) * 100,1) end as Q1AddedPct," +
                                "case (isnull(Q2ActualLbs,0)) when 0 then 0 else round(((isnull(Q2ForecastLbs,0) - isnull(Q2ActualLbs,0))/isnull(Q2ActualLbs,0)) * 100,1) end as Q2AddedPct," +
                                "case (isnull(Q3ActualLbs,0)) when 0 then 0 else round(((isnull(Q3ForecastLbs,0) - isnull(Q3ActualLbs,0))/isnull(Q3ActualLbs,0)) * 100,1) end as Q3AddedPct," +
                                "case (isnull(Q4ActualLbs,0)) when 0 then 0 else round(((isnull(Q4ForecastLbs,0) - isnull(Q4ActualLbs,0))/isnull(Q4ActualLbs,0)) * 100,1) end as Q4AddedPct," +
                                "case (IsNull(Q1ActualLbs,0)+IsNull(Q2ActualLbs,0)+IsNull(Q3ActualLbs,0)+IsNull(Q4ActualLbs,0)) when 0 then 0 else  round((((IsNull(Q1ForecastLbs,0)+IsNull(Q2ForecastLbs,0)+IsNull(Q3ForecastLbs,0)+IsNull(Q4ForecastLbs,0)) - (IsNull(Q1ActualLbs,0)+IsNull(Q2ActualLbs,0)+IsNull(Q3ActualLbs,0)+IsNull(Q4ActualLbs,0)))/(IsNull(Q1ActualLbs,0)+IsNull(Q2ActualLbs,0)+IsNull(Q3ActualLbs,0)+IsNull(Q4ActualLbs,0))) * 100,1) end  as AnnualAddedPct ";

            string whereClause = "Location='" + BranchID.Trim() + "' and Customer='" + CustomerNumber + "' and OrderType='" + OrderType + "'" + sortExpression;

            try
            {
                DataSet dsBranchSummary = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                             new SqlParameter("@tableName", "SalesForecastPounds"),
                                             new SqlParameter("@columnNames", columnName),
                                             new SqlParameter("@whereClause", whereClause));

                return dsBranchSummary;
            }
            catch (Exception ex)
            {

                return null;
            }

        }
    }
}