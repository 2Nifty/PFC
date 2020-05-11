
/********************************************************************************************
 * File	Name			:	ContractList.aspx.cs
 * File Type			:	C#
 * Project Name			:	Vendor Managed Inventory
 * Module Description	:	Retrive Data From VMI_Contract tables
 * Created By			:	A.Nithyapriyadarshini
 * Created Date			:	02/12/2007	
 * History				: 
 * DATE					VERSION			AUTHOR			            ACTION
 * ****					*******			******				        ******
 * 02/12/2007		    Version 1		A.Nithyapriyadarshini		Created 
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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
using PFC.Intranet.Securitylayer;
using PFC.Intranet.Utility;   

#endregion

public partial class VMIContractProcessing_ContractList : System.Web.UI.Page,INamingContainer
{

    #region Global variable declaration

    private string tableName = "VMI_Contract";
    private string displayColumns = "distinct ContractNo,Chain,CustomerPO";
    private string strCustChainNo = string.Empty;
    private string whereCondition = string.Empty;
    private string keyColumn = "ContractNo";
    int pagesize = 20;
    DataTable dtAnalysis = new DataTable();
    DataSet dsAnalysis = new DataSet();
    Utility utility = new Utility();
    #endregion

    #region Auto genereated events

    protected void Page_Load(object sender, EventArgs e)
    {
        utility.CheckBrowserCompatibility(Request, dgAnalysis, ref pagesize);
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();

        strCustChainNo = Request.QueryString["CustCatNo"].Replace("||","&");
        
        if(!IsPostBack)
            BindDataToDataGrid();
    }

    protected void Pager_PageChanged(Object sender, System.EventArgs e)
    {
        dgAnalysis.CurrentPageIndex = Pager1.GotoPageNumber;
        BindDataToDataGrid();
    }

    protected void dgAnalysis_PageIndexChanged(object source, System.Web.UI.WebControls.DataGridPageChangedEventArgs e)
    {
        //Set the page no and Rebind data grid
        dgAnalysis.CurrentPageIndex = e.NewPageIndex;
        BindDataToDataGrid();
    }    

    protected void dgAnalysis_SortCommand(object source, DataGridSortCommandEventArgs e)
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
        BindDataToDataGrid();

    }

    protected void dgAnalysis_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            string vmiURL = Global.IntranetSiteURL + "VMIContractProcessing/VMIManagementReport.aspx?ContractNo=" + e.Item.Cells[0].Text + "&ChainName=" + e.Item.Cells[1].Text + "&CustomerPO=" + e.Item.Cells[2].Text + "&mode=Contract";
            HyperLink hplButton = new HyperLink();
            hplButton.Text = "View Contract";
            hplButton.NavigateUrl = vmiURL;
            hplButton.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'popupwindow', 'height=705,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");
            e.Item.Cells[e.Item.Cells.Count - 2].Controls.Add(hplButton);
            e.Item.Cells[e.Item.Cells.Count - 2].CssClass = "GridItemLink";

            vmiURL = Global.IntranetSiteURL + "VMIContractProcessing/VMIManagementReport.aspx?ContractNo=" + e.Item.Cells[0].Text + "&ChainName=" + e.Item.Cells[1].Text + "&CustomerPO=" + e.Item.Cells[2].Text + "&mode=BuyExceptions";
            HyperLink hplButton1 = new HyperLink();
            hplButton1.Text = "View Exceptions";
            hplButton1.ForeColor = System.Drawing.Color.Blue;
            hplButton1.NavigateUrl = vmiURL;
            hplButton1.Attributes.Add("onclick", "var hWnd=window.open(this.href, 'popupwindow', 'height=705,width=1020,scrollbars=no,status=no,top='+((screen.height/2) - (760/2))+',left='+((screen.width/2) - (1020/2))+',resizable=YES'); hWnd.opener = self; if (window.focus) {hWnd.focus()} return false;");
            e.Item.Cells[e.Item.Cells.Count - 1].Controls.Add(hplButton1);
            e.Item.Cells[e.Item.Cells.Count - 1].CssClass = "GridItemLink";
        }

    }

    #endregion

    #region Developer generated code

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
        this.Pager1.BubbleClick += new EventHandler(this.Pager_PageChanged);
    }

    private void BindDataToDataGrid()
    {
        try
        {

            whereCondition = "Chain='" + strCustChainNo + "'";
            string sortExpression = ((hidSort.Value != "") ? " ORDER BY  " + hidSort.Value : " ORDER BY " + keyColumn);
            dsAnalysis = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[ugen_sp_select]",
                        new SqlParameter("@tableName", tableName),
                        new SqlParameter("@displayColumns", displayColumns),
                        new SqlParameter("@whereCondition", whereCondition + sortExpression));
            dtAnalysis = dsAnalysis.Tables[0];
            dgAnalysis.DataSource = dtAnalysis;
            dgAnalysis.DataBind();
            Pager1.InitPager(dgAnalysis, pagesize);
            lblStatus.Text = "No Records Found";
            lblStatus.Visible = (dgAnalysis.Items.Count < 1) ? true : false;

        }
        catch (Exception ex)
        {
            Response.Write(ex.Message);
        }
    }

    #endregion
      
}
