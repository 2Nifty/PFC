#region Header
using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.IO;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.WOE.DataAccessLayer;
using PFC.WOE.BusinessLogicLayer;
using System.Data.SqlClient;
#endregion

namespace PFC.WOE
{
    public partial class WOPrintPage : System.Web.UI.Page
    {

        #region Page Local variables
        //SalesReportUtils salesReportUtils = new SalesReportUtils();
        //InvoiceAnalysis invoiceAnalysis = new InvoiceAnalysis();
        //PFC.WOE.Utility.Utility utility = new PFC.WOE.Utility.Utility();
        string erpConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

        private string sortExpression = string.Empty;
        private int pagesize = 22;     
        DataTable dtWorkorder = new DataTable();
        string _reportType = "";
        string _doctStNo = "";
        string _doctEndNo = "";
        string _docList = "";

        #endregion

        #region Page load event handler

        protected void Page_Load(object sender, EventArgs e)
        {
            //SystemCheck systemCheck = new SystemCheck();
            //systemCheck.SessionCheck();

            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(WOPrintPage));
            lblMessage.Text = "";

            _reportType = Request.QueryString["ReportType"].ToString();
            _doctStNo = Request.QueryString["DocStNo"].ToString();
            _doctEndNo = Request.QueryString["DocEndNo"].ToString();
            _docList = Request.QueryString["DocList"].ToString();

            if (!IsPostBack)
            {
                Session["PrintWordOrderNo"] = "";
                

                BindDataGrid(); 
            }

            BindPrintDialog();
           
        } 

        #endregion

        #region Developer Methods

        public void BindDataGrid()
        {
            dtWorkorder = GetWorkOrderList();

            if (dtWorkorder != null && dtWorkorder.Rows.Count > 0)
            {
                if (hidSort.Value != "")
                    dtWorkorder.DefaultView.Sort = hidSort.Value;

                dvWOList.DataSource = dtWorkorder.DefaultView.ToTable();
                dvWOList.DataBind();
                dvWOList.Visible = true;
                dvPager.InitPager(dvWOList, pagesize);
                divPager.Style.Add("display", "");
                lblStatus.Visible = false;
            }
            else
            {
                dvWOList.Visible = false;
                divPager.Style.Add("display","none");
                lblStatus.Visible = true;
                lblStatus.Text = "No Records Found";
            }
            pnlProgress.Update();
            upnlGrid.Update();           
        }

        public void BindPrintDialog()
        {
            PrintDialogue1.PageTitle = "Work Orders";
            string WorkOrderURL = "WorkOrderExport.aspx?WorkOrder=[DocNo]";
            PrintDialogue1.PageUrl = WorkOrderURL;
            PrintDialogue1.FormName = "WorkOrderExport";     
            
        }

        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public void SaveSelectedWorkOrders(string WorkOrderNo, bool chkSelectStatus)
        {
            try
            {
                // if the WorkOrder number is already in the session remove it first
                if (Session["PrintWordOrderNo"] != null)
                {
                    Session["PrintWordOrderNo"] = Session["PrintWordOrderNo"].ToString().Replace("," + WorkOrderNo, "");
                }
                if (chkSelectStatus)
                {
                    // Store the value in session to retore value after paging
                    Session["PrintWordOrderNo"] += "," + WorkOrderNo;
                }
            }
            catch (Exception ex)
            {
                
            }
        }
        #endregion

        #region  Event handler

        protected void Pager_PageChanged(Object sender, System.EventArgs e)
        {
            dvWOList.CurrentPageIndex = dvPager.GotoPageNumber;
            BindDataGrid();
        }

        protected void dvWOList_RowDataBound(object sender, DataGridItemEventArgs e)
        {
            if ((e.Item.ItemType == ListItemType.Item) || (e.Item.ItemType == ListItemType.AlternatingItem))
            {
                if (Session["PrintWordOrderNo"].ToString().Contains(e.Item.Cells[1].Text))
                {
                    CheckBox chkselect = e.Item.FindControl("chkSelect") as CheckBox;
                    chkselect.Checked = true;
                }
            }
        }

        protected void dvWOList_Sorting(object sender,  DataGridSortCommandEventArgs e)
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
        
        protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
        {
            //string strURL = "Sort=" + hidSort.Value +
            //                "&StartDate=" + cldStartDt.SelectedDate.ToShortDateString() +
            //                "&EndDate=" + cldEndDt.SelectedDate.ToShortDateString() +
            //                "&OrderType=" + Request.QueryString["OrderType"].ToString() +
            //                "&Branch=" + Request.QueryString["Branch"].ToString() +
            //                "&CustNo=" + Request.QueryString["CustNo"].ToString() +
            //                "&Chain=" + Request.QueryString["Chain"].ToString() +
            //                "&WeightFrom=" + Request.QueryString["WeightFrom"].ToString() +
            //                "&WeightTo=" + Request.QueryString["WeightTo"].ToString() +
            //                "&ShipToState=" + Request.QueryString["ShipToState"].ToString() +
            //                "&BranchDesc=" + Request.QueryString["BranchDesc"].ToString() +
            //                "&OrderTypeDesc=" + Request.QueryString["OrderTypeDesc"].ToString() +
            //                "&SalesPerson=" + Request.QueryString["SalesPerson"].ToString() +
            //                "&SalesRepNo=" + Request.QueryString["SalesRepNo"].ToString() +
            //                "&PriceCd=" + Request.QueryString["PriceCd"].ToString() +
            //                "&OrderSource=" + Request.QueryString["OrderSource"].ToString() +
            //                "&OrderSourceDesc=" + Request.QueryString["OrderSourceDesc"].ToString() +
            //                "&ShipMethod=" + Request.QueryString["ShipMethod"].ToString() +
            //                "&ShipMethodName=" + Request.QueryString["ShipMethodName"].ToString() +
            //                "&SubTotal=" + Request.QueryString["SubTotal"].ToString() +
            //                "&SubTotalDesc=" + Request.QueryString["SubTotalDesc"].ToString() +
            //                "&SubTotalFlag=" + Request.QueryString["SubTotalFlag"].ToString()+
            //                "&TerritoryCd=" + Request.QueryString["TerritoryCd"].ToString() +
            //                "&TerritoryDesc=" + Request.QueryString["TerritoryDesc"].ToString() +
            //                "&CSRName=" + Request.QueryString["CSRName"].ToString() +
            //                "&CSRNo=" + Request.QueryString["CSRNo"].ToString();

            //ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "PrintReport('" + strURL + "');", true);
        } 

        #endregion

        #region Data Access Methods

        private DataTable GetWorkOrderList()
        {
            try
            {
                DataSet dsResult = SqlHelper.ExecuteDataset(erpConnectionString, "pWOPrinting",
                                               new SqlParameter("@docNoStart", _doctStNo),
                                               new SqlParameter("@docNoEnd", _doctEndNo),
                                               new SqlParameter("@docNoList", _docList)
                                               );
                if (dsResult != null)
                {
                    return dsResult.Tables[0];
                }
                return null;
            }
            catch (Exception ex)
            {
                lblStatus.Visible = true;
                lblStatus.Text = ex.ToString();
                return null;
            }

        }
        
        #endregion

    }// End Class
}//End Namespace