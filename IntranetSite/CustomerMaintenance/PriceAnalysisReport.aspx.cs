#region Header
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
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;
using System.Data.SqlClient;
using System.Text.RegularExpressions;
#endregion

namespace PFC.Intranet.DailySalesReports
{
    public partial class PriceAnalysisReport : System.Web.UI.Page
    {
        #region Page Local variables
        SalesReportUtils salesReportUtils = new SalesReportUtils();
        InvoiceAnalysis invoiceAnalysis = new InvoiceAnalysis();
        MaintenanceUtility MaintUtil = new MaintenanceUtility();

        private string sortExpression = string.Empty;
        private int pagesize = 20;
        
        DataSet dsPriceAnalysis = new DataSet();
        string _startDate = "";
        string _endDate = "";
        string _customerNumber = "";
        string _categoryNo = "";

        GridView dv = new GridView();
        DataTable dtExcelData = new DataTable();
        string excelFilePath = "../Common/ExcelUploads/";
        string border = "0";
        #endregion

        #region Page load event handler
        protected void Page_Load(object sender, EventArgs e)
        {
            SystemCheck systemCheck = new SystemCheck();
            systemCheck.SessionCheck();

            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(PriceAnalysisReport));
            lblMessage.Text = "";
            _customerNumber = Request.QueryString["CustNo"].ToString();
            _categoryNo = Request.QueryString["Category"];
            if (!IsPostBack)
            {
                string _todaysDate = DateTime.Now.ToShortDateString();
                string _beginDtofSixMo = DateTime.Now.AddMonths(-6).ToShortDateString();
                
                cldStartDt.SelectedDate = Convert.ToDateTime(_beginDtofSixMo);
                cldEndDt.SelectedDate = Convert.ToDateTime(_todaysDate);
                cldStartDt.VisibleDate = Convert.ToDateTime(_beginDtofSixMo);
                cldEndDt.VisibleDate = Convert.ToDateTime(_todaysDate);

                hidShowAvgCost.Value = (MaintUtil.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.PriceAnalysisShowAvgCost) != "" ? "TRUE" : "FALSE");
                hidFileName.Value = "PriceAnalysisReport" + Session["SessionID"].ToString() + ".xls";
                lblBeginDate.Text = "Beginning Date: " + _beginDtofSixMo;
                lblEndDate.Text = "Ending Date: " + _todaysDate;
                if (_categoryNo != null)
                    lblCategory.Text = "Category: " + _categoryNo;
                
                Session["PriceAnalysisData"] = null;
                BindDataGrid();
            }

