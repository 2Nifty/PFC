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

public partial class RequestQuote_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //string branchid = (Request.QueryString["BranchID"]!= null ? Request.QueryString["BranchID"].ToString() : "");

        //string url = "RequestQuote.aspx?BranchID=" + branchid;
        //string scriptBlock = "window.open('" + url + "','Order','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=No','')";
        //ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "cross", scriptBlock, true);
    }
}
