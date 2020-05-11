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
using System.IO;
using PFC.Intranet.Securitylayer;

public partial class CPR_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        string fgf= Fileupload1.PostedFile.FileName;
    }
    protected void Button1d_Click(object sender, EventArgs e)
    {
        string fgf = Fileupload2.PostedFile.FileName;
        
        Stream fStream = File.OpenRead(txt.Text);
    
    }
}
