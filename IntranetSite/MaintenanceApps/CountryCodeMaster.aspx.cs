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

public partial class CountryCodeMaster : System.Web.UI.Page
{
    int count;
    CountryMaster CountryDetails = new CountryMaster();
    private DataSet dsCountryMaster = new DataSet();

    string updateMessage = "Data has been successfully updated.";
    string deleteMessage = "Data has been successfully Deleted.";

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
            Session["CountrySecurity"] = CountryDetails.GetSecurityCode(Session["UserName"].ToString());
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
        txt3CharCd.Text = "N";
        txtCode.Enabled = true;
        btncheck();
        btnSave.Visible = (CountrySecurity != "") ? true : false;
        txtCode.Focus();
        upnlAdd.Update();
        upnlEntry.Update();
        upnlbtnSearch.Update();
        upnlGrid.Update();
        pnlProgress.Update();
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

        if (txt3CharCd.Text.Trim().Length != 3)
        {
            ScriptManager.RegisterClientScriptBlock(btnSave, btnSave.GetType(), "invalidCode", "alert('3 Char Cd is invalid. It should be three character.');", true);
            return;
        }

        if (ViewState["Mode"].ToString() == "Add")
        {
            bool CountryCode = CountryDetails.GetCountryCode("CountryCd = '" + txtCode.Text.Trim() + "'");
            if (CountryCode)
            {
                string columnValue = "'" + txtCode.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + txtName.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + txtDateFormat.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + txtPostalCode.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + txtPhoneFormat.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + txtCurrencyCode.Text.Trim().Replace("'", "''") + "'," +
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
                                    "'" + DateTime.Now.ToShortDateString() + "'," +
                                    "'" + txtStatusCode.Text.Trim().Replace("'", "''") + "'," +
                                    "'" + txt3CharCd.Text.Trim().Replace("'", "''") + "'" ;

                CountryDetails.CountryDetails(columnValue);
                DisplaStatusMessage(updateMessage, "Success");
                btnSave.Visible = false;
                btnDelete.Visible = false;
            }
            else
            {
                DisplaStatusMessage("Country Code Already Exists", "Fail");
                upnlGrid.Update();
                pnlProgress.Update();
                return;
            }

        }
        else
        {
            string updateValue = "CountryCd='" + txtCode.Text.Trim().Replace("'", "''") + "'," +
                            "Name='" + txtName.Text.Trim().Replace("'", "''") + "'," +
                            "DateFormat='" + txtDateFormat.Text.Trim().Replace("'", "''") + "'," +
                            "PostCodeFormat='" + txtPostalCode.Text.Trim().Replace("'", "''") + "'," +
                            "PhoneFormat='" + txtPhoneFormat.Text.Trim().Replace("'", "''") + "'," +
                            "CurrencyCD='" + txtCurrencyCode.Text.Trim().Replace("'", "''") + "'," +
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
                            "ChangeDt='" + DateTime.Now.ToShortDateString() + "'," +
                            "StatusCd='" + txtStatusCode.Text.Trim().Replace("'", "''") + "'," +
                            "[856CountryCd]='" + txt3CharCd.Text.Trim().Replace("'", "''") + "'";
            CountryDetails.UpdateCountryDetails("CountryMaster", updateValue, "pCountryMstrID=" + hidpCountryMstrID.Value.Trim());

            DisplaStatusMessage(updateMessage, "Success");
            btnSave.Visible = false;
            btnDelete.Visible = false;
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);

        }
        ViewState["Operation"] = "Save";
        Clear();

        //btncheck();
        BindDataGrid();
        upnlEntry.Update();
        upnlchkSelectAll.Update();
        upnlbtnSearch.Update();
        upnlAdd.Update();
        upnlGrid.Update();
        pnlProgress.Update();


    }

    protected void btnSearch_Click(object sender, ImageClickEventArgs e)
    {
        btnSave.Visible = false;
        btnDelete.Visible = false;
        ViewState["Mode"] = "Add";
        btncheck();
        Clear();

        BindDataGrid();
        upnlchkSelectAll.Update();
        upnlEntry.Update();
        upnlGrid.Update();
        upnlAdd.Update();
        pnlProgress.Update();
    }

    protected void dgCountryCode_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edit")
        {
            dsCountryMaster = CountryDetails.GetDataToDateset("CountryMaster", "pCountryMstrID,CountryCd,Name,DateFormat,PostCodeFormat,PhoneFormat,CurrencyCD,GLAppInd,APAppInd,ARAppInd,SOAppInd,POAppInd,IMAppInd,WMAppInd,WOAppInd,MMAppInd,SMAppInd,EntryID,EntryDt,ChangeID,ChangeDt,StatusCd,[856CountryCd]", "pCountryMstrID = '" + e.CommandArgument + "'");
            DisplayRecord();
            btncheck();
            btnSave.Visible = (CountrySecurity != "") ? true : false;
            ScriptManager.RegisterClientScriptBlock(txtName, txtName.GetType(), "focud", "document.getElementById('" + txtName.ClientID + "').select();document.getElementById('" + txtName.ClientID + "').focus();", true);
        }
        if (e.CommandName == "Delete")
        {
            CountryDetails.DeleteCountryDetails("CountryMaster", "pCountryMstrID = '" + e.CommandArgument + "'");
            BindDataGrid();
            DisplaStatusMessage(deleteMessage, "Success");
            btnSave.Visible = false;
            btnDelete.Visible = false;
            Clear();
         }
         ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);

        upnlEntry.Update();
        upnlchkSelectAll.Update();
        upnlbtnSearch.Update();
        upnlAdd.Update();
        upnlGrid.Update();
        pnlProgress.Update();
        btncheck();
    }

    protected void btnDelete_Click(object sender, ImageClickEventArgs e)
    {
        CountryDetails.DeleteCountryDetails("CountryMaster", "pCountryMstrID = '" + hidpCountryMstrID.Value + "'");
        Clear();
        lblMessage.Text = "Sucessfully Deleted ...";
        BindDataGrid();
        //btncheck();
        btnSave.Visible = false;
        btnDelete.Visible = false;

        upnlEntry.Update();
        upnlchkSelectAll.Update();
        upnlbtnSearch.Update();
        upnlAdd.Update();
        upnlGrid.Update();
        pnlProgress.Update();

        
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
        hidpCountryMstrID.Value = dsCountryMaster.Tables[0].Rows[0]["pCountryMstrID"].ToString().Trim();
        txtCode.Text = dsCountryMaster.Tables[0].Rows[0]["CountryCd"].ToString().Trim();
        txtCode.Enabled = false;
        txtName.Text = dsCountryMaster.Tables[0].Rows[0]["Name"].ToString().Trim();
        txtDateFormat.Text = dsCountryMaster.Tables[0].Rows[0]["DateFormat"].ToString().Trim();
        txtPostalCode.Text = dsCountryMaster.Tables[0].Rows[0]["PostCodeFormat"].ToString().Trim();
        txtPhoneFormat.Text = dsCountryMaster.Tables[0].Rows[0]["PhoneFormat"].ToString().Trim();
        txtCurrencyCode.Text = dsCountryMaster.Tables[0].Rows[0]["CurrencyCD"].ToString().Trim();
        txtStatusCode.Text = dsCountryMaster.Tables[0].Rows[0]["StatusCd"].ToString().Trim();
        txt3CharCd.Text = dsCountryMaster.Tables[0].Rows[0]["856CountryCd"].ToString().Trim();

        lblEntryID.Text = dsCountryMaster.Tables[0].Rows[0]["EntryID"].ToString().Trim();
        lblEntryDate.Text = (dsCountryMaster.Tables[0].Rows[0]["EntryDt"].ToString()=="")?"":Convert.ToDateTime(dsCountryMaster.Tables[0].Rows[0]["EntryDt"].ToString()).ToShortDateString();
        lblChangeID.Text = dsCountryMaster.Tables[0].Rows[0]["ChangeID"].ToString().Trim();        
        lblChangeDate.Text = (dsCountryMaster.Tables[0].Rows[0]["ChangeDt"].ToString() == "") ? "" : Convert.ToDateTime(dsCountryMaster.Tables[0].Rows[0]["ChangeDt"].ToString()).ToShortDateString();
        if (dsCountryMaster.Tables[0].Rows[0]["GLAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[0].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[0].Selected = false;

        }
        if (dsCountryMaster.Tables[0].Rows[0]["APAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[1].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[1].Selected = false;
        }

        if (dsCountryMaster.Tables[0].Rows[0]["ARAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[2].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[2].Selected = false;

        }


        if (dsCountryMaster.Tables[0].Rows[0]["SOAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[3].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[3].Selected = false;

        }

        if (dsCountryMaster.Tables[0].Rows[0]["POAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[4].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[4].Selected = false;

        }


        if (dsCountryMaster.Tables[0].Rows[0]["IMAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[5].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[5].Selected = false;

        }


        if (dsCountryMaster.Tables[0].Rows[0]["WMAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[6].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[6].Selected = false;

        }

        if (dsCountryMaster.Tables[0].Rows[0]["WOAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[7].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[7].Selected = false;

        }

        if (dsCountryMaster.Tables[0].Rows[0]["MMAppInd"].ToString().Trim() == "Y")
        {
            chkSelection.Items[8].Selected = true;
            count = count + 1;
        }
        else
        {
            chkSelection.Items[8].Selected = false;

        }

        if (dsCountryMaster.Tables[0].Rows[0]["SMAppInd"].ToString().Trim() == "Y")
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

        //dgCountryCode.Visible = false;
    }

    private void BindDataGrid()
    {
        string searchText = (txtCountryCode.Text == "" ? "1=1" : "CountryCd like '%" + txtCountryCode.Text + "%'");
        dsCountryMaster = CountryDetails.GetDataToDateset("CountryMaster", "pCountryMstrID,CountryCd,Name,DateFormat,PostCodeFormat,PhoneFormat,CurrencyCD,GLAppInd,APAppInd,ARAppInd,SOAppInd,POAppInd,IMAppInd,WMAppInd,WOAppInd,MMAppInd,SMAppInd,EntryID,EntryDt,ChangeID,ChangeDt,StatusCd,[856CountryCd]", searchText);

        if (dsCountryMaster != null)
        {
            dsCountryMaster.Tables[0].DefaultView.Sort = (hidSort.Value == "") ? "CountryCd asc" : hidSort.Value;
            dgCountryCode.DataSource = dsCountryMaster.Tables[0].DefaultView.ToTable();
            dgCountryCode.DataBind();

            if (dsCountryMaster.Tables[0].Rows.Count == 1)
            {
                DisplayRecord();
                btnSave.Visible = (CountrySecurity != "") ? true : false;
                btnDelete.Visible = (CountrySecurity != "") ? true : false;
                if (ViewState["Operation"].ToString() == "Save")
                {
                    Clear();
                    btnSave.Visible = false;
                    btnDelete.Visible = false;
                }                
            }
            if (dsCountryMaster.Tables[0].Rows.Count == 0)
            {
                DisplaStatusMessage("No Records Found", "Fail");
            }

        }
        else
            DisplaStatusMessage("No Records Found", "Fail");

    }

    protected void Clear()
    {
        try
        {
            foreach (ListItem li in chkSelection.Items)
            {
                li.Selected = false;
            }

            chkSelectAll.Checked = false;
            txtCode.Focus();
            lblChangeID.Text =  lblChangeDate.Text = lblEntryID.Text = lblEntryDate.Text = "";
            txtCode.Text = txtCurrencyCode.Text = txtDateFormat.Text = txtName.Text = txtPhoneFormat.Text = txtPostalCode.Text = txtStatusCode.Text = txt3CharCd.Text = "";
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
        txtCountryCode.Attributes.Add("onkeydown", "if(event.which || event.keyCode)" +
        "{if ((event.which == 9) || (event.keyCode == 9) || (event.which == 13) || (event.keyCode == 13)) " +
        "{document.getElementById('" + txtCode.ClientID +
        "').focus();return false;}} else {return true}; ");
    }
}



