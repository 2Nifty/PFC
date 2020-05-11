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
        string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
        string GERRTSInsertColumns = "VendNo, PONo, ItemNo, GERRTSStatCd, PalletCnt, Qty, QtyRemaining, GrossWght, PortofLading, LocCd, MfgPlant, EntryID, EntryDt, StatusCd";
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
        private string _CurPalPtnrValue = string.Empty;
        /// <summary>
        /// Get RTS AppPref Record
        /// </summary>
        public string GetAppPref(string OptType)
        {
            //try
            //{
            DataSet dsAppPref = new DataSet();
            dsAppPref = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[UGEN_SP_Select]",
                    new SqlParameter("@tableName", "AppPref"),
                    new SqlParameter("@displayColumns", "AppOptionValue"),
                    new SqlParameter("@whereCondition", " (ApplicationCd = 'RTS') AND (AppOptionType = '" + OptType + "')"));
            //}
            //catch (Exception ex)
            //{
            //}
            return dsAppPref.Tables[0].Rows[0]["AppOptionValue"].ToString(); ;
        }

        /// <summary>
        /// Move Detail to Hist and Clear Tables
        /// </summary>
        public string ClearWeek()
        {
            try
            {
                int result = SqlHelper.ExecuteNonQuery(Global.ReportsConnectionString, "[pGERRTSClearWeek]");
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
                int result = SqlHelper.ExecuteNonQuery(Global.ReportsConnectionString, "[pGERRTSCalcRecommended]",
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
            cn.ConnectionString = Global.ReportsConnectionString;
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
            cn.ConnectionString = Global.ReportsConnectionString;
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
            DataTable dtSource = new DataTable();
            DataSet dsVendor = new DataSet();
            //try
            //{
            //dsVendor = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["NVConnectionString"].ToString(), "[UGEN_SP_Select]",
            //        new SqlParameter("@tableName", "[Porteous$Vendor]"),
            //        new SqlParameter("@displayColumns", "No_ + ' ~ ' + No_ as No_ ,Name"),
            //        new SqlParameter("@whereCondition", "1=1"));

            ////}
            ////catch (Exception ex) { }
            //if (dsVendor.Tables[0] != null)
            //{
            //    dtSource = dsVendor.Tables[0];
            //}

            try
            {
                dsVendor = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["NVConnectionString"].ToString(), "[UGEN_SP_Select]",
                    new SqlParameter("@tableName", "[Porteous$Vendor]"),
                    new SqlParameter("@displayColumns", "distinct [Search Name] as ShortCode"),
                    new SqlParameter("@whereCondition", "([Vendor Posting Group] = 'PRODMAT') and (isnull([Search Name],'') >= 'A') order by [Search Name]"));

            }
            catch (Exception ex) { }
            if (dsVendor.Tables[0] != null)
            {
                //dtSource.Merge(dsVendor.Tables[0]);
                dtSource = dsVendor.Tables[0];
            }
            return dtSource;
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
            SqlHelper.ExecuteDataset(connectionString, "[pVMI_Delete]",
                         new SqlParameter("@tableName", "GERRTS"),
                         new SqlParameter("@whereClause", "StatusCd >= '01' and VendNo = '" + VendorValue + "'"));
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
                    insertValues = "'" + VendorValue + "',";
                    insertValues += "'" + POValue + "',";
                    insertValues += "'" + PartValue + "',";
                    insertValues += "'" + PalletPartnerValue + "',";
                    insertValues += "'" + PalletsValue.ToString() + "',";
                    //insertValues += "'0',";
                    insertValues += CartonsValue + ",";
                    insertValues += recctr.ToString() + ",";
                    insertValues += WeightValue + ",";
                    insertValues += "'" + PortOfLadingValue + "',";
                    insertValues += "'" + LocationValue + "',";
                    insertValues += "'" + MfgPlantValue + "',";
                    insertValues += "'" + UserName + "',";
                    insertValues += "'" + DateTime.Now.ToString() + "',";
                    insertValues += "'" + RecStatus + "'";
                    try
                    {
                        SqlHelper.ExecuteDataset(connectionString, "[ugen_sp_insert]",
                                     new SqlParameter("@tableName", "GERRTS"),
                                     new SqlParameter("@columnNames", GERRTSInsertColumns),
                                     new SqlParameter("@columnValues", insertValues));
                    }
                    catch (Exception ex)
                    {
                        LineProblems += "Write; ";
                        RecStatus = "99";
                        insertValues = "'" + VendorValue + "',";
                        insertValues += "'',";
                        insertValues += "'',";
                        insertValues += "'',";
                        insertValues += "'0',";
                        insertValues += "0,";
                        insertValues += recctr.ToString() + ",";
                        insertValues += "0,";
                        insertValues += "'',";
                        insertValues += "'',";
                        insertValues += "'',";
                        insertValues += "'" + UserName + "',";
                        insertValues += "'" + DateTime.Now.ToString() + "',";
                        insertValues += "'" + RecStatus + "'";
                        SqlHelper.ExecuteDataset(connectionString, "[ugen_sp_insert]",
                                     new SqlParameter("@tableName", "GERRTS"),
                                     new SqlParameter("@columnNames", GERRTSInsertColumns),
                                     new SqlParameter("@columnValues", insertValues));
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
                        try
                        {
                            LocationValue = RTSPOLineLocationCode;
                            PalletPartnerValue = RTSPalPtnrValue;
                            if (RTSPOLineQty != int.Parse(Cols[CartonsCol].Replace(",", "")))
                            {
                                LineProblems += "PO Line Qty Mismatch; ";
                                RecStatus = "13";
                            }
                        }
                        catch (Exception ex)
                        {
                            LineProblems += "Failed ValidatePOLine; ";
                            RecStatus = "14";
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
                        CartonsValue = Cols[CartonsCol].Replace(",", "");
                        CartonsValue = int.Parse(Cols[CartonsCol].Replace(",", "")).ToString();
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
                    DataSet dsItem = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                    new SqlParameter("@tableName", "ItemMaster"),
                    new SqlParameter("@displayColumns", "ItemNo"),
                    new SqlParameter("@whereCondition", "ItemNo='" + Item + "'"));
                    if (dsItem.Tables[0].Rows.Count > 0) return true;
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
                    DataSet dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["NVConnectionString"].ToString(), "UGEN_SP_Select",
                        new SqlParameter("@tableName", "[Porteous$Purchase Header]"),
                        new SqlParameter("@columnNames", "[No_]"),
                        new SqlParameter("@whereClause", "[No_]='" + PO + "'"));
                    if (dsGER.Tables[0].Rows.Count > 0) return true;
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
            DataSet dsGER = new DataSet();
            try
            {
                if (PO != "" && Item != "")
                {
                    RTSPOLineLocationCode = "";
                    dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["NVConnectionString"].ToString(), "UGEN_SP_Select",
                        new SqlParameter("@tableName", " [Porteous$Purchase Line]"),
                        new SqlParameter("@columnNames", "[Location Code], [PO Status Code], convert(bigint, [Outstanding Quantity])"),
                        new SqlParameter("@whereClause", "[Document No_]='" + PO + "' and No_='" + Item + "' and [Outstanding Quantity] > 0 and [PO Status Code] <> 'B'"));
                    if (dsGER.Tables[0].Rows.Count > 0)
                    {
                        RTSPOLineLocationCode = dsGER.Tables[0].Rows[0][0].ToString();
                        RTSPalPtnrValue = dsGER.Tables[0].Rows[0][1].ToString();
                        RTSPOLineQty = int.Parse(dsGER.Tables[0].Rows[0][2].ToString().Replace(",",""));
                        return true;
                    }
                }
            }
            catch (Exception ex)
            {
                LineProblems += "PO Line Get Failure " + dsGER.Tables[0].Rows[0][2].ToString() + "; ";
            }
            return false;
        }


        /// <summary>
        /// Add Vendor Excel data to GERRTS tables
        /// </summary>
        public void LoadVendorData(string VendorValue)
        {
            SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Update]",
                new SqlParameter("@tableName", "GERRTS"),
                new SqlParameter("@columnNames", "GERRTS.StatusCd = '00', GERRTS.QtyRemaining = GERRTS.Qty, GERRTS.GrossWght=GERRTS.Qty*ItemMaster.GrossWght from ItemMaster "),
                new SqlParameter("@whereCondition", "ItemMaster.ItemNo = GERRTS.ItemNo and (GERRTS.StatusCd between '01' and '19') and GERRTS.VendNo = '" + VendorValue + "'"));
            SqlHelper.ExecuteDataset(connectionString, "[pVMI_Delete]",
                new SqlParameter("@tableName", "GERRTS"),
                new SqlParameter("@whereClause", "(StatusCd between '20' and 'ZZ') and VendNo = '" + VendorValue + "'"));
        }

        /// <summary>
        /// Indicates that Recommended Calcs have been processed
        /// </summary>
        public Boolean CalcProcessed()
        {
            DataSet ds = new DataSet(); 
            try
            {
                ds = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[UGEN_SP_Select]",
                    new SqlParameter("@tableName", "GERRTSProcTracking"),
                    new SqlParameter("@displayColumns", "count(*) as IsProcessed"),
                    new SqlParameter("@whereCondition", "ProcessName = 'CalcRecommended'"));
            }
            catch (Exception ex) { }
            if (ds.Tables[0] != null)
            {
                DataRow dr = ds.Tables[0].Rows[0];
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
        public void ItemPageCmdClose(string ItemNo)
        {
            //try
            //{
            int result = SqlHelper.ExecuteNonQuery(Global.ReportsConnectionString, "[pGERRTSUpdHdrStatus]",
                      new SqlParameter("@ItemNo", ItemNo));
            //}
            //catch (Exception ex)
            //{
            //}
            //return null;
        }

        /// <summary>
        /// Return Vendor/POL Drop Down contents
        /// </summary>
        public DataSet VendorPortDDL()
        {
            try
            {
                DataSet dsVendorPort = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[pGERRTSVendPortDDL]");
                return dsVendorPort;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        /// <summary>
        /// Return data for Vendor/POL
        /// </summary>
        public DataSet GetVendorSummary(string Vendor, string Port)
        {
            try
            {
                DataSet dsVendorPort = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[pGERRTSGetVendorSummary]",
                          new SqlParameter("@Vendor", Vendor),
                          new SqlParameter("@Port", Port));
                return dsVendorPort;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        /// <summary>
        /// Create Advice records
        /// </summary>
        public string CreateAdvice(string Vendor, string Port)
        {
            // after the advice records are created a dataset send back a table with a status message
            // this message is passed back as the status of the operation
            try
            {
                DataSet dsVendorPort = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[pGERRTSGetVendorSummary]",
                          new SqlParameter("@Vendor", Vendor),
                          new SqlParameter("@Port", Port));
                DataRow StatusRow = dsVendorPort.Tables[0].Rows[0];
                return StatusRow["StatMsg"].ToString(); ;
            }
            catch (Exception ex)
            {
                return "Operation failed!";
            }
        }

        /// <summary>
        /// Return Vendor Advice Drop Down contents
        /// </summary>
        public DataSet VendorAdviceDDL()
        {
            try
            {
                DataSet dsVendorPort = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[pGERRTSVendAdviceDDL]");
                return dsVendorPort;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        /// <summary>
        /// Return Vendor Advice detail by Item
        /// </summary>
        public DataSet SelectItemVendorDDL(string Vendor)
        {
            try
            {
                DataSet dsVendorPort = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[pGERRTSGetVendorSummary]",
                          new SqlParameter("@Vendor", Vendor));
                return dsVendorPort;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        
        /// <summary>
        /// Load Vendor contact data from Excel file
        /// </summary>
        public DataSet LoadVendorContacts(string ShortCode)
        {
            DataSet dsVendorContactData = new DataSet();
            OleDbConnectionStringBuilder builder = new OleDbConnectionStringBuilder();
            builder["Provider"] = "Microsoft.Jet.OLEDB.4.0";
            builder["Data Source"] = @"\\PFCDEV\Lib\RTS\VendorContactsList.xls";
            builder["User Id"] = "Admin";
            builder["Extended Properties"] = "Excel 8.0;HDR=YES;";

            OleDbConnection cno = new OleDbConnection();
            cno.ConnectionString = builder.ToString();
            cno.Open();
            OleDbDataAdapter adapter = new OleDbDataAdapter("select * from [Sheet1$] where [Search Name] = '" + ShortCode + "'", cno);
            adapter.Fill(dsVendorContactData, "VendorContacts");
            //OleDbCommand commando = new OleDbCommand();
            //commando.Connection = cno;
            ////commando.CommandTimeout = TimeOut;
            //commando.CommandText = "select * from [Sheet1$]";
            //OleDbDataReader dsVendorContactData = commando.ExecuteReader();
            cno.Close();
            return dsVendorContactData;

        }
    }
}
