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
using PFC.WOE.DataAccessLayer;

namespace PFC.WOE.BusinessLogicLayer
{
    public class Common
    {
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string umbrellaConnectionString = ConfigurationManager.AppSettings["UmbrellaConnectionString"].ToString();

        #region Validate Item
        /// <summary>
        /// Function used to return PFC Item details for given CustomerItemNo
        /// </summary>
        /// <param name="customerItemNo">Customer or PFC Item Number</param>
        /// <param name="customerNumber">Customer Number</param>
        /// <param name="ItemNumberType">ItemType: PFC or Customer</param>
        /// <returns>if valid CustomerItemNo then return PFC Item details else Null</returns> 
        public DataSet GetProductInfo(string ItemNumber, string CustomerNumber, string shipLoc, string itemType)
        {
            try
            {
                DataSet productDetail = new DataSet();

                // Fetch the item detail
                productDetail = SqlHelper.ExecuteDataset(connectionString, "[pSOEGetItemAlias]",
                                        new SqlParameter("@SearchItemNo", ItemNumber),
                                        new SqlParameter("@Organization", CustomerNumber),
                                        new SqlParameter("@PrimaryBranch", shipLoc),
                                        new SqlParameter("@SearchType", itemType));
                return productDetail;
            }
            catch (System.Data.SqlClient.SqlException ex)
            {
                if ((ex.Number == 53) || (ex.Number == 18456))
                {
                    Exception sqlEx = new Exception("PFC Server is Unavailable!");
                    throw sqlEx;
                }
                else
                    throw ex;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        #endregion

        public void LoadSessionVariables(string userID)
        {
            try
            {
                // Local variable declaration
                string _tableName = " UCOR_UserSetup";
                string _columnName = "CompanyID,UserName,Interface,DefaultCompanyID";
                string _whereClause = "[UserID]='" + userID + "'";

                DataSet userInterface = SqlHelper.ExecuteDataset(umbrellaConnectionString, "[UGEN_SP_Select]",
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));

                // Check whether any value has returned
                if (userInterface.Tables[0].Rows.Count > 0)
                {
                    HttpContext.Current.Session["BranchID"] = GetPFCBranchCode(userInterface.Tables[0].Rows[0]["CompanyID"].ToString());
                    HttpContext.Current.Session["InterfaceID"] = userInterface.Tables[0].Rows[0]["Interface"].ToString();
                    HttpContext.Current.Session["DefaultBranchID"] = GetPFCBranchCode(userInterface.Tables[0].Rows[0]["DefaultCompanyID"].ToString());
                }

                // Load LocMaster to Session variable
                DataSet dsLocMaster = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                                                new SqlParameter("@tableName", "LocMaster"),
                                                new SqlParameter("@columnNames", "LocID,LocType,LocName,LocAdress1,LocAdress2,LocCity,LocState,LocPostCode,LocCountry,LocPhone,LocFax,LocEmail,ShipMethCd,ReqPOInd"),
                                                new SqlParameter("@whereCondition", " 1=1 "));
                HttpContext.Current.Session["LocMaster"] = dsLocMaster.Tables[0];


                // Load Security Information
                string emailAdrress = SqlHelper.ExecuteScalar(connectionString, "[UGEN_SP_Select]",
                                                new SqlParameter("@tableName", "SecurityUsers"),
                                                new SqlParameter("@columnNames", "EmailAddress"),
                                                new SqlParameter("@whereCondition", " MSADUserName='" + HttpContext.Current.Session["UserName"] + "' and DeleteDt is null")).ToString();
                HttpContext.Current.Session["SalesPersonEmail"] = emailAdrress;
            }
            catch (Exception ex)
            {

            }
        }

        private string GetPFCBranchCode(string branchId)
        {
            try
            {
                // Local variable declaration
                string _tableName = "UCOR_CompanyProfile";
                string _columnName = "Code";
                string _whereClause = "Companyid=" + branchId;

                string branch = SqlHelper.ExecuteScalar(umbrellaConnectionString, "[UGEN_SP_Select]",
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause)).ToString();

                // Check whether any value has returned
                if (branch.ToString().Length == 1)
                    return "0" + branch;
                else
                    return branch;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public int GetSQLWarningRowCount()
        {
            int rowCount = (int)SqlHelper.ExecuteScalar(connectionString, "pSOESelect",
                                                  new SqlParameter("@tableName", "SystemMaster"),
                                                  new SqlParameter("@columnNames", "SQLRowWarn"),
                                                  new SqlParameter("@whereClause", "SystemMasterID='0'"));
            return rowCount;
        }
    }
}
