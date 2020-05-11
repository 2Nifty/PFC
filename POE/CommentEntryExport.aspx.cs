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

public partial class CommentEntryExport : System.Web.UI.Page
{
    PurchaseOrderDetails purchaseOrder = new PurchaseOrderDetails();
    POCommentEntry commentEntry = new POCommentEntry();
    private String PONumber;
    private string OrderTable;
    private string CommentTable;

    public string HeaderIDColumn
    {
        get
        {
            if (OrderTable == "POHeader")
                return "fPOHeaderID";
            else if (OrderTable == "POHeaderRel")
                return "fPOHeaderRelID";
            else if (OrderTable == "POHeaderHist")
                return "fPOHeaderHistID";
            else
                return "fPOHeaderID";
        }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        //CommentTable = Request.QueryString["CommentTableName"].ToString();
        //OrderTable = Request.QueryString["HeaderTableName"].ToString();

        CommentTable = "POComments";
        OrderTable = "POHeader";

        PONumber = Request.QueryString["PONumber"].ToString();
        hidSort.Value = Request.QueryString["Sort"].ToString();
        if (!Page.IsPostBack)
        {
            lnkStyle.Href = "http://" + Request.ServerVariables["SERVER_NAME"].ToString() + "/POE/Common/StyleSheet/printstyles.css";
            imglogo.ImageUrl = "http://" + Request.ServerVariables["SERVER_NAME"].ToString() + "/POE/Common/Images/PFC_logo.gif";
            BindData();
        }
    }
    private void BindData()
    {
        try
        {
            string whereClause = HeaderIDColumn + "= '" + PONumber + " ' and DeleteDt is null";
            
            if (Convert.ToBoolean(Request.QueryString["Deleted"]))
                whereClause = HeaderIDColumn + "= '" + PONumber + "'";
            if (Request.QueryString["Type"] !=null && Request.QueryString["Type"].ToString() != "")
                whereClause += " and Type ='" + Request.QueryString["Type"].ToString() + "'";

            DataTable dssubHeader = purchaseOrder.GetPurchaseOrderDetails(OrderTable, "POOrderNo,OrderContactName,BuyFromAddress,BuyFromCity,BuyFromState,BuyFromZip,BuyFromCountry,OrderContactPhoneNo,BuyFromVendorNo,ShipToName,ShipToAddress,ShipToCity,ShipToState,ShipToPhoneNo,ShipToZip,ShipToCountry,POVendorNo", "POOrderNo=" + PONumber);
            dlSOEHeader.DataSource = dssubHeader;            
            dlSOEHeader.DataBind();
            DataTable dtSort = commentEntry.GetCommentPrint(CommentTable, whereClause);
            dtSort.DefaultView.Sort =(hidSort.Value == "") ? "Type asc" : hidSort.Value;
            dgComment.DataSource = dtSort;
            //dgComment.DataSource = commentEntry.GetCommentPrint(CommentTable, whereClause);
            dgComment.DataBind();
        }
        catch (Exception ex) { }

    }
    
}
