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

public partial class CycleCountReport : System.Web.UI.Page
{
    # region Variable Declaration
    
    QuoteMetrics quoteMetrics = new QuoteMetrics();
    DataTable dtExcelData = new DataTable();
    DataSet dsCycleQuoteData = new DataSet();
    GridView dv = new GridView();

    int pageCount = 18;
    string border = "0";// Border is a dynamic variable because we need to print grid headers without border
    string StartDate = "";
    string EndDate = "";
    string BranchID = "";
    string MinAdjValue = "";    
    string RFUserId = "";
    string BranchDesc = "";
    string sortExpression = string.Empty;    
    string excelFilePath = "../Common/ExcelUploads/";
    
    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(CycleCountReport));
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        StartDate = Request.QueryString["StartDate"].ToString();
        EndDate = Request.QueryString["EndDate"].ToString();
        BranchID = Request.QueryString["Branch"].ToString();
        RFUserId = (Request.QueryString["RFUserId"].ToString() == "" ? "ALL" : Request.QueryString["RFUserId"].ToString());
        MinAdjValue = (Request.QueryString["MinAdjValue"].ToString() == "" ? "" : Request.QueryString["MinAdjValue"].ToString());        
        BranchDesc = (Request.QueryString["BranchName"].ToString() == "" ? "ALL" : Request.QueryString["BranchName"].ToString());
 
        if (!IsPostBack)
        {
            Session["RPTCycleCountData"] = null;
            hidFileName.Value = "CycleCountReport" + Session["SessionID"].ToString() + ".xls";

            lblStartDt.Text = StartDate;
            lblEndDt.Text = EndDate;
            lblBranch.Text = BranchDesc;
            lblRFUserId.Text = RFUserId;
            lblMinAdjValue.Text = MinAdjValue;

            BindDataGrid();
        }
    }

    private void BindDataGrid()
    {
        if (Session["RPTCycleCountData"] == null)
        {
            DataSet _dsCycleCountData = GetCycleCountData();

            Session["RPTCycleCountData"] = _dsCycleCountData;
            hidSort.Value = "";
        }

        dsCycleQuoteData = Session["RPTCycleCountData"] as DataSet;
        if (dsCycleQuoteData != null)
        {
            DataTable dtQuoteData = dsCycleQuoteData.Tables[0];
            if (hidSort.Value != "")
                dtQuoteData.DefaultView.Sort = hidSort.Value;

            if (dtQuoteData != null && dtQuoteData.Rows.Count > 0)
            {
                gvCycleCount.DataSource = dtQuoteData.DefaultView.ToTable();
                pager.InitPager(gvCycleCount, pageCount);
            }
            else
            {
                gvCycleCount.Visible = false;
                lblStatus.Visible = true;
                pager.Visible = false;
            }
        }
        upnlGrid.Update();
        pnlBranch.Update();        

    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        gvCycleCount.PageIndex = pager.GotoPageNumber;

        BindDataGrid();
    }

    protected void gvCycleCount_RowDataBound(object sender, GridViewRowEventArgs e)
    {               
        if(e.Row.RowType == DataControlRowType.Footer)
        {
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Font.Bold = true;
                e.Row.Cells[0].Visible = false;
                e.Row.Cells[1].ColumnSpan = 2;
                e.Row.Cells[1].Text = "Grand Total";

                DataSet _dsCycleCountData = Session["RPTCycleCountData"] as DataSet;
                e.Row.Cells[6].Text = String.Format("{0:#,##0}", Convert.ToDecimal(_dsCycleCountData.Tables[0].Compute("sum(adjQty)", "").ToString()));
                e.Row.Cells[7].Text = String.Format("{0:#,##0}", Convert.ToDecimal(_dsCycleCountData.Tables[0].Compute("sum(ExtValue)", "").ToString()));
            }
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

    protected void gvCycleCount_Sorting(object sender, GridViewSortEventArgs e)
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
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            e.Row.Font.Bold = true;
            e.Row.Cells[0].Visible = false;
            e.Row.Cells[1].ColumnSpan = 2;
            e.Row.Cells[1].Text = "Grand Total";

            DataSet _dsCycleCountData = Session["RPTCycleCountData"] as DataSet;            
            e.Row.Cells[6].Text = String.Format("{0:#,##0}", Convert.ToDecimal(_dsCycleCountData.Tables[0].Compute("sum(adjQty)", "").ToString()));
            e.Row.Cells[7].Text = String.Format("{0:#,##0}", Convert.ToDecimal(_dsCycleCountData.Tables[0].Compute("sum(ExtValue)", "").ToString()));            
        }
    }

    private string GenerateExportData(string dataFormat)
    {
        border = (dataFormat == "Print" ? "0" : "1");
        DataSet _dsCycleCountData = Session["RPTCycleCountData"] as DataSet;
        dtExcelData = new DataTable();

        string styleSheet = "<style>.text { mso-number-format:\\@; } </style>";
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;

        dtExcelData = _dsCycleCountData.Tables[0];

        headerContent =     "<table border='" + border + "' width='100%'>";
        headerContent +=    "<tr><th colspan='9' style='color:blue' align=left><center>Cycle Count Report</center></th></tr>";
        headerContent += "<tr><td colspan='3'><b>Beginning Date :" + StartDate + "</b></td>" + 
                            "<td  colspan='3'><b>Ending Date:" + EndDate + "</b></td>" +
                            "<td colspan='3'><b>Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;  Run Date: " + DateTime.Now.ToShortDateString() + "</></td>" + 
                            "</tr>";
        headerContent +=    "<tr><td  colspan='3'> <b>Branch:" + BranchDesc + "</b></td>" +                           
                            "<td  colspan='3'><b>RF User Id: " + RFUserId + "</b></td>" +
                            "<td  colspan='3'><b>Min Adjustment: " + MinAdjValue + "</b></td>" +
                            "</tr>";
        headerContent += "<tr><th colspan='9' style='color:blue' align=left></th></tr>";

        if (dtExcelData.Rows.Count > 0)
        {
            dv.AutoGenerateColumns = false;
            dv.ShowHeader = true;
            dv.ShowFooter = true;
            dv.RowDataBound += new GridViewRowEventHandler(dv_RowDataBound);

            BoundField bfExcel = new BoundField();
            bfExcel.HeaderText = "RF User ID";
            bfExcel.DataField = "UserID";            
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Type";
            bfExcel.DataField = "Type";            
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;            
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Created Date";
            bfExcel.DataField = "DATE_Time";            
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;            
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "PFC Item No.";
            bfExcel.DataField = "Extended";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Item Desc";
            bfExcel.DataField = "ItemDesc";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Bin Label";
            bfExcel.DataField = "Binlabel";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Adj. Qty";
            bfExcel.DataField = "adjQty";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Ext. Value";
            bfExcel.DataField = "ExtValue";
            bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
            bfExcel.FooterStyle.HorizontalAlign = HorizontalAlign.Right;
            dv.Columns.Add(bfExcel);

            bfExcel = new BoundField();
            bfExcel.HeaderText = "Reason";
            bfExcel.DataField = "Reason";
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
    
    public DataSet GetCycleCountData()
    {

        try
        {
            DateTime _StDate = Convert.ToDateTime(StartDate);
            DateTime _EndDate = Convert.ToDateTime(EndDate);
            string DBStartDtFormat =    _StDate.Year.ToString() + 
                                        (_StDate.Month.ToString().Length == 1 ? "0" + _StDate.Month.ToString() : _StDate.Month.ToString())  +
                                        (_StDate.Day.ToString().Length == 1 ? "0" + _StDate.Day.ToString() : _StDate.Day.ToString()) + 
                                        " 00:00:00.00";
            string DBEndDtFormat =      _EndDate.Year.ToString() +
                                        (_EndDate.Month.ToString().Length == 1 ? "0" + _EndDate.Month.ToString() : _EndDate.Month.ToString()) +
                                        (_EndDate.Day.ToString().Length == 1 ? "0" + _EndDate.Day.ToString() : _EndDate.Day.ToString()) +
                                         " 23:59:00.00";
            string DBRFuserId = (RFUserId == "ALL" ? "" : RFUserId);
            //"20090807 12:52:45.91"

            // Code to execute the stored procedure
            DataSet dsData = new DataSet();
            SqlConnection conn = new SqlConnection(ConfigurationManager.AppSettings["PFCRBConnectionString"].ToString());
            SqlDataAdapter adp;
            SqlCommand Cmd = new SqlCommand();
            Cmd.CommandTimeout = 0;
            Cmd.CommandType = CommandType.StoredProcedure;
            Cmd.Connection = conn;
            conn.Open();
            Cmd.CommandText = "[pWhsCycleCntRpt]";
            Cmd.Parameters.Add(new SqlParameter("@BeginDate", DBStartDtFormat));
            Cmd.Parameters.Add(new SqlParameter("@EndDate", DBEndDtFormat));
            Cmd.Parameters.Add(new SqlParameter("@Branch", BranchID));
            Cmd.Parameters.Add(new SqlParameter("@MinValue", (MinAdjValue == "" ? "0" : MinAdjValue)));
            Cmd.Parameters.Add(new SqlParameter("@RFUserId", DBRFuserId));
            adp = new SqlDataAdapter(Cmd);
            adp.Fill(dsData);                        
            
            return dsData;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

        
}

