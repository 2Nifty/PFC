using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Collections.Specialized;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.SOE.DataAccessLayer;

public partial class SSItemList : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        string Cat = "";
        string Size = "";
        string Var = "";
        NameValueCollection coll = Request.QueryString;
        if (coll["Cat"] != null && coll["Cat"].ToString().Length > 0)
        {
            Cat = coll["Cat"].ToString().Replace("?", "_");
            CatTextBox.Text = coll["Cat"].ToString();
        }
        if (coll["Size"] != null && coll["Size"].ToString().Length > 0)
        {
            Size = coll["Size"].ToString().Replace("?", "_");
            SizeTextBox.Text = coll["Size"].ToString();
        }
        if (coll["Var"] != null && coll["Var"].ToString().Length > 0)
        {
            Var = coll["Var"].ToString().Replace("?", "_");
            VarTextBox.Text = coll["Var"].ToString();
        }
        // get the items.
        ds = SqlHelper.ExecuteDataset(connectionString, "pSSSearchItems",
            new SqlParameter("@SearchCat", Cat),
            new SqlParameter("@SearchSize", Size),
            new SqlParameter("@SearchVar", Var));
        if (ds.Tables.Count >= 1)
        {
            if (ds.Tables.Count == 1)
            {
                // We only go one table back, something is wrong
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    ShowPageMessage("Item not found.", 2);
                }
            }
            else
            {
                dt = ds.Tables[1];
                if (dt.Rows.Count == 0)
                {
                    ShowPageMessage("No Items found.", 2);
                }
                else
                {
                    ItemsGridView.DataSource = dt;
                    ItemsGridView.DataBind();
                    ShowPageMessage(dt.Rows.Count.ToString() + " Items found. Maximum is 500", 0);
                }
            }
        }
    }
    protected void DetailRowBound(Object sender, GridViewRowEventArgs e)
    {
        // allow click to open stock status
        GridViewRow row = e.Row;
        if (row.RowType == DataControlRowType.DataRow)
        {
            // set the link command
            LinkButton SSLink = (LinkButton)row.Cells[0].Controls[1];
            SSLink.OnClientClick = "DoStockStatus('" +
                Server.HtmlDecode(SSLink.Text) + "');";
            LinkButton SPLink = (LinkButton)row.Cells[3].Controls[1];
            SPLink.OnClientClick = "DoStockStatus('" +
                Server.HtmlDecode(SPLink.Text) + "');";
        }
    }
    protected void ClearPageMessages()
    {
        MessageLabel.Text = "";
        MessageUpdatePanel.Update();
    }
    protected void ShowPageMessage(string PageMessage, int MessageType)
    {
        switch (MessageType)
        {
            case 1:
                MessageLabel.CssClass = "warn";
                break;
            case 2:
                MessageLabel.CssClass = "error";
                break;
            default:
                MessageLabel.CssClass = "success";
                break;
        }
        //MessageLabel.CssClass = "error";
        MessageLabel.Text = PageMessage;
        MessageUpdatePanel.Update();
    }
}
