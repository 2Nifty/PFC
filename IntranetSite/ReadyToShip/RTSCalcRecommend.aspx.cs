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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
using GER;

public partial class RTSCalcRecommend : System.Web.UI.Page
{
    PFC.Intranet.BusinessLogicLayer.GERRTS gerrts = new PFC.Intranet.BusinessLogicLayer.GERRTS();
    Utility getUtility = new Utility();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            SystemCheck systemCheck = new SystemCheck();
            systemCheck.SessionCheck();
            if (gerrts.CalcProcessed())
            {
                OKButton.Visible = false;
                IncludeSummQtys.Visible = false;
                IncludeLabel.Visible = false;
                lblErrorMessage.Text = "Calculation has already been run.";
            }
            else
            {
            }
        }

    }

    protected void OKButton_Click(object sender, ImageClickEventArgs e)
    {
        // Run the stored procedure to cleaer the ehader and detail files and load the recommened qtys
        string result = "";
        string UserName = ((Session["UserName"] != null) ? Session["UserName"].ToString() : "Sathish");
        Server.ScriptTimeout = 6000;
        result = gerrts.CalcRecommended(UserName, 0, IncludeSummQtys.Checked.ToString().ToUpper());
        if (result == "")
        {
            lblSuccessMessage.Text = "Calculations have been loaded and are ready for use. Process complete.";
        }
        else
        {
            // Notify the user of the error
            lblErrorMessage.Text = result;
        }
    }

}
