
/********************************************************************************************
 * File	Name			:	ItemBuilder.cs
 * File Type			:	C#
 * Project Name			:	PFC Sales Pricing 
 * Module Description	:	itemBuilder class is used for getting Item Details
 * Created By			:	Sathya
 * Created Date			:	19/01/2007
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION      DESCRIPTION
 * ****					*******			******				******
 * 19/01/2007 	        Version 1		Sathya      		Created 
 * 06/15/2012 	        Version 2		Pete Arreola  		Modified    Added Bulk Pkg filter and NetWeight  
 *********************************************************************************************/

#region Namespace
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
using PFC.Intranet.DataAccessLayer;
using System.Data.Sql;
using System.Data.SqlClient;
#endregion

namespace PFC.Intranet
{
    /// <summary>
    /// ItemBuilder class is used for getting Item Details
    /// </summary>
    public class ItemBuilder
    {
        #region Variable declaration
        // Constant declaration
        const string SPGENERALSELECT = "UGEN_SP_SELECT";

        // Variable declaration
        private string reportConnectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
        private string PFCERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        
        private string _tableName = string.Empty;
        private string _columnNames = string.Empty;
        private string _whereClause = string.Empty;
        private string strCommand = string.Empty;
        #endregion

        #region Property Bags
        private string _itemFamily =string.Empty;
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
            set { 
                _itemFamily = value; }
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
        
        //public string ItemPackage
        //{
        //    get
        //    {
        //        if (_itemPackage == "")
        //            return " AND (b.QTYBASEUOM IS NOT NULL) AND (b.SUPEREQUIVUOM IS NOT NULL)";
        //        else
        //        {
        //            string _whereClause = "";
        //            string[] _Array = _itemPackage.Split('`');
        //            if(_Array.Length == 2)
        //                _whereClause = " AND (b.QTYBASEUOM =" + _Array[0] + ") AND (b.SUPEREQUIVUOM=" + _Array[1]+ ")";
        //            return _whereClause;
        //        }
        //    }
        //    set
        //    {              
        //        _itemPackage = value;
        //    }
        //}

        public string ItemPackage
        {
            get
            {
                if (_itemPackage == "")
                    return " AND ( a.ItemId IS NOT NULL)";
                else
                {
                    string _whereClause = "";
                    _whereClause = " AND (SUBSTRING( a.ItemId, 14, 1))='"+ItemPackage.ToString()+"'";
                    return _whereClause;
                }
            }
            set
            {
                _itemPackage = value;
            }
        }
        #endregion

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
                _whereClause = "a.CHAPTER <> '' order by b.SortBY";

