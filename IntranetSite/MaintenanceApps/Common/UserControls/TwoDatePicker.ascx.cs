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

public partial class Common_UserControls_TwoDatePicker : System.Web.UI.UserControl
{
    public int TabIndex
    {
        set
        {
            txtStart.TabIndex = (short)value;
            txtEnd.TabIndex = (short)(value + 1);
        }
    }
    public string StartDate
    {
        set { txtStart.Text = value; }
        get { return txtStart.Text; }
    }
    public string EndDate
    {
        set { txtEnd.Text = value; }
        get { return txtEnd.Text; }
    }
    public string StartLabelText
    {
        set { lblStartLabel.Text = value; }
    }
    public string EndLabelText
    {
        set { lblEndLabel.Text = value; }
       
    }
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    protected void cvDatePicker_ServerValidate(object source, ServerValidateEventArgs args)
    {
        if (txtStart.Text != "" && txtEnd.Text != "")
        {
            if (Convert.ToDateTime(txtStart.Text) <= Convert.ToDateTime(txtEnd.Text))
                args.IsValid = true;
            else
                args.IsValid = false;
        }
        else
            args.IsValid = true;
    }
}
