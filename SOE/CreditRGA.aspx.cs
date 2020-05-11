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

public partial class CreditRGA : Page
{
    OrderEntry orderEntry = new OrderEntry();
    CustomerDetail custDet = new CustomerDetail();
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataTable dtCredits = new DataTable();
    DataRow creditrow;
    private string searchFieldCaption = "Order #,Quote Date,Total Weight,Total Amount,PFC Item,Cust. Item";
    private string searchColumnName = "QuoteNumber,QuotationDate,TotalWeight,TotalAmount,PFCItemNo,UserItemNo";
    private string OrderTypeSelect = " ListDetail.ListValue, ListDetail.ListDtlDesc FROM ListMaster with (NOLOCK) " +
        "INNER JOIN ListDetail with (NOLOCK) ON ListMaster.pListMasterID = ListDetail.fListMasterID " +
        "where (ListMaster.ListName = 'soeordertypes') AND ((ListDetail.ListValue = 'PRGA') or (ListDetail.ListValue = 'PCR'))";
    private string ReasonSelect = " TableCd AS ReasonCode, ShortDsc AS ReasonDesc " +
        "FROM Tables with (NOLOCK) " +
        "WHERE (TableType = 'REAS') AND (ISNUMERIC(TableCd) = 0) " +
        "ORDER BY TableType, TableCd";
    string DateToGet;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            OrderIDHidden.Value = "";
            Session["CreditDetailTable"] = null;
            NameValueCollection coll = Request.QueryString;
            if (coll["InvoiceNo"] != null)
            {
                //get invoice
                //http://10.1.36.34/SOE/packingandplating.aspx?ItemNumber=00200-2400-021&ShipLoc=10&RequestedQty=5&AltQty=50&AvailableQty=33
                InvoiceNoTextBox.Text = coll["InvoiceNo"].ToString();
                GetDocument(coll["InvoiceNo"].ToString(), "");
            }
            else
            {
                CreditRGAScriptManager.SetFocus("InvoiceNoTextBox");

            }
            // Call the function to fill the search bar
            BindOrderTypes();
            BindReasons();
            RGAReturnToDropDown.DataSource = custDet.GetLocationDetails();
            RGAReturnToDropDown.DataBind();
            MakeCreditButt.Visible = false;
            MakeRGAButt.Visible = false;
            RGAReturnToLabel.Visible = false;
            RGAReturnToDropDown.Visible = false;
        }
        else
        {
        }
       
    }

    protected void GetDocument(string InvoiceNo, string SONo)
    {
        try
        {
            OrderIDHidden.Value = "";
            Session["CreditDetailTable"] = null;
            ClearPageMessages();
            // get the data.
            ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetCreditRGA",
                new SqlParameter("@PassedInvoice", InvoiceNo),
                new SqlParameter("@PassedOrder", SONo));
            if (ds.Tables.Count >= 1)
            {
                if (ds.Tables.Count == 1)
                {
                    // We only go one table back, something is wrong
                    dt = ds.Tables[0];
                    if (dt.Rows[0]["ErrorType"].ToString().Trim() + dt.Rows[0]["ErrorCode"].ToString() == "E0081")
                    {
                        ShowPageMessage("Document is on file but is the wrong type", 2);
                        CreditRGAScriptManager.SetFocus("InvoiceNoTextBox");
                        return;
                    }
                    if (dt.Rows[0]["ErrorType"].ToString().Trim() + dt.Rows[0]["ErrorCode"].ToString() == "E0001")
                    {
                        ShowPageMessage("Document not found. " + InvoiceNo + "," + SONo, 2);
                        CreditRGAScriptManager.SetFocus("InvoiceNoTextBox");
                        return;
                    }
                    if (dt.Rows.Count > 0)
                    {
                        ShowPageMessage("GetCreditRGA processing error. " + InvoiceNo + "," + SONo, 2);
                        return;
                    }
                }
                else
                {
                    dt = ds.Tables[1];
                    if (dt.Rows.Count == 0)
                    {
                        HeaderGridView.DataBind();
                        HeaderUpdatePanel.Update();
                        DetailGridView.DataBind();
                        DetailUpdatePanel.Update();
                        ShowPageMessage("Invoice/Order not found.", 2);
                        CreditRGAScriptManager.SetFocus("InvoiceNoTextBox");
                    }
                    else
                    {
                        DetailGridView.DataSource = dt;
                        DetailGridView.DataBind();
                        Session["CreditDetailTable"] = dt;
                        OrderIDHidden.Value = ds.Tables[2].Rows[0]["FoundID"].ToString().Trim();
                        ShipLocHidden.Value = ds.Tables[2].Rows[0]["ShipLoc"].ToString().Trim();
                        try
                        {
                            RGAReturnToDropDown.SelectedValue = ShipLocHidden.Value.ToString();
                        }
                        catch
                        {
                        }
                        ShowMakeButton();
                        DetailUpdatePanel.Update();
                        dt = ds.Tables[2];
                        HeaderGridView.DataSource = dt;
                        HeaderGridView.DataBind();
                        HeaderUpdatePanel.Update();
                    }
                }
            }
            ScriptManager.RegisterClientScriptBlock(InvoiceNoTextBox, InvoiceNoTextBox.GetType(), "SizeUpdate", "SetHeight();", true);
        }
        catch (Exception e2)
        {
            ShowPageMessage("GetCreditRGA Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    protected void ShowMakeButton()
    {
        MakeCreditButt.Visible = false;
        MakeRGAButt.Visible = false;
        RGAReturnToLabel.Visible = false;
        RGAReturnToDropDown.Visible = false;
        if (OrderIDHidden.Value.ToString() != "")
        {
            switch (OrderTypeDropDownList.SelectedItem.Value.ToString())
            {
                case "PRGA":
                    MakeRGAButt.Visible = true;
                    RGAReturnToLabel.Visible = true;
                    RGAReturnToDropDown.Visible = true;
                    break;
                case "PCR":
                    MakeCreditButt.Visible = true;
                    break;
            }
            DetailUpdatePanel.Update();
        }
    }

    public void OrderType_Changed(Object sender, EventArgs e)
    {
        ShowMakeButton();
    }

    protected void Search(object sender, EventArgs e)
    {
        if (InvoiceNoTextBox.Text.Trim().Length == 0 && SONumberTextBox.Text.Trim().Length == 0)
        {
            ShowPageMessage("You must enter either an Invoice or Sales Order number. ", 2);
            MessageUpdatePanel.Update();
        }
        else
        {
            // get the document
            GetDocument(InvoiceNoTextBox.Text, SONumberTextBox.Text);
        }
    }

    protected void MakeOrder_Click(object sender, EventArgs e)
    {
        ClearPageMessages();
        int CheckedCount = 0;
        string SelectedDoc = "";
        try
        {
            foreach (TableRow tr in DetailGridView.Rows)
            {
                CheckBox LineChecked = (CheckBox)tr.Cells[0].Controls[1];
                HiddenField LineNo = (HiddenField)tr.Cells[0].Controls[3];
                if (LineChecked.Checked)
                {
                    // update the line to be made
                    SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "UGEN_SP_Update",
                        new SqlParameter("@tableName", "SODetailHist"),
                        new SqlParameter("@columnNames", "StatusCd='MC'"),
                        new SqlParameter("@whereClause", "fSOHeaderHistID=" + OrderIDHidden.Value + " and LineNumber=" + LineNo.Value));
                    CheckedCount++;
                }
            }
            if (CheckedCount == 0)
            {
                ShowPageMessage("Check the check box to the left of the invoice line to add that line to the credit. ", 2);
            }
            else
            {
                // Make a document.
                ds = SqlHelper.ExecuteDataset(connectionString, "pSOEMakeCrRgaFromInv",
                    new SqlParameter("@InvoiceID", OrderIDHidden.Value.ToString()),
                    new SqlParameter("@DocType", OrderTypeDropDownList.SelectedItem.Value.ToString()),
                    new SqlParameter("@ReasonCode", ReasonCodeDropDownList.SelectedItem.Value.ToString()),
                    new SqlParameter("@ShipLoc", RGAReturnToDropDown.SelectedItem.Value.ToString()),
                    new SqlParameter("@EntryID", Session["UserName"].ToString()));
                if (ds.Tables.Count >= 1)
                {
                    if (ds.Tables.Count == 1)
                    {
                        // We only go one table back, something is wrong
                        dt = ds.Tables[0];
                        if (dt.Rows.Count > 0)
                        {
                            ShowPageMessage("Make Document problem. ", 2);
                        }
                    }
                    else
                    {
                        // 2 softlock tables, error stat, then order no
                        dt = ds.Tables[3];
                        if (dt.Rows.Count == 0)
                        {
                            ShowPageMessage("Make Document problem. ", 2);
                        }
                        else
                        {
                            ShowPageMessage("Created Order number <A HREF='javascript:ShowDoc(\"" + dt.Rows[0]["NewOrders"].ToString() + "\" );' >" + dt.Rows[0]["NewOrders"] + "</A>", 0);
                            //orderEntry.OrderLock("LOCK", dt.Rows[0]["NewOrderNo"].ToString());
                        }
                    }
                }
            }
        }
        catch (Exception e2)
        {
            ShowPageMessage("MakeCreditRGA Error " + e2.Message + ", " + e2.ToString(), 2);
        }
        //ScriptManager.RegisterClientScriptBlock(InvoiceNoTextBox, InvoiceNoTextBox.GetType(), "SizeUpdate", "SetHeight();", true);
    }

    public void SortDetailGrid(Object sender, GridViewSortEventArgs e)
    {
        // Create a DataView from the Credit Detail DataTable.
        DataView dv = new DataView((DataTable)Session["CreditDetailTable"]);
        dv.Sort = e.SortExpression;
        DetailGridView.DataSource = dv;
        DetailGridView.DataBind();
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


    /// <summary>
    /// BindOrderTypes : Put the Credit/RGA order type into the drop doen list
    /// </summary>
    private void BindOrderTypes()
    {
        DataSet ds = (DataSet)SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
               new SqlParameter("@tableName", ""),
               new SqlParameter("@columnNames", OrderTypeSelect),
               new SqlParameter("@whereClause", ""));
        // Load the ddl
        OrderTypeDropDownList.DataSource = ds.Tables[0];
        OrderTypeDropDownList.DataBind();
    }

    /// <summary>
    /// BindReasons : Put the reasons into the drop doen list
    /// </summary>
    private void BindReasons()
    {
        DataSet ds = (DataSet)SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
               new SqlParameter("@tableName", ""),
               new SqlParameter("@columnNames", ReasonSelect),
               new SqlParameter("@whereClause", ""));
        // Load the ddl
        ReasonCodeDropDownList.DataSource = ds.Tables[0];
        ReasonCodeDropDownList.DataBind();
    }

}
