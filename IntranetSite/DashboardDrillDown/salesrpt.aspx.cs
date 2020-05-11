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

public partial class SalesRpt : System.Web.UI.Page
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
        Ajax.Utility.RegisterTypeForAjax(typeof(SalesRpt));
        Session["SessionID"] = ((Session["SessionID"] != null) ? Session["SessionID"].ToString() : "null");

        cnxERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["csERP"].ConnectionString);

        //if (Request.QueryString["Location"].ToString() == "00")
        //    lblBranchHd.Text = ": " + Request.QueryString["LocName"].ToString();
        //else
        //    lblBranchHd.Text = ": " + Request.QueryString["Location"].ToString() + " - " + Request.QueryString["LocName"].ToString();
        lblBranchHd.Text = ": " + Request.QueryString["LocName"].ToString();
        
        if (Request.QueryString["Range"].ToString() == "Daily")
        {
            lblRangeHd.Text = "Daily Sales";
            cmd = new SqlCommand("pDashboardDrilldownDaily", cnxERP);
        }

        if (Request.QueryString["Range"].ToString() == "MTD")
        {
            lblRangeHd.Text = "MTD Sales";
            cmd = new SqlCommand("pDashboardDrilldownMTD", cnxERP);
        }

        cmd.Parameters.AddWithValue("@Loc", Request.QueryString["Location"].ToString());
        cmd.CommandType = CommandType.StoredProcedure;

        hidSort.Value = ((Session["SortSales"] != null) ? Session["SortSales"].ToString() : " SalesDollars DESC");
        
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

        if (ds.Tables["Sales"].Rows.Count > 0)
        {
            GrdTotSales = Convert.ToDecimal(ds.Tables["Sales"].Compute("sum(SalesDollars)", ""));
            lblTotSales.Text = String.Format("{0:c}", GrdTotSales);

            GrdTotPounds = Math.Round(Convert.ToDecimal(ds.Tables["Sales"].Compute("sum(Lbs)", "")), 2);
            lblTotPounds.Text = String.Format("{0:0,0.00}", GrdTotPounds);

            GrdTotMgnDollars = Convert.ToDecimal(ds.Tables["Sales"].Compute("sum(MarginDollars)", ""));
            lblTotMgnDollars.Text = String.Format("{0:c}", GrdTotMgnDollars);

            if (GrdTotPounds == 0)
                lblTotPricePerLb.Text = "0";
            else
                lblTotPricePerLb.Text = String.Format("{0:c}", GrdTotSales / GrdTotPounds);

            if (GrdTotSales == 0)
                lblTotMgnPct.Text = "0";
            else
                lblTotMgnPct.Text = String.Format("{0:N2}%", GrdTotMgnDollars / GrdTotSales * 100);

            if (GrdTotPounds == 0)
                lblTotMgnPerLb.Text = "0";
            else
                lblTotMgnPerLb.Text = String.Format("{0:c}", GrdTotMgnDollars / GrdTotPounds);

            GrdTotBudgetSales = Convert.ToDecimal(ds.Tables["Sales"].Compute("sum(BudgetSales)", ""));
            lblTotBudgetSales.Text = String.Format("{0:c}", GrdTotBudgetSales);

            GrdTotBudgetMgn = Convert.ToDecimal(ds.Tables["Sales"].Compute("sum(BudgetMargin)", ""));
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
            Label _lblCatNo = e.Item.FindControl("lblCatNo") as Label;
            HyperLink _lnkCatNo = e.Item.FindControl("lnkCatNo") as HyperLink;
            if (Request.QueryString["Range"].ToString() == "MTD")
            {
                _lblCatNo.Visible = false;
                _lnkCatNo.Visible = true;
                _lnkCatNo.ForeColor = System.Drawing.Color.Green;
                _lnkCatNo.Font.Underline = true;
                _lnkCatNo.Attributes.Add("onclick", "var hwnd=window.open(this.href, 'CatSales', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hwnd.opener = self; if (window.focus) {hwnd.focus()} return false;");
                //_lnkCatNo.NavigateUrl = "CatSalesRpt.aspx?Location=" + Request.QueryString["Location"].ToString().Trim() +
                //                                        "&LocName=" + Request.QueryString["LocName"].ToString().Trim() +
                //                                        "&Range=" + Request.QueryString["Range"].ToString().Trim() +
                //                                        "&Category=" + DataBinder.GetDataItem("DataItem.CategoryGroup") + 
                //                                        "&CSRName=";
//NavigateUrl='<%# "CatSalesRpt.aspx?CSRName=&Location="+Request.QueryString["Location"].ToString().Trim()+"&LocName="+Request.QueryString["LocName"].ToString().Trim()+"&Range="+Request.QueryString["Range"].ToString().Trim()+"&Category="+DataBinder.Eval(Container,"DataItem.CategoryGroup")%>' Text='<%# DataBinder.Eval(Container,"DataItem.CategoryGroup")%>'></asp:HyperLink> 
            }
            else
            {
                _lblCatNo.Visible = true;
                _lnkCatNo.Visible = false;
            }

            TotSales = TotSales + Convert.ToDecimal(e.Item.Cells[1].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[1].Text);
            e.Item.Cells[1].Text = String.Format("{0:c}", DispVal);

            TotPounds = TotPounds + Convert.ToDecimal(e.Item.Cells[2].Text);
            DispVal = Math.Round(Convert.ToDecimal(e.Item.Cells[2].Text), 2);
            e.Item.Cells[2].Text = String.Format("{0:0,0.00}", DispVal);

            TotMgn = TotMgn + Convert.ToDecimal(e.Item.Cells[5].Text);
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
            e.Item.Cells[0].HorizontalAlign = HorizontalAlign.Left;

            e.Item.Cells[1].Text = String.Format("{0:c}", TotSales);

            e.Item.Cells[2].Text = String.Format("{0:0,0.00}", Math.Round(TotPounds, 2));

            if (TotPounds == 0)
                e.Item.Cells[3].Text = "0";
            else
                e.Item.Cells[3].Text = String.Format("{0:c}", TotSales / TotPounds);

            if (TotSales == 0)
                e.Item.Cells[4].Text = "0";
            else
                e.Item.Cells[4].Text = String.Format("{0:N2}%", TotMgn / TotSales * 100);

            e.Item.Cells[5].Text = String.Format("{0:c}", TotMgn);

            if (TotPounds == 0)
                e.Item.Cells[6].Text = "0";
            else
                e.Item.Cells[6].Text = String.Format("{0:c}", TotMgn / TotPounds);

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
        Session["SortSales"] = hidSort.Value;
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
        
        String xlsFile = "SalesRpt_" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//DashboardDrilldown//Excel//") + xlsFile;

        StreamWriter swExcel = new StreamWriter(ExportFile, false);

        swExcel.WriteLine("Category" + tab + "Sales $" + tab + "Pounds" + tab + "Price/Lb" + tab + "Mgn %" + tab + "Mgn $" + tab + "Mgn/Lb" + tab + "Budget Sales" + tab + "Budget Margin" + tab + "Budget Mgn %");

        String sortExpression = (hidSort.Value == "") ? " SalesDollars DESC" : hidSort.Value;
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "Sales");
        ds.Tables["Sales"].DefaultView.Sort = sortExpression;

        foreach (DataRow SalesRow in ds.Tables["Sales"].DefaultView.ToTable().Rows)
            swExcel.WriteLine(SalesRow["CategoryGroup"].ToString() + tab + String.Format("{0:c}", SalesRow["SalesDollars"]) + tab + String.Format("{0:0,0.00}", SalesRow["Lbs"]) + tab + String.Format("{0:c}", SalesRow["SalesPerLb"]) + tab + String.Format("{0:N2}%", SalesRow["MarginPct"]) + tab + String.Format("{0:c}", SalesRow["MarginDollars"]) + tab + String.Format("{0:c}", SalesRow["MarginPerLb"]) + tab + String.Format("{0:c}", SalesRow["BudgetSales"]) + tab + String.Format("{0:c}", SalesRow["BudgetMargin"]) + tab + String.Format("{0:N2}%", SalesRow["BudgetMarginPct"]));

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