                DataSet dsItemFamily = (DataSet)SqlHelper.ExecuteDataset(reportConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsItemFamily.Tables[0] != null)
                {
                    return dsItemFamily.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
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

                DataSet dsItemProductLine = (DataSet)SqlHelper.ExecuteDataset(reportConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsItemProductLine.Tables[0] != null)
                {
                    return dsItemProductLine.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetProduct()
        {
            try
            {
                _tableName = "CatalogChapter";
                _columnNames = "DESCR";
                _whereClause = "(CODE" + ItemFamily + ")";

                DataSet dsItemProductLine = (DataSet)SqlHelper.ExecuteDataset(reportConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsItemProductLine.Tables[0] != null)
                {
                    return dsItemProductLine.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
       
        /// <summary>
        /// GetItemCatagory:Method Used to Get Item Catagory
        /// </summary>
        /// <param name="strItemFamily">string Item family </param>
        /// <param name="strProductLine">string Item ProductLine</param>
        /// <returns>DataTable ItemCatagory</returns>
        public DataTable GetProductLine(string CategoryID)
        {
            try
            {
                strCommand = "select DISTINCT(PRODUCTLINE)from ItemCatalog where Category='"+CategoryID+"'";

                DataSet dsItemCatagory = (DataSet)SqlHelper.ExecuteDataset(reportConnectionString, CommandType.Text, strCommand);

                if (dsItemCatagory.Tables[0] != null)
                {
                    return dsItemCatagory.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetItemCatagory()
        {
            try
            {
                //Modified by Slater to sort categories by SORTBY
                //strCommand = "select DISTINCT CatalogCategory.DESCR AS Description, TMP.CATEGORY as Category FROM  (SELECT DISTINCT b.CODE AS DIAMETERCODE, b.DIAMETER AS DIAMETERDESC, a.CATEGORY from ItemCatalog a INNER JOIN CatalogDiameter b ON a.CATEGORY = b.CATALOGCODE AND a.DIAMETER = b.DIAMETER where (a.DIAMETER <> '') AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE  " + ItemProductLine + " )) TMP INNER JOIN  CatalogCategory ON TMP.CATEGORY COLLATE SQL_Latin1_General_CP1_CI_AS = CatalogCategory.CODE ORDER BY TMP.CATEGORY";
                strCommand = "select DISTINCT CatalogCategory.DESCR AS Description, TMP.CATEGORY as Category, CatalogCategory.SORTBY FROM  (SELECT DISTINCT b.CODE AS DIAMETERCODE, b.DIAMETER AS DIAMETERDESC, a.CATEGORY from ItemCatalog a INNER JOIN CatalogDiameter b ON a.CATEGORY = b.CATALOGCODE AND a.DIAMETER = b.DIAMETER where (a.DIAMETER <> '') AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE  " + ItemProductLine + " )) TMP INNER JOIN  CatalogCategory ON TMP.CATEGORY COLLATE SQL_Latin1_General_CP1_CI_AS = CatalogCategory.CODE ORDER BY CatalogCategory.SortBy";

                DataSet dsItemCatagory = (DataSet)SqlHelper.ExecuteDataset(reportConnectionString, CommandType.Text, strCommand);

                if (dsItemCatagory.Tables[0] != null)
                {
                    return dsItemCatagory.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        //public DataTable GetItemCatagory1()
        //{
        //    try
        //    {
        //        strCommand = "SELECT DISTINCT CatalogCategory.DESCR AS Description, TMP.CATEGORY as Category FROM ItemCatalog a INNER JOIN CatalogDiameter b ON a.CATEGORY = b.CATALOGCODE  WHERE  (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ")";

        //        DataSet dsItemCatagory = (DataSet)SqlHelper.ExecuteDataset(connectionString, CommandType.Text, strCommand);

        //        if (dsItemCatagory.Tables[0] != null)
        //        {
        //            return dsItemCatagory.Tables[0];
        //        }
        //        return null;
        //    }
        //    catch (Exception ex)
        //    {
        //        return null;
        //    }
        //}

        /// <summary>
        /// GetItemDiameter :Method used to get Item Diameter
        /// </summary>
        /// <param name="strItemFamily">string Item family</param>
        /// <param name="strProductLine">string Item ProductLine</param>
        /// <param name="strItemCatagory">string Item Catagory</param>
        /// <returns> DataTable Item Diameter</returns>
        /// 
        public DataTable GetItemDiameter()
        {
            try
            {
                _tableName = "ItemCatalog a INNER JOIN CatalogDiameter b ON a.CATEGORY = b.CATALOGCODE AND a.DIAMETER = b.DIAMETER";
                _columnNames = "DISTINCT b.CODE AS DIAMETERCODE, b.DIAMETER AS DIAMETERDESC";
                _whereClause = "(a.DIAMETER <> '') AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ") AND (a.CATEGORY " + ItemCategory + ") ORDER BY DIAMETERCODE";

                DataSet dsItemDiameter = (DataSet)SqlHelper.ExecuteDataset(reportConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsItemDiameter.Tables[0] != null)
                {
                    return dsItemDiameter.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
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

                DataSet dsItemLength = (DataSet)SqlHelper.ExecuteDataset(reportConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsItemLength.Tables[0] != null)
                {
                    return dsItemLength.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
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

                DataSet dsItemPlating = (DataSet)SqlHelper.ExecuteDataset(reportConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsItemPlating.Tables[0] != null)
                {
                    return dsItemPlating.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetPlating()
        {
            try
            {
                _tableName = "ItemCatalog a INNER JOIN CatalogPlating b ON a.PLATING = b.CODE LEFT OUTER JOIN Inventory c ON a.ITEMID = c.ITEMID";
                _columnNames = "DISTINCT a.PLATING, b.DESCR AS PLATINGDESC";
                _whereClause = "(a.PLATING <> '') AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ") AND (a.CATEGORY " + ItemCategory + ") ORDER BY PLATINGDESC";

                DataSet dsItemPlating = (DataSet)SqlHelper.ExecuteDataset(reportConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsItemPlating.Tables[0] != null)
                {
                    return dsItemPlating.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
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
        //public DataTable GetItemPackage()
        //{
        //    try
        //    {
        //        _tableName = "ItemCatalog a INNER JOIN Inventory b ON a.ITEMID = b.ITEMID";
        //        _columnNames = "DISTINCT CAST(CAST(ISNULL(b.QTYBASEUOM, 0) AS integer) AS varchar(50)) + RTRIM(ISNULL(b.STKUM, '')) + RTRIM(ISNULL(b.SUPEREQUIVUOM, '')) " +
        //                       "+ RTRIM(ISNULL(b.STKUM, '')) + RTRIM(ISNULL(b.WEIGHT100UOM, '')) AS PACKAGE, CAST(CAST(ISNULL(b.QTYBASEUOM, 0) AS integer) " +
        //                       " AS varchar(50)) + '/' + RTRIM(b.STKUM) + ' _ ' + RTRIM(ISNULL(b.SUPEREQUIVUOM, '')) + ' ' + RTRIM(ISNULL(b.STKUM, '')) " +
        //                       "+ '/' + RTRIM(ISNULL(b.WEIGHT100UOM, '')) AS PACKAGEDESC, a.PACKAGE AS PACKAGEID";
        //        _whereClause = "(a.PACKAGE <> '') AND (a.PLATING " + ItemPlating + ") AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ") AND " +
        //                       " (a.CATEGORY " + ItemCategory + ") AND (a.DIAMETER " + ItemDiameter + ") AND (a.LENGTH " + ItemLength + ") ORDER BY PACKAGEDESC";

        //        DataSet dsItemPackage = (DataSet)SqlHelper.ExecuteDataset(connectionString, SPGENERALSELECT,
        //                                               new SqlParameter("@tableName", _tableName),
        //                                               new SqlParameter("@columnNames", _columnNames),
        //                                               new SqlParameter("@whereClause", _whereClause));
        //        if (dsItemPackage.Tables[0] != null)
        //        {
        //            return dsItemPackage.Tables[0];
        //        }
        //        return null;
        //    }
        //    catch (Exception ex)
        //    {
        //        return null;
        //    }
        //}

        public DataTable GetPackage()
        {
            try
            {
               _tableName = "AppPref";
               _columnNames = "ApplicationCd, AppOptionType, cast(AppOptionNumber as int) as AppOptionNumber, AppOptionValue ";
               _whereClause = "(ApplicationCd = 'IB') AND (AppOptionType = 'PackageFilter') ORDER BY AppOptionNumber ";

               DataSet dsItemPackage = (DataSet)SqlHelper.ExecuteDataset(reportConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsItemPackage.Tables[0] != null)
                {
                    return dsItemPackage.Tables[0];
                }
               
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetResults()
        {
            try
            {
                _tableName = "ItemCatalog a inner join Inventory b on a.ItemID =b.ItemID";
                _columnNames = "Distinct a.ItemId as ItemNo,a.Diameter,a.PLATING as Plating,b.descr1 as Description,b.SUPEREQUIVUOM as SuperEquivalent,CONVERT(decimal(38, 0), b.WEIGHT) AS Weight, CONVERT(decimal(38, 2),b.QTYBASEUOM) AS Quantity, b.STKUM AS BaseUOM";
                _whereClause = "(a.DIAMETER <> '') AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ") AND (a.CATEGORY " + ItemCategory + ") AND (a.PLATING " + ItemPlating + ") AND (a.PACKAGE " + ItemPackage + ")";

                DataSet dsItemPackage = (DataSet)SqlHelper.ExecuteDataset(reportConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsItemPackage.Tables[0] != null)
                {
                    return dsItemPackage.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetCustomerID(string custNo)
        {
            try
            {
                _tableName = "customerMaster";
                _columnNames = "pcustmstrID";
                _whereClause = "custno='" + custNo + "'";

                DataSet dsCustomerID = (DataSet)SqlHelper.ExecuteDataset(PFCERPConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsCustomerID.Tables[0] != null)
                {
                    string custID = dsCustomerID.Tables[0].Rows[0]["pcustmstrID"].ToString();
                    DataSet dsCustomerInfo = (DataSet)SqlHelper.ExecuteDataset(PFCERPConnectionString, SPGENERALSELECT,
                                                      new SqlParameter("@tableName", "customerAddress"),
                                                      new SqlParameter("@columnNames", "Name1,PostCd,City,State,AddrLine1"),
                                                      new SqlParameter("@whereClause", "fcustomermasterid='" + custID + "' and type not in('DSHP','SHP')"));
                    return dsCustomerInfo.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public bool checkCustomerNumber(string custNo)
        {
            try
            {
                _tableName = "customerMaster";
                _columnNames = "*";
                _whereClause = "custno='" + custNo + "'";

                DataSet dsCustomerID = (DataSet)SqlHelper.ExecuteDataset(PFCERPConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsCustomerID.Tables[0].Rows.Count>0 )
                {
                    return true;
                }
                return false;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

        /*
         * Pete added
         */

        public bool checkCustomerContract(string custNo)
        {
            try
            {
                _tableName = "customerPrice";
                _columnNames = "*";
                _whereClause = "custno='" + custNo + "'";

                DataSet dsCustomerID = (DataSet)SqlHelper.ExecuteDataset(PFCERPConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsCustomerID.Tables[0].Rows.Count > 0)
                {
                    return true;
                }
                return false;
            }
            catch (Exception ex)
            {
                return false;
            }
        }

       
        public DataTable GetResultsGrid()
        {
            try
            {
                _tableName = "ItemCatalog a inner join Inventory b on a.ItemID =b.ItemID";
                _columnNames = "Distinct (left(a.ItemId ,10)) as ItemNo,a.Diameter,a.PLATING as Plating,b.descr1 as Description,(b.SUPEREQUIVUOM + '/'+ b.WEIGHT100UOM)as SuperEquivalent,(CONVERT(varchar(41), CONVERT(decimal(38, 0), b.QTYBASEUOM)) +' / ' + b.STKUM ) as Quantity";
              //_tableName = "ItemCatalog a inner join Inventory b on a.ItemID =b.ItemID";
              //_columnNames = "distinct (left(a.ItemId ,10))as Category,a.Diameter,(CONVERT(varchar(41), CONVERT(decimal(38, 0), b.QTYBASEUOM)) +' / ' + b.STKUM )AS BaseUOM1";
                _whereClause = "(a.DIAMETER <> '') AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ") AND (a.CATEGORY " + ItemCategory + ")";

                DataSet dsItemPackage = (DataSet)SqlHelper.ExecuteDataset(reportConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsItemPackage.Tables[0] != null)
                {
                    return dsItemPackage.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
       
        //public DataTable GetItemNumber()
        //{
        //    try
        //    {
        //        _tableName = "ItemCatalog a inner join Inventory b on a.ItemID =b.ItemID";
        //        _columnNames = "Distinct a.ItemId as ItemNo,b.descr1 as Description,CONVERT(decimal(38, 2), b.WEIGHT) AS Weight, CONVERT(decimal(38, 2),b.QTYBASEUOM) AS Quantity, b.STKUM AS BaseUOM ";
        //        _whereClause = "(a.PACKAGE " + ItemPackage + ") And (a.PLATING " + ItemPlating + ") AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ") AND " +
        //                      " (a.CATEGORY " + ItemCategory + ") AND (a.DIAMETER " + ItemDiameter + ") AND (a.LENGTH " + ItemLength + ") ";

        //        DataSet dsItemID = (DataSet)SqlHelper.ExecuteDataset(connectionString, SPGENERALSELECT,
        //                                               new SqlParameter("@tableName", _tableName),
        //                                               new SqlParameter("@columnNames", _columnNames),
        //                                               new SqlParameter("@whereClause", _whereClause));
        //        if (dsItemID.Tables[0] != null)
        //        {
        //           // GetCrossReferenceNumbers("201190", dsItemID.Tables[0]);
        //            return dsItemID.Tables[0];
        //        }
        //        return null;
        //    }
        //    catch (Exception ex)
        //    {
        //        return null;
        //    }
        //}

        public DataTable GetCustValidation(string customerItemNo,string customerNumber)
        {
            string _tableName = "ItemAlias";
            string _columnName = "*";
            string _whereClause = "AliasItemNo='" + customerItemNo + "' and OrganizationNo='" + customerNumber + "' and DeleteDt is null";

            DataSet dsCustNoValidation = (DataSet)SqlHelper.ExecuteDataset(PFCERPConnectionString, SPGENERALSELECT,
                                                     new SqlParameter("@tableName", _tableName),
                                                     new SqlParameter("@columnNames", _columnName),
                                                     new SqlParameter("@whereClause", _whereClause));
            return dsCustNoValidation.Tables[0];
        }

        public DataTable GetItemID(string itemFamily)
        {
            try
            {
                _tableName = "ItemCatalog";
                _columnNames = "Top 1 Category";
                _whereClause = "chapter "+itemFamily+"";

                DataSet dsItemID = (DataSet)SqlHelper.ExecuteDataset(reportConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsItemID.Tables[0] != null)
                {
                    // GetCrossReferenceNumbers("201190", dsItemID.Tables[0]);
                    return dsItemID.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable BindImage(string ConnectionString, string ColumnNames,string Category)
        {
            try
            {
                _tableName = "ItemCategory";
                _columnNames = ColumnNames;
                _whereClause = "Category='" + Category + "'";

                DataSet dsItemID = (DataSet)SqlHelper.ExecuteDataset(ConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsItemID.Tables[0] != null)
                {
                    return dsItemID.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetAliasType(string _security)
        {
            try
            {
                _tableName = "ListMaster (NOLOCK) LM, ListDetail (NOLOCK) LD";
                _columnNames = "LD.ListValue + ' - ' + LD.ListDtlDesc as ListDesc, LD.ListValue ";

                if (_security.ToUpper() == "FULL")
                    _whereClause = "";
                else
                    _whereClause = "LD.SequenceNo <> 99 AND ";
                _whereClause += "LM.ListName = 'ItemAliasTypes' AND LD.fListMasterID = LM.pListMasterID ORDER BY LD.SequenceNo ASC";

                DataSet dsType = SqlHelper.ExecuteDataset(PFCERPConnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnNames),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsType.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetAliasTypeList()
        {
            try
            {
                _tableName = "ListMaster (NOLOCK) LM, ListDetail (NOLOCK) LD";
                _columnNames = "LD.ListValue, LD.SequenceNo ";
                _whereClause = "LM.ListName = 'ItemAliasTypes' AND LD.fListMasterID = LM.pListMasterID ORDER BY LD.SequenceNo ASC";

                DataSet dsType = SqlHelper.ExecuteDataset(PFCERPConnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnNames),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsType.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public string GetAliasTypeDesc(string aliasType)
        {
            try
            {
                _tableName = "ListMaster (NOLOCK) LM, ListDetail (NOLOCK) LD";
                _columnNames = "LD.ListDtlDesc as ListDesc ";
                _whereClause = "LM.ListName = 'ItemAliasTypes' AND LD.fListMasterID = LM.pListMasterID AND LD.ListValue = '" + aliasType.Trim() + "' ORDER BY LD.SequenceNo ASC";

                DataSet dsType = SqlHelper.ExecuteDataset(PFCERPConnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnNames),
                                    new SqlParameter("@whereClause", _whereClause));

                if (dsType.Tables[0].Rows.Count > 0)
                    return dsType.Tables[0].Rows[0]["ListDesc"].ToString();
                else
                    return "";
            }
            catch (Exception ex)
            {
                return "";
            }
        }

        public string GetItemAliasCount(string customerNumber, string aliasType)
        {
            strCommand = "SELECT COUNT(*) as AliasCount " +
                         "FROM   ItemAlias (NoLock) " +
                         "WHERE  OrganizationNo = '" + customerNumber + "' AND AliasType = '" + aliasType.Trim() + "' AND isnull(DeleteDt,'') = ''";

            DataSet dsResult = SqlHelper.ExecuteDataset(PFCERPConnectionString, CommandType.Text, strCommand);
            return dsResult.Tables[0].DefaultView.ToTable().Rows[0]["AliasCount"].ToString();
        }

        //Pete Added
        public string GetItemCustomerPriceCount(string customerNumber, string aliasType)
        {
            strCommand = "SELECT COUNT(*) as ItemNoCount " +
                         "FROM   CustomerPrice (NoLock) " +
                         "WHERE  CustNo = '" + customerNumber + "' AND PriceMethod = '" + aliasType.Trim() + "' ";

            DataSet dsResult = SqlHelper.ExecuteDataset(PFCERPConnectionString, CommandType.Text, strCommand);
            return dsResult.Tables[0].DefaultView.ToTable().Rows[0]["ItemNoCount"].ToString();
        }

        //Pete Added
        public string GetItemCustomerPriceCount(string customerNumber)
        {
            strCommand = "SELECT COUNT(*) as ItemNoCount " +
                         "FROM   CustomerPrice (NoLock) " +
                         "WHERE  CustNo = '" + customerNumber + "'";

            DataSet dsResult = SqlHelper.ExecuteDataset(PFCERPConnectionString, CommandType.Text, strCommand);
            return dsResult.Tables[0].DefaultView.ToTable().Rows[0]["ItemNoCount"].ToString();
        }

        public void BindListControls(ListControl lstControl, string textField, string valueField, DataTable dtSource)
        {
            try
            {
                if (dtSource != null && dtSource.Rows.Count > 0)
                {
                    lstControl.DataSource = dtSource;
                    lstControl.DataTextField = textField;
                    lstControl.DataValueField = valueField;
                    lstControl.DataBind();

                    if (lstControl.ID == "lstBoxPlating" || lstControl.ID == "lstBoxPackage")
                        lstControl.Items.Insert(0, new ListItem("-- Select All --", ""));
                }
                else
                {
                    lstControl.Items.Clear();
                    lstControl.Items.Insert(0, new ListItem("N/A", ""));
                }
            }
            catch (Exception ex) { }
        }

        #endregion     

        #region Functions to bring Cross reference numbers
        public DataTable GetItemNumber(string customerNumber)
        {
            try
            {
                _tableName = "ItemCatalog a inner join Inventory b on a.ItemID =b.ItemID";
                _columnNames = "Distinct a.ItemId as ItemNo,b.descr1 as Description,CONVERT(decimal(38, 2), b.WEIGHT) AS Weight, CONVERT(decimal(38, 2),b.QTYBASEUOM) AS Quantity, b.STKUM AS BaseUOM ";
                _whereClause = "(a.PACKAGE " + ItemPackage + ") And (a.PLATING " + ItemPlating + ") AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ") AND " +
                              " (a.CATEGORY " + ItemCategory + ") AND (a.DIAMETER " + ItemDiameter + ") AND (a.LENGTH " + ItemLength + ") ";

                DataSet dsItemID = (DataSet)SqlHelper.ExecuteDataset(reportConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsItemID.Tables[0] != null)
                {
                    return dsItemID.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        
        public DataTable GetItemNumberWithCrossReference(string customerNumber,string Package)
        {
            try
            {
                _tableName = "ItemCatalog a inner join Inventory b on a.ItemID =b.ItemID";
                _columnNames = "Distinct a.ItemId as ItemNo,a.Diameter,a.PLATING as Plating,b.descr1 as Description,(b.SUPEREQUIVUOM + ' ' + b.STKUM + '/'+ b.WEIGHT100UOM) as SuperEquivalent,(CONVERT(varchar(41), CONVERT(decimal(38, 0), b.QTYBASEUOM)) +'/' + b.STKUM ) as Quantity";
                _whereClause = "(a.DIAMETER <> '') AND (a.CHAPTER " + ItemFamily + ") AND (a.PRODUCTLINE " + ItemProductLine + ") AND (a.CATEGORY " + ItemCategory + ") AND (a.PLATING " + ItemPlating + ") " + Package + "";

                DataSet dsItemID = (DataSet)SqlHelper.ExecuteDataset(reportConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnNames),
                                                       new SqlParameter("@whereClause", _whereClause));
                if (dsItemID.Tables[0] != null)
                {
                    DataTable dtItemWithCrossRef = GetCrossReferenceNumbers(customerNumber, dsItemID.Tables[0]);
                    return dtItemWithCrossRef;
                }
                return null;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetCrossReferenceNumbers(string customerNumber, DataTable dtBasedonCriteria)
        {
            DataTable dtPFCItemNoForSelectedCriteria = dtBasedonCriteria;
            DataTable dtAllCrossRefNoForCustomer = GetCrossRefNumberBasedonCustomer(customerNumber);
            DataTable CrossRefResultForSelectedCriteria = CreateJoins(dtPFCItemNoForSelectedCriteria, dtAllCrossRefNoForCustomer);
            return CrossRefResultForSelectedCriteria;
        }

        private DataTable GetCrossRefNumberBasedonCustomer(string customerNumber)
        {
            string _tableName = "ItemAlias";
            string _columnName = "*";
            string _whereClause = "OrganizationNo='" + customerNumber + "' and DeleteDt is null";

            DataSet dsCustomerCrossRefNo = (DataSet)SqlHelper.ExecuteDataset(PFCERPConnectionString, SPGENERALSELECT,
                                                       new SqlParameter("@tableName", _tableName),
                                                       new SqlParameter("@columnNames", _columnName),
                                                       new SqlParameter("@whereClause", _whereClause));
            return dsCustomerCrossRefNo.Tables[0];
        }       

        private DataTable CreateJoins(DataTable dtPFCItemNumber, DataTable dtCrossRefNumber)
        {
            try
            {
                DataSet dsFinalResult = new DataSet();
                // DataSetHelper dataSetHelper = new DataSetHelper(ref dsFinalResult);
                dtPFCItemNumber.TableName = "PorteousItem";
                dtCrossRefNumber.TableName = "CrossReference";
                dtPFCItemNumber.Columns.Add("CrossRefNumber");
                dtPFCItemNumber.Columns.Add("pItemAliasID");
                dsFinalResult.Tables.Add(dtPFCItemNumber.Copy());
                dsFinalResult.Tables.Add(dtCrossRefNumber.Copy());

                DataRelation itemNumberRelation =
                dsFinalResult.Relations.Add("CrossRefItem",
                dsFinalResult.Tables["PorteousItem"].Columns["ItemNo"],
                dsFinalResult.Tables["CrossReference"].Columns["ItemNo"], false);

                foreach (DataRow pfcItemRow in dsFinalResult.Tables["PorteousItem"].Rows)
                {
                    foreach (DataRow crossReferenceRow in pfcItemRow.GetChildRows(itemNumberRelation))
                    {
                        pfcItemRow["CrossRefNumber"] = crossReferenceRow["AliasItemNo"].ToString();
                        pfcItemRow["pItemAliasID"] = crossReferenceRow["pItemAliasID"].ToString();  
                    }
                }
                return dsFinalResult.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public string updateRecords(string customerNumber,string customerItemNo,string pfcItemNumber,string priceUOM, string description,string pItemAliasId)
        {
            try
            {
                string newID = "";
                string tableName =  "ItemAlias";
                string columnName = "[OrganizationNo],[AliasType], [AliasItemNo],[ItemNo]" +
                                    ",[UOM],[AliasWhseNo],[AliasDesc],[EntryID],[EntryDt]";
                string columnValues = "'" + customerNumber + "','C', " +
                                    "'" + customerItemNo + "', " +
                                    "'" + pfcItemNumber + "','" + priceUOM + "',''," +
                                    "'" + description + "','" + HttpContext.Current.Session["UserName"].ToString() + "','" + DateTime.Now.ToShortDateString() + "'";
                string whereClause = "OrganizationNo='" + customerNumber +"' and ItemNo='" + pfcItemNumber.Trim() + "'";

                if(pItemAliasId != "")
                    DeleteCrossReferenceNumber(pItemAliasId);

                if (customerItemNo.Trim() != "")
                {
                    newID = SqlHelper.ExecuteScalar(PFCERPConnectionString, "[UGEN_SP_GetIdentityAfterInsert]",
                                 new SqlParameter("@tableName", tableName),
                                 new SqlParameter("@columnNames", columnName),
                                 new SqlParameter("@columnValues", columnValues)).ToString();
                }

                return newID;
            }
            catch (Exception ex)
            {
                return "";
            }
        }

        public void InsertTables(string columnValues)
        {
            try
            {
                SqlHelper.ExecuteDataset(PFCERPConnectionString, "[UGen_sp_insert]",
                             new SqlParameter("@tableName", "[ItemAlias]"),
                             new SqlParameter("@columnNames", "ItemNo,AliasItemNo,AliasWhseNo,AliasType,OrganizationNo,EntryID,EntryDt"),
                             new SqlParameter("@columnValues", columnValues));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void InsertAlias(string tableName, string columnNames, string columnValues)
        {
            try
            {
                SqlHelper.ExecuteDataset(PFCERPConnectionString, "[UGen_sp_insert]",
                             new SqlParameter("@tableName", tableName),
                             new SqlParameter("@columnNames", columnNames),
                             new SqlParameter("@columnValues", columnValues));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /*
        * Pete added 
        */
        public void InsertCustomerContractItem(string tableName, string columnNames, string columnValues)
        {


            try
            {
                SqlHelper.ExecuteDataset(PFCERPConnectionString, "[UGen_sp_insert]", //reportConnectionString
                             new SqlParameter("@tableName", tableName),
                             new SqlParameter("@columnNames", columnNames),
                             new SqlParameter("@columnValues", columnValues));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteCrossReferenceNumber(string pItemAliasNo)
        {
            try
            {
                // Set delete delete dt for old data
                SqlHelper.ExecuteNonQuery(PFCERPConnectionString, "UGEN_SP_Delete",
                                          new SqlParameter("@tableName", "ItemAlias"),
                                          new SqlParameter("@whereClause", "pItemAliasID=" + pItemAliasNo));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteCrossReferenceNumber(string pfcItemNumber, string customerItemNo, string customerNumber)
        {
            try
            {
                string whereClause = "(OrganizationNo='" + customerNumber.Trim() + "' and ItemNo='" + pfcItemNumber.Trim() + "' and AliasItemNo='" + customerItemNo.Replace("'","''") + "' and AliasType='C')";
                
                // Set delete delete dt for old data
                SqlHelper.ExecuteNonQuery(PFCERPConnectionString, "UGEN_SP_Delete",
                                          new SqlParameter("@tableName", "ItemAlias"),
                                          new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void DeleteCrossReferenceQueue(string customerNumber, string aliasType)
        {
            try
            {
                string whereClause = "OrganizationNo='" + customerNumber.Trim() + "' and AliasType='" + aliasType.Trim() + "'";

                // Set delete delete dt for old data
                SqlHelper.ExecuteNonQuery(PFCERPConnectionString, "UGEN_SP_Delete",
                                          new SqlParameter("@tableName", "ItemAliasUploadQueue"),
                                          new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /*
        * Pete added 
        */

        public void DeleteCustomerPriceQueue(string customerNumber)
        {
            try
            {
                string whereClause = "CustNo='" + customerNumber.Trim() + "'";

                // Set delete delete dt for old data
                SqlHelper.ExecuteNonQuery(PFCERPConnectionString, "UGEN_SP_Delete",
                                          new SqlParameter("@tableName", "CustomerPriceQueue"),
                                          new SqlParameter("@whereClause", whereClause));
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable CheckItemValidation(string ItemNo)
        {
            try
            {
                string cmd = "select * from ItemMaster where ItemNo in (" + ItemNo + ")";
                DataSet dsItemID = new DataSet();

                SqlDataAdapter adp = new SqlDataAdapter(cmd, PFCERPConnectionString);
                adp.Fill(dsItemID);

                return dsItemID.Tables[0];              
            }
            catch (Exception ex)
            {
                return null;
            }
        }
        #endregion

    }// End Class

}// End Namespaces 
