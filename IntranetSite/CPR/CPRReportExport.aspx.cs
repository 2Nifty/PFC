using System;
using System.Data;
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

public partial class CPRReport : System.Web.UI.Page
{
    PFC.Intranet.BusinessLogicLayer.CPR cpr = new PFC.Intranet.BusinessLogicLayer.CPR();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    int pagesize = 1;
    int lastRow;
    Decimal ANetTotal, AEstCostTotal;
    private string Num0Format = "{0:####,###,##0} ";
    private string Num1Format = "{0:####,###,##0.0} ";
    private string Num2Format = "{0:####,###,##0.00} ";
    private string Num3Format = "{0:####,###,##0.000} ";
    private string DollarFormat = "${0:#,##0.00} ";
    private string Dollar3Format = "${0:#,##0.000} ";
    private string PcntFormat = "{0:#,##0.0}% ";
    private string DateFormat = "{0:MM/dd/yy} ";
    private string Filler = "&nbsp;";
    protected void Page_Load(object sender, EventArgs e)
    {
        string CurItemsFilter = Request.QueryString["RecID"];
        HiddenFactor.Value = Request.QueryString["Factor"];
        HiddenIncludeSummQtys.Value = Request.QueryString["IncludeSummQtys"];
        ReportFormat.Value = Request.QueryString["Format"];
        VMIRun.Value = Request.QueryString["VMI"];
        if (VMIRun.Value == "True")
        {
            VMIChain.Value = Request.QueryString["VChain"];
            VMIContract.Value = Request.QueryString["VContract"];
        }
        string OrderBy = Request.QueryString["Sort"];
        dt = cpr.GetCPRItems(CurItemsFilter, Request.QueryString["Factor"].ToString(), OrderBy).Tables[0];
        CreateCPRReport();
        // http://10.1.36.34/intranetsite/CPR/CPRReportExport.aspx?RecID=toms&Factor=3&Long=True&VMI=False
        // http://10.1.36.34/intranetsite/CPR/CPRReportExport.aspx?RecID=toms&Factor=3&Long=True&VMI=True&VChain=WURT&VContract=2006-01

    }

    private DataSet FixCPRData(DataTable cprData)
    {
        DataSet dsFixed = new System.Data.DataSet();
        Decimal Sub3Mo = 0;
        Decimal Tot3Mo = 0;
        Decimal Sub12Mo = 0;
        Decimal Tot12Mo = 0;
        Decimal SubUse30D = 0;
        Decimal TotUse30D = 0;
        Decimal SubAvl = 0;
        Decimal TotAvl = 0;
        Decimal SubTrf = 0;
        Decimal TotTrf = 0;
        Decimal SubOO = 0;
        Decimal TotOO = 0;
        Decimal SubOW = 0;
        Decimal TotOW = 0;
        Decimal SubOONxtQty = 0;
        Decimal TotOONxtQty = 0;
        Decimal SubOWNxtQty = 0;
        Decimal TotOWNxtQty = 0;
        Decimal SubTotalQty = 0;
        Decimal TotTotalQty = 0;
        Decimal SubFcstNeed = 0;
        Decimal TotFcstNeed = 0;
        Decimal SubNetBuy = 0;
        Decimal TotNetBuy = 0;
        Decimal SubEstBuyCost = 0;
        Decimal TotEstBuyCost = 0;
        Decimal SubMosAvl = 0;
        Decimal TotMosAvl = 0;
        Decimal SubMosTrf = 0;
        Decimal TotMosTrf = 0;
        Decimal SubMosOO = 0;
        Decimal TotMosOO = 0;
        Decimal SubMosOW = 0;
        Decimal TotMosOW = 0;
        Decimal SubMosTotal = 0;
        Decimal TotMosTotal = 0;
        Decimal SubROP = 0;
        Decimal TotROP = 0;
        cprData.Rows[lastRow]["LocationCode"] = "Total";
        ANetTotal = 0;
        AEstCostTotal = 0;
        System.Data.DataTable ATotalTable = new System.Data.DataTable("ATotals");
        ATotalTable.Columns.Add("ATitle", typeof(String));
        ATotalTable.Columns.Add("ANetTotal", typeof(Decimal));
        ATotalTable.Columns.Add("AEstCostTotal", typeof(Decimal));
        foreach (System.Data.DataRow row in cprData.Rows)
        {
            if (row["LocationCode"].ToString().Trim().Length == 2 || row["LocationCode"].ToString().Substring(0, 5) == "Child")
            {
                Sub3Mo += decimal.Parse(row["Avg3M"].ToString(), NumberStyles.Number);
                Tot3Mo += decimal.Parse(row["Avg3M"].ToString(), NumberStyles.Number);
                Sub12Mo += decimal.Parse(row["Avg12M"].ToString(), NumberStyles.Number);
                Tot12Mo += decimal.Parse(row["Avg12M"].ToString(), NumberStyles.Number);
                SubUse30D += decimal.Parse(row["Use30D"].ToString(), NumberStyles.Number);
                TotUse30D += decimal.Parse(row["Use30D"].ToString(), NumberStyles.Number);
                SubAvl += decimal.Parse(row["Avl"].ToString(), NumberStyles.Number);
                TotAvl += decimal.Parse(row["Avl"].ToString(), NumberStyles.Number);
                SubTrf += decimal.Parse(row["Trf"].ToString(), NumberStyles.Number);
                TotTrf += decimal.Parse(row["Trf"].ToString(), NumberStyles.Number);
                SubOO += decimal.Parse(row["OO"].ToString(), NumberStyles.Number);
                TotOO += decimal.Parse(row["OO"].ToString(), NumberStyles.Number);
                SubOW += decimal.Parse(row["OW"].ToString(), NumberStyles.Number);
                TotOW += decimal.Parse(row["OW"].ToString(), NumberStyles.Number);
                SubOONxtQty += decimal.Parse(row["OONxtQty"].ToString(), NumberStyles.Number);
                TotOONxtQty += decimal.Parse(row["OONxtQty"].ToString(), NumberStyles.Number);
                SubOWNxtQty += decimal.Parse(row["OWNxtQty"].ToString(), NumberStyles.Number);
                TotOWNxtQty += decimal.Parse(row["OWNxtQty"].ToString(), NumberStyles.Number);
                SubTotalQty += decimal.Parse(row["TotalQty"].ToString(), NumberStyles.Number);
                TotTotalQty += decimal.Parse(row["TotalQty"].ToString(), NumberStyles.Number);
                SubFcstNeed += decimal.Parse(row["FcstNeed"].ToString(), NumberStyles.Number);
                TotFcstNeed += decimal.Parse(row["FcstNeed"].ToString(), NumberStyles.Number);
                SubNetBuy += decimal.Parse(row["NetBuy"].ToString(), NumberStyles.Number);
                TotNetBuy += decimal.Parse(row["NetBuy"].ToString(), NumberStyles.Number);
                SubEstBuyCost += decimal.Parse(row["EstBuyCost"].ToString(), NumberStyles.Number);
                TotEstBuyCost += decimal.Parse(row["EstBuyCost"].ToString(), NumberStyles.Number);
                SubMosAvl += decimal.Parse(row["MosAvl"].ToString(), NumberStyles.Number);
                TotMosAvl += decimal.Parse(row["MosAvl"].ToString(), NumberStyles.Number);
                SubMosTrf += decimal.Parse(row["MosTrf"].ToString(), NumberStyles.Number);
                TotMosTrf += decimal.Parse(row["MosTrf"].ToString(), NumberStyles.Number);
                SubMosOO += decimal.Parse(row["MosOO"].ToString(), NumberStyles.Number);
                TotMosOO += decimal.Parse(row["MosOO"].ToString(), NumberStyles.Number);
                SubMosOW += decimal.Parse(row["MosOW"].ToString(), NumberStyles.Number);
                TotMosOW += decimal.Parse(row["MosOW"].ToString(), NumberStyles.Number);
                SubMosTotal += decimal.Parse(row["MosTotal"].ToString(), NumberStyles.Number);
                TotMosTotal += decimal.Parse(row["MosTotal"].ToString(), NumberStyles.Number);
                SubROP += decimal.Parse(row["PCROP"].ToString(), NumberStyles.Number);
                TotROP += decimal.Parse(row["PCROP"].ToString(), NumberStyles.Number);
                if ((decimal)row["NetBuy"] > 0)
                {
                    ANetTotal += (decimal)row["NetBuy"];
                    AEstCostTotal += (decimal)row["EstBuyCost"];
                }
            }
            if (row["LocationCode"].ToString().Substring(0, 2) == "Lo")
            {
                row["Avg3M"] = Sub3Mo;
                row["Avg12M"] = Sub12Mo;
                row["Use30D"] = SubUse30D;
                row["Avl"] = SubAvl;
                row["Trf"] = SubTrf;
                row["OO"] = SubOO;
                row["OW"] = SubOW;
                row["OONxtQty"] = SubOONxtQty;
                row["OWNxtQty"] = SubOWNxtQty;
                row["TotalQty"] = SubTotalQty;
                row["FcstNeed"] = SubFcstNeed;
                row["NetBuy"] = SubNetBuy;
                row["EstBuyCost"] = SubEstBuyCost;
                row["PCROP"] = SubROP;
                if (SubUse30D == 0)
                {
                    row["MosAvl"] = 0;
                    row["MosTrf"] = 0;
                    row["MosOO"] = 0;
                    row["MosOW"] = 0;
                    row["MosTotal"] = 0;
                }
                else
                {
                    row["MosAvl"] = SubAvl / SubUse30D;
                    row["MosTrf"] = SubTrf / SubUse30D;
                    row["MosOO"] = SubOO / SubUse30D;
                    row["MosOW"] = SubOW / SubUse30D;
                    row["MosTotal"] = SubTotalQty / SubUse30D;
                }
            }
            if (row["LocationCode"].ToString().Substring(1, 1) == "-")
            {
                row["Avg3M"] = Sub3Mo;
                row["Avg12M"] = Sub12Mo;
                row["Use30D"] = SubUse30D;
                row["Avl"] = SubAvl;
                row["Trf"] = SubTrf;
                row["OO"] = SubOO;
                row["OW"] = SubOW;
                row["OONxtQty"] = SubOONxtQty;
                row["OWNxtQty"] = SubOWNxtQty;
                row["TotalQty"] = SubTotalQty;
                row["FcstNeed"] = SubFcstNeed;
                row["NetBuy"] = SubNetBuy;
                row["EstBuyCost"] = SubEstBuyCost;
                row["PCROP"] = SubROP;
                if (SubUse30D == 0)
                {
                    row["MosAvl"] = 0;
                    row["MosTrf"] = 0;
                    row["MosOO"] = 0;
                    row["MosOW"] = 0;
                    row["MosTotal"] = 0;
                }
                else
                {
                    row["MosAvl"] = SubAvl / SubUse30D;
                    row["MosTrf"] = SubTrf / SubUse30D;
                    row["MosOO"] = SubOO / SubUse30D;
                    row["MosOW"] = SubOW / SubUse30D;
                    row["MosTotal"] = SubTotalQty / SubUse30D;
                }
                Sub3Mo = 0;
                Sub12Mo = 0;
                SubUse30D = 0;
                SubAvl = 0;
                SubTrf = 0;
                SubOO = 0;
                SubOW = 0;
                SubOONxtQty = 0;
                SubOWNxtQty = 0;
                SubTotalQty = 0;
                SubFcstNeed = 0;
                SubNetBuy = 0;
                SubEstBuyCost = 0;
                SubMosAvl = 0;
                SubMosTrf = 0;
                SubMosOO = 0;
                SubMosOW = 0;
                SubMosTotal = 0;
                SubROP = 0;
            }
        }
        cprData.Rows[lastRow]["Avg3M"] = Tot3Mo;
        cprData.Rows[lastRow]["Avg12M"] = Tot12Mo;
        cprData.Rows[lastRow]["Use30D"] = TotUse30D;
        cprData.Rows[lastRow]["Avl"] = TotAvl;
        cprData.Rows[lastRow]["Trf"] = TotTrf;
        cprData.Rows[lastRow]["OO"] = TotOO;
        cprData.Rows[lastRow]["OW"] = TotOW;
        cprData.Rows[lastRow]["OONxtQty"] = TotOONxtQty;
        cprData.Rows[lastRow]["OWNxtQty"] = TotOWNxtQty;
        cprData.Rows[lastRow]["TotalQty"] = TotTotalQty;
        cprData.Rows[lastRow]["FcstNeed"] = TotFcstNeed;
        cprData.Rows[lastRow]["NetBuy"] = TotNetBuy;
        cprData.Rows[lastRow]["EstBuyCost"] = TotEstBuyCost;
        cprData.Rows[lastRow]["PCROP"] = TotROP;
        if (TotUse30D == 0)
        {
            cprData.Rows[lastRow]["MosAvl"] = 0;
            cprData.Rows[lastRow]["MosTrf"] = 0;
            cprData.Rows[lastRow]["MosOO"] = 0;
            cprData.Rows[lastRow]["MosOW"] = 0;
            cprData.Rows[lastRow]["MosTotal"] = 0;
        }
        else
        {
            cprData.Rows[lastRow]["MosAvl"] = TotAvl / TotUse30D;
            cprData.Rows[lastRow]["MosTrf"] = TotTrf / TotUse30D;
            cprData.Rows[lastRow]["MosOO"] = TotOO / TotUse30D;
            cprData.Rows[lastRow]["MosOW"] = TotOW / TotUse30D;
            cprData.Rows[lastRow]["MosTotal"] = TotTotalQty / TotUse30D;
        }
        DataRow ATotalRow = ATotalTable.NewRow();
        ATotalRow["ATitle"] = "Pos:";
        ATotalRow["ANetTotal"] = ANetTotal;
        ATotalRow["AEstCostTotal"] = AEstCostTotal;
        ATotalTable.Rows.Add(ATotalRow);
        dsFixed.Tables.Add(ATotalTable);
        return dsFixed;
    }

