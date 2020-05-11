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

public partial class ShowItems : System.Web.UI.Page
{
    DataTable dt = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {
        ReportItemsGrid.DataSource = (DataTable)Session["CurItems"];
        ReportItemsGrid.DataBind();
    }

    protected virtual void SortCurItems(object source, GridViewSortEventArgs e)
    {
        // Retrieve the data source from session state.
        dt = (DataTable)Session["CurItems"];

        // Create a DataView from the DataTable.
        DataView dv = new DataView(dt);

        // The DataView provides an easy way to sort. Simply set the
        // Sort property with the name of the field to sort by.
        dv.Sort = e.SortExpression;

        // Re-bind the data source and specify that it should be sorted
        // by the field specified in the SortExpression property.
        ReportItemsGrid.DataSource = dv;
        ReportItemsGrid.DataBind();

    }

}
