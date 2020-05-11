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

public partial class QuoteMetricsReport : System.Web.UI.Page
{
    # region Variable Declaration
    
    QuoteMetrics quoteMetrics = new QuoteMetrics();
    DataTable dtExcelData = new DataTable();
    DataSet dsQuoteData = new DataSet();
    GridView dv = new GridView();

    int pageCount = 17;
    string border = "0";// Border is a dynamic variable because we need to print grid headers without border
    string StartDate = "";
    string EndDate = "";
    string BranchID = "";
    string SalesPerson = "";
    string BranchDesc = "";
    string sortExpression = string.Empty;    
    string excelFilePath = "../Common/ExcelUploads/";
    
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(QuoteMetricsReport));
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        StartDate = Request.QueryString["StartDate"].ToString();
        EndDate = Request.QueryString["EndDate"].ToString();
        BranchID = Request.QueryString["Branch"].ToString();
        SalesPerson = (Request.QueryString["SalesPerson"].ToString() == "" ? "ALL" : Request.QueryString["SalesPerson"].ToString());
        BranchDesc = (Request.QueryString["BranchName"].ToString() == "" ? "ALL" : Request.QueryString["BranchName"].ToString());
 
        if (!IsPostBack)
        {
            Session["RPTQuoteData"] = null;
            hidFileName.Value = "QuoteMetricsReport" + Session["SessionID"].ToString() + ".xls";

            lblStartDt.Text = StartDate;
            lblEndDt.Text = EndDate;
            lblBranch.Text = BranchDesc;
            lblSalesPerson.Text = SalesPerson;

            BindDataGrid();
        }
    }

    private void BindDataGrid()
    {
        if (Session["RPTQuoteData"] == null || hidSort.Value != "")
        {
           
            DataSet _dsQuoteData = quoteMetrics.GetQuoteMetricsData(StartDate, EndDate, BranchID, Request.QueryString["SalesPerson"].ToString(), hidSort.Value);
            if (chkOnlySubTotal.Checked) // if user wants to see only subtotal filter the override the session varible with only subtotals records
            {
                DataTable _dtTempgrandTotal = _dsQuoteData.Tables[1];
                _dsQuoteData.Tables[0].DefaultView.RowFilter = "PFCItemNo='Total'";
                DataTable _dtFilteredQuoteData = _dsQuoteData.Tables[0].DefaultView.ToTable();
                _dsQuoteData.Tables.Clear();
                _dsQuoteData.Tables.Add(_dtFilteredQuoteData);
                _dsQuoteData.Tables.Add(_dtTempgrandTotal);
            }
            
            Session["RPTQuoteData"] = _dsQuoteData;
            hidSort.Value = "";
        }

        dsQuoteData = Session["RPTQuoteData"] as DataSet;
        if (dsQuoteData != null)
        {
            DataTable dtQuoteData = dsQuoteData.Tables[0];
            if (dtQuoteData != null && dtQuoteData.Rows.Count > 0)
            {
                gvQuoteMetrics.DataSource = dtQuoteData.DefaultView.ToTable();
                pager.InitPager(gvQuoteMetrics, pageCount);
            }
            else
            {
                gvQuoteMetrics.Visible = false;
                lblStatus.Visible = true;
                pager.Visible = false;
            }
        }
        upnlGrid.Update();
        pnlBranch.Update();        

    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        gvQuoteMetrics.PageIndex = pager.GotoPageNumber;

        BindDataGrid();
    }

    protected void gvQuoteMetrics_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[3].ColumnSpan = 2;
            e.Row.Cells[3].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Final Quote</center></td></tr><tr><td width='53' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('RequestQuantity');\">Req Qty</div></center></td><td width='45' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('AvailableQuantity');\">Avl Qty</div></td></tr></table>";

            e.Row.Cells[4].Visible = false;

            e.Row.Cells[6].ColumnSpan = 3;
            e.Row.Cells[6].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>Initial Entry</center></td></tr><tr><td width='43' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('InitialReqQty');\">Req Qty</div></center></td><td width='42' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('InitialAvailableQty');\">Avl Qty</div></center></td><td width='38' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('InitialLocationCode');\">Loc</div></td></tr></table>";

            e.Row.Cells[7].Visible = false;
            e.Row.Cells[8].Visible = false;

            e.Row.Cells[9].ColumnSpan = 2;
            e.Row.Cells[9].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Sales Person</center></td></tr><tr><td width='73' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('Name');\">Name</div></center></td><td width='39' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('OELoc');\">Loc</div></td></tr></table>";

            e.Row.Cells[10].Visible = false;


            e.Row.Cells[13].ColumnSpan = 3;
            e.Row.Cells[13].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>Count</center></td></tr><tr><td width='52' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('LineCnt');\">Lines</div></center></td><td width='55' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('AvlShort');\">Avl Short</div></center></td><td width='65' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('MadeOrder');\">Made Order</div></td></tr></table>";

            e.Row.Cells[14].Visible = false;
            e.Row.Cells[15].Visible = false;
        }
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (e.Row.Cells[0].Text.Trim() == "Total")
            {
                e.Row.Font.Bold = true;
                e.Row.Cells[10].Visible = false;
                e.Row.Cells[0].Text = "";
                e.Row.Cells[9].ColumnSpan = 2;
                e.Row.Cells[9].Width = 100;                
            }
        }
        if(e.Row.RowType == DataControlRowType.Footer)
        {
            DataTable  dtGrandTotal = dsQuoteData.Tables[1];
            e.Row.Font.Bold = true;
            e.Row.Cells[10].Visible = false;
            e.Row.Cells[9].ColumnSpan = 2;
            e.Row.Cells[9].Text = "Grand Total";
            
            e.Row.Cells[11].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["Quote"].ToString()));
            e.Row.Cells[12].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["MadeOrd"].ToString()));
            e.Row.Cells[13].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["LineCnt"].ToString()));
            e.Row.Cells[14].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["AvlShort"].ToString()));
            e.Row.Cells[15].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["MadeOrder"].ToString()));

            //upnlGrid.Update();
            //DropDownList ddlpager = pager.FindControl("ddlPages") as DropDownList;
            //Label lblTotalPage = pager.FindControl("lblTotalPage") as Label;
            //if (ddlpager.Items.Count -1 == pager.GotoPageNumber)
            //    gvQuoteMetrics.ShowFooter = true;
            //else
            //    gvQuoteMetrics.ShowFooter = false;
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
        BindDataGrid();
    }

    protected void gvQuoteMetrics_Sorting(object sender, GridViewSortEventArgs e)
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

    #region Export Options

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        string _excelData = GenerateExportData("Excel");

        FileInfo fnExcel = new FileInfo(Server.MapPath(excelFilePath + hidFileName.Value.ToString()));             
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();        
        reportWriter.WriteLine(_excelData);
        reportWriter.Close();

        // Downloding Process
        FileStream fileStream = File.Open(Server.MapPath(excelFilePath + hidFileName.Value.ToString()), FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        // Download Process
        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath(excelFilePath + hidFileName.Value.ToString())));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }

    protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
    {
        string excelContent = GenerateExportData("Print");

        string pattern = @"\s*\r?\n\s*";
        excelContent = Regex.Replace(excelContent, pattern, "");
        excelContent = Regex.Replace(excelContent, "<tr><th", "<THEAD style='display:table-header-group;'><TR><th").Replace("</th></tr>", "</th></TR></THEAD>");
        excelContent = excelContent.Replace("BORDER-COLLAPSE: collapse;", "border-collapse:separate;").Replace("BORDER-LEFT: #c9c6c6 1px solid;", "BORDER-LEFT: #c9c6c6 0px solid;").Replace("BORDER-RIGHT: #c9c6c6 1px solid;", "BORDER-RIGHT: #c9c6c6 0px solid;");
        excelContent = excelContent.Replace("BORDER-TOP: #c9c6c6 1px solid;", "BORDER-TOP: #c9c6c6 0px solid;").Replace("BORDER-BOTTOM: #c9c6c6 1px solid;", "BORDER-BOTTOM: #c9c6c6 0px solid;");

        Session["PrintContent"] = excelContent;
        ScriptManager.RegisterClientScriptBlock(ibtnPrint, ibtnPrint.GetType(), "Print", "PrintReport();", true);
    }

    protected void dv_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[3].ColumnSpan = 2;
            e.Row.Cells[3].Text = "<table border='" + border + "' style='font-weight:bold;' cellpadding='0' cellspacing='0'  width='100%'><tr><td  colspan=2 nowrap ><center>Final Quote</center></td></tr><tr><td width='53' nowrap ><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('RequestQuantity');\">Req Qty</div></center></td><td width='45' nowrap align='center' nowrap >" +
                                        "<Div onclick=\"javascript:BindValue('AvailableQuantity');\">Avl Qty</div></td></tr></table>";

            e.Row.Cells[4].Visible = false;

            e.Row.Cells[6].ColumnSpan = 3;
            e.Row.Cells[6].Text = "<table border='" + border + "' style='font-weight:bold;' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' colspan=3 nowrap ><center>Initial Entry</center></td></tr><tr><td width='43'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('InitialReqQty');\">Req Qty</div></center></td><td width='42' align='center'>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('InitialAvailableQty');\">Avl Qty</div></center></td><td width='38' align='center'>" +
                                        "<Div onclick=\"javascript:BindValue('InitialLocationCode');\">Loc</div></td></tr></table>";

            e.Row.Cells[7].Visible = false;
            e.Row.Cells[8].Visible = false;

            e.Row.Cells[9].ColumnSpan = 2;
            e.Row.Cells[9].Text = "<table border='" + border + "' style='font-weight:bold;'  cellpadding='0' cellspacing='0'  width='100%'><tr><td colspan=2 nowrap ><center>Sales Person</center></td></tr><tr><td width='73' ><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('Name');\">Name</div></center></td><td width='39'>" +
                                        "<Div onclick=\"javascript:BindValue('OELoc');\">Loc</div></td></tr></table>";

            e.Row.Cells[10].Visible = false;


            e.Row.Cells[13].ColumnSpan = 3;
            e.Row.Cells[13].Text = "<table border='" + border + "' style='font-weight:bold;'  cellpadding='0' cellspacing='0'  width='100%'><tr><td colspan=3 nowrap ><center>Count</center></td></tr><tr><td width='52'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('LineCnt');\">Lines</div></center></td><td width='55' >" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('AvlShort');\">Avl Short</div></center></td><td width='65'>" +
                                        "<Div onclick=\"javascript:BindValue('MadeOrder');\">Made Order</div></td></tr></table>";

            e.Row.Cells[14].Visible = false;
            e.Row.Cells[15].Visible = false;
        }
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            e.Row.Cells[1].Attributes.Add("class", "text");
            e.Row.Cells[8].Attributes.Add("class", "text");
            e.Row.Cells[10].Attributes.Add("class", "text");

            if (e.Row.Cells[0].Text.Trim() == "Total")
            {
                e.Row.Font.Bold = true;
                e.Row.Cells[10].Visible = false;
                e.Row.Cells[0].Text = "";
                e.Row.Cells[9].ColumnSpan = 2;                
            }
        }
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            DataSet _dsQuoteData = Session["RPTQuoteData"] as DataSet;
            DataTable _dtGrandTotal = _dsQuoteData.Tables[1];
            e.Row.Font.Bold = true;
            e.Row.Cells[10].Visible = false;
            e.Row.Cells[9].ColumnSpan = 2;
            e.Row.Cells[9].Text = "Grand Total";
            e.Row.Cells[9].HorizontalAlign = HorizontalAlign.Center;

            e.Row.Cells[11].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(_dtGrandTotal.Rows[0]["Quote"].ToString()));
            e.Row.Cells[12].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(_dtGrandTotal.Rows[0]["MadeOrd"].ToString()));
            e.Row.Cells[13].Text = String.Format("{0:#,##0}", Convert.ToDecimal(_dtGrandTotal.Rows[0]["LineCnt"].ToString()));
            e.Row.Cells[14].Text = String.Format("{0:#,##0}", Convert.ToDecimal(_dtGrandTotal.Rows[0]["AvlShort"].ToString()));
            e.Row.Cells[15].Text = String.Format("{0:#,##0}", Convert.ToDecimal(_dtGrandTotal.Rows[0]["MadeOrder"].ToString()));

        }
    }

    private string GenerateExportData(string dataFormat)
    {
        border = (dataFormat == "Print" ? "0" : "1");
        DataSet _dsQuoteData = Session["RPTQuoteData"] as DataSet;
        dtExcelData = new DataTable();

        string styleSheet = "<style>.text { mso-number-format:\\@; } </style>";
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;

        dtExcelData = _dsQuoteData.Tables[0];

        headerContent =     "<table border='" + border + "' width='100%'>";
        headerContent +=    "<tr><th colspan='16' style='color:blue' align=left><center>Quote Metrics Report</center></th></tr>";
        headerContent += "<tr><td colspan='3'><b>Beginning Date :" + StartDate + "</b></td><td  colspan='3'><b>Ending Date:" + EndDate + "</b></td><td colspan='10'></td></tr>";
        headerContent +=    "<tr><td  colspan='3'> <b>Branch:" + BranchDesc + "</b></td>" +                           
                            "<td  colspan='3'><b>Sales Person: " + SalesPerson + "</b></td>" +
                            "<td colspan='5'><b>Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;  Run Date: " + DateTime.Now.ToShortDateString() + "</></td></tr>";
        headerContent += "<tr><th colspan='16' style='color:blue' align=left></th></tr>";

        if (dtExcelData.Rows.Count > 0)
        {
            dv.AutoGenerateColumns = false;
            dv.ShowHeader = true;
            dv.ShowFooter = true;
            dv.RowDataBound += new GridViewRowEventHandler(dv_RowDataBound);

            BoundField bfExcel = new BoundField();
            bfExcel.HeaderText = "ItemNo";
            bfExcel.DataField = "PFCItemNo";
            bfExcel.DataFormatString = "{0:MM/dd/yy}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Sales Loc";
            bfExcel.DataField = "SalesLocationCode";
            bfExcel.DataFormatString = "{0:00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Customer Name";
            bfExcel.DataField = "CustomerName";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "RequestQuantity";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "AvailableQuantity";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Quote Date";
            bfExcel.DataField = "QuotationDate";
            bfExcel.DataFormatString = "{0:MM/dd/yy}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "InitialRequestQty";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "InitialAvailableQty";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "InitialLocationCode";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "Name";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "OELoc";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Quote $";
            bfExcel.DataField = "Quote";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Ordered $";
            bfExcel.DataField = "MadeOrd";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "LineCnt";
            bfExcel.DataFormatString = "{0:#,##0.0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "AvlShort";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.DataField = "MadeOrder";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            dv.DataSource = dtExcelData;
            dv.DataBind();

            System.Text.StringBuilder sb = new System.Text.StringBuilder();
            System.IO.StringWriter sw = new System.IO.StringWriter(sb);
            HtmlTextWriter htw = new HtmlTextWriter(sw);
            dv.RenderControl(htw);
            excelContent = sb.ToString();

        }
        else
        {
            excelContent = "<tr  ><th width='100%' align ='center' colspan='18' > No records found</th></tr> </table>";
        }

        return styleSheet + headerContent + excelContent;
    }

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath(excelFilePath));

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

    protected void chkOnlySubTotal_CheckedChanged(object sender, EventArgs e)
    {
        Session["RPTQuoteData"] = null;
        BindDataGrid();
    }


}

