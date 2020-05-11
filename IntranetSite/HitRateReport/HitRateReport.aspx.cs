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

public partial class HitRateReport : System.Web.UI.Page
{
    # region Variable Declaration
    
    QuoteMetrics quoteMetrics = new QuoteMetrics();
    DataTable dtExcelData = new DataTable();
    DataSet dsQuoteData = new DataSet();
    GridView dv = new GridView();

    string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
    int     pageCount = 20;
    string border = "0";// Border is a dynamic variable because we need to print grid headers without border
    protected string RegionCd = "";
    protected string RegionName = "";
    protected string NoOfDays = "";
    protected string SalesRepCd = "";
    protected string SalesRepName = "";
    protected string sortExpression = string.Empty;    
    string excelFilePath = "../Common/ExcelUploads/";
    string dataFormat;

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(HitRateReport));
        Response.Cache.SetCacheability(HttpCacheability.NoCache);

        RegionCd = (Request.QueryString["RegionCd"].ToString() == "ALL" ? "" : Request.QueryString["RegionCd"].ToString());
        RegionName = (RegionCd == "" ? "ALL" : Request.QueryString["RegionCd"].ToString());
        NoOfDays = Request.QueryString["NoOfDays"].ToString();
        SalesRepCd = (Request.QueryString["SalesPersonCd"].ToString() == "ALL" ? "" : Request.QueryString["SalesPersonCd"].ToString());
        SalesRepName = (SalesRepCd == "" ? "ALL" : Request.QueryString["SalesPersonName"].ToString());        
 
        if(!IsPostBack)
        {
            Session["RPTHitRateData"] = null;
            hidFileName.Value = "HitRateReport" + Session["SessionID"].ToString() + ".xls";

            lblRegion.Text = RegionName;
            lblCSRName.Text = SalesRepName;
            lblDays.Text = NoOfDays + " Days";

            BindDataGrid();
        }
    }

    private void BindDataGrid()
    {
        if (Session["RPTHitRateData"] == null)
        {
            DataSet _dsQuoteData = GetHitRateReportData(RegionCd, NoOfDays, SalesRepCd);
            Session["RPTHitRateData"] = _dsQuoteData;
            hidSort.Value = "";
        }

        dsQuoteData = Session["RPTHitRateData"] as DataSet;
        if (dsQuoteData != null)
        {
            DataTable dtQuoteData = dsQuoteData.Tables[0];
            if (hidSort.Value != "")
                dsQuoteData.Tables[0].DefaultView.Sort = hidSort.Value;
            
            if (dtQuoteData != null && dtQuoteData.Rows.Count > 0)
            {
                gvHitRate.DataSource = dtQuoteData.DefaultView.ToTable();
                pager.InitPager(gvHitRate, pageCount);
            }
            else
            {
                gvHitRate.Visible = false;
                lblStatus.Visible = true;
                pager.Visible = false;
            }
        }
        upnlGrid.Update();
        pnlBranch.Update();        

    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        gvHitRate.PageIndex = pager.GotoPageNumber;

        BindDataGrid();
    }

    protected void gvHitRate_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            // Hit Rate %
            e.Row.Cells[2].ColumnSpan = 5;
            e.Row.Cells[2].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=5 nowrap ><center>Hit Rate % Based on:</center></td></tr><tr>"+
                                        "<td width='45' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('LbsHitRate');\">Lbs</div></center></td>" +
                                        "<td width='46' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('AvlHitRate');\">Avl Qty</div></td>" +
                                        "<td width='50' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('LnCntHitRage');\">Line Cnt</div></td>" +
                                        "<td width='46' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('ValueHitRate');\">Sell$</div></td>" +
                                        "<td width='45' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('GMHitRate');\">GM$</div></td>" +
                                        "</tr></table>";

            e.Row.Cells[3].Visible = false;
            e.Row.Cells[4].Visible = false;
            e.Row.Cells[5].Visible = false;
            e.Row.Cells[6].Visible = false;

            // Sales $
            e.Row.Cells[7].ColumnSpan = 2;
            e.Row.Cells[7].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Sales $</center></td></tr><tr>" +
                                        "<td width='60' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ValueOGQty');\">Quoted</div></center></td>" +
                                        "<td width='55' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('ValueMOQty');\">Ordered</div></td>" +
                                        "</tr></table>";

            e.Row.Cells[8].Visible = false;

            // GM $
            e.Row.Cells[9].ColumnSpan = 2;
            e.Row.Cells[9].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>GM $</center></td></tr><tr>" +
                                        "<td width='50' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('GMOGQty');\">Quoted</div></center></td>" +
                                        "<td width='48' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('GMMOQty');\">Ordered</div></td>" +
                                        "</tr></table>";

            e.Row.Cells[10].Visible = false;

            // GM $
            e.Row.Cells[11].ColumnSpan = 3;
            e.Row.Cells[11].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>GM %</center></td></tr><tr>" +
                                        "<td width='50' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('GMOG');\">Quoted</div></center></td>" +
                                        "<td width='50' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('GMMO');\">Ordered</div></td>" +
                                        "<td width='45' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('GMDiff');\">Diff</div></td>" +
                                        "</tr></table>";

            e.Row.Cells[12].Visible = false;
            e.Row.Cells[13].Visible = false;

            // Pounds
            e.Row.Cells[14].ColumnSpan = 2;
            e.Row.Cells[14].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Pounds</center></td></tr><tr>" +
                                        "<td width='60' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('LbsOGQty');\">Quoted</div></center></td>" +
                                        "<td width='55' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('LbsMOQty');\">Ordered</div></td>" +
                                        "</tr></table>";

            e.Row.Cells[15].Visible = false;

            // Line Count
            e.Row.Cells[16].ColumnSpan = 2;
            e.Row.Cells[16].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Line Count</center></td></tr><tr>" +
                                        "<td width='50' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('MOLineCnt');\">Quoted</div></center></td>" +
                                        "<td width='56' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('TotLineCnt');\">Ordered</div></td>" +
                                        "</tr></table>";

            e.Row.Cells[17].Visible = false;

            // Sales $ Per Lb
            e.Row.Cells[18].ColumnSpan = 2;
            e.Row.Cells[18].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Sales $ Per Lb</center></td></tr><tr>" +
                                        "<td width='52' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ValueOGPerLb');\">Quoted</div></center></td>" +
                                        "<td width='54' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('ValueMOPerLb');\">Ordered</div></td>" +
                                        "</tr></table>";

            e.Row.Cells[19].Visible = false;

            // GM Per Lb
            e.Row.Cells[20].ColumnSpan = 2;
            e.Row.Cells[20].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>GM Per Lb</center></td></tr><tr>" +
                                        "<td width='52' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('GMOGPerLb');\">Quoted</div></center></td>" +
                                        "<td width='54' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('GMMOPerLb');\">Ordered</div></td>" +
                                        "</tr></table>";

            e.Row.Cells[21].Visible = false;
        }
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            DataTable dtGrandTotal = dsQuoteData.Tables[1];
            e.Row.Font.Bold = true;
            e.Row.Cells[0].Visible = false;
            e.Row.Cells[1].ColumnSpan = 2;
            e.Row.Cells[1].Text = "Grand Total";

            // Hit Rate %
            e.Row.Cells[2].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["LbsHitRate"].ToString()));
            e.Row.Cells[3].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["AvlHitRate"].ToString()));
            e.Row.Cells[4].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["LnCntHitRage"].ToString()));
            e.Row.Cells[5].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["ValueHitRate"].ToString()));
            e.Row.Cells[6].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["GMHitRate"].ToString()));

            // Sales $
            e.Row.Cells[7].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["ValueOGQty"].ToString()));
            e.Row.Cells[8].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["ValueMOQty"].ToString()));

            // GM $
            e.Row.Cells[9].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["GMOGQty"].ToString()));
            e.Row.Cells[10].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["GMMOQty"].ToString()));
            
            // GM %
            e.Row.Cells[11].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["GMOG"].ToString()));
            e.Row.Cells[12].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["GMMO"].ToString()));
            e.Row.Cells[13].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["GMDiff"].ToString()));


            // Pounds
            e.Row.Cells[14].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["LbsOGQty"].ToString()));
            e.Row.Cells[15].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["LbsMOQty"].ToString()));
            
            // Line Count
            e.Row.Cells[16].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["MOLineCnt"].ToString()));
            e.Row.Cells[17].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["TotLineCnt"].ToString()));
            
            // Sales $ Per Lb
            e.Row.Cells[18].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["ValueOGPerLb"].ToString()));
            e.Row.Cells[19].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["ValueMOPerLb"].ToString()));
            
            // GM Per Lb
            e.Row.Cells[20].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["GMOGPerLb"].ToString()));
            e.Row.Cells[21].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["GMMOPerLb"].ToString()));
           
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

    protected void gvHitRate_Sorting(object sender, GridViewSortEventArgs e)
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

        if (e.Row.RowType == DataControlRowType.Header && dataFormat == "Print")
        {
            // Hit Rate %
            e.Row.Cells[2].ColumnSpan = 5;
            e.Row.Cells[2].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=5 nowrap ><center>Hit Rate % Based on:</center></td></tr><tr>" +
                                        "<td width='45' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('LbsHitRate');\">Lbs</div></center></td>" +
                                        "<td width='46' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('AvlHitRate');\">Avl Qty</div></td>" +
                                        "<td width='50' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('LnCntHitRage');\">Line Cnt</div></td>" +
                                        "<td width='46' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('ValueHitRate');\">Sell$</div></td>" +
                                        "<td width='45' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('GMHitRate');\">GM$</div></td>" +
                                        "</tr></table>";

            e.Row.Cells[3].Visible = false;
            e.Row.Cells[4].Visible = false;
            e.Row.Cells[5].Visible = false;
            e.Row.Cells[6].Visible = false;

            // Sales $
            e.Row.Cells[7].ColumnSpan = 2;
            e.Row.Cells[7].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Sales $</center></td></tr><tr>" +
                                        "<td width='60' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ValueOGQty');\">Quoted</div></center></td>" +
                                        "<td width='55' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('ValueMOQty');\">Ordered</div></td>" +
                                        "</tr></table>";

            e.Row.Cells[8].Visible = false;

            // GM $
            e.Row.Cells[9].ColumnSpan = 2;
            e.Row.Cells[9].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>GM $</center></td></tr><tr>" +
                                        "<td width='50' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('GMOGQty');\">Quoted</div></center></td>" +
                                        "<td width='48' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('GMMOQty');\">Ordered</div></td>" +
                                        "</tr></table>";

            e.Row.Cells[10].Visible = false;

            // GM $
            e.Row.Cells[11].ColumnSpan = 3;
            e.Row.Cells[11].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>GM %</center></td></tr><tr>" +
                                        "<td width='50' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('GMOG');\">Quoted</div></center></td>" +
                                        "<td width='50' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('GMMO');\">Ordered</div></td>" +
                                        "<td width='45' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('GMDiff');\">Diff</div></td>" +
                                        "</tr></table>";

            e.Row.Cells[12].Visible = false;
            e.Row.Cells[13].Visible = false;

            // Pounds
            e.Row.Cells[14].ColumnSpan = 2;
            e.Row.Cells[14].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Pounds</center></td></tr><tr>" +
                                        "<td width='60' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('LbsOGQty');\">Quoted</div></center></td>" +
                                        "<td width='55' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('LbsMOQty');\">Ordered</div></td>" +
                                        "</tr></table>";

            e.Row.Cells[15].Visible = false;

            // Line Count
            e.Row.Cells[16].ColumnSpan = 2;
            e.Row.Cells[16].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Line Count</center></td></tr><tr>" +
                                        "<td width='50' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('MOLineCnt');\">Quoted</div></center></td>" +
                                        "<td width='56' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('TotLineCnt');\">Ordered</div></td>" +
                                        "</tr></table>";

            e.Row.Cells[17].Visible = false;

            // Sales $ Per Lb
            e.Row.Cells[18].ColumnSpan = 2;
            e.Row.Cells[18].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>Sales $ Per Lb</center></td></tr><tr>" +
                                        "<td width='52' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ValueOGPerLb');\">Quoted</div></center></td>" +
                                        "<td width='54' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('ValueMOPerLb');\">Ordered</div></td>" +
                                        "</tr></table>";

            e.Row.Cells[19].Visible = false;

            // GM Per Lb
            e.Row.Cells[20].ColumnSpan = 2;
            e.Row.Cells[20].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>GM Per Lb</center></td></tr><tr>" +
                                        "<td width='52' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('GMOGPerLb');\">Quoted</div></center></td>" +
                                        "<td width='54' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('GMMOPerLb');\">Ordered</div></td>" +
                                        "</tr></table>";

            e.Row.Cells[21].Visible = false;
        }
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            DataSet _dsQuoteData = Session["RPTHitRateData"] as DataSet;
            DataTable dtGrandTotal = _dsQuoteData.Tables[1];
            e.Row.Font.Bold = true;
            e.Row.Cells[0].Visible = false;
            e.Row.Cells[1].ColumnSpan = 2;
            e.Row.Cells[1].Text = "Grand Total";

            // Hit Rate %
            e.Row.Cells[2].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["LbsHitRate"].ToString()));
            e.Row.Cells[3].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["AvlHitRate"].ToString()));
            e.Row.Cells[4].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["LnCntHitRage"].ToString()));
            e.Row.Cells[5].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["ValueHitRate"].ToString()));
            e.Row.Cells[6].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["GMHitRate"].ToString()));

            // Sales $
            e.Row.Cells[7].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["ValueOGQty"].ToString()));
            e.Row.Cells[8].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["ValueMOQty"].ToString()));

            // GM $
            e.Row.Cells[9].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["GMOGQty"].ToString()));
            e.Row.Cells[10].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["GMMOQty"].ToString()));

            // GM %
            e.Row.Cells[11].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["GMOG"].ToString()));
            e.Row.Cells[12].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["GMMO"].ToString()));
            e.Row.Cells[13].Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["GMDiff"].ToString()));


            // Pounds
            e.Row.Cells[14].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["LbsOGQty"].ToString()));
            e.Row.Cells[15].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["LbsMOQty"].ToString()));

            // Line Count
            e.Row.Cells[16].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["MOLineCnt"].ToString()));
            e.Row.Cells[17].Text = String.Format("{0:#,##0}", Convert.ToDecimal(dtGrandTotal.Rows[0]["TotLineCnt"].ToString()));

            // Sales $ Per Lb
            e.Row.Cells[18].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["ValueOGPerLb"].ToString()));
            e.Row.Cells[19].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["ValueMOPerLb"].ToString()));

            // GM Per Lb
            e.Row.Cells[20].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["GMOGPerLb"].ToString()));
            e.Row.Cells[21].Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(dtGrandTotal.Rows[0]["GMMOPerLb"].ToString()));
           
        }
    }

    private string GenerateExportData(string _dataFormat)
    {
        dataFormat = _dataFormat;
        border = (dataFormat == "Print" ? "0" : "1");
        DataSet _dsQuoteData = Session["RPTHitRateData"] as DataSet;
        dtExcelData = new DataTable();

        string styleSheet = "<style>.text { mso-number-format:\\@; } </style>";
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;

        dtExcelData = _dsQuoteData.Tables[0];

        headerContent = "<table border='" + border + "' width='100%'>";
        headerContent += "<tr><th colspan='22' style='color:blue' align=left><center>Hit Rate Report - Category/Region Level</center></th></tr>";
        headerContent += "<tr>  <td colspan='2'><b>Region :" + RegionName + "</b></td>" + 
                                "<td  colspan='2'><b>Days:" + NoOfDays + " Days</b></td>" + 
                                "<td  colspan='2'><b>CSR:" + SalesRepName + "</b></td>" +
                                "<td colspan='5'><b>Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;  Run Date: " + DateTime.Now.ToShortDateString() + "</b></td>" +
                                "<td colspan='11'></td></tr>";                                
        headerContent += "<tr><th colspan='22' style='color:blue' align=left></th></tr>";

        if (dtExcelData.Rows.Count > 0)
        {
            if (dataFormat == "Print")
                dv.Width = 1400;

            dv.AutoGenerateColumns = false;
            dv.ShowHeader = true;
            dv.ShowFooter = true;
            dv.RowDataBound += new GridViewRowEventHandler(dv_RowDataBound);

            BoundField bfExcel = new BoundField();
            bfExcel.HeaderText = "Category";
            bfExcel.DataField = "Category";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Region";
            bfExcel.DataField = "LocSalesGrp";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Lbs Hit Rate %";
            bfExcel.DataField = "LbsHitRate";
            bfExcel.DataFormatString = "{0:#,##0.0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Avl Qty Hit Rate %";
            bfExcel.DataField = "AvlHitRate";
            bfExcel.DataFormatString = "{0:#,##0.0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Line Cnt Hit Rate %";
            bfExcel.DataField = "LnCntHitRage";
            bfExcel.DataFormatString = "{0:#,##0.0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Sell$ Hit Rate %";
            bfExcel.DataField = "ValueHitRate";
            bfExcel.DataFormatString = "{0:#,##0.0}";
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "GM$ Hit Rate %";
            bfExcel.DataField = "GMHitRate";
            bfExcel.DataFormatString = "{0:#,##0.0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Sales $ Quoted";
            bfExcel.DataField = "ValueOGQty";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Sales $ Ordered";
            bfExcel.DataField = "ValueMOQty";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "GM$ Quoted";
            bfExcel.DataField = "GMOGQty";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "GM$ Ordered";
            bfExcel.DataField = "GMMOQty";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "GM % Quoted";
            bfExcel.DataField = "GMOG";
            bfExcel.DataFormatString = "{0:#,##0.0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "GM % Ordered";
            bfExcel.DataField = "GMMO";
            bfExcel.DataFormatString = "{0:#,##0.0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "GM % Diff";
            bfExcel.DataField = "GMDiff";
            bfExcel.DataFormatString = "{0:#,##0.0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Pounds Quoted";
            bfExcel.DataField = "LbsOGQty";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Pounds Ordered";
            bfExcel.DataField = "LbsMOQty";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Line Quoted";
            bfExcel.DataField = "MOLineCnt";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Lines Ordered";
            bfExcel.DataField = "TotLineCnt";
            bfExcel.DataFormatString = "{0:#,##0}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Sales $ Per Lb Quoted";
            bfExcel.DataField = "ValueOGPerLb";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Sales $ Per Lb Ordered";
            bfExcel.DataField = "ValueMOPerLb";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "GM Per Lb Quoted";
            bfExcel.DataField = "GMOGPerLb";
            bfExcel.DataFormatString = "{0:#,##0.00}";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "GM Per Lb Ordered";
            bfExcel.DataField = "GMMOPerLb";
            bfExcel.DataFormatString = "{0:#,##0.00}";
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
            excelContent = "<tr  ><th width='100%' align ='center' colspan='21' > No records found</th></tr> </table>";
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
    
    #region Database IO

    public DataSet GetHitRateReportData(string regionCd, string days, string salesRep)
    {

        try
        {
            DataSet dsHitRateData = SqlHelper.ExecuteDataset(connectionString , "[pDashboardHitRateRpt]",
                                                        new SqlParameter("@regionCd", regionCd),
                                                        new SqlParameter("@Days", days),
                                                        new SqlParameter("@salesRep", salesRep),
                                                        new SqlParameter("@reportType", "CategoryReport"),
                                                        new SqlParameter("@category", ""));
            return dsHitRateData;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    #endregion

  
}

