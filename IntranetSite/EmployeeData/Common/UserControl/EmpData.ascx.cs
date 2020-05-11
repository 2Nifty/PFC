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

public partial class EmpData : System.Web.UI.UserControl
{

    string columnValue = "";
    string status = "";
    string LocValue = "";
    string phoneFmt;
    EmployeeInfo employee = new EmployeeInfo();
    ScriptManager SM;

    public string EmployeeName
    {
        get { return hidUserName.Value.Trim(); }
        
        set
        {
            hidUserName.Value = ""; 
            hidUserName.Value = value;
            BindEmployeeData(hidUserName.Value);
        }
    }

    public string EmpLocation
    { get { return hidLocation.Value.Trim(); }
        set { hidLocation.Value = value; }
    }

    public string UserID
    {
        get { return ViewState["UserID"].ToString(); }
        set { ViewState["UserID"] = value; }

    }

    public string NewEmployee
    {
        set
        {
            ClearControl();
            ViewState["Mode"] = value;
            ibtnSave.Visible =(Session["Security"] != "") ? true : false;
        }

    }

    public string Status
    {
        get { return status; }
       
    }

    public string Mode
    {
        get { return ViewState["Mode"].ToString(); }
       
    }

    public event EventHandler BubbleClick;

    protected void Page_Load(object sender, EventArgs e)
    {
        SM = Page.FindControl("ScriptManager1") as ScriptManager;

        if (!IsPostBack)
        {
            //Default value
            BindValues();
            SelectItem(ddlPayrollLoc, ddlHireLocation.SelectedItem.Value);
            BindDefaultSupervisior(ddlHireLocation.SelectedItem.Value);
            dtpHireDate.SelectedDate = DateTime.Now.ToShortDateString();
           
            BindDepts(ddlHireLocation.SelectedItem.Value);
        }       
            
    }

    private void BindValues()
    {
        string status = "LM.ListName = 'UserEmpStatus' And LD.fListMasterID = LM.pListMasterID ";
        employee.BindListControls(ddlStatus, "ListDesc", "ListValue", employee.GetBindData(status), "--Select--");

        string position = "LM.ListName = 'UserEmpJobCd' And LD.fListMasterID = LM.pListMasterID ";
        employee.BindListControls(ddlPosition, "ListValue", "ListValue", employee.GetBindData(position), "--Select--");

        string shift = "LM.ListName = 'UserEmpShift' And LD.fListMasterID = LM.pListMasterID ";
        employee.BindListControls(ddlShift, "ListDesc", "ListValue", employee.GetBindData(shift), "--Select--");

        string pay = "LM.ListName = 'UserEmpPayCode' And LD.fListMasterID = LM.pListMasterID ";
        employee.BindListControls(ddlPayCode, "ListDesc", "ListValue", employee.GetBindData(pay), "--Select--");

        string salutation = "LM.ListName = 'EmpDataSalutation' And LD.fListMasterID = LM.pListMasterID ";
        employee.BindListControls(ddlSalutation, "ListDesc", "ListValue", employee.GetBindData(salutation), "--Select--");

        employee.BindListControls(ddlHireLocation, "Name", "Code", employee.GetLocationName(), "-- Select Location --");
        employee.BindListControls(ddlPayrollLoc, "Name", "Code", employee.GetLocationName(), "--Select Loacation--");


    }

    private void BindDepts(string location)
    {
        employee.BindListControls(ddlDepartment, "Department", "DepartmentNo", employee.GetDepartment(ddlHireLocation.SelectedItem.Value.ToString()), "--Select--");
        employee.BindListControls(ddlSupervisior, "Supervisior", "pEmployeeMasterID", employee.GetSupervisior(ddlHireLocation.SelectedItem.Value.ToString()), "--Select--");
    }

    private void BindDefaultSupervisior(string location)
    {
        DataTable dt = employee.GetDefaultSupervisior(location);
        if (dt != null && dt.Rows.Count > 0)
        {
            SelectItem(ddlSupervisior, dt.Rows[0]["pEmployeeMasterID"].ToString());
        }
    }

