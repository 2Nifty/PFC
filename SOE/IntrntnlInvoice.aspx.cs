using System;
using System.Collections.Specialized;
using System.Data;
using System.Data.SqlClient;
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

public partial class IntrntnlInvoice : Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            OrderIDHidden.Value = "";
            //DocTitleLabel.Text = "INTERNATIONAL INVOICE";
            DocType.Value = "INTERNATIONAL INVOICE";
            LineSort.Value = "E";
            HeaderTable.Value = "SOHeaderRel";
            PrintUpdatePanel.Visible = false;
            IntrntnlInvoiceScriptManager.SetFocus("SONumberTextBox");
        }
        else
        {
        }
    }

    protected void GetDocument(string SONo)
    {
        try
        {
            OrderIDHidden.Value = SONo.Replace("W", "");
            PrintUpdatePanel.Visible = false; 
            ClearPageMessages();
            CustNameLabel.Text = "";
            OrderDateLabel.Text = "";
            // get the data.
            // get the order data.
            ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetDoc",
                new SqlParameter("@DocNumber", OrderIDHidden.Value),
                new SqlParameter("@SortCode", LineSort.Value),
                new SqlParameter("@HeaderTable", HeaderTable.Value));
            if (ds.Tables.Count > 1)
            {
                // ds[1] = header, [2] = lines, [3]=expenses, [4]=comments
                dt = ds.Tables[1];
                //show the customer
                CustNameLabel.Text = dt.Rows[0]["ShipToName"].ToString() + " - " +
                    dt.Rows[0]["City"].ToString() + " " + dt.Rows[0]["State"].ToString() + " " + dt.Rows[0]["Country"].ToString();
                OrderDateLabel.Text = dt.Rows[0]["OrderDt"].ToString();
                // get ready to print
                PrintUpdatePanel.Visible = true;
                Print.PageTitle = "International Invoice for " + OrderIDHidden.Value;
                //string RecallURL = "QuoteRecallExport.aspx?CustNo=" + CustNoTextBox.Text;
                string PrintURL = "SOExport.aspx?OrderNo=" + OrderIDHidden.Value
                    + "&DocType=InternationalInvoice&Header=SOHeaderRel";
                Print.PageTitle = "International Invoice " + OrderIDHidden.Value;
                // we build a url according to what serach criterai they have entered. we may even sho line detail
                Print.PageUrl = PrintURL;
                PrintUpdatePanel.Update();
                //ShowPageMessage(RecallURL, 0);
            }
            else
            {
                ShowPageMessage("Document " + SONo + " not found.", 2);

            }
        }
        catch (Exception e2)
        {
            ShowPageMessage("pSOEGetDoc Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    protected void Search(object sender, EventArgs e)
    {
        if (SONumberTextBox.Text.Trim().Length == 0)
        {
            ShowPageMessage("You must enter a Released Order number. ", 2);
            MessageUpdatePanel.Update();
        }
        else
        {
            // get the document
            GetDocument(SONumberTextBox.Text);
        }
    }

    protected void ClearPageMessages()
    {
        MessageLabel.Text = "";
        MessageUpdatePanel.Update();
    }
    
    protected void ShowPageMessage(string PageMessage, int MessageType)
    {
        switch (MessageType)
        {
            case 1:
                MessageLabel.CssClass = "warn";
                break;
            case 2:
                MessageLabel.CssClass = "error";
                break;
            default:
                MessageLabel.CssClass = "success";
                break;
        }
        //MessageLabel.CssClass = "error";
        MessageLabel.Text = PageMessage;
        MessageUpdatePanel.Update();
    }

}
