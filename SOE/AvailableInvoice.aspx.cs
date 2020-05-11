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
using PFC.SOE.BusinessLogicLayer;
using PFC.SOE.Enums;


public partial class AvailableInvoice : System.Web.UI.Page
{
    string orderNo = "";
    SelectPrintInvoice printInvoice = new SelectPrintInvoice();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            orderNo = Request.QueryString["OrderNo"].ToString();
            lblCaption.Text = "Invoice Selection for Order # " + orderNo;

            BindGrid();
        }
    }

    private void BindGrid()
    {
        string order = orderNo.Replace("W", "");
        string whereClause = orderNo.Trim().Contains("W") ? "OrderRelNo='" + order + "'" : "OrderNo='" + order + "'";
        DataTable dtInvoice = printInvoice.GetInvoice(whereClause);
        if (dtInvoice.Rows.Count > 0)
        {
            dlInvoiced.DataSource = dtInvoice;
            dlInvoiced.DataBind();
        }
        else
        {
            printInvoice.DisplayMessage(MessageType.Failure, "No Records found", lblMessage);
        }
    }


    protected void dlInvoiced_ItemCommand(object source, DataListCommandEventArgs e)
    {
        if (e.CommandName == "Load")
        {
            string invoice = e.CommandArgument.ToString().Trim();
            ScriptManager.RegisterClientScriptBlock(this,typeof(Page),"Load","javascript:OpenInvoice('" + invoice+ "');",true);
        }
    }
}
