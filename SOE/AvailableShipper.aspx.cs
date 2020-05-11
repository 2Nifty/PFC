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


public partial class AvailableShipper : System.Web.UI.Page
{
    string orderNo = "";
    SelectPrintShipper printShipper = new SelectPrintShipper();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            orderNo = Request.QueryString["OrderNo"].ToString();
            lblCaption.Text = "Shipper Selection for Order # " + orderNo;
            BindGrid();
        }
        // Register Ajax
        Ajax.Utility.RegisterTypeForAjax(typeof(AvailableShipper));
    }

    private void BindGrid()
    {
        string order = orderNo.Replace("W", "");
        string whereClause = orderNo.Trim().Contains("W") ? "OrderNo='" + order + "'" : "fSOHeaderID='" + order + "'";
        DataTable dtShipper = printShipper.GetShipper(whereClause);
        if (dtShipper.Rows.Count > 0)
        {
            dlShipped.DataSource = dtShipper;
            dlShipped.DataBind();
        }
        else
        {
            printShipper.DisplayMessage(MessageType.Failure, "No Records found", lblMessage);
        }
    }


    protected void dlShipped_ItemCommand(object source, DataListCommandEventArgs e)
    {
        if (e.CommandName == "Load")
        {
            string shipperNo = e.CommandArgument.ToString().Trim();
            // set up everything for the Print Utilty and fire it up.
            string printDialogURL = ConfigurationManager.AppSettings["SOESiteURL"].ToString() + "PrintUtility.aspx";
            string strPageTitle = "Shipper " + shipperNo;
            string strPageUrl = "ShipperExport.aspx?ShipperNo=" + shipperNo;
            ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Fax", "OpenPrintDialog('" + strPageUrl + "','Print','','" + Server.UrlEncode(strPageTitle) + "','" + printDialogURL + "','True' );", true);
        }
    }
}
