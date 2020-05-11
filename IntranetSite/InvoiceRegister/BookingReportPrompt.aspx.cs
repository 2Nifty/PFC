/********************************************************************************************
 * File	Name			:	BookingReportPrompt.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Booking Report Prompt 
 * Created By			:	Sathish
 * Created Date			:	03/02/2010
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 03/02/2010		    Version 1		Sathish      		Created 
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
    public partial class BookingReportPrompt : System.Web.UI.Page
    {
        PFC.Intranet.InvoiceRegister.BookingReport bookingReport = new PFC.Intranet.InvoiceRegister.BookingReport();
        SalesReportUtils salesReportUtils = new SalesReportUtils();
        InvoiceAnalysis invoiceAnalysis = new InvoiceAnalysis();
        string opt = string.Empty;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            lblError.Visible = false;
            if (!IsPostBack)
            {    
                //salesReportUtils.FillBranchesAndChainSession(Session["UserID"].ToString());

                DateTime startDate = Convert.ToDateTime(DateTime.Now.AddDays(-8).ToShortDateString());
                DateTime endDate = startDate.AddDays(+7);
                cldEndDt.SelectedDate = endDate;
                cldStartDt.SelectedDate = startDate;
                cldEndDt.VisibleDate = endDate;
                cldStartDt.VisibleDate = startDate;
                    
                //
                // Fill The Branches in the Combo
                //
                BindBranch();                
                hidEndDt.Value = cldEndDt.SelectedDate.ToShortDateString();
                hidStartDt.Value = cldStartDt.SelectedDate.ToShortDateString();
                               
                for (int i = 0; i <= ddlBranch.Items.Count - 1; i++)
                {
                    if (ddlBranch.Items[i].Value.Trim() == Session["BranchID"].ToString())
                    {
                        ddlBranch.Items[i].Selected = true;
                        break;
                    }
                }
            }
        }

        public void BindBranch()
        {
            try
            {
                bookingReport.BindListControls(ddlBranch, "Name", "Code", bookingReport.GetBranchLocation(), "");
                ddlBranch.Items.Insert(0, "ALL");

                foreach (ListItem item in ddlBranch.Items)
                {
                    if (item.Value == Session["BranchID"].ToString())
                    {
                        item.Selected = true;
                        break;
                    }
                }
            }
            catch (Exception ex) { }
        }

        protected void btnReport_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                if (cldStartDt.SelectedDate.ToShortDateString() == "" || cldEndDt.SelectedDate.ToShortDateString() == "")
                {
                    lblError.Text = "Select Date Range"; 
                    lblError.Visible = true;
                    pnlStatus.Update();
                }
                else
                {
                    
                    string popupScript = "<script language='javascript'>ViewReport()</script>";
                    Page.RegisterStartupScript("Booking Report", popupScript);
                }
            }
        }

        protected void cldEndDt_SelectionChanged(object sender, EventArgs e)
        {
            hidEndDt.Value = cldEndDt.SelectedDate.ToShortDateString();
        }

        protected void cldStartDt_SelectionChanged(object sender, EventArgs e)
        {
            hidStartDt.Value = cldStartDt.SelectedDate.ToShortDateString();
        }

        private bool ValidateDate(DateTime date)
        {
            if (DateTime.Compare(DateTime.Now, date) == -1 )
            {
                lblError.Text = "InValid Date Range";
                return false;
            }
            else
                return true;
        }
}
}
