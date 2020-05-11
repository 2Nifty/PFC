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
namespace PFC.WOE.ListMaintenance
{
    public partial class NewFooter : System.Web.UI.UserControl
    {
        /// <summary>
        /// Set the Title to be display at the footer
        /// </summary>
        public string Title
        {
            get { return lblHeading.Text; }
            set { lblHeading.Text = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {

            lnkCopyRight.Text = PFC.WOE.BusinessLogicLayer.ApplicationConfiguration.CorporateName + ". All rights reserved. Terms & Conditions";
            //lnkCopyRight.Text = ". All rights reserved. Terms & Conditions";
        }
    }
}