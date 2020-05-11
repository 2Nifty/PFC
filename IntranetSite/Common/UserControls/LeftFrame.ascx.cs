#region Namespaces
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
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer; 
#endregion

namespace PFC.Intranet.UserControls
{
    public partial class LeftFrame : System.Web.UI.UserControl
    {
        #region variable Declaration 
        // MenuGenerator Object declaration 
        MenuGenerator objMenuGenerator = new MenuGenerator();   
       
        #endregion

        #region Developer Code
        /// <summary>
        /// Method used to load menus based on the filter condition
        /// </summary>
        /// <param name="argTabID">Menu TabID</param>
        /// <param name="argUsedID">Iser ID</param>
        /// <param name="sesitivity">sesitivity</param>
        public void LoadMenu(int argTabID, int argUsedID, int sesitivity)
        {
            try
            {
                string  umbrellaURL = Global.UmbrellaSiteURL + "/Umbrella/kernel/PCOWINIEX.aspx"; 
                DataSet dtParentMenu = objMenuGenerator.GetParentMenuItems(argTabID, argUsedID, sesitivity);

                if (dtParentMenu.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in dtParentMenu.Tables[0].Rows)
                    {
                        MenuItem tabItem = new MenuItem((string)row["Name"]);

                        tabItem.ToolTip = row["Name"].ToString();
                        tabItem.Target = "bodyframe";

                        switch (row["ID"].ToString())
                        {
                            
                           // case "5567": // Inventory Management tab
                            //    tabItem.NavigateUrl = Global.IntranetSiteURL + "InvReportDashboard/InvReportsDashBoard.aspx";
                            //    break;
                            case "5947"://PFCPolicies                          
                                tabItem.NavigateUrl = Global.IntranetSiteURL + "SystemFrameSet/PFCVisionWOLogin.aspx";
                                break;
                            case "5615": // Web Administration
                                tabItem.NavigateUrl = umbrellaURL;
                                tabItem.Target = "_blank";
                                break;
                            //case "5549"://Financial Management
                            //case "5568"://Order Management
                            //case "5577"://Period Processing
                            //case "5578"://Procurement Management
                            case "5579"://Quality Assurance Management
                            case "5608"://Reports and Queries
                            case "5609"://HardWare Under knowledgeBase
                            case "5610"://Newsparts Under knowledgeBase
                            case "5614"://EDI                          
                                tabItem.NavigateUrl = Global.IntranetSiteURL + "SystemFrameSet/UnderConstruction.aspx";
                                break;
                            default:
                                tabItem.NavigateUrl = Global.IntranetSiteURL + "SystemFrameSet/BodyFrame.aspx?TabID=" + argTabID.ToString() + "&ParentID=" + row["ID"].ToString() + "&ParentMenuName=" + row["Name"].ToString();
                                break;
                        }
                        Menu1.Items.Add(tabItem);

                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        /// <summary>
        /// function to load the news menu
        /// </summary>
        /// <param name="menuID">Menu ID</param>
        public void LoadMenuNews(int menuID)
        {
            try
            {
                string strWhere = (menuID == 328) ? "status=1 and NewsTypeID=1" : "status=1 and NewsTypeID=2";

                DataSet dsNewsMenu = (DataSet)SqlHelper.ExecuteDataset(Global.QuotesSystemConnectionString, "UGEN_SP_Select",
                                              new SqlParameter("@tableName", "PFC_NewsMaster"),
                                              new SqlParameter("@columnNames", "Distinct NewsID,HeadLine,PlayFileName"),
                                              new SqlParameter("@whereClause", strWhere+" Order by NewsID desc"));
                foreach (DataRow dRow in dsNewsMenu.Tables[0].Rows)
                {
                    MenuItem tabItem = new MenuItem((string)dRow["HeadLine"]);

                    if (dRow["PlayFileName"].ToString() == string.Empty)
                    {
                        tabItem.NavigateUrl = Global.IntranetSiteURL + "News/News.aspx?NewsID='" + dRow["NewsID"].ToString() + "'&Type=" + dRow["HeadLine"].ToString();
                        tabItem.Target = "bodyframe";
                    }
                    else
                    {
                        tabItem.NavigateUrl = Global.UmbrellaSiteURL + "Applications/AppModule/PFCNews/NewsFiles/" + dRow["PlayFileName"].ToString();
                        tabItem.Target = "_blank";
                    }
                    Menu1.Items.Add(tabItem);
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        } 
        #endregion

    }// End Class

}// End Namespace
