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
#endregion

public partial class Notes : System.Web.UI.Page
{
    #region Class Variable
    CustomerMaintenance customerMaintenance = new CustomerMaintenance();
 

    #endregion
 

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
    #region Page Load Event
    /// <summary>
    /// Page Load Event Handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        CustomerDetail =customerMaintenance.GetCustomerDetail(CustomerID);
      
        if (!IsPostBack)
        {
            if (CustomerDetail != null && CustomerDetail.Rows.Count > 0)
            {
                lblCustNumber.Text = CustomerDetail.Rows[0]["CustNo"].ToString();

              
                BindDataGrid();
                ViewState["Mode"] = "ADD";
            }  BindNotesType();
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
        DataTable dtNotes = customerMaintenance.SelectNotes(ddlType.SelectedValue, lblCustNumber.Text.Trim());

        dlNotes.DataSource = dtNotes;
        dlNotes.DataBind();
    }
    /// <summary>
    /// Clear user enter values in entry area
    /// </summary>
    private void ClearEntryControl()
    {
        txtNotes.Text = "Enter Notes Here...";
    }
  

    #endregion

    #region Event Handlers
  



    /// <summary>
    /// Save the user input
    /// </summary>
    protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            string columnValue = "";
            if (txtNotes.Text.ToString() != "Enter Notes Here...")
            {
                columnValue = "'" + CustomerID + "','" + lblCustNumber.Text.Trim() + "','" + ddlType.SelectedValue.ToString() + "','" + txtNotes.Text + "','" + Session["UserName"].ToString() + "','" + DateTime.Now.ToShortDateString() + "'";
                customerMaintenance.InsertCustNotes(columnValue);

                lblMessage.Text = customerMaintenance.AddMessage;
                ClearEntryControl();
                BindDataGrid();
                upTaxEntry.Update();
                upTaxGrid.Update();
                upProgress.Update();
            }
            else 
            {
                lblMessage.Text = "Enter the valid Notes";
                upProgress.Update();
            }
        }
        catch (Exception ex)
        {
            throw;
        }
    }
 
   
 
    #endregion

    protected void ddlType_SelectedIndexChanged(object sender, EventArgs e)
    {
        ClearEntryControl();
        BindDataGrid();
        lblMessage.Text = "";
        upTaxEntry.Update();
        upTaxGrid.Update();
    }

    private void BindNotesType()
    {
        customerMaintenance.BindListControls(ddlType, "ListDesc", "ListValue", customerMaintenance.GetNotesType());
        SelectItem(ddlType, "Credit");
    }
    private void SelectItem(DropDownList ddlControl, string value)
    {
        ListItem lItem = ddlControl.Items.FindByValue(value) as ListItem;
        if (lItem != null)
            ddlControl.SelectedValue = value;
    }

}
