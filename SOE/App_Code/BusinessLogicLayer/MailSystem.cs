/********************************************************************************************
 * Project				:	Umbrella 2.0
 * Specification Doc.   :   NA
 * File					:	MailSystem.cs
 * File Type			:	Class File
 * Description			:	Class which used to Send Mail
 * History				: 
 * 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 30 July '05			Ver-1			Sathishvarn	 		Created
 * 16 Aug '05			Ver-1			Shivakumar			Modified/Updated
 * 15 Sep '05			Ver-1			Shivakumar			Added new method
 * 23 Sep '05			Ver-1			Shivakumar			Fixed Bug
 *********************************************************************************************/


#region Namepsaces
using System;
using System.Xml;
using System.Web;
using System.Net.Mail;
using System.Data;
using System.Data.SqlClient;
using PFC.SOE.DataAccessLayer;
using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.Securitylayer;
using System.Collections;
using System.Configuration;
#endregion

namespace PFC.SOE.BusinessLogicLayer
{

    #region Enumerators
    /// <summary>
    /// Options for tracking email
    /// </summary>
    public enum EmailTrack
    {
        None = 0,
        All = 1,
        To = 2,
        CC = 3,
        BCC = 4
    }

    public enum ContentDataMergeOption
    {
        TagArray,
        DBContentData
    }

    /// <summary>
    /// Enumerator for Email Send To Option
    /// </summary>
    public enum EmailSendOption
    {
        Individual,
        Group
    }

    /// <summary>
    /// Enumerator for Email CC Sending Option
    /// </summary>
    public enum EmailSendCC
    {
        None,
        Required
    }

    public enum EmailStatus
    {
        Sent,
        Viewed,
        OptOut,
        Bounced
    }
    #endregion

    /// <summary>
    /// Summary description for EmailFunctions.
    /// </summary>
    public class MailSystem : System.Web.UI.Page
    {
        #region constants
        //
        // Constants
        //
        protected const string TBL_UEMM_EMAILCONTENT = "UEMM_EmailContent";
        protected const string TBL_UEMM_EMAILCONTENTDATA = "UEMM_EmailContentData";
        protected const string TBL_UEMM_EMAILCONFIGURATION = "UEMM_EmailConfiguration";
        protected const string TBL_UEMM_EMAILGROUP = "UEMM_EmailGroup";
        protected const string TBL_UEMM_EMAILTRACKING = "UEMM_EmailTracking";
        protected const string TBL_UEMM_EMAILBLOCKLIST = "UEMM_EmailBlockList";
        protected const string TBL_UEMM_EMAILCATEGORY = "UEMM_EmailCategory";
        protected const string TBL_UEMM_AUTHORIZEDTEMPLATE = "UEMM_AuthorizedEmailTemplatebyInterface";
        protected const string TBL_UCOR_APPCONFIG = "UCOR_ApplicationConfiguration";

        //
        // Stored Procedures
        //
        protected const string SP_GENERALSELECT = "UGEN_SP_Select";
        protected const string SP_GENERALINSERT = "UGEN_SP_Insert";
        protected const string SP_GENERALUPDATE = "UGEN_SP_Update";
        protected const string SP_GETSAFEEMAILLIST = "UEMM_SP_GetSafeEmailList";
        protected const string SP_GETIDENTITYAFTERINSERT = "UGEN_SP_GetIdentityAfterInsert";



        //
        // Module level variables for 
        // 
        string _tableName;		// For passing Table Name
        string _columnNames;	// For Passing Column Name			
        string _whereClause;    // For passing where condition
        string _values;			// For passing values while inserting values into table

        //
        // Declare variables for storing email list details
        //
        string emailTo = string.Empty;
        string emailCC = string.Empty;
        string emailBCC = string.Empty;

