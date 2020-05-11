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
    int count;
    MaintenanceUtility formMessages = new MaintenanceUtility();
    FormMessages formMsg = new FormMessages();
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

            if (!Page.IsPostBack)
            {
                Session["CountrySecurity"] = null;
                lnkCode.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");
                Session["CountrySecurity"] = formMessages.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.FormMessage);                
                btnDelete.Attributes.Add("onclick", "return confirm('Are you sure you want to delete?');");
                ViewState["Mode"] = "Add";

                // Fill Data Entry Drop Down
                BindDropDown(ddlFormType,ddlSearcFrmType, "FormType");
                BindDropDown(ddlMsgType,ddlSearchMsgType, "FormMsgType");
                BindBanchDropDown();                             
                                
                BindDataGrid();
                btncheck();
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
        BindDataGrid();
        Clear();
        ViewState["Mode"] = "Add";        
        btncheck();
        btnSave.Visible = (CountrySecurity != "") ? true : false;
        txtComments.Focus();
        UpdatePanels();        
    }

    protected void btncheck()
    {
        if (ViewState["Mode"] == "Add")
        {
            btnDelete.Visible = false;
        }

        if (ViewState["Mode"] == "Edit")
        {
            btnDelete.Visible = (CountrySecurity != "") ? true : false;
        }

        upnlbtnsave.Update();

    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        bool CountryCode = true;
        if (ViewState["Mode"].ToString() == "Add")
        {
            CountryCode = CheckDataExist("Add");
            if (CountryCode)
            {
                string columnName = "PrintDoc,FormMsgLoc,FormMsgType,Comments,EntryID,EntryDt,ChangeID,ChangeDt,TableType";
                string columnValue = "'" + ddlFormType.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                    "'" + ddlLocation.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                    "'" + ddlMsgType.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                    "'" + txtComments.Text.Trim().Replace("'", "''") + "'," +                                    
                                    "'" + Session["UserName"] + "'," +
                                    "'" + DateTime.Now.ToShortDateString() + "'," +
                                    "'" + Session["UserName"] + "'," +
                                    "'" + DateTime.Now.ToShortDateString() + "','FM'";

                formMessages.InsertTables(columnName,columnValue);
                DisplaStatusMessage(updateMessage, "Success");
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
            CountryCode = CheckDataExist("Edit");
            if (CountryCode)
            {
                string updateValue = "FormMsgLoc='" + ddlLocation.SelectedItem.Value.Trim().Trim().Replace("'", "''") + "'," +
                                     "FormMsgType='" + ddlMsgType.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "PrintDoc='" + ddlFormType.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "Comments='" + txtComments.Text.Trim().Replace("'", "''") + "'," +
                                     "ChangeID='" + Session["UserName"].ToString() + "'," +
                                     "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";

                formMessages.UpdateTables(updateValue, "pTableID=" + hidPrimaryKey.Value.Trim());

                DisplaStatusMessage(updateMessage, "Success");
                btnSave.Visible = false;
                btnDelete.Visible = false;
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);

            }
            else
            {
                DisplaStatusMessage("Code Already Exists", "Fail");
                upnlGrid.Update();
                pnlProgress.Update();
                return;
            }
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
        BindDataGrid();
        UpdatePanels();
    }

    protected void dgCountryCode_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            dtTablesData = formMsg.GetFormMessages("pTableID = '" + e.CommandArgument + "'");
            DisplayRecord();
            btncheck();
            btnSave.Visible = (CountrySecurity != "") ? true : false;
            ScriptManager.RegisterClientScriptBlock(txtComments, txtComments.GetType(), "focud", "document.getElementById('" + txtComments.ClientID + "').select();document.getElementById('" + txtComments.ClientID + "').focus();", true);
        }
        if (e.CommandName == "Delete")
        {
            ViewState["Operation"] = "Delete";
            formMessages.DeleteTablesData(e.CommandArgument.ToString());
            BindDataGrid();
            DisplaStatusMessage(deleteMessage, "Success");            
            Clear();
        }
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
        UpdatePanels();        
    }

    protected void btnDelete_Click(object sender, ImageClickEventArgs e)
    {
        formMessages.DeleteTablesData(hidPrimaryKey.Value);
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
    }

    private void DisplayRecord()
    {
        ViewState["Mode"] = "Edit";
        
        btncheck();
        hidPrimaryKey.Value = dtTablesData.Rows[0]["pTableID"].ToString().Trim();
        HighLightDropDown(ddlFormType, dtTablesData.Rows[0]["FrmType"].ToString().Trim());
        HighLightDropDown(ddlLocation, dtTablesData.Rows[0]["FormMsgLoc"].ToString().Trim());
        HighLightDropDown(ddlMsgType, dtTablesData.Rows[0]["FormMsgType"].ToString().Trim());
        txtComments.Text = dtTablesData.Rows[0]["Comments"].ToString().Trim();

        lblEntryID.Text = dtTablesData.Rows[0]["EntryID"].ToString().Trim();
       // lblEntryDate.Text = Convert.ToDateTime(dtTablesData.Rows[0]["EntryDt"].ToString()).ToShortDateString();
        lblChangeID.Text = dtTablesData.Rows[0]["ChangeID"].ToString().Trim();
        //lblChangeDate.Text = Convert.ToDateTime(dtTablesData.Rows[0]["ChangeDt"].ToString()).ToShortDateString();
        lblChangeDate.Text = (dtTablesData.Rows[0]["ChangeDt"].ToString() == "") ? "" : Convert.ToDateTime(dtTablesData.Rows[0]["ChangeDt"].ToString()).ToShortDateString();
        lblEntryDate.Text = (dtTablesData.Rows[0]["EntryDt"].ToString() == "") ? "" : Convert.ToDateTime(dtTablesData.Rows[0]["EntryDt"].ToString()).ToShortDateString();
       
    }

    private void BindDataGrid()
    {
        string searchText = GetSearchText();
        Clear();
        dtTablesData = formMsg.GetFormMessages(searchText);

        if (dtTablesData != null)
        {
            dtTablesData.DefaultView.Sort = (hidSort.Value == "") ? "pTableID desc" : hidSort.Value;
            dgCountryCode.DataSource = dtTablesData.DefaultView.ToTable();
            dgCountryCode.DataBind();

            if (dtTablesData.Rows.Count == 1)
            {
                if (Page.IsPostBack)
                {
                    DisplayRecord();
                    btnSave.Visible = (CountrySecurity != "") ? true : false;
                    btnDelete.Visible = (CountrySecurity != "") ? true : false;
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

    }

    private void UpdatePanels()
    {

        upnlEntry.Update();       
        upnlbtnSearch.Update();
        upnlAdd.Update();
        upnlGrid.Update();
        pnlProgress.Update();
        upnlbtnsave.Update();
    }

    private string GetSearchText()
    {
        string _searchText = "TableType='FM'";

        if (ddlSearchMsgType.SelectedIndex != 0)
            _searchText += "AND FormMsgType='" + ddlSearchMsgType.SelectedItem.Value + "'";
        if (ddlSearcFrmType.SelectedIndex != 0)
            _searchText += "AND PrintDoc='" + ddlSearcFrmType.SelectedItem.Value + "'";
        if (ddlSearchLocation.SelectedIndex != 0)
            _searchText += "AND FormMsgLoc='" + ddlSearchLocation.SelectedItem.Value + "'";

        return _searchText;
    }

    private void DisableDropDowns()
    {
        ddlLocation.Enabled = false;
        ddlMsgType.Enabled = false;
        ddlFormType.Enabled = false;
    }

    private bool CheckDataExist(string mode)
    {
        string whereClause = "";
        if (mode == "Add")
        {
            whereClause = "PrintDoc='" + ddlFormType.Text + "' AND FormMsgLoc='" + ddlLocation.Text + "' AND FormMsgType='" + ddlMsgType.Text + "'";
        }
        else
        {
            whereClause = "PrintDoc='" + ddlFormType.Text + "' AND FormMsgLoc='" + ddlLocation.Text + "' AND FormMsgType='" + ddlMsgType.Text + "' AND pTableID <>" + hidPrimaryKey.Value;
        }

        DataSet dsCarrierCode = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                    new SqlParameter("@tableName", "[Tables]"),
                    new SqlParameter("@columnNames", "TableCd"),
                    new SqlParameter("@whereClause", whereClause));
            
        if (dsCarrierCode.Tables[0].Rows.Count > 0)
        {
            return false;
        }
        else
        {
            return true;
        }

    }

    private void BindBanchDropDown()
    {
        DataTable dtBranch = formMessages.GetKPIBranches();

        ddlLocation.DataSource = dtBranch;
        ddlLocation.DataTextField = "BranchDesc";
        ddlLocation.DataValueField = "Branch";
        ddlLocation.DataBind();

        ddlSearchLocation.DataSource = dtBranch;
        ddlSearchLocation.DataTextField = "BranchDesc";
        ddlSearchLocation.DataValueField = "Branch";
        ddlSearchLocation.DataBind();

        ddlLocation.Items.Insert(0, new ListItem("ALL",""));
        ddlSearchLocation.Items.Insert(0, new ListItem("ALL", ""));
    }

    protected void Clear()
    {
        try
        {            
            btnSave.Visible = false;
            btnDelete.Visible = false;
            ddlFormType.SelectedIndex = 0;
            ddlLocation.SelectedIndex = 0;
            ddlMsgType.SelectedIndex = 0;

            ddlLocation.Focus(); 
            lblChangeID.Text =  lblChangeDate.Text = lblEntryID.Text = lblEntryDate.Text = "";
            txtComments.Text = "";
            upnlEntry.Update();            
        }
        catch (Exception ex) { }
    }


    private void HighLightDropDown(DropDownList ddlFrom, string comboValueText)
    {
        ddlFrom.ClearSelection();
        for (int i = 0; i <= ddlFrom.Items.Count - 1; i++)
        {
            if (ddlFrom.Items[i].Value.Trim() == comboValueText.Trim())
                ddlFrom.Items[i].Selected = true;
        }
    }

    private void BindDropDown(DropDownList ddlFormFieldDtl,DropDownList ddlSearch, string listName)
    {
        try
        {
            string _whereClause = "a.pListMasterID=b.fListMasterID and a.ListName='" + listName + "' Order by b.SequenceNo";
            string _tableName = "listmaster a,ListDetail b ";
            string _columnName = "b.ListValue as ListValue,b.ListValue +' - ' +b.ListDtlDesc as ListDtlDesc";

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

                ddlSearch.DataSource = dslist.Tables[0];
                ddlSearch.DataTextField = "ListDtlDesc";
                ddlSearch.DataValueField = "ListValue";
                ddlSearch.DataBind();

            }
            ListItem item = new ListItem("     ---Select---     ", "");
            
            ddlFormFieldDtl.Items.Insert(0, item);
            ddlSearch.Items.Insert(0, item);
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

    protected void ibtnClear_Click(object sender, ImageClickEventArgs e)
    {
        ViewState["Operation"] = "Clear";
        ddlSearcFrmType.SelectedIndex = 0;
        ddlSearchLocation.SelectedIndex = 0;
        ddlSearchMsgType.SelectedIndex = 0;
        Clear();
        upnlbtnSearch.Update();        
        BindDataGrid();
        UpdatePanels();
    }

    private void SetTabIndex()
    {
        ddlSearchLocation.Attributes.Add("onkeydown", "if(event.which || event.keyCode)" +
        "{if ((event.which == 9) || (event.keyCode == 9) || (event.which == 13) || (event.keyCode == 13)) " +
        "{document.getElementById('" + ddlSearchMsgType.ClientID +
        "').focus();return false;}} else {return true}; ");
    }
}



