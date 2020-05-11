#region Namespaces

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
using System.Data.SqlClient;
using System.Threading;
using System.IO;
using System.Reflection;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
using PFC.Intranet.eCommerceReport;

#endregion

public partial class CustomerContactReportPreview : System.Web.UI.Page
{
    #region Global Variables

    private string keyColumn = "customerNumber";
    private string sortExpression = string.Empty;
    
    string strCustType =  string.Empty;
    string strBranch = string.Empty;
    string strContactType = string.Empty;
    string strBG = string.Empty;
    string strFilterDt = string.Empty;
    
    CustomerContactReport CCR = new CustomerContactReport();
    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(CustomerContactReport));

        SystemCheck systemCheck = new SystemCheck();
        //Comment should be removed
        //systemCheck.SessionCheck();

        strCustType =  (Request.QueryString["CustomerType"] != null) ? Request.QueryString["CustomerType"].ToString().Trim() : "";
        strBranch = (Request.QueryString["Branch"] != null) ? Request.QueryString["Branch"].ToString().Trim() : "";
        strContactType = (Request.QueryString["ContactType"] != null) ? Request.QueryString["ContactType"].ToString().Trim() : "";
        strBG = (Request.QueryString["BuyingGroup"] != null) ? Request.QueryString["BuyingGroup"].ToString().Trim() : "";
        strFilterDt = (Request.QueryString["FilterDt"] != null) ? Request.QueryString["FilterDt"].ToString().Trim() : "";

        if (!IsPostBack)
        {   
            lblBranch.Text = Request.QueryString["BrnName"].ToString();
            lblCustomer.Text = Request.QueryString["CustName"].ToString();
            lblContact.Text = Request.QueryString["ContName"].ToString();
            lblbuyingGrp.Text = Request.QueryString["BGName"].ToString();
            lblFilterDt.Text = Request.QueryString["FilterDt"].ToString();
      
            BindDataGrid();
        }
        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");   

        hidFileName.Value = "ccrReport" + Session["SessionID"].ToString() + name + ".xls";
    } 

    #endregion

    #region Developer Code

    private void BindDataGrid()
    {
        sortExpression = ((hidSort.Value != "") ?  hidSort.Value : keyColumn);

        //dtQuoteAndOrder = eCommerceReport.GetQuote2OrderData(periodMonth, periodYear,customerNo);
        //dtQuote2Order = eCommerceReport.CreateJoins(dtQuoteAndOrder, GetCustomers());
        //dtQuote2Order.DefaultView.Sort = hidSort.Value;

        DataTable dtCCR = CCR.GetContactReport(strBranch, strCustType, strContactType, strBG, strFilterDt);
        
        if (dtCCR.Rows.Count > 0)
        {
            dtCCR.DefaultView.Sort = hidSort.Value;
            dgReport.DataSource = dtCCR.DefaultView.ToTable();
            dgReport.DataBind();
            //Pager1.Visible = true;
            //Pager1.InitPager(dgReport, pagesize);
            lblStatus.Visible = false;
        }
        else
        {
            //Pager1.Visible = false;
            lblStatus.Visible = true;
            lblStatus.Text = "No Records Found";
        }
    }
   
    #endregion

    #region Events

   


    protected void dgReport_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            //HyperLink hplButton = e.Item.FindControl("hplNoOfQuotes") as HyperLink;
            //hplButton.ForeColor = System.Drawing.Color.Blue;
            //hplButton.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'QuotePage', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");

            //HyperLink hplOrders = e.Item.FindControl("hplNoOfOrders") as HyperLink;
            //hplOrders.ForeColor = System.Drawing.Color.Blue;
            //hplOrders.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'OrderPage', 'height=710,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=no'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");
        }
    //   " <Div onclick=\"javascript:BindValue('NoOfQuotes');">&nbsp;# of Quotes</div>
        if (e.Item.ItemType == ListItemType.Header)
        {
            e.Item.Cells[5].ColumnSpan = 2;
            e.Item.Cells[5].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='160'><tr>"+
                                "<td class='GridHead splitBorder' colspan=2 nowrap align=center >Business</td></tr><tr>" +
                                "<td width='80' class='GridHead splitBorders' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('[Business Fax]');\">FAX</div></center></td>" +
                                "<td width='80' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('[Business Phone]');\">&nbsp;Phone</div></td></tr></table>";
            e.Item.Cells[6].Visible = false;
        }
    }


    protected void btnSort_Click(object source, EventArgs e)
    {
        if (hidSort.Attributes["sortType"] != null)
        {
            if (hidSort.Attributes["sortType"].ToString() == "ASC")
                hidSort.Attributes["sortType"] = "DESC";
            else
                hidSort.Attributes["sortType"] = "ASC";
        }
        else
            hidSort.Attributes.Add("sortType", "ASC");

        hidSort.Value = hidSortExpression.Value+  " " + hidSort.Attributes["sortType"].ToString();
        BindDataGrid();
    }
   

    #endregion

   
   
}
