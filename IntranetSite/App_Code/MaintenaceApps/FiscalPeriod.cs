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

namespace PFC.Intranet.MaintenanceApps
{
    /// <summary>
    /// Summary description for FormMessages
    /// </summary>
    public class FiscalPeriod
    {
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
     
        string whereClause = string.Empty;
        string _whereClause = string.Empty;    
        string _columnName = string.Empty;
        string _tableName = "FiscalPeriodCalendar";

        /// <summary>
        /// Get fiscal record from Table based on searchText 
        /// </summary>
        /// <param name="searchText"></param>
        /// <returns></returns>
        public DataTable GetFiscalPeriods(string searchText)
        {
            try
            {
                _whereClause = searchText;
                _columnName = "  pFYPeriodID,FiscalPeriod as 'Period',FiscalYear as 'Year',StatusCd,convert(char(10),FiscalPeriodStart,101) as PeriodStart ," +
                              " convert(char(10),FiscalPeriodEnd ,101)as PeriodEnd,StatusCd,Notes,PayrollPostedInd, ReconciledVariancePostedInd as 'RCLVarPostedInd', GLMonthendClosedInd as 'GLMEClosedInd'," +
                              " GLYearendClosedInd as 'GLYEClosedInd',EntryID,EntryDt,ChangeID,ChangeDt"; ;                

                DataSet dsFrmMsg = new DataSet();
                dsFrmMsg = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsFrmMsg.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        /// <summary>
        /// Update fiscal calendar values 
        /// </summary>
        /// <param name="columnValues"></param>
        /// <param name="whereCondition"></param>
        public void UpdateTables(string columnValues, string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                             new SqlParameter("@tableName", _tableName),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {

            }
        }
        /// <summary>
        /// insert new record in fiscal calendar 
        /// </summary>
        /// <param name="columnNames"></param>
        /// <param name="columnValues"></param>
        public void InsertTables(string columnNames, string columnValues)
        {
            try
            {
                SqlHelper.ExecuteDataset(connectionString, "pSOEInsert",
                             new SqlParameter("@tableName", _tableName),
                             new SqlParameter("@columnNames", columnNames),
                             new SqlParameter("@columnValues", columnValues));
            }
            catch (Exception ex)
            {

            }
        }
        /// <summary>
        /// Delete record from table 
        /// </summary>
        /// <param name="primaryKey"></param>
        public void DeleteData(string primaryKey)
        {
            try
            {
                whereClause = "pFYPeriodID ='" + primaryKey + "'";
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEDelete",
                                             new SqlParameter("@tableName", _tableName),
                                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public bool CheckDataExist(string whereClause)
        {
            DataSet dsCarrierCode = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                        new SqlParameter("@tableName", _tableName),
                        new SqlParameter("@columnNames", "*"),
                        new SqlParameter("@whereClause", whereClause));

            if (dsCarrierCode.Tables[0].Rows.Count > 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
    }
}