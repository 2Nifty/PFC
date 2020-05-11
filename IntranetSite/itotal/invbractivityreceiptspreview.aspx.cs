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
    public partial class BranchItemDetailPreview : System.Web.UI.Page
    {
        ITotal iTotal = new ITotal();
        //ITotalRef.iTotalTemp iTotalTemp = new ITotalRef.iTotalTemp(); 
        private string sortExpression = string.Empty;
        private string reportType = "Rec";
        DataTable dtTotal = new DataTable();

        protected void Page_Load(object sender, EventArgs e)
        {
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
                //DataSet ds = new DataSet();
                //ds = iTotalTemp.GetInventoryBrActivityDetail(Request.QueryString["Branch"].ToString(),Request.QueryString["Period"].ToString(), reportType);
                //dtTotal = ds.Tables[0];

                dtTotal = iTotal.GetInventoryBrActivityDetail(Request.QueryString["Branch"].ToString(), Request.QueryString["Period"].ToString(), reportType);
      
                if (dtTotal != null && dtTotal.Rows.Count > 0)
                {
                    dtTotal.DefaultView.Sort = Request.QueryString["Sort"].ToString();
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
                e.Row.Cells[4].ColumnSpan = 3;
                e.Row.Cells[4].Text = "<table border='0' cellpadding='0' cellspacing='0' width='100%'  ><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>Average Cost System</center></td></tr><tr><td width='85' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ACWeight');\"><center>Weight</center></div></center></td><td width='76' class='GridHead splitBorders' nowrap align='center' nowrap style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ACValue');\">Value</div></center></td><td width='75' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('AcRecperLb');\">Per Lb</div></td></tr></table>";
                e.Row.Cells[5].Visible = false;
                e.Row.Cells[6].Visible = false;

                e.Row.Cells[7].ColumnSpan = 3;
                e.Row.Cells[7].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr><td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;border-right:solid 0px #c9c6c6;' colspan=3 nowrap ><center>ERP</center></td></tr><tr><td width='88' class='GridHead splitBorders' nowrap  style='cursor:hand;border-right:solid 1px #c9c6c6;'><center>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ERPWeight');\"><center>Weight</center></div></center></td><td width='76' class='GridHead splitBorders' nowrap align='center' nowrap style='cursor:hand;border-right:solid 1px #c9c6c6;'>" +
                                        "<Div style='cursor:hand;' onclick=\"javascript:BindValue('ERPValue');\">Value</div></center></td><td width='75' class='GridHead splitBorders' nowrap align='center' nowrap  style='cursor:hand;border-right:solid 0px #c9c6c6;'>" +
                                        "<Div onclick=\"javascript:BindValue('ERPRecperLb');\">Per Lb</div></td></tr></table>";
                e.Row.Cells[8].Visible = false;
                e.Row.Cells[9].Visible = false;
            }


            if (e.Row.RowType == DataControlRowType.Footer)
            {
                e.Row.Cells[0].Text = "Grand Total";
                e.Row.Cells[1].Text = dtTotal.Rows.Count.ToString();

                decimal _ACValue = Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ACValue)", "")), 2);
                decimal _ACWeight = Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ACWeight)", "")), 2);
                decimal _ERPValue = Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ERPValue)", "")), 2);
                decimal _ERPWeight = Math.Round(Convert.ToDecimal(dtTotal.Compute("sum(ERPWeight)", "")), 2);

                e.Row.Cells[4].Text = String.Format("{0:#,##0.00}", _ACWeight);
                e.Row.Cells[5].Text = String.Format("{0:#,##0.00}", _ACValue);
                e.Row.Cells[6].Text = (_ACWeight.ToString() != "0.00" ? Math.Round((_ACValue / _ACWeight), 3).ToString() : "0.000");

                e.Row.Cells[7].Text = String.Format("{0:#,##0.00}", _ERPWeight);
                e.Row.Cells[8].Text = String.Format("{0:#,##0.00}", _ERPValue);
                e.Row.Cells[9].Text = (_ERPWeight.ToString() != "0.00" ? Math.Round((_ERPValue / _ERPWeight), 3).ToString() : "0.000");
            }       
        }
   
}

}