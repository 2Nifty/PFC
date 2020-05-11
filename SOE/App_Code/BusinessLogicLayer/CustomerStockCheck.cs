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
using PFC.SOE.DataAccessLayer;

namespace PFC.SOE.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for CustomerStockCheck
    /// </summary>
    public class CustomerStockCheck
    {

        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        string tableName = "";
        string columnName = "";
        string whereClause = "";

        public DataTable GetLocationName()
        {
            try
            {

                DataSet dsLoc = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                              new SqlParameter("@tableName", "LocMaster"),
                              new SqlParameter("@columnNames", " Rtrim(LOCID) as Code,LOCID + '-' + [LocName] as Name"),
                              new SqlParameter("@whereClause", " LocName <> ''"));

                return dsLoc.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public DataTable GetStock(string itemNo, string location)
        {
            try
            {
                DataSet dsStock= SqlHelper.ExecuteDataset(ERPConnectionString, "[pSOECustStockCheck]",
                                new SqlParameter("@ItemNo", itemNo),
                                new SqlParameter("@Loc", location));
                return dsStock.Tables[0];

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetLocationGrid(string itemNo)
        {
            try
            {
                DataSet dsLoc = SqlHelper.ExecuteDataset(ERPConnectionString, "[pCustLocation]",
                               new SqlParameter("@ItemNo", itemNo));

                return dsLoc.Tables[0];


            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetStockGrid(string whereClause)
        {
            tableName = "ItemBranchUsage";
            columnName = "Location,cast(isnull(sum(CurEndOHQty),0)as decimal(25,2))as [On Hand],"+
                         "cast(isnull(sum(CurSalesQty),0)as decimal(25,2))as [Allocated],"+
                         "cast(isnull(sum(CurBackOrderQty),0)as decimal(25,2))as [Back Order],"+
                         "cast(isnull(sum(CurAdjustQty),0)as decimal(25,2))as [Available],"+
                         "cast(isnull(sum(CurPOQty),0)as decimal(25,2))as [On Order],"+
                         "cast(isnull(sum(CurGERQty),0)as decimal(25,2))as [Transist],"+
                         "cast (sum( case CurPOQty when 0 then 0 else CurAdjustQty/CurPOQty end)as decimal(25,2)) as [Avail/Order]";
            //whereClause = "ItemNo='"+itemNo +"' and Location='"+Loc+"' group by ItemNo,Location,CurPeriodNo";

            DataSet dsStockGrid = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                           new SqlParameter ("@tableName",tableName),
                                           new SqlParameter ("@columnName",columnName),
                                           new SqlParameter ("@whereClause",whereClause ));
            return dsStockGrid.Tables[0];
        }
        public DataTable ValidateItemNumber(string itemNo)
        {

            try
            {
                tableName = "ItemMaster";
                columnName = "ItemNo";
                whereClause = "ItemNo='" + itemNo.Trim() + "'";


                DataSet dsItemNo = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", tableName),
                                    new SqlParameter("@columnNames", columnName),
                                    new SqlParameter("@whereClause", whereClause));
                return dsItemNo.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet ExecuteSelectQuery(string tableName, string columnNames, string whereClause)
        {

            try
            {
                DataSet dsSelect = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
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
        public DataTable GetLocationValue(string itemNo,string Loc)
        {
            tableName = "ItemBranchUsage";
            columnName = "Location,cast(isnull(sum(CurEndOHQty),0)as decimal(25,2))as [On Hand]," +
                         "cast(isnull(sum(CurSalesQty),0)as decimal(25,2))as [Allocated]," +
                         "cast(isnull(sum(CurBackOrderQty),0)as decimal(25,2))as [Back Order]," +
                         "cast(isnull(sum(CurAdjustQty),0)as decimal(25,2))as [Available]," +
                         "cast(isnull(sum(CurPOQty),0)as decimal(25,2))as [On Order]," +
                         "cast(isnull(sum(CurGERQty),0)as decimal(25,2))as [Transist]," +
                         "cast (sum( case CurPOQty when 0 then 0 else CurAdjustQty/CurPOQty end)as decimal(25,2)) as [Avail/Order]";
            whereClause = "ItemNo='" + itemNo + "' and Location='" + Loc + "' group by ItemNo,Location,CurPeriodNo";

            DataSet dsStockGrid = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                           new SqlParameter("@tableName", tableName),
                                           new SqlParameter("@columnName", columnName),
                                           new SqlParameter("@whereClause", whereClause));
            return dsStockGrid.Tables[0];
        }



    }
}