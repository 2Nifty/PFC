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

public partial class IBExceptionReportPage : System.Web.UI.Page
{
    # region Variable Declaration
    
    QuoteMetrics quoteMetrics = new QuoteMetrics();
    DataTable dtExcelData = new DataTable();
    DataSet dsQuoteData = new DataSet();
    GridView dv = new GridView();

    string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
    int     pageCount = 25;
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
        Ajax.Utility.RegisterTypeForAjax(typeof(IBExceptionReportPage));
        Response.Cache.SetCacheability(HttpCacheability.NoCache);

        if(!IsPostBack)
        {
            Session["IBExceptionData"] = null;
            hidFileName.Value = "IBExceptionReport" + Session["SessionID"].ToString() + ".xls";

            BindDataGrid();
        }
    }

    private void BindDataGrid()
    {
        if (Session["IBExceptionData"] == null)
        {
            DataSet _dsQuoteData = GetExceptionReportData(RegionCd, NoOfDays, SalesRepCd);
            Session["IBExceptionData"] = _dsQuoteData;
            hidSort.Value = "";
        }

        dsQuoteData = Session["IBExceptionData"] as DataSet;
        if (dsQuoteData != null)
        {
            DataTable dtQuoteData = dsQuoteData.Tables[0];
            if (hidSort.Value != "")
                dsQuoteData.Tables[0].DefaultView.Sort = hidSort.Value;
            
            if (dtQuoteData != null && dtQuoteData.Rows.Count > 0)
            {
                gvIBExceptions.DataSource = dtQuoteData.DefaultView.ToTable();
                pager.InitPager(gvIBExceptions, pageCount);
            }
            else
            {
                gvIBExceptions.Visible = false;
                lblStatus.Visible = true;
                pager.Visible = false;
            }
        }
        upnlGrid.Update();                

    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        gvIBExceptions.PageIndex = pager.GotoPageNumber;

        BindDataGrid();
    }

    protected void gvIBExceptions_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        
    }


    protected void gvIBExceptions_Sorting(object sender, GridViewSortEventArgs e)
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

    private string GenerateExportData(string _dataFormat)
    {
        dataFormat = _dataFormat;
        border = (dataFormat == "Print" ? "0" : "1");
        DataSet _dsQuoteData = Session["IBExceptionData"] as DataSet;
        dtExcelData = new DataTable();

        string styleSheet = "<style>.text { mso-number-format:\\@; } </style>";
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;

        dtExcelData = _dsQuoteData.Tables[0];

        headerContent = "<table border='" + border + "' width='400px'>";
        headerContent += "<tr><th colspan='3' style='color:blue' align=left><center>Item Branch Exception Report</center></th></tr>";
        headerContent += "<tr><td colspan='3'><b>Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;  Run Date: " + DateTime.Now.ToShortDateString() + "</b></td></tr>";                                
        headerContent += "<tr><th colspan='3' style='color:blue' align=left></th></tr>";

        if (dtExcelData.Rows.Count > 0)
        {
            if (dataFormat == "Print")
                dv.Width = 250;

            dv.AutoGenerateColumns = false;
            dv.ShowHeader = true;
            dv.ShowFooter = true;            

            BoundField bfExcel = new BoundField();
            bfExcel.HeaderText = "Item #";
            bfExcel.DataField = "ItemNo";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Missing Location";
            bfExcel.DataField = "Location";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Center;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "QOH";
            bfExcel.DataField = "QOH";            
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
            excelContent = "<tr  ><th width='100%' align ='center' colspan='3' > No records found</th></tr> </table>";
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
    
    #region Database IO

    public DataSet GetExceptionReportData(string regionCd, string days, string salesRep)
    {

        try
        {
            DataSet dsHitRateData = SqlHelper.ExecuteDataset(connectionString, "[pIMGetMissingIBRecords]");
            return dsHitRateData;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    #endregion

  
}

