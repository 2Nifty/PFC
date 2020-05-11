using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Drawing;
using System.Drawing.Imaging;
using System.Data.SqlClient;
using System.Net;
using System.IO;
using System.Text;
using PFC.SOE.DataAccessLayer;

/// <summary>
/// Summary description for InvoiceRecall
/// </summary>

namespace PFC.SOE.BusinessLogicLayer
{
    public class InvoiceReCall
    {
        string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        string tableName = "";
        string columnName = "";
        string whereClause = "";

        System.Drawing.Bitmap bmImage;

        public DataTable GetBillTo(string invoiceNo)
        {
            try
            {
                DataSet dsInvoice = SqlHelper.ExecuteDataset(ERPConnectionString, "[pSOEInvoiceRecall]",
                                               new SqlParameter("@InvoiceNo", invoiceNo));
                return dsInvoice.Tables[0];
            }
            catch (Exception ex)
            {
                throw ex;

            }

        }

        public DataTable GetInvoice(string whereClause)
        {
            try
            {
                columnName = "InvoiceNo,SellToCustNo,convert(char(10),InvoiceDt,101)as InvoiceDt,CustPONo,TotalOrder";

                DataSet dsInvoice = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                            new SqlParameter("@tablename", "SOHeaderHist"),
                                            new SqlParameter("columnNames", columnName),
                                            new SqlParameter("@whereClause", whereClause));

                return dsInvoice.Tables[0];

            }
            catch (Exception ex)
            {
                throw ex;

            }

        }
        public string GetSecurityCode(string userName)
        {
            try
            {
                tableName = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";
                whereClause = " ' AND (SG.groupname='IRC (W)' OR  SG.groupname='IRC')";

                object objSecurityCode = (object)SqlHelper.ExecuteScalar(ERPConnectionString, "pSOESelect",
                        new SqlParameter("@tableName", tableName ),
                        new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                        new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and SU.UserName='" + userName + whereClause));

                if (objSecurityCode != null)
                    return objSecurityCode.ToString().Trim();
                else
                    return "";

            }
            catch (Exception Ex) { return ""; }
        }

        public bool CheckCertAvailability(string invoiceNumber, string invoiceFileName)
        {
            string _pageURL = "";
            try
            {
                _pageURL ="http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232c4%3BNoUI%3D1%3BF0%3D62571P;style=abc123;";
             // _pageURL = "http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232c4%3BNoUI%3D1%3BF0%3D" + invoiceNumber+"P;style=abc123;";
                
                HttpWebRequest loHttp = (HttpWebRequest)WebRequest.Create(_pageURL);
                HttpWebResponse loWebResponse = (HttpWebResponse)loHttp.GetResponse();
                Encoding enc = Encoding.GetEncoding(1252); // Windows default Code Page                
                Stream loResponseStream = loWebResponse.GetResponseStream();
                System.Drawing.Image iNewImage = System.Drawing.Image.FromStream(loResponseStream);

                //StreamReader sr = new System.IO.StreamReader(loResponseStream);
                //string htmlContent = sr.ReadToEnd();

                //PDF Format File Process

                //BinaryReader reader = new BinaryReader(loResponseStream);
                //Byte[] buffer = new byte[2048];
                //int count = reader.Read(buffer, 0, 2048);
                //int totalSize = 0;
                //while (count > 0)
                //{
                //    totalSize += count;
                //   HttpContext.Current.Response.OutputStream.Write(buffer, 0, count);
                //    count = reader.Read(buffer, 0, 2048);
                //}
                //HttpContext.Current.Response.ContentType = "application/pdf";


                loResponseStream.Close();
                loWebResponse.Close();
                bmImage = (System.Drawing.Bitmap)iNewImage;
                // GetImage(path);
                CreateCertFile(bmImage, invoiceFileName);
                return true;

            }
            catch (Exception ex)
            {

                return false;
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

        //public DataTable GetCertImagesFromTifImage(string invoiceNumber)
        //{
        //  string  pageURL = "http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232c4%3BNoUI%3D1%3BF0%3D" + invoiceNumber+"P;style=abc123;";
        //  //string pageURL ="http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232c4%3BNoUI%3D1%3BF0%3D62571P;style=abc123;";
        //  //  string pageURL="http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232b6%3BNoUI%3D1%3BF0%3D00200-2400-021%3BF1%3D951120%3BF2%3D15092009;Style=abc";
        //    return GetCertImages(pageURL);
        //}

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
               // _pageURL = "http://10.1.35.247:85/LibertyIMS::/anon/Cmd%3DXmlGetRequest%3BName%3D%232c4%3BNoUI%3D1%3BF0%3D62571P;style=abc123;";
            
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
    }
  }

