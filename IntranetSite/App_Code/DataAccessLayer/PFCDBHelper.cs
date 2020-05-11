using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.Sql;
using System.Data.SqlClient;

namespace PFC.Intranet.DataAccessLayer
{
    /// <summary>
    /// Summary description for PFCDBHelper
    /// </summary>
    public class PFCDBHelper
    {
        public static DataTable ExecuteERPSelectQuery(string query)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(Global.PFCERPConnectionString))
                {
                    connection.Open();
                    DataSet dsResult = SqlHelper.ExecuteDataset(connection, CommandType.Text, query);

                    if (dsResult != null)
                        return dsResult.Tables[0];

                    return null;
                }
            }
            catch (Exception ex)
            {
                throw ex;
                return null;
            }
        }

        public static int ExecuteERPUpdateQuery(string query)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(Global.PFCERPConnectionString))
                {
                    connection.Open();
                    int retval = SqlHelper.ExecuteNonQuery(connection, CommandType.Text, query);
                    
                    return retval;
                }
            }
            catch (Exception ex)
            {
                throw ex;
                return -1;
            }
        }

    }
}
