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

public partial class QuoteRecall : Page
{
    OrderEntry orderEntry = new OrderEntry();
    CustomerDetail custDet = new CustomerDetail();
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataRow quoterow;
    private string searchFieldCaption = "Order #,Quote Date,Total Weight,Total Amount,PFC Item,Cust. Item";
    private string searchColumnName = "QuoteNumber,QuotationDate,TotalWeight,TotalAmount,PFCItemNo,UserItemNo";
    string DateToGet;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session["ReviewQuotation"] = null;
            Session["dtPrint"] = null;
            QuoteNoHidden.Value = "";
            DetailPanel.Visible = false;
            NameValueCollection coll = Request.QueryString;
            if (coll["CustNo"] != null)
            {
                //get bill to
                //http://10.1.36.34/SOE/QuoteRecallExport.aspx?CustomerNumber=004401
                //http://10.1.36.34/SOE/QuoteRecallExport.aspx?CustNo=004401&QuoteDate=03/23/2009&QuoteNo=09823
                CustNoTextBox.Text = coll["CustNo"].ToString();
                GetQuotes(coll["CustNo"].ToString(), "", "", "Header");
                if (coll["QuoteDate"] != null && coll["QuoteDate"].ToString().Length >6)
                {
                    DateToGet = coll["QuoteDate"];
                    SearchColumn.Text = "Quote Date:";
                    txtSearchText.Text = coll["QuoteDate"];
                    FillGridView(dt);
                }
                if (coll["PFCItemNo"] != null)
                {
                    SearchColumn.Text = "PFC Item Number:";
                    txtSearchText.Text = coll["PFCItemNo"];
                    FillGridView(dt);
                }
                if (coll["QuoteNo"] != null)
                {
                    SearchColumn.Text = "Quote Number:";
                    txtSearchText.Text = coll["QuoteNo"];
                    DetailPanel.Visible = true;
                    GetQuotes(Server.HtmlDecode(CustNoTextBox.Text), "QuoteNumber", Server.HtmlDecode(txtSearchText.Text), "Detail");
                    object sumObject = dt.Compute("Sum(LineWeight)", "1 = 1");
                    ExtendedWeightLabel.Text = string.Format("{0:####,###,##0.00} LBS", sumObject);
                }
            }
        }
    }

    protected void GetQuotes(string CustNo, string FilterField, string FilterValue, string GridToFill)
    {
        try
        {
            // get the quote data.
            string FreshQOH = "0";
            if (GridToFill == "Detail") FreshQOH = "1";
            ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetQuotes",
                new SqlParameter("@Organization", CustNo),
                new SqlParameter("@QuoteFilterField", FilterField),
                new SqlParameter("@QuoteFilterValue", FilterValue),
                new SqlParameter("@FreshQOH", FreshQOH));
            if (ds.Tables.Count >= 1)
            {
                dt = ds.Tables[1];
                if (dt.Rows.Count == 0)
                {
                    DateGridView.DataBind();
                    DetailGridView.DataBind();
                    QuoteGridView.DataBind();
                    FilterShowingLabel.Text = "";
                }
                else
                {
                    if (GridToFill == "Header")
                    {
                        DataTable dtDates = new DataTable();
                        dtDates.Columns.Add("QuoteDate", typeof(DateTime));
                        dtDates.Columns.Add("QuoteCount", typeof(int));
                        int DateCtr = 0;
                        string Lastdate = "";
                        string Newdate = "";
                        string LastQuote = "";
                        string NewQuote = "";
                        DataRow daterow;
                        CustNameLabel.Text = dt.Rows[0]["CustomerName"].ToString();
                        Session["MasterTable"] = dt;
                        Lastdate = string.Format("{0:yyyy-MM-dd}", dt.Rows[0]["QuotationDate"]);
                        DateToGet = string.Format("{0:MM/dd/yyyy}", dt.Rows[0]["QuotationDate"]);
                        foreach (DataRow drow in dt.Rows)
                        {
                            Newdate = string.Format("{0:yyyy-MM-dd}", drow["QuotationDate"]);
                            NewQuote = drow["SessionID"].ToString();
                            if (Newdate != Lastdate)
                            {
                                daterow = dtDates.NewRow();
                                daterow["QuoteDate"] = Lastdate;
                                daterow["QuoteCount"] = DateCtr;
                                dtDates.Rows.Add(daterow);
                                Lastdate = Newdate;
                                DateCtr = 0;
                            }
                            if (NewQuote != LastQuote)
                            {
                                DateCtr++;
                                LastQuote = NewQuote;
                            }
                        }
                        daterow = dtDates.NewRow();
                        daterow["QuoteDate"] = Newdate;
                        daterow["QuoteCount"] = DateCtr;
                        dtDates.Rows.Add(daterow);
                        DateGridView.DataSource = dtDates;
                        DateGridView.DataBind();
                        FillGridView(dt);
                        DetailGridView.DataBind();
                    }
                    if (GridToFill == "Detail")
                    {
                        DetailGridView.DataSource = dt;
                        DetailGridView.DataBind();
                    }
                    //QuoteUpdatePanel.Update();
                    //DataView dv = new DataView(dt, "SubItem = '" + ItemNo + "'", "", DataViewRowState.CurrentRows);
                    //AltAvailLabel.Text = String.Format("{0:#,##0}", dv[0]["AltQOH"]);
                }
            }
        }
        catch (Exception e2)
        {
            ErrorLabel.Text = e2.Message + ", " + e2.ToString();
        }
    }

    protected void FillGridView(DataTable Quotes)
    {
        DataTable dtQuotes = new DataTable();
        try
        {
            string filter = "";
            switch (SearchColumn.Text)
            {
                case "PFCItemNo":
                case "UserItemNo":
                    if (SearchColumn.Text == "PFCItemNo")
                    {
                        FilterShowingLabel.Text = " PFC Item = " + txtSearchText.Text;
                        filter = "PFCItemNo = '" + txtSearchText.Text + "'";
                    }
                    else
                    {
                        FilterShowingLabel.Text = " Customer Item = " + txtSearchText.Text;
                        filter = "UserItemNo = '" + txtSearchText.Text + "'";
                    }
                    DataView dvItems = new DataView(Quotes, filter, "", DataViewRowState.CurrentRows);
                    dtQuotes.Columns.Add("Quote", typeof(string));
                    dtQuotes.Columns.Add("QuoteDate", typeof(DateTime));
                    dtQuotes.Columns.Add("QuoteQty", typeof(int));
                    dtQuotes.Columns.Add("QuotePrice", typeof(decimal));
                    dtQuotes.Columns.Add("QuoteAmount", typeof(decimal));
                    dtQuotes.Columns.Add("Status", typeof(string));
                    for (int i = 0; i < dvItems.Count; i++)
                    {
                        quoterow = dtQuotes.NewRow();
                        quoterow["Quote"] = dvItems[i]["SessionID"].ToString();
                        quoterow["QuoteDate"] = dvItems[i]["QuotationDate"];
                        quoterow["QuoteQty"] = dvItems[i]["RequestQuantity"];
                        quoterow["QuoteAmount"] = dvItems[i]["TotalPrice"];
                        quoterow["QuotePrice"] = dvItems[i]["UnitPrice"];
                        dtQuotes.Rows.Add(quoterow);
                    }
                    ItemGridView.DataSource = dtQuotes;
                    ItemGridView.DataBind();
                    ItemGridView.Visible = true;
                    QuoteGridView.Visible = false;
                    break;
                default:
                    FilterShowingLabel.Text = DateToGet;
                    filter = "QuotationDate = #" + FilterShowingLabel.Text + "#";
                    //filter = "QuotationDate = #03/05/2009#";
                    DataView dv = new DataView(Quotes, filter, "", DataViewRowState.CurrentRows);
                    dtQuotes.Columns.Add("Quote", typeof(string));
                    dtQuotes.Columns.Add("QuoteLines", typeof(int));
                    dtQuotes.Columns.Add("QuoteWeight", typeof(decimal));
                    dtQuotes.Columns.Add("QuoteAmount", typeof(decimal));
                    dtQuotes.Columns.Add("Status", typeof(string));
                    int LineCtr = 0;
                    decimal QuoteAmt = 0;
                    decimal QuoteWght = 0;
                    string LastQuote = "";
                    string NewQuote = "";
                    for (int i = 0; i < dv.Count; i++)
                    {
                        NewQuote = dv[i]["SessionID"].ToString();
                        if (NewQuote != LastQuote)
                        {
                            if (LastQuote != "")
                            {
                                quoterow = dtQuotes.NewRow();
                                quoterow["Quote"] = LastQuote;
                                quoterow["QuoteLines"] = LineCtr;
                                quoterow["QuoteAmount"] = QuoteAmt;
                                quoterow["QuoteWeight"] = QuoteWght;
                                dtQuotes.Rows.Add(quoterow);
                                LineCtr = 0;
                                QuoteAmt = 0;
                                QuoteWght = 0;
                            }
                            LastQuote = NewQuote;
                        }
                        LineCtr++;
                        QuoteAmt += (decimal)dv[i]["TotalPrice"];
                        QuoteWght += (decimal)dv[i]["LineWeight"];
                    }
                    quoterow = dtQuotes.NewRow();
                    quoterow["Quote"] = LastQuote;
                    quoterow["QuoteLines"] = LineCtr;
                    quoterow["QuoteAmount"] = QuoteAmt;
                    quoterow["QuoteWeight"] = QuoteWght;
                    dtQuotes.Rows.Add(quoterow);
                    QuoteGridView.DataSource = dtQuotes;
                    QuoteGridView.DataBind();
                    QuoteGridView.Visible = true;
                    ItemGridView.Visible = false;
                    break;
            }
        }
        catch (Exception e2)
        {
            ErrorLabel.Text = e2.Message + ", " + e2.ToString();
        }
    }

    protected void QuoteDaysCommand(Object sender, GridViewCommandEventArgs e)
    {
        // get the day 
        if (e.CommandName == "ShowDay")
        {
            QuoteNoHidden.Value = "";
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = DateGridView.Rows[index];
            DateToGet = Server.HtmlDecode(row.Cells[0].Text);
            FillGridView((DataTable)Session["MasterTable"]);
        }
    }

    protected void QuoteSummCommand(Object sender, GridViewCommandEventArgs e)
    {
        // get the quote
        if (e.CommandName == "ShowDetail")
        {
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = QuoteGridView.Rows[index];
            QuoteNoHidden.Value = Server.HtmlDecode(row.Cells[0].Text);
            GetQuotes(Server.HtmlDecode(CustNoTextBox.Text), "QuoteNumber", Server.HtmlDecode(row.Cells[0].Text), "Detail");
            Session["QuoteDetailTable"] = dt;
        }
        if (e.CommandName == "ShowItemDetail")
        {
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = ItemGridView.Rows[index];
            QuoteNoHidden.Value = Server.HtmlDecode(row.Cells[0].Text);
            GetQuotes(Server.HtmlDecode(CustNoTextBox.Text), "QuoteNumber", Server.HtmlDecode(row.Cells[0].Text), "Detail");
            Session["QuoteDetailTable"] = dt;
        }
    }

    protected void DetailRowBound(Object sender, GridViewRowEventArgs e)
    {
        // show availability link if QOH less than requested
        GridViewRow row = e.Row;
        if (row.RowType == DataControlRowType.DataRow)
        {
            Label QOHLabel = (Label)row.Cells[7].Controls[1];
            LinkButton QOHLink = (LinkButton)row.Cells[7].Controls[3];
            HiddenField QuoteID = (HiddenField)row.Cells[0].Controls[3];
            int ReqQty = int.Parse(Server.HtmlDecode(row.Cells[5].Text.Replace(",", "")));
            int QOH = int.Parse(QOHLabel.Text.Replace(",", ""));
        }
    }

}
