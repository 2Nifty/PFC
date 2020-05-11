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
    public class InvoiceRegisterReportTesting
    {
        string reportConnectionString = ConfigurationManager.ConnectionStrings["PFCReportsConnectionString"].ToString();
        //string reportConnectionString = "workstation id=PFCSQLP;packet size=4096;user id=pfcnormal;data source=PFCSQLP;persist security info=True;initial catalog=pfcreports;password=pfcnormal";
        //string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        public DataTable GetInvoiceData(string startDate, string endDate,string customerNo,string cSRName)
        {

            try
            {
                // Code to execute the stored procedure
                DataSet dsData = new DataSet();
                SqlConnection conn = new SqlConnection(reportConnectionString);
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = "[pInvoiceRegisterCSRFilter]";
                Cmd.Parameters.Add(new SqlParameter("@StartDate", startDate));
                Cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));
                Cmd.Parameters.Add(new SqlParameter("@CustomerNo", customerNo));
                Cmd.Parameters.Add(new SqlParameter("@CSR", cSRName));
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
                                       new SqlParameter("@tableName", "DashBoardRanges"),
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

                DataSet dsMargin = SqlHelper.ExecuteDataset(reportConnectionString, "UGen_Sp_Select",
                                       new SqlParameter("@tableName", "AppPref"),
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

                string _tableName = "LocMaster";
                string _columnName = "LOCID as Code,LOCID + ' - ' + [LocName] as Name";
                string _whereClause = "Loctype in ('BR','DC') order by  LOCID asc ";

                DataSet dsType = SqlHelper.ExecuteDataset(reportConnectionString, "UGen_Sp_Select",
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