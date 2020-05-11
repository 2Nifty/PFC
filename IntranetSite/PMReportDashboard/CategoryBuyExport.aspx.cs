using System;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Printing;
using System.Configuration;
using System.Collections;
using System.Collections.Specialized;
using System.Globalization;
using System.IO;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;

public partial class CategoryBuyExport : System.Web.UI.Page
{
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    int pageCtr = 1;
    int lineCtr = 0;
    int lastRow;
    DateTime PrintTime = DateTime.Now;
    Decimal ANetTotal, AEstCostTotal;
    private string Num0Format = "{0:####,###,##0} ";
    private string Num1Format = "{0:####,###,##0.0} ";
    private string Num2Format = "{0:####,###,##0.00} ";
    private string Num3Format = "{0:####,###,##0.000} ";
    private string DollarFormat = "${0:#,##0.00} ";
    private string Dollar3Format = "${0:#,##0.000} ";
    private string PcntFormat = "{0:#,##0.0}% ";
    private string DateFormat = "{0:ddd. MM/dd/yy hh:mmtt} ";
    private string Filler = "&nbsp;";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["CatBuyTable"] == null)
        {
            ds = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "pCategoryBuyData",
                    new SqlParameter("@BegCFVC", "A"),
                    new SqlParameter("@EndCFVC", "D"));
            Session["CatBuyTable"] = FixData(ds.Tables[0]);
        }
        dt = (DataTable)Session["CatBuyTable"];
        CreateCatBuyReport();
    }

    private DataTable FixData(DataTable CatBuyData)
    {
        DataRow TotRow = CatBuyData.NewRow();
        DataSet dsFixed = new System.Data.DataSet();
        Decimal TotAvgUseLB = 0;
        Decimal TotAvlLB = 0;
        Decimal TotOWLB = 0;
        Decimal TotOOLB = 0;
        Decimal TotalLB = 0;
        Decimal TotBuyLB = 0;
        Decimal TotBuyMO = 0;
        Decimal TotAvlMO = 0;
        Decimal TotOWMO = 0;
        Decimal TotOOMO = 0;
        Decimal TotalMO = 0;
        foreach (System.Data.DataRow row in CatBuyData.Rows)
        {
            if (row["CVC"].ToString().Trim().Length == 0)
            {
                TotAvgUseLB += decimal.Parse(row["AvgUseLbs"].ToString(), NumberStyles.Number);
                TotAvlLB += decimal.Parse(row["Avail_Wgt"].ToString(), NumberStyles.Number);
                TotOWLB += decimal.Parse(row["OW_Wgt"].ToString(), NumberStyles.Number);
                TotOOLB += decimal.Parse(row["OO_Wgt"].ToString(), NumberStyles.Number);
                TotalLB += decimal.Parse(row["TotalLbs"].ToString(), NumberStyles.Number);
                TotBuyLB += decimal.Parse(row["BuyLbs"].ToString(), NumberStyles.Number);
            }
        }
        TotAvlMO = TotAvlLB / TotAvgUseLB;
        TotOWMO = TotOWLB / TotAvgUseLB;
        TotOOMO = TotOOLB / TotAvgUseLB;
        TotalMO = TotalLB / TotAvgUseLB;
        TotBuyMO = TotBuyLB / TotAvgUseLB;
        //TotRow["GrpNo"] = 0;
        TotRow["GrpName"] = "Total";
        TotRow["AvgUseLbs"] = TotAvgUseLB;
        TotRow["Avail_Wgt"] = TotAvlLB;
        TotRow["AvailMonths"] = TotAvlMO;
        TotRow["OW_Wgt"] = TotOWLB;
        TotRow["OWMonths"] = TotOWMO;
        TotRow["OO_Wgt"] = TotOOLB;
        TotRow["OOMonths"] = TotOOMO;
        TotRow["TotalLbs"] = TotalLB;
        TotRow["TotalMonths"] = TotalMO;
        TotRow["BuyLbs"] = TotBuyLB;
        TotRow["BuyMonths"] = TotBuyMO;
        TotRow["GrandTotalMonths"] = TotalMO + TotBuyMO;
        CatBuyData.Rows.Add(TotRow);
        return CatBuyData;
    }

    public void CreateCatBuyReport()
    {
        string cellclass = "GridItem";
        string cellGroupclass = "rightBorder";
        int LocColSpan = 0;
        RepTable.CellSpacing = 0;
        RepTable.CellPadding = 0;
        RepTable.CssClass = "GridItem";
        CreateHeading();
        foreach (DataRow row in dt.Rows)
        {
            if (row["CVC"].ToString().Trim().Length == 0)
            {
                // build the main grid
                cellclass = "GridItem";
                cellGroupclass = "rightBorder";
                LocColSpan = 1;
                // set totals
                if (row["GrpName"].ToString() == "Total")
                {
                    cellclass = "TotBord";
                    cellGroupclass = "TotBordGroup";
                }
                TableRow GridDetRow = new TableRow();
                GridDetRow.HorizontalAlign = HorizontalAlign.Right;
                TableCell GridDetCell01 = new TableCell();
                GridDetCell01.Text = row["GrpNo"].ToString();
                GridDetCell01.HorizontalAlign = HorizontalAlign.Center;
                GridDetCell01.ColumnSpan = LocColSpan;
                GridDetCell01.CssClass = cellclass;
                GridDetRow.Cells.Add(GridDetCell01);
                TableCell GridDetCell03 = new TableCell();
                GridDetCell03.Text = row["GrpName"].ToString();
                GridDetCell03.CssClass = cellGroupclass;
                GridDetCell03.HorizontalAlign = HorizontalAlign.Left;
                GridDetRow.Cells.Add(GridDetCell03);
                TableCell GridDetCell04 = new TableCell();
                GridDetCell04.Text = string.Format(Num1Format, row["MonthsBuyFactor"]);
                GridDetCell04.CssClass = cellclass;
                GridDetRow.Cells.Add(GridDetCell04);
                TableCell GridDetCell05 = new TableCell();
                GridDetCell05.Text = string.Format(Num0Format, row["AvgUseLbs"]);
                GridDetCell05.CssClass = cellGroupclass;
                GridDetRow.Cells.Add(GridDetCell05);
                TableCell GridDetCell06 = new TableCell();
                GridDetCell06.Text = string.Format(Num0Format, row["Avail_Wgt"]);
                GridDetCell06.CssClass = cellclass;
                GridDetRow.Cells.Add(GridDetCell06);
                TableCell GridDetCell07 = new TableCell();
                GridDetCell07.Text = string.Format(Num1Format, row["AvailMonths"]);
                GridDetCell07.CssClass = cellGroupclass;
                GridDetRow.Cells.Add(GridDetCell07);
                TableCell GridDetCell08 = new TableCell();
                GridDetCell08.Text = string.Format(Num0Format, row["OW_Wgt"]);
                GridDetCell08.CssClass = cellclass;
                GridDetRow.Cells.Add(GridDetCell08);
                TableCell GridDetCell09 = new TableCell();
                GridDetCell09.Text = string.Format(Num1Format, row["OWMonths"]);
                GridDetCell09.CssClass = cellGroupclass;
                GridDetRow.Cells.Add(GridDetCell09);
                TableCell GridDetCell10 = new TableCell();
                GridDetCell10.Text = string.Format(Num0Format, row["OO_Wgt"]);
                GridDetCell10.CssClass = cellclass;
                GridDetRow.Cells.Add(GridDetCell10);
                TableCell GridDetCell11 = new TableCell();
                GridDetCell11.Text = string.Format(Num1Format, row["OOMonths"]);
                GridDetCell11.CssClass = cellGroupclass;
                GridDetRow.Cells.Add(GridDetCell11);
                TableCell GridDetCell12 = new TableCell();
                GridDetCell12.Text = string.Format(Num0Format, row["TotalLbs"]);
                GridDetCell12.CssClass = cellclass;
                GridDetRow.Cells.Add(GridDetCell12);
                TableCell GridDetCell13 = new TableCell();
                GridDetCell13.Text = string.Format(Num1Format, row["TotalMonths"]);
                GridDetCell13.CssClass = cellGroupclass;
                GridDetRow.Cells.Add(GridDetCell13);
                TableCell GridDetCell14 = new TableCell();
                GridDetCell14.Text = string.Format(Num0Format, row["BuyLbs"]);
                GridDetCell14.CssClass = cellclass;
                GridDetRow.Cells.Add(GridDetCell14);
                TableCell GridDetCell15 = new TableCell();
                GridDetCell15.Text = string.Format(Num1Format, row["BuyMonths"]);
                GridDetCell15.CssClass = cellGroupclass;
                GridDetRow.Cells.Add(GridDetCell15);
                TableCell GridDetCell16 = new TableCell();
                GridDetCell16.Text = string.Format(Num1Format, row["GrandTotalMonths"]);
                GridDetCell16.CssClass = cellclass;
                GridDetRow.Cells.Add(GridDetCell16);
                TableCell GridDetCell17 = new TableCell();
                GridDetCell17.Text = "";
                GridDetCell17.CssClass = cellGroupclass;
                GridDetRow.Cells.Add(GridDetCell17);
                RepTable.Rows.Add(GridDetRow);
                lineCtr++;
                if (lineCtr % 35 == 0)
                {
                    CreateHeading();
                }
            }
        }
    }

    public void CreateHeading()
    {
        // create grid column heading
        TableRow GridHdr1Row = new TableRow();
        GridHdr1Row.HorizontalAlign = HorizontalAlign.Center;
        GridHdr1Row.VerticalAlign = VerticalAlign.Bottom;
        TableCell GridHdr1Cell01 = new TableCell();
        GridHdr1Cell01.Text = "Printed: " + string.Format(DateFormat, PrintTime) + Filler + Filler + Filler + Filler + " Page: " + string.Format(Num0Format, pageCtr);
        GridHdr1Cell01.ColumnSpan = 16;
        GridHdr1Cell01.HorizontalAlign = HorizontalAlign.Right;
        if (pageCtr > 1)
        {
            GridHdr1Cell01.CssClass = "NewPage";
        }
        GridHdr1Row.Cells.Add(GridHdr1Cell01);
        TableRow GridHdr2Row = new TableRow();
        GridHdr2Row.HorizontalAlign = HorizontalAlign.Center;
        GridHdr2Row.VerticalAlign = VerticalAlign.Bottom;
        TableCell GridHdr2Cell01 = new TableCell();
        GridHdr2Cell01.Text = "Category Group Buy Report";
        GridHdr2Cell01.ColumnSpan = 16;
        GridHdr2Cell01.CssClass = "noData";
        GridHdr2Row.Cells.Add(GridHdr2Cell01);
        // now build 2 rows of headings
        TableRow GridHdr3Row = new TableRow();
        GridHdr3Row.HorizontalAlign = HorizontalAlign.Center;
        GridHdr3Row.VerticalAlign = VerticalAlign.Bottom;
        TableCell GridHdr3Cell01 = new TableCell();
        GridHdr3Cell01.Text = "Category Group";
        GridHdr3Cell01.ColumnSpan = 2;
        GridHdr3Cell01.RowSpan = 2;
        GridHdr3Cell01.CssClass = "rightBorder bottomBorder";
        GridHdr3Row.Cells.Add(GridHdr3Cell01);
        TableCell GridHdr3Cell02 = new TableCell();
        GridHdr3Cell02.Text = "Buy<br />Factor";
        GridHdr3Cell02.RowSpan = 2;
        GridHdr3Cell02.CssClass = "bottomBorder";
        GridHdr3Row.Cells.Add(GridHdr3Cell02);
        TableCell GridHdr3Cell03 = new TableCell();
        GridHdr3Cell03.Text = "AvgUse<br />LBS";
        GridHdr3Cell03.RowSpan = 2;
        GridHdr3Cell03.CssClass = "rightBorder bottomBorder";
        GridHdr3Row.Cells.Add(GridHdr3Cell03);
        TableCell GridHdr3Cell04 = new TableCell();
        GridHdr3Cell04.Text = "Available";
        GridHdr3Cell04.ColumnSpan = 2;
        GridHdr3Cell04.CssClass = "rightBorder";
        GridHdr3Row.Cells.Add(GridHdr3Cell04);
        TableCell GridHdr3Cell05 = new TableCell();
        GridHdr3Cell05.Text = "On The Water";
        GridHdr3Cell05.ColumnSpan = 2;
        GridHdr3Cell05.CssClass = "rightBorder";
        GridHdr3Row.Cells.Add(GridHdr3Cell05);
        TableCell GridHdr3Cell06 = new TableCell();
        GridHdr3Cell06.Text = "On Order";
        GridHdr3Cell06.ColumnSpan = 2;
        GridHdr3Cell06.CssClass = "rightBorder";
        GridHdr3Row.Cells.Add(GridHdr3Cell06);
        TableCell GridHdr3Cell07 = new TableCell();
        GridHdr3Cell07.Text = "Total (Avl,OW,OO)";
        GridHdr3Cell07.ColumnSpan = 2;
        GridHdr3Cell07.CssClass = "rightBorder";
        GridHdr3Row.Cells.Add(GridHdr3Cell07);
        TableCell GridHdr3Cell08 = new TableCell();
        GridHdr3Cell08.Text = "Buy";
        GridHdr3Cell08.ColumnSpan = 2;
        GridHdr3Cell08.CssClass = "rightBorder";
        GridHdr3Row.Cells.Add(GridHdr3Cell08);
        TableCell GridHdr3Cell09 = new TableCell();
        GridHdr3Cell09.Text = "Grand<br />Total<br />Months";
        GridHdr3Cell09.RowSpan = 2;
        GridHdr3Cell09.CssClass = "bottomBorder";
        GridHdr3Row.Cells.Add(GridHdr3Cell09);
        TableCell GridHdr3Cell10 = new TableCell();
        GridHdr3Cell10.Text = "Buy<br />(Blank)";
        GridHdr3Cell10.RowSpan = 2;
        GridHdr3Cell10.CssClass = "rightBorder bottomBorder";
        GridHdr3Row.Cells.Add(GridHdr3Cell10);
        // column heading
        TableRow GridHdr4Row = new TableRow();
        GridHdr4Row.HorizontalAlign = HorizontalAlign.Center;
        GridHdr4Row.VerticalAlign = VerticalAlign.Bottom;
        TableCell GridHdr4Cell01 = new TableCell();
        GridHdr4Cell01.Text = "LBS";
        GridHdr4Cell01.VerticalAlign = VerticalAlign.Bottom;
        GridHdr4Cell01.CssClass = "bottomBorder";
        GridHdr4Row.Cells.Add(GridHdr4Cell01);
        TableCell GridHdr4Cell02 = new TableCell();
        GridHdr4Cell02.Text = "Months";
        GridHdr4Cell02.VerticalAlign = VerticalAlign.Bottom;
        GridHdr4Cell02.CssClass = "rightBorder bottomBorder";
        GridHdr4Row.Cells.Add(GridHdr4Cell02);
        TableCell GridHdr4Cell03 = new TableCell();
        GridHdr4Cell03.Text = "LBS";
        GridHdr4Cell03.VerticalAlign = VerticalAlign.Bottom;
        //GridHdr4Cell03.Width = Unit.Pixel(80);
        GridHdr4Cell03.CssClass = "bottomBorder";
        GridHdr4Row.Cells.Add(GridHdr4Cell03);
        TableCell GridHdr4Cell04 = new TableCell();
        GridHdr4Cell04.Text = "Months";
        GridHdr4Cell04.VerticalAlign = VerticalAlign.Bottom;
        //GridHdr4Cell04.Width = Unit.Pixel(80);
        GridHdr4Cell04.CssClass = "rightBorder bottomBorder";
        GridHdr4Row.Cells.Add(GridHdr4Cell04);
        TableCell GridHdr4Cell05 = new TableCell();
        GridHdr4Cell05.Text = "LBS";
        GridHdr4Cell05.VerticalAlign = VerticalAlign.Bottom;
        //GridHdr4Cell05.Width = Unit.Pixel(80);
        GridHdr4Cell05.CssClass = "bottomBorder";
        GridHdr4Row.Cells.Add(GridHdr4Cell05);
        TableCell GridHdr4Cell05a = new TableCell();
        GridHdr4Cell05a.Text = "Months";
        GridHdr4Cell05a.VerticalAlign = VerticalAlign.Bottom;
        //GridHdr4Cell05a.Width = Unit.Pixel(100);
        GridHdr4Cell05a.CssClass = "rightBorder bottomBorder";
        GridHdr4Row.Cells.Add(GridHdr4Cell05a);
        TableCell GridHdr4Cell06 = new TableCell();
        GridHdr4Cell06.Text = "LBS";
        GridHdr4Cell06.VerticalAlign = VerticalAlign.Bottom;
        //GridHdr4Cell06.Width = Unit.Pixel(100);
        GridHdr4Cell06.CssClass = "bottomBorder";
        GridHdr4Row.Cells.Add(GridHdr4Cell06);
        TableCell GridHdr4Cell07 = new TableCell();
        GridHdr4Cell07.Text = "Months";
        GridHdr4Cell07.VerticalAlign = VerticalAlign.Bottom;
        //GridHdr4Cell07.Width = Unit.Pixel(100);
        GridHdr4Cell07.CssClass = "rightBorder bottomBorder";
        GridHdr4Row.Cells.Add(GridHdr4Cell07);
        TableCell GridHdr4Cell08 = new TableCell();
        GridHdr4Cell08.Text = "LBS";
        GridHdr4Cell08.VerticalAlign = VerticalAlign.Bottom;
        //GridHdr4Cell08.Width = Unit.Pixel(120);
        GridHdr4Cell08.CssClass = "bottomBorder";
        GridHdr4Row.Cells.Add(GridHdr4Cell08);
        TableCell GridHdr4Cell09 = new TableCell();
        GridHdr4Cell09.Text = "Months";
        GridHdr4Cell09.VerticalAlign = VerticalAlign.Bottom;
        //GridHdr4Cell09.Width = Unit.Pixel(100);
        GridHdr4Cell09.CssClass = "rightBorder bottomBorder";
        GridHdr4Row.Cells.Add(GridHdr4Cell09);
        // add the grid header
        RepTable.Rows.Add(GridHdr1Row);
        RepTable.Rows.Add(GridHdr2Row);
        RepTable.Rows.Add(GridHdr3Row);
        RepTable.Rows.Add(GridHdr4Row);
        pageCtr++;
    }
}
