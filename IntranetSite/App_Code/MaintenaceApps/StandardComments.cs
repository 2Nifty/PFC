using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;

namespace PFC.Intranet.MaintenanceApps
{
    /// <summary>
    /// Summary description for MaintenanceUtility
    /// </summary>
    public class StandardComment 
    {
        //For Security Code
        string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string whereClause = string.Empty;
        
        public void UpdateTables(string columnValues, string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                             new SqlParameter("@tableName", "[StandardComments]"),
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
                SqlHelper.ExecuteDataset(connectionString, "pSOEInsert",
                             new SqlParameter("@tableName", "[StandardComments]"),
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
                whereClause = "StdCommentsID ='" + primaryKey + "'";
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEDelete",
                                             new SqlParameter("@tableName", "[StandardComments]"),
                                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetTablesData(string searchText)
        {
            try
            {
                string _whereClause = searchText;
                string _tableName = "[StandardComments]";
                string _columnName = "[StdCommentsID] as pTableID,StdCommentsCd,CommentLocOnDoc,DocumentType,[NoOfSpaces],Comments,GLAppInd,APAppInd,ARAppInd,SOAppInd,POAppInd,IMAppInd,WMAppInd,WOAppInd,MMAppInd,SMAppInd,EntryID,EntryDt,ChangeID,ChangeDt";

                DataSet dsCarrierCode = new DataSet();
                dsCarrierCode = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsCarrierCode.Tables[0];
            }
            catch (Exception ex)
            { 
                return null;
            }
        }

        public bool CheckDataExist(string code, MaintenaceTable maintenaceTable)
        {
            string whereClause = "StdCommentsCd='" + code + "'";
            DataSet dsCarrierCode = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                        new SqlParameter("@tableName", "[StandardComments]"),
                        new SqlParameter("@columnNames", "StdCommentsCd"),
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
                    
        #region Security Code
        /// <summary>
        /// Public Method user to get User security code
        /// </summary>
        /// <param name="userName">Parameter:username</param>
        /// <returns>User security code</returns>
        public string GetSecurityCode(string userName, MaintenaceTable moduleType)
        {
            try
            {
                
                #region Create where clause based on module type

                string whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='StdComm (W)')";
                
                #endregion

                object objSecurityCode = (object)SqlHelper.ExecuteScalar(connectionString, "pSOESelect",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and SU.UserName='" + userName + whereClause));

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