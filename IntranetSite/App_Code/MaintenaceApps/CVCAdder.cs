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
    public class CVCAdder
    {
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string whereClause;

        public DataSet GetCVCAdderTableData(string source,string filter)
        {
            try
            {
                DataSet dsResult = new DataSet();
                dsResult = SqlHelper.ExecuteDataset(connectionString, "[pCVCAdderFrm]",
                                    new SqlParameter("@source", source),
                                    new SqlParameter("@searchFilter", filter),
                                    new SqlParameter("@category", ""),
                                    new SqlParameter("@plating", ""),
                                    new SqlParameter("@cvcCd", ""));
                return dsResult;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetCVCAdderTableData(string source, string category,string plating)
        {
            try
            {
                DataSet dsResult = new DataSet();
                dsResult = SqlHelper.ExecuteDataset(connectionString, "[pCVCAdderFrm]",
                                    new SqlParameter("@source", source),
                                    new SqlParameter("@searchFilter", ""),
                                    new SqlParameter("@category", category),
                                    new SqlParameter("@plating", plating),
                                    new SqlParameter("@cvcCd", ""));
                return dsResult;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public void UpdateTables(string columnValues, string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "[pSOEUpdate]",
                             new SqlParameter("@tableName", "[CVCAdders]"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {

            }
        }

        public void InsertTables(string columnNames, string columnValues)
        {
            try
            {
                SqlHelper.ExecuteDataset(connectionString, "[pSOEInsert]",
                             new SqlParameter("@tableName", "[CVCAdders]"),
                             new SqlParameter("@columnNames", columnNames),
                             new SqlParameter("@columnValues", columnValues));
            }
            catch (Exception ex)
            {

            }
        }

        public void DeleteTablesData(string primaryKey)
        {
            try
            {
                whereClause = "pCVCAddersID ='" + primaryKey + "'";
                string columnValues = "DeleteDt='" + DateTime.Now.ToString() + "',"+
                                    "ChangeID='" + HttpContext.Current.Session["UserName"].ToString() + "'," +
                                    "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";

                SqlHelper.ExecuteNonQuery(connectionString, "[pSOEUpdate]",
                             new SqlParameter("@tableName", "[CVCAdders]"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereClause));                
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public bool CheckDataExist(string category,string plating,string cvcCd,string cvcadderId)
        {
            try
            {
                DataSet dsResult = new DataSet();
                dsResult = SqlHelper.ExecuteDataset(connectionString, "[pCVCAdderFrm]",
                                    new SqlParameter("@source", "checkduplicate"),
                                    new SqlParameter("@searchFilter", cvcadderId),
                                    new SqlParameter("@category", category),
                                    new SqlParameter("@plating", plating),
                                    new SqlParameter("@cvcCd", cvcCd));
                if (dsResult != null && dsResult.Tables[0].Rows.Count>0)
                {
                    return false;
                }
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

    }
}