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

using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.DataAccessLayer;

/// <summary>
/// Summary description for Invoice
/// </summary>

namespace PFC.SOE.BusinessLogicLayer
{

    public class Invoice
    {
        public Invoice()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public string InsertInvoiceDetails(string tableName, string columnName, string columnValues)
        {
            try
            {
                object objID = SqlHelper.ExecuteScalar(ConfigurationManager.AppSettings["EsuiteConnectionString"].ToString(), "UGEN_SP_Insert",
                                            new SqlParameter("@tableName", tableName),
                                            new SqlParameter("@columnNames", columnName),
                                            new SqlParameter("@columnValues", columnValues));
                if (objID != null)
                    return objID.ToString().Trim();

                return "";
            }
            catch (Exception ex)
            {
                return "";
            }
        }

        public DataTable GetDetails(string tableName, string columnName, string whereClause)
        {
            try
            {
                DataSet dsDetails = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["EsuiteConnectionString"].ToString(), "UGEN_SP_SELECT",
                                             new SqlParameter("@tableName", tableName),
                                             new SqlParameter("@columnNames", columnName),
                                             new SqlParameter("@whereClause", whereClause));
                return dsDetails.Tables[0];
            }
            catch (Exception ex) { return null; }
        }
    }
}
