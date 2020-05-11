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
/// Summary description for SalesOrderDetails
/// </summary>
/// 
namespace PFC.SOE.BusinessLogicLayer
{
    public class SalesOrderDetails
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string _tableName = "";
        string _columnName = "";
        string _whereClause = "";



        #region Sub Header
        public DataTable GetSalesOrderDetails(string tableName, string columnName, string whereClause)
        {
            try
            {
                DataSet dsSalesOrderDetails = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", tableName),
                                    new SqlParameter("@columnNames", columnName),
                                    new SqlParameter("@whereClause", whereClause));

                return dsSalesOrderDetails.Tables[0];
            }
            catch (Exception ex)
            {

                return null;
            }
        }


  
        #endregion

        #region SubHeader ShipTO Details
        public DataTable GetShipToDetails(string SoNumber)
        {
            try
            {
                _tableName = "";
                _columnName = "Name2,AddrLine1,City,State,Country,PostCd,ContactPhoneNo";
                _whereClause = "fRelatedToID='" + SoNumber + "'";
                DataSet dsShipToDetails = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));

                return dsShipToDetails.Tables[0];
            }
            catch (Exception ex)
            {

                return null;
            }

        }

        #endregion

        # region Comment Entry

        /// <summary>
        /// GetType used to get Comment Type
        /// </summary>
        /// <returns>DataTable with ListdtlDesc,ListValue columns</returns>
        public DataTable GetType()
        {
            try
            {
                _tableName = "ListMaster LM ,ListDetail LD";
                _columnName = "LD.ListdtlDesc ";
                _whereClause = "LM.ListName = 'SOCommentsType' And LD.fListMasterID = LM.pListMasterID";
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
        # endregion


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
                _columnName = "TableCd";
                _whereClause = "TableType='EXP' and SOApp='Y'";
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
                _whereClause = "TableCd = '" + expenseCode + "' and TableType='EXP' and SOApp='Y'";
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
        public DataSet GetSOExpense(string salesOrderNumber)
        {
            try
            {

                DataSet dsSOExpense = SqlHelper.ExecuteDataset(ERPConnectionString, "[pSOExpenseSelect]",
                                    new SqlParameter("@SalesOrderNumber", salesOrderNumber));
                return dsSOExpense;
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
        public void InsertSOExpense(string columnValue)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "[pSOExpenseInsert]",
                                    new SqlParameter("@ColumnValues", columnValue));
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
        public void UpdateSOExpense(string columnValue, string whereClause)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "[pSOExpenseUpdate]",
                                    new SqlParameter("@ColumnValues", columnValue),
                                    new SqlParameter("@WhereClause", whereClause));
            }
            catch (Exception ex)
            {
            }
        }
        public DataTable GetExpenseDetail(String expenseID)
        {
            try
            {
                _whereClause = "SOEX.[pSOExpenseID]= " + expenseID + " and SOEX.ExpenseCd=TBL.TableCd and TBL.TableType='EXP'";
                DataSet dsSalesOrderDetails = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", "[dbo].[SOExpense] SOEX,Tables TBL"),
                                    new SqlParameter("@columnNames", "SOEX.[pSOExpenseID],SOEX.[LineNumber],SOEX.[ExpenseCd],SOEX.[Amount],SOEX.[Cost],[ExpenseInd],SOEX.[TaxStatus],SOEX.[StatusCd],[Dsc]"),
                                    new SqlParameter("@whereClause", _whereClause));

                return dsSalesOrderDetails.Tables[0];
            }
            catch (Exception ex)
            {

                return null;
            }
        }



        #endregion


        // Gaja Added

        public DataTable GetShippingMarks(String SoNumber)
        {
            try
            {
                _tableName = " soHeader ";
                _columnName = "ShippingMark1,ShippingMark2,ShippingMark3,ShippingMark4,Remarks,ShipInstrCdName,ShipInstrCd,SellToCustName,SellToCustNo";
                _whereClause = "pSOHeaderID='" + SoNumber + "'";
                DataSet dsSalesOrderDetails = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsSalesOrderDetails.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public void UpdateShippingMarks(string columnValues, string SoNumber)
        {
            try
            {
                _tableName = " soHeader ";
                _whereClause = "pSOHeaderID='" + SoNumber + "'";
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "pSOEUpdate",
                             new SqlParameter("@tableName", _tableName),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", _whereClause));
            }
            catch (Exception ex)
            {

            }
        }
        public DataTable GetContacttype()
        {
            try
            {
                string _whereClause = "a.pListMasterID=b.fListMasterID and a.ListName='SOEShipInstr' Order by b.SequenceNo";
                string _tableName = "listmaster a,ListDetail b ";
                string _columnName = "b.ListValue as ListValue,b.ListDtlDesc as ListDtlDesc";

                DataSet dslist = new DataSet();
                dslist = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));

                return dslist.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        public DataSet GetShippingMarksExport(String SoNumber)
        {
            try
            {
                _tableName = " soHeader ";
                _columnName = "pSOHeaderID,ShippingMark1,ShippingMark2,ShippingMark3,ShippingMark4,Remarks,ShipInstrCdName,ShipInstrCd,SellToCustNo,SellToCustName,SellToAddress1,SellToAddress2,SellToAddress3,SellToCity,SellToState,SellToZip,SellToProvidence,SellToCountry,SellToContactName,SellToContactPhoneNo,ShipToCd,ShipToName,ShipToAddress1,ShipToAddress2,ShipToAddress3,City,State,Country,CountryCD,Zip,PhoneNo,FaxNo,ContactName,ContactPhoneNo";
                _whereClause = "pSOHeaderID='" + SoNumber + "'";
                DataSet dsSalesOrderDetails = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsSalesOrderDetails;
            }
            catch (Exception ex)
            {
                return null;
            }
        }


    }
}
