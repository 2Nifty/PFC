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




public partial class ItemBuilder_Builder : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if(Request.QueryString["UserName"] != null)
        {
            Session["CustNo"] = Request.QueryString["CustomerNumber"].ToString();
            Session["UserName"] = Request.QueryString["UserName"].ToString();
            string chkDCUser = Session["UserName"].ToString().Trim();
            if (chkDCUser == "DC")
                Header1.Visible = false;
            else
                Header1.Visible = true;
        }
    }
    #region Item Builder event handler
    protected void ItemControl_OnChange(object sender, EventArgs e)
    {
        FamilyPanel.Update();
    }

    protected void UpdateItemLookup(object sender, EventArgs e)
    {
        UCItemLookup.Visible = false;
        UCItemLookup.UpdateValue();

        if (Page.IsPostBack)
        {
            UCItemLookup.Visible = true;
            ControlPanel.Update();
        }
        if (UCItemLookup.Visible)
        {
           
            ControlPanel.Update();
            
        }

    }

    #endregion
}
