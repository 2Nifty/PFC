using System;
using System.Collections.Specialized;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.SOE.DataAccessLayer;

public partial class StockStatus : System.Web.UI.Page 
{
    //PFC.Intranet.BusinessLogicLayer.SS cpr = new PFC.Intranet.BusinessLogicLayer.SS();
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
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
    string ImageLibrary = ConfigurationManager.AppSettings["ProductImagesPath"].ToString();

    protected void Page_Init(object sender, EventArgs e)
    {
        Session["FooterTitle"] = "Stock Status";
        HeadImageUpdatePanel.Visible = false;
        BodyImageUpdatePanel.Visible = false;
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            CPRFactor.Text = "1";
            Session["StockData"] = null;
            //CPRFactor.ForeColor = Color.Gray; if (this.value == 'Factor') {this.style.color = 'black'; this.style.fontWeight = 'bold'; this.value='';} else 
            CalledBy.Value = "";
            ParentCall.Value = "0";
            tblPager.Visible = false;
            RunCPRButt.Visible = false;
            CPRFactor.Visible = false;
            PrintUpdatePanel.Visible = false;
            LocSortHidden.Value = "SortKey";

            if (Request.QueryString["UserName"] != null)
                Session["UserName"] = Request.QueryString["UserName"].ToString();

            NameValueCollection coll = Request.QueryString;
            // Load NameValueCollection object.
            if (coll["ItemNo"] != null && coll["ItemNo"].ToString().Length > 0)
            {
                ItemNoTextBox.Text = coll["ItemNo"].ToString();
                GetItem(coll["ItemNo"].ToString());
            }
            else
            {
                ShowPageMessage("Enter an Item", 0);
                StockStatusScriptManager.FindControl("ItemNoTextBox").Focus();
            }
            if (coll["ListCall"] != null)
            {
                CalledBy.Value = "SSList";
            }
            if (coll["ParentCall"] != null)
            {
                ParentCall.Value = "1";
                CalledBy.Value = "SSParent";
            }
            else
            {
                ParentLabel.Font.Underline = true;
            }
        }
        else
        {
        }

    }

    protected void ItemButt_Click(object sender, EventArgs e)
    {
        try
        {
            // here we are checking for pfc part number with z-item processing
            ClearPageMessages();
            ClearItemData(true);
            // try to find the item.
            GetItem(ItemNoTextBox.Text);
            ScriptManager.RegisterClientScriptBlock(ItemNoTextBox, ItemNoTextBox.GetType(), "resize", "SetHeight();", true);
        }
        catch (Exception ex1)
        {
            ShowPageMessage("Get Item Error " + ex1.Message + ", " + ex1.ToString(), 2);
        }
    }

    protected void GetItem(string ItemNo)
    {
        RunCPRButt.Visible = false;
        CPRFactor.Visible = false;
        PrintUpdatePanel.Visible = false;
        // get the package and plating data.
        ds = SqlHelper.ExecuteDataset(connectionString, "pSSGetItem",
            new SqlParameter("@SearchItemNo", ItemNo),
            new SqlParameter("@UserName", Session["UserName"].ToString()));
        if (ds.Tables.Count >= 1)
        {
            if (ds.Tables.Count == 1)
            {
                // We only go one table back, something is wrong
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    ShowPageMessage("Item not found.", 2);
                }
            }
            else
            {
                dt = ds.Tables[1];
                ItemDescLabel.Text = dt.Rows[0]["ItemDesc"].ToString();
                Wgt100Label.Text = FormatScreenData(Num2Format, dt.Rows[0]["HundredWght"]);
                QtyUOMLabel.Text = dt.Rows[0]["SellGlued"].ToString();
                StdCostLabel.Text = dt.Rows[0]["CostGlued"].ToString();
                UPCLabel.Text = dt.Rows[0]["UPC"].ToString();
                WebLabel.Text = dt.Rows[0]["WebEnabled"].ToString();
                CategoryLabel.Text = dt.Rows[0]["CatDesc"].ToString();
                NetWghtLabel.Text = FormatScreenData(Num2Format, dt.Rows[0]["NetWght"]);
                SuperEqLabel.Text = dt.Rows[0]["SuperGlued"].ToString();
                LowProfileLabel.Text = FormatScreenData(Num0Format, dt.Rows[0]["LowProfileQty"]);
                ListLabel.Text = FormatScreenData(Num2Format, dt.Rows[0]["ListPrice"]);
                HarmCodeLabel.Text = dt.Rows[0]["Tariff"].ToString();
                PackGroupLabel.Text = dt.Rows[0]["PackageGroup"].ToString();
                PlatingLabel.Text = dt.Rows[0]["Finish"].ToString();
                GrossWghtLabel.Text = FormatScreenData(Num2Format, dt.Rows[0]["GrossWght"]);
                PriceUMLabel.Text = dt.Rows[0]["PriceUM"].ToString();
                CFVLabel.Text = dt.Rows[0]["CorpFixedVelocity"].ToString();
                PPILabel.Text = dt.Rows[0]["PPI"].ToString();
                ParentLabel.Text = dt.Rows[0]["ParentProdNo"].ToString();
                ParentItemHidden.Value = dt.Rows[0]["ParentProdNo"].ToString();
                StockLabel.Text = dt.Rows[0]["StockInd"].ToString();
                CostUMLabel.Text = dt.Rows[0]["CostUM"].ToString();
                CatVelLabel.Text = dt.Rows[0]["CatVelocityCd"].ToString();
                CreatedLabel.Text = FormatScreenData(DateFormat, dt.Rows[0]["Created"]);
                PkgVelLabel.Text = dt.Rows[0]["PackageVelocity"].ToString();
                SmoothOK.Value = dt.Rows[0]["SmoothOk"].ToString();
                if (dt.Rows[0]["SmoothOk"].ToString()=="1")
                {
                    SSHeadingTable.Rows[1].Cells[14].Text = "Avg.";
                }
                if (int.Parse(dt.Rows[0]["CPROk"].ToString()) == 1)
                {
                    RunCPRButt.Visible = true;
                    CPRFactor.Visible = true;
                }
                Session["StockData"] = ds.Tables[2];
                BindSSGrid(ds.Tables[2]);
                GetImages(dt.Rows[0]["ItemCategory"].ToString());
                BindPrintDialog();
            }
        }
        StockStatusScriptManager.SetFocus("ItemNoTextBox");
    }


    private void BindSSGrid(DataTable StockData)
    {
        SSGridView.DataSource = StockData;
        SSGridView.DataBind();
        Session["StockData"] = StockData;
    }

    public void GetImages(string Category)
    {
        string HeaderImageName = "";
        string BodyImageName = "";
        //show the item images
        string ColumnNames = "";
        ColumnNames = "Category ,";
        ColumnNames += "TechSpec,";
        ColumnNames += "Caution,";
        ColumnNames += "BodyFileName,";
        ColumnNames += "HeadFileName";
        DataSet dsImage = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
            new SqlParameter("@tableName", "ItemCategory WITH (NOLOCK)"),
            new SqlParameter("@columnNames", ColumnNames),
            new SqlParameter("@whereClause", "Category='" + Category + "'"));
        if (dsImage.Tables.Count == 1)
        {
            // We only got one table back
            DataTable dtImage = dsImage.Tables[0];
            if (dtImage.Rows.Count > 0)
            {
                CategorySpecLabel.Text = dtImage.Rows[0]["TechSpec"].ToString();
                if (CategorySpecLabel.Text.Length > 1)
                {
                    CategorySpecLabel.Text = "Specification: " + CategorySpecLabel.Text;
                    MessageUpdatePanel.Update();
                }
                BodyImageName = dtImage.Rows[0]["BodyFileName"].ToString();
                HeaderImageName = dtImage.Rows[0]["HeadFileName"].ToString();
                BodyImage.ImageUrl = ImageLibrary + BodyImageName;
                HeadImage.ImageUrl = ImageLibrary + HeaderImageName;
                HeadImageUpdatePanel.Update();
                BodyImageUpdatePanel.Update();
                HeadImageUpdatePanel.Visible = true;
                BodyImageUpdatePanel.Visible = true;
            }
            else
            {
                ShowPageMessage(Category + " Not Found for Image", 2);
            }
        }
        else
        {
            ShowPageMessage(Category + " Not Found for Image", 2);
        }
    }

    private DataSet FixSSData(DataTable cprData)
    {
        DataSet dsFixed = new System.Data.DataSet();
        //Decimal Sub3Mo = 0;
        //Decimal Tot3Mo = 0;
        //Decimal Sub12Mo = 0;
        //Decimal Tot12Mo = 0;
        //Decimal SubUse30D = 0;
        //Decimal TotUse30D = 0;
        //Decimal SubAvl = 0;
        //Decimal TotAvl = 0;
        //Decimal SubTrf = 0;
        //Decimal TotTrf = 0;
        //Decimal SubOO = 0;
        //Decimal TotOO = 0;
        //Decimal SubOW = 0;
        //Decimal TotOW = 0;
        //Decimal SubOONxtQty = 0;
        //Decimal TotOONxtQty = 0;
        //Decimal SubOWNxtQty = 0;
        //Decimal TotOWNxtQty = 0;
        //Decimal SubTotalQty = 0;
        //Decimal TotTotalQty = 0;
        //Decimal SubFcstNeed = 0;
        //Decimal TotFcstNeed = 0;
        //Decimal SubNetBuy = 0;
        //Decimal TotNetBuy = 0;
        //Decimal SubEstBuyCost = 0;
        //Decimal TotEstBuyCost = 0;
        //Decimal SubMosAvl = 0;
        //Decimal TotMosAvl = 0;
        //Decimal SubMosTrf = 0;
        //Decimal TotMosTrf = 0;
        //Decimal SubMosOO = 0;
        //Decimal TotMosOO = 0;
        //Decimal SubMosOW = 0;
        //Decimal TotMosOW = 0;
        //Decimal SubMosTotal = 0;
        //Decimal TotMosTotal = 0;
        //cprData.Rows[lastRow]["LocationCode"] = "Total";
        //ANetTotal = 0;
        //AEstCostTotal = 0;
        //System.Data.DataTable ATotalTable = new System.Data.DataTable("ATotals");
        //ATotalTable.Columns.Add("ATitle", typeof(String));
        //ATotalTable.Columns.Add("ANetTotal", typeof(Decimal));
        //ATotalTable.Columns.Add("AEstCostTotal", typeof(Decimal));
        //foreach (System.Data.DataRow row in cprData.Rows)
        //{
        //    if (row["LocationCode"].ToString().Trim().Length == 2 || row["LocationCode"].ToString().Substring(0, 5) == "Child")
        //    {
        //        Sub3Mo += decimal.Parse(row["Avg3M"].ToString());
        //        Tot3Mo += decimal.Parse(row["Avg3M"].ToString());
        //        Sub12Mo += decimal.Parse(row["Avg12M"].ToString());
        //        Tot12Mo += decimal.Parse(row["Avg12M"].ToString());
        //        SubUse30D += decimal.Parse(row["Use30D"].ToString());
        //        TotUse30D += decimal.Parse(row["Use30D"].ToString());
        //        SubAvl += decimal.Parse(row["Avl"].ToString());
        //        TotAvl += decimal.Parse(row["Avl"].ToString());
        //        SubTrf += decimal.Parse(row["Trf"].ToString());
        //        TotTrf += decimal.Parse(row["Trf"].ToString());
        //        SubOO += decimal.Parse(row["OO"].ToString());
        //        TotOO += decimal.Parse(row["OO"].ToString());
        //        SubOW += decimal.Parse(row["OW"].ToString());
        //        TotOW += decimal.Parse(row["OW"].ToString());
        //        SubOONxtQty += decimal.Parse(row["OONxtQty"].ToString());
        //        TotOONxtQty += decimal.Parse(row["OONxtQty"].ToString());
        //        SubOWNxtQty += decimal.Parse(row["OWNxtQty"].ToString());
        //        TotOWNxtQty += decimal.Parse(row["OWNxtQty"].ToString());
        //        SubTotalQty += decimal.Parse(row["TotalQty"].ToString());
        //        TotTotalQty += decimal.Parse(row["TotalQty"].ToString());
        //        SubFcstNeed += decimal.Parse(row["FcstNeed"].ToString());
        //        TotFcstNeed += decimal.Parse(row["FcstNeed"].ToString());
        //        SubNetBuy += decimal.Parse(row["NetBuy"].ToString());
        //        TotNetBuy += decimal.Parse(row["NetBuy"].ToString());
        //        SubEstBuyCost += decimal.Parse(row["EstBuyCost"].ToString());
        //        TotEstBuyCost += decimal.Parse(row["EstBuyCost"].ToString());
        //        SubMosAvl += decimal.Parse(row["MosAvl"].ToString());
        //        TotMosAvl += decimal.Parse(row["MosAvl"].ToString());
        //        SubMosTrf += decimal.Parse(row["MosTrf"].ToString());
        //        TotMosTrf += decimal.Parse(row["MosTrf"].ToString());
        //        SubMosOO += decimal.Parse(row["MosOO"].ToString());
        //        TotMosOO += decimal.Parse(row["MosOO"].ToString());
        //        SubMosOW += decimal.Parse(row["MosOW"].ToString());
        //        TotMosOW += decimal.Parse(row["MosOW"].ToString());
        //        SubMosTotal += decimal.Parse(row["MosTotal"].ToString());
        //        TotMosTotal += decimal.Parse(row["MosTotal"].ToString());
        //        if ((decimal)row["NetBuy"] > 0)
        //        {
        //            ANetTotal += (decimal)row["NetBuy"];
        //            AEstCostTotal += (decimal)row["EstBuyCost"];
        //        }
        //    }
        //    if (row["LocationCode"].ToString().Substring(0, 2) == "Lo")
        //    {
        //        row["Avg3M"] = Sub3Mo;
        //        row["Avg12M"] = Sub12Mo;
        //        row["Use30D"] = SubUse30D;
        //        row["Avl"] = SubAvl;
        //        row["Trf"] = SubTrf;
        //        row["OO"] = SubOO;
        //        row["OW"] = SubOW;
        //        row["OONxtQty"] = SubOONxtQty;
        //        row["OWNxtQty"] = SubOWNxtQty;
        //        row["TotalQty"] = SubTotalQty;
        //        row["FcstNeed"] = SubFcstNeed;
        //        row["NetBuy"] = SubNetBuy;
        //        row["EstBuyCost"] = SubEstBuyCost;
        //        if (SubUse30D == 0)
        //        {
        //            row["MosAvl"] = 0;
        //            row["MosTrf"] = 0;
        //            row["MosOO"] = 0;
        //            row["MosOW"] = 0;
        //            row["MosTotal"] = 0;
        //        }
        //        else
        //        {
        //            row["MosAvl"] = SubAvl / SubUse30D;
        //            row["MosTrf"] = SubTrf / SubUse30D;
        //            row["MosOO"] = SubOO / SubUse30D;
        //            row["MosOW"] = SubOW / SubUse30D;
        //            row["MosTotal"] = SubTotalQty / SubUse30D;
        //        }
        //    }
        //    if (row["LocationCode"].ToString().Substring(1, 1) == "-")
        //    {
        //        row["Avg3M"] = Sub3Mo;
        //        row["Avg12M"] = Sub12Mo;
        //        row["Use30D"] = SubUse30D;
        //        row["Avl"] = SubAvl;
        //        row["Trf"] = SubTrf;
        //        row["OO"] = SubOO;
        //        row["OW"] = SubOW;
        //        row["OONxtQty"] = SubOONxtQty;
        //        row["OWNxtQty"] = SubOWNxtQty;
        //        row["TotalQty"] = SubTotalQty;
        //        row["FcstNeed"] = SubFcstNeed;
        //        row["NetBuy"] = SubNetBuy;
        //        row["EstBuyCost"] = SubEstBuyCost;
        //        if (SubUse30D == 0)
        //        {
        //            row["MosAvl"] = 0;
        //            row["MosTrf"] = 0;
        //            row["MosOO"] = 0;
        //            row["MosOW"] = 0;
        //            row["MosTotal"] = 0;
        //        }
        //        else
        //        {
        //            row["MosAvl"] = SubAvl / SubUse30D;
        //            row["MosTrf"] = SubTrf / SubUse30D;
        //            row["MosOO"] = SubOO / SubUse30D;
        //            row["MosOW"] = SubOW / SubUse30D;
        //            row["MosTotal"] = SubTotalQty / SubUse30D;
        //        }
        //        Sub3Mo = 0;
        //        Sub12Mo = 0;
        //        SubUse30D = 0;
        //        SubAvl = 0;
        //        SubTrf = 0;
        //        SubOO = 0;
        //        SubOW = 0;
        //        SubOONxtQty = 0;
        //        SubOWNxtQty = 0;
        //        SubTotalQty = 0;
        //        SubFcstNeed = 0;
        //        SubNetBuy = 0;
        //        SubEstBuyCost = 0;
        //        SubMosAvl = 0;
        //        SubMosTrf = 0;
        //        SubMosOO = 0;
        //        SubMosOW = 0;
        //        SubMosTotal = 0;

        //    }
        //}
        //cprData.Rows[lastRow]["Avg3M"] = Tot3Mo;
        //cprData.Rows[lastRow]["Avg12M"] = Tot12Mo;
        //cprData.Rows[lastRow]["Use30D"] = TotUse30D;
        //cprData.Rows[lastRow]["Avl"] = TotAvl;
        //cprData.Rows[lastRow]["Trf"] = TotTrf;
        //cprData.Rows[lastRow]["OO"] = TotOO;
        //cprData.Rows[lastRow]["OW"] = TotOW;
        //cprData.Rows[lastRow]["OONxtQty"] = TotOONxtQty;
        //cprData.Rows[lastRow]["OWNxtQty"] = TotOWNxtQty;
        //cprData.Rows[lastRow]["TotalQty"] = TotTotalQty;
        //cprData.Rows[lastRow]["FcstNeed"] = TotFcstNeed;
        //cprData.Rows[lastRow]["NetBuy"] = TotNetBuy;
        //cprData.Rows[lastRow]["EstBuyCost"] = TotEstBuyCost;
        //if (TotUse30D == 0)
        //{
        //    cprData.Rows[lastRow]["MosAvl"] = 0;
        //    cprData.Rows[lastRow]["MosTrf"] = 0;
        //    cprData.Rows[lastRow]["MosOO"] = 0;
        //    cprData.Rows[lastRow]["MosOW"] = 0;
        //    cprData.Rows[lastRow]["MosTotal"] = 0;
        //}
        //else
        //{
        //    cprData.Rows[lastRow]["MosAvl"] = TotAvl / TotUse30D;
        //    cprData.Rows[lastRow]["MosTrf"] = TotTrf / TotUse30D;
        //    cprData.Rows[lastRow]["MosOO"] = TotOO / TotUse30D;
        //    cprData.Rows[lastRow]["MosOW"] = TotOW / TotUse30D;
        //    cprData.Rows[lastRow]["MosTotal"] = TotTotalQty / TotUse30D;
        //}
        //DataRow ATotalRow = ATotalTable.NewRow();
        //ATotalRow["ATitle"] = "Pos:";
        //ATotalRow["ANetTotal"] = ANetTotal;
        //ATotalRow["AEstCostTotal"] = AEstCostTotal;
        //ATotalTable.Rows.Add(ATotalRow);
        //dsFixed.Tables.Add(ATotalTable);
        return dsFixed;
    }

    public void Report_CheckedChanged(Object sender, EventArgs e)
    {
        //SetGridColumns();
        //if (LongReport.Checked)
        //{
        //    string CurItem = ItemGrid.Items[0].Cells[0].Text.Split(new Char[] { ' ' })[1].ToString();
        //    System.Data.DataTable cprData = new System.Data.DataTable();
        //    cprData = cpr.GetGPRGridData(CurItem, (decimal)Session["SSFactor"]).Tables[0];
        //    if (cprData.Rows.Count > 0)
        //    {
        //        int lastRow = cprData.Rows.Count - 1;
        //        cprData.Rows[lastRow]["LocationCode"] = "Total";
        //        SSGridView.DataSource = cprData;
        //        SSGridView.DataBind();
        //    }
        //}

    }

    public void LocSortLinkButton_Click(Object sender, EventArgs e)
    {
        if (LocSortHidden.Value == "LocID")
        {
            LocSortHidden.Value = "SortKey";
        }
        else
        {
            LocSortHidden.Value = "LocID";
        }
        try
        {
            //LocSortLinkButton.Text = LocSortHidden.Value;
            DataView SSview = ((DataTable)Session["StockData"]).DefaultView;
            SSview.Sort = LocSortHidden.Value;
            BindSSGrid(SSview.ToTable());
            DetailUpdatePanel.Update();
        }
        catch
        {
        }
    }
 
    protected void SSLineFormat(object source, GridViewRowEventArgs e)
    {
        int lastCell = e.Row.Cells.Count - 1;
        TableCell tempCell = new TableCell();
        //int newWidth = 0;
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            GridViewRow row = e.Row;
            // color row
            for (int col = 0; col < lastCell; col++)
            {
                if (e.Row.Cells[lastCell].Text.Trim() == "G")
                {
                    e.Row.Cells[col].CssClass = "hubGridLine";
                    switch (col)
                    {
                        case 4:
                        case 9:
                        case 14:
                        case 15:
                        case 20:
                            e.Row.Cells[col].CssClass = "hubGroupBorder";
                            break;
                    }
                }
                // set links for columns that can show documents
                string Loc = row.Cells[0].Text;
                // sales
                SetShowDocsLink(row.Cells[6], row.Cells[0].Text, "SO");
                // tran out
                SetShowDocsLink(row.Cells[7], row.Cells[0].Text, "TO");
                // back order
                SetShowDocsLink(row.Cells[8], row.Cells[0].Text, "BO");
                //// PO
                SetShowDocsLink(row.Cells[10], row.Cells[0].Text, "PO");
                //// OTW
                SetShowDocsLink(row.Cells[11], row.Cells[0].Text, "OW");
                //// WO
                SetShowDocsLink(row.Cells[12], row.Cells[0].Text, "WO");
                //// Returns
                SetShowDocsLink(row.Cells[13], row.Cells[0].Text, "RO");
                //// tran in
                SetShowDocsLink(row.Cells[14], row.Cells[0].Text, "TI");
            }
        }
    }

    protected void SSTotals(object source, EventArgs e)
    {
        DataTable StockData = new DataTable();
        if ((Session["StockData"] != null) && (SSGridView.FooterRow != null))
        {
            StockData = (DataTable)Session["StockData"];
            // Get the footer row.
            GridViewRow footerRow = SSGridView.FooterRow;
            footerRow.CssClass = "bold totals";
            footerRow.Cells[0].Text = "Totals";
            footerRow.Cells[1].Text = FormatScreenData(Num1Format, StockData.Compute("Sum(Use30D)", "1 = 1"));
            footerRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;
            footerRow.Cells[3].Text = FormatScreenData(Num1Format, StockData.Compute("Sum(ROP)", "1 = 1"));
            footerRow.Cells[3].HorizontalAlign = HorizontalAlign.Right;
            //footerRow.Cells[4].Text = FormatScreenData(Num0Format, StockData.Compute("Sum(ROPDays)", "1 = 1"));
            //footerRow.Cells[4].HorizontalAlign = HorizontalAlign.Right;
            footerRow.Cells[5].Text = FormatScreenData(Num0Format, StockData.Compute("Sum(Avail)", "1 = 1"));
            footerRow.Cells[5].HorizontalAlign = HorizontalAlign.Right;
            footerRow.Cells[6].Text = FormatScreenData(Num0Format, StockData.Compute("Sum(Sales)", "1 = 1"));
            footerRow.Cells[6].HorizontalAlign = HorizontalAlign.Right;
            footerRow.Cells[7].Text = FormatScreenData(Num0Format, StockData.Compute("Sum(TransOut)", "1 = 1"));
            footerRow.Cells[7].HorizontalAlign = HorizontalAlign.Right;
            footerRow.Cells[8].Text = FormatScreenData(Num0Format, StockData.Compute("Sum(Back)", "1 = 1"));
            footerRow.Cells[8].HorizontalAlign = HorizontalAlign.Right;
            footerRow.Cells[9].Text = FormatScreenData(Num0Format, StockData.Compute("Sum(QOH)", "1 = 1"));
            footerRow.Cells[9].HorizontalAlign = HorizontalAlign.Right;
            footerRow.Cells[10].Text = FormatScreenData(Num0Format, StockData.Compute("Sum(PO)", "1 = 1"));
            footerRow.Cells[10].HorizontalAlign = HorizontalAlign.Right;
            footerRow.Cells[11].Text = FormatScreenData(Num0Format, StockData.Compute("Sum(OTW)", "1 = 1"));
            footerRow.Cells[11].HorizontalAlign = HorizontalAlign.Right;
            footerRow.Cells[12].Text = FormatScreenData(Num0Format, StockData.Compute("Sum(WO)", "1 = 1"));
            footerRow.Cells[12].HorizontalAlign = HorizontalAlign.Right;
            footerRow.Cells[13].Text = FormatScreenData(Num0Format, StockData.Compute("Sum(RO)", "1 = 1"));
            footerRow.Cells[13].HorizontalAlign = HorizontalAlign.Right;
            footerRow.Cells[14].Text = FormatScreenData(Num0Format, StockData.Compute("Sum(TransIn)", "1 = 1"));
            footerRow.Cells[14].HorizontalAlign = HorizontalAlign.Right;
            footerRow.Cells[footerRow.Cells.Count - 1].CssClass = "invsible";
        }
    }

    protected void SetShowDocsLink(TableCell QtyCell, string loc, string docTypeToShow)
    {
        Label labelField = (Label)QtyCell.Controls[1];
        LinkButton linkField=(LinkButton)QtyCell.Controls[3];
        if (labelField.Text.Trim().Length > 0)
        {
            int DocQty = int.Parse(Server.HtmlDecode(labelField.Text.Replace(",", "").Trim()));
            if (DocQty != 0)
            {
                labelField.Visible = false;
                linkField.OnClientClick = "ShowDocs('" +
                    Server.HtmlDecode(loc) + "', '" + docTypeToShow + "');";
            }
            else
            {
                linkField.Visible = false;
            }
        }
        else
        {
            linkField.Visible = false;
        }
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        //ItemGrid.CurrentPageIndex = Pager1.GotoPageNumber;
        //dt = (System.Data.DataTable)Session["MasterTable"];
        //ItemGrid.DataSource = dt.DefaultView.ToTable();
        //BindPage();
    }

    protected void ClearPageMessages()
    {
        MessageLabel.Text = "";
        MessageUpdatePanel.Update();
    }
    protected void ShowPageMessage(string PageMessage, int MessageType)
    {
        switch (MessageType)
        {
            case 1:
                MessageLabel.CssClass = "warn";
                break;
            case 2:
                MessageLabel.CssClass = "error";
                break;
            default:
                MessageLabel.CssClass = "success";
                break;
        }
        //MessageLabel.CssClass = "error";
        MessageLabel.Text = PageMessage;
        MessageUpdatePanel.Update();
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

    #region Clear Data
    protected void ClearItemData(bool NewItem)
    {
        // if NewItem is true, we are clearing after an item is entered
        SSGridView.DataBind();
        DetailUpdatePanel.Update();
        ItemDescLabel.Text = "";
        Wgt100Label.Text = "";
        QtyUOMLabel.Text = "";
        StdCostLabel.Text = "";
        UPCLabel.Text = "";
        WebLabel.Text = "";
        CategoryLabel.Text = "";
        NetWghtLabel.Text = "";
        SuperEqLabel.Text = "";
        ListLabel.Text = "";
        HarmCodeLabel.Text = "";
        PackGroupLabel.Text = "";
        PlatingLabel.Text = "";
        GrossWghtLabel.Text = "";
        PriceUMLabel.Text = "";
        CFVLabel.Text = "";
        PPILabel.Text = "";
        ParentLabel.Text = "";
        StockLabel.Text = "";
        CostUMLabel.Text = "";
        CatVelLabel.Text = "";
        PkgVelLabel.Text = "";
        CreatedLabel.Text = "";
        HeaderUpdatePanel.Update();
        CategorySpecLabel.Text = "";
        MessageUpdatePanel.Update();
        HeadImageUpdatePanel.Visible = false;
        BodyImageUpdatePanel.Visible = false;
    }
    #endregion

    public void BindPrintDialog()
    {
        PrintUpdatePanel.Visible = true;
        Print.PageTitle = "Stock Status for " + ItemNoTextBox.Text;
        string SSURL = "StockStatusExport.aspx?ItemNo=" + ItemNoTextBox.Text + "&UserName=" + Session["UserName"].ToString();
        Print.PageTitle = "Stock Status " + ItemNoTextBox.Text;
        // we build a url according to what item they have entered. 
        Print.PageUrl = SSURL;
        PrintUpdatePanel.Update();
        //ShowPageMessage(RecallURL, 0);
    }
}