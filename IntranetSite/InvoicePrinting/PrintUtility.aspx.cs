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
using PFC.Intranet.Securitylayer;

using System.IO;
using System.Net;
using System.Text;
using System.Drawing;
using System.Runtime.InteropServices;
using RFCOMAPILib;

public partial class _Default : System.Web.UI.Page
{
    private DataTable dtPrinterServer = new DataTable();
    private DataTable dtPrinterName = new DataTable();
    private string customerName;
    private string SoeNo;
    private string Mode;
    private int MaxAttachmentAllowed = 0;

    DataUtility dataUtility = new DataUtility();
    PrintUtilityDialogue utilityDialogue = new PrintUtilityDialogue();
    private string _customerNumber = string.Empty;
    private string _printURL = string.Empty;
    private string _formName = string.Empty;
    private string MSGSUCESS = "Request has been sucessfully posted";
    string selectedInvoiceNo = "";
    int selectedInvoiceCount = 0;
    string faxAdminName = ConfigurationManager.AppSettings["FAXAdminName"].ToString();
    string faxAdminKey = ConfigurationManager.AppSettings["FAXAdminKey"].ToString();
    string pfcDomain = ConfigurationManager.AppSettings["PFCDomain"].ToString();
    string pfcServer = ConfigurationManager.AppSettings["FAXServerName"].ToString();

    protected void Page_Load(object sender, EventArgs e)
    {
        scmPrintUtility.AsyncPostBackTimeout = 36000;  //600 minutes

        string PrintURL = Server.UrlDecode(Request.QueryString["pageURL"].ToString().Replace("`", "'"));
        _formName = Request.QueryString["FormName"].ToString();
        
        selectedInvoiceNo = Session["PrintInvoiceNo"].ToString();
        if (selectedInvoiceNo != "")
        {
            selectedInvoiceNo = selectedInvoiceNo.Remove(0, 1);
            selectedInvoiceCount = (selectedInvoiceNo.Contains(",") == true ? selectedInvoiceNo.Split(',').Length : 1);
        }

        _printURL = ConfigurationManager.AppSettings["SOESiteURL"].ToString() + PrintURL;
        btnPrinter.Attributes.Add("onclick", "javascript:PrintPopUP('" + Server.UrlEncode(Request.QueryString["pageURL"].ToString()) + "');");
        string PreviewURL = ConfigurationManager.AppSettings["IntranetSiteURL"].ToString() +
           Server.UrlDecode(Request.QueryString["pageURL"].ToString().Replace("`", "'"));
        
        PreviewURL += "&ScriptX=YES";
        btnPrintPreviewDoc.Attributes.Add("onclick", "javascript:OpenPreview('" + PreviewURL + "');");
        btnEMailPreviewDoc.Attributes.Add("onclick", "javascript:OpenPreview('" + PreviewURL + "');");
        btnFAXPreviewDoc.Attributes.Add("onclick", "javascript:OpenPreview('" + PreviewURL + "');");

        if (!chkIncludeCover.Checked)        
            tblCoverLetter.Attributes.Add("style", "display:none;");        
        else
            tblCoverLetter.Attributes.Add("style", "display:block;");

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

            BindDropLocation();
            BindDropPrinter();
        }       
        
