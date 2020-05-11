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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;

public partial class BackOrderReportSummary : System.Web.UI.Page
{
    Warehouse warehouse = new Warehouse();
    BackOrderReport backOrder = new BackOrderReport();
    string unAuthorizedPage = "~/Common/ErrorPage/unauthorizedpage.aspx";
    DataTable dtReport = new DataTable();
    DataTable dtExcelReport = new DataTable();
    string strLocation = "";
    string strType = "";
    string ItemNo = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(BackOrderReportSummary));

        ItemNo = Request.QueryString["ItemNo"].ToString();
        strType = Request.QueryString["Type"].ToString();
        strLocation = Request.QueryString["Location"].ToString();

        string strDeleteDt = "";

        if (!IsPostBack)
        {
            DataTable dssecurityCode = backOrder.GetSecurityCode(Session["UserName"].ToString());

            if (dssecurityCode.Rows.Count > 0)
            {
                strDeleteDt = dssecurityCode.Rows[0]["DeleteDt"].ToString();
                Session["SecurityCode"] = strDeleteDt;
                if (strDeleteDt != "")
                    Response.Redirect(unAuthorizedPage);
                else
                {
                    string strSecUserID = dssecurityCode.Rows[0]["pSecUserID"].ToString();
                    string strpSecGroupID = dssecurityCode.Rows[0]["pSecGroupID"].ToString();
                    string strpSecMembersID = dssecurityCode.Rows[0]["pSecMembersID"].ToString();
                    if (strpSecGroupID == "" && strpSecMembersID == "")
                    {
                        string AppType = "BORpts";
                        string strAppType = backOrder.GetApplicationSecurity(AppType, strSecUserID);
                        if (strAppType != "")
                            Response.Redirect(unAuthorizedPage);
                        else
                        {
                            Session["SessionID"] = Session.SessionID.ToString();
                            hidFileName.Value = "ReceiveReport" + Session["SessionID"].ToString() + ".xls";
                            BindDataGrid();
                            BindLabels();
                        }
                    }
                    else
                    {
                        Session["SessionID"] = Session.SessionID.ToString();
                        hidFileName.Value = "ReceiveReport" + Session["SessionID"].ToString() + ".xls";
                        BindDataGrid();
                        BindLabels();
                    }

                }
            }
            else
            {
                Response.Redirect(unAuthorizedPage);
            }



        }
    }

    private void BindDataGrid()
    {

        string whereClause = "";

        if (strType == "Range")
        {
            string[] strItemNoArray = ItemNo.Split(',');
            whereClause = "SODetailRel.ItemNo between '" + strItemNoArray[0].ToString().Trim() + "' and '" + strItemNoArray[1].ToString().Trim() + "' and SOHeaderRel.OrderType='BO'";
        }
        else if (strType == "Number")
        {
            whereClause = "SODetailRel.ItemNo = '" + ItemNo.ToString().Trim() + "' and SOHeaderRel.OrderType='BO'";
        }
        else
            whereClause = "1=1 and SOHeaderRel.OrderType='BO'";
        
        if (strLocation.ToLower() != "all")
        {
            if (whereClause.Trim() == "")
                whereClause += "SOHeaderRel.ShipLoc=" + strLocation;
            if (whereClause.Trim() != "")
                whereClause += " and SOHeaderRel.ShipLoc=" + strLocation;
        }

        dtReport = backOrder.GetExecutiveBranchItemSummary(whereClause);

        ViewState["WhereClause"] = whereClause;
        if (dtReport != null && dtReport.Rows.Count > 0)
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
            ClearControl();

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
        if (strType == "Range")
        {
            string[] strItemNoArray = ItemNo.Split(',');
            lblItemNo.Text = strItemNoArray[0].ToString().Trim() + " - " + strItemNoArray[1].ToString().Trim();
        }
        else
        {
            lblItemNo.Text = Request.QueryString["ItemNo"].ToString();
        }

    }

    private void ClearControl()
    {
        //lblWhse.Text = lblContainerNo.Text = lblDocumentNo.Text = "";
        //lblBOLNo.Text = lblRunDate.Text = lblRunBy.Text = "";

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

        // (DataTable)warehouse.GetLPNInformation(ViewState["WhereClause"].ToString());

        headerContent = "<table border='1' width='70%'>";
        headerContent += "<tr><th colspan='7' style='color:blue'>Executive Branch Item Sumary Report</th></tr>";
        headerContent += "<tr><th colspan='4' style='text-align: left'>Branch:" + lblBranch.Text + "</th><th colspan='3'  style='text-align: left'>Run By:" + lblRunBy.Text + "</th></tr>";
        headerContent += "<tr><th colspan='4' style='text-align: left'>Item #:" + lblItemNo.Text + "</th><th colspan='3'  style='text-align: left'>Run Date:" + lblRunDate.Text + "</th></tr>";
        headerContent += "<tr><th colspan='7' style='color:blue'></th></tr>";


            headerContent += "<tr style='font-weight:bold;'>" +
                                "<th style='width:80px;'>Item</th><th style='width:50px;'>Item Description</th>" +

                                "<th style='width:120px;'><table style='border: 1px solid black;font-weight:bold; width: 100%;'><tr style='width: 100%; text-align: center'><td style='border-bottom: 1px solid black;font-weight:bold; width: 100%; border-width: thin;' colspan='2'>Branch</td></tr><tr><td style='border-right: 1px solid black;font-weight:bold; text-align: center; border-width: thin'>Sls</td><td style='border-right: 0px solid black;font-weight:bold; text-align: center'>Ship</td></tr></table>  </th>" +
                                  "<th style='width:100px;'>Avail Qty</th>" +
                                "<th style='width:50px;'> On Water</th>" +
                                "<th style='width:100px;'>Transfer In</th>" +
                                "<th style='width:50px;'> BO Qty</th>";


            foreach (GridViewRow row in gvReport.Rows)
            {
                LinkButton lnkItemNo = (LinkButton)row.FindControl("lnkItemNo");
                Label lblItemDesc = (Label)row.FindControl("lblItemDesc");
                Label lblQty = (Label)row.FindControl("lblQty");
                Label lblOrdered = (Label)row.FindControl("lblOrdered");
                Label lblSls = (Label)row.FindControl("lblSls");
                Label lblShip = (Label)row.FindControl("lblShip");
                Label lblWater = (Label)row.FindControl("lblWater");
                Label lblTransfer = (Label)row.FindControl("lblTransfer");

                excelContent += "<tr>" +
                               "<td> " + lnkItemNo.Text + "</td>" +
                               "<td>" + lblItemDesc.Text + "</td>" +
                               "<td><table style='border: 1px solid black;width: 100%;'><tr><td style='border-right: 1px solid black;text-align: center; border-width: thin'>" + lblSls.Text + "</td><td style='text-align: center;'>" + lblShip.Text + "</td></tr></table></td>" +
                               "<td>" + lblQty.Text + "</td>" +
                               "<td>" + lblWater.Text + "</td>" +
                               "<td>" + lblTransfer.Text + "</td>" +
                               "<td> " + lblOrdered.Text + "</td>" +
                               "</tr>";
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

        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            LinkButton lnkItemNo = e.Row.FindControl("lnkItemNo") as LinkButton;
            Label lblQty = e.Row.FindControl("lblQty") as Label;
            Label lblWater = e.Row.FindControl("lblWater") as Label;
            Label lblTransfer = e.Row.FindControl("lblTransfer") as Label;
            Label lblLoc = e.Row.FindControl("lblShip") as Label;
            Label _lblOrderLoc = e.Row.FindControl("lblSls") as Label;             
       
            DataTable dtAvaiQty = backOrder.GetAvaliableQty(lnkItemNo.Text, lblLoc.Text.ToString().Trim());
            if (dtAvaiQty.Rows.Count > 0)
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

            lnkItemNo.Attributes.Add("onclick", "javascript:return openReportDetail('" + lnkItemNo.Text.ToString() + "','" + strType + "','" + lblLoc.Text.ToString() + "','" + _lblOrderLoc .Text + "');");
        }
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            if(dtReport != null)
                e.Row.Cells[7].Text = dtReport.Compute("sum(QtyOrdered)", "").ToString();
        }

        if (e.Row.RowType == DataControlRowType.Header)
        {
            if(dtReport.Rows.Count>15)
                e.Row.Cells[0].CssClass = "locked";

            e.Row.Cells[2].ColumnSpan = 2;
            e.Row.Cells[3].Visible = false;
        }
    }
}
