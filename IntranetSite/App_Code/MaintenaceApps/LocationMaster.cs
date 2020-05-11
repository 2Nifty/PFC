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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;

namespace PFC.IntranetSite.MaintenanceApps
{
    /// <summary>
    /// Summary description for CarrierCode
    /// </summary>
    public class LocationMaster
    {
        //For Security Code
        string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU  (NOLOCK) ";
        //string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
        string whereClause = string.Empty;

        public string connectionString
        {
            get
            {
                // return PFC.Intranet.MaintenanceApps.MaintenanceUtility.GetConnectionString();
                return ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
            }
        }

        /// <summary>
        /// Get the table values from the database
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="columnName"></param>
        /// <param name="whereClause"></param>
        /// <returns></returns>
        public DataSet GetDataToDateSet(string tableName, string columnName, string whereClause)
        {
            try
            {

                DataSet dsDetails = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                    new SqlParameter("@tableName", tableName),
                    new SqlParameter("@columnNames", columnName),
                    new SqlParameter("@whereClause", whereClause));

                if (dsDetails != null && dsDetails.Tables[0].Rows.Count > 0)
                    return dsDetails;
                else
                    return null;
            }
            catch (Exception ex) { return null; }
        }

        public LocationMaster()
        {
            //
            // TODO: Add constructor logic here
            //
        }

