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
    public partial class CustPriceMatrixPrompt : System.Web.UI.Page
    {

        CustPriceMatrix custPriceMatrix = new CustPriceMatrix();
        string opt = string.Empty;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                smGER.SetFocus(txtPFCItemNo);
                BindLocations();
                txtStartDt.Text = DateTime.Today.AddDays(-7).ToShortDateString();
                txtEndDt.Text = DateTime.Today.ToShortDateString();
            }
        }

        private void BindLocations()
        {
            try
            {
                string _tableName = "LocMaster (NOLOCK)";
                string _columnName = "LOCID as Code,LOCID + ' - ' + [LocName] as Name";
                string _whereClause = "Loctype in ('DC','B') order by  LOCID asc ";

                DataSet dsType = SqlHelper.ExecuteDataset(Global.PFCERPConnectionString, "UGen_Sp_Select",
                    new SqlParameter("@tableName", _tableName),
                    new SqlParameter("@columnNames", _columnName),
                    new SqlParameter("@whereClause", _whereClause));

                ddlLocation.DataSource = dsType.Tables[0];
                ddlLocation.DataTextField = "Name";
                ddlLocation.DataValueField = "Code";
                ddlLocation.DataBind();

                ListItem item = new ListItem("---------- Select ---------", "");
                ddlLocation.Items.Insert(0, item);
            }
            catch (Exception ex) { }
        }

        protected void btnReport_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {                    
                string popupScript = "<script language='javascript'>ViewReport()</script>";
                Page.RegisterStartupScript("custpricematrix", popupScript);             
            }
        }

        #region Dates

        #region StartDt
        protected void ibtnStartDt_Click(object sender, ImageClickEventArgs e)
        {
            cldStartDt.Visible = true;
            pnlStartPick.Update();
        }

        protected void txtStartDt_TextChanged(object sender, EventArgs e)
        {
            lblError.Text = "";
            pnlError.Update();
            try
            {
                if (!ValidateDate(Convert.ToDateTime(txtStartDt.Text)))
                {
                    cldStartDt.SelectedDate = DateTime.Now;
                    txtStartDt.Text = "";
                    smGER.SetFocus(txtStartDt);
                    lblError.Text = "Invalid Start date";
                    pnlError.Update();
                }
                else
                {
                    txtStartDt.Text = Convert.ToDateTime(txtStartDt.Text).ToShortDateString();
                    pnlStartDt.Update();
                    smGER.SetFocus(txtEndDt);
                }

                if (txtEndDt.Text != "" && DateTime.Compare(Convert.ToDateTime(txtEndDt.Text), Convert.ToDateTime(txtStartDt.Text)) == -1)
                {
                    txtStartDt.Text = "";
                    smGER.SetFocus(txtStartDt);
                    lblError.Text = "Start date must be less than or equal to End date (1)";
                    pnlError.Update();
                }
            }
            catch (Exception ex)
            {
                txtStartDt.Text = "";
                smGER.SetFocus(txtStartDt);
                lblError.Text = "Invalid Start date (ex)";
                pnlError.Update();
            }
        }

        protected void cldStartDt_SelectionChanged(object sender, EventArgs e)
        {
            lblError.Text = "";
            pnlError.Update();
            if (ValidateDate(cldStartDt.SelectedDate))
            {
                txtStartDt.Text = cldStartDt.SelectedDate.ToShortDateString();
                pnlStartDt.Update();
                pnlStartPick.Update();
                smGER.SetFocus(txtEndDt);
            }
            else
            {
                txtStartDt.Text = "";
                smGER.SetFocus(txtStartDt);
                cldStartDt.SelectedDate = Convert.ToDateTime(DateTime.Now);
            }

            if (txtEndDt.Text != "" && DateTime.Compare(Convert.ToDateTime(txtEndDt.Text), Convert.ToDateTime(txtStartDt.Text)) == -1)
            {
                txtStartDt.Text = "";
                smGER.SetFocus(txtStartDt);
                lblError.Text = "Start date must be less than or equal to End date (2)";
                pnlError.Update();
            }
        }
        #endregion

        #region EndDt
        protected void ibtnEndDt_Click(object sender, ImageClickEventArgs e)
        {
            cldEndDt.Visible = true;
            pnlEndPick.Update();
        }

        protected void txtEndDt_TextChanged(object sender, EventArgs e)
        {
            lblError.Text = "";
            pnlError.Update();
            try
            {
                if (!ValidateDate(Convert.ToDateTime(txtEndDt.Text)))
                {
                    cldEndDt.SelectedDate = DateTime.Now;
                    txtEndDt.Text = "";
                    smGER.SetFocus(txtEndDt);
                    lblError.Text = "Invalid End date";
                    pnlError.Update();
                }
                else
                {
                    txtEndDt.Text = Convert.ToDateTime(txtEndDt.Text).ToShortDateString();
                    pnlEndDt.Update();
                }

                if (txtStartDt.Text != "" && DateTime.Compare(Convert.ToDateTime(txtEndDt.Text), Convert.ToDateTime(txtStartDt.Text)) == -1)
                {
                    txtEndDt.Text = "";
                    smGER.SetFocus(txtEndDt);
                    lblError.Text = "End date must be greater than or equal to Start date (1)";
                    pnlError.Update();
                }
            }
            catch (Exception ex)
            {
                txtEndDt.Text = "";
                smGER.SetFocus(txtEndDt);
                lblError.Text = "Invalid End date (ex)";
                pnlError.Update();
            }
        }

        protected void cldEndDt_SelectionChanged(object sender, EventArgs e)
        {
            lblError.Text = "";
            pnlError.Update();
            if (ValidateDate(cldEndDt.SelectedDate))
            {
                txtEndDt.Text = cldEndDt.SelectedDate.ToShortDateString();
                pnlEndDt.Update();
                pnlEndPick.Update();
            }
            else
            {
                txtEndDt.Text = "";
                smGER.SetFocus(txtEndDt);
                cldEndDt.SelectedDate = Convert.ToDateTime(DateTime.Now);
            }
            if (txtEndDt.Text != "" && DateTime.Compare(Convert.ToDateTime(txtEndDt.Text), Convert.ToDateTime(txtStartDt.Text)) == -1)
            {
                txtEndDt.Text = "";
                smGER.SetFocus(txtEndDt);
                lblError.Text = "End date must be greater than or equal to Start date (2)";
                pnlError.Update();
            }
        }
        #endregion

        private bool ValidateDate(DateTime date)
        {
            if (DateTime.Compare(DateTime.Now, date) == -1)
            {
                lblError.Text = "Date must be less than or equal current date";
                pnlError.Update();
                return false;
            }
            else
                return true;
        }

        #endregion
    }
}
