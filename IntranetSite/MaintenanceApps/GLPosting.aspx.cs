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
                Session["CountrySecurity"] = maintenanceUtils.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.GLPosting);                
                btnDelete.Attributes.Add("onclick", "return confirm('Are you sure you want to delete?');");
                ViewState["Mode"] = "Add";

                // Fill Data Entry Drop Down
                BindDropDown(ddlAppType, "GLTypeCd");
                BindDropDown(ddlCustCode, "GLCustCode");
                BindDropDown(ddlItemCode, "GLItemcd");
                BindBanchDropDown();      

                BindAccountsDropDown(ddlSales);
                BindAccountsDropDown(ddlInvMaterial);
                BindAccountsDropDown(ddlInvLabor);
                BindAccountsDropDown(ddlCOGSMaterial);
                BindAccountsDropDown(ddlCOGSLabor);
                BindAccountsDropDown(ddlSalesDiscount);
                BindAccountsDropDown(ddlARTrade);
                BindAccountsDropDown(ddlMiscellanous);
                                                
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
        UpdatePanels();        
    }

    protected void btncheck()
    {
        if (ViewState["Mode"].ToString() == "Add")
        {
            btnDelete.Visible = false;
        }

        if (ViewState["Mode"].ToString() == "Edit")
        {
            btnDelete.Visible = (CountrySecurity != "") ? true : false;
        }

        upnlbtnsave.Update();

    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        string whereClause = "ApplicationCd='" + ddlAppType.SelectedItem.Value.Trim().Trim() + "' AND " +
                                "LocationCd='" + ddlBrLocation.SelectedItem.Value.Trim().Replace("'", "''") + "' AND " +
                                 "OrganizationGLCd='" + ddlCustCode.SelectedItem.Value.Trim().Replace("'", "''") + "' AND " +
                                 "ItemGLCd='" + ddlItemCode.SelectedItem.Value.Trim().Replace("'", "''") + "' AND " +
                                 "GLSalesAcct='" + ddlSales.SelectedItem.Value.Trim().Replace("'", "''") + "' AND " +
                                 "GLInvMaterialAcct='" + ddlInvMaterial.SelectedItem.Value.Trim().Replace("'", "''") + "'  AND " +
                                 "GLInvLaborAcct='" + ddlInvLabor.SelectedItem.Value.Trim().Replace("'", "''") + "' AND " +
                                 "GLCOGSMaterialAcct='" + ddlCOGSMaterial.SelectedItem.Value.Trim().Replace("'", "''") + "' AND " +
                                 "GLCOGSLaborAcct='" + ddlCOGSLabor.SelectedItem.Value.Trim().Replace("'", "''") + "' AND " +
                                 "GLSalesDiscountAcct='" + ddlSalesDiscount.SelectedItem.Value.Trim().Replace("'", "''") + "' AND " +
                                 "GLARTradeAcct='" + ddlARTrade.SelectedItem.Value.Trim().Replace("'", "''") + "' AND " +
                                 "GLMiscAcct='" + ddlMiscellanous.SelectedItem.Value.Trim().Replace("'", "''") + "'";

        if (ViewState["Mode"].ToString() == "Add")
        {
            if (glPosting.CheckDataExist(whereClause))
            {
              string columnName = "ApplicationCd,LocationCd,OrganizationGLCd,ItemGLCd," +
                                "GLSalesAcct,GLInvMaterialAcct,GLInvLaborAcct,GLCOGSMaterialAcct," +
                                "GLCOGSLaborAcct,GLSalesDiscountAcct,GLARTradeAcct,GLMiscAcct,EntryID,EntryDt";

                string columnValue = "'" + ddlAppType.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "'" + ddlBrLocation.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "'" + ddlCustCode.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "'" + ddlItemCode.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "'" + ddlSales.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "'" + ddlInvMaterial.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "'" + ddlInvLabor.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "'" + ddlCOGSMaterial.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "'" + ddlCOGSLabor.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "'" + ddlSalesDiscount.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "'" + ddlARTrade.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "'" + ddlMiscellanous.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "'" + Session["UserName"] + "'," +
                                     "'" + DateTime.Now.ToShortDateString() + "'" ;

                glPosting.InsertTables(columnName,columnValue);
                DisplaStatusMessage(updateMessage, "Success");
                btnSave.Visible = false;
                btnDelete.Visible = false;
            }
            else
            {
                DisplaStatusMessage("GL Record Already Exists", "Fail");
                upnlGrid.Update();
                pnlProgress.Update();
                return;
            }
        }
        else
        {
            whereClause += " AND pGLPostingID <>" + hidPrimaryKey.Value.Trim();
            if (glPosting.CheckDataExist(whereClause))
            {

                string updateValue = "ApplicationCd='" + ddlAppType.SelectedItem.Value.Trim().Trim().Replace("'", "''") + "'," +
                                     "LocationCd='" + ddlBrLocation.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "OrganizationGLCd='" + ddlCustCode.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "ItemGLCd='" + ddlItemCode.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "GLSalesAcct='" + ddlSales.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "GLInvMaterialAcct='" + ddlInvMaterial.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "GLInvLaborAcct='" + ddlInvLabor.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "GLCOGSMaterialAcct='" + ddlCOGSMaterial.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "GLCOGSLaborAcct='" + ddlCOGSLabor.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "GLSalesDiscountAcct='" + ddlSalesDiscount.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "GLARTradeAcct='" + ddlARTrade.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "GLMiscAcct='" + ddlMiscellanous.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                     "ChangeID='" + Session["UserName"].ToString() + "'," +
                                     "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";

                glPosting.UpdateTables(updateValue, "pGLPostingID=" + hidPrimaryKey.Value.Trim());

                DisplaStatusMessage(updateMessage, "Success");
                btnSave.Visible = false;
                btnDelete.Visible = false;
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
            }            
            else
            {
                DisplaStatusMessage("GL Record Already Exists", "Fail");
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
            dtTablesData = glPosting.GetPostingRecords("pGLPostingID = '" + e.CommandArgument + "'");
            DisplayRecord();
            btncheck();
            btnSave.Visible = (CountrySecurity != "") ? true : false;            
        }
        if (e.CommandName == "Delete")
        {
            ViewState["Operation"] = "Delete";
            glPosting.DeleteTablesData(e.CommandArgument.ToString());
            BindDataGrid();
            DisplaStatusMessage(deleteMessage, "Success");            
            Clear();
        }
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
        UpdatePanels();        
    }

    protected void btnDelete_Click(object sender, ImageClickEventArgs e)
    {
        glPosting.DeleteTablesData(hidPrimaryKey.Value);
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
        hidPrimaryKey.Value = dtTablesData.Rows[0]["pGLPostingID"].ToString().Trim();
        HighLightDropDown(ddlAppType, dtTablesData.Rows[0]["ApplicationCd"].ToString().Trim());
        HighLightDropDown(ddlBrLocation, dtTablesData.Rows[0]["LocationCd"].ToString().Trim());
        HighLightDropDown(ddlCustCode, dtTablesData.Rows[0]["OrganizationGLCd"].ToString().Trim());
        HighLightDropDown(ddlItemCode, dtTablesData.Rows[0]["ItemGLCd"].ToString().Trim());
        HighLightDropDown(ddlSales, dtTablesData.Rows[0]["GLSalesAcct"].ToString().Trim());
        HighLightDropDown(ddlInvMaterial, dtTablesData.Rows[0]["GLInvMaterialAcct"].ToString().Trim());
        HighLightDropDown(ddlInvLabor, dtTablesData.Rows[0]["GLInvLaborAcct"].ToString().Trim());
        HighLightDropDown(ddlCOGSMaterial, dtTablesData.Rows[0]["GLCOGSMaterialAcct"].ToString().Trim());
        HighLightDropDown(ddlCOGSLabor, dtTablesData.Rows[0]["GLCOGSLaborAcct"].ToString().Trim());
        HighLightDropDown(ddlSalesDiscount, dtTablesData.Rows[0]["GLSalesDiscountAcct"].ToString().Trim());
        HighLightDropDown(ddlARTrade, dtTablesData.Rows[0]["GLARTradeAcct"].ToString().Trim());
        HighLightDropDown(ddlMiscellanous, dtTablesData.Rows[0]["GLMiscAcct"].ToString().Trim());
        
        lblEntryID.Text = dtTablesData.Rows[0]["EntryID"].ToString().Trim();
        //lblEntryDate.Text = Convert.ToDateTime(dtTablesData.Rows[0]["EntryDt"].ToString()).ToShortDateString();
        lblChangeID.Text = dtTablesData.Rows[0]["ChangeID"].ToString().Trim();
        //lblChangeDate.Text = (dtTablesData.Rows[0]["ChangeDt"].ToString().Trim() != "" ? Convert.ToDateTime(dtTablesData.Rows[0]["ChangeDt"].ToString()).ToShortDateString():"");
        lblChangeDate.Text = (dtTablesData.Rows[0]["ChangeDt"].ToString() == "") ? "" : Convert.ToDateTime(dtTablesData.Rows[0]["ChangeDt"].ToString()).ToShortDateString();
        lblEntryDate.Text = (dtTablesData.Rows[0]["EntryDt"].ToString() == "") ? "" : Convert.ToDateTime(dtTablesData.Rows[0]["EntryDt"].ToString()).ToShortDateString();
       
    }

    private void BindDataGrid()
    {
        string searchText = GetSearchText();
        Clear();
        dtTablesData = glPosting.GetDataGridPostingRecords(searchText);

        if (dtTablesData != null)
        {
            dtTablesData.DefaultView.Sort = (hidSort.Value == "") ? "pGLPostingID desc" : hidSort.Value;
            dgCountryCode.DataSource = dtTablesData.DefaultView.ToTable();
            dgCountryCode.DataBind();

            if (dtTablesData.Rows.Count == 1)
            {
                if (Page.IsPostBack)
                {
                    //
                    // Fetch Data From Table
                    //
                    hidPrimaryKey.Value = dtTablesData.Rows[0]["pGLPostingID"].ToString().Trim();
                    dtTablesData = glPosting.GetPostingRecords("pGLPostingID = '" + hidPrimaryKey.Value + "'");
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
        string _searchText = "";

        if (ddlSearch.SelectedIndex == 0 || txtSearchText.Text.Trim() == "")
            _searchText = "1=1 Order by pGLPostingID Desc";        
        else
            _searchText = ddlSearch.SelectedItem.Value + " Like '%" + txtSearchText.Text + "%' Order by pGLPostingID Desc";
        
        return _searchText;
    }

    private void DisableDropDowns()
    {
        ddlAppType.Enabled = false;
    }

    private void BindBanchDropDown()
    {
        DataTable dtBranch = maintenanceUtils.GetKPIBranches();

        ddlBrLocation.DataSource = dtBranch;
        ddlBrLocation.DataTextField = "BranchDesc";
        ddlBrLocation.DataValueField = "Branch";
        ddlBrLocation.DataBind();
        ListItem item = new ListItem("     ---Select---     ","");
        ddlBrLocation.Items.Insert(0, item);
    }

    protected void Clear()
    {
        try
        {            
            btnSave.Visible = false;
            btnDelete.Visible = false;
            ddlAppType.SelectedIndex = 0;
            ddlARTrade.SelectedIndex = 0;
            ddlBrLocation.SelectedIndex = 0;
            ddlCOGSLabor.SelectedIndex = 0;
            ddlCOGSMaterial.SelectedIndex = 0;
            ddlCustCode.SelectedIndex = 0;
            ddlInvLabor.SelectedIndex = 0;
            ddlInvMaterial.SelectedIndex = 0;
            ddlItemCode.SelectedIndex = 0;
            ddlMiscellanous.SelectedIndex = 0;
            ddlSales.SelectedIndex = 0;
            ddlSalesDiscount.SelectedIndex = 0;            
            
            lblChangeID.Text =  lblChangeDate.Text = lblEntryID.Text = lblEntryDate.Text = "";            
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
            string _columnName = "AccountNo,AccountNo +'-'+AccountDescription as AccountDescription";
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
        txtSearchText.Attributes.Add("onkeydown", "if(event.which || event.keyCode)" +
        "{if ((event.which == 9) || (event.keyCode == 9)) " +
        "{document.getElementById('" + ddlAppType.ClientID +
        "').focus();return false;}} else {return true}; ");
    }
}



