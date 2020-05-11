/********************************************************************************************
 * File	Name			:	OrderEntry.aspx.cs
 * File Type			:	C#
 * Project Name			:	Sales Order Entry
 * Module Description	:	Crating Sales Order
 * Created By			:	Nithyapriyadarshini.A
 * Created Date			:	15/10/2007	
 * History*				: 
 * DATE					AUTHOR			                ACTION
 * ****					******				            ******
 * 20/10/2007           Mahesh Kumar.S                  Created
 * 30/11/2008           Sathya Ramasamy                 Modified
 *********************************************************************************************/

using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;

using System.Text;
using PFC.SOE;
using PFC.SOE.DataAccessLayer;
using PFC.SOE.UserControls;
using PFC.SOE.BusinessLogicLayer;

public partial class OrderEntryPage : System.Web.UI.Page
{
    #region Variables
    // Create instance for the webservice
    OrderEntry orderEntry = new OrderEntry();
    DataTable dtProduct = new DataTable();
    Common common = new Common();
    SOCommentEntry comments = new SOCommentEntry();
    ExpenseEntry expenseEntry = new ExpenseEntry();
    Utility utility = new Utility();
    // Create Instance for the class cutomer details
    CustomerDetail customerDetail = new CustomerDetail();
    SelectPrintInvoice printInvoice = new SelectPrintInvoice();
    // Added by Slater for Shipper processing
    SelectPrintShipper printShipper = new SelectPrintShipper();
    public string crossReference = string.Empty;

    DataTable dtCarrier = new DataTable();
    DataTable dtFreight = new DataTable();
    string searchText = string.Empty;
    decimal NewPrice = 0;
    //string NewPrice = "";
    decimal totalExtAmount = 0;
    decimal totalExtWgt = 0;
    decimal totalDolperLB = 0;
    bool isValid = true;
    // Get the text box in the user control
    TextBox txtSoNumber;
    string expenseOnlySubType = "52";
    //string order1RType = "RG";
    string PENRGA = "PR";
    string RGASUBTYPE = "53";
    string pendingOrderSubType = "99";
    string itemType = "PFC";
    int pagesize = 10;
    int detailsLineCount = 0;
    #endregion

    #region Property Bag
    public string HeaderIDColumn
    {
        get
        {
            if (Session["OrderTableName"].ToString() == "SOHeader")
                return "fSOHeaderID";
            else if (Session["OrderTableName"].ToString() == "SOHeaderRel")
                return "pSOHeaderRelID";
            else if (Session["OrderTableName"].ToString() == "SOHeaderHist")
                return "pSOHeaderHistID";
            else
                return "fSOHeaderID";
        }
    }

    public string DetailIDColumn
    {
        get
        {
            if (Session["OrderTableName"].ToString() == "SOHeader")
                return "pSODetailID";
            else if (Session["OrderTableName"].ToString() == "SOHeaderRel")
                return "pSODetailRelID";
            else if (Session["OrderTableName"].ToString() == "SOHeaderHist")
                return "pSODetailHistID";
            else
                return "pSODetailID";
        }
    }

    public string SOHeaderTable
    {
        get
        {
            return Session["OrderTableName"].ToString();
        }
    }

    public string CommentIDColumn
    {
        get
        {
            if (Session["OrderTableName"].ToString() == "SOHeader")
                return "fSOHeaderID";
            else if (Session["OrderTableName"].ToString() == "SOHeaderRel")
                return "fSOHeaderRelID";
            else if (Session["OrderTableName"].ToString() == "SOHeaderHist")
                return "fSOHeaderHistID";
            else
                return "fSOHeaderID";
        }
    }
    public string CommentTableName
    {
        get
        {
            if (Session["OrderTableName"].ToString() == "SOHeader")
                return "SOComments";
            else if (Session["OrderTableName"].ToString() == "SOHeaderRel")
                return "SOCommentsRel";
            else if (Session["OrderTableName"].ToString() == "SOHeaderHist")
                return "SOCommentsHist";
            else
                return "SOComments";
        }
    }
    
    #endregion

    #region Page Load
    /// <summary>
    /// Page Load event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        // Register Ajax
        Ajax.Utility.RegisterTypeForAjax(typeof(OrderEntryPage));
        txtSoNumber = CustDet.FindControl("txtSONumber") as TextBox;
        ShowMessage("", false);
        // Call the function to add columns in the datatable
        AddColumn();
         
        if (!IsPostBack)
        {
            Session["PromotionCd"] = "";
            ClearSessionVariable();
            LoadDefaultOrder();
            Session["UserName"] = Request.QueryString["UserName"];
            // Security Code ( SOE(W) or ENTRY(W))
            Session["UserSecurity"] = orderEntry.GetSecurityCode(Session["UserName"].ToString());
            Session["ProductDetails"] = dtProduct;          
            // Code to hide the delete falg columns
            dgNewQuote.Columns[dgNewQuote.Columns.Count - 4].Visible = tdDelete.Visible = false;          
            imgRelease.Visible = false;
            hidisDifferentUser.Value = "";
        }

        BindPrintDialog();

        // Create event trigger when the button clicked on the user control       
        TextBox txtCustNo = CustDet.FindControl("txtCustNo") as TextBox;
        Button btnLoadAll = CustDet.FindControl("btnLoadAll") as Button;

        // Call the event when the user control event is clicked 
        txtCustNo.TextChanged += new EventHandler(txtCustNo_TextChanged);
        btnLoadAll.Click += new EventHandler(btnLoadAll_Click);
        
