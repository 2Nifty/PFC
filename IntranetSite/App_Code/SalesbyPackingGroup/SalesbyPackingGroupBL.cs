using System;
using System.Data;
using System.Configuration;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;

public class SalesbyPackingGroupBL
{
    string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    string erpconnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();
    DataSet ds = new DataSet();
    DataTable dt = new DataTable();
    DataRow ErrorRow;

    string _tableName = "";
    string _columnName = "";
    string _whereClause = "";
    string _groupBy = "";


    /// <summary>
    /// public method GetALLBranches is used to fill authorized branches 
    /// in DropDownList ddlBranch
    /// </summary>
    /// <param name="ddlBranch">DropDownList control ID</param>
    /// <param name="userID">string userID</param>
    public void GetALLBranches(DropDownList ddlBranch, string userID)
    {
        try
        {
            ddlBranch.DataSource = System.Web.HttpContext.Current.Session["BranchComboValues"] as DataSet;
            ddlBranch.DataTextField = "Name";
            ddlBranch.DataValueField = "Branch";
            ddlBranch.DataBind();
            ddlBranch.Items.Insert(0, new ListItem("ALL", System.Web.HttpContext.Current.Session["BranchIDForALL"].ToString() + " "));
        }
        catch (Exception ex)
        {

        }
    }

    public DataTable GetSalesPerson()
    {
        //try
        //{
            _tableName = "RepMaster (NOLOCK) INNER JOIN SOHeaderHist (NOLOCK) ON SalesRepNo = RepNo";
            _columnName = "DISTINCT RepName, RepNo";
            _whereClause = "RepEmail is not null AND RepEmail <> '' AND left(RepName,2) <> 'xx' ORDER BY RepName";

            DataSet dsResult = SqlHelper.ExecuteDataset(erpconnectionString, "UGEN_SP_Select",
                                        new SqlParameter("@tableName", _tableName),
                                        new SqlParameter("@columnNames", _columnName),
                                        new SqlParameter("@whereClause", _whereClause));

            return dsResult.Tables[0];
        //}
        //catch (Exception ex)
        //{
        //    return null;
        //}
    }

