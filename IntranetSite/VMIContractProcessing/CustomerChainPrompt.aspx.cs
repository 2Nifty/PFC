/********************************************************************************************
 * File	Name			:	VMIManagementReport.aspx.cs
 * File Type			:	C#
 * Project Name			:	Vendor Managed Inventory
 * Module Description	:	Get Customer Chain Number
 * Created By			:	A.Nithyapriyadarshini
 * Created Date			:	02/12/2007	
 * History				: 
 * DATE					VERSION			AUTHOR			            ACTION
 * ****					*******			******				        ******
 * 02/12/2007		    Version 1		A.Nithyapriyadarshini		Created 
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
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.SqlClient;
using System.Threading;
using System.IO;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet;
using System.Reflection;
using PFC.Intranet.Securitylayer;
using PFC.VMIReports; 

#endregion

public partial class SystemFrameSet_PromptCustomerChain : System.Web.UI.Page
{

    #region Auto genereated events

    protected void Page_Load(object sender, EventArgs e)
    {
        SystemCheck systemCheck = new SystemCheck();
        systemCheck.SessionCheck();
        if (!IsPostBack)
        {
            BindCustomerChainNo();
        }

    }
 
    #endregion

    #region Developer generated code

    private void BindCustomerChainNo()
    {
        try
        {

            // function to get chain data 
            VMIReports vmiReports = new VMIReports();
            DataTable dtChain = vmiReports.GetChainData();

            // fill DropdownList ChainName
            ddlCustomerChainNo.DataSource = dtChain;
            ddlCustomerChainNo.DataTextField = "Code";
            ddlCustomerChainNo.DataValueField = "ChainCode";
            ddlCustomerChainNo.DataBind();
            ddlCustomerChainNo.Items.Insert(0, new ListItem("--- Select ---", "0"));

        }
        catch (Exception ex) { }
    } 

    #endregion

}
