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
using PFC.Intranet.BusinessLogicLayer;

public partial class WarehouseMgmt_ReceiveReportPrompt : System.Web.UI.Page
{
    Warehouse warehouse = new Warehouse();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
            BindBranch();
    }

    private void BindBranch()
    {
        warehouse.BindListControls(ddlLocation, "Name", "Code", warehouse.GetLocation(), "--ALL--");
    }

    protected void btnPrompt_Click(object sender, ImageClickEventArgs e)
    {
        if (txtBOLNo.Text != "" || txtContainerNo.Text != "" || txtDocumentNo.Text != "")
        {
            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "ReceiveReport", "javascript:OpenReport('" + ddlLocation.SelectedItem.Value.ToString() + "','" + ddlLocation.SelectedItem.Text + "','" + txtContainerNo.Text + "','" + txtBOLNo.Text + "','" + txtDocumentNo.Text + "');", true);
        }
        else
        {
            ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "ReceiveReport", "javascript:alert('Invalid Search Criteria');", true);
        }
    }

    protected void btnClear_Click(object sender, ImageClickEventArgs e)
    {
        txtBOLNo.Text = "";
        txtContainerNo.Text = "";
        txtDocumentNo.Text = "";
        ddlLocation.ClearSelection();
    }
}
