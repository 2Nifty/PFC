using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;
using PFC.Intranet.BusinessLogicLayer;

public partial class BillOfMaterialsPreview : System.Web.UI.Page
{
    #region Variable Declaration
    MaintenanceUtility MaintUtil = new MaintenanceUtility();

    DataSet dsBOM = new DataSet();
    DataTable dtBOM = new DataTable();
    DataTable dtBOMItem = new DataTable();
    DataTable dtBOMChild = new DataTable();
    DataTable dtBOMUM = new DataTable();

    SqlConnection cnERP = new SqlConnection(ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);

    string strSQL, sortExpression;

    FileInfo fnExcel;
    StreamWriter reportWriter;
    string xlsFile, ExportFile, headerContent, excelContent, footerContent;

    private string Num0Format = "{0:####,###,##0} ";
    private string Num2Format = "{0:####,###,##0.00} ";
    private string DateFormat = "{0:MM/dd/yy} ";
    #endregion Variable Declaration


    string PassedItemNo;
    string PassedBillType;

    protected void Page_Load(object sender, EventArgs e)
    {

        #region URL Parameters
        PassedItemNo = (Request.QueryString["ItemNo"] != null) ? Request.QueryString["ItemNo"].ToString().Trim() : "";
        PassedBillType = (Request.QueryString["BillType"] != null) ? Request.QueryString["BillType"].ToString().Trim() : "";
        sortExpression = (Request.QueryString["SortExp"] != null) ? Request.QueryString["SortExp"].ToString().Trim() : "";
        #endregion
        
        
        //PassedItemNo = "00200-2400-401";
        //PassedBillType = "S - Standard";
        //sortExpression = "BOMSeqNo, BOMItem ASC";

        ValidateParent();

        lblSearchItem.Text = PassedItemNo.ToString().Trim();
        lblBOMBillType.Text = PassedBillType.ToString().Trim();


    }



    private void ValidateParent()
    {
        #region Validate the parent item
        dtBOMItem = ValidItem(PassedItemNo);
        if (dtBOMItem.Rows.Count > 0)
        {   //Valid Item Found
            #region Display ItemInfo
            lblItemDesc.Text = dtBOMItem.Rows[0]["ItemDesc"].ToString();
            lblCatDesc.Text = dtBOMItem.Rows[0]["CatDesc"].ToString();
            lblPltTyp.Text = dtBOMItem.Rows[0]["PltTyp"].ToString();
            lblParentItem.Text = dtBOMItem.Rows[0]["ParentItem"].ToString();

            lbl100Wght.Text = FormatScreenData(Num2Format, dtBOMItem.Rows[0]["100Wght"]);
            lblNetWght.Text = FormatScreenData(Num2Format, dtBOMItem.Rows[0]["NetWght"]);
            lblGrossWght.Text = FormatScreenData(Num2Format, dtBOMItem.Rows[0]["GrossWght"]);
            lblStockInd.Text = dtBOMItem.Rows[0]["StockInd"].ToString();

            lblSellStk.Text = dtBOMItem.Rows[0]["SellStk"].ToString();
            lblSupEqv.Text = dtBOMItem.Rows[0]["SupEqv"].ToString();
            lblPriceUM.Text = dtBOMItem.Rows[0]["PriceUM"].ToString();
            lblCostUM.Text = dtBOMItem.Rows[0]["CostUM"].ToString();

            lblStdCost.Text = dtBOMItem.Rows[0]["StdCost"].ToString();
            lblListPrice.Text = FormatScreenData(Num2Format, dtBOMItem.Rows[0]["ListPrice"]);
            lblCFV.Text = dtBOMItem.Rows[0]["CFV"].ToString();
            lblCVC.Text = dtBOMItem.Rows[0]["CVC"].ToString();

            lblUPCCd.Text = dtBOMItem.Rows[0]["UPCCd"].ToString();
            lblTarrif.Text = dtBOMItem.Rows[0]["Tariff"].ToString();
            lblPPI.Text = dtBOMItem.Rows[0]["PPI"].ToString();
            lblCreateDt.Text = FormatScreenData(DateFormat, dtBOMItem.Rows[0]["CreateDt"]);

            lblWebEnabled.Text = dtBOMItem.Rows[0]["WebEnabled"].ToString();
            lblPkgGrp.Text = dtBOMItem.Rows[0]["PkgGrp"].ToString();
            lblLowProfile.Text = FormatScreenData(Num0Format, dtBOMItem.Rows[0]["LowProfile"]);
            lblPVC.Text = dtBOMItem.Rows[0]["PVC"].ToString();

            #endregion Display ItemInfo

            Session["dtBOMItem"] = dtBOMItem;
            dtBOM = GetBOM(PassedItemNo);
            CheckBOM();
        }
        else
        {   //No Valid Item found


        }
        #endregion Validate the parent item
    }



    protected DataTable ValidItem(string ItemNo)
    {
        //Check for valid item
        dsBOM = SqlHelper.ExecuteDataset(cnERP, "pBOMGetItem", new SqlParameter("@ItemNo", ItemNo),
                                                               new SqlParameter("@RecCtl", "ITEM"));

        return dsBOM.Tables[0];
    }

    protected DataTable GetBOM(string ItemNo)
    {
        //Read the BOM/BOMDetail
        dsBOM = SqlHelper.ExecuteDataset(cnERP, "pBOMGetItem", new SqlParameter("@ItemNo", ItemNo),
                                                               new SqlParameter("@RecCtl", "BOM"));

        return dsBOM.Tables[0];
    }



    private void CheckBOM()
    {
        if (dtBOM.Rows.Count > 0)
        {   //Valid BOM found
            dtBOM.DefaultView.Sort = sortExpression;
            dgBOM.DataSource = dtBOM.DefaultView.ToTable();
            dgBOM.DataBind();
            divdatagrid.Visible = true;
        }
        else
        {   //No Valid BOM found

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
