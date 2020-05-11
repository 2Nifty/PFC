using System;
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
using PFC.SOE.DataAccessLayer;

public partial class PackSlipExport : Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCRBConnectionString"].ToString();
    string ERPconnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    private string Num0Format = "{0:####,###,##0} ";
    private string Num1Format = "{0:####,###,##0.0} ";
    private string Num2Format = "{0:####,###,##0.00} ";
    private string Num3Format = "{0:####,###,##0.000} ";
    private string DollarFormat = "${0:#,##0.00} ";
    private string Dollar3Format = "${0:#,##0.000} ";
    private string PcntFormat = "{0:#,##0.0}% ";
    private string DateFormat = "{0:MM/dd/yy} ";
    private string MedDateFormat = "{0:MMM dd, yyyy} ";
    private string LongDateFormat = "{0:dddd, MMM dd, yyyy} ";
    private string LongDateTimeFormat = "{0:MM/dd/yy h:mtt} ";
    DataSet ds = new DataSet();
    DataTable dtHdr = new DataTable();
    DataTable dtLines = new DataTable();
    DataTable dtFooter = new DataTable();
    DataSet dsSys = new DataSet();
    DataTable dtSys = new DataTable();
    string UserName;
    string PackSlipNo = "";
    int rowCtr = 0;
    decimal PageNo = 1;
    decimal PrintedHeight;
    decimal PageBottom = 0;
    decimal PageFooterHeight;
    decimal DocFooterHeight;
    decimal DocHeight = 8.0M;
    decimal PickPieces = 0;
    decimal PickCtns = 0;
    decimal PickWeight = 0;
    DateTime PrintDate = DateTime.Now;
    int[] DetColWid = { 12, 15, 5, 8, 8, 8, 35, 8 };

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            Session["dtPrint"] = null;
            if (Request.QueryString["UserName"] != null)
            {
                UserName = Request.QueryString["UserName"].ToString().Trim();
            }
            else
                if (Session["UserName"] != null)
                {
                    UserName = Session["UserName"].ToString().Trim();
                }
                else
                {
                    UserName = "NoUser";
                }
            if (Request.QueryString["OrderNo"] != null)
            {
                PackSlipNo = Request.QueryString["OrderNo"].ToString();
                try
                {
                    // get the order data.
                    ds = SqlHelper.ExecuteDataset(connectionString, "pFormPackSlip",
                        new SqlParameter("@PackSlip", PackSlipNo));
                    if (ds.Tables.Count > 1)
                    {
                        dsSys = SqlHelper.ExecuteDataset(ERPconnectionString, "pUTGetSysMaster");
                        dtSys = dsSys.Tables[0];
                        // ds[1] = header, [2] = lines, [3]=footer, [4]=error
                        PageFooterHeight = 0.115M;
                        DocFooterHeight = 1.30M;
                        //DocFooterHeight = 1.515M;
                        PageBottom = (DocHeight * PageNo) - (PageFooterHeight + 0.2M);
                        dtHdr = ds.Tables[0];
                        if (ds.Tables.Count > 1) dtLines = ds.Tables[1];
                        if (ds.Tables.Count > 2) dtFooter = ds.Tables[2];
                        // make the report
                        PrintedHeight = 0.05M;
                        MainReport.Rows.Add(MakeHeader("docTitle"));
                        //MainReport.Rows.Add(BlankLine());
                        MainReport.Rows.Add(MakeDocHeader());
                        MainReport.Rows.Add(MakeDetHeader());
                        foreach (DataRow dr in dtLines.Rows)
                        {
                            if ((PrintedHeight > PageBottom) || ((dtLines.Rows.Count - rowCtr < 3) && ((PrintedHeight + DocFooterHeight > PageBottom))))
                            {
                                // start a new page + 1
                                for (decimal l = PrintedHeight; l < PageBottom; l += 0.1M)
                                {
                                    MainReport.Rows.Add(TenthBlankLine("o"));
                                }
                                MainReport.Rows.Add(MakePageFooter());
                                PrintedHeight = (DocHeight * PageNo) + 0.05M;
                                //PrintedHeight = (DocHeight * PageNo) + 1.05M;
                                PageNo++;
                                MainReport.Rows.Add(MakeHeader("docTitle newPage"));
                                MainReport.Rows.Add(MakeDetHeader());
                                PageBottom = (DocHeight * PageNo) - (PageFooterHeight + 0.2M);
                            }
                            MainReport.Rows.Add(MakeDetailLine(dr));
                            //PickPieces += (decimal)dr["QtyOrdered"] * (decimal)dr["SellStkQty"];
                            //PickCtns += (decimal)dr["QtyOrdered"];
                            //PickWeight += (decimal)dr["ExtendedGrossWght"];
                            rowCtr++;
                        }
                        // end of document
                        PageBottom = (DocHeight * PageNo) - (PageFooterHeight + DocFooterHeight);
                        if (PrintedHeight > PageBottom)
                        {
                            for (decimal l = PrintedHeight; l < ((DocHeight * PageNo) - PageFooterHeight); l += 0.1M)
                            {
                                MainReport.Rows.Add(TenthBlankLine("b"));
                            }
                            MainReport.Rows.Add(MakePageFooter());
                            PrintedHeight = (DocHeight * PageNo) + 0.05M;
                            PageNo++;
                            MainReport.Rows.Add(MakeHeader("docTitle newPage"));
                            MainReport.Rows.Add(MakeDetHeader());
                            PageBottom = (DocHeight * PageNo) - (PageFooterHeight + DocFooterHeight);
                        }
                        // finish up the doc
                        for (decimal l = PrintedHeight; l < PageBottom; l += 0.1M)
                        {
                            MainReport.Rows.Add(TenthBlankLine("f"));
                        }
                        MainReport.Rows.Add(MakeFooter());
                        MainReport.Rows.Add(MakePageFooter());
                        TotPageHidden.Value = PageNo.ToString();
                    }
                    else
                        lblErrorMessage.Text = "Nothing in Radio Beacon for Pack Slip number " + PackSlipNo;
                }
                catch (Exception e3)
                {
                    lblErrorMessage.Text = "pFormPackSlip Error " + e3.Message + ", " + e3.ToString();
                }
            }
            else
                lblErrorMessage.Text = "Nothing in URL for OrderNo.";
        }
    }

    TableRow MakeHeader(string TitleCss)
    {
        //Build a new header
        TableRow th1 = new TableRow();
        TableCell HdrCell = new TableCell();
        Table NewHeader = new Table();
        NewHeader.ID = "NewHeader" + PageNo.ToString();
        NewHeader.Width = Unit.Percentage(98);
        NewHeader.CellSpacing = 0;
        NewHeader.CellPadding = 0;
        NewHeader.CssClass = "pageHeader";
        NewHeader.Style.Add("top", FormatData(Num2Format, PrintedHeight).Trim() + "in");

        TableRow NewHeaderRow1 = new TableRow();
        NewHeaderRow1.VerticalAlign = VerticalAlign.Top;
        // logo
        TableCell NewHeaderRow1Cell1 = new TableCell();
        NewHeaderRow1Cell1.CssClass = TitleCss;
        Image Logo = new Image();
        //Logo.ImageUrl = ConfigurationManager.AppSettings["SOESiteURL"].ToString() + "Common/images/Gray200.gif";
        Logo.ImageUrl = dtHdr.Rows[0]["LogoLocation"].ToString() + dtHdr.Rows[0]["LogoName"].ToString();
        NewHeaderRow1Cell1.Controls.Add(Logo);
        NewHeaderRow1Cell1.HorizontalAlign = HorizontalAlign.Center;
        NewHeaderRow1Cell1.VerticalAlign = VerticalAlign.Top;
        NewHeaderRow1Cell1.Width = Unit.Percentage(15);
        NewHeaderRow1Cell1.RowSpan = 4;
        NewHeaderRow1.Cells.Add(NewHeaderRow1Cell1);
        // loc name
        TableCell NewHeaderRow1Cell2 = new TableCell();
        NewHeaderRow1Cell2.CssClass = "locName";
        if ((bool)dtHdr.Rows[0]["LogoOverride"])
        {
            NewHeaderRow1Cell2.Text = dtHdr.Rows[0]["Bill_Name"].ToString();
        }
        else
        {
            NewHeaderRow1Cell2.Text = dtHdr.Rows[0]["Shpr_Name"].ToString();
        }
        NewHeaderRow1Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewHeaderRow1Cell2.Width = Unit.Percentage(40);
        NewHeaderRow1.Cells.Add(NewHeaderRow1Cell2);
        // order
        TableCell NewHeaderRow1Cell3 = new TableCell();
        NewHeaderRow1Cell3.CssClass = "docTitle";
        NewHeaderRow1Cell3.Text = "PACKING LIST";
        NewHeaderRow1Cell3.HorizontalAlign = HorizontalAlign.Center;
        NewHeaderRow1Cell3.ColumnSpan = 2;
        NewHeaderRow1Cell3.Width = Unit.Percentage(35);
        NewHeaderRow1.Cells.Add(NewHeaderRow1Cell3);
        NewHeader.Rows.Add(NewHeaderRow1);
        TableRow NewHeaderRow2 = new TableRow();
        TableCell NewHeaderRow2Cell1 = new TableCell();
        NewHeaderRow2Cell1.CssClass = "locAddr";
        NewHeaderRow2Cell1.Text = "";
        if ((bool)dtHdr.Rows[0]["LogoOverride"])
        {

            if (dtHdr.Rows[0]["Bill_Add1"].ToString().Trim().Length != 0)
            {
                NewHeaderRow2Cell1.Text += dtHdr.Rows[0]["Bill_Add1"].ToString() + "<br>";
            }
            if (dtHdr.Rows[0]["Bill_Add2"].ToString().Trim().Length != 0)
            {
                NewHeaderRow2Cell1.Text += dtHdr.Rows[0]["Bill_Add2"].ToString() + "<br>";
            }
            NewHeaderRow2Cell1.Text += dtHdr.Rows[0]["Bill_City"].ToString() + ", " +
                dtHdr.Rows[0]["Bill_Prov"].ToString() + ". " +
                dtHdr.Rows[0]["Bill_Zip"].ToString();
        }
        else
        {
            if (dtHdr.Rows[0]["Shpr_Add1"].ToString().Trim().Length != 0)
            {
                NewHeaderRow2Cell1.Text += dtHdr.Rows[0]["Shpr_Add1"].ToString() + "<br>";
            }
            if (dtHdr.Rows[0]["Shpr_Add2"].ToString().Trim().Length != 0)
            {
                NewHeaderRow2Cell1.Text += dtHdr.Rows[0]["Shpr_Add2"].ToString() + "<br>";
            }
            NewHeaderRow2Cell1.Text += dtHdr.Rows[0]["CityStZip"].ToString();
        }
        NewHeaderRow2Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewHeaderRow2Cell1.VerticalAlign = VerticalAlign.Top;
        NewHeaderRow2Cell1.RowSpan = 2;
        NewHeaderRow2.Cells.Add(NewHeaderRow2Cell1);
        TableCell NewHeaderRow2Cell2 = new TableCell();
        NewHeaderRow2Cell2.CssClass = "bold largetext rightPad";
        NewHeaderRow2Cell2.Text = " <span class=docTitle>Packing Number</span>";
        NewHeaderRow2Cell2.HorizontalAlign = HorizontalAlign.Right;
        NewHeaderRow2.Cells.Add(NewHeaderRow2Cell2);
        TableCell NewHeaderRow2Cell3 = new TableCell();
        NewHeaderRow2Cell3.CssClass = "bold largetext leftPad";
        NewHeaderRow2Cell3.Text = "<span class=docTitle>" + dtHdr.Rows[0]["PackSlip"].ToString() + "</span>";
        NewHeaderRow2Cell3.HorizontalAlign = HorizontalAlign.Left;
        NewHeaderRow2.Cells.Add(NewHeaderRow2Cell3);
        NewHeader.Rows.Add(NewHeaderRow2);
        TableRow NewHeaderRow3 = new TableRow();
        TableCell NewHeaderRow3Cell2 = new TableCell();
        NewHeaderRow3Cell2.CssClass = "bold largetext rightPad";
        NewHeaderRow3Cell2.Text = "Order Request Date"; 
        NewHeaderRow3Cell2.HorizontalAlign = HorizontalAlign.Right;
        NewHeaderRow3.Cells.Add(NewHeaderRow3Cell2);
        TableCell NewHeaderRow3Cell3 = new TableCell();
        NewHeaderRow3Cell3.CssClass = "bold largetext leftPad";
        NewHeaderRow3Cell3.Text = FormatData(LongDateFormat, dtHdr.Rows[0]["Date_Reqd"]);
        NewHeaderRow3Cell3.HorizontalAlign = HorizontalAlign.Left;
        NewHeaderRow3.Cells.Add(NewHeaderRow3Cell3);
        NewHeader.Rows.Add(NewHeaderRow3);
        
        TableRow NewHeaderRow5 = new TableRow();
        NewHeaderRow5.Style.Add("height", "0.1in");
        TableCell NewHeaderRow5Cell1 = new TableCell();
        NewHeaderRow5Cell1.VerticalAlign = VerticalAlign.Top;
        //NewHeaderRow5Cell1.Text = "&nbsp;";
        NewHeaderRow5Cell1.CssClass = "fatLine";
        NewHeaderRow5Cell1.ColumnSpan = 3;
        NewHeaderRow5.Cells.Add(NewHeaderRow5Cell1);
        NewHeader.Rows.Add(NewHeaderRow5);
        TableRow NewHeaderRow6 = new TableRow();
        NewHeaderRow6.Style.Add("height", "0.1in");
        TableCell NewHeaderRow6Cell1 = new TableCell();
        NewHeaderRow6Cell1.VerticalAlign = VerticalAlign.Top;
        NewHeaderRow6Cell1.CssClass = "microtext";
        NewHeaderRow6Cell1.Text = "&nbsp;";
        NewHeaderRow6Cell1.ColumnSpan = 4;
        NewHeaderRow6Cell1.Style.Add("height", "0.1in");
        NewHeaderRow6.Cells.Add(NewHeaderRow6Cell1);
        NewHeader.Rows.Add(NewHeaderRow6);
        /**/
        HdrCell.Controls.Add(NewHeader);
        HdrCell.ID = "XHeader" + PageNo.ToString();
        th1.Cells.Add(HdrCell);
        PrintedHeight += 0.7M;
        return th1;
    }

    TableRow MakeDocHeader()
    {
        //Build the document data header
        TableRow th2 = new TableRow();
        TableCell HdrDocCell = new TableCell();
        if (dtSys.Rows[0]["PrintRqst"].ToString().Trim() == "T")
        {
            HdrDocCell.CssClass = "pageHeader watermark";
            HdrDocCell.Attributes.Add("style",
                 "background-image:url(" + ConfigurationManager.AppSettings["SOESiteURL"].ToString() + "Common/Images/TestWatermark.gif);");
        }
        Table NewDocHeader = new Table();
        NewDocHeader.ID = "NewDocHeader" + PageNo.ToString();
        NewDocHeader.Width = Unit.Percentage(98);
        NewDocHeader.CellSpacing = 1;
        NewDocHeader.CellPadding = 0;
        NewDocHeader.CssClass = "pageHeader";
        NewDocHeader.Style.Add("top", FormatData(Num2Format, PrintedHeight).Trim() + "in");
        /**/
        Table NewDocHead2 = new Table();
        NewDocHead2.ID = "NewDocHead2" + PageNo.ToString();
        NewDocHead2.Width = Unit.Percentage(98);
        NewDocHead2.CellSpacing = 1;
        NewDocHead2.CellPadding = 0;
        NewDocHead2.CssClass = "pageHeader";
        NewDocHead2.Style.Add("top", FormatData(Num2Format, PrintedHeight).Trim() + "in");
        // Bill To, Sell To, Ship To 
        TableRow NewDocHead2Row1 = new TableRow();
        NewDocHead2Row1.VerticalAlign = VerticalAlign.Bottom;
        TableCell NewDocHead2Row1Cell1 = new TableCell();
        NewDocHead2Row1Cell1.Text = " ";
        NewDocHead2Row1Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewDocHead2Row1Cell1.Width = Unit.Percentage(8);
        NewDocHead2Row1.Cells.Add(NewDocHead2Row1Cell1);
        TableCell NewDocHead2Row1Cell2 = new TableCell();
        if (!(bool)dtHdr.Rows[0]["LogoOverride"])
        {
            NewDocHead2Row1Cell2.Text = "<span class='billNamePad'>Bill To:</span><span class='bold billNamePad'> " + dtHdr.Rows[0]["Bill_Name"].ToString() + "</span><br>";
            if (dtHdr.Rows[0]["Bill_Add1"].ToString().Trim().Length != 0)
            {
                NewDocHead2Row1Cell2.Text += dtHdr.Rows[0]["Bill_Add1"].ToString() + "<br>";
            }
            if (dtHdr.Rows[0]["Bill_Add2"].ToString().Trim().Length != 0)
            {
                NewDocHead2Row1Cell2.Text += dtHdr.Rows[0]["Bill_Add2"].ToString() + "<br>";
            }
            NewDocHead2Row1Cell2.Text += dtHdr.Rows[0]["Bill_City"].ToString() + ", " +
                dtHdr.Rows[0]["Bill_Prov"].ToString() + ". " +
                dtHdr.Rows[0]["Bill_Zip"].ToString() + "<br>";
        }
        //NewDocHead2Row1Cell2.Text += dtHdr.Rows[0]["BillToCountry"].ToString();
        NewDocHead2Row1Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewDocHead2Row1Cell2.VerticalAlign = VerticalAlign.Top;
        NewDocHead2Row1Cell2.Width = Unit.Percentage(44);
        NewDocHead2Row1.Cells.Add(NewDocHead2Row1Cell2);
        TableCell NewDocHead2Row1Cell4 = new TableCell();
        NewDocHead2Row1Cell4.Text = "" + dtHdr.Rows[0]["Cust_Num"].ToString() + "<br>";
        NewDocHead2Row1Cell4.Text += "<span class='shipNamePad'>Ship To:</span><span class='bold shipNamePad'> " + dtHdr.Rows[0]["Ship_Name"].ToString() + "</span><br>";
        if (dtHdr.Rows[0]["Ship_Add1"].ToString().Trim().Length != 0)
        {
            NewDocHead2Row1Cell4.Text += dtHdr.Rows[0]["Ship_Add1"].ToString() + "<br>";
        }
        if (dtHdr.Rows[0]["Ship_Add2"].ToString().Trim().Length != 0)
        {
            NewDocHead2Row1Cell4.Text += dtHdr.Rows[0]["Ship_Add2"].ToString() + "<br>";
        }
        NewDocHead2Row1Cell4.Text += dtHdr.Rows[0]["Ship_City"].ToString() + ", " +
            dtHdr.Rows[0]["Ship_Prov"].ToString() + ". " +
            dtHdr.Rows[0]["Ship_Zip"].ToString() + "<br>";
        NewDocHead2Row1Cell4.Text += dtHdr.Rows[0]["Ship_Cntry"].ToString() + "<br>";
        NewDocHead2Row1Cell4.Text += "Ship Via: <span class=bold> " + dtHdr.Rows[0]["Ship_Via"].ToString() + "</span>";
        NewDocHead2Row1Cell4.HorizontalAlign = HorizontalAlign.Left;
        NewDocHead2Row1Cell4.VerticalAlign = VerticalAlign.Top;
        NewDocHead2Row1Cell4.Width = Unit.Percentage(30);
        NewDocHead2Row1.Cells.Add(NewDocHead2Row1Cell4);

        TableCell NewDocHead2Row1Cell5 = new TableCell();        
        //NewDocHead2Row1Cell5.CssClass = "barcode";
        //NewDocHead2Row1Cell5.Text = dtHdr.Rows[0]["PackSlip"].ToString();
        NewDocHead2Row1Cell5.HorizontalAlign = HorizontalAlign.Center;
        NewDocHead2Row1Cell5.VerticalAlign = VerticalAlign.Top;

        // To set the width & height for barcode, we are calling this barcode.aspx page -- sdded by sathish
        Image imgBarCode = new Image();
        imgBarCode.ImageUrl = "Barcode.aspx?Code=" + dtHdr.Rows[0]["PackSlip"].ToString();
        NewDocHead2Row1Cell5.Controls.Add(imgBarCode);
        NewDocHead2Row1.Cells.Add(NewDocHead2Row1Cell5);        

        NewDocHead2.Rows.Add(NewDocHead2Row1);
        HdrDocCell.Controls.Add(NewDocHead2);
        //
        Table NewDocHead3 = new Table();
        NewDocHead3.ID = "NewDocHead3" + PageNo.ToString();
        NewDocHead3.Width = Unit.Percentage(98);
        NewDocHead3.CellSpacing = 1;
        NewDocHead3.CellPadding = 0;
        NewDocHead3.CssClass = "pageHeader";
        NewDocHead3.Style.Add("top", FormatData(Num2Format, PrintedHeight).Trim() + "in");
        //
        TableRow NewDocHead3Row4 = new TableRow();
        TableCell NewDocHead3Row4Cell1 = new TableCell();
        NewDocHead3Row4Cell1.CssClass = "topComment";
        NewDocHead3Row4Cell1.Text = dtHdr.Rows[0]["HdrComments"].ToString();
        NewDocHead3Row4Cell1.Width = Unit.Percentage(55);
        NewDocHead3Row4Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewDocHead3Row4Cell1.ColumnSpan = 2;
        NewDocHead3Row4.Cells.Add(NewDocHead3Row4Cell1);
        NewDocHead3.Rows.Add(NewDocHead3Row4);
        // CIA or COD
        //if ((dtHdr.Rows[0]["OrderTermsCd"].ToString().Trim() == "01") || (dtHdr.Rows[0]["OrderTermsCd"].ToString().Trim() == "98"))
        //{
        //    TableRow NewDocHead3Row5 = new TableRow();
        //    TableCell NewDocHead3Row5Cell1 = new TableCell();
        //    NewDocHead3Row5Cell1.CssClass = "big24text";
        //    NewDocHead3Row5Cell1.Text = "!!! Collect On Delivery or Cash In Advance !!!";
        //    NewDocHead3Row5Cell1.HorizontalAlign = HorizontalAlign.Center;
        //    NewDocHead3Row5Cell1.ColumnSpan = 4;
        //    NewDocHead3Row5.Cells.Add(NewDocHead3Row5Cell1);
        //    NewDocHead3.Rows.Add(NewDocHead3Row5);
        //    TableRow NewDocHead3Row6 = new TableRow();
        //    TableCell NewDocHead3Row6Cell1 = new TableCell();
        //    NewDocHead3Row6Cell1.CssClass = "big14text";
        //    NewDocHead3Row6Cell1.Text = "The Invoice for the SO number above must be with this document. The customer must pay for the product in the amount on the Invoice. The check for the invoice amount must be exchanged for the shipment when it is picked up or delivered.";
        //    NewDocHead3Row6Cell1.HorizontalAlign = HorizontalAlign.Center;
        //    NewDocHead3Row6Cell1.ColumnSpan = 4;
        //    NewDocHead3Row6.Cells.Add(NewDocHead3Row6Cell1);
        //    NewDocHead3.Rows.Add(NewDocHead3Row6);
        //}
        //
        HdrDocCell.Controls.Add(NewDocHead3);
        PrintedHeight += 1.5M;
        /**/
        HdrDocCell.ID = "XHeaderDoc" + PageNo.ToString();
        th2.Cells.Add(HdrDocCell);
        return th2;
    }

    TableRow MakeDetHeader()
    {
        //Build the document detail header
        TableRow th3 = new TableRow();
        TableCell HdrDtlCell = new TableCell();
        Table NewDtlHeader = new Table();
        NewDtlHeader.ID = "NewDtlHeader" + PageNo.ToString();
        NewDtlHeader.Width = Unit.Percentage(98);
        NewDtlHeader.CellSpacing = 0;
        NewDtlHeader.CellPadding = 0;
        NewDtlHeader.CssClass = "pageHeader";
        NewDtlHeader.Style.Add("top", FormatData(Num2Format, PrintedHeight).Trim() + "in");
        // build the lines
        TableRow NewDtlHeaderRow1 = new TableRow();
        NewDtlHeaderRow1.VerticalAlign = VerticalAlign.Top;
        TableCell NewDtlHeaderRow1Cell1 = new TableCell();
        NewDtlHeaderRow1Cell1.CssClass = "topLine newLine rightCol leftPad leftCol";
        NewDtlHeaderRow1Cell1.Text = "PO No.";
        NewDtlHeaderRow1Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewDtlHeaderRow1Cell1.Width = Unit.Percentage(DetColWid[0]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell1);
        TableCell NewDtlHeaderRow1Cell2 = new TableCell();
        NewDtlHeaderRow1Cell2.CssClass = "topLine newLine rightCol leftPad";
        NewDtlHeaderRow1Cell2.Text = "Item No.";
        NewDtlHeaderRow1Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewDtlHeaderRow1Cell2.Width = Unit.Percentage(DetColWid[1]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell2);
        TableCell NewDtlHeaderRow1Cell2a = new TableCell();
        NewDtlHeaderRow1Cell2a.CssClass = "topLine newLine rightCol";
        NewDtlHeaderRow1Cell2a.Text = "UOM";
        NewDtlHeaderRow1Cell2a.HorizontalAlign = HorizontalAlign.Center;
        NewDtlHeaderRow1Cell2a.Width = Unit.Percentage(DetColWid[2]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell2a);
        TableCell NewDtlHeaderRow1Cell3 = new TableCell();
        NewDtlHeaderRow1Cell3.CssClass = "topLine newLine rightCol rightPad";
        NewDtlHeaderRow1Cell3.Text = "Picked";
        NewDtlHeaderRow1Cell3.HorizontalAlign = HorizontalAlign.Right;
        NewDtlHeaderRow1Cell3.Width = Unit.Percentage(DetColWid[3]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell3);
        TableCell NewDtlHeaderRow1Cell4 = new TableCell();
        NewDtlHeaderRow1Cell4.CssClass = "topLine newLine rightCol rightPad";
        NewDtlHeaderRow1Cell4.Text = "Ordered";
        NewDtlHeaderRow1Cell4.HorizontalAlign = HorizontalAlign.Right;
        NewDtlHeaderRow1Cell4.Width = Unit.Percentage(DetColWid[4]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell4);
        TableCell NewDtlHeaderRow1Cell5 = new TableCell();
        NewDtlHeaderRow1Cell5.CssClass = "topLine newLine rightCol rightPad";
        NewDtlHeaderRow1Cell5.Text = "BackOrd";
        NewDtlHeaderRow1Cell5.HorizontalAlign = HorizontalAlign.Right;
        NewDtlHeaderRow1Cell5.Width = Unit.Percentage(DetColWid[5]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell5);
        TableCell NewDtlHeaderRow1Cell6 = new TableCell();
        NewDtlHeaderRow1Cell6.CssClass = "topLine newLine rightCol";
        NewDtlHeaderRow1Cell6.Text = "Description";
        NewDtlHeaderRow1Cell6.HorizontalAlign = HorizontalAlign.Center;
        NewDtlHeaderRow1Cell6.Width = Unit.Percentage(DetColWid[6]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell6);
        TableCell NewDtlHeaderRow1Cell7 = new TableCell();
        NewDtlHeaderRow1Cell7.CssClass = "topLine newLine rightCol rightPad";
        NewDtlHeaderRow1Cell7.Text = "Weight/Line";
        NewDtlHeaderRow1Cell7.HorizontalAlign = HorizontalAlign.Right;
        NewDtlHeaderRow1Cell7.Width = Unit.Percentage(DetColWid[7]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell7);
        NewDtlHeader.Rows.Add(NewDtlHeaderRow1);
        /**/
        HdrDtlCell.Controls.Add(NewDtlHeader);
        PrintedHeight += 0.23M;
        HdrDtlCell.ID = "XHeaderDtl" + PageNo.ToString();
        th3.Cells.Add(HdrDtlCell);
        return th3;
    }

    TableRow MakeDetailLine(DataRow DetRow)
    {
        //Build the document detail line
        TableRow td1 = new TableRow();
        TableCell DetailCell = new TableCell();
        Table NewDetail = new Table();
        NewDetail.ID = "NewDetail" + PageNo.ToString() + "R" + rowCtr.ToString();
        NewDetail.Width = Unit.Percentage(98);
        NewDetail.CellSpacing = 0;
        NewDetail.CellPadding = 0;
        NewDetail.CssClass = "pageHeader";
        NewDetail.Style.Add("top", FormatData(Num2Format, PrintedHeight).Trim() + "in");
        // build the lines
        TableRow NewDetailRow1 = new TableRow();
        NewDetailRow1.VerticalAlign = VerticalAlign.Top;
        TableCell NewDetailRow1Cell1 = new TableCell();
        NewDetailRow1Cell1.CssClass = "rightCol newLine leftPad";
        NewDetailRow1Cell1.Text = dtHdr.Rows[0]["Cust_PO"].ToString();
        NewDetailRow1Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewDetailRow1Cell1.VerticalAlign = VerticalAlign.Top;
        NewDetailRow1Cell1.RowSpan = 2;
        NewDetailRow1Cell1.Width = Unit.Percentage(DetColWid[0]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell1);
        TableCell NewDetailRow1Cell2 = new TableCell();
        NewDetailRow1Cell2.CssClass = "rightCol leftPad";
        NewDetailRow1Cell2.Text = DetRow["Product"].ToString();
        NewDetailRow1Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewDetailRow1Cell2.Width = Unit.Percentage(DetColWid[1]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell2);
        TableCell NewDetailRow1Cell2a = new TableCell();
        NewDetailRow1Cell2a.CssClass = "newLine rightCol";
        NewDetailRow1Cell2a.Text = DetRow["UOM"].ToString();
        NewDetailRow1Cell2a.HorizontalAlign = HorizontalAlign.Center;
        NewDetailRow1Cell2a.Width = Unit.Percentage(DetColWid[2]);
        NewDetailRow1Cell2a.RowSpan = 2;
        NewDetailRow1.Cells.Add(NewDetailRow1Cell2a);
        TableCell NewDetailRow1Cell3 = new TableCell();
        NewDetailRow1Cell3.CssClass = "rightCol";
        NewDetailRow1Cell3.Text = FormatData(Num0Format, DetRow["Qty_Picked"]);
        NewDetailRow1Cell3.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell3.Width = Unit.Percentage(DetColWid[3]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell3);
        TableCell NewDetailRow1Cell4 = new TableCell();
        NewDetailRow1Cell4.CssClass = "rightCol newLine";
        NewDetailRow1Cell4.Text = FormatData(Num0Format, DetRow["Qty_Orignl"]);
        NewDetailRow1Cell4.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell4.RowSpan = 2;
        NewDetailRow1Cell4.Width = Unit.Percentage(DetColWid[4]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell4);
        TableCell NewDetailRow1Cell5 = new TableCell();
        NewDetailRow1Cell5.CssClass = "rightCol newLine";
        NewDetailRow1Cell5.Text = FormatData(Num0Format, DetRow["QtyBO"]);
        NewDetailRow1Cell5.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell5.Width = Unit.Percentage(DetColWid[5]);
        NewDetailRow1Cell5.RowSpan = 2;
        NewDetailRow1.Cells.Add(NewDetailRow1Cell5);
        TableCell NewDetailRow1Cell6 = new TableCell();
        NewDetailRow1Cell6.CssClass = "rightCol leftPad newLine";
        NewDetailRow1Cell6.Text = DetRow["Descript"].ToString();
        NewDetailRow1Cell6.HorizontalAlign = HorizontalAlign.Left;
        NewDetailRow1Cell6.Width = Unit.Percentage(DetColWid[6]);
        NewDetailRow1Cell6.RowSpan = 2;
        NewDetailRow1.Cells.Add(NewDetailRow1Cell6);
        TableCell NewDetailRow1Cell7 = new TableCell();
        NewDetailRow1Cell7.Text = FormatData(Num2Format, DetRow["ExtLbs"]);
        NewDetailRow1Cell7.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell7.Width = Unit.Percentage(DetColWid[7]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell7);
        NewDetail.Rows.Add(NewDetailRow1);
        // detail line 2
        TableRow NewDetailRow2 = new TableRow();
        NewDetailRow2.VerticalAlign = VerticalAlign.Top;
        TableCell NewDetailRow2Cell2 = new TableCell();
        NewDetailRow2Cell2.CssClass = "rightCol newLine leftPad";
        NewDetailRow2Cell2.Text = DetRow["Cust_Xref"].ToString();
        NewDetailRow2Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewDetailRow2.Cells.Add(NewDetailRow2Cell2);
        TableCell NewDetailRow2Cell4 = new TableCell();
        NewDetailRow2Cell4.CssClass = "rightCol newLine";
        NewDetailRow2Cell4.Text = FormatData(Num0Format, DetRow["ExtPcs"]);
        NewDetailRow2Cell4.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow2Cell4.Width = Unit.Percentage(DetColWid[3]);
        NewDetailRow2.Cells.Add(NewDetailRow2Cell4);
        TableCell NewDetailRow2Cell7 = new TableCell();
        NewDetailRow2Cell7.CssClass = "newLine";
        NewDetailRow2Cell7.Text = "Line:" + FormatData(Num0Format, DetRow["LineNumber"]);
        NewDetailRow2Cell7.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow2Cell7.Width = Unit.Percentage(DetColWid[7]);
        NewDetailRow2.Cells.Add(NewDetailRow2Cell7);
        NewDetail.Rows.Add(NewDetailRow2);
        PrintedHeight += 0.346M;
        // detail comment line (if needed)
        if (DetRow["DtlComments"].ToString() != "")
        {
            TableRow NewDetailRow3 = new TableRow();
            NewDetailRow3.VerticalAlign = VerticalAlign.Top;
            TableCell NewDetailRow3Cell1 = new TableCell();
            NewDetailRow3Cell1.CssClass = "leftPad newLine";
            NewDetailRow3Cell1.Text = DetRow["DtlComments"].ToString();
            NewDetailRow3Cell1.HorizontalAlign = HorizontalAlign.Left;
            NewDetailRow3Cell1.ColumnSpan = 8;
            NewDetailRow3.Cells.Add(NewDetailRow3Cell1);
            NewDetail.Rows.Add(NewDetailRow3);
            PrintedHeight += 0.175M;
        }
        // cert data line (if needed)
        if (DetRow["Extra2"].ToString() != "")
        {
            TableRow NewDetailRow4 = new TableRow();
            NewDetailRow4.VerticalAlign = VerticalAlign.Top;
            TableCell NewDetailRow4Cell1 = new TableCell();
            NewDetailRow4Cell1.CssClass = "leftPad newLine";
            NewDetailRow4Cell1.Text = DetRow["Extra2"].ToString();
            NewDetailRow4Cell1.HorizontalAlign = HorizontalAlign.Left;
            NewDetailRow4Cell1.ColumnSpan = 8;
            NewDetailRow4.Cells.Add(NewDetailRow4Cell1);
            NewDetail.Rows.Add(NewDetailRow4);
            PrintedHeight += 0.175M;
        }
        /**/
        DetailCell.Controls.Add(NewDetail);
        DetailCell.ID = "XDetail" + PageNo.ToString() + "R" + rowCtr.ToString();
        td1.Cells.Add(DetailCell);
        return td1;
    }

    TableRow MakeFooter()
    {
        //Build the document footer
        TableRow tf1 = new TableRow();
        TableCell FooterCell = new TableCell();
        Table NewFooter = new Table();
        NewFooter.ID = "NewFooter" + PageNo.ToString();
        NewFooter.Width = Unit.Percentage(98);
        NewFooter.CellSpacing = 0;
        NewFooter.CellPadding = 0;
        NewFooter.CssClass = "docFooter";
        NewFooter.Style.Add("top", FormatData(Num2Format, (DocHeight * PageNo) - DocFooterHeight).Trim() + "in");
        // build the footer
        TableRow NewFooterRow1 = new TableRow();
        NewFooterRow1.VerticalAlign = VerticalAlign.Top;
        TableCell NewFooterRow1Cell1 = new TableCell();
        NewFooterRow1Cell1.CssClass = "topLine fatLine largetext";
        NewFooterRow1Cell1.Text = "Line Count: " + FormatData(Num0Format, dtLines.Rows.Count);
        NewFooterRow1Cell1.HorizontalAlign = HorizontalAlign.Right;
        NewFooterRow1Cell1.Width = Unit.Percentage(25);
        NewFooterRow1.Cells.Add(NewFooterRow1Cell1);
        TableCell NewFooterRow1Cell2 = new TableCell();
        NewFooterRow1Cell2.CssClass = "topLine fatLine medtext rightPad";
        NewFooterRow1Cell2.Text = "&nbsp;Pick PCS:";
        NewFooterRow1Cell2.HorizontalAlign = HorizontalAlign.Right;
        NewFooterRow1Cell2.Width = Unit.Percentage(15);
        NewFooterRow1.Cells.Add(NewFooterRow1Cell2);
        TableCell NewFooterRow1Cell3 = new TableCell();
        NewFooterRow1Cell3.CssClass = "topLine fatLine largetext";
        NewFooterRow1Cell3.Text = FormatData(Num0Format, dtFooter.Rows[0]["TotalPcs"]);
        NewFooterRow1Cell3.HorizontalAlign = HorizontalAlign.Left;
        NewFooterRow1Cell3.Width = Unit.Percentage(10);
        NewFooterRow1.Cells.Add(NewFooterRow1Cell3);
        TableCell NewFooterRow1Cell4 = new TableCell();
        NewFooterRow1Cell4.CssClass = "topLine fatLine medtext rightPad";
        NewFooterRow1Cell4.Text = "&nbsp;Pick Qty:";
        NewFooterRow1Cell4.HorizontalAlign = HorizontalAlign.Right;
        NewFooterRow1Cell4.Width = Unit.Percentage(15);
        NewFooterRow1.Cells.Add(NewFooterRow1Cell4);
        TableCell NewFooterRow1Cell5 = new TableCell();
        NewFooterRow1Cell5.CssClass = "topLine fatLine largetext";
        NewFooterRow1Cell5.Text = FormatData(Num0Format, dtFooter.Rows[0]["TotalPickQty"]);
        NewFooterRow1Cell5.HorizontalAlign = HorizontalAlign.Left;
        NewFooterRow1Cell5.Width = Unit.Percentage(10);
        NewFooterRow1.Cells.Add(NewFooterRow1Cell5);
        TableCell NewFooterRow1Cell7 = new TableCell();
        NewFooterRow1Cell7.CssClass = "topLine fatLine medtext rightPad";
        NewFooterRow1Cell7.Text = "Total Weight (LBS):";
        NewFooterRow1Cell7.HorizontalAlign = HorizontalAlign.Right;
        NewFooterRow1Cell7.Width = Unit.Percentage(15);
        NewFooterRow1.Cells.Add(NewFooterRow1Cell7);
        TableCell NewFooterRow1Cell8 = new TableCell();
        NewFooterRow1Cell8.CssClass = "topLine fatLine largetext";
        NewFooterRow1Cell8.Text = FormatData(Num2Format, dtFooter.Rows[0]["TotalWgt"]);
        NewFooterRow1Cell8.HorizontalAlign = HorizontalAlign.Left;
        NewFooterRow1Cell8.Width = Unit.Percentage(10);
        NewFooterRow1.Cells.Add(NewFooterRow1Cell8);
        NewFooter.Rows.Add(NewFooterRow1);
        // Disclamer
        TableRow NewFooterRow3 = new TableRow();
        NewFooterRow3.Style.Add("height", "0.65in");
        NewFooterRow3.VerticalAlign = VerticalAlign.Bottom;
        TableCell NewFooterRow3Cell1 = new TableCell();
        NewFooterRow3Cell1.CssClass = "microtext fatLine";
        NewFooterRow3Cell1.Text = "Porteous warrants the goods sold hereby are free from defects in workmanship and material in the event any of these goods prove to be defective in workmanship or  material within a period of six (6) months from purchase, Porteous will replace same without cost to buyer.  Except as herein stated, Porteous shall not be liable for any damages or for any breach of any warranty, express or implied, or for any other obligation or liability on account of the goods.  As part of the consideration for Porteous's  sale of these goods, buyer agrees that the respective rights and liabilities of the parties shall be determined in accordance with the laws of the State of California and that any action or proceeding arising directly or indirectly from this sale shall be litigated within the County of Los Angeles, State of California.  Buyer consents to the jurisdiction of any local, state or federal court located within Los Angeles County, California, waives personal service of any process upon buyer and consents that all such service may be made by certified mail, return receipt requested, directed to buyer.  These articles may be imported.  The requirements of 19 U.S.C. 1304 and 19 CFR part 134 provide that the articles of their containers must be marked in a conspicuous place as legibly, indelibly and permanently as the nature of the article or container will permit, in such a manner as to indicate to an ultimate purchaser in the United States, the english name of the country of origin of the article.";
        NewFooterRow3Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewFooterRow3Cell1.ColumnSpan = 8; 
        NewFooterRow3.Cells.Add(NewFooterRow3Cell1);
        NewFooter.Rows.Add(NewFooterRow3);
        /**/
        FooterCell.Controls.Add(NewFooter);
        FooterCell.ID = "XFooter" + PageNo.ToString();
        tf1.Cells.Add(FooterCell);
        return tf1;
    }

    TableRow MakePageFooter()
    {
        //Build the pager footer
        TableRow pf1 = new TableRow();
        TableCell pf1Cell1 = new TableCell();
        Table NewPageFooter = new Table();
        NewPageFooter.ID = "NewHeader" + PageNo.ToString();
        NewPageFooter.Width = Unit.Percentage(95);
        NewPageFooter.CellSpacing = 0;
        NewPageFooter.CellPadding = 0;
        NewPageFooter.CssClass = "pageFooter";
        NewPageFooter.Style.Add("top", FormatData(Num2Format, (DocHeight * PageNo) - PageFooterHeight).Trim() + "in");
        TableRow NewPageFooterRow1 = new TableRow();
        TableCell NewPageFooterRow1Cell1 = new TableCell();
        NewPageFooterRow1Cell1.Text = "Print: " + FormatData(LongDateTimeFormat, PrintDate);
        NewPageFooterRow1Cell1.Width = Unit.Percentage(30);
        NewPageFooterRow1Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewPageFooterRow1.Cells.Add(NewPageFooterRow1Cell1);
        TableCell NewPageFooterRow1Cell2 = new TableCell();
        NewPageFooterRow1Cell2.Text = dtFooter.Rows[0]["FooterMessage"].ToString();
        NewPageFooterRow1Cell2.Width = Unit.Percentage(40);
        NewPageFooterRow1Cell2.HorizontalAlign = HorizontalAlign.Center;
        NewPageFooterRow1.Cells.Add(NewPageFooterRow1Cell2);
        TableCell NewPageFooterRow1Cell3 = new TableCell();
        NewPageFooterRow1Cell3.Text = "Page " + FormatData(Num0Format, PageNo) + " of XX";
        NewPageFooterRow1Cell3.Width = Unit.Percentage(30);
        NewPageFooterRow1Cell3.HorizontalAlign = HorizontalAlign.Right;
        NewPageFooterRow1.Cells.Add(NewPageFooterRow1Cell3);
        NewPageFooter.Rows.Add(NewPageFooterRow1);
        pf1Cell1.Controls.Add(NewPageFooter);
        pf1Cell1.ID = "XPageFooter" + PageNo.ToString();
        pf1.Cells.Add(pf1Cell1);
        return pf1;
    }

    TableRow BlankLine()
    {
        //add a blank line
        TableRow bl1 = new TableRow();
        TableCell blCell = new TableCell();
        blCell.Text = "&nbsp;";
        /**/
        bl1.Cells.Add(blCell);
        return bl1;
    }

    TableRow TenthBlankLine(string CellText)
    {
        //add a row a tenth of a in tall
        TableRow bl1 = new TableRow();
        TableCell blCell = new TableCell();
        blCell.CssClass = "tenthLine microtext";
        blCell.Text = "&nbsp;";
        /* + CellText*/
        bl1.Cells.Add(blCell);
        return bl1;
    }

    protected string FormatData(string FormatString, object FieldVal)
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
