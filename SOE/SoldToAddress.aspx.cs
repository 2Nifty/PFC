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

namespace PFC.WebPage
{
    public partial class SoldToInformation : System.Web.UI.Page
    {

        #region Variable Declaration

        SoldToAddress soldToAddress = new SoldToAddress();
        Utility utility = new Utility();
        Common common = new Common();

        string noRecordMessage = "No Records Found";
        string contactSuccessMessage = "Sold To information updated successfully";

        #endregion

        #region Page events

        protected void Page_Load(object sender, EventArgs e)
        {
            SecurityCheck();
            
            ViewState["DisplayMode"] = Request.QueryString["Mode"].ToString();
            lblMessage.Text = "";

            if (Request.QueryString["SONumber"].ToString() == "") // If Pop-up opended without SO Number
            {
                lblSONumber.Text = "N/A";
                FillFormBasedOnCustomerNumber();
                printDialogue.Visible = false;
            }
            else // If pop-up opened With SO Number
            {
                lblSONumber.Text = Request.QueryString["SONumber"].ToString();
                if (!IsPostBack)
                {
                    FillDefaultAddressAndContact();
                    BindDataGrid();

                    printDialogue.CustomerNo = hidCustNo.Value;
                    printDialogue.PageUrl = Server.UrlEncode("SoldToAddressExport.aspx?SONumber=" + lblSONumber.Text);
                    printDialogue.PageTitle = "Sold To Address for " + lblSONumber.Text;
                }
            }
            
            if (!IsPostBack)
            {
                DisplayMode();
            }
            
        }

        protected void gvContacts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Edits")
            {
                hidfCustAddrID.Value = e.CommandArgument.ToString().Split('~')[0];
                hidpCustContactID.Value = e.CommandArgument.ToString().Split('~')[1];
                DataTable dtContactDetail = soldToAddress.GetContactDetail(hidpCustContactID.Value);
                FillContactInformation(dtContactDetail);
                chkNewContact.Checked = false;
                pnlContactEntry.Update();

                //ScriptManager.RegisterClientScriptBlock(gvContacts, gvContacts.GetType(), "fillParent", "BindOrderEntryForm('" + SoHeaderID + "');", true);
            }
        }

        protected void gvContacts_Sorting(object sender, GridViewSortEventArgs e)
        {
            if (hidSort.Attributes["sortType"] != null)
            {
                if (hidSort.Attributes["sortType"].ToString() == "ASC")
                    hidSort.Attributes["sortType"] = "DESC";
                else
                    hidSort.Attributes["sortType"] = "ASC";
            }
            else
                hidSort.Attributes.Add("sortType", "ASC");

            hidSort.Value = e.SortExpression + " " + hidSort.Attributes["sortType"].ToString();
            BindDataGrid();
        }

        protected void ibtnDeletedItem_Click1(object sender, ImageClickEventArgs e)
        {
            ViewState["Mode"] = "ShowAll"; // Display Grid with deleted orders
            BindDataGrid();
        }

        protected void chkNewContact_CheckedChanged(object sender, EventArgs e)
        {
            if (chkNewContact.Checked)
            {
                txtContactName.Text = "";
                txtContactJobTitle.Text = "";
                txtContactDepart.Text = "";
                txtContactPhoneNo.GetPhoneNumber = "";
                txtContactExt.Text = "";
                txtContactFax.GetPhoneNumber = "";
                txtContactMob.GetPhoneNumber = "";
                txtContactEmail.Text = "";
                pnlContactEntry.Update();
            }
            else
            {
                DataTable dtContactDetail = soldToAddress.GetContactDetail(hidpCustContactID.Value);
                FillContactInformation(dtContactDetail);
                pnlContactEntry.Update();

            }

        }

        protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                string columnValues = string.Empty;
                string whereClause = string.Empty;

                if (chkNewContact.Checked)
                {
                    // Insert New Contact Information
                    columnValues = "'" + hidfCustAddrID.Value + "'," +
                                    "'" + txtContactJobTitle.Text.Replace("'", "''") + "'," +
                                    "'" + txtContactDepart.Text.Replace("'", "''") + "'," +
                                    "'" + txtContactExt.Text + "'," +
                                    "'" + txtContactFax.GetPhoneNumber + "'," +
                                    "'" + txtContactMob.GetPhoneNumber.Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "") + "'," +
                                    "'" + txtContactEmail.Text.Replace("'", "''") + "'," +
                                    "'" + txtContactName.Text.Replace("'", "''") + "'," +
                                    "'" + txtContactPhoneNo.GetPhoneNumber + "'," +
                                    "'" + hidCustNo.Value + "'," +
                                    "'" + "A" + "'," +
                                    "'" + Session["UserName"].ToString() + "'," +
                                    "'" + DateTime.Now.ToString() + "'";

                    string newContactID = soldToAddress.AddNewContact(columnValues);

                    // Update SoHeader Contact information
                    columnValues = "SellToContactPhoneNo='" + txtContactPhoneNo.GetPhoneNumber +
                                    "',SellToContactName='" + txtContactName.Text.Replace("'", "''") +
                                    "',SellToContactID='" + newContactID + "'";
                    whereClause = "OrderNo='" + lblSONumber.Text.Trim() + "'";
                    soldToAddress.UpdateSOHeaderContactInformation(columnValues, whereClause);

