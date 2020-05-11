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

public partial class Frame : System.Web.UI.Page
{
    Common common = new Common();
    OrderEntry orderEntry = new OrderEntry();

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(Frame));
        pageCaption.Text = "Sales Order Entry V1.0.0";
        if (Request.QueryString["UserName"] != null)
        {
            Session["UserName"] = Request.QueryString["UserName"].ToString();
            Session["UserID"] = Request.QueryString["UserID"].ToString();
            common.LoadSessionVariables(Request.QueryString["UserID"].ToString());
            Session["IterationCount"] = orderEntry.GetAppPref("Iteration");

            // Security Code ( SOE(W) or ENTRY(W))
            Session["SecurityCode"] = common.GetSecurityCode(Session["UserName"].ToString());         
            if (Session["SecurityCode"].ToString() == "")
                Response.Redirect("common/errorpage/unauthorizedpage.aspx", true);
        }
    }
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void ReleaseLock()
    {
        OrderEntry order = new OrderEntry();
        order.ReleaseLock();
    }
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string  ChangeOrderType()
    {
        return ((Session["ChangeOrderType"] == null) ? "" : "true");
    }

}
