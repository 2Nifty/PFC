/** 
 * Project Name: SOE
 * 
 * Module Name: Pending ECommerce Quotes
 * 
 * Author: Slater
 *
 * Abstract: Page used to find Pending ECommerce Quotes in SOE system...
 *
 * Revision History:
 * 
 *  DATE				VERSION			AUTHOR				ACTION
 * <-------------------------------------------------------------------------->			
 *	08 Sep 11			Ver-1			Slater		        Created
 **/

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
using PFC.SOE.Enums;
using System.Data.SqlClient;
using PFC.SOE.DataAccessLayer;


public partial class PendingECommQuotes : System.Web.UI.Page
{

    #region Variable Declaration

    CustomerDetail customerDetail = new CustomerDetail();
    ECommQuotes ecommQuotes = new ECommQuotes();
    Common common = new Common();
    Utility utility = new Utility();
    OrderEntry orderEntry = new OrderEntry();
    string invalidMessage = "Invalid Customer Number";
    string noRecordMessage = "No Records Found";
    string successMessage = "Query completed successfully";
    LinkButton CustLink;
    GridViewRow row;
    DataView dv = new DataView();
    int LinesPerPage = 15;
    DropDownList ddlPages = new DropDownList();
    TextBox txtGotoPage = new TextBox();
    Label lblCurrentPage = new Label();
    Label lblTotalPage = new Label();
    Label lblCurrentPageRecCount = new Label();
    Label lblCurrentTotalRec = new Label();
    Label lblTotalNoOfRec = new Label();

    #endregion

