
/********************************************************************************************
 * File	Name			:	CategoryTrendAnalysisUserPrompt.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Retrive Data From Curvalsum Table - Customerwise.
 * Created By			:	Senthilkumar
 * Created Date			:	08/07/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/12/2005		    Version 1		Mahesh      		Created 
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
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.Securitylayer;

public partial class Sales_Analysis_Report_CategoryTrendAnalysisUserPrompt : System.Web.UI.Page
{
    SalesReportUtils salesReportUtils = new SalesReportUtils();
    SqlConnection cn = new SqlConnection(PFC.Intranet.Global.ReportsConnectionString);
    SqlCommand cmd;
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            
            if (!IsPostBack)
            {
                //
                // Fill The Branches in the Combo
                //
                FillBranches();
              
                string strYear = string.Empty;
                for (int i = 0; ; i++)
                {
                    strYear = i.ToString();
                    strYear = (strYear.Length == 1) ? "200" + i.ToString() : "20" + i.ToString();
                    if (Convert.ToInt32(strYear) > DateTime.Now.Year)
                        break;

                    ddlStYear.Items.Insert(i, new ListItem(strYear, i.ToString()));
                    ddlEndYear.Items.Insert(i, new ListItem(strYear, i.ToString()));

                }
               

                for (int j = 0; j <= ddlBranch.Items.Count - 1; j++)
                {
                    if (ddlBranch.Items[j].Value.Trim() == Session["BranchID"].ToString())
                    {
                        ddlBranch.Items[j].Selected = true;

                        break;
                    }
                }
                salesReportUtils.GetALLReps(ddlRep, ddlBranch.SelectedItem.Value);

                int month = (int)DateTime.Now.Month;
                int year = Convert.ToInt16(DateTime.Now.Year.ToString().Substring(2));

                if (month != 1)
                {
                    ddlEndMonth.Items[month - 2].Selected = true;
                    ddlEndYear.Items[year].Selected = true;
                }
                else
                {
                    ddlEndMonth.Items[ddlEndMonth.Items.Count - 1].Selected = true;
                    ddlEndYear.Items[year - 1].Selected = true;
                }
                


            }
        }
        catch (Exception ex) { }
    }

    public void FillBranches()
    {
        try
        {
            salesReportUtils.GetALLBranches(ddlBranch,Session["UserID"].ToString());
        }
        catch (Exception ex) { }
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        int endDate = DateTime.DaysInMonth( Convert.ToInt32(ddlEndYear.SelectedItem.Text),Convert.ToInt32(ddlEndMonth.SelectedValue));
        //string  startDate = ddlStMonth.SelectedValue+"/"+"01"+"/" + ddlStYear.SelectedItem.Text;
        //string endDate1 =  ddlEndMonth.SelectedValue + "/"+endDate.ToString()+"/" + ddlEndYear.SelectedItem.Text;
        string startDate = ddlStMonth.SelectedValue + "/" + ddlStYear.SelectedItem.Text;
        string endDate1 =  ddlEndMonth.SelectedValue + "/" + ddlEndYear.SelectedItem.Text;
        string strVariance=string.Empty;

       string url="Branch=" + ddlBranch.SelectedItem.Text +
                                                      "&BranchID=" + ddlBranch.SelectedValue +
                                                      "&StDate=" + startDate +
                                                      "&EndDate=" + endDate1 +
                                                      "&Period=" +
                                                      ddlStMonth.SelectedItem.Text +
                                                      ddlStYear.SelectedItem.Text.Remove(ddlStYear.SelectedItem.Text.Length - 4,2) + "." +
                                                      ddlEndMonth.SelectedItem.Text +
                                                      ddlEndYear.SelectedItem.Text.Remove(ddlEndYear.SelectedItem.Text.Length - 4,2)+
                                                      "&CategoryFrom="+txtCatFrom.Text+"&CategoryTo="+txtCatTo.Text+"&VarianceFrom="+txtVariance.Text
                                                      +"&VarianceTo="+txtVarianceTo.Text;
       RegisterClientScriptBlock("PopUp", "<script>NewWindow('" + url + "');</script>");
                                                      

    }
    protected void ddlBranch_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            salesReportUtils.GetALLReps(ddlRep, ddlBranch.SelectedItem.Value);
        }
        catch (Exception ex) { }
    }
   
}
