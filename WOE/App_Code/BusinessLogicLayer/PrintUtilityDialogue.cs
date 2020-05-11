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
using PFC.WOE.DataAccessLayer;

namespace PFC.WOE.BusinessLogicLayer
{
    public class PrintUtilityDialogue
    {
        //string reportconnectionstring = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
        string UmbConnectionString = ConfigurationManager.AppSettings["UmbrellaConnectionString"].ToString();
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
      
        public DataTable GetPrinterServer()
        {
            try
            {
                string _tableName = " PrinterList ";
                string _columnName = " distinct PrintServer ";
                string _whereClause = " 1=1 ";
                //DataSet dsPrinterServer = SqlHelper.ExecuteDataset(reportconnectionstring, "UGEN_SP_Select",
                DataSet dsPrinterServer = SqlHelper.ExecuteDataset(ERPConnectionString, "UGEN_SP_Select",
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
                string _columnName = "PrinterPath, PrinterNetworkAddress";
                string _whereClause = "PrintServer = '" + whereCondition + "'";
                //DataSet dsPrinterName = SqlHelper.ExecuteDataset(reportconnectionstring, "UGEN_SP_Select",
                DataSet dsPrinterName = SqlHelper.ExecuteDataset(ERPConnectionString, "UGEN_SP_Select",
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
                string custName = SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
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

                string data = SqlHelper.ExecuteScalar(UmbConnectionString, "UGEN_SP_Insert",
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
                string _tableName = " SecurityUsers ";
                string _columnName = "DefaultPrinter";
                string _whereClause = " UserName='" + UserName + "'";
                string defaultPrinter = (string)SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
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
                
        public void UpdateDefaultPrinter(string columnValues, string whereCondition)
        {
            try
            {
                string _tableName = " SecurityUsers ";
                SqlHelper.ExecuteNonQuery(ERPConnectionString, "pSOEUpdate",
                             new SqlParameter("@tableName", _tableName),
                             new SqlParameter("@columnNames", columnValues),
                             new SqlParameter("@whereClause", whereCondition));
            }
            catch (Exception ex)
            {

            }
        }
    }
}
