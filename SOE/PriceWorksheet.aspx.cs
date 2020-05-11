using System;
using System.Collections.Specialized;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.SOE;
using PFC.SOE.DataAccessLayer;
using PFC.SOE.BusinessLogicLayer;
using System.Drawing;

public partial class SOEPriceWorksheet : System.Web.UI.Page
{

    #region Variables
    CustomerDetail custDet = new CustomerDetail();
    OrderEntry orderEntry = new OrderEntry();
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    int WSTextBoxWidth = 60;
    private string NumFieldFormat = "{0:#########0.00000}, ";
    private string IntFieldFormat = "{0:#########0}, ";
    private string StringFieldFormat = "'{0}', ";
    private string DateFieldFormat = "'{0:MM/dd/yy}', ";
    private string Num0Format = "{0:####,###,##0} ";
    private string Num1Format = "{0:####,###,##0.0} ";
    private string Num2Format = "{0:####,###,##0.00} ";
    private string Num3Format = "{0:####,###,##0.000} ";
    private string Num4Format = "{0:####,###,##0.0000} ";
    private string DollarFormat = "${0:#,##0.00} ";
    private string Dollar3Format = "${0:#,##0.000} ";
    private string PcntFormat = "{0:#,##0.0}% ";
    private string DateFormat = "{0:MM/dd/yy} ";
    private string ControlAfterQty = "SellPriceTextBox";
    decimal ItemWeight;
    decimal ItemSellPrice;
    decimal eComItemSellPrice;
    int LineQty;
    int LineQOH;
    int NewLineNumber;
    int NewQuoteLineNumber;
    bool LineError;
    bool LineFixed;
    decimal MainCost;
    decimal StdCost;
    decimal ReplCost;
    decimal MainMargin;
    decimal StdMargin;
    decimal ReplMargin;    
    decimal SellLB;
    decimal MarginLB;
    decimal TargetMarginLB;
    decimal ListPrice;
    decimal DiscountPcnt;
    decimal DiscountPrice;
    decimal AltPrice;
    decimal AltQty;
    decimal UnitQty;
    decimal LineCost;
    decimal LinePrice;
    decimal LineGrossWeight;
    decimal LineNetWeight;
    decimal SuperDiscount;
    string UOMText;
    string Qtytext;
    string whereClause = "";
    string ImageLibrary = ConfigurationManager.AppSettings["ProductImagesPath"].ToString();
    bool QtySubmittedBySubtituteItem = false;
    string OPERATINGMODE = "full";
    #endregion

    #region Insert Columns
    private string DetailColumnNames = "LineNumber, LineSeq, LineType, LinePriceInd, LineReason, LineReasonDsc, " +
        "LineExpdCd, LineExpdCdDsc, ItemNo, ItemDsc, BinLoc, IMLoc, IMLocName, " +
        "CostInd, PriceCd, LISource, QtyStat, ComPct, ComDol, NetUnitPrice, ListUnitPrice, DiscUnitPrice, DiscPct1, DiscPct2, " +
        "DiscPct3, QtyAvailLoc1, QtyAvail1, QtyAvailLoc2, QtyAvail2, QtyAvailLoc3, QtyAvail3, OrigOrderLineNo, RqstdShipDt, OrigShipDt, " +
        "SuggstdShipDt, " +
        "OriginalQtyRequested, QtyOrdered, QtyShipped, QtyBO, SellStkUM, SellStkFactor, " +
        "UnitCost, UnitCost2, UnitCost3, RepCost, OECost, Remark, CustItemNo, CustItemDsc, EntryDate, EntryID, StatusCd, " +
        "GrossWght, NetWght, ExtendedPrice, ExtendedCost, ExtendedNetWght, ExtendedGrossWght, SellStkQty, AlternateUM, " +
        "AlternateUMQty, SuperEquivUM, SuperEquivQty, QtyStatus, ExcludedFromUsageFlag, AlternatePrice, CarrierCd, CertRequiredInd, FreightCd";
    private string QuoteColumnNames = " UserID, CustomerNumber, CustomerName, UserItemNo, " +
        "PFCItemNo, Description, RequestQuantity, AvailableQuantity, PriceUOM, BaseUOM, BaseUOMQty, AlternateUOM, AlternateUOMQty, " +
        "GrossWeight, Weight, UnitPrice, LocationCode, LocationName, TotalPrice, RequestorQuoteRemarks, OrderCompletionStatus, " +
        "QuoteConfirmStatus, AltPrice, AltPriceUOM, DeleteFlag, Status, RemoveFlag, SalesLocationCode, OrderCarrier, OrderCarName, " +
        "OrderFreightCd, OrderFreightName, EntryID, EntryDt, ContactName, InitialRequestQty, InitialLocationCode, InitialAvailableQty, " +
        "CertRequiredInd, OrderSource, UnitCost ";
    #endregion

    #region Properties
    // Properties
    private int quote_expiry = 14;
    private decimal sell_multiplier = 0;
    private DataTable remote_qtys;
    private string promoCd = "";

    public int QuoteExpiry
    {
        get
        {
            return (int)ViewState["quote_expiry"];
        }
        set
        {
            ViewState["quote_expiry"] = value;
        }
    }

    public decimal SellMultiplier
    {
        get
        {
            return (ViewState["sell_multiplier"]!=null) ? (decimal)ViewState["sell_multiplier"] : 1;
        }
        set
        {
            ViewState["sell_multiplier"] = value;
        }
    }
    #endregion

    // Methods
    protected void Page_Init(object sender, EventArgs e)
    {
        // we have 2 modes of operation: Order processing or quick quoting
        // in order processing, we use session variables to get the data to make the prices
        // in quickquoting, we ask for the customer data to make the prices
        // first chack an see if there is a session varaible that indicates quick quoting
        QuickQuote.Value = "0";
        QuoteRecall.Value = "0";
        NoSKUOnFile.Value = "0";
        DisableEntry(true);
        // Load NameValueCollection object.
        QQInfoPanel.Visible = false;
        ReviewQuoteButton.Visible = false;
        TermsNameLabel.Visible = false;
        TermsDescLabel.Visible = false;
        TargetMargin.Value = GetAppPref("MarginLB");
        MinMargin.Value = GetAppPref("MinMargin");
        MaxMargin.Value = GetAppPref("MaxMargin");
        UseRemoteQtys.Value = "";
        RemoteDataTextBox.Text = "";
        CameraButt.Visible = false;
        HistoryButt.Visible = false;
        PackPlateButt.Visible = false;
        HeadImageUpdatePanel.Visible = false;
        BodyImageUpdatePanel.Visible = false;
        WorkSellPriceTextBox.Width = WSTextBoxWidth;
        MgnCostTextBox.Width = WSTextBoxWidth;
        //MgnStdTextBox.Width = WSTextBoxWidth;
        MgnReplTextBox.Width = WSTextBoxWidth;
        SellLBTextBox.Width = WSTextBoxWidth;
        MarginLBTextBox.Width = WSTextBoxWidth;
        AddXrefCheckBox.Enabled = false;
        ItemColor.Value = "0";
        LineAdded.Value = "LineAdded";

        if(!Page.IsPostBack)
            chkFastEntry.Visible = IsUserHasSecurity("SOEWSFE");
        
        if (Request.QueryString["OperateMode"] != null)
        {
            OPERATINGMODE = Request.QueryString["OperateMode"].ToString().ToLower();
        }

        if (Request.QueryString["QuickQuote"] != null)
        {
            //We have been called to do a quick quote, prompt for Customer, Item 
            QuickQuote.Value = "1";
            ItemPanel.CssClass = "quoting";
            OrderNumber.Value = "-1";
            chkFastEntry.Visible = false;
            if (Request.QueryString["Instance"] != null)
            {
                LineAdded.Value = "LineAdded" + Request.QueryString["Instance"].ToString();
            }
            else
            {
                LineAdded.Value = "LineAddedQQ1";
            }
            if (CustNameLabel.Text.Trim().Length == 0)
            {
                this.Title = "QuickQuote";
            }
            else
            {
                this.Title = CustNameLabel.Text;
            }
            QuoteExpiry = int.Parse(GetAppPref("QOT", "QuoteExpiry"));
            QuoteLineNo.Value = "10";
            NewQuoteLineNumber = int.Parse(QuoteLineNo.Value);
            LocationDropDownList.DataSource = custDet.GetLocationDetails();
            LocationDropDownList.DataBind();
            LocationDropDownList.Visible = true;
            ShipFromLabel.Visible = false;
            TermsNameLabel.Visible = true;
            TermsDescLabel.Visible = true;
            CarrierDropDownList.DataSource = custDet.GetCarrierList();
            CarrierDropDownList.DataBind();
            FreightDropDownList.DataSource = orderEntry.ExecuteERPSelectQuery("Tables", @"TableCd as Code,TableCd+' - '+ShortDsc as Name", @"TableType='FGHT' and SOApp='Y'").Tables[0];
            FreightDropDownList.DataBind();
            QQInfoPanel.Visible = true;
        }
        if (Request.QueryString["QuoteRecall"] != null)
        {
            //We have been called to do recall a quote, get the data and fill
            QuoteRecall.Value = "1";
            QuoteNumber.Value = Request.QueryString["QuoteRecall"].ToString();
            QuoteNumberLabel.Text = QuoteNumber.Value;
            if (Request.QueryString["NextLineNo"] != null) QuoteLineNo.Value = Request.QueryString["NextLineNo"].ToString();
            LineAdded.Value = "LineAddedQRecall" + QuoteNumber.Value.ToString();
            CustNoTextBox.Text = Request.QueryString["CustNo"].ToString();
            ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetQuoteCust",
                     new SqlParameter("@customer", CustNoTextBox.Text.Trim()));
            CustValid.Value = "1";
            CustNameLabel.Text = ds.Tables[0].Rows[0]["CustName"].ToString();
            ShippingBranch.Value = ds.Tables[0].Rows[0]["CustShipLocation"].ToString();
            if (ds.Tables[0].Rows[0]["CertRequiredInd"].ToString().Trim() == "1")
            {
                CustCertRequiredInd.Value = "TRUE";
            }
            else
            {
                CustCertRequiredInd.Value = "FALSE";
            }
            LocationDropDownList.DataSource = custDet.GetLocationDetails();
            LocationDropDownList.DataBind();
            LocationDropDownList.SelectedValue = ShippingBranch.Value;
            LocationDropDownList.Visible = true;
            TermsNameLabel.Visible = true;
            TermsDescLabel.Visible = true;
            TermsDescLabel.Text = ds.Tables[0].Rows[0]["TermsDesc"].ToString().Substring(0, Math.Min(ds.Tables[0].Rows[0]["TermsDesc"].ToString().Length, 18));
            ReviewQuoteButton.Visible = true;
            ShipFromLabel.Visible = false;
            SetImageDisplay();
            LocName.Value = ds.Tables[0].Rows[0]["LocName"].ToString();
            HeadingPriceCodeLabel.Text = ds.Tables[0].Rows[0]["PriceCode"].ToString();
            SetWebCust(ds.Tables[0].Rows[0]["PriceCode"].ToString());
            //ItemUpdatePanel.Update();
            this.Title = "Add Quote Line";
            if (Request.QueryString["QuoteLine"] != null)
            {
                // we got passed a line so we allow it to be fixed
                QuoteLineNo.Value = Request.QueryString["QuoteLine"].ToString();
                QuoteFix.Value = "1";
                LineAdded.Value = "LineAddedQFix" + QuoteNumber.Value.ToString();
                this.Title = "Quote Fix";
                DataTable dtFix = new DataTable();
                ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetQuotes",
                   new SqlParameter("@Organization", Request.QueryString["CustNo"].ToString()),
                   new SqlParameter("@QuoteFilterField", "QuoteNumber"),
                   new SqlParameter("@QuoteFilterValue", QuoteLineNo.Value),
                   new SqlParameter("@FreshQOH", "4"));
                dtFix = ds.Tables[1];
                CustomerItemTextBox.Text = dtFix.Rows[0]["PFCItemNo"].ToString();
                //Session["ItemNo"] = dtFix.Rows[0]["PFCItemNo"].ToString();
                CustomerItemTextBox.Enabled = false;
                if (CustomerItemTextBox.Text.ToString().ToUpper() == "COMMENT")
                {
                    CommentEntry.Value = "1";
                    StartCommentEntry();
                    LineItemCommentTextBox.Text = dtFix.Rows[0]["Notes"].ToString();
                    //ItemUpdatePanel.Update();
                }
                else
                {
                    FindItem("PFC", CustomerItemTextBox.Text + " Not Found");
                    if (dtFix.Rows[0]["CertRequiredInd"].ToString().Trim() == "1")
                    {
                        ItemCertsReqdCheckBox.Checked = true;
                    }
                    else
                    {
                        ItemCertsReqdCheckBox.Checked = false;
                    }
                    RequestedQtyTextBox.Text = FormatScreenData(Num0Format, dtFix.Rows[0]["RequestQuantity"]);
                    CurQty.Value = RequestedQtyTextBox.Text.Replace(",", "").Trim().ToUpper();
                    OriginalPrice.Value = dtFix.Rows[0]["UnitPrice"].ToString();
                    QtyToSellLabel.Text = FormatScreenData(Num0Format, dtFix.Rows[0]["RequestQuantity"]) + "/" + ContUOM.Value;
                    CarrierDropDownList.SelectedValue = dtFix.Rows[0]["OrderCarrier"].ToString();
                    FreightDropDownList.SelectedValue = dtFix.Rows[0]["OrderFreightCd"].ToString();

                    ds = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEGetPrice]",
                                                new SqlParameter("@orderid", -1),
                                                new SqlParameter("@v_order_line_no", -1),
                                                new SqlParameter("@PassedItemNo", dtFix.Rows[0]["PFCItemNo"].ToString()),
                                                new SqlParameter("@PassedSellToCustNo", Request.QueryString["CustNo"].ToString()),
                                                new SqlParameter("@PassedShipLoc", ShippingBranch.Value.ToString()),
                                                new SqlParameter("@PassedHdrTable", "SOHeader"),
                                                new SqlParameter("@PassedDetTable", "SODetail"),
                                                new SqlParameter("@PassedQty", dtFix.Rows[0]["RequestQuantity"]),
                                                new SqlParameter("@PassedPrice", dtFix.Rows[0]["AltPrice"]),
                                                new SqlParameter("@PassedOrigin", "E"),
                                                new SqlParameter("@v_price_code", HeadingPriceCodeLabel.Text.ToString()),
                                                new SqlParameter("@Param1", "WQ"),
                                                new SqlParameter("@Param2", "SOE"),
                                                new SqlParameter("@Param3", ""),
                                                new SqlParameter("@Param4", ""),
                                                new SqlParameter("@Param5", ""),
                                                new SqlParameter("@Param6", "0"),
                                                new SqlParameter("@Param7", "0"),
                                                new SqlParameter("@Param8", "0"),
                                                new SqlParameter("@Param9", "0"),
                                                new SqlParameter("@Param10", "0"));
                    
                    dt = ds.Tables[1];

                    string SOEPrice = dt.Rows[0]["SOEPromoPrice"].ToString();
                    string SOEAltPrice = dt.Rows[0]["SOEPromoAltSellPrice"].ToString();
                    //PriceOriginLabel.Text = dt.Rows[0]["ErrorCode"].ToString();
                    PriceOriginLabel.Text = dt.Rows[0]["PriceOrigin"].ToString();
                    PriceOriginHidden.Value = dt.Rows[0]["PriceOrigin"].ToString();
                    CostMethod.Value = dt.Rows[0]["CostMethod"].ToString();
                    OECost.Value = dt.Rows[0]["OECost"].ToString();
                    AltUOMQty.Value = dt.Rows[0]["AltUOMQty"].ToString();
                    string avgCost = (Convert.ToInt32(dt.Rows[0]["StdCost"]) != 0 ? dt.Rows[0]["StdCost"].ToString() : dt.Rows[0]["AvgCost"].ToString());
                    AvgCostText.Text = FormatScreenData(Num3Format, InSellUM(avgCost));
                    AvgCostHidden.Value = avgCost;
                    StdCostText.Text = FormatScreenData(Num3Format, dt.Rows[0]["IBPriceCost"]);
                    StdCostHidden.Value = InContUM(dt.Rows[0]["IBPriceCost"]).ToString();
                    SellPriceTextBox.Text = FormatScreenData(Num2Format, SOEAltPrice);
                    lblTargetPrice.Text = "$" + FormatScreenData(Num2Format, dt.Rows[0]["AltSellPrice"]);
                    ContPriceLabel.Text = FormatScreenData(Num2Format, SOEPrice) + "/" + ContUOM.Value;
                    SuperDisc.Value = "1.000";
                    if (dt.Columns.Contains("SupEquivDiscPct"))
                        SuperDisc.Value = FormatScreenData(Num3Format, 1 - decimal.Parse(dt.Rows[0]["SupEquivDiscPct"].ToString()));
                    OriginalPrice.Value = FormatScreenData(Num2Format, SOEPrice);                    
                    WorkSellPriceTextBox.Text = FormatScreenData(Num2Format, SOEAltPrice);
                    WebPriceLabel.Text = FormatScreenData(DollarFormat, dt.Rows[0]["WebDiscPrice"]);
                    lblPromo.Text = (dt.Rows[0]["PromoCode"].ToString() == "" ? "N/A" : dt.Rows[0]["PromoCode"].ToString());                    
                    lblPromo.ToolTip = dt.Rows[0]["PromoFullDesc"].ToString();
                    lblTargetDisc.Text = Math.Round(Convert.ToDecimal(dt.Rows[0]["TargetDiscount"].ToString()) * 100, 1).ToString() + "%";
                    lblAdderPct.Text = dt.Rows[0]["PriceCostAdder"].ToString();
                    HighLightFields(dt);                    
                    PricingCalled.Value = "1";
                    wsRefresh(1);
                    // Suggested is Web Price so we calc from there
                    ItemSellPrice = (decimal)dt.Rows[0]["WebPrice"];
                    eComItemSellPrice = Convert.ToDecimal (dt.Rows[0]["WebDiscPrice"].ToString() != ""  ? dt.Rows[0]["WebDiscPrice"].ToString() : "0.00");
                    try
                    {
                        MainMargin = 100 * ((eComItemSellPrice - MainCost) / eComItemSellPrice);
                        StdMargin = 100 * ((eComItemSellPrice - StdCost) / eComItemSellPrice);
                        ReplMargin = 100 * ((eComItemSellPrice - ReplCost) / eComItemSellPrice);
                    }
                    catch (Exception ep)
                    {
                        MainMargin = 0;
                        //StdMargin = 0;
                        ReplMargin = 0;                        
                    }
                    try
                    {
                        SellLB = InContUM(eComItemSellPrice) / ItemWeight;
                        MarginLB = InContUM(eComItemSellPrice - MainCost) / ItemWeight;
                    }
                    catch (Exception ep)
                    {
                        SellLB = 0;
                        MarginLB = 0;
                    }
                    MgnCostSuggestLabel.Text = FormatScreenData("{0:#,##0.0}%", MainMargin);                    
                    MgnReplSuggestLabel.Text = FormatScreenData("{0:#,##0.0}%", ReplMargin);
                    SellLBSuggestLabel.Text = FormatScreenData("${0:#,##0.000}", SellLB);
                    //MarginLBSuggestLabel.Text = FormatScreenData("${0:#,##0.000}", MarginLB); // Always display 0 in Ecomm field when users are in quote recall mode
                    MarginLBSuggestLabel.Text = "$0.000";
                    SuperDiscount = decimal.Parse(SuperDisc.Value, NumberStyles.Number);
                    if (SuperDiscount == 1) SuperDiscount = 0;
                    SuperPriceLabel.Text = FormatScreenData(Num2Format, (1m - SuperDiscount) * ItemSellPrice);
                    LineItemCommentTextBox.Text = dtFix.Rows[0]["Notes"].ToString();
                    GetHistory();
                    
