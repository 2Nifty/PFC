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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet;
using PFC.Intranet.Utility;


public partial class SalesForeCastingTool_CustomerSelectorPreview : System.Web.UI.Page
{
    SalesForecastingTool salesSorecastingTool = new SalesForecastingTool();
    private DataSet dsCustomerData = new DataSet();
    DataTable dtCustomerData = new DataTable();
    private DataTable dtTotal = new DataTable();
    private string branchID, orderType = "";
    private string keyColumn = "YTDSales";

    #region page events

    protected void Page_Load(object sender, EventArgs e)
    {
        branchID = Request.QueryString["Branch"].ToString();
        orderType = Request.QueryString["OrderType"].ToString();

        if (orderType.Trim() == "Mill")
            orderType = "m";
        else
            orderType = "w";

       



        if (!Page.IsPostBack)
        {
            //Request.QueryString["HeaderText"] = "Update --";

            lblHeaderBranch.Text = Request.QueryString["HeaderText"].ToString() + " Business";
            FillCASHeader();
            BindDataGrid();
        }
    }



    public void FillCASHeader()
    {
        try
        {

            // Bind the datagrid with datatable
            dgCas.DataSource = salesSorecastingTool.GetCASHeaderRecord(branchID);
            dgCas.DataBind();
            // Display the info to the user when table contains no records
            lblStatus.Visible = (dgCas.Items.Count <= 0 ? true : false);


        }
        catch (Exception ex) { Response.Write(ex.ToString()); }
    }

    private void BindDataGrid()
    {


        string sortExpression = ((Request.QueryString["Sort"] != null && Request.QueryString["Sort"] != "") ? " ORDER BY  " + Request.QueryString["Sort"].ToString() : " ORDER BY " + keyColumn + " DESC");
        dsCustomerData = salesSorecastingTool.GetCustomerSalesData(branchID, orderType, sortExpression);
        dtTotal = dsCustomerData.Tables[0].DefaultView.ToTable();
        if (dtTotal.Rows.Count > 0)
        {
            GetTotal();
            dgCustomer.DataSource = dsCustomerData.Tables[0];
            dgCustomer.DataBind();
            HighLightCheckBox();
            //pnldgrid.Update();
        }
    }

    private void GetTotal()
    {
        dtTotal.Clear();
        DataRow drow = dtTotal.NewRow();

        decimal SalesPerLb = (Convert.ToDecimal(dsCustomerData.Tables[0].Compute("sum(YTDWgt)", "")) == 0) ? 0 : (Convert.ToDecimal(dsCustomerData.Tables[0].Compute("sum(YTDSales)", "")) / Convert.ToDecimal(dsCustomerData.Tables[0].Compute("sum(YTDWgt)", "")));
        decimal GPPct = (Convert.ToDecimal(dsCustomerData.Tables[0].Compute("sum(YTDSales)", "")) == 0) ? 0 : ((Convert.ToDecimal(dsCustomerData.Tables[0].Compute("sum(YTDSales)", "")) - Convert.ToDecimal(dsCustomerData.Tables[0].Compute("sum(YTDGM)", ""))) / Convert.ToDecimal(dsCustomerData.Tables[0].Compute("sum(YTDSales)", "")));

        drow["cust"] = "";
        drow["CustName"] = "Total ";
        drow["YTDWgt"] = Convert.ToDecimal(dsCustomerData.Tables[0].Compute("sum(YTDWgt)", "")).ToString();
        drow["YTDSales"] = Convert.ToDecimal(dsCustomerData.Tables[0].Compute("sum(YTDSales)", "")).ToString();
        drow["SalesPerLb"] = SalesPerLb.ToString();//(Convert.ToDecimal(dsCustomerData.Tables[0].Compute("sum(YTDSales)", "")) / Convert.ToDecimal(dsCustomerData.Tables[0].Compute("sum(YTDWgt)", ""))).ToString();
        drow["YTDGM"] = Convert.ToDecimal(dsCustomerData.Tables[0].Compute("sum(YTDGM)", "")).ToString();
        drow["GPPct"] = GPPct.ToString(); ((Convert.ToDecimal(dsCustomerData.Tables[0].Compute("sum(YTDSales)", "")) - Convert.ToDecimal(dsCustomerData.Tables[0].Compute("sum(YTDGM)", ""))) / Convert.ToDecimal(dsCustomerData.Tables[0].Compute("sum(YTDSales)", ""))).ToString();
        dtTotal.Rows.InsertAt(drow, 0);
        
    }

    protected void dgCustomer_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        #region Header & Total Display

