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

public partial class InvoiceView : Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    string InvoiceNo;
    string CrystalPath;
    string PrintRequest;

    protected void Page_Load(object sender, EventArgs e)
    {
        // since we are using Crystal to do everything, the web page is built here
        //if (!IsPostBack)
        //{
            if (Request.QueryString["InvoiceNo"] != null)
            {
                InvoiceNo = Request.QueryString["InvoiceNo"].ToString();
                // get the TEST watermark indicator
                DataSet dsAppPref = new DataSet();
                //dsAppPref = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                //        new SqlParameter("@tableName", "SystemMaster with (NOLOCK)"),
                //        new SqlParameter("@displayColumns", "PrintRqst"),
                //        new SqlParameter("@whereCondition", " SystemMasterID = 0"));
                //PrintRequest = dsAppPref.Tables[0].Rows[0]["PrintRqst"].ToString().Trim();
                // load the crystal report using the path in an app pref record
                dsAppPref = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                        new SqlParameter("@tableName", "AppPref with (NOLOCK)"),
                        new SqlParameter("@displayColumns", "AppOptionValue"),
                        new SqlParameter("@whereCondition", " (ApplicationCd = 'SOE') AND (AppOptionType = 'InvoiceLocation')"));
                CrystalPath = dsAppPref.Tables[0].Rows[0]["AppOptionValue"].ToString();
                InvoiceReportSource.Report.FileName = CrystalPath + "WebInvoice.rpt";
                // set the database connections for the report
                SqlConnectionStringBuilder ConnectBuilder = new SqlConnectionStringBuilder();
                ConnectBuilder.ConnectionString = connectionString;
                ConnectionInfo ConnectInfo = new ConnectionInfo();
                ConnectInfo.DatabaseName = ConnectBuilder["Initial Catalog"].ToString();
                ConnectInfo.UserID = ConnectBuilder["User Id"].ToString();
                ConnectInfo.Password = ConnectBuilder["Password"].ToString();
                ConnectInfo.ServerName = ConnectBuilder["Data Source"].ToString();
                //  AutoDataBind="true"
                foreach (CrystalDecisions.CrystalReports.Engine.Table InvTable in InvoiceReportSource.ReportDocument.Database.Tables)
                {
                    TableLogOnInfo InvTableLogonInfo = InvTable.LogOnInfo;
                    InvTableLogonInfo.ConnectionInfo = ConnectInfo;
                    InvTable.ApplyLogOnInfo(InvTableLogonInfo);
                }
                //// set the parameters
                //if (PrintRequest == "T")
                //{
                //    InvoiceReportSource.ReportDocument.SetParameterValue("IsTest", true);
                //}
                //else
                //{
                //    InvoiceReportSource.ReportDocument.SetParameterValue("IsTest", false);
                //}
                // we are ready to go
                InvoiceReportViewer.SelectionFormula = "{SOHeaderHist.InvoiceNo}=\"" + InvoiceNo + "\" and isnull({SODetailHist.DeleteDt})";
            }
        //}
    }

}
