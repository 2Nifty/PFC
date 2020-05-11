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
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;

public partial class Rebate : System.Web.UI.Page
{
    PartnerRebate rebate = new PartnerRebate();
    DataTable dtRebate = new DataTable();
    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(Rebate));

        if (!IsPostBack)
        {
            BindProgram();
            ViewState["Mode"] = "Add";
            BindChainCustNo();
          
        } 
    }
    protected void ddlProgram_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void ddlChainCust_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void rdoCustChain_SelectedIndexChanged(object sender, EventArgs e)
    {
        BindChainCustNo();
       
    }

    private void BindChainCustNo()
    {
        if (rdoCustChain.SelectedValue == "Chain")
        {
            rebate.BindListControls(ddlChainCust, "ChainCd", "CustName", rebate.GetCustomerNo(), "--Select--");
        }
        if (rdoCustChain.SelectedValue == "Cust")
        {
            rebate.BindListControls(ddlChainCust, "CustNo", "CustName", rebate.GetCustomerNo(), "ALL");
        }

        upnlEntry.Update();
    }
    private void BindProgram()
    {
        rebate.BindListControls(ddlProgram, "ListDesc", "ListValue", rebate.GetProgram(), "--Select--");
    }
}
