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
using PFC.SOE.DataAccessLayer;
using System.Data.SqlClient;

public partial class CompetitorPrice : System.Web.UI.Page
{
    string pfcItemNo = "";
    string customerNo = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["PFCItemNo"] != null && Request.QueryString["CustomerNo"] != null)
        {
            pfcItemNo = Request.QueryString["PFCItemNo"].ToString();
            customerNo = Request.QueryString["CustomerNo"].ToString();
            //pfcItemNo = "00200-2400-021";
            //customerNo = "002801";

            if (!Page.IsPostBack)
            {
                BindDataGrid();
            }
        }
        else
        {
            lblMessage.Text = "No record found";
            lblMessage.Visible = true;
            dgCompetitor.Visible = false;
        }
    }

    private void BindDataGrid()
    {
        try
        {
            DataTable dtCompetitor = new DataTable();
            DataSet dsCompetitorPrice = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "[pSOEReturnCompPriceMetrics]",
                                                 new SqlParameter("@item", pfcItemNo),
                                                 new SqlParameter("@selltoCustNo", customerNo),
                                                 new SqlParameter("@rows", "0"));

            if (dsCompetitorPrice != null && dsCompetitorPrice.Tables[0].Rows.Count > 0)
            {
                dtCompetitor = dsCompetitorPrice.Tables[0];

                if (hidSort.Value.Trim() != "")
                    dtCompetitor.DefaultView.Sort = hidSort.Value;
                else
                    dtCompetitor.DefaultView.Sort = "CompetitorName ASC";

                dgCompetitor.DataSource = dtCompetitor.DefaultView.ToTable();
                dgCompetitor.DataBind();
                lblMessage.Visible = false;
                dgCompetitor.Visible = true; ;
            }
            else
            {
                lblMessage.Text = "No record found";
                lblMessage.Visible = true;
                dgCompetitor.Visible = false;
            }

        }
        catch (Exception ex)
        {
            lblMessage.Text = "No record found";
            lblMessage.Visible = true;
            dgCompetitor.Visible = false;
        }
    }

    protected void dgCompetitor_ItemDataBound(object sender, DataGridItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            if (e.Item.Cells[0].Text.Trim() == "1")
            {
                e.Item.Font.Bold = true;                
            }
        }
    }

    protected void dgCompetitor_SortCommand(object source, DataGridSortCommandEventArgs e)
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

        hidSort.Value = ((e.SortExpression.IndexOf(" ") != -1) ? "[" + e.SortExpression + "]" : e.SortExpression) + " " + hidSort.Attributes["sortType"].ToString();
        BindDataGrid();
    }
}
