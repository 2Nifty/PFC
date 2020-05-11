using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.Sql;
using System.Data.SqlClient;
using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.DataAccessLayer;


public partial class RecallPrintUtility : System.Web.UI.Page
{
    private DataTable dtPrinterServer = new DataTable();
    private DataTable dtPrinterName = new DataTable();
    private string invoiceNo;
   


    MailSystem mailSystem = new MailSystem();
    PrintUtilityDialogue utilityDialogue = new PrintUtilityDialogue();
    private string _customerNumber = string.Empty;
    private string _printURL = string.Empty;
    private string MSGSUCESS = "Request has been sucessfully posted";


    protected void Page_Load(object sender, EventArgs e)
    {
        invoiceNo = Request.QueryString["InvoiceNo"];
      

        if (!Page.IsPostBack)
        {
            txtSubject.Text = "Invoice Recall For No#" + invoiceNo;
            btnEmail_Click(null, null);
        }

        divBannerEmail.Visible = false;
        pnlButtons.Update();
        
    }

   
    protected void btnPostEmail_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            string ToEmail = "";
            string subject = "<p><font face='arial,helvetica,sans-serif' size='2'>"+
                             "Dear User,</font></p><p><font face='arial,helvetica,sans-serif' size='2'>"+ 
                             "Please find the PFC certificate for below specification,<br /><br /></font>"+
                             "<font face='arial,helvetica,sans-serif' size='2'><strong>Invoice #</strong> [InvoiceNo]<br />"+
                             "<p><font face='arial,helvetica,sans-serif' size='2'>Regards,<br /></font><font face='arial,helvetica,sans-serif' size='2'>"+
                                 "PFC Administrator</font></p>";
            string body = "";
            string content = "";
            string FromMail="webadmin@porteousfastener.com";

            string emailID = txtEmailTo.Text;
          
            body =subject ;
            body = body.Replace("[InvoiceNo]", invoiceNo);
            

            DataTable dtInvoiceData = Session["InvoiceInfo"] as DataTable;
          
            if ( dtInvoiceData!=null && dtInvoiceData.Rows.Count > 0)
            {
                string[] attachementPaths = new string[dtInvoiceData.Rows.Count];

                for (int i = 0; i < dtInvoiceData.Rows.Count; i++)
                    attachementPaths[i] = dtInvoiceData.Rows[i]["ImagePhysicalPath"].ToString();
                mailSystem.SendMail(emailID, FromMail, "", "", txtSubject.Text, body, attachementPaths);
            }
            else
            {
                mailSystem.SendMail(emailID, FromMail, "", "", txtSubject.Text, body);
                
            } 
            divBannerEmail.Visible = true;    
            lblmsgEmail.Text = MSGSUCESS;            
            pnlButtons.Update();
        }


        catch (Exception ex)
        {
            throw;
        }
    }

    protected void btnEmail_Click(object sender, ImageClickEventArgs e)
    {
       // txtEmailTo.Text = Session["Email"].ToString();

        pnlEmail.Visible = true;
        btnEmail.ImageUrl = "~/Common/Images/Email_o.gif";
    } 

    private void ClearControls(string Param)
    {
        if (Param == "Email")
        {
            txtEmailTo.Text = "";
            txtSubject.Text = lblSubject.Text;
            txtComments.Text = "";
            txtEmailTo.Focus();
        }

    }

}

