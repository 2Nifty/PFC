using System;
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
using PFC.WOE;
using PFC.WOE.BusinessLogicLayer;
using PFC.WOE.DataAccessLayer;
using PFC.WOE.SecurityLayer;

public partial class WOWorkSheet : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

    DataSet dsWorkSheet = new DataSet();
    DataTable dtWorkSheet = new DataTable();

    int PageSize = 17;
    int dgOffSet = 3;

    string PreviewURL;

    DataUtility DataUtil = new DataUtility();
    WorksheetData WSData = new WorksheetData();
    SecurityUtility SecurityUtil = new SecurityUtility();
    Common BusinessLogic = new Common();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
        {
            Ajax.Utility.RegisterTypeForAjax(typeof(WOWorkSheet));

            Session["UserName"] = ((Session["UserName"] != null) ? Session["UserName"].ToString() : "[null]");

            GetSecurity();

            DataUtil.BindListControls(ddlActionStatus, "ListDesc", "ListValue", DataUtil.GetListDetails("WOActions"), "--- ALL ---");
            DataUtil.BindListFromTables("--- ALL ---", ddlPriorityCd, "TableType='PRI' AND WOApp='Y' ORDER BY TableCd");
            DataUtil.BindLocList("--- ALL ---", ddlBranch, "AssemblyLoc='Y' ORDER BY LocID");
            DataUtil.BindWorkSheetUserList("--- ALL ---", ddlEntryID);

            DataUtil.BindListControls(lstActionStatus, "ListDesc", "ListValue", DataUtil.GetListDetails("WOActions"), "");
            DataUtil.BindListFromTables("", lstPriorityCd, "TableType='PRI' AND WOApp='Y' ORDER BY TableCd");
            DataUtil.BindLocList("", lstWOBranch, "AssemblyLoc='Y' ORDER BY LocID");

            ClearGrid();
        }
    }

    #region Filters
    protected void txtCat_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtCat.Text.ToString()))
            txtCat.Text = txtCat.Text.PadLeft(5, '0').ToString();
        smWorkSheet.SetFocus(txtSize);
    }

    protected void txtSize_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtSize.Text.ToString()))
            txtSize.Text = txtSize.Text.PadLeft(4, '0').ToString();
        smWorkSheet.SetFocus(txtVar);
    }

    protected void txtVar_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtVar.Text.ToString()))
            txtVar.Text = txtVar.Text.PadLeft(3, '0').ToString();
        smWorkSheet.SetFocus(btnSubmit);
    }

    protected void btnSubmit_Click(object sender, ImageClickEventArgs e)
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        PreviewURL = "WOWorkSheet/WOWorkSheetPreview.aspx?ActionStatus=";
        string whereClause = "WHERE ";

        if (ddlActionStatus.SelectedIndex > 0)
        {
            whereClause = whereClause + "ActionStatus = '" + ddlActionStatus.SelectedValue.ToString() + "'";
            PreviewURL = PreviewURL + ddlActionStatus.SelectedValue.ToString();
        }

        PreviewURL = PreviewURL + "&PriorityCd=";
        if (ddlPriorityCd.SelectedIndex > 0)
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "PriorityCd = '" + ddlPriorityCd.SelectedValue.ToString() + "'";
            PreviewURL = PreviewURL + ddlPriorityCd.SelectedValue.ToString();
        }

        PreviewURL = PreviewURL + "&EntryID=";
        if (ddlEntryID.SelectedIndex > 0)
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "EntryID = '" + ddlEntryID.SelectedValue.ToString() + "'";
            PreviewURL = PreviewURL + ddlEntryID.SelectedValue.ToString();
        }

        //PreviewURL = PreviewURL + "&Branch=";
        if (ddlBranch.SelectedIndex > 0)
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "WOBranch = '" + ddlBranch.SelectedValue.ToString() + "'";
            PreviewURL = PreviewURL + "&Branch=" + ddlBranch.SelectedValue.ToString() + "&BranchDesc=" + ddlBranch.SelectedItem.ToString();
        }
        else
        {
            PreviewURL = PreviewURL + "&Branch=&BranchDesc=";
        }

        PreviewURL = PreviewURL + "&Category=";
        if (!string.IsNullOrEmpty(txtCat.Text.ToString()))
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "LEFT(WOItemNo,5) = '" + txtCat.Text.ToString() + "'";
            PreviewURL = PreviewURL + txtCat.Text.ToString();
        }

        PreviewURL = PreviewURL + "&Size=";
        if (!string.IsNullOrEmpty(txtSize.Text.ToString()))
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "SUBSTRING(WOItemNo,7,4) = '" + txtSize.Text.ToString() + "'";
            PreviewURL = PreviewURL + txtSize.Text.ToString();
        }

        PreviewURL = PreviewURL + "&Variance=";
        if (!string.IsNullOrEmpty(txtVar.Text.ToString()))
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "RIGHT(WOItemNo,3) = '" + txtVar.Text.ToString() + "'";
            PreviewURL = PreviewURL + txtVar.Text.ToString();
        }

        hidPreviewURL.Value = PreviewURL;
        PrintDialogue1.PageUrl = hidPreviewURL.Value + "&SortCommand=";
        pnlExport.Update();

        dsWorkSheet = SqlHelper.ExecuteDataset(connectionString, "pWOSSetFilters", new SqlParameter("@whereClause", whereClause));
        Session["dtWS"] = dsWorkSheet.Tables[0].DefaultView.ToTable();
        hidSort.Value = "";
        hidSort.Attributes["sortType"] = "ASC";

        if (dsWorkSheet.Tables[0].Rows.Count > 0)
        {
            Pager1.GotoPageNumber = 0;
            dgWorkSheet.CurrentPageIndex = 0;
            pnlPager.Update();
            BindDataGrid();
            //DisplayStatusMessage(PrintDialogue1.PageUrl.ToString(), "fail");
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
        dtWorkSheet = (DataTable)Session["dtWS"];
        dtWorkSheet.DefaultView.Sort = (hidSort.Value == "") ? "ActionStatus ASC, WOItemNo ASC, PriorityCd ASC" : hidSort.Value;
        dgWorkSheet.DataSource = dtWorkSheet.DefaultView.ToTable();
        dgWorkSheet.AllowPaging = true;
        dgWorkSheet.DataBind();
        pnlWSGrid.Update();

        hidRowCount.Value = dtWorkSheet.Rows.Count.ToString();
        Session["dtWS"] = dtWorkSheet.DefaultView.ToTable();

        Pager1.InitPager(dgWorkSheet, PageSize);
        Pager1.Visible = true;
        pnlPager.Update();
    }

    protected void PageChanged(Object sender, System.EventArgs e)
    {
        dgWorkSheet.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void dgWorkSheet_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            string WorkSheetID = dtWorkSheet.DefaultView.ToTable().Rows[e.Item.DataSetIndex]["pWOWorkSheetID"].ToString().Trim();
            string WOItem = dtWorkSheet.DefaultView.ToTable().Rows[e.Item.DataSetIndex]["WOItemNo"].ToString().Trim();
            string WOParentItem = dtWorkSheet.DefaultView.ToTable().Rows[e.Item.DataSetIndex]["ParentItemNo"].ToString().Trim();

            //Link List Control for ActionStatus
            LinkButton _lnkActionStatusGrid = e.Item.FindControl("lnkActionStatusGrid") as LinkButton;
            if (_lnkActionStatusGrid.Text == "")
            {
                _lnkActionStatusGrid.Text = "Select";
                _lnkActionStatusGrid.Attributes.Add("style", "cursor:hand; text-decoration:underline; font-style:italic;");
                _lnkActionStatusGrid.Attributes.Add("title", "Click to select");
            }
            else
            {
                _lnkActionStatusGrid.Attributes.Add("style", "cursor:hand; text-decoration:underline;");
                _lnkActionStatusGrid.Attributes.Add("title", "Click to change");
            }
            _lnkActionStatusGrid.Attributes.Add("onclick", "return ShowGridList('" + WorkSheetID + "','ActionStatus','divActionStatusLst','" + _lnkActionStatusGrid.ClientID + "');");

            //Link List Control for PriorityCode
            LinkButton _lnkPriorityCdGrid = e.Item.FindControl("lnkPriorityCdGrid") as LinkButton;
            if (_lnkPriorityCdGrid.Text == "")
            {
                _lnkPriorityCdGrid.Text = "Select";
                _lnkPriorityCdGrid.Attributes.Add("style", "cursor:hand; text-decoration:underline; font-style:italic;");
                _lnkPriorityCdGrid.Attributes.Add("title", "Click to select");
            }
            else
            {
                _lnkPriorityCdGrid.Attributes.Add("style", "cursor:hand; text-decoration:underline;");
                _lnkPriorityCdGrid.Attributes.Add("title", "Click to change");
            }
            _lnkPriorityCdGrid.Attributes.Add("onclick", "return ShowGridList('" + WorkSheetID + "','PriorityCd','divPriorityCdLst','" + _lnkPriorityCdGrid.ClientID + "');");

            //Link Right Click Options for Finished Item No
            HyperLink _lnkFinishItemNo = e.Item.FindControl("lnkFinishItemNo") as HyperLink;
            string urlCPR = "../../IntranetSite/CPR/CPRReport.aspx?Item=" + WOItem + "&Factor=1";
            //string urlStockStatus = "../../SOE/SORecall/ProgressBar.aspx?destPage=../StockStatus.aspx?ItemNo=" + WOItem;
            string urlStockStatus = "../../SOE/StockStatus.aspx?ItemNo=" + WOItem + "&UserID=" + Session["UserID"].ToString().Trim() + "&UserName=" + Session["UserName"].ToString().Trim();
            string urlBOM = "../../SOE/StockStatus.aspx?ItemNo=" + WOItem + "&UserID=" + Session["UserID"].ToString().Trim() + "&UserName=" + Session["UserName"].ToString().Trim();
            _lnkFinishItemNo.Text = WOItem;
            _lnkFinishItemNo.Attributes.Add("title", "Right click for more options");
            _lnkFinishItemNo.Attributes.Add("style", "cursor:hand; text-decoration:underline;");
            _lnkFinishItemNo.Attributes.Add("oncontextmenu", "return false;");
            _lnkFinishItemNo.Attributes.Add("onmousedown", "ShowToolTip(event,'" + urlCPR + "','" + urlStockStatus + "','" + urlBOM + "','" + e.Item.Cells[3].ClientID.ToString() + "');");

            TextBox _txtActionQty = e.Item.FindControl("txtActionQty") as TextBox;
            _txtActionQty.Text = String.Format("{0:n0}", dtWorkSheet.DefaultView.ToTable().Rows[e.Item.DataSetIndex]["ActionQty"]);

            //Link List Control for WOBranch
            LinkButton _lnkWOBranchGrid = e.Item.FindControl("lnkWOBranchGrid") as LinkButton;
            if (_lnkWOBranchGrid.Text == "")
            {
                _lnkWOBranchGrid.Text = "Sel";
                _lnkWOBranchGrid.Attributes.Add("style", "cursor:hand; text-decoration:underline; font-style:italic;");
                _lnkWOBranchGrid.Attributes.Add("title", "Click to select");
            }
            else
            {
                _lnkWOBranchGrid.Attributes.Add("style", "cursor:hand; text-decoration:underline;");
                _lnkWOBranchGrid.Attributes.Add("title", "Click to change");
            }
            _lnkWOBranchGrid.Attributes.Add("onclick", "return ShowGridList('" + WorkSheetID + "','WOBranch','divWOBranchLst','" + _lnkWOBranchGrid.ClientID + "');");

            TextBox _txtDueDt = e.Item.FindControl("txtDueDt") as TextBox;
            _txtDueDt.Text = String.Format("{0:MM/dd/yyyy}", dtWorkSheet.DefaultView.ToTable().Rows[e.Item.DataSetIndex]["WODueDt"]);

            //Link Right Click Options for Parent Item No
            HyperLink _lnkParentItemNo = e.Item.FindControl("lnkParentItemNo") as HyperLink;
            urlCPR = "../../IntranetSite/CPR/CPRReport.aspx?Item=" + WOParentItem + "&Factor=1";
            //urlStockStatus = "../../SOE/SORecall/ProgressBar.aspx?destPage=../StockStatus.aspx?ItemNo=" + WOParentItem;
            urlStockStatus = "../../SOE/StockStatus.aspx?ItemNo=" + WOParentItem + "&UserID=" + Session["UserID"].ToString().Trim() + "&UserName=" + Session["UserName"].ToString().Trim();
            urlBOM = "../../SOE/StockStatus.aspx?ItemNo=" + WOParentItem + "&UserID=" + Session["UserID"].ToString().Trim() + "&UserName=" + Session["UserName"].ToString().Trim();
            _lnkParentItemNo.Attributes.Add("title", "Right click for more options");
            _lnkParentItemNo.Attributes.Add("style", "cursor:hand; text-decoration:underline;");
            _lnkParentItemNo.Attributes.Add("oncontextmenu", "return false;");
            _lnkParentItemNo.Attributes.Add("onmousedown", "ShowToolTip(event,'" + urlCPR + "','" + urlStockStatus + "','" + urlBOM + "','" + e.Item.Cells[10].ClientID.ToString() + "');");
        }
    }

    protected void dgWorkSheet_SortCommand(object source, DataGridSortCommandEventArgs e)
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

    #region Change Events
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public bool UpdateGridListValue(string pWOWorkSheetID, string updField, string updValue)
    {
        dtWorkSheet = (DataTable)Session["dtWS"];
        DataRow[] dr = dtWorkSheet.Select("pWOWorkSheetID=" + pWOWorkSheetID);
        WSData.UpdGridData(pWOWorkSheetID, updField, updValue);
        dr[0][updField] = updValue;
        dtWorkSheet.AcceptChanges();
        Session["dtWS"] = dtWorkSheet.DefaultView.ToTable();
        return true;
    }

    protected void txtActionQty_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        TextBox _txtActionQty = sender as TextBox;
        _txtActionQty.Text = String.Format("{0:n0}", Convert.ToInt32(_txtActionQty.Text));

        //Update the DataSet
        string rowId = _txtActionQty.ClientID.ToString().Replace("dgWorkSheet_ctl", "").Replace("_txtActionQty", "");
        dsUpdate(rowId, "ActionQty", _txtActionQty.Text);

        ////Set focus on ParentItemNo
        //DataGridItem _dgWorkSheet = _txtActionQty.Parent.Parent as DataGridItem;
        //TextBox _txtParentItemNo = _dgWorkSheet.FindControl("txtParentItemNo") as TextBox;
        //smWorkSheet.SetFocus(_txtParentItemNo);

        //Set focus on ActionQty in next record
        string nextId = Convert.ToString(Convert.ToInt32(rowId) + 1);
        if (nextId == Convert.ToString(Convert.ToInt32(hidRowCount.Value) + dgOffSet) || nextId == Convert.ToString(PageSize + dgOffSet)) nextId = dgOffSet.ToString();
        string nextCtl = "dgWorkSheet_ctl" + nextId.PadLeft(2, '0').ToString() + "_txtActionQty";
        //ScriptManager.RegisterClientScriptBlock(_txtActionQty, _txtActionQty.GetType(), "focus", "document.getElementById('" + nextCtl + "').focus();document.getElementById('" + nextCtl + "').focus();", true);
        smWorkSheet.SetFocus(nextCtl.ToString());
    }


    
    protected void txtDueDt_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        TextBox _txtDueDt = sender as TextBox;

        string rowId = _txtDueDt.ClientID.ToString().Replace("dgWorkSheet_ctl", "").Replace("_txtDueDt", "");

        if (IsDate(_txtDueDt.Text))
        {
            //Update the DataSet
            dsUpdate(rowId, "WODueDt", _txtDueDt.Text);

            //Set focus on DueDt in next record
            string nextId = Convert.ToString(Convert.ToInt32(rowId) + 1);
            if (nextId == Convert.ToString(Convert.ToInt32(hidRowCount.Value) + dgOffSet) || nextId == Convert.ToString(PageSize + dgOffSet)) nextId = dgOffSet.ToString();
            string nextCtl = "dgWorkSheet_ctl" + nextId.PadLeft(2, '0').ToString() + "_txtDueDt";
            //ScriptManager.RegisterClientScriptBlock(_txtDueDt, _txtDueDt.GetType(), "focus", "document.getElementById('" + nextCtl + "').focus();document.getElementById('" + nextCtl + "').focus();", true);
            smWorkSheet.SetFocus(nextCtl.ToString());
        }
        else
        {
            DropDownList ddlPageNo = Pager1.FindControl("ddlPages") as DropDownList;
            int updRow = ((Convert.ToInt16(ddlPageNo.SelectedItem.Text) - 1) * PageSize) + Convert.ToInt16(rowId);

            dtWorkSheet = (DataTable)Session["dtWS"];
            _txtDueDt.Text = String.Format("{0:MM/dd/yyyy}", dtWorkSheet.Rows[updRow - dgOffSet]["WODueDt"]);
            smWorkSheet.SetFocus(_txtDueDt.ClientID.ToString());

            //Update the DataSet
            dsUpdate(rowId, "WODueDt", _txtDueDt.Text);
            pnlWSGrid.Update();

            DisplayStatusMessage("Date format not valid", "fail");
        }

        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "scroll", "ScrollIt();", true);
    }

    protected void btnPFCItem_Click(object sender, EventArgs e)
    {
        //This event is fired at the end of the ZItem function
        //The postback caused by this event causes the txtParentItemNo_TextChanged event to fire
        //The txtParentItemNo_TextChanged event then handles the validation of the completed item
    }

    protected void txtParentItemNo_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        TextBox _txtParentItemNo = sender as TextBox;

        DataSet dsItemDetail = BusinessLogic.GetProductInfo(_txtParentItemNo.Text.ToString(), "000000", "01", "PFC");

        string rowId = hidItemCtl.Value.ToString().Replace("dgWorkSheet_ctl", "").Replace("_txtParentItemNo", "");
        //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "debug1", "alert('Parent " + dsItemDetail.Tables.Count.ToString() + "');", true);  

        if (dsItemDetail.Tables.Count > 1)      //Valid Item
        {
            //Update the DataSet
            dsUpdate(rowId, "ParentItemNo", _txtParentItemNo.Text.ToString());

            //Set focus on ParentItemNo in next record
            string nextId = Convert.ToString(Convert.ToInt32(rowId) + 1);
            if (nextId == Convert.ToString(Convert.ToInt32(hidRowCount.Value) + dgOffSet) || nextId == Convert.ToString(PageSize + dgOffSet)) nextId = dgOffSet.ToString();
            string nextCtl = "dgWorkSheet_ctl" + nextId.PadLeft(2, '0').ToString() + "_txtParentItemNo";
            //ScriptManager.RegisterClientScriptBlock(_txtActionQty, _txtActionQty.GetType(), "focus", "document.getElementById('" + nextCtl + "').focus();document.getElementById('" + nextCtl + "').focus();", true);
            smWorkSheet.SetFocus(nextCtl.ToString());
        }
        else                                    //Invalid Item
        {
            DropDownList ddlPageNo = Pager1.FindControl("ddlPages") as DropDownList;
            int updRow = ((Convert.ToInt16(ddlPageNo.SelectedItem.Text) - 1) * PageSize) + Convert.ToInt16(rowId);

            dtWorkSheet = (DataTable)Session["dtWS"];
            _txtParentItemNo.Text = dtWorkSheet.Rows[updRow - dgOffSet]["ParentItemNo"].ToString();
            smWorkSheet.SetFocus(hidItemCtl.Value.ToString());

            //Update the DataSet
            dsUpdate(rowId, "ParentItemNo", _txtParentItemNo.Text.ToString());
            pnlWSGrid.Update();

            DisplayStatusMessage("Item No " + hidItemNo.Value.ToString() + " not on file", "fail");
        }

    }

    protected void dsUpdate(string rowId, string rowName, string rowValue)
    {
        DropDownList ddlPageNo = Pager1.FindControl("ddlPages") as DropDownList;
        int updRow = ((Convert.ToInt16(ddlPageNo.SelectedItem.Text) - 1) * PageSize) + Convert.ToInt16(rowId);
        dtWorkSheet = (DataTable)Session["dtWS"];
        dtWorkSheet.Rows[updRow - dgOffSet][rowName.ToString()] = rowValue.ToString();
        WSData.UpdGridData(dtWorkSheet.Rows[updRow - dgOffSet]["pWOWorkSheetID"].ToString(), rowName, rowValue);

        dgWorkSheet.DataSource = dtWorkSheet.DefaultView.ToTable();
        dgWorkSheet.AllowPaging = true;
        dgWorkSheet.DataBind();
        pnlWSGrid.Update();

        Session["dtWS"] = dtWorkSheet.DefaultView.ToTable();
    }
    #endregion

    protected void btnAccept_Click(object sender, ImageClickEventArgs e)
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        string updateString = "";
        string whereClause = "";

        if (!string.IsNullOrEmpty(Session["dtWS"].ToString()))
            dtWorkSheet = (DataTable)Session["dtWS"];

        if (string.IsNullOrEmpty(Session["dtWS"].ToString()) || dtWorkSheet.Rows.Count < 1)
        {
            DisplayStatusMessage("No records to update", "fail");
        }
        else
        {
            foreach (DataRow WSRow in dtWorkSheet.Rows)
            {
                updateString =
                    //"ActionStatus = '" + WSRow["ActionStatus"].ToString() + "'," +
                    //"PriorityCd = '" + WSRow["PriorityCd"].ToString() + "'," +
                    //"ActionQty = '" + WSRow["ActionQty"].ToString() + "'," +
                    //"WOBranch = '" + WSRow["WOBranch"].ToString() + "'," +
                    //"ParentItemNo = '" + WSRow["ParentItemNo"].ToString() + "'," +
                    "AcceptActionDt = '" + DateTime.Now.ToString() + "'," +
                    "AcceptActionId = '" + Session["UserName"].ToString().Trim() + "'," +
                    "ChangeID = '" + Session["UserName"].ToString().Trim() + "'," +
                    "ChangeDt = '" + DateTime.Now.ToString() + "'";
                if ((WSRow["WODueDt"].ToString().Trim().Length != 0) && IsDate(WSRow["WODueDt"].ToString().Trim()))
                    updateString += ", WODueDt = '" + WSRow["WODueDt"].ToString() + "'";

                whereClause = "pWOWorkSheetID = '" + WSRow["pWOWorkSheetID"].ToString() + "'";

                DataUtil.UpdateTableData("WOWorkSheet", updateString, whereClause);
            }

            DisplayStatusMessage(dtWorkSheet.Rows.Count + " record(s) updated", "success");
        }

        ClearGrid();
    }

    protected void btnCancel_Click(object sender, ImageClickEventArgs e)
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        ClearGrid();
    }

    private void ClearGrid()
    {
        //ddlActionStatus.SelectedIndex = 0;
        //ddlPriorityCd.SelectedIndex = 0;
        //ddlBranch.SelectedIndex = 0;
        //txtCat.Text = "";
        //txtSize.Text = "";
        //txtVar.Text = "";
        smWorkSheet.SetFocus(ddlActionStatus);

        Session["dtWS"] = "";
        dgWorkSheet.DataSource = "";
        dgWorkSheet.AllowPaging = false;
        dgWorkSheet.DataBind();
        pnlWSGrid.Update();

        Pager1.Visible = false;
        Pager1.GotoPageNumber = 0;
        dgWorkSheet.CurrentPageIndex = 0;
        pnlPager.Update();

        PreviewURL = "WOWorkSheet/WOWorkSheetPreview.aspx?ActionStatus=&PriorityCd=&Category=&Size=&Variance=";
        hidPreviewURL.Value = PreviewURL;
        PrintDialogue1.PageUrl = hidPreviewURL.Value + "&SortCommand=";
        pnlExport.Update();
    }

    #region App Utilities
    public bool IsDate(string sdate)
    {
        DateTime dt;
        try
        {
            dt = DateTime.Parse(sdate);
        }
        catch
        {
            return false;
        }
        return true;
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

    //
    //Determine user security for this page
    //For WOWorkSheet: MRP (W); WOS (W)
    //
    private void GetSecurity()
    {
        hidSecurity.Value = SecurityUtil.GetSecurityCode(Session["UserName"].ToString(), "WOWorkSheet");
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

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void UnloadPage()
    {
        Session["dtWS"] = "";
    }
    #endregion
}