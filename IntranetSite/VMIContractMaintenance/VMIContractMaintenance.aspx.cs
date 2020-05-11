/********************************************************************************************
 * File	Name			:	VMIContractMaintenance.aspx.cs
 * File Type			:	C#
 * Project Name			:	Vendor Managed Inventory Contract Maintenance
 * Module Description	:	Get Contract Details
 * Created By			:	A.Nithyapriyadarshini
 * Created Date			:	02/21/2007	
 * History				:
 * 
 * DATE					VERSION			AUTHOR			            ACTION
 * ****					*******			******				        ******
 * 02/21/2007		    Version 1		A.Nithyapriyadarshini		Created 
 * 03/15/2007           Version 2       T.Sathishvaran              Modified - Add Item functionality and location drop down added
 ***********************************************************************************************/

#region Name Space
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
using System.Data.SqlClient;
using System.Threading;
using System.IO;
using System.Reflection;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet;
using System.Drawing;
#endregion

public partial class VMIContractMaintenance : System.Web.UI.Page
{
    #region Global variable declaration

    public string tableName = "VMI_ContractDetail";
    public string ContractColumnNames = "chain,StartDate,ItemNo,SubItemNo,ContractPrice,Vendor,Contact,OrderMethod,ContractNo,EndDate,CrossRef,EAU_Qty,E_Profit_Pct,Salesperson,ContactPhone,MonthFactor,ItemDesc,Closed,CustomerPO";
    public string strContractNo = string.Empty;
    public string strChain = string.Empty;
    public string whereCondition = string.Empty;
    public string columnValues = string.Empty;
    public string strColumnValues = string.Empty;
    public string msgFlag = string.Empty;
    string strCheck = string.Empty;

    Hashtable tblPreserveValues = new Hashtable();
    DataTable dtReport = new DataTable();
    DataSet dsReport = new DataSet();
    protected DataRow dRow;
    public string ddlBranch = string.Empty;

    #endregion
    
    #region Auto genereated events

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            
            msgText.Visible = false;
            SystemCheck systemCheck = new SystemCheck();
            systemCheck.SessionCheck();

            // Register The Class Name in Ajax Utility
            Ajax.Utility.RegisterTypeForAjax(typeof(VMIContractMaintenance));

            strContractNo = Request.QueryString["Contractno"].Trim();
            whereCondition = "ContractNo='" + strContractNo + "'";
            strChain = Request.QueryString["ChainName"].Replace("||","&");

            //Add Column to the DataTable
            dtReport.Columns.Add("Branch", typeof(string));
            dtReport.Columns.Add("Pct_Brn_EAU", typeof(string));
            dtReport.Columns.Add("AnnualQty", typeof(string));
            dtReport.Columns.Add("Qty30Day", typeof(string));

