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
using PFC.SOE.BusinessLogicLayer; 
#endregion

public partial class TaxExempt : System.Web.UI.Page
{
    #region Class Variable
    BillToAddress billToAddress = new BillToAddress();
    Utility utility = new Utility();

    #endregion

    #region Variable Declaration

    string custPNumber = "";
    string custNumber = "";
    string CustId = "";
    #endregion

    #region Page Load Event
    /// <summary>
    /// Page Load Event Handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        custPNumber = Request.QueryString["CustomerNumber"].ToString();
        lblCustNumber.Text = custNumber = billToAddress.GetCustomerNumber(custPNumber);
        lblCustName.Text = billToAddress.GetCustomerName(custNumber);
        lnkListMaster.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");
        if (!IsPostBack)
        {
            BindState();
            BindDataGrid();
            ViewState["Mode"] = "ADD";
        }
        if (Session["UserSecurity"].ToString() == "")
            ibtnSave.Visible = false;
    } 
    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        DataSet dsTax = billToAddress.SelectTaxExempt(custNumber);
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
        utility.BindListControls(ddlState, "ListDesc", "ListValue", billToAddress.GetStates(), "-- Select State --");
    }
    /// <summary>
    /// Bind User entered values 
    /// </summary>
    private void BindEntryControl()
    {
        try
        {
            ViewState["Mode"] = "EDIT";
            DataTable dtGetTaxDetail = billToAddress.GetTaxDetail(hidTaxID.Value);
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
                billToAddress.DeleteTaxExempt(whereClause);
                lblMessage.Text = utility.DeleteMessage;
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
    }
    /// <summary>
    /// Save the user input
    /// </summary>
    protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            DateTime dExpDate;
            dExpDate = Convert.ToDateTime(dtpExpDate.SelectedDate);
            string columnValue = "";
            if (ViewState["Mode"].ToString() == "ADD")
            {
                //fCustMasterID, CustNo, ResaleCertNo, State, ExpirationDt,  ChangeID, ChangeDt
                columnValue = "'" + billToAddress.GetCustomerID(custNumber) + "','" + custNumber + "','" + txtCert.Text.Trim() + "','" + ddlState.SelectedValue+ "','" + dExpDate + "','" + Session["UserName"].ToString() + "','" + DateTime.Now.ToShortDateString() + "'";
                billToAddress.InsertTaxExempt(columnValue);
                lblMessage.Text = utility.AddMessage;
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
                billToAddress.UpdateTaxExempt(columnValue, whereClause);
                lblMessage.Text = utility.UpdateMessage;
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
