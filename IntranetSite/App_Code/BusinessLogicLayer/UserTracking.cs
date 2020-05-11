/********************************************************************************************
 * Project				:	Umbrella 2.0
 * Specification Doc.   :   NA
 * File					:	UserTracking.cs
 * File Type			:	Class File
 * Description			:	Class which used to track the User data  
 * History				: 
 * 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 25 July '05			Ver-1			Sathishvarn	 		Created
 *********************************************************************************************/


using System;
using System.Web;
using System.ComponentModel;
using System.Net;
using System.Web.SessionState;
using System.Web.UI;
using System.Diagnostics;
using System.Data;
using System.Data.SqlClient;
using System.Data.Common;
using System.Data.SqlTypes;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;


namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for UserTracking.
    /// </summary>
    public class UserTracking : System.Web.UI.Page
    {

        #region Constant Declaration

        public const string SPGENERALINSERT = "UGEN_SP_Insert";
        public const string SPGENERALUPDATE = "UGEN_SP_Update";
        public const string TBL_USERSESSIONLOG = "UCOR_UserSessionlog";       

        #endregion

        #region Methods

        public UserTracking()
        { 
        }

        /// <summary>
        /// Function to insert User details to Ucor_usersessionlog table
        /// </summary>
        public void TrackPageEntry(string moduleID)
        {
            //
            // Variable Declarations
            //
            int _SesionID = Int32.Parse(Session["SessionID"].ToString());
            string _URL = HttpContext.Current.Request.Path.ToString();

            //
            // Assigning Columns and values data to be inserted into Ucor_usersessionlog table
            //
            string _columnNames = "SessionID,UserID,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,ModuleID,StartTime,URL,CompanyID";
            string _values = _SesionID + "," +
                                    Session["UserID"].ToString() + ",'" +
                                    Session["UserName"].ToString() + "','" +
                                    DateTime.Now.Date.ToString() + "','" +
                                    Session["UserName"].ToString() + "','" +
                                    DateTime.Now.Date.ToString() + "'," +
                                    moduleID + ",'" +
                                    DateTime.Now.ToString() + "','" +
                                    _URL + "'," +
                                    Session["CompanyID"].ToString();

            SqlHelper.ExecuteNonQuery(Global.UmbrellaConnectionString, SPGENERALINSERT,
                                        new SqlParameter("@tableName", TBL_USERSESSIONLOG),
                                        new SqlParameter("@columnNames", _columnNames),
                                        new SqlParameter("@columnValues", _values)
                                      );
        }     
        
        #endregion
    }
}
