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
    public partial class VendorHeader : System.Web.UI.UserControl
    {
        public string _mode = "";
        public string _vendorNo = "";

        string addTableName = "VendorAddress";
        string addColumns = "LocationName,Line1,Line2,State,PostCd,PhoneNo,City,Country,FAXPhoneNo,EntryDt,EntryID,ChangeDt,ChangeID";

        VendorDetailLayer vendorDetails = new VendorDetailLayer();
        protected void Page_Load(object sender, EventArgs e)
        {
            lnkPayto.Attributes.Add("onclick", "Javascript:ShowDetail(event,this.id);return false;");
            
            if (!IsPostBack)
                Clear();
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

                if (value == "Add")
                    Clear();
                else
                    BindVendorDetails(_vendorNo);
            }
        }

        public string VendorNumber
        {
            get
            {
                return _vendorNo;
            }
            set
            {
                _vendorNo = value;
            }
        }

        public void Clear()
        {
            try
            {
                lblVendNo.Text = "";
                lblVenName.Text = "";
                lblVenCode.Text = "";
                lblCode.Text = "";
                lblFTD.Text = "";
                lblTC.Text = "";
                lblCC.Text = "";

                lblAddress.Text = "";
                lblLine1.Text = "";
               lblPhones.Text= lblPhone.Text = "";
                lblCity.Text = "";
                lblCountry.Text = "";
                lblFaxs.Text = lblFax.Text = "";

                lblEntryDate.Text = "";
                lblEntryID.Text = "";
                lblChangeDate.Text = "";
                lblChangeID.Text = "";
            }
            catch (Exception ex) { }
        }

        private string _parendAddID;
        public string ParentAddID
        {
            get { return _parendAddID; }
            set
            {
                _parendAddID = value;
                if (_parendAddID != "" && _parendAddID != "0")
                    BindAddressDetails();
                else
                    BindVendorDetails(VendorNumber);
            }
        }

        public void BindVendorDetails(string vendorNumber)
        {
            try
            {
                DataSet dsHeaderDetail = vendorDetails.GetVendorHeaderDetails(vendorNumber);
                Clear();
                if (dsHeaderDetail != null && dsHeaderDetail.Tables[0].Rows.Count > 0)
                {
                    lnkPayto.Text = "Pay To";
                    tdPayAddress.Style.Add(HtmlTextWriterStyle.Width, "43px");
                    lblVendNo.Text = dsHeaderDetail.Tables[0].Rows[0]["VendNo"].ToString().Trim();
                    lblVenName.Text =  dsHeaderDetail.Tables[0].Rows[0]["Name"].ToString().Trim();
                    lblVenCode.Text =  dsHeaderDetail.Tables[0].Rows[0]["Code"].ToString().Trim();
                    lblCode.Text =  dsHeaderDetail.Tables[0].Rows[0]["1099Cd"].ToString().Trim();
                    lblFTD.Text = dsHeaderDetail.Tables[0].Rows[0]["FedTaxID"].ToString().Trim(); ;
                    lblTC.Text = dsHeaderDetail.Tables[0].Rows[0]["TermsCd"].ToString().Trim();
                    lblCC.Text = dsHeaderDetail.Tables[0].Rows[0]["CurrencyCd"].ToString().Trim();

                    lblAddress.Text = dsHeaderDetail.Tables[0].Rows[0]["LocationName"].ToString().Trim();
                    lblLine1.Text = dsHeaderDetail.Tables[0].Rows[0]["Line1"].ToString().Trim() + " , " + dsHeaderDetail.Tables[0].Rows[0]["Line2"].ToString().Trim();
                    lblPhone.Text = vendorDetails.FormatPhoneFax(dsHeaderDetail.Tables[0].Rows[0]["PhoneNo"].ToString().Trim());
                    lblCity.Text = dsHeaderDetail.Tables[0].Rows[0]["City"].ToString().Trim() + " , " + dsHeaderDetail.Tables[0].Rows[0]["State"].ToString().Trim() + " , " + dsHeaderDetail.Tables[0].Rows[0]["PostCd"].ToString().Trim();
                    lblCountry.Text = dsHeaderDetail.Tables[0].Rows[0]["Country"].ToString().Trim();
                    lblFax.Text = vendorDetails.FormatPhoneFax(dsHeaderDetail.Tables[0].Rows[0]["FAXPhoneNo"].ToString().Trim());
                   
                    lblPhones.Text = "Phone: ";
                    lblFaxs.Text = "Fax: ";
                    // For Pay TO user Detail
                    lblEntryDate.Text =Convert.ToDateTime(dsHeaderDetail.Tables[0].Rows[0]["EntryDt"].ToString().Trim()).ToShortDateString();
                    lblEntryID.Text = dsHeaderDetail.Tables[0].Rows[0]["EntryID"].ToString().Trim();
                    lblChangeDate.Text = Convert.ToDateTime(dsHeaderDetail.Tables[0].Rows[0]["ChangeDt"].ToString().Trim()).ToShortDateString();
                    lblChangeID.Text = dsHeaderDetail.Tables[0].Rows[0]["ChangeID"].ToString().Trim();
                    
                }

            }
            catch (Exception ex)
            {

            }
        }

        public void BindAddressDetails()
        {
            
            DataSet dsAddressDetail = vendorDetails.GetDataToDateset(addTableName,addColumns,"pVendAddrID="+_parendAddID.Trim());            
            if (dsAddressDetail != null && dsAddressDetail.Tables[0].Rows.Count > 0)
            {
                lnkPayto.Text = "Buy From";
                tdPayAddress.Style.Add(HtmlTextWriterStyle.Width, "60px");
                lblAddress.Text = dsAddressDetail.Tables[0].Rows[0]["LocationName"].ToString().Trim();
                lblLine1.Text = dsAddressDetail.Tables[0].Rows[0]["Line1"].ToString().Trim() + " , " + dsAddressDetail.Tables[0].Rows[0]["Line2"].ToString().Trim();
                lblPhone.Text=vendorDetails.FormatPhoneFax(dsAddressDetail.Tables[0].Rows[0]["PhoneNo"].ToString().Trim());
                lblCity.Text = dsAddressDetail.Tables[0].Rows[0]["City"].ToString().Trim() + " , " + dsAddressDetail.Tables[0].Rows[0]["State"].ToString().Trim() + " , " + dsAddressDetail.Tables[0].Rows[0]["PostCd"].ToString().Trim();
                lblCountry.Text = dsAddressDetail.Tables[0].Rows[0]["Country"].ToString().Trim();
                lblFax.Text = vendorDetails.FormatPhoneFax(dsAddressDetail.Tables[0].Rows[0]["FAXPhoneNo"].ToString().Trim());
              
                lblPhones.Text = "Phone: ";
                lblFaxs.Text = "Fax: ";
                // For Pay TO user Detail
                lblEntryDate.Text = Convert.ToDateTime(dsAddressDetail.Tables[0].Rows[0]["EntryDt"].ToString().Trim()).ToShortDateString();
                lblEntryID.Text = dsAddressDetail.Tables[0].Rows[0]["EntryID"].ToString().Trim();
                lblChangeDate.Text = Convert.ToDateTime(dsAddressDetail.Tables[0].Rows[0]["ChangeDt"].ToString().Trim()).ToShortDateString();
                lblChangeID.Text = dsAddressDetail.Tables[0].Rows[0]["ChangeID"].ToString().Trim();
              
            }
        }
    } 
}
