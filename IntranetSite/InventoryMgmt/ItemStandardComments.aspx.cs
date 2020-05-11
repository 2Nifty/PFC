using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;

public partial class ItemStandardComments : System.Web.UI.Page
{
    SqlConnection cnERP = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
    string procName = "pIMMaintStdComments";

    DataSet dsItemNotes = new DataSet();
    DataTable dtItemNotes = new DataTable();
    DataView dvItemNotes = new DataView();
    string strSQL = string.Empty;
    string sessionID = string.Empty;
    string lockUser = string.Empty;

    ddlBind ddlBind = new ddlBind();
    MaintenanceUtility Notes = new MaintenanceUtility();

    protected void Page_Load(object sender, EventArgs e)
    {
        sessionID = Session["UserName"].ToString().Trim() + Session["SessionID"].ToString().Trim();
        Ajax.Utility.RegisterTypeForAjax(typeof(ItemStandardComments));
       
        if (!IsPostBack)
        {
            ClearScreen();
            Session["IMNLockStatus"] = "";
            Session["IMNoteID"] = "";

            GetSecurity();

            ddlBind.BindFromList("ItemNotesCd", ddlTypeSearch, " ", " ");
            ddlBind.BindFromList("FormType", ddlFormSearch, " ", " ");
            ddlBind.BindFromList("ItemNotesCd", ddlCmntType, " ", " ");
            ddlBind.BindFromList("FormType", ddlFormCd, " ", " ");

            txtItemNo.Text = string.Empty;
            if (!string.IsNullOrEmpty(Request.QueryString["ItemNo"].ToString().Trim()))
            {
                txtItemNo.Text = Request.QueryString["ItemNo"].ToString().Trim();
                btnHidSubmitItem_Click(btnHidSubmitItem, EventArgs.Empty);
            }
            smItemStdCmnt.SetFocus(txtItemNo);
        }
    }

    #region Validate Item & Get Notes
    protected void btnHidSubmitItem_Click(object sender, EventArgs e)
    {
        ClearScreen();
        CheckItem();
    }

    private void CheckItem()
    {
        hidNoteInd.Value = "false";

        try
        {
            dsItemNotes = SqlHelper.ExecuteDataset(cnERP, procName, new SqlParameter("@Item", txtItemNo.Text.ToString().Trim()),
                                                                    new SqlParameter("@Type", ""),
                                                                    new SqlParameter("@FormCd", ""),
                                                                    new SqlParameter("@Note", ""),
                                                                    new SqlParameter("@RecID", 0),
                                                                    new SqlParameter("@SessID", sessionID),
                                                                    new SqlParameter("@Mode", "GET"));
        }
        catch (Exception ex)
        {
            DisplayStatusMessage("[GET] Error executing stored procedure (" + procName + ") - " + ex.Message, "fail");
            smItemStdCmnt.SetFocus(txtItemNo);
            return;
        }

        if (dsItemNotes.Tables[0].DefaultView.ToTable().Rows.Count <= 0)
        {
            DisplayStatusMessage("Item " + txtItemNo.Text.ToString().Trim() + " not on file", "fail");
            smItemStdCmnt.SetFocus(txtItemNo);
        }
        else
        {
            //DisplayStatusMessage("Item " + txtItemNo.Text.ToString().Trim() + " found.", "success");
            dtItemNotes = dsItemNotes.Tables[0].DefaultView.ToTable();
            Session["dtItemNotes"] = dtItemNotes;
            if (hidSecurity.Value.ToUpper() == "FULL")
                btnAdd.Visible = true;
            else
                DisplayStatusMessage("Query Only", "fail");
            btnCancel.Visible = true;
            lblItemNo.Text = dtItemNotes.Rows[0]["ItemNo"].ToString().Trim();
            lblCatDesc.Text = dtItemNotes.Rows[0]["CatDesc"].ToString().Trim();
            lblItemDesc.Text = dtItemNotes.Rows[0]["ItemDesc"].ToString().Trim();
            tblEditDesc.Visible = true;

            if (dtItemNotes.Rows[0]["Notes"].ToString().Trim() == "NONOTES")
            {
                DisplayStatusMessage("No Standard Comments Found For Item " + txtItemNo.Text.ToString().Trim(), "fail");
                pnlGrid.Visible = false;
            }
            else
            {
                hidNoteInd.Value = "true";
                tblSearch.Visible = true;
                gvComments.DataSource = dtItemNotes;
                gvComments.DataBind();
                pnlGrid.Visible = true;
            }
            pnlMain.Update();
        }
    }
    #endregion Validate Item & Get Notes

