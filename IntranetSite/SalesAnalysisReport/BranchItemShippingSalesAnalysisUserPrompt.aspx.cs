/********************************************************************************************
 * File	Name			:	BranchItemSalesAnalysisUserPrompt.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Retrive Data From Curvalsum Table - Customerwise.
 * Created By			:	Senthilkumar
 * Created Date			:	08/07/2006
 * History*				: 
 * DATE					VERSION			AUTHOR			    ACTION
 * ****					*******			******				******
 * 08/12/2005		    Version 1		Senthilkumar		Excel Report Added 
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
using PFC.Intranet.BusinessLogicLayer;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.Securitylayer;

public partial class BranchItemShippingSalesAnalysisUserPrompt : System.Web.UI.Page
{
    SalesReportUtils salesReportUtils = new SalesReportUtils();
    SqlConnection cn = new SqlConnection(PFC.Intranet.Global.ReportsConnectionString);
    SqlCommand cmd;

    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
            
            ddlYear.Items.Clear();
            string strYear=string.Empty;
            for (int i = 0; ; i++)
            {
                strYear=i.ToString();
                strYear=(strYear.Length==1)?"200"+i.ToString():"20"+i.ToString();
                if (Convert.ToInt32(strYear) > DateTime.Now.Year)
                    break;

                ddlYear.Items.Insert(i, new ListItem(strYear, strYear));
            }
            //
            // Fill The Branches in the Combo
            //
           FillBranches();
            //
            // Fill The Agents in the drop down
            //
            FillAgents();

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
            salesReportUtils.GetALLReps(ddlRep, ddlBranch.SelectedItem.Value);

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

    public void FillAgents()
    {
        //try
        //{
        DataSet dsAgent = (DataSet)SqlHelper.ExecuteDataset(Global.ReportsConnectionString, "[UGEN_SP_Select]",
                                new SqlParameter("@TableName", "CuvnalTempShipments"),
                                new SqlParameter("@columnNames", "distinct [Shipping Agent Code] as Agent"),
                                new SqlParameter("@whereClause", "[Shipping Agent Code]<>'' order by [Shipping Agent Code]"));

        ddlAgent.DataSource = dsAgent;
        ddlAgent.DataTextField = "Agent";
        ddlAgent.DataValueField = "Agent";
        ddlAgent.DataBind();
        ddlAgent.Items.Insert(0, new ListItem("All", "0"));   

        //}
        //catch (Exception ex) { }
    }

    protected void btnReport_Click(object sender, EventArgs e)
    {
        if (Page.IsValid)
        {
            string popupScript = "<script language='javascript'>ViewReport()</script>";
            Page.RegisterStartupScript("Item Sales Analysis", popupScript);
        }
    }
    //protected string GetURL()
    //{
    //    string url = "CustomerSalesAnalysis.aspx?Month=" + ddlMonth.SelectedValue + "&Year=" + ddlYear.SelectedValue + "&Branch=" + ddlBranch.SelectedValue +  "&MonthName=" + ddlMonth.SelectedItem;
    //    string url1 = Server.UrlEncode(PFC.Intranet.Securitylayer.Cryptor.Encrypt(url).ToString());
    //    return url1;
    //}
    protected void ddlBranch_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            salesReportUtils.GetALLReps(ddlRep, ddlBranch.SelectedValue);
            upRep.Update();
        }
        catch (Exception ex) { }
    }
    
}
