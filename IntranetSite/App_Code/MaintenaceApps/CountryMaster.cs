using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;

/// <summary>
/// Summary description for CountryMasterLayer
/// </summary>
namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for VendorDetailLayer
    /// </summary>
    public class CountryMaster
    {
        string CountryMasterTable = "CountryMaster";
        string CountryMasterColumns = "CountryCd,Name,DateFormat,PostCodeFormat,PhoneFormat,CurrencyCd,GLAppInd,APAppInd,ARAppInd,SOAppInd,POAppInd,IMAppInd,WMAppInd,WOAppInd,MMAppInd,SMAppInd,EntryID,EntryDt,ChangeID,ChangeDt,StatusCd,[856CountryCd]";
        //For Security Code
        string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";
        //ConnectionString
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        /// <summary>
        /// Get the table values from the database
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="columnName"></param>
        /// <param name="whereClause"></param>
        /// <returns></returns>
        /// 

        public DataSet GetDataToDateset(string tableName, string columnName, string whereClause)
        {
            try
            {

                DataSet dsDetails = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                    new SqlParameter("@tableName", tableName),
                    new SqlParameter("@columnNames", columnName),
                    new SqlParameter("@whereClause", whereClause));

                return dsDetails;

            }
            catch (Exception ex) { return null; }
        }


        public object InsertCountryCodeDetails(string tableName, string ColumnName, string ColumnValue)
        {
            try
            {

                object objID = SqlHelper.ExecuteScalar(connectionString, "pSOEInsert",
                                              new SqlParameter("@tableName", tableName),
                                              new SqlParameter("@columnNames", ColumnName),
                                              new SqlParameter("@columnValues", ColumnValue));
                return objID;
            }
            catch (Exception ex) { return null; }
        }


        public string CountryDetails(string columnValue)
        {
            object objID = InsertCountryCodeDetails(CountryMasterTable, CountryMasterColumns, columnValue);

            if (objID != null)
                return objID.ToString();
            else
                return "";
        }

        public void UpdateCountryDetails(string tableName, string columnValue, string where)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                                             new SqlParameter("@tableName", tableName.Trim()),
                                             new SqlParameter("@columnNames", columnValue),
                                             new SqlParameter("@whereClause", where));
            }
            catch (Exception ex) { }
        }

        public void DeleteCountryDetails(string tableName, string where)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEDelete",
                                             new SqlParameter("@tableName", tableName.Trim()),
                                             new SqlParameter("@whereClause", where));
            }
            catch (Exception ex) { }
        }


        public bool GetCountryCode(string whereClause)
        {
            try
            {
                DataSet objVendNo = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                    new SqlParameter("@tableName", "CountryMaster"),
                    new SqlParameter("@columnNames", "CountryCd"),
                    new SqlParameter("@whereClause", whereClause));

                if (objVendNo.Tables[0].Rows.Count > 0)
                    return false;
                else
                    return true;
            }
            catch (Exception Ex) { return false; }
        }

        #region Security Code
        /// <summary>
        /// Public Method user to get User security code
        /// </summary>
        /// <param name="userName">Parameter:username</param>
        /// <returns>User security code</returns>
        public string GetSecurityCode(string userName)
        {
            try
            {
                object objSecurityCode = (object)SqlHelper.ExecuteScalar(connectionString, "pSOESelect",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and (SU.DeleteDt is null or SU.DeleteDt = '') and (SM.DeleteDt is null or SM.DeleteDt = '') and (SG.DeleteDt is null or SG.DeleteDt = '') and SU.UserName='" + userName + "' AND (SG.groupname='MAINTENANCE (W)')"));

                if (objSecurityCode != null)
                    return objSecurityCode.ToString().Trim();
                else
                    return "";

            }
            catch (Exception Ex) { return ""; }
        }
        #endregion
    }
}