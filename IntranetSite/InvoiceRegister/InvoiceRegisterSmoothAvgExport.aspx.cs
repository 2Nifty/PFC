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
using System.Text.RegularExpressions;
using PFC.Intranet.InvoiceRegister;

public partial class InvoiceRegisterSmoothAvg_print : System.Web.UI.Page
{

    DataTable dtInvoiceExcel = new DataTable();
    DataTable dtInvoiceBranch = new DataTable();
    DataTable dtInvoice = new DataTable();
    InvoiceRegisterReport invoice = new InvoiceRegisterReport();
    GridView dv = new GridView();

    string _startDate = "";
    string _endDate = "";
    string subTotalType = "";
    string subTotalDesc = "";
    string branchID = "";
    string branchDesc = "";
    decimal minMargin = 0;
    decimal maxMargin = 100;
    string userName = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        _startDate = Request.QueryString["StartDate"].ToString();
        _endDate = Request.QueryString["EndDate"].ToString();
        subTotalType = Request.QueryString["SubTotalType"].ToString();
        subTotalDesc = Request.QueryString["SubTotalTypeDesc"].ToString();
        branchID = Request.QueryString["BranchID"].ToString();
        branchDesc = Request.QueryString["BranchDesc"].ToString();


        DataTable dtMargin = invoice.GetMarginValue();
        if (dtMargin != null && dtMargin.Rows.Count > 0)
        {
            maxMargin = Convert.ToDecimal(dtMargin.Rows[1]["AppOptionValue"].ToString()) * 100;
            minMargin = Convert.ToDecimal(dtMargin.Rows[0]["AppOptionValue"].ToString()) * 100;
            ViewState["MaxMargin"] = maxMargin.ToString();
            ViewState["MinMargin"] = minMargin.ToString();
        }