        divBanner.Visible = false;
        divBannerEmail.Visible = false;
        divBannerPrint.Visible = false;
        pnlButtons.Update();

    }

    protected void btnPostEmail_Click(object sender, ImageClickEventArgs e)
    {
        if (DoRequestValidation())
        {
            string url = Server.UrlDecode(Request.QueryString["pageURL"].ToString());
            _printURL = ConfigurationManager.AppSettings["SOESiteURL"].ToString() + url + "&ScriptX=NO";
            string UserName = (Session["UserName"] != null ? Session["UserName"].ToString() : "SOE");

            string columnName = "createdBy,createdDate,Status,QueueType,PageURL,Sentto,subject,body,FormName,MultiDocPrinting,DocNo";
            string columnvalues = "'" + UserName + "'," +
                                    "'" + DateTime.Now.ToLocalTime() + "'," +
                                    "'0'," +
                                    "'Email'," +
                                    "'" + _printURL.Replace("`", "'").Replace("'", "''") + "'," +
                                    "'" + txtEmailTo.Text + "'," +
                                    "'" + txtSubject.Text + "'," +
                                    "'" + txtComments.Text + "'," +
                                    "'" + _formName + "'," +
                                    "'True'," +
                                    "'" + selectedInvoiceNo + "'";
            utilityDialogue.GetData(columnName, columnvalues);
            divBannerEmail.Visible = true;
            lblmsgEmail.Text = MSGSUCESS;
            ClearControls("Email");
            pnlButtons.Update();
        }
    }

    protected void btnPostPrint_Click1(object sender, ImageClickEventArgs e)
    {
        if (DoRequestValidation())
        {
            string url = Server.UrlDecode(Request.QueryString["pageURL"].ToString().Replace("`", "'"));

            _printURL = ConfigurationManager.AppSettings["SOESiteURL"].ToString() + url + "&ScriptX=YES";

            string UserName = (Session["UserName"] != null ? Session["UserName"].ToString() : "SOE");

            char strPageSetup = Convert.ToChar(HidPageSetup.Value);
            if (rdoText.Checked == true)
            {
                string PrintValues = txtPrint.Text;

                string columnName = "PrinterNetworkAddress,PageSetup,createdBy,createdDate,Status,QueueType,PageURL,FormName,MultiDocPrinting,DocNo";
                string columnvalues = "'" + PrintValues + "' ," +
                                    "'" + strPageSetup + "' ," +
                                    "'" + UserName + "'," +
                                    "'" + DateTime.Now.ToLocalTime() + "'," +
                                    "'0'," +
                                    "'Print'," +
                                    "'" + _printURL.Replace("'", "''") + "'," +
                                    "'" + _formName + "'," +
                                    "'True'," +
                                    "'" + selectedInvoiceNo + "'";
                utilityDialogue.GetData(columnName, columnvalues);
                divBannerPrint.Visible = true;
                lblmsgPrint.Text = "Sucessfully Posted";
                ClearControls("Print");
                pnlButtons.Update();
            }
            else if (rdoPrint.Checked == true)
            {

                string columnName = "PrinterNetworkAddress,PageSetup,createdBy,createdDate,Status,QueueType,PageURL,FormName,MultiDocPrinting,DocNo";
                string columnvalues = "'" + ddlPrinterName.SelectedValue.ToString() + "'," +
                                    "'" + strPageSetup + "' ," +
                                     "'" + UserName + "'," +
                                    "'" + DateTime.Now.ToLocalTime() + "'," +
                                    "'0'," +
                                     "'Print'," +
                                    "'" + _printURL.Replace("`", "'").Replace("'", "''") + "'," +
                                    "'" + _formName + "'," +
                                    "'True'," +
                                    "'" + selectedInvoiceNo + "'";
                utilityDialogue.GetData(columnName, columnvalues);
                divBannerPrint.Visible = true;
                lblmsgPrint.Text = "Sucessfully Posted";
                ClearControls("Print");
                pnlButtons.Update();
            }
            txtPrint.Text = hidPrinter.Value;
        }
    }

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

    protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
    {
        string UserName = (Session["UserName"] != null ? Session["UserName"].ToString() : "SOE");
        string defaultPrinter = ddldefaultPrinter.SelectedItem.Value.ToString();
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
        ddlDefaultLocation.Enabled = false;
        ddldefaultPrinter.Enabled = false;
        tblPrinterPref.Visible = true;
        btnPrint_Click(null, null);
        
    }

    protected void btnDefaultPrinter_Click(object sender, EventArgs e)
    {
       
        tblPrinterPref.Visible = false;
        tblDefaultPrinter.Visible = true;
        ddlDefaultLocation.Enabled = true;
        ddldefaultPrinter.Enabled = true;

        BindDropDefaultServer();
        BindDropDefaultPrinter();
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

    #region Utility Method
    private void BindName()
    {
        _customerNumber = Request.QueryString["CustomerNumber"];
        customerName = utilityDialogue.GetCustomerName(_customerNumber);
        SoeNo = Request.QueryString["SoeNo"];

    }

    private void BindDropLocation()
    {
        DataTable dtLocation = utilityDialogue.GetLocations();
        ddlLocation.DataSource = dtLocation;
        ddlLocation.DataTextField = "Name";
        ddlLocation.DataValueField = "LocId";
        ddlLocation.DataBind();

        ListItem item = new ListItem("ALL", "");
        ddlLocation.Items.Insert(0, item);

        if (Session["BranchID"] != null)
        {
            try
            {
                ddlLocation.ClearSelection();
                ddlLocation.SelectedValue = Session["BranchID"].ToString();
            }
            catch (Exception ex)
            {
            }
        }
    }

    private void BindDropPrinter()
    {
        string whereCondition = ddlLocation.SelectedItem.Value.ToString();
        dtPrinterName = utilityDialogue.GetPrinterName(whereCondition);
        ddlPrinterName.DataSource = dtPrinterName;

        ddlPrinterName.DataTextField = "PrinterPath";
        ddlPrinterName.DataValueField = "PrinterNetworkAddress";
        ddlPrinterName.DataBind();


    }

    private void BindDropDefaultServer()
    {

        DataTable dtLocation = utilityDialogue.GetLocations();
        ddlDefaultLocation.DataSource = dtLocation;
        ddlDefaultLocation.DataTextField = "Name";
        ddlDefaultLocation.DataValueField = "LocId";
        ddlDefaultLocation.DataBind();

        ListItem item = new ListItem("ALL", "");
        ddlDefaultLocation.Items.Insert(0, item);

        if (Session["BranchID"] != null)
        {
            try
            {
                ddlDefaultLocation.ClearSelection();
                ddlDefaultLocation.SelectedValue = Session["BranchID"].ToString();
            }
            catch (Exception ex)
            {
            }
        }


    }

    private void BindDropDefaultPrinter()
    {
        string whereCondition = ddlDefaultLocation.SelectedItem.Value.ToString();
        dtPrinterName = utilityDialogue.GetPrinterName(whereCondition);
        ddldefaultPrinter.DataSource = dtPrinterName;

        ddldefaultPrinter.DataTextField = "PrinterPath";
        ddldefaultPrinter.DataValueField = "PrinterNetworkAddress";
        ddldefaultPrinter.DataBind();


    }

    private void ClearControls(string Param)
    {
        if (Param == "Print")
        {
            txtPrint.Enabled = true;
            txtPrint.Text = "";
            ddlLocation.Enabled = false;
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
            txtFaxFromName.Text = "";
            txtFaxFromFaxNo.Text = "";
            txtFaxFromPhoneNo.Text = "";
            txtFaxFromNotes.Text = "";
            txtCustomerFaxNo.Focus();
        }

    }

    protected void rdoText_CheckedChanged(object sender, EventArgs e)
    {
        if (rdoText.Checked == true)
        {
            txtPrint.Enabled = true;
            txtPrint.Text = hidPrinter.Value;
            ddlLocation.Enabled = false;
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
            ddlLocation.Enabled = true;
            ddlPrinterName.Enabled = true;
            BindDropLocation();
            BindDropPrinter();
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

    private bool DoRequestValidation()
    {
        MaxAttachmentAllowed = GetMaxEmailAttachmentCount();
        if (selectedInvoiceCount > MaxAttachmentAllowed)
        {
            string errorMessage = "Only " + MaxAttachmentAllowed + " invoices allowed per request. Please select less than "+ MaxAttachmentAllowed + " invoices.";
            ScriptManager.RegisterClientScriptBlock(btnCancel, btnCancel.GetType(), "allowedDoc", "alert('" + errorMessage + "');", true);
            return false;
        }

        return true;
    }

    #endregion

    #region Fax Methods

    public bool IsConverLetterSent = false;

    protected void btnPostFax_Click(object sender, ImageClickEventArgs e)
    {
        if (txtCustomerFaxNo.Text.Trim() != "")
        {
            if (DoRequestValidation())
            {           
                bool result = true;
                
                if (!SendFax())
                {
                    result = false;                    
                }

                if (result)
                {
                    divBanner.Visible = true;
                    lblmsg.ForeColor = Color.Green;
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
        }
        else
        {
            lblmsg.ForeColor = Color.Red;
            lblmsg.Text = "Invaild Fax Number.";
            divBanner.Visible = true;
            pnlButtons.Update();
        }
    }

    public bool SendFax()
    {
        try
        {
            using (new Impersonator(faxAdminName, pfcDomain, faxAdminKey))                        
            {
                // Variable declarations
                RFCOMAPILib.FaxServerClass faxserver = new RFCOMAPILib.FaxServerClass();
                faxserver.ServerName = pfcServer;
                faxserver.Protocol = RFCOMAPILib.CommunicationProtocolType.cpNamedPipes;
                faxserver.UseNTAuthentication = RFCOMAPILib.BoolType.True; faxserver.OpenServer();
                RFCOMAPILib.Fax fax = (RFCOMAPILib.Fax)faxserver.get_CreateObject(RFCOMAPILib.CreateObjectType.coFax);
                //string faxNO = txtCustomerFaxNo.Text.Replace("-", "").Replace("(", "").Replace(")", "").Replace(" ", "");
                string faxNO = txtCustomerFaxNo.Text;
                string createdBy = ((Session["UserName"] != null || Session["UserName"].ToString() == "") ? Session["UserName"].ToString() : "Dashboard");

                #region Create Right Fax Header
                
                fax.ToName = "Accounts Payable";
                fax.ToCompany = txtFaxToCompanyName.Text;
                fax.ToFaxNumber = faxNO;

                if (chkIncludeCover.Checked == true)
                {
                    fax.HasCoversheet = BoolType.True;
                    fax.FromFaxNumber = txtFaxFromFaxNo.Text;
                    fax.FromName = txtFaxFromName.Text + " (Porteous Fastener Co.)";
                    fax.FromVoiceNumber = txtFaxFromPhoneNo.Text;
                    
                    #region Insert notes lines to fax utility
                    if (txtFaxFromNotes.Text.Trim() != "")
                    {
                        int totalNotesLine = txtFaxFromNotes.Text.Length / 69;
                        int remainingLines = txtFaxFromNotes.Text.Length % 69;
                        int charStartIndex = 0;
                        int charEndIndex = 69;
                        int notesLineIndexCounter = 1;

                        if (totalNotesLine == 0)
                        {
                            fax.set_CoverSheetNotes(notesLineIndexCounter, txtFaxFromNotes.Text);
                        }
                        else
                        {
                            for (notesLineIndexCounter = 1; notesLineIndexCounter <= totalNotesLine; notesLineIndexCounter++)
                            {
                                fax.set_CoverSheetNotes(notesLineIndexCounter, txtFaxFromNotes.Text.Substring(charStartIndex, charEndIndex));
                                charStartIndex += 69;
                            }
                            if (remainingLines != 0)
                            {
                                fax.set_CoverSheetNotes(notesLineIndexCounter, txtFaxFromNotes.Text.Substring(charStartIndex, remainingLines));
                            }
                        }
                    }

                    #endregion

                    IsConverLetterSent = true;
                }
                else
                {
                    fax.HasCoversheet = BoolType.False;
                }

                #endregion

                #region Create Right Fax Content

                int totInvoiceCount = (selectedInvoiceNo.Contains(",") == true ? selectedInvoiceNo.Split(',').Length : 1);
                _printURL = ConfigurationManager.AppSettings["SOESiteURL"].ToString() + Server.UrlDecode(Request.QueryString["pageURL"].ToString()) + "&ScriptX=NO";  

                for (int i = 0; i < totInvoiceCount; i++)
                {
                    string _singleDocNo = (selectedInvoiceNo.Contains(",") == true ? selectedInvoiceNo.Split(',')[i].ToString() : selectedInvoiceNo);
                    string dynamicPageURL = _printURL.Replace("[DocNo]", _singleDocNo);                    
                    

                    #region Do web request & create HTML doc (used as an attachement in rightfax com object)

                    // Create a request using a URL that can receive a post. 
                    HttpWebRequest webRequest = (HttpWebRequest)System.Net.WebRequest.Create(dynamicPageURL);                    
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
                    string filename = "RequestEmail" + Session["SessionID"] + "_" + i.ToString() + ".html";
                    AppPath = AppPath + @"\" + filename;

                    #endregion

                    StreamWriter sw = new System.IO.StreamWriter(AppPath, true, Encoding.GetEncoding("windows-1252"));
                    {
                        sw.Write(htm);
                        sw.Flush();
                        sw.Close();
                                                
                        fax.Attachments.Add(AppPath, RFCOMAPILib.BoolType.True);
                    }

                    System.Threading.Thread.Sleep(2000);
                }

                #endregion

                fax.Send();                
            }

            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
    
    #endregion

    #region Data Access Layer

    private int GetMaxEmailAttachmentCount()
    {
        int _maxAttachAllowed = 0;
        DataTable dtResult = dataUtility.GetTableData("AppPref","AppOptionValue","(ApplicationCd = 'UTL') and AppOptionType='Email_inv'");
        if (dtResult != null)
        {
            _maxAttachAllowed = Convert.ToInt16(dtResult.Rows[0]["AppOptionValue"].ToString());
        }

        return _maxAttachAllowed;

    }

    private bool IsValidRequest()
    {

        return true;
    }

    #endregion

}