    private void SelectItem(DropDownList ddlControl, string value)
    {
        ListItem lItem = ddlControl.Items.FindByValue(value.Trim()) as ListItem;
        if (lItem != null )
            ddlControl.SelectedValue = value.Trim();
        else
            ddlControl.ClearSelection();
    }

    private void BindEmployeeData(string empName)
    {
        DataTable dtEmployee = employee.GetEmployeeData(empName);
       
        if (dtEmployee != null && dtEmployee.Rows.Count > 0)
        {
            ViewState["EmpID"] = dtEmployee.Rows[0]["pEmployeeMasterID"].ToString();
            lblUserName.Text = dtEmployee.Rows[0]["EmployeeName"].ToString();
            SelectItem(ddlSalutation, dtEmployee.Rows[0]["Salutation"].ToString());
            SelectItem(ddlHireLocation, dtEmployee.Rows[0]["Location"].ToString());
            //hidLocation.Value = ddlHireLocation.SelectedItem.Text;
            EmpLocation = (ddlHireLocation.SelectedItem.Value.ToString()!="")?((ddlHireLocation.SelectedItem.Value.ToString()) + "-" + (ddlHireLocation.SelectedItem.Text.ToString())):"";
            employee.BindListControls(ddlSupervisior, "Supervisior", "pEmployeeMasterID", employee.GetSupervisior(ddlHireLocation.SelectedItem.Value.ToString()), "--Select--");
                //dtEmployee.Rows[0]["Location"].ToString();
            txtEmpNo.Text = dtEmployee.Rows[0]["EmployeeNo"].ToString();
            SelectItem(ddlStatus, dtEmployee.Rows[0]["EmploymentStatus"].ToString());
            dtpHireDate.SelectedDate = ((dtEmployee.Rows[0]["HireDt"].ToString() != "01/01/1900") ? dtEmployee.Rows[0]["HireDt"].ToString() : "");
            SelectItem(ddlDepartment, dtEmployee.Rows[0]["DepartmentNo"].ToString());
            SelectItem(ddlPosition, dtEmployee.Rows[0]["DefaultJobCd"].ToString());
            SelectItem(ddlShift, dtEmployee.Rows[0]["Shift"].ToString());
            SelectItem(ddlSupervisior, dtEmployee.Rows[0]["SupervisorEmpID"].ToString());
            txtFirstName.Text = dtEmployee.Rows[0]["FirstName"].ToString();
            txtMiddleName.Text = dtEmployee.Rows[0]["MiddleInitial"].ToString().Trim();
            txtLastName.Text = dtEmployee.Rows[0]["LastName"].ToString();
            txtEmail.Text = dtEmployee.Rows[0]["EmailAddress"].ToString().Replace("@porteousfastener.com", "");
            txtPhone.Text = FormatPhoneBasedOnLocation(dtEmployee.Rows[0]["PhoneNo"].ToString(), ddlHireLocation.SelectedItem.Value.ToString());
            txtFax.Text = FormatPhoneBasedOnLocation(dtEmployee.Rows[0]["FaxNo"].ToString(), ddlHireLocation.SelectedItem.Value.ToString());
            SelectItem(ddlPayCode, dtEmployee.Rows[0]["PayCd"].ToString());
            txtPayrollEmpNo.Text = dtEmployee.Rows[0]["PayrollEmployeeNo"].ToString();
            SelectItem(ddlPayrollLoc, dtEmployee.Rows[0]["PayRollLocation"].ToString());
            txtHoliday.Text = dtEmployee.Rows[0]["HolidayHours"].ToString();
            txtSick.Text = dtEmployee.Rows[0]["SickHours"].ToString();
            txtVacation.Text = dtEmployee.Rows[0]["VacationHours"].ToString();
            txtBegin.Text =(( dtEmployee.Rows[0]["LeaveBeginDt"].ToString()!= "01/01/1900" )? dtEmployee.Rows[0]["LeaveBeginDt"].ToString():"");
            txtEnd.Text = ((dtEmployee.Rows[0]["LeaveEndDt"].ToString()!= "01/01/1900" )?dtEmployee.Rows[0]["LeaveEndDt"].ToString():"");
            txtAbsenceBal.Text = ((dtEmployee.Rows[0]["LeaveBalanceDt"].ToString()!= "01/01/1900" )?dtEmployee.Rows[0]["LeaveBalanceDt"].ToString():"");
            txtBalance.Text = ((dtEmployee.Rows[0]["BenefitBalance"].ToString() != "") ? (String.Format("{0:###0.00}", Convert.ToDecimal(dtEmployee.Rows[0]["BenefitBalance"].ToString()))) : "");

            ViewState["UserID"] = employee.GetUserIDByEmployeeID(ViewState["EmpID"].ToString());
        }
       // hidUserName.Value = "";
        ViewState["Mode"] = "Save";
      
    }       

