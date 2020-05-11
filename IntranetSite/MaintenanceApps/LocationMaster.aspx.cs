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
using System.Threading;
using System.IO;
using System.Reflection;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
using PFC.IntranetSite.MaintenanceApps;

public partial class LocationMasterPage : System.Web.UI.Page
{
    #region Variable declaration

    string connectionString ;
    private LocationMaster locationMaster;
    private DataTable dtLCM = new DataTable();

    private DataTable dtLocationMaster = new DataTable();

    string updateMessage = "Data has been successfully updated";
    string deleteMessage = "Data has been successfully deleted";
    string ccMessage = "Location Code already exist"; 
    #endregion

    /// <summary>
    /// Security ReadOnly Property : Get current user's security Code
    /// </summary>
    protected string LocationMasterSecurity
    {
        get
        {
            return Session["LocationMasterSecurity"].ToString();
        }
    }

    #region Page Load Handlers
    protected void Page_Load(object sender, EventArgs e)
    {
        lblMessage.Text = "";
       
        locationMaster = new LocationMaster();
        // Register AJAX
        Ajax.Utility.RegisterTypeForAjax(typeof(LocationMasterPage));
        //connectionString = PFC.Intranet.MaintenanceApps.MaintenanceUtility.GetConnectionString();
        connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        if (!Page.IsPostBack)
        {
            Session["UserID"] = ((Session["UserID"] != null) ? Session["UserID"].ToString() : "01");
            Session["UserName"] = ((Session["UserName"] != null) ? Session["UserName"].ToString() : "intranet");
            Session["LocationMasterSecurity"] = locationMaster.GetSecurityCode(Session["UserName"].ToString());
            BindInformationList();
            BindDataGrid();

        }
        ImageButton btnOptionClose = ucOption.FindControl("btnOptionClose") as ImageButton;
        ImageButton btnWarehouseClose = ucWarehouse.FindControl("btnWarehouseClose") as ImageButton;
        ImageButton btnPrinterClose = ucPrinter.FindControl("btnPrintClose") as ImageButton;
        btnOptionClose.Click += new ImageClickEventHandler(btnOptionClose_Click);
        btnWarehouseClose.Click += new ImageClickEventHandler(btnOptionClose_Click);
        btnPrinterClose.Click += new ImageClickEventHandler(btnOptionClose_Click);

        ImageButton btnOptionSave = ucOption.FindControl("btnSave") as ImageButton;
        ImageButton btnWarehouseSave = ucWarehouse.FindControl("btnSave") as ImageButton;
        ImageButton btnPrinterSave = ucPrinter.FindControl("btnSave") as ImageButton;
        btnOptionSave.Click += new ImageClickEventHandler(btnOptionSave_Click);
        btnWarehouseSave.Click += new ImageClickEventHandler(btnOptionSave_Click);
        btnPrinterSave.Click += new ImageClickEventHandler(btnOptionSave_Click);

        if (LocationMasterSecurity == "")
            EnableQueryMode();
    } 
    #endregion

