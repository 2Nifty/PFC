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

public partial class WOParentAltPackExport : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

    DataUtility DataUtil = new DataUtility();
    
    DataSet dsWorkSheet = new DataSet();
    DataTable dtWorkSheet = new DataTable();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        string ActionStatus = "";
        string PriorityCd = "";
        string EntryID = "";
        string WOBranch = "";
        string Category = "";
        string Size = "";
        string Variance = "";
        string AltVariance = "1";

        if (!string.IsNullOrEmpty(Request.QueryString["ActionStatus"].ToString()) && Request.QueryString["ActionStatus"].ToString().ToLower() != "all")
        {
            ActionStatus = Request.QueryString["ActionStatus"].ToString();
            lblActionStatus.Text = Request.QueryString["ActionStatus"].ToString();
        }
        else
        {
            lblActionStatus.Text = "ALL";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["PriorityCd"].ToString()) && Request.QueryString["PriorityCd"].ToString().ToLower() != "all")
        {
            PriorityCd = Request.QueryString["PriorityCd"].ToString();
            lblPriorityCd.Text = Request.QueryString["PriorityCd"].ToString();
        }
        else
        {
            lblPriorityCd.Text = "ALL";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["EntryID"].ToString()) && Request.QueryString["EntryID"].ToString().ToLower() != "all")
        {
            EntryID = Request.QueryString["EntryID"].ToString();
            lblUser.Text = Request.QueryString["EntryID"].ToString();
        }
        else
        {
            lblUser.Text = "ALL";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["Branch"].ToString()) && Request.QueryString["Branch"].ToString().ToLower() != "all")
        {
            WOBranch = Request.QueryString["Branch"].ToString();
            lblBranch.Text = Request.QueryString["BranchDesc"].ToString();
        }
        else
        {
            lblBranch.Text = "ALL";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["Category"].ToString()))
        {
            Category = Request.QueryString["Category"].ToString();
            lblCategory.Text = Request.QueryString["Category"].ToString();
        }
        else
        {
            lblCategory.Text = "ALL";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["Size"].ToString()))
        {
            Size = Request.QueryString["Size"].ToString();
            lblSize.Text = Request.QueryString["Size"].ToString();
        }
        else
        {
            lblSize.Text = "ALL";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["Variance"].ToString()))
        {
            Variance = Request.QueryString["Variance"].ToString();
            lblVariance.Text = Request.QueryString["Variance"].ToString();
        }
        else
        {
            lblVariance.Text = "ALL";
        }

        dsWorkSheet = SqlHelper.ExecuteDataset(connectionString, "pWOWorksheetAltItemList"
            , new SqlParameter("@ActionStatus", ActionStatus)
            , new SqlParameter("@PriorityCode", PriorityCd)
            , new SqlParameter("@UserID", EntryID)
            , new SqlParameter("@Branch", WOBranch)
            , new SqlParameter("@Category", Category)
            , new SqlParameter("@Size", Size)
            , new SqlParameter("@Variance", Variance)
            , new SqlParameter("@AltVariance", AltVariance)
            );

        if (dsWorkSheet.Tables[0].Rows.Count > 0)
        {
            BindDataGrid();
        }
    }

    private void BindDataGrid()
    {
        dtWorkSheet = dsWorkSheet.Tables[0];
        dtWorkSheet.DefaultView.Sort = (Request.QueryString["SortCommand"].ToString() == "") ? "ActionStatus ASC, FinishedItemNo ASC, PriorityCd ASC" : Request.QueryString["SortCommand"].ToString();
        dgWorkSheet.DataSource = dtWorkSheet.DefaultView.ToTable();
        dgWorkSheet.DataBind();
    }

}
