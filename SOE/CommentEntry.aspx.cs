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
using PFC.SOE.BusinessLogicLayer;

public partial class CommentEntry : System.Web.UI.Page
{
    #region Class Variable

    SalesOrderDetails soDetail = new SalesOrderDetails();
    SOCommentEntry comments = new SOCommentEntry();
    Utility utility = new Utility();
    string SoLineNo = "";
 
    #endregion

    #region Variable Declaration

    string soNumber = "";  
    
    public string CommentsType
    {
        get { return ddlType.SelectedValue; }
    }
    public string HeaderIDColumn
    {
        get
        {
            if (Session["OrderTableName"].ToString() == "SOHeader")
                return "fSOHeaderID";
            else if (Session["OrderTableName"].ToString() == "SOHeaderRel")
                return "fSOHeaderRelID";
            else if (Session["OrderTableName"].ToString() == "SOHeaderHist")
                return "fSOHeaderHistID";
            else
                return "fSOHeaderID";
        }
    }
    public string CommentTableName
    {
        get
        {
            if (Session["OrderTableName"].ToString() == "SOHeader")
                return "SOComments";
            else if (Session["OrderTableName"].ToString() == "SOHeaderRel")
                return "SOCommentsRel";
            else if (Session["OrderTableName"].ToString() == "SOHeaderHist")
                return "SOCommentsHist";
            else
                return "SOComments";
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
        soNumber = Request.QueryString["SONumber"].Replace("W","").ToString();

        // Line Comment logic
        if (Request.QueryString["LineNo"] != null && Request.QueryString["LineNo"].ToString() != "")
        {
            SoLineNo = Request.QueryString["LineNo"].ToString();
        }

        if (!IsPostBack)
        {
            ViewState["Mode"] = "ADD";
            BindCommentType();
            BindDropDowns();
            SoHeader.SONumber = soNumber;

            if (Session["OrderTableName"].ToString() == "SOHeaderHist")
            {
                soNumber = comments.GetIdentityFromHistoryTable(soNumber);
            }
            BindDataGrid();
            BindSequenceNo();

            //
            // If user selected quote line in the main order entry screen, then highlight the dropdown to "Line Comment"
            //
            HighLightForCommentLine();
        }
        else
        {
            if (Session["OrderTableName"].ToString() == "SOHeaderHist")
            {
                soNumber = comments.GetIdentityFromHistoryTable(soNumber);
            }
        }

        PrintDialogue1.CustomerNo = SoHeader.CustNumber;
        PrintDialogue1.PageUrl = Server.UrlEncode("commentEntryExport.aspx?SONumber=" + soNumber + "&Type=" + ddlFilter.SelectedValue + "&Deleted=" + chkComment.Checked.ToString() + "&CommentTableName=" + CommentTableName + "&HeaderTableName=" + Session["OrderTableName"].ToString());
        PrintDialogue1.PageTitle = "Comment Entry for So#" + soNumber;
        if (Session["UserSecurity"].ToString() == "")
            ibtnSave.Visible = false;
        
        
    }
    #endregion

    #region DeveloperCode
    /// <summary>
    /// Bind the Dropdown list
    /// </summary>
    private void BindCommentType()
    {
        string _whereClause ="";
        if (Request.QueryString["LineNo"]!= null && Request.QueryString["LineNo"] != "")
        {
            _whereClause = " and LD.ListValue<>'CT' and LD.ListValue<>'CB' ";
        }
        else
        {
            _whereClause = " and LD.ListValue<>'LC' ";
        }
        DataTable dtCommentType = comments.GetCommentType(_whereClause);
        utility.BindListControls(ddlType, "ListDesc", "ListValue", dtCommentType);
        utility.BindListControls(ddlFilter, "ListDesc", "ListValue", dtCommentType, "Active");
                

    }
    private void BindDropDowns()
    {

        utility.BindListControls(ddlFrom, "ListDesc", "ListValue", comments.GetForm(), "-- Select Form Type --");
        utility.BindListControls(ddlStdComment, "Comments", "TypeForm", comments.GetStdComment(), "-- Select Comments--");
    }
    /// <summary>
    /// Bind the Datagrid on SOHeaderID
    /// </summary>
    private void BindDataGrid()
     {
        string _whereClause = HeaderIDColumn+"= '" + soNumber + " ' and DeleteDt is null";
       
        if (chkComment.Checked)
            _whereClause = HeaderIDColumn + "= '" + soNumber + "'";

        if (ddlFilter.SelectedValue != "")
            _whereClause += " and Type ='" + ddlFilter.SelectedValue + "'";
        else
        {
            if (Request.QueryString["LineNo"] != "")
            {
                _whereClause += " and Type ='LC'";
            }
            else if (Request.QueryString["LineNo"] == "")
            {
                _whereClause += " and (Type='CB' OR Type='CT')";
            }
        }

        DataTable dsCommentEntry = comments.GetSoComment(_whereClause);
        if (dsCommentEntry != null)
        {
            dsCommentEntry.DefaultView.Sort = (hidSort.Value == "") ? "Type asc" : hidSort.Value;
            gvComment.DataSource = dsCommentEntry;
            gvComment.DataBind();

            Session["CommentAvailable"] = (gvComment.Rows.Count > 0 ? "true" : "false");           
        }

    }
    
    /// <summary>
    /// Bind the Sequence Dropdown
    /// </summary>
    public void BindSequenceNo()
    { 
        string dsCommLine = string.Empty;
        dsCommLine = (CommentsType != "LC") ? comments.GetSeqNo(soNumber, CommentsType) : comments.GetSeqNo(soNumber, CommentsType, SoLineNo);
        int seqCount = Convert.ToInt32(dsCommLine)+1;
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
            SelectItem(ddlType,dsComment.Rows[0]["Type"].ToString().Trim());               
            SelectItem(ddlFrom,dsComment.Rows[0]["FormsCd"].ToString().Trim());
            lblSequence.Text = dsComment.Rows[0]["CommLineSeqNo"].ToString();
            txtComment.Text = dsComment.Rows[0]["CommText"].ToString();
            SoLineNo = dsComment.Rows[0]["CommLineNo"].ToString();
            ddlType.Enabled = false;
            ddlStdComment.Enabled = false;
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
        ddlType.ClearSelection();
        ddlFilter.ClearSelection();
        txtComment.Text = "";
        lblItemCaption.Visible = false;
        lblItemDesc.Visible = false;    
        ddlFrom.SelectedIndex = 0;
        ddlStdComment.SelectedIndex = 0;
        ddlType.Enabled = true;
        ddlStdComment.Enabled = true;
        chkComment.Checked = false;

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

            int _lineNo = Convert.ToInt32(SoLineNo);
            ddlLineNo_SelectedIndexChanged(Page, new EventArgs());
        }
    }

