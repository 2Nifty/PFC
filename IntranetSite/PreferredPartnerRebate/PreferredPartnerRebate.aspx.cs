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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;


public partial class PreferredPartnerRebate : System.Web.UI.Page
{
    #region Variable Declaration
    string columnName = "";
    string columnValue = "";
    string whereClause = "";
    string currentControl = "";

    string noRecordMessage = "No Records Found";
    string queryMessage = "Data added Successfully"; //"Query Completed Successfully"
    string queryString = "";
    string errorMessage = "EndDate Must be greater than StartDate";
    string deleteMessage = "Data deleted Successfully";
    string updateMessage = "Data is updated successfully";

    #endregion

    string connectionString = ConfigurationManager.ConnectionStrings["PFCReportsConnectionString"].ToString();
   

    PartnerRebate rebate = new PartnerRebate();
    DataTable dtRebate = new DataTable();
 
   
    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(PreferredPartnerRebate));
        ddlChainCust.Attributes.Add("style", "text-align:center");
        if (!IsPostBack)
        {
            BindProgram();           
            ViewState["Mode"] = "Add";
            gvRebate.EditItemIndex = 0;
            BindChainCustNo();
            //BindGridRebate();
            ViewState["WhereClause"] = "";
            btnAdd.Visible = false;
        }


    }

    #region Developer Methods
    /// <summary>
    /// To Bind the Program Name dropdown
    /// </summary>
    private void BindProgram()
    {
        rebate.BindListControls(ddlProgram, "ListDesc", "ListValue", rebate.GetProgram(), "--Select--");
    }

    /// <summary>
    /// To Bind Chain and Cust # dropdown
    /// </summary>
    private void BindChainCustNo()
    {
        lblCustName.Text = "";

        if (rdoCustChain.SelectedValue == "Chain")
        {
            rebate.BindListControls(ddlChainCust, "ChainCd", "ChainCd", rebate.GetChainNo(), "--Select--");
        }
        if (rdoCustChain.SelectedValue == "Cust")
        {
            rebate.BindListControls(ddlChainCust, "CustNo", "CustName", rebate.GetCustomerNo(), "--Select--");
        }
      
    } 

    /// <summary>
    /// To Bind the Grid 
    /// </summary>
    private void BindGridRebate()

    {
        string whereClause = "";
        string dateClause = ((ViewState["Condition"].ToString() == "") ? "" : " and " + ViewState["Condition"].ToString());
        if (ddlProgram.SelectedIndex == 0 && ddlChainCust.SelectedIndex == 0)
        {
            whereClause = (ViewState["Condition"].ToString() == "") ? "1=1" : ViewState["Condition"].ToString();
        }
        else if (ddlProgram.SelectedIndex != 0 && ddlChainCust.SelectedIndex == 0)
        {
            whereClause = "SalesPrograms.ProgramName='" + ddlProgram.SelectedItem.Value.ToString() + "'" + dateClause;

        }
        else if (ddlProgram.SelectedIndex == 0 && ddlChainCust.SelectedIndex != 0)
        {
            whereClause = "SalesPrograms.CustNoChainCd='" + ddlChainCust.SelectedItem.Text.Trim() + "'" + dateClause;

        }
        else
        {
            whereClause = "SalesPrograms.ProgramName='" + ddlProgram.SelectedItem.Value.ToString() + "' and SalesPrograms.CustNoChainCd='" + ddlChainCust.SelectedItem.Text.ToString() + "'" +
                            dateClause;

        }

        ViewState["WhereClause"] = whereClause;
         
        //lblCustName.Text = ddlChainCust.SelectedItem.Value.ToString();

        dtRebate = rebate.GetData(whereClause);

        if (dtRebate.Rows.Count == 0  )
        {
            rebate.DisplayMessage(MessageType.Failure, noRecordMessage, lblMessage);
            
        }
        else
        {
            rebate.DisplayMessage(MessageType.None, queryString, lblMessage);
        }

        //Adds a new row to the grid 

        DataRow dr = dtRebate.NewRow();
        dtRebate.Rows.InsertAt(dr, 0);

        gvRebate.DataSource = dtRebate;
       
        gvRebate.DataBind();
        upAdd.Update();
        upMessage.Update();
        upnlgrid.Update();
    }

    /// <summary>
    /// Clear the Controls value
    /// </summary>
    private void ClearControl()
    {
        ddlProgram.SelectedIndex = 0;
        ddlChainCust.SelectedIndex = 0;
        dtpStartDate.SelectedDate = "";
        dtpEndDate.SelectedDate = "";
        lblCustName.Text = "";
    }

