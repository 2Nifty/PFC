/********************************************************************************************
 * File	Name			:	CustomerSalesAnalysis.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Retrive Data From Curvalsum Table - Customerwise.
 * Created By			:	Senthilkumar
 * Created Date			:	08/07/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/12/2006		    Version 1		Menaka		        Created
 * 08/19/2006		    Version 2		Senthilkumar 		Store Procedure Name Changed
 * 09/19/2006		    Version 3		Senthilkumar 		Change The Format of The Excel Sheet
 * 09/20/2006           Version 4		Mahesh      		Implemented Ajax To Delete Excel Files on Page Unload & Comments Added
 *********************************************************************************************/
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
    string CategoryDetailGridIds = string.Empty;
    #endregion
    
    #region Control Events
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            Session["VendorForeCastData"] = null;
            BindDataToGrid();
            lblRunDate.Text = DateTime.Now.ToShortDateString();
            lblMultiplier.Text = " " + Session["VendorMultiplier"].ToString();

            // store the category grid names in hidvalue
            if(CategoryDetailGridIds != string.Empty)
                hidGridNames.Value = CategoryDetailGridIds.Remove(0, 1);
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

            // script to bind header in all the pages
            CategoryDetailGridIds = CategoryDetailGridIds + "," + dgCategoryDetail.ClientID;
            
            dgCategoryDetail.DataSource = filteredItemPrixedTable;
            dgCategoryDetail.DataBind();
            
        }
    }

    protected void dgCategory_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        dgCategory.CurrentPageIndex = e.NewPageIndex;
        BindDataToGrid();
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
            //ExcelExport();

            // Grand Total
            foreCastUSG = String.Format("{0:#,##0}", Convert.ToDecimal(dtVFCSort.Compute("Sum(ForeCastUSG)", "")));
            usgUOM = String.Format("{0:#,##0}", Convert.ToDecimal(dtVFCSort.Compute("Sum(USGUOM)", "")));
            usgLBS = String.Format("{0:#,##0}", Convert.ToDecimal(dtVFCSort.Compute("Sum(USGLBS)", "")));
            usgKGS = String.Format("{0:#,##0}", Convert.ToDecimal(dtVFCSort.Compute("Sum(USGKGS)", "")));

            footerContent = "";
            footerContent += "<table border='1' width='100%' cellpadding='0'cellspacing='0'>";
            footerContent += "<tr><td style='width:403px' class='GridHead' align='right'>Grand Total</td>";
            footerContent += "<td style='width:60px' class='GridHead' align='right'>" + foreCastUSG + "</td>";
            footerContent += "<td style='width:60px' class='GridHead' align='right'>" + usgUOM + "</td>";
            footerContent += "<td style='width:60px' class='GridHead' align='right'>" + usgLBS + "</td>";
            footerContent += "<td style='width:60px' class='GridHead' align='right'>" + usgKGS + "</td></tr></table>";

            dgCategory.Columns[0].FooterText = footerContent;
            dgCategory.DataSource = dtVFCSort;
            dgCategory.DataBind();
        }
        catch (Exception ex) { Response.Write(ex.Message.ToString()); }
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

    protected void dgCategoryDetail_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        
        if (e.Item.ItemType == ListItemType.Header)
        {
            string headerContent = string.Empty;

            e.Item.Cells[5].Visible = false;
            e.Item.Cells[6].Visible = false;
            e.Item.Cells[7].Visible = false;
            
            e.Item.Cells[0].RowSpan = 2;
            e.Item.Cells[1].RowSpan = 2;
            e.Item.Cells[2].RowSpan = 2;
            e.Item.Cells[3].RowSpan = 2;
            e.Item.Cells[4].ColumnSpan = 4;

            e.Item.Cells[4].HorizontalAlign = HorizontalAlign.Center;
            e.Item.Cells[4].Text += "<tr style='background-color:#DFF3F9;'><td class='GridHead'align='center'>Quantity</td>";
            e.Item.Cells[4].Text += "<td class='GridHead' align='center'>Units</td>";
            e.Item.Cells[4].Text += "<td class='GridHead' align='center'>Pounds</td>";
            e.Item.Cells[4].Text += "<td class='GridHead' align='center'>Kgs.</td></tr>";           
        }   
    }
}
