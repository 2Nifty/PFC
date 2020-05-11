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
using System.Net.Mail;
using System.Data.Sql;
using System.Data.SqlClient;
using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.DataAccessLayer;



public partial class GetCerts : System.Web.UI.Page
{
    protected MailSystem objMailSystem = new MailSystem();
    Certs certs;
    string QuotesConnectionString = ConfigurationManager.AppSettings["QuotesConnectionString"].ToString();
    string ConnectionString = ConfigurationManager.AppSettings["ConnectionString"].ToString();
   string certFileName ;

    string emailID = "";
    string FromMail = "";
    string imgURL = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        certFileName = "Cert_" + HttpContext.Current.Session.SessionID.ToString() + ".jpg";
        certs = new Certs();
        
        
    }

  
    protected void btnCertsAssist_Click(object sender, ImageClickEventArgs e)
    {
        MailCertAssist();
        ClearControl();
       
    }

    private void MailCertAssist()
    {
        try
        {
            string ToEmail = "";
            string subject = "";
            string body = "";
            string content = "";

            string userName = Session["UserName"].ToString();
            string company = Session["CompanyName"].ToString();
            string custNumber = Session["CustomerNumber"].ToString();
            emailID = Session["Email"].ToString();

            SqlDataReader NameReader = SqlHelper.ExecuteReader(QuotesConnectionString, "UGEN_SP_Select",
                                            new SqlParameter("@tableName", "DTQ_Applicationconfiguration"),
                                            new SqlParameter("@columnNames", "FromEmailID"),
                                            new SqlParameter("@whereClause", "1=1"));



            if (NameReader.Read())
            {
                 FromMail = NameReader["FromEMailID"].ToString();
                    ToEmail = "certs@Porteousfastener.com,QA@porteousfastener.com";
                 //ToEmail = "sathis@porteousfastener.com";

                SqlDataReader NameReader1 = SqlHelper.ExecuteReader(ConnectionString, "UGEN_SP_Select",
                                           new SqlParameter("@tableName", "UEMM_EmailContent"),
                                           new SqlParameter("@columnNames", "*"),
                                           new SqlParameter("@whereClause", "TemplateID='" + 82 + "'"));

                if (NameReader1.Read())
                {
                    subject = NameReader1["Subject"].ToString();
                    body = NameReader1["Content"].ToString();
                    content = body.Replace("[Item No]", txtItemNumber.Text);
                    content = content.Replace("[Lot No]", txtMfgLotNo.Text);
                    content = content.Replace("[UserName]", userName);
                    content = content.Replace("[Email]", emailID);
                    content = content.Replace("[CompanyName]", company);
                    content = content.Replace("[Customer Number]", custNumber);

                }
            }

            objMailSystem.SendMail(ToEmail, FromMail, "", "", subject, content);
            ScriptManager.RegisterClientScriptBlock(btnCertsAssist, btnCertsAssist.GetType(), "MailInfo", "window.alert('Your request is sent to PFC Successfully');", true);
               
            }
       

        catch (Exception ex)
        {
            throw;
        }
  
    }

    public void ClearControl()
    {
        txtItemNumber.Text = txtMfgLotNo.Text = txtPFCLotNo.Text = "";
        CertsAssit.Visible = false;
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        if (txtItemNumber.Text != "" && txtMfgLotNo.Text != "")
        {
            imgURL = certs.CheckForXML(txtItemNumber.Text,txtPFCLotNo.Text, txtMfgLotNo.Text, certFileName);
            Session["ImgURL"] = imgURL.Trim();
            if (imgURL != "")
            {

                ScriptManager.RegisterClientScriptBlock(btnSubmit, btnSubmit.GetType(), "GetCertificate", "GetXMLImage('" + txtItemNumber.Text.Trim() + "','" + txtPFCLotNo.Text.Trim() + "','" + txtMfgLotNo.Text.Trim() + "');", true);
                ClearControl();

            }

            else
            {

                if (certs.CheckCertAvailability(txtItemNumber.Text, txtPFCLotNo.Text ,txtMfgLotNo.Text, certFileName))
                {
                    ScriptManager.RegisterClientScriptBlock(btnSubmit, btnSubmit.GetType(), "GetCertificate", "GetEnlargeImage('" + txtItemNumber.Text.Trim() + "','" + txtPFCLotNo.Text.Trim() + "','" + txtMfgLotNo.Text.Trim() + "');", true);
                    ClearControl();
                }
                else
                {
                    CertsAssit.Visible = true;
                    imgCerts.Visible = false;
                }
            }

        }

    }
}
