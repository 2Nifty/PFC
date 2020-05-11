using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;


public partial class AvailableShipper : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (Request.QueryString["DocType"] != null)
            {
                DocType.Value = Request.QueryString["DocType"].ToString();
                if (DocType.Value.ToString() == "Invoice")
                {
                    lblParentMenuName.Text = "INVOICE REPRINT";
                    DocPromptLabel.Text = "Invoice";
                }
                if (DocType.Value.ToString() == "Credit")
                {
                    lblParentMenuName.Text = "CREDIT MEMO REPRINT";
                    DocPromptLabel.Text = "Credit Memo";
                }
                if (DocType.Value.ToString() == "RGR")
                {
                    lblParentMenuName.Text = "RETURN RECEIPT REPRINT";
                    DocPromptLabel.Text = "Return Receipt";
                }
            }
            LineSort.Value = "E";
            HeaderTable.Value = "SOHeaderHist";
            PreviewPanel.Visible = false;
        }
        DocViewerScriptManager.SetFocus("SONumberTextBox");
    }

    protected void Search(object sender, EventArgs e)
    {
        PreviewPanel.Visible = false;
        if (SONumberTextBox.Text.Trim().Length == 0)
        {
            ShowPageMessage("You must enter a Released Document number. ", 2);
            MessageUpdatePanel.Update();
        }
        else
        {
            // get the document
            GetOrder(SONumberTextBox.Text);
        }
    }

    protected void GetOrder(string SONo)
    {
        // Get the document
        ClearPageMessages();
        OrderIDHidden.Value = SONo.ToUpper().Replace("W", "");
        try
        {
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
                PreviewPanel.Visible = true;
            }
            else
            {
                ShowPageMessage("Document " + SONumberTextBox.Text + " not found.", 2);

            }
        }
        catch (SqlException ex1)
        {
            ShowPageMessage("Error in pSOEGetDoc " + ex1.Message + ", " + ex1.Number.ToString() + ", " + ex1.LineNumber.ToString(), 2);
        }
    }

    #region Page Messages
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

    protected void ClearPageMessages()
    {
        MessageLabel.Text = "";
        MessageUpdatePanel.Update();
    }
    #endregion


}
