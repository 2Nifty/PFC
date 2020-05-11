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

public partial class CatSalesRptPreview : System.Web.UI.Page
{
    SqlConnection cnReports, cnErp;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet ds = new DataSet();

    Decimal DispVal, TotSales, TotPounds, TotMgn, LMTotSales, LMTotPounds, LMTotMgn, PMTotSales, PMTotPounds, PMTotMgn;
    Decimal GrdTotSales, GrdTotPounds, GrdTotMgnDollars, LMGrdTotSales, LMGrdTotPounds, LMGrdTotMgnDollars, PMGrdTotSales, PMGrdTotPounds, PMGrdTotMgnDollars;

    protected void Page_Load(object sender, EventArgs e)
    {
        Session["SessionID"] = ((Session["SessionID"] != null) ? Session["SessionID"].ToString() : "null");

        cnErp = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
        cnReports = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCReportsConnectionString"].ConnectionString);

        //lblBranchHd.Text = "  [Category: " + Request.QueryString["Category"].ToString() + " - Location: " + Request.QueryString["LocName"].ToString() + "]";

        //if (Request.QueryString["Range"].ToString() == "Daily")
        //{
        //    lblRangeHd.Text = "Daily Sales";
        //    cmd = new SqlCommand("pDashboardDrilldownDaily", cnReports);
        //}

        if (Request.QueryString["Range"].ToString() == "MTD")
        {
            lblRangeHd.Text = "MTD Customer Sales";
            //cmd = new SqlCommand("pDashboardDrilldownCustCatMTD", cnReports);
        }

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

        //cmd.Parameters.AddWithValue("@Loc", Request.QueryString["Location"].ToString());
        //cmd.Parameters.AddWithValue("@Cat", Request.QueryString["Category"].ToString());
        //cmd.CommandType = CommandType.StoredProcedure;

        BindDataGrid();
    }

    public void BindDataGrid()
    {
        String sortExpression = " SalesDollars DESC";  //(Session["SortCatSales"] == null) ? " SalesDollars DESC" : Session["SortCatSales"].ToString();
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "Sales");
        ds.Tables["Sales"].DefaultView.Sort = sortExpression;        
        GridView1.DataSource = ds.Tables["Sales"].DefaultView.ToTable();
        GridView1.DataBind();
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

        //Grand-Totals in the Grid Footer
        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[1].Text = "Grand-Totals";

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
}
