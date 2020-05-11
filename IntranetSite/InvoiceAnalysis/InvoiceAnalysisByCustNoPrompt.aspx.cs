/********************************************************************************************
 * File	Name			:	InvoiceAnalysis.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Invoice Analysis report
 * Created By			:	Sathish
 * Created Date			:	08/27/2008
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/27/2008		    Version 1		Sathish      		Created 
 *********************************************************************************************/
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
using System.Windows.Forms;
using System.Data.SqlClient;
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;
using PFC.Intranet.BusinessLogicLayer;
using System.Threading;

namespace PFC.Intranet
{
    public partial class InvoiceAnalysisPrompt : System.Web.UI.Page
    {
        SalesReportUtils salesReportUtils = new SalesReportUtils();
        InvoiceAnalysis invoiceAnalysis = new InvoiceAnalysis();
        string opt = string.Empty;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            lblError.Visible = false;
            if (!IsPostBack)
            {    
                salesReportUtils.FillBranchesAndChainSession(Session["UserID"].ToString());

                cldStartDt.SelectedDate = Convert.ToDateTime(DateTime.Now.AddDays(-6).ToShortDateString());
                cldStartDt.VisibleDate = Convert.ToDateTime(DateTime.Now.AddDays(-6).ToShortDateString());
                cldEndDt.SelectedDate = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                cldEndDt.VisibleDate = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                hidEndDt.Value = cldEndDt.SelectedDate.ToShortDateString();
                hidStartDt.Value = cldStartDt.SelectedDate.ToShortDateString();

                FillBranches();
                FillTerritory();
                FillOutsideRep();
                FillShipMethod();
                FillInsideRep();
                FillRegionalMgr();
                FillPriceCd();
                FillOrderSource();
                FillBuyGroup();
            }
        }

        public void FillBranches()
        {
            try
            {
                salesReportUtils.GetALLBranches(ddlBranch, Session["UserID"].ToString());
                salesReportUtils.GetChainName(ddlChain);
            }
            catch (Exception ex) { }
        }

        public void FillTerritory()
        {
            string branchID = (ddlBranch.SelectedIndex == 0 ? "ALL" : ddlBranch.SelectedValue);
            DataTable dt = invoiceAnalysis.GetTerritory(branchID);
            ddlTerritory.DataSource = dt;
            ddlTerritory.DataValueField = "ValueField";
            ddlTerritory.DataTextField = "TextField";
            ddlTerritory.DataBind();
            ddlTerritory.Items.Insert(0, new ListItem("ALL", "ALL"));
        }

        public void FillOutsideRep()
        {
            string branchID = (ddlBranch.SelectedIndex == 0 ? "ALL" : ddlBranch.SelectedValue);
            DataTable dt = invoiceAnalysis.GetCSRNames(branchID);
            ddlOutsideRep.DataSource = dt;
            ddlOutsideRep.DataValueField = "RepNo";
            ddlOutsideRep.DataTextField = "RepName";
            ddlOutsideRep.DataBind();
            ddlOutsideRep.Items.Insert(0, new ListItem("ALL", "ALL"));
        }

        public void FillShipMethod()
        {
            DataTable dt = invoiceAnalysis.GetDataFromTables("FGHT");
            ddlShipMethod.DataSource = dt;
            ddlShipMethod.DataValueField = "ValueField";
            ddlShipMethod.DataTextField = "TextField";
            ddlShipMethod.DataBind();
            ddlShipMethod.Items.Insert(0, new ListItem("ALL", "ALL"));
        }

        public void FillInsideRep()
        {
            string branchID = (ddlBranch.SelectedIndex == 0 ? "ALL" : ddlBranch.SelectedValue);
            DataTable dt = invoiceAnalysis.GetSalesPerson(branchID);
            ddlInsideRep.DataSource = dt;
            ddlInsideRep.DataValueField = "RepNo";
            ddlInsideRep.DataTextField = "RepName";
            ddlInsideRep.DataBind();
            ddlInsideRep.Items.Insert(0, new ListItem("ALL", "ALL"));            
        }

