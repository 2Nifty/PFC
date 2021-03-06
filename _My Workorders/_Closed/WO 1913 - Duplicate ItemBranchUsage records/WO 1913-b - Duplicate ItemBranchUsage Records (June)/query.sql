
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

-- Summarize SODetail History
  
SELECT ISNULL(SODH.UsageLoc,IMLoc) AS IMLoc,SODH.ItemNo,@CurPeriod AS Period,Count(*) AS SlsCnt,
SUM(QtyShipped) AS SlsQty,
SUM(NetUnitPrice*QtyShipped) AS SlsDol,
SUM(UnitCost * QtyShipped) AS SlsCost,
SUM(IM.Wght * QtyShipped) AS SlsWght, @userName AS EntID, GetDate() AS EntDt
INTO #SODetailSum
FROM SODETAILHist SODH (nolock),SOHeaderHist SOHH (nolock), ItemMaster IM (nolock) 
WHERE  SODH.fSOHeaderHistID = SOHH.pSOHeaderHistID
AND SODH.ItemNo = IM.ItemNo
AND SOHH.InvoiceDt Between @begInvDt AND @endInvDt

--and ISNULL(SODH.UsageLoc,IMLoc)='04' and SODH.ItemNo='00050-3220-021'

GROUP BY ISNULL(SODH.UsageLoc,IMLoc), SODH.ItemNo



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
'Tod' as EntID, GetDate() EntDt, NULL AS ChgID, NULL AS ChgDt,
Null as StsCd 
FROM #SODetailSum SDS (NOLOCK) LEFT OUTER JOIN SumItem SI (NOLOCK)
ON SDS.IMLoc = SI.Location and SDS.ItemNo = SI.ItemNo,
ItemMaster IMM (NOLOCK) WHERE SDS.Period = '201006' --@CurPeriod
and SI.SourceCd ='OH'
AND SDS.ItemNo = IMM.ItemNo and
SDS.IMLoc='10' and SDS.ItemNo='00080-4464-040' and SDS.Period='201006'
