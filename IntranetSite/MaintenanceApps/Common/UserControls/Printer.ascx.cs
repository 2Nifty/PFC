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
public partial class MaintenanceApps_Common_UserControls_Printer : System.Web.UI.UserControl
{

    private LocationMaster locationMaster = new LocationMaster();
    public string LocMasterID
    {
        get { return ViewState["LocMasterID"].ToString().Trim(); }
    }
    public DataTable SetPrinterValue
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
        string updateValue = "AckDfltPrinter	='" + ddlAcknowledgement.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                          " CheckDfltPrinter='" + ddlAPCheck.Text.Trim().Replace("'", "''") + "'," +
                           "BOLDfltPrinter	='" + ddlBillofLading.Text.Trim().Replace("'", "''") + "'," +
                           "CInvDfltPrinter  ='" + ddlCommercialInvoice.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                           "DMDfltPrinter	='" + ddlDebitMemo.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                           "InvDfltPrinter ='" + ddlInvoice.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                           "ShipDfltPrinter='" + ddlPackingList.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                           "PSHDfltPrinter 	='" + ddlPickSheet.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                           "PSDfltPrinter  	='" + ddlPickSlip.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                           "PriorityShipDfltPrinter 	='" + ddlPriorityShip.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                           "PODfltPrinter  	='" + ddlPurchaseOrder.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                           "BlindRcvDfltPrinter	='" + ddlReceiver.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                           "RmtShipDfltPrinter  	='" + ddlRemoteShip.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                           "ShipLblDfltPrinter 	='" + ddlShippingLabel.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                           "StmntDfltPrinter	='" + ddlStatement.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                           "WCShipDftlPrinter	 ='" + ddlWCShip.SelectedItem.Value.Trim().Replace("'", "''") + " ',"+
                           "ChangeID='" + Session["UserName"].ToString().Trim() + "'," +
                           "ChangeDt='" + DateTime.Now.ToString() + "'";

        string whereclause = "LocID=" + LocMasterID;

        locationMaster.UpdateLocationMaster(updateValue, whereclause);
    }

    private void SetValue(DataTable dtValue)
    {
        ViewState["LocMasterID"] = dtValue.Rows[0]["LocID"].ToString().Trim();

        SetValueDropDownList(ddlAcknowledgement, dtValue.Rows[0]["AckDfltPrinter"].ToString().Trim());
        SetValueDropDownList(ddlAPCheck, dtValue.Rows[0]["CheckDfltPrinter"].ToString().Trim());
        SetValueDropDownList(ddlBillofLading, dtValue.Rows[0]["BOLDfltPrinter"].ToString().Trim());
        SetValueDropDownList(ddlCommercialInvoice, dtValue.Rows[0]["CInvDfltPrinter"].ToString().Trim());
        SetValueDropDownList(ddlDebitMemo, dtValue.Rows[0]["DMDfltPrinter"].ToString().Trim());
        SetValueDropDownList(ddlInvoice, dtValue.Rows[0]["InvDfltPrinter"].ToString().Trim());
        SetValueDropDownList(ddlPackingList, dtValue.Rows[0]["ShipDfltPrinter"].ToString().Trim());
        SetValueDropDownList(ddlPickSheet, dtValue.Rows[0]["PSHDfltPrinter"].ToString().Trim());
        SetValueDropDownList(ddlPickSlip, dtValue.Rows[0]["PSDfltPrinter"].ToString().Trim());
        SetValueDropDownList(ddlPriorityShip, dtValue.Rows[0]["PriorityShipDfltPrinter"].ToString().Trim());
        SetValueDropDownList(ddlPurchaseOrder, dtValue.Rows[0]["PODfltPrinter"].ToString().Trim());
        SetValueDropDownList(ddlReceiver, dtValue.Rows[0]["BlindRcvDfltPrinter"].ToString().Trim());
        SetValueDropDownList(ddlRemoteShip, dtValue.Rows[0]["RmtShipDfltPrinter"].ToString().Trim());
        SetValueDropDownList(ddlShippingLabel, dtValue.Rows[0]["ShipLblDfltPrinter"].ToString().Trim());
        SetValueDropDownList(ddlStatement, dtValue.Rows[0]["StmntDfltPrinter"].ToString().Trim());
        SetValueDropDownList(ddlWCShip, dtValue.Rows[0]["WCShipDftlPrinter"].ToString().Trim());

    }

    private void SetValueDropDownList(DropDownList ddlControl, String value)
    {

        ListItem lItem = ddlControl.Items.FindByValue(value) as ListItem;
        if (lItem != null)
            ddlControl.SelectedValue = value;
    }

    private void BindDropdownvalue()
    {
        locationMaster.GetPrinterList(ddlAcknowledgement);
        locationMaster.GetPrinterList(ddlAPCheck);
        locationMaster.GetPrinterList(ddlBillofLading);
        locationMaster.GetPrinterList(ddlCommercialInvoice);
        locationMaster.GetPrinterList(ddlDebitMemo);
        locationMaster.GetPrinterList(ddlInvoice);

        locationMaster.GetPrinterList(ddlPackingList);
        locationMaster.GetPrinterList(ddlPickSheet);
        locationMaster.GetPrinterList(ddlPickSlip);
        locationMaster.GetPrinterList(ddlPriorityShip);
        locationMaster.GetPrinterList(ddlPurchaseOrder);
        locationMaster.GetPrinterList(ddlReceiver);
        locationMaster.GetPrinterList(ddlRemoteShip);
        locationMaster.GetPrinterList(ddlShippingLabel);
        locationMaster.GetPrinterList(ddlStatement);
        locationMaster.GetPrinterList(ddlWCShip);

    }

    protected void btnPrintClose_Click(object sender, ImageClickEventArgs e)
    {

    }
}
