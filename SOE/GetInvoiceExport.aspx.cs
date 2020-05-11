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
using PFC.SOE.Enums;


public partial class GetInvoicePDF : System.Web.UI.Page
{
    string noRecordMessage = "No Records Found";
    string queryMessage = "Query Completed Successfully";

    DataTable dtInvoice = new DataTable();

    InvoiceReCall invoiceCall =new InvoiceReCall();
    Utility utility = new Utility();

    protected void Page_Load(object sender, EventArgs e)
    {
        txtInvoiceNumber.Text = Request.QueryString["InvoiceNo"].ToString();

        if (!Page.IsPostBack)
        {
            BindGrid();
        }
        
    }
    private void BindGrid()
    {
        dtInvoice = invoiceCall.GetCertImagesFromTifImage(Session["RecallImgURL"].ToString());
        //dtInvoice = Session["Invoiceinfo"] as DataTable;
        if (dtInvoice != null)
        {
            gvCertificates.DataSource = dtInvoice;
            gvCertificates.DataBind();

           
        }
        else
        {
            utility.DisplayMessage(MessageType.Failure, "No Records Found", lblMessage);
            
        }
    }
}
