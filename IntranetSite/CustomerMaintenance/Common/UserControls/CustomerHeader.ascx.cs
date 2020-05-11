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

namespace PFC.Intranet.Maintenance
{
    public partial class AddressHeader : System.Web.UI.UserControl
    {
        private string _billTocustomerNo = "";
        private string _customerNo = "";
        private CustomerType _customerType;
        private DataTable dsValue = new DataTable();
     
        CustomerMaintenance customerDetails = new CustomerMaintenance();
        protected void Page_Load(object sender, EventArgs e)
        {
            lnkBillto.Attributes.Add("onclick", "Javascript:ShowBillDetail(event,this.id);return false;");
            lnkSoldto.Attributes.Add("onclick", "Javascript:ShowSoldDetail(event,this.id);return false;");

            if (!IsPostBack)
            {
                if (Request.QueryString["Mode"] == null)
                {
                    ClearBillControls();
                    ClearSoldControls();
                }
            }
        }
        public string BillToCustomerNo
        {
            set
            {
                _billTocustomerNo = value;
            }
            get { return _billTocustomerNo.Trim(); }
        } 
        public string CustomerNumber
        {           
            set
            {
                _customerNo = value;
                BindBillToAddress();
            }
            get
            {
                return _customerNo;
            }
        }        
        public CustomerType CustType
        {
            get {return _customerType;}
            set { _customerType = value; }
        }

        public void ClearBillControls()
        {
            lblBillCity.Text = "";
            lblBillCountry.Text = "";
            lblBillFax.Text = "";
            lblBillLine1.Text = "";
            lblBillName.Text = "";
            lblBillPhone.Text = "";
            lblBillToCustomerNumber.Text = "";


            lblBillChangeDate.Text = "";
            lblBillChangeID.Text = "";
            lblBillEntryDate.Text = "";
            lblBillEntryID.Text = "";

            lblCustMastEntryID.Text = "";
            lblCustMastEntryDt.Text = "";
            lblCustMastChnageDt.Text = "";
            lblCustMastChangeID.Text = "";
            tblEntryPanel.Visible = false;
        }

        public void ClearSoldControls()
        {
            try
            {
               

                lblSoldCity.Text = "";
                lblSoldCountry.Text = "";
                lblSoldFax.Text= "";
                lblSoldLine1.Text = "";
                lblSoldName.Text = "";
                lblSoldPhone.Text = "";
                lblSoldToCustomerNumber.Text = "";               


                lblSoldChangeDate.Text = "";
                lblSoldChangeID.Text = "";
                lblSoldEntryDate.Text = "";
                lblSoldEntryID.Text = "";
               
            }
            catch (Exception ex) { }
        }

