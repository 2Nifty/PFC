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

namespace PFC.Intranet
{
    public partial class CustomerSalesAnalysisUserPrompt : System.Web.UI.Page
    {
       

        protected void Page_Load(object sender, EventArgs e)
        {
           
            if (!IsPostBack)
            {
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
            }
        }

        protected void btnReport_Click(object sender, EventArgs e)
        {
            
        }
    }
}
