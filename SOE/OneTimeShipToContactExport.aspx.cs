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
 *	15 Nov '08			Ver-1			Sathya		            Created
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

public partial class SoldToAddressExport : System.Web.UI.Page
{
    #region Variable Declaration

    ShipToInformation shipToAddress = new ShipToInformation();      
    Utility utility = new Utility();
    Common common = new Common();

    #endregion
    
    #region Page events

    protected void Page_Load(object sender, EventArgs e)
    {       
        lblSONumber.Text = Request.QueryString["SONumber"].ToString();

        if (!IsPostBack)
        {
            FillDefaultAddressAndContact();
        }
    }

    #endregion

    #region Developer Method

    

    private void FillDefaultAddressAndContact()
    {
        // Fill Default Address infromation
        DataTable dtDefaultAddress = shipToAddress.GetCustomerDefaultAddress(lblSONumber.Text.ToUpper().Replace("W",""));

        if (dtDefaultAddress != null && dtDefaultAddress.Rows.Count > 0)
        {
            hidCustNo.Value = dtDefaultAddress.Rows[0]["SellToCustNo"].ToString();
            lblName.Text = dtDefaultAddress.Rows[0]["ShipToName"].ToString();
            lblAddress1.Text = dtDefaultAddress.Rows[0]["ShipToAddress1"].ToString();
           lblAddress2.Text = dtDefaultAddress.Rows[0]["ShipToAddress2"].ToString();
            lblCity.Text = dtDefaultAddress.Rows[0]["City"].ToString();
            lblState.Text = dtDefaultAddress.Rows[0]["State"].ToString();
            lblPostcode.Text = dtDefaultAddress.Rows[0]["Zip"].ToString();
            lblCountry.Text = dtDefaultAddress.Rows[0]["Country"].ToString();
            lblPhone.Text = utility.FormatPhoneNumber(dtDefaultAddress.Rows[0]["PhoneNo"].ToString());          

            DataTable dtContactDetail;

            if (dtDefaultAddress.Rows[0]["ShipToContactID"].ToString().Replace("'", "''") == "")
            {
                txtContactName.Text = dtDefaultAddress.Rows[0]["ContactName"].ToString();
            }
            else
            {
                // First try to find contact info using contact name
                // if no information found fill default information using CustNo
                dtContactDetail = shipToAddress.GetCustomerContacts(dtDefaultAddress.Rows[0]["ShipToContactID"].ToString().Replace("'", "''"), true);

                if (dtContactDetail.Rows.Count < 1)   // Fill Default Contact information
                {
                    dtContactDetail = shipToAddress.GetDefaultContact(hidCustNo.Value);
                }

                if (dtContactDetail.Rows.Count > 0)
                {
                    txtContactName.Text = dtContactDetail.Rows[0]["Name"].ToString();
                    txtContactJobTitle.Text = dtContactDetail.Rows[0]["JobTitle"].ToString();
                    txtContactDepart.Text = dtContactDetail.Rows[0]["Department"].ToString();
                    txtContactPhoneNo.Text = utility.FormatPhoneNumber(dtContactDetail.Rows[0]["Phone"].ToString());
                    txtContactExt.Text = dtContactDetail.Rows[0]["PhoneExt"].ToString();
                    txtContactFax.Text = dtContactDetail.Rows[0]["FaxNo"].ToString();
                    txtContactMob.Text = utility.FormatPhoneNumber(dtContactDetail.Rows[0]["MobilePhone"].ToString());
                    txtContactEmail.Text = dtContactDetail.Rows[0]["EmailAddr"].ToString();
                    
                }
            }
        }
    }

    
    #endregion
}
