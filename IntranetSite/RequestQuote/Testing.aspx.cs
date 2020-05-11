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

public partial class RequestQuote_Testing : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        Response.Redirect("http://208.29.238.26/IntranetSite/RequestQuote/Authentication.aspx?loginid='INT-0607252'&PFCCustomerNo='000001'&UserType='INTERNAL'&RequestPage=CrossRef");
    }
}
