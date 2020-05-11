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

public partial class OpenOrderRptPreview : System.Web.UI.Page
{
    SqlConnection cnx;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet ds = new DataSet();

    protected void Page_Load(object sender, EventArgs e)
    {
        cnx = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
        cmd = new SqlCommand("pOpenOrderRpt", cnx);
        cmd.Parameters.AddWithValue("@CustNo", Request.QueryString["Cust"].ToString());
        cmd.Parameters.AddWithValue("@OrderType", Request.QueryString["OrdType"].ToString());
        cmd.Parameters.AddWithValue("@EntryID", Request.QueryString["SalesPerson"].ToString());
        cmd.Parameters.AddWithValue("@CustShipLoc", Request.QueryString["CustShipLoc"].ToString());
        cmd.Parameters.AddWithValue("@ShipLoc", Request.QueryString["ShipLoc"].ToString());
        cmd.Parameters.AddWithValue("@BadMgn", Request.QueryString["BadMgn"].ToString());

        lblCustNo.Text = ((Request.QueryString["Cust"].ToString() == "" || Request.QueryString["Cust"].ToString() == "000000") ? "All" : Request.QueryString["Cust"].ToString());
        lblOrderType.Text = Request.QueryString["OrdTypeDesc"].ToString();
        lblSalesPerson.Text = (Request.QueryString["SalesPerson"].ToString() == "" ? "All" : Request.QueryString["SalesPerson"].ToString());
        lblSalesLoc.Text = Request.QueryString["CustShipLocDesc"].ToString();
        lblShipLoc.Text = Request.QueryString["ShipLocDesc"].ToString();
        lblLineType.Text = (Request.QueryString["BadMgn"].ToString().ToLower() == "true" ? "Only bad margin lines" : "All Lines");


        cmd.CommandType = CommandType.StoredProcedure;
        BindDataGrid();
    }

    public void BindDataGrid()
    {
        string sortExpression = (Request.QueryString["SortCommand"].ToString() == "") ? " CustNo, SONumber Asc" : Request.QueryString["SortCommand"].ToString();
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "OpenOrders");
        ds.Tables["OpenOrders"].DefaultView.Sort = sortExpression;
        GridView1.DataSource = ds.Tables["OpenOrders"].DefaultView.ToTable();
        GridView1.DataBind();
    }
}
