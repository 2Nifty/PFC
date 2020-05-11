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
using System.ComponentModel;

public partial class Common_UserControls_FooterImage2 : System.Web.UI.UserControl
{
    #region Property Bag
    private string strFooterTitle = string.Empty;

    /// <summary>
    /// Footer Title
    /// </summary>
    public string FooterTitle
    {
        get { return strFooterTitle; }
        set
        {
            hidFooterTitle.Value = value;
            strFooterTitle = hidFooterTitle.Value;
        }
    }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            CopyrightYear.Text = DateTime.Now.Year.ToString();
            lblPageTitle.Text = this.FooterTitle;
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}
