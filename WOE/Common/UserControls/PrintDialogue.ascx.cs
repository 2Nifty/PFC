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
using System.ComponentModel;

public partial class PrintDialogue : System.Web.UI.UserControl
{

    #region Property Bag
    private string strPageUrl = string.Empty;
    private string strMode = string.Empty;
    private string strPageTitle = string.Empty;
    private string strPageSetup = string.Empty;
    private string strCustomerNo = string.Empty;
    private bool strEnableEmail = false;
    private bool strEnableFax = false;
    private string strFormName = string.Empty;

    public string PageUrl
    {
        get { return strPageUrl; }
        set
        {
            hidPageURL.Value = value;
            strPageUrl = hidPageURL.Value;
        }
    }
    
    public string PageTitle
    {
        get { return strPageTitle; }
        set { 
            hidPageTitle.Value= value;
            strPageTitle = hidPageTitle.Value;
        }
    }

    public string PageSetup
    {
        get { return strPageSetup; }
        set
        {
            strPageSetup = value;
        }
    }

    public string CustomerNo
    {
        get { return strCustomerNo; }
        set
        {
            hidCustomerNo.Value = value;
            strCustomerNo = hidCustomerNo.Value;
        }
    }

    [DefaultValue(false)]
    public bool EnableEmail
    {
        get { return strEnableEmail; }
        set
        {
            strEnableEmail = value;
        }
    }

    [DefaultValue(false)]
    public bool EnableFax
    {
        get { return strEnableFax; }
        set
        {
            strEnableFax = value;
        }
    }
    
    public string FormName
    {
        get { return strFormName; }
        set
        {
            hidFormName.Value = value;
            strFormName = hidFormName.Value;
        }
    }

    #endregion
    
    protected void Page_Load(object sender, EventArgs e)
    {
        strPageUrl = Server.UrlEncode(hidPageURL.Value);
        strPageTitle = hidPageTitle.Value;
        strCustomerNo = hidCustomerNo.Value;
        strFormName = hidFormName.Value;

        if (strEnableFax)
            ibtnFax.Visible = true;
        else
            ibtnFax.Visible = false;
        if (strEnableEmail)
            ibtnEmail.Visible = true;
        else
            ibtnEmail.Visible = false;        
    }

    protected void ibtnEmail_Click1(object sender, ImageClickEventArgs e)
    {
        try
        {
            ExportPage("Email");
        }
        catch (Exception ex) { }
    }

    protected void ibtnPrint_Click1(object sender, ImageClickEventArgs e)
    {
        try
        {
            ExportPage("Print");
        }
        catch (Exception ex) { }
    }

    protected void ibtnFax_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            ExportPage("Fax");
        }
        catch (Exception ex) { }
    }

    private void ExportPage(string mode)
    {
        string printDialogURL = ConfigurationManager.AppSettings["WOESiteURL"].ToString() + "/Common/UserControls/PrintUtility.aspx";

        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Print", "OpenPrintDialog('" + printDialogURL + "','" + strPageUrl + "','" + mode + "','" + Server.UrlEncode(strPageTitle) + "','" + strPageSetup + "','" + strCustomerNo + "','" + EnableEmail + "','" + EnableFax + "','" + strFormName  + "' );", true);
    }
}
