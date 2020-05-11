using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Data.SqlClient;
using PFC.Intranet.DataAccessLayer;

namespace PFC.VMIReports
{
    /// <summary>
    /// Summary description for VMIReports
    /// </summary>
    public class VMIReports
    {
        // public variables
        DataTable dtChainData = new DataTable();

        public DataTable GetChainData()
        {
            try
            {

                if (HttpContext.Current.Session["VMIChainData"] == null)
                {
                    DataSet dsChain = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[ugen_sp_select]",
                        new SqlParameter("@tableName", "VMI_Chain"),
                        new SqlParameter("@displayColumns", "DISTINCT Code AS ChainCode, Code + ' - ' + Name AS Code"),
                        new SqlParameter("@whereCondition", "1=1"));

                    dtChainData = dsChain.Tables[0];
                    HttpContext.Current.Session["VMIChainData"] = dsChain.Tables[0];
                }
                else
                {
                    dtChainData = HttpContext.Current.Session["VMIChainData"] as DataTable;
                }
                return dtChainData;
            }
            catch (Exception ex)
            {
                return null;               
            }

        }
    }
}
