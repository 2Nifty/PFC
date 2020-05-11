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
/// ContainerXDockData: SQL data class for Conatiner Cross Dock processing
/// </summary>
public class ContainerReceiptData
{
    string ERPConnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataRow ErrorRow;
    string _ToLoc = "__";
    string _BegLPN = "";
    string _EndLPN = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    string _BegBOL = "";
    string _EndBOL = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    DateTime MinDate = DateTime.Today.AddDays(-720);
    DateTime MaxDate = DateTime.Today;

    public DataTable SearchUnprocessed(string ToLoc, string BegLPN, string EndLPN,
        string BegBOL, string EndBOL, string BegDate, string EndDate)
    {
        _ToLoc = "__";
        _BegLPN = "";
        _EndLPN = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
        _BegBOL = "";
        _EndBOL = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";

        if (ToLoc.Trim() != "00") _ToLoc = ToLoc;
        if (BegLPN.Trim() != "")
        {
            _BegLPN = BegLPN;
            _EndLPN = BegLPN;
            BegDate = MinDate.ToShortDateString();
            EndDate = MaxDate.ToShortDateString();
        }
        if (EndLPN.Trim() != "") _EndLPN = EndLPN;
        if (BegBOL.Trim() != "")
        {
            _BegBOL = BegBOL;
            _EndBOL = BegBOL;
            BegDate = MinDate.ToShortDateString();
            EndDate = MaxDate.ToShortDateString();
        }
        if (EndBOL.Trim() != "") _EndBOL = EndBOL;
        return WorkFormData("Unprocessed", _ToLoc, _BegLPN, _EndLPN,
         _BegBOL, _EndBOL, BegDate, EndDate, "");
    }

    public DataTable UpdateLPNAudit(string LPN, string UserID)
    {
        return WorkFormData("UpdLPN", "", LPN, "",
         "", "", MinDate.ToShortDateString(), MaxDate.ToShortDateString(), UserID);
    }

    public DataTable GetItems(string LPN, string UserID)
    {
        // Lock the LPN
        dt = WorkFormData("SoftLockLOCK", "", LPN, "",
         "", "", MinDate.ToShortDateString(), MaxDate.ToShortDateString(), UserID);
        // now get the items
        return WorkFormData("ItemDetail", "", LPN, "",
         "", "", MinDate.ToShortDateString(), MaxDate.ToShortDateString(), "");
    }

    public DataTable ReleaseContainer(string Container, string UserID)
    {
        // Release the container
        return WorkFormData("SoftLockRELEASE", "", Container, "",
         "", "", MinDate.ToShortDateString(), MaxDate.ToShortDateString(), UserID);
    }

    public DataTable WorkFormData(string Action, string ToLoc, string BegLPN, string EndLPN,
        string BegBOL, string EndBOL, string BegDate, string EndDate, string EntryID)
    {
        StringBuilder errorMessages = new StringBuilder();
        try
        {
            // get the data.
            ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pContainerReceiptForm",
                      new SqlParameter("@Action", Action),
                      new SqlParameter("@ToLoc", ToLoc),
                      new SqlParameter("@BegLPN", BegLPN),
                      new SqlParameter("@EndLPN", EndLPN),
                      new SqlParameter("@BegBOL", BegBOL),
                      new SqlParameter("@EndBOL", EndBOL),
                      new SqlParameter("@BegDate", BegDate),
                      new SqlParameter("@EndDate", EndDate),
                      new SqlParameter("@EntryID", EntryID)
                      );
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

    public DataTable CreateXFers(string LPN, string EntryID)
    {
        StringBuilder errorMessages = new StringBuilder();
        try
        {
            // get the data.
            ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pCreateCrossDocOrder",
                      new SqlParameter("@Container", LPN),
                      new SqlParameter("@EntryID", EntryID)
                      );
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
        DataTable XDockError = new DataTable();
        XDockError.Columns.Add("ErrorType", typeof(string));
        XDockError.Columns.Add("ErrorCode", typeof(string));
        XDockError.Columns.Add("ErrorText", typeof(string));
        ErrorRow = XDockError.NewRow();
        return XDockError;
    }
}
