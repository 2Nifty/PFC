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
    public partial class VendorDetails : System.Web.UI.UserControl
    {
        public string _mode = "";
        public string _vendorNo = "";
        private string _clearMode = "";
        VendorDetailLayer vendorDetails = new VendorDetailLayer();

        #region Property Bags

        public string VendorNumber
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

        public string Mode
        {
            get 
            {
                return _mode;
            }
            set 
            {
                _mode = value;
             
                // Code to clear the input controls
                ClearVendorInput();
                ClearPayToInput();
               
                divVendorInfo.Style.Add(HtmlTextWriterStyle.Display, "");
                divCntDisplay.Style.Add(HtmlTextWriterStyle.Display, "none");

                // Code to show hide the buttons
                ToggleButton(value);
                SetSecurity();
    
                
            
            }
        }

        public string ClearMode
        {
            get { return _clearMode; }
            set { 
                _clearMode = value;
                txtVendNo.Text = "";
            }
        }

        public string VendorText
        {
            set
            {
                txtVendNo.Text = value;
            }
        }

        #endregion

        #region Control Events

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {

                divVendorInfo.Style.Add(HtmlTextWriterStyle.Display, "");
                divCntDisplay.Style.Add(HtmlTextWriterStyle.Display, "none");

                vendorDetails.FillCountry(ddlCountry);
                SetSecurity();
            }

            ImageButton btnClose = vendorContacts.FindControl("btnClose") as ImageButton;
            btnClose.Click+=new ImageClickEventHandler(btnClose_Click);
        }

        /// <summary>
        /// Code to insert the vendor address details
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    DataSet dsVendor = vendorDetails.GetDataToDateset("VendorMaster", "VendNo", "VendNo='" + txtVendNo.Text.Trim()+"'");
                    if (dsVendor != null)
                    {
                        if (dsVendor.Tables[0].Rows.Count > 0)
                        {
                            hidVendor.Value = "";
                            hidAddress.Value = "";
                        }
                        else
                            UpdateValue();
                    }
                    else
                    {
                        UpdateValue();
                     
                    }

                }
                catch (Exception ex) { }
            }
            else
            {
                hidVendor.Value = "";
            }
        }
        private void UpdateValue()
        {
            // VendNo,Code,Name,1099Cd,TermsCd,FedTaxID,CurrencyCd
            string columnValue = "'" + txtVendNo.Text.Trim().Replace("'", "''") + "'," +
                                 "'" + txtVenCode.Text.Trim().Replace("'", "''") + "'," +
                                 "'" + txtVenName.Text.Trim().Trim().Replace("'", "''") + "'," +
                                 "'" + txtCode.Text.Trim().Replace("'", "''") + "'," +
                                 "'" + txtTC.Text.Trim().Replace("'", "''") + "'," +
                                 "'" + txtFTD.Text.Trim().Replace("'", "''") + "'," +
                                 "'" + txtCC.Text.Trim().Replace("'", "''") + "'," +
                                  "'" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "") + "'," +
                                 "'" + DateTime.Now.ToShortDateString().Trim() + "'," +
                                 "'" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "") + "'," +
                                 "'" + DateTime.Now.ToShortDateString().Trim() + "'";
            hidVendor.Value = vendorDetails.InsertVendorAddressDetails(columnValue);

            //LocationName,Line1,Line2,City,State,PostCd,Country,PhoneNo,FAXPhoneNo,
            //Email,EntryID,EntryDt,ChangeID,ChangeDt,Type
            string addColumnValue = "'" + txtAddressName.Text.Trim().Replace("'", "''") + "'," +
                                 "'" + txtLine1.Text.Trim().Replace("'", "''") + "'," +
                                 "'" + txtLine2.Text.Trim().Trim().Replace("'", "''") + "'," +
                                 "'" + txtCity.Text.Trim().Replace("'", "''") + "'," +
                                 "'" + txtState.Text.Trim().Replace("'", "''") + "'," +
                                 "'" + txtZipCode.Text.Trim().Replace("'", "''") + "'," +
                                 "'" + ddlCountry.SelectedValue.Trim().Replace("'", "''") + "'," +
                                 "'" + phVendor.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                 "'" + fxVendor.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                 "'" + txtEmail.Text.Trim().Replace("'", "''") + "'," +
                                 "'" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "") + "'," +
                                 "'" + DateTime.Now.ToShortDateString().Trim() + "'," +
                                 "'" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "") + "'," +
                                 "'" + DateTime.Now.ToShortDateString().Trim() + "','','PT','" + hidVendor.Value + "'";

            hidAddress.Value = vendorDetails.InsertPayToDetails(addColumnValue);

            btnContacts.Visible = true;
            ibtnSave.Visible = false;
            ibtnUpdate.Visible = true;
            Mode = "Edit";
        }
        protected void ibtnUpdate_Click(object sender, ImageClickEventArgs e)
        {
            if (Page.IsValid)
            {
                try
                {
                    // VendNo,Code,Name,1099Cd,TermsCd,FedTaxID,CurrencyCd
                    string columnValue = "VendNo='" + txtVendNo.Text.Trim().Replace("'", "''") + "'," +
                                         "Code='" + txtVenCode.Text.Trim().Replace("'", "''") + "'," +
                                         "Name='" + txtVenName.Text.Trim().Trim().Replace("'", "''") + "'," +
                                         "[1099Cd]='" + txtCode.Text.Trim().Replace("'", "''") + "'," +
                                         "TermsCd='" + txtTC.Text.Trim().Replace("'", "''") + "'," +
                                         "FedTaxID='" + txtFTD.Text.Trim().Replace("'", "''") + "'," +
                                         "CurrencyCd='" + txtCC.Text.Trim().Replace("'", "''") + "'," +
                                         "ChangeID='" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "") + "'," +
                                         "ChangeDt='" + DateTime.Now.ToShortDateString().Trim() + "'";

                    vendorDetails.UpdateVendorDetails("VendorMaster", columnValue, "pVendMstrID=" + hidVendor.Value.Trim());

                    //LocationName,Line1,Line2,City,State,PostCd,Country,PhoneNo,FAXPhoneNo,
                    //Email,EntryID,EntryDt,ChangeID,ChangeDt,Type
                    string addColumnValue = "LocationName='" + txtAddressName.Text.Trim().Replace("'", "''") + "'," +
                                         "Line1='" + txtLine1.Text.Trim().Replace("'", "''") + "'," +
                                         "Line2='" + txtLine2.Text.Trim().Trim().Replace("'", "''") + "'," +
                                         "City='" + txtCity.Text.Trim().Replace("'", "''") + "'," +
                                         "State='" + txtState.Text.Trim().Replace("'", "''") + "'," +
                                         "PostCd='" + txtZipCode.Text.Trim().Replace("'", "''") + "'," +
                                         "Country='" + ddlCountry.SelectedValue.Trim().Replace("'", "''") + "'," +
                                         "PhoneNo='" + phVendor.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                         "FAXPhoneNo='" + fxVendor.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                         "Email='" + txtEmail.Text.Trim().Replace("'", "''") + "'," +
                                         "ChangeID='" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "") + "'," +
                                         "ChangeDt='" + DateTime.Now.ToShortDateString().Trim() + "'";

                    vendorDetails.UpdateVendorDetails("VendorAddress", addColumnValue, "pVendAddrID=" + hidAddress.Value.Trim());

                    //divCntDisplay.Visible = true;
                    divVendorInfo.Visible = true;
                    divVendorInfo.Style.Add(HtmlTextWriterStyle.Display, "");
                    vendorContacts.AddressID = hidAddress.Value.Trim();
                }
                catch (Exception ex) { }
            }
        }

        protected void btnContacts_Click(object sender, ImageClickEventArgs e)
        {
            
            divVendorInfo.Style.Add(HtmlTextWriterStyle.Display, "none");
            divCntDisplay.Style.Add(HtmlTextWriterStyle.Display, "");
            vendorContacts.AddressID = hidAddress.Value.Trim();
            vendorContacts.BindContactDeatils();
        }

        protected void ibtnCancel_Click(object sender, ImageClickEventArgs e)
        {
            divVendorInfo.Style.Add(HtmlTextWriterStyle.Display, "none");
            divCntDisplay.Style.Add(HtmlTextWriterStyle.Display, "");
            vendorContacts.AddressID = hidAddress.Value.Trim();
            vendorContacts.BindContactDeatils();
        }

        protected void btnClose_Click(object sender, ImageClickEventArgs e)
        {
            
            divVendorInfo.Style.Add(HtmlTextWriterStyle.Display, "");
            divCntDisplay.Style.Add(HtmlTextWriterStyle.Display, "none");
            
        }

        #endregion


        #region Developer Methods

        public void ClearVendorInput()
        {
            txtVenName.Text = txtVenCode.Text = txtFTD.Text =  txtCode.Text = txtTC.Text = txtCC.Text =txtState.Text= "";
        }

        public void ClearPayToInput()
        {
            txtAddressName.Text = txtLine1.Text = txtLine2.Text = txtCity.Text = txtZipCode.Text = phVendor.GetPhoneNumber = fxVendor.GetPhoneNumber = txtEmail.Text = "";
        }

        public void DisableText(bool flag)
        {
            phVendor.Enable =  txtVenName.Enabled = txtVenCode.Enabled = txtFTD.Enabled = txtCode.Enabled = txtTC.Enabled = txtCC.Enabled = txtState.Enabled = flag;
            txtAddressName.Enabled = txtLine1.Enabled = txtLine2.Enabled = txtCity.Enabled = txtZipCode.Enabled = fxVendor.Enable = txtEmail.Enabled = ddlCountry.Enabled = flag;

        }

        public void ToggleButton(string mode)
        {

            ibtnSave.Visible = ((mode == "Add") ? true : false);
            ibtnUpdate.Visible = ((mode == "Edit") ? true : false);
            btnContacts.Visible = ((mode == "Edit") ? true : false);

            if (mode == "Edit")
            {
                BindVendorDetails(hidVendor.Value);
                txtVendNo.Enabled = false;
            }
            else
                txtVendNo.Enabled = true;
        }

        public void BindVendorDetails(string vendorNumber)
        {
            try
            {
                DataSet dsHeaderDetail = vendorDetails.GetVendorHeaderDetails(vendorNumber);

                // Code to clear the input controls
                ClearVendorInput();
                ClearPayToInput();

                if (dsHeaderDetail != null && dsHeaderDetail.Tables[0].Rows.Count > 0)
                {
                    txtVendNo.Text = dsHeaderDetail.Tables[0].Rows[0]["VendNo"].ToString().Trim();
                    txtVenName.Text = dsHeaderDetail.Tables[0].Rows[0]["Name"].ToString().Trim();
                    txtVenCode.Text = dsHeaderDetail.Tables[0].Rows[0]["Code"].ToString().Trim();
                    txtCode.Text = dsHeaderDetail.Tables[0].Rows[0]["1099Cd"].ToString().Trim();
                    txtFTD.Text = dsHeaderDetail.Tables[0].Rows[0]["FedTaxID"].ToString().Trim(); ;
                    txtTC.Text = dsHeaderDetail.Tables[0].Rows[0]["TermsCd"].ToString().Trim();
                    txtCC.Text = dsHeaderDetail.Tables[0].Rows[0]["CurrencyCd"].ToString().Trim();

                    txtAddressName.Text = dsHeaderDetail.Tables[0].Rows[0]["LocationName"].ToString().Trim();
                    txtLine1.Text = dsHeaderDetail.Tables[0].Rows[0]["Line1"].ToString().Trim();
                    txtLine2.Text = dsHeaderDetail.Tables[0].Rows[0]["Line2"].ToString().Trim();
                    phVendor.GetPhoneNumber = dsHeaderDetail.Tables[0].Rows[0]["PhoneNo"].ToString().Trim();
                    txtCity.Text = dsHeaderDetail.Tables[0].Rows[0]["City"].ToString().Trim();
                    txtState.Text = dsHeaderDetail.Tables[0].Rows[0]["State"].ToString().Trim();
                    txtZipCode.Text= dsHeaderDetail.Tables[0].Rows[0]["PostCd"].ToString().Trim();
                    ddlCountry.SelectedValue = dsHeaderDetail.Tables[0].Rows[0]["Country"].ToString().Trim();
                    fxVendor.GetPhoneNumber = dsHeaderDetail.Tables[0].Rows[0]["FAXPhoneNo"].ToString().Trim();
                    hidAddress.Value = dsHeaderDetail.Tables[0].Rows[0]["pVendAddrID"].ToString().Trim();
                    //lblLC.Text =  dsHeaderDetail.Tables[0].Rows[0][""].ToString().Trim();
                    txtEmail.Text = dsHeaderDetail.Tables[0].Rows[0]["Email"].ToString().Trim();
                }

               

            }
            catch (Exception ex)
            {
            }
        }

        public void SetSecurity()
        {
            if ((Session["SecurityCode"] != null && Session["SecurityCode"].ToString().Trim() == "VEND (W)") ||  (Session["Lock"] != null && Session["Lock"].ToString().Trim() == "L"))
            {
                DisableText(false);
              //  btnContacts.Visible = false;
                ibtnSave.Visible = false;
                ibtnUpdate.Visible = false;
                ibtnCancel.Visible = false;
            }
            else
            {
                DisableText(true);
             //   btnContacts.Visible = true;
                ibtnSave.Visible = true;
                ibtnUpdate.Visible = true;

                if(Session["SecurityCode"] != null && Session["SecurityCode"].ToString().Trim() == "VDAP")
                    ibtnSave.Visible =  false;
                else
                    ibtnSave.Visible = (_mode == "Add") ? true : false;

                ibtnUpdate.Visible = (_mode == "Edit") ? true : false;
                btnContacts.Visible = (_mode == "Edit") ? true : false;
            }

            
            

        }

        public void ShowHideButtion()
        {
            btnContacts.Visible = false;
            ibtnSave.Visible = false;
            ibtnUpdate.Visible = false;
            ibtnCancel.Visible = false;
        }

        #endregion

    } 
}
