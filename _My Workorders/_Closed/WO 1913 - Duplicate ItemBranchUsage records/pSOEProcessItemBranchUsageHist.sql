

--CREATE   PROCEDURE [dbo].[pSOEProcessItemBranchUsageHist] 
--@begInvDt DATETIME,
--@endInvDt DATETIME,
--@userName VARCHAR(50)
--AS
BEGIN
-- =============================================
-- Author:		Craig Parks
-- Create date: 12/22/2008
-- Description:	Build ItemBranchUsage from History
-- 12/29/2008 CSP Correct Where clause for ItemMaster
-- Modified: 12/31/2008 Craig Parks Use SOIDetailHist UsageLoc if not NULL
-- Modified 1/2/2009 Craig Parks Use tSOHeaderHistUsage, tSODetailHistUsage
-- Modified: 1/26/2009 Craig Parks Column Name Updates
-- Modified: 3/27/2009 Craig Parks set Begin End InvDt with procedure based on current date
-- Modified: 9/1/2009 Craig Parks Use Fiscal period date range
-- Modified: 11/13/2009 Craig Parks Pick up both Navision and ERP Sales
-- =============================================
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
DECLARE @curPeriod   INT,
@endPeriod INT,
@msg VARCHAR(100),
@FM INT,
@FY INT,
@RefDate DATETIME
DECLARE @begInvDt DATETIME
DECLARE @endInvDT DATETIME
DECLARE @userName VARCHAR(50)
SET @userName = 'HistBuild'
-- Get FiscalMonth date range for prior month
DECLARE @today DATETIME
SELECT @today =  GETDATE()
/*Uncomment the following  statementThe above example posts 2009 03

--SET @today = CAST('11/01/2009' AS DATETIME) -- A date following the period you want to post
end uncomment*/
EXEC [dbo].[pUTRetPeriod] 
	-- Add the parameters for the stored procedure here
	@date  = @today, 
	@periodType  = 'LF',
    	@period  = @curPeriod   OUTPUT,
	@periodBegin  = @begInvDt OUTPUT,
	@periodEnd = @endInvDT OUTPUT


SET @endPeriod = @curPeriod;

select @begInvDt, @endInvDT, @CurPeriod

-- Summarize SODetail History


SELECT ISNULL(SODH.UsageLoc,IMLoc) AS IMLoc,SODH.ItemNo,'201004' AS Period,Count(*) AS SlsCnt,
SUM(QtyShipped) AS SlsQty,
SUM(NetUnitPrice*QtyShipped) AS SlsDol,
SUM(UnitCost * QtyShipped) AS SlsCost,
SUM(IM.Wght * QtyShipped) AS SlsWght, 'tod' AS EntID, GetDate() AS EntDt
INTO #SODetailSum
FROM SODETAILHist SODH (nolock),SOHeaderHist SOHH (nolock), ItemMaster IM (nolock) 
WHERE  SODH.fSOHeaderHistID = SOHH.pSOHeaderHistID
AND SODH.ItemNo = IM.ItemNo
AND SOHH.InvoiceDt Between '2010-03-28' AND '2010-04-01'
GROUP BY ISNULL(SODH.UsageLoc,IMLoc), SODH.ItemNo



-- Build ItemBranchUsage for Items not Currently in table for which there are Sales
INSERT INTO tempItemBranchUsage ([Location], ItemNo,  [CurPeriodNo],
[CurBegOnHandQty], [CurBegOnHandDol], [CurBegOnHandWght],
[CurNoofReceipts], [CurReceivedQty], [CurReceivedDol],
[CurReceivedWght], [CurNoofReturns], [CurReturnQty], [CurReturnDol],
[CurReturnWght], [CurNoofBackOrders], [CurBackOrderQty],
[CurBackOrderDol], [CurBackOrderWght], [CurNoofSales], [CurSalesQty],
[CurSalesDol], [CurSalesWght], [CurCostDol], [CurNoofTransfers],
[CurTransferQty], [CurTransferDol], [CurTransferWght], [CurNoofIssues],
[CurIssuesQty], [CurIssuesDol], [CurIssuesWght], [CurNoofAdjust],
[CurAdjustQty], [CurAdjustDol], [CurAdjustWght], [CurNoofChanges],
[CurChangeQty], [CurChangeDol], [CurChangeWght], [CurNoofPO], [CurPOQty],
[CurPODol], [CurPOWght], [CurNoofGER], [CurGERQty], [CurGERDol],
[CurGERWght], [CurNoofWorkOrders], [CurWorkOrderQty], [CurWorkOrderDol],
[CurWorkOrderWght], [CurLostSlsQty], [CurDailySlsQty], [CurDailyRetQty],
[CurEndOHQty], [CurEndOHDol], [CurEndOHWght], [CurNoofOrders], [CurNRSalesQty],
    [CurNRNoSales], [CurNRSalesDol], [CurNRSalesWght], [CurNRCostDol],
[EntryID], [EntryDt], [ChangeID], [ChangeDt], [StatusCd])

