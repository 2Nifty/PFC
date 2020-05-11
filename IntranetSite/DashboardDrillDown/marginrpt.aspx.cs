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

public partial class MarginRpt : System.Web.UI.Page
{
    SqlConnection cnxERP;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet ds = new DataSet();

    Decimal DispVal, TotSales, TotPounds, TotMgn, TotBudgetSales, TotBudgetMgn;
    Decimal GrdTotSales, GrdTotPounds, GrdTotMgnDollars, GrdTotBudgetSales, GrdTotBudgetMgn, GrdTotBudgetMgnPct;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(MarginRpt));
        Session["SessionID"] = ((Session["SessionID"] != null) ? Session["SessionID"].ToString() : "null");

        cnxERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["csERP"].ConnectionString);

        //if (Request.QueryString["Location"].ToString() == "00")
        //    lblBranchHd.Text = ": " + Request.QueryString["LocName"].ToString();
        //else
        //    lblBranchHd.Text = ": " + Request.QueryString["Location"].ToString() + " - " + Request.QueryString["LocName"].ToString();
        lblBranchHd.Text = ": " + Request.QueryString["LocName"].ToString();

        if (Request.QueryString["Range"].ToString() == "Daily")
        {
            lblRangeHd.Text = "Daily Margin";
            cmd = new SqlCommand("pDashboardDrilldownDaily", cnxERP);
        }

        if (Request.QueryString["Range"].ToString() == "MTD")
        {
            lblRangeHd.Text = "MTD Margin";
            cmd = new SqlCommand("pDashboardDrilldownMTD", cnxERP);
        }

        cmd.Parameters.AddWithValue("@Loc", Request.QueryString["Location"].ToString());
        cmd.CommandType = CommandType.StoredProcedure;

        hidSort.Value = ((Session["SortMgn"] != null) ? Session["SortMgn"].ToString() : " MarginDollars DESC");

        if (!Page.IsPostBack)
            BindDataGrid();
    }

    public void BindDataGrid()
    {
        String sortExpression = (hidSort.Value == "") ? " MarginDollars DESC" : hidSort.Value;
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "Margin");
        ds.Tables["Margin"].DefaultView.Sort = sortExpression;
        GridView1.DataSource = ds.Tables["Margin"].DefaultView.ToTable();

        if (ds.Tables["Margin"].Rows.Count > 0)
        {
            GrdTotMgnDollars = Convert.ToDecimal(ds.Tables["Margin"].Compute("sum(MarginDollars)", ""));
            lblTotMgnDollars.Text = String.Format("{0:c}", GrdTotMgnDollars);

            GrdTotPounds = Math.Round(Convert.ToDecimal(ds.Tables["Margin"].Compute("sum(Lbs)", "")), 2);
            lblTotPounds.Text = String.Format("{0:0,0.00}", GrdTotPounds);

            GrdTotSales = Convert.ToDecimal(ds.Tables["Margin"].Compute("sum(SalesDollars)", ""));
            lblTotSales.Text = String.Format("{0:c}", GrdTotSales);

            if (GrdTotPounds == 0)
                lblTotMgnPerLb.Text = "0";
            else
                lblTotMgnPerLb.Text = String.Format("{0:c}", GrdTotMgnDollars / GrdTotPounds);

            if (GrdTotSales == 0)
                lblTotMgnPct.Text = "0";
            else
                lblTotMgnPct.Text = String.Format("{0:N2}%", GrdTotMgnDollars / GrdTotSales * 100);

            if (GrdTotPounds == 0)
                lblTotPricePerLb.Text = "0";
            else
                lblTotPricePerLb.Text = String.Format("{0:c}", GrdTotSales / GrdTotPounds);

            GrdTotBudgetSales = Convert.ToDecimal(ds.Tables["Margin"].Compute("sum(BudgetSales)", ""));
            lblTotBudgetSales.Text = String.Format("{0:c}", GrdTotBudgetSales);

            GrdTotBudgetMgn = Convert.ToDecimal(ds.Tables["Margin"].Compute("sum(BudgetMargin)", ""));
            lblTotBudgetMgn.Text = String.Format("{0:c}", GrdTotBudgetMgn);

            if (GrdTotBudgetSales == 0)
                lblTotBudgetMgnPct.Text = "0";
            else
                lblTotBudgetMgnPct.Text = String.Format("{0:N2}%", GrdTotBudgetMgn / GrdTotBudgetSales * 100);
        }

        Pager1.InitPager(GridView1, 22);
    }

    protected void ItemDataBound(Object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            TotMgn = TotMgn + Convert.ToDecimal(e.Item.Cells[1].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[1].Text);
            e.Item.Cells[1].Text = String.Format("{0:c}", DispVal);

            TotPounds = TotPounds + Convert.ToDecimal(e.Item.Cells[2].Text);
            DispVal = Math.Round(Convert.ToDecimal(e.Item.Cells[2].Text), 2);
            e.Item.Cells[2].Text = String.Format("{0:0,0.00}", DispVal);

            TotSales = TotSales + Convert.ToDecimal(e.Item.Cells[5].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[5].Text);
            e.Item.Cells[5].Text = String.Format("{0:c}", DispVal);

            TotBudgetSales = TotBudgetSales + Convert.ToDecimal(e.Item.Cells[7].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[7].Text);
            e.Item.Cells[7].Text = String.Format("{0:c}", DispVal);

            TotBudgetMgn = TotBudgetMgn + Convert.ToDecimal(e.Item.Cells[8].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[8].Text);
            e.Item.Cells[8].Text = String.Format("{0:c}", DispVal);

        }
        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].Text = "Sub-Tot:";

            e.Item.Cells[1].Text = String.Format("{0:c}", TotMgn);

            e.Item.Cells[2].Text = String.Format("{0:0,0.00}", Math.Round(TotPounds, 2));

            if (TotPounds == 0)
                e.Item.Cells[3].Text = "0";
            else
                e.Item.Cells[3].Text = String.Format("{0:c}", TotMgn / TotPounds);

            if (TotSales == 0)
                e.Item.Cells[4].Text = "0";
            else
                e.Item.Cells[4].Text = String.Format("{0:N2}%", TotMgn / TotSales * 100);

            e.Item.Cells[5].Text = String.Format("{0:c}", TotSales);

            if (TotPounds == 0)
                e.Item.Cells[6].Text = "0";
            else
                e.Item.Cells[6].Text = String.Format("{0:c}", TotSales / TotPounds);

            e.Item.Cells[7].Text = String.Format("{0:c}", TotBudgetSales);

            e.Item.Cells[8].Text = String.Format("{0:c}", TotBudgetMgn);

            if (TotBudgetSales == 0)
                e.Item.Cells[9].Text = "0";
            else
                e.Item.Cells[9].Text = String.Format("{0:N2}%", TotBudgetMgn / TotBudgetSales * 100);
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
        Session["SortMgn"] = hidSort.Value;
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

        String xlsFile = "MarginRpt_" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//DashboardDrilldown//Excel//") + xlsFile;

        StreamWriter swExcel = new StreamWriter(ExportFile, false);
        
        swExcel.WriteLine("Category" + tab + "Mgn $" + tab + "Pounds" + tab + "Mgn/Lb" + tab + "Mgn %" + tab + "Sales $" + tab + "Price/Lb" + tab + "Budget Sales" + tab + "Budget Margin" + tab + "Budget Mgn %");

        String sortExpression = (hidSort.Value == "") ? " MarginDollars DESC" : hidSort.Value;
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "Margin");
        ds.Tables["Margin"].DefaultView.Sort = sortExpression;

        foreach (DataRow SalesRow in ds.Tables["Margin"].DefaultView.ToTable().Rows)
            swExcel.WriteLine(SalesRow["CategoryGroup"].ToString() + tab + String.Format("{0:c}", SalesRow["MarginDollars"]) + tab + String.Format("{0:0,0.00}", SalesRow["Lbs"]) + tab + String.Format("{0:c}", SalesRow["MarginPerLb"]) + tab + String.Format("{0:N2}%", SalesRow["MarginPct"]) + tab + String.Format("{0:c}", SalesRow["SalesDollars"]) + tab + String.Format("{0:c}", SalesRow["SalesPerLb"]) + tab + String.Format("{0:c}", SalesRow["BudgetSales"]) + tab + String.Format("{0:c}", SalesRow["BudgetMargin"]) + tab + String.Format("{0:N2}%", SalesRow["BudgetMarginPct"]));

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