        public void UpdateLocationMaster(string columnValues, string whereCondition)
        {
            try
            {
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEUpdate",
                             new SqlParameter("@tableName", "LocMaster"),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {

            }
        }

        public void InsertLocationMaster(string columnNames, string columnValues)
        {
            try
            {
                SqlHelper.ExecuteDataset(connectionString, "pSOEInsert",
                             new SqlParameter("@tableName", "LocMaster"),
                             new SqlParameter("@columnNames", columnNames),
                             new SqlParameter("@columnValues", columnValues));
            }
            catch (Exception ex)
            {

            }
        }

        public void DeleteLocationMaster(string locID)
        {
            try
            {
                whereClause = "LocID ='" + locID + "'";
                SqlHelper.ExecuteNonQuery(connectionString, "pSOEDelete",
                                             new SqlParameter("@tableName", "LocMaster"),
                                             new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public bool CheckLocationMasterExist(string cCODE)
        {
            DataSet dsLocationCode = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                        new SqlParameter("@tableName", "LocMaster (NOLOCK) "),
                        new SqlParameter("@columnNames", "LocID"),
                        new SqlParameter("@whereClause", "LocID='" + cCODE + "'"));

            if (dsLocationCode.Tables[0].Rows.Count > 0)
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        public DataTable GetLocationCode(string locID)
        {
            string _whereClause = string.Empty;
            string _tableName = "LocMaster (NOLOCK) ";
            string _columnName = "LocID,LocName,LocAdress1,LocAdress2,LocCity,LocState,LocPostCode,LocCountry,LocTimeZone,SrvrTimeZone,LocContact,LocPhone,LocFax,LocEmail,LocType,WarehouseInd,IMBranchSort,IMDisplayColor,EntryID,EntryDt,ChangeID,ChangeDt";

            _whereClause = "LocID=" + locID;


            try
            {
                DataSet dsLocationCode = new DataSet();
                dsLocationCode = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsLocationCode.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
                throw;
            }
        }

        public DataTable GetLocationMaster(string searchText)
        {
            string _whereClause = searchText;
            string _tableName = "LocMaster (NOLOCK) ";
            //string _columnName = "LocID,LocName,LocAdress1,LocAdress2,LocCity,LocState,LocPostCode,LocCountry,LocTimeZone,SrvrTimeZone,LocContact,LocPhone,LocFax,LocEmail,LocType,WarehouseInd,,EntryID,EntryDt,ChangeID,ChangeDt";
            string _columnName = "[LocID],[LocType],[LocName],[LocAdress1],[LocAdress2],[LocCity],[LocState],[LocPostCode],[LocCountry],[LocPhone],[LocFax],[LocEmail],[BOEmailAddress],[BigQuoteEmailAddress],[RGAEmailAddress],[LocContact],[ShortCode][DtFmt],[PhoneFmt],[PostCodeFmt],[fVendorMasterID],[AllocTypeCd],[CRCheckCd],[PrmptReasonCd],[ShipMethCd],[ExpediteCd],[CurrencyFmtCd],[POTaxStatus],[SrvrTimeZone],[LocTimeZone],[DaylightSave],[CRDelinqDays],[SFZipDigits],[CostPctPrice],[InfoMsgSec],[ErrorMsgSec],[SwipePrmptSec],[PrmptSec],[RcvLblDfltNo],[RcvLblMaxNo],[ROPDays],[SSCC],[WarehouseInd],[EnterSTInd],[GroupPricingInd],[MaintainIMQtyInd],[ReqPOInd],[MenusUsedInd],[ReqRequisitionInd],[OEAutoHoldInd],[UseQueuesInd],[ShipHold1Ind],[VendorPerformInd],[UseEDIInd],[PrintRqstInd],[LotTrackInd],[PalletInd],[PrmptBinInd],[SerialNoInd],[PackSlipPrintInd],[InvoicePrintInd],[SerialNoPrintInd],[RFPrintInd],[FtCollectInd],[ShippedOrderInd],[SuppDscPrintInd],[CostCtrInd],[ShipModuleInd],[UsePTLInd],[CIStartsJobInd],[COStopsJobInd],[StopJobStartJobInd],[StartJobStopJobInd],[PrmptWONoInd],[PrmptBadgeNoInd],[UseASNOdomInd],[ShipInFullInd],[ComplItemShipInd],[CartonPrintINd],[ActivatePhyInd],[UseScaleInd],[TransferInd],[UseEFMenuInd],[ActivityPhyInd],[ShipConfirmInd],[DimensionInd],[PTLIMQtyInd],[SODupItemsInd],[LPNControlInd],[ILTBatchControlInd],[ILTStartTransInd],[ItemPromptInd],[EndCrtnDocsInd],[PickEndInd],[PickLabelInd],[VendorPOInd],[UseOdomInd],[UnderRecPrmptInd],[SOEDetailItemInd],[AllowMultiCopiesInd],[CreateLPNPrmptInd],[AllowMultiLPNInd],[DefaultBinInd],[DefaultItemInd],[MultiUMInd],[ReformToItemInd],[MoveDocPromptInd],[SupportRepInd],[UseDefltSellStkUMInd],[LocCrtnPrefix],[PTLCrtnPrefix],[ReceiverPrefix],[ShipperForm],[BOLForm],[InvForm],[POForm],[ARStmt],[APCheck],[ShipLabel],[BlindRecForm],[AckDfltPrinter],[BlindRcvDfltPrinter],[BOLDfltPrinter],[CheckDfltPrinter],[DMDfltPrinter],[InvDfltPrinter],[PODfltPrinter],[PSDfltPrinter],[ShipDfltPrinter],[ShipLblDfltPrinter],[StmntDfltPrinter],[CircaRPDfltHost],[PSHDfltPrinter],[CInvDfltPrinter],[PhysTagDfltPrinter],[EntryDt],[EntryID],[ChangeDt],[ChangeID],[StatusCd],[WhseSQFT],[OfficeSQFT],[TotalSQFT],[LocSalesGrp],[LocIMRegion],[WCShipDftlPrinter],[RmtShipDfltPrinter],[PriorityShipDfltPrinter],[HubSort],fTransVendorMasterID,AllowPartialRcptsInd,ReceivingMode,DefaultFromBinInd,SODisplayProd,IMBranchSort,IMDisplayColor,BigQuoteMinimum,ShortCode,AllowSplitEDI,USDutyCalcReq,VirtualLocationName,VirtualLocationNo,VirtualBinZone,ShipFromSupportBr1,ShipFromSupportBr2,ShipFromSupportBr3,ShipFromSupportBr4";

            DataSet dsLocationMaster = new DataSet();
            dsLocationMaster = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            return dsLocationMaster.Tables[0];
        }
        //select a.ListValue from listdetail a,listmaster b where plistmasterid=flistmasterid and listname='country'

        public DataTable GetListValue(string listName)
        {
            string _whereClause = "b.plistmasterid=a.flistmasterid and b.listname='" + listName + "' order by a.sequenceno";
            string _tableName = "listdetail a,listmaster b (NOLOCK) ";
            string _columnName = "a.ListValue as ListValue,a.ListValue +' - '+ a.ListDtlDesc as 'Desc'";

            DataSet dsListValue = new DataSet();
            dsListValue = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            return dsListValue.Tables[0];
        }
        public void GetLocList(DropDownList ddlLoc)
        {
            string tableName = "LocMaster (NOLOCK) ";
            string columnName = "convert(varchar(10),LocID) +' - ' + LocName as ListDesc,rtrim(LocID) as ListValue";
            string where = "MaintainIMQtyInd='Y' order by LocID ASC";
            DataSet dsLoc = GetDataToDateSet(tableName, columnName, where);
            if (dsLoc != null && dsLoc.Tables[0].Rows.Count > 0)
                BindDropDown(ddlLoc, dsLoc.Tables[0], "ListDesc", "ListValue", "--- Select Location ---");
            else
            {
                ddlLoc.Items.Insert(0, new ListItem("---N/A---", ""));
            }
        }
        public void GetCountryList(DropDownList ddlCountry)
        {
            string tableName = "CountryMaster (NOLOCK) ";
            string columnName = "CountryCd,Name";
            string where = "1=1 order by Name";
            DataSet dsCountry = GetDataToDateSet(tableName, columnName, where);
            if (dsCountry != null && dsCountry.Tables[0].Rows.Count > 0)
                BindDropDown(ddlCountry, dsCountry.Tables[0], "Name", "CountryCd", "--- Select Country ---");
            else
            {
                ddlCountry.Items.Insert(0, new ListItem("---N/A---", ""));
            }
        }
        public void GetExpediteList(DropDownList ddlExpedite)
        {
            string tableName = "Tables (NOLOCK) ";
            string columnName = "shortdsc";
            string where = "TableType='EXPD' order by shortdsc";
            DataSet dsExpedite = GetDataToDateSet(tableName, columnName, where);
            if (dsExpedite != null && dsExpedite.Tables[0].Rows.Count > 0)
                BindDropDown(ddlExpedite, dsExpedite.Tables[0], "shortdsc", "shortdsc", "-- Select --");
            else
            {
                ddlExpedite.Items.Insert(0, new ListItem("---N/A---", ""));
            }
        }
        public void GetPrinterList(DropDownList ddlPrinter)
        {
            string tableName = "PrinterList (NOLOCK) ";
            string columnName = " PrinterPath";
            string where = " 1=1 order by PrintServer";
            DataSet dsExpedite = GetDataToDateSet(tableName, columnName, where);
            if (dsExpedite != null && dsExpedite.Tables[0].Rows.Count > 0)
                BindDropDown(ddlPrinter, dsExpedite.Tables[0], "PrinterPath", "PrinterPath", "-- Select --");
            else
            {
                ddlPrinter.Items.Insert(0, new ListItem("---N/A---", ""));
            }
        }
        public void BindListValue(string listName, string defaultString, DropDownList ddlList)
        {
            DataTable dtList = GetListValue(listName);
            if (dtList != null)
            {
                ddlList.DataSource = dtList;
                ddlList.DataTextField = "Desc";
                ddlList.DataValueField = "ListValue";
                ddlList.DataBind();
            }
            ddlList.Items.Insert(0, new ListItem(defaultString, ""));
        }

        /// <summary>
        /// Code to Bind the drop down
        /// </summary>
        /// <param name="ddlCurrent"></param>
        /// <param name="dataSource"></param>
        /// <param name="textField"></param>
        /// <param name="valueField"></param>
        /// <param name="defaultText"></param>
        public void BindDropDown(DropDownList ddlCurrent, DataTable dataSource, string textField, string valueField, string defaultText)
        {
            try
            {
                if (dataSource != null && dataSource.Rows.Count > 0)
                {
                    ddlCurrent.DataSource = dataSource;
                    ddlCurrent.DataTextField = textField;
                    ddlCurrent.DataValueField = valueField;
                    ddlCurrent.DataBind();

                    // Code to add default selected item
                    ddlCurrent.Items.Insert(0, new ListItem(defaultText, ""));
                }
                else
                    // Code to add default selected item
                    ddlCurrent.Items.Add(new ListItem("N/A", ""));
            }
            catch (Exception ex) { }
        }

        public DataTable GetVendorID(string vendNo)
        {
            try
            {
                string _whereClause = "vendno='" + vendNo + "'";
                string _tableName = "vendormaster (NOLOCK) ";
                string _columnName = "vendno,pVendMstrID";

                DataSet dsVendValue = new DataSet();
                dsVendValue = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsVendValue.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        public string GetVendorNumber(string vendID)
        {
            try
            {
                string _whereClause = "pVendMstrID=" + vendID;
                string _tableName = "vendormaster (NOLOCK) ";
                string _columnName = "vendno";

                string vendorNumber = SqlHelper.ExecuteScalar(connectionString, "pSOESelect",
                                      new SqlParameter("@tableName", _tableName),
                                      new SqlParameter("@columnNames", _columnName),
                                      new SqlParameter("@whereClause", _whereClause)).ToString();
                return vendorNumber;
            }
            catch (Exception ex)
            {
                return "";
            }
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
                object objSecurityCode = (object)SqlHelper.ExecuteScalar(connectionString, "pSOESelect",
                    new SqlParameter("@tableName", securityTable),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and (SU.DeleteDt is null or SU.DeleteDt = '') and (SM.DeleteDt is null or SM.DeleteDt = '') and (SG.DeleteDt is null or SG.DeleteDt = '') and SU.UserName='" + userName + "' AND (SG.groupname='MAINTENANCE (W)' OR  SG.groupname='LOCMSTR (W)')"));

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