            if (hidShowMode.Value == "Show")
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Show", "ShowPanel();", true);
            else
                if (hidShowMode.Value == "ShowL")
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShowL", "ShowHide('Show');", true);
                else
                    if (hidShowMode.Value == "HideL")
                        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "HideL", "ShowHide('Hide');", true);
        } 
        #endregion

        #region Developer Methods

        public void BindDataGrid()
        {
            _startDate = cldStartDt.SelectedDate.ToShortDateString();
            _endDate = cldEndDt.SelectedDate.ToShortDateString();

            if (Session["PriceAnalysisData"] == null) 
            {
                dsPriceAnalysis = GetPriceAnalysisData(_startDate, _endDate, _customerNumber, _categoryNo);
                Session["PriceAnalysisData"] = dsPriceAnalysis; // to increase the performance in paging control
            }

            dsPriceAnalysis = Session["PriceAnalysisData"] as DataSet;
            if (dsPriceAnalysis != null && dsPriceAnalysis.Tables[0].Rows.Count >0)
            {
                if (hidSort.Value != "")
                    dsPriceAnalysis.Tables[1].DefaultView.Sort = hidSort.Value;

                if (hidShowAvgCost.Value != "TRUE")
                {
                    lblSuggGMPct.Visible = false;
                    dvInvoiceAnalysis.Columns[4].Visible = false;
                }

                dvInvoiceAnalysis.DataSource = dsPriceAnalysis.Tables[1].DefaultView.ToTable();

                dvPager.InitPager(dvInvoiceAnalysis, pagesize);
                divPager.Style.Add("display", "");
                lblStatus.Visible = false;

                SetReportHeader();
            }
            else
            {
                divPager.Style.Add("display","none");
                lblStatus.Visible = true;
                lblStatus.Text = "No Records Found";
                if (!(cldEndDt.SelectedDate.CompareTo(cldStartDt.SelectedDate) == 1 || cldEndDt.SelectedDate.CompareTo(cldStartDt.SelectedDate) == 0))
                    lblStatus.Text = "Invalid Date Range";
            }

            pnlBranch.Update();
            pnlProgress.Update();
            upnlGrid.Update();
            if (hidShowMode.Value == "Show")
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Show", "ShowPanel();", true);
            else
                if (hidShowMode.Value == "ShowL")
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShowL", "ShowHide('Show');", true);
                else
                    if (hidShowMode.Value == "HideL")
                        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "HideL", "ShowHide('Hide');", true);
        }

        private void SetReportHeader()
        {
            DataTable dtHeader = dsPriceAnalysis.Tables[0];
            lblCustomerNumber.Text = "Customer: " + dtHeader.Rows[0]["CustNo"].ToString() + " - " + dtHeader.Rows[0]["CustName"].ToString();
            lblBranch.Text = "Branch: " + dtHeader.Rows[0]["Brn"].ToString();
            lblHistExtSell.Text = "Hist Ext. Sell: " + String.Format("{0:#,##}",dtHeader.Rows[0]["HistExtSell"]);
            lblHistExtGM.Text = "Hist Ext. GM: " + String.Format("{0:#,##}", dtHeader.Rows[0]["HistExtGM"]);
            lblHistGMPct.Text = "Hist GM Pct: " + String.Format("{0:0.0%}", dtHeader.Rows[0]["HistGMPct"]);
            lblSuggGMPct.Text = "Sugg GM Pct: " + String.Format("{0:0.0%}", dtHeader.Rows[0]["SuggGMPct"]);
            lblSAvgSuggGMPct.Text = "SAvg Sugg GM Pct: " + String.Format("{0:0.0%}", dtHeader.Rows[0]["SuggSmthAvgGMPct"]);

            lblHistExtLbs.Text = "Hist Ext. Lbs: " + String.Format("{0:#,##}", dtHeader.Rows[0]["HistExtLbs"]);
            lblHistSellPerLb.Text = "Hist Sell Per Lb: " + String.Format("{0:#,##0.000}", dtHeader.Rows[0]["HistSellPerLb"]);
            lblHistGMPerLb.Text = "Hist GM Per Lb " + String.Format("{0:#,##0.000}", dtHeader.Rows[0]["HistGMPerLb"]);
            
        }

        #endregion

        #region  Event handler

        protected void Pager_PageChanged(Object sender, System.EventArgs e)
        {
            dvInvoiceAnalysis.PageIndex = dvPager.GotoPageNumber;
            BindDataGrid();
        }

        protected void dvInvoiceAnalysis_Sorting(object sender, GridViewSortEventArgs e)
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

        protected void ibtnRunReport_Click(object sender, ImageClickEventArgs e)
        {
            dvPager.Visible = true;
            lblBeginDate.Text = "Beginning Date: " + cldStartDt.SelectedDate.ToShortDateString();
            lblEndDate.Text = "Ending Date: " + cldEndDt.SelectedDate.ToShortDateString(); 

            if (cldEndDt.SelectedDate.CompareTo(cldStartDt.SelectedDate) == 1 || cldEndDt.SelectedDate.CompareTo(cldStartDt.SelectedDate) == 0)
            {
                Session["PriceAnalysisData"] = null;
                BindDataGrid();
            }
            else
            {
                lblMessage.Text = "Invalid Date Range";
                BindDataGrid();
                pnlProgress.Update();
                if (hidShowMode.Value == "Show")
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Show", "document.getElementById('leftPanel').style.display='';document.getElementById('imgHide').style.display='';document.getElementById('imgShow').style.display='none';document.getElementById('div-datagrid').style.width='830px';document.getElementById('hidShowMode').value='Show';", true);
            }
            pnlBranch.Update();
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

        #endregion

        #region Write to Excel

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

        private string GenerateExportData(string dataFormat)
        {
            border = (dataFormat == "Print" ? "0" : "1");
            DataSet _dsPriceData = Session["PriceAnalysisData"] as DataSet;
            dtExcelData = new DataTable();

            string styleSheet = "<style>.text { mso-number-format:\\@; } </style>";
            string headerContent = string.Empty;
            string footerContent = string.Empty;
            string excelContent = string.Empty;

            dtExcelData = _dsPriceData.Tables[1];

            headerContent = "<table border='" + border + "' width='100%'>";
            headerContent += "<tr><th colspan='14' style='color:blue' align=left><center>Price Analysis Report</center></th></tr>";
            headerContent +=    "<tr>" + 
                                "<td colspan='3'><b>"+ lblBeginDate.Text + "</b></td>" + 
                                "<td colspan='3'><b>" + lblEndDate.Text + "</b></td>" +
                                "<td colspan='3'><b>" + lblBranch.Text + "</b></td>" +
                                "<td colspan='3'><b>" + lblCustomerNumber.Text + "</b></td>" +
                                "<td colspan='2'></td>" +
                                "</tr>";
            headerContent += "<tr>" +
                               "<td colspan='3'><b>" + lblHistExtSell.Text + "</b></td>" +
                               "<td colspan='3'><b>" + lblHistExtGM.Text + "</b></td>" +
                               "<td colspan='3'><b>" + lblHistGMPct.Text + "</b></td>" +
                               "<td colspan='3'><b>" + lblSAvgSuggGMPct.Text + "</b></td>" +
                               "<td colspan='2'><b>" + (hidShowAvgCost.Value == "TRUE" ? lblSuggGMPct.Text : "") + "</b></td>" +
                               "</tr>";

            headerContent += "<tr>" +
                              "<td colspan='3'><b>" + lblHistExtLbs.Text + "</b></td>" +
                              "<td colspan='3'><b>" + lblHistSellPerLb.Text + "</b></td>" +
                              "<td colspan='3'><b>" + lblHistGMPerLb.Text + "</b></td>" +
                              "<td colspan='3'><b>Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;  Run Date: " + DateTime.Now.ToShortDateString() + "</b></td>" +
                              "<td colspan='2'></td>" +
                              "</tr>";

             headerContent += "<tr><th colspan='14' style='color:blue' align=left></th></tr>";

            if (dtExcelData.Rows.Count > 0)
            {
                dv.AutoGenerateColumns = false;
                dv.ShowHeader = true;
                dv.ShowFooter = true;                

                BoundField bfExcel = new BoundField();
                bfExcel.HeaderText = "Item No";
                bfExcel.DataField = "ItemNo";
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;                
                dv.Columns.Add(bfExcel);

                bfExcel = new BoundField();
                bfExcel.HeaderText = "Sugg Price Alt";
                bfExcel.DataField = "SuggestedPriceAlt";
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;                
                dv.Columns.Add(bfExcel);

                bfExcel = new BoundField();
                bfExcel.HeaderText = "Hist Sell Price Alt";
                bfExcel.DataField = "SellUM";
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
                dv.Columns.Add(bfExcel);

                bfExcel = new BoundField();
                bfExcel.HeaderText = "Sugg Price Method";
                bfExcel.DataField = "SuggestedPriceMethod";
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Left;
                dv.Columns.Add(bfExcel);

                if (hidShowAvgCost.Value == "TRUE")
                {
                    bfExcel = new BoundField();
                    bfExcel.HeaderText = "Avg Sugg GM Pct";
                    bfExcel.DataField = "AVGSuggGMPct";
                    bfExcel.DataFormatString = "{0:0.0%}";
                    bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
                    dv.Columns.Add(bfExcel);
                }
                
                bfExcel = new BoundField();
                bfExcel.HeaderText = "SAvg Sugg GM Pct";
                bfExcel.DataField = "SMTHAVGSuggGMPct";
                bfExcel.DataFormatString = "{0:0.0%}";
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
                dv.Columns.Add(bfExcel);
            

                bfExcel = new BoundField();
                bfExcel.HeaderText = "GM Pct";
                bfExcel.DataField = "GMPct";
                bfExcel.DataFormatString = "{0:0.0%}";
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
                dv.Columns.Add(bfExcel);

                bfExcel = new BoundField();
                bfExcel.HeaderText = "Qty Shipped";
                bfExcel.DataField = "QtyShipped";
                bfExcel.DataFormatString = "{0:#,##}";
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
                dv.Columns.Add(bfExcel);

                bfExcel = new BoundField();
                bfExcel.HeaderText = "Ext. Lines";
                bfExcel.DataField = "ExtLines";
                bfExcel.DataFormatString = "{0:#,##}";
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
                dv.Columns.Add(bfExcel);

                bfExcel = new BoundField();
                bfExcel.HeaderText = "Ext. Sell";
                bfExcel.DataField = "ExtSell";
                bfExcel.DataFormatString = "{0:#,##0.00}";
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;                
                dv.Columns.Add(bfExcel);

                bfExcel = new BoundField();
                bfExcel.HeaderText = "Ext. GM";
                bfExcel.DataField = "ExtGM";
                bfExcel.DataFormatString = "{0:#,##0.00}";
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;                
                dv.Columns.Add(bfExcel);

                

                bfExcel = new BoundField();
                bfExcel.HeaderText = "Ext. Lbs";
                bfExcel.DataField = "ExtLbs";
                bfExcel.DataFormatString = "{0:#,##0.00}";
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
                dv.Columns.Add(bfExcel);

                bfExcel = new BoundField();
                bfExcel.HeaderText = "Sell Per Lb";
                bfExcel.DataField = "SellPerLb";
                bfExcel.DataFormatString = "{0:#,##0.000}";
                bfExcel.ItemStyle.HorizontalAlign = HorizontalAlign.Right;
                dv.Columns.Add(bfExcel);

                bfExcel = new BoundField();
                bfExcel.HeaderText = "GM Per Lb";
                bfExcel.DataField = "GMPerLb";
                bfExcel.DataFormatString = "{0:#,##0.000}";
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
                excelContent = "<tr  ><th width='100%' align ='center' colspan='21' > No records found</th></tr> </table>";
            }

            return styleSheet + headerContent + excelContent;
        }

        #endregion

        #region Delete Excel using sessionid
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

        #region DB Helper

        public DataSet GetPriceAnalysisData(string startDate, string endDate, string custNo,string categoryNo)
        {
            try
            {
                DataSet dsResult = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pPriceAnalysisRpt",
                                            new SqlParameter("@CustNo", custNo),
                                            new SqlParameter("@BegDate", startDate),
                                            new SqlParameter("@EndDate", endDate),
                                            new SqlParameter("@Version", "Short"),
                                            new SqlParameter("@Category", categoryNo));
                return dsResult;
            }
            catch (Exception ex)
            {
                return null;
            }
        }

        #endregion

    }// End Class
}//End Namespace