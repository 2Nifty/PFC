using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;
using PFC.Intranet.BusinessLogicLayer;

public partial class BranchStockStatusReport : System.Web.UI.Page
{
    string cnERP = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    //string umbrellaConnectionString = ConfigurationManager.AppSettings["UmbrellaConnectionString"].ToString();
    MaintenanceUtility MaintUtil = new MaintenanceUtility();

    //bool ProcessError;

    //int PageSize = 18;
    //int dgOffSet = 3;

    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataTable dtSched = new DataTable();

    GridViewRow row;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            ExcelUpdatePanel.Visible = true;

            //ApprovalOKHidden.Value = MaintUtil.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.CatPriceSchedMaintApproval);

            //if (ApprovalOKHidden.Value.ToString() != "")
            //{
                ApprovalOKHidden.Value = "TRUE";
            //}
            //else
            //if ((MaintUtil.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.CatPriceSchedMaintAccess) == "") && (ApprovalOKHidden.Value.ToUpper() != "TRUE"))
            //{
            //    txtBranchNo.Enabled = false;
            //    btnSearch.Visible = false;
            //    lblErrorMessage.Text = "You do not have sufficient security to access this application.";
            //    MessageUpdatePanel.Update();
            //}
        }

        //Initializing AJAX.NET Library 
        Ajax.Utility.RegisterTypeForAjax(typeof(BranchStockStatusReport));
        smBranchStockStatus.SetFocus("txtBranchNo");
    }

    #region Search
    protected void txtStrCat_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtStrCat.Text.ToString()))
            txtStrCat.Text = txtStrCat.Text.PadLeft(5, '0').ToString();
        smBranchStockStatus.SetFocus(txtStrSize);
    }

    protected void txtStrSize_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtStrSize.Text.ToString()))
            txtStrSize.Text = txtStrSize.Text.PadLeft(4, '0').ToString();
        smBranchStockStatus.SetFocus(txtStrVar);
    }

    protected void txtStrVar_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtStrVar.Text.ToString()))
            txtStrVar.Text = txtStrVar.Text.PadLeft(3, '0').ToString();
        smBranchStockStatus.SetFocus(txtEndCat);
    }

    protected void txtEndCat_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtEndCat.Text.ToString()))
            txtEndCat.Text = txtEndCat.Text.PadLeft(5, '0').ToString();
        smBranchStockStatus.SetFocus(txtEndSize);
    }

    protected void txtEndSize_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtEndSize.Text.ToString()))
            txtEndSize.Text = txtEndSize.Text.PadLeft(4, '0').ToString();
        smBranchStockStatus.SetFocus(txtEndVar);
    }

    protected void txtEndVar_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtEndVar.Text.ToString()))
            txtEndVar.Text = txtEndVar.Text.PadLeft(3, '0').ToString();
        smBranchStockStatus.SetFocus(btnSearch);
    }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        //tPager.Visible = true;
        //BSSGridView.CurrentPageIndex = 0;
        //Pager1.GotoPageNumber = 0;
        //pnlPager.Update();

        lblErrorMessage.Text = "";
        lblSuccessMessage.Text = "";
        MessageUpdatePanel.Update();

        if (txtBranchNo.Text.Trim().Length == 0)
        {
            lblErrorMessage.Text = "You must enter a Branch Number.";
            MessageUpdatePanel.Update();
        }
        else
        {
            lblErrorMessage.Text = "";
            ClearDisplay();

            //Validate Item Params
            if (string.IsNullOrEmpty(txtStrCat.Text))
            {
                txtStrCat.Text = "00000";
                if (string.IsNullOrEmpty(txtEndCat.Text))
                    txtEndCat.Text = "99999";
            }
            else
            {
                if (string.IsNullOrEmpty(txtEndCat.Text))
                    txtEndCat.Text = txtStrCat.Text;
            }

            if (string.IsNullOrEmpty(txtStrSize.Text))
            {
                txtStrSize.Text = "0000";
                if (string.IsNullOrEmpty(txtEndSize.Text))
                    txtEndSize.Text = "9999";
            }
            else
            {
                if (string.IsNullOrEmpty(txtEndSize.Text))
                    txtEndSize.Text = txtStrSize.Text;
            }

            if (string.IsNullOrEmpty(txtStrVar.Text))
            {
                txtStrVar.Text = "000";
                if (string.IsNullOrEmpty(txtEndVar.Text))
                    txtEndVar.Text = "999";
            }
            else
            {
                if (string.IsNullOrEmpty(txtEndVar.Text))
                    txtEndVar.Text = txtStrVar.Text;
            }

            //Get the data using pSSLocExcelDump         
            ds = SqlHelper.ExecuteDataset(cnERP, "pSSLocExcelDump",
                  new SqlParameter("@LocID", txtBranchNo.Text.Trim()),
                  new SqlParameter("@StrCat", txtStrCat.Text.Trim()),
                  new SqlParameter("@StrSize", txtStrSize.Text.Trim()),
                  new SqlParameter("@StrVar", txtStrVar.Text.Trim()),
                  new SqlParameter("@EndCat", txtEndCat.Text.Trim()),
                  new SqlParameter("@EndSize", txtEndSize.Text.Trim()),
                  new SqlParameter("@EndVar", txtEndVar.Text.Trim()));

            if (ds.Tables.Count >= 1)
            {
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    DataView dv = new DataView(dt, hidRowFilter.Value.ToString(), hidSort.Value.ToString(), DataViewRowState.CurrentRows);
                    // BSSGridView.DataSource = dv;
                    lblSuccessMessage.Text = dt.Rows.Count.ToString().Trim() + " record(s) found. Click Excel button to Export";

                    Session["BSSData"] = dt;

                    BSSGridView.DataBind();

                    ExcelUpdatePanel.Visible = true;
                    SelectorUpdatePanel.Update();
                    DetailUpdatePanel.Update();
                }
                else
                {
                    lblErrorMessage.Text = "No Branch Status for Branch Location " + txtBranchNo.Text.Trim();
                    MessageUpdatePanel.Update();
                    Session["BSSData"] = null;
                    BSSGridView.DataBind();
                }
                MessageUpdatePanel.Update();
            }
        }
    }
    #endregion

    #region Excel
    protected void btnExcel_Click(object sender, ImageClickEventArgs e)
    {
        CreateExcelFile();
    }

    private void CreateExcelFile()
    {
        string ExcelFileName = @"../Common/ExcelUploads/BSS" + Session["SessionID"].ToString() + ".xls";
        string fullpath = Request.MapPath(ExcelFileName);

        using (StreamWriter sw = new StreamWriter(fullpath))
        {
            sw.Write("Location\tItemNo\tCatDesc\tItemSize\tFinish\tUPCCd\tBoxSize\tSellStkUMQty\tSellStkUM\tPcsPerPallet\tSuperUM\tSVC\tROP\tROPDays\tAvlQty\tOHQty\tWOQty\tPOQty\tTIQty\tOWQty\tOpenMRPNo");
            sw.WriteLine();

            dt = (DataTable)Session["BSSData"];
            if (!string.IsNullOrEmpty(hidSort.Value.Trim()))
                dt.DefaultView.Sort = hidSort.Value;
            dt.DefaultView.RowFilter = hidRowFilter.Value;

            foreach (DataRow row in dt.DefaultView.ToTable().Rows)
            {
                sw.Write(row["Location"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["ItemNo"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["CatDesc"].ToString().Trim());
                sw.Write("\t");
                sw.Write(@"=""" + row["ItemSize"].ToString() + @"""");
                sw.Write("\t");
                sw.Write(row["Finish"].ToString().Trim());
                sw.Write("\t");
                sw.Write(@"=""" + row["UPCCd"].ToString() + @"""");
                sw.Write("\t");
                sw.Write(row["BoxSize"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["SellStkUMQty"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["SellStkUM"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["PcsPerPallet"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["SuperUM"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["SVC"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["ROP"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["ROPDays"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["AvlQty"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["OHQty"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["WOQty"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["POQty"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["TIQty"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["OWQty"].ToString().Trim());
                sw.Write("\t");
                sw.Write(row["OpenMRPNo"].ToString().Trim());
                sw.Write("\t");
                sw.WriteLine();
            }
        }

        // Downloading Process
        //
        FileStream fileStream = File.Open(fullpath, FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        // fileStream.Close();

        Response.AddHeader("Content-disposition", "attachment; filename=" + fullpath);
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }
    #endregion

    public void ClearDisplay()
    {
        ExcelUpdatePanel.Visible = false;
    }

    protected void ibtnRefresh_Click(object sender, ImageClickEventArgs e)
    {
        txtBranchNo.Text = "";

        txtStrCat.Text = "";
        txtStrSize.Text = "";
        txtStrVar.Text = "";
        txtEndCat.Text = "";
        txtEndSize.Text = "";
        txtEndVar.Text = "";

        lblSuccessMessage.Text = "";
        lblErrorMessage.Text = "";

        DeleteExcel("BSS" + Session["SessionID"].ToString());
 
        smBranchStockStatus.SetFocus(txtBranchNo);
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void UnloadPage()
    {
        Session["BSSData"] = null;
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


    #region DataGrid  //Does not seem to be used
    public void SortDetailGrid(Object sender, GridViewSortEventArgs e)
    {
        try
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

            dt = (DataTable)Session["BSSData"];
            DataView dv = new DataView(dt, hidRowFilter.Value.ToString(), hidSort.Value.ToString(), DataViewRowState.CurrentRows);
            BSSGridView.DataSource = dv;
            BSSGridView.DataBind();
            DetailGridPanel.Height = new Unit(double.Parse(DetailGridHeightHidden.Value), UnitType.Pixel);
            DetailGridPanel.Width = new Unit(double.Parse(DetailGridWidthHidden.Value), UnitType.Pixel);
        }
        catch (Exception e2)
        {
            lblErrorMessage.Text = "Sort Error " + e2.Message + ", " + e2.ToString();
            MessageUpdatePanel.Update();
        }
    }

    //protected void Pager_PageChanged(Object sender, System.EventArgs e)
    //{
    //    BSSGridView.CurrentPageIndex = Pager1.GotoPageNumber;
    //    BindDataGrid();
    //}

    #endregion
}