    protected void ddlHireLocation_SelectedIndexChanged(object sender, EventArgs e)
    {
        string location = ddlHireLocation.SelectedItem.Value.ToString();
        BindDepts(ddlHireLocation.SelectedItem.Value.ToString());

        SelectItem(ddlPayrollLoc, location);
        BindDefaultSupervisior(location);
        
        SM.SetFocus(txtEmpNo);
        upnlDept.Update();
        upnlUser.Update();
    }

    private void ClearControl()
    {
        lblUserName.Text = "";
        txtFirstName.Text = txtLastName.Text = txtEmpNo.Text = "";
        txtFirstName.Text = txtMiddleName.Text = txtLastName.Text = "";
        txtEmail.Text = txtPhone.Text = txtFax.Text = "";
        txtPayrollEmpNo.Text = txtHoliday.Text = txtSick.Text = "";
        txtVacation.Text = txtBegin.Text = txtEnd.Text = "";
        txtAbsenceBal.Text =txtBalance.Text= "";
        dtpHireDate.SelectedDate = "";
        ddlHireLocation.SelectedIndex = ddlStatus.SelectedIndex = 0;
        ddlDepartment.SelectedIndex = ddlPosition.SelectedIndex = 0;
        ddlShift.SelectedIndex = ddlSupervisior.SelectedIndex = 0;
        ddlSalutation.SelectedIndex = ddlPayCode.SelectedIndex = ddlPayrollLoc.SelectedIndex = 0;

    }

