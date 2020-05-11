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
using PFC.SOE.Enums;


public partial class PrintInvoice : System.Web.UI.Page
{
    string orderNo;
    string tableName;
    string invoiceFileName;
    string invoiceNo;
    SelectPrintInvoice printInvoice = new SelectPrintInvoice();

    

    protected void Page_Load(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        invoiceFileName = "PrintInvoice_" + HttpContext.Current.Session.SessionID.ToString() + ".jpg";
        MyScript.SetFocus(txtOrderNo);
        upnlMessage.Update();
        upnlSearch.Update();
        
    }

    
    protected void txtOrderNo_TextChanged(object sender, EventArgs e)
    {
        string invoiceNo = "";
        string orderNo = txtOrderNo.Text.ToLower().Replace("w", "");

        string whereClause = txtOrderNo.Text.ToLower().Contains("w") ? "OrderRelNo=" + orderNo + "" : "OrderNo='" + orderNo + "'";

        DataTable dtOrder = printInvoice.GetInvoice(whereClause);

        if (dtOrder != null && dtOrder.Rows.Count > 0)
        {
            if (dtOrder.Rows.Count == 1)
            {
                invoiceNo = dtOrder.Rows[0]["InvoiceNo"].ToString();                

                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "Invoice", "GetInvoice('" + invoiceNo + "');", true);
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "AvailableInvoice", "AvailInvoice('" + orderNo + "');", true);
            }

        }
        // added by Slater for WO 1540
        else
        {
            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "NoShipper", "alert('Invoice is unavailable for this document');", true);
        }

        upnlSearch.Update();

        //orderNo = txtOrderNo.Text;
        //DataTable dtOrder = printInvoice.GetInvoice(orderNo );

        //if (dtOrder != null && dtOrder.Rows.Count > 0)
        //{
        //    if (dtOrder.Rows.Count == 1)
        //    {
        //        invoiceNo = dtOrder.Rows[0]["InvoiceNo"].ToString();
        //        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "Invoice", "GetInvoice('" + invoiceNo + "');", true);
        //    }
        //    else
        //    {
        //        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "AvailableInvoice", "AvailInvoice('"+orderNo+"');", true);
        //    }
        //}

        //upnlSearch.Update();
    }

    protected void btnOrder_Click(object sender, EventArgs e)
    {

        string invoiceNo = "";
        string orderNo = txtOrderNo.Text.ToLower().Replace("w", "");

        string whereClause = txtOrderNo.Text.ToLower().Contains("w") ? "OrderRelNo=" + orderNo + "" : "OrderNo='" + orderNo + "'";

        DataTable dtOrder = printInvoice.GetInvoice(whereClause);

        if (dtOrder != null && dtOrder.Rows.Count > 0)
        {
            if (dtOrder.Rows.Count == 1)
            {
                invoiceNo = dtOrder.Rows[0]["InvoiceNo"].ToString();

                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "Invoice", "GetInvoice('" + invoiceNo + "');", true);
            }
            else
            {
                ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "AvailableInvoice", "AvailInvoice('" + orderNo + "');", true);
            }

        }
        // added by Slater for WO 1540
        else
        {
            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "NoShipper", "alert('Invoice is unavailable for this document');", true);
        }

        upnlMessage.Update();
        upnlSearch.Update();

        //orderNo = txtOrderNo.Text;
        //tableName ="";
        //DataTable dtOrder = printInvoice.GetInvoice(orderNo);

        //if (dtOrder != null && dtOrder.Rows.Count > 0)
        //{
        //    if (dtOrder.Rows.Count == 1)
        //    {
        //        invoiceNo = dtOrder.Rows[0]["InvoiceNo"].ToString();
        //        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "Invoice", "GetInvoice('" + invoiceNo + "');", true);
        //        lblMessage.Text = "";

        //    }
        //    else
        //    {
        //        lblMessage.Text = "";
        //        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "AvailableInvoice", "AvailInvoice('" + orderNo + "');", true);
        //    }

        //}
        //else
        //{
        //    lblMessage.Text = "No records found";
        //    lblMessage.ForeColor = System.Drawing.Color.Red;
        //    //printInvoice.DisplayMessage(MessageType.Failure, "No Records found",lblMessage);

        //}
        //upnlMessage.Update();
        //upnlSearch.Update();

    }

    protected void btnInvoice_Click(object sender, EventArgs e)
    {
        invoiceNo = txtInvoiceNumber.Text;
        ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "Invoice", "GetInvoice('" + invoiceNo + "');", true);

    }
    protected void btnSearch_Click(object sender, ImageClickEventArgs e)
    {
       
       if (txtOrderNo.Text != "")
        {
            orderNo =  txtOrderNo.Text.ToLower().Replace("w", "");
            string whereClause = txtOrderNo.Text.Trim().ToLower().Contains("w") ? "OrderRelNo=" + orderNo +"" : "OrderNo='" + orderNo+"'";
           
            DataTable dtOrder = printInvoice.GetInvoice(whereClause);

            if (dtOrder != null && dtOrder.Rows.Count > 0)
            {
                if (dtOrder.Rows.Count == 1)
                {
                    invoiceNo = dtOrder.Rows[0]["InvoiceNo"].ToString();
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "Invoice", "GetInvoice('" + invoiceNo + "');", true);
                    lblMessage.Text = "";

                }
                else
                {
                    lblMessage.Text = "";
                    ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "AvailableInvoice", "AvailInvoice('" + txtOrderNo.Text.Trim().ToUpper() + "');", true);
                }

            }
            else 
            {
                lblMessage.Text = "No records found";
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
            txtOrderNo.Text = "";
            upnlMessage.Update();
            upnlSearch.Update();
        }
        else if (txtInvoiceNumber.Text != "")
        {
            invoiceNo = txtInvoiceNumber.Text;
            txtInvoiceNumber.Text = "";
            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "Invoice", "GetInvoice('" + invoiceNo + "');", true);
           
        }
        else
        {

            lblMessage.Text = "Enter Sales OrderNo or Invoice No to search";
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }
    }
}