    #region Filter DDLs
    protected void ddlTypeSearch_SelectedIndexChanged(object sender, EventArgs e)
    {
        SetFilter();
    }
    
    protected void ddlFormSearch_SelectedIndexChanged(object sender, EventArgs e)
    {
        SetFilter();
    }

    protected void SetFilter()
    {
        DisplayStatusMessage("", "success");
        dtItemNotes = (DataTable)Session["dtItemNotes"];
        dvItemNotes = new DataView(dtItemNotes);
        string rowFilter = string.Empty;

        if (!string.IsNullOrEmpty(ddlTypeSearch.SelectedValue.ToString().Trim()))
        {
            rowFilter = "Type = '" + ddlTypeSearch.SelectedValue.ToString().Trim() + "'";
        }

        if (!string.IsNullOrEmpty(ddlFormSearch.SelectedValue.ToString().Trim()))
        {
            if (!string.IsNullOrEmpty(rowFilter))
            {
                rowFilter += " AND ";
            }
            rowFilter += "FormCd = '" + ddlFormSearch.SelectedValue.ToString().Trim() + "'";
        }

        if (!string.IsNullOrEmpty(rowFilter))
        {
            dvItemNotes.RowFilter = rowFilter;
            if (dvItemNotes.Count > 0)
            {
                DisplayStatusMessage(dvItemNotes.Count.ToString().Trim() + " notes in this filter: " + rowFilter, "success");
            }
            else
            {
                DisplayStatusMessage(dvItemNotes.Count.ToString().Trim() + " notes in this filter: " + rowFilter, "fail");
            }
        }
        gvComments.DataSource = dvItemNotes;
        gvComments.DataBind();
        pnlGrid.Update();
    }
    #endregion Filter DDLs

    #region Buttons
    protected void btnCancel_Click(object sender, ImageClickEventArgs e)
    {
        ClearScreen();
        smItemStdCmnt.SetFocus(txtItemNo);
    }

    protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    {
        DisplayStatusMessage("", "success");
        txtItemNo.Text = lblItemNo.Text.ToString().Trim();
        if (hidMaintMode.Value == "EDT")
            ReleaseLock();
        hidMaintMode.Value = "ADD";
        ToggleEdit("ON");
        ddlCmntType.Enabled = true;
        ddlCmntType.SelectedIndex = ddlTypeSearch.SelectedIndex;
        ddlFormCd.Enabled = true;
        ddlFormCd.SelectedIndex = ddlFormSearch.SelectedIndex;
        txtCmntText.Text = string.Empty;
        smItemStdCmnt.SetFocus(txtCmntText);
        pnlEdit.Update();
        pnlGrid.Update();
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        if (hidMaintMode.Value == "ADD")
        {
            #region ADD Mode - Insert new record
            if (ddlCmntType.SelectedIndex <= 0 || ddlFormCd.SelectedIndex <= 0) 
            {
                DisplayStatusMessage("A valid Note Type & Form Code is required", "fail");
            }
            else
            {
                #region INSERT the new Note Record
                try
                {
                    dsItemNotes = SqlHelper.ExecuteDataset(cnERP, procName, new SqlParameter("@Item", lblItemNo.Text.ToString().Trim()),
                                                                            new SqlParameter("@Type", ddlCmntType.SelectedValue.ToString().Trim()),
                                                                            new SqlParameter("@FormCd", ddlFormCd.SelectedValue.ToString().Trim()),
                                                                            new SqlParameter("@Note", txtCmntText.Text.ToString()),
                                                                            new SqlParameter("@RecID", 0),
                                                                            new SqlParameter("@SessID", sessionID),
                                                                            new SqlParameter("@Mode", "ADD"));
                }
                catch (Exception ex)
                {
                    DisplayStatusMessage("[ADD] Error executing stored procedure (" + procName + ") - " + ex.Message, "fail");
                    smItemStdCmnt.SetFocus(txtItemNo);
                    return;
                }

                if (dsItemNotes.Tables[0].DefaultView.ToTable().Rows.Count > 0)
                {
                    DisplayStatusMessage("Duplicate Note Type & Form Code already on file", "fail");
                }
                else
                {
                    ToggleEdit("OFF");
                    if (hidNoteInd.Value != "true")
                    {
                        pnlGrid.Visible = true;
                    }
                    CheckItem();
                    DisplayStatusMessage("Note Added", "success");
                }
                #endregion INSERT the new Note Record
            }
            #endregion ADD Mode - Insert new record
        }

        if (hidMaintMode.Value == "EDT")
        {
            #region EDIT Mode - UPDATE the modified Note Record
            try
            {
                dsItemNotes = SqlHelper.ExecuteDataset(cnERP, procName, new SqlParameter("@Item", ""),
                                                                        new SqlParameter("@Type", ""),
                                                                        new SqlParameter("@FormCd", ""),
                                                                        new SqlParameter("@Note", txtCmntText.Text.ToString()),
                                                                        new SqlParameter("@RecID", Convert.ToInt32(hidIMNoteID.Value)),
                                                                        new SqlParameter("@SessID", sessionID),
                                                                        new SqlParameter("@Mode", "UPD"));
            }
            catch (Exception ex)
            {
                DisplayStatusMessage("[UPD] Error executing stored procedure (" + procName + ") - " + ex.Message, "fail");
                smItemStdCmnt.SetFocus(txtItemNo);
                return;
            }
            ReleaseLock();
            ToggleEdit("OFF");
            CheckItem();
            DisplayStatusMessage("Note Updated", "success");
            #endregion EDIT Mode - UPDATE the modified Note Record
        }
    }
    #endregion Buttons

