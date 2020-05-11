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
        private int pagesize = 18;
        DataTable dtTotal = new DataTable();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(BranchInventoryOnHand));
            lblMessage.Text = "";
            if (!IsPostBack)
            {
                cldStartDt.SelectedDate = Convert.ToDateTime("08/08/2008");
                cldStartDt.VisibleDate = Convert.ToDateTime("08/08/2008");
                
                //
                // Fill The Branches in the Combo
                //
                Session["SessionID"] = "1234";
                Session["UserName"] = "328";             
                BindDataGrid();
               
            }
            hidPeriod.Value = cldStartDt.SelectedDate.ToShortDateString();
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
                lblPeriod.Text = "Period : " + cldStartDt.SelectedDate.ToShortDateString();
              
                 dtTotal = iTotal.GetBranchInventoryOnHand(cldStartDt.SelectedDate.ToShortDateString());
                

                if (dtTotal !=null && dtTotal.Rows.Count > 0)
                {
                    sortExpression = ((hidSort.Value != "") ? hidSort.Value : "Branch asc");
                    dtTotal.DefaultView.Sort = sortExpression;
                    Session["BranchInventoryOnHand"] = dtTotal.DefaultView.ToTable();
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
                e.Row.Cells[7].ColumnSpan = 2;
                e.Row.Cells[7].Text =  "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>30 Day Usage</center></td></tr><tr><td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ThirtyDayUsageQty');\">Qty</div></center></td><td width='70' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('ThirtyDayUseQtyDolPerAvg');\">$ @Avg</div></td></tr></table>";
                e.Row.Cells[8].Visible = false;
              

            }

           
            if (e.Row.RowType == DataControlRowType.Footer)
            {


                e.Row.Cells[0].Text = "Grand Total";                
                 e.Row.Cells[5].Text = iTotal.BranchDolPerLB;
                 e.Row.Cells[6].Text = iTotal.OTWDolPerLB;
                 e.Row.Cells[1].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(Qty)", ""));
                 e.Row.Cells[2].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(DolAtAvgCost)", ""));
                 e.Row.Cells[3].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(Weight)", ""));
                 e.Row.Cells[4].Text = String.Format("{0:#,##0.000}", dtTotal.Compute("sum(DolAtAvgCost)/sum(Weight)", ""));
            }

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                string url = string.Empty;
                string InvCatBrItem = Global.IntranetSiteURL + "ITotal/InvCategoryBranchItem.aspx?BrDesc=" + e.Row.Cells[0].Text + "&Period=" + hidPeriod.Value ;
                string BrItemDetail = Global.IntranetSiteURL + "ITotal/BranchItemDetail.aspx?BrDesc=" + e.Row.Cells[0].Text + "&Period=" + hidPeriod.Value;

                HyperLink hplButton = new HyperLink();
                hplButton.Text = "<div oncontextmenu=\"Javascript:return false;\" id=div" + e.Row.RowIndex + "CAS onmousedown=\"ShowToolTip(event,'" + InvCatBrItem + "','" + BrItemDetail + "',this.id);\">" + e.Row.Cells[0].Text + "</div>";
                hplButton.Attributes.Add("onclick", "window.open(this.href, 'popupwindow', 'height=700,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=NO'); return false;");
                e.Row.Cells[0].Controls.Add(hplButton);
                e.Row.Cells[0].CssClass = "GridItemLink";
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
          
            BindDataGrid();
        }      
        
        protected void cldStartDt_SelectionChanged(object sender, EventArgs e)
        {
            BindDataGrid();
            hidPeriod.Value = cldStartDt.SelectedDate.ToShortDateString();
        }

        protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
        {
            string strURL = "Sort=" + hidSort.Value + "&Period=" + cldStartDt.SelectedDate.ToShortDateString(); 
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "PrintReport('" + strURL + "');", true);
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


            dtTotal = (DataTable)iTotal.GetBranchInventoryOnHand(cldStartDt.SelectedDate.ToShortDateString());

            headerContent = "<table border='1' width='90%'>";
            headerContent += "<tr><th colspan='10' style='color:blue'>Branch Inventory On Hand</th></tr>";
            headerContent += "<tr><th colspan=3 align='left'>Period :" + cldStartDt.SelectedDate.ToShortDateString() + "</th><th colspan=3 ></th><th colspan='2'>Run By : " + Session["UserName"].ToString() + "</th><th colspan='2'>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>";


            if (dtTotal.Rows.Count > 0)
            {
                headerContent += "<tr><th style='width:180px;'>Branch</th><th>Qty</th><th>$ @Avg</th><th style='width:80px;'>Weight</th><th style='width:80px;'>$/Lb</th><th style='width:80px;'>Branch $/Lb</th><th style='width:80px;'>OTW $/Lb</th><th style='width:100px;' colspan=2><table border='1' cellpadding='0' cellspacing='0'  width='100%' style='font-weight:bold'><tr><td colspan=2 nowrap><center>30 Day Usage</center></td></tr><tr><td><center>" +
                                            "Qty</center></td><td width='70' align='center' nowrap  >" +
                                            "$ @Avg </td></tr></table> </th><th width='80'>Months On Hand</th></tr>";
                foreach (DataRow roiReader in dtTotal.Rows)
                {
                    excelContent += "<tr><td align='left'>" + roiReader["BranchDesc"].ToString() + "</td><td>" +
                            String.Format("{0:#,##0}", roiReader["Qty"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["DolAtAvgCost"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["Weight"]) + "</td><td>" +
                            String.Format("{0:#,##0.000}", roiReader["DolPerLb"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", "") + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", "") + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["ThirtyDayUsageQty"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["ThirtyDayUseQtyDolPerAvg"]) + "</td><td>" +
                            String.Format("{0:#,##0}", roiReader["MOH"]) + "</td></tr>";

                }
                footerContent = "<tr style='font-weight:bold'><td>Grand Total</td><td>" +
                         String.Format("{0:#,##0}", dtTotal.Compute("sum(Qty)", "")) + "</td><td nowrap=nowrap>" +
                         String.Format("{0:#,##0}", dtTotal.Compute("sum(DolAtAvgCost)", "")) + "</td><td nowrap=nowrap>" +
                         String.Format("{0:#,##0}", dtTotal.Compute("sum(Weight)", "")) + "</td><td>" +
                         String.Format("{0:#,##0.000}", dtTotal.Compute("sum(DolAtAvgCost)/sum(Weight)", "")) + "</td><td nowrap=nowrap>" +
                          iTotal.BranchDolPerLB + "</td><td nowrap=nowrap>" + iTotal.OTWDolPerLB+" </td><td nowrap=nowrap> </td><td> </td></tr>";

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