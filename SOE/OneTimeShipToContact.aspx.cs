/** 
 * Project Name: SOE
 * 
 * Module Name: One Time Shio To / Contact 
 * 
 * Author: 	Sathya Ramasamy	
 *
 * Abstract: Creating / Modifying Ship to address and contact...
 *
 * Revision History:
 * 
 *  DATE				VERSION			AUTHOR							ACTION
 * <-------------------------------------------------------------------------->			
 *	15 Nov '08			Ver-1			Sathya Ramasamy		            Created
 **/

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
using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.Enums;


public partial class ShipToInformations : System.Web.UI.Page
{

    #region Variable Declaration

    CustomerDetail customerDetail = new CustomerDetail();
    ShipToInformation shipToAddress = new ShipToInformation();
    Common common = new Common();
    Utility utility = new Utility();
   
    string noRecordMessage = "No Records Found";
    string contactExistMessage = "Contact name already exist";
    string contactSuccessMessage = "Ship To information updated successfully";
    #endregion

    #region Properties
    public string AddressID
    {
        get { return (ViewState["AddressID"] == null) ? "" : ViewState["AddressID"].ToString(); }
        set { ViewState["AddressID"] = value; }
    }

    public string ContactID
    {
        get { return (ViewState["ContactID"] == null) ? "" : ViewState["ContactID"].ToString(); }
        set { ViewState["ContactID"] = value; }
    }

    public string PageMode
    {
        get { return (Request.QueryString["Mode"] == null) ? "" : Request.QueryString["Mode"].ToString().ToLower(); }
    }	 
    #endregion

    #region Page events

    protected void Page_Load(object sender, EventArgs e)
    {
        lblSONumber.Text = Request.QueryString["SONumber"].ToString();
        lblMessage.Text = "";

        if (lblSONumber.Text == "") // If Pop-up opended without SO Number
        {
            lblSONumber.Text = "N/A";
            FillFormBasedOnCustomerNumber();
            printDialogue.Visible = false;
        }
        else // If pop-up opened With SO Number
        {
            if (!IsPostBack)
            {
                pnlAddress.CssClass = "blueTable";
                txtAddress1.ReadOnly = true;
                txtAddress2.ReadOnly = true;
                txtCity.ReadOnly = true;
                txtCountry.ReadOnly = true;
                txtName.ReadOnly = true;
                txtPhone.ReadOnly = true;
                txtPostcode.ReadOnly = true;
                txtState.ReadOnly = true;

                FillDefaultAddressAndContact();
                BindDataGrid();

                printDialogue.CustomerNo = hidCustNo.Value;
                printDialogue.PageUrl = "OneTimeShipToContact.aspx?SONumber=" + lblSONumber.Text;
                printDialogue.PageTitle = "Ship To information for " + lblSONumber.Text;
                
            } 
        }

        if (!IsPostBack)
        {
            EnableControlForNewContact(false);
            EnableControlForOneTime();
        }

        
    }  
    #endregion

    #region Event Handler

    protected void imgExport_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            //hidPrintURL.Value = "PendingOrdersAndQuotesExport.aspx?CustomerNo=" + txtCustomerNumber.Text +
            //    "&LocDesc=" + (ddlLocation.SelectedIndex != 0 ? ddlLocation.SelectedItem.Text : "") +
            //    "&loccode=" + (ddlLocation.SelectedIndex != 0 ? ddlLocation.SelectedItem.Value : "") +
            //    "&OrderTypeDesc=" + (ddlOrderType.SelectedIndex != 0 ? ddlOrderType.SelectedItem.Text : "") +
            //    "&OrderTypeValue=" + (ddlOrderType.SelectedIndex != 0 ? ddlOrderType.SelectedItem.Value : "") +
            //    "&StartDate=" + dtpStartDt.SelectedDate +
            //    "&EndDate=" + dtpEndDt.SelectedDate +
            //    "&ShowDelRecord=" + ViewState["Mode"].ToString();

