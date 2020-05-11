/********************************************************************************************
 * Project				:	Umbrella 2.0
 * Specification Doc.   :   NA
 * File					:	UserSession.cs
 * File Type			:	Class File
 * Description			:	
 * History				: 
 * 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 5 July '05			Ver-1			Sathishvarn	 		Created
 *********************************************************************************************/

using System;
using System.Web;
using System.Data;
using System.Web.SessionState;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;
namespace PFC.Intranet.BusinessLogicLayer
{
    /// <summary>
    /// Summary description for UserSession.
    /// </summary>
    public class UserSession : System.Web.UI.Page
    {

        #region Variable Declaration

        int intTerminalCount;
        int intSessionActive;

        #endregion

        #region Constant Declaration

        protected const string SPGENERALINSERT = "UGEN_SP_Insert";
        protected const string SPGENERALUPDATE = "UGEN_SP_Update";
        protected const string SPGENERALSELECT = "UGEN_SP_Select";
        protected const string TBLAPPSESSIONLOG = "UCOR_AppSessionLog";
        protected const string TBLUSERSETUP = "UCOR_Usersetup";
        protected const string SP_GETIDENTITYAFTERINSERT = "UGEN_SP_GetIdentityAfterInsert";

        #endregion

        #region Methods

        public UserSession()
        {
        }
        /// <summary>
        /// Insert Session details 
        /// </summary>
        public void InsertSession(string userID, string companyID, string UserName)
        {
            int Active = 1;
            string CreatedBy = UserName;
            string ModifiedBy = UserName;
            string URL = HttpContext.Current.Request.Path.ToString();
            //string Referer = HttpContext.Current.Request.UrlReferrer.ToString();
            string Referer = "";
            string RemoteHost = HttpContext.Current.Request.UserHostName.ToString();
            string UserAgent = HttpContext.Current.Request.UserAgent.ToString();
            string UALanguage = (HttpContext.Current.Request.UserLanguages != null) ? (HttpContext.Current.Request.UserLanguages.GetValue(0).ToString()) : "";
            string HostIP = HttpContext.Current.Request.UserHostAddress.ToString();
            int CompanyID = Int32.Parse(companyID);
            string WebStatus = "WebStatus";
            int newSessionCount;

            //
            //Get the Max SessionCount of the User
            //
            newSessionCount = GetSessionCount(userID);
            int SessionCount = newSessionCount + 1;
            HttpContext.Current.Cache["MaxSessionCount"] = SessionCount;
            //
            // Variable Declarations
            //
            string _tableName = TBLAPPSESSIONLOG;

            //
            // Assigning Columns and values data to be inserted into Ucor_usersessionlog table
            //
            string _columnNames = "UserID,CreatedBy,CreatedDate,ModifiedBy,ModifiedDate,StartTime,Active,URL,Referer,RemoteHost,UserAgent,UALanguage,SessionCount,HostIP,WebStatus,CompanyID";
            string _values =        userID + ",'" +
                                    CreatedBy + "','" +
                                    DateTime.Now.ToString() + "','" +
                                    CreatedBy + "','" +
                                    DateTime.Now.ToString() + "','" +
                                    DateTime.Now.ToString() + "'," +
                                    Active + ",'" +
                                    URL + "','" +
                                    Referer + "','" +
                                    RemoteHost + "','" +
                                    UserAgent + "','" +
                                    UALanguage + "'," +
                                    SessionCount + ",'" +
                                    HostIP + "','" +
                                    WebStatus + "'," +
                                    CompanyID;


            SqlDataReader sessionIDReader = (SqlDataReader)SqlHelper.ExecuteReader(Global.UmbrellaConnectionString,SP_GETIDENTITYAFTERINSERT,
                                                                new SqlParameter("@TableName", _tableName),
                                                                new SqlParameter("@columnNames", _columnNames),
                                                                new SqlParameter("@columnValues", _values));
            try
            {

                while (sessionIDReader.Read())
                {
                    //
                    // Get the Template id after inserting a value into Email Content Table
                    //
                    if (sessionIDReader[0] != null)
                        Session["SessionID"] = sessionIDReader[0].ToString();
                
                }
            }
            catch (Exception ex)
            {
            }
            finally
            {
                sessionIDReader.Close();
            }
        }
        /// <summary>
        /// Get Session count of the Logged in User
        /// </summary>
        public int GetSessionCount(string UserID)
        {
            string _tableName = TBLAPPSESSIONLOG;
            string _columnNames = "max(SessionCount)";
            string _whereClause = "UserID = " + UserID;

            //
            // Get maxcount data for this user
            //
       
            DataSet dsMaxCount = (DataSet)SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString,SPGENERALSELECT,
                                                   new SqlParameter("@tableName", _tableName),
                                                   new SqlParameter("@columnNames", _columnNames),
                                                   new SqlParameter("@whereClause", _whereClause));

