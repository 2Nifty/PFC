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
using PFC.SOE.DataAccessLayer;
/// <summary>
/// Summary description for ExpenseEntry
/// </summary>
namespace PFC.SOE.BusinessLogicLayer
{   

    public class SOEFind
    {
        // Connection String
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        string _tableName = "";
        string _columnName = "";
        string _whereClause = "";

        public SOEFind()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        #region Fill Drop Down
        /// <summary>
        /// GetSOFindSearch used to get So Search list 
        /// </summary>
        /// <returns>DataTable with TableCd columns</returns>
        public DataTable GetSOFindSearch(string mode)
        {
            try
            {
                
                _tableName = "ListMaster LM ,ListDetail LD";
                _columnName = "(LD.ListdtlDesc) as ListDesc,LD.ListValue ";
                _whereClause = "LM.ListName = '" + mode + "' And LD.fListMasterID = LM.pListMasterID  order by SequenceNo asc";
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
        /// <summary>
        /// GetSOFindSearch used to get So Search list 
        /// </summary>
        /// <returns>DataTable with TableCd columns</returns>
        public DataTable GetSOSearch(string mode)
        {
            try
            {

                _tableName = "ListMaster LM ,ListDetail LD";
                _columnName = "(rtrim(LD.ListValue)) as ListValue,(rtrim(LD.ListValue) + ' - ' + LD.ListdtlDesc) as ListDesc";
                _whereClause = "LM.ListName = '" + mode + "' And LD.fListMasterID = LM.pListMasterID  order by SequenceNo asc";
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
                
        public DataTable ValidateCustomer(string customerNumber)
        {

            try
            {
                _tableName = "CustomerMaster (NOLOCK) left outer join RepMaster (NOLOCK) on CustomerMaster.SlsRepNo = RepMaster.RepNo";
                _columnName = "ContractNo,SlsRepNo,CustNo,RepName,PriceCd";
                _whereClause = "CustNo='" + customerNumber.Trim()+"' or CustSearchKey='" + customerNumber.Trim() + "'";
                
            
                DataSet dsCustomer = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsCustomer.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetSalesOrder(string whereClause, string tableName)
        {

            try
            {
                string columnName = "ShipLoc as ShipLoc,OrderNo as SoNo,InvoiceNo as InvoiceNo,CustPONo as PORef,isnull(NetSales,0) as Amount," +
                                        "isnull(ShipWght,0) as Weight,OrderType as 'Type',convert(char(10),ConfirmShipDt,101) as CShipDate," +
                                        "convert(char(10),OrderDt,101) as OrderDate,convert(char(10),CustReqDt,101) as CustReq,convert(char(10),SchShipDt,101) as SchShipDt," +
                                        "StatusCd =	Case	" +
                                        " WHEN isnull(DeleteDt,'') <>'' THEN 'Deleted'" +
                                        " WHEN isnull(InvoiceDt,'') <> '' THEN 'Invoiced'" +
                                        " WHEN isnull(HoldDt,'') <> '' THEN HoldReason +' ' + convert(char(10),HoldDt,101)" +
                                        " WHEN isnull(MakeOrderDt,'') <>'' AND isnull(AllocDt ,'') ='' THEN 'Make Order'	" +
                                        " WHEN isnull(RlsWhseDt,'') ='' AND isnull(AllocDt ,'') ='' THEN 'Action Req'	" +
                                        " WHEN isnull(RlsWhseDt,'') <>'' AND isnull(AllocDt ,'') <>'' THEN 'Warehouse'	" +
                                        " WHEN isnull(MakeOrderDt,'') <>'' AND isnull(AllocDt ,'') ='' AND isnull(AllocRelDt ,'') <>'' AND isnull(RlsWhseDt,'') ='' THEN 'Allocating'	" +
                                        " WHEN isnull(MakeOrderDt,'') <>'' AND isnull(AllocDt ,'') <>'' AND isnull(AllocRelDt ,'') <>'' AND isnull(RlsWhseDt,'') ='' AND isnull(PickDt ,'') ='' and isnull(HoldDt,'') = '' THEN 'Allocated'	" +
                                        " WHEN isnull(AllocDt,'') <>'' AND isnull(RlsWhseDt,'') <>'' AND isnull(PickDt ,'') <>'' THEN 'Warehouse'	" +                                                            
                                        " END," +
                                        "OrderCarrier as Carrier,SellToCustNo as CustomerNo,SellToCustName,RefSONo,cast(OrderNo as varchar(100))+'W' as OrderID";

                //if (tableName.Trim().ToLower() == "soheaderhist")
                //    columnName = "ShipLoc as ShipLoc,OrderNo as SoNo,InvoiceNo as InvoiceNo,PORefNo as PORef,isnull(NetSales,0) as Amount,isnull(ShipWght,0) as Weight,OrderType as 'Type',convert(char(10),ConfirmShipDt,101) as CShipDate,convert(char(10),OrderDt,101) as OrderDate,convert(char(10),CustReqDt,101) as CustReq,isnull(OrderStatus,'SO') as OrderStatus,OrderCarrier as Carrier,SellToCustNo as CustomerNo,cast(OrderNo as varchar(100)) as OrderID";

                DataSet dsSalesOrder = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", tableName + " NOLOCK "),
                                    new SqlParameter("@columnNames", columnName),
                                    new SqlParameter("@whereClause", whereClause));

                return dsSalesOrder.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public DataTable GetShiplocation()
        {
            try
            {

                _tableName = "LocMaster NOLOCK ";
                _columnName = "LOCID as Code,LOCID + ' - ' + [LocName] as Name";
                _whereClause = "Loctype in ('B','S')";
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
        public DataTable GetUser()
        {
            try
            {

                _tableName = "SecurityUsers";
                _columnName = "UserName as Code,UserName as Name";
                _whereClause = "1=1 Order By UserName";
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
        /// <summary>
        /// Display Order Type not belongs to sub type 99
        /// </summary>
        /// <returns></returns>
        public DataTable GetSOFindOrderTypes()
        {
            try
            {
                string _tableName = " listmaster,listdetail ";
                string _columnName = "ListValue as Code,ListValue +' - '+ListDtlDesc as Name ";
                string _whereClause = " listmaster.pListMasterID =listdetail.fListMasterID and listmaster.ListName='SOEOrderTypes' and listdetail.SequenceNo <>99 order by listdetail.ListValue ";


                DataSet dsCustomer = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsCustomer.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
      

      

        #endregion


    
    }
}
