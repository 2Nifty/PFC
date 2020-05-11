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

public partial class Common_UserControls_Header : System.Web.UI.UserControl
{

    Utility utils = new Utility();
    CustomerDetail custDet = new CustomerDetail();

    // Create instance for the webservice
    OrderEntry service = new OrderEntry();

    #region Propery Bags


    /// <summary>
    /// Property to get or ser customer number 
    /// </summary>
    public string custNumber
    {
        get
        {
            return txtCustNo.Text.Trim();
        }
        set
        {
            txtCustNo.Text = value;
            hidCust.Value = value;
        }
    }

    /// <summary>
    /// Propety to get customer address
    /// </summary>
    public string getAddress
    {
        get
        {
            //return "[ShipTo_Name]='" + lblBill_Name.Text.Trim() + "',[ShipTo_Contact]='" + lblBill_Contact.Text.Trim() + "'," +
            //    "[ShipTo_City]='" + lblBill_City.Text.Trim() + "',[ShipTo_County]='" + lblBill_Territory.Text.Trim() + "'," +
            //    "[ShipTo_Phone No_]='" + lblBill_Phone.Text.Trim() + "',[ShipTo_Post Code]='" + lblBill_Pincode.Text.Trim() + "'";
            return "[ShipToName]='" + lblBill_Name.Text.Trim() + "',[ContactName]='" + lblBill_Contact.Text.Trim() + "'," +
             "[City]='" + lblBill_City.Text.Trim() + "',[State]='" + lblBill_Territory.Text.Trim() + "'," +
             "[ContactPhoneNo]='" + lblBill_Phone.Text.Trim() + "',[Zip]='" + lblBill_Pincode.Text.Trim() + "'";


        }
    }

    /// <summary>
    /// Property to get ship to details
    /// </summary>
    public string getShipTO
    {
        get
        {
            //return "[BillTo_Name]='" + lblShip_Name.Text.Trim() + "',[BillTo_Contact]='" + lblShip_Contact.Text.Trim() + "'," +
            //       "[BillTo_City]='" + lblShip_City.Text.Trim() + "',[BillTo_County]='" + lblShip_Territory.Text.Trim() + "'," +
            //       "[BillTo_Phone No_]='" + lblShip_Phone.Text.Trim() + "',[BillTo_Post Code]='" + lblShip_Pincode.Text.Trim() + "'";
            return "[BillToCustName]='" + lblShip_Name.Text.Trim() + "',[BillToContactName]='" + lblShip_Contact.Text.Trim() + "'," +
                   "[BillToCity]='" + lblShip_City.Text.Trim() + "',[BillToState]='" + lblShip_Territory.Text.Trim() + "'," +
                   "[BillToContactPhoneNo]='" + lblShip_Phone.Text.Trim() + "',[BillToZip]='" + lblShip_Pincode.Text.Trim() + "'";


        }
    }
    /// <summary>
    /// Get Sales order number
    /// </summary>
    public string SOrderNumber
    {
        get { return txtSONumber.Text; }
    }


