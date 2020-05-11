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
using System.IO;
#endregion

namespace PFC.Intranet
{
    public partial class TopFrame : System.Web.UI.Page
    {
        /// <summary>
        /// Page Load Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {
            Ajax.Utility.RegisterTypeForAjax(typeof(TopFrame));
            try
            {
                if (Session["UserID"] != null && Session["MaxSensitivity"] != null)
                {
                    int userId = Convert.ToInt16(Session["UserID"].ToString());
                    int sensitivity = Convert.ToInt16(Session["MaxSensitivity"].ToString());
                    Header1.LoadTab(userId, sensitivity);
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }


        #region Ajax Function To Delete The Excel Files

        [Ajax.AjaxMethod()]
        public string DeleteExcel(string strSession)
        {
            try
            {

                DirectoryInfo drExcel = new DirectoryInfo(Server.MapPath("..\\Common\\ExcelUploads"));

                foreach (FileInfo fn in drExcel.GetFiles())
                {
                    if (fn.Name.Contains(strSession))
                        fn.Delete();
                }

                return "";
            }
            catch (Exception ex) { return ""; }
        }

        #endregion
    } 
}