            DataRow drMaxCount = dsMaxCount.Tables[0].Rows[0];

            if (drMaxCount[0] == DBNull.Value)
            {
                return 0;
            }
            else
            {
                //
                // Returns Number of terminals allocated for the User
                //
                int intMaxCount = Int32.Parse(drMaxCount[0].ToString());
                return intMaxCount;
            }
        }
        /// <summary>
        /// Update user session log
        /// </summary>
        public void UpdateSession()
        {
            try
            {
                DateTime KillTime = DateTime.Now;
                DateTime EndTime = DateTime.Now;
                //
                // Assigning Columns and whereclause values to be inserted into Ucor_usersessionlog table
                //
                string _tableName = TBLAPPSESSIONLOG;

                string _columnNames = "Active = 0" + "," +
                                      "killSessionDate ='" + DateTime.Now.ToString() + "'," +
                                      "EndTime ='" + DateTime.Now.ToString() + "'";

                string _whereClause = "SessionID=" + Session["SessionID"].ToString();

                //
                // updating Ucor_Appsesionlog Endtime field
                //
                SqlHelper.ExecuteNonQuery(Global.UmbrellaConnectionString, SPGENERALUPDATE,
                                        new SqlParameter("@tableName", _tableName),
                                        new SqlParameter("@columnNames", _columnNames),
                                        new SqlParameter("@whereClause", _whereClause));
            }
            catch (Exception ex)
            {

                throw;
            }       

           
        }
        /// <summary>
        /// Get Terminal count for the user
        /// </summary>
        public int GetTerminalCount(string UserID)
        {

            string _tableName = TBLUSERSETUP;
            string _columnNames = "terminals";
            string _whereClause = "UserID = " + UserID;

            //
            // Get number of terminals allocated for this user
            //
         
            DataSet dsTerminalCount = (DataSet)SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SPGENERALUPDATE,
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnNames),
                                    new SqlParameter("@whereClause", _whereClause));
            DataRow drTermanialCount = dsTerminalCount.Tables[0].Rows[0];
            intTerminalCount = Int32.Parse(drTermanialCount["terminals"].ToString());

            //
            // Returns Number of terminals allocated for the User
            //
            return intTerminalCount;
        }
        /// <summary>
        /// Get Active session count of the user
        /// </summary>
        public int GetActiveSession(string UserID)
        {
            //
            // Declare the variables
            //
            string _tableName = TBLAPPSESSIONLOG;
            string _columnNames = "Count(SessionCount)";
            string _whereClause = "UserID = " + UserID +
                                  " and  Active = 1";

            //
            // updating Ucor_Appsesionlog Endtime field
            //
            
            DataSet dsActiveSession = (DataSet)SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SPGENERALUPDATE,
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnNames),
                                    new SqlParameter("@whereClause", _whereClause));
            DataRow drActiveSession = dsActiveSession.Tables[0].Rows[0];
            intSessionActive = Int32.Parse(drActiveSession[0].ToString());

            //
            // Return Number of active connect already used by the User 
            //
            return intSessionActive;
        }
        /// <summary>
        /// Function to Continuously Check whether the User session is active or not
        /// </summary>	
        public DataSet CheckActiveSession()
        {
            //
            // Declare the variables
            //
            string _tableName = TBLAPPSESSIONLOG;
            string _columnNames = "Active";
            string _whereClause = "SessionID =" + Int32.Parse(Session["SessionID"].ToString());

            //
            // To get the Active Field value of the current session
            //
            string[,] parameter =	{
											{"@tableName", _tableName },
											{"@columnNames", _columnNames},
											{"@whereClause", _whereClause }
									};
            DataSet dsSessionStatus = (DataSet)SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SPGENERALUPDATE,
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnNames),
                                    new SqlParameter("@whereClause", _whereClause));
            DataRow drSessionStatus = dsSessionStatus.Tables[0].Rows[0];

            return dsSessionStatus;
        }
        public DataSet GetUserInformation(string userID)
        {
            //
            // Declare the variables
            //
            string _tableName = TBLUSERSETUP;
            string _columnNames = "UserName,UserID,Terminals";
            string _whereClause = "UserID = " + userID;

            //
            // To get the Active Field value of the current session
            //
            string[,] parameter =	{
											{"@tableName", _tableName },
											{"@columnNames", _columnNames},
											{"@whereClause", _whereClause }
										};
            DataSet dsUserName = (DataSet)SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SPGENERALUPDATE,
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnNames),
                                    new SqlParameter("@whereClause", _whereClause));
            return dsUserName;

        }

        #endregion

    }
}
