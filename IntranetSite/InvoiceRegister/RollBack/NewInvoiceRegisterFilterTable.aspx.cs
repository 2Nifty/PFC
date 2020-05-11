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

public partial class NewInvoiceRegister : System.Web.UI.Page
{
    # region Variable Declaration
    private string sortExpression = string.Empty;
    string sort = "";
    string _startDate = "";
    string _endDate = "";
    decimal minMargin = 0;
    decimal maxMargin = 100;
    DataTable dtInvoice = new DataTable();
    DataTable dtDate = new DataTable();
    DataTable dtMargin = new DataTable();
    DataTable dtInvoiceBranch = new DataTable();
    InvoiceRegisterReportFilterTable invoiceFilterTable = new InvoiceRegisterReportFilterTable();
    DataTable dtInvoiceExcel = new DataTable();
    DataTable dtCSR = new DataTable();
    DataTable dtCustNo = new DataTable();
    DataTable dtFilters = new DataTable();
    GridView dv = new GridView();

    int totalBranchFound = 0;
    string reportName = "Invoice Register Filter Table Report";

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        ScriptManager1.AsyncPostBackTimeout = 7200;

        Ajax.Utility.RegisterTypeForAjax(typeof(NewInvoiceRegister));
        Session["PrintContent"] = "";

        if (!IsPostBack)
        {
            hidFileName.Value = "InvoiceAnalysisReport" + Session["SessionID"].ToString() + ".xls";

            dtDate = invoiceFilterTable.GetCurrentDateValue();
            if (dtDate != null && dtDate.Rows.Count > 0)
            {
                ViewState["EndDate"] = Convert.ToDateTime(dtDate.Rows[0]["EndDate"].ToString()).ToShortDateString();
                ViewState["StartDate"] = Convert.ToDateTime(dtDate.Rows[0]["BegDate"].ToString()).ToShortDateString();
                lblStartDt.Text = Convert.ToDateTime(dtDate.Rows[0]["BegDate"].ToString()).ToShortDateString();
                lblEndDt.Text = Convert.ToDateTime(dtDate.Rows[0]["EndDate"].ToString()).ToShortDateString();
            }

            dtFilters = invoiceFilterTable.GetFilterHeaders();
            if (dtFilters != null && dtFilters.Rows.Count > 0)
            {
                FilterDropDownList.DataSource = dtFilters;
                FilterDropDownList.DataBind();
            }

        }

