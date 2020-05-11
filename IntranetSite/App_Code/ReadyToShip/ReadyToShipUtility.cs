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
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;

namespace PFC.Intranet.BusinessLogicLayer
{
    public class ReadyToShipUtility
    {
        string cnReports = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
        
        string colNameActionCommit = "A.pGERRTSDtlID as 'ID', A.LocCd as 'PFCLoc', A.Qty, A.Qty * A.GrossWght as 'Lbs', A.PONo as 'PO #', " +
                                     "A.PortOfLading as 'Leading Port', CONVERT(BIGINT,isnull(A.ActionQty,0)) as 'Action Qty', A.GERRTSStatCd as 'Status Code', " +
                                     "A.VendNo as 'Vendor', A.ItemNo, B.ShortCode as 'BrDesc', A.GrossWght, A.Hold ";

        string colNameActionBr = "Top 1 null as 'ID', A.LocCd as 'PFCLoc', '0' as 'Qty', '0' as 'Lbs', A.PONo as 'PO #', " +
                                 "A.PortOfLading as 'Leading Port', 0 as 'Action Qty', A.GERRTSStatCd as 'Status Code', A.VendNo as 'Vendor', " +
                                 "A.ItemNo,B.ShortCode as 'BrDesc', CONVERT(DECIMAL(25,2),A.GrossWght/A.Qty) as 'GrossWght' ";

        public ReadyToShipUtility()
        {

        }

        // Get the vendor po item details
        public DataSet GetVendorPODetails(string whereClause)
        {
            try
            {
                string tableName = "GERRTS A (NoLock), LocMaster B (NoLock)";
                string columnName = "A.VendNo as 'Vendor', A.PONo as 'PO#', A.Qty, A.GrossWght as 'Lbs', A.PortOfLading as 'Landing Port', A.QtyRemaining as 'Remaining Qty', " +
                                    "A.GERRTSStatCd as 'Sts Code', A.LocCd as 'PFC Destination', A.ItemNo, B.ShortCode as 'BrDesc', A.MfgPlant";
                whereClause = whereClause + " And A.LocCd=B.LocID And A.StatusCd = '00' and GERRTSStatCd <> 'OtherPO'";
                DataSet dsVendorDetails = GetDetails(tableName, columnName, whereClause);
                return dsVendorDetails;
            }
            catch (Exception ex) { return null; }
        }

        // Get the information about the item no selected
        public DataSet GetVendorItemDetails(string itemNumber)
        {
            try
            {
                string tableName = "CPRDailyRTS ";
                string columnName = "Top 1  Description, " +
                                    "       UOM, " +
                                    "       CONVERT(BIGINT,UOM_Qty) as [Qty Per], " +
                                    "       CONVERT(DECIMAL(25,2),ISNULL(GrossWeight,0)) as Lbs, " +
                                    "       CONVERT(VARCHAR,CONVERT(BIGINT,SupEqv_Qty)) + ' ' + CONVERT(VARCHAR,SupEqv_UOM) as [Super Equiv.], " +
                                    "       CONVERT(BIGINT,ISNULL(UOM_Qty,0)) * CONVERT(BIGINT,ISNULL(SupEqv_Qty,0)) as Pcs, " +
                                    "       CONVERT(DECIMAL(25,2),ISNULL(SupEqv_Qty,0) * ISNULL(GrossWeight,0)) as Tot_Lbs, " +
                                    "       CONVERT(DECIMAL(25,2),Wgt100) as [Wgt/100], " +
                                    "       PPI as HarmCode, " +
                                    "       CorpFixedVelCode as [Fixed Velocity], " +
                                    "       CONVERT(BIGINT,SupEqv_Qty) as SupEqvQty, " +
                                    "       LowPalletQty";
                string whereClause = "ItemNo='" + itemNumber + "' and UOM_Qty >= 0";
                DataSet dsItemDetails = SqlHelper.ExecuteDataset(cnReports, "UGEN_SP_Select",
                                                                 new SqlParameter("@tableName", tableName),
                                                                 new SqlParameter("@columnNames", columnName),
                                                                 new SqlParameter("@whereClause", whereClause));
                return dsItemDetails;
            }
            catch (Exception ex) { return null; }
        }