        // Set focus to command line from PO Number textbox
        LinkButton _lnkShipFrom = ucShipFrom.FindControl("lbtnLink") as LinkButton;
        _lnkShipFrom.Attributes.Add("onkeypress", "javascript:if(event.keyCode==13 && document.getElementById('txtINo1') != null){document.getElementById('txtINo1').focus();}");
    } 
    #endregion

    #region Item Builder event handler
    /// <summary>
    /// UpdateItemLookup Used to update item lookupp
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void UpdateItemLookup(object sender, EventArgs e)
    {

        UCItemLookup.Visible = false;
        UCItemLookup.UpdateValue();

        if (Page.IsPostBack)
        {
            UCItemLookup.Visible = true;
            ControlPanel.Update();
        }
        if (UCItemLookup.Visible)
        {
            //divdatagrid.Style.Add("height", "320px");
            ControlPanel.Update();
            pnlQuoteDetail.Update();
        }
    }

    /// <summary>
    /// ItemControl_OnPackageChange Event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ItemControl_OnPackageChange(object sender, EventArgs e)
    {
       //  ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Resize", "ItembuilderHeight();", true);
    }
    /// <summary>
    /// Event Handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ItemControl_OnChange(object sender, EventArgs e)
    {
        FamilyPanel.Update();
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Resize", "ItembuilderHeight();", true);
    }
    #endregion

    #region Header Control Events
   
    /// <summary>
    /// Header Customer number text change event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void txtCustNo_TextChanged(object sender, EventArgs e)
    {
        try
        {
            ClearUserControls();
            if (Session["CustomerNumber"] != null)
            {
                if (!CustDet.ISBillToCustomer)
                {
                    Session["OrderTableName"] = "SOHeader";
                    Session["DetailTableName"] = "SODetail";
                    Session["LineItemNumber"] = "0";
                    hidLineCount.Value = "0";
                    // Call the function to fill the values in the user control
                    FillUserControls();

                    // Clear the message in the label
                    lblMessage.Text = "";
                    
                    SetSessionVariable();
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Opens", "if(document.getElementById('txtPO') != null){document.getElementById('txtPO').focus();document.getElementById('txtPO').select();}", true);
                }

            }           
        }
        catch (System.Net.WebException ex)
        { }
        catch (System.Web.Services.Protocols.SoapException ex)
        { }
        catch (System.InvalidOperationException ex)
        { }
        catch (Exception ex)
        { }
        // Code to update the panels
        pnlProgress.Update();
        pnlPoDetails.Update();
        pnlSOSummary.Update();
        pnlQuoteDetail.Update();
        pnlLineDtl.Update();
        //ScriptManager.RegisterClientScriptBlock(lblMessage, typeof(Label), "", "document.getElementById('CustDet_txtSONumber').focus();", true);
    }

    /// <summary>
    /// header SoNumber changed event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnLoadAll_Click(object sender, EventArgs e)
    {
        try
        {

            FillUserControls();
            string detailIDColumn = (Session["DetailTableName"].ToString().ToLower().Trim() == "sodetail") ? "a.pSODetailID" : "a.fSODetailID";
            //string whereClause = "DeleteFlag=0 and SalesOrderID=" + CustDet.SOrderNumber + " Order by ID desc";
            string whereClause = ((lblOrdSts.Text == "Deleted") ? "" : " a.DeleteDt is null AND ") + " a.f" + HeaderIDColumn.Remove(0, 1).Trim() + "=" + CustDet.SOOrderID + " Order by " + detailIDColumn + " desc";

            DataSet dtcount = orderEntry.ExecuteERPSelectQuery(Session["DetailTableName"].ToString() + " NOLOCK " , " max(linenumber) ", "f" + HeaderIDColumn.Remove(0, 1).Trim() + "=" + CustDet.SOOrderID);
            if (dtcount != null && dtcount.Tables[0].Rows.Count > 0)
            {
                Session["LineItemNumber"] = (dtcount.Tables[0].Rows[0][0].ToString() == "") ? "0" : dtcount.Tables[0].Rows[0][0].ToString();
               
            }
            else
                Session["LineItemNumber"] = "0";
             

            SetSessionVariable();
            // Code to hide the delete falg columns
            dgNewQuote.Columns[dgNewQuote.Columns.Count - 4].Visible = tdDelete.Visible = false;
            GetQuotes(whereClause);
            BindDataGrid();


            // Code to update the panels
            pnlProgress.Update();
            pnlPoDetails.Update();
            pnlSOSummary.Update();
            pnlQuoteDetail.Update();
            pnlLineDtl.Update();
            if ((CustDet.custNumber != "" && CustDet.SOrderNumber != ""))
            {
                 // Once a order is opened disable below fields
                TextBox _txtCustNo = CustDet.FindControl("txtCustNo") as TextBox;
                TextBox _txtSoNo = CustDet.FindControl("txtSONumber") as TextBox;
                _txtCustNo.ReadOnly = true;
                _txtSoNo.ReadOnly = true;

                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Open", "if(document.getElementById('txtPO') != null){document.getElementById('txtPO').focus();document.getElementById('txtPO').select();}", true);
            }

        }
        catch (Exception ex) { }
    }  

    /// <summary>
    /// Clear Control header control
    /// </summary>
    public void ClearUserControls()
    {
        ucCarrierCode.Text = "";
        ucFreightCode.Text = "";
        ucExpedite.Text = "";
        ucOrderType.Text = "";
        lnkUsageInfo.Text = "";
        ucPriorityCode.Text = "";
        ucReasonCd.Text = "";
        ucShipFrom.Text = "";
        ucCarrierCode.ToolTip = "";
        ucFreightCode.ToolTip = "";
        ucExpedite.ToolTip = "";
        ucOrderType.ToolTip = "";
        lnkUsageInfo.ToolTip = "";
        ucPriorityCode.ToolTip = "";
        ucReasonCd.ToolTip = "";
        ucShipFrom.ToolTip = "";
        txtPO.Text = "";
        dtpReqdShipDate.SelectedDate = "";
        dtqBranchReqDate.SelectedDate = "";
        dtqShdate.SelectedDate = "";
        txtInvDate.Text = "";

        lblTotalWeight.Text = "";
        lblTotGPLb.Text = "";
        lblSales.Text = "";
        lblOrdSts.Text = "";
        lblEntId.Text = "";
        lblChangeID.Text = "";
        dtProduct.Rows.Clear();
        dgNewQuote.DataSource = dtProduct;
        dgNewQuote.DataBind();
    }

    /// <summary>
    /// Code to fill the user controls
    /// </summary>
    public void FillUserControls()
    {
        DataTable dtCustomer = (DataTable)Session["HeaderDetail"];
        DataTable dtLocMaster = Session["LocMaster"] as DataTable;

        ucSODocSort.Text = customerDetail.GetSortDocInd(CustDet.custNumber);
        ucCarrierCode.Text = dtCustomer.Rows[0]["OrderCarrier"].ToString().Trim();
        ucCarrierCode.ToolTip = dtCustomer.Rows[0]["OrderCarName"].ToString().Trim();
        ucFreightCode.Text = dtCustomer.Rows[0]["OrderFreightCd"].ToString().Trim();
        ucFreightCode.ToolTip = dtCustomer.Rows[0]["OrderFreightName"].ToString().Trim();
        ucOrderType.Text = dtCustomer.Rows[0]["OrderType"].ToString().Trim();

        ucOrderType.ToolTip = dtCustomer.Rows[0]["OrderTypeDsc"].ToString().Trim();
        ucPriorityCode.Text = dtCustomer.Rows[0]["OrderPriorityCd"].ToString().Trim();
        ucPriorityCode.ToolTip = dtCustomer.Rows[0]["OrderPriName"].ToString().Trim();
        ucReasonCd.Text = dtCustomer.Rows[0]["ReasonCd"].ToString().Trim();
        ucReasonCd.ToolTip = dtCustomer.Rows[0]["ReasonCdName"].ToString().Trim();
        ucShipFrom.Text = dtCustomer.Rows[0]["ShipLoc"].ToString().Trim();
        ucShipFrom.ToolTip = dtCustomer.Rows[0]["ShipLocName"].ToString().Trim();
        lnkUsageInfo.Text = dtCustomer.Rows[0]["UsageLoc"].ToString().Trim();
        lnkUsageInfo.ToolTip = dtCustomer.Rows[0]["UsageLocName"].ToString().Trim();
        ucExpedite.Text = dtCustomer.Rows[0]["OrderExpdCd"].ToString().Trim();
        ucExpedite.ToolTip = dtCustomer.Rows[0]["OrderExpdCdName"].ToString().Trim();
        ucSODocSort.Text = dtCustomer.Rows[0]["DocumentSortInd"].ToString().Trim();
        Session["SODocSort"] = ucSODocSort.Text.Trim();
        lblRefNo.Text = dtCustomer.Rows[0]["RefSONo"].ToString().Trim();
        CertsReqdCheckBox.Checked = (dtCustomer.Rows[0]["CertRequiredInd"].ToString().Trim() == "1") ? true : false;

        lblEntId.Text = dtCustomer.Rows[0]["EntryID"].ToString().Trim();
        lblChangeID.Text = dtCustomer.Rows[0]["ChangeID"].ToString().Trim();

        lblOrdSts.Text = (dtCustomer.Rows[0]["OrderStatus"].ToString().Trim() == "") ? "SO" : dtCustomer.Rows[0]["OrderStatus"].ToString().Trim();

        txtPO.Text = dtCustomer.Rows[0]["CustPONo"].ToString().Trim();
        dtpReqdShipDate.SelectedDate = (dtCustomer.Rows[0]["CustReqDt"].ToString() == "") ? "" : Convert.ToDateTime(dtCustomer.Rows[0]["CustReqDt"].ToString().Trim()).ToShortDateString();
        dtqBranchReqDate.SelectedDate = (dtCustomer.Rows[0]["BranchReqDt"].ToString().Trim() == "") ? "" : Convert.ToDateTime(dtCustomer.Rows[0]["BranchReqDt"].ToString().Trim()).ToShortDateString();
        dtpReqdShipDate.SelectedDate = ((dtCustomer.Rows[0]["CustReqDt"] != null && dtCustomer.Rows[0]["CustReqDt"].ToString().Trim() != "") ? Convert.ToDateTime(dtCustomer.Rows[0]["CustReqDt"].ToString()).ToShortDateString() : "");
        dtqShdate.SelectedDate = (dtCustomer.Rows[0]["SchShipDt"].ToString() == "" ? "" : Convert.ToDateTime(dtCustomer.Rows[0]["SchShipDt"].ToString().Trim()).ToShortDateString());
        hidShippedDate.Value = dtCustomer.Rows[0]["ShippedDt"].ToString();
        if (dtCustomer.Rows[0]["InvoiceDt"].ToString().Trim() != "")
            txtInvDate.Text = Convert.ToDateTime(dtCustomer.Rows[0]["InvoiceDt"].ToString().Trim()).ToShortDateString();
        lblCapInvDate.Text = "Invoice Date:";

        hidSubType.Value = dtCustomer.Rows[0]["SubType"].ToString();
        hidHoldDt.Value = dtCustomer.Rows[0]["HoldDt"].ToString();

        #region Button logic

        if (SOHeaderTable == "SOHeaderRel")
        {
            imgMO.Visible = false;
            imgRelease.Visible = true;
            imgShowItemBuilder.Visible = false;
            hidIsReadOnly.Value = "true";
        }
        else if (SOHeaderTable == "SOHeader")
        {
            imgMO.Visible = true;
            imgRelease.Visible = false;
            hidIsReadOnly.Value = "false";
        }
        else
        {
            imgMO.Visible = false;
            imgRelease.Visible = false;
            hidIsReadOnly.Value = "true";
        }

        #endregion

        #region Order & Wharehouse status logic

        if (SOHeaderTable == "SOHeader")
        {
            if (dtCustomer.Rows[0]["AllocDt"].ToString() == "" && dtCustomer.Rows[0]["MakeOrderDt"].ToString() != "" && dtCustomer.Rows[0]["AllocRelDt"].ToString() != "")
            {
                lblOrdSts.Text = "Allocating";
                lblWhs.Text = "";

                imgMO.Visible = false;
                imgRelease.Visible = false;
                imgShowItemBuilder.Visible = false;
                hidIsReadOnly.Value = "true";
            }
            else if (dtCustomer.Rows[0]["AllocDt"].ToString() != "" && dtCustomer.Rows[0]["MakeOrderDt"].ToString() != "")
            {
                lblOrdSts.Text = (hidSubType.Value != "99" ? "Released" : "Pending");
                lblWhs.Text = "";

                imgMO.Visible = false;
                imgRelease.Visible = false;
                imgShowItemBuilder.Visible = false;
                hidIsReadOnly.Value = "true";
            }
            else if (dtCustomer.Rows[0]["DeleteDt"].ToString().Trim() != "") // For deleted orders
            {
                lblOrdSts.Text = "Deleted";
                lblWhs.Text = "";
                lblCapInvDate.Text = "Deleted Date:";
                txtInvDate.Text = Convert.ToDateTime(dtCustomer.Rows[0]["DeleteDt"].ToString().Trim()).ToShortDateString();

                imgMO.Visible = false;
                imgRelease.Visible = false;
                imgShowItemBuilder.Visible = false;
                hidIsReadOnly.Value = "true";
            }
            else
            {
                imgRelease.Visible = false;
                imgMO.Visible = true;
                hidIsReadOnly.Value = "false";

                lblOrdSts.Text = (ucOrderType.Text != "TO" ? "SO" : "Transfer");
                lblWhs.Text = "Pending";
            }
        }
        else if (SOHeaderTable == "SOHeaderRel")
        {
            if (dtCustomer.Rows[0]["HoldDt"].ToString() != "") // For HW & HI orders
            {
                lblOrdSts.Text = dtCustomer.Rows[0]["HoldReason"].ToString().Trim() + " " + Convert.ToDateTime(dtCustomer.Rows[0]["HoldDt"].ToString().Trim()).ToShortDateString();

                if (dtCustomer.Rows[0]["HoldReason"].ToString().Trim() == "HW")
                {
                    lblWhs.Text = "On Hold";
                }
                else if (dtCustomer.Rows[0]["HoldReason"].ToString().Trim() == "HI" || dtCustomer.Rows[0]["HoldReason"].ToString().Trim() == "HT")
                {
                    if (dtCustomer.Rows[0]["ConfirmShipDt"].ToString() != "")
                        lblWhs.Text = "Shipped";
                    else if (dtCustomer.Rows[0]["PickCompDt"].ToString() != "")
                        lblWhs.Text = "Picked";
                    else if (dtCustomer.Rows[0]["PickDt"].ToString() != "")
                        lblWhs.Text = "Picking";
                    else if (dtCustomer.Rows[0]["RlsWhseDt"].ToString() != "")
                        lblWhs.Text = "Warehouse";
                    else
                        lblWhs.Text = "Pending";
                }

            }
            else
            {
                if (dtCustomer.Rows[0]["AllocDt"].ToString() == "")
                {
                    lblOrdSts.Text = "Action Req";
                    lblWhs.Text = "";
                }
                if (dtCustomer.Rows[0]["AllocDt"].ToString() == "" && dtCustomer.Rows[0]["MakeOrderDt"].ToString() != "" && dtCustomer.Rows[0]["AllocRelDt"].ToString() != "")
                {
                    lblOrdSts.Text = "Allocating";
                    lblWhs.Text = "";
                }
                if (dtCustomer.Rows[0]["AllocDt"].ToString() != "" && dtCustomer.Rows[0]["MakeOrderDt"].ToString() != "")
                {
                    lblOrdSts.Text = "Allocated";

                    if (dtCustomer.Rows[0]["ConfirmShipDt"].ToString() != "")
                        lblWhs.Text = "Shipped";
                    else if (dtCustomer.Rows[0]["PickCompDt"].ToString() != "")
                        lblWhs.Text = "Picked";
                    else if (dtCustomer.Rows[0]["PickDt"].ToString() != "")
                        lblWhs.Text = "Picking";
                    else if (dtCustomer.Rows[0]["RlsWhseDt"].ToString() != "")
                        lblWhs.Text = "Warehouse";
                    else
                        lblWhs.Text = "Pending";
                }
                if (dtCustomer.Rows[0]["InvoiceDt"].ToString().Trim() != "" || dtCustomer.Rows[0]["DeleteDt"].ToString().Trim() != "") // For invoiced orders
                {
                    lblOrdSts.Text = "Invoiced";
                    lblWhs.Text = (hidSubType.Value == "53" ? "Received" : "Shipped");
                    hidExpenseReadOnly.Value = "true";

                    if (dtCustomer.Rows[0]["DeleteDt"].ToString().Trim() != "") // For deleted orders
                    {
                        lblOrdSts.Text = "Deleted";
                        lblWhs.Text = "";
                        lblCapInvDate.Text = "Deleted Date:";
                        txtInvDate.Text = Convert.ToDateTime(dtCustomer.Rows[0]["DeleteDt"].ToString().Trim()).ToShortDateString();
                    }
                }
            }

            // Button logic for SOHeaderRel table orders
            bool isOrderInAllocation = (dtCustomer.Rows[0]["MakeOrderDt"].ToString() != "" && dtCustomer.Rows[0]["AllocRelDt"].ToString() != "" && dtCustomer.Rows[0]["AllocDt"].ToString() == "");
            if ( isOrderInAllocation || 
                 (dtCustomer.Rows[0]["DeleteDt"].ToString() != "" || 
                 dtCustomer.Rows[0]["InvoiceDt"].ToString() != "" || 
                 dtCustomer.Rows[0]["ConfirmShipDt"].ToString() != ""))
            {
                imgMO.Visible = false;
                imgRelease.Visible = false;
                hidIsReadOnly.Value = "true";
            }
            else if (dtCustomer.Rows[0]["AllocDt"].ToString() != "" &&  dtCustomer.Rows[0]["MakeOrderDt"].ToString() != "" && dtCustomer.Rows[0]["AllocRelDt"].ToString() != "" )
            {
                imgMO.Visible = false;
                imgRelease.Visible = true;
                imgShowItemBuilder.Visible = false;
                hidIsReadOnly.Value = "true";
            }
            else
            {
                imgRelease.Visible = false;
                imgMO.Visible = true;
                hidIsReadOnly.Value = "false";
            }

            // Release Botton logic for RGA order
            if (hidSubType.Value == "53" && (dtCustomer.Rows[0]["HoldReason"].ToString().Trim() == "HI" || dtCustomer.Rows[0]["HoldReason"].ToString().Trim() == "HT" ))
                imgRelease.Visible = false;            

        }
        else // From SOHeaderHist table
        {
            lblOrdSts.Text = "Invoiced";
            lblWhs.Text = (hidSubType.Value == "53" ? "Received" : "Shipped");
            hidExpenseReadOnly.Value = "true";

            if (dtCustomer.Rows[0]["DeleteDt"].ToString() != "")
            {
                lblOrdSts.Text = "Deleted";
                lblWhs.Text = "NA";
                hidExpenseReadOnly.Value = "true";
                lblCapInvDate.Text = "Deleted Date:";
                txtInvDate.Text = Convert.ToDateTime(dtCustomer.Rows[0]["DeleteDt"].ToString().Trim()).ToShortDateString();
            }

            imgShowItemBuilder.Visible = false;
            imgMO.Visible = false;
            imgRelease.Visible = false;
            hidIsReadOnly.Value = "true";
        }

        #endregion

        #region PO & Contact Name Text box logic

        if ((lblOrdSts.Text == "Allocating" || lblOrdSts.Text == "Invoiced" || lblOrdSts.Text == "Deleted") ||
            (lblOrdSts.Text == "Released" && SOHeaderTable.ToLower() == "soheader"))
        {
            LinkButton lnkContactName = CustDet.FindControl("lnkOrderContact") as LinkButton;
            lnkContactName.OnClientClick = "return false;";
            txtPO.ReadOnly = true;
            lnkUsageInfo.ReadOnly = true;
        }

        #endregion

        if (Session["OrderLock"] != null && Session["OrderLock"].ToString() == "L")
        {
            hidIsReadOnly.Value = "true";
            imgMO.Visible = false;
            imgRelease.Visible = false;
        }

        //lblWhs.Text = ((hidSubType.Value == "") || (Convert.ToInt32(hidSubType.Value) > 50)) ? "NA" : lblWhs.Text;

        ibtnDelete.Visible = imgMO.Visible;
        hidCommandLineReadOnly.Value = ((hidSubType.Value == expenseOnlySubType) ? "true" : hidIsReadOnly.Value);
        if (hidisDifferentUser.Value == "true")
        {
            hidisDifferentUser.Value = "";
            InsertUserErrorLog();
        }

        #region Hold Invoice Logic

        if (dtCustomer.Rows[0]["HoldReason"].ToString().Trim() == "HI" || dtCustomer.Rows[0]["HoldReason"].ToString().Trim() == "HT")
        {
            lblOrdSts.Attributes.Add("oncontextmenu", "return false;");
            lblOrdSts.Attributes.Add("onmousedown", "DisplayHoldInvoiceMenu(this.id,event);");
            lblOrdSts.Attributes.Add("style", "cursor:hand;text-decoration:underline;");
            lblOrdSts.ToolTip = "Right click for more options.";
        }
        else
        {
            lblOrdSts.Attributes.Add("oncontextmenu", "return false;");
            lblOrdSts.Attributes.Add("onmousedown", "return false;");
            lblOrdSts.Attributes.Add("style", "cursor:pointer;text-decoration:none;");
            lblOrdSts.ToolTip = "";
        }

        #endregion

        Session["OrderSubType"] = hidSubType.Value;
        Session["OrderType"] = ucOrderType.Text;
        Session["RefSONo"] = lblRefNo.Text;
        SetControlReadOnly();
        Session["ChangeOrderType"] = null;
        if (!(hidSubType.Value == pendingOrderSubType || orderEntry.GetApprefSubType(hidSubType.Value) || hidIsReadOnly.Value == "true" || ucOrderType.ReadOnly))
            Session["ChangeOrderType"] = "true";

        #region PO Required logic

        if (dtCustomer.Rows[0]["CustShipLoc"].ToString() != "")
        {
            DataRow[] drIsPORequired = dtLocMaster.Select("LocID=" + dtCustomer.Rows[0]["CustShipLoc"].ToString());
            if (drIsPORequired != null && drIsPORequired[0]["ReqPOInd"].ToString().Trim() == "N")
            {
                hidPORequired.Value = "false";
            }
        }

        #endregion

        #region Order Type Logics

        if (lblOrdSts.Text.Trim().ToLower() != "deleted")
            lblTOOrderType.Text = ucOrderType.ToolTip;
        else
            lblTOOrderType.Text = "Deleted Order";

        #endregion

        #region Confirm Shipment logic

        int intSubType = Convert.ToInt16(hidSubType.Value);

        if (SOHeaderTable == "SOHeaderRel" && imgRelease.Visible == true && intSubType <= 51)
        {
            DataRow[] dr = dtLocMaster.Select("LocID=" + ucShipFrom.Text);
            //if (dr != null && dr[0]["ShipMethCd"].ToString().Trim() == "ERP" && dtCustomer.Rows[0]["ConfirmShipDt"].ToString() != "")
            if (dr != null && dr[0]["ShipMethCd"].ToString().Trim() == "ERP" && dtCustomer.Rows[0]["ConfirmShipDt"].ToString() == "")
            {
                imgConfirmShpmt.Visible = true;
            }

        }
        #endregion

        #region Split Line Logic

        if (SOHeaderTable.ToLower() == "soheader" && dtCustomer.Rows[0]["MakeOrderDt"].ToString() == "")
            divSplitItem.Style.Add("display", "");
        else
            divSplitItem.Style.Add("display", "none");

        #endregion

        // if subtype is 99 don't display make order button
        if (hidSubType.Value == "99")
            imgMO.Visible = false;

    }

    private void SetControlReadOnly()
    {
        ucCarrierCode.ReadOnly = (hidIsReadOnly.Value == "true");
        ucFreightCode.ReadOnly = (hidIsReadOnly.Value == "true");
        ucOrderType.ReadOnly = (hidIsReadOnly.Value == "true" || Session["OrderTableName"].ToString() == "SOHeaderRel");
        ucReasonCd.ReadOnly = (hidIsReadOnly.Value == "true");
        ucShipFrom.ReadOnly = (hidIsReadOnly.Value == "true" || Session["OrderTableName"].ToString() == "SOHeaderRel");
        //lnkUsageInfo.ReadOnly = (hidIsReadOnly.Value == "true");
        ucPriorityCode.ReadOnly = (hidIsReadOnly.Value == "true");
        ucExpedite.ReadOnly = (hidIsReadOnly.Value == "true");
        ucSODocSort.ReadOnly = (hidIsReadOnly.Value == "true");
        dtpReqdShipDate.ReadOnly = (hidIsReadOnly.Value == "true");
        dtqBranchReqDate.ReadOnly = (hidIsReadOnly.Value == "true");

        dtqShdate.ReadOnly = (hidIsReadOnly.Value == "true");

        if (orderEntry.GetApprefSubType(hidSubType.Value))
            ucOrderType.ReadOnly = true;

        // Comments are not to be underlined until expenses or comments are added
        DataTable dtComment = comments.GetSoComment(CommentIDColumn + "= '" + CustDet.SOOrderID + " ' and DeleteDt is null");
        lnbtnComments.Font.Underline = (dtComment != null && dtComment.Rows.Count > 0);

        lnbtnExpense.Font.Underline = (hidExpenseReadOnly.Value == "true");
        lnbtnExpense.Style.Add(HtmlTextWriterStyle.Cursor, ((hidExpenseReadOnly.Value == "true") ? "default" : "hand"));

        //Expenses are not to be underlined until expenses or comments are added
        DataSet dsExpense = expenseEntry.GetSOExpense(CustDet.SOOrderID);
        lnbtnExpense.Font.Underline = (dsExpense != null && dsExpense.Tables[0].Rows.Count > 0);

        lnkPromoCd.Font.Underline = (Session["PromotionCd"].ToString() != "" ? true : false);
        //if (hidIsReadOnly.Value == "true")
        //{
        //    lblOrdSts.Attributes.Add("oncontextmenu", "return false;");
        //    lblOrdSts.Attributes.Add("onmousedown", "");
        //    lblOrdSts.Attributes.Add("style", "text-decoration:none;");
        //    lblOrdSts.ToolTip = "";
        //}

        SetCommandLineReadOnly();
    }

    protected void btnCheckExpComment_Click(object sender, EventArgs e)
    {
        if (Session["CommentAvailable"] != null)
        {
            lnbtnComments.Font.Underline = (Session["CommentAvailable"].ToString() == "true" ? true : false);
            Session["CommentAvailable"] = null;
        }

        if (Session["ExpenseAvailable"] != null)
        {
            lnbtnExpense.Font.Underline = (Session["ExpenseAvailable"].ToString() == "true" ? true : false);
            Session["ExpenseAvailable"] = null;
        }

        pnlSOSummary.Update();
    }

    protected void btnCheckPromoCode_Click(object sender, EventArgs e)
    {
        lnkPromoCd.Font.Underline = (Session["PromotionCd"].ToString() != "" ? true : false);
    }
    #endregion

    #region Refresh page from Worksheet page
    /// <summary>
    /// Event refresh entry page from worksheet page
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnGrid_Click(object sender, EventArgs e)
    {
        try
        {
            string detailIDColumn = (Session["DetailTableName"].ToString().ToLower().Trim() == "sodetail") ? "a.pSODetailID" : "a.fSODetailID";
            //string whereClause = "DeleteFlag=0 and SalesOrderID=" + CustDet.SOrderNumber + " Order by ID desc";
            string whereClause = " a.DeleteDt is null and  a.f" + HeaderIDColumn.Remove(0, 1).Trim() + "=" + CustDet.SOOrderID + " Order by " + detailIDColumn + " desc";

            DataSet dtcount = orderEntry.ExecuteERPSelectQuery(Session["DetailTableName"].ToString() + " NOLOCK ", " max(linenumber) ", "f" + HeaderIDColumn.Remove(0, 1).Trim() + "=" + CustDet.SOOrderID);
            if (dtcount != null && dtcount.Tables[0].Rows.Count > 0)
            {
                Session["LineItemNumber"] = (dtcount.Tables[0].Rows[0][0].ToString() == "") ? "0" : dtcount.Tables[0].Rows[0][0].ToString();
            }
            else
                Session["LineItemNumber"] = "0";
             
            
            SetSessionVariable();
            txtINo1.Text = "";
            // Code to hide the delete falg columns
            dgNewQuote.Columns[dgNewQuote.Columns.Count - 4].Visible = tdDelete.Visible = false;
            GetQuotes(whereClause);
            BindDataGrid();

            // Code to update the panels
            pnlSOSummary.Update();
            pnlQuoteDetail.Update();
            pnlLineDtl.Update();
            if (hidGridCurControl.Value != "")
            {
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('hidGridCurControl').value='';document.getElementById('" + hidGridCurControl.Value + "').focus();document.getElementById('" + hidGridCurControl.Value + "').select();", true);
            }
            
        }
        catch (Exception ex) { }
    } 
    #endregion

    #region Code to bind the quote details which are selected in the item lookup

    /// <summary>
    /// Event to bind the item selected in the item lookup to the datagrid
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnGetGrid_Click(object sender, EventArgs e)
    {
        try
        {
            UpdateItemLookup(UCItemFamily, new EventArgs());
            GetDataFromDataGridToDataTable();
            dtProduct.Merge((DataTable)Session["dtProductNew"]);
            Session["ProductDetails"] = dtProduct;
            BindDataGrid();
           
            if (dgNewQuote.Items.Count > 1)
            {
                //TextBox txtQty = dgNewQuote.Items[0].Cells[3].Controls[1] as TextBox
                //TextBox txtQty = dgNewQuote.Items[0].Cells[3].Controls[1] as TextBox;
                //txtQty.Focus();
            }
            pnlQuoteDetail.Update();
            FamilyPanel.Update();
        }
        catch (Exception ex) { }
    }

    #endregion

    #region Code to bind the quote detail in the grid

    /// <summary>
    /// AddColumn :Method used to add column to datatable 
    /// </summary>
    private void AddColumn()
    {
        dtProduct.Columns.Add("CustItemNo");
        dtProduct.Columns.Add("QtyOrdered");
        dtProduct.Columns.Add("SellStkQty");
        dtProduct.Columns.Add("SellStkUM");
        dtProduct.Columns.Add("QtyAvail1");
        dtProduct.Columns.Add("ExtendedPrice");
        dtProduct.Columns.Add("AlternateUM");
        dtProduct.Columns.Add("NetUnitPrice");
        dtProduct.Columns.Add("AlternateUMQty");
        dtProduct.Columns.Add("ExtendedNetWght");
        dtProduct.Columns.Add("pSODetailID");
        dtProduct.Columns.Add("ItemDsc");
        dtProduct.Columns.Add("NetWght");

        dtProduct.Columns.Add("Remark");
        dtProduct.Columns.Add("IMLoc");
        dtProduct.Columns.Add("QtyAvailLoc1");
        dtProduct.Columns.Add("DeleteDt");
        dtProduct.Columns.Add("ItemNo");

    }

    /// <summary>
    /// Get the all the data's in the datagrid
    /// </summary>
    public void GetDataFromDataGridToDataTable()
    {
        try
        {
            dtProduct.Rows.Clear();
            foreach (DataGridItem dgItem in dgNewQuote.Items)
            {
                #region Cast the control in the datagrid

                Label lblCustItemNo = dgItem.FindControl("lblCustItem") as Label;
                Label lblPFCItemNo = dgItem.FindControl("lblPFCItemNo") as Label;
                HiddenField hidTotalAvQty = dgItem.FindControl("hidTotAvailableQty") as HiddenField;
                TextBox  txtReqQuantity = dgItem.FindControl("txtQty") as TextBox ;
                //Label txtReqQuantity = dgItem.FindControl("lblReqQty") as Label;
                Label lblBaseUOMQty = dgItem.FindControl("lblBaseUOMQty") as Label;
                Label lblBaseUOM = dgItem.FindControl("lblBaseUOM") as Label;
                HiddenField hidAvailableQty = dgItem.FindControl("hidAvailableQty") as HiddenField;
                Label lblAltUnitPrice = dgItem.FindControl("lblAltUnitPrice") as Label;
                Label lblAltPricUom = dgItem.FindControl("lblAlternateUM") as Label;
                HiddenField hidExtAmount = dgItem.FindControl("hidExtAmount") as HiddenField;
                Label lblAltQtyUOM = dgItem.FindControl("lblSuperEquivalent") as Label;
                HiddenField hidExtWt = dgItem.FindControl("hidExtWt") as HiddenField;
                HiddenField hidGrossWt = dgItem.FindControl("hidGrossWt") as HiddenField;
                HiddenField hidUnitPrice = dgItem.FindControl("hidUnitPrice") as HiddenField;
                Label lblQuote = dgItem.FindControl("lblQuoteNo") as Label;
                Label lblDescription = dgItem.FindControl("lblDescription") as Label;
                Label txtQuoteRemark = dgItem.FindControl("lblQuoteRemark") as Label;
                HiddenField hidLocationCode = dgItem.FindControl("hidLocationCode") as HiddenField;
                HiddenField hidLocationName = dgItem.FindControl("hidLocationName") as HiddenField;
                Label lblDelDate = dgItem.FindControl("lblDelDate") as Label;
                #endregion

                #region Code to add the row to the datatable

                DataRow drProduct = dtProduct.NewRow();
                drProduct["CustItemNo"] = lblCustItemNo.Text;
                drProduct["QtyOrdered"] = txtReqQuantity.Text;
                drProduct["SellStkQty"] = lblBaseUOMQty.Text;
                drProduct["SellStkUM"] = lblBaseUOM.Text;
                drProduct["QtyAvail1"] = hidAvailableQty.Value;
                drProduct["NetUnitPrice"] = lblAltUnitPrice.Text.Split('/')[0].Trim();
                drProduct["AlternateUM"] = lblAltPricUom.Text;
                drProduct["ExtendedPrice"] = Convert.ToString(Convert.ToDecimal(drProduct["NetUnitPrice"]) * Convert.ToDecimal(txtReqQuantity.Text));
                drProduct["AlternateUMQty"] = lblAltQtyUOM.Text;
                drProduct["ExtendedNetWght"] = System.Math.Round(Convert.ToDecimal(hidExtWt.Value), 2);
                drProduct["pSODetailID"] = lblQuote.Text;
                drProduct["ItemDsc"] = lblDescription.Text;
                drProduct["NetWght"] = hidGrossWt.Value;
                
                drProduct["Remark"] = txtQuoteRemark.Text;
                //drProduct["IMLoc"] = hidLocationCode.Value;
                //drProduct["QtyAvailLoc1"] = hidLocationName.Value;
                drProduct["IMLoc"] = hidLocationName.Value;
                drProduct["QtyAvailLoc1"] = hidLocationCode.Value;
                drProduct["ItemNo"] = lblPFCItemNo.Text;
                drProduct["DeleteDt"] = DBNull.Value;
                dtProduct.Rows.Add(drProduct);
                
                #endregion

            }

            // Store the grid details in the session
            Session["ProductDetails"] = dtProduct;

        }
        catch (Exception ex) { }

    }

    /// <summary>
    /// BindDataGrid :Method used to Bind data grid
    /// </summary>
    private void BindDataGrid()
    {
        try
        {
            pnlExport.Update();
            dtProduct = (DataTable)Session["ProductDetails"];
            DataTable dtDetail = dtProduct;
            if (dtDetail != null)
            {
                dtDetail.DefaultView.Sort = hidSort.Value;
                dtDetail.DefaultView.RowFilter = searchText.Trim();
                dtCarrier = customerDetail.GetCarrierList();
                dtFreight = customerDetail.GetFreightList();
                dgNewQuote.DataSource = dtDetail.DefaultView.ToTable();
                if (dtDetail.DefaultView.ToTable().Rows.Count > pagesize)
                {
                    gridPager.InitPager(dgNewQuote, pagesize);
                    gridPager.Visible = true;                   
                }
                else
                {
                    dgNewQuote.DataBind();
                    gridPager.Visible = false;
                }
                dtDetail.DefaultView.RowFilter = "DeleteDt is null";
                hidLineCount.Value = dtDetail.DefaultView.ToTable().Rows.Count.ToString();
                dgNewQuote.Visible = true;
            }
            else
            {
                dgNewQuote.Visible = false;                
            }
            if (Session["OrderHeaderID"] != null)
            {
                string whereClause = HeaderIDColumn + "=" + Session["OrderHeaderID"].ToString();
                DataSet dsHeader = orderEntry.ExecuteERPSelectQuery(Session["OrderTableName"].ToString() + " NOLOCK ", "NetSales,ShipWght,TotalCost", whereClause);

                lblSales.Text = (dsHeader != null && dsHeader.Tables[0].Rows.Count > 0 && dsHeader.Tables[0].Rows[0]["NetSales"].ToString() != "") ? string.Format("{0:###,###,###.00}", Convert.ToDecimal(dsHeader.Tables[0].Rows[0]["NetSales"]), 2) : "0.00";
                lblTotalWeight.Text = (dsHeader != null && dsHeader.Tables[0].Rows.Count > 0 && dsHeader.Tables[0].Rows[0]["ShipWght"].ToString() != "") ? string.Format("{0:###,###,###.00}", Convert.ToDecimal(dsHeader.Tables[0].Rows[0]["ShipWght"])): "0.00";
                lblTotGPLb.Text = (lblTotalWeight.Text == "0.00") ? "0.00" : Math.Round(((Convert.ToDecimal(dsHeader.Tables[0].Rows[0]["NetSales"]) - Convert.ToDecimal(dsHeader.Tables[0].Rows[0]["TotalCost"])) / Convert.ToDecimal(dsHeader.Tables[0].Rows[0]["ShipWght"])), 2).ToString();
            }
            else
            {
                lblSales.Text = "0.00";
                lblTotalWeight.Text = "0.00";
                lblTotGPLb.Text = "0.0";
            }
            string profitStatus=orderEntry.GetProfitStatus(txtSoNumber.Text.ToUpper().Replace("W", ""), Session["OrderTableName"].ToString());
            lblTotGPLb.ForeColor = (profitStatus.ToUpper().Trim() == "PROFIT") ? System.Drawing.Color.Green : System.Drawing.Color.Red;
            pnlPoDetails.Update();
            pnlSOSummary.Update();
            pnlQuoteDetail.Update();
            pnlPager.Update();
           
            if(gridPager.Visible)
                ScriptManager.RegisterClientScriptBlock(dgNewQuote, typeof(DataGrid), "setHeight", "javascript:SetSOEGridHeight();", true);
        }
        catch (Exception ex) { }
    }

    protected void dgNewQuote_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        // hide the check box column in the grid
        e.Item.Cells[0].Style.Add("display", "none");
        e.Item.Cells[18].Style.Add("display", "none");
        e.Item.Cells[14].Style.Add("display", "none");
        // e.Item.Cells[9].Style.Add("display", "none");

        if (detailsLineCount < 20)
        {
            e.Item.Cells[1].CssClass = "locked";
            e.Item.Cells[2].CssClass = "locked";
            e.Item.Cells[3].CssClass = "locked";
        }

        if (hidSubType.Value == RGASUBTYPE)
        {
            e.Item.Cells[6].Style.Add("display", "none");
            e.Item.Cells[7].Style.Add("display", "");
        }
        else
        {
            e.Item.Cells[6].Style.Add("display", "");
            e.Item.Cells[7].Style.Add("display", "none");
        }

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            try
            {
                LinkButton dglnkCarrierCd = e.Item.FindControl("dglnkCarrierCode") as LinkButton;
                LinkButton dglnkFreightCd = e.Item.FindControl("dglnkFreightCode") as LinkButton;
                LinkButton dglnkLocCode = e.Item.FindControl("lblLocCode") as LinkButton;
                Label lblQuote = e.Item.FindControl("lblQuoteNo") as Label;
                Label lblDelDate = e.Item.FindControl("lblDelDate") as Label;
                Label lblCustItemNo = e.Item.FindControl("lblCustItem") as Label;
                Label lblPFCItemNo = e.Item.FindControl("lblPFCItemNo") as Label;
                Label lblAvailQty = e.Item.FindControl("lblAvailQty") as Label;
                TextBox txtReqQuantity = e.Item.FindControl("txtQty") as TextBox;
                Label lblExtAmount = e.Item.FindControl("lblExtAmount") as Label;
                Label lblExtWt = e.Item.FindControl("lblExtWt") as Label;
                HiddenField _lineNo = e.Item.FindControl("hidLineNumber") as HiddenField;
                HiddenField _hidQtyShipped = e.Item.FindControl("hidQtyShipped") as HiddenField;

                
                // Delete menu logic
                if ((lblDelDate.Text == "" && hidIsReadOnly.Value == "false") ||
                    (SOHeaderTable.ToLower() == "soheaderrel" && _hidQtyShipped.Value == "0"))
                {
                    lblCustItemNo.Attributes.Add("onmousedown", "if(document.getElementById('hidRowID').value != '')document.getElementById(document.getElementById('hidRowID').value).style.fontWeight='normal';DeleteQuote('" + _lineNo.Value.Trim() + "','" + lblQuote.Text + "',this.id,event); document.getElementById('" + e.Item.ClientID + "').style.fontWeight='bold';hidRowID.value='" + e.Item.ClientID + "'");
                    lblPFCItemNo.Attributes.Add("onmousedown", "if(document.getElementById('hidRowID').value != '')document.getElementById(document.getElementById('hidRowID').value).style.fontWeight='normal';DeleteQuote('" + _lineNo.Value.Trim() + "','" + lblQuote.Text + "',this.id,event);document.getElementById('" + e.Item.ClientID + "').style.fontWeight='bold';hidRowID.value='" + e.Item.ClientID + "'");                
                }
                else if ((lblDelDate.Text != "" && ibtnDelete.Visible == true) &&
                        (SOHeaderTable.ToLower() == "soheader"))
                {
                    lblCustItemNo.Attributes.Add("onmousedown", "if(document.getElementById('hidRowID').value != '')document.getElementById(document.getElementById('hidRowID').value).style.fontWeight='normal';DeleteQuote('" + _lineNo.Value.Trim() + "','" + lblQuote.Text + "',this.id,event); document.getElementById('" + e.Item.ClientID + "').style.fontWeight='bold';hidRowID.value='" + e.Item.ClientID + "'");
                    lblPFCItemNo.Attributes.Add("onmousedown", "if(document.getElementById('hidRowID').value != '')document.getElementById(document.getElementById('hidRowID').value).style.fontWeight='normal';DeleteQuote('" + _lineNo.Value.Trim() + "','" + lblQuote.Text + "',this.id,event);document.getElementById('" + e.Item.ClientID + "').style.fontWeight='bold';hidRowID.value='" + e.Item.ClientID + "'");                
                    
                    // Just hide Delete Option
                    divDeleteItemMenu.Style.Add("display", "none");
                }

                // line maintenance logic
                if (hidIsReadOnly.Value == "false")
                {
                    // added by slater to set link format
                    lblCustItemNo.Attributes.Add("style", "color: firebrick; text-decoration: underline; cursor:hand;");
                    lblPFCItemNo.Attributes.Add("style", "color: firebrick; text-decoration: underline; cursor:hand;");
                }

                if (lblDelDate.Text == "" && hidIsReadOnly.Value == "false")
                {
                    dglnkCarrierCd.Attributes.Add("onclick", "return OpenGridPopupWindow('" + lblQuote.Text + "','carrier','" + dglnkCarrierCd.ClientID + "');");
                    dglnkFreightCd.Attributes.Add("onclick", "return OpenGridPopupWindow('" + lblQuote.Text + "','freight','" + dglnkFreightCd.ClientID + "');");
                    
                    if(SOHeaderTable.ToLower() == "soheader")                    
                        dglnkLocCode.Attributes.Add("onclick", "return OpenGridPopupWindow('" + lblQuote.Text + "','loccode','" + dglnkLocCode.ClientID + "');");                    

                    // To Open Available Qty
                    if (Convert.ToInt32(lblAvailQty.Text) < Convert.ToInt32(txtReqQuantity.Text))
                    {
                        string script=  "popUp=window.open ('StockStatus.aspx?ItemNo="+ lblPFCItemNo.Text + "','Maximize','height=560,width=1014,scrollbars=no,status=no,top='+((screen.height/2) - (560/2))+',left='+((screen.width/2) - (1014/2))+',resizable=NO','');" +
                                        "popUp.focus();document.getElementById('" + lblAvailQty.ClientID + "').style.textDecoration='underline';";
                        lblAvailQty.Attributes.Add("onclick", script);
                    }
                }                

                totalExtAmount = totalExtAmount + Convert.ToDecimal(lblExtAmount.Text.Replace("$", "").Trim() == "" ? "0" : lblExtAmount.Text.Replace("$", "").Trim());
                totalExtWgt = totalExtWgt + Convert.ToDecimal(lblExtWt.Text);
                HiddenField hidavail = e.Item.FindControl("hidTotAvailableQty") as HiddenField;

                // if Make order is not null make read only textbox
                txtReqQuantity.ReadOnly = (hidIsReadOnly.Value != "false");
                txtSellPrice.ReadOnly = (hidIsReadOnly.Value != "false");
                dglnkCarrierCd.Enabled = (hidIsReadOnly.Value == "false");
            }
            catch (Exception ex)
            {
                throw;
            }

        }
    }

    /// <summary>
    /// dgNewQuote_SortCommand:Sort Command event Handler
    /// </summary>
    /// <param name="source"></param>
    /// <param name="e"></param>
    protected void dgNewQuote_SortCommand(object source, DataGridSortCommandEventArgs e)
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

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgNewQuote.CurrentPageIndex = gridPager.GotoPageNumber;
        BindDataGrid();
    }

    protected void btnGridUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            CommonLink cmLnk = new CommonLink();
            string[] values = hidfSOdetailID.Value.Split('-');
            if (values[0] == "carrier")
                cmLnk = FindControl("ucCarrierCode") as CommonLink;
            else if (values[0] == "freight")
                cmLnk = FindControl("ucFreightCode") as CommonLink;
            else if(values[0] == "loccode")
                cmLnk = FindControl("ucShipFrom") as CommonLink;


            DataSet dsDetail = customerDetail.GetMasterDetails(cmLnk.TableName, cmLnk.ColumnNames, cmLnk.WhereClause);

            if (dsDetail != null)
            {
                dsDetail.Tables[0].DefaultView.RowFilter = ucCarrierCode.TextField + "<>''";
                lstGridContextMenu.DataSource = dsDetail.Tables[0].DefaultView.ToTable();
                lstGridContextMenu.DataTextField = ucCarrierCode.TextField;
                lstGridContextMenu.DataValueField = ucCarrierCode.ValueField;
                lstGridContextMenu.Width = (Unit)150;
                lstGridContextMenu.DataBind();
                ScriptManager.RegisterClientScriptBlock(btnGet, typeof(Button), "", " ShowGridContextMenu();document.getElementById('lstGridContextMenu').focus();", true);

            }
        }
        catch (Exception ex) { }
    }

    protected void lstGridContextMenu_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            bool refreshGrid = false;
            bool isPONumberValid = (hidPORequired.Value == "false" ? true : (txtPO.Text != "" ? true : false));
            if (isPONumberValid)
            {
                string[] controlType = hidfSOdetailID.Value.Split('-');
                string[] values = lstGridContextMenu.SelectedValue.Split('-');
                //string detailIDColumn = (Session["DetailTableName"].ToString().ToLower().Trim() == "sodetail") ? "pSODetailID" : "fSODetailID";

                if (controlType[0] != "loccode")
                {
                    if (controlType[0] == "carrier")
                    {
                        orderEntry.UpdateQuote(Session["DetailTableName"].ToString(), "CarrierCd='" + values[0].Trim() + "'", DetailIDColumn + "='" + controlType[1].Trim() + "'");
                    }
                    else if (controlType[0] == "freight")
                    {
                        orderEntry.UpdateQuote(Session["DetailTableName"].ToString(), "FreightCd='" + lstGridContextMenu.SelectedValue + "'", DetailIDColumn + "='" + controlType[1].Trim() + "'");
                    }
                    refreshGrid = true;
                }
                else // When user change the ship loc in grid
                {
                    
                    DataRow[] itemDetail = GetSODetailByID(controlType[1].Trim());
                    if (itemDetail != null)
                    {
                        string itemNo = itemDetail[0]["ItemNo"].ToString();
                        string Qty = itemDetail[0]["QtyOrdered"].ToString();
                        string newLoc = lstGridContextMenu.SelectedValue;

                        string result = CheckAvailability(itemNo, Qty, newLoc);
                        
                        if (result == "NoStock")
                        {
                            ScriptManager.RegisterClientScriptBlock(lstCommon, typeof(ListBox), "UpdateAvail", "Hide();UpdateLineAvailability('" + controlType[1].Trim() + "','" + lstGridContextMenu.SelectedValue + "','" + Session["AvailableQty"].ToString() + "');", true);
                        }
                        else if (result == "")
                        {
                            string _columnValues = "IMLoc='" + lstGridContextMenu.SelectedValue + "'" +
                                                    ",IMLocName='" + GetBranchName(lstGridContextMenu.SelectedValue) + "'" +
                                                    ",QtyAvail1='" + Session["AvailableQty"].ToString() + "'";
                            orderEntry.UpdateQuote(Session["DetailTableName"].ToString(), _columnValues, DetailIDColumn + "='" + controlType[1].Trim() + "'");
                            refreshGrid = true;
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(lstCommon, typeof(ListBox), "UpdateAvail", "Hide();alert('" + result + "');", true);
                        }
                    }
                }

                if (refreshGrid)
                {
                    string detailIDColumn = (Session["DetailTableName"].ToString().ToLower().Trim() == "sodetail") ? "a.pSODetailID" : "a.fSODetailID";
                    string whereClause = ((lblOrdSts.Text == "Deleted") ? "" : " a.DeleteDt is null AND ") + " a.f" + HeaderIDColumn.Remove(0, 1).Trim() + "=" + CustDet.SOOrderID + " Order by " + detailIDColumn + " desc";
                    GetQuotes(whereClause);
                    BindDataGrid();
                }
            }
            else
                ScriptManager.RegisterClientScriptBlock(lstCommon, typeof(ListBox), "", "Hide();POAlert();", true);
        }
        catch (Exception ex)
        {

            throw;
        }
    }
    /// <summary>
    /// Method to update ship loc in grid line (Case: when Req Qty lesss then avail qty)
    /// </summary>
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void UpdateLocDetail( string pSODetailID,string newLocID, string availQty)
    {
        try
        {
            string _columnValues = "IMLoc='" + newLocID + "'" +
                                    ",IMLocName='" + GetBranchName(newLocID) + "'" +
                                    ",QtyAvail1='" + availQty + "'";

            orderEntry.UpdateQuote(Session["DetailTableName"].ToString(), _columnValues, DetailIDColumn + "=" + pSODetailID);
        }
        catch (Exception)
        {

            throw;
        }
    }
    #endregion

    #region Check Item No And Cross Reference
    /// <summary>
    /// Check Cross reference against Itemno and customer number
    /// </summary>
    /// <param name="itemNo"></param>
    /// <returns></returns>
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string GetCrossreference(string itemNo)
    {
        string status = "";
        // get the data.
        DataSet dsAvail = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEGetItemAlias]",
                    new SqlParameter("@SearchItemNo", itemNo),
                    new SqlParameter("@Organization", Session["CustomerNumber"].ToString().Trim()),
                    new SqlParameter("@PrimaryBranch", Session["ShipFrom"].ToString()),
                    new SqlParameter("@SearchType", "Alias"));

        if (dsAvail.Tables.Count >= 1)
        {
            if (dsAvail.Tables.Count == 1)
            {
                if (dsAvail.Tables[0].Rows.Count > 0)
                {
                    status = "false";
                }
            }
            else
            {
                status = "true";
            }
        }
        return status;

    }

    #endregion

    #region Code to save quotation

    /// <summary>
    /// Event to save the quotation on the button click event
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void imgMakeQuotation_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            bool isPONumberValid = (hidPORequired.Value == "false" ? true : (txtPO.Text != "" ? true : false));
            if (isPONumberValid && hidIsReadOnly.Value == "false" && txtINo1.Text != "" && IsValidOrderLine())
            {
                // Call the function to insert quote details
                SaveQuotation();
                btnGrid_Click(btnGrid, new EventArgs());
                ClearCommandLine();
                txtINo1.Text = "";
                txtCmdShipLoc.Text = "";
                SMOrderEntry.SetFocus("txtINo1");
            }
            else
            {
                if (txtPO.Text == "")
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Opens", "alert('Enter PO Number');if(document.getElementById('txtPO') != null){document.getElementById('txtPO').focus();document.getElementById('txtPO').select();}", true);
                else if (txtINo1.Text.Trim() == "")
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Opens", "alert('Enter Item Number');if(document.getElementById('txtINo1') != null){document.getElementById('txtINo1').focus();document.getElementById('txtPO').select();}", true);
            }
        }
        catch (Exception ex)
        { }
        finally
        {
            hidStartProc.Value = "0"; // To avoid multiple entry when user hit enter key twice in cmd line
        }
        
    }

    /// <summary>
    /// Function to save the quotation
    /// </summary>
    public void SaveQuotation()
    {
        //if (IsValidOrderLine())
        {
            string _tableName = Session["DetailTableName"].ToString();

            string _columnName = "LineExpdCd,LineExpdCdDsc,LineReason,LineReasonDsc,LineNumber, LineSeq, LineType, LinePriceInd, ItemNo, ItemDsc, BinLoc, IMLoc,IMLocName, " +
            "CostInd, PriceCd, LISource, QtyStat, ComPct, ComDol, NetUnitPrice, ListUnitPrice, DiscUnitPrice, DiscPct1, DiscPct2, " +
            "DiscPct3, QtyAvailLoc1, QtyAvail1, QtyAvailLoc2, QtyAvail2, QtyAvailLoc3, QtyAvail3, OrigOrderLineNo, RqstdShipDt, OrigShipDt, " +
            "SuggstdShipDt, OriginalQtyRequested, QtyOrdered, QtyBO, SellStkUM, SellStkFactor, " +
            "UnitCost, UnitCost2,UnitCost3, RepCost, OECost, Remark, CustItemNo, CustItemDsc, EntryDate, EntryID, StatusCd, " +
            "GrossWght, NetWght, ExtendedPrice, ExtendedCost, ExtendedNetWght, ExtendedGrossWght, SellStkQty, AlternateUM, " +
            "AlternateUMQty, QtyStatus, ExcludedFromUsageFlag, AlternatePrice,SuperEquivQty,SuperEquivUM,CarrierCd,FreightCd,UsageLoc,"+
            "OriginalAvailQty, CertRequiredInd";
            string CertRequiredInd = "0";
            if (((CertsReqdCheckBox.Checked) && (hidCertsReqd.Value.Trim() == "1"))
                || (chkItemCert.Checked))
                CertRequiredInd = "1";

            _columnName = (Session["DetailTableName"].ToString() == "SODetail") ? "fSOHeaderID," + _columnName : "fSOHeaderRelID," + _columnName;

            string _columnValues = CustDet.SOOrderID + ",'" + ucExpedite.Text + "','" + ucExpedite.ToolTip + "','" + ucReasonCd.Text + "','" + ucReasonCd.ToolTip + "'," +
                                    "" + Convert.ToString(Convert.ToInt32(Session["LineItemNumber"]) + 10) + "," +
                                    "" + Convert.ToString(Convert.ToInt32(Session["LineItemNumber"]) + 10) + "," +
                                    "'S','" + lblPriceOrgin.Text + "'," +
                                    "'" + txtINo1.Text + "'," +
                                    "'" + lblDesription.Text.Replace("'","''") + "'," +
                                    "'STOCK'," +
                                    "'" + txtCmdShipLoc.Text.Trim() + "'," +
                                    "'" + GetBranchName(txtCmdShipLoc.Text.Trim()) + "'," +
                                    "'" + (ucOrderType.Text.Trim() != "TO" ? Session["CustPriceCode"].ToString() : "A")  + "'," +
                                    "'" + Session["CustPriceCode"].ToString() + "'," +
                                    "'E','',0,0," +
                                    "" + txtUnitPrice.Text.Replace(",", "") + "," +
                                    "" + hidListPrice.Value.Replace(",", "") + "," +
                                    "" + txtUnitPrice.Text.Replace(",", "") + "," +
                                    "0," +
                                    "0,0," +
                                    "'" + txtCmdShipLoc.Text.Trim() + "'," +
                                    "" + txtAvQty.Text + ",'',0,'',0,0," +
                                    "'" + dtqShdate.SelectedDate + "'," +
                                    "'" + dtqShdate.SelectedDate + "'," +
                                    "'" + dtqShdate.SelectedDate + "'," +
                                    "" + hidQtyToSell.Value + "," +
                                    "" + hidQtyToSell.Value + ",0," +
                                    "'" + lblBuom.Text.Split('/')[1].ToString().Trim() + "',1," +
                                    "" + hidAvgCost.Value.Replace(",", "") + "," +
                                    "" + hidStdCost.Value.Replace(",", "") + "," +
                                    "" + hidReplacement.Value.Replace(",", "") + "," +
                                    "" + hidAvgCost.Value.Replace(",", "") + "," +
                                    "" + hidOECost.Value.Replace(",", "") + "," +
                                    "'" + txtQuoteRemark.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + hidCrossref.Value + "'," +
                                    "'" + lblDesription.Text.Replace("'", "''") + "'," +
                                    "'" + DateTime.Today.ToString() + "'," +
                                    "'" + Session["UserName"].ToString() + "',''," +
                                    "" + decimal.Parse(hidWorkItemWeight.Value).ToString() + "," +
                                    "" + decimal.Parse(hidWorkNetWeight.Value).ToString() + "," +
                                    "" + hidTotAmt.Value.Replace(",", "") + "," +
                                    "" + hidTotCost.Value.Replace(",", "") + "," +
                                     "" + hidTotNetWeight.Value.Replace(",", "") + "," +
                                    "" + hidTotWeight.Value.Replace(",", "") + "," +
                                   "" + hidQty.Value.Replace(",", "") + "," +
                                    "'" + lblAltPUOM.Text + "'," +
                                    "" + lblAltQty.Text.Replace(",", "") + "," +
                                    "'" + ((decimal.Parse(hidQtyToSell.Value) > decimal.Parse(txtAvQty.Text)) ? "O" : "") + "'," +
                                    "'" + ((chkExcludeUsage.Checked) ? "1" : "0") + "'," +
                                    "" + txtSellPrice.Text + "," +
                                    "" + lblSupEquiv.Text.Split('/')[0].ToString().Trim() + "," +
                                    "'" + lblSupEquiv.Text.Split('/')[1].ToString().Trim() + "'," +
                                    "'" + ucCarrierCode.Text.Trim() + "'," +
                                    "'" + ucFreightCode.Text.Trim() + "'," +
                                    "'" + lnkUsageInfo.Text.Trim() + "'," +
                                    "'" + txtAvQty.Text + "'," +
                                    "'" + CertRequiredInd + "'";

            if ((hidSubType.Value != RGASUBTYPE) && (ucOrderType.Text.Trim() != PENRGA)) // Update ShipQty only when Order type != RGA, PRGA
            {
                _columnName += ",QtyShipped";
                _columnValues += "," + hidQtyToSell.Value;
            }

            string _quoteID = orderEntry.GetIdentityAfterInsert(_tableName, _columnName, _columnValues);

            SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "[pSOERecomputePriceEntry]",
                                                       new SqlParameter("@orderID", CustDet.SOOrderID),
                                                       new SqlParameter("@line", Convert.ToString(Convert.ToInt32(Session["LineItemNumber"]) + 10)),
                                                       new SqlParameter("@table", (Session["DetailTableName"].ToString() == "SODetail") ? "SOHeader" : "SOHeaderRel"));

            SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "[pSOEExt]",
                                                  new SqlParameter("@orderID", CustDet.SOOrderID),
                                                  new SqlParameter("@line", Convert.ToString(Convert.ToInt32(Session["LineItemNumber"]) + 10)),
                                                  new SqlParameter("@type", "ORDER"),
                                                  new SqlParameter("@table", (Session["DetailTableName"].ToString() == "SODetail") ? "ORDER" : "REL"));
        }
    }

    public bool IsValidOrderLine()
    {
        bool result = true;
        if (ucShipFrom.Text == "")
        {
            ScriptManager.RegisterClientScriptBlock(btnUpdateValue, typeof(Button), "Alert", "alert('Invalid Ship From');", true);
            return false;
        }
        else if (ucCarrierCode.Text == "")
        {
            ScriptManager.RegisterClientScriptBlock(btnUpdateValue, typeof(Button), "Alert", "alert('Invalid Carrier Cd');", true);
            return false;
        }
        else if (ucFreightCode.Text == "")
        {
            ScriptManager.RegisterClientScriptBlock(btnUpdateValue, typeof(Button), "Alert", "alert('Invalid Freight Cd');", true);
            return false;
        }
        return result;
    }

    private string GetBranchName(string branchID)
    {
        try
        {
            string branchName = "";
            DataTable dtLocMaster = Session["LocMaster"] as DataTable;
            if (dtLocMaster != null)
            {
                DataRow[] drBranchName = dtLocMaster.Select("LocID=" + branchID.Trim());
                if (drBranchName != null)
                {
                    branchName = drBranchName[0]["LocName"].ToString();
                }
            }
            return branchName;
        }
        catch (Exception ex)
        {
            return "";
        }
    }

    private DataRow[] GetSODetailByID(string pSODetailId)
    {
        try
        {
            DataRow[] drSODetail = null;
            DataTable _dtProduct = (DataTable)Session["ProductDetails"];
            if (_dtProduct != null)
            {
                drSODetail = _dtProduct.Select("pSODetailID=" + pSODetailId);                
            }
            return drSODetail;
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    #endregion

    #region Show hide item builder

    /// <summary>
    /// Event to show the item builder
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ibtnHide_Click(object sender, ImageClickEventArgs e)
    {
        imgShowItemBuilder.Visible = true;
        ibtnHide.Visible = false;
        UCItemLookup.Visible = false;
        ControlPanel.Update();
       ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Resize", "SetGridHeight('Common');", true);
    }

    /// <summary>
    /// Event to hide the item builder
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void imgShowItemBuilder_Click(object sender, ImageClickEventArgs e)
    {
        imgShowItemBuilder.Visible = false;
        ibtnHide.Visible = true;
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Resize", "SetGridHeight('Common');", true);
    }
    protected void ibtnClear_Click(object sender, ImageClickEventArgs e)
    {
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closePriceSheet", "DoUnload();", true);

        if (txtSoNumber.Text != "" && Session["OrderTableName"] != null)
        {
            if ((hidSubType.Value == pendingOrderSubType || orderEntry.GetApprefSubType(hidSubType.Value) || hidIsReadOnly.Value == "true" || ucOrderType.ReadOnly) || (Session["OrderTableName"].ToString().ToLower().Trim() != "soheader"))
            {
                orderEntry.ReleaseLock();
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Load", "document.location.href=document.location.href;", true);
            }
            else
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Load", "OpenOrderTypeUpdate();", true);
             
        }
        else
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Load", "parent.window.close();", true);

    }
    protected void btnClose_Click(object sender, EventArgs e)
    {
        orderEntry.ReleaseLock();
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Load", "parent.window.close();", true);
    }
    #endregion

    #region Code to update the quote details

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.Read)]
    public void UpdatePONum(string strPO, string strSales)
    {
        try
        {
            
            //if (Session["OrderTableName"].ToString() == "SOHeader")
            //{
                string strColumn = "[CustPONo]='" + strPO.Trim() + "'";
                string strTableName = (Session["OrderTableName"] == null) ? "SoHeader" : Session["OrderTableName"].ToString();
                string strWhere = HeaderIDColumn + "=" + Session["OrderHeaderID"].ToString();
                orderEntry.UpdateQuote(strTableName, strColumn, strWhere);
           //}
        }
        catch (Exception ex) { } 
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.Read)]
    public void UpdateCert(string strCert, string strSales)
    {
        try
        {
            string strColumn = "[CertRequiredInd]='";
            if (strCert.ToUpper() == "TRUE")
            {
                strColumn += "1'";
            }
            else
            {
                strColumn += "0'";
            }
            string strTableName = (Session["OrderTableName"] == null) ? "SoHeader" : Session["OrderTableName"].ToString();
            string strWhere = HeaderIDColumn + "=" + Session["OrderHeaderID"].ToString();
            orderEntry.UpdateQuote(strTableName, strColumn, strWhere);
            //}
        }
        catch (Exception ex) { }
    }

    #endregion

    #region Update ReqQty
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void UpdateItemValue(string soDetailId, string carrierCd, string columnName)
    {
        try
        {
            int soId = Convert.ToInt32(soDetailId);
            string columnValue = columnName + "='" + carrierCd.ToString() + "',Changeid='" + Session["UserName"].ToString() + "',ChangeDate='" + DateTime.Now.ToShortDateString() + "'";
            orderEntry.UpdateQuote(Session["DetailTableName"].ToString(), columnValue, DetailIDColumn + "=" + soId);
        }
        catch (Exception)
        {

            throw;
        }
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdateReqQty(string soDetailId, string quantity, string price,string itemNo,string location,string baseQty,string lineNumber,string qtyShipped,string mode)
    {
        int soId = Convert.ToInt32(soDetailId);
        decimal qty = 0;
        decimal unitPrice = 0;
        if (mode == "QTY")
        {
            try
            {
                qty = Convert.ToDecimal(quantity);
                DataSet dsUpdate = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEUpdLine]",
                       new SqlParameter("@PassedDetTable", Session["DetailTableName"].ToString()),
                       new SqlParameter("@PassedUserID", Session["UserName"].ToString()),
                       new SqlParameter("@SODetailID", soId),
                       new SqlParameter("@NewQty", qty),
                       new SqlParameter("@NewPrice", price));
            }
            catch (Exception)
            {
                char[] QtyArray = quantity.ToUpper().ToCharArray();
                string UOMText = "";
                string Qtytext = "";
                DataTable dt = new DataTable();
                foreach (char c in QtyArray)
                {
                    if (c.Equals('-')) Qtytext += c;
                    if (char.IsDigit(c)) Qtytext += c;
                    if (c.Equals('.')) Qtytext += c;
                    if (char.IsLetter(c)) UOMText += c;
                }
                // get the data.
                try
                {
                    if (Qtytext != "" && UOMText != "")
                    {
                        DataSet dsAvail = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEGetBrAvail]",
                                     new SqlParameter("@SearchItemNo", itemNo),
                                     new SqlParameter("@QtyRequested", Qtytext),
                                     new SqlParameter("@QtyUOM", UOMText),
                                     new SqlParameter("@PrimaryBranch", location));
                        if (dsAvail.Tables.Count >= 1)
                        {
                            if (dsAvail.Tables.Count == 1)
                            {
                                if (dsAvail.Tables[0].Rows.Count > 0)
                                {
                                   
                                    return "Invalid UOM " + UOMText;
                                }
                            }
                            else
                            {
                                dsAvail.Tables[1].DefaultView.RowFilter = "Location='" + location.Trim() + "'";
                                dt = dsAvail.Tables[1].DefaultView.ToTable();
                                qty = Convert.ToDecimal(dsAvail.Tables[2].Rows[0]["QtyToSell"]);                                
                                int UnitQty = int.Parse(baseQty);
 
                                decimal AltQty = (UnitQty) * qty;
                                string columnValue = "QtyOrdered='" + qty.ToString() + "', AlternateUMQty=" + AltQty.ToString() +
                                                     ",Changeid='" + Session["UserName"].ToString() + "',ChangeDate='" + DateTime.Now.ToShortDateString() + "'";

                                if (qtyShipped != "") //If QtyShipped is not NULL move it to OriginalQtyRequested
                                {
                                    orderEntry.UpdateQuote(Session["DetailTableName"].ToString(), "OriginalQtyRequested=" + qtyShipped, DetailIDColumn + "=" + soId);
                                }
                                if ((Session["OrderSubType"].ToString() != RGASUBTYPE) && Session["OrderType"].ToString().Trim() != PENRGA ) // Update ShipQty only when Order type != RGA,PR
                                {
                                    columnValue += ",QtyShipped=" + qty.ToString();
                                }

                                orderEntry.UpdateQuote(Session["DetailTableName"].ToString(), columnValue, DetailIDColumn + "=" + soId);

                                DataSet dsReCompute = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOERecomputePriceEntry]",
                                                       new SqlParameter("@orderID", Session["OrderHeaderID"].ToString()),
                                                       new SqlParameter("@line", lineNumber),
                                                       new SqlParameter("@table", (Session["DetailTableName"].ToString() == "SODetail") ? "SoHeader" : "SOHeaderRel"));
                                
                                DataSet dsUpdate = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEExt]",
                                               new SqlParameter("@orderID", Session["OrderHeaderID"].ToString()),
                                               new SqlParameter("@line", lineNumber),
                                               new SqlParameter("@type", "ORDER"),
                                               new SqlParameter("@table", (Session["DetailTableName"].ToString() == "SODetail") ? "ORDER" : "REL"));
                            }
                        }
                    }
                    else
                        return "Invalid UOM " + UOMText;
                }
                catch (Exception ex)
                {
                    return "Invalid UOM " + UOMText;

                }

            }
        }
        else
        {
            try
            {
                decimal AltQty = 0;
                decimal UnitQty = decimal.Parse(baseQty.Trim());
                decimal NewSellPrice;
                string PriceEntered = price.ToUpper();
                qty = Convert.ToDecimal(quantity);
                unitPrice = Convert.ToDecimal(price);

                UnitQty = int.Parse(baseQty);
                DataSet dsPricedetail = orderEntry.GetProductPriceDetail(Session["OrderHeaderID"].ToString(), itemNo, Session["CustomerNumber"].ToString(), location, Session["OrderTableName"].ToString(), Session["DetailTableName"].ToString(), qty.ToString(), price, "E", Session["CustPriceCode"].ToString());
                if (dsPricedetail != null && dsPricedetail.Tables[1].Rows.Count > 0)
                {
                    AltQty = Convert.ToDecimal(dsPricedetail.Tables[1].Rows[0]["AltUOMQty"]);
                    unitPrice = (AltQty == 0 ? 0 : decimal.Parse(price) * UnitQty / AltQty);
                    AltQty = (UnitQty) * qty;
                    string columnValue = "DiscUnitPrice=" + unitPrice + ",AlternateUMQty=" + AltQty.ToString() +
                                         ",AlternatePrice=" + price + ",LISource='E',NetUnitPrice=" + unitPrice + ",Changeid='" + Session["UserName"].ToString() + "',ChangeDate='" + DateTime.Now.ToShortDateString() + "'";
                    orderEntry.UpdateQuote(Session["DetailTableName"].ToString(), columnValue, DetailIDColumn + "=" + soId);

                    SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "[pSOERecomputePriceEntry]",
                                                       new SqlParameter("@orderID", Session["OrderHeaderID"].ToString()),
                                                       new SqlParameter("@line", lineNumber),
                                                       new SqlParameter("@table", (Session["DetailTableName"].ToString() == "SODetail") ? "SOHeader" : "SOHeaderRel"));

                    SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "[pSOEExt]",
                                   new SqlParameter("@orderID", Session["OrderHeaderID"].ToString()),
                                   new SqlParameter("@line", lineNumber),
                                   new SqlParameter("@type", "ORDER"),
                                   new SqlParameter("@table", (Session["DetailTableName"].ToString() == "SODetail") ? "ORDER" : "REL"));
                }
            }
            catch (Exception)
            {

                return "Invalid Sell Price";
               
            }
        }
        return "";
     
    }

    /// <summary>
    /// Check qty availability command line
    /// </summary>
    /// <param name="itemNo">Item number</param>
    /// <param name="qty">Qty requested</param>
    /// <returns></returns>
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string CheckAvailability(string itemNo, string qty,string shipLoc)
    {
        try
        {
            string status = "";
            char[] QtyArray = qty.Trim().ToCharArray();
            string UOMText = "";
            string Qtytext = "";
            DataTable dt = new DataTable();
            foreach (char c in QtyArray)
            {
                if (c.Equals('-')) Qtytext += c;
                if (char.IsDigit(c)) Qtytext += c;
                if (c.Equals('.')) Qtytext += c;
                if (char.IsLetter(c)) UOMText += c;
            }
            // get the data.
            DataSet dsAvail = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEGetBrAvail]",
                      new SqlParameter("@SearchItemNo", itemNo),
                      new SqlParameter("@QtyRequested", Qtytext),
                      new SqlParameter("@QtyUOM", UOMText),
                      new SqlParameter("@PrimaryBranch", shipLoc.Trim()));
            if (dsAvail.Tables.Count >= 1)
            {
                if (dsAvail.Tables.Count == 1)
                {
                    if (dsAvail.Tables[0].Rows.Count > 0)
                    {
                        status = "Invalid UOM " + UOMText;
                    }
                }
                else
                {
                    dsAvail.Tables[1].DefaultView.RowFilter = "Location='" + shipLoc.Trim() + "'";
                    dt = dsAvail.Tables[1].DefaultView.ToTable();
                    if (Convert.ToDecimal((dt != null && dt.Rows.Count > 0) ? dt.Rows[0]["QOH"].ToString() : "0") < Convert.ToDecimal(dsAvail.Tables[2].Rows[0]["QtyToSell"].ToString()))
                    {
                        status = "NoStock";
                        Session["AvailableQty"] = "0";
                    }
                    else
                    {
                        Session["AvailableQty"] = dt.Rows[0]["QOH"].ToString();
                    }
                }
            }
            return status;
        }
        catch (Exception ex)
        {
            return "";
            throw;
        }

    }

    /// <summary>
    /// Check qty availability grid line
    /// </summary>
    /// <param name="itemNo">Item number</param>
    /// <param name="qty">Qty requested</param>
    /// <param name="loc">Location</param>
    /// <returns></returns>
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string GridCheckAvailability(string itemNo, string qty, string loc)
    {
        string status = "";
        char[] QtyArray = qty.Trim().ToCharArray();
        string UOMText = "";
        string Qtytext = "";
        DataTable dt = new DataTable();
        foreach (char c in QtyArray)
        {
            if (c.Equals('-')) Qtytext += c;
            if (char.IsDigit(c)) Qtytext += c;
            if (c.Equals('.')) Qtytext += c;
            if (char.IsLetter(c)) UOMText += c;
        }
        // get the data.
        DataSet dsAvail = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEGetBrAvail]",
                  new SqlParameter("@SearchItemNo", itemNo),
                  new SqlParameter("@QtyRequested", Qtytext),
                  new SqlParameter("@QtyUOM", UOMText),
                  new SqlParameter("@PrimaryBranch", loc.ToString().Trim()));
        if (dsAvail.Tables.Count >= 1)
        {
            if (dsAvail.Tables.Count == 1)
            {
                if (dsAvail.Tables[0].Rows.Count > 0)
                {
                    status = "Invalid UOM " + UOMText;
                }
            }
            else
            {
                dsAvail.Tables[1].DefaultView.RowFilter = "Location='" + Session["ShipFrom"].ToString() + "'";
                dt = dsAvail.Tables[1].DefaultView.ToTable();
                if (Convert.ToDecimal((dt != null && dt.Rows.Count > 0) ? dt.Rows[0]["QOH"].ToString() : "0") < Convert.ToDecimal(dsAvail.Tables[2].Rows[0]["QtyToSell"].ToString()))
                    status = "NoStock";
            }
        }
        return status;

    }    

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void UpdateDate(string strSO, string dtField, string dtValue, string UserID)
    {
        try
        {
            if (Session["OrderTableName"].ToString() == "SOHeader")
            {
                //string strColumn = "[CustPONo]='" + strPO.Trim() + "'";
                string strTableName = (Session["OrderTableName"] == null) ? "SOHeader" : Session["OrderTableName"].ToString();
                string ColumnValue = "[" + dtField + "]='" + dtValue + "'";
                customerDetail.UpdateHeader(strTableName, ColumnValue + ",ChangeID='" + Session["UserName"].ToString() + "',ChangeDt='" + DateTime.Now.ToShortDateString() + "'", HeaderIDColumn + "=" + Session["OrderHeaderID"].ToString());
            }
        }
        catch (Exception ex) { }

    }

    #endregion 

    #region Code to save the purchase order
    protected void imgRelease_Click(object sender, ImageClickEventArgs e)
    {
        string releaseStatus = string.Empty;
        bool releseFlag = false;
        bool isPONumberValid = (hidPORequired.Value == "false" ? true : (txtPO.Text != "" ? true : false));

        if (isPONumberValid)
        {
            if (hidSubType.Value != RGASUBTYPE)
            {

                releaseStatus = orderEntry.ReleaseOrder(CustDet.SOOrderID, Session["UserName"].ToString());
                if ((releaseStatus == "Delete OK") || (Convert.ToInt32(hidSubType.Value) > 50 && releaseStatus.Trim() == "SO Released"))
                {
                    releseFlag = true;
                }
                else
                {
                    orderEntry.SuspendReleasedOrder(CustDet.SOOrderID, Session["UserName"].ToString());
                    lblMessage.Text = releaseStatus;
                    pnlProgress.Update();
                }
            }
            else
            {
                string result = orderEntry.ReleaseRGAOrder(CustDet.SOOrderID);

                if (result == "1")
                    releaseStatus = "RGA Number is not valid or is already invoiced";
                else if (result == "2")
                    releaseStatus = "Receiving is in process for the RGA";
                else if (result == "0")
                {
                    releseFlag = true;
                    releaseStatus = "";
                }

                lblMessage.Text = releaseStatus;
                pnlProgress.Update();
            }

            if (releseFlag)
            {
                imgRelease.Visible = false;
                imgMO.Visible = true;
                ibtnDelete.Visible = true;
                imgConfirmShpmt.Visible = false;
                CustDet.btnLoadAll_Click(imgRelease, new EventArgs()); // Add by sathish
                btnLoadAll_Click(imgRelease, new EventArgs());
                hidIsReadOnly.Value = "false";
                lblOrdSts.Text = "Action Req";
                hidHoldDt.Value = "";
                lblWhs.Text = "";
                btnGrid_Click(btnGrid, new EventArgs());
                pnlLineDtl.Update();
            }
            else
            {
                imgRelease.Visible = true;
            }
        }
        
    }
    /// <summary>
    /// Event to save the purchase order
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void imgMakeOreder_Click(object sender, ImageClickEventArgs e)
    {
        if ( CheckExpenseLinesCount() || dgNewQuote.Items.Count > 0 || hidSubType.Value == expenseOnlySubType)
        {
            ScriptManager.RegisterClientScriptBlock(imgMakeOreder, imgMakeOreder.GetType(), "CloseWorkSheet", "DoUnload();", true);
            
            if (hidSubType.Value != pendingOrderSubType && hidHoldDt.Value.Trim() == "")
            {
                // Create order
                TextBox txtCustNo = CustDet.FindControl("txtCustNo") as TextBox;

                string creditStatus = orderEntry.GetCreditReview(CustDet.BillToCustomerNumber, CustDet.CreditInd, CustDet.SOOrderID, ((Session["OrderTableName"].ToString() == "SoHeader") ? "Order" : "Rel"));
                bool isPONumberValid = (hidPORequired.Value == "false" ? true : (txtPO.Text != "" ? true : false));
                if (creditStatus.ToUpper() == "OK" && isPONumberValid)
                {
                    string holdCd = hidMOrderType.Value;
                    orderEntry.MakeOrder(CustDet.SOOrderID, Session["UserName"].ToString(), Session["OrderTableName"].ToString(), holdCd);
                    orderEntry.ReleaseLock();
                    if (hidSubType.Value == expenseOnlySubType)
                        InsertErrorLog();
                    ScriptManager.RegisterClientScriptBlock(imgMakeOreder, imgMakeOreder.GetType(), "invalid", "alert('Order updated successfully.');document.location.href=document.location.href;", true);
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(imgMakeOreder, imgMakeOreder.GetType(), "invalid", "alert('" + creditStatus + "');", true);
                }
            }
            else
                ScriptManager.RegisterClientScriptBlock(imgMakeOreder, imgMakeOreder.GetType(), "invalid", "alert('Make order is not available');", true);
        }
        else
            ScriptManager.RegisterClientScriptBlock(imgMakeOreder, imgMakeOreder.GetType(), "invalid", "alert('No line item for this Order.');", true);
        

    }

    protected void btnOrderDelete_Click(object sender, ImageClickEventArgs e)
    {
        if (Session["DeleteReasonCode"] != null)
        {

            customerDetail.UpdateHeader(SOHeaderTable, "DeleteReasonCd='"+Session["DeleteReasonCode"].ToString()+"',DeleteReasonName='"+customerDetail.GetTablesName(Session["DeleteReasonCode"].ToString(),"REAS")+"',DeleteUserID='" + Session["UserName"].ToString() + "',ChangeID='" + Session["UserName"].ToString() + "',ChangeDt='" + DateTime.Now.ToShortDateString() + "'", HeaderIDColumn + "=" + CustDet.SOOrderID);

            SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "pSOEOrderDelete",
                                                     new SqlParameter("@orderID", CustDet.SOOrderID),
                                                     new SqlParameter("@userName", Session["UserName"].ToString()),
                                                     new SqlParameter("@tableName", Session["OrderTableName"].ToString()));
            imgMO.Visible = false;
            ibtnDelete.Visible = false;
            txtPO.ReadOnly = true;
            hidIsReadOnly.Value = "true";
            lblCapInvDate.Text = "Deleted Date:";
            lblOrdSts.Text = "Deleted";
            lblTOOrderType.Text = "Deleted Order";
            txtInvDate.Text = DateTime.Now.ToShortDateString();
            lblChangeID.Text = Session["UserName"].ToString();
            SetControlReadOnly();
            Session["ChangeOrderType"] = null;
            BindDataGrid();
            pnlSOSummary.Update();
            pnlPoDetails.Update();
            pnlQuoteDetail.Update();
        }
    }

    protected void btnRefresh_Click(object sender, ImageClickEventArgs e)
    {
        btnGrid_Click(btnRefresh, new EventArgs());
    }
    #endregion

    #region Grid Search
    /// <summary>
    /// Even to search the
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnSearch_Click(object sender, EventArgs e)
    {

        if (Session["ProductDetails"] != null)
            dtProduct = (DataTable)Session["ProductDetails"];

        if (dtProduct.Rows.Count > 0)
        {
            if (txt_Item.Text.Trim() == "" && txt_SellUnit.Text == "" && txt_FreightCd.Text=="" && txt_CarrierCd.Text == "" && txt_PFCITem.Text == "" && txt_Qty.Text == "" && txt_Desc.Text == "" && txt_BaseUOM.Text == "" && txt_AvQty.Text.Trim() == "" && txt_LocCode.Text == "" && txt_ExtWt.Text == "" && txt_UPrice.Text == "" && txt_Remark.Text == "" && txt_SE.Text == "" && txtDelDate.Text == "")
            {
                //txt_quote.Text=="" &&
                searchText = "";
                BindDataGrid();
                return;
            }
            

            searchText = ((txt_Item.Text.Trim() != "") ? ((searchText.Trim() != "") ? searchText + " And CustItemNo ='" + txt_Item.Text.Trim() + "'" : "CusItemNo='" + txt_Item.Text.Trim() + "'") : searchText);
            searchText = ((txt_PFCITem.Text.Trim() != "") ? ((searchText.Trim() != "") ? searchText + " And ItemNo ='" + txt_PFCITem.Text.Trim() + "'" : "ItemNo='" + txt_PFCITem.Text.Trim() + "'") : searchText);
            searchText = ((txt_Qty.Text != "") ? ((searchText.Trim() != "") ? searchText + " And QtyOrdered='" + txt_Qty.Text.Trim() + "'" : "QtyOrdered='" + txt_Qty.Text.Trim() + "'") : searchText);
            searchText = ((txt_Desc.Text != "") ? ((searchText.Trim() != "") ? searchText + searchText + " And ItemDsc  ='" + txt_Desc.Text + "'" : "ItemDsc  ='" + txt_Desc.Text + "'") : searchText);
            searchText = ((txt_BaseUOM.Text != "") ? ((searchText.Trim() != "") ? " And SellStkQty='" + txt_BaseUOM.Text + "'" : "SellStkQty='" + txt_BaseUOM.Text + "'") : searchText);
            searchText = ((txt_AvQty.Text.Trim() != "") ? ((searchText.Trim() != "") ? searchText + " And QtyAvail1='" + txt_AvQty.Text.Trim() + "'" : "QtyAvail1='" + txt_AvQty.Text.Trim() + "'") : searchText);
            searchText = ((txt_LocCode.Text.Trim() != "") ? ((searchText.Trim() != "") ? searchText + " And QtyAvailLoc1='" + txt_LocCode.Text.Trim() + "'" : "QtyAvailLoc1='" + txt_LocCode.Text + "'") : searchText);
            searchText = ((txt_LocaName.Text != "") ? ((searchText.Trim() != "") ? searchText + " And IMLoc='" + txt_LocaName.Text.Trim() + "'" : "IMLoc='" + txt_LocaName.Text.Trim() + "'") : searchText);
            searchText = ((txt_ExtAmt.Text != "") ? ((searchText.Trim() != "") ? searchText + " And ExtendedPrice='" + txt_ExtAmt.Text.Trim() + "'" : "ExtendedPrice='" + txt_ExtAmt.Text.Trim() + "'") : searchText);
            searchText = ((txt_ExtWt.Text != "") ? ((searchText.Trim() != "") ? searchText + " And ExtendedNetWght='" + txt_ExtWt.Text.Trim() + "'" : "ExtendedNetWght='" + txt_ExtWt.Text.Trim() + "'") : searchText);
            searchText = ((txt_UPrice.Text != "") ? ((searchText.Trim() != "") ? searchText + " And NetUnitPrice='" + txt_UPrice.Text.Trim() + "'" : "NetUnitPrice='" + txt_UPrice.Text.Trim() + "'") : searchText);
            searchText = ((txt_Remark.Text != "") ? ((searchText.Trim() != "") ? searchText + " And Remark='" + txt_Remark.Text.Trim() + "'" : "Remark='" + txt_Remark.Text.Trim() + "'") : searchText);
            searchText = ((txt_SE.Text != "") ? ((searchText.Trim() != "") ? searchText + " And AlternateUMQty='" + txt_SE.Text.Trim() + "'" : "AlternateUMQty='" + txt_SE.Text.Trim() + "'") : searchText);
            searchText = ((txtDelDate.Text != "") ? ((searchText.Trim() != "") ? searchText + " And DeleteDt='" + txtDelDate.Text.Trim() + "'" : "DeleteDt='" + txtDelDate.Text.Trim() + "'") : searchText);
            searchText = ((txt_SellUnit.Text != "") ? ((searchText.Trim() != "") ? searchText + " And AltPricePerUOM='" + txt_SellUnit.Text.Trim() + "'" : "AltPricePerUOM='" + txt_SellUnit.Text.Trim() + "'") : searchText);
            searchText = ((txt_CarrierCd.Text != "") ? ((searchText.Trim() != "") ? searchText + " And CarrierCd='" + txt_CarrierCd.Text.Trim() + "'" : "CarrierCd='" + txt_CarrierCd.Text.Trim() + "'") : searchText);
            searchText = ((txt_FreightCd.Text != "") ? ((searchText.Trim() != "") ? searchText + " And FreightCd='" + txt_FreightCd.Text.Trim() + "'" : "FreightCd='" + txt_FreightCd.Text.Trim() + "'") : searchText);
            
            //searchText = ((txt_quote.Text != "") ? ((searchText.Trim() != "") ? searchText + " And pSODetailID='" + txt_quote.Text.Trim() + "'" : "pSODetailID='" + txt_quote.Text.Trim() + "'") : searchText);

            // Call the datagrid to bind the search details
            BindDataGrid();            
            ScriptManager.RegisterClientScriptBlock(btnSearch, typeof(Button), "", "document.getElementById('tblSearch').style.display='';", true);
        }
        else
        {
            lblMessage.Text = "There is no value that matches the entered search criteria.";
            pnlProgress.Update();
        }
        pnlSearchBar.Update();

        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "setgridwidth", " setTimeout('SetGridHeight(\"Common\")',1000);", true);
    } 
    #endregion
   
    #region Code to set value when the link label is clicked
    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void lstCommon_SelectedIndexChanged(object sender, EventArgs e)
    {
        int NoOfRetry = 0;

        Begin:
        try
        {
            bool isPONumberValid = (hidPORequired.Value == "false" ? true : (txtPO.Text != "" ? true : false));
            if (isPONumberValid)
            {

                CommonLink cmLnk = FindControl(hidCurrentControl.Value) as CommonLink;

                if (cmLnk.ID == "ucOrderType")
                {
                    // For TO orders type
                    // if a order is TO type it can be converted into PTO only
                    if (Session["OrderType"].ToString() == "TO" || Session["OrderType"].ToString() == "PTO")
                    {
                        if (lstCommon.SelectedValue.Split('-')[0].Trim() == "PTO" || lstCommon.SelectedValue.Split('-')[0].Trim() == "TO")
                        {
                            cmLnk.Text = lstCommon.SelectedValue.Split('-')[0].Trim();
                            cmLnk.ToolTip = lstCommon.SelectedItem.Text.Split('-')[1].Trim();
                            UpdateDetail(cmLnk.LinkText, lstCommon.SelectedItem.Value);
                            lblTOOrderType.Text = lstCommon.SelectedItem.Text.Split('-')[1].Trim();
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(lstCommon, typeof(ListBox), "", "Hide();alert(' Only you can convert this order into \"TO\" or \"PTO\" order types.');document.getElementById('" + cmLnk.TxtID + "').focus();document.getElementById('" + cmLnk.TxtID + "').select();", true);
                        }
                    }
                    else
                    {
                        // if customer don't have TO as default ordertype they can't select TO or PTO order type
                        if (lstCommon.SelectedValue.Split('-')[0].Trim() != "PTO" && lstCommon.SelectedValue.Split('-')[0].Trim() != "TO")
                        {
                            cmLnk.Text = lstCommon.SelectedValue.Split('-')[0].Trim();
                            cmLnk.ToolTip = lstCommon.SelectedItem.Text.Split('-')[1].Trim();
                            UpdateDetail(cmLnk.LinkText, lstCommon.SelectedItem.Value);
                            lblTOOrderType.Text = lstCommon.SelectedItem.Text.Split('-')[1].Trim();
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(lstCommon, typeof(ListBox), "invalidOrder", "Hide();alert('You can not convert this order into \"TO\" or \"PTO\" order types.');document.getElementById('" + cmLnk.TxtID + "').focus();document.getElementById('" + cmLnk.TxtID + "').select();", true);
                        }
                    }
                }                
                else
                {
                    cmLnk.Text = lstCommon.SelectedValue;
                    cmLnk.ToolTip = lstCommon.SelectedItem.Text.Split('-')[1].Trim();

                    UpdateDetail(cmLnk.LinkText, lstCommon.SelectedItem.Text);
                    if (cmLnk.ID == "ucCarrierCode" && cmLnk.Text.Trim().ToUpper() == "WC")
                    {
                        ucExpedite.Text = cmLnk.Text;
                        ucExpedite.ToolTip = cmLnk.ToolTip;
                        ucPriorityCode.Text = cmLnk.Text;
                        ucPriorityCode.ToolTip = cmLnk.ToolTip;
                        ucFreightCode.Text = "COL";
                        ucFreightCode.ToolTip = "COL";
                    }
                    else if (cmLnk.ID == "ucShipFrom" && ucOrderType.Text == "TO")
                    {

                        UpdateDetail(lnkUsageInfo.LinkText, lstCommon.SelectedItem.Text);
                        lnkUsageInfo.Text = cmLnk.Text;
                        lnkUsageInfo.ToolTip = cmLnk.ToolTip;
                    }

                }
                //if (cmLnk.ID == "ucCarrierCode" || (cmLnk.ID == "ucOrderType" && (hidSubType.Value == RGASUBTYPE)))
                if (cmLnk.ID == "ucCarrierCode" || cmLnk.ID == "ucOrderType" || cmLnk.ID == "ucFreightCode")
                {
                    string detailIDColumn = (Session["DetailTableName"].ToString().ToLower().Trim() == "sodetail") ? "a.pSODetailID" : "a.fSODetailID";
                    //string whereClause = "DeleteFlag=0 and SalesOrderID=" + CustDet.SOrderNumber + " Order by ID desc";
                    string whereClause = ((lblOrdSts.Text == "Deleted") ? "" : "  a.DeleteDt is null AND ") + " a.f" + HeaderIDColumn.Remove(0, 1).Trim() + "=" + CustDet.SOOrderID + " Order by " + detailIDColumn + " desc";
                    GetQuotes(whereClause);
                    BindDataGrid();
                }
                pnlPoDetails.Update();
                pnlSOSummary.Update();

                hidCurrentControl.Value = "";
                ScriptManager.RegisterClientScriptBlock(lstCommon, typeof(ListBox), "", "Hide();document.getElementById('" + cmLnk.TxtID + "').focus();document.getElementById('" + cmLnk.TxtID + "').select();", true);
            }
            else
                ScriptManager.RegisterClientScriptBlock(lstCommon, typeof(ListBox), "", "Hide();POAlert();", true);
                        
        }
        catch (SqlException ex)
        {
            if (ex.Number == 1205) // For SQL Deadlock              
            {
                int iterationCount = Convert.ToInt32(Session["IterationCount"].ToString());

                if (NoOfRetry < iterationCount)
                {
                    NoOfRetry++;
                    goto Begin;
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(lstCommon, lstCommon.GetType(), "DBUpdateFailed", "alert('Unable to update the sales order. Please try again later.');", true);
                }
            }
            else
            {
                throw;
            }
        }
        catch (Exception ex)
        {

            throw;
        }        
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnGet_Click(object sender, EventArgs e)
    {
        bool usageFromFlag = false;

        CommonLink cmLnk = FindControl(hidCurrentControl.Value) as CommonLink;
        bool isEditable = ((cmLnk.ID == "ucCarrierCode" || cmLnk.ID == "lnkUsageInfo" || cmLnk.ID == "ucFreightCode" || cmLnk.ID == "ucExpedite" || cmLnk.ID == "ucPriorityCode" || cmLnk.ID == "ucReasonCd") && Session["OrderTableName"].ToString() == "SOHeaderRel") ? true : false;

        if (cmLnk.ID == "lnkUsageInfo" || cmLnk.ReadOnly != true) // logic to allow usage loc till invoicing
            usageFromFlag = true;

        bool isPONumberValid = (hidPORequired.Value == "false" ? true : (txtPO.Text != "" ? true : false));
        if (isPONumberValid && ((hidIsReadOnly.Value == "false" && (isEditable || Session["OrderTableName"].ToString() == "SOHeader")) || usageFromFlag == true))
        {

            if (cmLnk.ID != "lnkUsageInfo" && cmLnk.ID != "ucShipFrom")
            {
                if (!cmLnk.ISDefault)
                {
                    DataSet dsDetail = customerDetail.GetMasterDetails(cmLnk.TableName, cmLnk.ColumnNames, cmLnk.WhereClause);

                    if (dsDetail != null)
                    {
                        dsDetail.Tables[0].DefaultView.RowFilter = cmLnk.TextField + "<>''";
                        lstCommon.DataSource = dsDetail.Tables[0].DefaultView.ToTable();
                        lstCommon.DataTextField = cmLnk.TextField;
                        lstCommon.DataValueField = cmLnk.ValueField;
                        lstCommon.DataBind();
                        //if (cmLnk.ID == "ucOrderType")
                        //    lstCommon.Attributes.Add("onchange", "javascript:return ValidateOrrderType();");
                        ScriptManager.RegisterClientScriptBlock(btnGet, typeof(Button), "", "ShowToolTip();document.getElementById('lstCommon').focus();", true);

                    }
                }
                else
                {
                    lstCommon.Items.Clear();
                    string[] dataSource = cmLnk.DataSource.Split(',');
                    for (int count = 0; count < dataSource.Length; count++)
                    {
                        lstCommon.Items.Add(dataSource[count].ToString());
                    }
                    ScriptManager.RegisterClientScriptBlock(btnGet, typeof(Button), "", "ShowToolTip();document.getElementById('lstCommon').focus();", true);
                }
                lstCommon.Width = Unit.Pixel(200);
            }
            else
            {
                DataSet dsTable = new DataSet();
                if (cmLnk.ID == "lnkUsageInfo")
                {
                    dsTable = customerDetail.GetUsageLoc();
                }
                else
                {
                    dsTable = customerDetail.GetLocationDetails();
                }


                lstCommon.DataSource = dsTable;
                lstCommon.DataTextField = "Name";
                lstCommon.DataValueField = "Code";
                lstCommon.DataBind();
                lstCommon.Width = Unit.Pixel(130);

                string _scriptblock = "document.getElementById('divToolTip').style.height='190px'; " +
                                        "document.getElementById('divToolTip').style.width='140px'; " +
                                        "ShowToolTip();document.getElementById('lstCommon').focus();";
                ScriptManager.RegisterClientScriptBlock(btnGet, typeof(Button), "", _scriptblock, true);
            }
            if (cmLnk.ID == "ucSODocSort")
            {
                lstCommon.Width = Unit.Pixel(140);
            }
            if (lstCommon.Items.Count > 8)
            {
                lstCommon.Height = Unit.Pixel(150);
                string _scriptblock = "document.getElementById('divToolTip').style.height='150px';";
                ScriptManager.RegisterClientScriptBlock(btnGet, btnGet.GetType(), "setHeight", _scriptblock, true);
            }
            else
            {
                lstCommon.Height = Unit.Pixel(80);
                string _scriptblock = "document.getElementById('divToolTip').style.height='85px';";
                ScriptManager.RegisterClientScriptBlock(btnGet, btnGet.GetType(), "setHeight", _scriptblock, true);
            }
        }


    }

    protected void btnUpdateValue_Click(object sender, EventArgs e)
    {
        int NoOfRetry = 0;

        Begin:
        try
        {
            bool usageFromFlag = false;

            CommonLink cmLnk = FindControl(hidCurrentControl.Value) as CommonLink;
            bool isEditable = ((cmLnk.ID == "ucCarrierCode" || cmLnk.ID == "lnkUsageInfo" || cmLnk.ID == "ucFreightCode" || cmLnk.ID == "ucExpedite" || cmLnk.ID == "ucPriorityCode" || cmLnk.ID == "ucReasonCd") && Session["OrderTableName"].ToString() == "SOHeaderRel") ? true : false;

            if (cmLnk.ID == "lnkUsageInfo" || cmLnk.ReadOnly != true) // logic to allow usage loc till invoicing
                usageFromFlag = true;

            bool isPONumberValid = (hidPORequired.Value == "false" ? true : (txtPO.Text != "" ? true : false));
            if (isPONumberValid && ((hidIsReadOnly.Value == "false" && (isEditable || Session["OrderTableName"].ToString() == "SOHeader")) || usageFromFlag == true))
            {
                DataSet dsDetail = customerDetail.GetMasterDetails(cmLnk.TableName, cmLnk.ColumnNames, cmLnk.WhereClause);
                if (dsDetail != null && dsDetail.Tables[0].Rows.Count != 0)
                {
                    if (cmLnk.ID == "ucOrderType")
                        dsDetail.Tables[0].DefaultView.RowFilter = "Value ='" + cmLnk.Text.Trim() + "'";
                    else
                        dsDetail.Tables[0].DefaultView.RowFilter = "Code ='" + cmLnk.Text.Trim() + "'";
                    if (dsDetail.Tables[0].DefaultView.ToTable().Rows.Count == 1)
                    {
                        if (cmLnk.ID == "ucOrderType")
                        {
                            cmLnk.Text = dsDetail.Tables[0].DefaultView.ToTable().Rows[0]["Value"].ToString();
                            cmLnk.ToolTip = dsDetail.Tables[0].DefaultView.ToTable().Rows[0]["Name"].ToString().Split('-')[1].Trim();
                            UpdateDetail(cmLnk.LinkText, dsDetail.Tables[0].DefaultView.ToTable().Rows[0]["Code"].ToString());
                            lblTOOrderType.Text = cmLnk.ToolTip;
                        }
                        else
                        {
                            cmLnk.Text = dsDetail.Tables[0].DefaultView.ToTable().Rows[0]["Code"].ToString();
                            cmLnk.ToolTip = dsDetail.Tables[0].DefaultView.ToTable().Rows[0]["Name"].ToString().Split('-')[1].Trim();


                            UpdateDetail(cmLnk.LinkText, dsDetail.Tables[0].DefaultView.ToTable().Rows[0]["Name"].ToString());
                            if (cmLnk.ID == "ucCarrierCode" && cmLnk.Text.Trim().ToUpper() == "WC")
                            {
                                ucExpedite.Text = cmLnk.Text;
                                ucExpedite.ToolTip = cmLnk.ToolTip;
                                ucPriorityCode.Text = cmLnk.Text;
                                ucPriorityCode.ToolTip = cmLnk.ToolTip;
                                ucFreightCode.Text = "COL";
                                ucFreightCode.ToolTip = "COL";
                            }

                        }

                        if (cmLnk.ID == "ucCarrierCode" || cmLnk.ID == "ucOrderType" || cmLnk.ID == "ucFreightCode")
                        {
                            string detailIDColumn = (Session["DetailTableName"].ToString().ToLower().Trim() == "sodetail") ? "a.pSODetailID" : "a.fSODetailID";
                            //string whereClause = "DeleteFlag=0 and SalesOrderID=" + CustDet.SOrderNumber + " Order by ID desc";
                            string whereClause = ((lblOrdSts.Text == "Deleted") ? "" : " a.DeleteDt is null AND") + " a.f" + HeaderIDColumn.Remove(0, 1).Trim() + "=" + CustDet.SOOrderID + " Order by " + detailIDColumn + " desc";

                            //return;
                            GetQuotes(whereClause);
                            BindDataGrid();

                        }
                        lblChangeID.Text = Session["UserName"].ToString();
                        pnlPoDetails.Update();
                        pnlSOSummary.Update();

                        hidCurrentControl.Value = "";
                        ScriptManager.RegisterClientScriptBlock(btnUpdateValue, typeof(Button), "", "document.getElementById('" + cmLnk.TxtID + "').focus();document.getElementById('" + cmLnk.TxtID + "').select();", true);
                    }
                    else
                    {
                        if (cmLnk.ID == "ucCarrierCode" || cmLnk.ID == "ucFreightCode")
                            cmLnk.Text = "";

                        ScriptManager.RegisterClientScriptBlock(btnUpdateValue, typeof(Button), "Alert", "alert('Invalid " + cmLnk.LinkText + "');document.getElementById('" + cmLnk.TxtID + "').value='';document.getElementById('" + cmLnk.TxtID + "').focus();document.getElementById('" + cmLnk.TxtID + "').select();", true);
                    }

                }
            }
        }
        catch (SqlException ex)
        {
            if (ex.Number == 1205) // For SQL Deadlock              
            {
                int iterationCount = Convert.ToInt32(Session["IterationCount"].ToString());

                if (NoOfRetry < iterationCount)
                {
                    NoOfRetry++;
                    goto Begin;
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(btnUpdateValue, btnUpdateValue.GetType(), "btnUpdateFailed", "alert('Unable to update the sales order. Please try again later.');", true);
                }
            }
            else
            {
                throw;
            }
        }
        catch (Exception ex)
        {

            throw;
        }  

    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="lnkText"></param>
    /// <param name="value"></param>
    private void UpdateDetail(string lnkText, string value)
    {
        try
        {
            customerDetail.UpdateHeader(SOHeaderTable, GetControlValue(lnkText, value)+"ChangeID='"+Session["UserName"].ToString() + "',ChangeDt='"+DateTime.Now.ToShortDateString() +"'", HeaderIDColumn+"=" + CustDet.SOOrderID);
        }
        catch (Exception ex)
        {
            throw;
        }

    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="lnkText"></param>
    /// <param name="value"></param>
    /// <returns></returns>
    private string GetControlValue(string lnkText, string value)
    {
        try
        {
            string columnValue = string.Empty;
            string updateColumn = string.Empty;
            string[] values = value.Split('-');
            if (value != "")
            {
                switch (lnkText)
                {
                    case "SO Doc Sort":
                        updateColumn = "[DocumentSortInd ]='" + ucSODocSort.Text + "',";
                        Session["SODocSort"] = ucSODocSort.Text;
                        return updateColumn;
                        break;
                    case "Ship From":
                        updateColumn = "[ShipLoc]='" + values[0].Trim() + "',ShipLocName='" + values[1].Trim() + "',";
                        Session["ShipFrom"] = values[0].Trim();
                        hidShowWorkSheet.Value = ((orderEntry.GetShowWorkSheet(values[0].Trim())) ? "true" : "false");
                        
                        return updateColumn;
                        break;
                    case "Order Type":
                        updateColumn = "[OrderType]='" + values[0].Trim() + "',SubType='" + values[1].Trim() + "',OrderTypeDsc='" + values[2].Trim() + "',";
                        hidSubType.Value = values[1].Trim();
                        Session["OrderSubType"] = hidSubType.Value;
                        Session["OrderType"] = values[0].Trim();
                       
                        if (orderEntry.GetApprefSubType(values[1].Trim()))
                            ucOrderType.ReadOnly = true;
                        if (values[1].ToString().Trim() == expenseOnlySubType)
                        {
                            hidCommandLineReadOnly.Value = "true";
                            SetCommandLineReadOnly();
                            pnlLineDtl.Update();
                        }
                        if (hidSubType.Value != pendingOrderSubType)
                            Session["ChangeOrderType"] = "true";
                        else
                            Session["ChangeOrderType"] = null;
                        
                        // if subtype is 99 don't display make order button
                        if (hidSubType.Value == "99")
                            imgMO.Visible = false;
                        else
                            imgMO.Visible = true;

                        // added by Slater. If the order type has a terms override, update the terms
                        DataSet dsTermsOver = orderEntry.GetOrderTypeTermsOverrides(values[0].Trim(), CustDet.custNumber);
                        if (dsTermsOver != null && dsTermsOver.Tables.Count == 1 && dsTermsOver.Tables[0].Rows.Count > 0)
                        {
                            //we got something so add more stuff to the update command
                            updateColumn = "[OrderTermsCd]='" + dsTermsOver.Tables[0].Rows[0]["TableCd"].ToString().Trim() + "', " + updateColumn;
                            updateColumn = "[OrderTermsName]='" + dsTermsOver.Tables[0].Rows[0]["Dsc"].ToString().Trim() + "', " + updateColumn;
                            ScriptManager.RegisterClientScriptBlock(lstCommon, typeof(ListBox), "newTerm", "document.getElementById('CustDet_lblTermDesc').innerText='" + dsTermsOver.Tables[0].Rows[0]["Dsc"].ToString().Trim() + "';", true);
                        }

                        pnlLineDtl.Update();

                        return updateColumn;
                        break;
                    case "Carrier Cd":
                        if (values[0].Trim().ToUpper() != "WC")
                        {
                            updateColumn = "[OrderCarrier]='" + values[0].Trim() + "',OrderCarName='" + values[1].Trim() + "',";
                            columnValue = "CarrierCd='" + values[0].Trim() + "',Changeid='" + Session["UserName"].ToString() + "',ChangeDate='" + DateTime.Now.ToShortDateString() + "'";
                        }
                        else
                        {
                            updateColumn = "[OrderCarrier]='" + values[0].Trim() + "',OrderCarName='" + values[1].Trim() + "',[OrderExpdCd]='" + values[0].Trim() + "',OrderExpdCdName='" + values[1].Trim() + "',[OrderPriorityCd]='" + values[0].Trim() + "',OrderPriName='" + values[1].Trim() + "',[OrderFreightCd]='" + values[0].Trim() + "',OrderFreightName='" + values[1].Trim() + "',";
                            columnValue = "FreightCd='COL',CarrierCd='" + values[0].Trim() + "',Changeid='" + Session["UserName"].ToString() + "',ChangeDate='" + DateTime.Now.ToShortDateString() + "'";
                        }
                        Session["CarrierCode"] = values[0].Trim();
                        
                        orderEntry.UpdateQuote(Session["DetailTableName"].ToString(), columnValue,"f" + HeaderIDColumn.Remove(0, 1).Trim() + "=" + CustDet.SOOrderID );
                        return updateColumn;
                        break;
                    case "Req'd Ship Date":
                        updateColumn = "[CustReqDt]='" + value + "',";
                        return updateColumn;
                        break;
                    case "Expedite Cd":
                        updateColumn = "[OrderExpdCd]='" + values[0].Trim() + "',OrderExpdCdName='" + values[1].Trim() + "',";
                        return updateColumn;
                        break;
                    case "Priority Cd":
                        updateColumn = "[OrderPriorityCd]='" + values[0].Trim() + "',OrderPriName='" + values[1].Trim().Replace("'","''") + "',";
                        return updateColumn;
                        break;
                    case "Freight Cd":
                        string _freightName = "";
                        string _frightValue = "";
                        if (values.Length == 4)
                        {
                            //_frightValue = values[0].Trim() + " - " + values[1].Trim();
                            //_freightName = values[2].Trim() + " - " + values[3].Trim();

                            _frightValue = values[0] + "-" + values[1];
                            _freightName = values[2] + "-" + values[3];
                        }
                        else
                        {
                            _frightValue = values[0].Trim();
                            _freightName = values[1];
                        }
                        updateColumn = "[OrderFreightCd]='" + _frightValue + "',OrderFreightName='" + _freightName + "',";
                        columnValue = "FreightCd='" + _frightValue + "',Changeid='" + Session["UserName"].ToString() + "',ChangeDate='" + DateTime.Now.ToShortDateString() + "'";
                        orderEntry.UpdateQuote(Session["DetailTableName"].ToString(), columnValue, "f" + HeaderIDColumn.Remove(0, 1).Trim() + "=" + CustDet.SOOrderID);
                        Session["FreightCode"] = _frightValue;
                        return updateColumn;
                        break;                   
                    case "Reason Cd":
                        updateColumn = "[ReasonCd]='" + values[0].Trim() + "',ReasonCdName='" + values[1].Trim() + "',";
                        //string detailColumn = "[LineReason]='" + values[0].Trim() + "',LineReasonDsc='" + values[1].Trim() + "'";
                        //orderEntry.UpdateQuote(Session["DetailTableName"].ToString(), detailColumn, "f" + HeaderIDColumn.Remove(0, 1).Trim() + "=" + CustDet.SOOrderID);
                        return updateColumn;
                        break;
                    case "Price Cd":
                        updateColumn = "[PriceCd]='" + values[0].Trim() + "',";
                        SetSessionVariable();
                        return updateColumn;
                        break;               
                    case "Usage From":
                        updateColumn = "[UsageLoc]='" + values[0].Trim() + "',UsageLocName='" + values[1].Trim() + "',";
                        return updateColumn;
                        break;
                    default:
                        return updateColumn;
                        break;
                }
            }
            else
                return "";
        }
        catch (Exception ex)
        {

            throw;
        }
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void UpdateOrderContact(string soNumber, string contactName)
    {
        try
        {
            string strTableName = Session["OrderTableName"].ToString();
            string ColumnValue = "[SellToContactName]='" + contactName.Replace("'","''") + "'";
            customerDetail.UpdateHeader(strTableName, ColumnValue , HeaderIDColumn + "=" + Session["OrderHeaderID"].ToString());           
        }
        catch (Exception ex) { }
    }
    #endregion

    #region Event handler
    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnDelete_Click(object sender, EventArgs e)
    {
        try
        {
            string _tableName = Session["DetailTableName"].ToString();
            string _columnName = "DeleteDt='" + DateTime.Now.ToShortDateString() + "',ChangeID='" + lblEntId.Text + "',ChangeDate='" + DateTime.Now.ToShortDateString() + "'";
            orderEntry.UpdateQuote(_tableName, _columnName, DetailIDColumn + "=" + hidDelete.Value);
            orderEntry.UpdateQuote(CommentTableName, "DeleteDt='" + DateTime.Now.ToShortDateString() + "'", CommentIDColumn + "=" + CustDet.SOOrderID + " and CommLineNo=" + hidLineNo.Value);
            orderEntry.UpdateHeaderExtended(CustDet.SOOrderID, hidLineNo.Value, ((Session["OrderTableName"].ToString() == "SOHeader") ? "ORDER" : "REL"));
            btnGrid_Click(btnGrid, new EventArgs());
            ScriptManager.RegisterClientScriptBlock(btnDelete, typeof(Button), "hideDelete", "if(document.getElementById('hidRowID')){document.getElementById('hidRowID').value ='';}document.getElementById('divDelete').style.display='none';", true);
        }
        catch (Exception ex) { }
    }
    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ibtnExband_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton imgcommon = sender as ImageButton;
        string whereClause = string.Empty;

        if (imgcommon.ImageUrl == "~/Common/Images/expand.gif")
        {
            whereClause = "a.f" + HeaderIDColumn.Remove(0, 1).Trim() + "=" + CustDet.SOOrderID + " Order by a.LineNumber desc";
            // Code to hide the delete falg columns
            dgNewQuote.Columns[dgNewQuote.Columns.Count - 4].Visible = tdDelete.Visible = true;
            GetQuotes(whereClause);
            imgcommon.ImageUrl = "~/Common/Images/expt.gif";
            imgcommon.ToolTip = "Clike here to Show Item";
        }
        else
        {
            whereClause = " a.DeleteDt is null and a.f" + HeaderIDColumn.Remove(0, 1).Trim() + "=" + CustDet.SOOrderID + " Order by a.LineNumber desc";

            // Code to hide the delete falg columns
            dgNewQuote.Columns[dgNewQuote.Columns.Count - 4].Visible = tdDelete.Visible = false;
            GetQuotes(whereClause);

            imgcommon.ImageUrl = "~/Common/Images/expand.gif";
            imgcommon.ToolTip = "Clike here to Show Deleted Item";
        }
        BindDataGrid();
        pnlQuoteDetail.Update();
    }

    protected void btnRemoveHI_Click(object sender, EventArgs e)
    {
        string errorMsg = orderEntry.DoTotalCostCheck(CustDet.SOOrderID);
        if (errorMsg == "")
        {
            string _columnName ="StatusCd=NULL,HoldDt=NULL,HoldReason=NULL," +
                                "ChangeId='" + Session["UserName"].ToString() + "',ChangeDt='" + DateTime.Now.ToString() + "'" ;
            orderEntry.UpdateQuote(SOHeaderTable, _columnName, HeaderIDColumn + "=" + CustDet.SOOrderID);

            hidHoldDt.Value = "";
            lblOrdSts.Attributes.Add("oncontextmenu", "return false;");
            lblOrdSts.Attributes.Add("onmousedown", "return false;");
            lblOrdSts.Attributes.Add("style", "cursor:pointer;text-decoration:none;");
            lblOrdSts.ToolTip = "";
            lblOrdSts.Text = "Allocated";
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "Hold invoice flag removed successfully";
            pnlSOSummary.Update();
            pnlPoDetails.Update();
        }
        else
        {
            string _columnName = "StatusCd='NC'";
            orderEntry.UpdateQuote(SOHeaderTable, _columnName, HeaderIDColumn + "=" + CustDet.SOOrderID);

            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = "Not able to remove hold invoice flag (some of the items are missing avg cost).";
            pnlSOSummary.Update();
            pnlPoDetails.Update();

        }

    }

    protected void imgConfirmShpmt_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            orderEntry.ConfirmShipment(CustDet.SOOrderID);
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = "Shipment confirmed successfully";
            imgConfirmShpmt.Visible = false;
            pnlSOSummary.Update();
        }
        catch (Exception ex)
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = ex.Message;
            pnlSOSummary.Update();
        }

    }

    protected void btnRefereshGrid_Click(object sender, EventArgs e)
    {
        string detailIDColumn = (Session["DetailTableName"].ToString().ToLower().Trim() == "sodetail") ? "a.pSODetailID" : "a.fSODetailID";
        string whereClause = ((lblOrdSts.Text == "Deleted") ? "" : " a.DeleteDt is null AND ") + " a.f" + HeaderIDColumn.Remove(0, 1).Trim() + "=" + CustDet.SOOrderID + " Order by " + detailIDColumn + " desc";

        GetQuotes(whereClause);
        BindDataGrid();

        pnlQuoteDetail.Update();
    }
    
    #endregion

    #region Developer Method

    public void InsertUserErrorLog()
    {
        try
        {
            SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "[pUTInsertErrLog]",
                               new SqlParameter("@dbID", CustDet.SOOrderID),
                               new SqlParameter("@table", Session["OrderTableName"].ToString()),
                               new SqlParameter("@msg", "SOE: Order Override by " + Session["UserName"].ToString()),
                               new SqlParameter("@userName", Session["UserName"].ToString()),
                               new SqlParameter("@appFunction", "SOE"),
                               new SqlParameter("@procedureName", "Sales Order retrieval"));
        }
        catch (Exception ex)
        {
        }
    } 

    public void InsertErrorLog()
    {
        try
        {
            SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "[pUTInsertErrLog]",
                               new SqlParameter("@dbID", CustDet.SOOrderID),
                               new SqlParameter("@table", Session["OrderTableName"].ToString()),
                               new SqlParameter("@msg", "Expense Only Order Created"),
                               new SqlParameter("@userName", Session["UserName"].ToString()),
                               new SqlParameter("@appFunction", "SOE"),
                               new SqlParameter("@procedureName", "pSOEMakeOrder"));
        }
        catch (Exception ex)
        { 
        } 
    }

    /// <summary>
    /// 
    /// </summary>
    /// <param name="whereClause"></param>
    public void GetQuotes(string whereClause)
    {
        try
        {

            string tableName = Session["DetailTableName"].ToString() + " a (NOLOCK) LEFT OUTER JOIN LocMaster b (NOLOCK) ON a.IMLoc = b.LocID ";

            string columnName = "a.LineNumber,a." + DetailIDColumn + " as pSODetailID,a.ItemNo,a.ItemDsc,b.LocName as IMLoc ,a.IMLoc as IMLocID,Cast(a.ListUnitPrice AS Decimal(25,2)) as ListUnitPrice,CAST(a.NetUnitPrice AS Decimal(25,5)) As NetUnitPrice,CAST(a.AlternatePrice AS Decimal(25,2)) as AlternatePrice," +
                                "a.QtyAvailLoc1,Cast(a.QtyAvail1 As Decimal(25,0)) as QtyAvail1,Cast(a.QtyOrdered As Decimal(25,0)) as QtyOrdered,a.SellStkUM,a.Remark," +
                                "a.CustItemNo,a.EntryDate,a.EntryID,Cast(a.ExtendedNetWght AS Decimal(25,2)) as ExtendedNetWght,Cast(a.NetWght AS Decimal(25,2)) as NetWght," +
                                "Cast(a.ExtendedPrice AS Decimal(25,2)) as ExtendedPrice,Cast(a.SellStkQty As Decimal(25,0)) as SellStkQty," +
                                "a.AlternateUM,(cast(cast(a.SuperEquivQty as int) as varchar(100)) + '/ ' + a.SuperEquivUM) AS AlternateUMQty,convert(char(10),a.DeleteDt ,101) as DeleteDt,a.AlternateUM as AltPricePerUOM,FreightCd,CarrierCd,CAST(a.QtyShipped AS Decimal(25,0)) as ReceivedQty,a.LinePriceInd as LinePriceInd,"+
                                "CONVERT(VARCHAR(10),a.RqstdShipDt,101) as RqstdShipDt";

            DataSet dsQuote = orderEntry.ExecuteERPSelectQuery(tableName, columnName, whereClause);
            // Store the grid details in the session
            if (dsQuote != null)
            {
                Session["ProductDetails"] = dsQuote.Tables[0];
                dtProduct = dsQuote.Tables[0];
                //DeleteButtonLogic();
            }
            else
            {
                dtProduct.Rows.Clear();
                Session["ProductDetails"] = null;
            }

            
        }
        catch (Exception ex) { }
    }

    private void SetSessionVariable()
    {
        Session["CustomerNumber"] = CustDet.custNumber;
        Session["OrderNumber"] = CustDet.SOOrderID;
        Session["ShipLocation"] = ucShipFrom.Text;
        Session["CustPriceCode"] = CustDet.CustPriceCode;
        Session["CarrierCode"] = ucCarrierCode.Text.Trim();
        Session["FreightCode"] = ucFreightCode.Text.Trim();
        Session["CustomerName"] = CustDet.CustomerName;
        Session["ShipFrom"] = ucShipFrom.Text.Trim();       

        hidShowWorkSheet.Value = (orderEntry.GetShowWorkSheet(ucShipFrom.Text.Trim())) ? "true" : "false";
    }

    private void ClearSessionVariable()
    {
        Session["CustomerNumber"] = null;
        Session["OrderNumber"] = null;
        Session["ShipLocation"] = null;
        Session["CustPriceCode"] = null;
        Session["CustomerName"] = null;
        Session["CustomerDetail"] = null;
        Session["ShipDetails"] = null;
        Session["OrderTableName"] = null;
        Session["DetailTableName"] = null;
        Session["ShipFrom"] = null;
        Session["OrderHeaderID"] = null;
        Session["ProductDetails"] = null;
        Session["HeaderDetail"] = null;
        Session["ChangeOrderType"] = null;
    }

    private void ClearOrderEntryScreen()
    {
        txtINo1.Text = "";
        ClearCommandLine();
        ClearSessionVariable();
        ClearUserControls();
        CustDet.custNumber = "";
        CustDet.ClearLabels();
        pnlPoDetails.Update();
        pnlSOSummary.Update();
        pnlQuoteDetail.Update();
        pnlLineDtl.Update();
    }
    /// <summary>
    /// Show message 
    /// </summary>
    /// <param name="message"></param>
    /// <param name="isValid"></param>
    private void ShowMessage(string message, bool isValid)
    {
        lblMessage.ForeColor = (isValid) ? System.Drawing.Color.Green : System.Drawing.Color.Red;
        lblMessage.Text = message;
        pnlProgress.Update();
    }

    public void SetValueListControl(DropDownList ddlControl, string value)
    {
        ListItem lItem = ddlControl.Items.FindByValue(value) as ListItem;
        if (lItem != null)
            ddlControl.SelectedValue = value;
    }

    public void LoadDefaultOrder()
    {
        DataTable dtOrder = orderEntry.GetDefaultLockSO();

        if (dtOrder != null)
        {
            if (dtOrder.Rows[0]["TableRowItem"].ToString().ToUpper() == "SOHEADER")
            {
                Session["OrderTableName"] = "SOHeader";
                Session["DetailTableName"] = "SODetail";
                txtSoNumber.Text = dtOrder.Rows[0]["TypeofRowItem"].ToString().Trim();
            }
            else if (dtOrder.Rows[0]["TableRowItem"].ToString().ToUpper() == "SOHEADERREL")
            {
                Session["OrderTableName"] = "SOHeaderRel";
                Session["DetailTableName"] = "SODetailRel";
                CustDet.SOOrderID = dtOrder.Rows[0]["TypeofRowItem"].ToString().Trim();
                txtSoNumber.Text = dtOrder.Rows[0]["TypeofRowItem"].ToString().Trim() + "W";
            }
            else if (dtOrder.Rows[0]["TableRowItem"].ToString().ToUpper() == "SOHEADERHIST")
            {
                Session["OrderTableName"] = "SOHeaderHist";
                Session["DetailTableName"] = "SODetailHist";
                txtSoNumber.Text = dtOrder.Rows[0]["TypeofRowItem"].ToString().Trim();
            }
            CustDet.btnLoadAll_Click(btnSetOrderType, new EventArgs());
            btnLoadAll_Click(btnSetOrderType, new EventArgs());
        }
    }

    private bool CheckExpenseLinesCount()
    {
        //Expenses are not to be underlined until expenses or comments are added
        DataSet dsExpense = expenseEntry.GetSOExpense(CustDet.SOOrderID);
        //lnbtnExpense.Font.Underline = (lnbtnExpense.Font.Underline && dsExpense != null && dsExpense.Tables[0].Rows.Count > 0);
        return (dsExpense.Tables[0].Rows.Count > 0 ? true : false);
    }

    private void BindPrintDialog()
    {
        if (txtSoNumber.Text != "" && Session["OrderHeaderID"] != null)
        {
            PrintDialogue1.CustomerNo = CustDet.custNumber;
            //PrintDialogue1.PageTitle = "Sales Order for SO#  " + CustDet.SOOrderID;
            string pageURL = "";

            if (hidSubType.Value == "53" && SOHeaderTable.ToLower().Trim() == "soheaderrel")
            {
                PrintDialogue1.PageTitle = "RGA for SO#  " + CustDet.SOOrderID + " / PO " + txtPO.Text ;
                pageURL = Server.UrlEncode("RGAExport.aspx?OrderNo=" + CustDet.SOrderNumber.ToLower().Replace("w", ""));
            }
            else if (hidSubType.Value == "53" && SOHeaderTable.ToLower().Trim() == "soheaderhist")
            {
                PrintDialogue1.PageTitle = "RGR for SO#  " + CustDet.SOOrderID + " / PO " + txtPO.Text;
                pageURL = Server.UrlEncode("RGRExport.aspx?OrderNo=" + CustDet.SOrderNumber.ToLower().Replace("w", ""));
            }
            else if (hidSubType.Value == "51" && ucOrderType.Text == "IO" && SOHeaderTable.ToLower().Trim() == "soheaderhist")
            {
                PrintDialogue1.PageTitle = "Invoice for SO#  " + CustDet.SOOrderID + " / PO " + txtPO.Text;
                pageURL = Server.UrlEncode("InvoiceExport.aspx?OrderNo=" + CustDet.SOrderNumber.ToLower().Replace("w", ""));
            }
            else if (hidSubType.Value == "51" && ucOrderType.Text == "CR" && SOHeaderTable.ToLower().Trim() == "soheaderhist")
            {
                PrintDialogue1.PageTitle = "CRA for SO#  " + CustDet.SOOrderID + " / PO " + txtPO.Text;
                pageURL = Server.UrlEncode("CreditExport.aspx?OrderNo=" + CustDet.SOrderNumber.ToLower().Replace("w", ""));
            }
            else // Old logic for export
            {
                if (SOHeaderTable.ToLower().Trim() != "soheaderhist")
                {
                    PrintDialogue1.PageTitle = "Sales Order for SO#  " + CustDet.SOOrderID + " / PO " + txtPO.Text;
                    pageURL = Server.UrlEncode("SOExport.aspx?OrderNo=" + CustDet.SOOrderID + "&Header=" + SOHeaderTable + (Session["SODocSort"] != null ? "&LineSort=" + Session["SODocSort"].ToString() : ""));
                }
                else
                {
                    string orderNo = CustDet.SOrderNumber.ToLower().Replace("w", "");
                    string whereClause = CustDet.SOrderNumber.Trim().ToLower().Contains("w") ? "OrderRelNo=" + orderNo + "" : "OrderNo='" + orderNo + "'";
                    DataTable dtOrder = printInvoice.GetInvoice(whereClause);

                    if (dtOrder != null && dtOrder.Rows.Count > 0)
                    {
                        //invoiceNo = "62571";
                        PrintDialogue1.PageTitle = "Invoice for SO#  " + CustDet.SOOrderID + " / PO " + txtPO.Text;
                        pageURL = "InvoiceExport.aspx?InvoiceNo=" + dtOrder.Rows[0]["InvoiceNo"].ToString();
                    }
                }
            }

            PrintDialogue1.PageUrl = pageURL;

        }
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public bool CheckForFreightCdPrompt(string freightCd)
    {
        try
        {
            // If it the frightcd has "DC" in delivery charge field then display expense prompt        
            object objFreightChargeCd = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "[pSOESelect]",
                                                    new SqlParameter("@tableName", "Tables"),
                                                    new SqlParameter("@columnNames", "DelChgCd"),
                                                    new SqlParameter("@whereClause", "TableType='FGHT' and SOApp='Y' and TableCd='" + freightCd + "'"));

            if (objFreightChargeCd != null &&
                objFreightChargeCd.ToString().ToLower().Trim() == "00")
                return true;

            return false;
        }
        catch (Exception ex)
        {
            return false;            
        }

    }    

    #endregion     
   
    #region Check order No with Multiple table
    protected void btnSetOrderType_Click(object sender, EventArgs e)
    {

        ClearOrderEntryScreen();

        if (txtSoNumber.Text.ToLower().Contains("w"))
        {
            Session["OrderTableName"] = "SOHeaderRel";
            Session["DetailTableName"] = "SODetailRel";
            CustDet.SOOrderID = txtSoNumber.Text.ToLower().Replace("w", "");
            txtSoNumber.Text = txtSoNumber.Text.ToLower().Replace("w", "");

            CustDet.btnLoadAll_Click(btnSetOrderType, new EventArgs());
            btnLoadAll_Click(btnSetOrderType, new EventArgs());
        }
        else
        {
            DataSet dsOrderType = orderEntry.GetAvailableOrderType(txtSoNumber.Text);

            if (dsOrderType != null)
            {
                // Order is only in SOHeader table, directly display order information
                if (dsOrderType.Tables[0].Rows.Count > 0 && dsOrderType.Tables[2].Rows.Count == 0 && dsOrderType.Tables[1].Rows.Count == 0)
                {
                    Session["OrderTableName"] = "SOHeader";
                    Session["DetailTableName"] = "SODetail";
                    CustDet.SOOrderID = txtSoNumber.Text.Trim();
                    CustDet.btnLoadAll_Click(btnSetOrderType, new EventArgs());
                    btnLoadAll_Click(btnSetOrderType, new EventArgs());
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Opens", "if(document.getElementById('txtPO') != null){document.getElementById('txtPO').focus();document.getElementById('txtPO').select();}", true);
                }
                // Invalid sales order number
                else if (dsOrderType.Tables[0].Rows.Count == 0 && dsOrderType.Tables[2].Rows.Count == 0 && dsOrderType.Tables[1].Rows.Count == 0)
                {
                    ScriptManager.RegisterClientScriptBlock(btnSetOrderType, btnSetOrderType.GetType(), "orderType", "document.getElementById('lblMessage').innerText=\"Invalid Sales Order Number\";", true);
                }
                // Order is in mutiple table open dialog box
                else
                {
                    ScriptManager.RegisterClientScriptBlock(btnSetOrderType, btnSetOrderType.GetType(), "orderType", "OpenOrderTypeDialog(" + txtSoNumber.Text + ");", true);
                }
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(btnSetOrderType, btnSetOrderType.GetType(), "orderType", "document.getElementById('lblMessage').innerText=\"Invalid Sales Order Number\";", true);
            }
        }

    } 
    #endregion

    #region Command line function

    /// <summary>
    /// set Command line read only
    /// </summary>
    private void SetCommandLineReadOnly()
    {
        txtSellPrice.ReadOnly = (hidCommandLineReadOnly.Value == "true");
        txtReqQty.ReadOnly = (hidCommandLineReadOnly.Value == "true");
        txtINo1.ReadOnly = (hidCommandLineReadOnly.Value == "true");
        txtQuoteRemark.ReadOnly = (hidCommandLineReadOnly.Value == "true");
        txtCmdShipLoc.ReadOnly = (hidCommandLineReadOnly.Value == "true");
    }

    protected void btnPFCItem_Click(object sender, EventArgs e)
    {
        itemType = "PFC";
        btnItemNo_Click(btnPFCItem, new EventArgs());
    }

    protected void btnCustItem_Click(object sender, EventArgs e)
    {
        itemType = "Alias";
        btnItemNo_Click(btnCustItem, new EventArgs());
    }
    /// <summary>
    /// Item number event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnItemNo_Click(object sender, EventArgs e)
    {
        bool isPONumberValid = (hidPORequired.Value == "false" ? true : (txtPO.Text != "" ? true : false));

        if ( isPONumberValid && hidIsReadOnly.Value == "false" && txtINo1.Text.Trim() != "")
        {
            txtCmdShipLoc.Text = ucShipFrom.Text.Trim();
            hidOrgShipLoc.Value = txtCmdShipLoc.Text;

            DataSet dsItemDetail = orderEntry.GetProductInfo(txtINo1.Text.Trim(), CustDet.custNumber, txtCmdShipLoc.Text, itemType);
            ClearCommandLine();

            if (dsItemDetail.Tables.Count >= 1)
            {
                if (dsItemDetail.Tables.Count == 1)
                {
                    // We only go one table back, something is wrong
                    DataTable dt = dsItemDetail.Tables[0];
                    
                    if (dt.Rows.Count > 0)
                    {
                        if (dt.Rows[0]["ErrorType"].ToString().Trim() + dt.Rows[0]["ErrorCode"].ToString() == "E0022")
                        {
                            ShowMessage("Item not stocked at any Branch. This item cannot be sold.", false);
                            SMOrderEntry.SetFocus("txtINo1");
                        }
                        else
                        {
                            ShowMessage(txtINo1.Text + " Alias for " + CustDet.custNumber + " not on file.", false);
                            SMOrderEntry.SetFocus("txtINo1");
                        }
                    }
                }
                else
                {
                    DataTable dtItemDetail = dsItemDetail.Tables[1].DefaultView.ToTable();
                    txtINo1.Text = dtItemDetail.Rows[0]["FoundItem"].ToString();
                    lblDesription.Text = dtItemDetail.Rows[0]["ItemDesc"].ToString();
                    lblBuom.Text = dtItemDetail.Rows[0]["ItemQty"].ToString() + "/" + dtItemDetail.Rows[0]["ItemUOM"].ToString();
                    lblSupEquiv.Text = dtItemDetail.Rows[0]["SuperQty"].ToString() + "/" + dtItemDetail.Rows[0]["SuperUM"].ToString();
                    lblAltPUOM.Text = dtItemDetail.Rows[0]["AltPriceUM"].ToString();
                    hidQty.Value = dtItemDetail.Rows[0]["ItemQty"].ToString();
                    hidCertsReqd.Value = dtItemDetail.Rows[0]["CertRequiredInd"].ToString();
                    string ItemType = "PFC";

                    if (dtItemDetail.Rows[0]["CustItem"].ToString().Trim() != "No Alias")
                    {
                        hidCrossref.Value = dtItemDetail.Rows[0]["CustItem"].ToString();
                        hidCrossDesc.Value = dtItemDetail.Rows[0]["CustDesc"].ToString();
                    }


                    hidReplacement.Value = String.Format("{0:0.000}", dtItemDetail.Rows[0]["ReplacementCost"]);
                    //hidStdCost.Value = String.Format("{0:0.000}", dtItemDetail.Rows[0]["StdCost"]);
                    hidListPrice.Value = String.Format("{0:0.000}", dtItemDetail.Rows[0]["ListPrice"]);
                    hidWorkItemWeight.Value = String.Format("{0:0.00}", dtItemDetail.Rows[0]["GrossWght"]);
                    hidWorkNetWeight.Value = String.Format("{0:0.00}", dtItemDetail.Rows[0]["Wght"]);

                    SMOrderEntry.SetFocus("txtReqQty");

                }
            }
            //if (dsItemDetail != null && dsItemDetail.Tables[0].Rows.Count > 0 && dsItemDetail.Tables[0].Rows[0][1].ToString().Trim() == "")
            
            else
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = "Invalid Item Number";
                ClearCommandLine();
                SMOrderEntry.SetFocus("txtINo1");
                pnlProgress.Update();
            }
        }
        else
        {
            SMOrderEntry.SetFocus("txtReqQty");
            ClearCommandLine();
        }
    }    
    /// <summary>
    /// Qty update event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnQtyUpdate_TextChanged(object sender, EventArgs e)
    {
        bool isPONumberValid = (hidPORequired.Value == "false" ? true : (txtPO.Text != "" ? true : false));

        if (isPONumberValid && hidIsReadOnly.Value == "false")
        {
            if (txtReqQty.Text.Trim() != "")
            {
                char[] QtyArray = txtReqQty.Text.Trim().ToCharArray();
                string UOMText = "";
                string Qtytext = "";
                DataTable dt = new DataTable();
                foreach (char c in QtyArray)
                {
                    if (c.Equals('-')) Qtytext += c;
                    if (char.IsDigit(c)) Qtytext += c;
                    if (c.Equals('.')) Qtytext += c;
                    if (char.IsLetter(c)) UOMText += c;
                }
                // get the data.
                DataSet dsAvail = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEGetBrAvail]",
                          new SqlParameter("@SearchItemNo", txtINo1.Text),
                          new SqlParameter("@QtyRequested", Qtytext),
                          new SqlParameter("@QtyUOM", UOMText),
                          new SqlParameter("@PrimaryBranch", txtCmdShipLoc.Text.Trim()));
                if (dsAvail.Tables.Count >= 1)
                {
                    if (dsAvail.Tables.Count == 1)
                    {
                        if (dsAvail.Tables[0].Rows.Count > 0)
                        {
                            ShowMessage("Invalid UOM " + UOMText, false);
                            SMOrderEntry.SetFocus("txtReqQty");
                            return;
                        }
                    }
                    else
                    {
                        dsAvail.Tables[1].DefaultView.RowFilter = "Location='" + txtCmdShipLoc.Text.Trim() + "'";
                        dt = dsAvail.Tables[1].DefaultView.ToTable();
                        txtAvQty.Text = (dt != null && dt.Rows.Count > 0) ? dt.Rows[0]["QOH"].ToString() : "0";
                        hidQtyToSell.Value = dsAvail.Tables[2].Rows[0]["QtyToSell"].ToString();
                        lblSellQty.Text = dsAvail.Tables[2].Rows[0]["QtyToSell"].ToString() + "/" + lblBuom.Text.Split('/')[1].ToString().Trim();
                        
                        if(ucOrderType.Text == "TO")
                            chkExcludeUsage.Checked = true;
                    }
                }
                
                //if(lblPriceOrgin.Text != "E")
                BindProductDetail();
            }
            
        }
    }
    /// <summary>
    /// Clear Command line event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnClearItem_TextChanged(object sender, EventArgs e)
    {
        txtINo1.Text = "";
        txtCmdShipLoc.Text = "";
        ClearCommandLine();
        SMOrderEntry.SetFocus("txtINo1");
    }
    /// <summary>
    ///  Sell price update event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnPriceUpdate_Click(object sender, EventArgs e)
    {
        try
        {
            Session["oeLineStartPrc"] = true;
            if (hidSellPrice.Value.Trim() != txtSellPrice.Text.Trim())
                txtSellPrice_TextChanged(btnPriceChange, new EventArgs());

            bool isPONumberValid = (hidPORequired.Value == "false" ? true : (txtPO.Text != "" ? true : false));

            if (isPONumberValid && hidIsReadOnly.Value == "false")
            {
                if (isValid)
                {
                    if (txtReqQty.Text != "" && IsValidOrderLine())
                    {
                        // Call the function to insert quote details
                        SaveQuotation();
                        btnGrid_Click(btnGrid, new EventArgs());
                        ClearCommandLine();
                        txtINo1.Text = "";
                        txtCmdShipLoc.Text = "";
                        SMOrderEntry.SetFocus("txtINo1");
                    }

                }
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Opens", "alert('Enter PO Number');if(document.getElementById('txtPO') != null){document.getElementById('txtPO').focus();document.getElementById('txtPO').select();}", true);
            }
        }
        catch (Exception)
        {

        }
        finally
        {
            hidStartProc.Value  = "0"; // To avoid multiple entry when user hit enter key twice in cmd line
        }
        
    }
    /// <summary>
    /// Sell price change event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void txtSellPrice_TextChanged(object sender, EventArgs e)
    {
        if (hidSellPrice.Value.Trim() != txtSellPrice.Text.Trim())
        {
            lblPriceOrgin.Text = "E";

            decimal AltPrice = 0;
            if (decimal.TryParse(txtSellPrice.Text, out AltPrice))
            {
                CalculateField();                
            }
            else
            {
                ShowMessage("Invalid Sell Price", false);
                SMOrderEntry.SetFocus(txtSellPrice);
            }
        }

        SMOrderEntry.SetFocus("txtCmdShipLoc");
    }
    /// <summary>
    /// Calculate command values
    /// </summary>
    protected void CalculateField()
    {
        decimal ItemWeight = decimal.Parse(hidWorkItemWeight.Value);
        int LineQty = int.Parse(hidQtyToSell.Value);
        decimal MainCost = decimal.Parse(hidAvgCost.Value);
        decimal StdCost = decimal.Parse(hidStdCost.Value);
        decimal AltQty = decimal.Parse(hidAltQty.Value);
        decimal UnitQty = decimal.Parse(hidQty.Value);
        //decimal ItemSellPrice = decimal.Parse(txtSellPrice.Text) * UnitQty / AltQty;
        decimal ItemSellPrice = (decimal)Math.Round(decimal.Parse(txtSellPrice.Text) * (1 / AltQty), 5);        
        //decimal ItemSellPrice = decimal.Parse(txtSellPrice.Text) * UnitQty * AltQty;
        if (MainCost == 0) MainCost = StdCost;        

        txtPriceLb.Text = (ItemWeight == 0 ? "0.00" : Math.Round(ItemSellPrice / ItemWeight, 2).ToString());
        //txtSellPrice.Text = (UnitQty == 0 ? "0.000" : Math.Round(ItemSellPrice * AltQty / UnitQty, 3).ToString()); // Lines Commented for new pricing procedure implementation
        //hidSellPrice.Value = (UnitQty == 0 ? "0.000" : Math.Round(ItemSellPrice * AltQty / UnitQty, 3).ToString());
        hidSellPrice.Value = txtSellPrice.Text;
        hidTotAmt.Value = Math.Round(LineQty * ItemSellPrice, 2).ToString();
        hidTotWeight.Value = Math.Round(LineQty * ItemWeight, 2).ToString();
        lblAltQty.Text = string.Format("{0:####,###,##0}", Math.Round(LineQty * UnitQty, 0));        
        txtUnitPrice.Text = ItemSellPrice.ToString();        

        hidTotCost.Value = Math.Round(LineQty * MainCost, 2).ToString();
        lblPriceUOM.Text = string.Format("{0:0.00}", ItemSellPrice).ToString() + " / " + lblBuom.Text.Split('/')[1].ToString().Trim();        
        txtMarginPct.Text = ((txtUnitPrice.Text.Split('.')[0].Trim() != "0") ? (Math.Round((Convert.ToDecimal(txtUnitPrice.Text) - Convert.ToDecimal(hidAvgCost.Value)) / Convert.ToDecimal(txtUnitPrice.Text) * 100, 2)).ToString() : "0");
    }
    /// <summary>
    /// Bind Product details
    /// </summary>
    private void BindProductDetail()
    {
        DataSet dsPricedetail = orderEntry.GetProductPriceDetail(CustDet.SOOrderID, txtINo1.Text.Trim(), CustDet.custNumber, Session["ShipFrom"].ToString(), Session["OrderTableName"].ToString(), Session["DetailTableName"].ToString(), hidQtyToSell.Value, txtSellPrice.Text, lblPriceOrgin.Text, Session["CustPriceCode"].ToString());
        if (dsPricedetail != null && dsPricedetail.Tables.Count >= 1)
        {
            //if (dsPricedetail.Tables.Count >= 1 && dsPricedetail.Tables[0].Rows[0]["ErrorType"].ToString().Trim()!="")
            if (dsPricedetail.Tables.Count == 1)
            {
                // We only go one table back, something is wrong
                DataTable dt = dsPricedetail.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    ShowMessage("Pricing problem", false);
                    SMOrderEntry.SetFocus("txtINo1");
                }
            }
            else
            {               
                if (dsPricedetail != null && dsPricedetail.Tables[1].Rows.Count > 0)
                {
                    hidOECost.Value = dsPricedetail.Tables[1].Rows[0]["OECost"].ToString();
                    hidAltQty.Value = dsPricedetail.Tables[1].Rows[0]["AltUOMQty"].ToString();
                    txtUnitPrice.Text = Math.Round(Convert.ToDecimal(dsPricedetail.Tables[1].Rows[0]["Price"]), 2).ToString();
                    hidSellPrice.Value = Math.Round(Convert.ToDecimal(dsPricedetail.Tables[1].Rows[0]["Price"]), 2).ToString();
                    txtPriceLb.Text = Math.Round(Convert.ToDecimal(dsPricedetail.Tables[1].Rows[0]["SuggSellPricePerLB"]), 2).ToString();
                    txtMarginPct.Text = ((dsPricedetail.Tables[1].Rows[0]["Price"].ToString().Split('.')[0].Trim() != "0") ? (Math.Round((Convert.ToDecimal(dsPricedetail.Tables[1].Rows[0]["Price"]) - Convert.ToDecimal(dsPricedetail.Tables[1].Rows[0]["AvgCost"])) / Convert.ToDecimal(dsPricedetail.Tables[1].Rows[0]["Price"]) * 100, 2)).ToString() : "0");
                    txtSellPrice.Text = Math.Round(Convert.ToDecimal( (ucOrderType.Text == "TO" ? "0" : dsPricedetail.Tables[1].Rows[0]["AltSellPrice"])), 2).ToString();
                    lblAltQty.Text = string.Format("{0:####,###,##0}", Math.Round(Convert.ToDecimal(dsPricedetail.Tables[1].Rows[0]["AltUOMQty"]), 2));
                    lblPriceOrgin.Text = dsPricedetail.Tables[1].Rows[0]["PriceOrigin"].ToString();
                    hidItemWeight.Value = dsPricedetail.Tables[1].Rows[0]["Weight"].ToString();
                    hidAvgCost.Value = (Convert.ToInt32(dsPricedetail.Tables[1].Rows[0]["StdCost"]) != 0 ? dsPricedetail.Tables[1].Rows[0]["StdCost"].ToString() : dsPricedetail.Tables[1].Rows[0]["AvgCost"].ToString()); ;                    
                    hidTotNetWeight.Value = dsPricedetail.Tables[1].Rows[0]["LineNetWeight"].ToString();
                    //hidQty.Value = dsPricedetail.Tables[1].Rows[0]["Qty"].ToString();

                    decimal AltQty =Convert.ToDecimal(dsPricedetail.Tables[1].Rows[0]["AltUOMQty"].ToString());
                    if (AltQty != 0)
                    {
                        hidStdCost.Value = Math.Round(decimal.Parse(dsPricedetail.Tables[1].Rows[0]["IBPriceCost"].ToString()) * (1 / AltQty), 5).ToString();
                    }
                    else
                        hidStdCost.Value = "0";
                    CalculateField();
                    if(hidCmdSourceControl.Value == "Location")
                        SMOrderEntry.SetFocus("txtQuoteRemark");
                    else
                        SMOrderEntry.SetFocus("txtSellPrice");
                    
                }
            }
        }
    }
    /// <summary>
    /// Clear Command Line
    /// </summary>
    private void ClearCommandLine()
    {
        chkExcludeUsage.Checked = false;
        chkItemCert.Checked = false;
        txtUnitPrice.Text = "";
        txtPriceLb.Text = "";
        txtMarginPct.Text = "";
        lblBuom.Text = "";
        lblSupEquiv.Text = "";
        lblDesription.Text = "";
        txtReqQty.Text = "";
        txtAvQty.Text = "";
        hidItemWeight.Value = "";
        hidAvgCost.Value = "";
        hidCrossref.Value = "";
        txtQuoteRemark.Text = "";
        hidQtyToSell.Value = "";
        lblAltPUOM.Text = "";
        lblAltQty.Text = "";
        txtSellPrice.Text = "";
        lblPriceOrgin.Text = "";
        lblPriceUOM.Text = "";
        hidAltQty.Value = "";
        hidItemWeight.Value = "";
        hidAvgCost.Value = "";
        hidCrossref.Value = "";
        hidCrossDesc.Value = "";
        hidQtyToSell.Value = "";
        hidStdCost.Value = "";
        hidListPrice.Value = "";
        hidReplacement.Value = "";
        hidWorkNetWeight.Value = "";
        hidWorkItemWeight.Value = "";
        hidTotAmt.Value = "";
        hidTotWeight.Value = "";
        hidTotNetWeight.Value = "";
        hidSellPrice.Value = "";
        lblSellQty.Text = "";
        hidCertsReqd.Value = "";
    }    
    #endregion

    #region Order Lock status
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public Array CheckLock(string soOrderId)
    {
        // ClearOrderEntryScreen();
        string[] arCust ={ };
        string orderid = "";
        string status = "";
        string lockstatus = "";
        string userName = "";
        DataTable dtLock = new DataTable();
        if (soOrderId.ToLower().Contains("w"))
        {
            Session["OrderTableName"] = "SOHeaderRel";
            Session["DetailTableName"] = "SODetailRel";
            orderid = soOrderId.ToLower().Replace("w", "");
            Session["OrderHeaderID"] = orderid;
            orderEntry.ReleaseLock();
            dtLock = orderEntry.OrderLock("Lock", orderid);
            orderEntry.SetLock(orderid);
            status = "Single";
        }
        else
        {
            DataSet dsOrderType = orderEntry.GetAvailableOrderType(soOrderId);

            if (dsOrderType != null)
            {
                // Order is only in SOHeader table, directly display order information
                if (dsOrderType.Tables[0].Rows.Count > 0 && dsOrderType.Tables[2].Rows.Count == 0 && dsOrderType.Tables[1].Rows.Count == 0)
                {
                    Session["OrderTableName"] = "SOHeader";
                    Session["DetailTableName"] = "SODetail";
                    orderid = soOrderId.ToLower().Replace("w", "");
                    Session["OrderHeaderID"] = orderid;
                    orderEntry.ReleaseLock();
                    dtLock = orderEntry.OrderLock("Lock", orderid);
                    orderEntry.SetLock(orderid);
                    status = "Single";
                }
                // Invalid sales order number
                else if (dsOrderType.Tables[0].Rows.Count == 0 && dsOrderType.Tables[2].Rows.Count == 0 && dsOrderType.Tables[1].Rows.Count == 0)
                {
                    status = "Invalid";//ScriptManager.RegisterClientScriptBlock(btnSetOrderType, btnSetOrderType.GetType(), "orderType", "document.getElementById('lblMessage').innerText=\"Invalid Sales Order Number\";", true);

                }
                // Order is in mutiple table open dialog box
                else
                {
                    status = "Multiple"; //ScriptManager.RegisterClientScriptBlock(btnSetOrderType, btnSetOrderType.GetType(), "orderType", "OpenOrderTypeDialog(" + txtSoNumber.Text + ");", true);
                }
            }
            else
            {
                status = "Invalid";
                // ScriptManager.RegisterClientScriptBlock(btnSetOrderType, btnSetOrderType.GetType(), "orderType", "document.getElementById('lblMessage').innerText=\"Invalid Sales Order Number\";", true);
            }
        }
        if (dtLock != null && dtLock.Rows.Count > 0)
        {
            userName = dtLock.Rows[0][0].ToString();
            lockstatus = dtLock.Rows[0][1].ToString();
        }

        arCust = new string[3] 
         {
            status,userName,lockstatus
         };
        return arCust;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public Array CheckOrderLock(string soOrderId)
    {
        string[] arCust ={ };
        DataTable dtLock = new DataTable();
        orderEntry.ReleaseLock();
        dtLock = orderEntry.OrderLock("Lock", soOrderId.ToUpper().Replace("W",""));
        arCust = new string[2] 
         {
            dtLock.Rows[0][0].ToString(),dtLock.Rows[0][1].ToString()
         };
        return arCust;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void CreateItemSession(string itemNo)
    {
        Session["ItemNo"] = itemNo.Replace("+", "");
    }
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string CheckUserLogin(string soID)
    {
        object obSelect = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                                                new SqlParameter("@tableName", Session["OrderTableName"].ToString()),
                                                new SqlParameter("@columnNames", "OrderNo"),
                                                new SqlParameter("@whereClause", HeaderIDColumn +"='"+soID.ToLower().Replace("w","")+"' and entryId='"+Session["UserName"].ToString()+"'"));

        if (obSelect == null && Session["OrderTableName"] != null && Session["OrderTableName"].ToString() != "SOHeaderHist")
        {
            object userID = (object)SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                                                 new SqlParameter("@tableName", "listmaster,listdetail"),
                                                 new SqlParameter("@columnNames", "ListDtlDesc"),
                                                 new SqlParameter("@whereClause", "listmaster.pListMasterID =listdetail.fListMasterID and listmaster.ListName='SOEbypassid' and listdetail.ListValue='" + Session["UserName"].ToString() + "'"));
            if (userID == null)
                return "false";
            else
                return "true";
        }
        else
            return "true";

    }
    #endregion

    #region Invoice

    public void ibtnInvoice_Click(object sender, EventArgs e)
    {
        if (CustDet.SOrderNumber != "")
        {
            string invoiceNo = "";
            string orderNo = CustDet.SOrderNumber.ToLower().Replace("w", "");

            string whereClause = CustDet.SOrderNumber.Trim().ToLower().Contains("w") ? "OrderRelNo=" + orderNo + "" : "OrderNo='" + orderNo + "'";

            DataTable dtOrder = printInvoice.GetInvoice(whereClause);

            if (dtOrder != null && dtOrder.Rows.Count > 0)
            {
                if (dtOrder.Rows.Count == 1)
                {
                    invoiceNo = dtOrder.Rows[0]["InvoiceNo"].ToString();
                    //invoiceNo = "62571";

                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "Invoice", "GetInvoice('" + invoiceNo + "');", true);
                }
                else
                {

                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "AvailableInvoice", "AvailInvoice('" + orderNo + "');", true);
                }

            }
            // added by Slater for WO 1540
            else
            {
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "NoShipper", "alert('Invoice is unavailable for this document');", true);
            }
        }
    }

    public void ibtnExportExcel_Click(object sender, EventArgs e)
    {
        string excelFileName = "SOExport" + DateTime.Now.ToString().Replace(":", "").Replace("/", "").Replace(" ", "") + ".xls";
        FileInfo fnExcel = new FileInfo(Server.MapPath("Common//Excel//" + excelFileName));
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();

        DataTable _dtProduct = (DataTable)Session["ProductDetails"];
        if (_dtProduct != null && _dtProduct.Rows.Count > 0)
        {
            headerContent = "<table border='1'>";

            headerContent += "<tr>" +
                                "<th nowrap width='100'> <center>SO Number</center> </th>" +
                                "<th nowrap width='100'> <center>Customer #</center> </th>" +
                                "<th nowrap width='100'> <center>Cust Item #</center> </th>" +
                                "<th width='100'  nowrap><center>Item #</center></th>" +
                                "<th width='200' nowrap align='center'>Description</th>" +
                                "<th width='50' align='center'>Req'd Qty</th>" +
                                "<th width='70' class='GridHead splitBorders'><center>Base Qty/UOM</center></th>" +
                                "<th width='50'  align='center'>Avail Qty.</th>" +
                                "<th width='50'  align='center'>Sell Price</th>" +
                                "<th width='50'  align='center' >Sell Unit</th>" +
                                "<th width='40' nowrap align='center' nowrap >PI</th>" +
                                "<th width='40'  nowrap align='center' nowrap >Loc</th>" +
                                "<th width='80'  align='center' >Carrier Cd</th>" +
                                "<th width='80'  align='center' >Freight Cd</th>" +
                                "<th width='80'  align='center' >Extended Amount</th>" +
                                "<th width='80'  align='center' >Extended Weight</th>" +
                                "<th width='90'  align='center' >Super Equival</th>" +
                                "<th width='100' align='center' >Location Name</th>" +
                                "<th width='100' align='center' >Line Note</th>" +
                                "</tr>";


            if (_dtProduct.Rows.Count > 0)
            {
                foreach (DataRow drSODetail in _dtProduct.Rows)
                {
                    excelContent += "<tr><td STYLE=\"mso-number-format:00\">" + CustDet.SOrderNumber + "</td><td>" +
                                                    CustDet.custNumber + "</td><td>" +
                                                    drSODetail["CustItemNo"].ToString() + "</td><td>" +
                                                    drSODetail["ItemNo"] + "</td><td>" +
                                                    drSODetail["ItemDsc"] + "</td><td>" +
                                                    drSODetail["QtyOrdered"] + "</td><td>" +
                                                    drSODetail["SellStkQty"] + "/" + drSODetail["SellStkUM"] + "</td><td>" +
                                                    drSODetail["QtyAvail1"] + "</td><td>" +
                                                    drSODetail["AlternatePrice"] + "</td><td>" +
                                                    drSODetail["AltPricePerUOM"] + "</td><td>" +
                                                    drSODetail["LinePriceInd"] + "</td><td>" +
                                                    drSODetail["IMLocID"] + "</td><td STYLE=\"mso-number-format:00\">" +
                                                    drSODetail["CarrierCd"] + "</td><td STYLE=\"mso-number-format:00\">" +
                                                    drSODetail["FreightCd"] + "</td><td>" +
                                                    string.Format("{0:#,##0.00}", drSODetail["ExtendedPrice"]) + "</td><td>" +
                                                    string.Format("{0:#,##0.00}", drSODetail["ExtendedNetWght"]) + "</td><td STYLE=\"mso-number-format:00\">" +
                                                    drSODetail["AlternateUMQty"] + "</td><td STYLE=\"mso-number-format:00;\" align='left'>" +
                                                    drSODetail["IMLoc"].ToString() + "</td><td STYLE=\"mso-number-format:000000\">" +
                                                    drSODetail["Remark"] + "</td></tr>";
                }

                footerContent = "</table>";

            }
            reportWriter.WriteLine(headerContent + excelContent + footerContent);
            reportWriter.Close();

            //
            // Downloding Process
            //
            FileStream fileStream = File.Open(Server.MapPath("Common//Excel//" + excelFileName), FileMode.Open);
            Byte[] bytBytes = new Byte[fileStream.Length];
            fileStream.Read(bytBytes, 0, (int)fileStream.Length);
            fileStream.Close();

            //
            // Download Process
            //
            Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath("Common//Excel//" + excelFileName)));
            Response.ContentType = "application/octet-stream";
            Response.BinaryWrite(bytBytes);
            Response.End();
        }
    }

    #endregion

    #region Shipper
    // Added by Slater for Shipper processing
    public void ibtnShipper_Click(object sender, EventArgs e)
    {
        if (CustDet.SOrderNumber != "")
        {
            string shipperNo = "";
            string orderNo = CustDet.SOrderNumber.ToLower().Replace("w", "");
            string whereClause = CustDet.SOrderNumber.Trim().ToLower().Contains("w") ? "OrderNo=" + orderNo + "" : "fSOHeaderID='" + orderNo + "'";
            DataTable dtShipper = printShipper.GetShipper(whereClause);
            if (dtShipper != null && dtShipper.Rows.Count > 0)
            {
                if (dtShipper.Rows.Count == 1)
                {
                    // set up everything for the Print Utilty and fire it up.
                    shipperNo = dtShipper.Rows[0]["OrderNo"].ToString();
                    string printDialogURL = ConfigurationManager.AppSettings["SOESiteURL"].ToString() + "PrintUtility.aspx";
                    string strPageTitle = "Shipper " + shipperNo;
                    string strPageUrl = "ShipperExport.aspx?ShipperNo=" + shipperNo;
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Fax", "OpenPrintDialog('" + strPageUrl + "','Print','','" + Server.UrlEncode(strPageTitle) + "','" + printDialogURL + "','True','ShipperExport');", true);
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "AvailableShipper", "AvailShipper('" + orderNo + "');", true);
                }

            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "NoShipper", "alert('PFC Shipper is unavailable for this document');", true);
            }
        }
    }


    #endregion

    #region Packing Slip
    // Added by Slater for Packing Slip processing
    public void ibtnPackSlip_Click(object sender, EventArgs e)
    {
        if ((CustDet.SOrderNumber != "") && (Session["OrderTableName"].ToString() == "SOHeaderRel"))
        {
            DataSet dsShipper = new DataSet();
            string packingSlipNo = CustDet.SOrderNumber.ToLower().Replace("w", "");
            // get the Packing Slip data.
            dsShipper = SqlHelper.ExecuteDataset(ConfigurationManager.ConnectionStrings["PFCRBConnectionString"].ToString(), "pFormPackSlip",
                new SqlParameter("@PackSlip", packingSlipNo));
            if (dsShipper.Tables.Count > 1)
            {
                // set up everything for the Print Utilty and fire it up.
                string printDialogURL = ConfigurationManager.AppSettings["SOESiteURL"].ToString() + "PrintUtility.aspx";
                string strPageTitle = "Packing Slip " + packingSlipNo;
                string strPageUrl = "PackSlipExport.aspx?OrderNo=" + packingSlipNo + "&ScriptX=YES";
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Fax", "OpenPrintDialog('" + strPageUrl + "','Print','','" + Server.UrlEncode(strPageTitle) + "','" + printDialogURL + "','True','ShipperExport');", true);

            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "NoPackSlip", "alert('PFC Packing List is unavailable for this document');", true);
            }
        }
    }


    #endregion


}
