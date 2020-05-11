/********************************************************************************************
 * File	Name			:	ItemBuilder.cs
 * File Type			:	C#
 * Project Name			:	PFC Sales Pricing 
 * Module Description	:	temBuilder class is used for getting Item Details
 * Created By			:	Sathya
 * Created Date			:	19/01/2007
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 19/01/2007 	        Version 1		Sathya      		Created 
 * 10/03/2007 	        Version 1		Mahesh      		Edited 
 *********************************************************************************************/

#region Namespace
using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.ComponentModel;
using System.Windows.Forms;
using System.Collections;
using PFC.SOE.DataAccessLayer;


#endregion


namespace PFC.SOE.BusinessLogicLayer
{
    /// <summary>
    /// ItemBuilder class is used for getting Item Details
    /// </summary>
    public class ItemBuilder
    {
        #region Variable declaration
        
        // Variable declaration
        private string _tableName = string.Empty;
        private string _columnNames = string.Empty;
        private string _whereClause = string.Empty;
        private string strCommand = string.Empty;

        OrderEntry pfcQMSService = new OrderEntry(); 
        #endregion

        #region Constructor

        /// <summary>
        /// ItemBuilder :ItemBuilder class is used for getting Item Details
        /// </summary>
        public ItemBuilder()
        {
           
        }
        #endregion

        private string _itemFamily = string.Empty;
        private string _itemProductLine = string.Empty;
        private string _itemCategory = string.Empty;
        private string _itemDiameter = string.Empty;
        private string _itemLength = string.Empty;
        private string _itemPlating = string.Empty;
        private string _itemPackage = string.Empty;

        public string ItemFamily
        {
            get
            {
                if (_itemFamily == "")
                    return "<> '" + _itemFamily + "'";
                else
                    return "= '" + _itemFamily + "'";
            }
            set
            {
                _itemFamily = value;
            }
        }

        public string ItemProductLine
        {
            get
            {
                if (_itemProductLine == "")
                    return "<> '" + _itemProductLine + "'";
                else
                    return "= '" + _itemProductLine + "'";
            }
            set
            {
                _itemProductLine = value;
            }
        }

        public string ItemCategory
        {
            get
            {
                if (_itemCategory == "")
                    return "<> '" + _itemCategory + "'";
                else
                    return "= '" + _itemCategory + "'";
            }
            set
            {
                _itemCategory = value;
            }
        }

        public string ItemDiameter
        {
            get
            {
                if (_itemDiameter == "")
                    return "<> '" + _itemDiameter + "'";
                else
                    return "= '" + _itemDiameter + "'";
            }
            set
            {
                _itemDiameter = value;
            }
        }

        public string ItemLength
        {
            get
            {
                if (_itemLength == "")
                    return "<> '" + _itemLength + "'";
                else
                    return "= '" + _itemLength + "'";
            }
            set
            {
                _itemLength = value;
            }
        }

        public string ItemPlating
        {
            get
            {
                if (_itemPlating == "")
                    return "<> '" + _itemPlating + "'";
                else
                    return "= '" + _itemPlating + "'";
            }
            set
            {
                _itemPlating = value;
            }
        }

        public string ItemPackage
        {
            get
            {
                if (_itemPackage == "")
                    return "";
                else
                    return   _itemPackage  ;
            }
            set
            {
                _itemPackage = value;
            }
        }


