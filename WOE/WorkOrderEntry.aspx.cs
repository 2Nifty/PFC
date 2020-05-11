/********************************************************************************************
 * File	Name			:	WorkOrderEntry.aspx.cs
 * File Type			:	C#
 * Project Name			:	Work Order Entry 
 * Created By			:	Sathish.T
 * Created Date			:	05/26/2010	
 * History*				: 
 * DATE					AUTHOR			                ACTION
 * ****					******				            ******
 * 05/26/2010           Sathish                         Created 
 *********************************************************************************************/

using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Globalization;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.IO;

using System.Text;
using PFC.WOE.DataAccessLayer;
using PFC.WOE.BusinessLogicLayer;

public partial class WorkOrderEntry : System.Web.UI.Page
{
    #region Global Variables
    
    DataUtility dataUtility = new DataUtility();
    WOEntry woEntry = new WOEntry();

    string searchText = "";

    #endregion

    #region Page Load
    
    protected void Page_Load(object sender, EventArgs e)
    {
        //// Register Ajax
        Ajax.Utility.RegisterTypeForAjax(typeof(WorkOrderEntry));       
        ShowMessage("", false);
        //onfocus="javascript:alert('got focus');BorderWipItem('Solid');"
        chkCmdWipItem.InputAttributes.Add("onfocus", "javascript:BorderWipItem('Solid');this.select();");
 
        if (!IsPostBack)
        {
            Session["PODetailID"] = "";
            Session["POHeaderID"] = "";
            Session["POHeaderTableName"] = "POHeader";
            Session["PODetailTableName"] = "PODetail";            
            Session["WOCompTableName"] = "POWOComponent";
            Session["POHeaderColumnName"] = "pPOHeaderID";
            hidSOEURL.Value = ConfigurationManager.AppSettings["SOESiteURL"].ToString();
            //if (Request.QueryString["UserName"] != null)
            if (Request.QueryString["UserName"] == null)
            {
                if (Session["UserName"] == null)
                {
                    ShowMessage("No user name.", false);
                }
                else
                {
                    hidStockStatusUser.Value = Session["UserName"].ToString();
                }
            }
            else
            {
                //ShowMessage(Session["UserName"].ToString(), false);
                hidStockStatusUser.Value = Request.QueryString["UserName"].ToString();
                Session["UserName"] = Request.QueryString["UserName"].ToString();
            }
            ShowMessage(hidStockStatusUser.Value.ToString(), true);
            //hidStockStatusUser.Value = Request.QueryString["UserName"].ToString();
            lnkRefNo.Visible = false;
            ProgMode.Value = "entry";
            // set up the program to operate for WO Receiving
            if (Request.QueryString["ProgMode"] != null)
            {
                ProgMode.Value = Request.QueryString["ProgMode"].ToString();
                scmWOE.SetFocus(txtWONo);
            }
            BindDropDowns();               
            // set up the program to operate for WO Receiving
            if (Session["WOOrderNo"] != null)
            {
                hidReadOnly.Value = "false";
                txtWONo.ReadOnly = false; // to load the order, we are setting this varibale to false;
                txtWONo.Text = Session["WOOrderNo"].ToString();
                btnLoadWO_Click(btnMakeOrder, new EventArgs());
                Session["WOOrderNo"] = null;
            }
        }
        ShowMessage(Session["PODetailID"].ToString(), true);
        SetProgramMode();
        Session["UserName"] = hidStockStatusUser.Value.ToString();
    } 
    
    #endregion
    
    #region Header Section Methods

    private void BindDropDowns()
    {
        DataSet dsLocation = woEntry.GetWOEData("ddllocation", "");
        dataUtility.BindListControls(ddlLocation, "LocName", "LocID", dsLocation.Tables[0], "--- Select ---");

        DataSet dsOrderType = woEntry.GetWOEData("ddlordertype", "WOOrdType");
        dataUtility.BindListControls(ddlOrderType, "ListDesc", "ListValue", dsOrderType.Tables[0], "--- Select ---");
        Session["WOOrderType"] = dsOrderType;

        DataSet dsExpedite = woEntry.GetWOEData("ddlexpedite", "");
        dataUtility.BindListControls(ddlExpeditCd, "Name", "Code", dsExpedite.Tables[0], "--- Select ---");
        dataUtility.BindListFromTables("--- NONE ---", ddlPriorityCd, "TableType='PRI' AND WOApp='Y' ORDER BY TableCd");
    }

    protected void ddlLocation_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            DataTable dtWOHeader = woEntry.InsertWOHeader(ddlLocation.SelectedItem.Value, Session["UserName"].ToString());

