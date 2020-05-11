using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;
using PFC.Intranet.DataAccessLayer;

public partial class CreditView : Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    string CreditNo;
    string CrystalPath;

    protected void Page_Load(object sender, EventArgs e)
    {
        // since we are using Crystal to do everything, the web page is built here
        //if (!IsPostBack)
        //{
            if (Request.QueryString["CreditMemoNo"] != null)
            {
                CreditNo = Request.QueryString["CreditMemoNo"].ToString();
                // load the crystal report using the path in an app pref record
                DataSet dsAppPref = new DataSet();
                dsAppPref = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                        new SqlParameter("@tableName", "AppPref with (NOLOCK)"),
                        new SqlParameter("@displayColumns", "AppOptionValue"),
                        new SqlParameter("@whereCondition", " (ApplicationCd = 'SOE') AND (AppOptionType = 'InvoiceLocation')"));
                CrystalPath = dsAppPref.Tables[0].Rows[0]["AppOptionValue"].ToString();
                CreditMemoReportSource.Report.FileName = CrystalPath + "WebCreditMemo.rpt";
                // set the database connections for the report
                SqlConnectionStringBuilder ConnectBuilder = new SqlConnectionStringBuilder();
                ConnectBuilder.ConnectionString = connectionString;
                ConnectionInfo ConnectInfo = new ConnectionInfo();
                ConnectInfo.DatabaseName = ConnectBuilder["Initial Catalog"].ToString();
                ConnectInfo.UserID = ConnectBuilder["User Id"].ToString();
                ConnectInfo.Password = ConnectBuilder["Password"].ToString();
                ConnectInfo.ServerName = ConnectBuilder["Data Source"].ToString();
                //  AutoDataBind="true"
                foreach (CrystalDecisions.CrystalReports.Engine.Table CRTable in CreditMemoReportSource.ReportDocument.Database.Tables)
                {
                    TableLogOnInfo CRTableLogonInfo = CRTable.LogOnInfo;
                    CRTableLogonInfo.ConnectionInfo = ConnectInfo;
                    CRTable.ApplyLogOnInfo(CRTableLogonInfo);
                }
                // we are ready to go
                CreditMemoReportViewer.SelectionFormula = "{SOHeaderHist.InvoiceNo}=\"" + CreditNo + "\" and isnull({SODetailHist.DeleteDt})";
            }
        //}
    }

}
