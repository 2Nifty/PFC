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
using PFC.SOE.BusinessLogicLayer;
public partial class Release : System.Web.UI.Page
{
    OrderEntry orderEntry = new OrderEntry();
    protected void Page_Load(object sender, EventArgs e)
    {
        orderEntry.ReleaseLock();
    }
}
