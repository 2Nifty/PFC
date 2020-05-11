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
using PFC.Intranet;

public partial class GERBOLSearch : System.Web.UI.Page
{
    #region Variable Declaration
    string csReports = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    
    //CustPriceMatrix custPriceMatrix = new CustPriceMatrix();
    DataTable dtExcelData = new DataTable();
    DataSet dsCustPriceData = new DataSet();
    GridView dv = new GridView();

    int pageCount = 22;
    string border = "0";        // Border is a dynamic variable because we need to print grid headers without border
    string pfcItemNo = "";
    string containerNo = "";
    string poNo = "";
    string locId = "";
    string locDesc = "";
    string startDt = "";
    string endDt = "";
    string sortExpression = string.Empty;    
    string excelFilePath = "../Common/ExcelUploads/";
    string excelContent;
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(GERBOLSearch));
        Response.Cache.SetCacheability(HttpCacheability.NoCache);

        pfcItemNo = Request.QueryString["PFCItemNo"].ToString();
        containerNo = Request.QueryString["ContainerNo"].ToString();
        poNo = Request.QueryString["PONo"].ToString();
        locDesc = Request.QueryString["LocDesc"].ToString();
        locId = Request.QueryString["LocID"].ToString();
        startDt = Request.QueryString["StartDt"].ToString();
        endDt = Request.QueryString["EndDt"].ToString();

        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");
        hidFileName.Value = "GERBOLExport" + Session["SessionID"].ToString() + name + ".xls";

        if (!IsPostBack)
        {
            lblItemNo.Text = (pfcItemNo != "" ? pfcItemNo : "ALL");
            lblContainerNo.Text = (containerNo != "" ? containerNo : "ALL");
            lblPONo.Text = (poNo != "" ? poNo : "ALL");
            lblLocation.Text = (locDesc != "" ? locDesc : "ALL");
            lblStartDt.Text = (startDt != "" ? startDt : "ALL");
            lblEndDt.Text = (endDt != "" ? endDt : "ALL");
            BindDataGrid();
        }
    }

    #region DataGrid (GridView)
    private void BindDataGrid()
    {
        DataTable _dtBOLHistory = GetBOLHistory();        
        if (_dtBOLHistory != null && _dtBOLHistory.Rows.Count > 0)
        {
            if (hidSort.Value != "")
            {
                _dtBOLHistory.DefaultView.Sort = hidSort.Value;
            }

            Session["GERBOLRptData"] = _dtBOLHistory.DefaultView.ToTable();
            gvBOLHist.DataSource = _dtBOLHistory.DefaultView.ToTable();
            pager.InitPager(gvBOLHist, pageCount);
        }
        else
        {
            gvBOLHist.Visible = false;
            lblStatus.Visible = true;
            pager.Visible = false;
        }

        upnlGrid.Update();
    }

    private DataTable GetBOLHistory()
    {
        DataSet dsResult = SqlHelper.ExecuteDataset(csReports, "[pGERBOLHistoryList]",
                                                    new SqlParameter("@ItemNo", pfcItemNo),
                                                    new SqlParameter("@PONumber", poNo),
                                                    new SqlParameter("@ContainerNo", containerNo),
                                                    new SqlParameter("@Location", locId),
                                                    new SqlParameter("@StartDt", startDt),
                                                    new SqlParameter("@EndDt", endDt));
        if (dsResult == null)
            return null;
        else
            return dsResult.Tables[0];
    }

    protected void gvBOLHist_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            HyperLink hplButton = e.Row.FindControl("hplBOLNo") as HyperLink;
            hplButton.ForeColor = System.Drawing.Color.Blue;
            hplButton.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'Quote', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");
        }
    }
    protected void gvBOLHist_Sorting(object sender, GridViewSortEventArgs e)
    {
        if (hidSort.Attributes["sortType"] != null)
        {
            if (hidSort.Attributes["sortType"].ToString() == "ASC")
                hidSort.Attributes["sortType"] = "DESC";
            else
                hidSort.Attributes["sortType"] = "ASC";
        }
        else
            hidSort.Attributes.Add("sortType", "DESC");

        hidSort.Value = e.SortExpression + " " + hidSort.Attributes["sortType"].ToString();
        BindDataGrid();
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        gvBOLHist.PageIndex = pager.GotoPageNumber;
        BindDataGrid();
    }
    #endregion

    #region Export
    protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
    {
        excelContent = GenerateExportData("Print");

        string pattern = @"\s*\r?\n\s*";
        excelContent = Regex.Replace(excelContent, pattern, "");
        excelContent = Regex.Replace(excelContent, "<tr><th", "<THEAD style='display:table-header-group;'><TR><th").Replace("</th></tr>", "</th></TR></THEAD>");
        excelContent = excelContent.Replace("BORDER-COLLAPSE: collapse;", "border-collapse:separate;").Replace("BORDER-LEFT: #c9c6c6 1px solid;", "BORDER-LEFT: #c9c6c6 0px solid;").Replace("BORDER-RIGHT: #c9c6c6 1px solid;", "BORDER-RIGHT: #c9c6c6 0px solid;");
        excelContent = excelContent.Replace("BORDER-TOP: #c9c6c6 1px solid;", "BORDER-TOP: #c9c6c6 0px solid;").Replace("BORDER-BOTTOM: #c9c6c6 1px solid;", "BORDER-BOTTOM: #c9c6c6 0px solid;");

        Session["PrintContent"] = excelContent;
        ScriptManager.RegisterClientScriptBlock(ibtnPrint, ibtnPrint.GetType(), "Print", "PrintReport();", true);
    }

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + hidFileName.Value.ToString()));
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();

        excelContent = GenerateExportData("Excel");

        reportWriter.WriteLine(excelContent);
        reportWriter.Close();

        #region Download & Open
        FileStream fileStream = File.Open(Server.MapPath("..//Common//ExcelUploads//" + hidFileName.Value.ToString()), FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath("..//Common//ExcelUploads//" + hidFileName.Value.ToString())));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
        #endregion
    }

    private string GenerateExportData(string dataFormat)
    {
        border = (dataFormat == "Print" ? "0" : "1");
        dtExcelData = Session["GERBOLRptData"] as DataTable;
        //dtExcelData = new DataTable();

        string styleSheet = "<style>.text { mso-number-format:\\@; } </style>";
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;

        //dtExcelData = _dsCustPriceData.Tables[0];

        headerContent = "<table border='" + border + "' width='100%'>";
        headerContent += "<tr><th colspan='8' style='color:blue' align=left><center>GER BOL Search</center></th></tr>";

        headerContent += "<tr><td colspan='8'><center><b>Item # " + lblItemNo.Text +
                "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Container # " + lblContainerNo.Text +
                "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;PO # " + lblPONo.Text +
                "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Loc: " + lblLocation.Text + "</b></center></td></tr>";

        headerContent += "<tr><td colspan='8'><center><b>Start Dt: " + lblStartDt.Text +
                "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;End Dt: " + lblEndDt.Text +
                "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Run By: " + Session["UserName"].ToString() +
                "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Run Dt: " + DateTime.Today.ToShortDateString() + "</b></center></td></tr>";

        headerContent += "<tr><th colspan='8' style='color:blue' align=left></th></tr>";

        if (dtExcelData.Rows.Count > 0)
        {
            dv.AutoGenerateColumns = false;
            dv.ShowHeader = true;
            dv.ShowFooter = false;

            BoundField bfExcel = new BoundField();
            bfExcel.HeaderText = "BOL #";
            bfExcel.DataField = "BOLNo";            
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Container #";
            bfExcel.DataField = "ContainerNo";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Vendor #";
            bfExcel.DataField = "VendInvNo";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);
            dv.DataSource = dtExcelData;

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Entry Dt";
            bfExcel.DataField = "EntryDt";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);
            dv.DataSource = dtExcelData;

            bfExcel = new BoundField();
            bfExcel.HeaderText = "PFC Item #";
            bfExcel.DataField = "PFCItemNo";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Description";
            bfExcel.DataField = "PFCItemDesc";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "PO #";
            bfExcel.DataField = "PFCPONo";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);
            dv.DataSource = dtExcelData;

            bfExcel = new BoundField();
            bfExcel.HeaderText = "PFC Location";
            bfExcel.DataField = "PFCLocNo";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
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

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\Common\\ExcelUploads"));

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

