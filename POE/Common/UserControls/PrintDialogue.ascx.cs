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
    private string strPageSetup = "P";
    private PrinterSetup _printerSetup= PrinterSetup.Portrait;

    private bool strEnableEmail = true;
    private bool strEnableFax = false;

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

    public PrinterSetup PageSetup
    {
        get
        {
            if (hidPageSetup.Value == "L")
                return PrinterSetup.Landscape;
            else
                return PrinterSetup.Portrait;
        }
        set
        {
            if (value == PrinterSetup.Landscape)
                hidPageSetup.Value = "L";
            else
                hidPageSetup.Value = "P";
                        
        }
    }

    [DefaultValue(true)]
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
    #endregion

    #region Enum 

    public enum PrinterSetup
    {
        Portrait,
        Landscape
    }

    #endregion

    protected void Page_Load(object sender, EventArgs e)
    {
        strPageUrl = Server.UrlEncode(hidPageURL.Value);
        strPageTitle = hidPageTitle.Value;
        strCustomerNo = hidCustomerNo.Value;

        if (strEnableFax)
            ibtnFax.Visible = true;
        else
            ibtnFax.Visible = false;

        if (strEnableEmail)
            ibtnEmail.Visible = true;
        else
            ibtnEmail.Visible = false;
    }

    protected void ibtnEmail_Click(object sender, ImageClickEventArgs e)
    {
        try
        {
            ExportPage("Email");
            
        }
        catch (Exception ex) { }
    }

    protected void ibtnPrint_Click(object sender, ImageClickEventArgs e)
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

        string printDialogURL = ConfigurationManager.AppSettings["POESiteURL"].ToString() + "PrintUtility.aspx";
        ScriptManager.RegisterClientScriptBlock(ibtnEmail, ibtnEmail.GetType(), "Faxd", "OpenPrintDialog('" + strPageUrl + "','" + mode + "','" + strCustomerNo + "','" + Server.UrlEncode(strPageTitle) + "','" + printDialogURL + "','" + hidPageSetup.Value + "');", true);       
    }
}
