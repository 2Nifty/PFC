using System;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

public partial class AItemSalesRpt : System.Web.UI.Page
{
    SqlConnection cnxERP;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet ds = new DataSet();

    protected void Page_Load(object sender, EventArgs e)
    {
        cnxERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["csERP"].ConnectionString);
        cmd = new SqlCommand("pAItemSalesRpt", cnxERP);
        cmd.CommandType = CommandType.StoredProcedure;
        BindDataGrid();

        if (!Page.IsPostBack)
        {
            btnClose.Attributes.Add("onclick", "javascript:window.location='" + Request.ServerVariables.Get("HTTP_REFERER") + "'");
        }
    }

    public void BindDataGrid()
    {
        string sortExpression = (hidSort.Value == "") ? " [ItemNo], [Loc] Asc" : hidSort.Value;
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "AItems");
        ds.Tables["AItems"].DefaultView.Sort = sortExpression;
        GridView1.DataSource = ds.Tables["AItems"].DefaultView.ToTable();
        GridView1.DataBind();
        Pager1.InitPager(GridView1, 18);
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        GridView1.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void GridView1_SortCommand(object source, DataGridSortCommandEventArgs e)
    {
        if (hidSort.Attributes["sortType"] != null)
        {
            if (hidSort.Attributes["sortType"].ToString() == "ASC")
                hidSort.Attributes["sortType"] = "DESC";
            else
                hidSort.Attributes["sortType"] = "ASC";
        }
        else
            hidSort.Attributes.Add("sortType", "ASC");

        hidSort.Value = "[" + e.SortExpression + "] " + hidSort.Attributes["sortType"].ToString();

        BindDataGrid();

    }

    protected void ExportRpt_Click(object sender, ImageClickEventArgs e)
    {
        char tab = '\t';

        String xlsFile = "AItemSales.xls";
        String ExportFile = Server.MapPath("..//A-ItemSales//Excel//") + xlsFile;

        StreamWriter swExcel = new StreamWriter(ExportFile, false);

        swExcel.WriteLine("Item No" + tab + "Loc" + tab + "Description" + tab + "30 Day Usage" + tab + "Usage Wgt" + tab + "Available Qty" + tab + "Available Wgt" + tab + "Net Wgt" + tab + "Avg Cost" + tab + "Sugg. Sell Price" + tab + "6 Mo. Avg Sell Price" + tab + "Last Wk Avg Sell Price" + tab + "2nd Wk Avg Sell Price" + tab + "3rd Wk Avg Sell Price" + tab + "4th Wk Avg Sell Price");

        foreach (DataRow AItemRow in ds.Tables["AItems"].Rows)
            swExcel.WriteLine(AItemRow["ItemNo"].ToString() + tab + AItemRow["Loc"].ToString() + tab + AItemRow["Description"].ToString() + tab + String.Format("{0:N0}", AItemRow["TotUse30"]) + tab + String.Format("{0:N2}", AItemRow["TotUseWgt"]) + tab + String.Format("{0:N0}", AItemRow["AvailQty"]) + tab + String.Format("{0:N2}", AItemRow["AvailWgt"]) + tab + String.Format("{0:N2}", AItemRow["Net_Wgt"]) + tab + String.Format("{0:C2}", AItemRow["Avg_CostM"]) + tab + String.Format("{0:C2}", AItemRow["SuggSell"]) + tab + String.Format("{0:C2}", AItemRow["6MthAvgSellPrice"]) + tab + String.Format("{0:C2}", AItemRow["LastWkAvgSellPrice"]) + tab + String.Format("{0:C2}", AItemRow["2ndWkAvgSellPrice"]) + tab + String.Format("{0:C2}", AItemRow["3rdWkAvgSellPrice"]) + tab + String.Format("{0:C2}", AItemRow["4thWkAvgSellPrice"]));

        swExcel.Close();

        Response.Redirect("ExcelExport.aspx?Filename=../A-ItemSales/Excel/" + xlsFile, true);
    }

}
