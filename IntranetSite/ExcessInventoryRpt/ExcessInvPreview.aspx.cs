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
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;

public partial class ExcessInvPreview : System.Web.UI.Page
{
    string strSQL;
    SqlConnection cnPFCReports = new SqlConnection(System.Configuration.ConfigurationManager.ConnectionStrings["PFCReportsConnectionString"].ConnectionString);

    DataUtility DataUtil = new DataUtility();

    DataSet dsExcessInv = new DataSet();
    DataTable dtExcessInv = new DataTable();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        string whereClause = "WHERE ";

        if (!string.IsNullOrEmpty(Request.QueryString["Branch"].ToString()) && Request.QueryString["Branch"].ToString().ToLower() != "all")
        {
            whereClause = whereClause + "Branch = '" + Request.QueryString["Branch"].ToString() + "'";
            lblLoc.Text = Request.QueryString["Branch"].ToString();
            if (!string.IsNullOrEmpty(Request.QueryString["BranchName"].ToString()))
                lblLoc.Text = Request.QueryString["BranchName"].ToString();
        }
        else
        {
            lblLoc.Text = "ALL";
            //lblLoc.Text = "80 - PFC International Direct";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["Type"].ToString()) && Request.QueryString["Type"].ToString().ToLower() != "all")
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "RecordType = '" + Request.QueryString["Type"].ToString() + "'";
            lblRecType.Text = Request.QueryString["Type"].ToString();
        }
        else
        {
            lblRecType.Text = "ALL";
            //lblRecType.Text = "BULK";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["Category"].ToString()))
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "LEFT(ItemNo,5) = '" + Request.QueryString["Category"].ToString() + "'";
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
            whereClause = whereClause + "SUBSTRING(ItemNo,7,4) = '" + Request.QueryString["Size"].ToString() + "'";
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
            whereClause = whereClause + "RIGHT(ItemNo,3) = '" + Request.QueryString["Variance"].ToString() + "'";
            lblVariance.Text = Request.QueryString["Variance"].ToString();
        }
        else
        {
            lblVariance.Text = "ALL";
            //lblVariance.Text = "020";
        }

        if (!string.IsNullOrEmpty(Request.QueryString["Min"].ToString()))
        {
            if (whereClause.ToString() != "WHERE ") whereClause = whereClause + " AND ";
            whereClause = whereClause + "ExcessQty >= " + Request.QueryString["Min"].ToString();
            lblMin.Text = Request.QueryString["Min"].ToString();
        }
        else
        {
            lblMin.Text = "0";
            //lblMin.Text = "99999.9999";
        }


        strSQL = "SELECT * FROM InventoryRptExcess (NoLock)";
        if (whereClause.ToString() != "WHERE ") strSQL = strSQL + whereClause;
        dsExcessInv = SqlHelper.ExecuteDataset(cnPFCReports, CommandType.Text, strSQL);

        if (dsExcessInv.Tables[0].Rows.Count > 0)
        {
            BindDataGrid();
        }
    }

    private void BindDataGrid()
    {
        dtExcessInv = dsExcessInv.Tables[0];
        dtExcessInv.DefaultView.Sort = (Request.QueryString["SortCommand"].ToString() == "") ? "ItemNo ASC, Branch ASC" : Request.QueryString["SortCommand"].ToString();
        dgExcessInv.DataSource = dtExcessInv.DefaultView.ToTable();
        dgExcessInv.DataBind();
    }
}