    public void CreateCPRReport()
    {
        string cellclass = "GridItem";
        string cellGroupclass = "rightBorder";
        int pageCtr = 0;
        int LocColSpan = 0;
        RepTable.CellSpacing = 0;
        RepTable.CellPadding = 0;
        RepTable.CssClass = "GridItem";
        if (ReportFormat.Value == "Long")
        {
            //RepTable.Width = Unit.Pixel(1500);
            RepTable.Width = Unit.Percentage(100);
        };
        if (ReportFormat.Value == "Short")
        {
            //RepTable.Width = Unit.Pixel(1200);
            RepTable.Width = Unit.Percentage(100);
        };
        if (ReportFormat.Value == "Transfer")
        {
            RepTable.Width = Unit.Percentage(100);
            RepTable.CssClass = "XFerGrid";
        };
        foreach (DataRow row in dt.Rows)
        {
            TableRow ItemRow = new TableRow();
            if (pageCtr > 0)
            {
                ItemRow.CssClass = "NewPage";
            }
            TableCell ItemCell = new TableCell();
            ItemCell.Style.Add("font-size", "24px");
            ItemCell.Text = "<b>" + row["ItemNo"].ToString() + "</b>";
            ItemCell.ColumnSpan = 8;
            ItemRow.Cells.Add(ItemCell);
            System.Data.DataTable cprData = cpr.GetGPRGridData(row["ItemNo"].ToString(), decimal.Parse(HiddenFactor.Value), 
                HiddenIncludeSummQtys.Value.ToString()).Tables[0];
            if (VMIRun.Value != "True")
            {
                TableCell Hdr01Cell = new TableCell();
                Hdr01Cell.VerticalAlign = VerticalAlign.Top;
                Hdr01Cell.RowSpan = 10;
                if (ReportFormat.Value == "Transfer")
                    Hdr01Cell.RowSpan = 7;
                Hdr01Cell.ColumnSpan = 25;
                if (cprData.Rows.Count > 0)
                {
                    lastRow = cprData.Rows.Count - 1;
                    Hdr01Cell.Style.Add("font-size", "20px");
                    Hdr01Cell.Text = string.Format("Last Cost&nbsp;&nbsp;<b>{0:N3}</b>", cprData.Rows[lastRow]["Last_CostM"]);
                    Hdr01Cell.Text += string.Format("<br />Avg. Cost&nbsp;&nbsp;<b>{0:N3}</b><br /></span>", cprData.Rows[lastRow]["Avg_CostM"]);
                }
                if (ReportFormat.Value != "Transfer")
                {
                    System.Data.DataTable vendData = cpr.GetVendorData(row["ItemNo"].ToString()).Tables[0];
                    if (vendData.Rows.Count > 0)
                    {
                        Table VendorTable = new Table();
                        VendorTable.CellPadding = 0;
                        VendorTable.CellSpacing = 0;
                        VendorTable.BorderStyle = BorderStyle.None;
                        VendorTable.CssClass = "GridItem";
                        // cost data
                        TableRow CostHdrRow = new TableRow();
                        //CostHdrRow.HorizontalAlign = HorizontalAlign.Right;
                        TableCell CostHdrCell = new TableCell();
                        CostHdrCell.HorizontalAlign = HorizontalAlign.Left;
                        CostHdrCell.ColumnSpan = 12;
                        CostHdrCell.Text = Hdr01Cell.Text;
                        CostHdrRow.Cells.Add(CostHdrCell);
                        VendorTable.Rows.Add(CostHdrRow);
                        // vendor data
                        TableRow VendorHdrRow = new TableRow();
                        VendorHdrRow.HorizontalAlign = HorizontalAlign.Right;
                        TableCell VendorLocHdrCell = new TableCell();
                        VendorLocHdrCell.HorizontalAlign = HorizontalAlign.Center;
                        VendorLocHdrCell.Width = Unit.Pixel(80);
                        VendorLocHdrCell.Text = "Vend";
                        TableCell VendorCoHdrCell = new TableCell();
                        VendorCoHdrCell.Width = Unit.Pixel(30);
                        VendorCoHdrCell.Text = "Co";
                        TableCell VendorFobHdrCell = new TableCell();
                        VendorFobHdrCell.Width = Unit.Pixel(50);
                        VendorFobHdrCell.Text = "FOB";
                        TableCell VendorDiffHdrCell = new TableCell();
                        VendorDiffHdrCell.Width = Unit.Pixel(40);
                        VendorDiffHdrCell.Text = "Diff";
                        TableCell VendorDutyHdrCell = new TableCell();
                        VendorDutyHdrCell.Width = Unit.Pixel(50);
                        VendorDutyHdrCell.Text = "Duty";
                        TableCell VendorFLbHdrCell = new TableCell();
                        VendorFLbHdrCell.Width = Unit.Pixel(50);
                        VendorFLbHdrCell.Text = "F/Lb";
                        TableCell VendorLandHdrCell = new TableCell();
                        VendorLandHdrCell.Width = Unit.Pixel(50);
                        VendorLandHdrCell.Text = "Land";
                        TableCell VendorDiff2HdrCell = new TableCell();
                        VendorDiff2HdrCell.Width = Unit.Pixel(40);
                        VendorDiff2HdrCell.Text = "Diff";
                        TableCell VendorLLbHdrCell = new TableCell();
                        VendorLLbHdrCell.Width = Unit.Pixel(50);
                        VendorLLbHdrCell.Text = "L/Lb";
                        TableCell VendorCommHdrCell = new TableCell();
                        VendorCommHdrCell.Width = Unit.Pixel(50);
                        VendorCommHdrCell.Text = "Cartons";
                        VendorHdrRow.Cells.Add(VendorLocHdrCell);
                        VendorHdrRow.Cells.Add(VendorCoHdrCell);
                        VendorHdrRow.Cells.Add(VendorFobHdrCell);
                        VendorHdrRow.Cells.Add(VendorDiffHdrCell);
                        VendorHdrRow.Cells.Add(VendorDutyHdrCell);
                        VendorHdrRow.Cells.Add(VendorFLbHdrCell);
                        VendorHdrRow.Cells.Add(VendorLandHdrCell);
                        VendorHdrRow.Cells.Add(VendorDiff2HdrCell);
                        VendorHdrRow.Cells.Add(VendorLLbHdrCell);
                        VendorHdrRow.Cells.Add(VendorCommHdrCell);
                        VendorTable.Rows.Add(VendorHdrRow);
                        foreach (DataRow vendRow in vendData.Rows)
                        {
                            TableRow VendorRow = new TableRow();
                            VendorRow.HorizontalAlign = HorizontalAlign.Right;
                            TableCell VendorNameCell = new TableCell();
                            VendorNameCell.HorizontalAlign = HorizontalAlign.Left;
                            VendorNameCell.Width = Unit.Pixel(10);
                            VendorNameCell.Text = vendRow["VendorName"].ToString();
                            //TableCell VendorLocCell = new TableCell();
                            //VendorLocCell.Text = vendRow["CountryCode"].ToString();
                            TableCell VendorCoCell = new TableCell();
                            VendorCoCell.Text = vendRow["CountryCode"].ToString();
                            TableCell VendorFobCell = new TableCell();
                            VendorFobCell.Text = string.Format(Num2Format, vendRow["FOB_Cost"]);
                            TableCell VendorDiffCell = new TableCell();
                            VendorDiffCell.Text = string.Format(PcntFormat, vendRow["FOB_Diff"]);
                            TableCell VendorDutyCell = new TableCell();
                            VendorDutyCell.Text = string.Format(Num2Format, vendRow["DutyRate"]);
                            TableCell VendorFLbCell = new TableCell();
                            VendorFLbCell.Text = string.Format(Num2Format, vendRow["FOB_Wgt"]);
                            TableCell VendorLandCell = new TableCell();
                            VendorLandCell.Text = string.Format(Num2Format, vendRow["Land_Cost"]);
                            TableCell VendorDiff2Cell = new TableCell();
                            VendorDiff2Cell.Text = string.Format(PcntFormat, vendRow["Land_Diff"]);
                            TableCell VendorLLbCell = new TableCell();
                            VendorLLbCell.Text = string.Format(Num2Format, vendRow["Land_Wgt"]);
                            TableCell VendorCommCell = new TableCell();
                            VendorCommCell.Text = string.Format(Num0Format, vendRow["VendorCartons"]);
                            VendorRow.Cells.Add(VendorNameCell);
                            VendorRow.Cells.Add(VendorCoCell);
                            VendorRow.Cells.Add(VendorFobCell);
                            VendorRow.Cells.Add(VendorDiffCell);
                            VendorRow.Cells.Add(VendorDutyCell);
                            VendorRow.Cells.Add(VendorFLbCell);
                            VendorRow.Cells.Add(VendorLandCell);
                            VendorRow.Cells.Add(VendorDiff2Cell);
                            VendorRow.Cells.Add(VendorLLbCell);
                            VendorRow.Cells.Add(VendorCommCell);
                            VendorTable.Rows.Add(VendorRow);
                        }
                        Hdr01Cell.Controls.Add(VendorTable);
                    }
                    else
                    {
                        Hdr01Cell.Text += "<div class=noData>No Vendor Data Available</div>";
                    }
                }
                ItemRow.Cells.Add(Hdr01Cell);
                RepTable.Rows.Add(ItemRow);
            }
            else
            {
                RepTable.Rows.Add(ItemRow);
                // VMI Heading
                DataTable vmiData = new DataTable();
                vmiData = cpr.GetVMIContractItem(VMIChain.Value, VMIContract.Value, row["ItemNo"].ToString()).Tables[0];
                TableRow VMI01Row = new TableRow();
                TableCell VMIHdr01Cell01 = new TableCell();
                VMIHdr01Cell01.Style.Add("font-size", "20px");
                VMIHdr01Cell01.Text = "Customer";
                VMIHdr01Cell01.Width = Unit.Pixel(300);
                VMIHdr01Cell01.ColumnSpan = 3;
                VMI01Row.Cells.Add(VMIHdr01Cell01);
                TableCell VMIHdr01Cell02 = new TableCell();
                VMIHdr01Cell02.Style.Add("font-size", "20px");
                VMIHdr01Cell02.Text = "Chain";
                VMIHdr01Cell02.Width = Unit.Pixel(200);
                VMIHdr01Cell02.ColumnSpan = 3;
                VMI01Row.Cells.Add(VMIHdr01Cell02);
                TableCell VMIHdr01Cell03 = new TableCell();
                VMIHdr01Cell03.Style.Add("font-size", "20px");
                VMIHdr01Cell03.Text = "Effective";
                VMIHdr01Cell03.ColumnSpan = 24;
                //VMIHdr01Cell03.Width = Unit.Pixel(100);
                VMI01Row.Cells.Add(VMIHdr01Cell03);
                RepTable.Rows.Add(VMI01Row);
                TableRow VMI02Row = new TableRow();
                TableCell VMIHdr02Cell = new TableCell();
                VMIHdr02Cell.Text = VMIChain.Value;
                VMIHdr02Cell.Style.Add("font-size", "20px");
                VMIHdr02Cell.ColumnSpan = 3;
                VMI02Row.Cells.Add(VMIHdr02Cell);
                //RepTable.Rows.Add(VMI02Row);
                //TableRow VMI03Row = new TableRow();
                TableCell VMIHdr03Cell = new TableCell();
                VMIHdr03Cell.Text = VMIContract.Value;
                VMIHdr03Cell.Style.Add("font-size", "20px");
                VMIHdr03Cell.ColumnSpan = 3;
                VMI02Row.Cells.Add(VMIHdr03Cell);
                //RepTable.Rows.Add(VMI03Row);
                //TableRow VMI04Row = new TableRow();
                TableCell VMIHdr04Cell = new TableCell();
                VMIHdr04Cell.Text = string.Format("&nbsp;" + DateFormat + "thru ", vmiData.Rows[0]["StartDate"]);
                VMIHdr04Cell.Text += string.Format(DateFormat, vmiData.Rows[0]["EndDate"]);
                VMIHdr04Cell.ColumnSpan = 24;
                VMIHdr04Cell.Style.Add("font-size", "20px");
                VMI02Row.Cells.Add(VMIHdr04Cell);
                RepTable.Rows.Add(VMI02Row);
                TableRow VMI05Row = new TableRow();
                TableCell VMIHdr05Cell = new TableCell();
                VMIHdr05Cell.Text = "Cust PO&nbsp; " + vmiData.Rows[0]["CustomerPO"].ToString();
                VMIHdr05Cell.ColumnSpan = 8;
                VMI05Row.Cells.Add(VMIHdr05Cell);
                RepTable.Rows.Add(VMI05Row);
                TableRow VMI06Row = new TableRow();
                TableCell VMIHdr06Cell = new TableCell();
                VMIHdr06Cell.Text = "Cross Ref #&nbsp;" + vmiData.Rows[0]["CrossRef"].ToString();
                VMIHdr06Cell.ColumnSpan = 8;
                VMI06Row.Cells.Add(VMIHdr06Cell);
                RepTable.Rows.Add(VMI06Row);
                TableRow VMI07Row = new TableRow();
                TableCell VMIHdr07Cell = new TableCell();
                VMIHdr07Cell.Text = "Desc:&nbsp;" + vmiData.Rows[0]["ItemDesc"].ToString();
                VMIHdr07Cell.ColumnSpan = 8;
                VMI07Row.Cells.Add(VMIHdr07Cell);
                RepTable.Rows.Add(VMI07Row);
                TableRow VMI08Row = new TableRow();
                TableCell VMIHdr08Cell = new TableCell();
                VMIHdr08Cell.Text = "Sub Item #&nbsp;" + vmiData.Rows[0]["SubItemNo"].ToString();
                VMIHdr08Cell.ColumnSpan = 8;
                VMI08Row.Cells.Add(VMIHdr08Cell);
                RepTable.Rows.Add(VMI08Row);
                TableRow VMI09Row = new TableRow();
                TableCell VMIHdr09Cell = new TableCell();
                VMIHdr09Cell.Text = "PFC Salesperson&nbsp;" + vmiData.Rows[0]["Salesperson"].ToString();
                VMIHdr09Cell.ColumnSpan = 8;
                VMI09Row.Cells.Add(VMIHdr09Cell);
                RepTable.Rows.Add(VMI09Row);
                TableRow VMI10Row = new TableRow();
                TableCell VMIHdr10Cell = new TableCell();
                VMIHdr10Cell.Text = "Annual Usage Qty&nbsp;" + string.Format(Num0Format, vmiData.Rows[0]["EAU_Qty"]);
                VMIHdr10Cell.ColumnSpan = 8;
                VMI10Row.Cells.Add(VMIHdr10Cell);
                RepTable.Rows.Add(VMI10Row);
                TableRow VMI11Row = new TableRow();
                TableCell VMIHdr11Cell = new TableCell();
                VMIHdr11Cell.Text = "Contact&nbsp;" + vmiData.Rows[0]["Contact"].ToString() + " / " + vmiData.Rows[0]["ContactPhone"].ToString();
                VMIHdr11Cell.ColumnSpan = 8;
                VMI11Row.Cells.Add(VMIHdr11Cell);
                RepTable.Rows.Add(VMI11Row);
                TableRow VMI12Row = new TableRow();
                TableCell VMIHdr12Cell = new TableCell();
                VMIHdr12Cell.Text = "Expected GP %&nbsp;" + string.Format(Num0Format, vmiData.Rows[0]["E_Profit_Pct"]);
                VMIHdr12Cell.ColumnSpan = 8;
                VMI12Row.Cells.Add(VMIHdr12Cell);
                RepTable.Rows.Add(VMI12Row);
                TableRow VMI13Row = new TableRow();
                TableCell VMIHdr13Cell = new TableCell();
                VMIHdr13Cell.Text = "Order Method&nbsp;" + vmiData.Rows[0]["OrderMethod"].ToString();
                VMIHdr13Cell.ColumnSpan = 8;
                VMI13Row.Cells.Add(VMIHdr13Cell);
                RepTable.Rows.Add(VMI13Row);
                TableRow VMI14Row = new TableRow();
                TableCell VMIHdr14Cell = new TableCell();
                VMIHdr14Cell.Text = "Vendor Code&nbsp;" + vmiData.Rows[0]["Vendor"].ToString();
                VMIHdr14Cell.ColumnSpan = 8;
                VMI14Row.Cells.Add(VMIHdr14Cell);
                RepTable.Rows.Add(VMI14Row);
                TableRow VMI15Row = new TableRow();
                TableCell VMIHdr15Cell = new TableCell();
                VMIHdr15Cell.Text = "Month Factor&nbsp;" + string.Format(Num1Format, vmiData.Rows[0]["MonthFactor"]);
                VMIHdr15Cell.ColumnSpan = 8;
                VMI15Row.Cells.Add(VMIHdr15Cell);
                RepTable.Rows.Add(VMI15Row);

            }
            if (cprData.Rows.Count > 0)
            {
                lastRow = cprData.Rows.Count - 1;
                ds = FixCPRData(cprData);
                if (VMIRun.Value != "True")
                {
                    // standard heading
                    TableRow StdHdr01Row = new TableRow();
                    TableCell StdHdr01Cell = new TableCell();
                    StdHdr01Cell.Text = cprData.Rows[lastRow]["Description"].ToString();
                    StdHdr01Cell.ColumnSpan = 8;
                    StdHdr01Row.Cells.Add(StdHdr01Cell);
                    RepTable.Rows.Add(StdHdr01Row);
                    TableRow StdHdr02Row = new TableRow();
                    TableCell StdHdr02Cell = new TableCell();
                    StdHdr02Cell.Text = string.Format("Qty/Uom&nbsp;&nbsp;" + Num0Format, cprData.Rows[lastRow]["UOM_Qty"]) + " / "
                        + string.Format(Num0Format, cprData.Rows[lastRow]["UOM"]);
                    StdHdr02Cell.ColumnSpan = 8;
                    StdHdr02Row.Cells.Add(StdHdr02Cell);
                    RepTable.Rows.Add(StdHdr02Row);
                    if (ReportFormat.Value != "Transfer")
                    {

                        TableRow StdHdr03Row = new TableRow();
                        TableCell StdHdr03Cell = new TableCell();
                        StdHdr03Cell.Text = string.Format("Weight&nbsp;&nbsp;" + Num1Format, cprData.Rows[lastRow]["Net_Wgt"]) + " Lbs";
                        StdHdr03Cell.ColumnSpan = 8;
                        StdHdr03Row.Cells.Add(StdHdr03Cell);
                        RepTable.Rows.Add(StdHdr03Row);
                    }
                    TableRow StdHdr04Row = new TableRow();
                    TableCell StdHdr04Cell = new TableCell();
                    StdHdr04Cell.Text = string.Format("Super Eqv&nbsp;&nbsp;<b>" + Num0Format, cprData.Rows[lastRow]["SupEqv_Qty"]) + " / "
                        + string.Format(Num0Format, cprData.Rows[lastRow]["SupEqv_UOM"]);
                    StdHdr04Cell.Text += "</b>&nbsp;&nbsp;&nbsp;&nbsp;Pieces&nbsp;&nbsp;" + string.Format(Num0Format, cprData.Rows[lastRow]["SupEqv_Pcs"]) + " Pcs";
                    StdHdr04Cell.ColumnSpan = 8;
                    StdHdr04Row.Cells.Add(StdHdr04Cell);
                    RepTable.Rows.Add(StdHdr04Row);
                    if (ReportFormat.Value != "Transfer")
                    {
                        TableRow StdHdr04ARow = new TableRow();
                        TableCell StdHdr04ACell = new TableCell();
                        StdHdr04ACell.Text = string.Format("Low Profile&nbsp;&nbsp;<b>" + Num0Format, cprData.Rows[lastRow]["LowPalletQty"]) + " / "
                            + string.Format(Num0Format, cprData.Rows[lastRow]["LowPalletPcs"]) + "</b> Pcs";
                        StdHdr04ACell.ColumnSpan = 8;
                        StdHdr04ARow.Cells.Add(StdHdr04ACell);
                        RepTable.Rows.Add(StdHdr04ARow);
                        TableRow StdHdr05Row = new TableRow();
                        TableCell StdHdr05Cell = new TableCell();
                        StdHdr05Cell.Text = string.Format("Yearly Usage Weight&nbsp;&nbsp;" + Num1Format, cprData.Rows[lastRow]["Item_Use_CY_Wgt"]) + " Lbs";
                        StdHdr05Cell.ColumnSpan = 8;
                        StdHdr05Row.Cells.Add(StdHdr05Cell);
                        RepTable.Rows.Add(StdHdr05Row);
                    }
                    TableRow StdHdr06Row = new TableRow();
                    TableCell StdHdr06Cell = new TableCell();
                    StdHdr06Cell.Text = string.Format("Weight/100&nbsp;&nbsp;" + Num2Format, cprData.Rows[lastRow]["Wgt100"]);
                    StdHdr06Cell.ColumnSpan = 8;
                    StdHdr06Row.Cells.Add(StdHdr06Cell);
                    RepTable.Rows.Add(StdHdr06Row);
                    if (ReportFormat.Value != "Transfer")
                    {
                        TableRow StdHdr07Row = new TableRow();
                        TableCell StdHdr07Cell = new TableCell();
                        StdHdr07Cell.Text = "Harmonizing Code&nbsp;&nbsp;" + cprData.Rows[lastRow]["PPI"].ToString();
                        StdHdr07Cell.ColumnSpan = 8;
                        StdHdr07Row.Cells.Add(StdHdr07Cell);
                        RepTable.Rows.Add(StdHdr07Row);
                    }
                    TableRow StdHdr08Row = new TableRow();
                    TableCell StdHdr08Cell = new TableCell();
                    if (HiddenFactor.Value.ToString() == "-1")
                    {
                        StdHdr08Cell.Text = "Factor&nbsp;&nbsp;" + cprData.Rows[lastRow]["CVFactor"].ToString() 
                            + "&nbsp;&nbsp;<b>" + cprData.Rows[lastRow]["LLTag"].ToString() + "<b>";
                    }
                    else
                    {
                        StdHdr08Cell.Text = "Factor&nbsp;&nbsp;" + HiddenFactor.Value + "&nbsp;&nbsp;<b>" + cprData.Rows[lastRow]["LLTag"].ToString() + "<b>";
                    }
                    StdHdr08Cell.ColumnSpan = 8;
                    StdHdr08Row.Cells.Add(StdHdr08Cell);
                    RepTable.Rows.Add(StdHdr08Row);
                    TableRow StdHdr09Row = new TableRow();
                    TableCell StdHdr09Cell = new TableCell();
                    StdHdr09Cell.Text = "CFV: <b>" + cprData.Rows[lastRow]["CorpFixedVelCode"].ToString() + "</b>";
                    StdHdr09Cell.Text += "&nbsp;&nbsp;PVC: <b>" + cprData.Rows[lastRow]["PackageVelocityCd"].ToString() + "</b>";
                    StdHdr09Cell.ColumnSpan = 8;
                    StdHdr09Row.Cells.Add(StdHdr09Cell);
                    RepTable.Rows.Add(StdHdr09Row);
                }
                // create grid column heading
                // start with 2 blank lines
                TableRow GridHdr1Row = new TableRow();
                TableCell GridHdr1Cell = new TableCell();
                GridHdr1Cell.Text = "&nbsp;";
                GridHdr1Cell.ColumnSpan = 30;
                GridHdr1Row.Cells.Add(GridHdr1Cell);
                TableRow GridHdr2Row = new TableRow();
                TableCell GridHdr2Cell = new TableCell();
                GridHdr2Cell.Text = "&nbsp;";
                GridHdr2Cell.ColumnSpan = 30;
                GridHdr2Row.Cells.Add(GridHdr2Cell);
                // now build 3 rows of headings
                TableRow GridHdr3Row = new TableRow();
                GridHdr3Row.HorizontalAlign = HorizontalAlign.Center;
                GridHdr3Row.VerticalAlign = VerticalAlign.Bottom;
                TableCell GridHdr3Cell01 = new TableCell();
                GridHdr3Cell01.Text = "BASE";
                GridHdr3Cell01.ColumnSpan = 2;
                GridHdr3Cell01.CssClass = "rightBorder bottomBorder";
                GridHdr3Row.Cells.Add(GridHdr3Cell01);
                TableCell GridHdr3Cell02 = new TableCell();
                GridHdr3Cell02.Text = "SALES AVERAGES";
                GridHdr3Cell02.ColumnSpan = 3;
                GridHdr3Cell02.CssClass = "rightBorder bottomBorder";
                GridHdr3Row.Cells.Add(GridHdr3Cell02);
                TableCell GridHdr3Cell03 = new TableCell();
                GridHdr3Cell03.Text = "STOCK / ORDERS";
                if ((ReportFormat.Value == "Long") || (ReportFormat.Value == "Transfer"))
                    GridHdr3Cell03.ColumnSpan = 9;
                if (ReportFormat.Value == "Short")
                    GridHdr3Cell03.ColumnSpan = 7;
                GridHdr3Cell03.CssClass = "rightBorder bottomBorder";
                GridHdr3Row.Cells.Add(GridHdr3Cell03);
                if (ReportFormat.Value != "Transfer")
                {
                    TableCell GridHdr3Cell04 = new TableCell();
                    GridHdr3Cell04.Text = "BUY";
                    GridHdr3Cell04.ColumnSpan = 3;
                    GridHdr3Cell04.CssClass = "rightBorder bottomBorder";
                    GridHdr3Row.Cells.Add(GridHdr3Cell04);
                }
                TableCell GridHdr3Cell05 = new TableCell();
                GridHdr3Cell05.Text = "NUMBER OF MONTHS";
                GridHdr3Cell05.ColumnSpan = 5;
                GridHdr3Cell05.CssClass = "rightBorder bottomBorder";
                GridHdr3Row.Cells.Add(GridHdr3Cell05);
                if ((ReportFormat.Value == "Long") || (ReportFormat.Value == "Transfer"))
                {
                    TableCell GridHdr3Cell06 = new TableCell();
                    GridHdr3Cell06.Text = "MISCELLANEOUS";
                    GridHdr3Cell06.ColumnSpan = 4;
                    GridHdr3Cell06.CssClass = "rightBorder bottomBorder";
                    GridHdr3Row.Cells.Add(GridHdr3Cell06);
                }
                TableCell GridHdr3Cell07 = new TableCell();
                GridHdr3Cell07.Text = "&nbsp;";
                GridHdr3Cell07.ColumnSpan = 6;
                GridHdr3Row.Cells.Add(GridHdr3Cell07);
                // column heading
                TableRow GridHdr4Row = new TableRow();
                GridHdr4Row.HorizontalAlign = HorizontalAlign.Center;
                GridHdr4Row.VerticalAlign = VerticalAlign.Bottom;
                TableCell GridHdr4Cell01 = new TableCell();
                GridHdr4Cell01.Text = "Loc";
                GridHdr4Cell01.RowSpan = 2;
                GridHdr4Cell01.VerticalAlign = VerticalAlign.Bottom;
                GridHdr4Cell01.CssClass = "bottomBorder";
                GridHdr4Row.Cells.Add(GridHdr4Cell01);
                TableCell GridHdr4Cell02 = new TableCell();
                GridHdr4Cell02.Text = "SV";
                GridHdr4Cell02.RowSpan = 2;
                GridHdr4Cell02.VerticalAlign = VerticalAlign.Bottom;
                GridHdr4Cell02.CssClass = "rightBorder bottomBorder";
                GridHdr4Row.Cells.Add(GridHdr4Cell02);
                TableCell GridHdr4Cell03 = new TableCell();
                GridHdr4Cell03.Text = "3M";
                GridHdr4Cell03.RowSpan = 2;
                GridHdr4Cell03.VerticalAlign = VerticalAlign.Bottom;
                GridHdr4Cell03.Width = Unit.Pixel(80);
                GridHdr4Cell03.CssClass = "bottomBorder";
                GridHdr4Row.Cells.Add(GridHdr4Cell03);
                TableCell GridHdr4Cell04 = new TableCell();
                GridHdr4Cell04.Text = "12M";
                GridHdr4Cell04.RowSpan = 2;
                GridHdr4Cell04.VerticalAlign = VerticalAlign.Bottom;
                GridHdr4Cell04.Width = Unit.Pixel(80);
                GridHdr4Cell04.CssClass = " bottomBorder";
                GridHdr4Row.Cells.Add(GridHdr4Cell04);
                TableCell GridHdr4Cell05 = new TableCell();
                GridHdr4Cell05.Text = "Use<br />30D";
                GridHdr4Cell05.RowSpan = 2;
                GridHdr4Cell05.VerticalAlign = VerticalAlign.Bottom;
                GridHdr4Cell05.Width = Unit.Pixel(80);
                GridHdr4Cell05.CssClass = "rightBorder bottomBorder";
                GridHdr4Row.Cells.Add(GridHdr4Cell05);
                TableCell GridHdr4Cell06 = new TableCell();
                GridHdr4Cell06.Text = "Avl";
                GridHdr4Cell06.RowSpan = 2;
                GridHdr4Cell06.VerticalAlign = VerticalAlign.Bottom;
                GridHdr4Cell06.Width = Unit.Pixel(120);
                GridHdr4Cell06.CssClass = "bottomBorder";
                GridHdr4Row.Cells.Add(GridHdr4Cell06);
                TableCell GridHdr4Cell07 = new TableCell();
                GridHdr4Cell07.Text = "Trf";
                GridHdr4Cell07.RowSpan = 2;
                GridHdr4Cell07.VerticalAlign = VerticalAlign.Bottom;
                GridHdr4Cell07.Width = Unit.Pixel(100);
                GridHdr4Cell07.CssClass = "bottomBorder";
                GridHdr4Row.Cells.Add(GridHdr4Cell07);
                TableCell GridHdr4Cell08 = new TableCell();
                GridHdr4Cell08.Text = "OO";
                GridHdr4Cell08.RowSpan = 2;
                GridHdr4Cell08.VerticalAlign = VerticalAlign.Bottom;
                GridHdr4Cell08.Width = Unit.Pixel(100);
                GridHdr4Cell08.CssClass = "bottomBorder";
                GridHdr4Row.Cells.Add(GridHdr4Cell08);
                TableCell GridHdr4Cell09 = new TableCell();
                GridHdr4Cell09.Text = "OW";
                GridHdr4Cell09.RowSpan = 2;
                GridHdr4Cell09.VerticalAlign = VerticalAlign.Bottom;
                GridHdr4Cell09.Width = Unit.Pixel(100);
                GridHdr4Cell09.CssClass = "rightBorder bottomBorder";
                GridHdr4Row.Cells.Add(GridHdr4Cell09);
                TableCell GridHdr4Cell10 = new TableCell();
                GridHdr4Cell10.Text = "<b>OO Next</b>";
                GridHdr4Cell10.ColumnSpan = 2;
                GridHdr4Cell10.CssClass = "rightBorder";
                GridHdr4Row.Cells.Add(GridHdr4Cell10);
                if ((ReportFormat.Value == "Long") || (ReportFormat.Value == "Transfer"))
                {

                    TableCell GridHdr4Cell11 = new TableCell();
                    GridHdr4Cell11.Text = "<b>OW Next</b>";
                    GridHdr4Cell11.ColumnSpan = 2;
                    GridHdr4Cell11.CssClass = "rightBorder";
                    GridHdr4Row.Cells.Add(GridHdr4Cell11);
                }
                TableCell GridHdr4Cell14 = new TableCell();
                GridHdr4Cell14.Text = "Total";
                GridHdr4Cell14.Width = Unit.Pixel(120);
                GridHdr4Cell14.RowSpan = 2;
                GridHdr4Cell14.VerticalAlign = VerticalAlign.Bottom;
                GridHdr4Cell14.CssClass = "rightBorder bottomBorder";
                GridHdr4Row.Cells.Add(GridHdr4Cell14);
                if (ReportFormat.Value != "Transfer")
                {
                    TableCell GridHdr4Cell15 = new TableCell();
                    GridHdr4Cell15.Text = "FcstNeed";
                    GridHdr4Cell15.RowSpan = 2;
                    GridHdr4Cell15.VerticalAlign = VerticalAlign.Bottom;
                    GridHdr4Cell15.Width = Unit.Pixel(120);
                    GridHdr4Cell15.CssClass = "bottomBorder";
                    GridHdr4Row.Cells.Add(GridHdr4Cell15);
                    TableCell GridHdr4Cell16 = new TableCell();
                    GridHdr4Cell16.Text = "NetBuy";
                    GridHdr4Cell16.RowSpan = 2;
                    GridHdr4Cell16.VerticalAlign = VerticalAlign.Bottom;
                    GridHdr4Cell16.Width = Unit.Pixel(120);
                    GridHdr4Cell16.CssClass = "bottomBorder";
                    GridHdr4Row.Cells.Add(GridHdr4Cell16);
                    TableCell GridHdr4Cell17 = new TableCell();
                    GridHdr4Cell17.Text = "EstBuyCost";
                    GridHdr4Cell17.RowSpan = 2;
                    GridHdr4Cell17.VerticalAlign = VerticalAlign.Bottom;
                    GridHdr4Cell17.Width = Unit.Pixel(120);
                    GridHdr4Cell17.CssClass = "rightBorder bottomBorder";
                    GridHdr4Row.Cells.Add(GridHdr4Cell17);
                }
                TableCell GridHdr4Cell18 = new TableCell();
                GridHdr4Cell18.Text = "Avl";
                GridHdr4Cell18.RowSpan = 2;
                GridHdr4Cell18.VerticalAlign = VerticalAlign.Bottom;
                GridHdr4Cell18.Width = Unit.Pixel(90);
                GridHdr4Cell18.CssClass = "bottomBorder";
                GridHdr4Row.Cells.Add(GridHdr4Cell18);
                TableCell GridHdr4Cell19 = new TableCell();
                GridHdr4Cell19.Text = "Trf";
                GridHdr4Cell19.RowSpan = 2;
                GridHdr4Cell19.VerticalAlign = VerticalAlign.Bottom;
                GridHdr4Cell19.Width = Unit.Pixel(90);
                GridHdr4Cell19.CssClass = "bottomBorder";
                GridHdr4Row.Cells.Add(GridHdr4Cell19);
                TableCell GridHdr4Cell20 = new TableCell();
                GridHdr4Cell20.Text = "OO";
                GridHdr4Cell20.RowSpan = 2;
                GridHdr4Cell20.VerticalAlign = VerticalAlign.Bottom;
                GridHdr4Cell20.Width = Unit.Pixel(90);
                GridHdr4Cell20.CssClass = "bottomBorder";
                GridHdr4Row.Cells.Add(GridHdr4Cell20);
                TableCell GridHdr4Cell21 = new TableCell();
                GridHdr4Cell21.Text = "OW";
                GridHdr4Cell21.Width = Unit.Pixel(90);
                GridHdr4Cell21.RowSpan = 2;
                GridHdr4Cell21.VerticalAlign = VerticalAlign.Bottom;
                GridHdr4Cell21.CssClass = "bottomBorder";
                GridHdr4Row.Cells.Add(GridHdr4Cell21);
                TableCell GridHdr4Cell22 = new TableCell();
                GridHdr4Cell22.Text = "Total";
                GridHdr4Cell22.RowSpan = 2;
                GridHdr4Cell22.VerticalAlign = VerticalAlign.Bottom;
                GridHdr4Cell22.Width = Unit.Pixel(100);
                GridHdr4Cell22.CssClass = "rightBorder bottomBorder";
                GridHdr4Row.Cells.Add(GridHdr4Cell22);
                if ((ReportFormat.Value == "Long") || (ReportFormat.Value == "Transfer"))
                {
                    TableCell GridHdr4Cell24 = new TableCell();
                    GridHdr4Cell24.Text = "ROP<br />Cust";
                    GridHdr4Cell24.RowSpan = 2;
                    GridHdr4Cell24.VerticalAlign = VerticalAlign.Bottom;
                    GridHdr4Cell24.Width = Unit.Pixel(90);
                    GridHdr4Cell24.CssClass = "bottomBorder";
                    GridHdr4Row.Cells.Add(GridHdr4Cell24);
                    TableCell GridHdr4Cell25 = new TableCell();
                    GridHdr4Cell25.Text = "ROP<br />Days";
                    GridHdr4Cell25.RowSpan = 2;
                    GridHdr4Cell25.VerticalAlign = VerticalAlign.Bottom;
                    GridHdr4Cell25.Width = Unit.Pixel(90);
                    GridHdr4Cell25.CssClass = "bottomBorder";
                    GridHdr4Row.Cells.Add(GridHdr4Cell25);
                    TableCell GridHdr4Cell26 = new TableCell();
                    GridHdr4Cell26.Text = "ROP<br />-ATO";
                    GridHdr4Cell26.RowSpan = 2;
                    GridHdr4Cell26.VerticalAlign = VerticalAlign.Bottom;
                    GridHdr4Cell26.Width = Unit.Pixel(90);
                    GridHdr4Cell26.CssClass = "rightBorder bottomBorder";
                    GridHdr4Row.Cells.Add(GridHdr4Cell26);
                    TableCell GridHdr4Cell27 = new TableCell();
                    GridHdr4Cell27.Text = "Action";
                    GridHdr4Cell27.RowSpan = 2;
                    GridHdr4Cell27.VerticalAlign = VerticalAlign.Bottom;
                    GridHdr4Cell27.CssClass = "rightBorder bottomBorder";
                    GridHdr4Row.Cells.Add(GridHdr4Cell27);
                }
                TableCell GridHdr4Cell28 = new TableCell();
                GridHdr4Cell28.Text = "&nbsp;";
                GridHdr4Row.Cells.Add(GridHdr4Cell28);
                // next row
                TableRow GridHdr5Row = new TableRow();
                GridHdr5Row.HorizontalAlign = HorizontalAlign.Right;
                GridHdr5Row.VerticalAlign = VerticalAlign.Bottom;
                TableCell GridHdr5Cell10 = new TableCell();
                GridHdr5Cell10.Text = "Qty";
                GridHdr5Cell10.Width = Unit.Pixel(100);
                GridHdr5Cell10.CssClass = "bottomBorder";
                GridHdr5Row.Cells.Add(GridHdr5Cell10);
                TableCell GridHdr5Cell11 = new TableCell();
                GridHdr5Cell11.Text = "Date";
                GridHdr5Cell11.Width = Unit.Pixel(120);
                GridHdr5Cell11.CssClass = "rightBorder bottomBorder";
                GridHdr5Row.Cells.Add(GridHdr5Cell11);
                if ((ReportFormat.Value == "Long") || (ReportFormat.Value == "Transfer"))
                {
                    TableCell GridHdr5Cell12 = new TableCell();
                    GridHdr5Cell12.Text = "Qty";
                    GridHdr5Cell12.Width = Unit.Pixel(100);
                    GridHdr5Cell12.CssClass = "bottomBorder";
                    GridHdr5Row.Cells.Add(GridHdr5Cell12);
                    TableCell GridHdr5Cell13 = new TableCell();
                    GridHdr5Cell13.Text = "Date";
                    GridHdr5Cell13.CssClass = "rightBorder bottomBorder";
                    GridHdr5Cell13.Width = Unit.Pixel(120);
                    GridHdr5Row.Cells.Add(GridHdr5Cell13);
                }
                // add the grid header
                if (ReportFormat.Value != "Transfer")
                {
                    RepTable.Rows.Add(GridHdr1Row);
                    RepTable.Rows.Add(GridHdr2Row);
                }
                RepTable.Rows.Add(GridHdr3Row);
                RepTable.Rows.Add(GridHdr4Row);
                RepTable.Rows.Add(GridHdr5Row);
                // build the main grid
                foreach (DataRow cprRow in cprData.Rows)
                {
                    cellclass = "GridItem";
                    if (ReportFormat.Value == "Transfer")
                        cellclass = "XFerGrid";
                    cellGroupclass = "rightBorder";
                    LocColSpan = 1;
                    // set background on territory and final totals
                    if (cprRow["LocationCode"].ToString().Trim().Length != 2)
                    {
                        if (cprRow["LocationCode"].ToString().Trim() != "Child")
                        {
                            cellclass = "bottomBorder";
                            cellGroupclass = "rightBorder bottomBorder";
                            LocColSpan = 2;
                        }
                    }
                    TableRow GridDetRow = new TableRow();
                    GridDetRow.HorizontalAlign = HorizontalAlign.Right;
                    TableCell GridDetCell01 = new TableCell();
                    GridDetCell01.Text = cprRow["LocationCode"].ToString();
                    GridDetCell01.HorizontalAlign = HorizontalAlign.Center;
                    GridDetCell01.ColumnSpan = LocColSpan;
                    GridDetCell01.CssClass = cellclass;
                    if (LocColSpan == 2)
                    {
                        GridDetCell01.CssClass = cellGroupclass;
                    }
                    GridDetRow.Cells.Add(GridDetCell01);
                    if (LocColSpan == 1)
                    {
                        TableCell GridDetCell02 = new TableCell();
                        GridDetCell02.Text = cprRow["SVCode"].ToString() + Filler;
                        GridDetCell02.HorizontalAlign = HorizontalAlign.Center;
                        GridDetCell02.CssClass = cellGroupclass;
                        GridDetRow.Cells.Add(GridDetCell02);
                    }
                    TableCell GridDetCell03 = new TableCell();
                    GridDetCell03.Text = string.Format(Num1Format, cprRow["Avg3M"]);
                    GridDetCell03.CssClass = cellclass;
                    GridDetRow.Cells.Add(GridDetCell03);
                    TableCell GridDetCell04 = new TableCell();
                    GridDetCell04.Text = string.Format(Num1Format, cprRow["Avg12M"]);
                    GridDetCell04.CssClass = cellclass;
                    GridDetRow.Cells.Add(GridDetCell04);
                    TableCell GridDetCell05 = new TableCell();
                    GridDetCell05.Text = string.Format(Num1Format, cprRow["Use30D"]);
                    GridDetCell05.CssClass = cellGroupclass;
                    GridDetRow.Cells.Add(GridDetCell05);
                    TableCell GridDetCell06 = new TableCell();
                    GridDetCell06.Text = string.Format(Num0Format, cprRow["Avl"]);
                    GridDetCell06.CssClass = cellclass;
                    GridDetRow.Cells.Add(GridDetCell06);
                    TableCell GridDetCell07 = new TableCell();
                    GridDetCell07.Text = string.Format(Num0Format, cprRow["Trf"]);
                    GridDetCell07.CssClass = cellclass;
                    GridDetRow.Cells.Add(GridDetCell07);
                    TableCell GridDetCell08 = new TableCell();
                    GridDetCell08.Text = string.Format(Num0Format, cprRow["OO"]);
                    GridDetCell08.CssClass = cellclass;
                    GridDetRow.Cells.Add(GridDetCell08);
                    TableCell GridDetCell09 = new TableCell();
                    GridDetCell09.Text = string.Format(Num0Format, cprRow["OW"]);
                    GridDetCell09.CssClass = cellGroupclass;
                    GridDetRow.Cells.Add(GridDetCell09);
                    TableCell GridDetCell10 = new TableCell();
                    GridDetCell10.Text = string.Format(Num0Format, cprRow["OONxtQty"]);
                    GridDetCell10.CssClass = cellclass;
                    GridDetRow.Cells.Add(GridDetCell10);
                    TableCell GridDetCell11 = new TableCell();
                    GridDetCell11.Text = cprRow["OONxtDate"].ToString() + Filler;
                    GridDetCell11.CssClass = cellGroupclass;
                    GridDetRow.Cells.Add(GridDetCell11);
                    if ((ReportFormat.Value == "Long") || (ReportFormat.Value == "Transfer"))
                    {
                        TableCell GridDetCell12 = new TableCell();
                        GridDetCell12.Text = string.Format(Num0Format, cprRow["OWNxtQty"]);
                        GridDetCell12.CssClass = cellclass;
                        GridDetRow.Cells.Add(GridDetCell12);
                        TableCell GridDetCell13 = new TableCell();
                        GridDetCell13.Text = string.Format(DateFormat, cprRow["OWNxtDate"]) + Filler;
                        GridDetCell13.CssClass = cellGroupclass;
                        GridDetRow.Cells.Add(GridDetCell13);
                    }
                    TableCell GridDetCell14 = new TableCell();
                    GridDetCell14.Text = string.Format(Num0Format, cprRow["TotalQty"]);
                    GridDetCell14.CssClass = cellGroupclass;
                    GridDetRow.Cells.Add(GridDetCell14);
                    if (ReportFormat.Value != "Transfer")
                    {
                        TableCell GridDetCell15 = new TableCell();
                        GridDetCell15.Text = string.Format(Num0Format, cprRow["FcstNeed"]);
                        GridDetCell15.CssClass = cellclass;
                        GridDetRow.Cells.Add(GridDetCell15);
                        TableCell GridDetCell16 = new TableCell();
                        GridDetCell16.Text = string.Format(Num0Format, cprRow["NetBuy"]);
                        GridDetCell16.CssClass = cellclass;
                        GridDetRow.Cells.Add(GridDetCell16);
                        TableCell GridDetCell17 = new TableCell();
                        GridDetCell17.Text = string.Format(Num0Format, cprRow["EstBuyCost"]);
                        GridDetCell17.CssClass = cellGroupclass;
                        GridDetRow.Cells.Add(GridDetCell17);
                    }
                    TableCell GridDetCell18 = new TableCell();
                    GridDetCell18.Text = string.Format(Num1Format, cprRow["MosAvl"]);
                    GridDetCell18.CssClass = cellclass;
                    GridDetRow.Cells.Add(GridDetCell18);
                    TableCell GridDetCell19 = new TableCell();
                    GridDetCell19.Text = string.Format(Num1Format, cprRow["MosTrf"]);
                    GridDetCell19.CssClass = cellclass;
                    GridDetRow.Cells.Add(GridDetCell19);
                    TableCell GridDetCell20 = new TableCell();
                    GridDetCell20.Text = string.Format(Num1Format, cprRow["MosOO"]);
                    GridDetCell20.CssClass = cellclass;
                    GridDetRow.Cells.Add(GridDetCell20);
                    TableCell GridDetCell21 = new TableCell();
                    GridDetCell21.Text = string.Format(Num1Format, cprRow["MosOW"]);
                    GridDetCell21.CssClass = cellclass;
                    GridDetRow.Cells.Add(GridDetCell21);
                    TableCell GridDetCell22 = new TableCell();
                    GridDetCell22.Text = string.Format(Num1Format, cprRow["MosTotal"]);
                    GridDetCell22.CssClass = cellGroupclass;
                    GridDetRow.Cells.Add(GridDetCell22);
                    if ((ReportFormat.Value == "Long") || (ReportFormat.Value == "Transfer"))
                    {
                        TableCell GridDetCell24 = new TableCell();
                        GridDetCell24.Text = string.Format(Num1Format, cprRow["PCROP"]);
                        GridDetCell24.CssClass = cellGroupclass;
                        GridDetRow.Cells.Add(GridDetCell24);
                        TableCell GridDetCell25 = new TableCell();
                        GridDetCell25.Text = string.Format(Num1Format, cprRow["ROPDays"]);
                        GridDetCell25.CssClass = cellGroupclass;
                        GridDetRow.Cells.Add(GridDetCell25);
                        TableCell GridDetCell26 = new TableCell();
                        GridDetCell26.Text = string.Format(Num1Format, cprRow["ROPRem"]);
                        GridDetCell26.Width = Unit.Pixel(90);
                        GridDetCell26.CssClass = cellGroupclass;
                        if ((int)cprRow["ROPShade"] == 1)
                        {
                            GridDetCell26.BackColor = Color.Silver;
                        }
                        GridDetRow.Cells.Add(GridDetCell26);
                        // action line
                        TableCell GridDetCell27 = new TableCell();
                        GridDetCell27.Text = "&nbsp;";
                        if (LocColSpan == 1)
                        {
                            GridDetCell27.CssClass = "bottomBorder";
                        }
                        GridDetRow.Cells.Add(GridDetCell27);
                    }
                    TableCell GridDetCell28 = new TableCell();
                    GridDetCell28.Text = "&nbsp;";
                    GridDetRow.Cells.Add(GridDetCell28);
                    RepTable.Rows.Add(GridDetRow);

                }
                if (ReportFormat.Value == "Long") 
                {
                    TableRow GridTotRow = new TableRow();
                    GridTotRow.HorizontalAlign = HorizontalAlign.Right;
                    TableCell GridTotCell01 = new TableCell();
                    GridTotCell01.Text = "&nbsp;";
                    GridTotCell01.ColumnSpan = 14;
                    GridTotCell01.CssClass = cellclass;
                    GridTotRow.Cells.Add(GridTotCell01);
                    TableCell GridTotCell02 = new TableCell();
                    GridTotCell02.Text = "Pos:";
                    GridTotCell02.CssClass = cellclass;
                    GridTotRow.Cells.Add(GridTotCell02);
                    TableCell GridTotCell03 = new TableCell();
                    GridTotCell03.Text = string.Format(Num1Format, ds.Tables[0].Rows[0]["ANetTotal"]);
                    GridTotCell03.CssClass = cellclass;
                    GridTotRow.Cells.Add(GridTotCell03);
                    TableCell GridTotCell04 = new TableCell();
                    GridTotCell04.Text = string.Format(Num1Format, ds.Tables[0].Rows[0]["AEstCostTotal"]);
                    GridTotCell04.CssClass = cellGroupclass;
                    GridTotRow.Cells.Add(GridTotCell04);
                    RepTable.Rows.Add(GridTotRow);
                }
            }
            else
            {
                TableRow GridNoDataRow = new TableRow();
                TableCell GridNoDataCell01 = new TableCell();
                GridNoDataCell01.Text = "<div class=noData>No CPR Data on file</div>";
                GridNoDataCell01.ColumnSpan = 8;
                GridNoDataRow.Cells.Add(GridNoDataCell01);
                RepTable.Rows.Add(GridNoDataRow);
                // put in some empty rows so previous rowspan will not cause misalignment of next page
                for (int count = 0; count < 15; count++)
                {
                    TableRow GridNoDataEmptyRow = new TableRow();
                    TableCell GridNoDataEmptyCell = new TableCell();
                    GridNoDataEmptyCell.Text = "&nbsp;";
                    GridNoDataEmptyCell.ColumnSpan = 30;
                    GridNoDataEmptyRow.Cells.Add(GridNoDataEmptyCell);
                    RepTable.Rows.Add(GridNoDataEmptyRow);
                    //sw.WriteLine("<tr ><td colspan=30>&nbsp;</td></tr>");
                }

            }
            pageCtr++;
        }
    }

}
