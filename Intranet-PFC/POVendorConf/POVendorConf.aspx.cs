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

public partial class POVendorConf : System.Web.UI.Page
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
        BindDataGrid();
        
        if (!Page.IsPostBack)
        {
            btnClose.Attributes.Add("onclick", "javascript:window.location='" + Request.ServerVariables.Get("HTTP_REFERER") + "'");
        }
    }

    public void BindDataGrid()
    {
        string sortExpression = (hidSort.Value == "") ? " [PO No] Asc" : hidSort.Value;
        adp = new SqlDataAdapter(cmd);
        ds.Clear();
        adp.Fill(ds, "POVendorConf");
        ds.Tables["POVendorConf"].DefaultView.Sort = sortExpression;
        GridView1.DataSource = ds.Tables["POVendorConf"].DefaultView.ToTable();
        GridView1.DataBind();
        Pager1.InitPager(GridView1, 20);
    }
    
    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        GridView1.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void ExportRpt_Click(object sender, ImageClickEventArgs e)
    {
        char tab = '\t';

        String xlsFile = "POVendorConf.xls";
        String ExportFile = Server.MapPath("..//POVendorConf//Excel//") + xlsFile;

        StreamWriter swExcel = new StreamWriter(ExportFile, false);

        swExcel.WriteLine("PO No" + tab + "Vendor No" + tab + "Vendor Short Code" + tab + "PO Date" + tab + "Total PO Qty" + tab + "Total PO Amount" +tab + "Outstanding Qty" + tab + "Due Date");

        foreach (DataRow PORow in ds.Tables["POVendorConf"].Rows)
            swExcel.WriteLine(PORow["PO No"].ToString() + tab + PORow["Vendor No"].ToString() + tab + PORow["Vendor Short Code"].ToString() + tab + PORow["PO Date"].ToString() + tab + String.Format("{0:0}", PORow["POQty"]) + tab + String.Format("{0:C}", PORow["POAmt"]) + tab + String.Format("{0:0}", PORow["OutstandingQty"]) + tab + String.Format("{0:d}", PORow["Due Date"]));

        swExcel.Close();

        Response.Redirect("ExcelExport.aspx?Filename=../POVendorConf/Excel/" + xlsFile, true);
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
            hidSort.Attributes.Add("sortType", "ASC");

        hidSort.Value = "[" + e.SortExpression + "] " + hidSort.Attributes["sortType"].ToString();

        BindDataGrid();

    }
}
