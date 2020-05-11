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
using PFC.POE.BusinessLogicLayer; 


public partial class Frame : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        Common common = new Common();
        if (Request.QueryString["UserName"] != null)
        {
            Session["UserName"] = Request.QueryString["UserName"].ToString();

            // Security Code ( SOE(W) or ENTRY(W))
            Session["UserSecurity"] = common.GetSecurityCode(Session["UserName"].ToString());
            if (Session["UserSecurity"].ToString() == "")
                Response.Redirect("common/errorpage/unauthorizedpage.aspx", true);
        }
    }
}
