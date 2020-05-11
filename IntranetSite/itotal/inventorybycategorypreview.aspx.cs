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
                dtTotal = iTotal.GetInventoryByCategory(Request.QueryString["Period"].ToString(), pkgType);
                //dtTotal = iTotal.GetInventoryByCategory(Request.QueryString["Period"].ToString());

                if (dtTotal != null && dtTotal.Rows.Count > 0)
                {
                    sortExpression = Request.QueryString["Sort"].ToString();
                    dtTotal.DefaultView.Sort = sortExpression;
                    dvBIOnhand.DataSource = dtTotal.DefaultView.ToTable();
                    dvBIOnhand.DataBind();
                    dvBIOnhand.Visible = true;
                    lblStatus.Visible = false;
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
                e.Row.Cells[4].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='99%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>CarTrans</center></td></tr><tr>" +
                                        "<td width='43' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center><Div style='cursor:hand;' onclick=\"javascript:BindValue('CarTrDol');\">$</div></center></td>" +
                                        "<td width='46' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><Div onclick=\"javascript:BindValue('CarTrLB');\">Lbs</div></td>" +
                                        "<td width='37' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'><Div onclick=\"javascript:BindValue('CarTrDolPerLb');\">$/Lb</div></td>" +
                                        "</tr></table>";
                e.Row.Cells[5].Visible = false;
                e.Row.Cells[6].Visible = false;

                // Intra Trans
                e.Row.Cells[7].ColumnSpan = 3;
                e.Row.Cells[7].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='99%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>IntraTrans</center></td></tr><tr>" +
                                        "<td width='43' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center><Div style='cursor:hand;' onclick=\"javascript:BindValue('IntraTrDol');\">$</div></center></td>" +
                                        "<td width='46' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><Div onclick=\"javascript:BindValue('IntraTrLB');\">Lbs</div></td>" +
                                        "<td width='37' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'><Div onclick=\"javascript:BindValue('IntraTrDolPerLb');\">$/Lb</div></td>" +
                                        "</tr></table>";
                e.Row.Cells[8].Visible = false;
                e.Row.Cells[9].Visible = false;

                // OTW
                e.Row.Cells[10].ColumnSpan = 3;
                e.Row.Cells[10].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='99%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>OTW</center></td></tr><tr>" +
                                        "<td width='43' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center><Div style='cursor:hand;' onclick=\"javascript:BindValue('OTWDol');\">$</div></center></td>" +
                                        "<td width='46' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><Div onclick=\"javascript:BindValue('OTWLB');\">Lbs</div></td>" +
                                        "<td width='37' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'><Div onclick=\"javascript:BindValue('OTWDolPerLb');\">$/Lb</div></td>" +
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
        }
   
}

}