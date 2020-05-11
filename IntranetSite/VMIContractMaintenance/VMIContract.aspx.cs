/********************************************************************************************
 * File	Name			:	VMIContract.aspx.cs
 * File Type			:	C#
 * Project Name			:	Vendor Managed Inventory Contract Maintenance
 * Module Description	:	Get Chain Name and Contract Number
 * Created By			:	A.Nithyapriyadarshini
 * Created Date			:	02/21/2007	
 * History				: 
 * DATE					VERSION			AUTHOR			            ACTION
 * ****					*******			******				        ******
 * 02/21/2007		    Version 1		A.Nithyapriyadarshini		Created 
  *********************************************************************************************/

#region Namespace

using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
using System.Reflection;
using PFC.Intranet.Securitylayer;
using PFC.VMIReports;

#endregion

public partial class VMIContractMaintenancePrompt : System.Web.UI.Page
{

    #region Global Declaration

    DataSet dsCustomerChainNo = new DataSet();
    DataTable dtContract = new DataTable();
    DataSet dsContract = new DataSet();
    
    #endregion

    #region Auto generated event

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        Ajax.Utility.RegisterTypeForAjax(typeof(VMIContractMaintenancePrompt));
        if (!IsPostBack)
        {
            BindChainName();
        }
    }

    protected void ddlChainName_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindContracts();
    }

    #endregion

    #region Developer generated code

    private void BindChainName()
    {
        try
        {
            // function to get chain data 
            VMIReports vmiReports = new VMIReports();
            DataTable dtChain = vmiReports.GetChainData();

            // fill DropdownList ChainName
            ddlChainName.DataSource = dtChain;
            ddlChainName.DataTextField = "Code";
            ddlChainName.DataValueField = "ChainCode";
            ddlChainName.DataBind();
            ddlChainName.Items.Insert(0, new ListItem("--- Select ---", "0"));
        }
        catch (Exception ex) { }
    }

    private void BindContracts()
    {
        try
        {
            dsContract = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[ugen_sp_select]",
                new SqlParameter("@tableName", "VMI_Contract"),
                new SqlParameter("@displayColumns", "Distinct ContractNo"),
                new SqlParameter("@whereCondition", "Chain='" + ddlChainName.SelectedValue.Trim() + "' and Closed='0'"));
            dtContract = dsContract.Tables[0];

        }
        catch (Exception ex) { }
    } 

    #endregion
    
    #region Ajax Method for getting Contract #
    [Ajax.AjaxMethod]
    public string GetContractNumbers(string chain)
    {
        try
        {
            string result = string.Empty;
            dsContract = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[ugen_sp_select]",
                new SqlParameter("@tableName", "VMI_Contract"),
                new SqlParameter("@displayColumns", "Distinct ContractNo"),
                new SqlParameter("@whereCondition", "Chain='" + chain + "' and Closed='0'"));
            dtContract = dsContract.Tables[0];

            foreach (DataRow dr in dtContract.Rows)
            {
                result = result + "~" + dr["ContractNo"].ToString();
            }

            if (dtContract.Rows.Count > 0)
                result = result.Remove(0, 1);

            return result;

        }
        catch (Exception ex)
        { return ""; }

    }
    #endregion

    #region Ajax Method for getting Item #
    [Ajax.AjaxMethod]
    public string GetItemNumbers(string chain, string contract)
    {
        try
        {
            string result = string.Empty;
            dsContract = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[ugen_sp_select]",
                new SqlParameter("@tableName", "VMI_Contract"),
                new SqlParameter("@displayColumns", "ItemNo"),
                new SqlParameter("@whereCondition", "Chain='" + chain + "' and ContractNo='" + contract + "' and Closed='0'"));
            dtContract = dsContract.Tables[0];

            foreach (DataRow dr in dtContract.Rows)
            {
                result = result + "~" + dr["ItemNo"].ToString();
            }

            if (dtContract.Rows.Count > 0)
                result = result.Remove(0, 1);

            return result;

        }
        catch (Exception ex)
        { return ""; }

    }
    #endregion

}