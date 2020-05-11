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

public partial class ECommQuoteRecall : Page
{
    ECommQuotes ecommQuotes = new ECommQuotes();
    Common common = new Common();
    CustomerDetail custDet = new CustomerDetail();
    OrderEntry orderEntry = new OrderEntry();
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
    Label QOHLabel;
    Label LocLabel;
    Label PriceUMLabel;
    Label PriceGluedLabel;
    Label MarginPcntLabel;
    LinkButton ItemLink;
    Label CarrierCdLabel;
    Label FreightCdLabel;
    LinkButton QOHLink;
    CheckBox LineSelector;
    HiddenField QuoteID;
    HiddenField GridUpdatedFlag;
    HiddenField GridOrderSource;
    HiddenField GridMakeBy;
    TextBox PriceBox;
    TextBox MarginPcntBox;
    TextBox ReqQtyBox;
    Label ReqQtyLabel;
    GridViewRow row;

    protected void Page_Init(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //QuoteNoHidden.Value = "";
            //CommentsPanel.Visible = false;
            //UpdateButton.Visible = false;
            //UpdateUpdatePanel.Update();
            RecallPageMode.Value = "Recall";
            HeaderTableName.Value = "QuoteHeaderTable";
            DetailTableName.Value = "QuoteDetailTable";
            //DetailSortField.Value = "QuoteNumber";
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
                WorkCustomerNumber(sender, e);
                if (Request.QueryString["QuoteNo"] != null && Request.QueryString["QuoteNo"].ToString().Length > 0)
                {
                    // Here we are reviewing a single quote
                    RecallPageMode.Value = "Review";
                    //QuoteNoHidden.Value = Request.QueryString["QuoteNo"].ToString();
                    //DetailFilterFieldHidden.Value = "QuoteNumber";
                    //DetailFilterValueHidden.Value = QuoteNoHidden.Value;
                    HeaderTableName.Value = "Quote" + Request.QueryString["QuoteNo"].ToString() + "HeaderTable";
                    DetailTableName.Value = "Quote" + Request.QueryString["QuoteNo"].ToString() + "ReviewTable";
                    //this.Title = "Quote " + QuoteNoHidden.Value + " Review";
                    //DetailGridHeightHidden.Value = "600";
                    //SingleQuoteDetail = true;
                    //CheckAll = false;
                    GetCustQuotes(Request.QueryString["Cust"].ToString());
                    ShowQuotesDetail(Request.QueryString["Cust"].ToString(), Request.QueryString["QuoteNo"].ToString(), null);
                    //if (dt.Rows.Count > 0) ReviewCustNameLabel.Text = dt.Rows[0]["CustomerName"].ToString();
                    //BindPrintDialog();
                    //ECommQuoteRecallScriptManager.SetFocus("POTextBox");
                }
                else
                {
                    GetCustQuotes(Request.QueryString["Cust"].ToString());
                }
            }
            else
            {
                ECommQuoteRecallScriptManager.SetFocus("CustNoTextBox");
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            // Initializing AJAX.NET Library 
            Ajax.Utility.RegisterTypeForAjax(typeof(ECommQuoteRecall));
        }
        catch (Exception e2)
        {
            ShowPageMessage("PageLoad Error " + HttpContext.Current.User.Identity.Name.ToString() + ", " + e2.ToString(), 2);
        }
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
        //        ECommQuoteRecallScriptManager.SetFocus("ddlSearchColumn");
        //        GetQuotes(CustNoTextBox.Text, "", "", "Header");
        //    }
        //    else
        //    {
        //        ShowPageMessage(CustNoTextBox.Text + " Not Found", 2);
        //        ECommQuoteRecallScriptManager.SetFocus("CustNoTextBox");
        //    }
        //}
        //else
        //{
        //    ShowPageMessage(CustNoTextBox.Text + " Not Found", 2);
        //    HeaderUpdatePanel.Update();
        //    ECommQuoteRecallScriptManager.SetFocus("CustNoTextBox");
        //}
    }

    protected void GetCustQuotes(string CustNo)
    {
        ClearGrids();
        ds = ecommQuotes.GetCustSummary(CustNo);
        if (ds.Tables.Count == 1)
        {
            // Fill the date grid, then the quotes for the first date
            dt = ds.Tables[0];
            if (dt.Rows.Count > 0)
            {
                DateGridView.DataSource = dt;
                DateGridView.DataBind();
                ShowQuotesSummary(CustNo, dt.Rows[0]["QuoteDate"]);

            }
            else
            {
                ShowPageMessage("No Quotes on file for Customer " + CustNo, 2);
            }
        }
        else
        {
            ShowPageMessage("Quote access problem (GetSummary). " + CustNo, 2);
        }
    }

    protected void ShowQuotesSummary(string CustNo, object QuoteDate)
    {
        FilterShowingLabel.Text = string.Format("{0:MM/dd/yyyy}", QuoteDate);
        ds = ecommQuotes.GetDateSummary(CustNo, string.Format("{0:MM/dd/yyyy}", QuoteDate));
        QuoteGridView.DataSource = ds.Tables[0];
        QuoteGridView.DataBind();
        Session[HeaderTableName.Value] = ds.Tables[0];
    }


    protected void ShowQuotesDetail(string CustNo, string QuoteNo, object QuoteDate)
    {
        if (QuoteNo == null)
        {
            ds = ecommQuotes.GetDateDetail(CustNo, string.Format("{0:MM/dd/yyyy}", QuoteDate));
            CurShowQuote.Value = "";
        }
        else
        {
            ds = ecommQuotes.GetQuoteDetail(CustNo, QuoteNo);
            CurShowQuote.Value = QuoteNo;
        }
        RefreshDetailGrid(ds.Tables[0]);
        ScriptManager.RegisterClientScriptBlock(CustNoTextBox, CustNoTextBox.GetType(), "Find", "SetHeight();", true);
    }

    protected void RefreshDetailGrid(DataTable DetailData)
    {
        DataView lineView = new DataView();
        DetailGridView.DataSource = DetailData;
        DetailGridView.DataBind();
        QuoteDetailUpdatePanel.Update();
        Session[DetailTableName.Value] = DetailData;
        if (DetailData.Rows.Count > 0)
        {
            //UpdateButton.Visible = true;
            //UpdateUpdatePanel.Update();
        }
        else
        {
            ShowPageMessage("No Quote Detail.", 2);
            MessageUpdatePanel.Update();
        }
    }

    protected void ClearGrids()
    {
        DateGridView.DataBind();
        QuoteGridView.DataBind();
        FilterShowingLabel.Text = "";
        HeaderUpdatePanel.Update();
        DetailGridView.DataBind();
        QuoteDetailUpdatePanel.Update();
        //UpdateButton.Visible = false;
        //UpdateUpdatePanel.Update();
    }

    //protected void UpdateButton_Click(object sender, EventArgs e)
    //{
    //    UpdateButton.Visible = false;
    //    UpdateUpdatePanel.Update();
    //    int UpdatedCount = 0;
    //    dt = (DataTable)Session[DetailTableName.Value];
    //    foreach (DataRow dr in dt.Rows)
    //    {
    //        if (dr["Checked"].ToString() == "True")
    //        {
    //            ds = ecommQuotes.UpdatePrice(dr["QuoteNumber"].ToString(), dr["AltPrice"].ToString(), dr["UnitPrice"].ToString());
    //            UpdatedCount++;
    //        }
    //    }
    //    ShowPageMessage(UpdatedCount.ToString() + " quote lines updated." , 0);
    //}

    protected void DetailClearAll_Click(object sender, EventArgs e)
    {
        dt = (DataTable)Session[DetailTableName.Value];
        for (int cctr = 0; cctr < dt.Rows.Count; cctr++)
        {
            dt.Rows[cctr]["MakeOrder"] = false;
        }
        Session[DetailTableName.Value] = dt;
        RefreshDetailGrid(dt);
    }

    protected void DetailCheckAll_Click(object sender, EventArgs e)
    {
        CheckAll = true;
    }

    protected void QuoteDaysCommand(Object sender, GridViewCommandEventArgs e)
    {
        ClearPageMessages();
        // get the day they asked for
        if (e.CommandName == "ShowDay")
        {
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = DateGridView.Rows[index];
            ShowQuotesSummary(CustNoTextBox.Text.ToString(), Server.HtmlDecode(row.Cells[0].Text));
            CurShowDate.Value = Server.HtmlDecode(row.Cells[0].Text);
            ScriptManager.RegisterClientScriptBlock(CustNoTextBox, CustNoTextBox.GetType(), "Find", "SetHeight();", true);
        }
        // show all lines for the day in the detail grid
        if (e.CommandName == "ShowLines")
        {
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = DateGridView.Rows[index];
            ShowQuotesDetail(CustNoTextBox.Text.ToString(), null, Server.HtmlDecode(row.Cells[0].Text));
        }
    }

    protected void QuoteSummCommand(Object sender, GridViewCommandEventArgs e)
    {
        // show all lines for the day in the detail grid
        if (e.CommandName == "ShowDetail")
        {
            int index = Convert.ToInt32(e.CommandArgument);
            GridViewRow row = QuoteGridView.Rows[index];
            ShowQuotesDetail(CustNoTextBox.Text.ToString(), Server.HtmlDecode(row.Cells[0].Text).ToString(), null);
            ScriptManager.RegisterClientScriptBlock(CustNoTextBox, CustNoTextBox.GetType(), "Find", "SetHeight();", true);
        }
    }

    protected void DetailRowBound(Object sender, GridViewRowEventArgs e)
    {
        try
        {
            //// allow price editing if Order Source <> IX
            row = e.Row;
            if (row.RowType == DataControlRowType.DataRow)
            {
                // line formatting
                ItemLink = (LinkButton)row.Cells[2].Controls[1];
                PriceBox = (TextBox)row.Cells[8].Controls[1];
                PriceUMLabel = (Label)row.Cells[8].Controls[3];
                PriceGluedLabel = (Label)row.Cells[8].Controls[5];
                MarginPcntBox = (TextBox)row.Cells[11].Controls[1];
                MarginPcntLabel = (Label)row.Cells[11].Controls[3];
                GridOrderSource = (HiddenField)row.Cells[12].Controls[7];
                GridUpdatedFlag = (HiddenField)row.Cells[12].Controls[5];
                LineSelector = (CheckBox)row.Cells[12].Controls[1];
                if (GridUpdatedFlag.Value=="True")
                {
                    LineSelector.Checked = true;
                }
                if (GridOrderSource.Value.ToString() == "IX")
                {
                    PriceBox.Visible = false;
                    PriceUMLabel.Visible = false;
                    MarginPcntBox.Visible = false;
                    PriceGluedLabel.Visible = true;
                    MarginPcntLabel.Visible = true;
                }
                else
                {
                    PriceBox.Visible = true;
                    PriceUMLabel.Visible = true;
                    MarginPcntBox.Visible = true;
                    PriceGluedLabel.Visible = false;
                    MarginPcntLabel.Visible = false;
                }
                string LinkCommand = "";
                if (Session["UserName"] == null)
                {
                    // if we don't have the session variables, we shunt to a page that will give them to us
                    LinkCommand = "return ShowStockStatus('";
                    LinkCommand += Server.HtmlDecode(ItemLink.Text) + "','No');";
                    ItemLink.OnClientClick = LinkCommand;
                }
                else
                {
                    LinkCommand = "return ShowStockStatus('";
                    LinkCommand += Server.HtmlDecode(ItemLink.Text) + "','Yes');";
                    ItemLink.OnClientClick = LinkCommand;
                }
            }
        }
        catch (Exception e2)
        {
            ShowPageMessage("FillGrid Error " + e2.Message + ", " + e2.ToString(), 2);
        }
    }

    public void DetailRefresh_Click(object sender, EventArgs e)
    {
        RefreshDetailGrid((DataTable)Session[DetailTableName.Value]);
        ScriptManager.RegisterClientScriptBlock(CustNoTextBox, CustNoTextBox.GetType(), "Find", "SetHeight();", true);
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
        try
        {
            ClearPageMessages();
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
                        if (dsCustomer.Tables[0].Columns.Contains("ErrorMessage"))
                        {
                            ScriptManager.RegisterClientScriptBlock(CustNoTextBox, typeof(TextBox), "invalid", "alert('" + dsCustomer.Tables[0].Rows[0]["ErrorMessage"].ToString() + "');", true);
                            ECommQuoteRecallScriptManager.SetFocus("CustNoTextBox"); 
                            return;
                        }
                        else
                        {
                            string creditStatus = "";
                            if (dsCustomer.Tables[0].Rows[0]["CustCd"].ToString() != "BT" && dsCustomer.Tables[0].Rows[0]["fBillToNo"].ToString() != "")
                            {

                                creditStatus = orderEntry.GetCreditReview(dsCustomer.Tables[0].Rows[0]["fBillToNo"].ToString().ToString(), dsCustomer.Tables[2].Rows[0]["CreditInd"].ToString().Trim(), "0", "Order");
                                if (creditStatus.ToUpper() != "OK")
                                {
                                    ScriptManager.RegisterClientScriptBlock(CustNoTextBox, typeof(TextBox), "invalid", "alert('" + creditStatus + "');", true);
                                    ECommQuoteRecallScriptManager.SetFocus("CustNoTextBox");
                                    return;
                                }
                            }
                            else
                            {
                                //ISBillToCustomer = true;
                                ScriptManager.RegisterClientScriptBlock(CustNoTextBox, typeof(TextBox), "invalid", "alert('Bill To Only Customer could not process order');document.getElementById('" + CustNoTextBox.ClientID + "').value='';document.getElementById('" + CustNoTextBox.ClientID + "').focus();document.getElementById('" + CustNoTextBox.ClientID + "').select();", true);
                                ECommQuoteRecallScriptManager.SetFocus("CustNoTextBox");
                                return;
                            }
                            Session[HeaderTableName.Value] = null;
                            CustNameLabel.Text = dsCustomer.Tables[2].Rows[0]["Name"].ToString();
                            HeaderUpdatePanel.Update();
                            GetCustQuotes(CustNoTextBox.Text);
                        }
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
        catch (Exception e2)
        {
            ShowPageMessage("WorkCustomerNumber Error " + e2.ToString(), 2);
        }
    }

    public void SortDetailGrid(Object sender, GridViewSortEventArgs e)
    {
        try
        {
            // Create a DataView from the Quote Detail DataTable.
            string LineFilter;
            DataView dv = new DataView((DataTable)Session[DetailTableName.Value]);
            dv.Sort = e.SortExpression;
            DetailSortField.Value = e.SortExpression;
            //dv.RowFilter = LineFilter;
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
        //DataView dv = new DataView((DataTable)Session[DetailTableName.Value]);
        // Create a DataView from the Quote Detail DataTable.
        try
        {
            string LineFilter;
            DataView dv = new DataView((DataTable)Session[DetailTableName.Value]);
            dv.Sort = DetailSortField.Value;
            //dv.RowFilter = LineFilter;
            DetailGridView.DataSource = dv;
            DetailGridView.PageIndex = e.NewPageIndex;
            DetailGridView.DataBind();
            DetailGridPanel.Height = Unit.Pixel(int.Parse(DetailGridHeightHidden.Value));
            DetailGridPanel.Width = Unit.Pixel(int.Parse(DetailGridWidthHidden.Value));
            QuoteDetailUpdatePanel.Update();
        }
        catch (Exception e2)
        {
            ShowPageMessage("Paging Error " + DetailGridHeightHidden.Value.ToString() + " : " + e2.ToString(), 2);
        }
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdLinePrice(string LineQuoteNo, string NewPrice, string UOM, string SessionTable, string HeaderTable)
    {
        string status = LineQuoteNo;
        string SessionID;
        decimal AltPrice = decimal.Parse(NewPrice, NumberStyles.Number);
        decimal UnitPrice = 0;
        decimal MarginPcnt = 0;
        try
        {
            // we update the detail table with the new price. 
            DataTable tempDt = (DataTable)Session[SessionTable];
            DataRow[] QuoteRow = tempDt.Select("QuoteNumber = '" + LineQuoteNo + "'");
            QuoteRow[0]["AltPrice"] = AltPrice;
            if (QuoteRow[0]["PriceUOM"].ToString() == "M")
            {
                UnitPrice = AltPrice * (decimal)QuoteRow[0]["BaseUOMQty"] / 1000;
            }
            if (QuoteRow[0]["PriceUOM"].ToString() == "C")
            {
                UnitPrice = AltPrice * (decimal)QuoteRow[0]["BaseUOMQty"] / 100;
            }
            if (QuoteRow[0]["PriceUOM"].ToString() == "CWT")
            {
                UnitPrice = AltPrice / (100 / (decimal)QuoteRow[0]["BaseUOMQty"]) ;
            }
            if (QuoteRow[0]["PriceUOM"].ToString() == "CFT")
            {
                UnitPrice = (AltPrice / 100) * (decimal)QuoteRow[0]["BaseUOMQty"];
            }
            QuoteRow[0]["UnitPrice"] = UnitPrice;
            if (UnitPrice != 0)
            {
                // avoid a divide by zero
                MarginPcnt = 100 * (UnitPrice - (decimal)QuoteRow[0]["UnitCost"]) / UnitPrice;
            }
            ////status += " was " + QuoteRow[0]["AltPrice"].ToString();

            status = string.Format("{0:####,###,##0.00}", AltPrice);
            QuoteRow[0]["TotalPrice"] = (decimal)QuoteRow[0]["RequestQuantity"] * UnitPrice;
            status += ":" + string.Format("{0:####,###,##0.00}", QuoteRow[0]["TotalPrice"]);
            QuoteRow[0]["MarginDollars"] = (decimal)QuoteRow[0]["RequestQuantity"] * (UnitPrice - (decimal)QuoteRow[0]["UnitCost"]);
            status += ":" + string.Format("{0:####,###,##0.00}", QuoteRow[0]["MarginDollars"]);
            QuoteRow[0]["MarginPcnt"] = MarginPcnt;
            status += ":" + string.Format("{0:####,###,##0.00}", MarginPcnt);
            QuoteRow[0]["Checked"] = "True";
            ds = ecommQuotes.UpdatePrice(LineQuoteNo, QuoteRow[0]["AltPrice"].ToString(), QuoteRow[0]["UnitPrice"].ToString());
            Session[SessionTable] = tempDt;
            //SessionID = QuoteRow[0]["SessionID"].ToString();
            //////status += ". Qty set to " + NewQty;
            //object sumAmountObject, sumMarginObject;
            //sumAmountObject = tempDt.Compute("Sum(TotalPrice)", "SessionID ='" + SessionID + "' and DeleteFlag = 0");
            //status += ":" + string.Format("{0:####,###,##0.00}", sumAmountObject);
            //sumMarginObject = tempDt.Compute("Sum(MarginDollars)", "SessionID ='" + SessionID + "' and DeleteFlag = 0");
            //status += ":" + string.Format("{0:####,###,##0.00}", sumMarginObject);
            // now do the header table
            //tempDt = (DataTable)Session[HeaderTable];
            //QuoteRow = tempDt.Select("Quote = '" + SessionID + "'");
            //QuoteRow[0]["QuoteAmount"] = sumAmountObject;
            ////QuoteRow[0]["UnitPrice"] = UnitPrice;
            ////QuoteRow[0]["TotalPrice"] = (decimal)QuoteRow[0]["RequestQuantity"] * UnitPrice;
            ////QuoteRow[0]["MarginDollars"] = (decimal)QuoteRow[0]["RequestQuantity"] * (UnitPrice - (decimal)QuoteRow[0]["UnitCost"]);
            ////QuoteRow[0]["MarginPcnt"] = MarginPcnt;
            //Session[HeaderTable] = tempDt;

            return status;
        }
        catch (Exception e2)
        {
            return "!!" + e2.ToString();
        }
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdLineMargin(string LineQuoteNo, string NewMargin, string UOM, string SessionTable, string HeaderTable)
    {
        string status = LineQuoteNo;
        decimal AltPrice = 0;
        decimal UnitPrice = 0;
        decimal MarginPcnt = decimal.Parse(NewMargin, NumberStyles.Number);
        try
        {
            // we update the detail table with the new margin. 
            DataTable tempDt = (DataTable)Session[SessionTable];
            DataRow[] QuoteRow = tempDt.Select("QuoteNumber = '" + LineQuoteNo + "'");
            QuoteRow[0]["MarginPcnt"] = MarginPcnt;
            if (MarginPcnt != 0)
            {
                // avoid a divide by zero
                UnitPrice = ((1 / (1 - (MarginPcnt / 100))) * (decimal)QuoteRow[0]["UnitCost"]);
            }
            else
            {
                UnitPrice = (decimal)QuoteRow[0]["UnitCost"];
            }
            if (QuoteRow[0]["PriceUOM"].ToString() == "M")
            {
                AltPrice = (UnitPrice / (decimal)QuoteRow[0]["BaseUOMQty"]) * 1000;
            }
            if (QuoteRow[0]["PriceUOM"].ToString() == "C")
            {
                AltPrice = (UnitPrice / (decimal)QuoteRow[0]["BaseUOMQty"]) * 100;
            }
            if (QuoteRow[0]["PriceUOM"].ToString() == "CWT")
            {
                AltPrice = UnitPrice * (100 / (decimal)QuoteRow[0]["BaseUOMQty"]);
            }
            if (QuoteRow[0]["PriceUOM"].ToString() == "CFT")
            {
                AltPrice = (UnitPrice / (decimal)QuoteRow[0]["BaseUOMQty"]) * 100;
            }
            QuoteRow[0]["UnitPrice"] = UnitPrice;
            QuoteRow[0]["AltPrice"] = AltPrice;
            status = string.Format("{0:####,###,##0.00}", AltPrice);
            QuoteRow[0]["TotalPrice"] = (decimal)QuoteRow[0]["RequestQuantity"] * UnitPrice;
            status += ":" + string.Format("{0:####,###,##0.00}", QuoteRow[0]["TotalPrice"]);
            QuoteRow[0]["MarginDollars"] = (decimal)QuoteRow[0]["RequestQuantity"] * (UnitPrice - (decimal)QuoteRow[0]["UnitCost"]);
            status += ":" + string.Format("{0:####,###,##0.00}", QuoteRow[0]["MarginDollars"]);
            status += ":" + string.Format("{0:####,###,##0.00}", MarginPcnt);
            QuoteRow[0]["Checked"] = "True";
            ds = ecommQuotes.UpdatePrice(LineQuoteNo, QuoteRow[0]["AltPrice"].ToString(), QuoteRow[0]["UnitPrice"].ToString());
            Session[SessionTable] = tempDt;
            ////status += " was " + QuoteRow[0]["AltPrice"].ToString();
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


}
