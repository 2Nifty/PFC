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

public partial class LeftFrame : System.Web.UI.UserControl
{
    EmployeeInfo employee = new EmployeeInfo();

    public string BindLocation
    {
        set
        {
            string whereCondition = value;

            BindLocationDetails(whereCondition);
            ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "Show", "javascript:LoadLocation();", true);
            UpdatePanel pnl = Page.FindControl("upnlMenu") as UpdatePanel;
            pnl.Update();
        }
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           BindLocationDetails(hidLocName.Value);

        }
    }

    public void BindLocationDetails(string whereCondition)
    {
        string whereClause = "";
        if (whereCondition != null && whereCondition != "")
        {
            whereClause = whereCondition;

        }
        else
            whereClause = "";
        try
        {

            MenuFrameTV.Nodes.Clear();
            DataTable dsDetails = employee.GetLocationView(whereClause);

            if (dsDetails != null && dsDetails.Rows.Count > 0)
            {
                TreeNode tvLoc = new TreeNode("Locations", "Locations");

                MenuFrameTV.Nodes.Add(tvLoc);
                tvLoc.SelectAction = TreeNodeSelectAction.Expand;
                string[] locName ={ "Location", "LocName" };
                DataTable dtLocName = dsDetails.DefaultView.ToTable(true, locName);
                dtLocName.DefaultView.Sort = "Location asc";
                DataTable dtUserName = dsDetails.Copy();
                DataTable dtDeptName = dsDetails.Copy();
                foreach (DataRow dr in dtLocName.Rows)
                {
                    TreeNode tvLocName = new TreeNode(dr["Location"].ToString(), dr["LocName"].ToString());
                    tvLoc.ChildNodes.Add(tvLocName);
                    tvLocName.SelectAction = TreeNodeSelectAction.Expand;

                    dtDeptName.DefaultView.RowFilter = "Location='" + dr["Location"].ToString() + "'";

                    DataTable dtDept =dtDeptName.DefaultView.ToTable(true, "Department");
                    foreach (DataRow drDept in dtDept.Rows)
                    {
                        TreeNode tvDeptName = new TreeNode(drDept["Department"].ToString(), drDept["Department"].ToString());
                        tvLocName.ChildNodes.Add(tvDeptName);
                        tvDeptName.SelectAction = TreeNodeSelectAction.Expand;

                        dtUserName.DefaultView.RowFilter = "Location='" + dr["Location"].ToString() + "' and Department='" + drDept["Department"].ToString() + "'";

                        string[] UserName ={ "UserName", "Name" };

                        DataTable dtUser = dtUserName.DefaultView.ToTable(true, UserName);

                        DataTable dtG = dsDetails.Copy();
                        foreach (DataRow drow in dtUser.Rows)
                        {
                            TreeNode tvUser = new TreeNode("<table> <tr><td ><img src=\"../EmployeeData/Common/images/folder.gif\" runat=Server />" + "</td><td style=\"cursor:hand;\" onclick=\"javascript:return GetUserName('" + drow["Name"].ToString() + "');\" >" + drow["Name"].ToString() + " - " + drow["UserName"].ToString() + "  </td></tr></table>", drow["Name"].ToString());
                            //TreeNode tvUser = new TreeNode("<div onclick=\"javascript:GetUserName('" + drow["Name"].ToString() + "');\">" + drow["Name"].ToString() + "-" + drow["UserName"].ToString(), drow["UserName"].ToString());
                            tvDeptName.ChildNodes.Add(tvUser);
                            tvUser.SelectAction = TreeNodeSelectAction.Expand;
                            dtG.DefaultView.RowFilter = "UserName='" + drow["UserName"].ToString() + "'";

                            DataTable dtGroup = dtG.DefaultView.ToTable(true, "GroupName");
                            //int UserID = Convert.ToInt32(dtUserName.Rows[0]["ID"].ToString());
                            //DataTable dtGroup = employee.GetUserGroup(UserID);
                            //if (dtGroup.Rows.Count > 0)
                            //{
                            foreach (DataRow drow1 in dtGroup.Rows)
                            {
                                TreeNode tvGroup = new TreeNode(drow1["GroupName"].ToString(), drow1["GroupName"].ToString());
                                // TreeNode tvGroup = new TreeNode(drow1["SecGroupApp"].ToString(), drow1["SecGroupApp"].ToString());
                                tvUser.ChildNodes.Add(tvGroup);
                                tvGroup.SelectAction = TreeNodeSelectAction.Expand;
                            }
                        }
                    }
                    }
                

            }
        }
        catch (Exception ex) { }
    }

    //public void BindLocationDetails(string location)
    //{
    //    string whereCondition = "";
    //    if (location != null && location != "")
    //    {
    //        whereCondition = "and (LocM.LocName)='" + location.Trim() + "'";

    //    }
    //    else
    //        whereCondition = "";
    //    try
    //    {

    //        MenuFrameTV.Nodes.Clear();
    //        DataTable dsDetails = employee.GetLocationView(whereCondition);

    //        if (dsDetails != null && dsDetails.Rows.Count > 0)
    //        {
    //            TreeNode tvLoc = new TreeNode("Locations", "Locations");

    //            MenuFrameTV.Nodes.Add(tvLoc);
    //            tvLoc.SelectAction = TreeNodeSelectAction.Expand;
    //            string[] locName ={ "Location", "LocName" };
    //            DataTable dtLocName = dsDetails.DefaultView.ToTable(true, locName);
    //            dtLocName.DefaultView.Sort = "Location asc";
    //            DataTable dtUserName = dsDetails.Copy();
    //            //DataTable dtDeptName = dsDetails.Copy();

    //            foreach (DataRow dr in dtLocName.Rows)
    //            {
    //                TreeNode tvLocName = new TreeNode(dr["Location"].ToString(), dr["LocName"].ToString());
    //                tvLoc.ChildNodes.Add(tvLocName);
    //                tvLocName.SelectAction = TreeNodeSelectAction.Expand;

    //                //dtDeptName.DefaultView.RowFilter = "Location='" + dr["Location"].ToString() + "'";
    //                //string[] Dept ={ "Department", "DepartmentNo" };
    //                //DataTable dtDept = dtDeptName.DefaultView.ToTable(true, Dept);

    //                //foreach (DataRow drDept in dtDept.Rows)
    //                //{
    //                //    TreeNode tvDeptName = new TreeNode(drDept["Department"].ToString(), drDept["DepartmentNo"].ToString());
    //                //    tvLocName.ChildNodes.Add(tvDeptName);
    //                //    tvDeptName.SelectAction = TreeNodeSelectAction.Expand;


    //                dtUserName.DefaultView.RowFilter = "Location='" + dr["Location"].ToString() + "'"; //"Department='" + drDept["Department"].ToString() + "' ";

    //                    string[] UserName ={ "UserName", "Name" };

    //                    DataTable dtUser = dtUserName.DefaultView.ToTable(true, UserName);

    //                    DataTable dtG = dsDetails.Copy();
    //                    foreach (DataRow drow in dtUser.Rows)
    //                    {
    //                        //TreeNode tvUser = new TreeNode("<div onclick=\"javascript:GetUserName('" + drow["Name"].ToString() + "');\"> <img src=\"../images/folder.gif\" runat=Server >" + drow["Name"].ToString() + "-" + drow["UserName"].ToString(), drow["Name"].ToString());
    //                        TreeNode tvUser = new TreeNode("<table> <tr><td ><img src=\"../EmployeeData/Common/images/folder.gif\" runat=Server />" + "</td><td  onclick=\"javascript:return GetUserName('" + drow["Name"].ToString() + "');\" >" + drow["Name"].ToString() + "- " + drow["UserName"].ToString() + "  </td></tr></table>", drow["Name"].ToString());
    //                        tvLocName.ChildNodes.Add(tvUser);
    //                        tvUser.SelectAction = TreeNodeSelectAction.Expand;
    //                        dtG.DefaultView.RowFilter = "UserName='" + drow["UserName"].ToString() + "'";

    //                        DataTable dtGroup = dtG.DefaultView.ToTable();
    //                        //int UserID = Convert.ToInt32(dtUserName.Rows[0]["ID"].ToString());
    //                        //DataTable dtGroup = employee.GetUserGroup(UserID);
    //                        //if (dtGroup.Rows.Count > 0)
    //                        //{
    //                        foreach (DataRow drow1 in dtGroup.Rows)
    //                        {
    //                            TreeNode tvGroup = new TreeNode(drow1["GroupName"].ToString(), drow1["GroupName"].ToString());
    //                            // TreeNode tvGroup = new TreeNode(drow1["SecGroupApp"].ToString(), drow1["SecGroupApp"].ToString());
    //                            tvUser.ChildNodes.Add(tvGroup);
    //                            tvGroup.SelectAction = TreeNodeSelectAction.Expand;
    //                        }
    //                        //}
    //                    }
    //                }

    //            }
            
    //    }
    //    catch (Exception ex) { }
    //}

    public void btnLocation_Click(object sender, EventArgs e)
    {
         string whereCondition ="";
        if (hidLocName.Value.Trim() != "")
        {
             whereCondition = " and (LocM.LocName)='" + hidLocName.Value.Trim() + "'";
        }
        else
        {
            whereCondition = "";
        }

        BindLocationDetails(whereCondition);
        Session["LocationName"] = hidLocName.Value;
        hidLocName.Value = "";
          
        ScriptManager.RegisterClientScriptBlock(this.Page, typeof(Page), "Show", "javascript:LoadLocation();", true);
        UpdatePanel pnl = Page.FindControl("upnlMenu") as UpdatePanel;
        //pnl.Update();
    }
   
   
}
