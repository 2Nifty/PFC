using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Data.SqlClient;

using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;

namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for FiscalCalendar
    /// </summary>
    public class FiscalCalendar
    {
        // Local variable
        int _currentWorkDay = 0;
        int _MoTotWorkDay = 0;
        int _curMonth = 0;
        int _curYear = 0;
        string _lastBusiness = string.Empty;

        public int CurrentWorkDay
        {
            get
            {
                return _currentWorkDay;
            }
        }
        public int MonthTotalWorkDay
        {
            get
            {
                return _MoTotWorkDay;
            }
        }
        public int CurrentMonth
        {
            get
            {
                return _curMonth;
            }
        }
        public int CurrentYear
        {
            get
            {
                return _curYear;
            }
        }
        public string LastBusinessDay
        {
            get
            {
                return _lastBusiness;
            }
        }

        public FiscalCalendar(string currentMonth, string currentYear)
        {
            //
            // Get total work days in the current month
            //
            _MoTotWorkDay = GetMonthTotalWorkDays(currentMonth, currentYear);

            //
            // Get total workdays completed in current fiscal month
            //
            _currentWorkDay = GetTotalWorkDays(currentMonth, currentYear);

            //
            // Get Current month & year value
            //
            GetCurrentMonth();

            //
            // Get last working date value
            //
            GetLastBusinessDay();

        }

        public FiscalCalendar()
        {
            //
            // Get Current month & year value
            //
            GetCurrentMonth();
        }

        private int GetMonthTotalWorkDays(string currentMonth, string currentYear)
        {
            try
            {
                string _tableName = "FiscalCalendar";
                string _columnName = "count(*)";
                string _whereClause = "FiscalCalMonth=" + currentMonth + " and FiscalCalYear=" + currentYear + " and WorkDay=1";

                string totWorkDays = SqlHelper.ExecuteScalar(Global.ReportsConnectionString, "[UGEN_SP_Select]",
                                                   new SqlParameter("@tableName", _tableName),
                                                   new SqlParameter("@columnNames", _columnName),
                                                   new SqlParameter("@whereCondition", _whereClause)).ToString();
                return Convert.ToInt32(totWorkDays);
            }
            catch (Exception ex)
            {
                return 0;
            }
        }

        private int GetTotalWorkDays(string currentMonth, string currentYear)
        {
            try
            {
                string _tableName = "FiscalCalendar";
                string _columnName = "count(*)";
                string _whereClause = "FiscalCalMonth=" + currentMonth + " and FiscalCalYear=" + currentYear + " and CurrentDt<'" + DateTime.Now.ToShortDateString() + "' and WorkDay=1";

                string dayofMonth = SqlHelper.ExecuteScalar(Global.ReportsConnectionString, "[UGEN_SP_Select]",
                                                   new SqlParameter("@tableName", _tableName),
                                                   new SqlParameter("@columnNames", _columnName),
                                                   new SqlParameter("@whereCondition", _whereClause)).ToString();
                return Convert.ToInt32(dayofMonth);
            }
            catch (Exception ex)
            {
                return 0;
            }
        }

        private void GetCurrentMonth()
        {
            try
            {
                string _tableName = "DashboardRanges";
                string _columnName = "MonthValue,YearValue";
                string _whereClause = "DashboardParameter='LastMonth'";

                DataSet dsDashboardRange = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[UGEN_SP_Select]",
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));
                if (dsDashboardRange != null && dsDashboardRange.Tables[0].Rows.Count > 0)
                {
                    _curMonth = Convert.ToInt32(dsDashboardRange.Tables[0].Rows[0]["MonthValue"].ToString());
                    _curYear = Convert.ToInt32(dsDashboardRange.Tables[0].Rows[0]["YearValue"].ToString());
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private void GetLastBusinessDay()
        {
            try
            {
                string _tableName = "DashboardRanges";
                string _columnName = "EndDate";
                string _whereClause = "DashboardParameter='CurrentDay'";

                DataSet dsDashboardRange = SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[UGEN_SP_Select]",
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));
                if (dsDashboardRange != null && dsDashboardRange.Tables[0].Rows.Count > 0)
                {
                    _lastBusiness = dsDashboardRange.Tables[0].Rows[0]["EndDate"].ToString();                    
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}