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

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for InvoiceRegisterRep
    /// </summary>
    public class QuoteMetrics
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
        string reportConnectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
        //string ERPConnectionString = ConfigurationManager.AppSettings["LIVEPFCERPConnectionString"].ToString();
        //string reportConnectionString = ConfigurationManager.AppSettings["LIVEReportsConnectionString"].ToString();
        string customerSortExpression = "";

        public DataSet GetQuoteMetricsData(string startDate, string endDate, string branchID, string salesPerson, string sortExpression)
        {

            try
            {
                customerSortExpression = sortExpression;
                // Code to execute the stored procedure
                DataSet dsData = new DataSet();
                SqlConnection conn = new SqlConnection(ERPConnectionString);
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = "[pQuoteMetricsReport]";
                Cmd.Parameters.Add(new SqlParameter("@StartDate", startDate));
                Cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));
                Cmd.Parameters.Add(new SqlParameter("@SalesLoc", branchID));
                Cmd.Parameters.Add(new SqlParameter("@SalesPerson", salesPerson));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsData);

                DataTable dtResult = AddSalesRepSubTotal(dsData.Tables[0]);
                DataTable dtGrandTotal = dsData.Tables[1];
                dsData.Tables.Clear();
                dsData.Tables.Add(dtResult);
                dsData.Tables.Add(dtGrandTotal);

                return dsData;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataSet GetCSRQuoteMetricsData(string startDate, string endDate, string branchID, string salesPerson, string sortExpression)
        {

            try
            {
                customerSortExpression = sortExpression;
                // Code to execute the stored procedure
                DataSet dsData = new DataSet();
                SqlConnection conn = new SqlConnection(ERPConnectionString);
                SqlDataAdapter adp;
                SqlCommand Cmd = new SqlCommand();
                Cmd.CommandTimeout = 0;
                Cmd.CommandType = CommandType.StoredProcedure;
                Cmd.Connection = conn;
                conn.Open();
                Cmd.CommandText = "[pDashboardQuoteMetricsReport]";
                Cmd.Parameters.Add(new SqlParameter("@StartDate", startDate));
                Cmd.Parameters.Add(new SqlParameter("@EndDate", endDate));
                Cmd.Parameters.Add(new SqlParameter("@SalesLoc", branchID));
                Cmd.Parameters.Add(new SqlParameter("@SalesPerson", salesPerson));
                adp = new SqlDataAdapter(Cmd);
                adp.Fill(dsData);

                DataTable dtResult = AddSalesRepSubTotal(dsData.Tables[0]);
                DataTable dtGrandTotal = dsData.Tables[1];
                dsData.Tables.Clear();
                dsData.Tables.Add(dtResult);
                dsData.Tables.Add(dtGrandTotal);

                return dsData;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private DataTable AddSalesRepSubTotal(DataTable dtQuoteData)
        {
            DataTable dtQuoteDataWithSubTotal = dtQuoteData.Clone();
            DataTable dtGroup = dtQuoteData.DefaultView.ToTable(true, "Name");
            foreach (DataRow dr in dtGroup.Rows)
            {
                string repName = dr["Name"].ToString();
                DataTable dtTemp = new DataTable();
                dtQuoteData.DefaultView.RowFilter = "Name='" + repName + "'";
                dtTemp = dtQuoteData.DefaultView.ToTable();
                if (customerSortExpression != "")
                    dtTemp.DefaultView.Sort = customerSortExpression;

                dtQuoteDataWithSubTotal.Merge(dtTemp.DefaultView.ToTable());
                
                DataRow drTotal = dtQuoteDataWithSubTotal.NewRow();
                drTotal["PFCItemNo"] = "Total";
                drTotal["Name"] = repName + " Total";
                drTotal["Quote"] = dtTemp.Compute("sum(Quote)", "");
                drTotal["MadeOrd"] = dtTemp.Compute("sum(MadeOrd)", "");
                drTotal["LineCnt"] = dtTemp.Compute("sum(LineCnt)", "");
                drTotal["AvlShort"] = dtTemp.Compute("sum(AvlShort)", "");
                drTotal["MadeOrder"] = dtTemp.Compute("sum(MadeOrder)", "");
                dtQuoteDataWithSubTotal.Rows.Add(drTotal);

            }

            return dtQuoteDataWithSubTotal;
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

        public DataTable GetSalesPerson(string branchID)
        {
            try
            {

                string _tableName = "SecurityUsers (NOLOCK)";
                string _columnName = "UserName";
                string _whereClause = "IMLoc='" + branchID + "' order by  UserName asc ";

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
                        lstControl.Items.Insert(0, new ListItem("ALL", ""));
                    }

                }
            }
            catch (Exception ex) { throw ex; }
        }
    }

}