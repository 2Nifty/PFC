/********************************************************************************************
 * File	Name			:	CustomerContactReportPrompt.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Customer Contact Report
 * Created By			:	Sathish
 * Created Date			:	08/27/2008
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/27/2008		    Version 1		Senthilkumar      		Created 
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
    public partial class CustomerContactReportPrompt : System.Web.UI.Page
    {
        SalesReportUtils salesReportUtils = new SalesReportUtils();
        CustomerContactReport CCR = new CustomerContactReport();
        PFC.Intranet.MaintenanceApps.CustomerContact customerContact = new PFC.Intranet.MaintenanceApps.CustomerContact();
        
        string opt = string.Empty;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            lblError.Visible = false;
            if (!IsPostBack)
            {    
                salesReportUtils.GetALLBranches(ddlBranch, Session["UserID"].ToString());                
                FillControl();                 
            }
        }
 

        public void FillControl()
        {
            CCR.BindListValue("ContactType", ddlContact);            
            ddlContact.Items.Insert(0, new ListItem("ALL", ""));

            CCR.BindListValue("CustType", ddlCustomer);            
            ddlCustomer.Items.Insert(0, new ListItem("ALL", ""));

            CCR.GetCustomerBuyingGroup(ddlBuying);
        }
      
        protected void btnReport_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                    string popupScript = "<script language='javascript'>ViewReport()</script>";
                    Page.RegisterStartupScript("Customer Contact Report", popupScript);
               
            }
        }

        protected void cdChangeDt_SelectionChanged(object sender, EventArgs e)
        {
            hidFilterDt.Value = cdChangeDt.SelectedDate.ToShortDateString();
        }
}
}
