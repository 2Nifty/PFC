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

public partial class RequestQuote_CertRequest : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["RequestPage"] != null && Request.QueryString["RequestPage"] == "CrossRef")
        {
            imgCCRefFile_Click(Page, new ImageClickEventArgs(0,0));

        }

    }

    protected void imgGetCerts_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect(ConfigurationManager.AppSettings["PorteousSiteURL"].ToString() + "GetCerts.aspx?UserName=" + Session["UserType"].ToString() + "&CustomerNumber=" + Session["PFCCustomerNo"].ToString());   
    }

    protected void imgCCRefFile_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect(ConfigurationManager.AppSettings["PorteousSiteURL"].ToString() + "CrossReference.aspx?SystemType=SDK&UserName=SDK&CustomerNumber=" + Session["PFCCustomerNo"].ToString());   
    }
}
