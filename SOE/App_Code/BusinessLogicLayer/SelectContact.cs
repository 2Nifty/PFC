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
/// Summary description for SelectContact
/// </summary>
namespace PFC.SOE.BusinessLogicLayer
{
    public class SelectContact
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string tableName = "";
        string columnName = "";
        string whereClause = "";
        public DataTable GetContacts(string custNo)
        {
            try
            {

                
                tableName="dbo.CustomerAddress INNER JOIN dbo.CustomerMaster ON dbo.CustomerAddress.fCustomerMasterID = dbo.CustomerMaster.pCustMstrID INNER JOIN dbo.CustomerContact ON dbo.CustomerAddress.pCustomerAddressID =dbo.CustomerContact.fCustAddrID";
                columnName = "(case  when dbo.CustomerAddress.Type='p' then 'Sold To' else 'Bill To' end ) as [ContactType] ,dbo.CustomerContact.CustNo,dbo.CustomerContact.Name,dbo.CustomerContact.FaxNo,  dbo.CustomerContact.EmailAddr";
                whereClause = " CustomerMaster.CustNo='" + custNo.Trim()+ "'";
                DataSet dsContact = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                              new SqlParameter("@tableName", tableName),
                                              new SqlParameter ("@columnName",columnName ),
                                              new SqlParameter ("@whereClause",whereClause ));
                return dsContact.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }


        }
        
    }
}
