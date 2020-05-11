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
    public partial class InvByCategoryItemPreview : System.Web.UI.Page
    {
        ITotal iTotal = new ITotal();
        private string sortExpression = string.Empty;
        private string pkgType = string.Empty;
        private string period = string.Empty;
        DataTable dtTotal = new DataTable();

        protected void Page_Load(object sender, EventArgs e)
        {
            lblStatus.Text = "";
            pkgType = Request.QueryString["PkgType"].ToString();
            period = Request.QueryString["Period"].ToString();

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
                // dtTotal = iTotal.GetInventoryByCategoryItem(Request.QueryString["Period"].ToString(), Request.QueryString["Category"].ToString());
                dtTotal = iTotal.GetInventoryByCategoryItem(period, Request.QueryString["Category"].ToString(),pkgType);


                if (dtTotal != null && dtTotal.Rows.Count > 0)
                {
                    dtTotal.DefaultView.Sort = Request.QueryString["Sort"].ToString();
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
                e.Row.Cells[6].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=2 nowrap ><center>30 Day Usage</center></td></tr><tr><td width='70' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' >Qty</div></center></td><td width='70' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div>$ @Avg</div></td></tr></table>";
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
        }
   
}

}