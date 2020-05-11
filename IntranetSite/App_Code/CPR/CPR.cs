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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Methods for CPR data extraction
    /// </summary>
    public class CPR
    {
        //
        // Global Variables Declaration
        //
        //Utility utility = new Utility();
        string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
        //string liveConnectionString = ConfigurationManager.AppSettings["LiveReportsConnectionString"].ToString();
        string liveConnectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();

        /// <summary>
        /// Get AppPref entries for CPR/AD entries
        /// </summary>
        public string GetAppPrefValue(string OptType)
        {
            //try
            //{
            DataSet dsAppPref = new DataSet();
            dsAppPref = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[UGEN_SP_Select]",
                    new SqlParameter("@tableName", "AppPref"),
                    new SqlParameter("@displayColumns", "AppOptionValue"),
                    new SqlParameter("@whereCondition", " (ApplicationCd = 'AD') AND (AppOptionType = '" + OptType + "')"));
            //}
            //catch (Exception ex)
            //{
            //}
            return dsAppPref.Tables[0].Rows[0]["AppOptionValue"].ToString(); ;
        }

        public decimal GetAppPrefNumber(string OptType)
        {
            //try
            //{
            DataSet dsAppPref = new DataSet();
            dsAppPref = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[UGEN_SP_Select]",
                    new SqlParameter("@tableName", "AppPref"),
                    new SqlParameter("@displayColumns", "AppOptionNumber"),
                    new SqlParameter("@whereCondition", " (ApplicationCd = 'AD') AND (AppOptionType = '" + OptType + "')"));
            //}
            //catch (Exception ex)
            //{
            //}
            return (decimal)dsAppPref.Tables[0].Rows[0]["AppOptionNumber"]; ;
        }

        public decimal GetAppPrefNumber(string AppCode, string OptType)
        {
            //try
            //{
            DataSet dsAppPref = new DataSet();
            dsAppPref = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[UGEN_SP_Select]",
                    new SqlParameter("@tableName", "AppPref"),
                    new SqlParameter("@displayColumns", "AppOptionNumber"),
                    new SqlParameter("@whereCondition", " (ApplicationCd = '" + AppCode + "') AND (AppOptionType = '" + OptType + "')"));
            //}
            //catch (Exception ex)
            //{
            //}
            return (decimal)dsAppPref.Tables[0].Rows[0]["AppOptionNumber"]; ;
        }

        /// <summary>
        /// Return item data for user running the report. This is used to populate the grid pages
        /// </summary>
        public DataSet GetCPRItems(string userID, string orderBy)
        {
            try
            {
                DataSet dsMasterItems = SqlHelper.ExecuteDataset(connectionString, "[pCPRRepItemDetail]",
                          new SqlParameter("@UserID", userID),
                          new SqlParameter("@OrderBy", orderBy));
                return dsMasterItems;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetCPRItems(string userID, string Factor, string orderBy)
        {
            try
            {
                DataSet dsMasterItems = SqlHelper.ExecuteDataset(connectionString, "[pCPRRepItemDetail]",
                          new SqlParameter("@UserID", userID),
                          new SqlParameter("@Factor", Factor),
                          new SqlParameter("@OrderBy", orderBy));
                return dsMasterItems;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetFilteredItems(string BegCat, string EndCat, string BegSize, string EndSize, string BegVar
            , string EndVar, string BegCFVC, string EndCVFC, string userID)
        {
            try
            {
                DataSet dsMasterItems = SqlHelper.ExecuteDataset(connectionString, "[pCPRGetItems]",
                          new SqlParameter("@UserID", userID),
                          new SqlParameter("@BegCat", BegCat),
                          new SqlParameter("@EndCat", EndCat),
                          new SqlParameter("@BegSize", BegSize),
                          new SqlParameter("@EndSize", EndSize),
                          new SqlParameter("@BegVar", BegVar),
                          new SqlParameter("@EndVar", EndVar),
                          new SqlParameter("@BegCFVC", BegCFVC),
                          new SqlParameter("@EndCFVC", EndCVFC));
                return dsMasterItems;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetCPRItems(string userID)
        {
            try
            {
                return GetCPRItems(userID, "CPR.ItemNo");
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        ///// <summary>
        ///// Return Single Item data
        ///// </summary>
        //public DataSet GetItemData( string ItemNo)
        //{
        //    try
        //    {
        //        DataSet dsLocal = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
        //            new SqlParameter("@tableName", "ItemMaster"),
        //            new SqlParameter("@displayColumns", "ItemNo, ItemDesc, Finish, SellStkUM, SellStkUMQty, SuperUM, PcsPerPallet, SellStkUMQty*PcsPerPallet as PalletPieces, Wght, CUMGrossWght, HundredWght, TariffCd, CorpFixedVelocity"),
        //            new SqlParameter("@whereCondition", "ItemNo = '" + ItemNo + "' "));

        //        return dsLocal;
        //    }
        //    catch (Exception ex)
        //    {
        //        return null;
        //    }
        //}

        /// <summary>
        /// Return static list summarized by ListDate, UserID, ListType
        /// </summary>
        public DataSet GetStaticLists()
        {
            try
            {
                DataSet dsLocal = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                    new SqlParameter("@tableName", "CPRStaticItemLists"),
                    new SqlParameter("@displayColumns", " ListDate, UserID, ListType, count(*) as NumRecs"),
                    new SqlParameter("@whereCondition", "1=1 GROUP BY ListDate, UserID, ListType ORDER BY ListDate DESC, UserID"));

                return dsLocal;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        /// <summary>
        /// Return static lists for a single list type summarized by ListDate, UserID, ListType
        /// </summary>
        public DataSet GetStaticLists(string ListType)
        {
            try
            {
                DataSet dsLocal = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                    new SqlParameter("@tableName", "CPRStaticItemLists"),
                    new SqlParameter("@displayColumns", " ListDate, UserID, ListType, count(*) as NumRecs"),
                    new SqlParameter("@whereCondition", "ListType = '" + ListType + "' GROUP BY ListDate, UserID, ListType ORDER BY ListDate DESC, UserID, ListType"));

                return dsLocal;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        /// <summary>
        /// Return static list types regardless of user or date
        /// </summary>
        public DataSet GetStaticListTypes()
        {
            try
            {
                DataSet dsLocal = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                    new SqlParameter("@tableName", "CPRStaticItemLists"),
                    new SqlParameter("@displayColumns", " ListType"),
                    new SqlParameter("@whereCondition", "1=1 GROUP BY ListType ORDER BY ListType"));

                return dsLocal;
            }
            catch (Exception ex)
            {
                return null;
            }
        }


        /// <summary>
        /// Delete the items in a selected static list 
        /// </summary>
        public void DelStaticListItems(GridViewRow row)
        {
            string ListDate = row.Cells[0].Text;
            string ListUser = row.Cells[1].Text;
            string ListType = row.Cells[2].Text;
            string whereClause = "ListDate = '" + ListDate + "' ";
            whereClause += " and UserID = '" + ListUser + "' ";
            whereClause += " and ListType = '" + ListType + "' ";

            //try
            //{
            SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Delete]",
                new SqlParameter("@tableName", "CPRStaticItemLists"),
                new SqlParameter("@whereCondition", whereClause));

            //}
            //catch (Exception ex)
            //{
            //    return null;
            //}
        }

        /// <summary>
        /// Return the items in a selected static list 
        /// </summary>
        public DataSet GetStaticListItems(GridViewRow row)
        {
            string ListDate = row.Cells[0].Text;
            string ListUser = row.Cells[1].Text;
            string ListType = row.Cells[2].Text;
            string whereClause = "ListDate = '" + ListDate + "' ";
            whereClause += " and UserID = '" + ListUser + "' ";
            whereClause += " and ListType = '" + ListType + "' ";
            //try
            //{
                DataSet dsLocal = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                    new SqlParameter("@tableName", "CPRStaticItemLists"),
                    new SqlParameter("@displayColumns", "ItemNo as Item, left(ItemNo,5) as Cat, substring(ItemNo,14,1) as Plate, substring(ItemNo,12,3) as Var"),
                    new SqlParameter("@whereCondition", whereClause + " ORDER BY ItemNo"));

                return dsLocal;
            //}
            //catch (Exception ex)
            //{
            //    return null;
            //}
        }

        /// <summary>
        /// Return AD exception list summarized by Date, Process, and UserID
        /// </summary>
        public DataSet GetExceptionLists()
        {
            try
            {
                DataSet dsLocal = SqlHelper.ExecuteDataset(connectionString, "[pADExceptionLists]");
                return dsLocal;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        /// <summary>
        /// Delete the items in a selected Exception list 
        /// </summary>
        public string DelExceptionListItems(GridViewRow row)
        {
            string ListDate = row.Cells[0].Text;
            string ListType = row.Cells[1].Text;
            string ListUser = row.Cells[2].Text;
            //          string whereClause = "convert(varchar(19),RunDate,120) = convert(varchar(19),'" + ListDate + "',120) ";

            string whereClause = "CONVERT(varchar(30), RunDate , 100) = CONVERT(varchar(30), CAST('" + ListDate + "' as DATETIME), 100)";

            whereClause += " and RunUserID = '" + ListUser + "' ";
            whereClause += " and Process = '" + ListType + "' ";

            //try
            //{
            SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Delete]",
                new SqlParameter("@tableName", "ADException"),
                new SqlParameter("@whereCondition", whereClause));

            //}
            //catch (Exception ex)
            //{
            //    return null;
            //}

            return whereClause;
        }

        /// <summary>
        /// Return the items in a selected AD exception list 
        /// </summary>
        public DataSet GetExceptionListItems(GridViewRow row)
        {
            string ListDate = row.Cells[0].Text;
            string ListType = row.Cells[1].Text;
            string ListUser = row.Cells[2].Text;
            //try
            //{
            DataSet dsMasterItems = SqlHelper.ExecuteDataset(connectionString, "[pADExceptionListDetail]",
                      new SqlParameter("@ListDate", ListDate),
                      new SqlParameter("@ProcessCode", ListType),
                      new SqlParameter("@UserID", ListUser)
                      );
            return dsMasterItems;
            //}
            //catch (Exception ex)
            //{
            //    return null;
            //}
        }

        /// <summary>
        /// Load items in ReportItemsGrid into CPRCurItems for report
        /// </summary>
        public void LoadCurrentItems(string UserID, GridView ItemsGrid)
        {
            string ItemNo;
            DateTime ListDate = DateTime.Today;
            // clear out Items for user
            string SqlStatement = "delete from CPRCurItems ";
            SqlStatement += " where UserID =  '" + UserID.TrimEnd() + "' ";
            SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, SqlStatement);
            //try
            //{
            foreach (GridViewRow row in ItemsGrid.Rows)
            {
                ItemNo = row.Cells[0].Text;
                SqlStatement = "insert into CPRCurItems ";
                SqlStatement += " (ItemNo, UserID, EntryID, EntryDt) values (";
                SqlStatement += " '" + ItemNo.Substring(0, 14) + "', ";
                SqlStatement += " '" + UserID.TrimEnd() + "', ";
                SqlStatement += " '" + UserID.TrimEnd() + "', ";
                SqlStatement += " convert(datetime,'" + ListDate.ToString() + "') ) ";
                SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, SqlStatement);
            }
            //}
            //catch (Exception ex)
            //{
            //}
        }

        /// <summary>
        /// Load single item into CPRCurItems for report
        /// </summary>
        public DataSet LoadCurrentItems(string UserID, string ItemNo)
        {
            DateTime ListDate = DateTime.Today;
            // clear out Items for user
            string SqlStatement = "delete from CPRCurItems ";
            SqlStatement += " where UserID =  '" + UserID.TrimEnd() + "' ";
            SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, SqlStatement);
            //try
            //{
                SqlStatement = "insert into CPRCurItems ";
                SqlStatement += " (ItemNo, UserID, EntryID, EntryDt) values (";
                SqlStatement += " '" + ItemNo.Trim() + "', ";
                SqlStatement += " '" + UserID.TrimEnd() + "', ";
                SqlStatement += " '" + UserID.TrimEnd() + "', ";
                SqlStatement += " convert(datetime,'" + ListDate.ToString() + "') ) ";
                SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, SqlStatement);
            //}
            //catch (Exception ex)
            //{
            //}
            DataSet dsLocal = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                new SqlParameter("@tableName", "CPRCurItems"),
                new SqlParameter("@displayColumns", "ItemNo as Item, left(ItemNo,5) as Cat, substring(ItemNo,14,1) as Plate, substring(ItemNo,12,3) as Var"),
                new SqlParameter("@whereCondition", "UserID = '" + UserID.TrimEnd() + "' "));

            return dsLocal;
            }

        /// <summary>
        /// Create a static list from the item grid
        /// </summary>
        public void CreateStaticList(string UserID, string ListName, GridView ItemsGrid)
        {
            string ItemNo;
            DateTime ListDate = DateTime.Now;
            //try
            //{
            foreach (GridViewRow row in ItemsGrid.Rows)
            {
                ItemNo = row.Cells[0].Text;
                string SqlStatement = "insert into CPRStaticItemLists ";
                SqlStatement += " (ItemNo, ListType, ListDate, UserID, EntryID, EntryDt) values (";
                SqlStatement += " '" + ItemNo.Substring(0, 14) + "', ";
                SqlStatement += " '" + ListName + "', ";
                SqlStatement += " convert(datetime,'" + ListDate.ToString() + "'), ";
                SqlStatement += " '" + UserID.TrimEnd() + "', ";
                SqlStatement += " '" + UserID.TrimEnd() + "', ";
                SqlStatement += " convert(datetime,'" + ListDate.ToString() + "') ) ";
                SqlHelper.ExecuteNonQuery(connectionString, CommandType.Text, SqlStatement);
            }
            //}
            //catch (Exception ex)
            //{
            //}
        }

        /// <summary>
        /// Get VMI contracts for drop down selector
        /// </summary>
        public DataSet GetVMIDDL()
        {
            //try
            //{
            string SqlStatement = "SELECT  Chain + ' - ' + ContractNo AS ContractCode ";
            SqlStatement += " FROM VMI_Contract ";
            SqlStatement += " GROUP BY Chain + ' - ' + ContractNo ";
            SqlStatement += " ORDER BY Chain + ' - ' + ContractNo  ";
            DataSet dsVMIContracts = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, SqlStatement);
            return dsVMIContracts;
            //}
            //catch (Exception ex)
            //{
            //}
        }

        /// <summary>
        /// Get VMI contract items for report selection
        /// </summary>
        public DataSet GetVMIContractItems(string ContractCode)
        {
            //try
            //{
            string Chain, Contract;
            string[] stringSeparators = new string[] { " - " };
            Chain = ContractCode.Split(stringSeparators, StringSplitOptions.None)[0].Trim();
            Contract = ContractCode.Split(stringSeparators, StringSplitOptions.None)[1].Trim();
            //Chain = " - ";
            //Contract = " - ";
            string SqlStatement = "SELECT ItemNo as Item, left(ItemNo,5) as Cat, substring(ItemNo,14,1) as Plate, substring(ItemNo,12,3) as Var ";
            SqlStatement += " FROM VMI_Contract ";
            SqlStatement += " where Chain = '" + Chain + "' and ContractNo ='" + Contract + "'";
            SqlStatement += " ORDER BY ItemNo  ";
            DataSet dsVMIContractItems = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, SqlStatement);
            return dsVMIContractItems;
            //}
            //catch (Exception ex)
            //{
            //}
        }

        /// <summary>
        /// Get VMI contract item
        /// </summary>
        public DataSet GetVMIContractItem(string Chain, string ContractNo, string ItemNo)
        {
            //try
            //{
            //Chain = " - ";
            //Contract = " - ";
            string SqlStatement = "SELECT * ";
            SqlStatement += " FROM VMI_Contract ";
            SqlStatement += " where Chain = '" + Chain + "' and ContractNo ='" + ContractNo + "' and ItemNo ='" + ItemNo + "'";
            DataSet dsVMIContractItem = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, SqlStatement);
            return dsVMIContractItem;
            //}
            //catch (Exception ex)
            //{
            //}
        }

        /// <summary>
        /// get the CPR data for the main grid
        /// </summary>
        public DataSet GetGPRGridData(string ItemNo, decimal Factor)
        {
            //try
            //{
            DataSet dsGridData = SqlHelper.ExecuteDataset(liveConnectionString, "[pCPRRepGridDetail]",
                          new SqlParameter("@ItemNo", ItemNo),
                          new SqlParameter("@Factor", Factor),
                          new SqlParameter("@Combine", "false"));
            return dsGridData;
            //}
            //catch (Exception ex)
            //{
            //    return null;
            //}
        }

        /// <summary>
        /// get the CPR data for the main grid
        /// </summary>
        public DataSet GetGPRGridData(string ItemNo, decimal Factor, string IncludeSummQtys)
        {
            //try
            //{
            DataSet dsGridData = SqlHelper.ExecuteDataset(liveConnectionString, "[pCPRRepGridDetail]",
                          new SqlParameter("@ItemNo", ItemNo),
                          new SqlParameter("@Factor", Factor),
                          new SqlParameter("@Combine", IncludeSummQtys));
            return dsGridData;
            //}
            //catch (Exception ex)
            //{
            //    return null;
            //}
        }

        /// <summary>
        /// get the Vendor/Pallet Partner data 
        /// </summary>
        public DataSet GetVendorData(string ItemNo)
        {
            //try
            //{
            string SqlStatement = "SELECT CPRVend.ItemNo, CPRVend.VendorName, CPRVend.CountryCode,  ";
            SqlStatement += " CPRVend.FOB_Cost, CPRVend.FOB_Diff, CPRVend.DutyRate,  ";
            SqlStatement += " CPRVend.FOB_Wgt, CPRVend.Land_Cost, CPRVend.Land_Diff, CPRVend.Land_Wgt,  ";
            SqlStatement += " PallPart_Committed, VendorAvail, VendorPcsPer,  ";
            SqlStatement += " PallPart_Ready, PallPart_TotRlsd, VendorRank,  ";
            SqlStatement += " case when isnull(VendorPcsPer,0) = 0 then 0 else VendorAvail/VendorPcsPer end as VendorCartons  ";
            SqlStatement += " FROM CPR_VendorDetail CPRVend  ";
            //SqlStatement += " LEFT OUTER JOIN CPR_PalletPartner PP  ";
            //SqlStatement += " ON CPRVend.VendorName = PP.Vendor AND CPRVend.ItemNo = PP.Item ";
            SqlStatement += " where CPRVend.ItemNo = '" + ItemNo + "' ";
            SqlStatement += " order by VendorRank  ";
            DataSet dsVendors = SqlHelper.ExecuteDataset(connectionString, CommandType.Text, SqlStatement);
            return dsVendors;
            //}
            //catch (Exception ex)
            //{
            //    return null;
            //}
        }

        /// <summary>
        /// Return current item list with items that have no availabilty in any branch 
        /// or with items that have no availabilty in any branch removed
        /// </summary>
        public DataSet ClearEmptyItems(string UserID, int Action, bool IncludeSummQtys)
        {
            try
            {
                DataSet dsLocal = SqlHelper.ExecuteDataset(connectionString, "pCPRClearEmpty",
                    new SqlParameter("@UserID", UserID),
                    new SqlParameter("@FilterAction", Action),
                    new SqlParameter("@Combine", IncludeSummQtys.ToString().ToUpper())
                    );
                return dsLocal;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        /// <summary>
        /// Return current item list with items that require no action in any branch removed
        /// </summary>
        public DataSet ClearNoActionItems(string UserID, bool IncludeSummQtys)
        {
            try
            {
                DataSet dsLocal = SqlHelper.ExecuteDataset(connectionString, "pCPRClearNoAction",
                    new SqlParameter("@UserID", UserID),
                    new SqlParameter("@Combine", IncludeSummQtys.ToString().ToUpper())
                    );
                return dsLocal;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        /// <summary>
        /// Return current item list with items that have no stock in any branch removed
        /// </summary>
        public DataSet ClearNoStockItems(string UserID)
        {
            try
            {
                DataSet dsLocal = SqlHelper.ExecuteDataset(connectionString, "pCPRClearNoStock",
                    new SqlParameter("@UserID", UserID)
                    );
                return dsLocal;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        /// <summary>
        /// Return current item list with items that require no action in any branch removed
        /// </summary>
        public DataSet FilterExceptionItems(string UserID, int ExceptionNumber, bool IncludeSummQtys)
        {
            try
            {
                DataSet dsLocal = SqlHelper.ExecuteDataset(connectionString, "[pCPRFilterExceptions]",
                    new SqlParameter("@UserID", UserID),
                    new SqlParameter("@ExceptionNumber", ExceptionNumber),
                    new SqlParameter("@Combine", IncludeSummQtys.ToString().ToUpper())
                    );
                return dsLocal;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet FilterExceptionItems(string UserID, int ExceptionNumber, int SqlTimeOut, bool IncludeSummQtys)
        {
            SqlConnection cn = new SqlConnection();
            cn.ConnectionString = Global.ReportsConnectionString;
            cn.Open();
            SqlCommand command = new SqlCommand();
            command.Connection = cn;
            command.CommandTimeout = SqlTimeOut;
            command.CommandText = "exec pCPRFilterExceptions '" + UserID + "', " + ExceptionNumber.ToString() 
                + ", '" + IncludeSummQtys.ToString().ToUpper() + "' ";
            //try
            //{
                int rs = command.ExecuteNonQuery();
                return GetCPRItems(UserID);
            //}
            //catch (Exception ex)
            //{  }
            cn.Close();
            //return null;
        }

        /// <summary>
        /// Return current item list with items that fall within the Net Buy Range
        /// </summary>
        public DataSet FilterNetBuy(string UserID, decimal Factor, decimal LowerValue, decimal UpperValue, bool IgnoreChildren
            , bool IncludeSummQtys, bool UsePosNetBuy)
        {
            try
            {
                DataSet dsLocal = SqlHelper.ExecuteDataset(connectionString, "[pCPRFilterNetBuy]",
                    new SqlParameter("@UserID", UserID),
                    new SqlParameter("@Factor", Factor.ToString()),
                    new SqlParameter("@LowerValue", LowerValue.ToString()),
                    new SqlParameter("@UpperValue", UpperValue.ToString()),
                    new SqlParameter("@IgnoreChildren", IgnoreChildren.ToString().ToUpper()),
                    new SqlParameter("@Combine", IncludeSummQtys.ToString().ToUpper()),
                    new SqlParameter("@UsePosNetBuy", UsePosNetBuy.ToString().ToUpper())
                    );
                return dsLocal;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

    }
}
