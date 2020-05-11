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

using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;

public partial class FormMessage : System.Web.UI.Page
{
    GLPosting glPosting = new GLPosting();
    MaintenanceUtility maintenanceUtils = new MaintenanceUtility();
    GLAccount glaccount = new GLAccount();
    private DataTable dtTablesData = new DataTable();
    
    string updateMessage = "Data has been successfully updated";
    string deleteMessage = "Data has been successfully deleted";
    string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

    /// <summary>
    /// Security ReadOnly Property : Get current user's security Code
    /// </summary>
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
            SetTabIndex();
            lblDelete.Visible = false;
            if (!Page.IsPostBack)
            {
                Session["CountrySecurity"] = null;
                lnkCode.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");
                Session["CountrySecurity"] = maintenanceUtils.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.GLAccount);                
                btnDelete.Attributes.Add("onclick", "return confirm('Are you sure you want to delete?');");
                ViewState["Mode"] = "Add";
                BindDropDownLocation();
                ddlLocation.SelectedValue = Session["BranchID"].ToString();               
                BindDropDownDept();                                                
                BindDataGrid();
                btncheck();
                SelectItem(ddlLocation, Session["BranchID"].ToString());
                upnlEntry.Update();
                
            }

            if (CountrySecurity == "")
                EnableQueryMode();
        }
        catch (Exception ex)
        {
            DisplaStatusMessage(ex.Message, "Fail");
        }

    }
    protected void BindDropDownLocation()
    {
        string WhereCondition = "1=1";
        string ColNames = "LocID+ ' - '+ LocName as LocName,LocID";
        string tableName = "LocMaster";
        BindListControls(ddlLocation, "LocName", "LocID", glaccount.GetLocation(WhereCondition, ColNames, tableName), "--Select--");
        
    }
    protected void BindDropDownDept()
    {
        string WhereCondition = "LocationNo='"+ddlLocation.SelectedValue+"'";
        string ColNames = "pDepartmentID,cast(DepartmentNo as varchar(50)) + '-' +DepartmentName as DepartmentName";
        string tableName = "Departments";
        BindListControls(ddlDept, "DepartmentName", "pDepartmentID", glaccount.GetLocation(WhereCondition, ColNames, tableName), "--Select--");
        UpdatePanels();
        
    }
    protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
        SelectItem(ddlLocation, Session["BranchID"].ToString());
        BindDataGrid();
        Clear();
        ViewState["Mode"] = "Add";        
        btncheck();
        btnSave.Visible = (CountrySecurity != "") ? true : false;
        UpdatePanels();        
    }

    protected void btncheck()
    {
        if (ViewState["Mode"].ToString() == "Add")
        {
            btnDelete.Visible = false;
            btnSave.Visible = true;
        }

        if (ViewState["Mode"].ToString() == "Edit")
        {
            //btnDelete.Visible = (CountrySecurity != "") ? true : false;
            btnSave.Visible = (CountrySecurity != "") ? true : false;
        }

        upnlbtnsave.Update();

    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {

        chkDelete.Checked = false;
        string whereCondition = "AccountNo='" + txtAccountNo.Text.ToString().Trim() + "' AND DeleteDt is NULL ";
        string whereClause = "AccountNo='" + txtAccountNo.Text.ToString().Trim() + "' AND " +
                                  "Location='" + ddlLocation.SelectedItem.Value.Trim().Replace("'", "''") + "' AND " +
                                   "AliasAccountNo='" + txtAliasNo.Text.ToString().Trim().Replace("'", "''") + "' AND " +
                                   "AccountDescription='" + txtDescription.Text.ToString().Trim().Replace("'", "''") + "' AND " +
                                   "AccountType='" + txtAccount.Text.ToString().Trim().Replace("'", "''") + "' AND " +
                                   "PostLevel='" + txtPostLevel.Text.ToString().Trim().Replace("'", "''") + "'  AND " +
                                   "SequenceNo='" + txtSequenceNo.Text.ToString().Trim().Replace("'", "''") + "' AND " +
                                   "EffectiveDt='" + dtEffectiveDate.SelectedDate + "' AND " +
                                   "fDepartmentID='" + ddlDept.SelectedItem.Value.Trim().Replace("'", "''") + "'";
        if (ViewState["Mode"].ToString() == "Add")
        {
            if (glaccount.CheckDataExist(whereCondition))
            {
                DateTime date = Convert.ToDateTime(dtEffectiveDate.SelectedDate);
                DateTime present = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                if (date >= present)
                {

                        string columnName = "AccountNo,Location,AliasAccountNo,AccountDescription," +
                                          "AccountType,PostLevel,SequenceNo,fDepartmentID,EffectiveDt,EntryID,EntryDt";

                        string columnValue = "'" + txtAccountNo.Text.ToString().Trim().Replace("'", "''") + "'," +
                                             "'" + ddlLocation.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                             "'" + txtAliasNo.Text.ToString().Trim().Replace("'", "''") + "'," +
                                             "'" + txtDescription.Text.ToString().Trim().Replace("'", "''") + "'," +
                                             "'" + txtAccount.Text.ToString().Trim().Replace("'", "''") + "'," +
                                             "'" + txtPostLevel.Text.ToString().Trim().Replace("'", "''") + "'," +
                                             "'" + txtSequenceNo.Text.ToString().Trim().Replace("'", "''") + "'," +
                                             "'" + ddlDept.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                              "'" + dtEffectiveDate.SelectedDate + "'," +
                                             "'" + Session["UserName"] + "'," +
                                             "'" + DateTime.Now.ToShortDateString() + "'";

                        glaccount.InsertTables(columnName, columnValue);
                        DisplaStatusMessage(updateMessage, "Success");
                        btnSave.Visible = false;
                        btnDelete.Visible = false;
                        ViewState["Operation"] = "Save";
                        Clear();
                        BindDataGrid();
                    
                    
                }
                else
                {
                    DisplaStatusMessage("Effective date should be greater than current date", "Fail");
                    pnlProgress.Update();
                }
            }
            else
            {
                DisplaStatusMessage("GL Account Number Already Exists", "Fail");               
                pnlProgress.Update();
               
            }
           
        }
        else
        {
            whereCondition += " AND pGLAcctMasterID <>" + hidPrimaryKey.Value.Trim();
            if (glaccount.CheckDataExist(whereCondition))
            {
                DateTime date = Convert.ToDateTime(dtEffectiveDate.SelectedDate);
                DateTime present = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                if (date >= present)
                {
                    string updateValue = "AccountNo='" + txtAccountNo.Text.ToString().Trim().Replace("'", "''") + "'," +
                                         "Location='" + ddlLocation.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                         "AliasAccountNo='" + txtAliasNo.Text.ToString().Trim().Replace("'", "''") + "'," +
                                         "AccountDescription='" + txtDescription.Text.ToString().Trim().Replace("'", "''") + "'," +
                                         "AccountType='" + txtAccount.Text.ToString().Trim().Replace("'", "''") + "'," +
                                         "PostLevel='" + txtPostLevel.Text.ToString().Trim().Replace("'", "''") + "'," +
                                         "SequenceNo='" + txtSequenceNo.Text.ToString().Trim().Replace("'", "''") + "'," +
                                         "fDepartmentID='" + ddlDept.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                          "EffectiveDt='" + dtEffectiveDate.SelectedDate + "'," +
                                         "ChangeID='" + Session["UserName"].ToString() + "'," +
                                         "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";

                    glaccount.UpdateTables(updateValue, "pGLAcctMasterID=" + hidPrimaryKey.Value.Trim());
                    DisplaStatusMessage(updateMessage, "Success");
                    btnSave.Visible = false;
                    btnDelete.Visible = false;
                    ViewState["Operation"] = "Save";
                    Clear();
                    BindDataGrid();
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
                }
                else
                {
                    DisplaStatusMessage("Effective date should be greater than current date", "Fail");
                    pnlProgress.Update();
                }
            }
            else
            {
                DisplaStatusMessage("GL Account Number Already Exists", "Fail");
                upnlGrid.Update();
                pnlProgress.Update();
                return;
            }
        }

        upnlGrid.Update();
        UpdatePanels();
        pnlProgress.Update();
    }  

    protected void dgCountryCode_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            dtTablesData = glaccount.GetPostingRecords("pGLAcctMasterID = '" + e.CommandArgument + "'");
            ddlLocation.ClearSelection();
            ddlDept.ClearSelection();
            DisplayRecord();
            btncheck();
            btnSave.Visible = (CountrySecurity != "") ? true : false;
            if (chkDelete.Checked == true)
            {
                lblDelete.Visible = true;
                btnSave.Visible = false;
                btnDelete.Visible = false;
                lblDeleteDate.Text = Convert.ToDateTime(dtTablesData.Rows[0]["DeleteDT"].ToString()).ToShortDateString();
            }
            else
            {
                lblDeleteDate.Text = "";
               
            }
        }
        if (e.CommandName == "Delete")
        {
            ViewState["Operation"] = "Delete";
            string colValues = "DeleteDt='"+DateTime.Now.ToShortDateString()+"'";
            glaccount.UpdateDeleteDT(colValues,e.CommandArgument.ToString());
            BindDataGrid();
            DisplaStatusMessage(deleteMessage, "Success");
            Clear();
        }
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
        UpdatePanels();        
    }

    protected void btnDelete_Click(object sender, ImageClickEventArgs e)
    {
        //glaccount.DeleteTablesData(hidPrimaryKey.Value);
        string colValues = "DeleteDt='" + DateTime.Now.ToShortDateString() + "'";
        glaccount.UpdateDeleteDT(colValues,hidPrimaryKey.Value);
        Clear();
        DisplaStatusMessage(deleteMessage, "success");
        ViewState["Operation"] = "Delete";
        BindDataGrid();

        btnSave.Visible = false;
        btnDelete.Visible = false;
        UpdatePanels();
    }
    
    protected void dgCountryCode_SortCommand(object source, DataGridSortCommandEventArgs e)
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
    /// <summary>
    /// dgCountryCode :Item data bound event handlers
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void dgCountryCode_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if ((e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item) && CountrySecurity == "")
        {
            LinkButton lnkDelete = e.Item.FindControl("lnlDelete") as LinkButton;          
            lnkDelete.Visible = false;
        }
        else if ((e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item))
        {
            LinkButton lnkDelete = e.Item.FindControl("lnlDelete") as LinkButton;
            if (chkDelete.Checked)
                lnkDelete.Visible = false;
        }
    }

    private void DisplayRecord()
    {
        ViewState["Mode"] = "Edit";

        btncheck();
        hidPrimaryKey.Value = dtTablesData.Rows[0]["pGLAcctMasterID"].ToString().Trim();
        SelectItem(ddlLocation, dtTablesData.Rows[0]["Location"].ToString().Trim());
        SelectItem(ddlDept, dtTablesData.Rows[0]["fDepartmentID"].ToString().Trim());
        txtAccountNo.Text = dtTablesData.Rows[0]["AccountNo"].ToString().Trim();
        txtAccount.Text = dtTablesData.Rows[0]["AccountType"].ToString().Trim();
        txtPostLevel.Text = dtTablesData.Rows[0]["PostLevel"].ToString().Trim();
        txtAliasNo.Text = dtTablesData.Rows[0]["AliasAccountNo"].ToString().Trim();
        txtSequenceNo.Text = dtTablesData.Rows[0]["SequenceNo"].ToString().Trim();
        txtDescription.Text = dtTablesData.Rows[0]["AccountDescription"].ToString().Trim();
        dtEffectiveDate.SelectedDate = (dtTablesData.Rows[0]["EffectiveDt"].ToString() == "") ? "" : Convert.ToDateTime(dtTablesData.Rows[0]["EffectiveDt"].ToString().Trim()).ToShortDateString();

        lblEntryID.Text = dtTablesData.Rows[0]["EntryID"].ToString().Trim();
        //lblEntryDate.Text = Convert.ToDateTime(dtTablesData.Rows[0]["EntryDt"].ToString()).ToShortDateString();
        lblChangeID.Text = dtTablesData.Rows[0]["ChangeID"].ToString().Trim();
        //lblChangeDate.Text = (dtTablesData.Rows[0]["ChangeDt"].ToString().Trim() != "" ? Convert.ToDateTime(dtTablesData.Rows[0]["ChangeDt"].ToString()).ToShortDateString():"");
        lblChangeDate.Text = (dtTablesData.Rows[0]["ChangeDt"].ToString() == "") ? "" : Convert.ToDateTime(dtTablesData.Rows[0]["ChangeDt"].ToString()).ToShortDateString();
        lblEntryDate.Text = (dtTablesData.Rows[0]["EntryDt"].ToString() == "") ? "" : Convert.ToDateTime(dtTablesData.Rows[0]["EntryDt"].ToString()).ToShortDateString();
       
    }

    private void BindDataGrid()
    {
        Pager1.Visible = true;
        //string searchText = GetSearchText();
        lblDeleteDate.Text = "";
        string searchText = "DeleteDt is null";
        Clear();
        dtTablesData = glaccount.GetDataGridPostingRecords(searchText);

        if (dtTablesData != null)
        {
            dtTablesData.DefaultView.Sort = (hidSort.Value == "") ? "pGLAcctMasterID desc" : hidSort.Value;
            dgCountryCode.DataSource = dtTablesData.DefaultView.ToTable();
            //dgCountryCode.DataBind();
             Pager1.InitPager(dgCountryCode, 25);
            
            if (dtTablesData.Rows.Count == 1)
            {
                if (Page.IsPostBack)
                {
                    //
                    // Fetch Data From Table
                    //
                    hidPrimaryKey.Value = dtTablesData.Rows[0]["pGLAcctMasterID"].ToString().Trim();
                    dtTablesData = glPosting.GetPostingRecords("pGLAcctMasterID = '" + hidPrimaryKey.Value + "'");
                    DisplayRecord();
                    btnSave.Visible = (CountrySecurity != "") ? true : false;
                    //btnDelete.Visible = (CountrySecurity != "") ? true : false;
                    if (ViewState["Operation"].ToString() == "Save" || ViewState["Operation"].ToString() == "Delete" || ViewState["Operation"].ToString() == "Clear")
                    {
                        Clear();
                    }
                }
                else
                {
                    btnSave.Visible = false;
                    btnDelete.Visible = false;
                }
            }
            if (dtTablesData.Rows.Count == 0)
            {
                DisplaStatusMessage("No Records Found", "Fail");
            }

        }
        else
            DisplaStatusMessage("No Records Found", "Fail");
        SelectItem(ddlLocation, Session["BranchID"].ToString());
        UpdatePanels();
    }

    private void UpdatePanels()
    {

        upnlEntry.Update();      
        upnlAdd.Update();
        upnlGrid.Update();
        pnlProgress.Update();
        upnlbtnsave.Update();
    }    

    protected void Clear()
    {
        try
        {
            btnSave.Visible = false;
            btnDelete.Visible = false;
            ddlLocation.SelectedIndex = 0;
            ddlDept.SelectedIndex = 0;
            txtDescription.Text = "";
            txtAliasNo.Text = "";
            txtAccountNo.Text = "";
            txtAccount.Text = "";
            txtSequenceNo.Text = "";
            txtPostLevel.Text = "";
            dtEffectiveDate.SelectedDate = "";
            chkDelete.Checked = false;
            lblChangeID.Text = lblChangeDate.Text = lblEntryID.Text = lblEntryDate.Text = "";
            upnlEntry.Update();
        }
        catch (Exception ex) { }
    }
    private void SelectItem(DropDownList ddlControl, string value)
    {
        ListItem lItem = ddlControl.Items.FindByValue(value) as ListItem;
        if (lItem != null)
        {
            ddlControl.SelectedValue = value.Trim();
            for (int i = 0; i <= ddlControl.Items.Count - 1; i++)
            {
                if (ddlControl.Items[i].Value.Trim() == value.Trim())
                    ddlControl.Items[i].Selected = true;
            }
        }
        else
            ddlControl.ClearSelection();
    }
    private void HighLightDropDown(DropDownList ddlFrom, string comboValueText)
    {
        ddlFrom.ClearSelection();
        ddlFrom.SelectedValue = comboValueText;

        for (int i = 0; i <= ddlFrom.Items.Count - 1; i++)
        {
            if (ddlFrom.Items[i].Value.Trim() == comboValueText.Trim())
                ddlFrom.Items[i].Selected = true;
        }
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

            ListItem item = new ListItem("     ---Select---     ", "");
            ddlFormFieldDtl.Items.Insert(0, item);

        }
        catch (Exception ex)
        {
            throw ex;
        }
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
    /// <summary>
    ///  used to disable control for security mode
    /// </summary>
    private void EnableQueryMode()
    {
        btnDelete.Visible = false;
        btnSave.Visible = false;
        btnAdd.Visible = false;
    }    

    private void SetTabIndex()
    {
        //txtSearchText.Attributes.Add("onkeydown", "if(event.which || event.keyCode)" +
        //"{if ((event.which == 9) || (event.keyCode == 9)) " +
        //"{document.getElementById('" + ddlAppType.ClientID +
        //"').focus();return false;}} else {return true}; ");
    }
    protected void ddlLocation_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindDropDownDept();
        UpdatePanels();
    }
    protected void chkDelete_CheckedChanged(object sender, EventArgs e)
    {

        if (chkDelete.Checked)
        {
            btnSave.Visible = false;
            lblDelete.Visible = true;
            string searchText = "DeleteDT is not null";
            dtTablesData = glaccount.GetDataGridPostingRecords(searchText);
            if (dtTablesData != null)
            {
                dgCountryCode.DataSource = dtTablesData;
                if (dtTablesData.Rows.Count == 25)
                    Pager1.InitPager(dgCountryCode, 25);
                else
                {
                    Pager1.Visible = false;
                    //Pager1.InitPager(dgCountryCode,dtTablesData.Rows.Count);
                    dgCountryCode.DataBind();
                    ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "div", "javascript:document.getElementById('dgCountryCode').style.width='995px';", true);
                    //ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "div12", "javascript:document.getElementById('div-datagrid').style.height='350px';", true);
                }
            }
            else
                DisplaStatusMessage("No Records Found", "Fail");
        }
        else
        {
            BindDataGrid();
        }
        upnlbtnsave.Update();
        upnlEntry.Update();
    }
    public void BindListControls(ListControl lstControl, string textField, string valueField, DataTable dtSource, string defaultValue)
    {
        try
        {
            if (dtSource != null && dtSource.Rows.Count > 0)
            {
                lstControl.DataSource = dtSource;
                lstControl.DataTextField = textField;
                lstControl.DataValueField = valueField;
                lstControl.DataBind();
                lstControl.Items.Insert(0, new ListItem(defaultValue, ""));


            }
            else
            {
                if (lstControl.ID.IndexOf("lst") == -1)
                {
                    lstControl.Items.Clear();
                    lstControl.Items.Insert(0, new ListItem("N/A", ""));
                }

            }
        }
        catch (Exception ex) { throw ex; }
    }
    protected void dgCountryCode_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        dgCountryCode.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
    }
    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgCountryCode.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

}



