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
public class ContainerXDockData
{
    string ERPConnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataRow ErrorRow;
    string _ToLoc = "__";
    string _BegContainer = "";
    string _EndContainer = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    string _BegBOL = "";
    string _EndBOL = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    string _BegDate = "";
    string _EndDate = "";
    DateTime MinDate = DateTime.Today.AddDays(-720);
    DateTime MaxDate = DateTime.Today;

    public DataTable SearchUnprocessed(string ToLoc, string BegContainer, string EndContainer,
        string BegBOL, string EndBOL, string BegDate, string EndDate)
    {
        _ToLoc = "__";
        _BegContainer = "%";
        _EndContainer = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
        _BegBOL = "%";
        _EndBOL = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
        _BegDate = MinDate.ToShortDateString();
        _EndDate = MaxDate.ToShortDateString();

        if (ToLoc.Trim() != "00") _ToLoc = ToLoc;
        if (BegContainer.Trim() != "")
        {
            _BegContainer = BegContainer;
            _EndContainer = BegContainer;
        }
        if (EndContainer.Trim() != "") _EndContainer = EndContainer;
        if (BegBOL.Trim() != "")
        {
            _BegBOL = BegBOL;
            _BegBOL = BegBOL;
        }
        if (EndBOL.Trim() != "") _EndBOL = EndBOL;
        if (BegDate.Trim() != "") _BegDate = BegDate;
        if (EndDate.Trim() != "") _EndDate = EndDate;
        return WorkFormData("Unprocessed", _ToLoc, _BegContainer, _EndContainer,
         _BegBOL, _EndBOL, _BegDate, _EndDate, "", "", "", "", "0", "");
    }

    public DataTable GetContainerItems(string Container, string UserID)
    {
        // Lock the container
        dt = WorkFormData("SoftLockLOCK", "", Container, "",
         "", "", MinDate.ToShortDateString(), MaxDate.ToShortDateString(), "", "", "", "", "0", UserID);
        // now get the items
        return WorkFormData("ContainerItems", "", Container, "",
         "", "", MinDate.ToShortDateString(), MaxDate.ToShortDateString(), "", "", "", "", "0", "");
    }

    public DataTable GetItem(string Container, string Item)
    {
        return WorkFormData("ItemDetail", "", Container, "",
         "", "", MinDate.ToShortDateString(), MaxDate.ToShortDateString(), "", "", "", Item, "0", "");
    }

    public DataTable GetItemRegions(string Container, string Item)
    {
        return WorkFormData("ItemRegions", "", Container, "",
         "", "", MinDate.ToShortDateString(), MaxDate.ToShortDateString(), "", "", "", Item, "0", "");
    }

    public DataTable AddXDockRecs(string Container, string ToLoc, string FromLoc, string Item, string Qty, string UserID, string RecID)
    {
        return WorkFormData("AddXDoc", ToLoc, Container, FromLoc,
         "", "", MinDate.ToShortDateString(), MaxDate.ToShortDateString(), "CT", "", "", Item, Qty, UserID);
    }

    public DataTable GetOtherXDock(string Item, string Container)
    {
        return WorkFormData("OtherXDock", "", Container, "",
         "", "", MinDate.ToShortDateString(), MaxDate.ToShortDateString(), "CT", "", "", Item, "0", "");
    }

    public DataTable ReleaseContainer(string Container, string UserID)
    {
        // Release the container
        return WorkFormData("SoftLockRELEASE", "", Container, "",
         "", "", MinDate.ToShortDateString(), MaxDate.ToShortDateString(), "", "", "", "", "0", UserID);
    }

    public DataTable WorkFormData(string Action, string ToLoc, string BegContainer, string EndContainer,
        string BegBOL, string EndBOL, string BegDate, string EndDate, string CrossDocType,
        string VendNo, string PONo, string ItemNo, string Qty, string EntryID)
    {
        StringBuilder errorMessages = new StringBuilder();
        try
        {
            // get the data.
            ds = SqlHelper.ExecuteDataset(ERPConnectionString, "pContainerCrossDocForm",
                      new SqlParameter("@Action", Action),
                      new SqlParameter("@ToLoc", ToLoc),
                      new SqlParameter("@BegContainer", BegContainer),
                      new SqlParameter("@EndContainer", EndContainer),
                      new SqlParameter("@BegBOL", BegBOL),
                      new SqlParameter("@EndBOL", EndBOL),
                      new SqlParameter("@BegDate", BegDate),
                      new SqlParameter("@EndDate", EndDate),
                      new SqlParameter("@CrossDocType", CrossDocType),
                      new SqlParameter("@VendNo", VendNo),
                      new SqlParameter("@PONo", PONo),
                      new SqlParameter("@ItemNo", ItemNo),
                      new SqlParameter("@Qty", Qty),
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
