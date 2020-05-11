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

public partial class StandardComments : System.Web.UI.Page
{
    int count;
    StandardComment standardComment = new StandardComment();
    MaintenanceUtility maintanceUtility = new MaintenanceUtility();
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
        
        ViewState["Operation"] = "";
        lblMessage.Text = "";
        
       // Session["UserName"] = "intranet";
        
        if (!Page.IsPostBack)
        {
            SetTabIndex();
            Session["CountrySecurity"] = null;
            lnkCode.Attributes.Add("onclick", "Javascript:ShowToolTipAtTop(this.id);return false;");
            Session["CountrySecurity"] = maintanceUtility.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.StandardComments);
            //Session["CountrySecurity"] = "testing";
            btnDelete.Attributes.Add("onclick", "return confirm('Are you sure you want to delete?');");

            // Fill dropdowns
            BindDropDown(ddlCommentLoc, "LocOnDoc");
            BindDropDown(ddlDocType, "FormType");

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
            bool CountryCode = standardComment.CheckDataExist(txtCode.Text.Trim(),MaintenaceTable.ClassofTrade);
            if (CountryCode)
            {
                string columnName = "StdCommentsCd,CommentLocOnDoc,DocumentType,[NoOfSpaces],Comments,GLAppInd,APAppInd,ARAppInd,SOAppInd,POAppInd,IMAppInd,WMAppInd,WOAppInd,MMAppInd,SMAppInd,EntryID,EntryDt,ChangeID,ChangeDt";
                
                string columnValue = "'" + txtCode.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + ddlCommentLoc.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                    "'" + ddlDocType.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                    "'" + txtSpace.Text.Trim().Replace("'", "''") + "'," +
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
                                    "'" + DateTime.Now.ToShortDateString() + "'" ;

                standardComment.InsertTables(columnName,columnValue);
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
        else
        {
            string updateValue = "CommentLocOnDoc='" + ddlCommentLoc.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                "DocumentType='" + ddlDocType.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                "Comments='" + txtComments.Text.Trim().Replace("'", "''") + "'," +
                                "NoOfSpaces='" + txtSpace.Text.Trim().Replace("'", "''") + "'," +
                                "GLAppInd='" + ((chkSelection.Items[0].Selected == true) ? "Y" : "") + "'," +
                                "APAppInd='" + ((chkSelection.Items[1].Selected == true) ? "Y" : "") + "'," +
                                "ARAppInd='" + ((chkSelection.Items[2].Selected == true) ? "Y" : "") + "'," +
                                "SOAppInd='" + ((chkSelection.Items[3].Selected == true) ? "Y" : "") + "'," +
                                "POAppInd='" + ((chkSelection.Items[4].Selected == true) ? "Y" : "") + "'," +
                                "IMAppInd='" + ((chkSelection.Items[5].Selected == true) ? "Y" : "") + "'," +
                                "WMAppInd='" + ((chkSelection.Items[6].Selected == true) ? "Y" : "") + "'," +
                                "WOAppInd='" + ((chkSelection.Items[7].Selected == true) ? "Y" : "") + "'," +
                                "MMAppInd='" + ((chkSelection.Items[8].Selected == true) ? "Y" : "") + "'," +
                                "SMAppInd='" + ((chkSelection.Items[9].Selected == true) ? "Y" : "") + "'," +
                                "ChangeID='" + Session["UserName"].ToString() + "'," +
                                "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";

            standardComment.UpdateTables(updateValue, "StdCommentsID=" + hidPrimaryKey.Value.Trim());

            DisplaStatusMessage(updateMessage, "Success");
            btnSave.Visible = false;
            btnDelete.Visible = false;
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
            dtTablesData = standardComment.GetTablesData("StdCommentsID = '" + e.CommandArgument + "'");
            DisplayRecord();
            btncheck();
            btnSave.Visible = (CountrySecurity != "") ? true : false;
            ScriptManager.RegisterClientScriptBlock(txtComments, txtComments.GetType(), "focud", "document.getElementById('" + txtComments.ClientID + "').select();document.getElementById('" + txtComments.ClientID + "').focus();", true);
        }
        if (e.CommandName == "Delete")
        {
            ViewState["Operation"] = "Delete";
            standardComment.DeleteTablesData(e.CommandArgument.ToString());
            BindDataGrid();
            DisplaStatusMessage(deleteMessage, "Success");            
            Clear();
        }
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
        UpdatePanels();        
    }

