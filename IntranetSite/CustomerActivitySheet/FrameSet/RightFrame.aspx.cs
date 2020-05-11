#region Namespaces
using System;
using System.Collections;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web;
using System.Web.SessionState;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.HtmlControls;
using System.IO;
using PFC.Intranet.Securitylayer;
#endregion

namespace PFC.Intranet.CustomerActivity
{
    public partial class treeViewMenuFrame : System.Web.UI.Page
    {
        #region Variable Declaration
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

        private string strChain = string.Empty;


        #endregion

        #region Page Load Event handler
        /// <summary>
        /// Page_Load:Page load event handler
        /// </summary>
        /// <param name="sender">Object sender</param>
        /// <param name="e">System.EventArgs e</param>
        protected void Page_Load(object sender, System.EventArgs e)
        {

            SystemCheck systemCheck = new SystemCheck();
            systemCheck.SessionCheck();
            #region Getting Query string values
            customerNumber = Request.QueryString["CustNo"].ToString();
            curYear = Request.QueryString["Year"].ToString();
            curMonth = Request.QueryString["Month"].ToString();
            branch = Request.QueryString["Branch"].ToString();
            branchName = Request.QueryString["BranchName"].ToString();
            strMonthName = Request.QueryString["MonthName"].ToString();
            strChain = Request.QueryString["Chain"] != null ? Request.QueryString["Chain"].ToString() : "";
            #endregion

            if (Request.QueryString["CASMode"] == null)
            {
                customerDataPage = "../CustomerData.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&BranchName=" + branchName + "&MonthName=" + strMonthName;
                top5SalesPage = "../TopSalesCategories.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&BranchName=" + branchName + "&MonthName=" + strMonthName;
                salesCategoryPage = "../SalesCategoryDetail.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&BranchName=" + branchName + "&MonthName=" + strMonthName;
                pieChartPage = "../PieCharts.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&BranchName=" + branchName + "&MonthName=" + strMonthName + "&CustName=" + Session["CustomerName"].ToString().Replace(',', '`').Replace("'", "|||");
                customerNotesPage = "../ContactNotes.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&BranchName=" + branchName + "&MonthName=" + strMonthName;
            }
            else
            {
                customerDataPage = "../CustomerData.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&BranchName=" + branchName + "&Chain=" + strChain + "&MonthName=" + strMonthName + "&CASMode=" + Request.QueryString["CASMode"].Trim();
                top5SalesPage = "../TopSalesCategories.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&BranchName=" + branchName + "&Chain=" + strChain + "&MonthName=" + strMonthName + "&CASMode=" + Request.QueryString["CASMode"].Trim();
                salesCategoryPage = "../SalesCategoryDetail.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&BranchName=" + branchName + "&Chain=" + strChain + "&MonthName=" + strMonthName + "&CASMode=" + Request.QueryString["CASMode"].Trim();
                pieChartPage = "../PieCharts.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&BranchName=" + branchName + "&MonthName=" + strMonthName + "&Chain=" + strChain + "&CustName=" + Session["CustomerName"].ToString().Replace(',', '`').Replace("'", "|||") + "&CASMode=" + Request.QueryString["CASMode"].Trim();
                customerNotesPage = "../ContactNotes.aspx?Month=" + curMonth + "&Year=" + curYear + "&CustNo=" + customerNumber + "&Branch=" + branch + "&BranchName=" + branchName + "&MonthName=" + strMonthName + "&Chain=" + strChain + "&CASMode=" + Request.QueryString["CASMode"].Trim();
            }
            // Registeing Ajax
            Ajax.Utility.RegisterTypeForAjax(typeof(treeViewMenuFrame));

        }
        #endregion

        #region Ajax Function To Delete The Excel Files

        [Ajax.AjaxMethod()]
        public string DeleteExcel(string strSession)
        {
            try
            {
                DirectoryInfo drHTML = new DirectoryInfo(Server.MapPath("../CustomerActivitySheet"));
                DirectoryInfo drPDF = new DirectoryInfo(Server.MapPath("../CustomerActivitySheet/PDF"));

                foreach (FileInfo fn in drHTML.GetFiles())
                    if (fn.Name.Contains(strSession.Trim())) fn.Delete();

                foreach (FileInfo fn1 in drPDF.GetFiles())
                    if (fn1.Name.Contains(strSession.Trim())) fn1.Delete();

                return "";
            }
            catch (Exception ex) { return ""; }
        }

        #endregion

    } // End Class

} // End Namespace




