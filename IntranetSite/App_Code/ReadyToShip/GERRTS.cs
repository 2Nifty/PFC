#region Namespace
using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.Configuration;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
#endregion

/// <summary>
/// GoodsEnRoute (GER). This class handles data processing fuctions for GER Ready To Ship screens
/// </summary>
namespace PFC.Intranet.BusinessLogicLayer
{
    public class GERRTS
    {
        //
        // Global Variables Declaration
        //
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        //string GERRTSInsertColumns = "VendNo, PONo, ItemNo, GERRTSStatCd, PalletCnt, Qty, QtyRemaining, GrossWght, PortofLading, LocCd, MfgPlant, EntryID, EntryDt, StatusCd";
        string LineProblems;
        int VendorCol;
        int POCol;
        int PartCol;
        int PalletCol;
        int CartonsCol;
        int WeightCol;
        int PortOfLadingCol;
        int MfgPlantCol;
        bool InHeading = true;
        string RecStatus = "";
        string ImportVendorValue = "";
        string POValue = "";
        string PartValue = "";
        string PalletPartnerValue = "";
        string PalletsValue = "";
        string CartonsValue = "";
        string WeightValue = "";
        string PortOfLadingValue = "";
        string LocationValue = "";
        string MfgPlantValue = "";
        int HoldWeeks = 0;
        string insertValues = "";
        int recctr = 0;
        Regex PartPattern = new Regex(@"\d{5}-\d{4}-\d{3}");
        Match PartMatch;
        //PartPattern = new Regex(@"\d{5}-\d{4}-\d{3}");

        public string RTSPO
        {
            get { return _CurPO; }
            set { _CurPO = value; }
        }
        public string RTSItem
        {
            get { return _CurItem; }
            set { _CurItem = value; }
        }
        public string RTSShortCode
        {
            get { return _CurShortCode; }
            set { _CurShortCode = value; }
        }
        public string RTSVendorNo
        {
            get { return _CurVendorNo; }
            set { _CurVendorNo = value; }
        }
        public string RTSPOLineLocationCode
        {
            get { return _CurPOLineLoc; }
            set { _CurPOLineLoc = value; }
        }
        public int RTSPOLineQty
        {
            get { return _CurPOLineQty; }
            set { _CurPOLineQty = value; }
        }
        public int RTSHoldWeeks
        {
            get { return _CurRTSHoldWeeks; }
            set { _CurRTSHoldWeeks = value; }
        }
        public string RTSPalPtnrValue
        {
            get { return _CurPalPtnrValue; }
            set { _CurPalPtnrValue = value; }
        }
        private string _CurPO = string.Empty;
        private string _CurItem = string.Empty;
        private string _CurShortCode = string.Empty;
        private string _CurVendorNo = string.Empty;
        private string _CurPOLineLoc = string.Empty;
        private int _CurPOLineQty;
        private int _CurRTSHoldWeeks;
        private string _CurPalPtnrValue = string.Empty;
        /// <summary>
        /// Get RTS AppPref Record
        /// </summary>
        public string GetAppPref(string OptType)
        {
            //try
            //{
            DataSet dsAppPref = new DataSet();
            dsAppPref = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                    new SqlParameter("@tableName", "AppPref"),
                    new SqlParameter("@displayColumns", "coalesce(nullif(rtrim(AppOptionValue), ''), AppOptionTypeDesc) as AppOptionValue"),
                    new SqlParameter("@whereCondition", " (ApplicationCd = 'RTS') AND (AppOptionType = '" + OptType + "')"));
            //}
            //catch (Exception ex)
            //{
            //}
            return dsAppPref.Tables[0].Rows[0]["AppOptionValue"].ToString(); ;
        }

