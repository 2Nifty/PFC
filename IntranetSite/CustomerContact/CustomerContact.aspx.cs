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
using System.Web.UI.Design;

using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;
using PFC.Intranet.Securitylayer;

public partial class CustomerContact : System.Web.UI.Page
{
    PFC.Intranet.MaintenanceApps.CustomerContact customerContact = new PFC.Intranet.MaintenanceApps.CustomerContact();
    private DataTable dtTablesData = new DataTable();
    private DataTable dtCustomerContact = new DataTable();

    string insertMessage = "Data has been successfully added";
    string updateMessage = "Data has been successfully updated";
    string deleteMessage = "Data has been successfully deleted";

    /// <summary>
    /// Security ReadOnly Property : Get current user's security Code
    /// </summary>
    protected string CustomerSecurity
    {
        get
        {
            return Session["CustomerSecurity"].ToString();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // Register AJAX
        Ajax.Utility.RegisterTypeForAjax(typeof(CustomerContact));

        lblNameCaption.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");
        ViewState["Operation"] = "";
        lblMessage.Text = "";
        
        if (!Page.IsPostBack)
        {
            customerContact.BindPriceCd(ddlPriceCd);
            customerContact.BindBuyingGroup(ddlBuyingGroup);
            customerContact.BindCustType(ddlCustomerType);
            SetTabIndex();
            //Session["CustomerSecurity"] = customerContact.GetSecurityCode(Session["UserName"].ToString());
            Session["CustomerSecurity"] = "CUST";
            ViewState["Mode"] = "Add";
            customerContact.BindCustomerType(ddlContactType);
            
            // Bind Content Section
            trContent1.Style.Add(HtmlTextWriterStyle.Display, "none");
            trContent2.Style.Add(HtmlTextWriterStyle.Display, "none");

            tblBuyingGrp.Visible = false;
        }

        if (CustomerSecurity == "")
            EnableQueryMode();

    }

    protected string GetContact(string cntType)
    {
        try
        {
            DataTable dtContactType = customerContact.GetContacttype(cntType);

            if (dtContactType.Rows.Count > 0)
            {
                return dtContactType.Rows[0]["ListDtlDesc"].ToString();
            }
            else
                return "";
        }
        catch (Exception)
        {
            return "";
            throw;
        }
    }

    protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
        ViewState["Mode"] = "Add";
        ClearDataEntryArea();
        chkPFCMaterial.Checked = true;
        btnSave.Visible = (CustomerSecurity != "") ? true : false;
        
        ToggleEntry(true);
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "FocusControl", "document.getElementById('txtName').select();document.getElementById('txtName').focus();", true);
        
