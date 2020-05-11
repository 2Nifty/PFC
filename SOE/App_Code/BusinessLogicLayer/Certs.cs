using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Net;
using System.Text;
using System.IO;
using System.Collections;
using System.Drawing.Imaging;
using System.Drawing;
using System.Net;
using System.Text;
using System.IO;

namespace PFC.SOE.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for Certs
    /// </summary>
    public class Certs
    {
        System.Drawing.Bitmap bmImage;

        public bool CheckCertAvailability(string itemNumber,string pfcLotNumber, string MfgLotNumber, string certFileName)
        {
            string _pageURL = "";
            try
            {
                if (pfcLotNumber.Trim() != "")
                {
                    _pageURL = "http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232b6%3BNoUI%3D1%3BF0%3D"+itemNumber+"%3BF1%3D"+ pfcLotNumber +"%3BF2%3D"+ MfgLotNumber +";Sty;e=abc";
                }
                else
                {
                    _pageURL = "http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232b6%3BNoUI%3D1%3BF0%3D" + itemNumber + "%3BF2%3D" + MfgLotNumber + ";Style=abc";
                }
                HttpWebRequest loHttp = (HttpWebRequest)WebRequest.Create(_pageURL);
                HttpWebResponse loWebResponse = (HttpWebResponse)loHttp.GetResponse();
                Encoding enc = Encoding.GetEncoding(1252); // Windows default Code Page                
                Stream loResponseStream = loWebResponse.GetResponseStream();
                System.Drawing.Image iNewImage = System.Drawing.Image.FromStream(loResponseStream);

                loResponseStream.Close();
                loWebResponse.Close();
                bmImage = (System.Drawing.Bitmap)iNewImage;
                // GetImage(path);
               CreateCertFile(bmImage, certFileName);
                return true;

            }
            catch (Exception ex)
            {

                return false;
            }
        }

        public string CheckForXML(string itemNumber,string pfcLotNumber, string MfglotNumber,string certFileName)
        {
            string url = "";
            string _pageURL = "";

            try
            {

                if (pfcLotNumber.Trim() != "")
                {
                    _pageURL = "http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232b6%3BNoUI%3D1%3BF0%3D"+ itemNumber +"%3BF1%3D"+ pfcLotNumber + "%3BF2%3D"+ MfglotNumber +";Style=abc";
                }
                else
                {
                    _pageURL = "http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232b6%3BNoUI%3D1%3BF0%3D" + itemNumber + "%3BF2%3D" + MfglotNumber + ";Style=abc";
                }
                HttpWebRequest loHttp = (HttpWebRequest)WebRequest.Create(_pageURL);
                HttpWebResponse loWebResponse = (HttpWebResponse)loHttp.GetResponse();
                Encoding enc = Encoding.GetEncoding(1252); // Windows default Code Page

                Stream loResponseStream = loWebResponse.GetResponseStream();

                StreamReader loResponseStream1 = new StreamReader(loWebResponse.GetResponseStream());

                string strStream = loResponseStream1.ReadToEnd();

                DataSet ds = new DataSet();
                StringReader loReader = new StringReader(strStream);


                ds.ReadXml(loReader);

                if (ds.Tables["IndexRecord"].Rows.Count > 0 && ds.Tables["IndexRecord"] != null)
                {
                    DataTable dt = new DataTable();
                    dt = ds.Tables["IndexRecord"];
                    url = dt.Rows[0]["RawDocumentLink"].ToString();

                }
                CreateCertXmlFile(url, certFileName);
                // System.Drawing.Image iNewImage = System.Drawing.Image.FromStream(loResponseStream);
                return url;

            }
            catch (Exception ex)
            {
                return "";
            }
        }

        public void CreateCertFile(System.Drawing.Bitmap certificate, string certFileName)
        {
            try
            {
                DeleteCertImage(certFileName);
                certificate.Save(HttpContext.Current.Server.MapPath("") + "\\CertsFile\\" + certFileName);
            }
            catch (Exception ex)
            {

            }
            finally
            {
                certificate.Dispose();
            }
        }

        public void DeleteCertImage(string certFileName)
        {
                //if (fn.Name == certFileName)
            try
            {

                DirectoryInfo drExcel = new DirectoryInfo(HttpContext.Current.Server.MapPath("") + "\\CertsFile");

                //foreach (FileInfo fn in drExcel.GetFiles())
                //{
                //    if (fn.Name.Contains(certFileName.Remove(certFileName.Length - 4, 4)))
                //        fn.Delete();
                //}

                
            }
            catch (Exception ex) { throw ex; }

        }

        public void CreateCertXmlFile(string url,string certFileName)
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
                //bmImage.Save(Response.OutputStream, System.Drawing.Imaging.ImageFormat.Jpeg);
                CreateCertFile(bmImage,certFileName);
                loWebResponse.Close();
                loResponseStream.Close();
               

            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public DataTable GetCertImagesFromTifImage(string itemNumber,string pfcLotNumber, string mfgLotNumber)
        {
            string _pageURL = "";
            if (pfcLotNumber.Trim() != "")
            {
                _pageURL = "http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232b6%3BNoUI%3D1%3BF0%3D"+itemNumber+"%3BF1%3D"+ pfcLotNumber +"%3BF2%3D" + mfgLotNumber + ";Style=abc";
            }
            else
            {
                _pageURL = "http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232b6%3BNoUI%3D1%3BF0%3D" + itemNumber + "%3BF2%3D" + mfgLotNumber+ ";style=abc;";
            }
            return GetCertImages(_pageURL);
        }
        
        public DataTable GetCertImagesFromTifImage(string pageURL)
        {
            return GetCertImages(pageURL);
        }

        private DataTable GetCertImages(string pageUrl)
        {
            try
            {
                Guid myGuid;
                FrameDimension myDimension;
                int myPageCount;
                Bitmap myBMP;

                //
                // Image Information
                //
                DataTable dtCert = new DataTable();
                dtCert.Columns.Add("ImagePhysicalPath");
                dtCert.Columns.Add("ImageURL");
                DataRow drCerts;


                HttpWebRequest loHttp = (HttpWebRequest)WebRequest.Create(pageUrl);
                HttpWebResponse loWebResponse = (HttpWebResponse)loHttp.GetResponse();
                Encoding enc = Encoding.GetEncoding(1252); // Windows default Code Page                
                Stream loResponseStream = loWebResponse.GetResponseStream();

                MemoryStream ms;
                System.Drawing.Image myImage;
                myImage = System.Drawing.Image.FromStream(loResponseStream);
                myGuid = myImage.FrameDimensionsList[0];
                myDimension = new FrameDimension(myGuid);
                myPageCount = myImage.GetFrameCount(myDimension);
                for (int i = 0; i < myPageCount; i++)
                {
                    drCerts = dtCert.NewRow();
                    ms = new MemoryStream();
                    myImage.SelectActiveFrame(myDimension, i);
                    myImage.Save(ms, ImageFormat.Bmp);
                    myBMP = new Bitmap(ms);

                    string imagePhysicalPath = HttpContext.Current.Server.MapPath("") + "\\CertsFile\\" + HttpContext.Current.Session.SessionID + i + ".jpg";
                    string imageURL = ConfigurationManager.AppSettings["PFCOnlineSiteURL"].ToString() + "CertsFile/" + HttpContext.Current.Session.SessionID + i + ".jpg";

                    myBMP.Save(imagePhysicalPath);
                    drCerts["ImagePhysicalPath"] = imagePhysicalPath;
                    drCerts["ImageURL"] = imageURL;
                    dtCert.Rows.Add(drCerts);

                    ms.Close();
                }
                loResponseStream.Close();

                return dtCert;
            }
            catch (Exception ex)
            {
                return null;
            }
        }
    }
}
