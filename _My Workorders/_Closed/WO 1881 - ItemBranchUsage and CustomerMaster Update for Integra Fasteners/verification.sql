if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1881_UsageList]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1881_UsageList]
GO

--Step01: Build tWO1881_UsageList from SOHistory
--Less than 1 minute in DEV (1,542 rows affected)
SELECT	Hdr.SellToCustNo,
	Hdr.ARPostDt,
	RIGHT(('0000' + Cast(Per.FiscalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalPeriod AS VARCHAR(2))),2) AS CurPeriod,
	Dtl.ItemNo,
	Dtl.LineNumber,
	Dtl.QtyShipped,
	Dtl.NetUnitPrice,
	Dtl.ExtendedPrice,
	Dtl.NetWght,
	Dtl.ExtendedNetWght,
	Dtl.UnitCost,
	Dtl.ExtendedCost,
	ISNULL(Dtl.ExcludedFromUsageFlag,0) AS ExcludedFromUsageFlag,
	ISNULL(Hdr.UsageLoc, Dtl.IMLoc) AS UsageLoc
INTO	tWO1881_UsageList
FROM	SOHeaderHist Hdr (NoLock) INNER JOIN
	SODetailHist Dtl (NoLock)
ON	Hdr.pSOHeaderHistID = Dtl.fSOheaderHistID LEFT OUTER JOIN
	FiscalCalendar Per (NoLock)
ON	Hdr.ARPostDt = Per.CurrentDt
WHERE	Hdr.SellToCustNo = '076121' AND ISNULL(Hdr.UsageLoc, Dtl.IMLoc) = '10' AND
	Hdr.ArPostDt >= '2007-08-26' AND Hdr.SubType <= 50 AND Dtl.ItemNo <> '00000-0000-000' AND
	(Hdr.DeleteDt IS NULL OR Hdr.DeleteDt = '') AND (Dtl.DeleteDt IS NULL OR Dtl.DeleteDt = '')
GO



select * from tWO1881_UsageList


---------------------------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1881_SalesUsage]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1881_SalesUsage]
GO

--Step02: Build tWO1881_SalesUsage from tWO1881_UsageList
--Less than 1 minute in DEV (1,254 rows affected)
SELECT	--CurPeriod,
	ISNULL(CurPeriod, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)) AS CurPeriod,
	ItemNo,
	COUNT(LineNumber) AS TotCount,
	SUM(QtyShipped) AS TotQty,
	SUM(NetUnitPrice * QtyShipped) AS TotDol,
	SUM(NetWght * QtyShipped) AS TotWght,
	SUM(UnitCost * QtyShipped) AS TotCostDol,
	'10' as OldUsageLoc,
	'09' as NewUsageLoc
INTO	tWO1881_SalesUsage
FROM	tWO1881_UsageList (NoLock)
WHERE	ExcludedFromUsageFlag <> 1
GROUP BY ISNULL(CurPeriod, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)), ItemNo
GO

----------------------------------------------------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1881_NRUsage]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1881_NRUsage]
GO

--Step03: Build tWO1881_NRUsage from tWO1881_UsageList
--Less than 1 minute in DEV (94 rows affected)
SELECT	--CurPeriod,
	ISNULL(CurPeriod, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)) AS CurPeriod,
	ItemNo,
	COUNT(LineNumber) AS TotCount,
	SUM(QtyShipped) AS TotQty,
	SUM(ExtendedPrice) AS TotDol,
	SUM(ExtendedNetWght) AS TotWght,
	SUM(ExtendedCost) AS TotCostDol,
	'10' as OldUsageLoc,
	'09' as NewUsageLoc
INTO	tWO1881_NRUsage
FROM	tWO1881_UsageList (NoLock)
WHERE	ExcludedFromUsageFlag = 1
GROUP BY ISNULL(CurPeriod, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)), ItemNo
GO


select * from ItemBranchUsage IBU
where exists (select * from tWO1881_NRUsage tIBU
			where	tIBU.CurPeriod = IBU.CurPeriodNo AND
				tIBU.ItemNo = IBU.ItemNo AND
				tIBU.NewUsageLoc = IBU.Location)
and exists 
(select * from tWO1881_NRUsage tIBU
			where	tIBU.CurPeriod = IBU.CurPeriodNo AND
				tIBU.ItemNo = IBU.ItemNo AND
				tIBU.OldUsageLoc = IBU.Location)
