using System;
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
using PFC.WOE;
using PFC.WOE.DataAccessLayer;

public partial class WOWorkSheetPreview : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

    DataUtility DataUtil = new DataUtility();
    
    DataSet dsWorkSheet = new DataSet();
    DataTable dtWorkSheet = new DataTable();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        string whereClause = "WHERE ";

        if (!string.IsNullOrEmpty(Request.QueryString["ActionStatus"].ToString()) && Request.QueryString["ActionStatus"].ToString().ToLower() != "all")
        {
            whereClause = whereClause + "ActionStatus = '" + Request.QueryString["ActionStatus"].ToString() + "'";
            lblActionStatus.Text = Request.QueryString["ActionStatus"].ToString();
        }
        else
        {
            lblActionStatus.Text = "ALL";
            //lblActionStatus.Text = "Ignore WorkOrder Line2345";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["PriorityCd"].ToString()) && Request.QueryString["PriorityCd"].ToString().ToLower() != "all")
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "PriorityCd = '" + Request.QueryString["PriorityCd"].ToString() + "'";
            lblPriorityCd.Text = Request.QueryString["PriorityCd"].ToString();
        }
        else
        {
            lblPriorityCd.Text = "ALL";
            //lblPriorityCd.Text = "Priority Code A1 2345 678";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["EntryID"].ToString()) && Request.QueryString["EntryID"].ToString().ToLower() != "all")
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "EntryID = '" + Request.QueryString["EntryID"].ToString() + "'";
            lblUser.Text = Request.QueryString["EntryID"].ToString();
        }
        else
        {
            lblUser.Text = "ALL";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["Branch"].ToString()) && Request.QueryString["Branch"].ToString().ToLower() != "all")
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "WOBranch = '" + Request.QueryString["Branch"].ToString() + "'";
            lblBranch.Text = Request.QueryString["BranchDesc"].ToString();
            //lblBranch.Text = "99 - Loc Name 12345 67890 1234";
        }
        else
        {
            lblBranch.Text = "ALL";
            //lblBranch.Text = "99 - Loc Name123456789012";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["Category"].ToString()))
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "LEFT(WOItemNo,5) = '" + Request.QueryString["Category"].ToString() + "'";
            lblCategory.Text = Request.QueryString["Category"].ToString();
        }
        else
        {
            lblCategory.Text = "ALL";
            //lblCategory.Text = "00020";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["Size"].ToString()))
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "SUBSTRING(WOItemNo,7,4) = '" + Request.QueryString["Size"].ToString() + "'";
            lblSize.Text = Request.QueryString["Size"].ToString();
        }
        else
        {
            lblSize.Text = "ALL";
            //lblSize.Text = "2800";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["Variance"].ToString()))
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "RIGHT(WOItemNo,3) = '" + Request.QueryString["Variance"].ToString() + "'";
            lblVariance.Text = Request.QueryString["Variance"].ToString();
        }
        else
        {
            lblVariance.Text = "ALL";
            //lblVariance.Text = "020";
        }

        dsWorkSheet = SqlHelper.ExecuteDataset(connectionString, "pWOSSetFilters", new SqlParameter("@whereClause", whereClause));

        if (dsWorkSheet.Tables[0].Rows.Count > 0)
        {
            BindDataGrid();
        }
    }

    private void BindDataGrid()
    {
        dtWorkSheet = dsWorkSheet.Tables[0];
        dtWorkSheet.DefaultView.Sort = (Request.QueryString["SortCommand"].ToString() == "") ? "ActionStatus ASC, WOItemNo ASC, PriorityCd ASC" : Request.QueryString["SortCommand"].ToString();
        dgWorkSheet.DataSource = dtWorkSheet.DefaultView.ToTable();
        dgWorkSheet.DataBind();
    }

    protected void dgWorkSheet_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.AlternatingItem || e.Item.ItemType == ListItemType.Item)
        {
            //Label _lblActionStatusGrid = e.Item.FindControl("lblActionStatusGrid") as Label;
            //_lblActionStatusGrid.Text = DataUtil.GetListDtlDesc("WOActions", dtWorkSheet.Rows[e.Item.DataSetIndex]["ActionStatus"].ToString());

            //Label _lblPriorityCdGrid = e.Item.FindControl("lblPriorityCdGrid") as Label;
            //_lblPriorityCdGrid.Text = DataUtil.GetShortDscFromTables(dtWorkSheet.Rows[e.Item.DataSetIndex]["PriorityCd"].ToString(), "TableType='PRI' AND WOApp='Y'");
        }
    }
}
