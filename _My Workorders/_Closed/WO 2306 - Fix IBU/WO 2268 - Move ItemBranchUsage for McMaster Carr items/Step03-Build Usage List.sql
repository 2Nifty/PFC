if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO2268_UsageList]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO2268_UsageList]
GO

--Step03: Build tWO2268_UsageList from SOHistory
--About 2.5 minutes in DEVPERP (7,155 rows affected)
SELECT	Hdr.SellToCustNo,
		ISNULL(Hdr.UsageLoc, Dtl.IMLoc) AS UsageLoc,
		RIGHT(('0000' + Cast(Per.FiscalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalPeriod AS VARCHAR(2))),2) AS CurPeriod,
		RIGHT(('0000' + Cast(Per.FiscalCalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalCalMonth AS VARCHAR(2))),2) AS CurCalPeriod,
		tItems.FromItem,
		tItems.ToItem,
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
		Hdr.ARPostDt,
		Hdr.OrderNo,
		Hdr.InvoiceNo,
		Hdr.pSOHeaderHistID,
		Dtl.pSODetailHistID
--INTO	tWO2268_UsageList
FROM	tWO2268_McMasterCarrItems tItems (NoLock) INNER JOIN
		SODetailHist Dtl (NoLock)
ON		tItems.FromItem = Dtl.ItemNo INNER JOIN
		SOHeaderHist Hdr (NoLock)
ON		Hdr.pSOHeaderHistID = Dtl.fSOheaderHistID LEFT OUTER JOIN
		FiscalCalendar Per (NoLock)
ON		Hdr.ARPostDt = Per.CurrentDt
WHERE	Hdr.SellToCustNo <> '057461' AND Hdr.SubType <= 50 AND --Hdr.ArPostDt >= '2007-08-26' AND 
		(Hdr.DeleteDt IS NULL OR Hdr.DeleteDt = '') AND (Dtl.DeleteDt IS NULL OR Dtl.DeleteDt = '')
GO

----------------------------------------------------------------

select * from tWO2268_McMasterCarrItems
select * from tWO2268_UsageList


select 
		RIGHT(('0000' + Cast(Per.FiscalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalPeriod AS VARCHAR(2))),2) AS CurPeriod,
		RIGHT(('0000' + Cast(Per.FiscalCalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalCalMonth AS VARCHAR(2))),2) AS CurCalPeriod,

RIGHT(('0000' + Cast(Per.FiscalYear AS VARCHAR(4))),4) + RIGHT(('00' + CAST(Per.FiscalPeriod AS VARCHAR(2))),2) AS CurPeriodWO1836,

* from FiscalCalendar Per where CurrentDt='18-Nov-2010'






