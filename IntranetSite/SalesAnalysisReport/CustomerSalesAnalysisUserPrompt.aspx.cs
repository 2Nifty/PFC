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
        SalesReportUtils salesReportUtils = new SalesReportUtils();

        protected void Page_Load(object sender, EventArgs e)
        {
            SystemCheck systemCheck = new SystemCheck();
            systemCheck.SessionCheck();

            Ajax.Utility.RegisterTypeForAjax(typeof(CustomerSalesAnalysisUserPrompt));

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
                salesReportUtils.GetALLReps(ddlRep, ddlBranch.SelectedItem.Value);
            }
        }

        public void FillBranches()
        {
            try
            {
                salesReportUtils.GetALLBranches(ddlBranch, Session["UserID"].ToString());
                salesReportUtils.GetChainName(ddlChain);
            }
            catch (Exception ex) { }
        }

        protected void btnReport_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                string popupScript = "<script language='javascript'>ViewReport()</script>";
                Page.RegisterStartupScript("Item Sales Analysis", popupScript);
            }
        }

        protected string GetURL()
        {
            string url = "CustomerSalesAnalysis.aspx?Month=" + ddlMonth.SelectedValue + "&Year=" + ddlYear.SelectedValue + "&Branch=" + ddlBranch.SelectedValue + "&Chain=" + ddlChain.SelectedItem.Text + "&CustNo=" + txtCustNo.Text + "&MonthName=" + ddlMonth.SelectedItem;
            string url1 = Server.UrlEncode(PFC.Intranet.Securitylayer.Cryptor.Encrypt(url).ToString());
            return url1;
        }

        protected void ddlBranch_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                salesReportUtils.GetALLReps(ddlRep, ddlBranch.SelectedValue);
            }
            catch (Exception ex) { }
        }

        [Ajax.AjaxMethod()]
        public string GetCustomerNumber(string strChain, string curMonth, string curYear)
        {
            try
            {
                string strCustNo = (string)SqlHelper.ExecuteScalar(Global.ReportsConnectionString, "[UGEN_SP_Select]",
                                          new SqlParameter("@TableName", "CAS_ChainData"),
                                          new SqlParameter("@columnNames", "Top 1 CustNo"),
                                          new SqlParameter("@whereClause", "chain='" + strChain + "' and CurMonth='" + curMonth + "' and CurYear='" + curYear + "'"));
                return strCustNo;
            }
            catch (Exception ex) { return ""; }
        }

        #region Ajax Method for getting Chain
        [Ajax.AjaxMethod]
        public string GetChain()
        {
            try
            {
                string result = string.Empty;
                DataSet dsChain = new DataSet();
                DataTable dtChain = new DataTable();
                dsChain = SqlHelper.ExecuteDataset(ConfigurationManager.AppSettings["ReportsConnectionString"].ToString(), "[ugen_sp_select]",
                    new SqlParameter("@tableName", "[Porteous$Chain Name]"),
                    new SqlParameter("@displayColumns", "Code"),
                    new SqlParameter("@whereCondition", "1=1"));
                dtChain = dsChain.Tables[0];

                foreach (DataRow dr in dtChain.Rows)
                {
                    result = result + "~" + dr["Code"].ToString();
                }

                if (dtChain.Rows.Count > 0)
                    result = result.Remove(0, 1);

                return result;

            }
            catch (Exception ex)
            { return ""; }

        }
        #endregion

    }
}
