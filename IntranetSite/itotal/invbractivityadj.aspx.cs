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
 
#endregion

namespace PFC.Intranet.ITotalReports
{
    public partial class InvBrActivityIssues : System.Web.UI.Page
    {
       
        ITotal iTotal = new ITotal();
        // ITotalRef.iTotalTemp iTotalTemp = new ITotalRef.iTotalTemp(); 
        private string sortExpression = string.Empty;
        private string branchID = string.Empty;
        private string branchDesc = string.Empty;
        private string reportType = "Adj";
        private int pagesize = 16;
        DataTable dtTotal = new DataTable();
        string sort = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(InvBrActivityIssues));
            branchID = (Request.QueryString["Branch"].ToString().Length == 1 ? "0" + Request.QueryString["Branch"].ToString() : Request.QueryString["Branch"].ToString());
            branchDesc = Request.QueryString["BranchDesc"].ToString().Replace("'","");
            lblMessage.Text = "";

            if (!IsPostBack)
            {
                cldStartDt.SelectedDate = Convert.ToDateTime(Request.QueryString["Period"].ToString());
                cldStartDt.VisibleDate = Convert.ToDateTime(Request.QueryString["Period"].ToString());
                lblBranch.Text = branchDesc + "&nbsp;:&nbsp;Adjustments";
                BindDataGrid();               
            }

            hidFileName.Value = "InvBrActivityAdjustments_" + Session["SessionID"].ToString() + ".xls";

