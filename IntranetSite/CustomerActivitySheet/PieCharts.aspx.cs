#region namespaces
using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Data.SqlClient;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
#endregion

namespace PFC.Intranet.CustomerActivity
{
    public partial class PieCharts : System.Web.UI.Page
    {
        #region variable Declaration
        PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet customerActivitySheet = new PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet();
        //public string cName = string.Empty;
        public string strWhere = string.Empty;
        #endregion

        #region Page Load Event Handler
        /// <summary>
        /// Protected Page Load Method
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">EventArgs</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            
            if (Request.QueryString["PrintMode"] == null)
            {
                SystemCheck systemCheck = new SystemCheck();
                systemCheck.SessionCheck();
            }
            try
            {
                //if (Session["CustomerName"] == null)
                //    cName = Request.QueryString["CustName"] != null ? Request.QueryString["CustName"].ToString().Replace("|||","'") : "";
                //else
                //    cName = Session["CustomerName"].ToString();

                if (!IsPostBack)
                {
                    string strWhere = "CustNo='" + Request.QueryString["CustNo"].ToString() + "'";
                    DataTable dtCustName = customerActivitySheet.GetCustomerActivityDetail(strWhere, "CustName", "CAS_CustomerData");
                    if (dtCustName != null && dtCustName.Rows.Count > 0)
                        lblCustName.Text = dtCustName.Rows[0]["CustName"].ToString();
                }

                // Method used to Build Where Clause
                GetWhereClause();

                // Method used to bind Order Type Chart
                BindOrderTypeChart();

                // Method used to Bind Package Chart
                BindPkageChart();
            }
            catch (Exception ex)
            {
                Response.Write(ex.Message.ToString());
            }
        }
        #endregion

