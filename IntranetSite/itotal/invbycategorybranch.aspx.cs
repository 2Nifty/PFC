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
    public partial class InvByCategoryBranch : System.Web.UI.Page
    {
       
        ITotal iTotal = new ITotal();
        private string sortExpression = string.Empty;
        private string category = string.Empty;
        private int pagesize = 18;
        DataTable dtTotal = new DataTable();
        string sort = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(InvByCategoryBranch));
            lblCatDesc.Text = Request.QueryString["CategoryDesc"].ToString();
            category = Request.QueryString["Category"].ToString();
            lblMessage.Text = "";

            if (!IsPostBack)
            {
                cldStartDt.SelectedDate = Convert.ToDateTime(Request.QueryString["Period"].ToString());
                cldStartDt.VisibleDate = Convert.ToDateTime(Request.QueryString["Period"].ToString());

                ddlPkgType.Text = (Session["DropDownSelVal"].ToString().Trim());

                BindDataGrid();
               
            }
            hidFileName.Value = "InvByCategoryBranch_" + Session["SessionID"].ToString() + ".xls";

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
                if(sort =="")
                {
                
                lblPeriod.Text = "Period : " + cldStartDt.SelectedDate.ToShortDateString();
                hidPeriod.Value = cldStartDt.SelectedDate.ToShortDateString();
                //dtTotal = iTotal.GetInventoryByCategoryBranch(cldStartDt.SelectedDate.ToShortDateString(),category);
                }

                if (ddlPkgType.SelectedValue == "ALL")
                {
                    dtTotal = iTotal.GetInventoryByCategoryBranch(hidPeriod.Value, category,  ddlPkgType.SelectedValue = "ALL"); //Pete added 11/17/2011

                }
                else if (ddlPkgType.SelectedValue == "PKG")
                {
                    dtTotal = iTotal.GetInventoryByCategoryBranch(hidPeriod.Value, category, ddlPkgType.SelectedValue = "PKG"); //Pete added 11/17/2011

                }
                else if (ddlPkgType.SelectedValue == "BULK")
                {
                    dtTotal = iTotal.GetInventoryByCategoryBranch(hidPeriod.Value, category, ddlPkgType.SelectedValue = "BULK"); //Pete added 11/17/2011

                }


                else
                    dtTotal = iTotal.GetInventoryByCategoryBranch(hidPeriod.Value, category);

                if (dtTotal !=null && dtTotal.Rows.Count > 0)
                {
                    sortExpression = ((hidSort.Value != "") ? hidSort.Value : "Branch asc");                    
                    dtTotal.DefaultView.Sort = sortExpression;
                    dvBIOnhand.DataSource = dtTotal.DefaultView.ToTable();
                    dvBIOnhand.Visible = true;
                    lblStatus.Visible = false;
                    dvBIOnhand.DataBind();

                }
                else
                {
                    dvBIOnhand.Visible = false;
                    lblStatus.Visible = true;
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
                e.Row.Cells[6].ColumnSpan = 2;
                e.Row.Cells[6].Text =  "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>30 Day Usage</center></td></tr><tr><td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ThirtyDayUsageQty');\">Qty</div></center></td><td width='70' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('ThirtyDayUseQtyDolPerAvg');\">$ @Avg</div></td></tr></table>";
                e.Row.Cells[7].Visible = false;             
            }
                       
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells[0].Text = "Grand Total";      
                e.Row.Cells[2].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(Qty)", ""));
                e.Row.Cells[3].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(DolAtAvgCost)", ""));
                e.Row.Cells[4].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(Weight)", ""));
                e.Row.Cells[5].Text = String.Format("{0:#,##0.000}", (Convert.ToInt32(dtTotal.Compute("sum(Weight)", "")) == 0) ? 0 : dtTotal.Compute("sum(DolAtAvgCost)/sum(Weight)", ""));
                
            }

            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                HyperLink _hplInvByCatItem = e.Row.FindControl("hplInvByCatBrItem") as HyperLink;
                _hplInvByCatItem.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'InvByCatBrItem', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");
               
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
        
        protected void cldStartDt_SelectionChanged(object sender, EventArgs e)
        {
            BindDataGrid();
        }

        protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
        {
            string strURL = "Sort=" + hidSort.Value + "&Period=" + hidPeriod.Value + "&Category=" + category + "&CatDesc=" + Request.QueryString["CategoryDesc"].ToString() + "&PkgType=" + ddlPkgType.SelectedValue;  
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


            //dtTotal = (DataTable)iTotal.GetInventoryByCategoryBranch(hidPeriod.Value,category);


            if (ddlPkgType.SelectedValue == "ALL")
            {
                dtTotal = iTotal.GetInventoryByCategoryBranch(hidPeriod.Value, category, ddlPkgType.SelectedValue = "ALL"); //Pete added 11/17/2011

            }
            else if (ddlPkgType.SelectedValue == "PKG")
            {
                dtTotal = iTotal.GetInventoryByCategoryBranch(hidPeriod.Value, category, ddlPkgType.SelectedValue = "PKG"); //Pete added 11/17/2011

            }
            else if (ddlPkgType.SelectedValue == "BULK")
            {
                dtTotal = iTotal.GetInventoryByCategoryBranch(hidPeriod.Value, category, ddlPkgType.SelectedValue = "BULK"); //Pete added 11/17/2011

            }

            headerContent = "<table border='1' width='70%'>";
            headerContent += "<tr><th colspan='8' style='color:blue'>Inventory By Category </th></tr>";
            headerContent += "<tr><th colspan=2 align='left'>Category :" + Request.QueryString["CategoryDesc"].ToString() + "</th><th colspan=1 align='left'>PkType : " + ddlPkgType.SelectedValue + "</th><th colspan=3 >Period:" + hidPeriod.Value + "</th><th colspan='1'>Run By : " + Session["UserName"].ToString() + "</th><th colspan='1'>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>";


            if (dtTotal.Rows.Count > 0)
            {
                headerContent += "<tr><th style='width:180px;'>Branch</th><th>Qty</th><th>$ @Avg</th><th style='width:80px;'>Weight</th><th style='width:80px;'>$/Lb</th><th style='width:100px;' colspan=2><table border='1' cellpadding='0' cellspacing='0'  width='100%' style='font-weight:bold'><tr><td colspan=2 nowrap><center>30 Day Usage</center></td></tr><tr><td><center>" +
                                            "Qty</center></td><td width='70' align='center' nowrap  >" +
                                            "$ @Avg </td></tr></table> </th><th width='80'>Months On Hand</th></tr>";
                foreach (DataRow roiReader in dtTotal.Rows)
                {
                    excelContent += "<tr><td align='left'>" + roiReader["BranchDesc"].ToString() + "</td><td>" +
                            String.Format("{0:#,##0}", roiReader["Qty"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["DolAtAvgCost"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["Weight"]) + "</td><td>" +
                            String.Format("{0:#,##0.000}", roiReader["DolPerLb"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["ThirtyDayUsageQty"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["ThirtyDayUseQtyDolPerAvg"]) + "</td><td>" +
                            String.Format("{0:#,##0.0}", roiReader["MOH"]) + "</td></tr>";

                }
                footerContent = "<tr style='font-weight:bold'><td>Grand Total</td><td>" +
                         String.Format("{0:#,##0}", dtTotal.Compute("sum(Qty)", "")) + "</td><td nowrap=nowrap>" +
                         String.Format("{0:#,##0}", dtTotal.Compute("sum(DolAtAvgCost)", "")) + "</td><td nowrap=nowrap>" +
                         String.Format("{0:#,##0}", dtTotal.Compute("sum(Weight)", "")) + "</td><td>" +
                         String.Format("{0:#,##0.000}", (Convert.ToInt32(dtTotal.Compute("sum(Weight)", "")) == 0) ? 0 : dtTotal.Compute("sum(DolAtAvgCost)/sum(Weight)", "")) + "</td>" +
                                       "<td nowrap=nowrap> </td><td> </td></tr>";

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