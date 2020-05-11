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
/// Warehouse Move Forward and Bin Consolidation (FillFace). This class handles data processing fuctions for screens
/// </summary>
namespace PFC.Intranet.BusinessLogicLayer
{
    public class BinItemCapacityData
    {
        //
        // Global Variables Declaration
        //
        string connectionString = ConfigurationManager.AppSettings["PFCRBConnectionString"].ToString();
        string LineProblems;
        string RecStatus = "";
        string LocationValue = "";
        string PartValue = "";
        string BinValue = "";
        string CapacityValue = "";
        int recctr = 0;
        int Capacity = 0;
        //PartPattern = new Regex(@"\d{5}-\d{4}-\d{3}");

        public string LocationCode
        {
            get { return _CurLoc; }
            set { _CurLoc = value; }
        }
        public string Item
        {
            get { return _CurItem; }
            set { _CurItem = value; }
        }
        public string Bin
        {
            get { return _CurBin; }
            set { _CurBin = value; }
        }
        public int Qty
        {
            get { return _CurQty; }
            set { _CurQty = value; }
        }

        private string _CurLoc = string.Empty;
        private string _CurItem = string.Empty;
        private string _CurBin = string.Empty;
        private int _CurQty;

        /// <summary>
        /// Get BIC AppPref Record
        /// </summary>
        public DataTable GetExcelData()
        {
            return WorkFormsData("GetExcel", "Excel%");
        }

        public DataTable GetATicket(string TicketNo)
        {
            return WorkFormsData("GetATicket", TicketNo);
        }

        public DataTable GetLocations()
        {
            return WorkFormsData("LocationDDL", "");
        }

        public DataTable GetTicketSummary(string LocCd)
        {
            return WorkFormsData("GetTicketSummary", LocCd);
        }

        public DataTable GetTicketData(string LocCd, string Status)
        {
            return WorkFormsData("GetTickets", Status, LocCd, "", "", "0", "", "0", "", "");
        }

        public DataTable PrintOK(string LocCd, string Printer, string Filter, string UserID)
        {
            return WorkFormsData("PrintOK", Filter, LocCd, "", "", "0", "", "0", Printer, UserID);
        }

        public DataTable SetPrinted(string Filter)
        {
            return WorkFormsData("SetPrinted", Filter);
        }

        public DataTable SetToProcess(string LocCd, string Filter, string AutoPrint, string Printer, string UserID)
        {
            return WorkFormsData("SetToProcess", Filter, LocCd, "", "", "0", "", AutoPrint, Printer, UserID);
        }

        public DataTable WorkFormsData(string Action, string Filter, 
            string LocCd, string ItemNo, string BinLabel, string BinCapacity,
            string BinStatus, string AutoPrint, string Printer, string UserID)
       {

            //try
            //{
           DataSet ds = SqlHelper.ExecuteDataset(connectionString, "pCreateMoveTicketsForm",
                new SqlParameter("@Action", Action),
                new SqlParameter("@Filter", Filter),
                new SqlParameter("@LocCd", LocCd),
                new SqlParameter("@ItemNo", ItemNo),
                new SqlParameter("@BinLabel", BinLabel),
                new SqlParameter("@BinCapacity", BinCapacity),
                new SqlParameter("@BinStatus", BinStatus),
                new SqlParameter("@AutoPrint", AutoPrint),
                new SqlParameter("@Printer", Printer),
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

        public DataTable WorkFormsData(string Action, string Filter)
        {
            return WorkFormsData(Action, Filter, "", "", "", "0", "", "0", "", "");
        }

        /// <summary>
        /// Load Excel file from Vendor
        /// </summary>
        public string ParseEngine(string FilePath, string UserName)
        {
            string[] delimiter = new string[] { "\t" };
            String ExcelLine;
            String LineProblems = "";
            LocationCode = "";
            WorkFormsData("ClearExcel", ""); 
            // Now scan the contents
            using (StreamReader sr = new StreamReader(FilePath))
            {
              while ((ExcelLine = sr.ReadLine()) != null)
              {
                string[] Cols = ExcelLine.Split(delimiter, StringSplitOptions.RemoveEmptyEntries);
                LocationValue = "";
                PartValue= "";
                BinValue = "";
                CapacityValue = "0";
                RecStatus = "";
                string[] LineResults = ValidateInputColumns(Cols);
                LineProblems = LineResults[1];
                RecStatus = LineResults[0];
                if (RecStatus != "EM")
                {
                    try
                    {
                        WorkFormsData("InsertExcel"
                            , ""
                            , LocationValue
                            , PartValue
                            , BinValue
                            , CapacityValue
                            , "Excel:" + RecStatus
                            , "0"
                            , ""
                            , UserName);
                    }
                    catch (Exception ex)
                    {
                        LineProblems += "Write; ";
                        RecStatus = "99";
                        WorkFormsData("InsertRTS"
                            , ""
                            , LocationValue
                            , PartValue
                            , BinValue
                            , "0"
                            , "Excel:" + RecStatus
                            , "0"
                            , ""
                            , UserName);
                    }
                }
                recctr += 1;
              }
            }
            return "Recs " + recctr.ToString();
        }

        public String[] ValidateInputColumns(string[] Cols)
        {
            string[] ReturnValues = new string[2];
            LineProblems = "Empty";
            string RecStatus = "EM";
            try
            {
                RecStatus = "00";
                if (Cols.Length > 0)
                {
                    // parse the line
                    LocationValue = Cols[0];
                    PartValue = Cols[1];
                    BinValue = Cols[2];
                    CapacityValue = Cols[3];
                    //if (LocationCode != LocationValue)
                    //{
                    if (!ValidateLocationCode(LocationValue))
                    {
                        //LineProblems += "Bad Branch; ";
                        RecStatus = "10" + LocationValue;
                    }
                    //else
                    //{
                    //    LocationCode = LocationValue;
                    //}
                    //}
                    if (!ValidateItemNo(PartValue))
                    {
                        //LineProblems += "Bad Item; ";
                        RecStatus = "11";
                    }
                    if (!int.TryParse(CapacityValue.Replace(",", ""), out Capacity))
                    {
                        //LineProblems += "Bad Qty; ";
                        RecStatus = "13";
                    }
                }
                ReturnValues[0] = RecStatus;
                ReturnValues[1] = LineProblems;
            }
            catch (Exception ex)
            {
                ReturnValues[0] = "99";
                ReturnValues[1] = LineProblems;
            }
            return ReturnValues;
        }

        public string GetAppPref(string OptType)
        {
            return WorkFormsData("GetAppPref", OptType).Rows[0]["AppOptionValue"].ToString(); 
        }

        public void SetLastFile(string FileName)
        {
            WorkFormsData("SetLastFile", FileName);
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
                    if (WorkFormsData("ValidateItemNo", Item).Rows.Count > 0) return true;
                }
            }
            catch (Exception ex)
            { }
            return false;
        }

        /// <summary>
        /// ValidateLocationCode: Method used to validate the Branch
        /// </summary>
        /// <param name="Location"> DataType:String Required Location Code </param>
        /// <returns>Return boolean </returns>
        public Boolean ValidateLocationCode(string Location)
        {
            try
            {
                if (Location != "")
                {
                    if (WorkFormsData("ValidateLocationCode", Location).Rows.Count > 0) return true;
                }
            }
            catch (Exception ex)
            { }
            return false;
        }


    }
}
