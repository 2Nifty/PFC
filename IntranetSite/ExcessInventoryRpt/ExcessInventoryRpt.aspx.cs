using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.IO;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;

public partial class ExcessInventoryRpt : System.Web.UI.Page
{
    SqlConnection cnPFCReports;
    DataSet dsExcessInv;
    DataTable dtExcessInv;
    string strSQL;
    string PreviewURL;
    int PageSize = 18;
    
    DataUtility DataUtil = new DataUtility();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        cnPFCReports = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCReportsConnectionString"].ConnectionString);
        Ajax.Utility.RegisterTypeForAjax(typeof(ExcessInventoryRpt));

        if (!Page.IsPostBack)
        {
            Session["UserName"] = ((Session["UserName"] != null) ? Session["UserName"].ToString() : "[null]");
            DataUtil.BindLocList("ALL", ddlLocation, "MaintainIMQtyInd='Y' ORDER BY LocID");
            ClearGrid();
        }
    }

    #region Filters
    protected void txtCat_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtCat.Text.ToString()))
            txtCat.Text = txtCat.Text.PadLeft(5, '0').ToString();
        smExcessInv.SetFocus(txtSize);
    }

    protected void txtSize_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtSize.Text.ToString()))
            txtSize.Text = txtSize.Text.PadLeft(4, '0').ToString();
        smExcessInv.SetFocus(txtVar);
    }

    protected void txtVar_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtVar.Text.ToString()))
            txtVar.Text = txtVar.Text.PadLeft(3, '0').ToString();
        smExcessInv.SetFocus(txtMin);
    }

    protected void txtMin_TextChanged(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(txtMin.Text.ToString()))
            txtMin.Text = "0";
        smExcessInv.SetFocus(btnSubmit);
    }

    protected void btnSubmit_Click(object sender, ImageClickEventArgs e)
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        PreviewURL = "ExcessInventoryRpt/ExcessInvPreview.aspx?Branch=";
        string whereClause = "WHERE ";

        if (ddlLocation.SelectedIndex > 0)
        {
            whereClause = whereClause + "Branch = '" + ddlLocation.SelectedValue.ToString() + "'";
            PreviewURL = PreviewURL + ddlLocation.SelectedValue.ToString();
            PreviewURL = PreviewURL + "&BranchName=" + ddlLocation.SelectedItem.ToString();
        }
        else
        {
            PreviewURL = PreviewURL + "&BranchName=";
        }

        PreviewURL = PreviewURL + "&Type=";
        if (ddlRecType.SelectedIndex > 0)
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "RecordType = '" + ddlRecType.SelectedValue.ToString() + "'";
            PreviewURL = PreviewURL + ddlRecType.SelectedValue.ToString();
        }

        PreviewURL = PreviewURL + "&Category=";
        if (!string.IsNullOrEmpty(txtCat.Text.ToString()))
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "LEFT(ItemNo,5) = '" + txtCat.Text.ToString() + "'";
            PreviewURL = PreviewURL + txtCat.Text.ToString();
        }

        PreviewURL = PreviewURL + "&Size=";
        if (!string.IsNullOrEmpty(txtSize.Text.ToString()))
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "SUBSTRING(ItemNo,7,4) = '" + txtSize.Text.ToString() + "'";
            PreviewURL = PreviewURL + txtSize.Text.ToString();
        }

        PreviewURL = PreviewURL + "&Variance=";
        if (!string.IsNullOrEmpty(txtVar.Text.ToString()))
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "RIGHT(ItemNo,3) = '" + txtVar.Text.ToString() + "'";
            PreviewURL = PreviewURL + txtVar.Text.ToString();
        }

        PreviewURL = PreviewURL + "&Min=";
        if (!string.IsNullOrEmpty(txtMin.Text.ToString()) && txtMin.Text.ToString() != "0")
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "ExcessQty >= " + txtMin.Text.ToString();
            PreviewURL = PreviewURL + txtMin.Text.ToString();
        }

        hidPreviewURL.Value = PreviewURL;
        PrintDialogue1.PageUrl = hidPreviewURL.Value + "&SortCommand=";
        pnlExport.Update();

        hidSort.Value = "";
        hidSort.Attributes["sortType"] = "ASC";

        strSQL = "SELECT * FROM InventoryRptExcess (NoLock)";
        if (whereClause.ToString() != "WHERE ") strSQL = strSQL + whereClause;
        dsExcessInv = SqlHelper.ExecuteDataset(cnPFCReports, CommandType.Text, strSQL);
        Session["dsExInv"] = dsExcessInv;

        if (dsExcessInv.Tables[0].Rows.Count > 0)
        {
            BindDataGrid();
        }
        else
        {
            DisplayStatusMessage("No matching records found", "fail");
            ClearGrid();
        }
    }
    #endregion

    #region Bind Grid
    private void BindDataGrid()
    {
        dsExcessInv = (DataSet)Session["dsExInv"];
        dtExcessInv = dsExcessInv.Tables[0];
        dtExcessInv.DefaultView.Sort = (hidSort.Value == "") ? "ItemNo ASC, Branch ASC" : hidSort.Value;
        dgExcessInv.DataSource = dtExcessInv.DefaultView.ToTable();
        dgExcessInv.AllowPaging = true;
        dgExcessInv.DataBind();
        pnlRptGrid.Update();

        hidRowCount.Value = dsExcessInv.Tables[0].Rows.Count.ToString();

        Pager1.InitPager(dgExcessInv, PageSize);
        Pager1.Visible = true;
        pnlPager.Update();
    }

    protected void PageChanged(Object sender, System.EventArgs e)
    {
        dgExcessInv.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void dgExcessInv_SortCommand(object source, DataGridSortCommandEventArgs e)
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

        hidSort.Value = e.SortExpression + " " + hidSort.Attributes["sortType"].ToString();
        BindDataGrid();

        PrintDialogue1.PageUrl = hidPreviewURL.Value + "&SortCommand=" + hidSort.Value;
        pnlExport.Update();
    }
    #endregion

    protected void btnExport_Click(object sender, ImageClickEventArgs e)
    {
        //BindDataGrid();
        dsExcessInv = (DataSet)Session["dsExInv"];

        char tab = '\t';

        String xlsFile = "ExcessInv" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//Common//ExcelUploads//") + xlsFile;

        StreamWriter swExcel = new StreamWriter(ExportFile, false);

        swExcel.WriteLine("Item Type" + tab + "ItemNo" + tab + "Loc" + tab + "Size" + tab + "Description" + tab +
                          "UOM" + tab + "Available" + tab + "Excess Qty" + tab + "Excess Wght");

        foreach (DataRow Row in dsExcessInv.Tables[0].Rows)
            swExcel.WriteLine(Row["RecordType"].ToString() + tab + Row["ItemNo"].ToString() + tab + Row["Branch"].ToString() + tab +
                              Row["ItemSize"].ToString() + tab + Row["Description"].ToString() + tab + Row["UOM"].ToString() + tab +
                              String.Format("{0:n0}", Row["AvailableQty"]) + tab + String.Format("{0:n2}", Row["ExcessQty"]) + tab +
                              String.Format("{0:n3}", Row["ExcessWght"]));

        swExcel.Close();

        //Response.Redirect("ExcessInvXLS.aspx?Filename=../Common/ExcelUploads/" + xlsFile, true);
        string URL = "ExcessInvXLS.aspx?Filename=../Common/ExcelUploads/" + xlsFile;
        string script = "window.open('" + URL + "' ,'export','height=710,width=1020,Addressbar=0,scrollbars=no,location=no,status=no,top='+((screen.height/2) - (710/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no','');	";
        ScriptManager.RegisterClientScriptBlock(btnExport, btnExport.GetType(), "export", script, true);
    }

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {
            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..//Common//ExcelUploads//"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(strSession))
                    fn.Delete();
            }

            return "";
        }
        catch (Exception ex) { return ""; }
    }

    protected void btnCancel_Click(object sender, ImageClickEventArgs e)
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        ClearGrid();
    }

    private void ClearGrid()
    {
        ddlLocation.SelectedIndex = 0;
        ddlRecType.SelectedIndex = 0;
        txtCat.Text = "";
        txtSize.Text = "";
        txtVar.Text = "";
        txtMin.Text = "4.9";
        smExcessInv.SetFocus(ddlLocation);

        Session["dsExInv"] = "";
        dgExcessInv.DataSource = "";
        dgExcessInv.AllowPaging = false;
        dgExcessInv.DataBind();
        pnlRptGrid.Update();

        Pager1.Visible = false;
        dgExcessInv.CurrentPageIndex = 0;
        pnlPager.Update();

        PreviewURL = "ExcessInventoryRpt/ExcessInvPreview.aspx?Branch=&BranchName=&Type=&Category=&Size=&Variance=&Min=";
        hidPreviewURL.Value = PreviewURL;
        PrintDialogue1.PageUrl = hidPreviewURL.Value + "&SortCommand=";
        pnlExport.Update();
    }

    private void DisplayStatusMessage(string message, string messageType)
    {
        lblMessage.Visible = true;
        if (messageType.ToLower() == "success")
        {
            lblMessage.ForeColor = System.Drawing.Color.Green;
            lblMessage.Text = message;
        }
        else if (messageType.ToLower() == "fail")
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
            lblMessage.Text = message;
        }
        pnlStatus.Update();
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void UnloadPage()
    {
        Session["dsExInv"] = "";
    }
}
