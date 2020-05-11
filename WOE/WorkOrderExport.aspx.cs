using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Globalization;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.WOE.DataAccessLayer;
using PFC.WOE.BusinessLogicLayer;

public partial class WorkOrderExport : System.Web.UI.Page
{
    WOEntry woEntry = new WOEntry();
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
    DataTable dtHdr = new DataTable();
    DataTable dtLine = new DataTable();
    DataTable dtComp = new DataTable();
    DataTable dtComment = new DataTable();
    string UserName;
    string WorkOrder;
    string CertLotNo = "";
    decimal PcTotal = 0;
    decimal WghtTotal = 0;
    int pageRows = 44;
    int rowCtr = 0;
    int PageNo = 1;
    int SellStkUMQty = 0;
    decimal SuperEquivQty;
    int[] DetColWid = { 13, 18, 18, 8, 7, 7, 10, 11, 8 };
    int[] FinColWid = { 15, 20, 20, 10, 15, 20 };

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["WorkOrder"] != null)
        {
            WorkOrder = Request.QueryString["WorkOrder"].ToString().Trim();
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
            // get the report data.
            ds = SqlHelper.ExecuteDataset(connectionString, "pWOEGetWorkOrder",
                    new SqlParameter("@WorkOrderNo", WorkOrder));
            if (ds.Tables.Count == 4)
            {
                // make the report
                dtHdr = ds.Tables[0];
                dtLine = ds.Tables[1];
                PcTotal = decimal.Parse(dtLine.Rows[0]["PcQty"].ToString(), NumberStyles.Number)
                    * decimal.Parse(dtLine.Rows[0]["QtyOrdered"].ToString(), NumberStyles.Number); 
                WghtTotal = decimal.Parse(dtLine.Rows[0]["Wght"].ToString(), NumberStyles.Number)
                    * decimal.Parse(dtLine.Rows[0]["QtyOrdered"].ToString(), NumberStyles.Number);
                dtComp = ds.Tables[2];
                dtComment = ds.Tables[3];
                if (dtComp.Rows.Count > 6)
                {
                    MainReport.Rows.Add(MakeHeader(""));
                    MainReport.Rows.Add(MakeFinished());
                    PageNo++;
                    MainReport.Rows.Add(MakeHeader("newPage"));
                    MainReport.Rows.Add(MakeDocHeader());
                    foreach (DataRow dr in dtComp.Rows)
                    {
                        if (rowCtr > pageRows)
                        {
                            // start a new page
                            PageNo++;
                            rowCtr = 0;
                            MainReport.Rows.Add(MakeHeader("newPage"));
                        }
                        rowCtr++;
                        MainReport.Rows.Add(MakeDetailLine(dr));
                        if (dr["WOCertNo"].ToString().Trim() != "")
                            CertLotNo = dr["WOCertNo"].ToString().Trim();
                    }
                }
                else
                {
                    MainReport.Rows.Add(MakeHeader(""));
                    MainReport.Rows.Add(MakeDocHeader());
                    foreach (DataRow dr in dtComp.Rows)
                    {
                        MainReport.Rows.Add(MakeDetailLine(dr));
                        if (dr["WOCertNo"].ToString().Trim() != "")
                            CertLotNo = dr["WOCertNo"].ToString().Trim();
                    }
                    MainReport.Rows.Add(MakeFinished());
                }
            }
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "pWOEGetWorkOrder Error " + e3.ToString();
            lblErrorMessage.Text += "<BR> Header Count " + dtHdr.Rows.Count.ToString();
            lblErrorMessage.Text += "<BR> Line Count " + dtLine.Rows.Count.ToString();
            lblErrorMessage.Text += "<BR> Comp Count " + dtComp.Rows.Count.ToString();
            lblErrorMessage.Text += "<BR> WorkOrder " + WorkOrder;
        }
    }

    TableRow MakeHeader(string TitleCss)
    {
        //Build a new header
        TableRow th1 = new TableRow();
        TableCell HdrCell = new TableCell();
        Table NewHeader = new Table();
        NewHeader.CssClass = TitleCss;
        NewHeader.ID = "NewHeader" + PageNo.ToString();
        NewHeader.Width = Unit.Percentage(100);
        NewHeader.CellSpacing = 0;
        NewHeader.CellPadding = 0;
        //NewHeader.BorderWidth = Unit.Pixel(2);

        TableRow NewHeaderRow1 = new TableRow();
        NewHeaderRow1.VerticalAlign = VerticalAlign.Top;
        TableCell NewHeaderRow1Cell1 = new TableCell();
        NewHeaderRow1Cell1.RowSpan = 2;
        // create the left header
        Table LeftHeader = new Table();
        LeftHeader.CellPadding = 0;
        LeftHeader.CellSpacing = 0;
        TableRow LHR1 = new TableRow();
        TableCell LHR1Cell1 = new TableCell();
        LHR1Cell1.ColumnSpan = 2;
        LHR1Cell1.Text = "Work Order"+ "&nbsp;-&nbsp;" + dtHdr.Rows[0]["POTypeName"].ToString();
        LHR1Cell1.CssClass = "docTitle";
        LHR1.Cells.Add(LHR1Cell1);
        LeftHeader.Rows.Add(LHR1);
        TableRow LHR2 = new TableRow();
        TableCell LHR2Cell1 = new TableCell();
        LHR2Cell1.Text = WorkOrder + "&nbsp;&nbsp;&nbsp;&nbsp;";
        LHR2Cell1.CssClass = "docTitle bold";
        LHR2.Cells.Add(LHR2Cell1);
        TableCell LHR2Cell2 = new TableCell();
        LHR2Cell2.HorizontalAlign = HorizontalAlign.Right;
        // To set the width & height for barcode, we are calling this barcode.aspx page
        //Image imgWorkOrderBarCode = new Image();
        //imgWorkOrderBarCode.ImageUrl = "Barcode.aspx?Code=" + WorkOrder + "&WidthFactor=26";
        //LHR2Cell2.Controls.Add(imgWorkOrderBarCode);
        //LHR2Cell2.CssClass = "barclip1";
        LHR2Cell2.CssClass = "barcode";
        LHR2Cell2.Text = "*" + WorkOrder + "*";
        LHR2.Cells.Add(LHR2Cell2);
        LeftHeader.Rows.Add(LHR2);
        TableRow LHR3 = new TableRow();
        TableCell LHR3Cell1 = new TableCell();
        LHR3Cell1.Text = "Buyer:";
        LHR3Cell1.CssClass = "smalltext";
        LHR3Cell1.HorizontalAlign = HorizontalAlign.Right;
        LHR3.Cells.Add(LHR3Cell1);
        TableCell LHR3Cell2 = new TableCell();
        LHR3Cell2.Text = dtHdr.Rows[0]["EntryID"].ToString();
        LHR3Cell2.CssClass = "smalltext bold";
        LHR3.Cells.Add(LHR3Cell2);
        LeftHeader.Rows.Add(LHR3);
        TableRow LHR4 = new TableRow();
        TableCell LHR4Cell1 = new TableCell();
        LHR4Cell1.Text = "Issue Date:";
        LHR4Cell1.CssClass = "smalltext";
        LHR4Cell1.HorizontalAlign = HorizontalAlign.Right;
        LHR4.Cells.Add(LHR4Cell1);
        TableCell LHR4Cell2 = new TableCell();
        LHR4Cell2.Text = dtHdr.Rows[0]["EntryDt"].ToString();
        LHR4Cell2.CssClass = "smalltext bold";
        LHR4.Cells.Add(LHR4Cell2);
        LeftHeader.Rows.Add(LHR4);
        TableRow LHR5 = new TableRow();
        TableCell LHR5Cell1 = new TableCell();
        LHR5Cell1.Text = "Due Date:";
        LHR5Cell1.CssClass = "smalltext";
        LHR5Cell1.HorizontalAlign = HorizontalAlign.Right;
        LHR5.Cells.Add(LHR5Cell1);
        TableCell LHR5Cell2 = new TableCell();
        LHR5Cell2.Text = dtLine.Rows[0]["RequestedReceiptDt"].ToString();
        LHR5Cell2.CssClass = "smalltext bold";
        LHR5.Cells.Add(LHR5Cell2);
        LeftHeader.Rows.Add(LHR5);
        TableRow LHR6 = new TableRow();
        TableCell LHR6Cell1 = new TableCell();
        LHR6Cell1.Text = "Priority:";
        LHR6Cell1.CssClass = "smalltext";
        LHR6Cell1.HorizontalAlign = HorizontalAlign.Right;
        LHR6.Cells.Add(LHR6Cell1);
        TableCell LHR6Cell2 = new TableCell();
        LHR6Cell2.Text = dtHdr.Rows[0]["PriorityCd"].ToString();
        LHR6Cell2.CssClass = "smalltext bold";
        LHR6.Cells.Add(LHR6Cell2);
        LeftHeader.Rows.Add(LHR6);
        // now add the table as the left header
        NewHeaderRow1Cell1.Controls.Add(LeftHeader);
        NewHeaderRow1Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewHeaderRow1Cell1.Width = Unit.Percentage(35);
        NewHeaderRow1.Cells.Add(NewHeaderRow1Cell1);

        TableCell NewHeaderRow1Cell2 = new TableCell();
        // create the center header
        Table CenterHeader = new Table();
        CenterHeader.CellPadding = 0;
        CenterHeader.CellSpacing = 0;
        TableRow CHR1 = new TableRow();
        TableCell CHR1Cell1 = new TableCell();
        CHR1Cell1.Text = dtHdr.Rows[0]["BuyFromName"].ToString();
        CHR1Cell1.CssClass = "medtext bold";
        CHR1.Cells.Add(CHR1Cell1);
        CenterHeader.Rows.Add(CHR1);
        TableRow CHR2 = new TableRow();
        TableCell CHR2Cell1 = new TableCell();
        CHR2Cell1.Text = dtHdr.Rows[0]["BuyFromAddress"].ToString();
        CHR2Cell1.CssClass = "medtext";
        CHR2.Cells.Add(CHR2Cell1);
        CenterHeader.Rows.Add(CHR2);
        TableRow CHR3 = new TableRow();
        TableCell CHR3Cell1 = new TableCell();
        CHR3Cell1.Text = dtHdr.Rows[0]["BuyFromAddress2"].ToString();
        CHR3Cell1.CssClass = "medtext";
        CHR3.Cells.Add(CHR3Cell1);
        CenterHeader.Rows.Add(CHR3);
        TableRow CHR4 = new TableRow();
        TableCell CHR4Cell1 = new TableCell();
        CHR4Cell1.Text = dtHdr.Rows[0]["BuyFromCity"].ToString() + ", " + dtHdr.Rows[0]["BuyFromState"].ToString() + ".  " + dtHdr.Rows[0]["BuyFromZip"].ToString();
        CHR4Cell1.CssClass = "medtext";
        CHR4.Cells.Add(CHR4Cell1);
        CenterHeader.Rows.Add(CHR4);
        TableRow CHR5 = new TableRow();
        TableCell CHR5Cell1 = new TableCell();
        CHR5Cell1.Text = dtHdr.Rows[0]["OrderContactPhoneNo"].ToString();
        CHR5Cell1.CssClass = "medtext";
        CHR5.Cells.Add(CHR5Cell1);
        CenterHeader.Rows.Add(CHR5);
        // now add the table as the center header
        NewHeaderRow1Cell2.Controls.Add(CenterHeader);
        NewHeaderRow1Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewHeaderRow1Cell2.Width = Unit.Percentage(30);
        NewHeaderRow1.Cells.Add(NewHeaderRow1Cell2);
 
        TableCell NewHeaderRow1Cell3 = new TableCell();
        NewHeaderRow1Cell3.RowSpan = 2;
        // create the right header
        Table RightHeader = new Table();
        TableRow RHR1 = new TableRow();
        TableCell RHR1Cell1 = new TableCell();
        RHR1Cell1.Text = "Sales&nbsp;Order&nbsp;Ref:";
        RHR1Cell1.CssClass = "smalltext";
        RHR1Cell1.ColumnSpan = 2;
        RHR1.Cells.Add(RHR1Cell1);
        TableCell RHR1Cell2 = new TableCell();
        RHR1Cell2.RowSpan = 3;
        RHR1Cell2.VerticalAlign = VerticalAlign.Top;
        RHR1Cell2.HorizontalAlign = HorizontalAlign.Right;
        RHR1Cell2.Wrap = false;
        //Image imgSalesOrderRefBarCode = new Image();
        //if (dtHdr.Rows[0]["SORefNo"].ToString().Trim() != "")
        //{
        //    imgSalesOrderRefBarCode.ImageUrl = "Barcode.aspx?Code=" + dtHdr.Rows[0]["SORefNo"].ToString() + "&WidthFactor=23";
        //}
        //else
        //{
        //    imgSalesOrderRefBarCode.ImageUrl = "Barcode.aspx?Code=" + dtLine.Rows[0]["ItemNo"].ToString() + "&WidthFactor=22";
        //}
        //RHR1Cell2.Controls.Add(imgSalesOrderRefBarCode);
        if (dtHdr.Rows[0]["SORefNo"].ToString().Trim() != "")
        {
            RHR1Cell2.Text = "*" + dtHdr.Rows[0]["SORefNo"].ToString() + "*";
            RHR1Cell2.CssClass = "barcode";
        }
        else
        {
            RHR1Cell2.Text = "";
        }
        RHR1.Cells.Add(RHR1Cell2);
        RightHeader.Rows.Add(RHR1);
        TableRow RHR2 = new TableRow();
        TableCell RHR2Cell1 = new TableCell();
        RHR2Cell1.ColumnSpan = 2;
        if (dtHdr.Rows[0]["SORefNo"].ToString().Trim() != "")
        {
            RHR2Cell1.Text = dtHdr.Rows[0]["SORefNo"].ToString();
        }
        else
        {
            RHR2Cell1.Text = "";
        }
        RHR2Cell1.CssClass = "medtext bold";
        RHR2.Cells.Add(RHR2Cell1);
        RightHeader.Rows.Add(RHR2);
        TableRow RHR3 = new TableRow();
        TableCell RHR3Cell1 = new TableCell();
        RHR3Cell1.Text = "Branch:";
        RHR3Cell1.CssClass = "smalltext";
        RHR3Cell1.HorizontalAlign = HorizontalAlign.Right;
        RHR3.Cells.Add(RHR3Cell1);
        TableCell RHR3Cell2 = new TableCell();
        RHR3Cell2.Text = dtHdr.Rows[0]["LocationCd"].ToString();
        RHR3Cell2.CssClass = "medtext bold";
        RHR3.Cells.Add(RHR3Cell2);
        RightHeader.Rows.Add(RHR3);
        TableRow RHR4 = new TableRow();
        TableCell RHR4Cell1 = new TableCell();
        RHR4Cell1.Text = "Page:";
        RHR4Cell1.CssClass = "smalltext";
        RHR4Cell1.HorizontalAlign = HorizontalAlign.Right;
        RHR4.Cells.Add(RHR4Cell1);
        TableCell RHR4Cell2 = new TableCell();
        RHR4Cell2.Text = PageNo.ToString();
        RHR4Cell2.CssClass = "smalltext";
        RHR4.Cells.Add(RHR4Cell2);
        RightHeader.Rows.Add(RHR4);
        TableRow RHR5 = new TableRow();
        TableCell RHR5Cell1 = new TableCell();
        RHR5Cell1.Text = "Sub-Contractor:";
        RHR5Cell1.CssClass = "smalltext";
        RHR5Cell1.HorizontalAlign = HorizontalAlign.Right;
        RHR5.Cells.Add(RHR5Cell1);
        TableCell RHR5Cell2 = new TableCell();
        RHR5Cell2.Text = dtHdr.Rows[0]["PayToName"].ToString();
        RHR5Cell2.CssClass = "smalltext bold";
        RHR5.Cells.Add(RHR5Cell2);
        RightHeader.Rows.Add(RHR5);
        TableRow RHR6 = new TableRow();
        TableCell RHR6Cell1 = new TableCell();
        RHR6Cell1.Text = "Pick Status:";
        RHR6Cell1.CssClass = "smalltext";
        RHR6Cell1.HorizontalAlign = HorizontalAlign.Right;
        RHR6.Cells.Add(RHR6Cell1);
        TableCell RHR6Cell2 = new TableCell();
        RHR6Cell2.Text = woEntry.GetWOPickStatus(dtHdr);
        RHR6Cell2.CssClass = "smalltext bold";
        RHR6.Cells.Add(RHR6Cell2);
        RightHeader.Rows.Add(RHR6);

        // now add the table as the right header
        NewHeaderRow1Cell3.Controls.Add(RightHeader);
        NewHeaderRow1Cell3.HorizontalAlign = HorizontalAlign.Left;
        NewHeaderRow1Cell3.Width = Unit.Percentage(35);
        NewHeaderRow1.Cells.Add(NewHeaderRow1Cell3);
        NewHeader.Rows.Add(NewHeaderRow1);
        
        TableRow NewHeaderRow2 = new TableRow();
        NewHeaderRow2.VerticalAlign = VerticalAlign.Bottom;
        
        TableCell NewHeaderRow2Cell1 = new TableCell();
        NewHeaderRow2Cell1.Text = "Printed: " + String.Format(LongDateTimeFormat, DateTime.Now);
        NewHeaderRow2Cell1.CssClass = "smalltext bold";
        NewHeaderRow2.Cells.Add(NewHeaderRow2Cell1);
        NewHeader.Rows.Add(NewHeaderRow2);
 
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
        NewDocHeader.CellSpacing = 0;
        NewDocHeader.CellPadding = 0;
        // build the lines
        TableRow NewDocHeaderRow0 = new TableRow();
        NewDocHeaderRow0.VerticalAlign = VerticalAlign.Bottom;
        TableCell NewDocHeaderRow0Cell1 = new TableCell();
        NewDocHeaderRow0Cell1.CssClass = "largetext botTopBord";
        NewDocHeaderRow0Cell1.Text = "COMPONENT ITEMS";
        NewDocHeaderRow0Cell1.HorizontalAlign = HorizontalAlign.Center;
        NewDocHeaderRow0Cell1.ColumnSpan = 9;
        NewDocHeaderRow0.Cells.Add(NewDocHeaderRow0Cell1);
        NewDocHeader.Rows.Add(NewDocHeaderRow0);

        TableRow NewDocHeaderRow1 = new TableRow();
        NewDocHeaderRow1.VerticalAlign = VerticalAlign.Bottom;
        TableCell NewDocHeaderRow1Cell1 = new TableCell();
        NewDocHeaderRow1Cell1.CssClass = "smalltext bold botBord";
        NewDocHeaderRow1Cell1.Text = "PART NUMBER";
        NewDocHeaderRow1Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewDocHeaderRow1Cell1.Width = Unit.Percentage(DetColWid[0]);
        NewDocHeaderRow1.Cells.Add(NewDocHeaderRow1Cell1);
        TableCell NewDocHeaderRow1Cell2 = new TableCell();
        NewDocHeaderRow1Cell2.CssClass = "smalltext bold botBord";
        NewDocHeaderRow1Cell2.Text = "SIZE";
        NewDocHeaderRow1Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewDocHeaderRow1Cell2.Width = Unit.Percentage(DetColWid[1]);
        NewDocHeaderRow1.Cells.Add(NewDocHeaderRow1Cell2);
        TableCell NewDocHeaderRow1Cell3 = new TableCell();
        NewDocHeaderRow1Cell3.CssClass = "smalltext bold botBord";
        NewDocHeaderRow1Cell3.Text = "DESCRIPTION";
        NewDocHeaderRow1Cell3.HorizontalAlign = HorizontalAlign.Left;
        NewDocHeaderRow1Cell3.Width = Unit.Percentage(DetColWid[2]);
        NewDocHeaderRow1.Cells.Add(NewDocHeaderRow1Cell3);
        TableCell NewDocHeaderRow1Cell4 = new TableCell();
        NewDocHeaderRow1Cell4.CssClass = "smalltext bold botBord";
        NewDocHeaderRow1Cell4.Text = "PLTD.";
        NewDocHeaderRow1Cell4.HorizontalAlign = HorizontalAlign.Right;
        NewDocHeaderRow1Cell4.Width = Unit.Percentage(DetColWid[3]);
        NewDocHeaderRow1.Cells.Add(NewDocHeaderRow1Cell4);
        TableCell NewDocHeaderRow1Cell5 = new TableCell();
        NewDocHeaderRow1Cell5.CssClass = "smalltext bold botBord";
        NewDocHeaderRow1Cell5.Text = "Pick";
        NewDocHeaderRow1Cell5.HorizontalAlign = HorizontalAlign.Right;
        NewDocHeaderRow1Cell5.Width = Unit.Percentage(DetColWid[4]);
        NewDocHeaderRow1.Cells.Add(NewDocHeaderRow1Cell5);
        TableCell NewDocHeaderRow1Cell5A = new TableCell();
        NewDocHeaderRow1Cell5A.CssClass = "smalltext bold botBord";
        NewDocHeaderRow1Cell5A.Text = "Picked";
        NewDocHeaderRow1Cell5A.HorizontalAlign = HorizontalAlign.Right;
        NewDocHeaderRow1Cell5A.Width = Unit.Percentage(DetColWid[5]);
        NewDocHeaderRow1.Cells.Add(NewDocHeaderRow1Cell5A);
        TableCell NewDocHeaderRow1Cell6 = new TableCell();
        NewDocHeaderRow1Cell6.CssClass = "smalltext bold botBord rightPad";
        NewDocHeaderRow1Cell6.Text = "TOTAL UNITS";
        NewDocHeaderRow1Cell6.HorizontalAlign = HorizontalAlign.Right;
        NewDocHeaderRow1Cell6.Width = Unit.Percentage(DetColWid[6]);
        NewDocHeaderRow1.Cells.Add(NewDocHeaderRow1Cell6);
        TableCell NewDocHeaderRow1Cell7 = new TableCell();
        NewDocHeaderRow1Cell7.CssClass = "smalltext bold botBord";
        NewDocHeaderRow1Cell7.Text = "QTY PER ";
        NewDocHeaderRow1Cell7.HorizontalAlign = HorizontalAlign.Right;
        NewDocHeaderRow1Cell7.Width = Unit.Percentage(DetColWid[7]);
        NewDocHeaderRow1.Cells.Add(NewDocHeaderRow1Cell7);
        TableCell NewDocHeaderRow1Cell8 = new TableCell();
        NewDocHeaderRow1Cell8.CssClass = "smalltext bold botBord rightPad";
        NewDocHeaderRow1Cell8.Text = "LBS/PER";
        NewDocHeaderRow1Cell8.HorizontalAlign = HorizontalAlign.Right;
        NewDocHeaderRow1Cell8.Width = Unit.Percentage(DetColWid[8]);
        NewDocHeaderRow1.Cells.Add(NewDocHeaderRow1Cell8);
        NewDocHeader.Rows.Add(NewDocHeaderRow1);
        /**/
        HdrDocCell.Controls.Add(NewDocHeader);
        HdrDocCell.ID = "XHeaderDoc" + PageNo.ToString();
        th2.Cells.Add(HdrDocCell);
        return th2;
    }

    TableRow MakeFinished()
    {
        //Build the document footer
        TableRow th3 = new TableRow();
        TableCell HdrDtlCell = new TableCell();
        Table NewDtlHeader = new Table();
        NewDtlHeader.ID = "NewDtlHeader" + PageNo.ToString();
        NewDtlHeader.Width = Unit.Percentage(100);
        NewDtlHeader.CellSpacing = 0;
        NewDtlHeader.CellPadding = 0;
        // build the lines
        TableRow NewDtlHeaderRow0 = new TableRow();
        NewDtlHeaderRow0.VerticalAlign = VerticalAlign.Bottom;
        TableCell NewDtlHeaderRow0Cell1 = new TableCell();
        NewDtlHeaderRow0Cell1.CssClass = "largetext bold topBord";
        NewDtlHeaderRow0Cell1.Text = "FINISHED ITEM";
        NewDtlHeaderRow0Cell1.HorizontalAlign = HorizontalAlign.Center;
        NewDtlHeaderRow0Cell1.ColumnSpan = 5;
        NewDtlHeaderRow0Cell1.Width = Unit.Percentage(FinColWid[0] + FinColWid[1] + FinColWid[2] + FinColWid[3] + FinColWid[4]);
        NewDtlHeaderRow0.Cells.Add(NewDtlHeaderRow0Cell1);
        TableCell NewDtlHeaderRow0Cell3 = new TableCell();
        NewDtlHeaderRow0Cell3.CssClass = "largetext bold rightPad topBord";
        NewDtlHeaderRow0Cell3.Text = FormatData(Num0Format, PcTotal) + " Pcs";
        NewDtlHeaderRow0Cell3.Width = Unit.Percentage(FinColWid[5]);
        NewDtlHeaderRow0.Cells.Add(NewDtlHeaderRow0Cell3);
        NewDtlHeader.Rows.Add(NewDtlHeaderRow0);
        
        TableRow NewDtlHeaderRow1 = new TableRow();
        NewDtlHeaderRow1.VerticalAlign = VerticalAlign.Top;
        TableCell NewDtlHeaderRow1Cell1 = new TableCell();
        NewDtlHeaderRow1Cell1.CssClass = "bold botBord";
        NewDtlHeaderRow1Cell1.Text = dtLine.Rows[0]["ItemNo"].ToString();
        NewDtlHeaderRow1Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewDtlHeaderRow1Cell1.Width = Unit.Percentage(FinColWid[0]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell1);
        TableCell NewDtlHeaderRow1Cell2 = new TableCell();
        NewDtlHeaderRow1Cell2.CssClass = "bold botBord";
        NewDtlHeaderRow1Cell2.Text = dtLine.Rows[0]["ItemSize"].ToString(); 
        NewDtlHeaderRow1Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewDtlHeaderRow1Cell2.Width = Unit.Percentage(FinColWid[1]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell2);
        TableCell NewDtlHeaderRow1Cell3 = new TableCell();
        NewDtlHeaderRow1Cell3.CssClass = "bold botBord";
        NewDtlHeaderRow1Cell3.Text = dtLine.Rows[0]["CatDesc"].ToString();
        NewDtlHeaderRow1Cell3.HorizontalAlign = HorizontalAlign.Left;
        NewDtlHeaderRow1Cell3.Width = Unit.Percentage(FinColWid[2]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell3);
        TableCell NewDtlHeaderRow1Cell4 = new TableCell();
        NewDtlHeaderRow1Cell4.CssClass = "bold botBord";
        NewDtlHeaderRow1Cell4.Text = dtLine.Rows[0]["Finish"].ToString();
        NewDtlHeaderRow1Cell4.HorizontalAlign = HorizontalAlign.Right;
        NewDtlHeaderRow1Cell4.Width = Unit.Percentage(FinColWid[3]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell4);
        TableCell NewDtlHeaderRow1Cell5 = new TableCell();
        NewDtlHeaderRow1Cell5.CssClass = "bold botBord";
        NewDtlHeaderRow1Cell5.Text = FormatData(Num0Format, dtLine.Rows[0]["QtyOrdered"]) + dtLine.Rows[0]["BaseQtyUM"].ToString();
        NewDtlHeaderRow1Cell5.HorizontalAlign = HorizontalAlign.Right;
        NewDtlHeaderRow1Cell5.Width = Unit.Percentage(FinColWid[4]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell5);
        TableCell NewDtlHeaderRow1Cell7 = new TableCell();
        NewDtlHeaderRow1Cell7.CssClass = "bold botBord rightPad";
        NewDtlHeaderRow1Cell7.Text = FormatData(Num1Format, WghtTotal) + " LBS";
        NewDtlHeaderRow1Cell7.Width = Unit.Percentage(FinColWid[5]);
        NewDtlHeaderRow1.Cells.Add(NewDtlHeaderRow1Cell7);
        NewDtlHeader.Rows.Add(NewDtlHeaderRow1);
 
        // now create the final entry area
        TableRow NewFooterRow1 = new TableRow();
        NewFooterRow1.VerticalAlign = VerticalAlign.Top;
        TableCell NewFooterRow1Cell1 = new TableCell();
        NewFooterRow1Cell1.CssClass = "rightCol botBord";
        NewFooterRow1Cell1.ColumnSpan = 2;
        // create the first left footer
        Table LeftFooter1 = new Table();
        TableRow LF1R1 = new TableRow();
        TableCell LF1R1Cell1 = new TableCell();
        if (decimal.TryParse(dtLine.Rows[0]["SuperEquivQty"].ToString(), out SuperEquivQty))
        {
            NewFooterRow1Cell1.Text = "<span class='medtext bold'>Boxes Per " + dtLine.Rows[0]["SuperEquivUM"].ToString()
                + ": " + FormatData(Num0Format, dtLine.Rows[0]["SuperEquivQty"]);
        }
        else
        {
            NewFooterRow1Cell1.Text = "<span class='medtext bold'>Boxes Per " + dtLine.Rows[0]["SuperEquivUM"].ToString()
                + ": 0";
        }
        if (int.TryParse(dtLine.Rows[0]["SellStkUMQty"].ToString(), out SellStkUMQty))
        {
            NewFooterRow1Cell1.Text += "<BR>Qty Per " + dtLine.Rows[0]["BaseQtyUM"].ToString()
                + " = " + FormatData(Num0Format, dtLine.Rows[0]["SellStkUMQty"]) + "<BR>";
        }
        else
        {
            NewFooterRow1Cell1.Text += "<BR>Qty Per " + dtLine.Rows[0]["BaseQtyUM"].ToString()
                + " = 0<BR>";
        }
        if (int.TryParse(dtLine.Rows[0]["SellStkUMQty"].ToString(), out SellStkUMQty) &&
            decimal.TryParse(dtLine.Rows[0]["SuperEquivQty"].ToString(), out SuperEquivQty))
        {
            NewFooterRow1Cell1.Text += "Pcs Per " + dtLine.Rows[0]["SuperEquivUM"].ToString()
                + " = " + FormatData(Num0Format, SellStkUMQty * SuperEquivQty) + "</span><BR>";
        }
        else
        {
            NewFooterRow1Cell1.Text += "Pcs Per " + dtLine.Rows[0]["SuperEquivUM"].ToString()
              + " = 0</span><BR>";
        }
        NewFooterRow1Cell1.Text += "<span class='microtext'><BR>";
        NewFooterRow1Cell1.Text += "Boxes Packed _________________ <BR><BR>";
        NewFooterRow1Cell1.Text += "Cases Packed _________________&nbsp;&nbsp;&nbsp;&nbsp;Packer _________________ </span>";
        //LF1R1Cell1.CssClass = "microtext";
        //LF1R1.Cells.Add(LF1R1Cell1);
        //LeftFooter1.Rows.Add(LF1R1);
        // now add the table
        //NewFooterRow1Cell1.Controls.Add(LeftFooter1);
        NewFooterRow1Cell1.HorizontalAlign = HorizontalAlign.Left;
        //NewFooterRow1Cell1.Width = Unit.Percentage(30);
        NewFooterRow1.Cells.Add(NewFooterRow1Cell1);
 
        TableCell NewFooterRow1Cell2 = new TableCell();
        NewFooterRow1Cell2.ColumnSpan = 2;
        NewFooterRow1Cell2.CssClass = "rightCol  botBord";
        // create the first center footer
        Table CenterFooter1 = new Table();
        TableRow CF1R1 = new TableRow();
        TableCell CF1R1Cell1 = new TableCell();
        CF1R1Cell1.Text = "PFC Lot No.";
        CF1R1Cell1.CssClass = "microtext";
        CF1R1.Cells.Add(CF1R1Cell1);
        TableCell CF1R1Cell2 = new TableCell();
        CF1R1Cell2.Text = "Mfg. I.D. No.";
        CF1R1Cell2.CssClass = "microtext";
        CF1R1.Cells.Add(CF1R1Cell2);
        TableCell CF1R1Cell3 = new TableCell();
        CF1R1Cell3.Text = "Mfg. Lot No.";
        CF1R1Cell3.CssClass = "microtext";
        CF1R1.Cells.Add(CF1R1Cell3);
        CenterFooter1.Rows.Add(CF1R1);

        TableRow CF1R2 = new TableRow();
        TableCell CF1R2Cell1 = new TableCell();
        CF1R2Cell1.Text = "______________________";
        CF1R2Cell1.CssClass = "microtext";
        CF1R2.Cells.Add(CF1R2Cell1);
        TableCell CF1R2Cell2 = new TableCell();
        CF1R2Cell2.Text = "______________________";
        CF1R2Cell2.CssClass = "microtext";
        CF1R2.Cells.Add(CF1R2Cell2);
        TableCell CF1R2Cell3 = new TableCell();
        if (CertLotNo != "")
        {
            CF1R2Cell3.Text = CertLotNo;
        }
        else
        {
            CF1R2Cell3.Text = "______________________";
        }
        CF1R2Cell3.CssClass = "microtext";
        CF1R2Cell3.HorizontalAlign = HorizontalAlign.Right;
        CF1R2.Cells.Add(CF1R2Cell3);
        CenterFooter1.Rows.Add(CF1R2);

        TableRow CF1R3 = new TableRow();
        TableCell CF1R3Cell1 = new TableCell();
        CF1R3Cell1.Text = "______________________";
        CF1R3Cell1.CssClass = "microtext";
        CF1R3.Cells.Add(CF1R3Cell1);
        TableCell CF1R3Cell2 = new TableCell();
        CF1R3Cell2.Text = "______________________";
        CF1R3Cell2.CssClass = "microtext";
        CF1R3.Cells.Add(CF1R3Cell2);
        TableCell CF1R3Cell3 = new TableCell();
        CF1R3Cell3.Text = "______________________";
        CF1R3Cell3.CssClass = "microtext";
        CF1R3Cell3.HorizontalAlign = HorizontalAlign.Right;
        CF1R3.Cells.Add(CF1R3Cell3);
        CenterFooter1.Rows.Add(CF1R3);

        TableRow CF1R4 = new TableRow();
        TableCell CF1R4Cell1 = new TableCell();
        CF1R4Cell1.Text = "______________________";
        CF1R4Cell1.CssClass = "microtext";
        CF1R4.Cells.Add(CF1R4Cell1);
        TableCell CF1R4Cell2 = new TableCell();
        CF1R4Cell2.Text = "______________________";
        CF1R4Cell2.CssClass = "microtext";
        CF1R4.Cells.Add(CF1R4Cell2);
        TableCell CF1R4Cell3 = new TableCell();
        CF1R4Cell3.Text = "______________________";
        CF1R4Cell3.CssClass = "microtext";
        CF1R4Cell3.HorizontalAlign = HorizontalAlign.Right;
        CF1R4.Cells.Add(CF1R4Cell3);
        CenterFooter1.Rows.Add(CF1R4);

        // now add the table
        NewFooterRow1Cell2.Controls.Add(CenterFooter1);
        NewFooterRow1Cell2.HorizontalAlign = HorizontalAlign.Center;
        NewFooterRow1Cell2.Width = Unit.Percentage(40);
        NewFooterRow1.Cells.Add(NewFooterRow1Cell2);
 
        TableCell NewFooterRow1Cell3 = new TableCell();
        NewFooterRow1Cell3.ColumnSpan = 2;
        NewFooterRow1Cell3.CssClass = "botBord";
        // create the first right footer
        Table RightFooter1 = new Table();
        TableRow RF1R1 = new TableRow();
        TableCell RF1R1Cell1 = new TableCell();
        RF1R1Cell1.Text = "<span class='largetext bold' style='text-align:center;'>Labels</span><BR><BR>";
        RF1R1Cell1.Text += "<span>Printed By  ____________________ <BR><BR>";
        RF1R1Cell1.Text += "Date Printed ____________________ <BR><BR>";
        RF1R1Cell1.Text += "Number Printed ____________________ </span>";
        RF1R1Cell1.CssClass = "microtext";
        RF1R1.Cells.Add(RF1R1Cell1);
        RightFooter1.Rows.Add(RF1R1);
        NewFooterRow1Cell3.Controls.Add(RightFooter1);
        NewFooterRow1Cell3.HorizontalAlign = HorizontalAlign.Left;
        NewFooterRow1Cell3.Width = Unit.Percentage(30);
        NewFooterRow1.Cells.Add(NewFooterRow1Cell3);
        NewDtlHeader.Rows.Add(NewFooterRow1);

        TableRow NewFooterRow2 = new TableRow();
        NewFooterRow2.VerticalAlign = VerticalAlign.Top;
        TableCell NewFooterRow2Cell1 = new TableCell();
        NewFooterRow2Cell1.ColumnSpan = 2;
        NewFooterRow2Cell1.CssClass = "rightCol";
        // create the second left footer
        Table LeftFooter2 = new Table();
        TableRow LF2R1 = new TableRow();
        TableCell LF2R1Cell1 = new TableCell();
        LF2R1Cell1.Text = "";
        LF2R1Cell1.CssClass = "docTitle bold";
        LF2R1Cell1.VerticalAlign = VerticalAlign.Top;
        //LF2R1Cell1.RowSpan = 4;
        foreach (DataRow cdr in dtComment.Rows)
        {
            LF2R1Cell1.Text += cdr["CommText"].ToString() + "<BR>";
        }
        LF2R1.Cells.Add(LF2R1Cell1);
        LeftFooter2.Rows.Add(LF2R1);

        //TableCell LF2R1Cell2 = new TableCell();
        //LF2R1Cell2.Text = "<BR>_______________________________";
        //LF2R1Cell2.CssClass = "microtext";
        //LF2R1.Cells.Add(LF2R1Cell2);

        //TableRow LF2R2 = new TableRow();
        //TableCell LF2R2Cell2 = new TableCell();
        //LF2R2Cell2.Text = "_______________________________";
        //LF2R2Cell2.CssClass = "microtext";
        //LF2R2.Cells.Add(LF2R2Cell2);
        //LeftFooter2.Rows.Add(LF2R2);

        //TableRow LF2R3 = new TableRow();
        //TableCell LF2R3Cell2 = new TableCell();
        //LF2R3Cell2.Text = "_______________________________";
        //LF2R3Cell2.CssClass = "microtext";
        //LF2R3.Cells.Add(LF2R3Cell2);
        //LeftFooter2.Rows.Add(LF2R3);

        //TableRow LF2R4 = new TableRow();
        //TableCell LF2R4Cell2 = new TableCell();
        //LF2R4Cell2.Text = "_______________________________";
        //LF2R4Cell2.CssClass = "microtext";
        //LF2R4.Cells.Add(LF2R4Cell2);
        //LeftFooter2.Rows.Add(LF2R4);
        // now add the table
        NewFooterRow2Cell1.Controls.Add(LeftFooter2);
        NewFooterRow2Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewFooterRow2.Cells.Add(NewFooterRow2Cell1);

        TableCell NewFooterRow2Cell2 = new TableCell();
        NewFooterRow2Cell2.ColumnSpan = 2;
        NewFooterRow2Cell2.CssClass = "rightCol";
        NewFooterRow2Cell2.Text = "<span class='medtext bold' style='text-align:center;'>Country of Origin</span>";
        NewFooterRow2Cell2.Text += "<P>________________________________________</P>";
        NewFooterRow2Cell2.HorizontalAlign = HorizontalAlign.Center;
        NewFooterRow2.Cells.Add(NewFooterRow2Cell2);

        TableCell NewFooterRow2Cell3 = new TableCell();
        NewFooterRow2Cell3.ColumnSpan = 2;
        NewFooterRow2Cell3.Text = "<span class='medtext leftPad bold'>Notes:</span><BR>";
        NewFooterRow2Cell3.Text += "_________________________<BR>";
        NewFooterRow2Cell3.Text += "_________________________<BR>";
        NewFooterRow2Cell3.Text += "_________________________";
        NewFooterRow2Cell3.HorizontalAlign = HorizontalAlign.Center;
        NewFooterRow2Cell3.VerticalAlign = VerticalAlign.Middle;
        NewFooterRow2.Cells.Add(NewFooterRow2Cell3);
        NewDtlHeader.Rows.Add(NewFooterRow2);

        TableRow NewFooterRow3 = new TableRow();
        NewFooterRow3.VerticalAlign = VerticalAlign.Bottom;
        TableCell NewFooterRow3Cell1 = new TableCell();
        NewFooterRow3Cell1.ColumnSpan = 6;
        NewFooterRow3Cell1.VerticalAlign = VerticalAlign.Bottom;
        NewFooterRow3Cell1.HorizontalAlign = HorizontalAlign.Right;
        NewFooterRow3Cell1.Height = Unit.Pixel(200);
        //NewFooterRow3Cell1.CssClass = "barclip1";
        NewFooterRow3Cell1.CssClass = "barcode";
        NewFooterRow3Cell1.Text = "*" + dtLine.Rows[0]["ItemNo"].ToString() + "*";
        //Image imgFinishedPartBarCode = new Image();
        //imgFinishedPartBarCode.ImageUrl = "Barcode.aspx?Code=" + dtLine.Rows[0]["ItemNo"].ToString() + "&WidthFactor=22";
        //NewFooterRow3Cell1.Controls.Add(imgFinishedPartBarCode);
        NewFooterRow3.Cells.Add(NewFooterRow3Cell1);
        NewDtlHeader.Rows.Add(NewFooterRow3);

        TableRow NewFooterRow4 = new TableRow();
        NewFooterRow4.VerticalAlign = VerticalAlign.Bottom;
        TableCell NewFooterRow4Cell1 = new TableCell();
        NewFooterRow4Cell1.ColumnSpan = 6;
        NewFooterRow4Cell1.VerticalAlign = VerticalAlign.Bottom;
        NewFooterRow4Cell1.HorizontalAlign = HorizontalAlign.Right;
        NewFooterRow4Cell1.Text = dtLine.Rows[0]["ItemNo"].ToString()
            + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
        NewFooterRow4.Cells.Add(NewFooterRow4Cell1);
        NewDtlHeader.Rows.Add(NewFooterRow4);

        
        /**/
        HdrDtlCell.Controls.Add(NewDtlHeader);
        HdrDtlCell.ID = "XFooter" + PageNo.ToString();
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
        NewDetailRow1Cell1.Text = DetRow["ItemNo"].ToString();
        NewDetailRow1Cell1.HorizontalAlign = HorizontalAlign.Left;
        NewDetailRow1Cell1.Width = Unit.Percentage(DetColWid[0]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell1);
        
        TableCell NewDetailRow1Cell2 = new TableCell();
        NewDetailRow1Cell2.Text = DetRow["ItemSize"].ToString();
        NewDetailRow1Cell2.HorizontalAlign = HorizontalAlign.Left;
        NewDetailRow1Cell2.Width = Unit.Percentage(DetColWid[1]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell2);
        
        TableCell NewDetailRow1Cell3 = new TableCell();
        NewDetailRow1Cell3.Text = DetRow["CatDesc"].ToString();
        NewDetailRow1Cell3.HorizontalAlign = HorizontalAlign.Left;
        NewDetailRow1Cell3.Width = Unit.Percentage(DetColWid[2]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell3);
        
        TableCell NewDetailRow1Cell4 = new TableCell();
        NewDetailRow1Cell4.Text = DetRow["Finish"].ToString();
        NewDetailRow1Cell4.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell4.CssClass = "bold";
        NewDetailRow1Cell4.Width = Unit.Percentage(DetColWid[3]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell4);

        TableCell NewDetailRow1Cell5 = new TableCell();
        NewDetailRow1Cell5.Text = FormatData(Num0Format, DetRow["PickQty"]);
        NewDetailRow1Cell5.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell5.Width = Unit.Percentage(DetColWid[4]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell5);

        TableCell NewDetailRow1Cell5A = new TableCell();
        NewDetailRow1Cell5A.Text = FormatData(Num0Format, DetRow["PickedQty"]);
        NewDetailRow1Cell5A.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell5A.Width = Unit.Percentage(DetColWid[5]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell5A);

        TableCell NewDetailRow1Cell6 = new TableCell();
        NewDetailRow1Cell6.Text = FormatData(Num0Format, DetRow["ExtendedQty"]);
        NewDetailRow1Cell6.CssClass = "rightPad rightCol";
        NewDetailRow1Cell6.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell6.Width = Unit.Percentage(DetColWid[6]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell6);
        
        TableCell NewDetailRow1Cell7 = new TableCell();
        NewDetailRow1Cell7.Text = FormatData(Num0Format, DetRow["QtyPer"]);
        NewDetailRow1Cell7.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell7.Width = Unit.Percentage(DetColWid[7]);
        NewDetailRow1.Cells.Add(NewDetailRow1Cell7);
        
        TableCell NewDetailRow1Cell8 = new TableCell();
        NewDetailRow1Cell8.Text = FormatData(Num2Format, DetRow["NetWght"]);
        NewDetailRow1Cell8.HorizontalAlign = HorizontalAlign.Right;
        NewDetailRow1Cell8.CssClass = "rightPad";
        NewDetailRow1Cell8.Width = Unit.Percentage(DetColWid[8]);
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
