#region Headers
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

namespace PFC.Intranet.DailySalesReports
{
    public partial class DailySalesReportPreview : System.Web.UI.Page
    {
        #region Local variables
        DailySalesReport dailySalesReport = new DailySalesReport();

        private string sortExpression = string.Empty;
        private int pagesize = 19; //Constant

        private DataTable dtTotal;
        DataTable dtSalesAnalysis = new DataTable();
        #endregion

        #region Page load event handlers
        /// <summary>
        /// Page load event handler
        /// </summary>
        /// <param name="sender">Object</param>
        /// <param name="e">EventArgs</param>
        protected void Page_Load(object sender, EventArgs e)
        {
            SystemCheck systemCheck = new SystemCheck();
            systemCheck.SessionCheck();
            if (!IsPostBack)
            {
                BindDataGrid();
            }
        }
        #endregion

        #region Event Handlers
        /// <summary>
        /// dvDailySales_RowDataBound : Data grid view Row Data Bound event handler
        /// </summary>
        /// <param name="sender">object</param>
        /// <param name="e">GridViewRowEventArgs</param>
        protected void dvDailySales_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            //e.Row.Cells[0].CssClass = "locked";
            if (e.Row.RowType == DataControlRowType.Header)
            {
                e.Row.Cells[1].ColumnSpan = 8;
                e.Row.Cells[1].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=8 nowrap ><center>Sales</center></td></tr><tr><td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                      "$</center></td><td width='50' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;' align='center'>" +
                                      "$/LB</td><td width='70' class='GridHead splitBorders'  style='cursor:hand;border-right:solid 1px #c9c6c6;' nowrap align='center'>" +
                                      "GP $</td><td width='50' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                      "GP %</center></td><td width='50' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                      "$/LB</td><td width='50' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                      "Orders</td><td width='70' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                      "Lines</td><td width='70' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                      "Pounds</td></tr></table>";
                e.Row.Cells[9].ColumnSpan = 8;
                e.Row.Cells[9].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;' colspan=8 nowrap ><center>Credits</center></td></tr><tr><td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                      "$</center></td><td width='50' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;' align='center'>" +
                                      "$/LB</td><td width='70' class='GridHead splitBorders'  style='cursor:hand;border-right:solid 1px #c9c6c6;' nowrap align='center'>" +
                                      "GP $</td><td width='50' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                      "GP %</center></td><td width='50' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                      "$/LB</td><td width='50' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                      "Orders</td><td width='70' class='GridHead splitBorders ' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                      "Lines</td><td width='70' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                      "Pounds</td></tr></table>";
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
                    //e.Row.Cells[12].Text = string.Format("{0:#,##0.00}", dtTotal.Rows[0]["CreditGPPct"]);
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
        #endregion

        #region Developer Methods
        /// <summary>
        /// GetTotal :method used to get grand total
        /// </summary>
        public void GetTotal()
        {
            dtTotal.Clear();
            if (dtSalesAnalysis != null && dtSalesAnalysis.Rows.Count > 0)
            {//SalesDol,SalesDolLB,SalesGP,SalesGPPct,SalesGPDolLB, SalesOrders, SalesLines, SalesPounds,
                //CreditDol, CreditDolLB,  CreditGP,CreditGPPct, CreditGPDolLB, CreditOrders, CreditLines, CreditPounds
                DataRow drow = dtTotal.NewRow();
                drow["SalesPerson"] = "Branch Total";
                drow["SalesDol"] = dtSalesAnalysis.Compute("sum(SalesDol)", "");
                drow["SalesDolLB"] = dtSalesAnalysis.Compute("avg(SalesDolLB)", "");
                drow["SalesGP"] = dtSalesAnalysis.Compute("sum(SalesGP)", "");
                drow["SalesGPPct"] = dtSalesAnalysis.Compute("avg(SalesGPPct)", "");
                drow["SalesGPDolLB"] = dtSalesAnalysis.Compute("avg(SalesGPDolLB)", "");
                drow["SalesOrders"] = dtSalesAnalysis.Compute("sum(SalesOrders)", "");
                drow["SalesLines"] = dtSalesAnalysis.Compute("sum(SalesLines)", "");
                drow["SalesPounds"] = dtSalesAnalysis.Compute("sum(SalesPounds)", "");
                drow["CreditDol"] = dtSalesAnalysis.Compute("sum(CreditDol)", "");
                drow["CreditDolLB"] = dtSalesAnalysis.Compute("avg(CreditDolLB)", "");
                drow["CreditGP"] = dtSalesAnalysis.Compute("sum(CreditGP)", "");
                drow["CreditGPPct"] = dtSalesAnalysis.Compute("avg(CreditGPPct)", "");
                drow["CreditGPDolLB"] = dtSalesAnalysis.Compute("avg(CreditGPDolLB)", "");
                drow["CreditOrders"] = dtSalesAnalysis.Compute("sum(CreditOrders)", "");
                drow["CreditLines"] = dtSalesAnalysis.Compute("sum(CreditLines)", "");
                drow["CreditPounds"] = dtSalesAnalysis.Compute("sum(CreditPounds)", "");

                dtTotal.Rows.Add(drow);
            }
        }
        /// <summary>
        /// BindDataGrid :Used to bind data grid view 
        /// </summary>
        public void BindDataGrid()
        {
            bool status = false;
            dailySalesReport.StartDate = Request.QueryString["StartDate"].ToString();
            dailySalesReport.EndDate = Request.QueryString["EndDate"].ToString();

            sortExpression = ((Request.QueryString["Sort"] != null) ? Request.QueryString["Sort"].ToString() : "SalesPerson asc");
            dtSalesAnalysis = dailySalesReport.GetSalesToDatetable(Request.QueryString["Branch"].ToString());

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

            dvDailySales.DataBind();

            if (dtSalesAnalysis != null && dtSalesAnalysis.Rows.Count > 1)
            {
                lblStatus.Visible = false;
            }
            else
            {
                lblStatus.Visible = status;
                lblStatus.Text = "No Records Found";
                if (!(Convert.ToDateTime(dailySalesReport.EndDate).CompareTo(Convert.ToDateTime(dailySalesReport.StartDate)) == 1 || Convert.ToDateTime(dailySalesReport.EndDate).CompareTo(Convert.ToDateTime(dailySalesReport.StartDate)) == 0))
                    lblStatus.Text = "Invalid Date Range";
            }
        }
        #endregion
    
    }// End Class

}// End Namespace