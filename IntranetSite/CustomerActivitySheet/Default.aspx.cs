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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
using System.Data.SqlClient;
using PFC.Intranet.Securitylayer;
using System.Net.Mail;

public partial class CustomerActivitySheet_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
        #region 
        //for (int i = 1; i <= 3; i++)
        //{
        //    try
        //    {
        //        //
        //        // Variable Declarations
        //        //
        //        string _bodyMessage = "test";

        //        // 
        //        // Create a Mail Message object
        //        //
        //        MailMessage EmailMessage = new MailMessage();

        //        //
        //        // Assigning To,From,CC address to mail 
        //        //
        //        System.Net.Mail.MailAddress fromAddress = new MailAddress("sathishvaran@novantus.com");
        //        System.Net.Mail.MailAddress toAddress = new MailAddress("sathishvaran@gmail.com");

        //        EmailMessage.To.Add(toAddress);
        //        EmailMessage.From = fromAddress;
        //        EmailMessage.IsBodyHtml = true;

        //        //
        //        // Subject line of the Email
        //        //
        //        EmailMessage.Subject = "test";

        //        //
        //        // Body of the Email
        //        //
        //        EmailMessage.Body = _bodyMessage;
        //        EmailMessage.Headers.Add("http://schemas.microsoft.com/cdo/configuration/sendusing", "2");
        //        EmailMessage.Headers.Add("http://schemas.microsoft.com/cdo/configuration/smtpserver", "mail.novantus.com");	//basic authentication

        //        // Code update by mahesh on 12/08/2006 to send mail to all mail server
        //        //EmailMessage.Fields.Add("http://schemas.microsoft.com/cdo/configuration/sendusing", "2");	//basic authentication
        //        //EmailMessage.Fields.Add("http://schemas.microsoft.com/cdo/configuration/smtpserver", "pfcexch.pfca.com");	//basic authentication

        //        // EmailMessage.Fields.Add("http://schemas.microsoft.com/cdo/configuration/sendusername", strUserName); //set your username here
        //        // EmailMessage.Fields.Add("http://schemas.microsoft.com/cdo/configuration/sendpassword", strPassWord);	//set your password here

        //        //SmtpMail.SmtpServer = smtpServer;
        //        //
        //        // Send the message
        //        //


        //        System.Net.Mail.SmtpClient smtp = new SmtpClient();

        //        //smtp.Host = "mail.novantus.com";
        //        smtp.Send(EmailMessage);
        //        //System SmtpMail.Send(EmailMessage);
        //    }
        //    catch (Exception ex)
        //    {

        //        throw ex;
        //    }
        //}
        #endregion


        #region 2.0 
        try
        {

            //
            // Variable Declarations
            //
            string _bodyMessage = "test Body";

            // 
            // Create a Mail Message object
            //
            MailMessage EmailMessage = new MailMessage();

            //
            // Assigning To,From,CC address to mail 
            //
            EmailMessage.To.Add("sathishvaran@yahoo.com");
            EmailMessage.From = new MailAddress("webadmin@porteousfastner.com");
            EmailMessage.IsBodyHtml = true;

            //
            // Subject line of the Email
            //
            EmailMessage.Subject = "test subject";

            //
            // Body of the Email
            //
            EmailMessage.Body = _bodyMessage;
            
            //
            // Send the message
            //
            SmtpClient smtp = new SmtpClient("mail.novantus.com");
            smtp.UseDefaultCredentials = true;
            smtp.Credentials = new System.Net.NetworkCredential("sathishvaran", "sathisht","");
            smtp.Send(EmailMessage);
        }
        catch (Exception ex)
        {
                       
        }
        #endregion

    }
}
