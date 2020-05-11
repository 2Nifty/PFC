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
 
#endregion

public partial class PhoneNumber : System.Web.UI.UserControl
{
    #region Global variable decalaration

    public string strPhone = string.Empty;
 
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
            if (strPhone.Trim() != "")
                txtPhone.Text = ((strPhone.Length == 10 ) ? ("(" + strPhone.Substring(0, 3) + ")" + " " + strPhone.Substring(3, 3) + "-" + strPhone.Substring(6, 4)) :
                                (strPhone.Length >= 10 ) ?
                                (strPhone.Substring(0, 1) + "-" + strPhone.Substring(1, 3) + "-" + strPhone.Substring(4, 3) + "-" + strPhone.Substring(7, 4)):strPhone);
            else
                txtPhone.Text = "";
        }
    }
    public string GetFormattedPhoneNumber
    {
        get
        {
            return txtPhone.Text;
        }
    }
    public int TabIndex
    {
        set
        {
             txtPhone.TabIndex =(short)value;
        }
    }

    public string CssClass
    {
        set
        {
            txtPhone.CssClass = value;
        }

    }

    public int Width
    {
        set
        {
            txtPhone.Width = value;
        }
    }

    public bool ReadOnly
    {
        set
        {
            txtPhone.ReadOnly = value;
        }
    }

    #endregion

    #region Auto generated event

    protected void Page_Load(object sender, EventArgs e)
    {

    } 

    #endregion

}
