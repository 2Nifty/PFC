using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.IO;
using System.Net;
using System.Threading;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml;
using PFC.Intranet.DataAccessLayer;

public partial class PurchaseImportXmlExport : System.Web.UI.Page
{
    string ERPConnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    public DataRow row1;
    string XmlFileName;
    string fullpath;

    protected void Page_Init(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FTPUpdatePanel.Visible = false;
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // Initializing AJAX.NET Library 
        Ajax.Utility.RegisterTypeForAjax(typeof(PurchaseImportXmlExport));
        PageFooter2.FooterTitle = "Purchase Import XML Exporte";
        PIXmlScriptManager.AsyncPostBackTimeout = 3600;
        if (!IsPostBack)
        {
            // get the data.
            Session["PIXmlData"] = null;
            lblProcessed.Visible = false;
            btnConfirm.Visible = false;
        }
        else
        {
        }
    }

    protected void Submit_Click(object sender, EventArgs e)
    {
        lblErrorMessage.Text = "";
        lblSuccessMessage.Text = "";
        lblProcessed.Visible = false;
        btnConfirm.Visible = false;
        FTPUpdatePanel.Visible = false;
        if (txtPONo.Text.ToString().Trim().Length == 0)
        {
            lblErrorMessage.Text = "A Purchase Order number is required.";
        }
        else
        {
            try
            {
                ds = null;
                ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pPurchImportXml",
                          new SqlParameter("@Action", "Validate"),
                          new SqlParameter("@PONo", txtPONo.Text.ToString().Trim())
                          );
                if ((ds == null) || (ds.Tables[0] == null) || (ds.Tables[0].Rows.Count == 0))
                {
                    lblErrorMessage.Text = "Invalid PO number.";
                    MessageUpdatePanel.Update();
                }
                else
                {
                    if (ds.Tables[0].Rows[0]["ProcessStatus"].ToString().Trim() == "Processed")
                    {
                        lblProcessed.Text = "Processed at " + ds.Tables[0].Rows[0]["EDIDate"].ToString() + ". Please confirm by clicking the OK button.";
                        lblProcessed.Visible = true;
                        btnConfirm.Visible = true;
                    }
                    else
                    {
                        ds = null;
                        ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pPurchImportXml",
                                  new SqlParameter("@Action", "Extract"),
                                  new SqlParameter("@PONo", txtPONo.Text.ToString().Trim())
                                  );
                        if ((ds != null) && (ds.Tables[0] != null) && (ds.Tables[0].Rows.Count > 0))
                        {
                            CreateXMLFile(ds.Tables[1], ds.Tables[0]);
                            Session["PIXmlData"] = ds.Tables[1];
                            lblSuccessMessage.Text = "XML data Created. You may now send it FTP.";
                            FTPUpdatePanel.Visible = true;
                        }
                        else
                        {
                            lblErrorMessage.Text = "No data available.";
                            MessageUpdatePanel.Update();
                        }
                    }
                }
            }
            catch (Exception e3)
            {
                lblErrorMessage.Text = "Submit_Click Error " + e3.ToString();
                MessageUpdatePanel.Update();
            }
        }
    }

    protected void Confirm_Click(object sender, EventArgs e)
    {
        lblErrorMessage.Text = "";
        lblSuccessMessage.Text = "";
        FTPUpdatePanel.Visible = false;
        if (txtPONo.Text.ToString().Trim().Length == 0)
        {
            lblErrorMessage.Text = "A Purchase Order number is required.";
        }
        else
        {
            try
            {
                ds = null;
                ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pPurchImportXml",
                          new SqlParameter("@Action", "Extract"),
                          new SqlParameter("@PONo", txtPONo.Text.ToString().Trim())
                          );
                if ((ds != null) && (ds.Tables[0] != null) && (ds.Tables[0].Rows.Count > 0))
                {
                    CreateXMLFile(ds.Tables[1], ds.Tables[0]);
                    Session["PIXmlData"] = ds.Tables[1];
                    lblSuccessMessage.Text = "XML data Created. You may now send it FTP.";
                    lblProcessed.Visible = false;
                    btnConfirm.Visible = false;
                    FTPUpdatePanel.Visible = true;
                }
                else
                {
                    lblErrorMessage.Text = "No data available.";
                    MessageUpdatePanel.Update();
                }
            }
            catch (Exception e3)
            {
                lblErrorMessage.Text = "Submit_Click Error " + e3.ToString();
                MessageUpdatePanel.Update();
            }
        }
    }

    protected void FTP_Click(object sender, EventArgs e)
    {
        lblErrorMessage.Text = "";
        lblSuccessMessage.Text = "";
        if (txtFTPSite.Text.ToString().Trim().Length == 0)
        {
            lblErrorMessage.Text = "An FTP Site Address required.";
        }
        else
        {
            try
            {
                int POCtr = 0;
                dt = (DataTable)Session["PIXmlData"];
                foreach (DataRow header in (dt.Rows))
                {
                    XmlFileName = @"XML/PFC_Order_" + header["PONum"].ToString().Trim() + ".xml";
                    fullpath = Request.MapPath(XmlFileName);
                    SendFile(txtFTPSite.Text.ToString().Trim(),
                        @"PFC_Order_" + header["PONum"].ToString().Trim() + ".xml",
                        txtFTPUser.Text.ToString().Trim(),
                        txtFTPPassword.Text.ToString().Trim(),
                        fullpath.Trim());
                    POCtr++;
                }
                lblSuccessMessage.Text = POCtr.ToString() + " files have been sent to " + txtFTPSite.Text.ToString().Trim() + ".";
                FTPUpdatePanel.Visible = false;
            }
            catch (Exception e3)
            {
                lblErrorMessage.Text = "FTP_Click Error " + e3.ToString();
            }
        }
        MessageUpdatePanel.Update();
    }

    public void CreateXMLFile(DataTable POs,DataTable edt)
    {
        //
        // Create the the XML output
        //
        /*
        <?xml version="1.0" encoding="utf-8"?>
        <ns0:Orders xmlns:ns0="http://BAPISend.MultipleOrders">
        <Order>
        <ORDER_HEADER_IN>
        <DOC_SOURCE>PFC</DOC_SOURCE>
        <REQ_DATE_H>20100419</REQ_DATE_H>  Date format of YYYYMMDD
        <PURCH_DATE>20100419</PURCH_DATE>  Date format of YYYYMMDD
        <NAME>EDI</NAME>
        <PURCH_NO_C>2896617</PURCH_NO_C>  Your Purchase Order Number (unique per order)
        <BILL_DATE>20100419</BILL_DATE>  Date format of YYYYMMDD
        <CUST_GRP>10</CUST_GRP>
        </ORDER_HEADER_IN>
        <ORDER_ITEMS_IN>
        <PO_ITM_NO>0001</PO_ITM_NO>  Increment by 1 for each item
        <MATERIAL>GBC832J</MATERIAL>  HTI Part Number
        <PLANT>0021</PLANT>  HTI Plant (0010 = Chicago, 0021 = New Jersey, 0040 = Atlanta, 0044 = Dallas, 0050 = Los Angeles)
        <TARGET_QTY>2100</TARGET_QTY>  Quantity in Pieces, not boxes 
        <TARGET_QU>EA</TARGET_QU>
        <ITEM_DESC>1/2-13X2 CARR BLT F/THD GALV</ITEM_DESC>  Description (not critical)
        <ITEM_BUYER_PART>QKH2</ITEM_BUYER_PART>  Your part number (info only)
        <ITEM_VENDOR_PART>GBC832J</ITEM_VENDOR_PART>  HTI Part Number (should match MATERIAL)
        </ORDER_ITEMS_IN>
        <ORDER_PARTNERS>
        <PARTN_ROLE>WE</PARTN_ROLE>
        <PARTN_NUMB>0000005886</PARTN_NUMB>
        <ITM_NUMBER>ST</ITM_NUMBER>
        <ADDRESS1>1234 ANYSTREET</ADDRESS1>  SHIPTO Addr1
        <ADDRESS2></ADDRESS2>  SHIPTO Addr2
        <CITY>ANYTOWN</CITY>  SHIPTO City
        <STATE>IL</STATE>  SHIPTO State
        <ZIP>60016</ZIP>  SHIPTO Zip Code
        <NAME>THAT NAME</NAME>  SHIPTO Identifying Name 
        </ORDER_PARTNERS>
        <ORDER_PARTNERS>
        <PARTN_ROLE>AG</PARTN_ROLE>
        <PARTN_NUMB>0000005886</PARTN_NUMB>
        <ITM_NUMBER>BT</ITM_NUMBER>
        <ADDRESS1>22795 S UTILITY WAY</ADDRESS1>
        <ADDRESS2></ADDRESS2>
        <CITY>CARSON</CITY>
        <STATE>CA</STATE>
        <ZIP>90745</ZIP>
        <NAME>PORTEOUS FASTENER CO</NAME>
        </ORDER_PARTNERS>
        </Order>
        </ns0:Orders>

        */
        // Convert a virtual path to a fully qualified physical path.
        string CurOrder = "";
        XmlWriterSettings settings = new XmlWriterSettings();
        settings.Indent = true;
        int LineCtr = 1;
        int POCtr = 0;
        settings.IndentChars = ("    ");
        //XmlWriter writer = XmlWriter;
        // Write XML data.
        foreach (DataRow header in (POs.Rows))
        {
            XmlFileName = @"XML/PFC_Order_" + header["PONum"].ToString().Trim() + ".xml";
            fullpath = Request.MapPath(XmlFileName);
            using (XmlWriter writer = XmlWriter.Create(fullpath, settings))
            {
                writer.WriteStartElement("ns0", "Orders", "http://BAPISend.MultipleOrders");
                writer.WriteStartElement("Order");
                writer.WriteStartElement("ORDER_HEADER_IN");
                writer.WriteElementString("DOC_SOURCE", "PFC");
                writer.WriteElementString("REQ_DATE_H", string.Format("{0:yyyyMMdd}", DateTime.Now));
                writer.WriteElementString("PURCH_DATE", string.Format("{0:yyyyMMdd}", DateTime.Now));  //Date format of YYYYMMDD
                writer.WriteElementString("NAME", "EDI");
                writer.WriteElementString("PURCH_NO_C", header["PONum"].ToString().Trim());  //Your Purchase Order Number (unique per order)
                writer.WriteElementString("BILL_DATE", string.Format("{0:yyyyMMdd}", DateTime.Now));  //Date format of YYYYMMDD
                writer.WriteElementString("CUST_GRP", "10");
                writer.WriteEndElement();
                LineCtr = 1;
                //edt.Select("PURCH_NO_C = " + header["PONum"].ToString().Trim());
                //foreach (DataRow row in (edt.Rows))
                foreach (DataRow row in edt.Select("PURCH_NO_C = '" + header["PONum"].ToString().Trim() + "'"))
                {
                    writer.WriteStartElement("ORDER_ITEMS_IN");
                    writer.WriteElementString("PO_ITM_NO", string.Format("{0:0000}", LineCtr));
                    writer.WriteElementString("MATERIAL", row["MATERIAL"].ToString().Trim());
                    writer.WriteElementString("PLANT", row["PLANT"].ToString().Trim());
                    writer.WriteElementString("TARGET_QTY", row["TARGET_QTY"].ToString().Trim());
                    writer.WriteElementString("TARGET_QU", row["TARGET_QU"].ToString().Trim());
                    writer.WriteElementString("ITEM_DESC", row["ITEM_DESC"].ToString().Trim());
                    writer.WriteElementString("ITEM_BUYER_PART", row["ITEM_BUYER_PART"].ToString().Trim());
                    writer.WriteElementString("ITEM_VENDOR_PART", row["ITEM_VENDOR_PART"].ToString().Trim());
                    writer.WriteEndElement();
                    LineCtr++;
                }
                row1 = edt.Rows[0];
                writer.WriteStartElement("ORDER_PARTNERS");
                writer.WriteElementString("PARTN_ROLE", "WE");
                writer.WriteElementString("PARTN_NUMB", row1["PARTN_NUMB"].ToString().Trim());
                writer.WriteElementString("STITM_NUMBER", row1["STITM_NUMBER"].ToString().Trim());
                writer.WriteElementString("ADDRESS1", row1["STADDRESS1"].ToString().Trim());
                writer.WriteElementString("ADDRESS2", row1["STADDRESS2"].ToString().Trim());
                writer.WriteElementString("CITY", row1["STCITY"].ToString().Trim());
                writer.WriteElementString("STATE", row1["STSTATE"].ToString().Trim());
                writer.WriteElementString("NAME", row1["STNAME"].ToString().Trim());
                writer.WriteEndElement();
                writer.WriteStartElement("ORDER_PARTNERS");
                writer.WriteElementString("PARTN_ROLE", "AG");
                writer.WriteElementString("PARTN_NUMB", row1["PARTN_NUMB"].ToString().Trim());
                writer.WriteElementString("STITM_NUMBER", row1["BTITM_NUMBER"].ToString().Trim());
                writer.WriteElementString("ADDRESS1", row1["BTADDRESS1"].ToString().Trim());
                writer.WriteElementString("ADDRESS2", row1["BTADDRESS2"].ToString().Trim());
                writer.WriteElementString("CITY", row1["BTCITY"].ToString().Trim());
                writer.WriteElementString("STATE", row1["BTSTATE"].ToString().Trim());
                writer.WriteElementString("NAME", row1["BTNAME"].ToString().Trim());
                writer.WriteEndElement();
                writer.WriteEndElement();
                writer.WriteEndElement();
                writer.Flush();
            }
            HyperLink SubPO = new HyperLink();
            SubPO.NavigateUrl = XmlFileName;
            SubPO.Text = header["PONum"].ToString().Trim();
            SubPO.Target = "_blank";
            PlaceHolder1.Controls.Add(SubPO);
            // Add a spacer in the form of an HTML <BR> element.
            PlaceHolder1.Controls.Add(new LiteralControl("&nbsp;&nbsp;"));
            POCtr++;
            if (POCtr % 10 == 0)
            {
                PlaceHolder1.Controls.Add(new LiteralControl("<br>"));
            }
        }
        hidXMLFilePath.Value = fullpath;
        hidXMLName.Value = @"PFC_Order_" + txtPONo.Text.ToString().Trim() + ".xml";


    }
    public class FtpState
    {
        private ManualResetEvent wait;
        private FtpWebRequest request;
        private string fileName;
        private Exception operationException = null;
        string status;

        public FtpState()
        {
            wait = new ManualResetEvent(false);
        }

        public ManualResetEvent OperationComplete
        {
            get { return wait; }
        }

        public FtpWebRequest Request
        {
            get { return request; }
            set { request = value; }
        }

        public string FileName
        {
            get { return fileName; }
            set { fileName = value; }
        }
        public Exception OperationException
        {
            get { return operationException; }
            set { operationException = value; }
        }
        public string StatusDescription
        {
            get { return status; }
            set { status = value; }
        }
    }

    public static void SendFile(string FTPSite, string fileName, string user, string pass, string fullPath)
        {
            // Create a Uri instance with the specified URI string.
            // If the URI is not correctly formed, the Uri constructor
            // will throw an exception.
            ManualResetEvent waitObject;

            Uri target = new Uri(FTPSite);
            FtpState state = new FtpState();
            //FtpWebRequest request = (FtpWebRequest)WebRequest.Create(target);
            FtpWebRequest request = (FtpWebRequest)WebRequest.Create(target + @"/" + fileName);
            //FtpWebRequest request = (FtpWebRequest)WebRequest.Create(@"ftp://10.1.36.34/");
            request.Method = WebRequestMethods.Ftp.UploadFile;

            // This example uses anonymous logon.
            // The request is anonymous by default; the credential does not have to be specified. 
            // The example specifies the credential only to
            // control how actions are logged on the server.
            request.Proxy = null;

            request.Credentials = new NetworkCredential(user, pass);

            // Store the request in the object that we pass into the
            // asynchronous operations.
            state.Request = request;

            // Set a time limit for the operation to complete.
            request.Timeout = 600000;
            //state.FileName = @"C:\Software\PFCApps\IntranetSite\PurchaseImport\XML\PFC_Order_11050303_toms.xml"; ;
            state.FileName = fullPath;

            // Get the event to wait on.
            waitObject = state.OperationComplete;

            // Asynchronously get the stream for the file contents.
            request.BeginGetRequestStream(
                new AsyncCallback(EndGetStreamCallback),
                state
            );

            // Block the current thread until all operations are complete.
            waitObject.WaitOne();

            // The operations either completed or threw an exception.
            if (state.OperationException != null)
            {
                throw state.OperationException;
            }
            else
            {
                //lblSuccessMessage.Text = "XML sent to " + FTPSite;
                //MessageUpdatePanel.Update();
            }
        }
        private static void EndGetStreamCallback(IAsyncResult ar)
        {
            FtpState state = (FtpState)ar.AsyncState;

            Stream requestStream = null;
            // End the asynchronous call to get the request stream.
            try
            {
                requestStream = state.Request.EndGetRequestStream(ar);
                // Copy the file contents to the request stream.
                const int bufferLength = 2048;
                byte[] buffer = new byte[bufferLength];
                int count = 0;
                int readBytes = 0;
                FileStream stream = File.OpenRead(state.FileName);
                do
                {
                    readBytes = stream.Read(buffer, 0, bufferLength);
                    requestStream.Write(buffer, 0, readBytes);
                    count += readBytes;
                }
                while (readBytes != 0);
                // IMPORTANT: Close the request stream before sending the request.
                requestStream.Close();
                // Asynchronously get the response to the upload request.
                state.Request.BeginGetResponse(
                    new AsyncCallback(EndGetResponseCallback),
                    state
                );
                if (stream != null)
                    stream.Close();
            }
            // Return exceptions to the main application thread.
            catch (Exception e)
            {
                state.OperationException = e;
                state.OperationComplete.Set();
                return;
            }

        }

        // The EndGetResponseCallback method  
        // completes a call to BeginGetResponse.
        private static void EndGetResponseCallback(IAsyncResult ar)
        {
            FtpState state = (FtpState)ar.AsyncState;
            FtpWebResponse response = null;
            try
            {
                response = (FtpWebResponse)state.Request.EndGetResponse(ar);
                response.Close();
                state.StatusDescription = response.StatusDescription;
                // Signal the main application thread that 
                // the operation is complete.
                state.OperationComplete.Set();
            }
            // Return exceptions to the main application thread.
            catch (Exception e)
            {
                state.OperationException = e;
                state.OperationComplete.Set();
            }
        }

}
