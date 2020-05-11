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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;


public partial class RebateExport : System.Web.UI.Page
{
    string noRecordMessage = "No Records Found";

    PartnerRebate rebate = new PartnerRebate();
    DataTable dtRebate = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            lblProgram.Text = Request.QueryString["Program"].ToString();
            lblChainCustNo.Text = Request.QueryString["ChainNo"].ToString();
            lblCustName.Text = Request.QueryString["CustName"].ToString();
            lblStartDate.Text = Request.QueryString["Start"].ToString();
            lblEndDate.Text = Request.QueryString["End"].ToString();
            BindGridRebate();
        }
    }

    private void BindGridRebate()
    {
        string whereClause = Request.QueryString["Where"].ToString().Replace ("`","'");

        dtRebate = rebate.GetData(whereClause);

        if (dtRebate == null || dtRebate.Rows.Count == 0  )

        {
            rebate.DisplayMessage(MessageType.Failure, noRecordMessage, lblMessage);
            
        }
        else
        {
            gvRebate.DataSource = dtRebate;
            gvRebate.DataBind();
       
        }
        upnlGrid.Update();

    }


    protected void gvRebate_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Footer)
        {
            e.Item.Cells[0].Text = "Total:";
            e.Item.Cells[2].Text = String.Format("{0: ###,##0.00}", dtRebate.Compute("sum(SalesHistory)", ""));
            e.Item.Cells[3].Text = String.Format("{0:###,##0.00}", dtRebate.Compute("sum(SalesBaseline)", ""));
            e.Item.Cells[4].Text = String.Format("{0:###,##0.00}", dtRebate.Compute("sum(SalesGoal)", ""));
        }
    }
}
