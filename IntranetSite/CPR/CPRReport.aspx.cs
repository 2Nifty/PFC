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
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Utility;
using PFC.Intranet.Securitylayer;

public partial class CPRReport : System.Web.UI.Page
{
    PFC.Intranet.BusinessLogicLayer.CPR cpr = new PFC.Intranet.BusinessLogicLayer.CPR();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    int pagesize = 1;
    int lastRow;
    Decimal ANetTotal, AEstCostTotal;

    protected void Page_Init(object sender, EventArgs e)
    {
        Session["FooterTitle"] = "CPR Report";
        Session["FooterTitle"] = Session["UserName"].ToString();
        lblUserInfo.Text = DateTime.Now.ToLongDateString() + "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; You have logged in as <strong>" + Session["UserName"].ToString() + "</strong> in <strong>" + System.Configuration.ConfigurationManager.AppSettings["Environment"];
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            // Load NameValueCollection object.
            NameValueCollection coll = Request.QueryString;
            if (coll["Item"] != null)
            {
                cpr.LoadCurrentItems(Session["UserName"].ToString(), coll["Item"].ToString());
                Session["GridType"] = "Long";
                Session["VMIRun"] = false;
                Session["CPRFactor"] = decimal.Parse(coll["Factor"]);
            }
            //LinkButton1.Attributes.Add("onfocus", "javascript:document.getElementById('CPRPrintButton').focus();var WinPrint = window.open('Report.aspx','CPRPrint','toolbar=0,scrollbars=0,status=0,resizable=YES','');WinPrint.print();return false;");
            LinkButton1.Attributes.Add("onfocus", "javascript:document.getElementById('CPRPrintButton').focus();PrintCPR2();");
            if (Session["GridType"].ToString() == "Long")
                LongReport.Checked = true;
            if (Session["GridType"].ToString() == "Short")
                ShortReport.Checked = true;
            if (Session["GridType"].ToString() == "Transfer")
                TransferReport.Checked = true;
            if ((Boolean)Session["VMIRun"])
            {
                VMIRun.Value = Session["VMIRun"].ToString();
                string ChainContract = (String)Session["VMIContractCode"];
                string[] stringSeparators = new string[] { " - " };
                VMIChain.Value = ChainContract.Split(stringSeparators, StringSplitOptions.None)[0].Trim();
                VMIContract.Value = ChainContract.Split(stringSeparators, StringSplitOptions.None)[1].Trim();
            }
            HiddenFactor.Value = Session["CPRFactor"].ToString();
            HiddenIncludeSummQtys.Value = Session["IncludeSummQtys"].ToString();
            ReportPageName.Value = @"Excel/" + Session["UserName"].ToString() + "Report.aspx";
            StatusFileName.Value = @"Excel/Status" + Session["UserName"].ToString() + ".txt";
            string OrderBy = "CPR.ItemNo";
            if (Session["CPRSort"] != null)
            {
                if (Session["CPRSort"].ToString() == "SortPlating") OrderBy = "substring(CPR.ItemNo,14,1), CPR.ItemNo";
                if (Session["CPRSort"].ToString() == "SortItem") OrderBy = "CPR.ItemNo";
                if (Session["CPRSort"].ToString() == "SortVariance") OrderBy = "substring(CPR.ItemNo,12,3), CPR.ItemNo";
                if (Session["CPRSort"].ToString() == "SortNetBuyBucks") OrderBy = "FactoredBuyCost, CPR.ItemNo";
                if (Session["CPRSort"].ToString() == "SortNewBuyLBS") OrderBy = "FactoredBuyQty*ItemMaster.Wght, CPR.ItemNo";
                if (Session["CPRSort"].ToString() == "SortCFVC") OrderBy = "CorpFixedVelocity, CPR.ItemNo";
            }
            dt = cpr.GetCPRItems(Session["UserName"].ToString(), Session["CPRFactor"].ToString(), OrderBy).Tables[0];
            Session["MasterTable"] = dt;
            ItemGrid.DataSource = dt.DefaultView.ToTable();
            BindPage();
            BindPrintDialog();
        }
        else
        {
        }

    }

    protected void BindPage()
    {
        Pager1.InitPager(ItemGrid, pagesize);
        string CurItem = ItemGrid.Items[0].Cells[0].Text.Split(new Char[] { ' ' })[1].ToString();
        DataTable cprData = new DataTable();
        if (VMIRun.Value != "True")
        {
            // Process standard page
            VMIPanel.Visible = false;
            ItemPanel.Visible = true;
            VendorPanel.Visible = true;
            cprData = cpr.GetGPRGridData(CurItem, (decimal)Session["CPRFactor"], HiddenIncludeSummQtys.Value.ToString()).Tables[0];
            if (cprData.Rows.Count > 0)
            {
                lastRow = cprData.Rows.Count - 1;
                ItemDescLabel.Text = cprData.Rows[lastRow]["Description"].ToString();
                QtyUOMLabel.Text = string.Format("{0:N0}", cprData.Rows[lastRow]["UOM_Qty"]) + " / " + string.Format("{0:N0}", cprData.Rows[lastRow]["UOM"]);
                UOMWghtLabel.Text = string.Format("{0:N1}", cprData.Rows[lastRow]["Net_Wgt"]) + " Lbs";
                SuperEqLabel.Text = string.Format("{0:N0}", cprData.Rows[lastRow]["SupEqv_Qty"]) + " / "
                    + string.Format("{0:N0}", cprData.Rows[lastRow]["SupEqv_UOM"]);
                SuperPiecesLabel.Text = "<b>" + string.Format("{0:N0}", cprData.Rows[lastRow]["SupEqv_Pcs"]) + "</b> Pcs";
                LowPalletLabel.Text = "<b>" + string.Format("{0:N0}", cprData.Rows[lastRow]["LowPalletQty"]) + " / "
                   + string.Format("{0:N0}", cprData.Rows[lastRow]["LowPalletPcs"]) + "</b>";
                YrWgtUseLabel.Text = string.Format("{0:N1}", cprData.Rows[lastRow]["Item_Use_CY_Wgt"]) + " Lbs";
                Wgt100Label.Text = string.Format("{0:N2}", cprData.Rows[lastRow]["Wgt100"]);
                HarmCodeLabel.Text = cprData.Rows[lastRow]["PPI"].ToString();
                LLTagLabel.Text = cprData.Rows[lastRow]["LLTag"].ToString();
                if (HiddenFactor.Value.ToString() == "-1")
                {
                    FactorLabel.Text = cprData.Rows[lastRow]["CVFactor"].ToString();
                }
                else
                {
                    FactorLabel.Text = HiddenFactor.Value;
                }
                CFVLabel.Text = "CFV: <b>" + cprData.Rows[lastRow]["CorpFixedVelCode"].ToString() + "</b>";
                CFVLabel.Text += "&nbsp;&nbsp;PVC: <b>" + cprData.Rows[lastRow]["PackageVelocityCd"].ToString() + "</b>";
                LastCostLabel.Text = string.Format("{0:N3}", cprData.Rows[lastRow]["Last_CostM"]);
                UnitCostLabel.Text = string.Format("{0:N3}", cprData.Rows[lastRow]["Avg_CostM"]);
                BindCPRGrid(cprData);
                VendorGridView.DataSource = cpr.GetVendorData(CurItem).Tables[0];
                VendorGridView.DataBind();
            }
            else
            {
                ItemDescLabel.Text = "No CPR Data On File";
                QtyUOMLabel.Text = "";
                UOMWghtLabel.Text = "";
                SuperEqLabel.Text = "";
                SuperPiecesLabel.Text = "";
                LowPalletLabel.Text = "";
                YrWgtUseLabel.Text = "";
                Wgt100Label.Text = "";
                HarmCodeLabel.Text = "";
                CFVLabel.Text = "";
                LastCostLabel.Text = "";
                UnitCostLabel.Text = "";
                CPRGridView.DataBind();
                VendorGridView.DataBind();
                ATotalsGridView.DataBind();
            }

        }
        else
        {
            // process VMI page
            VMIPanel.Visible = true;
            ItemPanel.Visible = false;
            VendorPanel.Visible = false;
            System.Data.DataTable vmiData = new System.Data.DataTable();
            vmiData = cpr.GetVMIContractItem(VMIChain.Value, VMIContract.Value, CurItem).Tables[0];
            VMIChainLabel.Text = VMIChain.Value;
            VMIContractLabel.Text = VMIContract.Value;
            VMIBegLabel.Text = string.Format("{0:dd/MM/yy}",vmiData.Rows[0]["StartDate"]);
            VMIEndLabel.Text = string.Format("{0:dd/MM/yy}",vmiData.Rows[0]["EndDate"]);
            VMICustPOLabel.Text = vmiData.Rows[0]["CustomerPO"].ToString();
            VMIXRefLabel.Text = vmiData.Rows[0]["CrossRef"].ToString();
            VMIDescLabel.Text = vmiData.Rows[0]["ItemDesc"].ToString();
            VMISubItemLabel.Text = vmiData.Rows[0]["SubItemNo"].ToString();
            VMISalesPersonLabel.Text = vmiData.Rows[0]["Salesperson"].ToString();
            VMIUsageLabel.Text = string.Format("{0:N0}", vmiData.Rows[0]["EAU_Qty"]);
            VMIContactLabel.Text = vmiData.Rows[0]["Contact"].ToString() + " / " + vmiData.Rows[0]["ContactPhone"].ToString();
            VMIGPLabel.Text = string.Format("{0:N1}", vmiData.Rows[0]["E_Profit_Pct"]);
            VMIOrderMethodLabel.Text = vmiData.Rows[0]["OrderMethod"].ToString();
            VMIVendorLabel.Text = vmiData.Rows[0]["Vendor"].ToString();
            VMIFactorLabel.Text = string.Format("{0:N1}", vmiData.Rows[0]["MonthFactor"]);
            decimal MonthFactor = Decimal.Parse(vmiData.Rows[0]["MonthFactor"].ToString());
            cprData = cpr.GetGPRGridData(CurItem, MonthFactor, HiddenIncludeSummQtys.Value.ToString()).Tables[0];
            CPRDataLabel.Text = "";
            if (cprData.Rows.Count > 0)
            {
                lastRow = cprData.Rows.Count - 1;
                cprData.Rows[lastRow]["LocationCode"] = "Total";
                LastCostLabel.Text = string.Format("{0:N3}", cprData.Rows[lastRow]["Last_CostM"]);
                UnitCostLabel.Text = string.Format("{0:N3}", cprData.Rows[lastRow]["Avg_CostM"]);
                VendorGridView.DataSource = cpr.GetVendorData(CurItem).Tables[0];
                VendorGridView.DataBind();
                BindCPRGrid(cprData);
            }
            else
            {
                CPRDataLabel.Text = "No CPR Data on File.";
                VendorGridView.DataBind();
                CPRGridView.DataBind();
                ATotalsGridView.DataBind();
            }
        }

    }

    private void BindCPRGrid(DataTable cprData)
    {
        SetGridColumns();
        ds = FixCPRData(cprData);
        CPRGridView.DataSource = cprData;
        CPRGridView.DataBind();
        ATotalsGridView.DataSource = ds.Tables[0];
        ATotalsGridView.DataBind();
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

    public void Report_CheckedChanged(Object sender, EventArgs e)
    {
        SetGridColumns();
        if (LongReport.Checked)
        {
            string CurItem = ItemGrid.Items[0].Cells[0].Text.Split(new Char[] { ' ' })[1].ToString();
            System.Data.DataTable cprData = new System.Data.DataTable();
            cprData = cpr.GetGPRGridData(CurItem, (decimal)Session["CPRFactor"], HiddenIncludeSummQtys.Value.ToString()).Tables[0];
            if (cprData.Rows.Count > 0)
            {
                int lastRow = cprData.Rows.Count - 1;
                cprData.Rows[lastRow]["LocationCode"] = "Total";
                CPRGridView.DataSource = cprData;
                CPRGridView.DataBind();
            }
        }

    }

    protected void SetGridColumns()
    {
        if (LongReport.Checked)
        {
            CPRHeadingTable.Rows[0].Cells[5].Visible = true;
            CPRHeadingTable.Rows[0].Cells[2].Width = 455;
            CPRHeadingTable.Rows[0].Cells[3].Width = 155;
            //CPRHeadingTable.Width = 1030;
            CPRGridView.Columns[11].Visible = true;
            CPRGridView.Columns[12].Visible = true;
            CPRGridView.Columns[13].Visible = true;
            CPRGridView.Columns[15].Visible = true;
            CPRGridView.Columns[16].Visible = true;
            CPRGridView.Columns[22].Visible = true;
            CPRGridView.Columns[23].Visible = true;
            CPRGridView.Columns[24].Visible = true;
            ATotalsGridView.Visible = true;
        };
        if (ShortReport.Checked)
        {
            CPRHeadingTable.Rows[0].Cells[5].Visible = false;
            CPRHeadingTable.Rows[0].Cells[2].Width = 320;
            CPRHeadingTable.Rows[0].Cells[3].Width = 45;
            //CPRHeadingTable.Width = 800;
            CPRGridView.Columns[11].Visible = false;
            CPRGridView.Columns[12].Visible = false;
            CPRGridView.Columns[13].Visible = false;
            CPRGridView.Columns[15].Visible = false;
            CPRGridView.Columns[16].Visible = false;
            CPRGridView.Columns[22].Visible = false;
            CPRGridView.Columns[23].Visible = false;
            CPRGridView.Columns[24].Visible = false;
            ATotalsGridView.Visible = false;
        };
        //if (TransferReport.Checked)
        //{
        //    CPRHeadingTable.Rows[0].Cells[5].Visible = false;
        //    CPRHeadingTable.Rows[0].Cells[2].Width = 320;
        //    CPRHeadingTable.Rows[0].Cells[3].Width = 45;
        //    //CPRHeadingTable.Width = 800;
        //    CPRGridView.Columns[11].Visible = false;
        //    CPRGridView.Columns[12].Visible = false;
        //    CPRGridView.Columns[13].Visible = false;
        //    CPRGridView.Columns[15].Visible = false;
        //    CPRGridView.Columns[16].Visible = false;
        //    CPRGridView.Columns[22].Visible = false;
        //    CPRGridView.Columns[23].Visible = false;
        //    CPRGridView.Columns[24].Visible = false;
        //    ATotalsGridView.Visible = false;
        //};
        BindPrintDialog();
    }

    protected void CPRLineFormat(object source, GridViewRowEventArgs e)
    {
        int lastCell = e.Row.Cells.Count - 1;
        TableCell tempCell = new TableCell();
        int newWidth = 0;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // shade columns
            if (e.Row.Cells[lastCell].Text == "1")
            {
                e.Row.Cells[lastCell - 1].ForeColor = Color.Gray;
            }
            else
            {
                e.Row.Cells[lastCell - 1].Font.Bold = true;
            }
            e.Row.Cells[lastCell].Text = "";
            // set background on territory and final totals
            if (e.Row.Cells[0].Text.Trim().Length != 2)
            {
                if (e.Row.Cells[0].Text.Trim() != "Child")
                {

                    for (int col = 0; col < lastCell; col++)
                    {
                        e.Row.Cells[col].CssClass = "TotBord";
                        switch (col)
                        {
                            case 1:
                            case 4:
                            case 8:
                            case 10:
                            case 12:
                            case 13:
                            case 16:
                            case 21:
                            case 22:
                            case 23:
                            case 24:
                                e.Row.Cells[col].CssClass = "TotBordGroup";
                                break;
                        }
    //                    cell.BackColor = Color.PowderBlue;
                    }
                }
            }
        }
    }

    protected void PosLineFormat(object source, GridViewRowEventArgs e)
    {
        int TitleWidth = 0;
        TableItemStyle CelStyle = new TableItemStyle();

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            // set the actual width
            for (int i = 0; i <= 12; i++)
            {
                TitleWidth += (int)CPRGridView.Columns[i].ItemStyle.Width.Value;
            }
            e.Row.Cells[0].Width = TitleWidth - 5;
            e.Row.Cells[1].Width = (int)CPRGridView.Columns[13].ItemStyle.Width.Value;
            e.Row.Cells[2].Width = (int)CPRGridView.Columns[14].ItemStyle.Width.Value + 1;
        }
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        ItemGrid.CurrentPageIndex = Pager1.GotoPageNumber;
        dt = (System.Data.DataTable)Session["MasterTable"];
        ItemGrid.DataSource = dt.DefaultView.ToTable();
        BindPage();
    }

    //protected void CPRPrintButton_Click(object sender, ImageClickEventArgs e)
    //{
    //    string SiteFileName = ReportPageName.Value.ToString();
    //    CreateCPRReport(SiteFileName);
    //    Session["CPRStatus"] = "0";
    //    Session["CPRTotPages"] = dt.Rows.Count.ToString();

    //    //LinkButton1.Focus();
    //}

    protected void ExcelExportButton_Click(object sender, ImageClickEventArgs e)
    {
        //string ExcelPath = ConfigurationManager.AppSettings["CPRExcelFilePath"].ToString() + "CPRExcel.xls";
        string SiteFileName = @"Excel\"
            + Session["UserName"].ToString()
            + "Export.xls";
        CreateCPRReport(SiteFileName);
        Response.Redirect(SiteFileName);
    }

    public void CreateCPRReport(string FileName)
    {
        string FullFilePath = Server.MapPath(FileName);
        string StatFilePath = Server.MapPath(StatusFileName.Value);
        string cellclass = "GridItem";
        string cellGroupclass = "rightBorder";
        int pageCtr = 0;
        dt = (System.Data.DataTable)Session["MasterTable"];
        // 
        using (StreamWriter sw = new StreamWriter(FullFilePath))
        {
            sw.WriteLine("<html><head>");
            sw.WriteLine("<link href=../Common/StyleSheet/Styles.css rel=stylesheet type=text/css />");
            sw.WriteLine("<style>");
            sw.WriteLine(".NewPage {page-break-before: always;}");
            sw.WriteLine(".GridItem {font-family: 'Arial Narrow', Arial, Helvetica, sans-serif;	font-size: 16px; color: #000000; text-decoration:none; padding-top: 3px; padding-right: 3px; padding-bottom: 2px;}");
            sw.WriteLine(".noData {font-weight: bold; font-size: 32px; }");
            sw.WriteLine("</style><title>CPR Printed</title>");
            sw.WriteLine("</head><body onLoad=\"window.print();\">");
            if (LongReport.Checked)
            {
                if (VMIRun.Value != "True")
                {
                    sw.WriteLine("<table border=0 cellspacing=0 cellpadding=0 class=GridItem width=1500px>");
                }
                else
                {
                    sw.WriteLine("<table border=0 cellspacing=0 cellpadding=0 class=GridItem width=1200px>");
                }
            }
            else
            {
                sw.WriteLine("<table border=0 cellspacing=0 cellpadding=0 class=GridItem width=1800px>");
            }
            foreach (DataRow row in dt.Rows)
            {
                using (StreamWriter statw = new StreamWriter(StatFilePath))
                {
                    statw.WriteLine(row["ItemNo"].ToString().Substring(0, 5) + "," + pageCtr.ToString());
                }
                if (pageCtr > 0)
                {
                    sw.WriteLine("<tr class=NewPage><td colspan=30>&nbsp;</td></tr>");
                }
                sw.Write("<tr ><td colspan=8 style=\"font-size: 24px;\"><b>");
                sw.Write(row["ItemNo"]);
                sw.Write("</b>");
                System.Data.DataTable cprData = cpr.GetGPRGridData(row["ItemNo"].ToString(), (decimal)Session["CPRFactor"], HiddenIncludeSummQtys.Value.ToString()).Tables[0];
                if (VMIRun.Value != "True")
                {
                    sw.Write("</td><td colspan=25 rowspan=10 valign=top>");

                    if (cprData.Rows.Count > 0)
                    {
                        lastRow = cprData.Rows.Count - 1;
                        sw.Write(string.Format("<span  style=\"font-size: 20px;\">Last Cost&nbsp;&nbsp;<b>{0:N3}</b>", cprData.Rows[lastRow]["Last_CostM"]));
                        sw.Write(string.Format("<br />Avg. Cost&nbsp;&nbsp;<b>{0:N3}</b><br /></span>", cprData.Rows[lastRow]["Avg_CostM"]));
                    }


                    System.Data.DataTable vendData = cpr.GetVendorData(row["ItemNo"].ToString()).Tables[0];
                    if (vendData.Rows.Count > 0)
                    {
                        sw.WriteLine("<table border=0 cellspacing=3 cellpadding=0 class=GridItem>");
                        sw.Write("<tr  align=right><td width=80 align=Center>");
                        sw.Write("Loc</td><td width=30>");
                        sw.Write("Co</td><td width=50>");
                        sw.Write("FOB</td><td width=40>");
                        sw.Write("Diff</td><td width=50>");
                        sw.Write("Duty</td><td width=50>");
                        sw.Write("F/Lb</td><td width=50>");
                        sw.Write("Land</td><td width=40>");
                        sw.Write("Diff</td><td width=50>");
                        sw.Write("L/Lb</td><td width=50>");
                        sw.Write("Cartons</td><td width=50>");
                        sw.WriteLine("</td></tr>");
                        foreach (DataRow vendRow in vendData.Rows)
                        {
                            sw.Write("<tr  align=right><td width=10 align=left>");
                            sw.Write(vendRow["VendorName"]);
                            sw.Write("</td><td>");
                            sw.Write(vendRow["CountryCode"]);
                            sw.Write("</td><td>");
                            sw.Write(string.Format("{0:N2}", vendRow["FOB_Cost"]));
                            sw.Write("</td><td>");
                            sw.Write(string.Format("{0:N1}%", vendRow["FOB_Diff"]));
                            sw.Write("</td><td>");
                            sw.Write(string.Format("{0:N2}", vendRow["DutyRate"]));
                            sw.Write("</td><td>");
                            sw.Write(string.Format("{0:N2}", vendRow["FOB_Wgt"]));
                            sw.Write("</td><td>");
                            sw.Write(string.Format("{0:N2}", vendRow["Land_Cost"]));
                            sw.Write("</td><td>");
                            sw.Write(string.Format("{0:N0}%", vendRow["Land_Diff"]));
                            sw.Write("</td><td>");
                            sw.Write(string.Format("{0:N2}", vendRow["Land_Wgt"]));
                            sw.Write("</td><td>");
                            sw.Write(string.Format("{0:N0}", vendRow["VendorCartons"]));
                            sw.WriteLine("</td></tr>");
                        }
                        sw.WriteLine("</table>");
                    }
                    else
                    {
                        sw.Write("<div class=noData>No Vendor Data Available</div>");
                    }
                }
                else
                {
                    sw.Write("</td></tr><tr ><td colspan=30>Customer Chain&nbsp;");
                    // VMI Heading
                    System.Data.DataTable vmiData = new System.Data.DataTable();
                    vmiData = cpr.GetVMIContractItem(VMIChain.Value, VMIContract.Value, row["ItemNo"].ToString()).Tables[0];
                    sw.Write( VMIChain.Value);
                    sw.Write("</td></tr><tr ><td colspan=8>");
                    sw.Write(VMIContract.Value);
                    sw.Write("</td></tr><tr ><td colspan=8>Effective&nbsp;");
                    sw.Write(string.Format("{0:MM/dd/yy} thru ", vmiData.Rows[0]["StartDate"]));
                    sw.Write(string.Format("{0:MM/dd/yy}", vmiData.Rows[0]["EndDate"]));
                    sw.Write("</td></tr><tr ><td colspan=8>Cust PO&nbsp;");
                    sw.Write(vmiData.Rows[0]["CustomerPO"].ToString());
                    sw.Write("</td></tr><tr ><td colspan=8>Cross Ref #&nbsp;");
                    sw.Write(vmiData.Rows[0]["CrossRef"].ToString());
                    sw.Write("</td></tr><tr ><td colspan=8>Desc:&nbsp;");
                    sw.Write(vmiData.Rows[0]["ItemDesc"].ToString());
                    sw.Write("</td></tr><tr ><td colspan=8>Sub Item #&nbsp;");
                    sw.Write(vmiData.Rows[0]["SubItemNo"].ToString());
                    sw.Write("</td></tr><tr ><td colspan=8>PFC Salesperson&nbsp;");
                    sw.Write(vmiData.Rows[0]["Salesperson"].ToString());
                    sw.Write("</td></tr><tr ><td colspan=8>Annual Usage Qty&nbsp;");
                    sw.Write(string.Format("{0:N0}", vmiData.Rows[0]["EAU_Qty"]));
                    sw.Write("</td></tr><tr ><td colspan=8>Contact&nbsp;");
                    sw.Write(vmiData.Rows[0]["Contact"].ToString() + " / " + vmiData.Rows[0]["ContactPhone"].ToString());
                    sw.Write("</td></tr><tr ><td colspan=8>Expected GP %&nbsp;");
                    sw.Write(string.Format("{0:N1}", vmiData.Rows[0]["E_Profit_Pct"]));
                    sw.Write("</td></tr><tr ><td colspan=8>Order Method&nbsp;");
                    sw.Write(vmiData.Rows[0]["OrderMethod"].ToString());
                    sw.Write("</td></tr><tr ><td colspan=8>Vendor Code&nbsp;");
                    sw.Write(vmiData.Rows[0]["Vendor"].ToString());
                    sw.Write("</td></tr><tr ><td colspan=8>Month Factor&nbsp;");
                    sw.Write(string.Format("{0:N1}", vmiData.Rows[0]["MonthFactor"]));
//                    sw.Write(Decimal.Parse(vmiData.Rows[0]["MonthFactor"].ToString()));
                    //sw.WriteLine("</td></tr>");

                }
                sw.WriteLine("</td></tr>");
                if (cprData.Rows.Count > 0)
                {
                    lastRow = cprData.Rows.Count - 1;
                    ds = FixCPRData(cprData);
                    if (VMIRun.Value != "True")
                    {
                        sw.Write("<tr ><td colspan=8>");
                        sw.Write(cprData.Rows[lastRow]["Description"].ToString());
                        sw.Write("</td></tr><tr ><td colspan=8>");
                        sw.Write(string.Format("Qty/Uom&nbsp;&nbsp;{0:N0}", cprData.Rows[lastRow]["UOM_Qty"]) + " / "
                            + string.Format("{0:N0}", cprData.Rows[lastRow]["UOM"]));
                        sw.Write("</td></tr><tr ><td colspan=8>");
                        sw.Write(string.Format("Weight&nbsp;&nbsp;{0:N1}", cprData.Rows[lastRow]["Net_Wgt"]) + " Lbs");
                        sw.Write("</td></tr><tr ><td colspan=8>");
                        sw.Write(string.Format("Super Eqv&nbsp;&nbsp;<b>{0:N0}", cprData.Rows[lastRow]["SupEqv_Qty"]) + " / "
                            + string.Format("{0:N0}", cprData.Rows[lastRow]["SupEqv_UOM"]));
                        sw.Write("</b>&nbsp;&nbsp;&nbsp;&nbsp;Pieces&nbsp;&nbsp;" + string.Format("{0:N0}", cprData.Rows[lastRow]["SupEqv_Pcs"]) + " Pcs");
                        sw.Write("</td></tr><tr ><td colspan=8>");
                        sw.Write(string.Format("Yearly Usage Weight&nbsp;&nbsp;{0:N1}", cprData.Rows[lastRow]["Item_Use_CY_Wgt"]) + " Lbs");
                        sw.Write("</td></tr><tr ><td colspan=8>");
                        sw.Write(string.Format("Weight/100&nbsp;&nbsp;{0:N2}", cprData.Rows[lastRow]["Wgt100"]));
                        sw.Write("</td></tr><tr ><td colspan=8>Harmonizing Code&nbsp;&nbsp;");
                        sw.Write(cprData.Rows[lastRow]["PPI"].ToString());
                        sw.Write("</td></tr><tr ><td colspan=8>Factor&nbsp;&nbsp;");
                        sw.Write(HiddenFactor.Value);
                        sw.Write("</td></tr><tr ><td colspan=8>");
                        sw.Write("CFV: <b>" + cprData.Rows[lastRow]["CorpFixedVelCode"].ToString() + "</b>");
                        sw.WriteLine("</td></tr>");
                    }
                    // start heading
                    sw.Write("<tr ><td  colspan=30>&nbsp;");
                    sw.WriteLine("</td></tr>");
                    sw.Write("<tr ><td  colspan=30>&nbsp;");
                    sw.WriteLine("</td></tr>");
                    sw.Write("<tr align=center valign=bottom class=TotBord><td colspan=2 class=rightBorder><div class=TotBord><b>&nbsp;BASE</b><br /></div>");
                    sw.Write("</td><td  colspan=3 class=rightBorder><div class=TotBord><b>SALES AVERAGES</b><br /></div>");
                    sw.Write("</td><td  colspan=9 class=rightBorder><div class=TotBord><b>STOCK / ORDERS</b><br /></div>");
                    sw.Write("</td><td  colspan=3 class=rightBorder><div class=TotBord><b>BUY</b><br /></div>");
                    sw.Write("</td><td  colspan=5 class=rightBorder><div class=TotBord><b>NUMBER OF MONTHS</b><br /></div>");
                    sw.Write("</td><td  colspan=4 class=rightBorder><div class=TotBord><b>MISCELLANEOUS</b><br /></div>");
                    sw.Write("</td><td  colspan=6 >&nbsp;");
                    sw.WriteLine("</td></tr>");
                    sw.Write("<tr align=center valign=bottom><td colspan=2 class=rightBorder>&nbsp;");
                    sw.Write("</td><td  colspan=3 class=rightBorder>&nbsp;");
                    sw.Write("</td><td  colspan=4 class=rightBorder>&nbsp;");
                    sw.Write("</td><td  colspan=2 class=rightBorder><b>OO Next</b>");
                    sw.Write("</td><td  colspan=2 class=rightBorder><b>OW Next</b>");
                    sw.Write("</td><td  colspan=1 class=rightBorder>&nbsp;");
                    sw.Write("</td><td  colspan=3 class=rightBorder>&nbsp;");
                    sw.Write("</td><td  colspan=5 class=rightBorder>&nbsp;");
                    sw.Write("</td><td  colspan=3 class=rightBorder>&nbsp;");
                    sw.Write("</td><td  colspan=1 class=rightBorder>&nbsp;");
                    sw.Write("</td><td  colspan=6 >&nbsp;");
                    sw.WriteLine("</td></tr>");
                    sw.Write("<tr  align=right valign=bottom><td align=center width=100 class=TotBord>");
                    sw.Write("Loc");
                    sw.Write("</td><td width=40 class=TotBordGroup>");
                    sw.Write("SV");
                    sw.Write("</td><td width=80 class=TotBord>");
                    sw.Write("3M");
                    sw.Write("</td><td width=80 class=TotBord>");
                    sw.Write("12M");
                    sw.Write("</td><td width=80 class=TotBordGroup>");
                    sw.Write("Use<br />30D");
                    sw.Write("</td><td width=120 class=TotBord>");
                    sw.Write("Avl");
                    sw.Write("</td><td width=100 class=TotBord>");
                    sw.Write("Trf");
                    sw.Write("</td><td width=100 class=TotBord>");
                    sw.Write("OO");
                    sw.Write("</td><td width=100 class=TotBordGroup>");
                    sw.Write("OW");
                    sw.Write("</td><td width=100 class=TotBord>");
                    sw.Write("Qty");
                    sw.Write("</td><td width=120 class=TotBordGroup>");
                    sw.Write("Date");
                    sw.Write("</td><td width=100 class=TotBord>");
                    if (LongReport.Checked)
                    {
                        sw.Write("Qty");
                        sw.Write("</td><td width=120 class=TotBordGroup>");
                        sw.Write("Date");
                        sw.Write("</td><td width=120 class=TotBordGroup>");
                    }
                    sw.Write("Total");
                    sw.Write("</td><td width=120 class=TotBord>");
                    sw.Write("FcstNeed");
                    sw.Write("</td><td width=120 class=TotBord>");
                    sw.Write("NetBuy");
                    sw.Write("</td><td width=120 class=TotBordGroup>");
                    sw.Write("EstBuyCost");
                    sw.Write("</td><td width=90 class=TotBord>");
                    sw.Write("Avl");
                    sw.Write("</td><td width=90 class=TotBord>");
                    sw.Write("Trf");
                    sw.Write("</td><td width=90 class=TotBord>");
                    sw.Write("OO");
                    sw.Write("</td><td width=90 class=TotBord>");
                    sw.Write("OW");
                    sw.Write("</td><td width=100 class=TotBordGroup>");
                    sw.Write("Total");
                    if (LongReport.Checked)
                    {
                        sw.Write("</td><td width=90 class=TotBord>");
                        sw.Write("ROP");
                        sw.Write("</td><td width=90 class=TotBord>");
                        sw.Write("ROP<br />Cust");
                        sw.Write("</td><td width=90 class=TotBordGroup>");
                        sw.Write("ROP<br />-ATO");
                    }
                    sw.Write("</td><td class=TotBordGroup>Action");
                    sw.Write("</td><td>&nbsp;");
                    sw.WriteLine("</td></tr>");



                    foreach (DataRow cprRow in cprData.Rows)
                    {
                        cellclass = "GridItem";
                        cellGroupclass = "rightBorder";
                        // set background on territory and final totals
                        if (cprRow["LocationCode"].ToString().Trim().Length != 2)
                        {
                            if (cprRow["LocationCode"].ToString().Trim() != "Child")
                            {
                                cellclass = "TotBord";
                                cellGroupclass = "TotBordGroup";
                            }
                        }

                        sw.Write("<tr align=right><td align=center class=" + cellclass + ">");
                        sw.Write(cprRow["LocationCode"]);
                        sw.Write("</td><td class=" + cellGroupclass + ">");
                        sw.Write(cprRow["SVCode"].ToString());
                        sw.Write("&nbsp;</td><td class=" + cellclass + ">");
                        sw.Write(string.Format("{0:N1}", cprRow["Avg3M"]));
                        sw.Write("</td><td class=" + cellclass + ">");
                        sw.Write(string.Format("{0:N1}", cprRow["Avg12M"]));
                        sw.Write("</td><td class=" + cellGroupclass + ">");
                        sw.Write(string.Format("{0:N1}", cprRow["Use30D"]));
                        sw.Write("</td><td class=" + cellclass + ">");
                        sw.Write(string.Format("{0:N0}", cprRow["Avl"]));
                        sw.Write("</td><td class=" + cellclass + ">");
                        sw.Write(string.Format("{0:N0}", cprRow["Trf"]));
                        sw.Write("</td><td class=" + cellclass + ">");
                        sw.Write(string.Format("{0:N0}", cprRow["OO"]));
                        sw.Write("</td><td class=" + cellGroupclass + ">");
                        sw.Write(string.Format("{0:N0}", cprRow["OW"]));
                        sw.Write("</td><td class=" + cellclass + ">");
                        sw.Write(string.Format("{0:N0}", cprRow["OONxtQty"]));
                        sw.Write("</td><td class=" + cellGroupclass + ">");
                        sw.Write(string.Format("{0:MM/dd/yy}", cprRow["OONxtDate"]));
                        if (LongReport.Checked)
                        {
                            sw.Write("&nbsp;</td><td class=" + cellclass + ">");
                            sw.Write(string.Format("{0:N0}", cprRow["OWNxtQty"]));
                            sw.Write("</td><td class=" + cellGroupclass + ">");
                            sw.Write(string.Format("{0:MM/dd/yy}", cprRow["OWNxtDate"]));
                        }
                        sw.Write("&nbsp;</td><td class=" + cellGroupclass + ">");
                        sw.Write(string.Format("{0:N0}", cprRow["TotalQty"]));
                        sw.Write("</td><td class=" + cellclass + ">");
                        sw.Write(string.Format("{0:N0}", cprRow["FcstNeed"]));
                        sw.Write("</td><td class=" + cellclass + ">");
                        sw.Write(string.Format("{0:N0}", cprRow["NetBuy"]));
                        sw.Write("</td><td class=" + cellGroupclass + ">");
                        sw.Write(string.Format("{0:N0}", cprRow["EstBuyCost"]));
                        sw.Write("</td><td class=" + cellclass + ">");
                        sw.Write(string.Format("{0:N1}", cprRow["MosAvl"]));
                        sw.Write("</td><td class=" + cellclass + ">");
                        sw.Write(string.Format("{0:N1}", cprRow["MosTrf"]));
                        sw.Write("</td><td class=" + cellclass + ">");
                        sw.Write(string.Format("{0:N1}", cprRow["MosOO"]));
                        sw.Write("</td><td class=" + cellclass + ">");
                        sw.Write(string.Format("{0:N1}", cprRow["MosOW"]));
                        sw.Write("</td><td class=" + cellGroupclass + ">");
                        sw.Write(string.Format("{0:N1}", cprRow["MosTotal"]));
                        if (LongReport.Checked)
                        {
                            sw.Write("</td><td class=" + cellGroupclass + ">");
                            sw.Write(string.Format("{0:N1}", cprRow["ROP"]));
                            sw.Write("</td><td class=" + cellGroupclass + ">");
                            sw.Write(string.Format("{0:N1}&nbsp;", cprRow["PCROP"]));
                            if ((int)cprRow["ROPShade"] == 1)
                            {
                                sw.Write("</td><td class=" + cellGroupclass + " bgcolor=silver>");
                            }
                            else
                            {
                                sw.Write("</td><td class=" + cellGroupclass + ">");
                            }
                            sw.Write(string.Format("{0:N1}&nbsp;", cprRow["ROPRem"]));
                            sw.Write("</td><td>_______");
                        }
                        sw.Write("</td><td>&nbsp;");
                        sw.WriteLine("</td></tr>");
                    }
                    if (LongReport.Checked)
                    {
                        sw.Write("<tr align=right><td colspan=14 class=" + cellclass + ">&nbsp;");
                        sw.Write("</td><td class=" + cellclass + ">Pos:");
                        sw.Write("</td><td class=" + cellclass + ">" + string.Format("{0:N1}&nbsp;", ds.Tables[0].Rows[0]["ANetTotal"]));
                        sw.Write("</td><td class=" + cellGroupclass + ">" + string.Format("{0:N1}&nbsp;", ds.Tables[0].Rows[0]["AEstCostTotal"]) + "</td></tr>");
                    }
                }
                else
                {
                    sw.WriteLine("<tr ><td colspan=30><div class=noData>No CPR Data on file</div></td></tr>");
                    for (int count = 0; count < 15; count++) sw.WriteLine("<tr ><td colspan=30>&nbsp;</td></tr>");

                }
                pageCtr++;
            }
            sw.WriteLine("</table></body></html>");
        }
        using (StreamWriter statw = new StreamWriter(StatFilePath))
        {
            pageCtr++;
            statw.WriteLine("Complete," + pageCtr.ToString());
        }

        //Response.Redirect("file:" + ExcelPath);
    }

    public void BindPrintDialog()
    {
        Print.PageTitle = "CPR for " + Session["UserName"].ToString();
        // we build a url according to how the CPR report is configured
        // CPRReportExport.aspx?RecID=toms&Factor=3&Long=True&VMI=False
        // CPRReportExport.aspx?RecID=toms&Factor=3&Long=True&VMI=True&VChain=WURT&VContract=2006-01
        string CPRURL = "CPR/CPRReportExport.aspx?RecID=" + Session["UserName"].ToString();
        CPRURL += "&Factor=" + Session["CPRFactor"].ToString();
        CPRURL += "&IncludeSummQtys=" + Session["IncludeSummQtys"].ToString();
        if (LongReport.Checked)
        {
            CPRURL += "&Format=Long";
        }
        if (ShortReport.Checked)
        {
            CPRURL += "&Format=Short";
        }
        if (TransferReport.Checked)
        {
            CPRURL += "&Format=Transfer";
        }
        CPRURL += "&VMI=" + Session["VMIRun"].ToString();
        if ((Boolean)Session["VMIRun"])
        {
            CPRURL += "&VChain=" + VMIChain.Value.ToString();
            CPRURL += "&VContract=" + VMIContract.Value.ToString();
        }
        if (Session["CPRSort"] != null)
        {
            if (Session["CPRSort"].ToString() == "SortPlating") CPRURL += "&Sort=substring(CPR.ItemNo,14,1),CPR.ItemNo";
            if (Session["CPRSort"].ToString() == "SortItem") CPRURL += "&Sort=CPR.ItemNo";
            if (Session["CPRSort"].ToString() == "SortVariance") CPRURL += "&Sort=substring(CPR.ItemNo,12,3),CPR.ItemNo";
            if (Session["CPRSort"].ToString() == "SortNetBuyBucks") CPRURL += "&Sort=FactoredBuyCost,CPR.ItemNo";
            if (Session["CPRSort"].ToString() == "SortNewBuyLBS") CPRURL += "&Sort=FactoredBuyQty*ItemMaster.Wght,CPR.ItemNo";
            if (Session["CPRSort"].ToString() == "SortCFVC") CPRURL += "&Sort=CorpFixedVelocity,CPR.ItemNo";
        }
        Print.PageUrl = CPRURL;
        Print.FormName = "CPRReport";
        //ItemDescLabel.Text = CPRURL;
    }
}
