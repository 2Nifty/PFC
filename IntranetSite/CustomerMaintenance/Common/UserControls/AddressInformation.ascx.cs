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
    public partial class AddressInformation : System.Web.UI.UserControl
    {
        CustomerMaintenance customerDetails = new CustomerMaintenance();
        string newCustID = "";
        public CustomerType GetCustType
        {
            get
            {
                if (ddlCode.SelectedValue == "BTST")
                    return CustomerType.BTST;
                else if (ddlCode.SelectedValue == "BT")
                    return CustomerType.BT;
                else
                    return (CustomerType)Session["CustomerType"];
            }
        }

        public string AddressID
        {
            get
            {
                return hidAddressID.Value;
            }
            set
            {
                hidAddressID.Value = value;
                customerContacts.AddressID = value;
            }
        }
        public string CustomerNumber
        {
            get
            {
                return hidCustomerNo.Value;
            }
            set
            { 
                hidCustomerNo.Value = value;
                if(ddlCode.Items.FindByValue("ST") !=null)
                ddlCode.Items.FindByValue("ST").Enabled = true;
                if (Mode=="Add" && Type=="BT")
                {
                    ClearAddress();
                    ClearCustomer();
                    txtCustNo.Enabled = true;
                    txtCustNo.Text = value;
                    txtCustNo.Enabled = false;                    
                    customerContacts.AddressID = "";
                    ddlCode.Enabled = true;
                    ddlAddType.SelectedIndex = 0; ddlAddType.Enabled = false;
                    if (ddlCode.Items.FindByValue("ST") != null)
                    ddlCode.Items.FindByValue("ST").Enabled = false;
                    Session["CustomerLock"] = "SL";
                }
                
            }
        }
        public string BillCustomerID
        {
            get
            {
                return hidBillCustomerID.Value;
            }
            set
            {
                hidBillCustomerID.Value = value;
              
            }
        }
        public string BillCustomerNo
        {
            get
            {
                return hidBillCustomerNo.Value;
            }
            set
            {
                hidBillCustomerNo.Value = value;

            }
        }
        public string CustomerID
        {
            get
            {
                return hidCustomerID.Value;
            }
            set
            {
                hidCustomerID.Value = value; 
                BindcustomerDetails();
                BindAddressDetail();
                DisableControls();
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
                BindcustomerDetails();
            }
        } 

        public string Type
        {
            get
            { 
                return hidType.Value; 
            }
            set
            {
                hidType.Value = value;
               
            }
        }
        string _updateStatus;
        public string UpdateStatus
        {
            set
            {
                _updateStatus = value;
            }
            get
            {
                return _updateStatus;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            lblNamelnk.Attributes.Add("onclick", "Javascript:ShowDetail(event,this);return false;");
            
            if (!IsPostBack)
            {
                customerContacts.Mode = "Edit";
                BindListControl();
            }
            if (Session["SecurityCode"].ToString().Trim() != "" && Session["CustomerLock"].ToString().Trim() != "L")
            {
                btnSave.Visible = true;
            }
            else
                btnSave.Visible = false;
        }

        private void BindListControl()
        {
            customerDetails.BindListControls(ddlAddType, "ListDesc", "ListValue", customerDetails.GetListDetails("CustAddrType"), "-- Select --");
            customerDetails.BindListControls(ddlCode, "ListDesc", "ListValue", customerDetails.GetListDetails("CustCd"), "-- Select --");

        }
        public void BindcustomerDetails()
        {
            try
            {
              
                DataTable dtCustomerDetail = customerDetails.GetCustomerDetail(CustomerID);
                if (dtCustomerDetail != null && dtCustomerDetail.Rows.Count > 0)
                {
                    txtAltCustName.Text = dtCustomerDetail.Rows[0]["AltCustName"].ToString();
                    txtCustName.Text = dtCustomerDetail.Rows[0]["CustName"].ToString();
                    //  txtCustName2.Text = dtCustomerDetail.Rows[0][""].ToString();
                    txtCustNo.Text = dtCustomerDetail.Rows[0]["CustNo"].ToString();
                    txtSearchKey.Text = dtCustomerDetail.Rows[0]["CustSearchKey"].ToString();
                    txtSortName.Text = dtCustomerDetail.Rows[0]["SortName"].ToString();
                    customerDetails.SetSelectedValuesInListControl(ddlCode, dtCustomerDetail.Rows[0]["CustCd"].ToString());                    
                }
                else
                    ClearCustomer();

            }
            catch (Exception ex) { }
        }

        public void BindAddressDetail()
        {
            //string condition = "CustomerAddress.fCustomerMasterID=customermaster.pCustMstrID and customermaster.custno ='" + customerNo + "' and CustomerAddress.[Type]<>'SHP' and CustomerAddress.[Type]<>'DSHP'";
          
            DataTable dtAddressDetail = (Type != "SH") ? customerDetails.GetCustomerAddress(txtCustNo.Text) : customerDetails.GetCustomerShipToAddress(AddressID);
            if (dtAddressDetail != null)
            {
                txtAddress1.Text = dtAddressDetail.Rows[0]["AddrLine1"].ToString();
                txtAddress2.Text = dtAddressDetail.Rows[0]["AddrLine2"].ToString();
                txtCity.Text = dtAddressDetail.Rows[0]["City"].ToString();
                txtCountry.Text = dtAddressDetail.Rows[0]["Country"].ToString();
                txtPhone.GetPhoneNumber = dtAddressDetail.Rows[0]["PhoneNo"].ToString();
                txtPostCode.Text = dtAddressDetail.Rows[0]["PostCd"].ToString();
                txtState.Text = dtAddressDetail.Rows[0]["State"].ToString();
                txtCustName.Text = dtAddressDetail.Rows[0]["Name1"].ToString();
                txtCustName2.Text = dtAddressDetail.Rows[0]["Name2"].ToString();
                AddressID = dtAddressDetail.Rows[0]["pCustomerAddressID"].ToString();
                customerDetails.SetSelectedValuesInListControl(ddlAddType, dtAddressDetail.Rows[0]["Type"].ToString());

                lblChangeDate.Text = (dtAddressDetail.Rows[0]["ChangeDt"].ToString() != "") ? Convert.ToDateTime(dtAddressDetail.Rows[0]["ChangeDt"].ToString()).ToShortDateString() : "";
                lblChangeID.Text = dtAddressDetail.Rows[0]["ChangeID"].ToString();
                lblEntryDate.Text = Convert.ToDateTime(dtAddressDetail.Rows[0]["EntryDt"].ToString()).ToShortDateString();
                lblEntryID.Text = dtAddressDetail.Rows[0]["EntryID"].ToString();
            }
            else
                ClearAddress();

            if (Type =="SH")
            {
                DataSet dsCount = customerDetails.GetDataToDateset("customerAddress  (NOLOCK) ", "count(*)", "fCustomerMasterID =" + CustomerID + " and (Type='DSHP' or Type ='SHP')");
                 
                    if (dsCount != null && (dsCount.Tables[0].Rows[0][0].ToString() == "0" || dsCount.Tables[0].Rows[0][0].ToString() == "1"))
                    {
                        customerDetails.SetSelectedValuesInListControl(ddlAddType, "DSHP");
                        ddlAddType.Enabled = false;
                    }
                    else
                    {
                        ddlAddType.Enabled = true;
                    }
                
            }
            if (Session["SoldToAddressCount"] != null && (((Session["SoldToAddressCount"].ToString() == "0" || Session["SoldToAddressCount"].ToString() == "1") && Mode == "Edit") || ((Session["SoldToAddressCount"].ToString() == "0" && Mode == "Edit"))) && hidType.Value == "ST")
            {
                customerDetails.SetSelectedValuesInListControl(ddlAddType, "P");
                ddlAddType.Enabled = false;
            }
            else if (Type=="ST")
            {
                ddlAddType.Enabled = true;
            }
        }
        public void ClearCustomer()
        { 
            txtAltCustName.Text = ""; txtCustName.Text = ""; txtCustName2.Text = "";
            txtCustNo.Text = ""; txtSearchKey.Text = ""; txtSortName.Text = "";
        }
        public void ClearAddress()
        {
            txtAddress1.Text = ""; txtAddress2.Text = "";
            txtCity.Text = ""; txtCountry.Text = "";
            txtPhone.GetPhoneNumber = ""; txtPostCode.Text = "";
            txtState.Text = "";

            lblChangeDate.Text = "";
            lblChangeID.Text = "";
            lblEntryDate.Text = "";
            lblEntryID.Text = "";
        }
        public void DisableControls()
        {
            if (Type == "SH")
            {
                txtAltCustName.Enabled = false; txtCustName.Enabled = false; txtCustName2.Enabled = true;
                txtCustNo.Enabled = false; txtSearchKey.Enabled = false; txtSortName.Enabled = false;
                if (ddlCode.Items.FindByValue("ST") != null)
                    ddlCode.Items.FindByValue("ST").Enabled = true;
                customerDetails.SetSelectedValuesInListControl(ddlCode,"ST");
                //ddlCode.SelectedItem.Text = "ST";
                ddlCode.Enabled=false;
            }
            else if (Type == "ST")
            {
                txtAltCustName.Enabled = true; txtCustName.Enabled = true; txtCustName2.Enabled = true;
                txtCustNo.Enabled = true; txtSearchKey.Enabled = true; txtSortName.Enabled = true;
                customerDetails.SetSelectedValuesInListControl(ddlCode, "ST");

                if (ddlCode.Items.FindByValue("ST") != null)
                    ddlCode.Items.FindByValue("ST").Enabled = true;
                //ddlCode.SelectedItem.Text = "ST";
                ddlCode.Enabled = false;
                txtCustNo.Enabled = (Mode == "Add");              
            }
            else if (Type == "BT")
            {
                txtAltCustName.Enabled = true; txtCustName.Enabled = true; txtCustName2.Enabled = true;
                txtCustNo.Enabled = true; txtSearchKey.Enabled = true; txtSortName.Enabled = true;
                txtCustNo.Enabled = false;
                ddlCode.Enabled = (Mode == "Add");
            }
            if (Session["SecurityCode"].ToString().Trim() != "" && Session["CustomerLock"].ToString().Trim() != "L")
                btnSave.Visible = true;
            else
                btnSave.Visible = false;
        }     
        protected void btnClose_Click(object sender, EventArgs e)
        {

        }
        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                UpdateStatus = "";
                if (Mode == "Edit")
                {
                    UpdateCustomer();
                    UpdateAddress();
                    UpdateStatus = "Success";
                }
                else
                {
                    if (Type == "ST" || Type == "BT")
                    {
                        if (ddlCode.SelectedIndex != 0)
                        {
                            if(Type=="ST")
                            {
                                DataSet dtCust = customerDetails.GetDataToDateset("CustomerMaster (NOLOCK) ", "pCustMstrID,fBillToNo,CustCd,CustNo", "CustNo='" + txtCustNo.Text + "'");

                                if (dtCust != null && dtCust.Tables[0].Rows.Count > 0)
                                {
                                    ScriptManager.RegisterClientScriptBlock(txtCustNo, typeof(TextBox), "Alert", "alert('Customer already exist');document.getElementById('" + txtCustNo.ClientID + "').focus();document.getElementById('" + txtCustNo.ClientID + "').select();", true);
                                    return;
                                }
                                
                            }
                            InsertCustomer();
                            InsertAddress();
                            Mode = "Edit";
                            CustomerID = newCustID;
                            CustomerNumber = txtCustNo.Text;
                            if (Type == "BT")
                            {

                                BillCustomerID = CustomerID;
                                BillCustomerNo = CustomerNumber;
                            }
                            UpdateStatus = "Success";
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(btnSave, typeof(Button), "Load", "alert('Select Customer Type');", true);
                            return;
                        }


                    }
                    else
                    {
                        newCustID = CustomerID;
                        if (newCustID != "")
                        {
                            InsertAddress();
                            UpdateStatus = "Success";
                        }
                    }

                    
                }
                
            }
            catch (Exception ex)
            {
                UpdateStatus = ex.Message;
                throw;
            }          
        }

        private void UpdateCustomer()
        {
            //[pCustMstrID],[CustNo],[CustName],[],[SortName],[CustSearchKey],[CustSlsRank],
            //[ShipLocation],[fBillToNo],[ARGLAcctID],[CustType],[ContractNo],[DunsNo],[DunsRating],[Territory]
            //,[CustReg],[SalesOrgNo],[SlsRepNo],[SupportRepNo],[ResaleNo],[UPSNo],[TaxStat],[CreditInd],
            //[SummBillInd],[CycBillInd],[DunInd],[BackOrderInd],[CreditAppInd],[CreditRvwInd],[NetPriceInd],
            //[NextPriceInd],[AllowSubsInd],[AllowPartialsInd],[AllowDelProofInd],[AllowPTLInd],[ASNInd],
            //[DelinqInd],[ChgBackInd],[NickelSurChrgInd],[EDI870Ind],[FinChrgInd],[StmtCopies],[InvCopies],
            //[CashStatus],[InvSortOrd],[TaxCd],[CustCd],[ReasonCd],[CLTradeCd],[PriorityCd],[ExpediteCd],
            //[ShipMethCd],[ShipViaCd],[ShipTermsCd],[TradeTermCd],[ConsMethCd],[DateCdLimit],[SerialNoCd],
            //[MultiTaxCd],[CashDiscCd],[GLPostCd],[DiscTypeCd],[SIC],[LOB],[Rebate],[InvInstr],[ShipInstr],
            //[CreditLmt],[FirstActivityDt],[CreditRvwDT],[SoldSinceDt],[WriteOffDt],[DeleteDt],[LateChrgPct],
            //[ContractSchd1],[ContractSchd2],[ContractSchd3],[MinBillAmt],[SvcChrgMo],[ZeroBalMo],[SpecialLbl],
            //[ASNFormat],[TypeofOrder],[EntryID],[EntryDt],
            //[ChangeID],[ChangeDt],[StatusCd],[ABCCd],[ChainCd],[PriceCd],CustShipLocation,UsageLocation

            if (Type!="SH")
            {
                string updateString = "CustName='" + txtCustName.Text.Replace("'", "''") + "'," +
                                    "SortName='" + txtSortName.Text.Replace("'", "''") + "'," +
                                    "CustSearchKey='" + txtSearchKey.Text.Replace("'", "''") + "'," +
                                    "AltCustName='" + txtAltCustName.Text.Replace("'", "''") + "'," +
                                    "ChangeDt='" + DateTime.Now.ToShortDateString() + "'," +
                                    "ChangeID='" + Session["UserName"].ToString().Replace("'", "''") + "'";
                customerDetails.UpdateCustomerDetails(updateString, CustomerID); 
            }
        }
        private void UpdateAddress()
        {

            //"CustNo,CustName,[pCustomerAddressID],[Type],[fCustomerMasterID],[Name2],[AddrLine1],[AddrLine2],[AddrLine3],
            //[AddrLine4],[AddrLine5],[City],[State],[PostCd],[Country],[PhoneNo],[CustContacts],[fCustContactsID],
            //[UPSZone],[FaxPhoneNo],[EDIPhoneNo],[UPSShipperNo],[Email],CustomerAddress.[EntryID],
            //CustomerAddress.[EntryDt],CustomerAddress.[ChangeID],CustomerAddress.[ChangeDt],
            //CustomerAddress.[StatusCd],[LocationName]";

            string custId = (Type == "ST") ? BillCustomerID : newCustID;
            string AddressType = "";
            string updateString = "Type='" + GetAddressType() + "'," +
                                  "Name1='" + txtCustName.Text.Replace("'", "''") + "'," +
                                 "Name2='" + txtCustName2.Text.Replace("'", "''") + "'," +
                                 "AddrLine1='" + txtAddress1.Text.Replace("'", "''") + "'," +
                                 "AddrLine2='" + txtAddress2.Text.Replace("'", "''") + "'," +
                                 "City='" + txtCity.Text.Replace("'", "''") + "'," +
                                 "State='" + txtState.Text.Replace("'", "''") + "'," +
                                 "PostCd='" + txtPostCode.Text.Replace("'", "''") + "'," +
                                 "Country='" + txtCountry.Text.Replace("'", "''") + "'," +                   
                                 "PhoneNo='" + txtPhone.GetPhoneNumber.Replace("'", "''") + "'," +
                                 "ChangeDt='" + DateTime.Now.ToShortDateString() + "'," +
                                 "ChangeID='" + Session["UserName"].ToString().Replace("'", "''") + "'";
            customerDetails.UpdateAddressDetails(updateString, "pCustomerAddressID='" + AddressID + "'");
        }
       
        private void InsertAddress()
        {
            string addType = GetAddressType();
            string columnName = "Type,fCustomerMasterID,Name1,Name2,AddrLine1,AddrLine2,City,State,PostCd,Country,PhoneNo,EntryDt,EntryID";
            string updateString = "'" + addType + "'," +
                                "'" + newCustID + "'," +
                                "'" + txtCustName.Text.Replace("'", "''") + "'," +
                                "'" + txtCustName2.Text.Replace("'", "''") + "'," +
                                "'" + txtAddress1.Text.Replace("'", "''") + "'," +
                                "'" + txtAddress2.Text.Replace("'", "''") + "'," +
                                "'" + txtCity.Text.Replace("'", "''") + "'," +
                                "'" + txtState.Text.Replace("'", "''") + "'," +
                                "'" + txtPostCode.Text.Replace("'", "''") + "'," +
                                "'" + txtCountry.Text.Replace("'", "''") + "'," +
                                "'" + txtPhone.GetPhoneNumber.Replace("'", "''") + "'," +
                                "'" + DateTime.Now.ToShortDateString() + "'," +
                                "'" + Session["UserName"].ToString().Replace("'", "''") + "'";

            AddressID = customerDetails.InsertAddressDetails(columnName, updateString);
        }
        private string GetAddressType()
        {
            string addType="";
            if (Type == "BT")
            {
                return addType;
            }
            else if (Type == "ST" )
            {
                if (ddlAddType.Enabled && (ddlAddType.SelectedValue == "DSHP" || ddlAddType.SelectedValue == ""))
                    addType = "A";
                else
                {
                    customerDetails.UpdateAddressDetails("Type='A'", "fCustomerMasterID='" + BillCustomerID + "' and Type<>'SHP' and Type<>'DSHP'");
                    addType = "P";
                } 
            }
            else if (Type == "SH")
            {
                if (ddlAddType.Enabled && (ddlAddType.SelectedValue == "P" || ddlAddType.SelectedValue == ""))
                    addType = "SHP";
                else
                {
                    customerDetails.UpdateAddressDetails("Type='SHP'", "fCustomerMasterID='" + CustomerID + "' and Type='DSHP'");
                    addType = "DSHP";
                }
            }
            return addType;
            
        }
        protected void txtCustNo_TextChanged(object sender, EventArgs e)
        {
            if (Session["SecurityCode"].ToString().Trim() != "" && Session["CustomerLock"].ToString().Trim() != "L")
            {
                if (txtCustNo.Text.Trim() != "")
                {
                    DataSet dtCust = customerDetails.GetDataToDateset("CustomerMaster (NOLOCK) ", "pCustMstrID,fBillToNo,CustCd,CustNo", "CustNo='" + txtCustNo.Text + "'");
                    if (dtCust != null && dtCust.Tables[0].Rows.Count > 0)
                        ScriptManager.RegisterClientScriptBlock(txtCustNo, typeof(TextBox), "Alert", "alert('Customer already exist');document.getElementById('" + txtCustNo.ClientID + "').focus();document.getElementById('" + txtCustNo.ClientID + "').select();", true);


                } 
            }
        }
        private void InsertCustomer()
        {
            string columnName = "CustNo,CustName,SortName,CustSearchKey,AltCustName,fbilltono,CustCd,EntryDt,EntryID";
            string fbilltoNo = "";
            if (ddlCode.SelectedValue == "BTST")
                fbilltoNo = txtCustNo.Text.Replace("'", "''");
            else if (ddlCode.SelectedValue == "ST")
                fbilltoNo = BillCustomerNo;
            
            string updateString = "'" + txtCustNo.Text.Replace("'", "''") + "'," +
                                "'" + txtCustName.Text.Replace("'", "''") + "'," +
                                 "'" + txtSortName.Text.Replace("'", "''") + "'," +
                                 "'" + txtSearchKey.Text.Replace("'", "''") + "'," +
                                 "'" + txtAltCustName.Text.Replace("'", "''") + "'," +
                                 "'" + fbilltoNo + "'," +
                                 "'" + ddlCode.SelectedValue + "'," +
                                 "'" + DateTime.Now.ToShortDateString() + "'," +
                                 "'" + Session["UserName"].ToString().Replace("'", "''") + "'";
             newCustID= customerDetails.InsertCustomerDetails(columnName, updateString); 
        }
    }
}