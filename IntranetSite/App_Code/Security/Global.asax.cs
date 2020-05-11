using System;
using System.Collections;
using System.ComponentModel;
using System.Web;
using System.Web.SessionState;
using System.Web.Security;
using System.Data;

namespace PFC.Intranet
{
    /// <summary>
    /// Summary description for Global.
    /// </summary>
    public class Global : System.Web.HttpApplication
    {
        //
        // Global variables 
        //
        public static string ReportsConnectionString = System.Configuration.ConfigurationSettings.AppSettings["ReportsConnectionString"];
        public static string PFCERPConnectionString = System.Configuration.ConfigurationSettings.AppSettings["PFCERPConnectionString"];
        public static string QuotesSystemConnectionString = System.Configuration.ConfigurationSettings.AppSettings["QuotesSystemConnectionString"];
        public static string UmbrellaConnectionString = System.Configuration.ConfigurationSettings.AppSettings["UmbrellaConnectionString"];
        public static string InternerUmbrellaConnectionString = System.Configuration.ConfigurationSettings.AppSettings["InternetUmbrellaConnectionString"];
        public static string IntranetInterfaceID = "123";
        public static string IntranetSiteURL = System.Configuration.ConfigurationSettings.AppSettings["IntranetSiteURL"];
        public static string UmbrellaSiteURL = System.Configuration.ConfigurationSettings.AppSettings["UmbrellaSiteURL"]; 
        public static string WinSystemName = System.Configuration.ConfigurationSettings.AppSettings["WinSystemName"]; 
	    public static string NavisionConnectionString = System.Configuration.ConfigurationSettings.AppSettings["NVConnectionString"];
        public static string ShipLiveConnectionString = System.Configuration.ConfigurationSettings.AppSettings["PFCShipLiveConnectionString"];
        public static string RBConnectionString = System.Configuration.ConfigurationSettings.AppSettings["PFCRBConnectionString"];

        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        public Global()
        {
            InitializeComponent();
        }

        protected void Application_Start(Object sender, EventArgs e)
        {
           
        }

        protected void Session_Start(Object sender, EventArgs e)
        {
            
                    
        }

        protected void Application_BeginRequest(Object sender, EventArgs e)
        {

        }

        protected void Application_EndRequest(Object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(Object sender, EventArgs e)
        {
            //string User = HttpContext.Current.Profile.UserName.ToString();
        }

        protected void Application_Error(Object sender, EventArgs e)
        {

        }

        protected void Session_End(Object sender, EventArgs e)
        {
            Session["ItemSale"] = "";
            Session["CustomerSale"] = "";
            Session["DocSale"] = "";
            Session["BranchItem"] = "";
            Session["BranchCustomer"] = "";
            Session["dtReport"] = "";
            Session["dt"] = "";
        }

        protected void Application_End(Object sender, EventArgs e)
        {

        }

        #region Web Form Designer generated code
        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
        }
        #endregion
    }
}

