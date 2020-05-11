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

public partial class ReadyToShip_Home : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
       
        Contacts1.CustomerNumber = "000001"; 
        Contacts1.AddressID = "1";
    }
}
