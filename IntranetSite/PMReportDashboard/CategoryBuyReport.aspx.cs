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
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Utility;
using PFC.Intranet.Securitylayer;

public partial class CatBuyReport : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    //string liveConnectionString = ConfigurationManager.AppSettings["LiveReportsConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();

    protected void Page_Init(object sender, EventArgs e)
    {
        //Session["FooterTitle"] = Session["UserName"].ToString();
        lblUserInfo.Text = DateTime.Now.ToLongDateString() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; You have logged in as <strong>" + Session["UserName"].ToString() + "</strong> in <strong>" + System.Configuration.ConfigurationManager.AppSettings["Environment"];
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            if (Session["CatBuyTable"] == null)
            {
                ds = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "pCategoryBuyData",
                        new SqlParameter("@BegCFVC", "A"),
                        new SqlParameter("@EndCFVC", "D"));
                Session["CatBuyTable"] = FixData(ds.Tables[0]);
            }
            CatBuyGridView.DataSource = (DataTable)Session["CatBuyTable"];
            CatBuyGridView.DataBind();
            BindPrintDialog();
        }
        else
        {
        }

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
            if (row["CVC"].ToString().Trim().Length == 0 )
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

    protected void CatBuyLineFormat(object source, GridViewRowEventArgs e)
    {
        int lastCell = e.Row.Cells.Count - 1;
        Label CVC = new Label();
        LinkButton GrpNo = new LinkButton();
        LinkButton DescLink = new LinkButton();
        int newWidth = 0;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // don't show the CVC tots until drill down
            CVC = (Label)e.Row.Cells[1].Controls[3];
            DescLink = (LinkButton)e.Row.Cells[1].Controls[1];
            if (CVC.Text.Trim().Length != 0)
            {
                // we have a CVC line
                e.Row.Style["display"] = "none";
                e.Row.Style["background-color"] = "palegreen";
                GrpNo = (LinkButton)e.Row.Cells[0].Controls[1];
                GrpNo.Style["display"] = "none";
                DescLink.Style["display"] = "none";
                if (CVC.Text.Trim() == "Z")
                {
                    CVC.Text = "CVC - All Others";
                }
                else
                {
                    CVC.Text = "CVC - " + CVC.Text.Trim();
                }
           }
            else
            {
                // we have a Grp total line
                if (AltLine.Value == "1")
                {
                    e.Row.Style["background-color"] = "white";
                    AltLine.Value = "0";
                }
                else
                {
                    AltLine.Value = "1";
                }
            }
            if (DescLink.Text.Trim() == "Total")
            {
                e.Row.Style["font-weight"] = "bold";
                for (int col = 0; col <= lastCell; col++)
                {
                    e.Row.Cells[col].Style["font-weight"] = "bold";
                }
            }
        }
    }

    protected void ExcelExportButton_Click(object sender, ImageClickEventArgs e)
    {
        ////string ExcelPath = ConfigurationManager.AppSettings["CPRExcelFilePath"].ToString() + "CPRExcel.xls";
        //string SiteFileName = @"Excel\"
        //    + Session["UserName"].ToString()
        //    + "Export.xls";
        //FullFilePath = Server.MapPath(SiteFileName);
        ////CreateCatBuyReport(SiteFileName);
        ////Response.Redirect(SiteFileName);
        ////
        //// Downloding Process
        ////
        //FileStream fileStream = File.Open(FullFilePath, FileMode.Open);
        //Byte[] bytBytes = new Byte[fileStream.Length];
        //fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        //fileStream.Close();

        ////
        //// Download Process
        ////
        //Response.AddHeader("Content-disposition", "attachment; filename=" + FullFilePath);
        //Response.ContentType = "application/octet-stream";
        //Response.BinaryWrite(bytBytes);
        //Response.End();

    }

