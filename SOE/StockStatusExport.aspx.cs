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

public partial class StockStatusExport : System.Web.UI.Page 
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
    string ImageLibrary = ConfigurationManager.AppSettings["SOESiteURL"].ToString() + ConfigurationManager.AppSettings["ProductImagesPath"].ToString();
    private string userName = "";

    protected void Page_Init(object sender, EventArgs e)
    {

    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            NameValueCollection coll = Request.QueryString;
            userName = (Session["UserName"] != null ? Session["UserName"].ToString() : Request.QueryString["UserName"].ToString());
            // Load NameValueCollection object.
            if (coll["ItemNo"] != null && coll["ItemNo"].ToString().Length > 0)
            {
                ItemNoLabel.Text = coll["ItemNo"].ToString();
                GetItem(coll["ItemNo"].ToString());
            }
            else
            {
                ItemNoLabel.Text = "No Item Passed";
            }
        }
        else
        {
        }

    }


    protected void GetItem(string ItemNo)
    {
        // get the package and plating data.
        ds = SqlHelper.ExecuteDataset(connectionString, "pSSGetItem",
            new SqlParameter("@SearchItemNo", ItemNo),
            new SqlParameter("@UserName", userName));
        if (ds.Tables.Count >= 1)
        {
            if (ds.Tables.Count == 1)
            {
                // We only go one table back, something is wrong
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    ItemNoLabel.Text = "Item not found.";
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
                StockLabel.Text = dt.Rows[0]["StockInd"].ToString();
                CostUMLabel.Text = dt.Rows[0]["CostUM"].ToString();
                PkgVelLabel.Text = dt.Rows[0]["PackageVelocity"].ToString();
                CatVelLabel.Text = "";
                CreatedLabel.Text = FormatScreenData(DateFormat, dt.Rows[0]["Created"]);
                BindSSGrid(ds.Tables[2]);
                GetImages(dt.Rows[0]["ItemCategory"].ToString());
            }
        }
    }


    private void BindSSGrid(DataTable StockData)
    {
        SSGridView.DataSource = StockData;
        SSGridView.DataBind();
        // set the totals
        UsageTotLabel.Text = FormatScreenData(Num1Format, StockData.Compute("Sum(Use30D)", "1 = 1"));
        ROPTotLabel.Text = FormatScreenData(Num1Format, StockData.Compute("Sum(ROP)", "1 = 1"));
        AvailTotLabel.Text = FormatScreenData(Num0Format, StockData.Compute("Sum(Avail)", "1 = 1"));
        SalesTotLabel.Text = FormatScreenData(Num0Format, StockData.Compute("Sum(Sales)", "1 = 1"));
        TransOutTotLabel.Text = FormatScreenData(Num0Format, StockData.Compute("Sum(TransOut)", "1 = 1"));
        BackTotLabel.Text = FormatScreenData(Num0Format, StockData.Compute("Sum(Back)", "1 = 1"));
        QOHTotLabel.Text = FormatScreenData(Num0Format, StockData.Compute("Sum(QOH)", "1 = 1"));
        PurchTotLabel.Text = FormatScreenData(Num0Format, StockData.Compute("Sum(PO)", "1 = 1"));
        OTWTotLabel.Text = FormatScreenData(Num0Format, StockData.Compute("Sum(OTW)", "1 = 1"));
        ProdTotLabel.Text = FormatScreenData(Num0Format, StockData.Compute("Sum(WO)", "1 = 1"));
        ReturnTotLabel.Text = FormatScreenData(Num0Format, StockData.Compute("Sum(RO)", "1 = 1"));
        TransInTotLabel.Text = FormatScreenData(Num0Format, StockData.Compute("Sum(TransIn)", "1 = 1"));
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
                }
                BodyImageName = dtImage.Rows[0]["BodyFileName"].ToString();
                HeaderImageName = dtImage.Rows[0]["HeadFileName"].ToString();
                BodyImage.ImageUrl = ImageLibrary + BodyImageName;
                HeadImage.ImageUrl = ImageLibrary + HeaderImageName;
            }
            else
            {
                //ShowPageMessage(Category + " Not Found for Image", 2);
            }
        }
        else
        {
            //ShowPageMessage(Category + " Not Found for Image", 2);
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
                        case 3:
                        case 8:
                        case 13:
                        case 14:
                        case 19:
                            e.Row.Cells[col].CssClass = "hubGroupBorder";
                            break;
                    }
                }
            }
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