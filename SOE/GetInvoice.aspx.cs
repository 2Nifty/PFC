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
using System.Data.Sql;
using System.Data.SqlClient;
using System.Net;
using System.IO;
using System.Text;
using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.DataAccessLayer;
using PFC.SOE.Enums;

public partial class GetInvoice : System.Web.UI.Page
{
    string invoicePageURL = "InvoiceExport.aspx?InvoiceNo=";
    string invoiceNo = "";

    Utility utility = new Utility();
    SelectPrintInvoice printInvoice = new SelectPrintInvoice();
   
    protected void Page_Load(object sender, EventArgs e)
    {
        invoiceNo = Request.QueryString["InvoiceNo"].ToString();
        //invoiceNo = "62584";
        txtInvoiceNumber.Text = invoiceNo;

        if (invoiceNo != "")
        {
            // figure out the document type
            string whereClause = "InvoiceNo='" + invoiceNo + "'";
            DataTable dtInvoice = printInvoice.GetInvoice(whereClause);
            if (dtInvoice.Rows.Count > 0)
            {
                if (dtInvoice.Rows[0]["OrderType"].ToString().Trim() == "CR")
                {
                    invoicePageURL = "CreditExport.aspx?InvoiceNo=";
                    PrintDialogue1.PageTitle = "PFC Credit Memo For Credit#  " + invoiceNo;
                    Footer1.Title = "Credit Memo";
                }
                else
                {
                    if (dtInvoice.Rows[0]["SubType"].ToString().Trim() == "53")
                    {
                        invoicePageURL = "RGRExport.aspx?InvoiceNo=";
                        PrintDialogue1.PageTitle = "PFC Returned Goods Receipt For RGR#  " + invoiceNo;
                        Footer1.Title = "Returned Goods Receipt";
                    }
                    else
                    {
                        invoicePageURL = "InvoiceExport.aspx?InvoiceNo=";
                        PrintDialogue1.PageTitle = "PFC Invoice For Invoice#  " + invoiceNo;
                        Footer1.Title = "Original Invoice";
                    }
                }
            }
            else
            {
                printInvoice.DisplayMessage(MessageType.Failure, "No Records found", lblMessage);
            }

            GenerateInvoice();

            // Print urilty
            PrintDialogue1.CustomerNo = "";
            PrintDialogue1.PageUrl = Server.UrlEncode(invoicePageURL + invoiceNo);
        }
        else
        {
            utility.DisplayMessage(MessageType.Failure, "No Records Found", lblMessage);            
        }    

    }

    public void GenerateInvoice()
    {
        ifrmInvoice.Attributes.Add("src", invoicePageURL + invoiceNo);     
    }
     
}