//    public void CreateCatBuyReport(string FileName)
//    {
//        string StatFilePath = Server.MapPath(StatusFileName.Value);
//        string cellclass = "GridItem";
//        string cellGroupclass = "rightBorder";
//        int pageCtr = 0;
//        dt = (System.Data.DataTable)Session["MasterTable"];
//        // 
//        using (StreamWriter sw = new StreamWriter(FullFilePath))
//        {
//            sw.WriteLine("<html><head>");
//            sw.WriteLine("<style>");
//            sw.WriteLine(".NewPage {page-break-before: always;}");
//            sw.WriteLine(".GridItem {font-family: 'Arial Narrow', Arial, Helvetica, sans-serif;	font-size: 16px; color: #000000; text-decoration:none; padding-top: 3px; padding-right: 3px; padding-bottom: 2px;}");
//            sw.WriteLine(".rightBorder {border-right-width: 1px; border-right-style: solid; border-right-color: black; }");
//            sw.WriteLine(".TotBord {border-top-width: 1px; border-top-style: solid;	border-top-color: black; border-bottom-width: 1px; border-bottom-style: solid; border-bottom-color: black;}");
//            sw.WriteLine(".TotBordGroup {border-top-width: 1px;	border-top-style: solid; border-top-color: black; border-bottom-width: 1px;	border-bottom-style: solid;	border-bottom-color: black;	border-right-width: 1px; border-right-style: solid;	border-right-color: black;}");
//            sw.WriteLine(".noData {font-weight: bold; font-size: 32px; }");
//            sw.WriteLine("</style><title>CPR Buy</title>");
//            sw.WriteLine("</head><body onLoad=\"window.print();\">");
//            foreach (DataRow row in dt.Rows)
//            {
//                using (StreamWriter statw = new StreamWriter(StatFilePath))
//                {
//                    statw.WriteLine(row["ItemNo"].ToString().Substring(0, 5) + "," + pageCtr.ToString());
//                }
//                if (pageCtr > 0)
//                {
//                    sw.WriteLine("<tr class=NewPage><td colspan=30>&nbsp;</td></tr>");
//                }
//                sw.Write("<tr ><td colspan=8 style=\"font-size: 24px;\"><b>");
//                sw.Write(row["ItemNo"]);
//                sw.Write("</b>");
//                System.Data.DataTable CatBuyData = cpr.GetGPRGridData(row["ItemNo"].ToString(), (decimal)Session["CPRFactor"]).Tables[0];
//                if (VMIRun.Value != "True")
//                {
//                    sw.Write("</td><td colspan=25 rowspan=10 valign=top>");

//                    if (CatBuyData.Rows.Count > 0)
//                    {
//                        lastRow = CatBuyData.Rows.Count - 1;
//                        sw.Write(string.Format("<span  style=\"font-size: 20px;\">Last Cost&nbsp;&nbsp;<b>{0:N3}</b>", CatBuyData.Rows[lastRow]["Last_CostM"]));
//                        sw.Write(string.Format("<br />Avg. Cost&nbsp;&nbsp;<b>{0:N3}</b><br /></span>", CatBuyData.Rows[lastRow]["Avg_CostM"]));
//                    }


