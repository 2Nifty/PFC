#region Namespace

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
using PFC.Intranet.DataAccessLayer;
 
#endregion

public partial class PhoneNumber : System.Web.UI.UserControl
{
    #region Global variable decalaration

    public string strPhone = string.Empty;
    VendorDetailLayer vendorDetails = new VendorDetailLayer();
    #endregion

    #region Property Bag

    public string GetPhoneNumber
    {
        get
        {
            strPhone = txtPhone.Text.Replace(")", "");
            strPhone = strPhone.Replace("(", "");
            strPhone = strPhone.Replace(")", "");
            strPhone = strPhone.Replace(" ", "");
            strPhone = strPhone.Replace("-", "");
            return strPhone;
        }
        set
        {
            strPhone = value;
            txtPhone.Text =vendorDetails.FormatPhoneFax(strPhone);
            
        }
    }
    private bool _enable=true;

    public bool Enable
    {
        get { return _enable; }
        set { txtPhone.Enabled = value; }
    }


    #endregion

    #region Auto generated event

    protected void Page_Load(object sender, EventArgs e)
    {

    } 

    #endregion

}
