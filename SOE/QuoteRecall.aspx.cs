using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Globalization;
using System.IO;
using System.Text;
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
    DataTable dtQuotes = new DataTable();
    DataRow quoterow;
    int QtyAvailable;
    bool SingleQuoteDetail;
    bool CheckAll;
    bool RemoteRefresh;
    private string searchFieldCaption = "Order #,Quote Date,Total Weight,Total Amount,PFC Item,Cust. Item";
    private string searchColumnName = "QuoteNumber,QuotationDate,TotalWeight,TotalAmount,PFCItemNo,UserItemNo";
    string DateToGet;
    string DatesToGet;
    string QuotesToGet;
    Label QOHLabel;
    Label LocLabel;
    Label PriceUMLabel;
    Label PriceGluedLabel;
    Label ItemLabel;
    Label CarrierCdLabel;
    Label FreightCdLabel;
    LinkButton QOHLink;
    CheckBox LineSelector;
    HiddenField QuoteID;
    HiddenField GridDeleteFlag;
    HiddenField GridMakeDate;
    HiddenField GridMakeBy;
    TextBox PriceBox;
    TextBox ReqQtyBox;
    Label ReqQtyLabel;
    GridViewRow row;
    LinkButton DateSelectButt = new LinkButton();

    protected void Page_Init(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //QuoteNoHidden.Value = "";
            ShowDeletedHidden.Value = "0";
            PrintUpdatePanel.Visible = false;
            CommentsPanel.Visible = false;
            POPanel.Visible = false;
            ExcelExportButton.Visible = false;
            ExcelUpdatePanel.Update();
            RecallPageMode.Value = "Recall";
            HeaderTableName.Value = "QuoteHeaderTable";
            DetailTableName.Value = "QuoteDetailTable";
            //DetailSortField.Value = "QuoteNumber";
            ReviewHeaderPanel.Visible = false;
            SOELink.Value = ConfigurationManager.AppSettings["SOESiteURL"].ToString() +
                            "frame.aspx?Source=Quote&" +
                            "UserID=" + Session["UserID"].ToString() + "&" +
                            "UserName=" + Session["UserName"].ToString();
            ReadOnly.Value = "0";
            if (Request.QueryString["ReadOnly"] != null)
            {
                ReadOnly.Value = "1";
            }
            if (Request.QueryString["Cust"] != null && Request.QueryString["Cust"].ToString().Length > 0)
            {
                //we have been passed a customer so go to town
                CustNoTextBox.Text = Request.QueryString["Cust"].ToString();
                HeaderTableName.Value = "Cust" + CustNoTextBox.Text + "HeaderTable";
                DetailTableName.Value = "Cust" + CustNoTextBox.Text + "DetailTable";

                GetQuotes(Request.QueryString["Cust"].ToString(), "", "", "Header");

                if (Request.QueryString["QuoteNo"] != null && Request.QueryString["QuoteNo"].ToString().Length > 0)
                {
                    DetailFilterFieldHidden.Value = "QuoteNumber";
                    DetailFilterValueHidden.Value = Server.HtmlDecode(Request.QueryString["QuoteNo"].ToString());
                    QuoteNoHidden.Value = DetailFilterValueHidden.Value;
                    AddLineLink.Text = "Add Line to " + QuoteNoHidden.Value;
                    Session[DetailTableName.Value] = null;
                    SingleQuoteDetail = true;
                    CheckAll = false;
                    GetQuotes(CustNoTextBox.Text, "QuoteNumber", Request.QueryString["QuoteNo"].ToString(), "Detail");
                    UpdateWeight();
                    BindPrintDialog();
			 QuoteRecallScriptManager.SetFocus("POTextBox");
                }

                #region Code Commented By Sathish: To display Header & Detail Grid by default

                //if (Request.QueryString["QuoteNo"] != null && Request.QueryString["QuoteNo"].ToString().Length > 0)
                //{
                //    // Here we are reviewing a single quote
                //    RecallPageMode.Value = "Review";
                //    ReviewHeaderPanel.Visible = true;
                //    //HeaderPanel.Visible = false;
                //    DetailPanel.Visible = true;
                //    QuoteNoHidden.Value = Request.QueryString["QuoteNo"].ToString();
                //    ReviewCustNoLabel.Text = CustNoTextBox.Text;
                //    DetailFilterFieldHidden.Value = "QuoteNumber";
                //    DetailFilterValueHidden.Value = QuoteNoHidden.Value;
                //    HeaderTableName.Value = "Quote" + Request.QueryString["QuoteNo"].ToString() + "HeaderTable";
                //    DetailTableName.Value = "Quote" + Request.QueryString["QuoteNo"].ToString() + "ReviewTable";
                //    this.Title = "Quote " + QuoteNoHidden.Value + " Review";
                //    DetailGridHeightHidden.Value = "600";
                //    SingleQuoteDetail = true;
                //    CheckAll = false;
                //    GetQuotes(CustNoTextBox.Text, DetailFilterFieldHidden.Value, DetailFilterValueHidden.Value, "Detail");
                //    if (dt.Rows.Count > 0) ReviewCustNameLabel.Text = dt.Rows[0]["CustomerName"].ToString();
                //    BindPrintDialog();
                //    QuoteRecallScriptManager.SetFocus("POTextBox");
                //}
                //else
                //{
                //    GetQuotes(Request.QueryString["Cust"].ToString(), "", "", "Header");
                //}

                #endregion
            }
            else
            {
                QuoteRecallScriptManager.SetFocus("CustNoTextBox");
            }
            // Call the function to fill the search bar
            BindSearchColumns(searchFieldCaption, searchColumnName, ',');
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // Initializing AJAX.NET Library 
        Ajax.Utility.RegisterTypeForAjax(typeof(QuoteRecall));
    }

    protected void CustNoSubmit_Click(object sender, EventArgs e)
    {
        //ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetQuoteCust",
        //         new SqlParameter("@customer", CustNoTextBox.Text.Trim()));
        //if (ds.Tables.Count == 1)
        //{
        //    // Take the first customer returned
        //    dt = ds.Tables[0];
        //    if (dt.Rows.Count > 0)
        //    {
        //        CustNameLabel.Text = dt.Rows[0]["CustName"].ToString();
        //        HeaderUpdatePanel.Update();
        //        //ShowPageMessage("ShipLoc=" + ShippingBranch.Value.ToString(), 0);
        //        QuoteRecallScriptManager.SetFocus("ddlSearchColumn");
        //        GetQuotes(CustNoTextBox.Text, "", "", "Header");
        //    }
        //    else
        //    {
        //        ShowPageMessage(CustNoTextBox.Text + " Not Found", 2);
        //        QuoteRecallScriptManager.SetFocus("CustNoTextBox");
        //    }
        //}
        //else
        //{
        //    ShowPageMessage(CustNoTextBox.Text + " Not Found", 2);
        //    HeaderUpdatePanel.Update();
        //    QuoteRecallScriptManager.SetFocus("CustNoTextBox");
        //}
    }

    protected void GetQuotes(string CustNo, string FilterField, string FilterValue, string GridToFill)
    {
        try
        {
            ClearPageMessages();
            // get the quote data.
            string FreshQOH = "0";
            // single quote search
            if ((GridToFill == "Header") && (FilterField == "QuoteNumber") && (CustNo.Trim() == "")) FreshQOH = "5";
            if ((GridToFill == "Detail") && (SingleQuoteDetail)) FreshQOH = "5";
            if ((GridToFill == "Detail") && (CheckAll)) FreshQOH = "1";
            ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetQuotes",
                new SqlParameter("@Organization", CustNo),
                new SqlParameter("@QuoteFilterField", FilterField),
                new SqlParameter("@QuoteFilterValue", FilterValue),
                new SqlParameter("@FreshQOH", FreshQOH));
            if (ds.Tables.Count >= 1)
            {
                if (ds.Tables.Count == 1)
                {
                    // We only go one table back, something is wrong
                    dt = ds.Tables[0];
                    if (dt.Rows.Count > 0)
                    {
                        ShowPageMessage("Quote access problem. " + CustNo, 2);
                        MessageUpdatePanel.Update();
                    }
                }
                else
                {
                    dt = ds.Tables[1];
                    if (dt.Rows.Count == 0)
                    {
                        Session[DetailTableName.Value] = null;
                        DateGridView.DataBind();
                        DetailGridView.DataBind();
                        QuoteGridView.DataBind();
                        FilterShowingLabel.Text = "";
                        QuoteDetailUpdatePanel.Update();
                        Session[HeaderTableName.Value] = null;
                        ShowPageMessage("No Quotes on File. Customer " + CustNo + " : " + FilterField + " " + FilterValue, 2);
                        MessageUpdatePanel.Update();
                        QuoteRecallScriptManager.SetFocus("CustNoTextBox");
                    }
                    else
                    {
                        WeightButt.OnClientClick = "OpenAtPos('CustWeight', 'CustWeight.aspx?CustNumber=" + CustNoTextBox.Text + 
                            "', 'toolbar=0,scrollbars=0,status=1,resizable=YES', 0, 0, 400, 600);return false;";  
                        if (GridToFill == "Header")
                        {
                            Session[DetailTableName.Value] = null;
                            DataTable dtDates = new DataTable();
                            dtDates.Columns.Add("QuoteDate", typeof(DateTime));
                            dtDates.Columns.Add("QuoteCount", typeof(int));
                            dtDates.Columns.Add("DateSelected", typeof(Boolean));
                            int DateCtr = 0;
                            string Lastdate = "";
                            string Newdate = "";
                            string LastQuote = "";
                            string NewQuote = "";
                            DataRow daterow;
                            if ((FilterField == "QuoteNumber") && (CustNo.Trim() == ""))
                                CustNoTextBox.Text = dt.Rows[0]["CustomerNumber"].ToString();
                            CustNameLabel.Text = dt.Rows[0]["CustomerName"].ToString();
                            Session[HeaderTableName.Value] = dt;
                            ShowPageMessage(dt.Rows.Count.ToString()+ " Quotes on File", 0);
                            Lastdate = string.Format("{0:yyyy-MM-dd}", dt.Rows[0]["QuotationDate"]);
                            DateToGet = string.Format("{0:MM/dd/yyyy}", dt.Rows[0]["QuotationDate"]);
                            DatesToGet = "";
                            foreach (DataRow drow in dt.Select("DeleteFlag = 0"))
                            {
                                Newdate = string.Format("{0:yyyy-MM-dd}", drow["QuotationDate"]);
                                NewQuote = drow["SessionID"].ToString();
                                if (Newdate != Lastdate)
                                {
                                    daterow = dtDates.NewRow();
                                    daterow["QuoteDate"] = Lastdate;
                                    daterow["QuoteCount"] = DateCtr;
                                    daterow["DateSelected"] = true;
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
                            if (NewQuote != "")
                            {
                                daterow = dtDates.NewRow();
                                daterow["QuoteDate"] = Newdate;
                                daterow["QuoteCount"] = DateCtr;
                                daterow["DateSelected"] = true;
                                dtDates.Rows.Add(daterow);
                            }
                            else
                            {
                                ShowPageMessage("Quote is deleted.", 2);
                            }
                            DateGridView.DataSource = dtDates;
                            DateGridView.DataBind();
                            FillGridView(dt);
                            DetailGridView.DataBind();
                            QuoteDetailUpdatePanel.Update();
                            ExcelExportButton.Visible = false;
                            ExcelUpdatePanel.Update();
                        }
                        if (GridToFill == "Detail")
                        {
                            ShowPageMessage(dt.Rows.Count.ToString() + " Lines found.", 0);
                            DataColumn column = new DataColumn();
                            column.DataType = Type.GetType("System.Boolean");
                            column.ColumnName = "MakeOrder";
                            column.Caption = "MakeOrder";
                            column.ReadOnly = false;
                            column.Unique = false;
                            column.DefaultValue = CheckAll;
                            dt.Columns.Add(column);
                            // reset any make order check boxes
                            if (Session[DetailTableName.Value] != null)
                            {
                                // get the current lines that are selected
                                DataTable tempDt = (DataTable)Session[DetailTableName.Value];
                                DataRow[] CheckedRow = tempDt.Select("MakeOrder");
                                if (CheckedRow.Length > 0)
                                {
                                    for (int cctr = 0; cctr < CheckedRow.Length; cctr++)
                                    {
                                        DataRow[] QuoteRow = dt.Select("QuoteNumber = '" + CheckedRow[cctr]["QuoteNumber"] + "'");
                                        QuoteRow[0]["MakeOrder"] = true;
                                    }
                                }
                            }
                            Session[DetailTableName.Value] = dt;
                            RefreshDetailGrid();
                        }
                        //QuoteUpdatePanel.Update();
                        //DataView dv = new DataView(dt, "SubItem = '" + ItemNo + "'", "", DataViewRowState.CurrentRows);
                        //AltAvailLabel.Text = String.Format("{0:#,##0}", dv[0]["AltQOH"]);
                    }
                }
            }
        }
        catch (Exception e2)
        {
            ShowPageMessage("GetQuote Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    protected void FillGridView(DataTable Quotes)
    {
        string filter = "";
        try
        {
            POPanel.Visible = false;
            DetailGridView.DataBind();
            QuoteDetailUpdatePanel.Update();
            CommentsPanel.Visible = false;
            ExcelExportButton.Visible = false;
            ExcelUpdatePanel.Update();
            switch (ddlSearchColumn.SelectedValue)
            {
                case "PFCItemNo":
                case "UserItemNo":
                    if (ddlSearchColumn.SelectedValue == "PFCItemNo")
                    {
                        FilterShowingLabel.Text = " PFC Item = " + txtSearchText.Text;
                        filter = "PFCItemNo = '" + txtSearchText.Text + "' and DeleteFlag = 0";
                    }
                    else
                    {
                        FilterShowingLabel.Text = " Customer Item = " + txtSearchText.Text;
                        filter = "UserItemNo = '" + txtSearchText.Text + "' and DeleteFlag = 0";
                    }
                    DataView dvItems = new DataView(Quotes, filter, "", DataViewRowState.CurrentRows);
                    if (dtQuotes.Columns.IndexOf("Quote") == -1)
                    {
                        dtQuotes.Columns.Add("Quote", typeof(string));
                        dtQuotes.Columns.Add("QuoteDate", typeof(DateTime));
                        dtQuotes.Columns.Add("QuoteQty", typeof(int));
                        dtQuotes.Columns.Add("QuotePrice", typeof(decimal));
                        dtQuotes.Columns.Add("QuoteAmount", typeof(decimal));
                        dtQuotes.Columns.Add("UserID", typeof(string));
                    }
                    for (int i = 0; i < dvItems.Count; i++)
                    {
                        quoterow = dtQuotes.NewRow();
                        quoterow["Quote"] = dvItems[i]["SessionID"].ToString();
                        quoterow["QuoteDate"] = dvItems[i]["QuotationDate"];
                        quoterow["QuoteQty"] = dvItems[i]["RequestQuantity"];
                        quoterow["QuoteAmount"] = dvItems[i]["TotalPrice"];
                        quoterow["QuotePrice"] = dvItems[i]["UnitPrice"];
                        quoterow["UserID"] = dvItems[i]["UserID"];
                        dtQuotes.Rows.Add(quoterow);
                    }
                    ItemGridView.DataSource = dtQuotes;
                    ItemGridView.DataBind();
                    ItemGridView.Visible = true;
                    QuoteGridView.Visible = false;
                    break;
                default:
                    if (DatesToGet != "")
                    {
                        // we got multiple dates so select them all
                        FilterShowingLabel.Text = DatesToGet;
                        filter = "(";
                        for (int i = 0; i < DatesToGet.Split(',').Length; i++)
                        {
                            if (i > 0)
                            {
                                filter += " or ";
                            }
                            filter += "QuotationDate = #" + DatesToGet.Split(',')[i] + "# ";
                        }
                        filter += ") and DeleteFlag = 0";
                    }
                    if (DateToGet != "")
                    {
                        FilterShowingLabel.Text = DateToGet;
                        filter = "QuotationDate = #" + FilterShowingLabel.Text + "# and DeleteFlag = 0";
                    }
                    DataView dv = new DataView(Quotes, filter, "", DataViewRowState.CurrentRows);
                    if (dtQuotes.Columns.IndexOf("Quote") == -1)
                    {
                        dtQuotes.Columns.Add("Quote", typeof(string));
                        dtQuotes.Columns.Add("QuoteLines", typeof(int));
                        dtQuotes.Columns.Add("QuoteWeight", typeof(decimal));
                        dtQuotes.Columns.Add("QuoteAmount", typeof(decimal));
                        dtQuotes.Columns.Add("QuoteMarginDols", typeof(decimal));
                        dtQuotes.Columns.Add("QuoteMarginPcnt", typeof(decimal));
                        dtQuotes.Columns.Add("UserID", typeof(string));
                    }
                    int LineCtr = 0;
                    decimal QuoteAmt = 0;
                    decimal QuoteMrgn = 0;
                    decimal QuoteWght = 0;
                    string LastQuote = "";
                    string NewQuote = "";
                    string QuoteUser = "";
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
                                quoterow["QuoteMarginDols"] = QuoteMrgn;
                                if (QuoteAmt != 0)
                                {
                                    quoterow["QuoteMarginPcnt"] = QuoteMrgn / QuoteAmt;
                                }
                                else
                                {
                                    quoterow["QuoteMarginPcnt"] = 0;
                                }
                                quoterow["QuoteWeight"] = QuoteWght;
                                quoterow["UserID"] = QuoteUser;
                                dtQuotes.Rows.Add(quoterow);
                                LineCtr = 0;
                                QuoteAmt = 0;
                                QuoteWght = 0;
                                QuoteMrgn = 0;
                            }
                            LastQuote = NewQuote;
                            QuoteUser = dv[i]["UserID"].ToString();
                        }
                        LineCtr++;
                        QuoteAmt += (decimal)dv[i]["TotalPrice"];
                        QuoteMrgn += (decimal)dv[i]["MarginDollars"];
                        QuoteWght += (decimal)dv[i]["LineWeight"];
                    }
                    if (NewQuote != "")
                    {
                        quoterow = dtQuotes.NewRow();
                        quoterow["Quote"] = LastQuote;
                        quoterow["QuoteLines"] = LineCtr;
                        quoterow["QuoteAmount"] = QuoteAmt;
                        quoterow["QuoteMarginDols"] = QuoteMrgn;
                        if (QuoteAmt != 0)
                        {
                            quoterow["QuoteMarginPcnt"] = QuoteMrgn / QuoteAmt;
                        }
                        else
                        {
                            quoterow["QuoteMarginPcnt"] = 0;
                        }
                        quoterow["QuoteWeight"] = QuoteWght;
                        quoterow["UserID"] = QuoteUser;
                        dtQuotes.Rows.Add(quoterow);
                    }
                    QuoteGridView.DataSource = dtQuotes;
                    QuoteGridView.DataBind();
                    QuoteGridView.Visible = true;
                    ItemGridView.Visible = false;
                    break;
            }
            ScriptManager.RegisterClientScriptBlock(txtSearchText, txtSearchText.GetType(), "Find", "SetHeight();", true);
        }
        catch (Exception e2)
        {
            ShowPageMessage("FillGrid Error " + filter + ", " + e2.ToString(), 2);
        }
    }

    protected void RemoteDetailRefresh_Click(object sender, EventArgs e)
    {
        if (DetailFilterFieldHidden.Value.ToString() == "QuoteNumber")
            SingleQuoteDetail = true;
        else
            SingleQuoteDetail = false;
        RemoteRefresh = true;
        CheckAll = false;
        GetQuotes(Server.HtmlDecode(CustNoTextBox.Text), DetailFilterFieldHidden.Value, DetailFilterValueHidden.Value, "Detail");
        UpdateWeight();
        RemoteRefresh = false;
        //ScriptManager.RegisterClientScriptBlock(txtSearchText, txtSearchText.GetType(), "Fix", "closeFixWindow();", true);
    }

    protected void DetailClearAll_Click(object sender, EventArgs e)
    {
        dt = (DataTable)Session[DetailTableName.Value];
        for (int cctr = 0; cctr < dt.Rows.Count; cctr++)
        {
            dt.Rows[cctr]["MakeOrder"] = false;
        }
        Session[DetailTableName.Value] = dt;
        RefreshDetailGrid();
    }

    protected void DetailCheckAll_Click(object sender, EventArgs e)
    {
        CheckAll = true;
        GetQuotes(CustNoTextBox.Text, DetailFilterFieldHidden.Value, DetailFilterValueHidden.Value, "Detail");
    }

    protected void ToggleDeleted_Click(object sender, EventArgs e)
    {
        if (ShowDeletedHidden.Value == "0")
        {
            ShowDeletedHidden.Value = "1";
        }
        else
        {
            ShowDeletedHidden.Value = "0";
        }
        RefreshDetailGrid();
    }

    protected void RefreshDetailGrid()
    {
        DataView lineView = new DataView();
        if (ShowDeletedHidden.Value == "1")
        {
            lineView = new DataView((DataTable)Session[DetailTableName.Value], "1 = 1", "QuoteNumber", DataViewRowState.CurrentRows);
            DeletedLineStateLabel.Text = "Deleted Lines are being Shown";
        }
        else
        {
            lineView = new DataView((DataTable)Session[DetailTableName.Value], "DeleteFlag = 0", "QuoteNumber", DataViewRowState.CurrentRows);
            DeletedLineStateLabel.Text = "Deleted Lines are Hidden";
        }
        if (lineView.Count == 0)
        {
            ShowPageMessage("No Lines to show.", 2);
            MakeOrderButt.Visible = false;
            ExcelExportButton.Visible = false;
            ExcelUpdatePanel.Update();
        }
        else
        {
            DetailGridView.DataSource = lineView;
            MakeOrderButt.Visible = true;
            ExcelExportButton.Visible = true;
            ExcelUpdatePanel.Update();
        }
        if (RemoteRefresh) DetailGridView.PageIndex = DetailGridView.PageCount - 1;
        DetailGridView.DataBind();
        if(DetailGridHeightHidden.Value != "")
            DetailGridPanel.Height = new Unit(double.Parse(DetailGridHeightHidden.Value), UnitType.Pixel);
        QuoteDetailUpdatePanel.Update();
        CommentsPanel.Visible = false;
        DataRow[] foundRows;
        foundRows = lineView.Table.Select("ContactName > ' '");
        if (foundRows.Length > 0)
        {
            ContactLabel.Text = "Contact: " + foundRows[0]["ContactName"].ToString();
        }
        else
        {
            ContactLabel.Text = "No Contact Set for the Quote.";
        }
        POPanel.Visible = true;
        if (ReadOnly.Value == "1")
        {
            MakeOrderButt.Visible = false;
        }
        ScriptManager.RegisterClientScriptBlock(POTextBox, POTextBox.GetType(), "PO", "SetHeight();", true);
    }

    protected void UpdateWeight()
    {
        try
        {
            object sumObject;
            sumObject = dt.Compute("Sum(LineWeight)", "DeleteFlag = 0");
            ExtendedWeightLabel.Text = string.Format("{0:####,###,##0.00} LBS", sumObject);
            // set the next line number
            object lineObject;
            lineObject = dt.Compute("Max(QuoteNumber)", "0 = 0");
            NextLineNo.Value = lineObject.ToString();
            NextLineNo.Value = string.Format("{0:########0}", int.Parse(NextLineNo.Value.ToString().Split('-')[1]) + 10);
        }
        catch (Exception e2)
        {
            ShowPageMessage("UpdateWeight Error " + DetailFilterFieldHidden.Value.ToString() + ", " + e2.ToString(), 2);
        }
    }

    protected void QuoteDaysCommand(Object sender, GridViewCommandEventArgs e)
    {
        ClearPageMessages();
        Session[DetailTableName.Value] = null;
        PrintUpdatePanel.Visible = false;
        // get the day they asked for
        if (e.CommandName == "ShowDay")
        {
            QuoteNoHidden.Value = "";
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = DateGridView.Rows[index];
            DatesToGet = "";
            DateToGet = Server.HtmlDecode(row.Cells[0].Text);
            FillGridView((DataTable)Session[HeaderTableName.Value]);
            ScriptManager.RegisterClientScriptBlock(txtSearchText, txtSearchText.GetType(), "Find", "SetHeight();", true);
        }
        // show all lines for the day in the detail grid
        if (e.CommandName == "ShowLines")
        {
            QuoteNoHidden.Value = "";
            AddLineLink.Text = QuoteNoHidden.Value;
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = DateGridView.Rows[index];
            DatesToGet = "";
            DateToGet = Server.HtmlDecode(row.Cells[0].Text);
            FillGridView((DataTable)Session[HeaderTableName.Value]);
            DetailFilterFieldHidden.Value = "QuotationDate";
            DetailFilterValueHidden.Value = DateToGet;
            SingleQuoteDetail = false;
            CheckAll = false;
            GetQuotes(CustNoTextBox.Text, "QuotationDate", DateToGet, "Detail");
            UpdateWeight();
            ScriptManager.RegisterClientScriptBlock(txtSearchText, txtSearchText.GetType(), "Find", "SetHeight();", true);
        }
        if (e.CommandName == "SelectDays")
        {
            // show all lines for the selected days in the detail grid + dt.Rows.Count.ToString()OnClick="ShowSelectedDaysButt_Click"
            QuoteNoHidden.Value = "";
            AddLineLink.Text = QuoteNoHidden.Value;
            DateToGet = "";
            DatesToGet = "";
            CheckBox DateSelected = new CheckBox();
            try
            {
                foreach (GridViewRow row in DateGridView.Rows)
                {
                    DateSelected = (CheckBox)row.Cells[4].Controls[1];
                    if (DateSelected.Checked)
                    {
                        if (DatesToGet != "") DatesToGet += ",";
                        DatesToGet += Server.HtmlDecode(row.Cells[0].Text);
                    }
                }
                if (DatesToGet.Trim() == "")
                {
                    ShowPageMessage("You must select at least one date", 2);
                }
                else
                {
                    FillGridView((DataTable)Session[HeaderTableName.Value]);
                    HeaderUpdatePanel.Update();
                    DetailFilterFieldHidden.Value = "QuotationDates";
                    DetailFilterValueHidden.Value = DatesToGet;
                    SingleQuoteDetail = false;
                    CheckAll = false;
                    GetQuotes(CustNoTextBox.Text, "QuotationDates", DatesToGet, "Detail");
                    UpdateWeight();
                    ScriptManager.RegisterClientScriptBlock(txtSearchText, txtSearchText.GetType(), "Find", "SetHeight();", true);
                }
            }
            catch (Exception e2)
            {
                ShowPageMessage("ShowSelectedDaysButt_Click Error " + e2.ToString(), 2);
            }
        }
    }

    protected void QuoteSummCommand(Object sender, GridViewCommandEventArgs e)
    {
        ClearPageMessages();
        PrintUpdatePanel.Visible = false;
        // get the one they asked for
        if (e.CommandName == "ShowDetail")
        {
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = QuoteGridView.Rows[index];
            DetailFilterFieldHidden.Value = "QuoteNumber";
            DetailFilterValueHidden.Value = Server.HtmlDecode(row.Cells[0].Text);
            QuoteNoHidden.Value = DetailFilterValueHidden.Value;
            AddLineLink.Text = "Add Line to " + QuoteNoHidden.Value;
            Session[DetailTableName.Value] = null;
            SingleQuoteDetail = true;
            CheckAll = false;
            GetQuotes(Server.HtmlDecode(CustNoTextBox.Text), "QuoteNumber", Server.HtmlDecode(row.Cells[0].Text), "Detail");
            UpdateWeight();
            BindPrintDialog();
        }
        if (e.CommandName == "ShowItemDetail")
        {
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = ItemGridView.Rows[index];
            QuoteNoHidden.Value = Server.HtmlDecode(row.Cells[0].Text);
            DetailFilterFieldHidden.Value = "QuoteNumber";
            DetailFilterValueHidden.Value = Server.HtmlDecode(row.Cells[0].Text);
            QuoteNoHidden.Value = DetailFilterValueHidden.Value;
            AddLineLink.Text = "Add Line to " + QuoteNoHidden.Value;
            Session[DetailTableName.Value] = null;
            SingleQuoteDetail = true;
            CheckAll = false;
            GetQuotes(Server.HtmlDecode(CustNoTextBox.Text), "QuoteNumber", Server.HtmlDecode(row.Cells[0].Text), "Detail");
            UpdateWeight();
        }
        if (e.CommandName == "ShowQuotes")
        {
            // show all lines for the selected quotes in the detail grid 
            QuoteNoHidden.Value = "";
            AddLineLink.Text = QuoteNoHidden.Value;
            QuotesToGet = "";
            CheckBox QuoteSelected = new CheckBox();
            foreach (GridViewRow row in QuoteGridView.Rows)
            {
                QuoteSelected = (CheckBox)row.Cells[8].Controls[1];
                if (QuoteSelected.Checked)
                {
                    if (QuotesToGet != "") QuotesToGet += ",";
                    QuotesToGet += Server.HtmlDecode(row.Cells[0].Text);
                }
            }
            if (QuotesToGet.Trim() == "")
            {
                ShowPageMessage("You must select at least one quote", 2);
                //ScriptManager.RegisterClientScriptBlock(txtSearchText, txtSearchText.GetType(), "Find", "alert('You must select at least one quote');", true);
            }
            else
            {
                DetailFilterFieldHidden.Value = "QuotationNumbers";
                DetailFilterValueHidden.Value = QuotesToGet;
                SingleQuoteDetail = false;
                CheckAll = false;
                GetQuotes(CustNoTextBox.Text, "QuotationNumbers", QuotesToGet, "Detail");
                UpdateWeight();
                ScriptManager.RegisterClientScriptBlock(txtSearchText, txtSearchText.GetType(), "Find", "SetHeight();", true);
            }
        }
  		QuoteRecallScriptManager.SetFocus("POTextBox");
       	ScriptManager.RegisterClientScriptBlock(txtSearchText, txtSearchText.GetType(), "Find", "SetHeight();", true);
    }

    protected void DetailRowBound(Object sender, GridViewRowEventArgs e)
    {
        try
        {
            // show availability link if QOH less than requested
            row = e.Row;
            if (row.RowType == DataControlRowType.DataRow)
            {
                // line formatting
                LineSelector = (CheckBox)row.Cells[0].Controls[1];
                GridDeleteFlag = (HiddenField)row.Cells[0].Controls[5];
                GridMakeDate = (HiddenField)row.Cells[0].Controls[7];
                GridMakeBy = (HiddenField)row.Cells[0].Controls[9];
                QuoteID = (HiddenField)row.Cells[0].Controls[3];
                ItemLabel = (Label)row.Cells[3].Controls[1];
                ReqQtyBox = (TextBox)row.Cells[5].Controls[1];
                ReqQtyLabel = (Label)row.Cells[5].Controls[3];
                QOHLink = (LinkButton)row.Cells[7].Controls[3];
                QOHLabel = (Label)row.Cells[7].Controls[1];
                LocLabel = (Label)row.Cells[8].Controls[1];
                PriceBox = (TextBox)row.Cells[9].Controls[1];
                PriceUMLabel = (Label)row.Cells[9].Controls[3];
                PriceGluedLabel = (Label)row.Cells[9].Controls[5];
                CarrierCdLabel = (Label)row.Cells[14].Controls[1];
                FreightCdLabel = (Label)row.Cells[15].Controls[1];
                // format comment lines
                if (row.Cells[2].Text == "COMMENT")
                {
                    LineSelector.Enabled = false;
                    LineSelector.ToolTip = "This Line is a Quote Comment and Can Not Be Made into an Order";
                    //row.Cells[3].Visible = false;
                    row.Cells[4].ColumnSpan = 13;
                    row.Cells[4].Text = row.Cells[17].Text;
                    row.Cells[4].Width = new Unit(row.Cells[4].Width.Value + row.Cells[5].Width.Value + 
                        row.Cells[6].Width.Value + row.Cells[7].Width.Value +
                        row.Cells[8].Width.Value + row.Cells[9].Width.Value + row.Cells[10].Width.Value +
                        row.Cells[11].Width.Value + row.Cells[12].Width.Value + row.Cells[13].Width.Value +
                        row.Cells[14].Width.Value + row.Cells[15].Width.Value + row.Cells[16].Width.Value, UnitType.Pixel);
                    row.Cells[5].Visible = false;
                    row.Cells[6].Visible = false;
                    row.Cells[7].Visible = false;
                    row.Cells[8].Visible = false;
                    row.Cells[9].Visible = false;
                    row.Cells[10].Visible = false;
                    row.Cells[11].Visible = false;
                    row.Cells[12].Visible = false;
                    row.Cells[13].Visible = false;
                    row.Cells[14].Visible = false;
                    row.Cells[15].Visible = false;
                    row.Cells[16].Visible = false;
                    //row.Cells[4].Attributes.Add("oncontextmenu", "javascript:window.event.returnValue=false;");
                    //row.Cells[4].Attributes.Add("onMouseDown", "delLine(this, '" + QuoteID.Value.Trim() + "');");
                }
                // line deleted processing
                if (GridDeleteFlag.Value == "True")
                {
                    row.Cells[0].CssClass = "quoteLineDeleted";
                    LineSelector.Enabled = false;
                    LineSelector.ToolTip = "This Line is Deleted and Can Not Be Made into an Order";
                    QOHLink.Visible = false;
                    ReqQtyBox.Visible = false;
                    PriceBox.Visible = false;
                    PriceUMLabel.Visible = false;
                    LocLabel.CssClass = "";
                    LocLabel.Attributes.Remove("onClick");
                    CarrierCdLabel.CssClass = "";
                    CarrierCdLabel.Attributes.Remove("onClick");
                    FreightCdLabel.CssClass = "";
                    FreightCdLabel.Attributes.Remove("onClick");
                }
                else
                {
                    ReqQtyLabel.Visible = false;
                    PriceGluedLabel.Visible = false;
                    // line delete set up
                    row.Cells[3].Attributes.Add("oncontextmenu", "javascript:window.event.returnValue=false;");
                    ItemLabel.Attributes.Add("onMouseDown", "delLine(this, '" + QuoteID.Value.Trim() + "');");
                    //row.Cells[3].Attributes.Add("onMouseOut", "delLineHide();");
                    //// Carrier processing
                    //HiddenField CarCode = (HiddenField)row.Cells[12].Controls[3];
                    //DropDownList CarDrop = (DropDownList)row.Cells[12].Controls[1];
                    //CarDrop.SelectedValue = CarCode.Value.ToString();
                    //// Freight processing
                    //HiddenField FrtCode = (HiddenField)row.Cells[13].Controls[3];
                    //DropDownList FrtDrop = (DropDownList)row.Cells[13].Controls[1];
                    //FrtDrop.SelectedValue = FrtCode.Value.ToString();
                    // handle QOH link to bring up branch availability if QOH is short
                    int ReqQty = int.Parse(Server.HtmlDecode(ReqQtyBox.Text.Replace(",", "")));
                    int QOH = int.Parse(QOHLabel.Text.Replace(",", ""));
                    string LinkCommand = "";
                    LinkCommand = "return ShowAvailability('";
                    LinkCommand += Server.HtmlDecode(row.Cells[1].Text) + "', '";
                    LinkCommand += Server.HtmlDecode(ItemLabel.Text) + "', '";
                    LinkCommand += Server.HtmlDecode(LocLabel.Text) + "', '";
                    LinkCommand += Server.HtmlDecode(ReqQtyBox.Text.Replace(",", "")) + "', '";
                    LinkCommand += Server.HtmlDecode(QOHLabel.Text.Replace(",", "")) + "');";
                    QOHLink.OnClientClick = LinkCommand;
                    if (QOH < ReqQty)
                    {
                        QOHLabel.CssClass = "noDisplay";
                        //QOHLink.OnClientClick = "alert(" + LinkCommand + ");";
                    }
                    else
                    {
                        QOHLink.CssClass = "noDisplay";
                    }
                    // Make order processing
                    if (GridMakeBy.Value.Trim().Length > 0)
                    {
                        row.Cells[0].CssClass = "quoteLineOrderMade";
                        LineSelector.ToolTip = "An order was Made from this Line by " + GridMakeBy.Value.Trim() + " on " + GridMakeDate.Value;
                    }
                }
            }
        }
        catch (Exception e2)
        {
            ShowPageMessage("FillGrid Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    protected void DateRowBound(Object sender, GridViewRowEventArgs e)
    {
        try
        {
            // set up the select link  OnRowDataBound="DateRowBound"
            row = e.Row;
            if (row.RowType == DataControlRowType.Header)
            {
                // line formatting
                DateSelectButt.Text = "Select";
                DateSelectButt.Attributes.Add("OnClick", "ShowSelectedDays();");
                row.Cells[4].Controls.Add(DateSelectButt);
            }
        }
        catch (Exception e2)
        {
            ShowPageMessage("DateRowBound Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    protected void SearchQuotes(object sender, EventArgs e)
    {
        // get the using the filter.
        GetQuotes(CustNoTextBox.Text, ddlSearchColumn.SelectedValue, txtSearchText.Text, "Header");
        //QuoteHeaderUpdatePanel.Update();
    }

    protected void ShowSelectedQuotesButt_Click(object sender, EventArgs e)
    {
    }

    protected void LineDelete_Click(object sender, EventArgs e)
    {
        string UpdateColumns = "DeleteDt=getdate(), DeleteFlag=1, ChangeID='" +
           Session["UserName"].ToString() + "', ChangeDt=getdate(), Status=''";
        SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "UGEN_SP_Update",
            new SqlParameter("@tableName", "DTQ_CustomerQuotation"),
            new SqlParameter("@columnNames", UpdateColumns),
            new SqlParameter("@whereClause", "QuoteNumber='" + LineToDelHidden.Value + "'"));
        dt = (DataTable)Session[DetailTableName.Value];
        DataRow quoteRow = dt.Select("QuoteNumber = '" + LineToDelHidden.Value + "'")[0];
        quoteRow["DeleteFlag"] = 1;
        RefreshDetailGrid();
        //ScriptManager.RegisterClientScriptBlock(POTextBox, POTextBox.GetType(), "PO", "delLineHide();", true);
    }

    public void DetailRefresh_Click(object sender, EventArgs e)
    {
        RefreshDetailGrid();
    }

    protected void MakeOrder_Click(object sender, EventArgs e)
    {
        int CheckedCount = 0;
        string SelectedQuote = "";
        string UpdateColumns = "";
        StringBuilder errorMessages = new StringBuilder();
        string QuotesList = "";
        // onClick="ShowLine(this);" CssClass="QOHLink"
        ClearPageMessages();
        if (POTextBox.Text.Trim().Length == 0)
        {
            ShowPageMessage("A P.O. number is required when making an order.", 2);
            QuoteRecallScriptManager.SetFocus("POTextBox");
        }
        else
        {
            try
            {
                foreach (DataRow dr in ((DataTable)Session[DetailTableName.Value]).Rows)
                {
                    SelectedQuote = dr["SessionID"].ToString();
                    if (!QuotesList.Contains(dr["SessionID"].ToString()))
                    {
                        if (QuotesList == "")
                        {
                            QuotesList += dr["SessionID"].ToString();
                        }
                        else
                        {
                            QuotesList += ", " + dr["SessionID"].ToString();
                        }
                    }
                    // first clear any old make order statuses
                    UpdateColumns = "Status='' ";
                    SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "UGEN_SP_Update",
                        new SqlParameter("@tableName", "DTQ_CustomerQuotation"),
                        new SqlParameter("@columnNames", UpdateColumns),
                        new SqlParameter("@whereClause", "QuoteNumber='" + dr["QuoteNumber"].ToString() + "'"));
                    if ((bool)dr["MakeOrder"])
                    {
                        // update the line to be made
                        UpdateColumns = "Status='MO', MakeOrderDt=getdate(), MakeOrderID='" + Session["UserName"].ToString() + "'";
                        SqlHelper.ExecuteNonQuery(Global.PFCERPConnectionString, "UGEN_SP_Update",
                            new SqlParameter("@tableName", "DTQ_CustomerQuotation"),
                            new SqlParameter("@columnNames", UpdateColumns),
                            new SqlParameter("@whereClause", "QuoteNumber='" + dr["QuoteNumber"].ToString() + "' and RequestQuantity<>0"));
                        CheckedCount++;
                    }
                }
                if (CheckedCount == 0)
                {
                    ShowPageMessage("Check the check box to the left of the quote number to make that quote into an order. ", 2);
                }
                else
                {
                    // Make an Order.
                    try
                    {
                        ds = SqlHelper.ExecuteDataset(connectionString, "pSOEMakeOrderFromQuote",
                           new SqlParameter("@CustNo", CustNoTextBox.Text),
                           new SqlParameter("@QuotesList", QuotesList),
                           new SqlParameter("@PONo", POTextBox.Text),
                           new SqlParameter("@EntryID", Session["UserName"].ToString()));
                    }
                    catch (SqlException ex)
                    {
                        for (int i = 0; i < ex.Errors.Count; i++)
                        {
                            errorMessages.Append("Index #" + i + "\n" +
                                "Message: " + ex.Errors[i].Message + "\n" +
                                "LineNumber: " + ex.Errors[i].LineNumber + "\n" +
                                "Source: " + ex.Errors[i].Source + "\n" +
                                "Procedure: " + ex.Errors[i].Procedure + "\n");
                        }
                        ShowPageMessage("pSOEMakeOrderFromQuote Error " + errorMessages.ToString(), 2);
                    }
                    if (ds.Tables.Count >= 1)
                    {
                        if (ds.Tables.Count <= 1)
                        {
                            // We only go two tables back, something is wrong
                            dt = ds.Tables[0];
                            if (dt.Rows.Count > 0)
                            {
                                ShowPageMessage("Make Order problem. " + SelectedQuote, 2);
                            }
                        }
                        else
                        {
                            dt = ds.Tables[ds.Tables.Count - 1];
                            if (dt.Rows.Count == 0)
                            {
                                ShowPageMessage("Make Order problem. " + SelectedQuote, 2);
                            }
                            else
                            {
                                ShowPageMessage("Created Order number " + dt.Rows[0]["NewOrders"] + " from Quote(s) " + QuotesList.Replace("'",""), 0);
                                Session[DetailTableName.Value] = null;
                                CommentsPanel.Visible = true;
                                POPanel.Visible = false;
                                ExcelExportButton.Visible = false;
                                ExcelUpdatePanel.Update();
                                //ScriptManager.RegisterClientScriptBlock(POTextBox, POTextBox.GetType(), "PO", "RestoreHeader();", true);
                                //ScriptManager.RegisterClientScriptBlock(POTextBox, POTextBox.GetType(), "PO", "CreateCommentLinks('" + dt.Rows[0]["NewOrders"].ToString() + "');", true);
                                ScriptManager.RegisterClientScriptBlock(POTextBox, POTextBox.GetType(), "PO", "OpenSOE();", true);
                                POTextBox.Text = "";
                                DetailGridView.DataBind();
                                int lastline = CheckedCount * 10;
                                QuoteRecallScriptManager.SetFocus("CloseButt");
                                //orderEntry.OrderLock("LOCK", dt.Rows[0]["NewOrderNo"].ToString());
                            }
                        }
                    }
                }
            }
            catch (NullReferenceException ex0)
            {
                ShowPageMessage("We cannot process this order at this time.  Please try again after logging out SOE and then back in.", 2);
            }
            catch (Exception ex1)
            {
                string PassedData = "Quote=" + SelectedQuote + ":User=" + Session["UserName"].ToString()
                    + ":Cust=" + CustNoTextBox.Text + ":PO=" + POTextBox.Text + ":Count=" + CheckedCount.ToString()
                    + ":UpdateColumns=" + UpdateColumns + ":DetailTableName=" + DetailTableName.Value + "\n";
                ShowPageMessage("Make Order from Quote Error " + PassedData + ex1.Message + ", \n\n" + ex1.ToString(), 2);
            }
        }
    }

    protected void ExcelExportButton_Click(object sender, ImageClickEventArgs e)
    {
        // 
        CreateExcelFile();
    }

    private void CreateExcelFile()
    {
        //
        // Create the quote detail spreadsheet
        //
        // Convert a virtual path to a fully qualified physical path.
        string ExcelFileName = @"Common/Excel/QuoteDetail" + Session["UserName"].ToString() + ".xls";
        string fullpath = Request.MapPath(ExcelFileName);
        string RowSelector = "";
        if (ShowDeletedHidden.Value == "1")
        {
            RowSelector = "1 = 1";
        }
        else
        {
            RowSelector = "DeleteFlag = 0";
        }
        using (StreamWriter sw = new StreamWriter(fullpath))
        {
            sw.Write("Quote #\tCust Part\tPFC Part\tDescription\tQty\tBase Qty/UOM\tQOH\tLoc.\tPrice/UOM\tAmount\t");
            sw.Write("Mrgn $\tMrgn %\tWeight\tCarrier\tFreight\tUser");
            sw.WriteLine();
            foreach (DataRow row in ((DataTable)Session[DetailTableName.Value]).Select(RowSelector))
            {
                if (row["UserItemNo"].ToString() == "COMMENT")
                {
                    //sw.Write("\t\t\t");
                    sw.Write(row["Notes"].ToString().Trim());
                }
                else
                {

                    sw.Write(row["SessionID"].ToString().Trim());
                    sw.Write("\t");
                    sw.Write(row["UserItemNo"].ToString().Trim());
                    sw.Write("\t");
                    sw.Write(row["PFCItemNo"].ToString().Trim());
                    sw.Write("\t");
                    sw.Write(row["Description"].ToString().Trim());
                    sw.Write("\t");
                    sw.Write(row["RequestQuantity"].ToString().Trim());
                    sw.Write("\t");
                    sw.Write(row["BaseQtyGlued"].ToString().Trim());
                    sw.Write("\t");
                    sw.Write(row["AvailableQuantity"].ToString().Trim());
                    sw.Write("\t");
                    sw.Write(row["LocationCode"].ToString().Trim());
                    sw.Write("\t");
                    sw.Write(row["PriceGlued"].ToString().Trim());
                    sw.Write("\t");
                    sw.Write(row["TotalPrice"].ToString().Trim());
                    sw.Write("\t");
                    sw.Write(row["MarginDollars"].ToString().Trim());
                    sw.Write("\t");
                    sw.Write(row["MarginPcnt"].ToString().Trim());
                    sw.Write("\t");
                    sw.Write(row["LineWeight"].ToString().Trim());
                    sw.Write("\t");
                    sw.Write(row["OrderCarName"].ToString().Trim());
                    sw.Write("\t");
                    sw.Write(row["OrderFreightName"].ToString().Trim());
                    sw.Write("\t");
                    sw.Write(row["UserID"].ToString().Trim());
                    sw.Write("\t");
                }
                sw.WriteLine();
            }
        }
        // now open it.
        //ScriptManager.RegisterClientScriptBlock(POTextBox, POTextBox.GetType(), "PONo", "OpenExcel('" + ExcelFileName + "');", true);
        //
        // Downloding Process
        //
        FileStream fileStream = File.Open(fullpath, FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        //
        // Download Process
        //
        Response.AddHeader("Content-disposition", "attachment; filename=" + fullpath);
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();


    }

    public string GetQtyAvail(string Item, string Loc, string UOM)
    {
        DataTable tempDt = new DataTable();
        ds = SqlHelper.ExecuteDataset(connectionString, CommandType.Text,
            "Select QOH = isnull(dbo.fGetBrAvailability('" + Item + "', '" + Loc + "', '" + UOM + "'), 0)");
        if (ds.Tables.Count == 1)
        {
            tempDt = ds.Tables[0];
            return tempDt.Rows[0]["QOH"].ToString();
        }
        else
        {
            return "-1";
        }
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string OrderAllocate(string OrderNo, string HoldStat)
    {
        string status = "";
        // set SubType from 99 to 50
        SqlHelper.ExecuteNonQuery(connectionString, "UGEN_SP_Update",
            new SqlParameter("@tableName", "SOHeader"),
            new SqlParameter("@columnNames", " SubType=50 "),
            new SqlParameter("@whereClause", "pSOHeaderID = " + OrderNo));
        // get the data.  
        DataSet dsMO = SqlHelper.ExecuteDataset(connectionString, "pSOEMakeOrder",
                  new SqlParameter("@orderID", OrderNo),
                  new SqlParameter("@userName", Session["UserName"].ToString()),
                  new SqlParameter("@table", "SOHeader"),
                  new SqlParameter("@holdCd", HoldStat));
        status = "true";
        return status;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string SetCommentSessionVars(string OrderLines)
    {
        Session["OrderTableName"] = "SOHeader";
        Session["DetailTableName"] = "SODetail";
        int lastLine = int.Parse(OrderLines);
        lastLine = lastLine * 10;
        Session["LineItemNumber"] = lastLine.ToString();
        string status = "";
        status = "true";
        return status;
    }

    
    protected void QuoteGridViewSortCommand(object source, GridViewSortEventArgs e)
    {
        DataView dv = new DataView((DataTable)Session[HeaderTableName.Value], "", e.SortExpression.ToString(), DataViewRowState.CurrentRows);
        QuoteGridView.DataSource = dv;
        QuoteGridView.DataBind();
    }

    /// <summary>
    /// Function to load the customer details
    /// </summary>
    public void WorkCustomerNumber(object sender, EventArgs e)
    {
        string strCustNo = CustNoTextBox.Text;
        int strCnt = 0;
        //if ((strCustNo != "") && (strCustNo.Contains("%") == true))
        //{
        //    //strCustNo.Replace("'", "''");
        //    if (isNumeric(strCustNo.Remove(strCustNo.Length - 1, 1), System.Globalization.NumberStyles.Integer) == false)
        //        strCnt = Convert.ToInt32(cntCustName(strCustNo));
        //    else
        //        strCnt = Convert.ToInt32(cntCustNo(strCustNo));
        //    int maxRowCount = custDet.GetSQLWarningRowCount();


        //    if (strCnt < maxRowCount)
        //        ScriptManager.RegisterClientScriptBlock(CustNoTextBox, CustNoTextBox.GetType(), "Customer", "LoadCustomerLookup('" + Server.UrlEncode(PFC.SOE.Securitylayer.Cryptor.Encrypt(strCustNo)) + "');", true);
        //    else
        //        ScriptManager.RegisterClientScriptBlock(CustNoTextBox, CustNoTextBox.GetType(), "Customer", "alert('Maximum row exceeds for this search.please enter additional data.');", true);
        //}
        bool textIsNumeric = true;
        try
        {
            int.Parse(strCustNo);
        }
        catch
        {
            textIsNumeric = false;
        }

        if ((strCustNo != "") && !textIsNumeric)
        {
            ScriptManager.RegisterClientScriptBlock(CustNoTextBox, CustNoTextBox.GetType(), "Customer", "LoadCustomerLookup('" + Server.UrlEncode(PFC.SOE.Securitylayer.Cryptor.Encrypt(strCustNo)) + "');", true);
        }
        else
        {
            if (strCustNo != "")
            {
                #region Code to fill the customer details in the controls
                // Call the webservice to get the customer address detail
                DataSet dsCustomer = orderEntry.GetCustomerDetails(strCustNo);
                if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count != 0)
                {
                    string creditStatus = "";
                    if (dsCustomer.Tables[0].Rows[0]["CustCd"].ToString() != "BT" && dsCustomer.Tables[0].Rows[0]["fBillToNo"].ToString() != "")
                    {

                        creditStatus = orderEntry.GetCreditReview(dsCustomer.Tables[0].Rows[0]["fBillToNo"].ToString().ToString(), dsCustomer.Tables[2].Rows[0]["CreditInd"].ToString().Trim(), "0", "Order");
                        if (creditStatus.ToUpper() != "OK")
                        {
                            ScriptManager.RegisterClientScriptBlock(CustNoTextBox, typeof(TextBox), "invalid", "alert('" + creditStatus + "');", true);
                            return;
                        }
                    }
                    else
                    {
                        //ISBillToCustomer = true;
                        ScriptManager.RegisterClientScriptBlock(CustNoTextBox, typeof(TextBox), "invalid", "alert('Bill To Only Customer could not process order');document.getElementById('" + CustNoTextBox.ClientID + "').value='';document.getElementById('" + CustNoTextBox.ClientID + "').focus();document.getElementById('" + CustNoTextBox.ClientID + "').select();", true);
                        return;
                    }
                    Session[HeaderTableName.Value] = null;
                    GetQuotes(CustNoTextBox.Text, "", "", "Header");

                }
                else
                {
                    //hidCust.Value = "";
                    ScriptManager.RegisterClientScriptBlock(CustNoTextBox, typeof(TextBox), "invalid", "alert('Invalid Customer value (1)');document.getElementById('" + CustNoTextBox.ClientID + "').value='';document.getElementById('" + CustNoTextBox.ClientID + "').focus();document.getElementById('" + CustNoTextBox.ClientID + "').select();", true);
                }
                #endregion
            }
            else
            {
                //ClearLabels();
            }
        }
    }

    public void SortDetailGrid(Object sender, GridViewSortEventArgs e)
    {
        try
        {
            // Create a DataView from the Quote Detail DataTable.
            string LineFilter;
            if (ShowDeletedHidden.Value == "1")
            {
                LineFilter = "1 = 1";
            }
            else
            {
                LineFilter = "DeleteFlag = 0";
            }
            DataView dv = new DataView((DataTable)Session[DetailTableName.Value]);
            dv.Sort = e.SortExpression;
            DetailSortField.Value = e.SortExpression;
            dv.RowFilter = LineFilter;
            DetailGridView.DataSource = dv;
            DetailGridView.DataBind();
            DetailGridPanel.Height = new Unit(double.Parse(DetailGridHeightHidden.Value), UnitType.Pixel);
            DetailGridPanel.Width = new Unit(double.Parse(DetailGridWidthHidden.Value), UnitType.Pixel);
        }
        catch (Exception e2)
        {
            ShowPageMessage("Sort Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    public void DetailGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        // Create a DataView from the Quote Detail DataTable.
        string LineFilter;
        if (ShowDeletedHidden.Value == "1")
        {
            LineFilter = "1 = 1";
        }
        else
        {
            LineFilter = "DeleteFlag = 0";
        }
        DataView dv = new DataView((DataTable)Session[DetailTableName.Value]);
        dv.Sort = DetailSortField.Value;
        dv.RowFilter = LineFilter;
        DetailGridView.DataSource = dv;
        DetailGridView.PageIndex = e.NewPageIndex;
        DetailGridView.DataBind();
        ScriptManager.RegisterClientScriptBlock(POTextBox, POTextBox.GetType(), "PO", "SetHeight();", true);
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string SetLineCheckBoxData(string LineQuoteNo, string NewState, string Item, string Loc, string UOM, string SessionTable)
    {
        string status = LineQuoteNo;
        // update the table in the session variable to show that the line is selected for make order.
        DataTable tempDt = (DataTable)Session[SessionTable];
        DataRow[] QuoteRow =
           tempDt.Select("QuoteNumber = '" + LineQuoteNo + "'");
        status += " was " + QuoteRow[0]["MakeOrder"].ToString();
        if (NewState.ToUpper() == "TRUE")
        {
            QuoteRow[0]["MakeOrder"] = true;
            // we are selecting the line, so get the QOH
            status = GetQtyAvail(Item, Loc, UOM);
            // update the record
            SqlHelper.ExecuteNonQuery(connectionString, "UGEN_SP_Update",
                new SqlParameter("@tableName", "DTQ_CustomerQuotation"),
                new SqlParameter("@columnNames", " AvailableQuantity=" + status + " "),
                new SqlParameter("@whereClause", "QuoteNumber = '" + LineQuoteNo + "'"));
            QuoteRow[0]["AvailableQuantity"] = int.Parse(status, NumberStyles.Number);
        }
        else
        {
            QuoteRow[0]["MakeOrder"] = false;
            //status += " made false";
        }
        Session[SessionTable] = tempDt;
        return status;

    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdLineLoc(string LineQuoteNo, string NewLocationCode, string NewLocationName, string SessionTableName)
    {
        string status = LineQuoteNo;
        // update the line carrier via an Ajax call from the javascript function ChangeCarrier
        DataTable tempDt = (DataTable)Session[SessionTableName];
        //status = DetailTableName.Value.ToString();
        DataRow[] QuoteRow =
           tempDt.Select("QuoteNumber = '" + LineQuoteNo + "'");
        status += " was " + QuoteRow[0]["LocationCode"].ToString();
        // we are changing the location, so get the QOH
        status = GetQtyAvail(QuoteRow[0]["PFCItemNo"].ToString(), NewLocationCode, QuoteRow[0]["BaseUOM"].ToString());
        // update the record
        SqlHelper.ExecuteNonQuery(connectionString, "UGEN_SP_Update",
            new SqlParameter("@tableName", "DTQ_CustomerQuotation"),
            new SqlParameter("@columnNames", " LocationCode='" + NewLocationCode + "', LocationName='" + NewLocationName + "',  AvailableQuantity=" + status + " "),
            new SqlParameter("@whereClause", "QuoteNumber = '" + LineQuoteNo + "'"));

        QuoteRow[0]["LocationCode"] = NewLocationCode;
        QuoteRow[0]["LocationName"] = NewLocationName;
        //status += ". Location set to " + NewLocationCode + " - " + NewLocationName;
        Session[SessionTableName] = tempDt;
        return status;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdLineCarrier(string LineQuoteNo, string NewCarrierCode, string NewCarrierName, string SessionTableName)
    {
        string status = LineQuoteNo;
        // update the line carrier via an Ajax call from the javascript function ChangeCarrier
        DataTable tempDt = (DataTable)Session[SessionTableName];
        //status = DetailTableName.Value.ToString();
        DataRow[] QuoteRow =
           tempDt.Select("QuoteNumber = '" + LineQuoteNo + "'");
        status += " was " + QuoteRow[0]["OrderCarrier"].ToString();
        // update the record
        SqlHelper.ExecuteNonQuery(connectionString, "UGEN_SP_Update",
            new SqlParameter("@tableName", "DTQ_CustomerQuotation"),
            new SqlParameter("@columnNames", " OrderCarrier='" + NewCarrierCode + "', OrderCarName='" + NewCarrierName + "' "),
            new SqlParameter("@whereClause", "QuoteNumber = '" + LineQuoteNo + "'"));

        QuoteRow[0]["OrderCarrier"] = NewCarrierCode;
        QuoteRow[0]["OrderCarName"] = NewCarrierName;
        status += ". Carrier set to " + NewCarrierCode + " - " + NewCarrierName;
        Session[SessionTableName] = tempDt;
        return status;

    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdLineFreight(string LineQuoteNo, string NewFreightCode, string NewFreightName, string SessionTableName)
    {
        string status = LineQuoteNo;
        // all we do here is update the table in the session variable to show that the line is selected for make order.
        DataTable tempDt = (DataTable)Session[SessionTableName];
        DataRow[] QuoteRow =
           tempDt.Select("QuoteNumber = '" + LineQuoteNo + "'");
        status += " was " + QuoteRow[0]["OrderFreightCd"].ToString();
        // update the record
        SqlHelper.ExecuteNonQuery(connectionString, "UGEN_SP_Update",
            new SqlParameter("@tableName", "DTQ_CustomerQuotation"),
            new SqlParameter("@columnNames", " OrderFreightCd='" + NewFreightCode + "', OrderFreightName='" + NewFreightName + "' "),
            new SqlParameter("@whereClause", "QuoteNumber = '" + LineQuoteNo + "'"));

        QuoteRow[0]["OrderFreightCd"] = NewFreightCode;
        QuoteRow[0]["OrderFreightName"] = NewFreightName;
        status += ". Freight set to " + NewFreightCode + " - " + NewFreightName;
        Session[SessionTableName] = tempDt;
        return status;

    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdLineQty(string LineQuoteNo, string NewQty, string Item, string Loc, string UOM, string SessionTable, string HeaderTable)
    {
        string status = LineQuoteNo;
        string SessionID;
        // we are changing the qty, so get the QOH
        status = GetQtyAvail(Item, Loc, UOM);
        // we update the table in the session variable and the actual quote table with the new qty.
        // we also update the available. Since we can't update the page, we pass back the new availability so it can be updated
        DataTable tempDt = (DataTable)Session[SessionTable];
        DataRow[] QuoteRow =
           tempDt.Select("QuoteNumber = '" + LineQuoteNo + "'");
        //status += " was " + QuoteRow[0]["RequestQuantity"].ToString();
        // update the record
        SqlHelper.ExecuteNonQuery(connectionString, "UGEN_SP_Update",
            new SqlParameter("@tableName", "DTQ_CustomerQuotation"),
            new SqlParameter("@columnNames", " RequestQuantity=" + int.Parse(NewQty, NumberStyles.Number).ToString()
                + ", AlternateUOMQty=BaseUOMQty*" + int.Parse(NewQty, NumberStyles.Number).ToString() + " "
                + ", AvailableQuantity=" + status + " "
                + ", TotalPrice=(UnitPrice*" + int.Parse(NewQty, NumberStyles.Number).ToString() + ") "),
            new SqlParameter("@whereClause", "QuoteNumber = '" + LineQuoteNo + "'"));

        QuoteRow[0]["RequestQuantity"] = int.Parse(NewQty, NumberStyles.Number);
        QuoteRow[0]["TotalPrice"] = int.Parse(NewQty, NumberStyles.Number) * decimal.Parse(QuoteRow[0]["UnitPrice"].ToString(), NumberStyles.Number);
        QuoteRow[0]["LineWeight"] = int.Parse(NewQty, NumberStyles.Number) * decimal.Parse(QuoteRow[0]["NetWeight"].ToString(), NumberStyles.Number);
        QuoteRow[0]["MarginDollars"] = int.Parse(NewQty, NumberStyles.Number) * ((decimal)QuoteRow[0]["UnitPrice"] - (decimal)QuoteRow[0]["UnitCost"]);
        QuoteRow[0]["AvailableQuantity"] = int.Parse(status, NumberStyles.Number);
        SessionID = QuoteRow[0]["SessionID"].ToString();
        //status += ". Qty set to " + NewQty;
        object sumWeightObject, sumAmountObject, sumMarginObject;
        sumAmountObject = tempDt.Compute("Sum(TotalPrice)", "SessionID ='" + SessionID + "' and DeleteFlag = 0");
        status += ":" + string.Format("{0:####,###,##0.00}", sumAmountObject);
        sumMarginObject = tempDt.Compute("Sum(MarginDollars)", "SessionID ='" + SessionID + "' and DeleteFlag = 0");
        status += ":" + string.Format("{0:####,###,##0.00}", sumMarginObject);
        sumWeightObject = tempDt.Compute("Sum(LineWeight)", "SessionID ='" + SessionID + "' and DeleteFlag = 0");
        status += ":" + string.Format("{0:####,###,##0.00}", sumWeightObject);
        Session[SessionTable] = tempDt;
        //// now do the header table
        //tempDt = (DataTable)Session[HeaderTable];
        //QuoteRow = tempDt.Select("QuoteNumber = '" + LineQuoteNo + "'");
        //QuoteRow[0]["RequestQuantity"] = int.Parse(NewQty, NumberStyles.Number);
        //QuoteRow[0]["TotalPrice"] = int.Parse(NewQty, NumberStyles.Number) * decimal.Parse(QuoteRow[0]["UnitPrice"].ToString(), NumberStyles.Number);
        //QuoteRow[0]["LineWeight"] = int.Parse(NewQty, NumberStyles.Number) * decimal.Parse(QuoteRow[0]["NetWeight"].ToString(), NumberStyles.Number);
        //QuoteRow[0]["MarginDollars"] = int.Parse(NewQty, NumberStyles.Number) * ((decimal)QuoteRow[0]["UnitPrice"] - (decimal)QuoteRow[0]["UnitCost"]);
        //QuoteRow[0]["AvailableQuantity"] = int.Parse(status, NumberStyles.Number);
        //Session[HeaderTable] = tempDt;

        return status;

    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdLinePrice(string LineQuoteNo, string NewPrice, string Item, string Loc, string UOM, string SessionTable, string HeaderTable)
    {
        string status = LineQuoteNo;
        string colNames;
        string SessionID;
        decimal AltPrice = decimal.Parse(NewPrice, NumberStyles.Number);
        decimal UnitPrice = 0;
        decimal MarginPcnt = 0;
        try
        {
            // we update the table in the session variable and the actual quote table with the new price.
            DataTable tempDt = (DataTable)Session[SessionTable];
            DataRow[] QuoteRow = tempDt.Select("QuoteNumber = '" + LineQuoteNo + "'");
            QuoteRow[0]["AltPrice"] = AltPrice;
            UnitPrice = AltPrice * (decimal)QuoteRow[0]["SellUOMQty"];
            QuoteRow[0]["UnitPrice"] = UnitPrice;
            if (UnitPrice != 0)
            {
                // avoid a divide by zero
                MarginPcnt = 100 * (UnitPrice - (decimal)QuoteRow[0]["UnitCost"]) / UnitPrice;
            }
            colNames = " AltPrice = " + AltPrice.ToString()
                    + ", UnitPrice = " + UnitPrice.ToString() + " "
                    + ", TotalPrice = (RequestQuantity * " + UnitPrice.ToString() + ") ";
            //status = colNames;
            //status += " was " + QuoteRow[0]["AltPrice"].ToString();
            // update the record
            SqlHelper.ExecuteNonQuery(connectionString, "UGEN_SP_Update",
                new SqlParameter("@tableName", "DTQ_CustomerQuotation"),
                new SqlParameter("@columnNames", colNames),
                new SqlParameter("@whereClause", "QuoteNumber = '" + LineQuoteNo + "'"));

            status = UnitPrice.ToString();
            QuoteRow[0]["TotalPrice"] = (decimal)QuoteRow[0]["RequestQuantity"] * UnitPrice;
            QuoteRow[0]["MarginDollars"] = (decimal)QuoteRow[0]["RequestQuantity"] * (UnitPrice - (decimal)QuoteRow[0]["UnitCost"]);
            QuoteRow[0]["MarginPcnt"] = MarginPcnt;
            SessionID = QuoteRow[0]["SessionID"].ToString();
            //status += ". Qty set to " + NewQty;
            object sumAmountObject, sumMarginObject;
            sumAmountObject = tempDt.Compute("Sum(TotalPrice)", "SessionID ='" + SessionID + "' and DeleteFlag = 0");
            status += ":" + string.Format("{0:####,###,##0.00}", sumAmountObject);
            sumMarginObject = tempDt.Compute("Sum(MarginDollars)", "SessionID ='" + SessionID + "' and DeleteFlag = 0");
            status += ":" + string.Format("{0:####,###,##0.00}", sumMarginObject);
            Session[SessionTable] = tempDt;
            //// now do the header table
            //tempDt = (DataTable)Session[HeaderTable];
            //QuoteRow = tempDt.Select("QuoteNumber = '" + LineQuoteNo + "'");
            //QuoteRow[0]["AltPrice"] = AltPrice;
            //QuoteRow[0]["UnitPrice"] = UnitPrice;
            //QuoteRow[0]["TotalPrice"] = (decimal)QuoteRow[0]["RequestQuantity"] * UnitPrice;
            //QuoteRow[0]["MarginDollars"] = (decimal)QuoteRow[0]["RequestQuantity"] * (UnitPrice - (decimal)QuoteRow[0]["UnitCost"]);
            //QuoteRow[0]["MarginPcnt"] = MarginPcnt;
            //Session[HeaderTable] = tempDt;

            return status;
        }
        catch (Exception e2)
        {
            return "!!" + e2.ToString();
        }
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string ClearSessionTables(string SessionTable, string HeaderTable)
    {
        string status = "Cleared " + HeaderTable + " and " + SessionTable;
        if (Session[SessionTable] != null) Session[SessionTable] = null;
        if (Session[HeaderTable] != null) Session[HeaderTable] = null;
        return status;
    }


    #region Customer Validation
    public string cntCustName(string custNo)
    {
        DataTable dtCustomer = new DataTable();
        string tableName = "CustomerMaster";
        string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
        string whereClause = " CustName Like '" + custNo.Trim().Replace("%", "").Replace("'", "''") + "%'";
        DataSet dsCustomer = orderEntry.ExecuteERPSelectQuery(tableName, columnName, whereClause);

        if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
        {
            dtCustomer = dsCustomer.Tables[0];
            return dtCustomer.Rows[0]["totalcount"].ToString();
        }
        else
            return "0";
    }

    public string cntCustNo(string custNo)
    {
        DataTable dtCustomer = new DataTable();
        string tableName = "CustomerMaster";
        string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
        string whereClause = "[CustNo] Like '" + custNo.Trim().Replace("%", "").Replace("'", "''") + "%'";
        DataSet dsCustomer = orderEntry.ExecuteERPSelectQuery(tableName, columnName, whereClause);

        if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
        {
            dtCustomer = dsCustomer.Tables[0];
            return dtCustomer.Rows[0]["totalcount"].ToString();
        }
        else
            return "0";
    }

    public bool isNumeric(string val, System.Globalization.NumberStyles NumberStyle)
    {
        Double result;
        return Double.TryParse(val, NumberStyle,
            System.Globalization.CultureInfo.CurrentCulture, out result);
    }
    #endregion

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
        //ScriptManager.RegisterClientScriptBlock(POTextBox, POTextBox.GetType(), "PO", "SetHeight();", true);
    }


    /// <summary>
    /// BindSearchColumns : Bind search column
    /// </summary>
    /// <param name="searchColumnCaption"></param>
    /// <param name="searchColumnValue"></param>
    /// <param name="separator"></param>
    private void BindSearchColumns(string searchColumnCaption, string searchColumnValue, char separator)
    {

        string[] displayCaption = searchColumnCaption.Split(separator);
        string[] displayValue = searchColumnValue.Split(separator);
        for (int i = 0; i <= displayCaption.Length - 1; i++)
        {
            ListItem column = new ListItem(displayCaption[i], displayValue[i]);
            ddlSearchColumn.Items.Add(column);
        }
        ListItem allItem = new ListItem("--ALL--", "ALL");
        ddlSearchColumn.Items.Insert(0, allItem);


    }

    public void BindPrintDialog()
    {
        string RecallURL = ""; 
        PrintUpdatePanel.Visible = true;
        //string RecallURL = "QuoteRecallExport.aspx?CustNo=" + CustNoTextBox.Text;
        if (RecallPageMode.Value == "Recall")
        {
            PrintControl.CustomerNo = CustNoTextBox.Text;
            RecallURL = "QuoteExport.aspx?CustomerNumber=" + CustNoTextBox.Text;
            RecallURL += "&CustNo=" + CustNoTextBox.Text;
            RecallURL += "&QuoteNo=" + QuoteNoHidden.Value;
            PrintControl.PageTitle = "Porteous Fastener Co. Quote " + QuoteNoHidden.Value;
        }
        if (RecallPageMode.Value == "Review")
        {
            PrintControl.CustomerNo = ReviewCustNoLabel.Text;
            RecallURL = "QuoteExport.aspx?CustomerNumber=" + ReviewCustNoLabel.Text;
            RecallURL += "&CustNo=" + ReviewCustNoLabel.Text;
            RecallURL += "&QuoteNo=" + QuoteNoHidden.Value;
            PrintControl.PageTitle = "Porteous Fastener Co. Quote " + QuoteNoHidden.Value;
        }
        //if (QuoteNoHidden.Value != "")
        //{
        //}
        // we build a url according to what serach criterai they have entered. we may even sho line detail
        //Print.PageTitle = "Quote Recall List for " + CustNoTextBox.Text;
        PrintControl.PageUrl = RecallURL;
        PrintUpdatePanel.Update();
        //ShowPageMessage(RecallURL, 0);
    }
}