//                    System.Data.DataTable vendData = cpr.GetVendorData(row["ItemNo"].ToString()).Tables[0];
//                    if (vendData.Rows.Count > 0)
//                    {
//                        sw.WriteLine("<table border=0 cellspacing=3 cellpadding=0 class=GridItem>");
//                        sw.Write("<tr  align=right><td width=80 align=Center>");
//                        sw.Write("Loc</td><td width=30>");
//                        sw.Write("Co</td><td width=50>");
//                        sw.Write("FOB</td><td width=40>");
//                        sw.Write("Diff</td><td width=50>");
//                        sw.Write("Duty</td><td width=50>");
//                        sw.Write("F/Lb</td><td width=50>");
//                        sw.Write("Land</td><td width=40>");
//                        sw.Write("Diff</td><td width=50>");
//                        sw.Write("L/Lb</td><td width=50>");
//                        sw.Write("Avail</td><td width=50>");
//                        sw.Write("Pcs Per</td><td>");
//                        sw.WriteLine("</td></tr>");
//                        foreach (DataRow vendRow in vendData.Rows)
//                        {
//                            sw.Write("<tr  align=right><td width=10 align=left>");
//                            sw.Write(vendRow["VendorName"]);
//                            sw.Write("</td><td>");
//                            sw.Write(vendRow["CountryCode"]);
//                            sw.Write("</td><td>");
//                            sw.Write(string.Format("{0:N2}", vendRow["FOB_Cost"]));
//                            sw.Write("</td><td>");
//                            sw.Write(string.Format("{0:N1}%", vendRow["FOB_Diff"]));
//                            sw.Write("</td><td>");
//                            sw.Write(string.Format("{0:N2}", vendRow["DutyRate"]));
//                            sw.Write("</td><td>");
//                            sw.Write(string.Format("{0:N2}", vendRow["FOB_Wgt"]));
//                            sw.Write("</td><td>");
//                            sw.Write(string.Format("{0:N2}", vendRow["Land_Cost"]));
//                            sw.Write("</td><td>");
//                            sw.Write(string.Format("{0:N0}%", vendRow["Land_Diff"]));
//                            sw.Write("</td><td>");
//                            sw.Write(string.Format("{0:N2}", vendRow["Land_Wgt"]));
//                            sw.Write("</td><td>");
//                            sw.Write(string.Format("{0:N0}", vendRow["VendorAvail"]));
//                            sw.Write("</td><td>");
//                            sw.Write(string.Format("{0:N0}", vendRow["VendorPcsPer"]));
//                            sw.WriteLine("</td></tr>");
//                        }
//                        sw.WriteLine("</table>");
//                    }
//                    else
//                    {
//                        sw.Write("<div class=noData>No Vendor Data Available</div>");
//                    }
//                }
//                else
//                {
//                    sw.Write("</td></tr><tr ><td colspan=30>Customer Chain&nbsp;");
//                    // VMI Heading
//                    System.Data.DataTable vmiData = new System.Data.DataTable();
//                    vmiData = cpr.GetVMIContractItem(VMIChain.Value, VMIContract.Value, row["ItemNo"].ToString()).Tables[0];
//                    sw.Write( VMIChain.Value);
//                    sw.Write("</td></tr><tr ><td colspan=8>");
//                    sw.Write(VMIContract.Value);
//                    sw.Write("</td></tr><tr ><td colspan=8>Effective&nbsp;");
//                    sw.Write(string.Format("{0:MM/dd/yy} thru ", vmiData.Rows[0]["StartDate"]));
//                    sw.Write(string.Format("{0:MM/dd/yy}", vmiData.Rows[0]["EndDate"]));
//                    sw.Write("</td></tr><tr ><td colspan=8>Cust PO&nbsp;");
//                    sw.Write(vmiData.Rows[0]["CustomerPO"].ToString());
//                    sw.Write("</td></tr><tr ><td colspan=8>Cross Ref #&nbsp;");
//                    sw.Write(vmiData.Rows[0]["CrossRef"].ToString());
//                    sw.Write("</td></tr><tr ><td colspan=8>Desc:&nbsp;");
//                    sw.Write(vmiData.Rows[0]["ItemDesc"].ToString());
//                    sw.Write("</td></tr><tr ><td colspan=8>Sub Item #&nbsp;");
//                    sw.Write(vmiData.Rows[0]["SubItemNo"].ToString());
//                    sw.Write("</td></tr><tr ><td colspan=8>PFC Salesperson&nbsp;");
//                    sw.Write(vmiData.Rows[0]["Salesperson"].ToString());
//                    sw.Write("</td></tr><tr ><td colspan=8>Annual Usage Qty&nbsp;");
//                    sw.Write(string.Format("{0:N0}", vmiData.Rows[0]["EAU_Qty"]));
//                    sw.Write("</td></tr><tr ><td colspan=8>Contact&nbsp;");
//                    sw.Write(vmiData.Rows[0]["Contact"].ToString() + " / " + vmiData.Rows[0]["ContactPhone"].ToString());
//                    sw.Write("</td></tr><tr ><td colspan=8>Expected GP %&nbsp;");
//                    sw.Write(string.Format("{0:N1}", vmiData.Rows[0]["E_Profit_Pct"]));
//                    sw.Write("</td></tr><tr ><td colspan=8>Order Method&nbsp;");
//                    sw.Write(vmiData.Rows[0]["OrderMethod"].ToString());
//                    sw.Write("</td></tr><tr ><td colspan=8>Vendor Code&nbsp;");
//                    sw.Write(vmiData.Rows[0]["Vendor"].ToString());
//                    sw.Write("</td></tr><tr ><td colspan=8>Month Factor&nbsp;");
//                    sw.Write(string.Format("{0:N1}", vmiData.Rows[0]["MonthFactor"]));
////                    sw.Write(Decimal.Parse(vmiData.Rows[0]["MonthFactor"].ToString()));
//                    //sw.WriteLine("</td></tr>");

