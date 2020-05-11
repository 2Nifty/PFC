using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.SOE.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using System.Drawing;
using PFC.Intranet.Securitylayer;
using System.Net;
using System.IO;
using System.Text;

public partial class _Default : System.Web.UI.Page
{
    private DataTable dtPrinterServer = new DataTable();
    private DataTable dtPrinterName = new DataTable();
    private string customerName;
    private string SoeNo;
    private string Mode;

    PrintUtilityDialogue utilityDialogue = new PrintUtilityDialogue();
    private string _customerNumber = string.Empty;
    private string _printURL = string.Empty;
    private string MSGSUCESS = "Request has been sucessfully posted";

   
    protected void Page_Load(object sender, EventArgs e)
    {
        scmPrintUtility.AsyncPostBackTimeout = 36000;  //600 minutes

        string PrintURL = Server.UrlDecode(Request.QueryString["pageURL"].ToString().Replace("`", "'"));
        //url = url.Remove(url.Length - 1, 1);
        _printURL = ConfigurationManager.AppSettings["IntranetSiteURL"].ToString() + PrintURL;
        btnPrinter.Attributes.Add("onclick", "javascript:PrintPopUP('" + Server.UrlEncode(Request.QueryString["pageURL"].ToString()) + "');");
        // added by Slater 11/19/2009
        string PreviewURL = ConfigurationManager.AppSettings["IntranetSiteURL"].ToString() +
           Server.UrlDecode(Request.QueryString["pageURL"].ToString().Replace("`", "'"));
        // added by Slater 5/6/2010
        PreviewURL += "&ScriptX=YES";
        btnPrintPreviewDoc.Attributes.Add("onclick", "javascript:OpenPreview('" + PreviewURL + "');");
        btnEMailPreviewDoc.Attributes.Add("onclick", "javascript:OpenPreview('" + PreviewURL + "');");
        btnFAXPreviewDoc.Attributes.Add("onclick", "javascript:OpenPreview('" + PreviewURL + "');");
        if (!Page.IsPostBack)
        {
            Mode = Request.QueryString["Mode"];
            BindName();
            lblCust.Text = customerName; 

            if(SoeNo != "")
                lblSubject.Text =  SoeNo;
            txtSubject.Text = lblSubject.Text;
            HidPageSetup.Value = (Request.QueryString["PageSetup"] != null && Request.QueryString["PageSetup"].Trim() != "") ? Request.QueryString["PageSetup"].ToString().ToUpper() : "P";
            if (Mode == "Print" )
            { 
                if (HidPageSetup.Value == "L")
                {
                    btnPrint_Click(null, null);
                    rdoPortrait.Checked = false;
                    rdoLandscape.Checked = true;
                    rdoLandscape_CheckedChanged(null, null);
                }
                else
                    btnPrint_Click(null, null); 

            }
            if (Mode == "Email")
            {
                btnEmail_Click(null, null);

            }
            if (Mode == "Fax")
            {
                btnFax_Click(null, null);
            }

            BindDropServer();
            BindDropPrinter();
        }       
        
        divBanner.Visible = false;
        divBannerEmail.Visible = false;
        divBannerPrint.Visible = false;
        pnlButtons.Update();

    }

    private void BindName()
    {
        _customerNumber = Request.QueryString["CustomerNumber"];
        customerName = utilityDialogue.GetCustomerName(_customerNumber);
        SoeNo = Request.QueryString["SoeNo"];

    }

    private void BindDropServer()
    {
        dtPrinterServer = utilityDialogue.GetPrinterServer();
        ddlPrinterServer.DataSource = dtPrinterServer;
        ddlPrinterServer.DataTextField = "Printserver";
        ddlPrinterServer.DataValueField = "Printserver";
        ddlPrinterServer.DataBind();
    }

