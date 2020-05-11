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

public partial class WIPOverReceiptChoice : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["TotalRecQty"] != null)
        {
            lblTotalRecQty.Text = Request.QueryString["TotalRecQty"].ToString().Trim();
        }
        if (Request.QueryString["WIPQty"] != null)
        {
            lblWIPQty.Text = Request.QueryString["WIPQty"].ToString().Trim();
        }

    }
}
