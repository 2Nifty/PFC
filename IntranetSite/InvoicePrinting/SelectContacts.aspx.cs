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
using System.Data.Sql;
using System.Data.SqlClient;

using PFC.SOE.BusinessLogicLayer;

public partial class SelectContacts : System.Web.UI.Page
{
    SelectContact contact = new SelectContact();
    string custNo = "";
    string mode = "";

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(SelectContacts));
        mode = Request.QueryString["Mode"].ToString();
        if (Request.QueryString["CustomerNo"] != null)
        {
            custNo = Request.QueryString["CustomerNo"].ToString();
        }
      // mode = "Email";
        if(!IsPostBack)
        {
       // custNo ="060997";
       
        BindGrid(custNo);
        }
    }

    private void BindGrid(string custNum)
    {
        
        DataTable dtContact = contact.GetContacts(custNum);
        if (dtContact != null && dtContact.Rows.Count > 0)
        {
            if (hidSort.Value != "")
                dtContact.DefaultView.Sort = hidSort.Value;

            gvContacts.DataSource = dtContact.DefaultView;
            gvContacts.DataBind();
        }
        else 
        {
 
        }
        upnlContactsGrid.Update();
    }
  
    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
       // ((CheckBox)GridView1.HeaderRow.Cells[0].FindControl("chkSelectAll")).Attributes.Add("onclick", "selectAll('" + chkboxIds + "',this);"); 
        if (((CheckBox)gvContacts.HeaderRow.FindControl("ChkSelectAll")).Checked == true)
        {
            foreach (GridViewRow gvr in gvContacts.Rows)
            {
                ((CheckBox)gvr.FindControl("ChkSelect")).Checked = true;

            }
        }
        else
        {
            foreach (GridViewRow gvr in gvContacts.Rows)
            {
                ((CheckBox)gvr.FindControl("ChkSelect")).Checked = false ;

            }
        }
    }

    protected void btnOk_Click(object sender, ImageClickEventArgs e)
    { 
        ArrayList names = new ArrayList();
        foreach (GridViewRow gvr in gvContacts.Rows)
        {

            //CheckBox cb = dr.FindControl("ChkSelect") as CheckBox;
            if (((CheckBox)gvr.FindControl("ChkSelect")).Checked == true)
            {
                if (mode == "Email")
                    names.Add(gvr.Cells[3].Text);
                else
                {
                    names.Add(gvr.Cells[4].Text);
                }
            } 
        }
        Label1.Text = "";
        foreach (object itm in names)
        {
            if(itm.ToString() != "&nbsp;" )
            Label1.Text += itm.ToString() + " ,";

        }
        if (Label1.Text.Length > 0)
        {
            Label1.Text = Label1.Text.Remove(Label1.Text.Length - 1);
        }
        //ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Load", "window.opener.document.getElementById('lblParent').innerText ='" + Label1.Text + "'; ", true);

       ScriptManager.RegisterClientScriptBlock(this, typeof(Page), "Load", "Pass('" + Label1.Text + "','"+ mode+"');", true);
         
    }
    protected void gvContacts_RowDataBound(object sender, GridViewRowEventArgs e)
    {
       
            if (mode == "Email")
            {
                e.Row.Cells[4].Visible = false;

            }
            else
            {
                e.Row.Cells[3].Visible = false;
            }
       
    }

    protected void gvContacts_Sorting1(object sender, GridViewSortEventArgs e)
    {
        if (hidSort.Attributes["sortType"] != null)
        {
            if (hidSort.Attributes["sortType"].ToString() == "ASC")
                hidSort.Attributes["sortType"] = "DESC";
            else
                hidSort.Attributes["sortType"] = "ASC";
        }
        else
            hidSort.Attributes.Add("sortType", "ASC");

        hidSort.Value = e.SortExpression + " " + hidSort.Attributes["sortType"].ToString();

        BindGrid(custNo);
    }
}
