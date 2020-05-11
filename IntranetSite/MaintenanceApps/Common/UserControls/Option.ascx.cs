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
public partial class MaintenanceApps_Common_UserControls_Option : System.Web.UI.UserControl
{
    private LocationMaster locationMaster = new LocationMaster();
    public string LocMasterID
    {
        get { return ViewState["LocMasterID"].ToString().Trim(); }     
    }
    public DataTable SetOptionsValue
    {
        set
        {
            SetValue(value);
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        btnSave.Visible= (Session["LocationMasterSecurity"].ToString() != "") ? true : false; 
        if (!IsPostBack)
        {
            BindDropdownvalue(); 
        }
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        string updateValue ="CRCheckCd ='" + ddlCreditCheckCode.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "CRDelinqDays ='" + txtDelinquentDays.Text.Trim().Replace("'", "''") + "'," +
                            "SFZipDigits ='" + txtShipFromLocation.Text.Trim().Replace("'", "''") + "'," +
                            "ShortCode ='" + txtShortCd.Text.Trim().Replace("'", "''") + "'," +
                            "CostPctPrice ='" + txtCostpctPrice.Text.Trim().Replace("'", "''") + "'," +
                            "BigQuoteMinimum = '" + Math.Round(Convert.ToDecimal(txtBigQuoteMin.Text.Trim().Replace("'", "''")), 2) + "'," +
                            "fTransVendorMasterID =" + ((hidTransferVendor.Value.Trim().Replace("'", "''") == "") ? "null " : "'" + hidTransferVendor.Value.Trim().Replace("'", "''") + "'") + "," +
                            "fVendorMasterID =" + ((hidDefaultVendor.Value.Trim().Replace("'", "''") == "") ? "null " : "'" + hidDefaultVendor.Value.Trim().Replace("'", "''") + "'") + "," +
                            "ShipHold1Ind ='" + ddlShipHoldCode.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "AllocTypeCd ='" + ddlAllocationType.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "APCheck ='" + ddlAPChecks.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "BlindRecForm ='" + ddlBlindReceiver.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "BOLForm ='" + ddlBOLForm.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "ExpediteCd ='" + ddlFreightExpedite.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "InvForm ='" + ddlInvoiceForm.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "POForm ='" + ddlPOForm.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "ItemPromptInd ='" + ddlItemPrompt.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "ShipperForm ='" + ddlShipperForm.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "ARStmt ='" + ddlStatement.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "SuppDscPrintInd ='" + ddlSuppDescPrint.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "VendorPOInd ='" + ddlVendorPO.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                            "USDutyCalcReq ='" + ddlDutyCalc.SelectedItem.Value.Trim().Replace("'", "''") + "'," +

                            "CostCtrInd ='" + ((chkSelection.Items[0].Selected == true) ? "Y" : "N") + "'," +
                            "TransferInd ='" + ((chkSelection.Items[1].Selected == true) ? "Y" : "N") + "'," +
                            "PrmptReasonCd ='" + ((chkSelection.Items[2].Selected == true) ? "Y" : "N") + "'," +
                            "SOEDetailItemInd ='" + ((chkSelection.Items[3].Selected == true) ? "Y" : "N") + "'," +
                            "GroupPricingInd ='" + ((chkSelection.Items[4].Selected == true) ? "Y" : "N") + "'," +
                            "SODupItemsInd ='" + ((chkSelection.Items[5].Selected == true) ? "Y" : "N") + "'," +
                            "UseQueuesInd ='" + ((chkSelection.Items[6].Selected == true) ? "Y" : "N") + "'," +
                            "FtCollectInd ='" + ((chkSelection.Items[7].Selected == true) ? "Y" : "N") + "'," +
                            "EnterSTInd ='" + ((chkSelection.Items[8].Selected == true) ? "Y" : "N") + "'," +
                            "ReqPOInd ='" + ((chkSelection.Items[9].Selected == true) ? "Y" : "N") + "'," +
                            "DimensionInd ='" + ((chkSelection.Items[10].Selected == true) ? "Y" : "N") + "'," +
                            "UseEDIInd ='" + ((chkSelection.Items[11].Selected == true) ? "Y" : "N") + " '," +
                            "MaintainIMQtyInd ='" + ((chkSelection.Items[12].Selected == true) ? "Y" : "N") + "'," +
                            "ReqRequisitionInd ='" + ((chkSelection.Items[13].Selected == true) ? "Y" : "N") + "'," +
                            //"VendorPOInd ='" + ((chkSelection.Items[14].Selected == true) ? "Y" : "N") + "'," +
                            "SODisplayProd ='" + ((chkSelection.Items[14].Selected == true) ? "Y" : "N") + "'," +
                            "AllowSplitEDI ='" + ((chkSelection.Items[15].Selected == true) ? "1" : "0") + "'," +
                            "ChangeID ='" + Session["UserName"].ToString().Trim() + "'," +
                            "ChangeDt ='" + DateTime.Now.ToString() + "'";

        string whereclause = "LocID=" + LocMasterID;
        locationMaster.UpdateLocationMaster(updateValue, whereclause);
        txtBigQuoteMin.Text = Convert.ToString(Math.Round(Convert.ToDecimal(txtBigQuoteMin.Text.Trim().Replace("'", "''")), 2));
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
        locationMaster.BindListValue("CreditCheckCd", "-- Select --", ddlCreditCheckCode);
        locationMaster.BindListValue("ShipHoldCd", "-- Select --", ddlShipHoldCode);
        locationMaster.BindListValue("AllocTypeCd", "-- Select --", ddlAllocationType);
        locationMaster.BindListValue("APCheckMod", "-- Select --", ddlAPChecks);
        locationMaster.BindListValue("BlindRecForm", "-- Select --", ddlBlindReceiver);
        locationMaster.BindListValue("BOLForm", "-- Select --", ddlBOLForm);
        //locationMaster.BindListValue("CostPctPriceInd", "-- Select --", ddlCostpctPrice);
        locationMaster.GetExpediteList(ddlFreightExpedite);       
        locationMaster.BindListValue("InvForm", "-- Select --", ddlInvoiceForm);
        locationMaster.BindListValue("PoForm", "-- Select --", ddlPOForm);
        locationMaster.BindListValue("ItemPrptInd", "-- Select --", ddlItemPrompt);
        locationMaster.BindListValue("ShipForm", "-- Select --", ddlShipperForm);
        locationMaster.BindListValue("ARStmt", "-- Select --", ddlStatement);
        locationMaster.BindListValue("SuppDescPrt", "-- Select --", ddlSuppDescPrint);
        locationMaster.BindListValue("POVendInd", "-- Select --", ddlVendorPO);
        locationMaster.BindListValue("USDutyCalcReq", "-- Select --", ddlDutyCalc);
    }
    private void SetValue(DataTable dtValue)
    {
        ViewState["LocMasterID"] = dtValue.Rows[0]["LocID"].ToString().Trim();

        SetValueDropDownList(ddlCreditCheckCode, dtValue.Rows[0]["CRCheckCd"].ToString().Trim());
        txtDelinquentDays.Text = dtValue.Rows[0]["CRDelinqDays"].ToString().Trim();
        txtShipFromLocation.Text = dtValue.Rows[0]["SFZipDigits"].ToString().Trim();
        txtShortCd.Text = dtValue.Rows[0]["ShortCode"].ToString().Trim();
        txtCostpctPrice.Text = dtValue.Rows[0]["CostPctPrice"].ToString().Trim();
        txtBigQuoteMin.Text = dtValue.Rows[0]["BigQuoteMinimum"].ToString().Trim();
        txtTransferVendor.Text = locationMaster.GetVendorNumber(dtValue.Rows[0]["fTransVendorMasterID"].ToString().Trim());
        txtDefaultVendor.Text = locationMaster.GetVendorNumber(dtValue.Rows[0]["fVendorMasterID"].ToString().Trim());
        SetValueDropDownList(ddlShipHoldCode, dtValue.Rows[0]["ShipHold1Ind"].ToString().Trim());
        SetValueDropDownList(ddlAllocationType,dtValue.Rows[0]["AllocTypeCd"].ToString().Trim());
        SetValueDropDownList(ddlAPChecks, dtValue.Rows[0]["APCheck"].ToString().Trim());
        SetValueDropDownList(ddlBlindReceiver, dtValue.Rows[0]["BlindRecForm"].ToString().Trim());
        SetValueDropDownList(ddlBOLForm, dtValue.Rows[0]["BOLForm"].ToString().Trim());
        //SetValueDropDownList(ddlCostpctPrice, dtValue.Rows[0]["CostPctPrice"].ToString().Trim());
        SetValueDropDownList(ddlFreightExpedite, dtValue.Rows[0]["ExpediteCd"].ToString().Trim());
        SetValueDropDownList(ddlInvoiceForm, dtValue.Rows[0]["InvForm"].ToString().Trim());
        SetValueDropDownList(ddlPOForm, dtValue.Rows[0]["POForm"].ToString().Trim());
        SetValueDropDownList(ddlItemPrompt, dtValue.Rows[0]["ItemPromptInd"].ToString().Trim());
        SetValueDropDownList(ddlShipperForm, dtValue.Rows[0]["ShipperForm"].ToString().Trim());
        SetValueDropDownList(ddlStatement, dtValue.Rows[0]["ARStmt"].ToString().Trim());
        SetValueDropDownList(ddlSuppDescPrint, dtValue.Rows[0]["SuppDscPrintInd"].ToString().Trim());
        SetValueDropDownList(ddlVendorPO, dtValue.Rows[0]["VendorPOInd"].ToString().Trim());
        SetValueDropDownList(ddlDutyCalc, dtValue.Rows[0]["USDutyCalcReq"].ToString().Trim());

        chkSelection.Items[0].Selected = (dtValue.Rows[0]["CostCtrInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[1].Selected = (dtValue.Rows[0]["TransferInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[2].Selected = (dtValue.Rows[0]["PrmptReasonCd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[3].Selected = (dtValue.Rows[0]["SOEDetailItemInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[4].Selected = (dtValue.Rows[0]["GroupPricingInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[5].Selected = (dtValue.Rows[0]["SODupItemsInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[6].Selected = (dtValue.Rows[0]["UseQueuesInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[7].Selected = (dtValue.Rows[0]["FtCollectInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[8].Selected = (dtValue.Rows[0]["EnterSTInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[9].Selected = (dtValue.Rows[0]["ReqPOInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[10].Selected = (dtValue.Rows[0]["DimensionInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[11].Selected = (dtValue.Rows[0]["UseEDIInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[12].Selected = (dtValue.Rows[0]["MaintainIMQtyInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[13].Selected = (dtValue.Rows[0]["ReqRequisitionInd"].ToString().Trim() == "Y") ? true : false;
        //chkSelection.Items[14].Selected = (dtValue.Rows[0]["VendorPOInd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[14].Selected = (dtValue.Rows[0]["SODisplayProd"].ToString().Trim() == "Y") ? true : false;
        chkSelection.Items[15].Selected = (dtValue.Rows[0]["AllowSplitEDI"].ToString().Trim() == "1") ? true : false;
    }

    protected void txtTransferVendor_TextChanged(object sender, EventArgs e)
    {
        if (txtTransferVendor.Text != "")
        {
            DataTable dtvendor = locationMaster.GetVendorID(txtTransferVendor.Text.Trim());
            if (dtvendor != null && dtvendor.Rows.Count > 0)
            {
                hidTransferVendor.Value = dtvendor.Rows[0]["pVendMstrID"].ToString().Trim();
            }
            else
            {
                txtTransferVendor.Text = "";
                ScriptManager.RegisterClientScriptBlock(txtTransferVendor, typeof(TextBox), "Valid", "alert('Invalid vendor #');", true);
            }
        }
        else
            hidTransferVendor.Value = "";
    }
    protected void txtDefaultVendor_TextChanged(object sender, EventArgs e)
    {
        if (txtDefaultVendor.Text.Trim() != "")
        {
            DataTable dtvendor = locationMaster.GetVendorID(txtDefaultVendor.Text.Trim());
            if (dtvendor != null && dtvendor.Rows.Count > 0)
            {
                hidDefaultVendor.Value = dtvendor.Rows[0]["pVendMstrID"].ToString().Trim();
            }
            else
            {
                txtDefaultVendor.Text = "";
                ScriptManager.RegisterClientScriptBlock(txtDefaultVendor, typeof(TextBox), "Valid", "alert('Invalid vendor #');", true);
            }
        }
        else
            hidDefaultVendor.Value = "";
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
