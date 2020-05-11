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
using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.DataAccessLayer;

public partial class InvoiceRecallImageExport : System.Web.UI.Page
{
    string noRecordMessage = "No Records Found";
    string queryMessage = "Query Completed Successfully";

    InvoiceReCall invoiceCall = new InvoiceReCall();

    DataTable dtInvoice = new DataTable();
    DataTable dtInvoiceImage = new DataTable();
    string[] invoice ={ };
    protected void Page_Load(object sender, EventArgs e)
    {
        //string InvoiceNoImage = "62571|62571|62571";
         string InvoiceNoImage = Request.QueryString["InvoiceNo"].ToString();
         invoice = InvoiceNoImage.Split('|');
         BindGrid();
    }
    private void BindGrid()
    {

        DataTable dtMain= new DataTable();
        for (int i = 0; i < invoice.Length; i++)
        {
            string invoiceFileName = "Invoice_" + HttpContext.Current.Session.SessionID.ToString()+"File"+i.ToString() + ".jpg";
           string imgURL= invoiceCall.CheckForXML(invoice[i], invoiceFileName);
           dtInvoiceImage = invoiceCall.GetCertImagesFromTifImage(imgURL);
           if(i ==0)
           {
               dtMain= dtInvoiceImage.Clone();
           }
           dtMain.Merge(dtInvoiceImage);
        }
        
        //dtInvoice = Session["Invoiceinfo"] as DataTable;
        if (dtMain != null)
        {
            gvCertificates.DataSource = dtMain;
            gvCertificates.DataBind();


        }
        else
        {
         //   utility.DisplayMessage(MessageType.Failure, "No Records Found", lblMessage);

        }
    }
}