    public DataTable GetDataFromList(string listName)
    {
        //try
        //{
            _tableName = "ListMaster LM (NOLOCK), ListDetail LD (NOLOCK)";
            _columnName = "LD.ListValue as ValueField, LD.ListValue + ' - ' + LD.ListDtlDesc as TextField";
            _whereClause = "LM.ListName = '" + listName + "' AND LD.fListMasterID = LM.pListMasterID order by SequenceNo asc";
            DataSet dsType = SqlHelper.ExecuteDataset(erpconnectionString, "UGEN_SP_Select",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            return dsType.Tables[0];
        //}
        //catch (Exception ex)
        //{
        //    return null;
        //}
    }

    public String GetListDesc(string listName, string listValue)
    {
        try
        {
            _tableName = "ListMaster LM (NOLOCK), ListDetail LD (NOLOCK)";
            _columnName = "LD.ListDtlDesc as Description";
            _whereClause = "LM.ListName = '" + listName + "' AND LD.ListValue = '" + listValue + "' AND LD.fListMasterID = LM.pListMasterID";
            DataSet dsType = SqlHelper.ExecuteDataset(erpconnectionString, "UGEN_SP_Select",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            return dsType.Tables[0].Rows[0][0].ToString();
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public DataTable GetDataFromTables(string tableType)
    {
        //try
        //{
            _tableName = "Tables (NOLOCK)";
            _columnName = "TableCd as ValueField, Dsc as TextField";
            _whereClause = "TableType = '" + tableType + "' AND  SOApp = 'Y'";

            DataSet dsResult = SqlHelper.ExecuteDataset(erpconnectionString, "UGEN_SP_Select",
                                        new SqlParameter("@tableName", _tableName),
                                        new SqlParameter("@columnNames", _columnName),
                                        new SqlParameter("@whereClause", _whereClause));

            return dsResult.Tables[0];
        //}
        //catch (Exception ex)
        //{
        //    return null;
        //}
    }

    #region Invoice Analysis By Customer
    string _analysisByCustColumns = "Hdr.CustShipLoc as Branch," +
                                    "Hdr.SellToCustNo as CustNo, " +
                                    "Hdr.SellToCustName as CustName, " +
                                    "SUM(Hdr.NetSales) as NetSales, " +
                                    "SUM(Hdr.TotalOrder - Hdr.NetSales) as NetExp, " +
                                    "SUM(Hdr.TotalOrder) as TotAR, " +
                                    "SUM(Hdr.NetSales - Hdr.TotalCost) as GMDollar, " +
                                    "(CASE WHEN SUM(Hdr.NetSales) = 0  THEN 0  ELSE ((SUM(Hdr.NetSales - Hdr.TotalCost)) / SUM(Hdr.NetSales)) * 100 END) as GMPct," +
                                    "SUM(Hdr.ShipWght) as TotWgt, " +
                                    "Cust.ChainCd as Chain, " +
                                    "Cust.PriceCd";

    string _custGroupBy = " GROUP BY Hdr.SellToCustNo," +
                                    "Hdr.SellToCustName," +
                                    "Hdr.CustShipLoc," +
                                    "Cust.ChainCd," +
                                    "Cust.PriceCd";


    //public DataTable GetLostLeadersDatabyBuyGrp(string startDate, string endDate, string branch, string chain, string custNo, string salesTerritory, string outsideRep, string insideRep, string orderSource, string buyGroup, string runMode, string category )
    public DataTable GetLostLeadersDatabyBuyGrp(string startDate, string endDate, string branch, string chain, string custNo, string salesTerritory, string outsideRep, string insideRep, string orderSource, string buyGroup, string buyGrp, string category, string runMode)
    {
        ds = SqlHelper.ExecuteDataset(erpconnectionString, "pLostLeadersRpt_v9",
                   new SqlParameter("@StartDate", startDate),
                   new SqlParameter("@EndDate", endDate),
                   new SqlParameter("@CustShipLoc ", branch),
                   new SqlParameter("@Chain ", chain),
                   new SqlParameter("@CustNo ", custNo),
                   new SqlParameter("@SalesTerritory ", salesTerritory),
                   new SqlParameter("@OutsideRep ", outsideRep),
                   new SqlParameter("@InsideRep ", insideRep),
                   new SqlParameter("@OrderSource ", orderSource),
                   new SqlParameter("@BuyGroup ", buyGroup),
                   new SqlParameter("@BuyGrp ", buyGrp),
                   new SqlParameter("@Category ", category),
                   new SqlParameter("@RunMode ", runMode)); // 11
                   //new SqlParameter("@category ", category)); 

            if (ds.Tables[0].Rows.Count > 0)
            {
                return ds.Tables[0];
            }
            else
            {
                return null;
            }
               
    }

    //public DataTable GetLostLeadersDatabyBuyGrp(string startDate, string endDate, string branch, string chain, string custNo, string salesTerritory, string outsideRep, string insideRep, string orderSource, string buyGroup, string runMode, string category )
    public DataTable GetLostLeadersDatabyBuyGrpp(string startDate, string endDate, string branch, string chain, string custNo, string salesTerritory, string orderSource, string buyGroup, string buyGrp, string category, string runMode)
    {
        ds = SqlHelper.ExecuteDataset(erpconnectionString, "pLostLeadersRpt_v10",
                   new SqlParameter("@StartDate", startDate),
                   new SqlParameter("@EndDate", endDate),
                   new SqlParameter("@CustShipLoc ", branch),
                   new SqlParameter("@Chain ", chain),
                   new SqlParameter("@CustNo ", custNo),
                   new SqlParameter("@SalesTerritory ", salesTerritory),
                   //new SqlParameter("@OutsideRep ", outsideRep),
                   //new SqlParameter("@InsideRep ", insideRep),
                   new SqlParameter("@OrderSource ", orderSource),
                   new SqlParameter("@BuyGroup ", buyGroup),
                   new SqlParameter("@BuyGrp ", buyGrp),
                   new SqlParameter("@Category ", category),
                   new SqlParameter("@RunMode ", runMode)); // 11
        //new SqlParameter("@category ", category)); 

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0];
        }
        else
        {
            return null;
        }

    }

    public DataTable GetLostLeadersDatabyBuyGrppp(string startDate, string endDate, string branch, string orderSource, string locSalesGrp, string pkgType)
    {
       try 
        {
        ds = SqlHelper.ExecuteDataset(erpconnectionString, "pSalesByPackageGroup",
                   new SqlParameter("@StartDate", startDate),
                   new SqlParameter("@EndDate", endDate),
                   new SqlParameter("@CustShipLoc ", branch),
                   //new SqlParameter("@Chain ", chain),
                   //new SqlParameter("@CustNo ", custNo),
                   //new SqlParameter("@SalesTerritory ", salesTerritory),
                   //new SqlParameter("@OutsideRep ", outsideRep),
                   //new SqlParameter("@InsideRep ", insideRep),
                   new SqlParameter("@OrderSource ", orderSource),
                   //new SqlParameter("@BuyGroup ", buyGroup),
                   //new SqlParameter("@BuyGrp ", buyGrp),
                   //new SqlParameter("@Category ", category),
                   //new SqlParameter("@RunMode ", runMode)); 
                   new SqlParameter("@LocSalesGrp ", locSalesGrp), 
                   new SqlParameter("@PkgType ", pkgType)); 

        if (ds.Tables[0].Rows.Count > 0)
        {
            return ds.Tables[0];
        }
        else
        {
            return null;
        }

    }
    catch (Exception ex)
    {
        return null;
    }

    }

    public DataTable HistGetLostLeadersDatabyBuyGrppp(string branch, string orderSource, string locSalesGrp, string pkgType)
    {
        try
        {
            ds = SqlHelper.ExecuteDataset(erpconnectionString, "pSalesByPackageGroupHist",
                       new SqlParameter("@CustShipLoc ", branch),             
                       new SqlParameter("@OrderSource ", orderSource),              
                       new SqlParameter("@LocSalesGrp ", locSalesGrp),
                       new SqlParameter("@PkgType ", pkgType));
            if (ds.Tables[0].Rows.Count > 0)
            {
                return ds.Tables[0];
            }
            else
            {
                return null;
            }
        }
        catch (Exception ex)
        {
            return null;
        }
    }


    public DataTable GetSalesPerson(string branchID)
    {
        _tableName = "RepMaster";
        _columnName = "RepNo,RepName";
        _whereClause = "(RepStatus='A' OR  RepStatus='N' OR RepStatus='P') AND RepClass='I' ";

        if (branchID != "ALL")
            _whereClause += " AND SalesOrgNo='" + branchID + "'";

        DataSet dsResult = SqlHelper.ExecuteDataset(erpconnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause + " Order by RepName"));

        return dsResult.Tables[0];
    }

    public DataTable GetCSRNames(string branchID)
    {
        _tableName = "RepMaster";
        _columnName = "RepNo,RepName";
        _whereClause = "(RepStatus='A' OR  RepStatus='N' OR RepStatus='P') AND RepClass='O' ";

        if (branchID != "ALL")
            _whereClause += " AND SalesOrgNo='" + branchID + "'";

        DataSet dsResult = SqlHelper.ExecuteDataset(erpconnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause + " Order by RepName"));

        return dsResult.Tables[0];
    }

