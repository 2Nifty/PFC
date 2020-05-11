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

public partial class CatSalesRpt : System.Web.UI.Page
{
    SqlConnection cnReports, cnErp;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet ds = new DataSet();

    Decimal DispVal, TotSales, TotPounds, TotMgn, LMTotSales, LMTotPounds, LMTotMgn, PMTotSales, PMTotPounds, PMTotMgn;
    Decimal GrdTotSales, GrdTotPounds, GrdTotMgnDollars, LMGrdTotSales, LMGrdTotPounds, LMGrdTotMgnDollars, PMGrdTotSales, PMGrdTotPounds, PMGrdTotMgnDollars;
    protected void Page_Load(object sender, EventArgs e)
    {
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(CatSalesRpt));
        Session["SessionID"] = ((Session["SessionID"] != null) ? Session["SessionID"].ToString() : "null");

        cnErp = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
        cnReports = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCReportsConnectionString"].ConnectionString);

        lblRangeHd.Text = "MTD Customer Sales";

        if (!string.IsNullOrEmpty(Request.QueryString["CSRName"].ToString()))
        {
            lblBranchHd.Text = "  [Category: " + Request.QueryString["Category"].ToString() + " - CSR: " + Request.QueryString["CSRName"].ToString() + "]";
            cmd = new SqlCommand("pDashboardDrilldownCSRCatMTD", cnErp);
            cmd.Parameters.AddWithValue("@CSR", Request.QueryString["CSRName"].ToString());
            cmd.Parameters.AddWithValue("@Cat", Request.QueryString["Category"].ToString());
            cmd.CommandType = CommandType.StoredProcedure;
        }
        else
        {
            lblBranchHd.Text = "  [Category: " + Request.QueryString["Category"].ToString() + " - Location: " + Request.QueryString["LocName"].ToString() + "]";
            cmd = new SqlCommand("pDashboardDrilldownCustCatMTD", cnReports);
            cmd.Parameters.AddWithValue("@Loc", Request.QueryString["Location"].ToString());
            cmd.Parameters.AddWithValue("@Cat", Request.QueryString["Category"].ToString());
            cmd.CommandType = CommandType.StoredProcedure;
        }

        hidSort.Value = ((Session["SortCatSales"] != null) ? Session["SortCatSales"].ToString() : " SalesDollars DESC");
        