        // Method to fill vendor summary
        public DataSet GetVendorItemSummary(string itemNumber)
        {
            string tableName = "GERRTS (NoLock)";
            string columnValue = "*";
            string whereClause = "ItemNo='" + itemNumber + "' And StatusCd = '00'";

            try
            {
                DataSet dsDetails = SqlHelper.ExecuteDataset(cnReports, "UGEN_SP_Select",
                                                             new SqlParameter("@tableName", tableName),
                                                             new SqlParameter("@columnNames", columnValue),
                                                             new SqlParameter("@whereClause", whereClause));
                return dsDetails;
            }
            catch (Exception ex) { return null; }
        }

        // Method to fill the items in the ready to ship
        public DataSet GERReadyToShipItemDetails(string itemNo)
        {
            try
            {
                DataSet dsItemDetails = new DataSet();
                using (SqlConnection cn = new SqlConnection(cnReports))
                {
                    //                    string sqlItemDetails = "SELECT ItemNo," +
                    //                                            "       LocationCode," +
                    //                                            "       SVCode," +
                    //                                            "       CONVERT(DECIMAL(25,1),isnull(ROPHubCalc,0)) as 'ROPHubCalc'," +
                    //                                            "       CONVERT(BIGINT,AvailQty) as 'AvailQty'," +
                    //                                            "       CONVERT(BIGINT,InTransit) as InTransit," +
                    ////                                          "       CONVERT(BIGINT,Allocated) as 'Allocated'," +
                    ////                                          "       0 as 'Allocated'," +
                    //                                            "       CONVERT(BIGINT,Required) as 'Required'," +
                    //                                            "       CONVERT(BIGINT,RecommQty) as 'RecommQty', " +
                    //                                            "       isnull(CONVERT(BIGINT,CommitQty),0) as 'CommitQty'," +
                    //                                            "       LocIMRegion," +
                    //                                            "       CONVERT(BIGINT,RTSBQty) as 'RTSBQty', " +
                    //                                            "       CONVERT(DECIMAL(25,1),isnull(SupEqQty,0)) as SupEqQty, " +
                    //                                            "       CONVERT(DECIMAL(25,0),isnull(Avail_Mos,0)) as Avail_Mos," +
                    //                                            "       ROPDays " +
                    //                                            "FROM   vRTS_Details (NoLock) " +
                    //                                            "WHERE  ItemNo = '" + itemNo + "' AND SVCode <> 'N' " +
                    //                                            "ORDER BY HubSort asc";

                    string sqlItemDetails = "SELECT	vRTS.ItemNo, " +
                                            "		vRTS.LocationCode, " +
                                            "		vRTS.SVCode, " +
                                            "		CONVERT(DECIMAL(25,1),isnull(vRTS.ROPHubCalc,0)) as 'ROPHubCalc', " +
                                            "		CONVERT(BIGINT,vRTS.AvailQty) as 'AvailQty', " +
                                            "		CONVERT(BIGINT,vRTS.InTransit) as InTransit, " +
                                            "		isnull(tROPFct.ROPFactor,0) as ROPFactor, " +
                                            "		CONVERT(DECIMAL(25,1),(isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor)) as 'FactoredROP', " +
                        //                                          "		(CONVERT(DECIMAL(25,1),(isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor))) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit)) as 'Allocated', " +
                        //                                          "       CONVERT(BIGINT,ROUND(((isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit))),0)) as 'Allocated', " +
                                            "       CASE WHEN CONVERT(BIGINT,ROUND(((isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit))),0)) = 0 AND " +
                                            "                 (isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit)) < 0 " +
                                            "                   THEN -1 " +
                                            "            WHEN CONVERT(BIGINT,ROUND(((isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit))),0)) = 0 AND " +
                                            "                 (isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - (CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit)) > 0 " +
                                            "                   THEN 1 " +
                                            "            ELSE CONVERT(BIGINT,ROUND(((isnull(vRTS.ROPHubCalc,0)*tROPFct.ROPFactor) - CONVERT(BIGINT,vRTS.AvailQty) - CONVERT(BIGINT,vRTS.RTSBQty) - CONVERT(BIGINT,vRTS.InTransit)),0)) " +
                                            "       END AS 'Allocated', " +
                                            "		CONVERT(BIGINT,vRTS.Required) as 'Required', " +
                                            "		CONVERT(BIGINT,vRTS.RecommQty) as 'RecommQty', " +
                                            "		isnull(CONVERT(BIGINT,vRTS.CommitQty),0) as 'CommitQty', " +
                                            "       isnull(tROPFct.OrigRemain,0) as 'OrigRemain', " +
                                            "		vRTS.LocIMRegion, " +
                                            "		CONVERT(BIGINT,vRTS.RTSBQty) as 'RTSBQty', " +
                                            "		CONVERT(DECIMAL(25,1),isnull(vRTS.SupEqQty,0)) as SupEqQty, " +
                                            "		CONVERT(DECIMAL(25,0),isnull(vRTS.Avail_Mos,0)) as Avail_Mos, " +
                                            "		vRTS.ROPDays " +
                                            "FROM	vRTS_Details vRTS (NoLock) INNER JOIN " +
                                            "		(SELECT	isnull(tItemSum.ItemNo,tPOSum.ItemNo) AS ItemNo, " +
                                            "			CASE isnull(TotROP,0) " +
                                            "			     WHEN 0 THEN 0 " +
                                            "				    ELSE ROUND(((isnull(TotAvl,0) + isnull(TotRTSB,0) + isnull(TotOW,0) + isnull(TotRemain,0) + isnull(TotComm,0)) / isnull(TotROP,0)),3) " +
                                            "			END AS ROPFactor, " +
                                            "           isnull(TotRemain,0) + isnull(TotComm,0) as OrigRemain " +
                                            "		 FROM	(SELECT	ItemNo, " +
                                            "				SUM(CONVERT(DECIMAL(25,1),isnull(ROPHubCalc,0))) AS TotROP, " +
                                            "				SUM(CONVERT(BIGINT,AvailQty)) AS TotAvl, " +
                                            "				SUM(CONVERT(BIGINT,RTSBQty)) AS TotRTSB, " +
                                            "				SUM(CONVERT(BIGINT,InTransit)) AS TotOW, " +
                                            "				SUM(CONVERT(BIGINT,CommitQty)) AS TotComm " +
                                            "			 FROM   vRTS_Details (NoLock) " +
                                            "			 WHERE  SVCode <> 'N' " +
                                            "				AND ItemNo = '" + itemNo + "' " +
                                            "			 GROUP BY ItemNo) tItemSum FULL OUTER JOIN " +
                                            "			(SELECT	GER.ItemNo, " +
                                            "				SUM(GER.QtyRemaining) as TotRemain " +
                                            "			 FROM	GERRTS GER (NoLock), LocMaster Loc (NoLock) " +
                                            "			 WHERE	GER.LocCd = Loc.LocID And GER.StatusCd = '00' and GERRTSStatCd <> 'OtherPO' " +
                                            "					AND GER.ItemNo = '" + itemNo + "' " +
                                            "			 GROUP BY GER.ItemNo) tPOSum " +
                                            "		 ON	tItemSum.ItemNo = tPOSum.ItemNo) tROPFct " +
                                            "ON     vRTS.ItemNo = tROPFct.ItemNo " +
                                            "WHERE  vRTS.ItemNo = '" + itemNo + "' AND SVCode <> 'N' " +
                                            "ORDER BY vRTS.HubSort asc";

                    cn.Open();
                    SqlDataAdapter adp;
                    SqlCommand cmd = new SqlCommand(sqlItemDetails, cn);
                    cmd.CommandTimeout = 0;
                    adp = new SqlDataAdapter(cmd);
                    adp.Fill(dsItemDetails);
                }
                return dsItemDetails;
            }
            catch (Exception ex) { return null; }
        }

