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
using PFC.WOE;
using PFC.WOE.BusinessLogicLayer;
using PFC.WOE.DataAccessLayer;
using PFC.WOE.SecurityLayer;

public partial class WOFind : System.Web.UI.Page
{
    SqlConnection cnERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);

    Common BusinessLogic = new Common();
    DataUtility DataUtil = new DataUtility();
    SecurityUtility SecurityUtil = new SecurityUtility();

    DataSet dsWorkOrders = new DataSet();
    DataTable dtWorkOrders = new DataTable();
    DataTable dtEmpty = new DataTable();

    int PageSize = 14;
    string PreviewURL;

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(WOFind));

        if (!IsPostBack)
        {
            GetSecurity();
            
            dgFind.PageSize = PageSize;

            ViewState["MaxRowCount"] = BusinessLogic.GetSQLWarningRowCount();
            //ViewState["MaxRowCount"] = "9999";

            BindFindControls();
            ClearFindControls();

            dtStartDt.SelectedDate = DateTime.Now.AddDays(-7).ToShortDateString();
            dtEndDt.SelectedDate = DateTime.Now.ToShortDateString();

            dtEmpty.Clear();
            dgFind.DataSource = dtEmpty.DefaultView.ToTable();
            dgFind.DataBind();
            Pager1.InitPager(dgFind, PageSize);
        }
    }

    #region FindControls
    public void BindFindControls()
    {
        DataUtil.BindListControls(ddlUserId, "Name", "Code", DataUtil.GetUsers(), "All");
        DataUtil.SetListControlValue(ddlUserId, Session["UserName"].ToString());
        DataUtil.BindListControls(ddlWOType, "ListDesc", "ListValue", DataUtil.GetListDetails("WOOrderType"), "All");
        DataUtil.BindLocList("All", ddlMfgLoc, "AssemblyLoc='Y' ORDER BY LocID");
        DataUtil.BindListControls(ddlStatusDesc, "ListDesc", "ListValue", DataUtil.GetListDetails("WOFindOrderStat"), "All");
        DataUtil.BindListControls(ddlPrinted, "ListDesc", "ListValue", DataUtil.GetListDetails("WOPrinted"), "All");
        DataUtil.BindListControls(ddlRouting, "Name", "Code", DataUtil.GetRoutes(), "All");
    }

    public void ClearFindControls()
    {
        DataUtil.SetListControlValue(ddlUserId, Session["UserName"].ToString());
        ddlWOType.SelectedIndex = 0;
        ddlMfgLoc.SelectedIndex = 0;
        ddlStatusDesc.SelectedIndex = 0;
        dtStartDt.SelectedDate = DateTime.Now.AddDays(-7).ToShortDateString();
        dtEndDt.SelectedDate = DateTime.Now.ToShortDateString(); 
    }

    protected void ibtnFind_Click(object sender, ImageClickEventArgs e)
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        dsWorkOrders = GetWorkOrders();
        Session["dtWorkOrders"] = dsWorkOrders.Tables[0].DefaultView.ToTable();

        dgFind.CurrentPageIndex = 0;
        Pager1.GotoPageNumber = 0;
        BindDataGrid();
    }
    #endregion

    #region DataGrid
    public DataSet GetWorkOrders()
    {
        string _UserId, _WOType, _MfgLoc, _StatusDesc, _StartDt, _EndDt, _Printed, _Routing;

        if (!string.IsNullOrEmpty(ddlUserId.SelectedValue.ToString()) && ddlUserId.SelectedIndex != 0)
            _UserId = ddlUserId.SelectedValue.ToString().Trim();
        else
            _UserId = "";

        if (!string.IsNullOrEmpty(ddlWOType.SelectedValue.ToString()) && ddlWOType.SelectedIndex != 0)
            _WOType = ddlWOType.SelectedValue.ToString().Trim();
        else
            _WOType = "";

        if (!string.IsNullOrEmpty(ddlMfgLoc.SelectedValue.ToString()) && ddlMfgLoc.SelectedIndex != 0)
            _MfgLoc = ddlMfgLoc.SelectedValue.ToString().Trim();
        else
            _MfgLoc = "";

        if (!string.IsNullOrEmpty(ddlStatusDesc.SelectedValue.ToString()) && ddlStatusDesc.SelectedIndex != 0)
            _StatusDesc = ddlStatusDesc.SelectedValue.ToString().Trim();
        else
            _StatusDesc = "";

        if (string.IsNullOrEmpty(dtStartDt.SelectedDate.ToString()))
            dtStartDt.SelectedDate = DateTime.Now.AddDays(-7).ToShortDateString();
        _StartDt = dtStartDt.SelectedDate.ToString().Trim();

        if (string.IsNullOrEmpty(dtEndDt.SelectedDate.ToString()))
            dtEndDt.SelectedDate = DateTime.Now.ToShortDateString();
        _EndDt = dtEndDt.SelectedDate.ToString().Trim();

        if (!string.IsNullOrEmpty(ddlPrinted.SelectedValue.ToString()) && ddlPrinted.SelectedIndex != 0)
            _Printed = ddlPrinted.SelectedValue.ToString().Trim();
        else
            _Printed = "All";

        if (!string.IsNullOrEmpty(ddlRouting.SelectedValue.ToString()) && ddlRouting.SelectedIndex != 0)
            _Routing = ddlRouting.SelectedValue.ToString().Trim();
        else
            _Routing = "All";

        PreviewURL = "WOFindPreview.aspx?UserId=" + _UserId + "&WOType=" + _WOType + "&MfgLoc=" + _MfgLoc + "&StatusDesc="
            + _StatusDesc + "&StartDt=" + _StartDt + "&EndDt=" + _EndDt + "&Printed=" + _Printed + "&Routing=" + _Routing;

        PrintDialogue1.PageUrl = PreviewURL;
        Session["PrintWordOrderNo"] = null;
        pnlExport.Update();

        try
        {
            DataSet dsResult = SqlHelper.ExecuteDataset(cnERP, "pWOFind",
                                                new SqlParameter("@UserId", _UserId),
                                                new SqlParameter("@WOType", _WOType),
                                                new SqlParameter("@MfgLoc", _MfgLoc),
                                                new SqlParameter("@StatusDesc", _StatusDesc),
                                                new SqlParameter("@StartDt", _StartDt),
                                                new SqlParameter("@EndDt", _EndDt),
                                                new SqlParameter("@Printed", _Printed),
                                                new SqlParameter("@Routing", _Routing));
            return dsResult;
        }
        catch (Exception ex)
        {
            DisplaStatusMessage(ex.ToString(), "fail");
            return null;
        }
    }

    public void BindDataGrid()
    {
        dtWorkOrders = (DataTable)Session["dtWorkOrders"];
        
        if (dtWorkOrders != null && dtWorkOrders.DefaultView.ToTable().Rows.Count > 0)
        {
            int allowedRowCount = Convert.ToInt32(ViewState["MaxRowCount"].ToString());
            if (dtWorkOrders.DefaultView.ToTable().Rows.Count < allowedRowCount)
            {
                //WorkOrders Found
                String sortExpression = (hidSort.Value == "") ? " POOrderNo ASC" : hidSort.Value;
                dtWorkOrders.DefaultView.Sort = sortExpression;
                dgFind.DataSource = dtWorkOrders.DefaultView.ToTable();
            }
            else
            {
                //Too Many WorkOrders Found
                dgFind.DataSource = dtEmpty.DefaultView.ToTable();
                DisplaStatusMessage("Maximum rows exceeded for this search. Please enter additional data.", "fail");
            }
        }
        else
        {
            if (dtWorkOrders.DefaultView.ToTable().Rows.Count == 0)
            {
                //No WorkOrders Found
                dgFind.DataSource = dtEmpty.DefaultView.ToTable();
                DisplaStatusMessage("No Work Orders Found", "fail");
            }
        }

        dgFind.DataBind();
        Pager1.InitPager(dgFind, PageSize);
        
        pnlWOGrid.Update();
        pnlStatus.Update();
    }

    protected void dgFind_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            ////Test data for column formatting
            //e.Item.Cells[0].Text = "WO999999 xxx";
            //e.Item.Cells[1].Text = "WO Type xxx";
            //e.Item.Cells[2].Text = "99 99";
            //e.Item.Cells[3].Text = "12345-1234-123";
            //e.Item.Cells[4].Text = "50 character ItemDesc 2456789 123456789 1234567890";
            //e.Item.Cells[5].Text = "99 999 999";
            //e.Item.Cells[6].Text = "BX CS";
            //e.Item.Cells[7].Text = "12345 7890";
            //e.Item.Cells[8].Text = "20 character EntryID";

            //Link OrderNo to WOE
            LinkButton _lnkOrderNo = e.Item.FindControl("lnkOrderNo") as LinkButton;
            if (_lnkOrderNo.Text != "")
            {
                _lnkOrderNo.Attributes.Add("style", "cursor:hand; text-decoration:underline;");
                _lnkOrderNo.Attributes.Add("title", "Work Order Entry");
                _lnkOrderNo.Attributes.Add("onclick", "return OpenWO('" + _lnkOrderNo.Text + "');");
            }

            //Link SORefNo to SO Recall
            LinkButton _lnkRefNo = e.Item.FindControl("lnkRefNo") as LinkButton;
            if (_lnkRefNo.Text != "")
            {
                _lnkRefNo.Attributes.Add("style", "cursor:hand; text-decoration:underline;");
                _lnkRefNo.Attributes.Add("title", "Sales Order Recall");
                _lnkRefNo.Attributes.Add("onclick", "return OpenSO('" + _lnkRefNo.Text + "');");
            }

            //Handle MassPrint checkbox
            CheckBox _chkPrint = e.Item.FindControl("chkPrint") as CheckBox;
            HiddenField _hidMassPrint = e.Item.FindControl("hidMassPrint") as HiddenField;
            if (_hidMassPrint.Value == "1")
            {
                _chkPrint.Checked = true;
            }
        }
    }

    protected void dgFind_SortCommand(object source, DataGridSortCommandEventArgs e)
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

        dtWorkOrders = (DataTable)Session["dtWorkOrders"];
        BindDataGrid();
    }

    protected void Pager1_PageChanged(Object sender, System.EventArgs e)
    {
        dgFind.CurrentPageIndex = Pager1.GotoPageNumber;
        dtWorkOrders = (DataTable)Session["dtWorkOrders"];
        BindDataGrid();
    }
    #endregion

    #region Export
    protected void btnExport_Click(object sender, ImageClickEventArgs e)
    {
        String xlsFile = "WOFind" + Session["UserID"] + ".xls";
        String ExportFile = Server.MapPath("Common//ExcelUploads//") + xlsFile;
        FileInfo fnExcel = new FileInfo(ExportFile);
        StreamWriter reportWriter = fnExcel.CreateText();

        string headerContent = string.Empty;
        string excelContent = string.Empty;

        dtWorkOrders = (DataTable)Session["dtWorkOrders"];
        BindDataGrid();

        if (dtWorkOrders != null && dtWorkOrders.DefaultView.ToTable().Rows.Count > 0)
        {
            //Headers
            headerContent =  "<table border='1' width='100%'>";
            headerContent += "<tr><th colspan='13' style='color:blue; border-bottom:2' align=left>" +
                             "<center>Run Date: " + DateTime.Now.ToShortDateString() +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "<b>Work Order Find - Excel Export</b>" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;" +
                             "Run By: " + Session["UserName"].ToString() + "</center></th></tr>";

            headerContent += "<tr><td colspan='13'><center><b>User Id: ";
            headerContent += (ddlUserId.SelectedItem.ToString() == "") ? "All" : ddlUserId.SelectedItem.ToString();
            headerContent += "</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            headerContent += "<b>WO Type: ";
            headerContent += (ddlWOType.SelectedValue.ToString() == "") ? "All" : ddlWOType.SelectedValue.ToString();
            headerContent += "</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            headerContent += "<b>Mfg Loc: ";
            headerContent += (ddlMfgLoc.SelectedValue.ToString() == "") ? "All" : ddlMfgLoc.SelectedValue.ToString();
            headerContent += "</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            headerContent += "<b>Status Desc: ";
            headerContent += (ddlStatusDesc.SelectedItem.ToString() == "") ? "All" : ddlStatusDesc.SelectedItem.ToString();
            headerContent += "</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            headerContent += "<b>Routing: ";
            headerContent += (ddlRouting.SelectedItem.ToString() == "") ? "All" : ddlRouting.SelectedItem.ToString();
            headerContent += "</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            headerContent += "<b>Begin Date: ";
            headerContent += dtStartDt.SelectedDate.ToString();
            headerContent += "</b>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;";
            headerContent += "<b>End Date: ";
            headerContent += dtEndDt.SelectedDate.ToString();
            headerContent += "</b></center></td></tr><tr><th colspan='12'></th></tr>";

            headerContent += "<tr><th nowrap><center>Order No</center></th>" +
                                 "<th nowrap><center>PO Type</center></th>" +
                                 "<th nowrap><center>Loc</center></th>" +
                                 "<th nowrap><center>Item No</center></th>" +
                                 "<th nowrap><center>Item Desc</center></th>" +
                                 "<th nowrap><center>Mfg Qty</center></th>" +
                                 "<th nowrap><center>UM</center></th>" +
                                 "<th nowrap><center>SO Ref No</center></th>" +
                                 "<th nowrap><center>User Id</center></th>" +
                                 "<th nowrap><center>Order Dt</center></th>" +
                                 "<th nowrap><center>Pick Sheet Dt</center></th>" +
                                 "<th nowrap><center>Due Dt</center></th>" +
                                 "<th nowrap><center>Routing</center></th></tr>";
            reportWriter.Write(headerContent);

            //Detail
            if (dtWorkOrders.DefaultView.ToTable().Rows.Count > 0)
            {
                foreach (DataRow dr in dtWorkOrders.DefaultView.ToTable().Rows)
                {
                    excelContent += "<tr><td nowrap align='center'>" +
                                        dr["POOrderNo"].ToString() + "</td><td nowrap align='center'>" +
                                        dr["POType"].ToString() + "</td><td nowrap align='center'>" +
                                        dr["LocationCd"].ToString() + "</td><td nowrap align='center'>" +
                                        dr["ItemNo"].ToString() + "</td><td nowrap align='left'>" +
                                        dr["ItemDesc"].ToString() + "</td><td nowrap align='right'>" +
                                        string.Format("{0:#,##0}", dr["QtyOrdered"]) + "</td><td nowrap align='center'>" +
                                        dr["BaseQtyUM"].ToString() + "</td><td nowrap align='center'>" +
                                        dr["SORefNo"].ToString() + "</td><td nowrap align='center'>" +
                                        dr["UserId"].ToString() + "</td><td nowrap align='center'>" +
                                        string.Format("{0:MM/dd/yyyy}", dr["OrderDt"]) + "</td><td nowrap align='center'>" +
                                        string.Format("{0:MM/dd/yyyy}", dr["PickSheetDt"]) + "</td><td nowrap align='center'>" +
                                        string.Format("{0:MM/dd/yyyy}", dr["RequestedReceiptDt"]) + "</td><td nowrap align='center'>" +
                                        dr["RoutingNo"].ToString() + "</td></tr>";
                }

                reportWriter.Write(excelContent);
            }

            reportWriter.Close();

            //Downloding Process
            FileStream fileStream = File.Open(ExportFile, FileMode.Open);
            Byte[] bytBytes = new Byte[fileStream.Length];
            fileStream.Read(bytBytes, 0, (int)fileStream.Length);
            fileStream.Close();

            Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(ExportFile));
            Response.ContentType = "application/octet-stream";
            Response.BinaryWrite(bytBytes);
            Response.End();
        }
    }

    [Ajax.AjaxMethod()]
    public void DeleteExcel(string strUserId)
    {
        try
        {
            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..//Common//ExcelUploads//"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(strUserId))
                    fn.Delete();
            }
        }
        catch (Exception ex) { }
    }
    #endregion

    protected void ibtnCancel_Click(object sender, ImageClickEventArgs e)
    {
        lblMessage.Text = "";
        pnlStatus.Update();
        ClearFindControls();
        dgFind.DataSource = dtEmpty.DefaultView.ToTable();
        dgFind.DataBind();
        Pager1.InitPager(dgFind, PageSize);
        pnlWOGrid.Update();
    }

    private void DisplaStatusMessage(string message, string messageType)
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

    #region Security
    //
    //Determine user security for this page
    //For WOFind: WOS (W); MRP (W); MAINTENANCE (W)
    //
    private void GetSecurity()
    {
        hidSecurity.Value = SecurityUtil.GetSecurityCode(Session["UserName"].ToString(), "WOFind");
        if (hidSecurity.Value.ToString() == "")
            hidSecurity.Value = "Query";
        else
            hidSecurity.Value = "Full";

        //
        //If the page does not allow 'Query' only, change to 'None'
        //
        if (hidSecurity.Value.ToString() == "Query")
            hidSecurity.Value = "None";


        //Hard code the security value(s) until specific security is implemented
        //Toggle between Query, Full and None
        //hidSecurity.Value = "Query";
        //hidSecurity.Value = "Full";
        //hidSecurity.Value = "None";


        switch (hidSecurity.Value.ToString())
        {
            case "None":
                Response.Redirect("~/Common/ErrorPage/unauthorizedpage.aspx", true);
                break;
            case "Full":
                break;
        }
    }
    #endregion

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string UpdMassprint(string WONo, string MassPrint)
    {
        string status = WONo;
        try
        {
            // we update the detail table with the new margin. 
            DataTable tempDt = (DataTable)Session["dtWorkOrders"];
            DataRow[] QuoteRow = tempDt.Select("POOrderNo = '" + WONo + "'");
            if (Session["PrintWordOrderNo"] != null)
            {
                Session["PrintWordOrderNo"] = Session["PrintWordOrderNo"].ToString().Replace("," + WONo, "");
            }
            if (MassPrint.ToUpper() == "TRUE")
            {
                QuoteRow[0]["MassPrint"] = 1;
                Session["PrintWordOrderNo"] += "," + WONo;
            }
            else
            {
                QuoteRow[0]["MassPrint"] = 0;
            }
            status += " set to " + MassPrint;
            Session["dtWorkOrders"] = tempDt;
            return status;
        }
        catch (Exception e2)
        {
            return "!!" + e2.ToString();
        }
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string GetMassprint()
    {
        string status = "";
        try
        {
            // give back the lines that are checked for printing. 
            DataTable tempDt = (DataTable)Session["dtWorkOrders"];
            DataRow[] PrintRows = tempDt.Select("MassPrint = 1");
            foreach (DataRow dr in PrintRows)
            {
                if (status != "")
                {
                    status += ",";
                }
                status += dr["POOrderNo"].ToString();
            }
            if (status == "")
            {
                status = "NoRecs";
            }
            return status;
        }
        catch (Exception e2)
        {
            return "!!" + e2.ToString();
        }
    }

    [Ajax.AjaxMethod()]
    public void UnloadPage()
    {
        Session["dtWorkOrders"] = null;
    }
}
