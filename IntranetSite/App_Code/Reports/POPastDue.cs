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

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for InvoiceRegisterRep
    /// </summary>
    public class POPastDue
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string customerSortExpression = "";

        public DataTable GetPOPastDueData(string reportName, string reportSort)
        {

            try
            {
                // Code to execute the stored procedure
                DataSet dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "[pPOPastDueReport]",
                                    new SqlParameter("@reportName", reportName),
                                    new SqlParameter("@reportFilter", reportSort));

                if (dsResult != null)
                    return dsResult.Tables[0];

                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

    }

}