order by ItemNo, CurPeriodNo

select * from tWO1881_SalesUsage
where
(OldUsageLoc='10' and ItemNo='00050-3442-021' and CurPeriod='200907') or
(OldUsageLoc='10' and ItemNo='00110-2630-021' and CurPeriod='200905') or
(OldUsageLoc='10' and ItemNo='00200-2800-404' and CurPeriod='200909') or
(OldUsageLoc='10' and ItemNo='00631-1012-401' and CurPeriod='200906') or
(OldUsageLoc='10' and ItemNo='20056-1030-401' and CurPeriod='200908') or
(OldUsageLoc='09' and ItemNo='00050-3442-021' and CurPeriod='200907') or
(OldUsageLoc='09' and ItemNo='00110-2630-021' and CurPeriod='200905') or
(OldUsageLoc='09' and ItemNo='00200-2800-404' and CurPeriod='200909') or
(OldUsageLoc='09' and ItemNo='00631-1012-401' and CurPeriod='200906') or
(OldUsageLoc='09' and ItemNo='20056-1030-401' and CurPeriod='200908')
order by OldUsageLoc DESC, ItemNo, CurPeriod


select * from tWO1881_SalesUsage
where
(OldUsageLoc='10' and ItemNo='00110-2526-021' and CurPeriod='201003') or
(OldUsageLoc='10' and ItemNo='00400-0618-401' and CurPeriod='200807') or
(OldUsageLoc='09' and ItemNo='00110-2526-021' and CurPeriod='201003') or
(OldUsageLoc='09' and ItemNo='00400-0618-401' and CurPeriod='200807')
order by OldUsageLoc DESC, ItemNo, CurPeriod



select * from ItemBranchUsage
where
(Location='10' and ItemNo='00050-3442-021' and CurPeriodNo='200907') or
(Location='10' and ItemNo='00110-2630-021' and CurPeriodNo='200905') or
(Location='10' and ItemNo='00200-2800-404' and CurPeriodNo='200909') or
(Location='10' and ItemNo='00631-1012-401' and CurPeriodNo='200906') or
(Location='10' and ItemNo='20056-1030-401' and CurPeriodNo='200908') or
(Location='09' and ItemNo='00050-3442-021' and CurPeriodNo='200907') or
(Location='09' and ItemNo='00110-2630-021' and CurPeriodNo='200905') or
(Location='09' and ItemNo='00200-2800-404' and CurPeriodNo='200909') or
(Location='09' and ItemNo='00631-1012-401' and CurPeriodNo='200906') or
(Location='09' and ItemNo='20056-1030-401' and CurPeriodNo='200908')
order by Location DESC, ItemNo, CurPeriodNo


select * from ItemBranchUsage
where
(Location='10' and ItemNo='00110-2526-021' and CurPeriodNo='201003') or
(Location='10' and ItemNo='00400-0618-401' and CurPeriodNo='200807') or
(Location='09' and ItemNo='00110-2526-021' and CurPeriodNo='201003') or
(Location='09' and ItemNo='00400-0618-401' and CurPeriodNo='200807')
order by Location DESC, ItemNo, CurPeriodNo




select * from tWO1881_NRUsage
where
(OldUsageLoc='10' and ItemNo='00154-3222-000' and CurPeriod='201002') or
(OldUsageLoc='10' and ItemNo='00154-3225-000' and CurPeriod='200907') or
(OldUsageLoc='10' and ItemNo='00214-3200-050' and CurPeriod='200902') or
(OldUsageLoc='10' and ItemNo='00214-3200-050' and CurPeriod='200904') or
(OldUsageLoc='10' and ItemNo='00214-3200-050' and CurPeriod='200906') or

(OldUsageLoc='09' and ItemNo='00154-3222-000' and CurPeriod='201002') or
(OldUsageLoc='09' and ItemNo='00154-3225-000' and CurPeriod='200907') or
(OldUsageLoc='09' and ItemNo='00214-3200-050' and CurPeriod='200902') or
(OldUsageLoc='09' and ItemNo='00214-3200-050' and CurPeriod='200904') or
(OldUsageLoc='09' and ItemNo='00214-3200-050' and CurPeriod='200906')
order by OldUsageLoc DESC, ItemNo, CurPeriod