    #region GridView (gvComments)
    protected void gvComments_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (hidSecurity.Value.ToString() == "Full")
            {
                Label lblNoAction = e.Row.FindControl("lblNoAction") as Label;
                lblNoAction.Visible = false;

                LinkButton lnkEdit = e.Row.FindControl("lnkEdit") as LinkButton;
                lnkEdit.Visible = true;

                LinkButton lnkDelete = e.Row.FindControl("lnkDelete") as LinkButton;
                lnkDelete.Visible = true;
            }
            else
            {
                Label lblNoAction = e.Row.FindControl("lblNoAction") as Label;
                lblNoAction.Visible = true;

                LinkButton lnkEdit = e.Row.FindControl("lnkEdit") as LinkButton;
                lnkEdit.Visible = false;

                LinkButton lnkDelete = e.Row.FindControl("lnkDelete") as LinkButton;
                lnkDelete.Visible = false;
            }
        }
    }

    #region Grid Commands (EDIT & DELETE)
    protected void gvComments_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        hidIMNoteID.Value = e.CommandArgument.ToString().Trim();
        DisplayStatusMessage("", "success");

        dtItemNotes = (DataTable)Session["dtItemNotes"];
        dvItemNotes = new DataView(dtItemNotes);
        dvItemNotes.RowFilter = "pItemNotesID = " + hidIMNoteID.Value;

        if (e.CommandName == "EDT")
        {
            #region EDIT Mode
            CheckLock();
            if (Session["IMNLockStatus"].ToString() == "L")
            {
                ScriptManager.RegisterClientScriptBlock(pnlGrid, typeof(UpdatePanel), "Script", "alert('Record Locked By " + lockUser.ToString() + "');", true);
            }
            else
            {
                //DisplayStatusMessage("NOT LOCKED - " + lockUser.ToString(), "success");

                #region EDIT Notes Record
                hidMaintMode.Value = "EDT";
                ToggleEdit("ON");
                ddlCmntType.Enabled = false;
                ddlFormCd.Enabled = false;
                try
                {
                    ddlCmntType.SelectedValue = dvItemNotes[0]["Type"].ToString().Trim();
                }
                catch (Exception ex)
                {
                    ddlCmntType.SelectedIndex = 0;
                }
                try
                {
                    ddlFormCd.SelectedValue = dvItemNotes[0]["FormCd"].ToString().Trim();
                }
                catch (Exception ex)
                {
                    ddlFormCd.SelectedIndex = 0;
                }
                txtCmntText.Text = dvItemNotes[0]["Notes"].ToString().Trim();
                smItemStdCmnt.SetFocus(txtCmntText);
                pnlEdit.Update();
                #endregion EDIT Notes Record
            }
            #endregion EDIT Mode
        }

        if (e.CommandName == "DEL")
        {
            #region DELETE Mode
            if (hidDelNote.Value == "true")
            {
                if (hidMaintMode.Value == "EDT")
                {
                    ReleaseLock();
                    ToggleEdit("OFF");
                }
                CheckLock();
                if (Session["IMNLockStatus"].ToString() == "L")
                {
                    ScriptManager.RegisterClientScriptBlock(pnlGrid, typeof(UpdatePanel), "Script", "alert('Record Locked By " + lockUser.ToString() + "');", true);
                    DisplayStatusMessage("Record Locked by " + lockUser.ToString() + " - Note not deleted", "fail");
                }
                else
                {
                    //DELETE the selected record - SET the DeleteDt
                    #region DELETE Notes Record
                    try
                    {
                        dsItemNotes = SqlHelper.ExecuteDataset(cnERP, procName, new SqlParameter("@Item", ""),
                                                                                new SqlParameter("@Type", ""),
                                                                                new SqlParameter("@FormCd", ""),
                                                                                new SqlParameter("@Note", ""),
                                                                                new SqlParameter("@RecID", Convert.ToInt32(hidIMNoteID.Value)),
                                                                                new SqlParameter("@SessID", sessionID),
                                                                                new SqlParameter("@Mode", "DEL"));
                    }
                    catch (Exception ex)
                    {
                        DisplayStatusMessage("[DEL] Error executing stored procedure (" + procName + ") - " + ex.Message, "fail");
                        smItemStdCmnt.SetFocus(txtItemNo);
                        return;
                    }
                    DisplayStatusMessage("Note Deleted Successfully", "fail");
                    ReleaseLock();
                    CheckItem();
                    #endregion DELETE Notes Record
                }
            }
            #endregion DELETE Mode
        }
    }
    #endregion Grid Commands (EDIT & DELETE)

    #endregion GridView (gvComments)

    #region Screen Utils
    private void ClearScreen()
    {
        DisplayStatusMessage("", "success");
        tblSearch.Visible = false;
        ddlTypeSearch.SelectedIndex = 0;
        ddlFormSearch.SelectedIndex = 0;
        btnAdd.Visible = false;
        btnCancel.Visible = false;
        if (hidMaintMode.Value == "EDT")
            ReleaseLock();
        tblEditDesc.Visible = false;
        ToggleEdit("OFF");
        pnlGrid.Visible = false;
        pnlGrid.Update();
    }

    private void ToggleEdit(string _switch)
    {
        if (_switch.ToUpper() == "OFF")
        {
            hidMaintMode.Value = string.Empty;
            lblMaintHdr.Text = "Item Standard Comments Maintenance";
            pnlMaintHdr.Update();
            tblEditCmnt.Visible = false;
            divCmntGrid.Attributes["style"] = "overflow:auto; height:405px; width:1010px;";
        }

        if (_switch.ToUpper() == "ON")
        {
            if (hidMaintMode.Value == "EDT")
            {
                lblMaintHdr.Text = "Edit Item Standard Comments";
            }
            else
            {
                lblMaintHdr.Text = "Enter Item Standard Comments";
            }
            pnlMaintHdr.Update();
            tblEditCmnt.Visible = true;
            divCmntGrid.Attributes["style"] = "overflow:auto; height:305px; width:1010px;";
        }
        pnlMain.Update();
    }

    private void DisplayStatusMessage(string message, string messageType)
    {
        lblMessage.Visible = true;
        lblMessage.Text = message;
        if (messageType.ToLower() == "success")
        {
            lblMessage.ForeColor = System.Drawing.Color.Green;
        }
        else
        {
            lblMessage.ForeColor = System.Drawing.Color.Red;
        }
        pnlStatus.Update();
    }
    #endregion Screen Utils

    #region Security, SoftLocks & Page Unload
    private void GetSecurity()
    {
        hidSecurity.Value = Notes.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.ItemNotes);
        if (hidSecurity.Value.ToString() == "")
            hidSecurity.Value = "Query";
        else
            hidSecurity.Value = "Full";

        //Response.Write(Session["UserName"].ToString());
        //Response.Write("<br>");
        //Response.Write(hidSecurity.Value.ToString());

        switch (hidSecurity.Value.ToString())
        {
            case "None":
                Response.Redirect("~/Common/ErrorPage/unauthorizedpage.aspx", true);
                break;
            case "Query":
                DisplayStatusMessage("Query Only", "fail");
                break;
            case "Full":
                break;
        }
    }

    public void CheckLock()
    {
        ReleaseLock();
        Session["IMNoteID"] = hidIMNoteID.Value;
        DataTable dtLock = Notes.SetLock("ItemNotes", Session["IMNoteID"].ToString(), "IMN");
        Session["IMNLockStatus"] = dtLock.DefaultView.ToTable().Rows[0]["Status"].ToString();
        lockUser = dtLock.DefaultView.ToTable().Rows[0]["EntryID"].ToString();
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void ReleaseLock()
    {
        Notes.ReleaseLock("ItemNotes", Session["IMNoteID"].ToString(), "IMN", Session["IMNLockStatus"].ToString());
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void Unload()
    {
        ReleaseLock();
        Session["IMNLockStatus"] = null;
        Session["IMNoteID"] = null;
        Session["dtItemNotes"] = null;
    }
    #endregion Security, SoftLocks & Page Unload
}