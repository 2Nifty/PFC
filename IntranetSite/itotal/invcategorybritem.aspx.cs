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
    public partial class InvCategoryBrItem : System.Web.UI.Page
    {
       
        ITotal iTotal = new ITotal();
        private string sortExpression = string.Empty;
        private string branchID = string.Empty;
        private string branchDesc = string.Empty;
        private string categoryID = string.Empty;
        private string categoryDesc = string.Empty;
        private int pagesize = 16;
        DataTable dtTotal = new DataTable();
        string sort = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(InvCategoryBrItem));
            branchID = Request.QueryString["Branch"].ToString();
            branchDesc = Request.QueryString["BranchDesc"].ToString();
            categoryID = Request.QueryString["Category"].ToString();
            categoryDesc = Request.QueryString["CategoryDesc"].ToString();
            lblMessage.Text = "";

            if (!IsPostBack)
            {
                cldStartDt.SelectedDate = Convert.ToDateTime(Request.QueryString["Period"].ToString());
                cldStartDt.VisibleDate = Convert.ToDateTime(Request.QueryString["Period"].ToString());
                lblBranch.Text = "Branch:&nbsp;" + branchDesc;
                lblCategory.Text = "Category:&nbsp;" + categoryDesc;

                ddlPkgType.Text = (Session["DropDownSelVal"].ToString().Trim());
                
                BindDataGrid();
               
            }

            hidFileName.Value = "CategoryBrItem_" + Session["SessionID"].ToString() + ".xls";

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

                   // dtTotal = iTotal.GetInventoryByCategoryBranchItem(cldStartDt.SelectedDate.ToShortDateString(), categoryID, branchID);
                    hidPeriod.Value = cldStartDt.SelectedDate.ToShortDateString();
                }
                if (ddlPkgType.SelectedValue == "ALL")
                {
                    dtTotal = iTotal.GetInventoryByCategoryBranchItem(hidPeriod.Value, categoryID, branchID, ddlPkgType.SelectedValue = "ALL"); //Pete added 11/17/2011

                }
                else if (ddlPkgType.SelectedValue == "PKG")
                {
                    dtTotal = iTotal.GetInventoryByCategoryBranchItem(hidPeriod.Value, categoryID, branchID, ddlPkgType.SelectedValue = "PKG"); //Pete added 11/17/2011

                }
                else if (ddlPkgType.SelectedValue == "BULK")
                {
                    dtTotal = iTotal.GetInventoryByCategoryBranchItem(hidPeriod.Value, categoryID, branchID, ddlPkgType.SelectedValue = "BULK"); //Pete added 11/17/2011

                }

                else
                {
                    dtTotal = iTotal.GetInventoryByCategoryBranchItem(hidPeriod.Value, categoryID, branchID);
                }
                if (dtTotal !=null && dtTotal.Rows.Count > 0)
                {
                    sortExpression = ((hidSort.Value != "") ? hidSort.Value : "ItemNo asc");
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
                e.Row.Cells[9].ColumnSpan = 2;
                e.Row.Cells[9].Text =  "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>30 Day Usage</center></td></tr><tr><td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ThirtyDayUsageQty');\">Qty</div></center></td><td width='70' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('ThirtyDayUseQtyDolPerAvg');\">$ @Avg</div></td></tr></table>";
                e.Row.Cells[10].Visible = false;  
            }

           
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells[0].Text = "Grand Total";
                e.Row.Cells[5].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(Qty)", ""));
                e.Row.Cells[6].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(DolAtAvgCost)", ""));
                e.Row.Cells[7].Text = String.Format("{0:#,##0}", dtTotal.Compute("sum(Weight)", ""));
                e.Row.Cells[8].Text = String.Format("{0:#,##0.000}", (Convert.ToInt32(dtTotal.Compute("sum(Weight)", "")) == 0) ? 0 : dtTotal.Compute("sum(DolAtAvgCost)/sum(Weight)", ""));               
                
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
            //BindDataGrid();
        }

        protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
        {
            string strURL = "Sort=" + hidSort.Value + "&Period=" + hidPeriod.Value + "&Branch=" + branchID + "&BranchDesc=" + branchDesc + "&Category=" + categoryID + "&CategoryDesc=" + categoryDesc + "&PkgType=" + ddlPkgType.SelectedValue;   
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

            sortExpression = ((hidSort.Value != "") ? hidSort.Value : "ItemNo asc");
           // dtTotal = iTotal.GetInventoryByCategoryBranchItem(hidPeriod.Value, categoryID, branchID);
           // dtTotal = iTotal.GetInventoryByCategoryBranchItem(hidPeriod.Value, categoryID, branchID);

            if (ddlPkgType.SelectedValue == "ALL")
            {
                dtTotal = iTotal.GetInventoryByCategoryBranchItem(hidPeriod.Value, categoryID, branchID, ddlPkgType.SelectedValue = "ALL"); //Pete added 11/17/2011

            }
            else if (ddlPkgType.SelectedValue == "PKG")
            {
                dtTotal = iTotal.GetInventoryByCategoryBranchItem(hidPeriod.Value, categoryID, branchID, ddlPkgType.SelectedValue = "PKG"); //Pete added 11/17/2011

            }
            else if (ddlPkgType.SelectedValue == "BULK")
            {
                dtTotal = iTotal.GetInventoryByCategoryBranchItem(hidPeriod.Value, categoryID, branchID, ddlPkgType.SelectedValue = "BULK"); //Pete added 11/17/2011

            }

            dtTotal.DefaultView.Sort = sortExpression;
            dtTotal = dtTotal.DefaultView.ToTable(); 

            headerContent = "<table border='1' width='900'>";
            headerContent += "<tr><th colspan='12' style='color:blue'>Inventory By Category/Branch Item Report</th></tr>";
            headerContent += "<tr><th colspan='2' align='left'>Branch: " + branchDesc + "</th><th colspan=1 align='left'>PkType : " + ddlPkgType.SelectedValue + "</th><th colspan='4'>Category:" + categoryDesc + "</th><th colspan=1 align='left'>Period :" + hidPeriod.Value + "</th><th colspan='2'>Run By : " + Session["UserName"].ToString() + "</th><th colspan='2' align='left'>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>";


            if (dtTotal.Rows.Count > 0)
            {
                headerContent += "<tr><th style='width:150px;'>Item</th><th  style='width:200px'>Description</th><th style='width:80px;'>Net Weight</th><th>SVC</th><th style='width:80px;'>CVC</th><th style='width:80px;'>Qty</th><th style='width:80px;'>$@AvgCost</th><th style='width:80px;'>Weight</th><th style='width:80px;'>$/Lb</th><th style='width:100px;' colspan=2><table border='1' cellpadding='0' cellspacing='0'  width='100%' style='font-weight:bold'><tr><td colspan=2 nowrap><center>30 Day Usage</center></td></tr><tr><td><center>" +
                                            "Qty</center></td><td width='70' align='center' nowrap  >" +
                                            "$ @Avg </td></tr></table> </th><th width='40'>Months On Hand</th></tr>";
                foreach (DataRow roiReader in dtTotal.Rows)
                {
                    excelContent += "<tr><td align='left'>" + roiReader["ItemNo"].ToString() + "</td><td>" +
                            String.Format("{0:#,##0}", roiReader["Description"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0.00}", roiReader["NetWght"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["SVC"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["CVC"]) + "</td><td>" +
                            String.Format("{0:#,##0}", roiReader["Qty"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["DolAtAvgCost"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["Weight"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0.000}", roiReader["DolPerLb"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["ThirtyDayUsageQty"]) + "</td><td>" +
                            String.Format("{0:#,##0}", roiReader["ThirtyDayUseQtyDolPerAvg"]) + "</td><td>" +
                            String.Format("{0:#,##0.0}", roiReader["MOH"]) + "</td></tr>";

                }
                footerContent = "<tr style='font-weight:bold'><td colspan='5'>Grand Total</td><td>" +
                         String.Format("{0:#,##0}", dtTotal.Compute("sum(Qty)", "")) + "</td><td nowrap=nowrap>" +
                         String.Format("{0:#,##0}", dtTotal.Compute("sum(DolAtAvgCost)", "")) + "</td><td nowrap=nowrap>" +
                         String.Format("{0:#,##0}", dtTotal.Compute("sum(Weight)", "")) + "</td><td>" +
                         String.Format("{0:#,##0.000}", (Convert.ToInt32(dtTotal.Compute("sum(Weight)", "")) == 0) ? 0 : dtTotal.Compute("sum(DolAtAvgCost)/sum(Weight)", "")) + "</td><td nowrap=nowrap>" +
                          iTotal.BranchDolPerLB + "</td><td nowrap=nowrap>" + iTotal.OTWDolPerLB+" </td><td> </td></tr>";

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