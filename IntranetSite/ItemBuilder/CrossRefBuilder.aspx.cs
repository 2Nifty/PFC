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

public partial class CrossRefBuilder : System.Web.UI.Page
{
    string IntranetSiteURL = ConfigurationManager.AppSettings["IntranetSiteURL"].ToString();

    protected void Page_Load(object sender, EventArgs e)
    {
        
    }

    protected void ibtnitem1_Click(object sender, ImageClickEventArgs e)
    {    
        Session["LoginName"] = Session["UserName"].ToString();
        Session["CustNo"] = Request.QueryString["CustomerNumber"];
        Response.Redirect(IntranetSiteURL + "Itembuilder/ItemBuilder.aspx?UserName=" + Session["LoginName"].ToString().Trim() + "&CustomerNumber=" + Session["CustNo"].ToString().Trim() + "&Internet=yes");
    }

    protected void ibtnitem2_Click(object sender, ImageClickEventArgs e)
    {
        Session["LoginName"] = Session["UserName"].ToString();
        Session["CustNo"] = Request.QueryString["CustomerNumber"];
        Response.Redirect(IntranetSiteURL +"Itembuilder/Reference.aspx?UserName=" + Session["LoginName"].ToString().Trim() + "&CustomerNumber=" + Session["CustNo"].ToString().Trim() + "&Internet=yes");
    }
}
