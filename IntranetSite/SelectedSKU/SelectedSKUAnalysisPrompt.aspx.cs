using System;
using System.IO;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Data.SqlClient;
using System.Data.OleDb;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet;
using PFC.Intranet.BusinessLogicLayer;

public partial class SelectedSKUAnalysisPrompt : System.Web.UI.Page
{
    ddlBind ddlBind = new ddlBind();
    
    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(SelectedSKUAnalysisPrompt));

        if (!IsPostBack)
        {
            ddlBind.BindLoc_BranchComboValues(ddlStrLoc);
            //ddlStrLoc.Items.Insert(0, new ListItem("---- All ----", System.Web.HttpContext.Current.Session["BranchIDForALL"].ToString()));
            ddlStrLoc.Items.Insert(0, new ListItem("---- All ----", "ALL"));
            ddlStrLoc.Items.Insert(1, new ListItem("00 - Corp Summary", "00"));
            ddlBind.BindLoc_BranchComboValues(ddlEndLoc);
            ddlEndLoc.Items.Insert(0, new ListItem(" ", " "));
            //ddlEndLoc.Items.Insert(1, new ListItem("ALL", System.Web.HttpContext.Current.Session["BranchIDForALL"].ToString()));
            txtLocList.Text = string.Empty;

            txtStrCat.Text = string.Empty;
            txtEndCat.Text = string.Empty;
            txtCatList.Text = string.Empty;

            txtStrSize.Text = string.Empty;
            txtEndSize.Text = string.Empty;
            txtSizeList.Text = string.Empty;

            txtStrVar.Text = string.Empty;
            txtEndVar.Text = string.Empty;
            txtVarList.Text = string.Empty;

            ddlBind.BindFromList("CVCCodes", ddlStrCFV, "ALL", "ALL");
            ddlBind.BindFromList("CVCCodes", ddlEndCFV, " ", " ");
            txtCFVList.Text = string.Empty;

            ddlBind.BindFromList("SVCCodes", ddlStrSVC, "ALL", "ALL");
            ddlBind.BindFromList("SVCCodes", ddlEndSVC, " ", " ");
            txtSVCList.Text = string.Empty;

            ddlBind.BindFromList("SKUWebEnabled", ddlWeb, string.Empty, string.Empty);

            txtStrDt.Text = string.Empty;
            txtEndDt.Text = string.Empty;
        }
    }

    #region Toggle Param List Check Boxes

    //if CHECKED
    //     then CLEAR & DISABLE Start & End
    //          ENABLE List
    //     else CLEAR & DISABLE List
    //          ENABLE Start & End
    
    protected void chkLocList_CheckedChanged(object sender, EventArgs e)
    {
        if (chkLocList.Checked)
        {
            ddlStrLoc.SelectedIndex = 0;
            ddlStrLoc.Enabled = false;
            ddlEndLoc.SelectedIndex = 0;
            ddlEndLoc.Enabled = false;
            txtLocList.Enabled = true;
        }
        else
        {
            txtLocList.Text = string.Empty;
            txtLocList.Enabled = false;
            ddlStrLoc.Enabled = true;
            ddlEndLoc.Enabled = true;
        }
    }

    protected void chkCatList_CheckedChanged(object sender, EventArgs e)
    {
        if (chkCatList.Checked)
        {
            txtStrCat.Text = string.Empty;
            txtStrCat.Enabled = false;
            txtEndCat.Text = string.Empty;
            txtEndCat.Enabled = false;
            txtCatList.Enabled = true;
        }
        else
        {
            txtCatList.Text = string.Empty;
            txtCatList.Enabled = false;
            txtStrCat.Enabled = true;
            txtEndCat.Enabled = true;
        }
        pnlCat.Update();
    }

    protected void chkSizeList_CheckedChanged(object sender, EventArgs e)
    {
        if (chkSizeList.Checked)
        {
            txtStrSize.Text = string.Empty;
            txtStrSize.Enabled = false;
            txtEndSize.Text = string.Empty;
            txtEndSize.Enabled = false;
            txtSizeList.Enabled = true;
        }
        else
        {
            txtSizeList.Text = string.Empty;
            txtSizeList.Enabled = false;
            txtStrSize.Enabled = true;
            txtEndSize.Enabled = true;
        }
        pnlSize.Update();
    }

    protected void chkVarList_CheckedChanged(object sender, EventArgs e)
    {
        if (chkVarList.Checked)
        {
            txtStrVar.Text = string.Empty;
            txtStrVar.Enabled = false;
            txtEndVar.Text = string.Empty;
            txtEndVar.Enabled = false;
            txtVarList.Enabled = true;
        }
        else
        {
            txtVarList.Text = string.Empty;
            txtVarList.Enabled = false;
            txtStrVar.Enabled = true;
            txtEndVar.Enabled = true;
        }
        pnlVar.Update();
    }

    protected void chkCFVList_CheckedChanged(object sender, EventArgs e)
    {
        if (chkCFVList.Checked)
        {
            ddlStrCFV.SelectedIndex = 0;
            ddlStrCFV.Enabled = false;
            ddlEndCFV.SelectedIndex = 0;
            ddlEndCFV.Enabled = false;
            txtCFVList.Enabled = true;
        }
        else
        {
            txtCFVList.Text = string.Empty;
            txtCFVList.Enabled = false;
            ddlStrCFV.Enabled = true;
            ddlEndCFV.Enabled = true;
        }
        pnlCFV.Update();
    }

    protected void chkSVCList_CheckedChanged(object sender, EventArgs e)
    {
        if (chkSVCList.Checked)
        {
            ddlStrSVC.SelectedIndex = 0;
            ddlStrSVC.Enabled = false;
            ddlEndSVC.SelectedIndex = 0;
            ddlEndSVC.Enabled = false;
            txtSVCList.Enabled = true;
        }
        else
        {
            txtSVCList.Text = string.Empty;
            txtSVCList.Enabled = false;
            ddlStrSVC.Enabled = true;
            ddlEndSVC.Enabled = true;
        }
        pnlSVC.Update();
    }

    #endregion

    #region Dates

    #region StartDt
    protected void ibtnStartDt_Click(object sender, ImageClickEventArgs e)
    {
        if (cldStartDt.Visible == false)
            cldStartDt.Visible = true;
        else
            cldStartDt.Visible = false;
        pnlStartPick.Update();
    }

    protected void txtStrDt_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = string.Empty;
        pnlStatus.Update();
        try
        {
            if (!ValidateDate(Convert.ToDateTime(txtStrDt.Text)))
            {
                cldStartDt.SelectedDate = DateTime.Now;
                txtStrDt.Text = string.Empty;
                smSKU.SetFocus(txtStrDt);
                lblMessage.Text = "Invalid Start date";
                pnlStatus.Update();
            }
            else
            {
                txtStrDt.Text = Convert.ToDateTime(txtStrDt.Text).ToShortDateString();
                pnlStartDt.Update();
                smSKU.SetFocus(txtEndDt);
            }

            if (txtEndDt.Text != "" && DateTime.Compare(Convert.ToDateTime(txtEndDt.Text), Convert.ToDateTime(txtStrDt.Text)) == -1)
            {
                txtStrDt.Text = string.Empty;
                smSKU.SetFocus(txtStrDt);
                lblMessage.Text = "Start date must be less than or equal to End date (1)";
                pnlStatus.Update();
            }
        }
        catch (Exception ex)
        {
            txtStrDt.Text = string.Empty;
            smSKU.SetFocus(txtStrDt);
            lblMessage.Text = "Invalid Start date (ex)";
            pnlStatus.Update();
        }
    }

    protected void cldStartDt_SelectionChanged(object sender, EventArgs e)
    {
        lblMessage.Text = string.Empty;
        pnlStatus.Update();
        if (ValidateDate(cldStartDt.SelectedDate))
        {
            txtStrDt.Text = cldStartDt.SelectedDate.ToShortDateString();
            pnlStartDt.Update();
            pnlStartPick.Update();
            smSKU.SetFocus(txtEndDt);
        }
        else
        {
            txtStrDt.Text = string.Empty;
            smSKU.SetFocus(txtStrDt);
            cldStartDt.SelectedDate = Convert.ToDateTime(DateTime.Now);
        }

        if (txtEndDt.Text != "" && DateTime.Compare(Convert.ToDateTime(txtEndDt.Text), Convert.ToDateTime(txtStrDt.Text)) == -1)
        {
            txtStrDt.Text = string.Empty;
            smSKU.SetFocus(txtStrDt);
            lblMessage.Text = "Start date must be less than or equal to End date (2)";
            pnlStatus.Update();
        }
    }
    #endregion

    #region EndDt
    protected void ibtnEndDt_Click(object sender, ImageClickEventArgs e)
    {
        if (cldEndDt.Visible == false)
            cldEndDt.Visible = true;
        else
            cldEndDt.Visible = false;
        pnlEndPick.Update();
    }

    protected void txtEndDt_TextChanged(object sender, EventArgs e)
    {
        lblMessage.Text = string.Empty;
        pnlStatus.Update();
        try
        {
            if (!ValidateDate(Convert.ToDateTime(txtEndDt.Text)))
            {
                cldEndDt.SelectedDate = DateTime.Now;
                txtEndDt.Text = string.Empty;
                smSKU.SetFocus(txtEndDt);
                lblMessage.Text = "Invalid End date";
                pnlStatus.Update();
            }
            else
            {
                txtEndDt.Text = Convert.ToDateTime(txtEndDt.Text).ToShortDateString();
                pnlEndDt.Update();
            }

            if (txtStrDt.Text != "" && DateTime.Compare(Convert.ToDateTime(txtEndDt.Text), Convert.ToDateTime(txtStrDt.Text)) == -1)
            {
                txtEndDt.Text = string.Empty;
                smSKU.SetFocus(txtEndDt);
                lblMessage.Text = "End date must be greater than or equal to Start date (1)";
                pnlStatus.Update();
            }
        }
        catch (Exception ex)
        {
            txtEndDt.Text = string.Empty;
            smSKU.SetFocus(txtEndDt);
            lblMessage.Text = "Invalid End date (ex)";
            pnlStatus.Update();
        }
    }

    protected void cldEndDt_SelectionChanged(object sender, EventArgs e)
    {
        lblMessage.Text = string.Empty;
        pnlStatus.Update();
        if (ValidateDate(cldEndDt.SelectedDate))
        {
            txtEndDt.Text = cldEndDt.SelectedDate.ToShortDateString();
            pnlEndDt.Update();
            pnlEndPick.Update();
        }
        else
        {
            txtEndDt.Text = string.Empty;
            smSKU.SetFocus(txtEndDt);
            cldEndDt.SelectedDate = Convert.ToDateTime(DateTime.Now);
        }
        if (txtEndDt.Text != "" && DateTime.Compare(Convert.ToDateTime(txtEndDt.Text), Convert.ToDateTime(txtStrDt.Text)) == -1)
        {
            txtEndDt.Text = string.Empty;
            smSKU.SetFocus(txtEndDt);
            lblMessage.Text = "End date must be greater than or equal to Start date (2)";
            pnlStatus.Update();
        }
    }
    #endregion

    private bool ValidateDate(DateTime date)
    {
        if (DateTime.Compare(DateTime.Now, date) == -1)
        {
            lblMessage.Text = "Date must be less than or equal current date";
            pnlStatus.Update();
            return false;
        }
        else
            return true;
    }

    #endregion
}