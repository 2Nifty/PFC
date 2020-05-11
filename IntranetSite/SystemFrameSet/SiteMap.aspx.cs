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
using PFC.Intranet.BusinessLogicLayer;

public partial class SystemFrameSet_SiteMap : System.Web.UI.Page
{
    private const string MODULECHECKPATH = "Systemframeset/";
    private int userID = 0;
    private int sensitivity = 0;
    int iLinkFlag = 0;
    //
    // Create Objects for calling common functions
    //
    MenuGenerator menuGenerator = new MenuGenerator();

    protected void Page_Load(object sender, EventArgs e)
    {
        userID = Convert.ToInt32(Session["UserID"].ToString().Trim());
        sensitivity = Convert.ToInt32(Session["MaxSensitivity"].ToString().Trim());
        
        if (!IsPostBack)
            FillTreeView();
    }

    /// <summary>
    /// Fill TreeView Items
    /// </summary>
    private void FillTreeView()
    {
        try
        {
            // 
            // Calling a function to get Tabs to be displayed for this User
            //
            DataSet dsTabNames = menuGenerator.GetTabNames(Convert.ToInt32(PFC.Intranet.Global.IntranetInterfaceID), userID, sensitivity);

            // Dividing the menu items
            int iTotalRows = dsTabNames.Tables[0].Rows.Count;
            int iFirstDLRow = iTotalRows / 3;
            int iSecondDLRow = iFirstDLRow + iFirstDLRow;

            DataTable dtTabName = new DataTable();
            DataTable dtTabName1 = new DataTable();
            DataTable dtTabName2 = new DataTable();

            dtTabName.Columns.Add("Name");
            dtTabName.Columns.Add("TabID");
            dtTabName.Columns.Add("Mouseoutcolour");
            dtTabName.Columns.Add("Mouseovercolour");

            dtTabName1.Columns.Add("Name");
            dtTabName1.Columns.Add("TabID");
            dtTabName1.Columns.Add("Mouseoutcolour");
            dtTabName1.Columns.Add("Mouseovercolour");

            dtTabName2.Columns.Add("Name");
            dtTabName2.Columns.Add("TabID");
            dtTabName2.Columns.Add("Mouseoutcolour");
            dtTabName2.Columns.Add("Mouseovercolour");

            for (int i = 0; i < dsTabNames.Tables[0].Rows.Count; i++)
            {
                if (i < iFirstDLRow)
                {
                    DataRow drTable = dtTabName.NewRow();
                    drTable[0] = dsTabNames.Tables[0].Rows[i]["Name"].ToString();
                    drTable[1] = dsTabNames.Tables[0].Rows[i]["TabID"].ToString();
                    drTable[2] = dsTabNames.Tables[0].Rows[i]["Mouseoutcolour"].ToString();
                    drTable[3] = dsTabNames.Tables[0].Rows[i]["Mouseovercolour"].ToString();
                    dtTabName.Rows.Add(drTable);
                }
                else if (i < iSecondDLRow)
                {
                    DataRow drTable = dtTabName1.NewRow();
                    drTable[0] = dsTabNames.Tables[0].Rows[i]["Name"].ToString();
                    drTable[1] = dsTabNames.Tables[0].Rows[i]["TabID"].ToString();
                    drTable[2] = dsTabNames.Tables[0].Rows[i]["Mouseoutcolour"].ToString();
                    drTable[3] = dsTabNames.Tables[0].Rows[i]["Mouseovercolour"].ToString();
                    dtTabName1.Rows.Add(drTable);
                }
                else
                {
                    DataRow drTable = dtTabName2.NewRow();
                    drTable[0] = dsTabNames.Tables[0].Rows[i]["Name"].ToString();
                    drTable[1] = dsTabNames.Tables[0].Rows[i]["TabID"].ToString();
                    drTable[2] = dsTabNames.Tables[0].Rows[i]["Mouseoutcolour"].ToString();
                    drTable[3] = dsTabNames.Tables[0].Rows[i]["Mouseovercolour"].ToString();
                    dtTabName2.Rows.Add(drTable);
                }
            }

            dlMenuTab.DataSource = dtTabName;
            dlMenuTab.DataBind();

            dlMenuTab1.DataSource = dtTabName1;
            dlMenuTab1.DataBind();

            dlMenuTab2.DataSource = dtTabName2;
            dlMenuTab2.DataBind();

        }
        catch (Exception ex)
        {
        }

    }

