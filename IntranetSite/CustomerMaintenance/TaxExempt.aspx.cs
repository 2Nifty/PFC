/********************************************************************************************
 * File	Name			:	TaxExempt.aspx.cs
 * File Type			:	C#
 * Project Name			:	Sales Order Entry
 * Module Description	:	Tax Exempt
 * Created By			:	Sathya Ramasamy
 * Created Date			:	12/05/2008	
 * History*				: 
 * DATE					AUTHOR			                ACTION
 * ****					******				            ******
 * 12/05/2008           Senthilkumar                   Created
 *********************************************************************************************/

#region Namespace
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
#endregion

public partial class TaxExempt : System.Web.UI.Page
{
    #region Class Variable
    CustomerMaintenance customerMaintenance = new CustomerMaintenance();
  

    #endregion

    #region Variable Declaration

 
    public string CustomerID
    {
        get { return Request.QueryString["CustomerID"].ToString(); }
    }
    public DataTable CustomerDetail
    {
        set
        {
            ViewState["CustomerDetail"] = value;
        }
        get
        {
            if (ViewState["CustomerDetail"] != null)
                return (DataTable)ViewState["CustomerDetail"];
            else
                return null;
        }

    }
    #endregion

    #region Page Load Event
    /// <summary>
    /// Page Load Event Handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
       