    protected void ibtnSave_Click(object sender, ImageClickEventArgs e)
    {
        string empName =(txtFirstName.Text.Replace("'", "").Replace("\"", "").Trim()+ " " + txtLastName.Text.Replace("'", "").Replace("\"", "").Trim());
        string email = ((txtEmail.Text != "") ? (txtEmail.Text.Replace("'", "").Replace("\"", "")) + lblEmail.Text : "");
        DateTime stDate = (txtBegin.Text != "") ? Convert.ToDateTime(txtBegin.Text) : DateTime.Now;
        DateTime endDate = (txtEnd.Text != "") ? Convert.ToDateTime(txtEnd.Text) : DateTime.Now;

        txtPhone.Text = RemovePhoneNumberFormat(txtPhone.Text.Replace("'", "").Trim());
        txtFax.Text = RemovePhoneNumberFormat(txtFax.Text.Replace("'", "").Trim());

        if (endDate >= stDate)
        {
            if (ViewState["Mode"].ToString() == "Add")
            {
                columnValue = "'" + empName + "'," +
                               "'" + ddlHireLocation.SelectedItem.Value.ToString() + "'," +
                               "'" + txtEmpNo.Text.Replace("'", "").Replace("\"", "") + "'," +
                                ((ddlStatus.SelectedItem.Value.ToString() != "") ? ("'" + ddlStatus.SelectedItem.Value.ToString() + "'") : "NULL") + "," +
                               "'" + dtpHireDate.SelectedDate + "'," +
                               ((ddlDepartment.SelectedItem.Value.ToString() != "") ? ddlDepartment.SelectedItem.Value.ToString() : "NULL") + "," +
                               "'" + ((ddlPosition.SelectedItem.Value.ToString() != "") ? ddlPosition.SelectedItem.Value.ToString() : "NULL") + "'," +
                                ((ddlShift.SelectedItem.Value.ToString() != "") ? ("'" + ddlShift.SelectedItem.Value.ToString() + "'") : "NULL") + "," +
                               ((ddlSupervisior.SelectedItem.Value.ToString() != "") ? ("'" + ddlSupervisior.SelectedItem.Value.ToString() + "'") : "NULL") + "," +
                               "'" + txtFirstName.Text.Replace("'", "").Replace("\"", "") + "'," +
                               "'" + txtMiddleName.Text.Replace("'", "").Replace("\"", "").Trim() + "'," +
                               "'" + txtLastName.Text.Replace("'", "").Replace("\"", "") + "'," +
                                ((ddlSalutation.SelectedItem.Value.ToString() != "") ? ("'" + ddlSalutation.SelectedItem.Value.ToString().Trim() + "'") : "NULL") + "," +
                               "'" + email + "'," +
                               "'" + txtPhone.Text + "'," +
                               "'" + txtFax.Text + "'," +
                               "'" + ddlPayCode.SelectedItem.Value.ToString() + "'," +
                               "'" + txtPayrollEmpNo.Text.Replace("'", "").Replace("\"", "") + "'," +
                               "'" + ddlPayrollLoc.SelectedItem.Value.ToString() + "'," +
                               ((txtHoliday.Text != "") ? txtHoliday.Text : "NULL") + "," +
                               ((txtSick.Text != "") ? txtSick.Text : "NULL") + "," +
                               ((txtVacation.Text != "") ? txtVacation.Text : "NULL") + "," +
                               "'" + txtBegin.Text + "'," +
                               "'" + txtEnd.Text + "'," +
                               "'" + txtAbsenceBal.Text + "'," +
                               "" + ((txtBalance.Text != "") ? txtBalance.Text : "NULL") + "," +
                               "'" + Session["UserName"].ToString() + "'," +
                               "'" + DateTime.Now.ToShortDateString() + "'," +
                               ((ddlPosition.SelectedItem.Value.ToString().Trim().ToLower() == "supervisior") ? "'Y'" : "NULL");// +"'";

                string whereClause = "EmployeeName='" + empName + "' and DeleteDt is null";

                bool checkUser = employee.CheckUser(whereClause);
                bool checkUserID = employee.CheckUserID(txtEmpNo.Text.Trim());

                Label lbl = Page.FindControl("lblMessage") as Label;
                if (checkUser)
                {
                    employee.DisplayMessage(MessageType.Failure, "Employee Name already exists", lbl);
                    UpdatePanel pnl = Page.FindControl("upnlMessage") as UpdatePanel;
                    pnl.Update();
                    status = "Failure";
                }
                else if (checkUserID)
                {
                    employee.DisplayMessage(MessageType.Failure, "Employee No. already exists", lbl);
                    UpdatePanel pnl = Page.FindControl("upnlMessage") as UpdatePanel;
                    pnl.Update();
                    status = "Failure";
                }
                else
                { 
                    string _empID = employee.InsertEmployeeData(columnValue);
                    ViewState["EmpID"] = _empID;
                    status = "NewEmployeeSuccess";

                    string userSettingcolumnValue = "'" + ddlHireLocation.SelectedItem.Text.ToString().Split('-')[1].ToString().Trim() + "'," +
                                                     "'" + ddlHireLocation.SelectedItem.Value.ToString() + "'," +
                                                     "'" + _empID + "'," +
                                                     "'" + Session["UserName"].ToString() + "'," +
                                                     "'" + DateTime.Now.ToShortDateString() + "'";
                    UserID = employee.InsertUserData(userSettingcolumnValue);
                    
                    ViewState["UserID"] = UserID.ToString();
                    EmployeeName = empName;
                    ViewState["Mode"] = "Save";
                }
            }
            else
            {
                string empID = ViewState["EmpID"].ToString();
                string updateValue = "EmployeeName='"+ empName.Trim() + "'," +
                                      "Location='" + ddlHireLocation.SelectedItem.Value.ToString() + "'," +
                                      "EmployeeNo='" + txtEmpNo.Text.Replace("'", "").Replace("\"", "") + "'," +
                                      "EmploymentStatus=" + ((ddlStatus.SelectedItem.Value.ToString() != "") ? ("'"+ddlStatus.SelectedItem.Value.ToString()+"'" ): "NULL") + "," +
                                      "HireDt='" + dtpHireDate.SelectedDate + "'," +
                                      "DepartmentNo=" + ((ddlDepartment.SelectedItem.Value.ToString() != "") ? ddlDepartment.SelectedItem.Value.ToString() : "NULL") + "," +
                                      "DefaultJobCd=" + ((ddlPosition.SelectedItem.Value.ToString() != "") ? ("'"+ddlPosition.SelectedItem.Value.ToString()+"'") : "NULL") + "," +
                                      "Shift='" + ddlShift.SelectedItem.Value.ToString() + "'," +
                                      "SupervisorEmpID=" + ((ddlSupervisior.SelectedItem.Value.ToString() != "") ? ddlSupervisior.SelectedItem.Value.ToString() : "NULL") + "," +
                                      "SupervisorInd='" + ((ddlPosition.SelectedItem.Value.ToString().Trim().ToLower() == "supervisior") ? "Y" : "") + "'," +
                                      "FirstName='" + txtFirstName.Text.Replace("'", "").Replace("\"", "") + "'," +
                                      "MiddleInitial='" + txtMiddleName.Text.Replace("'", "").Replace("\"", "") + "'," +
                                      "LastName='" + txtLastName.Text.Replace("'", "").Replace("\"", "") + "'," +
                                      "Salutation=" +((ddlSalutation.SelectedItem.Value.ToString()!="")?("'"+ddlSalutation.SelectedItem.Value.ToString()+"'"):"NULL")+ "," +
                                      "EmailAddress='" + email + "'," +
                                      "PhoneNo='" + txtPhone.Text + "'," +
                                      "FaxNo='" + txtFax.Text + "'," +
                                      "PayCd='" + ddlPayCode.SelectedItem.Value.ToString() + "'," +
                                      "PayRollEmployeeNo='" + txtPayrollEmpNo.Text.Replace("'", "").Replace("\"", "") + "'," +
                                      "PayRollLocation=" +((ddlPayrollLoc.SelectedItem.Value.ToString()!="")?("'"+ddlPayrollLoc.SelectedItem.Value.ToString()+"'"):"NULL" )+ "," +
                                      "HolidayHours=" + ((txtHoliday.Text != "") ? txtHoliday.Text : "NULL") + "," +
                                      "SickHours=" + ((txtSick.Text != "") ? txtSick.Text : "NULL") + "," +
                                      "VacationHours=" + ((txtVacation.Text != "") ? txtVacation.Text : "NULL") + "," +
                                      "LeaveBeginDt='" + txtBegin.Text + "'," +
                                      "LeaveEndDt='" + txtEnd.Text + "'," +
                                      "LeaveBalanceDt='" + txtAbsenceBal.Text + "'," +
                                      "BenefitBalance=" + ((txtBalance.Text != "") ? txtBalance.Text : "NULL") + "," +
                                      "ChangeID='" + Session["UserName"].ToString() + "'," +
                                      "ChangeDt='" + DateTime.Now.ToShortDateString() + "'";                                      

                employee.UpdateEmployeeData(updateValue, empID);

                int userID = Convert.ToInt32((employee.GetUserIDByEmployeeID(empID)));
                ViewState["UserID"] = userID.ToString();

                string userSettingColumnValue =" Location='" + ddlHireLocation.SelectedItem.Text.ToString() + "'," +
                                              "IMLoc='" + ddlHireLocation.SelectedItem.Value.ToString() + "'";
                employee.UpdateUserData(userSettingColumnValue, userID.ToString());
                status = "Success";

                EmpLocation = (ddlHireLocation.SelectedItem.Value.ToString()) + "-" + (ddlHireLocation.SelectedItem.Text.ToString());
                EmployeeName = empName;
                ViewState["Mode"] = "Save";
            }            
        }
        else
        {
            Label lbl = Page.FindControl("lblMessage") as Label;

            employee.DisplayMessage(MessageType.Failure, "End Date must be greater than Start Date", lbl);
            UpdatePanel pnl = Page.FindControl("upnlMessage") as UpdatePanel;
            pnl.Update();
            txtEnd.Text= "";
            // ClearControl();
            status = "Failure";
        }
    }