        if (hidShowMode.Value == "Show")
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoW", "ShowPanel();", true);
        else if (hidShowMode.Value == "ShowL")
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoWL", "ShowHide('Show');", true);
        else if (hidShowMode.Value == "HideL")
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoWL", "ShowHide('Hide');", true);

    }

    protected void ibtnFilter_Click(object sender, EventArgs e)
    {
            BindDataGrid();
    }

    private void BindDataGrid()
    {
        dtMargin = invoiceFilterTable.GetMarginValue();
        if (dtMargin != null && dtMargin.Rows.Count > 0)
        {
            maxMargin = Convert.ToDecimal(dtMargin.Rows[1]["AppOptionValue"].ToString()) * 100;
            minMargin = Convert.ToDecimal(dtMargin.Rows[0]["AppOptionValue"].ToString()) * 100;
            ViewState["MaxMargin"] = maxMargin.ToString();
            ViewState["MinMargin"] = minMargin.ToString();
        }

        if (sort == "")
        {
            dtInvoice = invoiceFilterTable.GetInvoiceData(FilterDropDownList.SelectedValue.ToString());
            Session["InvoiceRegister"] = dtInvoice;
            Session["InvoiceRegisterExcel"] = dtInvoice;
        }
        else
        {
            dtInvoice = (DataTable)Session["InvoiceRegister"];
        }

        if (dtInvoice != null && dtInvoice.Rows.Count > 0)
        {
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
            
            dtInvoice.DefaultView.RowFilter = "BranchSls='" + hidBranchID.Value + "'" ;
            dtInvoiceBranch = dtInvoice.DefaultView.ToTable();

            if (dtInvoiceBranch.Rows.Count > 0)
            {
                // sortExpression = ((hidSort.Value != "") ? hidSort.Value : "PostDate asc");
                // dtInvoice.DefaultView.Sort = sortExpression;
                DataRow drSum;
                if (e.Row.RowIndex == 0)
                    dtInvoiceExcel = dtInvoiceBranch.Clone();
                //  dtTotal = dtInvoiceAnalysis.Clone();
                if (ddlSubTotals.SelectedItem.Text != "ALL")
                {
                    DataTable dtGroup = dtInvoiceBranch.DefaultView.ToTable(true, ddlSubTotals.SelectedValue);
                    DataTable dtMain = dtInvoiceBranch.Clone();
                    foreach (DataRow dr in dtGroup.Rows)
                    {
                        try
                        {
                            dtInvoiceBranch.DefaultView.RowFilter = ddlSubTotals.SelectedValue + "='" + dr[ddlSubTotals.SelectedValue].ToString() + "'";
                            DataTable dtFiltered = dtInvoiceBranch.DefaultView.ToTable();

                            // dtTotal.Merge(dtFiltered);
                            dtMain.Merge(dtFiltered);
                            drSum = dtMain.NewRow();

                            drSum["ItemDescription"] = ddlSubTotals.SelectedItem.Text + " Totals";
                            drSum["Qty"] = dtFiltered.Compute("sum(Qty)", "");
                            drSum["ExtendedPrice"] = dtFiltered.Compute("sum(ExtendedPrice)", "");
                            drSum["ExtendedCost"] = dtFiltered.Compute("sum(ExtendedCost)", "");
                            drSum["ExtendedWeight"] = dtFiltered.Compute("sum(ExtendedWeight)", "");
                            drSum["MarginPct"] = ((Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")), 1)) * 100, 1));
                            drSum["SellPerLb"] = ((Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedWeight)", "")));
                            drSum[ddlSubTotals.SelectedValue] = dr[ddlSubTotals.SelectedValue];
                            if (ddlSubTotals.SelectedValue == "SellToCustomerNumber")
                                drSum["SellToCustomerName"] = dtFiltered.Rows[0]["SellToCustomerName"];

                            if (Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", "")) == 0)
                            {
                                drSum["DisplayRplGMPct"] = 0;
                            }
                            else if (Convert.ToDecimal(dtFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                            {
                                drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
                            }
                            else
                            {
                                drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
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
                                DataTable dtInvoiceGroup = dtCustomerFiltered.DefaultView.ToTable(true, "InvoiceNumber");
                                foreach (DataRow drInvoice in dtInvoiceGroup.Rows)
                                {
                                    dtCustomerFiltered.DefaultView.RowFilter = "InvoiceNumber='" + drInvoice["InvoiceNumber"].ToString() + "'";
                                    DataTable dtInvoiceFiltered = dtCustomerFiltered.DefaultView.ToTable();

                                    dtMain.Merge(dtInvoiceFiltered);
                                    drSum = dtMain.NewRow();

                                    drSum["ItemDescription"] = "Invoice Totals";
                                    drSum["Qty"] = dtInvoiceFiltered.Compute("sum(Qty)", "");
                                    drSum["ExtendedPrice"] = dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "");
                                    drSum["ExtendedCost"] = dtInvoiceFiltered.Compute("sum(ExtendedCost)", "");
                                    drSum["ExtendedWeight"] = dtInvoiceFiltered.Compute("sum(ExtendedWeight)", "");
                                    drSum["MarginPct"] = ((Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "")), 1)) * 100, 1));
                                    //drSum["DisplayRplGMPct"] = ((Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
                                    drSum["SellPerLb"] = ((Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedWeight)", "")));
                                    drSum["InvoiceNumber"] = drInvoice["InvoiceNumber"];
                                    if (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")) == 0)
                                    {
                                        drSum["DisplayRplGMPct"] = 0;
                                    }
                                    else if (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                    {
                                        drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
                                    }
                                    else
                                    {
                                        drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
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
                                if (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")) == 0)
                                {
                                    drSum["DisplayRplGMPct"] = 0;
                                }
                                else if (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                {
                                    drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
                                }
                                else
                                {
                                    drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
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
                            if (Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")) == 0)
                            {
                                drSum["DisplayRplGMPct"] = 0;
                            }
                            else if (Convert.ToDecimal(dtRepFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                            {
                                drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
                            }
                            else
                            {
                                drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
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
                    if (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")) == 0)
                    {
                        drSum["DisplayRplGMPct"] = 0;
                    }
                    else if (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(DisplayRplCost)", "")) == 0)
                    {
                        drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
                    }
                    else
                    {
                        drSum["DisplayRplGMPct"] = (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(DisplayRplCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
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
        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[4].ColumnSpan = 2;
            e.Row.Cells[4].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Branch</center></td></tr><tr><td width='50' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('BranchSls');\">Sls</div></center></td><td width='50' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('BranchShip');\">Ship</div></td></tr></table>";

            e.Row.Cells[5].Visible = false;

            e.Row.Cells[7].ColumnSpan = 2;
            e.Row.Cells[7].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Net Unit</center></td></tr><tr><td width='35' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('NetUnitPrice');\">Price</div></center></td><td width='30' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('NetUnitCost');\">Cost</div></td></tr></table>";

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
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('MarginPct');\">Avg</div></center></td><td width='40' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('DisplayRplGMPct');\">Repl</div></td></tr></table>";


            e.Row.Cells[15].ColumnSpan = 2;
            e.Row.Cells[15].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Sell-To Customer </center></td></tr><tr><td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('NetUnitPrice');\">Number</div></center></td><td width='200' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('NetUnitCost');\">Name</div></td></tr></table>";
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
            DataTable dtTotal = dtInvoiceBranch.Copy();
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
                if (Convert.ToDecimal(dtTotal.Compute("sum(NetUnitPrice)", "")) == 0)
                {
                    MarginRplPct = 0;
                }
                else if (Convert.ToDecimal(dtTotal.Compute("sum(DisplayRplCost)", "")) == 0)
                {
                    MarginRplPct = (Math.Round((Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(NetUnitCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
                }
                else
                {
                    MarginRplPct = (Math.Round((Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(DisplayRplCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1));
                }
                e.Row.Cells[13].Text = string.Format("{0:#,##0.0}", MarginRplPct);
                e.Row.Cells[14].Text = string.Format("{0:#,##0.00}", ((Convert.ToDecimal(dtTotal.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dtTotal.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtTotal.Compute("sum(ExtendedWeight)", ""))));
            }
            else
                e.Row.Visible = false;
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

    protected void ibtnRunReport_Click(object sender, ImageClickEventArgs e)
    {
        dvPager.Visible = true;
       
        BindDataGrid();        
        pnlBranch.Update();
        pnlProgress.Update();
        upnlGrid.Update();
    }

    protected void ddlSubTotals_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindDataGrid();
    }

    protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
    {
        dtInvoiceExcel = new DataTable();
        string headerContent = string.Empty;
        string excelContent = string.Empty;

        _startDate = ViewState["StartDate"].ToString();
        _endDate = ViewState["EndDate"].ToString();

        dtInvoiceExcel = GetExcelTable((DataTable)Session["InvoiceRegisterExcel"]);

        headerContent = "<table border='0' width=100% cellpadding=1 cellspacing=0 >";

        headerContent += "<tr><th colspan='18' style='color:blue' align=left><center>" + reportName + " - Filtered for:" + FilterDropDownList.SelectedItem.Text.ToString() + "</center></th></tr>";
        headerContent += "<tr><td colspan='2' style='padding-bottom:15px;' ><b>StartDate :" + _startDate + "</b></td><td  colspan='2' style='padding-bottom:15px;' ><b>End Date:" + _endDate + "</b></td></b></td>";
        headerContent += "<td style='padding-bottom:15px;'><b>Show Sub-Totals:" + ddlSubTotals.SelectedItem.Text + "</b></td><td style='padding-bottom:15px;'></td>" +                
                         "<td  colspan='2' style='padding-bottom:15px;' ></td>" +
                        "<td  colspan='2' style='padding-bottom:15px;' ></td>" +
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
            bfExcel.DataField = "NetUnitPrice";
            bfExcel.HeaderText = "Price";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "NetUnitCost";
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
            bfExcel.DataField = "InvoiceNumber";
            bfExcel.HeaderText = "Invoice";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "PricingType";
            bfExcel.HeaderText = "Pricing Type";
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
            dtValue.DefaultView.RowFilter =  "";
            if (dtValue.DefaultView.ToTable(true, "BranchSls").Rows.Count > 0)
            {
                DataTable dtBranchGroup = dtValue.DefaultView.ToTable(true, "BranchSls");

                foreach (DataRow drBranch in dtBranchGroup.Rows)
                {
                    dtValue.DefaultView.RowFilter = "BranchSls  ='" + drBranch["BranchSls"].ToString() + "'" ;
                    dtInvoiceBranch = dtValue.DefaultView.ToTable();

                    if (dtInvoiceBranch.Rows.Count > 0)
                    {
                        if (ddlSubTotals.SelectedItem.Text != "ALL")
                        {
                            DataTable dtGroup = dtInvoiceBranch.DefaultView.ToTable(true, ddlSubTotals.SelectedValue);
                            dtMain = dtInvoiceBranch.Clone();
                            if (dtInvoiceReturn == null)
                                dtInvoiceReturn = dtMain.Clone();
                            foreach (DataRow dr in dtGroup.Rows)
                            {
                                try
                                {
                                    dtInvoiceBranch.DefaultView.RowFilter = ddlSubTotals.SelectedValue + "='" + dr[ddlSubTotals.SelectedValue].ToString() + "'";
                                    DataTable dtFiltered = dtInvoiceBranch.DefaultView.ToTable();


                                    // dtTotal.Merge(dtFiltered);
                                    dtMain.Merge(dtFiltered);
                                    drSum = dtMain.NewRow();

                                    drSum["ItemDescription"] = ddlSubTotals.SelectedItem.Text + " Totals";
                                    drSum["Qty"] = dtFiltered.Compute("sum(Qty)", "");
                                    drSum["ExtendedPrice"] = dtFiltered.Compute("sum(ExtendedPrice)", "");
                                    drSum["ExtendedCost"] = dtFiltered.Compute("sum(ExtendedCost)", "");
                                    drSum["ExtendedWeight"] = dtFiltered.Compute("sum(ExtendedWeight)", "");
                                    drSum["MarginPct"] = ((Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")), 1)) * 100, 1));
                                    drSum["SellPerLb"] = ((Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedWeight)", "")));
                                    drSum[ddlSubTotals.SelectedValue] = dr[ddlSubTotals.SelectedValue];
                                    if (Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", "")), 0) == 0)
                                    {
                                        drSum["DisplayRplGMPct"] = 0;
                                    }
                                    else if (Convert.ToDecimal(dtFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                    {
                                        drSum["DisplayRplGMPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1);
                                    }
                                    else
                                    {
                                        drSum["DisplayRplGMPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1);
                                    }
                                    if (ddlSubTotals.SelectedValue == "SellToCustomerNumber")
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
                                        DataTable dtInvoiceGroup = dtCustomerFiltered.DefaultView.ToTable(true, "InvoiceNumber");
                                        foreach (DataRow drInvoice in dtInvoiceGroup.Rows)
                                        {
                                            dtCustomerFiltered.DefaultView.RowFilter = "InvoiceNumber='" + drInvoice["InvoiceNumber"].ToString() + "'";
                                            DataTable dtInvoiceFiltered = dtCustomerFiltered.DefaultView.ToTable();

                                            dtMain.Merge(dtInvoiceFiltered);
                                            drSum = dtMain.NewRow();

                                            drSum["ItemDescription"] = "Invoice Totals";
                                            drSum["Qty"] = dtInvoiceFiltered.Compute("sum(Qty)", "");
                                            drSum["ExtendedPrice"] = dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "");
                                            drSum["ExtendedCost"] = dtInvoiceFiltered.Compute("sum(ExtendedCost)", "");
                                            drSum["ExtendedWeight"] = dtInvoiceFiltered.Compute("sum(ExtendedWeight)", "");
                                            drSum["MarginPct"] = ((Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", ""))) * 100, 1));
                                            if (Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")), 0) == 0)
                                            {
                                                drSum["DisplayRplGMPct"] = 0;
                                            }
                                            else if (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                            {
                                                drSum["DisplayRplGMPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1);
                                            }
                                            else
                                            {
                                                drSum["DisplayRplGMPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1);
                                            }
                                            drSum["SellPerLb"] = ((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedWeight)", "")), 0) == 0) ? 0 : Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedWeight)", "")));
                                            drSum["InvoiceNumber"] = drInvoice["InvoiceNumber"];
                                            dtMain.Rows.Add(drSum);
                                        }
                                        drSum = dtMain.NewRow();
                                        drSum["ItemDescription"] = "Sell-To Customer Totals";
                                        drSum["Qty"] = dtCustomerFiltered.Compute("sum(Qty)", "");
                                        drSum["ExtendedPrice"] = dtCustomerFiltered.Compute("sum(ExtendedPrice)", "");
                                        drSum["ExtendedCost"] = dtCustomerFiltered.Compute("sum(ExtendedCost)", "");
                                        drSum["ExtendedWeight"] = dtCustomerFiltered.Compute("sum(ExtendedWeight)", "");
                                        drSum["MarginPct"] = ((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedPrice)", "")), 0) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedPrice)", "")), 1)) * 100, 1));
                                        //drSum["DisplayRplGMPct"] = ((Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1));
                                        if (Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")), 0) == 0)
                                        {
                                            drSum["DisplayRplGMPct"] = 0;
                                        }
                                        else if (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                        {
                                            drSum["DisplayRplGMPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")) * 100), 1);
                                        }
                                        else
                                        {
                                            drSum["DisplayRplGMPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(NetUnitPrice)", "")) * 100), 1);
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
                                    if (Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")), 0) == 0)
                                    {
                                        drSum["DisplayRplGMPct"] = 0;
                                    }
                                    else if (Convert.ToDecimal(dtRepFiltered.Compute("sum(DisplayRplCost)", "")) == 0)
                                    {
                                        drSum["DisplayRplGMPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1);
                                    }
                                    else
                                    {
                                        drSum["DisplayRplGMPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtRepFiltered.Compute("sum(NetUnitPrice)", ""))) * 100, 1);
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
                            if (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")) == 0)
                            {
                                drSum["DisplayRplGMPct"] = 0;
                            }
                            else if (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(DisplayRplCost)", "")) == 0)
                            {
                                drSum["DisplayRplGMPct"] = (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")) == 0 ? 0 : (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", ""))) * 100, 1)));
                            }
                            else
                            {
                                drSum["DisplayRplGMPct"] = (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")) == 0 ? 0 : (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(DisplayRplCost)", "")), 1)) / (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(NetUnitPrice)", ""))) * 100, 1)));
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

        _startDate = ViewState["StartDate"].ToString();//cldStartDt.SelectedDate.ToShortDateString();
        _endDate = ViewState["EndDate"].ToString();
        
        dtInvoiceExcel = GetExcelTable((DataTable)Session["InvoiceRegisterExcel"]);

        headerContent = "<table border='1'>";

        headerContent += "<tr><th colspan='19' style='color:blue' align=left><center>"+ reportName +"</center></th></tr>";
        headerContent += "<tr><td colspan='2'><b>StartDate :" + _startDate + "</b></td><td  colspan='2'><b>End Date:" + _endDate + "</b></td>";
        headerContent += "</b></td><td  colspan='2'><b>Show Sub-Totals:" + ddlSubTotals.SelectedItem.Text + "</b></td><td></td>" +
                       "<td  colspan='2' style='padding-bottom:15px;' ></td>" +
                        "<td  colspan='2' style='padding-bottom:15px;' ></td>" +  
            "<td colspan='2'><b>Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;  Run Date: " + DateTime.Now.ToShortDateString() + "</></td></tr>";
        headerContent += "<tr><th colspan='19' style='color:blue' align=left></th></tr>";

        headerContent += "<tr><th nowrap width='70px'> <center>PostDate</center> </th>" +
                             "<th width='35' nowrap   align='center'>Order Type</th>" +
                            "<th width='100' nowrap align='center'>Item</th>" +
                            "<th width='200' nowrap align='center'>Item Description</th>" +
                            "<th style='width:50px' colspan='2' ><table border='1px' ><tr><th colspan='2'>Branch</th></tr><tr><th>Sls</th><th>Ship</th></table></th>" +
                            "<th width='35px'  nowrap align='center' nowrap  >Qty</th>" +
                            "<th style='width:70px' colspan='2'><table border='1px' ><tr><th colspan='2'>Net Unit</th></tr><tr><th>Price</th><th>Cost</th></table></th>" +
                            "<th style='width:110px' colspan='3'><table border='1px' ><tr><th colspan='3'>Extended</th></tr><tr><th>Price</th><th>Cost</th><th>Weight</th></table></th>" +
                            "<th width='40px'  nowrap align='center' nowrap  ><table border='1px' ><tr><th colspan='2'>Margin %</th></tr><tr><th>Avg</th><th>Repl</th></table></th>" +
                            "<th width='40px'  align='center' nowrap  >Sell/Lb</th>" +
                            "<th style='width:270px' colspan='2'><table border='1px' ><tr><th colspan='2'>Sell-To Customer</th></tr><tr><th>Number</th><th>Name</th></table></th>" +
                            "<th width='100px'  nowrap align='center' nowrap  >Invoice</th>" +
                            "<th width='100px' nowrap align='center' nowrap  >PricingType</th>" +
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
            bfExcel.DataField = "NetUnitPrice";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "NetUnitCost";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "ExtendedPrice";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "ExtendedCost";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "ExtendedWeight";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "MarginPct";
            bfExcel.DataFormatString = "{0:#,##0.0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "DisplayRplGMPct";
            bfExcel.DataFormatString = "{0:#,##0.0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "SellPerLb";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
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
            bfExcel.DataField = "InvoiceNumber";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "PricingType";
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
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('MarginPct');\">Avg</div></center></td><td width='40' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('DisplayRplGMPct');\">Repl</div></td></tr></table>";


            e.Row.Cells[15].ColumnSpan = 2;
            e.Row.Cells[15].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Sell-To Customer </center></td></tr><tr><td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('NetUnitPrice');\">Number</div></center></td><td width='200' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('NetUnitCost');\">Name</div></td></tr></table>";
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
            DataTable dt = (DataTable)Session["InvoiceRegisterExcel"] ;

            e.Row.Cells[3].Text = "Grand Total";
            e.Row.Cells[6].Text = string.Format("{0:#,##0}", dt.Compute("sum(Qty)", ""));
            e.Row.Cells[9].Text = string.Format("{0:#,##0.00}", dt.Compute("sum(ExtendedPrice)", ""));
            e.Row.Cells[10].Text = string.Format("{0:#,##0.00}", dt.Compute("sum(ExtendedCost)", ""));
            e.Row.Cells[11].Text = string.Format("{0:#,##0.00}", dt.Compute("sum(ExtendedWeight)", ""));

            e.Row.Cells[12].Text = string.Format("{0:#,##0.0}", ((Convert.ToDecimal(dt.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dt.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dt.Compute("sum(ExtendedCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dt.Compute("sum(ExtendedPrice)", "")), 1)) * 100, 1)));
            //e.Row.Cells[13].Text = string.Format("{0:#,##0.0}", ((Convert.ToDecimal(dt.Compute("sum(NetUnitPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dt.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dt.Compute("sum(DisplayRplGMPct)", "")), 1)) / (Math.Round(Convert.ToDecimal(dt.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1)));
            Decimal MarginRplPct = 0.0M;
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

