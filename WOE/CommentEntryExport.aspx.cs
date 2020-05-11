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
using PFC.WOE.BusinessLogicLayer;
using PFC.WOE.DataAccessLayer;

public partial class CommentEntryExport : System.Web.UI.Page
{
    PFC.WOE.BusinessLogicLayer.CommentEntry comments = new PFC.WOE.BusinessLogicLayer.CommentEntry();
    DataUtility utility = new DataUtility(); 

    private String PONumber;
    private string OrderTable;
    private string CommentTable;

    public string HeaderIDColumn
    {
        get
        {
            if (OrderTable == "POHeader")
                return "pPOHeaderID";
            else if (OrderTable == "POHeaderHist")
                return "pPOHeaderHistID";
            else
                return "pPOHeaderID";
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
            BindData();
        }
    }
    private void BindData()
    {
        try
        {
            string whereClause = "fPOHeaderID= '" + PONumber + " ' and DeleteDt is null";
            
            if (Convert.ToBoolean(Request.QueryString["Deleted"]))
                whereClause = "fPOHeaderID= '" + PONumber + "'";
            if (Request.QueryString["Type"] !=null && Request.QueryString["Type"].ToString() != "")
                whereClause += " and Type ='" + Request.QueryString["Type"].ToString() + "'";

            DataTable dssubHeader = utility.GetTableData(OrderTable, "POOrderNo,OrderContactName,BuyFromAddress,BuyFromCity,BuyFromState,BuyFromZip,BuyFromCountry,OrderContactPhoneNo,BuyFromVendorNo,ShipToName,ShipToAddress,ShipToCity,ShipToState,ShipToPhoneNo,ShipToZip,ShipToCountry,POVendorNo", HeaderIDColumn + "=" + PONumber);
            dlSOEHeader.DataSource = dssubHeader;            
            dlSOEHeader.DataBind();
            DataTable dtSort = comments.GetCommentPrint(CommentTable, whereClause);
            dtSort.DefaultView.Sort =(hidSort.Value == "") ? "Type asc" : hidSort.Value;
            dgComment.DataSource = dtSort;
            //dgComment.DataSource = commentEntry.GetCommentPrint(CommentTable, whereClause);
            dgComment.DataBind();
        }
        catch (Exception ex) { }

    }
    
}
