
using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;

namespace PFC.Intranet.MaintenanceApps
{
    /// <summary>
    /// Public enum used for maintenace tables project
    /// </summary>
    public enum MaintenaceTable
    {
        AppPref,
        BillOfMaterials,
        CarrierCodes,
        CategoryBuyGroups,
        ClassofTrade,
        CustomerActivity,
        CustomerContact,
        CustomerContract,
        CustomerType,
        CustPriceSchedMaint,
        ExpediteCodes,
        ExpenseCodes,
        FiscalPeriod,
        FormMessage,
        FreightAddr,
        FreightTerms,
        GLAccount,
        GLPosting,
        ItemAlias,
        OrganisationComments,
        PriorityCodes,
        ReasonCodes,
        RepClass,
        RepMaster,
        SecurityGroups,
        ShipMethod,
        StandardComments,
        SubItemAlias,
        TermsCodes,
        WarningMessages,
        WebCatDisc,
        CatPriceSchedMaintAccess,
        CatPriceSchedMaintApproval,
        CVCAdder
    }

    /// <summary>
    /// Summary description for MaintenanceUtility
    /// </summary>
    public class MaintenanceUtility
    {
        //For Security Code
        string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string whereClause = string.Empty;

        public void UpdateTables(string columnValues, string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                             new SqlParameter("@tableName", "[Tables]"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {

            }
        }

        public void InsertTables(string columnNames, string columnValues)
        {
            try
            {
                SqlHelper.ExecuteDataset(connectionString, "pSOEInsert",
                             new SqlParameter("@tableName", "[Tables]"),
                             new SqlParameter("@columnNames", columnNames),
                             new SqlParameter("@columnValues", columnValues));
            }
            catch (Exception ex)
            {

            }
        }

        public void DeleteTablesData(string primaryKey)
        {
            try
            {
                whereClause = "pTableID ='" + primaryKey + "'";
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEDelete",
                                             new SqlParameter("@tableName", "[Tables]"),
                                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public DataTable GetTablesData(string searchText)
        {
            try
            {
                string _whereClause = searchText;
                string _tableName = "[Tables]";
                string _columnName = "pTableID,TableCd,Dsc,ShortDsc,PrintDoc,Comments,GLApp,APApp,ARApp,SOApp,POApp,IMApp,WMApp,WOApp,MMApp,SMApp" +
                                     ",EntryID,convert(char(10),EntryDt,101)as EntryDt,ChangeID,convert(char(10),ChangeDt,101) as ChangeDt" +
                                     ",GLAccountNo,LineNumber,ExpType,Pct,TaxStatus,Indicator";

                DataSet dsCarrierCode = new DataSet();
                dsCarrierCode = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsCarrierCode.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public bool CheckDataExist(string code, MaintenaceTable maintenaceTable)
        {
            #region Create where clause based on module type

            string whereClause = "TableCd='" + code + "'";
            switch (maintenaceTable)
            {
                case MaintenaceTable.AppPref:
                    whereClause = whereClause;
                    break;
                case MaintenaceTable.CarrierCodes:
                    whereClause += " AND TableType='CAR'";
                    break;
                case MaintenaceTable.ClassofTrade:
                    whereClause += " AND TableType='TRD'";
                    break;
                //case MaintenaceTable.CustomerType:
                //    whereClause += " AND TableType='CTYP'";
                //    break;
                case MaintenaceTable.ExpediteCodes:
                    whereClause += " AND TableType='EXPD'";
                    break;
                //case MaintenaceTable.FreightAddr:
                //    whereClause += " AND TableType='FGHTADD'";
                //    break;
                case MaintenaceTable.FreightTerms:
                    whereClause += " AND TableType='FGHT'";
                    break;
                case MaintenaceTable.PriorityCodes:
                    whereClause += " AND TableType='PRI'";
                    break;
                case MaintenaceTable.ReasonCodes:
                    whereClause += " AND TableType='REAS'";
                    break;
                case MaintenaceTable.RepClass:
                    whereClause += " AND TableType='RPCL'";
                    break;
                //case MaintenaceTable.SecurityGroups:
                //    whereClause += " AND TableType='SEC'";
                //    break;
                //case MaintenaceTable.ShipMethod:
                //    whereClause += " AND TableType='SHIP'";
                //    break;
                case MaintenaceTable.WarningMessages:
                    whereClause += " AND TableType='WM'";
                    break;
                //case MaintenaceTable.WebCatDisc:
                //    whereClause += " AND TableType='WebCat'";
                //    break;
                default:
                    whereClause = whereClause;
                    break;
            }
            #endregion
            DataSet dsCarrierCode = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                        new SqlParameter("@tableName", "[Tables]"),
                        new SqlParameter("@columnNames", "TableCd"),
                        new SqlParameter("@whereClause", whereClause));

            if (dsCarrierCode.Tables[0].Rows.Count > 0)
            {
                return false;
            }
            else
            {
                return true;
            }

        }

        public DataTable GetKPIBranches()
        {
            try
            {
                string _whereClause = "LocSalesGrp <>'' order by locid";
                string _tableName = "[locmaster]";
                string _columnName = "rtrim(LocID) as Branch,LocID + ' - ' + LocName as BranchDesc";

                DataSet dsBranch = new DataSet();
                dsBranch = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsBranch.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetTermsCodeData(string searchText)
        {
            try
            {
                string _whereClause = searchText;
                string _tableName = "[Tables]";
                string _columnName = "pTableID,TableCd,Dsc,ShortDsc,TrmRuleID,Comments,GLApp,APApp,ARApp,SOApp,POApp,IMApp,WMApp,WOApp,MMApp,SMApp,EntryID,EntryDt,ChangeID,ChangeDt," +
                                     "ColorCd,CashDiscDays,Pct,CollectionDays,DiscGraceDays,DelChgCd";

                DataSet dsCarrierCode = new DataSet();
                dsCarrierCode = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsCarrierCode.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetMaintData(string tableName, string columnName, string whereClause)
        {
            try
            {
                DataSet dsData = new DataSet();
                dsData = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", tableName),
                                    new SqlParameter("@columnNames", columnName),
                                    new SqlParameter("@whereClause", whereClause));
                return dsData.Tables[0];
            }
            catch (Exception ex)
            { throw ex; }
        }

        public void UpdateMaintData(string tableName, string columnName, string whereClause)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                             new SqlParameter("@tableName", tableName),
                             new SqlParameter("@columnNames", columnName),
                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            { throw ex; }
        }

        #region For Reason Code & Freight Terms

        public DataTable GetReasonCodeData(string searchText)
        {
            try
            {
                string _whereClause = searchText;
                string _tableName = "[Tables]";
                string _columnName = "pTableID,TableCd,Dsc,ShortDsc,IssueDoc,SOEAllowed,DelChgCd,Comments,GLApp,APApp,ARApp,SOApp,POApp,IMApp,WMApp,WOApp,MMApp,SMApp,EntryID,EntryDt,ChangeID,ChangeDt";

                DataSet dsCarrierCode = new DataSet();
                dsCarrierCode = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsCarrierCode.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetAppPrefData(string searchText)
        {
            try
            {
                string _whereClause = searchText;
                string _tableName = "[AppPref]";
                string _columnName = "pAppPrefID,ApplicationCd,AppOptionType,AppOptionValue,AppOptionNumber,AppOptionTypeDesc,EntryID,EntryDt,ChangID.ChangeDt";
                DataSet dsAppPref = new DataSet();
                dsAppPref = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsAppPref.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        #endregion

        #region Security Code
        /// <summary>
        /// Public Method user to get User security code
        /// </summary>
        /// <param name="userName">Parameter:username</param>
        /// <returns>User security code</returns>
        public string GetSecurityCode(string userName, MaintenaceTable moduleType)
        {
            try
            {

                #region Create where clause based on module type

                string whereClause = string.Empty;
                switch (moduleType)
                {
                    case MaintenaceTable.AppPref:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='AppPref (W)')";
                        break;

                    case MaintenaceTable.BillOfMaterials:
                        whereClause = "' AND (SG.groupname='ADMIN (W)' OR  SG.groupname='MAINTENANCE (W)' OR  SG.groupname='BOM (W)')";
                        break;
                    
                    case MaintenaceTable.CarrierCodes:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='CarrierCd (W)')";
                        break;
                    case MaintenaceTable.CategoryBuyGroups:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='CatBuyGrpMaint (W)')";
                        break;
                    case MaintenaceTable.ClassofTrade:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='Trd (W)')";
                        break;
                    case MaintenaceTable.CustomerActivity:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)')";
                        break;
                    case MaintenaceTable.CustomerContract:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='CustContMaint (W)')";
                        break;
                    case MaintenaceTable.CustomerType:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='Ctyp (W)')";
                        break;
                    case MaintenaceTable.CustPriceSchedMaint:
                        whereClause = "' AND (SG.groupname='ADMIN (W)' OR  SG.groupname='MAINTENANCE (W)' OR  SG.groupname='CustPriceMaint (W)')";
                        break;
                    case MaintenaceTable.ExpediteCodes:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='Expd (W)')";
                        break;
                    case MaintenaceTable.ExpenseCodes:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='Expense(W)')";
                        break;
                    case MaintenaceTable.FiscalPeriod:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='Fiscal(W)')";
                        break;
                    case MaintenaceTable.FormMessage:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='FormMsg (W)')";
                        break;
                    case MaintenaceTable.FreightAddr:
                        whereClause = "' AND (SG.groupname='ADMIN (W)' OR  SG.groupname='MAINTENANCE (W)' OR  SG.groupname='FghtAdd')";
                        break;
                    case MaintenaceTable.FreightTerms:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='Fght (W)')";
                        break;
                    case MaintenaceTable.GLAccount:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='GLAcct (W)')";
                        break;
                    case MaintenaceTable.GLPosting:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='GLPost (W)')";
                        break;
                    case MaintenaceTable.ItemAlias:
                        whereClause = "' AND (SG.groupname='ItemAliasXref (W)')";
                        break;
                    case MaintenaceTable.OrganisationComments:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='OrgComm (W)')";
                        break;
                    case MaintenaceTable.PriorityCodes:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='Pri (W)')";
                        break;
                    case MaintenaceTable.ReasonCodes:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='Reas (W)')";
                        break;
                    case MaintenaceTable.RepClass:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='Rpcl (W)')";
                        break;
                    case MaintenaceTable.RepMaster:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='ADMIN (W)' OR SG.groupname='RepMasterMaint (W)' )";
                        break;
                    case MaintenaceTable.SecurityGroups:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='Security (W)')";
                        break;
                    case MaintenaceTable.ShipMethod:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='Ship (W)')";
                        break;
                    case MaintenaceTable.StandardComments:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='StdComm (W)')";
                        break;
                    case MaintenaceTable.SubItemAlias:
                        whereClause = "' AND (SG.groupname='SubItem (W)')";
                        break;
                    case MaintenaceTable.TermsCodes:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='Term (W)')";
                        break;
                    case MaintenaceTable.WarningMessages:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='WarnMsg (W)')";
                        break;
                    case MaintenaceTable.WebCatDisc:
                        whereClause = "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='WebCat (W)')";
                        break;
                    case MaintenaceTable.CatPriceSchedMaintAccess:
                        whereClause = "' AND (SG.groupname='CustCatPriceMaint (W)')";
                        break;
                    case MaintenaceTable.CatPriceSchedMaintApproval:
                        whereClause = "' AND (SG.groupname='CustCatPriceApprove (W)')";
                        break;
                    default:
                        whereClause = "' AND SG.groupname='MAINTENANCE (W)' ";
                        break;
                }
                #endregion

                object objSecurityCode = (object)SqlHelper.ExecuteScalar(connectionString, "pSOESelect",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID and SM.SecUserID = SU.pSecUserID and (SU.DeleteDt is null or SU.DeleteDt = '') and (SM.DeleteDt is null or SM.DeleteDt = '') and (SG.DeleteDt is null or SG.DeleteDt = '') and SU.UserName='" + userName + whereClause));

                if (objSecurityCode != null)
                    return objSecurityCode.ToString().Trim();

                else

                    return "";

            }
            catch (Exception Ex) { return ""; }
        }

        /// <summary>
        /// return max row to display search value
        /// </summary>
        /// <returns></returns>
        public int GetSQLWarningRowCount()
        {
            int locName = (int)SqlHelper.ExecuteScalar(connectionString, "pSOESelect",
                                                  new SqlParameter("@tableName", "SystemMaster"),
                                                  new SqlParameter("@columnNames", "SQLRowWarn"),
                                                  new SqlParameter("@whereClause", "SystemMasterID='0'"));
            return locName;
        }
        #endregion


        public string FormatPhoneNumber(string phoneNumber)
        {
            string result = phoneNumber;
            if (phoneNumber.Trim() != "")
            {
                if (phoneNumber.Length == 10 || phoneNumber.Length == 11)
                {
                    result = ((phoneNumber.Length == 10) ?
                                        ("(" + phoneNumber.Substring(0, 3) + ")" + " " + phoneNumber.Substring(3, 3) + "-" + phoneNumber.Substring(6, 4)) :
                                        (phoneNumber.Substring(0, 1) + "-" + phoneNumber.Substring(1, 3) + "-" + phoneNumber.Substring(4, 3) + "-" + phoneNumber.Substring(7, 4)));
                }
            }
            return result;
        }


        #region ColorCode

        public DataTable GetColorCode()
        {
            try
            {
                string _tableName = "ListMaster LM ,ListDetail LD";
                string _columnName = "(LD.ListValue+' - '+LD.ListdtlDesc) as ListDesc,LD.ListValue ";
                string _whereClause = "LM.ListName = 'BranchColor' And LD.fListMasterID = LM.pListMasterID ";


                DataSet dsProgram = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                      new SqlParameter("@tableName", _tableName),
                                      new SqlParameter("@columnNames", _columnName),
                                      new SqlParameter("@whereClause", _whereClause));
                return dsProgram.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        #endregion

        #region DropDownList

        public DataTable GetListDetails(string listName)
        {
            try
            {
                string _tableName = "ListMaster (NOLOCK) LM, ListDetail (NOLOCK) LD";
                string _columnName = "LD.ListDtlDesc as ListDesc, LD.ListValue ";
                string _whereClause = "LM.ListName = '" + listName + "' AND LD.fListMasterID = LM.pListMasterID order by SequenceNo asc";
                DataSet dsType = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
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

        public void BindListControls(ListControl lstControl, string textField, string valueField, DataTable dtSource, string defaultValue)
        {
            try
            {
                if (dtSource != null && dtSource.Rows.Count > 0)
                {
                    lstControl.DataSource = dtSource;
                    lstControl.DataTextField = textField;
                    lstControl.DataValueField = valueField;
                    lstControl.DataBind();
                    lstControl.Items.Insert(0, new ListItem(defaultValue, ""));


                }
                else
                {
                    if (lstControl.ID.IndexOf("lst") == -1)
                    {
                        lstControl.Items.Clear();
                        lstControl.Items.Insert(0, new ListItem("N/A", ""));
                    }

                }
            }
            catch (Exception ex) { throw ex; }
        }

        public void SetValueListControl(DropDownList ddlControl, string value)
        {
            ListItem lItem = ddlControl.Items.FindByValue(value.Trim()) as ListItem;
            if (lItem != null)
                ddlControl.SelectedValue = value.Trim();
        }

        #endregion

        #region Soft Locks

        public DataTable SetLock(string lockTable, string lockID, string lockApp)
        {
            try
            {
                DataTable dtLock = new DataTable();
                dtLock = MaintLock(lockTable.ToString(), "Lock", lockID.ToString(), lockApp.ToString());
                return dtLock.DefaultView.ToTable();
            }
            catch (Exception ex) { return null; }
        }

        public DataTable MaintLock(string lockTable, string lockFunction, string lockID, string lockApp)
        {
            try
            {
                DataSet dsLock = SqlHelper.ExecuteDataset(connectionString, "pSoftLock",
                                              new SqlParameter("@resource", lockTable),
                                              new SqlParameter("@function", lockFunction),
                                              new SqlParameter("@key", lockID),
                                              new SqlParameter("@uid", HttpContext.Current.Session["UserName"].ToString()),
                                              new SqlParameter("@curApplication", lockApp));

                if (dsLock != null && dsLock.Tables[0].Rows.Count > 0)
                    return dsLock.Tables[0];
                else
                    return null;
            }
            catch (Exception ex) { return null; }
        }

        public void ReleaseLock(string lockTable, string lockID, string lockApp, string lockStatus)
        {
            try
            {
                if (lockStatus.ToString() == "SL")
                    MaintLock(lockTable.ToString(), "Release", lockID.ToString(), lockApp.ToString());
            }
            catch (Exception ex) { }
        }

        #endregion
    }
}