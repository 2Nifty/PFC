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
using PFC.WOE.DataAccessLayer;
using PFC.WOE.BusinessLogicLayer;

namespace PFC.WebPage
{
    public partial class PackByInformation : System.Web.UI.Page
    {

        #region Variable Declaration

        WOEntry woEntry = new WOEntry();
        DataUtility dataUtility = new DataUtility();
              
        
        #endregion

        #region Page events

        protected void Page_Load(object sender, EventArgs e)
        {            
            //ViewState["DisplayMode"] = Request.QueryString["Mode"].ToString();
            //lblMessage.Text = "";


            if (!IsPostBack)
            {
                FillFormBasedOnDefaultValues();
                BindPackByLocations();

            }
            
        }

        protected void gvContacts_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Edits")
            {
                DataSet dtContactDetail = woEntry.GetPackByAddressData("getcontactdetail", e.CommandArgument.ToString());
                lblContactName.Text = dtContactDetail.Tables[0].Rows[0]["Name"].ToString();
                lblContactFax.Text = woEntry.FormatPhoneNumber( dtContactDetail.Tables[0].Rows[0]["FaxNo"].ToString());
                lblContactEmail.Text = dtContactDetail.Tables[0].Rows[0]["EmailAddr"].ToString();                
                pnlContactEntry.Update();
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
            BindALLContacts();
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
            BindPackByLocations();
        }

        protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                string columnValues = string.Empty;
                string whereClause = string.Empty;

                // Update SoHeader Contact information
                columnValues = "ShipToContactName='" + lblContactName.Text.Replace("'", "''") +
                                "',ShipToContactEmail='" + lblContactEmail.Text +
                                "',ShipToContactFaxNo='" + lblContactFax.Text + "'";
                whereClause = Session["POHeaderColumnName"].ToString() + "=" + Session["POHeaderID"].ToString();
                dataUtility.UpdateTableData(Session["POHeaderTableName"].ToString(),columnValues, whereClause);

                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = "Pack By information updated successfully";                
                pnlStatusMessage.Update();
                
                ScriptManager.RegisterClientScriptBlock(ibtnSave, ibtnSave.GetType(), "refresh", "RefreshPackByContact('" + lblContactName.Text + "');", true);
            }
            catch (Exception ex)
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = ex.Message;                
                pnlStatusMessage.Update();
            }

        }

        protected void gvContacts_RowDataBound1(object sender, GridViewRowEventArgs e)
        {
            if (e.Row.RowType == DataControlRowType.DataRow)
            {
                if (e.Row.Cells[1].Text != "" && (e.Row.Cells[1].Text.Length == 10 || e.Row.Cells[1].Text.Length == 11))
                {
                    e.Row.Cells[1].Text = (e.Row.Cells[1].Text.Length == 10 ? string.Format("{0:(###) ###-####}", Convert.ToInt64(e.Row.Cells[1].Text)) : string.Format("{0:#-###-###-####}", Convert.ToInt64(e.Row.Cells[1].Text)));
                }
            }
        }

        protected void ddlGridMode_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlGridMode.SelectedValue == "Address")
            {
                gvAddress.Visible = true;
                gvContacts.Visible = false;
            }
            else
            {
                gvAddress.Visible = false;
                gvContacts.Visible = true;
            }
        }

        protected void gvAddress_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "Edits")
            {
                hidLocCode.Value = e.CommandArgument.ToString();
                BindALLContacts();

                gvAddress.Visible = false;
                gvContacts.Visible = true;
            }
        }

        #endregion

        #region Developer Method

        private void BindPackByLocations()
        {
            DataSet dsPackbyAddress = woEntry.GetPackByAddressData("getpackbyloc", "");
            
            if (dsPackbyAddress != null && dsPackbyAddress.Tables[0].Rows.Count == 0) // if datatable is empty add new row for display purpose
            {
                DataRow dr = dsPackbyAddress.Tables[0].NewRow();
                dsPackbyAddress.Tables[0].Rows.Add(dr);
            }

            dsPackbyAddress.Tables[0].DefaultView.Sort = (hidAddressSort.Value == "") ? "LocName asc" : hidAddressSort.Value;
            gvAddress.DataSource = dsPackbyAddress.Tables[0].DefaultView;
            gvAddress.DataBind();

            pnlGrid.Update();
        }

        private void BindALLContacts()
        {
            DataSet dsContacts = woEntry.GetPackByAddressData("getallcontacts", hidLocCode.Value);
            
            if (dsContacts != null && dsContacts.Tables[0].Rows.Count == 0) 
            {
                DataRow dr = dsContacts.Tables[0].NewRow();
                dsContacts.Tables[0].Rows.Add(dr);
            }
            
            dsContacts.Tables[0].DefaultView.Sort = (hidContactSort.Value == "") ? "Name asc" : hidContactSort.Value;
            gvContacts.DataSource = dsContacts.Tables[0].DefaultView.ToTable();
            gvContacts.DataBind();

            pnlGrid.Update();

        }

        private void FillFormBasedOnDefaultValues()
        {
            // Fill Default Address infromation
            DataTable dtDefaultAddress = dataUtility.GetTableData(Session["POHeaderTableName"].ToString(), "*", Session["POHeaderColumnName"].ToString() + "=" + Session["POHeaderID"].ToString());

            if (dtDefaultAddress != null && dtDefaultAddress.Rows.Count > 0)
            {
                lblWONumber.Text = dtDefaultAddress.Rows[0]["POOrderNo"].ToString();
                lblName.Text = dtDefaultAddress.Rows[0]["ShipToName"].ToString();
                lblAddress1.Text = dtDefaultAddress.Rows[0]["ShipToAddress"].ToString();
                lblAddress2.Text = dtDefaultAddress.Rows[0]["ShipToAddress2"].ToString();
                lblCity.Text = dtDefaultAddress.Rows[0]["ShipToCity"].ToString();
                lblState.Text = dtDefaultAddress.Rows[0]["ShipToState"].ToString();
                lblPostcode.Text = dtDefaultAddress.Rows[0]["ShipToZip"].ToString();
                lblCountry.Text = dtDefaultAddress.Rows[0]["ShipToCountry"].ToString();
                lblPhone.Text = dtDefaultAddress.Rows[0]["ShipToPhoneNo"].ToString();
                lblContactName.Text = dtDefaultAddress.Rows[0]["ShipToContactName"].ToString();
                lblContactFax.Text = dtDefaultAddress.Rows[0]["ShipToContactFaxNo"].ToString();
                lblContactEmail.Text = dtDefaultAddress.Rows[0]["ShipToContactEmail"].ToString();
                hidLocCode.Value = dtDefaultAddress.Rows[0]["ShipToVendorNo"].ToString();
                
                BindALLContacts();
            }
        }

        #endregion

        
}
}
