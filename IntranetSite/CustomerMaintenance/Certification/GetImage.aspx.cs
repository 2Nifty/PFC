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



public partial class _Default : System.Web.UI.Page
{
    string itemNo = "";
    string lotNo = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        //string _pageURL = Request.QueryString["PageURL"].ToString();

        try
        {
            string _pageURL = Request.QueryString["PageURL"].ToString();
            HttpWebRequest loHttp = (HttpWebRequest)WebRequest.Create(_pageURL);
            HttpWebResponse loWebResponse = (HttpWebResponse)loHttp.GetResponse();
            Encoding enc = Encoding.GetEncoding(1252); // Windows default Code Page
            //StreamReader loResponseStream = new StreamReader(loWebResponse.GetResponseStream(), enc);
            //Stream buffer = loResponseStream.BaseStream;
            Stream loResponseStream = loWebResponse.GetResponseStream();
            System.Drawing.Image iNewImage = System.Drawing.Image.FromStream(loResponseStream);
            loResponseStream.Close();
            loWebResponse.Close();
            System.Drawing.Bitmap bmImage = (System.Drawing.Bitmap)iNewImage;
            // Bitmap bmImage = new Bitmap(buffer);
            bmImage.Save(Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
            loWebResponse.Close();
            loResponseStream.Close();


        }
        catch (Exception ex)
        {
            throw ex;
        }
        //GetImage(_pageURL);

        //try
        //{
        //    itemNo = Request.QueryString["ItemNo"].ToString();
        //    lotNo = Request.QueryString["LotNo"].ToString();

        //   string _pageURL = "http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232b6%3BNoUI%3D1%3BF0%3D" +itemNo+ "%3BF2%3D" +lotNo;
        //   //string _pageURL = Request.QueryString["PageURL"].ToString();
        //    HttpWebRequest loHttp = (HttpWebRequest)WebRequest.Create(_pageURL);
        //    HttpWebResponse loWebResponse = (HttpWebResponse)loHttp.GetResponse();
        //    Encoding enc = Encoding.GetEncoding(1252); // Windows default Code Page
        //    //StreamReader loResponseStream = new StreamReader(loWebResponse.GetResponseStream(), enc);
        //    //Stream buffer = loResponseStream.BaseStream;
        //    //Bitmap bmImage = new Bitmap(buffer);
        //    Stream loResponseStream = loWebResponse.GetResponseStream();
        //    System.Drawing.Image iNewImage = System.Drawing.Image.FromStream(loResponseStream);
        //    System.Drawing.Bitmap bmImage = (System.Drawing.Bitmap)iNewImage;
        //    bmImage.Save(Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
        //    loWebResponse.Close();
        //    loResponseStream.Close();

        //}
        //catch (Exception ex)
        //{
        //    //Response.Redirect("GetCerts.aspx?ItemNo="+itemNo +"&LotNo="+lotNo ); 
        //    //Response.Redirect("www.google.com"); 
        //        throw ex;
        //}

    }

    public void GetImage(string url)
    {

        try
        {
            string _pageURL = Request.QueryString["PageURL"].ToString();
            HttpWebRequest loHttp = (HttpWebRequest)WebRequest.Create(_pageURL);
            HttpWebResponse loWebResponse = (HttpWebResponse)loHttp.GetResponse();
            Encoding enc = Encoding.GetEncoding(1252); // Windows default Code Page
            //StreamReader loResponseStream = new StreamReader(loWebResponse.GetResponseStream(), enc);
            //Stream buffer = loResponseStream.BaseStream;
            Stream loResponseStream = loWebResponse.GetResponseStream();
            System.Drawing.Image iNewImage = System.Drawing.Image.FromStream(loResponseStream);
            loResponseStream.Close();
            loWebResponse.Close();
            System.Drawing.Bitmap bmImage = (System.Drawing.Bitmap)iNewImage;
            // Bitmap bmImage = new Bitmap(buffer);
            bmImage.Save(Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
            loWebResponse.Close();
            loResponseStream.Close();
           

        }
        catch (Exception ex)
        {
            throw ex;
            
        }
    }

}