            if (!IsPostBack)
            {
                CreateBranchCombobox();

                if (Request.QueryString["mode"] == "edit")
                    SetValuesToControls();
                else if (Request.QueryString["mode"] == "add")
                {
                    hidChainValue.Value = strChain;                   
                }
                
                if (Request.QueryString["ItemAddMode"] != null && Request.QueryString["ItemAddMode"].ToString() == "true")
                    RestoreSessionValues();

                if (Request.QueryString["updateFlag"] != null)
                {
                    msgText.ForeColor = Color.Blue;
                    msgText.Text = (Request.QueryString["updateFlag"].Trim() == "add") ? "Data has been successfully added" : "Data has been successfully updated";
                    msgText.Visible = true;
                }
            }
        }
        catch (Exception ex)
        {
            msgText.ForeColor = Color.Red;
            msgText.Text = ex.Message;
            msgText.Visible = true;
        }
    }

    protected void btnSave_Click(object sender, ImageClickEventArgs e)
    {
        Page.Validate();
        if (Page.IsValid)
        {
            UpdateContractDetail();

            if (chkStatus.Checked)
                Response.Redirect("VMIContract.aspx");
            else if (strCheck == "")
                Response.Redirect("VMIContractMaintenance.aspx?mode=edit&ChainName=" + hidChainValue.Value.Replace("&", "||") + "&Contractno=" + txtContract.Text + "&ItemNo=" + txtPFCItemNo.Text + "&updateFlag=" + Request.QueryString["mode"].Trim());
        }

    }

    protected void btnNext_Click(object sender, ImageClickEventArgs e)
    {
        int i;
        DataTable dtNextItem = new DataTable();
        DataSet dsNextItem = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[ugen_sp_select]",
                                new SqlParameter("@tableName", "VMI_Contract"),
                                new SqlParameter("@displayColumns", "ItemNo"),
                                new SqlParameter("@whereCondition", "ContractNo='" + strContractNo + "' and Chain='" + strChain.Replace("||", "&") + "' and closed='0' order by ItemNo asc"));
        if (dsNextItem != null)
        {
            dtNextItem = dsNextItem.Tables[0];

            for (i = 0; i < dtNextItem.Rows.Count; i++)
                if (dtNextItem.Rows[i][0].ToString().Trim() == Request.QueryString["ItemNo"].Trim())
                    break;
            try
            {
                if (dtNextItem.Rows[i + 1][0] != null)
                    Response.Redirect("VMIContractMaintenance.aspx?mode=edit&ChainName=" + strChain.Replace("&", "||") + "&Contractno=" + strContractNo + "&ItemNo=" + dtNextItem.Rows[i + 1][0].ToString().Trim());
            }
            catch (Exception ex)
            {
                msgText.ForeColor = Color.Red;
                msgText.Text = "End of Items for this Contract";
                msgText.Visible = true;
            }


        }


    }

    protected void ibtnAddItem_Click(object sender, ImageClickEventArgs e)
    {
        Page.Validate();
        if (Page.IsValid)
        {
            UpdateContractDetail();

            //
            // Persist values in Session variable to display default values in add item mode
            //
            tblPreserveValues.Add("ChainName", hidChainValue.Value);
            tblPreserveValues.Add("ContractNumber", txtContract.Text);
            tblPreserveValues.Add("StartDate", txtStartDate.Text);
            tblPreserveValues.Add("EndDate", txtEndDate.Text);
            tblPreserveValues.Add("VendorCode", txtVendor.Text);
            tblPreserveValues.Add("SalesPerson", txtSales.Text);
            tblPreserveValues.Add("ContactName", txtContact.Text);
            tblPreserveValues.Add("OrderMethod", ddlOrder.SelectedItem.Text);
            tblPreserveValues.Add("MonthFactor", txtMonth.Text);
            tblPreserveValues.Add("PhoneNo", ucPhone.GetPhoneNumber);
            tblPreserveValues.Add("CustomerPO", txtCustomerPO.Text.Trim());
            Session["PersistControlValues"] = tblPreserveValues;

            //
            // Set updateFalg value in querystring to display message box
            //
            if (Request.QueryString["mode"].Trim() == "add")
                msgFlag = "add";

            if (strCheck == "")
                Response.Redirect("VMIContractMaintenance.aspx?mode=add&ChainName=0&Contractno=0&ItemNo=0&updateFlag=" + msgFlag + "&ItemAddMode=true");
        }
                
    }

    #endregion

    #region Developer generated code

    public void SetValuesToControls()
    {
        try
        {


            using (SqlDataReader resultReader = SqlHelper.ExecuteReader(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[ugen_sp_select]",
                new SqlParameter("@tableName", "VMI_Contract"),
                new SqlParameter("@displayColumns", "*"),
                new SqlParameter("@whereCondition", "ContractNo='" + strContractNo + "' and Chain='" + strChain.Replace("||", "&") + "' and ItemNo='" + Request.QueryString["ItemNo"].Trim() + "' and Closed='0'")))
            {
                if (resultReader.Read())
                {
                    hidChainValue.Value= resultReader["Chain"].ToString();
                    txtContract.Text = resultReader["ContractNo"].ToString();
                    if (resultReader["StartDate"].ToString().Trim() == "1/1/1900 12:00:00 AM")
                        txtStartDate.Text ="";
                    else
                        txtStartDate.Text =Convert.ToDateTime(resultReader["StartDate"].ToString()).ToShortDateString();
                    if (resultReader["EndDate"].ToString().Trim() == "1/1/1900 12:00:00 AM")
                        txtEndDate.Text = "";
                    else
                        txtEndDate.Text = Convert.ToDateTime(resultReader["EndDate"].ToString()).ToShortDateString(); ;
                    txtPFCItemNo.Text = resultReader["ItemNo"].ToString();
                    txtRefNo.Text = resultReader["CrossRef"].ToString();
                    txtSubItemNo.Text = resultReader["SubItemNo"].ToString();
                    txtQty.Text = String.Format("{0:#,###}", Convert.ToDecimal(resultReader["EAU_Qty"].ToString()));
                    txtPrice.Text = String.Format("{0:#,##0.00}", Convert.ToDecimal(resultReader["ContractPrice"].ToString()));
                    txtGp.Text = Convert.ToString(Math.Round((Convert.ToDecimal(resultReader["E_Profit_Pct"].ToString()) * 100), 1));
                    txtVendor.Text = resultReader["Vendor"].ToString();
                    txtSales.Text = resultReader["Salesperson"].ToString();
                    txtContact.Text = resultReader["Contact"].ToString();
                    ucPhone.GetPhoneNumber = resultReader["ContactPhone"].ToString();
                    ddlOrder.SelectedValue = resultReader["OrderMethod"].ToString();
                    txtMonth.Text = String.Format("{0:#,##0.0}", Convert.ToDecimal(resultReader["MonthFactor"].ToString()));
                    lblDesc.Text = resultReader["ItemDesc"].ToString();
                    hidDescription.Value = resultReader["ItemDesc"].ToString();
                    txtCustomerPO.Text = resultReader["CustomerPO"].ToString();

                    string strChk = resultReader["Closed"].ToString();
                    if (strChk.Trim() == "1")
                        chkStatus.Checked = true;
                    else
                        chkStatus.Checked = false;
                }
            }


        }
        catch (Exception ex) { }
    }

    private void UpdateContractDetail()
    {
        try
        {
            DataSet dsContract = new DataSet();
            string strStatus = ((chkStatus.Checked) ? "1" : "0");
            string strWhereCondition = string.Empty;
            strWhereCondition = ((Request.QueryString["mode"].Trim().ToLower() == "add") ? "ContractNo='" + txtContract.Text + "' and ItemNo='" + txtPFCItemNo.Text + "' and Chain='" + hidChainValue.Value + "'" : "ContractNo='" + txtContract.Text + "' and  Chain='" + hidChainValue.Value + "' and ItemNo='" + txtPFCItemNo.Text + "' and ItemNo<>'" + Request.QueryString["ItemNo"].Trim() + "'");
            Decimal E_Profit_Pct;
            E_Profit_Pct = ((txtGp.Text == "") ? 0 : (Convert.ToDecimal(txtGp.Text) * Convert.ToDecimal(0.01)));

            using (SqlDataReader checkReader = SqlHelper.ExecuteReader(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[ugen_sp_select]",
                   new SqlParameter("@tableName", "VMI_Contract"),
                   new SqlParameter("@displayColumns", "ItemNo"),
                   new SqlParameter("@whereCondition", strWhereCondition)))
            {
                if (checkReader.Read())
                    strCheck = checkReader["ItemNo"].ToString();
            }

            if (strCheck == "")
            {
                #region Insert contract master values

                if (Request.QueryString["mode"] == "add")
                {
                    strColumnValues = "'" + hidChainValue.Value + "',";
                    strColumnValues += "'" + txtStartDate.Text + "',";
                    strColumnValues += "'" + txtPFCItemNo.Text + "',";
                    strColumnValues += "'" + txtSubItemNo.Text + "',";
                    strColumnValues += "'" + txtPrice.Text.Replace(",", "") + "',";
                    strColumnValues += "'" + txtVendor.Text + "',";
                    strColumnValues += "'" + txtContact.Text + "',";
                    strColumnValues += "'" + ddlOrder.SelectedValue + "',";
                    strColumnValues += "'" + txtContract.Text + "',";
                    strColumnValues += "'" + txtEndDate.Text + "',";
                    strColumnValues += "'" + txtRefNo.Text + "',";
                    strColumnValues += "'" + txtQty.Text.Replace(",", "") + "',";
                    strColumnValues += "'" + (decimal)(Math.Round((double)E_Profit_Pct * 0.01d, 10) * 100) + "',";
                    strColumnValues += "'" + txtSales.Text + "',";
                    strColumnValues += "'" + ucPhone.GetPhoneNumber + "',";
                    strColumnValues += "'" + txtMonth.Text.Replace(",", "") + "',";
                    strColumnValues += "'" + hidDescription.Value + "',";
                    strColumnValues += "'" + strStatus + "',";
                    strColumnValues += "'" + txtCustomerPO.Text.Replace("'","''") + "'";

                    dsContract = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVMI_insert]",
                            new SqlParameter("@tableName", "VMI_Contract"),
                            new SqlParameter("@ColumnNames", ContractColumnNames),
                            new SqlParameter("@ColumnValues", strColumnValues));
                }
                else
                {

                    columnValues = "chain='" + hidChainValue.Value + "',ContractNo='" + txtContract.Text + "',";
                    columnValues += "StartDate='" + txtStartDate.Text + "',EndDate='" + txtEndDate.Text + "',";
                    columnValues += "ItemNo='" + txtPFCItemNo.Text + "',CrossRef='" + txtRefNo.Text + "',";
                    columnValues += "SubItemNo='" + txtSubItemNo.Text + "',EAU_Qty='" + txtQty.Text.Replace(",", "") + "',";
                    columnValues += "ContractPrice='" + txtPrice.Text.Replace(",", "") + "',E_Profit_Pct='" + (decimal)(Math.Round((double)E_Profit_Pct * 0.01d, 10) * 100) + "',";
                    columnValues += "Vendor='" + txtVendor.Text + "',Salesperson='" + txtSales.Text + "',";
                    columnValues += "Contact='" + txtContact.Text + "',ContactPhone='" + ucPhone.GetPhoneNumber + "',";
                    columnValues += "OrderMethod='" + ddlOrder.SelectedValue + "',MonthFactor='" + txtMonth.Text.Replace(",", "") + "',ItemDesc='" + hidDescription.Value + "',Closed='" + strStatus + "',CustomerPO='"+txtCustomerPO.Text.Replace("'","''")+"'";

                    dsContract = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVMI_update]",
                            new SqlParameter("@tableName", "VMI_Contract"),
                            new SqlParameter("@displayColumns", columnValues),
                            new SqlParameter("@whereCondition", "ContractNo='" + Request.QueryString["Contractno"].Trim() + "' and Chain='" + Request.QueryString["ChainName"].Replace("||", "&").Trim() + "' and ItemNo='" + Request.QueryString["ItemNo"].Trim() + "'"));

                    DataSet dsConDet = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVMI_delete]",
                            new SqlParameter("@tableName", "VMI_ContractDetail"),
                            new SqlParameter("@whereCondition", "ContractNo='" + Request.QueryString["Contractno"].Trim() + "' and Chain='" + Request.QueryString["ChainName"].Replace("||", "&").Trim() + "' and ItemNo='" + Request.QueryString["ItemNo"].Trim() + "'"));
                }
                #endregion

                #region Insert Contract Details
                dtReport.Clear();
                string strColumn = string.Empty;
                string[] strData = hidSaveData.Value.Split('~');

                for (int i = 0; i < strData.Length; i++)
                {
                    if (strData[i].Split('#')[0].Trim() != "" && strData[i].Split('#')[1].Trim() != "" && strData[i].Split('#')[2].Trim() != "" && strData[i].Split('#')[3].Trim() != "")
                    {
                        Decimal LocPercent;
                        LocPercent = ((strData[i].Split('#')[1].Trim() == "") ? 0 : (Convert.ToDecimal(strData[i].Split('#')[1].Trim().Replace(",", "")) * Convert.ToDecimal(0.01)));

                        strColumn = "'" + txtContract.Text + "',";
                        strColumn += "'" + hidChainValue.Value + "',";
                        strColumn += "'" + txtPFCItemNo.Text + "',";
                        strColumn += "'" + hidDescription.Value + "',";
                        strColumn += "'" + strData[i].Split('#')[0].Trim() + "',";
                        strColumn += "'" + (decimal)(Math.Round((double)LocPercent * 0.01d, 10) * 100) + "',";
                        strColumn += "'" + strData[i].Split('#')[2].Trim().Replace(",", "") + "',";
                        strColumn += "'" + strData[i].Split('#')[3].Trim().Replace(",", "") + "'";

                        DataSet dsContractDetail = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVMI_insert]",
                            new SqlParameter("@tableName", "VMI_ContractDetail"),
                            new SqlParameter("@ColumnNames", "ContractNo,Chain,ItemNo,ItemDesc,Branch,Pct_Brn_EAU,AnnualQty,Qty30Day"),
                            new SqlParameter("@ColumnValues", strColumn));
                    }
                }
                #endregion
            }
            else
                RegisterClientScriptBlock("check", "<script>javascript:alert('Item # " + strCheck + " is already exists');</script>");
        }
        catch (Exception ex)
        {
            
            throw ex;
        }
    }

    private void RestoreSessionValues()
    {
        tblPreserveValues = Session["PersistControlValues"] as Hashtable;

        hidChainValue.Value = tblPreserveValues["ChainName"].ToString();
        txtContract.Text = tblPreserveValues["ContractNumber"].ToString();
        txtStartDate.Text = tblPreserveValues["StartDate"].ToString();
        txtEndDate.Text = tblPreserveValues["EndDate"].ToString();
        txtVendor.Text = tblPreserveValues["VendorCode"].ToString();
        txtSales.Text = tblPreserveValues["SalesPerson"].ToString();
        txtContact.Text = tblPreserveValues["ContactName"].ToString();
        ddlOrder.SelectedValue = tblPreserveValues["OrderMethod"].ToString();
        txtMonth.Text = tblPreserveValues["MonthFactor"].ToString();
        ucPhone.GetPhoneNumber = tblPreserveValues["PhoneNo"].ToString();
        txtCustomerPO.Text = tblPreserveValues["CustomerPO"].ToString();
    }

    private void CreateBranchCombobox()
    {
        DataSet dsBranchName = Session["BranchComboValues"] as DataSet;

        ddlBranch = "<select name='ddlBranch' id='[BranchID]'   onkeydown='if (event.keyCode==13) {event.keyCode=9; return event.keyCode }'  class='cnt' oncontextmenu='return false;'  onfocus=SetFlag(); onmousedown='javascript:ShowToolTip(event,this.id)'><option selected='selected' value=''>---Select---</option>";
        foreach(DataRow drBranch in dsBranchName.Tables[0].Rows)
        {
            ddlBranch = ddlBranch + "<option value='" + drBranch["Branch"].ToString().Trim() + "'>" + drBranch["Name"].ToString() +"</option>";	                
        }
        ddlBranch = ddlBranch + "</select>";

        hidBranchControl.Value = ddlBranch;
    }

    #endregion
    
    #region Ajax Function To bind the description

    [Ajax.AjaxMethod()]
    public string ValidatePFCItem(string strPFCItem)
    {
        try
        {
            string strDesc = string.Empty;
            string valTxtBox = "false";
            DataTable dtItem = new DataTable();
            if (strPFCItem != "")
            {
                DataSet dsItem = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[ugen_sp_select]",
                new SqlParameter("@tableName", "CuvnalTempItem"),
                new SqlParameter("@displayColumns", "No_,Description"),
                new SqlParameter("@whereCondition", "No_='" + strPFCItem + "'"));
                dtItem = dsItem.Tables[0];
                foreach (DataRow dr in dtItem.Rows)
                {
                    if (strPFCItem == dr["No_"].ToString())
                    {
                        valTxtBox = "true";
                        break;
                    }


                }
                strDesc = GetItemDescription(strPFCItem) + "~" + valTxtBox;
            }
            else
                strDesc = "";

            return strDesc;
        }
        catch (Exception ex)
        { return ""; }

    }
   
    public string GetItemDescription(string strPFCItem)
    {
        try
        {
            if (strPFCItem.Trim() != string.Empty)
            {
                DataSet dsEdit = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[ugen_sp_select]",
                      new SqlParameter("@tableName", "CuvnalTempItem"),
                      new SqlParameter("@displayColumns", "Description"),
                      new SqlParameter("@whereCondition", "No_='" + strPFCItem + "'"));

                string strDesc = dsEdit.Tables[0].Rows[0]["Description"].ToString();
                return strDesc;
            }
            else
            {
                return "";
            }
        }
        catch (Exception ex)
        {
            return "";
        }
    }

    [Ajax.AjaxMethod()]
    public string BindEditData(string strChain, string strContract, string itemNo)
    {
        whereCondition = "ContractNo='" + strContract + "' and Chain='" + strChain.Replace("||", "&") + "' and ItemNo='" + itemNo + "'";
        string sortExpression = " ORDER BY  Branch";
        string strDatabaseValue = string.Empty;

        DataSet dsReport = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[ugen_sp_select]",
        new SqlParameter("@tableName", tableName),
        new SqlParameter("@displayColumns", "Branch,cast((isnull(Pct_Brn_EAU,0) * 100)as decimal(25,1))as Pct_Brn_EAU,cast((isnull(AnnualQty,0))as decimal(25,0))as AnnualQty,cast((isnull(Qty30Day,0))as decimal(25,0)) as Qty30Day"),
        new SqlParameter("@whereCondition", whereCondition + sortExpression));

        //return dsReport.Tables[0];
        if (dsReport.Tables[0] != null)
            foreach (DataRow drow in dsReport.Tables[0].Rows)
                strDatabaseValue += drow[0] + "," + drow[1] + "," + drow[2] + "," + drow[3] + "~";

        strDatabaseValue = ((strDatabaseValue.IndexOf('~') != -1) ? strDatabaseValue.Remove(strDatabaseValue.Length - 1, 1) : strDatabaseValue);
        return strDatabaseValue;


    }
    
    #endregion

    #region Ajax Function To delete the contract details
    [Ajax.AjaxMethod()]
    public void contractDetailDel(string strBranch, string strLocation, string contractNo, string strPFCItem, string Chain)
    {
        try
        {
            Decimal Loc;
            Loc = ((strLocation == "") ? 0 : (Convert.ToDecimal(strLocation) * Convert.ToDecimal(0.01)));
            DataSet dsConDet = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[pVMI_delete]",
                  new SqlParameter("@tableName", "VMI_ContractDetail"),
                  new SqlParameter("@whereCondition", "ContractNo='" + contractNo + "' and ItemNo='" + strPFCItem + "' and Chain='" + Chain + "' and Branch='" + strBranch + "'"));


        }
        catch (Exception ex)
        {

        }
    } 
    #endregion        
}

