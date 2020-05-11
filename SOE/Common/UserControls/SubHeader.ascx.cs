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


public partial class SubHeader : System.Web.UI.UserControl
{

    SalesOrderDetails Sod = new SalesOrderDetails();

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
    public string SONumber
    {
        set { txtSONumber.Text = value; BindSaleaOrderDetails(); }
        get
        {
            return txtSONumber.Text;
        }
    }
    public string CustNumber
    {  
        get
        {
            return lblSoldCustNum.Text;
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

           // BindSaleaOrderDetails();
        }
    }

    private void BindSaleaOrderDetails()
    {
        
        //string whereClause = HeaderIDColumn + "=" + SONumber.ToUpper().Replace("W","");
        string whereClause = "OrderNo=" + SONumber.ToUpper().Replace("W", "");

        DataTable dsSalesOrderDetails = Sod.GetSalesOrderDetails(Session["OrderTableName"].ToString(), "SellToCustNo,SellToCustName,SellToAddress1,SellToAddress2,SellToAddress3,SellToCity,SellToState,SellToZip,SellToCountry,SellToContactName,SellToContactPhoneNo,ShipToName,ShipToAddress1,City,State,PhoneNo,Zip,Country", whereClause);
        
        if (dsSalesOrderDetails != null)
        {

            //SellToCustNo,SellToCustName,SellToAddress1,SellToAddress2,SellToAddress3,SellToCity,SellToState,SellToZip,SellToProvidence,SellToCountry,SellToContactName,SellToContactPhoneNo,ShipToCd,ShipToName,ShipToAddress1,ShipToAddress2,ShipToAddress3,City,State,Zip,PhoneNo,FaxNo,ContactName,ContactPhoneNo";
            lblSold_Name.Text = dsSalesOrderDetails.Rows[0]["SellToCustName"].ToString().Trim();
            lblSold_Address.Text = dsSalesOrderDetails.Rows[0]["SellToAddress1"].ToString().Trim();
            lblSold_City.Text = dsSalesOrderDetails.Rows[0]["SellToCity"].ToString().Trim();
            lblSold_Territory.Text = dsSalesOrderDetails.Rows[0]["SellToState"].ToString().Trim();
            lblSold_Phone.Text = dsSalesOrderDetails.Rows[0]["SellToContactPhoneNo"].ToString().Trim();
            lblSold_Pincode.Text = dsSalesOrderDetails.Rows[0]["SellToZip"].ToString().Trim();
            lblSoldCom.Visible = ((lblSold_City.Text.Trim() != "" && lblSold_Territory.Text.Trim() != "") ? true : false);
            lblSoldCountry.Text = dsSalesOrderDetails.Rows[0]["SellToCountry"].ToString().Trim();
            
            lblShip_Name.Text = dsSalesOrderDetails.Rows[0]["ShipToName"].ToString().Trim();
            lblShip_Address.Text = dsSalesOrderDetails.Rows[0]["ShipToAddress1"].ToString().Trim();
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

    private void BindShipToDetails()
    { 
        //string SoNumber = txtSONumber.Text;

        //DataTable dsShipToDetails = Sod.GetShipToDetails(SoNumber);

        //if (dsShipToDetails != null && dsShipToDetails.Rows.Count > 0 )
        //{
        //    lblShip_Name.Text = dsShipToDetails.Rows[0]["Name2"].ToString().Trim();
        //    lblShip_Contact.Text = dsShipToDetails.Rows[0]["AddrLine1"].ToString().Trim();
        //    lblShip_City.Text = dsShipToDetails.Rows[0]["City"].ToString().Trim();
        //    lblShip_State.Text = dsShipToDetails.Rows[0]["State"].ToString().Trim();
        //    lblShip_Phone.Text = dsShipToDetails.Rows[0]["ContactPhoneNo"].ToString().Trim();
        //    lblShip_Pincode.Text = dsShipToDetails.Rows[0]["PostCd"].ToString().Trim();
        //    lblShipCom.Visible = ((lblShip_City.Text.Trim() != "" && lblShip_State.Text.Trim() != "") ? true : false);
        //    lblShipCountry.Text = dsShipToDetails.Rows[0]["Country"].ToString().Trim();

        //}

    }
}
