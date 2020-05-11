            DECLARE     @Beg3MoDate DATETIME,
                  @End3MoDate DATETIME,
                  @Beg12MoDate DATETIME,
                  @End12MoDate DATETIME

            --Beg3MoDate
            SELECT      DISTINCT
                  @Beg3MoDate = CurFiscalMthBeginDt
            FROM  FiscalCalendar
            WHERE (DATEPART(yyyy,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))) * 100) + DATEPART(m,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))
                  IN    
                  (SELECT     (DATEPART(yyyy,DATEADD(m,-3,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-3,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))))
                   FROM FiscalCalendar
                   WHERE      CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))

            --End3MoDate
            SELECT      DISTINCT
                  @End3MoDate = CurFiscalMthEndDt
            FROM  FiscalCalendar
            WHERE (DATEPART(yyyy,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))) * 100) + DATEPART(m,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))
                  IN
                  (SELECT     (DATEPART(yyyy,DATEADD(m,-1,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-1,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))))
                   FROM FiscalCalendar
                   WHERE      CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))

            --Beg12MoDate
            SELECT      DISTINCT
                  @Beg12MoDate = CurFiscalMthBeginDt
            FROM  FiscalCalendar
            WHERE (DATEPART(yyyy,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))) * 100) + DATEPART(m,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))
                  IN
                  (SELECT     (DATEPART(yyyy,DATEADD(m,-12,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-12,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))))
                   FROM FiscalCalendar
                   WHERE      CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))

            --End12MoDate
            SELECT      DISTINCT
                  @End12MoDate = CurFiscalMthEndDt
            FROM  FiscalCalendar
            WHERE (DATEPART(yyyy,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))) * 100) + DATEPART(m,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))
                  IN
                  (SELECT     (DATEPART(yyyy,DATEADD(m,-1,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8))))) * 100) + DATEPART(m,DATEADD(m,-1,(CAST(((FiscalCalYear * 100 + FiscalCalMonth) * 100 + 01) as CHAR(8)))))
                   FROM FiscalCalendar
                   WHERE      CurrentDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME))


         SELECT      @Beg3MoDate as Beg3MoDate, @End3MoDate as End3MoDate, @Beg12MoDate as Beg12MoDate, @End12MoDate as End12MoDate


