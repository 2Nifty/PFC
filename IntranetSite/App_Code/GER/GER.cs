#region Namespace
using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
#endregion

/// <summary>
/// GoodsEnRoute (GER). This class handles data processing fuctions for GER Bill of Lading Entry screen
/// </summary>
namespace PFC.Intranet.BusinessLogicLayer
{
    public class GER
    {
        #region Developer generated Code
        public string POLineStat
        {
            get
            {
                return _POLineStat;
            }
            set
            {
                _POLineStat = value;
            }
        }
        public string CurPO
        {
            get
            {
                return _CurPO;
            }
            set
            {
                _CurPO = value;
            }
        }
        public string CurItem
        {
            get
            {
                return _CurItem;
            }
            set
            {
                _CurItem = value;
            }
        }
        private string _CurPO = string.Empty;
        private string _CurItem = string.Empty;
        private string _POLineStat = string.Empty;
        /// <summary>
        /// GetPOLine: Method used to get from PO lines matching item number
        /// </summary>
        /// <param name="strPO"> DataType:String Required PO number </param>
        /// <param name="strItem">DataType:String required Item number </param>
        /// <returns>Return retrived data as DataSet </returns>
        public DataSet GetPOLine(string strPO, string strItem)
        {
            //try
            //{
                DataSet dsGER = new DataSet();
                CurPO = strPO;
                CurItem = strItem;
                POLineStat = "";
                dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["NVConnectionString"].ToString(), "UGEN_SP_Select",
                    new SqlParameter("@tableName", "[Porteous$Purchase Line]"),
                    new SqlParameter("@columnNames", "[Document No_], [No_], [Line No_], [Location Code], [Unit of Measure Code],Description, [Unit of Measure], replace(convert(varchar,cast((cast(isnull([Outstanding Quantity],0) as bigint)) as money),1),'.00','') as [Outstanding Quantity], [Alt_ Price], [Alt_ Price UOM], [Net Weight],replace(cast(round([Quantity Received],0) as decimal(15,2)),'.00','') as [Quantity Received], [Alt_ Quantity]/[Quantity] as [Alt_ Quantity], [Pay-to Vendor No_]"),
                    new SqlParameter("@whereClause", "[Document No_]='" + strPO + "' and [No_] = '" + strItem + "' and [Outstanding Quantity] > 0"));
                if (dsGER.Tables[0].Rows.Count > 0)
                {
                    dsGER = SubtractGERDetail(dsGER);
                    dsGER = CheckForReservations(dsGER);
                }
                else
                {
                    POLineStat = "Line not found or completely received";
                }
              return dsGER;
            //}
            //catch (Exception ex) { return null; }
        }
        /// <summary>
        /// CheckForReservations: Verfiy that no are no ILE entries reserved against the PO Lines
        /// </summary>
        /// <returns>updated PO lines data as DataSet </returns>
        private DataSet CheckForReservations(DataSet dsPOLines)
        {
            //try
            //{
            DataTable dtGER = new DataTable();
            DataSet dsGERDet = new DataSet();
            DataRow POLine;
            dtGER = dsPOLines.Tables[0];
            for (int i = 0; i < dtGER.Rows.Count; i++)
            {
                POLine = dtGER.Rows[i];
                dsGERDet = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["NVConnectionString"].ToString(), "UGEN_SP_Select",
                    new SqlParameter("@tableName", " [Porteous$Reservation Entry]"),
                    new SqlParameter("@columnNames", "[Entry No_]"),
                    new SqlParameter("@whereClause", "([Source Type] = 39) and  ([Source ID] = '" + POLine["Document No_"].ToString() + "') and ([Source Ref_ No_] = '" + POLine["Line No_"].ToString() + "') "));
                if (dsGERDet.Tables[0].Rows.Count > 0)
                {
                    POLineStat = "PO Line Reserved, Please select a different PO number or have the reservation broken";
                    dtGER.Rows[i].Delete();
                }
            }
            dtGER.AcceptChanges();
            return dsPOLines;
            //}
            //catch (Exception ex) { return null; }
        }
        /// <summary>
        /// SubtractGERDetail: Method used to subtract qtys already consumed in other GERDetail records
        /// </summary>
        /// <returns>Return retrived GERHeader data as DataSet </returns>
        private DataSet SubtractGERDetail(DataSet dsPOLines)
        {
            //try
            //{
                DataTable dtGER = new DataTable();
                DataSet dsGERDet = new DataSet();
                DataRow POLine;
                int LineQty;
                string LineQtyString;
                int GERQty;
                dtGER = dsPOLines.Tables[0];
                for (int i = 0; i < dtGER.Rows.Count; i++)
                {
                    POLine = dtGER.Rows[i];
                    LineQty = 0;
                    LineQtyString = POLine["Outstanding Quantity"].ToString();
                    LineQty = System.Convert.ToInt32(LineQtyString.Replace(",",""));
                    GERQty = 0;
                    dsGERDet = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
                        new SqlParameter("@tableName", "GERDetail"),
                        new SqlParameter("@columnNames", "BOLNo, ContainerNo, RcptQty"),
                        new SqlParameter("@whereClause", "PFCPONo = '" + POLine["Document No_"].ToString() + "' and PFCPOLineNo = '" + POLine["Line No_"].ToString() + "' "));
                    if (dsGERDet.Tables[0].Rows.Count > 0)
                    {
                        for (int j = 0; j < dsGERDet.Tables[0].Rows.Count; j++)
                        {
                            GERQty += Convert.ToInt32(dsGERDet.Tables[0].Rows[j]["RcptQty"]);
                        }
                        if (GERQty >= LineQty)
                        {
                            POLineStat = "Line qty already entered";
                            dtGER.Rows[i].Delete();
                        }
                        else
                        {
                            POLine["Outstanding Quantity"] = Convert.ToString(LineQty - GERQty);
                        }
                    }

                }
                dtGER.AcceptChanges();
                return dsPOLines;
            //}
            //catch (Exception ex) { return null; }
        }
        /// <summary>
        /// GetBOLDetail: Method used to get BOL's Completed and InCompleted details from GERHeader
        /// </summary>
        /// <returns>Return retrived GERHeader data as DataSet </returns>
        public DataSet GetBOLDetailList(string whereCondition)
        {
            try
            {
                DataSet dsGERDetailList = new DataSet();

                dsGERDetailList = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
                    new SqlParameter("@tableName", "GERHeader"),
                    new SqlParameter("@columnNames", "pGERHdrID,BOLNo,VendNo,VendName,convert(char(11),cast(BOLDate as DateTime),101) as BOLDate,PFCLocCd,PFCLocName,PortOfLading,VesselName,RcptTypeDesc,convert(varchar,cast((cast(isnull(BrokerInvTot,0) as decimal(25,2))) as money),1) as BrokerInvTot,replace(convert(varchar,cast((cast(isnull(BrokerInvBOLCount,0) as bigint)) as money),1),'.00','') as BrokerInvBOLCount,convert(char(11),cast(ProcDt as DateTime),101) as ProcDt,StatusCd,CustomsEntryNo,convert(char(11),cast(CustomsEntryDt as DateTime),101) as CustomsEntryDt,CustomsPortOfEntry"),
                    new SqlParameter("@whereClause", whereCondition));
                return dsGERDetailList;
            }
            catch (Exception ex) { return null; }
        }

        /// <summary>
        /// GetBOLDetail: Method used to get BOL detail from GERDetail
        /// </summary>
        /// <param name="strPO"> DataType:String Required BOL number </param>
        /// <returns>Return retrived GERDetail data as DataSet </returns>
        public DataSet GetBOLDetail(string BOLNo)
        {
            try
            {
                DataSet dsGER = new DataSet();

                dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
                    new SqlParameter("@tableName", "GERDetail"),
                    new SqlParameter("@columnNames", "BOLNo,VendInvNo,convert(char(11),cast(VendInvDt as DateTime),101) as VendInvDt, ContainerNo, PFCPONo, PFCItemNo,replace(convert(varchar,cast((cast(isnull([POQty],0) as bigint)) as money),1),'.00','') as POQty, replace(convert(varchar,cast((cast(isnull([RcptQty],0) as bigint)) as money),1),'.00','') as [RcptQty],((convert(varchar,cast((cast(isnull(POCostPerAlt,0) as decimal(25,2))) as money),1)) +'/'+POAltUOM) as [POCost_UOM],UOPOPerAlt, ExtLandAdder, LandvsPOPct, PFCPOLineNo, convert(varchar,cast((cast(isnull(UOMatlAmt,0) as decimal(25,2))) as money),1) as UOMatlAmt "),
                    new SqlParameter("@whereClause", "BOLNo='" + BOLNo + "'"));
                return dsGER;
            }
            catch (Exception ex) { return null; }
        }

        public Boolean DupBOL(string BOLNo)
        {
            try
            {
                DataSet dsGER = new DataSet();

                dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
                    new SqlParameter("@tableName", "GERHeader"),
                    new SqlParameter("@columnNames", "BOLNo "),
                    new SqlParameter("@whereClause", "BOLNo='" + BOLNo + "'"));

                if (dsGER.Tables[0].Rows.Count > 0)
                    return true;
            }
            catch (Exception ex) { return false; }

            try
            {
                DataSet dsGER = new DataSet();

                dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
                    new SqlParameter("@tableName", "GERHeaderHist"),
                    new SqlParameter("@columnNames", "BOLNo "),
                    new SqlParameter("@whereClause", "BOLNo='" + BOLNo + "'"));

                if (dsGER.Tables[0].Rows.Count > 0)
                    return true;
            }
            catch (Exception ex) { }
            return false;
        }

        /// <summary>
        /// MarkPOLine :Returns the selected PO Line to the Command Line
        /// </summary>
        /// <param name="LineNumber">Line number choosen from radio button</param>
        /// <returns>Return retrived data as DataSet </returns>
        public DataSet MarkPOLine(string PONumber, string LineNumber, string ItemNumber)
        {
            try
            {
                DataSet dsGER = new DataSet();

                dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["NVConnectionString"].ToString(), "UGEN_SP_Select",
                    new SqlParameter("@tableName", "[Porteous$Purchase Line]"),
                    new SqlParameter("@columnNames", "[Document No_], [No_], [Line No_], [Location Code], Description, [Unit of Measure], replace(convert(varchar,cast((cast(isnull([Outstanding Quantity],0) as bigint)) as money),1),'.00','') as [Outstanding Quantity], [Alt_ Price], [Alt_ Price UOM], [Outstanding Net Weight]"),
                    new SqlParameter("@whereClause", "[Document No_]='" + PONumber + "' and [No_] = '" + ItemNumber + "' and [Line No_] = '" + LineNumber + "'"));
                if (dsGER.Tables[0].Rows.Count > 0)
                {
                    dsGER = SubtractGERDetail(dsGER);
                }
                return dsGER;
            }
            catch (Exception ex) { return null; }
        }
        /// <summary>
        /// OpenReconcile: groups detail by container
        /// </summary>
        /// <param name="BOLNo"> DataType:String Required BOL number </param>
        /// <returns>Return retrived data as DataSet </returns>
        public DataSet OpenReconcile(string BOLNo)
        {
            try
            {
                DataSet dsContainerTotals = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[pGERBolReconcile]",
                      new SqlParameter("@BolNo", BOLNo));

                return dsContainerTotals;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        /// <summary>
        /// CHARGES: calculate accessorial charges and returns values to Invoicing Grid
        /// </summary>
        /// <param name="strBOL">DataType:String Required BOL number</param>
        /// <returns>Return retrived data as DataSet </returns>
        public DataSet CHARGES(string strBOL)
        {
            try
            {
                DataSet dsCharges = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[pGERBolCharges]",
                      new SqlParameter("@BolNo", strBOL));

                return dsCharges;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        /// <summary>
        /// Process:Kicks off stored procedure that updates Processed Date (with Current date) and copies GER data to Historical table
        /// </summary>
        /// <param name="BOLNo">Bill of Lading Number</param>
        /// <returns>nothing </returns>
        public string PROCESS(string BOLNo, int ProcessInd)
        {
            try
            {
                string InvoiceCheck = CheckInvoiceNo(BOLNo);
                if (InvoiceCheck == "")
                {
                    int nada = SqlHelper.ExecuteNonQuery(Global.ReportsConnectionString, "[pGERBolProcess]",
                          new SqlParameter("@BolNo", BOLNo),
                          new SqlParameter("@ProcessInd", ProcessInd));
                }
                return InvoiceCheck;
            }
            catch (Exception ex)
            {
                return ex.Message;
            }
        }
        /// <summary>
        /// GER_WriteHdr: Write out header information to the GERHeader table
        /// </summary>
        /// <param name="BOLNo">Bill of Lading Number</param>
        /// <param name="BOLDate">Bill of Lading Date</param>
        /// <param name="VendNo">Materials Vendor Number</param>
        /// <param name="RcptTypeDesc">Receipt Type Description</param>
        /// <param name="VesselName">Vessel Name</param>
        /// <param name="PFCLocCd">Porteous Branch Number</param>
        /// <param name="PortofLading">Port of Lading</param>
        /// <param name="BrokerInvTot">total amount of invoice from broker</param>
        /// <param name="BrokerInvBOLCount">number of BOLs on invoice from broker</param>
        /// <param name="UsedID">current user id</param>
        /// <returns>Return retrived data as DataSet </returns>
        public DataSet GERWriteHdr(string BOLNo, string BOLDate, string VendNo, string VendName, string PayToVend, string RcptTypeDesc, string VesselName, string PFCLocCd, string PFClocName, string PortofLading, string BrokerInvTot, string BrokerInvBOLCount, string CustomsEntryNo, string CustomsPortofEntry,string CustomsDate, string UserID)
        {
            //try
            //{
                DataSet dsHdr = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[pGERBolWriteHdr]",
                      new SqlParameter("@BolNo", BOLNo),
                      new SqlParameter("@BOLDate", BOLDate),
                      new SqlParameter("@VendNo", VendNo),
                      new SqlParameter("@VendName", VendName),
                      new SqlParameter("@PayToVend", PayToVend),
                      new SqlParameter("@RcptTypeDesc", RcptTypeDesc),
                      new SqlParameter("@VesselName", VesselName),
                      new SqlParameter("@PFCLocCd", PFCLocCd),
                      new SqlParameter("@PFCLocName", PFClocName),
                      new SqlParameter("@PortofLading", PortofLading),
                      new SqlParameter("@BrokerInvTot", ((BrokerInvTot != "") ? BrokerInvTot : "0")),
                      new SqlParameter("@BrokerInvBOLCount", ((BrokerInvBOLCount != "") ? BrokerInvBOLCount : "0")),
                      new SqlParameter("@CustomsEntryNo", ((CustomsEntryNo != "") ? CustomsEntryNo : "0")),
                      new SqlParameter("@CustomsPortofEntry", CustomsPortofEntry ),
                      new SqlParameter("@CustomsDate", CustomsDate),
                      new SqlParameter("@UsedID", UserID));

                return dsHdr;
            //}
            //catch (Exception ex)
            //{
            //    return null;
            //}
        }

        /// <summary>
        /// GetBOLDetail: Method used to check the BOL detail exists or not from GERDetail
        /// </summary>
        /// <param name="strPO"> DataType:String Required BOL number </param>
        /// <returns>Return retrived GERDetail data as DataSet </returns>
        public DataSet CheckBOLDetail(string BOLNo, string VendInvNo, string VendInvDt, string ContainerNo, string PFCPONo, string PFCItemNo, string PFCPOLineNo)
        {
            try
            {
                DataSet dsGER = new DataSet();

                dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
                    new SqlParameter("@tableName", "GERDetail"),
                    new SqlParameter("@columnNames", "BOLNo,VendInvNo,convert(char(11),cast(VendInvDt as DateTime),101) as VendInvDt, ContainerNo, PFCPONo, PFCItemNo,replace(convert(varchar,cast((cast(isnull([POQty],0) as bigint)) as money),1),'.00','') as POQty, replace(convert(varchar,cast((cast(isnull([RcptQty],0) as bigint)) as money),1),'.00','') as [RcptQty],((convert(varchar,cast((cast(isnull(POCostPerAlt,0) as decimal(25,2))) as money),1)) +'/'+POAltUOM) as [POCost_UOM],UOPOPerAlt, ExtLandAdder, LandvsPOPct,PFCPOLineNo"),
                    new SqlParameter("@whereClause", "BOLNo='" + BOLNo + "' and VendInvNo='" + VendInvNo + "' and VendInvDt='" + VendInvDt + "' and ContainerNo='" + ContainerNo + "' and PFCPONo='" + PFCPONo + "' and PFCItemNo='" + PFCItemNo + "' and PFCPOLineNo='" + PFCPOLineNo + "'"));
                return dsGER;
            }
            catch (Exception ex) { return null; }
        }


        /// <summary>
        /// ksENTER: Saves current Command Line values to Grid and updated SQL table
        /// </summary>
        /// <param name="BOLNo">Bill of Lading Number</param>
        /// <param name="VendInvNo">Vendor Invoice Number</param>
        /// <param name="VendInvDt">Bill of Lading Date</param>
        /// <param name="ContainerNo">Container Number</param>
        /// <param name="PFCPONo">PFC Purchase Order Number</param>
        /// <param name="PFCItemNo">PFC Item Number</param>
        /// <param name="PFCPOLineNo">PFC Purchase Order Line Number</param>
        /// <param name="RcptQty">Receipt Quantity</param>
        /// <param name="POCostPerAlt">PFC Purchase Order Cost per Alternate</param>
        /// <param name="UOPOPerAlt">User Override to PO Price Per Alternate</param>
        /// <param name="PFCItemDesc">item decsription</param>
        /// <param name="PFCLocNo">Branch</param>
        /// <param name="BaseUOM">Item base unit of measure</param>
        /// <param name="PcsPerAlt">pcs in container</param>
        /// <param name="ItemNetWght">container weight</param>
        /// <param name="POAltUOM">Purchase Order Alternate Unit of Measure Description</param>
        /// <returns>Return retrived data as DataSet </returns>
        public DataSet ksENTER(string BOLNo, string VendInvNo, string VendInvDt, string ContainerNo, string PFCPONo, string PFCItemNo, string PFCPOLineNo, string POQty, string RcptQty, string POCostPerAlt, string POAltUOM, string UOPOPerAlt, string UserID, string PFCItemDesc, string PFCLocNo, string BaseUOM, string PcsPerAlt, string ItemNetWght)
        {
            DataSet dsLines = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[pGERksENTER]",
                  new SqlParameter("@BOLNo" , BOLNo), 
                  new SqlParameter("@VendInvNo" ,VendInvNo ), 
                  new SqlParameter("@VendInvDt" , VendInvDt), 
                  new SqlParameter("@ContainerNo" , ContainerNo), 
                  new SqlParameter("@PFCPONo" , PFCPONo), 
                  new SqlParameter("@PFCItemNo" , PFCItemNo), 
                  new SqlParameter("@PFCItemDesc" , PFCItemDesc), 
                  new SqlParameter("@PFCLocCd" , PFCLocNo), 
                  new SqlParameter("@BaseUOM" ,BaseUOM ), 
                  new SqlParameter("@PcsPerAlt" ,PcsPerAlt ),
                  new SqlParameter("@ItemNetWght" ,ItemNetWght ),
                  new SqlParameter("@PFCPOLineNo" , PFCPOLineNo), 
                  new SqlParameter("@POQty", POQty),
                  new SqlParameter("@RcptQty" , RcptQty), 
                  new SqlParameter("@POCostPerAlt" ,POCostPerAlt ),
                  new SqlParameter("@POAltUOM" ,POAltUOM ), 
                  new SqlParameter("@UOPOPerAlt" , UOPOPerAlt),
                  new SqlParameter("@UsedID", UserID));

            return dsLines;
        }
        #endregion

        /// <summary>
        /// Check if BOL number has already been used
        /// </summary>
        /// <returns>Empty string if OK, Other wise returns error message</returns>
        public string CheckBOLExists(string BOLNo)
        {
            // Check if Invoice number already used
            DataSet BOLCheck = new DataSet();
            string FoundMessage = "";
            string TableName = "GERHeader";
            string WhereCond = "BOLNo='" + BOLNo + "' and isnull(ProcDt,0)<>0";
            //string WhereCond = "BOLNo='" + BOLNo + "'";
            BOLCheck = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
                new SqlParameter("@tableName", TableName),
                new SqlParameter("@columnNames", "convert(char(11),cast(ProcDt as DateTime),101) as ProcDt"),
                new SqlParameter("@whereClause", WhereCond));
            if (BOLCheck.Tables[0].Rows.Count > 0)
            {
                DataRow HdrRow = BOLCheck.Tables[0].Rows[0];
                string Processed = HdrRow["ProcDt"].ToString();
                FoundMessage = "BOL #" + BOLNo + " has already been processed on " + Processed + ".";
            }
            else
            {
                TableName = "GERHeaderHist";
                BOLCheck = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
                    new SqlParameter("@tableName", TableName),
                    new SqlParameter("@columnNames", "convert(char(11),cast(ProcDt as DateTime),101) as ProcDt"),
                    new SqlParameter("@whereClause", WhereCond));
                if (BOLCheck.Tables[0].Rows.Count > 0)
                {
                    DataRow HdrRow = BOLCheck.Tables[0].Rows[0];
                    string Processed = HdrRow["ProcDt"].ToString();
                    FoundMessage = "BOL #" + BOLNo + " has already been processed on" + Processed + " and is in history.";
                }
            }
            return FoundMessage;
        }

        /// <summary>
        /// Check if Vendor Invoice number has already been posted to VLE
        /// </summary>
        /// <returns>Empty string if OK, Other wise returns error message</returns>
        public string CheckInvoiceNo(string BOLNo)
        {
            // Check if Invoice number already used
            DataSet VenInvCheck = new DataSet();
            DataSet dsGERHdr = new DataSet();
            DataSet dsGERDet = new DataSet();
            string FoundInvoices = "";
            string VendNo = "";
            string VendInvNo = "";

            dsGERHdr = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
                new SqlParameter("@tableName", "GERHeader"),
                new SqlParameter("@columnNames", "PayToVend"),
                new SqlParameter("@whereClause", "BOLNo='" + BOLNo + "'"));
            DataRow HdrRow = dsGERHdr.Tables[0].Rows[0];
            VendNo = HdrRow["PayToVend"].ToString();
            //FoundInvoices += "Vendor:" + VendNo;
            dsGERDet = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
                new SqlParameter("@tableName", "GERDetail"),
                new SqlParameter("@columnNames", "VendInvNo,ContainerNo, PFCPONo, PFCItemNo, PFCPOLineNo"),
                new SqlParameter("@whereClause", "BOLNo='" + BOLNo + "'"));
            //FoundInvoices += "Count:" + dsGERDet.Tables[0].Rows.Count;

            for (int rownum = 0; rownum < dsGERDet.Tables[0].Rows.Count; rownum++)
            {
                DataRow DetRow = dsGERDet.Tables[0].Rows[rownum];
                VendInvNo = DetRow["VendInvNo"].ToString();
                //FoundInvoices += "Invoice:" + VendInvNo;
                VenInvCheck = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["NVConnectionString"].ToString(), "UGEN_SP_Select",
                    new SqlParameter("@tableName", " [Porteous$Vendor Ledger Entry] with (NOLOCK)"),
                    new SqlParameter("@columnNames", "[Entry No_]"),
                    new SqlParameter("@whereClause", "[Document Type] = 2 and [External Document No_] = '" + VendInvNo + "' and [Vendor No_] = '" + VendNo + "'"));
                //FoundInvoices += "Count:" + VenInvCheck.Tables[0].Rows.Count;
                if (VenInvCheck.Tables[0].Rows.Count > 0)
                {
                    FoundInvoices = "Invoice #" + VendInvNo + " has already been processed – BOL cannot be processed with this invoice number";
                }
            }
            return FoundInvoices;
        }
        public string CheckInvoiceNo(string VendNo, string VendInvNo)
        {
            // Check if Invoice number already used
            DataSet VenInvCheck = new DataSet();
            string FoundInvoices = "";
            //FoundInvoices += "Invoice:" + VendInvNo;
            VenInvCheck = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["NVConnectionString"].ToString(), "UGEN_SP_Select",
                new SqlParameter("@tableName", " [Porteous$Vendor Ledger Entry] with (NOLOCK)"),
                new SqlParameter("@columnNames", "[Entry No_]"),
                new SqlParameter("@whereClause", "[Document Type] = 2 and [External Document No_] = '" + VendInvNo + "' and [Vendor No_] = '" + VendNo + "'"));
            //FoundInvoices += "Count:" + VenInvCheck.Tables[0].Rows.Count;
            if (VenInvCheck.Tables[0].Rows.Count > 0)
            {
                FoundInvoices = "Invoice #" + VendInvNo + " has already been processed – BOL cannot be processed with this invoice number";
            }
            return FoundInvoices;
        }

        /// <summary>
        /// Read WMS REC records  where the user Loc=WMS Loc and the  License plate has sum(Qty) ne 0 or Any Qty ne 0 line have reason code = NULL
        /// </summary>
        /// <returns>Returned Open Receipts (Select Distinct on LP#) dataset for user related branch</returns>
        public DataSet GetOpenRec(string Branch)
        {
            throw new System.NotImplementedException();
            /*
LPNo, BOLNo, TansactionDate, Weight, PctComplete, StatusCd
                        try
            {
                DataSet dsGER = new DataSet();

                dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["RBConnectionString"].ToString(), "UGEN_SP_Select",
                    new SqlParameter("@tableName", "[Porteous$Purchase Line]"),
                    new SqlParameter("@columnNames", "LPNo, BOLNo, TansactionDate, Weight, PctComplete, StatusCd"),
                    new SqlParameter("@whereClause", " Loc=WMS Loc and the License plate has sum(Qty)<>0 or 
Any Qty<>0 line have reason code = NULL" + strItem + "' and [Outstanding Quantity] > 0"));
                CurPO = strPO;
                CurItem = strItem;
                return dsGER;
            }
            catch (Exception ex) { return null; }
            */
        }

        /// <summary>
        /// Read the same dataset as in Open Receipts List but do not perform a select distinct
        /// </summary>
        public DataSet GetOpenRecDetail(string LPN)
        {
            throw new System.NotImplementedException();
        }

        /// <summary>
        /// WMS REC records where the user Loc=WMS Loc and License plate have sum(Qty)=0 or 
        /// All Qty ne 0 line have reason code NOT NULL
        /// </summary>
        public DataSet GetClosedRec(string Branch)
        {
            throw new System.NotImplementedException();
        }

        /// <summary>
        /// Read the same dataset as in Closed Receipts List but do not perform a select distinct
        /// </summary>
        public DataSet GetClosedRecDetail(string LPN)
        {
            throw new System.NotImplementedException();
        }

        /// <summary>
        /// Link: kicks off a function to read WMS REC records where all lines within a license plate with Qty ne 0 have Reason code Not Null
        /// </summary>
        public DataSet GetFinReview()
        {
            throw new System.NotImplementedException();
        }

        /// <summary>
        /// update Goods En Route Detail record with value and run a SQL update to WMS REC record with value
        /// </summary>
        public String RecReasonKsEnter(string GERInternalID)
        {
            throw new System.NotImplementedException();
        }

        /// <summary>
        /// Close lines that require fiancial review
        /// </summary>
        /// <remarks>User clicks radio button and then ksENTER key.  This will cause an update to the GERDetail table to set InvQty to zero, it will also update WMS LP Quantity for the record to zero</remarks>
        /// <returns>nothing</returns>
        public void RecCloseLine(string GERInternalID)
        {
            throw new System.NotImplementedException();
        }
        /// <summary>
        /// DEPRECIATED ksENTER: Saves current Command Line values to Grid and updated SQL table
        /// </summary>
        /// <param name="BOLNo">Bill of Lading Number</param>
        /// <param name="VendInvNo">Vendor Invoice Number</param>
        /// <param name="VendInvDt">Bill of Lading Date</param>
        /// <param name="ContainerNo">Container Number</param>
        /// <param name="PFCPONo">PFC Purchase Order Number</param>
        /// <param name="PFCItemNo">PFC Item Number</param>
        /// <param name="PFCPOLineNo">PFC Purchase Order Line Number</param>
        /// <param name="RcptQty">Receipt Quantity</param>
        /// <param name="POCostPerAlt">PFC Purchase Order Cost per Alternate</param>
        /// <param name="UOPOPerAlt">User Override to PO Price Per Alternate</param>
        /// <param name="POAltUOM">Purchase Order Alternate Unit of Measure Description</param>
        /// <returns>Return retrived data as DataSet </returns>
        public DataSet ksENTER(string BOLNo, string VendInvNo, string VendInvDt, string ContainerNo, string PFCPONo, string PFCItemNo, string PFCPOLineNo, string POQty, string RcptQty, string POCostPerAlt, string POAltUOM, string UOPOPerAlt, string UserID)
        {
            string InsertCommand;
            int qr;
            qr = 0;
            InsertCommand = "insert into GERDetail (";
            InsertCommand += "BOLNo, VendInvNo, VendInvDt, ContainerNo, PFCPONo, PFCItemNo, PFCPOLineNo, POQty, RcptQty, POCostPerAlt, POAltUOM, UOPOPerAlt, EntryID) values (";
            InsertCommand += "'" + BOLNo + "', ";
            InsertCommand += "'" + VendInvNo + "', ";
            InsertCommand += "'" + VendInvDt + "', ";
            InsertCommand += "'" + ContainerNo + "', ";
            InsertCommand += "'" + PFCPONo + "', ";
            InsertCommand += "'" + PFCItemNo + "', ";
            InsertCommand += PFCPOLineNo + ", ";
            InsertCommand += "'" + POQty + "', ";
            InsertCommand += RcptQty + ", ";
            InsertCommand += POCostPerAlt + ", ";
            InsertCommand += "'" + POAltUOM + "', ";
            InsertCommand += UOPOPerAlt + " , ";
            InsertCommand += "'" + UserID + "' ";
            InsertCommand += ")";

            try
            {
                SqlHelper.ExecuteNonQuery(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), CommandType.Text, InsertCommand);

                DataSet dsGER = new DataSet();
                dsGER = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
                    new SqlParameter("@tableName", "GERDetail"),
                    new SqlParameter("@columnNames", "BOLNo,VendInvNo, convert(char(11),cast(VendInvDt as DateTime),101) as VendInvDt, ContainerNo, PFCPONo, PFCItemNo,replace(convert(varchar,cast((cast(isnull([POQty],0) as bigint)) as money),1),'.00','') as POQty, replace(convert(varchar,cast((cast(isnull([RcptQty],0) as bigint)) as money),1),'.00','') as [RcptQty], ((convert(varchar,cast((cast(isnull(POCostPerAlt,0) as decimal(25,2))) as money),1)) +'/'+POAltUOM) as [POCost_UOM], UOPOPerAlt,ExtLandAdder,LandVsPOPct"),
                    new SqlParameter("@whereClause", "BOLNo='" + BOLNo + "'"));
                return dsGER;
            }
            catch (Exception ex) { return null; }
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
                object objSecurityCode = (object)SqlHelper.ExecuteScalar(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "UGEN_SP_Select",
                    new SqlParameter("@tableName", "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU"),
                    new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                    new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and (SU.DeleteDt is null or SU.DeleteDt = '') and (SM.DeleteDt is null or SM.DeleteDt = '') and (SG.DeleteDt is null or SG.DeleteDt = '') and SU.UserName='" + userName + "' AND (SG.groupname='GER (W)' OR  SG.groupname='GERADMIN (W)')"));

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
