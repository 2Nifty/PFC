
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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
using PFC.Intranet.BusinessLogicLayer;
using WebSupergoo.ABCpdf5;
using WebSupergoo.ABCpdf5.Objects;
using WebSupergoo.ABCpdf5.Atoms;
using System.IO;
using PFC.Intranet.Securitylayer;

public partial class CustomerActivitySheet_Print_Export : System.Web.UI.Page
{
    FileStream fStream;
    string strDetailType = string.Empty;
    protected void Page_Load(object sender, EventArgs e)
    {

        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        try
        {
            // Get the mode in the variable
            string strMode = Request.QueryString["mode"].Trim();

            // Get the url of the pages in the string
            string strUrl = Request.QueryString["URL"].Trim();

            strUrl = strUrl.Replace("~", "&");
            string[] url = strUrl.Split(',');

            strDetailType = Session["DetailType"] != null ? Session["DetailType"].ToString() : "PFC Employee";

            // Using HTTP Post get the content of the pages in the array
            for (int i = 0; i < url.Length; i++)
            {
                WebRequest req = WebRequest.Create(Global.IntranetSiteURL + "CustomerActivitySheet/" + url[i].Trim().Replace('`', ',') + "&ChartType=" + Session["ChartType"].ToString() + "&ChartPalette=" + Session["ChartPalette"].ToString() + "&CustomerType=" + Session["CustomerType"].ToString() + "&mode=" + strMode + "&DetailType=" + strDetailType + "&PrintMode=Print");
                WebResponse resp = req.GetResponse();
                StreamReader reader = new StreamReader(resp.GetResponseStream(), System.Text.Encoding.ASCII);

                // Get the page content in the string
                string strHtml = reader.ReadToEnd();
                string[] strhtm = strHtml.Split('~');
                strHtml = strhtm[1].ToString();
                strHtml = strHtml.Replace("|>", "");
                strHtml = strHtml.Replace("|\">", "");
                strHtml = strHtml.Replace("</html>", "");
                strHtml = strHtml.Replace("</form>", "");
                strHtml = strHtml.Replace("</body>", "");
                if ((i == url.Length - 1) && (url[i].ToString().IndexOf("SalesCategoryDetail") != -1))
                {
                    strHtml = strHtml.Replace("style=\"page-break-after:always;\"", "");
                }
                else
                    strHtml = (i == url.Length - 1) ? strHtml.Replace("page-break-after:always", "") : strHtml;
                // Assing the page content in to the div
                strHtml = strHtml.Replace("???", "-");
                strHtml = strHtml.Replace("??", "  ");

                divContent.InnerHtml = divContent.InnerHtml + "<form>" + strHtml + "</form>";
            }

            if (strMode.Trim() == "Print")
            {
                // Script to print the current form
                Response.Write("<script>window.print();</script>");
            }
            else
            {
                // Code to export the pages to pdf
                string strFilename = DateTime.Now.ToString().Replace("/", "");
                strFilename = strFilename.Replace(" ", "");
                strFilename = strFilename.Replace(":", "");

                // Get the HTML FileName in a string
                string strHTMLFilename = "CAS" + Session["SessionID"].ToString() + strFilename + ".htm";

                // Get the PDF FileName in a string
                string strPDFilename = "CAS" + Session["SessionID"].ToString() + strFilename + ".pdf";
                string strContent = divContent.InnerHtml.Replace("style=\"width:100%;border-collapse:collapse;\"", "style=\"width:100%;border-collapse:collapse;border-left:1px;border-right:1px;border-bottom:1px;border-top:1px\"");

                // Code to create the HTML File
                FileInfo fn = new FileInfo(Server.MapPath(strHTMLFilename));
                StreamWriter writeHTML = fn.CreateText();
                writeHTML.WriteLine("<html>");
                writeHTML.WriteLine("<head>");
                writeHTML.WriteLine("<link href=\"../CustomerActivitySheet/Styles/Styles.css\" rel=\"stylesheet\" type=\"text/css\" />" +
                   "<link href=\"../SalesAnalysisReport/StyleSheet/Styles.css\" rel=\"stylesheet\" type=\"text/css\" />");
                writeHTML.WriteLine("</head>");
                writeHTML.WriteLine("<body>");
                writeHTML.WriteLine(strContent.Replace("class=DashBoardBk", ""));
                writeHTML.WriteLine("</body>");
                writeHTML.WriteLine("</html>");
                writeHTML.Close();

                // Initialize the class variable Customeractivitysheet
                PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet cs = new PFC.Intranet.BusinessLogicLayer.CustomerActivitySheet();

                // Code to create the pdf file
                cs.CreatePDF(Global.IntranetSiteURL + "CustomerActivitySheet/" + strHTMLFilename, Server.MapPath("PDF/" + strPDFilename));

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
        catch (Exception ex)
        {
            fStream.Close();
        }
        finally
        {
            
        }
    }
}