    protected void dlMenuTab_ItemDataBound(object sender, DataListItemEventArgs e)
    {
        if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
        {
            Label lblTab = e.Item.FindControl("lblMenuTab") as Label;
            TreeView tvMenu = e.Item.FindControl("MenuFrameTV") as TreeView;
            HiddenField hidTabID = e.Item.FindControl("hidTabID") as HiddenField;
            BuildMenuTree(tvMenu, Convert.ToInt32(hidTabID.Value.Trim()));

        }
    }

    /// <summary>
    /// Build TreeView using Recursive concept
    /// </summary>
    /// <CreatedBy>Shiva</CreatedBy>
    /// <alteredBy>mahesh For TreeView</alteredBy>
    /// <param name="menuItemID"></param>
    /// <param name="tabID"></param>
    private void BuildMenuTree(TreeView tvMenu, int tabID)
    {
        try
        {            
            //
            // Menu Item
            //            
            DataSet dsParentMenuID = menuGenerator.GetParentMenuItems(tabID, userID, sensitivity);
            DataTable dtParentMenuID = dsParentMenuID.Tables[0];

            //
            // Check whether there exist any rows
            //
            if (dtParentMenuID.Rows.Count > 0)
            {
                //
                // Loop trough each row and add the menu item
                //
                foreach (DataRow parentRow in dtParentMenuID.Rows)
                {
                    //
                    // Add the menu item
                    //
                    TreeNode tvMenuItem = new TreeNode((string)parentRow["Name"]);
                    tvMenu.Nodes.Add(tvMenuItem);
                    tvMenuItem.SelectAction = TreeNodeSelectAction.Expand;
                    tvMenuItem.ToolTip = ((string)parentRow["Name"]);
                    string parentName = (string)parentRow["Name"];

                    // ----------------------------------------------------------------------
                    // Check whether next level exist before binding the URL to the item (Level 2)
                    // ----------------------------------------------------------------------
                    int parentTabID = Convert.ToInt32(parentRow["TabID"].ToString());
                    int parentID = Convert.ToInt32(parentRow["ID"].ToString());
                    string mouseOutColor = parentRow["MouseOutColour"].ToString();

                    iLinkFlag = 0;
                    //
                    // Build the child TreeView menus
                    //
                    BuildSubMenus(tvMenuItem, parentID, parentTabID, mouseOutColor, parentName);

                }
            }
            
        }
        catch (Exception ex)
        {
            //ProcessMonitor.InsertProcessMonitor("MenuFrame.aspx", "1.0", "System", "Kernel", "BuildMenuTree()", "", ex.Message.ToString(), "Failed");
        }
    }

