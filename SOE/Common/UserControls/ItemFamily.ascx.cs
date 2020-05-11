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



namespace PFC.SalesPricing
{
    public partial class ItemFamily : System.Web.UI.UserControl
    {
        #region Variable declaration
        ItemBuilder itemBuilder = new ItemBuilder();
        public event EventHandler ItemClick; 
        #endregion

        #region Page load event handler
        /// <summary>
        /// Page load event handlers
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                LoadMenu();
                OnItemClick(e);

            }
        } 
        #endregion

        #region Developer Code
        /// <summary>
        /// Load Item family Menu
        /// </summary>
        private void LoadMenu()
        {
            try
            {
                DataTable dtItemFamily = itemBuilder.GetItemFamily();
                dgMenu.DataSource = dtItemFamily;
                dgMenu.DataBind();
                //if (dtItemFamily != null)
                //{
                //    if (dtItemFamily.Rows.Count > 0)
                //    {
                //        foreach (DataRow row in dtItemFamily.Rows)
                //        {
                //            MenuItem tabItem = new MenuItem((string)row["ChapterDesc"], (string)row["CHAPTER"]);
                //            tabItem.ToolTip = row["ChapterDesc"].ToString();
                //            //tabItem.NavigateUrl = "Javascript:GetItemFamily('" + (string)row["CHAPTER"] + "');";
                //            muItemFamily.Items.Add(tabItem);

                //        }
                //    }
                //}
            }
            catch (Exception ex)
            {
                throw;
            }

        }
        #endregion  

        #region Event Handler
        /// <summary>
        /// Event HAndler
        /// </summary>
        /// <param name="e"></param>
        protected void OnItemClick(EventArgs e)
        {
            if (ItemClick != null)
            {
                ItemClick(this, e);

            }
        }
        /// <summary>
        /// Item family section event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void muItemFamily_MenuItemClick(object sender, MenuEventArgs e)
        {
            Session["ItemFamily"] = e.Item.Value;
            OnItemClick(e);
        }

        protected void dgMenu_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                e.Item.Attributes.Add("onmouseover", "javascript:this.className='MenuItemMo';");
                e.Item.Attributes.Add("onmouseout", "javascript:this.className='leftMenuItem';");
                e.Item.Attributes.Add("onclick", "javascript:this.className='leftMenuItemMo';");
            }
        }
        protected void dgMenu_ItemCommand(object source, DataGridCommandEventArgs e)
        {

            foreach (DataGridItem dgitem in dgMenu.Items)
            {
                if(dgitem.ItemIndex != e.Item.ItemIndex) 
                 dgitem.CssClass = "leftMenuItem";
            }

            e.Item.CssClass = "leftMenuItemMo";
            HiddenField hidValue = e.Item.FindControl("hidValue") as HiddenField;
            Session["ItemFamily"] = hidValue.Value;
            OnItemClick(e);
            UpdatePanel upFamily = Page.FindControl("FamilyPanel") as UpdatePanel;
            upFamily.Update();
            ScriptManager.RegisterClientScriptBlock(dgMenu, typeof(DataGrid), "", "javascript:document.getElementById('TDItem').style.display='';SetGridHeight('ItemFamily');", true);
        }
        #endregion
        
} 
}