        if (e.Item.ItemType == ListItemType.Header)
        {

            e.Item.BorderStyle =  BorderStyle.Outset;
            //e.Item.Cells[0].Text = "<table border='0' bgcolor='#DFF3F9' cellpadding='0' height=40px cellspacing='0' runat=server  width='105%' ><tr>" +
            //                  "<td class='GridHead splitBorder'  nowrap >Select</td></tr><tr>" +
            //                  "<td width='36' class='GridHead splitBorders' style='cursor:hand;'><center>&nbsp;</center></td></tr></table>";

            e.Item.Cells[0].Visible = false;
            e.Item.Cells[1].ColumnSpan = 2;
            e.Item.Cells[1].Text = "<table border='0' bgcolor='#DFF3F9' cellpadding='0' height=40px  cellspacing='0'  width='100%'><tr>" +
                                    "<td width='54' class='GridHead splitBorder' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('cust');\">Cust</div></center></td><td class='GridHead splitBorder' style='cursor:hand;' width='*'><center><Div onclick=\"javascript:BindValue('CustName');\">Name</div></center></td></tr><tr>" +
                                    "<td class='GridHead splitBorders' colspan=2 style='padding-left:10px;border-bottom:1px Solid #cccccc;' align='left' nowrap >Total</td></tr></table>";

            e.Item.Cells[2].Text = "<table border='0' cellpadding='0' height=40px  cellspacing='0'  width='101%' align='right'><tr><td class='GridHead splitBorder'  style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('YTDWgt');\">YTD Lbs</div></center></td></tr>" +
                                    "<tr align='right' ><td align='right' class='GridHead splitBorders' style='padding-right:10px;border-bottom:1px Solid #cccccc;'>" + String.Format("{0:#,##0}", dtTotal.Rows[0]["YTDWgt"]) + "</td></tr></table>";


            e.Item.Cells[3].Text = "<table border='0' cellpadding='0' height=40px  cellspacing='0'  width='101%' align='right'><tr><td class='GridHead splitBorder'  style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('YTDSales');\">YTD Dollars</div></center></td></tr>" +
                                    "<tr align='right'><td align='right' class='GridHead splitBorders' style='padding-right:10px;border-bottom:1px Solid #cccccc;'>" + String.Format("{0:#,##0}", dtTotal.Rows[0]["YTDSales"]) + "</td></tr></table>";

            e.Item.Cells[4].Text = "<table border='0' cellpadding='0' height=40px  cellspacing='0'  width='101%' align='right'><tr><td class='GridHead splitBorder' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('SalesPerLb');\">$/Lb</div></center></td></tr>" +
                                    "<tr align='right'><td align='right' class='GridHead splitBorders' style='padding-right:10px;border-bottom:1px Solid #cccccc;'>" + String.Format("{0:#,##0.00}", dtTotal.Rows[0]["SalesPerLb"]) + "</td></tr></table>";

            e.Item.Cells[5].Text = "<table border='0' cellpadding='0' height=40px  cellspacing='0'  width='101%' align='right'><tr><td class='GridHead splitBorder' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('YTDGM');\">YTD GP$</div></center></td></tr>" +
                                    "<tr align='right'><td align='right' class='GridHead splitBorders'  style='padding-right:10px;border-bottom:1px Solid #cccccc;border-bottom:1px Solid #cccccc;'>" + String.Format("{0:#,##0}", dtTotal.Rows[0]["YTDGM"]) + "</td></tr></table>";

            e.Item.Cells[6].Text = "<table border='0' cellpadding='0' height=40px  cellspacing='0'  width='101%' align='right'><tr><td class='GridHead splitBorder' style='cursor:hand;'><center><Div onclick=\"javascript:BindValue('GPPct');\">GP %</div></center></td></tr>" +
                                   "<td align='right' class='GridHead splitBorders' style='padding-right:10px;border-bottom:1px Solid #cccccc;'><span >" + String.Format("{0:#,##0.0}", dtTotal.Rows[0]["GPPct"]) + "</span></td></tr></table>";

            e.Item.Cells[7].Text = "<table border='0' cellpadding='0' height=40px  cellspacing='0'  width='101%' align='right'><tr><td class='GridHead splitBorder'>&nbsp;</td></tr></table>";

        }
        #endregion
    }
    protected void dgCustomer_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgCustomer.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
        //pnldgrid.Update();
    }

    private void HighLightCheckBox()
    {
        DataTable dtExistingCustomerList = salesSorecastingTool.GetExistingCustomerList(branchID, orderType);

    }

    #endregion
}
