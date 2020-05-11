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


public partial class SalesForeCastingTool_CustomerSelectionPrompt : System.Web.UI.Page
{
    SalesReportUtils salesReportUtils = new SalesReportUtils();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            FillBranches();
           // Session["UserID"] = "328";

        }

    }
        public void FillBranches()
        {
            try
            {
              //  salesReportUtils.FillBranchesAndChainSession(Session["UserID"].ToString());
                salesReportUtils.GetALLBranches(ddlBranch, Session["UserID"].ToString());
                ddlBranch.SelectedValue= Session["DefaultCompanyID"].ToString().Length == 1 ? "0" + Session["DefaultCompanyID"].ToString() : Session["DefaultCompanyID"].ToString();
            }
            catch (Exception ex) { }
        }


    protected void ddlBranch_SelectedIndexChanged(object sender, EventArgs e)
    {
        upnlBranch.Update();

    }
}
 


   

