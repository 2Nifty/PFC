#region Namespace
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
using PFC.Intranet.Securitylayer;
#endregion

namespace PFC.Intranet.CustomerActivity
{
    public partial class PrintPanel : System.Web.UI.Page
    {
        #region Variable Declaration
        public string strTitle = string.Empty;
        public string strURL = string.Empty;

        public string customerDataPage = string.Empty;
        public string pieChartPage = string.Empty;
        public string top5SalesPage = string.Empty;
        public string salesCategoryPage = string.Empty;
        public string customerNotesPage = string.Empty;

        private string customerNumber = string.Empty;
        private string curYear = string.Empty;
        private string curMonth = string.Empty;
        private string branch = string.Empty;
        private string branchName = string.Empty;
        private string strMonthName = string.Empty;
        public string strQuery = string.Empty;
        private string strChain = string.Empty;
        #endregion

        #region Page load Event Handler
        /// <summary>
        /// Page_Load:Page load Event handler
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected void Page_Load(object sender, EventArgs e)
        {

            SystemCheck systemCheck = new SystemCheck();
            systemCheck.SessionCheck();
            
                string[] strSplit = { ".aspx?" };
                if (Request.QueryString["CustNo"] != null && Request.QueryString["Year"] != null && Request.QueryString["Month"] != null && Request.QueryString["BranchName"] != null && Request.QueryString["MonthName"] != null)
                {
                    #region Getting Query string
                    customerNumber = Request.QueryString["CustNo"].ToString();
                    curYear = Request.QueryString["Year"].ToString();
                    curMonth = Request.QueryString["Month"].ToString();
                    branch = Request.QueryString["Branch"].ToString();
                    branchName = Request.QueryString["BranchName"].ToString();
                    strMonthName = Request.QueryString["MonthName"].ToString();
                    strChain = Request.QueryString["Chain"] !=null?Request.QueryString["Chain"].ToString():"";
                    #endregion

                    strTitle = "Customer Data";

                    if (Request.QueryString["CASMode"] == null)
                    {
                        customerDataPage = "../CustomerData.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&BranchName=" + branchName + "&MonthName=" + strMonthName;
                        top5SalesPage = "../TopSalesCategories.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&BranchName=" + branchName + "&MonthName=" + strMonthName;
                        salesCategoryPage = "../SalesCategoryDetail.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&BranchName=" + branchName + "&MonthName=" + strMonthName;
                        pieChartPage = "../PieCharts.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&BranchName=" + branchName + "&MonthName=" + strMonthName;
                        customerNotesPage = "../ContactNotes.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&BranchName=" + branchName + "&MonthName=" + strMonthName;
                    }
                    else
                    {
                        customerDataPage = "../CustomerData.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Chain=" + strChain + "&Branch=" + branch + "&BranchName=" + branchName + "&MonthName=" + strMonthName + "&CASMode=" + Request.QueryString["CASMode"].Trim();
                        top5SalesPage = "../TopSalesCategories.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Chain=" + strChain + "&Branch=" + branch + "&BranchName=" + branchName + "&MonthName=" + strMonthName + "&CASMode=" + Request.QueryString["CASMode"].Trim();
                        salesCategoryPage = "../SalesCategoryDetail.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Chain=" + strChain + "&Branch=" + branch + "&BranchName=" + branchName + "&MonthName=" + strMonthName + "&CASMode=" + Request.QueryString["CASMode"].Trim();
                        pieChartPage = "../PieCharts.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&Chain=" + strChain + "&BranchName=" + branchName + "&MonthName=" + strMonthName + "&CASMode=" + Request.QueryString["CASMode"].Trim();
                        customerNotesPage = "../ContactNotes.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&Chain=" + strChain + "&BranchName=" + branchName + "&MonthName=" + strMonthName + "&CASMode=" + Request.QueryString["CASMode"].Trim();
                    }

                    strURL = customerDataPage;


                }
                else if (Request.QueryString["pageTitle"] != null && Request.QueryString["PageURL"] != null)
                {

                    strTitle = Request.QueryString["pageTitle"].ToString().Split('~')[0];
                    strURL = Request.QueryString["PageURL"].ToString().Replace('~', '&');
                    hidPageID.Value = Request.QueryString["pageTitle"].ToString().Split('~')[1];

                    customerDataPage = "../CustomerData.aspx?" + strURL.Split(strSplit, StringSplitOptions.None)[1].ToString();
                    pieChartPage = "../PieCharts.aspx?" + strURL.Split(strSplit, StringSplitOptions.None)[1].ToString();
                    top5SalesPage = "../TopSalesCategories.aspx?" + strURL.Split(strSplit, StringSplitOptions.None)[1].ToString();
                    salesCategoryPage = "../SalesCategoryDetail.aspx?" + strURL.Split(strSplit, StringSplitOptions.None)[1].ToString();
                    customerNotesPage = "../ContactNotes.aspx?" + strURL.Split(strSplit, StringSplitOptions.None)[1].ToString();
                }
               if (Request.QueryString["Mode"] != null)            
                {

                    #region Body Frame refresh Script
                    Response.Write("<script>");
                    Response.Write("parent.bodyframe.location.href=parent.bodyframe.location.href");
                    Response.Write("</script>");
                    #endregion
                }
        }
        #endregion

    }// End Class 

}// End Namespace