        #region Developer Code
        /// <summary>
        /// Private Method used to bind Order Type Chart
        /// </summary>
        private void BindOrderTypeChart()
        {
            try
            {

                BindChart(chOrderTypeSales, "select (case OrderType when '' then 'Other' else OrderType end) as OrderType,cast(isnull(round(MTDSales,2),0) as Decimal(25,2)) as MTDSales from dbo.CAS_PieChartOrderType where " + strWhere, "Sales by OrderType", "$");

                BindChart(chOrderTypePounds, "select (case OrderType when '' then 'Other' else OrderType end) as OrderType,cast(isnull(round(MTDLbs,2),0) as Decimal(25,2)) as MTDLbs from dbo.CAS_PieChartOrderType where " + strWhere, "Pounds by OrderType", "");

                BindChart(chOrderTypeGM, "select (case OrderType when '' then 'Other' else OrderType end) as OrderType,cast(isnull(round(MTDGMPct,2),0) as Decimal(25,2)) as MTDGMPct from dbo.CAS_PieChartOrderType where " + strWhere, "GM% by OrderType", "%");

            }
            catch (Exception ex)
            {
                Response.Write(ex.Message.ToString());
            }

        }
        /// <summary>
        /// GetWhereClause :Method used to build WhereClause
        /// </summary>
        /// <returns></returns>
        private void GetWhereClause()
        {
            if (Request.QueryString["CASMode"] == null)
            {
                strWhere = "CustNo='" + Request.QueryString["CustNo"].Trim().Replace("||", "&")
                             + "' and BranchNo is not null "
                             + " and CurYear='" + Request.QueryString["Year"].Trim()
                             + "'and CurMonth='" + Request.QueryString["Month"].Trim() + "'";
            }
            else
            {
                strWhere = "CustNo='" + Request.QueryString["Chain"].Trim().Replace("||", "&")
                             + "' and BranchNo is null "
                             + " and CurYear='" + Request.QueryString["Year"].Trim()
                             + "' and CurMonth='" + Request.QueryString["Month"].Trim() + "'";
            }
        }
        /// <summary>
        /// Private Method used to Bind Package Chart
        /// </summary>
        private void BindPkageChart()
        {
            try
            {
                BindChart(chpkgSales, "select (case PkgGroup when '' then 'Other' else PkgGroup end) as PkgGroup,cast(isnull(round(MTDSales,2),0) as Decimal(25,2)) as MTDSales from dbo.CAS_PieChartPkgGrp where " + strWhere, "Sales by PKG Group", "$");

                BindChart(chpkgPounds, "select (case PkgGroup when '' then 'Other' else PkgGroup end) as PkgGroup,cast(isnull(round(MTDLbs,2),0) as Decimal(25,2)) as MTDLbs from dbo.CAS_PieChartPkgGrp where " + strWhere, "Pounds by PKG Group", "");

                BindChart(chpkgGM, "select (case PkgGroup when '' then 'Other' else PkgGroup end) as PkgGroup,cast(isnull(round(MTDGMPct,2),0) as Decimal(25,2)) as MTDGMPct from dbo.CAS_PieChartPkgGrp where " + strWhere, "GM% by PKG Group", "%");

            }
            catch (Exception ex)
            {
                Response.Write(ex.Message.ToString());
            }
        }
        /// <summary>
        /// BindChart :Private method used to bind chart based on the parameter
        /// </summary>
        /// <param name="chartModule">dotnetCHARTING.Chart</param>
        /// <param name="query">String Sql Query</param>
        /// <param name="title">title</param>
        /// <param name="format">format</param>
        private void BindChart(dotnetCHARTING.Chart chartModule, string query, string title, string format)
        {
            dotnetCHARTING.ChartType myChartType;
            string strFormat = "%YValue";
            //dotnetCHARTING.ChartType myChartType = (dotnetCHARTING.ChartType)Enum.Parse(typeof(dotnetCHARTING.ChartType), Session["ChartType"].ToString(), true);
            dotnetCHARTING.Scale myAxisScale = (dotnetCHARTING.Scale)Enum.Parse(typeof(dotnetCHARTING.Scale), "Range", true);
            dotnetCHARTING.SeriesType mySeriesType = (dotnetCHARTING.SeriesType)Enum.Parse(typeof(dotnetCHARTING.SeriesType), "Column", true);
            dotnetCHARTING.LegendBoxPosition myLegendBoxPosition = dotnetCHARTING.LegendBoxPosition.BottomMiddle;

            if (Request.QueryString["ChartPalette"] == null && Request.QueryString["ChartType"] == null)
            {
                chartModule.PaletteName = customerActivitySheet.GetPaletteName(Session["ChartPalette"].ToString());
                myChartType = (dotnetCHARTING.ChartType)Enum.Parse(typeof(dotnetCHARTING.ChartType), Session["ChartType"].ToString(), true);
            }
            else
            {
                chartModule.PaletteName = customerActivitySheet.GetPaletteName(Request.QueryString["ChartPalette"].ToString());
                myChartType = (dotnetCHARTING.ChartType)Enum.Parse(typeof(dotnetCHARTING.ChartType), Request.QueryString["ChartType"].ToString(), true);
            }
            //General settings
            chartModule.DefaultSeries.ConnectionString = Global.ReportsConnectionString.ToString();
            chartModule.DefaultSeries.LimitMode = (dotnetCHARTING.LimitMode)Enum.Parse(typeof(dotnetCHARTING.LimitMode), "Top", true);
            chartModule.DefaultSeries.DefaultElement.ShowValue = true;
            chartModule.DefaultAxis.NumberPercision = 0;

            chartModule.Mentor = false;
            chartModule.TempDirectory = "temp";
            chartModule.Visible = true;
            chartModule.Type = myChartType;
            chartModule.Height = 210;
            chartModule.Width = 300;
            chartModule.UseFile = true;
            chartModule.Debug = false;
            chartModule.DonutHoleSize = 50;
            chartModule.LegendBox.Template = "%icon%name";
            chartModule.LegendBox.Position = myLegendBoxPosition;
            chartModule.Use3D = true;
            chartModule.Transpose = true;
            chartModule.DefaultSeries.ShowOther = true;
            chartModule.DefaultSeries.Type = mySeriesType;
            chartModule.DefaultAxis.Scale = myAxisScale;
            chartModule.Series.Name = "";
            chartModule.AutoNameLabels = true;
            chartModule.Title = "";
            chartModule.Series.SqlStatement = query;
            chartModule.SeriesCollection.Add();
            chartModule.PrinterOptimizedText = true;
            chartModule.ChartArea.ClearColors();
            chartModule.DefaultSeries.DefaultElement.ShowValue = true;
            if (format == "$")
            {
                strFormat = "$ %YValue";
                chartModule.YAxis.NumberPrecision = 0;
            }
            else if (format == "%")
            {
                strFormat = "%YValue %";
                chartModule.YAxis.NumberPrecision = 1;
            }
            else
                chartModule.YAxis.NumberPrecision = 0;

            chartModule.DefaultSeries.DefaultElement.SmartLabel.Text = strFormat;
            chartModule.PieLabelMode = dotnetCHARTING.PieLabelMode.Inside;
            chartModule.DefaultSeries.DefaultElement.Transparency = 10;

        }
        #endregion

    }// End Class

}// End Namespace