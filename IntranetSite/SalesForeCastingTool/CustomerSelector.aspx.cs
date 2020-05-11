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



public partial class SalesForeCastingTool_CustomerSelector : System.Web.UI.Page
{
    SalesForecastingTool salesSorecastingTool = new SalesForecastingTool();
    private DataSet dsCustomerData = new DataSet();
    DataTable dtCustomerData = new DataTable();
    private DataTable dtTotal = new DataTable();
    private string branchID,orderType = "";
    private string keyColumn = "YTDSales";
    private string sortExpression = string.Empty;
    #region page events
    
    protected void Page_Load(object sender, EventArgs e)
    {
        branchID = Request.QueryString["Branch"].ToString();
        orderType = Request.QueryString["OrderType"].ToString();
        
        if (orderType.Trim() == "Mill")
            orderType = "m";
        else
            orderType = "w";

        lblMessage.Text = "";

        if (!Page.IsPostBack)
        {            
            lblHeaderBranch.Text = Request.QueryString["HeaderText"].ToString() + " Business";
            FillCASHeader();
            BindDataGrid();
        }
    }

    protected void dgCustomer_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        #region Header & Total Display
        
        if (e.Item.ItemType == ListItemType.Header)
        {
            lblYtdWgt.Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["YTDWgt"]) ;
            lblYTDSales.Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["YTDSales"]);
            lblSlsPerLb.Text = String.Format("{0:#,##0.00}", dtTotal.Rows[0]["SalesPerLb"]);
            lblYTDGM.Text = String.Format("{0:#,##0}", dtTotal.Rows[0]["YTDGM"]);
            lblGPPct.Text = String.Format("{0:#,##0.0}", dtTotal.Rows[0]["GPPct"]);

        }
        #endregion
    }

    protected void dgCustomer_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgCustomer.CurrentPageIndex = e.NewPageIndex;
        BindDataGrid();
        pnldgrid.Update();
    }

    protected void ProcessChkBox_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox chkSelect = (CheckBox)sender;
        DataGridItem container = (DataGridItem)chkSelect.NamingContainer;

        if (chkSelect.Checked)
            salesSorecastingTool.InsertCustomerForecastData(branchID, container.Cells[1].Text, orderType);
        else
            salesSorecastingTool.DeleteCustomerForecastData(branchID, container.Cells[1].Text, orderType);

        BindDataGrid();
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "", "document.getElementById('div-datagrid').scrollTop='" + hidScrollTop.Value + "'", true);

    }

    protected void ibtnClearAll_Click(object sender, ImageClickEventArgs e)
    {
        
        lblMessage.Text = "Data has been successfully cleared ..."; 
        salesSorecastingTool.ClearAllForecastData(branchID, orderType);
        
        pnlProgress.Update();
        BindDataGrid();
        pnldgrid.Update(); 
    }

    protected void ibtnAccept_Click(object sender, ImageClickEventArgs e)
    {
        lblMessage.Text = "Data has been successfully added..."; 
        salesSorecastingTool.UpdateCustomerList(branchID, orderType);
        
        BindDataGrid();
        pnldgrid.Update();
        pnlProgress.Update();
    }
   
    protected void btnSort_Click(object sender, EventArgs e)
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

        hidSort.Value = hidSortExpression.Value + " " + hidSort.Attributes["sortType"].ToString();
        BindDataGrid();
        pnldgrid.Update();
    }

    #endregion

    #region Developer Methods
            
    private void HighLightCheckBox()
    {
        DataTable dtExistingCustomerList = salesSorecastingTool.GetExistingCustomerList(branchID,orderType);

        if(dtExistingCustomerList.Rows.Count >0)
        {
            foreach (DataGridItem dgi in dgCustomer.Items)
            {
                CheckBox chkSelect = (CheckBox)dgi.FindControl("ProcessChkBox");
                dtExistingCustomerList.DefaultView.RowFilter = "customer='" + dgi.Cells[1].Text.Trim()  +"'";
                          
                if (dtExistingCustomerList.DefaultView.ToTable().Rows.Count >0)
                {
                    chkSelect.Checked = true;
                }
            }
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
        sortExpression = ((hidSort.Value != "") ? " ORDER BY  " + hidSort.Value : " ORDER BY " + keyColumn + " DESC");
        dsCustomerData = salesSorecastingTool.GetCustomerSalesData(branchID, orderType, sortExpression);
        dtTotal = dsCustomerData.Tables[0].DefaultView.ToTable();
        if (dtTotal.Rows.Count > 0)
        {
            GetTotal();

            dgCustomer.DataSource = dsCustomerData.Tables[0];
            dgCustomer.DataBind();
            HighLightCheckBox();
            pnldgrid.Update();
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
       
    #endregion

    
}
