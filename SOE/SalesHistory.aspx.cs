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
using PFC.SOE.DataAccessLayer;
using PFC.SOE.BusinessLogicLayer;

public partial class SalesHistory : System.Web.UI.Page
{
    SalesOrderDetails Sod = new SalesOrderDetails();
    SalesHISTory salesHis = new SalesHISTory();
    Utility util =new Utility() ;

    CustomerDetail custDet = new CustomerDetail();

    // Create instance for the webservice
    OrderEntry orderEntry = new OrderEntry();

    DataTable dsValidateCustomer = new DataTable();
    DataTable dsSalesHistory = new DataTable();
    string custNumber = "";
    string SoNumber = "";
    int pagesize=10;

    public DateTime stDate ;
    public DateTime endDate ;

    public string HeaderIDColumn
    {
        get
        {
            if (Session["OrderTableName"].ToString() == "SOHeader")
                return "fSOHeaderID";
            else if (Session["OrderTableName"].ToString() == "SOHeaderRel")
                return "pSOHeaderRelID";
            else if (Session["OrderTableName"].ToString() == "SOHeaderHist")
                return "pSOHeaderHistID";
            else
                return "fSOHeaderID";
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
            txtCustNumber.Focus();

            BindMonthYear();
            
            if (Request.QueryString["SONumber"] != null && Request.QueryString["SONumber"].ToString() != "")
            {
                txtCustNumber.Text = custNumber = Request.QueryString["CustomerNumber"].ToString();
                hidSoNumber.Value = Request.QueryString["SONumber"].ToString();
                BindSaleaOrderDetails();                
                BindDataGrid();
                upMessage.Update();
                pnlcustEntry.Update();
            }
            


        }
    }

    public void BindDataGrid()
    {
        
        stDate = Convert.ToDateTime(ddlStMonth.SelectedValue.ToString() + "/01/" + ddlStYear.SelectedValue.ToString());
        endDate = Convert.ToDateTime(ddlEndMonth.SelectedValue.ToString() + "/28/" + ddlEndYear.SelectedValue.ToString());

        PrintDialogue1.CustomerNo = custNumber;
        PrintDialogue1.PageTitle = "Sales history for " + custNumber;
        string TempUrl = "saleshistoryExport.aspx?CustomerNumber=" + custNumber + "&SONumber=" + hidSoNumber.Value.ToString() + "&frmMonth=" + ddlStMonth.SelectedValue.ToString()+ "&frmYear=" + ddlStYear.SelectedValue.ToString() + "&endMonth=" + ddlEndMonth.SelectedValue.ToString() + "&endYear="  +ddlEndYear.SelectedValue.ToString();
        PrintDialogue1.PageUrl = Server.UrlEncode(TempUrl);

        dsSalesHistory = salesHis.GetSalesHistory(custNumber, stDate, endDate);
        if (dsSalesHistory.Rows.Count > 0 && dsSalesHistory != null)
            lblMsg.Visible = false;
        else
        {
            lblMsg.Text = "No Records found";
            lblMsg.Visible = true;
        }
            
        dsSalesHistory .DefaultView.Sort = (hidSort.Value == "") ? "itemNo asc" : hidSort.Value;
        dgSalesHistory.DataSource = dsSalesHistory;
        Pager1.InitPager(dgSalesHistory, pagesize);
        upSalesHistoryGrid.Update();
    }

