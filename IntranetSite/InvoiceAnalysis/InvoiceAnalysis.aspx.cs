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
    public partial class InvoiceAnalysisReport : System.Web.UI.Page
    {
        #region Page Local variables
        SalesReportUtils salesReportUtils = new SalesReportUtils();
        InvoiceAnalysis invoiceAnalysis = new InvoiceAnalysis();

        private string sortExpression = string.Empty;
        private int pagesize = 19;
        private DataTable dtMain, dtGroup, dtTotal;
        DataTable dtInvoiceAnalysis = new DataTable();
        string _startDate = "";
        string _endDate = "";
        string _orderType = "";
        string _branchID = "";
        string _chain = "";
        string _customerNumber = "";
        string _weightFrom = "";
        string _weightTo = "";
        string _shipToState = "";
        string _shipment = "";
        string _salesPerson = "";
        string _salesRepNo = "";
        string _priceCd = "";
        string _orderSource = "";
        string _orderSourceDesc = "";
        string _subTotal = "";
        string _subTotalDesc = "";
        string _subTotalFlag = "";
        #endregion

        #region Page load event handler
        protected void Page_Load(object sender, EventArgs e)
        {
            SystemCheck systemCheck = new SystemCheck();
            systemCheck.SessionCheck();

            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(InvoiceAnalysisReport));
            lblMessage.Text = "";
            
            _orderType = Request.QueryString["OrderType"].ToString();
            _branchID = Request.QueryString["Branch"].ToString();
            _chain = Request.QueryString["Chain"].ToString();
            _customerNumber = Request.QueryString["CustNo"].ToString();
            _weightFrom = Request.QueryString["WeightFrom"].ToString();
            _weightTo = Request.QueryString["WeightTo"].ToString();
            _shipToState = Request.QueryString["ShipToState"].ToString();
            _shipment = Request.QueryString["ShipMethod"].ToString();
            _salesPerson = Request.QueryString["SalesPerson"].ToString();
            _salesRepNo = Request.QueryString["SalesRepNo"].ToString();
            _priceCd = Request.QueryString["PriceCd"].ToString();
            _orderSource = Request.QueryString["OrderSource"].ToString();
            _orderSourceDesc = Request.QueryString["OrderSourceDesc"].ToString();
            _subTotal = Request.QueryString["SubTotal"].ToString();
            _subTotalDesc = Request.QueryString["SubTotalDesc"].ToString();
            _subTotalFlag = Request.QueryString["SubTotalFlag"].ToString();

            if (!IsPostBack)
            {
                cldStartDt.SelectedDate = Convert.ToDateTime(Request.QueryString["StartDate"].ToString());
                cldEndDt.SelectedDate  = Convert.ToDateTime( Request.QueryString["EndDate"].ToString());
                cldStartDt.VisibleDate = Convert.ToDateTime(Request.QueryString["StartDate"].ToString());
                cldEndDt.VisibleDate = Convert.ToDateTime(Request.QueryString["EndDate"].ToString());

                hidFileName.Value = "InvoiceAnalysisReport" + Session["SessionID"].ToString() + ".xls";
                lblBeginDate.Text = "Beginning Date: " + Request.QueryString["StartDate"].ToString();
                lblEndDate.Text = "Ending Date: " + Request.QueryString["EndDate"].ToString();
                lblOrderType.Text = "Order Type: " + Request.QueryString["OrderTypeDesc"].ToString();
                lblBranch.Text = "Branch: " + Request.QueryString["BranchDesc"].ToString();
                lblShipment.Text = "Ship Meth: " + (_shipment == "" ? "ALL" : Request.QueryString["ShipMethodName"].ToString());
                lblChain.Text = "Chain: " + (_chain == "" ? "ALL" : _chain);
                lblCustomerNumber.Text = "Customer # " + (_customerNumber == "" ? "ALL" : _customerNumber);
                if(_weightFrom == "" && _weightTo == "")
                    lblWeight.Text = "Weight Range: ALL";
                else
                    lblWeight.Text = "Weight Range: " + (_weightFrom == "" ? "-" : _weightFrom) + " To  " + (_weightTo== "" ? "-" : _weightTo);
                lblState.Text = "Ship To State: " + (_shipToState == "" ? "ALL" : _shipToState);
                lblSalesPerson.Text = "Sales Person: " + (_salesPerson == "" ? "ALL" : _salesPerson);
                lblPriceCd.Text = "Price Code: " + (_priceCd == "" ? "ALL" : invoiceAnalysis.GetListDesc("CustPriceCd", _priceCd));
                lblOrderSource.Text = "Order Source: " + (_orderSourceDesc == "" ? invoiceAnalysis.GetListDesc("SOEOrderSource", _orderSource) : _orderSourceDesc);
                lblSubTot.Text = "Sub-Totals: " + _subTotalDesc;
                if (_subTotalFlag.ToUpper().ToString() == "TRUE")
                    lblSubTot.Text += " (Sub-Totals ONLY)";

                BindDataGrid(); 
            }

            if (hidShowMode.Value == "Show")
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Show", "ShowPanel();", true);
            else
                if (hidShowMode.Value == "ShowL")
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShowL", "ShowHide('Show');", true);
                else
                    if (hidShowMode.Value == "HideL")
                        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "HideL", "ShowHide('Hide');", true);
        } 
        #endregion

        #region Developer Methods
        public void BindDataGrid()
        {
            _startDate = cldStartDt.SelectedDate.ToShortDateString();
            _endDate = cldEndDt.SelectedDate.ToShortDateString();

            dtInvoiceAnalysis = invoiceAnalysis.GetInvoiceAnalysis(_startDate, _endDate, _orderType, _branchID, _chain, _customerNumber, _weightFrom, _weightTo, _shipToState, _shipment, _salesRepNo, _priceCd, _orderSource);

            if (dtInvoiceAnalysis != null && dtInvoiceAnalysis.Rows.Count > 0)
            {
                if (_subTotal == "0")
                {   //No Sub-Totals
                    dvInvoiceAnalysis.AllowSorting = true;
                    BindNoTot();
                }
                else
                {   //Sub-Totals
                    dvInvoiceAnalysis.AllowSorting = false;
                    BindSubTot();
                    dvInvoiceAnalysis.DataSource = dtMain.DefaultView.ToTable();
                }

                dvPager.InitPager(dvInvoiceAnalysis, pagesize);
                divPager.Style.Add("display", "");
                lblStatus.Visible = false;
            }
            else
            {
                divPager.Style.Add("display","none");
                lblStatus.Visible = true;
                lblStatus.Text = "No Records Found";
                if (!(cldEndDt.SelectedDate.CompareTo(cldStartDt.SelectedDate) == 1 || cldEndDt.SelectedDate.CompareTo(cldStartDt.SelectedDate) == 0))
                    lblStatus.Text = "Invalid Date Range";
            }

            pnlBranch.Update();
            pnlProgress.Update();
            upnlGrid.Update();
            if (hidShowMode.Value == "Show")
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Show", "ShowPanel();", true);
            else
                if (hidShowMode.Value == "ShowL")
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShowL", "ShowHide('Show');", true);
                else
                    if (hidShowMode.Value == "HideL")
                        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "HideL", "ShowHide('Hide');", true);
        }

        public void BindNoTot()
        {
            sortExpression = ((hidSort.Value != "") ? hidSort.Value : "ARDate ASC");
            dtInvoiceAnalysis.DefaultView.Sort = sortExpression;

            dvInvoiceAnalysis.DataSource = dtInvoiceAnalysis.DefaultView.ToTable();
            dtTotal = dtInvoiceAnalysis.DefaultView.ToTable();
        }

        public void BindSubTot()
        {
            dtGroup = invoiceAnalysis.GetInvoiceGroup(_subTotal, _startDate, _endDate, _orderType, _branchID, _chain, _customerNumber, _weightFrom, _weightTo, _shipToState, _shipment, _salesRepNo, _priceCd, _orderSource);

            dtMain = dtInvoiceAnalysis.Clone();
            dtTotal = dtInvoiceAnalysis.Clone();
            
            if (_subTotalFlag.ToUpper().ToString() == "TRUE")
                dtMain.Clear();

            foreach (DataRow dr in dtGroup.Rows)
            {
                try
                {
                    bool weightStatus;
                    decimal weightSubTot = 0;
                    decimal weightTo = (_weightTo == "") ? 0 : Convert.ToDecimal(_weightTo);
                    decimal weightFrom = (_weightFrom == "") ? 0 : Convert.ToDecimal(_weightFrom);

                    switch (_subTotal)
                    {
                        case "1":
                            dtInvoiceAnalysis.DefaultView.RowFilter = "CustNo='" + dr["CustNo"].ToString() + "'";
                        break;
                        case "2":
                            dtInvoiceAnalysis.DefaultView.RowFilter = "CustNo='" + dr["CustNo"].ToString() + "' and OrderSource='" + dr["OrderSource"].ToString() + "'";
                        break;
                        default:
                            dtInvoiceAnalysis.DefaultView.RowFilter = "ARDate='" + dr["ARDate"].ToString() + "' and Branch='" + dr["Branch"].ToString() + "' and ShipToCity='" + dr["ShipToCity"].ToString().Replace("'", "''") + "'";
                        break;
                    }
                    
                    DataTable dtFiltered = dtInvoiceAnalysis.DefaultView.ToTable();
                    if (dtFiltered != null && dtFiltered.Rows.Count > 0)
                    {
                        weightSubTot = Convert.ToDecimal(dtFiltered.Compute("sum(TotWgt)", ""));

                        if ((_weightFrom != "" && _weightTo != "") && (weightSubTot >= weightFrom && weightSubTot <= weightTo))
                            weightStatus = true;
                        else
                            if (_weightFrom != "" && _weightTo == "" && (weightSubTot >= weightFrom))
                                weightStatus = true;
                            else
                                if (_weightFrom == "" && _weightTo != "" && (weightSubTot <= weightTo))
                                    weightStatus = true;
                                else
                                    if (_weightFrom == "" && _weightTo == "")
                                        weightStatus = true;
                                    else
                                        weightStatus = false;

                        if (weightStatus)
                        {
                            dtTotal.Merge(dtFiltered);

                            DataRow drSum = dtMain.NewRow();
                            if (_subTotalFlag.ToUpper().ToString() == "TRUE")
                            {
                                switch (_subTotal)
                                {
                                    case "1":
                                        drSum["CustNo"] = dtFiltered.Rows[0]["CustNo"];
                                        drSum["CustName"] = dtFiltered.Rows[0]["CustName"];
                                        drSum["Chain"] = dtFiltered.Rows[0]["Chain"];
                                        drSum["PriceCd"] = dtFiltered.Rows[0]["PriceCd"];
                                    break;
                                    case "2":
                                        drSum["CustNo"] = dtFiltered.Rows[0]["CustNo"];
                                        drSum["CustName"] = dtFiltered.Rows[0]["CustName"];
                                        drSum["Chain"] = dtFiltered.Rows[0]["Chain"];
                                        drSum["PriceCd"] = dtFiltered.Rows[0]["PriceCd"];
                                        drSum["OrderSource"] = dtFiltered.Rows[0]["OrderSource"];
                                    break;
                                    default:
                                        drSum["ARDate"] = dtFiltered.Rows[0]["ARDate"];
                                        drSum["Branch"] = dtFiltered.Rows[0]["Branch"];
                                        drSum["ShipToCity"] = dtFiltered.Rows[0]["ShipToCity"];
                                    break;
                                }
                            }
                            else
                            {
                                dtMain.Merge(dtFiltered);
                                drSum["ARDate"] = "Sub-Total";
                            }

                            drSum["NetSales"] = dtFiltered.Compute("sum(NetSales)", "");
                            drSum["NetExp"] = dtFiltered.Compute("sum(NetExp)", "");
                            drSum["TotAR"] = dtFiltered.Compute("sum(TotAR)", "");
                            drSum["GMDollar"] = dtFiltered.Compute("sum(GMDollar)", "");
                            decimal _gmPct = ((Convert.ToDecimal(dtFiltered.Compute("sum(NetSales)", "")) == 0) ? 0 : Convert.ToDecimal(dtFiltered.Compute("sum(GMDollar)", "")) / Convert.ToDecimal(dtFiltered.Compute("sum(NetSales)", "")));
                            drSum["GMPct"] = Math.Round(_gmPct * 100, 1);
                            drSum["TotWgt"] = dtFiltered.Compute("sum(TotWgt)", "");
                            dtMain.Rows.Add(drSum);
                        }
                    }
                }
                catch (Exception ex)
                {
                    throw;
                }
            }
        }
        #endregion

        #region  Event handler
        protected void Pager_PageChanged(Object sender, System.EventArgs e)
        {
            dvInvoiceAnalysis.PageIndex = dvPager.GotoPageNumber;
            BindDataGrid();
        }

        protected void dvInvoiceAnalysis_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            e.Row.Cells[0].CssClass = "locked";
            e.Row.Cells[1].CssClass = "locked";
            e.Row.Cells[2].CssClass = "locked";
            e.Row.Cells[3].CssClass = "locked";
            e.Row.Cells[4].CssClass = "locked";
            e.Row.Cells[5].CssClass = "locked";

            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.Cells[0].Text.Trim() == "Sub-Total")
                e.Row.Style.Add(HtmlTextWriterStyle.FontWeight, "bold");

            if (e.Row.RowType == DataControlRowType.Footer && dtTotal.Rows.Count > 0)
            {
                e.Row.Cells[0].Text = "Total"; 
                e.Row.Cells[11].Text = String.Format("{0:c}", dtTotal.Compute("sum(NetSales)", ""));
                e.Row.Cells[12].Text = String.Format("{0:c}", dtTotal.Compute("sum(NetExp)", ""));
                e.Row.Cells[13].Text = String.Format("{0:c}", dtTotal.Compute("sum(TotAR)", ""));
                e.Row.Cells[14].Text = String.Format("{0:c}", dtTotal.Compute("sum(GMDollar)", ""));

                decimal _gmPct = 0.0M;
                if (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(NetSales)", "")), 0) != 0)
                    _gmPct = Convert.ToDecimal(dtTotal.Compute("sum(GMDollar)", "")) / Convert.ToDecimal(dtTotal.Compute("sum(NetSales)", ""));

                e.Row.Cells[15].Text = Math.Round(_gmPct*100,1).ToString();
                e.Row.Cells[16].Text = String.Format("{0:#,##0.0}", dtTotal.Compute("sum(TotWgt)", ""));
            }
        }

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

        protected void dvInvoiceAnalysis_Sorting(object sender, GridViewSortEventArgs e)
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

        protected void ibtnRunReport_Click(object sender, ImageClickEventArgs e)
        {
            dvPager.Visible = true;
            lblBeginDate.Text = "Beginning Date: " + cldStartDt.SelectedDate.ToShortDateString();
            lblEndDate.Text = "Ending Date: " + cldEndDt.SelectedDate.ToShortDateString(); 

            if (cldEndDt.SelectedDate.CompareTo(cldStartDt.SelectedDate) == 1 || cldEndDt.SelectedDate.CompareTo(cldStartDt.SelectedDate) == 0)
            {
                BindDataGrid();
            }
            else
            {
                lblMessage.Text = "Invalid Date Range";
                BindDataGrid();
                pnlProgress.Update();
                if (hidShowMode.Value == "Show")
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Show", "document.getElementById('leftPanel').style.display='';document.getElementById('imgHide').style.display='';document.getElementById('imgShow').style.display='none';document.getElementById('div-datagrid').style.width='830px';document.getElementById('hidShowMode').value='Show';", true);
            }
            pnlBranch.Update();
        }

        protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
        {
            string strURL = "Sort=" + hidSort.Value +
                            "&StartDate=" + cldStartDt.SelectedDate.ToShortDateString() +
                            "&EndDate=" + cldEndDt.SelectedDate.ToShortDateString() +
                            "&OrderType=" + Request.QueryString["OrderType"].ToString() +
                            "&Branch=" + Request.QueryString["Branch"].ToString() +
                            "&CustNo=" + Request.QueryString["CustNo"].ToString() +
                            "&Chain=" + Request.QueryString["Chain"].ToString() +
                            "&WeightFrom=" + Request.QueryString["WeightFrom"].ToString() +
                            "&WeightTo=" + Request.QueryString["WeightTo"].ToString() +
                            "&ShipToState=" + Request.QueryString["ShipToState"].ToString() +
                            "&BranchDesc=" + Request.QueryString["BranchDesc"].ToString() +
                            "&OrderTypeDesc=" + Request.QueryString["OrderTypeDesc"].ToString() +
                            "&SalesPerson=" + Request.QueryString["SalesPerson"].ToString() +
                            "&SalesRepNo=" + Request.QueryString["SalesRepNo"].ToString() +
                            "&PriceCd=" + Request.QueryString["PriceCd"].ToString() +
                            "&OrderSource=" + Request.QueryString["OrderSource"].ToString() +
                            "&OrderSourceDesc=" + Request.QueryString["OrderSourceDesc"].ToString() +
                            "&ShipMethod=" + Request.QueryString["ShipMethod"].ToString() +
                            "&ShipMethodName=" + Request.QueryString["ShipMethodName"].ToString() +
                            "&SubTotal=" + Request.QueryString["SubTotal"].ToString() +
                            "&SubTotalDesc=" + Request.QueryString["SubTotalDesc"].ToString() +
                            "&SubTotalFlag=" + Request.QueryString["SubTotalFlag"].ToString();

            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "PrintReport('" + strURL + "');", true);
        } 
        #endregion

        #region Write to Excel
        protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
        {
            FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
            string headerContent = string.Empty;
            string footerContent = string.Empty;
            string excelContent = string.Empty;
            StreamWriter reportWriter;
            reportWriter = fnExcel.CreateText();

            _startDate = cldStartDt.SelectedDate.ToShortDateString();
            _endDate = cldEndDt.SelectedDate.ToShortDateString();
            sortExpression = ((hidSort.Value != "") ? hidSort.Value : "ARDate asc");
            dtInvoiceAnalysis = invoiceAnalysis.GetInvoiceAnalysis(_startDate, _endDate, _orderType, _branchID, _chain, _customerNumber, _weightFrom, _weightTo, _shipToState, _shipment, _salesRepNo, _priceCd, _orderSource);

            if (dtInvoiceAnalysis != null && dtInvoiceAnalysis.Rows.Count > 0)
            {
                if (_subTotal == "0")
                {   //No Sub-Totals
                    dtInvoiceAnalysis.DefaultView.Sort = sortExpression;
                    dtMain = dtInvoiceAnalysis.DefaultView.ToTable();
                    dtTotal = dtInvoiceAnalysis.DefaultView.ToTable();
                }
                else
                {   //Sub-Totals
                    BindSubTot();
                }

                headerContent = "<table border='1'>";

                headerContent += "<tr><th colspan='22' style='color:blue' align=left><center>Invoice Analysis Report</center></th></tr><tr><td></td>" +
                                 "<td colspan='4'><b>Beginning Date: " + cldStartDt.SelectedDate.ToShortDateString() + "</b></td>" +
                                 "<td colspan='4'><b>Ending Date: " + cldEndDt.SelectedDate.ToShortDateString() + "</b></td>" +
                                 "<td colspan='4'><b>" + lblOrderType.Text + "</b></td>" +
                                 "<td colspan='4'><b>Branch: " + Request.QueryString["BranchDesc"].ToString() + "</b></td>" +
                                 "<td colspan='4'><b>" + lblChain.Text + "</b></td><td></td></tr><tr><td></td>" +
                                 "<td colspan='4'><b>" + lblCustomerNumber.Text + "</b></td>" +
                                 "<td colspan='4'><b>" + lblWeight.Text + "</b></td>" +
                                 "<td colspan='4'><b>" + lblState.Text + "</b></td>" +
                                 "<td colspan='4'><b>" + lblShipment.Text + "</b></td>" +
                                 "<td colspan='4'><b>" + lblSalesPerson.Text + "</b></td><td></td><tr><td></td>" +
                                 "<td colspan='4'><b>" + lblPriceCd.Text + "</b></td>" +
                                 "<td colspan='4'><b>" + lblOrderSource.Text + "</b></td>" +
                                 "<td colspan='4'><b>" + lblSubTot.Text + "</b></td>" +
                                 "<td colspan='4'><b>Run By: " + Session["UserName"].ToString() + "</b></td>" +
                                 "<td colspan='4'><b>Run Date: " + DateTime.Now.ToShortDateString() + "</b></td><td></td></tr>" +
                                 "<tr><th colspan='22' style='color:blue' align=left></th></tr>";

                headerContent += "<tr><th         nowrap align='center'>Date</th>" +
                                 "<th width='70'  nowrap align='center'>Branch</td>" +
                                 "<th width='150' nowrap align='center'>Order Type</th>" +
                                 "<th width='150' nowrap align='center'>Ship To City</th>" +
                                 "<th width='50'  nowrap align='center'>State</th>" +
                                 "<th width='60'  nowrap align='center'>No</th>" +
                                 "<th width='250' nowrap align='center'>Name</th>" +
                                 "<th width='60'  nowrap align='center'>Chain</th>" +
                                 "<th width='60'  nowrap align='center'>Price Cd</th>" +
                                 "<th width='70'  nowrap align='center'>Doc No</th>" +
                                 "<th width='120' nowrap align='center'>Cust PO</th>" +
                                 "<th width='80'  nowrap align='center'>Net Sales</th>" +
                                 "<th width='80'  nowrap align='center'>Net Exp</th>" +
                                 "<th width='80'  nowrap align='center'>Tot A/R</th>" +
                                 "<th width='80'  nowrap align='center'>GM $</th>" +
                                 "<th width='80'  nowrap align='center'>GM %</th>" +
                                 "<th width='80'  nowrap align='center'>Tot Wght</th>" +
                                 "<th width='120' nowrap align='center'>Ship Method</th>" +
                                 "<th width='100'  nowrap align='center'>Inside Sales</th>" +
                                 "<th width='100'  nowrap align='center'>Sales Person</th>" +
                                 "<th width='250' nowrap align='center'>Ship To Name</th>" +
                                 "<th width='70'  nowrap align='center'>Order Src</th>" +
                                 "</tr>";

                if (dtMain.Rows.Count > 0)
                {
                    foreach (DataRow drSalesAnalysis in dtMain.Rows)
                    {
                        if (drSalesAnalysis["ARDate"].ToString() == "Sub-Total")
                            excelContent += " <tr style='font-weight:bold'>";
                        else
                            excelContent += " <tr>";

                        excelContent += "<td nowrap align='center'>" +
                                        drSalesAnalysis["ARDate"].ToString() + "</td><td nowrap align='center'>" +
                                        drSalesAnalysis["Branch"] + "</td><td nowrap>" +
                                        drSalesAnalysis["OrderType"] + "</td><td nowrap>" +
                                        drSalesAnalysis["ShipToCity"] + "</td><td nowrap align='center'>" +
                                        drSalesAnalysis["ShipToState"] + "</td><td nowrap align='center'>" +
                                        drSalesAnalysis["CustNo"] + "</td><td nowrap>" +
                                        drSalesAnalysis["CustName"] + "</td><td nowrap align='center'>" +
                                        drSalesAnalysis["Chain"] + "</td><td nowrap align='center'>" +
                                        drSalesAnalysis["PriceCd"] + "</td><td nowrap align='center'>" +
                                        drSalesAnalysis["DocNo"] + "</td><td nowrap align='left'>" +
                                        drSalesAnalysis["CustPO"] + "</td><td nowrap>" +
                                        string.Format("{0:c}", drSalesAnalysis["NetSales"]) + "</td><td nowrap>" +
                                        string.Format("{0:c}", drSalesAnalysis["NetExp"]) + "</td><td nowrap>" +
                                        string.Format("{0:c}", drSalesAnalysis["TotAR"]) + "</td><td nowrap>" +
                                        string.Format("{0:c}", drSalesAnalysis["GMDollar"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0.0}", drSalesAnalysis["GMPct"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0.0}", drSalesAnalysis["TotWgt"]) + "</td><td nowrap>" +
                                        drSalesAnalysis["ShipMethod"] + "</td><td nowrap>" +
                                        drSalesAnalysis["InsideSalesPerson"] + "</td><td nowrap>" +
                                        drSalesAnalysis["SalesPerson"] + "</td><td nowrap>" +
                                        drSalesAnalysis["ShipToName"] + "</td><td nowrap align='center'>" +
                                        drSalesAnalysis["OrderSource"] + "</td></tr>";
                    }

                    decimal _gmPct = 0.0M;
                    if (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(NetSales)", "")), 0) != 0)
                        _gmPct = Convert.ToDecimal(dtTotal.Compute("sum(GMDollar)", "")) / Convert.ToDecimal(dtTotal.Compute("sum(NetSales)", ""));

                    footerContent = "<tr style='font-weight:bold'><td align='center'>Total</td><td colspan='10'></td><td>" +
                                        String.Format("{0:c}", dtTotal.Compute("sum(NetSales)", "")) + "</td><td>" +
                                        String.Format("{0:c}", dtTotal.Compute("sum(NetExp)", "")) + "</td><td>" +
                                        String.Format("{0:c}", dtTotal.Compute("sum(TotAR)", "")) + "</td><td>" +
                                        String.Format("{0:c}", dtTotal.Compute("sum(GMDollar)", "")) + "</td><td>" +
                                        Math.Round(_gmPct * 100, 1).ToString() + "</td><td>" +
                                        String.Format("{0:#,##0.0}", dtTotal.Compute("sum(TotWgt)", "")) + "</td><td colspan='5'></td></tr></table>";
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