SELECT SDS.IMLoc, SDS.ItemNo, SDS.Period, Qty, ExtAvgCost,
(Qty * [NetUnitWght]) As BegOHWght,
0 AS NoRecs, 0 AS RecQty, 0 AS RecDol, 0 AS RecWght, 0 AS NoRet,
0 AS RetQty, 0 AS RetDol, 0 AS RetWght, 0 AS NoBO, 0 AS BOQty, 0 AS BODol,
0 AS BOWght, SDS.SlsCnt , SDS. SlsQty, SDS.SlsDol, SDS.SlsWght,
SDS.SlsCost, 0 AS NoXFR, 0 AS XFRQty, 0 As XFRDol, 0 AS XFRWght,
0 AS NoIss, 0 AS IssQty, 0 AS IssDol, 0 AS IssWght, 0 AS NoAdj,
0 AS AdjQty, 0 AS AdjDol, 0 AS AdjWght, 0 AS NoChg, 0 AS ChgQty,
0 AS ChgDol, 0 AS ChgWght, 0 AS NoPO, 0 AS POQty, 0 AS PODol,
0 AS POWght, 0 AS NoGer, 0 AS GERQty, 0 AS GERDol, 0 AS GERWght,
0 AS NoWO, 0 AS WOQty, 0 AS WODol, 0 AS WOWght, 0 AS LSQty,
0 AS DlySlsQty, 0 AS DlyRetQty, Qty AS EndOH, ExtAvgCost AS EndVal,
(Qty * [NetUnitWght]) As EndOHWght, 0 AS NoOrd, 0 AS NRUse,
0 AS NRNoSls, 0 AS NRSlsDol, 0 AS NRSlsWght, 0 AS NRSlsCost,
'tod' EntID, GetDate() EntDt, NULL AS ChgID, NULL AS ChgDt,
Null as StsCd 

FROM #SODetailSum SDS (NOLOCK) LEFT OUTER JOIN SumItem SI (NOLOCK)
ON SDS.IMLoc = SI.Location and SDS.ItemNo = SI.ItemNo,
ItemMaster IMM (NOLOCK) WHERE SDS.Period = '201004'
and SI.SourceCd ='OH'
AND SDS.ItemNo = IMM.ItemNo;


-- Set Fiscal Period Start and End Dates for Beginning End OH values
DECLARE @FMStart DATETIME,
@FMEND DATETIME
SELECT @FMStart = MIN(InvoiceDt) FROM SOHeaderHist (nolock)
WHERE InvoiceDt BETWEEN @BegInvDt AND @EndInvDT
SELECT @FMEnd = MAX(InvoiceDt) FROM SOHeaderHist (nolock)
WHERE InvoiceDt BETWEEN @BegInvDt AND @EndInvDT

 SELECT (DATEPART(yy,InvoiceDT) * 100) + DatePart(mm,InvoiceDT) AS Period,
ISNULL(SODH.UsageLoc,IMLoc) AS IMLoc,ItemNo,
SUM(QtyShipped) AS NRQty,
Count(*) AS NRNoSls,
SUM(ExtendedPrice) AS NRSlsDol,
SUM(ExtendedNetWght) AS NRSlsWght,
SUM(ExtendedCost) AS NRSlsCost

 INTO #NR FROM SODetailHist SODH (nolock) INNER JOIN
SOHeaderHist (nolock) ON fSOHeaderHistID = pSOHeaderHistID  WHERE
InvoiceDt BETWEEN @begInvDt and @endInvDt
AND ExcludedFromUsageFlag = 1
GROUP BY (DATEPART(yy,InvoiceDT) * 100) + DatePart(mm,InvoiceDT),
ISNULL(SODH.UsageLoc,IMLoc),
ItemNo

UPDATE ItemBranchUsage SET CurNRSalesQty = NRQty,
CurNRNoSales = NRNoSls, CurNRSalesDol = NRSlsDol,
CurNRSalesWght = NRSlsWght, CurNRCostDol = NRSlsCost
 
FROM #NR NR WHERE ItemBranchUsage.Location = NR.IMLoc
AND ItemBranchUsage.ItemNo = NR.ItemNo
AND ItemBranchUsage.CurPeriodNo = NR.Period
DROP TABLE #NR

RETURN (0)
END


GO
