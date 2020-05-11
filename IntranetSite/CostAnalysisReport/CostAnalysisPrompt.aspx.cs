/********************************************************************************************
 * File	Name			:	CostAnalysis.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Executive - Reports
 * Module Description	:	Cost Analysis Report
 * Created By			:	Pete 
 * Created Date			:	09/14/2011
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 *09/14/2011		    Version 1		Pete      		    Created 
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
    public partial class CostAnalysisPrompt : System.Web.UI.Page
    {
               
        protected void Page_Load(object sender, EventArgs e)
        {
            lblError.Visible = false;
            if (!IsPostBack)
            {
                DateTime startDate = Convert.ToDateTime(DateTime.Now.AddDays(-8).ToShortDateString());
                DateTime endDate = startDate.AddDays(+7);
                cldEndDt.SelectedDate = endDate;
                cldStartDt.SelectedDate = startDate;
                cldEndDt.VisibleDate = endDate;
                cldStartDt.VisibleDate = startDate;
                hidEndDt.Value = cldEndDt.SelectedDate.ToShortDateString();
                hidStartDt.Value = cldStartDt.SelectedDate.ToShortDateString();               
            }
        }

        protected void cldStartDt_SelectionChanged(object sender, EventArgs e)
        {
            hidStartDt.Value = cldStartDt.SelectedDate.ToShortDateString();
        }

        protected void cldEndDt_SelectionChanged(object sender, EventArgs e)
        {
            hidEndDt.Value = cldEndDt.SelectedDate.ToShortDateString();
        }

        /// <summary>
        /// ClearMasterControls :Used to clear Filter Controls
        /// </summary>
        private void ClearMasterControls()
        {
            //lblChangeDate.Text = lblChangeID.Text = lblEntryDate.Text = lblEntryID.Text = txtListComments.Text = txtListDesc.Text = txtListName.Text = "";
            //chkBoxRestricted.Items[0].Selected = chkBoxRestricted.Items[1].Selected = chkBoxRestricted.Items[2].Selected = false;
            //pnlListMaster.Update();
        }

       

    }
}