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
namespace Novantus.Umbrella.UserControls
{
    public partial class novapopupdatepicker: System.Web.UI.UserControl
    {
        public string SelectedDate
        {
            get
            {
                if (textBox.Text != "")
                {

                    return textBox.Text;
                }
                else
                    return String.Empty;
            }
            set
            {
                if (value != "1/1/1900")
                    textBox.Text = value;
                else
                    textBox.Text = "";
            }

        }

        public int TabIndex
        {
            set { textBox.TabIndex = (short)value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }
        /// <summary>
        /// Function to Return site url for OpenDatePicker function used in javascript
        /// </summary>
        /// <returns></returns>
        protected string GetSiteURL()
        {
            //Umbrella.Securitylayer.UmbrellaControlBlock ControlBlock = new Novantus.Umbrella.Securitylayer.UmbrellaControlBlock();
            //string url = "'" + ControlBlock.SiteURL + "Umbrella/CodePro/ScreenBuilder/DatePicker_ClientInterface.aspx" + "'";
            string url = "'Common/DatePicker/DatePicker_ClientInterface.aspx'"; 
            return url;
        }
    }
}