    #region Event Handlers
    protected void dgLocation_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            if (LocationMasterSecurity == "")
            {
                LinkButton lnkDelete = e.Item.FindControl("lnkDelete") as LinkButton;
                lnkDelete.Visible = false;
            }
        }
    }

    protected void dgLocation_SortCommand(object source, DataGridSortCommandEventArgs e)
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

    protected void dgLocation_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {

            dtLCM = GetLocationCode(e.Item.Cells[0].Text.ToString().Trim());
            FillFormControls(dtLCM);
            hidMode.Value = "Update";

            btnSave.Visible = (LocationMasterSecurity != "") ? true : false;
            EnableAddMode(false);
            UpdatePanels();
            ToggleLink(true);
            ScriptManager.RegisterClientScriptBlock(txtAddress1, txtAddress1.GetType(), "focud", "document.getElementById('" + txtAddress1.ClientID + "').select();document.getElementById('" + txtAddress1.ClientID + "').focus();", true);
        }
        if (e.CommandName == "Delete")
        {
            try
            {
                locationMaster.DeleteLocationMaster(e.CommandArgument.ToString().Trim());
                BindDataGrid();
                ClearControls();
                hidMode.Value = "New";
                EnableAddMode(true);
                btnSave.Visible = false;
                DisplaStatusMessage(deleteMessage, "success");

            }
            catch (Exception ex)
            {
                DisplaStatusMessage(ex.Message.ToString(), "Fail");
            }
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
            UpdatePanels();
        }
    }

    protected void SearchButton_Click(object sender, ImageClickEventArgs e)
    {
        DisplayAddMode();
        UpdatePanels();
    }

    protected void SaveButton_Click(object sender, ImageClickEventArgs e)
    {
        if (hidMode.Value == "Update")
        {
            #region Update Value
            string _WhereClause = "LocID ='" + txtSearchCode.Text.ToString().Trim() + "'";
            string _ColumnValues = "LocName='" + txtSearchName.Text.ToString().Trim() +
                                    "',LocAdress1='" + txtAddress1.Text.ToString().Trim().Replace("'", "''") +
                                    "',LocAdress2='" + txtAddress2.Text.ToString().Trim().Replace("'", "''") +
                                    "',LocCity='" + txtCity.Text.ToString().Trim().Replace("'", "''") +
                                    "',LocState='" + ddlState.SelectedValue.ToString().Trim().Replace("'", "''") +
                                    "',LocPostCode='" + txtPostalCode.Text.ToString().Trim().Replace("'", "''") +
                                    "',LocCountry='" + ddlCountry.SelectedValue.ToString().Trim().Replace("'", "''") +
                                    "',LocTimeZone='" + ddlTimeZone.SelectedValue.ToString().Trim().Replace("'", "''") +
                                    "',SrvrTimeZone='" + ddlServerTimeZone.SelectedValue.ToString().Trim().Replace("'", "''") +
                                    "',LocContact='" + txtName.Text.ToString().Trim().Replace("'", "''") +
                                    "',LocPhone='" + txtPhone.Text.ToString().Trim().Replace("'", "''") +
                                    "',LocFax='" + txtFax.Text.ToString().Trim().Replace("'", "''") +
                                    "',LocEmail='" + txtEmail.Text.ToString().Trim().Replace("'", "''") +
                                    "',LocType='" + ddlType.SelectedValue.ToString().Trim() +
                                    "',HubSort='" + txtHubSort.Text.ToString().Trim().Replace("'", "''") +
                                    "',WarehouseInd='" + ddlWarehouse.SelectedValue.ToString().Trim() +
                                    "',IMBranchSort='" + txtBranchSort.Text.ToString().Trim() +
                                    "',IMDisplayColor='" + ddlColor.SelectedValue.ToString().Trim() +
                                    "',ChangeID='" + Session["UserName"].ToString().Trim().Replace("'", "''") + "'," +
                                    " ChangeDt='" + DateTime.Now.ToString() + "'";

            locationMaster.UpdateLocationMaster(_ColumnValues, _WhereClause);
            BindDataGrid();
            DisplaStatusMessage(updateMessage, "Success");

            #endregion
        }
        UpdatePanels();
    }

    protected void btnTopAdd_Click(object sender, ImageClickEventArgs e)
    {
        hidMode.Value = "";
        if (hidMode.Value == "New" || hidMode.Value == "")
        {
            #region Inset value
            bool result = locationMaster.CheckLocationMasterExist(txtSearchCode.Text);

            if (result)
            {
                string _columnNames = "LocID,LocName,EntryID,EntryDt";

                string _columnValues = "'" + txtSearchCode.Text.Replace("'", "''") + "','" +
                        txtSearchName.Text.Trim().Replace("'", "''") + "','" +
                        Session["UserName"].ToString().Trim() + "','" +
                        DateTime.Now.ToString() + "'";

                locationMaster.InsertLocationMaster(_columnNames, _columnValues);

                hidMode.Value = "Update";
                DisplaStatusMessage(updateMessage, "Success");
                EnableAddMode(false);
                ToggleLink(true);
                lnkPhone.Attributes.Add("onclick", "javascript:return ShowToolTip(event,'phone',this.id);");
                lnkPostalCode.Attributes.Add("onclick", "javascript:return ShowToolTip(event,'postcode',this.id);");
                lnkEmail.Attributes.Add("onclick", "javascript:return ShowToolTip(event,'email',this.id);");
                lnkShipFrom.Attributes.Add("onclick", "javascript:return ShowToolTip(event,'ship',this.id);");
                UpdatePanels();
            }
            else
            {
                DisplaStatusMessage(ccMessage, "Fail");
            }
            #endregion
        }
    }

    protected void AddButton_Click(object sender, ImageClickEventArgs e)
    {
        ClearControls();
        EnableAddMode(true);
        UpdatePanels();
        ToggleLink(false);
        CloseEvent();
    }

    protected void btnDelete_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            locationMaster.DeleteLocationMaster(hidpCar.Value);
            BindDataGrid();
            ClearControls();
            btnSave.Visible = false;
            DisplaStatusMessage(deleteMessage, "success");
            UpdatePanels();

        }
        catch (Exception ex)
        {
            DisplaStatusMessage(ex.Message.ToString(), "Fail");
        }
    }

    protected void btnOptionClose_Click(object sender, ImageClickEventArgs e)
    {
        HideAllControls();
    }

    protected void btnOptionSave_Click(object sender, ImageClickEventArgs e)
    {
        DisplaStatusMessage(updateMessage, "success");
    }

    protected void lnkOptions_Click(object sender, EventArgs e)
    {
        LinkButton ctrl = sender as LinkButton;

        string searchText = "";

        searchText = "LocID = '" + txtSearchCode.Text.Trim() + "'";


        dtLocationMaster = locationMaster.GetLocationMaster(searchText);

        HideAllControls();

        if (ctrl.ID == "lnkOptions")
        {
            tdOption.Style.Add(HtmlTextWriterStyle.Display, "");
            ucOption.SetOptionsValue = dtLocationMaster;
            pnlOption.Update();
        }
        else if (ctrl.ID == "lnkWarehouse")
        {
            tdWarehouse.Style.Add(HtmlTextWriterStyle.Display, "");
            ucWarehouse.SetWarehouseValue = dtLocationMaster;
            pnlWarehouse.Update();
        }
        else if (ctrl.ID == "lnkPrinters")
        {
            tdPrinter.Style.Add(HtmlTextWriterStyle.Display, "");
            ucPrinter.SetPrinterValue = dtLocationMaster;
            pnlPrinter.Update();
        }
    }

    protected void ibtnFSave_Click(object sender, ImageClickEventArgs e)
    {
        string updateValue = "";
        string javascript = "";

        switch (hidFMode.Value)
        {
            case "phone":
                javascript = "document.getElementById('txtPhone').select();document.getElementById('txtPhone').focus();";
                hidPhone.Value = txtFormat.Text.Trim();
                txtPhone.Text = FormatContent(txtFormat.Text.Trim(), txtPhone.Text);
                updateValue = "PhoneFmt='" + txtFormat.Text.Trim().Replace("'", "''") + "',LocPhone='" + txtPhone.Text;
            break;
            case "postcode":
                javascript = "document.getElementById('txtPostalCode').select();document.getElementById('txtPostalCode').focus();";
                hidPostalCode.Value = txtFormat.Text.Trim();
                txtPostalCode.Text = FormatContent(txtFormat.Text.Trim(), txtPostalCode.Text);
                updateValue = "PostCodeFmt='" + txtFormat.Text.Trim().Replace("'", "''") + "',LocPostCode='" + txtPostalCode.Text;
            break;
            case "email":
                javascript = "document.getElementById('txtEmail').select();document.getElementById('txtEmail').focus();";
                txtEmail.Text = txtLocEmail.Text.Trim();
                hidLocEmail.Value = txtLocEmail.Text.Trim();
                hidBOEmail.Value = txtBOEmail.Text.Trim();
                hidBigQuoteEmail.Value = txtBigQuoteEmail.Text.Trim();
                hidRGAEmail.Value = txtRGAEmail.Text.Trim();
                updateValue = "LocEmail='" + txtLocEmail.Text.ToString().Trim().Replace("'", "''") +
                              "',BOEmailAddress='" + txtBOEmail.Text.ToString().Trim().Replace("'", "''") +
                              "',BigQuoteEmailAddress='" + txtBigQuoteEmail.Text.ToString().Trim().Replace("'", "''") +
                              "',RGAEmailAddress='" + txtRGAEmail.Text.ToString().Trim().Replace("'", "''");
            break;
            case "ship":
                javascript = "document.getElementById('lnkShipFrom').select();document.getElementById('lnkShipFrom').focus();";
                hidShipFrom1.Value = ddlShpBr1.SelectedValue.ToString().Trim().Replace("'", "''");
                hidShipFrom2.Value = ddlShpBr2.SelectedValue.ToString().Trim().Replace("'", "''");
                hidShipFrom3.Value = ddlShpBr3.SelectedValue.ToString().Trim().Replace("'", "''");
                hidShipFrom4.Value = ddlShpBr4.SelectedValue.ToString().Trim().Replace("'", "''");
                updateValue = "ShipFromSupportBr1='" + ddlShpBr1.SelectedValue.ToString().Trim().Replace("'", "''") +
                              "',ShipFromSupportBr2='" + ddlShpBr2.SelectedValue.ToString().Trim().Replace("'", "''") +
                              "',ShipFromSupportBr3='" + ddlShpBr3.SelectedValue.ToString().Trim().Replace("'", "''") +
                              "',ShipFromSupportBr4='" + ddlShpBr4.SelectedValue.ToString().Trim().Replace("'", "''");
                break;
        }

        updateValue = updateValue + "'," +
                       "ChangeID='" + Session["UserName"].ToString().Trim() + "'," +
                       "ChangeDt='" + DateTime.Now.ToString() + "'";

        string whereclause = "LocID=" + txtSearchCode.Text.Trim();

        locationMaster.UpdateLocationMaster(updateValue, whereclause);
        DisplaStatusMessage(updateMessage, "Success");
        pnlContent.Update();

        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "hide", "Hide();" + javascript, true);
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
    }

    #endregion

    #region Developer Methods

    private void ToggleLink(bool status)
    {
        if (status)
            tblLink.Style.Add(HtmlTextWriterStyle.Display, "");
        else
            tblLink.Style.Add(HtmlTextWriterStyle.Display, "none");
        pnlLink.Update();
    }

    private void BindDataGrid()
    {
        string searchText = "";
        if (txtSearchCode.Text == "" && txtSearchName.Text == "")
            searchText = "1=1";
        else if (txtSearchCode.Text == "")
            searchText = " LocName like '%" + txtSearchName.Text + "%'";
        else if (txtSearchName.Text == "")
            searchText = "LocID like '%" + txtSearchCode.Text + "%'";
        else if (hidMode.Value == "Update")
            searchText = "LocID like '%" + txtSearchCode.Text.Trim() + "%'";
        else
            searchText = "LocID like '%" + txtSearchCode.Text + "%' or LocName like '%" + txtSearchName.Text + "%'";

        dtLocationMaster = locationMaster.GetLocationMaster(searchText);

        if (dtLocationMaster != null)
        {
            dtLocationMaster.DefaultView.Sort = (hidSort.Value == "") ? "LocID asc" : hidSort.Value;
            dgLocation.DataSource = dtLocationMaster.DefaultView.ToTable();
            dgLocation.DataBind();

            if (dtLocationMaster.Rows.Count == 1)
            {
                FillFormControls(dtLocationMaster);
                hidMode.Value = "Update";
                ToggleLink(true);

                EnableAddMode(false);

            }
            else if (dtLocationMaster.Rows.Count != 0)
            {
                EnableAddMode(true);
            }
            if (dtLocationMaster.Rows.Count == 0)
            {
                DisplaStatusMessage("No Records Found", "fail");
            }
            
        }
        else
            DisplaStatusMessage("No Records Found", "fail");
    }

    private void FillFormControls(DataTable dtFillFormControls)
    {
        //LocID,LocName,LocAdress1,LocAdress2,LocCity,LocState,LocPostCode,LocCountry,LocTimeZone,SrvrTimeZone,LocContact,LocPhone,LocFax,LocEmail,LocType,WarehouseInd,EntryID,EntryDt,ChangeID,ChangeDt
        txtSearchName.Text = dtFillFormControls.Rows[0]["LocName"].ToString();
        txtSearchCode.Text = dtFillFormControls.Rows[0]["LocID"].ToString();
        txtAddress1.Text = dtFillFormControls.Rows[0]["LocAdress1"].ToString();
        txtAddress2.Text = dtFillFormControls.Rows[0]["LocAdress2"].ToString();
        txtCity.Text = dtFillFormControls.Rows[0]["LocCity"].ToString();
        txtName.Text = dtFillFormControls.Rows[0]["LocContact"].ToString();
        txtFax.Text = dtFillFormControls.Rows[0]["LocFax"].ToString();
        txtEmail.Text = dtFillFormControls.Rows[0]["LocEmail"].ToString();
        hidLocEmail.Value = dtFillFormControls.Rows[0]["LocEmail"].ToString();
        hidBOEmail.Value = dtFillFormControls.Rows[0]["BOEmailAddress"].ToString();
        hidBigQuoteEmail.Value = dtFillFormControls.Rows[0]["BigQuoteEmailAddress"].ToString();
        hidRGAEmail.Value = dtFillFormControls.Rows[0]["RGAEmailAddress"].ToString();
        txtHubSort.Text = dtFillFormControls.Rows[0]["HubSort"].ToString();
        txtPhone.Text = dtFillFormControls.Rows[0]["LocPhone"].ToString();
        txtPostalCode.Text = dtFillFormControls.Rows[0]["LocPostCode"].ToString();
        txtBranchSort.Text = dtFillFormControls.Rows[0]["IMBranchSort"].ToString();

        SetValueDropDownList(ddlType, dtFillFormControls.Rows[0]["LocType"].ToString().Trim());
        SetValueDropDownList(ddlWarehouse, dtFillFormControls.Rows[0]["WarehouseInd"].ToString().Trim());
        SetValueDropDownList(ddlCountry, dtFillFormControls.Rows[0]["LocCountry"].ToString().Trim());
        SetValueDropDownList(ddlTimeZone, dtFillFormControls.Rows[0]["LocTimeZone"].ToString().Trim());
        SetValueDropDownList(ddlServerTimeZone, dtFillFormControls.Rows[0]["SrvrTimeZone"].ToString().Trim());
        SetValueDropDownList(ddlState, dtFillFormControls.Rows[0]["LocState"].ToString().Trim());
        SetValueDropDownList(ddlColor, dtFillFormControls.Rows[0]["IMDisplayColor"].ToString().Trim());

        hidShipFrom1.Value = dtFillFormControls.Rows[0]["ShipFromSupportBr1"].ToString().Trim();
        hidShipFrom2.Value = dtFillFormControls.Rows[0]["ShipFromSupportBr2"].ToString().Trim();
        hidShipFrom3.Value = dtFillFormControls.Rows[0]["ShipFromSupportBr3"].ToString().Trim();
        hidShipFrom4.Value = dtFillFormControls.Rows[0]["ShipFromSupportBr4"].ToString().Trim();

        hidPhone.Value = dtFillFormControls.Rows[0]["PhoneFmt"].ToString();
        hidPostalCode.Value = dtFillFormControls.Rows[0]["PostCodeFmt"].ToString();

        lnkPhone.Attributes.Add("onclick", "javascript:return ShowToolTip(event,'phone',this.id);");
        lnkPostalCode.Attributes.Add("onclick", "javascript:return ShowToolTip(event,'postcode',this.id);");
        lnkEmail.Attributes.Add("onclick", "javascript:return ShowToolTip(event,'email',this.id);");
        lnkShipFrom.Attributes.Add("onclick", "javascript:return ShowToolTip(event,'ship',this.id);");
    }

    private void ClearControls()
    {
        txtAddress1.Text = txtAddress2.Text = "";
        txtCity.Text = txtPostalCode.Text = "";
        txtBranchSort.Text = txtName.Text = txtPhone.Text = "";
        txtFax.Text = txtEmail.Text = "";
        txtHubSort.Text = "";

        hidPostalCode.Value = hidPhone.Value = "";

        ddlColor.SelectedIndex = ddlState.SelectedIndex = ddlCountry.SelectedIndex = 0;
        ddlTimeZone.SelectedIndex = ddlType.SelectedIndex = ddlWarehouse.SelectedIndex = ddlServerTimeZone.SelectedIndex = 0;

        hidLocEmail.Value = hidBOEmail.Value = hidBigQuoteEmail.Value = hidRGAEmail.Value = "";
        hidShipFrom1.Value = hidShipFrom2.Value = hidShipFrom3.Value = hidShipFrom4.Value = "";

        lnkPhone.Attributes.Add("onclick", "javascript:return false;");
        lnkPostalCode.Attributes.Add("onclick", "javascript:return false;");
        lnkEmail.Attributes.Add("onclick", "javascript:return false;");
        lnkShipFrom.Attributes.Add("onclick", "javascript:return false;");

        hidpCar.Value = "";
    }

    private DataTable GetLocationCode(string locID)
    {
        string _whereClause = string.Empty;
        string _tableName = "LocMaster";
        string _columnName = "LocID,LocName,LocAdress1,LocAdress2,LocCity,LocState,LocPostCode,LocCountry,LocTimeZone,SrvrTimeZone,LocContact,LocPhone,LocFax,LocEmail,BOEmailAddress,BigQuoteEmailAddress,RGAEmailAddress,HubSort,LocType,WarehouseInd,EntryID,EntryDt,ChangeID,ChangeDt,PostCodeFmt,PhoneFmt,IMBranchSort,IMDisplayColor,ShipFromSupportBr1,ShipFromSupportBr2,ShipFromSupportBr3,ShipFromSupportBr4";

        _whereClause = "LocID='" + locID + "'";


        DataSet dsLocationCode = new DataSet();
        dsLocationCode = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                            new SqlParameter("@tableName", _tableName),
                            new SqlParameter("@columnNames", _columnName),
                            new SqlParameter("@whereClause", _whereClause));
        return dsLocationCode.Tables[0];
    }

    private void UpdatePanels()
    {
        pnlContent.Update();
        pnlLocationGrid.Update();
        pnlAdd.Update();
        pnlProgress.Update();
        upnlbtnSearch.Update();
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
        pnlProgress.Update();
    }

    private void DisplayAddMode()
    {
        ClearControls();
        btnSave.Visible = false;
        BindDataGrid();
    }

    private void EnableQueryMode()
    {
        btnSave.Visible = false;
        btnTopAdd.Visible = false;
        ibtnFSave.Visible = false;
    }

    private void HideAllControls()
    {
        tdLocation.Style.Add(HtmlTextWriterStyle.Display, "none");
        tdHeader.Style.Add(HtmlTextWriterStyle.Display, "none");
        tdOption.Style.Add(HtmlTextWriterStyle.Display, "none");
        tdWarehouse.Style.Add(HtmlTextWriterStyle.Display, "none");
        tdPrinter.Style.Add(HtmlTextWriterStyle.Display, "none");
        pnlOption.Update();
        pnlLocationGrid.Update();
        pnlLink.Update();
        pnlWarehouse.Update();
        pnlPrinter.Update();
    }

    private void CloseEvent()
    {
        HideAllControls();
        BindDataGrid();
        tdLocation.Style.Add(HtmlTextWriterStyle.Display, "");
        tdHeader.Style.Add(HtmlTextWriterStyle.Display, "");
        pnlLocationGrid.Update();
        pnlLink.Update();
    }

    private void BindInformationList()
    {
        locationMaster.GetCountryList(ddlCountry);
        locationMaster.BindListValue("TimeZone", "-- Select  --", ddlServerTimeZone);
        locationMaster.BindListValue("TimeZone", "-- Select --", ddlTimeZone);
        locationMaster.BindListValue("FiftyStates", "-- Select --", ddlState);
        locationMaster.BindListValue("LocType", "-- Select --", ddlType);
        locationMaster.BindListValue("WhInd", "-- Select --", ddlWarehouse);
        locationMaster.BindListValue("BranchColor", "-- Select --", ddlColor);
        locationMaster.GetLocList(ddlShpBr1);
        locationMaster.GetLocList(ddlShpBr2);
        locationMaster.GetLocList(ddlShpBr3);
        locationMaster.GetLocList(ddlShpBr4);
    }

    private void SetValueDropDownList(DropDownList ddlControl, String value)
    {
        ListItem lItem = ddlControl.Items.FindByValue(value) as ListItem;
        if (lItem != null)
            ddlControl.SelectedValue = value;
    }

    private void EnableAddMode(bool status)
    {
        if (status)
        {
            ToggleButton("add");
            txtSearchName.Text = txtSearchCode.Text = "";
            trsearchText.Style.Add(HtmlTextWriterStyle.Display, "");
            trsearchLabel.Style.Add(HtmlTextWriterStyle.Display, "none");
            lblSch.Visible = true;
            lblOr.Visible = true;
        }
        else
        {
            ToggleButton("search");

            lblSearchName.Text = " : " + txtSearchName.Text;
            lblSearchCode.Text = " : " + txtSearchCode.Text;
            trsearchText.Style.Add(HtmlTextWriterStyle.Display, "none");
            trsearchLabel.Style.Add(HtmlTextWriterStyle.Display, "");
            HideAllControls();
        }
    }

    private void ToggleButton(string mode)
    {
        if (mode.ToLower() == "search")
        {
            btnSave.Visible = (LocationMasterSecurity != "") ? true : false;
            AddButton.Visible = true;
            btnTopAdd.Visible = false;
            // iClose.Visible = true;
        }
        else
        {
            btnSave.Visible = false;
            AddButton.Visible = false;
            // iClose.Visible = false;
            btnTopAdd.Visible = (LocationMasterSecurity != "") ? true : false;
        }
    }

    private string FormatContent(string format, string txtCtrl)
    {
        string value = txtCtrl.Trim().Replace(" ", "").Replace("(", "").Replace(")", "").Replace("-", "").Trim();
        long formatValue = (value != "") ? Convert.ToInt64(value) : 0;
        if (value == "")
            return "";
        else
            return formatValue.ToString(format);
    }
    #endregion

    #region AJAX Method

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string GetFormattedValue(string format, string txtCtrl, string mode, string locID)
    {
        try
        {
            LocationMaster locationMstr = new LocationMaster();
            string updateValue = "";
            string formattedValue = "";
            if (mode == "phone")
            {
                formattedValue = FormatContent(format.Trim(), txtCtrl);
                updateValue = "PhoneFmt='" + format.Trim().Replace("'", "''") + "',LocPhone='" + formattedValue;
            }
            else
            {
                formattedValue = FormatContent(format.Trim(), txtCtrl);
                updateValue = "PostCodeFmt='" + format.Trim().Replace("'", "''") + "',LocPostCode='" + formattedValue;
            }
            updateValue = updateValue + "'," +
                          "ChangeID='" + Session["UserName"].ToString().Trim() + "'," +
                          "ChangeDt='" + DateTime.Now.ToString() + "'";

            string whereclause = "LocID=" + locID.Trim();

            locationMstr.UpdateLocationMaster(updateValue, whereclause);

            return formattedValue;
        }
        catch (Exception ex)
        {
            return "";
        }

    }
    #endregion
}