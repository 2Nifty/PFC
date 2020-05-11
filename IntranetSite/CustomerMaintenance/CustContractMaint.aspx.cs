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
using PFC.Intranet.MaintenanceApps;

public partial class CustContractMaint : System.Web.UI.Page
{
    DataTable dtCust = new DataTable();
    MaintenanceUtility CustContMaint = new MaintenanceUtility();
    string lockUser;

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(CustContractMaint));
        
        if (!IsPostBack)
        {
            Session["CustContLock"] = "";
            Session["CustID"] = "";
            GetSecurity();
            BindDropDownList();
            ClearCust();
            smCustContMaint.SetFocus(txtCustomer);
        }
    }

    private void ClearCust()
    {
        lblCustNo.Text = "";
        lblCustName.Text = "";
        lblCustLine1.Text = "";
        lblCustLine2.Text = "";
        lblCustCity.Text = "";
        lblCustPhone.Text = "";
        lblCustFax.Text = "";
        btnSave.Visible = false;
        btnCancel.Visible = false;
        pnlCustDetails.Update();

        lblSched1.Text = "";
        lblSched2.Text = "";
        lblSched3.Text = "";
        lblSched4.Text = "";
        lblSched5.Text = "";
        lblSched6.Text = "";
        lblSched7.Text = "";

        txtTargetGross.Text = "";
        txtWebDiscPct.Text = "";
        txtTargetCostPlus.Text = "";
        chkWebDiscInd.Checked = false;
        ddlCustDefPrice.SelectedIndex = 0;
        //chkCustDefInd.Checked = false;
        ddlCustPriceInd.SelectedIndex = 0;
        pnlCustData.Update();
    }

    private void BindDropDownList()
    {
        //CustContMaint.BindListControls(ddlSched1, "ListValue", "ListValue", CustContMaint.GetListDetails("CustContractSchd1"), "-- Select --");
        //DataTable dtCustomerContractSchd = CustContMaint.GetListDetails("CustContractSchd");
        //CustContMaint.BindListControls(ddlSched2, "ListValue", "ListValue", dtCustomerContractSchd, "-- Select --");
        //CustContMaint.BindListControls(ddlSched3, "ListValue", "ListValue", dtCustomerContractSchd, "-- Select --");
        //CustContMaint.BindListControls(ddlSched4, "ListValue", "ListValue", dtCustomerContractSchd, "-- Select --");
        //CustContMaint.BindListControls(ddlSched5, "ListValue", "ListValue", dtCustomerContractSchd, "-- Select --");
        //CustContMaint.BindListControls(ddlSched6, "ListValue", "ListValue", dtCustomerContractSchd, "-- Select --");
        //CustContMaint.BindListControls(ddlSched7, "ListValue", "ListValue", dtCustomerContractSchd, "-- Select --");
        CustContMaint.BindListControls(ddlCustDefPrice, "ListDesc", "ListValue", CustContMaint.GetListDetails("CustDefPriceSchd"), "-- Select --");
        CustContMaint.BindListControls(ddlCustPriceInd, "ListDesc", "ListValue", CustContMaint.GetListDetails("CustPriceInd"), "-- Select --");
    }

    private void DispCust()
    {
        lblCustNo.Text = dtCust.Rows[0]["CustNo"].ToString();
        lblCustName.Text = dtCust.Rows[0]["CustName"].ToString();
        lblCustLine1.Text = dtCust.Rows[0]["AddrLine1"].ToString();
        lblCustLine2.Text = dtCust.Rows[0]["AddrLine2"].ToString();
        lblCustCity.Text = dtCust.Rows[0]["City"].ToString() + ", " + dtCust.Rows[0]["State"].ToString() + "  " + dtCust.Rows[0]["PostCd"].ToString() + "  " + dtCust.Rows[0]["Country"].ToString();
        lblCustPhone.Text = dtCust.Rows[0]["PhoneNo"].ToString();
        lblCustFax.Text = dtCust.Rows[0]["FaxPhoneNo"].ToString();
        if (hidSecurity.Value.ToString() == "Full")
            btnSave.Visible = true;
        btnCancel.Visible = true;
        pnlCustDetails.Update();

        lblSched1.Text =dtCust.Rows[0]["ContractSchd1"].ToString();
        lblSched2.Text = dtCust.Rows[0]["ContractSchd2"].ToString();
        lblSched3.Text = dtCust.Rows[0]["ContractSchd3"].ToString();
        lblSched4.Text = dtCust.Rows[0]["ContractSchedule4"].ToString();
        lblSched5.Text = dtCust.Rows[0]["ContractSchedule5"].ToString();
        lblSched6.Text = dtCust.Rows[0]["ContractSchedule6"].ToString();
        lblSched7.Text = dtCust.Rows[0]["ContractSchedule7"].ToString();

        txtTargetGross.Text = String.Format("{0:0.0}", dtCust.Rows[0]["TargetGrossMarginPct"]);
        txtWebDiscPct.Text = String.Format("{0:0.00}", dtCust.Rows[0]["WebDiscountPct"]);
        chkWebDiscInd.Checked = (dtCust.Rows[0]["WebDiscountInd"].ToString().ToUpper().Trim() == "1");
        CustContMaint.SetValueListControl(ddlCustDefPrice, dtCust.Rows[0]["CustomerDefaultPrice"].ToString());
        //chkCustDefInd.Checked = (dtCust.Rows[0]["CustomerPriceInd"].ToString().ToUpper().Trim() == "Y");
        CustContMaint.SetValueListControl(ddlCustPriceInd, dtCust.Rows[0]["CustomerPriceInd"].ToString());
        txtTargetCostPlus.Text = String.Format("{0:0.0}", dtCust.Rows[0]["TargetCostPlusPct"]);
        pnlCustData.Update();

        smCustContMaint.SetFocus(txtTargetGross);
    }

    public void btnSearch_Click(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlMessage.Update();
        ClearCust();

        ReleaseLock();

        string tableName = "CustomerMaster (NoLock) INNER JOIN CustomerAddress (NoLock) ON pCustMstrID = fCustomerMasterID";
        string columnName = "pCustMstrID, CustNo, CustName, AddrLine1, AddrLine2, City, State, PostCd, Country, PhoneNo, FaxPhoneNo, " +
                            "ContractSchd1, ContractSchd2, ContractSchd3, ContractSchedule4, ContractSchedule5, ContractSchedule6, ContractSchedule7, " +
                            "TargetGrossMarginPct, WebDiscountPct, WebDiscountInd, CustomerDefaultPrice, CustomerPriceInd" + 
                            ",TargetCostPlusPct";
        string whereClause = "CustNo = '" + txtCustomer.Text.ToString() + "' AND (Type = 'P' OR Type = '')";
        dtCust = CustContMaint.GetMaintData(tableName, columnName, whereClause);

        if (dtCust != null && dtCust.Rows.Count > 0)
        {
            hidCustId.Value = dtCust.Rows[0]["pCustMstrID"].ToString();
            if (hidSecurity.Value.ToString() == "Full")
            {
                CheckLock();
                if (Session["CustContLock"].ToString() == "L")
                {
                    ClearCust();
                    hidCustId.Value = "";
                    smCustContMaint.SetFocus(txtCustomer);
                    ScriptManager.RegisterClientScriptBlock(pnlCustData, typeof(UpdatePanel), "Script", "alert('Record Locked By " + lockUser.ToString() + "');", true);
                }
                else
                {
                    DispCust();
                }
            }
            else
            {
                DispCust();
            }
        }
        else
        {
            ClearCust();
            hidCustId.Value = "";
            DisplaStatusMessage("Customer Record Not Found", "fail");
            smCustContMaint.SetFocus(txtCustomer);
        }
    }

    protected void txtCustomer_TextChanged(object sender, EventArgs e)
    {
        if (!string.IsNullOrEmpty(txtCustomer.Text.ToString()))
            txtCustomer.Text = txtCustomer.Text.PadLeft(6, '0').ToString();
    }

    protected void txtWebDiscPct_TextChanged(object sender, EventArgs e)
    {
        txtWebDiscPct.Text = Convert.ToString(Math.Round(Convert.ToDecimal(txtWebDiscPct.Text), 2));
    }

    protected void txtTargetGross_TextChanged(object sender, EventArgs e)
    {
        txtTargetGross.Text = Convert.ToString(Math.Round(Convert.ToDecimal(txtTargetGross.Text), 1));
    }

    public void btnSave_Click(object sender, EventArgs e)
    {
        string tableName = "CustomerMaster";
        string columnName = "TargetGrossMarginPct='" + ((txtTargetGross.Text != "") ? txtTargetGross.Text : "0") + "'," +
                            "WebDiscountPct='" + ((txtWebDiscPct.Text != "") ? txtWebDiscPct.Text : "0") + "'," +
                            "WebDiscountInd='" + ((chkWebDiscInd.Checked) ? "1" : "0") + "'," +
                            "CustomerDefaultPrice='" + ddlCustDefPrice.SelectedValue.Trim() + "'," +
                            //"CustomerPriceInd='" + ((chkCustDefInd.Checked) ? "Y" : "N") + "'," +
                            "CustomerPriceInd='" + ddlCustPriceInd.SelectedValue.Trim() + "'," +
                            "ChangeID ='" + Session["UserName"].ToString().Trim() + "'," +
                            "ChangeDt ='" + DateTime.Now.ToString() + "'," + 
                            "TargetCostPlusPct='" + (txtTargetCostPlus.Text != "" ?  txtTargetCostPlus.Text : "0.00") + "'";
        string whereClause = "pCustMstrID='" + hidCustId.Value + "'";
        CustContMaint.UpdateMaintData(tableName, columnName, whereClause);
        DisplaStatusMessage("Customer Record Updated", "success");
        smCustContMaint.SetFocus(txtCustomer);
    }

    public void btnCancel_Click(object sender, EventArgs e)
    {
        ReleaseLock();
        lblMessage.Text = "";
        pnlMessage.Update();
        ClearCust();
        smCustContMaint.SetFocus(txtCustomer);
    }

    private void GetSecurity()
    {
        hidSecurity.Value = CustContMaint.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.CustomerContract);
        if (hidSecurity.Value.ToString() == "")
            hidSecurity.Value = "Query";
        else
            hidSecurity.Value = "Full";

        //Response.Write(Session["UserName"].ToString());
        //Response.Write("<br>");
        //Response.Write(hidSecurity.Value.ToString());

        //switch (hidSecurity.Value.ToString())
        //{
        //    case "None":
        //        Response.Redirect("~/Common/ErrorPage/unauthorizedpage.aspx", true);
        //        break;
        //    case "Full":
        //        btnAdd.Visible = true;
        //        break;
        //}
    }

    public void CheckLock()
    {
        ReleaseLock();
        Session["CustID"] = hidCustId.Value;
        DataTable dtLock = CustContMaint.SetLock("CustomerMaster", Session["CustID"].ToString(), "CM");
        Session["CustContLock"] = dtLock.DefaultView.ToTable().Rows[0]["Status"].ToString();
        lockUser = dtLock.DefaultView.ToTable().Rows[0]["EntryID"].ToString();
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void ReleaseLock()
    {
        CustContMaint.ReleaseLock("CustomerMaster", Session["CustID"].ToString(), "CM", Session["CustContLock"].ToString());
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
        pnlMessage.Update();
    }
}
