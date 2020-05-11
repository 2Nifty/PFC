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

public partial class BackOrderDetail : System.Web.UI.Page
{
    Warehouse warehouse = new Warehouse();
    BackOrderReport backOrder = new BackOrderReport();
    DataTable dtReport = new DataTable();
    DataTable dtExcelReport = new DataTable();
    string strLocation = "";
    string ItemNo = "";
    string strType = "";
    string orderLoc = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(BackOrderDetail));

        ItemNo = Request.QueryString["ItemNo"].ToString();
        strType = Request.QueryString["Type"].ToString();
        strLocation = Request.QueryString["Location"].ToString();
        orderLoc = Request.QueryString["OrderLoc"].ToString();
        
        if (!IsPostBack)
        {
            Session["SessionID"] = Session.SessionID.ToString();
            hidFileName.Value = "ReceiveReport" + Session["SessionID"].ToString() + ".xls";
            BindDataGrid();
            BindLabels();
        }
        //BindLabels();
    }

    private void BindDataGrid()
    {
        string whereClause = "";
        string strwhereClause = "";

        whereClause = "SODetailRel.ItemNo = '" + ItemNo.ToString().Trim() + "' and SOHeaderRel.OrderType='BO' and isnull(SOHeaderRel.OrderLoc,'')='" + orderLoc + "' ";
        if (strLocation.ToLower() != "all")
        {
            strwhereClause = "Location ='" + strLocation + "'";
            if (whereClause.Trim() == "")
                whereClause += "SOHeaderRel.ShipLoc=" + strLocation;
            if (whereClause.Trim() != "")
                whereClause += " and SOHeaderRel.ShipLoc=" + strLocation;
        }

        ViewState["WhereClause"] = whereClause;
        dtReport = backOrder.GetExecutiveBranchItemDetail(whereClause);
        if (dtReport.Rows.Count > 0)
        {
            if (hidSort.Value != "")
            {
                dtReport.DefaultView.Sort = hidSort.Value;
            }
            ViewState["dtExcel"] = dtReport;
            gvReport.DataSource = dtReport.DefaultView;
            gvReport.DataBind();
            lblStatus.Visible = false;
        }
        else
        {
            lblStatus.Visible = true;
            lblStatus.Text = "No Records Found";
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

    private void BindLabels()
    {

        lblBranch.Text = (strLocation == "All") ? "ALL" : backOrder.GetLocation(Request.QueryString["Location"].ToString());
        lblRunBy.Text = Session["UserName"].ToString();
        lblRunDate.Text = DateTime.Now.ToShortDateString();        
        lblItemNo.Text = Request.QueryString["ItemNo"].ToString();
      

    }

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
        DataTable dtTrendExcel = new DataTable();

        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;
        int totQty = 0;

        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();

        dtExcelReport = (DataTable)ViewState["dtExcel"];// (DataTable)warehouse.GetLPNInformation(ViewState["WhereClause"].ToString());

        headerContent = "<table border='1' width='70%'>";
        headerContent += "<tr><th colspan='16' style='color:blue'>Executive Branch Item Detail Report</th></tr>";
        headerContent += "<tr><th colspan='4' style='text-align: left'>Branch: " + lblBranch.Text + "</th><th colspan='4' style='text-align: left'>Item #: " + lblItemNo.Text + "</th><th colspan='3'  style='text-align: left'>Run By: " + lblRunBy.Text + "</th><th colspan='3'  style='text-align: left'>Run Date: " + lblRunDate.Text + "</th></tr>";             
        headerContent += "<tr><th colspan='16' style='color:blue'></th></tr>";


        if (gvReport.Rows.Count > 0)
        {
            headerContent += "<tr style='font-weight:bold;'><th style='width:120px;'><table style='border: 1px solid black;font-weight:bold; width: 100%;'><tr style='width: 100%; text-align: center'><td style='border-bottom: 1px solid black;font-weight:bold; width: 100%; border-width: thin;' colspan='2'>Branch</td></tr><tr><td style='border-right: 1px solid black;font-weight:bold; text-align: center; border-width: thin'>Sls</td><td style='border-right: 0px solid black;font-weight:bold; text-align: center'>Ship</td></tr></table></th><th style='width:150px;'>Cust Req't</th><th style='width:80px;'>Order Type</th>" +
                                "<th style='width:80px;'>Item</th><th style='width:50px;'>Item Description</th>" +
                                "<th style='width:120px;'><table style='border: 1px solid black;font-weight:bold; width: 100%;'><tr style='width: 100%; text-align: center'><td style='border-bottom: 1px solid black;font-weight:bold; width: 100%; border-width: thin;' colspan='2'>Sell To Customer</td></tr><tr><td style='border-right: 1px solid black;font-weight:bold; text-align: center; border-width: thin'>No</td><td style='border-right: 0px solid black;font-weight:bold; text-align: center'>Name</td></tr></table></th><th style='width:80px;'>Order No</th>" +
                                "<th style='width:50px;'> CSR</th><th style='width:100px;'>Avail Qty</th>" +
                                "<th style='width:50px;'> On Water</th><th style='width:100px;'>Transfer In</th>" +
                                "<th style='width:50px;'> BO Qty</th><th style='width:100px;'><table style='border: 1px solid black;font-weight:bold; width: 100%;'><tr style='width: 100%; text-align: center'><td style='border-bottom: 1px solid black;font-weight:bold; width: 100%; border-width: thin;' colspan='2'>Net Unit</td></tr><tr><td style='border-right: 1px solid black;font-weight:bold; text-align: center; border-width: thin'>Price</td><td style='border-right: 0px solid black;font-weight:bold; text-align: center'>Cost</td></tr></table></th>" +
                                "<th style='width:50px;'> <table style='border: 1px solid black;font-weight:bold; width: 100%;'><tr style='width: 100%; text-align: center'><td style='border-bottom: 1px solid black;font-weight:bold; width: 100%;' colspan='3'>Extended</td></tr><tr><td style='border-right: 0px solid black;font-weight:bold; text-align: center; border-width: thin'>Price</td><td style='border-right: 1px solid black;font-weight:bold; text-align: center'>Cost</td><td style='border-right: 1px solid black;font-weight:bold; text-align: center;'>Weight</td></tr></table></th><th style='width:100px;'><table style='border: 1px solid black;font-weight:bold; width: 100%;'><tr style='width: 100%; text-align: center'><td style='border-bottom: 1px solid black;font-weight:bold; width: 100%; border-width: thin;' colspan='2'>Margin %</td></tr><tr><td style='border-right: 1px solid black;font-weight:bold; text-align: center; border-width: thin'>Avg</td><td style='border-right: 0px solid black;font-weight:bold; text-align: center'>Repl</td></tr></table></th>" +
                                "<th width='100' align='center'>Sell/Lb</th>";
            foreach (GridViewRow row in gvReport.Rows)
            {
                Label lblSls = (Label)row.FindControl("lblSls");
                Label lblShip = (Label)row.FindControl("lblShip");
                Label _lblItemNo = (Label)row.FindControl("lblItemNo");
                Label lblItemDesc = (Label)row.FindControl("lblItemDesc");
                Label lblOrdered = (Label)row.FindControl("lblOrdered");

                Label lblCustReqDT = (Label)row.FindControl("lblCustReqDT");
                Label lblOrderType = (Label)row.FindControl("lblOrderType");
                Label lblsellCustNo = (Label)row.FindControl("lblsellCustNo");
                Label lblSellCustName = (Label)row.FindControl("lblSellCustName");
                Label lblOrderNo = (Label)row.FindControl("lblOrderNo");

                Label lblCSR = (Label)row.FindControl("lblCSR");
                Label llbNetPrice = (Label)row.FindControl("llbNetPrice");
                Label lnlNetCost = (Label)row.FindControl("lnlNetCost");
                Label lblExtPrice = (Label)row.FindControl("lblExtPrice");
                Label lnlExtCost = (Label)row.FindControl("lnlExtCost");



                Label lblQty = (Label)row.FindControl("lblQty");
                Label lblWater = (Label)row.FindControl("lblWater");
                Label lblTransfer = (Label)row.FindControl("lblTransfer");

                Label lblExtWght = (Label)row.FindControl("lblExtWght");
                Label lblAvg = (Label)row.FindControl("lblAvg");
                Label lblRepl = (Label)row.FindControl("lblRepl");
                Label lblSell = (Label)row.FindControl("lblSell");
                excelContent += "<tr><td align='left'><table style='border: 1px solid black;width: 100%;'><tr><td style='border-right: 1px solid black;text-align: center; border-width: thin'>" + lblSls.Text.ToString() + "</td><td>" + lblShip.Text.ToString() + "</td></tr></table></td><td>" +
                           lblCustReqDT.Text.ToString() + "</td><td >" +
                           lblOrderType.Text.ToString() + "</td><td >" +
                           _lblItemNo.Text.ToString() + "</td><td>" +
                           lblItemDesc.Text.ToString() + "</td><td ><table style='border: 1px solid black;width: 100%;'><tr><td style='border-right: 1px solid black;text-align: center; border-width: thin'>" +
                           lblsellCustNo.Text.ToString() + "</td><td>" + lblSellCustName.Text.ToString() + "</td></tr></table></td><td >" +
                           lblOrderNo.Text.ToString() + "</td><td nowrap=nowrap>" +
                           lblCSR.Text.ToString() + "</td><td>" +
                            "" + lblQty.Text.ToString() + "</td><td >" +
                            "" + lblWater.Text.ToString() + "</td><td >" +
                            "" + lblTransfer.Text.ToString() + "</td><td>" +
                            lblOrdered.Text.ToString() + "</td><td ><table style='border: 1px solid black;width: 100%;'><tr><td style='border-right: 1px solid black;text-align: center; border-width: thin'>" +
                            llbNetPrice.Text.ToString() + "</td><td>" + lnlNetCost.Text.ToString() + "</td></tr></table></td><td ><table style='border: 1px solid black;width: 100%;'><tr><td style='border-right: 1px solid black;text-align: center; border-width: thin'>" +
                            lblExtPrice.Text.ToString() + "</td><td style='border-right: 1px solid black;text-align: center; border-width: thin'>" + lnlExtCost.Text.ToString() + "</td><td style='border-right: 1px solid black;text-align: center; border-width: thin'>" + lblExtWght.Text.ToString() + "</td></tr></table></td><td><table style='border: 1px solid black;width: 100%;'><tr><td style='border-right: 1px solid black;text-align: center; border-width: thin'>" +
                            lblAvg.Text.ToString() + "</td><td>" + lblRepl.Text.ToString() + "</td></tr></table></td><td >" +
                            lblSell.Text.ToString() + "</td></tr>";

                if (lblOrdered.Text.Trim() != "")
                    totQty += Convert.ToInt32(lblOrdered.Text);
            }
        }
                
        footerContent += "<tr><th colspan='11'></th><th>"+ totQty.ToString() + "</th></tr>";

        reportWriter.WriteLine(headerContent + excelContent + footerContent);
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

    #region Delete Excel using sessionid

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\WarehouseMgmt\\Common\\ExcelUploads"));

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

    protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
    {
        string strURL = "Location=" + strLocation + "&LocName=" + lblBranch.Text;
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "PrintReport('" + strURL + "');", true);
    }

    protected void gvReport_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        e.Row.Cells[0].CssClass = "locked";
        e.Row.Cells[1].CssClass = "locked";
        e.Row.Cells[2].CssClass = "locked";
        e.Row.Cells[3].CssClass = "locked";
        e.Row.Cells[4].CssClass = "locked";

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            Label lblQty = e.Row.FindControl("lblQty") as Label;
            Label lblWater = e.Row.FindControl("lblWater") as Label;
            Label lblTransfer = e.Row.FindControl("lblTransfer") as Label;

            //Label lblAvg = e.Row.FindControl("lblAvg") as Label;
            //Label lblRepl = e.Row.FindControl("lblRepl") as Label;
            Label lblSell = e.Row.FindControl("lblSell") as Label;

            Label llbNetPrice = e.Row.FindControl("llbNetPrice") as Label;
            Label lnlNetCost = e.Row.FindControl("lnlNetCost") as Label;
            Label lblExtPrice = e.Row.FindControl("lblExtPrice") as Label;
            Label lnlExtCost = e.Row.FindControl("lnlExtCost") as Label;
            Label lblExtWght = e.Row.FindControl("lblExtWght") as Label;
            Label lblCustReqDT = e.Row.FindControl("lblCustReqDT") as Label;
            lblCustReqDT.Text = (lblCustReqDT.Text.ToString() != "") ? Convert.ToDateTime(lblCustReqDT.Text.ToString()).ToShortDateString() : "";
                
            string  strwhereClause = "Location ='" + strLocation + "'";            
            DataTable dtAvaiQty = backOrder.GetAvaliableQty(ItemNo.ToString().Trim(), Request.QueryString["Location"].ToString().Trim());
            if (dtAvaiQty != null && dtAvaiQty.Rows.Count > 0)
            {
                lblQty.Text = dtAvaiQty.Rows[0]["AvlQty"].ToString();
                lblWater.Text = dtAvaiQty.Rows[0]["OTWQty"].ToString();
                lblTransfer.Text = dtAvaiQty.Rows[0]["TIQty"].ToString();
            }
            else
            {
                lblQty.Text = "0";
                lblWater.Text = "0";
                lblTransfer.Text = "0";  
            }
            decimal decNetPrice = (llbNetPrice.Text.ToString() != "") ? Convert.ToDecimal(llbNetPrice.Text.ToString()) : 0;
            decimal decNetCost = (lnlNetCost.Text.ToString() != "") ? Convert.ToDecimal(lnlNetCost.Text.ToString()) : 0;
            decimal decExtPrice = (lblExtPrice.Text.ToString() != "") ? Convert.ToDecimal(lblExtPrice.Text.ToString()) : 0;
            decimal decExtCost = (lnlExtCost.Text.ToString() != "") ? Convert.ToDecimal(lnlExtCost.Text.ToString()) : 0;
            decimal decExtWght = (lblExtWght.Text.ToString() != "") ? Convert.ToDecimal(lblExtWght.Text.ToString()) : 0;
            llbNetPrice.Text = "$" + Math.Round(decNetPrice, 2).ToString();
            lnlNetCost.Text = "$" + Math.Round(decNetCost, 2).ToString();
            lblExtPrice.Text = "$" + Math.Round(decExtPrice, 2).ToString();
            lnlExtCost.Text = "$" + Math.Round(decExtCost, 2).ToString();
            lblExtWght.Text = Math.Round(decExtWght, 2).ToString();
            decimal decSell = decNetPrice / decExtWght;
            lblSell.Text = "$" + Math.Round(decSell, 2).ToString();
               
        }

        if (e.Row.RowType == DataControlRowType.Header)
        {
            e.Row.Cells[0].ColumnSpan = 2;
            e.Row.Cells[1].Visible = false;

            e.Row.Cells[6].ColumnSpan = 2;
            e.Row.Cells[7].Visible = false;

            e.Row.Cells[14].ColumnSpan = 2;
            e.Row.Cells[15].Visible = false;

            e.Row.Cells[16].ColumnSpan = 3;
            e.Row.Cells[17].Visible = false;
            e.Row.Cells[18].Visible = false;

            e.Row.Cells[19].ColumnSpan = 2;
            e.Row.Cells[20].Visible = false;
        }

        if (e.Row.RowType == DataControlRowType.Footer)
        {
            if(dtReport != null) 
            {
                e.Row.Cells[13].Text = dtReport.Compute("Sum(QtyOrdered)", "").ToString();
            }
        }

    }
    
}
