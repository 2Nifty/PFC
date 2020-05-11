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
using PFC.Intranet.DataAccessLayer;

public partial class RBReceiptsSumm : System.Web.UI.Page
{
    string RBConnectionString = ConfigurationManager.ConnectionStrings["PFCRBConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    GridViewRow row;
    LinkButton LPNLink;

    protected void Page_Init(object sender, EventArgs e)
    {
        Session["FooterTitle"] = null;
        if (!IsPostBack)
        {
            if ((Request.QueryString["LocFilter"] != null) && (Request.QueryString["LocFilter"].ToString().Length > 0))
            {
                PageFooter2.FooterTitle = "ERP Warehouse Receiving";
                LocFilter.Value = Request.QueryString["LocFilter"].ToString() + "%";
            }
            else
            {
                PageFooter2.FooterTitle = "ERP Bin Reconciliation";
                LocFilter.Value = "";
            }
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        // Initializing AJAX.NET Library 
        Ajax.Utility.RegisterTypeForAjax(typeof(RBReceiptsSumm));
        // onChange="document.form1.LocSubmit.click();"
    }

    protected void LocSubmit_Click(object sender, EventArgs e)
    {
        GetLPNData(LocationDropDownList.SelectedItem.Text.Split(new string[] { " - " }, StringSplitOptions.None)[0].Trim());
    }

    protected void GetLPNData(string Loc)
    {
        try
        {
            // get the data.
            ds = SqlHelper.ExecuteDataset(RBConnectionString, "pWHSLPNSummary",
                      new SqlParameter("@Branch", LocationDropDownList.SelectedItem.Value.ToString()),
                      new SqlParameter("@ShipMeth", ""));
            if (ds.Tables.Count == 1)
            {
                dt = ds.Tables[0];
                if (dt.Rows.Count > 0)
                {
                    LPNGridView.DataSource = dt;
                    LPNGridView.DataBind();
                    DetailUpdatePanel.Update();
                    Session["LPNData"] = dt;
                }
                else
                {
                    //lblErrorMessage.Text = "Error " + ItemNoTextBox.Text + ":" + QuoteFilterValueHidden.Value + ":" + QOHCommandHidden.Value;
                    lblErrorMessage.Text = "No Recipt Bins in Branch " + Loc;
                    MessageUpdatePanel.Update();
                }
            }
        }
        catch (Exception e3)
        {
            lblErrorMessage.Text = "pWHSLPNSummary Error " + e3.Message + ", " + e3.ToString();
            MessageUpdatePanel.Update();
        }
    }

    protected void DetailRowBound(Object sender, GridViewRowEventArgs e)
    {
        try
        {
            // set the detail link
            row = e.Row;
            if (row.RowType == DataControlRowType.DataRow)
            {
                // line formatting
                LPNLink = (LinkButton)row.Cells[0].Controls[1];
                string LinkCommand = "";
                LinkCommand = "return OpenDetail('";
                LinkCommand += LPNLink.Text + "');";
                LPNLink.OnClientClick = LinkCommand;
            }
        }
        catch (Exception e2)
        {
            lblErrorMessage.Text = "FillGrid Error " + e2.Message + ", " + e2.ToString();
            MessageUpdatePanel.Update();
        }
    }

    public void SortDetailGrid(Object sender, GridViewSortEventArgs e)
    {
        try
        {
            // Create a DataView 
            string LineFilter;
            DataView dv = new DataView((DataTable)Session["LPNData"]);
            dv.Sort = e.SortExpression;
            LPNGridView.DataSource = dv;
            LPNGridView.DataBind();
            DetailGridPanel.Height = new Unit(double.Parse(DetailGridHeightHidden.Value), UnitType.Pixel);
            DetailGridPanel.Width = new Unit(double.Parse(DetailGridWidthHidden.Value), UnitType.Pixel);
        }
        catch (Exception e2)
        {
            lblErrorMessage.Text = "Sort Error " + e2.Message + ", " + e2.ToString();
            MessageUpdatePanel.Update();
        }
    }

    public void DetailGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        //DataView dv = new DataView((DataTable)Session[DetailTableName.Value]);
        LPNGridView.DataSource = (DataTable)Session["LPNData"];
        LPNGridView.PageIndex = e.NewPageIndex;
        LPNGridView.DataBind();
        DetailGridPanel.Height = new Unit(double.Parse(DetailGridHeightHidden.Value), UnitType.Pixel);
        DetailGridPanel.Width = new Unit(double.Parse(DetailGridWidthHidden.Value), UnitType.Pixel);
    }
}
