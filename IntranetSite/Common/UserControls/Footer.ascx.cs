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
namespace PFC.Intranet.ListMaintenance
{
    public partial class NewFooter : System.Web.UI.UserControl
    {
        

        public string LeftText
        {
            get { return lblLeftText.Text; }
            set { lblLeftText.Text = value; }
        }

        public string Title
        {
            get { return lblHeading.Text; }
            set { lblHeading.Text = value; }
        }

        public string CopyRight
        {
            get { return lblCpyright.Text; }
            set { lblCpyright.Text = value; }
        }
        
        protected void Page_Load(object sender, EventArgs e)
        {

            lnkCopyRight.Text = PFC.Intranet.BusinessLogicLayer.ApplicationConfiguration.CorporateName + ". All rights reserved. Terms & Conditions";
            //lnkCopyRight.Text = ". All rights reserved. Terms & Conditions";
        }
    }
}