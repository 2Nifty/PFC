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

public partial class CustomerContactReportPage : System.Web.UI.Page
{
    #region Global Variables

    private string keyColumn = "customerNumber";
    private string sortExpression = string.Empty;
    
    string strCustType =  string.Empty;
    string strBranch = string.Empty;
    string strContactType = string.Empty;
    string strBG = string.Empty;
    string strFilterDt = string.Empty;

    int pagesize = 19;
    
    CustomerContactReport CCR = new CustomerContactReport();
    #endregion

    #region Load Event

    protected void Page_Load(object sender, EventArgs e)
    {
        // Register The Class Name in Ajax Utility
        Ajax.Utility.RegisterTypeForAjax(typeof(CustomerContactReportPage));

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
            lblbuyingGrp.Text = Request.QueryString["BGName"].ToString().Trim();
            lblFilterDt.Text = Request.QueryString["FilterDt"].ToString().Trim();
       
            BindDataGrid();
        }
        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");   

        hidFileName.Value = "CustomerContactReport " + Session["SessionID"].ToString() + name + ".xls";
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
            //dgReport.DataBind();
            Pager1.Visible = true;
            Pager1.InitPager(dgReport, pagesize);
            lblStatus.Visible = false;
        }
        else
        {
            Pager1.Visible = false;
            lblStatus.Visible = true;
            lblStatus.Text = "No Records Found";
        }
    }
   
    #endregion

    #region Events

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgReport.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
        pnlDatagrid.Update();
    }

    protected void dgReport_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgReport.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
        pnlDatagrid.Update();
    }


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
            e.Item.Cells[5].Text = "<table border='0' cellpadding='0' cellspacing='0'  width='225'><tr>"+
                                "<td class='GridHead splitBorder' colspan=2 nowrap >Business</td></tr><tr>"+
                                "<td width='115' class='GridHead splitBorders' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('[Business Fax]');\">FAX</div></center></td>" +
                                "<td width='110' class='GridHead' nowrap align='center' style='cursor:hand;'><Div onclick=\"javascript:BindValue('[Business Phone]');\">&nbsp;Phone</div></td></tr></table>";
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

    protected void dgReport_SortCommand(object source, DataGridSortCommandEventArgs e)
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

        hidSort.Value = e.SortExpression + " " + hidSort.Attributes["sortType"].ToString();
        BindDataGrid();

    }

    #endregion

    #region Write to Excel

    protected void ibtnExcelExport_Click(object sender, ImageClickEventArgs e)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()));
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        string sortExpression = ((hidSort.Value != "") ? hidSort.Value : keyColumn);
      
        DataTable dtCCR = CCR.GetContactReport(strBranch, strCustType, strContactType, strBG, strFilterDt);


        headerContent = "<table border='1' >";
        headerContent += "<tr><th colspan='14' style='color:blue'>Customer Contact Report</th></tr>";
        headerContent += "<tr id=trHead class=PageBg ><td colspan=11><b><table cellpadding=1 cellspacing=0 width=100 style='font-weight:bold;'><tr><td class=LeftPadding TabHead style=width:110px colspan=2>Branch : " + lblBranch.Text + "</td>" +
             "<td class=LeftPadding TabHead style=width:180px>Contact Type :" + lblContact.Text + "</td>" +
             "<td class=TabHead  style=width:200px>Customer Type :" + lblCustomer.Text+   "</td>"+
             "<td width=200px;>&nbsp;</td>"+
             "<td class=TabHead style=width:130px>Run By :" + Session["UserName"].ToString() + "</td>"+
             "<td class=TabHead style=width:130px>Run Date :" + DateTime.Now.ToShortDateString() + "</td>"+
             "</tr></table></b></td></tr>";
        //if (strBranch != "")
        //{
        //    headerContent += "<tr><th>Name</th><th>Company</th><th>Cust #</th><th>Job Title</th><th><b><table border=1 style='font-weight:bold;'>" +
        //        "<tr><td colspan=2 align=center>Business</td></tr><tr><td align=center>Fax</td><td align=center>Phone</td></tr></table></b></th>" +
        //        "<th>Mobile Phone</th><th>E-Mail Address</th><th>Buying Group</th><th>Customer Type</th><th>Contact Type</th><th>Address</th><th>Allow Marketing</th></tr>";
        
        //}
        //else
        //{
        headerContent += "<tr><th width=50px;>Branch # </th><th>Name</th><th>Company</th><th>Cust #</th><th>Job Title</th><th><b><table border=1 style='font-weight:bold;'>" +
               "<tr><td colspan=2 align=center>Business</td></tr><tr><td align=center>Fax</td><td align=center>Phone</td></tr></table></b></th>" +
               "<th>Mobile Phone</th><th>E-Mail Address</th><th>Buying Group</th><th>Customer Type</th><th>Contact Type</th><th>Address</th><th>Allow Marketing</th><th>Contact #</th></tr>";
        
        //}
        if (dtCCR.Rows.Count > 0)
        {
            //if (strBranch != "")
            //{
            //    dtCCR.DefaultView.Sort = hidSort.Value;
            //    foreach (DataRow dr in dtCCR.DefaultView.ToTable().Rows)
            //    {
            //        excelContent += "<tr><td>" + dr["Name"].ToString() + "</td><td>" +
            //             dr["Company"].ToString() + "</td><td>" +
            //             dr["Cust #"].ToString() + "</td><td>" +
            //             dr["Job Title"].ToString() + "</td><td><table border=1 ><tr><td>" +
            //             dr["Business Fax"].ToString() + "</td><td>" + dr["Business Phone"].ToString() + "</td></tr></table><td>" +
            //             dr["Mobile Phone"].ToString() + "</td><td>" +
            //             dr["E-Mail Address"].ToString() + "</td><td>" +
            //             dr["Buying Group"].ToString() + "</td><td>" +
            //             dr["Customer Type"].ToString() + "</td><td>" +
            //             dr["Contact Type"].ToString() + "</td><td>" +
            //             dr["Address"].ToString() + "</td><td>" +
            //             dr["AllowMarketingEmailInd"].ToString() + "</td></tr>";

            //    }
            //}
            //else
            //{
                dtCCR.DefaultView.Sort = hidSort.Value;
                foreach (DataRow dr in dtCCR.DefaultView.ToTable().Rows)
                {
                    excelContent += "<tr><td>" + dr["Branch #"].ToString() + "</td><td>" +
                         dr["Name"].ToString() + "</td><td>" +
                         dr["Company"].ToString() + "</td><td>" +
                         dr["Cust #"].ToString() + "</td><td>" +
                         dr["Job Title"].ToString() + "</td><td><table border=1 ><tr><td>" +
                         dr["Business Fax"].ToString() + "</td><td>" + dr["Business Phone"].ToString() + "</td></tr></table><td>" +
                         dr["Mobile Phone"].ToString() + "</td><td>" +
                         dr["E-Mail Address"].ToString() + "</td><td>" +
                         dr["Buying Group"].ToString() + "</td><td>" +
                         dr["Customer Type"].ToString() + "</td><td>" +
                         dr["Contact Type"].ToString() + "</td><td>" +
                         dr["Address"].ToString() + "</td><td>" +
                         dr["AllowMarketingEmailInd"].ToString() + "</td><td>" +
                         dr["ContactId"].ToString() + "</td></tr>";

                }
            //}
           
        }
        reportWriter.WriteLine(headerContent + excelContent+"</table>");
        reportWriter.Close();


        //
        // Downloding Process
        //
        FileStream fileStream = File.Open(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString()), FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        //
        // Download Process
        //
        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath("Common//ExcelUploads//" + hidFileName.Value.ToString())));
        Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }
  
    #endregion

    #region Delete Excel using sessionid

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\CustomerContactReport\\Common\\ExcelUploads"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(strSession))
                    fn.Delete();
            }

            return "";
        }
        catch (Exception ex) { return ""; }
    } 

    #endregion   
   
}
