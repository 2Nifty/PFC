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

                //cldStartDt.SelectedDate = Convert.ToDateTime("12/23/2007");
                //cldStartDt.VisibleDate = Convert.ToDateTime("12/23/2007");
                //cldEndDt.SelectedDate = Convert.ToDateTime("01/26/2008");
                //cldEndDt.VisibleDate = Convert.ToDateTime("01/26/2008");
                hidEndDt.Value = cldEndDt.SelectedDate.ToShortDateString();
                hidStartDt.Value = cldStartDt.SelectedDate.ToShortDateString();

                FillBranches();
                for (int i = 0; i <= ddlBranch.Items.Count - 1; i++)
                {
                    if (ddlBranch.Items[i].Value.Trim() == Session["BranchID"].ToString())
                    {
                        ddlBranch.Items[i].Selected = true;
                        break;
                    }
                }
                FillShipMethod();
                FillSalesPerson();
                FillPriceCd();
                FillOrderSource();
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

        public void FillShipMethod()
        {
            DataTable dt = invoiceAnalysis.GetDataFromTables("FGHT");
            ddlShipMethod.DataSource = dt;
            ddlShipMethod.DataValueField = "ValueField";
            ddlShipMethod.DataTextField = "TextField";
            ddlShipMethod.DataBind();
            ddlShipMethod.Items.Insert(0, new ListItem("ALL", "ALL"));
        }

        public void FillSalesPerson()
        {
            DataTable dt = invoiceAnalysis.GetSalesPerson();
            ddlSalesPerson.DataSource = dt;
            ddlSalesPerson.DataValueField = "RepNo";
            ddlSalesPerson.DataTextField = "RepName";
            ddlSalesPerson.DataBind();
            ddlSalesPerson.Items.Insert(0, new ListItem("ALL", "ALL"));
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

        //protected void btnReport_Click(object sender, EventArgs e)
        //{
        //    if (Page.IsValid)
        //    {
        //        if (cldStartDt.SelectedDate.ToShortDateString() == "110001" || cldEndDt.SelectedDate.ToShortDateString() == "")
        //        {
        //            lblError.Text = "Select Date Range"; 
        //            lblError.Visible = true;
        //            pnlStatus.Update();
        //        }
        //        else
        //        {
                    
        //            string popupScript = "<script language='javascript'>ViewReport()</script>";
        //            Page.RegisterStartupScript("Quote and Order Analysis", popupScript);
        //        }
        //    }
        //}

        protected void cldStartDt_SelectionChanged(object sender, EventArgs e)
        {
            hidStartDt.Value = cldStartDt.SelectedDate.ToShortDateString();
            //if (DateTime.Compare(cldEndDt.SelectedDate, cldStartDt.SelectedDate) == -1)
            //{
            //    lblError.Text = "InValid Date Range";
            //}
        }

        protected void cldEndDt_SelectionChanged(object sender, EventArgs e)
        {
            hidEndDt.Value = cldEndDt.SelectedDate.ToShortDateString();
            //if ( DateTime.Compare(cldEndDt.SelectedDate, cldStartDt.SelectedDate) == -1)
            //{
            //    lblError.Text = "InValid Date Range";
            //}
        }

        //private bool ValidateDate(DateTime date)
        //{
        //    if (DateTime.Compare(DateTime.Now, date) == -1 )
        //    {
        //        lblError.Text = "InValid Date Range";
        //        return false;
        //    }
        //    else
        //        return true;
        //}

        protected void ddlShipMethod_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlShipMethod.SelectedValue.ToUpper() == "ALL")
            {
                ddlSubTot.SelectedValue = "0";
                chkSubTot.Checked = false;
                chkSubTot.Enabled = false;
            }
            else
            {
                ddlSubTot.SelectedValue = "9";
                chkSubTot.Enabled = true;
            }
            
            pnlShipMeth.Update();
            pnlSubTot.Update();
            pnlCheckbox.Update();
        }

        protected void ddlSubTot_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlSubTot.SelectedValue == "0")
            {
                chkSubTot.Checked = false;
                chkSubTot.Enabled = false;
            }
            else
                chkSubTot.Enabled = true;

            pnlShipMeth.Update();
            pnlSubTot.Update();
            pnlCheckbox.Update();
        }
    }
}