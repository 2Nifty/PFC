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

public class LostLeadersBL
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

    //string _analysisColumns =   "CONVERT(nvarchar(10),Hdr.ARPostDt,101) as [ARDate], " +
    //                            "Hdr.CustShipLoc as Branch, " +
    //                            "Hdr.OrderTypeDsc as OrderType, " +
    //                            "Hdr.City as ShipToCity, " +
    //                            "Hdr.State as ShipToState, " +
    //                            "Hdr.SellToCustNo as CustNo, " +
    //                            "Hdr.SellToCustName as CustName, " +
    //                            "Hdr.InvoiceNo as DocNo, " +
    //                            "Hdr.CustPONo as CustPO, " +
    //                            "Hdr.NetSales, " +
    //                            "Hdr.TotalOrder - Hdr.NetSales as NetExp, " +
    //                            "Hdr.TotalOrder as TotAR, " +
    //                            "Hdr.NetSales - Hdr.TotalCost as GMDollar, " +
    //                            "CASE WHEN Hdr.NetSales = 0 " +
    //                            "     THEN 0 " +
    //                            "     ELSE ((Hdr.NetSales - Hdr.TotalCost) / Hdr.NetSales) * 100 " +
    //                            "END as GMPct, " +
    //                            "Hdr.ShipWght as TotWgt, " +
    //                            "Hdr.OrderFreightName as ShipMethod, " +
    //                            "Hdr.CustSvcRepName as InsideSalesPerson, " +
    //                            "Hdr.SalesRepName as SalesPerson, " +
    //                            "Hdr.ShipToName, " +
    //                            "Hdr.OrderSource, " +
    //                            "List.SequenceNo as OrderSourceSeq, " +
    //                            "Cust.ChainCd as Chain, " +
    //                            "Cust.PriceCd";

    //string _analysisTable =     "SOHeaderHist Hdr (NOLOCK) LEFT OUTER JOIN " +
    //                            "CustomerMaster Cust (NOLOCK) ON Hdr.SellToCustNo = Cust.CustNo LEFT OUTER JOIN " +
    //                            "(SELECT LM.ListName, LD.ListValue, LD.ListDtlDesc, LD.SequenceNo " +
    //                            " FROM   OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN " +
    //                            "        OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD " +
    //                      //    " FROM   ListMaster LM INNER JOIN " +
    //                      //    "        ListDetail LD " +
    //                            " ON     LM.pListMasterID=LD.fListMasterID " +
    //                            " WHERE  LM.ListName = 'SOEOrderSource') List " +
    //                            "ON List.ListValue = Hdr.OrderSource";

    //public DataTable GetInvoiceAnalysis(string startDate, string endDate, string orderType, string branchID, string chain, string customerNumber, string weightFrom, string weightTo, string state, string shipment, string salesRepNo, string priceCd, string orderSource)
    //{
    //    try
    //    {
    //        // Build where caluse
    //        _whereClause = "Hdr.ARPostDt>= '" + startDate + "' AND Hdr.ARPostDt<= '" + endDate + "'";
    //        if (orderType != "")
    //            _whereClause += " AND Hdr.OrderType " + ((orderType == "0") ? "<>'1'" : "='" + orderType + "'");
    //        if (branchID != "")
    //            _whereClause += " AND Hdr.CustShipLoc='" + branchID + "'";
    //        if (customerNumber != "")
    //            _whereClause += " AND Hdr.SellToCustNo='" + customerNumber + "'";
    //        if (state != "")
    //            _whereClause += " AND Hdr.State='" + state + "'";
    //        if (weightFrom != "")
    //            _whereClause += " AND Hdr.ShipWght>= " + weightFrom;
    //        if (weightTo != "")
    //            _whereClause += " AND Hdr.ShipWght<= " + weightTo;
    //        if (chain != "")
    //            _whereClause += " AND Cust.ChainCd='" + chain + "'";
    //        if (shipment != "")
    //            _whereClause += " AND Hdr.OrderFreightCd='" + shipment + "'";
    //            //_whereClause += " AND Hdr.OrderFreightName='" + shipment + "'";
    //            //_whereClause += " AND REPLACE(Hdr.OrderFreightCd,' ','')='" + shipment + "'";
    //        if (salesRepNo != "")
    //            _whereClause += " AND Hdr.SalesRepNo='" + salesRepNo + "'";
    //        if (priceCd != "")
    //            _whereClause += " AND Cust.PriceCd='" + priceCd + "'";
    //        switch (orderSource)
    //        {
    //            case "ALLCSR":
    //                _whereClause += " AND List.SequenceNo <> 1";
    //                break;
    //            case "ALLEC":
    //                _whereClause += " AND List.SequenceNo = 1";
    //                break;
    //            default:
    //                if (orderSource != "")
    //                    _whereClause += " AND Hdr.OrderSource='" + orderSource + "'";
    //                break;
    //        }
            
    //        DataSet dsResult = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
    //                                    new SqlParameter("@tableName", _analysisTable),
    //                                    new SqlParameter("@columnNames", _analysisColumns),
    //                                    new SqlParameter("@whereClause", _whereClause));
    //        return dsResult.Tables[0];
    //    }
    //    catch (Exception ex)
    //    {
    //        return null;
    //    }
    //}

    //public DataTable GetInvoiceGroup(string subTotal, string startDate, string endDate, string orderType, string branchID, string chain, string customerNumber, string weightFrom, string weightTo, string state, string shipment, string salesRepNo, string priceCd, string orderSource)
    //{
    //    try
    //    {
    //        switch (subTotal)
    //        {
    //            case "1":
    //                _columnName = "Hdr.SellToCustNo as CustNo";
    //                _groupBy = " Group by Hdr.SellToCustNo";
    //                break;
    //            case "2":
    //                _columnName = "Hdr.SellToCustNo as CustNo, Hdr.OrderSource";
    //                _groupBy = " Group By Hdr.SellToCustNo, Hdr.OrderSource";
    //                break;
    //            default:
    //                _columnName = "CONVERT(nvarchar(10), Hdr.ARPostDt,101) as ARDate, Hdr.CustShipLoc as Branch, Hdr.City as ShipToCity";
    //                _groupBy = " Group By Hdr.ARPostDt, Hdr.CustShipLoc, Hdr.City";
    //                break;
    //        }

    //        // Build where caluse
    //        _whereClause = "Hdr.ARPostDt>= '" + startDate + "' AND Hdr.ARPostDt<= '" + endDate + "'";
    //        if (orderType != "")
    //            _whereClause += " AND Hdr.OrderType " + ((orderType == "0") ? "<>'1'" : "='" + orderType + "'");
    //        if (branchID != "")
    //            _whereClause += " AND Hdr.CustShipLoc='" + branchID + "'";
    //        if (customerNumber != "")
    //            _whereClause += " AND Hdr.SellToCustNo='" + customerNumber + "'";
    //        if (state != "")
    //            _whereClause += " AND Hdr.State='" + state + "'";
    //        if (weightFrom != "")
    //            _whereClause += " AND Hdr.ShipWght>= " + weightFrom;
    //        if (weightTo != "")
    //            _whereClause += " AND Hdr.ShipWght<= " + weightTo;
    //        if (chain != "")
    //            _whereClause += " AND Cust.ChainCd='" + chain + "'";
    //        if (shipment != "")
    //            _whereClause += " AND Hdr.OrderFreightCd='" + shipment + "'";
    //            //_whereClause += " AND Hdr.OrderFreightName='" + shipment + "'";
    //            //_whereClause += " AND REPLACE(Hdr.OrderFreightCd,' ','')='" + shipment + "'";
    //        if (salesRepNo != "")
    //            _whereClause += " AND Hdr.SalesRepNo='" + salesRepNo + "'";
    //        if (priceCd != "")
    //            _whereClause += " AND Cust.PriceCd='" + priceCd + "'";
    //        if (orderSource != "")
    //            _whereClause += " AND Hdr.OrderSource='" + orderSource + "'";
    //        switch (orderSource)
    //        {
    //            case "ALLCSR":
    //                _whereClause += " AND List.SequenceNo <> 1";
    //            break;
    //            case "ALLEC":
    //                _whereClause += " AND List.SequenceNo = 1";
    //            break;
    //            default:
    //                if (orderSource != "")
    //                    _whereClause += " AND Hdr.OrderSource='" + orderSource + "'";
    //            break;
    //        }

    //        DataSet dsResult = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
    //                                    new SqlParameter("@tableName", _analysisTable),
    //                                    new SqlParameter("@columnNames", _columnName),
    //                                    new SqlParameter("@whereClause", _whereClause + _groupBy));

    //        return dsResult.Tables[0];
    //    }
    //    catch (Exception ex)
    //    {
    //        return null;
    //    }
    //}

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


                 

    //public DataTable  GetLostLeadersDatabyBuyGrp(string startDate, string endDate, string branch, string chain, string custNo, string salesTerritory, string outsideRep, string insideRep, string orderSource, string buyGroup)
      
    //{
    //    StringBuilder errorMessages = new StringBuilder();
    //    try
    //    {
    //        ds = SqlHelper.ExecuteDataset(connectionString, "pLostLeadersRpt_v9",               
    //               new SqlParameter("@StartDate", startDate),
    //               new SqlParameter("@EndDate", endDate),
    //               new SqlParameter("@CustShipLoc ", branch),
    //               new SqlParameter("@Chain ", chain),
    //               new SqlParameter("@CustNo ", custNo),
    //               new SqlParameter("@SalesTerritory ", salesTerritory),
    //               new SqlParameter("@OutsideRep ", outsideRep),
    //               new SqlParameter("@InsideRep ", insideRep),
    //               new SqlParameter("@OrderSource ", orderSource),
    //               new SqlParameter("@BuyGroup ", buyGroup));
    //        //new SqlParameter("@RunMode ", runMode));

    //        if (ds.Tables[0].Rows.Count > 0)
    //        {
    //            return ds.Tables[0];
    //        }
    //        else
    //        {
    //            return null;
    //        }
    //    }
    //    catch (SqlException ex)
    //    {
    //        AddSQLError(ex);
    //        return dt;
    //    }
    //    catch (Exception e2)
    //    {
    //        AddGeneralError(e2);
    //        return dt;
    //    }
    //}


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
    #endregion

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
