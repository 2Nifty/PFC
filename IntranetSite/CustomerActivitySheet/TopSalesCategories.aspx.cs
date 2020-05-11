#region Namespaces
using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.Securitylayer;
#endregion

namespace PFC.Intranet.CustomerActivity
{
    public partial class TopSalesCategories : System.Web.UI.Page
    {
        #region Variable Declaration
        PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet customerActivitySheet = new PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet();
        DataTable dtCategories = new DataTable();
        DataSet dsCategories = new DataSet();

        private string customerNumber = string.Empty;
        private string curYear = string.Empty;
        private string curMonth = string.Empty;
        private string branch = string.Empty;
        private string branchName = string.Empty;
        private string strMonthName = string.Empty;
        #endregion

        #region Event Handler
        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {

            if (Request.QueryString["PrintMode"] == null)
            {
                SystemCheck systemCheck = new SystemCheck();
                systemCheck.SessionCheck();
            }
            if (!IsPostBack)
            {
                string strWhere = "CustNo='" + Request.QueryString["CustNo"].ToString()+"'";
                DataTable dtCustName = customerActivitySheet.GetCustomerActivityDetail(strWhere, "CustName", "CAS_CustomerData");
                if (dtCustName != null && dtCustName.Rows.Count > 0)
                    lblCustName.Text = dtCustName.Rows[0]["CustName"].ToString();
            }

            #region Getting QueryString
            curYear = Request.QueryString["Year"].ToString();
            curMonth = Request.QueryString["Month"].ToString();
            branch = Request.QueryString["Branch"].ToString().Trim() == "0" ? "" : Request.QueryString["Branch"].ToString();
            branchName = Request.QueryString["BranchName"].ToString();
            strMonthName = Request.QueryString["MonthName"].ToString();

            if (Request.QueryString["CASMode"] == null)
                customerNumber = Request.QueryString["CustNo"].ToString().Replace("||", "&");
            else
                customerNumber = Request.QueryString["Chain"].ToString().Replace("||", "&");
            #endregion

            #region Grid Binding Event
            //Method used to bind valus in datagrid
            BindDataGrid();
            #endregion

            #region Customer Type
            if (!IsPostBack)
            {
                if (Session["CustomerType"] != null)
                {
                    rbtnlCustType.Items[0].Selected = (Session["CustomerType"].ToString() == "PFC Employee") ? false : true;
                    rbtnlCustType.Items[1].Selected = (Session["CustomerType"].ToString() == "PFC Employee") ? true : false;
                    rbtnlCustType_SelectedIndexChanged(rbtnlCustType, new EventArgs());
                }
                else
                {
                    rbtnlCustType.Items[0].Selected = (Request.QueryString["CustomerType"].ToString() == "PFC Employee") ? false : true;
                    rbtnlCustType.Items[1].Selected = (Request.QueryString["CustomerType"].ToString() == "PFC Employee") ? true : false;
                    rbtnlCustType_SelectedIndexChanged(rbtnlCustType, new EventArgs());
                }
            }
            #endregion
        }

