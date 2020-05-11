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
    AppPref AppPref = new AppPref();
    MaintenanceUtility maintenanceUtility = new MaintenanceUtility();
    private DataTable dtAppPrefData = new DataTable();
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

            if (!Page.IsPostBack)            
            {

                lnkCode.Attributes.Add("onclick", "Javascript:ShowDetail(this.id);return false;");
                //Session["CountrySecurity"] = "asd";
                Session["CountrySecurity"] = maintenanceUtility.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.AppPref);

                ViewState["Mode"] = "Add";
                BindDataGrid();                
            }

            if (CountrySecurity == "")
                 EnableQueryMode();
        
    }
   
    protected void btnSearch_Click(object sender, ImageClickEventArgs e)
    {
        ViewState["Mode"] = "Add";
        Clear();

        BindDataGrid();
        UpdatePanels();
    }   

    protected void dgAppPref_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            dtAppPrefData = AppPref.GetAppPrefData( e.CommandArgument.ToString() );
            DisplayRecord();
            btnSave.Visible = (CountrySecurity != "") ? true : false;
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "focus", "document.getElementById(('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
        }
        if (e.CommandName == "Delete")
        {
            ViewState["Operation"] = "Delete";
            AppPref.DeleteData(e.CommandArgument.ToString());
            BindDataGrid();
            DisplaStatusMessage(deleteMessage, "Success");
            Clear();
        }

        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
        UpdatePanels();
    }

    protected void dgAppPref_SortCommand(object source, DataGridSortCommandEventArgs e)
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
    /// dgAppPref :Item data bound event handlers
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    /// 
    protected void dgAppPref_ItemDataBound(object sender, DataGridItemEventArgs e)
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

        hidPrimaryKey.Value = dtAppPrefData.Rows[0]["pAppPrefID"].ToString().Trim();
        txtCode.Text = dtAppPrefData.Rows[0]["ApplicationCd"].ToString().Trim();
        txtCode.Enabled = false;
        txtType.Text = dtAppPrefData.Rows[0]["AppOptionType"].ToString().Trim();
        txtValue.Text = dtAppPrefData.Rows[0]["AppOptionValue"].ToString().Trim();
        txtNumber.Text = (dtAppPrefData.Rows[0]["AppOptionNumber"].ToString() != "" ? Math.Round(Convert.ToDecimal(dtAppPrefData.Rows[0]["AppOptionNumber"].ToString()),2).ToString() : ""); dtAppPrefData.Rows[0]["AppOptionNumber"].ToString().Trim();
        txtComments.Text = dtAppPrefData.Rows[0]["AppOptionTypeDesc"].ToString().Trim();



        lblEntryID.Text = dtAppPrefData.Rows[0]["EntryID"].ToString().Trim();
        lblEntryDate.Text = (dtAppPrefData.Rows[0]["EntryDt"].ToString() != "" ? Convert.ToDateTime(dtAppPrefData.Rows[0]["EntryDt"].ToString()).ToShortDateString() : ""); 
        lblChangeID.Text = dtAppPrefData.Rows[0]["ChangeID"].ToString().Trim();
        lblChangeDate.Text = (dtAppPrefData.Rows[0]["ChangeDt"].ToString() != "" ? Convert.ToDateTime(dtAppPrefData.Rows[0]["ChangeDt"].ToString()).ToShortDateString() : "");


   }

    private void BindDataGrid()
   {
        dtAppPrefData = AppPref.GetAppPrefData();
        if (dtAppPrefData != null)
        {
            
            dtAppPrefData.DefaultView.Sort = (hidSort.Value == "") ? "pAppPrefID desc" : hidSort.Value;
            dgAppPref.DataSource = dtAppPrefData.DefaultView.ToTable();
            dgAppPref.DataBind();
        }
        else
            DisplaStatusMessage("No Records Found", "Fail");
   }

    private void UpdatePanels()
    {

        upnlEntry.Update();
        upnlbtnsave.Update();
        upnlGrid.Update();
        pnlProgress.Update();
    }

    protected void Clear()
    {
        try
        {
            btnSave.Visible = false;

            txtCode.Focus();
            lblChangeID.Text = lblChangeDate.Text = lblEntryID.Text = lblEntryDate.Text = "";
            txtCode.Text = txtNumber.Text = txtType.Text = txtComments.Text = txtValue.Text = "";
            upnlEntry.Update();

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
        btnSave.Visible = false;
        //btnAdd.Visible = false;
    }

    protected void btnSave_Click1(object sender, ImageClickEventArgs e)
    {
        if (ViewState["Mode"].ToString() == "Add")
        {
                string columnName = "ApplicationCd,AppOptionType,AppOptionValue,AppOptionNumber,AppOptionTypeDesc,"
                                    + "EntryID,EntryDt";
                string columnValue = "'" + txtCode.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + txtType.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + txtValue.Text.Trim().Replace("'", "''") + "'," +
                                    (txtNumber.Text.Trim().Replace("'", "''") != "" ? txtNumber.Text.Trim()  : "NULL" )+"," +
                                    "'" + txtComments.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + Session["UserName"] + "'," +
                                    "'" + DateTime.Now.ToShortDateString() + "'";

                AppPref.InsertTables(columnName, columnValue);
                DisplaStatusMessage(updateMessage, "Success");

        }
        else
        {
                string updateValue = "ApplicationCd='" + txtCode.Text.Trim().Replace("'", "''") + "'," +
                                      "AppOptionType='" + txtType.Text.Trim().Replace("'", "''") + "'," +
                                      "AppOptionValue='" + txtValue.Text.Trim().Replace("'", "''") + "'," +
                                      "AppOptionTypeDesc='" + txtComments.Text.Trim().Replace("'", "''") + "'," +
                                      "AppOptionNumber=" + (txtNumber.Text.Trim().Replace("'", "''") != "" ? txtNumber.Text.Trim() : "NULL") + "," +
                                      "ChangeID='" + Session["UserName"].ToString() + "'," +
                                      "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";
                AppPref.UpdateAppPrefData(updateValue, "pAppPrefID=" + hidPrimaryKey.Value.Trim());
                DisplaStatusMessage(updateMessage, "Success");
                ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
        }

        ViewState["Operation"] = "Save";
        Clear();
        BindDataGrid();
        UpdatePanels();

        
    }

    protected void btnAdd_Click1(object sender, ImageClickEventArgs e)
    {
        BindDataGrid();
        Clear();
        ViewState["Mode"] = "Add";
        txtCode.Enabled = true;
        btnSave.Visible = (CountrySecurity != "") ? true : false;
        txtCode.Focus();
        UpdatePanels();
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "FocusControl", "document.getElementById('txtCode').focus();", true);
    }
}