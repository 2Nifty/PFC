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



public partial class SubHeader : System.Web.UI.UserControl
{

    PurchaseOrderDetails purchaseOrder = new PurchaseOrderDetails();

    public string HeaderIDColumn
    {
        get
        {
            return "pPOHeaderID";
        }
    }
    public string PONumber
    {
        set { txtPONumber.Text = value; BindSaleOrderDetails();  }
        get
        {
            return txtPONumber.Text;
        }
    }
    public string VendorNumber
    {
        set { hidVendorNo.Value = value;  }
        get
        {
            return hidVendorNo.Value;
        }
    }
    public string POOrderID
    {
        set { hidPOOrderID.Value = value; }
        get
        {
            return hidPOOrderID.Value;
        }
    }
    public string CustNumber
    {
       
        get
        {
            return lblBuyVendorNum.Text;
        }
    }
    
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

           // BindSaleaOrderDetails();
        }
    }

    private void BindSaleOrderDetails()
    {
        
        string whereClause = HeaderIDColumn + "=" + PONumber.ToUpper().Replace("W","");

        DataTable dsSalesOrderDetails = purchaseOrder.GetPurchaseOrderDetails("POHeader", "PPOHeaderID,POOrderNo,OrderContactName,BuyFromAddress,BuyFromCity,BuyFromState,BuyFromZip,BuyFromCountry,OrderContactPhoneNo,BuyFromVendorNo,ShipToName,ShipToAddress,ShipToCity,ShipToState,ShipToPhoneNo,ShipToZip,ShipToCountry,POVendorNo", whereClause);
        
        if (dsSalesOrderDetails != null && dsSalesOrderDetails.Rows.Count>0)
        {            
            //SellToCustNo,SellToCustName,SellToAddress1,SellToAddress2,SellToAddress3,SellToCity,SellToState,SellToZip,SellToProvidence,SellToCountry,SellToContactName,SellToContactPhoneNo,ShipToCd,ShipToName,ShipToAddress1,ShipToAddress2,ShipToAddress3,City,State,Zip,PhoneNo,FaxNo,ContactName,ContactPhoneNo";
            lblBuy_Name.Text = dsSalesOrderDetails.Rows[0]["OrderContactName"].ToString().Trim();
            lblBuy_Address.Text = dsSalesOrderDetails.Rows[0]["BuyFromAddress"].ToString().Trim();
            lblBuy_City.Text = dsSalesOrderDetails.Rows[0]["BuyFromCity"].ToString().Trim();
            lblBuy_Territory.Text = dsSalesOrderDetails.Rows[0]["BuyFromState"].ToString().Trim();
            lblBuy_Phone.Text = dsSalesOrderDetails.Rows[0]["OrderContactPhoneNo"].ToString().Trim();
            lblBuy_Pincode.Text = dsSalesOrderDetails.Rows[0]["BuyFromZip"].ToString().Trim();
            lblBuyCom.Visible = ((lblBuy_City.Text.Trim() != "" && lblBuy_Territory.Text.Trim() != "") ? true : false);
            lblBuyCountry.Text = dsSalesOrderDetails.Rows[0]["BuyFromCountry"].ToString().Trim();
            
            lblShip_Name.Text = dsSalesOrderDetails.Rows[0]["ShipToName"].ToString().Trim();
            lblShip_Address.Text = dsSalesOrderDetails.Rows[0]["ShipToAddress"].ToString().Trim();
            lblShip_City.Text = dsSalesOrderDetails.Rows[0]["ShipToCity"].ToString().Trim();
            lblShip_State.Text = dsSalesOrderDetails.Rows[0]["ShipToState"].ToString().Trim();
            lblShip_Phone.Text = dsSalesOrderDetails.Rows[0]["ShipToPhoneNo"].ToString().Trim();
            lblShip_Pincode.Text = dsSalesOrderDetails.Rows[0]["ShipToZip"].ToString().Trim();
            lblShipCom.Visible = ((lblShip_City.Text.Trim() != "" && lblShip_State.Text.Trim() != "") ? true : false);
            lblShipCountry.Text = dsSalesOrderDetails.Rows[0]["ShipToCountry"].ToString().Trim();

            lblBuyVendorNum.Text = dsSalesOrderDetails.Rows[0]["BuyFromVendorNo"].ToString().Trim();
            lblShipVendorNum.Text = dsSalesOrderDetails.Rows[0]["POVendorNo"].ToString().Trim();
            VendorNumber = lblShipVendorNum.Text;
            POOrderID = dsSalesOrderDetails.Rows[0]["PPOHeaderID"].ToString().Trim();
        }
    }


    
}
