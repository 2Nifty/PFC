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

public partial class SOExport : Page
{
    OrderEntry orderEntry = new OrderEntry();
    CustomerDetail custDet = new CustomerDetail();
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataSet dsSys = new DataSet();
    DataTable dtSys = new DataTable();
    DataRow orderrow;
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

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session["dtPrint"] = null;
            NameValueCollection coll = Request.QueryString;
            if (coll["OrderNo"] != null)
            {
                dsSys = SqlHelper.ExecuteDataset(connectionString, "pUTGetSysMaster");
                dtSys = dsSys.Tables[0];
                if (dtSys.Rows[0]["PrintRqst"].ToString().Trim() == "T")
                {
                    TestWatermark.Attributes["class"] = "watermark";
                    TestWatermark.Attributes.Add("style",
                      "background-image:url(" + ConfigurationManager.AppSettings["SOESiteURL"].ToString() + "Common/Images/TestWatermark.gif);");
                }
                OrderNumberLabel.Text = coll["OrderNo"].ToString();
                if (coll["DocType"] != null && coll["DocType"].ToString() == "InternationalInvoice")
                {
                    DocTitleLabel.Text = "COMMERCIAL INVOICE";
                    DocType.Value = coll["DocType"].ToString();
                }
                else
                {
                    DocTitleLabel.Text = "SALES ORDER";
                    DocType.Value = "SalesOrder";
                }
                if (coll["LineSort"] != null)
                {
                    LineSort.Value = coll["LineSort"].ToString().Trim();
                }
                else
                {
                    LineSort.Value = "E";
                }
                if (coll["Header"] != null)
                {
                    HeaderTable.Value = coll["Header"].ToString().Trim();
                }
                else
                {
                    HeaderTable.Value = "SOHeader";
                }
                GetOrder();
            }
        }
    }

    protected void GetOrder()
    {
        // The main table on the page is Doc Table.
        // To populate the form, we fill the preconfigured .net controls on the page with the header data.
        // We then go though the detail create an internal table (RowDetail) and format the lines, comments, etc.
        // as the pages fill, headers are added as needed and it is usually at his time that we will add
        // the internal table rows to the DocTable on the page
        try
        {
            // get the order data.
            ds = SqlHelper.ExecuteDataset(connectionString, "pSOEGetDoc",
                new SqlParameter("@DocNumber", OrderNumberLabel.Text),
                new SqlParameter("@SortCode", LineSort.Value),
                new SqlParameter("@HeaderTable", HeaderTable.Value));
            if (ds.Tables.Count > 1)
            {
                // ds[1] = header, [2] = lines, [3]=expenses, [4]=comments
                dt = ds.Tables[1];
                //
                // fill the header
                if ((DocType.Value == "SalesOrder") && (dt.Rows[0]["OrderType"].ToString() != "0"))
                {
                    DocTitleLabel.Text = dt.Rows[0]["OrderTypeDsc"].ToString();
                }

                ReferenceLabel.Text = dt.Rows[0]["CustPONo"].ToString();
                CustIDLabel.Text = dt.Rows[0]["SellToCustNo"].ToString();
                OrderDateLabel.Text = FormatScreenData(LongDateFormat, dt.Rows[0]["OrderDt"]);
                PageNumberLabel.Text = "1";
                LocNameLabel.Text = dt.Rows[0]["LocName"].ToString();
                if (dt.Rows[0]["LocAdress1"].ToString().Trim().Length > 0)
                {
                    LocAddr1.Text = dt.Rows[0]["LocAdress1"].ToString();
                }
                else
                {
                    LocAddr1.Visible = false;
                }
                if (dt.Rows[0]["LocAdress2"].ToString().Trim().Length > 0)
                {
                    LocAddr2.Text = dt.Rows[0]["LocAdress2"].ToString();
                }
                else
                {
                    LocAddr2.Visible = false;
                }
                LocCityStZip.Text = dt.Rows[0]["LocCityStZip"].ToString();
                InsideNameLabel.Text = dt.Rows[0]["InsideName"].ToString();
                InsideEMailLabel.Text = dt.Rows[0]["InsideEmail"].ToString();
                InsidePhoneLabel.Text = dt.Rows[0]["InsidePhone"].ToString();
                InsideFAXLabel.Text = dt.Rows[0]["InsideFax"].ToString();
                MgrNameLabel.Text = dt.Rows[0]["MgrName"].ToString();
                MgrEMailLabel.Text = dt.Rows[0]["MgrEmail"].ToString();
                MgrPhoneLabel.Text = dt.Rows[0]["MgrPhone"].ToString();
                MgrFAXLabel.Text = dt.Rows[0]["MgrFax"].ToString();
                // bill to
                BillLabel1.Text = "Bill To " + dt.Rows[0]["BillToCustNo"].ToString();
                if (dt.Rows[0]["BillToContactName"].ToString().Trim().Length == 0)
                {
                    BillLabel2.Visible = false;
                }
                else
                {
                    BillLabel2.Text = "Attn: " + dt.Rows[0]["BillToContactName"].ToString();
                }
                BillLabel3.Text = dt.Rows[0]["BillToCustName"].ToString();
                if (dt.Rows[0]["BillToAddress1"].ToString().Trim().Length > 0)
                {
                    BillLabel4.Text = dt.Rows[0]["BillToAddress1"].ToString();
                }
                else
                {
                    BillLabel4.Visible = false;
                }
                if (dt.Rows[0]["BillToAddress2"].ToString().Trim().Length > 0)
                {
                    BillLabel5.Text = dt.Rows[0]["BillToAddress2"].ToString();
                }
                else
                {
                    BillLabel5.Visible = false;
                }
                BillLabel6.Text = dt.Rows[0]["BillToCity"].ToString() + ", " +
                    dt.Rows[0]["BillToState"].ToString() + ". " +
                    dt.Rows[0]["BillToZip"].ToString();
                BillLabel7.Text = dt.Rows[0]["BillToCountry"].ToString();
                //Sell to
                SellLabel1.Text = "Sell To " + dt.Rows[0]["SellToCustNo"].ToString();
                if (dt.Rows[0]["SellToContactName"].ToString().Trim().Length == 0)
                {
                    SellLabel2.Visible = false;
                }
                else
                {
                    SellLabel2.Text = "Attn: " + dt.Rows[0]["SellToContactName"].ToString();
                }
                SellLabel3.Text = dt.Rows[0]["SellToCustName"].ToString();
                if (dt.Rows[0]["SellToAddress1"].ToString().Trim().Length > 0)
                {
                    SellLabel4.Text = dt.Rows[0]["SellToAddress1"].ToString();
                }
                else
                {
                    SellLabel4.Visible = false;
                }
                if (dt.Rows[0]["SellToAddress2"].ToString().Trim().Length > 0)
                {
                    SellLabel5.Text = dt.Rows[0]["SellToAddress2"].ToString();
                }
                else
                {
                    SellLabel5.Visible = false;
                }
                SellLabel6.Text = dt.Rows[0]["SellToCity"].ToString() + ", " +
                    dt.Rows[0]["SellToState"].ToString() + ". " +
                    dt.Rows[0]["SellToZip"].ToString();
                SellLabel7.Text = dt.Rows[0]["SellToCountry"].ToString();
                //Ship to
                ShipLabel1.Text = "Ship To ";
                if (dt.Rows[0]["ContactName"].ToString().Trim().Length == 0)
                {
                    ShipLabel2.Visible = false;
                }
                else
                {
                    ShipLabel2.Text = "Attn: " + dt.Rows[0]["ContactName"].ToString();
                }
                ShipLabel3.Text = dt.Rows[0]["ShipToName"].ToString();
                if (dt.Rows[0]["ShipToAddress1"].ToString().Trim().Length > 0)
                {
                    ShipLabel4.Text = dt.Rows[0]["ShipToAddress1"].ToString();
                }
                else
                {
                    ShipLabel4.Visible = false;
                }
                if (dt.Rows[0]["ShipToAddress2"].ToString().Trim().Length > 0)
                {
                    ShipLabel5.Text = dt.Rows[0]["ShipToAddress2"].ToString();
                }
                else
                {
                    ShipLabel5.Visible = false;
                }
                ShipLabel6.Text = dt.Rows[0]["City"].ToString() + ", " +
                    dt.Rows[0]["State"].ToString() + ". " +
                    dt.Rows[0]["Zip"].ToString();
                ShipLabel7.Text = dt.Rows[0]["Country"].ToString();
                // cust ref 
                PONumberLabel.Text = dt.Rows[0]["CustPONo"].ToString();
                DateLabel.Text = FormatScreenData(DateFormat, dt.Rows[0]["OrderDt"]);
                ShipmentDateLabel.Text = FormatScreenData(DateFormat, dt.Rows[0]["SchShipDt"]);
                TermsLabel.Text = dt.Rows[0]["OrderTermsName"].ToString();
                int pageRows = 39;
                int rowCtr = 0;
                int PageNo = 1;
                int FirstPage = 1;
                string ShipMethod = dt.Rows[0]["OrderFreightName"].ToString(); 
                // add any header comments
                foreach (DataRow dc in ds.Tables[4].Select("Type = 'CT'"))
                {
                    CommentTopLabel.Text += dc["CommText"].ToString() + "<br>";
                    rowCtr++;
                }
                // set the detail table
                dt = ds.Tables[2];
                // start a detail table
                Table RowDetail = new Table();
                RowDetail.ID = "DetSect" + PageNo.ToString();
                RowDetail.Width = Unit.Percentage(100);
                RowDetail.CellSpacing = 0;
                RowDetail.CellPadding = 0;
                // fill the detail
                foreach (DataRow dr in dt.Rows)
                {
                    if ((rowCtr == 0) || (FirstPage == 1))
                    {
                        FirstPage = 0;
                        // create the detail header
                        TableRow detailHeader = new TableHeaderRow();
                        detailHeader.VerticalAlign = VerticalAlign.Bottom;
                        TableCell detalHdrCol1 = new TableHeaderCell();
                        detalHdrCol1.Text = "Quantity/Total";
                        detalHdrCol1.CssClass = "newLine rightCol";
                        detalHdrCol1.Width = Unit.Percentage(12);
                        detailHeader.Cells.Add(detalHdrCol1);
                        TableCell detalHdrCol2 = new TableHeaderCell();
                        detalHdrCol2.Text = "Weight/Pack";
                        detalHdrCol2.CssClass = "newLine rightCol";
                        detalHdrCol2.Width = Unit.Percentage(13);
                        detailHeader.Cells.Add(detalHdrCol2);
                        TableCell detalHdrCol3 = new TableHeaderCell();
                        detalHdrCol3.Text = "PRODUCT DESCRIPTION";
                        detalHdrCol3.CssClass = "newLine rightCol";
                        detalHdrCol3.ColumnSpan = 2;
                        detalHdrCol3.Width = Unit.Percentage(38);
                        detailHeader.Cells.Add(detalHdrCol3);
                        TableCell detalHdrCol4 = new TableHeaderCell();
                        detalHdrCol4.Text = "Price UOM/<br />Location";
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
                    // now write the body
                    TableRow tr1 = new TableRow();
                    if (dr["CustItemNo"].ToString() == "COMMENT")
                    {
                        TableCell CommentCell = new TableCell();
                        CommentCell.Text = "Note: " + dr["Remark"].ToString();
                        CommentCell.CssClass = "newLine leftPad bold";
                        CommentCell.ColumnSpan = 7;
                        tr1.Cells.Add(CommentCell);
                        RowDetail.Rows.Add(tr1);
                        rowCtr++;
                    }
                    else
                    {
                        TableCell QtyCell = new TableCell();
                        QtyCell.Text = FormatScreenData(Num0Format, dr["QtyOrdered"]);
                        QtyCell.CssClass = "rightCol rightPad bold";
                        tr1.Cells.Add(QtyCell);
                        TableCell WghtCell = new TableCell();
                        WghtCell.Text = FormatScreenData(Num1Format, dr["GrossWght"]) + "LBS";
                        WghtCell.CssClass = "rightCol rightPad";
                        tr1.Cells.Add(WghtCell);
                        TableCell ItemNoCell = new TableCell();
                        ItemNoCell.Text = dr["ItemNo"].ToString();
                        ItemNoCell.CssClass = "bold leftPad";
                        tr1.Cells.Add(ItemNoCell);
                        TableCell CustItemCell = new TableCell();
                        CustItemCell.Text = dr["CustItemNo"].ToString() + "&nbsp;";
                        CustItemCell.CssClass = "rightCol leftPad";
                        tr1.Cells.Add(CustItemCell);
                        TableCell AltPriceCell = new TableCell();
                        AltPriceCell.Text = FormatScreenData(Num2Format, dr["AlternatePrice"]) + "/" + dr["AlternateUM"].ToString();
                        AltPriceCell.CssClass = "rightCol rightPad";
                        tr1.Cells.Add(AltPriceCell);
                        TableCell UnitePriceCell = new TableCell();
                        UnitePriceCell.Text = FormatScreenData(Num2Format, dr["NetUnitPrice"]);
                        UnitePriceCell.CssClass = "rightCol rightPad";
                        tr1.Cells.Add(UnitePriceCell);
                        TableCell ExtPriceCell = new TableCell();
                        ExtPriceCell.Text = FormatScreenData(Num2Format, dr["ExtendedPrice"]);
                        ExtPriceCell.CssClass = "rightPad bold";
                        tr1.Cells.Add(ExtPriceCell);
                        RowDetail.Rows.Add(tr1);
                        rowCtr++;
                        // second detail data row
                        TableRow tr2 = new TableRow();
                        TableCell QtyPcsCell = new TableCell();
                        QtyPcsCell.Text = FormatScreenData(Num0Format, dr["AlternateUMQty"]) + dr["QtyText"].ToString();
                        QtyPcsCell.CssClass = "rightCol rightPad";
                        tr2.Cells.Add(QtyPcsCell);
                        TableCell ContPcsCell = new TableCell();
                        ContPcsCell.Text = FormatScreenData(Num0Format, dr["SellStkQty"]) + "/" + dr["ContainerName"].ToString(); 
                        ContPcsCell.CssClass = "rightCol rightPad";
                        tr2.Cells.Add(ContPcsCell);
                        TableCell ItemDescCell = new TableCell();
                        ItemDescCell.Text = FormatScreenData(Num0Format, dr["ItemDsc"]);
                        ItemDescCell.ColumnSpan = 2;
                        ItemDescCell.VerticalAlign = VerticalAlign.Bottom;
                        ItemDescCell.CssClass = "desctext rightCol leftPad";
                        tr2.Cells.Add(ItemDescCell);
                        TableCell LocNameCell = new TableCell();
                        LocNameCell.Text = FormatScreenData(Num0Format, dr["IMLocName"]);
                        LocNameCell.CssClass = "rightCol rightPad";
                        tr2.Cells.Add(LocNameCell);
                        TableCell EmptyCell = new TableCell();
                        EmptyCell.Text = "&nbsp;";
                        EmptyCell.CssClass = "rightCol";
                        tr2.Cells.Add(EmptyCell);
                        TableCell LineWeightCell = new TableCell();
                        LineWeightCell.Text = FormatScreenData(Num1Format, dr["ExtendedGrossWght"]) + "LBS";
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
                        ShipCell.Text = dr["CarrierName"].ToString();
                        ShipCell.CssClass = "rightCol leftPad newLine bold";
                        ShipCell.ColumnSpan = 2;
                        tr3.Cells.Add(ShipCell);
                        TableCell EmptyCell3 = new TableCell();
                        EmptyCell3.Text = "&nbsp;";
                        EmptyCell3.CssClass = "rightCol newLine";
                        tr3.Cells.Add(EmptyCell3);
                        TableCell FreightCell = new TableCell();
                        //FreightCell.Text = dr["OrderFreightName"].ToString();
                        FreightCell.Text = ShipMethod;
                        FreightCell.CssClass = "newLine bold leftPad";
                        FreightCell.ColumnSpan = 2;
                        tr3.Cells.Add(FreightCell);
                        RowDetail.Rows.Add(tr3);
                        rowCtr++;
                        if (dr["Remark"].ToString().Trim().Length > 0)
                        {
                            TableRow tr4 = new TableRow();
                            TableCell RemarkCell = new TableCell();
                            RemarkCell.Text = "Line Remark: " + dr["Remark"].ToString();
                            RemarkCell.CssClass = "newLine leftPad bold";
                            RemarkCell.ColumnSpan = 7;
                            tr4.Cells.Add(RemarkCell);
                            RowDetail.Rows.Add(tr4);
                            rowCtr++;
                        }
                        // add any line comments
                        foreach (DataRow dc in ds.Tables[4].Select("Type = 'LC' and CommLineNo='" + dr["LineNumber"].ToString() + "'"))
                        {
                            TableRow tr4 = new TableRow();
                            TableCell RemarkCell = new TableCell();
                            RemarkCell.Text = dc["CommText"].ToString();
                            RemarkCell.CssClass = "newLine leftPad bold";
                            RemarkCell.ColumnSpan = 7;
                            tr4.Cells.Add(RemarkCell);
                            RowDetail.Rows.Add(tr4);
                            rowCtr++;
                        }
                    }
                    if (rowCtr > pageRows)
                    {
                        TableRow td1 = new TableRow();
                        TableCell DetCell = new TableCell();
                        DetCell.Controls.Add(RowDetail);
                        td1.Cells.Add(DetCell);
                        // add rows to page here
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
                        NewHeaderRow2Cell1.Text = "Porteous Fastener Company " + DocTitleLabel.Text;
                        NewHeaderRow2Cell1.CssClass = "docTitle";
                        NewHeaderRow2Cell1.ColumnSpan = 5;
                        NewHeaderRow2Cell1.HorizontalAlign = HorizontalAlign.Center;
                        NewHeaderRow2Cell1.Width = Unit.Percentage(70);
                        NewHeaderRow2.Cells.Add(NewHeaderRow2Cell1);
                        NewHeader.Rows.Add(NewHeaderRow2);
                        TableRow NewHeaderRow3 = new TableRow();
                        TableCell NewHeaderRow3Cell1 = new TableCell();
                        NewHeaderRow3Cell1.Text = "&nbsp;&nbsp; Reference:";
                        NewHeaderRow3Cell1.HorizontalAlign = HorizontalAlign.Left;
                        NewHeaderRow3.Cells.Add(NewHeaderRow3Cell1);
                        TableCell NewHeaderRow3Cell2 = new TableCell();
                        NewHeaderRow3Cell2.Text = "Customer ID:";
                        NewHeaderRow3Cell2.HorizontalAlign = HorizontalAlign.Right;
                        NewHeaderRow3.Cells.Add(NewHeaderRow3Cell2);
                        TableCell NewHeaderRow3Cell3 = new TableCell();
                        NewHeaderRow3Cell3.Text = "Order Date:";
                        NewHeaderRow3Cell3.HorizontalAlign = HorizontalAlign.Right;
                        NewHeaderRow3.Cells.Add(NewHeaderRow3Cell3);
                        TableCell NewHeaderRow3Cell4 = new TableCell();
                        NewHeaderRow3Cell4.Text = "Order Number:";
                        NewHeaderRow3Cell4.HorizontalAlign = HorizontalAlign.Right;
                        NewHeaderRow3.Cells.Add(NewHeaderRow3Cell4);
                        TableCell NewHeaderRow3Cell5 = new TableCell();
                        NewHeaderRow3Cell5.Text = "Page:";
                        NewHeaderRow3Cell5.HorizontalAlign = HorizontalAlign.Right;
                        NewHeaderRow3.Cells.Add(NewHeaderRow3Cell5);
                        NewHeader.Rows.Add(NewHeaderRow3);

                        TableRow NewHeaderRow4 = new TableRow();
                        TableCell NewHeaderRow4Cell1 = new TableCell();
                        NewHeaderRow4Cell1.Text = "&nbsp;&nbsp;&nbsp;" + ReferenceLabel.Text;
                        NewHeaderRow4Cell1.HorizontalAlign = HorizontalAlign.Left;
                        NewHeaderRow4.Cells.Add(NewHeaderRow4Cell1);
                        TableCell NewHeaderRow4Cell2 = new TableCell();
                        NewHeaderRow4Cell2.Text = CustIDLabel.Text;
                        NewHeaderRow4Cell2.HorizontalAlign = HorizontalAlign.Right;
                        NewHeaderRow4.Cells.Add(NewHeaderRow4Cell2);
                        TableCell NewHeaderRow4Cell3 = new TableCell();
                        NewHeaderRow4Cell3.Text = OrderDateLabel.Text;
                        NewHeaderRow4Cell3.HorizontalAlign = HorizontalAlign.Right;
                        NewHeaderRow4.Cells.Add(NewHeaderRow4Cell3);
                        TableCell NewHeaderRow4Cell4 = new TableCell();
                        NewHeaderRow4Cell4.Text = OrderNumberLabel.Text;
                        NewHeaderRow4Cell4.HorizontalAlign = HorizontalAlign.Right;
                        NewHeaderRow4.Cells.Add(NewHeaderRow4Cell4);
                        TableCell NewHeaderRow4Cell5 = new TableCell();
                        NewHeaderRow4Cell5.Text = PageNo.ToString();
                        NewHeaderRow4Cell5.HorizontalAlign = HorizontalAlign.Right;
                        NewHeaderRow4.Cells.Add(NewHeaderRow4Cell5);
                        NewHeader.Rows.Add(NewHeaderRow4);

                        TableRow NewHeaderRow5 = new TableRow();
                        TableCell NewHeaderRow5Cell1 = new TableCell();
                        NewHeaderRow5Cell1.Text = "<div class=locName>" + LocNameLabel.Text + "</div>";
                        if (LocAddr1.Text.Trim().Length > 0)
                        {
                            NewHeaderRow5Cell1.Text += "<div class=locAddr>" + LocAddr1.Text + "</div>";
                        }
                        if (LocAddr2.Text.Trim().Length > 0)
                        {
                            NewHeaderRow5Cell1.Text += "<div class=locAddr>" + LocAddr2.Text + "</div>";
                        }
                        NewHeaderRow5Cell1.Text += "<div class=locAddr>" + LocCityStZip.Text + "</div>";
                        NewHeaderRow5Cell1.ColumnSpan = 5;
                        NewHeaderRow5.Cells.Add(NewHeaderRow5Cell1);
                        NewHeader.Rows.Add(NewHeaderRow5);

                        HdrCell.Controls.Add(NewHeader);

                        HdrCell.CssClass = "newPage";
                        HdrCell.ID = "XHeader" + PageNo.ToString();
                        th1.Cells.Add(HdrCell);
                        DocTable.Rows.Add(th1);
                        // more rows can be printed because the sub header is not shown beyond the first page
                        pageRows = 54;
                        rowCtr = 0;
                        RowDetail = new Table();
                        RowDetail.Width = Unit.Percentage(100);
                        RowDetail.CellSpacing = 0;
                        RowDetail.CellPadding = 0;
                        RowDetail.ID = "DetSect" + PageNo.ToString();
                    }
                }
                // add any expenses
                foreach (DataRow de in ds.Tables[3].Rows)
                {
                    TableRow tr4 = new TableRow();
                    TableCell ExpensLabelCell = new TableCell();
                    ExpensLabelCell.Text = "Charge:";
                    ExpensLabelCell.CssClass = "newLine leftPad rightCol";
                    tr4.Cells.Add(ExpensLabelCell);
                    TableCell ExpensDescCell = new TableCell();
                    ExpensDescCell.Text = de["ExpenseDesc"].ToString();
                    ExpensDescCell.CssClass = "newLine leftPad bold rightCol";
                    ExpensDescCell.ColumnSpan = 5;
                    tr4.Cells.Add(ExpensDescCell);
                    TableCell ExpensAmountCell = new TableCell();
                    ExpensAmountCell.Text = FormatScreenData(Num2Format, de["Amount"]);
                    ExpensAmountCell.CssClass = "newLine rightPad bold";
                    tr4.Cells.Add(ExpensAmountCell);
                    RowDetail.Rows.Add(tr4);
                    rowCtr++;
                }
                // add any bottom comments
                foreach (DataRow dc in ds.Tables[4].Select("Type = 'CB'"))
                {
                    TableRow tr4 = new TableRow();
                    TableCell RemarkCell = new TableCell();
                    RemarkCell.Text = dc["CommText"].ToString();
                    RemarkCell.CssClass = "leftPad bold";
                    RemarkCell.ColumnSpan = 7;
                    tr4.Cells.Add(RemarkCell);
                    RowDetail.Rows.Add(tr4);
                    rowCtr++;
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
                // print the totals
                Table OrderTotals = new Table();
                OrderTotals.ID = "OrderTotals";
                OrderTotals.Width = Unit.Percentage(100);
                OrderTotals.CellSpacing = 0;
                OrderTotals.CellPadding = 0;
                TableRow total1 = new TableRow();
                TableCell ThanxLabelCell = new TableCell();
                ThanxLabelCell.Text = "&nbsp;&nbsp;&nbsp;<i>Thank You for the Opportunity to be of Service</i>";
                ThanxLabelCell.CssClass = "docTotal";
                ThanxLabelCell.RowSpan = 2;
                ThanxLabelCell.Width = Unit.Percentage(60);
                total1.Cells.Add(ThanxLabelCell);
                TableCell TotAmtLabelCell = new TableCell();
                TotAmtLabelCell.Text = "Order Total(USD):";
                TotAmtLabelCell.CssClass = "bold docTotal";
                TotAmtLabelCell.HorizontalAlign = HorizontalAlign.Right;
                TotAmtLabelCell.Width = Unit.Percentage(20);
                total1.Cells.Add(TotAmtLabelCell);
                TableCell TotAmtCell = new TableCell();
                TotAmtCell.Text = FormatScreenData(DollarFormat, ds.Tables[1].Rows[0]["TotalOrder"]);
                TotAmtCell.CssClass = "bold docTotal";
                TotAmtCell.HorizontalAlign = HorizontalAlign.Right;
                TotAmtCell.Width = Unit.Percentage(20);
                total1.Cells.Add(TotAmtCell);
                OrderTotals.Rows.Add(total1);
                TableRow total2 = new TableRow();
                TableCell TotLbLabelCell = new TableCell();
                TotLbLabelCell.Text = "Total LBS:";
                TotLbLabelCell.CssClass = "docTotal";
                TotLbLabelCell.HorizontalAlign = HorizontalAlign.Right;
                total2.Cells.Add(TotLbLabelCell);
                TableCell TotLbCell = new TableCell();
                TotLbCell.Text = FormatScreenData(Num1Format, ds.Tables[1].Rows[0]["BOLWght"]);
                TotLbCell.CssClass = "docTotal";
                TotLbCell.HorizontalAlign = HorizontalAlign.Right;
                total2.Cells.Add(TotLbCell);
                OrderTotals.Rows.Add(total2);
                TableRow total3 = new TableRow();
                TableCell TotMsgLabelCell = new TableCell();
                TotMsgLabelCell.Text = "Order Status, Shipment Tracking, and Order Entry are available on the Web at www.PorteousFastener.com";
                TotMsgLabelCell.CssClass = "bottomMessage bold";
                TotMsgLabelCell.HorizontalAlign = HorizontalAlign.Center;
                TotMsgLabelCell.ColumnSpan = 3;
                total3.Cells.Add(TotMsgLabelCell);
                OrderTotals.Rows.Add(total3);
                TableRow tt1 = new TableRow();
                TableCell TotCell = new TableCell();
                TotCell.ID = "docFooter";
                TotCell.Controls.Add(OrderTotals);
                tt1.Cells.Add(TotCell);
                DocTable.Rows.Add(tt1);
                // document complete
                NumberOfPages.Value = PageNo.ToString();
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
