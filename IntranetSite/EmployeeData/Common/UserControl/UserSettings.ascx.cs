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

public partial class UserSettingData : System.Web.UI.UserControl
{
    EmployeeInfo employee = new EmployeeInfo();

    string status = "";

    public string User
    {
        get { return lblUserName.Text; }
        set
        {
            hidUserID.Value = "";
            ClearControl();
            hidUserID.Value = value;
            BindUserData(hidUserID.Value);
        }
    }
    public string Location
    {
        get {return lblLocation.Text; }
        set { hidLocation.Value = value; 
            lblLocation.Text =(hidLocation.Value!="")? hidLocation.Value.Substring(3):""; }

    }
    
    public string UserID
    {
        get { return ViewState["UserID"].ToString(); }
        set { ViewState["UserID"] = value; }

    }

    public string NewUserSetting
    {
        get { return lblUserName.Text; }
        set
        {
            ClearControl();
            hidUserID.Value = "";
            hidUserID.Value = value;
            BindUserData(value);
            ibtnSave.Visible = (Session["Security"] != "") ? true : false;
        }
    }

    public string Mode

    {
      
        set { ViewState["Mode"] = value; }
    }

    public string Status
    {
        get { return status; }
    }

    public string EmployeeName
    {
        get { return lblUserName.Text; }
        set { lblUserName.Text = value; }
    }


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            BindValues();
        }
    }


    private void BindValues()
    {
        string user = "LM.ListName = 'UserInterfaceInd' And LD.fListMasterID = LM.pListMasterID ";
        employee.BindListControls(ddlUserInterface, "ListDesc", "ListValue", employee.GetBindData(user), "--Select--");

        string buyer = "LM.ListName = 'UserBuyerInd' And LD.fListMasterID = LM.pListMasterID ";
        employee.BindListControls(ddlBuyer, "ListDesc", "ListValue", employee.GetBindData(buyer), "--Select--");

        string orders = "LM.ListName = 'UserApprOrdrInd' And LD.fListMasterID = LM.pListMasterID ";
        employee.BindListControls(ddlApproveOrders, "ListDesc", "ListValue", employee.GetBindData(orders), "--Select--");

        string clerk = "LM.ListName = 'UserARClerkInd' And LD.fListMasterID = LM.pListMasterID ";
        employee.BindListControls(ddlARClerk, "ListDesc", "ListValue", employee.GetBindData(clerk), "--Select--");

        string prompt = "LM.ListName = 'UserPrmryBinPrmpt' And LD.fListMasterID = LM.pListMasterID ";
        employee.BindListControls(ddlPrompt, "ListDesc", "ListValue", employee.GetBindData(prompt), "--Select--");

    }   

    private void BindUserData(string userid)
    {
        ViewState["UserID"] =  userid;
        DataTable dtUser = employee.GetUserData(userid);
        if (dtUser != null && dtUser.Rows.Count > 0)
        {
            //lblUserName.Text = dtUser.Rows[0]["Name"].ToString();
            //lblLocation.Text = dtUser.Rows[0]["Location"].ToString();
            SelectItem(ddlUserInterface, dtUser.Rows[0]["UserInterfaceInd"].ToString());
            txtMSADUserName.Text = dtUser.Rows[0]["MSADUserName"].ToString();
            lblLastLogin.Text = ((dtUser.Rows[0]["LastLoginDt"].ToString()!="01/01/1900")?dtUser.Rows[0]["LastLoginDt"].ToString():"");
            lblNoLogins.Text = dtUser.Rows[0]["NoofLogins"].ToString();
            lblLogStatus.Text = dtUser.Rows[0]["LogonStatusInd"].ToString();
            txtUserName.Text = dtUser.Rows[0]["UserName"].ToString();
            txtPassword.Attributes.Add("value", dtUser.Rows[0]["Password"].ToString());

            txtDomain.Text = dtUser.Rows[0]["Domain"].ToString();
            SelectItem(ddlBuyer, dtUser.Rows[0]["BuyerInd"].ToString());
            SelectItem(ddlApproveOrders, dtUser.Rows[0]["ApproveOrderInd"].ToString());
            SelectItem(ddlARClerk, dtUser.Rows[0]["ARClerkInd"].ToString());
            SelectItem(ddlPrompt, dtUser.Rows[0]["PrimaryBinPrmpt"].ToString());
            txtDollarLimit.Text =((dtUser.Rows[0]["PODolLimit"].ToString()!="")? String.Format("{0:###0.00}",Convert.ToDecimal( dtUser.Rows[0]["PODolLimit"])):"");
            txtConsumable.Text = ((dtUser.Rows[0]["ConsumablesAmt"].ToString()!="")?String.Format("{0:###0.00}", Convert.ToDecimal(dtUser.Rows[0]["ConsumablesAmt"])):""); 


        }

        ViewState["Mode"] = "Save";
    }

    protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
    {
        string userID = ViewState["UserID"].ToString();

        DataSet dsUserData = employee.CheckUserNameDuplicate(txtUserName.Text, txtMSADUserName.Text, userID);

        if (dsUserData != null && dsUserData.Tables[0].Rows.Count == 0)
        {
            string ColumnValue = " Location='" + lblLocation.Text.Split('-')[1].ToString().Trim() + "'," +
                               "IMLoc='" + hidLocation.Value.Substring(0, 2) + "'," +
                               "UserInterfaceInd='" + ddlUserInterface.SelectedItem.Value.ToString() + "'," +
                               "MSADUserName='" + txtMSADUserName.Text.Replace("'", "").Replace("\"", "") + "'," +
                                "DateofLastLogin='" + lblLastLogin.Text + "'," +
                               "NoofLogins=" + ((lblNoLogins.Text != "") ? lblNoLogins.Text : "NULL") + "," +
                               "LogonStatusInd='" + lblLogStatus.Text + "'," +
                               "UserName='" + txtUserName.Text.Replace("'", "").Replace("\"", "") + "'," +
                               "UserPassword='" + txtPassword.Text.Replace("'", "").Replace("\"", "") + "'," +
                               "Domain='" + txtDomain.Text.Replace("'", "").Replace("\"", "") + "'," +
                               "BuyerInd='" + ddlBuyer.SelectedItem.Value.ToString() + "'," +
                               "ApproveOrderInd='" + ddlApproveOrders.SelectedItem.Value.ToString() + "'," +
                               "ARClerkInd='" + ddlARClerk.SelectedItem.Value.ToString() + "'," +
                               "PrimaryBinPrmpt='" + ddlPrompt.SelectedItem.Value.ToString() + "'," +
                               "PODolLimit=" + ((txtDollarLimit.Text != "") ? txtDollarLimit.Text : "NULL") + "," +
                               "ConsumablesAmt=" + ((txtConsumable.Text != "") ? txtConsumable.Text : "NULL") + "," +
                               "ChangeID='" + Session["UserName"].ToString() + "'," +
                               "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";

            employee.UpdateUserData(ColumnValue, userID);
            status = "Success";
            ViewState["Mode"] = "Save";
        }
        else
        {
            Label lbl = Page.FindControl("lblMessage") as Label;

            employee.DisplayMessage(MessageType.Failure, "Username or MSAD Username already exists", lbl);
            UpdatePanel pnl = Page.FindControl("upnlMessage") as UpdatePanel;
            pnl.Update();            
        }

        upnlUser.Update();
        upnlMSAD.Update();
        upnlBuyer.Update();
    }
    private void SelectItem(DropDownList ddlControl, string value)
    {
        ListItem lItem = ddlControl.Items.FindByValue(value) as ListItem;
        if (lItem != null)
            ddlControl.SelectedValue = value;
    }
    private void ClearControl()
    {
        lblUserName.Text = lblLocation.Text = "";
        txtMSADUserName.Text = txtUserName.Text = txtPassword.Text = "";
        txtDollarLimit.Text = txtDomain.Text = txtConsumable.Text="";
        lblLastLogin.Text = lblNoLogins.Text = lblLogStatus.Text = "";
        ddlUserInterface.SelectedIndex = ddlBuyer.SelectedIndex = 0;
        ddlApproveOrders.SelectedIndex = ddlARClerk.SelectedIndex = 0;
        ddlPrompt.SelectedIndex = 0;

    }



}
