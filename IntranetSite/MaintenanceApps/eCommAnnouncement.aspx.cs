using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Web.UI.Design;
using System.Data.SqlClient;
using System.IO;

using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;

public partial class eCommerceAnnouncementPage : System.Web.UI.Page
{
    MaintenanceUtility maintenanceUtils = new MaintenanceUtility();
    PFC.Intranet.MaintenanceApps.eCommerceAnnouncement ecommerceAnnouncement = new PFC.Intranet.MaintenanceApps.eCommerceAnnouncement();
    DataTable dteCommData = new DataTable();
    GridView dv = new GridView();

    string updateMessage = "Data has been successfully updated";
    string deleteMessage = "Data has been successfully deleted";
    string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
    string searchWhereClause = "";

    int pageSize = 50;
    string excelFilePath = "../Common/ExcelUploads/";

    protected string CountrySecurity
    {
        get
        {
            return Session["CountrySecurity"].ToString();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

        try
        {
            ViewState["Operation"] = "";
            lblMessage.Text = "";            

            if (!Page.IsPostBack)
            {
                Session["CountrySecurity"] = null;
                lnkCode.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");
                Session["CountrySecurity"] = maintenanceUtils.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.CVCAdder);
               
                ViewState["Mode"] = "Add";

                // Fill Data Entry Drop Down
                BindLocationDropDowns();
                BindDropDown(ddlMsgType, "eCommAppType");
                BindDropDown(ddlCustType, "CustType");
                BindDropDown(ddlFormType, "eComOrderType");
                                             
                BindDataGrid();                
            }

            if (CountrySecurity == "")
                EnableQueryMode();
        }
        catch (Exception ex)
        {
            DisplaStatusMessage(ex.Message, "Fail");
        }

    }

    protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
        //BindDataGrid();
        Clear();
        ViewState["Mode"] = "Add";
        //DataSet dsResult = cvcAdder.GetCVCAdderTableData("getnextsat", "");
        //dpEffectiveDt.SelectedDate = Convert.ToDateTime(dsResult.Tables[0].Rows[0]["DefaultDate"].ToString()).ToShortDateString();
        btnSave.Visible = true;
        btnCancel.Visible = true;
        UpdatePanels();        
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        if (ViewState["Mode"].ToString() == "Add")
        {
            //if (ecommerceAnnouncement.CheckDataExist(ddlLocation.SelectedValue, dpStartDt.SelectedDate, dpEndDt.SelectedDate,""))
            //{
                string columnName = "Location,CustomerType,MessageType,FormType,FormMessage,DisplayMessage,StartDt,EndDt,EntryID,EntryDt";

                string columnValue = "'" + ddlLocation.SelectedItem.Value + "'," +
                                     "'" + ddlCustType.SelectedItem.Value + "'," +
                                     "'" + ddlMsgType.SelectedItem.Value + "'," +
                                     "'" + ddlFormType.Text + "'," +
                                     "'" + txtTitle.Text.Replace("'","''") + "'," +
                                     "'" + txtMessage.Text.Replace("'", "''") + "'," +                                     
                                     "'" + dpStartDt.SelectedDate + "'," +
                                     "'" + dpEndDt.SelectedDate + "'," +
                                     "'" + Session["UserName"] + "'," +
                                     "'" + DateTime.Now.ToShortDateString() + "'";

                ecommerceAnnouncement.InsertTables(columnName, columnValue);
                DisplaStatusMessage(updateMessage, "Success");
                btnSave.Visible = false;                
                btnCancel.Visible = false;
            //}
            //else
            //{
            //    DisplaStatusMessage("Announcement already exists for this date range", "Fail");
            //    upnlGrid.Update();
            //    pnlProgress.Update();
            //    return;
            //}
        }
        else
        {
            //if (ecommerceAnnouncement.CheckDataExist(ddlLocation.SelectedValue, dpStartDt.SelectedDate, dpEndDt.SelectedDate, hidPrimaryKey.Value))
            //{

                string updateValue = "Location='" + ddlLocation.SelectedItem.Value + "'," +
                                     "CustomerType='" + ddlCustType.SelectedItem.Value + "'," +
                                     "MessageType='" + ddlMsgType.SelectedItem.Value + "'," +
                                     "FormType='" + ddlFormType.SelectedItem.Value + "'," +
                                     "FormMessage='" + txtTitle.Text.Replace("'", "''") + "'," +
                                     "DisplayMessage='" + txtMessage.Text.Replace("'", "''") + "'," +
                                     "StartDt='" + dpStartDt.SelectedDate + "'," +
                                     "EndDt='" + dpEndDt.SelectedDate + "'," +
                                     "ChangeID='" + Session["UserName"].ToString() + "'," +
                                     "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";

                ecommerceAnnouncement.UpdateTables(updateValue, "pHolidayMessageID=" + hidPrimaryKey.Value.Trim());

                DisplaStatusMessage(updateMessage, "Success");
                btnSave.Visible = false;                
                btnCancel.Visible = false;
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
            //}
            //else
            //{
            //    DisplaStatusMessage("Announcement already exists for this date range", "Fail");
            //    upnlGrid.Update();
            //    pnlProgress.Update();
            //    return;
            //}
        }

