using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
namespace PFC.SOE.DataAccessLayer
{
    /// <summary>
    /// Summary description for Global.
    /// </summary>
    public class Global : System.Web.HttpApplication
    {

        //
        // Global variables 
        //
        public static string PFCQuoteConnectionString;
        public static string PFCNavisionConnectionString;
        public static string PFCReportConnectionString;
        public static string PFCUmbrellaConnectionString;
        public static string PFCERPConnectionString;
        public static string PrintStyleSheet;
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
            // Code that runs on application startup
            PFCQuoteConnectionString = System.Configuration.ConfigurationManager.AppSettings["PFCQuoteDBConnectionString"];
            PFCNavisionConnectionString = System.Configuration.ConfigurationManager.AppSettings["PFCNavisionDBConnectionString"];
            PFCUmbrellaConnectionString = System.Configuration.ConfigurationManager.AppSettings["UmbrellaConnectionString"];
            PFCReportConnectionString = System.Configuration.ConfigurationManager.AppSettings["PFCReportConnectionString"];
            PFCERPConnectionString = System.Configuration.ConfigurationManager.AppSettings["PFCERPConnectionString"];
            PrintStyleSheet = "<link href=\"http://10.1.36.34/SOE/Common/StyleSheet/printstyles.css\" rel=\"stylesheet\" type=\"text/css\" />";
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

        }

        protected void Application_Error(Object sender, EventArgs e)
        {

        }

        protected void Session_End(Object sender, EventArgs e)
        {
            Response.Write("<script>");
            Response.Write("window.opener=top;");
            Response.Write("var a=window.screen.availHeight-30; window.open(" + "Umbrella / kernel / pcowiniex.aspx" + ");");
            Response.Write("window.close();");
            Response.Write("</script>");
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
