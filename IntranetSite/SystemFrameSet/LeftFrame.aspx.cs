#region Namespaces
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

public partial class System_FrameSet_LeftFrame : System.Web.UI.Page
{
    /// <summary>
    /// Page Load Event handler
    /// </summary>
    /// <param name="sender">Control</param>
    /// <param name="e">EventArgs e</param>
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            if (Session["UserID"] != null && Session["MaxSensitivity"] != null && Request.QueryString["TabID"] != null)
            {
                int userId = Convert.ToInt16(Session["UserID"].ToString());
                int sensitivity = Convert.ToInt16(Session["MaxSensitivity"].ToString());
                int tabId = Convert.ToInt16(Request.QueryString["TabID"].ToString());
                
                switch (tabId)
                {
                    case 328:
                   // case 329:
                        LeftFrame.LoadMenuNews(tabId);
                        Page.RegisterClientScriptBlock("LoadPage", "<script>ShowLeftMenu();</script>");
                        Page.RegisterClientScriptBlock("Load", "<script>ShowRight();</script>");

                        break;
                    case 322:
                        Page.RegisterClientScriptBlock("LoadPage", "<script>top.frameSet2.cols='0,*';</script>");
                        break;
                    default:
                        LeftFrame.LoadMenu(tabId, userId, sensitivity);
                        Page.RegisterClientScriptBlock("LoadPage", "<script>ShowLeftMenu();</script>"); 
                        break;
                }
               
            }
        }
        catch (Exception ex)
        {
            throw;
        }
    }   
}//End Class