        lnkListMaster.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");
        if (!IsPostBack)
        {
            Session["UserSecurity"] = "t";
            CustomerDetail = customerMaintenance.GetCustomerDetail(CustomerID);
            if (CustomerDetail != null && CustomerDetail.Rows.Count > 0)
            {
                lblCustNumber.Text = CustomerDetail.Rows[0]["CustNo"].ToString();
                lblCustName.Text = CustomerDetail.Rows[0]["CustName"].ToString(); 
                BindDataGrid();
                ViewState["Mode"] = "ADD";
            }
            BindState();
           
        }
        if (Session["SecurityCode"].ToString().Trim() != "" && Session["CustomerLock"].ToString().Trim() != "L")
            ibtnSave.Visible = true;
        else
            ibtnSave.Visible = false;
    } 
    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        DataSet dsTax = customerMaintenance.SelectTaxExempt(lblCustNumber.Text.Trim());
        if (dsTax != null)
        {
            dsTax.Tables[0].DefaultView.Sort = (hidSort.Value == "") ? "ResaleCertNo asc" : hidSort.Value;

            gvTax.DataSource = dsTax.Tables[0].DefaultView.ToTable();
            gvTax.DataBind();
        }

    }
    /// <summary>
    /// Clear user enter values in entry area
    /// </summary>
    private void ClearEntryControl()
    {
        txtCert.Text = "";
        ddlState.SelectedIndex = 0;
        dtpExpDate.SelectedDate = "";
        lblChangeDate.Text = "";
        lblChangeID.Text = "";
        lblEntryDate.Text = "";
        lblEntryID.Text = "";
    }

    private void BindState()
    {
        customerMaintenance.BindListControls(ddlState, "ListDesc", "ListValue", customerMaintenance.GetStates(), "-- Select State --");
    }
    /// <summary>
    /// Bind User entered values 
    /// </summary>
    private void BindEntryControl()
    {
        try
        {
            ViewState["Mode"] = "EDIT";
            DataTable dtGetTaxDetail = customerMaintenance.GetTaxDetail(hidTaxID.Value);
            txtCert.Text = dtGetTaxDetail.Rows[0]["ResaleCertNo"].ToString();

            ddlState.SelectedIndex = -1;
            ListItem lstItem = ddlState.Items.FindByValue(dtGetTaxDetail.Rows[0]["State"].ToString().Trim()) as ListItem;
            if (lstItem != null)
                lstItem.Selected = true;
            
            dtpExpDate.SelectedDate = Convert.ToDateTime(dtGetTaxDetail.Rows[0]["ExpirationDt"].ToString()).ToShortDateString();

            lblChangeDate.Text = (dtGetTaxDetail.Rows[0]["ChangeDt"].ToString() !="") ? Convert.ToDateTime(dtGetTaxDetail.Rows[0]["ChangeDt"].ToString()).ToShortDateString() : "";
            lblChangeID.Text = dtGetTaxDetail.Rows[0]["ChangeID"].ToString();
            lblEntryDate.Text = Convert.ToDateTime(dtGetTaxDetail.Rows[0]["EntryDt"].ToString()).ToShortDateString();
            lblEntryID.Text = dtGetTaxDetail.Rows[0]["EntryID"].ToString();

            upTaxEntry.Update();
        }
        catch (Exception)
        {
            throw;
        }
    }

    #endregion

    #region Event Handlers
    protected void gvTax_Sorting(object sender, GridViewSortEventArgs e)
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
        upTaxEntry.Update();
    }

    protected void gvTax_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Edits")
        {
            hidTaxID.Value = e.CommandArgument.ToString().Trim();
            BindEntryControl();
        }
        else if (e.CommandName == "Deletes")
        {
            try
            {
                string whereClause = "pTaxExemptID=" + e.CommandArgument.ToString();
                customerMaintenance.DeleteTaxExempt(whereClause);
                lblMessage.Text = customerMaintenance.DeleteMessage;
                BindDataGrid();
                upTaxGrid.Update();
                upProgress.Update();
            }
            catch (Exception ex)
            {
                throw;
            }
        }

    }
    /// <summary>
    /// Perform item data bound event
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvTax_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            LinkButton lnkDelete = e.Row.FindControl("lnlDelete") as LinkButton;
            if (Session["SecurityCode"].ToString().Trim() != "" && Session["CustomerLock"].ToString().Trim() != "L") 
            lnkDelete.Visible = false;
        }
    }
    /// <summary>
    /// Save the user input
    /// </summary>
    protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            DateTime dExpDate;
            string strState = string.Empty;
            dExpDate = Convert.ToDateTime(dtpExpDate.SelectedDate);
            strState = (ddlState.SelectedValue == "" )? "": "";
            string columnValue = "";
            if (ViewState["Mode"].ToString() == "ADD")
            {
                //fCustMasterID, CustNo, ResaleCertNo, State, ExpirationDt,  ChangeID, ChangeDt
                columnValue = "'" + CustomerID + "','" + lblCustNumber.Text.Trim() + "','" + txtCert.Text.Trim() + "','" + ddlState.SelectedValue + "','" + dExpDate + "','" + Session["UserName"].ToString() + "','" + DateTime.Now.ToShortDateString() + "'";
                customerMaintenance.InsertTaxExempt(columnValue);
                lblMessage.Text = customerMaintenance.AddMessage;
            }
            else
            {
                dExpDate = Convert.ToDateTime(dtpExpDate.SelectedDate);

                //fCustMasterID, CustNo, ResaleCertNo, State, ExpirationDt, ChangeID, ChangeDt
                string whereClause = "pTaxExemptID=" + hidTaxID.Value;
                columnValue = "ResaleCertNo='" + txtCert.Text.Trim()
                              + "',State='" + ddlState.SelectedValue 
                              + "',ExpirationDt='" + dExpDate  
                              + "',ChangeID='" + Session["UserName"].ToString() 
                              + "',ChangeDt='" + DateTime.Now.ToShortDateString() 
                              + "'";
                customerMaintenance.UpdateTaxExempt(columnValue, whereClause);
                lblMessage.Text = customerMaintenance.UpdateMessage;
            }
            ViewState["Mode"] = "ADD";
            ClearEntryControl();
            BindDataGrid();
            upTaxEntry.Update();
            upTaxGrid.Update();
            upProgress.Update();
        }
        catch (Exception ex)
        {
            throw;
        }
    }
 
   
 
    #endregion
    
}
