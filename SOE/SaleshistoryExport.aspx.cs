/** 
 * Project Name: SOE
 * 
 * Module Name: Pending Orders & Quotes
 * 
 * Author: Sathishvaran
 *
 * Abstract: Page used to find Pending orders in SOE system...
 *
 * Revision History:
 * 
 *  DATE				VERSION			AUTHOR							ACTION
 * <-------------------------------------------------------------------------->			
 *	15 Nov '08			Ver-1			Sathishvaran		            Created
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

public partial class SoldToAddressExport : System.Web.UI.Page
{
    #region Variable Declaration

    SoldToAddress soldToAddress = new SoldToAddress();      
    Utility utility = new Utility();
    Common common = new Common();

    #endregion
    
    #region Page events

    SalesOrderDetails Sod = new SalesOrderDetails();
    SalesHISTory salesHis = new SalesHISTory();
    Utility util = new Utility();

    CustomerDetail custDet = new CustomerDetail();

    // Create instance for the webservice
    OrderEntry orderEntry = new OrderEntry();

    DataTable dsValidateCustomer = new DataTable();
    DataTable dsSalesHistory = new DataTable();
    public string custNumber = "";
    public string SoNumber = "";
    
    public DateTime stDate;
    public DateTime endDate;

    public string fMonth ="";
    public string eMonth = "";
    public string eYear = "";
    public string fYear = "";

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            txtCustNumber.Text = custNumber = Request.QueryString["CustomerNumber"].ToString();
            SoNumber = Request.QueryString["SONumber"].ToString();
            lblStMonth.Text = fMonth = Request.QueryString["frmMonth"].ToString();
            lblStYear.Text = fYear = Request.QueryString["frmYear"].ToString();
            lblEndMonth.Text = eMonth = Request.QueryString["endMonth"].ToString();
            lblEndYear.Text = eYear = Request.QueryString["endYear"].ToString();
            //Request.QueryString["Sort"].ToString();
            BindSaleaOrderDetails();
            BindDataGrid();
        }
    }

    public void BindDataGrid()
    {
        stDate = Convert.ToDateTime(fMonth + "/01/" + fYear);
        endDate = Convert.ToDateTime(eMonth + "/28/" + eYear);

        dsSalesHistory = salesHis.GetSalesHistory(custNumber, stDate, endDate);
        if (dsSalesHistory.Rows.Count > 0 && dsSalesHistory != null)
            lblMsg.Visible = false;
        else
        {
            lblMsg.Text = "No Records found";
            lblMsg.Visible = true;
        }

        dsSalesHistory.DefaultView.Sort = (hidSort.Value == "") ? "itemNo asc" : hidSort.Value;
        dgSalesHistory.DataSource = dsSalesHistory;
        dgSalesHistory.DataBind();
        
    }

    private void BindSaleaOrderDetails()
    {
        SalesOrderDetails salesOrder = new SalesOrderDetails();
        DataTable dsSalesOrderDetails = salesOrder.GetSalesOrderDetails("SOHeader", "pSOHeaderID,SellToCustNo,SellToCustName,SellToAddress1,SellToAddress2,SellToAddress3,SellToCity,SellToState,SellToZip,SellToCountry,SellToContactName,SellToContactPhoneNo,ShipToName,ShipToAddress1,City,State,PhoneNo,Zip,Country", "pSOHeaderID=" + SoNumber);
        if (dsSalesOrderDetails != null)
        {
            lblSold_Name.Text = dsSalesOrderDetails.Rows[0]["SellToCustName"].ToString().Trim();
            lblSold_Contact.Text = dsSalesOrderDetails.Rows[0]["SellToAddress1"].ToString().Trim();
            lblSold_City.Text = dsSalesOrderDetails.Rows[0]["SellToCity"].ToString().Trim();
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
        }
    }



    #endregion


}
