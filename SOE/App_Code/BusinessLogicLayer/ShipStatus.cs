using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.Sql;
using System.Data.SqlClient;
using PFC.SOE.DataAccessLayer;

namespace PFC.SOE.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for ShippingStatus
    /// </summary>
    public class ShipStatus
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        string tableName = "";
        string columnName = "";
        string whereClause = "";
        string SrcTableInfo = "";

        /// <summary>
        /// Check for Shipment date
        /// </summary>
        /// <param name="whereClause"></param>
        /// <returns></returns>
        public string ValidateSoNumber(string whereClause,string tableName)
        {
            //columnName = "case when DocumentSrcTable='soheader' then 'ORDER' when DocumentSrcTable='soheaderRel' then 'REL' when DocumentSrcTable='soheaderHist' then 'Hist' end as 'Source'";
            columnName = "schshipdt";
            whereClause += " And schshipdt is not null";
            string orderType = null;

            try
            {
                DataSet dsValue = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                  new SqlParameter("@tableName", tableName),
                                  new SqlParameter("@columnName", columnName),
                                  new SqlParameter("@whereClause", whereClause));

                if (dsValue != null)
                {
                    switch (tableName.ToLower().Trim())
                    {
                        case "soheader":
                            orderType = "ORDER";
                            break;
                        case "soheaderrel":
                            orderType = "REL";
                            break;
                        case "soheaderhist":
                            orderType = "Hist";
                            break;
                    }
                    return orderType;
                }
                else
                    return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }


        public DataTable GetShipHeaderDetails(string soNumber, string type)
        {
            //tableName = "SoHeader a ,CustomerMaster b," +srcTable.Trim();
            //columnName = "OrderNo,InvoiceNo,OrderCarrier,OrderCarName, HoldReasonName,VerifyType,OrderReprints,"+
            //              "convert(char(10),VerifyDt,101) as VerifyDt,convert(char(10),PrintDt,101) as PrintDt,"+
            //              "OrderType,convert(char(10),OrderDt,101) as OrderDt,ShipLoc,"+
            //              "convert(char(10),HoldDt,101)as HoldDt,convert(char(10),AckPrintedDt,101)as AckPrintedDt," +
            //              "convert(char(10),AllocDt,101)as AllocDt,convert(char(10),PickDt,101)as PickDt," +
            //              "convert(char(10),PickCompDt,101)as PickCompDt,convert(char(10),ConfirmShipDt,101)as ConfirmShipDt," +
            //              "convert(char(10),ShippedDt,101)as ShippedDt,convert(char(10),InvoiceDt,101)as InvoiceDt," +
            //              "convert(char(10),ARPostDt,101)as ARPostDt,ShipInstrCd, ShipInstrCdName,SellToCustNo,SellToCustName," +
            //              "SellToAddress1,SellToCity,SellToState,SellToZip,SellToCountry,SellToContactPhoneNo,ShipToName," +
            //              "ShipToAddress1,City,State,Zip,Country,PhoneNo ,b.MinBillAmt as Amount,a.BolNo as BolNo";

            //whereClause = " b.CustNo=SellToCustNo  and OrderNo='"+ SoNumber + "'";

            try
            {

                DataSet dsHeaderInfo = SqlHelper.ExecuteDataset(ERPConnectionString, "[pSOEShipmentStatus]",
                                      new SqlParameter("@SoNumber", soNumber),
                                      new SqlParameter("@Type", type));
                                     

                //if (dsHeaderInfo.Tables[0] != null && dsHeaderInfo.Tables[0].Rows.Count > 0)
                
                    return dsHeaderInfo.Tables[0];
              

            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataTable GetGridControl(string soNumber)
        {
            tableName = "ASNControl";
            columnName = " Substring(TrackingNo,11,9) as CartonNo,[PackageType],[EDIStatus],[pASNControlID]";
            whereClause = "fSOHeaderID='" + soNumber + "'";
            try
            {
                DataSet dsGridControl = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                        new SqlParameter("@tableName", tableName),
                                        new SqlParameter("@columnName", columnName),
                                        new SqlParameter("@whereClause", whereClause));

                return dsGridControl.Tables[0];
            }
            catch (Exception ex)
            {
                return null;

            }

        }

        public DataTable GetGridDetail(string controlID)
        {
            tableName = "ASNDetail AS ad INNER JOIN " +
                        "ItemMaster AS im ON ad.ItemNo = im.ItemNo INNER JOIN " +
                        "ASNControl AS ASNHeader ON ad.fASNControlID = ASNHeader.pASNControlID " ;
            columnName = " ad.QtyPickedInUnits as TotalQty,ad.ItemNo,CONVERT(decimal(10,2),isnull(ad.TotalWeight,0)) as TotalWeight,ad.SellUM,im.ItemDesc,ASNHeader.TrackingNo,ASNHeader.Carrier";
            whereClause = "ad.ItemNo=im.ItemNo and fASNControlID='"+ controlID + "'";
            try
            {
                DataSet dsGridDetail = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                        new SqlParameter("@tableName", tableName),
                                        new SqlParameter("@columnName", columnName),
                                        new SqlParameter("@whereClause", whereClause));

                return dsGridDetail.Tables[0];
            }
            catch (Exception ex)
            {
                return null;

            }
        }

        public string GetTotQuantity(string SoNumber)
        {
            try
            {
                string totQty = SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                    new SqlParameter("@tableName", "ASNControl"),
                    new SqlParameter("@columnNames", "Count(TotalQty)"),
                    new SqlParameter("@whereClause", " OrderNo='" + SoNumber + "'")).ToString();
                return totQty;
            }
            catch (Exception ex) { return ""; }
        }
    } 
}
