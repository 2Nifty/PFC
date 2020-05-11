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


public partial class OpenOrderRpt : System.Web.UI.Page
{
    SqlConnection cnx;
    SqlCommand cmd;
    SqlDataAdapter adp;
    DataSet dsOrders = new DataSet(), dsSOEType = new DataSet(), dsLoc = new DataSet();
    string strSQL;

    SalesReportUtils salesReportUtils = new SalesReportUtils();
    string iCustNo = "";
    string iOrderType = "";
    string iSalesPerson = "";
    string iCustShipLoc = "";
    string iShipLoc = "";
    string iBadMgn = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(OpenOrderRpt));
        cnx = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);

        //Response.Write(Session["UserID"].ToString() + "<br>" + Session["UserName"].ToString() + "<br>" + Session["SessionID"].ToString());
                
        Session["UserID"] = ((Session["UserID"] != null) ? Session["UserID"].ToString() : "328");   //intranet
        Session["UserName"] = ((Session["UserName"] != null) ? Session["UserName"].ToString() : "intranet");   //intranet
        Session["SessionID"] = ((Session["SessionID"] != null) ? Session["SessionID"].ToString() : "null");

        iCustNo = Request.QueryString["CustNo"].ToString();
        iOrderType = Request.QueryString["OrdType"].ToString();
        iSalesPerson = Request.QueryString["SalesPerson"].ToString();
        iCustShipLoc = Request.QueryString["CustShipLoc"].ToString();
        iShipLoc = Request.QueryString["ShipLoc"].ToString();
        iBadMgn = Request.QueryString["BadMgn"].ToString();

        hidCust.Value = iCustNo.ToString().PadLeft(6, '0');
        hidOrdType.Value = iOrderType.ToString();
        hidSalesPerson.Value = iSalesPerson.ToString();
        hidCustShipLoc.Value = iCustShipLoc.ToString();
        hidShipLoc.Value = iShipLoc.ToString();
        hidBadMgn.Value = iBadMgn.ToString();

        lblCustNo.Text = ((iCustNo == "" || iCustNo == "000000") ? "All" : iCustNo);
        lblOrderType.Text = Request.QueryString["OrdTypeDesc"].ToString();
        lblSalesPerson.Text = (iSalesPerson == "" ? "All" : iSalesPerson);
        lblSalesLoc.Text = Request.QueryString["CustShipLocDesc"].ToString();
        lblShipLoc.Text = Request.QueryString["ShipLocDesc"].ToString();
        lblLineType.Text = (iBadMgn.ToLower() == "true" ? "Only bad margin lines" : "All Lines");

        if (!Page.IsPostBack)
        {
            //btnClose.Attributes.Add("onclick", "javascript:window.location='" + Request.ServerVariables.Get("HTTP_REFERER") + "'");
            hidReferer.Value = Request.ServerVariables.Get("HTTP_REFERER");
            BindDataGrid();
        }
    }

    protected void btnView_Click(object sender, ImageClickEventArgs e)
    {
        GridView1.CurrentPageIndex = 0;
        BindDataGrid();                
    }

    public void BindDataGrid()
    {
        cmd = new SqlCommand("pOpenOrderRpt", cnx);
        cmd.Parameters.AddWithValue("@CustNo", iCustNo.ToString().PadLeft(6, '0'));
        cmd.Parameters.AddWithValue("@OrderType", iOrderType.ToString());
        cmd.Parameters.AddWithValue("@EntryID", iSalesPerson.ToString());
        cmd.Parameters.AddWithValue("@CustShipLoc", iCustShipLoc.ToString());
        cmd.Parameters.AddWithValue("@ShipLoc", iShipLoc.ToString());
        cmd.Parameters.AddWithValue("@BadMgn", iBadMgn.ToString());
        cmd.CommandType = CommandType.StoredProcedure;
        
        string sortExpression = (hidSort.Value == "") ? " CustNo, SONumber Asc" : hidSort.Value;
        adp = new SqlDataAdapter(cmd);
        dsOrders.Clear();
        adp.Fill(dsOrders, "OpenOrders");
        dsOrders.Tables["OpenOrders"].DefaultView.Sort = sortExpression;
        GridView1.DataSource = dsOrders.Tables["OpenOrders"].DefaultView.ToTable();
        //GridView1.DataBind();
        Pager1.InitPager(GridView1, 18);
        Pager1.Visible = true;
    }

    protected void GridView1_SortCommand(object source, DataGridSortCommandEventArgs e)
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

        hidSort.Value = "[" + e.SortExpression + "] " + hidSort.Attributes["sortType"].ToString();

        BindDataGrid();

    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        GridView1.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataGrid();
    }

    protected void ExportRpt_Click(object sender, ImageClickEventArgs e)
    {
        BindDataGrid();
        
        String xlsFile = "OpenOrderRpt" + Session["SessionID"] + ".xls";
        String ExportFile = Server.MapPath("..//OpenOrderRpt//Excel//") + xlsFile;
        string headerContent = string.Empty;
        string footerContent = string.Empty;
        string excelContent = string.Empty;

        FileInfo fnExcel = new FileInfo(ExportFile);
        StreamWriter swExcel;
        swExcel = fnExcel.CreateText();

        headerContent = "<table border=1px><tr><td>Cust No</td><td>Cust Name</td><td>SO Number</td><td>PO Number</td><td>Reference</td><td>Item No</td>" +
                          "<td>Description</td><td>Quantity</td><td>UOM</td><td>Unit Price</td><td>Mgn %</td><td>Order Date</td>" +
                          "<td>Ship Date</td><td>Sell Loc</td><td>Ship Loc</td><td>Alt Price</td><td>Alt UOM</td><td>Salessperson</td></tr>";

        foreach (DataRow SORow in dsOrders.Tables["OpenOrders"].Rows)
            excelContent += "<tr><td>" + SORow["CustNo"].ToString() + "</td><td>" + SORow["CustName"].ToString() + "</td><td>" + SORow["SONumber"].ToString() + "</td><td>" +
                              SORow["PONumber"].ToString() + "</td><td style='mso-number-format:\\@;'>" + SORow["Ref"].ToString() + "</td><td>" + SORow["Item"].ToString() + "</td><td>" +
                              SORow["Description"].ToString() + "</td><td>" + String.Format("{0:0}", SORow["Quantity"]) + "</td><td>" + SORow["UOM"].ToString() + "</td><td>" +
                              String.Format("{0:C}", SORow["UnitPrice"]) + "</td><td>" + String.Format("{0:0.00%}", SORow["Mgn%"]) + "</td><td>" +
                              String.Format("{0:d}", SORow["OrderDt"]) + "</td><td>" + String.Format("{0:d}", SORow["ShipDt"]) + "</td><td>" +
                              SORow["SalesLoc"].ToString() + "</td><td>" + SORow["ShipLoc"].ToString() + "</td><td>" + String.Format("{0:C}", SORow["AltPrice"]) + "</td><td>" +
                              SORow["AltUOM"].ToString() + "</td><td>" + SORow["SalesPerson"].ToString() + "</td></tr>";

        swExcel.WriteLine(headerContent + excelContent + "</table>");
        swExcel.Close();
        
        //
        // Downloding Process
        //
        FileStream fileStream = File.Open(Server.MapPath("Excel//" + xlsFile), FileMode.Open);
        Byte[] bytBytes = new Byte[fileStream.Length];
        fileStream.Read(bytBytes, 0, (int)fileStream.Length);
        fileStream.Close();

        //
        // Download Process
        //
        Response.Clear();
        Response.Buffer = true;
        Response.ContentType = "application/vnd.ms-excel";
        Response.AddHeader("Content-disposition", "attachment; filename=" + Path.GetFileName(Server.MapPath("Excel//" + xlsFile)));
        //Response.ContentType = "application/octet-stream";
        Response.BinaryWrite(bytBytes);
        Response.End();
    }

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {
            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..//OpenOrderRpt//Excel//"));

            foreach (FileInfo fn in drExcel.GetFiles())
            {
                if (fn.Name.Contains(strSession))
                    fn.Delete();
            }

            return "";
        }
        catch (Exception ex) { return ""; }
    }

    protected void GridView1_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        e.Item.Cells[0].CssClass = "locked";
        e.Item.Cells[1].CssClass = "locked";
    }
}
