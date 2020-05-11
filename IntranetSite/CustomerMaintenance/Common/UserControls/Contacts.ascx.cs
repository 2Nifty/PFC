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
    public partial class Contacts : System.Web.UI.UserControl
    {
       
        CustomerMaintenance customerDetails = new CustomerMaintenance();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BindListControl();
                tblContactEntry.Visible = false;
                
            }
            if (Session["SecurityCode"].ToString().Trim() != "" && Session["CustomerLock"].ToString().Trim() != "L")
            {
                ibtnUpdate.Visible = true;
            }
            else
                ibtnUpdate.Visible = false;
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
            }
        }

        public string CustomerNumber
        {
            get { return hidCustomerNo.Value; }
            set { hidCustomerNo.Value = value; }
        }
        public string ContactID
        {
            get { return hidContactID.Value; }
            set { hidContactID.Value = value; }
        }
        public string AddressID
        {
            get { return hidAddressID.Value; }
            set { hidAddressID.Value = value; BindContactDetails(); }
        }

        protected void Clear()
        {
            try
            {
                txtName.Text = txtJobTitle.Text = txtMphone.GetPhoneNumber = txtEmail.Text = txtDepartment.Text = phContact.GetPhoneNumber = txtExt.Text = fxContact.GetPhoneNumber = "";
            }
            catch (Exception ex) { }
        }
        private void BindListControl()
        {
            customerDetails.BindListControls(ddlCode, "ListDesc", "ListValue", customerDetails.GetListDetails("ContactCode"), "-- Select --");
            customerDetails.BindListControls(ddlType, "ListDesc", "ListValue", customerDetails.GetListDetails("ContactType"), "-- Select --");

        }
        protected void btnAdd_Click(object sender, ImageClickEventArgs e)
        {
            if (hidAddressID.Value.Trim() != "")
            {
                Clear();
                tblContactEntry.Visible = true;
                dlContacts.Visible = false;
                lblMessage.Visible = false;
                Mode = "Add";              
                btnAdd.Visible = false;
                divDisplay.Style.Add(HtmlTextWriterStyle.Display, "none");
               
            }            
        }          
        protected void ibtnUpdate_Click(object sender, ImageClickEventArgs e)
        {
            if (Page.IsValid)
            {
                if (ddlCode.SelectedValue == "P")
                    customerDetails.UpdateCustomerDetails("CustomerContact", "ContactCd='A'", "fCustAddrID=" + hidAddressID.Value.Trim());
                if (Mode == "Add")
                {
                    //[fCustAddrID],CustNo,ContactType,ContactCd,[Name],[JobTitle],[Phone],[PhoneExt],[FaxNo],[MobilePhone],
                    //[EmailAddr],[Department],[EntryID],[EntryDt],[ChangeID],[ChangeDt]

                  
                    string columnValue = AddressID + "," +
                                        "'" + CustomerNumber + "'," +
                                        "'" + ddlType.SelectedValue + "'," +
                                        "'" + ddlCode.SelectedValue + "'," +  
                                        "'" + txtName.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + txtJobTitle.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + phContact.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                        "'" + txtExt.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + fxContact.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                        "'" + txtMphone.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                        "'" + txtEmail.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + txtDepartment.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "") + "'," +
                                        "'" + DateTime.Now.ToShortDateString() + "'";

                    hidContactID.Value = customerDetails.InsertContactDetails(columnValue);
                   
                }
                else
                    if (hidMode.Value == "Edit")
                    {
                        string updateValue = "ContactType='" + ddlType.SelectedValue + "'," +
                                        "ContactCd='" + ddlCode.SelectedValue + "'," +  
                                        "Name='" + txtName.Text.Trim().Replace("'", "''") + "'," +
                                        "JobTitle='" + txtJobTitle.Text.Trim().Replace("'", "''") + "'," +
                                        "Phone='" + phContact.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                        "PhoneExt='" + txtExt.Text.Trim().Replace("'", "''") + "'," +
                                        "FaxNo='" + fxContact.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                        "MobilePhone='" + txtMphone.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                        "EmailAddr='" + txtEmail.Text.Trim().Replace("'", "''") + "'," +
                                        "Department='" + txtDepartment.Text.Trim().Replace("'", "''") + "'," +
                                        "ChangeID='" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "") + "'," +
                                        "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";
                        customerDetails.UpdateCustomerDetails("CustomerContact", updateValue, "pCustContactsID=" + hidContactID.Value.Trim());
                       
                    }
                    if (ddlCode.SelectedValue == "P")
                    {
                        customerDetails.UpdateCustomerDetails("CustomerAddress", "fCustContactsID=" + hidContactID.Value.Trim(), "pCustomerAddressID=" + hidAddressID.Value.Trim());
                    }
                tblContactEntry.Visible = false;
                btnAdd.Visible = true;
                BindContactDetails();                 
                divDisplay.Style.Add(HtmlTextWriterStyle.Display, "");
            }
        }
        /// <summary>
        /// 
        /// </summary>
        public void BindContactDetails()
        {
            try
            {
                DataSet dsContact = customerDetails.GetContactDetails(hidAddressID.Value.Trim());               
                if (dsContact != null && dsContact.Tables[0].Rows.Count > 0)
                {
                    dlContacts.DataSource = dsContact.Tables[0];
                    dlContacts.DataBind();
                    tblContactEntry.Visible = false;
                    dlContacts.Visible = true;
                    lblMessage.Visible = false;
                    hidContactCount.Value = dsContact.Tables[0].Rows.Count.ToString();
                    customerDetails.SetSelectedValuesInListControl(ddlCode, "P");
                    ddlCode.Enabled = true;
                }
                else
                {
                    tblContactEntry.Visible = false;
                    dlContacts.Visible = false;
                    lblMessage.Visible = true;
                    hidContactCount.Value = "0";
                    customerDetails.SetSelectedValuesInListControl(ddlCode, "P");
                    ddlCode.Enabled = false;
                }              
            }
            catch (Exception ex) { }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void dlContacts_ItemCommand(object source, DataListCommandEventArgs e)
        {
           
            if (e.CommandName == "Edit")
            {
                hidContactID.Value = e.CommandArgument.ToString().Trim();
                Mode = "Edit";
                DataSet dsContact = customerDetails.GetContactContact(hidContactID.Value.Trim());
                if (dsContact != null && dsContact.Tables[0].Rows.Count > 0)
                {
                    txtName.Text = dsContact.Tables[0].Rows[0]["Name"].ToString().Trim();
                    txtJobTitle.Text = dsContact.Tables[0].Rows[0]["JobTitle"].ToString().Trim();
                    txtMphone.GetPhoneNumber = dsContact.Tables[0].Rows[0]["MobilePhone"].ToString().Trim();
                    txtEmail.Text = dsContact.Tables[0].Rows[0]["EmailAddr"].ToString().Trim();
                    txtDepartment.Text = dsContact.Tables[0].Rows[0]["Department"].ToString().Trim();
                    phContact.GetPhoneNumber = dsContact.Tables[0].Rows[0]["Phone"].ToString().Trim();
                    txtExt.Text = dsContact.Tables[0].Rows[0]["PhoneExt"].ToString().Trim();
                    fxContact.GetPhoneNumber = dsContact.Tables[0].Rows[0]["FaxNo"].ToString().Trim();                    
                    customerDetails.SetSelectedValuesInListControl(ddlCode, dsContact.Tables[0].Rows[0]["ContactCd"].ToString().Trim());
                    customerDetails.SetSelectedValuesInListControl(ddlType, dsContact.Tables[0].Rows[0]["ContactType"].ToString().Trim());
                    if (hidContactCount.Value == "1")
                    {
                        customerDetails.SetSelectedValuesInListControl(ddlCode, "P");
                        ddlCode.Enabled = false;
                    }
                    else
                    {
                        ddlCode.Enabled = true;
                    }
                }
                tblContactEntry.Visible = true;
                dlContacts.Visible = false;
                lblMessage.Visible = false;            
            }

            if (e.CommandName == "Delete")
            {
                customerDetails.DeleteContact(e.CommandArgument.ToString().Trim());
                BindContactDetails();
            }

        }
        protected void ibtnCancel_Click(object sender, ImageClickEventArgs e)
        {
            tblContactEntry.Visible = false;
            BindContactDetails();
            btnAdd.Visible = true;         
         
        }
        protected void dlContacts_ItemDataBound(object sender, DataListItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lnkEdit = e.Item.FindControl("lbtnEdit") as LinkButton;
                LinkButton lnkDelete = e.Item.FindControl("lnkDelete") as LinkButton;
                Label lblPhone = e.Item.FindControl("lblPhone") as Label;
                Label lblFax = e.Item.FindControl("lblFax") as Label;
                lblPhone.Text = customerDetails.FormatPhoneFax(lblPhone.Text.Trim().Replace("&nbsp;", ""));
                lblFax.Text = customerDetails.FormatPhoneFax(lblFax.Text.Trim().Replace("&nbsp;", ""));
                lnkDelete.Attributes.Add("onclick", "return confirm(\"Do you want to delete this contact?\");");
                Label lblMphone = e.Item.FindControl("lblMphone") as Label;
                lblMphone.Text = customerDetails.FormatPhoneFax(lblMphone.Text.Trim().Replace("&nbsp;", ""));
                if (Session["SecurityCode"].ToString().Trim() != "" && Session["CustomerLock"].ToString().Trim() != "L")
                    lnkDelete.Visible = true;
                else
                    lnkDelete.Visible = false;
                //if ((!(hidType.Value == "Address" || hidType.Value == "SF" || hidType.Value == "BF")) && (Session["SecurityCode"] != null && Session["SecurityCode"].ToString().Trim() == "VEND (W)"))
                //{
                //    lnkEdit.Visible = false;
                //    lnkDelete.Visible = false;
                   
                //}
                //else if((hidType.Value == "Address" || hidType.Value == "SF" || hidType.Value == "BF") && (Session["SecurityCode"] != null && Session["SecurityCode"].ToString().Trim() == "VDAP"))
                //{
                //        lnkEdit.Visible = false;
                //        lnkDelete.Visible = false;
                //}
                //else
                //{
                //      lnkEdit.Visible = true;
                //        lnkDelete.Visible = true;
                //}
                

            }
        }       
    }
}
