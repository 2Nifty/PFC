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
    public class GLAccount
    {
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string whereClause;

        public DataTable GetPostingRecords(string searchText)
        {
            try
            {
                string _whereClause = searchText;
                string _tableName = "GLAcctMaster";
                string _columnName = "*";
                

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
                //string _tableName = "GLAcctMaster";
                //string _columnName = "pGLAcctMasterID,AccountNo,Location,AccountDescription,EntryID,EntryDt,ChangeID,ChangeDt";
                string _tableName = "GLAcctMaster LEFT OUTER JOIN LocMaster ON GLAcctMaster.Location = LocMaster.LocID";
                string _columnName = "LocMaster.LocName as Location, GLAcctMaster.pGLAcctMasterID, GLAcctMaster.AccountNo, GLAcctMaster.AccountDescription,GLAcctMaster.fDepartmentID, GLAcctMaster.AccountType, GLAcctMaster.AliasAccountNo, GLAcctMaster.EffectiveDt,GLAcctMaster.DeleteDt, GLAcctMaster.SequenceNo, GLAcctMaster.PostLevel, GLAcctMaster.EntryID, GLAcctMaster.EntryDt,GLAcctMaster.ChangeID,GLAcctMaster.ChangeDt";


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
                             new SqlParameter("@tableName", "[GLAcctMaster]"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {

            }
        }
        public void UpdateDeleteDT(string columnValues, string whereCondition)
        {
            try
            {
                string whereClause = "pGLAcctMasterID ='" + whereCondition + "'";
                SqlHelper.ExecuteNonQuery(connectionString, "[pSOEUpdate]",
                             new SqlParameter("@tableName", "[GLAcctMaster]"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereClause));
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
                             new SqlParameter("@tableName", "[GLAcctMaster]"),
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
                whereClause = "pGLAcctMasterID ='" + primaryKey + "'";
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEDelete",
                                             new SqlParameter("@tableName", "[GLAcctMaster]"),
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
                        new SqlParameter("@tableName", "[GLAcctMaster]"),
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

        public DataTable GetLocation(string searchText,string ColNames,string TableName)
        {
            try
            {
                string _whereClause = searchText;
                string _tableName =TableName ;
                string _columnName = ColNames;


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