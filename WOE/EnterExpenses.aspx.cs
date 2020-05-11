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
using PFC.SOE.BusinessLogicLayer; 
#endregion

public partial class EnterExpenses : System.Web.UI.Page
{
    #region Class Variable
    ExpenseEntry expenseEntry = new ExpenseEntry();
    Utility utility = new Utility(); 
    #endregion

    #region Variable Declaration

    string soNumber = "";
    string invalidMessage = "Select Valid Expense Code";
    
    #endregion

    #region Page Load Event
    /// <summary>
    /// Page Load Event Handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        soNumber = Request.QueryString["SONumber"].ToString().Replace("W", "");
        if (!IsPostBack)
        {
            //Bind Expense Code dropdown
            BindExpenseCode();
            SoHeader.SONumber = soNumber;
            BindDataGrid();

            PrintDialogue1.CustomerNo = SoHeader.CustNumber;
            PrintDialogue1.PageUrl = Server.UrlEncode("ExpenseEntryExport.aspx?SONumber=" + soNumber); 
            PrintDialogue1.PageTitle = "Enter Expenses for " + soNumber;

            // Maintain Mode of operation 
            ViewState["Mode"] = "ADD";

            ScriptManager1.SetFocus(ddlCode);
        }
        if (Session["UserSecurity"].ToString() == "" )
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
        DataSet dsExpense = expenseEntry.GetSOExpense(soNumber);
        if (dsExpense != null)
        {
            dsExpense.Tables[0].DefaultView.Sort = (hidSort.Value == "") ? "LineNumber asc" : hidSort.Value;

            if (hidShowActiveLine.Value == "true")
                dsExpense.Tables[0].DefaultView.RowFilter = "DeleteDt is null";

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
        lblCost.Text = "0.00";
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
            lblCost.Text = dsExpense.Rows[0]["Cost"].ToString();
            chkTaxable.Checked = (dsExpense.Rows[0]["TaxStatus"].ToString().Trim() == "Y") ? true : false;
            lblIndicator.Text = dsExpense.Rows[0]["ExpenseInd"].ToString();
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
                expenseEntry.UpdateSOExpense(columnValue, e.CommandArgument.ToString());
                expenseEntry.ReExtendOrderHeader(soNumber);
                lblMessage.Text = utility.DeleteMessage;
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
            if ((e.Row.Cells[8].Text != "" && e.Row.Cells[8].Text != "&nbsp;") || Session["UserSecurity"].ToString() == "")
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
                    columnValue = "'" + soNumber + "','" + lblLineNo.Text.Trim() + "','" + ddlCode.SelectedValue.Trim() + "','" +
                                         txtAmount.Text + "','" + lblCost.Text + "','" + lblIndicator.Text + "','" +
                                         ((chkTaxable.Checked) ? "Y" : "N") + "','" + Session["UserName"].ToString() + "','" +
                                         DateTime.Now.ToShortDateString() + "','"+lblDescription.Text+"'";
                    expenseEntry.InsertSOExpense(columnValue);
                    lblMessage.Text = utility.AddMessage;
                }
                else
                {
                   // string whereClause = "pSOExpenseID=" + hidExpenseID.Value;
                    columnValue = "ExpenseCd='" + ddlCode.SelectedValue.Trim() + "',Amount=" +
                                     txtAmount.Text + ",Cost=" + lblCost.Text + ",ExpenseInd='" + lblIndicator.Text + "',TaxStatus='" +
                                     ((chkTaxable.Checked) ? "Y" : "N") + "',ChangeID='" + Session["UserName"].ToString() + "',ChangeDt='" +
                                     DateTime.Now.ToShortDateString() + "',ExpenseDesc='"+lblDescription.Text+"'";
                    expenseEntry.UpdateSOExpense(columnValue, hidExpenseID.Value);
                    lblMessage.Text = utility.UpdateMessage;
                }
                expenseEntry.ReExtendOrderHeader(soNumber);
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

                lblIndicator.Text = dtExpenseCodeDetail.Rows[0]["Indicator"].ToString();
                txtPercent.Text = (lblIndicator.Text.Trim() == "P") ? String.Format("{0:###0.00}", dtExpenseCodeDetail.Rows[0]["Percent"]) : "0.00";
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
    protected void ibtnExband_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton imgcommon = sender as ImageButton;
        string whereClause = string.Empty;

        if (imgcommon.ImageUrl == "~/Common/Images/expand.gif")
        {
            // Code to hide the delete falg columns
            //dgNewQuote.Columns[dgNewQuote.Columns.Count - 4].Visible = tdDelete.Visible = true;
            //GetQuotes(whereClause);
            hidShowActiveLine.Value = "false";
            imgcommon.ImageUrl = "~/Common/Images/expt.gif";
            imgcommon.ToolTip = "Clike here to Show Item";
        }
        else
        {
            //whereClause = " a.DeleteDt is null and a.f" + HeaderIDColumn.Remove(0, 1).Trim() + "=" + CustDet.SOOrderID + " Order by a.LineNumber desc";
            hidShowActiveLine.Value = "true";
            // Code to hide the delete falg columns
            //dgNewQuote.Columns[dgNewQuote.Columns.Count - 4].Visible = tdDelete.Visible = false;
            //GetQuotes(whereClause);

            imgcommon.ImageUrl = "~/Common/Images/expand.gif";
            imgcommon.ToolTip = "Clike here to Show Deleted Item";
        }

        BindDataGrid();
        upExpenseGrid.Update();
        //pnlQuoteDetail.Update();
    }
    #endregion
    
}
