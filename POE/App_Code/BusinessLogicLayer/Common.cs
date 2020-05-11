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
using PFC.POE.DataAccessLayer;

namespace PFC.POE.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for Common
    /// </summary>
    public class Common
    {
        //For Security Code
        string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        public static string PrintStyleSheet = "<link href=\"http://10.1.36.34/SOE/Common/StyleSheet/printstyles.css\" rel=\"stylesheet\" type=\"text/css\" />";

        /// <summary>
        /// Public Method user to get User security code
        /// </summary>
        /// <param name="userName">Parameter:username</param>
        /// <returns>User security code</returns>
        public string GetSecurityCode(string userName)
        {
            try
            {
                object objSecurityCode = (object)SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and SU.UserName='" + userName + "' AND (SG.groupname='POE(W)' OR  SG.groupname='ENTRY(W)')"));

                if (objSecurityCode != null)
                    return objSecurityCode.ToString().Trim();
                else
                    return "";

            }
            catch (Exception Ex) { return ""; }
        }
    }
}
