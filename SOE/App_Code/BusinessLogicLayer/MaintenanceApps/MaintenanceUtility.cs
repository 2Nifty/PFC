using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using PFC.SOE.DataAccessLayer;


namespace PFC.Intranet.MaintenanceApps
{
    /// <summary>
    /// Public enum used for maintenace tables project
    /// </summary>
    public enum MaintenaceTable
    {       
        OrganisationComments
    }

    /// <summary>
    /// Summary description for MaintenanceUtility
    /// </summary>
    public class MaintenanceUtility
    {
        /// <summary>
        /// Common Connection string for all the maintenance apps
        /// </summary>
        /// <returns></returns>
        public static string GetConnectionString()
        {
            //if (HttpContext.Current.Session["MaintenanceConnectString"] != null)
            return ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
            
            return "";
        }

        //For Security Code
        string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";
        string connectionString = PFC.Intranet.MaintenanceApps.MaintenanceUtility.GetConnectionString();
        string whereClause = string.Empty;

        public void UpdateTables(string columnValues, string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                             new SqlParameter("@tableName", "[Tables]"),
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
                             new SqlParameter("@tableName", "[Tables]"),
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
                whereClause = "pTableID ='" + primaryKey + "'";
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEDelete",
                                             new SqlParameter("@tableName", "[Tables]"),
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
                string _tableName = "[Tables]";
                string _columnName = "pTableID,TableCd,Dsc,ShortDsc,PrintDoc,Comments,GLApp,APApp,ARApp,SOApp,POApp,IMApp,WMApp,WOApp,MMApp,SMApp"+
                                     ",EntryID,convert(char(10),EntryDt,101)as EntryDt,ChangeID,convert(char(10),ChangeDt,101) as ChangeDt" +
                                     ",GLAccountNo,LineNumber,ExpType,Pct,TaxStatus,Indicator";
               
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


        public DataTable GetKPIBranches()
        {
            try
            {
                string _whereClause = "1=1 order by locid";
                string _tableName = "[locmaster]";
                string _columnName = "rtrim(LocID) as Branch,LocID + ' - ' + LocName as BranchDesc";

                DataSet dsBranch = new DataSet();
                dsBranch = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsBranch.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        #region For Reason Code & Freight Terms

        public DataTable GetReasonCodeData(string searchText)
        {
            try
            {
                string _whereClause = searchText;
                string _tableName = "[Tables]";
                string _columnName = "pTableID,TableCd,Dsc,ShortDsc,IssueDoc,SOEAllowed,DelChgCd,Comments,GLApp,APApp,ARApp,SOApp,POApp,IMApp,WMApp,WOApp,MMApp,SMApp,EntryID,EntryDt,ChangeID,ChangeDt";

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

        public DataTable GetTermsCodeData(string searchText)
        {
            try
            {
                string _whereClause = searchText;
                string _tableName = "[Tables]";
                string _columnName = "pTableID,TableCd,Dsc,ShortDsc,TrmRuleID,Comments,GLApp,APApp,ARApp,SOApp,POApp,IMApp,WMApp,WOApp,MMApp,SMApp,EntryID,EntryDt,ChangeID,ChangeDt";

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
        
        #endregion
                    
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
                
                string whereClause = string.Empty;
                switch (moduleType)
                {                  
                    case MaintenaceTable.OrganisationComments:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='OrgComm (W)')";
                        break;
                    default:
                        whereClause = "' AND SG.groupname='MAINTENANCE (W)' ";
                        break;
                }
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
        /// <summary>
        /// return max row to display search value
        /// </summary>
        /// <returns></returns>
        public int GetSQLWarningRowCount()
        {
            int locName = (int)SqlHelper.ExecuteScalar(connectionString, "pSOESelect",
                                                  new SqlParameter("@tableName", "SystemMaster"),
                                                  new SqlParameter("@columnNames", "SQLRowWarn"),
                                                  new SqlParameter("@whereClause", "SystemMasterID='0'"));
            return locName;
        }

        #region Utility

        public string FormatPhoneNumber(string phoneNumber)
        {
            string result = phoneNumber;
            if (phoneNumber.Trim() != "")
            {
                if (phoneNumber.Length == 10 || phoneNumber.Length == 11)
                {
                    result = ((phoneNumber.Length == 10) ?
                                        ("(" + phoneNumber.Substring(0, 3) + ")" + " " + phoneNumber.Substring(3, 3) + "-" + phoneNumber.Substring(6, 4)) :
                                        (phoneNumber.Substring(0, 1) + "-" + phoneNumber.Substring(1, 3) + "-" + phoneNumber.Substring(4, 3) + "-" + phoneNumber.Substring(7, 4)));
                }
            }
            return result;
        }

        #endregion
    }

}