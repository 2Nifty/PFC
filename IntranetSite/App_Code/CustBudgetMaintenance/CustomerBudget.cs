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
    public class CustomerBudget
    {
        string erpConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        public DataSet GetCustomerBudgetData(string source, string searchFilter)
        {
            try
            {
                DataSet dsData = SqlHelper.ExecuteDataset(erpConnectionString, "pDashboardCustBudgetFrm",
                                  new SqlParameter("@source", source),
                                  new SqlParameter("@searchFilter", searchFilter));

                return dsData;
            }
            catch (Exception ex)
            {
                return null;
            }            
        }

        public DataSet GetCustomerBudgetReport(string branchNo, string repNo, string chainNo, string custNo, string reportType, string sortType, string showOnlyTotal, string showFSNL)
        {
            try
            {
                DataSet dsData = SqlHelper.ExecuteDataset(erpConnectionString, "pDashboardCustBudgetRpt",
                                  new SqlParameter("@branchNo", branchNo),
                                  new SqlParameter("@repNo", repNo),
                                  new SqlParameter("@chainNo", chainNo),
                                  new SqlParameter("@custNo", custNo),
                                  new SqlParameter("@reportType", reportType),
                                  new SqlParameter("@sortType", sortType),
                                  new SqlParameter("@ShowOnlyTotal", showOnlyTotal),
                                  new SqlParameter("@showFastenalCust", showFSNL));

                return dsData;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet ReExtendGrids(string pSalesForeCastId,
                                     string branchId,
                                     string growthPct, 
                                     string lastYearSalForeCastId, 
                                     string fieldType,
                                     string repNo,
                                     string chainNo,
                                     string custNo, 
                                     string summaryType,
                                     string showFSNL)
        {
            try
            {
                DataSet dsData = SqlHelper.ExecuteDataset(erpConnectionString, "[pDashboardCustBudgetReExtLine]",
                                  new SqlParameter("@pSalForeCastId", pSalesForeCastId),
                                  new SqlParameter("@branchId", branchId),
                                  new SqlParameter("@growthPct", growthPct),
                                  new SqlParameter("@LYSalForeCastId", lastYearSalForeCastId),
                                  new SqlParameter("@type", fieldType),
                                  new SqlParameter("@repNo", repNo),
                                  new SqlParameter("@chainNo", chainNo),
                                  new SqlParameter("@custNo", custNo),
                                  new SqlParameter("@summaryType", summaryType),
                                  new SqlParameter("@userName", HttpContext.Current.Session["UserName"].ToString()),
                                  new SqlParameter("@showFastenalCust", showFSNL));

                return dsData;
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

                    if (defaultValue != "")
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


        public DataSet GetFiscalPeriod()
        {
            try
            {
                string _tableName = "FiscalCalendar";
                string _columnName = "FiscalPeriod,FiscalYear";
                string _whereClause = "CurrentDt = '" + DateTime.Now.ToShortDateString() + "'";

                DataSet dsFicalCal = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[UGEN_SP_Select]",
                                                   new SqlParameter("@tableName", _tableName),
                                                   new SqlParameter("@columnNames", _columnName),
                                                   new SqlParameter("@whereCondition", _whereClause));

                return dsFicalCal;
            }
            catch (Exception ex)
            {
                return null;
            }
        }


        #region Next Year Processing

        public DataSet GetNextYearFiscalPeriod()
        {
            try
            {
                string _tableName = "FiscalCalendar";
                string _columnName = "FiscalPeriod,FiscalYear";
                //string _whereClause = "CurrentDt = '" + DateTime.Now.ToShortDateString() + "'";
                string _whereClause = "CurrentDt = '" + DateTime.Now.AddYears(1).ToShortDateString() + "'";

                DataSet dsFicalCal = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[UGEN_SP_Select]",
                                                   new SqlParameter("@tableName", _tableName),
                                                   new SqlParameter("@columnNames", _columnName),
                                                   new SqlParameter("@whereCondition", _whereClause));

                return dsFicalCal;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet GetCustomerNextYearReport(string branchNo, string repNo, string chainNo, string custNo, string reportType, string sortType, string showOnlyTotal, string showFSNL)
        {
            try
            {
                DataSet dsData = SqlHelper.ExecuteDataset(erpConnectionString, "pDashboardCustNextYearBudgetRpt",
                                  new SqlParameter("@branchNo", branchNo),
                                  new SqlParameter("@repNo", repNo),
                                  new SqlParameter("@chainNo", chainNo),
                                  new SqlParameter("@custNo", custNo),
                                  new SqlParameter("@reportType", reportType),
                                  new SqlParameter("@sortType", sortType),
                                  new SqlParameter("@ShowOnlyTotal", showOnlyTotal),
                                  new SqlParameter("@showFastenalCust", showFSNL));

                return dsData;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        public DataSet ReExtendNextYearGrids(string pSalesForeCastId,
                                     string branchId,
                                     string growthPct,
                                     string lastYearSalForeCastId,
                                     string fieldType,
                                     string repNo,
                                     string chainNo,
                                     string custNo,
                                     string summaryType,
                                     string showFSNL)
        {
            try
            {
                DataSet dsData = SqlHelper.ExecuteDataset(erpConnectionString, "pDashboardCustNextYearBudgetReExtLine",
                                  new SqlParameter("@pSalForeCastId", pSalesForeCastId),
                                  new SqlParameter("@branchId", branchId),
                                  new SqlParameter("@growthPct", growthPct),
                                  new SqlParameter("@LYSalForeCastId", lastYearSalForeCastId),
                                  new SqlParameter("@type", fieldType),
                                  new SqlParameter("@repNo", repNo),
                                  new SqlParameter("@chainNo", chainNo),
                                  new SqlParameter("@custNo", custNo),
                                  new SqlParameter("@summaryType", summaryType),
                                  new SqlParameter("@userName", HttpContext.Current.Session["UserName"].ToString()),
                                  new SqlParameter("@showFastenalCust", showFSNL));

                return dsData;
            }
            catch (Exception ex)
            {
                return null;
            }

        }

        public DataSet GetCustomerNextYearData(string source, string searchFilter)
        {
            try
            {
                DataSet dsData = SqlHelper.ExecuteDataset(erpConnectionString, "pDashboardCustNextYearBudgetFrm",
                                  new SqlParameter("@source", source),
                                  new SqlParameter("@searchFilter", searchFilter));

                return dsData;
            }
            catch (Exception ex)
            {
                return null;
            }
        }


        #endregion
    }

}