    public DataTable GetRegionalMgr(string branchID)
    {
        _tableName = "RepMaster";
        _columnName = "RepNo,RepName";
        //_whereClause = "(RepStatus='A' OR  RepStatus='N' OR RepStatus='P') AND RepClass='R' ";
        _whereClause = "RepClass='R' ";

        if (branchID != "ALL")
            _whereClause += " AND SalesOrgNo='" + branchID + "'";

        DataSet dsResult = SqlHelper.ExecuteDataset(erpconnectionString, "UGEN_SP_Select",
                                    new SqlParameter("@tableName", _tableName),
                                    new SqlParameter("@columnNames", _columnName),
                                    new SqlParameter("@whereClause", _whereClause + " Order by RepName"));

        return dsResult.Tables[0];
    }

    public DataTable GetTerritory(string branchID)
    {
        _tableName = "ListMaster LM (NOLOCK), ListDetail LD (NOLOCK)";
        _columnName = "LD.ListValue as ValueField, LD.ListValue + ' - ' + LD.ListDtlDesc as TextField";
        _whereClause = "LM.ListName = 'SalesTerritory' " + (branchID == "ALL" ? "" : " AND SequenceNo ='" + branchID + "'") + " AND LD.fListMasterID = LM.pListMasterID order by SequenceNo asc";

        DataSet dsType = SqlHelper.ExecuteDataset(erpconnectionString, "UGEN_SP_Select",
                            new SqlParameter("@tableName", _tableName),
                            new SqlParameter("@columnNames", _columnName),
                            new SqlParameter("@whereClause", _whereClause));
        return dsType.Tables[0];
    }

    //pete added per Sathis
    public DataTable GetSalesBranches(string salesRegionID)
    {
        try
        {
            _tableName = "LocMaster (NOLOCK)";
            _columnName = "LocID as Branch, LocID + ' - ' + LocName as Name";
            _whereClause = "LocSalesGrp='" + salesRegionID + "' Order by LocID";

            DataSet dsType = SqlHelper.ExecuteDataset(erpconnectionString, "UGEN_SP_Select",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            return dsType.Tables[0];
        }

        catch (Exception ex)
        {
            return null;
        }
    }


    #endregion

    public DataTable GetChainList()
    {
        _tableName = "ListMaster LM (NOLOCK), ListDetail LD (NOLOCK)";
        _columnName = "LD.ListValue as ValueField, LD.ListValue + ' - ' + LD.ListDtlDesc as TextField";
        _whereClause = "LM.ListName = 'CustChainName' AND LD.fListMasterID = LM.pListMasterID order by LD.ListValue asc";

        DataSet dsType = SqlHelper.ExecuteDataset(erpconnectionString, "UGEN_SP_Select",
                            new SqlParameter("@tableName", _tableName),
                            new SqlParameter("@columnNames", _columnName),
                            new SqlParameter("@whereClause", _whereClause));
        return dsType.Tables[0];
    }

    public DataTable GetChainListNoSumm()
    {
        _tableName = "ListMaster LM (NOLOCK), ListDetail LD (NOLOCK)";
        _columnName = "LD.ListValue as ValueField, LD.ListValue + ' - ' + LD.ListDtlDesc as TextField";
        _whereClause = "LM.ListName = 'CustChainName' AND isnull(LD.SequenceNo,'') <> '99' AND LD.fListMasterID = LM.pListMasterID order by LD.ListValue asc";

        DataSet dsType = SqlHelper.ExecuteDataset(erpconnectionString, "UGEN_SP_Select",
                            new SqlParameter("@tableName", _tableName),
                            new SqlParameter("@columnNames", _columnName),
                            new SqlParameter("@whereClause", _whereClause));
        return dsType.Tables[0];
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
