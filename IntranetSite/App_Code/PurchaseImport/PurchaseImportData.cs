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
/// PurchaseImportData: SQL data classes for Purchase Import processing
/// </summary>
public class PurchaseImportData
{
    string ERPConnectionString = ConfigurationManager.ConnectionStrings["PFCERPConnectionString"].ToString();
    string NVConnectionString = ConfigurationManager.ConnectionStrings["csNVEnterprise"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataRow ErrorRow;
    string _ToLoc = "__";
    string _BegCategory = "00000";
    string _EndCategory = "99999";
    string _BegBOL = "";
    string _EndBOL = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
    string _BegDate = "";
    string _EndDate = "";
    DateTime MinDate = DateTime.Today.AddDays(-720);
    DateTime MaxDate = DateTime.Today;

    public DataTable GetCatLists()
    {
        return WorkFormData("CatList", "", "", "", "", "0", "");
    }

    public DataTable GetCatFilter(string RecID)
    {
        return WorkFormData("GetCatFilter", "", "", "", "", RecID, "");
    }

    public DataTable AddCatData(string VendNo, string BegCategory, string EndCategory, string ImportFileName, string UserID)
    {
        // Add the Category Filter
        dt = WorkFormData("AddCatFilterData", VendNo, BegCategory, EndCategory,
         ImportFileName, "0", UserID);
        // Return the list
        return GetCatLists();
    }

    public DataTable FixCatData(string VendNo, string BegCategory, string EndCategory, string ImportFileName, string RecID, string UserID)
    {
        // Update the Category Filter
        dt = WorkFormData("FixCatFilterData", VendNo, BegCategory, EndCategory,
         ImportFileName, RecID, UserID);
        // Return the list
        return GetCatLists();
    }

    public DataTable DeleteCatData(string RecID)
    {
        // Delete a filter record
        dt = WorkFormData("DeleteCatFilter", "", "", "", "", RecID, "");
        // Return the list
        return GetCatLists();
    }

    public DataTable GetRTSData(string RecID)
    {
        // Get the data for the RTS import files
        dt = WorkFormData("GetRTSData", "", "", "", "", RecID, "");
        // Set the shipping location
        string OldPO = "";
        string ShippingPort = "";
        string ShortCode = "";
        foreach (DataRow row in (dt.Rows))
        {
            if (OldPO != row["RTSPONo"].ToString())
            {
                // get the shipping location for the PO "SELECT [Buy-from City] AS ShipLoc FROM [Porteous$Purchase Header] WHERE (No_ = '" + row["RTSPONo"].ToString() + "')")
                ds = SqlHelper.ExecuteDataset(NVConnectionString, "UGEN_SP_Select",
                      new SqlParameter("@tableName", "[Porteous$Purchase Header] with (NOLOCK)  INNER JOIN Porteous$Vendor with (NOLOCK) ON [Porteous$Purchase Header].[Buy-from Vendor No_] = Porteous$Vendor.No_"),
                      new SqlParameter("@columnNames", "[Buy-from City] AS ShipLoc, [Search Name] as ShortCode"),
                      new SqlParameter("@whereClause", "([Porteous$Purchase Header].No_ = '" + row["RTSPONo"].ToString() + "')"));
                if ((ds.Tables[0] != null) && (ds.Tables[0].Rows.Count > 0))
                {
                    ShippingPort = ds.Tables[0].Rows[0]["ShipLoc"].ToString();
                    ShortCode = ds.Tables[0].Rows[0]["ShortCode"].ToString();
                }
                else
                {
                    ShippingPort = "USA";
                }
                OldPO = row["RTSPONo"].ToString();
            }
            row["ShippingPort"] = ShippingPort;
            row["Vendor"] = ShortCode;
        }
        // give it back
        return dt;
    }

    public DataTable WorkFormData(string Action, string VendNo, string BegCategory, string EndCategory,
        string ImportFileName, string RecID, string EntryID)
    {
        StringBuilder errorMessages = new StringBuilder();
        try
        {
            // get the data.
            DataSet ds1 = SqlHelper.ExecuteDataset(ERPConnectionString, "pPurchImportCatMaintForm",
                      new SqlParameter("@Action", Action),
                      new SqlParameter("@VendNo", VendNo),
                      new SqlParameter("@BegCategory", BegCategory),
                      new SqlParameter("@EndCategory", EndCategory),
                      new SqlParameter("@ImportFileName", ImportFileName),
                      new SqlParameter("@RecID", RecID),
                      new SqlParameter("@EntryID", EntryID)
                      );
            if (ds1.Tables[0].Rows.Count > 0)
            {
                return ds1.Tables[0];
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