            if (hidShowMode.Value == "Show")
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoW", "ShowPanel();", true);
            else if (hidShowMode.Value == "ShowL")
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoWL", "ShowHide('Show');", true);
            else if (hidShowMode.Value == "HideL")
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoWL", "ShowHide('Hide');", true);
        }   
       
        public void BindDataGrid()
        {
            try
            {
                if (sort == "")
                {
                    lblPeriod.Text = "Period : " + cldStartDt.SelectedDate.ToShortDateString();

                    //DataSet ds = new DataSet();
                    //ds = iTotalTemp.GetInventoryBrActivityDetail(branchID, cldStartDt.SelectedDate.ToShortDateString(), reportType);
                    //dtTotal = ds.Tables[0];
                    hidPeriod.Value = cldStartDt.SelectedDate.ToShortDateString();
                    dtTotal = iTotal.GetInventoryBrActivityDetail(branchID, cldStartDt.SelectedDate.ToShortDateString(), reportType);
                }
                else
                {
                    dtTotal = iTotal.GetInventoryBrActivityDetail(branchID, hidPeriod.Value, reportType);
                }
                if (dtTotal !=null && dtTotal.Rows.Count > 0)
                {
                    sortExpression = ((hidSort.Value != "") ? hidSort.Value : "TypeofTransaction asc");
                    dtTotal.DefaultView.Sort = sortExpression;
                    dvBIOnhand.DataSource = dtTotal.DefaultView.ToTable();
                    Pager.InitPager(dvBIOnhand, pagesize);
                    dvBIOnhand.Visible = true;
                    lblStatus.Visible = false;
                    Pager.Visible = true;
                }
                else
                {
                    dvBIOnhand.Visible = false;
                    lblStatus.Visible = true;
                    Pager.Visible = false;
                    lblStatus.Text = "No Records Found";
                }
                upnlGrid.Update();
                if (hidShowMode.Value == "Show")
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoW", "ShowPanel();", true);
                else if (hidShowMode.Value == "ShowL")
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoWL", "ShowHide('Show');", true);
                else if (hidShowMode.Value == "HideL")
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ShoWL", "ShowHide('Hide');", true);
            }
            catch (Exception ex)
            {

                throw;
            }
        }        

        protected void dvBIOnhand_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.Header)
            {
                e.Row.Cells[2].ColumnSpan = 3;
                e.Row.Cells[2].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>Average Cost System</center></td></tr><tr><td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ACWeight');\"><center>Weight</center></div></center></td><td width='61' class='GridHead splitBorders' nowrap align='center' nowrap style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ACValue');\">Value</div></center></td><td width='60' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('AcAdjperLb');\">Per Lb</div></td></tr></table>";
                e.Row.Cells[3].Visible = false;
                e.Row.Cells[4].Visible = false;

                e.Row.Cells[5].ColumnSpan = 3;
                e.Row.Cells[5].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>ERP</center></td></tr><tr><td width='69' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ERPWeight');\"><center>Weight</center></div></center></td><td width='61' class='GridHead splitBorders' nowrap align='center' nowrap style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ERPValue');\">Value</div></center></td><td width='60' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('ERPAdjperLb');\">Per Lb</div></td></tr></table>";
                e.Row.Cells[6].Visible = false;
                e.Row.Cells[7].Visible = false;
            }


            if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells[0].Text = "Grand Total";
                e.Row.Cells[1].Text = dtTotal.Rows.Count.ToString();

                decimal _ACValue =  Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ACValue)", "")),2);
                decimal _ACWeight = Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ACWeight)", "")), 2);
                decimal _ERPValue = Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ERPValue)", "")), 2);
                decimal _ERPWeight = Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ERPWeight)", "")), 2);
               
                e.Row.Cells[2].Text = String.Format("{0:#,##0.00}", _ACWeight);
                e.Row.Cells[3].Text = String.Format("{0:#,##0.00}", _ACValue);
                e.Row.Cells[4].Text = (_ACWeight.ToString() != "0.00" ? Math.Round((_ACValue / _ACWeight),3).ToString() : "0.000");

                e.Row.Cells[5].Text = String.Format("{0:#,##0.00}", _ERPWeight);
                e.Row.Cells[6].Text = String.Format("{0:#,##0.00}", _ERPValue);                
                e.Row.Cells[7].Text = (_ERPWeight.ToString() != "0.00" ? Math.Round((_ERPValue / _ERPWeight), 3).ToString() : "0.000");
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
            sort = "sort";
            BindDataGrid();
        }

        protected void dvBIOnhand_Sorting(object sender, GridViewSortEventArgs e)
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
            sort = "sort";
            BindDataGrid();
        }

        protected void Pager_PageChanged(Object sender, System.EventArgs e)
        {
            dvBIOnhand.PageIndex = Pager.GotoPageNumber;
            sort = "sort";
            BindDataGrid();
        }

        protected void cldStartDt_SelectionChanged(object sender, EventArgs e)
        {
          //  BindDataGrid();
        }

        protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
        {
            string strURL = "Sort=" + hidSort.Value + "&Period=" + hidPeriod.Value + "&Branch=" + branchID + "&BranchDesc=" + branchDesc ; 
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "PrintReport('" + strURL + "');", true);

           // BindDataGrid();
        }

        #region Write to Excel

        protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
        {

            FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
            string headerContent = string.Empty;
            string footerContent = string.Empty;
            string excelContent = string.Empty;
            StreamWriter reportWriter;
            reportWriter = fnExcel.CreateText();

            sortExpression = ((hidSort.Value != "") ? hidSort.Value : "TypeofTransaction asc");

            //DataSet ds = new DataSet();
            //ds = iTotalTemp.GetInventoryBrActivityDetail(branchID, cldStartDt.SelectedDate.ToShortDateString(), reportType);
            //dtTotal = ds.Tables[0];

            dtTotal = iTotal.GetInventoryBrActivityDetail(branchID, hidPeriod.Value, reportType);
            dtTotal.DefaultView.Sort = sortExpression;
            dtTotal = dtTotal.DefaultView.ToTable();

            headerContent = "<table border='1' width='900'>";
            headerContent += "<tr><th colspan='8' style='color:blue'>Inventory Branch Activity</th></tr>";
            headerContent += "<tr><th colspan='2' align='left'>" + branchDesc + "&nbsp;:&nbsp;Adjustments</th><th colspan=0 align='left'>Period :" + hidPeriod.Value + "</th><th colspan='1'></th><th colspan='2'>Run By : " + Session["UserName"].ToString() + "</th><th colspan='2' align='left'>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr><tr colspan='10'></tr>";


            if (dtTotal.Rows.Count > 0)
            {
                headerContent += "<tr><th style='width:150px;'>TransType</th>" +
                                    "<th  style='width:200px'>DocNo</th>" +
                                    "<th style='width:80px;' colspan=3><table border='1' cellpadding='0' cellspacing='0'  width='100%' style='font-weight:bold'><tr>" +
                                    "<td colspan=3 nowrap><center>Average Cost System</center></td></tr><tr>" +
                                    "<td><center>Weight</center></td>" +
                                    "<td width='70' align='center' nowrap >Value </td>" +
                                    "<td width='70' align='center' nowrap >Per Lb </td></tr></table></th> " +
                                    "<th style='width:80px;' colspan=3><table border='1' cellpadding='0' cellspacing='0'  width='100%' style='font-weight:bold'><tr>" +
                                    "<td colspan=3 nowrap><center>ERP</center></td></tr><tr>" +
                                    "<td><center>Weight</center></td>" +
                                    "<td width='70' align='center' nowrap >Value </td>" +
                                    "<td width='70' align='center' nowrap >Per Lb </td></tr></table></th></tr> ";

                foreach (DataRow roiReader in dtTotal.Rows)
                {
                    excelContent += "<tr><td align='left'>" + roiReader["TypeofTransaction"].ToString() + "</td><td>" +
                            String.Format("{0:#,##0}", roiReader["DocumentNo"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0.00}", roiReader["ACWeight"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0.00}", roiReader["ACValue"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0.000}", roiReader["AcAdjperLb"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0.00}", roiReader["ERPWeight"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0.00}", roiReader["ERPValue"]) + "</td><td>" +
                            String.Format("{0:#,##0.000}", roiReader["ERPAdjperLb"]) + "</td></tr>";

                }
                decimal _ACValue = Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ACValue)", "")), 2);
                decimal _ACWeight = Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ACWeight)", "")), 2);
                decimal _ERPValue = Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ERPValue)", "")), 2);
                decimal _ERPWeight = Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ERPWeight)", "")), 2);

                footerContent = "<tr style='font-weight:bold'><td>Grand Total</td><td align='left'>" +
                                dtTotal.Rows.Count.ToString() + "</td><td nowrap=nowrap>" +
                                String.Format("{0:#,##0.00}", _ACWeight) + "</td><td nowrap=nowrap>" +
                                String.Format("{0:#,##0.00}", _ACValue) + "</td><td>" +
                                (_ACWeight.ToString() != "0.00" ? Math.Round((_ACValue / _ACWeight), 3).ToString() : "0.000") + "</td><td nowrap=nowrap>" +
                                String.Format("{0:#,##0.00}", _ERPWeight) + "</td><td nowrap=nowrap>" +
                                String.Format("{0:#,##0.00}", _ERPValue) + "</td><td>" +
                                (_ERPWeight.ToString() != "0.00" ? Math.Round((_ERPValue / _ERPWeight), 3).ToString() : "0.000") + "</td></tr>" ;
                         
                          

            }
            reportWriter.WriteLine(headerContent + excelContent + footerContent);
            reportWriter.Close();

            //Downloding Process
            FileStream fileStream = File.Open(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()), FileMode.Open);
            Byte[] bytBytes = new Byte[fileStream.Length];
            fileStream.Read(bytBytes, 0, (int)fileStream.Length);
            fileStream.Close();


            //  Download Process
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

                DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\ITotal\\Common\\ExcelUploads"));

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
       
        protected void ibtnRunReport_Click(object sender, ImageClickEventArgs e)
        {
            BindDataGrid();
        }
}

}