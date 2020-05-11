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
    public class RequestQuote
    {
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string QuotesSystemConnectionString = ConfigurationManager.AppSettings["QuotesSystemConnectionString"].ToString();
        
        string whereClause;

        public DataTable GetRequestQuote(string searchText)
        {
            try
            {
                string _whereClause = searchText + " and QuoteType='RFQ' and UserItemNo is null";

                string _tblname = " DTQ_CustomerQuotation LEFT OUTER JOIN  SDK_EndUserRegistration ON  DTQ_CustomerQuotation.UserID =  SDK_EndUserRegistration.LoginID";
                string _colName = "distinct DTQ_CustomerQuotation.CustomerName,DTQ_CustomerQuotation.CustomerNumber," +
                                    "SDK_EndUserRegistration.AdministratorEmailID," +
                                    "DTQ_CustomerQuotation.PFCSalesRep,convert(varchar(10)," +
                                    "DTQ_CustomerQuotation.RFQCompleteDt,101)as RFQCompleteDt,DTQ_CustomerQuotation.CustRefNo," +
                                    "DTQ_CustomerQuotation.SystemName,DTQ_CustomerQuotation.SessionID," +
                                    "convert(varchar(10),DTQ_CustomerQuotation.QuotationDate,101) as QuotationDate";
                DataSet dsFrmMsg = new DataSet();
                dsFrmMsg = SqlHelper.ExecuteDataset(QuotesSystemConnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tblname),
                                    new SqlParameter("@columnNames", _colName),
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
                string _tableName = "GLAcctMaster";
                string _columnName = "pGLAcctMasterID,AccountNo,Location,AccountDescription,EntryID,EntryDt,ChangeID,ChangeDt";
                                      

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
                SqlHelper.ExecuteNonQuery(QuotesSystemConnectionString, "UGEN_SP_Update",
                             new SqlParameter("@tableName", "DTQ_CustomerQuotation"),
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
        public DataTable GetCustomerID(string custNo)
        {
            try
            {


              string   _tableName = "customerMaster";
              string _columnNames = "pcustmstrID";
              string _whereClause = "custno='" + custNo + "'";

                DataSet dsCustomerID = (DataSet)SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsCustomerID.Tables[0] != null)
                {
                    string custID = dsCustomerID.Tables[0].Rows[0]["pcustmstrID"].ToString();
                    DataSet dsCustomerInfo = (DataSet)SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                                      new SqlParameter("@tableName", "customerAddress"),
                                                      new SqlParameter("@columnNames", "Name1,PostCd,City,State,AddrLine1"),
                                                      new SqlParameter("@whereClause", "fcustomermasterid='" + custID + "' and type not in('DSHP','SHP')"));
                    return dsCustomerInfo.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable GetCustQuotationInfo(string searchText)
        {
            try
            {
                string _whereClause = searchText + " and QuoteType='RFQ' and UserITemNo<>''";
                //string _tableName = "vw_RFQ";
                //string _columnName = "*";

                string _tblname = "DTQ_CustomerQuotation";
                string _colName = "*";
                DataSet dsFrmMsg = new DataSet();
                dsFrmMsg = SqlHelper.ExecuteDataset(QuotesSystemConnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tblname),
                                    new SqlParameter("@columnNames", _colName),
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