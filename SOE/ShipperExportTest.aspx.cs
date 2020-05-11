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
//using System.Data;
//using System.Collections;

public partial class ShipperExport : Page
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    string ShipperNo;
    string CrystalPath;
    string UserPrefix;
    bool WriteOK;
    decimal PagePosition;
    ReportDocument ShipperDoc = new ReportDocument();
    ExportOptions ExpOpt = new ExportOptions();
    protected void Page_Load(object sender, EventArgs e)
    {
        Response.Write("test3ed");
        Response.End();
        
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
            if (Request.QueryString["ShipperNo"] != null)
            {

                
                ShipperNo = Request.QueryString["ShipperNo"].ToString();
                // clear out any previous exports first
                DirectoryInfo OldPages = new DirectoryInfo(Server.MapPath(@"SOEShipper"));
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

                // load the crystal report using the path in an app pref record
                DataSet dsAppPref = new DataSet();
                dsAppPref = SqlHelper.ExecuteDataset(connectionString, "[UGEN_SP_Select]",
                        new SqlParameter("@tableName", "AppPref with (NOLOCK)"),
                        new SqlParameter("@displayColumns", "AppOptionValue"),
                        new SqlParameter("@whereCondition", " (ApplicationCd = 'SOE') AND (AppOptionType = 'InvoiceLocation')"));
                CrystalPath = dsAppPref.Tables[0].Rows[0]["AppOptionValue"].ToString();
                
                Response.Write("Windows Account which runs ASP.NET is: " + Environment.Username);
                Response.Write("test3");
                Response.End();
                try
                {
                    ShipperDoc.Load(CrystalPath + "SOEShipper.rpt", OpenReportMethod.OpenReportByTempCopy);
                }
                catch (Exception ex )
                {

                    throw ex;
                }
                
                // set the database connections for the report
                SqlConnectionStringBuilder ConnectBuilder = new SqlConnectionStringBuilder();
                ConnectBuilder.ConnectionString = connectionString;
                ConnectionInfo ConnectInfo = new ConnectionInfo();
                ConnectInfo.DatabaseName = ConnectBuilder["Initial Catalog"].ToString();
                ConnectInfo.UserID = ConnectBuilder["User Id"].ToString();
                ConnectInfo.Password = ConnectBuilder["Password"].ToString();
                ConnectInfo.ServerName = ConnectBuilder["Data Source"].ToString();
                //  AutoDataBind="true"

                foreach (CrystalDecisions.CrystalReports.Engine.Table ShipperTable in ShipperDoc.Database.Tables)
                {
                    TableLogOnInfo ShipperTableLogonInfo = ShipperTable.LogOnInfo;
                    ShipperTableLogonInfo.ConnectionInfo = ConnectInfo;
                    ShipperTable.ApplyLogOnInfo(ShipperTableLogonInfo);
                }
                ShipperDoc.RecordSelectionFormula = "{SOHeaderRel.OrderNo}=" + ShipperNo;
                // we are ready to go
                ShipperDoc.Refresh();
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
                htmlFormatOpts.HTMLFileName = UserPrefix + "ShipperExport.htm";

                exportOpts.ExportFormatOptions = htmlFormatOpts;

                ShipperDoc.Export(exportOpts);
                ShipperDoc.Close();
                // now that we have created the individual pages, make one big page
                DirectoryInfo PageFiles = new DirectoryInfo(Server.MapPath(@"SOEShipper"));
                // Get a reference to each file in that directory.
                FileInfo[] AllPages = PageFiles.GetFiles();
                // start the HTML page
                Response.Write("<head>\n");
                // write the styles
                Response.Write("<style type=\"text/css\">\n");
                Response.Write(".barcode{height:30px;font-size:15pt;color:#000000;font-family:IDAutomationC39M;font-weight:normal;overflow:hidden;}\n");
                Response.Write("</style>\n");
                // finish the header start the body
                Response.Write("\n<title>Shipper Document</title>\n</head>\n<body  LEFTMARGIN=31 TOPMARGIN=31 >\n");
                PagePosition = (decimal)0.0;
                foreach (FileInfo InvPage in AllPages)
                {
                     // get only the files for the current user
                    if (InvPage.Name.Substring(0, UserPrefix.Length) == UserPrefix)
                    {
                        WriteOK = false;
                        Response.Write("<DIV style=\"position:absolute; left:0px; top:" + PagePosition.ToString() + "pt;  height:590px \">\n");
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
                                if (line.Contains("images/")) line = line.Replace("images/", ConfigurationManager.AppSettings["SOESiteURL"].ToString() + "SOEShipper/images/");
                                // write the line
                                if (WriteOK) Response.Write(line + "\n");
                                if (line.Contains("</style>")) WriteOK = false;
                                if (line.Contains("<BODY")) WriteOK = true;
                            }
                        }
                        Response.Write("</DIV>\n");
                        if (PagePosition == (decimal)0.0) PagePosition += (decimal)590;
                    }
                }
                Response.Write("</body>\n</html>\n");
            }
        }
    }

}
