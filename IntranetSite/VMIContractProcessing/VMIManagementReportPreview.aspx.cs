
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

public partial class VMIContractProcessing_VMIManagementReportPreview : System.Web.UI.Page
{

    #region Global variable declaration

    private string tableName = "VMI_Contract_Mngmt";
    private string displayColumns = "Branch,isnull(Loc_EAU_Qty,0) as Loc_EAU_Qty,isnull(Loc_EAU_30_Day_Qty,0) as Loc_EAU_30_Day_Qty,isnull(Act_30D_Use_Qty,0) as Act_30D_Use_Qty,isnull(Act_Forecast_Qty,0) as Act_Forecast_Qty,isnull(Tot_Brn_30D_Qty,0) as Tot_Brn_30D_Qty,isnull(Brn_Avail,0) as Brn_Avail,isnull(VMI_Res_Qty,0) as VMI_Res_Qty,isnull(VMI_Res_factor,0)  as VMI_Res_factor,isnull(VMI_Res_Need_Qty,0) as VMI_Res_Need_Qty,isnull(OO_Qty,0) as OO_Qty,convert(char(11),cast(Next_PO_Date as DateTime),101) as Next_PO_Date,isnull(Next_PO_Qty,0) as Next_PO_Qty,Next_PO_Status,isnull(Trans_Qty,0) as Trans_Qty,convert(char(11),cast(Next_Trans_Date as DateTime),101) as Next_Trans_Date,isnull(Next_Trans_Qty,0) as Next_Trans_Qty,isnull(Buy_factor,0)  as Buy_Factor,isnull(Buy_Qty,0) as Buy_Qty";
    private string strContractNo = string.Empty;
    private string whereCondition = string.Empty;
    private string strWhere = string.Empty;
    private string strPromptValues = string.Empty;
    private string strGridValues = string.Empty;
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
        ViewState["ExcelFileName"] = "VMIManagementReport" + Session["SessionID"].ToString() + name + ".xls";
        if (!IsPostBack)
        {
            BindDataToDataGrid();
        }
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
            dgReport.DataBind();
        }
        catch (Exception ex)
        {

        }
    } 

    #endregion
    
    
}
