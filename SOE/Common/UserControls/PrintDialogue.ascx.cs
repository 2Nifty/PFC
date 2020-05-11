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
    private string strPageTitle = string.Empty;
    private string strCustomerNo = string.Empty;
    private string strMode = string.Empty;
    private bool strEnableFax = false;
    private string strFormName = string.Empty;

    /// <summary>
    /// PFC CustomerNo
    /// </summary>
    public string CustomerNo
    {
        get { return strCustomerNo; }
        set {
            hidCustomerNo.Value = value;
            strCustomerNo = hidCustomerNo.Value;
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

    public string PageUrl
    {
        get { return strPageUrl; }
        set {
            hidPageURL.Value = value;
            strPageUrl = hidPageURL.Value; 
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
        string printDialogURL = ConfigurationManager.AppSettings["SOESiteURL"].ToString() + "PrintUtility.aspx";
        //string printDialogURL = "PrintUtility.aspx";
        ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Fax", "OpenPrintDialog('" + strPageUrl + "','" + mode + "','" + strCustomerNo + "','" + Server.UrlEncode(strPageTitle) + "','" + printDialogURL + "','" + EnableFax + "','"+ FormName + "');", true);
    }
}
