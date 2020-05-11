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

public partial class User : System.Web.UI.UserControl
{
    EmployeeInfo employee = new EmployeeInfo();

   
    public string SelectedNode
    {
        set
        {
            SetSelectedNode(value);           
        }
        
    }
    public string UserInfo
    {
        set { ViewState["UserInfo"] = value;
                BindUser();
               
                UpdatePanel pnl = Page.FindControl("upnlMenu") as UpdatePanel;
                pnl.Update();
        }
    }
    public string UserInfoOnSearch
    {
        set
        {   ViewState["UserSearch"] = value;
            BindUser();
           
            UpdatePanel pnl = Page.FindControl("upnlMenu") as UpdatePanel;
            pnl.Update();
        }
    }

    public string UserBind
    {
        set
        {
            ViewState["Value"] = value;
            BindUser();
        }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)//|| hidLeftFrameBindMode.Value!="Click")
        {
            BindUser();
        }
    }


    public void BindUser()
    {
        try
        {
            
             string whereCondition="";
            MenuFrameTV.Nodes.Clear();
            if (ViewState["UserInfo"] != null && ViewState["UserInfo"].ToString() != "")
            {
                whereCondition = " and  EM.EmployeeName like '" + ViewState["UserInfo"].ToString() + "%'";
                ViewState["UserInfo"] = "";
            }
            else if (ViewState["UserSearch"] != null && ViewState["UserSearch"].ToString() != "")
            {
                whereCondition = " and  EM.EmployeeName in (" + ViewState["UserSearch"].ToString() + ")";
                ViewState["UserSearch"] = "";
            }
            else
            {
                whereCondition = "";
            }
               
             DataTable dsDetails  = employee.GetUser(whereCondition); //);

            if (dsDetails != null && dsDetails.Rows.Count > 0)
            {

                TreeNode tvUser = new TreeNode("All Users", "Users");

                MenuFrameTV.Nodes.Add(tvUser);
                tvUser.SelectAction = TreeNodeSelectAction.Expand;

                DataTable dt = dsDetails.Copy();

                DataTable dtLocName = dsDetails.DefaultView.ToTable(true, "UserName");
                dtLocName.DefaultView.Sort = "UserName asc";
                
                foreach (DataRow drow in dtLocName.Rows)
                {
                    dt.DefaultView.RowFilter = "UserName='" + drow["UserName"].ToString() + "'";

                    DataTable dtUserName = dt.DefaultView.ToTable();
                    //DataTable dtG = dsDetails.Copy();

                    TreeNode tvUserName = new TreeNode("<table><tr><td width=200px style=\"cursor:hand;\" onclick=\"javascript:return GetUserName('" + dtUserName.Rows[0]["Name"].ToString() + "');\" >" + dtUserName.Rows[0]["Name"].ToString() + " - " + dtUserName.Rows[0]["UserName"].ToString() + "  </td><td style=\"text-decoration:underline;padding-left:5px;cursor:hand;white-space: nowrap;\" onclick=\"javascript:return UserLocation('" + dtUserName.Rows[0]["LocName"].ToString() + "','" + dtUserName.Rows[0]["Name"].ToString() + "'); \"><font style=\"white-space: nowrap;\">" + dtUserName.Rows[0]["Location"].ToString() + "</font></td></tr></table>", dtUserName.Rows[0]["Name"].ToString());
                   
                    tvUser.ChildNodes.Add(tvUserName);
                    tvUserName.SelectAction = TreeNodeSelectAction.Expand;

                    
                    dt.DefaultView.RowFilter = "UserName='" + dtUserName.Rows[0]["UserName"].ToString() + "'";

                    int UserID = Convert.ToInt32(dtUserName.Rows[0]["ID"].ToString());
                    DataTable dtGroup = employee.GetUserGroup(UserID.ToString());
                    if (dtGroup != null && dtGroup.Rows.Count > 0)
                        {
                        foreach (DataRow drow1 in dtGroup.Rows)
                        {
                            // TreeNode tvGroup = new TreeNode(drow1["GroupName"].ToString(), drow1["GroupName"].ToString());
                            TreeNode tvGroup = new TreeNode(drow1["SecurityGroupApp"].ToString(), drow1["SecurityGroupApp"].ToString());
                            tvUserName.ChildNodes.Add(tvGroup);
                            tvGroup.SelectAction = TreeNodeSelectAction.Expand;
                        }
                    }
                    else
                    {
                        TreeNode tvGroup = new TreeNode("","");
                        tvUserName.ChildNodes.Add(tvGroup);
                        tvGroup.SelectAction = TreeNodeSelectAction.Expand;
                    }
                }
            }
        }
        catch (Exception ex) { }
    }

    /// <summary>
    /// Function to expand the Parent
    /// </summary>
    /// <param name="Node"></param>
    public void SetSelectedNode(string Node)
    {
        try
        {

            foreach (TreeNode tn in MenuFrameTV.Nodes)
            {
                if (tn.Value.Trim() == Node.Trim())
                {
                    tn.Selected = true; 
                    tn.Expand();
                    break;
                }
                else
                    CheckChildNode(tn, Node);
               
            }

        }
        catch (Exception ex) { }
    }

    /// <summary>
    /// function to expand the child node
    /// </summary>
    /// <param name="tnCheck"></param>
    /// <param name="nodeValue"></param>
    public void CheckChildNode(TreeNode tnCheck, string nodeValue)
    {
        try
        {

            foreach (TreeNode tn in tnCheck.ChildNodes)
            {
                if (tn.Value.Trim() == nodeValue.Trim())
                {
                    tn.Selected = true;
                    tn.Parent.Expand();
                    tn.ExpandAll();


                    //if (tn.Parent.Parent != null)
                    //{
                    //    tn.Parent.Parent.ExpandAll();
                    //    if (tn.Parent.Parent.Parent != null)
                    //    {
                    //        tn.Parent.Parent.ExpandAll();
                    //        tn.Parent.Parent.Parent.ExpandAll();
                    //    }
                    //}
                    break;

                }
                else
                    CheckChildNode(tn, nodeValue);
            }
        }
        catch (Exception ex) { }
    }


    #region User
    //public void BindLocationDetails()
    //{
    //    try
    //    {
    //        MenuFrameTV.Nodes.Clear();
    //        DataTable dsDetails = employee.GetLocationView();

    //        if (dsDetails != null && dsDetails.Rows.Count > 0)
    //        {
    //            TreeNode tvLoc = new TreeNode("Locations", "Locations");

    //            MenuFrameTV.Nodes.Add(tvLoc);
    //            tvLoc.SelectAction = TreeNodeSelectAction.Expand;

    //            DataTable dtLocName = dsDetails.DefaultView.ToTable(true, "Location");
    //            dtLocName.DefaultView.Sort = "Location asc";
    //            DataTable dtUserName = dsDetails.Copy();
    //            foreach (DataRow dr in dtLocName.Rows)
    //            {
    //                TreeNode tvLocName = new TreeNode(dr["Location"].ToString(), dr["Location"].ToString());
    //                tvLoc.ChildNodes.Add(tvLocName);
    //                tvLocName.SelectAction = TreeNodeSelectAction.Expand;

    //                dtUserName.DefaultView.RowFilter = "Location='" + dr["Location"].ToString() + "'";

    //                string[] UserName ={ "UserName", "Name" };

    //                DataTable dtUser = dtUserName.DefaultView.ToTable(true, UserName);

    //                DataTable dtG = dsDetails.Copy();
    //                foreach (DataRow drow in dtUser.Rows)
    //                {
    //                    TreeNode tvUser = new TreeNode(drow["Name"].ToString() + "-" + drow["UserName"].ToString(), drow["UserName"].ToString());
    //                    tvLocName.ChildNodes.Add(tvUser);
    //                    tvUser.SelectAction = TreeNodeSelectAction.Expand;
    //                    dtG.DefaultView.RowFilter = "UserName='" + drow["UserName"].ToString() + "'";

    //                    DataTable dtGroup = dtG.DefaultView.ToTable();

    //                    foreach (DataRow drow1 in dtGroup.Rows)
    //                    {
    //                        TreeNode tvGroup = new TreeNode(drow1["GroupName"].ToString(), drow1["GroupName"].ToString());
    //                        tvUser.ChildNodes.Add(tvGroup);
    //                        tvGroup.SelectAction = TreeNodeSelectAction.Expand;
    //                    }
    //                }
    //            }
    //        }
    //    }
    //    catch (Exception ex) { }
    //}


   
    //public void BindUser()
    //{
    //    try
    //    {
    //        MenuFrameTV.Nodes.Clear();
    //        DataTable dsDetails = employee.GetUser();

    //        if (dsDetails != null && dsDetails.Rows.Count > 0)
    //        {

    //            TreeNode tvLoc = new TreeNode("AllUsers", "Users");

    //            MenuFrameTV.Nodes.Add(tvLoc);
    //            tvLoc.SelectAction = TreeNodeSelectAction.Expand;

    //            DataTable dtLocName = dsDetails.DefaultView.ToTable(true, "UserName");
    //            dtLocName.DefaultView.Sort = "UserName asc";
    //            DataTable dt = dsDetails.Copy();
    //            DataTable dtG = dsDetails.Copy();
    //            foreach (DataRow dr in dsDetails.Rows)
    //            {
    //                TreeNode tvLocName = new TreeNode(dr["Name"].ToString() + "-" + dr["UserName"].ToString() + " " + "<div  style=\"text-decoration:underline;\" onclick=\"javascript:UserLocation('" + dr["Location"].ToString() + "'); \"> " + dr["Location"].ToString() + "</div>", dr["ID"].ToString());
    //                tvLoc.ChildNodes.Add(tvLocName);
    //                tvLocName.SelectAction = TreeNodeSelectAction.Expand;

    //                // tvUser.SelectAction = TreeNodeSelectAction.Expand;
    //                dtG.DefaultView.RowFilter = "UserName='" + dr["UserName"].ToString() + "'";

    //                DataTable dtGroup = dtG.DefaultView.ToTable();

    //                foreach (DataRow drow1 in dtGroup.Rows)
    //                {
    //                    TreeNode tvGroup = new TreeNode(drow1["GroupName"].ToString(), drow1["GroupName"].ToString());
    //                    tvLoc.ChildNodes.Add(tvGroup);
    //                    tvGroup.SelectAction = TreeNodeSelectAction.Expand;
    //                }
    //            }
    //        }
    //    }
    //    catch (Exception ex) { }
    //}
    #endregion 
    
}
