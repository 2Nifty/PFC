#region Name Space
using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Reflection;
using System.Threading;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

using PFC.POE;
using PFC.POE.DataAccessLayer;
//using PFC.Intranet.Securitylayer;
#endregion

namespace PFC.POE
{
    public partial class InfoHeader : System.Web.UI.UserControl
    {


        #region Auto generated event
        protected void Page_Load(object sender, EventArgs e)
        {
            lblUserInfo.Text = DateTime.Now.ToLongDateString() + " You have logged in as <strong>" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "[null]") + "</strong> in <strong> "+ System.Configuration.ConfigurationManager.AppSettings["Environment"];
        }

        #endregion

    }
}