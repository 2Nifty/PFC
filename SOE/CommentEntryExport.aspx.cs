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
public partial class CommentEntryExport : System.Web.UI.Page
{
    SalesOrderDetails salesOrder = new SalesOrderDetails();
    SOCommentEntry commentEntry = new SOCommentEntry();
    private String SONumber;
    private string OrderTable;
    private string CommentTable;

    public string HeaderIDColumn
    {
        get
        {
            if (OrderTable == "SOHeader")
                return "fSOHeaderID";
            else if (OrderTable == "SOHeaderRel")
                return "fSOHeaderRelID";
            else if (OrderTable == "SOHeaderHist")
                return "fSOHeaderHistID";
            else
                return "fSOHeaderID";
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        CommentTable = Request.QueryString["CommentTableName"].ToString();
        OrderTable = Request.QueryString["HeaderTableName"].ToString();
        SONumber = Request.QueryString["SONumber"].ToString();
        if (!Page.IsPostBack)
        {
            lnkStyle.Href = "http://" + Request.ServerVariables["SERVER_NAME"].ToString() + "/SOE/Common/StyleSheet/printstyles.css";
            imglogo.ImageUrl = "http://" + Request.ServerVariables["SERVER_NAME"].ToString() + "/SOE/Common/Images/PFC_logo.gif";
            BindData();
        }
    }
    private void BindData()
    {
        try
        {
            string whereClause = HeaderIDColumn + "= '" + SONumber + " ' and DeleteDt is null";

            if (Convert.ToBoolean(Request.QueryString["Deleted"]))
                whereClause = HeaderIDColumn + "= '" + SONumber + "'";
            if (Request.QueryString["Type"] !=null && Request.QueryString["Type"].ToString() != "")
                whereClause += " and Type ='" + Request.QueryString["Type"].ToString() + "'";

            DataTable dssubHeader = salesOrder.GetSalesOrderDetails(OrderTable, "OrderNo,SellToCustNo,SellToCustName,SellToAddress1,SellToAddress2,SellToAddress3,SellToCity,SellToState,SellToZip,SellToCountry,SellToContactName,SellToContactPhoneNo,ShipToName,ShipToAddress1,City,State,PhoneNo,Zip,Country", "OrderNo=" + SONumber);
            dlSOEHeader.DataSource = dssubHeader;
            dlSOEHeader.DataBind();
            dgComment.DataSource = commentEntry.GetCommentPrint(CommentTable, whereClause);
            dgComment.DataBind();
        }
        catch (Exception ex) { }

    }
}