        if (!Page.IsPostBack)
            BindDataGrid();
    }

    public void BindDataGrid()
    {
        String sortExpression = (hidSort.Value == "") ? " SalesDollars DESC" : hidSort.Value;
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "Sales");
        ds.Tables["Sales"].DefaultView.Sort = sortExpression;
        GridView1.DataSource = ds.Tables["Sales"].DefaultView.ToTable();

        //Grand totals
        if (ds.Tables["Sales"].Rows.Count > 0)
        {
            //Current Month
            GrdTotSales = Convert.ToDecimal(ds.Tables["Sales"].Compute("sum(SalesDollars)", ""));
            lblTotSales.Text = String.Format("{0:c}", GrdTotSales);
            GrdTotPounds = Math.Round(Convert.ToDecimal(ds.Tables["Sales"].Compute("sum(Lbs)", "")), 2);
            lblTotPounds.Text = String.Format("{0:0,0.00}", GrdTotPounds);
            GrdTotMgnDollars = Convert.ToDecimal(ds.Tables["Sales"].Compute("sum(MarginDollars)", ""));
            //lblTotMgnDollars.Text = String.Format("{0:c}", GrdTotMgnDollars);
            if (GrdTotPounds == 0)
                lblTotPricePerLb.Text = "0";
            else
                lblTotPricePerLb.Text = String.Format("{0:c}", GrdTotSales / GrdTotPounds);
            if (GrdTotSales == 0)
                lblTotMgnPct.Text = "0";
            else
                lblTotMgnPct.Text = String.Format("{0:N2}%", GrdTotMgnDollars / GrdTotSales * 100);

            //Last Month
            LMGrdTotSales = Convert.ToDecimal(ds.Tables["Sales"].Compute("sum(LMSalesDollars)", ""));
            lblLMTotSales.Text = String.Format("{0:c}", LMGrdTotSales);
            LMGrdTotPounds = Math.Round(Convert.ToDecimal(ds.Tables["Sales"].Compute("sum(LMLbs)", "")), 2);
            lblLMTotPounds.Text = String.Format("{0:0,0.00}", LMGrdTotPounds);
            LMGrdTotMgnDollars = Convert.ToDecimal(ds.Tables["Sales"].Compute("sum(LMMarginDollars)", ""));
            //lblLMTotMgnDollars.Text = String.Format("{0:c}", LMGrdTotMgnDollars);
            if (LMGrdTotPounds == 0)
                lblLMTotPricePerLb.Text = "0";
            else
                lblLMTotPricePerLb.Text = String.Format("{0:c}", LMGrdTotSales / LMGrdTotPounds);
            if (LMGrdTotSales == 0)
                lblLMTotMgnPct.Text = "0";
            else
                lblLMTotMgnPct.Text = String.Format("{0:N2}%", LMGrdTotMgnDollars / LMGrdTotSales * 100);

            //Previous Month
            PMGrdTotSales = Convert.ToDecimal(ds.Tables["Sales"].Compute("sum(PMSalesDollars)", ""));
            lblPMTotSales.Text = String.Format("{0:c}", PMGrdTotSales);
            PMGrdTotPounds = Math.Round(Convert.ToDecimal(ds.Tables["Sales"].Compute("sum(PMLbs)", "")), 2);
            lblPMTotPounds.Text = String.Format("{0:0,0.00}", PMGrdTotPounds);
            PMGrdTotMgnDollars = Convert.ToDecimal(ds.Tables["Sales"].Compute("sum(PMMarginDollars)", ""));
            //lblPMTotMgnDollars.Text = String.Format("{0:c}", PMGrdTotMgnDollars);
            if (PMGrdTotPounds == 0)
                lblPMTotPricePerLb.Text = "0";
            else
                lblPMTotPricePerLb.Text = String.Format("{0:c}", PMGrdTotSales / PMGrdTotPounds);
            if (PMGrdTotSales == 0)
                lblPMTotMgnPct.Text = "0";
            else
                lblPMTotMgnPct.Text = String.Format("{0:N2}%", PMGrdTotMgnDollars / PMGrdTotSales * 100);
        }

        Pager1.InitPager(GridView1, 21);
    }

    protected void ItemDataBound(Object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            //Current Month
            TotSales = TotSales + Convert.ToDecimal(e.Item.Cells[2].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[2].Text);
            e.Item.Cells[2].Text = String.Format("{0:c}", DispVal);

            TotPounds = TotPounds + Convert.ToDecimal(e.Item.Cells[3].Text);
            DispVal = Math.Round(Convert.ToDecimal(e.Item.Cells[3].Text), 2);
            e.Item.Cells[3].Text = String.Format("{0:0,0.00}", DispVal);

            TotMgn = TotMgn + Convert.ToDecimal(e.Item.Cells[6].Text);

            //Last Month
            LMTotSales = LMTotSales + Convert.ToDecimal(e.Item.Cells[7].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[7].Text);
            e.Item.Cells[7].Text = String.Format("{0:c}", DispVal);

            LMTotPounds = LMTotPounds + Convert.ToDecimal(e.Item.Cells[8].Text);
            DispVal = Math.Round(Convert.ToDecimal(e.Item.Cells[8].Text), 2);
            e.Item.Cells[8].Text = String.Format("{0:0,0.00}", DispVal);

            LMTotMgn = LMTotMgn + Convert.ToDecimal(e.Item.Cells[11].Text);

            //Previous Month
            PMTotSales = PMTotSales + Convert.ToDecimal(e.Item.Cells[12].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[12].Text);
            e.Item.Cells[12].Text = String.Format("{0:c}", DispVal);

            PMTotPounds = PMTotPounds + Convert.ToDecimal(e.Item.Cells[13].Text);
            DispVal = Math.Round(Convert.ToDecimal(e.Item.Cells[13].Text), 2);
            e.Item.Cells[13].Text = String.Format("{0:0,0.00}", DispVal);

            PMTotMgn = PMTotMgn + Convert.ToDecimal(e.Item.Cells[16].Text);
        }

        //Sub-Totals in the Grid Footer
        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[1].Text = "Sub-Totals";

            //Current Month
            e.Item.Cells[2].Text = String.Format("{0:c}", TotSales);
            e.Item.Cells[3].Text = String.Format("{0:0,0.00}", Math.Round(TotPounds, 2));
            if (TotPounds == 0)
                e.Item.Cells[4].Text = "0";
            else
                e.Item.Cells[4].Text = String.Format("{0:c}", TotSales / TotPounds);
            if (TotSales == 0)
                e.Item.Cells[5].Text = "0";
            else
                e.Item.Cells[5].Text = String.Format("{0:N2}%", TotMgn / TotSales * 100);

            //Last Month
            e.Item.Cells[7].Text = String.Format("{0:c}", LMTotSales);
            e.Item.Cells[8].Text = String.Format("{0:0,0.00}", Math.Round(LMTotPounds, 2));
            if (LMTotPounds == 0)
                e.Item.Cells[9].Text = "0";
            else
                e.Item.Cells[9].Text = String.Format("{0:c}", LMTotSales / LMTotPounds);
            if (LMTotSales == 0)
                e.Item.Cells[10].Text = "0";
            else
                e.Item.Cells[10].Text = String.Format("{0:N2}%", LMTotMgn / LMTotSales * 100);

            //Previous Month
            e.Item.Cells[12].Text = String.Format("{0:c}", PMTotSales);
            e.Item.Cells[13].Text = String.Format("{0:0,0.00}", Math.Round(PMTotPounds, 2));
            if (PMTotPounds == 0)
                e.Item.Cells[14].Text = "0";
            else
                e.Item.Cells[14].Text = String.Format("{0:c}", PMTotSales / PMTotPounds);
            if (PMTotSales == 0)
                e.Item.Cells[15].Text = "0";
            else
                e.Item.Cells[15].Text = String.Format("{0:N2}%", PMTotMgn / PMTotSales * 100);
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
        Session["SortCatSales"] = hidSort.Value;
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
        
        String xlsFile = "CatSalesRpt_" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//DashboardDrilldown//Excel//") + xlsFile;

        StreamWriter swExcel = new StreamWriter(ExportFile, false);

        swExcel.WriteLine("Cat No" + tab + "Cust No" + tab + "Cust Name" + tab +
                          "Sales $" + tab + "Pounds" + tab + "Price/Lb" + tab + "Mgn %" + tab +
                          "Sales $ (Last)" + tab + "Pounds (Last)" + tab + "Price/Lb (Last)" + tab + "Mgn % (Last)" + tab +
                          "Sales $ (Prev)" + tab + "Pounds (Prev)" + tab + "Price/Lb (Prev)" + tab + "Mgn % (Prev)");

        String sortExpression = (hidSort.Value == "") ? " SalesDollars DESC" : hidSort.Value;
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "Sales");
        ds.Tables["Sales"].DefaultView.Sort = sortExpression;

        foreach (DataRow SalesRow in ds.Tables["Sales"].DefaultView.ToTable().Rows)
            swExcel.WriteLine(Request.QueryString["Category"].ToString() + tab + SalesRow["CustNo"].ToString() + tab + SalesRow["CustName"].ToString() + tab +
                              String.Format("{0:c}", SalesRow["SalesDollars"]) + tab + String.Format("{0:0,0.00}", SalesRow["Lbs"]) + tab + String.Format("{0:c}", SalesRow["SalesPerLb"]) + tab + String.Format("{0:N2}%", SalesRow["MarginPct"]) + tab +
                              String.Format("{0:c}", SalesRow["LMSalesDollars"]) + tab + String.Format("{0:0,0.00}", SalesRow["LMLbs"]) + tab + String.Format("{0:c}", SalesRow["LMSalesPerLb"]) + tab + String.Format("{0:N2}%", SalesRow["LMMarginPct"]) + tab +
                              String.Format("{0:c}", SalesRow["PMSalesDollars"]) + tab + String.Format("{0:0,0.00}", SalesRow["PMLbs"]) + tab + String.Format("{0:c}", SalesRow["PMSalesPerLb"]) + tab + String.Format("{0:N2}%", SalesRow["PMMarginPct"]));

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
