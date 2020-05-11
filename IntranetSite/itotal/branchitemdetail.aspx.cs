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
    public partial class BranchItemDetail : System.Web.UI.Page
    {
       
        ITotal iTotal = new ITotal();
        private string sortExpression = string.Empty;
        private string branchID = string.Empty;
        private string savPkType = string.Empty;
        private string branchDesc = string.Empty;
        private int pagesize = 16;
        DataTable dtTotal = new DataTable();
        string sort = "";
            

       

        protected void Page_Load(object sender, EventArgs e)
        {
            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(BranchItemDetail));
            branchID = Request.QueryString["Branch"].ToString();
            branchDesc = Request.QueryString["BranchDesc"].ToString();
            lblMessage.Text = "";
            
            //ddlPkgType.Text = (Session["DropDownSelVal"].ToString().Trim());

            if (!IsPostBack)
            {
                cldStartDt.SelectedDate = Convert.ToDateTime(Request.QueryString["Period"].ToString());
                cldStartDt.VisibleDate = Convert.ToDateTime(Request.QueryString["Period"].ToString());
                lblBranch.Text = "Branch: " + branchDesc;

                ddlPkgType.Text = (Session["DropDownSelVal"].ToString().Trim());
                         
                BindDataGrid();               
            }

          //  sav =  Session["DropDownSelVal"].ToString();

            hidFileName.Value = "BranchItemDetail_" + Session["SessionID"].ToString() + ".xls";

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
                    //dtTotal = iTotal.GetInventoryBranchItemDetail(cldStartDt.SelectedDate.ToShortDateString(), branchID);
                }

                if  (ddlPkgType.SelectedValue == "ALL")
                //if (Session["DropDownSelVal"] == "ALL")
                   // if (ddlPkgType.SelectedValue = Session["DropDownSelVal"])
               
                {                    
                   dtTotal = iTotal.GetInventoryBranchItemDetail(hidPeriod.Value, branchID, ddlPkgType.SelectedValue = "ALL"); //Pete added 11/17/2011
                   // dtTotal = iTotal.GetInventoryBranchItemDetail(hidPeriod.Value, branchID, iTotal.GetBranchInventoryOnHand(hidPkgType1.PkgType)); //Pete added 04/13/2012
                   // dtTotal = iTotal.GetInventoryBranchItemDetail(hidPeriod.Value, branchID, iTotal.GetBranchInventoryOnHand(hidPkgType1.Value)); //Pete added 04/13/2012

                }
                else if (ddlPkgType.SelectedValue == "PKG")
                //else if (Session["DropDownSelVal"] == "PKG")
                {
                    dtTotal = iTotal.GetInventoryBranchItemDetail(hidPeriod.Value, branchID, ddlPkgType.SelectedValue = "PKG"); //Pete added 11/17/2011

                }
                else if (ddlPkgType.SelectedValue == "BULK")
                //else if (sav == "BULK")
                {
                    dtTotal = iTotal.GetInventoryBranchItemDetail(hidPeriod.Value, branchID, ddlPkgType.SelectedValue = "BULK"); //Pete added 11/17/2011

                }
                else
                {
                    dtTotal = iTotal.GetInventoryBranchItemDetail(hidPeriod.Value, branchID);
                }

                if (dtTotal !=null && dtTotal.Rows.Count > 0)
                {
                    if (chkShowUsage.Checked)
                    {
                        dvBIOnhand.Columns[9].Visible = true;
                        dvBIOnhand.Columns[10].Visible = true;
                        dvBIOnhand.Columns[11].Visible = true;                        
                    }
                    else
                    {
                        dvBIOnhand.Columns[9].Visible = false;
                        dvBIOnhand.Columns[10].Visible = false;
                        dvBIOnhand.Columns[11].Visible = false;                        
                    }

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
                e.Row.Cells[8].Text = String.Format("{0:#,##0.000}",(Convert.ToInt32(dtTotal.Compute("sum(Weight)", ""))==0)? 0: dtTotal.Compute("sum(DolAtAvgCost)/sum(Weight)", ""));               
                
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
            string strURL = "Sort=" + hidSort.Value + "&Period=" + hidPeriod.Value + "&Branch=" + branchID + "&BranchDesc=" + branchDesc + "&ShowUsage=" + chkShowUsage.Checked + "&PkgType=" + ddlPkgType.SelectedValue; 
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

            sortExpression = ((hidSort.Value != "") ? hidSort.Value : "ItemNo asc");
            //dtTotal = iTotal.GetInventoryBranchItemDetail(hidPeriod.Value, branchID);
            // dtTotal = iTotal.GetInventoryBranchItemDetail(hidPeriod.Value, branchID);

            if (ddlPkgType.SelectedValue == "ALL")
            {
                dtTotal = iTotal.GetInventoryBranchItemDetail(hidPeriod.Value, branchID, ddlPkgType.SelectedValue = "ALL"); //Pete added 11/17/2011

            }
            else if (ddlPkgType.SelectedValue == "PKG")
            {
                dtTotal = iTotal.GetInventoryBranchItemDetail(hidPeriod.Value, branchID, ddlPkgType.SelectedValue = "PKG"); //Pete added 11/17/2011

            }
            else if (ddlPkgType.SelectedValue == "BULK")
            {
                dtTotal = iTotal.GetInventoryBranchItemDetail(hidPeriod.Value, branchID, ddlPkgType.SelectedValue = "BULK"); //Pete added 11/17/2011

            }


            dtTotal.DefaultView.Sort = sortExpression;
            dtTotal = dtTotal.DefaultView.ToTable();

            if (chkShowUsage.Checked)
            {
                headerContent = "<table border='1' width='900'>";
                headerContent += "<tr><th colspan='12' style='color:blue'>Inventory Branch Item Detail Report</th></tr>";
                headerContent += "<tr><th colspan='2' align='left'>Branch: " + branchDesc + "</th><th colspan=2 align='left'>Period :" + hidPeriod.Value + "</th><th colspan=2 >PkType : " + ddlPkgType.SelectedValue + "</th><th colspan='3'>Run By : " + Session["UserName"].ToString() + "</th><th colspan='3' align='left'>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>";


                if (dtTotal.Rows.Count > 0)
                {
                    headerContent += "<tr><th style='width:150px;'>Item</th><th  style='width:200px'>Description</th><th style='width:80px;'>NetWeight</th><th>SVC</th><th style='width:80px;'>CVC</th><th style='width:80px;'>Qty</th><th style='width:80px;'>$@AvgCost</th><th style='width:80px;'>Weight</th><th style='width:80px;'>$/Lb</th><th style='width:100px;' colspan=2><table border='1' cellpadding='0' cellspacing='0'  width='100%' style='font-weight:bold'><tr><td colspan=2 nowrap><center>30 Day Usage</center></td></tr><tr><td><center>" +
                                                "Qty</center></td><td width='70' align='center' nowrap  >" +
                                                "$ @Avg </td></tr></table> </th><th width='40'>Months On Hand</th></tr>";

                    DataGrid dg = new DataGrid();
                    dg.AutoGenerateColumns = true;
                    dg.ShowHeader = false;

                    dg.DataSource = dtTotal;
                    dg.DataBind();
                    foreach (DataGridItem i in dg.Items)
                    {
                        //foreach (TableCell tc in i.Cells[1])
                        i.Cells[1].Attributes.Add("class", "text");
                    }

                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    System.IO.StringWriter sw = new System.IO.StringWriter(sb);
                    HtmlTextWriter htw = new HtmlTextWriter(sw);
                    dg.RenderControl(htw);
                    string style = @"<style> .text { mso-number-format:\@; } </style> ";
                    Response.Write(style);

                    excelContent = sb.ToString();

                    footerContent = "<table border='1'><tr style='font-weight:bold'><td colspan='5'>Grand Total</td><td>" +
                             String.Format("{0:#,##0}", dtTotal.Compute("sum(Qty)", "")) + "</td><td nowrap=nowrap>" +
                             String.Format("{0:#,##0}", dtTotal.Compute("sum(DolAtAvgCost)", "")) + "</td><td nowrap=nowrap>" +
                             String.Format("{0:#,##0}", dtTotal.Compute("sum(Weight)", "")) + "</td><td>" +
                             String.Format("{0:#,##0.000}", (Convert.ToInt32(dtTotal.Compute("sum(Weight)", "")) == 0) ? 0 : dtTotal.Compute("sum(DolAtAvgCost)/sum(Weight)", "")) + "</td><td nowrap=nowrap>" +
                              iTotal.BranchDolPerLB + "</td><td nowrap=nowrap>" + iTotal.OTWDolPerLB + " </td><td> </td></tr></table>";

                }
            }
            else
            {
                headerContent = "<table border='1' width='700'>";
                headerContent += "<tr><th colspan='9' style='color:blue'>Inventory Branch Item Detail Report</th></tr>";
                headerContent += "<tr><th colspan='1' align='left'>Branch: " + branchDesc + "</th><th colspan=1 align='left'>Period :" + hidPeriod.Value + "</th><th colspan='2'>PkType : " + ddlPkgType.SelectedValue + "</th><th colspan='2'>Run By : " + Session["UserName"].ToString() + "</th><th colspan='3' align='left'>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>";
                
                if (dtTotal.Rows.Count > 0)
                {
                    headerContent += "<tr><th style='width:150px;'>Item</th><th  style='width:200px'>Description</th><th style='width:80px;'>Net Weight</th><th>SVC</th><th style='width:80px;'>CVC</th><th style='width:80px;'>Qty</th><th style='width:80px;'>$@AvgCost</th><th style='width:80px;'>Weight</th><th style='width:80px;'>$/Lb</th></tr>";

                    DataGrid dg = new DataGrid();
                    dg.AutoGenerateColumns = true;
                    dg.ShowHeader = false;
                    dtTotal.Columns.Remove("ThirtyDayUsageQty");
                    dtTotal.Columns.Remove("ThirtyDayUseQtyDolPerAvg");
                    dtTotal.Columns.Remove("MOH");
                    dg.DataSource = dtTotal;
                    dg.DataBind();

                    foreach (DataGridItem i in dg.Items)
                    {
                        //foreach (TableCell tc in i.Cells[1])
                            i.Cells[1].Attributes.Add("class", "text");
                    }
                    System.Text.StringBuilder sb = new System.Text.StringBuilder();
                    System.IO.StringWriter sw = new System.IO.StringWriter(sb);
                    HtmlTextWriter htw = new HtmlTextWriter(sw);
                    dg.RenderControl(htw);

                    string style = @"<style> .text { mso-number-format:\@; } </style> ";
                    Response.Write(style);

                    excelContent = sb.ToString();

                    footerContent = "<table border='1'><tr style='font-weight:bold'><td colspan='5'>Grand Total</td><td>" +
                             String.Format("{0:#,##0}", dtTotal.Compute("sum(Qty)", "")) + "</td><td nowrap=nowrap>" +
                             String.Format("{0:#,##0}", dtTotal.Compute("sum(DolAtAvgCost)", "")) + "</td><td nowrap=nowrap>" +
                             String.Format("{0:#,##0}", dtTotal.Compute("sum(Weight)", "")) + "</td><td>" +
                             String.Format("{0:#,##0.000}", (Convert.ToInt32(dtTotal.Compute("sum(Weight)", "")) == 0) ? 0 : dtTotal.Compute("sum(DolAtAvgCost)/sum(Weight)", "")) + "</td></tr></table>";

                }
            }
            reportWriter.WriteLine(headerContent + excelContent + footerContent );
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

        protected void chkShowUsage_CheckedChanged(object sender, EventArgs e)
        {
            BindDataGrid();
        }
        protected void ddlPkgType_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindDataGrid();
        }
}

}