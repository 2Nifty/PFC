/** 
 * Project Name: SOE
 * 
 * Module Name: Pending Orders & Quotes
 * 
 * Author: Sathishvaran
 *
 * Abstract: Page used to find Pending orders in SOE system...
 *
 * Revision History:
 * 
 *  DATE				VERSION			AUTHOR							ACTION
 * <-------------------------------------------------------------------------->			
 *	15 Nov '08			Ver-1			Sathishvaran		            Created
 **/

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
using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.Enums;


public partial class SoldToInformation : System.Web.UI.Page
{

    #region Variable Declaration

    CustomerDetail customerDetail = new CustomerDetail();
    PendingOrders pendingOrderAndQuotes = new PendingOrders();
    Common common = new Common();
    Utility utility = new Utility();

    string SoNumber = "";
    string noRecordMessage = "No Records Found";

    #endregion
    
    #region Page events

    protected void Page_Load(object sender, EventArgs e)
    {
        SoNumber = "1";

        lblMessage.Text = "";
        if (!IsPostBack)
        {
            ViewState["Mode"] = "Active"; // Display grid without deleted orders
            BindDataGrid();
            
        }
    }

    protected void imgExport_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            //hidPrintURL.Value = "PendingOrdersAndQuotesExport.aspx?CustomerNo=" + txtCustomerNumber.Text +
            //    "&LocDesc=" + (ddlLocation.SelectedIndex != 0 ? ddlLocation.SelectedItem.Text : "") +
            //    "&loccode=" + (ddlLocation.SelectedIndex != 0 ? ddlLocation.SelectedItem.Value : "") +
            //    "&OrderTypeDesc=" + (ddlOrderType.SelectedIndex != 0 ? ddlOrderType.SelectedItem.Text : "") +
            //    "&OrderTypeValue=" + (ddlOrderType.SelectedIndex != 0 ? ddlOrderType.SelectedItem.Value : "") +
            //    "&StartDate=" + dtpStartDt.SelectedDate +
            //    "&EndDate=" + dtpEndDt.SelectedDate +
            //    "&ShowDelRecord=" + ViewState["Mode"].ToString();

            //ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "ExportPendingOrdersAndQuotes();", true);
        }
        catch (Exception ex) { }
    }
   
    protected void gvPendingOrders_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Edits")
        {
            string SoHeaderID = e.CommandArgument.ToString();
            ScriptManager.RegisterClientScriptBlock(gvPendingOrders, gvPendingOrders.GetType(), "fillParent", "BindOrderEntryForm('" + SoHeaderID + "');", true);
        }
    }

    protected void gvPendingOrders_Sorting(object sender, GridViewSortEventArgs e)
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
   
    protected void ibtnDeletedItem_Click1(object sender, ImageClickEventArgs e)
    {
        ViewState["Mode"] = "ShowAll"; // Display Grid with deleted orders
        BindDataGrid();
    }

    #endregion

    #region Developer Method

    private void BindDataGrid()
    {
        DataTable dtPendingOrders = new DataTable();

        if (dtPendingOrders.Rows.Count == 0) // if datatable is empty add new row for display purpose
        {
            DataRow dr = dtPendingOrders.NewRow();
            dtPendingOrders.Rows.Add(dr);

            if (Page.IsPostBack)
            {
                utility.DisplayMessage(MessageType.Failure, noRecordMessage, lblMessage);
                pnlStatusMessage.Update();
            }
        }

        dtPendingOrders.DefaultView.Sort = (hidSort.Value == "") ? "OrderNo asc" : hidSort.Value;
        gvPendingOrders.DataSource = dtPendingOrders.DefaultView.ToTable();
        gvPendingOrders.DataBind();

        // Hide Deleted Date Column base on mode
        gvPendingOrders.Columns[10].Visible = (ViewState["Mode"].ToString() == "Active" ? false : true);
        pnlPendingOrderGrid.Update();

    }

    private void FillDefaultAddress()
    {

    }

    #endregion

}