    private void BindSaleaOrderDetails()
    {
        SoNumber = hidSoNumber.Value;
        string whereClause = HeaderIDColumn + "=" + SoNumber.ToUpper().Replace("W", "");
        DataTable dsSalesOrderDetails = Sod.GetSalesOrderDetails(Session["OrderTableName"].ToString(), "SellToCustNo,SellToCustName,SellToAddress1,SellToAddress2,SellToAddress3,SellToCity,SellToState,SellToZip,SellToCountry,SellToContactName,SellToContactPhoneNo,ShipToName,ShipToAddress1,City,State,PhoneNo,Zip,Country", whereClause);
             
        if (dsSalesOrderDetails != null)
        {

            //SellToCustNo,SellToCustName,SellToAddress1,SellToAddress2,SellToAddress3,SellToCity,SellToState,SellToZip,SellToProvidence,SellToCountry,SellToContactName,SellToContactPhoneNo,ShipToCd,ShipToName,ShipToAddress1,ShipToAddress2,ShipToAddress3,City,State,Zip,PhoneNo,FaxNo,ContactName,ContactPhoneNo";
            lblSold_Name.Text = dsSalesOrderDetails.Rows[0]["SellToCustName"].ToString().Trim() ;
            lblSold_Address.Text = dsSalesOrderDetails.Rows[0]["SellToAddress1"].ToString().Trim();
            lblSold_City.Text = (dsSalesOrderDetails.Rows[0]["SellToCity"].ToString().Trim() != "" ? dsSalesOrderDetails.Rows[0]["SellToCity"].ToString().Trim() + ",&nbsp;" :dsSalesOrderDetails.Rows[0]["SellToCity"].ToString().Trim());
            lblSold_Territory.Text = dsSalesOrderDetails.Rows[0]["SellToState"].ToString().Trim();
            lblSold_Phone.Text = dsSalesOrderDetails.Rows[0]["SellToContactPhoneNo"].ToString().Trim();
            lblSold_Pincode.Text = dsSalesOrderDetails.Rows[0]["SellToZip"].ToString().Trim();
            lblSoldCom.Visible = ((lblSold_City.Text.Trim() != "" && lblSold_Territory.Text.Trim() != "") ? true : false);
            lblSoldCountry.Text = dsSalesOrderDetails.Rows[0]["SellToCountry"].ToString().Trim();

            lblShip_Name.Text = dsSalesOrderDetails.Rows[0]["ShipToName"].ToString().Trim();
            lblShip_Contact.Text = dsSalesOrderDetails.Rows[0]["ShipToAddress1"].ToString().Trim();
            lblShip_City.Text = dsSalesOrderDetails.Rows[0]["City"].ToString().Trim();
            lblShip_State.Text = dsSalesOrderDetails.Rows[0]["State"].ToString().Trim();
            lblShip_Phone.Text = dsSalesOrderDetails.Rows[0]["PhoneNo"].ToString().Trim();
            lblShip_Pincode.Text = dsSalesOrderDetails.Rows[0]["Zip"].ToString().Trim();
            lblShipCom.Visible = ((lblShip_City.Text.Trim() != "" && lblShip_State.Text.Trim() != "") ? true : false);
            lblShipCountry.Text = dsSalesOrderDetails.Rows[0]["Country"].ToString().Trim();

            lblSoldCustNum.Text = dsSalesOrderDetails.Rows[0]["SellToCustNo"].ToString().Trim();
            lblShipCustNum.Text = dsSalesOrderDetails.Rows[0]["SellToCustNo"].ToString().Trim();
            lblSalesRepdisp.Text = salesHis.GetSalesRepName(salesHis.GetSalesRepNo(custNumber));
        }
    }

    #region Date Check
    protected void ibtnHeaderFind_Click(object sender, ImageClickEventArgs e)
    {
        custNumber = txtCustNumber.Text;
        DateTime stDate = Convert.ToDateTime(ddlStMonth.SelectedValue + "/01/"  + ddlStYear.SelectedValue);
        DateTime endDate = Convert.ToDateTime ( ddlEndMonth.SelectedValue + "/28/" + ddlEndYear.SelectedValue);
        lblMessage.Text = (stDate <= endDate) ? "" : "Invalid Date Range";
        lblMessage.ForeColor = System.Drawing.Color.Red;
        BindDataGrid();
        upMessage.Update();
        pnlcustEntry.Update();
    }

    public void BindMonthYear()
    {
        util.BindListControls(ddlStYear, "FiscalYear", "FiscalYear", salesHis.GetYear());
        util.BindListControls(ddlEndYear, "FiscalYear", "FiscalYear", salesHis.GetYear());
        ValidateMonthYear();
    }

    public void ValidateMonthYear()
    {
        string endMonth = DateTime.Now.Month.ToString();
        string stYear = DateTime.Now.Year.ToString();
        string stMonth = endMonth != "1" ? Convert.ToString(Int32.Parse(endMonth) - 1) : "12";

        SelectItem(ddlStMonth, stMonth);
        SelectItem(ddlStYear, stYear);
        SelectItem(ddlEndMonth, endMonth);
        SelectItem(ddlEndYear, stYear);
    }

