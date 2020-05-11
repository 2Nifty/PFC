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
using PFC.IntranetSite.MaintenanceApps;
public partial class MaintenanceApps_Common_UserControls_Warehouse : System.Web.UI.UserControl
{
    private LocationMaster locationMaster = new LocationMaster();
    public string LocMasterID
    {
        get { return ViewState["LocMasterID"].ToString(); }
    }
    public DataTable SetWarehouseValue
    {

        set
        {
            SetValue(value);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        btnSave.Visible = (Session["LocationMasterSecurity"].ToString() != "") ? true : false; 
        if (!IsPostBack)
        {
            BindDropdownvalue();
        }
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        string updateValue = "UseASNOdomInd	='" + ddlASNOdometer.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "CreateLPNPrmptInd ='" + ddlCreateLPN.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "EndCrtnDocsInd	='" + ddlEndCartonDocs.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "InvoicePrintInd 	='" + ddlInvoicePrint.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "LotTrackInd 	='" + ddlLotTrack.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "PackSlipPrintInd	='" + ddlPackingSlipPrint.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "PalletInd 	='" + ddlPallet.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "PickEndInd	='" + ddlPickEndOrder.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "PrmptBinInd 	='" + ddlPromptRecBin.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "ReceivingMode	='" + ddlReceiveMode.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "ReformToItemInd	='" + ddlReformtoItem.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "RFPrintInd 	 ='" + ddlRFPrint.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "ROPDays		='" + txtROPDays.Text.Trim().Replace("'", "''") + "'," +
                            "SerialNoInd ='" + ddlSerial.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "SerialNoPrintInd	='" + ddlSerialPrint.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "ShippedOrderInd 	='" + ddlShippedOrder.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "ShipLabel	='" + ddlShippingLabel.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "ShipMethCd	='" + ddlShippingMethod.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "ShipModuleInd	 ='" + ddlShippingModule.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "SupportRepInd		='" + ddlSupportRep.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "ILTStartTransInd='" + ddlTransactionSet.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "ComplItemShipInd 	='" + ((chkSelection.Items[0].Selected == true) ? "Y" : "N") + "'," +
                            "ILTBatchControlInd='" + ((chkSelection.Items[1].Selected == true) ? "Y" : "N") + "'," +
                            "ActivatePhyInd='" + ((chkSelection.Items[2].Selected == true) ? "Y" : "N") + "'," +
                            "UseOdomInd	='" + ((chkSelection.Items[3].Selected == true) ? "Y" : "N") + "'," +
                            "DefaultBinInd ='" + ((chkSelection.Items[4].Selected == true) ? "Y" : "N") + "'," +
                            "LPNControlInd='" + ((chkSelection.Items[5].Selected == true) ? "Y" : "N") + "'," +
                            "CartonPrintInd='" + ((chkSelection.Items[6].Selected == true) ? "Y" : "N") + "'," +
                            "AllowPartialRcptsInd='" + ((chkSelection.Items[7].Selected == true) ? "Y" : "N") + "'," +
                            "DefaultItemInd ='" + ((chkSelection.Items[8].Selected == true) ? "Y" : "N") + "'," +
                            "MoveDocPromptInd='" + ((chkSelection.Items[9].Selected == true) ? "Y" : "N") + "'," +
                            "ShipConfirmInd='" + ((chkSelection.Items[10].Selected == true) ? "Y" : "N") + "'," +
                            "UseScaleInd='" + ((chkSelection.Items[11].Selected == true) ? "Y" : "N") + "'," +
                            "UseDefltSellStkUMInd ='" + ((chkSelection.Items[12].Selected == true) ? "Y" : "N") + "'," +
                            "MultiUMInd='" + ((chkSelection.Items[13].Selected == true) ? "Y" : "N") + "'," +
                            "ShipInFullInd='" + ((chkSelection.Items[14].Selected == true) ? "Y" : "N") + "',"+
                            "DefaultFromBinInd ='" + ((chkSelection.Items[15].Selected == true) ? "Y" : "N") + "'," +
                            "VirtualLocationName ='" + txtVLocName.Text.Trim().Replace("'", "''") + "'," +
                            "VirtualLocationNo ='" + txtVLocNo.Text.Trim().Replace("'", "''") + "'," +
                            "VirtualBinZone ='" + txtVLocZone.Text.Trim().Replace("'", "''") + "'," +
                            "ChangeID='" + Session["UserName"].ToString().Trim() + "'," +
                            "ChangeDt='" + DateTime.Now.ToString() + "'";
        
        string whereclause = "LocID=" + LocMasterID;

        locationMaster.UpdateLocationMaster(updateValue, whereclause);


    }
    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        if (chkSelectAll.Checked == true)
            foreach (ListItem li in chkSelection.Items)
                li.Selected = true;
        else
            foreach (ListItem li in chkSelection.Items)
                li.Selected = false;
    }
    private void BindDropdownvalue()
    {
        locationMaster.BindListValue("ASNUseOdom", "-- Select --", ddlASNOdometer);
        locationMaster.BindListValue("LPNInd", "-- Select --", ddlCreateLPN);
        locationMaster.BindListValue("EndCarton", "-- Select --", ddlEndCartonDocs);
        locationMaster.BindListValue("InvPrtInd", "-- Select --", ddlInvoicePrint);
        locationMaster.BindListValue("LotTrackInd", "-- Select --", ddlLotTrack);
        locationMaster.BindListValue("PackSlipInd", "-- Select --", ddlPackingSlipPrint);
        locationMaster.BindListValue("PalletInd", "-- Select --", ddlPallet);
        locationMaster.BindListValue("PickEndInd", "-- Select --", ddlPickEndOrder);
        locationMaster.BindListValue("RecBinPrmpt", "-- Select --", ddlPromptRecBin);
        locationMaster.BindListValue("ReceiveMode", "-- Select --", ddlReceiveMode);
        locationMaster.BindListValue("ReformItemInd", "-- Select --", ddlReformtoItem);
        locationMaster.BindListValue("RFPrintInd", "-- Select --", ddlRFPrint);
        //locationMaster.BindListValue("ROPDaysInd", "-- Select --", ddlROPDays);
        locationMaster.BindListValue("SerialNoInd", "-- Select --", ddlSerial);
        locationMaster.BindListValue("SerialNoPrtInd", "-- Select --", ddlSerialPrint);
        locationMaster.BindListValue("ShipOrdInd", "-- Select --", ddlShippedOrder);
        locationMaster.BindListValue("ShipLabelInd", "-- Select --", ddlShippingLabel);
        locationMaster.BindListValue("ShipModCd", "-- Select --", ddlShippingModule);
        locationMaster.BindListValue("ShipModInd", "-- Select --", ddlShippingMethod);
        locationMaster.BindListValue("SupportRepInd", "-- Select --", ddlSupportRep);
        locationMaster.BindListValue("ILTTransSet", "-- Select --", ddlTransactionSet);
    }
    private void SetValue(DataTable dtValue)
    {

        ViewState["LocMasterID"] = dtValue.Rows[0]["LocID"].ToString();

        SetValueDropDownList(ddlASNOdometer,dtValue.Rows[0]["UseASNOdomInd"].ToString().Trim());
        SetValueDropDownList(ddlCreateLPN,dtValue.Rows[0]["CreateLPNPrmptInd"].ToString().Trim());
        SetValueDropDownList( ddlEndCartonDocs,dtValue.Rows[0]["EndCrtnDocsInd"].ToString().Trim());
        SetValueDropDownList(ddlInvoicePrint,dtValue.Rows[0]["InvoicePrintInd"].ToString().Trim());
        SetValueDropDownList(ddlLotTrack,dtValue.Rows[0]["LotTrackInd"].ToString().Trim());
        SetValueDropDownList(ddlPackingSlipPrint,dtValue.Rows[0]["PackSlipPrintInd"].ToString().Trim());
        SetValueDropDownList(ddlPallet,dtValue.Rows[0]["PalletInd"].ToString().Trim());
        SetValueDropDownList(ddlPickEndOrder,dtValue.Rows[0]["PickEndInd"].ToString().Trim());
        SetValueDropDownList(ddlPromptRecBin,dtValue.Rows[0]["PrmptBinInd"].ToString().Trim());
        SetValueDropDownList(ddlReceiveMode,dtValue.Rows[0]["ReceivingMode"].ToString().Trim());
        SetValueDropDownList(ddlReformtoItem,dtValue.Rows[0]["ReformToItemInd"].ToString().Trim());
        SetValueDropDownList(ddlRFPrint,dtValue.Rows[0]["RFPrintInd"].ToString().Trim());
       // SetValueDropDownList(ddlROPDays,dtValue.Rows[0]["ROPDays"].ToString().Trim());
        SetValueDropDownList(ddlSerial,dtValue.Rows[0]["SerialNoInd"].ToString().Trim());
        SetValueDropDownList(ddlSerialPrint,dtValue.Rows[0]["SerialNoPrintInd"].ToString().Trim());
        SetValueDropDownList(ddlShippedOrder,dtValue.Rows[0]["ShippedOrderInd"].ToString().Trim());
        SetValueDropDownList(ddlShippingLabel,dtValue.Rows[0]["ShipLabel"].ToString().Trim());
        SetValueDropDownList(ddlShippingMethod,dtValue.Rows[0]["ShipMethCd"].ToString().Trim());
        SetValueDropDownList(ddlShippingModule,dtValue.Rows[0]["ShipModuleInd"].ToString().Trim());
        SetValueDropDownList(ddlSupportRep,dtValue.Rows[0]["SupportRepInd"].ToString().Trim());
        SetValueDropDownList(ddlTransactionSet,dtValue.Rows[0]["ILTStartTransInd"].ToString().Trim());
        txtROPDays.Text = dtValue.Rows[0]["ROPDays"].ToString().Trim();
        chkSelection.Items[0].Selected = (dtValue.Rows[0]["ComplItemShipInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[4].Selected = (dtValue.Rows[0]["DefaultBinInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[8].Selected = (dtValue.Rows[0]["DefaultItemInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[12].Selected = (dtValue.Rows[0]["UseDefltSellStkUMInd"].ToString().Trim() == "Y") ? true : false;

        chkSelection.Items[1].Selected = (dtValue.Rows[0]["ILTBatchControlInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[5].Selected = (dtValue.Rows[0]["LPNControlInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[9].Selected = (dtValue.Rows[0]["MoveDocPromptInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[13].Selected = (dtValue.Rows[0]["MultiUMInd"].ToString().Trim() == "Y") ? true : false;

        chkSelection.Items[2].Selected = (dtValue.Rows[0]["ActivatePhyInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[6].Selected = (dtValue.Rows[0]["CartonPrintInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[10].Selected = (dtValue.Rows[0]["ShipConfirmInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[14].Selected = (dtValue.Rows[0]["ShipInFullInd"].ToString().Trim() == "Y") ? true : false;

        chkSelection.Items[3].Selected = (dtValue.Rows[0]["UseOdomInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[7].Selected = (dtValue.Rows[0]["AllowPartialRcptsInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[11].Selected = (dtValue.Rows[0]["UseScaleInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[15].Selected = (dtValue.Rows[0]["DefaultFromBinInd"].ToString().Trim() == "Y") ? true : false;

        txtVLocName.Text = dtValue.Rows[0]["VirtualLocationName"].ToString().Trim();
        txtVLocNo.Text = dtValue.Rows[0]["VirtualLocationNo"].ToString().Trim();
        txtVLocZone.Text = dtValue.Rows[0]["VirtualBinZone"].ToString().Trim();
    }

    private void SetValueDropDownList(DropDownList ddlControl, String value)
    {
        ListItem lItem = ddlControl.Items.FindByValue(value) as ListItem;
        if (lItem != null)
            ddlControl.SelectedValue = value;
    }
    protected void btnOptionClose_Click(object sender, ImageClickEventArgs e)
    {

    }
}