        // Method to fill the items in the ready to ship
        public decimal GERReadyToShipHoldQuantity(string itemNo)
        {
            try
            {
                object holdedQty = SqlHelper.ExecuteScalar(cnReports, "UGEN_SP_Select",
                                                           new SqlParameter("@tableName", "GERRTSdtl (NoLock)"),
                                                           new SqlParameter("@columnNames", "sum(ActionQty)"),
                                                           new SqlParameter("@whereClause", "ItemNo = '" + itemNo + "' and LocCd = '90'"));
                 return System.Math.Round((decimal)holdedQty,0);
            }
            catch (Exception ex) { return 0; }
        }

        // Get UnUsed Qty vale to display in grid footer
        public string GetNonPPQuantity(string itemNumber)
        {
            try
            {
                string unUsedQty = SqlHelper.ExecuteScalar(cnReports, "UGEN_SP_Select",
                                                           new SqlParameter("@tableName", "GERRTS (NoLock)"),
                                                           new SqlParameter("@columnNames", "isnull(sum(qty),0)"),
                                                           new SqlParameter("@whereClause", "GERRTSstatCd <> 'PP' and StatusCd = '00' and ItemNo = '" + itemNumber + "'")).ToString();
                return unUsedQty;
            }
            catch (Exception ex) { return ""; }
        }

