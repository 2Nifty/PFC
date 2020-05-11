
/********************************************************************************************
 * File	Name			:	ContactData.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	To display the customer Data
 * Created By			:	MaheshKumar.S
 * Created Date			:	11/14/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 11/14/2006		    Version 1		Mahesh      		Created 
 *********************************************************************************************/

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
using System.Net;

using WebSupergoo.ABCpdf5;
using WebSupergoo.ABCpdf5.Objects;
using WebSupergoo.ABCpdf5.Atoms;
using System.IO;
using PFC.SOE.BusinessLogicLayer;
using PFC.Intranet.Securitylayer;

public partial class CustomerActivitySheet_Print_Export : System.Web.UI.Page
{
    FileStream fStream;
    string strDetailType = string.Empty;


    Utility utils = new Utility();
    protected void Page_Load(object sender, EventArgs e)
    {
        Export();
    }


    protected void Export()
    {
        try
        {
            using (new Impersonator("sathis", "PFCA.COM", "Password~1"))
            {
                // Get the mode in the variable
                string strMode = Request.QueryString["Mode"].Trim();
                WebRequest req = WebRequest.Create("http://" + Request.ServerVariables["SERVER_NAME"].ToString() + "/SOE/Export.aspx?SOEID=" + Request.QueryString["SOEID"].Trim());
                WebResponse resp = req.GetResponse();
                StreamReader reader = new StreamReader(resp.GetResponseStream(), System.Text.Encoding.ASCII);

                // Get the page content in the string
                string strHtml = reader.ReadToEnd();
                string[] strhtm = strHtml.Split('~');
                strHtml = strhtm[1].ToString();
                strHtml = strHtml.Replace("|>", "");
                strHtml = strHtml.Replace("</div>", "");
                strHtml = strHtml.Replace("</html>", "");
                strHtml = strHtml.Replace("</form>", "");
                strHtml = strHtml.Replace("</body>", "");

                if (strMode.Trim() == "Print")
                {
                    divContents.InnerHtml = strHtml;

                }
                else
                {


                    // Code to export the pages to pdf
                    string strFilename = DateTime.Now.ToString().Replace("/", "");
                    strFilename = strFilename.Replace(" ", "");
                    strFilename = strFilename.Replace(":", "");

                

                    // Get the HTML FileName in a string
                        string strHTMLFilename = "SOE" + strFilename + ".htm";

                    // Get the PDF FileName in a string
                        string strPDFilename = "SOE" + strFilename + ".pdf";

                    // Code to create the HTML File
                    FileInfo fn = new FileInfo(Server.MapPath(strHTMLFilename));
                    StreamWriter writeHTML = fn.CreateText();
                    writeHTML.WriteLine("<html>");
                    writeHTML.WriteLine("<head>");
                    writeHTML.WriteLine("<link href=\"Common/StyleSheet/printstyles.css\" rel=\"stylesheet\" type=\"text/css\" />");
                    writeHTML.WriteLine("</head>");
                    writeHTML.WriteLine("<body class=\"PageBg\">");
                    writeHTML.WriteLine(strHtml);
                    writeHTML.WriteLine("</body>");
                    writeHTML.WriteLine("</html>");
                    writeHTML.Close();



                    // Code to create the pdf file
                    utils.CreatePDF("http://" + Request.ServerVariables["SERVER_NAME"].ToString() + "/SOE/" + strHTMLFilename, Server.MapPath("PDF/" + strPDFilename));

                    // Code to save or open the pdf file 
                    string pathFileName = Server.MapPath("PDF/" + strPDFilename);
                    fStream = new System.IO.FileStream(pathFileName, System.IO.FileMode.Open, System.IO.FileAccess.Read, System.IO.FileShare.Read);

                    Byte[] b;
                    if (fStream.Length > 0)
                    {
                        b = new Byte[fStream.Length];
                        Response.Clear();
                        Response.ClearContent();
                        Response.ClearHeaders();
                        Response.ContentType = "application/unknown";
                        fStream.Read(b, 0, (int)fStream.Length - 1);
                        Response.AddHeader("Content-Disposition", "attachment;filename=" + strPDFilename);
                        Response.BinaryWrite(b);
                        Response.End();
                        fStream.Close();
                    }
                }
            }
            
        }
        catch (Exception ex) {}
       
    }
}
