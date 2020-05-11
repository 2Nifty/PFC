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
using PFC.Intranet.BusinessLogicLayer;

public partial class InvReportDashboard_GER : System.Web.UI.Page
{
    PFC.Intranet.BusinessLogicLayer.GER ger = new PFC.Intranet.BusinessLogicLayer.GER();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void lnkGER_Click(object sender, EventArgs e)
    {
       string securityCode= ger.GetSecurityCode(Session["UserName"].ToString());
       if (securityCode == "")
           ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "error", "alert('You are not authorized user to access this application. Please contact administrator.');", true);
       else
           ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Open", "LoadPage('GER');", true);
    }
}