        // Get the details for the action qty
        public DataSet GetRTSActionQty(string whereClause, string mode)
        {
            try
            {
                string tableName = ((mode.Trim() != "Commit") ? "GERRTS " : "GERRTSDtl ") + "A,LocMaster B";
                string columnName = ((mode.Trim() != "Commit") ? colNameActionBr+",(SELECT Top 1 Hold FROM GERRTSDTL WHERE "+whereClause +" and Hold<>'') as Hold" : colNameActionCommit);
                DataSet dsRTSActionDtls = GetDetails(tableName, columnName, whereClause + " and A.LocCd = B.LocID");
                return dsRTSActionDtls;
            }
            catch (Exception ex) { throw (ex); }
        }

        // Get the details for the action qty (HOLD Branch)
        public DataSet GetRTSActionQtyHold(string whereClause, string mode)
        {
            try
            {
                string colNameCommit = "A.pGERRTSDtlID as 'ID', A.LocCd as 'PFCLoc', A.Qty, A.Qty * A.GrossWght as 'Lbs', " +
                                       "A.PONo as 'PO #', A.PortOfLading as 'Leading Port', CONVERT(BIGINT,isnull(A.ActionQty,0)) as 'Action Qty', " +
                                       "A.GERRTSStatCd as 'Status Code', A.VendNo as 'Vendor', A.ItemNo, 'HOLD' as 'BrDesc', A.GrossWght, A.Hold ";

               string colNameAction = "Top 1 null as 'ID', A.LocCd as 'PFCLoc', '0' as 'Qty', '0' as 'Lbs', " +
                                      "A.PONo as 'PO #', A.PortOfLading as 'Leading Port', 0 as 'Action Qty', " +
                                      "A.GERRTSStatCd as 'Status Code', A.VendNo as 'Vendor', A.ItemNo, " +
                                      "CONVERT(DECIMAL(25,2),A.GrossWght/A.Qty) as 'GrossWght' ";

                string tableName = ((mode.Trim() != "Commit") ? "GERRTS " : "GERRTSDtl ") + "A";
                string columnName = ((mode.Trim() != "Commit") ? colNameAction + ",(SELECT Top 1 Hold FROM GERRTSDTL WHERE " + whereClause + " and Hold <> '') as Hold, 'HOLD' as BrDesc" : colNameCommit);
                DataSet dsRTSActionDtls = GetDetails(tableName, columnName, whereClause );
                return dsRTSActionDtls;
            }
            catch (Exception ex) { return null; }
        }

        // Get the table values from the database
        public DataSet GetDetails(string tableName, string columnName, string whereClause)
        {
            try
            {
                DataSet dsDetails = SqlHelper.ExecuteDataset(cnReports, "UGEN_SP_Select",
                                                             new SqlParameter("@tableName", tableName),
                                                             new SqlParameter("@columnNames", columnName),
                                                             new SqlParameter("@whereClause", whereClause));
                return dsDetails;
            }
            catch (Exception ex) { return null; }
        }

