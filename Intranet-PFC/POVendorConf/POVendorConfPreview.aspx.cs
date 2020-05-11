using System;
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

public partial class POVendorConfPreview : System.Web.UI.Page
{
    SqlConnection cnxNV;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet ds = new DataSet();

    protected void Page_Load(object sender, EventArgs e)
    {
        cnxNV = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["csNVReports"].ConnectionString);
        cmd = new SqlCommand("pPOVendorConf", cnxNV);
        cmd.CommandType = CommandType.StoredProcedure;
        if (!Page.IsPostBack)
        {
           BindDataGrid();
           decimal Count = GridView1.Items.Count;
           for (int i = 0; i < Count; i++)
               GridView1.Items[i].Font.Size = 8;
        }

        //Response.Write(Request.QueryString["SortCommand"].ToString());

    }

    public void BindDataGrid()
    {
        string sortExpression = (Request.QueryString["SortCommand"].ToString() == "") ? " [PO No] Asc" : Request.QueryString["SortCommand"].ToString();
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "POVendorConf");
        ds.Tables["POVendorConf"].DefaultView.Sort = sortExpression;
        GridView1.DataSource = ds.Tables["POVendorConf"].DefaultView.ToTable();
        GridView1.DataBind();
    }
}

