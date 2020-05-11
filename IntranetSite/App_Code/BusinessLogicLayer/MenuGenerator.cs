/********************************************************************************************
 * Project				:	Umbrella 2.0
 * Specification Doc.   :   NA
 * File					:	MenuGenerator.cs
 * File Type			:	Class File
 * Description			:	Class which used to create dynamic menubar
 * History				: 
 * 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 20 July '05			Ver-1			Sathishvarn	 		Created
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
    public class MenuGenerator
    {
        #region Constants Declaration
        private const string SPGETTABS = "UCOR_SP_GetTabs";
        private const string SPGETPARENTITEMS = "UCOR_SP_ParentItems";
        //private const string SPGETSUBMENUITEMS = "UCOR_SP_Submenuitems";
        private const string SPGETSUBMENUITEMS = "UCOR_SP_GetSubMenuCategoryPFC";
        private const string SPGETSUBMENUCATEGORY = "UCOR_SP_GetSubMenuCategory";

        #endregion

        #region Variable Declaration        
        private string _HomePageURL = string.Empty;
        
        #endregion

        #region Methods
        /// <summary>
        /// Constructor
        /// </summary>
        public MenuGenerator()
        { }

        /// <summary>
        /// Function to get the TabNames according to the InterfaceID
        /// </summary>	
        public DataSet GetTabNames(int argInterfaceID, int UserID, int sesitivity)
        {
            DataSet dsTabNames = (DataSet)SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SPGETTABS,
                                                 new SqlParameter("@InterfaceID", argInterfaceID.ToString()),
                                                 new SqlParameter("@argUsedID", UserID.ToString()),
                                                 new SqlParameter("@intSensitivity", sesitivity.ToString()));

            return dsTabNames;
        }

        /// <summary>
        /// Function to Get the Parent Items to be Displayed for the current Tab
        /// </summary>
        public DataSet GetParentMenuItems(int argTabID, int argUsedID,int sesitivity)
        {
            DataSet dsParentMenuItem = (DataSet)SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SPGETPARENTITEMS,
                                                new SqlParameter("@intTabID", argTabID.ToString()),
                                                new SqlParameter("@argUserID", argUsedID.ToString()),
                                                new SqlParameter("@intSensitivity", sesitivity.ToString()));

            return dsParentMenuItem;
        }

        /// <summary>
        /// Function to Get the Sub menu category for given parentID
        /// </summary>
        public DataSet GetSubMenuCategory(int argParentItemID, int TabID, int sesitivity)
        {
            DataSet dsSubMenuItems = (DataSet)SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SPGETSUBMENUCATEGORY,
                                              new SqlParameter("@intParentID", argParentItemID.ToString()),
                                              new SqlParameter("@intTabID", TabID.ToString()),
                                              new SqlParameter("@intSensitivity", sesitivity.ToString()));

            return dsSubMenuItems;
        }

        /// <summary>
        /// Function to Get the menuitems for given parentID
        /// </summary>
        public DataSet GetSubMenuItems(int argParentItemID, int TabID, int sesitivity)
        {
            try
            {
                DataSet dsSubMenuItems = (DataSet)SqlHelper.ExecuteDataset(Global.UmbrellaConnectionString, SPGETSUBMENUITEMS,
                                                   new SqlParameter("@intParentID", argParentItemID.ToString()),
                                                   new SqlParameter("@intTabID", TabID.ToString()),
                                                   new SqlParameter("@intSensitivity", sesitivity.ToString()));

                return dsSubMenuItems;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
      
        #endregion
    }
}
