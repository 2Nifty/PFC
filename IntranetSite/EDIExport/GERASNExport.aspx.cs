using System;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;

public partial class GERASNExport : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCReportsConnectionString"].ToString();
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
    private string LongDateTimeFormat = "{0:dddd, MMM dd, yyyy h:mtt} ";
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    string UserName;
    string BOL = "";
    string EDIFile = "";
    string ASN = "";
    string ExceptionCode = "";
    decimal ASNTotal = 0;
    decimal BOLTotal = 0;
    //public Table MainReport = new Table();
    int pageRows = 44;
    int rowCtr = 0;
    int PageNo = 1;
    int[] DetColWid = { 6, 12, 16, 10, 8, 10, 8, 10, 14, 10 };

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["BOL"] != null)
        {
            BOL = Request.QueryString["BOL"].ToString().Trim();
            try
            {
                // get the report data."05""05POCU0564018"
                ds = SqlHelper.ExecuteDataset(connectionString, "pEDIGERASNExport",
                        new SqlParameter("@BOL", BOL));
                if (ds.Tables.Count >= 1)
                {
                    // make the report
                    dt = ds.Tables[0];
                    MainReport.Rows.Add(MakeHeader("headingc"));
                    TableRow MailDetailRow = new TableRow();
                    TableCell MailDetailCell = new TableCell();
                    Table Dtl = new Table();
                    Dtl.ID = "Dtl" + PageNo.ToString();
                    Dtl.Width = Unit.Percentage(100);
                    Dtl.CellSpacing = 0;
                    Dtl.CellPadding = 0;
                    dt = ds.Tables[1];
                    foreach (DataRow dr in dt.Rows)
                    {
                        if (EDIFile != dr["EDIFileName"].ToString().Trim())
                        {
                            Dtl.Rows.Add(MakeFileNameLine(dr));
                            EDIFile = dr["EDIFileName"].ToString().Trim();
                            rowCtr++;
                        }
                        if (ASN != dr["ASNID"].ToString().Trim() || ExceptionCode != dr["ExceptionCode"].ToString().Trim())
                        {
                            if (ASN != "")
                            {
                                Dtl.Rows.Add(MakeASNTotal());
                                ASNTotal = 0;
                                rowCtr++;
                            }
                            Dtl.Rows.Add(MakeASNLine(dr));
                            Dtl.Rows.Add(MakeDetHeader());
                            ASN = dr["ASNID"].ToString().Trim();
                            ExceptionCode = dr["ExceptionCode"].ToString().Trim();
                            rowCtr++;
                            rowCtr++;
                        }
                        rowCtr++;
                        ASNTotal += (decimal)dr["LineTotal"];
                        BOLTotal += (decimal)dr["LineTotal"];
                        Dtl.Rows.Add(MakeDetailLine(dr));
                    }
                    Dtl.Rows.Add(MakeASNTotal());
                    Dtl.Rows.Add(MakeBOLTotal());
                    MailDetailCell.Controls.Add(Dtl);
                    MailDetailRow.Cells.Add(MailDetailCell);
                    MainReport.Rows.Add(MailDetailRow);
                }
            }
            catch (Exception e3)
            {
                lblErrorMessage.Text = "pEDIGERASNExport Error " + e3.Message + ", " + e3.ToString();
            }
        }
    }

    TableRow MakeHeader(string TitleCss)
    {
        //Build a new header
        TableRow th1 = new TableRow();
        TableCell HdrCell = new TableCell();
        Table NewHeader = new Table();
        NewHeader.ID = "NewHeader" + PageNo.ToString();
        NewHeader.Width = Unit.Percentage(100);
        NewHeader.CellSpacing = 0;
        NewHeader.CellPadding = 0;
        NewHeader.BorderWidth = Unit.Pixel(0);
        TableRow NewHeaderRow1 = new TableRow();
        NewHeaderRow1.VerticalAlign = VerticalAlign.Top;
        TableCell NewHeaderRow1Cell1 = new TableCell();
        NewHeaderRow1Cell1.CssClass = "title";
        NewHeaderRow1Cell1.Text = "<i>Porteous Fastener Co.</i><br>Internal Use Only - Inbound GER ASN";
        NewHeaderRow1Cell1.ColumnSpan = 2;
        NewHeaderRow1.Cells.Add(NewHeaderRow1Cell1);
        NewHeader.Rows.Add(NewHeaderRow1);
 
        TableRow NewHeaderRow2 = new TableRow();
        TableCell NewHeaderRow2Cell1 = new TableCell();
        NewHeaderRow2Cell1.VerticalAlign = VerticalAlign.Top;
        NewHeaderRow2Cell1.CssClass = "border";
        NewHeaderRow2Cell1.Width = Unit.Percentage(50);
        Table HeaderVenData = new Table();
        HeaderVenData.Width = Unit.Percentage(100);
        TableRow HeaderVenDataRow1 = new TableRow();
        HeaderVenDataRow1.VerticalAlign = VerticalAlign.Top;
        TableCell HeaderVenDataRow1Cell1 = new TableCell();
        HeaderVenDataRow1Cell1.CssClass = "headingc";
        HeaderVenDataRow1Cell1.Text = "Acct. Information:";
        HeaderVenDataRow1Cell1.ColumnSpan = 2;
        HeaderVenDataRow1.Cells.Add(HeaderVenDataRow1Cell1);
        HeaderVenData.Rows.Add(HeaderVenDataRow1);
        TableRow HeaderVenDataRow2 = new TableRow();
        TableCell HeaderVenDataRow2Cell1 = new TableCell();
        HeaderVenDataRow2Cell1.CssClass = "rightbold";
        HeaderVenDataRow2Cell1.VerticalAlign = VerticalAlign.Top;
        HeaderVenDataRow2Cell1.Text = "Buy From Vendor:";
        HeaderVenDataRow2.Cells.Add(HeaderVenDataRow2Cell1);
        TableCell HeaderVenDataRow2Cell2 = new TableCell();
        HeaderVenDataRow2Cell2.CssClass = "left";
        HeaderVenDataRow2Cell2.Text = dt.Rows[0]["VendorNo"].ToString().Trim() + "<BR>";
        HeaderVenDataRow2Cell2.Text = HeaderVenDataRow2Cell2.Text + dt.Rows[0]["VendorName"].ToString().Trim() + "<BR>";
        HeaderVenDataRow2Cell2.Text = HeaderVenDataRow2Cell2.Text + dt.Rows[0]["VendorAddr1"].ToString().Trim() + "<BR>";
        HeaderVenDataRow2Cell2.Text = HeaderVenDataRow2Cell2.Text + dt.Rows[0]["VendorAddr2"].ToString().Trim() + "<BR>";
        HeaderVenDataRow2Cell2.Text = HeaderVenDataRow2Cell2.Text + dt.Rows[0]["VendorCityStZip"].ToString().Trim();
        HeaderVenDataRow2.Cells.Add(HeaderVenDataRow2Cell2);
        HeaderVenData.Rows.Add(HeaderVenDataRow2);
        NewHeaderRow2Cell1.Controls.Add(HeaderVenData);
        NewHeaderRow2.Cells.Add(NewHeaderRow2Cell1);
        
        TableCell NewHeaderRow2Cell2 = new TableCell();
        NewHeaderRow2Cell2.VerticalAlign = VerticalAlign.Top;
        NewHeaderRow2Cell2.CssClass = "border";
        NewHeaderRow2Cell2.Width = Unit.Percentage(50);
        Table HeaderDocData = new Table();
        HeaderDocData.Width = Unit.Percentage(100);
        TableRow HeaderDocDataRow0 = new TableRow();
        HeaderDocDataRow0.VerticalAlign = VerticalAlign.Top;
        TableCell HeaderDocDataRow0Cell1 = new TableCell();
        HeaderDocDataRow0Cell1.CssClass = "headingc";
        HeaderDocDataRow0Cell1.Text = "&nbsp;";
        HeaderDocDataRow0Cell1.ColumnSpan = 2;
        HeaderDocDataRow0.Cells.Add(HeaderDocDataRow0Cell1);
        HeaderDocData.Rows.Add(HeaderDocDataRow0);
        TableRow HeaderDocDataRow1 = new TableRow();
        HeaderDocDataRow1.VerticalAlign = VerticalAlign.Top;
        TableCell HeaderDocDataRow1Cell1 = new TableCell();
        HeaderDocDataRow1Cell1.CssClass = "rightbold";
        HeaderDocDataRow1Cell1.Width = Unit.Percentage(50);
        HeaderDocDataRow1Cell1.Text = "Processed Date:";
        HeaderDocDataRow1.Cells.Add(HeaderDocDataRow1Cell1);
        TableCell HeaderDocDataRow1Cell2 = new TableCell();
        HeaderDocDataRow1Cell2.CssClass = "left";
        HeaderDocDataRow1Cell2.Width = Unit.Percentage(50);
        HeaderDocDataRow1Cell2.Text = FormatData(DateFormat, dt.Rows[0]["TransmissionDate"]);
        HeaderDocDataRow1.Cells.Add(HeaderDocDataRow1Cell2);
        HeaderDocData.Rows.Add(HeaderDocDataRow1);
        TableRow HeaderDocDataRow2 = new TableRow();
        HeaderDocDataRow2.VerticalAlign = VerticalAlign.Top;
        TableCell HeaderDocDataRow2Cell1 = new TableCell();
        HeaderDocDataRow2Cell1.CssClass = "rightbold";
        HeaderDocDataRow2Cell1.Text = "Received Date:";
        HeaderDocDataRow2.Cells.Add(HeaderDocDataRow2Cell1);
        TableCell HeaderDocDataRow2Cell2 = new TableCell();
        HeaderDocDataRow2Cell2.CssClass = "left";
        HeaderDocDataRow2Cell2.Text = FormatData(DateFormat, dt.Rows[0]["ReceivedDate"]);
        HeaderDocDataRow2.Cells.Add(HeaderDocDataRow2Cell2);
        HeaderDocData.Rows.Add(HeaderDocDataRow2);

        TableRow HeaderDocDataRow3 = new TableRow();
        HeaderDocDataRow3.VerticalAlign = VerticalAlign.Top;
        TableCell HeaderDocDataRow3Cell1 = new TableCell();
        HeaderDocDataRow3Cell1.CssClass = "rightbold";
        HeaderDocDataRow3Cell1.Text = "BOL #:";
        HeaderDocDataRow3.Cells.Add(HeaderDocDataRow3Cell1);
        TableCell HeaderDocDataRow3Cell2 = new TableCell();
        HeaderDocDataRow3Cell2.CssClass = "left";
        HeaderDocDataRow3Cell2.Text = BOL;
        HeaderDocDataRow3.Cells.Add(HeaderDocDataRow3Cell2);
        HeaderDocData.Rows.Add(HeaderDocDataRow3);
 
        TableRow HeaderDocDataRow4 = new TableRow();
        HeaderDocDataRow4.VerticalAlign = VerticalAlign.Top;
        TableCell HeaderDocDataRow4Cell1 = new TableCell();
        HeaderDocDataRow4Cell1.CssClass = "rightbold";
        HeaderDocDataRow4Cell1.Text = "Location:";
        HeaderDocDataRow4.Cells.Add(HeaderDocDataRow4Cell1);
        TableCell HeaderDocDataRow4Cell2 = new TableCell();
        HeaderDocDataRow4Cell2.CssClass = "left";
        HeaderDocDataRow4Cell2.Text = dt.Rows[0]["BranchNo"].ToString().Trim();
        HeaderDocDataRow4.Cells.Add(HeaderDocDataRow4Cell2);
        HeaderDocData.Rows.Add(HeaderDocDataRow4);
   
        NewHeaderRow2Cell2.Controls.Add(HeaderDocData);
        NewHeaderRow2.Cells.Add(NewHeaderRow2Cell2);
        NewHeader.Rows.Add(NewHeaderRow2);

        HdrCell.Controls.Add(NewHeader);
        HdrCell.ID = "XHeader" + PageNo.ToString();
        th1.Cells.Add(HdrCell);
        return th1;
    }

    TableRow MakeDetHeader()
    {
        //Build the document detail header
        TableRow NewDtlHeaderRow1 = new TableRow();
        NewDtlHeaderRow1.VerticalAlign = VerticalAlign.Top;
        TableCell NewDtlHeaderRow1Cell1 = new TableCell();
        NewDtlHeaderRow1Cell1.CssClass = "headingc";
        NewDtlHeaderRow1Cell1.Text = "ASN<BR>Line";
        NewDtlHeaderRow1Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewDtlHeaderRow1Cell1.Width = Unit.Percentage(DetColWid[0]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell1);
        TableCell NewDtlHeaderRow1Cell2 = new TableCell();
        NewDtlHeaderRow1Cell2.CssClass = "headingc";
        NewDtlHeaderRow1Cell2.Text = "PFC PO#";
        NewDtlHeaderRow1Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewDtlHeaderRow1Cell2.Width = Unit.Percentage(DetColWid[1]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell2);
        TableCell NewDtlHeaderRow1Cell3 = new TableCell();
        NewDtlHeaderRow1Cell3.CssClass = "headingc";
        NewDtlHeaderRow1Cell3.Text = "Part Number";
        NewDtlHeaderRow1Cell3.HorizontalAlign = HorizontalAlign.Right;
        NewDtlHeaderRow1Cell3.Width = Unit.Percentage(DetColWid[2]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell3);
        TableCell NewDtlHeaderRow1Cell4 = new TableCell();
        NewDtlHeaderRow1Cell4.CssClass = "headingc";
        NewDtlHeaderRow1Cell4.Text = "ASN<BR>Qty/UM";
        NewDtlHeaderRow1Cell4.HorizontalAlign = HorizontalAlign.Right;
        NewDtlHeaderRow1Cell4.Width = Unit.Percentage(DetColWid[3]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell4);
        TableCell NewDtlHeaderRow1Cell5 = new TableCell();
        NewDtlHeaderRow1Cell5.CssClass = "headingc";
        NewDtlHeaderRow1Cell5.Text = "PFC<BR>Qty/UM";
        NewDtlHeaderRow1Cell5.HorizontalAlign = HorizontalAlign.Right;
        NewDtlHeaderRow1Cell5.Width = Unit.Percentage(DetColWid[4]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell5);
        TableCell NewDtlHeaderRow1Cell6 = new TableCell();
        NewDtlHeaderRow1Cell6.CssClass = "headingc";
        NewDtlHeaderRow1Cell6.Text = "Vend. Part#";
        NewDtlHeaderRow1Cell6.HorizontalAlign = HorizontalAlign.Center;
        NewDtlHeaderRow1Cell6.Width = Unit.Percentage(DetColWid[5]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell6);
        TableCell NewDtlHeaderRow1Cell7 = new TableCell();
        NewDtlHeaderRow1Cell7.CssClass = "headingc";
        NewDtlHeaderRow1Cell7.Text = "ASN ID";
        NewDtlHeaderRow1Cell7.HorizontalAlign = HorizontalAlign.Left;
        NewDtlHeaderRow1Cell7.Width = Unit.Percentage(DetColWid[6]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell7);
        TableCell NewDtlHeaderRow1Cell8 = new TableCell();
        NewDtlHeaderRow1Cell8.CssClass = "headingc";
        NewDtlHeaderRow1Cell8.Text = "Packing List";
        NewDtlHeaderRow1Cell8.HorizontalAlign = HorizontalAlign.Left;
        NewDtlHeaderRow1Cell8.Width = Unit.Percentage(DetColWid[7]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell8);
        TableCell NewDtlHeaderRow1Cell9 = new TableCell();
        NewDtlHeaderRow1Cell9.CssClass = "headingc";
        NewDtlHeaderRow1Cell9.Text = "Price/UM";
        NewDtlHeaderRow1Cell9.HorizontalAlign = HorizontalAlign.Left;
        NewDtlHeaderRow1Cell9.Width = Unit.Percentage(DetColWid[8]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell9);
        //TableCell NewDtlHeaderRow1Cell10 = new TableCell();
        //NewDtlHeaderRow1Cell10.CssClass = "headingc";
        //NewDtlHeaderRow1Cell10.Text = "Status";
        //NewDtlHeaderRow1Cell10.HorizontalAlign = HorizontalAlign.Left;
        //NewDtlHeaderRow1Cell10.Width = Unit.Percentage(DetColWid[9]);
        //NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell10);
        return NewDtlHeaderRow1;
    }

    TableRow MakeFileNameLine(DataRow DetRow)
    {
        //Build the EDI File name line
        TableRow FileNameRow = new TableRow();
        FileNameRow.ID = "XEDIFile" + PageNo.ToString() + "R" + rowCtr.ToString();
        TableCell FileNameRowCell = new TableCell();
        FileNameRowCell.Text = "<b>EDI File:</b> " + DetRow["EDIFileName"].ToString();
        FileNameRowCell.CssClass = "heading";
        FileNameRowCell.HorizontalAlign = HorizontalAlign.Left;
        FileNameRowCell.ColumnSpan = 9;
        FileNameRow.Cells.Add(FileNameRowCell);
        return FileNameRow;
    }

    TableRow MakeASNLine(DataRow DetRow)
    {
        //Build the EDI File name line
        TableRow FileNameRow = new TableRow();
        FileNameRow.ID = "XASNHdr" + PageNo.ToString() + "R" + rowCtr.ToString();
        TableCell FileNameRowCell = new TableCell();
        if (DetRow["ExceptionCode"].ToString().Trim() != "255")
        {
            FileNameRowCell.Text = "Failed Lines:  " + DetRow["ExceptionDesc"].ToString();
            FileNameRowCell.CssClass = "borderc";
            FileNameRowCell.ForeColor = Color.Red;
        }
        else
        {
            FileNameRowCell.Text = "Successful Lines for ASN  " + DetRow["ASNID"].ToString();
            FileNameRowCell.CssClass = "borderc";
        }
        FileNameRowCell.ColumnSpan = 9;
        FileNameRow.Cells.Add(FileNameRowCell);
        return FileNameRow;
    }

    TableRow MakeDetailLine(DataRow DetRow)
    {
        //Build the document detail line
        TableRow NewDetailRow1 = new TableRow();
        NewDetailRow1.VerticalAlign = VerticalAlign.Top;
        NewDetailRow1.ID = "NewDetail" + PageNo.ToString() + "R" + rowCtr.ToString();
        TableCell NewDetailRow1Cell1 = new TableCell();
        NewDetailRow1Cell1.Text = DetRow["ASNLineNo"].ToString();
        NewDetailRow1Cell1.CssClass = "border";
        NewDetailRow1Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewDetailRow1Cell1.Width = Unit.Percentage(DetColWid[0]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell1);
        TableCell NewDetailRow1Cell2 = new TableCell();
        NewDetailRow1Cell2.Text = DetRow["PONumber"].ToString();
        NewDetailRow1Cell2.CssClass = "border";
        NewDetailRow1Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewDetailRow1Cell2.Width = Unit.Percentage(DetColWid[1]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell2);
        TableCell NewDetailRow1Cell3 = new TableCell();
        NewDetailRow1Cell3.Text = DetRow["ItemNo"].ToString();
        NewDetailRow1Cell3.CssClass = "border";
        NewDetailRow1Cell3.HorizontalAlign = HorizontalAlign.Center;
        NewDetailRow1Cell3.Width = Unit.Percentage(DetColWid[2]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell3);
        TableCell NewDetailRow1Cell4 = new TableCell();
        NewDetailRow1Cell4.Text = FormatData(Num0Format, DetRow["QtyShipped"]) + "/" + DetRow["ASNUOM"];
        NewDetailRow1Cell4.CssClass = "border";
        NewDetailRow1Cell4.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell4.Width = Unit.Percentage(DetColWid[3]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell4);
        TableCell NewDetailRow1Cell5 = new TableCell();
        NewDetailRow1Cell5.Text = FormatData(Num0Format, DetRow["ContQty"]) + "/" + DetRow["POUOM"];
        NewDetailRow1Cell5.CssClass = "border";
        NewDetailRow1Cell5.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell5.Width = Unit.Percentage(DetColWid[4]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell5);
        TableCell NewDetailRow1Cell6 = new TableCell();
        NewDetailRow1Cell6.Text = DetRow["VendorPart"].ToString();
        NewDetailRow1Cell6.CssClass = "border";
        NewDetailRow1Cell6.HorizontalAlign = HorizontalAlign.Center;
        NewDetailRow1Cell6.Width = Unit.Percentage(DetColWid[5]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell6);
        TableCell NewDetailRow1Cell7 = new TableCell();
        NewDetailRow1Cell7.Text = DetRow["ASNID"].ToString();
        NewDetailRow1Cell7.CssClass = "border";
        NewDetailRow1Cell7.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell7.Width = Unit.Percentage(DetColWid[6]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell7);
        TableCell NewDetailRow1Cell8 = new TableCell();
        NewDetailRow1Cell8.Text = DetRow["PackingList"].ToString();
        NewDetailRow1Cell8.CssClass = "border";
        NewDetailRow1Cell8.HorizontalAlign = HorizontalAlign.Center;
        NewDetailRow1Cell8.Width = Unit.Percentage(DetColWid[7]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell8);
        TableCell NewDetailRow1Cell9 = new TableCell();
        NewDetailRow1Cell9.Text = FormatData(Num2Format, DetRow["ASNPrice"]) + "/M";
        NewDetailRow1Cell9.CssClass = "border";
        NewDetailRow1Cell9.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell9.Width = Unit.Percentage(DetColWid[8]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell9);
        //TableCell NewDetailRow1Cell10 = new TableCell();
        //NewDetailRow1Cell10.Text = DetRow["ExceptionDesc"].ToString();
        //NewDetailRow1Cell10.CssClass = "border";
        //NewDetailRow1Cell10.HorizontalAlign = HorizontalAlign.Left;
        //NewDetailRow1Cell10.Width = Unit.Percentage(DetColWid[9]);
        //NewDetailRow1.Cells.Add(NewDetailRow1Cell10);
        return NewDetailRow1;
    }

    TableRow MakeASNTotal()
    {
        //Build the EDI File name line
        TableRow ASNTotalRow = new TableRow();
        ASNTotalRow.ID = "XASNTotal" + PageNo.ToString() + "R" + rowCtr.ToString();
        ASNTotalRow.CssClass = "border";
        TableCell ASNTotalRowCell1 = new TableCell();
        ASNTotalRowCell1.Text = "ASN Total: ";
        //ASNTotalRowCell1.CssClass = "border";
        ASNTotalRowCell1.HorizontalAlign = HorizontalAlign.Right;
        ASNTotalRowCell1.ColumnSpan = 8;
        ASNTotalRow.Cells.Add(ASNTotalRowCell1);
        TableCell ASNTotalRowCell2 = new TableCell();
        ASNTotalRowCell2.Text = FormatData(Num2Format, ASNTotal);
        //ASNTotalRowCell2.CssClass = "border";
        ASNTotalRowCell2.HorizontalAlign = HorizontalAlign.Right;
        ASNTotalRow.Cells.Add(ASNTotalRowCell2);
        return ASNTotalRow;
    }

    TableRow MakeBOLTotal()
    {
        //Build the EDI File name line
        TableRow BOLTotalRow = new TableRow();
        BOLTotalRow.ID = "XBOLTotal" + PageNo.ToString() + "R" + rowCtr.ToString();
        BOLTotalRow.CssClass = "border";
        TableCell BOLTotalRowCell1 = new TableCell();
        BOLTotalRowCell1.Text = "BOL Total: ";
        //BOLTotalRowCell1.CssClass = "border";
        BOLTotalRowCell1.HorizontalAlign = HorizontalAlign.Right;
        BOLTotalRowCell1.ColumnSpan = 8;
        BOLTotalRow.Cells.Add(BOLTotalRowCell1);
        TableCell BOLTotalRowCell2 = new TableCell();
        BOLTotalRowCell2.Text =  FormatData(Num2Format, BOLTotal);
        //BOLTotalRowCell2.CssClass = "border";
        BOLTotalRowCell2.HorizontalAlign = HorizontalAlign.Right;
        BOLTotalRow.Cells.Add(BOLTotalRowCell2);
        return BOLTotalRow;
    }

    TableRow BlankLine()
    {
        //Build the document data header
        TableRow bl1 = new TableRow();
        TableCell blCell = new TableCell();
        blCell.Text = "&nbsp;";
        /**/
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
