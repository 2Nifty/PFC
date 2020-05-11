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
public class EDIData
{
    string ERPconnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataRow ErrorRow;


    public DataTable GetAll753(string HeaderID)
    {
        return WorkEDI753Data("Get753", "0", 0, "", 0, "", 0, "", HeaderID, "");
    }

    public DataTable GetPending()
    {
        return WorkEDI753Data("Pending", "0", 0, "", 0, "", 0, "", "0", "");
    }

    public DataTable GetEI753Detail(string DetailID)
    {
        return WorkEDI753Data("GetDetail", DetailID, 0, "", 0, "", 0, "", "0", "");
    }

    public DataTable GetSO(string OrderNo)
    {
        return WorkEDI753Data("GetOrder", OrderNo, 0, "", 0, "", 0, "", "0", "");
    }

    public DataTable WorkEDI753Data(string Action, string OrderID, decimal PalletQty, string QtyType,
        decimal ShipQty, string DeliveryDate, int DeliveryTime, string UserID, string EDI753HdrID, string ErrorText)
    {
        StringBuilder errorMessages = new StringBuilder();
        SqlParameter HeaderID = new SqlParameter();
        HeaderID.Direction = ParameterDirection.InputOutput;
        HeaderID.SqlDbType = SqlDbType.BigInt;
        HeaderID.Value = EDI753HdrID;
        HeaderID.ParameterName = "@EDI753HdrID";
        try
        {
            ds = SqlHelper.ExecuteDataset(ERPconnectionString, "pEDIX12CreateRouteReq",
               new SqlParameter("@Action", Action),
               new SqlParameter("@RecToFind", OrderID),
               new SqlParameter("@PalletQty", PalletQty),
               new SqlParameter("@QtyType", QtyType),
               new SqlParameter("@ShipQty", ShipQty),
               new SqlParameter("@DeliveryDate", DeliveryDate),
               new SqlParameter("@DeliveryTime", DeliveryTime),
               new SqlParameter("@EntryID", UserID),
               HeaderID);
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

    public DataSet Get753Export(string EDI753HdrID)
    {
        SqlParameter HeaderID = new SqlParameter();
        HeaderID.Direction = ParameterDirection.InputOutput;
        HeaderID.SqlDbType = SqlDbType.BigInt;
        HeaderID.Value = EDI753HdrID;
        HeaderID.ParameterName = "@EDI753HdrID";
        ds = SqlHelper.ExecuteDataset(ERPconnectionString, "pEDIX12CreateRouteReq",
           new SqlParameter("@Action", "GetExport"),
           new SqlParameter("@RecToFind", "0"),
           new SqlParameter("@PalletQty", "0"),
           new SqlParameter("@QtyType", ""),
           new SqlParameter("@ShipQty", "0"),
           new SqlParameter("@DeliveryDate", "01/01/1900"),
           new SqlParameter("@DeliveryTime", "0"),
           new SqlParameter("@EntryID", ""),
           HeaderID);
        return ds;
    }

    public DataTable Get754Export(string EDI754HdrID)
    {
        ds = SqlHelper.ExecuteDataset(ERPconnectionString, "pEDIX12754EMail",
           new SqlParameter("@pEDI754HdrID", EDI754HdrID),
           new SqlParameter("@EMailText", ""),
           new SqlParameter("@LocEmailAddress", ""));
        return ds.Tables[0];
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
