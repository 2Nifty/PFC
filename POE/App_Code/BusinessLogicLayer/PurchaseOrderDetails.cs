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
using PFC.POE.DataAccessLayer;

/// <summary>
/// Summary description for SalesOrderDetails
/// </summary>
/// 
namespace PFC.POE.BusinessLogicLayer
{
    public class PurchaseOrderDetails
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
       
        #region Sub Header
        public DataTable GetPurchaseOrderDetails(string tableName, string columnName, string whereClause)
        {
            try
            {
                DataSet dsSalesOrderDetails = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", tableName),
                                    new SqlParameter("@columnNames", columnName),
                                    new SqlParameter("@whereClause", whereClause));

                return dsSalesOrderDetails.Tables[0];
            }
            catch (Exception ex)
            {

                return null;
            }
        }


        #endregion


    }
}
