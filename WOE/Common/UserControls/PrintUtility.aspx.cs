using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.WOE.BusinessLogicLayer;
using PFC.WOE.DataAccessLayer;


public partial class _Default : System.Web.UI.Page
{
    PrintUtilityDialogue utilityDialogue = new PrintUtilityDialogue();

    private DataTable dtPrinterServer = new DataTable();
    private DataTable dtPrinterName = new DataTable();
    private string customerName;
    private string _customerNumber = string.Empty;
    private string Mode;
    private string _printURL = string.Empty;
    private string MSGSUCESS = "Request has been sucessfully posted";
   
    protected void Page_Load(object sender, EventArgs e)
    {
        string PrintURL = Server.UrlDecode(Request.QueryString["pageURL"].ToString().Replace("`", "'"));
        //url = url.Remove(url.Length - 1, 1);
        _printURL = ConfigurationManager.AppSettings["WOESiteURL"].ToString() + PrintURL;
        btnPrinter.Attributes.Add("onclick", "javascript:PrintPopUP('" +  Server.UrlEncode(Request.QueryString["pageURL"].ToString()) + "');");
        string PreviewURL = ConfigurationManager.AppSettings["WOESiteURL"].ToString() +
           Server.UrlDecode(Request.QueryString["pageURL"].ToString().Replace("`", "'"));
        // added by Slater 10/5/2010
        PreviewURL += "&ScriptX=YES";
        btnPrintPreviewDoc.Attributes.Add("onclick", "javascript:OpenPreview('" + PreviewURL + "');");
        btnEMailPreviewDoc.Attributes.Add("onclick", "javascript:OpenPreview('" + PreviewURL + "');");
        btnFAXPreviewDoc.Attributes.Add("onclick", "javascript:OpenPreview('" + PreviewURL + "');");
        
        if (!Page.IsPostBack)
        {
            Mode = Request.QueryString["Mode"];
            BindName();
            lblCust.Text = customerName;

            if (Request.QueryString["EnableEmail"].ToString().ToLower() == "false")
                btnEmail.Visible = false;

            if (Request.QueryString["EnableFax"].ToString().ToLower() == "false")
                btnFax.Visible = false;

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
                btnEmail.Visible = true;
                btnEmail_Click(null, null);
            }
            
            if (Mode == "Fax")
            {
                btnFax.Visible = true;
                btnFax_Click(null, null);
            }

            BindDropServer();
            BindDropPrinter();

            pnlButtons.Update();

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
        //string url = Request.QueryString["pageURL"].ToString().Remove(0, 1);
        string url = Server.UrlDecode(Request.QueryString["pageURL"].ToString().Replace("`","'"));

        //url = url.Remove(url.Length - 1, 1);
        _printURL = ConfigurationManager.AppSettings["WOESiteURL"].ToString() + url;
        string UserName = ( Session["UserName"] != null ? Session["UserName"].ToString() : "WOE");
        string _formName = (Request.QueryString["FormName"] == null ? "" : Request.QueryString["FormName"].ToString());

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
                                "'"+ _formName+ "'";
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
                                "'" + _formName+ "'";;
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
        _printURL = ConfigurationManager.AppSettings["WOESiteURL"].ToString() + url;
        string UserName = (Session["UserName"] != null ? Session["UserName"].ToString() : "WOE");

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

    protected void btnPostFax_Click(object sender, ImageClickEventArgs e)
    {
        string url = Server.UrlDecode(Request.QueryString["pageURL"].ToString());
       
        _printURL = ConfigurationManager.AppSettings["WOESiteURL"].ToString() + url;
        string UserName = (Session["UserName"] != null ? Session["UserName"].ToString() : "WOE");

        string columnName = "createdBy,createdDate,Status,QueueType,PageURL,Sentto";
        string columnvalues = "'" + UserName + "'," +
                                "'" + DateTime.Now.ToLocalTime() + "'," +
                                "'0'," +
                                "'Fax'," +
                                "'" + _printURL.Replace("`","'").Replace("'", "''") + "'," +
                                "'" + txtCustomerFaxNo.Text + "'";

        utilityDialogue.GetData(columnName, columnvalues);
        divBanner.Visible = true;
        lblmsg.Text = MSGSUCESS;
        ClearControls("Fax");
        pnlButtons.Update();
    }

    protected void btnEmail_Click(object sender, ImageClickEventArgs e)
    {
        string Model = "Email";
        pnlEmail.Visible = true;
        pnlFax.Visible = false;
        pnlPrint.Visible = false;
        btnFax.ImageUrl = "../Images/fax_n.gif";
        btnEmail.ImageUrl = "../Images/email_o.gif";
        btnPrint.ImageUrl = "../Images/print_n.gif";
        //if (Request.QueryString["CustomerNumber"] != "")
        // lnkEmail.Attributes.Add("onclick", "Javascript:OpenPopup('" + Model + "','" + Request.QueryString["CustomerNumber"] + "');"); 
        //else
        lnkEmail.Font.Underline= false;
    }

    protected void btnPrint_Click(object sender, ImageClickEventArgs e)
    {
        string UserName = (Session["UserName"] != null ? Session["UserName"].ToString() : "WOE");
        hidPrinter.Value = txtPrint.Text = utilityDialogue.GetDefaultPrinter(UserName.ToString());
        tblDefaultPrinter.Visible = false;
        tblPrinterPref.Visible = true;
        pnlPrint.Visible = true;
        pnlFax.Visible = false;
        pnlEmail.Visible = false;
        btnFax.ImageUrl = "../Images/fax_n.gif";
        btnEmail.ImageUrl = "../Images/email_n.gif";
        btnPrint.ImageUrl = "../Images/print_o.gif";
        pnlPrint.Update();
    }

    protected void btnFax_Click(object sender, ImageClickEventArgs e)
    {
        string Model = "Fax";
        pnlFax.Visible = true;
        pnlPrint.Visible = false;
        pnlEmail.Visible = false;
        btnFax.ImageUrl = "../Images/fax_o.gif";
        btnEmail.ImageUrl = "../Images/email_n.gif";
        btnPrint.ImageUrl = "../Images/print_n.gif";
        //if (Request.QueryString["CustomerNumber"] != "")
        //    lnkFax.Attributes.Add("onclick", "Javascript:OpenPopup('" + Model + "','" + Request.QueryString["CustomerNumber"] + "');");
        //else
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
        btnPrintPreviewDoc.Visible = true;
    }

    protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
    {
        string UserName = (Session["UserName"] != null ? Session["UserName"].ToString() : "WOE");
        string defaultPrinter = "\\\\"+ddlDefaultPrintServer.SelectedItem.Value.ToString() + "\\" + ddldefaultPrinter.SelectedItem.Text.ToString();
        string columnName = "DefaultPrinter='" + defaultPrinter + "'";
        string whereClause = " UserName='" + UserName + "'";
        utilityDialogue.UpdateDefaultPrinter(columnName, whereClause);

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
