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

public partial class AC_ItemBranchActivity_ItemBranchActivityPreview : System.Web.UI.Page
{
    SqlConnection cnxAC;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet dsAC = new DataSet();

    protected void Page_Load(object sender, EventArgs e)
    {
        cnxAC = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ACAdminAdj"].ConnectionString);
        Session["SessionID"] = ((Session["SessionID"] != null) ? Session["SessionID"].ToString() : "null");
        
        BindDataGrid();

        decimal Count = GridView1.Items.Count;
        for (int i = 0; i < Count; i++)
            GridView1.Items[i].Font.Size = 8;
    }

    public void BindDataGrid()
    {
        cmd = new SqlCommand("pACGetItemBranchDetail", cnxAC);
        cmd.Parameters.AddWithValue("@BeginDt", Request.QueryString["BeginDt"].ToString());
        cmd.Parameters.AddWithValue("@EndDt", Request.QueryString["EndDt"].ToString());
        cmd.Parameters.AddWithValue("@ItemNo", Request.QueryString["ItemNo"].ToString());
        cmd.Parameters.AddWithValue("@Branch", Request.QueryString["Branch"].ToString());
        cmd.CommandType = CommandType.StoredProcedure;
        adp = new SqlDataAdapter(cmd);
        dsAC.Clear();
        adp.Fill(dsAC, "AC");

        String sortExpression = (Session["SortAC"] == "") ? " CurDate ASC" : Session["SortAC"].ToString();
        dsAC.Tables["AC"].DefaultView.Sort = sortExpression;
        GridView1.DataSource = dsAC.Tables["AC"].DefaultView.ToTable();
        GridView1.DataBind();
    }
}
