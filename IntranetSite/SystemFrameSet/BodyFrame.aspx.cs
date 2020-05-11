#region Name spaces
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
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;


#endregion
namespace PFC.Intranet
{
    public partial class BodyFrame : System.Web.UI.Page
    {
        SystemCheck systemCheck = new SystemCheck();
        /// <summary>
        /// Page_Load:Page Load Event
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {

            systemCheck.SessionCheck();
            if (Request.QueryString["TabID"] != null && Request.QueryString["ParentID"] != null)
                BindDataGrid();
            lblParentMenuName.Text = Request.QueryString["ParentMenuName"].ToString();
            
        }

        #region Developer Code
        /// <summary>
        /// BindDataGrid():Method used to bind Menus based on the condition
        /// </summary>
        private void BindDataGrid()
        {
            try
            {
                MenuGenerator menu = new MenuGenerator();
                int tabid = Convert.ToInt16(Request.QueryString["TabID"]);
                int parentId = Convert.ToInt16(Request.QueryString["ParentID"]);
                int sensitivity = Convert.ToInt32(Session["MaxSensitivity"]);
                DataSet dsSubmenu = menu.GetSubMenuItems(parentId, tabid, sensitivity);
                dgDisplay.DataSource = dsSubmenu.Tables[0];
                dgDisplay.DataBind();
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        /// <summary>
        /// Method used to bind navigate URL
        /// </summary>
        /// <param name="Container"></param>
        /// <returns>string : Navigate URL</returns>
        public string GetURL(object Container)
        {
            
                string URL = "";
                URL = Global.UmbrellaSiteURL + DataBinder.Eval(Container, "DataItem.ModuleUrl").ToString();

                URL = "ModulePreprocessor.aspx?DestPage=" + Server.UrlEncode(PFC.Intranet.Securitylayer.Cryptor.Encrypt(URL)) + "&ModuleID=" + DataBinder.Eval(Container, "DataItem.ModuleID").ToString();
                return URL;

            }
        #endregion

            #region DashBoard Functionality

            protected void dgDisplay_ItemDataBound(object sender, DataGridItemEventArgs e)
        {

            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HyperLink lnk = e.Item.FindControl("HyperLink1") as HyperLink;

                if (e.Item.Cells[1].Text.ToLower() == "false")
                {
                    lnk.NavigateUrl = "#";
                    lnk.Attributes.Add("onclick", "OpenWin('" + e.Item.Cells[2].Text + "');");
                }
            }

        }
            #endregion
    }//End Class 
}//End Namespace

