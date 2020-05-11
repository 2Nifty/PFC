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

using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;

namespace PFC.Intranet.VendorMaintenance
{
    public partial class AddressInformation : System.Web.UI.UserControl
    {
        VendorDetailLayer vendorDetails = new VendorDetailLayer();


        public string BuyID
        {
            get
            {
                return hidBuyID.Value;
            }
            set
            {
                hidBuyID.Value = value;
            }
        }

        public string ShipID
        {
            get
            {
                return hidShipID.Value;
            }
            set
            {
                hidShipID.Value = value;
            }
        }

        public string Mode
        {
            get
            {
                return hidMode.Value;
            }
            set
            {
                hidMode.Value = value;
                BindVendorDetails();
            }
        }

        public string Vendor
        {
            get
            {
                return hidVendor.Value;
            }
            set
            {
                hidVendor.Value = value;
            }
        }

        public string Type
        {
            get
            { return hidType.Value; }
            set
            {
                hidType.Value = value;
                vendorContacts.AddressID = ((value == "SF") ? hidShipID.Value.Trim() : hidBuyID.Value.Trim());
                vendorContacts.Type = "";
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                vendorContacts.Mode = "Edit";

                if ((Session["SecurityCode"] != null && Session["SecurityCode"].ToString().Trim() == "VDAP") || (Session["Lock"] != null && Session["Lock"].ToString().Trim() == "L"))
                    ibtnDelete.Visible = false;
                else
                    ibtnDelete.Visible = true;
                
                //ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "Divcontact", "if(document.getElementById('divDisplay')!=null)document.getElementById('divDisplay').style.height='245px'", true);
            }

            //ibtnDelete.Attributes.Add("onclick", "return confirm(\"Do you want to delete this " + lblAddressInfo.Text.Trim() + "?\");");
        }

        public void BindVendorDetails()
        {
            try
            {
                string whereClause = ""; //(hidAddrID.Value.Trim() != "") ? " pVendAddrID in(Select Top 1 pVendAddrID from VendorAddress where fVendMstrID=" + hidVendor.Value + " and Type='SF')" : "pVendAddrID=" + hidShipID.Value;

                if (hidType.Value == "SF")
                    whereClause = "pVendAddrID=" + hidShipID.Value;
                else
                    whereClause = "pVendAddrID=" + hidBuyID.Value;

                DataSet dsAddress = vendorDetails.GetAddressInformation(whereClause);
                Clear();
                if (dsAddress != null && dsAddress.Tables[0].Rows.Count > 0)
                {
                    hidShipID.Value = dsAddress.Tables[0].Rows[0]["pVendAddrID"].ToString().Trim();

                    if (dsAddress.Tables[0].Rows[0]["Type"].ToString().Trim() == "SF")
                    {
                        lblAddressInfo.Text = "Ship From Information";
                        hidType.Value = "SF";
                        hidBuyID.Value = dsAddress.Tables[0].Rows[0]["fBuyFromAddrID"].ToString().Trim();
                        vendorContacts.AddressID = dsAddress.Tables[0].Rows[0]["pVendAddrID"].ToString().Trim();
                    }
                    else
                    {
                        lblAddressInfo.Text = "Buy From Information";
                        hidBuyID.Value = dsAddress.Tables[0].Rows[0]["pVendAddrID"].ToString().Trim();
                        hidType.Value = "BF";
                        vendorContacts.AddressID = dsAddress.Tables[0].Rows[0]["fBuyFromAddrID"].ToString().Trim();
                    }
                   
                    lblAddress.Text = dsAddress.Tables[0].Rows[0]["LocationName"].ToString();
                    lblLine1.Text = ((dsAddress.Tables[0].Rows[0]["Line1"].ToString().Trim() != "") ? dsAddress.Tables[0].Rows[0]["Line1"].ToString().Trim() + "," : "") + ((dsAddress.Tables[0].Rows[0]["Line2"].ToString().Trim() != "") ? dsAddress.Tables[0].Rows[0]["Line2"].ToString().Trim()  : "");
                    lblCity.Text = ((dsAddress.Tables[0].Rows[0]["City"].ToString().Trim() != "") ? dsAddress.Tables[0].Rows[0]["City"].ToString().Trim() + "," : "") + ((dsAddress.Tables[0].Rows[0]["State"].ToString().Trim() != "") ? dsAddress.Tables[0].Rows[0]["State"].ToString().Trim() + "," : "") + ((dsAddress.Tables[0].Rows[0]["PostCd"].ToString().Trim() != "") ? dsAddress.Tables[0].Rows[0]["PostCd"].ToString().Trim() : "");
                    lblCountry.Text = ((dsAddress.Tables[0].Rows[0]["Country"].ToString().Trim() != "") ? dsAddress.Tables[0].Rows[0]["Country"].ToString().Trim() : "");
                    lblFax.Text = vendorDetails.FormatPhoneFax(dsAddress.Tables[0].Rows[0]["FAXPhoneNo"].ToString().Trim());
                    lblPhone.Text = vendorDetails.FormatPhoneFax(dsAddress.Tables[0].Rows[0]["PhoneNo"].ToString().Trim());
                    lblTransitDay.Text = dsAddress.Tables[0].Rows[0]["TransitDays"].ToString().Trim();
                    lblWebPage.Text = dsAddress.Tables[0].Rows[0]["WebPageAddr"].ToString().Trim();
                    lblProductType.Text = dsAddress.Tables[0].Rows[0]["ProdType"].ToString().Trim();
                    lblEmail.Text = dsAddress.Tables[0].Rows[0]["Email"].ToString().Trim();


                    // Code to Bind the contact details
                    vendorContacts.Mode = "Edit";
                    vendorContacts.AddressID = ((hidType.Value == "BF") ? hidBuyID.Value : hidShipID.Value);
                    vendorContacts.Type = "Address";
                    vendorContacts.BindContactDeatils();
                    if ((Session["SecurityCode"] != null && Session["SecurityCode"].ToString().Trim() == "VDAP") || (Session["Lock"] != null && Session["Lock"].ToString().Trim() == "L"))
                        ibtnDelete.Visible = false;
                    else
                        ibtnDelete.Visible = true;
                }
            }
            catch (Exception ex) { }

        }

        public void Clear()
        {
            lblAddress.Text = lblCountry.Text = lblCity.Text = lblPhone.Text = lblLine1.Text ="";
            lblFax.Text = lblTransitDay.Text = lblWebPage.Text = lblProductType.Text = "";
        }

        protected void btnEdit_Click(object sender, ImageClickEventArgs e)
        {

        }
        protected void btnClose_Click(object sender, ImageClickEventArgs e)
        {

        }
        protected void btnDelete_Click(object sender, ImageClickEventArgs e)
        {
            string values = "deletedt='" + DateTime.Now.ToShortDateString() + "',Changedt= '" + DateTime.Now.ToShortDateString() + "',changeId='" + Session["UserName"].ToString() + "'";
            string whereclause = "pVendAddrID=" + ((hidType.Value == "SF") ? hidShipID.Value.Trim() : hidBuyID.Value.Trim() + " or fBuyFromAddrID=" + hidBuyID.Value.Trim());
            vendorDetails.UpdateVendorDetails("VendorAddress", values, whereclause);
            
        }
    }
}