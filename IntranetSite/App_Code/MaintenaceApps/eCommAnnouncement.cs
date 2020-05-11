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
    public class eCommerceAnnouncement
    {
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string whereClause;

        public DataSet GeteCommAnnouncementData(string source,string filter)
        {
            try
            {
                DataSet dsResult = new DataSet();
                dsResult = SqlHelper.ExecuteDataset(connectionString, "[peCommAnnouncementFrm]",
                                    new SqlParameter("@source", source),
                                    new SqlParameter("@filter", filter),
                                    new SqlParameter("@parameter1", ""),
                                    new SqlParameter("@parameter2", ""),
                                    new SqlParameter("@pHolidayMessageID", ""));
                return dsResult;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public void UpdateTables(string columnValues, string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "[pSOEUpdate]",
                             new SqlParameter("@tableName", "[HolidayMessage]"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {

            }
        }

        public void InsertTables(string columnNames, string columnValues)
        {
            try
            {
                SqlHelper.ExecuteDataset(connectionString, "[pSOEInsert]",
                             new SqlParameter("@tableName", "[HolidayMessage]"),
                             new SqlParameter("@columnNames", columnNames),
                             new SqlParameter("@columnValues", columnValues));
            }
            catch (Exception ex)
            {

            }
        }

        public void DeleteTablesData(string primaryKey)
        {
            try
            {
                whereClause = "pHolidayMessageID ='" + primaryKey + "'";
                string columnValues = "DeleteDt='" + DateTime.Now.ToString() + "',"+
                                    "ChangeID='" + HttpContext.Current.Session["UserName"].ToString() + "'," +
                                    "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";

                SqlHelper.ExecuteNonQuery(connectionString, "[pSOEUpdate]",
                             new SqlParameter("@tableName", "[HolidayMessage]"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereClause));                
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public bool CheckDataExist(string locId, string startDt, string endDt, string pHolidayMessageID)
        {
            try
            {
                if (pHolidayMessageID == "")
                    pHolidayMessageID = "-99";

                DataSet dsResult = new DataSet();
                dsResult = SqlHelper.ExecuteDataset(connectionString, "[peCommAnnouncementFrm]",
                                    new SqlParameter("@source", "checkdataexist"),
                                    new SqlParameter("@filter", locId),
                                    new SqlParameter("@parameter1", startDt),
                                    new SqlParameter("@parameter2", endDt),
                                    new SqlParameter("@pHolidayMessageID", pHolidayMessageID));          

                if (dsResult != null && dsResult.Tables[0].Rows.Count>0)
                {
                    return false;
                }
                return true;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

    }
}