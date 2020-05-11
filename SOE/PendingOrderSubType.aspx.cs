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
    OrderEntry orderEntry = new OrderEntry();
    string soID = "";
    #endregion

    public string SOHeaderTable
    {
        get
        {
            return Session["OrderTableName"].ToString();
        }
    }
    public string HeaderIDColumn
    {
        get
        {
            if (Session["OrderTableName"].ToString() == "SOHeader")
                return "fSOHeaderID";
            else if (Session["OrderTableName"].ToString() == "SOHeaderRel")
                return "pSOHeaderRelID";
            else if (Session["OrderTableName"].ToString() == "SOHeaderHist")
                return "pSOHeaderHistID";
            else
                return "fSOHeaderID";
        }
    }
    #region Page Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
       
        if (!IsPostBack)
        {
            string QECount = orderEntry.GetSoftLockData();
            if (Convert.ToInt32(QECount) < 1) // If we have any SO lock with 'QE' then main page was closed by QuoteRecall, don't display the pop-up
            {
                if ((Request.QueryString["FormClose"] != null && (Session["ChangeOrderType"] != null && Session["ChangeOrderType"].ToString() != "true")) || Session["ChangeOrderType"] == null)
                {
                    orderEntry.ReleaseLock();
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Close", "window.close();", true);
                }
                else
                    BindPendingOrderCode();
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Close", "window.close();", true);
            }
            
        }
    }

    private void BindPendingOrderCode()
    {
        DataSet dsValue = customerDetail.GetMasterDetails("listmaster,listdetail", "ListValue as 'Value',ListValue +'-'+ListDtlDesc as 'Code',ListValue +' - '+ListDtlDesc as 'Name'", " SequenceNo ='99' and listmaster.pListMasterID =listdetail.fListMasterID and listmaster.ListName='SOEOrderTypes' order by listdetail.ListValue");
        ddlOrderType.DataSource = dsValue;
        ddlOrderType.DataValueField = "Code";
        ddlOrderType.DataTextField = "Name";
        ddlOrderType.DataBind();
        ddlOrderType.Items.Insert(0, new ListItem("-- Select Order Type--"));
    }

    #endregion 
    protected void ddlOrderType_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            soID = (Session["OrderHeaderID"] == null) ? "" : Session["OrderHeaderID"].ToString();
            if (soID != "")
            {
                if (Session["OrderType"].ToString() == "TO" && ddlOrderType.SelectedValue.Split('-')[0] != "PTO") // For TO orders type
                {
                    ScriptManager.RegisterClientScriptBlock(ddlOrderType, typeof(DropDownList), "", "alert('Only you can convert this order into Pending Transfer Order.');", true);
                    return;
                }
                else
                {
                    if (ddlOrderType.SelectedValue.Split('-')[0] == "PTO" && Session["OrderType"].ToString() != "TO")
                    {
                        ScriptManager.RegisterClientScriptBlock(ddlOrderType, typeof(DropDownList), "", "alert('You can not convert this order into Pending Transfer Order.');", true);
                        return;
                    }
                    else
                    {
                        string[] values = ddlOrderType.SelectedValue.Split('-');
                        string updateColumn = "[OrderType]='" + values[0].Trim() + "',SubType='99',OrderTypeDsc='" + values[1] + "',";
                        customerDetail.UpdateHeader(SOHeaderTable, updateColumn + "ChangeID='" + Session["UserName"].ToString() + "',ChangeDt='" + DateTime.Now.ToShortDateString() + "'", HeaderIDColumn + "=" + soID);
                        if (Request.QueryString["FormClose"] == null)
                            orderEntry.ReleaseLock();
                        ddlOrderType.Enabled = false;
                    }
                }

            }
             ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Load", "window.opener.location.href=window.opener.location.href;window.close();", true);
               
        }
        catch (Exception ex)
        {
            throw;
        }
    }
}