//                }
//                sw.WriteLine("</td></tr>");
//                if (CatBuyData.Rows.Count > 0)
//                {
//                    lastRow = CatBuyData.Rows.Count - 1;
//                    ds = FixCatBuyData(CatBuyData);
//                    if (VMIRun.Value != "True")
//                    {
//                        sw.Write("<tr ><td colspan=8>");
//                        sw.Write(CatBuyData.Rows[lastRow]["Description"].ToString());
//                        sw.Write("</td></tr><tr ><td colspan=8>");
//                        sw.Write(string.Format("Qty/Uom&nbsp;&nbsp;{0:N0}", CatBuyData.Rows[lastRow]["UOM_Qty"]) + " / "
//                            + string.Format("{0:N0}", CatBuyData.Rows[lastRow]["UOM"]));
//                        sw.Write("</td></tr><tr ><td colspan=8>");
//                        sw.Write(string.Format("Weight&nbsp;&nbsp;{0:N1}", CatBuyData.Rows[lastRow]["Net_Wgt"]) + " Lbs");
//                        sw.Write("</td></tr><tr ><td colspan=8>");
//                        sw.Write(string.Format("Super Eqv&nbsp;&nbsp;<b>{0:N0}", CatBuyData.Rows[lastRow]["SupEqv_Qty"]) + " / "
//                            + string.Format("{0:N0}", CatBuyData.Rows[lastRow]["SupEqv_UOM"]));
//                        sw.Write("</b>&nbsp;&nbsp;&nbsp;&nbsp;Pieces&nbsp;&nbsp;" + string.Format("{0:N0}", CatBuyData.Rows[lastRow]["SupEqv_Pcs"]) + " Pcs");
//                        sw.Write("</td></tr><tr ><td colspan=8>");
//                        sw.Write(string.Format("Yearly Usage Weight&nbsp;&nbsp;{0:N1}", CatBuyData.Rows[lastRow]["Item_Use_CY_Wgt"]) + " Lbs");
//                        sw.Write("</td></tr><tr ><td colspan=8>");
//                        sw.Write(string.Format("Weight/100&nbsp;&nbsp;{0:N2}", CatBuyData.Rows[lastRow]["Wgt100"]));
//                        sw.Write("</td></tr><tr ><td colspan=8>Harmonizing Code&nbsp;&nbsp;");
//                        sw.Write(CatBuyData.Rows[lastRow]["PPI"].ToString());
//                        sw.Write("</td></tr><tr ><td colspan=8>Factor&nbsp;&nbsp;");
//                        sw.Write(HiddenFactor.Value);
//                        sw.Write("</td></tr><tr ><td colspan=8>");
//                        sw.Write("CFV: <b>" + CatBuyData.Rows[lastRow]["CorpFixedVelCode"].ToString() + "</b>");
//                        sw.WriteLine("</td></tr>");
//                    }
//                    // start heading
//                    sw.Write("<tr ><td  colspan=30>&nbsp;");
//                    sw.WriteLine("</td></tr>");
//                    sw.Write("<tr ><td  colspan=30>&nbsp;");
//                    sw.WriteLine("</td></tr>");
//                    sw.Write("<tr align=center valign=bottom class=TotBord><td colspan=2 class=rightBorder><div class=TotBord><b>&nbsp;BASE</b><br /></div>");
//                    sw.Write("</td><td  colspan=3 class=rightBorder><div class=TotBord><b>SALES AVERAGES</b><br /></div>");
//                    sw.Write("</td><td  colspan=3 class=rightBorder><div class=TotBord><b>3 Year Sales Qty</b><br /></div>");
//                    sw.Write("</td><td  colspan=7 class=rightBorder><div class=TotBord><b>STOCK / ORDERS</b><br /></div>");
//                    sw.Write("</td><td  colspan=2 class=rightBorder><div class=TotBord><b>BUY</b><br /></div>");
//                    sw.Write("</td><td  colspan=5 class=rightBorder><div class=TotBord><b>NUMBER OF MONTHS</b><br /></div>");
//                    sw.WriteLine("</td></tr>");
//                    sw.Write("<tr align=center valign=bottom><td colspan=2 class=rightBorder>&nbsp;");
//                    sw.Write("</td><td  colspan=3 class=rightBorder>&nbsp;");
//                    sw.Write("</td><td  colspan=3 class=rightBorder><b>Period</b>");
//                    sw.Write("</td><td  colspan=4 class=rightBorder>&nbsp;");
//                    sw.Write("</td><td  colspan=2 class=rightBorder><b>OW Next</b>");
//                    sw.Write("</td><td  colspan=1 class=rightBorder>&nbsp;");
//                    sw.Write("</td><td  colspan=2 class=rightBorder>&nbsp;");
//                    sw.Write("</td><td  colspan=5 class=rightBorder>&nbsp;");
//                    sw.WriteLine("</td></tr>");
//                    sw.Write("<tr  align=right valign=bottom><td align=center width=100 class=TotBord>");
//                    sw.Write("Loc");
//                    sw.Write("</td><td width=40 class=TotBordGroup>");
//                    sw.Write("SV");
//                    sw.Write("</td><td width=80 class=TotBord>");
//                    sw.Write("3M");
//                    sw.Write("</td><td width=80 class=TotBord>");
//                    sw.Write("12M");
//                    sw.Write("</td><td width=80 class=TotBordGroup>");
//                    sw.Write("Use<br />30D");
//                    sw.Write("</td><td width=120 class=TotBord>");
//                    sw.Write("Prev1");
//                    sw.Write("</td><td width=100 class=TotBord>");
//                    sw.Write("Prev2");
//                    sw.Write("</td><td width=100 class=TotBordGroup>");
//                    sw.Write("Prev3");
//                    sw.Write("</td><td width=100 class=TotBord>");
//                    sw.Write("Avl");
//                    sw.Write("</td><td width=100 class=TotBord>");
//                    sw.Write("Trf");
//                    sw.Write("</td><td width=100 class=TotBord>");
//                    sw.Write("OO");
//                    sw.Write("</td><td width=100 class=TotBordGroup>");
//                    sw.Write("OW");
//                    sw.Write("</td><td width=100 class=TotBord>");
//                    sw.Write("Qty");
//                    sw.Write("</td><td width=120 class=TotBordGroup>");
//                    sw.Write("Date");
//                    sw.Write("</td><td width=100 class=TotBordGroup>");
//                    sw.Write("Total");
//                    sw.Write("</td><td width=120 class=TotBord>");
//                    sw.Write("FcstNeed");
//                    sw.Write("</td><td width=120 class=TotBordGroup>");
//                    sw.Write("NetBuy");
//                    sw.Write("</td><td width=120 class=TotBord>");
//                    sw.Write("Avl");
//                    sw.Write("</td><td width=90 class=TotBord>");
//                    sw.Write("Trf");
//                    sw.Write("</td><td width=90 class=TotBord>");
//                    sw.Write("OO");
//                    sw.Write("</td><td width=90 class=TotBord>");
//                    sw.Write("OW");
//                    sw.Write("</td><td width=100 class=TotBordGroup>");
//                    sw.Write("Total");
//                    sw.WriteLine("</td></tr>");

