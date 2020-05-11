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

public partial class SOHeaderRptPreview : System.Web.UI.Page
{
    SqlConnection cnxERP;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet ds = new DataSet();

    Decimal DispVal, TotSales, TotPounds, TotMgn;
    Decimal GrdTotSales, GrdTotPounds, GrdTotMgnDollars;

    protected void Page_Load(object sender, EventArgs e)
    {
        cnxERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["csERP"].ConnectionString);

        if (Request.QueryString["Customer"].ToString() != "******")
            lblCustHd.Text = ": Cust #" + Request.QueryString["Customer"].ToString();
        else
            lblBranchHd.Text = ": " + Request.QueryString["LocName"].ToString();

        if (Request.QueryString["Range"].ToString() == "Daily")
        {
            lblRangeHd.Text = "Daily Sales Orders";
            cmd = new SqlCommand("pDashboardSODrilldownDaily", cnxERP);
        }

        if (Request.QueryString["Range"].ToString() == "MTD")
        {
            lblRangeHd.Text = "MTD Sales Orders";
            cmd = new SqlCommand("pDashboardSODrilldownMTD", cnxERP);
        }

        cmd.Parameters.AddWithValue("@Loc", Request.QueryString["Location"].ToString());
        cmd.Parameters.AddWithValue("@CustNo", Request.QueryString["Customer"].ToString());
        cmd.Parameters.AddWithValue("@InvoiceNo", Request.QueryString["Invoice"].ToString());
        cmd.CommandType = CommandType.StoredProcedure;

        if (!Page.IsPostBack)
            BindDataGrid();

        decimal Count = GridView1.Items.Count;
        for (int i = 0; i < Count; i++)
            GridView1.Items[i].Font.Size = 8;
    }

    public void BindDataGrid()
    {
        String sortExpression = (Session["SortSOHeader"] == null) ? " SalesDollars DESC" : Session["SortSOHeader"].ToString();
        String rowFilter = (Request.QueryString["Source"] == "") ? "ALL" : Request.QueryString["Source"];
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "SOHdr");
        ds.Tables["SOHdr"].DefaultView.Sort = sortExpression;
        switch (rowFilter)
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
        GridView1.DataBind();
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
            e.Item.Cells[2].Text = "Grand-Totals:";

            e.Item.Cells[5].Text = String.Format("{0:c}", TotSales);

            e.Item.Cells[6].Text = String.Format("{0:0,0.00}", Math.Round(TotPounds, 2));

            if (TotPounds == 0)
                e.Item.Cells[7].Text = "0";
            else
                e.Item.Cells[7].Text = String.Format("{0:c}", TotSales / TotPounds);

            e.Item.Cells[8].Text = String.Format("{0:c}", TotMgn);

            if (TotPounds == 0)
                e.Item.Cells[9].Text = "0";
            else
                e.Item.Cells[9].Text = String.Format("{0:c}", TotMgn / TotPounds);

            if (TotSales == 0)
                e.Item.Cells[10].Text = "0";
            else
                e.Item.Cells[10].Text = String.Format("{0:N2}%", TotMgn / TotSales * 100);
        }
    }
}
