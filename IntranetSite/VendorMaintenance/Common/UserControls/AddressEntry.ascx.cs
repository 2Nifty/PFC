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
    public partial class LocationAdd : System.Web.UI.UserControl
    {
        VendorDetailLayer vendorDetails = new VendorDetailLayer();
        #region Property Bags

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
                Clear();
                hidMode.Value = value;
                lblCaption.Text = ((hidType.Value == "SF") ? "Ship From Information" : "Buy From Information");
                BindDetails();
                SetSecurity();
                btnClose.Visible = (hidMode.Value == "Add") ? false : true;
               
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
            get { return hidType.Value; }
            set { hidType.Value = value; }
        }
       

        #endregion


        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                vendorDetails.FillCountry(ddlCountry);
                vendorDetails.FilProductType(ddlProductType);
                SetSecurity();
            }
        }

        protected void ibtnUpdate_Click(object sender, ImageClickEventArgs e)
        {
            if (Page.IsValid)
            {
                if (hidMode.Value.Trim() == "Add")
                    AddDetails();
                else
                    EditDetails();
            }
        }

        public void AddDetails()
        {
            try
            {
                DataSet dsCode = vendorDetails.GetDataToDateset("VendorAddress", "Code", "Code='" + txtCode.Text.Trim()+"'");
                if (dsCode == null )
                {
                    string addColumnValue = "'" + txtAddressName.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + txtLine1.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + txtLine2.Text.Trim().Trim().Replace("'", "''") + "'," +
                                        "'" + txtCity.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + txtState.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + txtZipCode.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + ddlCountry.SelectedValue.Trim().Replace("'", "''") + "'," +
                                        "'" + phAdddress.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                        "'" + fxAddress.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                        "'" + txtEmail.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "") + "'," +
                                        "'" + DateTime.Now.ToShortDateString().Trim() + "'," +
                                        "'" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "") + "'," +
                                        "'" + DateTime.Now.ToShortDateString().Trim() + "','" +  txtCode.Text.Trim().Replace("'", "''")+"','"+ hidType.Value.Trim() + "','" + hidVendor.Value + "','" + ((hidType.Value == "SF") ? hidBuyID.Value.Trim() : "0") + "'," +                                     
                                        "'" + txtUrl.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + txtTransitAddres.Text.Trim().Trim().Replace("'", "''") + "'," +
                                        "'" + ddlProductType.SelectedValue.Trim().Replace("'", "''") + "'" ;
                    string idValue = vendorDetails.InsertLocationDetails(addColumnValue);
                    hidBuyID.Value = ((hidType.Value.Trim() != "SF") ? idValue : "0");
                    hidShipID.Value = ((hidType.Value.Trim() == "SF") ? idValue : "0");
                    lblCodeStatus.Text = "";
                }
                else
                    lblCodeStatus.Text = "Code already exist";
                SetSecurity();
             
            }
            catch (Exception ex) { }
        }

        public void EditDetails()
        {
            try
            {
                DataSet dsCode = vendorDetails.GetDataToDateset("VendorAddress", "Code", "Code='" + txtCode.Text.Trim() + "' and pVendAddrID!=" + ((hidType.Value == "SF") ? hidShipID.Value.Trim() : hidBuyID.Value.Trim()));
                if (dsCode == null )
                {
                    //LocationName,Line1,Line2,City,State,PostCd,Country,PhoneNo,FAXPhoneNo,
                    //Email,EntryID,EntryDt,ChangeID,ChangeDt,Type
                    string addColumnValue = "LocationName='" + txtAddressName.Text.Trim().Replace("'", "''") + "'," +
                                         "Line1='" + txtLine1.Text.Trim().Replace("'", "''") + "'," +
                                         "Line2='" + txtLine2.Text.Trim().Trim().Replace("'", "''") + "'," +
                                         "City='" + txtCity.Text.Trim().Replace("'", "''") + "'," +
                                         "State='" + txtState.Text.Trim().Replace("'", "''") + "'," +
                                         "PostCd='" + txtZipCode.Text.Trim().Replace("'", "''") + "'," +
                                         "Country='" + ddlCountry.SelectedValue.Trim().Replace("'", "''") + "'," +
                                         "PhoneNo='" + phAdddress.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                         "FAXPhoneNo='" + fxAddress.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                         "Email='" + txtEmail.Text.Trim().Replace("'", "''") + "'," +
                                         "ChangeID='" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "") + "'," +
                                         "ChangeDt='" + DateTime.Now.ToShortDateString().Trim() + "'," +
                                         "WebPageAddr='" + txtUrl.Text.Trim().Replace("'", "''") + "'," +
                                         "TransitDays='" + txtTransitAddres.Text.Trim().Trim().Replace("'", "''") + "'," +
                                         "ProdType='" + ddlProductType.SelectedValue.Trim().Replace("'", "''") + "'," +
                                         "Code='" + txtCode.Text.Trim().Replace("'", "''") + "'";
                    vendorDetails.UpdateVendorDetails("VendorAddress", addColumnValue, "pVendAddrID=" + ((hidType.Value == "SF") ? hidShipID.Value.Trim() : hidBuyID.Value.Trim()));
                    lblCodeStatus.Text = "";
                }
                else
                    lblCodeStatus.Text = "Code already exist";
            }
            catch (Exception ex) { }
        }

        public void BindDetails()
        {
            try
            {
                DataSet dsLoca = vendorDetails.GetLocationDetails(((hidType.Value == "SF") ? hidShipID.Value.Trim() : hidBuyID.Value.Trim()));
                if (dsLoca != null && dsLoca.Tables[0].Rows.Count > 0)
                {
                    txtAddressName.Text = dsLoca.Tables[0].Rows[0]["LocationName"].ToString().Trim();
                    txtLine1.Text = dsLoca.Tables[0].Rows[0]["Line1"].ToString().Trim();
                    txtLine2.Text = dsLoca.Tables[0].Rows[0]["Line2"].ToString().Trim();
                    phAdddress.GetPhoneNumber = dsLoca.Tables[0].Rows[0]["PhoneNo"].ToString().Trim();
                    fxAddress.GetPhoneNumber = dsLoca.Tables[0].Rows[0]["FAXPhoneNo"].ToString().Trim();
                    txtTransitAddres.Text = dsLoca.Tables[0].Rows[0]["TransitDays"].ToString().Trim();
                    txtEmail.Text = dsLoca.Tables[0].Rows[0]["Email"].ToString().Trim();
                    txtState.Text = dsLoca.Tables[0].Rows[0]["State"].ToString().Trim();
                    ddlCountry.SelectedValue = dsLoca.Tables[0].Rows[0]["Country"].ToString().Trim();
                    ddlProductType.SelectedValue = dsLoca.Tables[0].Rows[0]["ProdType"].ToString().Trim();
                    txtZipCode.Text = dsLoca.Tables[0].Rows[0]["PostCd"].ToString().Trim();
                    ddlCountry.SelectedValue = dsLoca.Tables[0].Rows[0]["Country"].ToString().Trim();
                    txtCode.Text = dsLoca.Tables[0].Rows[0]["Code"].ToString().Trim();
                    txtCity.Text = dsLoca.Tables[0].Rows[0]["City"].ToString().Trim();
                    txtUrl.Text = dsLoca.Tables[0].Rows[0]["WebPageAddr"].ToString().Trim();
                    
                }
                SetSecurity();

                
            }
            catch (Exception ex) { }
        }

        public void DisableText(bool flag)
        {
            phAdddress.Enable = txtAddressName.Enabled = txtLine1.Enabled = txtLine2.Enabled = fxAddress.Enable = txtTransitAddres.Enabled = flag;
            txtCity.Enabled= txtUrl.Enabled =  txtCode.Enabled =txtEmail.Enabled = txtState.Enabled = ddlCountry.Enabled = ddlProductType.Enabled = txtZipCode.Enabled = flag;
        }

        public void Clear()
        {
            txtCode.Text = txtAddressName.Text = txtLine1.Text = txtLine2.Text = phAdddress.GetPhoneNumber = fxAddress.GetPhoneNumber = txtTransitAddres.Text = "";
            txtEmail.Text = txtState.Text = ddlCountry.Text = txtZipCode.Text =txtCity.Text=txtUrl.Text=ddlProductType.SelectedValue= "";
        }


        public void SetSecurity()
        {
            try
            {
                if ((Session["SecurityCode"] != null && Session["SecurityCode"].ToString().Trim() == "VDAP") || (Session["Lock"] != null && Session["Lock"].ToString().Trim() == "L"))
                {
                    DisableText(false);
                    ibtnUpdate.Visible = false;
                    ibtnCancel.Visible = false;
                   
                }
                else
                {
                    DisableText(true);
                    ibtnUpdate.Visible = true;
                    ibtnCancel.Visible = true;
                   
                }
            }
            catch (Exception ex) { }
        }

        protected void ibtnCancel_Click(object sender, ImageClickEventArgs e)
        {
           
        }
        protected void btnClose_Click(object sender, ImageClickEventArgs e)
        {

        }
}
}
