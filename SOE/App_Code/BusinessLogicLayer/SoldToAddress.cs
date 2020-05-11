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
    public class SoldToAddress
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string _tableName = "";
        string _columnName = "";
        string _whereClause = "";

        #region CommentEntry

        public DataTable GetAllCustomer(string customerNumber)
        {
            try
            {
                _tableName = "CustomerContact";
                _columnName = "pCustContactsID,[Name],JobTitle,Department,Phone,PhoneExt,FaxNo,MobilePhone,EmailAddr," +
                                "EntryID,convert(char(10),EntryDt,101) as EntryDt,ChangeID,convert(char(10),ChangeDt,101) as ChangeDt,convert(char(10),DeleteDt,101) as DeleteDt,fCustAddrID";

                _whereClause = " CustNo='" + customerNumber + "'";
                DataSet dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));

                return dsResult.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetCustomerDefaultAddress(string soNumber)
        {
            try
            {
                _tableName = HttpContext.Current.Session["OrderTableName"].ToString();
                _columnName =   "fsoheaderID,SellToCustNo,SellToCustName,SellToAddress1,SellToAddress2,SellToCity," +
                                "SellToState,SellToZip,SellToCountry,SellToContactName,SellToContactPhoneNo,SellToContactID";

                _whereClause = " OrderNo='" + soNumber + "'";
                DataSet dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                
                return dsResult.Tables[0];

            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetDefaultContact(string customerNumber)
        {
            try
            {
                _tableName = "CustomerContact";
                _columnName = "JobTitle,Department,PhoneExt,FaxNo,MobilePhone,EmailAddr,[Name],Phone,fCustAddrID,CustNo,pCUstContactsID";
                _whereClause = "CustNo='" + customerNumber + "' and ContactCd='P'";

                DataSet dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));

                return dsResult.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetContactInfoByContactID(string contactID)
        {
            try
            {
                _tableName = "CustomerContact";
                _columnName = "JobTitle,Department,PhoneExt,FaxNo,MobilePhone,EmailAddr,[Name],Phone,fCustAddrID,CustNo,pCUstContactsID";
                _whereClause = "pCUstContactsID='" + contactID + "'";

                DataSet dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));

                return dsResult.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetContactDetail(string pContactID)
        {
            try
            {
                _tableName = "CustomerContact";
                _columnName = "JobTitle,Department,PhoneExt,FaxNo,MobilePhone,EmailAddr,[Name],Phone,fCustAddrID,CustNo,pCUstContactsID";
                _whereClause = "pCUstContactsID='" + pContactID + "'";

                DataSet dsResult = SqlHelper.ExecuteDataset(ERPConnectionString,"pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));

                return dsResult.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public string AddNewContact(string columnValue)
        {
            try
            {
                string contactID = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOEGetIdentityAfterInsert",
                                            new SqlParameter("@tableName", "CustomerContact"),
                                            new SqlParameter("@columnNames", "fCustAddrID,JobTitle,Department,PhoneExt,FaxNo,MobilePhone,EmailAddr,Name,Phone,CustNo,ContactCd,EntryID,EntryDt"),
                                            new SqlParameter("@columnValues", columnValue)).ToString();
                return contactID;
            }
            catch (Exception ex)
            {
                throw ex;
            }        
        }

        public void UpdateSOHeaderContactInformation(string columnValue, string whereClause)
        {
            try
            {
                string tableName = HttpContext.Current.Session["OrderTableName"].ToString();

                SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "[pSOEUpdate]",
                                    new SqlParameter("@tableName", tableName),
                                    new SqlParameter("@ColumnValues", columnValue),
                                    new SqlParameter("@WhereClause", whereClause));                
            }
            catch (Exception ex)
            {
                throw ex;
            }            
        }

        public bool IsContactNameAvailable(string customerNumber,string contactName)
        {
            try
            {
                _tableName = "CustomerContact";
                _columnName = "Count(*)";
                _whereClause = " CustNo='" + customerNumber + "' And [Name]='" + contactName.Trim().Replace("'","''") + "'";

                string _result = SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause)).ToString();
                if (Convert.ToInt32(_result) > 0)
                {
                    return false;
                }

                return true;

            }
            catch (Exception ex)
            {
                return true;
            }

        }

        #endregion

    }    
}