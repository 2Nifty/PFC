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


public partial class UserMaster : System.Web.UI.Page
{

    EmployeeInfo employee = new EmployeeInfo();

    bool User;

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(UserMaster));

        Session["UMUserName"] = hidUser.Value;       

        ImageButton btnSave = ucEmpData.FindControl("ibtnSave") as ImageButton;
        btnSave.Click += new ImageClickEventHandler (btnSave_Click);

        ImageButton btnUserSettingSave = ucSetting.FindControl("ibtnSave") as ImageButton;
        btnUserSettingSave.Click += new ImageClickEventHandler(btnUserSettingSave_Click);

        ImageButton btnUserSecuritySave = ucSecurity.FindControl("ibtnSave") as ImageButton;
        btnUserSecuritySave.Click += new ImageClickEventHandler(btnUserSecuritySave_Click);

        if (!IsPostBack)
        {
            Session["Security"] = employee.GetSecurityCode(Session["UserName"].ToString());

            divEmployee.Style.Add(HtmlTextWriterStyle.Display,"none");
            divUSerSecurity.Style.Add(HtmlTextWriterStyle.Display, "none");
            divUserSetting.Style.Add(HtmlTextWriterStyle.Display, "none");           
        }
    }
    /// <summary>
    /// When user change the view dropdown to "User"
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void btnBindUsers_Click(object sender, EventArgs e)
    {    
        BindUserInfo();
        divUser.Style.Add(HtmlTextWriterStyle.Display, "");
        divLocation.Style.Add(HtmlTextWriterStyle.Display, "none");
        
        if (User)
        {
            HighLightTabsheet("employee");
        }
        else
        {
            HighLightTabsheet("none");
        }

        upnlSearchResult.Update();
        upnlData.Update();

    }
    /// <summary>
    /// When User click serach Icon
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="e"></param>
    protected void ibtnSearchByButton_Click(object sender, ImageClickEventArgs e)
    {
        hidMode.Value = "Search";
        DoSearch();

        upnlSearchResult.Update();
        upnlData.Update();
    }

    protected void ibtnSearch_Click(object sender, EventArgs e)
    {
        DoSearch();

        lblSearch.Text = "";
        upnlSearchResult.Update();
        upnlData.Update();
    }

    private void DoSearch()
    {
        if (ddlViewOption.SelectedItem.Text == "User")
        {
            BindUserInfo();
            divUser.Style.Add(HtmlTextWriterStyle.Display, "");
            divLocation.Style.Add(HtmlTextWriterStyle.Display, "none");
            //upnlMenu.Update();
        }
        else
        {
            hidLocSearch.Value = "Location";
            BindUserInfo();
            divUser.Style.Add(HtmlTextWriterStyle.Display, "none");
            divLocation.Style.Add(HtmlTextWriterStyle.Display, "");
        }

        if (User)
        {
            HighLightTabsheet("employee");
        }
        else
        {
            HighLightTabsheet("none");
        }
    }

    protected void BindUserInfo()
    {
        lblSearch.Text = "";
        EnableTabs();

        string whereCondition = "";
        int recCount = 0;
        HiddenField hidLeftFrame = ucUser.FindControl("hidLeftFrameBindMode") as HiddenField;

        if (ddlSearch.SelectedItem.Value == "Name")
        {
            if (hidMode.Value == "Search") // serach initiated by button
                whereCondition = " and EM.EmployeeName like '" + txtSearch.Text.Trim() + "%'";
            else
                whereCondition = " and EM.EmployeeName ='" + txtSearch.Text.Trim() + "'";

            bool user;
            DataTable dtUser = employee.CountUser(whereCondition);
            if (dtUser.Rows.Count > 0 && dtUser != null)
            {
                User=user = true;
                recCount = dtUser.Rows.Count;

            }
            else
            {
               User= user = false;
                recCount = 0;
            }
            // employee.CheckUser(whereCondition);

            if (user)
            {
                if ((hidLeftFrameBindMode.Value != "Click" && hidLocSearch.Value.Trim() != "Location") || hidMode.Value == "Search")
                {
                    ucUser.UserInfo = txtSearch.Text.Trim().ToString();
                }                

                hidLeftFrameBindMode.Value = "";
                hidLeftFrame.Value = "";
                hidMode.Value = "";

                ucEmpData.EmployeeName = dtUser.Rows[0]["EmployeeName"].ToString();
                
                if (hidLocSearch.Value.Trim() == "Location")
                {
                    //ucLocation.BindLocation = whereCondition;
                    divLocation.Style.Add(HtmlTextWriterStyle.Display, "");
                    divUser.Style.Add(HtmlTextWriterStyle.Display, "none");
                }
                else
                {
                    ucUser.SelectedNode = ucEmpData.EmployeeName;
                }
                //ucUser.SelectedNode = ucEmpData.EmployeeName;
                ucSetting.User = dtUser.Rows[0]["SecUserID"].ToString();
                ucSetting.EmployeeName = ucEmpData.EmployeeName;
                ucSetting.Location = ucEmpData.EmpLocation;
                ucSecurity.UserName = ucEmpData.EmployeeName;
                ucSecurity.UserID = ucSetting.UserID;

                //HighLightTabsheet("employee");
                lblMessage.Text = "";

            }
            else
            {
                //HighLightTabsheet("none");
                lblMessage.Text = "No Records found";                
            }

        }

        else if (ddlSearch.SelectedItem.Value == "UserName")
        {
            string whereClause = "SU.UserName like'" + txtSearch.Text.Trim() + "%'";


            string empName = "";
            bool user;
            DataTable dtUser = new DataTable();
            DataTable dtEmpName = employee.GetUserName(whereClause);
            //string empName = employee.GetUserName(whereClause);
            if (dtEmpName != null && dtEmpName.Rows.Count > 0)
            {
                foreach (DataRow drName in dtEmpName.Rows)
                    empName += "'" + drName["EmployeeName"].ToString() + "',";



                empName = (empName != "") ? empName.Remove(empName.Length - 1, 1) : "";

                whereCondition = " and EmployeeName in (" + empName + ")";
                dtUser = employee.CountUser(whereCondition);
            }
            if (dtUser.Rows.Count > 0 && dtUser != null)
            {
                user = true;
                recCount = dtUser.Rows.Count;

            }
            else
            {
                user = false;
                recCount = 0;
            }
            if (user)
            {
                if (hidLeftFrameBindMode.Value != "Click")// && hidLocSearch.Value!="Location")
                {
                    ucUser.UserInfo = txtSearch.Text.Trim().ToString();
                }


                hidLeftFrameBindMode.Value = "";
                hidLeftFrame.Value = "";
                if (hidLocSearch.Value.Trim() == "Location")
                {
                    ucLocation.BindLocation = whereCondition;
                    divLocation.Style.Add(HtmlTextWriterStyle.Display, "");
                    divUser.Style.Add(HtmlTextWriterStyle.Display, "none");
                }
                else
                {
                    ucUser.UserInfoOnSearch = empName;
                    ucUser.SelectedNode = ucEmpData.EmployeeName;
                }
                //ucUser.UserInfoOnSearch = empName;
                ucEmpData.EmployeeName = dtUser.Rows[0]["EmployeeName"].ToString();
               //ucUser.SelectedNode = ucEmpData.EmployeeName;
                ucSetting.User = dtUser.Rows[0]["SecUserID"].ToString();
                ucSetting.EmployeeName = ucEmpData.EmployeeName;
                ucSetting.Location = ucEmpData.EmpLocation;
                ucSecurity.UserName = ucEmpData.EmployeeName;
                ucSecurity.UserID = ucSetting.UserID;

               // HighLightTabsheet("employee");
                lblMessage.Text = "";

            }

            else
            {
                //HighLightTabsheet("none");
                employee.DisplayMessage(MessageType.Failure, "No Records Found", lblMessage);
            }
        }

        hidLocSearch.Value = "";

        lblSearch.Text = recCount.ToString() + " Records Found";
        txtSearch.Text = "";
        upnlData.Update();
        upnlMessage.Update();
        upnlSearchResult.Update();
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        ibtnUserSetting.Disabled = false;

        if (ucEmpData.Status == "NewEmployeeSuccess")
        {
            ucSetting.Mode = "Add";
            ucSetting.NewUserSetting = ucEmpData.UserID;
            ucSetting.Location = ucEmpData.EmpLocation;
            ucSetting.EmployeeName = ucEmpData.EmployeeName;
            ucSecurity.UserName = ucEmpData.EmployeeName;
            ibtnEmpData.Disabled = false;

            HighLightTabsheet("settings");            
            employee.DisplayMessage(MessageType.Success, "Employee Data Saved Sucessfully", lblMessage);
          
        }
        else if (ucEmpData.Status == "Success")
        {
            ucSetting.User = ucEmpData.UserID;
            ucSetting.Location = ucEmpData.EmpLocation;
            ucSetting.EmployeeName = ucEmpData.EmployeeName;
            ucSecurity.UserName = ucEmpData.EmployeeName;
            ucSecurity.UserID = ucSetting.UserID;            
            ucUser.SelectedNode=ucEmpData.EmployeeName;

            HighLightTabsheet("settings");
            employee.DisplayMessage(MessageType.Success, "Employee Data Saved Sucessfully", lblMessage);

        }

        upnlData.Update();
        upnlMessage.Update();
    }

    protected void btnUserSettingSave_Click(object sender, EventArgs e)
    {
        ibtnUserSecurity.Disabled = false; 
        ibtnEmpData.Disabled = false; 
        
        if (ucSetting.Status == "Success")
        {
            ucSecurity.UserID = ucSetting.UserID;
            ucSetting.User = ucEmpData.UserID;
            ucSetting.Location = ucEmpData.EmpLocation;
            ucSetting.EmployeeName = ucEmpData.EmployeeName; 
            
            HighLightTabsheet("security");
            employee.DisplayMessage(MessageType.Success, "User Settings Saved Sucessfully", lblMessage);
        }

        upnlData.Update();
        upnlMessage.Update();
    }

    protected void btnUserSecuritySave_Click(object sender, EventArgs e)
    {
        divEmployee.Style.Add(HtmlTextWriterStyle.Display, "none");
        divUSerSecurity.Style.Add(HtmlTextWriterStyle.Display, "");
        divUserSetting.Style.Add(HtmlTextWriterStyle.Display, "none");
        employee.DisplayMessage(MessageType.Success, "User Security Saved Sucessfully", lblMessage);
        upnlMessage.Update();
    }

    protected void ibtnAdd_Click(object sender, ImageClickEventArgs e)
    {
        ibtnEmpData.Disabled = false;
        ibtnUserSecurity.Disabled = true;
        ibtnUserSetting.Disabled = true;

        divEmployee.Style.Add(HtmlTextWriterStyle.Display, "");
        divUSerSecurity.Style.Add(HtmlTextWriterStyle.Display, "none");
        divUserSetting.Style.Add(HtmlTextWriterStyle.Display, "none");
        
        ucEmpData.NewEmployee = "Add";
        HiddenField hidUSettingUserID  = ucSetting.FindControl("hidUserID") as HiddenField;
        hidUSettingUserID.Value = "";
        HiddenField hidUSettingLocation =  ucSetting.FindControl("hidLocation") as HiddenField;
        hidUSettingLocation.Value = "";
        upnlSearchResult.Update();
        upnlData.Update();        
    }

    protected void ibtnRefresh_Click(object sender, ImageClickEventArgs e)
    {
        ucUser.UserInfo = "";
        if (ucEmpData.EmployeeName != "")
        {
            ucUser.SelectedNode = ucEmpData.EmployeeName;
        }
        lblSearch.Text = "";
        upnlSearchResult.Update();
    }

    protected void Delete_Click(Object sender, System.EventArgs e)
    {
        ibtnAdd_Click(ibtnRefresh, new ImageClickEventArgs(0,0));
    }

    protected void EnableTabs()
    {
        ibtnEmpData.Disabled = false;
        ibtnUserSecurity.Disabled = false;
        ibtnUserSetting.Disabled = false;
    }

    protected void HighLightTabsheet(string sheetName)
    {
        string script = "";

        if (sheetName == "security")
        {
            divEmployee.Style.Add(HtmlTextWriterStyle.Display, "none");
            divUSerSecurity.Style.Add(HtmlTextWriterStyle.Display, "");
            divUserSetting.Style.Add(HtmlTextWriterStyle.Display, "none");

            script = "document.getElementById('ibtnUserSecurity').src = \"Common/images/tab_usersecurity_o.gif\";" +
                            "document.getElementById('ibtnUserSetting').src = \"Common/images/tab_userset_n.gif\";" +
                            "document.getElementById('ibtnEmpData').src = \"Common/images/tab_empdata_n.gif\";";
        }
        else if (sheetName == "settings")
        {
            divEmployee.Style.Add(HtmlTextWriterStyle.Display, "none");
            divUSerSecurity.Style.Add(HtmlTextWriterStyle.Display, "none");
            divUserSetting.Style.Add(HtmlTextWriterStyle.Display, "");

            script = "document.getElementById('ibtnUserSecurity').src = \"Common/images/tab_usersecurity_n.gif\";" +
                            "document.getElementById('ibtnUserSetting').src = \"Common/images/tab_userset_o.gif\";" +
                            "document.getElementById('ibtnEmpData').src = \"Common/images/tab_empdata_n.gif\";";
        }
        else if (sheetName == "employee")
        {
            divEmployee.Style.Add(HtmlTextWriterStyle.Display, "");
            divUSerSecurity.Style.Add(HtmlTextWriterStyle.Display, "none");
            divUserSetting.Style.Add(HtmlTextWriterStyle.Display, "none");

            script = "document.getElementById('ibtnUserSecurity').src = \"Common/images/tab_usersecurity_n.gif\";" +
                            "document.getElementById('ibtnUserSetting').src = \"Common/images/tab_userset_n.gif\";" +
                            "document.getElementById('ibtnEmpData').src = \"Common/images/tab_empdata_o.gif\";";
        }
        else
        {
            divEmployee.Style.Add(HtmlTextWriterStyle.Display, "none");
            divUSerSecurity.Style.Add(HtmlTextWriterStyle.Display, "none");
            divUserSetting.Style.Add(HtmlTextWriterStyle.Display, "none");

            script = "document.getElementById('ibtnUserSecurity').src = \"Common/images/tab_usersecurity_n.gif\";" +
                            "document.getElementById('ibtnUserSetting').src = \"Common/images/tab_userset_n.gif\";" +
                            "document.getElementById('ibtnEmpData').src = \"Common/images/tab_empdata_n.gif\";";
        }
        ScriptManager.RegisterClientScriptBlock(Page, Page.GetType(), "highlight", script, true);
    }


}