        /// <summary>
        /// Add accepted data to PO updates for leter processing
        /// </summary>
        public string CreatePOUpdates(string VendNo, string PortofLading, string LocCd, string ReceiptDate, string UserID)
        {
            try
            {
                int result = SqlHelper.ExecuteNonQuery(connectionString, "pGERRTSCreatePOUpdates",
                    new SqlParameter("@Vendor", VendNo),
                    new SqlParameter("@PortofLading", PortofLading),
                    new SqlParameter("@PFCLoc", LocCd),
                    new SqlParameter("@ReceiptDate", ReceiptDate),
                    new SqlParameter("@EntryID", UserID));
                return "";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        /// <summary>
        /// Move Detail to Hist and Clear Tables
        /// </summary>
        public string ClearWeek()
        {
            try
            {
                int result = SqlHelper.ExecuteNonQuery(connectionString, "pGERRTSClearWeek");
                return "";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        /// <summary>
        /// Create recommended qtys
        /// </summary>
        public string CalcRecommended(string UserName)
        {
            try
            {
                int result = SqlHelper.ExecuteNonQuery(connectionString, "pGERRTSCalcRecommended",
                    new SqlParameter("@EntryID", UserName),
                    new SqlParameter("@IncludeSummQtys", "FALSE"));
                return "";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }

        public string CalcRecommended(string UserName, int TimeOut)
        {
            SqlConnection cn = new SqlConnection();
            cn.ConnectionString = connectionString;
            cn.Open();
            SqlCommand command = new SqlCommand();
            command.Connection = cn;
            command.CommandTimeout = TimeOut;
            command.CommandText = "exec pGERRTSCalcRecommended '" + UserName + "'";
            try
            {
                int rs = command.ExecuteNonQuery();
                return "";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            cn.Close();
        }
        public string CalcRecommended(string UserName, int TimeOut, string IncludeSummQtys)
        {
            SqlConnection cn = new SqlConnection();
            cn.ConnectionString = connectionString;
            cn.Open();
            SqlCommand command = new SqlCommand();
            command.Connection = cn;
            command.CommandTimeout = TimeOut;
            command.CommandText = "exec pGERRTSCalcRecommended '" + UserName + "', '" + IncludeSummQtys.ToUpper() + "'";
            try
            {
                int rs = command.ExecuteNonQuery();
                return "";
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
            cn.Close();
        }

        /// <summary>
        /// Return Vendor Drop Down contents
        /// </summary>
        public DataTable VendorRTSDDL()
        {
            return WorkFormsData("VendorRTSDDL", "", "");
        }

        public DataTable VendorAdviceDDL()
        {
            return WorkFormsData("VendorAdviceDDL", "", "");
        }

        public DataTable VendorContacts(string VendorValue)
        {
            return WorkFormsData("VendorContacts", VendorValue, "");
        }

        public DataTable AdviceData(string VendorValue)
        {
            return WorkFormsData("AdviceData", VendorValue, "");
        }

        public DataTable WorkFormsData(string Action, string Filter, string UserID)
        {

            return WorkFormsData(Action, Filter, "", "", "", ""
                , "0", "0", "0", "0.0", "", "", "", "", "0", UserID);
        }

        public DataTable WorkPOData(string Action, string PONo, string ItemNo)
        {

            return WorkFormsData(Action, "", "", PONo, ItemNo, ""
                , "0", "0", "0", "0.0", "", "", "", "", "0", "");
       }

        public DataTable DeleteRTSLine(string VendNo, string PONo, string ItemNo)
        {

            return WorkFormsData("DeleteRTSLine", "", VendNo, PONo, ItemNo, ""
                , "0", "0", "0", "0.0", "", "", "", "", "0", "");
       }

        public DataTable WorkFormsData(string Action, string Filter, string VendNo, string PONo, string ItemNo, string GERRTSStatCd
            , string PalletCnt, string Qty, string QtyRemaining, string GrossWght, string PortofLading
            , string LocCd, string MfgPlant, string StatusCd, string HoldWeeks, string UserID)
       {

            //try
            //{
            DataSet ds = SqlHelper.ExecuteDataset(connectionString, "pGERRTSFormsData",
                new SqlParameter("@Action", Action),
                new SqlParameter("@Filter", Filter),
                new SqlParameter("@VendNo", VendNo),
                new SqlParameter("@PONo", PONo),
                new SqlParameter("@ItemNo", ItemNo),
                new SqlParameter("@GERRTSStatCd", GERRTSStatCd),
                new SqlParameter("@PalletCnt", PalletCnt),
                new SqlParameter("@Qty", Qty),
                new SqlParameter("@QtyRemaining", QtyRemaining),
                new SqlParameter("@GrossWght", GrossWght),
                new SqlParameter("@PortofLading", PortofLading),
                new SqlParameter("@LocCd", LocCd),
                new SqlParameter("@MfgPlant", MfgPlant),
                new SqlParameter("@StatusCd", StatusCd),
                new SqlParameter("@HoldWeeks", HoldWeeks),
                new SqlParameter("@UserID", UserID));

            //}
            //catch (Exception ex) { }
            if (ds.Tables.Count > 0)
            {
                return ds.Tables[0];
            }
            else
            {
                return null;
            }
        }

        /// <summary>
        /// Load Excel file from Vendor
        /// </summary>
        public DataSet ParseEngine(string FilePath, string VendorValue, Boolean PalletPartnerChecked, string UserName)
        {
            DataSet dsVendorData = new DataSet();
            DataTable dtSource = new DataTable();
            dtSource.Columns.Add("Line", typeof(String));
            dtSource.Columns.Add("Problem", typeof(String));
            dtSource.Columns.Add("OriginalLine", typeof(String));
            string[] delimiter = new string[] { "\t" };
            String RTSLine;
            String LineProblems = "";
            PartCol = -1;
            RTSVendorNo = VendorValue;
            WorkFormsData("ClearVendorRTS", VendorValue, ""); 
            // Now scan the contents
            using (StreamReader sr = new StreamReader(FilePath))
            {
              while ((RTSLine = sr.ReadLine()) != null)
              {
                string[] Cols = RTSLine.Split(delimiter, StringSplitOptions.RemoveEmptyEntries);
                POValue= "";
                PartValue= "";
                PalletPartnerValue= "";
                PalletsValue = "";
                CartonsValue = "";
                WeightValue = "";
                PortOfLadingValue = "";
                LocationValue = "";
                MfgPlantValue = "";
                RecStatus = "";
                string[] LineResults = ValidateInputColumns(Cols, PalletPartnerChecked);
                LineProblems = LineResults[1];
                RecStatus = LineResults[0];
                if (RecStatus != "EM")
                {
                    try
                    {
                        WorkFormsData("InsertRTS"
                            , ""
                            , VendorValue
                            , POValue
                            , PartValue
                            , PalletPartnerValue
                            , PalletsValue.ToString()
                            , CartonsValue
                            , recctr.ToString()
                            , WeightValue
                            , PortOfLadingValue
                            , LocationValue
                            , MfgPlantValue
                            , RecStatus
                            , HoldWeeks.ToString()
                            , UserName);
                    }
                    catch (Exception ex)
                    {
                        LineProblems += "Write; ";
                        RecStatus = "99";
                        WorkFormsData("InsertRTS"
                          , ""
                          , VendorValue
                          , ""
                          , ""
                          , ""
                          , "0"
                          , "0"
                          , recctr.ToString()
                          , "0"
                          , ""
                          , ""
                          , ""
                          , RecStatus
                          , "0"
                          , UserName);
                    }
                }
                dtSource.Rows.Add(new Object[] { recctr.ToString(), LineProblems, RTSLine.Replace("\"", "      ") });
                recctr += 1;
              }
            }
            dsVendorData.Tables.Add(dtSource);
            return dsVendorData;

        }

        public String[] ValidateInputColumns(string[] Cols, Boolean PalletPartnerChecked)
        {
            string[] ReturnValues = new string[2];
            LineProblems = "Empty";
            string RecStatus = "EM";
            if (Cols.Length > 0)
            {
                // parse the line
                PartCol = -1;
                LineProblems = "";
                RecStatus = "01";
                // figure out which column has the part number
                for (int i = 0; i < Cols.Length; i++)
                {
                    PartMatch = PartPattern.Match(Cols[i]);
                    if (PartMatch.Success)
                    {
                        PartCol = i;
                        POCol = i - 1;
                        VendorCol = i - 2;
                        PalletCol = i + 1;
                        CartonsCol = i + 2;
                        WeightCol = i + 3;
                        PortOfLadingCol = i + 4;
                        MfgPlantCol = i + 5;
                    }
                }
                if (PartCol != -1) 
                {
                    try
                    {
                        if (PartPattern.IsMatch(Cols[PartCol]))
                        {
                            PartValue = Cols[PartCol];
                            if (!ValidateItemNo(PartValue))
                            {
                                LineProblems += "No Item; ";
                                RecStatus = "20";
                            }
                        }
                        else
                        {
                            LineProblems += "Bad Item" + PartCol.ToString() + "; ";
                            RecStatus = "21";
                        }
                    }
                    catch (Exception ex)
                    {
                        LineProblems += "Bad Item; ";
                        RecStatus = "22";
                    }
                    try
                    {
                        ImportVendorValue = Cols[VendorCol].Trim();
                    }
                    catch (Exception ex)
                    {
                        LineProblems += "Bad Vendor; ";
                        RecStatus = "23";
                    }
                    if (RTSVendorNo.ToUpper() != ImportVendorValue.ToUpper())
                    {
                        LineProblems += "Vendor Mismatch; ";
                        RecStatus = "24";
                    }
                    try
                    {
                        POValue = Cols[POCol];
                    }
                    catch (Exception ex)
                    {
                        LineProblems += "Bad PO; ";
                        RecStatus = "25";
                    }
                    if (!ValidatePONo(POValue))
                    {
                        LineProblems += "PO Not Found; ";
                        RecStatus = "11";
                    }
                    if (!ValidatePOLine(POValue, PartValue))
                    {
                        LineProblems += "PO Line Not Found; ";
                        RecStatus = "12";
                    }
                    else
                    {
                        LocationValue = RTSPOLineLocationCode;
                        PalletPartnerValue = RTSPalPtnrValue;
                        HoldWeeks = RTSHoldWeeks;
                        if (RTSPOLineQty != int.Parse(Cols[CartonsCol].Replace(",","")))
                        {
                            LineProblems += "PO Line Qty Mismatch; ";
                            RecStatus = "13";
                        }
                    }
                    PalletPartnerValue = SetRTSLinePriority(PalletPartnerChecked, PalletPartnerValue, POValue);
                    try
                    {
                        PalletsValue = Cols[PalletCol];
                    }
                    catch (Exception ex)
                    {
                        LineProblems += "Bad Pallets; ";
                        RecStatus = "26";
                    }
                    try
                    {
                        CartonsValue = Cols[CartonsCol];
                    }
                    catch (Exception ex)
                    {
                        LineProblems += "Bad Cartons; ";
                        RecStatus = "27";
                    }
                    try
                    {
                        WeightValue = Cols[WeightCol];
                    }
                    catch (Exception ex)
                    {
                        LineProblems += "Bad Weight; ";
                        RecStatus = "28";
                    }
                    try
                    {
                        PortOfLadingValue = Cols[PortOfLadingCol].Replace("\"", "").Split(new Char[] { ',' })[0];
                        if (PortOfLadingValue.Length > 40) PortOfLadingValue = PortOfLadingValue.Substring(0,4);
                    }
                    catch (Exception ex)
                    {
                        LineProblems += "Bad Port; ";
                        RecStatus = "29";
                    }
                    if (MfgPlantCol >= Cols.Length)
                    {
                        MfgPlantValue = "None";
                    }
                    else
                    {
                        try
                        {
                            MfgPlantValue = Cols[MfgPlantCol];
                            if (MfgPlantValue.Length > 4) MfgPlantValue = MfgPlantValue.Substring(0, 4);
                        }
                        catch (Exception ex)
                        {
                            LineProblems += "Bad MfgPlant; ";
                            RecStatus = "30";
                        }
                    }
                }
            }
            ReturnValues[0] = RecStatus;
            ReturnValues[1] = LineProblems;
            return ReturnValues;
        }
        
        /// <summary>
        /// ValidatePFCItemNo: Method used to validate the PFCItemNo
        /// </summary>
        /// <param name="strPFCItem"> DataType:String Required PFCItemNo </param>
        /// <returns>Return boolean </returns>
        public Boolean ValidateItemNo(string Item)
        {
            try
            {
                if (Item != "")
                {
                    if (WorkFormsData("ValidateItemNo", Item, "").Rows.Count > 0) return true;
                }
            }
            catch (Exception ex)
            { }
            return false;
        }


        /// <summary>
        /// ValidatePONo: Method used to validate the PO number via NV
        /// </summary>
        /// <param name="strPFCItem"> DataType:String Required PO number </param>
        /// <returns>Return boolean </returns>
        public Boolean ValidatePONo(string PO)
        {
            try
            {
                if (PO != "")
                {
                    if (WorkFormsData("ValidatePONo", PO, "").Rows.Count > 0) return true;
                }
            }
            catch (Exception ex)
            { }
            return false;
        }

        /// <summary>
        /// SetRTSLinePriority: Method used to set StatusCd 
        /// </summary>
        /// <param name="strPFCItem"> DataType:String Required PO number </param>
        /// <returns>Return boolean </returns>
        public string SetRTSLinePriority(bool PalPtnrChecked, string POLinePriority, string PONumber)
        {
            try
            {
                if ((POLinePriority == "G") || (POLinePriority == "M"))
                {
                    return POLinePriority;
                }
                if (PONumber.Substring(0,1) == "5")
                {
                    return "PP";
                }
            }
            catch (Exception ex)
            { }
            return POLinePriority;
        }

        /// <summary>
        /// ValidatePOLine: Method used to validate the PO line exists via NV
        /// also sets location code is line is found
        /// </summary>
        /// <param name="strPFCItem"> DataType:String Required PO number </param>
        /// <returns>Return boolean </returns>
        public Boolean ValidatePOLine(string PO, string Item)
        {
            DataTable dtGER = new DataTable();
            try
            {
                if (PO != "" && Item != "")
                {
                    RTSPOLineLocationCode = "";

                    dtGER = WorkPOData("ValidatePOLine", PO, Item);
                    if (dtGER.Rows.Count > 0)
                    {
                        RTSPOLineLocationCode = dtGER.Rows[0]["Branch"].ToString();
                        RTSPalPtnrValue = dtGER.Rows[0]["LineStatus"].ToString();
                        RTSPOLineQty = int.Parse(dtGER.Rows[0]["QtyRem"].ToString().Replace(",", ""));
                        RTSHoldWeeks = int.Parse(dtGER.Rows[0]["HoldWeeks"].ToString());
                        return true;
                    }
                }
            }
            catch (Exception ex)
            {
                LineProblems += "PO Line Get Failure; ";
            }
            return false;
        }


        /// <summary>
        /// Add Vendor Excel data to GERRTS tables
        /// </summary>
        public void LoadVendorData(string VendorValue)
        {
            WorkFormsData("LoadVendorData", VendorValue, "");
        }

        /// <summary>
        /// Indicates that Recommended Calcs have been processed
        /// </summary>
        public Boolean CalcProcessed()
        {
            DataTable dt = new DataTable(); 
            try
            {
                dt = WorkFormsData("CalcProcessed", "", "");
            }
            catch (Exception ex) { }
            if (dt != null)
            {
                DataRow dr = dt.Rows[0];
                //if (0 == 0)
                if (dr["IsProcessed"].ToString() == "0")
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
        return false;
        }

        /// <summary>
        /// Update GERRTS Priority
        /// </summary>
        //public void ItemPageCmdClose(string ItemNo)
        //{
        //    //try
        //    //{
        //    int result = SqlHelper.ExecuteNonQuery(connectionString, "[pGERRTSUpdHdrStatus]",
        //              new SqlParameter("@ItemNo", ItemNo));
        //    //}
        //    //catch (Exception ex)
        //    //{
        //    //}
        //    //return null;
        //}

        ///// <summary>
        ///// Return Vendor/POL Drop Down contents
        ///// </summary>
        //public DataSet VendorPortDDL()
        //{
        //    try
        //    {
        //        return WorkFormsData("VendPortDDL", "", "");
        //    }
        //    catch (Exception ex)
        //    {
        //        return null;
        //    }
        //}

        ///// <summary>
        ///// Return data for Vendor/POL
        ///// </summary>
        //public DataSet GetVendorSummary(string Vendor, string Port)
        //{
        //    try
        //    {
        //        DataSet dsVendorPort = WorkFormsData("GetVendorSummary", Vendor, Port);
        //        return dsVendorPort;
        //    }
        //    catch (Exception ex)
        //    {
        //        return null;
        //    }
        //}

        ///// <summary>
        ///// Create Advice records
        ///// </summary>
        //public string CreateAdvice(string Vendor, string Port)
        //{
        //    // after the advice records are created a dataset send back a table with a status message
        //    // this message is passed back as the status of the operation
        //    try
        //    {
        //        DataSet dsVendorPort = SqlHelper.ExecuteDataset(connectionString, "[pGERRTSGetVendorSummary]",
        //                  new SqlParameter("@Vendor", Vendor),
        //                  new SqlParameter("@Port", Port));
        //        DataRow StatusRow = dsVendorPort.Tables[0].Rows[0];
        //        return StatusRow["StatMsg"].ToString(); ;
        //    }
        //    catch (Exception ex)
        //    {
        //        return "Operation failed!";
        //    }
        //}

        /// <summary>
        /// Return Vendor Advice Drop Down contents
        /// </summary>
        ///// <summary>
        ///// Return Vendor Advice detail by Item
        ///// </summary>
        //public DataSet SelectItemVendorDDL(string Vendor)
        //{
        //    try
        //    {
        //        DataSet dsVendorPort = SqlHelper.ExecuteDataset(connectionString, "[pGERRTSGetVendorSummary]",
        //                  new SqlParameter("@Vendor", Vendor));
        //        return dsVendorPort;
        //    }
        //    catch (Exception ex)
        //    {
        //        return null;
        //    }
        //}

        /// <summary>
        /// BindListControl: Method used to bind information in Combo
        /// </summary>
        /// <param name="ddl">Required ListControl</param>
        /// <param name="textField"> DataType:String Required textField </param>
        /// <param name="valueField">DataType:String Required valueField </param>
        /// <param name="dtDataSource">Required DataTable</param>
        /// <returns></returns>

        public void BindListControl(ListControl ddl, string textField, string valueField, DataTable dtDataSource)
        {
            try
            {
                ddl.DataSource = dtDataSource;
                ddl.DataTextField = textField;
                ddl.DataValueField = valueField;
                ddl.DataBind();
                ddl.Items.Insert(0, new ListItem("--- Select ---", "0"));

            }
            catch (Exception ex) { }
        }

    }
}
