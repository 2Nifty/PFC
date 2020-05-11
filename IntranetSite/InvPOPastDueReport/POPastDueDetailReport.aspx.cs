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

public partial class POPastDueDetailReport : System.Web.UI.Page
{
    # region Variable Declaration

    POPastDue poPastDue = new POPastDue();
    DataTable dtExcelData = new DataTable();
    DataTable dtPOData = new DataTable();
    GridView dv = new GridView();

    int pageCount = 21;
    string border = "0";// Border is a dynamic variable because we need to print grid headers without border
    string sortExpression = string.Empty;    
    string excelFilePath = "../Common/ExcelUploads/";
    string buyGrpNo = "";

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(POPastDueDetailReport));
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        buyGrpNo = Request.QueryString["BuyGrpNo"].ToString();

        if (!IsPostBack)
        {
            lblReportGroup.Text = Request.QueryString["ReportGrp"].ToString();
            lblBugGroup.Text = Request.QueryString["BuyGrpDesc"].ToString();
            hidFileName.Value = "POPastDueDetailReport" + Session["SessionID"].ToString() + ".xls";
            BindDataGrid();
        }
    }

    private void BindDataGrid()
    {
        dtPOData = poPastDue.GetPOPastDueData("popostduedetail", buyGrpNo);

        if (dtPOData != null && dtPOData.Rows.Count > 0)
        {
            if (hidSort.Value != "")
            {
                dtPOData.DefaultView.Sort = hidSort.Value;                
            }

            gvPOPastDue.DataSource = dtPOData.DefaultView.ToTable();
            pager.InitPager(gvPOPastDue, pageCount);
            Session["RPTPODueData"] = dtPOData.DefaultView.ToTable();
        }
        else
        {
            gvPOPastDue.Visible = false;
            lblStatus.Visible = true;
            pager.Visible = false;
        }        
        upnlGrid.Update();
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        gvPOPastDue.PageIndex = pager.GotoPageNumber;

        BindDataGrid();
    }

    protected void gvPOPastDue_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[1].ColumnSpan = 3;
            e.Row.Cells[1].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>Total Open PO</center></td></tr><tr>"+
                                        "<td width='42' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('TotOpenPOQty');\">Qty</div></center></td><td width='83' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('TotOpenPOLbs');\">Pounds</div></center></td><td width='53' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('OpenPOMosSupply');\">Months</div></td></tr></table>";

            e.Row.Cells[2].Visible = false;
            e.Row.Cells[3].Visible = false;

            e.Row.Cells[4].ColumnSpan = 2;
            e.Row.Cells[4].Text =   "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Past Due</center></td></tr><tr>" +
                                        "<td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('PastDueLbs');\">Pounds</div></center></td><td width='30' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('PastDueMos');\">Months</div></center></td></tr></table>";

            e.Row.Cells[5].Visible = false;

            e.Row.Cells[6].ColumnSpan = 2;
            e.Row.Cells[6].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Current Due</center></td></tr><tr>" +
                                        "<td width='60' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('CurLbs');\">Pounds</div></center></td><td width='30' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('CurMos');\">Months</div></center></td></tr></table>";

            e.Row.Cells[7].Visible = false;

            // Future 1
            e.Row.Cells[8].ColumnSpan = 2;
            e.Row.Cells[8].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Future 1</center></td></tr><tr>" +
                                        "<td width='50' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('Fut1Lbs');\">Pounds</div></center></td><td width='30' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('Fut1Mos');\">Months</div></center></td></tr></table>";

            e.Row.Cells[9].Visible = false;

            // Future 2
            e.Row.Cells[10].ColumnSpan = 2;
            e.Row.Cells[10].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Future 2</center></td></tr><tr>" +
                                        "<td width='50' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('Fut2Lbs');\">Pounds</div></center></td><td width='30' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('Fut2Mos');\">Months</div></center></td></tr></table>";

            e.Row.Cells[11].Visible = false;

            // Future 3
            e.Row.Cells[12].ColumnSpan = 2;
            e.Row.Cells[12].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Future 3</center></td></tr><tr>" +
                                        "<td width='50' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('Fut3Lbs');\">Pounds</div></center></td><td width='30' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('Fut3Mos');\">Months</div></center></td></tr></table>";

            e.Row.Cells[13].Visible = false;  

        }
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            HyperLink hplCatGroup = e.Row.FindControl("hplItemNo") as HyperLink;
            hplCatGroup.ForeColor = System.Drawing.Color.Blue;
            hplCatGroup.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'soeItemFrm', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (750/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");
        }
        if(e.Row.RowType == DataControlRowType.Footer)
        {
            DataTable dtGrandTotal = dtPOData;
            e.Row.Font.Bold = true;
            e.Row.Cells[0].Text = "Grand Total";

            e.Row.Cells[1].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Compute("sum(TotOpenPOQty)", "").ToString()));
            e.Row.Cells[2].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Compute("sum(TotOpenPOLbs)", "").ToString()));
            e.Row.Cells[3].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Compute("sum(OpenPOMosSupply)", "").ToString()));
            e.Row.Cells[4].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Compute("sum(PastDueLbs)", "").ToString()));
            e.Row.Cells[5].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Compute("sum(PastDueMos)", "").ToString()));

            e.Row.Cells[6].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Compute("sum(CurLbs)", "").ToString()));
            e.Row.Cells[7].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Compute("sum(CurMos)", "").ToString()));
            e.Row.Cells[8].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Compute("sum(Fut1Lbs)", "").ToString()));
            e.Row.Cells[9].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Compute("sum(Fut2Lbs)", "").ToString()));
            e.Row.Cells[10].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Compute("sum(Fut2Lbs)", "").ToString()));
            e.Row.Cells[11].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Compute("sum(Fut2Lbs)", "").ToString()));
            e.Row.Cells[12].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Compute("sum(Fut3Lbs)", "").ToString()));
            e.Row.Cells[13].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Compute("sum(Fut3Lbs)", "").ToString()));

            //upnlGrid.Update();
            //DropDownList ddlpager = pager.FindControl("ddlPages") as DropDownList;
            //Label lblTotalPage = pager.FindControl("lblTotalPage") as Label;
            //if (ddlpager.Items.Count - 1 == pager.GotoPageNumber)
            //    gvPOPastDue.ShowFooter = true;
            //else
            gvPOPastDue.ShowFooter = true;
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

    protected void gvPOPastDue_Sorting(object sender, GridViewSortEventArgs e)
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
            //e.Row.Cells[2].ColumnSpan = 3;
            //e.Row.Cells[2].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>Total Open PO</center></td></tr><tr>" +
            //                            "<td width='42' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
            //                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('TotOpenPOQty');\">Qty</div></center></td><td width='69' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
            //                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('TotOpenPOLbs');\">Pounds</div></center></td><td width='53' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
            //                            "<Div onclick=\"javascript:BindValue('OpenPOMosSupply');\">Months</div></td></tr></table>";

            //e.Row.Cells[3].Visible = false;
            //e.Row.Cells[4].Visible = false;

            //e.Row.Cells[5].ColumnSpan = 2;
            //e.Row.Cells[5].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Past Due</center></td></tr><tr>" +
            //                            "<td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
            //                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('PastDueLbs');\">Pounds</div></center></td><td width='30' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
            //                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('PastDueMos');\">Months</div></center></td></tr></table>";

            //e.Row.Cells[6].Visible = false;

            //e.Row.Cells[7].ColumnSpan = 2;
            //e.Row.Cells[7].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Current Due</center></td></tr><tr>" +
            //                            "<td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
            //                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('CurLbs');\">Pounds</div></center></td><td width='30' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
            //                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('CurMos');\">Months</div></center></td></tr></table>";

            //e.Row.Cells[8].Visible = false;

            //// Future 1
            //e.Row.Cells[9].ColumnSpan = 2;
            //e.Row.Cells[9].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Future 1</center></td></tr><tr>" +
            //                            "<td width='60' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
            //                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('Fut1Lbs');\">Pounds</div></center></td><td width='30' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
            //                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('Fut1Mos');\">Months</div></center></td></tr></table>";

            //e.Row.Cells[10].Visible = false;

            //// Future 2
            //e.Row.Cells[11].ColumnSpan = 2;
            //e.Row.Cells[11].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Future 2</center></td></tr><tr>" +
            //                            "<td width='60' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
            //                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('Fut2Lbs');\">Pounds</div></center></td><td width='30' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
            //                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('Fut2Mos');\">Months</div></center></td></tr></table>";

            //e.Row.Cells[12].Visible = false;

            //// Future 3
            //e.Row.Cells[13].ColumnSpan = 2;
            //e.Row.Cells[13].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Future 3</center></td></tr><tr>" +
            //                            "<td width='60' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
            //                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('Fut3Lbs');\">Pounds</div></center></td><td width='30' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
            //                            "<Div style='cursor:hand;' onclick=\"javascript:BindValue('Fut3Mos');\">Months</div></center></td></tr></table>";

            //e.Row.Cells[14].Visible = false;  
        }
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            DataTable dtGrandTotal = dtExcelData;
            e.Row.Font.Bold = true;
            e.Row.Cells[0].Text = "Grand Total";

            e.Row.Cells[1].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Compute("sum(TotOpenPOQty)", "").ToString()));
            e.Row.Cells[2].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Compute("sum(TotOpenPOLbs)", "").ToString()));
            e.Row.Cells[3].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Compute("sum(OpenPOMosSupply)", "").ToString()));
            e.Row.Cells[4].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Compute("sum(PastDueLbs)", "").ToString()));
            e.Row.Cells[5].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Compute("sum(PastDueMos)", "").ToString()));

            e.Row.Cells[6].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Compute("sum(CurLbs)", "").ToString()));
            e.Row.Cells[7].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Compute("sum(CurMos)", "").ToString()));
            e.Row.Cells[8].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Compute("sum(Fut1Lbs)", "").ToString()));
            e.Row.Cells[9].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Compute("sum(Fut2Lbs)", "").ToString()));
            e.Row.Cells[10].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Compute("sum(Fut2Lbs)", "").ToString()));
            e.Row.Cells[11].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Compute("sum(Fut2Lbs)", "").ToString()));
            e.Row.Cells[12].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Compute("sum(Fut3Lbs)", "").ToString()));
            e.Row.Cells[13].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Compute("sum(Fut3Lbs)", "").ToString()));
            gvPOPastDue.ShowFooter = true;
        }
        
    }

    private string GenerateExportData(string dataFormat)
    {
        border = (dataFormat == "Print" ? "0" : "1");
        dtExcelData = Session["RPTPODueData"] as DataTable;        

        string styleSheet = "<style>.text { mso-number-format:\\@; } </style>";
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;

        headerContent =     "<table border='" + border + "' width='100%'>";
        headerContent += "<tr><th colspan='14' style='color:blue' align=left><center>PO Past Due Detail Report</center></th></tr>";
        headerContent += "<tr><td colspan='5'><b>Report Group:"+ lblReportGroup.Text +"</b></td><td colspan='5'><b>Buy Group:"+lblBugGroup.Text +"</b></td><td colspan='4' align=right><b>Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;  Run Date: " + DateTime.Now.ToShortDateString() + "</></td></tr>";
        headerContent += "<tr><th colspan='14' style='color:blue' align=left></th></tr>";

        if (dtExcelData.Rows.Count > 0)
        {
            dv.AutoGenerateColumns = false;
            dv.ShowHeader = true;
            dv.ShowFooter = true;            
            dv.RowDataBound += new GridViewRowEventHandler(dv_RowDataBound);

            BoundField bfExcel = new BoundField();
            bfExcel.HeaderText = "Item No";
            bfExcel.DataField = "ItemNo";            
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Tot Open PO Qty";
            bfExcel.DataField = "TotOpenPOQty";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Tot Open PO Qty";
            bfExcel.DataField = "TotOpenPOLbs";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Tot Open PO Mos";
            bfExcel.DataField = "OpenPOMosSupply";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Past Due Lbs";
            bfExcel.DataField = "PastDueLbs";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Past Due Mos";
            bfExcel.DataField = "PastDueMos";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Current Lbs";
            bfExcel.DataField = "CurLbs";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);
            
            bfExcel = new BoundField();
            bfExcel.HeaderText = "Current Mos";
            bfExcel.DataField = "CurMos";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Future 1 Lbs";
            bfExcel.DataField = "Fut1Lbs";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;            
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Future 1 Mos";
            bfExcel.DataField = "Fut1Mos";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;            
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Future 2 Lbs";
            bfExcel.DataField = "Fut2Lbs";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Future 2 Mos";
            bfExcel.DataField = "Fut2Mos";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Future 3 Lbs";
            bfExcel.DataField = "Fut3Lbs";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Future 3 Mos";
            bfExcel.DataField = "Fut3Mos";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
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

}

