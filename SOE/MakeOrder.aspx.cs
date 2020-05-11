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

public partial class MakeOrder : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string orderNo = Request.QueryString["OrderNo"].ToString();
        lblCaption.Text = "Make Order For Order# " + orderNo;
    }
}
