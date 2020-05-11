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
public partial class ReadyToShip_RevUnProcessed : System.Web.UI.Page
{
    ReadyToShipUtility detRTS = new ReadyToShipUtility();

    protected void Page_Load(object sender, EventArgs e)
    {
        lblStatus.Text = "";
        pnlStatus.Update();
        if (!IsPostBack)
        {
            if (Request.QueryString["Vendor"] != null && Request.QueryString["Port"] != null)
            {
                lblVendor.Text = Request.QueryString["Vendor"].ToString().Trim();
                lblPort.Text = Request.QueryString["Port"].ToString().Trim();
                BindDetails();
            }
            else
            {
                lblMessage.Text = "Invalid arguments verndor and portoflading";
                lblMessage.ForeColor =System.Drawing.Color.FromName( "#cc0000");
                pnlStatus.Update();
            }
        }

    }

    public void BindDetails()
    {
        try
        {
            DataSet dsReview = detRTS.GetReviewUnprocessed(Request.QueryString["Vendor"].ToString().Trim(), Request.QueryString["Port"].ToString().Trim());
            if (dsReview != null && dsReview.Tables[0].Rows.Count > 0)
            {
                dgReview.DataSource = dsReview;
                dgReview.DataBind();
            }
            else
            {
                lblStatus.Text = "No Records Found";
                pnlShipDetails.Update();
            }
        }
        catch (Exception ex) { }
    }

    protected void imgPalceHold_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            string tableName = "GERRTSDtl";
            string columnValue = "Hold='Y'";
            string whereClause = "VendNo='" + Request.QueryString["Vendor"].ToString().Trim() + "' AND PortOfLading='" + Request.QueryString["Port"].ToString().Trim() + "' AND PONo in (Select PONO From GERRTS Where QtyRemaining>0 and VendNo='" + Request.QueryString["Vendor"].ToString().Trim() + "' AND PortOfLading='" + Request.QueryString["Port"].ToString().Trim() + "')";
            detRTS.UpdateQuantity(tableName, columnValue, whereClause);
            lblMessage.Text = "Purchase order(s) has been successfully holded";
            lblMessage.ForeColor = System.Drawing.Color.Green;
            pnlStatus.Update();

        }
        catch (Exception ex) { }
    }
}
