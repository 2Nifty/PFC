/********************************************************************************************
 * File	Name			:	EnterExpense.aspx.cs
 * File Type			:	C#
 * Project Name			:	Sales Order Entry
 * Module Description	:	Enter Expense for orders
 * Created By			:	Sathya Ramasamy
 * Created Date			:	10/27/2008	
 * History*				: 
 * DATE					AUTHOR			                ACTION
 * ****					******				            ******
 * 10/27/2008           Sathya Ramasamy                 Created

 *********************************************************************************************/

#region Namespace
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
#endregion

public partial class EnterExpenses : System.Web.UI.Page
{
    #region Class Variable
    ExpenseEntry expenseEntry = new ExpenseEntry();
    Utility utility = new Utility(); 
    #endregion

    #region Variable Declaration

    string poNumber = "";
    string invalidMessage = "Select Valid Expense Code";
    string deleteMessage = "Data had been successfully deleted";
    string updateMessage = "Data has been successfully updated";
    string addMessage = "Data has been successfully added";
    #endregion

    #region Page Load Event
    /// <summary>
    /// Page Load Event Handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        

        poNumber = Request.QueryString["PONumber"].ToString();

      // poNumber = "1";
        if (!IsPostBack)
        {
            
           

            //Bind Expense Code dropdown
            BindExpenseCode();
            SoHeader.PONumber = poNumber;
            BindDataGrid();

            PrintDialogue1.CustomerNo = SoHeader.CustNumber;
            PrintDialogue1.PageUrl = Server.UrlEncode("ExpenseEntryExport.aspx?PONumber=" + poNumber);
            PrintDialogue1.PageTitle = "Enter Expenses for " + poNumber;

            // Maintain Mode of operation 
            ViewState["Mode"] = "ADD";
        }

