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
    private string strFormName = string.Empty;
    private bool strEnableEmail = true;
    private bool strEnableFax = true;

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

    public string FormName
    {
        get { return strFormName; }
        set
        {
            hidFormName.Value = value;
            strFormName = hidFormName.Value;
        }
    }

    [DefaultValue(true)]
    public bool EnableEmail
    {
        get { return Convert.ToBoolean(hidShowFax.Value); }
        set
        {
            hidShowEmail.Value = value.ToString();
            strEnableEmail = value;
        }
    }

    [DefaultValue(false)]
    public bool EnableFax
    {
        get { return Convert.ToBoolean(hidShowFax.Value); }
        set
        {
            hidShowFax.Value = value.ToString();
            strEnableFax = value;
        }
    }

    #endregion
    
    protected void Page_Load(object sender, EventArgs e)
    {
        ScriptManager mgr = ScriptManager.GetCurrent(this.Page);
        if (mgr != null)
            mgr.Scripts.Add(new ScriptReference("~/PrintUtility/Common/JavaScript/Common.js"));
        else
        {
            Literal js = new Literal();
            js.Text = "<script type=\"text/javascript\" src=\"~/PrintUtility/Common/JavaScript/Common.js\"></script>";
            this.Page.Header.Controls.Add(js);
        }

        strPageUrl = Server.UrlEncode(hidPageURL.Value);
        strPageTitle = hidPageTitle.Value;
        strCustomerNo = hidCustomerNo.Value;
        strFormName = hidFormName.Value;

        if (hidShowFax.Value.ToLower() == "true" )
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
        string printDialogURL = ConfigurationManager.AppSettings["IntranetSiteURL"].ToString() + "PrintUtility/PrintUtility.aspx";
       
        //string script = "var Url = '" + printDialogURL + "?pageURL=" + strPageUrl + "&CustomerNumber=" + strCustomerNo + "&SoeNo=" + strPageTitle + "&Mode=" + mode + "&FormName="+ strFormName + "'" +
        //                "window.open(Url,\"PrintUtility1\" ,'height=320,width=650,scrollbars=yes,status=no,top='+((screen.height/2) - (320/2))+',left='+((screen.width/2) - (650/2))+',resizable=No',\"\");";

        string script = "var Url = '" + printDialogURL + "?pageURL=" + strPageUrl + "&CustomerNumber=" + strCustomerNo + "&SoeNo=" + strPageTitle + "&Mode=" + mode + "&FormName=" + strFormName + "';" +
                       "window.open(Url,\"PrintUtility\" ,'height=320,width=650,scrollbars=yes,status=no,top='+((screen.height/2) - (320/2))+',left='+((screen.width/2) - (650/2))+',resizable=No',\"\");";


        ScriptManager.RegisterClientScriptBlock(this, ibtnPrint.GetType(), "printdialog", script, true);        
    }
}
