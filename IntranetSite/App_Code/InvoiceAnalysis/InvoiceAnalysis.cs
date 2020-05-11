using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using PFC.Intranet;
using PFC.Intranet.DataAccessLayer;
using PFC.Intranet.BusinessLogicLayer;

public class InvoiceAnalysis
{
    string connectionString = ConfigurationManager.AppSettings["ReportsConnectionString"].ToString();
    string erpconnectionString = ConfigurationManager.AppSettings["PFCERPConnectionString"].ToString();

    string _tableName = "";
    string _columnName = "";
    string _whereClause = "";
    string _groupBy = "";

    string _analysisColumns =   "CONVERT(nvarchar(10),Hdr.ARPostDt,101) as [ARDate], " +
                                "Hdr.CustShipLoc as Branch, " +
                                "Hdr.OrderTypeDsc as OrderType, " +
                                "Hdr.City as ShipToCity, " +
                                "Hdr.State as ShipToState, " +
                                "Hdr.SellToCustNo as CustNo, " +
                                "Hdr.SellToCustName as CustName, " +
                                "Hdr.InvoiceNo as DocNo, " +
                                "Hdr.CustPONo as CustPO, " +
                                "Hdr.NetSales, " +
                                "Hdr.TotalOrder - Hdr.NetSales as NetExp, " +
                                "Hdr.TotalOrder as TotAR, " +
                                "Hdr.NetSales - Hdr.TotalCost as GMDollar, " +
                                "CASE WHEN Hdr.NetSales = 0 " +
                                "     THEN 0 " +
                                "     ELSE ((Hdr.NetSales - Hdr.TotalCost) / Hdr.NetSales) * 100 " +
                                "END as GMPct, " +
                                "Hdr.ShipWght as TotWgt, " +
                                "Hdr.OrderFreightName as ShipMethod, " +
                                "Hdr.CustSvcRepName as InsideSalesPerson, " +
                                "Hdr.SalesRepName as SalesPerson, " +
                                "Hdr.ShipToName, " +
                                "Hdr.OrderSource, " +
                                "List.SequenceNo as OrderSourceSeq, " +
                                "Cust.ChainCd as Chain, " +
                                "Cust.PriceCd";

    string _analysisTable =     "SOHeaderHist Hdr (NOLOCK) LEFT OUTER JOIN " +
                                "CustomerMaster Cust (NOLOCK) ON Hdr.SellToCustNo = Cust.CustNo LEFT OUTER JOIN " +
                                "(SELECT LM.ListName, LD.ListValue, LD.ListDtlDesc, LD.SequenceNo " +
                                " FROM   OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN " +
                                "        OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD " +
                          //    " FROM   ListMaster LM INNER JOIN " +
                          //    "        ListDetail LD " +
                                " ON     LM.pListMasterID=LD.fListMasterID " +
                                " WHERE  LM.ListName = 'SOEOrderSource') List " +
                                "ON List.ListValue = Hdr.OrderSource";

