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
/// ManualTransferData: SQL data class for Manual Transfer processing
/// </summary>
public class ManualTransferData
{
    string ERPConnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    string CPRConnectionString = ConfigurationManager.ConnectionStrings["PFCReportsConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataRow ErrorRow;
    //string _ToLoc = "__";
    //string _BegContainer = "";
    //string _EndContainer = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    //string _BegBOL = "";
    //string _EndBOL = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    //string _BegDate = "";
    //string _EndDate = "";
    //DateTime MinDate = DateTime.Today.AddDays(-720);
    //DateTime MaxDate = DateTime.Today;

    //public DataTable SearchUnprocessed(string ToLoc, string BegContainer, string EndContainer,
    //    string BegBOL, string EndBOL, string BegDate, string EndDate)
    //{
    //    _ToLoc = "__";
    //    _BegContainer = "%";
    //    _EndContainer = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    //    _BegBOL = "%";
    //    _EndBOL = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    //    _BegDate = MinDate.ToShortDateString();
    //    _EndDate = MaxDate.ToShortDateString();

    //    if (ToLoc.Trim() != "00") _ToLoc = ToLoc;
    //    if (BegContainer.Trim() != "")
    //    {
    //        _BegContainer = BegContainer;
    //        _EndContainer = BegContainer;
    //    }
    //    if (EndContainer.Trim() != "") _EndContainer = EndContainer;
    //    if (BegBOL.Trim() != "")
    //    {
    //        _BegBOL = BegBOL;
    //        _BegBOL = BegBOL;
    //    }
    //    if (EndBOL.Trim() != "") _EndBOL = EndBOL;
    //    if (BegDate.Trim() != "") _BegDate = BegDate;
    //    if (EndDate.Trim() != "") _EndDate = EndDate;
    //    return WorkFormData("Unprocessed", _ToLoc, _BegContainer, _EndContainer,
    //     _BegBOL, _EndBOL, _BegDate, _EndDate, "", "", "", "", "0", "");
    //}

    public DataTable GetCPRItems(string ItemNo, string Factor, string OrderBy)
    {
        // get the item data and grid data
        try
        {
            // get the data.
            ds = SqlHelper.ExecuteDataset(CPRConnectionString, "pCPRRepItemDetail",
                      new SqlParameter("@ItemNo", ItemNo),
                      new SqlParameter("@Factor", Factor),
                      new SqlParameter("@OrderBy", OrderBy)
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

    public DataTable GetItemData(string UserID, string Factor, string Combine)
    {
        // get the items
        try
        {
            // get the data.
            ds = SqlHelper.ExecuteDataset(CPRConnectionString, "pCPRRepGridDetail",
                      new SqlParameter("@UserID", UserID),
                      new SqlParameter("@Factor", Factor),
                      new SqlParameter("@Combine", Combine)
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

    public DataSet AddXFerRecs(string ToLoc, string FromLoc, string Item, string Qty, string EntryID)
    {
        return WorkFormData("AddXferRecs", ToLoc, FromLoc, Item, Qty, EntryID);
    }

    public DataTable AcceptTransfers(string Item, string EntryID)
    {
        return WorkFormData("Accept", "", "", Item, "0", EntryID).Tables[0];
    }

    public DataTable LockInTransfers(string Item, string EntryID)
    {
        return WorkFormData("LockIn", "", "", Item, "0", EntryID).Tables[0];
    }

    public DataTable GetBranchTots(string Item, string FromLoc)
    {
        // get the transfer from a branch
        return WorkFormData("BranchTotals", "", FromLoc, Item, "0", "").Tables[0];
    }

    public DataTable GetCurXFers(string Item, string UserID)
    {
        // get the items
        dt = WorkFormData("CurXferRecs", "", "", Item, "0", UserID).Tables[0];
        if (dt.Rows.Count==0)
        {
            dt.NewRow();
        }
        return dt;
    }

    public DataSet WorkFormData(string Action, string ToLoc, string FromLoc, string Item, string Qty, string EntryID)
    {
        try
        {
            // get the data.
            ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pManualXferFrm",
                new SqlParameter("@Action", Action),
                new SqlParameter("@ToLoc", ToLoc),
                new SqlParameter("@FromLoc", FromLoc),
                new SqlParameter("@Item", Item),
                new SqlParameter("@Qty", Qty),
                      //new SqlParameter("@EndBOL", EndBOL),
                      //new SqlParameter("@BegDate", BegDate),
                      //new SqlParameter("@EndDate", EndDate),
                      //new SqlParameter("@CrossDocType", CrossDocType),
                      //new SqlParameter("@VendNo", VendNo),
                      //new SqlParameter("@PONo", PONo),
                      //new SqlParameter("@ItemNo", ItemNo),
                      //new SqlParameter("@Qty", Qty),
                new SqlParameter("@UserID", EntryID)
                );
            return ds;
            //if (ds.Tables[0].Rows.Count > 0)
            //{
            //}
            //else
            //{
            //    return null;
            //}
        }
        catch (SqlException ex)
        {
            AddSQLError(ex);
            return ds;
        }
        catch (Exception e2)
        {
            AddGeneralError(e2);
            return ds;
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
        ds.Tables.Add(dt);
    }

    private void AddGeneralError(Exception Ex)
    {
        dt = MakeErrorTable();
        ErrorRow["ErrorType"] = "General";
        ErrorRow["ErrorCode"] = "1";
        ErrorRow["ErrorText"] = Ex.ToString();
        dt.Rows.Add(ErrorRow);
        ds.Tables.Add(dt);
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