        #region Developer Code
        /// <summary>
        /// GetItemFamily : Method Used to get Item family
        /// </summary>
        /// <returns> DataTable Item Family </returns>
        public DataTable GetItemFamily()
        {
            try
            {
                _tableName = "ItemCatalog a INNER JOIN CatalogChapter b ON a.CHAPTER = b.CODE";
                _columnNames = "DISTINCT a.CHAPTER, b.DESCR AS ChapterDesc, b.SORTBY";
                _whereClause = "a.CHAPTER <> '' order by b.SORTBY";
                                
                DataSet dsItemFamily = ExecuteSelectQuery(_tableName, _columnNames, _whereClause);

                if (dsItemFamily.Tables[0] != null)
                    return dsItemFamily.Tables[0];
                
                return null;
            }
            catch (Exception ex){return null;}

        }
        /// <summary>
        /// GetItemProductLine : Method Used to get Item ProductLine
        /// </summary>
        /// <param name="strItemFamily">string Item family</param>
        /// <returns>DataTable Item ProductLine </returns>
        public DataTable GetItemProductLine()
        {
            try
            {
                _tableName = "ItemCatalog a INNER JOIN CatalogProductLine b ON a.PRODUCTLINE = b.CODE";
                _columnNames = "DISTINCT a.PRODUCTLINE, b.DESCR AS PRODUCTLINEDESC, b.SORTBY, a.CHAPTER";
                _whereClause = "(a.PRODUCTLINE <> '') AND (a.CHAPTER " + ItemFamily + ") ORDER BY b.SORTBY";

                DataSet dsItemProductLine = ExecuteSelectQuery(_tableName, _columnNames, _whereClause);
                if (dsItemProductLine.Tables[0] != null)
                    return dsItemProductLine.Tables[0];
                
                return null;
            }
            catch (Exception ex){return null; }
        }

        /// <summary>
        /// GetItemCatagory:Method Used to Get Item Catagory
        /// </summary>
        /// <param name="strItemFamily">string Item family </param>
        /// <param name="strProductLine">string Item ProductLine</param>
        /// <returns>DataTable ItemCatagory</returns>
        public DataTable GetItemCatagory()
        {
            try
            {
                //strCommand = "SELECT DISTINCT CatalogCategory.DESCR AS Description, TMP.CATEGORY as Category " +
                //                    " FROM  (SELECT DISTINCT b.CODE AS DIAMETERCODE, b.DIAMETER AS DIAMETERDESC, a.CATEGORY " +
                //                     " FROM ItemCatalog a INNER JOIN CatalogDiameter b ON a.CATEGORY = b.CATALOGCODE AND a.DIAMETER = b.DIAMETER " +
                //                    " WHERE (a.DIAMETER <> '') AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ")) TMP INNER JOIN " +
                //                     " CatalogCategory ON TMP.CATEGORY COLLATE SQL_Latin1_General_CP1_CI_AS = CatalogCategory.CODE ORDER BY CatalogCategory.DESCR";

                _columnNames = "DISTINCT CatalogCategory.DESCR AS Description, TMP.CATEGORY as Category FROM  (SELECT DISTINCT b.CODE AS DIAMETERCODE, b.DIAMETER AS DIAMETERDESC, a.CATEGORY ";
                _tableName = "ItemCatalog a INNER JOIN CatalogDiameter b ON a.CATEGORY = b.CATALOGCODE AND a.DIAMETER = b.DIAMETER ";
                _whereClause = "(a.DIAMETER <> '') AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ")) TMP INNER JOIN  CatalogCategory ON TMP.CATEGORY COLLATE SQL_Latin1_General_CP1_CI_AS = CatalogCategory.CODE ORDER BY CatalogCategory.DESCR";

                DataSet dsItemCatagory = ExecuteSelectQuery(_tableName, _columnNames, _whereClause);

                if (dsItemCatagory.Tables[0] != null)
                    return dsItemCatagory.Tables[0];
        
