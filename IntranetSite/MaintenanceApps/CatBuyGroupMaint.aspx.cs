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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.MaintenanceApps;

public partial class CatBuyGroupMaint : System.Web.UI.Page
{
    SqlConnection cnERP = new SqlConnection(ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ConnectionString);
    string _cmdText, lockUser;
    DataSet dsResult;
    DataTable dtCategory, dtBuyGroup, dtRptGroup;

    MaintenanceUtility BuyGroupMaint = new MaintenanceUtility();

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(CatBuyGroupMaint));
        if (!Page.IsPostBack)
        {
            Session["CatBuyGrpLock"] = "";
            Session["CatID"] = "";
            GetSecurity();
            DisableFields();
            smCatBuyGroupMaint.SetFocus(txtCatNo);
        }
    }

    protected void txtCatNo_TextChanged(object sender, EventArgs e)
    {
        DisableFields();
        
        lblMessage.Text = "";
        pnlStatus.Update();

        if (!string.IsNullOrEmpty(txtCatNo.Text.ToString()))
            txtCatNo.Text = txtCatNo.Text.PadLeft(5, '0').ToString();
        GetCategory();
    }

    protected void txtRptGroupNo_TextChanged(object sender, EventArgs e)
    {
        dtRptGroup = ValidReportGroup(txtRptGroupNo.Text.ToString());
        
        if (dtRptGroup != null && dtRptGroup.Rows.Count > 0)
            txtRptGroupDesc.Text = dtRptGroup.Rows[0]["ReportGroup"].ToString();
        else
            txtRptGroupDesc.Text = "";

        pnlCatData.Update();
        smCatBuyGroupMaint.SetFocus(txtRptGroupDesc);
    }

    protected void txtLbExp_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        try
        {
            txtLbExp.Text = String.Format("{0:n2}", Convert.ToDecimal(txtLbExp.Text));
            smCatBuyGroupMaint.SetFocus(txtForecastPct);
        }
        catch
        {
            DisplayStatusMessage("Please Enter A Valid Decimal Value", "fail");
            smCatBuyGroupMaint.SetFocus(txtLbExp);
        }
    }

    protected void txtForecastPct_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = "";
        pnlStatus.Update();

        try
        {
            txtForecastPct.Text = String.Format("{0:n3}", Convert.ToDecimal(txtForecastPct.Text));

            if (btnSave.Visible)
                smCatBuyGroupMaint.SetFocus(btnSave);
            else
                smCatBuyGroupMaint.SetFocus(btnAdd);
        }
        catch
        {
            DisplayStatusMessage("Please Enter A Valid Decimal Value", "fail");
            smCatBuyGroupMaint.SetFocus(txtForecastPct);
        }
    }

    public void btnSearch_Click(object sender, EventArgs e)
    {
        GetCategory();
    }

    private void GetCategory()
    {
        ReleaseLock();
        dtCategory = ValidCategory(txtCatNo.Text.ToString());
        if (dtCategory != null && dtCategory.Rows.Count > 0)
        {
            lblCatDesc.Text = dtCategory.Rows[0]["CatDesc"].ToString();
            GetBuyGroup();
        }
        else
        {
            DisplayStatusMessage("Category Is Not Valid", "fail");
            smCatBuyGroupMaint.SetFocus(txtCatNo);
        }
    }

    private void GetBuyGroup()
    {
        hidCatId.Value = txtCatNo.Text.ToString();

        dtBuyGroup = ValidBuyGroup(txtCatNo.Text.ToString());
        if (dtBuyGroup != null && dtBuyGroup.Rows.Count > 0)
        {
            if (string.IsNullOrEmpty(dtBuyGroup.Rows[0]["CatDesc"].ToString()))
                txtCatDesc.Text = lblCatDesc.Text.ToString();
            else
                txtCatDesc.Text = dtBuyGroup.Rows[0]["CatDesc"].ToString();
            txtBuyGroup.Text = dtBuyGroup.Rows[0]["GroupNo"].ToString();
            txtRptGroupNo.Text = dtBuyGroup.Rows[0]["ReportGroupNo"].ToString();
            txtRptGroupDesc.Text = dtBuyGroup.Rows[0]["ReportGroup"].ToString();
            txtRptSort.Text = dtBuyGroup.Rows[0]["ReportSort"].ToString();
            txtBuyFct.Text = dtBuyGroup.Rows[0]["MonthsBuyFactor"].ToString();
            txtLbExp.Text = String.Format("{0:n2}", Convert.ToDecimal(dtBuyGroup.Rows[0]["ExpensePerLb"].ToString()));
            txtForecastPct.Text = String.Format("{0:n3}", Convert.ToDecimal(dtBuyGroup.Rows[0]["UsageForecastPct"].ToString()));
            txtCmntText.Text = dtBuyGroup.Rows[0]["Notes"].ToString();

            if (hidSecurity.Value == "Full")
            {
                CheckLock();
                if (Session["CatBuyGrpLock"].ToString() == "L")
                {
                    hidCatId.Value = "";
                    smCatBuyGroupMaint.SetFocus(txtCatNo);
                    ScriptManager.RegisterClientScriptBlock(pnlCatData, typeof(UpdatePanel), "Script", "alert('Record Locked By " + lockUser.ToString() + "');", true);
                }
                else
                {
                    EnableFields();
                    btnSave.Visible = true;
                    btnDel.Visible = true;
                    btnCancel.Visible = true;
                    smCatBuyGroupMaint.SetFocus(txtCatDesc);
                }
            }
            else
            {
                smCatBuyGroupMaint.SetFocus(txtCatNo);
            }
        }
        else
        {
            if (hidSecurity.Value == "Full")
            {
                DisplayStatusMessage("Add New Buy Group", "success");

                CheckLock();
                if (Session["CatBuyGrpLock"].ToString() == "L")
                {
                    hidCatId.Value = "";
                    smCatBuyGroupMaint.SetFocus(txtCatNo);
                    ScriptManager.RegisterClientScriptBlock(pnlCatData, typeof(UpdatePanel), "Script", "alert('Record Locked By " + lockUser.ToString() + "');", true);
                }
                else
                {
                    EnableFields();
                    btnAdd.Visible = true;
                    btnCancel.Visible = true;
                    txtCatDesc.Text = lblCatDesc.Text;
                    smCatBuyGroupMaint.SetFocus(txtCatDesc);
                }
            }
            else
            {
                DisplayStatusMessage("Buy Group Record Not Found", "fail");
                smCatBuyGroupMaint.SetFocus(txtCatNo);
            }
        }
        
        pnlCatData.Update();
    }

    public void btnSave_Click(object sender, EventArgs e)
    {
        _cmdText = "UPDATE  CategoryBuyGroups " +
                   "SET     [Description] = '" + txtCatDesc.Text.ToString().Trim() + "', " +
                   "        GroupNo = '" + txtBuyGroup.Text.ToString().Replace("-","") + "', " +
                   "        ReportGroupNo = '" + txtRptGroupNo.Text.ToString().Replace("-", "") + "', " +
                   "        ReportGroup = '" + txtRptGroupDesc.Text.ToString().Trim() + "', " +
                   "        ReportSort = '" + txtRptSort.Text.ToString().Replace("-", "") + "', " +
                   "        MonthsBuyFactor = '" + txtBuyFct.Text + "', " +
                   "        ExpensePerLb = '" + txtLbExp.Text + "', " +
                   "        UsageForecastPct = '" + txtForecastPct.Text + "', " +
                   "        Notes = '" + txtCmntText.Text.ToString().Trim() + "', " +
                   "        ChangeID ='" + Session["UserName"].ToString().Trim() + "', " +
                   "        ChangeDt ='" + DateTime.Now.ToString() + "' " +
                   "WHERE   Category = '" + txtCatNo.Text +"'";
        SqlHelper.ExecuteNonQuery(cnERP, CommandType.Text, _cmdText);
        DisplayStatusMessage("Buy Group Record Updated", "success");
        smCatBuyGroupMaint.SetFocus(txtCatNo);
    }

    public void btnDel_Click(object sender, EventArgs e)
    {
        _cmdText = "DELETE " +
                   "FROM    CategoryBuyGroups " +
                   "WHERE   Category = '" + txtCatNo.Text + "'";
        SqlHelper.ExecuteNonQuery(cnERP, CommandType.Text, _cmdText);
        DisplayStatusMessage("Buy Group Record Deleted", "success");
        smCatBuyGroupMaint.SetFocus(txtCatNo);
        ReleaseLock();
        DisableFields();
    }

    public void btnAdd_Click(object sender, EventArgs e)
    {
        if (string.IsNullOrEmpty(txtBuyGroup.Text))
            txtBuyGroup.Text = "0";
        if (string.IsNullOrEmpty(txtRptGroupNo.Text))
            txtRptGroupNo.Text = "0";
        if (string.IsNullOrEmpty(txtRptSort.Text))
            txtRptSort.Text = "0";
        if (string.IsNullOrEmpty(txtBuyFct.Text))
            txtBuyFct.Text = "0";
        if (string.IsNullOrEmpty(txtLbExp.Text))
            txtLbExp.Text = "0.00";
        if (string.IsNullOrEmpty(txtForecastPct.Text))
            txtForecastPct.Text = "0.000";
        
        _cmdText = "INSERT INTO CategoryBuyGroups " +
                   "            (Category, " +
                   "             [Description], " +
                   "             GroupNo, " +
                   "             ReportGroupNo, " +
                   "             ReportGroup, " +
                   "             ReportSort, " +
                   "             MonthsBuyFactor, " +
                   "             ExpensePerLb, " +
                   "             UsageForecastPct, " +
                   "             Notes, " +
                   "             EntryID, " +
                   "             EntryDt) " +
                   "VALUES      ('" + txtCatNo.Text.ToString() + "', " +
                   "             '" + txtCatDesc.Text.ToString().Trim() + "', " + 
                   "             '" + txtBuyGroup.Text.ToString().Replace("-", "") + "', " + 
                   "             '" + txtRptGroupNo.Text.ToString().Replace("-", "") + "', " + 
                   "             '" + txtRptGroupDesc.Text.ToString().Trim() + "', " + 
                   "             '" + txtRptSort.Text.ToString().Replace("-", "") + "', " + 
                   "             '" + txtBuyFct.Text + "', " + 
                   "             '" + txtLbExp.Text + "', " + 
                   "             '" + txtForecastPct.Text + "', " +
                   "             '" + txtCmntText.Text.ToString().Trim() + "', " + 
                   "             '" + Session["UserName"].ToString().Trim() + "', " + 
                   "             '" + DateTime.Now.ToString() + "')";
        SqlHelper.ExecuteNonQuery(cnERP, CommandType.Text, _cmdText);
        DisplayStatusMessage("Buy Group Record Added", "success");
        btnAdd.Visible = false;
        btnSave.Visible = true;
        btnDel.Visible = true;
        smCatBuyGroupMaint.SetFocus(txtCatNo);
    }

    public void btnCancel_Click(object sender, EventArgs e)
    {
        ReleaseLock();
        DisableFields();
        txtCatNo.Text = "";
        pnlSearchCat.Update();
        smCatBuyGroupMaint.SetFocus(txtCatNo);
    }

    public DataTable ValidCategory(string _catNo)
    {
        _cmdText = "SELECT ListValue AS CatNo, ListDtlDesc AS CatDesc " +
                   "FROM   ListMaster (NoLock) INNER JOIN ListDetail (NoLock) ON pListMasterID = fListMasterId " +
                   "WHERE  ListName = 'CategoryDesc' AND Listvalue = '" + _catNo + "'";
        dsResult = SqlHelper.ExecuteDataset(cnERP, CommandType.Text, _cmdText);
        return dsResult.Tables[0].DefaultView.ToTable();
    }

    public DataTable ValidBuyGroup(string _catNo)
    {
        _cmdText = "SELECT  isnull([Description],'') AS CatDesc, isnull(GroupNo,0) AS GroupNo, " +
                   "        isnull(ReportGroupNo,0) AS ReportGroupNo, isnull(ReportGroup,'') AS ReportGroup, " +
                   "        isnull(ReportSort,0) AS ReportSort, isnull(MonthsBuyFactor,0) AS MonthsBuyFactor, " +
                   "        isnull(ExpensePerLb,0) AS ExpensePerLb, isnull(UsageForecastPct,0) AS UsageForecastPct, " +
                   "        isnull(Notes,'') AS Notes " +
                   "FROM    CategoryBuyGroups (NoLock) " +
                   "WHERE   Category = '" + _catNo + "'";
        dsResult = SqlHelper.ExecuteDataset(cnERP, CommandType.Text, _cmdText);
        return dsResult.Tables[0].DefaultView.ToTable();
    }

    public DataTable ValidReportGroup(string _rptGroup)
    {
        _cmdText = "SELECT DISTINCT ReportGroupNo, ReportGroup " +
                   "FROM   CategoryBuyGroups (NoLock) " +
                   "WHERE  ReportGroupNo = '" + _rptGroup + "'";
        dsResult = SqlHelper.ExecuteDataset(cnERP, CommandType.Text, _cmdText);
        return dsResult.Tables[0].DefaultView.ToTable();
    }

    private void DisableFields()
    {
        lblCatDesc.Text = "";
        txtCatDesc.Text = "";
        txtBuyGroup.Text = "";
        txtRptGroupNo.Text = "";
        txtRptGroupDesc.Text = "";
        txtRptSort.Text = "";
        txtBuyFct.Text = "";
        txtLbExp.Text = "";
        txtForecastPct.Text = "";
        txtCmntText.Text = "";

        txtCatDesc.Enabled = false;
        txtBuyGroup.Enabled = false;
        txtRptGroupNo.Enabled = false;
        txtRptGroupDesc.Enabled = false;
        txtRptSort.Enabled = false;
        txtBuyFct.Enabled = false;
        txtLbExp.Enabled = false;
        txtForecastPct.Enabled = false;
        txtCmntText.Enabled = false;

        btnSave.Visible = false;
        btnDel.Visible = false;
        btnAdd.Visible = false;
        btnCancel.Visible = false;
        pnlCatData.Update();
    }

    private void EnableFields()
    {
        txtCatDesc.Enabled = true;
        txtBuyGroup.Enabled = true;
        txtRptGroupNo.Enabled = true;
        txtRptGroupDesc.Enabled = true;
        txtRptSort.Enabled = true;
        txtBuyFct.Enabled = true;
        txtLbExp.Enabled = true;
        txtForecastPct.Enabled = true;
        txtCmntText.Enabled = true;
    }

    private void DisplayStatusMessage(string message, string messageType)
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

    private void GetSecurity()
    {
        hidSecurity.Value = BuyGroupMaint.GetSecurityCode(Session["UserName"].ToString(), MaintenaceTable.CategoryBuyGroups);
        if (hidSecurity.Value.ToString() == "")
            hidSecurity.Value = "Query";
        else
            hidSecurity.Value = "Full";
    }

    public void CheckLock()
    {
        ReleaseLock();
        Session["CatID"] = hidCatId.Value;
        DataTable dtLock = BuyGroupMaint.SetLock("CategoryBuyGroups", Session["CatID"].ToString(), "CBG");
        Session["CatBuyGrpLock"] = dtLock.DefaultView.ToTable().Rows[0]["Status"].ToString();
        lockUser = dtLock.DefaultView.ToTable().Rows[0]["EntryID"].ToString();
    }

    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public void ReleaseLock()
    {
        BuyGroupMaint.ReleaseLock("CategoryBuyGroups", Session["CatID"].ToString(), "CBG", Session["CatBuyGrpLock"].ToString());
    }
}
