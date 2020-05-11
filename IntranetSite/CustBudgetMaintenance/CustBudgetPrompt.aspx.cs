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
    public partial class CustBudgetPrompt : System.Web.UI.Page
    {
        CustomerBudget customerBudget = new CustomerBudget();

        string opt = string.Empty;
        
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {      
                //
                // Fill The Branches in the Combo
                //
                BindDropDowns();

                if (Session["MaxSensitivity"].ToString().Trim() == "9")
                    btnAllBranch.Visible = true;
                else
                    btnAllBranch.Visible = false;

                //btnAllBranch.Visible = false;
            }
        }

        public void BindDropDowns()
        {
            try
            {

                DataSet dsDDLData = customerBudget.GetCustomerBudgetData("filldorpdowns", "");

                if (dsDDLData != null)
                {
                    customerBudget.BindListControls(ddlBranch, "LocDesc", "LocId", dsDDLData.Tables[0], "");
                    customerBudget.BindListControls(ddlChain, "ChainDisp", "ChainNo", dsDDLData.Tables[1], "----------------- Select -----------------");

                    // Bind Sales Person Based on LocId
                    BindSalesPerson();
                }

            }
            catch (Exception ex) { }
        }

        private void BindSalesPerson()
        {
            DataSet dsDDLData = new DataSet();

            if (ddlBranch.SelectedValue.Trim() == "00")
                dsDDLData = customerBudget.GetCustomerBudgetData("getsalesperson", "");
            else
                dsDDLData = customerBudget.GetCustomerBudgetData("getsalesperson", ddlBranch.SelectedValue.Trim());

            customerBudget.BindListControls(ddlSalesPerson, "RepName", "RepNo", dsDDLData.Tables[0], "ALL");
            ListItem item = new ListItem("Unassigned","Unassigned");
            ddlSalesPerson.Items.Insert(ddlSalesPerson.Items.Count, item);
        }

        protected void ddlBranch_SelectedIndexChanged(object sender, EventArgs e)
        {
            BindSalesPerson();          
            pnlSalesPerson.Update();
        }
}
}
