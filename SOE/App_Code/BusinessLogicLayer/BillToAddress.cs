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
namespace PFC.SOE.BusinessLogicLayer
{
    public class BillToAddress
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string _tableName = "";
        string _columnName = "";
        string _whereClause = "";
        private string spName = string.Empty;
        string _TaxExemptTable = "TaxExempt";

        #region Customer
        public string GetCustomerName(string CustomerNumber)
        {
            try
            {
                _tableName = "CustomerMaster";
                _columnName = " CustName";
                _whereClause = "CustNo='" + CustomerNumber + "'";
                string CustomerName = SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause)).ToString();
                return CustomerName;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public string GetCustomerID(string CustomerNumber)
        {
            try
            {
                _tableName = "CustomerMaster";
                _columnName = "pCustMstrID";
                _whereClause = "CustNo='" + CustomerNumber + "'";
                string CustomerName = SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause)).ToString();
                return CustomerName;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public string GetCustomerNumber(string CustomerID)
        {
            try
            {
                _tableName = "CustomerMaster";
                _columnName = "CustNo";
                _whereClause = "pCustMstrID='" + CustomerID + "'";
                string CustomerName = SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause)).ToString();
                return CustomerName;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        #endregion

        #region BillTo Info.
        /// <summary>
        /// Get Value From SP (pSOEGetBillToInfo)
        /// </summary>
        /// <param name="columnValue">soNumber</param>
        public DataTable GetBillToInfo(string soNumber)
        {
            spName = "[pSOEGetBillToInfo]";
            DataSet dsBillToInfo = SqlHelper.ExecuteDataset(ERPConnectionString, spName,
                                new SqlParameter("@soNumber", soNumber));
            return dsBillToInfo.Tables[0];
        }
        #endregion

        #region TaxExempt

        public DataSet SelectTaxExempt(string CustomerNumber)
        {
            try
            {
                //_columnName = "[pTaxExemptID],[fCustMasterID],[ResaleCertNo], [State], CONVERT(varchar(10), ExpirationDt, 101) AS ExpirationDt";
                //_whereClause = "[CustNo]='" + CustomerNumber + "'";
                //DataSet dsGetTaxExempt = SqlHelper.ExecuteDataset(ERPConnectionString, "[pSOESelect]",
                //         new SqlParameter("@tableName", _TaxExemptTable),
                //         new SqlParameter("@columnNames", _columnName),
                //         new SqlParameter("@whereClause", _whereClause));

                spName = "[pSOESelectTaxExempt]";
                DataSet dsGetTaxExempt = SqlHelper.ExecuteDataset(ERPConnectionString, spName,
                                    new SqlParameter("@custNumber", CustomerNumber));

                return dsGetTaxExempt;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public void InsertTaxExempt(string _columnValue)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "[pSOEInsert]",
                         new SqlParameter("@tableName", _TaxExemptTable),
                         new SqlParameter("@columnNames", "fCustMasterID, CustNo, ResaleCertNo, State, ExpirationDt,  EntryID, EntryDt"),
                         new SqlParameter("@columnValues", _columnValue));
            }
            catch (Exception ex)
            {

            }
        }

        public void UpdateTaxExempt(string _columnValue, string _whereClause)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "[pSOEUpdate]",
                         new SqlParameter("@tableName", _TaxExemptTable),
                         new SqlParameter("@columnNames", _columnValue),
                         new SqlParameter("@whereClause", _whereClause));
            }
            catch (Exception ex)
            {
            }
        }

        public void DeleteTaxExempt(string _whereClause)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "[pSOEDelete]",
                         new SqlParameter("@tableName", _TaxExemptTable),
                         new SqlParameter("@whereClause", _whereClause));
            }
            catch (Exception ex)
            {
            }
        }

        public DataTable GetTaxDetail(string TaxID)
        {
            try
            {
                _whereClause = "[pTaxExemptID]= " + TaxID;
                DataSet dsTaxDetail = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _TaxExemptTable),
                                    new SqlParameter("@columnNames", "fCustMasterID, CustNo, ResaleCertNo, State, ExpirationDt,EntryID, EntryDt,ChangeID, ChangeDt"),
                                    new SqlParameter("@whereClause", _whereClause));

                return dsTaxDetail.Tables[0];
            }
            catch (Exception ex)
            {

                return null;
            }
        }

        public DataTable GetStates()
        {
            try
            {
                _tableName = "ListMaster LM ,ListDetail LD";
                _columnName = "(LD.ListdtlDesc) as ListDesc,LD.ListValue ";
                _whereClause = "LM.ListName = 'FiftyStates' And LD.fListMasterID = LM.pListMasterID  order by SequenceNo asc";
                DataSet dsType = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsType.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }

       
        #endregion

        #region Notes
        

        public DataTable GetNotesType()
        {
            try
            {
                _tableName = "ListMaster LM ,ListDetail LD";
                _columnName = "(LD.ListdtlDesc) as ListDesc,LD.ListValue ";
                _whereClause = "LM.ListName = 'CustomerNotesType' And LD.fListMasterID = LM.pListMasterID  order by SequenceNo asc";
                DataSet dsType = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsType.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable SelectNotes(string Notestype, string CustNo)
        {
            try
            {                 
                _tableName = "CustomerNotes";
                _columnName = "CONVERT(varchar(10), EntryDt, 101) AS EntryDt ,Notes,EntryID ";
                _whereClause = "Type= '" + Notestype + "' And CustomerNo = '" + CustNo + "' order by EntryDt desc,  pCustomerNotesID desc";
                DataSet dsType = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsType.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public void InsertCustNotes(string _columnValue)
        {
            try
            {
                //pCustomerNotesID, fCustomerMasterID, CustomerNo, Type, Notes, EntryID, EntryDt, ChangeID, ChangeDt, StatusCd, FROM         CustomerNotes
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "[pSOEInsert]",
                         new SqlParameter("@tableName", "CustomerNotes"),
                         new SqlParameter("@columnNames", "fCustomerMasterID, CustomerNo, Type, Notes, EntryID, EntryDt"),
                         new SqlParameter("@columnValues", _columnValue));
            }
            catch (Exception ex)
            {

            }
        }
        #endregion
    }    

}