    private void SelectItem(DropDownList ddlControl, string value)
    {
        ListItem lItem = ddlControl.Items.FindByValue(value) as ListItem;
        if (lItem != null)
            ddlControl.SelectedValue = value;
    }
    # endregion

    # region DataGrid
    protected void dgSalesHistory_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        e.Item.Cells[0].CssClass = "locked";
        e.Item.Cells[1].CssClass = "locked";
    }

    protected void dgSalesHistory_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        dgSalesHistory.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
    }

    protected void dgSalesHistory__SortCommand(object source, DataGridSortCommandEventArgs e)
    {
        custNumber = txtCustNumber.Text;

        if (hidSort.Attributes["sortType"] != null)
        {
            if (hidSort.Attributes["sortType"].ToString() == "ASC")
                hidSort.Attributes["sortType"] = "DESC";
            else
                hidSort.Attributes["sortType"] = "ASC";
        }
        else
            hidSort.Attributes.Add("sortType", "ASC");

        hidSort.Value = ((e.SortExpression.IndexOf(" ") != -1) ? "[" + e.SortExpression + "]" : e.SortExpression) + " " + hidSort.Attributes["sortType"].ToString();
        BindDataGrid();
        upMessage.Update();
        pnlcustEntry.Update();

    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        custNumber = txtCustNumber.Text;
        dgSalesHistory.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    # endregion

    # region TxtCustno Changed

    protected void txtCustNumber_TextChanged(object sender, EventArgs e)
    {
        hidSoNumber.Value = "";
        string strCustNo = custNumber = txtCustNumber.Text;
        
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
            ScriptManager.RegisterClientScriptBlock(txtCustNumber, txtCustNumber.GetType(), "Customer", "LoadCustomerLookup('" + Server.UrlEncode(PFC.SOE.Securitylayer.Cryptor.Encrypt(strCustNo)) + "');", true);
        }
        else
        {
            LoadCustomerDetails();
            BindDataGrid();
            upMessage.Update();
            pnlcustEntry.Update();
        }
    }
    
    protected void btnLoadCustomer_Click(object sender, EventArgs e)
    {
        try
        {
            // Call the function to fill the customer details in the controls
            LoadCustomerDetails();

        }
        catch (System.Net.WebException ex)
        {
        }
        catch (System.Web.Services.Protocols.SoapException ex)
        {

        }
        catch (System.InvalidOperationException ex)
        {
        }
        catch (Exception ex)
        {
        }
    }

    /// <summary>
    /// Function to load the customer details
    /// </summary>
    public void LoadCustomerDetails()
    {

        //custNumber = hidCust.Value.Trim();

        #region Code to fill the customer details in the controls

        // Call the webservice to get the customer address detail
        DataSet dsCustomer = orderEntry.GetCustomerDetails(txtCustNumber.Text.Trim().Replace("'", ""));
       // DataSet dsShipTo = orderEntry.GetShipToDetails(txtCustNumber.Text);

        // Function to clear the value in the label
        ClearLabels();

        if (dsCustomer != null && dsCustomer.Tables[0].Rows.Count != 0)
        {
            hidCust.Value = txtCustNumber.Text;
            Session["CustNo"] = hidCust.Value.Trim();
            Session["CustomerDetail"] = dsCustomer.Tables[0];
            FillCustomerAddress(dsCustomer);
            lblSoldCustNum.Text = hidCust.Value.Trim();
            lblShipCustNum.Text = hidCust.Value.Trim();

            // Code to bind the location details
            DataSet dsLocation = custDet.GetLocationDetails();
            if (dsCustomer != null && dsCustomer.Tables[3].Rows.Count != 0)
            {
                Session["ShipDetails"] = dsCustomer.Tables[3];

                // Call the function to fill the ship to details
                FillShipTo(dsCustomer);
            }
        }
        else
        {

            hidCust.Value = "";
            Session["CustNo"] = null;
            Session["CustomerDetail"] = null;
            Session["ShipDetails"] = null;
            return;
        }


        #endregion

        BindDataGrid();
        upMessage.Update();
    }

    /// <summary>
    /// Function to fill the customer address
    /// </summary>
    /// <param name="dtAddress"></param>
    public void FillCustomerAddress(DataSet dtAddress)
    {
        // Set the customer address details to the control
        if (dtAddress.Tables[1] != null && dtAddress.Tables[1].Rows.Count > 0)
        {
            lblSold_Name.Text = dtAddress.Tables[0].Rows[0]["Name"].ToString().Trim();
            lblSold_Address.Text = dtAddress.Tables[1].Rows[0]["Address"].ToString().Trim();
            lblSold_City.Text = (dtAddress.Tables[1].Rows[0]["City"].ToString().Trim() != "" ? dtAddress.Tables[1].Rows[0]["City"].ToString().Trim() + ",&nbsp;" :dtAddress.Tables[1].Rows[0]["City"].ToString().Trim());
            lblSold_Territory.Text = dtAddress.Tables[1].Rows[0]["State"].ToString().Trim();
            lblSold_Phone.Text = dtAddress.Tables[1].Rows[0]["Phone No_"].ToString().Trim();
            lblSold_Pincode.Text = dtAddress.Tables[1].Rows[0]["Post Code"].ToString().Trim();
            lblSoldCom.Visible = ((lblSold_City.Text.Trim() != "" && lblSold_Territory.Text.Trim() != "") ? true : false);
            lblSoldCountry.Text = dtAddress.Tables[1].Rows[0]["Country"].ToString().Trim();
            //lblSalesRepdisp.Text = salesHis.GetSalesRepName(dtAddress.Rows[0]["Salesperson Code"].ToString().Trim());
        }
        lblSalesRepdisp.Text = dtAddress.Tables[0].Rows[0]["Salesperson Code"].ToString().Trim();
   
    }
    
    /// <summary>
    /// Function to fill ship to details
    /// </summary>
    /// <param name="dtShipTo"></param>
    public void FillShipTo(DataSet dsShipTo)
    {
        // Code to fill the ship to details
        lblShip_Name.Text = dsShipTo.Tables[3].Rows[0]["Name"].ToString().Trim();
        lblShip_Contact.Text = dsShipTo.Tables[3].Rows[0]["Address"].ToString().Trim();
        lblShip_City.Text = dsShipTo.Tables[3].Rows[0]["City"].ToString().Trim();
        lblShip_State.Text = dsShipTo.Tables[3].Rows[0]["Country"].ToString().Trim();
        lblShip_Phone.Text = dsShipTo.Tables[3].Rows[0]["Phone No_"].ToString().Trim();
        lblShip_Pincode.Text = dsShipTo.Tables[3].Rows[0]["Post Code"].ToString().Trim();
        lblShipCom.Visible = ((lblShip_City.Text.Trim() != "" && lblShip_State.Text.Trim() != "") ? true : false);
        lblShipCountry.Text = dsShipTo.Tables[0].Rows[0]["Country Code"].ToString().Trim();
    }

    public void ClearLabels()
    {
        try
        {

            lblSold_Name.Text = "";
            lblSold_Address.Text = "";
            lblSold_City.Text = "";
            lblSold_Territory.Text = "";
            lblSold_Phone.Text = "";
            lblSold_Pincode.Text = "";
            lblShip_Name.Text = "";
            lblShip_Contact.Text = "";
            lblShip_City.Text = "";
            lblShip_State.Text = "";
            lblShip_Phone.Text = "";
            lblShip_Pincode.Text = "";
            //lblSales.Text = "";
            lblShipCustNum.Text = "";
            lblSoldCustNum.Text = "";
            lblSoldCountry.Text = "";
            lblShipCountry.Text = "";
            //lblBill_To.Text = "";
            //  lblContact.Text = "";
            //txtSONumber.Text = "";

        }
        catch (Exception ex) { }
    }

    public string cntCustName(string custNo)
    {
        DataTable dtCustomer = new DataTable();
        string tableName = "CustomerMaster";
        string columnName = "Count(*) as totalcount";//Contract No,Form Dist,
        string whereClause = " CustName Like '" + custNo.Trim().Replace("%", "") + "%'";
        DataSet dsCustomer = salesHis.ExecuteSelectQuery(tableName, columnName, whereClause);

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
        DataSet dsCustomer = salesHis.ExecuteSelectQuery(tableName, columnName, whereClause);

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
   
}
