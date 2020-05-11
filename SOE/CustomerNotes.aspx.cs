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

public partial class Notes : System.Web.UI.Page
{
    #region Class Variable
    BillToAddress billToAddress = new BillToAddress();
    Utility utility = new Utility();

    #endregion

    #region Variable Declaration

    string custNumber = "";
    string custPNumber = "";
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
       // lblCustNumber.Text = custNumber = Request.QueryString["CustomerNumber"].ToString();
        if (!IsPostBack)
        {
            BindNotesType();
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
        DataTable dtNotes = billToAddress.SelectNotes(ddlType.SelectedValue,custNumber);

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
                columnValue = "'" + billToAddress.GetCustomerID(custNumber) + "','" + custNumber + "','" + ddlType.SelectedValue.ToString() + "','" + txtNotes.Text + "','" + Session["UserName"].ToString() + "','" + DateTime.Now.ToShortDateString() + "'";
                billToAddress.InsertCustNotes(columnValue);

                lblMessage.Text = utility.AddMessage;
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
        utility.BindListControls(ddlType, "ListDesc", "ListValue", billToAddress.GetNotesType());
        SelectItem(ddlType, "Credit");
    }
    private void SelectItem(DropDownList ddlControl, string value)
    {
        ListItem lItem = ddlControl.Items.FindByValue(value) as ListItem;
        if (lItem != null)
            ddlControl.SelectedValue = value;
    }

}
