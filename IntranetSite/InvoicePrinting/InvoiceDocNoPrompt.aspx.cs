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
                //salesReportUtils.FillBranchesAndChainSession(Session["UserID"].ToString());

                cldStartDt.SelectedDate = Convert.ToDateTime(DateTime.Now.AddDays(-6).ToShortDateString());
                cldStartDt.VisibleDate = Convert.ToDateTime(DateTime.Now.AddDays(-6).ToShortDateString());
                cldEndDt.SelectedDate = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                cldEndDt.VisibleDate = Convert.ToDateTime(DateTime.Now.ToShortDateString());
                hidEndDt.Value = cldEndDt.SelectedDate.ToShortDateString();
                hidStartDt.Value = cldStartDt.SelectedDate.ToShortDateString();

            }
        }

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

}
}