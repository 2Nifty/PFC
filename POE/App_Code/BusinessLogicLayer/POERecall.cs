using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Data.Sql;
using System.Data.SqlClient;
using PFC.POE.DataAccessLayer;

/// <summary>
/// Summary description for PORecall
/// </summary>
public class POERecall
{
    //For Security Code
    string securityTable = "SecurityGroups SG,dbo.SecurityMembers SM, dbo.SecurityUsers SU";

    // Connection String
    string ERPConnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

    string _tableName = "";
    string _columnName = "";
    string _whereClause = "";

    public string HeaderIDColumn
    {
        get
        {
            return "POOrderNo";
        }
    }

  


    #region Sub Header
    public DataTable GetPurchaseOrderDetails(string tableName, string whereClause)
    {
       
        try
        {
            //dbo.POHeader LEFT OUTER JOIN
            //dbo.VendorMaster ON dbo.POHeader.POVendorNo = dbo.VendorMaster.VendNo

            _tableName = tableName + " as POHeader LEFT OUTER JOIN " +
                            "VendorMaster as VM ON POHeader.POVendorNo = VM.VendNo";
            _columnName = "pPOHeaderID,POOrderNo,POTypeName,convert(char(10),OrderDt,101)as OrderDt,OrderContactName,BuyFromAddress,BuyFromCity,BuyFromState,BuyFromZip,BuyFromCountry," +
                          "OrderContactPhoneNo,BuyFromVendorNo,ShipToName,ShipToAddress,ShipToCity,ShipToState,ShipToPhoneNo,ShipToZip,ShipToCountry,POVendorNo,ShipToContactName" +
                          ",TotalCost,TotalGrossWeight,TotalNetWeight,PODocumentStatus,POStatus,POExpenseInd,ShippingInstructions,"+
                          "OrderRefType,OrderRefNo,ConfirmingTo,CarrierCd+'-'+CarrierName as Carrier,ShipMethodCd +'-'+ShipMethodName as ShipMethod," +
                          "OrderTermsCd +' – '+OrderTermsName as OrderTerms,convert(char(10),ScheduledReceiptDt,101)as ScheduledReceiptDt,"+
                          "Convert(char(10),ScheduledShipDt,101)as ScheduledShipDt,convert(char(10),POPrintDt,101)as POPrintDt,"+
                          "convert(char(10),POHeader.DeleteDt,101)as DeleteDt,convert(char(10),CompleteDt,101)as CompleteDt ,convert(char(10),ReceiptDt,101)as ReceiptDt,"+
                          "POHeader.EntryID,VM.PayMethodCd,Buyer,ShipStatus,POReferences,ReceivedBy";

            _whereClause = whereClause;
            DataSet dsSalesOrderDetails = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames",  _columnName),
                                new SqlParameter("@whereClause", _whereClause));

            return dsSalesOrderDetails.Tables[0];
        }
        catch (Exception ex)
        {

            return null;
        }
    }


    #endregion

    public DataTable GetRecallDetail( string poNumber)
    {
        try
        {
            _tableName = "PODetail,ItemMaster IM";
            _columnName = "fPOHeaderID,VendorItemNo,IM.ItemDesc,ReceivingLocation,POLineStatus,POLineNo ,IM.ItemNo as ItemNo," +
                          "VendorItemNo,QtyOrdered,ExtendedCost,ExtendedWeight,ReceivingLocation,SuperEquivQty,TransitDays,"+
                          "CostUM,BaseQtyUM,ScheduledReceiptDt,ScheduledShipDt";
            _whereClause = "IM.ItemNo = [PODetail].[ItemNo] and  " + HeaderIDColumn + "='" +poNumber + "'";

            DataSet dsRecall=SqlHelper.ExecuteDataset(ERPConnectionString,"pSOESelect",
                              new SqlParameter("@tablename",_tableName ),
                              new SqlParameter("@columnName",_columnName),
                              new SqlParameter("@whereClause",_whereClause));
            return dsRecall.Tables[0];

        }

        catch (Exception ex)
        {
            return null;
        }
    }

    #region Comments
    public DataTable BindTop(string POOrderNo)
    {
        try
        {
            string tablename = "Pocomments";
            string columnName = "*";
            string where = "fPOHeaderID ='" + POOrderNo + "' and type='CT' and deletedt is null";
            DataSet dtTable = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                     new SqlParameter("@tableName", tablename),
                                     new SqlParameter("@columnNames", columnName),
                                     new SqlParameter("@whereClause", where));

            return dtTable.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
            throw;
        }
    }

    public DataTable BindBottom(string POOrderNo)
    {
        try
        {
            string tablename = "Pocomments";
            string columnname = "*";
            string where = "fPOHeaderID ='" + POOrderNo + "' and type='CB' and deletedt is null";
            DataSet dtTable = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                     new SqlParameter("@tableName", tablename),
                                     new SqlParameter("@columnNames", columnname),
                                     new SqlParameter("@whereClause", where));

            return dtTable.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
            throw;
        }
    }

    public DataTable BindComments(string POOrderNo, string lineNo)
    {
        try
        {
            string tablename = "Pocomments";
            string columnnmae = "*";
            string where = "fPOHeaderID ='" + POOrderNo + "' and type='LC' and commlineno='" + lineNo + "' and deletedt is null";
            DataSet dtTable = SqlHelper.ExecuteDataset(ERPConnectionString, "pSOESelect",
                                     new SqlParameter("@tableName", tablename),
                                     new SqlParameter("@columnNames", columnnmae),
                                     new SqlParameter("@whereClause", where));

            return dtTable.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
            throw;
        }
    }
    #endregion

}
