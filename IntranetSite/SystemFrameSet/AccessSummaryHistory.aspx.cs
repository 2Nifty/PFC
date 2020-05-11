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

        // object declaration
        UserValidation objUser = new UserValidation();
        #endregion



        #region Page load Event

        /// <summary>
        /// Page Load Event handlers
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!Page.IsPostBack)
                {
                    BindDataGrid();
                }
            }
            catch (Exception ex)
            {


            }
        }

        #endregion
        private void BindDataGrid()
        {
            try
            {
                DataSet dsUserStatistics = objUser.DisplayUserStatisticsHistory(Session["CompanyID"].ToString(), Session["UserID"].ToString());
                if (dsUserStatistics.Tables[0] != null)
                {
                    dgAccessHistory.DataSource = dsUserStatistics.Tables[0];
                    dgAccessHistory.DataBind();
                }
                
            }
            catch (Exception ex)
            {

                throw;
            }
        }

        #region Event Handler
        protected void dgAccessHistory_PageIndexChanged(object source, DataGridPageChangedEventArgs e)
        {
            dgAccessHistory.CurrentPageIndex = e.NewPageIndex;
            BindDataGrid();
        } 
        #endregion
    } //End Class

}//End Namespace