//                    foreach (DataRow cprRow in CatBuyData.Rows)
//                    {
//                        cellclass = "GridItem";
//                        cellGroupclass = "rightBorder";
//                        // set background on territory and final totals
//                        if (cprRow["LocationCode"].ToString().Trim().Length != 2)
//                        {
//                            if (cprRow["LocationCode"].ToString().Trim() != "Child")
//                            {
//                                cellclass = "TotBord";
//                                cellGroupclass = "TotBordGroup";
//                            }
//                        }

//                        sw.Write("<tr align=right><td align=center class=" + cellclass + ">");
//                        sw.Write(cprRow["LocationCode"]);
//                        sw.Write("</td><td class=" + cellGroupclass + ">");
//                        sw.Write(cprRow["SVCode"].ToString());
//                        sw.Write("&nbsp;</td><td class=" + cellclass + ">");
//                        sw.Write(string.Format("{0:N1}", cprRow["Avg3M"]));
//                        sw.Write("</td><td class=" + cellclass + ">");
//                        sw.Write(string.Format("{0:N1}", cprRow["Avg12M"]));
//                        sw.Write("</td><td class=" + cellGroupclass + ">");
//                        sw.Write(string.Format("{0:N1}", cprRow["Use30D"]));
//                        sw.Write("</td><td class=" + cellclass + ">");
//                        sw.Write(string.Format("{0:N0}", cprRow["Use_Year1_Qty"]));
//                        sw.Write("</td><td class=" + cellclass + ">");
//                        sw.Write(string.Format("{0:N0}", cprRow["Use_Year2_Qty"]));
//                        sw.Write("</td><td class=" + cellGroupclass + ">");
//                        sw.Write(string.Format("{0:N0}", cprRow["Use_Year3_Qty"]));
//                        sw.Write("</td><td class=" + cellclass + ">");
//                        sw.Write(string.Format("{0:N0}", cprRow["Avl"]));
//                        sw.Write("</td><td class=" + cellclass + ">");
//                        sw.Write(string.Format("{0:N0}", cprRow["Trf"]));
//                        sw.Write("</td><td class=" + cellclass + ">");
//                        sw.Write(string.Format("{0:N0}", cprRow["OO"]));
//                        sw.Write("</td><td class=" + cellGroupclass + ">");
//                        sw.Write(string.Format("{0:N0}", cprRow["OW"]));
//                        sw.Write("</td><td class=" + cellclass + ">");
//                        sw.Write(string.Format("{0:N0}", cprRow["OWNxtQty"]));
//                        sw.Write("</td><td class=" + cellGroupclass + ">");
//                        sw.Write(string.Format("{0:MM/dd/yy}", cprRow["OWNxtDate"]));
//                        sw.Write("&nbsp;</td><td class=" + cellGroupclass + ">");
//                        sw.Write(string.Format("{0:N0}", cprRow["TotalQty"]));
//                        sw.Write("</td><td class=" + cellclass + ">");
//                        sw.Write(string.Format("{0:N0}", cprRow["FcstNeed"]));
//                        sw.Write("</td><td class=" + cellGroupclass + ">");
//                        sw.Write(string.Format("{0:N0}", cprRow["NetBuy"]));
//                        sw.Write("</td><td class=" + cellclass + ">");
//                        sw.Write(string.Format("{0:N1}", cprRow["MosAvl"]));
//                        sw.Write("</td><td class=" + cellclass + ">");
//                        sw.Write(string.Format("{0:N1}", cprRow["MosTrf"]));
//                        sw.Write("</td><td class=" + cellclass + ">");
//                        sw.Write(string.Format("{0:N1}", cprRow["MosOO"]));
//                        sw.Write("</td><td class=" + cellclass + ">");
//                        sw.Write(string.Format("{0:N1}", cprRow["MosOW"]));
//                        sw.Write("</td><td class=" + cellGroupclass + ">");
//                        sw.Write(string.Format("{0:N1}", cprRow["MosTotal"]));
//                        sw.WriteLine("</td></tr>");
//                    }
//                }
//                else
//                {
//                    sw.WriteLine("<tr ><td colspan=30><div class=noData>No CPR Data on file</div></td></tr>");
//                    for (int count = 0; count < 15; count++) sw.WriteLine("<tr ><td colspan=30>&nbsp;</td></tr>");

