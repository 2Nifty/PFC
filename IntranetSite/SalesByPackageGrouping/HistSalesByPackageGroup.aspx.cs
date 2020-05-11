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
#endregion

namespace PFC.Intranet.SalesByPackageGroupDashboard
{
    public partial class SalesByPackageGroup : System.Web.UI.Page
    {
        #region Page Local variables
        SalesbyPackingGroupBL salesbyPackingGroupBL = new SalesbyPackingGroupBL();

        private string sortExpression = string.Empty;

        private int pagesize = 18;
        private DataTable dtMain, dtTotal;
        DataTable dtInvoiceAnalysis = new DataTable();

        string _locSalesGrp = "";
        string _branchID = "";
        string _orderSource = "";
        string _orderSourceDesc = "";      
        string _pkgType = "";  

        #endregion

        #region Page load event handler
        protected void Page_Load(object sender, EventArgs e)
        {
            //SystemCheck systemCheck = new SystemCheck();
            //systemCheck.SessionCheck();

            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(SalesByPackageGroup));
            lblMessage.Text = "";

            _orderSource = Request.QueryString["OrderSource"].ToString();
            if (_orderSource == "")
                _orderSource = "ALL";
            lblOrderSource.Text = "Order Source: " + _orderSource;

            _branchID = Request.QueryString["Branch"].ToString();
            if (_branchID == "")
                _branchID = "ALL";

            _locSalesGrp = Request.QueryString["LocSalesGrp"].ToString();   

            _orderSource = Request.QueryString["OrderSource"].ToString();   //ok
            if (_orderSource == "")
                _orderSource = "ALL";  
           
            _orderSourceDesc = Request.QueryString["OrderSourceDesc"].ToString();   //ok
            
            _pkgType = Request.QueryString["PkgType"].ToString();
            if (_pkgType == "")
                _pkgType = "ALL";  


            if (!IsPostBack)
            {
                hidFileName.Value = "PackageGroupingReport" + Session["SessionID"].ToString() + ".xls"; //sathis added needed file name

                lblBranch.Text = "Branch: " + _branchID;  

                lblSalesGrp.Text = "Sales Region: " + (Request.QueryString["LocSalesGrp"].ToString()); 

                lblOrderSource.Text = "Order Source: " + _orderSource;  

                lblPkgType.Text = "Pkg Type: " + _pkgType;
       
                _locSalesGrp = Request.QueryString["LocSalesGrp"].ToString();
         
                BindDataGrid(); 
            }

            BindPrintDialog();
             //BindDataGrid(); 

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
            dtInvoiceAnalysis = salesbyPackingGroupBL.HistGetLostLeadersDatabyBuyGrppp(_branchID, _orderSource, _locSalesGrp, _pkgType); 