    public DataTable GetInvoiceAnalysis(string startDate, string endDate, string orderType, string branchID, string chain, string customerNumber, string weightFrom, string weightTo, string state, string shipment, string salesRepNo, string priceCd, string orderSource)
    {
        try
        {
            // Build where caluse
            _whereClause = "isnull(Hdr.DeleteDt,'') = '' and Hdr.ARPostDt>= '" + startDate + "' AND Hdr.ARPostDt<= '" + endDate + "'";

            if (orderType != "")
                _whereClause += " AND Hdr.OrderType " + ((orderType == "0") ? "<>'1'" : "='" + orderType + "'");
            if (branchID != "")
                _whereClause += " AND Hdr.CustShipLoc='" + branchID + "'";
            if (customerNumber != "")
                _whereClause += " AND Hdr.SellToCustNo='" + customerNumber + "'";
            if (state != "")
                _whereClause += " AND Hdr.State='" + state + "'";
            if (weightFrom != "")
                _whereClause += " AND Hdr.ShipWght>= " + weightFrom;
            if (weightTo != "")
                _whereClause += " AND Hdr.ShipWght<= " + weightTo;
            if (chain != "")
                _whereClause += " AND Cust.ChainCd='" + chain + "'";
            if (shipment != "")
                _whereClause += " AND Hdr.OrderFreightCd='" + shipment + "'";
                //_whereClause += " AND Hdr.OrderFreightName='" + shipment + "'";
                //_whereClause += " AND REPLACE(Hdr.OrderFreightCd,' ','')='" + shipment + "'";
            if (salesRepNo != "")
                _whereClause += " AND Hdr.SalesRepNo='" + salesRepNo + "'";
            if (priceCd != "")
                _whereClause += " AND Cust.PriceCd='" + priceCd + "'";
            switch (orderSource)
            {
                case "ALLCSR":
                    _whereClause += " AND List.SequenceNo <> 1";
                    break;
                case "ALLEC":
                    _whereClause += " AND List.SequenceNo = 1";
                    break;
                default:
                    if (orderSource != "")
                        _whereClause += " AND Hdr.OrderSource='" + orderSource + "'";
                    break;
            }
            
            DataSet dsResult = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                        new SqlParameter("@tableName", _analysisTable),
                                        new SqlParameter("@columnNames", _analysisColumns),
                                        new SqlParameter("@whereClause", _whereClause));
            return dsResult.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
        }
    }

    public DataTable GetInvoiceGroup(string subTotal, string startDate, string endDate, string orderType, string branchID, string chain, string customerNumber, string weightFrom, string weightTo, string state, string shipment, string salesRepNo, string priceCd, string orderSource)
    {
        try
        {
            switch (subTotal)
            {
                case "1":
                    _columnName = "Hdr.SellToCustNo as CustNo";
                    _groupBy = " Group by Hdr.SellToCustNo";
                    break;
                case "2":
                    _columnName = "Hdr.SellToCustNo as CustNo, Hdr.OrderSource";
                    _groupBy = " Group By Hdr.SellToCustNo, Hdr.OrderSource";
                    break;
                default:
                    _columnName = "CONVERT(nvarchar(10), Hdr.ARPostDt,101) as ARDate, Hdr.CustShipLoc as Branch, Hdr.City as ShipToCity";
                    _groupBy = " Group By Hdr.ARPostDt, Hdr.CustShipLoc, Hdr.City";
                    break;
            }

            // Build where caluse
            _whereClause = "Hdr.ARPostDt>= '" + startDate + "' AND Hdr.ARPostDt<= '" + endDate + "'";
            if (orderType != "")
                _whereClause += " AND Hdr.OrderType " + ((orderType == "0") ? "<>'1'" : "='" + orderType + "'");
            if (branchID != "")
                _whereClause += " AND Hdr.CustShipLoc='" + branchID + "'";
            if (customerNumber != "")
                _whereClause += " AND Hdr.SellToCustNo='" + customerNumber + "'";
            if (state != "")
                _whereClause += " AND Hdr.State='" + state + "'";
            if (weightFrom != "")
                _whereClause += " AND Hdr.ShipWght>= " + weightFrom;
            if (weightTo != "")
                _whereClause += " AND Hdr.ShipWght<= " + weightTo;
            if (chain != "")
                _whereClause += " AND Cust.ChainCd='" + chain + "'";
            if (shipment != "")
                _whereClause += " AND Hdr.OrderFreightCd='" + shipment + "'";
                //_whereClause += " AND Hdr.OrderFreightName='" + shipment + "'";
                //_whereClause += " AND REPLACE(Hdr.OrderFreightCd,' ','')='" + shipment + "'";
            if (salesRepNo != "")
                _whereClause += " AND Hdr.SalesRepNo='" + salesRepNo + "'";
            if (priceCd != "")
                _whereClause += " AND Cust.PriceCd='" + priceCd + "'";
            if (orderSource != "")
                _whereClause += " AND Hdr.OrderSource='" + orderSource + "'";
            switch (orderSource)
            {
                case "ALLCSR":
                    _whereClause += " AND List.SequenceNo <> 1";
                break;
                case "ALLEC":
                    _whereClause += " AND List.SequenceNo = 1";
                break;
                default:
                    if (orderSource != "")
                        _whereClause += " AND Hdr.OrderSource='" + orderSource + "'";
                break;
            }

            DataSet dsResult = SqlHelper.ExecuteDataset(connectionString, "UGEN_SP_Select",
                                        new SqlParameter("@tableName", _analysisTable),
                                        new SqlParameter("@columnNames", _columnName),
                                        new SqlParameter("@whereClause", _whereClause + _groupBy));

            return dsResult.Tables[0];
        }
        catch (Exception ex)
        {
            return null;
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
        //try
        //{
            _tableName = "ListMaster LM (NOLOCK), ListDetail LD (NOLOCK)";
            _columnName = "LD.ListDtlDesc as Description";
            _whereClause = "LM.ListName = '" + listName + "' AND LD.ListValue = '" + listValue + "' AND LD.fListMasterID = LM.pListMasterID";
            DataSet dsType = SqlHelper.ExecuteDataset(erpconnectionString, "UGEN_SP_Select",
                                new SqlParameter("@tableName", _tableName),
                                new SqlParameter("@columnNames", _columnName),
                                new SqlParameter("@whereClause", _whereClause));
            return dsType.Tables[0].Rows[0][0].ToString();
        //}
        //catch (Exception ex)
        //{
        //    return null;
        //}
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

    public DataSet GetInvoiceAnalysisByCustNo(string startDate, string endDate, string orderType, string branchID, string chain, string customerNumber, string territory, string CSRName, string state, string shipment, string salesPerson, string priceCd, string orderSource, string allCustFlag, string regionalMgr, string buyGroup, string rollUpInd)
    {
        try
        {
            // Build where caluse for sales
            string _whereSales = "Hdr.ARPostDt>= '" + startDate + "' AND Hdr.ARPostDt<= '" + endDate + "'";
            if (orderType != "")
                _whereSales += " AND Hdr.OrderType " + ((orderType == "0") ? "<>'1'" : "='" + orderType + "'");
            if (branchID != "")
                _whereSales += " AND Hdr.CustShipLoc='" + branchID + "'";
            //if (chain != "")
            //    _whereSales += " AND Cust.ChainCd='" + chain + "'";
            if (customerNumber != "")
                _whereSales += " AND Hdr.SellToCustNo='" + customerNumber + "'";
            //if (territory != "")
            //    _whereSales += " AND CUST.CustNo in (Select CustNo from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster Where SalesTerritory='" + territory + "')";
            if (state != "")
                _whereSales += " AND Hdr.State='" + state + "'";
            //if (CSRName != "")
            //    _whereSales += " AND Hdr.SalesRepNo='" + CSRName + "'";         //Outside Sales Rep
            if (shipment != "")
                _whereSales += " AND Hdr.OrderFreightCd='" + shipment + "'";
            //if (salesRepNo != "")
            //    _whereSales += " AND Hdr.CustSvcRepNo='" + salesRepNo + "'";    //Inside Sales Rep
            //if (priceCd != "")
            //    _whereSales += " AND Cust.PriceCd='" + priceCd + "'";
            switch (orderSource)
            {
                case "ALLCSR":
                    _whereSales += " AND List.SequenceNo <> 1";
                    break;
                case "ALLEC":
                    _whereSales += " AND List.SequenceNo = 1";
                    break;
                default:
                    if (orderSource != "")
                        _whereSales += " AND Hdr.OrderSource='" + orderSource + "'";
                    break;
            }

            string _whereCust = "1=1";
            if (branchID != "")
                _whereCust += " AND tAllCust.CustShipLocation='" + branchID + "'";
            if (chain != "")
                _whereCust += " AND tAllCust.ChainCd='" + chain + "'";
            //if (customerNumber != "")
            //    _whereCust += " AND CustNo='" + customerNumber + "'";
            if (territory != "")
                _whereCust += " AND tAllCust.CustNo in (SELECT CustNo FROM CustomerMaster (NoLock) WHERE SalesTerritory='" + territory + "')";  //Use this if we run against PERP instead of PFCReports
                //_whereCust += " AND CustNo in (SELECT CustNo FROM OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster WHERE SalesTerritory='" + territory + "')";
            if (CSRName != "")
                _whereCust += " AND tAllCust.OutsideRep='" + CSRName + "'";    //Outside Sales Rep
            if (salesPerson != "")
                _whereCust += " AND tAllCust.InsideRep='" + salesPerson + "'";  //Inside Sales Rep
            if (regionalMgr != "")
                _whereCust += " AND tRegionLoc.RegionalMgr='" + regionalMgr + "'";
            if (priceCd != "")
                _whereCust += " AND tAllCust.PriceCd='" + priceCd + "'";
            if (buyGroup != "")
                _whereCust += " AND isnull(tAllCust.BuyGroup,'')='" + buyGroup + "'";

            DataSet dsResult = SqlHelper.ExecuteDataset(erpconnectionString, "[pSalesPerformRpt]",
                                        new SqlParameter("@whereSales", _whereSales),
                                        new SqlParameter("@whereCust", _whereCust),
                                        new SqlParameter("@allCustFlg", allCustFlag),
                                        new SqlParameter("@startDt", startDate),
                                        new SqlParameter("@endDt", endDate),
                                        new SqlParameter("@RollUp", rollUpInd));

            return dsResult;
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
}
