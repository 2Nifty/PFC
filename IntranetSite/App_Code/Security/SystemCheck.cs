/********************************************************************************************
 * Project				:	Umbrella 2.0
 * Specification Doc.   :   NA
 * File					:	SystemCheck.cs
 * File Type			:	Class File
 * Description			:	Class which is used to check all the functionalities of kernel
 * History				: 
 * 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 16 August '05		Ver-1			Shiva		 		Created
 *********************************************************************************************/

using System;
using System.Web;


namespace PFC.Intranet.Securitylayer
{
    /// <summary>
    /// Summary description for SystemCheck.
    /// </summary>
    public class SystemCheck : System.Web.UI.Page
    {
        /// <summary>
        /// Constructor
        /// </summary>
        public SystemCheck()
        {
        }
     

        /// <summary>
        /// Function to check Session validity
        /// 1. It checks for valid session ID
        /// 2. It also checks for user not to change the query string manually
        /// </summary>
        public void SessionCheck()
        {
            #region Variables
            //
            // Check Session with SessionID
            //
          

            if (Session["SessionID"] == null)
            {
                HttpContext.Current.Response.Redirect(PFC.Intranet.Global.IntranetSiteURL + "/SystemFrameSet/SessionOut.aspx");
            }
            #endregion
        }
    }
}