            if (dtWOHeader != null && dtWOHeader.Rows.Count > 0)
            {
                LoadWorkOrderEntryHeader(dtWOHeader);
                scmWOE.SetFocus(txtPODItemNo);
            }
            else
            {
                ShowMessage("Work Order Creation Failed.", false);
            }
        }
        catch (Exception ex)
        {
            ShowMessage(ex.ToString(), false);
        }
    }

    protected void btnLoadWO_Click(object sender, EventArgs e)
    {
        try
        {
            if (txtWONo.ReadOnly == false)
            {
                if (woEntry.CheckWONumberAndInitiateSessionVariables(txtWONo.Text))
                {
                    string pPOHeaderID = Session["POHeaderID"].ToString();
                    DataSet dsWOData = woEntry.GetWOEData("loadwo", pPOHeaderID);

                            //ShowMessage("hidReadOnly=" + hidReadOnly.Value.ToString()
                            //    + "InvoiceDt=" + dsWOData.Tables[0].Rows[0]["InvoiceDt"].ToString()
                            //    + "MakeOrderDt=" + dsWOData.Tables[0].Rows[0]["MakeOrderDt"].ToString()
                            //    , false);

                    if (dsWOData != null)
                    {
                        // Set Ready Only hidden variable
                        if (Session["POHeaderTableName"].ToString().ToLower() == "poheaderhist" ||
                            dsWOData.Tables[0].Rows[0]["MakeOrderDt"].ToString() != "" ||
                            dsWOData.Tables[0].Rows[0]["CompleteDt"].ToString() != "" ||
                            dsWOData.Tables[0].Rows[0]["DeleteDt"].ToString() != "")
                        {
                            hidReadOnly.Value = "true";
                        }

                        LoadWorkOrderEntryHeader(dsWOData.Tables[0]);
                        lblPickSts.Text = woEntry.GetWOPickStatus(dsWOData.Tables[0]);

                        if (dsWOData.Tables[1].Rows.Count > 0)
                        {
                            LoadWorkOrderEntryDetail(dsWOData.Tables[1].Rows[0]["pPoDetailID"].ToString());
                            LoadWOComponentGrid();
                        }
                    }

                    // Button Logic
                    btnMakeOrder.Visible = false;
                    btnReleaseOrder.Visible = false;
                    btnReceive.Visible = false;
                    btnDeleteOrder.Visible = false;
                    if (hidReadOnly.Value == "true")
                    {
                        SetWOPageStatus(FormStatus.WOnReadOnlyMode);

                        if (ProgMode.Value == "receiving")
                        {
                            if (dsWOData.Tables[0].Rows[0]["CompleteDt"].ToString() != "")
                            {
                                txtQtyToRec.Enabled = false;
                            }
                            else if (dsWOData.Tables[0].Rows[0]["DeleteDt"].ToString() != "")
                            {
                                txtQtyToRec.Enabled = false;
                            }
                            else if (dsWOData.Tables[0].Rows[0]["InvoiceDt"].ToString() == "")
                            {
                                // do not allow receiving if SO is invoiced
                                ShowMessage("This WO has not been invoiced. Receiving is not available.", false);
                            }
                            else if (dsWOData.Tables[0].Rows[0]["MakeOrderDt"].ToString() == "")
                            {
                                txtQtyToRec.Enabled = false;
                                ShowMessage("This WO has not been made into an order. Receiving is not available.", false);
                            }
                            else
                            {
                                btnReceive.Visible = true;
                                txtQtyToRec.Enabled = true;
                            }
                        }
                        else
                        {
                            ddlPriorityCd.Enabled = false;
                            if (Session["POHeaderTableName"].ToString().ToLower() == "poheaderhist"
                                 || dsWOData.Tables[0].Rows[0]["CompleteDt"].ToString() != ""
                                 || dsWOData.Tables[0].Rows[0]["DeleteDt"].ToString() != "")
                                return;
                            ddlPriorityCd.Enabled = true;
                            if (dsWOData.Tables[0].Rows[0]["MakeOrderDt"].ToString() != "")
                            {
                                btnReleaseOrder.Visible = true;
                            }
                            else
                            {
                                btnMakeOrder.Visible = true;
                                btnDeleteOrder.Visible = true;
                            }
                        }
                    }
                    else
                    {
                        if (ProgMode.Value == "receiving")
                        {
                            if (dsWOData.Tables[0].Rows[0]["CompleteDt"].ToString() != "")
                            {
                                txtQtyToRec.Enabled = false;
                                ddlPriorityCd.Enabled = false;
                            }
                            else if (dsWOData.Tables[0].Rows[0]["DeleteDt"].ToString() != "")
                            {
                                txtQtyToRec.Enabled = false;
                                ddlPriorityCd.Enabled = false;
                            }
                            else if (dsWOData.Tables[0].Rows[0]["InvoiceDt"].ToString() == "")
                            {
                                // do not allow receiving if SO is invoiced
                                txtQtyToRec.Enabled = false;
                                ShowMessage("This WO has not been invoiced. Receiving is not available.", false);
                            }
                            else if (dsWOData.Tables[0].Rows[0]["MakeOrderDt"].ToString() == "")
                            {
                                txtQtyToRec.Enabled = false;
                                ShowMessage("This WO has not been made into an order. Receiving is not available.", false);
                            }
                            else
                            {
                                btnReceive.Visible = true;
                                txtQtyToRec.Enabled = true;
                            }
                        }
                        else
                        {
                            btnMakeOrder.Visible = true;
                            btnDeleteOrder.Visible = true;
                        }
                    }
                    pnlButtons.Update();
                    if (ProgMode.Value == "receiving")
                    {
                        scmWOE.SetFocus(txtQtyToRec);
                    }
                    else
                    {
                        scmWOE.SetFocus(txtQtyToMfg);
                    }
                    if ((dsWOData.Tables[0].Rows[0]["CompleteDt"].ToString() == "")
                        && (dsWOData.Tables[0].Rows[0]["DeleteDt"].ToString() == "")
                        && (ProgMode.Value == "receiving"))
                    {
                        DataTable dtSubPOData = woEntry.GetSubPOs(dsWOData.Tables[0].Rows[0]["POOrderNo"].ToString());
                        if ((dtSubPOData != null) && (dtSubPOData.Rows.Count > 0))
                        {
                            // We have sub-contractor POs
                            Session["SubPOs"] = dtSubPOData;
                            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "SubPOsWindow", "ShowSubPOs();", true);
                        }
                    }
                }
                else
                    ShowMessage("Invalid Order Number.", false);
            }
        }
        catch (Exception ex)
        {
            ShowMessage(ex.ToString(), false);
        }
    }

    private void LoadWorkOrderEntryHeader(DataTable dtWOHeader)
    {
        Session["POHeaderID"] = dtWOHeader.Rows[0]["pPOHeaderID"].ToString();
        //Session["POHeaderTableName"] = "POHeader";

        txtWONo.Text = dtWOHeader.Rows[0]["POOrderNo"].ToString();
        lblMfgName.Text = dtWOHeader.Rows[0]["BuyFromName"].ToString();
        lblMfgCode.Text = dtWOHeader.Rows[0]["BuyFromVendorNo"].ToString();
        lblMfgAddress.Text = dtWOHeader.Rows[0]["BuyFromAddress"].ToString();
        lblMfgAddress2.Text = dtWOHeader.Rows[0]["BuyFromAddress2"].ToString();
        lblMfgCity.Text = dtWOHeader.Rows[0]["BuyFromCity"].ToString();
        lblMfgState.Text = " " + dtWOHeader.Rows[0]["BuyFromState"].ToString();
        lblMfgPincode.Text = " " + dtWOHeader.Rows[0]["BuyFromZip"].ToString();
        lblMfgCountry.Text = dtWOHeader.Rows[0]["BuyFromCountry"].ToString();
        lblMfgPhone.Text = dtWOHeader.Rows[0]["OrderContactPhoneNo"].ToString();
        lblMfgContact.Text = dtWOHeader.Rows[0]["OrderContactName"].ToString();

        lblPckName.Text = dtWOHeader.Rows[0]["ShipToName"].ToString();
        lblPckAddress.Text = dtWOHeader.Rows[0]["ShipToAddress"].ToString();
        lblMfgAddress2.Text = dtWOHeader.Rows[0]["ShipToAddress2"].ToString();
        lblPckCity.Text = dtWOHeader.Rows[0]["ShipToCity"].ToString();
        lblPckState.Text = " " + dtWOHeader.Rows[0]["ShipToState"].ToString();
        lblPckPincode.Text = " " + dtWOHeader.Rows[0]["ShipToZip"].ToString();
        lblPckCountry.Text = dtWOHeader.Rows[0]["ShipToCountry"].ToString();
        lblPckPhone.Text = dtWOHeader.Rows[0]["ShipToPhoneNo"].ToString();
        lblPckContact.Text = dtWOHeader.Rows[0]["ShipToContactName"].ToString();
        lblEntryDt.Text = Convert.ToDateTime(dtWOHeader.Rows[0]["EntryDt"].ToString()).ToShortDateString();
        lblEntryID.Text = dtWOHeader.Rows[0]["EntryID"].ToString();

        lblPickType.Text = dtWOHeader.Rows[0]["OrderRefType"].ToString();
        lblRefNo.Text = dtWOHeader.Rows[0]["SoRefNo"].ToString();
        lblRefNo.Visible = true;
        lnkRefNo.Visible = false;
        if (lblPickType.Text == "SO")
        {
            lblRefNo.Visible = false;
            lnkRefNo.Visible = true;
            lnkRefNo.Text = dtWOHeader.Rows[0]["SoRefNo"].ToString();
            lnkRefNo.Target = "_blank";
            lnkRefNo.NavigateUrl = ConfigurationManager.AppSettings["SOESiteURL"].ToString();
            lnkRefNo.NavigateUrl += "SORecall/SORecall.aspx?DocNo=" + dtWOHeader.Rows[0]["SoRefNo"].ToString() + "&DocType=R";
        }
        lblWOStatus.Text = woEntry.GetWOStatus(dtWOHeader);
        lblTotCost.Text = Math.Round( Convert.ToDecimal((dtWOHeader.Rows[0]["TotalCost"].ToString() == "" ? "0.00" : dtWOHeader.Rows[0]["TotalCost"].ToString())),2).ToString();
        lblTotWght.Text = Math.Round(Convert.ToDecimal((dtWOHeader.Rows[0]["TotalNetWeight"].ToString() == "" ? "0.00" : dtWOHeader.Rows[0]["TotalNetWeight"].ToString())), 2).ToString();
        lnbtnComments.Font.Underline = ((dtWOHeader.Rows[0]["POCommentsInd"].ToString() == "" || dtWOHeader.Rows[0]["POCommentsInd"].ToString() == "N") ? false : true);
        lnbtnExpense.Font.Underline = ((dtWOHeader.Rows[0]["POExpenseInd"].ToString() == "" || dtWOHeader.Rows[0]["POExpenseInd"].ToString() == "N") ? false : true);
        if (dtWOHeader.Rows[0]["CompleteDt"].ToString() != "")
        {
            ShowMessage("WO is Closed", false);
            lblClosedDateTitle.Visible = true;
            lblClosedDateData.Text = dtWOHeader.Rows[0]["CompleteDt"].ToString();
            lblClosedDateData.Visible = true;

        }
        if (dtWOHeader.Rows[0]["DeleteDt"].ToString() != "")
            ShowMessage("WO is Deleted", false);

        //ShowMessage("PO Type is " + dtWOHeader.Rows[0]["POType"].ToString(), false);
        dataUtility.SetListControlValue(ddlOrderType, dtWOHeader.Rows[0]["POType"].ToString());
        dataUtility.SetListControlValue(ddlExpeditCd, dtWOHeader.Rows[0]["OrderExpdCd"].ToString());
        dataUtility.SetListControlValue(ddlLocation, dtWOHeader.Rows[0]["LocationCd"].ToString());
        dpPickShtDt.SelectedDate = (dtWOHeader.Rows[0]["PickSheetDt"].ToString() != "" ? Convert.ToDateTime(dtWOHeader.Rows[0]["PickSheetDt"].ToString()).ToShortDateString() : dtWOHeader.Rows[0]["PickSheetDt"].ToString());
        dataUtility.SetListControlValue(ddlPriorityCd, dtWOHeader.Rows[0]["PriorityCd"].ToString());


        btnMakeOrder.Visible = true;
        btnDeleteOrder.Visible = true;
        PrintDialogue1.Visible = true;
        BindPrintDialog();

        if (pnlCmdLine.Visible) pnlCmdLine.Update();
        pnlButtons.Update();
        SetWOPageStatus(FormStatus.WOOpened);
    }
    
    private void SetWOPageStatus(FormStatus formStatus)
    {
        if (formStatus == FormStatus.WOOpened)
        {
            ddlLocation.Enabled = false;
            txtWONo.ReadOnly = true;
            lblMfgComma.Visible = true;
            lblPckComma.Visible = true;
            lblMfgContactDesc.Visible = true;
            lblPckContactDesc.Visible = true;

            txtCmdItemNo.ReadOnly = false;
            txtCmdQtyPer.ReadOnly = false;
            txtCmdUnitCost.ReadOnly = false;
            txtPODItemNo.ReadOnly = false;
            txtQtyToMfg.ReadOnly = false;
            ddlPriorityCd.Enabled = true;
            dpPickShtDt.ReadOnly = false;
            dpReqDt.ReadOnly = false;
        }
        else if (formStatus == FormStatus.WOClosed)
        {
            // This method used to delete the WO if it has no WO lines[Ref# WO2283.5]
            if (Session["POHeaderID"] != null
                && Session["POHeaderID"].ToString() != ""
                && txtPODItemNo.Text.Trim() == "")
            {
                woEntry.DeleteWorkOrder(Session["POHeaderID"].ToString());
            }

            ddlPriorityCd.Enabled = false;
            Session["PODetailID"] = "";
            Session["POHeaderID"] = "";
            if (ProgMode.Value == "receiving")
            {
                ScriptManager.RegisterClientScriptBlock(btnClose, btnClose.GetType(), "reloadWOE", "location.href='WorkOrderEntry.aspx?ProgMode=receiving';", true);
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(btnClose, btnClose.GetType(), "reloadWOE", "location.href='WorkOrderEntry.aspx';", true);
            }
            return;
        }
        else if (formStatus == FormStatus.WOnReadOnlyMode)
        {
            ddlLocation.Enabled = false;
            ddlExpeditCd.Enabled = false;
            ddlOrderType.Enabled = false;
            txtPODItemNo.ReadOnly = true;
            txtWONo.ReadOnly = true;
            txtPODItemNo.ReadOnly = true;
            txtQtyToMfg.ReadOnly = true;  
            dpPickShtDt.ReadOnly = true;
            dpReqDt.ReadOnly = true;

            txtCmdItemNo.ReadOnly = true;
            txtCmdQtyPer.ReadOnly = true;
            txtCmdUnitCost.ReadOnly = true;
            btnDeleteOrder.Visible = false;

            scmWOE.SetFocus(txtWONo);          
        }

        pnlHeader.Update();
        pnlWOSummary.Update();
        pnlWODetail.Update();
        pnlWOGrid.Update();
        if (pnlCmdLine.Visible) pnlCmdLine.Update();
        pnlButtons.Update();
        pnlExport.Update();
    }

    private void ReLoadWOSummary(string pPoHeaderId)
    {
        DataSet dsSummary = woEntry.GetWOEData("getwosummary", pPoHeaderId);

        if (dsSummary != null && dsSummary.Tables[0].Rows.Count > 0)
        {
            lblTotCost.Text = dsSummary.Tables[0].Rows[0]["TotalCost"].ToString();
            lblTotWght.Text = dsSummary.Tables[0].Rows[0]["TotalNetWeight"].ToString();

            lnbtnComments.Font.Underline = ((dsSummary.Tables[0].Rows[0]["POCommentsInd"].ToString() == "" || dsSummary.Tables[0].Rows[0]["POCommentsInd"].ToString() == "N" ) ? false : true);
            lnbtnExpense.Font.Underline = ((dsSummary.Tables[0].Rows[0]["POExpenseInd"].ToString() == "" || dsSummary.Tables[0].Rows[0]["POExpenseInd"].ToString() == "N") ? false : true);
        }

        pnlWOSummary.Update();
    }
    
    private void SetWOPickStatus(DataTable dtWOHeader)
    {
        if (dtWOHeader.Rows[0]["HoldDt"].ToString() != "") // For HW & HI orders
        {
            if (dtWOHeader.Rows[0]["HoldReason"].ToString().Trim() == "HW")
            {
                lblPickSts.Text = "On Hold";
            }
            else if (dtWOHeader.Rows[0]["HoldReason"].ToString().Trim() == "HI")
            {
                if (dtWOHeader.Rows[0]["ConfirmShipDt"].ToString() != "")
                    lblPickSts.Text = "Shipped";
                else if (dtWOHeader.Rows[0]["PickCompDt"].ToString() != "")
                    lblPickSts.Text = "Picked";
                else if (dtWOHeader.Rows[0]["PickDt"].ToString() != "")
                    lblPickSts.Text = "Picking";
                else if (dtWOHeader.Rows[0]["RlsWhseDt"].ToString() != "")
                    lblPickSts.Text = "Warehouse";
                else
                    lblPickSts.Text = "Pending";
            }
        }
        else
        {
            if (dtWOHeader.Rows[0]["AllocDt"].ToString() == "")
            {
                lblPickSts.Text = "";
            }
            if (dtWOHeader.Rows[0]["AllocDt"].ToString() != "" && dtWOHeader.Rows[0]["MakeOrderDt"].ToString() != "")
            {
                if (dtWOHeader.Rows[0]["ConfirmShipDt"].ToString() != "")
                    lblPickSts.Text = "Shipped";
                else if (dtWOHeader.Rows[0]["PickCompDt"].ToString() != "")
                    lblPickSts.Text = "Picked";
                else if (dtWOHeader.Rows[0]["PickDt"].ToString() != "")
                    lblPickSts.Text = "Picking";
                else if (dtWOHeader.Rows[0]["RlsWhseDt"].ToString() != "")
                    lblPickSts.Text = "Warehouse";
                else
                    lblPickSts.Text = "Pending";
            }
            //if (dtWOHeader.Rows[0]["InvoiceDt"].ToString().Trim() != "" || dtWOHeader.Rows[0]["DeleteDt"].ToString().Trim() != "") // For invoiced orders
            //{
            //    lblPickSts.Text = (dtWOHeader.Rows[0]["SubType"].ToString().Trim() == "53" ? "Received" : "Shipped");                    
            //}
        }      
        
    }

    private void SetProgramMode()
    {
        if (ProgMode.Value == "receiving" && hidReadOnly.Value != "true")
        {
            lblQtyToRec.Visible = true;
            txtQtyToRec.Visible = true;
            pnlCmdLine.Visible = false;
            txtQtyToMfg.Visible = false;
            lblQtyToMfg.Visible = true;
            ddlLocation.Enabled = false;
            ddlExpeditCd.Enabled = false;
            ddlOrderType.Enabled = false;
        }
        else
        {
            lblQtyToRec.Visible = false;
            txtQtyToRec.Visible = false;
            pnlCmdLine.Visible = true;
            txtQtyToMfg.Visible = true;
            lblQtyToMfg.Visible = false;
        }
        //pnlWODetail.Update();

    }

    #endregion

    #region Detail Section Methods

    protected void btnPopulatePODetail_Click(object sender, EventArgs e)
    {
        try
        {
            if (Session["PODetailID"].ToString() == "")
            {
                string poDetailID = woEntry.InsertPODetail(txtPODItemNo.Text, Session["POHeaderID"].ToString(), Session["UserName"].ToString());

                if (poDetailID != "0")
                {
                    Session["PODetailID"] = poDetailID;

                    // After populating the detail tables, read the data from DB
                    LoadWorkOrderEntryDetail(poDetailID);
                    LoadWOComponentGrid();

                    // Reload Header since pick sheet date is set in WODetail line creation process
                    DataSet dsWOData = woEntry.GetWOEData("loadwo", Session["POHeaderID"].ToString());
                    LoadWorkOrderEntryHeader(dsWOData.Tables[0]);
                    txtPODItemNo.ReadOnly = true;
                }
                else
                {
                    ShowMessage("Work Order Detail ID Creation Failed.", false);
                }
            }
            scmWOE.SetFocus(txtQtyToMfg);
        }
        catch (Exception ex)
        {
            ShowMessage(ex.ToString(), false);
        }
    }

    private void LoadWorkOrderEntryDetail(string poDetailId)
    {
        DataSet dsWODetail = woEntry.GetWOEData("podetail", poDetailId);
        if (dsWODetail != null)
        {
            Session["PODetailID"] = poDetailId;
            txtPODItemNo.Text = dsWODetail.Tables[0].Rows[0]["ItemNo"].ToString();
            hidStockStatusItem.Value = dsWODetail.Tables[0].Rows[0]["ItemNo"].ToString();
            lblQtyReceived.Text = dsWODetail.Tables[0].Rows[0]["QtyReceived"].ToString();
            lblHdDesription.Text = dsWODetail.Tables[0].Rows[0]["ItemDesc"].ToString();
            lblPckQtyUOM.Text = string.Format("{0:#,##0}", Convert.ToInt32(dsWODetail.Tables[0].Rows[0]["SellStkUMQty"].ToString())) 
                + "/" + dsWODetail.Tables[0].Rows[0]["BaseQtyUM"].ToString();
            if(dsWODetail.Tables[0].Rows[0]["PalletQty"].ToString().Trim() != "")
                lblPalletQty.Text = string.Format("{0:#,##0}",Convert.ToInt32(dsWODetail.Tables[0].Rows[0]["PalletQty"].ToString())); 
            lblReOrdPoint.Text = dsWODetail.Tables[0].Rows[0]["ReOrderPoint"].ToString();
            txtQtyToMfg.Text = dsWODetail.Tables[0].Rows[0]["QtyOrdered"].ToString();
            lblQtyToMfg.Text = dsWODetail.Tables[0].Rows[0]["QtyOrdered"].ToString();
            txtQtyToRec.Text = string.Format("{0:####,###,##0}", (decimal)dsWODetail.Tables[0].Rows[0]["QtyOrdered"]
            - (decimal)dsWODetail.Tables[0].Rows[0]["QtyReceived"]);
            dpReqDt.SelectedDate = (dsWODetail.Tables[0].Rows[0]["RequestedReceiptDt"].ToString() != "" ? Convert.ToDateTime(dsWODetail.Tables[0].Rows[0]["RequestedReceiptDt"].ToString()).ToShortDateString() : dsWODetail.Tables[0].Rows[0]["RequestedReceiptDt"].ToString());

        }

        pnlWODetail.Update();
    }

    private void LoadWOComponentGrid()
    {
        try
        {
            DataSet dsWOComp = woEntry.GetWOEData("loadwolines", Session["POHeaderID"].ToString());

            if (dsWOComp != null)
            {
                if (hidShowAll.Value != "true")
                {
                    dsWOComp.Tables[0].DefaultView.RowFilter = "DeleteDt is null";
                    dgWOLines.Columns[dgWOLines.Columns.Count - 2].Visible = false;
                }
                else
                {
                    dgWOLines.Columns[dgWOLines.Columns.Count - 2].Visible = true;
                }

                if (searchText != "")
                    dsWOComp.Tables[0].DefaultView.RowFilter = searchText;

                dgWOLines.DataSource = dsWOComp.Tables[0].DefaultView.ToTable();
            }
            else
                dgWOLines.DataSource = null;

            dgWOLines.DataBind();
            pnlWOGrid.Update();
        }
        catch (Exception ex)
        {
            ShowMessage(ex.ToString(), false);
        }
    }

    protected void btnUpdatePODetail_Click(object sender, EventArgs e)
    {
        string columnValues =   "QtyOrdered=" + txtQtyToMfg.Text + "," +
                                "ChangeID='" + Session["UserName"].ToString() + "'," +
                                "ChangeDt='" + DateTime.Now.ToString() + "'";

        dataUtility.UpdateTableData("PODetail", columnValues ,"pPODetailID=" + Session["PoDetailID"].ToString());
        woEntry.ReExtendWOLines(Session["POHeaderID"].ToString(), Convert.ToInt32(txtQtyToMfg.Text), Session["UserName"].ToString());
        
        LoadWOComponentGrid();
        ReLoadWOSummary(Session["PoHeaderID"].ToString());
        scmWOE.SetFocus("txtCmdItemNo");
    }

    protected void btnUpdatePriority_Click(object sender, EventArgs e)
    {
        string columnValues = "PriorityCd='" + ddlPriorityCd.SelectedValue.ToString() + "'," +
                                "ChangeID='" + Session["UserName"].ToString() + "'," +
                                "ChangeDt='" + DateTime.Now.ToString() + "'";

        dataUtility.UpdateTableData("POHeader", columnValues, "pPOHeaderID=" + Session["PoHeaderID"].ToString());
        //scmWOE.SetFocus("txtCmdItemNo");
    }

    protected void dgWOLines_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Label _lblPFCItemNo = e.Item.FindControl("lblPFCItemNo") as Label;
            HiddenField _hidWOCompId = e.Item.FindControl("hidpWoCompId") as HiddenField;
            TextBox _txtUnitCost = e.Item.FindControl("txtUnitCost") as TextBox;
            try
            {
                if (hidReadOnly.Value != "true")
                    _lblPFCItemNo.Attributes.Add("onmousedown", "if(document.getElementById('hidRowID').value != '')document.getElementById(document.getElementById('hidRowID').value).style.fontWeight='normal';DeleteWOLine('" + _hidWOCompId.Value.Trim() + "',this.id,event); document.getElementById('" + e.Item.ClientID + "').style.fontWeight='bold';hidRowID.value='" + e.Item.ClientID + "'");
                else
                {
                    _txtUnitCost.ReadOnly = true;
                }
                if (ProgMode.Value == "receiving")
                {
                    _txtUnitCost.ReadOnly = false;
                }
            }
            catch (Exception ex)
            {
                ShowMessage(ex.ToString(), false);
            }
        }
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        dataUtility.UpdateTableData("WOComponent", 
                                    "DeleteDt='" + DateTime.Now.ToString() + "'", 
                                    "pWOComponentId='" + hidDeleteWoCompId.Value + "'");

        LoadWOComponentGrid();
        
        // After Delete Reextend the orders to get the correct order total
        woEntry.ReExtendWOLines(Session["POHeaderID"].ToString(), Convert.ToInt32(txtQtyToMfg.Text), Session["UserName"].ToString());
        ReLoadWOSummary(Session["PoHeaderID"].ToString());
        pnlButtons.Update();
        //pnlWOSummary.Update();
        if (pnlCmdLine.Visible) pnlCmdLine.Update();
    }

    #endregion

    #region Command Line Methods

    protected void btnMakeOreder_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            if (txtQtyToMfg.Text.Trim() == "0" || txtQtyToMfg.Text.Trim() == "")
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "MakeOrdValidation", "alert('Invalid Qty to Mfg.');", true);
                return;
            }
            
            woEntry.RunMakeOrderProcess(Session["POHeaderID"].ToString());
            //hidReadOnly.Value = "false";
            //txtWONo.ReadOnly = false; // to reload the order, we are setting this varibale to false;
            //btnLoadWO_Click(btnMakeOrder, new EventArgs());
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "ordercomplete", "alert('Work order updated successfully.');", true);
            SetWOPageStatus(FormStatus.WOClosed);
        }
        catch (Exception ex)
        {
            ShowMessage("Make Order Process Failed.", false);
        }
    }

    protected void btnReleaseOrder_Click(object sender, ImageClickEventArgs e)
    {
        string ReleaseStat = "";
        try
        {
            ReleaseStat = woEntry.RunReleaseOrderProcess(Session["POHeaderID"].ToString());
            if (ReleaseStat == "WO Released")
            {
                hidReadOnly.Value = "false";
                txtWONo.ReadOnly = false; // to reload the order, we are setting this varibale to false;
                btnLoadWO_Click(btnMakeOrder, new EventArgs());
                ShowMessage(ReleaseStat, true);                
            }
            else
            {
                ShowMessage("Unable To Release - " + ReleaseStat, false);
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Release Order Process Failed.<br>" + ex.ToString(), false);
        }
        pnlExport.Update();
    }

    protected void btnReceive_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            decimal QtyReceived;
            decimal QtyToMfg;
            decimal QtyToReceive;
            QtyReceived = decimal.Parse(lblQtyReceived.Text, NumberStyles.Number);
            QtyToMfg = decimal.Parse(lblQtyToMfg.Text, NumberStyles.Number);
            if (!decimal.TryParse(txtQtyToRec.Text.ToString(), out QtyToReceive))
            {
                ShowMessage("Invalid Qty To Receive", false);
                scmWOE.SetFocus(txtQtyToRec);
                return;
            }
            if (QtyToReceive + QtyReceived > QtyToMfg)
            {
                ShowMessage("Cannot Receive more the the Mfg Qty", false);
                scmWOE.SetFocus(txtQtyToRec);
                return;
            }
            // Check WIP Over Receipt
            DataTable dsOverReceipt = woEntry.CheckWipOverReceipt(Session["POHeaderID"].ToString(), QtyToReceive);
            hdInsufficientWipInd.Value = "N";
            if (dsOverReceipt.Rows.Count > 0)
            {
                if (dsOverReceipt.Rows[0]["InsufficientWipInd"].ToString().Trim() == "N")
                {
                    if (QtyToReceive + QtyReceived == QtyToMfg)
                    {
                        woEntry.ReceiveWO(Session["PODetailID"].ToString(), QtyToReceive, "Complete", "N");
                        btnReceive.Visible = false;
                        pnlButtons.Update();
                        SetWOPageStatus(FormStatus.WOClosed);
                        LoadWorkOrderEntryDetail(Session["PODetailID"].ToString());
                        ReLoadWOSummary(Session["POHeaderID"].ToString());
                    }
                    if (QtyToReceive + QtyReceived < QtyToMfg)
                    {
                        hdReceiveMethod.Value = "";
                        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ChooseReceipt", "GetReceiptType();", true);
                    }
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "WipOverPrompt", "CheckWipOverReceipt('" + string.Format("{0:###,##0}", dsOverReceipt.Rows[0]["TotRecQty"]) + "','" + string.Format("{0:###,##0}", dsOverReceipt.Rows[0]["PickedQty"]) + "');", true);
                }
            }
            else
            {
                ShowMessage("WIP Over Receipt Check Failure", false);
                scmWOE.SetFocus(txtQtyToRec);
            }
        }
        catch (Exception ex)
        {
            ShowMessage("Receipt Process Failed.<BR>" + ex.ToString(), false);
        }
    }

    protected void btnProcessWipOverRcpt_Click(object sender, EventArgs e)
    {
        decimal QtyReceived;
        decimal QtyToMfg;
        decimal QtyToReceive;
        try
        {
            QtyReceived = decimal.Parse(lblQtyReceived.Text, NumberStyles.Number);
            QtyToMfg = decimal.Parse(lblQtyToMfg.Text, NumberStyles.Number);
            QtyToReceive = decimal.Parse(txtQtyToRec.Text, NumberStyles.Number);
            hdInsufficientWipInd.Value = "Y";
            if (QtyToReceive + QtyReceived == QtyToMfg)
            {
                woEntry.ReceiveWO(Session["PODetailID"].ToString(), QtyToReceive, "Complete", "Y");
                SetWOPageStatus(FormStatus.WOClosed);
                LoadWorkOrderEntryDetail(Session["PODetailID"].ToString());
                ReLoadWOSummary(Session["POHeaderID"].ToString());
                ShowMessage("Complete receipt complete. This WO is closed", true);
                btnReceive.Visible = false;
                pnlButtons.Update();
            }
            if (QtyToReceive + QtyReceived < QtyToMfg)
            {
                hdReceiveMethod.Value = "";
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "ChooseReceipt", "GetReceiptType();", true);
            }
        }
        catch (Exception ex)
        {
            ShowMessage("btnProcessWipOverRcp Failed.<BR>" + ex.ToString(), false);
        }
    }

    protected void btnProcessChoice_Click(object sender, EventArgs e)
    {
        try
        {
            string RecptMessage = "";
            decimal QtyToReceive;
            QtyToReceive = decimal.Parse(txtQtyToRec.Text, NumberStyles.Number); 
            switch (hdReceiveMethod.Value)
            {
                case "Partial":
                    RecptMessage = "Partial receipt complete. This WO is still open";
                    break;
                case "Short":
                    RecptMessage = "Short receipt complete. This WO is closed";
                    //SetWOPageStatus(FormStatus.WOClosed);
                    break;
                case "Complete":
                    RecptMessage = "Complete receipt complete. This WO is closed";
                    //SetWOPageStatus(FormStatus.WOClosed);
                    break;
            }
            woEntry.ReceiveWO(Session["PODetailID"].ToString(), QtyToReceive, hdReceiveMethod.Value, hdInsufficientWipInd.Value);
            LoadWorkOrderEntryDetail(Session["PODetailID"].ToString());
            ReLoadWOSummary(Session["POHeaderID"].ToString());
            ShowMessage(RecptMessage, true);
            btnReceive.Visible = false;
            pnlButtons.Update();
        }
        catch (Exception ex)
        {
            ShowMessage("ProcessChoice Failed.<BR>" + ex.ToString(), false);
        }
    }

    protected void btnClose_Click(object sender, ImageClickEventArgs e)
    {
        if(txtWONo.Text != "")
            SetWOPageStatus(FormStatus.WOClosed);
        else
            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Load", "parent.window.close();", true);
    }

    protected void btnDeleteOrder_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            woEntry.DeleteWorkOrder(Session["POHeaderID"].ToString());

            hidReadOnly.Value = "false";
            txtWONo.ReadOnly = false; // to reload the order, we are setting this varibale to false;
            btnLoadWO_Click(btnMakeOrder, new EventArgs());
        }
        catch (Exception ex)
        {
            ShowMessage("Delete Order Process Failed.", false);
        }
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {

        if (txt_AvailQty.Text.Trim() == "" && txt_ExtCost.Text == "" && txt_ExtQty.Text == "" && txt_Item.Text == "" && txt_QtyPerUOM.Text == "" &&
            txt_LineNotes.Text == "" && txt_NextAvailDt.Text == "" && txt_NextAvailQty.Text == "" && txt_PFCItem.Text == "" &&
            txt_QtyPer.Text.Trim() == "" && txt_UnitCost.Text == "")
        {
            searchText = "";
            LoadWOComponentGrid();
            return;
        }

        searchText = ((txt_Item.Text != "") ? ((searchText.Trim() != "") ? searchText + " And ItemNo='" + txt_Item.Text.Trim() + "'" : "ItemNo='" + txt_Item.Text.Trim() + "'") : searchText);
        searchText = ((txt_PFCItem.Text != "") ? ((searchText.Trim() != "") ? searchText + searchText + " And ItemDesc  ='" + txt_PFCItem.Text + "'" : "ItemDesc  ='" + txt_PFCItem.Text + "'") : searchText);
        searchText = ((txt_QtyPer.Text != "") ? ((searchText.Trim() != "") ? searchText + " And QtyPer='" + txt_QtyPer.Text.Trim() + "'" : "QtyPer='" + txt_QtyPer.Text.Trim() + "'") : searchText);
        searchText = ((txt_QtyPerUOM.Text != "") ? ((searchText.Trim() != "") ? searchText + searchText + " And QtyPerUM  ='" + txt_QtyPerUOM.Text + "'" : "QtyPerUM  ='" + txt_QtyPerUOM.Text + "'") : searchText);
        searchText = ((txt_ExtQty.Text != "") ? ((searchText.Trim() != "") ? searchText + " And ExtendedQty='" + txt_ExtQty.Text.Trim() + "'" : "ExtendedQty='" + txt_ExtQty.Text.Trim() + "'") : searchText);
        searchText = ((txt_AvailQty.Text.Trim() != "") ? ((searchText.Trim() != "") ? searchText + " And AvailQty ='" + txt_AvailQty.Text.Trim() + "'" : "AvailQty='" + txt_AvailQty.Text.Trim() + "'") : searchText);
        searchText = ((txt_NextAvailQty.Text.Trim() != "") ? ((searchText.Trim() != "") ? searchText + " And NextAvailQty='" + txt_NextAvailQty.Text.Trim() + "'" : "NextAvailQty='" + txt_NextAvailQty.Text + "'") : searchText);
        searchText = ((txt_NextAvailDt.Text.Trim() != "") ? ((searchText.Trim() != "") ? searchText + " And NextAvailDt='" + txt_NextAvailDt.Text.Trim() + "'" : "NextAvailDt='" + txt_NextAvailDt.Text.Trim() + "'") : searchText);
        searchText = ((txt_UnitCost.Text != "") ? ((searchText.Trim() != "") ? searchText + " And UnitCost='" + txt_UnitCost.Text.Trim() + "'" : "UnitCost='" + txt_UnitCost.Text.Trim() + "'") : searchText);
        searchText = ((txt_ExtCost.Text.Trim() != "") ? ((searchText.Trim() != "") ? searchText + " And ExtendedCost ='" + txt_ExtCost.Text.Trim() + "'" : "ExtendedCost='" + txt_ExtCost.Text.Trim() + "'") : searchText);
        searchText = ((txt_LineNotes.Text != "") ? ((searchText.Trim() != "") ? " And LineNotes='" + txt_LineNotes.Text + "'" : "LineNotes='" + txt_LineNotes.Text + "'") : searchText);

        // Call the datagrid to bind the search details
        LoadWOComponentGrid();
        ScriptManager.RegisterClientScriptBlock(btnSearch, typeof(Button), "", "document.getElementById('tblSearch').style.display='';", true);

    }

    private void BindPrintDialog()
    {
        PrintDialogue1.CustomerNo = "00001";
        string pageURL = "";
        PrintDialogue1.PageTitle = "Work Order for WO#  " + txtWONo.Text;
        PrintDialogue1.FormName = "WorkOrderExport";
        pageURL = Server.UrlEncode("WorkOrderExport.aspx?WorkOrder=" + txtWONo.Text + "&UserName=" + Session["UserName"].ToString().Trim());
        
        PrintDialogue1.PageUrl = pageURL;
    }

    protected void btnGetItemInfo_Click(object sender, EventArgs e)
    {
        DataTable dtItemData = woEntry.GetItemDetail(txtCmdItemNo.Text, ddlLocation.SelectedItem.Value);
        if (dtItemData != null && dtItemData.Rows.Count > 0)
        {
            txtCmdUOM.Text = dtItemData.Rows[0]["BaseUOM"].ToString();
            txtCmdQtyPer.Text = "0";
            txtCmdUnitCost.Text = dtItemData.Rows[0]["UnitCost"].ToString();
            lblCmdUnitCost.Text = dtItemData.Rows[0]["UnitCost"].ToString();
            lblCmdCostOrigin.Text = dtItemData.Rows[0]["CostOrigin"].ToString();
            lblCmdDesription.Text = dtItemData.Rows[0]["ItemDesc"].ToString();
            if (txtCmdItemNo.Text.Length >6 && txtCmdItemNo.Text.Substring(0, 5) != "99996") chkCmdWipItem.Checked = true;
            hidBaseUOM.Value = dtItemData.Rows[0]["BaseUOM"].ToString();
            hidAvailQty.Value = dtItemData.Rows[0]["AvailQty"].ToString();
            hidNextAvailQty.Value = dtItemData.Rows[0]["NextAvailQty"].ToString();
            hidNextAvailDt.Value = dtItemData.Rows[0]["NextAvailDt"].ToString();

            scmWOE.SetFocus(txtCmdQtyPer);
        }
        else
        {
            ShowMessage("Invalid Item Number.", false);
        }
    }

    protected void btnGetUOMInfo_Click(object sender, EventArgs e)
    {
        if (!woEntry.GetUOM(txtCmdItemNo.Text, txtCmdUOM.Text))
        {
            ShowMessage("Invalid Unit of Measure (UOM).", false);
        }
        else
        {
            scmWOE.SetFocus(txtCmdUnitCost);
        }
    }

    protected void txtCmdUnitCost_TextChanged(object sender, EventArgs e)
    {
        lblCmdCostOrigin.Text = "E";
        scmWOE.SetFocus(chkCmdWipItem);
    }

    protected void btnAddCmdLine_Click(object sender, EventArgs e)
    {
        if (lblCmdDesription.Text != "")
        {
            decimal UnitCost = 0;
            if (decimal.TryParse(txtCmdUnitCost.Text.Replace(",", ""), out UnitCost))
            {
                string columnNames = "fBOMID,fPOHeaderID,ItemNo,ItemDesc,QtyPer,ExtendedQty,QtyToMfg,UnitCost," +
                                         "ExtendedCost,AvailQty,NextAvailQty,QtyPerUM,EntryID,EntryDt,WIPItemInd";
                string WipItemInd = "N";
                if (chkCmdWipItem.Checked) WipItemInd = "Y";
                if ((txtCmdItemNo.Text.Trim().Length > 5) && (txtCmdItemNo.Text.Substring(0, 5) == "99996")) WipItemInd = "C";

                string columnValues = "'0000'," +
                                        "'" + Session["POHeaderID"].ToString() + "'," +
                                        " '" + txtCmdItemNo.Text + "'," +
                                        "'" + lblCmdDesription.Text + "'," +
                                        "'" + txtCmdQtyPer.Text + "'," +
                                        "" + txtCmdQtyPer.Text + "*" + txtQtyToMfg.Text + "," +
                                        "'" + txtQtyToMfg.Text + "'," +
                                        "'" + txtCmdUnitCost.Text + "'," +
                                        "" + txtCmdUnitCost.Text + "*" + txtCmdQtyPer.Text + "*" + txtQtyToMfg.Text + "," +
                                        "'" + hidAvailQty.Value.Trim() + "'," +
                                        "'" + hidNextAvailQty.Value.Trim() + "'," +
                                        "'" + txtCmdUOM.Text.Trim() + "'," +
                                        "'" + Session["UserName"].ToString() + "'," +
                                        "'" + DateTime.Now.ToString() + "'," +
                                        "'" + WipItemInd + "'";

                if (hidNextAvailDt.Value != "")
                {
                    columnNames += ",NextAvailDt";
                    columnValues += ",'" + hidNextAvailDt.Value + "'";
                }

                woEntry.InsertTableData("WOComponent", columnNames, columnValues);
                woEntry.ReExtendWOLines(Session["POHeaderID"].ToString(), Convert.ToInt32(txtQtyToMfg.Text), Session["UserName"].ToString());

                ClearCommandLine();
                LoadWOComponentGrid();
                ReLoadWOSummary(Session["PoHeaderID"].ToString());

                scmWOE.SetFocus(txtCmdItemNo);
            }
            else
            {
                ShowMessage("Unit Cost is Invalid", false);
                scmWOE.SetFocus(txtCmdUnitCost);
            }
        }

    }

    protected void btnShowAll_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton imgcommon = sender as ImageButton;
        string whereClause = string.Empty;

        if (imgcommon.ImageUrl == "~/Common/Images/expand.gif")
        {
            // Code to show delete column
            hidShowAll.Value = "true";

            imgcommon.ImageUrl = "~/Common/Images/expt.gif";
            imgcommon.ToolTip = "Clike here to Show Item";
        }
        else
        {
            hidShowAll.Value = "false";
            // Code to hide the delete falg columns
            dgWOLines.Columns[dgWOLines.Columns.Count - 2].Visible = false;
            imgcommon.ImageUrl = "~/Common/Images/expand.gif";
            imgcommon.ToolTip = "Clike here to Show Deleted Item";
        }

        LoadWOComponentGrid();
    }

    private void ClearCommandLine()
    {
        txtCmdItemNo.Text = "";
        txtCmdQtyPer.Text = "";
        txtCmdUOM.Text = "";
        txtCmdUnitCost.Text = "";
        chkCmdWipItem.Checked = false;
        lblCmdUnitCost.Text ="";
        lblCmdDesription.Text = "";
        lblCmdCostOrigin.Text = "";
        hidBaseUOM.Value = "";
    }

    #endregion

    #region Utility Method

    private void ShowMessage(string message, bool isValid)
    {
        lblMessage.ForeColor = (isValid) ? System.Drawing.Color.Green : System.Drawing.Color.Red;
        lblMessage.Text = message;
        pnlProgress.Update();
    }

    #endregion 

    #region Ajax Methods

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string[] UpdateWOLines(string fieldType, string pWOCompId,string fieldValue)
    {
        string[] arrWOLine = new string[10];
        DataTable dtWOLine = new DataTable();

        if (fieldType == "UnitCost")
        {
            dtWOLine = woEntry.UpdateWOGridLines("Unitcost", fieldValue, pWOCompId, Session["UserName"].ToString());
        }

        if(dtWOLine != null && dtWOLine.Rows.Count >0)
        {
            arrWOLine[0] = dtWOLine.Rows[0]["ExtendedQty"].ToString();
            arrWOLine[1] = dtWOLine.Rows[0]["ExtendedCost"].ToString();
            arrWOLine[4] = dtWOLine.Rows[0]["PickQty"].ToString();

            DataSet dsSummary = woEntry.GetWOEData("getwosummary",Session["POHeaderID"].ToString());
            if (dsSummary != null && dsSummary.Tables[0].Rows.Count > 0)
            {
                arrWOLine[2] = dsSummary.Tables[0].Rows[0]["TotalCost"].ToString();
                arrWOLine[3] = dsSummary.Tables[0].Rows[0]["TotalNetWeight"].ToString();
            }
        }
        else
            arrWOLine = null;

        return arrWOLine;
        

    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void UpdateOrderContact(string contactName)
    {
        string columnValues = "ShipToContactName='" + contactName.Replace("'","''") + "'";

        dataUtility.UpdateTableData("POHeader", columnValues, "pPOHeaderID=" + Session["POHeaderID"].ToString());
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void UpdatePOHeader(string controlType, string controlValue, string controlText)
    {
        string columnValues = "";
        if (controlType.ToLower() == "wotype")
        {
            DataSet dsWOType = Session["WOOrderType"] as DataSet;
            DataRow[] drWOOrder = dsWOType.Tables[0].Select("ListValue='" + controlValue.Trim() + "'");

            columnValues = "POType='" + drWOOrder[0]["ListValue"] + "'," +
                            "POTypeName='" + drWOOrder[0]["WODesc"] + "'," +
                            "PoSubType='" + drWOOrder[0]["SequenceNo"] + "'";
        }
        else if (controlType.ToLower() == "expedite")
        {
            string[] arrExpedit = controlText.Split('-');

            columnValues = "OrderExpdCd='" + arrExpedit[0].Trim() + "'," +
                            "OrderExpdCdName='" + arrExpedit[1].Trim() + "'";
        }

        dataUtility.UpdateTableData("POHeader", columnValues, "pPOHeaderID=" + Session["POHeaderID"].ToString());
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string CheckItem(string ItemNo)
    {
        string result = "Item=" + ItemNo;
        bool check;
        check = woEntry.CheckItem(ItemNo);
        result = check.ToString();
        //result = woEntry.CheckItemStr(ItemNo);
        return result;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string CheckItemBOM(string ItemNo)
    {
        string result = "Item=" + ItemNo;
        bool check;
        check = woEntry.CheckBOM(ItemNo);
        result = check.ToString();
        return result;
    }
    
    #endregion   

}

