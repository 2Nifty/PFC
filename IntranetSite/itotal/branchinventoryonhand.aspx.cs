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
    public partial class BranchInventoryOnHand : System.Web.UI.Page
    {
       
        ITotal iTotal = new ITotal();
        private string sortExpression = string.Empty;
        DataTable dtTotal = new DataTable();
        FiscalCalendar ficalCalendar = new FiscalCalendar();
        string sort = "";
        

        protected void Page_Load(object sender, EventArgs e)
        {
            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(BranchInventoryOnHand));
            lblMessage.Text = "";
                      
            if (!IsPostBack)
            {
                cldStartDt.VisibleDate = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                cldStartDt.SelectedDate = Convert.ToDateTime(DateTime.Now.ToShortDateString());                               
                                                     
                //
                // Fill The Branches in the Combo
                //             
                BindDataGrid();                
               
            }
            hidFileName.Value = "BranchInventoryOnHand_" + Session["SessionID"].ToString() + ".xls";

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
                    hidPeriod.Value = cldStartDt.SelectedDate.ToShortDateString();               
                }
                if (ddlPkgType.SelectedValue == "ALL" && hidPeriod.Value == cldStartDt.VisibleDate.ToString())
                {
                    dtTotal = iTotal.GetBranchInventoryOnHand(hidPeriod.Value, ddlPkgType.SelectedValue = "ALL");
                    
                }
                else if (ddlPkgType.SelectedValue == "PKG")
                {
                    dtTotal = iTotal.GetBranchInventoryOnHand(hidPeriod.Value, ddlPkgType.SelectedValue = "PKG");
                    
                }
                else if (ddlPkgType.SelectedValue == "BULK")
                {

                    dtTotal = iTotal.GetBranchInventoryOnHand(hidPeriod.Value, ddlPkgType.SelectedValue = "BULK"); 

                }
                else if (ddlPkgType.SelectedValue == "ALL")
                {
                   
                    dtTotal = iTotal.GetBranchInventoryOnHand(hidPeriod.Value, "ALL");
                }
                
                if (dtTotal !=null && dtTotal.Rows.Count > 0)
                {

                    if (chkShowUsage.Checked)
                    {
                        dvBIOnhand.Columns[8].Visible = true;
                        dvBIOnhand.Columns[9].Visible = true;
                        dvBIOnhand.Columns[10].Visible = true;
                        dvBIOnhand.Columns[11].Visible = true;
                    }
                    else
                    {
                        dvBIOnhand.Columns[8].Visible = false;
                        dvBIOnhand.Columns[9].Visible = false;
                        dvBIOnhand.Columns[10].Visible = false;
                        dvBIOnhand.Columns[11].Visible = false;
                    }

                    sortExpression = ((hidSort.Value != "") ? hidSort.Value : "Branch asc");
                    dtTotal.DefaultView.Sort = sortExpression;
                    Session["BranchInventoryOnHand"] = dtTotal.DefaultView.ToTable();
                    Session["DropDownSelVal"] = ddlPkgType.SelectedValue;
                    dvBIOnhand.DataSource = dtTotal.DefaultView.ToTable();
                    dvBIOnhand.Visible = true;
                    lblStatus.Visible = false;
                    dvBIOnhand.DataBind();
                    
                }
                else
                {
                    Session["BranchInventoryOnHand"] = null;
                    dvBIOnhand.Visible = false;
                    lblStatus.Visible = true;
                    lblStatus.Text = "No Records Found";
                }


                upnlGrid.Update();
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "process", "window.parent.document.getElementById('Progress').style.display='none';", true);
                

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
                e.Row.Cells[8].ColumnSpan = 3;
                e.Row.Cells[8].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>30 Day Usage</center></td></tr><tr><td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ThirtyDayUsageQty');\">Qty</div></center></td><td width='70' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('ThirtyDayUseQtyDolPerAvg');\">$ @Avg</div></td><td width='70' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('ThirtyDayUseWgt');\">Weight</div></td></tr></table>";
                e.Row.Cells[9].Visible = false;
                e.Row.Cells[10].Visible = false;

            }
                       
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                //e.Row.Cells[0].Text = "<div onmouseover=\"title='View Inventory By Category'\" onclick=\"javascript:OpenInvByCatReport('" + cldStartDt.SelectedDate.ToShortDateString() + "');\" style='cursor:hand'>Grand Total</div>";                
                string InvCatBrItem = "BranchActivityDetail.aspx?Branch=ALL&Period=" + hidPeriod.Value + "&BranchDesc=ALL";
                string BrItemDetail = "InventoryByCategory.aspx?Period=" + hidPeriod.Value;
                HyperLink hplButton = new HyperLink();
                if(iTotal.ReportType=="current")
                    hplButton.Text = "<div onmouseover=\"title='Right click for more option'\" style='cursor:hand;' oncontextmenu=\"Javascript:return false;\" id=div" + e.Row.RowIndex + "ITotal onmousedown=\"ShowTotalToolTip(event,'" + InvCatBrItem + "','" + BrItemDetail + "',this.id);\" class='GridtotLink'>Grand Total</div>";
                else
                    hplButton.Text = "<div onmouseover=\"title='Right click is disabled'\" style='cursor:hand;' oncontextmenu=\"Javascript:return false;\" id=div" + e.Row.RowIndex + "ITotal class='GridtotLink'>Grand Total</div>";

                e.Row.Cells[0].Controls.Add(hplButton);
                e.Row.Cells[0].CssClass = "GridtotLink";

                 e.Row.Cells[6].Text = iTotal.BranchDolPerLB;
                 e.Row.Cells[7].Text = iTotal.OTWDolPerLB;
                 e.Row.Cells[2].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(Qty)", ""));
                 e.Row.Cells[3].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(DolAtAvgCost)", ""));
                 e.Row.Cells[4].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(Weight)", ""));
                 e.Row.Cells[5].Text = String.Format("{0:#,##0.000}", dtTotal.Compute("sum(DolAtAvgCost)/sum(Weight)", ""));
            }

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string url = string.Empty;
                string BrItemDetail = "BranchItemDetail.aspx?Branch=" + e.Row.Cells[1].Text + "&Period=" + hidPeriod.Value + "&BranchDesc=" + e.Row.Cells[0].Text;
                if (e.Row.Cells[1].Text.Trim() == "9995")
                {
                    e.Row.Cells[0].Text = e.Row.Cells[0].Text.Trim().Replace("9995","99");
                    e.Row.Cells[1].Text = "99";
                }

                string InvCatBrItem = "BranchActivityDetail.aspx?Branch=" + e.Row.Cells[1].Text + "&Period=" + hidPeriod.Value + "&BranchDesc=" + e.Row.Cells[0].Text;
                

                HyperLink hplButton = new HyperLink();
                if (iTotal.ReportType == "current")
                    hplButton.Text = "<div onmouseover=\"title='Right click for more option'\" style='cursor:hand;' oncontextmenu=\"Javascript:return false;\" id=div" + e.Row.RowIndex + "ITotal onmousedown=\"ShowToolTip(event,'" + InvCatBrItem + "','" + BrItemDetail + "',this.id);\">" + e.Row.Cells[0].Text + "</div>";
                else
                    hplButton.Text = "<div onmouseover=\"title='Right click is disabled'\" style='cursor:hand;' oncontextmenu=\"Javascript:return false;\" id=div" + e.Row.RowIndex + "ITotal >" + e.Row.Cells[0].Text + "</div>";
                e.Row.Cells[0].Controls.Add(hplButton);
                e.Row.Cells[0].CssClass = "GridItemLink";
            }

            e.Row.Cells[1].Visible = false;
            
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
              

        protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
        {
            string strURL = "Sort=" + hidSort.Value + "&Period=" + hidPeriod.Value + "&ShowUsage=" + ( (chkShowUsage.Checked  == true) ? "true" : "false" ) + "&PkgType=" + ddlPkgType.SelectedValue; 
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "PrintReport('" + strURL + "');", true);
            BindDataGrid();
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

            sortExpression = ((hidSort.Value != "") ? hidSort.Value : "Branch asc");
           
            if (ddlPkgType.SelectedValue == "ALL")
            {
                dtTotal = iTotal.GetBranchInventoryOnHand(hidPeriod.Value, ddlPkgType.SelectedValue = "ALL"); //Pete added 11/17/2011

            }
            else if (ddlPkgType.SelectedValue == "PKG")
            {
                dtTotal = iTotal.GetBranchInventoryOnHand(hidPeriod.Value, ddlPkgType.SelectedValue = "PKG"); //Pete added 11/17/2011

            }
            else if (ddlPkgType.SelectedValue == "BULK")
            {
                dtTotal = iTotal.GetBranchInventoryOnHand(hidPeriod.Value, ddlPkgType.SelectedValue = "BULK"); //Pete added 11/17/2011

            }
            
            if (chkShowUsage.Checked)
            {
                headerContent = "<table border='1'>";
                headerContent += "<tr><th colspan='11' style='color:blue'>Branch Inventory On Hand</th></tr>";
                headerContent += "<tr><th colspan=3 align='left'>Period :" + hidPeriod.Value + "</th><th colspan=3 >PkType : " + ddlPkgType.SelectedValue + "</th><th colspan='2'>Run By : " + Session["UserName"].ToString() + "</th><th colspan='3'>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>";


                if (dtTotal != null && dtTotal.Rows.Count > 0)
                {
                    headerContent += "<tr><th style='width:180px;'>Branch</th><th>Qty</th><th>$ @Avg</th><th style='width:80px;'>Weight</th><th style='width:80px;'>$/Lb</th><th style='width:80px;'>Branch $/Lb</th><th style='width:80px;'>OTW $/Lb</th><th style='width:100px;' colspan=3><table border='1' cellpadding='0' cellspacing='0'  width='100%' style='font-weight:bold'><tr><td colspan=3 nowrap><center>30 Day Usage</center></td></tr><tr><td><center>" +
                                                "Qty</center></td><td width='70' align='center' nowrap  >" +
                                                "$ @Avg </td><td width='70' align='center' nowrap  >" +
                                                "Weight </td></tr></table> </th><th width='80'>Months On Hand</th></tr>";
                    foreach (DataRow roiReader in dtTotal.Rows)
                    {
                        excelContent += "<tr><td align='left'>" + roiReader["BranchDesc"].ToString().Replace("9995", "99") + "</td><td>" +
                                String.Format("{0:#,##0}", roiReader["Qty"]) + "</td><td nowrap=nowrap>" +
                                String.Format("{0:#,##0}", roiReader["DolAtAvgCost"]) + "</td><td nowrap=nowrap>" +
                                String.Format("{0:#,##0}", roiReader["Weight"]) + "</td><td>" +
                                String.Format("{0:#,##0.000}", roiReader["DolPerLb"]) + "</td><td nowrap=nowrap>" +
                                String.Format("{0:#,##0}", "") + "</td><td nowrap=nowrap>" +
                                String.Format("{0:#,##0}", "") + "</td><td nowrap=nowrap>" +
                                String.Format("{0:#,##0}", roiReader["ThirtyDayUsageQty"]) + "</td><td nowrap=nowrap>" +
                                String.Format("{0:#,##0}", roiReader["ThirtyDayUseQtyDolPerAvg"]) + "</td><td>" +
                                String.Format("{0:#,##0}", roiReader["ThirtyDayUseWgt"]) + "</td><td>" +
                                String.Format("{0:#,##0.0}", roiReader["MOH"]) + "</td></tr>";

                    }
                    footerContent = "<tr style='font-weight:bold'><td>Grand Total</td><td>" +
                             String.Format("{0:#,##0}", dtTotal.Compute("sum(Qty)", "")) + "</td><td nowrap=nowrap>" +
                             String.Format("{0:#,##0}", dtTotal.Compute("sum(DolAtAvgCost)", "")) + "</td><td nowrap=nowrap>" +
                             String.Format("{0:#,##0}", dtTotal.Compute("sum(Weight)", "")) + "</td><td>" +
                             String.Format("{0:#,##0.000}", dtTotal.Compute("sum(DolAtAvgCost)/sum(Weight)", "")) + "</td><td nowrap=nowrap>" +
                              iTotal.BranchDolPerLB + "</td><td nowrap=nowrap>" + iTotal.OTWDolPerLB + " </td><td nowrap=nowrap> </td><td> </td></tr>";

                }
            }
            else
            {
                headerContent = "<table border='1'>";
                headerContent += "<tr><th colspan='7' style='color:blue'>Branch Inventory On Hand</th></tr>";
                headerContent += "<tr><th colspan=2 align='left'>Period :" + hidPeriod.Value + "</th><th>PkType : " + ddlPkgType.SelectedValue + "</th><th colspan='2'>Run By : " + Session["UserName"].ToString() + "</th><th colspan='2'>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>";


                if (dtTotal != null && dtTotal.Rows.Count > 0)
                {
                    headerContent += "<tr><th style='width:180px;'>Branch</th><th>Qty</th><th>$ @Avg</th><th style='width:80px;'>Weight</th><th style='width:80px;'>$/Lb</th><th style='width:80px;'>Branch $/Lb</th><th style='width:80px;'>OTW $/Lb</th></tr>";
                    foreach (DataRow roiReader in dtTotal.Rows)
                    {
                        excelContent += "<tr><td align='left'>" + roiReader["BranchDesc"].ToString().Replace("9995", "99") + "</td><td>" +
                                String.Format("{0:#,##0}", roiReader["Qty"]) + "</td><td nowrap=nowrap>" +
                                String.Format("{0:#,##0}", roiReader["DolAtAvgCost"]) + "</td><td nowrap=nowrap>" +
                                String.Format("{0:#,##0}", roiReader["Weight"]) + "</td><td>" +
                                String.Format("{0:#,##0.000}", roiReader["DolPerLb"]) + "</td><td nowrap=nowrap>" +
                                String.Format("{0:#,##0}", "") + "</td><td nowrap=nowrap>" +
                                String.Format("{0:#,##0}", "") + "</td></tr>";

                    }
                    footerContent = "<tr style='font-weight:bold'><td>Grand Total</td><td>" +
                             String.Format("{0:#,##0}", dtTotal.Compute("sum(Qty)", "")) + "</td><td nowrap=nowrap>" +
                             String.Format("{0:#,##0}", dtTotal.Compute("sum(DolAtAvgCost)", "")) + "</td><td nowrap=nowrap>" +
                             String.Format("{0:#,##0}", dtTotal.Compute("sum(Weight)", "")) + "</td><td>" +
                             String.Format("{0:#,##0.000}", dtTotal.Compute("sum(DolAtAvgCost)/sum(Weight)", "")) + "</td><td nowrap=nowrap>" +
                              iTotal.BranchDolPerLB + "</td><td nowrap=nowrap>" + iTotal.OTWDolPerLB + " </td></tr>";

                }
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
            if (hidPeriod.Value != DateTime.Now.ToShortDateString())
            {
                ddlPkgType.SelectedIndex = 0;
                ddlPkgType.Enabled = false;
                BindDataGrid();
            }
            if (hidPeriod.Value == DateTime.Now.ToShortDateString())
            {
                ddlPkgType.Enabled = true;
                BindDataGrid();
            }
            
        }
                
        protected void chkShowUsage_CheckedChanged(object sender, EventArgs e)
        {
            BindDataGrid();
        }
        protected void chkShowBULK_CheckedChanged(object sender, EventArgs e)
        {
            BindDataGrid();
        }
        protected void chkShowPkg_CheckedChanged(object sender, EventArgs e)
        {
            BindDataGrid();
        }

        protected void ddlPkgType_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindDataGrid();
        }

        protected void cldStartDt_SelectionChanged1(object sender, EventArgs e)
        {
            if (cldStartDt.SelectedDate.ToShortDateString() == DateTime.Now.ToShortDateString())
            {
                ddlPkgType.Enabled = true;

            }
            if (cldStartDt.SelectedDate.ToShortDateString() != DateTime.Now.ToShortDateString())
            {
                ddlPkgType.SelectedIndex = 0;
                ddlPkgType.Enabled = false;

            }                         

        }
}

}