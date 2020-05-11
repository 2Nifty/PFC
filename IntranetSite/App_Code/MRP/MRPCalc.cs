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
/// MRPCalc clad for MRP System
/// </summary>
public class MRPCalc
{
    string connectionString = ConfigurationManager.ConnectionStrings["PFCReportsConnectionString"].ToString();
    string ERPconnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataRow ErrorRow;

    public DataTable WorkProcessResults(string ProcessID, string ResultType)
    {
        return WorkProcessResults(ProcessID, ResultType, 0); ;
    }

    public DataTable UpdateProcessResults(string ProcessID, string ResultType, int PackQty)
    {
        return WorkProcessResults(ProcessID, ResultType, PackQty);
    }

    public DataTable WorkProcessResults(string ProcessID, string ResultType, int ToPack)
    {
        try
        {
            ds = SqlHelper.ExecuteDataset(connectionString, "pMRPWorkProcessResults",
                new SqlParameter("@ProcessID", ProcessID),
                new SqlParameter("@ResultsType", ResultType),
                new SqlParameter("@ToPack", ToPack));
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

    public DataTable CheckForRunningProcess(string UserID)
    {
        try
        {
            ds = SqlHelper.ExecuteDataset(ERPconnectionString, "pMRPCheckSoftLock",
                new SqlParameter("@UserID", UserID.Trim()));
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

    public DataTable GetProcessStatus(string ProcessID)
    {
        try
        {
            ds = SqlHelper.ExecuteDataset(connectionString, "pMRPGetProcessStatus",
                new SqlParameter("@ProcessID", ProcessID));
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

    public DataTable CreateMRPProcess(string ProcessName, string UserID)
    {
        StringBuilder errorMessages = new StringBuilder();
        try
        {
            ds = SqlHelper.ExecuteDataset(connectionString, "pMRPCreateProcessFromMaster",
                new SqlParameter("@ConfigName", ProcessName),
                new SqlParameter("@UserID", UserID));
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

    public DataTable CreateMRPProcess(string ProcessName, string UserID, bool IncludeRTSB, bool IncludeOTW, string ChildROP)
    {
        StringBuilder errorMessages = new StringBuilder();
        try
        {
            ds = SqlHelper.ExecuteDataset(connectionString, "pMRPCreateProcessFromMaster",
                new SqlParameter("@ConfigName", ProcessName),
                new SqlParameter("@UserID", UserID),
                new SqlParameter("@IncludeChildRTSB", IncludeRTSB),
                new SqlParameter("@IncludeChildOTW", IncludeOTW),
                new SqlParameter("@ChildROP", ChildROP));
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

    public DataTable CreateMRPProcess(string ProcessName, string UserID, bool IncludeRTSB, bool IncludeOTW, string ChildROP, string MinPcntROP)
    {
        StringBuilder errorMessages = new StringBuilder();
        try
        {
            ds = SqlHelper.ExecuteDataset(connectionString, "pMRPCreateProcessFromMaster",
                new SqlParameter("@ConfigName", ProcessName),
                new SqlParameter("@UserID", UserID),
                new SqlParameter("@IncludeChildRTSB", IncludeRTSB),
                new SqlParameter("@IncludeChildOTW", IncludeOTW),
                new SqlParameter("@ChildROP", ChildROP),
                new SqlParameter("@MinPcntROP", MinPcntROP));
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

    public DataTable MstrConfigValidate(string MstrConfigCode)
    {
        return WorkMstrConfigData("Validate", 0, MstrConfigCode, "", "", 0, "", "", "");
    }

    public DataTable MstrConfigDataGetAll()
    {
        return WorkMstrConfigData("GetAll", 0, "", "", "", 0, "", "", "");
    }

    public DataTable GetBranches()
    {
        return WorkMstrConfigData("GetBranches", 0, "", "", "", 0, "", "", "");
    }

    public DataTable MstrConfigDataGetConfig(string MstrConfigCode)
    {
        return WorkMstrConfigData("Get", 0, MstrConfigCode, "", "", 0, "", "", "");
    }

    public DataTable MstrConfigDataAddLink(string ActionCode, string MstrConfigCode, string LinkedCode, string EnteredOrder, string UserID)
    {
        return WorkMstrConfigData(ActionCode, 0, MstrConfigCode, "", "", 0, LinkedCode, EnteredOrder, UserID);
    }

    public DataTable MstrConfigDataDeleteLink(string ActionCode, string MstrConfigCode, string LinkedCode)
    {
        return WorkMstrConfigData(ActionCode, 0, MstrConfigCode, "", "", 0, LinkedCode, "", "");
    }

    public DataTable MstrConfigDataGetFilters(string MstrConfigCode)
    {
        return WorkMstrConfigData("GetFilters", 0, MstrConfigCode, "", "", 0, "", "", "");
    }

    public DataTable MstrConfigDataGetSteps(string MstrConfigCode)
    {
        return WorkMstrConfigData("GetSteps", 0, MstrConfigCode, "", "", 0, "", "", "");
    }

    public DataTable WorkMstrConfigData(string Action, decimal MstrConfigID, string MstrConfigName, string MstrConfigDesc,
        string PackBranch, int IncUnPlated, string LinkedCode, string LinkedOrder, string UserID)
    {
        StringBuilder errorMessages = new StringBuilder();
        try
        {
            ds = SqlHelper.ExecuteDataset(connectionString, "pMRPWorkMasterConfig",
                new SqlParameter("@Action", Action),
                new SqlParameter("@ConfigID", MstrConfigID),
                new SqlParameter("@ConfigName", MstrConfigName),
                new SqlParameter("@ConfigDesc", MstrConfigDesc),
                new SqlParameter("@PackBranch", PackBranch),
                new SqlParameter("@IncludeUnplated", IncUnPlated),
                new SqlParameter("@LinkedCode", LinkedCode),
                new SqlParameter("@LinkedOrder", LinkedOrder),
                new SqlParameter("@UserID", UserID));
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

    public DataTable VelocityDataGetAll()
    {
        return WorkVelocityData("GetAll", 0, "", "", 0, 0, 0, 0, "", "No Velocity Codes on file");
    }

    public DataTable VelocityDataGetVelocity(string VelocityCode)
    {
        return WorkVelocityData("Get", 0, VelocityCode, "", 0, 0, 0, 0, "", "Velocity Code " + VelocityCode + " not found");
    }

    public DataTable WorkVelocityData(string Action, decimal VelocityID, string VelocityCode, string VelocityName,
        decimal ROPCartons, decimal NeedFactor, int ParentItemIsBulk, int BomIsRequired, string UserID, string ErrorText)
    {
        StringBuilder errorMessages = new StringBuilder();
        try
        {
            ds = SqlHelper.ExecuteDataset(connectionString, "pMRPWorkVelocities",
               new SqlParameter("@Action", Action),
               new SqlParameter("@VelocityID", VelocityID),
               new SqlParameter("@VelocityCode", VelocityCode),
               new SqlParameter("@VelocityCdDesc", VelocityName),
               new SqlParameter("@ROPCartons", ROPCartons),
               new SqlParameter("@ROPNeedFactor", NeedFactor),
               new SqlParameter("@ParentBulk0", ParentItemIsBulk),
               new SqlParameter("@BOMReqd", BomIsRequired),
               new SqlParameter("@UserID", UserID));
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

    public DataTable CatRngDataGetAll()
    {
        return WorkCatRngData("GetAll", 0, "", "", "", "", "", "", "0", "");
    }

    public DataTable CatRngDataGetParentLimit()
    {
        return WorkCatRngData("GetLimit", 0, "", "", "", "", "", "", "0", "");
    }

    public DataTable CatRngDataGetStep(string CatRngCode)
    {
        return WorkCatRngData("Get", 0, CatRngCode, "", "", "", "", "", "0", "");
    }

    public DataTable WorkCatRngData(string Action, decimal CatRngID, string CatRngCode, string CatRngName,
        string BegCat, string EndCat, string PackageRng, string PlateRng, string ParentRoundLimit, string UserID)
    {
        StringBuilder errorMessages = new StringBuilder();
        try
        {
            ds = SqlHelper.ExecuteDataset(connectionString, "pMRPWorkCatRanges",
                new SqlParameter("@Action", Action),
                new SqlParameter("@StepID", CatRngID),
                new SqlParameter("@FilterCode", CatRngCode),
                new SqlParameter("@FilterName", CatRngName),
                new SqlParameter("@BegCategory", BegCat),
                new SqlParameter("@EndCategory", EndCat),
                new SqlParameter("@PackageRange", PackageRng),
                new SqlParameter("@PlateRange", PlateRng),
                new SqlParameter("@ParentRoundLimit", ParentRoundLimit),
                new SqlParameter("@UserID", UserID));
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

    public DataTable StepDataGetAll()
    {
        return WorkStepData("GetAll", 0, "", "", 0, 0, "", "No Steps on file");
    }

    public DataTable StepDataGetStep(string StepCode)
    {
        return WorkStepData("Get", 0, StepCode, "", 0, 0, "", "Step " + StepCode + " not found");
    }

    public DataTable WorkStepData(string Action, decimal StepID, string StepCode, string StepName,
        decimal ParentROPProtectionFactor, int RunOrder, string UserID, string ErrorText)
    {
        StringBuilder errorMessages = new StringBuilder();
        try
        {
            ds = SqlHelper.ExecuteDataset(connectionString, "pMRPWorkSteps",
               new SqlParameter("@Action", Action),
               new SqlParameter("@StepID", StepID),
               new SqlParameter("@StepCode", StepCode),
               new SqlParameter("@StepName", StepName),
               new SqlParameter("@ParentROPProtectionFactor", ParentROPProtectionFactor),
               new SqlParameter("@RunOrder", RunOrder),
               new SqlParameter("@UserID", UserID));
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
