using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
using System.Data.SqlClient;

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for CSRReports
    /// </summary>
    public class CSRReports
    {
        string connectionString = Global.UmbrellaConnectionString;
        string cnERP = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        //string connectionString = "Data Source=PFCQUOTE;Initial Catalog=umbrella;Persist Security Info=True;User ID=saadmin;Password=oswin~2005";


        //Umbrella Tables - This is obsolete
        public DataTable GetSalesRepNames(string branchID)
        {
            try
            {
                DataSet dsCsr = (DataSet)SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                             new SqlParameter("@TableName", "dbo.UCOR_UserSetup a join  dbo.UCOR_UserType b on a.UserType=b.typeID"),
                             new SqlParameter("@columnNames", "a.username as UserName"),
                             new SqlParameter("@whereClause", "a.CompanyId='" + branchID + "' and b.Type='Customer Sales Rep' order by username"));
                return dsCsr.Tables[0];
            }
            catch (Exception ex)
            {
                
                return null;
            }
        }

        //ERP Tables (RepMaster) - Current
        public DataTable GetRepMasterNames(string branchID)
        {
            try
            {
                DataSet dsCsr = (DataSet)SqlHelper.ExecuteDataset(cnERP, "[UGEN_SP_Select]",
                                         new SqlParameter("@TableName", "RepMaster RM (NoLock)"),
                                         new SqlParameter("@columnNames", "isnull(RM.RepNotes,'') as UserName"),
                                         new SqlParameter("@whereClause", "RM.LocationNo = '" + branchID + "' AND RM.RepClass = 'I' AND RM.RepStatus = 'A'"));
                return dsCsr.Tables[0];
            }
            catch (Exception ex)
            {

                return null;
            }
        }
    }
}