            if (dtInvoiceAnalysis != null && dtInvoiceAnalysis.Rows.Count > 0)
            {
                dvInvoiceAnalysis.AllowSorting = true;
                BindNoTot();

                dvInvoiceAnalysis.Visible = true;
                dvPager.InitPager(dvInvoiceAnalysis, pagesize);
                divPager.Style.Add("display", "");
                lblStatus.Visible = false;
            }
            else
            {
                dvInvoiceAnalysis.Visible = false;
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


        public void BindNoTot()
        {
            sortExpression = ((hidSort.Value != "") ? hidSort.Value : "StartWkCurDt ASC");
            dtInvoiceAnalysis.DefaultView.Sort = sortExpression;

            dvInvoiceAnalysis.DataSource = dtInvoiceAnalysis.DefaultView.ToTable();
            dtTotal = dtInvoiceAnalysis.DefaultView.ToTable();
        }

        public void BindPrintDialog()
        {
            string _branchID = "";

            _branchID = Request.QueryString["Branch"].ToString();
            if (_branchID == "")
                _branchID = "ALL";

            _pkgType = Request.QueryString["PkgType"].ToString();
            if (_pkgType == "")
                _pkgType = "ALL"; 


            pdInvoice.PageTitle = "Historical Sales By Package Group";
            string invoiceURL = "SalesByPackageGrouping/SalesByPackageGroup.aspx?Sort=" + hidSort.Value +
                            "&Branch=" + _branchID + 
                            "&OrderSource=" + Request.QueryString["OrderSource"].ToString() +
                            "&OrderSourceDesc=" + Request.QueryString["OrderSource"].ToString() +
                            "&LocSalesGrp=" + Request.QueryString["LocSalesGrp"].ToString() +
                             "&PkgType=" + " ";   
            pdInvoice.PageUrl = invoiceURL;
        }
        #endregion

        #region  Event handler
        protected void Pager_PageChanged(Object sender, System.EventArgs e)
        {
            dvInvoiceAnalysis.PageIndex = dvPager.GotoPageNumber;
            BindDataGrid();
        }

        protected void dvInvoiceAnalysis_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            try
            {

                if (e.Row.RowType == DataControlRowType.DataRow && e.Row.Cells[0].Text.Trim() == "Sub-Total")
                    e.Row.Style.Add(HtmlTextWriterStyle.FontWeight, "bold");

                if (e.Row.RowType == DataControlRowType.DataRow)
                {
                    HyperLink hplButton = e.Row.FindControl("hplInvByItem") as HyperLink;
                    hplButton.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'byItem', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (900/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");
                }

            }
            catch (Exception ex)
            {
                
                string s;
                s = ex.Message;  
            }

            try
            {

                if (e.Row.RowType == DataControlRowType.Footer && dtTotal.Rows.Count > 0)
                {
                    e.Row.Cells[0].Text = "Total";
                    e.Row.Cells[1].Text = String.Format("{0:c0}", dtTotal.Compute("sum(Per1Dol)", ""));
                    e.Row.Cells[2].Text = String.Format("{0:c0}", dtTotal.Compute("sum(Per1GM)", ""));
                    e.Row.Cells[4].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(Per1Lbs)", ""));

                    decimal _llgmPct = 0.0M;
                    if (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(Per1Dol)", "")), 0) != 0)
                        _llgmPct = Convert.ToDecimal(dtTotal.Compute("sum(Per1GM)", "")) / Convert.ToDecimal(dtTotal.Compute("sum(Per1Dol)", ""));
                    e.Row.Cells[3].Text = Math.Round(_llgmPct * 100, 1).ToString();
                   
                    decimal _contllgmPct = 0.0M;
                    if (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(Per1Lbs)", "")), 0) != 0)
                        _contllgmPct = Convert.ToDecimal(dtTotal.Compute("sum(Per1Dol)", "")) / Convert.ToDecimal(dtTotal.Compute("sum(Per1Lbs)", ""));
                    e.Row.Cells[5].Text = Math.Round(_contllgmPct * 1, 2).ToString();


                    decimal _contllgmPctt = 0.0M;
                    if (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(Per1Lbs)", "")), 0) != 0)
                        _contllgmPctt = Convert.ToDecimal(dtTotal.Compute("sum(Per1GM)", "")) / Convert.ToDecimal(dtTotal.Compute("sum(Per1Lbs)", ""));
                    e.Row.Cells[6].Text = Math.Round(_contllgmPctt * 1, 2).ToString();                                   
           
                }
            }
            catch (Exception ex)
            {
                string s;
                s = ex.Message;                
            }
        }

        protected void btnSort_Click(object source, EventArgs e)
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

            if (cldEndDt.SelectedDate.CompareTo(cldStartDt.SelectedDate) == 1 || cldEndDt.SelectedDate.CompareTo(cldStartDt.SelectedDate) == 0)
            {
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
            BindPrintDialog();
            pnlPrint.Update();
        }

        #endregion

        #region Write to Excel
        protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
        {
            FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
            string headerContent = string.Empty;
            string footerContent = string.Empty;
            string excelContent = string.Empty;
            StreamWriter reportWriter;
            reportWriter = fnExcel.CreateText();

            _locSalesGrp = Request.QueryString["LocSalesGrp"].ToString();
            if (_locSalesGrp == "")
                _locSalesGrp = "ALL";

            _branchID = Request.QueryString["Branch"].ToString();
            if (_branchID == "")
                _branchID = "ALL";

            _orderSource = Request.QueryString["OrderSource"].ToString();
            if (_orderSource == "")
                _orderSource = "ALL";
            _orderSourceDesc = Request.QueryString["OrderSourceDesc"].ToString();

            sortExpression = ((hidSort.Value != "") ? hidSort.Value : "StartWkCurDt asc");

            dtInvoiceAnalysis = salesbyPackingGroupBL.HistGetLostLeadersDatabyBuyGrppp(_branchID, _orderSource, _locSalesGrp, _pkgType); 

            if (dtInvoiceAnalysis != null && dtInvoiceAnalysis.Rows.Count > 0)
            {
                dtInvoiceAnalysis.DefaultView.Sort = sortExpression;
                dtMain = dtInvoiceAnalysis.DefaultView.ToTable();
                dtTotal = dtInvoiceAnalysis.DefaultView.ToTable();

                headerContent = "<table border='1'>";

                headerContent += "<tr><th colspan='7' style='color:blue' align=left><center>Historical Sales By Package Grouping</center></th></tr>" +
                                 "<td colspan='2'><b>Beginning Date: " + "Historical" + "</b></td>" +
                                 "<td colspan='2'><b>Ending Date: " + "Historical" + "</b></td>" +
                                 "<td colspan='2'><b>Sales Region: " + Request.QueryString["LocSalesGrp"].ToString() + "</b></td>" +
                                 "<td colspan='1'><b>Branch: " + _branchID + "</b></td>" +

                                 "</tr><tr>" +
                                 "<td colspan='2'><b>Run By: " + Session["UserName"].ToString() + "</b></td>" +
                                 "<td colspan='3'><b>" + lblOrderSource.Text + "</b></td>" +
                                 "<td colspan='2'><b>Run Date: " + DateTime.Now.ToShortDateString() + "</b></td>" +
                                 "<tr><th colspan='7' style='color:blue' align=left></th></tr>";

                headerContent += "<tr>" +
                                 "<th width='80'  nowrap align='center'>StartWkCurDt</td>" +
                                 "<th width='100'  nowrap align='center'>Sales $</th>" +
                                 "<th width='80'  nowrap align='center'>GM $</th>" +
                                 "<th width='100' nowrap align='center'>GM %</th>" +
                                 "<th width='100' nowrap align='center'>Lbs </th>" +
                                 "<th width='100' nowrap align='center'>$ Per Lb</th>" +
                                 "<th width='100' nowrap align='center'>GM$ Per Lb</th>" +
                                 "</tr>";

                if (dtMain.Rows.Count > 0)
                {
                    foreach (DataRow drSalesAnalysis in dtMain.Rows)
                    {

                        excelContent += "<tr>" +
                                        "<td nowrap align='Left'>" +
                                        string.Format("{0:MM/dd/yyyy}",drSalesAnalysis["StartWkCurDt"]) + "</td><td nowrap>" +
                                        string.Format("{0:c0}", drSalesAnalysis["Per1Dol"]) + "</td><td nowrap>" +
                                        string.Format("{0:c0}", drSalesAnalysis["Per1GM"]) + "</td><td nowrap>" +
                                        string.Format("{0:#,##0.0}", drSalesAnalysis["Per1GMpct"]) + "</td><td nowrap>" +
                                        string.Format("{0:0,0}", drSalesAnalysis["Per1Lbs"]) + "</td><td nowrap>" +
                                        string.Format("{0:c}", drSalesAnalysis["DolPerLb"]) + "</td><td nowrap>" +
                                        string.Format("{0:c}", drSalesAnalysis["GMPerLb"]) + "</td>" +
                                        "</tr>";
                    }

                    decimal _llgmPct = 0.0M;
                    if (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(Per1Dol)", "")), 0) != 0)
                        _llgmPct = Convert.ToDecimal(dtTotal.Compute("sum(Per1GM)", "")) / Convert.ToDecimal(dtTotal.Compute("sum(Per1Dol)", ""));

                    decimal _dolPerLb = 0.0M;
                    if (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(Per1Dol)", "")), 0) != 0)
                        _dolPerLb = Convert.ToDecimal(dtTotal.Compute("sum(Per1Dol)", "")) / Convert.ToDecimal(dtTotal.Compute("sum(Per1Lbs)", ""));

                    decimal _gmPerLb = 0.0M;
                    if (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(Per1Dol)", "")), 0) != 0)
                        _gmPerLb = Convert.ToDecimal(dtTotal.Compute("sum(Per1GM)", "")) / Convert.ToDecimal(dtTotal.Compute("sum(Per1Lbs)", ""));

                    footerContent = "<tr style='font-weight:bold'>" +
                                    "<td align='center'>Total</td>" +

                                    "<td>" +
                                    String.Format("{0:c0}", dtTotal.Compute("sum(Per1Dol)", "")) +
                                    "</td>" +

                                    "<td>" +
                                    String.Format("{0:c0}", dtTotal.Compute("sum(Per1GM)", "")) +
                                    "</td>" +

                                    "<td>" +
                                    Math.Round(_llgmPct * 100, 1).ToString() +
                                    "</td>" +

                                    "<td>" +
                                    String.Format("{0:0,0}", dtTotal.Compute("sum(Per1Lbs)", "")) +
                                    "</td>" +

                                    "<td>" +
                                    Math.Round(_dolPerLb, 2).ToString() +
                                    "</td>" +

                                    "<td>" +
                                    Math.Round(_gmPerLb, 2).ToString() +
                                    "</td>" +

                                    //"<td>" + caused extra column

                                    "</tr>" +
                                    "</table>";
                }
            }

            reportWriter.WriteLine(headerContent + excelContent + footerContent);
            reportWriter.Close();

            //
            // Downloding Process
            //
            FileStream fileStream = File.Open(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()), FileMode.Open);
            Byte[] bytBytes = new Byte[fileStream.Length];
            fileStream.Read(bytBytes, 0, (int)fileStream.Length);
            fileStream.Close();

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
                DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\SalesByPackageGrouping\\Common\\ExcelUploads"));

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

    }// End Class
}//End Namespace