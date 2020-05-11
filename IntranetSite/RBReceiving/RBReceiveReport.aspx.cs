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
using PFC.Intranet.DataAccessLayer;

public partial class ReceivingReport : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
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
    string Branch = "";
    string Container = "";
    string LPN = "";
    //public Table MainReport = new Table();
    int pageRows = 44;
    int rowCtr = 0;
    int PageNo = 1;
    int[] DetColWid = { 13, 13, 8, 8, 8, 10, 30, 10 };

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["Branch"] != null)
        {
            Branch = Request.QueryString["Branch"].ToString().Trim();
        }
        if (Request.QueryString["Container"] != null)
        {
            Container = Request.QueryString["Container"].ToString().Trim();
        }
        if (Request.QueryString["LPN"] != null)
        {
            LPN = Request.QueryString["LPN"].ToString().Trim();
        }
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
        try
        {
            // get the report data."05""05POCU0564018"
            ds = SqlHelper.ExecuteDataset(connectionString, "pWHSRcvRprtData",
                    new SqlParameter("@Branch", Branch),
                    new SqlParameter("@Container", Container),
                    new SqlParameter("@LPN", LPN));
            if (ds.Tables.Count >= 1)
            {
                // make the report
                dt = ds.Tables[0];
                MainReport.Rows.Add(MakeHeader("docTitle"));
                MainReport.Rows.Add(BlankLine());
                MainReport.Rows.Add(BlankLine());
                MainReport.Rows.Add(MakeDocHeader());
                MainReport.Rows.Add(BlankLine());
                MainReport.Rows.Add(MakeDetHeader());
                foreach (DataRow dr in dt.Rows)
                {
                    if (rowCtr > pageRows)
                    {
                        // start a new page
                        PageNo++;
                        rowCtr = 0;
                        MainReport.Rows.Add(MakeHeader("docTitle newPage"));
                        MainReport.Rows.Add(BlankLine());
                        MainReport.Rows.Add(BlankLine());
                        MainReport.Rows.Add(MakeDocHeader());
                        MainReport.Rows.Add(BlankLine());
                        MainReport.Rows.Add(MakeDetHeader());
                    }
                    rowCtr++;
                    MainReport.Rows.Add(MakeDetailLine(dr));
                    rowCtr++;
                    MainReport.Rows.Add(BlankLine());
                }
            }
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "pWHSRcvRprtData Error " + e3.Message + ", " + e3.ToString();
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

        TableRow NewHeaderRow1 = new TableRow();
        NewHeaderRow1.VerticalAlign = VerticalAlign.Top;
        TableCell NewHeaderRow1Cell1 = new TableCell();
        NewHeaderRow1Cell1.CssClass = TitleCss;
        NewHeaderRow1Cell1.Text = "Warehouse Receiving Report";
        NewHeaderRow1Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewHeaderRow1Cell1.Width = Unit.Percentage(33);
        NewHeaderRow1.Cells.Add(NewHeaderRow1Cell1);
        TableCell NewHeaderRow1Cell2 = new TableCell();
        NewHeaderRow1Cell2.Text = FormatData(LongDateTimeFormat, DateTime.Now);
        NewHeaderRow1Cell2.HorizontalAlign = HorizontalAlign.Right;
        NewHeaderRow1Cell2.ColumnSpan = 2;
        NewHeaderRow1Cell2.Width = Unit.Percentage(66);
        NewHeaderRow1.Cells.Add(NewHeaderRow1Cell2);
        NewHeader.Rows.Add(NewHeaderRow1);
        TableRow NewHeaderRow2 = new TableRow();
        TableCell NewHeaderRow2Cell1 = new TableCell();
        NewHeaderRow2Cell1.Text = dt.Rows[0]["CorpName"].ToString().Trim();
        NewHeaderRow2Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewHeaderRow2Cell1.Width = Unit.Percentage(33);
        NewHeaderRow2.Cells.Add(NewHeaderRow2Cell1);
        TableCell NewHeaderRow2Cell2 = new TableCell();
        NewHeaderRow2Cell2.Text = "Page: "+PageNo.ToString();
        NewHeaderRow2Cell2.ColumnSpan = 2;
        NewHeaderRow2Cell2.HorizontalAlign = HorizontalAlign.Right;
        NewHeaderRow2Cell2.Width = Unit.Percentage(66);
        NewHeaderRow2.Cells.Add(NewHeaderRow2Cell2);
        NewHeader.Rows.Add(NewHeaderRow2);
        TableRow NewHeaderRow3 = new TableRow();
        TableCell NewHeaderRow3Cell1 = new TableCell();
        NewHeaderRow3Cell1.Text = "&nbsp;&nbsp;";
        NewHeaderRow3Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewHeaderRow3.Cells.Add(NewHeaderRow3Cell1);
        TableCell NewHeaderRow3Cell2 = new TableCell();
        NewHeaderRow3Cell2.Text = UserName;
        NewHeaderRow3Cell2.ColumnSpan = 2;
        NewHeaderRow3Cell2.HorizontalAlign = HorizontalAlign.Right;
        NewHeaderRow3.Cells.Add(NewHeaderRow3Cell2);
        NewHeader.Rows.Add(NewHeaderRow3);
        TableRow NewHeaderRow4 = new TableRow();
        TableCell NewHeaderRow4Cell1 = new TableCell();
        //NewHeaderRow4Cell1.BorderColor = System.Drawing.Color.Black;
        //NewHeaderRow4Cell1.BorderStyle = BorderStyle.Solid;
        //NewHeaderRow4Cell1.BorderWidth = Unit.Pixel(2);
        NewHeaderRow4Cell1.Text = "TRANSFER FROM:";
        NewHeaderRow4Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewHeaderRow4Cell1.Width = Unit.Percentage(40);
        NewHeaderRow4.Cells.Add(NewHeaderRow4Cell1);
        TableCell NewHeaderRow4Cell2 = new TableCell();
        //NewHeaderRow4Cell2.BorderColor = System.Drawing.Color.Black;
        //NewHeaderRow4Cell2.BorderStyle = BorderStyle.Solid;
        //NewHeaderRow4Cell2.BorderWidth = Unit.Pixel(2);
        NewHeaderRow4Cell2.Text = "TRANSFER TO:";
        NewHeaderRow4Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewHeaderRow4Cell2.Width = Unit.Percentage(30);
        NewHeaderRow4.Cells.Add(NewHeaderRow4Cell2);
        TableCell NewHeaderRow4Cell3 = new TableCell();
        //NewHeaderRow4Cell3.BorderColor = System.Drawing.Color.Black;
        //NewHeaderRow4Cell3.BorderStyle = BorderStyle.Solid;
        //NewHeaderRow4Cell3.BorderWidth = Unit.Pixel(2);
        Label imgBarCode = new Label();
        imgBarCode.CssClass = "barcode";
        imgBarCode.Text = "*" + dt.Rows[0]["ContainerNo"].ToString() + "*";
        //imgBarCode.ImageUrl = "Barcode.aspx?Code=" + dt.Rows[0]["ContainerNo"].ToString();
        NewHeaderRow4Cell3.Controls.Add(imgBarCode);
        Label lblBarcode = new Label();
        lblBarcode.Text = "<br>" + dt.Rows[0]["ContainerNo"].ToString();
        NewHeaderRow4Cell3.Controls.Add(lblBarcode);
        NewHeaderRow4Cell3.Width = Unit.Percentage(30);
        NewHeaderRow4Cell3.RowSpan = 2;
        NewHeaderRow4Cell3.VerticalAlign = VerticalAlign.Middle;
        NewHeaderRow4Cell3.HorizontalAlign = HorizontalAlign.Center;
        NewHeaderRow4.Cells.Add(NewHeaderRow4Cell3);
        NewHeader.Rows.Add(NewHeaderRow4);
        TableRow NewHeaderRow5 = new TableRow();
        TableCell NewHeaderRow5Cell1 = new TableCell();
        NewHeaderRow5Cell1.Width = Unit.Percentage(40);
        NewHeaderRow5Cell1.VerticalAlign = VerticalAlign.Top;
        NewHeaderRow5Cell1.HorizontalAlign = HorizontalAlign.Left;
        // class=locAddr   class=locName
        NewHeaderRow5Cell1.Text = "<div class=locName>" + dt.Rows[0]["FromLocName"].ToString() + "</div>";
        if (dt.Rows[0]["FromLocAdress1"].ToString().Trim().Length > 0)
        {
            NewHeaderRow5Cell1.Text += "<div>" + dt.Rows[0]["FromLocAdress1"].ToString() + "</div>";
        }
        if (dt.Rows[0]["FromLocAdress2"].ToString().Trim().Length > 0)
        {
            NewHeaderRow5Cell1.Text += "<div>" + dt.Rows[0]["FromLocAdress2"].ToString() + "</div>";
        }
        NewHeaderRow5Cell1.Text += "<div>" + dt.Rows[0]["FromLocCityStZip"].ToString() + "</div>";
        NewHeaderRow5.Cells.Add(NewHeaderRow5Cell1);
        TableCell NewHeaderRow5Cell2 = new TableCell();
        NewHeaderRow5Cell2.Width = Unit.Percentage(30);
        NewHeaderRow5Cell2.VerticalAlign = VerticalAlign.Top;
        NewHeaderRow5Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewHeaderRow5Cell2.Text = "<div class=locName>" + dt.Rows[0]["ToLocName"].ToString() + "</div>";
        if (dt.Rows[0]["ToLocAdress1"].ToString().Trim().Length > 0)
        {
            NewHeaderRow5Cell2.Text += "<div>" + dt.Rows[0]["ToLocAdress1"].ToString() + "</div>";
        }
        if (dt.Rows[0]["ToLocAdress2"].ToString().Trim().Length > 0)
        {
            NewHeaderRow5Cell2.Text += "<div>" + dt.Rows[0]["ToLocAdress2"].ToString() + "</div>";
        }
        NewHeaderRow5Cell2.Text += "<div>" + dt.Rows[0]["ToLocCityStZip"].ToString() + "</div>";
        NewHeaderRow5.Cells.Add(NewHeaderRow5Cell2);
        NewHeader.Rows.Add(NewHeaderRow5);
/**/
        HdrCell.Controls.Add(NewHeader);
        //HdrCell.CssClass = "newPage";
        HdrCell.ID = "XHeader" + PageNo.ToString();
        th1.Cells.Add(HdrCell);
        return th1;
    }

    TableRow MakeDocHeader()
    {
        //Build the document data header
        TableRow th2 = new TableRow();
        TableCell HdrDocCell = new TableCell();
        Table NewDocHeader = new Table();
        NewDocHeader.ID = "NewDocHeader" + PageNo.ToString();
        NewDocHeader.Width = Unit.Percentage(100);
        NewDocHeader.CellSpacing = 5;
        NewDocHeader.CellPadding = 0;
        // build the lines
        TableRow NewDocHeaderRow1 = new TableRow();
        NewDocHeaderRow1.VerticalAlign = VerticalAlign.Bottom;
        TableCell NewDocHeaderRow1Cell1 = new TableCell();
        NewDocHeaderRow1Cell1.CssClass = "bold";
        NewDocHeaderRow1Cell1.Text = "BOL No";
        NewDocHeaderRow1Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewDocHeaderRow1Cell1.Width = Unit.Percentage(15);
        NewDocHeaderRow1.Cells.Add(NewDocHeaderRow1Cell1);
        TableCell NewDocHeaderRow1Cell2 = new TableCell();
        NewDocHeaderRow1Cell2.CssClass = "bold";
        NewDocHeaderRow1Cell2.Text = "Container No.";
        NewDocHeaderRow1Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewDocHeaderRow1Cell2.Width = Unit.Percentage(15);
        NewDocHeaderRow1.Cells.Add(NewDocHeaderRow1Cell2);
        //TableCell NewDocHeaderRow1Cell3 = new TableCell();
        //NewDocHeaderRow1Cell3.CssClass = "bold";
        //NewDocHeaderRow1Cell3.Text = "Container No.";
        //NewDocHeaderRow1Cell3.HorizontalAlign = HorizontalAlign.Left;
        //NewDocHeaderRow1Cell3.Width = Unit.Percentage(15);
        //NewDocHeaderRow1.Cells.Add(NewDocHeaderRow1Cell3);
        TableCell NewDocHeaderRow1Cell4 = new TableCell();
        NewDocHeaderRow1Cell4.CssClass = "bold";
        NewDocHeaderRow1Cell4.Text = "In Transit Loc";
        NewDocHeaderRow1Cell4.HorizontalAlign = HorizontalAlign.Left;
        NewDocHeaderRow1Cell4.Width = Unit.Percentage(15);
        NewDocHeaderRow1.Cells.Add(NewDocHeaderRow1Cell4);
        TableCell NewDocHeaderRow1Cell5 = new TableCell();
        NewDocHeaderRow1Cell5.CssClass = "bold";
        NewDocHeaderRow1Cell5.Text = "Pre-Rcpt Date";
        NewDocHeaderRow1Cell5.HorizontalAlign = HorizontalAlign.Left;
        NewDocHeaderRow1Cell5.Width = Unit.Percentage(15);
        NewDocHeaderRow1.Cells.Add(NewDocHeaderRow1Cell5);
        TableCell NewDocHeaderRow1Cell6 = new TableCell();
        NewDocHeaderRow1Cell6.CssClass = "bold";
        NewDocHeaderRow1Cell6.Text = "Ship Agent";
        NewDocHeaderRow1Cell6.HorizontalAlign = HorizontalAlign.Left;
        NewDocHeaderRow1Cell6.Width = Unit.Percentage(15);
        NewDocHeaderRow1.Cells.Add(NewDocHeaderRow1Cell6);
        TableCell NewDocHeaderRow1Cell7 = new TableCell();
        NewDocHeaderRow1Cell7.CssClass = "bold";
        NewDocHeaderRow1Cell7.Text = "Pre-Rcpt ID";
        NewDocHeaderRow1Cell7.HorizontalAlign = HorizontalAlign.Left;
        NewDocHeaderRow1Cell7.Width = Unit.Percentage(15);
        NewDocHeaderRow1.Cells.Add(NewDocHeaderRow1Cell7);
        NewDocHeader.Rows.Add(NewDocHeaderRow1);
        //
        TableRow NewDocHeaderRow2 = new TableRow();
        TableCell NewDocHeaderRow2Cell1 = new TableCell();
        NewDocHeaderRow2Cell1.Text = dt.Rows[0]["BOLNo"].ToString();
        NewDocHeaderRow2Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewDocHeaderRow2Cell1.Width = Unit.Percentage(15);
        NewDocHeaderRow2.Cells.Add(NewDocHeaderRow2Cell1);
        TableCell NewDocHeaderRow2Cell2 = new TableCell();
        NewDocHeaderRow2Cell2.Text = dt.Rows[0]["ContainerNo"].ToString();
        NewDocHeaderRow2Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewDocHeaderRow2Cell2.Width = Unit.Percentage(15);
        NewDocHeaderRow2.Cells.Add(NewDocHeaderRow2Cell2);
        //TableCell NewDocHeaderRow2Cell3 = new TableCell();
        //NewDocHeaderRow2Cell3.Text = dt.Rows[0]["OrigDoc"].ToString();
        //NewDocHeaderRow2Cell3.HorizontalAlign = HorizontalAlign.Left;
        //NewDocHeaderRow2Cell3.Width = Unit.Percentage(15);
        //NewDocHeaderRow2.Cells.Add(NewDocHeaderRow2Cell3);
        TableCell NewDocHeaderRow2Cell4 = new TableCell();
        NewDocHeaderRow2Cell4.Text = dt.Rows[0]["InTransit"].ToString();
        NewDocHeaderRow2Cell4.HorizontalAlign = HorizontalAlign.Left;
        NewDocHeaderRow2Cell4.Width = Unit.Percentage(15);
        NewDocHeaderRow2.Cells.Add(NewDocHeaderRow2Cell4);
        TableCell NewDocHeaderRow2Cell5 = new TableCell();
        NewDocHeaderRow2Cell5.Text = FormatData(MedDateFormat, dt.Rows[0]["PostDate"]);
        NewDocHeaderRow2Cell5.HorizontalAlign = HorizontalAlign.Left;
        NewDocHeaderRow2Cell5.Width = Unit.Percentage(15);
        NewDocHeaderRow2.Cells.Add(NewDocHeaderRow2Cell5);
        TableCell NewDocHeaderRow2Cell6 = new TableCell();
        NewDocHeaderRow2Cell6.Text = dt.Rows[0]["ShipAgent"].ToString();
        NewDocHeaderRow2Cell6.HorizontalAlign = HorizontalAlign.Left;
        NewDocHeaderRow2Cell6.Width = Unit.Percentage(15);
        NewDocHeaderRow2.Cells.Add(NewDocHeaderRow2Cell6);
        TableCell NewDocHeaderRow2Cell7 = new TableCell();
        NewDocHeaderRow2Cell7.Text = dt.Rows[0]["EntryID"].ToString();
        NewDocHeaderRow2Cell7.HorizontalAlign = HorizontalAlign.Left;
        NewDocHeaderRow2Cell7.Width = Unit.Percentage(15);
        NewDocHeaderRow2.Cells.Add(NewDocHeaderRow2Cell7);
        NewDocHeader.Rows.Add(NewDocHeaderRow2);
        /**/
        HdrDocCell.Controls.Add(NewDocHeader);
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
        NewDtlHeader.Width = Unit.Percentage(100);
        NewDtlHeader.CellSpacing = 0;
        NewDtlHeader.CellPadding = 0;
        // build the lines
        TableRow NewDtlHeaderRow1 = new TableRow();
        NewDtlHeaderRow1.VerticalAlign = VerticalAlign.Top;
        TableCell NewDtlHeaderRow1Cell1 = new TableCell();
        NewDtlHeaderRow1Cell1.CssClass = "bold";
        NewDtlHeaderRow1Cell1.Text = "PO Num";
        NewDtlHeaderRow1Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewDtlHeaderRow1Cell1.Width = Unit.Percentage(DetColWid[0]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell1);
        TableCell NewDtlHeaderRow1Cell2 = new TableCell();
        NewDtlHeaderRow1Cell2.CssClass = "bold";
        NewDtlHeaderRow1Cell2.Text = "Item No.";
        NewDtlHeaderRow1Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewDtlHeaderRow1Cell2.Width = Unit.Percentage(DetColWid[1]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell2);
        TableCell NewDtlHeaderRow1Cell3 = new TableCell();
        NewDtlHeaderRow1Cell3.CssClass = "bold";
        NewDtlHeaderRow1Cell3.Text = "Qty";
        NewDtlHeaderRow1Cell3.HorizontalAlign = HorizontalAlign.Right;
        NewDtlHeaderRow1Cell3.Width = Unit.Percentage(DetColWid[2]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell3);
        TableCell NewDtlHeaderRow1Cell4 = new TableCell();
        NewDtlHeaderRow1Cell4.CssClass = "bold";
        NewDtlHeaderRow1Cell4.Text = "Avl Qty";
        NewDtlHeaderRow1Cell4.HorizontalAlign = HorizontalAlign.Right;
        NewDtlHeaderRow1Cell4.Width = Unit.Percentage(DetColWid[3]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell4);
        TableCell NewDtlHeaderRow1Cell5 = new TableCell();
        NewDtlHeaderRow1Cell5.CssClass = "bold";
        NewDtlHeaderRow1Cell5.Text = "X-Dock Qty";
        NewDtlHeaderRow1Cell5.HorizontalAlign = HorizontalAlign.Right;
        NewDtlHeaderRow1Cell5.Width = Unit.Percentage(DetColWid[4]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell5);
        TableCell NewDtlHeaderRow1Cell6 = new TableCell();
        NewDtlHeaderRow1Cell6.CssClass = "bold";
        NewDtlHeaderRow1Cell6.Text = "UOM";
        NewDtlHeaderRow1Cell6.HorizontalAlign = HorizontalAlign.Center;
        NewDtlHeaderRow1Cell6.Width = Unit.Percentage(DetColWid[5]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell6);
        TableCell NewDtlHeaderRow1Cell7 = new TableCell();
        NewDtlHeaderRow1Cell7.CssClass = "bold";
        NewDtlHeaderRow1Cell7.Text = "Description";
        NewDtlHeaderRow1Cell7.HorizontalAlign = HorizontalAlign.Left;
        NewDtlHeaderRow1Cell7.Width = Unit.Percentage(DetColWid[6]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell7);
        TableCell NewDtlHeaderRow1Cell8 = new TableCell();
        NewDtlHeaderRow1Cell8.CssClass = "bold";
        NewDtlHeaderRow1Cell8.Text = "Vendor";
        NewDtlHeaderRow1Cell8.HorizontalAlign = HorizontalAlign.Left;
        NewDtlHeaderRow1Cell8.Width = Unit.Percentage(DetColWid[7]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell8);
        NewDtlHeader.Rows.Add(NewDtlHeaderRow1);
        /**/
        HdrDtlCell.Controls.Add(NewDtlHeader);
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
        NewDetail.Width = Unit.Percentage(100);
        NewDetail.CellSpacing = 0;
        NewDetail.CellPadding = 0;
        // build the lines
        TableRow NewDetailRow1 = new TableRow();
        NewDetailRow1.VerticalAlign = VerticalAlign.Top;
        TableCell NewDetailRow1Cell1 = new TableCell();
        NewDetailRow1Cell1.Text = DetRow["OrigDoc"].ToString();     //PONum
        NewDetailRow1Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewDetailRow1Cell1.Width = Unit.Percentage(DetColWid[0]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell1);
        TableCell NewDetailRow1Cell2 = new TableCell();
        NewDetailRow1Cell2.Text = DetRow["ItemNo"].ToString();
        NewDetailRow1Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewDetailRow1Cell2.Width = Unit.Percentage(DetColWid[1]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell2);
        TableCell NewDetailRow1Cell3 = new TableCell();
        NewDetailRow1Cell3.Text = FormatData(Num0Format, DetRow["OrigQty"]);
        NewDetailRow1Cell3.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell3.Width = Unit.Percentage(DetColWid[2]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell3);
        //TableCell NewDetailRow1Cell4 = new TableCell();
        //NewDetailRow1Cell4.Text = FormatData(Num0Format, DetRow["ShippedQty"]);
        //NewDetailRow1Cell4.HorizontalAlign = HorizontalAlign.Right;
        //NewDetailRow1Cell4.Width = Unit.Percentage(DetColWid[3]);
        //NewDetailRow1.Cells.Add(NewDetailRow1Cell4);
        //TableCell NewDetailRow1Cell5 = new TableCell();
        //NewDetailRow1Cell5.Text = FormatData(Num0Format, DetRow["RcvdQty"]);
        //NewDetailRow1Cell5.HorizontalAlign = HorizontalAlign.Right;
        //NewDetailRow1Cell5.Width = Unit.Percentage(DetColWid[4]);
        //NewDetailRow1.Cells.Add(NewDetailRow1Cell5);
        TableCell NewDetailRow1Cell4 = new TableCell();
        NewDetailRow1Cell4.Text = FormatData(Num0Format, DetRow["AvailQty"]);
        NewDetailRow1Cell4.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell4.Width = Unit.Percentage(DetColWid[3]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell4);
        TableCell NewDetailRow1Cell5 = new TableCell();
        NewDetailRow1Cell5.Text = FormatData(Num0Format, DetRow["XDockQty"]);
        NewDetailRow1Cell5.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell5.Width = Unit.Percentage(DetColWid[4]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell5);
        TableCell NewDetailRow1Cell6 = new TableCell();
        NewDetailRow1Cell6.Text = DetRow["UOM"].ToString();
        NewDetailRow1Cell6.HorizontalAlign = HorizontalAlign.Center;
        NewDetailRow1Cell6.Width = Unit.Percentage(DetColWid[5]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell6);
        TableCell NewDetailRow1Cell7 = new TableCell();
        NewDetailRow1Cell7.Text = DetRow["ItemDesc"].ToString();
        NewDetailRow1Cell7.CssClass = "smalltext";
        NewDetailRow1Cell7.HorizontalAlign = HorizontalAlign.Left;
        NewDetailRow1Cell7.Width = Unit.Percentage(DetColWid[6]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell7);
        TableCell NewDetailRow1Cell8 = new TableCell();
        NewDetailRow1Cell8.Text = DetRow["VendorSearch"].ToString();
        NewDetailRow1Cell8.HorizontalAlign = HorizontalAlign.Left;
        NewDetailRow1Cell8.Width = Unit.Percentage(DetColWid[7]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell8);
        NewDetail.Rows.Add(NewDetailRow1);
        /**/
        DetailCell.Controls.Add(NewDetail);
        DetailCell.ID = "XDetail" + PageNo.ToString() + "R" + rowCtr.ToString();
        td1.Cells.Add(DetailCell);
        return td1;
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
