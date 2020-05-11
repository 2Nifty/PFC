#region Namespace
using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
#endregion

namespace PFC.Intranet
{
    public partial class UserFavourite : System.Web.UI.Page
    {
        #region Constant Declaration
        public const string SP_GENERALSELECT = "UGEN_SP_Select";
        public const string SP_GENERALINSERT = "UGEN_SP_Insert";
        public const string SP_GENERALDELETE = "UGEN_SP_Delete";
        public const string SP_GENERALUPDATE = "UGEN_SP_Update";

        SystemCheck systemCheck = new SystemCheck();
        #endregion

        /// <summary>
        /// Page Load Event handlers
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                systemCheck.SessionCheck();
                if (!Page.IsPostBack)
                {
                    ViewState["UserDetail"] = null;
                    if (Request.QueryString["Mode"] != null)
                        GetMode();

                    ViewState["OpMode"] = "Add";
                }
            }
            catch (Exception ex)
            {
            }
        }

        #region  Developer Code
        /// <summary>
        /// Method used to get mode of operation
        /// </summary>
        private void GetMode()
        {
            try
            {
                if (Request.QueryString["Mode"].ToString() == "ShortCuts")
                {
                    LoadModules();
                    LoadShortcuts();
                    tdShortcuts.Visible = true;
                    dggShortcuts.Visible = true;
                }
                else if (Request.QueryString["Mode"].ToString() == "Favourite")
                {
                    LoadFavourite();
                    tdFavourite.Visible = true;
                    dggFavourite.Visible = true;

                }
                else if (Request.QueryString["Mode"].ToString() == "DoList")
                {
                    LoadDolist();
                    tdDoList.Visible = true;
                    dggDolist.Visible = true;
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        /// <summary>
        /// Method used to load Modules
        /// </summary>
        private void LoadModules()
        {
            try
            {
                // Local variable declaration
                string _tableName = "UCOR_ModuleSetup,UCOR_MenuItems";
                string _columnName = "distinct UCOR_ModuleSetup.ModuleName as ModuleName,UCOR_ModuleSetup.ModuleID as ModuleID";
                string _whereClause = "UCOR_ModuleSetup.[InterfaceID] = '" + Global.IntranetInterfaceID.ToString() + "' and UCOR_ModuleSetup.[Published]='1' and UCOR_ModuleSetup.ModuleID=UCOR_MenuItems.ModuleId and UCOR_MenuItems.Sesnsitivity <=" + Session["MaxSensitivity"].ToString() + " Order by UCOR_ModuleSetup.ModuleName Asc";

                DataSet UserInfo = SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));


                // Check whether any value has returned
                if (UserInfo.Tables[0].Rows.Count > 0)
                {
                    ddlmoduleName.DataSource = UserInfo.Tables[0];
                    ddlmoduleName.DataTextField = "ModuleName";
                    ddlmoduleName.DataValueField = "ModuleID";
                    ddlmoduleName.DataBind();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// Method used to Load Module URL
        /// </summary>
        /// <returns>string :Navigate URL</returns>
        private string GetModuleURL()
        {
            try
            {
                string _tableName = "UCOR_ModuleSetup";
                string _columnName = "ModuleURL";
                string _whereClause = "[InterfaceID] = '" + Global.IntranetInterfaceID.ToString() + "' and  [ModuleID] = '" + ddlmoduleName.SelectedValue.ToString() + "'";

                string moduleURL = (string)SqlHelper.ExecuteScalar(Global.UmbrellaConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));
                return moduleURL;
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        /// <summary>
        /// Method used to load shortcuts
        /// </summary>
        private void LoadShortcuts()
        {
            try
            {
                // Local variable declaration
                string _tableName = "PFC_UserFavourites";
                string _columnName = "[ID],[Content],[ModuleID],[NavigateURL],Description";
                string _whereClause = "[UserID] = '" + Session["UserID"].ToString() + "' and [Mode]=1 order by CreatedDate desc";

                DataSet dsuserShortcuts = SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));


                // Check whether any value has returned
                if (dsuserShortcuts.Tables[0].Rows.Count > 0)
                {
                    ViewState["UserDetail"] = dsuserShortcuts.Tables[0];
                    dgShortcuts.DataSource = dsuserShortcuts.Tables[0];
                    dgShortcuts.DataBind();
                    dgShortcuts.Visible = true;
                }
                else
                {
                    dgShortcuts.Visible = false;
                }
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        /// <summary>
        /// Method used to load Favourite
        /// </summary>
        private void LoadFavourite()
        {
            try
            {
                // Local variable declaration
                string _tableName = "PFC_UserFavourites";
                string _columnName = "[ID],[Content],[NavigateURL]";
                string _whereClause = "[UserID] = '" + Session["UserID"].ToString() + "' and Mode=2 order by CreatedDate desc";

                DataSet dsuserFavourites = SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));


                // Check whether any value has returned
                if (dsuserFavourites.Tables[0].Rows.Count > 0)
                {
                    ViewState["UserDetail"] = dsuserFavourites.Tables[0];
                    dgFavourites.DataSource = dsuserFavourites.Tables[0];
                    dgFavourites.DataBind();
                    dgFavourites.Visible = true;
                }
                else
                {
                    dgFavourites.Visible = false;
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        /// <summary>
        /// Method used to load Dolist
        /// </summary>
        private void LoadDolist()
        {
            try
            {
                // Local variable declaration
                string _tableName = "PFC_UserFavourites";
                string _columnName = "ID,[Content],Description";
                string _whereClause = "[UserID] = '" + Session["UserID"].ToString() + "' and Mode=3 order by CreatedDate desc";

                DataSet dsuserDolist = SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SP_GENERALSELECT,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@columnNames", _columnName),
                                                new SqlParameter("@whereCondition", _whereClause));


                // Check whether any value has returned
                if (dsuserDolist.Tables[0].Rows.Count > 0)
                {
                    ViewState["UserDetail"] = dsuserDolist.Tables[0];
                    dgList.DataSource = dsuserDolist.Tables[0];
                    dgList.DataBind();
                    dgList.Visible = true;
                }
                else
                {
                    dgList.Visible = false;
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        #endregion

        #region Shortcuts
        /// <summary>
        /// ibtnshortcut_Click:Used to add shortcuts
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ibtnshortcut_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                string _tableName = "PFC_UserFavourites";
                //
                // Assigning Columns and values data to be inserted into PFC_UserFavourites table
                //
                string ModuleURL = GetModuleURL();

                if (ViewState["OpMode"] != null)
                {
                    if (ViewState["OpMode"].ToString() == "Add")
                    {
                        string _columnNames = "UserID,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Mode,ModuleID,[Content],CompanyID,NavigateURL,Description";
                        string _values = "'" + Session["UserID"].ToString() + "','" +
                                                Session["UserName"].ToString() + "','" +
                                                DateTime.Now.ToString() + "','" +
                                                Session["UserName"].ToString() + "','" +
                                                DateTime.Now.ToString() + "'," +
                                                1 + ",'" +
                                                ddlmoduleName.SelectedValue.ToString() + "','" +
                                                txtShortcutName.Text + "','" +
                                                Session["CompanyID"].ToString() + "','" +
                                                ModuleURL + "','"+
                                                txtShortcutDesc.Text +"'";

                        SqlHelper.ExecuteNonQuery(Global.UmbrellaConnectionString, SP_GENERALINSERT,
                                                                            new SqlParameter("@TableName", _tableName),
                                                                            new SqlParameter("@columnNames", _columnNames),
                                                                            new SqlParameter("@columnValues", _values));
                    }
                    else if (ViewState["OpMode"].ToString() == "Edit")
                    {
                        string _whereClause = "ID =" + ViewState["IDValue"].ToString();
                        string _values = "UserID ='" + Session["UserID"].ToString() + "',ModifiedBy='" +
                                                Session["UserName"].ToString() + "',ModifiedDate='" +
                                                DateTime.Now.ToString() + "',Mode=" +
                                                1 + ",ModuleID='" +
                                                ddlmoduleName.SelectedValue.ToString() + "',[Content]='" +
                                                txtShortcutName.Text + "',CompanyID='" +
                                                Session["CompanyID"].ToString() + "',NavigateURL='" +
                                                ModuleURL + "',Description='"+txtShortcutDesc.Text +"'";
                        SqlHelper.ExecuteNonQuery(Global.UmbrellaConnectionString, SP_GENERALUPDATE,
                                                                           new SqlParameter("@tableName", _tableName),
                                                                           new SqlParameter("@columnNames", _values),
                                                                           new SqlParameter("@whereClause", _whereClause));
                        ViewState["OpMode"] = "Add";
                    }

                }
                LoadShortcuts();
                txtShortcutDesc.Text = "";
                txtShortcutName.Text = "";
                Page.RegisterClientScriptBlock("Dashboard", "<script>RefreshPage();</script>");
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        /// <summary>
        /// dgShortcuts_EditCommand: Method used to edit shortcuts
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void dgShortcuts_EditCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                Label lblId = e.Item.Cells[0].Controls[1] as Label;
                DataTable dtShort = (DataTable)ViewState["UserDetail"];
                DataRow[] drShort = dtShort.Select("ID='" + lblId.Text + "'");
                txtShortcutName.Text = drShort[0]["Content"].ToString();
                ddlmoduleName.SelectedValue = drShort[0]["ModuleID"].ToString();
                txtShortcutDesc.Text = drShort[0]["Description"].ToString();
                ViewState["OpMode"] = "Edit";
                ViewState["IDValue"] = lblId.Text;
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        /// <summary>
        /// dgShortcuts_DeleteCommand:Used to delete shortcut
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void dgShortcuts_DeleteCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                // Local variable declaration
                string _tableName = "PFC_UserFavourites";
                Label lblId = e.Item.Cells[0].Controls[1] as Label;
                string _whereClause = "[ID] =" + lblId.Text;

                SqlHelper.ExecuteNonQuery(Global.UmbrellaConnectionString, SP_GENERALDELETE,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@whereClause", _whereClause));
                dgShortcuts.CurrentPageIndex = 0;
                LoadShortcuts();
                Page.RegisterClientScriptBlock("Dashboard", "<script>RefreshPage();</script>");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// dgShortcuts_PageIndexChanged:Method used to Load data page wise
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void dgShortcuts_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
        {
            try
            {
                dgShortcuts.CurrentPageIndex = e.NewPageIndex;
                dgShortcuts.DataSource = (DataTable)ViewState["UserDetail"];
                dgShortcuts.DataBind();
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        #endregion

        #region Favourite
        /// <summary>
        /// ibtnfavourite_Click:Used to add favourite
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ibtnfavourite_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                string _tableName = "PFC_UserFavourites";
                //
                // Assigning Columns and values data to be inserted into PFC_UserFavourites table
                //


                if (ViewState["OpMode"] != null)
                {
                    if (ViewState["OpMode"].ToString() == "Add")
                    {
                        string _columnNames = "UserID,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Mode,[Content],CompanyID,NavigateURL";
                        string _values = "'" + Session["UserID"].ToString() + "','" +
                                                Session["UserName"].ToString() + "','" +
                                                DateTime.Now.ToString() + "','" +
                                                Session["UserName"].ToString() + "','" +
                                                DateTime.Now.ToString() + "'," +
                                                2 + ",'" +
                                                txtFavorite.Text + "','" +
                                                Session["CompanyID"].ToString() + "','" +
                                                txtFavouriteURl.Text + "'";

                        SqlHelper.ExecuteNonQuery(Global.UmbrellaConnectionString, SP_GENERALINSERT,
                                                                            new SqlParameter("@TableName", _tableName),
                                                                            new SqlParameter("@columnNames", _columnNames),
                                                                            new SqlParameter("@columnValues", _values));
                    }
                    else if (ViewState["OpMode"].ToString() == "Edit")
                    {
                        string _whereClause = "ID =" + ViewState["IDValue"].ToString();
                        string _values = "UserID ='" + Session["UserID"].ToString() + "',ModifiedBy='" +
                                                Session["UserName"].ToString() + "',ModifiedDate='" +
                                                DateTime.Now.ToString() + "',Mode=" +
                                                2 + ",[Content]='" +
                                                txtFavorite.Text + "',CompanyID='" +
                                                Session["CompanyID"].ToString() + "',NavigateURL='" +
                                                txtFavouriteURl.Text + "'";

                        SqlHelper.ExecuteNonQuery(Global.UmbrellaConnectionString, SP_GENERALUPDATE,
                                                                           new SqlParameter("@tableName", _tableName),
                                                                           new SqlParameter("@columnNames", _values),
                                                                           new SqlParameter("@whereClause", _whereClause));
                        ViewState["OpMode"] = "Add";
                        ViewState["IDValue"] = null;
                    }

                }
                LoadFavourite();
                txtFavorite.Text = "";
                txtFavouriteURl.Text = "";
                Page.RegisterClientScriptBlock("Dashboard", "<script>RefreshPage();</script>");
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        /// <summary>
        /// dgFavourites_DeleteCommand:Used to delete favourite
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void dgFavourites_DeleteCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                // Local variable declaration
                string _tableName = "PFC_UserFavourites";
                Label lblId = e.Item.Cells[0].Controls[1] as Label;
                string _whereClause = "[ID] =" + lblId.Text;

                SqlHelper.ExecuteNonQuery(Global.UmbrellaConnectionString, SP_GENERALDELETE,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@whereClause", _whereClause));
                dgFavourites.CurrentPageIndex = 0;
                LoadFavourite();
                Page.RegisterClientScriptBlock("Dashboard", "<script>RefreshPage();</script>");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// dgFavourites_EditCommand: Method used to edit favourite
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void dgFavourites_EditCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                Label lblId = e.Item.Cells[0].Controls[1] as Label;
                DataTable dtShort = (DataTable)ViewState["UserDetail"];
                DataRow[] drShort = dtShort.Select("ID='" + lblId.Text + "'");
                txtFavorite.Text = drShort[0]["Content"].ToString();
                txtFavouriteURl.Text = drShort[0]["NavigateURL"].ToString();
                ViewState["OpMode"] = "Edit";
                ViewState["IDValue"] = lblId.Text;
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        /// <summary>
        /// dgFavourites_PageIndexChanged:Method used to Load data page wise
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void dgFavourites_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
        {
            try
            {
                dgFavourites.CurrentPageIndex = e.NewPageIndex;
                dgFavourites.DataSource = (DataTable)ViewState["UserDetail"];
                dgFavourites.DataBind();
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        #endregion

        #region Dolist
        /// <summary>
        /// dgList_PageIndexChanged:Method used to Load data page wise
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void dgList_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = e.NewPageIndex;
                dgList.DataSource = (DataTable)ViewState["UserDetail"];
                dgList.DataBind();

            }
            catch (Exception ex)
            {

                throw;
            }
        }
        /// <summary>
        /// dgList_DeleteCommand:Used to delete dolist
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void dgList_DeleteCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                // Local variable declaration
                string _tableName = "PFC_UserFavourites";
                Label lblId = e.Item.Cells[0].Controls[1] as Label;
                string _whereClause = "[ID] =" + lblId.Text;

                SqlHelper.ExecuteNonQuery(Global.UmbrellaConnectionString, SP_GENERALDELETE,
                                                new SqlParameter("@tableName", _tableName),
                                                new SqlParameter("@whereClause", _whereClause));
                dgList.CurrentPageIndex = 0;
                LoadDolist();
                Page.RegisterClientScriptBlock("Dashboard", "<script>RefreshPage();</script>");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        /// <summary>
        /// dgList_EditCommand: Method used to edit dolist
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void dgList_EditCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                Label lblId = e.Item.Cells[0].Controls[1] as Label;
                DataTable dtShort = (DataTable)ViewState["UserDetail"];
                DataRow[] drShort = dtShort.Select("ID='" + lblId.Text + "'");
                txtdolist.Text = drShort[0]["Content"].ToString();
                txtdolistdesc.Text = drShort[0]["Description"].ToString();
                ViewState["OpMode"] = "Edit";
                ViewState["IDValue"] = lblId.Text;
                //Response.Write(drShort[0]["Description"].ToString());
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        /// <summary>
        /// ibtnDoList_Click:Used to add list
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void ibtnDoList_Click(object sender, ImageClickEventArgs e)
        {
            try
            {
                string _tableName = "PFC_UserFavourites";
                //
                // Assigning Columns and values data to be inserted into PFC_UserFavourites table
                //


                if (ViewState["OpMode"] != null)
                {
                    if (ViewState["OpMode"].ToString() == "Add")
                    {
                        string _columnNames = "UserID,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,Mode,[Content],CompanyID,Description";
                        string _values = "'" + Session["UserID"].ToString() + "','" +
                                                Session["UserName"].ToString() + "','" +
                                                DateTime.Now.ToString() + "','" +
                                                Session["UserName"].ToString() + "','" +
                                                DateTime.Now.ToString() + "'," +
                                                3 + ",'" +
                                                txtdolist.Text + "','" +
                                                Session["CompanyID"].ToString() + "','"+
                                                txtdolistdesc.Text + "'";

                        SqlHelper.ExecuteNonQuery(Global.UmbrellaConnectionString, SP_GENERALINSERT,
                                                                            new SqlParameter("@TableName", _tableName),
                                                                            new SqlParameter("@columnNames", _columnNames),
                                                                            new SqlParameter("@columnValues", _values));
                    }
                    else if (ViewState["OpMode"].ToString() == "Edit")
                    {
                        string _whereClause = "ID =" + ViewState["IDValue"].ToString();
                        string _values = "UserID ='" + Session["UserID"].ToString() + "',ModifiedBy='" +
                                                Session["UserName"].ToString() + "',ModifiedDate='" +
                                                DateTime.Now.ToString() + "',Mode=" +
                                                3 + ",[Content]='" +
                                                txtdolist.Text + "',CompanyID='" +
                                                Session["CompanyID"].ToString() + "',Description='" +
                                                txtdolistdesc.Text + "'";

                        SqlHelper.ExecuteNonQuery(Global.UmbrellaConnectionString, SP_GENERALUPDATE,
                                                                           new SqlParameter("@tableName", _tableName),
                                                                           new SqlParameter("@columnNames", _values),
                                                                           new SqlParameter("@whereClause", _whereClause));
                        ViewState["OpMode"] = "Add";
                        ViewState["IDValue"] = null;
                    }

                }
                LoadDolist();
                txtdolist.Text = "";
                txtdolistdesc.Text = "";
                Page.RegisterClientScriptBlock("Dashboard", "<script>RefreshPage();</script>");
            }
            catch (Exception ex)
            {

                throw;
            }
        }
        /// <summary>
        /// dgList_ItemCommand:Item command event handler
        /// </summary>
        /// <param name="source"></param>
        /// <param name="e"></param>
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.DataItem != null)
            {
                Label lblButton = e.Item.Cells[2].Controls[1] as Label;
                lblButton.Text = e.Item.Cells[2].Text;
                if (DataBinder.Eval(e.Item.DataItem, "Description").ToString().Length > 30)
                    lblButton.Text = DataBinder.Eval(e.Item.DataItem, "Description").ToString().Substring(0, 30);
                else
                    lblButton.Text = DataBinder.Eval(e.Item.DataItem, "Description").ToString();

            }
        }
        #endregion

     
} 
}//End Class
