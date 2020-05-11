using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using PFC.WOE.DataAccessLayer;

namespace PFC.WOE.BusinessLogicLayer
{
    public class WorksheetData
    {
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        public void UpdGridData(string RecId, string FldName, string FldVal)
        {
            SqlHelper.ExecuteNonQuery(connectionString, "pWOWorksheetFrm",
                new SqlParameter("@Action", "GridUpdate"),
                new SqlParameter("@RecordID", RecId),
                new SqlParameter("@FieldName", FldName),
                new SqlParameter("@FieldValue", FldVal));
        }
    }
}