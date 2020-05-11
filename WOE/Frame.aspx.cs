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
using PFC.WOE.BusinessLogicLayer;
using PFC.WOE.SecurityLayer;

public partial class Frame : System.Web.UI.Page
{
    Common common = new Common();
    SecurityUtility security = new SecurityUtility();

    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Expires = -1;

        Ajax.Utility.RegisterTypeForAjax(typeof(Frame));
        pageCaption.Text = "Work Order Entry V1.0.0";
        if (Request.QueryString["UserName"] != null)
        {
            Session["UserName"] = Request.QueryString["UserName"].ToString();
            Session["UserID"] = Request.QueryString["UserID"].ToString();
            if (Request.QueryString["WOOrderNo"] != null)
            {
                Session["WOOrderNo"] = Request.QueryString["WOOrderNo"].ToString();
            }
            else
            {
                Session["WOOrderNo"] = null;
            }
            common.LoadSessionVariables(Request.QueryString["UserID"].ToString());

            // Security Code ( SOE(W) or ENTRY(W))
            Session["SecurityCode"] = security.GetSecurityCode(Session["UserName"].ToString(), "WOWorkSheet");
            if (Session["SecurityCode"].ToString() == "")
                Response.Redirect("common/errorpage/unauthorizedpage.aspx", true);
        }
        else
        {
            Response.Write("No Session");
        }


    }
   
}
