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

public partial class ContractLoader : System.Web.UI.Page
{
    string IntranetSiteURL = ConfigurationManager.AppSettings["IntranetSiteURL"].ToString();

    protected void Page_Load(object sender, EventArgs e)
    {
        
    }
    

    protected void ibtnitem2_Click(object sender, ImageClickEventArgs e)
    {
        Session["LoginName"] = Session["UserName"].ToString();
        Session["CustNo"] = Request.QueryString["CustomerNumber"];
        Session["UploadOption"] = Request.QueryString["UploadOption"];
        Response.Redirect(IntranetSiteURL + "CustomerContractLoader/Reference.aspx?UserName=" + Session["LoginName"].ToString().Trim() + "&CustomerNumber=" + Session["CustNo"].ToString().Trim() + "&UploadOption=" + Session["UploadOption"].ToString().Trim() + "&Internet=yes");
    }
}