#endregion

    #region  Ajax Methods

    /// <summary>
    /// Method to validate Baseline with the Sales History value
    /// </summary>
    /// <param name="baseline"></param>
    /// <param name="history"></param>
    /// <returns></returns>
    
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string ValidateBase(string baseline, string history)
    {
        try
        {
            if (Convert.ToDecimal(baseline) >= Convert.ToDecimal(history))
                return "true";
            else
                return "false";
        }
        catch (Exception ex)
        {
            return "false";
            throw;
        }
    }

    /// <summary>
    /// To Get the SalesHistory Value  
    /// </summary>
    /// <param name="category"></param>
    /// <returns></returns>
     
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string GetSalesHist(string category)
    {
        try
        {
            string salesHist=rebate.GetSalesHist(category);
            if (salesHist != "" && salesHist != null)

                return salesHist;
            else
                return "0.00";
        }
        catch (Exception ex)
        {
            return "0.00";
        }
    }
    /// <summary>
    /// Method to format the Sales History Value 
    /// </summary>
    /// <param name="hist"></param>
    /// <returns></returns>
     
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string GetHistValue(string hist)
    {
        hist = ((hist == "") ? "0" : hist);
        string histVal = String.Format("{0:#,##0.00}", Convert.ToDecimal(hist));
        return histVal;
    }

#endregion

    #region Error Log
    /// <summary>
    /// Methos to enter a error log when  the Baseline value is lesser  than Sales History Value
    /// </summary>
    /// <param name="id"></param>
    public void ErrorLog(string id)
    {

        SqlHelper.ExecuteNonQuery(connectionString, "[pUTInsertErrLog]",
                                new SqlParameter("@dbID", id),  
                                new SqlParameter("@table", "SalesPrograms"),
                                new SqlParameter("@msg", "Beaseline value lesser than Saleshistory "), //Comment
                                new SqlParameter("@userName", Session["UserName"].ToString()),
                                new SqlParameter("@appFunction", "PPR"), 
                                new SqlParameter("@procedureName", "Ugen_Sp_Insert"));

    }
