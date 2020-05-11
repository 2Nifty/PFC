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
using System.Drawing.Imaging;



public partial class Test : System.Web.UI.Page
{
    string VisitorsIPAddr;
    protected void Page_Load(object sender, EventArgs e)
    {
    }
        //byte[] bytes = System.Convert.FromBase64String(xDocument.SelectSingleNode("Response/Images/Photo").InnerText);


        //System.IO.MemoryStream ms = new System.IO.MemoryStream(bytes);

        //System.Drawing.Bitmap b = new System.Drawing.Bitmap(ms); //(Bitmap)System.Drawing.Image.FromStream(ms);

        //System.Drawing.Imaging.FrameDimension frameDim;
        //frameDim = new System.Drawing.Imaging.FrameDimension(b.FrameDimensionsList[0]);


        //int NumberOfFrames = b.GetFrameCount(frameDim);
        //string[] paths = new string[NumberOfFrames];

        //for (int i = 0; i < NumberOfFrames; i++)
        //{
        //    b.SelectActiveFrame(frameDim, i);

        //    System.Drawing.Bitmap bmp = new System.Drawing.Bitmap(b);
        //    paths[i] = imagePathfile.Remove(imagePathfile.Length - 4, 4) + i.ToString() + ".gif";

        //    bmp.Save(paths[i], System.Drawing.Imaging.ImageFormat.Gif);
        //    //bmp.Save(Response.OutputStream, System.Drawing.Imaging.ImageFormat.Gif);
        //    bmp.Dispose();
        //}

        //Image1.Src = paths[0];
        ////Check if there's more than 1 image cause its a TIFF
        //if (paths.Length > 1)
        //{
        //    Image2.Src = paths[1];
        //}


    private void GetIpAddress()
    {

        string strHostName = System.Net.Dns.GetHostName();
        string clientIPAddress = System.Net.Dns.GetHostAddresses(strHostName).GetValue(0).ToString();

        lblResult.Text += strHostName + " ,";
        //lblResult.Text += clientIPAddress + " ,";
        if (HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"] != null)
        {
            //To get the IP address of the machine and not the proxy
            VisitorsIPAddr = HttpContext.Current.Request.ServerVariables["HTTP_X_FORWARDED_FOR"].ToString();
        }
        else if (HttpContext.Current.Request.UserHostAddress.Length != 0)
        {
           // VisitorsIPAddr = HttpContext.Current.Request.UserHostAddress;
           VisitorsIPAddr = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
        }

        lblResult.Text += VisitorsIPAddr;
    }
    protected void btnSubmit_Click(object sender, EventArgs e)
    {

        GetIpAddress();
       
    }
}
