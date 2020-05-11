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
using PFCQuoteService;

public partial class RequestQuote_Authentication : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string loginID = Request.QueryString["LoginID"].ToString().Replace("'", "");
        string pfcCustomer = Request.QueryString["PFCCustomerNo"].ToString().Replace("'", "");
        string userType = Request.QueryString["UserType"].ToString().Replace("'", "");
        string displayCrossRef = "";

        eQuote equote = new eQuote();
        if (equote.ValidateCustomer(userType, loginID, pfcCustomer))
        {
            Session["PFCCustomerNo"] = pfcCustomer;
            Session["UserType"] = userType;
            if (Request.QueryString["RequestPage"] != null && Request.QueryString["RequestPage"] == "CrossRef")
            {
                displayCrossRef = Request.QueryString["RequestPage"].ToString();

            }
            Server.Transfer("PFCTools.aspx?RequestPage="+ displayCrossRef);
        }
        else
            Response.Redirect(ConfigurationManager.AppSettings["IntranetSiteURL"].ToString() + "Common/ErrorPage/unauthorizedpage.aspx");
        
    }
}
