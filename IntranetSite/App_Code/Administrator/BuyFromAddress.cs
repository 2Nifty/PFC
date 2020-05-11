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
using PFC.Intranet.DataAccessLayer;

/// <summary>
/// Summary description for SOCommentEntry
/// </summary>
namespace PFC.POE.BusinessLogicLayer
{
    public class BuyFromAddress
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string _tableName = "";
        string _columnName = "";
        string _whereClause = "";

        public DataTable GetAllCustomer(string fvendorAddrId)
        {
            try
            {
                _tableName = "VendorContact";
                _columnName = "pVendContactID,[Name],JobTitle,Department,Phone,PhoneExt,FaxNo,MobilePhone,EmailAddr," +
                                "EntryID,convert(char(10),EntryDt,101) as EntryDt,ChangeID,convert(char(10),ChangeDt,101) as ChangeDt,convert(char(10),DeleteDt,101) as DeleteDt,fVendAddrID";

                _whereClause = " fVendAddrID='" + fvendorAddrId + "'";
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

        public DataTable GetCustomerDefaultAddress(string poNumber)
        {
            try
            {
                _columnName =   HttpContext.Current.Session["POHeaderColumnName"].ToString() + " as pPOheaderID,BuyFromVendorNo,BuyFromName,BuyFromAddress,BuyFromAddress2,BuyFromCity," +
                                "BuyFromState,BuyFromZip,BuyFromCountry,OrderContactName,OrderContactPhoneNo,buyFromContactId";
                _whereClause =  " POOrderNo='" + poNumber + "'";

                DataSet dsResult = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", HttpContext.Current.Session["POHeaderTableName"].ToString()),
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
                _tableName = "VendorContact";
                _columnName = "JobTitle,Department,PhoneExt,FaxNo,MobilePhone,EmailAddr,[Name],Phone,fVendAddrID,pVendContactID";
                _whereClause = "pVendContactID='" + contactID + "'";

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

        public string AddNewContact(string columnValue)
        {
            try
            {
                string contactID =  SqlHelper.ExecuteScalar(ERPConnectionString, "pSOEGetIdentityAfterInsert",
                                    new SqlParameter("@tableName", "VendorContact"),
                                    new SqlParameter("@columnNames", "fVendAddrID,JobTitle,Department,PhoneExt,FaxNo,MobilePhone,EmailAddr,Name,Phone,EntryID,EntryDt"),
                                    new SqlParameter("@columnValues", columnValue)).ToString();
                return contactID;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetContactDetail(string pContactID)
        {
            try
            {
                _tableName = "VendorContact";
                _columnName = "JobTitle,Department,PhoneExt,FaxNo,MobilePhone,EmailAddr,[Name],Phone,fVendAddrID,pVendContactID";
                _whereClause = "pVendContactID='" + pContactID + "'";

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

        public void UpdatePOHeaderContactInformation(string columnValue, string whereClause)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "[pSOEUpdate]",
                                    new SqlParameter("@tableName", HttpContext.Current.Session["POHeaderTableName"].ToString()),
                                    new SqlParameter("@ColumnValues", columnValue),
                                    new SqlParameter("@WhereClause", whereClause));                
            }
            catch (Exception ex)
            {
                throw ex;
            }            
        }

    }    
}