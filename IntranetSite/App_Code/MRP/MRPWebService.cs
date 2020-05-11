using System;
using System.Collections;
using System.Data.SqlClient;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Configuration;

/// <summary>
/// Summary description for MRPWebService
/// </summary>
[WebService(Namespace = "http://tempuri.org/")]
[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
public class MRPWebService : System.Web.Services.WebService {
    ConnectionStringSettings ReportsDB  = ConfigurationManager.ConnectionStrings["PFCReportsConnectionString"];
    String DTSServer = ConfigurationManager.AppSettings["DTSServer"];
    SqlConnection cn = new SqlConnection();
    SqlCommand command = new SqlCommand();
    SqlDataReader rs;

    public MRPWebService () 
    {
    }

    [WebMethod]
    public string StartMRPProcess(string ProcessID)
    {
        try
        {
            cn.ConnectionString = ReportsDB.ConnectionString;
            cn.Open();
            command.Connection = cn;
            command.CommandTimeout = 0;
            Server.ScriptTimeout = 6000;
            command.CommandText = "exec master..xp_cmdshell 'dtsrun /E /S " + DTSServer + " /N MRPProcess /A ProcessID:8=" + ProcessID + "'";
            rs = command.ExecuteReader();
            cn.Close();
            return "Process " + ProcessID + " is complete.";
        }
        catch (SqlException ex)
        {
            StringBuilder errorMessages = new StringBuilder();
            for (int i = 0; i < ex.Errors.Count; i++)
            {
                errorMessages.Append("Index #" + i + "\n" +
                    "Message: " + ex.Errors[i].Message + "\n" +
                    "LineNumber: " + ex.Errors[i].LineNumber + "\n" +
                    "Source: " + ex.Errors[i].Source + "\n" +
                    "Procedure: " + ex.Errors[i].Procedure + "\n");
            }
            return errorMessages.ToString();
        }
        catch (Exception e2)
        {
            return e2.ToString();
        }
}
    
}