    protected void btnDelete_Click(object sender, ImageClickEventArgs e)
    {
        standardComment.DeleteTablesData(hidPrimaryKey.Value);
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
        txtCode.Text = dtTablesData.Rows[0]["StdCommentsCd"].ToString().Trim();
        txtCode.Enabled = false;
        HighLightDropDown(ddlCommentLoc, dtTablesData.Rows[0]["CommentLocOnDoc"].ToString().Trim());
        HighLightDropDown(ddlDocType, dtTablesData.Rows[0]["DocumentType"].ToString().Trim());
        txtComments.Text = dtTablesData.Rows[0]["Comments"].ToString().Trim();
        txtSpace.Text = dtTablesData.Rows[0]["NoOfSpaces"].ToString().Trim();

        lblEntryID.Text = dtTablesData.Rows[0]["EntryID"].ToString().Trim();
        //lblEntryDate.Text = Convert.ToDateTime(dtTablesData.Rows[0]["EntryDt"].ToString()).ToShortDateString();
        lblChangeID.Text = dtTablesData.Rows[0]["ChangeID"].ToString().Trim();
        //lblChangeDate.Text = Convert.ToDateTime(dtTablesData.Rows[0]["ChangeDt"].ToString()).ToShortDateString();
        lblChangeDate.Text = (dtTablesData.Rows[0]["ChangeDt"].ToString() == "") ? "" : Convert.ToDateTime(dtTablesData.Rows[0]["ChangeDt"].ToString()).ToShortDateString();
        lblEntryDate.Text = (dtTablesData.Rows[0]["EntryDt"].ToString() == "") ? "" : Convert.ToDateTime(dtTablesData.Rows[0]["EntryDt"].ToString()).ToShortDateString();
        if (dtTablesData.Rows[0]["GLAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[0].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[0].Selected = false;

        }
        if (dtTablesData.Rows[0]["APAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[1].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[1].Selected = false;
        }

        if (dtTablesData.Rows[0]["ARAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[2].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[2].Selected = false;

        }


        if (dtTablesData.Rows[0]["SOAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[3].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[3].Selected = false;

        }

        if (dtTablesData.Rows[0]["POAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[4].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[4].Selected = false;

        }


        if (dtTablesData.Rows[0]["IMAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[5].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[5].Selected = false;

        }


        if (dtTablesData.Rows[0]["WMAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[6].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[6].Selected = false;

        }

        if (dtTablesData.Rows[0]["WOAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[7].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[7].Selected = false;

        }

        if (dtTablesData.Rows[0]["MMAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[8].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[8].Selected = false;

        }

        if (dtTablesData.Rows[0]["SMAppInd"].ToString().Trim() == "Y")
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
        string searchText = (txtSearchCode.Text == "" ? " 1=1 " : " StdCommentsCd like '%" + txtSearchCode.Text + "%'");
        dtTablesData = standardComment.GetTablesData(searchText);

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
            txtCode.Text =  txtComments.Text = txtSpace.Text  ="";
            ddlDocType.ClearSelection();
            ddlCommentLoc.ClearSelection();
            upnlEntry.Update();
            upnlchkSelectAll.Update();
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

    private void BindDropDown(DropDownList ddlFormFieldDtl, string listName)
    {
        try
        {
            string _whereClause = "a.pListMasterID=b.fListMasterID and a.ListName='" + listName + "' Order by b.SequenceNo";
            string _tableName = "listmaster a,ListDetail b ";
            string _columnName = "b.ListValue as ListValue,b.ListValue + ' - '+ b.ListDtlDesc as ListDtlDesc";

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



