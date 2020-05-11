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

public partial class Common_UserControls_BottomFrame : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void btnAccept_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("Reconciliation.aspx");
    }
    protected void btnCharges_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("AccessorialCharges.aspx");
    }
    protected void btnProcess_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("Processing.aspx");
    }
}
