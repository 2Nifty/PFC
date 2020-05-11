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

public partial class ProfitRptPreview : System.Web.UI.Page
{
    SqlConnection cnxERP;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet ds = new DataSet();

    Decimal DispVal, TotProfit, TotSales, TotPounds, TotMgn;

    protected void Page_Load(object sender, EventArgs e)
    {
        cnxERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["csERP"].ConnectionString);

        //if (Request.QueryString["Location"].ToString() == "00")
        //    lblBranchHd.Text = ": " + Request.QueryString["LocName"].ToString();
        //else
        //    lblBranchHd.Text = ": " + Request.QueryString["Location"].ToString() + " - " + Request.QueryString["LocName"].ToString();
        lblBranchHd.Text = ": " + Request.QueryString["LocName"].ToString();

        if (Request.QueryString["Range"].ToString() == "Daily")
        {
            lblRangeHd.Text = "Daily Profit";
            cmd = new SqlCommand("pDashboardDrilldownDaily", cnxERP);
        }

        if (Request.QueryString["Range"].ToString() == "MTD")
        {
            lblRangeHd.Text = "MTD Profit";
            cmd = new SqlCommand("pDashboardDrilldownMTD", cnxERP);
        }

        cmd.Parameters.AddWithValue("@Loc", Request.QueryString["Location"].ToString());
        cmd.CommandType = CommandType.StoredProcedure;

        if (!Page.IsPostBack)
            BindDataGrid();
        decimal Count = GridView1.Items.Count;
        for (int i = 0; i < Count; i++)
            GridView1.Items[i].Font.Size = 8;
    }

    public void BindDataGrid()
    {
        String sortExpression = (Session["SortProfit"] == null) ? " Profit DESC" : Session["SortProfit"].ToString();
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "Profit");
        ds.Tables["Profit"].DefaultView.Sort = sortExpression;
        GridView1.DataSource = ds.Tables["Profit"].DefaultView.ToTable();
        GridView1.DataBind();
    }

    protected void ItemDataBound(Object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            TotProfit = TotProfit + Convert.ToDecimal(e.Item.Cells[1].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[1].Text);
            e.Item.Cells[1].Text = String.Format("{0:c}", DispVal);

            TotMgn = TotMgn + Convert.ToDecimal(e.Item.Cells[2].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[2].Text);
            e.Item.Cells[2].Text = String.Format("{0:c}", DispVal);

            TotPounds = TotPounds + Convert.ToDecimal(e.Item.Cells[3].Text);
            DispVal = Math.Round(Convert.ToDecimal(e.Item.Cells[3].Text), 2);
            e.Item.Cells[3].Text = String.Format("{0:0,0.00}", DispVal);

            TotSales = TotSales + Convert.ToDecimal(e.Item.Cells[6].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[6].Text);
            e.Item.Cells[6].Text = String.Format("{0:c}", DispVal);
        }
        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].Text = "Grd-Tot:";

            e.Item.Cells[1].Text = String.Format("{0:c}", TotProfit);

            e.Item.Cells[2].Text = String.Format("{0:c}", TotMgn);

            e.Item.Cells[3].Text = String.Format("{0:0,0.00}", Math.Round(TotPounds, 2));

            if (TotPounds == 0)
                e.Item.Cells[4].Text = "0";
            else
                e.Item.Cells[4].Text = String.Format("{0:c}", TotMgn / TotPounds);

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
}
