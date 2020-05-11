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

public partial class CustPricingMatrixReport : System.Web.UI.Page
{
    # region Variable Declaration

    CustPriceMatrix custPriceMatrix = new CustPriceMatrix();
    DataTable dtExcelData = new DataTable();
    DataSet dsCustPriceData = new DataSet();
    GridView dv = new GridView();

    int pageCount = 21;
    string border = "0";// Border is a dynamic variable because we need to print grid headers without border
    string territoryCd = "";
    string territoryDesc = "";
    string outSideRep = "";
    string outSideRepDesc = "";
    string inSideRep = "";
    string inSideRepDesc = "";
    string regionCd = "";
    string regionDesc = "";
    string buyGrpCd = "";
    string buyGrpDesc = "";
    string sortExpression = string.Empty;    
    string excelFilePath = "../Common/ExcelUploads/";
    
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(CustPricingMatrixReport));
        Response.Cache.SetCacheability(HttpCacheability.NoCache);

        territoryCd = Request.QueryString["territoryCd"].ToString();
        territoryDesc = Request.QueryString["territoryDesc"].ToString();
        outSideRep = Request.QueryString["outSideRep"].ToString();
        outSideRepDesc = Request.QueryString["outSideRepDesc"].ToString();
        inSideRep = Request.QueryString["inSideRep"].ToString();
        inSideRepDesc = Request.QueryString["inSideRepDesc"].ToString();
        regionCd = Request.QueryString["regionCd"].ToString();
        regionDesc = Request.QueryString["regionDesc"].ToString();
        buyGrpCd = Request.QueryString["buyGrpCd"].ToString();
        buyGrpDesc = Request.QueryString["buyGrpDesc"].ToString();

        if (!IsPostBack)
        {
            Session["CustPriceRptData"] = null;
            hidFileName.Value = "CustPricingMatrixReport" + Session["SessionID"].ToString() + ".xls";

            lblTerritory.Text = territoryDesc;
            lblOutsideRep.Text = outSideRepDesc;
            lblInsideRep.Text = inSideRepDesc;
            lblRegion.Text = regionDesc;
            lblBuyGrp.Text = buyGrpDesc;

            BindDataGrid();
        }
    }

    private void BindDataGrid()
    {
        if (Session["CustPriceRptData"] == null)
        {

            DataSet _dsCustPriceData = custPriceMatrix.GetPriceMatrixReportData(territoryCd, outSideRep, inSideRep, regionCd, buyGrpCd);
            Session["CustPriceRptData"] = _dsCustPriceData;            
        }

        dsCustPriceData = Session["CustPriceRptData"] as DataSet;
        if (dsCustPriceData != null)
        {

            DataTable dtCustPriceData = dsCustPriceData.Tables[0];
            if (dtCustPriceData != null && dtCustPriceData.Rows.Count > 0)
            {
                // Set Width
                gvQuoteMetrics.Width = (dtCustPriceData.Columns.Count < 300 ?  dtCustPriceData.Columns.Count : 100 )* 55;

                if (hidSort.Value != "")
                {
                    dtCustPriceData.DefaultView.Sort = hidSort.Value;
                }

                gvQuoteMetrics.DataSource = dtCustPriceData.DefaultView.ToTable();
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

    protected void gvQuoteMetrics_RowCreated(object sender, GridViewRowEventArgs e)
    {
        e.Row.Cells[0].CssClass = "locked";
        e.Row.Cells[1].CssClass = "locked";
        e.Row.Cells[0].Width = 70;
        e.Row.Cells[1].Width = 180;
        e.Row.Cells[0].HorizontalAlign = HorizontalAlign.Left;
        e.Row.Cells[1].HorizontalAlign = HorizontalAlign.Left;

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

    private string GenerateExportData(string dataFormat)
    {
        border = (dataFormat == "Print" ? "0" : "1");
        DataSet _dsCustPriceData = Session["CustPriceRptData"] as DataSet;
        dtExcelData = new DataTable();

        string styleSheet = "<style>.text { mso-number-format:\\@; } </style>";
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;

        dtExcelData = _dsCustPriceData.Tables[0];

        headerContent =     "<table border='" + border + "' width='100%'>";
        headerContent += "<tr><th colspan='" + dtExcelData.Columns.Count + "' style='color:blue' align=left><center>Customer Price Matrix Report</center></th></tr>";
        headerContent += "<tr><td colspan='3'><b>Territory :" + territoryDesc + "</b></td>" +
                             "<td  colspan='4'><b>Outside Rep:" + outSideRepDesc + "</b></td>"+
                             "<td colspan='" + Convert.ToString(dtExcelData.Columns.Count - 7) + "'></td></tr>";
        headerContent += "<tr><td  colspan='3'> <b>InSide Rep:" + inSideRepDesc + "</b></td>" +
                            "<td  colspan='4'><b>Region: " + regionDesc + "</b></td>" +
                            "<td  colspan='4'><b>buy Group: " + buyGrpDesc + "</b></td>" +
                            "<td colspan='5'><b>Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;  Run Date: " + DateTime.Now.ToShortDateString() + "</></td></tr>";
        headerContent += "<tr><th colspan='" + dtExcelData.Columns.Count + "' style='color:blue' align=left></th></tr>";

        if (dtExcelData.Rows.Count > 0)
        {
            dv.AutoGenerateColumns = false;
            dv.ShowHeader = true;
            dv.ShowFooter = false;            
            
            for (int i = 0; i <= dtExcelData.Columns.Count - 1; i++)
            {
                BoundField bfExcel = new BoundField();
                bfExcel.HeaderText = dtExcelData.Columns[i].ColumnName;
                bfExcel.DataField = dtExcelData.Columns[i].ColumnName; 
                if (i == 0 || i == 1)
                {
                    if(i==0)
                        bfExcel.HeaderText = "Category";
                    else if( i == 1)
                        bfExcel.HeaderText = "Category Desc";

                    bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
                }
                else
                {
                    bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
                }
                dv.Columns.Add(bfExcel);
            }

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
    
   
    protected void gvQuoteMetrics_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        e.Row.Cells[0].CssClass = "locked";
        e.Row.Cells[1].CssClass = "locked";

        if (e.Row.RowType == DataControlRowType.Header)
        {
            for (int i = 2; i < dsCustPriceData.Tables[0].Columns.Count; i++)
            {
                e.Row.Cells[i].Text = "<table border='0' style='font-weight:bold;' cellpadding='0' cellspacing='0'  width='100%'><tr><td>" +
                                            "<Div style=\"cursor:hand;\" onclick=\"javascript:ShowCatPriceSchedule('" + e.Row.Cells[i].Text.Split('-')[1].ToString().Trim() + "');\">" + e.Row.Cells[i].Text + "</div></td></tr></table>";
            }

        }
    }
}

