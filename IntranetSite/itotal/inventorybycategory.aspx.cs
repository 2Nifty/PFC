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
    public partial class InventoryByCategory : System.Web.UI.Page
    {       
        ITotal iTotal = new ITotal();
        private string sortExpression = string.Empty;
        private int pagesize = 18;
        DataTable dtTotal = new DataTable();
        string sort = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(InventoryByCategory));
            lblMessage.Text = "";

            if (!IsPostBack)
            {
                cldStartDt.SelectedDate = Convert.ToDateTime(Request.QueryString["Period"].ToString());
                cldStartDt.VisibleDate = Convert.ToDateTime(Request.QueryString["Period"].ToString());
                if (Request.QueryString["PkgType"] != null)     //gets ddlvalue from previous page and stick it here so that it will highlight/show it. per Sathis                       
                    ddlPkgType.SelectedValue = Request.QueryString["PkgType"].ToString();   
                else
                    ddlPkgType.SelectedIndex = 0;               //***end ditto***//

                ddlPkgType.Text = (Session["DropDownSelVal"].ToString().Trim());

                BindDataGrid();

                //ddlPkgType.SelectedIndex = 0;
               
            }

            hidFileName.Value = "InventoryByCategory_" + Session["SessionID"].ToString() + ".xls";

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

                   //dtTotal = iTotal.GetInventoryByCategory(cldStartDt.SelectedDate.ToShortDateString());
                   //dtTotal = iTotal.GetInventoryByCategory(hidPeriod.Value, ddlPkgType.SelectedValue = "BULK");
                    Session["InventoryCategory"] = dtTotal;
                }
                if (ddlPkgType.SelectedValue == "ALL")
                {
                    dtTotal = iTotal.GetInventoryByCategory(hidPeriod.Value, ddlPkgType.SelectedValue = "ALL"); //Pete added 11/17/2011

                }
                else if (ddlPkgType.SelectedValue == "PKG")
                {
                    dtTotal = iTotal.GetInventoryByCategory(hidPeriod.Value, ddlPkgType.SelectedValue = "PKG"); //Pete added 11/17/2011

                }
                else if (ddlPkgType.SelectedValue == "BULK")
                {
                    dtTotal = iTotal.GetInventoryByCategory(hidPeriod.Value, ddlPkgType.SelectedValue = "BULK"); //Pete added 11/17/2011

                }

                else
                {

                    dtTotal = (DataTable)Session["InventoryCategory"];

                }

                if (dtTotal !=null && dtTotal.Rows.Count > 0)
                {
                    sortExpression = ((hidSort.Value != "") ? hidSort.Value : "Category asc");
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
            e.Row.Cells[0].CssClass = "locked";
            if (e.Row.RowType == DataControlRowType.Header)
            {
                
                // Branch
                e.Row.Cells[1].ColumnSpan = 3;
                e.Row.Cells[1].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='99%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>Branch</center></td></tr><tr>" +
                                        "<td width='45' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center><Div style='cursor:hand;' onclick=\"javascript:BindValue('BrDol');\">$</div></center></td>" +
                                        "<td width='46' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><Div onclick=\"javascript:BindValue('BrLB');\">Lbs</div></td>" +
                                        "<td width='37' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'><Div onclick=\"javascript:BindValue('BrDolPerLb');\">$/Lb</div></td>" +
                                        "</tr></table>";
                e.Row.Cells[2].Visible = false;
                e.Row.Cells[3].Visible = false;

                // Car Trans
                e.Row.Cells[4].ColumnSpan = 3;
                e.Row.Cells[4].Text = "<table border='0' cellpadding='0' cellspacing='0' width='99%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>CarTrans</center></td></tr><tr>" +
                                        "<td width='43' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;' align='center'><Div style='cursor:hand;width:100%;' onclick=\"javascript:BindValue('CarTrDol');\">$</div></td>" +
                                        "<td width='46' class='GridHead splitBorders' nowrap nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><Div onclick=\"javascript:BindValue('CarTrLB');\">Lbs</div></td>" +
                                        "<td width='37' class='GridHead splitBorders' nowrap  nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'><Div onclick=\"javascript:BindValue('CarTrDolPerLb');\"><center>$/Lb</center></div></td>" +
                                        "</tr></table>";
                e.Row.Cells[5].Visible = false;
                e.Row.Cells[6].Visible = false;

                // Intra Trans
                e.Row.Cells[7].ColumnSpan = 3;
                e.Row.Cells[7].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='99%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>IntraTrans</center></td></tr><tr>" +
                                        "<td width='43' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center><Div style='cursor:hand;' onclick=\"javascript:BindValue('IntraTrDol');\">$</div></center></td>" +
                                        "<td width='46' class='GridHead splitBorders' nowrap nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><Div onclick=\"javascript:BindValue('IntraTrLB');\">Lbs</div></td>" +
                                        "<td width='37' class='GridHead splitBorders' nowrap nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'><center><Div onclick=\"javascript:BindValue('IntraTrDolPerLb');\">$/Lb</div></center></td>" +
                                        "</tr></table>";
                e.Row.Cells[8].Visible = false;
                e.Row.Cells[9].Visible = false;

                // OTW
                e.Row.Cells[10].ColumnSpan = 3;
                e.Row.Cells[10].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='99%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>OTW</center></td></tr><tr>" +
                                        "<td width='43' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center><Div style='cursor:hand;' onclick=\"javascript:BindValue('OTWDol');\">$</div></center></td>" +
                                        "<td width='46' class='GridHead splitBorders' nowrap  nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><Div onclick=\"javascript:BindValue('OTWLB');\">Lbs</div></td>" +
                                        "<td width='37' class='GridHead splitBorders' nowrap nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'><center><Div onclick=\"javascript:BindValue('OTWDolPerLb');\">$/Lb</div></center></td>" +
                                        "</tr></table>";
                e.Row.Cells[11].Visible = false;
                e.Row.Cells[12].Visible = false;

            }

            if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells[0].Text = "Grand Total";
                e.Row.Cells[1].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(BrDol)", ""));
                e.Row.Cells[2].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(BrLB)", ""));
                e.Row.Cells[4].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(CarTrDol)", ""));
                e.Row.Cells[5].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(CarTrLB)", ""));

                e.Row.Cells[7].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(IntraTrDol)", ""));
                e.Row.Cells[8].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(IntraTrLB)", ""));
                e.Row.Cells[10].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(OTWDol)", ""));
                e.Row.Cells[11].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(OTWLB)", ""));
            }

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                HyperLink _hplInvByCatItem= e.Row.FindControl("hplInvByCatItem") as HyperLink;
                _hplInvByCatItem.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'InvByCatItem', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");

                HyperLink _hplInvByCarBr= e.Row.FindControl("hplInvByCatBr") as HyperLink;
                _hplInvByCarBr.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'InvByCatItem', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");

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
            BindDataGrid();
        }

        protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
        {
            string strURL = "Sort=" + hidSort.Value + "&Period=" + hidPeriod.Value + "&PkgType=" + ddlPkgType.SelectedValue; 
            BindDataGrid();
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "PrintReport('" + strURL + "');", true);
        }       


        protected void ibtnRunReport_Click(object sender, ImageClickEventArgs e)
        {
            BindDataGrid();
        }

        protected void ddlPkgType_SelectedIndexChanged(object sender, EventArgs e)
        {
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

            sortExpression = ((hidSort.Value != "") ? hidSort.Value : "Category asc");

            if (ddlPkgType.SelectedValue == "ALL")
            {
                dtTotal = iTotal.GetInventoryByCategory(hidPeriod.Value, ddlPkgType.SelectedValue = "ALL"); //Pete added 11/17/2011

            }
            else if (ddlPkgType.SelectedValue == "PKG")
            {
                dtTotal = iTotal.GetInventoryByCategory(hidPeriod.Value, ddlPkgType.SelectedValue = "PKG"); //Pete added 11/17/2011

            }
            else if (ddlPkgType.SelectedValue == "BULK")
            {
                dtTotal = iTotal.GetInventoryByCategory(hidPeriod.Value, ddlPkgType.SelectedValue = "BULK"); //Pete added 11/17/2011

            }

           // dtTotal =(DataTable) Session["InventoryCategory"];
            dtTotal.DefaultView.Sort = sortExpression;
            dtTotal = dtTotal.DefaultView.ToTable(); 

            headerContent = "<table border='1' width='1010'>";
            headerContent += "<tr><th colspan='15' style='color:blue'>Inventory By Category Report</th></tr>";
            headerContent += "<tr><th colspan=8 align='left'>Period :" + hidPeriod.Value + "</th><th colspan=2 align='left'>PkType : " + ddlPkgType.SelectedValue + "</th><th colspan='3'>Run By : " + Session["UserName"].ToString() + "</th><th colspan='2' align='left'>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>";


            if (dtTotal.Rows.Count > 0)
            {
                headerContent +=    "<tr style='font-weight:bold'><th style='width:150px;'>Category</th>" +
                                    "<th style='width:200px' colspan='3'><table border='1px' ><tr><th colspan='3'>Branch</th></tr><tr><th>$</th><th>Lbs</th><th>$/Lb</th></table></th>" +
                                    "<th style='width:200px' colspan='3'><table border='1px' ><tr><th colspan='3'>CarTrans</th></tr><tr><th>$</th><th>Lbs</th><th>$/Lb</th></table></th>" +
                                    "<th style='width:200px' colspan='3'><table border='1px' ><tr><th colspan='3'>IntraTrans</th></tr><tr><th>$</th><th>Lbs</th><th>$/Lb</th></table></th>" +
                                    "<th style='width:200px' colspan='3'><table border='1px' ><tr><th colspan='3'>OTW</th></tr><tr><th>$</th><th>Lbs</th><th>$/Lb</th></table></th>" +
                                    "<th width='60'>30D Usage $</th><th width='40'>Months On Hand</th></tr>";
                                    
                foreach (DataRow roiReader in dtTotal.Rows)
                {
                    excelContent += "<tr><td align='left'>" + roiReader["CatDesc"].ToString() + "</td><td style='width:70px'>" +
                            String.Format("{0:#,##0}", roiReader["BrDol"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["BrLB"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0.000}", roiReader["BrDolPerLb"]) + "</td><td>" +
                            String.Format("{0:#,##0}", roiReader["CarTrDol"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["CarTrLB"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0.000}", roiReader["CarTrDolPerLb"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["IntraTrDol"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["IntraTrLB"]) + "</td><td>" +
                            String.Format("{0:#,##0.000}", roiReader["IntraTrDolPerLb"]) + "</td><td>" +
                            String.Format("{0:#,##0}", roiReader["OTWDol"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["OTWLB"]) + "</td><td>" +
                            String.Format("{0:#,##0.000}", roiReader["OTWDolPerLb"]) + "</td><td>" +
                            String.Format("{0:#,##0}", roiReader["ThirtyDayDol"]) + "</td><td>" +
                            String.Format("{0:#,##0.0}", roiReader["MOH"]) + "</td></tr>";

                }
                footerContent = "<tr style='font-weight:bold'><td>Grand Total</td><td>" +
                            String.Format("{0:#,##0}", dtTotal.Compute("sum(BrDol)", "")) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", dtTotal.Compute("sum(BrLB)", "")) + "</td><td nowrap=nowrap></td><td nowrap=nowrap>" +

                            String.Format("{0:#,##0}", dtTotal.Compute("sum(CarTrDol)", "")) + "</td><td>" +
                            String.Format("{0:#,##0}", dtTotal.Compute("sum(CarTrLB)", "")) + "</td><td nowrap=nowrap></td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", dtTotal.Compute("sum(IntraTrDol)", "")) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", dtTotal.Compute("sum(IntraTrLB)", "")) + "</td><td nowrap=nowrap></td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", dtTotal.Compute("sum(OTWDol)", "")) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", dtTotal.Compute("sum(OTWLB)", "")) + "</td><td nowrap=nowrap></td><td> </td></tr>";

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
       

}

}