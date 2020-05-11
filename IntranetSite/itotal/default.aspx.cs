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
using System.Management;

public partial class ITotal_Default : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

        string MacAddress = string.Empty;
        try
        {
            ManagementClass MClass = new ManagementClass("Win32_NetworkAdapterConfiguration");
            ManagementObjectCollection MobjCollection = MClass.GetInstances();
            foreach (ManagementObject MObject in MobjCollection)
            {
                if ((bool)MObject["IPEnabled"] == true)
                {
                    MacAddress = MObject["MacAddress"].ToString();
                }
                MObject.Dispose();
            }

            Response.Write(MacAddress);
            //if (MacAddress == "[ValidationAddress]")
            //    return true;
            //else
            //    return false;

        }
        catch (Exception ex)
        {
            throw ex;
        }
    }
}
