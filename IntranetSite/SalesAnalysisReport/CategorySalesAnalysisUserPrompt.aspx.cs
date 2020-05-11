
/********************************************************************************************
 * File	Name			:	CategorySalesAnalysisUserPrompt.aspx.cs
 * File Type			:	C#
 * Project Name			:	PFC Insider - Reports
 * Module Description	:	Retrive Data From Curvalsum Table - CategoryWise.
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
using PFC.Intranet.Securitylayer;

public partial class Sales_Analysis_Report_CategoryTrendAnalysisUserPrompt : System.Web.UI.Page
{
    SqlConnection cn=new SqlConnection("Data Source=66.209.105.131;Initial Catalog=PFCReports;Persist Security Info=False;User ID=sa;Password=oswin2003");
    SqlCommand cmd;
    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
            string strYear=string.Empty;
            for (int i = 0; ; i++)
            {
                strYear=i.ToString();
                strYear=(strYear.Length==1)?"200"+i.ToString():"20"+i.ToString();
                if (Convert.ToInt32(strYear) > DateTime.Now.Year)
                    break;

                ddlStYear.Items.Insert(i, new ListItem(strYear, i.ToString()));
            }
           
            int month = (int)DateTime.Now.Month;
            int year = Convert.ToInt16(DateTime.Now.Year.ToString().Substring(2));
            if (month != 1)
            {
                ddlStMonth.Items[month - 2].Selected = true;
                ddlStYear.Items[year].Selected = true;
            }
            else
            {
                ddlStMonth.Items[ddlStMonth.Items.Count - 1].Selected = true;
                ddlStYear.Items[year - 1].Selected = true;
            }

           
        }
    }
    }