        CreateDocument();
    }

    private void CreateDocument()
    {
        dtInvoiceExcel = new DataTable();
        string headerContent = string.Empty;
        string excelContent = string.Empty;

        dtInvoice = invoice.GetInvoiceData(_startDate, _endDate);
        dtInvoiceExcel = GetExcelTable(dtInvoice);

        headerContent = "<table border='0' width=100% cellpadding=1 cellspacing=0 >";

        headerContent += "<tr><th colspan='18' style='color:blue' align=left><center>Smooth Average Invoice Register</center></th></tr>";
        headerContent += "<tr><td colspan='2' style='padding-bottom:15px;' ><b>StartDate :" + _startDate + "</b></td><td  colspan='2' style='padding-bottom:15px;' ><b>End Date:" + _endDate + "</b></td>";
        headerContent += "</b></td><td style='padding-bottom:15px;'><b>Show Sub-Totals:" + subTotalDesc + "</b></td><td style='padding-bottom:15px;'><b>Branch:" + branchID +
            "</b></td><td colspan='4' style='padding-bottom:15px;' ><b>Run By: " + userName + "&nbsp;&nbsp;  Run Date: " + DateTime.Now.ToShortDateString() + "</></td></tr>";
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
            bfExcel.DataField = "StdCostPct";
            bfExcel.HeaderText = "Smooth Avg";
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
        Response.Write(Session["PrintContent"]);
        //ScriptManager.RegisterClientScriptBlock(ibtnPrint, ibtnPrint.GetType(), "Print", "PrintReport();", true);
    }

    private DataTable GetExcelTable(DataTable dtValue)
    {
        DataRow drSum;
        DataTable dtMain = new DataTable();
        DataTable dtInvoiceReturn = null;
        //DataTable dtInvoiceReturn;
        if (dtValue.Rows.Count > 0)
        {
            dtValue.DefaultView.RowFilter = (branchDesc != "ALL") ? "BranchSls='" + branchID+ "'" : "";
            if (dtValue.DefaultView.ToTable(true, "BranchSls").Rows.Count > 0)
            {
                DataTable dtBranchGroup = dtValue.DefaultView.ToTable(true, "BranchSls");

                foreach (DataRow drBranch in dtBranchGroup.Rows)
                {
                    dtValue.DefaultView.RowFilter = "BranchSls  ='" + drBranch["BranchSls"].ToString() + "'";
                    dtInvoiceBranch = dtValue.DefaultView.ToTable();

                    if (subTotalDesc != "ALL")
                    {
                        DataTable dtGroup = dtInvoiceBranch.DefaultView.ToTable(true, subTotalType);
                        dtMain = dtInvoiceBranch.Clone();
                        if (dtInvoiceReturn == null)
                            dtInvoiceReturn = dtMain.Clone();
                        foreach (DataRow dr in dtGroup.Rows)
                        {
                            try
                            {
                                dtInvoiceBranch.DefaultView.RowFilter = subTotalType + "='" + dr[subTotalType].ToString() + "'";
                                DataTable dtFiltered = dtInvoiceBranch.DefaultView.ToTable();


                                // dtTotal.Merge(dtFiltered);
                                dtMain.Merge(dtFiltered);
                                drSum = dtMain.NewRow();

                                drSum["ItemDescription"] = subTotalDesc+ " Totals";
                                drSum["Qty"] = dtFiltered.Compute("sum(Qty)", "");
                                drSum["ExtendedPrice"] = dtFiltered.Compute("sum(ExtendedPrice)", "");
                                drSum["ExtendedCost"] = dtFiltered.Compute("sum(ExtendedCost)", "");
                                drSum["ExtendedWeight"] = dtFiltered.Compute("sum(ExtendedWeight)", "");
                                drSum["MarginPct"] = ((Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")), 1)) * 100, 1));
                                drSum["SellPerLb"] = ((Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedWeight)", "")));
                                drSum[subTotalType] = dr[subTotalType];
                                if (Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")), 0) == 0)
                                {
                                    drSum["StdCostPct"] = 0;
                                }
                                else
                                {
                                    drSum["StdCostPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtFiltered.Compute("sum(StdCostDol)", "")), 1)) / (Convert.ToDecimal(dtFiltered.Compute("sum(ExtendedPrice)", ""))) * 100, 1);
                                }
                                if (subTotalType == "SellToCustomerNumber")
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
                                        if (Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "")), 0) == 0)
                                        {
                                            drSum["StdCostPct"] = 0;
                                        }
                                        else
                                        {
                                            drSum["StdCostPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(StdCostDol)", "")), 1)) / (Convert.ToDecimal(dtInvoiceFiltered.Compute("sum(ExtendedPrice)", ""))) * 100, 1);
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
                                    if (Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedPrice)", "")), 0) == 0)
                                    {
                                        drSum["StdCostPct"] = 0;
                                    }
                                    else
                                    {
                                        drSum["StdCostPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtCustomerFiltered.Compute("sum(StdCostDol)", "")), 1)) / (Convert.ToDecimal(dtCustomerFiltered.Compute("sum(ExtendedPrice)", "")) * 100), 1);
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
                                if (Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedPrice)", "")), 0) == 0)
                                {
                                    drSum["StdCostPct"] = 0;
                                }
                                else
                                {
                                    drSum["StdCostPct"] = Math.Round((Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtRepFiltered.Compute("sum(StdCostDol)", "")), 1)) / (Convert.ToDecimal(dtRepFiltered.Compute("sum(ExtendedPrice)", ""))) * 100, 1);
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
                        if (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedPrice)", "")) == 0)
                        {
                            drSum["StdCostPct"] = 0;
                        }
                        else
                        {
                            drSum["StdCostPct"] = (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedPrice)", "")) == 0 ? 0 : (Math.Round((Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dtInvoiceBranch.Compute("sum(StdCostDol)", "")), 1)) / (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedPrice)", ""))) * 100, 1)));
                        }

                        drSum["SellPerLb"] = (Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedWeight)", "")) == 0 ? 0 : ((Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dtInvoiceBranch.Compute("sum(ExtendedWeight)", ""))));
                        drSum["BranchSls"] = dtInvoiceBranch.Rows[0]["BranchSls"];
                        dtMain.Rows.Add(drSum);
                        dtInvoiceReturn.Merge(dtMain);
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
                                        "<Div onclick=\"javascript:BindValue('StdCostPct');\">Smooth</div></td></tr></table>";


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
            DataTable dt = (subTotalDesc == "ALL") ? dtInvoice : dtInvoiceBranch;

            e.Row.Cells[3].Text = "Grand Total";
            e.Row.Cells[6].Text = string.Format("{0:#,##0}", dt.Compute("sum(Qty)", ""));
            e.Row.Cells[9].Text = string.Format("{0:#,##0.00}", dt.Compute("sum(ExtendedPrice)", ""));
            e.Row.Cells[10].Text = string.Format("{0:#,##0.00}", dt.Compute("sum(ExtendedCost)", ""));
            e.Row.Cells[11].Text = string.Format("{0:#,##0.00}", dt.Compute("sum(ExtendedWeight)", ""));

            e.Row.Cells[12].Text = string.Format("{0:#,##0.0}", ((Convert.ToDecimal(dt.Compute("sum(ExtendedPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dt.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dt.Compute("sum(ExtendedCost)", "")), 1)) / (Math.Round(Convert.ToDecimal(dt.Compute("sum(ExtendedPrice)", "")), 1)) * 100, 1)));
            //e.Row.Cells[13].Text = string.Format("{0:#,##0.0}", ((Convert.ToDecimal(dt.Compute("sum(NetUnitPrice)", "")) == 0) ? 0 : Math.Round((Math.Round(Convert.ToDecimal(dt.Compute("sum(NetUnitPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dt.Compute("sum(DisplayRplGMPct)", "")), 1)) / (Math.Round(Convert.ToDecimal(dt.Compute("sum(NetUnitPrice)", "")), 1)) * 100, 1)));
            Decimal MarginRplPct = 0.0M;
            if (Convert.ToDecimal(dt.Compute("sum(ExtendedPrice)", "")) == 0)
            {
                MarginRplPct = 0;
            }
            else
            {
                MarginRplPct = (Math.Round((Math.Round(Convert.ToDecimal(dt.Compute("sum(ExtendedPrice)", "")), 1) - Math.Round(Convert.ToDecimal(dt.Compute("sum(StdCostDol)", "")), 1)) / (Convert.ToDecimal(dt.Compute("sum(ExtendedPrice)", ""))) * 100, 1));
            }

            e.Row.Cells[13].Text = string.Format("{0:#,##0.0}", MarginRplPct);
            e.Row.Cells[14].Text = string.Format("{0:#,##0.00}", ((Convert.ToDecimal(dt.Compute("sum(ExtendedWeight)", "")) == 0) ? 0 : Convert.ToDecimal(dt.Compute("sum(ExtendedPrice)", "")) / Convert.ToDecimal(dt.Compute("sum(ExtendedWeight)", ""))));
            dv.ShowFooter = true;
            dv.FooterStyle.Font.Bold = true;

        }
    }

}
