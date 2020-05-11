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
using System.Drawing;
using System.Drawing.Imaging;

public partial class Barcode : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // Get the Requested code to be created.
        string Code = Request["code"].ToString();

        // Multiply the lenght of the code by 40 (just to have enough width)
        int w = Code.Length * 40;

        // Create a bitmap object of the width that we calculated and height of 100
        Bitmap oBitmap = new Bitmap(w, 50);

        // then create a Graphic object for the bitmap we just created.
        Graphics oGraphics = Graphics.FromImage(oBitmap);

        // Now create a Font object for the Barcode Font
        // (in this case the IDAutomationHC39M) of 18 point size
        Font oFont = new Font("IDAutomationC39M", 18);

        // Let's create the Point and Brushes for the barcode
        PointF oPoint = new PointF(2f, 2f);
        SolidBrush oBrushWrite = new SolidBrush(Color.Black);
        SolidBrush oBrush = new SolidBrush(Color.White);

        // Now lets create the actual barcode image
        // with a rectangle filled with white color
        oGraphics.FillRectangle(oBrush, 0, 0, w, 100);

        // We have to put prefix and sufix of an asterisk (*),
        // in order to be a valid barcode
        oGraphics.DrawString("*" + Code + "*", oFont, oBrushWrite, oPoint);

        // Then we send the Graphics with the actual barcode
        Response.ContentType = "image/jpeg";
        oBitmap.Save(Response.OutputStream, ImageFormat.Jpeg);
    }
}
