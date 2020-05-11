using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;
using System.Data.SqlClient;
using System.Net;
using System.IO;
using System.Text;
using PFC.SOE.DataAccessLayer;
using PFC.SOE.Enums;


namespace PFC.SOE.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for PrintInvoice
    /// </summary>

  

    public class SelectPrintInvoice
    {

        string tableName = "";
        string columnName = "";
        string whereClause = "";
        string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        System.Drawing.Bitmap bmImage;

        public string HeaderIDColumn
        {
            get
            {
                if (HttpContext.Current.Session["OrderTableName"].ToString() == "SOHeader")
                    return "fSOHeaderID";
                else if (HttpContext.Current.Session["OrderTableName"].ToString() == "SOHeaderRel")
                    return "pSOHeaderRelID";
                else if (HttpContext.Current.Session["OrderTableName"].ToString() == "SOHeaderHist")
                    return "pSOHeaderHistID";
                else
                    return "fSOHeaderID";
            }
        }
         


        public DataTable GetInvoice(string whereClause)
        {
            //tableName = HttpContext.Current.Session["OrderTableName"].ToString()+ " Hist";
            columnName = "OrderNo as pSOHeaderHistID,convert(varchar(20),OrderNo) + ' - Brn '+ convert(varchar(20),ShipLoc)+' - Inv # '+InvoiceNo  as ShipLoc,InvoiceNo,OrderType,SubType";
            //whereClause = "  Hist.OrderNo='" + orderNo.Trim() + "'";
            DataSet dsInvoice =  SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                           new SqlParameter("@tableName", "SOheaderHist"),
                                           new SqlParameter("@columnName", columnName),
                                           new SqlParameter("@whereClause", whereClause));

            return dsInvoice.Tables[0];

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

                    string imagePhysicalPath = HttpContext.Current.Server.MapPath("") + "\\InvoiceFile\\" + HttpContext.Current.Session.SessionID + i + ".jpg";
                    string imageURL = ConfigurationManager.AppSettings["SOESiteURL"].ToString() + "InvoiceFile/" + HttpContext.Current.Session.SessionID + i + ".jpg";

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

        public string CheckForXML(string invoiceNumber, string invoicetFileName)
        {
            string url = "";
            string _pageURL = "";

            try
            {
                //URL to retrieves Image
               
                _pageURL = "http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232c4%3BNoUI%3D1%3BF0%3D"+invoiceNumber+"P;style=abc123;";

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
                CreateCertXmlFile(url, invoicetFileName);
                // System.Drawing.Image iNewImage = System.Drawing.Image.FromStream(loResponseStream);
                return url;

            }
            catch (Exception ex)
            {
                return "";
            }
        }

        public void CreateCertFile(System.Drawing.Bitmap invoice, string invoiceFileName)
        {
            try
            {
                DeleteCertImage(invoiceFileName);
                //invoice.Save(HttpContext.Current.Server.MapPath("") + "\\InvoiceFile\\" + invoiceFileName);
            }
            catch (Exception ex)
            {

            }
            finally
            {
                invoice.Dispose();
            }
        }
        public void DeleteCertImage(string invoiceFileName)
        {
            //if (fn.Name == certFileName)
            try
            {

                DirectoryInfo drExcel = new DirectoryInfo(HttpContext.Current.Server.MapPath("") + "\\InvoiceFile");



            }
            catch (Exception ex) { throw ex; }

        }
        public void CreateCertXmlFile(string url, string certFileName)
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
                CreateCertFile(bmImage, certFileName);
                loWebResponse.Close();
                loResponseStream.Close();


            }
            catch (Exception ex)
            {

                throw ex;
            }
        }

        public DataTable GetCertImagesFromTifImage(string pageURL)
        {
            return GetCertImages(pageURL);
        }

        public void DisplayMessage(MessageType messageType, string messageText, Label lblMessage)
        {
            switch (messageType)
            {
                case MessageType.Success:
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                    break;
                case MessageType.Failure:
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                    break;
               
            }
        }
    }
  
}