/********************************************************************************************
 * File	Name			:	SalesByPackageGroupPrompt.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Sales By Package Group report
 * Created By			:	Pete Arreola
 * Created Date			:	10/04/2012
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 10/04/2012		    Version 1		Pete Arreola   		Created 
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
using PFC.Intranet.BusinessLogicLayer;

namespace PFC.Intranet
{
    public partial class SalesByPackageGroupPrompt : System.Web.UI.Page
    {
        //SalesReportUtils salesReportUtils = new SalesReportUtils();     //need to get ddl branches
        SalesbyPackingGroupBL salesbyPackingGroupBL = new SalesbyPackingGroupBL();              
        //string opt = string.Empty;

        ddlBind ddlBind = new ddlBind();
        
        protected void Page_Load(object sender, EventArgs e)
        {
            lblError.Visible = false;
            if (!IsPostBack)
            {    
                cldStartDt.SelectedDate = Convert.ToDateTime(getFollowingSunday(DateTime.Now).ToShortDateString());
                cldStartDt.VisibleDate = Convert.ToDateTime(getFollowingSunday(DateTime.Now).ToShortDateString());

                cldEndDt.SelectedDate = Convert.ToDateTime(getFollowingSaturday(DateTime.Now).ToShortDateString());
                cldEndDt.VisibleDate = Convert.ToDateTime(getFollowingSaturday(DateTime.Now).ToShortDateString());

                hidEndDt.Value = cldEndDt.SelectedDate.ToShortDateString();
                hidStartDt.Value = cldStartDt.SelectedDate.ToShortDateString();

                FillBranches();
                FillOrderSource(); 
                BindDDL();
                
            }
        }

        private void BindDDL()
        {          
           //outstanding...remove old way of doing drop drow and apply tods new way ddlBind class file
            ddlBind.BindValueFromList("SalesRegionNo", ddlSalesRegionNo, " ", "ALL");         

        }

        public void FillBranches()
        {
            try
            {
                salesbyPackingGroupBL.GetALLBranches(ddlBranch, Session["UserID"].ToString());
            }
            catch (Exception ex) { }
        }
        
       
        public void FillOrderSource()
        {
            DataTable dt = salesbyPackingGroupBL.GetDataFromList("SOEOrderSource");
            //DataTable dt = salesReportUtils.GetDataFromList("SOEOrderSource");
            ddlOrderSource.DataSource = dt;
            ddlOrderSource.DataValueField = "ValueField";
            ddlOrderSource.DataTextField = "TextField";
            ddlOrderSource.DataBind();
            ddlOrderSource.Items.Insert(0, new ListItem("*All Orders*", "ALL"));
            ddlOrderSource.Items.Insert(1, new ListItem("*All CSR Orders*", "ALLCSR"));
            ddlOrderSource.Items.Insert(2, new ListItem("*All eCommerce Orders*", "ALLEC"));
        }
              

        //pete added - per sathis
        public void FillSalesRegionNo()
        {
            string salesRegionID = (ddlSalesRegionNo.SelectedIndex == 0 ? "ALL" : ddlSalesRegionNo.SelectedValue);
            DataTable dt = salesbyPackingGroupBL.GetSalesBranches(salesRegionID);
            //DataTable dt = salesReportUtils.GetSalesBranches(salesRegionID);
            ddlBranch.DataSource = dt;
            ddlBranch.DataValueField = "Branch";
            ddlBranch.DataTextField = "Name";
            ddlBranch.DataBind();
            ddlBranch.Items.Insert(0, new ListItem("ALL", "ALL"));
            pnlBranch.Update();

        }

        protected void cldStartDt_SelectionChanged(object sender, EventArgs e)
        {
            hidStartDt.Value = cldStartDt.SelectedDate.ToShortDateString();
        }

        protected void cldEndDt_SelectionChanged(object sender, EventArgs e)
        {
            hidEndDt.Value = cldEndDt.SelectedDate.ToShortDateString();
        }

      
        protected void ddlSalesRegionNo_SelectedIndexChanged(object sender, EventArgs e)
        {
            FillSalesRegionNo();
        }           
      

        protected DateTime getFollowingSunday(DateTime aDate)
        { return aDate.AddDays(-7 - (int)aDate.DayOfWeek); }

        protected DateTime getFollowingSaturday(DateTime aDate)
        { return aDate.AddDays(-1 - (int)aDate.DayOfWeek); }
      
}
}