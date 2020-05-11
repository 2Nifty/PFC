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

public partial class ItemBranchActivity : System.Web.UI.Page
{
    SqlConnection cnxAC;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet dsAC = new DataSet();

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(ItemBranchActivity));
        cnxAC = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["ACAdminAdj"].ConnectionString);
        Session["SessionID"] = ((Session["SessionID"] != null) ? Session["SessionID"].ToString() : "null");

        if (!Page.IsPostBack)
            Session["SortAC"] = null;
        hidSort.Value = ((Session["SortAC"] != null) ? Session["SortAC"].ToString() : " CurDate ASC");
        Session["SortAC"] = hidSort.Value;
        
        BindDataGrid();
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

        String sortExpression = (hidSort.Value == "") ? " CurDate ASC" : hidSort.Value;
        dsAC.Tables["AC"].DefaultView.Sort = sortExpression;
        GridView1.DataSource = dsAC.Tables["AC"].DefaultView.ToTable();
        Pager1.InitPager(GridView1, 22);
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
            hidSort.Attributes.Add("sortType", "DESC");

        hidSort.Value = "[" + e.SortExpression + "] " + hidSort.Attributes["sortType"].ToString();
        Session["SortAC"] = hidSort.Value;
        BindDataGrid();
    }
    
    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        GridView1.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        char tab = '\t';

        String xlsFile = "ACItemBranch" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//AC_ItemBranchActivity//Common//Excel//") + xlsFile;

        StreamWriter swExcel = new StreamWriter(ExportFile, false);

        swExcel.WriteLine("Cur Date" + tab + "Branch" + tab + "Item No" + tab + "Qty On Hand" + tab + "Rcpt Qty" + tab + "Iss Qty" + tab + "Adj Qty" + tab + "Doc No" + tab + "Parent Doc No" + tab + "Source ID");

        String sortExpression = (hidSort.Value == "") ? " CurDate ASC" : hidSort.Value;
        adp = new SqlDataAdapter(cmd);
        dsAC.Clear();
        adp.Fill(dsAC, "AC");
        dsAC.Tables["AC"].DefaultView.Sort = sortExpression;

        foreach (DataRow ACRow in dsAC.Tables["AC"].DefaultView.ToTable().Rows)
            swExcel.WriteLine(String.Format("{0:MM/dd/yyyy}", ACRow["CurDate"]) + tab + ACRow["Branch"].ToString() + tab + ACRow["ItemNo"].ToString() + tab + ACRow["QOH"].ToString() + tab + ACRow["RcptQty"].ToString() + tab + ACRow["IssQty"].ToString() + tab + ACRow["AdjQty"].ToString() + tab + ACRow["DocNo"].ToString() + tab + ACRow["ParentDocNo"].ToString() + tab + ACRow["SourceId"].ToString());

        swExcel.Close();

        //Downloading Process
        FileStream fileStream = File.Open(ExportFile, FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(ExportFile));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {
            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..//AC_ItemBranchActivity//Common//Excel//"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(strSession))
                    fn.Delete();
            }

            return "";
        }
        catch (Exception ex) { return ""; }
    }
}
