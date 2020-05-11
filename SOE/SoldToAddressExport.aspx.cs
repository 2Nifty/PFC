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

public partial class SoldToAddressExport : System.Web.UI.Page
{
    #region Variable Declaration

    SoldToAddress soldToAddress = new SoldToAddress();      
    Utility utility = new Utility();
    Common common = new Common();

    #endregion
    
    #region Page events

    protected void Page_Load(object sender, EventArgs e)
    {       
        lblSONumber.Text = Request.QueryString["SONumber"].ToString();

        if (!IsPostBack)
        {
            DisplayMode();
            FillDefaultAddressAndContact();            
            BindDataGrid();            
        }
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
        DataTable dtCustomerContacts = soldToAddress.GetAllCustomer(hidCustNo.Value); ;

        if (dtCustomerContacts.Rows.Count == 0) // if datatable is empty add new row for display purpose
        {
            DataRow dr = dtCustomerContacts.NewRow();
            dtCustomerContacts.Rows.Add(dr);            
        }
    }

    private void FillDefaultAddressAndContact()
    {
        // Fill Default Address infromation
        DataTable dtDefaultAddress = soldToAddress.GetCustomerDefaultAddress(lblSONumber.Text);

        if (dtDefaultAddress != null && dtDefaultAddress.Rows.Count > 0)
        {
            hidCustNo.Value = dtDefaultAddress.Rows[0]["SellToCustNo"].ToString();
            lblName.Text = dtDefaultAddress.Rows[0]["SellToCustName"].ToString();
            lblAddress1.Text = dtDefaultAddress.Rows[0]["SellToAddress1"].ToString();
            lblAddress2.Text = dtDefaultAddress.Rows[0]["SellToAddress2"].ToString();
            lblCity.Text = dtDefaultAddress.Rows[0]["SellToCity"].ToString();
            lblState.Text = dtDefaultAddress.Rows[0]["SellToState"].ToString();
            lblPostcode.Text = dtDefaultAddress.Rows[0]["SellToZip"].ToString();
            lblCountry.Text = dtDefaultAddress.Rows[0]["SellToCountry"].ToString();
            lblPhone.Text = utility.FormatPhoneNumber(dtDefaultAddress.Rows[0]["SellToContactPhoneNo"].ToString());

            DataTable dtContactDetail;

            // First try to find contact info using contact name
            // if no information found fill default information using CustNo
            dtContactDetail = soldToAddress.GetContactInfoByContactID(dtDefaultAddress.Rows[0]["SellToContactID"].ToString().Replace("'", "''"));

            if (dtContactDetail.Rows.Count < 1)   // Fill Default Contact information
            {
                dtContactDetail = soldToAddress.GetDefaultContact(hidCustNo.Value);
            }

            FillContactInformation(dtContactDetail);
            
        }
    }

    private void FillContactInformation(DataTable dtContactDetail)
    {
        if (dtContactDetail.Rows.Count > 0)
        {
            txtContactName.Text = dtContactDetail.Rows[0]["Name"].ToString();
            txtContactJobTitle.Text = dtContactDetail.Rows[0]["JobTitle"].ToString();
            txtContactDepart.Text = dtContactDetail.Rows[0]["Department"].ToString();
            txtContactPhoneNo.Text = utility.FormatPhoneNumber(dtContactDetail.Rows[0]["Phone"].ToString());
            txtContactExt.Text = dtContactDetail.Rows[0]["PhoneExt"].ToString();
            txtContactFax.Text = utility.FormatPhoneNumber(dtContactDetail.Rows[0]["FaxNo"].ToString());
            txtContactMob.Text = utility.FormatPhoneNumber(dtContactDetail.Rows[0]["MobilePhone"].ToString());
            txtContactEmail.Text = dtContactDetail.Rows[0]["EmailAddr"].ToString();
        }
    }


    private void DisplayMode()
    {
        if (ViewState["DisplayMode"] != null && ViewState["DisplayMode"].ToString() == "Recall")
        {
            txtContactName.CssClass = "lblBluebox";
            txtContactPhoneNo.CssClass = "lblBluebox";
            txtContactMob.CssClass = "lblBluebox";
            txtContactJobTitle.CssClass = "lblBluebox";
            txtContactFax.CssClass = "lblBluebox";
            txtContactExt.CssClass = "lblBluebox";
            txtContactEmail.CssClass = "lblBluebox";
            txtContactDepart.CssClass = "lblBluebox";
            txtContactEmail.Enabled = false;
        }
        //RegisterClientScriptBlock("Mode", "<script>alert(document.body.clientHeight);document.body.clientHeight='20px';</script>");
    }


    
    #endregion
}