        bool trackEnabled;			// Boolean value for storing whether tracking is eanbled or not
        string emailSubject;		// Subject to send		
        string emailFrom;			// From Address
        string emailTemplateID;		// Template ID which is passed as parameter
        string emailAttachPath;		// Attachmment path
        public string _rawEmailContent;	// Variable to store email content 
        int EmailTrackID;			// Variable to store email Track ID which is auto generated
        public string finalcontent;

        string _unsubscribeCaption = string.Empty; // Variable to store the UnSubscribe caption
        bool _unsubscribeLink;		// variable to store whether unscubscribe is required or not

        //
        // Control Block Object
        //
        //UmbrellaControlBlock ControlBlock = new UmbrellaControlBlock();



        #endregion

        #region Global Variables

        protected Hashtable _controlData = new Hashtable();
        protected string smtpServer = string.Empty;
        protected string siteURL = string.Empty;
        protected string applicationPath = string.Empty;
        int _elementCounter = 1;
        public string _attachment = string.Empty;


        #endregion

        #region Methods
        /// <summary>
        /// Constructor
        /// </summary>
        public MailSystem()
        {            

        }

        /// <summary>
        /// Function to send an email without attachment
        /// </summary>
        /// <param name="To"></param>
        /// <param name="From"></param>
        /// <param name="Subject"></param>
        /// <param name="Body"></param>		
        public void SendMail(string To, string From, string CC, string BCC, string Subject, string Body)
        {
            try
            {
                // 
                // Create a Mail Message object
                //
                MailMessage EmailMessage = new MailMessage();

                //
                // Assigning To,From,CC address to mail 
                //
                if (To.Contains(","))
                {
                    string[] arrTo = To.Split(',');
                    for(int i=0;i<= arrTo.Length -1;i++)
                        EmailMessage.To.Add(arrTo[i]);
                }
                else
                    EmailMessage.To.Add(To);

                if (CC != string.Empty)
                    EmailMessage.CC.Add(CC);
                EmailMessage.From = new MailAddress(From);
                EmailMessage.IsBodyHtml = true;

                //
                // Subject line of the Email
                //
                EmailMessage.Subject = Subject;

                //
                // Body of the Email
                //
                EmailMessage.Body = Body;
                EmailMessage.Priority = MailPriority.High;

                // Send the message                
                SmtpClient smtp = new SmtpClient("pfcexch.pfca.com");
                smtp.Credentials = new System.Net.NetworkCredential("eConnect", "eCont07$");

                //SmtpClient smtp = new SmtpClient();
                //smtp.Credentials = new System.Net.NetworkCredential("umbrella@novantus.com", "Umbrella2.2");
                //smtp.EnableSsl = true;
                //smtp.Host = "smtp.gmail.com";
                //smtp.Port = 587;

                smtp.Send(EmailMessage);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        /// <summary>
        /// Function to send an email without attachment
        /// Function to catch the error. when the mail is not sent
        /// </summary>
        /// <param name="To"></param>
        /// <param name="From"></param>
        /// <param name="Subject"></param>
        /// <param name="Body"></param>		
        public void SendReportMail(string To, string From, string CC, string BCC, string Subject, string Body)
        {
            try
            {
                // 
                // Create a Mail Message object
                //
                MailMessage EmailMessage = new MailMessage();

                //
                // Assigning To,From,CC address to mail 
                //
                if (To.Contains(","))
                {
                    string[] arrTo = To.Split(',');
                    for (int i = 0; i <= arrTo.Length - 1; i++)
                        EmailMessage.To.Add(arrTo[i]);
                }
                else
                    EmailMessage.To.Add(To);
 
                EmailMessage.CC.Add(CC);
                EmailMessage.From = new MailAddress(From);
                EmailMessage.IsBodyHtml = true;

                //
                // Subject line of the Email
                //
                EmailMessage.Subject = Subject;

                //
                // Body of the Email
                //
                EmailMessage.Body = Body;
                EmailMessage.Priority = MailPriority.High;

                //
                // Send the message
                //
                //SmtpClient smtp = new SmtpClient();
                //smtp.Credentials = new System.Net.NetworkCredential("umbrella@novantus.com", "Umbrella2.2");
                //smtp.EnableSsl = true;
                //smtp.Host = "smtp.gmail.com";
                //smtp.Port = 587;
                SmtpClient smtp = new SmtpClient("pfcexch.pfca.com");
                smtp.Credentials = new System.Net.NetworkCredential("eConnect", "eCont07$");

                smtp.Send(EmailMessage);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        /// <summary>
        /// Function to Send email with attachment
        /// </summary>
        /// <param name="To"></param>
        /// <param name="From"></param>
        /// <param name="Subject"></param>
        /// <param name="path"></param>
        /// <param name="CC"></param>
        public void SendMail(string To, string From, string CC, string BCC, string Subject, string Body, string Attachpath)
        {
            
            // 
            // Create a Mail Message object
            //
            MailMessage EmailMessage = new MailMessage();
            try
            {
                //
                // Assigning To,From,CC address to mail 
                //
                EmailMessage.To.Add(To);
                if (CC != string.Empty)
                    EmailMessage.CC.Add(CC);
                EmailMessage.From = new MailAddress(From);
                EmailMessage.IsBodyHtml = true;
                
                //
                // Subject line of the Email
                //
                EmailMessage.Subject = Subject;

                //
                // Body of the Email
                //
                EmailMessage.Body = Body;

                //
                //Attachment
                //
                Attachment attach = new Attachment(Attachpath);
                EmailMessage.Attachments.Add(attach);

                //
                // Send the message
                //
                SmtpClient smtp = new SmtpClient("pfcexch.pfca.com");
                smtp.Credentials = new System.Net.NetworkCredential("eConnect", "eCont07$");

                //SmtpClient smtp = new SmtpClient();
                //smtp.Credentials = new System.Net.NetworkCredential("umbrella@novantus.com", "Umbrella2.2");
                //smtp.EnableSsl = true;
                //smtp.Host = "smtp.gmail.com";
                //smtp.Port = 587;

                smtp.Send(EmailMessage);                 
            }
            catch (Exception ex)
            {
                throw;

            }
            finally
            {
                EmailMessage.Dispose();
         
            }



        }

        public void SendMail(string To, string From, string CC, string BCC, string Subject, string Body, string[] Attachpaths)
        {

            // 
            // Create a Mail Message object
            //
            MailMessage EmailMessage = new MailMessage();
            try
            {
                //
                // Assigning To,From,CC address to mail 
                //
                EmailMessage.To.Add(To);
                if (CC != string.Empty)
                    EmailMessage.CC.Add(CC);
                EmailMessage.From = new MailAddress(From);
                EmailMessage.IsBodyHtml = true;

                //
                // Subject line of the Email
                //
                EmailMessage.Subject = Subject;

                //
                // Body of the Email
                //
                EmailMessage.Body = Body;

                //
                //Attachment
                //
                for (int i = 0; i < Attachpaths.Length; i++)
                {
                    Attachment attach = new Attachment(Attachpaths[i]);
                    EmailMessage.Attachments.Add(attach);
                }

                //
                // Send the message
                //
                SmtpClient smtp = new SmtpClient("pfcexch.pfca.com");
                smtp.Credentials = new System.Net.NetworkCredential("eConnect", "eCont07$");

                //SmtpClient smtp = new SmtpClient();
                //smtp.Credentials = new System.Net.NetworkCredential("umbrella@novantus.com", "Umbrella2.2");
                //smtp.EnableSsl = true;
                //smtp.Host = "smtp.gmail.com";
                //smtp.Port = 587;

                smtp.Send(EmailMessage);
            }
            catch (Exception ex)
            {
                throw;

            }
            finally
            {
                EmailMessage.Dispose();

            }



        }
        #endregion
    }
}