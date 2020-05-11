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

public partial class item : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

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
            //divdatagrid.Style.Add("height", "320px");
            ControlPanel.Update();
           
        }
    }
    /// <summary>
    /// ItemControl_OnPackageChange Event handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ItemControl_OnPackageChange(object sender, EventArgs e)
    {
    }
    /// <summary>
    /// Event Handler
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ItemControl_OnChange(object sender, EventArgs e)
    {
        FamilyPanel.Update();
    }
    #region Show hide item builder

    /// <summary>
    /// Event to show the item builder
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ibtnHide_Click(object sender, ImageClickEventArgs e)
    {
        imgShowItemBuilder.Visible = true;
        ibtnHide.Visible = false;
        UCItemLookup.Visible = false;
        ControlPanel.Update();
    }

    /// <summary>
    /// Event to hide the item builder
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void imgShowItemBuilder_Click(object sender, ImageClickEventArgs e)
    {
        imgShowItemBuilder.Visible = false;
        ibtnHide.Visible = true;
    }

    #endregion
}