    public string RemovePhoneNumberFormat(string phoneNumber)
    {
        string strPhone = phoneNumber.Replace(")", "");
        strPhone = strPhone.Replace("(", "");
        strPhone = strPhone.Replace(")", "");
        strPhone = strPhone.Replace(" ", "");
        strPhone = strPhone.Replace("-", "");
        return strPhone;
    }
    
    protected void txtPhone_TextChanged(object sender, EventArgs e)
    {
        if (txtPhone.Text != "")
        {
            String _phoneFmt = FormatPhoneBasedOnLocation(txtPhone.Text, ddlHireLocation.SelectedValue.Trim());
            if (_phoneFmt != "")
            {
                txtPhone.Text = _phoneFmt;
                SM.SetFocus(txtFax);
            }
            else
            {
                SM.SetFocus(txtPhone);
                ScriptManager.RegisterClientScriptBlock(txtPhone, txtPhone.GetType(), "validate", "alert('Invalid Phone Number.Valid Format is " + phoneFmt + "');", true);
            }
        }
        else
        {
            SM.SetFocus(txtFax);
        }
    }

    protected void txtFax_TextChanged(object sender, EventArgs e)
    {
        if (txtFax.Text != "")
        {
            String _phoneFmt = FormatPhoneBasedOnLocation(txtFax.Text, ddlHireLocation.SelectedValue.Trim());
            if (_phoneFmt != "")
            {
                txtFax.Text = _phoneFmt;
                SM.SetFocus(ddlDepartment);
            }
            else
            {
                SM.SetFocus(txtFax);
                ScriptManager.RegisterClientScriptBlock(txtPhone, txtPhone.GetType(), "validate", "alert('Invalid Phone Number.Valid Format is " + phoneFmt + "');", true);
            }
        }
        else
        {
            SM.SetFocus(ddlDepartment);
        }
    }

