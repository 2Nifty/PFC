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

public partial class ProfitLbRpt : System.Web.UI.Page
{
    SqlConnection cnxERP;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet ds = new DataSet();

    Decimal DispVal, TotProfit, TotSales, TotPounds, TotMgn;
    Decimal GrdTotProfit, GrdTotSales, GrdTotPounds, GrdTotMgnDollars;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(ProfitLbRpt));
        Session["SessionID"] = ((Session["SessionID"] != null) ? Session["SessionID"].ToString() : "null");

        cnxERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["csERP"].ConnectionString);

        //if (Request.QueryString["Location"].ToString() == "00")
        //    lblBranchHd.Text = ": " + Request.QueryString["LocName"].ToString();
        //else
        //    lblBranchHd.Text = ": " + Request.QueryString["Location"].ToString() + " - " + Request.QueryString["LocName"].ToString();
        lblBranchHd.Text = ": " + Request.QueryString["LocName"].ToString();

        if (Request.QueryString["Range"].ToString() == "Daily")
        {
            lblRangeHd.Text = "Daily Margin Per Pound";
            cmd = new SqlCommand("pDashboardDrilldownDaily", cnxERP);
        }

        if (Request.QueryString["Range"].ToString() == "MTD")
        {
            lblRangeHd.Text = "MTD Margin Per Pound";
            cmd = new SqlCommand("pDashboardDrilldownMTD", cnxERP);
        }

        cmd.Parameters.AddWithValue("@Loc", Request.QueryString["Location"].ToString());
        cmd.CommandType = CommandType.StoredProcedure;

        hidSort.Value = ((Session["SortProfitLb"] != null) ? Session["SortProfitLb"].ToString() : " MarginPerLb DESC");

        if (!Page.IsPostBack)
            BindDataGrid();
    }

    public void BindDataGrid()
    {
        String sortExpression = (hidSort.Value == "") ? " MarginPerLb DESC" : hidSort.Value;
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "Profit");
        ds.Tables["Profit"].DefaultView.Sort = sortExpression;
        GridView1.DataSource = ds.Tables["Profit"].DefaultView.ToTable();

        if (ds.Tables["Profit"].Rows.Count > 0)
        {
            GrdTotMgnDollars = Convert.ToDecimal(ds.Tables["Profit"].Compute("sum(MarginDollars)", ""));
            lblTotMgnDollars.Text = String.Format("{0:c}", GrdTotMgnDollars);

            GrdTotProfit = Convert.ToDecimal(ds.Tables["Profit"].Compute("sum(Profit)", ""));
            lblTotProfit.Text = String.Format("{0:c}", GrdTotProfit);

            GrdTotPounds = Math.Round(Convert.ToDecimal(ds.Tables["Profit"].Compute("sum(Lbs)", "")), 2);
            lblTotPounds.Text = String.Format("{0:0,0.00}", GrdTotPounds);

            GrdTotSales = Convert.ToDecimal(ds.Tables["Profit"].Compute("sum(SalesDollars)", ""));
            lblTotSales.Text = String.Format("{0:c}", GrdTotSales);

            if (GrdTotPounds == 0)
                lblTotMgnPerLb.Text = "0";
            else
                lblTotMgnPerLb.Text = String.Format("{0:c}", GrdTotMgnDollars / GrdTotPounds);

            if (GrdTotSales == 0)
                lblTotMgnPct.Text = "0";
            else
                lblTotMgnPct.Text = String.Format("{0:N2}%", GrdTotMgnDollars / GrdTotSales * 100);

            GrdTotSales = Convert.ToDecimal(ds.Tables["Profit"].Compute("sum(SalesDollars)", ""));
            lblTotSales.Text = String.Format("{0:c}", GrdTotSales);

            if (GrdTotPounds == 0)
                lblTotPricePerLb.Text = "0";
            else
                lblTotPricePerLb.Text = String.Format("{0:c}", GrdTotSales / GrdTotPounds);
        }

        Pager1.InitPager(GridView1, 22);
    }

    protected void ItemDataBound(Object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            TotMgn = TotMgn + Convert.ToDecimal(e.Item.Cells[2].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[2].Text);
            e.Item.Cells[2].Text = String.Format("{0:c}", DispVal);
            
            TotProfit = TotProfit + Convert.ToDecimal(e.Item.Cells[3].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[3].Text);
            e.Item.Cells[3].Text = String.Format("{0:c}", DispVal);

            TotPounds = TotPounds + Convert.ToDecimal(e.Item.Cells[4].Text);
            DispVal = Math.Round(Convert.ToDecimal(e.Item.Cells[4].Text), 2);
            e.Item.Cells[4].Text = String.Format("{0:0,0.00}", DispVal);

            TotSales = TotSales + Convert.ToDecimal(e.Item.Cells[6].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[6].Text);
            e.Item.Cells[6].Text = String.Format("{0:c}", DispVal);
        }
        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].Text = "Sub-Tot:";

            if (TotPounds == 0)
                e.Item.Cells[1].Text = "0";
            else
                e.Item.Cells[1].Text = String.Format("{0:c}", TotMgn / TotPounds);
            
            e.Item.Cells[2].Text = String.Format("{0:c}", TotMgn);
            
            e.Item.Cells[3].Text = String.Format("{0:c}", TotProfit);

            e.Item.Cells[4].Text = String.Format("{0:0,0.00}", Math.Round(TotPounds, 2));

            if (TotSales == 0)
                e.Item.Cells[5].Text = "0";
            else
                e.Item.Cells[5].Text = String.Format("{0:N2}%", TotMgn / TotSales * 100);

            e.Item.Cells[6].Text = String.Format("{0:c}", TotSales);

            if (TotPounds == 0)
                e.Item.Cells[7].Text = "0";
            else
                e.Item.Cells[7].Text = String.Format("{0:c}", TotSales / TotPounds);
        }
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
            hidSort.Attributes.Add("sortType", "DESC");

        hidSort.Value = "[" + e.SortExpression + "] " + hidSort.Attributes["sortType"].ToString();
        Session["SortProfitLb"] = hidSort.Value;
        BindDataGrid();
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        GridView1.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        char tab = '\t';

        String xlsFile = "ProfitLbRpt_" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//DashboardDrilldown//Excel//") + xlsFile;

        StreamWriter swExcel = new StreamWriter(ExportFile, false);

        swExcel.WriteLine("Category" + tab + "Mgn/Lb" + tab + "Mgn $" + tab + "Profit $" + tab + "Pounds" + tab + "Mgn %" + tab + "Sales $" + tab + "Price/Lb");

        String sortExpression = (hidSort.Value == "") ? " MarginPerLb DESC" : hidSort.Value;
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "Profit");
        ds.Tables["Profit"].DefaultView.Sort = sortExpression;

        foreach (DataRow ProfitRow in ds.Tables["Profit"].DefaultView.ToTable().Rows)
            swExcel.WriteLine(ProfitRow["CategoryGroup"].ToString() + tab + String.Format("{0:c}", ProfitRow["MarginPerLb"]) + tab + String.Format("{0:c}", ProfitRow["MarginDollars"]) + tab + String.Format("{0:c}", ProfitRow["Profit"]) + tab + String.Format("{0:0,0.00}", ProfitRow["Lbs"]) + tab + String.Format("{0:N2}%", ProfitRow["MarginPct"]) + tab + String.Format("{0:c}", ProfitRow["SalesDollars"]) + tab + String.Format("{0:c}", ProfitRow["SalesPerLb"]));

        swExcel.Close();

        //Response.Redirect("ExcelExport.aspx?Filename=../DashboardDrilldown/Excel/" + xlsFile, true);

        //Downloading Process
        FileStream fileStream = File.Open(ExportFile, FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(ExportFile));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..//DashboardDrilldown//Excel//"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(strSession))
                    fn.Delete();
            }

            return "";
        }
        catch (Exception ex) { return ""; }
    }
}


