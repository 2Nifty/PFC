/********************************************************************************************
 * File	Name			:	EnterExpense.aspx.cs
 * File Type			:	C#
 * Project Name			:	Sales Order Entry
 * Module Description	:	Enter Expense for orders
 * Created By			:	Sathya Ramasamy
 * Created Date			:	10/27/2008	
 * History*				: 
 * DATE					AUTHOR			                ACTION
 * ****					******				            ******
 * 10/27/2008           Sathya Ramasamy                 Created
 *********************************************************************************************/
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
using PFC.POE.DataAccessLayer;

/// <summary>
/// Summary description for ExpenseEntry
/// </summary>
namespace PFC.POE.BusinessLogicLayer
{   

    public class ExpenseEntry
    {
        //For Security Code
        string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";

        // Connection String
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        string _tableName = "";
        string _columnName = "";
        string _whereClause = "";
        string _expenseTable = "POExpense";

        public string HeaderIDColumn
        {
            get
            {
                    return "fPOHeaderID";
            }
        }

        public string ExpenseID
        {
            get
            {
                    return "pPOExpenseID";
            }
        }
        public string ExpenseTableName
        {
            get
            {
                    return "POExpense";
            }
        }

        public ExpenseEntry()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        #region Enter Expense
        /// <summary>
        /// GetExpenseCode used to get Expense code list 
        /// </summary>
        /// <returns>DataTable with TableCd columns</returns>
        public DataTable GetExpenseCode()
        {
            try
            {
                _tableName = "Tables";
                _columnName = "TableCd,TableCd + ' - ' + ShortDsc as ShortDsc";
                _whereClause = "TableType='EXP' and POApp='Y'";
                DataSet dsExpenseCode = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsExpenseCode.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        /// <summary>
        /// GetExpenseCodeDetail Used for getting expense code detail based on the expenseCode 
        /// </summary>
        /// <param name="expenseCode">Selected Expense Code</param>
        /// <returns>DataTable with Dsc,Pct,TaxStatus,ExpType columns </returns>
        public DataTable GetExpenseCodeDetail(string expenseCode)
        {
            try
            {
                _tableName = "Tables";
                _columnName = "Dsc as Description,Pct as [Percent],TaxStatus,ExpType";
                _whereClause = "TableCd = '" + expenseCode + "' and TableType='EXP' and POApp='Y'";
                DataSet dsExpenseCode = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsExpenseCode.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        /// <summary>
        /// GetSOExpense Used for getting expense detail based on Sales order Number
        /// </summary>
        /// <param name="salesOrderNumber">Sales order number</param>
        /// <returns>DataTable with columns [pSOExpenseID],[LineNumber],[ExpenseNo],
        /// [ExpenseCd],[Amount],[Cost],[ExpenseInd],[TaxStatus],[DeliveryCharge],[HandlingCharge],[PackagingCharge],
        /// [MiscCharge],[PhoneCharge],[DocumentLoc],[DeleteDt],[EntryID],[EntryDt],[ChangeID],[ChangeDt],[StatusCd],[Dsc]</returns>
        public DataSet GetPOExpense(string purchaseOrderNumber)
        {
            try
            {
               
                _columnName = ExpenseID +" as [pPOExpenseID],[LineNumber],[ExpenseNo],[ExpenseCd],[Amount],[Cost],[ExpenseInd],[TaxStatus],[DeliveryCharge],[HandlingCharge],[PackagingCharge],[MiscCharge],[PhoneCharge],[DocumentLoc],convert(char(10),[DeleteDt],101) as [DeleteDt] ,[EntryID],convert(char(10),[EntryDt],101) as [EntryDt],[ChangeID],convert(char(10),[ChangeDt],101) as [ChangeDt],[StatusCd],ExpenseDesc as Dsc";
                _whereClause = HeaderIDColumn+"='" + purchaseOrderNumber + "'";
                DataSet dsPOExpense = SqlHelper.ExecuteDataset(ERPConnectionString, "[pSOESelect]",
                         new SqlParameter("@tableName", ExpenseTableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                                     
                return dsPOExpense;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        /// <summary>
        /// Method user to insert expense detail
        /// </summary>
        /// <param name="columnValue">Column value</param>
        public void InsertPOExpense(string _columnValue)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "[pSOEInsert]",
                         new SqlParameter("@tableName", ExpenseTableName),
                         new SqlParameter("@columnNames", HeaderIDColumn + ",LineNumber,ExpenseCd,Amount,ExpenseInd,TaxStatus,EntryID,EntryDt,ExpenseDesc"),
                         new SqlParameter("@columnValues", _columnValue));

            }
            catch (Exception ex)
            {

            }
        }
        /// <summary>
        /// Method used to update soexpense 
        /// </summary>
        /// <param name="columnValue">Column values</param>
        /// <param name="whereClause">Condition</param>
        public void UpdatePOExpense(string _columnValue, string expenseID)
        {
            try
            {
                _whereClause = ExpenseID + "=" + expenseID;
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "[pSOEUpdate]",
                                        new SqlParameter("@tableName", ExpenseTableName),
                                             new SqlParameter("@columnNames",_columnValue),
                                             new SqlParameter("@whereClause", _whereClause));
            }
            catch (Exception ex)
            {
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="expenseID"></param>
        /// <returns></returns>
        public DataTable GetExpenseDetail(String expenseID)
        {
            try
            {
                _whereClause = ExpenseID+"= " + expenseID;
                DataSet dsSalesOrderDetails = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", ExpenseTableName),
                                    new SqlParameter("@columnNames", ExpenseID+" as [pSOExpenseID],[LineNumber],[ExpenseCd],[Amount],[Cost],[ExpenseInd],[TaxStatus],[StatusCd],ExpenseDesc as Dsc"),
                                    new SqlParameter("@whereClause", _whereClause));

                return dsSalesOrderDetails.Tables[0];
            }
            catch (Exception ex)
            {

                return null;
            }
        }

        public DataTable GetExpensePrint(string purchaseOrderNumber)
        {
            try
            {

                string tableName = "POExpense";
                    _whereClause = "fPOHeaderID= " + purchaseOrderNumber;
                
       
                DataSet dsSalesOrderDetails = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", tableName),
                                    new SqlParameter("@columnNames", "[LineNumber] as 'Line',[ExpenseCd] as 'Code',[ExpenseDesc] as 'Description',[Amount] as 'Amount',[TaxStatus] as 'Taxable',[Cost],[ExpenseInd] as 'Indicator',convert(char(10),[Deletedt],101) as 'Delete Date',convert(char(10),EntryDt,101) as 'Entry Date',EntryID as 'Entry ID',convert(char(10),ChangeDt,101) as 'Change Date',ChangeID as 'Change ID'"),
                                    new SqlParameter("@whereClause", _whereClause));

                return dsSalesOrderDetails.Tables[0];
            }
            catch (Exception ex)
            {

                return null;
            }
        }

        public string GetAmount(string poNumber)
        {  try
            {
                string tableName = "POHeader";
                 _whereClause = "pPOHeaderID= " + poNumber;

                       object objAmount =(object) SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                                               new SqlParameter("@tableName", tableName),
                                               new SqlParameter("@columnNames", "[TotalCost] as 'Total'"),
                                               new SqlParameter("@whereClause", _whereClause));
                if(objAmount!=null)
                    return objAmount.ToString().Trim();
                else
                    return "";
            }
          catch (Exception Ex) { return ""; }
        }
        #endregion


        #region Security Code
        /// <summary>
        /// Public Method user to get User security code
        /// </summary>
        /// <param name="userName">Parameter:username</param>
        /// <returns>User security code</returns>
        public string GetSecurityCode(string userName)
        {
            try
            {
                object objSecurityCode = (object)SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and SU.UserName='" + userName + "' AND (SG.groupname='POE(W)' OR  SG.groupname='ENTRY(W)')"));

                if (objSecurityCode != null)
                    return objSecurityCode.ToString().Trim();
                else
                    return "";

            }
            catch (Exception Ex) { return ""; }
        }
        #endregion
    }
}
