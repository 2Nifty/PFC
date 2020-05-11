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
using System.Data.SqlClient;
using PFC.SOE.DataAccessLayer;


public partial class PendingOrdersAndQuotes : System.Web.UI.Page
{

    #region Variable Declaration

    CustomerDetail customerDetail = new CustomerDetail();
    PendingOrders pendingOrderAndQuotes = new PendingOrders();
    Common common = new Common();
    Utility utility = new Utility();
    OrderEntry orderEntry = new OrderEntry();
    string invalidMessage = "Invalid Customer Number";
    string noRecordMessage = "No Records Found";
    string successMessage = "Query completed successfully";

    #endregion

    #region Page events

    protected void Page_Load(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        Ajax.Utility.RegisterTypeForAjax(typeof(PendingOrdersAndQuotes));
        if (!IsPostBack)
        {
            ViewState["Action"] = "New";
            ViewState["Mode"] = "Active"; // Display grid without deleted orders
            dtpEndDt.SelectedDate = DateTime.Now.ToShortDateString();
            dtpStartDt.SelectedDate = DateTime.Now.AddDays(-7).ToShortDateString();
            BindLocations();
            BindOrderType();
            BindDataGrid();
            txtCustomerNumber.Focus();
        }
        PrintDialogue1.CustomerNo = txtCustomerNumber.Text;
        PrintDialogue1.PageUrl = hidPrintURL.Value;
       // PrintDialogue1.PageSetup = PrintDialogue.PrinterSetup.Landscape;
        PrintDialogue1.PageTitle = "Pending Orders for customer #" + txtCustomerNumber.Text;

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

    protected void txtCustomerNumber_TextChanged(object sender, EventArgs e)
    {
        if (txtCustomerNumber.Text.Trim() != "")
        {
            string strCustNo = txtCustomerNumber.Text;
            int strCnt = 0;
            bool textIsNumeric = true;
            try
            {
                int.Parse(strCustNo);
            }
            catch
            {
                textIsNumeric = false;
            }
            if ((strCustNo != "") && !textIsNumeric)
            {
                if (isNumeric(strCustNo.Remove(strCustNo.Length - 1, 1), System.Globalization.NumberStyles.Integer) == false)
                    strCnt = Convert.ToInt32(cntCustName(strCustNo));
                else
                    strCnt = Convert.ToInt32(cntCustNo(strCustNo));
                int maxRowCount = customerDetail.GetSQLWarningRowCount();

                if (strCnt < maxRowCount)
                    ScriptManager.RegisterClientScriptBlock(txtCustomerNumber, txtCustomerNumber.GetType(), "Customer", "LoadCustomerLookup('" + PFC.SOE.Securitylayer.Cryptor.Encrypt(strCustNo) + "');", true);
                else
                    ScriptManager.RegisterClientScriptBlock(txtCustomerNumber, txtCustomerNumber.GetType(), "Customer", "alert('Maximum row exceeds for this search.please enter additional data.');", true);
            }
            else
            {
                if (!customerDetail.IsValidCustomer(txtCustomerNumber.Text))
                {
                    utility.DisplayMessage(MessageType.Failure, invalidMessage, lblMessage);
                    hidCustNo.Value = "";
                    txtCustomerNumber.Text = "";
                }
                else
                {
                    hidCustNo.Value = customerDetail.CustomerNumber;
                }
            }

            pnlStatusMessage.Update();
            pnlPendingOrderEntry.Update();
        }
        else
        {
            utility.DisplayMessage(MessageType.Failure, "", lblMessage);
            hidCustNo.Value = "";
        }
        ScriptManager.RegisterClientScriptBlock(txtCustomerNumber, txtCustomerNumber.GetType(), "tab", "document.getElementById(\"ddlOrderType\").focus();", true);
    }

    protected void ibtnSearch_Click(object sender, ImageClickEventArgs e)
    {
        ViewState["Mode"] = "Active";
        hidSort.Value = ""; // initialize sort value to empty

        if (hidCustNo.Value == "")
            if (dtpStartDt.SelectedDate != "" && dtpEndDt.SelectedDate != "")
            {
                if (DateTime.Compare(Convert.ToDateTime(dtpEndDt.SelectedDate), Convert.ToDateTime(dtpStartDt.SelectedDate)) == -1)
                {
                    utility.DisplayMessage(MessageType.Failure, "Invalid Date Range", lblMessage);
                    pnlStatusMessage.Update();
                    return;
                }
            }
        BindDataGrid();

    }

    protected void ibtnCancel_Click(object sender, ImageClickEventArgs e)
    {
        ClearForm();
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
        DataTable dtPendingOrders = pendingOrderAndQuotes.GetPendingOrders(BuildWhereClause());

        if (dtPendingOrders.Rows.Count == 0) // if datatable is empty add new row for display purpose
        {
            DataRow dr = dtPendingOrders.NewRow();
            dtPendingOrders.Rows.Add(dr);

            if (Page.IsPostBack && ViewState["Action"] != "Clear")
            {
                utility.DisplayMessage(MessageType.Failure, noRecordMessage, lblMessage);
                pnlStatusMessage.Update();
            }
        }
        else
        {
            utility.DisplayMessage(MessageType.Success, successMessage, lblMessage);
            pnlStatusMessage.Update();
        }

        dtPendingOrders.DefaultView.Sort = (hidSort.Value == "") ? "OrderNo asc" : hidSort.Value;
        gvPendingOrders.DataSource = dtPendingOrders.DefaultView.ToTable();
        gvPendingOrders.DataBind();


        // Hide Deleted Date Column base on mode
        gvPendingOrders.Columns[10].Visible = (ViewState["Mode"].ToString() == "Active" ? false : true);
        pnlPendingOrderGrid.Update();

        // Create Post url for utility dialog
        hidPrintURL.Value = Server.UrlEncode("PendingOrdersAndQuotesExport.aspx?CustomerNo=" + txtCustomerNumber.Text +
                "&LocDesc=" + (ddlLocation.SelectedIndex != 0 ? ddlLocation.SelectedItem.Text : "") +
                "&loccode=" + (ddlLocation.SelectedIndex != 0 ? ddlLocation.SelectedItem.Value : "") +
                "&OrderTypeDesc=" + (ddlOrderType.SelectedIndex != 0 ? ddlOrderType.SelectedItem.Text : "") +
                "&OrderTypeValue=" + (ddlOrderType.SelectedIndex != 0 ? ddlOrderType.SelectedItem.Value : "") +
                "&UserID=" + ddlUserID.SelectedItem.Value +
                "&UserName=" + ddlUserID.SelectedItem.Text +
                "&StartDate=" + dtpStartDt.SelectedDate +
                "&EndDate=" + dtpEndDt.SelectedDate +
                "&ShowDelRecord=" + ViewState["Mode"].ToString());

    }

    private void BindLocations()
    {
        utility.BindListControls(ddlLocation, "Name", "Branch", common.GetPFCLocations(), "ALL");
        //utility.HighlightDropdownValue(ddlLocation, common.GetUserLoc(Session["UserName"].ToString()));

        if (!common.IsAdminUser(Session["UserName"].ToString()))
            ddlLocation.Enabled = false;
        if (common.GetShowAllUser(Session["UserName"].ToString()) == "Y")        
            utility.BindListControls(ddlUserID, "Name", "Code", common.GetUserList(),"ALL");                    
        else
            utility.BindListControls(ddlUserID, "Name", "Code", common.GetUserList());
        
        utility.HighlightDropdownValue(ddlUserID, Session["UserName"].ToString());
    }

    private void BindOrderType()
    {
        utility.BindListControls(ddlOrderType, "ListDesc", "ListValue", FillDropDownFromListMaster(), "ALL");
    }

    public DataTable FillDropDownFromListMaster()
    {
        try
        {
            string _tableName = "ListMaster LM ,ListDetail LD";
            string _columnName = "(LD.ListValue+' - '+LD.ListdtlDesc) as ListDesc,LD.ListValue ";
            string _whereClause = "LM.ListName = 'soeordertypes' And LD.SequenceNo=99 And LD.fListMasterID = LM.pListMasterID order by ListValue";
            DataSet dsResult = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            return dsResult.Tables[0];

        }
        catch (Exception ex)
        {
            return null;
        }
    }

    private string BuildWhereClause()
    {
        string _whereClause = string.Empty;

        if (hidCustNo.Value != "")
            _whereClause = "(SellToCustNo= '" + hidCustNo.Value + "'";
        else
            _whereClause = "(pSOHeaderID is not null";

        if (ddlUserID.SelectedItem.Text != "ALL" )
            _whereClause += " AND EntryID='" + ddlUserID.SelectedItem.Value + "'";

        if (ddlLocation.SelectedIndex != 0)
            _whereClause += " AND ShipLoc='" + ddlLocation.SelectedValue + "'";

        // Create OrderDt Whereclause
        if (dtpStartDt.SelectedDate != "" && dtpEndDt.SelectedDate != "")
            _whereClause += " AND OrderDt between convert(datetime,'" + dtpStartDt.SelectedDate + "') AND DATEADD(dd,1,convert(datetime,'" + dtpEndDt.SelectedDate + "'))";
        else if (dtpStartDt.SelectedDate != "" && dtpEndDt.SelectedDate == "")
            _whereClause += " AND OrderDt >= convert(datetime,'" + dtpStartDt.SelectedDate + "')";
        else if (dtpStartDt.SelectedDate == "" && dtpEndDt.SelectedDate != "")
            _whereClause += " AND OrderDt <= convert(datetime,'" + dtpEndDt.SelectedDate + "')";
        
        // Add DeleteFlag Whereclause
        if (ViewState["Mode"] == "Active")
            _whereClause += " AND DeleteDt is null";


        if (ddlOrderType.SelectedIndex != 0)
            _whereClause += " AND OrderType='" + ddlOrderType.SelectedValue + "')";
        else
            _whereClause += ") and (Subtype='99' OR MakeOrderDt is null)";


        return _whereClause;
    }

    private void ClearForm()
    {
        ViewState["Action"] = "Clear";
        txtCustomerNumber.Text = "";
        ddlOrderType.SelectedIndex = 0;
        dtpStartDt.SelectedDate = "";
        dtpEndDt.SelectedDate = "";
        BindLocations();
        pnlPendingOrderEntry.Update();
        BindDataGrid();
        pnlPendingOrderGrid.Update();

    }

    private void ExportPendingOrder(string exportMode)
    {
        pnlStatusMessage.Update();
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "ExportPendingOrdersAndQuotes('" + exportMode + "');", true);
    }

