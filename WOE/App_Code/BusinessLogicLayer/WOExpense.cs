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
using PFC.WOE.DataAccessLayer;

/// <summary>
/// Summary description for ExpenseEntry
/// </summary>
namespace PFC.WOE.BusinessLogicLayer
{
    //public enum MessageType
    //{
    //    Success,
    //    Failure
    //}

    public class WOExpense
    {
        string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";
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
                

        #region Enter Expense
        /// <summary>
        /// GetExpenseCode used to get Expense code list 
        /// </summary>
        /// <returns>DataTable with TableCd columns</returns>
        public DataTable GetExpenseCode()
        {
            return GetFormData("ddlExpenseType").Tables[0];
        }

        /// <summary>
        /// FindWO used to get Work order data
        /// </summary>
        /// <returns>DataTable with TableCd columns</returns>
        public DataSet FindWO(string WONumber)
        {
            return GetFormData("FindWO", WONumber);
        }

        /// <summary>
        /// FindPO used to get Expense PO data
        /// </summary>
        /// <returns>DataTable with TableCd columns</returns>
        public DataSet FindPO(string PONumber)
        {
            return GetFormData("FindPO", PONumber);
        }

        /// <summary>
        /// GetFormData used to execute the form stored procedure (overloaded)
        /// </summary>
        /// <returns>DataTable with TableCd columns</returns>
        public DataSet GetFormData(string ActionCode)
        {
            try
            {
                DataSet ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pWOExpenseFrm",
                                    new SqlParameter("@Action", ActionCode),
                                    new SqlParameter("@Filter", ""),
                                    new SqlParameter("@ExpenseCode", ""),
                                    new SqlParameter("@ExpenseDesc", ""),
                                    new SqlParameter("@ExpenseType", ""),
                                    new SqlParameter("@UnitCost", "0"),
                                    new SqlParameter("@TotalCost", "0"),
                                    new SqlParameter("@EntryID", ""),
                                    new SqlParameter("@fPOHeaderID", "0"));
                return ds;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public DataSet GetFormData(string ActionCode, string FilterData)
        {
            try
            {
                DataSet ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pWOExpenseFrm",
                                    new SqlParameter("@Action", ActionCode),
                                    new SqlParameter("@Filter", FilterData),
                                    new SqlParameter("@ExpenseCode", ""),
                                    new SqlParameter("@ExpenseDesc", ""),
                                    new SqlParameter("@ExpenseType", ""),
                                    new SqlParameter("@UnitCost", "0"),
                                    new SqlParameter("@TotalCost", "0"),
                                    new SqlParameter("@EntryID", ""),
                                    new SqlParameter("@fPOHeaderID", "0"));
                return ds;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public DataSet AddFormData(string ExpenseCode, string ExpenseDesc, string ExpenseType, decimal UnitCost, decimal TotalCost, string EntryID, string POHeaderID)
        {
            try
            {
                DataSet ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pWOExpenseFrm",
                                    new SqlParameter("@Action", "AddExpense"),
                                    new SqlParameter("@Filter", ""),
                                    new SqlParameter("@ExpenseCode", ExpenseCode),
                                    new SqlParameter("@ExpenseDesc", ExpenseDesc),
                                    new SqlParameter("@ExpenseType", ExpenseType),
                                    new SqlParameter("@UnitCost", UnitCost),
                                    new SqlParameter("@TotalCost", TotalCost),
                                    new SqlParameter("@EntryID", EntryID),
                                    new SqlParameter("@fPOHeaderID", POHeaderID));
                return ds;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public DataSet UpdateFormData(string pWOCompId, string ExpenseCode, string ExpenseDesc, string ExpenseType, decimal UnitCost, decimal TotalCost, string EntryID, string POHeaderID)
        {
            try
            {
                DataSet ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pWOExpenseFrm",
                                    new SqlParameter("@Action", "UpdateExpense"),
                                    new SqlParameter("@Filter", pWOCompId),
                                    new SqlParameter("@ExpenseCode", ExpenseCode),
                                    new SqlParameter("@ExpenseDesc", ExpenseDesc),
                                    new SqlParameter("@ExpenseType", ExpenseType),
                                    new SqlParameter("@UnitCost", UnitCost),
                                    new SqlParameter("@TotalCost", TotalCost),
                                    new SqlParameter("@EntryID", EntryID),
                                    new SqlParameter("@fPOHeaderID", POHeaderID));
                return ds;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public DataSet GetExpenseLineData(string pWOCompId)
        {
            try
            {
                DataSet ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pWOExpenseFrm",
                                    new SqlParameter("@Action", "GetExpenseLine"),
                                    new SqlParameter("@Filter", pWOCompId),
                                    new SqlParameter("@ExpenseCode", ""),
                                    new SqlParameter("@ExpenseDesc", ""),
                                    new SqlParameter("@ExpenseType", ""),
                                    new SqlParameter("@UnitCost", "0"),
                                    new SqlParameter("@TotalCost", "0"),
                                    new SqlParameter("@EntryID", ""),
                                    new SqlParameter("@fPOHeaderID", "0"));
                return ds;
            }
            catch (Exception ex)
            {
                throw;
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
                _whereClause = "TableCd = '" + expenseCode + "' and TableType='EXP' and WOApp='Y'";
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
                throw;
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

        public DataSet DeleteExpenseLine(string pWOCompId, string fPoHeaderID)
        {
            try
            {
                DataSet ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pWOExpenseFrm",
                                    new SqlParameter("@Action", "DeleteExpense"),
                                    new SqlParameter("@Filter", pWOCompId),
                                    new SqlParameter("@ExpenseCode", ""),
                                    new SqlParameter("@ExpenseDesc", ""),
                                    new SqlParameter("@ExpenseType", ""),
                                    new SqlParameter("@UnitCost", "0"),
                                    new SqlParameter("@TotalCost", "0"),
                                    new SqlParameter("@EntryID", ""),
                                    new SqlParameter("@fPOHeaderID", fPoHeaderID));
                return ds;
            }
            catch (Exception ex)
            {
                throw;
            }
        }

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

        public void DisplayMessage(MessageType messageType, string messageText, Label lblMessage)
        {
            switch (messageType)
            {
                case MessageType.Success:
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    break;
                case MessageType.Failure:
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    break;
            }

            lblMessage.Text = messageText;
            lblMessage.Visible = true;
        }
    }
}
