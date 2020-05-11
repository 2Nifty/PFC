using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.IO;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CrystalDecisions.Shared;
using CrystalDecisions.CrystalReports.Engine;
using PFC.SOE.DataAccessLayer;

public partial class CreditMemoExport : Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    string CrystalPath;
    string UserPrefix;
    string PrintRequest;
    bool WriteOK;
    decimal PagePosition;
    ReportDocument CreditMemoDoc = new ReportDocument();
    ExportOptions ExpOpt = new ExportOptions();
    private const string DocName = "ERPCreditMemo";
    protected void Page_Load(object sender, EventArgs e)
    {
        // since we are using Crystal to do everything, the web page is built here
        if (!IsPostBack)
        {
            Session["dtPrint"] = null;
            if (Session["UserName"] == null)
            {
                UserPrefix = "NoUser";
            }
            else
            {
                UserPrefix = Session["UserName"].ToString().Trim();
            }
            if ((Request.QueryString["InvoiceNo"] != null) || (Request.QueryString["OrderNo"] != null))
            {
                // clear out any previous user exports first
                DirectoryInfo OldPages = new DirectoryInfo(Server.MapPath(DocName));
                if (OldPages.Exists)
                {
                    // Get a reference to each file in that directory.
                    FileInfo[] AllOldPages = OldPages.GetFiles();
                    // go through the files
                    foreach (FileInfo OldPage in AllOldPages)
                    {
                        if (OldPage.Name.Substring(0, UserPrefix.Length) == UserPrefix)
                        {
                            OldPage.Delete();
                        }
                    }
                }
                // get the TEST watermark indicator
                DataSet dsAppPref = new DataSet();
                dsAppPref = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                        new SqlParameter("@tableName", "SystemMaster with (NOLOCK)"),
                        new SqlParameter("@displayColumns", "PrintRqst"),
                        new SqlParameter("@whereCondition", " SystemMasterID = 0"));
                PrintRequest = dsAppPref.Tables[0].Rows[0]["PrintRqst"].ToString().Trim();
                // load the crystal report using the path in an app pref record
                dsAppPref = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                        new SqlParameter("@tableName", "AppPref with (NOLOCK)"),
                        new SqlParameter("@displayColumns", "AppOptionValue"),
                        new SqlParameter("@whereCondition", " (ApplicationCd = 'SOE') AND (AppOptionType = 'InvoiceLocation')"));
                CrystalPath = dsAppPref.Tables[0].Rows[0]["AppOptionValue"].ToString();
                CreditMemoDoc.Load(CrystalPath + DocName+ ".rpt", OpenReportMethod.OpenReportByTempCopy);
                // set the database connections for the report
                SqlConnectionStringBuilder ConnectBuilder = new SqlConnectionStringBuilder();
                ConnectBuilder.ConnectionString = connectionString;
                ConnectionInfo ConnectInfo = new ConnectionInfo();
                ConnectInfo.DatabaseName = ConnectBuilder["Initial Catalog"].ToString();
                ConnectInfo.UserID = ConnectBuilder["User Id"].ToString();
                ConnectInfo.Password = ConnectBuilder["Password"].ToString();
                ConnectInfo.ServerName = ConnectBuilder["Data Source"].ToString();
                //  AutoDataBind="true"
                foreach (CrystalDecisions.CrystalReports.Engine.Table CreditTable in CreditMemoDoc.Database.Tables)
                {
                    TableLogOnInfo CreditTableLogonInfo = CreditTable.LogOnInfo;
                    CreditTableLogonInfo.ConnectionInfo = ConnectInfo;
                    CreditTable.ApplyLogOnInfo(CreditTableLogonInfo);
                }
                // set the selection criteria
                if (Request.QueryString["InvoiceNo"] != null)
                    CreditMemoDoc.RecordSelectionFormula = "{SOHeaderHist.InvoiceNo}=\"" + Request.QueryString["InvoiceNo"].ToString() + "\" and isnull({SODetailHist.DeleteDt})";
                if (Request.QueryString["OrderNo"] != null)
                    CreditMemoDoc.RecordSelectionFormula = "{SOHeaderHist.OrderNo}=" + Request.QueryString["OrderNo"].ToString() + " and isnull({SODetailHist.DeleteDt})";
                // we are ready to go
                CreditMemoDoc.Refresh();
                // Now set up the export
                DiskFileDestinationOptions diskOpts = ExportOptions.CreateDiskFileDestinationOptions();
                ExportOptions exportOpts = new ExportOptions();
                exportOpts.ExportFormatType = ExportFormatType.HTML40;
                exportOpts.ExportDestinationType = ExportDestinationType.DiskFile;
                exportOpts.ExportDestinationOptions = diskOpts;
                HTMLFormatOptions htmlFormatOpts = new HTMLFormatOptions();
                htmlFormatOpts.FirstPageNumber = 1;
                htmlFormatOpts.HTMLEnableSeparatedPages = true;
                htmlFormatOpts.HTMLHasPageNavigator = false;
                htmlFormatOpts.HTMLBaseFolderName = Server.MapPath("");
                htmlFormatOpts.HTMLFileName = UserPrefix + "CreditExport.htm";
                exportOpts.ExportFormatOptions = htmlFormatOpts;
                // set the parameters
                if (PrintRequest == "T")
                {
                    CreditMemoDoc.SetParameterValue("IsTest", true);
                }
                else
                {
                    CreditMemoDoc.SetParameterValue("IsTest", false);
                }
                // Export the report to separate html files
                CreditMemoDoc.Export(exportOpts);
                CreditMemoDoc.Close();
                // now that we have created the individual pages, make one big page
                DirectoryInfo PageFiles = new DirectoryInfo(Server.MapPath(DocName));
                // Get a reference to each file in that directory.
                FileInfo[] AllPages = PageFiles.GetFiles();
                // start the HTML page
                Response.Write("<head>\n<title>Credit Memo Document</title>\n");
                if ((Request.QueryString["ScriptX"] != null) && (Request.QueryString["ScriptX"] == "YES"))
                {
                    // Embed ScriptX objects
                    using (StreamReader sr = new StreamReader(Server.MapPath("common/include/ScriptX.inc")))
                    {
                        String incline;
                        // Read and display lines from the Spriptx include file
                        while ((incline = sr.ReadLine()) != null)
                        {
                            Response.Write(incline + "\n");
                        }
                    }
                    // Load ScriptX javascript function 
                    Response.Write("<script src=\"Common/JavaScript/ScriptX.js\" type=\"text/javascript\"></script>\n");
                }
                Response.Write("</head>\n<body style=\"margin: 0px\" >\n");
                PagePosition = (decimal)0.0;
                foreach (FileInfo InvPage in AllPages)
                {
                    // get only the files for the current user
                    if (InvPage.Name.Substring(0, UserPrefix.Length) == UserPrefix)
                    {
                        WriteOK = false;
                        Response.Write("<DIV style=\"position:absolute; top:" + PagePosition.ToString() + "pt;  height:1000px \">\n");
                        //Response.Write("");
                        using (StreamReader sr = new StreamReader(InvPage.FullName))
                        {
                            String line;
                            // Read and display lines from the file until the end of 
                            // the file is reached.
                            while ((line = sr.ReadLine()) != null)
                            {
                                if (line.Contains("</BODY>")) WriteOK = false;
                                if (line.Contains("<style>")) WriteOK = true;
                                if (line.Contains("class=\"crystalstyle\"")) line = line.Replace("31", "0");
                                if (line.Contains("images/")) line = line.Replace("images/", ConfigurationManager.AppSettings["SOESiteURL"].ToString() + DocName + "/images/");
                                if (line.Contains("<DIV style=\"position:absolute; top:")) WriteOK = false;
                                if (line.Contains("</TR></TABLE></CENTER></Div>")) WriteOK = false;
                                // write the line
                                if (WriteOK) Response.Write(line + "\n");
                                if (line.Contains("</style>")) WriteOK = false;
                                if (line.Contains("<BODY")) WriteOK = true;
                            }
                        }
                        Response.Write("</DIV>\n");
                        if (PagePosition == (decimal)0.0) PagePosition += (decimal)757;
                    }
                }
                Response.Write("</body>\n");
                if ((Request.QueryString["ScriptX"] != null) && (Request.QueryString["ScriptX"] == "YES"))
                {
                    Response.Write("<script language=\"javascript\">\n");
                    Response.Write("SetPrintSettings(true, 0.25, 0.25, 0.25, 0.25);\n");
                    Response.Write("</script>\n");
                }
                Response.Write("</html>\n");
            }
        }
    }

}
