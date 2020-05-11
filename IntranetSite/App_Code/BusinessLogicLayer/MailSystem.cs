/********************************************************************************************
 * Project				:	Umbrella 2.0
 * Specification Doc.   	:   NA
 * File				:	MailSystem.cs
 * File Type			:	Class File
 * Description			:	Class which used to Send Mail
 * History				: 
 * 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 30 July '05			Ver-1			Sathishvaran	 		Created
 * 10 July '06
 *********************************************************************************************/


#region Namepsaces
using System;
using System.Xml;
using System.Web;
using System.Web.Mail;
using System.Data;
using System.Data.SqlClient;
using System.Collections;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
#endregion

namespace PFC.BusinessLogicLayer
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

        protected const string TBL_UEMM_EMAILCONFIGURATION = "UEMM_EmailConfiguration";

        //
        // Stored Procedures
        //
        protected const string SP_GENERALSELECT = "UGEN_SP_Select";
        protected const string SP_GENERALINSERT = "UGEN_SP_Insert";
        protected const string SP_GENERALUPDATE = "UGEN_SP_Update";

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

              /// <summary>
        /// Constructor
        /// </summary>
        public MailSystem()
        {
            
        }


        /// <summary>
        /// Function to reterive from address from given TemplateID
        /// </summary>
        private string GetFromAddress(string templateID)
        {
            //
            // Select From Adrress from DB
            //
            string _tableName = TBL_UEMM_EMAILCONFIGURATION;
            string _columnNames = "EmailFrom";
            string _whereClause = "TemplateID='"+templateID+"'";
            string _fromAddress = string.Empty;

            DataSet dsFromAddress = SqlHelper.ExecuteDataset(Global.QuotesSystemConnectionString, SP_GENERALSELECT,
                                     new SqlParameter("@tableName", _tableName),
                                     new SqlParameter("@columnNames", _columnNames),
                                     new SqlParameter("@whereCondition", _whereClause));
            if (dsFromAddress.Tables[0].Rows.Count > 0)
            {
                DataRow drFromAddress = dsFromAddress.Tables[0].Rows[0];

                _fromAddress = drFromAddress["EmailFrom"].ToString();
            }
            return _fromAddress;
        }

        /// <summary>
        /// Function to send an email without attachment
        /// </summary>
        /// <param name="To"></param>
        /// <param name="From"></param>
        /// <param name="Subject"></param>
        /// <param name="Body"></param>		
        public void SendMail(string To, string CC, string BCC, string TemplateID, string Subject)
        {
            try
            {

                string From = GetFromAddress(TemplateID);               
                //
                // Variable Declarations
                //
                string _bodyMessage = GetContent(TemplateID);

                // 
                // Create a Mail Message object
                //
                System.Web.Mail.MailMessage EmailMessage = new System.Web.Mail.MailMessage();

                SmtpMail.SmtpServer = smtpServer;

                //
                // Assigning To,From,CC address to mail 
                //
                EmailMessage.To = To;
                EmailMessage.From = From;
                EmailMessage.Cc = CC;
                EmailMessage.BodyFormat = MailFormat.Html;

                //
                // Subject line of the Email
                //
                EmailMessage.Subject = Subject;

                //
                // Body of the Email
                //
                EmailMessage.Body = _bodyMessage;
                //
                // Send the message
                //
                System.Web.Mail.SmtpMail.Send(EmailMessage);
            }
            catch (Exception ex)
            {
                string a = ex.Message;
            }
        }
	   /// <summary>
        /// 
        /// </summary>
        /// <param name="To"></param>
        /// <param name="CC"></param>
        /// <param name="BCC"></param>
        /// <param name="TemplateID"></param>
        /// <param name="Subject"></param>
        /// <param name="loginID"></param>
        public void SendMail(string To, string CC, string BCC, string TemplateID, string Subject, string loginID,string systemName,string customerNumber,string adminName)
        {
            try
            {
                string From = GetFromAddress(TemplateID);
                //
                // Variable Declarations
                //
                string _bodyMessage = GetContent(TemplateID);             

                _bodyMessage = _bodyMessage.Replace("[Vendor]", adminName);
                _bodyMessage = _bodyMessage.Replace("[LoginID]", loginID);
                _bodyMessage = _bodyMessage.Replace("[Customer]", "<font color='#000066'>PFC Customer #: </font>"+customerNumber);
                _bodyMessage = _bodyMessage.Replace("[UserType]", systemName);

                // 
                // Create a Mail Message object
                //
                System.Web.Mail.MailMessage EmailMessage = new System.Web.Mail.MailMessage();

                SmtpMail.SmtpServer = smtpServer;

                //
                // Assigning To,From,CC address to mail 
                //
                EmailMessage.To = To;
                EmailMessage.From = From;
                EmailMessage.Cc = CC;
                EmailMessage.BodyFormat = MailFormat.Html;

                //
                // Subject line of the Email
                //
                EmailMessage.Subject = Subject;

                //
                // Body of the Email
                //
                EmailMessage.Body = _bodyMessage;
                //
                // Send the message
                //
                System.Web.Mail.SmtpMail.Send(EmailMessage);
            }
            catch (Exception ex)
            {
                string a = ex.Message;
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
            // Variable Declarations
            //
            string _bodyMessage = Body;

            // 
            // Create a Mail Message object
            //
            System.Web.Mail.MailMessage EmailMessage = new System.Web.Mail.MailMessage();
            SmtpMail.SmtpServer = smtpServer;

            //
            // Assigning To,From,CC address to mail 
            //
            EmailMessage.To = To;
            EmailMessage.From = From;
            EmailMessage.Cc = CC;
            EmailMessage.BodyFormat = MailFormat.Html;

            //
            // Subject line of the Email
            //
            EmailMessage.Subject = Subject;

            //
            // Body of the Email
            //
            EmailMessage.Body = _bodyMessage;

            //
            // Attaching the files from given path
            //
            System.Web.Mail.MailAttachment myAttachment = new System.Web.Mail.MailAttachment(Attachpath);
            EmailMessage.Attachments.Add(myAttachment);

            //
            // Send the message
            //
            System.Web.Mail.SmtpMail.Send(EmailMessage);

        }

        private string GetContent(string TemplateID)
        {

            try
            {
                DataSet dsEmailContent = SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SP_GENERALSELECT,
                                          new SqlParameter("@tableName", "UEMM_EmailContent"),
                                          new SqlParameter("@columnNames", "Content,Subject"),
                                          new SqlParameter("@whereCondition", "TemplateID ='"+TemplateID+"'"));


                string EmailContent = "";                
                string EmailSubject = "";

                if (dsEmailContent.Tables[0].Rows.Count > 0)
                {
                    DataRow drEmailContent = dsEmailContent.Tables[0].Rows[0];
                    EmailContent = Server.HtmlDecode(drEmailContent["Content"].ToString());
                    EmailSubject = Server.HtmlDecode(drEmailContent["Subject"].ToString());

                    //
                    // Replace UserName
                    //
                    if(TemplateID=="76")
                    EmailContent = EmailContent.Replace("[Vendor]", "Vendor");
                    else
                    EmailContent = EmailContent.Replace("[Vendor]", "[Vendor]");
                    EmailContent = EmailContent.Replace("[SiteURL]", siteURL);
                }
                return EmailContent;
            }
            catch (Exception ex)
            {

                throw;
            }

        }
        public void SendMail(string From, string To, string Subject, string body)
        {
            try
            {
                //
                // Variable Declarations
                //
                string _bodyMessage = body;

                // 
                // Create a Mail Message object
                //
                System.Web.Mail.MailMessage EmailMessage = new System.Web.Mail.MailMessage();

                SmtpMail.SmtpServer = smtpServer;

                //
                // Assigning To,From,CC address to mail 
                //
                EmailMessage.To = To;
                EmailMessage.From = From;
                EmailMessage.BodyFormat = MailFormat.Html;

                //
                // Subject line of the Email
                //
                EmailMessage.Subject = Subject;

                //
                // Body of the Email
                //
                EmailMessage.Body = _bodyMessage;
                //
                // Send the message
                //
                System.Web.Mail.SmtpMail.Send(EmailMessage);
            }
            catch (Exception ex)
            {
                string a = ex.Message;
            }
        }

    }
}