    /// <summary>
    /// Recursive routine which builds the child level menus
    /// </summary>
    /// <CreatedBy>Shiva</CreatedBy>
    /// <alteredBy>mahesh For TreeView</alteredBy>
    /// <param name="tvMenuItem"></param>
    /// <param name="tabID"></param>
    private void BuildSubMenus(TreeNode tvMenuItem, int parentID, int parentTabID, string mouseOutColor, string parentMenuName)
    {
        try
        {
            DataSet dsSubMenu = menuGenerator.GetSubMenuCategory(parentID, parentTabID, sensitivity);
            DataTable dtSubMenu = dsSubMenu.Tables[0];

            if (dtSubMenu.Rows.Count > 0)
            {
                foreach (DataRow SubmenuRow in dtSubMenu.Rows)
                {
                    //
                    // condition to check where the module is pubished or released
                    //
                    if (SubmenuRow["Published"].ToString().ToLower() == "true" || SubmenuRow["ModuleID"].ToString() == "0")
                    {
                        //
                        // Add the menu item
                        //
                        TreeNode tvSubMenuitem = new TreeNode(SubmenuRow["Name"].ToString());
                        tvMenuItem.ChildNodes.Add(tvSubMenuitem);
                        tvSubMenuitem.SelectAction = TreeNodeSelectAction.Expand;
                        tvSubMenuitem.ToolTip = SubmenuRow["Name"].ToString();
                        string parentName = SubmenuRow["Name"].ToString();

                        //
                        // Bind the URL and set the target frame
                        //
                        if (SubmenuRow["ModuleURL"].ToString() != string.Empty)
                        {
                            switch (SubmenuRow["ID"].ToString())
                            {                               
                                //case "5549"://Financial Management
                                case "5568"://Order Management
                                case "5579"://Quality Assurance Management
                                case "5608"://Reports and Queries
                                case "5609"://HardWare Under knowledgeBase
                                case "5610"://Newsparts Under knowledgeBase
                                case "5614"://EDI                          
                                    tvSubMenuitem.NavigateUrl = Global.IntranetSiteURL + "SystemFrameSet/UnderConstruction.aspx";
                                    break;
                                default:                                    
                                    tvSubMenuitem.NavigateUrl = Global.UmbrellaSiteURL + SubmenuRow["ModuleURL"].ToString();
                                    break;
                            }
                        }

                        //
                        // Now check for child levels and call the function itself
                        //
                        int currentTabID = Convert.ToInt32(SubmenuRow["TabID"].ToString());
                        int currentParentID = Convert.ToInt32(SubmenuRow["ID"].ToString());

                        DataSet dsTempSubMenu = menuGenerator.GetSubMenuCategory(currentParentID, currentTabID, sensitivity);
                        if (dsTempSubMenu.Tables[0].Rows.Count == 0)
                            iLinkFlag = 1;
                        else
                            iLinkFlag = 0;
                        //
                        // Call the function recursively for further sublevel items
                        //
                        BuildMenuItems(tvSubMenuitem, currentParentID, currentTabID, mouseOutColor, parentName);
                    }
                }
            }
            else
            {
                if(parentID == 5615)
                {
                    tvMenuItem.NavigateUrl = Global.UmbrellaSiteURL + "/Umbrella/kernel/PCOWINIEX.aspx";
                    tvMenuItem.Target = "_blank";                        
                }
                else if (parentID == 5567) // Inventory Management tab
                    tvMenuItem.NavigateUrl = Global.IntranetSiteURL + "InvReportDashboard/InvReportsDashBoard.aspx";
                
                //                    
                // Add the menu item
                //
                if (iLinkFlag == 0)
                {

                    TreeNode tvSubMenuitem = new TreeNode("<i>No links found</i>");
                    tvMenuItem.ChildNodes.Add(tvSubMenuitem);
                    tvSubMenuitem.SelectAction = TreeNodeSelectAction.Expand;
                    tvSubMenuitem.ToolTip = "No links found";
                    iLinkFlag = 0;
                }
            }
        }
        catch (Exception ex)
        {            
        }
    }
    /// <summary>
    /// Bind menu items (last level node in tree view)
    /// </summary>
    /// <param name="tvMenuItem"></param>
    /// <param name="parentID"></param>
    /// <param name="parentTabID"></param>
    /// <param name="mouseOutColor"></param>
    /// <param name="parentMenuName"></param>
    private void BuildMenuItems(TreeNode tvMenuItem, int parentID, int parentTabID, string mouseOutColor, string parentMenuName)
    {
        try
        {
            DataSet dsSubMenu = menuGenerator.GetSubMenuCategory(parentID, parentTabID, sensitivity);
            DataTable dtSubMenu = dsSubMenu.Tables[0];

            if (dtSubMenu.Rows.Count > 0)
            {
                foreach (DataRow SubmenuRow in dtSubMenu.Rows)
                {
                    //
                    // condition to check where the module is pubished or released
                    //
                    if (SubmenuRow["Published"].ToString().ToLower() == "true" || SubmenuRow["ModuleID"].ToString() == "0")
                    {
                        //
                        // Add the menu item
                        //
                        TreeNode tvSubMenuitem = new TreeNode(SubmenuRow["Name"].ToString());
                        tvMenuItem.ChildNodes.Add(tvSubMenuitem);
                        tvSubMenuitem.SelectAction = TreeNodeSelectAction.Expand;
                        tvSubMenuitem.ToolTip = SubmenuRow["Name"].ToString();
                        string parentName = SubmenuRow["Name"].ToString();
                        tvSubMenuitem.NavigateUrl = Global.UmbrellaSiteURL +  SubmenuRow["ModuleURL"].ToString();                                                                     
                        
                    }
                }
            }
            else
            {
                //
                // Add the menu item
                //
                if (iLinkFlag == 0)
                {
                    TreeNode tvSubMenuitem = new TreeNode("No links Found");
                    tvMenuItem.ChildNodes.Add(tvSubMenuitem);
                    tvSubMenuitem.SelectAction = TreeNodeSelectAction.Expand;
                    tvSubMenuitem.ToolTip = "No links Found";
                    iLinkFlag = 0;
                }
            }
        }
        catch (Exception ex)
        {
        }
    }
}
