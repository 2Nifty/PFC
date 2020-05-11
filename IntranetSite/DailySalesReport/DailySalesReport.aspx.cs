#region Header
using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.IO;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.Securitylayer; 
#endregion

namespace PFC.Intranet.DailySalesReports
{
    public partial class _DailySalesReport : System.Web.UI.Page
    {
        #region Page Local variables

        SalesReportUtils salesReportUtils = new SalesReportUtils();
        DailySalesReport dailySalesReport = new DailySalesReport();

        private string sortExpression = string.Empty;
        private int pagesize = 18;
        private DataTable dtTotal;
        DataTable dtSalesAnalysis = new DataTable(); 
        string noneBranchID="900";
        bool status = false;
        #endregion

        #region Page load event handler
        /// <summary>
        /// Page_Load :Page Load event handler
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">EventArgs</param>
        protected void Page_Load(object sender, EventArgs e)
        {

            SystemCheck systemCheck = new SystemCheck();
            systemCheck.SessionCheck();

            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(_DailySalesReport));
            lblMessage.Text = "";
            ViewState["ALLMode"] = false;
            if (!IsPostBack)
            {
                //
                // Fill The Branches in the Combo
                //
                hidFileName.Value = "DailySalesReport" + Session["SessionID"].ToString() + ".xls";
                FillBranches();
                dailySalesReport.GetDateRange();
                BindDefaultDateRange();
                if (Request.QueryString["BranchID"].ToString() == "ALL")
                {
                    hidShowMode.Value = "Show";
                }
                BindDataGrid();
                
            }

           

            if (hidShowMode.Value == "Show")
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoW", "ShowPanel();", true);
            else if (hidShowMode.Value == "ShowL")
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoWL", "ShowHide('Show');", true);
            else if (hidShowMode.Value == "HideL")
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoWL", "ShowHide('Hide');", true);
        } 
        #endregion

