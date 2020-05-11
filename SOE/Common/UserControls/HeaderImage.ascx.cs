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

public partial class GER_Common_UserControls_HeaderImage : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {
        //lblUserInfo.Text = "Login as " + Session["UserName"].ToString() + ", " + "Environment: " + System.Configuration.ConfigurationManager.AppSettings["Environment"];
    
        lblDateTime.Text = DateTime.Now.ToLongDateString();
       
    }
}
