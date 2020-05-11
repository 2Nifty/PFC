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
using PFC.Intranet.DataAccessLayer;

namespace PFC.SOE.BusinessLogicLayer
{
    public class PrintUtilityDialogue
    {
        string soeConnectionString = ConfigurationManager.AppSettings["UmbrellaConnectionString"].ToString();
        string erpConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        //string erpDBConnectionString = ConfigurationManager.AppSettings["PFCERPDBConnectionString"].ToString();
        //string reportconnectionstring = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();

        public DataTable GetPrinterServer()
        {
            try
            {
                string _tableName = " PrinterList ";
                string _columnName = " distinct PrintServer ";
                string _whereClause = " 1=1 ";
                DataSet dsPrinterServer = SqlHelper.ExecuteDataset(erpConnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsPrinterServer.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetLocations()
        {
            try
            {
                string _tableName = " LocMaster ";
                string _columnName = " LocId,LocID + ' - ' + LocName as Name";
                string _whereClause = " LocType='B' ";
                DataSet dsPrinterServer = SqlHelper.ExecuteDataset(erpConnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsPrinterServer.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataTable GetPrinterName(string whereCondition)
        {
            try
            {
                string _tableName = " PrinterList ";
                string _columnName = "PrinterPath,PrinterNetworkAddress";
                string _whereClause = "PrinterLocId = '" + whereCondition + "'";

                if (whereCondition == "")
                    _whereClause = " 1=1 ";

                DataSet dsPrinterName = SqlHelper.ExecuteDataset(erpConnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                return dsPrinterName.Tables[0];
            }
            catch (Exception exe)
            {

                return null;
            }
        }

        public string GetCustomerName(string customerNumer)
        {
            try
            {
                string _tableName = " CustomerMaster ";
                string _columnName = " CustName ";
                string _whereClause = " CustNo=" + customerNumer + "";
                string custName = SqlHelper.ExecuteScalar(erpConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause)).ToString();
                return custName;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public string GetData(string columnName, string columnvalues)
        {
            try
            {
                string _tableName = "RequestQueue";

                string data = SqlHelper.ExecuteScalar(soeConnectionString, "UGEN_SP_Insert",
                                   new SqlParameter("@tableName", _tableName),
                                   new SqlParameter("@columnNames", columnName),
                                    new SqlParameter("@columnvalues", columnvalues)).ToString();

                return data;

            }
            catch (Exception ex)
            {

                return null;
            }
        }

        public string GetDefaultPrinter(string UserName)
        {
            try
            {
                string _tableName = " UserMaster ";
                string _columnName = "DefaultPrinter";
                string _whereClause = " UserName='" + UserName + "' order by pUserMasterID desc";
                string defaultPrinter = (string)SqlHelper.ExecuteScalar(erpConnectionString, "pSOESelect",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause));
                if(defaultPrinter != null && defaultPrinter.Trim() != "")
                    return defaultPrinter;

                return "";
            }
            catch (Exception ex)
            {
                return "";
            }
        }

        public void InsertDefaultPrinter(string columnValues)
        {
            try
            {
                string _tableName = " UserMaster ";
                string _columnName = "UserName,DefaultPrinter";
              
                SqlHelper.ExecuteScalar(erpConnectionString, "pSOEInsert",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@ColumnValues", columnValues));
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void UpdateDefaultPrinter(string columnValues, string whereCondition)
        {
            try
            {
                string _tableName = " UserMaster ";
                SqlHelper.ExecuteNonQuery(erpConnectionString, "pSOEUpdate",
                             new SqlParameter("@tableName", _tableName),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {

            }
        }

        public void PostRequestQueue(string Printer, string Form, string URL, string Orientation, string Type, string CreatedBy, string DocNo)
        {
            string strSQL = "INSERT INTO RequestQueue " +
                            "(PrinterNetworkAddress, FormName, PageURL, PageSetup, QueueType, Status, CreatedBy, CreatedDate, DocNo) " +
                            "VALUES ('" + Printer + "','" + Form + "','" + URL + "','" + Orientation + "','" + Type + "','False','" + CreatedBy + "','" + DateTime.Now.ToString() + "','" + DocNo + "')";
            SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["UmbrellaConnectionString"].ToString(), CommandType.Text, strSQL);

        }
    }
}