    private void BindDropPrinter()
    {
        string whereCondition = ddlPrinterServer.SelectedItem.Value.ToString();
        dtPrinterName = utilityDialogue.GetPrinterName(whereCondition);
        ddlPrinterName.DataSource = dtPrinterName;

        ddlPrinterName.DataTextField = "PrinterPath";
        ddlPrinterName.DataValueField = "PrinterNetworkAddress";
        ddlPrinterName.DataBind();


    }

    protected void rdoText_CheckedChanged(object sender, EventArgs e)
    {
        if (rdoText.Checked == true)
        {
            txtPrint.Enabled = true;
            txtPrint.Text = hidPrinter.Value;
            ddlPrinterServer.Enabled = false;
            ddlPrinterName.Enabled = false;
           
        }
    }

    protected void ddlPrinterServer_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindDropPrinter();
    }

    protected void rdoPrint_CheckedChanged(object sender, EventArgs e)
    {
        if (rdoPrint.Checked == true)
        {
            //txtPrint.Text = "";
            txtPrint.Enabled = false;
            ddlPrinterServer.Enabled = true;
            ddlPrinterName.Enabled = true;
            BindDropServer();
            BindDropPrinter();
        }
    }

    protected void btnPostPrint_Click1(object sender, ImageClickEventArgs e)
    {
        string url = Server.UrlDecode(Request.QueryString["pageURL"].ToString().Replace("`","'"));
        string _formName = (Request.QueryString["FormName"] == null ? "" : Request.QueryString["FormName"].ToString());

        _printURL = ConfigurationManager.AppSettings["IntranetSiteURL"].ToString() + url + "&ScriptX=YES";
        
        string UserName = ( Session["UserName"] != null ? Session["UserName"].ToString() : "SOE");

        char strPageSetup = Convert.ToChar(HidPageSetup.Value);
        if (rdoText.Checked == true)
        {
            string PrintValues = txtPrint.Text;
            
            string columnName = "PrinterNetworkAddress,PageSetup,createdBy,createdDate,Status,QueueType,PageURL,FormName";
            string columnvalues = "'" + PrintValues + "' ," +
                                "'" + strPageSetup + "' ," +
                                "'" + UserName + "'," +
                                "'" + DateTime.Now.ToLocalTime() + "'," +
                                "'0'," +
                                "'Print'," +
                                "'" + _printURL.Replace("'", "''") + "'," + 
                                "'" + _formName + "'" ;
            utilityDialogue.GetData(columnName, columnvalues);
            divBannerPrint.Visible = true;
            lblmsgPrint.Text = "Sucessfully Posted";
            ClearControls("Print");
            pnlButtons.Update();
            //MessageBox("Sucessfully Posted");

           

        }
        else if (rdoPrint.Checked == true)
        {

            string columnName = "PrinterNetworkAddress,PageSetup,createdBy,createdDate,Status,QueueType,PageURL,FormName";
            string columnvalues = "'" + ddlPrinterName.SelectedValue.ToString() + "'," +
                                "'" + strPageSetup + "' ," +
                                 "'" + UserName + "'," +
                                "'" + DateTime.Now.ToLocalTime() + "'," +
                                "'0'," +
                                 "'Print'," +
                                "'" + _printURL.Replace("`", "'").Replace("'", "''") + "'," +
                                "'" + _formName + "'" ;
            utilityDialogue.GetData(columnName, columnvalues);
            divBannerPrint.Visible = true;
            lblmsgPrint.Text = "Sucessfully Posted";
            ClearControls("Print");
            pnlButtons.Update();
        }
       txtPrint.Text = hidPrinter.Value;
    }

    protected void btnPostEmail_Click(object sender, ImageClickEventArgs e)
    {
        string url = Server.UrlDecode(Request.QueryString["pageURL"].ToString());
        _printURL = ConfigurationManager.AppSettings["IntranetSiteURL"].ToString() + url + "&ScriptX=NO";
        string UserName = (Session["UserName"] != null ? Session["UserName"].ToString() : "SOE");

        string columnName = "createdBy,createdDate,Status,QueueType,PageURL,Sentto,subject,body";
        string columnvalues = "'" + UserName + "'," +
                                "'" + DateTime.Now.ToLocalTime() + "'," +
                                "'0'," +
                                "'Email'," +
                                "'" + _printURL.Replace("`", "'").Replace("'", "''") + "'," +
                                "'" + txtEmailTo.Text + "'," +
                                "'" + txtSubject.Text + "'," +
                                "'" + txtComments.Text + "'";
        utilityDialogue.GetData(columnName, columnvalues);
        divBannerEmail.Visible = true;
        lblmsgEmail.Text = MSGSUCESS;
        ClearControls("Email");
        pnlButtons.Update();
    }

    #region Fax

    protected void btnPostFax_Click(object sender, ImageClickEventArgs e)
    {
        if (txtCustomerFaxNo.Text.Trim() != "")
        {
            string url = Server.UrlDecode(Request.QueryString["pageURL"].ToString());

            _printURL = ConfigurationManager.AppSettings["SOESiteURL"].ToString() + url + "&ScriptX=NO";
            string UserName = (Session["UserName"] != null ? Session["UserName"].ToString() : "SOE");


            if (SendFax(_printURL, txtCustomerFaxNo.Text, UserName))
            {
                divBanner.Visible = true;
                lblmsg.Text = "Fax sent successfully.";
                ClearControls("Fax");
                pnlButtons.Update();
            }
            else
            {
                lblmsg.ForeColor = Color.Red;
                lblmsg.Text = "Server not able to process this Request.";
                divBanner.Visible = true;
                pnlButtons.Update();
            }
        }
        else
        {
            lblmsg.ForeColor = Color.Red;
            lblmsg.Text = "Invaild Fax Number.";
            divBanner.Visible = true;
            pnlButtons.Update();
        }
    }

    public bool IsConverLetterSent = false;

    public bool SendFax(string url, string faxNo, string createdBy)
    {
        try
        {
            using (new Impersonator("MISADMIN", "pfca.com", "PFC2@@6it"))
            {
                // Variable declarations
                RFCOMAPILib.FaxServerClass faxserver = new RFCOMAPILib.FaxServerClass();
                faxserver.ServerName = "PFCFax1";
                faxserver.Protocol = RFCOMAPILib.CommunicationProtocolType.cpNamedPipes;
                faxserver.UseNTAuthentication = RFCOMAPILib.BoolType.True; faxserver.OpenServer();
                RFCOMAPILib.Fax fax = (RFCOMAPILib.Fax)faxserver.get_CreateObject(RFCOMAPILib.CreateObjectType.coFax);
                //string faxNO = txtCustomerFaxNo.Text.Replace("-", "").Replace("(", "").Replace(")", "").Replace(" ", "");
                //string faxNO = txtCustomerFaxNo.Text;                

                #region Create Right Fax Content

                //int totInvoiceCount = (selectedInvoiceNo.Contains(",") == true ? selectedInvoiceNo.Split(',').Length : 1);
                //_printURL = ConfigurationManager.AppSettings["SOESiteURL"].ToString() + Server.UrlDecode(Request.QueryString["pageURL"].ToString()) + "&ScriptX=NO";
                
                #region Do web request & create HTML doc (used as an attachement in rightfax com object)

                // Create a request using a URL that can receive a post. 
                HttpWebRequest webRequest = (HttpWebRequest)System.Net.WebRequest.Create(url);
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
                objSR = new StreamReader(objStream);
                htm = objSR.ReadToEnd();
                objSR.Close();

                string AppPath = Server.MapPath("");
                string filename = "RequestEmail_" + Session["SessionID"] + ".html";
                AppPath = AppPath + @"\" + filename;

                #endregion

                StreamWriter sw = new System.IO.StreamWriter(AppPath, true, Encoding.GetEncoding("windows-1252"));
                {
                    sw.Write(htm);
                    sw.Flush();
                    sw.Close();

                    fax.Attachments.Add(AppPath, RFCOMAPILib.BoolType.True);
                }

                #endregion

                fax.Send();

                InsertFaxRequest(txtCustomerFaxNo.Text, "S", "");
            }

            return true;
        }
        catch (Exception ex)
        {
            InsertFaxRequest(txtCustomerFaxNo.Text, "F", ex.Message);
            return false;
        }
    }

    private void InsertFaxRequest(string faxNo, string processCd, string errorMessage)
    {
        string UserName = (Session["UserName"] != null ? Session["UserName"].ToString() : "SOE");
        string columnName = "createdBy,createdDate,Status,QueueType,PageURL,Sentto,subject,body,ProcessCd,ErrorLog";
        string columnvalues = "'" + UserName + "'," +
                                "'" + DateTime.Now.ToLocalTime() + "'," +
                                "'1'," +
                                "'Fax'," +
                                "'" + _printURL.Replace("`", "'").Replace("'", "''") + "'," +
                                "'" + faxNo + "'," +
                                "''," +
                                "''," +
                                "'" + processCd + "'," +
                                "'" + errorMessage.Replace("'", "''") + "'";
        utilityDialogue.GetData(columnName, columnvalues);
    }

    #endregion
    protected void btnEmail_Click(object sender, ImageClickEventArgs e)
    {
        string Model = "Email";
        pnlEmail.Visible = true;
        pnlFax.Visible = false;
        pnlPint.Visible = false;
        btnFax.ImageUrl = "Common/Images/fax_n.gif";
        btnEmail.ImageUrl = "Common/Images/email_o.gif";
        btnPrint.ImageUrl = "Common/Images/print_n.gif";
        if (Request.QueryString["CustomerNumber"] != "")
         lnkEmail.Attributes.Add("onclick", "Javascript:OpenPopup('" + Model + "','" + Request.QueryString["CustomerNumber"] + "');"); 
        else
            lnkEmail.Font.Underline= false;
    }

    protected void btnPrint_Click(object sender, ImageClickEventArgs e)
    {
        string UserName = (Session["UserName"] != null ? Session["UserName"].ToString() : "SOE");
        hidPrinter.Value = txtPrint.Text = utilityDialogue.GetDefaultPrinter(UserName.ToString());
        tblDefaultPrinter.Visible = false;
        tblPrinterPref.Visible = true;
        pnlPint.Visible = true;
        pnlFax.Visible = false;
        pnlEmail.Visible = false;
        btnFax.ImageUrl = "Common/Images/fax_n.gif";
        btnEmail.ImageUrl = "Common/Images/email_n.gif";
        btnPrint.ImageUrl = "Common/Images/print_o.gif";
        pnlPint.Update();
    }

    protected void btnFax_Click(object sender, ImageClickEventArgs e)
    {
        string Model = "Fax";
        pnlFax.Visible = true;
        pnlPint.Visible = false;
        pnlEmail.Visible = false;
        btnFax.ImageUrl = "Common/Images/fax_o.gif";
        btnEmail.ImageUrl = "Common/Images/email_n.gif";
        btnPrint.ImageUrl = "Common/Images/print_n.gif";
        if (Request.QueryString["CustomerNumber"] != "")
            lnkFax.Attributes.Add("onclick", "Javascript:OpenPopup('" + Model + "','" + Request.QueryString["CustomerNumber"] + "');");
        else
            lnkFax.Font.Underline = false;
      
    }

    private void ClearControls(string Param)
    {
        if (Param == "Print")
        {
            txtPrint.Enabled = true;
            txtPrint.Text = "";
            ddlPrinterServer.Enabled = false;
            ddlPrinterName.Enabled = false;
            rdoText.Checked = true;
            rdoPrint.Checked = false;
        }

        if (Param == "Email")
        {
            txtEmailTo.Text = "";
            txtSubject.Text = lblSubject.Text;
            txtComments.Text = "";
            txtEmailTo.Focus();
        }

        if (Param == "Fax")
        {
            txtCustomerFaxNo.Text = "";
            txtCustomerFaxNo.Focus();
        }

    }

    protected void rdoLandscape_CheckedChanged(object sender, EventArgs e)
    {
        HidPageSetup.Value = "L";
        tblPrint.Visible = true;
        trDefault.Visible = false;
        tblPrinter.Visible = false;
        btnDefaultPrinter.Visible = false;
        btnPostPrint.Visible = false;
        // added by Slater 11/19/2009
        btnPrintPreviewDoc.Visible = false;
    }

    protected void rdoPortrait_CheckedChanged(object sender, EventArgs e)
    {
        HidPageSetup.Value = "P";
        tblPrint.Visible = false;
        trDefault.Visible = true;
        tblPrinter.Visible = true;
        btnPostPrint.Visible = true;
        btnDefaultPrinter.Visible = true;
        // added by Slater 11/19/2009
        btnPrintPreviewDoc.Visible = true;
    }

    protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
    {
        string UserName = (Session["UserName"] != null ? Session["UserName"].ToString() : "SOE");
        string defaultPrinter = "\\\\"+ddlDefaultPrintServer.SelectedItem.Value.ToString() + "\\" + ddldefaultPrinter.SelectedItem.Text.ToString();
        string text = utilityDialogue.GetDefaultPrinter(UserName.ToString()) ; 
        bool cond=(text!="")?true :false;

        if (cond)
        {
            string columnName = "DefaultPrinter='"+defaultPrinter +"'";
            string whereClause = " UserName='" + UserName + "'";
            utilityDialogue.UpdateDefaultPrinter(columnName, whereClause);
            
        }
        else
        {

            string columnValues = "'" + UserName + "'," +
                                 "'" + defaultPrinter + "'";
            utilityDialogue.InsertDefaultPrinter(columnValues);
        }
        tblDefaultPrinter.Visible = false;
        ddlDefaultPrintServer.Enabled = false;
        ddldefaultPrinter.Enabled = false;
        tblPrinterPref.Visible = true;
        btnPrint_Click(null, null);
        
    }

    protected void btnDefaultPrinter_Click(object sender, EventArgs e)
    {
       
        tblPrinterPref.Visible = false;
        tblDefaultPrinter.Visible = true;
        ddlDefaultPrintServer.Enabled = true;
        ddldefaultPrinter.Enabled = true;

        BindDropDefaultServer();
        BindDropDefaultPrinter();
    }

    private void BindDropDefaultServer()
    {

        dtPrinterServer = utilityDialogue.GetPrinterServer();
        ddlDefaultPrintServer.DataSource = dtPrinterServer;
        ddlDefaultPrintServer.DataTextField = "Printserver";
        ddlDefaultPrintServer.DataValueField = "Printserver";
        ddlDefaultPrintServer.DataBind();


    }

    private void BindDropDefaultPrinter()
    {
        string whereCondition = ddlDefaultPrintServer.SelectedItem.Value.ToString();
        dtPrinterName = utilityDialogue.GetPrinterName(whereCondition);
        ddldefaultPrinter.DataSource = dtPrinterName;

        ddldefaultPrinter.DataTextField = "PrinterPath";
        ddldefaultPrinter.DataValueField = "PrinterNetworkAddress";
        ddldefaultPrinter.DataBind();


    }
   
    protected void ddlDefaultPrintServer_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindDropDefaultPrinter();
    }

    protected void btnCancel_Click(object sender, ImageClickEventArgs e)
    {
        tblPrinterPref.Visible = true;
        tblDefaultPrinter.Visible = false;
    }
   
}
