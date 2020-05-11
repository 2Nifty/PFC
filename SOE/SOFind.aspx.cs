/** 
 * Project Name: SOE
 * 
 * Module Name: SO Find
 * 
 * Author: Sathya 
 *
 * Abstract: Page used to find orders/invoices in SOE system...
 *
 * Revision History:
 * 
 *  DATE				VERSION			AUTHOR						   ACTION
 * <-------------------------------------------------------------------------->			
 *	16 Nov '08			Ver-1			Sathya		                   Created
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
using System.IO;

public partial class SOFind : System.Web.UI.Page
{
 
    #region Variable Declaration
    SOEFind sOEFind = new SOEFind();
    OrderEntry orderEntry = new OrderEntry();
    Utility utility = new Utility();
    CustomerDetail custDet = new CustomerDetail();
    Common common = new Common();

    private bool isSort = false;
    private string whereClause = "";
    string deleteCondition = " and (deletedt is null or deletedt ='')";
    string invalidCustomer = "Invalid Customer Number/Name";
    string SOHEADERTABLE = "SOHeaderRel";
    DataTable dtSoFind;

    #endregion

    #region Page Load Event
    /// <summary>
    /// Page Load Event Handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(SOFind));
        lblMessage.Text = "";
        if (!IsPostBack)
        {
            //ShipLoc,SoNo,InventoryNo,PORef,Amount,Weight,Type,ShipDate,OrderDate,CustReq,Status,Carrier,CustomerNo
            ViewState["MaxRowCount"] = custDet.GetSQLWarningRowCount();
            BindDropDown();
            BindDataGrid();
            dtpStatusStart.SelectedDate = DateTime.Now.AddDays(-7).ToShortDateString();
            dtpStatusEnd.SelectedDate = DateTime.Now.ToShortDateString();           

        }
        PrintDialogue1.CustomerNo = txtCustomerNumber.Text;
        ExportSoFind(); // Set Print URL to User control
        PrintDialogue1.PageTitle = "SO Find for Customer #" + txtCustomerNumber.Text;
         
    }
    #endregion

    #region Developer Code
    /// <summary>
    /// To Fill list controls
    /// </summary>
    private void BindDropDown()
    {
       
        utility.BindListControls(ddlHeaderType, "ListDesc", "ListValue", sOEFind.GetSOFindSearch("SOFindSearch"), "-- Select --");
        utility.BindListControls(ddlSearchType, "ListDesc", "ListValue", sOEFind.GetSOSearch("SOFindOrderStat"), "ALL");

        utility.BindListControls(ddlUserId, "Name", "Code", sOEFind.GetUser(), "ALL");
        utility.HighlightDropdownValue(ddlUserId, Session["UserName"].ToString());
        utility.BindListControls(ddlOrderType, "Name", "Code", sOEFind.GetSOFindOrderTypes(), "ALL");
        utility.BindListControls(ddlSalesLocation, "Name", "Code", sOEFind.GetShiplocation(), "ALL");

        DataTable dt = sOEFind.GetSOFindSearch("SOFindSearch");
        dt.Merge(sOEFind.GetSOFindSearch("SOFindOrderStat"));
    } 
    /// <summary>
    /// Bind Result of search criteria
    /// </summary>
    private void BindDataGrid()
    {
        whereClause = (isSort && ViewState["whereClause"] != null) ? ViewState["whereClause"].ToString() : whereClause;
        if (whereClause=="")
            whereClause = "SellToCustNo=''";

        if (ddlHeaderType.SelectedValue.Trim().ToLower() == "in" || ddlSearchType.SelectedItem.Value.Trim() == "I")
            SOHEADERTABLE = "SOHeaderHist";

        DataTable dsSoFind = sOEFind.GetSalesOrder(whereClause,SOHEADERTABLE);
        ViewState["dtSOFind"] = dsSoFind;
        if (dsSoFind != null)
        {
            dtSoFind = dsSoFind;
            if (dtSoFind.Rows.Count == 0)
            {
                DataRow dr = dtSoFind.NewRow();
                dtSoFind.Rows.Add(dr);
            }
            int allowedRowCount =  Convert.ToInt32( ViewState["MaxRowCount"].ToString());
            if (dtSoFind.Rows.Count < allowedRowCount)
            {
                ViewState["whereClause"] = whereClause;
                dtSoFind.DefaultView.Sort = (hidSort.Value == "") ? "SoNo asc" : hidSort.Value;
                gvFind.DataSource = dtSoFind.DefaultView.ToTable();
                //gvFind.DataBind();
                GridPager.InitPager(gvFind, 20);
                ExportSoFind();
            }
            else
            {
                gvFind.DataSource = null;
                gvFind.DataBind();
                utility.DisplayMessage(PFC.SOE.Enums.MessageType.Failure, "Maximum row exceeds for this search.please enter additional data.", lblMessage);
                //ScriptManager.RegisterClientScriptBlock(ibtnOrderSearch, ibtnOrderSearch.GetType(), "search", "alert('');", true);
            }

            gvFind.Visible = true;
            upSOGrid.Update();
        }
        if(dsSoFind == null || dsSoFind.Rows.Count == 0)
        {
            gvFind.DataSource = null; ;
            gvFind.DataBind();
            utility.DisplayMessage(PFC.SOE.Enums.MessageType.Success, "No record found", lblMessage);
            upSOGrid.Update();
            upMessage.Update();
        }
        upSOGrid.Update();
        upSOSearch.Update();
        upMessage.Update();
    }
    /// <summary>
    /// Clear All Control
    /// </summary>
    private void ClearControl()
    {
        
        ViewState["whereClause"] = null;
        ViewState["CustomerNumber"] = null;
        dtpStatusStart.SelectedDate = DateTime.Now.AddDays(-7).ToShortDateString();
        dtpStatusEnd.SelectedDate = DateTime.Now.ToShortDateString();
        txtCustomerNumber.Text = "";
        ddlHeaderType.SelectedIndex = 0;
        ddlSearchType.SelectedIndex = 0;
        lblContractNumber.Text = "";
        lblPriceCode.Text = "";
        lblSalesRepName.Text = "";
        lblSalesRepNumber.Text = "";
        
        whereClause = "";
        BindDataGrid();
        upSOGrid.Update();
        upSOSearch.Update();
        dtpStatusStart.SelectedDate = DateTime.Now.AddDays(-7).ToShortDateString();
        dtpStatusEnd.SelectedDate = DateTime.Now.ToShortDateString();

    }
    /// <summary>
    /// Export Page
    /// </summary>
    /// <param name="exportMode"></param>
    private void ExportSoFind()
    {
        whereClause = (ViewState["whereClause"] != null) ? ViewState["whereClause"].ToString() : whereClause;
        hidSort.Value = (hidSort.Value == "") ? "SoNo asc" : hidSort.Value;
        string headerType = (ddlHeaderType.SelectedIndex == 0) ? "N/A" : ddlHeaderType.SelectedItem.Text;
        string headerSo = (ddlHeaderType.SelectedIndex == 0) ? "N/A" : txtSOInvoiceNo.Text;
        string description = (ddlSearchType.SelectedIndex == 0) ? "-" : ddlHeaderType.SelectedItem.Text;
        string descDate = (ddlSearchType.SelectedIndex == 0) ? "N/A" : dtpStatusStart.SelectedDate + " - " + dtpStatusEnd.SelectedDate;        
                        
        if (ViewState["CustomerNumber"] != null && txtCustomerNumber.Text.Trim() != "")
        {
            string queryString = "CustomerNumber=" + ViewState["CustomerNumber"].ToString() + "&Sort=" + hidSort.Value + "&WhereClause=" + whereClause.Replace("'","`") +
                                 "&HeaderType=" + headerType + "&OrderNumber=" + headerSo + "&Description=" + description +
                                 "&DescDate=" + descDate + "&TableName=" + SOHEADERTABLE;
            PrintDialogue1.PageUrl = Server.UrlEncode("SOFindExport.aspx?" + queryString);

           // ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "ExportFind('" + exportMode + "');", true);
        }
    }
    #endregion

    #region Event Handlers
    /// <summary>
    /// Sorting Event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void gvFind_Sorting(object sender, GridViewSortEventArgs e)
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
        isSort = true;
        BindDataGrid();
    }
   
    /// <summary>
    /// Calerder validation
    /// </summary>
    /// <param name="source"></param>
    /// <param name="args"></param> 
    protected void cvDatePicker_ServerValidate(object source, ServerValidateEventArgs args)
    {
        if (dtpStatusStart.SelectedDate != "" && dtpStatusEnd.SelectedDate != "")
        {
            if (Convert.ToDateTime(dtpStatusStart.SelectedDate) <= Convert.ToDateTime(dtpStatusEnd.SelectedDate))
                args.IsValid = true;
            else
                args.IsValid = false;
        }
        else
            args.IsValid = true;
    }
    /// <summary>
    /// Order serach based on customer no
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
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
                int maxRowCount = custDet.GetSQLWarningRowCount();


                if (strCnt < maxRowCount)
                    ScriptManager.RegisterClientScriptBlock(txtCustomerNumber, txtCustomerNumber.GetType(), "Customer", "LoadCustomerLookup('" + Server.UrlEncode(PFC.SOE.Securitylayer.Cryptor.Encrypt(strCustNo)) + "');", true);
                else
                    ScriptManager.RegisterClientScriptBlock(txtCustomerNumber, txtCustomerNumber.GetType(), "Customer", "alert('Maximum row exceeds for this search.please enter additional data.');", true);
            }
            else
            {
                DataTable dtCustomer = sOEFind.ValidateCustomer(txtCustomerNumber.Text.Trim());
                if (dtCustomer != null && dtCustomer.Rows.Count > 0)
                {
                    ClearControl();
                    txtCustomerNumber.Text = dtCustomer.Rows[0]["CustNo"].ToString();
                    ViewState["CustomerNumber"] = dtCustomer.Rows[0]["CustNo"].ToString();
                    lblContractNumber.Text = dtCustomer.Rows[0]["ContractNo"].ToString();
                    lblSalesRepNumber.Text = dtCustomer.Rows[0]["SlsRepNo"].ToString();
                    lblSalesRepName.Text = dtCustomer.Rows[0]["RepName"].ToString();
                    lblPriceCode.Text = dtCustomer.Rows[0]["PriceCd"].ToString();

                    ddlUserId.SelectedIndex = -1;
                    ListItem lstItem = ddlUserId.Items.FindByValue(dtCustomer.Rows[0]["SlsRepNo"].ToString().Trim()) as ListItem;
                    if (lstItem != null)
                        lstItem.Selected = true;

                    whereClause = "SellToCustNo='" + ViewState["CustomerNumber"].ToString() + "'" + deleteCondition;
                    upCustomerSearch.Update();
                    ScriptManager1.SetFocus(txtSOInvoiceNo);
                    //BindDataGrid();
                }
                else
                {
                    ViewState["CustomerNumber"] = null;
                    utility.DisplayMessage(PFC.SOE.Enums.MessageType.Failure, invalidCustomer, lblMessage);
                    upMessage.Update();
                    ClearControl();
                }
            }
        }
    }
    /// <summary>
    /// Order fins based on customer and PO/Invoice
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ibtnHeaderFind_Click(object sender, ImageClickEventArgs e)
    {
        if (txtCustomerNumber.Text != "")
        {
            string ddlbind = ddlconditionBind();

            if (ddlHeaderType.SelectedValue == "PO" && ViewState["CustomerNumber"] != null && txtCustomerNumber.Text.Trim() != "" && txtSOInvoiceNo.Text.Trim() != "")
            {
                whereClause = "SellToCustNo='" + ViewState["CustomerNumber"].ToString() + "' and CustPONo='" + txtSOInvoiceNo.Text + "'" + deleteCondition;
            }
            else if (ddlHeaderType.SelectedValue == "IN" && txtCustomerNumber.Text.Trim() != "" && txtSOInvoiceNo.Text.Trim() != "")
            {
                whereClause = "SellToCustNo='" + ViewState["CustomerNumber"].ToString() + "' and Invoiceno='" + txtSOInvoiceNo.Text + "'" + deleteCondition;
            }
            else
                whereClause = "SellToCustNo='" + ViewState["CustomerNumber"].ToString() + "'";

            whereClause = whereClause + ddlbind;
            BindDataGrid();
        }
        else
        {
            ScriptManager.RegisterClientScriptBlock(ibtnHeaderFind, ibtnHeaderFind.GetType(), "required", "alert('Enter Customer Number');", true);
            ScriptManager1.SetFocus(txtCustomerNumber);
        }
    }
    /// <summary>
    /// Order Search whth different description
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ibtnStatusFind_Click(object sender, ImageClickEventArgs e)
    {
        string ddlbind = ddlconditionBind();
        
        string condition = "";
        
        if (ddlSearchType.SelectedIndex == 0)
            condition = " convert(char(10),OrderDt,101) between convert(datetime,'" + dtpStatusStart.SelectedDate + "') and convert(datetime,'" + dtpStatusEnd.SelectedDate + "') and InvoiceDt is null ";
        else if (ddlSearchType.SelectedItem.Value.Trim() == "A")
            condition = " convert(char(10),AllocDt,101) between convert(datetime,'" + dtpStatusStart.SelectedDate + "') and convert(datetime,'" + dtpStatusEnd.SelectedDate + "') and InvoiceDt is null ";
        else if (ddlSearchType.SelectedItem.Value == "S")
            condition = " convert(char(10),ConfirmShipDt,101) between convert(datetime,'" + dtpStatusStart.SelectedDate + "') and convert(datetime,'" + dtpStatusEnd.SelectedDate + "') and InvoiceDt is null ";
        else if (ddlSearchType.SelectedItem.Value.Trim() == "D")
            condition = "  convert(char(10),DeleteDt,101) between convert(datetime,'" + dtpStatusStart.SelectedDate + "') and convert(datetime,'" + dtpStatusEnd.SelectedDate + "') and InvoiceDt is null ";
        else if (ddlSearchType.SelectedItem.Value.Trim() == "I")
            condition = "  convert(char(10),InvoiceDt,101) between convert(datetime,'" + dtpStatusStart.SelectedDate + "') and convert(datetime,'" + dtpStatusEnd.SelectedDate + "') ";
        else if (ddlSearchType.SelectedItem.Value.Trim() == "P")
            condition = " convert(char(10),PickDt,101) between convert(datetime,'" + dtpStatusStart.SelectedDate + "') and convert(datetime,'" + dtpStatusEnd.SelectedDate + "') and InvoiceDt is null ";
        else if (ddlSearchType.SelectedItem.Value.Trim() == "H")
            condition = " convert(char(10),HoldDt,101) between convert(datetime,'" + dtpStatusStart.SelectedDate + "') and convert(datetime,'" + dtpStatusEnd.SelectedDate + "') and InvoiceDt is null ";
        else if (ddlSearchType.SelectedItem.Value.Trim() == "W")
            condition = " convert(char(10),RlsWhseDt,101) between convert(datetime,'" + dtpStatusStart.SelectedDate + "') and convert(datetime,'" + dtpStatusEnd.SelectedDate + "') and InvoiceDt is null ";
        //else if (ddlSearchType.SelectedItem.Value.Trim() == "Pending")
        //    field = " convert(char(10),PendingDt,101) ";
        //else if (ddlSearchType.SelectedItem.Value.Trim() == "Printed")
        //    field = " convert(char(10),PrintDt,101) ";
        //else if (ddlSearchType.SelectedItem.Value.Trim() == "Verified")
        //    field = " convert(char(10),VerifyDt,101) ";

        //if (dtpStatusStart.SelectedDate != "" && dtpStatusEnd.SelectedDate != "")
        //    condition = "  " + field + " between convert(datetime,'" + dtpStatusStart.SelectedDate + "') and convert(datetime,'" + dtpStatusEnd.SelectedDate + "')";
        
        if (ddlSearchType.SelectedItem.Value.Trim() != "D")
            whereClause = ((ViewState["CustomerNumber"] == null || ViewState["CustomerNumber"].ToString() == "") ? "" : " SellToCustNo='" + ViewState["CustomerNumber"].ToString() + "' and") + condition + deleteCondition;
        else
            whereClause = ((ViewState["CustomerNumber"] ==null || ViewState["CustomerNumber"].ToString() =="")?"":" SellToCustNo='" + ViewState["CustomerNumber"].ToString() + "' and") + condition;
        
        whereClause = whereClause +  ddlbind;
        BindDataGrid();
    }
    /// <summary>
    /// Order Search event
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ibtnOrderSearch_Click(object sender, ImageClickEventArgs e)
    {
        string ddlbind = ddlconditionBind();
        if (ViewState["CustomerNumber"] != null && txtCustomerNumber.Text.Trim() != "")
        {
            string orderDate = "";
            string scheduledDate = "";
            string orderNo = "";
                         
            whereClause = orderDate + scheduledDate + orderNo + ((ViewState["CustomerNumber"] == null || ViewState["CustomerNumber"].ToString() == "") ? "" : " and SellToCustNo='" + ViewState["CustomerNumber"].ToString() + "'");
        }
        whereClause = whereClause +  ddlbind;
        BindDataGrid();
    }

    protected void ibtCancel_Click(object sender, ImageClickEventArgs e)
    {
        ClearControl();
    }  

    protected void gvFind_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "Edits")
        {
            
            string SoHeaderID = e.CommandArgument.ToString();
            ScriptManager.RegisterClientScriptBlock(gvFind, gvFind.GetType(), "fillParent", "BindOrderEntryForm('" + SoHeaderID + "');", true);
        }
    }

    protected void gvFind_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Footer)
        {
            Label lblTotalWeight = e.Row.FindControl("lblTotalWeight") as Label;
            lblTotalWeight.Text = String.Format("{0:#,##0.0}", dtSoFind.DefaultView.ToTable().Compute("sum(Weight)", ""));
            if (lblTotalWeight.Text == "")
                gvFind.ShowFooter = false;
            else
                gvFind.ShowFooter = true;
        }
    }

    public string cntCustName(string custNo)
    {
        DataTable dtCustomer = new DataTable();
        string tableName = "CustomerMaster";
        string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
        string whereClause = " CustName Like '" + custNo.Trim().Replace("%", "").Replace("'","''") + "%'";
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

    protected void ddlHeaderType_SelectedIndexChanged(object sender, EventArgs e)
    {
        upSOSearch.Update();
        
    }

    public string ddlconditionBind()
    {
        string strOrderType = (ddlOrderType.SelectedValue.Trim() == null || ddlOrderType.SelectedValue.Trim() == "") ? "" : " OrderType='" + ddlOrderType.SelectedValue.Trim() + "' and";
        string strShiploc = (ddlSalesLocation.SelectedValue.Trim() == null || ddlSalesLocation.SelectedValue.Trim() == "") ? "" : " CustShiploc='" + ddlSalesLocation.SelectedValue.Trim() + "' and" ;
        string strRep = (ddlUserId.SelectedValue.Trim() == null || ddlUserId.SelectedValue.Trim() == "") ? "" : " EntryID='" + ddlUserId.SelectedValue.Trim() + "' and";
        //string strRep = "";
        string ddlconditionBind = strOrderType + strShiploc + strRep;
        if (ddlconditionBind.Length > 4)
        {
            ddlconditionBind = " and " + ddlconditionBind.Remove((ddlconditionBind.Length - 3), 3);
        }
        return ddlconditionBind;
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void ReleaseLock()
    {
        orderEntry.ReleaseLock();
    }

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        string excelFileName = "SOFind" + DateTime.Now.ToString().Replace(":","").Replace("/","").Replace(" ","") + ".xls";
        FileInfo fnExcel = new FileInfo(Server.MapPath("Common//Excel//"+excelFileName ));
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();

        DataTable _dtSOFind = ViewState["dtSOFind"] as DataTable;
        if (_dtSOFind != null && _dtSOFind.Rows.Count > 0)
        {
            headerContent = "<table border='1'>";

            headerContent += "<tr><th colspan='15' style='color:blue' align=left><center>SO Find</center></th></tr>";
            headerContent += "<tr><td colspan='6'><b>Customer #: " + (txtCustomerNumber.Text == "" ? "ALL" :txtCustomerNumber.Text) + "</b></td><td  colspan='2'><b>User Id: " + ddlUserId.SelectedItem.Text + "</b></td>" +
                                "<td colspan='2'><b>Order Type: " + ddlOrderType.SelectedItem.Text + "</b></td><td colspan='5'><b>Sales Loc: " + ddlSalesLocation.SelectedItem.Text + "</b></td></tr>";
            headerContent += "<tr><td colspan='6'><b>Order Status: " + (ddlHeaderType.SelectedIndex == 0 ? "ALL" : ddlHeaderType.SelectedItem.Text) + "</b></td><td colspan='2'><b>Start Dt: " + dtpStatusStart.SelectedDate + "</b></td><td colspan='2'><b>End Dt: " + dtpStatusEnd.SelectedDate + "</b></td><td colspan='5'><b>Run By: " + Session["UserName"].ToString() + "&nbsp;&nbsp;  Run Date: " + DateTime.Now.ToShortDateString() + "</></td></tr>";                            
            headerContent += "<tr><th colspan='15' style='color:blue' align=left></th></tr>";

            headerContent += "<tr><th nowrap width='60'> <center>Ship Loc</center> </th>" +
                                "<th width='60'  nowrap><center>SO No.</center></td>" +
                                "<th width='60' nowrap   align='center'>Inv. No.</th>" +
                                "<th width='100' nowrap align='center'>PO Ref</th>" +
                                "<th width='70' class='GridHead splitBorders' nowrap  ><center>Order Amt</center></th>" +
                                "<th width='80'  nowrap align='center' nowrap  >Order Wght</th>" +
                                "<th width='60' align='center' nowrap  >Type</th>" +
                                "<th width='70'  nowrap align='center' nowrap >Ship Date</th>" +
                                "<th width='70'  nowrap align='center' nowrap >Sched Ship Date</th>" +
                                "<th width='70' nowrap align='center' nowrap >Order Date</th>" +
                                "<th width='70'  nowrap align='center' nowrap >Cust Req'd</th>" +
                                "<th width='100'  nowrap align='center' nowrap >Status</th>" +
                                "<th width='60'  nowrap align='center' nowrap >Carrier</th>" +
                                "<th width='90'  nowrap align='center' nowrap >Customer No</th>" +
                                "<th width='150'  nowrap align='center' nowrap >Customer Name</th>" +
                                "</tr>";


            if (_dtSOFind.Rows.Count > 0)
            {
                foreach (DataRow drSoFind in _dtSOFind.Rows)
                {
                    excelContent += "<tr><td STYLE=\"mso-number-format:00\">" + drSoFind["ShipLoc"].ToString() + "</td><td>" +
                                                    drSoFind["SoNo"] + "</td><td>" +
                                                    drSoFind["InvoiceNo"] + "</td><td>" +
                                                    drSoFind["PORef"] + "</td><td>" +
                                                    string.Format("{0:#,##0.00}", drSoFind["Amount"]) + "</td><td>" +
                                                    string.Format("{0:#,##0.0}", drSoFind["Weight"]) + "</td><td>" +
                                                    drSoFind["Type"] + "</td><td>" +
                                                    drSoFind["CShipDate"] + "</td><td>" +
                                                    drSoFind["SchShipDt"] + "</td><td>" +
                                                    drSoFind["OrderDate"] + "</td><td>" +
                                                    drSoFind["CustReq"] + "</td><td>" +
                                                    drSoFind["StatusCd"] + "</td><td STYLE=\"mso-number-format:00;\" align='left'>" +
                                                    drSoFind["Carrier"].ToString() + "</td><td STYLE=\"mso-number-format:000000\">" +
                                                    drSoFind["CustomerNo"] + "</td><td>" +
                                                    drSoFind["SellToCustName"] + "</td></tr>";

                }

                // Footer Total
                decimal _weight = Convert.ToDecimal(_dtSOFind.Compute("sum(Weight)", ""));
                footerContent = "<tr style='font-weight:bold'><td  colspan='5'>Total</td><td>" +
                String.Format("{0:#,##0.0}", _weight) + "</td></tr></table>";
                
            }
            reportWriter.WriteLine(headerContent + excelContent + footerContent);
            reportWriter.Close();

            //
            // Downloding Process
            //
            FileStream fileStream = File.Open(Server.MapPath("Common//Excel//" + excelFileName), FileMode.Open);
            Byte[] bytBytes = new Byte[fileStream.Length];
            fileStream.Read(bytBytes, 0, (int)fileStream.Length);
            fileStream.Close();

            //
            // Download Process
            //
            Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath("Common//Excel//" + excelFileName)));
            Response.ContentType = "application/octet-stream";
            Response.BinaryWrite(bytBytes);
            Response.End();
        }
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        gvFind.PageIndex = GridPager.GotoPageNumber;
        BindDataGrid();
    }
}
