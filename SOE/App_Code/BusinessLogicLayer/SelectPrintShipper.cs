using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;
using System.Data.SqlClient;
using System.Net;
using System.IO;
using System.Text;
using PFC.SOE.DataAccessLayer;
using PFC.SOE.Enums;


namespace PFC.SOE.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for PrintInvoice
    /// </summary>

  

    public class SelectPrintShipper
    {

        string tableName = "";
        string columnName = "";
        string whereClause = "";
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        public DataTable GetShipper(string whereClause)
        {
            //tableName = HttpContext.Current.Session["OrderTableName"].ToString()+ " Hist";
            columnName = "OrderNo, convert(varchar(20),OrderNo) + ' - Brn '+ convert(varchar(20),ShipLoc)+' - Order # '+convert(varchar(20),fSOHeaderID)  as ShipLoc";
            //whereClause = "  Hist.OrderNo='" + orderNo.Trim() + "'";
            DataSet dsShipper =  SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                           new SqlParameter("@tableName", "SOHeaderRel"),
                                           new SqlParameter("@columnName", columnName),
                                           new SqlParameter("@whereClause", whereClause));

            return dsShipper.Tables[0];

        }

        public void DisplayMessage(MessageType messageType, string messageText, Label lblMessage)
        {
            switch (messageType)
            {
                case MessageType.Success:
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    break;
                case MessageType.Failure:
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    break;

            }
        }
    }
  
}