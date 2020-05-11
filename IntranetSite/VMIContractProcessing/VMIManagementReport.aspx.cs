
/********************************************************************************************
 * File	Name			:	VMIManagementReport.aspx.cs
 * File Type			:	C#
 * Project Name			:	Vendor Managed Inventory
 * Module Description	:	Retrive Data From VMI_Contract_Management and VMI_Contract tables
 * Created By			:	A.Nithyapriyadarshini
 * Created Date			:	02/12/2007	
 * History				: 
 * DATE					VERSION			AUTHOR			            ACTION
 * ****					*******			******				        ******
 * 02/13/2007		    Version 1		A.Nithyapriyadarshini		Created 
  *********************************************************************************************/

#region Namespace

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
 
#endregion

public partial class VMIContractProcessing_VMIManagementReport : System.Web.UI.Page, INamingContainer
{

    #region Global variable declaration

    private string tableName = "VMI_Contract_Mngmt";
    private string displayColumns = "ItemNo,Branch,isnull(Loc_EAU_Qty,0) as Loc_EAU_Qty,isnull(Loc_EAU_30_Day_Qty,0) as Loc_EAU_30_Day_Qty,isnull(Act_30D_Use_Qty,0) as Act_30D_Use_Qty,isnull(Act_Forecast_Qty,0) as Act_Forecast_Qty,isnull(Tot_Brn_30D_Qty,0) as Tot_Brn_30D_Qty,isnull(Brn_Avail,0) as Brn_Avail,isnull(VMI_Res_Qty,0) as VMI_Res_Qty,isnull(VMI_Res_factor,0)  as VMI_Res_factor,isnull(VMI_Res_Need_Qty,0) as VMI_Res_Need_Qty,isnull(OO_Qty,0) as OO_Qty,convert(char(11),cast(Next_PO_Date as DateTime),101) as Next_PO_Date,isnull(Next_PO_Qty,0) as Next_PO_Qty,Next_PO_Status,isnull(Trans_Qty,0) as Trans_Qty,convert(char(11),cast(Next_Trans_Date as DateTime),101) as Next_Trans_Date,isnull(Next_Trans_Qty,0) as Next_Trans_Qty,isnull(Buy_factor,0)  as Buy_Factor,isnull(Buy_Qty,0) as Buy_Qty";
    private string strContractNo = string.Empty;
    private string whereCondition = string.Empty;
    private string strWhere = string.Empty;
    private string strPromptValues = string.Empty;
    private string strGridValues = string.Empty;
    private string strGridHeader = string.Empty;
    private string totalReport = string.Empty;
    private string strGridSpace = string.Empty;
    int pagesize = 1;
    DataTable dtReport = new DataTable();
    DataSet dsReport = new DataSet();

    #endregion

