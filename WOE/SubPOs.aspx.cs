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

public partial class SubPOs : System.Web.UI.Page
{
    HyperLink POLink;
    public string POESiteURL = ConfigurationManager.AppSettings["POESiteURL"].ToString();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            gvPOs.DataSource = (DataTable)Session["SubPOs"];
            gvPOs.DataBind();
        }
    }

    protected void gvPOs_OnRowDataBound(Object sender, GridViewRowEventArgs e)
    {

        //if (e.Row.RowType == DataControlRowType.DataRow)
        //{
        //    // Set the link URL.
        //    POLink = (HyperLink)e.Row.Cells[0].Controls[1];
        //    POLink.NavigateUrl = POESiteURL + "POrderEntry.aspx";
        //}

    }

}
