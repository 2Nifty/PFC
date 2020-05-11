using System;
using System.Configuration;
using System.Collections;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;

namespace PFC.Intranet.Maintenance
{
    public partial class SecurityGroupsMaint : System.Web.UI.Page
    {
        string whereCondition, lockUser;
        Boolean DupRecord;
        DataTable dtGroups = new DataTable();

        SecurityGroups Groups = new SecurityGroups();
        MaintenanceUtility Maint = new MaintenanceUtility();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                Ajax.Utility.RegisterTypeForAjax(typeof(SecurityGroupsMaint));
                Session["SecLockStatus"] = "";
                Session["SecRecID"] = "";

                GetSecurity();

                btnDel.Visible = false;
                btnSave.Visible = false;
                btnCancel.Visible = false;
                pnlGroupInfo.Visible = false;
                if (hidSecurity.Value != "Full")
                    btnAdd.Visible = false;
                hidDupCheck.Value = "false";
                smSecGroups.SetFocus(txtSearch);

                whereCondition = "";
                tvBind();
                Groups.BindListValue("SecurityGrpApp", "-- Select --", ddlSecApp);
            }


            //--------------------------------------
                //btnAdd.Visible = true;
                //btnDel.Visible = true;
                //btnSave.Visible = true;
                //btnCancel.Visible = true;
                //pnlGroupInfo.Visible = true;
            //--------------------------------------

        }

        public void tvBind()
        {
            try
            {
                tvGroups.Nodes.Clear();

                dtGroups = Groups.GetGroups(whereCondition);

                if (dtGroups != null && dtGroups.Rows.Count > 0)
                {
                    TreeNode tnParent = new TreeNode("Groups", "Groups");

                    tvGroups.Nodes.Add(tnParent);
                    tnParent.SelectAction = TreeNodeSelectAction.Expand;

                    foreach (DataRow GroupRow in dtGroups.Rows)
                    {
                        string child = GroupRow["GroupName"].ToString();
                        if (!string.IsNullOrEmpty(GroupRow["SecurityGroupApp"].ToString().Trim()))
                            child = child + " - " + GroupRow["SecurityGroupApp"].ToString();

                        TreeNode tnChild = new TreeNode(child, GroupRow["ID"].ToString());

                        tnParent.ChildNodes.Add(tnChild);
                        tnChild.SelectAction = TreeNodeSelectAction.SelectExpand;
                    }

                    if (whereCondition != "")
                        lblSearch.Text = dtGroups.Rows.Count.ToString().Trim() + " records found";
                }
            }
            catch (Exception ex) { }
        }

        protected void tvGroups_SelectedNodeChanged(object sender, EventArgs e)
        {
            Maint.ReleaseLock("SecurityGroups", Session["SecRecID"].ToString(), "Sec", Session["SecLockStatus"].ToString());

            hidMode.Value = "Edit";
            whereCondition = " AND pSecGroupID = " + tvGroups.SelectedNode.Value.ToString();
            dtGroups = Groups.GetGroups(whereCondition);

            if (dtGroups != null && dtGroups.Rows.Count > 0)
            {
                hidDupCheck.Value = "false";
                ShowGroupInfo();
            }
        }

        public void btnSearch_Click(object sender, ImageClickEventArgs e)
        {
            Maint.ReleaseLock("SecurityGroups", Session["SecRecID"].ToString(), "Sec", Session["SecLockStatus"].ToString());

            lblMessage.Text = "";
            pnlStatus.Update();
            
            hidMode.Value = "Search";
            lblSearch.Text = "";
            HideGroupInfo();

            if (string.IsNullOrEmpty(txtSearch.Text.ToString().Trim()))
                whereCondition = "";
            else
                if (ddlSearch.SelectedValue == "Group")
                    whereCondition = " AND GroupName LIKE '%" + txtSearch.Text.ToString().Trim() + "%'";
                else
                    whereCondition = " AND SecurityGroupApp LIKE '%" + txtSearch.Text.ToString().Trim() + "%'";
            hidWhere.Value = whereCondition.ToString();

            tvBind();

            if (dtGroups.Rows.Count == 1)
                ShowGroupInfo();

            if (dtGroups == null || dtGroups.Rows.Count <= 0)
            {
                DisplaStatusMessage("No Records Found", "fail");
                whereCondition = "";
                tvBind();
            }

            txtSearch.Text = "";
            tvGroups.ExpandAll();
            pnlTree.Update();
            pnlSearchResult.Update();
        }

        protected void ShowGroupInfo()
        {
            lblMessage.Text = "";
            pnlStatus.Update();
            
            lblGroupID.Text = dtGroups.Rows[0]["ID"].ToString();
            Session["SecRecID"] = dtGroups.Rows[0]["ID"].ToString();
            txtName.Text = dtGroups.Rows[0]["GroupName"].ToString();
            ListItem lItem = ddlSecApp.Items.FindByValue(dtGroups.Rows[0]["SecurityGroupApp"].ToString().Trim()) as ListItem;
            if (lItem != null)
                ddlSecApp.SelectedValue = dtGroups.Rows[0]["SecurityGroupApp"].ToString().Trim();
            txtDesc.Text = dtGroups.Rows[0]["GroupDesc"].ToString();
            txtComments.Text = dtGroups.Rows[0]["Comments"].ToString();

            hidRecID.Value = dtGroups.Rows[0]["ID"].ToString();
            CheckLock();
            if (Session["SecLockStatus"].ToString() == "L")
                ScriptManager.RegisterClientScriptBlock(pnlGroupInfo, typeof(UpdatePanel), "Script", "alert('Record Locked By " + lockUser.ToString() + " - QUERY ONLY');", true);

            btnCancel.Visible = true;
            if (hidSecurity.Value == "Full" && Session["SecLockStatus"].ToString() != "L")
            {
                btnDel.Visible = true;
                btnSave.Visible = true;
            }
            else
            {
                btnDel.Visible = false;
                btnSave.Visible = false;
            }
            pnlBottom.Update();

            pnlGroupInfo.Visible = true;
            smSecGroups.SetFocus(txtName);
            pnlGroupInfo.Update();

        }

        protected void HideGroupInfo()
        {
            lblGroupID.Text = "";
            txtName.Text = "";
            ddlSecApp.SelectedIndex = 0;
            txtDesc.Text = "";
            txtComments.Text = "";

            btnDel.Visible = false;
            if (hidMode.Value == "Add")
            {
                hidDupCheck.Value = "true";
                btnCancel.Visible = true;
                btnSave.Visible = true;
                pnlGroupInfo.Visible = true;
                smSecGroups.SetFocus(txtName);
            }
            else
            {
                hidDupCheck.Value = "false";
                btnCancel.Visible = false;
                btnSave.Visible = false;
                pnlGroupInfo.Visible = false;
                smSecGroups.SetFocus(txtSearch);
            }

            pnlGroupInfo.Update();
            pnlBottom.Update();
        }

        private void RefreshTree()
        {
            lblSearch.Text = "";
            if (!string.IsNullOrEmpty(hidWhere.Value.ToString()))
                whereCondition = hidWhere.Value.ToString();
            tvBind();
            tvGroups.ExpandAll();
            pnlTree.Update();
            pnlSearchResult.Update();
        }

        protected void txtName_TextChanged(object sender, EventArgs e)
        {
            hidDupCheck.Value = "true";
        }

        public void btnAdd_Click(object sender, ImageClickEventArgs e)
        {
            Maint.ReleaseLock("SecurityGroups", Session["SecRecID"].ToString(), "Sec", Session["SecLockStatus"].ToString());

            lblMessage.Text = "";
            pnlStatus.Update();

            hidMode.Value = "Add";
            HideGroupInfo();
            hidWhere.Value = "";
            whereCondition = "";
            RefreshTree();

            smSecGroups.SetFocus(txtName);
            pnlGroupInfo.Update();
        }

        public void btnSave_Click(object sender, ImageClickEventArgs e)
        {
            DupRecord = false;
            if (hidDupCheck.Value == "true")
                DupRecord = CheckDup();

            if (DupRecord == true)
                DisplaStatusMessage("Record " + dtGroups.Rows[0]["GroupName"].ToString() + " already on file", "fail");
            else
            {
                if (hidMode.Value == "Add")
                {
                    string columnNames = "GroupName, SecurityGroupApp, GroupDesc, Comments, EntryID, EntryDt";
                    string columnValues = "'" + txtName.Text.Trim().Replace("'", "''") + "'," +
                                          "'" + ddlSecApp.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                          "'" + txtDesc.Text.Trim().Replace("'", "''") + "'," +
                                          "'" + txtComments.Text.Trim().Replace("'", "''") + "'," +
                                          "'" + Session["UserName"].ToString().Trim() + "'," +
                                          "'" + DateTime.Now.ToString() + "'";
                    Groups.InsertSecurityGroups(columnNames, columnValues);
                    DisplaStatusMessage("Record Added", "success");
                    HideGroupInfo();
                    if (lblSearch.Text == "" || lblSearch.Text == "1 records found")
                    {
                        hidWhere.Value = "";
                        whereCondition = "";
                    }
                    RefreshTree();
                }
                else
                {
                    string updateValue = "GroupName = '" + txtName.Text.Trim().Replace("'", "''") + "'," +
                                        "SecurityGroupApp = '" + ddlSecApp.SelectedItem.Value.Trim().Replace("'", "''") + "'," +
                                        "GroupDesc = '" + txtDesc.Text.Trim().Replace("'", "''") + "'," +
                                        "Comments = '" + txtComments.Text.Trim().Replace("'", "''") + "'," +
                                        "ChangeID ='" + Session["UserName"].ToString().Trim() + "'," +
                                        "ChangeDt ='" + DateTime.Now.ToString() + "'";
                    string whereclause = "pSecGroupID = " + Session["SecRecID"].ToString();
                    Groups.UpdateSecurityGroups(updateValue, whereclause);
                    DisplaStatusMessage("Record Updated", "success");
                    HideGroupInfo();
                    if (lblSearch.Text == "" || lblSearch.Text == "1 records found")
                    {
                        hidWhere.Value = "";
                        whereCondition = "";
                    }
                    RefreshTree();
                    Maint.ReleaseLock("SecurityGroups", Session["SecRecID"].ToString(), "Sec", Session["SecLockStatus"].ToString());
                }
            }
        }

        public void btnDel_Click(object sender, ImageClickEventArgs e)
        {
            if (hidDelConf.Value == "true")
            {
                hidMode.Value = "Del";
                string updateValue = "DeleteDt='" + DateTime.Now.ToString() + "'";
                string whereclause = "pSecGroupID=" + Session["SecRecID"].ToString();
                Groups.UpdateSecurityGroups(updateValue, whereclause);
                DisplaStatusMessage("Record Deleted", "success");
                HideGroupInfo();
                if (lblSearch.Text == "" || lblSearch.Text == "1 records found")
                {
                    hidWhere.Value = "";
                    whereCondition = "";
                }
                RefreshTree();
                Maint.ReleaseLock("SecurityGroups", Session["SecRecID"].ToString(), "Sec", Session["SecLockStatus"].ToString());
            }
        }

        public void btnCancel_Click(object sender, ImageClickEventArgs e)
        {
            Maint.ReleaseLock("SecurityGroups", Session["SecRecID"].ToString(), "Sec", Session["SecLockStatus"].ToString());

            lblMessage.Text = "";
            pnlStatus.Update();

            hidMode.Value = "";
            HideGroupInfo();
            if (lblSearch.Text == "" || lblSearch.Text == "1 records found")
            {
                hidWhere.Value = "";
                whereCondition = "";
            }
            RefreshTree();
        }

        private void GetSecurity()
        {
            hidSecurity.Value = Maint.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.SecurityGroups);
            if (hidSecurity.Value.ToString() == "")
                hidSecurity.Value = "Query";
            else
                hidSecurity.Value = "Full";

            //Response.Write(Session["UserName"].ToString());
            //Response.Write("<br>");
            //Response.Write(hidSecurity.Value.ToString());

            if (hidSecurity.Value.ToString() == "None")
                Response.Redirect("~/Common/ErrorPage/unauthorizedpage.aspx", true);
        }

        private void DisplaStatusMessage(string message, string messageType)
        {
            lblMessage.Visible = true;
            if (messageType.ToLower() == "success")
            {
                lblMessage.ForeColor = System.Drawing.Color.Green;
                lblMessage.Text = message;
            }
            else if (messageType.ToLower() == "fail")
            {
                lblMessage.ForeColor = System.Drawing.Color.Red;
                lblMessage.Text = message;
            }
            pnlStatus.Update();
        }

        private Boolean CheckDup()
        {
            lblMessage.Text = "";
            pnlStatus.Update();

            //Check if record already exists
            //Checks only the GroupName data that appears before the '('
            string enteredGroup = txtName.Text.Trim().Replace("'", "''");
            if (enteredGroup.IndexOf("(") > 0)
                enteredGroup = enteredGroup.Substring(0, enteredGroup.IndexOf("(")).Trim();

            whereCondition = " AND '" + enteredGroup + "' = " +
                             " CASE WHEN CHARINDEX('(', GroupName) > 0" +
                             " AND CHARINDEX('(', GroupName) < LEN(RTRIM(GroupName))-1" +
                             " THEN RTRIM(LEFT(GroupName, CHARINDEX('(', GroupName)-1))" +
                             " ELSE RTRIM(GroupName) END";
            dtGroups = Groups.GetGroups(whereCondition);

            if (dtGroups != null && dtGroups.Rows.Count > 0)
                return true;
            else
                return false;
        }

        public void CheckLock()
        {
            //if (!string.IsNullOrEmpty(Session["SecRecID"].ToString()))
                Maint.ReleaseLock("SecurityGroups", Session["SecRecID"].ToString(), "Sec", Session["SecLockStatus"].ToString());
            Session["SecRecID"] = hidRecID.Value;
            DataTable dtLock = Maint.SetLock("SecurityGroups", Session["SecRecID"].ToString(), "Sec");
            Session["SecLockStatus"] = dtLock.DefaultView.ToTable().Rows[0]["Status"].ToString();
            lockUser = dtLock.DefaultView.ToTable().Rows[0]["EntryID"].ToString();
        }

        [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
        public void ReleaseLock()
        {
            Maint.ReleaseLock("SecurityGroups", Session["SecRecID"].ToString(), "Sec", Session["SecLockStatus"].ToString());
        }
    }
}