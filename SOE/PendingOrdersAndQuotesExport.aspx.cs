/** 
 * Project Name: SOE
 * 
 * Module Name: Pending Orders & Quotes
 * 
 * Author: Sathishvaran
 *
 * Abstract: Page used to find Print Pending orders in SOE system...
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


public partial class PendingOrdersAndQuotes : System.Web.UI.Page
{

    #region Variable Declaration

    CustomerDetail customerDetail = new CustomerDetail();
    PendingOrders pendingOrderAndQuotes = new PendingOrders();
    Common common = new Common();
    Utility utility = new Utility();

    string invalidMessage = "Invalid Customer Number";
    string noRecordMessage = "No Records Found";
    string userID = "";
    #endregion
    
    #region Page events

    protected void Page_Load(object sender, EventArgs e)
    {       
        if (!IsPostBack)
        {
            lblUserID.Text = Request.QueryString["UserName"].ToString();
            lblCustNo.Text = Request.QueryString["CustomerNo"].ToString();
            lblLocation.Text = Request.QueryString["LocDesc"].ToString();
            hidLocationCode.Value = Request.QueryString["LocCode"].ToString();
            lblOrderType.Text = (Request.QueryString["OrderTypeDesc"].ToString() == "") ? "ALL" : Request.QueryString["OrderTypeDesc"].ToString();
            hidOrderType.Value = Request.QueryString["OrderTypeValue"].ToString();
            lblStartDt.Text = Request.QueryString["StartDate"].ToString();
            lblEndDt.Text = Request.QueryString["EndDate"].ToString();
            userID = Request.QueryString["UserID"].ToString();
            ViewState["Mode"] = Request.QueryString["ShowDelRecord"].ToString();  
            BindDataGrid();
        }
    }

    #endregion

    #region Developer Method

    private void BindDataGrid()
    {
        DataTable dtPendingOrders = pendingOrderAndQuotes.GetPendingOrders(BuildWhereClause());

        if (dtPendingOrders !=null && dtPendingOrders.Rows.Count == 0) // if datatable is empty add new row for display purpose
        {
            DataRow dr = dtPendingOrders.NewRow();
            dtPendingOrders.Rows.Add(dr);            
        }

        dtPendingOrders.DefaultView.Sort = "OrderNo asc";
        gvPendingOrders.DataSource = dtPendingOrders.DefaultView.ToTable();
        gvPendingOrders.DataBind();

        // Hide Deleted Date Column base on mode
        gvPendingOrders.Columns[10].Visible = (ViewState["Mode"].ToString() != "ShowAll" ? false : true);
        
    }

    private string BuildWhereClause()
    {
        string _whereClause = string.Empty;



        if (lblCustNo.Text != "")
            _whereClause = "SellToCustNo= '" + lblCustNo.Text + "'";
        else
            _whereClause = "pSOHeaderID is not null";

        if (userID != "")
            _whereClause += " AND EntryID='" + userID + "'";

        if (hidLocationCode.Value != "")
            _whereClause += " AND ShipLoc='" + hidLocationCode.Value + "'";

        if (hidOrderType.Value != "")
            _whereClause += " AND OrderType='" + hidOrderType.Value + "'";
        else
            _whereClause += " AND SubType='99'";

        // Create OrderDt Whereclause
        if (lblStartDt.Text != "" && lblEndDt.Text != "")
            _whereClause += " AND OrderDt between convert(datetime,'" + lblStartDt.Text + "') AND DATEADD(dd,1,convert(datetime,'" + lblEndDt.Text + "'))";
        else if (lblStartDt.Text != "" && lblEndDt.Text == "")
            _whereClause += " AND OrderDt >= convert(datetime,'" + lblStartDt.Text + "')";
        else if (lblStartDt.Text == "" && lblEndDt.Text != "")
            _whereClause += " AND OrderDt <= convert(datetime,'" + lblEndDt.Text + "')";
        

        // Add DeleteFlag Whereclause
        if (ViewState["Mode"].ToString() != "ShowAll")
            _whereClause += " AND DeleteDt is null";
        
        return _whereClause;
    }

    #endregion

}
