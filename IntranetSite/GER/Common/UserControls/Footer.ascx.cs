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

public partial class Common_UserControls_NewFooter : System.Web.UI.UserControl
{
    /// <summary>
    /// Set the Title to be display at the footer
    /// </summary>
    public string Title
    {
        get { return lblHeading.Text; }
        set { lblHeading.Text = value; }
    }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        //lnkCopyRight.Attributes.Add("onmouseout", "javascript:document.getElementById('Tooltip').style.display = 'block';");
        //lnkCopyRight.Attributes.Add("onmouseover", "javascript:DisplayToolTip('true');");
        //lnkCopyRight.Attributes.Add("onclick", "javascript:DisplayToolTip('false');");

        lnkCopyRight.Text = PFC.Intranet.BusinessLogicLayer.ApplicationConfiguration.CorporateName + ". All rights reserved. Terms & Conditions";
    }
}
