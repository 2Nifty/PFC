/********************************************************************************************
 * File	Name			:	WOExpense.aspx.cs
 * File Type			:	C#
 * Project Name			:	Work Order Entry
 * Module Description	:	Enter Expense for work orders
 * Created By			:	Tom Slater
 * Created Date			:	10/27/2008	
 * History*				: 
 * DATE					AUTHOR			                ACTION
 * ****					******				            ******
 * 01/14/2011           Tom Slater                      Created

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
using PFC.WOE.BusinessLogicLayer;
using PFC.WOE.DataAccessLayer;
#endregion

public partial class WOExpenses : System.Web.UI.Page
{
    #region Class Variable
    WOExpense expenseEntry = new WOExpense();
    DataUtility utility = new DataUtility(); 
    #endregion

    #region Variable Declaration

    string woNumber = "";
    string invalidMessage = "Select Valid Expense Code";
    string noWoMessage = "Work Order is not on file or deleted";
    string deleteMessage = "Data had been successfully deleted";
    string updateMessage = "Data has been successfully updated";
    string addMessage = "Data has been successfully added";
    ImageClickEventArgs ge;
    #endregion

    #region Page Load Event
    /// <summary>
    /// Page Load Event Handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    { 
        woNumber = Request.QueryString["WONumber"].ToString();
           
        if (!IsPostBack)
        {
            //Bind Expense Code dropdown
            Session["WOOrderNo"] = null;
            BindExpenseCode();
            if (woNumber.Trim().Length > 0)
            {
                txtWONo.Text = woNumber;
                ibtnFind_Click(ibtnFind, ge);
            }

            PrintDialogue1.PageUrl = Server.UrlEncode("ExpenseEntryExport.aspx?PONumber=" + Session["POHeaderID"].ToString());
            PrintDialogue1.PageTitle = "Enter Expenses for " + woNumber;
        }
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
    /// Clear user enter values in entry area
    /// </summary>
    private void ClearEntryControl()
    {
        ddlCode.SelectedIndex = 0;
        lblDescription.Text = "";
        //lblPieceCost.Text = "";
        //lblPoundCost.Text = "";
        txtAmount.Text = "0.00";        
        //chkTaxable.Checked = false;
        //lblIndicator.Text = "";
    }

    private void BindExpenseGrid()
    {
        DataTable dtExpenseLines= new DataTable();
        DataSet dsWO = expenseEntry.FindWO(txtWONo.Text.ToString());
        if (dsWO != null && dsWO.Tables[2] != null)
        {
            dtExpenseLines = dsWO.Tables[2];

            if (hidSort.Value != "")
            {
                dtExpenseLines.DefaultView.Sort = hidSort.Value;
            }
            //Load the grid
            gvExpense.DataSource = dtExpenseLines.DefaultView;
            gvExpense.DataBind();
            upExpenseGrid.Update();
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

        BindExpenseGrid();
    }
    /// <summary>
    /// Find the WO and possibly the Expense PO
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ibtnFind_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            DataSet dsWO = expenseEntry.FindWO(txtWONo.Text.ToString());
            if (dsWO.Tables[0].Rows.Count > 0)
            {
                DataTable dtWO = dsWO.Tables[0];
                lblWONumber.Text = dtWO.Rows[0]["POOrderNo"].ToString().Trim();
                lblMfgName.Text = dtWO.Rows[0]["OrderContactName"].ToString().Trim();
                lblMfgAddress.Text = dtWO.Rows[0]["BuyFromAddress"].ToString().Trim();
                lblMfgAddress2.Text = dtWO.Rows[0]["BuyFromAddress2"].ToString();
                lblMfgCity.Text = dtWO.Rows[0]["BuyFromCity"].ToString().Trim();
                lblMfgState.Text = dtWO.Rows[0]["BuyFromState"].ToString().Trim();
                lblMfgPhone.Text = dtWO.Rows[0]["OrderContactPhoneNo"].ToString().Trim();
                lblMfgPincode.Text = dtWO.Rows[0]["BuyFromZip"].ToString().Trim();
                lblMfgComma.Visible = ((lblMfgCity.Text.Trim() != "" && lblMfgState.Text.Trim() != "") ? true : false);
                lblMfgCountry.Text = dtWO.Rows[0]["BuyFromCountry"].ToString().Trim();

                lblPckName.Text = dtWO.Rows[0]["ShipToName"].ToString().Trim();
                lblPckAddress.Text = dtWO.Rows[0]["ShipToAddress"].ToString().Trim();
                lblPckAddress2.Text = dtWO.Rows[0]["ShipToAddress2"].ToString().Trim();
                lblPckCity.Text = dtWO.Rows[0]["ShipToCity"].ToString().Trim();
                lblPckState.Text = dtWO.Rows[0]["ShipToState"].ToString().Trim();
                lblPckPhone.Text = dtWO.Rows[0]["ShipToPhoneNo"].ToString().Trim();
                lblPckPincode.Text = dtWO.Rows[0]["ShipToZip"].ToString().Trim();
                lblPckComma.Visible = ((lblPckCity.Text.Trim() != "" && lblPckState.Text.Trim() != "") ? true : false);
                lblPckCountry.Text = dtWO.Rows[0]["ShipToCountry"].ToString().Trim();

                lblMfgCode.Text = dtWO.Rows[0]["BuyFromVendorNo"].ToString();
                upHeader.Update();
                Session["POHeaderID"] = dtWO.Rows[0]["pPOHeaderID"].ToString();
                // Finished good data
                dtWO = dsWO.Tables[1];
                lblItemNo.Text = dtWO.Rows[0]["ItemNo"].ToString().Trim();
                lblItemDesc.Text = dtWO.Rows[0]["ItemDesc"].ToString().Trim();
                lblQty.Text = String.Format("{0:###0.00}", dtWO.Rows[0]["QtyOrdered"]);
                lblTotPcs.Text = dtWO.Rows[0]["OrderPieces"].ToString().Trim();
                lblPieceCost.Text = "";
                lblTotWght.Text = dtWO.Rows[0]["OrderWeight"].ToString().Trim();
                lblPoundCost.Text = "";

                //Load the grid
                gvExpense.DataSource = dsWO.Tables[2];
                gvExpense.DataBind();
                upExpenseGrid.Update();

                // check fo the PO
                if (txtExpPONo.Text.ToString().Trim().Length > 0)
                {
                    DataSet dsPO = expenseEntry.FindPO(txtExpPONo.Text.ToString());
                    if (dsPO.Tables[0].Rows.Count > 0)
                    {
                        DataTable dtPO = dsPO.Tables[0];
                        txtAmount.Text = String.Format("{0:###0.00}", dtPO.Rows[0]["TotalCost"]);
                        txtVendorNo.Text = dtPO.Rows[0]["BuyFromVendorNo"].ToString().Trim();
                        txtVendorRef.Text = dtPO.Rows[0]["VendorAlphaCd"].ToString().Trim();
                        upExpenseEntry.Update();
                        UpdateAmount();
                    }
                }

            }
            else
            {
                lblMessage.Text = noWoMessage;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
            upProgress.Update();

        }
        catch (Exception ex)
        {
            lblMessage.Text = ex.ToString();
            lblMessage.ForeColor = System.Drawing.Color.Red;
            upProgress.Update();

            //throw;
        }
    }

    /// <summary>
    /// Save the user input
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
    {
        lblMessage.Text = "";
        try
        {
            string ExpType = "Q";
            decimal UnitCost = 0;
            if (ddlCode.SelectedIndex > 0)
            {
                if (UpdateAmount())
                {
                    if (radSpreadWeight.Checked)
                    {
                        ExpType = "W";
                        UnitCost = decimal.Parse(lblPoundCost.Text);
                    }
                    else
                    {
                        UnitCost = decimal.Parse(lblPieceCost.Text);
                    }
                    Session["WOOrderNo"] = txtWONo.Text.ToString();

                    if (hidWoCompId.Value == "")
                    {
                        expenseEntry.AddFormData(ddlCode.SelectedValue.ToString(), lblDescription.Text, ExpType, UnitCost,
                            decimal.Parse(txtAmount.Text), Session["UserName"].ToString(), Session["POHeaderID"].ToString());

                        utility.UpdateTableData(Session["POHeaderTableName"].ToString(), "POExpenseInd='Y'", Session["POHeaderColumnName"].ToString() + "='" + Session["POHeaderID"].ToString() + "'");
                    }
                    else
                    {
                        expenseEntry.UpdateFormData(hidWoCompId.Value, ddlCode.SelectedValue.ToString(), lblDescription.Text, ExpType, UnitCost,
                            decimal.Parse(txtAmount.Text), Session["UserName"].ToString(), Session["POHeaderID"].ToString());
                        
                        // Used to clear edit mode
                        hidWoCompId.Value = "";
                        pnlContextMenu.Update();
                    }

                    ClearEntryControl();
                    upExpenseEntry.Update();
                    DataSet dsWO = expenseEntry.FindWO(txtWONo.Text.ToString());
                    //Load the grid
                    gvExpense.DataSource = dsWO.Tables[2];
                    gvExpense.DataBind();
                    upExpenseGrid.Update();
                }
                else
                {
                    lblMessage.ForeColor = System.Drawing.Color.Red;
                }
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
            lblMessage.Text = ex.ToString();
            lblMessage.ForeColor = System.Drawing.Color.Red;
            upProgress.Update();
        }
    }

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
            }
        }
        else
            ClearEntryControl();
        upExpenseEntry.Update();
    }

    /// <summary>
    /// Calculate Percent  while changing Amount 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void txtAmount_TextChanged(object sender, EventArgs e)
    {
        UpdateAmount();
    }

    protected bool UpdateAmount()
    {
        decimal Amount;
        if (decimal.TryParse(txtAmount.Text, out Amount))
        {
            decimal PcQty = decimal.Parse(lblTotPcs.Text);
            decimal Weight = decimal.Parse(lblTotWght.Text);
            if (PcQty != 0)
            {
                lblPieceCost.Text = String.Format("{0:###0.00000}", Amount / PcQty);
                lblPoundCost.Text = String.Format("{0:###0.00000}", Amount / Weight);
                upOrderEntry.Update();
                return true;
            }
            else
            {
                lblMessage.Text = "Charge cannot be saved until Qty to Manufacture is greater than 0";
                return false;
            }
        }
        else
        {
            lblMessage.Text = "Enter a valid expense amount";
            return false;
        }
    }

    protected void gvExpense_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            HiddenField _hidpWoCompId = e.Row.FindControl("hidpWoCompId") as HiddenField;
            HiddenField _hidDeleteDt = e.Row.FindControl("hidDeleteDt") as HiddenField;
            Label _lblPFCItemNo = e.Row.FindControl("lblPFCItemNo") as Label;
            
            if(_hidDeleteDt.Value == "")
                _lblPFCItemNo.Attributes.Add("onmousedown", "if(document.getElementById('hidRowID').value != '')document.getElementById(document.getElementById('hidRowID').value).style.fontWeight='normal';DeleteExpenseLine('" + _hidpWoCompId.Value.Trim() + "',this.id,event); document.getElementById('" + e.Row.ClientID + "').style.fontWeight='bold';hidRowID.value='" + e.Row.ClientID + "'");
            
        }
    }

    protected void btnDelete_Click(object sender, EventArgs e)
    {
        expenseEntry.DeleteExpenseLine(hidWoCompId.Value, Session["POHeaderID"].ToString());
        BindExpenseGrid();
    }

    protected void btnEdit_Click(object sender, EventArgs e)
    {
        //expenseEntry.DeleteExpenseLine(hidDeleteWoCompId.Value, Session["POHeaderID"].ToString());
        //BindExpenseGrid();

        DataSet dsExpLine = expenseEntry.GetExpenseLineData(hidWoCompId.Value);
        if (dsExpLine != null && dsExpLine.Tables[0].Rows.Count > 0)
        {
            
            DataRow drExp = dsExpLine.Tables[0].Rows[0];
            if (drExp["DeleteDt"].ToString() == "")
            {
                utility.SetListControlValue(ddlCode, drExp["ItemNo"].ToString());
                lblDescription.Text = drExp["ItemDesc"].ToString();
                txtAmount.Text = String.Format("{0:###0.00}", drExp["ExtendedCost"]);
                if (drExp["BillType"].ToString().Trim() == "W")
                {
                    radSpreadWeight.Checked = true;
                    lblPoundCost.Text = drExp["UnitCost"].ToString();
                }
                else
                {
                    radSpreadPiece.Checked = true;
                    radSpreadWeight.Checked = false;
                    lblPieceCost.Text = drExp["UnitCost"].ToString();
                }
            }
            else
            {
                lblMessage.Text = "Invalid operation. Line already deleted.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                upProgress.Update();
            }

            upExpenseEntry.Update();
        }


    }


    protected void btnClose_Click(object sender, ImageClickEventArgs e)
    {
        Session["WOOrderNo"] = txtWONo.Text;
        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "closeform", "CloseForm();", true);
    }
    #endregion

    
}