        if (Session["UserSecurity"].ToString() == "")
            ibtnSave.Visible = false;
    } 
    #endregion

    #region Developer Code
    /// <summary>
    /// Bind Expense Code dropdown
    /// </summary>
    private void BindExpenseCode()
    {
        utility.BindListControls(ddlCode, "ShortDsc", "TableCd", expenseEntry.GetExpenseCode(), "-- Select Code --");
    }
    /// <summary>
    /// Bind Expense grid based on SOHeader id
    /// </summary>
    private void BindDataGrid()
    {
        hidNetSales.Value = expenseEntry.GetAmount(poNumber);
        DataSet dsExpense = expenseEntry.GetPOExpense(poNumber);
        if (dsExpense != null)
        {
            dsExpense.Tables[0].DefaultView.Sort = (hidSort.Value == "") ? "LineNumber asc" : hidSort.Value;

            gvExpense.DataSource = dsExpense.Tables[0].DefaultView.ToTable();
            gvExpense.DataBind();

            Session["ExpenseAvailable"] = (gvExpense.Rows.Count > 0 ? "true" : "false");     

            lblLineNo.Text = (dsExpense.Tables[0].Rows.Count == 0) ? "1" : Convert.ToString(dsExpense.Tables[0].Rows.Count + 1);
        }

    }
    /// <summary>
    /// Perform grid sorting operation
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    /// /// <summary>
    /// Calculate amount
    /// </summary>
    private void CalculateAmount()
    {
        
        decimal amount;
        decimal percent = Convert.ToDecimal((txtPercent.Text == "") ? "0" : txtPercent.Text);
        decimal netSales = Convert.ToDecimal((hidNetSales.Value == "") ? "0" : hidNetSales.Value);
        amount = netSales * (percent / 100);
        txtAmount.Text = String.Format("{0:###0.00}", amount);
    }
    /// <summary>
    /// Calculate Percent
    /// </summary>
    private void CalculatePercent()
    {
        decimal percent;
        decimal amount = Convert.ToDecimal((txtAmount.Text == "") ? "0" : txtAmount.Text);
        decimal netSales = Convert.ToDecimal((hidNetSales.Value == "") ? "0" : hidNetSales.Value);
        percent = (netSales == 0) ? 0 : (amount / netSales) * 100;
        txtPercent.Text = String.Format("{0:###0.00}", percent);
    }
    /// <summary>
    /// Clear user enter values in entry area
    /// </summary>
    private void ClearEntryControl()
    {
        ddlCode.SelectedIndex = 0;
        lblDescription.Text = "";
        txtPercent.Text = "0.00";
        txtAmount.Text = "0.00";        
        chkTaxable.Checked = false;
        lblIndicator.Text = "";
    }
    /// <summary>
    /// Bind User entered values 
    /// </summary>
    private void BindEntryControl()
    {
        try
        {
            ViewState["Mode"] = "EDIT";
            DataTable dsExpense = expenseEntry.GetExpenseDetail(hidExpenseID.Value);
            ddlCode.SelectedIndex = -1;
            ListItem lstItem = ddlCode.Items.FindByValue(dsExpense.Rows[0]["ExpenseCd"].ToString().Trim()) as ListItem;
            if (lstItem != null)
                lstItem.Selected = true;
            lblDescription.Text = dsExpense.Rows[0]["Dsc"].ToString();
            txtAmount.Text = dsExpense.Rows[0]["Amount"].ToString();
            chkTaxable.Checked = (dsExpense.Rows[0]["TaxStatus"].ToString().Trim() == "Y") ? true : false;
            lblIndicator.Text = dsExpense.Rows[0]["ExpenseInd"].ToString();
            if (lblIndicator.Text.Trim() == "P")
            {
                txtPercent.Visible = true;
                lblPctCaption.Visible = true;
            }
            else
            {
                txtPercent.Visible = false;
                lblPctCaption.Visible = false;
            }                

            lblLineNo.Text = dsExpense.Rows[0]["LineNumber"].ToString();
            CalculatePercent();
            upExpenseEntry.Update();
        }
        catch (Exception)
        {
            throw;
        }

    }

    #endregion

    #region Event Handlers
    protected void gvExpense_Sorting(object sender, GridViewSortEventArgs e)
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
    /// perform edit and delete  
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvExpense_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Edits")
        {
            hidExpenseID.Value = e.CommandArgument.ToString().Trim();
            BindEntryControl();
        }
        else if (e.CommandName == "Deletes")
        {
            try
            {
                //string whereClause = "pSOExpenseID=" + e.CommandArgument.ToString();
                string columnValue = " DeleteDt='" + DateTime.Now.ToShortDateString() + "',ChangeID='" + Session["UserName"].ToString() + "',ChangeDt='" +
                                 DateTime.Now.ToShortDateString() + "'";
                expenseEntry.UpdatePOExpense(columnValue, e.CommandArgument.ToString());
                //lblMessage.Text = utility.DeleteMessage;
                utility.DisplayMessage(MessageType.Success, deleteMessage, lblMessage);
                BindDataGrid();
                ClearEntryControl();
                upExpenseEntry.Update();
                upExpenseGrid.Update();
                upProgress.Update();
            }
            catch (Exception ex)
            {
                throw;
            }
        }

    }
    /// <summary>
    /// Perform item data bound event
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvExpense_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if ((e.Row.Cells[8].Text != "" && e.Row.Cells[8].Text != "&nbsp;") ) //|| Session["UserSecurity"].ToString() == "")
            {
                e.Row.Cells[0].Controls[1].Visible = false;
                e.Row.Cells[0].Controls[3].Visible = false;
            }
        }
    }
    /// <summary>
    /// Save the user input
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            string columnValue = "";
            if (ddlCode.SelectedIndex > 0)
            {
                if (ViewState["Mode"].ToString() == "ADD")
                {
                    //fSOHeaderID,LineNumber,ExpenseCd,Amount,Cost,ExpenseInd,TaxStatus,EntryID,EntryDt
                    columnValue = "'" + poNumber + "','" + lblLineNo.Text.Trim() + "','" + ddlCode.SelectedValue.Trim() + "','" +
                                         txtAmount.Text + "','" + lblIndicator.Text + "','" +
                                         ((chkTaxable.Checked) ? "Y" : "N") + "','" + Session["UserName"].ToString() + "','" +
                                         DateTime.Now.ToShortDateString() + "','"+lblDescription.Text+"'";
                    expenseEntry.InsertPOExpense(columnValue);
                    utility.DisplayMessage(MessageType.Success, "Data has been successfully added", lblMessage);
                }
                else
                {
                   // string whereClause = "pSOExpenseID=" + hidExpenseID.Value;
                    columnValue = "ExpenseCd='" + ddlCode.SelectedValue.Trim() + "',Amount=" +
                                     txtAmount.Text + ",ExpenseInd='" + lblIndicator.Text + "',TaxStatus='" +
                                     ((chkTaxable.Checked) ? "Y" : "N") + "',ChangeID='" + Session["UserName"].ToString() + "',ChangeDt='" +
                                     DateTime.Now.ToShortDateString() + "',ExpenseDesc='"+lblDescription.Text+"'";
                    expenseEntry.UpdatePOExpense(columnValue, hidExpenseID.Value);
                    //lblMessage.Text = utility.UpdateMessage;
                    utility.DisplayMessage(MessageType.Success, updateMessage, lblMessage);
                }
                ViewState["Mode"] = "ADD";
                ClearEntryControl();
                BindDataGrid();
                upExpenseEntry.Update();
                upExpenseGrid.Update();
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
    /// Export Page
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
   
    /// <summary>
    /// Fill expense detail based on expense code
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ddlCode_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlCode.SelectedIndex != 0)
        {
            DataTable dtExpenseCodeDetail = expenseEntry.GetExpenseCodeDetail(ddlCode.SelectedValue.Trim());

            if (dtExpenseCodeDetail != null && dtExpenseCodeDetail.Rows.Count > 0)
            {
                lblDescription.Text = dtExpenseCodeDetail.Rows[0]["Description"].ToString();

                lblIndicator.Text = dtExpenseCodeDetail.Rows[0]["ExpType"].ToString();

                if (lblIndicator.Text.Trim() == "P")
                {
                    txtPercent.Text = String.Format("{0:###0.00}", dtExpenseCodeDetail.Rows[0]["Percent"]);

                    txtPercent.Visible = true;
                    lblPctCaption.Visible = true;
                }
                else
                {
                    txtPercent.Visible = false;
                    lblPctCaption.Visible = false;
                }
                    
                chkTaxable.Checked = (dtExpenseCodeDetail.Rows[0]["TaxStatus"].ToString().Trim() == "Y") ? true : false;
                CalculateAmount();
            }
        }
        else
            ClearEntryControl();

        upExpenseEntry.Update();
    }
    /// <summary>
    /// Calculate Amount while changing Percent
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void txtPercent_TextChanged(object sender, EventArgs e)
    {
        CalculateAmount();
        upExpenseEntry.Update();
    }
    /// <summary>
    /// Calculate Percent  while changing Amount 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void txtAmount_TextChanged(object sender, EventArgs e)
    {
        CalculatePercent();
        upExpenseEntry.Update();
    }
    //protected void imgExport_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        hidPrintURL.Value = Server.UrlEncode("ExpenseEntryExport.aspx?SONumber=" + soNumber);
    //        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "ExportExpense();", true);

    //    }
    //    catch (Exception ex) { }
    //}
    //protected void imgPrint_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        hidPrintURL.Value = Server.UrlEncode("ExpenseEntryExport.aspx?SONumber=" + soNumber);
    //        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "ExportExpense('Print');", true);

    //    }
    //    catch (Exception ex) { }
    //}
    //protected void imgMail_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        hidPrintURL.Value = Server.UrlEncode("ExpenseEntryExport.aspx?SONumber=" + soNumber);
    //        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Email", "ExportExpense('Email');", true);
    //    }
    //    catch (Exception ex) { }
    //}
    //protected void imgFax_Click(object sender, EventArgs e)
    //{
    //    try
    //    {
    //        hidPrintURL.Value = Server.UrlEncode("ExpenseEntryExport.aspx?SONumber=" + soNumber);
    //        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Fax", "ExportExpense('Fax');", true);
    //    }
    //    catch (Exception ex) { }
    //}
    #endregion
    
}
