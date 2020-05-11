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
    public partial class Contacts : System.Web.UI.UserControl
    {
        string _mode = "";
        string _addressID = "";
        string _type = "";
        VendorDetailLayer vendorDetails = new VendorDetailLayer();
        protected void Page_Load(object sender, EventArgs e)
        {
            divDisplay.Style.Add(HtmlTextWriterStyle.Height, "227px");
            if (!IsPostBack)
            {
                tblContactEntry.Visible = false;

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
                UpdateMode(hidMode.Value);
            }
        }

        public string AddressID
        {
            get { return hidAddID.Value; }
            set { hidAddID.Value = value; BindContactDeatils(); }
        }

        public string Type
        {
            get { return hidType.Value.Trim(); }
            set
            {
                hidType.Value = value;

                if (hidType.Value == "Address" || hidType.Value == "SF" || hidType.Value == "BF")
                {
                    btnClose.Style.Add("display", "none");
                    divDisplay.Style.Add(HtmlTextWriterStyle.Height, "227px");
                  
                }
                else if (hidType.Value != "")
                    divDisplay.Style.Add(HtmlTextWriterStyle.Height, "388px");
                else
                    divDisplay.Style.Add(HtmlTextWriterStyle.Height, "227px");
                   
                   

                if ((Session["SecurityCode"] != null && Session["SecurityCode"].ToString().Trim() == "VDAP") || (Session["Lock"] != null && Session["Lock"].ToString().Trim() == "L"))
                {
                    btnAdd.Visible = false;
                    btnClose.Visible = false;
                }
                else
                {
                    btnAdd.Visible = true;
                    btnClose.Visible = true;
                }
            }
        }


        protected void Clear()
        {
            try
            {
                txtName.Text = txtJobTitle.Text = txtMphone.GetPhoneNumber = txtEmail.Text = txtDepartment.Text = phContact.GetPhoneNumber = txtExt.Text = fxContact.GetPhoneNumber = "";
            }
            catch (Exception ex) { }
        }

        protected void btnAdd_Click(object sender, ImageClickEventArgs e)
        {
            if (hidAddID.Value.Trim() != "")
            {
                Clear();
                tblContactEntry.Visible = true;
                dlContacts.Visible = false;
                lblMessage.Visible = false;
                Mode = "Add";
                btnClose.Visible = (_type == "")? true:false;
                btnAdd.Visible = false;
                divDisplay.Style.Add(HtmlTextWriterStyle.Height, "0px");
               
            }            
        }

        protected void btnClose_Click(object sender, ImageClickEventArgs e)
        {

            tblContactEntry.Visible = false;
           
           BindContactDeatils();
           btnClose.Visible = (_type == "") ? true : false;
            btnAdd.Visible = true;
            Clear();
            if (hidType.Value == "Address" || hidType.Value == "SF" || hidType.Value == "BF")
            {
                divDisplay.Style.Add(HtmlTextWriterStyle.Height, "227px");
               
            }
            else
                divDisplay.Style.Add(HtmlTextWriterStyle.Height, "388px");
                
               
            
        }

        public void UpdateMode(string mode)
        {
            switch (mode)
            {
                case "Edit":
                    tblContactEntry.Visible = false;
                    dlContacts.Visible = true;
                    btnClose.Visible = true;                   
                    break;
                default:
                    tblContactEntry.Visible = true;
                    dlContacts.Visible = false;
                    btnClose.Visible =true ;
                    btnAdd.Visible = false;
                    divDisplay.Style.Add(HtmlTextWriterStyle.Height, "227px");
                    break;
            }
           
        }

        protected void ibtnUpdate_Click(object sender, ImageClickEventArgs e)
        {
            if (Page.IsValid)
            {
                if (hidMode.Value == "Add")
                {
                    //[fVendAddrID],[Name],[JobTitle],[Phone],[PhoneExt],[FaxNo],[MobilePhone],
                    //[EmailAddr],[Department],[EntryID],[EntryDt],[ChangeID],[ChangeDt]

                    string columnValue = hidAddID.Value.Trim() + "," +
                                        "'" + txtName.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + txtJobTitle.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + phContact.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                        "'" + txtExt.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + fxContact.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                        "'" + txtMphone.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                        "'" + txtEmail.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + txtDepartment.Text.Trim().Replace("'", "''") + "'," +
                                        "'" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "") + "'," +
                                        "'" + DateTime.Now.ToShortDateString() + "'," +
                                        "'" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "") + "'," +
                                        "'" + DateTime.Now.ToShortDateString() + "'";

                    hidID.Value = vendorDetails.InsertContactDetails(columnValue);
                }
                else
                    if (hidMode.Value == "Edit")
                    {
                        string updateValue = "Name='" + txtName.Text.Trim().Replace("'", "''") + "'," +
                                        "JobTitle='" + txtJobTitle.Text.Trim().Replace("'", "''") + "'," +
                                        "Phone='" + phContact.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                        "PhoneExt='" + txtExt.Text.Trim().Replace("'", "''") + "'," +
                                        "FaxNo='" + fxContact.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                        "MobilePhone='" + txtMphone.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                        "EmailAddr='" + txtEmail.Text.Trim().Replace("'", "''") + "'," +
                                        "Department='" + txtDepartment.Text.Trim().Replace("'", "''") + "'," +
                                        "ChangeID='" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "") + "'," +
                                        "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";
                        vendorDetails.UpdateVendorDetails("VendorContact", updateValue, "pVendContractID=" + hidID.Value.Trim());
                    }

                tblContactEntry.Visible = false;
                btnAdd.Visible = true;

                BindContactDeatils();
                if (hidType.Value == "Address" || hidType.Value == "SF" || hidType.Value == "BF")
                    divDisplay.Style.Add(HtmlTextWriterStyle.Height, "227px");
                else
                    divDisplay.Style.Add(HtmlTextWriterStyle.Height, "388px");
            }
        }
        /// <summary>
        /// 
        /// </summary>
        public void BindContactDeatils()
        {
            try
            {
                DataSet dsContact = vendorDetails.GetContactDetails(hidAddID.Value.Trim());
                if ((!(hidType.Value == "Address" || hidType.Value == "SF" || hidType.Value == "BF")) && (Session["SecurityCode"] != null && Session["SecurityCode"].ToString().Trim() == "VEND (W)"))
                    btnAdd.Visible = false;
                if (dsContact != null && dsContact.Tables[0].Rows.Count > 0)
                {
                    dlContacts.DataSource = dsContact.Tables[0];
                    dlContacts.DataBind();
                    tblContactEntry.Visible = false;
                    dlContacts.Visible = true;
                    lblMessage.Visible = false;
                    
                }
                else
                {
                    tblContactEntry.Visible = false;
                    dlContacts.Visible = false;
                    lblMessage.Visible = true;
                }
                if (hidType.Value == "Address" || hidType.Value == "SF" || hidType.Value == "BF")
                    divDisplay.Style.Add(HtmlTextWriterStyle.Height, "227px");
                else
                    divDisplay.Style.Add(HtmlTextWriterStyle.Height, "388px");
              
                
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
            HiddenField hidContact = e.Item.FindControl("hidContactID") as HiddenField;
            if (e.CommandName == "Edit")
            {
                hidID.Value = hidContact.Value;
                Mode = "Edit";
                DataSet dsContact = vendorDetails.GetVendorContact(hidID.Value.Trim());
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
                }
                tblContactEntry.Visible = true;
                dlContacts.Visible = false;
                lblMessage.Visible = false;
                if (hidType.Value == "Address" || hidType.Value == "SF" || hidType.Value == "BF")
                    divDisplay.Style.Add(HtmlTextWriterStyle.Height, "0px");
                else
                    divDisplay.Style.Add(HtmlTextWriterStyle.Height, "0px");
            }

            if (e.CommandName == "Delete")
            {
                vendorDetails.DeleteContact(hidContact.Value.Trim());
                BindContactDeatils();
            }

        }
        protected void ibtnCancel_Click(object sender, ImageClickEventArgs e)
        {
            tblContactEntry.Visible = false;
            BindContactDeatils();
            btnAdd.Visible = true;
            btnClose.Visible = (_type == "") ? true : false;
            if (hidType.Value == "Address" || hidType.Value == "SF" || hidType.Value == "BF")
                divDisplay.Style.Add(HtmlTextWriterStyle.Height, "227px");
            else
                divDisplay.Style.Add(HtmlTextWriterStyle.Height, "388px");
        }

        protected void dlContacts_ItemDataBound(object sender, DataListItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                LinkButton lnkEdit = e.Item.FindControl("lbtnEdit") as LinkButton;
                LinkButton lnkDelete = e.Item.FindControl("lnkDelete") as LinkButton;
                Label lblPhone = e.Item.FindControl("lblPhone") as Label;
                Label lblFax = e.Item.FindControl("lblFax") as Label;
                lblPhone.Text = vendorDetails.FormatPhoneFax(lblPhone.Text.Trim().Replace("&nbsp;", ""));
                lblFax.Text = vendorDetails.FormatPhoneFax(lblFax.Text.Trim().Replace("&nbsp;", ""));
                lnkDelete.Attributes.Add("onclick", "return confirm(\"Do you want to delete this contact?\");");
                Label lblMphone = e.Item.FindControl("lblMphone") as Label;
                lblMphone.Text = vendorDetails.FormatPhoneFax(lblMphone.Text.Trim().Replace("&nbsp;", ""));
                
                if ((!(hidType.Value == "Address" || hidType.Value == "SF" || hidType.Value == "BF")) && (Session["SecurityCode"] != null && Session["SecurityCode"].ToString().Trim() == "VEND (W)"))
                {
                    lnkEdit.Visible = false;
                    lnkDelete.Visible = false;
                   
                }
                else if((hidType.Value == "Address" || hidType.Value == "SF" || hidType.Value == "BF") && (Session["SecurityCode"] != null && Session["SecurityCode"].ToString().Trim() == "VDAP"))
                {
                        lnkEdit.Visible = false;
                        lnkDelete.Visible = false;
                }
                else
                {
                      lnkEdit.Visible = true;
                        lnkDelete.Visible = true;
                }
                HideControll(lnkEdit,lnkDelete);

            }
        }

        private void HideControll(LinkButton lnkEdit, LinkButton lnkDelete)
        {
            if ((Session["Lock"] != null && Session["Lock"].ToString().Trim() == "L"))
            {
                lnkEdit.Visible = false;
                lnkDelete.Visible = false;

            }           
        }
    }
}