//                }
//                pageCtr++;
//            }
//            sw.WriteLine("</table></body></html>");
//        }
//        using (StreamWriter statw = new StreamWriter(StatFilePath))
//        {
//            pageCtr++;
//            statw.WriteLine("Complete," + pageCtr.ToString());
//        }

//        //Response.Redirect("file:" + ExcelPath);
//    }

    public void BindPrintDialog()
    {
        Print.PageTitle = "Category Buy Report for " + Session["UserName"].ToString();
        // we build a url according to how the CPR report is configured
        // IntranetSite\PMReportDashboard\
        string CatBuyURL = "PMReportDashboard/CategoryBuyExport.aspx?RecID=" + Session["UserName"].ToString();
        //CatBuyURL += "&Factor=" + Session["CPRFactor"].ToString();
        //CatBuyURL += "&VMI=" + Session["VMIRun"].ToString();
        //if ((Boolean)Session["VMIRun"])
        //{
        //    CatBuyURL += "&VChain=" + VMIChain.Value.ToString();
        //    CatBuyURL += "&VContract=" + VMIContract.Value.ToString();
        //}
        //if (Session["CPRSort"] != null)
        //{
        //    if (Session["CPRSort"].ToString() == "SortPlating") CatBuyURL += "&Sort=substring(CPR.ItemNo,14,1),CPR.ItemNo";
        //    if (Session["CPRSort"].ToString() == "SortItem") CatBuyURL += "&Sort=CPR.ItemNo";
        //    if (Session["CPRSort"].ToString() == "SortVariance") CatBuyURL += "&Sort=substring(CPR.ItemNo,12,3),CPR.ItemNo";
        //    if (Session["CPRSort"].ToString() == "SortNetBuyBucks") CatBuyURL += "&Sort=FactoredBuyCost,CPR.ItemNo";
        //    if (Session["CPRSort"].ToString() == "SortNewBuyLBS") CatBuyURL += "&Sort=FactoredBuyQty*ItemMaster.Wght,CPR.ItemNo";
        //    if (Session["CPRSort"].ToString() == "SortCFVC") CatBuyURL += "&Sort=CorpFixedVelocity,CPR.ItemNo";
        //}
        Print.PageUrl = CatBuyURL;
    }
}
