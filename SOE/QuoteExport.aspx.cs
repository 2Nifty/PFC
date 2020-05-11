using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Globalization;
using System.Net.Mail;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.DataAccessLayer;

public partial class QuoteExport : Page
{
    OrderEntry orderEntry = new OrderEntry();
    CustomerDetail custDet = new CustomerDetail();
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataSet dsCust = new DataSet();
    DataTable dtCust = new DataTable();
    DataTable dtBillTo = new DataTable();
    DataSet dsSys = new DataSet();
    DataTable dtSys = new DataTable();
    DataRow quoterow;
    private string searchFieldCaption = "Order #,Quote Date,Total Weight,Total Amount,PFC Item,Cust. Item";
    private string searchColumnName = "QuoteNumber,QuotationDate,TotalWeight,TotalAmount,PFCItemNo,UserItemNo";
    private string Num0Format = "{0:####,###,##0} ";
    private string Num1Format = "{0:####,###,##0.0} ";
    private string Num2Format = "{0:####,###,##0.00} ";
    private string Num3Format = "{0:####,###,##0.000} ";
    private string DollarFormat = "${0:#,##0.00} ";
    private string Dollar3Format = "${0:#,##0.000} ";
    private string PcntFormat = "{0:#,##0.0}% ";
    private string DateFormat = "{0:MM/dd/yy} ";
    private string LongDateFormat = "{0:dddd, MMM dd, yyyy} ";
    string DateToGet;
    string QuoteMaker;
    object sumObject;
    object QuoteTotObject;
    int result;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session["ReviewQuotation"] = null;
            Session["dtPrint"] = null;
            if (Request.QueryString["CustomerNumber"] != null)
            {
                //get cust data
                dsCust = SqlHelper.ExecuteDataset(connectionString, "pSOEGetQuoteCust",
                    new SqlParameter("@customer", Request.QueryString["CustomerNumber"].ToString()));
                dtCust = dsCust.Tables[0];
                dtBillTo = dsCust.Tables[1];
                // look at SysMaster for watermark indicator
                dsSys = SqlHelper.ExecuteDataset(connectionString, "pUTGetSysMaster");
                dtSys = dsSys.Tables[0];
                if (dtSys.Rows[0]["PrintRqst"].ToString().Trim() == "T")
                {
                    TestWatermark.Attributes["class"] = "watermark";
                    TestWatermark.Attributes.Add("style",
                        "background-image:url(" + ConfigurationManager.AppSettings["SOESiteURL"].ToString() + "Common/Images/TestWatermark.gif);");
                }
                //http://10.1.36.34/SOE/QuoteExport.aspx?CustomerNumber=004401
                //http://10.1.36.34/SOE/QuoteExport.aspx?CustNo=004401&QuoteNo=091101 
                CustIDLabel.Text = Request.QueryString["CustomerNumber"].ToString();
                QuoteNumberLabel.Text = Request.QueryString["QuoteNo"].ToString();
                GetQuotes(Server.HtmlDecode(CustIDLabel.Text), "QuoteNumber", Server.HtmlDecode(Request.QueryString["QuoteNo"]));
                // big quote processing
                if (decimal.Parse(QuoteTotObject.ToString(), NumberStyles.Number) >= decimal.Parse(dtCust.Rows[0]["BigQuoteMinimum"].ToString(), NumberStyles.Number))
                {
                    // get the quote data.
                    result = SqlHelper.ExecuteNonQuery(connectionString, "pSOECreateBigQuoteEMail",
                        new SqlParameter("@QuoteNo", Request.QueryString["QuoteNo"].ToString()),
                        new SqlParameter("@OverrideEmail", ""));
                    //CustIDLabel.Text = result.ToString();
                    //string Subject = "Big Quote (" + FormatScreenData(DollarFormat, QuoteTotObject).Trim()
                    //    + ") by " + QuoteMaker
                    //    + " for " + dtCust.Rows[0]["CustName"].ToString();
                    //string Body = "Quote " + Request.QueryString["QuoteNo"]
                    //    + " was entered on " + FormatScreenData(LongDateFormat, dt.Rows[0]["QuotationDate"]).Trim() +
                    //    " by " + QuoteMaker
                    //    + " and will expire on " + FormatScreenData(LongDateFormat, dt.Rows[0]["ExpiryDate"]).Trim() + ".\n";
                    //Body += "The total amount is " + FormatScreenData(DollarFormat, QuoteTotObject).Trim() + ".\n";
                    //Body += "Sell To Customer Number: " + dtCust.Rows[0]["CustNo"].ToString() + ".\n";
                    //Body += "Bill To Customer Number: " + dtCust.Rows[0]["CustNo"].ToString()
                    //    + " - " + dtCust.Rows[0]["CustName"].ToString() + ".\n";
                    //MailMessage message = new MailMessage(
                    //    "QuoteDaemon@PorteousFastener.com",
                    //    dtCust.Rows[0]["BigQuoteEMailAddress"].ToString().Replace(";", ","),
                    //    //"tslater@porteousfastener.com",
                    //    Subject,
                    //    Body);
                    //if (InsideEMailLabel.Text.Trim().Length != 0)
                    //{
                    //    // Add a carbon copy recipient.
                    //    MailAddress copy = new MailAddress(InsideEMailLabel.Text.Trim());
                    //    message.CC.Add(copy);
                    //}
                    ////Send the message.
                    //SmtpClient client = new SmtpClient("PFCEXCH");
                    //client.Send(message);
                }
                
            }
        }
    }

    protected void GetQuotes(string CustNo, string FilterField, string FilterValue)
    {
        try
        {
            // get the quote data.
            ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetQuotes",
                new SqlParameter("@Organization", CustNo),
                new SqlParameter("@QuoteFilterField", FilterField),
                new SqlParameter("@QuoteFilterValue", FilterValue),
                new SqlParameter("@FreshQOH", "5"));
            if (ds.Tables.Count >= 1)
            {
                dt = ds.Tables[1];
                if (dt.Rows.Count == 0)
                {
                    //DetailGridView.DataBind();
                }
                else
                {
                    //
                    // fill the header
                    QuoteDateLabel.Text = FormatScreenData(LongDateFormat, dt.Rows[0]["QuotationDate"]);
                    PageNumberLabel.Text = "1";
                    LocNameLabel.Text = dtCust.Rows[0]["LocName"].ToString();
                    if (dtCust.Rows[0]["LocAdress1"].ToString().Trim().Length > 0)
                    {
                        LocAddr1.Text = dtCust.Rows[0]["LocAdress1"].ToString();
                    }
                    else
                    {
                        LocAddr1.Visible = false;
                    }
                    if (dtCust.Rows[0]["LocAdress2"].ToString().Trim().Length > 0)
                    {
                        LocAddr2.Text = dtCust.Rows[0]["LocAdress2"].ToString();
                    }
                    else
                    {
                        LocAddr2.Visible = false;
                    }
                    LocCityStZip.Text = dtCust.Rows[0]["LocCityStZip"].ToString();
                    InsideNameLabel.Text = dt.Rows[0]["InsideSalesRepName"].ToString();
                    InsideEMailLabel.Text = dt.Rows[0]["InsideSalesRepEMail"].ToString();
                    InsidePhoneLabel.Text = dt.Rows[0]["InsideSalesRepPhone"].ToString();
                    InsideFAXLabel.Text = dt.Rows[0]["InsideSalesRepFax"].ToString();
                    MgrNameLabel.Text = dtCust.Rows[0]["MgrName"].ToString();
                    MgrEMailLabel.Text = dtCust.Rows[0]["MgrEmail"].ToString();
                    MgrPhoneLabel.Text = dtCust.Rows[0]["MgrPhone"].ToString();
                    MgrFAXLabel.Text = dtCust.Rows[0]["MgrFax"].ToString();
                    
                    // bill to
                    BillLabel1.Text = "Bill To " + dtBillTo.Rows[0]["BillToCustNo"].ToString();
                    BillLabel2.Text = "Attn: " + dtBillTo.Rows[0]["ContactName"].ToString();
                    BillLabel3.Text = dtBillTo.Rows[0]["BillToCustName"].ToString();
                    if (dtBillTo.Rows[0]["BillToAddrLine1"].ToString().Trim().Length > 0)
                    {
                        BillLabel4.Text = dtBillTo.Rows[0]["BillToAddrLine1"].ToString();
                    }
                    else
                    {
                        BillLabel4.Visible = false;
                    }
                    if (dtBillTo.Rows[0]["BillToAddrLine2"].ToString().Trim().Length > 0)
                    {
                        BillLabel5.Text = dtBillTo.Rows[0]["BillToAddrLine2"].ToString();
                    }
                    else
                    {
                        BillLabel5.Visible = false;
                    }
                    BillLabel6.Text = dtBillTo.Rows[0]["BillToCity"].ToString() + ", " +
                        dtBillTo.Rows[0]["BillToState"].ToString() + ". " +
                        dtBillTo.Rows[0]["BillToPostCd"].ToString();
                    BillLabel7.Text = dtBillTo.Rows[0]["BillToCountry"].ToString();

                    #region Bill To Address Old Logic - To be deleted (Sathish)
                    //BillLabel1.Text = "Bill To " + dtCust.Rows[0]["CustNo"].ToString();
                    //BillLabel2.Text = "Attn: " + dt.Rows[0]["ContactName"].ToString();
                    //BillLabel3.Text = dtCust.Rows[0]["CustName"].ToString();
                    //if (dtCust.Rows[0]["AddrLine1"].ToString().Trim().Length > 0)
                    //{
                    //    BillLabel4.Text = dtCust.Rows[0]["AddrLine1"].ToString();
                    //}
                    //else
                    //{
                    //    BillLabel4.Visible = false;
                    //}
                    //if (dtCust.Rows[0]["AddrLine2"].ToString().Trim().Length > 0)
                    //{
                    //    BillLabel5.Text = dtCust.Rows[0]["AddrLine2"].ToString();
                    //}
                    //else
                    //{
                    //    BillLabel5.Visible = false;
                    //}
                    //BillLabel6.Text = dtCust.Rows[0]["City"].ToString() + ", " +
                    //    dtCust.Rows[0]["State"].ToString() + ". " +
                    //    dtCust.Rows[0]["PostCd"].ToString();
                    //BillLabel7.Text = dtCust.Rows[0]["Country"].ToString();
                    #endregion

                    //Sell to
                    SellLabel1.Text = "Sell To " + dtCust.Rows[0]["CustNo"].ToString();
                    SellLabel2.Text = "Attn: " + dt.Rows[0]["ContactName"].ToString();
                    SellLabel3.Text = dtCust.Rows[0]["CustName"].ToString();
                    if (dtCust.Rows[0]["AddrLine1"].ToString().Trim().Length > 0)
                    {
                        SellLabel4.Text = dtCust.Rows[0]["AddrLine1"].ToString();
                    }
                    else
                    {
                        SellLabel4.Visible = false;
                    }
                    if (dtCust.Rows[0]["AddrLine2"].ToString().Trim().Length > 0)
                    {
                        SellLabel5.Text = dtCust.Rows[0]["AddrLine2"].ToString();
                    }
                    else
                    {
                        SellLabel5.Visible = false;
                    }
                    SellLabel6.Text = dtCust.Rows[0]["City"].ToString() + ", " +
                        dtCust.Rows[0]["State"].ToString() + ". " +
                        dtCust.Rows[0]["PostCd"].ToString();
                    SellLabel7.Text = dtCust.Rows[0]["Country"].ToString();
                    //Ship to
                    ShipLabel1.Text = "Ship To ";
                    ShipLabel2.Text = "Attn: " + dt.Rows[0]["ContactName"].ToString();
                    ShipLabel3.Text = dtCust.Rows[0]["CustName"].ToString();
                    if (dtCust.Rows[0]["AddrLine1"].ToString().Trim().Length > 0)
                    {
                        ShipLabel4.Text = dtCust.Rows[0]["AddrLine1"].ToString();
                    }
                    else
                    {
                        ShipLabel4.Visible = false;
                    }
                    if (dtCust.Rows[0]["AddrLine2"].ToString().Trim().Length > 0)
                    {
                        ShipLabel5.Text = dtCust.Rows[0]["AddrLine2"].ToString();
                    }
                    else
                    {
                        ShipLabel5.Visible = false;
                    }
                    ShipLabel6.Text = dtCust.Rows[0]["City"].ToString() + ", " +
                        dtCust.Rows[0]["State"].ToString() + ". " +
                        dtCust.Rows[0]["PostCd"].ToString();
                    ShipLabel7.Text = dtCust.Rows[0]["Country"].ToString();
                    // cust ref
                    DateLabel.Text = FormatScreenData(DateFormat, dt.Rows[0]["QuotationDate"]);
                    ShipmentDateLabel.Text = FormatScreenData(DateFormat, dt.Rows[0]["QuotationDate"]);
                    TermsLabel.Text = dtCust.Rows[0]["TermsDesc"].ToString();
                    int pageRows = 44;
                    int rowCtr = 0;
                    int PageNo = 1;
                    // start a detail table
                    Table RowDetail = new Table();
                    RowDetail.ID = "DetSect" + PageNo.ToString();
                    RowDetail.Width = Unit.Percentage(100);
                    RowDetail.CellSpacing = 0;
                    RowDetail.CellPadding = 0;
                    //detailHeader.ID = "DetHdrRow" + PageNo.ToString();
                    //TableRow tdh1 = detailHeader;
                    //RowDetail.Rows.Clear();
                    //RowDetail.Rows.AddAt(0, tdh1);
                    // fill the detail
                    foreach (DataRow dr in dt.Select("DeleteFlag = 0"))
                    {
                        QuoteMaker = dr["InsideSalesRepName"].ToString().Trim();
                        // override the contact name if one is found in the lines
                        if (dr["ContactName"].ToString().Trim().Length > 0)
                        {
                            SellLabel2.Text = "Attn: " + dr["ContactName"].ToString();
                        }
                        if (rowCtr == 0)
                        {
                            // create the detail header
                            TableRow detailHeader = new TableHeaderRow();
                            detailHeader.VerticalAlign = VerticalAlign.Bottom;
                            TableCell detalHdrCol1 = new TableHeaderCell();
                            detalHdrCol1.Text = "Quantity/Total";
                            detalHdrCol1.CssClass = "newLine rightCol";
                            detalHdrCol1.Width = Unit.Percentage(12);
                            detailHeader.Cells.Add(detalHdrCol1);
                            TableCell detalHdrCol2 = new TableHeaderCell();
                            detalHdrCol2.Text = "Weight/<BR>Pack";
                            detalHdrCol2.CssClass = "newLine rightCol";
                            detalHdrCol2.Width = Unit.Percentage(10);
                            detailHeader.Cells.Add(detalHdrCol2);
                            TableCell detalHdrCol3 = new TableHeaderCell();
                            detalHdrCol3.Text = "PRODUCT DESCRIPTION";
                            detalHdrCol3.CssClass = "newLine rightCol";
                            detalHdrCol3.ColumnSpan = 2;
                            detalHdrCol3.Width = Unit.Percentage(41);
                            detailHeader.Cells.Add(detalHdrCol3);
                            TableCell detalHdrCol4 = new TableHeaderCell();
                            detalHdrCol4.Text = "Price Per UOM/<br />Location";
                            detalHdrCol4.CssClass = "newLine rightCol";
                            detalHdrCol4.Width = Unit.Percentage(14);
                            detailHeader.Cells.Add(detalHdrCol4);
                            TableCell detalHdrCol5 = new TableHeaderCell();
                            detalHdrCol5.Text = "Unit Price";
                            detalHdrCol5.CssClass = "newLine rightCol";
                            detalHdrCol5.Width = Unit.Percentage(10);
                            detailHeader.Cells.Add(detalHdrCol5);
                            TableCell detalHdrCol6 = new TableHeaderCell();
                            detalHdrCol6.Text = "Extended<br />AMOUNT";
                            detalHdrCol6.CssClass = "newLine";
                            detalHdrCol6.Width = Unit.Percentage(13);
                            detailHeader.Cells.Add(detalHdrCol6);
                            RowDetail.Rows.Add(detailHeader);
                        }
                        TableRow tr1 = new TableRow();
                        if (dr["UserItemNo"].ToString() == "COMMENT")
                        {
                            TableCell CommentCell = new TableCell();
                            CommentCell.Text = "Note: " + dr["Notes"].ToString();
                            CommentCell.CssClass = "newLine leftPad bold";
                            CommentCell.ColumnSpan = 7;
                            tr1.Cells.Add(CommentCell);
                            RowDetail.Rows.Add(tr1);
                            rowCtr++;
                        }
                        else
                        {
                            TableCell QtyCell = new TableCell();
                            QtyCell.Text = FormatScreenData(Num0Format, dr["RequestQuantity"]);
                            QtyCell.CssClass = "rightCol rightPad bold";
                            tr1.Cells.Add(QtyCell);
                            TableCell WghtCell = new TableCell();
                            WghtCell.Text = FormatScreenData(Num1Format, dr["NetWeight"]) + "LBS";
                            WghtCell.CssClass = "rightCol rightPad";
                            tr1.Cells.Add(WghtCell);
                            TableCell ItemNoCell = new TableCell();
                            ItemNoCell.Text = dr["PFCItemNo"].ToString();
                            ItemNoCell.CssClass = "bold leftPad";
                            tr1.Cells.Add(ItemNoCell);
                            TableCell CustItemCell = new TableCell();
                            CustItemCell.Text = dr["UserItemNo"].ToString() + "&nbsp;";
                            CustItemCell.CssClass = "rightCol leftPad";
                            tr1.Cells.Add(CustItemCell);
                            TableCell AltPriceCell = new TableCell();
                            AltPriceCell.Text = dr["PriceGlued"].ToString();
                            AltPriceCell.CssClass = "rightCol rightPad";
                            tr1.Cells.Add(AltPriceCell);
                            TableCell UnitePriceCell = new TableCell();
                            UnitePriceCell.Text = FormatScreenData(Num2Format, dr["UnitPrice"]);
                            UnitePriceCell.CssClass = "rightCol rightPad";
                            tr1.Cells.Add(UnitePriceCell);
                            TableCell ExtPriceCell = new TableCell();
                            ExtPriceCell.Text = FormatScreenData(Num2Format, dr["TotalPrice"]);
                            ExtPriceCell.CssClass = "rightPad bold";
                            tr1.Cells.Add(ExtPriceCell);
                            RowDetail.Rows.Add(tr1);
                            rowCtr++;
                            // second detail data row
                            TableRow tr2 = new TableRow();
                            TableCell QtyPcsCell = new TableCell();
                            QtyPcsCell.Text = FormatScreenData(Num0Format, dr["PieceQty"]) + "PC";
                            QtyPcsCell.CssClass = "rightCol rightPad";
                            tr2.Cells.Add(QtyPcsCell);
                            TableCell ContPcsCell = new TableCell();
                            ContPcsCell.Text = dr["BaseQtyLongGlued"].ToString();
                            ContPcsCell.CssClass = "rightCol rightPad";
                            tr2.Cells.Add(ContPcsCell);
                            TableCell ItemDescCell = new TableCell();
                            ItemDescCell.Text = FormatScreenData(Num0Format, dr["Description"]);
                            ItemDescCell.ColumnSpan = 2;
                            ItemDescCell.CssClass = "rightCol leftPad";
                            tr2.Cells.Add(ItemDescCell);
                            TableCell LocNameCell = new TableCell();
                            LocNameCell.Text = FormatScreenData(Num0Format, dr["LocationName"]);
                            LocNameCell.CssClass = "rightCol rightPad";
                            tr2.Cells.Add(LocNameCell);
                            TableCell EmptyCell = new TableCell();
                            EmptyCell.Text = "&nbsp;";
                            EmptyCell.CssClass = "rightCol";
                            tr2.Cells.Add(EmptyCell);
                            TableCell LineWeightCell = new TableCell();
                            LineWeightCell.Text = FormatScreenData(Num1Format, dr["LineWeight"]) + "LBS";
                            LineWeightCell.CssClass = "rightPad";
                            tr2.Cells.Add(LineWeightCell);
                            RowDetail.Rows.Add(tr2);
                            rowCtr++;
                            // third detail data row
                            TableRow tr3 = new TableRow();
                            TableCell ShipViaLabelCell = new TableCell();
                            ShipViaLabelCell.Text = "Ship Via";
                            ShipViaLabelCell.CssClass = "rightCol bold newLine";
                            ShipViaLabelCell.HorizontalAlign = HorizontalAlign.Center;
                            tr3.Cells.Add(ShipViaLabelCell);
                            TableCell EmptyCell2 = new TableCell();
                            EmptyCell2.Text = "&nbsp;";
                            EmptyCell2.CssClass = "rightCol newLine";
                            tr3.Cells.Add(EmptyCell2);
                            TableCell ShipCell = new TableCell();
                            ShipCell.Text = dr["OrderCarName"].ToString();
                            ShipCell.CssClass = "rightCol leftPad newLine bold";
                            ShipCell.ColumnSpan = 2;
                            tr3.Cells.Add(ShipCell);
                            TableCell EmptyCell3 = new TableCell();
                            EmptyCell3.Text = "&nbsp;";
                            EmptyCell3.CssClass = "rightCol newLine";
                            tr3.Cells.Add(EmptyCell3);
                            TableCell FreightCell = new TableCell();
                            FreightCell.Text = dr["OrderFreightName"].ToString() + "&nbsp;";
                            FreightCell.CssClass = "newLine bold leftPad";
                            FreightCell.ColumnSpan = 2;
                            tr3.Cells.Add(FreightCell);
                            RowDetail.Rows.Add(tr3);
                            rowCtr++;
                            if (dr["Notes"].ToString().Trim().Length > 0)
                            {
                                TableRow tr4 = new TableRow();
                                TableCell RemarkCell = new TableCell();
                                RemarkCell.Text = "Line Remark: " + dr["Notes"].ToString();
                                RemarkCell.CssClass = "newLine leftPad bold";
                                RemarkCell.ColumnSpan = 7;
                                tr4.Cells.Add(RemarkCell);
                                RowDetail.Rows.Add(tr4);
                                rowCtr++;
                            }
                        }
                        if (rowCtr > pageRows)
                        {
                            // add the detail lines already created
                            TableRow td1 = new TableRow();
                            TableCell DetCell = new TableCell();
                            DetCell.Controls.Add(RowDetail);
                            td1.Cells.Add(DetCell);
                            DocTable.Rows.Add(td1);
                            // start a new page
                            PageNo++;
                            TableRow th1 = new TableRow();
                            TableCell HdrCell = new TableCell();
                            //Build a new header
                            Table NewHeader = new Table();
                            NewHeader.ID = "NewHeader" + PageNo.ToString();
                            NewHeader.Width = Unit.Percentage(100);
                            NewHeader.CellSpacing = 0;
                            NewHeader.CellPadding = 0;

                            TableRow NewHeaderRow1 = new TableRow();
                            NewHeaderRow1.VerticalAlign = VerticalAlign.Top;
                            TableCell NewHeaderRow1Cell1 = new TableCell();
                            UserControl LogoUC = (UserControl)LoadControl("Common/UserControls/PrintDocLogo.ascx");
                            //NewHeaderRow1Cell1.Text = "Logo";
                            NewHeaderRow1Cell1.Controls.Add(LogoUC);
                            NewHeaderRow1Cell1.RowSpan = 5;
                            NewHeaderRow1Cell1.Width = Unit.Percentage(30);
                            NewHeaderRow1.Cells.Add(NewHeaderRow1Cell1);
                            NewHeader.Rows.Add(NewHeaderRow1);
                            TableRow NewHeaderRow2 = new TableRow();
                            TableCell NewHeaderRow2Cell1 = new TableCell();
                            NewHeaderRow2Cell1.Text = "Porteous Fastener Company SALES QUOTE";
                            NewHeaderRow2Cell1.CssClass = "docTitle";
                            NewHeaderRow2Cell1.ColumnSpan = 4;
                            NewHeaderRow2Cell1.HorizontalAlign = HorizontalAlign.Center;
                            NewHeaderRow2Cell1.Width = Unit.Percentage(70);
                            NewHeaderRow2.Cells.Add(NewHeaderRow2Cell1);
                            NewHeader.Rows.Add(NewHeaderRow2);
                            TableRow NewHeaderRow3 = new TableRow();
                            TableCell NewHeaderRow3Cell1 = new TableCell();
                            NewHeaderRow3Cell1.Text = "&nbsp;&nbsp; Customer ID:";
                            NewHeaderRow3Cell1.HorizontalAlign = HorizontalAlign.Left;
                            NewHeaderRow3.Cells.Add(NewHeaderRow3Cell1);
                            TableCell NewHeaderRow3Cell2 = new TableCell();
                            NewHeaderRow3Cell2.Text = "Quote Created:";
                            NewHeaderRow3Cell2.HorizontalAlign = HorizontalAlign.Left;
                            NewHeaderRow3.Cells.Add(NewHeaderRow3Cell2);
                            TableCell NewHeaderRow3Cell3 = new TableCell();
                            NewHeaderRow3Cell3.Text = "Quote Number:";
                            NewHeaderRow3Cell3.HorizontalAlign = HorizontalAlign.Right;
                            NewHeaderRow3.Cells.Add(NewHeaderRow3Cell3);
                            TableCell NewHeaderRow3Cell4 = new TableCell();
                            NewHeaderRow3Cell4.Text = "Page:";
                            NewHeaderRow3Cell4.HorizontalAlign = HorizontalAlign.Right;
                            NewHeaderRow3.Cells.Add(NewHeaderRow3Cell4);
                            NewHeader.Rows.Add(NewHeaderRow3);

                            TableRow NewHeaderRow4 = new TableRow();
                            TableCell NewHeaderRow4Cell1 = new TableCell();
                            NewHeaderRow4Cell1.Text = "&nbsp;&nbsp;&nbsp;" + CustIDLabel.Text;
                            NewHeaderRow4Cell1.HorizontalAlign = HorizontalAlign.Left;
                            NewHeaderRow4.Cells.Add(NewHeaderRow4Cell1);
                            TableCell NewHeaderRow4Cell2 = new TableCell();
                            NewHeaderRow4Cell2.Text = FormatScreenData(LongDateFormat, dt.Rows[0]["QuotationDate"]);
                            NewHeaderRow4Cell2.HorizontalAlign = HorizontalAlign.Left;
                            NewHeaderRow4.Cells.Add(NewHeaderRow4Cell2);
                            TableCell NewHeaderRow4Cell3 = new TableCell();
                            NewHeaderRow4Cell3.Text = QuoteNumberLabel.Text;
                            NewHeaderRow4Cell3.HorizontalAlign = HorizontalAlign.Right;
                            NewHeaderRow4.Cells.Add(NewHeaderRow4Cell3);
                            TableCell NewHeaderRow4Cell4 = new TableCell();
                            NewHeaderRow4Cell4.Text = PageNo.ToString();
                            NewHeaderRow4Cell4.HorizontalAlign = HorizontalAlign.Right;
                            NewHeaderRow4.Cells.Add(NewHeaderRow4Cell4);
                            NewHeader.Rows.Add(NewHeaderRow4);

                            TableRow NewHeaderRow5 = new TableRow();
                            TableCell NewHeaderRow5Cell1 = new TableCell();
                            NewHeaderRow5Cell1.Text = "<div class=locName>" + dtCust.Rows[0]["LocName"].ToString() + "</div>";
                            if (dtCust.Rows[0]["LocAdress1"].ToString().Trim().Length > 0)
                            {
                                NewHeaderRow5Cell1.Text += "<div class=locAddr>" + dtCust.Rows[0]["LocAdress1"].ToString() + "</div>";
                            }
                            if (dtCust.Rows[0]["LocAdress2"].ToString().Trim().Length > 0)
                            {
                                NewHeaderRow5Cell1.Text += "<div class=locAddr>" + dtCust.Rows[0]["LocAdress2"].ToString() + "</div>";
                            }
                            NewHeaderRow5Cell1.Text += "<div class=locAddr>" + dtCust.Rows[0]["LocCityStZip"].ToString() + "</div>";
                            NewHeaderRow5Cell1.ColumnSpan = 4;
                            NewHeaderRow5.Cells.Add(NewHeaderRow5Cell1);
                            NewHeader.Rows.Add(NewHeaderRow5);
                           
                            HdrCell.Controls.Add(NewHeader);
                            HdrCell.CssClass = "newPage";
                            HdrCell.ID = "XHeader" + PageNo.ToString();
                            th1.Cells.Add(HdrCell);
                            DocTable.Rows.Add(th1);
                            // more rows can be printed becuase the sub header is not shown beyond the first page
                            pageRows = 59;
                            rowCtr = 0;
                            // start a new detail section
                            RowDetail = new Table();
                            RowDetail.Width = Unit.Percentage(100);
                            RowDetail.CellSpacing = 0;
                            RowDetail.CellPadding = 0;
                            RowDetail.ID = "DetSect" + PageNo.ToString();
                        }
                    }
                    // add the last page detail
                    TableRow tdlast = new TableRow();
                    TableCell LastDetCell = new TableCell();
                    LastDetCell.Controls.Add(RowDetail);
                    tdlast.Cells.Add(LastDetCell);
                    DocTable.Rows.Add(tdlast);
                    for (int l = 0; l + rowCtr < pageRows - 3; l++)
                    {
                        TableRow fillRow = new TableRow();
                        TableCell fillCell = new TableCell();
                        fillCell.Text = "&nbsp;";
                        fillRow.Cells.Add(fillCell);
                        DocTable.Rows.Add(fillRow);
                    }
                    // create the totals
                    sumObject = dt.Compute("Sum(TotalPrice)", "DeleteFlag = 0");
                    QuoteTotObject = sumObject;
                    //QuoteTotalLabel.Text = FormatScreenData(DollarFormat, sumObject);
                    Table QuoteTotals = new Table();
                    QuoteTotals.ID = "QuoteTotals";
                    QuoteTotals.Width = Unit.Percentage(100);
                    QuoteTotals.CellSpacing = 0;
                    QuoteTotals.CellPadding = 0;
                    TableRow total1 = new TableRow();
                    TableCell ThanxLabelCell = new TableCell();
                    ThanxLabelCell.Text = "&nbsp;&nbsp;&nbsp;<i>Thank You for the Opportunity to be of Service</i>";
                    ThanxLabelCell.CssClass = "quoteTotal";
                    ThanxLabelCell.RowSpan = 2;
                    ThanxLabelCell.Width = Unit.Percentage(60);
                    total1.Cells.Add(ThanxLabelCell);
                    TableCell TotAmtLabelCell = new TableCell();
                    TotAmtLabelCell.Text = "Quote Total(USD):";
                    TotAmtLabelCell.CssClass = "bold quoteTotal";
                    TotAmtLabelCell.HorizontalAlign = HorizontalAlign.Right;
                    TotAmtLabelCell.Width = Unit.Percentage(20);
                    total1.Cells.Add(TotAmtLabelCell);
                    TableCell TotAmtCell = new TableCell();
                    TotAmtCell.Text = FormatScreenData(DollarFormat, sumObject);
                    TotAmtCell.CssClass = "bold quoteTotal";
                    TotAmtCell.HorizontalAlign = HorizontalAlign.Right;
                    TotAmtCell.Width = Unit.Percentage(20);
                    total1.Cells.Add(TotAmtCell);
                    QuoteTotals.Rows.Add(total1);
                    sumObject = dt.Compute("Sum(LineWeight)", "DeleteFlag = 0");
                    //ExtendedWeightLabel.Text = FormatScreenData(Num1Format, sumObject);
                    TableRow total2 = new TableRow();
                    TableCell TotLbLabelCell = new TableCell();
                    TotLbLabelCell.Text = "Total LBS:";
                    TotLbLabelCell.CssClass = "quoteTotal";
                    TotLbLabelCell.HorizontalAlign = HorizontalAlign.Right;
                    total2.Cells.Add(TotLbLabelCell);
                    TableCell TotLbCell = new TableCell();
                    TotLbCell.Text = FormatScreenData(Num1Format, sumObject);
                    TotLbCell.CssClass = "quoteTotal";
                    TotLbCell.HorizontalAlign = HorizontalAlign.Right;
                    total2.Cells.Add(TotLbCell);
                    QuoteTotals.Rows.Add(total2);
                    TableRow total3 = new TableRow();
                    TableCell TotMsgLabelCell = new TableCell();
                    TotMsgLabelCell.Text = "Order Status, Shipment Tracking, and Order Entry are available on the Web at www.PorteousFastener.com";
                    TotMsgLabelCell.CssClass = "bottomMessage bold";
                    TotMsgLabelCell.HorizontalAlign = HorizontalAlign.Center;
                    TotMsgLabelCell.ColumnSpan = 3;
                    total3.Cells.Add(TotMsgLabelCell);
                    QuoteTotals.Rows.Add(total3);
                    TableRow tt1 = new TableRow();
                    TableCell TotCell = new TableCell();
                    TotCell.ID = "docFooter";
                    TotCell.Controls.Add(QuoteTotals);
                    tt1.Cells.Add(TotCell);
                    DocTable.Rows.Add(tt1);
                    // document complete
                    NumberOfPages.Value = PageNo.ToString();
                }

            }
        }
        catch (Exception e2)
        {
            TermsLabel.Text = e2.Message + ", " + e2.ToString();
        }
    }

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

}