#endregion

    #region Event Handlers
    /// <summary>
    /// Insert the Rebate value 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnAdd_Click(object sender, ImageClickEventArgs e)
    {

        DropDownList ddlCategoryVal = gvRebate.Items[0].FindControl("ddlCategory") as DropDownList;
        Label lblEDescriptionVal = gvRebate.Items[0].FindControl("lblEDescription") as Label;
       // Label lblEHistoryVal = gvRebate.Items[0].FindControl("lblEHistory") as Label;
        //HiddenField hidHistoryVal = gvRebate.Items[0].FindControl("hidHistory") as HiddenField;
        TextBox txtBaseLineVal = gvRebate.Items[0].FindControl("txtBaseLine") as TextBox;
        TextBox txtGoalVal = gvRebate.Items[0].FindControl("txtGoal") as TextBox;
        TextBox txtRebateVal = gvRebate.Items[0].FindControl("txtRebate") as TextBox;
        DateTime stDate = (dtpStartDate.SelectedDate!="")? Convert.ToDateTime(dtpStartDate.SelectedDate):DateTime.Now;
        DateTime endDate = (dtpEndDate.SelectedDate != "") ? Convert.ToDateTime(dtpEndDate.SelectedDate) : DateTime.Now;

        if (ddlCategoryVal.SelectedIndex > 0)
        {
            if (endDate >= stDate)
            {

                if (ViewState["Mode"].ToString() == "Add")
                {
                    columnName = "ProgramName,CustNoChainCd,Category,SalesHistory,SalesBaseline,SalesGoal," +
                                 "RebatePct,ProgramStartDt,ProgramEndDt,EntryId,EntryDt";
                    columnValue = "'" + ddlProgram.SelectedItem.Value.ToString() + "'," +
                                 "'" + ddlChainCust.SelectedItem.Text.ToString() + "'," +
                                 "'" + ddlCategoryVal.SelectedItem.Text.ToString() + "'," +
                                 ((hidHistory.Value.Trim() == "") ? "0" : hidHistory.Value.Trim()) + "," +
                                 ((txtBaseLineVal.Text.Trim() == "") ? "0" : txtBaseLineVal.Text.Trim()) + "," +
                                 ((txtGoalVal.Text.Trim() == "") ? "0" : txtGoalVal.Text.Trim()) + "," +
                                ((txtRebateVal.Text.Trim() == "") ? "0" : txtRebateVal.Text.Trim()) + "," +
                                 "'" + dtpStartDate.SelectedDate + "'," +
                                 "'" + dtpEndDate.SelectedDate + "'," +
                                 "'" + Session["Username"].ToString() + "'," +
                                 "'" + DateTime.Now.ToShortDateString() + "'";

                    object insertID = rebate.InsertTables(columnName, columnValue);
                    if (hidErrorStatus.Value == "true")
                    {
                        ErrorLog(insertID.ToString());
                    }
                    hidErrorStatus.Value = "";
                    BindGridRebate();
                    rebate.DisplayMessage(MessageType.Success, queryMessage, lblMessage);
                }
            }
            else
            {
                rebate.DisplayMessage(MessageType.Failure, errorMessage, lblMessage);
            }
        }
        else
        {
            ScriptManager.RegisterClientScriptBlock(btnAdd, btnAdd.GetType(), "validation", "alert(\"Select Category Value\")", true);       
        }
        upMessage.Update();
    }
    
    protected void rdoCustChain_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindChainCustNo();

    }
   
   
    protected void ddlChainCust_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (rdoCustChain.SelectedValue == "Chain")
        {
            lblCustName.Text = rebate.GetChainName(ddlChainCust.SelectedItem.Value.ToString());
            //rebate.BindListControls(ddlChainCust, "ChainCd", "ChainCd", rebate.GetChainNo(), "--Select--");
        }
        else
        {
            lblCustName.Text = ddlChainCust.SelectedItem.Value.ToString();
        }
    }

    protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
    {
        //BindGridRebate();

        
        string queryString = "Program=" + hidProgramName.Value + "&ChainNo=" + hidCustChain.Value +
                          "&CustName=" + Server.UrlEncode(hidCustName.Value) + "&Start=" + hidStDate.Value +
                          "&End=" + hidEndDate.Value + "&Where=" + ViewState["WhereClause"].ToString().Replace("'","`");

        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "PrintReport('" + queryString + "');", true);

    }

    protected void ibtnSearch_Click(object sender, ImageClickEventArgs e)
    {

        if (ddlProgram.SelectedIndex == 0)
        {
            ScriptManager.RegisterClientScriptBlock(ibtnSearch, ibtnSearch.GetType(), "validation", "alert(\"Select program name\")", true);
        }
        else if (ddlChainCust.SelectedIndex == 0)
        {
            ScriptManager.RegisterClientScriptBlock(ibtnSearch, ibtnSearch.GetType(), "validation", "alert(\"Select Customer Or Chain Number\")", true);
        }
        else
        {
            string condition = "";

            if (dtpStartDate.SelectedDate != "" && dtpEndDate.SelectedDate != "")
                condition = "  ProgramStartDt" + " between convert(datetime,'" + dtpStartDate.SelectedDate + "') and convert(datetime,'" + dtpEndDate.SelectedDate + "')";
            else if (dtpStartDate.SelectedDate != "")
                condition = "  ProgramStartDt" + " >= convert(datetime,'" + dtpStartDate.SelectedDate + "')";
            else if (dtpEndDate.SelectedDate != "")
                condition = "  ProgramEndDt " + " <= convert(datetime,'" + dtpEndDate.SelectedDate + "')";
            else
                condition = "";
            ViewState["Condition"] = condition.ToString();
            gvRebate.EditItemIndex = 0;
            hidProgramName.Value = ((ddlProgram.SelectedIndex == 0) ? "ALL" : ddlProgram.SelectedItem.Text);
            hidCustChain.Value = ((ddlChainCust.SelectedIndex == 0) ? "ALL" : ddlChainCust.SelectedItem.Text);
            hidCustName.Value = (ddlChainCust.SelectedItem.Value != "") ? ddlChainCust.SelectedItem.Value.ToString() : "ALL";
            hidStDate.Value = dtpStartDate.SelectedDate;
            hidEndDate.Value = dtpEndDate.SelectedDate;
            btnAdd.Visible = true;
            BindGridRebate();
        }
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        string whereClause = "pSalesProgramId=" + hidDelete.Value + "";
        rebate.DeleteTables(whereClause);
        gvRebate.EditItemIndex = 0;
        BindGridRebate();
        rebate.DisplayMessage(MessageType.Success, deleteMessage, lblMessage);
        upMessage.Update();
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Load", "document.getElementById('hidRowID').value ='';document.getElementById('divDelete').style.display='none';", true);

    }

    #endregion

    #region Grid Event Handlers

    protected void gvRebate_ItemDataBound(object sender, DataGridItemEventArgs e)
    {

        if (e.Item.ItemType == ListItemType.EditItem)
        {
            DropDownList ddlCategory = e.Item.FindControl("ddlCategory") as DropDownList;

            if (e.Item.ItemIndex == 0)
            {
                rebate.BindListControls(ddlCategory, "Category", "Description", rebate.GetCategory(), "--Select--");
                e.Item.FindControl("lnkUpdate").Visible = false;
                e.Item.FindControl("lnkCancel").Visible = false;
            }
            else
            {
                ddlCategory.Visible = false;
                TextBox txtBase = e.Item.FindControl("txtBaseLine") as TextBox;
                txtBase.Enabled = true;
                currentControl = txtBase.ClientID;
            }
        }
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Label lblCategoryVal = e.Item.FindControl("lblCategory") as Label;
            HiddenField hidSalesId = e.Item.FindControl("hidSalesID") as HiddenField;

            //Code to display Context menu on right click (Delete ,Cancel )

            lblCategoryVal.Attributes.Add("onmousedown", "if(document.getElementById('hidRowID').value != '')document.getElementById(document.getElementById('hidRowID').value).style.fontWeight='normal';document.getElementById('divDelete').style.display='';hidRowID.value='" + e.Item.ClientID + "';DeleteRebate('" + hidSalesId.Value + "',this.id,event);document.getElementById('" + e.Item.ClientID + "').style.fontWeight='bold';");
            // e.Item.Attributes.Add("onmousedown", "if(document.getElementById('hidRowID').value != '')document.getElementById(document.getElementById('hidRowID').value).style.fontWeight='normal';document.getElementById('divDelete').style.display=''; DeleteRebate('" + hidSalesId.Value + "',this.id,event);document.getElementById('" + e.Item.ClientID + "').style.fontWeight='bold';hidRowID.value='" + e.Item.ClientID + "'");
            //lblCategoryVal.Attributes.Add("onmousedown", "if(document.getElementById('hidRowID').value != '')document.getElementById(document.getElementById('hidRowID').value).style.fontWeight='normal';DeleteQuote('" + hidLineNo.Value.Trim() + "','" + lblQuote.Text + "',this.id,event);document.getElementById('" + e.Item.ClientID + "').style.fontWeight='bold';hidRowID.value='" + e.Item.ClientID + "'");

            if (e.Item.ItemIndex == 0)
            {
                e.Item.FindControl("lnkEdit").Visible = false;
            }
        }

        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[1].Text = "Total:";
            e.Item.Cells[3].Text = String.Format("{0: ###,##0.00}", dtRebate.Compute("sum(SalesHistory)", ""));
            e.Item.Cells[4].Text = String.Format("{0:###,##0.00}", dtRebate.Compute("sum(SalesBaseline)", ""));
            e.Item.Cells[5].Text = String.Format("{0:###,##0.00}", dtRebate.Compute("sum(SalesGoal)", ""));
        }
    }


    protected void gvRebate_SortCommand(object source, DataGridSortCommandEventArgs e)
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
        gvRebate.EditItemIndex = 0;
        BindGridRebate();
    }

    protected void gvRebate_ItemCommand(object source, DataGridCommandEventArgs e)
    {
        if (e.CommandName == "Edits")
        {
            Label lblBaseLine = gvRebate.Items[e.Item.ItemIndex].FindControl("lblBaseLine") as Label;
            btnAdd.Visible = false;
            gvRebate.EditItemIndex = e.Item.ItemIndex;        
            BindGridRebate();
            SMPreferred.SetFocus(currentControl);

            //Code to Set focus on the grid 
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Focus", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "';", true);
            
        }
        else if (e.CommandName == "Cancel")
        {
            gvRebate.EditItemIndex = 0;
            btnAdd.Visible = true;
            BindGridRebate();
        }
        else if (e.CommandName == "Update")
        {
           
            TextBox txtBaseLineVal = gvRebate.Items[e.Item.ItemIndex].FindControl("txtBaseLine") as TextBox;
            TextBox txtGoalVal = gvRebate.Items[e.Item.ItemIndex].FindControl("txtGoal") as TextBox;
            TextBox txtRebateVal = gvRebate.Items[e.Item.ItemIndex].FindControl("txtRebate") as TextBox;           

            columnValue = "SalesBaseline=" +  ((txtBaseLineVal.Text.Trim() == "") ? "0" : txtBaseLineVal.Text.Trim().Replace(",", "")) + ",SalesGoal=" +
                                        ((txtGoalVal.Text.Trim() == "") ? "0" : txtGoalVal.Text.Trim().Replace(",", "")) + ",RebatePct=" +
                                       ((txtRebateVal.Text.Trim() == "") ? "0" : txtRebateVal.Text.Trim().Replace(",","")) + ",ChangeId=" +                                       
                                        "'" + Session["UserName"].ToString().Replace("'","''") + "',Changedt=" +
                                        "'" + DateTime.Now.ToShortDateString() + "'";

            rebate.UpdateValue(columnValue, "pSalesProgramID="+e.CommandArgument.ToString());
            btnAdd.Visible = true;
            gvRebate.EditItemIndex = 0;
            BindGridRebate();
            rebate.DisplayMessage(MessageType.Success, updateMessage, lblMessage);
            upMessage.Update();

            
        }
    }

    #endregion
}
     