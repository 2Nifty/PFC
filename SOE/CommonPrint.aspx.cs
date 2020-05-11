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
using PFC.Intranet.Securitylayer;

public partial class CommonPrint : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {       
        string PrintURL = Server.UrlDecode(Request.QueryString["PageURL"].ToString().Replace("`", "'"));
        //url = url.Remove(url.Length - 1, 1);
        PrintURL = ConfigurationManager.AppSettings["SOESiteURL"].ToString() + PrintURL;

        //WebRequest req = WebRequest.Create(PrintURL);
        //WebResponse resp = req.GetResponse();
        //Stream s = resp.GetResponseStream();
        //StreamReader sr = new StreamReader(s, Encoding.ASCII);
        //string htmlContent = sr.ReadToEnd();
        //htmlContent = System.Web.HttpUtility.HtmlDecode(htmlContent);
        //divContent.InnerHtml = htmlContent;



        // Create a request using a URL that can receive a post. 
        HttpWebRequest webRequest = (HttpWebRequest)System.Net.WebRequest.Create(PrintURL);
        // Set the Method property of the request to POST.
        webRequest.Headers.Clear();
        webRequest.AllowAutoRedirect = true;
        webRequest.PreAuthenticate = true;
        webRequest.ContentType = "application / x - www - form - urlencoded";
        webRequest.Credentials = CredentialCache.DefaultCredentials;
        webRequest.UserAgent = "Mozilla/4.0 (compatible; MSIE 5.01; Windows NT 5.0)";
        webRequest.Timeout = 150000;
        // Create POST data and convert it to a byte array.

        WebResponse webResponse = null;
        StreamReader objSR;
        System.Text.Encoding encode = System.Text.Encoding.GetEncoding("utf-8");
        Stream objStream;
        string htm;

        webResponse = (HttpWebResponse)webRequest.GetResponse();
        objStream = webResponse.GetResponseStream();
        objSR = new StreamReader(objStream, encode, true);
        //<<sResponse doesn't contain Unicode char values>>
        divContent.InnerHtml = objSR.ReadToEnd();
        objSR.Close();

       
    }
}
