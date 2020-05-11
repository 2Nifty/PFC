#region Name Space
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
using System.Data.SqlClient;
using System.Threading;
using System.IO;
using System.Reflection;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
using System.Drawing;

#endregion

namespace PFC.Intranet.ListMaintenance
{
    public partial class Header : System.Web.UI.UserControl
    {
        DataTable dtCustomerInformation = new DataTable();
        ItemBuilder itemBuilder = new ItemBuilder();

        #region Auto generated event
        protected void Page_Load(object sender, EventArgs e)
        {
            //lblUserInfo.Text = DateTime.Now.ToLongDateString() + " You have logged in as <strong>" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "Sathish") + "</strong> in <strong> "+ System.Configuration.ConfigurationManager.AppSettings["Environment"];
            //lblUserInfo.Text = DateTime.Now.ToLongDateString() + " You have logged in as <strong>" + ((Session["UserName"] != null) ? Session["UserName"].ToString() : "None") + "</strong> in <strong> " + ((Session["MaintenanceEnvironment"] != null) ? Session["MaintenanceEnvironment"].ToString() : "dbEnvironment");

            dtCustomerInformation = itemBuilder.GetCustomerID(Session["CustNo"].ToString());
            // if (Request.QueryString["Internet"] != null)
           // {
                //if (Session["CustNo"].ToString() != "000000")
                    //lblCustNo.Text = Session["CustNo"].ToString() + " - " + dtCustomerInformation.Rows[0]["Name1"].ToString();
               // else
                    //lblCustNo.Text = "000000 - Generic Cross Reference Item Entry";
            //}            

        }

        #endregion

    }
}