        UpdatePanels();
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        if (Page.IsValid)
        {
            try
            {
                if (ViewState["Mode"].ToString() == "Add")
                {
                    string columnName = "fCustAddrID,CustNo,ContactType,Name,[JobTitle],Phone,PhoneExt,FaxNo,MobilePhone,EmailAddr,Department,AllowMarketingEmailInd,EntryID,EntryDt";

                    string columnValue = "'" + hidCustMasterID.Value.Trim() + "'," +
                                         "'" + hidCustNo.Value.Trim() + "'," +
                                         "'" + ddlContactType.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                         "'" + txtName.Text.Trim().Replace("'", "''") + "'," +
                                         "'" + txtJobTitle.Text.Trim().Replace("'", "''") + "'," +
                                         "'" + txtHPhone.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                         "'" + txtExt.Text.Trim().Replace("'", "''") + "'," +
                                         "'" + txtFax.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                         "'" + txtMPhone.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                                         "'" + txtEmail.Text.Trim().Replace("'", "''") + "'," +
                                         "'" + txtDepartment.Text.Trim().Replace("'", "''") + "'," +
                                         "'" + (chkPFCMaterial.Checked? "Y" : "N") + "'," +
                                         "'" + Session["UserName"] + "'," +
                                         "'" + DateTime.Now.ToShortDateString() + "'";

                    customerContact.InsertTables(columnName, columnValue);
                    BindDataGrid();
                    DisplaStatusMessage(insertMessage, "Success");
                    //btnSave.Visible = false;
                    ToggleEntry(false);
                    pnlCustHeader.Update();
                    UpdatePanels();
                }

                if (ViewState["Mode"].ToString() == "Update")
                {
                    string updateValue = "ContactType='" + ddlContactType.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                    "Name='" + txtName.Text.Trim().Replace("'", "''") + "'," +
                    "JobTitle='" + txtJobTitle.Text.Trim().Replace("'", "''") + "'," +
                    "Phone='" + txtHPhone.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                    "PhoneExt='" + txtExt.Text.Trim().Replace("'", "''") + "'," +
                    "FaxNo='" + txtFax.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                    "MobilePhone='" + txtMPhone.GetPhoneNumber.Trim().Replace("'", "''") + "'," +
                    "EmailAddr='" + txtEmail.Text.Trim().Replace("'", "''") + "'," +
                    "Department='" + txtDepartment.Text.Trim().Replace("'", "''") + "'," +
                    "AllowMarketingEmailInd='" + (chkPFCMaterial.Checked ? "Y" : "N") + "'," +
                    "ChangeID='" + Session["UserName"] + "'," +
                    "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";
                    customerContact.UpdateCustomerContact("CustomerContact", updateValue, "pCustContactsID=" + hidCustContactID.Value.Trim());
                    BindDataGrid();
                    DisplaStatusMessage(updateMessage, "Success");

                    ToggleEntry(false);
                    UpdatePanels();
                    pnlCustHeader.Update();
                    upnlContactGrid.Update();
                    ViewState["EditContactID"] = null;
                }
            }
            catch (Exception ex) { } 
        }
    }

    protected void btnSearch_Click(object sender, ImageClickEventArgs e)
    {
        string strCustNo = txtSearchCode.Text;
        bool textIsNumeric = true;

        try
        {
            int.Parse(strCustNo);
        }
        catch
        {
            textIsNumeric = false;
        }

        if (!textIsNumeric)
        {
            ScriptManager.RegisterClientScriptBlock(txtSearchCode, txtSearchCode.GetType(), "Customer", "LoadCustomerLookup('" + Server.UrlEncode(PFC.Intranet.Securitylayer.Cryptor.Encrypt(strCustNo)) + "','" + txtSearchCode.ClientID + "');", true);
        }
        else
        {
            DataTable dtCustomerMaster = customerContact.GetCustomerMasterInformation(txtSearchCode.Text.Trim());

            string _creditInd = "";
            if (dtCustomerMaster != null && dtCustomerMaster.Rows.Count > 0)
                _creditInd = dtCustomerMaster.Rows[0]["CreditInd"].ToString().ToUpper().Trim();

            if (dtCustomerMaster != null && dtCustomerMaster.Rows.Count > 0 && _creditInd != "X")
            {
                //
                // Fill information in header
                //
                lblCustName.Text = dtCustomerMaster.Rows[0]["CustName"].ToString();
                lblAddress.Text = dtCustomerMaster.Rows[0]["AddrLine1"].ToString();
                lblCity.Text = dtCustomerMaster.Rows[0]["City"].ToString();
                lblState.Text = dtCustomerMaster.Rows[0]["State"].ToString();
                lblPostCode.Text = dtCustomerMaster.Rows[0]["PostCd"].ToString();
                lblCountry.Text = dtCustomerMaster.Rows[0]["Country"].ToString();
                hidCustMasterID.Value = dtCustomerMaster.Rows[0]["pCustomerAddressID"].ToString();
                hidCustNo.Value = txtSearchCode.Text.Trim();

                // ----------------------------------------------------------------------------//

                ToggleContact(true);
                BindDataGrid();

                tblBuyingGrp.Visible = true;
                SetDropDownValue(ddlPriceCd, dtCustomerMaster.Rows[0]["PriceCd"].ToString());
                SetDropDownValue(ddlBuyingGroup, dtCustomerMaster.Rows[0]["BuyGroup"].ToString());
                SetDropDownValue(ddlCustomerType, dtCustomerMaster.Rows[0]["CustType"].ToString());
            }
            else
            {
                ClearALL();
                tblBuyingGrp.Visible = false;
                dlContacts.DataSource = null;
                dlContacts.DataBind();
                if (_creditInd == "X")
                    DisplaStatusMessage("Customer is on hold, contacts cannot be edited", "Fail");
                else
                    DisplaStatusMessage("Invalid Customer Search value", "Fail");
                upnlContactGrid.Update();
                pnlProgress.Update();
                trContent1.Style.Add(HtmlTextWriterStyle.Display, "none");
                trContent2.Style.Add(HtmlTextWriterStyle.Display, "none");
                MyScript.SetFocus(txtSearchCode);
            }
            ToggleEntry(false);

            pnlCustHeader.Update();
        }
    }

    private void SetDropDownValue(DropDownList ddlCommon,string value)
    {
        ListItem item = ddlCommon.Items.FindByValue(value.Trim());
        if (item != null)
            ddlCommon.SelectedValue = value.Trim();
    }

    private void BindDataGrid()
    {
        DataTable dtCustomerContact = customerContact.GetCustomerContact(txtSearchCode.Text.Trim(), "custNo");

        if (dtCustomerContact != null && dtCustomerContact.Rows.Count > 0)
        {
            lblNoRecordfound.Visible = false;
            dlContacts.DataSource = dtCustomerContact.DefaultView.ToTable();
            dlContacts.DataBind();
        }
        else
        {
            dlContacts.DataSource = null;
            dlContacts.DataBind();
            lblNoRecordfound.Text = "No Records Found";
            lblNoRecordfound.Visible = true;
            pnlProgress.Update();
        }
    }

    private void UpdatePanels()
    {
        upnlEntry.Update();
        upnlbtnSearch.Update();
        upnlAdd.Update();
        upnlContactGrid.Update();
        pnlProgress.Update();
        upnlbtnsave.Update();
    }

    protected void ClearALL()
    {
        try
        {
            lblCustName.Text = "";
            lblAddress.Text = "";
            lblCity.Text = "";
            lblState.Text = "";
            lblPostCode.Text = "";
            lblCountry.Text = "";
        }
        catch (Exception ex) { }
    }

    protected void ClearDataEntryArea()
    {
        txtName.Text = "";
        txtJobTitle.Text = "";
        txtHPhone.GetPhoneNumber = "";
        txtMPhone.GetPhoneNumber = "";
        txtEmail.Text = "";
        txtDepartment.Text = "";
        ddlContactType.ClearSelection();
        txtExt.Text = "";
        txtFax.GetPhoneNumber = "";
        lblChangeID.Text = "";
        lblChangeDate.Text ="";
        lblEntryID.Text = "";
        lblEntryDate.Text = "";
    }

    private void DisplaStatusMessage(string message, string messageType)
    {
        lblMessage.Visible = true;
        if (messageType.ToLower() == "success")
        {
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = message;
        }
        else if (messageType.ToLower() == "fail")
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = message;
        }
    }

    public string FormatPhoneFax(string formatString)
    {
        try
        {
            string formatNumber = formatString.Trim();
            switch (formatString.Trim().Length)
            {
                case 10:
                    formatNumber = "(" + formatString.Substring(0, 3) + ")" + " " + formatString.Substring(3, 3) + "-" + formatString.Substring(6, 4);
                    break;
                case 11:
                    formatNumber = formatString.Substring(0, 1) + "-" + formatString.Substring(1, 3) + "-" + formatString.Substring(4, 3) + "-" + formatString.Substring(7, 4);
                    break;
            }

            return formatNumber;
        }
        catch (Exception ex) { return formatString; }
    }

    /// <summary>
    ///  used to disable control for security mode
    /// </summary>
    private void EnableQueryMode()
    {
        btnSave.Visible = false;
        btnAdd.Visible = false;
    }
   
    private void SetTabIndex()
    {
        //txtSearchCode.Attributes.Add("onkeydown", "if(event.which || event.keyCode)" +
        //"{if ((event.which == 9) || (event.keyCode == 9)) " +
        //"{document.getElementById('" + txtName.ClientID +
        //"').focus();return false;}} else {return true}; ");
    }

    protected void dlContacts_ItemCommand(object source, DataListCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            ViewState["EditContactID"] = e.CommandArgument.ToString().Trim();
            dtCustomerContact = customerContact.GetCustomerContact(e.CommandArgument.ToString().Trim(), "pCustContactsID");
            ToggleEntry(true);
            FillFormControls(dtCustomerContact);
            ViewState["Mode"] = "Update";
        }
        if (e.CommandName == "Delete")
        {
            customerContact.DeleteCustomerContact(e.CommandArgument.ToString().Trim());
            BindDataGrid();
            if (ViewState["EditContactID"] != null && ViewState["EditContactID"].ToString().Trim() == e.CommandArgument.ToString().Trim())
            {
                ClearDataEntryArea();              
                ToggleEntry(false);
                pnlCustHeader.Update();
                UpdatePanels();
            }
        }
    }

    public void FillFormControls(DataTable dtFillFormControls)
    {
        txtName.Text = dtFillFormControls.Rows[0]["Name"].ToString();
        txtJobTitle.Text = dtFillFormControls.Rows[0]["JobTitle"].ToString();
        txtHPhone.GetPhoneNumber = dtFillFormControls.Rows[0]["Phone"].ToString();
        txtMPhone.GetPhoneNumber = dtFillFormControls.Rows[0]["MobilePhone"].ToString();
        txtEmail.Text = dtFillFormControls.Rows[0]["EmailAddr"].ToString();
        txtDepartment.Text = dtFillFormControls.Rows[0]["Department"].ToString();
        txtFax.GetPhoneNumber = dtFillFormControls.Rows[0]["FaxNo"].ToString();
        txtExt.Text = dtFillFormControls.Rows[0]["PhoneExt"].ToString();
        ddlContactType.SelectedValue = dtFillFormControls.Rows[0]["ContactType"].ToString().Trim();
        chkPFCMaterial.Checked = (dtFillFormControls.Rows[0]["AllowMarketingEmailInd"].ToString().Trim() == "Y" ? true : false);
        hidCustContactID.Value = dtFillFormControls.Rows[0]["pCustContactsID"].ToString();

        lblChangeID.Text = dtFillFormControls.Rows[0]["ChangeID"].ToString();
        lblChangeDate.Text = (dtFillFormControls.Rows[0]["Changedt"].ToString() != "") ? Convert.ToDateTime(dtFillFormControls.Rows[0]["Changedt"].ToString()).ToShortDateString() : "";
            
        //Convert.ToDateTime(dtFillFormControls.Rows[0]["Changedt"].ToString()).ToShortDateString();
        lblEntryID.Text = dtFillFormControls.Rows[0]["EntryID"].ToString();
        lblEntryDate.Text = (dtFillFormControls.Rows[0]["Entrydt"].ToString() != "") ? Convert.ToDateTime(dtFillFormControls.Rows[0]["Entrydt"].ToString()).ToShortDateString() : "";
        //Convert.ToDateTime(dtFillFormControls.Rows[0]["Entrydt"].ToString()).ToShortDateString();

        pnlCustHeader.Update();
        upnlEntry.Update();
    }

    protected void ibtnCancel_Click(object sender, ImageClickEventArgs e)
    {
        ViewState["EditContactID"] = null;
        ClearDataEntryArea();
        //btnSave.Visible = false;
        //ibtnCancel.Visible = false;
        ToggleEntry(false);
        pnlCustHeader.Update();
        UpdatePanels();
    }

    protected void dlContacts_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            LinkButton lnkDelete = e.Item.FindControl("lnkDelete") as LinkButton;
            lnkDelete.Attributes.Add("onclick", "return confirm('Are you sure do you want to delete?');");
            if (CustomerSecurity == "")
                lnkDelete.Visible = false;
        }
    }

    private void ToggleEntry(bool status)
    {
        if (status)
        {
            lblEntryCaption.Visible = true;      
            tdEntry.Style.Add(HtmlTextWriterStyle.Display, "");
        }
        else
        {
            lblEntryCaption.Visible = false;
            tdEntry.Style.Add(HtmlTextWriterStyle.Display, "none");
        }
    }

    private void ToggleContact(bool status)
    {
        if (status)
        {
            trContent1.Style.Add(HtmlTextWriterStyle.Display, "");
            trContent2.Style.Add(HtmlTextWriterStyle.Display, "");
            tdContactHead.Style.Add(HtmlTextWriterStyle.Display, "");
            tdContact.Style.Add(HtmlTextWriterStyle.Display, "");
        }
        else
        {
            tdContactHead.Style.Add(HtmlTextWriterStyle.Display, "none");
            tdContact.Style.Add(HtmlTextWriterStyle.Display, "none");
        }
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string SuggestCustomer(string searchText)
    {
        try
        {
            string detail = "";
            DataTable dtVendor = customerContact.SuggestCustomerNames(searchText);
            if (dtVendor != null && dtVendor.Rows.Count > 0)
            {
                foreach (DataRow dr in dtVendor.Rows)
                    detail = detail + dr["Name"].ToString().Trim() + "~" + dr["custNo"].ToString().Trim() + "`";
                return detail;
            }
            else
                return "";
        }
        catch (Exception ex) { return ""; }
    }

    protected void ddlPriceCd_SelectedIndexChanged(object sender, EventArgs e)
    {
        string updateValue = "PriceCd='" + ddlPriceCd.SelectedValue + "'," +
                   "ChangeID='" + Session["UserName"] + "'," +
                   "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";
        customerContact.UpdateCustomerContact("CustomerMaster", updateValue, "CustNo=" + hidCustNo.Value.Trim());
    }

    protected void ddlBuyingGroup_SelectedIndexChanged(object sender, EventArgs e)
    {
        string updateValue = "BuyGroup='" + ddlBuyingGroup.SelectedValue + "'," +
                   "ChangeID='" + Session["UserName"] + "'," +
                   "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";
        customerContact.UpdateCustomerContact("CustomerMaster", updateValue, "CustNo=" + hidCustNo.Value.Trim());
    }

    protected void ddlCustomerType_SelectedIndexChanged(object sender, EventArgs e)
    {
        string updateValue = "CustType='" + ddlCustomerType.SelectedValue + "'," +
                   "ChangeID='" + Session["UserName"] + "'," +
                   "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";
        customerContact.UpdateCustomerContact("CustomerMaster", updateValue, "CustNo=" + hidCustNo.Value.Trim());
    }
}



