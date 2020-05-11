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
    public partial class InvoiceAnalysisByCustNoReport : System.Web.UI.Page
    {
        #region Page Local variables
        SalesReportUtils salesReportUtils = new SalesReportUtils();
        InvoiceAnalysis invoiceAnalysis = new InvoiceAnalysis();

        private string sortExpression = string.Empty;
        private int pagesize = 18;
        private DataTable dtMain, dtGroup, dtTotal;
        DataTable dtInvoiceAnalysis = new DataTable();
        DataSet dsInvoiceAnalysis = new DataSet();
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
        string _territory = "";
        string _CSR = "";
        string _CSRName = "";
        string _regionalMgr = "";
        string _allCustFlag = "";
        string _rollUpInd = "";
        string _buyGroup = "";
        #endregion

        #region Page load event handler
        protected void Page_Load(object sender, EventArgs e)
        {
            SystemCheck systemCheck = new SystemCheck();
            systemCheck.SessionCheck();

            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(InvoiceAnalysisByCustNoReport));
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
            _territory = Request.QueryString["TerritoryCd"].ToString();
            _CSR = Request.QueryString["CSRNo"].ToString();
            _CSRName = (Request.QueryString["CSRName"].ToString().ToUpper() == "ALL" ? "" :Request.QueryString["CSRName"].ToString());
            _regionalMgr = (Request.QueryString["RegionalMgr"].ToString().ToUpper() == "ALL" ? "" : Request.QueryString["RegionalMgr"].ToString());
            _allCustFlag = Request.QueryString["AllCustFlag"].ToString();
            if (_allCustFlag.ToUpper().ToString() == "TRUE")
                _allCustFlag = "Y";
            else
                _allCustFlag = "N";
            _rollUpInd = (Request.QueryString["RollUpIndFlag"] != null ? Request.QueryString["RollUpIndFlag"].ToString() : "True");
            //_rollUpInd = Request.QueryString["RollUpIndFlag"].ToString();
            if (_rollUpInd.ToUpper().ToString() == "TRUE")
                _rollUpInd = "Y";
            else
                _rollUpInd = "N"; 
            _buyGroup = (Request.QueryString["BuyGroup"] != null ? Request.QueryString["BuyGroup"].ToString() : "");

            if (!IsPostBack)
            {
                cldStartDt.SelectedDate = Convert.ToDateTime(Request.QueryString["StartDate"].ToString());
                cldEndDt.SelectedDate  = Convert.ToDateTime( Request.QueryString["EndDate"].ToString());
                cldStartDt.VisibleDate = Convert.ToDateTime(Request.QueryString["StartDate"].ToString());
                cldEndDt.VisibleDate = Convert.ToDateTime(Request.QueryString["EndDate"].ToString());

                hidFileName.Value = "SalesPerformanceReport" + Session["SessionID"].ToString() + ".xls";
                lblBeginDate.Text = "Beginning Date: " + Request.QueryString["StartDate"].ToString();
                lblEndDate.Text = "Ending Date: " + Request.QueryString["EndDate"].ToString();
                lblOrderType.Text = "Order Type: " + Request.QueryString["OrderTypeDesc"].ToString();
                lblBranch.Text = "Branch: " + Request.QueryString["BranchDesc"].ToString();
                lblChain.Text = "Chain: " + (_chain == "" ? "ALL" : _chain);
                lblCustomerNumber.Text = "Customer # " + (_customerNumber == "" ? "ALL" : _customerNumber);
                lblTerritory.Text = "Territory: " + (Request.QueryString["TerritoryDesc"].ToString() == "" ? "ALL" : Request.QueryString["TerritoryDesc"].ToString());
                lblCSR.Text = "Outside Rep: " + (Request.QueryString["CSRName"].ToString() == "" ? "ALL" : Request.QueryString["CSRName"].ToString());
                //lblState.Text = "Ship To State: " + (_shipToState == "" ? "ALL" : _shipToState);
                lblShipment.Text = "Ship Meth: " + (_shipment == "" ? "ALL" : Request.QueryString["ShipMethodName"].ToString());
                lblSalesPerson.Text = "Inside Rep: " + (_salesPerson == "" ? "ALL" : _salesPerson);
                lblRegionalMgr.Text = "Regional Mgr: " + (_regionalMgr == "" ? "ALL" : _regionalMgr);
                lblPriceCd.Text = "Price Code: " + (_priceCd == "" ? "ALL" : invoiceAnalysis.GetListDesc("CustPriceCd", _priceCd));
                lblOrderSource.Text = "Order Source: " + (_orderSourceDesc == "" ? invoiceAnalysis.GetListDesc("SOEOrderSource", _orderSource) : _orderSourceDesc);
                lblBuyGroup.Text = "BuyGroup: " + (_buyGroup == "" ? "ALL" : _buyGroup);
                //lblSubTot.Text = "Sub-Totals: " + _subTotalDesc;
                //if (_subTotalFlag.ToUpper().ToString() == "TRUE")
                //    lblSubTot.Text += " (Sub-Totals ONLY)";

                BindDataGrid(); 
            }

            BindPrintDialog();

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

            dsInvoiceAnalysis = invoiceAnalysis.GetInvoiceAnalysisByCustNo(_startDate, _endDate, _orderType, _branchID, _chain, _customerNumber, _territory, _CSRName, _shipToState, _shipment, _salesPerson, _priceCd, _orderSource, _allCustFlag, _regionalMgr, _buyGroup, _rollUpInd);

            dtInvoiceAnalysis = (dsInvoiceAnalysis != null ? dsInvoiceAnalysis.Tables[0] : null);
            if (dtInvoiceAnalysis != null && dtInvoiceAnalysis.Rows.Count > 0)
            {
                //if (_subTotal == "0")
                //{   //No Sub-Totals
                //    dvInvoiceAnalysis.AllowSorting = true;
                //    BindNoTot();
                //}
                //else
                //{   //Sub-Totals
                //    dvInvoiceAnalysis.AllowSorting = false;
                //    BindSubTot();
                //    dvInvoiceAnalysis.DataSource = dtMain.DefaultView.ToTable();
                //}
                dvInvoiceAnalysis.AllowSorting = true;
                BindNoTot();

                dvInvoiceAnalysis.Visible = true;
                dvPager.InitPager(dvInvoiceAnalysis, pagesize);
                divPager.Style.Add("display", "");
                lblStatus.Visible = false;
            }
            else
            {
                dvInvoiceAnalysis.Visible = false;
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
            sortExpression = ((hidSort.Value != "") ? hidSort.Value : "Branch,CustNo ASC");
            dtInvoiceAnalysis.DefaultView.Sort = sortExpression;

            dvInvoiceAnalysis.DataSource = dtInvoiceAnalysis.DefaultView.ToTable();
            dtTotal = dtInvoiceAnalysis.DefaultView.ToTable();
        }

        //public void BindSubTot()
        //{
        //    dtGroup = invoiceAnalysis.GetInvoiceGroup(_subTotal, _startDate, _endDate, _orderType, _branchID, _chain, _customerNumber, _weightFrom, _weightTo, _shipToState, _shipment, _salesRepNo, _priceCd, _orderSource);

        //    dtMain = dtInvoiceAnalysis.Clone();
        //    dtTotal = dtInvoiceAnalysis.Clone();
            
        //    if (_subTotalFlag.ToUpper().ToString() == "TRUE")
        //        dtMain.Clear();

        //    foreach (DataRow dr in dtGroup.Rows)
        //    {
        //        try
        //        {
        //            bool weightStatus;
        //            decimal weightSubTot = 0;
        //            decimal weightTo = (_weightTo == "") ? 0 : Convert.ToDecimal(_weightTo);
        //            decimal weightFrom = (_weightFrom == "") ? 0 : Convert.ToDecimal(_weightFrom);

        //            switch (_subTotal)
        //            {
        //                case "1":
        //                    dtInvoiceAnalysis.DefaultView.RowFilter = "CustNo='" + dr["CustNo"].ToString() + "'";
        //                break;
        //                case "2":
        //                    dtInvoiceAnalysis.DefaultView.RowFilter = "CustNo='" + dr["CustNo"].ToString() + "' and OrderSource='" + dr["OrderSource"].ToString() + "'";
        //                break;
        //                default:
        //                    dtInvoiceAnalysis.DefaultView.RowFilter = "ARDate='" + dr["ARDate"].ToString() + "' and Branch='" + dr["Branch"].ToString() + "' and ShipToCity='" + dr["ShipToCity"].ToString().Replace("'", "''") + "'";
        //                break;
        //            }
                    
        //            DataTable dtFiltered = dtInvoiceAnalysis.DefaultView.ToTable();
        //            if (dtFiltered != null && dtFiltered.Rows.Count > 0)
        //            {
        //                weightSubTot = Convert.ToDecimal(dtFiltered.Compute("sum(TotWgt)", ""));

        //                if ((_weightFrom != "" && _weightTo != "") && (weightSubTot >= weightFrom && weightSubTot <= weightTo))
        //                    weightStatus = true;
        //                else
        //                    if (_weightFrom != "" && _weightTo == "" && (weightSubTot >= weightFrom))
        //                        weightStatus = true;
        //                    else
        //                        if (_weightFrom == "" && _weightTo != "" && (weightSubTot <= weightTo))
        //                            weightStatus = true;
        //                        else
        //                            if (_weightFrom == "" && _weightTo == "")
        //                                weightStatus = true;
        //                            else
        //                                weightStatus = false;

        //                if (weightStatus)
        //                {
        //                    dtTotal.Merge(dtFiltered);

        //                    DataRow drSum = dtMain.NewRow();
        //                    if (_subTotalFlag.ToUpper().ToString() == "TRUE")
        //                    {
        //                        switch (_subTotal)
        //                        {
        //                            case "1":
        //                                drSum["CustNo"] = dtFiltered.Rows[0]["CustNo"];
        //                                drSum["CustName"] = dtFiltered.Rows[0]["CustName"];
        //                                drSum["Chain"] = dtFiltered.Rows[0]["Chain"];
        //                                drSum["PriceCd"] = dtFiltered.Rows[0]["PriceCd"];
        //                            break;
        //                            case "2":
        //                                drSum["CustNo"] = dtFiltered.Rows[0]["CustNo"];
        //                                drSum["CustName"] = dtFiltered.Rows[0]["CustName"];
        //                                drSum["Chain"] = dtFiltered.Rows[0]["Chain"];
        //                                drSum["PriceCd"] = dtFiltered.Rows[0]["PriceCd"];
        //                                drSum["OrderSource"] = dtFiltered.Rows[0]["OrderSource"];
        //                            break;
        //                            default:
        //                                drSum["ARDate"] = dtFiltered.Rows[0]["ARDate"];
        //                                drSum["Branch"] = dtFiltered.Rows[0]["Branch"];
        //                                drSum["ShipToCity"] = dtFiltered.Rows[0]["ShipToCity"];
        //                            break;
        //                        }
        //                    }
        //                    else
        //                    {
        //                        dtMain.Merge(dtFiltered);
        //                        drSum["ARDate"] = "Sub-Total";
        //                    }

        //                    drSum["NetSales"] = dtFiltered.Compute("sum(NetSales)", "");
        //                    drSum["NetExp"] = dtFiltered.Compute("sum(NetExp)", "");
        //                    drSum["TotAR"] = dtFiltered.Compute("sum(TotAR)", "");
        //                    drSum["GMDollar"] = dtFiltered.Compute("sum(GMDollar)", "");
        //                    decimal _gmPct = ((Convert.ToDecimal(dtFiltered.Compute("sum(NetSales)", "")) == 0) ? 0 : Convert.ToDecimal(dtFiltered.Compute("sum(GMDollar)", "")) / Convert.ToDecimal(dtFiltered.Compute("sum(NetSales)", "")));
        //                    drSum["GMPct"] = Math.Round(_gmPct * 100, 1);
        //                    drSum["TotWgt"] = dtFiltered.Compute("sum(TotWgt)", "");
        //                    dtMain.Rows.Add(drSum);
        //                }
        //            }
        //        }
        //        catch (Exception ex)
        //        {
        //            throw;
        //        }
        //    }
        //}

        public void BindPrintDialog()
        {
            pdInvoice.PageTitle = "Sales Performance Report";
            string invoiceURL = "InvoiceAnalysis/InvoiceAnalysisByCustNoPreview.aspx?Sort=" + hidSort.Value +
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
                            "&SubTotalFlag=" + Request.QueryString["SubTotalFlag"].ToString() +
                            "&TerritoryCd=" + Request.QueryString["TerritoryCd"].ToString() +
                            "&TerritoryDesc=" + Request.QueryString["TerritoryDesc"].ToString() +
                            "&CSRName=" + Request.QueryString["CSRName"].ToString() +
                            "&CSRNo=" + Request.QueryString["CSRNo"].ToString() +
                            "&RegionalMgr=" + Request.QueryString["RegionalMgr"].ToString() +
                            "&AllCustFlag=" + Request.QueryString["AllCustFlag"].ToString() +
                            "&BuyGroup=" + _buyGroup; 
            pdInvoice.PageUrl = invoiceURL;
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
            //e.Row.Cells[0].CssClass = "locked";
            //e.Row.Cells[1].CssClass = "locked";
            //e.Row.Cells[2].CssClass = "locked";

            if (e.Row.RowType == DataControlRowType.DataRow && e.Row.Cells[0].Text.Trim() == "Sub-Total")
                e.Row.Style.Add(HtmlTextWriterStyle.FontWeight, "bold");

            if (e.Row.RowType == DataControlRowType.Footer && dtTotal.Rows.Count > 0)
            {
                e.Row.Cells[0].Text = "Total"; 
                e.Row.Cells[5].Text = String.Format("{0:c}", dtTotal.Compute("sum(NetSales)", ""));                
                e.Row.Cells[6].Text = String.Format("{0:c}", dtTotal.Compute("sum(GMDollar)", "")); 
                e.Row.Cells[8].Text = String.Format("{0:c}", dtTotal.Compute("sum(GoalGMDol)", ""));
                e.Row.Cells[11].Text = String.Format("{0:c}", dtTotal.Compute("sum(ECommGMDollar)", ""));                

                decimal _gmPct = 0.0M;
                if (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(NetSales)", "")), 0) != 0)
                    _gmPct = Convert.ToDecimal(dtTotal.Compute("sum(GMDollar)", "")) / Convert.ToDecimal(dtTotal.Compute("sum(NetSales)", ""));

                e.Row.Cells[7].Text = Math.Round(_gmPct*100,1).ToString();

                decimal _goalGmPct = 0.0M;
                if (dsInvoiceAnalysis.Tables[1].Rows[0]["GoalGMPct"].ToString() != "")
                    _goalGmPct = Convert.ToDecimal(dsInvoiceAnalysis.Tables[1].Rows[0]["GoalGMPct"].ToString()) * 100;
                e.Row.Cells[9].Text = Math.Round(_goalGmPct, 1).ToString();

                decimal _eCommGmPct = 0.0M;
                if (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ECommSales)", "")), 0) != 0)
                    _eCommGmPct = Convert.ToDecimal(dtTotal.Compute("sum(ECommGMDollar)", "")) / Convert.ToDecimal(dtTotal.Compute("sum(ECommSales)", ""));

                e.Row.Cells[10].Text = String.Format("{0:#,##0.0}", dtTotal.Compute("sum(TotWgt)", ""));
                e.Row.Cells[10].Text = String.Format("{0:#,##0.0}", dtTotal.Compute("sum(TotWgt)", ""));
                e.Row.Cells[12].Text = Math.Round(_eCommGmPct * 100, 1).ToString();
                e.Row.Cells[17].Text = String.Format("{0:#,##}", dtTotal.Compute("sum(WebUserCnt)", ""));
                e.Row.Cells[18].Text = String.Format("{0:#,##}", dtTotal.Compute("sum(InxsUserCnt)", ""));
                e.Row.Cells[19].Text = String.Format("{0:#,##}", dtTotal.Compute("sum(DCUserCnt)", ""));
                e.Row.Cells[20].Text = String.Format("{0:#,##}", dtTotal.Compute("sum(SDKUserCnt)", ""));
                e.Row.Cells[21].Text = String.Format("{0:#,##}", dtTotal.Compute("sum(XrefCnt)", "")); 
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
            BindPrintDialog();
            pnlPrint.Update();
        }

        //protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
        //{
        //    string strURL = "Sort=" + hidSort.Value +
        //                    "&StartDate=" + cldStartDt.SelectedDate.ToShortDateString() +
        //                    "&EndDate=" + cldEndDt.SelectedDate.ToShortDateString() +
        //                    "&OrderType=" + Request.QueryString["OrderType"].ToString() +
        //                    "&Branch=" + Request.QueryString["Branch"].ToString() +
        //                    "&CustNo=" + Request.QueryString["CustNo"].ToString() +
        //                    "&Chain=" + Request.QueryString["Chain"].ToString() +
        //                    "&WeightFrom=" + Request.QueryString["WeightFrom"].ToString() +
        //                    "&WeightTo=" + Request.QueryString["WeightTo"].ToString() +
        //                    "&ShipToState=" + Request.QueryString["ShipToState"].ToString() +
        //                    "&BranchDesc=" + Request.QueryString["BranchDesc"].ToString() +
        //                    "&OrderTypeDesc=" + Request.QueryString["OrderTypeDesc"].ToString() +
        //                    "&SalesPerson=" + Request.QueryString["SalesPerson"].ToString() +
        //                    "&SalesRepNo=" + Request.QueryString["SalesRepNo"].ToString() +
        //                    "&PriceCd=" + Request.QueryString["PriceCd"].ToString() +
        //                    "&OrderSource=" + Request.QueryString["OrderSource"].ToString() +
        //                    "&OrderSourceDesc=" + Request.QueryString["OrderSourceDesc"].ToString() +
        //                    "&ShipMethod=" + Request.QueryString["ShipMethod"].ToString() +
        //                    "&ShipMethodName=" + Request.QueryString["ShipMethodName"].ToString() +
        //                    "&SubTotal=" + Request.QueryString["SubTotal"].ToString() +
        //                    "&SubTotalDesc=" + Request.QueryString["SubTotalDesc"].ToString() +
        //                    "&SubTotalFlag=" + Request.QueryString["SubTotalFlag"].ToString()+
        //                    "&TerritoryCd=" + Request.QueryString["TerritoryCd"].ToString() +
        //                    "&TerritoryDesc=" + Request.QueryString["TerritoryDesc"].ToString() +
        //                    "&CSRName=" + Request.QueryString["CSRName"].ToString() +
        //                    "&CSRNo=" + Request.QueryString["CSRNo"].ToString();

        //    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "PrintReport('" + strURL + "');", true);
        //} 
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
            sortExpression = ((hidSort.Value != "") ? hidSort.Value : "Branch,CustNo asc");
            dsInvoiceAnalysis = invoiceAnalysis.GetInvoiceAnalysisByCustNo(_startDate, _endDate, _orderType, _branchID, _chain, _customerNumber, _territory, _CSRName, _shipToState, _shipment, _salesPerson, _priceCd, _orderSource, _allCustFlag, _regionalMgr, _buyGroup, _rollUpInd);
            dtInvoiceAnalysis = (dsInvoiceAnalysis != null ? dsInvoiceAnalysis.Tables[0] : null);

            if (dtInvoiceAnalysis != null && dtInvoiceAnalysis.Rows.Count > 0)
            {
                //if (_subTotal == "0")
                //{   //No Sub-Totals
                //    dtInvoiceAnalysis.DefaultView.Sort = sortExpression;
                //    dtMain = dtInvoiceAnalysis.DefaultView.ToTable();
                //    dtTotal = dtInvoiceAnalysis.DefaultView.ToTable();
                //}
                //else
                //{   //Sub-Totals
                //    BindSubTot();
                //}
                dtInvoiceAnalysis.DefaultView.Sort = sortExpression;
                dtMain = dtInvoiceAnalysis.DefaultView.ToTable();
                dtTotal = dtInvoiceAnalysis.DefaultView.ToTable();

                headerContent = "<table border='1'>";

                headerContent += "<tr><th colspan='22' style='color:blue' align=left><center>Sales Performance by Filter Report</center></th></tr><tr><td></td>" +

                                 "<td colspan='3'><b>Beginning Date: " + cldStartDt.SelectedDate.ToShortDateString() + "</b></td>" +
                                 "<td colspan='3'><b>Ending Date: " + cldEndDt.SelectedDate.ToShortDateString() + "</b></td>" +
                                 "<td colspan='3'><b>" + lblOrderType.Text + "</b></td>" +
                                 "<td colspan='3'><b>Branch: " + Request.QueryString["BranchDesc"].ToString() + "</b></td>" +
                                 "<td colspan='8'><b>" + lblChain.Text + "</b></td><td></td></tr><tr><td></td>" +
                                 
                                 "<td colspan='3'><b>" + lblCustomerNumber.Text + "</b></td>" +
                                 "<td colspan='3'><b>" + lblTerritory.Text + "</b></td>" +
                                 //"<td colspan='2'><b>" + lblState.Text + "</b></td>" +
                                 "<td colspan='3'><b>" + lblCSR.Text + "</b></td>" +
                                 "<td colspan='3'><b>" + lblSalesPerson.Text + "</b></td>" +
                                 "<td colspan='8'><b>" + lblRegionalMgr.Text + "</b></td><tr><td></td>" +

                                 "<td colspan='3'><b>" + lblShipment.Text + "</b></td>" +
                                 "<td colspan='3'><b>" + lblPriceCd.Text + "</b></td>" +
                                 "<td colspan='3'><b>" + lblOrderSource.Text + "</b></td>" +
                                 "<td colspan='3'><b>Run By: " + Session["UserName"].ToString() + "</b></td>" +
                                 "<td colspan='8'><b>Run Date: " + DateTime.Now.ToShortDateString() + "</b></td><td></td></tr>" +
                                 "<tr><th colspan='22' style='color:blue' align=left></th></tr>";

                headerContent += "<tr>" +
                                 "<th width='70'  nowrap align='center'>Branch</td>" +
                                 "<th width='60'  nowrap align='center'>No</th>" +
                                 "<th width='250' nowrap align='center'>Name</th>" +
                                 "<th width='60'  nowrap align='center'>Chain</th>" +
                                 "<th width='60'  nowrap align='center'>Price Cd</th>" +
                                 "<th width='80'  nowrap align='center'>Net Sales</th>" +
                                 "<th width='80'  nowrap align='center'>GM $</th>" +
                                 "<th width='80'  nowrap align='center'>GM %</th>" +
                                 "<th width='80'  nowrap align='center'>Goal Sales $</th>" +
                                 "<th width='80'  nowrap align='center'>Goal GM %</th>" +
                                 "<th width='80'  nowrap align='center'>Tot Wght</th>" +
                                 "<th width='80'  nowrap align='center'>eCom GM$</th>" +
                                 "<th width='80'  nowrap align='center'>eCom GM%</th>" +
                                 "<th width='80'  nowrap align='center'>State Code</th>" +
                                 "<th width='80'  nowrap align='center'>Territory Code</th>" +
                                 "<th width='80'  nowrap align='center'>Inside Rep</th>" +
                                 "<th width='80'  nowrap align='center'>Outside Rep</th>" +
                                 "<th width='50'  nowrap align='center'># Web</th>" +
                                 "<th width='40'  nowrap align='center'># IxS</th>" +
                                 "<th width='40'  nowrap align='center'># DC</th>" +
                                 "<th width='40'  nowrap align='center'># SDK</th>" +
                                 "<th width='60'  nowrap align='center'># Xref</th>" +
                                 "</tr>";

                if (dtMain.Rows.Count > 0)
                {
                    foreach (DataRow drSalesAnalysis in dtMain.Rows)
                    {
                        //if (drSalesAnalysis["ARDate"].ToString() == "Sub-Total")
                        //    excelContent += " <tr style='font-weight:bold'>";
                        //else
                        //    excelContent += " <tr>";

                        excelContent += "<tr><td nowrap align='center'>" +
                                        drSalesAnalysis["Branch"] + "</td><td nowrap>" +
                                        drSalesAnalysis["CustNo"] + "</td><td nowrap>" +
                                        drSalesAnalysis["CustName"] + "</td><td nowrap align='center'>" +
                                        drSalesAnalysis["Chain"] + "</td><td nowrap align='center'>" +
                                        drSalesAnalysis["PriceCd"] + "</td><td nowrap align='center'>" +
                                        string.Format("{0:c}", drSalesAnalysis["NetSales"]) + "</td><td nowrap>" +                                        
                                        string.Format("{0:c}", drSalesAnalysis["GMDollar"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0.0}", drSalesAnalysis["GMPct"]) + "</td><td nowrap>" +
                                        string.Format("{0:c}", drSalesAnalysis["GoalGMDol"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0.0}", drSalesAnalysis["GoalGMPct"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0.0}", drSalesAnalysis["TotWgt"]) + "</td><td nowrap>" +
                                        string.Format("{0:c}", drSalesAnalysis["ECommGMDollar"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0.0}", drSalesAnalysis["ECommGMPct"]) + "</td><td nowrap>" +
                                        drSalesAnalysis["State"] + "</td><td nowrap>" +
                                        drSalesAnalysis["SalesTerritory"] + "</td><td nowrap>" +
                                        drSalesAnalysis["InsideRep"] + "</td><td nowrap>" +
                                        drSalesAnalysis["OutsideRep"] + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", drSalesAnalysis["WebUserCnt"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", drSalesAnalysis["InxsUserCnt"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", drSalesAnalysis["DCUserCnt"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", drSalesAnalysis["SDKUserCnt"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0}", drSalesAnalysis["XrefCnt"]) + "</td>" +
                                        "</tr>";
                    }

                    decimal _gmPct = 0.0M;
                    if (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(NetSales)", "")), 0) != 0)
                        _gmPct = Convert.ToDecimal(dtTotal.Compute("sum(GMDollar)", "")) / Convert.ToDecimal(dtTotal.Compute("sum(NetSales)", ""));

                    decimal _eComGmPct = 0.0M;
                    if (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ECommSales)", "")), 0) != 0)
                        _eComGmPct = Convert.ToDecimal(dtTotal.Compute("sum(ECommGMDollar)", "")) / Convert.ToDecimal(dtTotal.Compute("sum(ECommSales)", ""));

                    decimal _goalGmPct = 0.0M;
                    if (dsInvoiceAnalysis.Tables[1].Rows[0]["GoalGMPct"].ToString() != "")
                        _goalGmPct = Convert.ToDecimal(dsInvoiceAnalysis.Tables[1].Rows[0]["GoalGMPct"].ToString()) * 100;
                                        
                    footerContent = "<tr style='font-weight:bold'><td align='center'>Total</td><td colspan='4'></td><td>" +
                                        String.Format("{0:c}", dtTotal.Compute("sum(NetSales)", "")) + "</td><td>" +
                                        String.Format("{0:c}", dtTotal.Compute("sum(GMDollar)", "")) + "</td><td>" +
                                        Math.Round(_gmPct * 100, 1).ToString() + "</td><td>" +
                                        String.Format("{0:c}", dtTotal.Compute("sum(GoalGMDol)", "")) + "</td><td>" +
                                        String.Format("{0:#,##0.0}", _goalGmPct) + "</td><td>" +
                                        String.Format("{0:#,##0.0}", dtTotal.Compute("sum(TotWgt)", "")) + "</td><td>" +
                                        String.Format("{0:c}", dtTotal.Compute("sum(ECommGMDollar)", "")) + "</td><td>" +
                                        Math.Round(_eComGmPct * 100, 1).ToString() + "</td>" +
                                        "<td colspan='4'></td><td>" +
                                        String.Format("{0:#,##0}", dtTotal.Compute("sum(WebUserCnt)", "")) + "</td><td>" +
                                        String.Format("{0:#,##0}", dtTotal.Compute("sum(InxsUserCnt)", "")) + "</td><td>" +
                                        String.Format("{0:#,##0}", dtTotal.Compute("sum(DCUserCnt)", "")) + "</td><td>" +
                                        String.Format("{0:#,##0}", dtTotal.Compute("sum(SDKUserCnt)", "")) + "</td><td>" +
                                        String.Format("{0:#,##0}", dtTotal.Compute("sum(XrefCnt)", "")) + "</td>" +
                                        "</tr></table>";
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