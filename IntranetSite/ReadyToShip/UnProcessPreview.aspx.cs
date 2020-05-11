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

public partial class ReadyToShip_UnProcessPreview : System.Web.UI.Page
{
    ReadyToShipUtility detRTS = new ReadyToShipUtility();

    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
            BindDetails();
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
                //pnlShipDetails.Update();
            }
        }
        catch (Exception ex) { }
    }

}
