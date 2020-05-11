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
using System.Data.SqlClient;
#endregion

namespace PFC.Intranet.DailySalesReports
{
    public partial class InvoicePrintPage : System.Web.UI.Page
    {

        #region Page Local variables
        //SalesReportUtils salesReportUtils = new SalesReportUtils();
        InvoiceAnalysis invoiceAnalysis = new InvoiceAnalysis();
        PFC.Intranet.Utility.Utility utility = new PFC.Intranet.Utility.Utility();
        string erpConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        private string sortExpression = string.Empty;
        private int pagesize =22;        
        DataTable dtInvoice = new DataTable();
        string _startDate = "";
        string _endDate = "";
        string _reportType = "";
        string _custNo = "";
        string _custType = "";
        string _doctStNo = "";
        string _doctEndNo = "";
        string _docList = "";

        #endregion

        #region Page load event handler

        protected void Page_Load(object sender, EventArgs e)
        {
            SystemCheck systemCheck = new SystemCheck();
            systemCheck.SessionCheck();

            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(InvoicePrintPage));
            lblMessage.Text = "";

            _startDate = Request.QueryString["StartDt"].ToString();
            _endDate = Request.QueryString["EndDt"].ToString();
            _reportType = Request.QueryString["ReportType"].ToString();
            _custNo = Request.QueryString["AccountNo"].ToString();
            _custType = Request.QueryString["CustType"].ToString();
            _doctStNo = Request.QueryString["DocStNo"].ToString();
            _doctEndNo = Request.QueryString["DocEndNo"].ToString();
            _docList = Request.QueryString["DocList"].ToString();

            if (!IsPostBack)
            {
                Session["PrintInvoiceNo"] = "";
                hidFileName.Value = "InvoiceList" + Session["SessionID"].ToString() + ".xls";
                

                BindDataGrid(); 
            }

            BindPrintDialog();
           
        } 

        #endregion

        #region Developer Methods

        public void BindDataGrid()
        {
            dtInvoice = GetInvoiceList();

            if (dtInvoice != null && dtInvoice.Rows.Count > 0)
            {
                if (hidSort.Value != "")
                    dtInvoice.DefaultView.Sort = hidSort.Value;

                dvInvoiceAnalysis.DataSource = dtInvoice.DefaultView.ToTable();
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
            }
            pnlProgress.Update();
            upnlGrid.Update();           
        }

        public void BindPrintDialog()
        {
            PrintDialogue1.PageTitle = "Daily Sales Orders";
            string invoiceURL = "InvoiceExport.aspx?InvoiceNo=[DocNo]";
            PrintDialogue1.PageUrl = invoiceURL;
            PrintDialogue1.FormName = "Invoice";     
            
        }

        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public void SaveSelectedInvoices(string invoiceNo, bool chkSelectStatus)
        {
            try
            {
                // if the invoiceNo is already in the session remove it first
                if (Session["PrintInvoiceNo"] != null)
                {
                    Session["PrintInvoiceNo"] = Session["PrintInvoiceNo"].ToString().Replace("," + invoiceNo, "");
                }
                if (chkSelectStatus)
                {
                    // Store the value in session to retore value after paging
                    Session["PrintInvoiceNo"] += "," + invoiceNo;
                }
            }
            catch (Exception ex)
            {
                
            }
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
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (Session["PrintInvoiceNo"].ToString().Contains(e.Row.Cells[1].Text))
                {
                    CheckBox chkselect = e.Row.FindControl("chkSelect") as CheckBox;
                    chkselect.Checked = true;
                }
            }
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
        
        protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
        {
            //string strURL = "Sort=" + hidSort.Value +
            //                "&StartDate=" + cldStartDt.SelectedDate.ToShortDateString() +
            //                "&EndDate=" + cldEndDt.SelectedDate.ToShortDateString() +
            //                "&OrderType=" + Request.QueryString["OrderType"].ToString() +
            //                "&Branch=" + Request.QueryString["Branch"].ToString() +
            //                "&CustNo=" + Request.QueryString["CustNo"].ToString() +
            //                "&Chain=" + Request.QueryString["Chain"].ToString() +
            //                "&WeightFrom=" + Request.QueryString["WeightFrom"].ToString() +
            //                "&WeightTo=" + Request.QueryString["WeightTo"].ToString() +
            //                "&ShipToState=" + Request.QueryString["ShipToState"].ToString() +
            //                "&BranchDesc=" + Request.QueryString["BranchDesc"].ToString() +
            //                "&OrderTypeDesc=" + Request.QueryString["OrderTypeDesc"].ToString() +
            //                "&SalesPerson=" + Request.QueryString["SalesPerson"].ToString() +
            //                "&SalesRepNo=" + Request.QueryString["SalesRepNo"].ToString() +
            //                "&PriceCd=" + Request.QueryString["PriceCd"].ToString() +
            //                "&OrderSource=" + Request.QueryString["OrderSource"].ToString() +
            //                "&OrderSourceDesc=" + Request.QueryString["OrderSourceDesc"].ToString() +
            //                "&ShipMethod=" + Request.QueryString["ShipMethod"].ToString() +
            //                "&ShipMethodName=" + Request.QueryString["ShipMethodName"].ToString() +
            //                "&SubTotal=" + Request.QueryString["SubTotal"].ToString() +
            //                "&SubTotalDesc=" + Request.QueryString["SubTotalDesc"].ToString() +
            //                "&SubTotalFlag=" + Request.QueryString["SubTotalFlag"].ToString()+
            //                "&TerritoryCd=" + Request.QueryString["TerritoryCd"].ToString() +
            //                "&TerritoryDesc=" + Request.QueryString["TerritoryDesc"].ToString() +
            //                "&CSRName=" + Request.QueryString["CSRName"].ToString() +
            //                "&CSRNo=" + Request.QueryString["CSRNo"].ToString();

            //ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "PrintReport('" + strURL + "');", true);
        } 

        #endregion

