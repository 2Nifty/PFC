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
using PFC.Intranet.Securitylayer;

public partial class SalesAnalysisReport_ProgressBar : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();

        //
        //Used to check User session
        //
        systemCheck.SessionCheck();
    }
}