    /// <summary>
    /// property to get the insert header details
    /// </summary>
    public string getInsertValues
    {
        get
        {
            return txtCustNo.Text.Trim() + "`" +
                    lblBill_Name.Text.Trim() + "`" +
                    lblBill_Contact.Text.Trim() + "`" +
                    lblBill_City.Text.Trim() + "`" +
                    lblBill_Territory.Text.Trim() + "`" +
                    lblBill_Phone.Text.Trim() + "`" +
                    lblBill_Pincode.Text.Trim() + "`" +

                    lblShip_Name.Text.Trim() + "`" +
                    lblShip_Contact.Text.Trim() + "`" +
                    lblShip_City.Text.Trim() + "`" +
                    lblShip_Territory.Text.Trim() + "`" +
                    lblShip_Phone.Text.Trim() + "`" +
                    lblShip_Pincode.Text.Trim() + "`" +
                    lblUsageLoc.Text;

        }
    }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblShipCom.Visible = false;
            lblBillCom.Visible = false;
        }
    }


    /// <summary>
    /// Even to fill the customer detail in the listbox
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnLoadCustomer_Click(object sender, EventArgs e)
    {
        try
        {
            // Call the function to fill the customer details in the controls
            LoadCustomerDetails();

        }
        catch (System.Net.WebException ex)
        {
        }
        catch (System.Web.Services.Protocols.SoapException ex)
        {

        }
        catch (System.InvalidOperationException ex)
        {
        }
        catch (Exception ex)
        {
        }
    }

    /// <summary>
    /// Function to load the customer details
    /// </summary>
    public void LoadCustomerDetails()
    {

        txtCustNo.Text = hidCust.Value.Trim();

        #region Code to fill the customer details in the controls

        // Call the webservice to get the customer address detail
        DataSet dsCustomer = service.GetCustomerDetails(txtCustNo.Text.Trim().Replace("'", ""));
        DataSet dsShipTo = service.GetShipToDetails(txtCustNo.Text);

        // Function to clear the value in the label
        ClearLabels();

        if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count != 0)
        {
            Session["CustNo"] = hidCust.Value.Trim();
            Session["CustomerDetail"] = dsCustomer.Tables[0];
            FillCustomerAddress(dsCustomer.Tables[0]);

            // Code to bind the location details
            DataSet dsLocation = custDet.GetLocationDetails();

        }
        else
        {
            hidCust.Value = txtCustNo.Text = "";
            Session["CustNo"] = null;
            Session["CustomerDetail"] = null;
            Session["ShipDetails"] = null;
            return;
        }

        if (dsShipTo != null && dsShipTo.Tables[0].Rows.Count != 0)
        {
            Session["ShipDetails"] = dsShipTo.Tables[0];

            // Call the function to fill the ship to details
            FillShipTo(dsShipTo.Tables[0]);
        }
        #endregion
    }

    /// <summary>
    /// Function to fill the customer address
    /// </summary>
    /// <param name="dtAddress"></param>
    public void FillCustomerAddress(DataTable dtAddress)
    {
        // Set the customer address details to the control
        lblBill_Name.Text = dtAddress.Rows[0]["Name"].ToString();
        lblBill_Contact.Text = dtAddress.Rows[0]["Address"].ToString();
        lblBill_City.Text = dtAddress.Rows[0]["City"].ToString();
        lblBill_Territory.Text = dtAddress.Rows[0]["Country"].ToString();
        lblBill_Phone.Text = dtAddress.Rows[0]["Phone No_"].ToString();
        lblBill_Pincode.Text = dtAddress.Rows[0]["Post Code"].ToString();
        lblUsageLoc.Text = dtAddress.Rows[0]["Usage Location"].ToString();
        lblBillCom.Visible = ((lblBill_City.Text.Trim() != "" && lblBill_Territory.Text.Trim() != "") ? true : false);

    }

    /// <summary>
    /// Function to fill ship to details
    /// </summary>
    /// <param name="dtShipTo"></param>
    public void FillShipTo(DataTable dtShipTo)
    {
        // Code to fill the ship to details
        lblShip_Name.Text = dtShipTo.Rows[0]["Name"].ToString();
        lblShip_Contact.Text = dtShipTo.Rows[0]["Address"].ToString();
        lblShip_City.Text = dtShipTo.Rows[0]["City"].ToString();
        lblShip_Territory.Text = dtShipTo.Rows[0]["Country"].ToString();
        lblShip_Phone.Text = dtShipTo.Rows[0]["Phone No_"].ToString();
        lblShip_Pincode.Text = dtShipTo.Rows[0]["Post Code"].ToString();
        lblShipCom.Visible = ((lblShip_City.Text.Trim() != "" && lblShip_Territory.Text.Trim() != "") ? true : false);
    }

    /// <summary>
    /// Function to clear labels 
    /// </summary>
    public void ClearLabels()
    {
        try
        {
            lblBill_Name.Text = "";
            lblBill_Contact.Text = "";
            lblBill_City.Text = "";
            lblBill_Territory.Text = "";
            lblBill_Phone.Text = "";
            lblBill_Pincode.Text = "";
            lblShip_Name.Text = "";
            lblShip_Contact.Text = "";
            lblShip_City.Text = "";
            lblShip_Territory.Text = "";
            lblShip_Phone.Text = "";
            lblShip_Pincode.Text = "";
            lblUsageLoc.Text = "";
            lblSales.Text = "";

        }
        catch (Exception ex) { }
    }

    /// <summary>
    /// Event to fill the details in the label
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void lstDetails_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {

            string detailFlag = hidCurrentControl.Value.Split('_')[1].Replace("lnk", "");
            DataTable dtDetail = new DataTable();
            if (detailFlag == "BillTo" || detailFlag == "ShipTo")
            {
                dtDetail = (DataTable)Session[((detailFlag == "BillTo") ? "CustomerDetail" : "ShipDetails")];
                dtDetail.DefaultView.RowFilter = "Name='" + lstDetails.SelectedItem.Text + "' and " + ((detailFlag == "BillTo") ? "No_" : "Code") + "='" + lstDetails.SelectedValue + "'";
                dtDetail = dtDetail.DefaultView.ToTable();
            }

            switch (detailFlag.Replace("lnk", "").Trim())
            {
                case "BillTo":
                    // Code to fill the address or ship to details
                    FillCustomerAddress(dtDetail);

                    // Code to update the detail in the table
                    custDet.UpdateHeader("SOE_Header", getAddress, "SalesOrderID=" + SOrderNumber);
                    break;
                case "ShipTo":
                    FillShipTo(dtDetail);

                    // Code to update the detail in the table
                    custDet.UpdateHeader("SOE_Header", getShipTO, "SalesOrderID=" + SOrderNumber);
                    break;
                case "Usage":
                    lblUsageLoc.Text = lstDetails.SelectedValue;

                    // Code to update the detail in the table
                    custDet.UpdateHeader("SOE_Header", "[UsageLocation]='" + lblUsageLoc.Text + "'", "SalesOrderID=" + SOrderNumber);
                    break;
            }

            // Code to update the customer panel
            UpdatePanel pnlCustomer = Page.FindControl("pnlCustomer") as UpdatePanel;
            pnlCustomer.Update();

        }
        catch (Exception ex)
        {
        }
        ScriptManager.RegisterClientScriptBlock(lstDetails, typeof(ListBox), "", "Hide('divTool');", true);
    }

    /// <summary>
    /// Event to fill the details in the listbox
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnGetDetails_Click(object sender, EventArgs e)
    {
        try
        {
            if (hidCurrentControl.Value.Split('_')[1].Replace("lnk", "").Trim() == "BillTo" || hidCurrentControl.Value.Split('_')[1].Replace("lnk", "").Trim() == "ShipTo")
            {
                // Code to fill the details in the listbox
                DataTable dtDetail = (DataTable)Session[((hidCurrentControl.Value.Replace("lnk", "").Trim() == "CustDet_BillTo") ? "CustomerDetail" : "ShipDetails")];

                // Call the function to fill the listcontrol
                utils.BindListControls(lstDetails, "Name", ((hidCurrentControl.Value.Replace("lnk", "").Trim() == "CustDet_BillTo") ? "No_" : "Code"), dtDetail);
                lstDetails.Width = Unit.Pixel(200);
            }
            else
            {
                // Code to bind the location details
                DataSet dsLocation = custDet.GetLocationDetails();

                // Code to fill the usge location details
                utils.BindListControls(lstDetails, "Name", "Code", dsLocation.Tables[0]);
                lstDetails.Width = Unit.Pixel(130);
            }
            upContext.Update();
            ScriptManager.RegisterClientScriptBlock(btnGetDetails, typeof(Button), "", "xstooltip_show('divTool','" + hidCurrentControl.Value + "',289, 49);", true);
        }
        catch (Exception ex) { }

    }

    protected void btnLoadAll_Click(object sender, EventArgs e)
    {
        try
        {
            DataSet dsHeader = service.ExecuteSelectQuery("SOheader", " * ", "pSOHeaderID=" + txtSONumber.Text.Trim());
            Session["HeaderDetail"] = dsHeader.Tables[0];

           

            // Fill the header details  in the table
            Session["CustNo"] = txtCustNo.Text = hidCust.Value = dsHeader.Tables[0].Rows[0]["SellToCustNo"].ToString().Trim();
            lblBill_Name.Text = dsHeader.Tables[0].Rows[0]["BillToCustName"].ToString().Trim();
            lblBill_Contact.Text = dsHeader.Tables[0].Rows[0]["BillToContactName"].ToString().Trim();
            lblBill_City.Text = dsHeader.Tables[0].Rows[0]["BillToCity"].ToString().Trim();
            lblBill_Territory.Text = dsHeader.Tables[0].Rows[0]["BillToState"].ToString().Trim();
            lblBill_Phone.Text = dsHeader.Tables[0].Rows[0]["BillToContactPhoneNo"].ToString().Trim();
            lblBill_Pincode.Text = dsHeader.Tables[0].Rows[0]["BillToZip"].ToString().Trim();
            lblUsageLoc.Text = dsHeader.Tables[0].Rows[0]["UsageLoc"].ToString().Trim();
            lblShip_Name.Text = dsHeader.Tables[0].Rows[0]["ShipToName"].ToString().Trim();
            lblShip_Contact.Text = dsHeader.Tables[0].Rows[0]["ContactName"].ToString().Trim();
            lblShip_City.Text = dsHeader.Tables[0].Rows[0]["City"].ToString().Trim();
            lblShip_Territory.Text = dsHeader.Tables[0].Rows[0]["State"].ToString().Trim();
            lblShip_Phone.Text = dsHeader.Tables[0].Rows[0]["PhoneNo"].ToString().Trim();
            lblShip_Pincode.Text = dsHeader.Tables[0].Rows[0]["Zip"].ToString().Trim();
            lblBillCom.Visible = ((lblBill_City.Text.Trim() != "" && lblBill_Territory.Text.Trim() != "") ? true : false);
            lblShipCom.Visible = ((lblShip_City.Text.Trim() != "" && lblShip_Territory.Text.Trim() != "") ? true : false);

        }
        catch (Exception ex) { }
    }
}
