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

public partial class CPR_Common_UserControls_WebUserControl : System.Web.UI.UserControl
{
    protected void Page_Load(object sender, EventArgs e)
    {


        //btn.Attributes.Add("onclick","javascript:document.getElementById(this.id.replace('btn','Fileupload1')).click();return false;");
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        string fgf = Fileupload1.PostedFile.FileName;
    }
}
