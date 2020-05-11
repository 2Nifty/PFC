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

public partial class SODetailRptPreview : System.Web.UI.Page
{
    SqlConnection cnxERP;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet ds = new DataSet();

    Decimal DispVal, TotShipQty, TotSales, TotPounds, TotMgn;

    protected void Page_Load(object sender, EventArgs e)
    {
        //cnxERP = new SqlConnection(System.Configuration.ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString());
        cnxERP = new SqlConnection(System.Configuration.ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString());

        if (Request.QueryString["Invoice"].ToString() != "0000000000")
            lblInvHd.Text = ": Invoice #" + Request.QueryString["Invoice"].ToString();
        else
            lblBranchHd.Text = ": " + Request.QueryString["LocName"].ToString();

        if (Request.QueryString["Range"].ToString() == "Daily")
        {
            lblRangeHd.Text = "Daily Sales Order Detail";            
        }

        if (Request.QueryString["Range"].ToString() == "MTD")
        {
            lblRangeHd.Text = "MTD Sales Order Detail";            
        }

        cmd = new SqlCommand("[pDashboardCSRSODrilldown]", cnxERP);
        cmd.Parameters.AddWithValue("@Loc", "");
        cmd.Parameters.AddWithValue("@CustNo", Request.QueryString["Customer"].ToString());
        cmd.Parameters.AddWithValue("@InvoiceNo", Request.QueryString["Invoice"].ToString());
        cmd.Parameters.AddWithValue("@csrName", Request.QueryString["CSRName"].ToString());
        cmd.Parameters.AddWithValue("@reportType", "Detail");
        cmd.Parameters.AddWithValue("@period", Request.QueryString["Range"].ToString());
        cmd.CommandType = CommandType.StoredProcedure;

        if (!Page.IsPostBack)
            BindDataGrid();

        decimal Count = GridView1.Items.Count;
        for (int i = 0; i < Count; i++)
            GridView1.Items[i].Font.Size = 8;
    }

    public void BindDataGrid()
    {
        String sortExpression = (Session["SortSODetail"] == null) ? " SalesDollars DESC" : Session["SortSODetail"].ToString();
        String rowFilter = (Request.QueryString["Source"] == "") ? "ALL" : Request.QueryString["Source"];
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "SODtl");
        ds.Tables["SODtl"].DefaultView.Sort = sortExpression;
        switch (rowFilter)
        {
            case "ALLCSR":
                ds.Tables["SODtl"].DefaultView.RowFilter = "OrderSourceSeq <> 1";
                break;
            case "ALLEC":
                ds.Tables["SODtl"].DefaultView.RowFilter = "OrderSourceSeq = 1";
                break;
            default:
                if (rowFilter != "ALL")
                    ds.Tables["SODtl"].DefaultView.RowFilter = "OrderSource = '" + rowFilter.ToString() + "'";
                break;
        }
        GridView1.DataSource = ds.Tables["SODtl"].DefaultView.ToTable();
        GridView1.DataBind();
    }

    protected void ItemDataBound(Object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            TotShipQty = TotShipQty + Convert.ToDecimal(e.Item.Cells[7].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[7].Text);
            e.Item.Cells[7].Text = String.Format("{0:N0}", DispVal);
            
            TotSales = TotSales + Convert.ToDecimal(e.Item.Cells[8].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[8].Text);
            e.Item.Cells[8].Text = String.Format("{0:c}", DispVal);

            TotPounds = TotPounds + Convert.ToDecimal(e.Item.Cells[9].Text);
            DispVal = Math.Round(Convert.ToDecimal(e.Item.Cells[9].Text), 2);
            e.Item.Cells[9].Text = String.Format("{0:0,0.00}", DispVal);

            TotMgn = TotMgn + Convert.ToDecimal(e.Item.Cells[11].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[11].Text);
            e.Item.Cells[11].Text = String.Format("{0:c}", DispVal);
        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[2].Text = "Grand-Totals:";

            e.Item.Cells[7].Text = String.Format("{0:N0}", TotShipQty);

            e.Item.Cells[8].Text = String.Format("{0:c}", TotSales);

            e.Item.Cells[9].Text = String.Format("{0:0,0.00}", Math.Round(TotPounds, 2));

            if (TotPounds == 0)
                e.Item.Cells[10].Text = "0";
            else
                e.Item.Cells[10].Text = String.Format("{0:c}", TotSales / TotPounds);

            e.Item.Cells[11].Text = String.Format("{0:c}", TotMgn);

            if (TotPounds == 0)
                e.Item.Cells[12].Text = "0";
            else
                e.Item.Cells[12].Text = String.Format("{0:c}", TotMgn / TotPounds);

            if (TotSales == 0)
                e.Item.Cells[13].Text = "0";
            else
                e.Item.Cells[13].Text = String.Format("{0:N2}%", TotMgn / TotSales * 100);
        }
    }
}
