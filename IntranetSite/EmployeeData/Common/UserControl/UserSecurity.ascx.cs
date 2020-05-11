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

public partial class UserSecurityData : System.Web.UI.UserControl
{
    EmployeeInfo employee = new EmployeeInfo();
    int User =0;

    public string UserName
    {
        get { return hidUser.Value.Trim(); }
        set { lblUser.Text = value; hidUser.Value = value; }
   
    }

    public string UserID
    {
        get { return hidUserIDVal.Value.Trim(); }
        set
        {
            if (value != "")
            {
                hidUserIDVal.Value = value;
                User = Convert.ToInt32(hidUserIDVal.Value);
                BindSecurityGrid();
                BindUserGrid();
                BindUserPermission();
            }
        }
    }

    public string NewUserSecurity
    {
        set 
        {
            ViewState["Mode"] = value;
            ClearControl();
            BindUserGrid();
            BindSecurityGrid();
            ibtnSave.Visible = (Session["Security"] != "") ? true : false;
        }
    }

    public string Mode
    {
        set { ViewState["Mode"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    private void BindSecurityGrid()
    {
        DataTable dtSecurity = employee.GetSecurityGroups(UserID);
        if (dtSecurity != null && dtSecurity.Rows.Count > 0)
        {
            gvSecurityGroups.DataSource = dtSecurity;
            gvSecurityGroups.DataBind();
        }
        else
        {
            gvSecurityGroups.DataSource = "";
            gvSecurityGroups.DataBind();
        }
       
    }

    private void BindUserPermission()
    {
        ClearControl();
        DataTable dtUserPermis = employee.GetUserData(User.ToString());
        if (dtUserPermis != null && dtUserPermis.Rows.Count > 0)
        {
            lblUserName.Text = dtUserPermis.Rows[0]["UserName"].ToString();
            SelectItem(rdlAP, dtUserPermis.Rows[0]["APApplicationInd"].ToString());
            SelectItem(rdlAR, dtUserPermis.Rows[0]["ARApplicationInd"].ToString());
            SelectItem(rdlGL, dtUserPermis.Rows[0]["GLApplicationInd"].ToString());
            SelectItem(rdlIM, dtUserPermis.Rows[0]["IMApplicationInd"].ToString());
            SelectItem(rdlPOE, dtUserPermis.Rows[0]["POApplicationInd"].ToString());
            SelectItem(rdlSOE, dtUserPermis.Rows[0]["OEApplicationInd"].ToString());

        }
    }

    private void BindUserGrid()
    {
        DataTable dtUser = employee.GetUserGroup(UserID);
        if (dtUser != null && dtUser.Rows.Count > 0)
        {
            gvUserGroup.DataSource = dtUser;
            gvUserGroup.DataBind();
        }
        else
        { 
            gvUserGroup.DataSource = "";
            gvUserGroup.DataBind();
        }
        upnlGroupGrid.Update();
        upnlSecurityGrid.Update();
        upnlPermGrid.Update();
    }   
    
    protected void gvSecurityGroups_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        e.Row.ToolTip = "Select the permission you wants grant for " + lblUser.Text + ".";
                        //"Drag & drop them to User Group section.";

        e.Row.Attributes.Add("onclick", "javascript:SelectSecurityItem(this,'`" + e.Row.Cells[0].Text + ",');");
        e.Row.Attributes.Add("onDblclick", "javascript:SelectSecurityItem(this,'`" + e.Row.Cells[0].Text + ",');UpdateUser();");
       
    }

    protected void btnUserUpdate_Click(object sender, EventArgs e)
    {
        User = Convert.ToInt32(hidUserIDVal.Value);
        hidValue.Value  = hidValue.Value.Replace("`", "");
        string  groupID = hidValue.Value.Replace(",","','");

        string whereCond = " and psecGroupID in ('" + groupID.Remove(groupID.Length - 3, 3) + "')";

        //InsertUserGroup
        string columnValue = "";
        DataTable dtUpdate = employee.GetSecurityData(UserID, whereCond);

        //string secUserId = employee.GetSecUserID(lblUserName.Text);

            //string columnvalues = "'" + User + "','" + lblUserName.Text + "','"+Session["UserName"].ToString()+"','"+ DateTime.Now.ToShortDateString()+"'";
            //secUserId = employee.InsertSecurityUser(columnvalues);
       
       
        foreach (DataRow dr in dtUpdate.Rows)
        {
           
            columnValue ="'"+dr["ListValue"].ToString() + "'," +
                         "'" + dr["GroupCd"].ToString() + "'," + UserID + ", " + 
                         "'"+Session["UserName"].ToString()+"',"+
                         "'"+DateTime.Now.ToShortDateString()+"'";
             
            employee.InsertUserGroup(columnValue);
        }
        columnValue = "";
        hidValue.Value = "";

        BindUserGrid();
        BindSecurityGrid();

        ScriptManager.RegisterClientScriptBlock(btnUserUpdate, btnUserUpdate.GetType(), "Cursor", "document.form1.style.cursor='auto';", true);
        upnlGroupGrid.Update();
        upnlSecurityGrid.Update();
    }

    protected void btnSecurityUpdate_Click(object sender, EventArgs e)
    {
        User = Convert.ToInt32(hidUserIDVal.Value);
        hidUserValue.Value = hidUserValue.Value.Replace("`", "");
        hidUserID.Value = hidUserID.Value.Replace("`", "");
        string SecurityValue = hidUserValue.Value;
      
        string whereClause = "pSecMembersID in (" + hidUserID.Value.Remove(hidUserID.Value.Length-1,1) + ")";
        employee.DeleteUserGroup(whereClause);
        hidUserValue.Value = hidUserID.Value ="";

        BindUserGrid();
        BindSecurityGrid();

        ScriptManager.RegisterClientScriptBlock(btnSecurityUpdate, btnSecurityUpdate.GetType(), "Cursor", "document.form1.style.cursor='auto';", true);
        upnlGroupGrid.Update();
        upnlSecurityGrid.Update();
        upnlPermGrid.Update();
    }

    protected void gvUserGroup_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        e.Row.ToolTip = "Select the permission you wants remove form " + lblUser.Text + ".";
                        //"Drag & drop them to Security Group section.";
        
        e.Row.Attributes.Add("onclick", "javascript:SelectUserItem(this,'`" + e.Row.Cells[0].Text + ",','`"+e.Row.Cells[2].Text +",');");
        e.Row.Attributes.Add("onDblclick", "javascript:SelectUserItem(this,'`" + e.Row.Cells[0].Text + ",','`" + e.Row.Cells[2].Text + ",');UpdateSecurity();");
        //e.Row.Attributes.Add("onDblclick", "javascript:SelectUserItem(this,'`" + e.Row.Cells[0].Text + ",','`" + e.Row.Cells[2].Text + ",');UpdateSecurity();");
        e.Row.Cells[2].Style.Add(HtmlTextWriterStyle.Display, "none");
    }

    protected void  ibtnSave_Click(object sender, ImageClickEventArgs e)
{
   
    int userId =User= Convert.ToInt32(UserID);
    if (userId != 0)
    {
        string columnValue = "APApplicationInd='" + rdlAP.SelectedItem.Value.ToString()+ "'," +
            "ARApplicationInd='" + rdlAR.SelectedItem.Value.ToString()+ "'," +
            "GLApplicationInd='" + rdlGL.SelectedItem.Value.ToString() + "'," +
            "IMApplicationInd='" + rdlIM.SelectedItem.Value.ToString()+ "'," +
            "POApplicationInd='" + rdlPOE.SelectedItem.Value.ToString()+ "'," +
            "OEApplicationInd='" + rdlSOE.SelectedItem.Value.ToString() + "'";

        employee.UpdateUserSecurityData(columnValue, userId);
    }
   BindUserGrid();
   BindSecurityGrid();
   BindUserPermission();
   upnlGroupGrid.Update();
   upnlSecurityGrid.Update();
   upnlPermGrid.Update();
  

}

    private void ClearControl()
    {
        rdlAP.SelectedIndex = 2;
        rdlAR.SelectedIndex = 2;
        rdlGL.SelectedIndex = 2;
        rdlIM.SelectedIndex = 2;
        rdlPOE.SelectedIndex = 2;
        rdlSOE.SelectedIndex = 2;

        //rdlAP.SelectedItem.Value = "G";
        //rdlAR.SelectedItem.Value = "G";
        //rdlGL.SelectedItem.Value = "G";
        //rdlIM.SelectedItem.Value = "G";
        //rdlPOE.SelectedItem.Value = "G";
        //rdlSOE.SelectedItem.Value = "G";
    }

    private void SelectItem(RadioButtonList rdlControl, string value)
    {
        ListItem lItem = rdlControl.Items.FindByValue(value) as ListItem;
        if (lItem != null)
            rdlControl.SelectedValue = value;
    }
}
