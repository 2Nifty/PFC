if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO2268_NRUsage]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO2268_NRUsage]
GO

--Step05: Build Usage List (NR)
--Less than 1 minute in DEVPERP (1 rows affected)
SELECT	DISTINCT
		tUsageSum.*,
		tUsage.FromItem,
		tUsage.ToItem
INTO	tWO2268_NRUsage
FROM	tWO2268_UsageList tUsage (NoLock) INNER JOIN
		(SELECT	--CurPeriod,
				ISNULL(CurPeriod, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)) AS CurPeriod,
				ItemNo,
				UsageLoc,
				COUNT(LineNumber) AS TotCount,
				SUM(QtyShipped) AS TotQty,
				SUM(NetUnitPrice * QtyShipped) AS TotDol,
				SUM(NetWght * QtyShipped) AS TotWght,
				SUM(UnitCost * QtyShipped) AS TotCostDol
		 FROM	tWO2268_UsageList (NoLock)
		 WHERE	ExcludedFromUsageFlag = 1
		 GROUP BY ISNULL(CurPeriod, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)), ItemNo, UsageLoc) tUsageSum
ON		tUsage.FromItem = tUsageSum.ItemNo
GO

----------------------------------------------------------------

select * from tWO2268_NRUsage