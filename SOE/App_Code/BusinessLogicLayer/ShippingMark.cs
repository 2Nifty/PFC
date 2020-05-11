/********************************************************************************************
 * Project				:	SOE
 * Specification Doc.   :   NA
 * File					:	ShippingMark.cs
 * File Type			:	Class File
 * Description			:	Class which used to for implementations of the Shipping Mark Module 
 * * History				: 
 * 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				****** 
 * 03 Nov '08			Ver-1.0			Gajendran		    Created
 *********************************************************************************************/

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


/// <summary>
/// Summary description for ShippingMark
/// </summary>
/// 
namespace PFC.SOE.BusinessLogicLayer
{
    public class ShippingMark
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string _tableName = "";
        string _columnName = "";
        string _whereClause = "";

        public string HeaderIDColumn
        {
            get
            {
                if (HttpContext.Current.Session["OrderTableName"].ToString() == "SOHeader")
                    return "fSOHeaderID";
                else if (HttpContext.Current.Session["OrderTableName"].ToString() == "SOHeaderRel")
                    return "pSOHeaderRelID";
                else
                    return "fSOHeaderID";
            }
        }

        #region Shipping Mark

        public DataTable GetShipInstructionType()
        {
            try
            {
                string _whereClause = "a.pListMasterID=b.fListMasterID and a.ListName='SOEShipInstr' Order by b.SequenceNo";
                string _tableName = "listmaster a,ListDetail b ";
                string _columnName = "b.ListValue as ListValue,b.ListDtlDesc as ListDtlDesc";

                DataSet dslist = new DataSet();
                dslist = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));

                return dslist.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataTable GetShippingMarks(String SoNumber)
        {
                try
                {

                    _tableName = HttpContext.Current.Session["OrderTableName"].ToString();
                    _columnName = "ShippingMark1,ShippingMark2,ShippingMark3,ShippingMark4,Remarks,ShipInstrCdName,ShipInstrCd,SellToCustName,SellToCustNo";
                    _whereClause = HeaderIDColumn + "='" + SoNumber + "'";
                    DataSet dsSalesOrderDetails = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                        new SqlParameter("@tableName", _tableName),
                                        new SqlParameter("@columnNames", _columnName),
                                        new SqlParameter("@whereClause", _whereClause));
                    return dsSalesOrderDetails.Tables[0];
                }
                catch (Exception ex)
                {
                    return null;
                }
        }

        public void UpdateShippingMarks(string columnValues, string SoNumber)
        {
                try
                {
                    _tableName = HttpContext.Current.Session["OrderTableName"].ToString();
                    _whereClause = HeaderIDColumn + "='" + SoNumber + "'";
                    SqlHelper.ExecuteNonQuery(ERPConnectionString, "pSOEUpdate",
                                 new SqlParameter("@tableName", _tableName),
                                 new SqlParameter("@columnNames", columnValues),
                                 new SqlParameter("@whereClause", _whereClause));
                }
                catch (Exception ex)
                {

                }
        }

        public DataSet GetShippingMarksExport(String SoNumber,string tableName)
        {
            try
            {
                _tableName = tableName;
                _columnName = "ShippingMark1,ShippingMark2,ShippingMark3,ShippingMark4,Remarks,ShipInstrCdName,ShipInstrCd,SellToCustNo,SellToCustName,SellToAddress1,SellToAddress2,SellToAddress3,SellToCity,SellToState,SellToZip,SellToCountry,SellToContactName,SellToContactPhoneNo,ShipToCd,ShipToName,ShipToAddress1,ShipToAddress2,ShipToAddress3,City,State,Country,CountryCD,Zip,PhoneNo,FaxNo,ContactName,ContactPhoneNo";
                string columnName = (tableName.ToUpper() == "SOHEADER") ? " ,pSOHeaderID as ID" : ",pSOHeaderRelID as ID";
                _whereClause = (tableName.ToUpper() == "SOHEADER") ? ("fSOHeaderID='" + SoNumber + "'") : ("pSOHeaderRelID='" + SoNumber + "'");
                DataSet dsSalesOrderDetails = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName+columnName ),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsSalesOrderDetails;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        #endregion
    }
}
