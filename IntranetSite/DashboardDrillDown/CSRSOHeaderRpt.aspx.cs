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

using PFC.Intranet.DataAccessLayer;

public partial class CSRSOHeaderRpt : System.Web.UI.Page
{
    SqlConnection  cnxPERP;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet ds = new DataSet();

    Decimal DispVal, TotSales, TotPounds, TotMgn;
    Decimal GrdTotSales, GrdTotPounds, GrdTotMgnDollars;

    protected void Page_Load(object sender, EventArgs e)
    {
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(CSRSOHeaderRpt));
        Session["SessionID"] = ((Session["SessionID"] != null) ? Session["SessionID"].ToString() : "null");

        //PERP
        //cnxPERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
        cnxPERP = new SqlConnection(System.Configuration.ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString());
        
        if (Request.QueryString["Customer"].ToString() != "******")
            lblCustHd.Text = ": Cust #" + Request.QueryString["Customer"].ToString();
        else
            //lblBranchHd.Text = ": " + Session["UserName"].ToString();
            lblBranchHd.Text = ": " + Request.QueryString["CSRName"].ToString();

        if (Request.QueryString["Range"].ToString() == "Daily")
        {
            lblRangeHd.Text = "Daily Sales Orders";
        }

        if (Request.QueryString["Range"].ToString() == "MTD")
        {
            lblRangeHd.Text = "MTD Sales Orders";
        }

        hidSort.Value = ((Session["SortSOHeader"] != null) ? Session["SortSOHeader"].ToString() : " SalesDollars DESC");

