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
using System.Data.SqlClient;

using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;

public partial class MaintenanceApps_ExpenseCode : System.Web.UI.Page
{
    int count;
    MaintenanceUtility expenseCode;
    private DataTable dtTablesData = new DataTable();

    string updateMessage = "Data has been successfully updated";
    string deleteMessage = "Data has been successfully deleted";
    string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"];
   

    /// <summary>
    /// Security ReadOnly Property : Get current user's security Code
    /// </summary>
    protected string ExpenseSecurity
    {
        get
        {
            return Session["ExpenseSecurity"].ToString();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        //connectionString = PFC.Intranet.MaintenanceApps.MaintenanceUtility.GetConnectionString();
        expenseCode = new MaintenanceUtility();
        ViewState["Operation"] = "";
        lblMessage.Text = "";
        SetTabIndex();
        
       
        if (!Page.IsPostBack)
        {
            lnkCode.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");
            Session["ExpenseSecurity"] = expenseCode.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.ExpenseCodes);
            
            btnDelete.Attributes.Add("onclick", "return confirm('Are you sure you want to delete?');");
            ViewState["Mode"] = "Add";
            BindDataGrid();
            BindDropDown(ddlExpType, "ExpType");
            BindDropDown(ddlIndicator, "ExpInd");
            BindDropDown(ddlTaxStatus, "TaxStatusCd");
            BindAccountsDropDown(ddlGLAccount);
            btncheck();

        }

        if (ExpenseSecurity == "")
            EnableQueryMode();

    }

    protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
        BindDataGrid();
        Clear();
        ViewState["Mode"] = "Add";
        txtCode.Enabled = true;
        btncheck();
        btnSave.Visible = (ExpenseSecurity != "") ? true : false;
        txtCode.Focus();
        UpdatePanels();
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "FocusControl", "document.getElementById('txtCode').focus();", true);
    }

    protected void btncheck()
    {
        if (ViewState["Mode"] == "Add")
        {
            btnDelete.Visible = false;
        }

        if (ViewState["Mode"] == "Edit")
        {
            btnDelete.Visible = (ExpenseSecurity != "") ? true : false;
        }

        upnlbtnsave.Update();

    }

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        if (chkSelectAll.Checked == true)
            foreach (ListItem li in chkSelection.Items)
            {
                li.Selected = true;

            }
        else
            foreach (ListItem li in chkSelection.Items)
            {
                li.Selected = false;
            }
        upnlchkSelectAll.Update();

    }
    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {

        if (ViewState["Mode"].ToString() == "Add")
        {
            bool ExpenseCode = expenseCode.CheckDataExist(txtCode.Text.Trim(), MaintenaceTable.ExpenseCodes);
            
            if (ExpenseCode)
            {                
                string columnName = "TableCd,Dsc,ShortDsc,GLAccountNo,Pct,LineNumber,ExpType,Indicator,TaxStatus,GLApp,APApp,ARApp,SOApp,POApp,IMApp,WMApp,WOApp,MMApp,SMApp,EntryID,EntryDt,TableType";
                string columnValue = "'" + txtCode.Text.Trim()+ "'," +
                                    "'" + txtDescription.Text.Trim() + "'," +
                                    "'" + txtShortDesc.Text.Trim() + "'," +
                                    "'" + ddlGLAccount.SelectedValue.Trim()+"'"+
                                    "," + (txtPercent.Text.Trim() == "" ? "NULL" : txtPercent.Text.Trim()) + "," +
                                    (txtExpLine.Text.Trim() == "" ? "NULL" : txtExpLine.Text.Trim()) + "," +
                                    "'" + ddlExpType .SelectedValue.Trim() + "'," +
                                    "'" + ddlIndicator.SelectedValue.Trim() + "'," +
                                    "'" + ddlTaxStatus.SelectedValue.Trim() + "'," +
                                    "'" + ((chkSelection.Items[0].Selected == true) ? "Y" : "") + "'," +
                                    "'" + ((chkSelection.Items[1].Selected == true) ? "Y" : "") + "'," +
                                    "'" + ((chkSelection.Items[2].Selected == true) ? "Y" : "") + "'," +
                                    "'" + ((chkSelection.Items[3].Selected == true) ? "Y" : "") + "'," +
                                    "'" + ((chkSelection.Items[4].Selected == true) ? "Y" : "") + "'," +
                                    "'" + ((chkSelection.Items[5].Selected == true) ? "Y" : "") + "'," +
                                    "'" + ((chkSelection.Items[6].Selected == true) ? "Y" : "") + "'," +
                                    "'" + ((chkSelection.Items[7].Selected == true) ? "Y" : "") + "'," +
                                    "'" + ((chkSelection.Items[8].Selected == true) ? "Y" : "") + "'," +
                                    "'" + ((chkSelection.Items[9].Selected == true) ? "Y" : "") + "'," +
                                    "'" + Session["UserName"] + "'," +
                                    "'" + DateTime.Now.ToShortDateString() + "'," +
                                    "'EXP'";

                expenseCode.InsertTables(columnName, columnValue);
                DisplaStatusMessage(updateMessage, "Success");
                //BindDataGrid();
                btnSave.Visible = false;
                btnDelete.Visible = false;
            }
            else
            {
                DisplaStatusMessage("Code Already Exists", "Fail");
                upnlGrid.Update();
                pnlProgress.Update();
                return;
            }
            

        }
        else
        {
            string updateValue = "TableCd='" + txtCode.Text.Trim().Replace("'", "''") + "'," +
                            "Dsc='" + txtDescription.Text.Trim().Replace("'", "''") + "'," +
                            "ShortDsc='" + txtShortDesc.Text.Trim().Replace("'", "''") + "'," +
                            "GLAccountNo='" + ddlGLAccount.SelectedValue.Trim() + "'," +
                            "Pct=" + (txtPercent.Text.Trim() == "" ? "NULL" : txtPercent.Text.Trim()) + "," +
                            "ExpType='" + ddlExpType.SelectedValue.Trim() + "'," +
                            "LineNumber=" + (txtExpLine.Text.Trim() == "" ? "NULL" : txtExpLine.Text.Trim()) + "," +
                            "Indicator='" + ddlIndicator.SelectedValue.Trim() + "'," +
                            "TaxStatus='" + ddlTaxStatus.SelectedValue.Trim() + "'," +
                            "GLApp='" + ((chkSelection.Items[0].Selected == true) ? "Y" : "") + "'," +
                            "APApp='" + ((chkSelection.Items[1].Selected == true) ? "Y" : "") + "'," +
                            "ARApp='" + ((chkSelection.Items[2].Selected == true) ? "Y" : "") + "'," +
                            "SOApp='" + ((chkSelection.Items[3].Selected == true) ? "Y" : "") + "'," +
                            "POApp='" + ((chkSelection.Items[4].Selected == true) ? "Y" : "") + "'," +
                            "IMApp='" + ((chkSelection.Items[5].Selected == true) ? "Y" : "") + "'," +
                            "WMApp='" + ((chkSelection.Items[6].Selected == true) ? "Y" : "") + "'," +
                            "WOApp='" + ((chkSelection.Items[7].Selected == true) ? "Y" : "") + "'," +
                            "MMApp='" + ((chkSelection.Items[8].Selected == true) ? "Y" : "") + "'," +
                            "SMApp='" + ((chkSelection.Items[9].Selected == true) ? "Y" : "") + "'," +
                            "ChangeID='" + Session["UserName"].ToString() + "'," +
                            "ChangeDt='" + DateTime.Now.ToShortDateString() + "'"; 

            expenseCode.UpdateTables(updateValue, "pTableID=" + hidPrimaryKey.Value.Trim());
           // BindDataGrid();
            DisplaStatusMessage(updateMessage, "Success");
            btnSave.Visible = false;
            btnDelete.Visible = false;
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);

        }
        ViewState["Operation"] = "Save";
        Clear();
        BindDataGrid();
        UpdatePanels();
    }
    protected void btnSearch_Click(object sender, ImageClickEventArgs e)
    {
        btnSave.Visible = false;
        btnDelete.Visible = false;
        ViewState["Mode"] = "Add";
        btncheck();
        Clear();

        BindDataGrid();
        UpdatePanels();
    }

    protected void btnDelete_Click(object sender, ImageClickEventArgs e)
    {
        expenseCode.DeleteTablesData(hidPrimaryKey.Value);
        Clear();
        DisplaStatusMessage(deleteMessage, "success");
        ViewState["Operation"] = "Delete";
        BindDataGrid();

        btnSave.Visible = false;
        btnDelete.Visible = false;
        UpdatePanels();
    }
    protected void btnCancel_Click(object sender, ImageClickEventArgs e)
    {
        Clear();
    }
    protected void dgExpenseCode_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            dtTablesData = expenseCode.GetTablesData("pTableID = '" + e.CommandArgument + "'");
            DisplayRecord();
            btncheck();
            btnSave.Visible = (ExpenseSecurity != "") ? true : false;
            ScriptManager.RegisterClientScriptBlock(txtDescription, txtDescription.GetType(), "focus", "document.getElementById('" + txtDescription.ClientID + "').select();document.getElementById('" + txtDescription.ClientID + "').focus();", true);
        }
        if (e.CommandName == "Delete")
        {
            ViewState["Operation"] = "Delete";
            expenseCode.DeleteTablesData(e.CommandArgument.ToString());
            BindDataGrid();
            DisplaStatusMessage(deleteMessage, "Success");
            Clear();
        }
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
        UpdatePanels();
    }

    protected void dgExpenseCode_SortCommand(object source, DataGridSortCommandEventArgs e)
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
       
     private void DisplayRecord()
    {
        ViewState["Mode"] = "Edit";
        
        btncheck();
        hidPrimaryKey.Value = dtTablesData.Rows[0]["pTableID"].ToString().Trim();
        txtCode.Text = dtTablesData.Rows[0]["TableCd"].ToString().Trim();
        txtCode.Enabled = false;
        txtDescription.Text = dtTablesData.Rows[0]["Dsc"].ToString().Trim();
        txtShortDesc.Text = dtTablesData.Rows[0]["ShortDsc"].ToString().Trim();
        txtExpLine.Text =dtTablesData.Rows[0]["LineNumber"].ToString ().Trim();
        if (dtTablesData.Rows[0]["Pct"] != null && dtTablesData.Rows[0]["Pct"].ToString().Trim() != "")
        {   
            txtPercent.Text = Math.Round(Convert.ToDecimal(dtTablesData.Rows[0]["Pct"].ToString().Trim()),2).ToString();
        }        
        HighLightDropDown(ddlGLAccount, dtTablesData.Rows[0]["GLAccountNo"].ToString().Trim());
        HighLightDropDown(ddlExpType , dtTablesData.Rows[0]["ExpType"].ToString().Trim());
        HighLightDropDown (ddlTaxStatus,dtTablesData.Rows [0]["TaxStatus"].ToString().Trim());
        HighLightDropDown(ddlIndicator , dtTablesData.Rows[0]["Indicator"].ToString().Trim());
        lblEntryID.Text = dtTablesData.Rows[0]["EntryID"].ToString().Trim();
        lblEntryDate.Text = dtTablesData.Rows[0]["EntryDt"].ToString().Trim();
        lblChangeID.Text = dtTablesData.Rows[0]["ChangeID"].ToString().Trim();
        lblChangeDate.Text = dtTablesData.Rows[0]["ChangeDt"].ToString().Trim();

        if (dtTablesData.Rows[0]["GLApp"].ToString().Trim() == "Y")
        {
            chkSelection.Items[0].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[0].Selected = false;

        }
        if (dtTablesData.Rows[0]["APApp"].ToString().Trim() == "Y")
        {
            chkSelection.Items[1].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[1].Selected = false;
        }

        if (dtTablesData.Rows[0]["ARApp"].ToString().Trim() == "Y")
        {
            chkSelection.Items[2].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[2].Selected = false;

        }


        if (dtTablesData.Rows[0]["SOApp"].ToString().Trim() == "Y")
        {
            chkSelection.Items[3].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[3].Selected = false;

        }

        if (dtTablesData.Rows[0]["POApp"].ToString().Trim() == "Y")
        {
            chkSelection.Items[4].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[4].Selected = false;

        }


        if (dtTablesData.Rows[0]["IMApp"].ToString().Trim() == "Y")
        {
            chkSelection.Items[5].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[5].Selected = false;

        }


        if (dtTablesData.Rows[0]["WMApp"].ToString().Trim() == "Y")
        {
            chkSelection.Items[6].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[6].Selected = false;

        }

        if (dtTablesData.Rows[0]["WOApp"].ToString().Trim() == "Y")
        {
            chkSelection.Items[7].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[7].Selected = false;

        }

        if (dtTablesData.Rows[0]["MMApp"].ToString().Trim() == "Y")
        {
            chkSelection.Items[8].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[8].Selected = false;

        }

        if (dtTablesData.Rows[0]["SMApp"].ToString().Trim() == "Y")
        {
            chkSelection.Items[9].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[9].Selected = false;

        }

        if (count == 10)
        {
            chkSelectAll.Checked = true;

        }
        else
        {
            chkSelectAll.Checked = false;

        }
       
    }

    private void BindDataGrid()
    {
        string searchText = (txtSearchCode.Text == "" ? "TableType='EXP'" : "TableType='EXP' AND TableCd like '%" + txtSearchCode.Text + "%'");
        dtTablesData = expenseCode.GetTablesData(searchText);

        if (dtTablesData != null)
        {
            dtTablesData.DefaultView.Sort = (hidSort.Value == "") ? "TableCd asc" : hidSort.Value;
            dgExpenseCode.DataSource = dtTablesData.DefaultView.ToTable();
            dgExpenseCode.DataBind();

            if (dtTablesData.Rows.Count == 1)
            {
                if (Page.IsPostBack)
                {
                    DisplayRecord();
                    btnSave.Visible = (ExpenseSecurity != "") ? true : false;
                    btnDelete.Visible = (ExpenseSecurity != "") ? true : false;
                    if (ViewState["Operation"].ToString() == "Save" || ViewState["Operation"].ToString() == "Delete")
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

    }

    private void UpdatePanels()
    {

        upnlEntry.Update();
        upnlchkSelectAll.Update();
        upnlbtnSearch.Update();
        upnlAdd.Update();
        upnlGrid.Update();
        pnlProgress.Update();
        upnlbtnsave.Update();
    }
    
    protected void Clear()
    {
        try
        {
            foreach (ListItem li in chkSelection.Items)
            {
                li.Selected = false;
            }
            btnSave.Visible = false;
            btnDelete.Visible = false;
            chkSelectAll.Checked = false;
            txtCode.Focus();
            lblChangeID.Text =  lblChangeDate.Text = lblEntryID.Text = lblEntryDate.Text = "";
            txtCode.Text =  txtDescription.Text = txtShortDesc.Text  = "";
            txtExpLine.Text = txtPercent.Text = "";
            ddlIndicator.SelectedIndex = 0;
            ddlTaxStatus.SelectedIndex = 0;
            ddlGLAccount.SelectedIndex = 0;
            ddlExpType.SelectedIndex = 0;
            upnlEntry.Update();
            upnlchkSelectAll.Update();
        }
        catch (Exception ex) { }
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
    /// <summary>
    /// dgCountryCode :Item data bound event handlers
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void dgExpenseCode_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if ((e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item) && ExpenseSecurity == "")
        {
            LinkButton lnkDelete = e.Item.FindControl("lnlDelete") as LinkButton;
            lnkDelete.Visible = false;
        }
    }

    private void SetTabIndex()
    {
        txtSearchCode.Attributes.Add("onkeydown", "if(event.which || event.keyCode)" +
        "{if ((event.which == 9) || (event.keyCode == 9) || (event.which == 13) || (event.keyCode == 13)) " +
        "{document.getElementById('" + txtCode.ClientID +
        "').focus();return false;}} else {return true}; ");
    }

    private void BindDropDown(DropDownList ddlFormFieldDtl, string listName)
    {
        try
        {
            string _whereClause = "a.pListMasterID=b.fListMasterID and a.ListName='" + listName + "' Order by b.SequenceNo";
            string _tableName = "listmaster a,ListDetail b ";
            string _columnName = "b.ListValue as ListValue,b.ListValue +' - '+b.ListDtlDesc as ListDtlDesc";

            DataSet dslist = new DataSet();
            dslist = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
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

    private void BindAccountsDropDown(DropDownList ddlFormFieldDtl)
    {
        try
        {
            string _columnName = "AccountNo,(AccountNo+' - '+AccountDescription) as AccountDescription";
            string _whereClause = "1=1 Order By SequenceNo";
            string _tableName = "GLAcctMaster";


            DataSet dslist = new DataSet();
            dslist = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            if (dslist.Tables[0].Rows.Count > 0)
            {
                ddlFormFieldDtl.DataSource = dslist.Tables[0];
                ddlFormFieldDtl.DataTextField = "AccountDescription";
                ddlFormFieldDtl.DataValueField = "AccountNo";
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

    private void HighLightDropDown(DropDownList ddlFrom, string comboValueText)
    {
        ddlFrom.ClearSelection();

        foreach (ListItem item in ddlFrom.Items)
        {
            if(item.Value == comboValueText)
                item.Selected = true;
        }
    }

}



