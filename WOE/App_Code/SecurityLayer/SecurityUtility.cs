using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using PFC.WOE;
using PFC.WOE.DataAccessLayer;

namespace PFC.WOE.SecurityLayer
{
    public class SecurityUtility
    {
        string securityTable = "SecurityGroups SG, dbo.SecurityMembers SM, dbo.SecurityUsers SU";
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string whereClause = string.Empty;

        #region Security Code

        public string GetSecurityCode(string userName, string moduleType)
        {
            try
            {
                #region Create where clause based on module type
                whereClause = "SM.SecGroupID = SG.pSecGroupID AND SM.SecUserID = SU.pSecUserID AND (SU.DeleteDt is null OR SU.DeleteDt = '') AND (SM.DeleteDt is null OR SM.DeleteDt = '') AND (SG.DeleteDt is null OR SG.DeleteDt = '') AND SU.UserName='" + userName + "' ";
                switch (moduleType)
                {
                    case "WOFind":
                        whereClause = whereClause + "AND (SG.GroupName = 'MRP (W)' OR SG.GroupName = 'WOS (W)' OR SG.GroupName = 'MAINTENANCE (W)')";
                        break;
                    case "WOWorkSheet":
                        whereClause = whereClause + "AND (SG.GroupName = 'MRP (W)' OR SG.GroupName = 'WOS (W)')";
                        break;
                    default:
                        whereClause = whereClause + "AND SG.GroupName = 'MAINTENANCE (W)' ";
                        break;
                }
                #endregion

                object objSecurityCode = (object)SqlHelper.ExecuteScalar(connectionString, "pSOESelect",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "SG.GroupName"),
                    new SqlParameter("@whereClause", whereClause));

                if (objSecurityCode != null)
                    return objSecurityCode.ToString().Trim();
                else
                    return "";
            }
            catch (Exception Ex)
                { return ""; }
        }

        #endregion

        #region Soft Locks

        public DataTable SetLock(string lockTable, string lockID, string lockApp)
        {
            try
            {
                DataTable dtLock = new DataTable();
                dtLock = MaintLock(lockTable.ToString(), "Lock", lockID.ToString(), lockApp.ToString());
                return dtLock.DefaultView.ToTable();
            }
            catch (Exception ex) { return null; }
        }

        public DataTable MaintLock(string lockTable, string lockFunction, string lockID, string lockApp)
        {
            try
            {
                DataSet dsLock = SqlHelper.ExecuteDataset(connectionString, "pSoftLock",
                                              new SqlParameter("@resource", lockTable),
                                              new SqlParameter("@function", lockFunction),
                                              new SqlParameter("@key", lockID),
                                              new SqlParameter("@uid", HttpContext.Current.Session["UserName"].ToString()),
                                              new SqlParameter("@curApplication", lockApp));

                if (dsLock != null && dsLock.Tables[0].Rows.Count > 0)
                    return dsLock.Tables[0];
                else
                    return null;
            }
            catch (Exception ex) { return null; }
        }

        public void ReleaseLock(string lockTable, string lockID, string lockApp, string lockStatus)
        {
            try
            {
                if (lockStatus.ToString() == "SL")
                    MaintLock(lockTable.ToString(), "Release", lockID.ToString(), lockApp.ToString());
            }
            catch (Exception ex) { }
        }

        #endregion
    }
}