        #region Write to Excel
        protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
        {
            //FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
            //string headerContent = string.Empty;
            //string footerContent = string.Empty;
            //string excelContent = string.Empty;
            //StreamWriter reportWriter;
            //reportWriter = fnExcel.CreateText();

            //_startDate = cldStartDt.SelectedDate.ToShortDateString();
            //_endDate = cldEndDt.SelectedDate.ToShortDateString();
            //sortExpression = ((hidSort.Value != "") ? hidSort.Value : "Branch,CustNo asc");
            //dtInvoiceAnalysis = invoiceAnalysis.GetInvoiceAnalysisByCustNo(_startDate, _endDate, _orderType, _branchID, _chain, _customerNumber, _territory, _CSR, _shipToState, _shipment, _salesRepNo, _priceCd, _orderSource);

            //if (dtInvoiceAnalysis != null && dtInvoiceAnalysis.Rows.Count > 0)
            //{
            //    if (_subTotal == "0")
            //    {   //No Sub-Totals
            //        dtInvoiceAnalysis.DefaultView.Sort = sortExpression;
            //        dtMain = dtInvoiceAnalysis.DefaultView.ToTable();
            //        dtTotal = dtInvoiceAnalysis.DefaultView.ToTable();
            //    }
            //    else
            //    {   //Sub-Totals
            //        BindSubTot();
            //    }

            //    headerContent = "<table border='1'>";

            //    headerContent += "<tr><th colspan='15' style='color:blue' align=left><center>Sales Performance by Filter Report</center></th></tr><tr>" +
            //                     "<td colspan='3'><b>Beginning Date: " + cldStartDt.SelectedDate.ToShortDateString() + "</b></td>" +
            //                     "<td colspan='6'><b>Ending Date: " + cldEndDt.SelectedDate.ToShortDateString() + "</b></td>" +
            //                     "<td colspan='2'><b>" + lblOrderType.Text + "</b></td>" +
            //                     "<td colspan='3'><b>Branch: " + Request.QueryString["BranchDesc"].ToString() + "</b></td>" +
            //                     "<td colspan='1'><b>" + lblChain.Text + "</b></td></tr><tr>" +
            //                     "<td colspan='3'><b>" + lblCustomerNumber.Text + "</b></td>" +
            //                     "<td colspan='2'><b>" + lblTerritory.Text + "</b></td>" +
            //                     "<td colspan='2'><b>" + lblState.Text + "</b></td>" +
            //                     "<td colspan='2'><b>" + lblShipment.Text + "</b></td>" +
            //                     "<td colspan='2'><b>" + lblSalesPerson.Text + "</b></td><tr>" +
            //                     "<td colspan='3'><b>" + lblPriceCd.Text + "</b></td>" +
            //                     "<td colspan='4'><b>" + lblOrderSource.Text + "</b></td>" +
            //                     "<td colspan='2'><b>" + lblCSR.Text + "</b></td>" +
            //                     "<td colspan='2'><b>Run By: " + Session["UserName"].ToString() + "</b></td>" +
            //                     "<td colspan='4'><b>Run Date: " + DateTime.Now.ToShortDateString() + "</b></td></tr>" +
            //                     "<tr><th colspan='15' style='color:blue' align=left></th></tr>";

            //    headerContent += "<tr>" +
            //                     "<th width='70'  nowrap align='center'>Branch</td>" +
            //                     "<th width='60'  nowrap align='center'>No</th>" +
            //                     "<th width='250' nowrap align='center'>Name</th>" +
            //                     "<th width='60'  nowrap align='center'>Chain</th>" +
            //                     "<th width='60'  nowrap align='center'>Price Cd</th>" +
            //                     "<th width='80'  nowrap align='center'>Net Sales</th>" +
            //                     "<th width='80'  nowrap align='center'>GM $</th>" +
            //                     "<th width='80'  nowrap align='center'>GM %</th>" +
            //                     "<th width='80'  nowrap align='center'>Tot Wght</th>" +
            //                     "<th width='80'  nowrap align='center'>eCom GM$</th>" +
            //                     "<th width='80'  nowrap align='center'>eCom GM%</th>" +
            //                     "<th width='80'  nowrap align='center'>State Code</th>" +
            //                     "<th width='80'  nowrap align='center'>Territory Code</th>" +
            //                     "<th width='80'  nowrap align='center'>Inside Rep</th>" +
            //                     "<th width='80'  nowrap align='center'>Outside Rep</th>" +
            //                     "</tr>";

            //    if (dtMain.Rows.Count > 0)
            //    {
            //        foreach (DataRow drSalesAnalysis in dtMain.Rows)
            //        {
            //            //if (drSalesAnalysis["ARDate"].ToString() == "Sub-Total")
            //            //    excelContent += " <tr style='font-weight:bold'>";
            //            //else
            //            //    excelContent += " <tr>";

            //            excelContent += "<tr><td nowrap align='center'>" +
            //                            drSalesAnalysis["Branch"] + "</td><td nowrap>" +
            //                            drSalesAnalysis["CustNo"] + "</td><td nowrap>" +
            //                            drSalesAnalysis["CustName"] + "</td><td nowrap align='center'>" +
            //                            drSalesAnalysis["Chain"] + "</td><td nowrap align='center'>" +
            //                            drSalesAnalysis["PriceCd"] + "</td><td nowrap align='center'>" +
            //                            string.Format("{0:c}", drSalesAnalysis["NetSales"]) + "</td><td nowrap>" +                                        
            //                            string.Format("{0:c}", drSalesAnalysis["GMDollar"]) + "</td><td nowrap>" +
            //                            string.Format("{0:#,##0.0}", drSalesAnalysis["GMPct"]) + "</td><td nowrap>" +
            //                            string.Format("{0:#,##0.0}", drSalesAnalysis["TotWgt"]) + "</td><td nowrap>" +
            //                            string.Format("{0:c}", drSalesAnalysis["ECommGMDollar"]) + "</td><td nowrap>" +
            //                            string.Format("{0:#,##0.0}", drSalesAnalysis["ECommGMPct"]) + "</td><td nowrap>" +
            //                            string.Format("{0:#,##0.0}", drSalesAnalysis["State"]) + "</td><td nowrap>" +
            //                            string.Format("{0:#,##0.0}", drSalesAnalysis["SalesTerritory"]) + "</td><td nowrap>" +
            //                            string.Format("{0:#,##0.0}", drSalesAnalysis["InsideRep"]) + "</td><td nowrap>" +
            //                            string.Format("{0:#,##0.0}", drSalesAnalysis["OutsideRep"]) + "</td>" +                                         
            //                            "</tr>";
            //        }

            //        decimal _gmPct = 0.0M;
            //        if (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(NetSales)", "")), 0) != 0)
            //            _gmPct = Convert.ToDecimal(dtTotal.Compute("sum(GMDollar)", "")) / Convert.ToDecimal(dtTotal.Compute("sum(NetSales)", ""));

            //        decimal _eComGmPct = 0.0M;
            //        if (Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ECommSales)", "")), 0) != 0)
            //            _eComGmPct = Convert.ToDecimal(dtTotal.Compute("sum(ECommGMDollar)", "")) / Convert.ToDecimal(dtTotal.Compute("sum(ECommSales)", ""));


            //        footerContent = "<tr style='font-weight:bold'><td align='center'>Total</td><td colspan='4'></td><td>" +
            //                            String.Format("{0:c}", dtTotal.Compute("sum(NetSales)", "")) + "</td><td>" +
            //                            String.Format("{0:c}", dtTotal.Compute("sum(GMDollar)", "")) + "</td><td>" +
            //                            Math.Round(_gmPct * 100, 1).ToString() + "</td><td>" +
            //                            String.Format("{0:#,##0.0}", dtTotal.Compute("sum(TotWgt)", "")) + "</td><td>" +
            //                            String.Format("{0:c}", dtTotal.Compute("sum(ECommGMDollar)", "")) + "</td><td>" +
            //                            Math.Round(_eComGmPct * 100, 1).ToString() + "</td><td>" +
            //                            "</tr></table>";
            //    }
            //}

            //reportWriter.WriteLine(headerContent + excelContent + footerContent);
            //reportWriter.Close();

            ////
            //// Downloding Process
            ////
            //FileStream fileStream = File.Open(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()), FileMode.Open);
            //Byte[] bytBytes = new Byte[fileStream.Length];
            //fileStream.Read(bytBytes, 0, (int)fileStream.Length);
            //fileStream.Close();

            //Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString())));
            //Response.ContentType = "application/octet-stream";
            //Response.BinaryWrite(bytBytes);
            //Response.End();
        }
        #endregion

        #region Delete Excel using sessionid
        [Ajax.AjaxMethod()]
        public string DeleteExcel(string strSession)
        {
            try
            {

                DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\DailySalesReport\\Common\\ExcelUploads"));

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
        
        #region Data Access Methods

        private DataTable GetInvoiceList()
        {
            try
            {
                DataSet dsResult = SqlHelper.ExecuteDataset(erpConnectionString, "[pGetInvoiceList]",
                                               new SqlParameter("@custType", _custType),
                                               new SqlParameter("@custNo", _custNo),
                                               new SqlParameter("@docNoStart", _doctStNo),
                                               new SqlParameter("@docNoEnd", _doctEndNo),
                                               new SqlParameter("@docNoList", _docList),
                                               new SqlParameter("@startDt", _startDate),
                                               new SqlParameter("@endDt", _endDate)
                                               );

                if (dsResult != null)
                {
                    return dsResult.Tables[0];
                }

                return null;
            }
            catch (Exception ex)
            {
                return null;
            }

        }
        
        #endregion

    }// End Class
}//End Namespace