    #region Auto generated events

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        strContractNo = Request.QueryString["ContractNo"];
        string name = DateTime.Now.ToString().Replace("/", "");
        name = name.Replace(" ", "");
        name = name.Replace(":", "");
        if (ViewState["ExcelFileName"] == null || ViewState["ExcelFileName"] == "")
            ViewState["ExcelFileName"] = "VMIManagementReport" + Session["SessionID"].ToString() + name + ".xls";
        Ajax.Utility.RegisterTypeForAjax(typeof(VMIContractProcessing_VMIManagementReport));
        if (!IsPostBack)
        {
            BindDataToDataGrid();
            CreateExcelString();
            ExcelExport();
        }

    }
    override protected void OnInit(EventArgs e)
    {
        //
        // CODEGEN: This call is required by the ASP.NET Web Form Designer.
        //
        InitializeComponent();
        base.OnInit(e);
    }

    private void InitializeComponent()
    {
        this.Load += new System.EventHandler(this.Page_Load);
        this.dgReport.PageIndexChanged += new System.Web.UI.WebControls.DataGridPageChangedEventHandler(this.dgReport_PageIndexChanged);
        this.Pager1.BubbleClick += new EventHandler(this.Pager_PageChanged);
    }
    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgReport.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataToDataGrid();
    }

    protected void dgReport_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgReport.CurrentPageIndex = e.NewPageIndex;
        BindDataToDataGrid();

    }

    protected void dgReport_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Label lblChain = e.Item.FindControl("lblCusChain") as Label;
            Label lblContract = e.Item.FindControl("lblContract") as Label;
            Label lblItem = e.Item.FindControl("lblPFCItemNo") as Label;
            Label lblPhone = e.Item.FindControl("lblPhone") as Label;
            Label lblStatus = e.Item.FindControl("lblStatus") as Label;
            DataGrid dgContract = e.Item.FindControl("dgContract") as DataGrid;

            string strPhone = lblPhone.Text;
            if (strPhone != "")
                lblPhone.Text = ((strPhone.Length == 10) ?

                        ("(" + strPhone.Substring(0, 3) + ")" + " " + strPhone.Substring(3, 3) + "-" + strPhone.Substring(6, 4)) :
                        (strPhone.Substring(0, 1) + "-" + strPhone.Substring(1, 3) + "-" + strPhone.Substring(4, 3) + "-" + strPhone.Substring(7, 4)));
            else
                lblPhone.Text = "";

            if (Request.QueryString["mode"].Trim() == "BuyExceptions")
                strWhere = "ContractNo='" + lblContract.Text + "' and Chain='" + lblChain.Text + "' and ItemNo='" + lblItem.Text + "' and Buy_Exceptions=1";
            else
                strWhere = "ContractNo='" + lblContract.Text + "' and Chain='" + lblChain.Text + "' and ItemNo='" + lblItem.Text + "'";

            DataSet dsContract = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[ugen_sp_select]",
                new SqlParameter("@tableName", tableName),
                new SqlParameter("@displayColumns", displayColumns),
                new SqlParameter("@whereCondition", strWhere));

            dgContract.DataSource = dsContract.Tables[0];
            dgContract.DataBind();
            lblStatus.Text = "No Records Found";
            lblStatus.Visible = (dgContract.Items.Count < 1) ? true : false;
        }

    }

    protected void dgContract_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Header)
        {
            e.Item.Cells[0].Text = "<table border='0'  cellpadding='0' cellspacing='0' width='60'><tr><td class='splitBorder PageBg'>&nbsp;</td></tr><tr><td align='center' >Location</td></tr></table>";
            e.Item.Cells[1].ColumnSpan = 2;
            e.Item.Cells[1].Text = "<table border='0'  cellpadding='0' cellspacing='0' width='100%'><tr><td class='splitBorder PageBg' colspan=2 nowrap >ESTIMATED ANNUAL USAGE</td></tr><tr><td  width='70' class='GridBorder' nowrap><center>&nbsp;Annual QTY</center></td><td  width='65' nowrap class='GridBorder' align='center'>30 Day</td></tr></table>";
            e.Item.Cells[2].Visible = false;
            e.Item.Cells[3].ColumnSpan = 2;
            e.Item.Cells[3].Text = "<table border='0'  cellpadding='0' cellspacing='0' width='100%'><tr><td class='splitBorder PageBg' colspan=2 align='center' nowrap>ACTUAL USAGE</td></tr><tr><td  nowrap width='70'class='GridBorder'align='center'>30 Day</td><td  nowrap width='70' class='GridBorder' align='center'>Forecast</td></tr></table>";
            e.Item.Cells[4].Visible = false;
            e.Item.Cells[5].Text = "<table border='0'  cellpadding='0' cellspacing='0' width='60'><tr><td class='splitBorder PageBg' nowrap><center>TOT BRN</center></td></tr><tr><td  nowrap width='60' align='center'>30 Day</td></tr></table>";
            e.Item.Cells[6].Text = "<table border='0'  cellpadding='0' cellspacing='0' width='50'><tr><td class='splitBorder PageBg' nowrap><center>BRN</center></td></tr><tr><td  width='50' nowrap align='center'>Avail</td></tr></table>";
            e.Item.Cells[7].Text = "<table border='0'  cellpadding='0' cellspacing='0' width='70'><tr><td class='splitBorder PageBg' nowrap><center>VMI</center></td></tr><tr><td  width='70' nowrap align='center'>Res QTY</td></tr></table>";
            e.Item.Cells[8].Text = "<table border='0'  cellpadding='0' cellspacing='0' width='50'><tr><td class='splitBorder PageBg' nowrap><center>RES</center></td></tr><tr><td  width='50' nowrap align='center'>Factor</td></tr></table>";
            e.Item.Cells[9].Text = "<table border='0'  cellpadding='0' cellspacing='0' width='70'><tr><td class='splitBorder PageBg' nowrap><center>VMI</center></td></tr><tr><td   width='70' nowrap align='center'>Res Need</td></tr></table>";
            e.Item.Cells[10].Text = "<table border='0'  cellpadding='0' cellspacing='0' width='70'><tr><td class='splitBorder PageBg' nowrap><center>QTY</center></td></tr><tr><td  width='70' nowrap align='center'>On Order</td></tr></table>";
            e.Item.Cells[11].ColumnSpan = 3;
            e.Item.Cells[11].Text = "<table border='0'  cellpadding='0' cellspacing='0' width='200'><tr><td class='splitBorder PageBg' colspan=3 nowrap><center>NEXT PO</center></td></tr><tr><td  width='96' nowrap class='GridBorder' align='center'>Date</td><td  width='58' class='GridBorder' nowrap align='center'>QTY</td><td  width='38' align='center'>STS</td></tr></table>";
            e.Item.Cells[12].Visible = false;
            e.Item.Cells[13].Visible = false;
            e.Item.Cells[14].Text = "<table border='0'  cellpadding='0' cellspacing='0' width='40'><tr><td class='splitBorder PageBg' nowrap><center>TRANS</center></td></tr><tr><td  width='40' nowrap align='center'>QTY</td></tr></table>";
            e.Item.Cells[15].ColumnSpan = 2;
            e.Item.Cells[15].Text = "<table border='0'  cellpadding='0' cellspacing='0' width='100%'><tr><td class='splitBorder PageBg' colspan=2 nowrap><center>NEXT TRANS</center></td></tr><tr><td  width='100' nowrap class='GridBorder'align='center'>Date</td><td  width='60' nowrap class='GridBorder' align='center'>QTY</td></tr></table>";
            e.Item.Cells[16].Visible = false;
            e.Item.Cells[17].Text = "<table border='0'  cellpadding='0' cellspacing='0' width='60'><tr><td class='splitBorder PageBg' nowrap><center>BUY</center></td></tr><tr><td  width='60' nowrap align='center'>Factor</td></tr></table>";
            e.Item.Cells[18].Text = "<table border='0'  cellpadding='0' cellspacing='0' width='100%'><tr><td class='splitBorder PageBg'  nowrap><center>BUY</center></td></tr><tr><td  width='40' nowrap align='center'>QTY</td></tr></table>";
            for (int i = 0; i <= 18; i++)
                e.Item.Cells[i].VerticalAlign = VerticalAlign.Top;
        }

    } 

    #endregion

    #region Developer generated code

    private void GetDataGridFormat(DataTable dtGridDatas)
    {
        strGridValues = "";
        strGridHeader = "<tr class='GridHead' align='left'><td valign='top'><table border='0'  cellpadding='0' cellspacing='0' width='60'><tr style='border-bottom-width: 1px;border-bottom-style: solid;border-bottom-color: #000000;'><td class='splitBorder PageBg'>&nbsp;</td></tr><tr><td align='center' >Location</td></tr></table></td><td valign='top' colspan='2'><table border='0'  cellpadding='0' cellspacing='0' width='100%'><tr style='border-bottom-width: 1px;border-bottom-style: solid;border-bottom-color: #000000;'><td class='splitBorder PageBg'  align='center' colspan='2' nowrap><b>ESTIMATED ANNUAL USAGE</b></td></tr><tr><td  width='85' class='GridBorder' nowrap align='center' style='border-right-width: thin;border-right-style: solid;'>Annual QTY</td><td  width='50' nowrap class='GridBorder' align='center'>30 Day</td></tr></table></td><td valign='top' colspan='2'><table border='0'  cellpadding='0' cellspacing='0' width='100%'><tr style='border-bottom-width: 1px;border-bottom-style: solid;border-bottom-color: #000000;'><td class='splitBorder PageBg' colspan=2 align='center' nowrap><b>ACTUAL USAGE</b></td></tr><tr><td  nowrap width='70'class='GridBorder'align='center' style='border-right-width: thin;border-right-style: solid;'>30 Day</td><td  nowrap width='70' class='GridBorder' align='center'>Forecast</td></tr></table></td><td valign='top'><table border='0'  cellpadding='0' cellspacing='0' width='60'><tr style='border-bottom-width: 1px;border-bottom-style: solid;border-bottom-color: #000000;'><td class='splitBorder PageBg' nowrap><center><b>TOT BRN</b></center></td></tr><tr><td  nowrap width='60' align='center'>30 Day</td></tr></table></td><td valign='top'><table border='0'  cellpadding='0' cellspacing='0' width='50'><tr style='border-bottom-width: 1px;border-bottom-style: solid;border-bottom-color: #000000;'><td class='splitBorder PageBg' nowrap><center><b>BRN</b></center></td></tr><tr><td  width='50' nowrap align='center'>Avail</td></tr></table></td><td valign='top'><table border='0'  cellpadding='0' cellspacing='0' width='70'><tr style='border-bottom-width: 1px;border-bottom-style: solid;border-bottom-color: #000000;'><td class='splitBorder PageBg' nowrap><center><b>VMI</b></center></td></tr><tr><td  width='70' nowrap align='center'>Res QTY</td></tr></table></td><td valign='top'><table border='0'  cellpadding='0' cellspacing='0' width='50'><tr style='border-bottom-width: 1px;border-bottom-style: solid;border-bottom-color: #000000;'><td class='splitBorder PageBg' nowrap><center><b>RES</b></center></td></tr><tr><td  width='50' nowrap align='center'>Factor</td></tr></table></td><td valign='top'><table border='0'  cellpadding='0' cellspacing='0' width='70'><tr style='border-bottom-width: 1px;border-bottom-style: solid;border-bottom-color: #000000;'><td class='splitBorder PageBg' nowrap><center><b>VMI</b></center></td></tr><tr><td   width='70' nowrap align='center'>Res Need</td></tr></table></td><td valign='top'><table border='0'  cellpadding='0' cellspacing='0' width='70'><tr style='border-bottom-width: 1px;border-bottom-style: solid;border-bottom-color: #000000;'><td class='splitBorder PageBg' nowrap><center><b>QTY</b></center></td></tr><tr><td  width='70' nowrap align='center'>On Order</td></tr></table></td><td valign='top' colspan='3'><table border='0'  cellpadding='0' cellspacing='0' width='200'><tr style='border-bottom-width: 1px;border-bottom-style: solid;border-bottom-color: #000000;'><td class='splitBorder PageBg' colspan=3 nowrap><center><b>NEXT PO</b></center></td></tr><tr><td  width='96' nowrap class='GridBorder' align='center' style='border-right-width: thin;border-right-style: solid;'>Date</td><td  width='58' class='GridBorder' nowrap align='center' style='border-right-width: thin;border-right-style: solid;'>QTY</td><td  width='38' align='center'>STS</td></tr></table></td><td valign='top'><table border='0'  cellpadding='0' cellspacing='0' width='40'><tr style='border-bottom-width: 1px;border-bottom-style: solid;border-bottom-color: #000000;'><td class='splitBorder PageBg' nowrap><center><b>TRANS</b></center></td></tr><tr><td  width='40' nowrap align='center'>QTY</td></tr></table></td><td valign='top' colspan='2'><table border='0'  cellpadding='0' cellspacing='0' width='100%'><tr style='border-bottom-width: 1px;border-bottom-style: solid;border-bottom-color: #000000;'><td class='splitBorder PageBg' colspan=2 nowrap><center><b>NEXT TRANS</b></center></td></tr><tr><td  width='100' nowrap class='GridBorder'align='center' style='border-right-width: thin;border-right-style: solid;'>Date</td><td  width='60' nowrap class='GridBorder' align='center'>QTY</td></tr></table></td><td valign='top'><table border='0'  cellpadding='0' cellspacing='0' width='60'><tr style='border-bottom-width: 1px;border-bottom-style: solid;border-bottom-color: #000000;'><td class='splitBorder PageBg' nowrap><center><b>BUY</b></center></td></tr><tr><td  width='60' nowrap align='center'>Factor</td></tr></table></td><td valign='top'><table border='0'  cellpadding='0' cellspacing='0' width='100%'><tr style='border-bottom-width: 1px;border-bottom-style: solid;border-bottom-color: #000000;'><td class='splitBorder PageBg'  nowrap><center><b>BUY</b></center></td></tr><tr><td  width='40' nowrap align='center'>QTY</td></tr></table></td></tr>";
        if (dtGridDatas.Rows.Count != 0)
        {
            foreach (DataRow drow in dtGridDatas.Rows)
            {
                strGridValues += "<tr class='GridItem' nowrap='nowrap' style='background-color:White;'><td align='right' style='width:60px;'>" + drow["Branch"] + "</td><td nowrap='nowrap' align='right' style='width:78px;'>" + String.Format("{0:#,###0}", drow["Loc_EAU_Qty"]) + "</td><td nowrap='nowrap' align='right' style='width:70px;'>" + String.Format("{0:#,###0}", drow["Loc_EAU_30_Day_Qty"]) + "</td><td nowrap='nowrap' align='right' style='width:70px;'>" + String.Format("{0:#,###0}", drow["Act_30D_Use_Qty"]) + "</td><td nowrap='nowrap' align='right' style='width:70px;'>" + String.Format("{0:#,###0}", drow["Act_Forecast_Qty"]) + "</td><td align='right' style='width:60px;'>" + String.Format("{0:#,###0}", drow["Tot_Brn_30D_Qty"]) + "</td><td align='right' style='width:50px;'>" + String.Format("{0:#,###0}", drow["Brn_Avail"]) + "</td><td align='right' style='width:70px;'>" + String.Format("{0:#,###0}", drow["VMI_Res_Qty"]) + "</td><td align='right' style='width:50px;'>" + String.Format("{0:0.0}", drow["VMI_Res_factor"]) + "</td><td align='right' style='width:70px;'>" + String.Format("{0:#,###0}", drow["VMI_Res_Need_Qty"]) + "</td><td align='right' style='width:70px;'>" + String.Format("{0:#,###0}", drow["OO_Qty"]) + "</td><td align='right' style='width:100px;'>" + drow["Next_PO_Date"] + "</td><td align='right' style='width:60px;'>" + String.Format("{0:#,###0}", drow["Next_PO_Qty"]) + "</td><td align='right' style='width:40px;'>" + drow["Next_PO_Status"] + "</td><td align='right' style='width:60px;'>" + String.Format("{0:#,###0}", drow["Trans_Qty"]) + "</td><td align='right' style='width:100px;'>" + drow["Next_Trans_Date"] + "</td><td align='right' style='width:60px;'>" + String.Format("{0:#,###0}", drow["Next_Trans_Qty"]) + "</td><td align='right' style='width:60px;'>" + String.Format("{0:0.0}", drow["Buy_Factor"]) + "</td><td align='right' style='width:40px;'>" + String.Format("{0:#,###0}", drow["Buy_Qty"]) + "</td></tr>";
            }
        }
        else
            strGridValues += "<tr  ><td align='center' colspan='19' style='font-family: Arial, Helvetica, sans-serif;	font-size: 12px;	color: #CC0000;	font-weight: bold;	padding-left: 10px;	border-right-width: 1px;	border-right-style: solid;	border-right-color: #CEEAF4;'>No Records Found</td></tr>";
        strGridSpace = "<tr colspan='19'></tr>";
    }

    private void BindDataToDataGrid()
    {
        try
        {

            whereCondition = "ContractNo='" + strContractNo + "' and Chain='" + Request.QueryString["ChainName"].Replace("||", "&").ToString() + "'";

            dsReport = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[ugen_sp_select]",
                new SqlParameter("@tableName", "VMI_Contract"),
                new SqlParameter("@displayColumns", "ContractNo,Chain,ItemNo,ItemDesc,SubItemNo,CrossRef,round(E_Profit_Pct*100,1) as E_Profit_Pct,convert(varchar,cast((cast(isnull(ContractPrice,0) as decimal(25,2))) as money),1) as ContractPrice,replace(convert(varchar,cast((cast(isnull(EAU_Qty,0) as bigint)) as money),1),'.00','') as EAU_Qty,convert(char(11),cast(StartDate as DateTime),101) as StartDate,convert(char(11),cast(EndDate as DateTime),101) as EndDate,Salesperson,OrderMethod,Vendor,Contact,ContactPhone, cast(isnull(MonthFactor,0) as decimal(25,1)) as MonthFactor,Closed,CustomerPO"),
                new SqlParameter("@whereCondition", whereCondition));
            dtReport = dsReport.Tables[0];
            dgReport.DataSource = dtReport;
            //dgReport.DataBind();
            Pager1.InitPager(dgReport, pagesize);



        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
    }

    private void GetTableFormat(DataRow dr)
    {
        string strPhone = dr["ContactPhone"].ToString();
        if (strPhone != "")
            dr["ContactPhone"] = ((strPhone.Length == 10) ?

                    ("(" + strPhone.Substring(0, 3) + ")" + " " + strPhone.Substring(3, 3) + "-" + strPhone.Substring(6, 4)) :
                    (strPhone.Substring(0, 1) + "-" + strPhone.Substring(1, 3) + "-" + strPhone.Substring(4, 3) + "-" + strPhone.Substring(7, 4)));
        else
            dr["ContactPhone"] = "";
        strPromptValues = "<tr><th align='left'>" + "CHAIN NAME :</th><td align='left' colspan='18'>" + dr["Chain"] + "</td></tr>" +
            "<tr><th align='left'>" + "CONTRACT # :</th><td align='left' colspan='18'>" + dr["ContractNo"] + "</td></tr>" +
            "<tr><th align='left'>" + "START DATE :</th><td align='left' colspan='18'>" + dr["StartDate"] + "</td></tr>" +
            "<tr><th align='left'>" + "END DATE :</th><td align='left' colspan='18'>" + dr["EndDate"] + "</td></tr>" +
            "<tr><th align='left'>" + "PFC ITEM # :</th><td align='left' colspan='18'>" + dr["ItemNo"] + " " + dr["ItemDesc"] + "</td></tr>" +
            "<tr><th align='left'>" + "CROSS REF # :</th><td align='left'>" + dr["CrossRef"] + "</td><th align='left'>" + "CUSTOMER PO :</th><td align='left' colspan='16'>" + dr["CustomerPO"] + "</td></tr>" +
            "<tr><th align='left'>" + "SUB ITEM # :</th><td align='left'>" + dr["SubItemNo"] + "</td><th align='left'>" + "PFC SALES PERSON :</th><td align='left' colspan='16'>" + dr["SalesPerson"] + "</td></tr>" +
            "<tr><th align='left'>" + "ANNUAL USAGE QTY :</th><td align='left'>" + dr["EAU_Qty"] + "</td><th align='left'>" + "CONTACT :</th><td align='left' colspan='16'>" + dr["Contact"] + "</td></tr>" +
            "<tr><th align='left'>" + "PRICE PER UOM :</th><td align='left'>" + String.Format("{0:#,###.00}", Convert.ToDecimal(dr["ContractPrice"].ToString())) + "</td><th align='left'>" + "CONTACT PH# :</th><td align='left' colspan='16'>" + dr["ContactPhone"] + "</td></tr>" +
            "<tr><th align='left'>" + "EXPECTED GP :</th><td align='left'>" + dr["E_Profit_Pct"] + "</td><th align='left'>" + "ORDER METHOD :</th><td align='left' colspan='16'>" + dr["OrderMethod"] + "</td></tr>" +
            "<tr><th align='left'>" + "VENDOR CODE :</th><td align='left'>" + dr["Vendor"] + "</td><th align='left'>" + "MONTH FACTOR :</th><td align='left' colspan='16'>" + String.Format("{0:#,###.0}", Convert.ToDecimal(dr["MonthFactor"].ToString())) + "</td></tr>";


    }

    protected string GetFileURL()
    {
        string url = "../Common/ExcelUploads/" + ViewState["ExcelFileName"].ToString();
        return url;
    } 

    #endregion
    
    #region Write to Excel

    private void CreateExcelString()
    {
        string strWhereCon = string.Empty;
        //
        // Create Excel File
        // 
        if (Request.QueryString["mode"].Trim() == "BuyExceptions")
            strWhereCon = whereCondition + " and Buy_Exceptions=1";
        else
            strWhereCon = whereCondition;

        DataSet dsItemContract = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[ugen_sp_select]",
            new SqlParameter("@tableName", tableName),
            new SqlParameter("@displayColumns", displayColumns),
            new SqlParameter("@whereCondition", strWhereCon));


        foreach (DataRow dr in dtReport.Rows)
        {
            GetTableFormat(dr);
            dsItemContract.Tables[0].DefaultView.RowFilter = "ItemNo='" + dr["ItemNo"].ToString() + "'";
            GetDataGridFormat(dsItemContract.Tables[0].DefaultView.ToTable());
            totalReport = totalReport + strPromptValues + strGridHeader + strGridValues + strGridSpace;

        }
    }

    protected void ExcelExport()
    {
        try
        {
            CreateExcel(ViewState["ExcelFileName"].ToString());

        }
        catch (Exception ex) { Response.Write(ex.ToString()); }
    }

    private void CreateExcel(string fileName)
    {
        FileInfo fnExcel = new FileInfo(Server.MapPath("..//Common//ExcelUploads//" + fileName));
        StreamWriter reportWriter;
        reportWriter = fnExcel.CreateText();
        reportWriter.WriteLine("<table cellpadding=5 cellspacing=5 border=2px>");
        reportWriter.WriteLine("<tr><th colspan=19><font size=15px color=blue><b>VMI Management Report</b></font></th></tr>");
        reportWriter.WriteLine(totalReport);
        reportWriter.WriteLine("</table>");
        reportWriter.Close();


    }

    #endregion

    #region Ajax Function To Delete The Excel Files

    [Ajax.AjaxMethod()]
    public string DeleteExcel(string strSession)
    {
        try
        {

            DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\Common\\ExcelUploads"));

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
