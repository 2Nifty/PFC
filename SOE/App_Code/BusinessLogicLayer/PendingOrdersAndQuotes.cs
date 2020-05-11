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
using PFC.SOE.DataAccessLayer;

/// <summary>
/// Summary description for SOCommentEntry
/// </summary>
/// 
namespace PFC.SOE.BusinessLogicLayer
{
    public class PendingOrders
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string _tableName = "";
        string _columnName = "";
        string _whereClause = "";

        #region CommentEntry

        public DataTable GetPendingOrders(string whereClause)
        {
            try
            {
                _tableName = "SOHeader";
                _columnName =   "pSOHeaderID,ShipLoc,OrderNo,SellToCustNo,SellToCustName," +
                                "cast((isnull(TotalOrder,0)) as Decimal(25,2))  as TotalOrder," +
                                "convert(char(10),OrderDt,101) as OrderDt,convert(char(10),CustReqDt,101) as CustReqDt,OrderType," +
                                "convert(char(10),DeleteDt,101) as DeleteDt,isnull(OrderStatus,'SO') as OrderStatus,EntryID,convert(char(10),EntryDt,101) as EntryDt";
                //whereClause += " AND SubType='50'";
                DataSet dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", whereClause));
                return dsResult.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }
        
        #endregion
    }
    
}