        private void BindBillToAddress()
        {           
            //[pCustomerAddressID],[Type],[fCustomerMasterID],[Name2],[AddrLine1],[AddrLine2],[AddrLine3],[AddrLine4],
            //[AddrLine5],[City],[State],[PostCd],[Country],[PhoneNo],[CustContacts],[fCustContactsID],[UPSZone],
            //[FaxPhoneNo],[EDIPhoneNo],[UPSShipperNo],[Email],CustomerAddress.[EntryID],CustomerAddress.[EntryDt]
            //,CustomerAddress.[ChangeID],CustomerAddress.[ChangeDt],CustomerAddress.[StatusCd],[LocationName]
            if (CustomerNumber != "")
            {
                if (CustType == CustomerType.BT || CustType == CustomerType.BTST)
                    dsValue = customerDetails.GetCustomerAddress(CustomerNumber);
                else
                    dsValue = customerDetails.GetCustomerAddress(BillToCustomerNo);

                if (dsValue != null && dsValue.Rows.Count > 0)
                {
                    lblBillCity.Text = dsValue.Rows[0]["City"].ToString();
                    lblBillCountry.Text = dsValue.Rows[0]["Country"].ToString();
                    lblBillFax.Text = customerDetails.FormatPhoneFax(dsValue.Rows[0]["FaxPhoneNo"].ToString());
                    lblBillLine1.Text = dsValue.Rows[0]["AddrLine1"].ToString();
                    lblBillName.Text = dsValue.Rows[0]["CustName"].ToString();
                    lblBillPhone.Text = customerDetails.FormatPhoneFax(dsValue.Rows[0]["PhoneNo"].ToString());
                    lblBillToCustomerNumber.Text = dsValue.Rows[0]["CustNo"].ToString();

                    lblBillChangeDate.Text = (dsValue.Rows[0]["ChangeDt"].ToString() == "") ? "" : Convert.ToDateTime(dsValue.Rows[0]["ChangeDt"].ToString()).ToShortDateString();
                    lblBillChangeID.Text = dsValue.Rows[0]["ChangeID"].ToString();
                    lblBillEntryDate.Text = (dsValue.Rows[0]["EntryDt"].ToString() == "") ? "" : Convert.ToDateTime(dsValue.Rows[0]["EntryDt"].ToString()).ToShortDateString();
                    lblBillEntryID.Text = dsValue.Rows[0]["EntryID"].ToString();

                    lblCustMastChnageDt.Text = (dsValue.Rows[0]["CustMasterChangeDt"].ToString() == "") ? "" : Convert.ToDateTime(dsValue.Rows[0]["CustMasterChangeDt"].ToString()).ToShortDateString();
                    lblCustMastChangeID.Text = dsValue.Rows[0]["CustMasterChangeID"].ToString();
                    lblCustMastEntryDt.Text = (dsValue.Rows[0]["CustMasterEntryDt"].ToString() == "") ? "" : Convert.ToDateTime(dsValue.Rows[0]["CustMasterEntryDt"].ToString()).ToShortDateString();
                    lblCustMastEntryID.Text = dsValue.Rows[0]["CustMasterEntryID"].ToString();
                    tblEntryPanel.Visible = true;                    
                }
                else
                {
                    ClearBillControls();                    
                }


                if (CustType == CustomerType.BTST)
                {
                    DataTable dtsoldto = customerDetails.GetCustomerSoldToAddress(CustomerNumber);
                    if (dtsoldto != null && dtsoldto.Rows.Count > 0)
                    {
                        dsValue = dtsoldto.Copy();
                    }
                    BindSoldToAddress();

                }
                else if (CustType == CustomerType.ST)
                {
                    dsValue = customerDetails.GetCustomerAddress(CustomerNumber);
                    BindSoldToAddress();
                }
                else
                {
                    tdSoldAddress.Style.Add(HtmlTextWriterStyle.Display, "none");
                }
            }
            else
            {
                ClearBillControls();
                ClearSoldControls();
            }
            
        }

        private void BindSoldToAddress()
        {
            if (dsValue != null && dsValue.Rows.Count > 0)
            {
                lblSoldCity.Text = dsValue.Rows[0]["City"].ToString();
                lblSoldCountry.Text = dsValue.Rows[0]["Country"].ToString();
                lblSoldFax.Text = customerDetails.FormatPhoneFax(dsValue.Rows[0]["FaxPhoneNo"].ToString());
                lblSoldLine1.Text = dsValue.Rows[0]["AddrLine1"].ToString();
                lblSoldName.Text = dsValue.Rows[0]["CustName"].ToString();
                lblSoldPhone.Text = customerDetails.FormatPhoneFax(dsValue.Rows[0]["PhoneNo"].ToString());
                lblSoldToCustomerNumber.Text = dsValue.Rows[0]["CustNo"].ToString();

                lblSoldChangeDate.Text = (dsValue.Rows[0]["ChangeDt"].ToString() == "") ? "" : Convert.ToDateTime(dsValue.Rows[0]["ChangeDt"].ToString()).ToShortDateString();
                lblSoldChangeID.Text = dsValue.Rows[0]["ChangeID"].ToString();
                lblSoldEntryDate.Text = (dsValue.Rows[0]["EntryDt"].ToString() == "") ? "" : Convert.ToDateTime(dsValue.Rows[0]["EntryDt"].ToString()).ToShortDateString();
                lblSoldEntryID.Text = dsValue.Rows[0]["EntryID"].ToString();

            }
            else
            {               
                ClearSoldControls();
            }
              tdSoldAddress.Style.Add(HtmlTextWriterStyle.Display, "");
        }

        public void SetChangeIDAndDt()
        {
            lblCustMastChnageDt.Text = DateTime.Now.ToShortDateString();
            lblCustMastChangeID.Text = Session["UserName"].ToString().Replace("'", "''");                   
            //lblCustMastChangeID.Text = "text";              
        }
    }
}