                    // Sathish: Recompute Order sumnmary
                    CalculateOrderTotal();
                }
                AddItemImageButton.ImageUrl = "~/Common/Images/UpdateQuote.gif";

                /**/
            }
        }
        if (QuickQuote.Value == "0" && QuoteRecall.Value == "0")
        {
            //get the session variables and go to town
            CustNoTextBox.Text = Session["CustomerNumber"].ToString();
            CustNameLabel.Text = Session["CustomerName"].ToString();
            CustValid.Value = "1";
            ShippingBranch.Value = Session["ShipFrom"].ToString();
            LocationDropDownList.Visible = false;
            //ShippingBranchName.Value = Session["ShipFromName"].ToString();
            ShipFromLabel.Text = ShippingBranch.Value;
            ShipFromLabel.Visible = true;
            HeadingPriceCodeLabel.Text = Session["CustPriceCode"].ToString();
            SetWebCust(Session["CustPriceCode"].ToString());
            OrderNumber.Value = Session["OrderNumber"].ToString();
            OrderType.Value = Session["OrderType"].ToString();
            promoCd = ((Session["PromotionCd"] != null && Session["PromotionCd"].ToString() != "") ? Session["PromotionCd"].ToString() : "");
            lblName.ToolTip = HttpContext.Current.Session["CustomerCity"].ToString() + ", " + HttpContext.Current.Session["CustomerState"].ToString(); 
           
            if (Session["OrderTableName"] != null)
            {
                OrderTableName.Value = Session["OrderTableName"].ToString();
            }
            else
            {
                OrderTableName.Value = "SOHeader";
            }
            if (Session["DetailTableName"] != null)
            {
                DetailTableName.Value = Session["DetailTableName"].ToString();
            }
            else
            {
                DetailTableName.Value = "SODetail";
            }
            // if we get passed a line number, use it. Otherwise, wait until we get an item number from the user
            if (Session["LineItemNumber"] != null)
            {
                LineNumber.Value = Session["LineItemNumber"].ToString();
            }
            else
            {
                LineNumber.Value = "0";
            }
            NewLineNumber = int.Parse(LineNumber.Value) + 10;
            LineNumber.Value = NewLineNumber.ToString();
            LineAdded.Value = "LineAddedOE" + OrderNumber.Value.ToString() + 'L' + LineNumber.Value;
            SetImageDisplay();
            // if we get passed an item number and we are not quoting, use the item number. 
            if (Session["ItemNo"] != null && Session["ItemNo"].ToString().Length > 0)
            {
                CustomerItemTextBox.Text = Session["ItemNo"].ToString();
                FindItem("PFC", CustomerItemTextBox.Text + " Not Found");
            }
            if (Request.QueryString["OrderLineID"] != null)
            {
                // we got passed a line id so we allow it to be fixed
                /*
                  This was added to \SOE\Common\JavaScript\PFCItemDetail.js in the DeleteQuote function
                      // added by slater for line maintenance
                      if(event.button ==1)
                      {  
                        window.open('PriceWorksheet.aspx?OrderLineID=' + quoteID, 'OrderFix', 'toolbar=0,scrollbars=0,status=1,resizable=YES,height=560,width=1000'); 
                      }  
                  This was added to \SOE\OrderEntry.aspx.cs in the dgNewQuote_ItemDataBound method to format the link
                    // added by slater to set link format
                    lblCustItemNo.Attributes.Add("style", "color: firebrick; font-weight: bold; text-decoration: underline; cursor:hand;");
                    lblPFCItemNo.Attributes.Add("style", "color: firebrick; font-weight: bold; text-decoration: underline; cursor:hand;");
                */
                LineFix.Value = "1";
                LineRecID.Value = Request.QueryString["OrderLineID"];
                LineAdded.Value = "LineAddedOFix" + LineNumber.Value.ToString();
                this.Title = "Order Fix";
                DataTable dtFix = new DataTable();
                ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetLine",
                   new SqlParameter("@PassedDetTable", DetailTableName.Value.ToString()),
                   new SqlParameter("@SODetailID", Request.QueryString["OrderLineID"]));
                dtFix = ds.Tables[1];
                ShippingBranch.Value = dtFix.Rows[0]["IMLoc"].ToString();
                CustomerItemTextBox.Text = dtFix.Rows[0]["ItemNo"].ToString();
                CustomerItemTextBox.Enabled = false;
                FindItem("PFC", CustomerItemTextBox.Text + " Not Found");
                if (dtFix.Rows[0]["CertRequiredInd"].ToString().Trim() == "1")
                {
                    ItemCertsReqdCheckBox.Checked = true;
                }
                else
                {
                    ItemCertsReqdCheckBox.Checked = false;
                }
                RequestedQtyTextBox.Text = FormatScreenData(Num0Format, dtFix.Rows[0]["QtyOrdered"]);
                OriginalPrice.Value = dtFix.Rows[0]["NetUnitPrice"].ToString();
                QtyToSellLabel.Text = FormatScreenData(Num0Format, dtFix.Rows[0]["QtyOrdered"]) + "/" + ContUOM.Value;
                if (DetailTableName.Value.ToString() == "SODetail")
                {
                    LocationDropDownList.DataSource = custDet.GetLocationDetails();
                    LocationDropDownList.DataBind();
                    LocationDropDownList.SelectedValue = ShippingBranch.Value;
                    LocationDropDownList.Visible = true;
                    ShipFromLabel.Visible = false;
                }
                //CarrierDropDownList.SelectedValue = dtFix.Rows[0]["CarrierCd"].ToString();
                //FreightDropDownList.SelectedValue = dtFix.Rows[0]["FreightCd"].ToString();              

                ds = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEGetPrice]",
                                            new SqlParameter("@orderid", -1),
                                            new SqlParameter("@v_order_line_no", -1),
                                            new SqlParameter("@PassedItemNo", dtFix.Rows[0]["ItemNo"].ToString()),
                                            new SqlParameter("@PassedSellToCustNo", CustNoTextBox.Text.ToString()),
                                            new SqlParameter("@PassedShipLoc", ShippingBranch.Value.ToString()),
                                            new SqlParameter("@PassedHdrTable", "SOHeader"),
                                            new SqlParameter("@PassedDetTable", "SODetail"),
                                            new SqlParameter("@PassedQty", dtFix.Rows[0]["QtyOrdered"]),
                                            new SqlParameter("@PassedPrice", dtFix.Rows[0]["AlternatePrice"]),
                                            new SqlParameter("@PassedOrigin", "E"),
                                            new SqlParameter("@v_price_code", HeadingPriceCodeLabel.Text.ToString()),
                                            new SqlParameter("@Param1", "WQ"),
                                            new SqlParameter("@Param2", "SOE"),
                                            new SqlParameter("@Param3", ""),
                                            new SqlParameter("@Param4", ""),
                                            new SqlParameter("@Param5", ""),
                                            new SqlParameter("@Param6", "0"),
                                            new SqlParameter("@Param7", "0"),
                                            new SqlParameter("@Param8", "0"),
                                            new SqlParameter("@Param9", "0"),
                                            new SqlParameter("@Param10", "0"));

                dt = ds.Tables[1];

                string SOEPrice = dt.Rows[0]["SOEPromoPrice"].ToString();
                string SOEAltPrice = dt.Rows[0]["SOEPromoAltSellPrice"].ToString();
                PriceOriginLabel.Text = dt.Rows[0]["PriceOrigin"].ToString();
                PriceOriginHidden.Value = dt.Rows[0]["PriceOrigin"].ToString();
                CostMethod.Value = dt.Rows[0]["CostMethod"].ToString();
                OECost.Value = dt.Rows[0]["OECost"].ToString();
                AltUOMQty.Value = dt.Rows[0]["AltUOMQty"].ToString();
                string avgCost = (Convert.ToInt32(dt.Rows[0]["StdCost"]) != 0 ? dt.Rows[0]["StdCost"].ToString() : dt.Rows[0]["AvgCost"].ToString());
                AvgCostText.Text = FormatScreenData(Num3Format, InSellUM(avgCost));
                AvgCostHidden.Value = avgCost;
                StdCostText.Text = FormatScreenData(Num3Format, dt.Rows[0]["IBPriceCost"]);
                StdCostHidden.Value = InContUM(dt.Rows[0]["IBPriceCost"]).ToString();
                SellPriceTextBox.Text = FormatScreenData(Num2Format, SOEAltPrice);
                lblTargetPrice.Text = "$" + FormatScreenData(Num2Format, dt.Rows[0]["AltSellPrice"]);
                ContPriceLabel.Text = FormatScreenData(Num2Format, SOEPrice) + "/" + ContUOM.Value;
                SuperDisc.Value = "1.000";
                if (dt.Columns.Contains("SupEquivDiscPct"))
                    SuperDisc.Value = FormatScreenData(Num3Format, 1 - decimal.Parse(dt.Rows[0]["SupEquivDiscPct"].ToString()));
                OriginalPrice.Value = FormatScreenData(Num2Format, SOEPrice);
                WorkSellPriceTextBox.Text = FormatScreenData(Num2Format, SOEAltPrice);
                WebPriceLabel.Text = FormatScreenData(DollarFormat, dt.Rows[0]["WebDiscPrice"]);
                lblPromo.Text = (dt.Rows[0]["PromoCode"].ToString() == "" ? "N/A" : dt.Rows[0]["PromoCode"].ToString());
                lblPromo.ToolTip = dt.Rows[0]["PromoFullDesc"].ToString();
                lblTargetDisc.Text = Math.Round(Convert.ToDecimal(dt.Rows[0]["TargetDiscount"].ToString()) * 100, 1).ToString() + "%";
                lblAdderPct.Text = dt.Rows[0]["PriceCostAdder"].ToString();
                HighLightFields(dt);                
                PricingCalled.Value = "1";
                wsRefresh(1);
                // Suggested is Web Price so we calc from there
                ItemSellPrice = (decimal)dt.Rows[0]["WebPrice"];
                eComItemSellPrice = Convert.ToDecimal(dt.Rows[0]["WebDiscPrice"].ToString() != "" ? dt.Rows[0]["WebDiscPrice"].ToString() : "0.00");
                try
                {
                    MainMargin = 100 * ((eComItemSellPrice - MainCost) / eComItemSellPrice);
                    StdMargin = 100 * ((eComItemSellPrice - StdCost) / eComItemSellPrice);
                    ReplMargin = 100 * ((eComItemSellPrice - ReplCost) / eComItemSellPrice);
                }
                catch (Exception ep)
                {
                    MainMargin = 0;
                    StdMargin = 0;
                    ReplMargin = 0;
                }
                try
                {
                    SellLB = InContUM(eComItemSellPrice) / ItemWeight;
                    MarginLB = InContUM(eComItemSellPrice - MainCost) / ItemWeight;
                }
                catch (Exception ep)
                {
                    SellLB = 0;
                    MarginLB = 0;
                }
                MgnCostSuggestLabel.Text = FormatScreenData("{0:#,##0.0}%", MainMargin);                
                MgnReplSuggestLabel.Text = FormatScreenData("{0:#,##0.0}%", ReplMargin);
                SellLBSuggestLabel.Text = FormatScreenData("${0:#,##0.000}", SellLB);
                MarginLBSuggestLabel.Text = FormatScreenData("${0:#,##0.000}", MarginLB);
                SuperDiscount = decimal.Parse(SuperDisc.Value, NumberStyles.Number);
                if (SuperDiscount == 1) SuperDiscount = 0;
                SuperPriceLabel.Text = FormatScreenData(Num2Format, (1m - SuperDiscount) * ItemSellPrice);
                LineItemCommentTextBox.Text = dtFix.Rows[0]["Remark"].ToString();
                GetHistory();
                AddItemImageButton.ImageUrl = "~/Common/Images/update.gif";

                // Sathish: Recompute Order sumnmary
                CalculateOrderTotal();
            }
        }
        pnlQuoteDetail.Update();
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // Initializing AJAX.NET Library 
        Ajax.Utility.RegisterTypeForAjax(typeof(SOEPriceWorksheet));
        //ShippingBranch.Value = "04";
        //HeadingPriceCodeLabel.Text = "A";
        PriceFixed.Value = "0";
        EnablePricing(true);
        if (HeadingPriceCodeLabel.Text.ToUpper().Trim() == "Z")
        {
            PriceFixed.Value = "1";
            ControlAfterQty = "AddItemImageButton";
            EnablePricing(false);
        }

        if (Request.QueryString["OperatingMode"] != null &&
            Request.QueryString["OperatingMode"].ToString().ToLower() == "short")
        {
            OPERATINGMODE = "short";
        }

        if (!Page.IsPostBack)
        {
            HighLightQueueButton();            

            Session["SubstituteItemFound" + LineAdded.Value] = "";
            Session["SellOutItemFound" + LineAdded.Value] = "";
            
            if (OPERATINGMODE.ToLower() == "short")
            {
                // Ecomm Column
                LastECommLabel.Visible = false;
                DateLastECommLabel.Visible = false;
                QtyLastECommLabel.Visible = false;
                SellLastECommLabel.Visible = false;
                MgnCostLastECommLabel.Visible = false;
                MgnReplLastECommLabel.Visible = false;
                SellLBLastECommLabel.Visible = false;
                MarginLBLastECommLabel.Visible = false;
                

                OpenOrderLabel.Visible = false;
                DateOpenOrderLabel.Visible = false;
                QtyOpenOrderLabel.Visible = false;
                SellOpenOrderLabel.Visible = false;
                MgnCostOpenOrderLabel.Visible = false;
                MgnReplOpenOrderLabel.Visible = false;
                SellLBOpenOrderLabel.Visible = false;
                MarginLBOpenOrderLabel.Visible = false;


                RegionLastQuoteLabel.Visible = false;
                RegionLastOrderLabel.Visible = false;
                CompNameHeader.Visible = false;
                CompPriceHeader.Visible = false;
            }
        }
    }

    protected void Page_LoadComplete(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            RefreshNeeded.Value = "0";
            MillCostLabel.Visible = false;
            MillCostInput.Visible = false;
            if (QuickQuote.Value == "1" && QuoteRecall.Value == "0")
            {
                SOEPriceWorksheetScriptManager.SetFocus("CustNoTextBox");
            }
            else
            {
                // if we get passed an item number or we are fixing, go directly to qty. 
                if ((Session["ItemNo"] != null && Session["ItemNo"].ToString().Length > 0) 
                    || ((QuoteFix.Value == "1") && CommentEntry.Value.ToString() != "1")
                    || (LineFix.Value == "1"))
                {
                    SOEPriceWorksheetScriptManager.SetFocus("RequestedQtyTextBox");
                }
                else
                {
                    SOEPriceWorksheetScriptManager.SetFocus("CustomerItemTextBox");
                }
                CustNoTextBox.ReadOnly = true;
            }
            //Session["SOEItemNumber"] = null;
            //Session["SOEItemDesc"] = null;

        }
        else
        {
            //MessageLabel.Text = SellMultiplier.ToString();
        }
        if (CustNameLabel.Text.Trim().Length != 0 && QuickQuote.Value == "1")
        {
            this.Title = CustNameLabel.Text;
        }
    }

    protected void CustNoSubmit_Click(object sender, EventArgs e)
    {
    }
    
    protected void ShipLocSubmit_Click(object sender, EventArgs e)
    {
        ClearPageMessages();
        ShippingBranch.Value =
            LocationDropDownList.SelectedItem.Text.Split(new string[] { "-" }, StringSplitOptions.None)[0].Trim();
        DataTable dtLoc = new DataTable();
        DataSet dsLoc = SqlHelper.ExecuteDataset(connectionString, "pSOEGetLocMaster",
            new SqlParameter("@LocNo", ShippingBranch.Value));
        if (dsLoc.Tables.Count >= 1)
        {
            if (dsLoc.Tables.Count == 1)
            {
                // We only go one table back, something is wrong
                dtLoc = dsLoc.Tables[0];
                if (dtLoc.Rows.Count > 0)
                {
                    ShowPageMessage("Problem with Branch " + ShippingBranch.Value, 2);
                }
            }
            else
            {
                dtLoc = dsLoc.Tables[1];
                if (dtLoc.Rows.Count > 0)
                {
                    ShowPartImages.Value = dtLoc.Rows[0]["SODisplayProd"].ToString();
                    ItemPromptInd.Value = dtLoc.Rows[0]["ItemPromptInd"].ToString();
                    ShippingBranchName.Value = dtLoc.Rows[0]["LocName"].ToString();
                    // The shipping location has changed so update the worksheet
                    if (!((QuoteFix.Value == "1") || (LineFix.Value == "1")) && (CustomerItemTextBox.Text.Trim().Length > 0))
                    {
                        // there was an item so refresh it
                        FindItem("PFC", CustomerItemTextBox.Text + " Not Found");
                    }
                    if ((QuoteFix.Value == "1") || (LineFix.Value == "1"))
                    {
                        // we are maintaining records so get a new QOH  SELECT dbo.[fGetBrAvailability]( '00350-2600-021', '01', 'CT')
                        int NewQOH = (int)SqlHelper.ExecuteScalar(connectionString, CommandType.Text,
                            "SELECT dbo.[fGetBrAvailability]( '" + InternalItemLabel.Text.Trim() +
                            "', '" + ShippingBranch.Value.Trim() + "', '" + ContUOM.Value.Trim() + "')");
                        AvailableQtyLabel.Text = FormatScreenData(Num0Format, NewQOH);
                        ShowPageMessage("test" + ShippingBranch.Value.ToString(), 2);
                    }
                    string QtyEntered = RequestedQtyTextBox.Text.Replace(",", "").Trim().ToUpper();
                    if (QtyEntered.Length > 0)
                    {
                        // there is a qty so refresh that
                        QtyButt_Click(sender, e);
                    }
                }
            }
        }
    }

    protected void ItemButt_Click(object sender, EventArgs e)
    {
        FindItem("PFC", CustomerItemTextBox.Text + " Not Found");
    }

    protected void AliasButt_Click(object sender, EventArgs e)
    {
        // here we are checking for customer alias w/o z-item processing
        FindItem("Alias", CustomerItemTextBox.Text + " Alias for " + CustNoTextBox.Text + " not on file.");
    }

    protected void btnSubsItem_Click(object sender, EventArgs e)
    {
        // This button is fired from substitute item availability page >> submit button 
        // this button used to click itemButt & QtySubmit at the same time
        string itemNo = CustomerItemTextBox.Text;
        string reqQty = RequestedQtyTextBox.Text;

        QtySubmittedBySubtituteItem = true; // if this value is true then don't display Availability Pop-up again

        CustomerItemTextBox.Text = itemNo;
        ItemButt_Click(btnSubsItem, new EventArgs());
        
        RequestedQtyTextBox.Text = reqQty;
        QtyButt_Click(btnSubsItem, new EventArgs());
        QtySubmittedBySubtituteItem = false;
        AddItemImageButton.Visible = true;
        ActionUpdatePanel.Update();
        SOEPriceWorksheetScriptManager.SetFocus(SellPriceTextBox);
    }

    protected void FindItem(string ItemType,string NoFindMessage)
    {
        ClearPageMessages();
        ClearItemData(true);
        ClearCalcData();        
        Session[LineAdded.Value.ToString()] = false;
        try
        {
            // here we are checking for pfc part number with z-item processing
            // get the Item and SKU data.
            ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetItemAlias",
                      new SqlParameter("@SearchItemNo", CustomerItemTextBox.Text),
                      new SqlParameter("@Organization", CustNoTextBox.Text),
                      new SqlParameter("@PrimaryBranch", ShippingBranch.Value),
                      new SqlParameter("@SearchType", ItemType));
            if (ds.Tables.Count >= 1)
            {
                if (ds.Tables.Count == 1)
                {
                    // We only got one table back, something is wrong
                    dt = ds.Tables[0];
                    if (dt.Rows.Count > 0)
                    {
                        if (dt.Rows[0]["ErrorType"].ToString().Trim() + dt.Rows[0]["ErrorCode"].ToString() == "E0022")
                        {
                            ShowPageMessage("Item not stocked at any Branch. This item cannot be sold.", 2);
                        }
                        else
                        {
                            ShowPageMessage(NoFindMessage, 2);
                        }
                        DisableEntry(true);
                        SOEPriceWorksheetScriptManager.SetFocus("CustomerItemTextBox");
                    }
                }
                else
                {
                    dt = ds.Tables[1];
                    ShowItem();

                    #region Code To Display Substitute Items
                    // Set session variable to display substitute item & sell out item
                    if (dt.Rows.Count > 0)
                    {
                        //Session["SubstituteItemFound" + LineAdded.Value] = (dt.Rows[0]["SubItemInd"].ToString().Trim() == "Y" ? "Y" : "N");
                        //Session["SellOutItemFound" + LineAdded.Value] = (dt.Rows[0]["SellOutItemInd"].ToString().Trim() == "Y" ? "Y" : "N");

                        hidSubItemInd.Value = (dt.Rows[0]["SubItemInd"].ToString().Trim() == "Y" ? "Y" : "N");
                        hidSellOutItemInd.Value = (dt.Rows[0]["SellOutItemInd"].ToString().Trim() == "Y" ? "Y" : "N");
                    }

                    if (hidSellOutItemInd.Value == "Y" && QtySubmittedBySubtituteItem == false && QuoteFix.Value != "1")
                    {
                        AddItemImageButton.Visible = false;
                        ActionUpdatePanel.Update();
                        ScriptManager.RegisterClientScriptBlock(ItemSubmit, ItemSubmit.GetType(), "showselloutitems", "ShowSellOutItems()", true);
                    }
                    #endregion

                }
            }
            else
            {
                ShowPageMessage("Item DataSet Error", 2);
                SOEPriceWorksheetScriptManager.SetFocus("CustomerItemTextBox");
            }
        }
        catch (Exception ex1)
        {
            ShowPageMessage("pSOEGetItemAlias Error " + ex1.Message + ", " + ex1.ToString(), 2);
        }
    }

    protected void StartCommentEntry_Click(object sender, EventArgs e)
    {
        StartCommentEntry();
    }

    protected void StartCommentEntry()
    {
        if (CommentEntry.Value.ToString() == "1")
        {
            CustomerItemTextBox.Text = "Comment";
            InternalItemLabel.Text = "Comment";
            ItemDescLabel.Text = "Comment";
            DisableEntry(false);
            RequestedQtyTextBox.Text = "1";
            QtyToSellLabel.Text = "1";
            PieceQty.Value = "1";
            SellStkQty.Value = "1";
            SellUOMLabel.Text = "PC";
            FilledQtyHidden.Value = "1";
            SellPriceTextBox.Text = "0";
            ContPriceLabel.Text = "0/CT";
            ReplCostText.Text = "0";
            AvailableQtyLabel.Text = "0";
            QtyToSellLabel.Text = "1/PC";
            AvgCostText.Text = "0";
            StdCostText.Text = "0";
            txtPctDiff.Text = "0.0";
            WorkItemWeightLabel.Text = "0";
            WorkNetWeightLabel.Text = "0";
            MinMargin.Value = "0.1";
            MaxMargin.Value = "0.9";
            MgnCostTextBox.Text = "50";
            WorkSellPriceTextBox.Text = "0";
            //MgnStdTextBox.Text = "50";
            SellLBTextBox.Text = "1";
            MarginLBTextBox.Text = "50";
            WorkSheetUpdatePanel.Update();
            Session[LineAdded.Value.ToString()] = false;
            SOEPriceWorksheetScriptManager.SetFocus("LineItemCommentTextBox");
        }

    }

    protected void ShowItem()
    {
        try
        {
            InternalItemLabel.Text = dt.Rows[0]["FoundItem"].ToString();
            CustomerItemTextBox.Text = dt.Rows[0]["CustItem"].ToString();
            ItemDescLabel.Text = dt.Rows[0]["ItemDesc"].ToString();
            ItemColor.Value = dt.Rows[0]["ColorInd"].ToString().Trim();
            SellStkQty.Value = dt.Rows[0]["ItemQty"].ToString();
            AvailableQtyLabel.Text = FormatScreenData(Num0Format, dt.Rows[0]["QOH"]);
            ShippingBranchName.Value = dt.Rows[0]["LocName"].ToString();
            CustDesc.Value = dt.Rows[0]["CustDesc"].ToString();
            ContUOM.Value = dt.Rows[0]["ItemUOM"].ToString();
            QtyUnitLabel.Text = String.Format(Num0Format, dt.Rows[0]["ItemQty"]) + @"/" + ContUOM.Value;
            SellUOMLabel.Text = dt.Rows[0]["AltPriceUM"].ToString();
            SuperLabel.Text = dt.Rows[0]["SuperQty"].ToString() + "/" + dt.Rows[0]["SuperUM"].ToString();
            SuperUOM.Value = dt.Rows[0]["SuperUM"].ToString();
            SuperQty.Value = dt.Rows[0]["SuperQty"].ToString();
            PieceQty.Value = dt.Rows[0]["PieceQty"].ToString();
            PieceUOMLabel.Text = dt.Rows[0]["PieceUOMText"].ToString();
            WorkSVCLabel.Text = dt.Rows[0]["SalesVelocityCd"].ToString();
            //CatVLabel.Text = dt.Rows[0]["CatVelocityCd"].ToString();
            CorpVLabel.Text = dt.Rows[0]["FixedVelocityCd"].ToString();
            if (dt.Rows[0]["StockInd"].ToString() == "0")
            {
                ShowPageMessage("........Non-Stock Item, Do Not Backorder ........", 2);
            }
            ReplCostHidden.Value = dt.Rows[0]["ReplacementCost"].ToString();
            ListPriceHidden.Value = dt.Rows[0]["ListPrice"].ToString();
            WorkWght100Label.Text = FormatScreenData(Num2Format, dt.Rows[0]["HundredWght"]);
            WorkItemWeightLabel.Text = FormatScreenData(Num4Format, dt.Rows[0]["GrossWght"]);
            WorkNetWeightLabel.Text = FormatScreenData(Num4Format, dt.Rows[0]["Wght"]);
            ItemRecID.Value = dt.Rows[0]["ItemID"].ToString();
            Loc1.Value = ShippingBranch.Value.ToString();
            Qty1.Value = dt.Rows[0]["QOH"].ToString();
            ItemCertRequiredInd.Value = dt.Rows[0]["CertRequiredInd"].ToString().Trim();
            if ((CustCertRequiredInd.Value.Trim().ToUpper() == "TRUE") && (dt.Rows[0]["CertRequiredInd"].ToString().Trim()=="1"))
            {
                ItemCertsReqdCheckBox.Checked = true;
            }
            else
            {
                ItemCertsReqdCheckBox.Checked = false;
            }
            GetImages(InternalItemLabel.Text.Substring(0, 5));
            switch (ItemColor.Value.ToString())
            {
                case "R":
                    ItemDescLabel.CssClass = "lbl_whitebox redbg";
                    WorkSellPriceTextBox.CssClass = "ws_whitebox redbg";
                    MgnCostTextBox.CssClass = "ws_whitebox redbg";
                    //MgnStdTextBox.CssClass = "ws_whitebox redbg";
                    MgnReplTextBox.CssClass = "ws_whitebox redbg";
                    SellLBTextBox.CssClass = "ws_whitebox redbg";
                    MarginLBTextBox.CssClass = "ws_whitebox redbg";
                    break;
                case "Y":
                    ItemDescLabel.CssClass = "lbl_whitebox yellowbg";
                    WorkSellPriceTextBox.CssClass = "ws_whitebox yellowbg";
                    MgnCostTextBox.CssClass = "ws_whitebox yellowbg";
                    //MgnStdTextBox.CssClass = "ws_whitebox yellowbg";
                    MgnReplTextBox.CssClass = "ws_whitebox yellowbg";
                    SellLBTextBox.CssClass = "ws_whitebox yellowbg";
                    MarginLBTextBox.CssClass = "ws_whitebox yellowbg";
                    break;
                case "G":
                    ItemDescLabel.CssClass = "lbl_whitebox greenbg";
                    WorkSellPriceTextBox.CssClass = "ws_greenbox";
                    MgnCostTextBox.CssClass = "ws_greenbox";
                    //MgnStdTextBox.CssClass = "ws_greenbox";
                    MgnReplTextBox.CssClass = "ws_greenbox";
                    SellLBTextBox.CssClass = "ws_greenbox";
                    MarginLBTextBox.CssClass = "ws_greenbox";
                    break;
            }
            try
            {
                SellMultiplier = (decimal)dt.Rows[0]["AltQtyPerUM"] / (decimal)dt.Rows[0]["ItemQty"];
            }
            catch
            {
                SellMultiplier = 0;
            }
            ReplCostText.Text = FormatScreenData(Num3Format, InSellUM(dt.Rows[0]["ReplacementCost"]));
            ListPriceLabel.Text = FormatScreenData(Num2Format, InSellUM(dt.Rows[0]["ListPrice"])) + @"/" + SellUOMLabel.Text;
            DiscPriceTextBox.Text = FormatScreenData(Num2Format, InSellUM(dt.Rows[0]["ListPrice"]));
            if (dt.Rows[0]["CustItem"].ToString() == "No Alias")
            {
                AddXrefCheckBox.Enabled = true;
            }
            if (OrderType.Value.Trim() == "1")
            {

                MillCostLabel.Visible = true;
                MillCostInput.Visible = true;
            }
            else
            {
                MillCostLabel.Visible = false;
                MillCostInput.Visible = false;
            }
            CameraButt.Visible = true;
            CameraUpdatePanel.Update();
            HistoryButt.Visible = true;
            NoSKUOnFile.Value = "0";
            if (ds.Tables[0].Rows[0]["ErrorType"].ToString().Trim() + ds.Tables[0].Rows[0]["ErrorCode"].ToString() == "W0021")
            {
                NoSKUOnFile.Value = "1";
                NoSKUReplCostHidden.Value = "0";
                NoSKUAvgCostHidden.Value = "0";
                NoSKUStdCostHidden.Value = "0";
            }

            #region Short version & long version enhancement
            
            // Sathish: Don't display List price, Disc % & price (only for bulk item)
            if (InternalItemLabel.Text != "" &&
                (InternalItemLabel.Text.Substring(11, 1) == "0" ||
                InternalItemLabel.Text.Substring(11, 1) == "1" ||
                InternalItemLabel.Text.Substring(11, 1) == "5"))
            {
                ListPriceLabel.Visible = false;
                DiscPcntTextBox.Visible = false;
                DiscPriceTextBox.Visible = false;

                DummyListPriceLabel.Visible = true;
                DummyDiscPcntTextBox.Visible = true;
                DummyDiscPriceTextBox.Visible = true;
            }
            else
            {
                ListPriceLabel.Visible = true;
                DiscPcntTextBox.Visible = true;
                DiscPriceTextBox.Visible = true;

                DummyListPriceLabel.Visible = false;
                DummyDiscPcntTextBox.Visible = false;
                DummyDiscPriceTextBox.Visible = false;
            }

            #endregion
            
            WorkSheetUpdatePanel.Update();
            DisableEntry(false);
            PricingCalled.Value = "0";
            SOEPriceWorksheetScriptManager.SetFocus("RequestedQtyTextBox");
        }
        catch (Exception ex1)
        {
            DisableEntry(true);
            ShowPageMessage("Show Item Error " + ex1.Message + ", " + ex1.ToString(), 2);
        }
    }

    #region Check Item No And Cross Reference
    /// <summary>
    /// Check Cross reference against Itemno and customer number
    /// </summary>
    /// <param name="itemNo"></param>
    /// <returns></returns>
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string GetCrossreference(string itemNo, string custNo)
    {
        string status = "";
        // get the data.
        DataSet dsAvail = SqlHelper.ExecuteDataset(connectionString, "[pSOEGetItemAlias]",
                  new SqlParameter("@SearchItemNo", itemNo),
                  new SqlParameter("@Organization", custNo));

        if (dsAvail.Tables.Count >= 1)
        {
            if (dsAvail.Tables.Count == 1)
            {
                if (dsAvail.Tables[0].Rows.Count > 0)
                {
                    status = "false";
                }
            }
            else
            {
                status = "true";
            }
        }
        return status;

    }

    #endregion

    protected void QtyButt_Click(object sender, EventArgs e)
    {
        CurQty.Value = RequestedQtyTextBox.Text.Replace(",", "").Trim().ToUpper();
        if (!ParseQty(CurQty.Value))
        {
            SOEPriceWorksheetScriptManager.SetFocus("RequestedQtyTextBox");
        }
        else
        {
            if (!CheckQOH() && QtySubmittedBySubtituteItem == false)
            {
                ScriptManager.RegisterClientScriptBlock(RequestedQtyTextBox, RequestedQtyTextBox.GetType(), "ReqQty", "ShowAvailability();", true);
            }
            PackPlateButt.Visible = true;
            if (PricingCalled.Value != "1")
                GetPrice(OrderNumber.Value.ToString(), "-1", InternalItemLabel.Text, CustNoTextBox.Text, LineQty.ToString(),
                                SellPriceTextBox.Text, PriceOriginLabel.Text, HeadingPriceCodeLabel.Text);
            else
                wsRefresh(1);
        }
    }

    protected bool ParseQty(string QtyString)
    {
        UOMText = "";
        Qtytext = "";
        string QtyErrorText = "";
        try
        {
            ClearPageMessages();
            bool QtyAvailable = false;
            int PriQtyAvaliable = 0;
            int QtyRequested = 0;
            string QtyEntered = RequestedQtyTextBox.Text.Replace(",", "").Trim().ToUpper();
            if (QtyEntered.Length == 0)
            {
                QtyErrorText = "A Requested Qty is required";
                goto QtyInputError;
            }
            else
            {
                // parse the input for possible UOM strings
                UnitQty = 1;
                if (!int.TryParse(QtyEntered, out QtyRequested))
                {
                    char[] QtyArray = QtyEntered.ToCharArray();
                    foreach (char c in QtyArray)
                    {
                        if (c.Equals('-')) Qtytext += c;
                        if (char.IsDigit(c)) Qtytext += c;
                        if (c.Equals('.')) Qtytext += c;
                        if (char.IsLetter(c)) UOMText += c;
                    }
                    //RequestedQtyTextBox.Text = Qtytext+"X";
                    if (Qtytext.Length == 0)
                    {
                        QtyErrorText = "A Requested Qty is required";
                        goto QtyInputError;
                    }
                    QtyRequested = int.Parse(Qtytext, NumberStyles.Number);
                    if (UOMText.Length != 0)
                    {
                        // get the uom
                        ds = SqlHelper.ExecuteDataset(connectionString, "[pSOEGetItemUOM]",
                                  new SqlParameter("@SearchItemNo", InternalItemLabel.Text),
                                  new SqlParameter("@SearchUOM", UOMText));
                        if (ds.Tables.Count >= 1)
                        {
                            if (ds.Tables.Count == 1)
                            {
                                // We only go one table back, something is wrong
                                dt = ds.Tables[0];
                                if (dt.Rows.Count > 0)
                                {
                                    QtyErrorText = "Invalid UOM";
                                    goto QtyInputError;
                                }
                            }
                            else
                            {
                                UnitQty = (decimal)ds.Tables[1].Rows[0]["CTQtyFactor"];
                            }
                        }
                    }

                }
                // if we are not quoting, you don't get to enter a zero
                if ((QtyRequested == 0) && ((QuickQuote.Value != "1") && (QuoteRecall.Value != "1")))
                {
                    QtyErrorText = "A Qty of Zero is not Valid";
                    goto QtyInputError;
                }
                // set qty to sell
                LineQty = (int)Math.Ceiling(QtyRequested * UnitQty);
                QtyToSellLabel.Text = FormatScreenData(Num0Format, LineQty) + "/" + ContUOM.Value;
                // set up the piece qtys
                TotPieceQty.Value = string.Format(Num0Format, LineQty * int.Parse(PieceQty.Value, NumberStyles.Number));
                AltQtyLabel.Text = FormatScreenData(Num0Format, LineQty * UnitQty);
                //QtyErrorText = Qtytext + ":" + UOMText;
                //goto QtyInputError;

                return true;
            }
        }
        catch (Exception ex1)
        {
            ShowPageMessage("Qty Error " + ex1.Message + ", " + ex1.ToString(), 2);
            return false;
        }

    QtyInputError:
        ShowPageMessage(QtyErrorText, 2);
        return false;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.None)]
    public string AjaxGetLineQty(string QtyString, string QuickQuote, string QuoteRecall, string ItemNo)
    {
        UOMText = "";
        Qtytext = "";
        int QtyRequested = 0;
        string status = QtyString;
        try
        {
            string QtyEntered = QtyString.Replace(",", "").Trim().ToUpper();
            if (QtyEntered.Length == 0)
            {
                status = "A Requested Qty is required";
                return status;
            }
            else
            {
                // parse the input for possible UOM strings
                UnitQty = 1;
                if (!int.TryParse(QtyEntered, out QtyRequested))
                {
                    char[] QtyArray = QtyEntered.ToCharArray();
                    foreach (char c in QtyArray)
                    {
                        if (c.Equals('-')) Qtytext += c;
                        if (char.IsDigit(c)) Qtytext += c;
                        if (c.Equals('.')) Qtytext += c;
                        if (char.IsLetter(c)) UOMText += c;
                    }
                    //RequestedQtyTextBox.Text = Qtytext+"X";
                    if (Qtytext.Length == 0)
                    {
                        status = "A Requested Qty is required";
                        return status;
                    }
                    QtyRequested = int.Parse(Qtytext, NumberStyles.Number);
                }
                if (UOMText.Length != 0)
                {
                    // get the uom
                    ds = SqlHelper.ExecuteDataset(connectionString, "[pSOEGetItemUOM]",
                              new SqlParameter("@SearchItemNo", ItemNo),
                              new SqlParameter("@SearchUOM", UOMText));
                    if (ds.Tables.Count >= 1)
                    {
                        if (ds.Tables.Count == 1)
                        {
                            // We only go one table back, something is wrong
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                status = "Invalid UOM";
                                return status;
                            }
                        }
                        else
                        {
                            UnitQty = (decimal)ds.Tables[1].Rows[0]["CTQtyFactor"];
                        }
                    }
                }

            }
            // if we are not quoting, you don't get to enter a zero
            if ((QtyRequested == 0) && ((QuickQuote != "1") && (QuoteRecall != "1")))
            {
                status = "A Qty of Zero is not Valid";
            }
            else
            {
                // set qty to sell
                LineQty = (int)Math.Ceiling(QtyRequested * UnitQty);
                return LineQty.ToString();
            }
        }
        catch (Exception ex1)
        {
            status = "Qty Error " + ex1.Message + ", " + ex1.ToString();
        }
        return status;
    }

    protected bool CheckQOH()
    {
        if ((int.Parse(AvailableQtyLabel.Text, NumberStyles.Number) >= LineQty)
            || DetailTableName.Value.ToUpper().Contains("REL")
            || (OrderType.Value.Trim() == "1")
            || (OrderType.Value.Trim() == "4")
            || (OrderType.Value.Trim() == "PCR")
            || (OrderType.Value.Trim() == "CR")
            || (OrderType.Value.Trim() == "PRGA")
            || (OrderType.Value.Trim() == "RGA")
            )
        {
            // We have enough
            UseRemoteQtys.Value = "0";
            SOEPriceWorksheetScriptManager.SetFocus(ControlAfterQty);
            FilledQtyHidden.Value = QtyToSellLabel.Text.ToString();
            return true;
        }
        else
        {
            // we don't have enough at the primary branch
            // show the remote qty page so the user can get qty from other branches
            UseRemoteQtys.Value = "1";
            return false;
        }
    }

    public void GetImages(string Category)
    {
        string HeaderImageName = "";
        string BodyImageName = "";
        string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
        //show the item images
        string ColumnNames = "";
        ColumnNames = "Category ,";
        ColumnNames += "TechSpec,";
        ColumnNames += "Caution,";
        ColumnNames += "BodyFileName,";
        ColumnNames += "HeadFileName";
        DataSet dsImage = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
            new SqlParameter("@tableName", "ItemCategory WITH (NOLOCK)"),
            new SqlParameter("@columnNames", ColumnNames),
            new SqlParameter("@whereClause", "Category='" + Category + "'"));
        if (dsImage.Tables.Count == 1)
        {
            // We only got one table back
            DataTable dtImage = dsImage.Tables[0];
            if (dtImage.Rows.Count > 0)
            {
                CategorySpecLabel.Text = dtImage.Rows[0]["TechSpec"].ToString();
                if (CategorySpecLabel.Text.Length > 1)
                {
                    CategorySpecLabel.Text = "Specification: " + CategorySpecLabel.Text;
                }
                CategoryUpdatePanel.Update();
                if (ItemColor.Value.ToString() == "0" && int.Parse(dtImage.Rows[0]["Caution"].ToString()) == 1)
                {
                    ItemColor.Value = "Y";
                }
                if (ShowPartImages.Value == "Y")
                {
                    BodyImageName = dtImage.Rows[0]["BodyFileName"].ToString();
                    HeaderImageName = dtImage.Rows[0]["HeadFileName"].ToString();
                    BodyImage.ImageUrl = ImageLibrary + BodyImageName;
                    HeadImage.ImageUrl = ImageLibrary + HeaderImageName;
                    HeadImageUpdatePanel.Update();
                    BodyImageUpdatePanel.Update();
                    HeadImageUpdatePanel.Visible = true;
                    BodyImageUpdatePanel.Visible = true;
                }
            }
            else
            {
                ShowPageMessage(Category + " Not Found for Image", 2);
            }
        }
        else
        {
            ShowPageMessage(Category + " Not Found for Image", 2);
        }
    }

    protected void SetImageDisplay()
    {
        // get the LoacMaster data inidcating whether images should be shown.
        // This also retrieves whether ZItem should be process using field ItemPromptInd
        DataTable dtLoc = new DataTable();
        DataSet dsLoc = SqlHelper.ExecuteDataset(connectionString, "pSOEGetLocMaster",
            new SqlParameter("@LocNo", ShippingBranch.Value));
        if (dsLoc.Tables.Count >= 1)
        {
            if (dsLoc.Tables.Count == 1)
            {
                // We only go one table back, something is wrong
                dtLoc = dsLoc.Tables[0];
                if (dtLoc.Rows.Count > 0)
                {
                    ShowPageMessage("Image Problem with Branch " + ShippingBranch.Value, 2);
                }
            }
            else
            {
                dtLoc = dsLoc.Tables[1];
                if (dtLoc.Rows.Count > 0)
                {
                    ShowPartImages.Value = dtLoc.Rows[0]["SODisplayProd"].ToString();
                    ItemPromptInd.Value = dtLoc.Rows[0]["ItemPromptInd"].ToString();
                    ShippingBranchName.Value = dtLoc.Rows[0]["LocName"].ToString();
                }
            }
        }
    }

    protected void CostUpdButt_Click(object sender, EventArgs e)
    {
        // this is called from Branch Available to set the costs when there is no SKU at the ordering branch
        ReplCostText.Text = FormatScreenData(Num3Format, InSellUM(NoSKUReplCostHidden.Value));
        AvgCostText.Text = FormatScreenData(Num3Format, InSellUM(NoSKUAvgCostHidden.Value));
        StdCostText.Text = FormatScreenData(Num3Format, InSellUM(NoSKUStdCostHidden.Value));
        wsRefresh(7);
        SOEPriceWorksheetScriptManager.SetFocus("SellPriceTextBox");
    }

    public void GetPrice(string OrderNumber, string LineNumber, string ItemNumber, string CustNumber, 
            string ItemQty, string CurPrice, string PriceOrigin, string PriceCode)
    {
        //BigTextBox.Text = "x" + ItemQty + "x";
        //TestPanel.Update();
        // get the Pricing data.   
        try
        {
            if (CurPrice.Trim().Length == 0) CurPrice = "0";

            ds = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEGetPrice]",
                                        new SqlParameter("@orderid", int.Parse(OrderNumber)),
                                        new SqlParameter("@v_order_line_no", "-1"),
                                        new SqlParameter("@PassedItemNo", ItemNumber),
                                        new SqlParameter("@PassedSellToCustNo", CustNumber),
                                        new SqlParameter("@PassedShipLoc", ShippingBranch.Value.ToString()),
                                        new SqlParameter("@PassedHdrTable", OrderTableName.Value.ToString()),
                                        new SqlParameter("@PassedDetTable", DetailTableName.Value.ToString()),
                                        new SqlParameter("@PassedQty", Int32.Parse(ItemQty)),
                                        new SqlParameter("@PassedPrice", decimal.Parse(CurPrice.Replace(",", ""))),
                                        new SqlParameter("@PassedOrigin", PriceOrigin),
                                        new SqlParameter("@v_price_code", PriceCode),
                                        new SqlParameter("@Param1", "WQ"),
                                        new SqlParameter("@Param2", "SOE"),
                                        new SqlParameter("@Param3", ""),
                                        new SqlParameter("@Param4", ""),
                                        new SqlParameter("@Param5", ""),
                                        new SqlParameter("@Param6", "0"),
                                        new SqlParameter("@Param7", "0"),
                                        new SqlParameter("@Param8", "0"),
                                        new SqlParameter("@Param9", "0"),
                                        new SqlParameter("@Param10", "0"));

            if (ds.Tables.Count >= 1)
            {
                if (ds.Tables.Count == 1)
                {
                    // We only go one table back, something is wrong
                    dt = ds.Tables[0];
                    if (dt.Rows.Count > 0)
                    {
                        ShowPageMessage("Pricing problem", 2);
                    }
                }
                else
                {
                    if (ds.Tables.Count == 3)
                    {
                        // we got some header data back
                        LineReasonCode.Value = ds.Tables[2].Rows[0]["LineReason"].ToString();
                        LineReasonCodeDesc.Value = ds.Tables[2].Rows[0]["LineReasonDsc"].ToString();
                        LineExpediteCode.Value = ds.Tables[2].Rows[0]["LineExpdCd"].ToString();
                        LineExpediteCodeDesc.Value = ds.Tables[2].Rows[0]["LineExpdCdDsc"].ToString();
                    }
                    dt = ds.Tables[1];
                    if (dt.Rows.Count > 0)
                    {
                        string SOEPrice = dt.Rows[0]["SOEPromoPrice"].ToString();
                        string SOEAltPrice = dt.Rows[0]["SOEPromoAltSellPrice"].ToString();

                        PriceOriginLabel.Text = dt.Rows[0]["PriceOrigin"].ToString();
                        PriceOriginHidden.Value = dt.Rows[0]["PriceOrigin"].ToString();
                        CostMethod.Value = dt.Rows[0]["CostMethod"].ToString();
                        OECost.Value = dt.Rows[0]["OECost"].ToString();
                        AltUOMQty.Value = dt.Rows[0]["AltUOMQty"].ToString();
                        string avgCost = (Convert.ToInt32(dt.Rows[0]["StdCost"]) != 0 ? dt.Rows[0]["StdCost"].ToString() : dt.Rows[0]["AvgCost"].ToString());
                        AvgCostText.Text = FormatScreenData(Num3Format, InSellUM(avgCost));
                        AvgCostHidden.Value = avgCost;
                        StdCostText.Text = FormatScreenData(Num3Format, dt.Rows[0]["IBPriceCost"]);
                        StdCostHidden.Value = InContUM(dt.Rows[0]["IBPriceCost"]).ToString();
                        SellPriceTextBox.Text = FormatScreenData(Num2Format, SOEAltPrice);
                        CurAltPrice.Value = SellPriceTextBox.Text.ToString();
                        lblTargetPrice.Text = "$" + FormatScreenData(Num2Format, dt.Rows[0]["AltSellPrice"]);
                        ContPriceLabel.Text = FormatScreenData(Num2Format, SOEPrice) + "/" + ContUOM.Value;
                        SuperDisc.Value = "1.000";
                        if (dt.Columns.Contains("SupEquivDiscPct"))
                            SuperDisc.Value = FormatScreenData(Num3Format, decimal.Parse(dt.Rows[0]["SupEquivDiscPct"].ToString()));
                        OriginalPrice.Value = FormatScreenData(Num2Format, SOEPrice);
                        WorkSellPriceTextBox.Text = FormatScreenData(Num2Format, SOEAltPrice);
                        WebPriceLabel.Text = FormatScreenData(DollarFormat, dt.Rows[0]["WebDiscPrice"]);
                        lblPromo.Text = (dt.Rows[0]["PromoCode"].ToString() == "" ? "N/A" : dt.Rows[0]["PromoCode"].ToString());
                        lblPromo.ToolTip = dt.Rows[0]["PromoFullDesc"].ToString();
                        lblTargetDisc.Text = Math.Round(Convert.ToDecimal(dt.Rows[0]["TargetDiscount"].ToString()) * 100, 1).ToString() + "%";
                        lblAdderPct.Text = dt.Rows[0]["PriceCostAdder"].ToString();
                        HighLightFields(dt);
                        PricingCalled.Value = "1";
                        wsRefresh(1);

                        // Suggested is Web Price so we calc from there
                        //SellSuggestLabel.Text = FormatScreenData("${0:#,##0.00}", dt.Rows[0]["WebPrice"]);
                        ItemSellPrice = (decimal)dt.Rows[0]["WebPrice"];
                        eComItemSellPrice = Convert.ToDecimal(dt.Rows[0]["WebDiscPrice"].ToString() != "" ? dt.Rows[0]["WebDiscPrice"].ToString() : "0.00");
                        try
                        {
                            MainMargin = 100 * ((eComItemSellPrice - MainCost) / eComItemSellPrice);
                            StdMargin = 100 * ((eComItemSellPrice - StdCost) / eComItemSellPrice);
                            ReplMargin = 100 * ((eComItemSellPrice - ReplCost) / eComItemSellPrice);
                        }
                        catch (Exception ep)
                        {
                            MainMargin = 0;
                            StdMargin = 0;
                            ReplMargin = 0;
                        }
                        try
                        {
                            SellLB = InContUM(eComItemSellPrice) / ItemWeight;
                            MarginLB = InContUM(eComItemSellPrice - MainCost) / ItemWeight;
                        }
                        catch (Exception ep)
                        {
                            SellLB = 0;
                            MarginLB = 0;
                        }
                        MgnCostSuggestLabel.Text = FormatScreenData("{0:#,##0.0}%", MainMargin);
                        MgnReplSuggestLabel.Text = FormatScreenData("{0:#,##0.0}%", ReplMargin);
                        SellLBSuggestLabel.Text = FormatScreenData("${0:#,##0.000}", SellLB);
                        MarginLBSuggestLabel.Text = FormatScreenData("${0:#,##0.000}", MarginLB);

                        SuperDiscount = decimal.Parse(SuperDisc.Value, NumberStyles.Number);
                        if (SuperDiscount == 1) SuperDiscount = 0;
                        SuperPriceLabel.Text = FormatScreenData(Num2Format, (1m - SuperDiscount) * ItemSellPrice);  
                    }
                }
            }
            GetHistory();
            WorkSheetUpdatePanel.Update();
            AddItemImageButton.Visible = true;
            ActionUpdatePanel.Update();
        }
        catch (Exception ex1)
        {
            string PassedData = OrderNumber + ":-1:" + ItemNumber + ":" + CustNumber + ":" + ShippingBranch.Value.ToString()
                + ":" + OrderTableName.Value.ToString() + ":" + DetailTableName.Value.ToString() + ":" + ItemQty 
                + ":" + CurPrice.Replace(",", "") + ":" + PriceOrigin + ":" + PriceCode + "\n";
            ShowPageMessage("Price Error " + PassedData + ex1.Message + ", " + ex1.ToString(), 2);
        }

    }

    protected void GetHistory()
    {
        LastInvoiceLabel.Attributes.Remove("onmousedown");
        LastInvoiceLabel.CssClass = "";
        LastQuoteLabel.Attributes.Remove("onmousedown");
        LastQuoteLabel.CssClass = "";
        LastECommLabel.Attributes.Remove("onmousedown");
        LastECommLabel.CssClass = "";
        OpenOrderLabel.Attributes.Remove("onmousedown");
        OpenOrderLabel.CssClass = "";
        
        // get the history data.
        SqlConnection conn = new SqlConnection(connectionString);        
        SqlDataAdapter adp;
        SqlCommand Cmd = new SqlCommand();
        ds = new DataSet();
        Cmd.CommandTimeout = 0;
        Cmd.CommandType = CommandType.StoredProcedure;
        Cmd.Connection = conn;
        conn.Open();
        try
        {
            Cmd.CommandText = "pSOEGetItemHist";
            Cmd.Parameters.Add(new SqlParameter("@SearchItemNo", InternalItemLabel.Text));
            Cmd.Parameters.Add(new SqlParameter("@Organization", CustNoTextBox.Text));
            Cmd.Parameters.Add(new SqlParameter("@HistoryType", "Metrics"));
            Cmd.Parameters.Add(new SqlParameter("@operateMode", OPERATINGMODE));
            adp = new SqlDataAdapter(Cmd);
            adp.Fill(ds);
        }
        finally
        {
            conn.Close();
        }

        if (ds.Tables.Count >= 1)
        {
            if (ds.Tables.Count == 1)
            {
                // We only go one table back, something is wrong
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    ShowPageMessage("History problem", 2);
                }
            }
            else
            {
                dt = ds.Tables[1];
                string DocLink = "";
                if (dt.Rows.Count > 0)
                {
                    int MetricRowIndex = 0;
                    DocLink = "";
                    DataView dvm = new DataView(dt, "", "MetricType", DataViewRowState.CurrentRows);
                    MetricRowIndex = dvm.Find("IV");
                    if (MetricRowIndex != -1)
                    {
                        // we found some last invoice data
                        DateLastInvoiceLabel.Text = String.Format(DateFormat, dvm[MetricRowIndex]["MetricDt"]);
                        QtyLastInvoiceLabel.Text = String.Format(Num0Format, dvm[MetricRowIndex]["MetricQty"]);
                        SellLastInvoiceLabel.Text = String.Format(DollarFormat, dvm[MetricRowIndex]["MetricSellUMPrice"]);
                        MgnCostLastInvoiceLabel.Text = String.Format(PcntFormat, dvm[MetricRowIndex]["MetricMarginAtCost"]);
                        //MgnStdLastInvoiceLabel.Text = String.Format(PcntFormat, dvm[MetricRowIndex]["MetricMarginAtStd"]);
                        MgnReplLastInvoiceLabel.Text = String.Format(PcntFormat, dvm[MetricRowIndex]["MetricMarginAtReplacementCost"]);
                        SellLBLastInvoiceLabel.Text = String.Format(Dollar3Format, dvm[MetricRowIndex]["MetricSellPerLB"]);
                        MarginLBLastInvoiceLabel.Text = String.Format(Dollar3Format, dvm[MetricRowIndex]["MetricMarginPerLB"]);
                        if (dvm[MetricRowIndex]["OrderNo"].ToString().Trim() != "-1")
                        {
                            DocLink = "ShowDoc('" + dvm[MetricRowIndex]["OrderNo"].ToString()
                                + "','" + dvm[MetricRowIndex]["MetricType"].ToString() + "');";
                            LastInvoiceLabel.Attributes.Add("onmousedown", DocLink);
                            LastInvoiceLabel.CssClass = "QOHLink";
                        }
                    }
                    MetricRowIndex = dvm.Find("RQ");
                    if (MetricRowIndex != -1)
                    {
                        // we found some last quote data
                        DateLastQuoteLabel.Text = String.Format(DateFormat, dvm[MetricRowIndex]["MetricDt"]);
                        QtyLastQuoteLabel.Text = String.Format(Num0Format, dvm[MetricRowIndex]["MetricQty"]);
                        SellLastQuoteLabel.Text = String.Format(DollarFormat, dvm[MetricRowIndex]["MetricSellUMPrice"]);
                        MgnCostLastQuoteLabel.Text = String.Format(PcntFormat, dvm[MetricRowIndex]["MetricMarginAtCost"]);
                        //MgnStdLastQuoteLabel.Text = String.Format(PcntFormat, dvm[MetricRowIndex]["MetricMarginAtStd"]);
                        MgnReplLastQuoteLabel.Text = String.Format(PcntFormat, dvm[MetricRowIndex]["MetricMarginAtReplacementCost"]);
                        SellLBLastQuoteLabel.Text = String.Format(Dollar3Format, dvm[MetricRowIndex]["MetricSellPerLB"]);
                        MarginLBLastQuoteLabel.Text = String.Format(Dollar3Format, dvm[MetricRowIndex]["MetricMarginPerLB"]);
                        if (dvm[MetricRowIndex]["OrderNo"].ToString().Trim() != "-1")
                        {
                            DocLink = "ShowDoc('" + dvm[MetricRowIndex]["OrderNo"].ToString()
                                + "','" + dvm[MetricRowIndex]["MetricType"].ToString() + "');";
                            LastQuoteLabel.Attributes.Add("onmousedown", DocLink);
                            LastQuoteLabel.CssClass = "QOHLink";
                        }
                    }
                    MetricRowIndex = dvm.Find("WQ");
                    if (MetricRowIndex != -1)
                    {
                        // we found some last e commerce data
                        DateLastECommLabel.Text = String.Format(DateFormat, dvm[MetricRowIndex]["MetricDt"]);
                        QtyLastECommLabel.Text = String.Format(Num0Format, dvm[MetricRowIndex]["MetricQty"]);
                        SellLastECommLabel.Text = String.Format(DollarFormat, dvm[MetricRowIndex]["MetricSellUMPrice"]);
                        MgnCostLastECommLabel.Text = String.Format(PcntFormat, dvm[MetricRowIndex]["MetricMarginAtCost"]);
                        //MgnStdLastECommLabel.Text = String.Format(PcntFormat, dvm[MetricRowIndex]["MetricMarginAtStd"]);
                        MgnReplLastECommLabel.Text = String.Format(PcntFormat, dvm[MetricRowIndex]["MetricMarginAtReplacementCost"]);
                        SellLBLastECommLabel.Text = String.Format(Dollar3Format, dvm[MetricRowIndex]["MetricSellPerLB"]);
                        MarginLBLastECommLabel.Text = String.Format(Dollar3Format, dvm[MetricRowIndex]["MetricMarginPerLB"]);
                        if (dvm[MetricRowIndex]["OrderNo"].ToString().Trim() != "-1")
                        {
                            DocLink = "ShowDoc('" + dvm[MetricRowIndex]["OrderNo"].ToString()
                                + "','" + dvm[MetricRowIndex]["MetricType"].ToString() + "');";
                            LastECommLabel.Attributes.Add("onmousedown", DocLink);
                            LastECommLabel.CssClass = "QOHLink";
                        }
                    }
                    MetricRowIndex = dvm.Find("SO");
                    if (MetricRowIndex != -1)
                    {
                        // we found some open order data
                        DateOpenOrderLabel.Text = String.Format(DateFormat, dvm[MetricRowIndex]["MetricDt"]);
                        QtyOpenOrderLabel.Text = String.Format(Num0Format, dvm[MetricRowIndex]["MetricQty"]);
                        SellOpenOrderLabel.Text = String.Format(DollarFormat, dvm[MetricRowIndex]["MetricSellUMPrice"]);
                        MgnCostOpenOrderLabel.Text = String.Format(PcntFormat, dvm[MetricRowIndex]["MetricMarginAtCost"]);
                        //MgnStdOpenOrderLabel.Text = String.Format(PcntFormat, dvm[MetricRowIndex]["MetricMarginAtStd"]);
                        MgnReplOpenOrderLabel.Text = String.Format(PcntFormat, dvm[MetricRowIndex]["MetricMarginAtReplacementCost"]);
                        SellLBOpenOrderLabel.Text = String.Format(Dollar3Format, dvm[MetricRowIndex]["MetricSellPerLB"]);
                        MarginLBOpenOrderLabel.Text = String.Format(Dollar3Format, dvm[MetricRowIndex]["MetricMarginPerLB"]);
                        if (dvm[MetricRowIndex]["OrderNo"].ToString().Trim() != "-1")
                        {
                            DocLink = "ShowDoc('" + dvm[MetricRowIndex]["OrderNo"].ToString()
                                + "','" + dvm[MetricRowIndex]["MetricType"].ToString() + "');";
                            OpenOrderLabel.Attributes.Add("onmousedown", DocLink);
                            OpenOrderLabel.CssClass = "QOHLink";
                        }
                    }
                }

                // Sathish: Fill Region & Competitor 
                if (OPERATINGMODE.ToLower() == "full")
                {
                    if (ds.Tables[2] != null && ds.Tables[2].Rows.Count > 0)
                    {
                        // We found last region quote data
                        DataRow drRegLastQuote = ds.Tables[2].Rows[0];
                        DateRegionLastQuote.Text = String.Format(DateFormat, drRegLastQuote["MetricDt"]);
                        QtyLastRegionQuoteLabel.Text = String.Format(Num0Format, drRegLastQuote["MetricQty"]);
                        SellLastRegionQuoteLabel.Text = String.Format(DollarFormat, drRegLastQuote["MetricSellUMPrice"]);
                        MgnCostLastRegionQuoteLabel.Text = String.Format(PcntFormat, drRegLastQuote["MetricMarginAtCost"]);
                        MgnReplLasRegionQuoteLabel.Text = String.Format(PcntFormat, drRegLastQuote["MetricMarginAtReplacementCost"]);
                        SellLBLastRegionQuoteLabel.Text = String.Format(Dollar3Format, drRegLastQuote["MetricSellPerLB"]);
                        MarginLBLastRegionQuoteLabel.Text = String.Format(Dollar3Format, drRegLastQuote["MetricMarginPerLB"]);

                        if (drRegLastQuote["OrderNo"].ToString().Trim() != "-1")
                        {
                            DocLink = "ShowDoc('" + drRegLastQuote["OrderNo"].ToString()
                                     + "','" + drRegLastQuote["MetricType"].ToString() + "');";
                            RegionLastQuoteLabel.Attributes.Add("onmousedown", DocLink);
                            RegionLastQuoteLabel.CssClass = "QOHLink";
                        }
                    }
                    if (ds.Tables[3] != null && ds.Tables[3].Rows.Count > 0)
                    {
                        // We found last region Order data
                        DataRow drRegLastOrder = ds.Tables[3].Rows[0];
                        DateRegionLastOrder.Text = String.Format(DateFormat, drRegLastOrder["MetricDt"]);
                        QtyLastRegionOrderLabel.Text = String.Format(Num0Format, drRegLastOrder["MetricQty"]);
                        SellLastRegionOrderLabel.Text = String.Format(DollarFormat, drRegLastOrder["MetricSellUMPrice"]);
                        MgnCostLastRegionOrdLabel.Text = String.Format(PcntFormat, drRegLastOrder["MetricMarginAtCost"]);
                        MgnReplLasRegionOrdLabel.Text = String.Format(PcntFormat, drRegLastOrder["MetricMarginAtReplacementCost"]);
                        SellLBLastRegionOrdLabel.Text = String.Format(Dollar3Format, drRegLastOrder["MetricSellPerLB"]);
                        MarginLBLastRegionOrderLabel.Text = String.Format(Dollar3Format, drRegLastOrder["MetricMarginPerLB"]);

                        if (drRegLastOrder["OrderNo"].ToString().Trim() != "-1")
                        {
                            DocLink = "ShowDoc('" + drRegLastOrder["OrderNo"].ToString()
                                     + "','" + drRegLastOrder["MetricType"].ToString() + "');";
                            RegionLastOrderLabel.Attributes.Add("onmousedown", DocLink);
                            RegionLastOrderLabel.CssClass = "QOHLink";
                        }
                    }
                    if (ds.Tables[4] != null && ds.Tables[4].Rows.Count > 0)
                    {
                        DisplayCompPrice(ds.Tables[4]);
                    }

                }
            }
        }
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.None)]
    public string GetOrginalDocNo(string DocNo, string DocType)
    {
        
        // get the history data.
        DataSet dsOrderDetail = new DataSet();
        SqlConnection conn = new SqlConnection(Global.PFCERPConnectionString);
        SqlDataAdapter adp;
        SqlCommand Cmd = new SqlCommand();
        Cmd.CommandTimeout = 0;
        Cmd.CommandType = CommandType.StoredProcedure;
        Cmd.Connection = conn;
        conn.Open();
        
        try
        {
            Cmd.CommandText = "pSOEGetItemHist";
            Cmd.Parameters.Add(new SqlParameter("@SearchItemNo", DocNo));
            Cmd.Parameters.Add(new SqlParameter("@Organization", ""));
            Cmd.Parameters.Add(new SqlParameter("@HistoryType", "LastMetrics"));
            Cmd.Parameters.Add(new SqlParameter("@operateMode", DocType));
            adp = new SqlDataAdapter(Cmd);
            adp.Fill(dsOrderDetail);
            
            if (dsOrderDetail != null & dsOrderDetail.Tables[1].Rows.Count > 0)
                return dsOrderDetail.Tables[1].Rows[0]["OrderNo"].ToString();
        }
        finally
        {
            conn.Close();
        }
         
        return "";
    }

    protected void SellPriceChanged(object sender, EventArgs e)
    {
        if (QuickQuote.Value == "0")
        {
            PriceOriginHidden.Value = "E";
            PriceOriginLabel.Text = "E";
        }
        else
        {
            PriceOriginHidden.Value = "Q";
            PriceOriginLabel.Text = "Q";
        }
        ItemUpdatePanel.Update();
    }

    protected void SellQtyChanged(object sender, EventArgs e)
    {
        wsRefresh(1); 
    }

    protected void EnablePricing(bool EntryState)
    {
        SellPriceTextBox.Enabled = EntryState;
        DiscPcntTextBox.Enabled = EntryState;
        DiscPriceTextBox.Enabled = EntryState;
        WorkSellPriceTextBox.Enabled = EntryState;
        MgnCostTextBox.Enabled = EntryState;
        //MgnStdTextBox.Enabled = EntryState;
        MgnReplTextBox.Enabled = EntryState;
        SellLBTextBox.Enabled = EntryState;
        MarginLBTextBox.Enabled = EntryState;
    }
    
    protected void DisableEntry(bool EntryState)
    {
        RequestedQtyTextBox.Enabled = !EntryState;
        SellPriceTextBox.Enabled = !EntryState;
        ItemUpdatePanel.Update();
        AddItemImageButton.Visible = !EntryState;
        ActionUpdatePanel.Update();
    }

    public bool IsUserHasSecurity(string securityCode)
    {
        try
        {
            object objSecurityCode = (object)   SqlHelper.ExecuteScalar(Global.PFCERPConnectionString, "pSOESelect",
                                                new SqlParameter("@tableName", "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU"),
                                                new SqlParameter("@columnNames", "SG.groupname as GroupName"),
                                                new SqlParameter("@whereClause", "SM.SecGroupID = SG.pSecGroupID  and  SM.SecUserID= SU.pSecUserID and SU.UserName='" + Session["UserName"].ToString() + "' AND SG.groupname='" + securityCode + "'"));

            if (objSecurityCode != null)
                return true;
            else
                return false;

        }
        catch (Exception Ex) { return false; }
    }
    
    #region Discount Input
    protected void DiscPcntSubmit_Click(object sender, EventArgs e)
    {
        wsRefresh(6);
        SOEPriceWorksheetScriptManager.SetFocus("DiscPriceTextBox");
    }

    protected void DiscPriceSubmit_Click(object sender, EventArgs e)
    {
        wsRefresh(7);
        SOEPriceWorksheetScriptManager.SetFocus("AddItemImageButton");
    }
    #endregion 

    #region Worksheet refresh
    /// <summary>
    /// Refresh prices and worksheet
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>

    protected decimal InSellUM(object BaseNo)
    {
        decimal BaseNumber = 0;
        if (decimal.TryParse(BaseNo.ToString(), out BaseNumber))
        {
            return (decimal)BaseNumber * SellMultiplier;
        }
        else
        {
            return (decimal)0;
        }
    }

    protected decimal InContUM(object BaseNo)
    {
        decimal BaseNumber = 0;
        if (decimal.TryParse(BaseNo.ToString(), out BaseNumber))
        {
            return (decimal)Math.Round(BaseNumber * (1 / SellMultiplier), 5);
        }
        else
        {
            return (decimal)0;
        }
    }

    protected void ContPriceButt_Click(object sender, EventArgs e)
    {
        // the container price process is actually used by the profitometer
        LineQty = int.Parse(SplitOffNum(QtyToSellLabel.Text), NumberStyles.Number);
        if (LineQty == 0)
        {
            ShowPageMessage("Profitometer does not work with zero (0) line qtys.", 2);
        }
        else
        {
            //if (SellSuggestLabel.Text.Trim().Length == 0)
            //{
            //    // we had no suggested price (probably G webpriceind processing)
            //    AltPrice = decimal.Parse(WebPriceLabel.Text.Replace("$", ""), NumberStyles.Number);
            //}
            //else
            //{
            //    AltPrice = decimal.Parse(SellSuggestLabel.Text.Replace("$", ""), NumberStyles.Number);
            //}

            ItemSellPrice = decimal.Parse(WorkSellPriceTextBox.Text, NumberStyles.Number);

            //if (ItemSellPrice > AltPrice)
            //{
            //    WorkSellPriceTextBox.Text = FormatScreenData(Num3Format, AltPrice);
            //    wsRefresh(1);
            //}
            //else
                //if (Thermo.WebPriceInd != "G")
                //{
                //    if (Thermo.ProfitPrice > 0)
                //    {
                //        PriceOriginHidden.Value = "E";
                //        PriceOriginLabel.Text = "E";
                //        wsRefresh(0);
                //        SOEPriceWorksheetScriptManager.SetFocus("SellPriceTextBox");
                //    }
                //}
                //else
                //{
                    //if (Thermo.ProfitPrice > 0)
                    //{
                    //    // update Suggested (AKA Break Even) 
                    //    ItemWeight = decimal.Parse(WorkItemWeightLabel.Text, NumberStyles.Number);
                    //    MainCost = decimal.Parse(AvgCostText.Text, NumberStyles.Number);
                    //    StdCost = decimal.Parse(StdCostText.Text, NumberStyles.Number);
                    //    ReplCost = decimal.Parse(ReplCostText.Text, NumberStyles.Number);
                    //        SellSuggestLabel.Text = FormatScreenData("${0:#,##0.00}", InSellUM(Thermo.ProfitPrice) / LineQty);
                    //        ItemSellPrice = InSellUM(Thermo.ProfitPrice) / LineQty;
                    //    try
                    //    {
                    //        MainMargin = 100 * ((ItemSellPrice - MainCost) / ItemSellPrice);
                    //        StdMargin = 100 * ((ItemSellPrice - StdCost) / ItemSellPrice);
                    //        ReplMargin = 100 * ((ItemSellPrice - ReplCost) / ItemSellPrice);
                    //    }
                    //    catch (Exception ep)
                    //    {
                    //        MainMargin = 0;
                    //        StdMargin = 0;
                    //        ReplMargin = 0;
                    //    }
                    //    try
                    //    {
                    //        SellLB = InContUM(ItemSellPrice) / ItemWeight;
                    //        MarginLB = InContUM(ItemSellPrice - MainCost) / ItemWeight;
                    //    }
                    //    catch (Exception ep)
                    //    {
                    //        SellLB = 0;
                    //        MarginLB = 0;
                    //    }
                    //    MgnCostSuggestLabel.Text = FormatScreenData("{0:#,##0.0}%", MainMargin);
                    //    //MgnStdSuggestLabel.Text = FormatScreenData("{0:#,##0.0}%", StdMargin);
                    //    MgnReplSuggestLabel.Text = FormatScreenData("{0:#,##0.0}%", ReplMargin);
                    //    SellLBSuggestLabel.Text = FormatScreenData("${0:#,##0.000}", SellLB);
                    //    MarginLBSuggestLabel.Text = FormatScreenData("${0:#,##0.000}", MarginLB);
                    //    WorkSheetUpdatePanel.Update();
                    //}
                //}
        }
    }

    //protected void SellPriceButt_Click(object sender, EventArgs e)
    //{
    //    string PriceErrorText = "";
    //    AltQty = decimal.Parse(AltUOMQty.Value.Replace(",",""));
    //    UnitQty = decimal.Parse(SellStkQty.Value.Replace(",", ""));
    //    decimal NewSellPrice;
    //    string PriceEntered = ContPriceLabel.Text.Trim().ToUpper();
    //    if (PriceEntered.Length == 0)
    //    {
    //        PriceErrorText = "A Price is required";
    //        goto PriceInputError;
    //    }
    //    else
    //    {
    //        // parse the input for possible UOM strings
    //        char[] PriceArray = PriceEntered.ToCharArray();
    //        string UOMText = "";
    //        string PriceText = "";
    //        foreach (Char pChar in PriceArray)
    //        {
    //            if (char.IsLetter(pChar)) UOMText += pChar;
    //            if (char.IsDigit(pChar)) PriceText += pChar;
    //            if (pChar.Equals('.')) PriceText += pChar;
    //        }
    //        if (PriceText.Length == 0)
    //        {
    //            PriceErrorText = "A Price is required";
    //            goto PriceInputError;
    //        }
    //        if (UOMText.Length != 0)
    //        {
    //            // get the uom
    //            ds = SqlHelper.ExecuteDataset(connectionString, "[pSOEGetItemUOM]",
    //                      new SqlParameter("@SearchItemNo", InternalItemLabel.Text),
    //                      new SqlParameter("@SearchUOM", UOMText));
    //            if (ds.Tables.Count >= 1)
    //            {
    //                if (ds.Tables.Count == 1)
    //                {
    //                    // We only go one table back, something is wrong
    //                    dt = ds.Tables[0];
    //                    if (dt.Rows.Count > 0)
    //                    {
    //                        PriceErrorText = "Invalid UOM";
    //                        goto PriceInputError;
    //                    }
    //                }
    //                UnitQty = int.Parse(SplitOffNumQtyUnitLabel.Text));
    //                dt = ds.Tables[1];
    //                AltQty = (decimal)dt.Rows[0]["UOMAltQty"];
    //                SellUOMLabel.Text = UOMText.ToUpper();
    //                SellPriceTextBox.Text = FormatScreenData(Num3Format, PriceText);
    //                NewSellPrice = decimal.Parse(PriceText) * UnitQty / (UnitQty / AltQty);
    //                ContPriceLabel.Text = FormatScreenData(Num2Format, NewSellPrice);
    //            }
    //        }
    //        else
    //        {
    //            ItemSellPrice = decimal.Parse(PriceText);
    //            SellPriceTextBox.Text = FormatScreenData(Num3Format, ItemSellPrice * AltQty / UnitQty);
    //        }
    //        WorkSellPriceTextBox.Text = SellPriceTextBox.Text;

    //        wsRefresh(1);
    //        SOEPriceWorksheetScriptManager.SetFocus("AddItemImageButton");
    //        return;
    //    }
    //PriceInputError:
    //    ShowPageMessage(PriceErrorText, 2);
    //    SOEPriceWorksheetScriptManager.SetFocus("ContPriceLabel");
    //    return;
    //}

    protected void BuyPriceButt_Click(object sender, EventArgs e)
    {
        if (ParseBuyPrice(SellPriceTextBox.Text))
        {
            SOEPriceWorksheetScriptManager.SetFocus("AddItemImageButton");
        }
        else
        {
            SOEPriceWorksheetScriptManager.SetFocus(ControlAfterQty);
        }
    }

    protected bool ParseBuyPrice(string BuyPrice)
    {
        if (decimal.TryParse(BuyPrice, out AltPrice))
        {
            //AltQty = decimal.Parse(AltUOMQty.Value, NumberStyles.Number);
            //ItemSellPrice = AltPrice;
            WorkSellPriceTextBox.Text = String.Format(Num2Format, AltPrice);
            wsRefresh(1);
            return true;
        }
        else
        {
            ShowPageMessage("Invalid Buy Price", 2);
            return false;
        }
    }

    protected void WsSellPriceButt_Click(object sender, EventArgs e)
    {
        wsRefresh(1);
        SOEPriceWorksheetScriptManager.SetFocus("MgnCostTextBox");
    }

    protected void WsMgnCostSubmit_Click(object sender, EventArgs e)
    {
        wsRefresh(2);
        SOEPriceWorksheetScriptManager.SetFocus("MgnStdTextBox");
    }

    protected void WsStdCostSubmit_Click(object sender, EventArgs e)
    {
        wsRefresh(3);
        SOEPriceWorksheetScriptManager.SetFocus("MgnReplTextBox");
    }

    protected void WsReplCostSubmit_Click(object sender, EventArgs e)
    {
        wsRefresh(8);
        SOEPriceWorksheetScriptManager.SetFocus("SellLBTextBox");
    }

    protected void WsSellLBSubmit_Click(object sender, EventArgs e)
    {
        wsRefresh(4);
        SOEPriceWorksheetScriptManager.SetFocus("MarginLBTextBox");
    }

    protected void WsMgnLBSubmit_Click(object sender, EventArgs e)
    {
        wsRefresh(5);
        SOEPriceWorksheetScriptManager.SetFocus("AddItemImageButton");
    }

    protected void wsRefresh(int WsField)
    {
        /*
        This procedure deals in container price. The design changed to have the user work the UOM (alt) price 
        case 0 can be used to work a profit price
        case 1 always converts the entered price into a container price
        
        things are kinda strange here because of the evolution of the pricing and costing calcs
        ItemSell price is Sell UOM price. 
        */
        //ItemWeight = decimal.Parse(WorkItemWeightLabel.Text, NumberStyles.Number);
        ItemWeight = decimal.Parse(WorkNetWeightLabel.Text, NumberStyles.Number);
        LineQty = int.Parse(SplitOffNum(QtyToSellLabel.Text), NumberStyles.Number);
        MainCost = decimal.Parse(AvgCostText.Text, NumberStyles.Number);
        StdCost = decimal.Parse(StdCostText.Text, NumberStyles.Number);
        ReplCost = decimal.Parse(ReplCostText.Text, NumberStyles.Number);
        UnitQty = decimal.Parse(SellStkQty.Value, NumberStyles.Number);
        ListPrice = decimal.Parse(SplitOffNum(ListPriceLabel.Text));
        //ItemSellPrice = decimal.Parse(WorkSellPriceTextBox.Text) * UnitQty / AltQty;
        if (MainCost == 0) MainCost = StdCost;
        switch (WsField)
        {
            //case 0:
            //    // user has clicked on the profitomer and wants to lowest price
            //    ItemSellPrice = InSellUM(Thermo.ProfitPrice) / LineQty;
            //    break;
            case 1:
                // user has changes sell price
                ItemSellPrice = decimal.Parse(WorkSellPriceTextBox.Text, NumberStyles.Number);
                break;
            case 2:
                // user has changed magin at avg. cost
                ItemSellPrice = (1 / (1 - (decimal.Parse(MgnCostTextBox.Text, NumberStyles.Number) / 100))) * MainCost;
                break;
            //case 3:
            //    // user has chnaged margin at std. cost
            //    ItemSellPrice = (1 / (1 - (decimal.Parse(MgnStdTextBox.Text, NumberStyles.Number) / 100))) * StdCost;
            //    break;
            case 4:
                // user has changed dollars / LB
                ItemSellPrice = InSellUM(SellLBTextBox.Text) * ItemWeight;
                break;
            case 5:
                // user has changed margin / LB
                ItemSellPrice = ((MainCost / ItemWeight) + InSellUM(MarginLBTextBox.Text)) * ItemWeight;
                break;
            case 6:
                // user has changed discount percent
                DiscountPcnt = decimal.Parse(DiscPcntTextBox.Text, NumberStyles.Number) / 100;
                ItemSellPrice = ListPrice - (ListPrice * DiscountPcnt);
                break;
            case 7:
                // user has changed discount price
                ItemSellPrice = decimal.Parse(DiscPriceTextBox.Text, NumberStyles.Number);
                break;
            case 8:
                // user has changed replacement cost 
                ItemSellPrice = (1 / (1 - (decimal.Parse(MgnReplTextBox.Text, NumberStyles.Number) / 100))) * ReplCost;
                break;
        }
        try
        {
            MainMargin = 100 * ((ItemSellPrice - MainCost) / ItemSellPrice);
            StdMargin = 100 * ((ItemSellPrice - StdCost) / ItemSellPrice);
            ReplMargin = 100 * ((ItemSellPrice - ReplCost) / ItemSellPrice);
        }
        catch (Exception e)
        {
            MainMargin = 0;
            StdMargin = 0;
            ReplMargin = 0;
        }
        try
        {
            SellLB = InContUM(ItemSellPrice) / ItemWeight;
            MarginLB = InContUM(ItemSellPrice - MainCost) / ItemWeight;
        }
        catch (Exception e)
        {
            SellLB = 0;
            MarginLB = 0;
        }
        // here we set it back to UOM price and this is what we use to populate the main pricing fields
        //AltPrice = ItemSellPrice * UnitQty / AltQty;
        TotAmtLabel.Text = FormatScreenData(Num2Format, LineQty * InContUM(ItemSellPrice));
        TotalCost.Value = FormatScreenData(Num3Format, InContUM(MainCost) * LineQty);
        //TotWeightLabel.Text = FormatScreenData(Num2Format, LineQty * ItemWeight);
        WorkSellPriceTextBox.Text = FormatScreenData(Num2Format, ItemSellPrice);
        CurWorkPrice.Value = WorkSellPriceTextBox.Text.ToString();
        MgnCostTextBox.Text = FormatScreenData(Num2Format, MainMargin);
        CurAvgMrgn.Value = MgnCostTextBox.Text.ToString();
        //MgnStdTextBox.Text = FormatScreenData(Num2Format, StdMargin);
        //CurStdMrgn.Value = MgnStdTextBox.Text.ToString();
        MgnReplTextBox.Text = FormatScreenData(Num2Format, ReplMargin);
        CurReplMrgn.Value = MgnReplTextBox.Text.ToString();
        SellLBTextBox.Text = FormatScreenData(Num3Format, SellLB);
        CurDolrLB.Value = SellLBTextBox.Text.ToString();
        MarginLBTextBox.Text = FormatScreenData(Num3Format, MarginLB);
        CurMrgnLB.Value = MarginLBTextBox.Text.ToString();
        SellPriceTextBox.Text = FormatScreenData(Num2Format, ItemSellPrice);
        CurAltPrice.Value = SellPriceTextBox.Text.ToString();
        AltQtyLabel.Text = FormatScreenData(Num0Format, LineQty * UnitQty);
        TargetMarginLB = decimal.Parse(TargetMargin.Value);

        ItemAmtLabel.Text = FormatScreenData(Num2Format, InContUM(ItemSellPrice));
        ItemMgnPctLabel.Text = (ItemSellPrice != 0 ?  Math.Round(100 * ((ItemSellPrice - MainCost) / ItemSellPrice), 2).ToString() : "0.00") ;
        ItemMgnDolLabel.Text = FormatScreenData(Num2Format, ItemSellPrice - MainCost);

        // Sathish: % diff field calc
        decimal _replCost = Convert.ToDecimal(ReplCostHidden.Value);
        if (_replCost == 0)
        {
            txtPctDiff.Text = "0.0";
        }
        else
        {
            decimal _stdCost = Convert.ToDecimal(AvgCostHidden.Value);
            txtPctDiff.Text = Math.Round((((_replCost - _stdCost) / _replCost) * 100 ), 1).ToString();
        }

        if (ItemColor.Value == "0")
        {
            if (MarginLB >= TargetMarginLB)
            {
                WorkSellPriceTextBox.CssClass = "ws_greenbox";
                MgnCostTextBox.CssClass = "ws_greenbox";
                //MgnStdTextBox.CssClass = "ws_greenbox";
                MgnReplTextBox.CssClass = "ws_greenbox";
                SellLBTextBox.CssClass = "ws_greenbox";
                MarginLBTextBox.CssClass = "ws_greenbox";
            }
            else
            {
                WorkSellPriceTextBox.CssClass = "ws_whitebox";
                MgnCostTextBox.CssClass = "ws_whitebox";
                //MgnStdTextBox.CssClass = "ws_whitebox";
                MgnReplTextBox.CssClass = "ws_whitebox";
                SellLBTextBox.CssClass = "ws_whitebox";
                MarginLBTextBox.CssClass = "ws_whitebox";
            }
        }
        // check profit using line cost only (-2)
        //Thermo.Update(connectionString, "-2", OrderTableName.Value, LineQty * InContUM(ItemSellPrice), InContUM(ReplCost) * LineQty, LineQty * ItemWeight, 1);
        //ThermoHoriz.Update(connectionString, OrderNumber.Value, OrderTableName.Value, LineQty * ItemSellPrice, MainCost * LineQty, LineQty * ItemWeight, 1);
        WorkSheetUpdatePanel.Update();
        ContPriceLabel.Text = FormatScreenData(Num2Format, InContUM(ItemSellPrice)) + "/" + ContUOM.Value;
        DiscPriceTextBox.Text = FormatScreenData(Num2Format, ItemSellPrice);
        CurDiscPrice.Value = DiscPriceTextBox.Text.ToString();
        try
        {
            DiscPcntTextBox.Text = FormatScreenData(Num2Format, 100 * (1 - (ItemSellPrice / ListPrice)));
        }
        catch (Exception e)
        {
            DiscPcntTextBox.Text="0";
        }
        CurDiscPcnt.Value = DiscPcntTextBox.Text.ToString();
        PriceOriginLabel.Text = PriceOriginHidden.Value;
        ItemUpdatePanel.Update();
    }
    #endregion

    #region Add Lines
    /// <summary>
    /// Add the line(s)
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void AddItemImageButton_Click(object sender, EventArgs e)
    {
        //ScriptManager.RegisterClientScriptBlock(CustNoTextBox, CustNoTextBox.GetType(), "Customer", "alert('LineAdded.Value.ToString()=" + LineAdded.Value.ToString() + " : session=" + Session[LineAdded.Value.ToString()].ToString() + "');", true);
        if ((bool)Session[LineAdded.Value.ToString()])
        {
            // user is machine gunning the add item button
            HistoryButt.Visible = false;
            PackPlateButt.Visible = false;
            Session["ItemNo"] = null;
            ClearItemData(false);
            ClearCalcData();
            //Session["SOEItemNumber"] = null;
            //Session["SOEItemDesc"] = null;
            CameraButt.Visible = false;
            CameraUpdatePanel.Update();
            SOEPriceWorksheetScriptManager.SetFocus("CustomerItemTextBox");
        }
        if (!IsValid)
        {
            // one of the validators was not happy
            return;
        }
        Session[LineAdded.Value.ToString()] = true;
        QuoteNumber.Value = "";
        string RemoteLoc = "";
        string RemoteLocName = "";
        int RemoteQty = 0;
        int RemoteOH = 0;
        int LinesAdded = 0;
        decimal RemoteStd = 0;
        decimal RemoteAvg = 0;
        decimal RemoteRepl = 0;
        LineFixed = false;
        //if we are not entering comments
        if (CommentEntry.Value.ToString() != "1")
        {
            // if the user has entered data but not used the Tab or Enter key, we may need to do some updates
            // check the qty
            //ScriptManager.RegisterClientScriptBlock(CustNoTextBox, CustNoTextBox.GetType(),
            //   "test2", "alert('QtyCheck=" + CurQty.Value.ToString() + "');", true);
            if (CurQty.Value.ToString() != RequestedQtyTextBox.Text.Replace(",", "").Trim().ToUpper())
            {
                // qty has changed so re-parse
                if (!ParseQty(RequestedQtyTextBox.Text.Replace(",", "").Trim().ToUpper()))
                {
                    Session[LineAdded.Value.ToString()] = false;
                    SOEPriceWorksheetScriptManager.SetFocus("RequestedQtyTextBox");
                    return;
                }
                //if (!CheckQOH())
                //{
                //    Session[LineAdded.Value.ToString()] = false;
                //    SOEPriceWorksheetScriptManager.SetFocus("RequestedQtyTextBox");
                //    return;
                //}
            }
            // check the sell price
            if (CurAltPrice.Value.ToString() != SellPriceTextBox.Text.ToString())
            {
                // price has changed so re-parse
                if (!ParseBuyPrice(SellPriceTextBox.Text))
                {
                    Session[LineAdded.Value.ToString()] = false;
                    SOEPriceWorksheetScriptManager.SetFocus(ControlAfterQty);
                    return;
                }
            }
            // check the worksheet data
            if (CurWorkPrice.Value.ToString() != WorkSellPriceTextBox.Text.ToString()) wsRefresh(1);
            if (CurAvgMrgn.Value.ToString() != MgnCostTextBox.Text.ToString()) wsRefresh(2);
            //if (CurStdMrgn.Value.ToString() != MgnStdTextBox.Text.ToString()) wsRefresh(3);
            if (CurReplMrgn.Value.ToString() != MgnReplTextBox.Text.ToString()) wsRefresh(8);
            if (CurDolrLB.Value.ToString() != SellLBTextBox.Text.ToString()) wsRefresh(4);
            if (CurMrgnLB.Value.ToString() != MarginLBTextBox.Text.ToString()) wsRefresh(5);
            if (CurDiscPcnt.Value.ToString() != DiscPcntTextBox.Text.ToString()) wsRefresh(6);
            if (CurDiscPrice.Value.ToString() != DiscPriceTextBox.Text.ToString()) wsRefresh(7);
        }
        
        LineError = false;
        ItemSellPrice = decimal.Parse(WorkSellPriceTextBox.Text, NumberStyles.Number);
        // check for remote branch qtys
        //tesdata = "RemoteQtys" + RemoteDataTextBox.Text + "<br>";
        if (UseRemoteQtys.Value == "1" && RemoteDataTextBox.Text != "")
        {
            //tesdata += "in" + "-";
            string[] RemoteRows = RemoteDataTextBox.Text.Split(new Char[] { '|' });
            for (int r = 0; r < RemoteRows.Length - 1; r++)
            {
                string[] RemoteCols = RemoteRows[r].Split(new Char[] { ';' });
                BigTextBox.Text = BigTextBox.Text + "\n" + RemoteRows[r] + "+++";
                RemoteLoc = RemoteCols[0];
                RemoteLocName = RemoteCols[1];
                //tesdata += "loc" + RemoteLoc + "|";
                RemoteQty = int.Parse(RemoteCols[3], NumberStyles.Number);
                // add a line. get the costs from the remote qty page
                RemoteOH = int.Parse(RemoteCols[2], NumberStyles.Number);
                RemoteStd = decimal.Parse(RemoteCols[4], NumberStyles.Number);
                RemoteAvg = decimal.Parse(RemoteCols[5], NumberStyles.Number);
                RemoteRepl = decimal.Parse(RemoteCols[6], NumberStyles.Number);
                //tesdata += "Cel3:" + RemoteCols[3].ToString() + "|Cel4:" + RemoteCols[4].ToString() + "|Cel5:" + RemoteCols[5].ToString() + "<br>";
                if (QuickQuote.Value == "0")
                {
                    AddLine(RemoteLoc, RemoteOH, RemoteQty, RemoteLocName, RemoteStd, RemoteAvg, RemoteRepl);
                }
                else
                {
                    AddQuoteLine(RemoteLoc, RemoteLocName, RemoteOH, RemoteQty);
                }               

                LinesAdded++;
            }
            // if we were updating from remote data while in line maintenance and the original line was not updated,
            // we delete it.
            if (((QuickQuote.Value == "0")) && (LineFix.Value == "1") && !LineFixed)
            {
                string OrderUpdValues = " DeleteDt = " + DateTime.Now.ToShortDateString();
                OrderUpdValues += ", ChangeID = '" + Session["UserName"].ToString() + "'";
                OrderUpdValues += ", ChangeDate = " + DateTime.Now.ToShortDateString();
                if (DetailTableName.Value.ToString() == "SODetail")
                {
                    whereClause = "pSODetailID = " + LineRecID.Value;
                }
                if (DetailTableName.Value.ToString() == "SODetailRel")
                {
                    whereClause = "pSODetailRelID = " + LineRecID.Value;
                }
                ds = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Update",
                             new SqlParameter("@tableName", DetailTableName.Value.ToString()),
                             new SqlParameter("@columnNames", OrderUpdValues),
                             new SqlParameter("@whereClause", whereClause));
            }
            //ShowPageMessage("tesdata" + tesdata + "<br>QuoteFix.Value=" + QuoteFix.Value.ToString(), 2);
        }
        //RemoteQtys = null;
        else
        {
            if (!int.TryParse(SplitOffNum(QtyToSellLabel.Text), NumberStyles.Number, null, out LineQty))
            {
                ShowPageMessage("Add line failed. QtyToSell=" + SplitOffNum(QtyToSellLabel.Text), 2);
                return;
            }
            if (!int.TryParse(AvailableQtyLabel.Text, NumberStyles.Number, null, out LineQOH))
            {
                ShowPageMessage("Add line failed. QOH=" + AvailableQtyLabel.Text.ToString(), 2);
                return;
            }
            if (QuickQuote.Value == "0")
            {
                AddLine(ShippingBranch.Value.ToString(), LineQOH, LineQty, ShippingBranchName.Value.ToString().Trim());
            }
            else
            {
                AddQuoteLine(LocationDropDownList.SelectedItem.Text.Split(new string[] { "-" }, StringSplitOptions.None)[0].Trim(),
                    LocationDropDownList.SelectedItem.Text.Split(new string[] { "-" }, StringSplitOptions.None)[1].Trim(),
                    LineQOH, LineQty);
            }
            LinesAdded = 1;
        }
        //LineError = false;
        // add cross reference 
        if (AddXrefCheckBox.Checked && CustomerItemTextBox.Text.Trim() != "No Alias")
        {
            AddXRef();
        }
        //TestPanel.Update();
        HistoryButt.Visible = false;
        PackPlateButt.Visible = false;
        Session["ItemNo"] = null;
        LastItemLabel.Text = "Last Item Entered: " + InternalItemLabel.Text;
        ClearItemData(false);
        ClearCalcData();

        // Sathish: Recompute Order sumnmary
        CalculateOrderTotal();
        CameraButt.Visible = false;
        CameraUpdatePanel.Update();
        if (!LineError)
        {
            ShowPageMessage(LinesAdded.ToString() + " Line(s) Added", 0);
            SOEPriceWorksheetScriptManager.SetFocus("CustomerItemTextBox");
        }
        if (QuoteRecall.Value == "1")
        {
            ScriptManager.RegisterClientScriptBlock(CustNoTextBox, CustNoTextBox.GetType(), "Customer", "window.opener.parent.document.form1.RemoteDetailRefreshButton.click();", true);
        }
    }

    protected string FormatLineColumn(int FieldNo, int FormatType, string FieldVal)
    {
        // FormatType 1=string, 2=int, 3=dec, 4=date
        string FieldResult = "";
        if (LineError)
        {
            return FieldResult;
        }
        switch (FormatType)
        {
            case 1:
                try
                {
                    FieldResult = String.Format(StringFieldFormat, FieldVal.Replace("'", "''").Trim());
                }
                catch (Exception ex)
                {
                    LineError = true;
                }
                break;
            case 2:
                try
                {
                    if (FieldVal == "")
                    {
                        FieldVal = "0";
                    }
                    FieldResult = String.Format(IntFieldFormat, int.Parse(FieldVal, NumberStyles.Number));
                }
                catch (Exception ex)
                {
                    LineError = true;
                }
                break;
            case 3:
                try
                {
                    if (FieldVal == "")
                    {
                        FieldVal = "0";
                    }
                    FieldResult = String.Format(NumFieldFormat, decimal.Parse(FieldVal, NumberStyles.Number));
                }
                catch (Exception ex)
                {
                    LineError = true;
                }
                break;
            case 4:
                try
                {
                    if (FieldVal == "")
                    {
                        FieldVal = DateTime.Now.ToShortDateString();
                    }
                    FieldResult = String.Format(DateFieldFormat, DateTime.Parse(FieldVal));
                }
                catch (Exception ex)
                {
                    //LineError = true;
                }
                break;
        }
        if (LineError)
        {
            ShowPageMessage("Error on field " + FieldNo.ToString() + " Val=" + FieldVal, 2);
        }
        return FieldResult;
    }

    protected void AddLine(string branch, int lineOH, int lineQty, string branchName )
    {
        // If the line was not split to remote branches, take the stuff from the form
        AddLine(branch, lineOH, lineQty, branchName, 
            decimal.Parse(StdCostHidden.Value, NumberStyles.Number),
            decimal.Parse(AvgCostHidden.Value, NumberStyles.Number),
            decimal.Parse(ReplCostHidden.Value, NumberStyles.Number));
    }

    protected void AddLine(string branch, int lineOH, int lineQty, string branchName, decimal StdCost, decimal AvgCost, decimal ReplCost)
    {
        int ExcludeFromUsage = 0;
        if (XFUCheck.Checked) ExcludeFromUsage = 1;
        string qtyStatus = "";
        string colNames = "";
        string CertRequiredInd = "0";
        whereClause = "";
        if (lineQty > lineOH) qtyStatus = "O";
        if (((CustCertRequiredInd.Value.Trim().ToUpper() == "TRUE") && (ItemCertRequiredInd.Value == "1"))
            || (ItemCertsReqdCheckBox.Checked))
            CertRequiredInd = "1";
        // extend the cost, price, gross weight and net weight
        AltQty = decimal.Parse(SellStkQty.Value) * lineQty;
        LineCost = lineQty * AvgCost;
        LinePrice = lineQty * InContUM(ItemSellPrice);
        LineGrossWeight = lineQty * decimal.Parse(SplitOffNum(WorkItemWeightLabel.Text), NumberStyles.Number);
        LineNetWeight = lineQty * decimal.Parse(SplitOffNum(WorkNetWeightLabel.Text), NumberStyles.Number);
        if ((LineFix.Value == "1") && (ShippingBranch.Value.ToString() == branch))
        {
            // we change the line
            string OrderUpdValues = "QtyOrdered = " + String.Format(IntFieldFormat, int.Parse(lineQty.ToString(), NumberStyles.Number));
            OrderUpdValues += " QtyShipped = " + String.Format(IntFieldFormat, int.Parse(lineQty.ToString(), NumberStyles.Number));
            OrderUpdValues += " QtyAvailLoc1 = '" + branch + "'";
            OrderUpdValues += ", QtyAvail1 = " + String.Format(IntFieldFormat, int.Parse(lineOH.ToString(), NumberStyles.Number));
            OrderUpdValues += " NetUnitPrice = " + String.Format(NumFieldFormat, InContUM(ItemSellPrice));
            OrderUpdValues += " AlternatePrice = " + String.Format(NumFieldFormat, decimal.Parse(SellPriceTextBox.Text, NumberStyles.Number));
            OrderUpdValues += " IMLoc = '" + branch + "'";
            OrderUpdValues += ", IMLocName = '" + branchName + "'";
            OrderUpdValues += ", ExtendedPrice = " + String.Format(NumFieldFormat, decimal.Parse(LinePrice.ToString(), NumberStyles.Number));
            OrderUpdValues += " ExtendedCost = " + String.Format(NumFieldFormat, decimal.Parse(LineCost.ToString(), NumberStyles.Number));
            OrderUpdValues += " ExtendedNetWght = " + String.Format(NumFieldFormat, decimal.Parse(LineNetWeight.ToString(), NumberStyles.Number));
            OrderUpdValues += " ExtendedGrossWght = " + String.Format(NumFieldFormat, decimal.Parse(LineGrossWeight.ToString(), NumberStyles.Number));
            OrderUpdValues += " AlternateUMQty = " + String.Format(NumFieldFormat, decimal.Parse(AltQty.ToString(), NumberStyles.Number));
            OrderUpdValues += " Remark = '" + LineItemCommentTextBox.Text.Replace("'", "''") + "'";
            OrderUpdValues += ", QtyStatus = '" + qtyStatus + "'";
            OrderUpdValues += ", CertRequiredInd = '" + CertRequiredInd + "'";
            //OrderUpdValues += " OrderCarrier = '" + CarrierDropDownList.SelectedItem.Text.Split(new string[] { " - " }, StringSplitOptions.None)[0].Trim() + "'"; //OrderCarrier
            //OrderUpdValues += ", OrderCarName = '" + CarrierDropDownList.SelectedItem.Text.Split(new string[] { " - " }, StringSplitOptions.None)[1].Trim() + "'"; //OrderCarName
            //OrderUpdValues += ", OrderFreightCd = '" + FreightDropDownList.SelectedItem.Text.Split(new string[] { " - " }, StringSplitOptions.None)[0].Trim() + "'"; //OrderFreightCd
            //OrderUpdValues += ", OrderFreightName = '" + FreightDropDownList.SelectedItem.Text.Split(new string[] { " - " }, StringSplitOptions.None)[1].Trim() + "'"; //OrderFreightName
            OrderUpdValues += ", ChangeID = '" + Session["UserName"].ToString() + "'";
            OrderUpdValues += ", ChangeDate = '" + DateTime.Now.ToShortDateString() + "'";
            if (DetailTableName.Value.ToString() == "SODetail")
            {
                whereClause = "pSODetailID = " + LineRecID.Value;
            }
            if (DetailTableName.Value.ToString() == "SODetailRel")
            {
                whereClause = "pSODetailRelID = " + LineRecID.Value;
            }
            //BigTextBox.Text = OrderUpdValues + " where " + whereClause;
            //TestPanel.Update();
            ds = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Update",
                          new SqlParameter("@tableName", DetailTableName.Value.ToString()),
                          new SqlParameter("@columnNames", OrderUpdValues),
                          new SqlParameter("@whereClause", whereClause));
            LineFixed = true;
        }
        else
        {
            // build the value string
            string colValues = FormatLineColumn(1, 2, OrderNumber.Value); //fSOHeaderID
            colValues += FormatLineColumn(2, 2, LineNumber.Value); //LineNumber
            colValues += FormatLineColumn(40, 2, LineNumber.Value); //LineSeq
            colValues += FormatLineColumn(3, 1, "S"); //LineType
            colValues += FormatLineColumn(4, 1, PriceOriginLabel.Text); //LinePriceInd
            colValues += FormatLineColumn(70, 1, LineReasonCode.Value); //LineReason
            colValues += FormatLineColumn(71, 1, LineReasonCodeDesc.Value); //LineReasonDsc
            colValues += FormatLineColumn(72, 1, LineExpediteCode.Value); //LineExpdCd
            colValues += FormatLineColumn(73, 1, LineExpediteCodeDesc.Value); //LineExpdCdDsc
            colValues += FormatLineColumn(5, 1, InternalItemLabel.Text); //ItemNo
            colValues += FormatLineColumn(6, 1, ItemDescLabel.Text); //ItemDsc
            colValues += FormatLineColumn(41, 1, "STOCK"); //BinLoc
            colValues += FormatLineColumn(7, 1, branch.Trim()); //IMLoc
            colValues += FormatLineColumn(67, 1, branchName.Trim()); //IMLocName
            colValues += FormatLineColumn(8, 1, CostMethod.Value); //CostInd
            colValues += FormatLineColumn(42, 1, HeadingPriceCodeLabel.Text); //PriceCd
            colValues += FormatLineColumn(9, 1, "E"); //LISource
            colValues += FormatLineColumn(43, 1, " "); //QtyStat
            colValues += FormatLineColumn(44, 3, "0"); //ComPct
            colValues += FormatLineColumn(45, 3, "0"); //ComDol
            colValues += FormatLineColumn(10, 3, InContUM(ItemSellPrice).ToString()); //NetUnitPrice
            colValues += FormatLineColumn(11, 3, ListPriceHidden.Value); //ListUnitPrice
            colValues += FormatLineColumn(12, 3, InContUM(ItemSellPrice).ToString()); //DiscUnitPrice
            colValues += FormatLineColumn(13, 3, DiscPcntTextBox.Text); //DiscPct1
            colValues += FormatLineColumn(46, 3, "0"); //DiscPct2
            colValues += FormatLineColumn(47, 3, "0"); //DiscPct3
            colValues += FormatLineColumn(14, 1, branch); //QtyAvailLoc1
            colValues += FormatLineColumn(15, 2, lineOH.ToString()); //QtyAvail1
            colValues += FormatLineColumn(16, 1, ""); //QtyAvailLoc2
            colValues += FormatLineColumn(17, 2, "0"); //QtyAvail2
            colValues += FormatLineColumn(18, 1, ""); //QtyAvailLoc3
            colValues += FormatLineColumn(19, 2, "0"); //QtyAvail3
            colValues += FormatLineColumn(48, 2, "0"); //OrigOrderLineNo
            colValues += FormatLineColumn(20, 4, ShipDate.Value); //RqstdShipDt
            colValues += FormatLineColumn(21, 4, ShipDate.Value); //OrigShipDt
            colValues += FormatLineColumn(49, 4, ShipDate.Value); //SuggstdShipDt
            colValues += FormatLineColumn(22, 2, SplitOffNum(QtyToSellLabel.Text)); //OriginalQtyRequested
            colValues += FormatLineColumn(23, 2, lineQty.ToString()); //QtyOrdered
            colValues += FormatLineColumn(24, 2, lineQty.ToString()); //QtyShipped
            colValues += FormatLineColumn(50, 2, "0"); //QtyBO
            colValues += FormatLineColumn(25, 1, ContUOM.Value); //SellStkUM
            colValues += FormatLineColumn(51, 2, "1"); //SellStkFactor
            colValues += FormatLineColumn(26, 3, AvgCost.ToString()); //UnitCost
            colValues += FormatLineColumn(52, 3, StdCost.ToString()); //UnitCost2
            colValues += FormatLineColumn(66, 3, ReplCost.ToString()); //UnitCost3
            colValues += FormatLineColumn(27, 3, AvgCost.ToString()); //RepCost
            colValues += FormatLineColumn(28, 3, OECost.Value); //OECost
            colValues += FormatLineColumn(58, 1, LineItemCommentTextBox.Text); //Remark
            colValues += FormatLineColumn(29, 1, CustomerItemTextBox.Text.Trim().Replace("No Alias", "").ToUpper()); //CustItemNo
            colValues += FormatLineColumn(53, 1, CustDesc.Value); //CustItemDsc
            colValues += FormatLineColumn(30, 4, DateTime.Now.ToShortDateString()); //EntryDate
            colValues += FormatLineColumn(31, 1, Session["UserName"].ToString()); //EntryID
            colValues += FormatLineColumn(54, 1, " "); //StatusCd
            colValues += FormatLineColumn(32, 3, WorkItemWeightLabel.Text); //GrossWght
            colValues += FormatLineColumn(33, 3, WorkNetWeightLabel.Text); //NetWght
            colValues += FormatLineColumn(34, 3, LinePrice.ToString()); //ExtendedPrice
            colValues += FormatLineColumn(35, 3, LineCost.ToString()); //ExtendedCost
            colValues += FormatLineColumn(36, 3, LineNetWeight.ToString()); //ExtendedNetWght
            colValues += FormatLineColumn(37, 3, LineGrossWeight.ToString()); //ExtendedGrossWght
            colValues += FormatLineColumn(38, 3, SellStkQty.Value); //SellStkQty
            colValues += FormatLineColumn(61, 1, SellUOMLabel.Text); //AlternateUM
            colValues += FormatLineColumn(63, 2, AltQty.ToString()); //AlternateUMQty
            colValues += FormatLineColumn(39, 1, SuperUOM.Value); //SuperEquivUM 
            colValues += FormatLineColumn(55, 2, SuperQty.Value); //SuperEquivQty
            colValues += FormatLineColumn(56, 1, qtyStatus); //QtyStatus
            colValues += FormatLineColumn(57, 2, ExcludeFromUsage.ToString()); //ExcludedFromUsageFlag
            colValues += FormatLineColumn(59, 3, SellPriceTextBox.Text); //AlternatePrice
            colValues += FormatLineColumn(60, 1, Session["CarrierCode"].ToString()); //CarrierCd
            colValues += FormatLineColumn(76, 1, CertRequiredInd); //CertRequiredInd
            colValues += FormatLineColumn(75, 1, Session["FreightCode"].ToString()).Replace(",", ""); //FreightCd
            if (DetailTableName.Value.ToString() == "SODetail")
            {
                colNames = "fSOHeaderID, " + DetailColumnNames;
            }
            if (DetailTableName.Value.ToString() == "SODetailRel")
            {
                colNames = "fSOHeaderRelID, " + DetailColumnNames;
            }
            //// add all the values into a new detail line   Visible="false"
            //BigTextBox.Text = DetailColumnNames + ") values (" + colValues;
            //TestPanel.Update();
            try
            {
                ds = SqlHelper.ExecuteDataset(connectionString, "pSOEInsLI",
                      new SqlParameter("@tableName", DetailTableName.Value.ToString()),
                      new SqlParameter("@columnNames", colNames),
                      new SqlParameter("@columnValues", colValues));
            }
            catch (SqlException ex1)
            {
                if ((ex1.Number == 2601))
                {
                    // we got a duplicate, so increment the line number and try again
                    NewLineNumber = int.Parse(LineNumber.Value) + 10;
                    LineNumber.Value = NewLineNumber.ToString();
                    AddLine(branch, lineOH, lineQty, branchName);
                }
                else
                {
                    LineError = true;
                    ShowPageMessage("Error adding line(1) " + ex1.Message + ", " + ex1.Number.ToString() + ", " + ex1.LineNumber.ToString(), 2);
                }
            }
            Session["LineItemNumber"] = int.Parse(LineNumber.Value);
            NewLineNumber = int.Parse(LineNumber.Value) + 10;
            LineNumber.Value = NewLineNumber.ToString();
        }
    }

    protected void AddQuoteLine(string branch, string branchName, int lineOH, int lineQty)
    {
        string RecID = "";
        string CertRequiredInd = "0";
        bool LineExists = false;
        AltQty = 1;
        LinePrice = 0;
        if (((CustCertRequiredInd.Value.Trim().ToUpper() == "TRUE") && (ItemCertRequiredInd.Value == "1"))
           || (ItemCertsReqdCheckBox.Checked))
            CertRequiredInd = "1";
        if (CommentEntry.Value.ToString() != "1")
        {
            // extend
            AltQty = decimal.Parse(SellStkQty.Value) * lineQty;
            LinePrice = lineQty * InContUM(ItemSellPrice);
        }
        // build the value string
        string colValues = "";
        try
        {
            colValues += FormatLineColumn(1, 1, Session["UserName"].ToString()); //UserID
        }
        catch (SqlException ex1)
        {
            ShowPageMessage("Your session has expired. You must shut down Umbrella and restart", 2);
            return;
        }
        if ((QuoteFix.Value == "1"))
        {
            // we change the line
            string QuoteUpdValues = "RequestQuantity = " + String.Format(IntFieldFormat, int.Parse(lineQty.ToString(), NumberStyles.Number));
            QuoteUpdValues += " AvailableQuantity = " + String.Format(IntFieldFormat, int.Parse(lineOH.ToString(), NumberStyles.Number));
            QuoteUpdValues += " UnitPrice = " + InContUM(ItemSellPrice).ToString();
            QuoteUpdValues += ", LocationCode = '" + branch + "'";
            QuoteUpdValues += ", LocationName = '" + branchName + "'";
            QuoteUpdValues += ", TotalPrice = " + String.Format(NumFieldFormat, decimal.Parse(LinePrice.ToString(), NumberStyles.Number));
            QuoteUpdValues += " RequestorQuoteRemarks = '" + LineItemCommentTextBox.Text.Replace("'", "''") + "'";
            QuoteUpdValues += ", AltPrice = " + String.Format(NumFieldFormat, decimal.Parse(SellPriceTextBox.Text, NumberStyles.Number));
            QuoteUpdValues += " AlternateUOMQty = " + String.Format(NumFieldFormat, decimal.Parse(AltQty.ToString(), NumberStyles.Number));
            QuoteUpdValues += " SalesLocationCode = '" + branch + "'";
            QuoteUpdValues += ", OrderCarrier = '" + CarrierDropDownList.SelectedItem.Text.Split(new string[] { " - " }, StringSplitOptions.None)[0].Trim() + "'"; //OrderCarrier
            QuoteUpdValues += ", OrderCarName = '" + CarrierDropDownList.SelectedItem.Text.Split(new string[] { " - " }, StringSplitOptions.None)[1].Trim() + "'"; //OrderCarName
            QuoteUpdValues += ", OrderFreightCd = '" + FreightDropDownList.SelectedItem.Text.Split(new string[] { " - " }, StringSplitOptions.None)[0].Trim() + "'"; //OrderFreightCd
            QuoteUpdValues += ", OrderFreightName = '" + FreightDropDownList.SelectedItem.Text.Split(new string[] { " - " }, StringSplitOptions.None)[1].Trim() + "'"; //OrderFreightName
            QuoteUpdValues += ", ContactName = '" + QuoteContactTextBox.Text.Trim().Replace("'", "''") + "'";
            QuoteUpdValues += ", CertRequiredInd = '" + CertRequiredInd + "'";
            QuoteUpdValues += ", ChangeID = '" + Session["UserName"].ToString() + "'";
            QuoteUpdValues += ", ChangeDt = '" + DateTime.Now.ToShortDateString() + "'";
            ds = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Update",
                          new SqlParameter("@tableName", "DTQ_CustomerQuotation"),
                          new SqlParameter("@columnNames", QuoteUpdValues),
                          new SqlParameter("@whereClause", "QuoteNumber = '" + QuoteLineNo.Value + "'"));
        }
        else
        {
            // we add the line
            colValues += FormatLineColumn(3, 1, CustNoTextBox.Text); //CustomerNumber
            colValues += FormatLineColumn(4, 1, CustNameLabel.Text); //CustomerName
            //colValues += FormatLineColumn(5, 4, DateTime.Now.ToShortDateString()); //QuotationDate
            //colValues += FormatLineColumn(6, 4, DateTime.Now.AddDays(QuoteExpiry).ToShortDateString()); //ExpiryDate
            colValues += FormatLineColumn(7, 1, CustomerItemTextBox.Text.Trim().Replace("No Alias", "").ToUpper()); //UserItemNo
            colValues += FormatLineColumn(8, 1, InternalItemLabel.Text); //PFCItemNo
            colValues += FormatLineColumn(9, 1, ItemDescLabel.Text); //Description
            colValues += FormatLineColumn(10, 2, lineQty.ToString()); //RequestQuantity
            colValues += FormatLineColumn(11, 2, lineOH.ToString()); //AvailableQuantity
            colValues += FormatLineColumn(12, 1, SellUOMLabel.Text); //PriceUOM
            colValues += FormatLineColumn(13, 1, ContUOM.Value); //BaseUOM
            colValues += FormatLineColumn(14, 3, SellStkQty.Value); //BaseUOMQty
            colValues += FormatLineColumn(15, 1, SellUOMLabel.Text); //AlternateUOM
            colValues += FormatLineColumn(16, 2, AltQty.ToString()); //AlternateUOMQty
            colValues += FormatLineColumn(17, 3, WorkItemWeightLabel.Text); //GrossWeight
            colValues += FormatLineColumn(18, 3, WorkNetWeightLabel.Text); //Weight
            colValues += FormatLineColumn(19, 3, InContUM(ItemSellPrice).ToString()); //UnitPrice
            colValues += FormatLineColumn(20, 1, branch); //LocationCode
            colValues += FormatLineColumn(21, 1, branchName); //LocationName
            colValues += FormatLineColumn(22, 3, LinePrice.ToString()); //TotalPrice
            colValues += FormatLineColumn(23, 1, LineItemCommentTextBox.Text); //RequestorQuoteRemarks
            colValues += FormatLineColumn(24, 2, "0"); //OrderCompletionStatus
            colValues += FormatLineColumn(25, 2, "0"); //QuoteConfirmStatus
            colValues += FormatLineColumn(26, 3, SellPriceTextBox.Text); //AltPrice
            colValues += FormatLineColumn(27, 1, SellUOMLabel.Text); //AltPriceUOM
            colValues += FormatLineColumn(28, 2, "0"); //DeleteFlag
            colValues += FormatLineColumn(29, 1, ""); //Status
            colValues += FormatLineColumn(30, 2, "0"); //RemoveFlag
            colValues += FormatLineColumn(31, 1, branch); //SalesLocationCode
            colValues += FormatLineColumn(32, 1, CarrierDropDownList.SelectedItem.Text.Split(new string[] { " - " }, StringSplitOptions.None)[0].Trim()); //OrderCarrier
            colValues += FormatLineColumn(33, 1, CarrierDropDownList.SelectedItem.Text.Split(new string[] { " - " }, StringSplitOptions.None)[1].Trim()); //OrderCarName
            colValues += FormatLineColumn(41, 1, FreightDropDownList.SelectedItem.Text.Split(new string[] { " - " }, StringSplitOptions.None)[0].Trim()); //OrderFreightCd
            colValues += FormatLineColumn(42, 1, FreightDropDownList.SelectedItem.Text.Split(new string[] { " - " }, StringSplitOptions.None)[1].Trim()); //OrderFreightName
            colValues += FormatLineColumn(34, 1, Session["UserName"].ToString()); //EntryID
            colValues += FormatLineColumn(35, 4, DateTime.Now.ToShortDateString()); //EntryDate
            colValues += FormatLineColumn(36, 1, QuoteContactTextBox.Text.Trim()); //ContactName
            colValues += FormatLineColumn(37, 2, lineQty.ToString()); //InitialRequestQty
            colValues += FormatLineColumn(38, 1, branch); //InitialLocationCode
            colValues += FormatLineColumn(39, 2, lineOH.ToString()); //InitialAvailableQty
            colValues += FormatLineColumn(45, 1, CertRequiredInd); //CertRequiredInd
            colValues += FormatLineColumn(43, 1, "RQ"); //OrderSource
            colValues += FormatLineColumn(43, 1, (AvgCostHidden.Value == "" ? "0" : AvgCostHidden.Value)).Replace(",", ""); //UnitCost
            //// add all the values into a new quote line
            BigTextBox.Text = colValues;
            TestPanel.Update();
            try
            {
                ds = SqlHelper.ExecuteDataset(connectionString, "DTQ_SP_QuoteInsertion",
                  new SqlParameter("@QuickQuoteNo", QuoteNumberLabel.Text.ToString()),
                  new SqlParameter("@QuoteLineNo", QuoteLineNo.Value),
                  new SqlParameter("@columnNames", QuoteColumnNames),
                  new SqlParameter("@columnValues", colValues));
                if (ds.Tables.Count >= 1)
                {
                    // grab the Quote number
                    dt = ds.Tables[0];
                    if (dt.Rows.Count > 0)
                    {
                        if (QuoteNumberLabel.Text.Trim() == "")
                        {
                            QuoteNumber.Value = dt.Rows[0][0].ToString();
                            QuoteNumberLabel.Text = dt.Rows[0][0].ToString();
                        }
                        CustWeightLabel.Text = FormatScreenData(Num2Format, ds.Tables[2].Rows[0]["TotWeight"]);
                        QuoteAmountLabel.Text = FormatScreenData(Num2Format, ds.Tables[2].Rows[0]["TotAmt"]);
                        QuoteLinesLabel.Text = ds.Tables[2].Rows[0]["LineCount"].ToString();
                        //Session["QuoteLineNumber"] = int.Parse(QuoteLineNo.Value);
                        NewQuoteLineNumber = int.Parse(QuoteLineNo.Value) + 10;
                        QuoteLineNo.Value = NewQuoteLineNumber.ToString();
                        // update customer metrics. second table should have rec id
                        RecID = ds.Tables[1].Rows[0][0].ToString();
                        SqlHelper.ExecuteNonQuery(connectionString, "pSOEProcessCustomerMetrics",
                                 new SqlParameter("@orderID", RecID),
                                 new SqlParameter("@lineNo", 0),
                                 new SqlParameter("@table", "RepQuote"));
                        ReviewQuoteButton.Visible = true;
                        //LineError = true;
                        //ShowPageMessage("Inserted Metric ID: " + RecID, 2);
                    }
                    else
                    {
                        LineError = true;
                        ShowPageMessage("Line Insertion failed. Empty data tables returned", 2);
                    }
                }
                else
                {
                    LineError = true;
                    ShowPageMessage("Line Insertion failed. No Tables", 2);
                }
            }
            catch (SqlException ex1)
            {
                if ((ex1.Number == 2627))
                {
                    LineExists = true;
                }
                else
                {
                    LineError = true;
                    StringBuilder errorMessages = new StringBuilder();
                    for (int i = 0; i < ex1.Errors.Count; i++)
                    {
                        errorMessages.Append("<p>SQL Error Index #" + i + "<br>" +
                            "Message: " + ex1.Errors[i].Message + "<br>" +
                            "LineNumber: " + ex1.Errors[i].LineNumber + "<br>" +
                            "Source: " + ex1.Errors[i].Source + "<br>" +
                            "Procedure: " + ex1.Errors[i].Procedure + "</p>");
                    }

                    ShowPageMessage("<p>Error adding quote line " + ex1.ToString() + "</p>" + errorMessages, 2);
                }
            }
            if (LineExists)
            {
                // we got a duplicate, so increment the line number and try again
                ShowPageMessage("Duplicate line for " + QuoteLineNo.Value.ToString() + ", trying " + string.Format(Num0Format, int.Parse(QuoteLineNo.Value) + 10), 1);
                NewLineNumber = int.Parse(QuoteLineNo.Value) + 10;
                QuoteLineNo.Value = NewLineNumber.ToString();
                LineExists = false;
                //wait 1 seconds 
                System.Threading.Thread.Sleep(1000);
                AddQuoteLine(branch, branchName, lineOH, lineQty);
                LineExists = false;
            }
        }
    }

    protected void AddXRef()
    {
        string colNames = "ItemNo, OrganizationNo, AliasItemNo, AliasDesc, UOM, EntryID, EntryDt";
        string colValues = FormatLineColumn(1, 1, InternalItemLabel.Text.Trim()); //ItemNo
        colValues += FormatLineColumn(2, 1, CustNoTextBox.Text.Trim()); //OrganizationNo
        colValues += FormatLineColumn(3, 1, CustomerItemTextBox.Text.Trim().ToUpper()); //AliasItemNo
        colValues += FormatLineColumn(4, 1, ItemDescLabel.Text.Trim()); //AliasDesc
        colValues += FormatLineColumn(5, 1, ContUOM.Value.Trim()); //UOM
        colValues += FormatLineColumn(6, 1, Session["UserName"].ToString()); //EntryID
        colValues += FormatLineColumn(7, 4, DateTime.Now.ToShortDateString()).Replace(",", ""); //AliasItemNo
        ds = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Insert",
             new SqlParameter("@tableName", "ItemAlias"),
             new SqlParameter("@columnNames", colNames),
             new SqlParameter("@columnValues", colValues));
    }

    #endregion

    #region Clear Data

    protected void ClearItemData(bool NewItem)
    {
        // if NewItem is true, we are clearing after an item is entered
        // otherwise we are clearing after a line has been addedd
        DisableEntry(true);
        HeadImageUpdatePanel.Visible = false;
        BodyImageUpdatePanel.Visible = false;
        if (!NewItem) CustomerItemTextBox.Text = "";
        AddXrefCheckBox.Checked = false;
        AddXrefCheckBox.Enabled = false;
        InternalItemLabel.Text = "";
        ItemCertsReqdCheckBox.Checked = false;
        UseRemoteQtys.Value = "";
        CommentEntry.Value = "0";
        RemoteDataTextBox.Text = "";
        ItemColor.Value = "0";
        TotalCost.Value = "0";
        this.RequestedQtyTextBox.Text = "";
        QtyToSellLabel.Text = "";
        AvailableQtyLabel.Text = "";
        FilledQtyHidden.Value = "";
        Loc1.Value = "";
        Qty1.Value = "0";
        Loc2.Value = "";
        Qty2.Value = "0";
        Loc3.Value = "";
        Qty3.Value = "0";
        ContPriceLabel.Text = "";
        ContUOM.Value = "";
        PieceQty.Value = "";
        TotPieceQty.Value = "";
        ItemDescLabel.Text = "";
        ItemDescLabel.CssClass = "ws_data_left";
        XFUCheck.Checked = false;
        SuperLabel.Text = "";
        //CatVLabel.Text = "";
        AltQtyLabel.Text = "";
        SellPriceTextBox.Text = "";
        SellUOMLabel.Text = "";
        QtyUnitLabel.Text = "";
        PriceOriginLabel.Text = "";
        ReplCostText.Text = "";
        ReplCostHidden.Value = "";
        AvgCostText.Text = "";
        AvgCostHidden.Value = "";
        StdCostText.Text = "";
        StdCostHidden.Value = "";
        ListPriceLabel.Text = "";
        ListPriceHidden.Value = "";
        DiscPcntTextBox.Text = "";
        DiscPriceTextBox.Text = "";
        MillCostInput.Text = "";
        LineItemCommentTextBox.Text = "";
        SuperPriceLabel.Text = "";
        ItemUpdatePanel.Update();
        CategorySpecLabel.Text = "";
        CategoryUpdatePanel.Update();
        NoSKUOnFile.Value = "0";
        PricingCalled.Value = "0";
        ItemCertRequiredInd.Value = "";
        hidSellOutItemInd.Value = "N";
        hidSubItemInd.Value = "N";

        tdPromoTitle.BgColor = "#FFFFFF";
        tdPromoPrice.BgColor = "#FFFFFF";
    }

    protected void ClearCalcData()
    {
        TotAmtLabel.Text = "";
        //TotWeightLabel.Text = "";
        WorkSellPriceTextBox.Text = "";
        MgnCostTextBox.Text = "";
        //MgnStdTextBox.Text = "";
        MgnReplTextBox.Text = "";
        SellLBTextBox.Text = "";
        MarginLBTextBox.Text = "";
        // last invoice data
        LastInvoiceLabel.Attributes.Remove("onmousedown");
        LastInvoiceLabel.CssClass = "";
        DateLastInvoiceLabel.Text = "";
        QtyLastInvoiceLabel.Text = "";
        SellLastInvoiceLabel.Text = "";
        MgnCostLastInvoiceLabel.Text = "";
        //MgnStdLastInvoiceLabel.Text = "";
        MgnReplLastInvoiceLabel.Text = "";
        SellLBLastInvoiceLabel.Text = "";
        MarginLBLastInvoiceLabel.Text = "";
        // last quote data
        LastQuoteLabel.Attributes.Remove("onmousedown");
        LastQuoteLabel.CssClass = "";
        DateLastQuoteLabel.Text = "";
        QtyLastQuoteLabel.Text = "";
        SellLastQuoteLabel.Text = "";
        MgnCostLastQuoteLabel.Text = "";
        //MgnStdLastQuoteLabel.Text = "";
        MgnReplLastQuoteLabel.Text = "";
        SellLBLastQuoteLabel.Text = "";
        MarginLBLastQuoteLabel.Text = "";
        // last e commerce data
        LastECommLabel.Attributes.Remove("onmousedown");
        LastECommLabel.CssClass = "";
        DateLastECommLabel.Text = "";
        QtyLastECommLabel.Text = "";
        SellLastECommLabel.Text = "";
        MgnCostLastECommLabel.Text = "";
        //MgnStdLastECommLabel.Text = "";
        MgnReplLastECommLabel.Text = "";
        SellLBLastECommLabel.Text = "";
        MarginLBLastECommLabel.Text = "";
        // suggest data
        //SellSuggestLabel.Text = "";
        MgnCostSuggestLabel.Text = "";
        //MgnStdSuggestLabel.Text = "";
        MgnReplSuggestLabel.Text = "";
        SellLBSuggestLabel.Text = "";
        MarginLBSuggestLabel.Text = "";
        // open order data
        OpenOrderLabel.Attributes.Remove("onmousedown");
        OpenOrderLabel.CssClass = "";
        DateOpenOrderLabel.Text = "";
        QtyOpenOrderLabel.Text = "";
        SellOpenOrderLabel.Text = "";
        MgnCostOpenOrderLabel.Text = "";
        //MgnStdOpenOrderLabel.Text = "";
        MgnReplOpenOrderLabel.Text = "";
        SellLBOpenOrderLabel.Text = "";
        MarginLBOpenOrderLabel.Text = "";
        // misc data
        WebPriceLabel.Text = "";
        WorkSVCLabel.Text = "";
        CorpVLabel.Text = "";
        TotAmtLabel.Text = "";
        WorkItemWeightLabel.Text = "";
        WorkWght100Label.Text = "";
        //TotWeightLabel.Text = "";
        WorkNetWeightLabel.Text = "";
        //TotNetWeightLabel.Text = "";
        WorkSellPriceTextBox.CssClass = "ws_whitebox";
        MgnCostTextBox.CssClass = "ws_whitebox";
        //MgnStdTextBox.CssClass = "ws_whitebox";
        MgnReplTextBox.CssClass = "ws_whitebox";
        SellLBTextBox.CssClass = "ws_whitebox";
        MarginLBTextBox.CssClass = "ws_whitebox";
        //Thermo.Clear();

        DateRegionLastQuote.Text = "";
        QtyLastRegionQuoteLabel.Text = "";
        SellLastRegionQuoteLabel.Text = "";
        MgnCostLastRegionQuoteLabel.Text = "";
        MgnReplLasRegionQuoteLabel.Text = "";
        SellLBLastRegionQuoteLabel.Text = "";
        MarginLBLastRegionQuoteLabel.Text = "";

        DateRegionLastOrder.Text = "";
        QtyLastRegionOrderLabel.Text = "";
        SellLastRegionOrderLabel.Text = "";
        MgnCostLastRegionOrdLabel.Text = "";
        MgnReplLasRegionOrdLabel.Text = "";
        SellLBLastRegionOrdLabel.Text = "";
        MarginLBLastRegionOrderLabel.Text = "";
        RegionLastOrderLabel.Attributes.Remove("onmousedown");
        RegionLastOrderLabel.CssClass = "";
        RegionLastQuoteLabel.Attributes.Remove("onmousedown");
        RegionLastQuoteLabel.CssClass = "";

        Comp1Name.Text = Comp1Price.Text = "";
        Comp2Name.Text = Comp2Price.Text = "";
        Comp3Name.Text = Comp3Price.Text = "";
        Comp4Name.Text = Comp4Price.Text = "";
        Comp5Name.Text = Comp5Price.Text = "";
        Comp6Name.Text = Comp6Price.Text = "";
        Comp7Name.Text = Comp7Price.Text = "";
        Comp8Name.Text = Comp8Price.Text = "";       

        ItemAmtLabel.Text = "";
        ItemMgnPctLabel.Text = "";
        ItemMgnDolLabel.Text = "";
        txtPctDiff.Text = "";
        lblPromo.Text = "";
        lblAdderPct.Text = "";
        lblTargetDisc.Text = lblTargetPrice.Text = "";
        tdPrice.BgColor = tdMgnPctAtAvg.BgColor = tdMgnPctAtRepl.BgColor = "";
        WorkSellPriceTextBox.BackColor = Color.White;

        WorkSheetUpdatePanel.Update();
    }
    #endregion

    #region Work Screen Data
    protected string FormatScreenData(string FormatString, object FieldVal)
    {
        string FieldResult = "**";
        try
        {
            FieldResult = String.Format(FormatString, FieldVal);
        }
        catch (Exception ex)
        {
        }
        return FieldResult;
    }

    protected string SplitOffNum(string ScreenData)
    {
        return ScreenData.Split(new Char[] { '/' })[0].Replace(",", "");
    }
    #endregion

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

    #region Customer Validation
    /// <summary>
    /// Function to load the customer details
    /// </summary>
    public void WorkCustomerNumber(object sender, EventArgs e)
    {
        /*
        This is the code added to CustomerList.aspx to bring the customer back
            case 'SOPrice':  // refresh Price Worksheet page           
            window.opener.document.getElementById("CustNoTextBox").value=customerno;
            window.opener.document.getElementById("CustNoSubmit").click();          
            break;
        */
        ClearPageMessages();
        string strCustNo = CustNoTextBox.Text;
        int strCnt = 0;
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
                DataSet dsCustomer = orderEntry.GetCustomerDetails(CustNoTextBox.Text.Trim().Replace("'", ""));

                // Function to clear the value in the label
                //ClearLabels();

                if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count != 0)
                {
                    if (!dsCustomer.Tables[0].Columns.Contains("ErrorMessage"))
                    {
                        string creditStatus = "";
                        if (dsCustomer.Tables[0].Rows[0]["CustCd"].ToString() != "BT" && dsCustomer.Tables[0].Rows[0]["fBillToNo"].ToString() != "")
                        {
                            if (dsCustomer.Tables[2].Rows.Count != 0)
                            {
                                creditStatus = orderEntry.GetCreditReview(dsCustomer.Tables[0].Rows[0]["fBillToNo"].ToString().ToString(), dsCustomer.Tables[2].Rows[0]["CreditInd"].ToString().Trim(), "0", "Order");
                                if (creditStatus.ToUpper() == "OK")
                                {
                                    CustNameLabel.Text = dsCustomer.Tables[0].Rows[0]["Name"].ToString();
                                    lblName.ToolTip = dsCustomer.Tables[1].Rows[0]["City"].ToString() + ", " + dsCustomer.Tables[1].Rows[0]["State"].ToString(); 
                                    this.Title = CustNameLabel.Text;
                                    ShippingBranch.Value = dsCustomer.Tables[0].Rows[0]["Shipping Location"].ToString();
                                    ShipFromLabel.Text = ShippingBranch.Value;
                                    LocationDropDownList.SelectedValue = dsCustomer.Tables[0].Rows[0]["Shipping Location"].ToString().Trim();
                                    SetImageDisplay();
                                    //LocName.Value = dt.Rows[0]["LocName"].ToString();
                                    if (dsCustomer.Tables[0].Rows[0]["CertRequiredInd"].ToString().Trim() == "1")
                                    {
                                        CustCertRequiredInd.Value = "TRUE";
                                    }
                                    else
                                    {
                                        CustCertRequiredInd.Value = "FALSE";
                                    }
                                    HeadingPriceCodeLabel.Text = dsCustomer.Tables[0].Rows[0]["Customer Price Code"].ToString();
                                    SetWebCust(dsCustomer.Tables[0].Rows[0]["Customer Price Code"].ToString());
                                    CustExtraUpdatePanel.Update();
                                    if (TermsDescLabel.Visible)
                                    {
                                        dt = custDet.GetTermDescription(dsCustomer.Tables[0].Rows[0]["TradeTermCd"].ToString(), "TRM");
                                        if ((dt != null) && (dt.Rows.Count > 0) && (dt.Rows[0]["Dsc"] != null))
                                        {
                                            if (dt.Rows[0]["Dsc"].ToString().Length > 18)
                                            {
                                                TermsDescLabel.Text = dt.Rows[0]["Dsc"].ToString().Substring(0, 18);
                                            }
                                            else
                                            {
                                                TermsDescLabel.Text = dt.Rows[0]["Dsc"].ToString();
                                            }
                                        }
                                    }
                                    try
                                    {
                                        CarrierDropDownList.SelectedValue = dsCustomer.Tables[0].Rows[0]["Shipping Agent Code"].ToString();
                                    }
                                    catch (Exception ex) {}
                                    try
                                    {
                                        FreightDropDownList.SelectedValue = dsCustomer.Tables[0].Rows[0]["Freight Code"].ToString();
                                    }
                                    catch (Exception ex) { }
                                    // reset quote tracking data
                                    QuoteNumber.Value = "";
                                    QuoteNumberLabel.Text = "";
                                    QuoteContactTextBox.Text = "";
                                    QuoteLineNo.Value = "10";
                                    NewQuoteLineNumber = int.Parse(QuoteLineNo.Value);
                                    CustWeightLabel.Text = "0";
                                    QuoteAmountLabel.Text = "0";
                                    QuoteLinesLabel.Text = "0";
                                    CustValid.Value = "1";

                                    // Sathish: Recompute Order sumnmary
                                    CalculateOrderTotal();

                                    ItemUpdatePanel.Update();
                                    //ShowPageMessage("ShipLoc=" + ShippingBranch.Value.ToString(), 0);
                                    SOEPriceWorksheetScriptManager.SetFocus("CustomerItemTextBox");                                    
                                }
                                else
                                {
                                    ScriptManager.RegisterClientScriptBlock(CustNoTextBox, typeof(TextBox), "invalid", "alert('" + creditStatus + "');", true);
                                    return;
                                }
                            }
                            else
                            {
                                ScriptManager.RegisterClientScriptBlock(CustNoTextBox, typeof(TextBox), "invalid", "alert('Bill To Customer not found');document.getElementById('" + CustNoTextBox.ClientID + "').value='';document.getElementById('" + CustNoTextBox.ClientID + "').focus();document.getElementById('" + CustNoTextBox.ClientID + "').select();", true);
                            }
                        }
                        else
                        {
                            //ISBillToCustomer = true;
                            ScriptManager.RegisterClientScriptBlock(CustNoTextBox, typeof(TextBox), "invalid", "alert('Bill To Only Customer could not process order');document.getElementById('" + CustNoTextBox.ClientID + "').value='';document.getElementById('" + CustNoTextBox.ClientID + "').focus();document.getElementById('" + CustNoTextBox.ClientID + "').select();", true);
                        }
                    }
                    else
                    {
                        ScriptManager.RegisterClientScriptBlock(CustNoTextBox, typeof(TextBox), "invalid", "alert('" + dsCustomer.Tables[0].Rows[0]["ErrorMessage"].ToString() + "');document.getElementById('" + CustNoTextBox.ClientID + "').value='';document.getElementById('" + CustNoTextBox.ClientID + "').focus();document.getElementById('" + CustNoTextBox.ClientID + "').select();", true);
                    }
                }
                else
                {
                    //hidCust.Value = "";
                    ScriptManager.RegisterClientScriptBlock(CustNoTextBox, typeof(TextBox), "invalid", "alert('Invalid Customer value');document.getElementById('" + CustNoTextBox.ClientID + "').value='';document.getElementById('" + CustNoTextBox.ClientID + "').focus();document.getElementById('" + CustNoTextBox.ClientID + "').select();", true);
                }
                #endregion
            }
            else
            {
                //ClearLabels();
            }
        }
    }

    private void SetWebCust(string PriceCode)
    {
        if (PriceCode.ToUpper().Trim() == "W")
        {
            HeadingPriceCodeLabel.Style["font-weight"] = "bold";
            HeadingPriceCodeLabel.Style["background-color"] = "Red";
            HeadingPriceCodeLabel.Style["color"] = "white";
            CustExtraLabel.Text = "WEB CUSTOMER";
        }
        else
        {
            HeadingPriceCodeLabel.Style["font-weight"] = "normal";
            HeadingPriceCodeLabel.Style["background-color"] = "white";
            HeadingPriceCodeLabel.Style["color"] = "black";
            CustExtraLabel.Text = "";
        }
    }

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
    
    #region Get AppPref
    /// <summary>
    /// Get SOE AppPref Record
    /// </summary>
    public string GetAppPref(string OptType)
    {
        //try
        //{
        DataSet dsAppPref = new DataSet();
        dsAppPref = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                new SqlParameter("@tableName", "AppPref"),
                new SqlParameter("@displayColumns", "AppOptionValue"),
                new SqlParameter("@whereCondition", " (ApplicationCd = 'SOE') AND (AppOptionType = '" + OptType + "')"));
        //}
        //catch (Exception ex)
        //{
        //}
        return dsAppPref.Tables[0].Rows[0]["AppOptionValue"].ToString(); ;
    }

    public string GetAppPref(string OptCode, string OptType)
    {
        //try
        //{
        DataSet dsAppPref = new DataSet();
        dsAppPref = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                new SqlParameter("@tableName", "AppPref"),
                new SqlParameter("@displayColumns", "AppOptionValue"),
                new SqlParameter("@whereCondition", " (ApplicationCd = '" + OptCode + "') AND (AppOptionType = '" + OptType + "')"));
        //}
        //catch (Exception ex)
        //{
        //}
        return dsAppPref.Tables[0].Rows[0]["AppOptionValue"].ToString(); ;
    }
    #endregion

    #region Show hide item builder

    /// <summary>
    /// Event to show the item builder
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ibtnHide_Click(object sender, ImageClickEventArgs e)
    {
        imgShowItemBuilder.Visible = true;
        ibtnHide.Visible = false;
        UCItemLookup.Visible = false;
        ControlPanel.Update();
    }

    /// <summary>
    /// Event to hide the item builder
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void imgShowItemBuilder_Click(object sender, ImageClickEventArgs e)
    {
        imgShowItemBuilder.Visible = false;
        ibtnHide.Visible = true;
    }


    /// <summary>
    /// UpdateItemLookup Used to update item lookupp
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void UpdateItemLookup(object sender, EventArgs e)
    {

        UCItemLookup.Visible = false;
        UCItemLookup.UpdateValue();

        if (Page.IsPostBack)
        {
            UCItemLookup.Visible = true;
            ControlPanel.Update();
        }
        if (UCItemLookup.Visible)
        {
            //divdatagrid.Style.Add("height", "320px");
            ControlPanel.Update();
            pnlQuoteDetail.Update();
        }
    }

    /// <summary>
    /// ItemControl_OnPackageChange Event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ItemControl_OnPackageChange(object sender, EventArgs e)
    {

    }

    /// <summary>
    /// Event Handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ItemControl_OnChange(object sender, EventArgs e)
    {
        FamilyPanel.Update();
    }

    #endregion

    #region Freight & Total Order Column Methods

    protected void lnkCalcFreight_Click(object sender, EventArgs e)
    {
        ShowPageMessage("", 0);

        if (TotOrdGrossWghtLabel.Text == "0.00" || TotOrdGrossWghtLabel.Text.Trim() == "")
        {
            ShowPageMessage("Invalid Gross Weight.", 2);
            return;
        }
        else if(Convert.ToDecimal(TotOrdGrossWghtLabel.Text) > 150 && CarrierDropDownList.SelectedValue != "01")
        {
            ShowPageMessage("Gross weight is greater than 150lbs. Please select different carrier.", 2);
            return;
        }

        if (CustNoTextBox.Text != "")
        {
            #region Variable Declaration

            string _shipperAddressline1;
            string _shipperCity;
            string _shipperState;
            string _shipperPostalCode;
            string _shipperCountry;
            string _shipToAddressline1;
            string _shipToAddressline2;
            string _shipToCity;
            string _shipToState;
            string _shipToPostalCode;
            string _shipToCountry;             
            string carrierType = "";
            string PFCCarrierCd = "";
            string packageWeight;

            FreightCalculator freightCalc = new FreightCalculator();

            #endregion

            #region Fill ship from address

            string shipLoc = (LocationDropDownList.Visible == true ? LocationDropDownList.SelectedValue : ShipFromLabel.Text);
            string locMasterCmd =   " Select * " +
                                    " From LocMaster (NOLOCK) " +
                                    " Where LocId='" + shipLoc + "'";
            DataSet ShipFrom = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, CommandType.Text, locMasterCmd);

            _shipperAddressline1 = ShipFrom.Tables[0].Rows[0]["LocAdress1"].ToString();
            _shipperCity = ShipFrom.Tables[0].Rows[0]["LocCity"].ToString();
            _shipperState = ShipFrom.Tables[0].Rows[0]["LocState"].ToString();
            _shipperPostalCode = ShipFrom.Tables[0].Rows[0]["LocPostCode"].ToString();
            _shipperCountry = ShipFrom.Tables[0].Rows[0]["LocCountry"].ToString();  

            #endregion

            #region Fill ship to address

            if (Request.QueryString["QuickQuote"] != null) // Fill default ship to address in quick quote mode
            {
                DataSet dsCustomer = orderEntry.GetCustomerDetails(CustNoTextBox.Text.Trim().Replace("'", ""));
                if (dsCustomer.Tables[3] != null && dsCustomer.Tables[3].Rows.Count > 0)
                {
                    _shipToAddressline1 = dsCustomer.Tables[3].Rows[0]["Address"].ToString().Trim();
                    _shipToAddressline2 = dsCustomer.Tables[3].Rows[0]["Address 2"].ToString().Trim();
                    _shipToCity = dsCustomer.Tables[3].Rows[0]["City"].ToString().Trim();
                    _shipToState = dsCustomer.Tables[3].Rows[0]["State"].ToString().Trim();
                    _shipToPostalCode = dsCustomer.Tables[3].Rows[0]["Post Code"].ToString().Trim();
                    _shipToCountry = dsCustomer.Tables[3].Rows[0]["Country"].ToString().Trim();
                }
                else
                {
                    ShowPageMessage("Ship to address not found.", 2);
                    return;
                }
                
                PFCCarrierCd = CarrierDropDownList.SelectedValue;

            }
            else
            {
                _shipToAddressline1 = ShipToAddr1.Value;
                _shipToAddressline2 = ShipToAddr2.Value;
                _shipToCity = ShipToCity.Value;
                _shipToState = ShipToState.Value;
                _shipToPostalCode = ShipToZip.Value;
                _shipToCountry = ShipToCountry.Value;

                PFCCarrierCd = Session["CarrierCode"].ToString();
            }

            #endregion

            #region Convert PFC Carrier Cd to Ship Live Carrier Cd

            switch (PFCCarrierCd)
            {
                case "01":
                    carrierType = "LTL";
                    break;
                case "02": 
                    carrierType = "UPSG";
                    break;
                case "03":
                    carrierType = "UPSN";
                    break;
                case "04":
                    carrierType = "UPS2";
                    break;
                case "05":
                    carrierType = "UPS2A";
                    break;
                case "06":
                    carrierType = "UPS3";
                    break;
                case "07":
                    carrierType =  "UPSNXS";
                    break; 
                default:
                    ShowPageMessage("Invalid carrier code. Freight can not be calculated.", 2);
                    return;
            }
            
            #endregion

            double freightAmt = freightCalc.GetFreightRate( "", "", _shipperAddressline1, _shipperCity, _shipperState, _shipperPostalCode, _shipperCountry, "",
                                                            "", "", _shipToAddressline1, _shipToCity, _shipToState, _shipToPostalCode, _shipToCountry, "", carrierType, TotOrdGrossWghtLabel.Text);
            if (freightAmt != 0)
            {
                freightAmt /= 100;
                lnkCalcFreight.Text = "FREIGHT: $" + Math.Round(freightAmt,2).ToString();
            }
            else
            {
                lnkCalcFreight.Text = "FREIGHT: $0.00";
                ShowPageMessage("Not able to calculate freight. Please try again.", 2);
            }
        }
        else
        {
            ShowPageMessage("Invalid customer number.", 2);
        }
    }

    private void CalculateOrderTotal()
    {
        if ((QuoteNumberLabel.Text == "" && Request.QueryString["QuickQuote"] != null))
        {
            TotOrdAmtLabel.Text = "0.00";
            TotOrdGrossWghtLabel.Text = "0.00";
            TotOrdNetWghtLabel.Text = "0.00";
            TotOrdMgnPctLabel.Text = "0.00";
            TotOrdMgnDolLabel.Text = "0.00";
            lnkCalcFreight.Text = "FREIGHT: $0.00";
        }
        else
        {
            string _orderTableName = "";
            string _operateMode = "";
            string _quoteNumber = "";

            if (Request.QueryString["QuickQuote"] != null) // in quick quote mode
            {
                _operateMode = "quote";
                _quoteNumber = QuoteNumberLabel.Text;

            }
            else
            {
                _operateMode = "order";
                _orderTableName = Session["OrderTableName"].ToString();
                _quoteNumber = Session["OrderHeaderID"].ToString();
            }

            DataSet dsOrderTotal = SqlHelper.ExecuteDataset(connectionString, "[pSOEGetOrderSummary]",
                                            new SqlParameter("@quoteNumber", _quoteNumber),
                                            new SqlParameter("@orderTable", _orderTableName),
                                            new SqlParameter("@operateMode", _operateMode));
            if (dsOrderTotal != null && dsOrderTotal.Tables[0].Rows.Count > 0)
            {
                TotOrdAmtLabel.Text = dsOrderTotal.Tables[0].Rows[0]["TotOrder"].ToString();
                TotOrdGrossWghtLabel.Text = dsOrderTotal.Tables[0].Rows[0]["GrossWght"].ToString();
                TotOrdNetWghtLabel.Text = dsOrderTotal.Tables[0].Rows[0]["NetWght"].ToString();
                TotOrdMgnPctLabel.Text = dsOrderTotal.Tables[0].Rows[0]["MarginPct"].ToString();
                TotOrdMgnDolLabel.Text = dsOrderTotal.Tables[0].Rows[0]["MarginDollars"].ToString();
            }
        }

        WorkSheetUpdatePanel.Update();
    }

    protected void CarrierDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        lnkCalcFreight.Text = "FREIGHT: $0.00";
        WorkSheetUpdatePanel.Update();
    }

    #endregion

    #region Queue Button Logic

    private void HighLightQueueButton()
    {
        string selectQuery =    "Select isnull(QuoteQInd,'N') as QuoteQInd " +
                                "From RepMaster (NOLOCK) " +
                                "Where RepNotes like '" + Session["UserName"].ToString() + "'";

        object queueInd = SqlHelper.ExecuteScalar(  Global.PFCERPConnectionString, 
                                                    CommandType.Text,
                                                    selectQuery);
        if (queueInd!= null && queueInd.ToString().Trim() == "Y")
        {
            ibtnWebQueue.ImageUrl = "~/Common/Images/Q_ON.gif";
        }
    }

    protected void ibtnWebQueue_Click(object sender, ImageClickEventArgs e)
    {
        ibtnWebQueue.ImageUrl = "~/Common/Images/Q_OFF.gif";        
    }

    private void HighLightFields(DataTable dtPricing)
    {

        // Display ECommerce application promo's
        if (dtPricing.Rows[0]["PromoCode"].ToString().Trim() != "")
        {
            tdPromoTitle.BgColor = "#FFFF3C";
            tdPromoPrice.BgColor = "#FFFF3C";
        }

        // Display Customer Cust Indicator
        if (dtPricing.Rows[0]["CustCostMethod"].ToString().Trim() == "P")
            tdPrice.BgColor = "#FF6600";
        else if (dtPricing.Rows[0]["CustCostMethod"].ToString().Trim() == "S")
            tdMgnPctAtAvg.BgColor = "#FF6600";
        else if (dtPricing.Rows[0]["CustCostMethod"].ToString().Trim() == "R")
            tdMgnPctAtRepl.BgColor = "#FF6600";


        // Display SOE Promo's
        if (dtPricing.Rows[0]["SOEPromoCode"].ToString().Trim() != "")
        {
            tdPromoTitle.BgColor = "#FFFF3C";
            WorkSellPriceTextBox.BackColor = Color.FromName("#FFFF3C");
            WorkSellPriceTextBox.ToolTip = "Promo Disc: " + Math.Round(Convert.ToDecimal(dtPricing.Rows[0]["SOEPromoDiscPct"].ToString()) * 100, 1).ToString() + "% - End Date: " + Convert.ToDateTime(dtPricing.Rows[0]["SOEPromoExpireDate"].ToString()).ToShortDateString() + "\n" +
                                            "Promo Desc: " + dtPricing.Rows[0]["SOEPromoCode"].ToString() + " - " + dtPricing.Rows[0]["SOEPromoFullDesc"].ToString() + "\n" +
                                            "Org. Sell Price: $" + FormatScreenData(Num2Format, dt.Rows[0]["AltSellPrice"]);

        }
        else
        {
            WorkSellPriceTextBox.ToolTip = "";
        }


    }

    #endregion
    
    #region Competitor Pricing Logic

    /// <summary>
    /// This button is called from competitor price maint screen (save button)
    /// </summary>    
    protected void btnRefreshCompPrice_Click(object sender, EventArgs e)
    {

        DataSet dsCompetitor = new DataSet();
        dsCompetitor = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOECompetitorPriceFrm]",
                                            new SqlParameter("@source", "getcomppricing"),
                                            new SqlParameter("@custNo", CustNoTextBox.Text),
                                            new SqlParameter("@regionCd", ""),
                                            new SqlParameter("@compCd", ""),
                                            new SqlParameter("@pfcItemNo", InternalItemLabel.Text),
                                            new SqlParameter("@pCompItemId", ""));
        if(dsCompetitor != null)
            DisplayCompPrice(dsCompetitor.Tables[0]);

    }

    private void DisplayCompPrice(DataTable dtCompetitor)
    {
        // We found last region Order data        
        string _pageURL = "MaintenanceApps/CompetitorPriceMaint.aspx";
        string _queryString = "";

        if (dtCompetitor.Rows.Count > 0)
        {
            Comp1Name.Text = dtCompetitor.Rows[0]["CompetitorListCd"].ToString();
            _queryString = "?PageMode=ItemHistory&CompListCd=" + Comp1Name.Text + "&ItemNo=" + InternalItemLabel.Text;
            Comp1Name.Attributes.Add("onclick", "javascript:OpenCompPriceMaint('itemhistory','" + _pageURL + _queryString + "'); return false;");

            Comp1Price.Text = (dtCompetitor.Rows[0]["CompetitorPrice"].ToString() != "0.00" ? "$" + dtCompetitor.Rows[0]["CompetitorPrice"].ToString() : dtCompetitor.Rows[0]["CompetitorStockInd"].ToString());
            _queryString = "?PageMode=PirceMode&CompListCd=" + Comp1Name.Text + "&CompItemId=" + dtCompetitor.Rows[0]["pCompetitorItemsID"].ToString();
            Comp1Price.Attributes.Add("onclick", "javascript:OpenCompPriceMaint('price','" + _pageURL + _queryString + "'); return false;");
        }

        if (dtCompetitor.Rows.Count > 1)
        {
            Comp2Name.Text = dtCompetitor.Rows[1]["CompetitorListCd"].ToString();
            _queryString = "?PageMode=ItemHistory&CompListCd=" + Comp2Name.Text + "&ItemNo=" + InternalItemLabel.Text;
            Comp2Name.Attributes.Add("onclick", "javascript:OpenCompPriceMaint('itemhistory','" + _pageURL + _queryString + "'); return false;");


            Comp2Price.Text = (dtCompetitor.Rows[1]["CompetitorPrice"].ToString() != "0.00" ? "$" + dtCompetitor.Rows[1]["CompetitorPrice"].ToString() : dtCompetitor.Rows[1]["CompetitorStockInd"].ToString());
            _queryString = "?PageMode=PirceMode&CompListCd=" + Comp2Name.Text + "&CompItemId=" + dtCompetitor.Rows[1]["pCompetitorItemsID"].ToString();
            Comp2Price.Attributes.Add("onclick", "javascript:OpenCompPriceMaint('price','" + _pageURL + _queryString + "'); return false;");
        }

        if (dtCompetitor.Rows.Count > 2)
        {
            Comp3Name.Text = dtCompetitor.Rows[2]["CompetitorListCd"].ToString();
            _queryString = "?PageMode=ItemHistory&CompListCd=" + Comp3Name.Text + "&ItemNo=" + InternalItemLabel.Text;
            Comp3Name.Attributes.Add("onclick", "javascript:OpenCompPriceMaint('itemhistory','" + _pageURL + _queryString + "'); return false;");

            Comp3Price.Text = (dtCompetitor.Rows[2]["CompetitorPrice"].ToString() != "0.00" ? "$" + dtCompetitor.Rows[2]["CompetitorPrice"].ToString() : dtCompetitor.Rows[2]["CompetitorStockInd"].ToString());
            _queryString = "?PageMode=PirceMode&CompListCd=" + Comp3Name.Text + "&CompItemId=" + dtCompetitor.Rows[2]["pCompetitorItemsID"].ToString();
            Comp3Price.Attributes.Add("onclick", "javascript:OpenCompPriceMaint('price','" + _pageURL + _queryString + "'); return false;");
        }

        if (dtCompetitor.Rows.Count > 3)
        {
            Comp4Name.Text = dtCompetitor.Rows[3]["CompetitorListCd"].ToString();
            _queryString = "?PageMode=ItemHistory&CompListCd=" + Comp4Name.Text + "&ItemNo=" + InternalItemLabel.Text;
            Comp4Name.Attributes.Add("onclick", "javascript:OpenCompPriceMaint('itemhistory','" + _pageURL + _queryString + "'); return false;");

            Comp4Price.Text = (dtCompetitor.Rows[3]["CompetitorPrice"].ToString() != "0.00" ? "$" + dtCompetitor.Rows[3]["CompetitorPrice"].ToString() : dtCompetitor.Rows[3]["CompetitorStockInd"].ToString());
            _queryString = "?PageMode=PirceMode&CompListCd=" + Comp4Name.Text + "&CompItemId=" + dtCompetitor.Rows[3]["pCompetitorItemsID"].ToString();
            Comp4Price.Attributes.Add("onclick", "javascript:OpenCompPriceMaint('price','" + _pageURL + _queryString + "'); return false;");
        }

        if (dtCompetitor.Rows.Count > 4)
        {
            Comp5Name.Text = dtCompetitor.Rows[4]["CompetitorListCd"].ToString();
            _queryString = "?PageMode=ItemHistory&CompListCd=" + Comp5Name.Text + "&ItemNo=" + InternalItemLabel.Text;
            Comp5Name.Attributes.Add("onclick", "javascript:OpenCompPriceMaint('itemhistory','" + _pageURL + _queryString + "'); return false;");

            Comp5Price.Text = (dtCompetitor.Rows[4]["CompetitorPrice"].ToString() != "0.00" ? "$" + dtCompetitor.Rows[4]["CompetitorPrice"].ToString() : dtCompetitor.Rows[4]["CompetitorStockInd"].ToString());
            _queryString = "?PageMode=PirceMode&CompListCd=" + Comp5Name.Text + "&CompItemId=" + dtCompetitor.Rows[4]["pCompetitorItemsID"].ToString();
            Comp5Price.Attributes.Add("onclick", "javascript:OpenCompPriceMaint('price','" + _pageURL + _queryString + "'); return false;");
        }

        if (dtCompetitor.Rows.Count > 5)
        {
            Comp6Name.Text = dtCompetitor.Rows[5]["CompetitorListCd"].ToString();
            _queryString = "?PageMode=ItemHistory&CompListCd=" + Comp6Name.Text + "&ItemNo=" + InternalItemLabel.Text;
            Comp6Name.Attributes.Add("onclick", "javascript:OpenCompPriceMaint('itemhistory','" + _pageURL + _queryString + "'); return false;");

            Comp6Price.Text = (dtCompetitor.Rows[5]["CompetitorPrice"].ToString() != "0.00" ? "$" + dtCompetitor.Rows[5]["CompetitorPrice"].ToString() : dtCompetitor.Rows[5]["CompetitorStockInd"].ToString());
            _queryString = "?PageMode=PirceMode&CompListCd=" + Comp6Name.Text + "&CompItemId=" + dtCompetitor.Rows[5]["pCompetitorItemsID"].ToString();
            Comp6Price.Attributes.Add("onclick", "javascript:OpenCompPriceMaint('price','" + _pageURL + _queryString + "'); return false;");
        }

        if (dtCompetitor.Rows.Count > 6)
        {
            Comp7Name.Text = dtCompetitor.Rows[6]["CompetitorListCd"].ToString();
            _queryString = "?PageMode=ItemHistory&CompListCd=" + Comp7Name.Text + "&ItemNo=" + InternalItemLabel.Text;
            Comp7Name.Attributes.Add("onclick", "javascript:OpenCompPriceMaint('itemhistory','" + _pageURL + _queryString + "'); return false;");

            Comp7Price.Text = (dtCompetitor.Rows[6]["CompetitorPrice"].ToString() != "0.00" ? "$" + dtCompetitor.Rows[6]["CompetitorPrice"].ToString() : dtCompetitor.Rows[6]["CompetitorStockInd"].ToString());
            _queryString = "?PageMode=PirceMode&CompListCd=" + Comp7Name.Text + "&CompItemId=" + dtCompetitor.Rows[6]["pCompetitorItemsID"].ToString();
            Comp7Price.Attributes.Add("onclick", "javascript:OpenCompPriceMaint('price','" + _pageURL + _queryString + "'); return false;");
        }

        if (dtCompetitor.Rows.Count > 7)
        {
            Comp8Name.Text = dtCompetitor.Rows[7]["CompetitorListCd"].ToString();
            _queryString = "?PageMode=ItemHistory&CompListCd=" + Comp8Name.Text + "&ItemNo=" + InternalItemLabel.Text;
            Comp8Name.Attributes.Add("onclick", "javascript:OpenCompPriceMaint('itemhistory','" + _pageURL + _queryString + "'); return false;");

            Comp8Price.Text = (dtCompetitor.Rows[7]["CompetitorPrice"].ToString() != "0.00" ? "$" + dtCompetitor.Rows[7]["CompetitorPrice"].ToString() : dtCompetitor.Rows[7]["CompetitorStockInd"].ToString());
            _queryString = "?PageMode=PirceMode&CompListCd=" + Comp8Name.Text + "&CompItemId=" + dtCompetitor.Rows[7]["pCompetitorItemsID"].ToString();
            Comp8Price.Attributes.Add("onclick", "javascript:OpenCompPriceMaint('price','" + _pageURL + _queryString + "'); return false;");
        }
    }
        
    #endregion
   
}