    private void GetItemNumberInformation()
    {
        if (CommentsType == "LC")
        {
            int _lineNo = Convert.ToInt32(SoLineNo);
            lblItemDesc.Text = comments.GetSOItemInformation(soNumber, SoLineNo);
            lblItemDesc.Visible = true;
            lblItemCaption.Visible = true;
        }
        else
        {
            lblItemDesc.Visible = false;
            lblItemCaption.Visible = false;
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
            if (ddlType.SelectedIndex !=null )
            {
                if (ViewState["Mode"].ToString() == "ADD")
                {
                    string lineNo = (SoLineNo == "" ? "" : SoLineNo);
                    
                    //"fSOHeaderID,[Type],CommLineNo,CommLineSeqNo,FormsCd,CommText,EntryID,EntryDt"
                    columnValue = "'" + soNumber + "','" + ddlType.SelectedValue.Trim() + "','" + lineNo.ToString() +
                                   "','" + lblSequence.Text.ToString() + "','" + ddlFrom.SelectedValue.Trim() + "','" + txtComment.Text.Replace("'", "''") + "','" + Session["userName"].ToString() +
                                    "','" + DateTime.Now.ToShortDateString() + "'";
                    comments.InsertSOExpense(columnValue);
                    lblMessage.Text = utility.AddMessage;
                    

                }
                else
                {                    
                   // string whereClause = "pSOCommID=" + hidCommID.Value;
                    columnValue = "CommText='" + txtComment.Text.Replace("'", "''") +
                                 "',FormsCd='"+ddlFrom.SelectedValue.Trim()  + "',ChangeID='" + Session["UserName"].ToString()
                                   + "',ChangeDt='" + DateTime.Now.ToShortDateString() + "'";
                    comments.UpdateSOComment(columnValue, hidCommID.Value);
                    lblMessage.Text = utility.UpdateMessage;
                }
              
                ClearEntryControl();
                BindSequenceNo();
                BindDataGrid();
                ViewState["Mode"] = "ADD";
                BindCommentType();
                                
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
            BindCommentType();
            BindCommentEntry();
            GetItemNumberInformation();
        }
        else if (e.CommandName == "Deletes")
        {
            try
            {
               // string whereClause = "pSOCommID=" + e.CommandArgument.ToString();
                string columnValue = " DeleteDt='" + DateTime.Now.ToShortDateString() + "',ChangeID='" + Session["UserName"].ToString() + "',ChangeDt='" +
                                 DateTime.Now.ToShortDateString() + "'";
                comments.UpdateSOComment(columnValue, e.CommandArgument.ToString());
                lblMessage.Text = utility.DeleteMessage;
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
        
        if(e.Row.RowType==DataControlRowType.DataRow && (e.Row.Cells[10].Text!="&nbsp;" || Session["UserSecurity"].ToString() == ""))
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
        GetItemNumberInformation();
        
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
        SelectItem(ddlType,ddlStdComment.SelectedValue.Split('`')[0].ToString().Trim());
        SelectItem(ddlFrom, ddlStdComment.SelectedValue.Split('`')[1].ToString().Trim());
        txtComment.Text = ddlStdComment.SelectedItem.Text.Split('-')[1].ToString().Trim();
        
        BindSequenceNo();
        upCommentEntry.Update();
    }
    /// <summary>
    /// Fills the SequenceNo based on LineNo dropdown.
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlLineNo_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindSequenceNo();
        GetItemNumberInformation();        
        
        upCommentEntry.Update();
    }

}
    #endregion