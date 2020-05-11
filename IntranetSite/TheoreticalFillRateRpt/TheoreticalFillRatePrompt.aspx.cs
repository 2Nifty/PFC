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

public partial class TheoreticalFillRatePrompt : System.Web.UI.Page
{
    ddlBind ddlBind = new ddlBind(); 

    protected void Page_Load(object sender, EventArgs e)
    {
        Ajax.Utility.RegisterTypeForAjax(typeof(TheoreticalFillRatePrompt));

        if (!IsPostBack)
        {
            ddlBind.BindLoc_BranchComboValues(ddlStrLoc);
           // ddlStrLoc.Items.Insert(0, new ListItem("---- All ----", System.Web.HttpContext.Current.Session["BranchIDForALL"].ToString()));
            ddlStrLoc.Items.Insert(0, new ListItem("00 - Corp Summary", "00"));
            ddlBind.BindLoc_BranchComboValues(ddlEndLoc);
            ddlEndLoc.Items.Insert(0, new ListItem(" ", " "));
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

            ddlBind.BindFromList("SKUWebEnabled", ddlWeb, "", "");

            ddlPkType.SelectedValue = "0";

            txtRollingMonths.Text = string.Empty;
            txtPkgCdList.Text = string.Empty;
            txtPlatedCdList.Text = string.Empty;
            
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

    protected void chkPkgCdList_CheckedChanged(object sender, EventArgs e)
    {
        if (chkPkgCdList.Checked)
        {
            ddlPkType.SelectedIndex = 0;
            ddlPkType.Enabled = false;
            txtPkgCdList.Enabled = true;
        }
        else
        {
            txtPkgCdList.Text = string.Empty;
            txtPkgCdList.Enabled = false;
            ddlPkType.Enabled = true;
        }
        pnlSVC.Update();
    }

    protected void chkAddWO_CheckedChanged(object sender, EventArgs e)
    {
        //if (chkAddPO.Checked)
        //{
        //    //_addAvailWO = "Y";
        //}
        //else
        //{
        //    //_addAvailWO = "N";
        //}
        //pnlAddWO.Update();

    }
    protected void chkAddPO_CheckedChanged(object sender, EventArgs e)
    {
        //if (chkAddPO.Checked)
        //{
        //    //_addAvailPO = "Y";
        //}
        //else
        //{
        //    //_addAvailPO = "N";
        //}
        //pnlAddPO.Update();

    }
    protected void chkAddTI_CheckedChanged(object sender, EventArgs e)
    {
        //if (chkAddTI.Checked)
        //{
        //    //_addAvailTI = "Y";
        //}
        //else
        //{
        //    //_addAvailTI = "N";
        //}
       // pnlAddTI.Update();

    }
}

    #endregion

   