        #region Developer Methods
        /// <summary>
        /// BindDataGrid :Method used to bind grod
        /// </summary>          
        public void BindDataGrid()
        {
         
           
            dailySalesReport.StartDate = ViewState["StartDate"].ToString();
            dailySalesReport.EndDate = ViewState["EndDate"].ToString();

            lblPeriod.Text = "Period : " + Convert.ToDateTime(dailySalesReport.StartDate).ToShortDateString() + " to " + Convert.ToDateTime(dailySalesReport.EndDate).ToShortDateString();

            sortExpression = ((hidSort.Value != "") ? hidSort.Value : "SalesPerson asc");

            if (Request.QueryString["BranchID"].ToString() == "ALL" && !IsPostBack)
            {
                dtSalesAnalysis = dailySalesReport.GetSalesToDatetable(noneBranchID);
                ViewState["ALLMode"] = true;
            }
            else
                dtSalesAnalysis = dailySalesReport.GetSalesToDatetable(ddlBranch.SelectedValue);

            dtSalesAnalysis.DefaultView.Sort = sortExpression;
            if (dtSalesAnalysis.Rows.Count == 0)
            {
                DataRow drow = dtSalesAnalysis.NewRow();
                dtSalesAnalysis.Rows.Add(drow);
                status = true;
              
            }
            dvDailySales.DataSource = dtSalesAnalysis.DefaultView.ToTable();
            dtTotal = dtSalesAnalysis.DefaultView.ToTable();
            GetTotal();


            dvPager.InitPager(dvDailySales, pagesize);
            if (dtSalesAnalysis != null && dtSalesAnalysis.Rows.Count > 1)
            {
                divPager.Style.Add("display","");
                lblStatus.Visible = false;
            }
            else
            {
                divPager.Style.Add("display","none");
                
                lblStatus.Visible =((bool)ViewState["ALLMode"])? false: status;
                lblStatus.Text = "No Records Found";
                if (!(cldEndDt.SelectedDate.CompareTo(cldStartDt.SelectedDate) == 1 || cldEndDt.SelectedDate.CompareTo(cldStartDt.SelectedDate) == 0))
                    lblStatus.Text = "Invalid Date Range";
            }
            pnlBranch.Update();
            pnlProgress.Update();
            upnlGrid.Update();
            if (hidShowMode.Value == "Show")
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoW", "ShowPanel();", true);
            else if (hidShowMode.Value == "ShowL")
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoWL", "ShowHide('Show');", true);
            else if (hidShowMode.Value == "HideL")
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoWL", "ShowHide('Hide');", true);
        }
        /// <summary>
        /// GetTotal :method used to get grand total
        /// </summary>
        public void GetTotal()
        {
            dtTotal.Clear();
           
            if (status ==false && dtSalesAnalysis != null && dtSalesAnalysis.Rows.Count > 0  )
            {//SalesDol,SalesDolLB,SalesGP,SalesGPPct,SalesGPDolLB, SalesOrders, SalesLines, SalesPounds,
                //CreditDol, CreditDolLB,  CreditGP,CreditGPPct, CreditGPDolLB, CreditOrders, CreditLines, CreditPounds
                DataRow drow = dtTotal.NewRow();
                drow["SalesPerson"] = "Branch Total";
                drow["SalesDol"] = dtSalesAnalysis.Compute("sum(SalesDol)", "");                
                drow["SalesGP"] = dtSalesAnalysis.Compute("sum(SalesGP)", "");
                drow["SalesGPPct"] = dtSalesAnalysis.Compute("avg(SalesGPPct)", "");                
                drow["SalesOrders"] = dtSalesAnalysis.Compute("sum(SalesOrders)", "");
                drow["SalesLines"] = dtSalesAnalysis.Compute("sum(SalesLines)", "");
                drow["SalesPounds"] = dtSalesAnalysis.Compute("sum(SalesPounds)", "");
                drow["CreditDol"] = dtSalesAnalysis.Compute("sum(CreditDol)", "");
                drow["CreditGP"] = dtSalesAnalysis.Compute("sum(CreditGP)", "");
                drow["CreditGPPct"] = dtSalesAnalysis.Compute("avg(CreditGPPct)", "");               
                drow["CreditOrders"] = dtSalesAnalysis.Compute("sum(CreditOrders)", "");
                drow["CreditLines"] = dtSalesAnalysis.Compute("sum(CreditLines)", "");
                drow["CreditPounds"] = dtSalesAnalysis.Compute("sum(CreditPounds)", "");

                dtTotal.Rows.Add(drow);
            }
        }
        /// <summary>
        /// FillBranches :method used to Fill Branches in dropdown
        /// </summary>
        public void FillBranches()
        {
            try
            {
                salesReportUtils.GetALLBranches(ddlBranch, Session["UserID"].ToString());

                ddlBranch.SelectedValue = (Request.QueryString["BranchID"].ToString().Trim().Length == 1) ? "0" + Request.QueryString["BranchID"].ToString() : Request.QueryString["BranchID"].ToString();
                ddlBranch.Items[0].Value = "ALL";
            }
            catch (Exception ex) { }
            
        }
        /// <summary>
        /// BindDefaultDateRange :method used to Bind Default DateRange
        /// </summary>
        public void BindDefaultDateRange()
        {
            
            cldStartDt.SelectedDate =  Convert.ToDateTime(dailySalesReport.StartDate);
            cldStartDt.VisibleDate = Convert.ToDateTime(dailySalesReport.StartDate);
            cldEndDt.SelectedDate = Convert.ToDateTime(dailySalesReport.EndDate);
            cldEndDt.VisibleDate = Convert.ToDateTime(dailySalesReport.EndDate);

            ViewState["StartDate"] = cldStartDt.SelectedDate.ToShortDateString();
            ViewState["EndDate"] = cldEndDt.SelectedDate.ToShortDateString();
        } 
        #endregion

        #region  Event handler

