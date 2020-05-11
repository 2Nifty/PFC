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

using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;

public partial class CountryCodeMaster : System.Web.UI.Page
{
    int count;
    MaintenanceUtility expediteCode = new MaintenanceUtility();
    private DataTable dtTablesData = new DataTable();

    string updateMessage = "Data has been successfully updated";
    string deleteMessage = "Data has been successfully deleted";

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
        
        ViewState["Operation"] = "";
        lblMessage.Text = "";
        SetTabIndex();
        
        if (!Page.IsPostBack)
        {
            lnkCode.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");
            Session["CountrySecurity"] = expediteCode.GetSecurityCode(Session["UserName"].ToString(),MaintenaceTable.ExpediteCodes);
            //Session["CountrySecurity"] = "testing";
            btnDelete.Attributes.Add("onclick", "return confirm('Are you sure you want to delete?');");
            ViewState["Mode"] = "Add";
            BindDataGrid();
            btncheck();

        }

        if (CountrySecurity == "")
            EnableQueryMode();

    }

    protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
        BindDataGrid();
        Clear();
        ViewState["Mode"] = "Add";
        txtCode.Enabled = true;
        btncheck();
        btnSave.Visible = (CountrySecurity != "") ? true : false;
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
            btnDelete.Visible = (CountrySecurity != "") ? true : false;
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
            bool CountryCode = expediteCode.CheckDataExist(txtCode.Text.Trim(),MaintenaceTable.ExpediteCodes);
            if (CountryCode)
            {
                string columnName = "TableCd,Dsc,ShortDsc,Comments,GLApp,APApp,ARApp,SOApp,POApp,IMApp,WMApp,WOApp,MMApp,SMApp,EntryID,EntryDt,ChangeID,ChangeDt,TableType";
                string columnValue = "'" + txtCode.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + txtDescription.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + txtShortDesc.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + txtComments.Text.Trim().Replace("'", "''") + "'," +
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
                                    "'" + Session["UserName"] + "'," +
                                    "'" + DateTime.Now.ToShortDateString() + "','EXPD'";

                expediteCode.InsertTables(columnName,columnValue);
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
            string updateValue = "TableCd='" + txtCode.Text.Trim().Replace("'", "''") + "'," +
                            "Dsc='" + txtDescription.Text.Trim().Replace("'", "''") + "'," +
                            "ShortDsc='" + txtShortDesc.Text.Trim().Replace("'", "''") + "'," +
                            "Comments='" + txtComments.Text.Trim().Replace("'", "''") + "'," +
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

            expediteCode.UpdateTables(updateValue, "pTableID=" + hidPrimaryKey.Value.Trim());

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

    protected void dgCountryCode_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            dtTablesData = expediteCode.GetTablesData("pTableID = '" + e.CommandArgument + "'");
            DisplayRecord();
            btncheck();
            btnSave.Visible = (CountrySecurity != "") ? true : false;
            ScriptManager.RegisterClientScriptBlock(txtDescription, txtDescription.GetType(), "focud", "document.getElementById('" + txtDescription.ClientID + "').select();document.getElementById('" + txtDescription.ClientID + "').focus();", true);
        }
        if (e.CommandName == "Delete")
        {
            ViewState["Operation"] = "Delete";
            expediteCode.DeleteTablesData(e.CommandArgument.ToString());
            BindDataGrid();
            DisplaStatusMessage(deleteMessage, "Success");
            Clear();
        }
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
        UpdatePanels();        
    }

    protected void btnDelete_Click(object sender, ImageClickEventArgs e)
    {
        expediteCode.DeleteTablesData(hidPrimaryKey.Value);
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

    private void DisplayRecord()
    {
        ViewState["Mode"] = "Edit";
        
        btncheck();
        hidPrimaryKey.Value = dtTablesData.Rows[0]["pTableID"].ToString().Trim();
        txtCode.Text = dtTablesData.Rows[0]["TableCd"].ToString().Trim();
        txtCode.Enabled = false;
        txtDescription.Text = dtTablesData.Rows[0]["Dsc"].ToString().Trim();
        txtShortDesc.Text = dtTablesData.Rows[0]["ShortDsc"].ToString().Trim();
        txtComments.Text = dtTablesData.Rows[0]["Comments"].ToString().Trim();

        lblEntryID.Text = dtTablesData.Rows[0]["EntryID"].ToString().Trim();
       // lblEntryDate.Text = Convert.ToDateTime(dtTablesData.Rows[0]["EntryDt"].ToString()).ToShortDateString();
        lblChangeID.Text = dtTablesData.Rows[0]["ChangeID"].ToString().Trim();
        lblChangeDate.Text = (dtTablesData.Rows[0]["ChangeDt"].ToString() == "") ? "" : Convert.ToDateTime(dtTablesData.Rows[0]["ChangeDt"].ToString()).ToShortDateString();
        lblEntryDate.Text = (dtTablesData.Rows[0]["EntryDt"].ToString() == "") ? "" : Convert.ToDateTime(dtTablesData.Rows[0]["EntryDt"].ToString()).ToShortDateString();

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
        string searchText = (txtSearchCode.Text == "" ? "TableType='EXPD'" : "TableType='EXPD' AND TableCd like '%" + txtSearchCode.Text + "%'");
        dtTablesData = expediteCode.GetTablesData(searchText);

        if (dtTablesData != null)
        {
            dtTablesData.DefaultView.Sort = (hidSort.Value == "") ? "TableCd asc" : hidSort.Value;
            dgCountryCode.DataSource = dtTablesData.DefaultView.ToTable();
            dgCountryCode.DataBind();

            if (dtTablesData.Rows.Count == 1)
            {
                if (Page.IsPostBack)
                {
                    DisplayRecord();
                    btnSave.Visible = (CountrySecurity != "") ? true : false;
                    btnDelete.Visible = (CountrySecurity != "") ? true : false;
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
            txtCode.Text =  txtDescription.Text = txtShortDesc.Text  = txtComments.Text = "";
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
    protected void dgCountryCode_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if ((e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item) && CountrySecurity == "")
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
}



