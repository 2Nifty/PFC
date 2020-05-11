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
    public partial class BranchInventoryOnHandPreview : System.Web.UI.Page
    {
       
        ITotal iTotal = new ITotal();
        private string sortExpression = string.Empty;
        private string showUsage = string.Empty;
        private string pkgType = string.Empty;
        private string period = string.Empty;
        private int pagesize = 18;
        private DataTable dtTotal;
        DataTable dtBranchInventory = new DataTable();


        protected void Page_Load(object sender, EventArgs e)
        {
            pkgType = Request.QueryString["PkgType"].ToString();
            period = Request.QueryString["Period"].ToString();
            lblStatus.Text = "";
            if (!IsPostBack)
            {               
                //
                // Fill The Branches in the Combo
                // 
                BindDataGrid();               
            }            
        
        }

   
       
        public void BindDataGrid()
        {
            try
            {
                dtBranchInventory = iTotal.GetBranchInventoryOnHand(Request.QueryString["Period"].ToString(), pkgType);
               
                if (dtBranchInventory !=null && dtBranchInventory.Rows.Count > 0)
                {

                    sortExpression = ((Request.QueryString["Sort"].ToString() != "") ? Request.QueryString["Sort"].ToString() : "Branch asc");
                    showUsage = Request.QueryString["ShowUsage"].ToString();

                    if (showUsage == "true")
                    {
                        dvBIOnhand.Columns[7].Visible = true;
                        dvBIOnhand.Columns[8].Visible = true;
                        dvBIOnhand.Columns[9].Visible = true;
                        dvBIOnhand.Columns[10].Visible = true;
                        dvBIOnhand.Width = (Unit)900;
                    }
                    else
                    {
                        dvBIOnhand.Columns[7].Visible = false;
                        dvBIOnhand.Columns[8].Visible = false;
                        dvBIOnhand.Columns[9].Visible = false;
                        dvBIOnhand.Columns[10].Visible = false;
                        dvBIOnhand.Width = (Unit)600;
                    }

                    dtBranchInventory.DefaultView.Sort = sortExpression;                   
                    dvBIOnhand.DataSource = dtBranchInventory.DefaultView.ToTable();
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
                e.Row.Cells[7].ColumnSpan = 3;
                e.Row.Cells[7].Text =  "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>30 Day Usage</center></td></tr><tr><td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div >Qty</div></center></td><td width='70' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div >$ @Avg</div></td><td width='70' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div >Weight</div></td></tr></table>";
                e.Row.Cells[8].Visible = false;
                e.Row.Cells[9].Visible = false;
              

            } 
            if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells[0].Text = "Grand Total";                
                 e.Row.Cells[5].Text = iTotal.BranchDolPerLB;
                 e.Row.Cells[6].Text = iTotal.OTWDolPerLB;
                 e.Row.Cells[1].Text = String.Format("{0:#,##0}", dtBranchInventory.Compute("sum(Qty)", ""));
                 e.Row.Cells[2].Text = String.Format("{0:#,##0}", dtBranchInventory.Compute("sum(DolAtAvgCost)", ""));
                 e.Row.Cells[3].Text = String.Format("{0:#,##0}", dtBranchInventory.Compute("sum(Weight)", ""));
                 e.Row.Cells[4].Text = String.Format("{0:#,##0.000}", dtBranchInventory.Compute("sum(DolAtAvgCost)/sum(Weight)", ""));
            }
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                e.Row.Cells[0].Text = e.Row.Cells[0].Text.Trim().Replace("9995", "99");
            }
            
        }
   
      

  
       
}

}