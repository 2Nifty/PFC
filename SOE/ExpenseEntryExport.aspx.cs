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
public partial class ExpenseEntryExport : System.Web.UI.Page
{
    SalesOrderDetails salesOrder = new SalesOrderDetails();
    ExpenseEntry expenseEntry = new ExpenseEntry();
    private String SONumber;
    protected void Page_Load(object sender, EventArgs e)
    {
        SONumber = Request.QueryString["SONumber"].ToString();
        if (!Page.IsPostBack)
        {
            BindData();
        }
    }
    private void BindData()
    {
        try
        {
            DataTable dssubHeader = salesOrder.GetSalesOrderDetails("SOHeader", "pSOHeaderID,SellToCustNo,SellToCustName,SellToAddress1,SellToAddress2,SellToAddress3,SellToCity,SellToState,SellToZip,SellToCountry,SellToContactName,SellToContactPhoneNo,ShipToName,ShipToAddress1,City,State,PhoneNo,Zip,Country", "pSOHeaderID=" + SONumber);
            dlSOEHeader.DataSource = dssubHeader;
            dlSOEHeader.DataBind();
            dgExpense.DataSource= expenseEntry.GetExpensePrint(SONumber);
            dgExpense.DataBind();
        }
        catch (Exception ex) { }

    }
}
