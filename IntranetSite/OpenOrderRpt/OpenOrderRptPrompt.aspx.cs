using System;
using System.IO;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;


public partial class OpenOrderRptPrompt : System.Web.UI.Page
{
    SqlConnection cnx;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet dsOrders = new DataSet(), dsSOEType = new DataSet(), dsLoc = new DataSet();
    string strSQL;

    SalesReportUtils salesReportUtils = new SalesReportUtils();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(OpenOrderRptPrompt));
        cnx = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);

        //Response.Write(Session["UserID"].ToString() + "<br>" + Session["UserName"].ToString() + "<br>" + Session["SessionID"].ToString());
                
        Session["UserID"] = ((Session["UserID"] != null) ? Session["UserID"].ToString() : "328");   //intranet
        Session["UserName"] = ((Session["UserName"] != null) ? Session["UserName"].ToString() : "intranet");   //intranet
        Session["SessionID"] = ((Session["SessionID"] != null) ? Session["SessionID"].ToString() : "null");
        iCustNo.Focus();

        if (!Page.IsPostBack)
        {
            FillDropDowns();
        }
    }

    protected void iCustNo_TextChanged(object sender, EventArgs e)
    {
        //string strCustNo = iCustNo.Text;

        bool custIsNum = true;
        try
        {
            int.Parse(iCustNo.Text);
        }
        catch
        {
            custIsNum = false;
        }

        if ((iCustNo.Text != "") && !custIsNum)
        {
            ScriptManager.RegisterClientScriptBlock(iCustNo, iCustNo.GetType(), "Customer", "LoadCustomerLookup('" + Server.UrlEncode(PFC.Intranet.Securitylayer.Cryptor.Encrypt(iCustNo.Text)) + "');", true);
        }
        else
        {
            iCustNo.Text = iCustNo.Text.ToString().PadLeft(6, '0');
        }

        if (iCustNo.Text == "000000")
            iCustNo.Text = "";
    }

    protected void btnView_Click(object sender, ImageClickEventArgs e)
    {
        string url =    "OpenOrderRpt.aspx?CustNo="+iCustNo.Text.ToString().PadLeft(6, '0')+
                        "&OrdType=" + iOrderType.SelectedValue.ToString() +
                        "&SalesPerson=" + Server.UrlEncode(iSalesPerson.Text.ToString()) +
                        "&CustShipLoc=" + iCustShipLoc.SelectedValue.ToString()+
                        "&ShipLoc=" + iShipLoc.SelectedValue.ToString() +
                        "&OrdTypeDesc=" + Server.UrlEncode(iOrderType.SelectedItem.Text.ToString()) +
                        "&CustShipLocDesc=" + Server.UrlEncode(iCustShipLoc.SelectedItem.Text.ToString()) +
                        "&ShipLocDesc=" + Server.UrlEncode(iShipLoc.SelectedItem.Text.ToString()) +
                        "&BadMgn=" + iBadMgn.Checked.ToString();

        ScriptManager.RegisterClientScriptBlock(btnView, btnView.GetType(), "openreport", "ViewReport('" + url + "')", true);
    }

    protected void FillDropDowns()
    {
        //Fill the Order Type Drop Down
        strSQL = "SELECT ListValue as OrderType, ListValue + ' - ' + ListDtlDesc as [Desc] " +
                 "FROM ListMaster (NoLock) INNER JOIN ListDetail (NoLock) ON pListMasterID=fListMasterID " +
                 "WHERE	ListName='soeordertypes' ORDER BY OrderType";
        dsSOEType = SqlHelper.ExecuteDataset(cnx, CommandType.Text, strSQL);
        iOrderType.DataSource = dsSOEType;
        iOrderType.DataValueField = dsSOEType.Tables[0].Columns["OrderType"].ToString();
        iOrderType.DataTextField = dsSOEType.Tables[0].Columns["Desc"].ToString();
        iOrderType.DataBind();
        iOrderType.Items.Insert(0, new ListItem("All", "All"));

        //Fill the Sales Loc Drop Down
        strSQL = "SELECT LocID as Location, LocID + ' - ' + LocName as [Desc] " +
                 "FROM LocMaster (NoLock) " +
                 "WHERE	LocType='B' ORDER BY LocID";
        dsLoc = SqlHelper.ExecuteDataset(cnx, CommandType.Text, strSQL);
        iCustShipLoc.DataSource = dsLoc;
        iCustShipLoc.DataValueField = dsLoc.Tables[0].Columns["Location"].ToString();
        iCustShipLoc.DataTextField = dsLoc.Tables[0].Columns["Desc"].ToString();
        iCustShipLoc.DataBind();
        iCustShipLoc.Items.Insert(0, new ListItem("All", "All"));

        //Fill the Ship Loc Drop Down
        strSQL = "SELECT LocID as Location, LocID + ' - ' + LocName as [Desc] " +
                 "FROM LocMaster (NoLock) " +
                 "WHERE	MaintainIMQtyInd='Y' ORDER BY LocID";
        dsLoc = SqlHelper.ExecuteDataset(cnx, CommandType.Text, strSQL);
        iShipLoc.DataSource = dsLoc;
        iShipLoc.DataValueField = dsLoc.Tables[0].Columns["Location"].ToString();
        iShipLoc.DataTextField = dsLoc.Tables[0].Columns["Desc"].ToString();
        iShipLoc.DataBind();
        iShipLoc.Items.Insert(0, new ListItem("All", "All"));

        //Fill the Sales Loc & Ship Loc Drop Downs
        //salesReportUtils.FillBranchesAndChainSession(Session["UserID"].ToString());
        //salesReportUtils.GetALLBranches(iCustShipLoc, Session["UserID"].ToString());
        //salesReportUtils.GetALLBranches(iShipLoc, Session["UserID"].ToString());
        //iCustShipLoc.Items[0].Value = "All";
        //iShipLoc.Items[0].Value = "All";
    }

}
