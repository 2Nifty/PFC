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
       // private string sortExpression = string.Empty;
        private string branchID = string.Empty;
        private string branchDesc = string.Empty;
        private int pagesize = 16;
        DataTable dtTotal = new DataTable();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(BranchItemDetail));
            branchID = Request.QueryString["Branch"].ToString();
            branchDesc = Request.QueryString["BranchDesc"].ToString();
            lblMessage.Text = "";

            if (!IsPostBack)
            {
                cldStartDt.SelectedDate = Convert.ToDateTime(Request.QueryString["Period"].ToString());
                cldStartDt.VisibleDate = Convert.ToDateTime(Request.QueryString["Period"].ToString());
                lblBranch.Text = "Branch : "+ branchDesc;
                         
                BindDataGrid();
               
            }

            hidFileName.Value = "BranchActivityDetail_" + Session["SessionID"].ToString() + ".xls";

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
                hidPeriod.Value = cldStartDt.SelectedDate.ToShortDateString(); 

                dtTotal= iTotal.GetInventoryBrActivity(branchID,cldStartDt.SelectedDate.ToShortDateString());


                if (dtTotal != null && dtTotal.Rows.Count > 0)
               {
                   dgBranchActivity.DataSource = dtTotal;
                   dgBranchActivity.DataBind();
                   dgBranchActivity.Visible = true;
                   lblStatus.Visible = false;                  
               }
               else
               {
                   dgBranchActivity.Visible = false;
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

       

        protected void cldStartDt_SelectionChanged(object sender, EventArgs e)
        {
            //BindDataGrid();
        }

        protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
        {
            string strURL = "Period=" + hidPeriod.Value + "&Branch=" + branchID + "&BranchDesc=" + branchDesc; 
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "PrintReport('" + strURL + "');", true);
        }
        



   protected void ibtnRunReport_Click(object sender, ImageClickEventArgs e)
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

            // sortExpression = ((hidSort.Value != "") ? hidSort.Value : "ItemNo asc");            
            dtTotal = iTotal.GetInventoryBrActivity(branchID, hidPeriod.Value);           
            

            headerContent = "<table border='1' width='900'>";
            headerContent += "<tr><th colspan='8' style='color:blue'>Branch Activity Detail Report</th></tr>";
            headerContent += "<tr><th colspan='2' align='left'>Branch: " + branchDesc + "</th><th colspan=2 align='left'>Period :" + hidPeriod.Value + "</th><th colspan='2'>Run By : " + Session["UserName"].ToString() + "</th><th colspan='2' align='left'>Run Date :" + DateTime.Now.ToShortDateString() + "</th></tr>";


            if (dtTotal.Rows.Count > 0)
            {
                headerContent += "<tr><th style='width:150px;'></th><th  style='width:100px'>Qty</th><th style='width:100px'>Cost $</th><th style='width:100px'>Weight" +
                                            " </th><th style='width:100px'>$/Lb</th><th width=200 colspan=3></th></tr>";
                foreach (DataRow roiReader in dtTotal.Rows)
                {
                    excelContent += "<tr><td align='left'><b>Received</b></td><td>" +
                            String.Format("{0:#,##0}", roiReader["ReceiptsQty"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0.00}", roiReader["ReceiptsValue"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["RecWeight"]) + "</td><td>" +
                            String.Format("{0:#,##0.000}", roiReader["RecperLB"]) + "</td><td width=200 colspan=3></td></tr>";
                    excelContent += "<tr><td align='left'><b>Issued</b></td><td>" +
                            String.Format("{0:#,##0}", roiReader["IssuesQty"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0.00}", roiReader["IssuesValue"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["IssWeight"]) + "</td><td>" +
                            String.Format("{0:#,##0.000}", roiReader["IssperLB"]) + "</td><td width=200 colspan=3></td></tr>";
                    excelContent += "<tr><td align='left'><b>Adjusted</b></td><td>" +
                            String.Format("{0:#,##0}", roiReader["AdjQty"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0.00}", roiReader["AdjValue"]) + "</td><td nowrap=nowrap>" +
                            String.Format("{0:#,##0}", roiReader["AdjWeight"]) + "</td><td>" +
                            String.Format("{0:#,##0.000}", roiReader["AdjperLB"]) + "</td><td width=200 colspan=3></td></tr>";

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
       
}

}