


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
using System.Data.SqlClient;
using System.Threading;
using System.Reflection;
using System.IO;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
using PFC.Intranet.BusinessLogicLayer;
using System.Net;
using PFC.Intranet.Securitylayer;


public partial class CustomerActivitySheet : System.Web.UI.Page
{

    public void Page_Load(object sender, EventArgs e)
    {

        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        // Registering AJAX
        Ajax.Utility.RegisterTypeForAjax(typeof(CustomerActivitySheet));
    }

   
    // Ajax Function to get the page content through http post
    [Ajax.AjaxMethod()]
    public string GetPage(string strCustNo,string strMonth,string strYear,string strServer)
    {
        try
        {
            WebRequest req = WebRequest.Create("http://" + strServer + "/IntranetSite/CustomerActivitySheet/CustomerData.aspx?CustNo=" + strCustNo + "&Month=" + strMonth + "&Year=" + strYear);
            WebResponse resp = req.GetResponse();
            StreamReader reader = new StreamReader(resp.GetResponseStream(), System.Text.Encoding.ASCII);
            return reader.ReadToEnd();
        }
        catch (Exception ex) { return ""; }
    }


}
