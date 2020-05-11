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
using System.Data.SqlClient;
using System.Data.Sql;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.InvoiceRegister;
using System.Text.RegularExpressions;

public partial class BookingReport : System.Web.UI.Page
{
    # region Variable Declaration
    private string sortExpression = string.Empty;
    string sort = "";
    decimal minMargin = 0;
    decimal maxMargin = 100;
    DataTable dtInvoice = new DataTable();
    DataTable _dtTemp = new DataTable();
    //DataTable dtDate = new DataTable();
    DataTable dtMargin = new DataTable();
    DataTable dtInvoiceBranch = new DataTable();
    //DataTable dtBookingReportOrgData = new DataTable();
    PFC.Intranet.InvoiceRegister.BookingReport bookingReport = new PFC.Intranet.InvoiceRegister.BookingReport();
    DataTable dtInvoiceExcel = new DataTable();
    DataTable dtCSR = new DataTable();
    DataTable dtCustNo = new DataTable();
    GridView dv = new GridView();
    int totalBranchFound = 0;

    string StartDate = "";
    string EndDate = "";
    string BranchID = "";
    string LineType = "";
    string SubTotalType = "";
    string CustomerNo = "";
    string CSRName = "";
    string SubTotalDesc = "";
    string BranchDesc = "";
    string LineTypeDesc = "";
    
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(BookingReport));
        Session["PrintContent"] = "";

        StartDate = Request.QueryString["StartDate"].ToString();
        EndDate = Request.QueryString["EndDate"].ToString();
        BranchID = Request.QueryString["Branch"].ToString();
        LineType = Request.QueryString["LineType"].ToString();
        SubTotalType = (Request.QueryString["SubTotalType"].ToString() == "1" ? "ALL" : Request.QueryString["SubTotalType"].ToString());
        CustomerNo = (Request.QueryString["CustNo"].ToString().Trim() == "" ? "ALL" : Request.QueryString["CustNo"].ToString().Trim());
        CSRName = (Request.QueryString["CSR"].ToString().Trim() == "" ? "ALL" : Request.QueryString["CSR"].ToString().Trim());
        SubTotalDesc = Request.QueryString["SubTotalDesc"].ToString();
        BranchDesc = Request.QueryString["BranchDesc"].ToString();
        LineTypeDesc = Request.QueryString["LineTypeDesc"].ToString();

        if (!IsPostBack)
        {
            hidFileName.Value = "BookingReport" + Session["SessionID"].ToString() + ".xls";            

            lblStartDt.Text = StartDate;
            lblEndDt.Text = EndDate;
            lblBranch.Text = BranchDesc;
            lblLineType.Text = LineTypeDesc;
            lblSubTotalType.Text = SubTotalDesc;
            lblCSR.Text = CSRName;
            lblCustNo.Text = CustomerNo;

            BindDataGrid();            
        }

        if (hidShowMode.Value == "Show")
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoW", "ShowPanel();", true);
        else if (hidShowMode.Value == "ShowL")
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoWL", "ShowHide('Show');", true);
        else if (hidShowMode.Value == "HideL")
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoWL", "ShowHide('Hide');", true);

    }

    private void BindDataGrid()
    {
        dtMargin = bookingReport.GetMarginValue();
        if (dtMargin != null && dtMargin.Rows.Count > 0)
        {
            maxMargin = Convert.ToDecimal(dtMargin.Rows[1]["AppOptionValue"].ToString()) * 100;
            minMargin = Convert.ToDecimal(dtMargin.Rows[0]["AppOptionValue"].ToString()) * 100;
            ViewState["MaxMargin"] = maxMargin.ToString();
            ViewState["MinMargin"] = minMargin.ToString();
        }

        ViewState["StartDate"] = StartDate;
        ViewState["EndDate"] = EndDate;
        bool _onlyLowMarginLn = (LineType == "ALL" ? false : true);

        dtInvoice = bookingReport.GetBookingReportData(StartDate, EndDate, CustomerNo.Trim(), CSRName.Trim(), ViewState["MinMargin"].ToString(), ViewState["MaxMargin"].ToString(), _onlyLowMarginLn, BranchID);
        // Session["BookingReport"] = dtInvoice;
        // dtBookingReportOrgData = dtInvoice;
        

        if (dtInvoice != null && dtInvoice.Rows.Count > 0)
        {
           // dtInvoice.DefaultView.RowFilter = (BranchID != "ALL") ? "BranchSls='" + BranchID + "'" : "";

            if (dtInvoice.DefaultView.ToTable(true, "BranchSls").Rows.Count > 0)
            {
                totalBranchFound = dtInvoice.DefaultView.ToTable(true, "BranchSls").Rows.Count - 1;
                gvBranch.DataSource = dtInvoice.DefaultView.ToTable(true, "BranchSls");
                dvPager.InitPager(gvBranch, 1);

                gvBranch.Visible = true;
                lblStatus.Visible = false;
                lblMessage.Visible = false;
                dvPager.Visible = true;
            }
            else
            {
                gvBranch.Visible = false;
                lblStatus.Visible = true;
                dvPager.Visible = false;
                DisplaStatusMessage("No Records Found ", "Fail");
            }
        }
        else
        {
            gvBranch.Visible = false;
            lblStatus.Visible = true;
            dvPager.Visible = false;
            DisplaStatusMessage("No Records Found ", "Fail");
        }
        upnlGrid.Update();
        pnlBranch.Update();
        pnlProgress.Update();
        if (hidShowMode.Value == "Show")
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoW", "ShowPanel();", true);
        else if (hidShowMode.Value == "ShowL")
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoWL", "ShowHide('Show');", true);
        else if (hidShowMode.Value == "HideL")
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoWL", "ShowHide('Hide');", true);

    }

    private void DisplaStatusMessage(string message, string messageType)
    {
        lblMessage.Visible = true;
        if (messageType.ToLower() == "success")
        {
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = message;
        }
        else if (messageType.ToLower() == "fail")
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = message;
        }
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        gvBranch.PageIndex = dvPager.GotoPageNumber;
        sort = "sort";
        BindDataGrid();
    }

    protected void gvBranch_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            GridView gvInvoiceRegister = e.Row.FindControl("gvInvoiceRegister") as GridView;
            HiddenField hidBranchID = e.Row.FindControl("hidBranchID") as HiddenField;
            Label lbldgMessage = e.Row.FindControl("lbldgMessage") as Label;
            
            dtInvoice.DefaultView.RowFilter = "BranchSls='" + hidBranchID.Value + "'" + BindAdvanceWhereClause();
            dtInvoiceBranch = dtInvoice.DefaultView.ToTable();

            if (dtInvoiceBranch.Rows.Count > 0)
            {
                DataRow drSum;
                if (e.Row.RowIndex == 0)
                    dtInvoiceExcel = dtInvoiceBranch.Clone();
                if (SubTotalType != "ALL")
                {
                    DataTable dtGroup = dtInvoiceBranch.DefaultView.ToTable(true, SubTotalType);
                    DataTable dtMain = dtInvoiceBranch.Clone();
                    foreach (DataRow dr in dtGroup.Rows)
                    {
                        try
                        {
                            dtInvoiceBranch.DefaultView.RowFilter = SubTotalType + "='" + dr[SubTotalType].ToString() + "'";
                            DataTable dtFiltered = dtInvoiceBranch.DefaultView.ToTable();

                            // dtTotal.Merge(dtFiltered);
                            dtMain.Merge(dtFiltered);
                            drSum = dtMain.NewRow();

                            drSum["ItemDescription"] = SubTotalType + " Totals";
                            drSum["Qty"] = dtFiltered.Compute("sum(Qty)", "");
                            drSum["ExtendedPrice"] = dtFiltered.Compute("sum(ExtendedPrice)", "");
                            drSum["ExtendedCost"] = dtFiltered.Compute("sum(ExtendedCost)", "");
                            drSum["ExtendedWeight"] = dtFiltered.Compute("sum(ExtendedWeight)", "");
                            drSum["MarginPct"] = ((Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")), 1)) * 100, 1));
                            drSum["SellPerLb"] = ((Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedWeight)", "")));
                            drSum[SubTotalType] = dr[SubTotalType];
                            if (SubTotalType == "SellToCustomerNumber")
                                drSum["SellToCustomerName"] = dtFiltered.Rows[0]["SellToCustomerName"];

                            //if (Convert.ToDecimal(dtFiltered.Compute("sum(AltNetUnitPrice)", "")) == 0)
                            //{
                            //    drSum["DisplayRplGMPct"] = 0;
                            //}
                            //else if (Convert.ToDecimal(dtFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                            //{
                            //    drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(AltNetUnitCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(AltNetUnitPrice)", "")), 1)) * 100, 1));
                            //}
                            //else
                            //{
                            //    drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(AltNetUnitPrice)", "")), 1)) * 100, 1));
                            //}

                            if (Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", "")) == 0)
                            {
                                drSum["DisplayRplGMPct"] = 0;
                            }
                            else if (Convert.ToDecimal(dtFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                            {
                                drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                            }
                            else
                            {
                                drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                            }

                            dtMain.Rows.Add(drSum);
                        }
                        catch (Exception ex)
                        {
                        }
                    }
                    dtInvoiceExcel.Merge(dtMain);
                    gvInvoiceRegister.DataSource = dtMain;
                    gvInvoiceRegister.DataBind();
                }
                else
                {
                    DataTable dtRepGroup = dtInvoiceBranch.DefaultView.ToTable(true, "CustomerSrvcRepName");
                    DataTable dtMain = dtInvoiceBranch.Clone();
                    foreach (DataRow dr in dtRepGroup.Rows)
                    {
                        try
                        {
                            dtInvoiceBranch.DefaultView.RowFilter = "CustomerSrvcRepName='" + dr["CustomerSrvcRepName"].ToString() + "'";
                            DataTable dtRepFiltered = dtInvoiceBranch.DefaultView.ToTable();
                            DataTable dtCustomerGroup = dtInvoiceBranch.DefaultView.ToTable(true, "SellToCustomerNumber");
                            foreach (DataRow drCustomer in dtCustomerGroup.Rows)
                            {
                                dtRepFiltered.DefaultView.RowFilter = "SellToCustomerNumber='" + drCustomer["SellToCustomerNumber"].ToString() + "'";
                                DataTable dtCustomerFiltered = dtRepFiltered.DefaultView.ToTable();
                                DataTable dtInvoiceGroup = dtCustomerFiltered.DefaultView.ToTable(true, "OrderNo");
                                foreach (DataRow drInvoice in dtInvoiceGroup.Rows)
                                {
                                    dtCustomerFiltered.DefaultView.RowFilter = "OrderNo='" + drInvoice["OrderNo"].ToString() + "'";
                                    DataTable dtInvoiceFiltered = dtCustomerFiltered.DefaultView.ToTable();

                                    dtMain.Merge(dtInvoiceFiltered);
                                    drSum = dtMain.NewRow();

                                    drSum["ItemDescription"] = "Order Totals";
                                    drSum["Qty"] = dtInvoiceFiltered.Compute("sum(Qty)", "");
                                    drSum["ExtendedPrice"] = dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "");
                                    drSum["ExtendedCost"] = dtInvoiceFiltered.Compute("sum(ExtendedCost)", "");
                                    drSum["ExtendedWeight"] = dtInvoiceFiltered.Compute("sum(ExtendedWeight)", "");
                                    drSum["MarginPct"] = ((Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "")), 1)) * 100, 1));
                                    //drSum["DisplayRplGMPct"] = ((Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
                                    drSum["SellPerLb"] = ((Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedWeight)", "")));
                                    drSum["OrderNo"] = drInvoice["OrderNo"];

                                    if (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")) == 0)
                                    {
                                        drSum["DisplayRplGMPct"] = 0;
                                    }
                                    else if (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                    {
                                        drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                                    }
                                    else
                                    {
                                        drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                                    }
                                    dtMain.Rows.Add(drSum);
                                    //Response.Write( );
                                }

                                drSum = dtMain.NewRow();
                                drSum["ItemDescription"] = "Sell-To Customer Totals";
                                drSum["Qty"] = dtCustomerFiltered.Compute("sum(Qty)", "");
                                drSum["ExtendedPrice"] = dtCustomerFiltered.Compute("sum(ExtendedPrice)", "");
                                drSum["ExtendedCost"] = dtCustomerFiltered.Compute("sum(ExtendedCost)", "");
                                drSum["ExtendedWeight"] = dtCustomerFiltered.Compute("sum(ExtendedWeight)", "");
                                drSum["MarginPct"] = ((Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedPrice)", "")), 1)) * 100, 1));
                                //drSum["DisplayRplGMPct"] = ((Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
                                drSum["SellPerLb"] = ((Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedWeight)", "")));
                                drSum["SellToCustomerNumber"] = dtCustomerFiltered.Rows[0]["SellToCustomerNumber"];
                                drSum["SellToCustomerName"] = dtCustomerFiltered.Rows[0]["SellToCustomerName"];
                                
                                //if (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(AltNetUnitPrice)", "")) == 0)
                                //{
                                //    drSum["DisplayRplGMPct"] = 0;
                                //}
                                //else if (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                //{
                                //    drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(AltNetUnitCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(AltNetUnitPrice)", "")), 1)) * 100, 1));
                                //}
                                //else
                                //{
                                //    drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(AltNetUnitPrice)", "")), 1)) * 100, 1));
                                //}                                

                                if (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")) == 0)
                                {
                                    drSum["DisplayRplGMPct"] = 0;
                                }
                                else if (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                {
                                    drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                                }
                                else
                                {
                                    drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                                }
                                dtMain.Rows.Add(drSum);

                            }
                            drSum = dtMain.NewRow();
                            drSum["ItemDescription"] = "Customer Service Representative Totals";
                            drSum["Qty"] = dtRepFiltered.Compute("sum(Qty)", "");
                            drSum["ExtendedPrice"] = dtRepFiltered.Compute("sum(ExtendedPrice)", "");
                            drSum["ExtendedCost"] = dtRepFiltered.Compute("sum(ExtendedCost)", "");
                            drSum["ExtendedWeight"] = dtRepFiltered.Compute("sum(ExtendedWeight)", "");
                            drSum["MarginPct"] = ((Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedPrice)", "")), 1)) * 100, 1));
                            //drSum["DisplayRplGMPct"] = ((Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
                            drSum["SellPerLb"] = ((Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedWeight)", "")));
                            drSum["CustomerSrvcRepName"] = dtRepFiltered.Rows[0]["CustomerSrvcRepName"];
                            //if (Convert.ToDecimal(dtRepFiltered.Compute("sum(AltNetUnitPrice)", "")) == 0)
                            //{
                            //    drSum["DisplayRplGMPct"] = 0;
                            //}
                            //else if (Convert.ToDecimal(dtRepFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                            //{
                            //    drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(AltNetUnitCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(AltNetUnitPrice)", "")), 1)) * 100, 1));
                            //}
                            //else
                            //{
                            //    drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(AltNetUnitPrice)", "")), 1)) * 100, 1));
                            //}

                            if (Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")) == 0)
                            {
                                drSum["DisplayRplGMPct"] = 0;
                            }
                            else if (Convert.ToDecimal(dtRepFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                            {
                                drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                            }
                            else
                            {
                                drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                            }

                            dtMain.Rows.Add(drSum);

                        }
                        catch (Exception ex)
                        {
                        }
                    }

                    drSum = dtMain.NewRow();
                    drSum["ItemDescription"] = "Sales Branch Totals";
                    drSum["Qty"] = dtInvoiceBranch.Compute("sum(Qty)", "");
                    drSum["ExtendedPrice"] = dtInvoiceBranch.Compute("sum(ExtendedPrice)", "");
                    drSum["ExtendedCost"] = dtInvoiceBranch.Compute("sum(ExtendedCost)", "");
                    drSum["ExtendedWeight"] = dtInvoiceBranch.Compute("sum(ExtendedWeight)", "");
                    drSum["MarginPct"] = ((Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedPrice)", "")), 1)) * 100, 1));
                    //drSum["DisplayRplGMPct"] = ((Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(DisplayRplCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
                    drSum["SellPerLb"] = ((Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedWeight)", "")));
                    drSum["BranchSls"] = dtInvoiceBranch.Rows[0]["BranchSls"];
                    //if (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(AltNetUnitPrice)", "")) == 0)
                    //{
                    //    drSum["DisplayRplGMPct"] = 0;
                    //}
                    //else if (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(DisplayRplCost)", "")) == 0)
                    //{
                    //    drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(AltNetUnitCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(AltNetUnitPrice)", "")), 1)) * 100, 1));
                    //}
                    //else
                    //{
                    //    drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(DisplayRplCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(AltNetUnitPrice)", "")), 1)) * 100, 1));
                    //}

                    if (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")) == 0)
                    {
                        drSum["DisplayRplGMPct"] = 0;
                    }
                    else if (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(DisplayRplCost)", "")) == 0)
                    {
                        drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                    }
                    else
                    {
                        drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                    }

                    dtMain.Rows.Add(drSum);

                    gvInvoiceRegister.DataSource = dtMain;
                    gvInvoiceRegister.DataBind();
                    dtInvoiceExcel.Merge(dtMain);
                }
            }
            else
            {
                lbldgMessage.Text = lbldgMessage.Text + " For Branch# " + hidBranchID.Value;
                lbldgMessage.Visible = true;

            }
        }


    }

    protected void gvInvoiceRegister_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        try
        {
            if (e.Row.RowType == DataControlRowType.Header)
            {
                e.Row.Cells[4].ColumnSpan = 2;
                e.Row.Cells[4].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Branch</center></td></tr><tr><td width='50' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('BranchSls');\">Sls</div></center></td><td width='50' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                            "<Div onclick=\"javascript:BindValue('BranchShip');\">Ship</div></td></tr></table>";

                e.Row.Cells[5].Visible = false;

                e.Row.Cells[7].ColumnSpan = 2;
                e.Row.Cells[7].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Net Unit</center></td></tr><tr><td width='35' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('AltNetUnitPrice');\">Price</div></center></td><td width='30' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                            "<Div onclick=\"javascript:BindValue('AltNetUnitCost');\">Cost</div></td></tr></table>";

                e.Row.Cells[8].Visible = false;

                e.Row.Cells[9].ColumnSpan = 3;
                e.Row.Cells[9].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>Extended</center></td></tr><tr><td width='40' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                            "<Div onclick=\"javascript:BindValue('ExtendedPrice');\">Price</div></center></td><td width='40' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                            "<Div onclick=\"javascript:BindValue('ExtendedCost');\">Cost</div></td> <td width='40' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                            "<Div onclick=\"javascript:BindValue('ExtendedWeight');\">Weight</div></td></tr></table>";
                e.Row.Cells[10].Visible = e.Row.Cells[11].Visible = false;

                e.Row.Cells[12].Visible = false;
                e.Row.Cells[13].ColumnSpan = 2;
                e.Row.Cells[13].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Margin % </center></td></tr><tr><td width='40' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('MarginPct');\">SAVG</div></center></td><td width='40' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                            "<Div onclick=\"javascript:BindValue('DisplayRplGMPct');\">Repl</div></td></tr></table>";


                e.Row.Cells[15].ColumnSpan = 2;
                e.Row.Cells[15].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Sell-To Customer </center></td></tr><tr><td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('AltNetUnitPrice');\">Number</div></center></td><td width='200' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                            "<Div onclick=\"javascript:BindValue('AltNetUnitCost');\">Name</div></td></tr></table>";
                e.Row.Cells[16].Visible = false;
            }

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[12].HorizontalAlign = HorizontalAlign.Right;
                //e.Row.Cells[12].Text =Convert.ToString (Convert.ToDecimal(e.Row.Cells[12].Text) * 100);

                if (e.Row.Cells[0].Text == "&nbsp;")
                    e.Row.Font.Bold = true;
                else
                {
                    if (((Convert.ToDecimal(e.Row.Cells[12].Text)) < minMargin && (Convert.ToDecimal(e.Row.Cells[12].Text)) != minMargin) || ((Convert.ToDecimal(e.Row.Cells[12].Text)) > maxMargin && (Convert.ToDecimal(e.Row.Cells[12].Text)) != maxMargin))
                    {
                        e.Row.Cells[12].Text += "*";
                        e.Row.Cells[12].ForeColor = System.Drawing.Color.Red;
                        e.Row.Cells[12].Font.Bold = true;
                    }
                    if (((Convert.ToDecimal(e.Row.Cells[13].Text)) < minMargin && (Convert.ToDecimal(e.Row.Cells[13].Text)) != minMargin) || ((Convert.ToDecimal(e.Row.Cells[13].Text)) > maxMargin && (Convert.ToDecimal(e.Row.Cells[13].Text)) != maxMargin))
                    {
                        e.Row.Cells[13].Text += "*";
                        e.Row.Cells[13].ForeColor = System.Drawing.Color.Red;
                        e.Row.Cells[13].Font.Bold = true;
                    }
                }
            }

            if (e.Row.RowType == DataControlRowType.Footer)
            {
                DataTable dtTotal = (BranchID == "ALL") ? dtInvoice.Copy() : dtInvoiceBranch.Copy();
                if (gvBranch.PageIndex == totalBranchFound)
                {
                    e.Row.Cells[3].Text = "Grand Total";
                    e.Row.Cells[6].Text = string.Format("{0:#,##0}", dtTotal.Compute("sum(Qty)", ""));
                    e.Row.Cells[9].Text = string.Format("{0:#,##0.00}", dtTotal.Compute("sum(ExtendedPrice)", ""));
                    e.Row.Cells[10].Text = string.Format("{0:#,##0.00}", dtTotal.Compute("sum(ExtendedCost)", ""));
                    e.Row.Cells[11].Text = string.Format("{0:#,##0.00}", dtTotal.Compute("sum(ExtendedWeight)", ""));

                    e.Row.Cells[12].Text = string.Format("{0:#,##0.0}", ((Convert.ToDecimal(dtTotal.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ExtendedCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ExtendedPrice)", "")), 1)) * 100, 1)));
                    //e.Row.Cells[13].Text = string.Format("{0:#,##0.0}", ((Convert.ToDecimal(dtTotal.Compute("sum(NetUnitPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(DisplayRplGMPct)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1)));
                    Decimal MarginRplPct = 0.0M;
                    //if (Convert.ToDecimal(dtTotal.Compute("sum(AltNetUnitPrice)", "")) == 0)
                    //{
                    //    MarginRplPct = 0;
                    //}
                    //else if (Convert.ToDecimal(dtTotal.Compute("sum(DisplayRplCost)", "")) == 0)
                    //{
                    //    MarginRplPct = (Math.Round((Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(AltNetUnitCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(AltNetUnitPrice)", "")), 1)) * 100, 1));
                    //}
                    //else
                    //{
                    //    MarginRplPct = (Math.Round((Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(DisplayRplCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(AltNetUnitPrice)", "")), 1)) * 100, 1));
                    //}

                    if (Convert.ToDecimal(dtTotal.Compute("sum(NetUnitPrice)", "")) == 0)
                    {
                        MarginRplPct = 0;
                    }
                    else if (Convert.ToDecimal(dtTotal.Compute("sum(DisplayRplCost)", "")) == 0)
                    {
                        MarginRplPct = (Math.Round((Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtTotal.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                    }
                    else
                    {
                        MarginRplPct = (Math.Round((Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtTotal.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                    }

                    e.Row.Cells[13].Text = string.Format("{0:#,##0.0}", MarginRplPct);
                    e.Row.Cells[14].Text = string.Format("{0:#,##0.00}", ((Convert.ToDecimal(dtTotal.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dtTotal.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtTotal.Compute("sum(ExtendedWeight)", ""))));
                }
                else
                    e.Row.Visible = false;
            }
        }
        catch (Exception ex)
        {
            
            throw;
        }
    }

    protected void btnSort_Click(object sender, EventArgs e)
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
        sort = "sort";
        BindDataGrid();
    }

    protected void gvInvoiceRegister_Sorting(object sender, GridViewSortEventArgs e)
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
        sort = "sort";
        BindDataGrid();

    }

    private string BindAdvanceWhereClause()
    {
        string _whereClause = "";
        if (CSRName != "ALL")
            _whereClause += " and CustomerSrvcRepName='" + CSRName + "'";
        if (CustomerNo != "ALL")
            _whereClause += " and SellToCustomerNumber='" + CustomerNo + "'";

        return _whereClause;
    }
    
    protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
    {
        dtInvoiceExcel = new DataTable();
        string headerContent = string.Empty;
        string excelContent = string.Empty;

        StartDate = ViewState["StartDate"].ToString();
        EndDate = ViewState["EndDate"].ToString();
        string _customerNo = CustomerNo;
        string _CSRName = CSRName;
        bool _onlyLowMarginLn = (LineType == "ALL" ? false : true);

        DataTable _dtTemp = bookingReport.GetBookingReportData(StartDate, EndDate, _customerNo, _CSRName, ViewState["MinMargin"].ToString(), ViewState["MaxMargin"].ToString(), _onlyLowMarginLn, BranchID);
        
        dtInvoiceExcel = GetExcelTable(_dtTemp);

        headerContent = "<table border='0' width=100% cellpadding=1 cellspacing=0 >";

        headerContent += "<tr><th colspan='18' style='color:blue' align=left><center>Booking Report</center></th></tr>";
        headerContent += "<tr><td colspan='2' style='padding-bottom:15px;' ><b>StartDate :" + StartDate + "</b></td><td  colspan='2' style='padding-bottom:15px;' ><b>End Date:" + EndDate + "</b></td></b></td>";
        headerContent += "<td style='padding-bottom:15px;'><b>Show Sub-Totals:" + SubTotalType + "</b></td><td style='padding-bottom:15px;'><b>Branch:" + BranchDesc+ "</b></td>" +                
                         "<td  colspan='2' style='padding-bottom:15px;' ><b>CSR: " + CSRName + "</b></td>" +
                        "<td  colspan='2' style='padding-bottom:15px;' ><b>Customer No: " + CustomerNo + "</b></td>" +
                        "<td colspan='2'> <b>Filter:" + LineType + "</b></td>" +
                        "<td colspan='4' style='padding-bottom:15px;' ><b>Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;  Run Date: " + DateTime.Now.ToShortDateString() + "</></td></tr>";
        headerContent += "<tr><th colspan='18' style='color:blue' align=left></th></tr>";

        if (dtInvoiceExcel.Rows.Count > 0)
        {
            //GridView dv = new GridView();
            dv.ID = "dvPrint";
            dv.AutoGenerateColumns = false;
            dv.ShowHeader = true;
            dv.RowDataBound += new GridViewRowEventHandler(dv_RowDataBound);

            BoundField bfExcel = new BoundField();

            bfExcel.DataField = "PostDate";
            bfExcel.DataFormatString = "{0:MM/dd/yy}";
            bfExcel.HeaderText = "Post Date";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "OrderType";
            bfExcel.HeaderText = "Order Type";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "Item";
            bfExcel.HeaderText = "Item";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "ItemDescription";
            bfExcel.HeaderText = "Item Description";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "BranchSls";
            bfExcel.HeaderText = "Sls";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "BranchShip";
            bfExcel.HeaderText = "Ship";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "Qty";
            bfExcel.HeaderText = "Qty";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "AltNetUnitPrice";
            bfExcel.HeaderText = "Price";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "AltNetUnitCost";
            bfExcel.HeaderText = "Cost";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "ExtendedPrice";
            bfExcel.HeaderText = "Price";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "ExtendedCost";
            bfExcel.HeaderText = "Cost";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "ExtendedWeight";
            bfExcel.HeaderText = "Weight";
            // bfExcel.HeaderStyle.Width = new Unit(35, UnitType.Pixel);
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "MarginPct";
            bfExcel.HeaderText = "Margin Pct";
            bfExcel.DataFormatString = "{0:#,##0.0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "DisplayRplGMPct";
            bfExcel.HeaderText = "RplGMPct";
            bfExcel.DataFormatString = "{0:#,##0.0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "SellPerLb";
            bfExcel.HeaderText = "Sell/Lb";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "SellToCustomerNumber";
            bfExcel.HeaderText = "Number";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "SellToCustomerName";
            bfExcel.HeaderText = "Name";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "OrderNo";
            bfExcel.HeaderText = "Order";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "CustomerSrvcRepName";
            bfExcel.HeaderText = "CSR";
            bfExcel.HeaderStyle.Width = new Unit(100, UnitType.Pixel);
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            dv.DataSource = dtInvoiceExcel;
            dv.DataBind();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            System.IO.StringWriter sw = new System.IO.StringWriter(sb);
            HtmlTextWriter htw = new HtmlTextWriter(sw);
            dv.RenderControl(htw);
            excelContent = sb.ToString();

        }
        else
        {
            excelContent = "<tr><th width='100%' align ='center' colspan='18' > No records found</th></tr> </table>";
        }

        string pattern = @"\s*\r?\n\s*";
        excelContent = Regex.Replace(excelContent, pattern, "");
        excelContent = Regex.Replace(excelContent, "<tr><th", "<THEAD style='display:table-header-group;'><TR><th").Replace("</th></tr>", "</th></TR></THEAD>");
        excelContent = excelContent.Replace("BORDER-COLLAPSE: collapse;", "border-collapse:separate;").Replace("BORDER-LEFT: #c9c6c6 1px solid;", "BORDER-LEFT: #c9c6c6 0px solid;").Replace("BORDER-RIGHT: #c9c6c6 1px solid;", "BORDER-RIGHT: #c9c6c6 0px solid;");
        excelContent = excelContent.Replace("BORDER-TOP: #c9c6c6 1px solid;", "BORDER-TOP: #c9c6c6 0px solid;").Replace("BORDER-BOTTOM: #c9c6c6 1px solid;", "BORDER-BOTTOM: #c9c6c6 0px solid;");

        Session["PrintContent"] = headerContent + excelContent;
        ScriptManager.RegisterClientScriptBlock(ibtnPrint, ibtnPrint.GetType(), "Print", "PrintReport();", true);
    }

    #region ExcelTable Function
    private DataTable GetExcelTable(DataTable dtValue)
    {
        DataRow drSum;
        DataTable dtMain = new DataTable();
        DataTable dtInvoiceReturn = null;
        //DataTable dtInvoiceReturn;
        if (dtValue.Rows.Count > 0)
        {
            dtValue.DefaultView.RowFilter = (BranchDesc != "ALL") ? "BranchSls='" + BranchID + "'" : "";
            if (dtValue.DefaultView.ToTable(true, "BranchSls").Rows.Count > 0)
            {
                DataTable dtBranchGroup = dtValue.DefaultView.ToTable(true, "BranchSls");

                foreach (DataRow drBranch in dtBranchGroup.Rows)
                {
                    dtValue.DefaultView.RowFilter = "BranchSls  ='" + drBranch["BranchSls"].ToString() + "'" + BindAdvanceWhereClause();
                    dtInvoiceBranch = dtValue.DefaultView.ToTable();

                    if (dtInvoiceBranch.Rows.Count > 0)
                    {
                        if (SubTotalDesc != "ALL")
                        {
                            DataTable dtGroup = dtInvoiceBranch.DefaultView.ToTable(true, SubTotalType);
                            dtMain = dtInvoiceBranch.Clone();
                            if (dtInvoiceReturn == null)
                                dtInvoiceReturn = dtMain.Clone();
                            foreach (DataRow dr in dtGroup.Rows)
                            {
                                try
                                {
                                    dtMain = dtInvoiceBranch.Clone();
                                    dtInvoiceBranch.DefaultView.RowFilter = SubTotalType + "='" + dr[SubTotalType].ToString() + "'";
                                    DataTable dtFiltered = dtInvoiceBranch.DefaultView.ToTable();
                                    
                                    // dtTotal.Merge(dtFiltered);
                                    dtMain.Merge(dtFiltered);
                                    drSum = dtMain.NewRow();

                                    drSum["ItemDescription"] = SubTotalDesc + " Totals";
                                    drSum["Qty"] = dtFiltered.Compute("sum(Qty)", "");
                                    drSum["ExtendedPrice"] = dtFiltered.Compute("sum(ExtendedPrice)", "");
                                    drSum["ExtendedCost"] = dtFiltered.Compute("sum(ExtendedCost)", "");
                                    drSum["ExtendedWeight"] = dtFiltered.Compute("sum(ExtendedWeight)", "");
                                    //drSum["MarginPct"] = ((Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")), 1)) * 100, 1));
                                    drSum["MarginPct"] = ((Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedCost)", "")), 1)) / (Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", ""))) * 100, 1));
                                    drSum["SellPerLb"] = ((Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedWeight)", "")));
                                    drSum[SubTotalType] = dr[SubTotalType];


                                    //if (Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(AltNetUnitPrice)", "")), 0) == 0)
                                    //{
                                    //    drSum["DisplayRplGMPct"] = 0;
                                    //}
                                    //else if (Convert.ToDecimal(dtFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                    //{
                                    //    drSum["DisplayRplGMPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(AltNetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtFiltered.Compute("sum(AltNetUnitPrice)", ""))) * 100, 1);
                                    //}
                                    //else
                                    //{
                                    //    drSum["DisplayRplGMPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtFiltered.Compute("sum(AltNetUnitPrice)", ""))) * 100, 1);
                                    //}


                                    if (Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", "")) == 0)
                                    {
                                        drSum["DisplayRplGMPct"] = 0;
                                    }
                                    else if (Convert.ToDecimal(dtFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                    {
                                        drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                                    }
                                    else
                                    {
                                        drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                                    }

                                    if (SubTotalType == "SellToCustomerNumber")
                                        drSum["SellToCustomerName"] = dtFiltered.Rows[0]["SellToCustomerName"];

                                    dtMain.Rows.Add(drSum);
                                    dtInvoiceReturn.Merge(dtMain);
                                }
                                catch (Exception ex)
                                {
                                    return null;
                                }
                            }

                        }
                        else
                        {
                            DataTable dtRepGroup = dtInvoiceBranch.DefaultView.ToTable(true, "CustomerSrvcRepName");
                            dtMain = dtInvoiceBranch.Clone();
                            if (dtInvoiceReturn == null)
                                dtInvoiceReturn = dtMain.Clone();
                            foreach (DataRow dr in dtRepGroup.Rows)
                            {
                                try
                                {
                                    dtInvoiceBranch.DefaultView.RowFilter = "CustomerSrvcRepName='" + dr["CustomerSrvcRepName"].ToString() + "'";
                                    DataTable dtRepFiltered = dtInvoiceBranch.DefaultView.ToTable();
                                    DataTable dtCustomerGroup = dtInvoiceBranch.DefaultView.ToTable(true, "SellToCustomerNumber");

                                    foreach (DataRow drCustomer in dtCustomerGroup.Rows)
                                    {
                                        dtRepFiltered.DefaultView.RowFilter = "SellToCustomerNumber='" + drCustomer["SellToCustomerNumber"].ToString() + "'";
                                        DataTable dtCustomerFiltered = dtRepFiltered.DefaultView.ToTable();
                                        DataTable dtInvoiceGroup = dtCustomerFiltered.DefaultView.ToTable(true, "OrderNo");
                                        foreach (DataRow drInvoice in dtInvoiceGroup.Rows)
                                        {
                                            dtCustomerFiltered.DefaultView.RowFilter = "OrderNo='" + drInvoice["OrderNo"].ToString() + "'";
                                            DataTable dtInvoiceFiltered = dtCustomerFiltered.DefaultView.ToTable();

                                            dtMain.Merge(dtInvoiceFiltered);
                                            drSum = dtMain.NewRow();

                                            drSum["ItemDescription"] = "Order Totals";
                                            drSum["Qty"] = dtInvoiceFiltered.Compute("sum(Qty)", "");
                                            drSum["ExtendedPrice"] = dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "");
                                            drSum["ExtendedCost"] = dtInvoiceFiltered.Compute("sum(ExtendedCost)", "");
                                            drSum["ExtendedWeight"] = dtInvoiceFiltered.Compute("sum(ExtendedWeight)", "");
                                            drSum["MarginPct"] = ((Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", ""))) * 100, 1));
                                            //if (Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(AltNetUnitPrice)", "")), 0) == 0)
                                            //{
                                            //    drSum["DisplayRplGMPct"] = 0;
                                            //}
                                            //else if (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                            //{
                                            //    drSum["DisplayRplGMPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(AltNetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(AltNetUnitPrice)", ""))) * 100, 1);
                                            //}
                                            //else
                                            //{
                                            //    drSum["DisplayRplGMPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(AltNetUnitPrice)", ""))) * 100, 1);
                                            //}

                                            if (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")) == 0)
                                            {
                                                drSum["DisplayRplGMPct"] = 0;
                                            }
                                            else if (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                            {
                                                drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                                            }
                                            else
                                            {
                                                drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                                            }


                                            drSum["SellPerLb"] = ((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedWeight)", "")), 0) == 0) ? 0 : Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedWeight)", "")));
                                            drSum["OrderNo"] = drInvoice["OrderNo"];
                                            dtMain.Rows.Add(drSum);
                                        }
                                        drSum = dtMain.NewRow();
                                        drSum["ItemDescription"] = "Sell-To Customer Totals";
                                        drSum["Qty"] = dtCustomerFiltered.Compute("sum(Qty)", "");
                                        drSum["ExtendedPrice"] = dtCustomerFiltered.Compute("sum(ExtendedPrice)", "");
                                        drSum["ExtendedCost"] = dtCustomerFiltered.Compute("sum(ExtendedCost)", "");
                                        drSum["ExtendedWeight"] = dtCustomerFiltered.Compute("sum(ExtendedWeight)", "");
                                        drSum["MarginPct"] = ((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedPrice)", "")), 0) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedCost)", "")), 1)) / (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedPrice)", ""))) * 100, 1));
                                        //drSum["DisplayRplGMPct"] = ((Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                                        //if (Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(AltNetUnitPrice)", "")), 0) == 0)
                                        //{
                                        //    drSum["DisplayRplGMPct"] = 0;
                                        //}
                                        //else if (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                        //{
                                        //    drSum["DisplayRplGMPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(AltNetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(AltNetUnitPrice)", "")) * 100), 1);
                                        //}
                                        //else
                                        //{
                                        //    drSum["DisplayRplGMPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(AltNetUnitPrice)", "")) * 100), 1);
                                        //}

                                        if (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")) == 0)
                                        {
                                            drSum["DisplayRplGMPct"] = 0;
                                        }
                                        else if (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                        {
                                            drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                                        }
                                        else
                                        {
                                            drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                                        }

                                        drSum["SellPerLb"] = ((Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedWeight)", "")));
                                        drSum["SellToCustomerNumber"] = dtCustomerFiltered.Rows[0]["SellToCustomerNumber"];
                                        drSum["SellToCustomerName"] = dtCustomerFiltered.Rows[0]["SellToCustomerName"];
                                        dtMain.Rows.Add(drSum);

                                    }
                                    drSum = dtMain.NewRow();
                                    drSum["ItemDescription"] = "Customer Service Representative Totals ";
                                    drSum["Qty"] = dtRepFiltered.Compute("sum(Qty)", "");
                                    drSum["ExtendedPrice"] = dtRepFiltered.Compute("sum(ExtendedPrice)", "");
                                    drSum["ExtendedCost"] = dtRepFiltered.Compute("sum(ExtendedCost)", "");
                                    drSum["ExtendedWeight"] = dtRepFiltered.Compute("sum(ExtendedWeight)", "");
                                    drSum["MarginPct"] = ((Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedCost)", "")), 1)) / (Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedPrice)", ""))) * 100, 1));
                                    //drSum["DisplayRplGMPct"] = ((Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                                    //if (Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(AltNetUnitPrice)", "")), 0) == 0)
                                    //{
                                    //    drSum["DisplayRplGMPct"] = 0;
                                    //}
                                    //else if (Convert.ToDecimal(dtRepFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                    //{
                                    //    drSum["DisplayRplGMPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(AltNetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtRepFiltered.Compute("sum(AltNetUnitPrice)", ""))) * 100, 1);
                                    //}
                                    //else
                                    //{
                                    //    drSum["DisplayRplGMPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtRepFiltered.Compute("sum(AltNetUnitPrice)", ""))) * 100, 1);
                                    //}

                                    if (Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")) == 0)
                                    {
                                        drSum["DisplayRplGMPct"] = 0;
                                    }
                                    else if (Convert.ToDecimal(dtRepFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                    {
                                        drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                                    }
                                    else
                                    {
                                        drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                                    }

                                    drSum["SellPerLb"] = ((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedWeight)", "")), 0) == 0) ? 0 : Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedWeight)", "")));
                                    drSum["CustomerSrvcRepName"] = dtRepFiltered.Rows[0]["CustomerSrvcRepName"];
                                    dtMain.Rows.Add(drSum);

                                }
                                catch (Exception ex)
                                {
                                    return null;
                                }
                            }
                            drSum = dtMain.NewRow();
                            drSum["ItemDescription"] = "Sales Branch Totals";
                            drSum["Qty"] = dtInvoiceBranch.Compute("sum(Qty)", "");
                            drSum["ExtendedPrice"] = dtInvoiceBranch.Compute("sum(ExtendedPrice)", "");
                            drSum["ExtendedCost"] = dtInvoiceBranch.Compute("sum(ExtendedCost)", "");
                            drSum["ExtendedWeight"] = dtInvoiceBranch.Compute("sum(ExtendedWeight)", "");
                            drSum["MarginPct"] = ((Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedPrice)", ""))) * 100, 1));
                            //drSum["DisplayRplGMPct"] = ((Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                            //if (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(AltNetUnitPrice)", "")) == 0)
                            //{
                            //    drSum["DisplayRplGMPct"] = 0;
                            //}
                            //else if (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(DisplayRplCost)", "")) == 0)
                            //{
                            //    drSum["DisplayRplGMPct"] = (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(AltNetUnitPrice)", "")) == 0 ? 0 : (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(AltNetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(AltNetUnitPrice)", ""))) * 100, 1)));
                            //}
                            //else
                            //{
                            //    drSum["DisplayRplGMPct"] = (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(AltNetUnitPrice)", "")) == 0 ? 0 : (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(AltNetUnitPrice)", ""))) * 100, 1)));
                            //}

                            if (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")) == 0)
                            {
                                drSum["DisplayRplGMPct"] = 0;
                            }
                            else if (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(DisplayRplCost)", "")) == 0)
                            {
                                drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                            }
                            else
                            {
                                drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                            }

                            drSum["SellPerLb"] = (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedWeight)", "")) == 0 ? 0 : ((Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedWeight)", ""))));
                            drSum["BranchSls"] = dtInvoiceBranch.Rows[0]["BranchSls"];
                            dtMain.Rows.Add(drSum);
                            dtInvoiceReturn.Merge(dtMain);
                        }
                    }
                }
            }
            else
            {
                dtInvoiceReturn = dtValue;
            }
        }
        else
        {
            dtInvoiceReturn = dtValue;
        }
        //DataRow drGrandTotal = dtValue.NewRow();

        return dtInvoiceReturn;
    }
    #endregion

    #region Write Excel
    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        dtInvoiceExcel = new DataTable();
        FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();

        StartDate = ViewState["StartDate"].ToString();//cldStartDt.SelectedDate.ToShortDateString();
        EndDate = ViewState["EndDate"].ToString();
        string _customerNo = CustomerNo;
        string _CSRName = CSRName;
        bool _onlyLowMarginLn = (LineType == "ALL" ? false : true);

        _dtTemp = bookingReport.GetBookingReportData(StartDate, EndDate, _customerNo, _CSRName, ViewState["MinMargin"].ToString(), ViewState["MaxMargin"].ToString(), _onlyLowMarginLn, BranchID);

        dtInvoiceExcel = GetExcelTable(_dtTemp);

        headerContent = "<table border='1'>";

        headerContent += "<tr><th colspan='18' style='color:blue' align=left><center>Booking Report</center></th></tr>";
        headerContent += "<tr><td colspan='2'><b>StartDate :" + StartDate + "</b></td><td  colspan='2'><b>End Date:" + EndDate + "</b></td>";
        headerContent += "</b></td><td  colspan='2'><b>Show Sub-Totals:" + SubTotalDesc + "</b></td>" +
                        "<td> <b>Branch:" + BranchDesc + "</b></td>" +                        
                        "<td  colspan='2' style='padding-bottom:15px;' ><b>CSR: " + CSRName + "</b></td>" +
                        "<td  colspan='3' style='padding-bottom:15px;' ><b>Customer No: " + CustomerNo + "</b></td>" +
                        "<td colspan='2' style='padding-bottom:15px;'> <b>Filter:" + LineTypeDesc + "</b></td>" +
                        "<td colspan='2'><b>Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;  Run Date: " + DateTime.Now.ToShortDateString() + "</></td></tr>";
        headerContent += "<tr><th colspan='18' style='color:blue' align=left></th></tr>";

        headerContent += "<tr><th nowrap width='70px'> <center>PostDate</center> </th>" +
                             "<th width='35' nowrap   align='center'>Order Type</th>" +
                            "<th width='100' nowrap align='center'>Item</th>" +
                            "<th width='200' nowrap align='center'>Item Description</th>" +
                            "<th style='width:50px' colspan='2' ><table border='1px' ><tr><th colspan='2'>Branch</th></tr><tr><th>Sls</th><th>Ship</th></table></th>" +
                            "<th width='35px'  nowrap align='center' nowrap  >Qty</th>" +
                            "<th style='width:70px' colspan='2'><table border='1px' ><tr><th colspan='2'>Net Unit</th></tr><tr><th>Price</th><th>Cost</th></table></th>" +
                            "<th style='width:110px' colspan='3'><table border='1px' ><tr><th colspan='3'>Extended</th></tr><tr><th>Price</th><th>Cost</th><th>Weight</th></table></th>" +
                            "<th width='40px'  nowrap align='center' nowrap  ><table border='1px' ><tr><th colspan='2'>Margin %</th></tr><tr><th>SAVG</th><th>Repl</th></table></th>" +
                            "<th width='40px'  align='center' nowrap  >Sell/Lb</th>" +
                            "<th style='width:270px' colspan='2'><table border='1px' ><tr><th colspan='2'>Sell-To Customer</th></tr><tr><th>Number</th><th>Name</th></table></th>" +
                            "<th width='100px'  nowrap align='center' nowrap  >Order</th>" +
                            "<th width='100px' nowrap align='center' nowrap  >CSR</th>" +
                            "</tr>";


        if (dtInvoiceExcel.Rows.Count > 0)
        {
            dv.AutoGenerateColumns = false;
            dv.ShowHeader = false;

            dv.RowDataBound += new GridViewRowEventHandler(dv_RowDataBound);

            BoundField bfExcel = new BoundField();

            bfExcel.DataField = "PostDate";
            bfExcel.DataFormatString = "{0:MM/dd/yy}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "OrderType";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "Item";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "ItemDescription";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "BranchSls";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "BranchShip";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "Qty";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "AltNetUnitPrice";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "AltNetUnitCost";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "ExtendedPrice";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "ExtendedCost";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "ExtendedWeight";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "MarginPct";
            bfExcel.DataFormatString = "{0:#,##0.0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "DisplayRplGMPct";
            bfExcel.DataFormatString = "{0:#,##0.0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "SellPerLb";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "SellToCustomerNumber";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "SellToCustomerName";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "OrderNo";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "CustomerSrvcRepName";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            dv.DataSource = dtInvoiceExcel;
            dv.DataBind();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            System.IO.StringWriter sw = new System.IO.StringWriter(sb);
            HtmlTextWriter htw = new HtmlTextWriter(sw);
            dv.RenderControl(htw);
            excelContent = sb.ToString();

        }
        else
        {
            // excelContent = "<tr><th colspan='18'  align=left><center>No records found</center></th></tr> </table>";
            excelContent = "<tr  ><th width='100%' align ='center' colspan='18' > No records found</th></tr> </table>";
        }
        reportWriter.WriteLine(headerContent + excelContent);
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

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\InvoiceRegister\\Common\\ExcelUploads"));

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

    protected void dv_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[2].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead' colspan=2 nowrap width='90'><center>Item </center></td></tr></tr></table>";
            e.Row.Cells[3].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead' colspan=2 nowrap width='250'><center>Item Description</center></td></tr></tr></table>";
            e.Row.Cells[4].ColumnSpan = 2;
            e.Row.Cells[4].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td splitBorder' style='border-bottom:solid 1px #000000;border-right:solid 0px #000000;' colspan=2 nowrap ><center><strong>Branch<strong></center></td></tr><tr><td width='40' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #000000;'><center>" +
                                        "<Div style='cursor:hand;' >Sls</div></center></td><td width='40' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #000000;'>" +
                                        "<Div >Ship</div></td></tr></table>";

            e.Row.Cells[5].Visible = false;

            e.Row.Cells[7].ColumnSpan = 2;
            e.Row.Cells[7].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Net Unit</center></td></tr><tr><td width='35' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' >Price</div></center></td><td width='30' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div >Cost</div></td></tr></table>";

            e.Row.Cells[8].Visible = false;

            e.Row.Cells[9].ColumnSpan = 3;
            e.Row.Cells[9].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>Extended</center></td></tr><tr><td width='40' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div >Price</div></center></td><td width='40' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div >Cost</div></td> <td width='40' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div >Weight</div></td></tr></table>";
            e.Row.Cells[10].Visible = e.Row.Cells[11].Visible = false;

            e.Row.Cells[12].Visible = false;
            e.Row.Cells[13].ColumnSpan = 2;
            e.Row.Cells[13].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Margin % </center></td></tr><tr><td width='40' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('MarginPct');\">SAVG</div></center></td><td width='40' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('DisplayRplGMPct');\">Repl</div></td></tr></table>";


            e.Row.Cells[15].ColumnSpan = 2;
            e.Row.Cells[15].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Sell-To Customer </center></td></tr><tr><td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('AltNetUnitPrice');\">Number</div></center></td><td width='200' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('AltNetUnitCost');\">Name</div></td></tr></table>";
            e.Row.Cells[16].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (e.Row.Cells[0].Text == "&nbsp;")
                e.Row.Font.Bold = true;
            else
            {
                maxMargin = Convert.ToDecimal(ViewState["MaxMargin"].ToString());
                minMargin = Convert.ToDecimal(ViewState["MinMargin"].ToString());

                if (((Convert.ToDecimal(e.Row.Cells[12].Text)) < minMargin && (Convert.ToDecimal(e.Row.Cells[12].Text)) != minMargin) || ((Convert.ToDecimal(e.Row.Cells[12].Text)) > maxMargin && (Convert.ToDecimal(e.Row.Cells[12].Text)) != maxMargin))
                {
                    e.Row.Cells[12].ForeColor = System.Drawing.Color.Red;
                    e.Row.Cells[12].Font.Bold = true;
                }
                if (((Convert.ToDecimal(e.Row.Cells[13].Text)) < minMargin && (Convert.ToDecimal(e.Row.Cells[13].Text)) != minMargin) || ((Convert.ToDecimal(e.Row.Cells[13].Text)) > maxMargin && (Convert.ToDecimal(e.Row.Cells[13].Text)) != maxMargin))
                {
                    e.Row.Cells[13].ForeColor = System.Drawing.Color.Red;
                    e.Row.Cells[13].Font.Bold = true;
                }
            }
        }
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            DataTable dt = (BranchDesc == "ALL") ? _dtTemp : dtInvoiceBranch;

            e.Row.Cells[3].Text = "Grand Total";
            e.Row.Cells[6].Text = string.Format("{0:#,##0}", dt.Compute("sum(Qty)", ""));
            e.Row.Cells[9].Text = string.Format("{0:#,##0.00}", dt.Compute("sum(ExtendedPrice)", ""));
            e.Row.Cells[10].Text = string.Format("{0:#,##0.00}", dt.Compute("sum(ExtendedCost)", ""));
            e.Row.Cells[11].Text = string.Format("{0:#,##0.00}", dt.Compute("sum(ExtendedWeight)", ""));

            e.Row.Cells[12].Text = string.Format("{0:#,##0.0}", ((Convert.ToDecimal(dt.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dt.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dt.Compute("sum(ExtendedCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dt.Compute("sum(ExtendedPrice)", "")), 1)) * 100, 1)));
            //e.Row.Cells[13].Text = string.Format("{0:#,##0.0}", ((Convert.ToDecimal(dt.Compute("sum(NetUnitPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dt.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dt.Compute("sum(DisplayRplGMPct)", "")), 1)) / (Math.Round(Convert.ToDecimal(dt.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1)));
            Decimal MarginRplPct = 0.0M;
            //if (Convert.ToDecimal(dt.Compute("sum(AltNetUnitPrice)", "")) == 0)
            //{
            //    MarginRplPct = 0;
            //}
            //else if (Convert.ToDecimal(dt.Compute("sum(DisplayRplCost)", "")) == 0)
            //{
            //    MarginRplPct = (Math.Round((Math.Round(Convert.ToDecimal(dt.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dt.Compute("sum(AltNetUnitCost)", "")), 1)) / (Convert.ToDecimal(dt.Compute("sum(AltNetUnitPrice)", ""))) * 100, 1));
            //}
            //else
            //{
            //    MarginRplPct = (Math.Round((Math.Round(Convert.ToDecimal(dt.Compute("sum(AltNetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dt.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dt.Compute("sum(AltNetUnitPrice)", ""))) * 100, 1));
            //}
            if (Convert.ToDecimal(dt.Compute("sum(NetUnitPrice)", "")) == 0)
            {
                MarginRplPct = 0;
            }
            else if (Convert.ToDecimal(dt.Compute("sum(DisplayRplCost)", "")) == 0)
            {
                MarginRplPct = (Math.Round((Math.Round(Convert.ToDecimal(dt.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dt.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dt.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
            }
            else
            {
                MarginRplPct = (Math.Round((Math.Round(Convert.ToDecimal(dt.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dt.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dt.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
            }

            e.Row.Cells[13].Text = string.Format("{0:#,##0.0}", MarginRplPct);
            e.Row.Cells[14].Text = string.Format("{0:#,##0.00}", ((Convert.ToDecimal(dt.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dt.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dt.Compute("sum(ExtendedWeight)", ""))));
            dv.ShowFooter = true;
            
            dv.FooterStyle.Font.Bold = true;
        }
    }

}

