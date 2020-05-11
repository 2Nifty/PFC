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

    OrderEntry orderEntry = new OrderEntry();
    string orderNo = "";

    #endregion

    #region Page Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        orderNo = Request.QueryString["OrderNo"].ToString();
        lblCaption.Text = "Order Selection for Order # " + orderNo;

        CheckOrderAvailability();
    }

  
    private void CheckOrderAvailability()
    {
        DataSet dsOrderType = orderEntry.GetAvailableOrderType(orderNo);
        bool isValidNumber = false;

        if (dsOrderType != null)
        {
            if (dsOrderType.Tables[0].Rows.Count > 0)
            {
                lnkOriginalOrder.Text = orderNo;
                isValidNumber = true;
                lblOrgOrder.Visible = true;
            }
            else
            {
                lblOrgOrder.Visible = false;
            }

            if (dsOrderType.Tables[1].Rows.Count > 0)
            {
                dlInvoiced.DataSource = dsOrderType.Tables[1];
                dlInvoiced.DataBind();
                lblInvOrder.Visible = true;
            }
            else
            {
                lblInvOrder.Visible = false;
            }

            if (dsOrderType.Tables[2].Rows.Count > 0)
            {
                dlReleased.DataSource = dsOrderType.Tables[2];
                dlReleased.DataBind();
                lblRelOrder.Visible = true;
            }
            else
            {
                lblRelOrder.Visible = false;
            }
        } 
    }
    
    private void SetOrderType(string OrderMode,string orderID)
    {
        // Update the session value
        switch (OrderMode)
        {
            case "Order":
                Session["OrderTableName"] = "SOHeader";
                Session["DetailTableName"] = "SODetail";
               // Session["OrderHeaderID"] = orderID;
                break;
            case "Released":
                Session["OrderTableName"] = "SOHeaderRel";
                Session["DetailTableName"] = "SODetailRel";
               // Session["OrderHeaderID"] = orderID;
                break;
            case "Invoiced":
                Session["OrderTableName"] = "SOHeaderHist";
                Session["DetailTableName"] = "SODetailHist";
               // Session["OrderHeaderID"] = orderID;
                break;
            default:
                Session["OrderTableName"] = "SOHeader";
                Session["DetailTableName"] = "SODetail";
              //  Session["OrderHeaderID"] = orderID;
                break;
        }

        // Close the child window
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "orderType", "ReloadPO(" + orderID + ");", true);
        
    }
    #endregion



    protected void dlReleased_ItemCommand(object source, DataListCommandEventArgs e)
    {
        if (e.CommandName == "Load")
        {
            SetOrderType("Released",e.CommandArgument.ToString().Trim());
        }
    }
    protected void dlInvoiced_ItemCommand(object source, DataListCommandEventArgs e)
    {
        if (e.CommandName == "Load")
        {
            SetOrderType("Invoiced", e.CommandArgument.ToString().Trim());
        }
    }
    protected void lnkOriginalOrder_Click(object sender, EventArgs e)
    {
        SetOrderType("Order", orderNo);
    }

    protected void ibtnClose_Click1(object sender, ImageClickEventArgs e)
    {
        ScriptManager.RegisterClientScriptBlock(ibtnClose, ibtnClose.GetType(), "winclose", "window.close();", true);
    }
}