    #region Page events

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            lblMessage.Text = "";
            ddlPages = (DropDownList)GPager.FindControl("ddlPages");
            txtGotoPage = (TextBox)GPager.FindControl("txtGotoPage");
            lblCurrentPage = (Label)GPager.FindControl("lblCurrentPage");
            lblTotalPage = (Label)GPager.FindControl("lblTotalPage");
            lblCurrentPageRecCount = (Label)GPager.FindControl("lblCurrentPageRecCount");
            lblCurrentTotalRec = (Label)GPager.FindControl("lblCurrentTotalRec");
            lblTotalNoOfRec = (Label)GPager.FindControl("lblTotalNoOfRec");
            Ajax.Utility.RegisterTypeForAjax(typeof(PendingECommQuotes));
            if (!IsPostBack)
            {
                ViewState["Action"] = "New";
                ViewState["Mode"] = "Active"; // Display grid without deleted orders
                dtpEndDt.SelectedDate = DateTime.Now.ToShortDateString();
                DateTime StartDate = DateTime.Now.AddDays(-1);
                if (StartDate.DayOfWeek == DayOfWeek.Sunday)
                {
                    StartDate = StartDate.AddDays(-2);
                }
                dtpStartDt.SelectedDate = StartDate.ToShortDateString();
                BindLocations();
                BindOrderType();
                GPager.Visible = false;
                if (Request.QueryString["UserName"] != null && Request.QueryString["UserName"].ToString().Length > 0)
                {
                    Session["UserName"] = Request.QueryString["UserName"].ToString();
                    //utility.HighlightDropdownValue(ddlLocation, common.GetUserLoc(Session["UserName"].ToString()));
                    utility.HighlightDropdownValue(ddlInsideRep, Request.QueryString["UserName"].ToString());
                    BindDataGrid();
                }
                else
                {
                    txtCustomerNumber.Focus();
                }
            }
        }
        catch (Exception ex)
        {
            utility.DisplayMessage(MessageType.Failure, ex.ToString(), lblMessage);
            pnlStatusMessage.Update();
        }
    }

    protected void gvPendingOrders_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Edits")
        {
            string SoHeaderID = e.CommandArgument.ToString();
            ScriptManager.RegisterClientScriptBlock(gvPendingOrders, gvPendingOrders.GetType(), "fillParent", "BindOrderEntryForm('" + SoHeaderID + "');", true);
        }
    }

    protected void DetailRowBound(Object sender, GridViewRowEventArgs e)
    {
        try
        {
            //// allow price editing if Order Source <> IX
            row = e.Row;
            if (row.RowType == DataControlRowType.DataRow)
            {
                // line formatting
                CustLink = (LinkButton)row.Cells[3].Controls[1];
                string LinkCommand = "";
                LinkCommand = "return ShowECommRecall('";
                LinkCommand += Server.HtmlDecode(CustLink.Text) + "');";
                CustLink.OnClientClick = LinkCommand;
            }
        }
        catch (Exception e2)
        {
            utility.DisplayMessage(MessageType.Failure, "FillGrid Error " + e2.ToString(), lblMessage);
            pnlStatusMessage.Update();
        }
    }

    protected void gvPendingOrders_Sorting(object sender, GridViewSortEventArgs e)
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

    protected void txtCustomerNumber_TextChanged(object sender, EventArgs e)
    {
        if (txtCustomerNumber.Text.Trim() != "")
        {
            string strCustNo = txtCustomerNumber.Text;
            int strCnt = 0;
            bool textIsNumeric = true;
            try
            {
                int.Parse(strCustNo);
            }
            catch
            {
                textIsNumeric = false;
            }
            if ((strCustNo != "") && !textIsNumeric)
            {
                if (isNumeric(strCustNo.Remove(strCustNo.Length - 1, 1), System.Globalization.NumberStyles.Integer) == false)
                    strCnt = Convert.ToInt32(cntCustName(strCustNo));
                else
                    strCnt = Convert.ToInt32(cntCustNo(strCustNo));
                int maxRowCount = customerDetail.GetSQLWarningRowCount();

                if (strCnt < maxRowCount)
                    ScriptManager.RegisterClientScriptBlock(txtCustomerNumber, txtCustomerNumber.GetType(), "Customer", "LoadCustomerLookup('" + PFC.SOE.Securitylayer.Cryptor.Encrypt(strCustNo) + "');", true);
                else
                    ScriptManager.RegisterClientScriptBlock(txtCustomerNumber, txtCustomerNumber.GetType(), "Customer", "alert('Maximum row exceeds for this search.please enter additional data.');", true);
            }
            else
            {
                if (!customerDetail.IsValidCustomer(txtCustomerNumber.Text))
                {
                    utility.DisplayMessage(MessageType.Failure, invalidMessage, lblMessage);
                    hidCustNo.Value = "";
                    txtCustomerNumber.Text = "";
                }
                else
                {
                    hidCustNo.Value = customerDetail.CustomerNumber;
                }
            }

            pnlStatusMessage.Update();
            pnlPendingQuoteEntry.Update();
        }
        else
        {
            utility.DisplayMessage(MessageType.Failure, "", lblMessage);
            hidCustNo.Value = "";
        }
        ScriptManager.RegisterClientScriptBlock(txtCustomerNumber, txtCustomerNumber.GetType(), "tab", "document.getElementById(\"ddlOrderType\").focus();", true);
    }

    protected void ibtnSearch_Click(object sender, ImageClickEventArgs e)
    {
        ViewState["Mode"] = "Active";
        hidSort.Value = ""; // initialize sort value to empty

        if (hidCustNo.Value == "")
            if (dtpStartDt.SelectedDate != "" && dtpEndDt.SelectedDate != "")
            {
                if (DateTime.Compare(Convert.ToDateTime(dtpEndDt.SelectedDate), Convert.ToDateTime(dtpStartDt.SelectedDate)) == -1)
                {
                    utility.DisplayMessage(MessageType.Failure, "Invalid Date Range", lblMessage);
                    pnlStatusMessage.Update();
                    return;
                }
            }
        BindDataGrid();

    }

    protected void ibtnCancel_Click(object sender, ImageClickEventArgs e)
    {
        ClearForm();
    }

    protected void ibtnDeletedItem_Click1(object sender, ImageClickEventArgs e)
    {
        ViewState["Mode"] = "ShowAll"; // Display Grid with deleted orders
        BindDataGrid();
    }

    #endregion

    #region Developer Method

    private void BindDataGrid()
    {
        if (DateTime.Parse(dtpStartDt.SelectedDate.ToString()).AddDays(14) < DateTime.Parse(dtpEndDt.SelectedDate.ToString()))
        {
            dtpStartDt.SelectedDate = DateTime.Parse(dtpEndDt.SelectedDate.ToString()).AddDays(-14).ToShortDateString();
        }
        if ((ddlInsideRep.SelectedIndex != 0) && (ddlInsideRep.SelectedValue.ToString() != "ALL"))
        {
            ecommQuotes.UpdateRep(ddlInsideRep.SelectedValue.ToString());
        }
        DataTable dtPendingOrders = ecommQuotes.ExecutePendingQuotes(
            txtCustomerNumber.Text.ToString()
            , (ddlLocation.SelectedIndex != 0 ? ddlLocation.SelectedItem.Value : "")
            , (ddlInsideRep.SelectedIndex != 0 ? ddlInsideRep.SelectedItem.Value : "")
            , (ddlOrderType.SelectedIndex != 0 ? ddlOrderType.SelectedValue : "")
            , dtpStartDt.SelectedDate.ToString()
            , dtpEndDt.SelectedDate.ToString()
            ).Tables[0];

        if (dtPendingOrders.Rows.Count == 0) // if datatable is empty add new row for display purpose
        {
            DataRow dr = dtPendingOrders.NewRow();
            dtPendingOrders.Rows.Add(dr);

            if (Page.IsPostBack && ViewState["Action"] != "Clear")
            {
                utility.DisplayMessage(MessageType.Failure, noRecordMessage, lblMessage);
                pnlStatusMessage.Update();
                GPager.Visible = false;
                PagerUpdatePanel.Update();
            }
        }
        else
        {
            utility.DisplayMessage(MessageType.Success, successMessage, lblMessage);
            pnlStatusMessage.Update();
            gvPendingOrders.DataSource = dtPendingOrders;            
            GPager.InitPager(gvPendingOrders, LinesPerPage);
            GPager.Visible = true;
            PagerUpdatePanel.Update();
            pnlPendingQuotesGrid.Update();
        }

        dtPendingOrders.DefaultView.Sort = (hidSort.Value == "") ? "CustNo asc" : hidSort.Value;        
        Session["PendingECommData"] = dtPendingOrders;
        
    }

    private void BindLocations()
    {
        utility.BindListControls(ddlLocation, "LocName", "LocID", ecommQuotes.GetBranch(), "ALL");
        if (!common.IsAdminUser(Session["UserName"].ToString()))
            ddlLocation.Enabled = false;

        //if (common.GetShowAllUser(Session["UserName"].ToString()) == "Y")        
        //    utility.BindListControls(ddlUserID, "Name", "Code", common.GetUserList(),"ALL");                    
        //else
        //    utility.BindListControls(ddlUserID, "Name", "Code", common.GetUserList());
        //utility.HighlightDropdownValue(ddlUserID, Session["UserName"].ToString());
        
        //string branchID = (ddlBranch.SelectedIndex == 0 ? "ALL" : ddlBranch.SelectedValue);
        string branchID = "ALL";
        utility.BindListControls(ddlInsideRep, "RepName", "UserID", ecommQuotes.GetSalesPerson(branchID), "ALL");
        utility.HighlightDropdownValue(ddlInsideRep, Session["UserName"].ToString());
    }

    private void BindOrderType()
    {
        utility.BindListControls(ddlOrderType, "ListDesc", "ListValue", FillDropDownFromListMaster(), "ALL");
    }

    //public void Rep_Changed(Object sender, EventArgs e)
    //{
    //    //utility.DisplayMessage(MessageType.Failure, common.GetUserLoc(ddlInsideRep.SelectedValue.ToString()), lblMessage);
    //    //pnlStatusMessage.Update();
    //    ddlLocation.SelectedValue = common.GetUserLoc(ddlInsideRep.SelectedValue.ToString());
    //    pnlPendingQuoteEntry.Update();
    //}
    
    public DataTable FillDropDownFromListMaster()
    {
        try
        {
            string _tableName = "ListMaster LM ,ListDetail LD";
            string _columnName = "(LD.ListValue+' - '+LD.ListdtlDesc) as ListDesc,LD.ListValue ";
            string _whereClause = "LM.ListName = 'eComOrderType' And LD.fListMasterID = LM.pListMasterID order by ListValue";
            DataSet dsResult = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            return dsResult.Tables[0];

        }
        catch (Exception ex)
        {
            return null;
        }
    }

    private void ClearForm()
    {
        ViewState["Action"] = "Clear";
        txtCustomerNumber.Text = "";
        ddlOrderType.SelectedIndex = 0;
        dtpStartDt.SelectedDate = DateTime.Today.AddDays(-7).ToString("M/d/yyyy");
        dtpEndDt.SelectedDate = DateTime.Today.ToString("M/d/yyyy"); ;
        BindLocations();
        pnlPendingQuoteEntry.Update();
        BindDataGrid();
        pnlPendingQuotesGrid.Update();

    }

    private void ExportPendingOrder(string exportMode)
    {
        pnlStatusMessage.Update();
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "ExportPendingOrdersAndQuotes('" + exportMode + "');", true);
    }

    public string cntCustName(string custNo)
    {
        DataTable dtCustomer = new DataTable();
        string tableName = "CustomerMaster";
        string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
        string whereClause = " CustName Like '" + custNo.Trim().Replace("%", "") + "%'";
        DataSet dsCustomer = orderEntry.ExecuteERPSelectQuery(tableName, columnName, whereClause);

        if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
        {
            dtCustomer = dsCustomer.Tables[0];
            return dtCustomer.Rows[0]["totalcount"].ToString();
        }
        else
            return "0";
    }

    public string cntCustNo(string custNo)
    {
        DataTable dtCustomer = new DataTable();
        string tableName = "CustomerMaster";
        string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
        string whereClause = "[CustNo] Like '" + custNo.Trim().Replace("%", "") + "%'";
        DataSet dsCustomer = orderEntry.ExecuteERPSelectQuery(tableName, columnName, whereClause);

        if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count > 0)
        {
            dtCustomer = dsCustomer.Tables[0];
            return dtCustomer.Rows[0]["totalcount"].ToString();
        }
        else
            return "0";
    }
    
    public bool isNumeric(string val, System.Globalization.NumberStyles NumberStyle)
    {
        Double result;
        return Double.TryParse(val, NumberStyle,
            System.Globalization.CultureInfo.CurrentCulture, out result);
    }
    #endregion

    #region Pager Functionality

    protected void ddlPages_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            gvPendingOrders.PageIndex = GPager.GotoPageNumber;
            //BindPageDetails();
            BindDataGrid();            
        }
        catch (Exception ex)
        {
            utility.DisplayMessage(MessageType.Failure, ex.ToString(), lblMessage);
            pnlStatusMessage.Update();
        }
  }

    //public void RePage(DataTable GridData)
    //{
    //    DataTable dtPage = new DataTable();
    //    dtPage.Columns.Add("Id");
    //    dtPage.Columns.Add("PageNo");
    //    int PageNo = 1;
    //    for (int i = 0; i < GridData.Rows.Count; i++)
    //    {
    //        if (i % LinesPerPage == 0)
    //        {
    //            DataRow PagerRow = dtPage.NewRow();
    //            PagerRow["Id"] = (i + 1).ToString();
    //            PagerRow["PageNo"] = PageNo.ToString();
    //            dtPage.Rows.Add(PagerRow);
    //            PageNo++;
    //        }
    //        GridData.Rows[i]["PageNo"] = (PageNo - 1).ToString();
    //    }
    //    GridData.AcceptChanges();
    //    ddlPages.DataSource = dtPage;
    //    ddlPages.DataTextField = "PageNo";
    //    ddlPages.DataValueField = "Id";
    //    ddlPages.DataBind();
    //    ddlPages.SelectedIndex = 0;
    //}

    //public void BindPageDetails()
    //{
    //    try
    //    {
    //        lblCurrentPage.Text = " " + (ddlPages.SelectedIndex + 1).ToString();
    //        lblTotalPage.Text = " " + ddlPages.Items.Count.ToString();
    //        // see if page has been filtered
    //        dv = new DataView((DataTable)Session["PendingECommData"], "PageNo = " + (ddlPages.SelectedIndex + 1).ToString(),
    //            hidSort.Value, DataViewRowState.CurrentRows);
    //        gvPendingOrders.DataSource = dv;
    //        gvPendingOrders.DataBind();
    //        lblCurrentPageRecCount.Text = " " + ((ddlPages.SelectedIndex * LinesPerPage) + 1).ToString();
    //        lblCurrentTotalRec.Text = " " + (dv.Count < LinesPerPage ? ((DataTable)Session["PendingECommData"]).Rows.Count : (ddlPages.SelectedIndex + 1) * LinesPerPage).ToString();
    //        lblTotalNoOfRec.Text = " " + ((DataTable)Session["PendingECommData"]).Rows.Count.ToString();
    //        pnlPendingQuotesGrid.Update();
    //        PagerUpdatePanel.Update();
    //        utility.DisplayMessage(MessageType.Failure, "PageNo = " + (ddlPages.SelectedIndex + 1).ToString(), lblMessage);
    //        pnlStatusMessage.Update();
    //    }
    //    catch (Exception e3)
    //    {
    //        utility.DisplayMessage(MessageType.Failure, "BindPageDetails Error " + e3.ToString(), lblMessage);
    //    }
    //}
    #endregion

}
