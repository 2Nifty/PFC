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

public partial class TopFrame : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            lblUserInfo.Text = DateTime.Now.ToLongDateString() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; You have logged in as <strong>" + (Session["UserName"] != null ? Session["UserName"].ToString() :"") + "</strong> in <strong>" + System.Configuration.ConfigurationManager.AppSettings["Environment"];

        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}
