using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.IO;
using System.Net.Mail;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
using GER;

public partial class RTSVendorAdvice : System.Web.UI.Page
{
    PFC.Intranet.BusinessLogicLayer.GERRTS gerrts = new PFC.Intranet.BusinessLogicLayer.GERRTS();
    Utility getUtility = new Utility();
    string VendorShortCode = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            SetDefaultDir();
            EMailCCTextBox.Text = gerrts.GetAppPref("ECC");
            EMailSubjectTextBox.Text = gerrts.GetAppPref("ESUBJECT");
            EMailFromTextBox.Text = gerrts.GetAppPref("EFROM");
        }
        //if (VendorDropDownList.SelectedValue != "")
        //{
        //    SetDefaultEMail(VendorDropDownList.SelectedValue);
        //}
   }

    protected void VendDDL_LoadComplete(object sender, EventArgs e)
    {
        //if (!Page.IsPostBack)
        //{
        //    if (VendorDropDownList.Items.Count > 0)
        //    {
        //        SetDefaultEMail(VendorDropDownList.Items[0].Value.ToString());
        //    }
        //}
    }

    protected void VendDDL_IndexChanged(object sender, EventArgs e)
    {
        //SetDefaultEMail(VendorDropDownList.SelectedValue.ToString());
    }

    protected void ExcelExportButton_Click(object sender, ImageClickEventArgs e)
    {
        // 
        CreateExcelFile();
        Response.Redirect("file:" + DefaultDirLabel.Text + "VendorAdvice.xls");
    }

    protected void ExcelEMailButton_Click(object sender, ImageClickEventArgs e)
    {
        lblSuccessMessage.Text = "";
        CreateExcelFile();
        // 
        // Specify the file to be attached and sent.
        // This example assumes that a file named Data.xls exists in the
        // current working directory.
        string file = DefaultDirLabel.Text + "VendorAdvice.xls";
        // Create a message and set up the recipients.
        MailMessage message = new MailMessage(
           EMailFromTextBox.Text,
           VendorEMailTextBox.Text.ToString().Replace(";", ","),
           //"tslater@porteousfastener.com",
           EMailSubjectTextBox.Text,
           EMailBodyTextBox.Text);
        // Add a carbon copy recipient.
        MailAddress copy = new MailAddress(EMailCCTextBox.Text);
        message.CC.Add(copy);
        // Create  the file attachment for this e-mail message.
        Attachment data = new Attachment(file);
        // Add time stamp information for the file.
        //ContentDisposition disposition = data.ContentDisposition.;
        data.ContentDisposition.CreationDate = System.IO.File.GetCreationTime(file);
        data.ContentDisposition.ModificationDate = System.IO.File.GetLastWriteTime(file);
        data.ContentDisposition.ReadDate = System.IO.File.GetLastAccessTime(file);
        data.Name = "VendorAdvice.xls";
        // Add the file attachment to this e-mail message.
        message.Attachments.Add(data);
        //Send the message.
        SmtpClient client = new SmtpClient("PFCEXCH");
        // Add credentials if the SMTP server requires them.
        //client.Credentials = CredentialCache.DefaultNetworkCredentials;
        client.Send(message);
        data.Dispose();
        lblSuccessMessage.Text = "E-Mail sent.";
    }

    private void SetDefaultDir()
    {
        //
        //To fill the default directory for vendor files
        //
        DefaultDirLabel.Text = gerrts.GetAppPref("DIR");
    }

    private void SetDefaultEMail(string VendorShortCode)
    {
        //
        //Get the Vendor e-mail from a vendor contact spreadsheet
        //
        DataSet dsVendorContactData = gerrts.LoadVendorContacts(VendorShortCode);
        if (dsVendorContactData.Tables[0].Rows.Count > 0)
        {
            DataRow row = dsVendorContactData.Tables[0].Rows[0];
            VendorEMailTextBox.Text = row["E-Mail"].ToString();
            EMailBodyTextBox.Text = "To: " + row["Contact"].ToString() + "\n";
            EMailBodyTextBox.Text += row["Name"].ToString() + "\n";
        }
        else
        {
            VendorEMailTextBox.Text = ".";
        }
    }

    private void CreateExcelFile()
    {
        //
        //Create the vendor advice spreadsheet
        //
        using (StreamWriter sw = new StreamWriter(DefaultDirLabel.Text + "VendorAdvice.xls"))
        {
            foreach (TableCell column in AdviceGridView.HeaderRow.Cells)
            {
                sw.Write(column.Text);
                sw.Write("\t");
            }
            sw.WriteLine();
            foreach (GridViewRow row in AdviceGridView.Rows)
            {
                foreach (TableCell column in row.Cells)
                {
                    if (column.Text.Contains("nbsp"))
                    {
                        sw.Write( "" );
                    }
                    else
                    {
                        sw.Write(Server.HtmlDecode(column.Text).Trim());
                    }
                    sw.Write("\t");
                }
                sw.WriteLine();
            }
        }
    }

}