SELECT     distinct tCatSalesSum.Branch,
                        tCatSalesSum.CustNo as CustomerNo,
                        tCatSalesSum.CustName as CustomerName,
                        CAST(tCatSalesSum.GroupNo as VARCHAR(5)) as GroupNo,
                        tCatSalesSum.GroupDesc,
                        tCatSalesSum.GroupSales as SalesHistory,
                        ROUND(tCatSalesSum.PriceCostGMPct,2) as GMPctPriceCost,
                        tCatSales12MoSum.GroupSales12Mo as SalesHistory12Mo,
                        ROUND(tCatSales12MoSum.PriceCostGMPct12Mo,2) as GMPctPriceCost12Mo,
                        0.0 as TargetGMPct,
                        '0' as Approved,
                        '0' as RecType,
                        'C' as GroupType, --Category
                        -1 as pUnprocessedCategoryPriceID,
                        tCatSalesSum.ExistingCustPricePct
                   FROM (SELECT     tCatSales.CustNo,
                              tCatSales.CustName,
                              tCatSales.Branch,
                              tCatSales.CatNo as GroupNo,
                              tCatSales.CatDesc as GroupDesc,
                              ISNULL(SUM(tCatSales.Sales),0) as GroupSales,
                              CASE WHEN SUM(tCatSales.Sales) = 0
                                    THEN 0 
                                    ELSE 100 * SUM(tCatSales.PriceGMDol) / SUM(tCatSales.Sales)
                              END as PriceCostGMPct,
                              MAX(ISNULL(tCatSales.ExistingCustPricePct,-1)) as ExistingCustPricePct
                         FROM (SELECT     SOH.SellToCustNo as CustNo,
                                    CM.CustShipLocation as Branch,
                                    SOH.SellToCustName as CustName, 
                                    SOD.ItemNo,
                                    LEFT(SOD.ItemNo,5) as CatNo,
--                                  IM.CatDesc,
                                    CatList.CatDesc,
                                    ISNULL(SOD.QtyShipped * SOD.NetUnitPrice,0) as Sales,
                                    CASE WHEN ISNULL(IB.PriceCost,0) = 0
                                          THEN SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost
                                          ELSE SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * IB.PriceCost 
                                    END as PriceGMDol,
                                    Price.DiscPct as ExistingCustPricePct
                               FROM ItemBranch IB (NoLock) INNER JOIN
                                    SOHeaderHist SOH (NoLock) INNER JOIN
                                    SODetailHist SOD (NoLock)
                               ON   SOH.pSOHeaderHistID = SOD.fSOHeaderHistID INNER JOIN
                                    ItemMaster IM (NoLock)
                               ON   SOD.ItemNo = IM.ItemNo
                               ON   IB.fItemMasterID = IM.pItemMasterID AND IB.Location = SOD.IMLoc LEFT OUTER JOIN
                                    CategoryBuyGroups CAS (NoLock)
                               ON   CAS.Category = LEFT(SOD.ItemNo,5) INNER JOIN
                                    CustomerMaster CM (NoLock)
                               ON   CM.CustNo = SOH.SellToCustNo LEFT OUTER JOIN
                                    CompetitorPrice CP (NoLock)
                               ON   CP.PFCItem = SOD.ItemNo LEFT OUTER JOIN
                                    CustomerPrice Price (NoLock)
                               ON   (Price.ItemNo = CAST(CAS.GroupNo as VARCHAR(20)) or Price.ItemNo = CAS.Category) AND Price.CustNo = SOH.SellToCustNo LEFT OUTER JOIN
                                    (SELECT     LD.ListValue AS CatNo, LD.ListDtlDesc AS CatDesc
                                     FROM ListMaster (NoLock) LM INNER JOIN
                                          ListDetail (NoLock) LD
                                     ON   LM.pListMasterID = LD.fListMasterID
                                     WHERE      LM.ListName = 'CategoryDesc') CatList
                               ON   CatList.CatNo = LEFT(SOD.ItemNo,5)
                               --Use last 3 closed months of Sales Invoice data, skipping CompetitorPrice table items, Bulk Only
                               WHERE      SUBSTRING(SOD.ItemNo,12,1) in ('0','1','5') AND
                                    (CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg3MoDate and @End3MoDate) AND
                                    CASE WHEN CP.PFCItem is null
                                          THEN ''
                                          ELSE 'Skip'
                                    END <> 'SKIP' AND
                                    SOH.SellToCustNo = '066321' and CatList.CatNo='00170') tCatSales
                         GROUP BY tCatSales.CustNo, tCatSales.CustName, tCatSales.Branch, tCatSales.CatNo, tCatSales.CatDesc) tCatSalesSum INNER JOIN
                        (SELECT     tCatSales12Mo.CustNo,
                              tCatSales12Mo.CustName,
                              tCatSales12Mo.Branch,
                              tCatSales12Mo.CatNo as GroupNo,
                              tCatSales12Mo.CatDesc as GroupDesc,
                              ISNULL(SUM(tCatSales12Mo.Sales12Mo),0) as GroupSales12Mo,
                              CASE WHEN SUM(tCatSales12Mo.Sales12Mo) = 0
                                    THEN 0 
                                    ELSE 100 * SUM(tCatSales12Mo.PriceGMDol12Mo) / SUM(tCatSales12Mo.Sales12Mo)
                              END as PriceCostGMPct12Mo
                         FROM (SELECT     SOH.SellToCustNo as CustNo,
                                    CM.CustShipLocation as Branch,
                                    SOH.SellToCustName as CustName, 
                                    LEFT(SOD.ItemNo,5) as CatNo,
--                                  IM.CatDesc,
                                    CatList.CatDesc,
                                    ISNULL(SOD.QtyShipped * SOD.NetUnitPrice,0) as Sales12Mo,
                                    CASE WHEN ISNULL(IB.PriceCost,0) = 0
                                          THEN SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * SOD.UnitCost
                                          ELSE SOD.QtyShipped * SOD.NetUnitPrice - SOD.QtyShipped * IB.PriceCost 
                                    END as PriceGMDol12Mo
                               FROM ItemBranch IB (NoLock) INNER JOIN
                                    SOHeaderHist SOH (NoLock) INNER JOIN
                                    SODetailHist SOD (NoLock)
                               ON   SOH.pSOHeaderHistID = SOD.fSOHeaderHistID INNER JOIN
                                    ItemMaster IM (NoLock)
                               ON   SOD.ItemNo = IM.ItemNo
                               ON   IB.fItemMasterID = IM.pItemMasterID AND IB.Location = SOD.IMLoc LEFT OUTER JOIN
                                    CustomerMaster CM (NoLock)
                               ON   CM.CustNo = SOH.SellToCustNo LEFT OUTER JOIN
                                    CompetitorPrice CP (NoLock)
                               ON   CP.PFCItem = SOD.ItemNo LEFT OUTER JOIN
                                    (SELECT     LD.ListValue AS CatNo, LD.ListDtlDesc AS CatDesc
                                     FROM ListMaster (NoLock) LM INNER JOIN
                                          ListDetail (NoLock) LD
                                     ON   LM.pListMasterID = LD.fListMasterID
                                     WHERE      LM.ListName = 'CategoryDesc') CatList
                               ON   CatList.CatNo = LEFT(SOD.ItemNo,5)
                               --Use last 12 closed months of Sales Invoice data, skipping CompetitorPrice table items, Bulk Only
                               WHERE      SUBSTRING(SOD.ItemNo,12,1) in ('0','1','5') AND
                                    (CAST(FLOOR(CAST(SOH.ARPostDt AS FLOAT)) AS DATETIME) BETWEEN @Beg12MoDate and @End12MoDate) AND
                                    CASE WHEN CP.PFCItem is null
                                          THEN ''
                                          ELSE 'Skip'
                                    END <> 'SKIP' AND
                                    SOH.SellToCustNo = '066321' and CatList.CatNo='00170') tCatSales12Mo
                         GROUP BY tCatSales12Mo.CustNo, tCatSales12Mo.CustName, tCatSales12Mo.Branch, tCatSales12Mo.CatNo, tCatSales12Mo.CatDesc) tCatSales12MoSum
                         ON   tCatSalesSum.CustNo = tCatSales12MoSum.CustNo AND tCatSalesSum.Branch = tCatSales12MoSum.Branch AND tCatSalesSum.GroupNo = tCatSales12MoSum.GroupNo

exec pCustPriceGetHist '066321'