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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;

public partial class GetCerts : System.Web.UI.Page
{
    string itemNo = "";
    string lotNo = "";
    Certs certs = new Certs();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["ItemNo"] != null && Request.QueryString["LotNo"] != null)
        {
            itemNo = Request.QueryString["ItemNo"].ToString();
            lotNo = Request.QueryString["LotNo"].ToString();
            // bool imageFlag = Request.QueryString["ImgFlag"].ToString();
            if (itemNo != "" && lotNo != "")
            {
                Response.Write("Error");
                tdAssist.Visible = true;
                imgCerts.Visible = false;
                ClearControl();
               // upnlAssist.Update();
               
               


            }
        }

        upnlCerts.Update();
        
    }

    protected void btnGetCert_Click(object sender, EventArgs e)
    {

        if (txtItemNumber.Text != "")
        {
            string _pageURL = "http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232b6%3BNoUI%3D1%3BF0%3D" + txtItemNumber.Text.Trim() + "%3BF2%3D" + txtLotNo.Text.Trim();

            if (certs.CheckCertAvailability(_pageURL))
            {
                imgCerts.ImageUrl = "GetImage.aspx?PageURL=" + Server.UrlEncode(_pageURL);
                hplEnlarge.NavigateUrl = "GetImage.aspx?PageURL=" + Server.UrlEncode(_pageURL); 
                imgCerts.Visible = true;
            }
            else
            {
                tdAssist.Visible = true;
            }
            upnlCerts.Update();
        }
       

        //if (txtItemNumber.Text != "")
        //{

        //    //string _pageURL = Server.UrlEncode("http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232b6%3BNoUI%3D1%3BF0%3D" + txtItemNumber.Text.Trim() + "%3BF2%3D" + txtLotNo.Text.Trim());
        //    //imgCerts.ImageUrl = "GetImage.aspx?PageURL=" + _pageURL;
        //    //hplEnlarge.NavigateUrl = "GetImage.aspx?PageURL=" + _pageURL;
        //    imgCerts.Visible = true;

        //    imgCerts.ImageUrl = "GetImage.aspx?ItemNo=" + txtItemNumber.Text + "&LotNo=" + txtLotNo.Text;


        //    Response.Write(imgCerts.ImageUrl);
           
            

        //   // divGetEnlargeImage.Visible = true;
        //}

    }

    public void ClearControl()
    {
        txtItemNumber.Text = txtLotNo.Text = " ";
        tdAssist.Visible = true;
        
    }

    

}
