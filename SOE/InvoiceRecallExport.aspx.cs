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

public partial class InvoiceRecallExport : System.Web.UI.Page
{
    Utility utility = new Utility();
    InvoiceReCall invoiceCall = new InvoiceReCall();
    
    string whereClause = "";
    string NOInvoice = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        NOInvoice = txtInvoiceNumber.Text = Request.QueryString["InvoiceNo"].ToString();
        whereClause =Request.QueryString["WhereClause"].ToString();
        whereClause = whereClause.Replace("|", ",").Replace("`", "'");
        if (!IsPostBack)
        {            
            BindData();
            BindGrid(whereClause);
        }
     
        upnlBillInfo.Update();
        upnlInvoiceGrid.Update();
    }

    private void BindData()
    {

        DataTable dtInvoice = invoiceCall.GetBillTo(NOInvoice.Trim());


        if (dtInvoice != null && dtInvoice.Rows.Count > 0)
        {

            lblBillCustName.Text = dtInvoice.Rows[0]["CustName"].ToString();
            lblBillCustNo.Text = dtInvoice.Rows[0]["CustNo"].ToString();
            lblBillToFax.Text = dtInvoice.Rows[0]["FaxPhoneNo"].ToString();
            lblCustCom.Visible = ((lblBillCustNo.Text.Trim() != "" && lblBillToFax.Text.Trim() != "") ? true : false);
            lblBillToMail.Text = dtInvoice.Rows[0]["Email"].ToString();

            
            hidCust.Value = lblBillCustNo.Text;

            //if (IsPostBack)
            //{
            //    txtInvoiceNumber.Text = " ";
            //}
        }

       
       
        upnlBillInfo.Update();
        upnlInvoiceGrid.Update();
    }
    private void BindGrid(string whereClause)
    {
        if (hidCust.Value == "")
            hidCust.Value = lblBillCustNo.Text;
        if (hidCust.Value.Trim() == lblBillCustNo.Text.Trim())
        {
            //whereClause = "";
            DataTable dtInvoiceGrid = invoiceCall.GetInvoice(whereClause);

            gvInvoice.DataSource = dtInvoiceGrid;
            gvInvoice.DataBind();
         
        }
       }
    protected void txtInvoiceNumber_TextChanged(object sender, EventArgs e)
    {

        NOInvoice = txtInvoiceNumber.Text;
        //Session["Invoice"] += txtInvoiceNumber.Text + "|";
      //  string invoiceNo = CreateTable();
       // whereClause = "InvoiceNo in ( " + invoiceNo + " )";
        BindData();

    }
    
    

   

    protected void gvInvoice_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "BindInvoice")
        {
           
            //LinkButton lnk = e.CommandSource as LinkButton;
            //string invoice = lnk.Text;
            //lnk.Attributes.Add("onclick", "javascript:OpenInvoice('"+invoice +"');");
        }
    }
}


