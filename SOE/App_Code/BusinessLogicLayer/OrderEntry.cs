using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.SOE.DataAccessLayer;
namespace PFC.SOE.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for OrderEntry
    /// </summary>
    public class OrderEntry
    {
        //For Security Code
        string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";

        public OrderEntry()
        {
            //
            // TODO: Add constructor logic here
            //
        }
        #region Enumarator declaration

        public enum ItemNumberType
        {
            CustomerItemNumber,
            PFCItemNumber,
        }

        #endregion

        #region Variable Declaration
        //
        // Constant declaration
        //
        private const string SP_SELECT = "DTQ_SP_SELECT";
        private const String SP_GETPFCPRODUCTDETAILS = "[pSOEGetItemAlias]";
       // private const String SP_GETCUSTPRODUCTDETAILS = "DTQ_SP_GetCustProductDetails";
        //private const String SP_GETQUANTITYDETAILS = "DTQ_SP_GetItem_LocationAndQuantity";
        //
        // variable declaration
        //
        private string spName = string.Empty;
        #endregion

        #region Methods

      

        public string GetIdentityAfterInsert(string tableName, string columnName, string columnValue)
        {
            try
            {
                object _objIdentity = (object)SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOEGetIdentityAfterInsert",
                                                          new SqlParameter("@tableName", tableName),
                                                          new SqlParameter("@columnNames", columnName),
                                                          new SqlParameter("@columnValues", columnValue));
                return _objIdentity.ToString();
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public DataSet ExecuteERPSelectQuery(string tableName, string columnName, string whereCaluse)
        {
            try
            {
                DataSet dsSelect = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOESelect",
                                                 new SqlParameter("@tableName", tableName),
                                                 new SqlParameter("@columnNames", columnName),
                                                 new SqlParameter("@whereClause", whereCaluse));
                return dsSelect;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }
        public DataSet ExecuteListSelectQuery(string tableName, string columnName, string whereCaluse)
        {
            try
            {
                DataSet dsSelect = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOESelect",
                                                 new SqlParameter("@tableName", tableName),
                                                 new SqlParameter("@columnNames", columnName),
                                                 new SqlParameter("@whereClause", whereCaluse));
                return dsSelect;
            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public string GetProfitStatus(string orderNo, string tableName)
        {
            try
            {
                SqlParameter[] arParms = new SqlParameter[8];
                arParms[0] = new SqlParameter("@SearchOrderNo", orderNo);
                arParms[1] = new SqlParameter("@HeaderTable", tableName);
                arParms[2] = new SqlParameter("@StatusOnly", "0");
                arParms[3] = new SqlParameter("@ProfitStatus", SqlDbType.VarChar, 20);
                arParms[4] = new SqlParameter("@NewLineDollars", "0");
                arParms[5] = new SqlParameter("@NewLineCOGS", "0");
                arParms[6] = new SqlParameter("@NewLineWeight", "0");
                arParms[7] = new SqlParameter("@NewLineCount", "0");
                arParms[3].Direction = ParameterDirection.Output;

                SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, CommandType.StoredProcedure, "[pSOEGetProfitabilty]", arParms);
                if (arParms[3] != null)
                    return arParms[3].Value.ToString();
                else
                    return "";
            }
            catch (Exception ex)
            {
                return "";
                throw;
            }
        }

        /// <summary>
        /// Function to update the new quote
        /// </summary>
        /// <param name="strTableName"></param>
        /// <param name="strColumnValue"></param>
        /// <param name="strWhere"></param>
        public DataSet SelectQuery(string tableName, string columnNames, string whereClause)
        {

            try
            {
                DataSet dsSelect = SqlHelper.ExecuteDataset(Global.PFCNavisionConnectionString, "DTQ_SP_SELECT",
                                                 new SqlParameter("@tableName", tableName),
                                                 new SqlParameter("@columnNames", columnNames),
                                                 new SqlParameter("@whereClause", whereClause));
                return dsSelect;
            }
            catch (Exception ex)
            {

                return null;
         
            
            
            }
        }
        /// <summary>
        /// Function used to return PFC Item details for given CustomerItemNo from Navision Database
        /// </summary>
        /// <param name="customerItemNo">Given Customer Item Number</param>
        /// <param name="customerNumber">Customer Number</param>
        /// <param name="ItemNumberType">Entered ItemType(PFC or Customer)</param>
        /// <returns>if valid CustomerItemNo then return PFC Item details else Null</returns> 
        public DataSet GetProductInfo(string ItemNumber, string CustomerNumber,string shipLoc,string itemType)
        {
            try
            {
                spName = SP_GETPFCPRODUCTDETAILS;
       
             
                DataSet productDetail = new DataSet();
                //
                // Fetch the product detail from navision database
                // 
                productDetail = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, SP_GETPFCPRODUCTDETAILS,
                                        new SqlParameter("@SearchItemNo", ItemNumber),
                                        new SqlParameter("@Organization", CustomerNumber),
                                        new SqlParameter("@PrimaryBranch", shipLoc),
                                        new SqlParameter("@SearchType", itemType));

                return productDetail; 
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                if ((ex.Number == 53) || (ex.Number == 18456))
                {
                    Exception sqlEx = new Exception("PFC Server is Unavailable!");
                    throw sqlEx;
                }
                else
                    throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// Function used to return PFC Item details for given CustomerItemNo from Navision Database
        /// </summary>
        /// <param name="customerItemNo">Given Customer Item Number</param>
        /// <param name="customerNumber">Customer Number</param>
        /// <param name="ItemNumberType">Entered ItemType(PFC or Customer)</param>
        /// <returns>if valid CustomerItemNo then return PFC Item details else Null</returns> 
        public DataSet GetProductPriceDetail(string orderID, string itemNumber, string customerNumber, string shipLoc, string HeaderTable, string detailTable, string reqQty, string CurPrice, string PriceOrigin, string priceCd)
        {
            try
            { 
                spName = "pSOEPrice";

                if (CurPrice.Trim().Length == 0) CurPrice = "0";
                DataSet productDetail = new DataSet();
                //
                // Fetch the product detail from navision database
                // 
                //productDetail = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEPrice]",
                //                        new SqlParameter("@orderid", orderID),
                //                        new SqlParameter("@v_order_line_no", "-1"),
                //                        new SqlParameter("@PassedItemNo", itemNumber),
                //                        new SqlParameter("@PassedSellToCustNo", customerNumber),
                //                        new SqlParameter("@PassedShipLoc", shipLoc),
                //                        new SqlParameter("@PassedHdrTable", HeaderTable),
                //                        new SqlParameter("@PassedDetTable", detailTable),
                //                        new SqlParameter("@PassedQty", reqQty),
                //                        new SqlParameter("@PassedPrice", decimal.Parse(CurPrice.Replace(",", ""))),
                //                        new SqlParameter("@PassedOrigin", PriceOrigin),
                //                        new SqlParameter("@v_price_code", priceCd));

                productDetail = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEGetPrice]",
                                        new SqlParameter("@orderid", orderID),
                                        new SqlParameter("@v_order_line_no", "-1"),
                                        new SqlParameter("@PassedItemNo", itemNumber),
                                        new SqlParameter("@PassedSellToCustNo", customerNumber),
                                        new SqlParameter("@PassedShipLoc", shipLoc),
                                        new SqlParameter("@PassedHdrTable", HeaderTable),
                                        new SqlParameter("@PassedDetTable", detailTable),
                                        new SqlParameter("@PassedQty", reqQty),
                                        new SqlParameter("@PassedPrice", decimal.Parse(CurPrice.Replace(",", ""))),
                                        new SqlParameter("@PassedOrigin", PriceOrigin),
                                        new SqlParameter("@v_price_code", priceCd),
                                        new SqlParameter("@Param1", "WQ"),
                                        new SqlParameter("@Param2", "SOE"), // Code to retrieve SOE promotions
                                        new SqlParameter("@Param3", ""),
                                        new SqlParameter("@Param4", ""),
                                        new SqlParameter("@Param5", ""),
                                        new SqlParameter("@Param6", "0"),
                                        new SqlParameter("@Param7", "0"),
                                        new SqlParameter("@Param8", "0"),
                                        new SqlParameter("@Param9", "0"),
                                        new SqlParameter("@Param10", "0"));

                return productDetail;
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                if ((ex.Number == 53) || (ex.Number == 18456))
                {
                    Exception sqlEx = new Exception("PFC Server is Unavailable!");
                    throw sqlEx;
                }
                else
                    throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
      
        /// <summary>
        /// Function to update the new quote
        /// </summary>
        /// <param name="strTableName"></param>
        /// <param name="strColumnValue"></param>
        /// <param name="strWhere"></param>
        public void UpdateQuote(string strTableName, string strColumnValue, string strWhere)
        {
            try
            {

                SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "pSOEUpdate",
                                             new SqlParameter("@tableName", strTableName),
                                             new SqlParameter("@columnNames", strColumnValue),
                                             new SqlParameter("@whereClause", strWhere));

            }
            catch (Exception ex)
            {

                throw;
            }
        }
        
        /// <summary>
        /// Function to get Customer Detail for given customer Number from Navision Database
        /// </summary>
        /// <param name="customerNumber">PFC customer number</param>
        /// <returns>Dataset : Valid customer information</returns>
        public DataSet GetCustomerDetails(string CustomerNumber)
        {
            try
            {
                //// Local variable declaration
                //string _tableName = "Porteous$Customer";
                //string _columnName = "[County] as Country,[Address],[Address 2],[Name],[Contact],[City],[Phone No_],[Fax No_],[E-Mail],[Post Code],[No_],[Usage Location]," +
                //                    "[Chain Name],[Shipping Agent Code],[Priority],[Payment Terms Code],[Shipment Method Code]," +
                //                    "[Salesperson Code] ,[Shipping Location],[Customer Price Code],[Free Freight]," +
                //                    "[Tax Area Code],[Country Code]";
                //string _whereClause = "[No_]='" + CustomerNumber + "'";



                //DataSet dsProduct = SqlHelper.ExecuteDataset(Global.PFCNavisionConnectionString, SP_SELECT,
                //                    new SqlParameter("@tableName", _tableName),
                //                    new SqlParameter("@columnNames", _columnName),
                //                    new SqlParameter("@whereCondition", _whereClause));

                DataSet dsCustomer = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOECustomerDetails]",
                                    new SqlParameter("@custNo", CustomerNumber));
                // Check whether any value has returned
                if (dsCustomer !=null && dsCustomer.Tables[0] != null && dsCustomer.Tables[0].Rows.Count > 0)
                    return dsCustomer;
                else
                    return null;
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                if ((ex.Number == 53) || (ex.Number == 18456))
                {
                    Exception sqlEx = new Exception("PFC Server is Unavailable!");
                    throw sqlEx;
                }
                else
                    throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }       
        #endregion

        /// <summary>
        /// Function to update the new quote
        /// </summary>
        /// <param name="strTableName"></param>
        /// <param name="strColumnValue"></param>
        /// <param name="strWhere"></param>
        public DataSet GetCustomerSelect(string customer)
        {
            try
            {
                DataSet dsCustomer = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEGetCustSel]",
                                                 new SqlParameter("@customer", customer));
                return dsCustomer;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public void InsertShipToAddress(string columnValue)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "pSOEInsert",
                                                         new SqlParameter("@tableName", "OneTimeShipToAddress"),
                                                         new SqlParameter("@columnNames", "[AddrType],[fRelatedToID],[AddrLine1],[Name2],[City],[State],[PostCd],[ContactPhoneNo],[EntryDt],[EntryID],[Country]"),
                                                         new SqlParameter("@columnValues", "'SOE'," + columnValue));
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public void UpdateNetSales(string SOID, string netSales,string netWght)
        {
            try
            {

                SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "pSOEUpdate",
                                             new SqlParameter("@tableName", HttpContext.Current.Session["OrderTableName"].ToString()),
                                             new SqlParameter("@columnNames", "NetSales='" + netSales + "',ShipWght='" + netWght  + "'"),
                                             new SqlParameter("@whereClause", "fSOHeaderID=" + SOID));

            }
            catch (Exception ex)
            {

                throw;
            }
        }

        public DataSet GetAvailableOrderType(string orderNumber)
        {
            try
            {
                DataSet dsResult = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOECheckOrderAvailability]",
                                    new SqlParameter("@orderNo", orderNumber));

                return dsResult;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public void MakeOrder(string soOrderID,string userName,string table,string holdCd)
        {
            try
            {  
                object obj;
                if (holdCd == "")
                    obj = DBNull.Value;
                else
                    obj = holdCd;

                // Recalculate the extended price
                //string reComputeProcedure = (table.ToLower() == "soheader" ? "[pSOERecomputePriceEntry]" : "[pSOERecomputePrice]");
                //string tableType = (table.ToLower() == "soheader" ? "ORDER" : "REL");
                //SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, reComputeProcedure,
                //                                         new SqlParameter("@orderID", soOrderID));

                //SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "[pSOEExt]",
                //                                         new SqlParameter("@orderID", soOrderID),
                //                                         new SqlParameter("@line", "0"),
                //                                         new SqlParameter("@type", "Sum"),
                //                                         new SqlParameter("@table", tableType));

                // make order
                SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "[pSOEMakeOrder]",
                                                         new SqlParameter("@orderID", soOrderID),
                                                         new SqlParameter("@userName", userName),
                                                         new SqlParameter("@table", table),
                                                         new SqlParameter("@holdCd", obj));
            }
            catch (Exception ex)
            { 
                throw;
            }
        }

        public void UpdateHeaderExtended(string soOrderID, string soLineNo, string table)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "[pSOEExt]",
                                                         new SqlParameter("@orderID", soOrderID),
                                                         new SqlParameter("@line", soLineNo),
                                                         new SqlParameter("@type", "ORDER"),
                                                         new SqlParameter("@table", table));
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public string GetCreditReview(string billtoCustomer, string creditInd, string orderID, string tableName)
        {

            try
            {
                SqlParameter[] arParms = new SqlParameter[5];
                arParms[0] = new SqlParameter("@custNo", billtoCustomer);
                arParms[1] = new SqlParameter("@creditCode", creditInd);
                arParms[2] = new SqlParameter("@orderID", orderID);
                arParms[3] = new SqlParameter("@table", tableName);
                arParms[4] = new SqlParameter("@msg", SqlDbType.VarChar, 100);
                arParms[4].Direction = ParameterDirection.Output;

                SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, CommandType.StoredProcedure, "[pSOEPerformCreditReview]", arParms);
                return arParms[4].Value.ToString();
            }
            catch (Exception ex)
            {
                return "";
            }
        }

        public string ReleaseOrder(string orderNo, string userName)
        {
            try
            {
                SqlParameter[] arParms = new SqlParameter[3];
                arParms[0] = new SqlParameter("@orderNo", orderNo);
                arParms[1] = new SqlParameter("@userName", userName);              
                arParms[2] = new SqlParameter("@status", SqlDbType.VarChar, 1000);
                arParms[2].Direction = ParameterDirection.Output;

                SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, CommandType.StoredProcedure, "[pSOEDeleteRBOrder]", arParms);
                return arParms[2].Value.ToString();
            }
            catch (Exception ex)
            {
                return "";
            }
        }

        public string ReleaseRGAOrder(string orderNo)
        {
            try
            {
                SqlParameter[] arParms = new SqlParameter[2];
                arParms[0] = new SqlParameter("@RGANo", orderNo);
                arParms[1] = new SqlParameter();
                arParms[1].Direction = ParameterDirection.ReturnValue;

                SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, CommandType.StoredProcedure, "[pSOEDeleteRGALPN]", arParms);

                return arParms[1].Value.ToString();
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public void SuspendReleasedOrder(string orderNo, string userName)
        {
            try
            {
                SqlParameter[] arParms = new SqlParameter[2];
                arParms[0] = new SqlParameter("@orderNo", orderNo);
                arParms[1] = new SqlParameter("@userName", userName);

                SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, CommandType.StoredProcedure, "[pSOESuspendRBOrder]", arParms);
                 
            }
            catch (Exception ex)
            {
               
            }
        }

        public bool GetShowWorkSheet(string shipLoc)
        {
            object objCode = (object)SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                   new SqlParameter("@tableName", "LocMaster"),
                   new SqlParameter("@columnNames", "SOEDetailItemInd"),
                   new SqlParameter("@whereClause", "LocID='" + shipLoc + "'"));

            if (objCode != null && objCode.ToString().Trim() == "Y")
                return true;
            else
                return false;
        }

        public bool GetApprefOrderType(string orderType)
        {
            DataSet dsOrder = (DataSet)SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOESelect",
                   new SqlParameter("@tableName", "AppPref"),
                   new SqlParameter("@columnNames", "ApplicationCd,AppOptionType,AppOptionValue,AppOptionNumber"),
                   new SqlParameter("@whereClause", "ApplicationCd='SOE' and AppOptionType='" + orderType + "'"));

            if (dsOrder != null && dsOrder.Tables[0].Rows.Count>0)
                return true;
            else
                return false;
        }
        
        public bool GetApprefSubType(string subType)
        {
            DataSet dsOrder = (DataSet)SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOESelect",
                   new SqlParameter("@tableName", "AppPref"),
                   new SqlParameter("@columnNames", "ApplicationCd,AppOptionType,AppOptionValue,AppOptionNumber"),
                   new SqlParameter("@whereClause", "ApplicationCd='SOE' and AppOptionType='" + subType.Trim() + "'"));

            if (dsOrder != null && dsOrder.Tables[0].Rows.Count > 0)
                return true;
            else
                return false;
        }
        
        public void ConfirmShipment(string orderNo)
        {
            try
            {
                SqlConnection conn = new SqlConnection(Global.PFCERPConnectionString);
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();

                try
                {
                    Cmd.CommandTimeout = 0;
                    Cmd.CommandType = CommandType.StoredProcedure;
                    Cmd.Connection = conn;
                    conn.Open();
                    Cmd.CommandText = "pSOEShipERPOrders";
                    Cmd.Parameters.Add(new SqlParameter("@orderNo", orderNo));
                    Cmd.ExecuteNonQuery();
                }
                catch (Exception ex)
                {
                    throw ex;
                }
                finally
                {
                    conn.Close();
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }

        }

        public string DoTotalCostCheck(string orderNo)
        {
            try
            {
                string errorMsg = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOECheckCost",
                             new SqlParameter("@orderNo", orderNo)).ToString();

                return errorMsg;
            }
            catch (Exception ex)
            {

                return "error";
            }

        }

        // added by Slater for WO1645
        public DataSet GetOrderTypeTermsOverrides(string orderType, string billTo)
        {
            try
            {
                DataSet dsResult = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEGetTermsOverride]",
                                    new SqlParameter("@OrderType", orderType),
                                    new SqlParameter("@BillToCust", billTo));
                return dsResult;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public string GetAppPref(string OptType)
        {
            DataSet dsAppPref = new DataSet();
            dsAppPref = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[UGEN_SP_Select]",
                    new SqlParameter("@tableName", "AppPref"),
                    new SqlParameter("@displayColumns", "AppOptionValue"),
                    new SqlParameter("@whereCondition", " (ApplicationCd = 'SOE') AND (AppOptionType = '" + OptType + "')"));

            return dsAppPref.Tables[0].Rows[0]["AppOptionValue"].ToString(); ;
        }

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
                object objSecurityCode = (object)SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and SU.UserName='" + userName + "' AND (SG.groupname='SOE(W)' OR  SG.groupname='ENTRY(W)')"));

                if (objSecurityCode != null)
                    return objSecurityCode.ToString().Trim();
                else
                    return "";

            }
            catch (Exception Ex) { return ""; }
        }
        #endregion

        #region SoftLock
        //select entryId,TableRowItem,TypeofRowItem from dbo.SoftLockStats where UserCurrentApp='SOE' and Status='L' and entryId='intranet' and entrydt=(select max(entrydt) from dbo.SoftLockStats where UserCurrentApp='SOE' and Status='L' and entryId='intranet')
        public DataTable GetDefaultLockSO()
        {
            try
            {
                DataSet dsOrder = (DataSet)SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOESelect",
                          new SqlParameter("@tableName", " SoftLockStats"),
                          new SqlParameter("@columnNames", "TableRowItem,TypeofRowItem"),
                          new SqlParameter("@whereClause", "UserCurrentApp='SOE' and Status='L' and entryId='" + HttpContext.Current.Session["UserName"].ToString() + "' and entrydt=(select max(entrydt) from dbo.SoftLockStats where UserCurrentApp='SOE' and Status='L' and entryId='" + HttpContext.Current.Session["UserName"].ToString() + "')"));

                if (dsOrder != null && dsOrder.Tables[0].Rows.Count > 0)
                {
                    SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "pSOEUpdate",
                                                new SqlParameter("@tableName", "SoftLockStats"),
                                                new SqlParameter("@columnNames", "SourceApp=NULL"),
                                                new SqlParameter("@whereClause", "entryId='" + HttpContext.Current.Session["UserName"].ToString() + "'"));

                    return dsOrder.Tables[0];
                }
                else
                    return null;
            }
            catch (Exception ex)
            { 
                return null;
            }
        }

        public DataTable OrderLock(string lockorder, string orderID)
        {
            try
            {
                string currentApplication = "SOE";
                DataSet dsLock = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSoftLock",
                                              new SqlParameter("@resource", HttpContext.Current.Session["OrderTableName"].ToString()),
                                              new SqlParameter("@function", lockorder),
                                              new SqlParameter("@key", orderID),
                                              new SqlParameter("@uid", HttpContext.Current.Session["UserName"].ToString()),
                                              new SqlParameter("@curApplication", currentApplication)
                                              );

                if (dsLock != null && dsLock.Tables[0].Rows.Count > 0)
                    return dsLock.Tables[0];
                else
                    return null;

            }
            catch (Exception ex) { return null; }
        }


        /// <summary>
        /// Set the lock for the vendor
        /// </summary>
        /// <param name="idVendor"></param>
        public void SetLock(string orderID)
        {
            try
            {
                DataTable dtLock = new DataTable();
                HttpContext.Current.Session["LockOrderID"] = orderID;
                dtLock = OrderLock("Lock", HttpContext.Current.Session["LockOrderID"].ToString());
                HttpContext.Current.Session["OrderLock"] = dtLock.Rows[0][1].ToString().Trim();
            }
            catch (Exception ex)
            {
                HttpContext.Current.Session["OrderLock"] = null;
                HttpContext.Current.Session["LockOrderID"] = null;
            }
            finally
            {
            }
        }


        /// <summary>
        /// Function to release the vendor lock
        /// </summary>
        public void ReleaseLock()
        {
            try
            {
                if (HttpContext.Current.Session["OrderLock"] != null && HttpContext.Current.Session["OrderLock"].ToString().Trim() != "")
                    // if (HttpContext.Current.Session["CustomerLock"].ToString().Trim() == "SL")
                    OrderLock("Release", HttpContext.Current.Session["LockOrderID"].ToString());
            }
            catch (Exception ex) { }
            finally
            {
                HttpContext.Current.Session["OrderLock"] = null;
                HttpContext.Current.Session["LockOrderID"] = null;
            }
        }

        public string GetSoftLockData()
        {
            try
            {
                string orderCount = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "UGEN_SP_Select",
                                                 new SqlParameter("@tableName", "SoftLockStats"),
                                                 new SqlParameter("@columnNames", "count(*)"),
                                                 new SqlParameter("@whereClause", "EntryID='" + HttpContext.Current.Session["UserName"].ToString() + "' and SourceApp='QE'")).ToString();
                return orderCount;

            }
            catch (Exception ex)
            {
                return "0";
            }
        } 

        #endregion

        #region ItemBuilder
        /// <summary>
        /// Function to update the new quote
        /// </summary>
        /// <param name="strTableName"></param>
        /// <param name="strColumnValue"></param>
        /// <param name="strWhere"></param>
        public DataSet ExecuteSelectQuery(string tableName, string columnNames, string whereClause)
        {

            try
            {
                DataSet dsSelect = SqlHelper.ExecuteDataset(Global.PFCQuoteConnectionString, "UGEN_SP_Select",
                                                 new SqlParameter("@tableName", tableName),
                                                 new SqlParameter("@columnNames", columnNames),
                                                 new SqlParameter("@whereClause", whereClause));
                return dsSelect;
            }
            catch (Exception ex)
            {

                return null;
            }


        }
        #endregion
    } 
}