    private string FormatPhoneBasedOnLocation(string phoneNo,string location)
    {
        string _formatedPhoneNo = "";
        phoneNo = RemovePhoneNumberFormat(phoneNo);
        if (phoneNo != "")
        {
            phoneFmt = employee.GetHireLocPhoneFormat(ddlHireLocation.SelectedValue);
            _formatedPhoneNo = String.Format("{0:" + phoneFmt + "}", Double.Parse(phoneNo));

            // For future use
            //string _hashCount = phoneFmt.Replace("(", "");
            //_hashCount = _hashCount.Replace(")", "");
            //_hashCount = _hashCount.Replace("-", "");
            //_hashCount = _hashCount.Replace(" ", "");

            //if (_hashCount.Length == phoneNo.Length)            
            //    _formatedPhoneNo = String.Format("{0:" + phoneFmt + "}", Double.Parse(phoneNo));
            //else            
            //    _formatedPhoneNo = "";
            
        }
        return _formatedPhoneNo;

    }

    protected void ibtnDelete_Click(object sender, ImageClickEventArgs e)
    {
        string columnValue = " DeleteDt='" + DateTime.Now.ToShortDateString() + "',ChangeID='" + Session["UserName"].ToString() + "',ChangeDt='" +
                                 DateTime.Now.ToShortDateString() + "'";
        string userID = employee.GetUserIDByEmployeeID(ViewState["EmpID"].ToString());
        employee.UpdateEmployeeData(columnValue, ViewState["EmpID"].ToString());
        employee.UpdateUserData(columnValue, userID);
        employee.UpdateSecurityAfterDelete(columnValue, userID.ToString());
        
        OnBubbleClick(e); // Method to display the form in add mode

    }

    protected void OnBubbleClick(EventArgs e)
    {
        if (BubbleClick != null)
        {
            BubbleClick(this, e);
        }
    }
}