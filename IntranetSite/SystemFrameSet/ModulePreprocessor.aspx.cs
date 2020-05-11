#region Name Spaces
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
using PFC.Intranet.Securitylayer;
using PFC.Intranet; 
#endregion

namespace PFC.Intranet
{

    public partial class ModulePreprocessor : System.Web.UI.Page
    {
        /// <summary>
        /// Page Load Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                    if (Request.QueryString["DestPage"] != null && Request.QueryString["ModuleID"] != null)
                    {
                        try
                        {
                            UserTracking userTracking = new UserTracking();
                            userTracking.TrackPageEntry(Request.QueryString["ModuleID"].ToString());

                            Response.Redirect(Cryptor.Decrypt(Request.QueryString["DestPage"].ToString()).ToString());
                        }
                        catch (Exception ex)
                        {
                            Response.Write(ex);
                        }
                    }
            }
            

        }
    } 
}//End Class
