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
/// Summary description for ShipToinformation
/// </summary>
public class ShipToInformation
{
    string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
    string _tableName = "";
    string _columnName = "";
    string _whereClause = "";

    #region Ship to address

    public DataTable GetContactInfoByContactName(string contactName)
    {
        try
        {
            _tableName = "CustomerContact";
            _columnName = "JobTitle,Department,PhoneExt,FaxNo,MobilePhone,EmailAddr,[Name],Phone,fCustAddrID,CustNo";
            _whereClause = "Name='" + contactName + "'";

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
            _columnName = "JobTitle,Department,PhoneExt,FaxNo,MobilePhone,EmailAddr,[Name],Phone,fCustAddrID,CustNo,pCustContactsID";

            _whereClause ="CustNo='" + customerNumber + "' and ContactCd='P'";

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

    public DataTable GetCustomerContacts(string custAddrID, bool isSingle)
    {
        try
        {
            _tableName = "CustomerContact";
            _columnName = "pCustContactsID,[Name],JobTitle,Department,Phone,PhoneExt,FaxNo,MobilePhone,EmailAddr," +
                            "EntryID,convert(char(10),EntryDt,101) as EntryDt,ChangeID,convert(char(10),ChangeDt,101) as ChangeDt,convert(char(10),DeleteDt,101) as DeleteDt,fCustAddrID";

            if (isSingle)
                _whereClause = " pCustContactsID='" + custAddrID + "'";
            else
                _whereClause = " fCustAddrID='" + custAddrID + "'";
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

    public DataTable GetCustomerAddresses(string customerNumber,bool isSingle)
    {
        try
        {
            _tableName = "CustomerAddress";
            _columnName = "pCustomerAddressID,Name1 as Name, AddrLine1 as Address1, AddrLine2 as Address2,City,State, PostCd as PostCode, PhoneNo, Country ," +
                            "EntryID,convert(char(10),EntryDt,101) as EntryDt,ChangeID,convert(char(10),ChangeDt,101) as ChangeDt";
            if (isSingle)
                _whereClause = "pCustomerAddressID="+customerNumber;
            else                
                _whereClause = "fCustomerMasterID = (select pCustMstrID from CustomerMaster where CustNo='" + customerNumber + "') and Type='SHP'";
            
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
            _columnName = "fsoheaderID,SellToCustNo,ShipToName,ShipToAddress1,ShipToAddress2,City," +
                     "State,Zip,Country,ContactName,PhoneNo,ShipToContactID,ShipToCd";
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

    public void UpdateCustomerContact(string columnValue, string whereClause)
    {
        try
        {
            string tableName = "CustomerContact";

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

    public string AddNewAddress(string columnValue)
    {
        try
        {
            string contactID = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOEGetIdentityAfterInsert",
                                        new SqlParameter("@tableName", "CustomerAddress"),
                                        new SqlParameter("@columnNames", "[Type],[fCustomerMasterID],[Name1],[AddrLine1],[AddrLine2],[City],[State],[PostCd],[Country],[PhoneNo],EntryID,EntryDt"),
                                        new SqlParameter("@columnValues", columnValue)).ToString();
            return contactID;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    public void UpdateCustomerAddress(string columnValue, string whereClause)
    {
        try
        {
            string tableName = "CustomerAddress";

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
    #endregion
}
