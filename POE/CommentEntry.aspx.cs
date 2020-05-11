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
using PFC.POE.BusinessLogicLayer;

public partial class CommentEntry : System.Web.UI.Page
{
      
    #region Class Variable
    PurchaseOrderDetails purchaseDetail = new PurchaseOrderDetails();
    POCommentEntry comments = new POCommentEntry();
    Utility utility = new Utility();
    #endregion

    #region Variable Declaration
    string poNumber = "";
    string vendorNo = "";
    string LineItemNumber = "";
    DataTable dtStd = new DataTable();
    DataTable dtVendor = new DataTable();
    DataTable dtMerge = new DataTable();
    public string CommentsType
    {
        get { return ddlType.SelectedValue; }
    }
    public string HeaderIDColumn
    {
        get
        {  return "fPOHeaderID";
        }
    }
    public string CommentTableName
    {
        get
        {
             
                return "POComments";
        }
    }

    string invalidMessage = "Select Valid Comment Type";
   #endregion

    #region PageLoad Event 
    /// <summary>
    /// PageLoad Event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        poNumber = Request.QueryString["PONumber"].ToString();
        LineItemNumber = comments.GetPOOrderNo(poNumber);
        
        if (!IsPostBack)
        {
          

            ViewState["Mode"] = "ADD";
            BindCommentType();
            SoHeader.PONumber = poNumber;
            vendorNo = SoHeader.VendorNumber;

            DataTable dtcount = comments.GetLineCount(SoHeader.POOrderID);
            if (dtcount != null && dtcount.Rows.Count > 0)
                 Session["LineItemNumber"] = (dtcount.Rows[0][0].ToString() == "") ? "0" : dtcount.Rows[0][0].ToString();             
            else
                Session["LineItemNumber"] = "0";

            BindDataGrid();
            BindLineNumber();
            BindSequenceNo();

            //
            // If user selected quote line in the main order entry screen, then highlight the dropdown to "Line Comment"
            //
            HighLightForCommentLine();
        }
        BindExport();
         vendorNo = SoHeader.VendorNumber;
        if (Session["UserSecurity"].ToString() == "")
            ibtnSave.Visible = false;
        if (ddlType.SelectedValue != "LC")
            ddlLineNo.Enabled = false;
        else
            ddlLineNo.Enabled = true;
    }
    #endregion

    #region DeveloperCode
    /// <summary>
    /// Bind the Dropdown list
    /// </summary>
    private void BindCommentType()
    {
        utility.BindListControls(ddlType, "ListDesc", "ListValue", comments.GetCommentType());
        utility.BindListControls(ddlFrom, "ListDesc", "ListValue", comments.GetForm(), "-- Select Form Type --");
        utility.BindListControls(ddlStdComment, "Comments", "TypeForm", comments.GetStdComment(), "---- Standard ----");
        utility.BindListControls(ddlFilter, "ListDesc", "ListValue", comments.GetCommentType(), "Active");

    }
    /// <summary>
    /// Bind the Datagrid on SOHeaderID
    /// </summary>
    private void BindDataGrid()
    {
        string _whereClause = HeaderIDColumn + "= '" + poNumber + " ' and DeleteDt is null";

        if (chkComment.Checked)
            _whereClause = HeaderIDColumn + "= '" + poNumber + "'";

        if (ddlFilter.SelectedValue != "")
            _whereClause += " and Type ='" + ddlFilter.SelectedValue + "'";

        DataTable dsCommentEntry = comments.GetSoComment(_whereClause);
        if (dsCommentEntry != null)
        {
            dsCommentEntry.DefaultView.Sort = (hidSort.Value == "") ? "Type asc" : hidSort.Value;
            gvComment.DataSource = dsCommentEntry;
            gvComment.DataBind();

            Session["CommentAvailable"] = (gvComment.Rows.Count > 0 ? "true" : "false");
        }
        BindExport();
    }
    /// <summary>
    /// Bind the LineNo Dropdown
    /// </summary>
    public void BindLineNumber()
    {
        if (Session["LineItemNumber"] != null)
        {
            int lineCount = Convert.ToInt32(Session["LineItemNumber"].ToString()) / 10;
            for (int count = 1; count <= lineCount; count++)
            {
                ddlLineNo.Items.Add(count.ToString());
            }
        }
    }
    /// <summary>
    /// Bind the Sequence Dropdown
    /// </summary>
    public void BindSequenceNo()
    {
        string dsCommLine = string.Empty;
        dsCommLine = (CommentsType != "LC") ? comments.GetSeqNo(poNumber, CommentsType) : comments.GetSeqNo(poNumber, CommentsType, ddlLineNo.SelectedValue.Trim());
        int seqCount = Convert.ToInt32(dsCommLine) + 1;
        lblSequence.Text = seqCount.ToString();
    }
    /// <summary>
    /// Bind the User enterd values
    /// </summary>
    private void BindCommentEntry()
    {
        try
        {
            ViewState["Mode"] = "EDIT";
            DataTable dsComment = comments.GetSoCommentDetail(hidCommID.Value);           
            SelectItem(ddlType, dsComment.Rows[0]["Type"].ToString().Trim());
            SelectItem(ddlLineNo, (Convert.ToInt32(dsComment.Rows[0]["CommLineNo"].ToString().Trim())).ToString());
            SelectItem(ddlFrom, dsComment.Rows[0]["FormsCd"].ToString().Trim());
            lblSequence.Text = dsComment.Rows[0]["CommLineSeqNo"].ToString();          
                       
            txtComment.Text = dsComment.Rows[0]["CommText"].ToString();
            ddlType.Enabled = false;
            ddlLineNo.Enabled = false;
            ddlStdComment.Enabled = false;
            chkStandard.Enabled = false;
            chkVendor.Enabled = false;
            chkStandard.Checked = false;
            upCommentEntry.Update();
        }
        catch (Exception)
        {
            throw;
        }

    }
    /// <summary>
    /// Clear User enter values in entry area
    /// </summary>
    private void ClearEntryControl()
    {
        SelectItem(ddlType, "LC");
        SelectItem(ddlFilter, "");
        SelectItem(ddlLineNo, "1");
        txtComment.Text = "";
        //lblItemCaption.Visible = false;
        //lblItemDesc.Visible = false;
        ddlFrom.SelectedIndex = 0;
        ddlStdComment.SelectedIndex = 0;
        ddlType.Enabled = true;
        ddlStdComment.Enabled = true;
        ddlLineNo.Enabled = true;
        chkComment.Checked = false;  
        chkVendor.Enabled = true;
                chkStandard.Enabled = true;
                chkStandard.Checked = true;


    }
    /// <summary>
    /// Bind the selected values of dropdown
    /// </summary>
    /// <param name="ddlControl"></param>
    /// <param name="value"></param>
    private void SelectItem(DropDownList ddlControl, string value)
    {
        ListItem lItem = ddlControl.Items.FindByValue(value) as ListItem;
        if (lItem != null)
            ddlControl.SelectedValue = value;
    }
    /// <summary>
    /// This method will only when user selected any quote value in main order entry screen
    /// </summary>
    private void HighLightForCommentLine()
    {

        if (Request.QueryString["ItemNo"] != null && Request.QueryString["ItemNo"].ToString() != "")
        {
            SelectItem(ddlType, "LC");

            int _lineNo = Convert.ToInt32(Request.QueryString["LineNo"].ToString()) / 10;
            SelectItem(ddlLineNo, _lineNo.ToString());
            ddlLineNo_SelectedIndexChanged(Page, new EventArgs());
        }
    }

    private void GetItemNumberInformation()
    {
        if (CommentsType == "LC" && ddlLineNo.Items.Count > 0)
        {
            int _lineNo = Convert.ToInt32(ddlLineNo.SelectedValue) * 10;
            //lblItemDesc.Text = comments.GetSOItemInformation(poNumber, _lineNo.ToString());
            //lblItemDesc.Visible = true;
            //lblItemCaption.Visible = true;
        }
        else
        {
            //lblItemDesc.Visible = false;
            //lblItemCaption.Visible = false;
        }
    }

    #endregion

    #region EventHandlers
    /// <summary>
    /// Save the User Input
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            string columnValue = "";
            if (ddlType.SelectedIndex != null)
            {
                if (ViewState["Mode"].ToString() == "ADD")
                {
                    try
                    {
                        if(ddlType.SelectedValue.Trim() =="LC")
                        Convert.ToInt32(ddlLineNo.SelectedValue.Trim());
                    }
                    catch (Exception ex)
                    { 
                        SetMessage("No Line Item for this Order", false);
                        upProgress.Update();
                        return;
                    }
                    string lineNo = ((ddlLineNo.Enabled == false) ? "" : (Convert.ToInt32(ddlLineNo.SelectedValue.Trim()) * 10).ToString());

                    //"fSOHeaderID,[Type],CommLineNo,CommLineSeqNo,FormsCd,CommText,EntryID,EntryDt"
                    columnValue = "'" + poNumber + "','" + ddlType.SelectedValue.Trim() + "','" + lineNo.ToString() +
                                   "','" + lblSequence.Text.ToString() + "','" + ddlFrom.SelectedValue.Trim() + "','" + txtComment.Text.Replace("'", "''") + "','" + Session["UserName"].ToString() +
                                    "','" + DateTime.Now.ToShortDateString() + "'";
                    comments.InsertSOExpense(columnValue);
                    
                    SetMessage(utility.AddMessage, true);

                }
                else
                {
                    // string whereClause = "pSOCommID=" + hidCommID.Value;
                    columnValue = "CommText='" + txtComment.Text.Replace("'", "''") +
                                 "',FormsCd='" + ddlFrom.SelectedValue.Trim() + "',ChangeID='" + Session["UserName"].ToString()
                                   + "',ChangeDt='" + DateTime.Now.ToShortDateString() + "'";
                    comments.UpdateSOComment(columnValue, hidCommID.Value);
                    SetMessage(utility.UpdateMessage, true);
                }

                ClearEntryControl();
                BindSequenceNo();
                BindDataGrid();
              
                 
                ViewState["Mode"] = "ADD";
                upCommentEntry.Update();
                upCommentGrid.Update();
            }
            else
            {
                lblMessage.Text = invalidMessage;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
            upProgress.Update();
        }
        catch (Exception ex)
        {

            throw;
        }
    }
    private void SetMessage(string message,bool isSuccess)
    {
        lblMessage.Text = message;
        lblMessage.ForeColor = ((isSuccess) ? System.Drawing.Color.Green : System.Drawing.Color.Red);

    }
    /// <summary>
    ///  Perform Edit & Delete 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvComment_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Edits")
        {

            hidCommID.Value = e.CommandArgument.ToString().Trim();
            BindCommentEntry();
            //GetItemNumberInformation();
        }
        else if (e.CommandName == "Deletes")
        {
            try
            {
                // string whereClause = "pSOCommID=" + e.CommandArgument.ToString();
                string columnValue = " DeleteDt='" + DateTime.Now.ToShortDateString() + "',ChangeID='" + Session["UserName"].ToString() + "',ChangeDt='" +
                                 DateTime.Now.ToShortDateString() + "'";
                comments.UpdateSOComment(columnValue, e.CommandArgument.ToString());                
                SetMessage(utility.DeleteMessage, true);
                BindDataGrid();
                ClearEntryControl();
                upCommentEntry.Update();
                upCommentGrid.Update();
                upProgress.Update();
            }
            catch (Exception ex)
            {
                throw;
            }
        }

    }
    /// <summary>
    /// Perform item databound event
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvComment_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (!chkComment.Checked)
            e.Row.Cells[10].Visible = false;

        if (e.Row.RowType == DataControlRowType.DataRow && (e.Row.Cells[10].Text != "&nbsp;" || Session["UserSecurity"].ToString() == ""))
        {
            e.Row.Cells[0].FindControl("lnlEdit").Visible = false;
            e.Row.Cells[0].FindControl("lnlDelete").Visible = false;
        }
    }

    protected void gvComment_Sorting(object sender, GridViewSortEventArgs e)
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

    protected void ddlType_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSequenceNo();
      //  GetItemNumberInformation();


        upCommentEntry.Update();
    }
    /// <summary>
    /// Fills the datagrid based on FilterConditions
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlFilter_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            BindDataGrid();
            upCommentGrid.Update();
        }
        catch (Exception ex)
        {
            throw;
        }
    }
    /// <summary>
    /// Binds the Datagrid based on Checkbox checked condition
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void chkComment_CheckedChanged(object sender, EventArgs e)
    {
        try
        {
            BindDataGrid();
            upCommentGrid.Update();
        }
        catch (Exception ex)
        {
            throw;
        }
    }

    protected void ddlStdComment_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlStdComment.SelectedItem.Text == "---- Standard ----")
        {
            txtComment.Text = "";
        }
        else if (ddlStdComment.SelectedItem.Text == "---- Vendor Specific ----")
        {
            txtComment.Text = "";
        }
        else
        {
            if (chkStandard.Checked)
            {
                if (chkVendor.Checked)
                {
                    try
                    {
                        SelectItem(ddlType, ddlStdComment.SelectedValue.Split('`')[0].ToString().Trim());
                        SelectItem(ddlFrom, ddlStdComment.SelectedValue.Split('`')[1].ToString().Trim());
                        txtComment.Text = ddlStdComment.SelectedItem.Text.Split('-')[1].ToString().Trim();
                    }
                    catch (Exception ex)
                    {

                        SelectItem(ddlType, ddlStdComment.SelectedValue.Trim());
                        SelectItem(ddlFrom, ddlStdComment.SelectedValue.Trim());
                        txtComment.Text = ddlStdComment.SelectedItem.Text.Trim();
                    }
                }
                else
                {
                    SelectItem(ddlType, ddlStdComment.SelectedValue.Split('`')[0].ToString().Trim());
                    SelectItem(ddlFrom, ddlStdComment.SelectedValue.Split('`')[1].ToString().Trim());
                    txtComment.Text = ddlStdComment.SelectedItem.Text.Split('-')[1].ToString().Trim();
                }
            }
            else
            {
                txtComment.Text = ddlStdComment.SelectedItem.Text.ToString().Trim();
            }

            ddlLineNo.Enabled = (ddlType.SelectedValue != "LC") ? false : true;
            BindSequenceNo();
            upCommentEntry.Update();
        }
    }
    /// <summary>
    /// Fills the SequenceNo based on LineNo dropdown.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlLineNo_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSequenceNo();
       // GetItemNumberInformation();

        upCommentEntry.Update();
    }
    #endregion

    protected void CheckBox2_CheckedChanged(object sender, EventArgs e)
    {
        //chkStandard.Checked = false;
        if (chkVendor.Checked)
        {
            if (chkStandard.Checked)
            {
               
                dtVendor = comments.GetVendorComment(vendorNo);
                DataRow drVendor = dtVendor.NewRow();
                drVendor[1] = "";
                drVendor[0] = "---- Vendor Specific ----";
                dtVendor.Rows.InsertAt(drVendor,0);

                dtStd = comments.GetStdComment();
                DataRow drStd = dtStd.NewRow();
                drStd[1] = "";
                drStd[0] = "---- Standard ----";
                dtStd.Rows.InsertAt(drStd, 0);
                
                dtVendor.Merge(dtStd);
                utility.BindListControls(ddlStdComment, "Comments", "TypeForm", dtVendor);
               
            }
            else
            {
                utility.BindListControls(ddlStdComment, "Comments", "TypeForm", comments.GetVendorComment(vendorNo), "---- Vendor Specific ----");
            }
        }

        else if (chkStandard.Checked == false && chkVendor.Checked == false)
        {
            utility.BindListControls(ddlStdComment, "Comments", "TypeForm", comments.EmptyStdComment(), "---- Standard ----");
        }
        else
        {
            utility.BindListControls(ddlStdComment, "Comments", "TypeForm", comments.GetStdComment(), "---- Standard ----");
        }
        txtComment.Text = "";
       

        
    }
    protected void chkStandard_CheckedChanged(object sender, EventArgs e)
    {
        //chkVendor.Checked = false;       
        if (chkStandard.Checked)
        {
            if (chkVendor.Checked)
            {
                dtVendor = comments.GetVendorComment(vendorNo);
                DataRow drVendor = dtVendor.NewRow();                 
                drVendor[0] = "---- Vendor Specific ----";
                dtVendor.Rows.InsertAt(drVendor, 0);

                dtStd = comments.GetStdComment();
                DataRow drStd = dtStd.NewRow();              
                drStd[0] = "---- Standard ----";
                dtStd.Rows.InsertAt(drStd, 0);

                dtVendor.Merge(dtStd);
                utility.BindListControls(ddlStdComment, "Comments", "TypeForm", dtVendor);
                
            }
            else
            {

                utility.BindListControls(ddlStdComment, "Comments", "TypeForm", comments.GetStdComment(), "---- Standard ----");
            }
        }

        else if (chkStandard.Checked == false && chkVendor.Checked == false)
        {
            utility.BindListControls(ddlStdComment, "Comments", "TypeForm", comments.EmptyVendorComment(vendorNo), "---- Vendor Specific ----");
        }
        else
        {
            utility.BindListControls(ddlStdComment, "Comments", "TypeForm", comments.GetVendorComment(vendorNo), "---- Vendor Specific ----");
        }
        txtComment.Text = "";
       
    }
    private void BindExport()
    {
        PrintDialogue1.CustomerNo = SoHeader.CustNumber;
        PrintDialogue1.PageUrl = Server.UrlEncode("CommentEntryExport.aspx?PONumber=" + poNumber + "&Type=" + ddlFilter.SelectedValue + "&Deleted=" + chkComment.Checked.ToString() + "&Sort=" + hidSort.Value);
        PrintDialogue1.PageTitle = "Comment Entry for So#" + poNumber;

    }
    
}
    