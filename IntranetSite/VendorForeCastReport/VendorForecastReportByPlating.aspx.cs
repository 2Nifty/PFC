using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Threading;
using System.IO;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet;
using PFC.Intranet.Utility;
using System.Reflection;

public partial class CustomerSalesAnalysis : System.Web.UI.Page
{
    #region Variable Declaration
    
    VendorForecast vendorforeCast = new VendorForecast();
    Utility utility = new Utility();
    DataTable dtVendorForeCast = new DataTable();
    DataTable dtVFCSort = new DataTable();
    DataSet dsVendorForeCast = new DataSet();
    int pagesize = 2;

    //Computing the sub total & grant total
    string foreCastUSG = string.Empty;
    string usgUOM = string.Empty;
    string usgLBS = string.Empty;
    string usgKGS = string.Empty;
    string footerContent = string.Empty;

    // Global value for category
    Label lblCategory;

    // Total number of pages
    int totrecords = 0;
    int totpages = 1;
    int remainder = 0;
    #endregion
    
    #region Control Events
    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(CustomerSalesAnalysis));
        
        if (!Page.IsPostBack)
        {
            string name = DateTime.Now.ToString().Replace("/", "");
            name = name.Replace(" ", "");
            name = name.Replace(":", "");
            hidExcelFileName.Value = "VendorForeCast" + name + ".xls";

            Session["VendorForeCastData"] = null;
            BindDataToGrid();
        }
    }

    protected void dgCategory_ItemDataBound1(object sender, DataGridItemEventArgs e)
    {   
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            lblCategory = e.Item.FindControl("lblCategory") as Label;
            DataGrid dgCategoryDetail = e.Item.FindControl("dgCategoryDetail") as DataGrid;
            
            dtVendorForeCast.DefaultView.RowFilter = "Category ='" + lblCategory.Text + "'";

            //Computing the category Grant total.
            DataTable filteredItemPrixedTable = dtVendorForeCast.DefaultView.ToTable();

            foreCastUSG = String.Format("{0:#,##0}", Convert.ToDecimal(filteredItemPrixedTable.Compute("Sum(ForeCastUSG)", "")));
            usgUOM = String.Format("{0:#,##0}", Convert.ToDecimal(filteredItemPrixedTable.Compute("Sum(USGUOM)", "")));
            usgLBS = String.Format("{0:#,##0}", Convert.ToDecimal(filteredItemPrixedTable.Compute("Sum(USGLBS)", "")));
            usgKGS = String.Format("{0:#,##0}", Convert.ToDecimal(filteredItemPrixedTable.Compute("Sum(USGKGS)", "")));
            
            dgCategoryDetail.Columns[4].FooterText = foreCastUSG;
            dgCategoryDetail.Columns[5].FooterText = usgUOM;
            dgCategoryDetail.Columns[6].FooterText = usgLBS;
            dgCategoryDetail.Columns[7].FooterText = usgKGS;

            dgCategoryDetail.DataSource = filteredItemPrixedTable;
            dgCategoryDetail.DataBind();
            
        }
    }

    protected void dgCategory_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        dgCategory.CurrentPageIndex = e.NewPageIndex;
        BindDataToGrid();
    }

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        string excelContent = string.Empty;
        string category = string.Empty;

        decimal grantForeCastUSG = 0;
        decimal grantUSGUOM = 0;
        decimal grantUSGLBS = 0;
        decimal grantUSGKGS = 0;

        decimal subForeCastUSG = 0;
        decimal subUSGUOM = 0;
        decimal subUSGLBS = 0;
        decimal subUSGKGS = 0;

        int i = 0;
        DataSet dsVFCReport = vendorforeCast.GetVendorForeCastData(Session["VendorMultiplier"].ToString(), Session["VendorCategory"].ToString(), Session["VendorVariance"].ToString(), Session["VendorPlatingType"].ToString(), Session["VendorSort"].ToString());
        DataTable dtVFCReport = dsVFCReport.Tables[0];
        excelContent = "<table border='1px'>";
        excelContent += "<tr><th colspan='8' style='color:blue'>Vendor Forecast Report</th></tr>";
        excelContent += "<tr><th colspan='7' align='right'>Run Date:</th><th>" + DateTime.Now.ToShortDateString() + "</th></tr>";
        foreach (DataRow vendorFCReader in dtVFCReport.Rows)
        {
            i += 1;
            if (category != vendorFCReader["Category"].ToString())
            {
                if (subForeCastUSG != 0)
                {
                    //display the grant total information for category
                    excelContent += GetTotalDisplay(subForeCastUSG, subUSGUOM, subUSGLBS, subUSGKGS, "Sub Total");

                    //Creating blank line
                    excelContent += "<tr><td colspan='8'>&nbsp;</td></tr>";

                    subForeCastUSG = 0;
                    subUSGUOM = 0;
                    subUSGLBS = 0;
                    subUSGKGS = 0;
                }
                excelContent += "<tr>";
                excelContent += "<th align='left'>Category :</th><th colspan=7 align='left'>" + vendorFCReader["Category"].ToString() + "  " + vendorFCReader["CategoryDesc"].ToString() + " </th>";
                excelContent += "</tr>";
                
                excelContent +="<tr><td colspan='8'><table border='1'><tr>";
                excelContent +="<th>Item #</th>";
                excelContent +="<th>Size</th>";
                excelContent +="<th>Category Description</th>";
                excelContent +="<th>Plating </th>";
                excelContent +="<th colspan='4'>";
                excelContent +="<table border='1'><tr>";
                excelContent +="<th colspan='4'>Forecasted Usage</th></tr>";
                excelContent +="<tr><th>Quantity</th>";
                excelContent +="<th>Units</th>";
                excelContent +="<th>Pounds</th>";
                excelContent +="<th>Kgs.</th>";
                excelContent +="</tr></table>";
                excelContent += "</th></tr></table></td></tr>";




                category = vendorFCReader["Category"].ToString();
            }

            excelContent += "<tr><td colspan='8'><table border='1'>";
            excelContent += "<tr>";
            excelContent += "<td>" + vendorFCReader["Itemno"].ToString() + "</td>";
            excelContent += "<td>&nbsp;" + vendorFCReader["Size"].ToString() + "</td>";
            excelContent += "<td>" + vendorFCReader["CategoryDesc"].ToString() + "</td>";
            excelContent += "<td>" + vendorFCReader["Plate"].ToString() + "</td>";
            excelContent += "<td>" + String.Format("{0:#,##0}", Convert.ToDecimal(vendorFCReader["ForecastUsg"])) + "</td>";
            excelContent += "<td>" + String.Format("{0:#,##0}", Convert.ToDecimal(vendorFCReader["USGUOM"])) + "</td>";
            excelContent += "<td>" + String.Format("{0:#,##0}", Convert.ToDecimal(vendorFCReader["USGLBS"])) + "</td>";
            excelContent += "<td>" + String.Format("{0:#,##0}", Convert.ToDecimal(vendorFCReader["USGKGS"])) + "</td>";
            excelContent += "</tr>";
            excelContent += "</table></td></tr>";

            //Computing grant total
            grantForeCastUSG += Convert.ToDecimal(vendorFCReader["ForecastUsg"]);
            grantUSGUOM += Convert.ToDecimal(vendorFCReader["USGUOM"]);
            grantUSGLBS += Convert.ToDecimal(vendorFCReader["USGLBS"]);
            grantUSGKGS += Convert.ToDecimal(vendorFCReader["USGKGS"]);

            //Computing Item prefix sub total
            subForeCastUSG += Convert.ToDecimal(vendorFCReader["ForecastUsg"]);
            subUSGUOM += Convert.ToDecimal(vendorFCReader["USGUOM"]);
            subUSGLBS += Convert.ToDecimal(vendorFCReader["USGLBS"]);
            subUSGKGS += Convert.ToDecimal(vendorFCReader["USGKGS"]);
        }

        //display sub total for the Category
        excelContent += GetTotalDisplay(subForeCastUSG, subUSGUOM, subUSGLBS, subUSGKGS, "Sub Total");

        //display the category grant total information for category
        excelContent += GetTotalDisplay(grantForeCastUSG, grantUSGUOM, grantUSGLBS, grantUSGKGS, "Grant Total");

        excelContent += "</table>";
        try
        {
            FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + hidExcelFileName.Value));
            StreamWriter excelWriter;
            excelWriter = fnExcel.CreateText();
            excelWriter.WriteLine(excelContent);
            excelWriter.Flush();
            excelWriter.Close();
        }
        catch (Exception ex)
        {
            throw ex;
        }

        string script = "window.open('" + GetFileURL() + "','BranchItemSalesAnalysis' ,'height=0,width=0,top=500,left=500','');";

        ScriptManager.RegisterClientScriptBlock(this.ibtnExcelExport, ibtnExcelExport.GetType(), "msg", script, true);
    }

    protected void dgCategoryDetail_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Header)
        {
            string headerContent = string.Empty;

            headerContent = "<table height='100%' Cellpadding='0' cellspacing='0' width='100%'>";
            headerContent += "<tr><td colspan='4' class='GridHeaderTable' align='center'style='border-right:0px' > Forecasted Usage</td></tr>";
            headerContent += "<tr><td class='GridHeaderTable' align='center' style='width:82px'>Quantity</td>";
            headerContent += "<td class='GridHeaderTable' align='center' style='width:70x'>Units</td>";
            headerContent += "<td class='GridHeaderTable' align='center' style='width:83px'>Pounds</td>";
            headerContent += "<td class='GridHeaderTable' align='center' style='width:82px;border-right:0px'>Kgs.</td></tr>";
            headerContent += "</table>";

            e.Item.Cells[5].Visible = false;
            e.Item.Cells[6].Visible = false;
            e.Item.Cells[7].Visible = false;

            e.Item.Cells[4].ColumnSpan = 4;
            e.Item.Cells[4].Text = headerContent;

        }
    }
    #endregion

    #region Developer Code
    public void BindDataToGrid()
    {
        try
        {
            dsVendorForeCast = vendorforeCast.GetVendorForeCastData(Session["VendorMultiplier"].ToString(), Session["VendorCategory"].ToString(), Session["VendorVariance"].ToString(), Session["VendorPlatingType"].ToString(), Session["VendorSort"].ToString());
            dtVendorForeCast = dsVendorForeCast.Tables[0];
            dtVFCSort = dsVendorForeCast.Tables[1];
            if (dtVFCSort.Rows.Count == 0)
            {
                lblStatus.Visible = true;
                Pager1.Visible = false;
            }
            // Grand Total
            foreCastUSG = String.Format("{0:#,##0}", Convert.ToDecimal(dtVFCSort.Compute("Sum(ForeCastUSG)", "")));
            usgUOM = String.Format("{0:#,##0}", Convert.ToDecimal(dtVFCSort.Compute("Sum(USGUOM)", "")));
            usgLBS = String.Format("{0:#,##0}", Convert.ToDecimal(dtVFCSort.Compute("Sum(USGLBS)", "")));
            usgKGS = String.Format("{0:#,##0}", Convert.ToDecimal(dtVFCSort.Compute("Sum(USGKGS)", "")));

            footerContent = "";
            footerContent += "<table border='0' width='100%' cellpadding='0'cellspacing='0'>";
            footerContent += "<tr><td style='width:470px' class='GridHead' align='right'>Grand Total</td>";
            footerContent += "<td style='width:83px' class='GridHead' align='right'>" + foreCastUSG + "</td>";
            footerContent += "<td style='width:83px' class='GridHead' align='right'>" + usgUOM + "</td>";
            footerContent += "<td style='width:85px' class='GridHead' align='right'>" + usgLBS + "</td>";
            footerContent += "<td  class='GridHead' align='right'>" + usgKGS + "</td></tr></table>";

            dgCategory.Columns[0].FooterText = footerContent;
            dgCategory.DataSource = dtVFCSort;
            Pager1.InitPager(dgCategory, 1);

            if (dgCategory.CurrentPageIndex != Pager1.GetTotalNoOfPages - 1)
                dgCategory.ShowFooter = false;
            else
                dgCategory.ShowFooter = true;

            dgCategory.DataBind();

            GetTotalPages();
        }
        catch (Exception ex) { //Response.Write(ex.Message.ToString()); 
        }
    }

    /// <summary>
    /// Function used to change the pager index when user change the grid pager controls
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    /// <remarks></remarks>
    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgCategory.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataToGrid();
    }

    private string GetTotalDisplay(decimal foreCastUSG, decimal usgUOM, decimal usgLBS, decimal usgKGS, string caption)
    {
        string displayTotal = string.Empty;

        displayTotal += "<tr>";
        displayTotal += "<td colspan='4' align='right'><b>" + caption + "</b></td>";
        displayTotal += "<td colspan='4'><table border='1'><tr>";
        displayTotal += "<td align='right'><b>" + String.Format("{0:#,##0}", foreCastUSG) + "</b></td>";
        displayTotal += "<td align='right'><b>" + String.Format("{0:#,##0}", usgUOM) + "</b></td>";
        displayTotal += "<td align='right'><b>" + String.Format("{0:#,##0}", usgLBS) + "</b></td>";
        displayTotal += "<td align='right'><b>" + String.Format("{0:#,##0}", usgKGS) + "</b></td>";
        displayTotal += "</tr></table></td>";
        displayTotal += "</tr>";

        return displayTotal;
    }

    /// <summary>
    /// Method used to get the excel file url from view state
    /// </summary>
    /// <returns></returns>
    protected string GetFileURL()
    {
        string url = "../Common/ExcelUploads/" + hidExcelFileName.Value;
        return url;
    }

    private void GetTotalPages()
    {
        // addding total number of rows
        totrecords = dtVendorForeCast.Rows.Count ;

        // adding header , footer & Grand total count
        totrecords = totrecords + (dtVFCSort.Rows.Count * 3) + 1;

        if (totrecords <= 38)
        {
            Pager1.SetPageTotal = 1;
        }
        if (totrecords != 0)
        {
            totpages = totrecords / 38;
            remainder = totrecords % 38;
            totpages = (remainder == 0 ? totpages : totpages + 1);
        }
        Pager1.SetPageTotal = totpages;
    }

    #region Do Distinct Statement
    private static DataTable SelectDistinct(DataTable SourceTable, params string[] FieldNames)
    {
        object[] lastValues;
        DataTable newTable;
        DataRow[] orderedRows;

        if (FieldNames == null || FieldNames.Length == 0)
            throw new ArgumentNullException("FieldNames");

        lastValues = new object[FieldNames.Length];
        newTable = new DataTable();

        foreach (string fieldName in FieldNames)
            newTable.Columns.Add(fieldName, SourceTable.Columns[fieldName].DataType);

        orderedRows = SourceTable.Select("", string.Join(", ", FieldNames));

        foreach (DataRow row in orderedRows)
        {
            if (!fieldValuesAreEqual(lastValues, row, FieldNames))
            {
                newTable.Rows.Add(createRowClone(row, newTable.NewRow(), FieldNames));

                setLastValues(lastValues, row, FieldNames);
            }
        }

        return newTable;
    }

    private static bool fieldValuesAreEqual(object[] lastValues, DataRow currentRow, string[] fieldNames)
    {
        bool areEqual = true;

        for (int i = 0; i < fieldNames.Length; i++)
        {
            if (lastValues[i] == null || !lastValues[i].Equals(currentRow[fieldNames[i]]))
            {
                areEqual = false;
                break;
            }
        }

        return areEqual;
    }

    private static DataRow createRowClone(DataRow sourceRow, DataRow newRow, string[] fieldNames)
    {
        foreach (string field in fieldNames)
            newRow[field] = sourceRow[field];

        return newRow;
    }

    private static void setLastValues(object[] lastValues, DataRow sourceRow, string[] fieldNames)
    {
        for (int i = 0; i < fieldNames.Length; i++)
            lastValues[i] = sourceRow[fieldNames[i]];
    }
    #endregion

    #endregion

    #region Web Form Designer generated code
    override protected void OnInit(EventArgs e)
    {
        //
        // CODEGEN: This call is required by the ASP.NET Web Form Designer.
        //
        InitializeComponent();
        base.OnInit(e);
    }

    /// <summary>
    /// Required method for Designer support - do not modify
    /// the contents of this method with the code editor.
    /// </summary>
    private void InitializeComponent()
    {
        this.Pager1.BubbleClick += new EventHandler(this.Pager_PageChanged);
    }
    #endregion

    #region Ajax Method
    
    [Ajax.AjaxMethod()]
    public void DeleteExcelFile(string fileName)
    {
        string filePath = Server.MapPath("~") + "\\Common\\ExcelUploads\\" + fileName;

        if (File.Exists(filePath))
            File.Delete(filePath);
    }
    #endregion

    
}