                return null;
            }
            catch (Exception ex){return null;}
        }

        /// <summary>
        /// GetItemDiameter :Method used to get Item Diameter
        /// </summary>
        /// <param name="strItemFamily">string Item family</param>
        /// <param name="strProductLine">string Item ProductLine</param>
        /// <param name="strItemCatagory">string Item Catagory</param>
        /// <returns> DataTable Item Diameter</returns>
        public DataTable GetItemDiameter()
        {
            try
            {
                _tableName = "ItemCatalog a INNER JOIN CatalogDiameter b ON a.CATEGORY = b.CATALOGCODE AND a.DIAMETER = b.DIAMETER";
                _columnNames = "DISTINCT b.CODE AS DIAMETERCODE, b.DIAMETER AS DIAMETERDESC";
                _whereClause = "(a.DIAMETER <> '') AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ") AND (a.CATEGORY " + ItemCategory + ") ORDER BY DIAMETERCODE";

                DataSet dsItemDiameter = ExecuteSelectQuery(_tableName, _columnNames, _whereClause);
                if (dsItemDiameter.Tables[0] != null)
                    return dsItemDiameter.Tables[0];
                
                return null;
            }
            catch (Exception ex){return null;}
        }
        /// <summary>
        /// GetItemLength :Method used to Get Item Length
        /// </summary>
        /// <param name="strItemFamily">string Item family</param>
        /// <param name="strProductLine">string Item ProductLine</param>
        /// <param name="strItemCatagory">string Item Catagory</param>
        /// <param name="strDiameter">string Item Diameter</param>
        /// <returns>DataTable Item Length</returns>
        public DataTable GetItemLength()
        {
            try
            {
                _tableName = "ItemCatalog a INNER JOIN CatalogLength b ON a.CATEGORY = b.CATALOGCODE AND a.LENGTH = b.LENGTH";
                _columnNames = "DISTINCT b.CODE AS LENGTHCODE, b.LENGTH AS LENGTHDESC";
                _whereClause = "(a.LENGTH <> '') AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ") AND (a.CATEGORY " + ItemCategory + ") AND (a.DIAMETER " + ItemDiameter + ") ORDER BY LENGTHCODE";

                DataSet dsItemLength = ExecuteSelectQuery(_tableName, _columnNames, _whereClause);
                if (dsItemLength.Tables[0] != null)
                    return dsItemLength.Tables[0];
                
                return null;
            }
            catch (Exception ex) {return null;}
        }

        /// <summary>
        /// GetItemPlating : Method used to Get Item Plating
        /// </summary>
        /// <param name="strItemFamily">string Item family</param>
        /// <param name="strProductLine">string Item ProductLine</param>
        /// <param name="strItemCatagory">string Item Catagory</param>
        /// <param name="strDiameter">string Item Diameter</param>
        /// <param name="strLength">string Item Length</param>
        /// <returns>DataTable Item Plating</returns>
        public DataTable GetItemPlating()
        {
            try
            {
                _tableName = "ItemCatalog a INNER JOIN CatalogPlating b ON a.PLATING = b.CODE LEFT OUTER JOIN Inventory c ON a.ITEMID = c.ITEMID";
                _columnNames = "DISTINCT a.PLATING, b.DESCR AS PLATINGDESC";
                _whereClause = "(a.PLATING <> '') AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ") AND " +
                               "  (a.CATEGORY " + ItemCategory + ") AND (a.DIAMETER " + ItemDiameter + ") AND (a.LENGTH " + ItemLength + ") ORDER BY PLATINGDESC";


                DataSet dsItemPlating = ExecuteSelectQuery(_tableName, _columnNames, _whereClause);
                if (dsItemPlating.Tables[0] != null)
                    return dsItemPlating.Tables[0];
        
                return null;
            }
            catch (Exception ex){return null;}
        }
        /// <summary>
        /// GetItemPackage : Method used to Get Item Package
        /// </summary>
        /// <param name="strItemFamily">string Item family</param>
        /// <param name="strProductLine">string Item ProductLine</param>
        /// <param name="strItemCatagory">string Item Catagory</param>
        /// <param name="strDiameter">string Item Diameter</param>
        /// <param name="strLength">string Item Length</param>
        /// <param name="strPlating">string Plating Type</param>
        /// <returns>DataTable ItemPackage</returns>
        public DataTable GetItemPackage()
        {
            try
            {
                _tableName = "ItemCatalog a INNER JOIN Inventory b ON a.ITEMID = b.ITEMID";
                _columnNames = "DISTINCT CAST(CAST(ISNULL(b.QTYBASEUOM, 0) AS integer) AS varchar(50)) + RTRIM(ISNULL(b.STKUM, '')) + RTRIM(ISNULL(b.SUPEREQUIVUOM, '')) " +
                               "+ RTRIM(ISNULL(b.STKUM, '')) + RTRIM(ISNULL(b.WEIGHT100UOM, '')) AS PACKAGE, CAST(CAST(ISNULL(b.QTYBASEUOM, 0) AS integer) " +
                               " AS varchar(50)) + '/' + RTRIM(b.STKUM) + ' _ ' + RTRIM(ISNULL(b.SUPEREQUIVUOM, '')) + ' ' + RTRIM(ISNULL(b.STKUM, '')) " +
                               "+ '/' + RTRIM(ISNULL(b.WEIGHT100UOM, '')) AS PACKAGEDESC, a.PACKAGE AS PACKAGEID";
                _whereClause = "(a.PACKAGE <> '') AND (a.PLATING " + ItemPlating + ") AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ") AND " +
                               " (a.CATEGORY " + ItemCategory + ") AND (a.DIAMETER " + ItemDiameter + ") AND (a.LENGTH " + ItemLength + ") ORDER BY PACKAGEDESC";

                DataSet dsItemPackage = ExecuteSelectQuery(_tableName, _columnNames, _whereClause);

                if (dsItemPackage.Tables[0] != null)
                    return dsItemPackage.Tables[0];
                
                return null;
            }
            catch (Exception ex){return null;}
        }
       
        public DataTable GetItemNumber()
        {
            try
            {
                _tableName = "ItemCatalog a inner join Inventory b on a.ItemID =b.ItemID";
                _columnNames = "Distinct a.ItemId as ItemNo,b.descr1 as Description,CONVERT(decimal(38, 2), b.WEIGHT) AS Weight, CONVERT(decimal(38, 2),b.QTYBASEUOM) AS Quantity, b.STKUM AS BaseUOM ";
                //_whereClause = "(a.PACKAGE " + ItemPackage + ") And (a.PLATING " + ItemPlating + ") AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ") AND " +
                //              " (a.CATEGORY " + ItemCategory + ") AND (a.DIAMETER " + ItemDiameter + ") AND (a.LENGTH " + ItemLength + ") ";
                string package = (ItemPackage == "") ? "" : "(SUBSTRING( a.ItemId, 12, 1))='" + ItemPackage + "' And ";
                _whereClause = package + " (a.PLATING " + ItemPlating + ") AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ") AND " +
                            " (a.CATEGORY " + ItemCategory + ") AND (a.DIAMETER " + ItemDiameter + ") AND (a.LENGTH " + ItemLength + ") ";


                DataSet dsItemID = ExecuteSelectQuery(_tableName, _columnNames, _whereClause);
                if (dsItemID.Tables[0] != null)
                    return dsItemID.Tables[0];
                
                return null;
            }
            catch (Exception ex){throw ex;}
        }

        public DataTable GetAppPakage()
        {
            try
            {
                _tableName = "AppPref";
                _columnNames = "ApplicationCd, AppOptionType, cast(AppOptionNumber as int) as AppOptionNumber, AppOptionValue";
                _whereClause = "(ApplicationCd = 'IB') AND (AppOptionType = 'PackageFilter') ORDER BY AppOptionNumber";

                DataSet dsItemID = ExecuteSelectQuery(_tableName, _columnNames, _whereClause);
                if (dsItemID.Tables[0] != null)
                    return dsItemID.Tables[0];

                return null;
            }
            catch (Exception ex) { throw ex; }
        }
        #endregion     


        #region Code to update request quantity table

        public void UpdateReqQty(Hashtable htUpdate)
        {
            try
            {

                // Datatable declaration for updating into tables
                DataTable dtSelectedDetails = new DataTable();
                dtSelectedDetails.Columns.Add("LocationCode");
                dtSelectedDetails.Columns.Add("LocationName");
                dtSelectedDetails.Columns.Add("Quantity");

                DataRow dr = dtSelectedDetails.NewRow();
                dr[0] = htUpdate["Location Code"].ToString().Trim();
                dr[1] = htUpdate["Location Name"].ToString().Trim();
                dr[2] = htUpdate["Quantity"].ToString().Trim();
                dtSelectedDetails.Rows.Add(dr);

                DataSet dsReqQuantity = new DataSet();
                dsReqQuantity.Tables.Add(dtSelectedDetails);

                //pfcQMSService.UpdateLocationDetail(htUpdate["Quote #"].ToString().Trim(), htUpdate["Quantity"].ToString().Trim(), dsReqQuantity);
            }
            catch (Exception ex) { }
        }

        #endregion

        public DataSet ExecuteSelectQuery(string tableName, string columnNames, string whereClause)
        {

            try
            {
                DataSet dsSelect = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "UGEN_SP_Select",
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

    }// End Class

}// End Namespaces 
