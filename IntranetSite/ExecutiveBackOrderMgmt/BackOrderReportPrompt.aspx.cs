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
public partial class BackOrderReportPrompt : System.Web.UI.Page
{
    BackOrderReport orderReport = new BackOrderReport();
    Warehouse warehouse = new Warehouse();
    string PFCQuoteconnectionString = System.Configuration.ConfigurationManager.AppSettings["PFCERPConnectionString"];
    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(BackOrderReportPrompt));
        if (!IsPostBack)
            BindBranch();
        lblmsg.Visible = false;
        
    }
    [Ajax.AjaxMethod(Ajax.HttpSessionStateRequirement.ReadWrite)]
    public string chkItemNo(string itemNo,string where)
    {
        try
        {
            string status = "";
            DataSet dsAvail = orderReport.GetItemNo(itemNo,where);
            if (dsAvail.Tables[0].Rows.Count > 0)
                status = "true";
            //ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "Reference", "Javascript:document.getElementById('txtItemNo').focus();", true);
            else
                status = "false";

            return status;


        }
        catch (Exception ex)
        {

            throw ex;
        }


    }
    private void BindBranch()
    {
        warehouse.BindListControls(ddlLocation, "Name", "Code", warehouse.GetLocation(), "--ALL--");
    }
    protected void btnPrompt_Click(object sender, ImageClickEventArgs e)
    {

        string stritemNo = "";
        string strType = "";
        string _whereClause = "";
        string strchkItemNo = "";
        string strLocation = (ddlLocation.SelectedItem.Value == "") ? "All" : ddlLocation.SelectedItem.Value;
        if (ddlItemSelection.SelectedValue == "2")
        {
            if (txtItemRange1.Text == "" || txtItemRange2.Text == "")
            {
                lblmsg.Text = "Enter the Item Number";
                lblmsg.Visible = true;
            }
            else
            {
                _whereClause = "ItemNo between '" + txtItemRange1.Text.ToString().Trim() + "' and '" + txtItemRange2.Text.ToString().Trim() + "'";
                strchkItemNo = chkItemNo(stritemNo, _whereClause);
                if (strchkItemNo == "false")
                {
                    lblmsg.Text = "Invalid Item Number Range.";
                    lblmsg.Visible = true;
                }
                else
                {
                    stritemNo = txtItemRange1.Text + "," + txtItemRange2.Text.ToString();
                    strType = "Range";
                    ScriptManager.RegisterClientScriptBlock(btnPrompt, btnPrompt.GetType(), "OpenReport", "javascript:OpenReport('" + stritemNo + "','" + strType + "','" + strLocation + "');", true);
                }
            }
        }
        else if (ddlItemSelection.SelectedValue == "3")
        {
            if (txtItem.Text == "")
            {
                lblmsg.Text = "Enter the Item Number.";
                lblmsg.Visible = true;
            }
            else
            {
                stritemNo = txtItem.Text;

                _whereClause = "ItemNo='" + stritemNo + "'";
                 strchkItemNo = chkItemNo(stritemNo, _whereClause);
                if (strchkItemNo == "false")
                {
                    lblmsg.Text = "Invalid Item Number.";
                    lblmsg.Visible = true;
                }
                else
                {
                    strType = "Number";
                    ScriptManager.RegisterClientScriptBlock(btnPrompt, btnPrompt.GetType(), "OpenReport", "javascript:OpenReport('" + stritemNo + "','" + strType + "','" + strLocation + "');", true);
                }
            }
        }
        else
        {
            stritemNo = "All";
            strType = "All";
            ScriptManager.RegisterClientScriptBlock(btnPrompt, btnPrompt.GetType(), "OpenReport", "javascript:OpenReport('" + stritemNo + "','" + strType + "','" + strLocation + "');", true);
        }

       
        
        
    }
    protected void btnClear_Click(object sender, ImageClickEventArgs e)
    {
        clearSelection();
    }
    protected void ddlItemSelection_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlItemSelection.SelectedValue == "2")
        {
            tblrange.Visible = true;
            tblItem.Visible = false;
            clearSelection(); 
        }
        else if (ddlItemSelection.SelectedValue == "3")
        {
            tblrange.Visible = false;
            tblItem.Visible = true;
            clearSelection();
        }
        else
        {
            tblrange.Visible = false;
            tblItem.Visible = false;
            clearSelection();
        }
    }
    protected void clearSelection()
    {
        txtItemRange1.Text = "";
        txtItemRange2.Text = "";
        txtItem.Text = "";
        ddlLocation.ClearSelection(); 
    }
}
