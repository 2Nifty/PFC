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
    public class GLPosting
    {
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string whereClause;

        public DataTable GetPostingRecords(string searchText)
        {
            try
            {
                string _whereClause = searchText;
                string _tableName = "GLPosting";
                string _columnName = "pGLPostingID,ApplicationCd,LocationCd,OrganizationGLCd,ItemGLCd,GLSalesAcct,GLInvMaterialAcct,GLInvLaborAcct," +
                                    "GLCOGSMaterialAcct,GLCOGSLaborAcct,GLSalesDiscountAcct,GLARTradeAcct,GLMiscAcct,EntryID,EntryDt,ChangeID,ChangeDt,StatusCd";
                

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

        public DataTable GetDataGridPostingRecords(string searchText)
        {
            try
            {
                string _whereClause = searchText;
                string _tableName = "vGLPosting";
                string _columnName = "pGLPostingID,ApplicationCd,LocationCd,OrganizationGLCd,ItemGLCd,GLSalesAcct,GLInvMaterialAcct,GLInvLaborAcct," +
                                    "GLCOGSMaterialAcct,GLCOGSLaborAcct,GLSalesDiscountAcct,GLARTradeAcct,GLMiscAcct,EntryID,EntryDt,ChangeID,ChangeDt,StatusCd";
                                      

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

        public void UpdateTables(string columnValues, string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "[pSOEUpdate]",
                             new SqlParameter("@tableName", "[GLPosting]"),
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
                             new SqlParameter("@tableName", "[GLPosting]"),
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
                whereClause = "pGLPostingID ='" + primaryKey + "'";
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEDelete",
                                             new SqlParameter("@tableName", "[GLPosting]"),
                                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public bool CheckDataExist(string whereClause)
        {
            DataSet dsCarrierCode = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                        new SqlParameter("@tableName", "[GLPosting]"),
                        new SqlParameter("@columnNames", "*"),
                        new SqlParameter("@whereClause", whereClause));

            if (dsCarrierCode.Tables[0].Rows.Count > 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

    }
}