        if (!Page.IsPostBack)
        {
            BindListControls(ddlOrderSource, "ListDesc", "ListValue", "SOEOrderSource");
            
            cmd = new SqlCommand("pDashboardCSRSODrilldown", cnxPERP);
            cmd.Parameters.AddWithValue("@Loc", Request.QueryString["Location"].ToString());
            cmd.Parameters.AddWithValue("@CustNo", Request.QueryString["Customer"].ToString());
            cmd.Parameters.AddWithValue("@InvoiceNo", Request.QueryString["Invoice"].ToString());
            cmd.Parameters.AddWithValue("@csrName", Request.QueryString["CSRName"].ToString());
            cmd.Parameters.AddWithValue("@reportType", "Header");
            cmd.Parameters.AddWithValue("@period", Request.QueryString["Range"].ToString());

            cmd.CommandType = CommandType.StoredProcedure;
            ds.Clear();
            adp = new SqlDataAdapter(cmd);
            adp.Fill(ds, "SOHdr");
            Session["dsHdr"] = ds;
            BindDataGrid();
            hidRange.Value = Request.QueryString["Range"].ToString();
            hidCSRName.Value = Request.QueryString["CSRName"].ToString();
        }
    }

    public void BindDataGrid()
    {
        String sortExpression = (hidSort.Value == "") ? " SalesDollars DESC" : hidSort.Value;
        String rowFilter = (hidSource.Value == "") ? "ALL" : hidSource.Value;
        ds = (DataSet)Session["dsHdr"];
        ds.Tables["SOHdr"].DefaultView.Sort = sortExpression;
        switch(rowFilter)
        {
            case "ALLCSR":
                ds.Tables["SOHdr"].DefaultView.RowFilter = "OrderSourceSeq <> 1";
            break;
            case "ALLEC":
                ds.Tables["SOHdr"].DefaultView.RowFilter = "OrderSourceSeq = 1";
            break;
            default:
                if (rowFilter != "ALL")
                    ds.Tables["SOHdr"].DefaultView.RowFilter = "OrderSource = '" + rowFilter.ToString() + "'";
            break;
        }
        GridView1.DataSource = ds.Tables["SOHdr"].DefaultView.ToTable();

        lblTotSales.Text = "$0.00";
        lblTotPounds.Text = "00.00";
        lblTotPricePerLb.Text = "$0.00";
        lblTotMgnDollars.Text = "$0.00";
        lblTotMgnPerLb.Text = "$0.00";
        lblTotMgnPct.Text = "0%";

        if (ds.Tables["SOHdr"].DefaultView.ToTable().Rows.Count > 0)
        {
            GrdTotSales = Convert.ToDecimal(ds.Tables["SOHdr"].DefaultView.ToTable().Compute("sum(SalesDollars)", ""));
            lblTotSales.Text = String.Format("{0:c}", GrdTotSales);

            GrdTotPounds = Math.Round(Convert.ToDecimal(ds.Tables["SOHdr"].DefaultView.ToTable().Compute("sum(Lbs)", "")), 2);
            lblTotPounds.Text = String.Format("{0:0,0.00}", GrdTotPounds);

            if (GrdTotPounds != 0)
                lblTotPricePerLb.Text = String.Format("{0:c}", GrdTotSales / GrdTotPounds);

            GrdTotMgnDollars = Convert.ToDecimal(ds.Tables["SOHdr"].DefaultView.ToTable().Compute("sum(MarginDollars)", ""));
            lblTotMgnDollars.Text = String.Format("{0:c}", GrdTotMgnDollars);

            if (GrdTotPounds != 0)
                lblTotMgnPerLb.Text = String.Format("{0:c}", GrdTotMgnDollars / GrdTotPounds);

            if (GrdTotSales != 0)
                lblTotMgnPct.Text = String.Format("{0:N2}%", GrdTotMgnDollars / GrdTotSales * 100);
        }

        Pager1.InitPager(GridView1, 22);
    }

    protected void ItemDataBound(Object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            TotSales = TotSales + Convert.ToDecimal(e.Item.Cells[5].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[5].Text);
            e.Item.Cells[5].Text = String.Format("{0:c}", DispVal);

            TotPounds = TotPounds + Convert.ToDecimal(e.Item.Cells[6].Text);
            DispVal = Math.Round(Convert.ToDecimal(e.Item.Cells[6].Text), 2);
            e.Item.Cells[6].Text = String.Format("{0:0,0.00}", DispVal);

            TotMgn = TotMgn + Convert.ToDecimal(e.Item.Cells[8].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[8].Text);
            e.Item.Cells[8].Text = String.Format("{0:c}", DispVal);
        }
        
        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[2].Text = "Sub-Totals:";

            e.Item.Cells[5].Text = String.Format("{0:c}", TotSales);

            e.Item.Cells[6].Text = String.Format("{0:0,0.00}", Math.Round(TotPounds, 2));

            if (TotPounds == 0)
                e.Item.Cells[7].Text = "$0.00";
            else
                e.Item.Cells[7].Text = String.Format("{0:c}", TotSales / TotPounds);

            e.Item.Cells[8].Text = String.Format("{0:c}", TotMgn);

            if (TotPounds == 0)
                e.Item.Cells[9].Text = "$0.00";
            else
                e.Item.Cells[9].Text = String.Format("{0:c}", TotMgn / TotPounds);

            if (TotSales == 0)
                e.Item.Cells[10].Text = "0%";
            else
                e.Item.Cells[10].Text = String.Format("{0:N2}%", TotMgn / TotSales * 100);
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
        Session["SortSOHeader"] = hidSort.Value;
        BindDataGrid();
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        GridView1.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void ddlOrderSource_SelectedIndexChanged(object sender, EventArgs e)
    {
        hidSource.Value = ddlOrderSource.SelectedValue.ToString();
        BindDataGrid();
    }

    public void BindListControls(ListControl lstControl, string textField, string valueField, string listName)
    {
        try
        {
            DataTable dtSource = GetListDetails(listName);
            if (dtSource != null && dtSource.Rows.Count > 0)
            {
                lstControl.DataSource = dtSource;
                lstControl.DataTextField = textField;
                lstControl.DataValueField = valueField;
                lstControl.DataBind();
                lstControl.Items.Insert(0, new ListItem("*All Orders*", "ALL"));
                //lstControl.Items.Insert(1, new ListItem("*All CSR Orders*", "ALLCSR"));
                //lstControl.Items.Insert(2, new ListItem("*All eCommerce Orders*", "ALLEC"));
            }
            else
            {
                if (lstControl.ID.IndexOf("lst") == -1)
                {
                    lstControl.Items.Clear();
                    lstControl.Items.Insert(0, new ListItem("N/A", ""));
                }

            }
        }
        catch (Exception ex) { }
    }

    public DataTable GetListDetails(string listName)
    {
        try
        {
            string _tableName = "ListMaster (NoLock) LM, ListDetail (NoLock) LD";
            string _columnName = "LD.ListValue, LD.ListValue + ' - ' + LD.ListDtlDesc AS ListDesc";
            string _whereClause = "LM.ListName = '" + listName + "' AND LD.fListMasterID = LM.pListMasterID ORDER BY SequenceNo ASC";
            DataSet dsType = SqlHelper.ExecuteDataset(cnxPERP, "UGEN_SP_Select",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            return dsType.Tables[0];

        }
        catch (Exception ex)
        {
            return null;
        }
    }

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        char tab = '\t';

        String xlsFile = "SOHeader_" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//DashboardDrilldown//Excel//") + xlsFile;

        StreamWriter swExcel = new StreamWriter(ExportFile, false);

        swExcel.WriteLine("Invoice" + tab + "Cust No" + tab + "Customer Name" + tab + "Loc" + tab + "Post Date" + tab + "Sales $" + tab +
                          "Pounds" + tab + "Price/Lb" + tab + "Mgn $" + tab + "Mgn/Lb" + tab + "Mgn %" + tab + "Src");

        String sortExpression = (hidSort.Value == "") ? " SalesDollars DESC" : hidSort.Value;
        String rowFilter = (hidSource.Value == "") ? "ALL" : hidSource.Value;
        ds = (DataSet)Session["dsHdr"];
        ds.Tables["SOHdr"].DefaultView.Sort = sortExpression;

        if (rowFilter != "ALL")
            ds.Tables["SOHdr"].DefaultView.RowFilter = "OrderSource = '" + rowFilter.ToString() + "'";

        foreach (DataRow SOHdrRow in ds.Tables["SOHdr"].DefaultView.ToTable().Rows)
            swExcel.WriteLine(SOHdrRow["InvoiceNo"].ToString() + tab + SOHdrRow["CustNo"].ToString() + tab + SOHdrRow["CustName"].ToString() + tab +
                              SOHdrRow["Location"].ToString() + tab + String.Format("{0:MM/dd/yyyy}", SOHdrRow["ARPostDt"]) + tab +
                              String.Format("{0:c}", SOHdrRow["SalesDollars"]) + tab + String.Format("{0:0,0.00}", SOHdrRow["Lbs"]) + tab +
                              String.Format("{0:c}", SOHdrRow["SalesPerLb"]) + tab + String.Format("{0:c}", SOHdrRow["MarginDollars"]) + tab +
                              String.Format("{0:c}", SOHdrRow["MarginPerLb"]) + tab + String.Format("{0:N2}%", SOHdrRow["MarginPct"]) + tab +
                              SOHdrRow["OrderSource"].ToString());
        
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

        //Clear Session Variable
        Session["dsHdr"] = "";
    }
}