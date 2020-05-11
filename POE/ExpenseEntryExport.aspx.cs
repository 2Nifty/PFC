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

public partial class ExpenseEntryExport : System.Web.UI.Page
{
    PurchaseOrderDetails purchaseOrder = new PurchaseOrderDetails();
    ExpenseEntry expenseEntry = new ExpenseEntry();
    private String PONumber;
    protected void Page_Load(object sender, EventArgs e)
    {
       PONumber = Request.QueryString["PONumber"].ToString();
        //PONumber = "";
        if (!Page.IsPostBack)
        {
            BindData();
        }
    }
    private void BindData()
    {
        try
        {
            DataTable dssubHeader = purchaseOrder.GetPurchaseOrderDetails("POHeader", "pPOHeaderID,OrderContactName,BuyFromAddress,BuyFromCity,BuyFromState,BuyFromZip,BuyFromCountry,OrderContactPhoneNo,BuyFromVendorNo,ShipToName,ShipToAddress,ShipToCity,ShipToState,ShipToPhoneNo,ShipToZip,ShipToCountry,POVendorNo", "pPOHeaderID=" + PONumber);
            dlSOEHeader.DataSource = dssubHeader;
            dlSOEHeader.DataBind();
            dgExpense.DataSource= expenseEntry.GetExpensePrint(PONumber);
            dgExpense.DataBind();
        }
        catch (Exception ex) { }

    }
}