        /// <summary>
        /// Pager_PageChanged :Pager event handler
        /// </summary>
        /// <param name="sender">Object</param>
        /// <param name="e">EventArgs</param>
        protected void Pager_PageChanged(Object sender, System.EventArgs e)
        {
            dvDailySales.PageIndex = dvPager.GotoPageNumber;
            BindDataGrid();
        }
        /// <summary>
        /// dvDailySales_RowDataBound :Grid view event handler
        /// </summary>
        /// <param name="sender">Object</param>
        /// <param name="e">GridViewRowEventArgs</param>
        protected void dvDailySales_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            e.Row.Cells[0].CssClass = "locked";
            if (e.Row.RowType == DataControlRowType.Header)
            {
                e.Row.Cells[1].ColumnSpan = 8;
                e.Row.Cells[1].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=8 nowrap ><center>Sales</center></td></tr><tr><td width='69' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                      "<Div onclick=\"javascript:BindValue('SalesDol');\">$</div></center></td><td width='51' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;' align='center'>" +
                                      "<Div onclick=\"javascript:BindValue('SalesDolLB');\">$/Lb</div></td><td width='71' class='GridHead splitBorders'  style='cursor:hand;border-right:solid 1px #c9c6c6;' nowrap align='center'>" +
                                      "<Div onclick=\"javascript:BindValue('SalesGP');\">GP $</div></td><td width='51' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                      "<Div onclick=\"javascript:BindValue('SalesGPPct');\">GP %</div></center></td><td width='51' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                      "<Div onclick=\"javascript:BindValue('SalesGPDolLB');\">$/Lb</div></td><td width='51' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                      "<Div onclick=\"javascript:BindValue('SalesOrders');\">Orders</div></td><td width='71' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                      "<Div onclick=\"javascript:BindValue('SalesLines');\">Lines</div></td><td width='70' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                      "<Div onclick=\"javascript:BindValue('SalesPounds');\">Pounds</div></td></tr></table>";
                e.Row.Cells[9].ColumnSpan = 8;
                e.Row.Cells[9].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;' colspan=8 nowrap ><center>Credits</center></td></tr><tr><td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                      "<Div onclick=\"javascript:BindValue('CreditDol');\">$</div></center></td><td width='51' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;' align='center'>" +
                                      "<Div onclick=\"javascript:BindValue('CreditDolLB');\">$/Lb</div></td><td width='71' class='GridHead splitBorders'  style='cursor:hand;border-right:solid 1px #c9c6c6;' nowrap align='center'>" +
                                      "<Div onclick=\"javascript:BindValue('CreditGP');\">GP $</div></td><td width='51' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                      "<Div onclick=\"javascript:BindValue('CreditGPPct');\">GP %</div></center></td><td width='51' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                      "<Div onclick=\"javascript:BindValue('CreditGPDolLB');\">$/Lb</div></td><td width='50' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                      "<Div onclick=\"javascript:BindValue('CreditOrders');\">Orders</div></td><td width='70' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                      "<Div onclick=\"javascript:BindValue('CreditLines');\">Lines</div></td><td width='70' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                      "<Div onclick=\"javascript:BindValue('CreditPounds');\">Pounds</div></td></tr></table>";
                e.Row.Cells[2].Visible = e.Row.Cells[3].Visible = e.Row.Cells[4].Visible = false;
                e.Row.Cells[5].Visible = e.Row.Cells[6].Visible = e.Row.Cells[7].Visible = false;
                e.Row.Cells[8].Visible = e.Row.Cells[10].Visible = e.Row.Cells[11].Visible = false;
                e.Row.Cells[12].Visible = e.Row.Cells[13].Visible = e.Row.Cells[14].Visible = false;
                e.Row.Cells[15].Visible = e.Row.Cells[16].Visible = false;

            }