            //ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "ExportPendingOrdersAndQuotes();", true);
        }
        catch (Exception ex) { }
    }

    protected void gvAddress_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Edits")
        {
            chkNewContact.Checked = true;
            AddressID = e.CommandArgument.ToString();
            FillAddress();
            ClearContact();
            ddlGridMode.SelectedIndex = 1;            
            ddlGridMode_SelectedIndexChanged(ddlGridMode, new EventArgs());
        }
    }

    protected void gvAddress_Sorting(object sender, GridViewSortEventArgs e)
    {

        if (hidAddressSort.Attributes["sortType"] != null)
        {
            if (hidAddressSort.Attributes["sortType"].ToString() == "ASC")
                hidAddressSort.Attributes["sortType"] = "DESC";
            else
                hidAddressSort.Attributes["sortType"] = "ASC";
        }
        else
            hidAddressSort.Attributes.Add("sortType", "ASC");

        hidAddressSort.Value = e.SortExpression + " " + hidAddressSort.Attributes["sortType"].ToString();
        BindDataGrid();
    }

    protected void gvContacts_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Edits")
        {
            ContactID = e.CommandArgument.ToString();
            FillContact();
        }
    }

    protected void gvContacts_Sorting(object sender, GridViewSortEventArgs e)
    {
        if (hidContactSort.Attributes["sortType"] != null)
        {
            if (hidContactSort.Attributes["sortType"].ToString() == "ASC")
                hidContactSort.Attributes["sortType"] = "DESC";
            else
                hidContactSort.Attributes["sortType"] = "ASC";
        }
        else
            hidContactSort.Attributes.Add("sortType", "ASC");

        hidContactSort.Value = e.SortExpression + " " + hidContactSort.Attributes["sortType"].ToString();
        BindContactsGrid();
    }

    protected void ibtnDeletedItem_Click1(object sender, ImageClickEventArgs e)
    {
        ViewState["Mode"] = "ShowAll"; // Display Grid with deleted orders
        BindDataGrid();
    }

    protected void chkOneTime_CheckedChanged(object sender, EventArgs e)
    {
        //ClearAddress();
        //ClearContact();
        EnableControlForOneTime();
         
        if(!chkOneTime.Checked)
            FillDefaultAddressAndContact();
        else
        {
            chkNewContact.Checked=false;
            chkNewShip.Checked=false;
        }
    }

    protected void chkNewShip_CheckedChanged(object sender, EventArgs e)
    {
        //ClearAddress();
        //ClearContact();
        if (!chkNewShip.Checked)
            FillDefaultAddressAndContact();
        else
        {
            chkOneTime.Checked = false;
            EnableControlForNewShipTo();
        }
    }

    protected void chkNewContact_CheckedChanged(object sender, EventArgs e)
    {
        //ClearContact();
        EnableControlForNewContact(chkNewContact.Checked);
        //if (!chkNewContact.Checked)
            //FillDefaultAddressAndContact();
    }

    protected void ddlGridMode_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlGridMode.SelectedValue == "Ship")
        {
            gvAddress.Style.Add(HtmlTextWriterStyle.Display, "");
            gvContacts.Style.Add(HtmlTextWriterStyle.Display, "none");
        }
        else
        {
            BindContactsGrid();
            gvContacts.Style.Add(HtmlTextWriterStyle.Display, "");
            gvAddress.Style.Add(HtmlTextWriterStyle.Display, "none");
        }

        pnlPendingOrderGrid.Update();
    }

    protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
    {
        string columnValues = string.Empty;
        string whereClause = string.Empty;
        string newContactID = string.Empty;
        // Following If statemnt added by Slater
        if (!chkOneTime.Checked)
        {
            if (chkNewShip.Checked)
            {
                columnValues = "'SHP'," +
                              "''," +
                              "'" + txtName.Text.Replace("'", "''") + "'," +
                              "'" + txtAddress1.Text.Replace("'", "''") + "'," +
                              "'" + txtAddress2.Text.Replace("'", "''") + "'," +
                              "'" + txtCity.Text.Replace("'", "''") + "'," +
                              "'" + txtState.Text.Replace("'", "''") + "'," +
                              "'" + txtPostcode.Text.Replace("'", "''") + "'," +
                              "'" + txtCountry.Text.Replace("'", "''") + "'," +
                              "'" + txtPhone.GetFormattedPhoneNumber + "'," +
                              "'" + Session["UserName"].ToString() + "'," +
                              "'" + DateTime.Now.ToShortDateString() + "'";
                AddressID = shipToAddress.AddNewAddress(columnValues);
                columnValues = "fCustomerMasterID =(select pCustMstrID from CustomerMaster where CustNo='" + hidCustNo.Value + "')";
                whereClause = "pCustomerAddressID='" + AddressID + "' and (Type <>'' OR Type<>'P')";
                shipToAddress.UpdateCustomerAddress(columnValues, whereClause);

            }
            else
            {
                if (AddressID != "")
                {
                    columnValues = "[Name2]='" + txtName.Text.Replace("'", "''") + "'," +
                                  "[AddrLine1]='" + txtAddress1.Text.Replace("'", "''") + "'," +
                                  "[AddrLine2]='" + txtAddress2.Text.Replace("'", "''") + "'," +
                                  "[City]='" + txtCity.Text.Replace("'", "''") + "'," +
                                  "[State]='" + txtState.Text.Replace("'", "''") + "'," +
                                  "[PostCd]='" + txtPostcode.Text.Replace("'", "''") + "'," +
                                  "[Country]='" + txtCountry.Text.Replace("'", "''") + "'," +
                                  "[PhoneNo]='" + txtPhone.GetFormattedPhoneNumber + "'," +
                                  "ChangeId='" + Session["UserName"].ToString() + "'," +
                                  "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";
                    whereClause = "pCustomerAddressID='" + AddressID + "' and (Type <>'' OR Type<>'P')";
                    shipToAddress.UpdateCustomerAddress(columnValues, whereClause);
                }
            }
            if (chkNewContact.Checked || chkNewShip.Checked)
            {
                // Insert New Contact Information
                columnValues = "'" + AddressID + "'," +
                                "'" + txtContactJobTitle.Text.Replace("'", "''") + "'," +
                                "'" + txtContactDepart.Text.Replace("'", "''") + "'," +
                                "'" + txtContactExt.Text + "'," +
                                "'" + txtContactFax.GetFormattedPhoneNumber + "'," +
                                "'" + txtContactMob.GetFormattedPhoneNumber + "'," +
                                "'" + txtContactEmail.Text.Replace("'", "''") + "'," +
                                "'" + txtContactName.Text.Replace("'", "''") + "'," +
                                "'" + txtContactPhoneNo.GetFormattedPhoneNumber + "'," +
                                "'" + hidCustNo.Value + "'," +
                                "'" + "A" + "'," +
                                "'" + Session["UserName"].ToString() + "'," +
                                "'" + DateTime.Now.ToShortDateString() + "'";

                ContactID = shipToAddress.AddNewContact(columnValues);
            }
            else
            {
                if (ContactID != "")
                {
                    columnValues = "JobTitle='" + txtContactJobTitle.Text.Replace("'", "''") + "'," +
                                 "Department='" + txtContactDepart.Text.Replace("'", "''") + "'," +
                                 "PhoneExt='" + txtContactExt.Text + "'," +
                                 "FaxNo='" + txtContactFax.GetFormattedPhoneNumber + "'," +
                                 "MobilePhone='" + txtContactMob.GetFormattedPhoneNumber + "'," +
                                 "EmailAddr='" + txtContactEmail.Text.Replace("'", "''") + "'," +
                                 "Name='" + txtContactName.Text.Replace("'", "''") + "'," +
                                 "Phone='" + txtContactPhoneNo.GetFormattedPhoneNumber + "'," +
                                 "ContactCd='" + "A" + "'," +
                                 "ChangeId='" + Session["UserName"].ToString() + "'," +
                                 "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";
                    whereClause = "pCustContactsID=" + ContactID;
                    shipToAddress.UpdateCustomerContact(columnValues, whereClause);
                }
            }
        }
        if (chkOneTime.Checked || (AddressID != "" && ContactID != ""))
        {
            columnValues = "ContactPhoneNo='" + txtContactPhoneNo.GetFormattedPhoneNumber +
                           "',ContactName='" + txtContactName.Text.Replace("'", "''") +
                           "',ShipToContactID='" + ContactID +
                           "',ShipToName='" + txtName.Text.Replace("'", "''") +
                           "',ShipToAddress1='" + txtAddress1.Text.Replace("'", "''") +
                           "',ShipToAddress2='" + txtAddress2.Text.Replace("'", "''") +
                           "',City='" + txtCity.Text.Replace("'", "''") +
                           "',Zip='" + txtPostcode.Text.Replace("'", "''") +
                           "',Country='" + txtCountry.Text.Replace("'", "''") +
                           "',State='" + txtState.Text.Replace("'", "''") +
                           "',PhoneNo='" + txtPhone.GetFormattedPhoneNumber.Replace("'", "''").Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "") +
                           "',ChangeID='" + Session["UserName"].ToString() +
                           "',ChangeDt='" + DateTime.Now.ToShortDateString() + "'";
            if (chkOneTime.Checked)
                columnValues += ",ShipToCd='OT'";
            else
                columnValues += ",ShipToCd=''";
            whereClause = "OrderNo='" + lblSONumber.Text.Trim().ToUpper().Replace("W","") + "'";
            shipToAddress.UpdateSOHeaderContactInformation(columnValues, whereClause);
            chkNewShip.Checked = false;
            chkNewContact.Checked = false;
            BindDataGrid();
            BindContactsGrid();
            pnlPendingOrderGrid.Update();
            utility.DisplayMessage(MessageType.Success, contactSuccessMessage, lblMessage);
            pnlStatusMessage.Update();
             ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "fillParent", "BindEntryForm('" + lblSONumber.Text + "');", true);
        }
        else
            utility.DisplayMessage(MessageType.Failure, "Ship To information not updated successfully", lblMessage);
       
    } 

    #endregion

    #region Developer Method

    private void BindDataGrid()
    {
        DataTable dtCustomerContacts = shipToAddress.GetCustomerAddresses(hidCustNo.Value,false);

        if (dtCustomerContacts.Rows.Count == 0) // if datatable is empty add new row for display purpose
        {
            DataRow dr = dtCustomerContacts.NewRow();
            dtCustomerContacts.Rows.Add(dr);

            if (Page.IsPostBack)
            {
                utility.DisplayMessage(MessageType.Failure, noRecordMessage, lblMessage);
                pnlStatusMessage.Update();
            }
        }
        dtCustomerContacts.DefaultView.Sort = (hidAddressSort.Value == "") ? "Name asc" : hidAddressSort.Value;
        gvAddress.DataSource = dtCustomerContacts.DefaultView.ToTable();
        gvAddress.DataBind();      
        pnlPendingOrderGrid.Update();
    }

    private void BindContactsGrid()
    {
        DataTable dtCustomerContacts = shipToAddress.GetCustomerContacts(AddressID,false);

        if (dtCustomerContacts.Rows.Count == 0) // if datatable is empty add new row for display purpose
        {
            DataRow dr = dtCustomerContacts.NewRow();
            dtCustomerContacts.Rows.Add(dr);

            if (Page.IsPostBack)
            {
                utility.DisplayMessage(MessageType.Failure, noRecordMessage, lblMessage);
                pnlStatusMessage.Update();
            }
        }

        dtCustomerContacts.DefaultView.Sort = (hidContactSort.Value == "") ? "Name asc" : hidContactSort.Value;
        gvContacts.DataSource = dtCustomerContacts.DefaultView.ToTable();
        gvContacts.DataBind();
      

    }

    private void FillAddress()
    {
        DataTable dtDefaultAddress = shipToAddress.GetCustomerAddresses(AddressID,true);

        if (dtDefaultAddress != null && dtDefaultAddress.Rows.Count > 0)
        { 
            txtName.Text = dtDefaultAddress.Rows[0]["Name"].ToString();
            txtAddress1.Text = dtDefaultAddress.Rows[0]["Address1"].ToString();
            txtAddress2.Text = dtDefaultAddress.Rows[0]["Address2"].ToString();
            txtCity.Text = dtDefaultAddress.Rows[0]["City"].ToString();
            txtState.Text = dtDefaultAddress.Rows[0]["State"].ToString();
            txtPostcode.Text = dtDefaultAddress.Rows[0]["PostCode"].ToString();
            txtCountry.Text = dtDefaultAddress.Rows[0]["Country"].ToString();
            txtPhone.GetPhoneNumber = dtDefaultAddress.Rows[0]["PhoneNo"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");
            ClearCheck();
        }
        pnlEntry.Update();
    }

    private void FillContact()
    {
        DataTable dtContact = shipToAddress.GetCustomerContacts(ContactID, true);

        if (dtContact != null && dtContact.Rows.Count > 0)
        {
            txtContactName.Text = dtContact.Rows[0]["Name"].ToString();
            txtContactJobTitle.Text = dtContact.Rows[0]["JobTitle"].ToString();
            txtContactDepart.Text = dtContact.Rows[0]["Department"].ToString();
            txtContactPhoneNo.GetPhoneNumber = dtContact.Rows[0]["Phone"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");
            txtContactExt.Text = dtContact.Rows[0]["PhoneExt"].ToString();
            txtContactFax.GetPhoneNumber = dtContact.Rows[0]["FaxNo"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");
            txtContactMob.GetPhoneNumber = dtContact.Rows[0]["MobilePhone"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");
            txtContactEmail.Text = dtContact.Rows[0]["EmailAddr"].ToString();
            ClearCheck();
        }
        pnlEntry.Update();
    }

    private void FillDefaultAddressAndContact()
    {
        // Fill Default Address infromation
        DataTable dtDefaultAddress = shipToAddress.GetCustomerDefaultAddress(lblSONumber.Text.ToUpper().Replace("W",""));
        // Added by Slater
        AddressID = "";
        ContactID = "";
        // Added by Slater

        if (dtDefaultAddress != null && dtDefaultAddress.Rows.Count > 0)
        {
            hidCustNo.Value = dtDefaultAddress.Rows[0]["SellToCustNo"].ToString();
            txtName.Text = dtDefaultAddress.Rows[0]["ShipToName"].ToString();
            txtAddress1.Text = dtDefaultAddress.Rows[0]["ShipToAddress1"].ToString();
            txtAddress2.Text = dtDefaultAddress.Rows[0]["ShipToAddress2"].ToString();
            txtCity.Text = dtDefaultAddress.Rows[0]["City"].ToString();
            txtState.Text = dtDefaultAddress.Rows[0]["State"].ToString();
            txtPostcode.Text = dtDefaultAddress.Rows[0]["Zip"].ToString();
            txtCountry.Text = dtDefaultAddress.Rows[0]["Country"].ToString();
            txtPhone.GetPhoneNumber = dtDefaultAddress.Rows[0]["PhoneNo"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");
            if(!IsPostBack)
            chkOneTime.Checked = (dtDefaultAddress.Rows[0]["ShipToCd"].ToString()=="OT");
            ContactID = dtDefaultAddress.Rows[0]["ShipToContactID"].ToString();
            DataTable dtContactDetail;

            if (dtDefaultAddress.Rows[0]["ShipToCd"].ToString() == "OT")
            {
                txtContactName.Text = dtDefaultAddress.Rows[0]["ContactName"].ToString();
               // AddressID = dtContactDetail.Rows[0]["fCustAddrID"].ToString();
            }
            else
            {
                // First try to find contact info using contact name
                // if no information found fill default information using CustNo
                dtContactDetail = shipToAddress.GetCustomerContacts(dtDefaultAddress.Rows[0]["ShipToContactID"].ToString().Replace("'", "''"), true);

                if (dtContactDetail.Rows.Count < 1)   // Fill Default Contact information
                {
                   dtContactDetail = shipToAddress.GetDefaultContact(hidCustNo.Value);
                }

                if (dtContactDetail.Rows.Count > 0)
                {
                    txtContactName.Text = dtContactDetail.Rows[0]["Name"].ToString();
                    txtContactJobTitle.Text = dtContactDetail.Rows[0]["JobTitle"].ToString();
                    txtContactDepart.Text = dtContactDetail.Rows[0]["Department"].ToString();
                    txtContactPhoneNo.GetPhoneNumber = dtContactDetail.Rows[0]["Phone"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");
                    txtContactExt.Text = dtContactDetail.Rows[0]["PhoneExt"].ToString();
                    txtContactFax.GetPhoneNumber = dtContactDetail.Rows[0]["FaxNo"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");
                    txtContactMob.GetPhoneNumber = dtContactDetail.Rows[0]["MobilePhone"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");
                    txtContactEmail.Text = dtContactDetail.Rows[0]["EmailAddr"].ToString();
                    AddressID = dtContactDetail.Rows[0]["fCustAddrID"].ToString();
                    ContactID = dtContactDetail.Rows[0]["pCustContactsID"].ToString();
                }
            }
        }
    }

    private void ChangeControlStatus(bool isRecall)
    {
        if (isRecall)
        {
            pnlAddress.CssClass = "blueTable";
            pnlContacts.CssClass = "blueTable";
            divGrid.Style.Add(HtmlTextWriterStyle.Display, "none");
        }
        else
        {
            pnlAddress.CssClass = "whiteTable";
            pnlContacts.CssClass = "whiteTable";
        }

        chkNewContact.Enabled = !isRecall;
        chkNewShip.Enabled = !isRecall;
        
        txtAddress1.ReadOnly = isRecall;
        txtAddress2.ReadOnly = isRecall;
        txtCity.ReadOnly = isRecall;
        txtCountry.ReadOnly = isRecall;
        txtName.ReadOnly = isRecall;
        txtPhone.ReadOnly = isRecall;
        txtPostcode.ReadOnly = isRecall;
        txtState.ReadOnly = isRecall;

        txtContactDepart.ReadOnly = isRecall;
        txtContactEmail.ReadOnly = isRecall;
        txtContactExt.ReadOnly = isRecall;
        txtContactFax.ReadOnly = isRecall;
        txtContactJobTitle.ReadOnly = isRecall;
        txtContactMob.ReadOnly = isRecall;
        txtContactName.ReadOnly = isRecall;
        txtContactPhoneNo.ReadOnly = isRecall;       
    }

    private void ClearAddress()
    {
        txtCity.Text = txtAddress2.Text = "";        
        txtPhone.GetPhoneNumber = txtName.Text = txtCountry.Text = txtAddress1.Text = "";
        txtPostcode.Text = txtState.Text = AddressID = "";
    }

    private void ClearContact()
    {
        txtContactExt.Text = txtContactEmail.Text = txtContactDepart.Text = "";
        txtContactName.Text = txtContactMob.GetPhoneNumber = txtContactJobTitle.Text = txtContactFax.GetPhoneNumber = "";
       txtContactPhoneNo.GetPhoneNumber = ContactID = "";
    }

    private void ClearCheck()
    {
        chkNewContact.Checked = chkNewShip.Checked = chkOneTime.Checked = false;
    }

    private void EnableControlForOneTime()
    {
        if (chkOneTime.Checked)
        {
            bool isOneTime = chkOneTime.Checked;
            pnlAddress.CssClass = "whiteTable";
            pnlContacts.CssClass = "";
            pnlSubContacts.CssClass = "blueTable";
            txtAddress1.ReadOnly = !isOneTime;
            txtAddress2.ReadOnly = !isOneTime;
            txtCity.ReadOnly = !isOneTime;
            txtCountry.ReadOnly = !isOneTime;
            txtName.ReadOnly = !isOneTime;
            txtPhone.ReadOnly = !isOneTime;
            txtPostcode.ReadOnly = !isOneTime;
            txtState.ReadOnly = !isOneTime;
            txtContactName.ReadOnly = !isOneTime;

            txtContactDepart.ReadOnly = isOneTime;
            txtContactEmail.ReadOnly = isOneTime;
            txtContactExt.ReadOnly = isOneTime;
            txtContactFax.ReadOnly = isOneTime;
            txtContactJobTitle.ReadOnly = isOneTime;
            txtContactMob.ReadOnly = isOneTime;
            txtContactPhoneNo.ReadOnly = isOneTime;
        }
        if (chkOneTime.Checked && PageMode == "recall")
        {
            chkNewContact.Enabled = false;
            chkNewShip.Enabled = false;        
            divGrid.Style.Add(HtmlTextWriterStyle.Display, "none");
        }
        else if (!chkOneTime.Checked && PageMode == "recall")
            ChangeControlStatus(true);
        //else if (!chkOneTime.Checked && PageMode != "recall")
        //    ChangeControlStatus(false);
    }

    private void EnableControlForNewShipTo()
    {
        if (chkNewShip.Checked)
        {
            bool isNewShipTo = chkNewShip.Checked;
            pnlAddress.CssClass = "whiteTable";
            pnlContacts.CssClass = "";
            pnlSubContacts.CssClass = "blueTable";
            txtAddress1.ReadOnly = !isNewShipTo;
            txtAddress2.ReadOnly = !isNewShipTo;
            txtCity.ReadOnly = !isNewShipTo;
            txtCountry.ReadOnly = !isNewShipTo;
            txtName.ReadOnly = !isNewShipTo;
            txtPhone.ReadOnly = !isNewShipTo;
            txtPostcode.ReadOnly = !isNewShipTo;
            txtState.ReadOnly = !isNewShipTo;
            txtContactName.ReadOnly = !isNewShipTo;

            txtContactDepart.ReadOnly = isNewShipTo;
            txtContactEmail.ReadOnly = isNewShipTo;
            txtContactExt.ReadOnly = isNewShipTo;
            txtContactFax.ReadOnly = isNewShipTo;
            txtContactJobTitle.ReadOnly = isNewShipTo;
            txtContactMob.ReadOnly = isNewShipTo;
            txtContactPhoneNo.ReadOnly = isNewShipTo;
        }
        //else if (!chkOneTime.Checked && PageMode != "recall")
        //    ChangeControlStatus(false);
    }

    private void EnableControlForNewContact(bool isNewContact)
    {
        if (!isNewContact)
        {
            pnlContacts.CssClass = "blueTable";
        }
        else
        {
            pnlContacts.CssClass = "whiteTable";
        }
        txtContactName.ReadOnly = !isNewContact;
        txtContactDepart.ReadOnly = !isNewContact;
        txtContactEmail.ReadOnly = !isNewContact;
        txtContactExt.ReadOnly = !isNewContact;
        txtContactFax.ReadOnly = !isNewContact;
        txtContactJobTitle.ReadOnly = !isNewContact;
        txtContactMob.ReadOnly = !isNewContact;
        txtContactPhoneNo.ReadOnly = !isNewContact;
    }

    private void FillFormBasedOnCustomerNumber()
    {
        string customerNumber = Request.QueryString["CustNo"].ToString();
        DataSet dtCustomer= common.GetCustomerDefaultInformation(customerNumber);
        DataTable dtCustomerInfo = dtCustomer.Tables[1];
        if (dtCustomerInfo != null && dtCustomerInfo.Rows.Count > 0)
        {
            txtName.Text = dtCustomerInfo.Rows[0]["Name"].ToString();
            txtAddress1.Text = dtCustomerInfo.Rows[0]["Address"].ToString();
            txtAddress2.Text = dtCustomerInfo.Rows[0]["Address 2"].ToString();
            txtCity.Text = dtCustomerInfo.Rows[0]["City"].ToString();
            txtState.Text = dtCustomerInfo.Rows[0]["State"].ToString();
            txtPostcode.Text = dtCustomerInfo.Rows[0]["Post Code"].ToString();
            txtCountry.Text = dtCustomerInfo.Rows[0]["Country"].ToString();
            txtPhone.GetPhoneNumber = dtCustomerInfo.Rows[0]["PhoneNo"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");//utility.FormatPhoneNumber(dtCustomerInfo.Rows[0]["PhoneNo"].ToString());

            txtContactName.Text = dtCustomerInfo.Rows[0]["Contact"].ToString();
            txtContactJobTitle.Text = dtCustomerInfo.Rows[0]["CJobTitle"].ToString();
            txtContactDepart.Text = dtCustomerInfo.Rows[0]["Department"].ToString();
            txtContactPhoneNo.GetPhoneNumber = dtCustomerInfo.Rows[0]["CPhone"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", ""); ;
            txtContactExt.Text = dtCustomerInfo.Rows[0]["CPhoneExt"].ToString();
            txtContactFax.GetPhoneNumber = dtCustomerInfo.Rows[0]["CFaxNo"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", ""); ;
            txtContactMob.GetPhoneNumber = dtCustomerInfo.Rows[0]["CMobilePhone"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", ""); ;
            txtContactEmail.Text = dtCustomerInfo.Rows[0]["CEmailAddr"].ToString();
        }
    }

    #endregion

}