        ViewState["Operation"] = "Save";
        Clear();
        BindDataGrid();
        UpdatePanels();
    }

    protected void btnSearch_Click(object sender, ImageClickEventArgs e)
    {
        btnSave.Visible = false;        
        btnCancel.Visible = false;
        ViewState["Mode"] = "Add";
        
        // Bind Where Clause 
        if (ddlLocationSearch.SelectedValue != "")
            searchWhereClause = "Location='" + ddlLocationSearch.SelectedValue + "' and";

        if (ddlSearchType.SelectedValue != "")
        {
            if(ddlSearchType.SelectedValue == "MessageType")
                searchWhereClause += " MsgTypeDesc like '%" + txtFindText.Text + "%' and";
            else if (ddlSearchType.SelectedValue == "CustomerType")
                searchWhereClause += " CustTypeDesc like '%" + txtFindText.Text + "%' and";
            else if (ddlSearchType.SelectedValue == "FormType")
                searchWhereClause += " FormTypeDesc like '%" + txtFindText.Text + "%' and";
            else if (ddlSearchType.SelectedValue == "FormMessage")
                searchWhereClause += " FormMessage like '%" + txtFindText.Text + "%' and";
            else if (ddlSearchType.SelectedValue == "DisplayMessage")
                searchWhereClause += " DisplayMessage like '%" + txtFindText.Text + "%' and";
        }

        if (searchWhereClause != "")
            searchWhereClause = searchWhereClause.Remove(searchWhereClause.Length - 3, 3);

        BindDataGrid();
        UpdatePanels();
    }

    protected void dgeCommAnnounce_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            DataSet dsResult = ecommerceAnnouncement.GeteCommAnnouncementData("getsingleannouncement", e.CommandArgument.ToString());
            dteCommData = dsResult.Tables[0];
            DisplayRecord();

            btnSave.Visible = (CountrySecurity != "") ? true : false;
            btnCancel.Visible = true;
        }
        if (e.CommandName == "Delete")
        {
            ViewState["Operation"] = "Delete";
            ecommerceAnnouncement.DeleteTablesData(e.CommandArgument.ToString());
            BindDataGrid();
            DisplaStatusMessage(deleteMessage, "Success");
            Clear();
        }

        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
        UpdatePanels();        
    }

    protected void dgeCommAnnounce_SortCommand(object source, DataGridSortCommandEventArgs e)
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

    protected void dgeCommAnnounce_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if ((e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item))
        {
            LinkButton lnkDelete = e.Item.FindControl("lnlDelete") as LinkButton;
            LinkButton lnkEdit = e.Item.FindControl("lnlEdit") as LinkButton;

            //if (e.Item.Cells[19].Text != "&nbsp;" || CountrySecurity == "")
            //{
            //    lnkDelete.Visible = false;

            //    if (e.Item.Cells[19].Text != "&nbsp;")
            //        lnkEdit.Visible = false;
            //}

        }
    }

    private void DisplayRecord()
    {
        ViewState["Mode"] = "Edit";

        hidPrimaryKey.Value = dteCommData.Rows[0]["pHolidayMessageID"].ToString().Trim();
        HighLightDropDown(ddlCustType, dteCommData.Rows[0]["CustomerType"].ToString().Trim());
        HighLightDropDown(ddlFormType, dteCommData.Rows[0]["FormType"].ToString().Trim());
        HighLightDropDown(ddlLocation, dteCommData.Rows[0]["Location"].ToString().Trim());
        HighLightDropDown(ddlMsgType, dteCommData.Rows[0]["MessageType"].ToString().Trim());        
        dpStartDt.SelectedDate = Convert.ToDateTime(dteCommData.Rows[0]["StartDt"].ToString().Trim()).ToShortDateString();
        dpEndDt.SelectedDate = Convert.ToDateTime(dteCommData.Rows[0]["EndDt"].ToString().Trim()).ToShortDateString();

        txtTitle.Text = dteCommData.Rows[0]["FormMessage"].ToString().Trim();
        txtMessage.Text = dteCommData.Rows[0]["DisplayMessage"].ToString().Trim();

        lblEntryID.Text = dteCommData.Rows[0]["EntryID"].ToString().Trim();
        lblChangeID.Text = dteCommData.Rows[0]["ChangeID"].ToString().Trim();
        lblChangeDate.Text = (dteCommData.Rows[0]["ChangeDt"].ToString() == "") ? "" : Convert.ToDateTime(dteCommData.Rows[0]["ChangeDt"].ToString()).ToShortDateString();
        lblEntryDate.Text = (dteCommData.Rows[0]["EntryDt"].ToString() == "") ? "" : Convert.ToDateTime(dteCommData.Rows[0]["EntryDt"].ToString()).ToShortDateString();
       
    }

    private void BindDataGrid()
    {
        Clear();
        DataSet dsResult;
        dsResult = ecommerceAnnouncement.GeteCommAnnouncementData("loadgrid", "");
        bool isRecordFound = true;

        if (dsResult != null && dsResult.Tables[0].Rows.Count > 0)
        {
            if (searchWhereClause != "")
                dsResult.Tables[0].DefaultView.RowFilter = searchWhereClause;                
            
            if (hidSort.Value != "")
                dsResult.Tables[0].DefaultView.Sort = hidSort.Value;

            dgeCommAnnounce.PageSize = pageSize;
            dgeCommAnnounce.DataSource = dsResult.Tables[0].DefaultView.ToTable();
            Session["CVCAdderData"] = dsResult.Tables[0].DefaultView.ToTable();
            pager.InitPager(dgeCommAnnounce, pageSize);
            dgeCommAnnounce.Visible = true;
            pager.Visible = true;

            if (dgeCommAnnounce.Items.Count <= 0)
                isRecordFound = false;
        }

        if(!isRecordFound)
        {
            dgeCommAnnounce.Visible = false;
            pager.Visible = false;
            DisplaStatusMessage("No Records Found", "Fail");
        }

    }

    private void UpdatePanels()
    {
        upnlEntry.Update();               
        upnlAdd.Update();
        upnlGrid.Update();
        pnlProgress.Update();
        upnlbtnsave.Update();        
    }

    private void DisableDropDowns()
    {
        //ddlCategory.Enabled = false;
    }

    protected void Clear()
    {
        try
        {
            btnSave.Visible = false;            
            btnCancel.Visible = false;

            ddlCustType.ClearSelection();
            ddlFormType.ClearSelection();
            ddlLocation.ClearSelection();
            ddlMsgType.ClearSelection();
            dpEndDt.SelectedDate = "";
            dpStartDt.SelectedDate = "";

            txtMessage.Text = txtTitle.Text = "";
            lblChangeID.Text = lblChangeDate.Text = lblEntryID.Text = lblEntryDate.Text = "";
            upnlEntry.Update();            
        }
        catch (Exception ex) { }
    }
    
    private void HighLightDropDown(DropDownList ddlFrom, string comboValueText)
    {
        ddlFrom.ClearSelection();
        ddlFrom.SelectedValue = comboValueText;

        //for (int i = 0; i <= ddlFrom.Items.Count - 1; i++)
        //{
        //    if (ddlFrom.Items[i].Value.Trim() == comboValueText.Trim())
        //        ddlFrom.Items[i].Selected = true;
        //}
    }

    private void BindDropDown(DropDownList ddlFormFieldDtl, string listName)
    {
        try
        {
            string _whereClause = "a.pListMasterID=b.fListMasterID and a.ListName='" + listName + "' Order by b.SequenceNo";
            string _tableName = "listmaster a,ListDetail b ";
            string _columnName = "b.ListValue as ListValue,b.ListValue +' - ' + b.ListDtlDesc as ListDtlDesc";

            DataSet dslist = new DataSet();
            dslist = SqlHelper.ExecuteDataset(connectionString, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            if (dslist.Tables[0].Rows.Count > 0)
            {
                ddlFormFieldDtl.DataSource = dslist.Tables[0];
                ddlFormFieldDtl.DataTextField = "ListDtlDesc";
                ddlFormFieldDtl.DataValueField = "ListValue";
                ddlFormFieldDtl.DataBind();
            }

            ListItem item = new ListItem("ALL", "");            
            ddlFormFieldDtl.Items.Insert(0, item);
            
        }
        catch (Exception ex)
        {
            throw ex;
        }
    }

    private void BindLocationDropDowns()
    {
        DataSet dsResult = ecommerceAnnouncement.GeteCommAnnouncementData("getLocations", "");
        ddlLocation.DataSource = dsResult.Tables[0];
        ddlLocationSearch.DataSource = dsResult.Tables[0];

        ddlLocation.DataTextField = "LocName";
        ddlLocation.DataValueField = "LocID";
        ddlLocationSearch.DataTextField = "LocName";
        ddlLocationSearch.DataValueField = "LocID";
        ddlLocationSearch.DataBind();
        ddlLocation.DataBind();
        ListItem item = new ListItem("ALL","");

        ddlLocation.Items.Insert(0, item);
        ddlLocationSearch.Items.Insert(0, item);
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
    }

    private void EnableQueryMode()
    {
        btnCancel.Visible = false;
        btnSave.Visible = false;        
        btnAdd.Visible = false;
    }
    
    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgeCommAnnounce.CurrentPageIndex = pager.GotoPageNumber;

        BindDataGrid();
    }

    protected void btnCancel_Click(object sender, ImageClickEventArgs e)
    {
        Clear();
        ViewState["Mode"] = "Add";        
        UpdatePanels();
    }


}