        public bool CommitRTS(string ItemNo)
        {
            try
            {
                DataSet dsPO = GetDetails("GERRTS A (NoLock), GERRTSHDR B (NoLock)", "COUNT(PONo) as PoCnt", "A.ItemNo = '" + ItemNo + "' and B.ItemNo = '" + ItemNo + "' and A.LocCd = B.LocCd and A.QtyRemaining < B.RecommQty and A.StatusCd = '00'");
                string tableName = "GERRTSDTL (NoLock)";
                string colName = "ItemNo, LocCd, Qty, GrossWght, GERRTSStatCd, VendNo, PONo, PortofLading, ActionQty, EntryID, EntryDt, ChangeID, ChangeDt";
                if (dsPO != null && dsPO.Tables[0].Rows.Count > 0)
                {
                    int countPO = Convert.ToInt32(dsPO.Tables[0].Rows[0][0].ToString().Trim());
                    if (countPO == 0)
                    {
                        UpdateQuantity("GERRTSHdr", "CommitQty = RecommQty", "ItemNo = '" + ItemNo + "'");
                        string columnValue = "GERRTS.QtyRemaining = QtyRemaining - (SELECT GERRTSHdr.CommitQty FROM GERRTSHdr " +
                                             "WHERE GERRTSHdr.LocCd = GERRTS.LocCd and GERRTSHdr.ItemNo = GERRTS.ItemNo)";
                        string whereClause = "EXISTS (SELECT GERRTSHdr.LocCd, GERRTSHdr.ItemNo FROM GERRTSHdr " +
                                             "WHERE GERRTSHdr.LocCd = GERRTS.LocCd and GERRTSHdr.ItemNo = GERRTS.ItemNo) and " +
                                             "PONo in (SELECT PONo GERRTS where ItemNo = '" + ItemNo.Trim() + "')";
                        UpdateQuantity("GERRTS", columnValue, whereClause);

                        #region Code to insert value in the details table
                        DataSet dsPoDtl = GetDetails("GERRTS A, GERRTSHDR B",
                                                     "A.ItemNo, A.LocCd, CONVERT(BIGINT,B.RecommQty) as 'Qty', A.GrossWght, A.GERRTSStatCd, A.VendNo, A.PONo, A.PortofLading, CONVERT(BIGINT,B.RecommQty) as 'ActionQty'",
                                                     "A.ItemNo = '" + ItemNo + "' and B.ItemNo = '" + ItemNo + "' and A.LocCd = B.LocCd and A.QtyRemaining >= B.RecommQty");

                        foreach (DataRow drow in dsPoDtl.Tables[0].Rows)
                        {
                            string colValue = "'" + drow["ItemNo"].ToString().Trim() + "','" + drow["LocCd"].ToString().Trim() + "'," +
                                              "'" + drow["Qty"].ToString().Trim() + "','" + drow["GrossWght"].ToString().Trim() + "'," +
                                              "'" + drow["GERRTSStatCd"].ToString().Trim() + "','" + drow["VendNo"].ToString().Trim() + "'," +
                                              "'" + drow["PONo"].ToString().Trim() + "','" + drow["PortofLading"].ToString().Trim() + "'," +
                                              "'" + drow["ActionQty"].ToString().Trim() + "','" + HttpContext.Current.Session["UserID"].ToString().Trim() + "'," +
                                              "'" + DateTime.Now.ToString() + "','" + HttpContext.Current.Session["UserID"].ToString().Trim() + "'," +
                                              "'" + DateTime.Now.ToString() + "'";

                            // Insert value in the detail po line
                            InsertActionQty(tableName, colName, colValue);
                        }
                        #endregion

                        return true;
                    }
                    else
                        return false;
                }
                else
                    return false;
            }
            catch (Exception ex) { return false; }
        }

        public void UpdateQuantity(string tableName, string columnValue, string where)
        {
            try
            {
                //string insertQuery = "Update " + tableName.Trim() + " Set  " + columnValue + " where " + where;
                //SqlHelper.ExecuteNonQuery(cnReports, CommandType.Text, insertQuery);

                SqlHelper.ExecuteNonQuery(cnReports, "UGEN_SP_Update",
                                          new SqlParameter("@tableName", tableName.Trim()),
                                          new SqlParameter("@columnNames", columnValue),
                                          new SqlParameter("@whereClause", where));
            }
            catch (Exception ex) { }
        }

        public object InsertActionQty(string tableName, string ColumnName, string ColumnValue)
        {
            try
            {
                //string insertQuery = "Insert into " + tableName.Trim() + "(" + ColumnName + ") values(" + ColumnValue + ")";
                //SqlHelper.ExecuteNonQuery(cnReports, CommandType.Text, insertQuery);

                object objID=  SqlHelper.ExecuteScalar(cnReports, "UGEN_SP_INSERT",
                                                       new SqlParameter("@tableName", tableName),
                                                       new SqlParameter("@columnNames", ColumnName),
                                                       new SqlParameter("@columnValues", ColumnValue));
                return objID;
            }
            catch (Exception ex) { return null; }
        }

