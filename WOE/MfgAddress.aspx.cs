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
using PFC.WOE.BusinessLogicLayer;
using PFC.WOE.DataAccessLayer;

namespace PFC.WebPage
{
    public partial class MfgAddress : System.Web.UI.Page
    {

        #region Variable Declaration

        WOEntry woEntry = new WOEntry();
        DataUtility dataUtility = new DataUtility();

        string locId = "";

        #endregion

        #region Page events

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["WONumber"].ToString() != "") // If Pop-up opended without SO Number
            {
                lblWONumber.Text = Request.QueryString["WONumber"].ToString();
                locId = Request.QueryString["LocID"].ToString();

                FillDefaultAddressAndContact();
            }            
        }
              
        #endregion

        #region Developer Method
        
        private void FillDefaultAddressAndContact()
        {
            //// Fill Default Address infromation            
            DataTable dtDefaultAddress = dataUtility.GetTableData(Session["POHeaderTableName"].ToString(), "*", Session["POHeaderColumnName"].ToString() + "=" + Session["POHeaderID"].ToString());

            if (dtDefaultAddress != null && dtDefaultAddress.Rows.Count > 0)
            {
                lblName.Text = dtDefaultAddress.Rows[0]["BuyFromName"].ToString();
                lblAddress1.Text = dtDefaultAddress.Rows[0]["BuyFromAddress"].ToString();
                lblAddress2.Text = dtDefaultAddress.Rows[0]["BuyFromAddress2"].ToString();
                lblCity.Text = dtDefaultAddress.Rows[0]["BuyFromCity"].ToString();
                lblState.Text = dtDefaultAddress.Rows[0]["BuyFromState"].ToString();
                lblPostcode.Text = dtDefaultAddress.Rows[0]["BuyFromZip"].ToString();
                lblCountry.Text = dtDefaultAddress.Rows[0]["BuyFromCountry"].ToString();
                lblPhone.Text = dtDefaultAddress.Rows[0]["OrderContactPhoneNo"].ToString();

                FillContactInformation(dtDefaultAddress.Rows[0]["OrderContactName"].ToString());

            }
        }

        private void FillContactInformation(string contactName)
        {
            DataSet dsContact = woEntry.GetContactData("primarycontact", contactName);

            if (dsContact != null && dsContact.Tables[0].Rows.Count > 0)
            {
                lblContactName.Text = dsContact.Tables[0].Rows[0]["Contact"].ToString();
                lblContactTitle.Text = dsContact.Tables[0].Rows[0]["JobTitle"].ToString();
                lblContactDept.Text = dsContact.Tables[0].Rows[0]["Department"].ToString();
                lblContactPhone.Text = woEntry.FormatPhoneNumber(dsContact.Tables[0].Rows[0]["Phone"].ToString());
                lblContactExt.Text = dsContact.Tables[0].Rows[0]["PhoneExt"].ToString();
                lblContactFax.Text = woEntry.FormatPhoneNumber(dsContact.Tables[0].Rows[0]["FaxNo"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "")); ;
                lblContactMob.Text = woEntry.FormatPhoneNumber(dsContact.Tables[0].Rows[0]["MobilePhone"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", ""));
                lblContactEmail.Text = dsContact.Tables[0].Rows[0]["EmailAddr"].ToString();
            }
        }

        private void ExportShipToAddress(string exportMode)
        {
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "ExportShipToAddress('" + exportMode + "');", true);
        }

        #endregion

    }
}
