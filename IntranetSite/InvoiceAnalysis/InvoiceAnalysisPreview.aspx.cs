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
    public partial class InvoiceAnalysisPreview : System.Web.UI.Page
    {
        #region Local variables
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

        #region Page load event handlers
        protected void Page_Load(object sender, EventArgs e)
        {
            SystemCheck systemCheck = new SystemCheck();
            systemCheck.SessionCheck();

            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(InvoiceAnalysisPreview));

            _startDate = Request.QueryString["StartDate"].ToString();
            _endDate = Request.QueryString["EndDate"].ToString();
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
                lblBeginDate.Text = "Beginning Date: " + Request.QueryString["StartDate"].ToString();
                lblEndDate.Text = "Ending Date: " + Request.QueryString["EndDate"].ToString();
                lblOrderType.Text = "Order Type: " + Request.QueryString["OrderTypeDesc"].ToString();
                lblBranch.Text = "Branch: " + Request.QueryString["BranchDesc"].ToString();
                lblShipment.Text = "Ship Meth: " + (_shipment == "" ? "ALL" : Request.QueryString["ShipMethodName"].ToString());
                lblChain.Text = "Chain: " + (_chain == "" ? "ALL" : _chain);
                lblCustomerNumber.Text = "Customer # " + (_customerNumber == "" ? "ALL" : _customerNumber);
                if (_weightFrom == "" && _weightTo == "")
                    lblWeight.Text = "Weight Range: ALL";
                else
                    lblWeight.Text = "Weight Range: " + (_weightFrom == "" ? "-" : _weightFrom) + " To  " + (_weightTo == "" ? "-" : _weightTo);
                lblState.Text = "Ship To State: " + (_shipToState == "" ? "ALL" : _shipToState);
                lblSalesPerson.Text = "Sales Person: " + (_salesPerson == "" ? "ALL" : _salesPerson);
                lblPriceCd.Text = "Price Code: " + (_priceCd == "" ? "ALL" : invoiceAnalysis.GetListDesc("CustPriceCd", _priceCd));
                lblOrderSource.Text = "Order Source: " + (_orderSourceDesc == "" ? invoiceAnalysis.GetListDesc("SOEOrderSource", _orderSource) : _orderSourceDesc);
                lblSubTot.Text = "Sub-Totals: " + _subTotalDesc;
                if (_subTotalFlag.ToUpper().ToString() == "TRUE")
                    lblSubTot.Text += " (Sub-Totals ONLY)";

                BindDataGrid();
            }
        }
        #endregion

        #region Developer Methods
        public void BindDataGrid()
        {
            sortExpression = ((Request.QueryString["Sort"].ToString() != "") ? Request.QueryString["Sort"].ToString() : "ARDate asc");
            dtInvoiceAnalysis = invoiceAnalysis.GetInvoiceAnalysis(_startDate, _endDate, _orderType, _branchID, _chain, _customerNumber, _weightFrom, _weightTo, _shipToState, _shipment, _salesRepNo, _priceCd, _orderSource);

            if (dtInvoiceAnalysis != null && dtInvoiceAnalysis.Rows.Count > 0)
            {
                lblStatus.Visible = false;

                if (_subTotal == "0")
                {   //No Sub-Totals
                    BindNoTot();
                }
                else
                {   //Sub-Totals
                    BindSubTot();
                    dvInvoiceAnalysis.DataSource = dtMain.DefaultView.ToTable();
                }
                dvInvoiceAnalysis.DataBind();
            }
            else
            {
                lblStatus.Visible = true;
                lblStatus.Text = "No Records Found";
            }
        }

        public void BindNoTot()
        {
            sortExpression = ((Request.QueryString["Sort"].ToString() != "") ? Request.QueryString["Sort"].ToString() : "ARDate ASC");
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

        #region Event Handlers
        protected void dvInvoiceAnalysis_RowDataBound(object sender, GridViewRowEventArgs e)
        {
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

                e.Row.Cells[15].Text = Math.Round(_gmPct*100, 1).ToString();
                e.Row.Cells[16].Text = String.Format("{0:#,##0.0}", dtTotal.Compute("sum(TotWgt)", ""));
            }
        }
        #endregion
    
    }// End Class
}// End Namespace