        public string GetVendorDescription(string vendorCode)
        {
            try
            {
                string vendorDescription = (string)SqlHelper.ExecuteScalar(cnReports, "UGEN_SP_Select",
                                                                           new SqlParameter("@tableName", "VendorMaster (NoLock)"),
                                                                           new SqlParameter("@columnNames", "TOP 1 VendName"),
                                                                           new SqlParameter("@whereClause", "VendCd = '" + vendorCode + "'"));
                return vendorDescription;
            }
            catch (Exception ex) { return ""; }
        }

        public object GetScalar(string tableName, string columnValue, string where)
        {
            try
            {
                object scalarValue = (object)SqlHelper.ExecuteScalar(cnReports, "UGEN_SP_Select",
                                                                     new SqlParameter("@tableName", tableName),
                                                                     new SqlParameter("@columnNames", columnValue),
                                                                     new SqlParameter("@whereClause", where));
                return scalarValue;
            }
            catch (Exception ex) { return ""; }
        }

        public void UpdateSummaryDetail(string vendor, string portofLading)
        {
            try
            {
                string pallenCnt = "";
                string qtyRemaining = "";

                string query = "DELETE GERRTSAdvice WHERE VendNo = '" + vendor + "' and PortofLading='" + portofLading + "'";
                SqlHelper.ExecuteNonQuery(cnReports, CommandType.Text, query);

                query = "INSERT INTO GERRTSAdvice (VendNo, PONo, ItemNo, GERRTSStatCd, Qty, GrossWght, PortofLading, LocCd, EntryID, EntryDt, ChangeID, ChangeDt, StatusCd, MfgPlant) " +
                        "                   SELECT VendNo, PONo, ItemNo, GERRTSStatCd, Qty, GrossWght, PortofLading, LocCd, EntryID, EntryDt, ChangeID, ChangeDt, StatusCd, MfgPlant " +
                        "                   FROM   GERRTSDtl WHERE VendNo = '" + vendor + "' and PortofLading = '" + portofLading + "'";
                SqlHelper.ExecuteNonQuery(cnReports, CommandType.Text, query);

                DataSet dsDetails = SqlHelper.ExecuteDataset(cnReports, "UGEN_SP_Select",
                                                             new SqlParameter("@tableName", "GERRTSAdvice (NoLock)"),
                                                             new SqlParameter("@columnNames", "VendNo, PONo, ItemNo, PortofLading, LocCd"),
                                                             new SqlParameter("@whereClause", "VendNo = '" + vendor + "' and PortofLading = '" + portofLading + "'"));

                if (dsDetails != null)
                {
                    for (int count = 0; count < dsDetails.Tables[0].Rows.Count; count++)
                    {
                        DataSet dsValue = SqlHelper.ExecuteDataset(cnReports, "UGEN_SP_Select",
                                                                   new SqlParameter("@tableName", "GERRTS (NoLock)"),
                                                                   new SqlParameter("@columnNames", "PalletCnt, QtyRemaining"),
                                                                   new SqlParameter("@whereClause", "PONo='" + dsDetails.Tables[0].Rows[count]["PONo"].ToString() + "' and Itemno='" + dsDetails.Tables[0].Rows[count]["ItemNo"].ToString() + "'"));

                        object scalarValue = (object)SqlHelper.ExecuteScalar(cnReports, "UGEN_SP_Select",
                                                                             new SqlParameter("@tableName", "GERRTShdr (NoLock)"),
                                                                             new SqlParameter("@columnNames", "RecommQty"),
                                                                             new SqlParameter("@whereClause", "ItemNo = '" + dsDetails.Tables[0].Rows[count]["ItemNo"].ToString() + "' and LocCd = '" + dsDetails.Tables[0].Rows[count]["LocCd"].ToString() + "'"));

                        if (dsValue != null && dsValue.Tables[0].Rows.Count > 0)
                        {
                            pallenCnt = dsValue.Tables[0].Rows[0]["Palletcnt"].ToString();
                            qtyRemaining = dsValue.Tables[0].Rows[0]["qtyremaining"].ToString();
                        }
                        else
                        {
                            pallenCnt = "0";
                            qtyRemaining = "0";
                        }

                        query = "UPDATE GERRTSAdvice SET PalletCnt = '" + pallenCnt + "',QtyRemaining = '" + qtyRemaining + "' " +
                                "WHERE ItemNo = '" + dsDetails.Tables[0].Rows[count]["ItemNo"].ToString() + "' and LocCd = '" + dsDetails.Tables[0].Rows[count]["LocCd"].ToString() + "'";
                        SqlHelper.ExecuteNonQuery(cnReports, CommandType.Text, query);

                        string adviceqty = (scalarValue == null) ? "0" : scalarValue.ToString();
                        query = "UPDATE GERRTSAdvice SET AdviceQty = " + adviceqty + " " +
                                "WHERE ItemNo = '" + dsDetails.Tables[0].Rows[count]["ItemNo"].ToString() + "' and LocCd = '" + dsDetails.Tables[0].Rows[count]["LocCd"].ToString() + "'";
                        SqlHelper.ExecuteNonQuery(cnReports, CommandType.Text, query);
                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public string GetBranchDesc(string branchCode)
        {
            try
            {
                string tableName = "LocMaster (NoLock)";
                string columnName = "ShortCode";
                string whereClause = "LocID = '" + branchCode.Trim() + "'";
                DataSet dsBranch = GetDetails(tableName, columnName, whereClause);

                if (dsBranch != null && dsBranch.Tables[0].Rows.Count > 0)
                    return dsBranch.Tables[0].Rows[0][0].ToString().Trim();
                else
                    return string.Empty;
            }
            catch (Exception ex) { return string.Empty; }
        }

        public DataSet GetReviewUnprocessed(string vendor, string portLading)
        {
            try
            {
                //string tableName = "GERRTSDtl (NoLock)";
                //string colName = "PONo,ItemNo,Qty,Qty*GrossWght as 'GrossWght',GERRTSStatCd";
                //string whereClause = "VendNo='" + vendor + "' AND PortOfLading='" + portLading + "' AND PONO in(Select PONo From GERRTS Where QtyRemaining>0)";
                string tableName = "GERRTS (NoLock)";
                string colName = "PONo, ItemNo, MAX(QtyRemaining) as Qty, CONVERT(BIGINT,SUM((GrossWght/Qty)*(QtyRemaining))) as GrossWght, GERRTSStatCd";
                string whereClause = "VendNo = '" + vendor + "' and PortofLading='" + portLading + "' and QtyRemaining > 0 GROUP BY ItemNo, VendNo, PortofLading, PONo, GERRTSStatCd";
                DataSet dsReview = GetDetails(tableName, colName, whereClause);
                return ((dsReview != null && dsReview.Tables[0].Rows.Count > 0) ? dsReview : null);
            }
            catch (Exception ex) { return null; }
        }

        public string PoundNotProcessed(string vendor, string portLading)
        {
            try
            {
                // Modified by Slater : 07/11/08 : WO 594
                //string tableName = "GERRTSDtl (NoLock)";
                //string colName = "convert(bigint,Sum(ActionQty*GrossWght))";
                //string whereClause = "VendNo='" + vendor + "' AND PortOfLading='" + portLading + "' AND PONO in(Select PONo From GERRTS Where QtyRemaining>0)";
                // Modified by Sathya : 12/04/08  
                //string tableName = "GERRTS (NoLock)";
                //string colName = "convert(bigint,sum((GrossWght*(QtyRemaining/Qty))))";
                //string whereClause = "VendNo='" + vendor + "' AND PortOfLading='" + portLading + "' AND Qty>0";
                string tableName = "GERRTS (NoLock)";
                string colName = "CONVERT(BIGINT,SUM((GrossWght/Qty)*(QtyRemaining)))";
                string whereClause = "VendNo = '" + vendor + "' and PortofLading = '" + portLading + "' and Qty > 0 and QtyRemaining > 0 and StatusCd = '00'";
                DataSet dsReview = GetDetails(tableName, colName, whereClause);
                return ((dsReview != null && dsReview.Tables[0].Rows.Count > 0) ? dsReview.Tables[0].Rows[0][0].ToString().Trim() : "");
            }
            catch (Exception ex) { return ""; }
        }
    }
}