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
using System.Data.SqlClient;
using System.Data.SqlTypes;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
#endregion

public partial class CostBasisPage : System.Web.UI.Page
{

    #region Class Variable

    CustomerMaintenance customerMaintenance = new CustomerMaintenance();

    #endregion
    
    #region Page Load Event
    /// <summary>
    /// Page Load Event Handler
    /// </summary>    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindCostType();
            lblCustNumber.Text = Request.QueryString["CustNo"].ToString();

            object costMethod = SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "UGEN_SP_Select",
                    new SqlParameter("@tableName", "CustomerMaster"),
                    new SqlParameter("@columnNames", "isnull(CostMethod,'') as CostMethod"),
                    new SqlParameter("@whereClause", "CustNo='" + lblCustNumber.Text + "'"));
            if(costMethod!= null)
                SelectItem(ddlCostBasis, costMethod.ToString());
        }
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
            if (ddlCostBasis.SelectedIndex != 0)
            {
                SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "UGEN_SP_Update",
                                             new SqlParameter("@tableName", "CustomerMaster"),
                                             new SqlParameter("@columnNames", "Costmethod='" + ddlCostBasis.SelectedValue + "'"),
                                             new SqlParameter("@whereClause", "CustNo='" + lblCustNumber.Text + "'"));

                lblMessage.Text = "Cost basis has been updated successfuly.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
                upProgress.Update();
            }
            else 
            {
                lblMessage.Text = "Invalid cost basis";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                upProgress.Update();
            }
        }
        catch (Exception ex)
        {
            throw;
        }
    }
 
    #endregion
    
    private void BindCostType()
    {
        try
        {
            string _tableName = "ListMaster (NOLOCK) LM ,ListDetail (NOLOCK) LD";
            string _columnName = "(LD.ListValue + ' - ' + LD.ListdtlDesc) as ListDesc,LD.ListValue ";
            string _whereClause = "LM.ListName = 'setcostbasis' And LD.fListMasterID = LM.pListMasterID  order by SequenceNo asc";
            DataSet dsCostBasis = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "UGEN_SP_Select",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));

            customerMaintenance.BindListControls(ddlCostBasis, "ListDesc", "ListValue", dsCostBasis.Tables[0]);

            ddlCostBasis.Items.Insert(0, new ListItem("---- Select ----", ""));
        }
        catch (Exception ex)
        {            
        }        
    }
    
    private void SelectItem(DropDownList ddlControl, string value)
    {
        ListItem lItem = ddlControl.Items.FindByValue(value) as ListItem;
        if (lItem != null)
            ddlControl.SelectedValue = value;
    }

}
