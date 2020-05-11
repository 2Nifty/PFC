/********************************************************************************************
 * File	Name			:	OrderType.aspx.cs
 * File Type			:	C#
 * Project Name			:	Sales Order Entry
 * Module Description	:	Sales Order Availability Display page
 * Created By			:	Sathish
 * Created Date			:	1/02/2009 	
 * History*				: 
 * DATE					AUTHOR			                ACTION
 * ****					******				            ******
 * 1/02/2009            Sathish                     Created
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

public partial class OrderTypeDisplay : System.Web.UI.Page
{
    #region Class Variable
    CustomerDetail customerDetail = new CustomerDetail();
     
    #endregion

    #region Page Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindReasonCode(); 
        }
    }
    private void BindReasonCode()
    {
        DataSet dsValue = customerDetail.GetMasterDetails("Tables", "TableCd as Code,TableCd+' - '+ ShortDsc as Name", " TableType='REAS'");
        ddlReasonCode.DataSource = dsValue;
        ddlReasonCode.DataValueField = "Code";
        ddlReasonCode.DataTextField = "Name";
        ddlReasonCode.DataBind();
        ddlReasonCode.Items.Insert(0,new ListItem("-- Select Delete Reason --"));
    }
    #endregion


    protected void ibtnUpdate_Click(object sender, ImageClickEventArgs e)
    {
        if (ddlReasonCode.SelectedIndex != 0)
        {
            Session["DeleteReasonCode"] = ddlReasonCode.SelectedValue.Trim();
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "DeleteOrder", "DeleteOrder();", true);
        }
    }
}
