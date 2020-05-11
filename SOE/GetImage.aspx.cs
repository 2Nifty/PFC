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
using System.Net;
using System.IO;
using System.Text;
using System.Drawing;
using PFC.SOE.BusinessLogicLayer;

public partial class _GetImage : System.Web.UI.Page
{
    string _pageURL = "";
    Certs certs;

    protected void Page_Load(object sender, EventArgs e)
    {
       
        certs = new Certs();
         if (Request.QueryString["ImgType"] != "Multiple")
        {
            _pageURL = "http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232b6%3BNoUI%3D1%3BF0%3D" + Request.QueryString["ItemNo"].ToString() + "%3BF2%3D" + Request.QueryString["LotNo"].ToString();            
        }
        else
        {
            if (Request.QueryString["IUrl"] != null)
            {
                _pageURL = Server.UrlDecode(Request.QueryString["IUrl"].ToString());
            }
            else
            {
                _pageURL = Session["ImgURL"].ToString();
            }
        }

        GetImage(_pageURL);
        
    }

    public bool GetImage(string url)
    { 
        try
        {
            HttpWebRequest loHttp = (HttpWebRequest)WebRequest.Create(url);
            HttpWebResponse loWebResponse = (HttpWebResponse)loHttp.GetResponse();
            Encoding enc = Encoding.GetEncoding(1252); // Windows default Code Page
            Stream loResponseStream = loWebResponse.GetResponseStream();
            System.Drawing.Image iNewImage = System.Drawing.Image.FromStream(loResponseStream);
            loResponseStream.Close();
            loWebResponse.Close();
            System.Drawing.Bitmap bmImage = (System.Drawing.Bitmap)iNewImage;
            bmImage.Save(Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
            loWebResponse.Close();
            loResponseStream.Close();
            return true;
            
        }
        catch (Exception ex)
        {

            return false;
        }
    }
}
