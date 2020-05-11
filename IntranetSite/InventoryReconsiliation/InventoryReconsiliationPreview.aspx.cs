#region Namespaces

using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Threading;
using System.IO;
using System.Reflection;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
using PFC.Intranet.InventoryReconsiliation;

#endregion

public partial class InventoryReconsiliation_InventoryReconsiliationPreview : System.Web.UI.Page
{
    #region Global Variables

    private string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    private DataTable dtTotal = new DataTable(); 
    private DataSet dsReconsiliation = new DataSet();
    private string keyColumn = "ItemNo";
    private string sortExpression = string.Empty;
    private string sortColumn = string.Empty;
    string StrLocation = "";
    protected InventoryReconsiliation InventoryReconsiliation = new InventoryReconsiliation();
    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        sortColumn = Request.QueryString["Sort"].ToString();
        if (!IsPostBack)
        {

            StrLocation = Session["DefaultCompanyID"].ToString();
            lblBranch.Text = "Branch: " + Session["DefaultBranchName"].ToString();
            BindDataGrid();
        }
    }

    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        if (sortColumn == "")
            sortExpression = " ORDER BY " + keyColumn;
        else
            sortExpression = " ORDER BY " + sortColumn;
        dsReconsiliation = InventoryReconsiliation.GetRecByLocation(StrLocation, sortExpression);
        dtTotal =  dsReconsiliation.Tables[0].DefaultView.ToTable();
        GetTotal();
        dgReconsiliation.DataSource = dsReconsiliation.Tables[0];
        dgReconsiliation.DataBind();
        lblStatus.Text = "No Records Found";
        lblStatus.Visible = (dgReconsiliation.Items.Count < 1) ? true : false;
    }


    private void GetTotal()
    {
        dtTotal.Clear();
        DataRow drow = dtTotal.NewRow();
        drow["ItemNo"] = "Grand Total";
        drow["ItemDesc"] = "";
        drow["UOM"] = "";
        drow["Qty"] = System.Math.Round(Convert.ToDecimal(dsReconsiliation.Tables[0].Compute("sum(Qty)", "")),0).ToString();
        drow["BookedQty"] = System.Math.Round(Convert.ToDecimal(dsReconsiliation.Tables[0].Compute("sum(BookedQty)", "")),0).ToString();
        drow["Variance"] = 0;
        drow["SuperEquiv"] = "";
        drow["SuperEquivQty"] = System.Math.Round(Convert.ToDecimal(dsReconsiliation.Tables[0].Compute("sum(SuperEquivQty)", "")), 0).ToString();
        dtTotal.Rows.Add(drow);
    }

    
    #endregion

    #region Events

    protected void dgReconsiliation_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Header)
        {

            e.Item.Cells[6].ColumnSpan = 2;
            e.Item.Cells[6].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='100%'><tr>" +
                                "<td class='GridHead splitBorder' style='border-bottom:solid 1px #c9c6c6;' nowrap colspan=2>Super Equivelant</td></tr><tr>" +
                                "<td  class='GridHead splitBorders' style='cursor:hand;border-right:solid 1px #c9c6c6;' width='61px'><center>&nbsp;UOM</center>" +
                                "</td><td  class='GridHead ' nowrap align='center' style='cursor:hand;padding-right: 0px;' >&nbsp;Qty</td></tr></table>";

            e.Item.Cells[7].Visible = false;
        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].Text = dtTotal.Rows[0]["ItemNo"].ToString();
            e.Item.Cells[1].Text = dtTotal.Rows[0]["ItemDesc"].ToString();
            e.Item.Cells[2].Text = dtTotal.Rows[0]["UOM"].ToString();
            e.Item.Cells[3].Text = String.Format("{0:#,##0.00}", dtTotal.Rows[0]["Qty"]);
            e.Item.Cells[4].Text = String.Format("{0:#,##0.00}", dtTotal.Rows[0]["BookedQty"]);
            e.Item.Cells[5].Text = "";
            e.Item.Cells[6].Text = dtTotal.Rows[0]["SuperEquiv"].ToString();
            e.Item.Cells[7].Text = String.Format("{0:#,##0.0}", dtTotal.Rows[0]["SuperEquivQty"]);
        }
    }

   

    #endregion   
   
}
