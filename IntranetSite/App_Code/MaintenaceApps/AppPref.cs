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
    /// Summary description for Appplication Preferences
    /// </summary>
    public class AppPref
    {
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";
        string whereClause = string.Empty;

        public DataTable GetAppPrefData()
        {
            try
            {
                string _whereClause = " 1=1 ";
                string _tableName = "[AppPref]";
                string _columnName = "pAppPrefID,ApplicationCd,AppOptionType,AppOptionTypeDesc,AppOptionValue,EntryID,entryDt,ChangeID,ChangeDt";

                DataSet dsAppRef = new DataSet();
                dsAppRef = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsAppRef.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetAppPrefData(string AppPrefID)
        {
            try
            {
                string _whereClause = "pAppPrefID=" + AppPrefID;
                string _tableName = "[AppPref]";
                string _columnName = "*";

                DataSet dsAppPref = new DataSet();
                dsAppPref = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsAppPref.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public object InsertTables(string ColumnName, string ColumnValue)
        {
            try
            {

                object objID = SqlHelper.ExecuteScalar(connectionString, "pSOEInsert",
                                              new SqlParameter("@tableName", "AppPref"),
                                              new SqlParameter("@columnNames", ColumnName),
                                              new SqlParameter("@columnValues", ColumnValue));
                return objID;
            }
            catch (Exception ex) { return null; }
        }

        public void UpdateAppPrefData(string columnValues, string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "[pSOEUpdate]",
                             new SqlParameter("@tableName", "AppPref"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {

            }
        }

        public void DeleteData(string primaryKey)
        {
            try
            {
                whereClause = "pAppPrefID ='" + primaryKey + "'";
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEDelete",
                                             new SqlParameter("@tableName", "[AppPref]"),
                                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public bool CheckDataExist(string whereClause)
        {
            DataSet dsAppPref = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                        new SqlParameter("@tableName", "[AppPref]"),
                        new SqlParameter("@columnNames", "*"),
                        new SqlParameter("@whereClause", whereClause));

            if (dsAppPref.Tables[0].Rows.Count > 0)
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