        /// <summary>
        /// rbtnlCustType_SelectedIndexChanged :used to bind values based in the condition
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void rbtnlCustType_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (rbtnlCustType.Items[0].Selected)
            {
                dgSalesDetails.Columns[2].Visible = false;
                dgSalesDetails.Columns[4].Visible = false;                
                dgSalesDetails.Columns[5].Visible = false;
                dgSalesDetails.Columns[7].Visible = false;
                dgSalesDetails.Columns[9].Visible = false;
                Session["CustomerType"] = "";
            }
            else
            {
                dgSalesDetails.Columns[2].Visible = true;
                dgSalesDetails.Columns[4].Visible = true;
                dgSalesDetails.Columns[5].Visible = true;
                dgSalesDetails.Columns[7].Visible = true;
                dgSalesDetails.Columns[9].Visible = true;
                Session["CustomerType"] = "PFC Employee";
            }
        }
        /// <summary>
        /// dgSalesDetails_ItemDataBound:Used to bind datagrid
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void dgSalesDetails_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                if (e.Item.Cells[0].Text == "TOTALS")
                {
                    e.Item.CssClass = "GridHead";
                    for (int i = 0; i <= 9; i++)
                    {
                        e.Item.Cells[i].HorizontalAlign = (i == 0) ? HorizontalAlign.Left : HorizontalAlign.Right;
                        e.Item.Cells[i].CssClass = "CASGridPadding GridItem";
                        e.Item.Cells[i].BackColor = System.Drawing.Color.FromName("#dff3f9");
                        e.Item.Cells[8].Text = "&nbsp;";
                    }
                }
            }
        }
        #endregion

        #region Developer Code
        /// <summary>
        /// Method used to bind valus in datagrid
        /// </summary>
        private void BindDataGrid()
        {
            try
            {

                dsCategories = customerActivitySheet.GetCategorySalesData(curMonth, curYear, branch.Trim(), customerNumber);
                if (dsCategories != null)
                {
                    if (dsCategories.Tables[0].Rows.Count > 0)
                    {
                        dgSalesDetails.DataSource = dsCategories.Tables[0];
                        dgSalesDetails.DataBind();
                        lblStatus.Visible = false;
                        //Method used to bind valus in Chart
                        BindDataChart();
                    }
                    else
                    {
                        dgSalesDetails.Visible = false;
                        lblStatus.Visible = true;
                    }
                }
                else
                {
                    dgSalesDetails.Visible = false;
                    lblStatus.Text = "No Record Found";
                    lblStatus.Visible = true;
                }


            }
            catch (Exception ex)
            {
                throw;
            }
        }
        /// <summary>
        /// Method used to bind valus in Chart
        /// </summary>
        private void BindDataChart()
        {
            string[] sColumn ={ "CatGrpDesc", "MTDSales" };
            string[] sColumns ={ "CatGrpDesc", "MTDLbs" };
            BindChart(chTopCategorieSales, dsCategories.Tables[1], sColumn, false);
            BindChart(chTopCategoriePounds, dsCategories.Tables[2], sColumns, true);
        }
        /// <summary>
        /// BindChart : Method used to bind valus in Chart
        /// </summary>
        /// <param name="chartModule">dotnetCHARTING.Chart</param>
        /// <param name="dtTable">datasource DataTable</param>
        /// <param name="strColumn">Filter Column </param>
        private void BindChart(dotnetCHARTING.Chart chartModule, DataTable dtTable, string[] strColumn, bool isexplode)
        {
            dotnetCHARTING.ChartType myChartType;

            dotnetCHARTING.Scale myAxisScale = (dotnetCHARTING.Scale)Enum.Parse(typeof(dotnetCHARTING.Scale), "Normal", true);
            dotnetCHARTING.SeriesType mySeriesType = (dotnetCHARTING.SeriesType)Enum.Parse(typeof(dotnetCHARTING.SeriesType), "Column", true);
            dotnetCHARTING.PieLabelMode myPieLabelMode = dotnetCHARTING.PieLabelMode.Outside;
            dotnetCHARTING.LegendBoxPosition myLegendBoxPosition = dotnetCHARTING.LegendBoxPosition.None;

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
            chartModule.DefaultSeries.LimitMode = (dotnetCHARTING.LimitMode)Enum.Parse(typeof(dotnetCHARTING.LimitMode), "Top", true);
            chartModule.DefaultSeries.DefaultElement.ShowValue = true;
            chartModule.DefaultAxis.NumberPercision = 0;

            chartModule.Mentor = false;
            chartModule.TempDirectory = "temp";
            chartModule.Visible = true;
            chartModule.Type = myChartType;
            chartModule.Height = 220;
            chartModule.Width = 600;
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
            chartModule.PieLabelMode = myPieLabelMode;
            chartModule.Series.Name = "";
            chartModule.AutoNameLabels = true;
            chartModule.Title = "";
            chartModule.Series.Data = dtTable.DefaultView.ToTable(false, strColumn);
            chartModule.SeriesCollection.Add();
            chartModule.PrinterOptimizedText = true;
            chartModule.ChartArea.ClearColors();
            chartModule.DefaultSeries.DefaultElement.ExplodeSlice = isexplode;
            chartModule.DefaultSeries.DefaultElement.Transparency = 10;

            chartModule.DefaultSeries.DefaultElement.ShowValue = true;
            if (isexplode)
            {
                chartModule.DefaultSeries.DefaultElement.SmartLabel.Text = "%Name \n %YValue ";
                chartModule.YAxis.NumberPrecision = 0;
            }
            else
            {
                chartModule.DefaultSeries.DefaultElement.SmartLabel.Text = "%Name \n %YValue %";
                chartModule.YAxis.NumberPrecision = 1;
            }

        }
        #endregion

    } //End Class

} //End Namespace
