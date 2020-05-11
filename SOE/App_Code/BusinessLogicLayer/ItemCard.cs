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
    /// Summary description for ItemCard
    /// </summary>
    public class ItemCards
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

        public DataTable GetItCards(string itemNo, string location)
        {
            try
            {
                DataSet dsItem = SqlHelper.ExecuteDataset(ERPConnectionString, "[pSOEItemCard]",
                                new SqlParameter("@ItemNo", itemNo),
                                new SqlParameter("@Loc", location));
                return dsItem.Tables[0];

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public DataTable ValidateItemNumber(string itemNo)
        {

            try
            {
                tableName = "ItemMaster";
                columnName = "ItemNo";
                whereClause = "ItemNo='" +itemNo.Trim()+ "'";


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

    }
}
