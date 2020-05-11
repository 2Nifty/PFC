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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;

namespace PFC.Intranet.InvoiceRegister
{
    /// <summary>
    /// Summary description for InvoiceRegisterRep
    /// </summary>
    public class BookingReport
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string reportConnectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();

        public DataTable GetBookingReportData(string startDate, string endDate,string customerNo,string cSRName,string minMargin,string maxMargin, bool onlyLowMarginLn,string salesBranch)
        {

            try
            {
                // In sp we have between query to get the data for single date we are adding one day to end date.
                //if (startDate == endDate)
               // {
                //    endDate = Convert.ToDateTime(endDate).AddDays(1).ToShortDateString();
                //}
                customerNo = (customerNo == "ALL" ? "" : customerNo);
                cSRName = (cSRName == "ALL" ? "" : cSRName);

                // Code to execute the stored procedure
                DataSet dsData = new DataSet();
                SqlConnection conn = new SqlConnection(ERPConnectionString);
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = "[pBookingReport]";
                Cmd.Parameters.Add(new SqlParameter("@StartDate", startDate));
                Cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));
                Cmd.Parameters.Add(new SqlParameter("@CustomerNo", customerNo));
                Cmd.Parameters.Add(new SqlParameter("@CSR", cSRName));
                Cmd.Parameters.Add(new SqlParameter("@minMargin", Convert.ToDecimal(minMargin)));
                Cmd.Parameters.Add(new SqlParameter("@maxMargin", Convert.ToDecimal(maxMargin)));
                Cmd.Parameters.Add(new SqlParameter("@onlyLowMarginLn", (bool)onlyLowMarginLn));
                Cmd.Parameters.Add(new SqlParameter("@SalesBranch", salesBranch));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsData);
                return dsData.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetCurrentDateValue()
        {
            try
            {
                string whereClause = "DashboardParameter = 'CurrentDay'";
                DataSet dsDate = SqlHelper.ExecuteDataset(reportConnectionString, "UGen_Sp_Select",
                                       new SqlParameter("@tableName", "DashBoardRanges (NOLOCK)"),
                                       new SqlParameter("@columnName", "BegDate,EndDate"),
                                       new SqlParameter("@whereClause", whereClause));

                return dsDate.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetMarginValue()
        {
            try
            {



                string whereClause = "(ApplicationCd = 'SOE') AND (AppOptionType IN ('MinMargin', 'MaxMargin')) order by AppOptionType desc";

                DataSet dsMargin = SqlHelper.ExecuteDataset(ERPConnectionString, "UGen_Sp_Select",
                                       new SqlParameter("@tableName", "AppPref (NOLOCK)"),
                                       new SqlParameter("@columnName", "AppOptionType,AppOptionValue"),
                                       new SqlParameter("@whereClause", whereClause));

                return dsMargin.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable GetBranchLocation()
        {
            try
            {

                string _tableName = "LocMaster (NOLOCK)";
                string _columnName = "LOCID as Code,LOCID + ' - ' + [LocName] as Name";
                string _whereClause = "Loctype in ('BR','DC','B','S') order by  LOCID asc ";

                DataSet dsType = SqlHelper.ExecuteDataset(ERPConnectionString, "UGen_Sp_Select",
                 new SqlParameter("@tableName", _tableName),
                 new SqlParameter("@columnNames", _columnName),
                 new SqlParameter("@whereClause", _whereClause));

                return dsType.Tables[0];
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public void BindListControls(ListControl lstControl, string textField, string valueField, DataTable dtSource, string defaultValue)
        {
            try
            {
                if (dtSource != null && dtSource.Rows.Count > 0)
                {
                    lstControl.DataSource = dtSource;
                    lstControl.DataTextField = textField;
                    lstControl.DataValueField = valueField;
                    lstControl.DataBind();
                    
                    if(defaultValue != "")
                        lstControl.Items.Insert(0, new ListItem(defaultValue, ""));
                }
                else
                {
                    if (lstControl.ID.IndexOf("lst") == -1)
                    {
                        lstControl.Items.Clear();
                        lstControl.Items.Insert(0, new ListItem("N/A", ""));
                    }

                }
            }
            catch (Exception ex) { throw ex; }
        }
    }

}