#region Namespaces
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
using System.IO; 
#endregion


namespace PFC.Intranet
{
    public partial class Frame : System.Web.UI.Page
    {
        /// <summary>
        /// PageLoad Event Handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {

            try
            {
                Response.Expires = -1;

                if (Session["UserId"] != null && Session["CompanyID"] != null && Session["UserName"] != null)
                {
                    UserSession objUserSession = new UserSession();
                    objUserSession.InsertSession(Session["UserId"].ToString(), Session["CompanyID"].ToString(), Session["UserName"].ToString());

			  // Fill Authorized branches in Session
                    SalesReportUtils salesReport = new SalesReportUtils();
                    salesReport.FillBranchesAndChainSession(Session["UserID"].ToString());
                }
                else if (Session["SessionID"] == null)
                {
                    HttpContext.Current.Response.Redirect(PFC.Intranet.Global.IntranetSiteURL + "/SystemFrameSet/SessionOut.aspx");
                }

            }

            catch (Exception ex)
            {

                throw;
            }

        }

    }
}