                    BindDataGrid();
                    utility.DisplayMessage(MessageType.Success, contactSuccessMessage, lblMessage);
                    pnlStatusMessage.Update();
                    pnlContactGrid.Update();
                }
                else
                {
                    // Update SoHeader Contact information
                    columnValues = "SellToContactPhoneNo='" + txtContactPhoneNo.GetPhoneNumber +
                                    "',SellToContactName='" + txtContactName.Text.Replace("'", "''") +
                                    "',SellToContactID='" + hidpCustContactID.Value + "'";
                    whereClause = "OrderNo='" + lblSONumber.Text.Trim() + "'";
                    soldToAddress.UpdateSOHeaderContactInformation(columnValues, whereClause);

                    utility.DisplayMessage(MessageType.Success, contactSuccessMessage, lblMessage);
                    pnlStatusMessage.Update();
                }

                ScriptManager.RegisterClientScriptBlock(ibtnSave, ibtnSave.GetType(), "refresh", "RefreshSoldToContact('" + txtContactName.Text + "');", true);


            }
            catch (Exception ex)
            {
                utility.DisplayMessage(MessageType.Failure, ex.Message, lblMessage);
                pnlStatusMessage.Update();
            }

        }

        protected void gvContacts_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (e.Row.Cells[3].Text != "" && (e.Row.Cells[3].Text.Length == 10 || e.Row.Cells[3].Text.Length == 11))
                {
                    e.Row.Cells[3].Text = (e.Row.Cells[3].Text.Length == 10 ? string.Format("{0:(###) ###-####}", Convert.ToInt64(e.Row.Cells[3].Text)) : string.Format("{0:#-###-###-####}", Convert.ToInt64(e.Row.Cells[3].Text)));
                }
                if (e.Row.Cells[5].Text != "" && (e.Row.Cells[5].Text.Length == 10 || e.Row.Cells[5].Text.Length == 11))
                {
                    e.Row.Cells[5].Text = (e.Row.Cells[5].Text.Length == 10 ? string.Format("{0:(###) ###-####}", Convert.ToInt64(e.Row.Cells[5].Text)) : string.Format("{0:#-###-###-####}", Convert.ToInt64(e.Row.Cells[5].Text)));
                }
                if (e.Row.Cells[6].Text != "" && (e.Row.Cells[6].Text.Length == 10 || e.Row.Cells[6].Text.Length == 11))
                {
                    e.Row.Cells[6].Text = (e.Row.Cells[6].Text.Length == 10 ? string.Format("{0:(###) ###-####}", Convert.ToInt64(e.Row.Cells[6].Text)) : string.Format("{0:#-###-###-####}", Convert.ToInt64(e.Row.Cells[6].Text)));
                }
            }
        }

        #endregion

        #region Developer Method

        private void BindDataGrid()
        {
            DataTable dtCustomerContacts = soldToAddress.GetAllCustomer(hidCustNo.Value); ;

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

            dtCustomerContacts.DefaultView.Sort = (hidSort.Value == "") ? "Name asc" : hidSort.Value;
            gvContacts.DataSource = dtCustomerContacts.DefaultView.ToTable();
            gvContacts.DataBind();

            // Hide Deleted Date Column base on mode
            // gvContacts.Columns[10].Visible = (ViewState["Mode"].ToString() == "Active" ? false : true);
            pnlContactGrid.Update();

        }

        private void FillDefaultAddressAndContact()
        {
            // Fill Default Address infromation
            DataTable dtDefaultAddress = soldToAddress.GetCustomerDefaultAddress(lblSONumber.Text);

            if (dtDefaultAddress != null && dtDefaultAddress.Rows.Count > 0)
            {
                hidCustNo.Value = dtDefaultAddress.Rows[0]["SellToCustNo"].ToString();
                lblName.Text = dtDefaultAddress.Rows[0]["SellToCustName"].ToString();
                lblAddress1.Text = dtDefaultAddress.Rows[0]["SellToAddress1"].ToString();
                lblAddress2.Text = dtDefaultAddress.Rows[0]["SellToAddress2"].ToString();
                lblCity.Text = dtDefaultAddress.Rows[0]["SellToCity"].ToString();
                lblState.Text = dtDefaultAddress.Rows[0]["SellToState"].ToString();
                lblPostcode.Text = dtDefaultAddress.Rows[0]["SellToZip"].ToString();
                lblCountry.Text = dtDefaultAddress.Rows[0]["SellToCountry"].ToString();
                lblPhone.Text = utility.FormatPhoneNumber(dtDefaultAddress.Rows[0]["SellToContactPhoneNo"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", ""));

                DataTable dtContactDetail;

                // First try to find contact info using contact name
                // if no information found fill default information using CustNo
                dtContactDetail = soldToAddress.GetContactInfoByContactID(dtDefaultAddress.Rows[0]["SellToContactID"].ToString().Replace("'", "''"));

                //if (dtContactDetail.Rows.Count < 1)   // Fill Default Contact information
                //{
                //   // dtContactDetail = soldToAddress.GetDefaultContact(hidCustNo.Value);
                //}

                FillContactInformation(dtContactDetail);

            }
        }

        private void FillContactInformation(DataTable dtContactDetail)
        {
            if (dtContactDetail.Rows.Count > 0)
            {
                hidpCustContactID.Value = dtContactDetail.Rows[0]["pCUstContactsID"].ToString();
                hidfCustAddrID.Value = dtContactDetail.Rows[0]["fCustAddrID"].ToString();
                txtContactName.Text = dtContactDetail.Rows[0]["Name"].ToString();
                txtContactJobTitle.Text = dtContactDetail.Rows[0]["JobTitle"].ToString();
                txtContactDepart.Text = dtContactDetail.Rows[0]["Department"].ToString();
                txtContactPhoneNo.GetPhoneNumber = dtContactDetail.Rows[0]["Phone"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");
                txtContactExt.Text = dtContactDetail.Rows[0]["PhoneExt"].ToString();
                txtContactFax.GetPhoneNumber = dtContactDetail.Rows[0]["FaxNo"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");
                txtContactMob.GetPhoneNumber = dtContactDetail.Rows[0]["MobilePhone"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");
                txtContactEmail.Text = dtContactDetail.Rows[0]["EmailAddr"].ToString();
            }
        }

        private void SecurityCheck()
        {
            if (Session["UserSecurity"] == null || Session["UserSecurity"].ToString() == string.Empty)
                ibtnSave.Visible = false;
        }

        private void DisplayMode()
        {
            if (ViewState["DisplayMode"] != null && ViewState["DisplayMode"].ToString().ToLower() == "recall")
            {
                ibtnSave.Visible = false;
                pnlContactGrid.Visible = false;
                txtContactName.CssClass = "lblBluebox";
                txtContactName.ReadOnly = true;
                txtContactPhoneNo.CssClass = "lblBluebox";
                txtContactPhoneNo.ReadOnly = true;
                txtContactMob.CssClass = "lblBluebox";
                txtContactMob.ReadOnly = true;
                txtContactJobTitle.CssClass = "lblBluebox";
                txtContactJobTitle.ReadOnly = true;
                txtContactFax.CssClass = "lblBluebox";
                txtContactFax.ReadOnly = true;
                txtContactExt.CssClass = "lblBluebox";
                txtContactExt.ReadOnly = true;
                txtContactEmail.CssClass = "lblBluebox";
                txtContactEmail.ReadOnly = true;
                txtContactDepart.CssClass = "lblBluebox";
                txtContactDepart.ReadOnly = true;
                chkNewContact.Visible = false;
            }
            //RegisterClientScriptBlock("Mode", "<script>alert(document.body.clientHeight);document.body.clientHeight='20px';</script>");
        }

        private void ExportShipToAddress(string exportMode)
        {
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "ExportShipToAddress('" + exportMode + "');", true);
        }

        private void FillFormBasedOnCustomerNumber()
        {
            string customerNumber = Request.QueryString["CustNo"].ToString();
            DataSet dtCustomer = common.GetCustomerDefaultInformation(customerNumber);
            DataTable dtCustomerInfo = dtCustomer.Tables[1];
            if (dtCustomerInfo != null && dtCustomerInfo.Rows.Count > 0)
            {
                lblName.Text = dtCustomerInfo.Rows[0]["Name"].ToString();
                lblAddress1.Text = dtCustomerInfo.Rows[0]["Address"].ToString();
                lblAddress2.Text = dtCustomerInfo.Rows[0]["Address 2"].ToString();
                lblCity.Text = dtCustomerInfo.Rows[0]["City"].ToString();
                lblState.Text = dtCustomerInfo.Rows[0]["State"].ToString();
                lblPostcode.Text = dtCustomerInfo.Rows[0]["Post Code"].ToString();
                lblCountry.Text = dtCustomerInfo.Rows[0]["Country"].ToString();
                lblPhone.Text = dtCustomerInfo.Rows[0]["PhoneNo"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");

                txtContactName.Text = dtCustomerInfo.Rows[0]["Contact"].ToString();
                txtContactJobTitle.Text = dtCustomerInfo.Rows[0]["CJobTitle"].ToString();
                txtContactDepart.Text = dtCustomerInfo.Rows[0]["Department"].ToString();
                txtContactPhoneNo.GetPhoneNumber = dtCustomerInfo.Rows[0]["CPhone"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");
                txtContactExt.Text = dtCustomerInfo.Rows[0]["CPhoneExt"].ToString();
                txtContactFax.GetPhoneNumber = dtCustomerInfo.Rows[0]["CFaxNo"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");
                txtContactMob.GetPhoneNumber = dtCustomerInfo.Rows[0]["CMobilePhone"].ToString().Replace("(", "").Replace(")", "").Replace("-", "").Replace(" ", "");
                txtContactEmail.Text = dtCustomerInfo.Rows[0]["CEmailAddr"].ToString();
            }
        }

        #endregion

    }
}
