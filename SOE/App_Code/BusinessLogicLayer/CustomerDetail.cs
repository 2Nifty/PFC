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
    /// Summary description for CustomerDetail
    /// </summary>
    public class CustomerDetail
    {
        // Create instance for the webservice
        OrderEntry service = new OrderEntry();
        public string CustomerNumber
        {
            get
            {
                return _customerNo;
            }
        }
        private string _customerNo = "";
        private string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        /// <summary>
        /// function to get the customer shipping details
        /// </summary>
        /// <param name="custNo"></param>
        /// <returns></returns>
        public DataSet GetLocationDetails()
        {
            try
            {
                string tableName = "[LocMaster]";
                string columnName = "LocID as 'Code',LocID + ' - ' + [LocName] as Name";
                string whereCondition = "MaintainIMQtyInd='Y'";
                //string whereCondition = " UsageLocInd='A' OR UsageLocInd='I' Order by LocID Asc";

                // Call the webservice to get the shipping detail
                DataSet dsLocation = service.ExecuteERPSelectQuery(tableName, columnName, whereCondition);

                if (dsLocation != null && dsLocation.Tables[0].Rows.Count > 0)
                    return dsLocation;
                else
                    return null;
            }
            catch (Exception ex) { return null; }
        }
        public DataSet GetUsageLoc()
        {
            try
            {
                string tableName = "[LocMaster]";
                string columnName = "LocID as 'Code',LocID + ' - ' + [LocName] as Name";
                string whereCondition = " UsageLocInd='A' OR UsageLocInd='I' Order by LocID Asc";

                // Call the webservice to get the shipping detail
                DataSet dsLocation = service.ExecuteERPSelectQuery(tableName, columnName, whereCondition);

                if (dsLocation != null && dsLocation.Tables[0].Rows.Count > 0)
                    return dsLocation;
                else
                    return null;
            }
            catch (Exception ex) { return null; }
        }
        /// <summary>
        /// function to get the customer shipping details
        /// </summary>
        /// <param name="custNo"></param>
        /// <returns></returns>
        public DataSet GetMasterDetails(string tableName, string columnName, string condition)
        {
            try
            {

                // Call the webservice to get the Customer detail
                DataSet dsMasterDetails = service.ExecuteERPSelectQuery(tableName, columnName, condition);

                if (dsMasterDetails != null && dsMasterDetails.Tables[0].Rows.Count > 0)
                    return dsMasterDetails;
                else
                    return null;
            }
            catch (Exception ex) { return null; }
        }
        /// <summary>
        /// function to get the customer shipping details
        /// </summary>
        /// <param name="custNo"></param>
        /// <returns></returns>
        public DataSet GetListDetails(string tableName, string columnName, string condition)
        {
            try
            {

                // Call the webservice to get the Customer detail
                DataSet dsMasterDetails = service.ExecuteListSelectQuery(tableName, columnName, condition);

                if (dsMasterDetails != null && dsMasterDetails.Tables[0].Rows.Count > 0)
                    return dsMasterDetails;
                else
                    return null;
            }
            catch (Exception ex) { return null; }
        }
        /// <summary>
        /// Public Method user to get User security code
        /// </summary>
        /// <param name="userName">Parameter:username</param>
        /// <returns>User security code</returns>
        public string GetValues(string tableName, string columnName, string whereClause)
        {
            try
            {
                object objCode = (object)SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                    new SqlParameter("@tableName", tableName),
                    new SqlParameter("@columnNames", columnName),
                    new SqlParameter("@whereClause", whereClause));

                if (objCode != null)
                    return objCode.ToString().Trim();
                else
                    return "";

            }
            catch (Exception Ex) { return ""; }
        }
        public void UpdateHeader(string tableName, string values, string whereClause)
        {
            try
            {
                service.UpdateQuote(tableName, values, whereClause);
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        /// <summary>
        /// Method to validate customer number
        /// </summary>
        /// <param name="customerNumber"></param>
        /// <returns></returns>
        public bool IsValidCustomer(string customerNumber)
        {
            if (!String.IsNullOrEmpty(customerNumber))
            {
                string _tableName = " CustomerMaster ";
                string _columnName = "CustNo";
                string _whereClause = "CustNo='" + customerNumber + "'";

                if (!Utility.IsNumeric(customerNumber))
                    _whereClause = "CustSearchKey='" + customerNumber + "'";

                object _result = SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));

                if (_result == null)
                    return false;

                _customerNo = _result.ToString();
                return true;
            }

            return false;
        }

        public string GetLocationName(string locNo)
        {
            String locName = (string)SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                                                  new SqlParameter("@tableName", "LocMaster"),
                                                  new SqlParameter("@columnNames", "LocName"),
                                                  new SqlParameter("@whereClause", "LocID='" + locNo + "'"));
            return locName;
        }
        public int GetSQLWarningRowCount()
        {
            int locName = (int)SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                                                  new SqlParameter("@tableName", "SystemMaster"),
                                                  new SqlParameter("@columnNames", "SQLRowWarn"),
                                                  new SqlParameter("@whereClause", "SystemMasterID='0'"));
            return locName;
        }

        public string GetCarrierName(string CarCd)
        {
            String carName = (string)SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                                                  new SqlParameter("@tableName", "CarrierMaster"),
                                                  new SqlParameter("@columnNames", "CarrierDesc"),
                                                  new SqlParameter("@whereClause", "Code='" + CarCd + "'"));
            return carName;
        }
        public string GetListName(string listvalue, string listmasName)
        {
            String carName = (string)SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                                                  new SqlParameter("@tableName", "listmaster,listdetail"),
                                                  new SqlParameter("@columnNames", "ListDtlDesc"),
                                                  new SqlParameter("@whereClause", "listmaster.pListMasterID =listdetail.fListMasterID and listmaster.ListName='" + listmasName + "' and listdetail.ListValue='" + listvalue + "'"));
            return carName;
        }
        public string GetSubType(string listvalue, string listmasName)
        {
            String carName = (string)SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                                                  new SqlParameter("@tableName", "listmaster,listdetail"),
                                                  new SqlParameter("@columnNames", "convert(varchar(10),SequenceNo) as SequenceNo"),
                                                  new SqlParameter("@whereClause", "listmaster.pListMasterID =listdetail.fListMasterID and listmaster.ListName='" + listmasName + "' and listdetail.ListValue='" + listvalue + "'"));
            return carName;
        }
        public DataTable GetCarrierList()
        {
            try
            {
                DataSet dsCarrier = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOESelect",
                                                         new SqlParameter("@tableName", "[Tables]"),
                                                         new SqlParameter("@columnNames", "TableCd as Code,TableCd+' - '+ShortDsc as Name"),
                                                         new SqlParameter("@whereClause", "TableType='CAR' and SOApp='Y' order by TableCd"));
                if (dsCarrier == null)
                    return null;
                else
                    return dsCarrier.Tables[0];
            }
            catch (Exception)
            {
                return null;
                throw;
            }
        }
        public DataTable GetFreightList()
        {
            try
            {
                DataSet dsFreight = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOESelect",
                                                         new SqlParameter("@tableName", "[Tables]"),
                                                         new SqlParameter("@columnNames", "TableCd as Code,TableCd+' - '+ShortDsc as Name"),
                                                         new SqlParameter("@whereClause", "TableType='FGHT' and SOApp='Y' order by TableCd"));
                if (dsFreight == null)
                    return null;
                else
                    return dsFreight.Tables[0];
            }
            catch (Exception)
            {
                return null;
                throw;
            }
        }
        public string GetTablesName(string listvalue, string masName)
        {
            string carName = (string)SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                                                  new SqlParameter("@tableName", "Tables"),
                                                  new SqlParameter("@columnNames", "ShortDsc"),
                                                  new SqlParameter("@whereClause", "TableType='" + masName + "' and TableCd='" + listvalue + "'  and SOApp='Y'"));
            if (carName == null)
                return "";
            else
                return carName;
        }

        public string GetTablesFullDesc(string listvalue, string masName)
        {
            string carName = (string)SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                                                  new SqlParameter("@tableName", "Tables"),
                                                  new SqlParameter("@columnNames", "Dsc"),
                                                  new SqlParameter("@whereClause", "TableType='" + masName + "' and TableCd='" + listvalue + "'  and SOApp='Y'"));
            if (carName == null)
                return "";
            else
                return carName;
        }
        public DataTable GetTermDescription(string listvalue, string masName)
        {
            try
            {
                DataSet dsTerm = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOESelect",
                                                         new SqlParameter("@tableName", "Tables"),
                                                         new SqlParameter("@columnNames", "Dsc,ColorCd"),
                                                         new SqlParameter("@whereClause", "TableType='" + masName + "' and TableCd='" + listvalue + "'  and SOApp='Y'"));
                if (dsTerm != null && dsTerm.Tables[0].Rows.Count > 0)
                    return dsTerm.Tables[0];
                else
                    return null;
            }
            catch (Exception)
            {
                return null;
                throw;
            }
        }
        public string GetSortDocInd(string custNo)
        {
            try
            {
                string sODocSortInd = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                                                         new SqlParameter("@tableName", "CustomerMaster"),
                                                         new SqlParameter("@columnNames", "SODocSortInd"),
                                                         new SqlParameter("@whereClause", "Custno='" + custNo + "'")).ToString();
                return sODocSortInd;
            }
            catch (Exception)
            {
                return "";
                throw;
            }
        }
    }
}