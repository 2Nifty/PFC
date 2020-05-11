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

public partial class AItemPreview : System.Web.UI.Page
{
    SqlConnection cnxERP;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet ds = new DataSet();

    protected void Page_Load(object sender, EventArgs e)
    {
        cnxERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["csERP"].ConnectionString);
        cmd = new SqlCommand("pAItemSalesRpt", cnxERP);
        cmd.CommandType = CommandType.StoredProcedure;

        if (!Page.IsPostBack)
        {
            BindDataGrid();
            decimal Count = GridView1.Items.Count;
            for (int i = 0; i < Count; i++)
                GridView1.Items[i].Font.Size = 8;
        }
    }

    public void BindDataGrid()
    {
        string sortExpression = (Request.QueryString["SortCommand"].ToString() == "") ? " [ItemNo], [Loc] Asc" : Request.QueryString["SortCommand"].ToString();
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "AItems");
        ds.Tables["AItems"].DefaultView.Sort = sortExpression;
        GridView1.DataSource = ds.Tables["AItems"].DefaultView.ToTable();
        GridView1.DataBind();
    }
}
