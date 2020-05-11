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

namespace PFC.Intranet.MaintenanceApps
{
    /// <summary>
    /// Summary description for FormMessages
    /// </summary>
    public class FormMessages
    {
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        public DataTable GetFormMessages(string searchText)
        {
            try
            {
                string _whereClause = searchText;
                string _tableName = "[Tables]";
                string _columnName = "pTableID,PrintDoc as FrmType,FormMsgLoc,FormMsgType,Comments,EntryID,EntryDt,ChangeID,ChangeDt,TableType";

                DataSet dsFrmMsg = new DataSet();
                dsFrmMsg = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsFrmMsg.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}