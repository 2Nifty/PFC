using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using PFC.Intranet.DataAccessLayer;

/// <summary>
/// EDIData class for Pages working with EDI data
/// </summary>
public class ExcessPlainData
{
    string ERPconnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    string MSDBconnectionString = ConfigurationManager.ConnectionStrings["ERPMSDBConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataRow ErrorRow;

    public DataTable GetAnalysis(string UserID)
    {
        return WorkData("Analyze", "", "0", UserID);
    }

    public DataTable GetCurrent(string UserID)
    {
        return WorkData("GetCurrent", "", "0", UserID);
    }

    public DataTable MakePO(string UserID)
    {
        return WorkData("MakePO", "", "0", UserID);
    }

    public DataTable UpdatePOID(string PONumber, string POHdrID, string UserID)
    {
        return WorkData("UpdatePOID", PONumber, POHdrID, UserID);
    }

    public DataTable WorkData(string Action, string PONumber, string POHdrID, string UserID)
        {
            try
            {
                ds = SqlHelper.ExecuteDataset(ERPconnectionString, "pExcessPlain",
                    new SqlParameter("@Action", Action),
                    new SqlParameter("@PONumber", PONumber),
                    new SqlParameter("@POHdrID", POHdrID),
                    new SqlParameter("@EntryID", UserID));
                if (ds.Tables[0].Rows.Count > 0)
                {
                    return ds.Tables[0];
                }
                else
                {
                    return null;
                }
            }
            catch (SqlException ex)
            {
                AddSQLError(ex);
                return dt;
            }
            catch (Exception e2)
            {
                AddGeneralError(e2);
                return dt;
            }
        }

    public void StartJob()
        {
            using (SqlConnection connection = new SqlConnection(
               MSDBconnectionString))
            {
                SqlCommand command = new SqlCommand("exec [sp_start_job] 'ExcessPlainAddLines'", connection);
                command.Connection.Open();
                command.ExecuteNonQuery();
            }
        }

    private void AddSQLError(SqlException SQLEx)
    {
        StringBuilder errorMessages = new StringBuilder();
        dt = MakeErrorTable();
        for (int i = 0; i < SQLEx.Errors.Count; i++)
        {
            errorMessages.Append("Index #" + i + "\n" +
                "Message: " + SQLEx.Errors[i].Message + "\n" +
                "LineNumber: " + SQLEx.Errors[i].LineNumber + "\n" +
                "Source: " + SQLEx.Errors[i].Source + "\n" +
                "Procedure: " + SQLEx.Errors[i].Procedure + "\n");
        }
        ErrorRow["ErrorType"] = "SQL";
        ErrorRow["ErrorCode"] = "0";
        ErrorRow["ErrorText"] = errorMessages;
        dt.Rows.Add(ErrorRow);
    }

    private void AddGeneralError(Exception Ex)
    {
        dt = MakeErrorTable();
        ErrorRow["ErrorType"] = "General";
        ErrorRow["ErrorCode"] = "1";
        ErrorRow["ErrorText"] = Ex.ToString();
        dt.Rows.Add(ErrorRow);
    }

    private DataTable MakeErrorTable()
    {
        DataTable MRPError = new DataTable();
        MRPError.Columns.Add("ErrorType", typeof(string));
        MRPError.Columns.Add("ErrorCode", typeof(string));
        MRPError.Columns.Add("ErrorText", typeof(string));
        ErrorRow = MRPError.NewRow();
        return MRPError;
    }
}