        public void FillRegionalMgr()
        {
            string branchID = (ddlBranch.SelectedIndex == 0 ? "ALL" : ddlBranch.SelectedValue);
            DataTable dt = invoiceAnalysis.GetRegionalMgr(branchID);
            ddlRegionalMgr.DataSource = dt;
            ddlRegionalMgr.DataValueField = "RepNo";
            ddlRegionalMgr.DataTextField = "RepName";
            ddlRegionalMgr.DataBind();
            ddlRegionalMgr.Items.Insert(0, new ListItem("ALL", "ALL"));
        }

        public void FillPriceCd()
        {
            DataTable dt = invoiceAnalysis.GetDataFromList("CustPriceCd");
            ddlPriceCd.DataSource = dt;
            ddlPriceCd.DataValueField = "ValueField";
            ddlPriceCd.DataTextField = "TextField";
            ddlPriceCd.DataBind();
            ddlPriceCd.Items.Insert(0, new ListItem("ALL", "ALL"));
        }     

        public void FillOrderSource()
        {
            DataTable dt = invoiceAnalysis.GetDataFromList("SOEOrderSource");
            ddlOrderSource.DataSource = dt;
            ddlOrderSource.DataValueField = "ValueField";
            ddlOrderSource.DataTextField = "TextField";
            ddlOrderSource.DataBind();
            ddlOrderSource.Items.Insert(0, new ListItem("*All Orders*", "ALL"));
            ddlOrderSource.Items.Insert(1, new ListItem("*All CSR Orders*", "ALLCSR"));
            ddlOrderSource.Items.Insert(2, new ListItem("*All eCommerce Orders*", "ALLEC"));
        }

        public void FillBuyGroup()
        {
            DataTable dt = invoiceAnalysis.GetDataFromList("BuyGrp");
            ddlBuyGroup.DataSource = dt;
            ddlBuyGroup.DataValueField = "ValueField";
            ddlBuyGroup.DataTextField = "TextField";
            ddlBuyGroup.DataBind();
            ddlBuyGroup.Items.Insert(0, new ListItem("ALL", "ALL"));
        }

        protected void cldStartDt_SelectionChanged(object sender, EventArgs e)
        {
            hidStartDt.Value = cldStartDt.SelectedDate.ToShortDateString();
        }

        protected void cldEndDt_SelectionChanged(object sender, EventArgs e)
        {
            hidEndDt.Value = cldEndDt.SelectedDate.ToShortDateString();
        }

        protected void txtCustNo_TextChanged(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(txtCustNo.Text.ToString().Trim()))
            {
                chkAllCust.Enabled = true;
            }
            else
            {
                chkAllCust.Checked = false;
                chkAllCust.Enabled = false;
            }
            pnlAllCust.Update();
        }

        protected void ddlBranch_SelectedIndexChanged(object sender, EventArgs e)
        {
            FillTerritory();
            FillOutsideRep();
            FillInsideRep();
            FillRegionalMgr();

            pnlTerritory.Update();
            pnlOutsideRep.Update();
            pnlInsideRep.Update();
            pnlRegionalMgr.Update();
        }

        //protected void ddlShipMethod_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    if (ddlShipMethod.SelectedValue.ToUpper() == "ALL")
        //    {
        //        ddlSubTot.SelectedValue = "0";
        //        chkSubTot.Checked = false;
        //        chkSubTot.Enabled = false;
        //    }
        //    else
        //    {
        //        ddlSubTot.SelectedValue = "9";
        //        chkSubTot.Enabled = true;
        //    }

        //    pnlShipMeth.Update();
        //    pnlSubTot.Update();
        //    pnlCheckbox.Update();
        //}

        //protected void ddlSubTot_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    if (ddlSubTot.SelectedValue == "0")
        //    {
        //        chkSubTot.Checked = false;
        //        chkSubTot.Enabled = false;
        //    }
        //    else
        //        chkSubTot.Enabled = true;

        //    pnlShipMeth.Update();
        //    pnlSubTot.Update();
        //    pnlCheckbox.Update();
        //}

        protected void chkAllCust_CheckedChanged(object sender, EventArgs e)
        {
            if (chkAllCust.Checked)
            {
                txtCustNo.Text = "";
                txtCustNo.Enabled = false;
            }
            else
            {
                txtCustNo.Enabled = true;
            }
            pnlCustNo.Update();
        }
    }
}