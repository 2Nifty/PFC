using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Text;
using System.IO;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Net;
public partial class CommonPrint : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        string PrintURL = Server.UrlDecode(Request.QueryString["PageURL"].ToString().Replace("`", "'"));
        //url = url.Remove(url.Length - 1, 1);
        PrintURL = ConfigurationManager.AppSettings["WOESiteURL"].ToString() + PrintURL;

        WebRequest req = WebRequest.Create(PrintURL);
        WebResponse resp = req.GetResponse();
        Stream s = resp.GetResponseStream();
        StreamReader sr = new StreamReader(s, Encoding.ASCII);
        string htmlContent = sr.ReadToEnd();
        htmlContent = System.Web.HttpUtility.HtmlDecode(htmlContent);
        divContent.InnerHtml = htmlContent;
    }
}
