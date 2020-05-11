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
    public partial class popupdatepicker: System.Web.UI.UserControl
    {
        public string SelectedDate
        {
            get
            {
                if (txtDatePicker.Text != "")
                {

                    return txtDatePicker.Text;
                }
                else
                    return String.Empty;
            }
            set
            {
                if (value != "1/1/1900")
                    txtDatePicker.Text = value;
                else
                    txtDatePicker.Text = "";
            }
        }

        //public bool ISValid
        //{
        //    get { return rfvDate.IsValid; }
        //}

        public int TabIndex
        {
            set
            {
                txtDatePicker.TabIndex = (short)value;
            }
        }

        public int Width
        {
            set
            {
                if ((short)value != 0)
                    txtDatePicker.Width = (short)value;
            }
        }

        public string ParentErrCtl
        {
            set
            {
                hidParentErrCtl.Value = value;
            }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        //GetSiteURL method is no longer used.
        //The DatePicker URL is now hard coded
        //in the javascript function inside DatePicker.js.
        //Include DatePicker.js in your main page to make this work.

        //protected string GetSiteURL()
        //{
        //    string url = "'../Common/DatePicker/DatePicker_ClientInterface.aspx'"; 
        //    return url;
        //}   
    }
}
