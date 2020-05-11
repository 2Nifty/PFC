using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.IO;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using System.Data.SqlClient;
using PFC.Intranet;
public partial class WarehouseMgmt_HTIItemReceiving : System.Web.UI.Page
{

    DataTable dtReport = new DataTable();
    DataTable dtExcelReport = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(WarehouseMgmt_HTIItemReceiving));
       lblMessage.Text = "";
        if (!IsPostBack)
        {
            // Create Sesssion table to save item information
            DataTable dtHTIItems = new DataTable();
            dtHTIItems.Columns.Add("BinLabel");
            dtHTIItems.Columns.Add("Location");
            Session["HTIBinLabelSelected"] = dtHTIItems;

            hidFileName.Value = "HTIUnReceivedItemsReport" + Session["SessionID"].ToString() + ".xls";
            BindDataGrid();
        }        
    }

    private void BindDataGrid()
    {
        DataSet dsHTIBinLabels = GetUnReceivedItemData("GetGridSummary","");
        if (dsHTIBinLabels != null && dsHTIBinLabels.Tables[0].Rows.Count > 0)
        {
            if (hidSort.Value != "")
            {
                dsHTIBinLabels.Tables[0].DefaultView.Sort = hidSort.Value;
            }
            gvReport.DataSource = dsHTIBinLabels.Tables[0].DefaultView.ToTable();            
            gridPager.InitPager(gvReport, 50);
            gvReport.Visible = true;
            lblStatus.Visible = false;
        }
        else
        {
            gridPager.Visible = false;
            gvReport.Visible = false;
            lblStatus.Visible = true;
            lblStatus.Text = "No Records Found";
        }
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        gvReport.PageIndex = gridPager.GotoPageNumber;        
        BindDataGrid();
        RestoreInformationFromSession();
    }

    private void RestoreInformationFromSession()
    {
        if (Session["HTIBinLabelSelected"] != null)
        {
            DataTable dtHTIItems = Session["HTIBinLabelSelected"] as DataTable;

            if (dtHTIItems.Rows.Count > 0)
            {
                foreach (GridViewRow dgItem in gvReport.Rows)
                {
                    HiddenField _hidBinLabel = dgItem.FindControl("hidBinLabel") as HiddenField;
                    HiddenField _hidLocId = dgItem.FindControl("hidLocId") as HiddenField;

                    DataRow[] drItemFound = dtHTIItems.Select("BinLabel='" + _hidBinLabel.Value + "' and Location='" + _hidLocId.Value + "'");

                    if (drItemFound.Length > 0)
                    {
                        CheckBox _chkSelect = dgItem.FindControl("chkSelect") as CheckBox;
                        _chkSelect.Checked = true;
                    }
                }
            }
        }
    }

    protected void gvReport_Sorting(object sender, GridViewSortEventArgs e)
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

        hidSort.Value = e.SortExpression + " " + hidSort.Attributes["sortType"].ToString();
       
        BindDataGrid();

    }  

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
        DataTable dtTrendExcel = new DataTable();

        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;

        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();

        string selectedBinLabel ="";
        DataTable dtHTIItems = Session["HTIBinLabelSelected"] as DataTable;
        foreach (DataRow dr in dtHTIItems.Rows)
        {
            selectedBinLabel += "," + dr["BinLabel"].ToString() + "-" +  dr["Location"].ToString();            
        }

        if (selectedBinLabel != "")
        {
            selectedBinLabel = selectedBinLabel.Remove(0, 1);
        }
        else
        {
            ScriptManager.RegisterClientScriptBlock(ibtnExcelExport, ibtnExcelExport.GetType(), "error", "alert(\"No Bin Label's Selected to Export\");", true);
            return;
        }

        DataSet dsExcelReport = GetUnReceivedItemData("GetBinDetail", selectedBinLabel);
        if (dsExcelReport != null && dsExcelReport.Tables[0].Rows.Count > 0)
        {
            DataTable dtExcelReport = dsExcelReport.Tables[0];
            headerContent = "<table border='1' width='70%'>";
            headerContent += "<tr><th colspan='14' style='color:blue'>HTI UnReceived Products</th></tr>";           


            if (dtExcelReport.Rows.Count > 0)
            {
                headerContent += "<tr><th style='width:120px;'>Item #</th><th style='width:180px;'>Item Desc</th>" +
                                    "<th style='width:100px;'>Bin Label</th><th style='width:80px;'>Location</th>" +
                                    "<th style='width:80px;'>Quantity</th><th style='width:80px;'>Pcs Per Qty</th>" +
                                    "<th style='width:100px;'>Package Label</th>" +
                                    "<th style='width:120px;'>PFC Item #</th><th style='width:120px;'>PFC Item Desc</th>" +
                                    "<th style='width:90px;'>PFC Sell UM</th><th style='width:80px;'>PFC Qty Per</th>" +
                                    "<th style='width:100px;'>HTIBidPricePer</th><th style='width:100px;'>Entry ID</th>" +                                    
                                    "<th width='100'>Entry Dt</th> </th>";
                foreach (DataRow drHTIItems in dtExcelReport.Rows)
                {
                    excelContent += "<tr><td align='left'>" + drHTIItems["ItemNo"].ToString() + "</td><td style=\"mso-number-format:\\@;\">" +
                                drHTIItems["ItemDesc"].ToString() + "</td><td >" +
                                drHTIItems["BinLabel"].ToString() + "</td><td style=\"mso-number-format:\\@;\">" +
                                drHTIItems["Location"].ToString() + "</td><td>" +
                                drHTIItems["Quantity"].ToString() + "</td><td >" +
                                drHTIItems["PiecesPerQuantity"].ToString() + "</td><td >" +
                                drHTIItems["PackagedForLabel"].ToString() + "</td><td >" +
                                drHTIItems["PFCItemNo"].ToString() + "</td><td>" +
                                drHTIItems["PFCItemDesc"].ToString() + "</td><td align='left'>" +
                                drHTIItems["PFCSellUM"].ToString() + "</td><td>" +
                                drHTIItems["PFCQtyPer"].ToString() + "</td><td>" +
                                drHTIItems["HTIBidPricePerM"].ToString() + "</td><td>" +
                                drHTIItems["EntryID"].ToString() + "</td><td>" +
                                Convert.ToDateTime(drHTIItems["EntryDt"].ToString()).ToShortDateString() + "</td></tr>";
                }


            }
            reportWriter.WriteLine(headerContent + excelContent);
            reportWriter.Close();

            //Downloding Process
            FileStream fileStream = File.Open(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()), FileMode.Open);
            Byte[] bytBytes = new Byte[fileStream.Length];
            fileStream.Read(bytBytes, 0, (int)fileStream.Length);
            fileStream.Close();

            //  Download Process
            Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString())));
            Response.ContentType = "application/octet-stream";
            Response.BinaryWrite(bytBytes);
            Response.End();
        }

    }

    #region Delete Excel using sessionid

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("Common//ExcelUploads//"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(strSession))
                    fn.Delete();
            }

            return "";
        }
        catch (Exception ex) { return ""; }
    }

    #endregion

    #region Ajax Methods
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void StoreItemInSession(bool selected, string binLabel, string locId)
    {
        DataTable dtHTIItems = Session["HTIBinLabelSelected"] as DataTable;

        // if the itemno is already in the session remove it first
        DataRow[] drExistingItems = dtHTIItems.Select("BinLabel='" + binLabel + "' And Location='" + locId + "'");
        if (drExistingItems.Length > 0)
        {
            dtHTIItems.Rows.Remove(drExistingItems[0]);
        }

        if (selected)
        {
            DataRow _drNewItem = dtHTIItems.NewRow();
            _drNewItem["BinLabel"] = binLabel;
            _drNewItem["Location"] = locId;
            dtHTIItems.Rows.Add(_drNewItem);
        }

        // Store the value in session to retore value after paging
        Session["HTIBinLabelSelected"] = dtHTIItems;

    }
    #endregion

    #region DB Methods

    protected DataSet GetUnReceivedItemData(string operation, string filter)
    {
        DataSet dsResult = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pHTIUnreceivedItemsFrm]",
                                    new SqlParameter("@source", operation),
                                    new SqlParameter("@searchFilter", filter));
        return dsResult;
    }

    #endregion

    protected void ibtnComplete_Click(object sender, ImageClickEventArgs e)
    {
        string selectedBinLabel = "";
        DataTable dtHTIItems = Session["HTIBinLabelSelected"] as DataTable;
        foreach (DataRow dr in dtHTIItems.Rows)
        {
            selectedBinLabel += "," + dr["BinLabel"].ToString() + "-" + dr["Location"].ToString();
        }

        if (selectedBinLabel != "")
        {
            selectedBinLabel = selectedBinLabel.Remove(0, 1);
        }
        else
        {
            ScriptManager.RegisterClientScriptBlock(ibtnExcelExport, ibtnExcelExport.GetType(), "MarkAsError", "alert(\"No Bin Label's Selected.\");", true);
            return;
        }

        DataSet dsExcelReport = GetUnReceivedItemData("MarkAsComplete", selectedBinLabel);
        lblMessage.Text = "Data has been successfully updated.";
        lblMessage.ForeColor = System.Drawing.Color.Green; 
        BindDataGrid();
    }
}
