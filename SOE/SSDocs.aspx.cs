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

public partial class SSDocs : System.Web.UI.Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        string Loc = "";
        string Item = "";
        string SearchType = "";
        string SearchDesc = "";
        NameValueCollection coll = Request.QueryString;
        if (coll["ItemNo"] != null && coll["ItemNo"].ToString().Length > 0)
        {
            ItemNoLabel.Text = coll["ItemNo"].ToString();
            Item = coll["ItemNo"].ToString();
        }
        if (coll["Loc"] != null && coll["Loc"].ToString().Length > 0)
        {
            Loc = coll["Loc"].ToString();
            LocationLabel.Text = "Location: " + coll["Loc"].ToString();
        }
        if (coll["Type"] != null && coll["Type"].ToString().Length > 0)
        {
            SearchType = coll["Type"].ToString();
            TypeHidden.Value = coll["Type"].ToString();
            switch (SearchType)
            {
                case "SO":
                    SearchDesc = "Allocated Sales Orders";
                    break;
                case "BO":
                    SearchDesc = "Back Orders";
                    break;
                case "TI":
                    SearchDesc = "Incoming Transfer Orders";
                    break;
                case "TO":
                    SearchDesc = "Outgoing Transfer Orders";
                    break;
                case "PO":
                    SearchDesc = "Purchase Orders";
                    break;
                case "OW":
                    SearchDesc = "On The Water Orders";
                    break;
                case "WO":
                    SearchDesc = "Production Work Orders";
                    break;
                case "RO":
                    SearchDesc = "Return Orders";
                    break;
            }
            TypeLabel.Text = SearchDesc;
        }
        if (coll["ItemDesc"] != null && coll["ItemDesc"].ToString().Length > 0)
        {
            ItemDescLabel.Text = coll["ItemDesc"].ToString();
        }
        // get the items.
        ds = SqlHelper.ExecuteDataset(connectionString, "pSSGetDocs",
            new SqlParameter("@SearchItem", Item),
            new SqlParameter("@SearchLoc", Loc),
            new SqlParameter("@SearchType", SearchType));
        if (ds.Tables.Count >= 1)
        {
            if (ds.Tables.Count == 1)
            {
                // We only go one table back, something is wrong
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    ShowPageMessage("No documents found.", 2);
                }
            }
            else
            {
                dt = ds.Tables[1];
                if (dt.Rows.Count == 0)
                {
                    ShowPageMessage("No documents found.", 2);
                }
                else
                {
                    POEURL.Value = ConfigurationManager.AppSettings["POESiteURL"].ToString();
                    DocsGridView.DataSource = dt;
                    DocsGridView.DataBind();
                    ShowPageMessage(dt.Rows.Count.ToString() + " documents found.", 0);
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
            Label labelField = (Label)row.Cells[1].Controls[1];
            LinkButton linkField = (LinkButton)row.Cells[1].Controls[3];
            if (labelField.Text != "Non-ERP")
            {
                linkField.OnClientClick = "ShowDoc('" +
                    Server.HtmlDecode(linkField.Text) + "');";
                labelField.Visible = false;
            }
            else
            {
                linkField.Visible = false;
            }
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