            //SalesDol,SalesDolLB,SalesGP,SalesGPPct,SalesGPDolLB, SalesOrders, SalesLines, SalesPounds,
            //CreditDol, CreditDolLB,  CreditGP,CreditGPPct, CreditGPDolLB, CreditOrders, CreditLines, CreditPounds
            if (e.Row.RowType == DataControlRowType.Footer)
            {

                if (dtTotal.Rows.Count>0)
                {
                    decimal SalesDolLB = (Convert.ToDecimal(dtTotal.Rows[0]["SalesPounds"]) == 0) ? 0 : Convert.ToDecimal(dtTotal.Rows[0]["SalesDol"]) / Convert.ToDecimal(dtTotal.Rows[0]["SalesPounds"]);
                    decimal SalesGPDolLB = (Convert.ToDecimal(dtTotal.Rows[0]["SalesPounds"]) == 0) ? 0 : Convert.ToDecimal(dtTotal.Rows[0]["SalesGP"]) / Convert.ToDecimal(dtTotal.Rows[0]["SalesPounds"]);
                    decimal CreditDolLB = (Convert.ToDecimal(dtTotal.Rows[0]["CreditPounds"]) == 0) ? 0 : Convert.ToDecimal(dtTotal.Rows[0]["CreditDol"]) / Convert.ToDecimal(dtTotal.Rows[0]["CreditPounds"]);
                    decimal CreditGPDolLB = (Convert.ToDecimal(dtTotal.Rows[0]["CreditPounds"]) == 0) ? 0 : Convert.ToDecimal(dtTotal.Rows[0]["CreditGP"]) / Convert.ToDecimal(dtTotal.Rows[0]["CreditPounds"]);
                    decimal SalesGPPct = (Convert.ToDecimal(dtTotal.Rows[0]["SalesDol"]) == 0) ? 0 : Convert.ToDecimal(dtTotal.Rows[0]["SalesGP"]) / Convert.ToDecimal(dtTotal.Rows[0]["SalesDol"]);
                    decimal CreditGPPct = (Convert.ToDecimal(dtTotal.Rows[0]["CreditDol"]) == 0) ? 0 : Convert.ToDecimal(dtTotal.Rows[0]["CreditGP"]) / Convert.ToDecimal(dtTotal.Rows[0]["CreditDol"]);

                    e.Row.Cells[0].Text = "Branch Total";
                    e.Row.Cells[1].Text = string.Format("{0:#,##0}", dtTotal.Rows[0]["SalesDol"]);
                    e.Row.Cells[2].Text = string.Format("{0:#,##0.000}", SalesDolLB);
                    e.Row.Cells[3].Text = string.Format("{0:#,##0}", dtTotal.Rows[0]["SalesGP"]);

                   // e.Row.Cells[4].Text = string.Format("{0:#,##0.00}", dtTotal.Rows[0]["SalesGPPct"]);
                  e.Row.Cells[4].Text = string.Format("{0:#,##0.00}", SalesGPPct);

                    e.Row.Cells[5].Text = string.Format("{0:#,##0.000}", SalesGPDolLB);
                    e.Row.Cells[6].Text = string.Format("{0:#,##0}", dtTotal.Rows[0]["SalesOrders"]);
                    e.Row.Cells[7].Text = string.Format("{0:#,##0}", dtTotal.Rows[0]["SalesLines"]);
                    e.Row.Cells[8].Text = string.Format("{0:#,##0}", dtTotal.Rows[0]["SalesPounds"]);
                    e.Row.Cells[9].Text = string.Format("{0:#,##0}", dtTotal.Rows[0]["CreditDol"]);
                    e.Row.Cells[10].Text = string.Format("{0:#,##0.000}", CreditDolLB);
                    e.Row.Cells[11].Text = string.Format("{0:#,##0}", dtTotal.Rows[0]["CreditGP"]);
                   // e.Row.Cells[12].Text = string.Format("{0:#,##0.00}", dtTotal.Rows[0]["CreditGPPct"]);
                    e.Row.Cells[12].Text = string.Format("{0:#,##0.00}",CreditGPPct);
                    e.Row.Cells[13].Text = string.Format("{0:#,##0.000}", CreditGPDolLB);
                    e.Row.Cells[14].Text = string.Format("{0:#,##0}", dtTotal.Rows[0]["CreditOrders"]);
                    e.Row.Cells[15].Text = string.Format("{0:#,##0}", dtTotal.Rows[0]["CreditLines"]);
                    e.Row.Cells[16].Text = string.Format("{0:#,##0}", dtTotal.Rows[0]["CreditPounds"]); 
                }

            }
            if (e.Row.Cells[1].Text == "" || e.Row.Cells[1].Text == "&nbsp;")
                e.Row.Visible = false;
        }
        /// <summary>
        /// btnSort_Click :Grid view sort event handler
        /// </summary>
        /// <param name="source">object</param>
        /// <param name="e">EventArgs</param>
        protected void btnSort_Click(object source, EventArgs e)
        {
            if (hidSort.Attributes["sortType"] != null)
            {
                if (hidSort.Attributes["sortType"].ToString() == "ASC")
                    hidSort.Attributes["sortType"] = "DESC";
                else
                    hidSort.Attributes["sortType"] = "ASC";
            }
            else
                hidSort.Attributes.Add("sortType", "ASC");

            hidSort.Value = hidSortExpression.Value + " " + hidSort.Attributes["sortType"].ToString();
            BindDataGrid();
        }
        /// <summary>
        /// dvDailySales_Sorting :Grid view sort event handler
        /// </summary>
        /// <param name="source">object</param>
        /// <param name="e">GridViewSortEventArgs</param>
        protected void dvDailySales_Sorting(object sender, GridViewSortEventArgs e)
        {
            if (hidSort.Attributes["sortType"] != null)
            {
                if (hidSort.Attributes["sortType"].ToString() == "ASC")
                    hidSort.Attributes["sortType"] = "DESC";
                else
                    hidSort.Attributes["sortType"] = "ASC";
            }
            else
                hidSort.Attributes.Add("sortType", "ASC");

            hidSort.Value = e.SortExpression + " " + hidSort.Attributes["sortType"].ToString();
            BindDataGrid();
        }
        /// <summary>
        /// ddlBranch_SelectedIndexChanged : ddlBranch on change event handler
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">EventArgs</param>
        protected void ddlBranch_SelectedIndexChanged(object sender, EventArgs e)
        {
            ViewState["ALLMode"] = false;
            BindDataGrid();
        }
        /// <summary>
        /// ibtnRunReport_Click : Method used to run report based on selected date range
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">ImageClickEventArgs</param>
        protected void ibtnRunReport_Click(object sender, ImageClickEventArgs e)
        {
            ViewState["ALLMode"] = false;
            dvPager.Visible = true;
            ViewState["StartDate"] = cldStartDt.SelectedDate.ToShortDateString();
            ViewState["EndDate"] = cldEndDt.SelectedDate.ToShortDateString();
            BindDataGrid();
            //if (cldEndDt.SelectedDate.CompareTo(cldStartDt.SelectedDate) == 1 || cldEndDt.SelectedDate.CompareTo(cldStartDt.SelectedDate) == 0)
            //{
            //    ViewState["StartDate"] = cldStartDt.SelectedDate.ToShortDateString();
            //    ViewState["EndDate"] = cldEndDt.SelectedDate.ToShortDateString();          
            //    BindDataGrid();
            //}
            //else
            //{
            //    lblMessage.Text = "Invalid Date Range";

            //    if (hidShowMode.Value == "Show")
            //        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoW", "document.getElementById('leftPanel').style.display='';document.getElementById('imgHide').style.display='';document.getElementById('imgShow').style.display='none';document.getElementById('div-datagrid').style.width='830px';document.getElementById('hidShowMode').value='Show';", true);

            //}
        }
        /// <summary>
        /// ibtnPrint_Click : Method used to print  report
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">ImageClickEventArgs</param>
        protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
        {
            string branchID = "";
            if (!(bool)ViewState["ALLMode"])
                branchID = ddlBranch.SelectedValue;
            else
                branchID = noneBranchID;
            string strURL = "Sort=" + hidSort.Value + "&Branch=" + branchID + "&BranchName=" + ddlBranch.SelectedItem.Text + "&StartDate=" + ViewState["StartDate"].ToString().Trim() + "&EndDate=" + ViewState["EndDate"].ToString().Trim();

            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "PrintReport('" + strURL + "');", true);
        } 
        #endregion

        #region Write to Excel
        /// <summary>
        /// ibtnPrint_Click : Method used to export  report 
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">ImageClickEventArgs</param>
        protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
        {

            FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
            string headerContent = string.Empty;
            string footerContent = string.Empty;
            string excelContent = string.Empty;
            StreamWriter reportWriter;
            reportWriter = fnExcel.CreateText();
            sortExpression = ((hidSort.Value != "") ? hidSort.Value : "SalesPerson asc");

            dailySalesReport.StartDate = ViewState["StartDate"].ToString();
            dailySalesReport.EndDate = ViewState["EndDate"].ToString();
            if(!(bool) ViewState["ALLMode"])
                dtSalesAnalysis = dailySalesReport.GetSalesToDatetable(ddlBranch.SelectedValue);
            else
                dtSalesAnalysis = dailySalesReport.GetSalesToDatetable(noneBranchID);
            dtSalesAnalysis.DefaultView.Sort = hidSort.Value;
            dtTotal = dtSalesAnalysis.DefaultView.ToTable();
            GetTotal();
            headerContent = "<table border='1'>";

            headerContent += "<tr><th colspan='17' style='color:blue' align=left>Daily Sales Analysis Report</th></tr>";
            headerContent += "<tr><td colspan='2'><b>Branch :" + ddlBranch.SelectedItem.Text + "</></td><td colspan='8'><b>" + lblPeriod.Text + "</></td><td colspan='7'><b>Run By: "+ Session["UserName"].ToString()+ "  Run Date: " + DateTime.Now.ToShortDateString() + "</></td></tr>";
            headerContent += "<tr><th>Sales Person</th><th colspan=8 >" +
                 "<table border='1' style='font-weight:bold' width='100%'><tr><td   colspan=8 nowrap ><center>Sales</center></td></tr><tr><td width='70' nowrap><center>" +
                  "$</center></td><td width='50'  nowrap   align='center'>" +
                  "$/LB</td><td width='70'    nowrap align='center'>" +
                  "GP $</td><td width='50' class='GridHead splitBorders' nowrap  ><center>" +
                  "GP %</center></td><td width='50'  nowrap align='center' nowrap  >" +
                  "$/LB</td><td width='50'  nowrap align='center' nowrap  >" +
                  "Orders</td><td width='70'  nowrap align='center' nowrap  >" +
                  "Lines</td><td width='70'  nowrap align='center' nowrap  >" +
                  "Pounds</td></tr></table></th><th colspan=8>" +
                  "<table border='1' style='font-weight:bold'  width='100%' ><tr><td   colspan=8 nowrap ><center>Credits</center></td></tr><tr><td width='70' nowrap  ><center>" +
                  "$</center></td><td width='50'  nowrap   align='center'>" +
                  "$/LB</td><td width='70'    nowrap align='center'>" +
                  "GP $</td><td width='50' class='GridHead splitBorders' nowrap  ><center>" +
                  "GP %</center></td><td width='50'  nowrap align='center' nowrap  >" +
                  "$/LB</td><td width='50'  nowrap align='center' nowrap  >" +
                  "Orders</td><td width='70'  nowrap align='center' nowrap  >" +
                  "Lines</td><td width='70'  nowrap align='center' nowrap  >" +
                  "Pounds</td></tr></table></th></tr>";


            if (dtSalesAnalysis.Rows.Count > 0)
            {
                foreach (DataRow drSalesAnalysis in dtSalesAnalysis.DefaultView.ToTable().Rows)
                {
                    excelContent += "<tr ><td>" + drSalesAnalysis["SalesPerson"].ToString() + "</td><td>" +
                                                      string.Format("{0:#,##0}", drSalesAnalysis["SalesDol"]) + "</td><td>" +
                                                     string.Format("{0:#,##0.000}", drSalesAnalysis["SalesDolLB"]) + "</td><td>" +
                                                     string.Format("{0:#,##0}", drSalesAnalysis["SalesGP"]) + "</td><td>" +
                                                     string.Format("{0:#,##0.00}", drSalesAnalysis["SalesGPPct"]) + "</td><td>" +
                                                     string.Format("{0:#,##0.000}", drSalesAnalysis["SalesGPDolLB"]) + "</td><td>" +
                                                     string.Format("{0:#,##0}", drSalesAnalysis["SalesOrders"]) + "</td><td>" +
                                                     string.Format("{0:#,##0}", drSalesAnalysis["SalesLines"]) + "</td><td>" +
                                                     string.Format("{0:#,##0}", drSalesAnalysis["SalesPounds"]) + "</td><td>" +
                                                     string.Format("{0:#,##0}", drSalesAnalysis["CreditDol"]) + "</td><td>" +
                                                      string.Format("{0:#,##0.000}", drSalesAnalysis["CreditDolLB"]) + "</td><td>" +
                                                      string.Format("{0:#,##0}", drSalesAnalysis["CreditGP"]) + "</td><td>" +
                                                      string.Format("{0:#,##0.00}", drSalesAnalysis["CreditGPPct"]) + "</td><td>" +
                                                      string.Format("{0:#,##0.000}", drSalesAnalysis["CreditGPDolLB"]) + "</td><td>" +
                                                      string.Format("{0:#,##0}", drSalesAnalysis["CreditOrders"]) + "</td><td>" +
                                                      string.Format("{0:#,##0}", drSalesAnalysis["CreditLines"]) + "</td><td>" +
                                                      string.Format("{0:#,##0}", drSalesAnalysis["CreditPounds"]) + "</td></tr>";

                }
               if (dtTotal.Rows.Count>0)                
                {

                    decimal SalesDolLB = (Convert.ToDecimal(dtTotal.Rows[0]["SalesPounds"]) == 0) ? 0 : Convert.ToDecimal(dtTotal.Rows[0]["SalesDol"]) / Convert.ToDecimal(dtTotal.Rows[0]["SalesPounds"]);
                    decimal SalesGPDolLB = (Convert.ToDecimal(dtTotal.Rows[0]["SalesPounds"]) == 0) ? 0 : Convert.ToDecimal(dtTotal.Rows[0]["SalesGP"]) / Convert.ToDecimal(dtTotal.Rows[0]["SalesPounds"]);
                    decimal CreditDolLB = (Convert.ToDecimal(dtTotal.Rows[0]["CreditPounds"]) == 0) ? 0 : Convert.ToDecimal(dtTotal.Rows[0]["CreditDol"]) / Convert.ToDecimal(dtTotal.Rows[0]["CreditPounds"]);
                    decimal CreditGPDolLB = (Convert.ToDecimal(dtTotal.Rows[0]["CreditPounds"]) == 0) ? 0 : Convert.ToDecimal(dtTotal.Rows[0]["CreditGP"]) / Convert.ToDecimal(dtTotal.Rows[0]["CreditPounds"]);
                    decimal SalesGPPct = (Convert.ToDecimal(dtTotal.Rows[0]["SalesDol"]) == 0) ? 0 : Convert.ToDecimal(dtTotal.Rows[0]["SalesGP"]) / Convert.ToDecimal(dtTotal.Rows[0]["SalesDol"]);
                    decimal CreditGPPct = (Convert.ToDecimal(dtTotal.Rows[0]["CreditDol"]) == 0) ? 0 : Convert.ToDecimal(dtTotal.Rows[0]["CreditGP"]) / Convert.ToDecimal(dtTotal.Rows[0]["CreditDol"]);

                    footerContent = "<tr style='font-weight:bold'><td >" + dtTotal.Rows[0]["SalesPerson"].ToString() + "</td><td>" +
                      string.Format("{0:#,##0}", dtTotal.Rows[0]["SalesDol"]) + "</td><td>" +
                     string.Format("{0:#,##0.000}", SalesDolLB) + "</td><td>" +
                     string.Format("{0:#,##0}", dtTotal.Rows[0]["SalesGP"]) + "</td><td>" +
                     //string.Format("{0:#,##0.00}", dtTotal.Rows[0]["SalesGPPct"]) + "</td><td>" +
                     string.Format("{0:#,##0.00}", SalesGPPct) + "</td><td>" +
                     string.Format("{0:#,##0.000}", SalesGPDolLB) + "</td><td>" +
                     string.Format("{0:#,##0}", dtTotal.Rows[0]["SalesOrders"]) + "</td><td>" +
                     string.Format("{0:#,##0}", dtTotal.Rows[0]["SalesLines"]) + "</td><td>" +
                     string.Format("{0:#,##0}", dtTotal.Rows[0]["SalesPounds"]) + "</td><td>" +
                     string.Format("{0:#,##0}", dtTotal.Rows[0]["CreditDol"]) + "</td><td>" +
                      string.Format("{0:#,##0.000}", CreditDolLB) + "</td><td>" +
                      string.Format("{0:#,##0}", dtTotal.Rows[0]["CreditGP"]) + "</td><td>" +
                     // string.Format("{0:#,##0.00}", dtTotal.Rows[0]["CreditGPPct"]) + "</td><td>" +
                      string.Format("{0:#,##0.00}", CreditGPPct) + "</td><td>" +
                      string.Format("{0:#,##0.000}", CreditGPDolLB) + "</td><td>" +
                      string.Format("{0:#,##0}", dtTotal.Rows[0]["CreditOrders"]) + "</td><td>" +
                      string.Format("{0:#,##0}", dtTotal.Rows[0]["CreditLines"]) + "</td><td>" +
                      string.Format("{0:#,##0}", dtTotal.Rows[0]["CreditPounds"]) + "</td></tr></table>"; 
                }

            }
            reportWriter.WriteLine(headerContent + excelContent + footerContent);
            reportWriter.Close();


            //
            // Downloding Process
            //
            FileStream fileStream = File.Open(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()), FileMode.Open);
            Byte[] bytBytes = new Byte[fileStream.Length];
            fileStream.Read(bytBytes, 0, (int)fileStream.Length);
            fileStream.Close();

            //
            // Download Process
            //
            Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString())));
            Response.ContentType = "application/octet-stream";
            Response.BinaryWrite(bytBytes);
            Response.End();


        }
        #endregion

        #region Delete Excel using sessionid

        [Ajax.AjaxMethod()]
        public string DeleteExcel(string strSession)
        {
            try
            {

                DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\DailySalesReport\\Common\\ExcelUploads"));

                foreach (FileInfo fn in drExcel.GetFiles())
                {
                    if (fn.Name.Contains(strSession))
                        fn.Delete();
                }

                return "";
            }
            catch (Exception ex) { return ""; }
        }

        #endregion   

    }// End Class

}//End Namespace