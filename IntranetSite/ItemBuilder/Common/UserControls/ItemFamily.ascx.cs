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
using PFC.Intranet;



namespace PFC.Intranet
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

                if (dtItemFamily != null)
                {
                    if (dtItemFamily.Rows.Count > 0)
                    {
                        foreach (DataRow row in dtItemFamily.Rows)
                        {
                            MenuItem tabItem = new MenuItem((string)row["ChapterDesc"], (string)row["CHAPTER"]);
                            tabItem.ToolTip = row["ChapterDesc"].ToString();
                            //tabItem.NavigateUrl = "Javascript:GetItemFamily('" + (string)row["CHAPTER"] + "');";
                            muItemFamily.Items.Add(tabItem);

                        }
                    }
                }
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
        #endregion
        
} 
}
