/********************************************************************************************
 * File	Name			:	CustomerSalesAnalysisUserPrompt.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Retrive Data From Curvalsum Table - Customerwise.
 * Created By			:	Senthilkumar
 * Created Date			:	08/07/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/12/2005		    Version 1		Menaka      		Created 
 * 08/19/2005		    Version 2		Senthilkumar 		Store Procedure Name Changed
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
    public partial class eCommerceSalesAnalysisUserPrompt : System.Web.UI.Page
    {
        SalesReportUtils salesReportUtils = new SalesReportUtils();
        PFC.Intranet.eCommerceReport.eCommerceReport eComm = new PFC.Intranet.eCommerceReport.eCommerceReport();
        string opt = string.Empty;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            //Session["SessionID"] = "1234";
            //Session["BranchID"] = "01";
            //Session["UserID"]   = "200";
            //Session["UserName"] = "Intranet";
            salesReportUtils.FillBranchesAndChainSession(Session["UserID"].ToString());
            lblError.Text = "";      
            if (!IsPostBack)
            {
                cldStartDt.Visible = false;
                cldEndDt.Visible = false;
                tdRange.Visible = false;

                ddlYear.Items.Clear();
                string strYear = string.Empty;
                for (int i = 0; ; i++)
                {
                    strYear = i.ToString();
                    strYear = (strYear.Length == 1) ? "200" + i.ToString() : "20" + i.ToString();
                    if (Convert.ToInt32(strYear) > DateTime.Now.Year)
                        break;

                    ddlYear.Items.Insert(i, new ListItem(strYear, strYear));
                }
                //
                // Fill The Branches in the Combo
                //
                FillBranches();                

                int month = (int)DateTime.Now.Month;
                int year = Convert.ToInt16(DateTime.Now.Year.ToString().Substring(2));
                if (month != 1)
                {
                    ddlMonth.Items[month - 2].Selected = true;
                    ddlYear.Items[year].Selected = true;
                }
                else
                {
                    ddlMonth.Items[ddlMonth.Items.Count - 1].Selected = true;
                    ddlYear.Items[year - 1].Selected = true;
                }

                
                for (int i = 0; i <= ddlBranch.Items.Count - 1; i++)
                {
                    if (ddlBranch.Items[i].Value.Trim() == Session["BranchID"].ToString())
                    {
                        ddlBranch.Items[i].Selected = true;
                        break;
                    }
                }

                //if(ddlBranch.SelectedIndex == 0)
                    FillCSRs();
            }
        }

        public void FillBranches()
        {
            try
            {
                salesReportUtils.GetALLBranches(ddlBranch, Session["UserID"].ToString());
            }
            catch (Exception ex) { }
        }

        public void FillCSRs()
        {
            try
            {
                string branchId = (ddlBranch.SelectedIndex == 0 ? "" : ddlBranch.SelectedValue);
                ddlCSR.DataSource = eComm.GetCSRNames(branchId);
                ddlCSR.ClearSelection();
                ddlCSR.Items.Clear();
                ddlCSR.DataTextField = "RepName";
                ddlCSR.DataValueField = "RepNo";
                ddlCSR.DataBind();
                ddlCSR.Items.Insert(0, new ListItem("All", ""));
           
            }
            catch (Exception ex) { }
        }

        protected void btnReport_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string popupScript = "<script language='javascript'>ViewReport()</script>";
                Page.RegisterStartupScript("Qoute and Order Analysis", popupScript);
            }
        }
       
        protected void PeriodByDate_CheckedChanged(object sender, EventArgs e)
        {
            cldStartDt.Visible = true;
            cldEndDt.Visible = true;
            filloption("DT");
            txtEndDt.Text = "";
            txtstartDt.Text = "";
        }
       
        protected void PeriodByMonth_CheckedChanged(object sender, EventArgs e)
        {
            cldStartDt.Visible = false;
            cldEndDt.Visible = false;
            filloption("MO");
        }

       
        public void filloption(string  opt)
        {
            if (opt== "DT" )
            {
                tdRange.Visible = true;
                tdPeriod.Visible = false;
            }
            else
            {
                tdPeriod.Visible = true;
                tdRange.Visible = false;
            }
        }


        protected void cldEndDt_SelectionChanged(object sender, EventArgs e)
        {
            if (ValidateDate(cldEndDt.SelectedDate))
                txtEndDt.Text = cldEndDt.SelectedDate.ToShortDateString();
            else
            {
                txtEndDt.Text = "";
                cldEndDt.SelectedDate = Convert.ToDateTime(DateTime.Now);
            }

            if (txtEndDt.Text != "" && DateTime.Compare(cldEndDt.SelectedDate, cldStartDt.SelectedDate) == -1)
            {
                txtEndDt.Text = "";
                lblError.Text = "InValid Date Range";
            }
        }
        protected void cldStartDt_SelectionChanged(object sender, EventArgs e)
        {
            if (ValidateDate(cldStartDt.SelectedDate))
                txtstartDt.Text = cldStartDt.SelectedDate.ToShortDateString();
            else
            {
                txtstartDt.Text = "";
                cldStartDt.SelectedDate = Convert.ToDateTime(DateTime.Now);
            }

            if (txtEndDt.Text != "" && DateTime.Compare(cldEndDt.SelectedDate, cldStartDt.SelectedDate) == -1)
            {
                txtstartDt.Text = "";
                lblError.Text = "InValid Date Range";
            }
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
        protected void ibtnStartDt_Click(object sender, ImageClickEventArgs e)
        {
            cldStartDt.Visible = true;            
        }
        protected void ibtnEndDt_Click(object sender, ImageClickEventArgs e)
        {           
            cldEndDt.Visible = true;
        }
        protected void txtstartDt_TextChanged(object sender, EventArgs e)
        {
            try
            {
                if (!ValidateDate(Convert.ToDateTime(txtstartDt.Text)))
                {
                    cldStartDt.SelectedDate = DateTime.Now;
                    txtstartDt.Text = "";
                    lblError.Text = "InValid Date Range";
                }

                if (txtEndDt.Text != "" && DateTime.Compare(Convert.ToDateTime(txtEndDt.Text), Convert.ToDateTime(txtstartDt.Text)) == -1)
                {
                    txtstartDt.Text = "";
                    lblError.Text = "InValid Date Range";
                }
            }
            catch (Exception ex)
            {

                txtstartDt.Text = "";
                lblError.Text = "InValid Date Range";
            }

        }
        protected void txtEndDt_TextChanged(object sender, EventArgs e)
        {
            try
            {
                if (!ValidateDate(Convert.ToDateTime(txtEndDt.Text)))
                {
                    cldEndDt.SelectedDate = DateTime.Now;
                    txtEndDt.Text = "";
                    lblError.Text = "InValid Date Range";
                }

                if (txtEndDt.Text != "" && DateTime.Compare(Convert.ToDateTime(txtEndDt.Text), Convert.ToDateTime(txtstartDt.Text)) == -1)
                {
                    txtEndDt.Text = "";
                    lblError.Text = "InValid Date Range";
                }
            }
            catch (Exception ex)
            {

                txtEndDt.Text = "";
                lblError.Text = "InValid Date Range";
            }
        }
        protected void ddlBranch_SelectedIndexChanged(object sender, EventArgs e)
        {
            FillCSRs();
        }
}
}
