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

public partial class SOCustomerRptPreview : System.Web.UI.Page
{
    SqlConnection cnxERP;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet ds = new DataSet();

    Decimal DispVal, TotSales, TotPounds, TotMgn, TotMTDGoal, TotMTDGoalMgn, TotYTDSales, TotYTDGoal, TotYTDGoalMgn, TotSalesWeb, TotMgnWeb;

    protected void Page_Load(object sender, EventArgs e)
    {
        //cnxERP = new SqlConnection(System.Configuration.ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString());
        cnxERP = new SqlConnection(System.Configuration.ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString());

        lblBranchHd.Text = ": " + Request.QueryString["CSRName"].ToString();

        if (Request.QueryString["Range"].ToString() == "Daily")
        {
            GridView1.Width = 910;
            lblRangeHd.Text = "Daily Sales Orders By Customer";            
        }

        if (Request.QueryString["Range"].ToString() == "MTD")
        {
            GridView1.Width = 1245;
            lblRangeHd.Text = "MTD Sales Orders By Customer";        
        }
        
        cmd = new SqlCommand("[pDashboardCSRSODrilldown]", cnxERP);
        cmd.Parameters.AddWithValue("@Loc", Request.QueryString["Location"].ToString());
        cmd.Parameters.AddWithValue("@CustNo", Request.QueryString["Customer"].ToString());
        cmd.Parameters.AddWithValue("@InvoiceNo", Request.QueryString["Invoice"].ToString());
        cmd.Parameters.AddWithValue("@csrName", Request.QueryString["CSRName"].ToString());
        cmd.Parameters.AddWithValue("@reportType", "Header");
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
        String sortExpression = (Session["SortSOCustomer"] == null) ? " SalesDollars DESC" : Session["SortSOCustomer"].ToString();
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "SoCust");
        ds.Tables["SoCust"].DefaultView.Sort = sortExpression;
        GridView1.DataSource = ds.Tables["SoCust"].DefaultView.ToTable();
        GridView1.DataBind();
    }

    protected void ItemDataBound(Object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Header)
            if (Request.QueryString["Range"].ToString() != "MTD")
            {
                e.Item.Cells[8].Visible = false;
                e.Item.Cells[9].Visible = false;
                e.Item.Cells[10].Visible = false;
                e.Item.Cells[11].Visible = false;
                e.Item.Cells[12].Visible = false;
            }

        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            TotSales = TotSales + Convert.ToDecimal(e.Item.Cells[2].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[2].Text);
            e.Item.Cells[2].Text = String.Format("{0:c}", DispVal);

            TotPounds = TotPounds + Convert.ToDecimal(e.Item.Cells[3].Text);
            DispVal = Math.Round(Convert.ToDecimal(e.Item.Cells[3].Text), 2);
            e.Item.Cells[3].Text = String.Format("{0:0,0.00}", DispVal);

            TotMgn = TotMgn + Convert.ToDecimal(e.Item.Cells[5].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[5].Text);
            e.Item.Cells[5].Text = String.Format("{0:c}", DispVal);

            if (Request.QueryString["Range"].ToString() == "MTD")
            {
                TotMTDGoalMgn = TotMTDGoalMgn + (Convert.ToDecimal(e.Item.Cells[8].Text) * Convert.ToDecimal(e.Item.Cells[9].Text));
                TotMTDGoal = TotMTDGoal + Convert.ToDecimal(e.Item.Cells[8].Text);
                DispVal = Convert.ToDecimal(e.Item.Cells[8].Text);
                e.Item.Cells[8].Text = String.Format("{0:c}", DispVal);

                DispVal = Convert.ToDecimal(e.Item.Cells[9].Text) * 100;
                e.Item.Cells[9].Text = String.Format("{0:N2}%", DispVal);

                TotYTDSales = TotYTDSales + Convert.ToDecimal(e.Item.Cells[10].Text);
                DispVal = Convert.ToDecimal(e.Item.Cells[10].Text);
                e.Item.Cells[10].Text = String.Format("{0:c}", DispVal);

                TotYTDGoalMgn = TotYTDGoalMgn + (Convert.ToDecimal(e.Item.Cells[11].Text) * Convert.ToDecimal(e.Item.Cells[12].Text));
                TotYTDGoal = TotYTDGoal + Convert.ToDecimal(e.Item.Cells[11].Text);
                DispVal = Convert.ToDecimal(e.Item.Cells[11].Text);
                e.Item.Cells[11].Text = String.Format("{0:c}", DispVal);

                DispVal = Convert.ToDecimal(e.Item.Cells[12].Text) * 100;
                e.Item.Cells[12].Text = String.Format("{0:N2}%", DispVal);
            }
            else    //Hide MTD/YTD Goal/Sales data
            {
                e.Item.Cells[8].Visible = false;
                e.Item.Cells[9].Visible = false;
                e.Item.Cells[10].Visible = false;
                e.Item.Cells[11].Visible = false;
                e.Item.Cells[12].Visible = false;
            }

            TotSalesWeb = TotSalesWeb + Convert.ToDecimal(e.Item.Cells[13].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[13].Text);
            e.Item.Cells[13].Text = String.Format("{0:c}", DispVal);

            TotMgnWeb = TotMgnWeb + Convert.ToDecimal(e.Item.Cells[14].Text);
            DispVal = Convert.ToDecimal(e.Item.Cells[14].Text);
            e.Item.Cells[14].Text = String.Format("{0:c}", DispVal);
        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[1].Text = "Grand-Totals:";

            e.Item.Cells[2].Text = String.Format("{0:c}", TotSales);

            e.Item.Cells[3].Text = String.Format("{0:0,0.00}", Math.Round(TotPounds, 2));

            if (TotPounds == 0)
                e.Item.Cells[4].Text = "0";
            else
                e.Item.Cells[4].Text = String.Format("{0:c}", TotSales / TotPounds);

            e.Item.Cells[5].Text = String.Format("{0:c}", TotMgn);

            if (TotPounds == 0)
                e.Item.Cells[6].Text = "0";
            else
                e.Item.Cells[6].Text = String.Format("{0:c}", TotMgn / TotPounds);

            if (TotSales == 0)
                e.Item.Cells[7].Text = "0";
            else
                e.Item.Cells[7].Text = String.Format("{0:N2}%", TotMgn / TotSales * 100);

            if (Request.QueryString["Range"].ToString() == "MTD")
            {
                e.Item.Cells[8].Text = String.Format("{0:c}", TotMTDGoal);

                if (TotMTDGoal == 0)
                    e.Item.Cells[9].Text = "0";
                else
                    e.Item.Cells[9].Text = String.Format("{0:N2}%", TotMTDGoalMgn / TotMTDGoal * 100);

                e.Item.Cells[10].Text = String.Format("{0:c}", TotYTDSales);

                e.Item.Cells[11].Text = String.Format("{0:c}", TotYTDGoal);

                if (TotYTDGoal == 0)
                    e.Item.Cells[12].Text = "0";
                else
                    e.Item.Cells[12].Text = String.Format("{0:N2}%", TotYTDGoalMgn / TotYTDGoal * 100);
            }
            else
            {
                e.Item.Cells[8].Visible = false;
                e.Item.Cells[9].Visible = false;
                e.Item.Cells[10].Visible = false;
                e.Item.Cells[11].Visible = false;
                e.Item.Cells[12].Visible = false;
            }

            e.Item.Cells[13].Text = String.Format("{0:c}", TotSalesWeb);

            e.Item.Cells[14].Text = String.Format("{0:c}", TotMgnWeb);

            if (TotSalesWeb == 0)
                e.Item.Cells[15].Text = "0";
            else
                e.Item.Cells[15].Text = String.Format("{0:N2}%", TotMgnWeb / TotSalesWeb * 100);

            if (TotSales == 0)
                e.Item.Cells[16].Text = "0";
            else
                e.Item.Cells[16].Text = String.Format("{0:N2}%", TotSalesWeb / TotSales * 100);
        }
    }
}