select * from ItemBranchUsage
where
(Location='10' and ItemNo='00154-3222-000' and CurPeriodNo='201002') or
(Location='10' and ItemNo='00154-3225-000' and CurPeriodNo='200907') or
(Location='10' and ItemNo='00214-3200-050' and CurPeriodNo='200902') or
(Location='10' and ItemNo='00214-3200-050' and CurPeriodNo='200904') or
(Location='10' and ItemNo='00214-3200-050' and CurPeriodNo='200906') or

(Location='09' and ItemNo='00154-3222-000' and CurPeriodNo='201002') or
(Location='09' and ItemNo='00154-3225-000' and CurPeriodNo='200907') or
(Location='09' and ItemNo='00214-3200-050' and CurPeriodNo='200902') or
(Location='09' and ItemNo='00214-3200-050' and CurPeriodNo='200904') or
(Location='09' and ItemNo='00214-3200-050' and CurPeriodNo='200906')
order by Location DESC, ItemNo, CurPeriodNo



select * from tWO1881_NRUsage

exec sp_columns ItemBranchUsage


select count(*) from ItemBranchUsage --1996932
select distinct Location, ItemNo, CurPeriodNo from ItemBranchUsage ---1996591



--------------------------------------------------------------------------------------------



select
Location,
ItemNo,
CurPeriodNo,
CurNoofSales,
CurSalesQty,
CurSalesDol,
CurSalesWght,
CurCostDol,
CurNRSalesQty,
EntryID,
EntryDt,
ChangeID,
ChangeDt,
CurNRNoSales,
CurNRSalesDol,
CurNRSalesWght,
CurNRCostDol
from ItemBranchUsage
where
(Location='10' and ItemNo='00050-3442-021' and CurPeriodNo='200907') or
(Location='10' and ItemNo='00110-2526-021' and CurPeriodNo='201003') or
(Location='10' and ItemNo='00110-2630-021' and CurPeriodNo='200905') or
(Location='10' and ItemNo='00152-3224-000' and CurPeriodNo='200810') or
(Location='10' and ItemNo='00154-3222-000' and CurPeriodNo='200906') or
(Location='10' and ItemNo='00154-3222-000' and CurPeriodNo='201002') or
(Location='10' and ItemNo='00154-3225-000' and CurPeriodNo='200907') or
(Location='10' and ItemNo='00154-3225-000' and CurPeriodNo='200911') or
(Location='10' and ItemNo='00200-2800-404' and CurPeriodNo='200909') or
(Location='10' and ItemNo='00214-3200-050' and CurPeriodNo='200902') or
(Location='10' and ItemNo='00214-3200-050' and CurPeriodNo='200904') or
(Location='10' and ItemNo='00214-3200-050' and CurPeriodNo='200906') or
(Location='10' and ItemNo='00400-0618-401' and CurPeriodNo='200807') or
(Location='10' and ItemNo='00631-1012-401' and CurPeriodNo='200906') or
(Location='10' and ItemNo='20056-1030-401' and CurPeriodNo='200908') or

(Location='09' and ItemNo='00050-3442-021' and CurPeriodNo='200907') or
(Location='09' and ItemNo='00110-2526-021' and CurPeriodNo='201003') or
(Location='09' and ItemNo='00110-2630-021' and CurPeriodNo='200905') or
(Location='09' and ItemNo='00152-3224-000' and CurPeriodNo='200810') or
(Location='09' and ItemNo='00154-3222-000' and CurPeriodNo='200906') or
(Location='09' and ItemNo='00154-3222-000' and CurPeriodNo='201002') or
(Location='09' and ItemNo='00154-3225-000' and CurPeriodNo='200907') or
(Location='09' and ItemNo='00154-3225-000' and CurPeriodNo='200911') or
(Location='09' and ItemNo='00200-2800-404' and CurPeriodNo='200909') or
(Location='09' and ItemNo='00214-3200-050' and CurPeriodNo='200902') or
(Location='09' and ItemNo='00214-3200-050' and CurPeriodNo='200904') or
(Location='09' and ItemNo='00214-3200-050' and CurPeriodNo='200906') or
(Location='09' and ItemNo='00400-0618-401' and CurPeriodNo='200807') or
(Location='09' and ItemNo='00631-1012-401' and CurPeriodNo='200906') or
(Location='09' and ItemNo='20056-1030-401' and CurPeriodNo='200908')
order by Location DESC, ItemNo, CurPeriodNo