    public string cntCustName(string custNo)
    {
        DataTable dtCustomer = new DataTable();
        string tableName = "CustomerMaster";
        string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
        string whereClause = " CustName Like '" + custNo.Trim().Replace("%", "") + "%'";
        DataSet dsCustomer = orderEntry.ExecuteERPSelectQuery(tableName, columnName, whereClause);

        if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
        {
            dtCustomer = dsCustomer.Tables[0];
            return dtCustomer.Rows[0]["totalcount"].ToString();
        }
        else
            return "0";
    }

    public string cntCustNo(string custNo)
    {
        DataTable dtCustomer = new DataTable();
        string tableName = "CustomerMaster";
        string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
        string whereClause = "[CustNo] Like '" + custNo.Trim().Replace("%", "") + "%'";
        DataSet dsCustomer = orderEntry.ExecuteERPSelectQuery(tableName, columnName, whereClause);

        if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
        {
            dtCustomer = dsCustomer.Tables[0];
            return dtCustomer.Rows[0]["totalcount"].ToString();
        }
        else
            return "0";
    }

    public bool isNumeric(string val, System.Globalization.NumberStyles NumberStyle)
    {
        Double result;
        return Double.TryParse(val, NumberStyle,
            System.Globalization.CultureInfo.CurrentCulture, out result);
    }
    #endregion

    protected void imgPrint_Click(object sender, ImageClickEventArgs e)
    {
        ExportPendingOrder("Print");
    }

    protected void ibtnEmail_Click(object sender, ImageClickEventArgs e)
    {
        ExportPendingOrder("Email");
    }
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void ReleaseLock()
    {
        orderEntry.ReleaseLock();
    }
}
