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
using PFC.Intranet.DataAccessLayer;
using PFC.VMIReports; 

#endregion

public partial class VMIChain : System.Web.UI.UserControl
{

    #region Property Bag

    public string ChainValue
    {
        set
        {
            ddlChain.SelectedValue = value;

        }
        get
        {
            return ddlChain.SelectedValue;
        }
    } 

    #endregion

    #region Auto generated event

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack)
            BindChain();
    } 

    #endregion

    #region Developer generated code

    private void BindChain()
    {
        try
        {
            // function to get chain data 
            VMIReports vmiReports = new VMIReports();
            DataTable dtChain = vmiReports.GetChainData();

            // fill DropdownList ChainName
            ddlChain.DataSource = dtChain;
            ddlChain.DataTextField = "Code";
            ddlChain.DataValueField = "ChainCode";
            ddlChain.DataBind();
            ddlChain.Items.Insert(0, new ListItem("--- Select ---", "0"));

        }
        catch (Exception ex) { }
    } 

    #endregion

}
