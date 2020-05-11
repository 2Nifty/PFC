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

public partial class PFCIntranet_Common_UserControls_MessageDisplay : System.Web.UI.UserControl
{
    private string _MessageText;
    private bool _Visible;

    public string MessageText
    {
        get { return lblFlag.Text; }
        set { lblFlag.Text = value; }
    }
    public bool Visible
    {
        get { return panMessage.Visible; }
        set { panMessage.Visible = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        MessageBox.Visible = false;
        MainTable.Visible = true;
    }
}
