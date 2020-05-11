select * from tWO2469_HTIUsage




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO2469_HTI_IBU]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO2469_HTI_IBU]
GO

CREATE TABLE [dbo].[tWO2469_HTI_IBU] (
	[Location] [varchar] (10) NULL ,
	[ItemNo] [nvarchar] (255) NULL ,
	[Period] [varchar] (6) NULL ,
	[NoOfSales] [float] NULL ,
	[SalesQty] [float] NULL ,
	[SalesDol] [money] NULL ,
	[SalesWght] [float] NULL ,
	[CostDol] [money] NULL 
) ON [PRIMARY]
GO


--Load tWO2469_HTI_IBU
--ValidAlt
INSERT
INTO	tWO2469_HTI_IBU
	(Location,
	 ItemNo,
	 Period,
	 NoOfSales,
	 SalesQty,
	 SalesDol,
	 SalesWght,
	 CostDol)


--------------------------------------------------------------------------------------------------------------------

--HTI PFC ITEM (1??): Build IBU Update records for 100% Cateogries
SELECT	Usage.Location,
	Usage.ItemNo,
	Per.Period,
	ceiling(isnull(Usage.WkNoOfSales,0) * isnull(Weeks,4)) as NoOfSales,

	isnull(Usage.WkSalesQty,0) * isnull(Weeks,4) as SalesQty,
	ceiling(isnull(Usage.WkSalesQty,0) * isnull(Weeks,4)) as ceilingSalesQty,
	ROUND(isnull(Usage.WkSalesQty,0) * isnull(Weeks,4),0) as roundSalesQty,

	ROUND((isnull(Usage.WkSalesDol,0) * isnull(Weeks,4)),2) as SalesDol,
	ROUND(((ceiling(isnull(Usage.WkSalesQty,0) * isnull(Weeks,4))) * Usage.NetWght),3) as SalesWght,
	ROUND((isnull(Usage.WkCostDol,0) * isnull(Weeks,4)),2) as CostDol
FROM	(--Per
	 SELECT	Period, count(*) as Weeks
	 FROM	(SELECT	DISTINCT
			FiscalCalYear * 100 + FiscalCalMonth as Period,
			FiscalWeekNo as WeekNo
		FROM	FiscalCalendar
		WHERE	FiscalCalYear * 100 + FiscalCalMonth >= 201004 AND 
			FiscalCalYear * 100 + FiscalCalMonth <= 201103) tmp
	 GROUP BY Period
	)Per,
	(--Usage
	 SELECT	HTILoc as Location,
		PFCItem as ItemNo,
		(isnull(HTICartonQty,0)) / 52 as WkNoOfSales,
		(isnull(HTICartonQty,0)) / 52 as WkSalesQty,
		(isnull(HTISalesDol,0)) / 52 as WkSalesDol,
		isnull(PFCItemNetWght,0) as NetWght,
		(isnull(HTICostDol,0)) / 52 as WkCostDol
	--3757 total items
	--select distinct PFCItem
	 FROM	tWO2469_HTIUsage
	 WHERE	PFCItemFlg = 'Y' AND AltItemFlg = 'N' AND
	--2868 @ 100%
		left(PFCItem,5) <> '00086' and left(PFCItem,5) <> '00086' and 
		left(PFCItem,5) <> '00153' and left(PFCItem,5)<> '00690' and
		(left(PFCItem,5) not between '00900' and '00972') and
		(left(PFCItem,5) not between '20056' and '20972')
	)Usage
Go



--------------------------------------------------------------------------------------------------------------------

--exec sp_columns tWO2469_HTIUsage
--select * from tWO2469_HTIUsage
--select * from tWO2469_HTI_IBU


	--889 @ 60%
		(left(PFCItem,5) = '00086' or left(PFCItem,5) = '00086' or 
		left(PFCItem,5) = '00153' or left(PFCItem,5) = '00690' or
		(left(PFCItem,5) between '00900' and '00972') or
		(left(PFCItem,5) between '20056' and '20972'))


	--2868 @ 100%
		left(PFCItem,5) <> '00086' and left(PFCItem,5) <> '00086' and 
		left(PFCItem,5) <> '00153' and left(PFCItem,5)<> '00690' and
		(left(PFCItem,5) not between '00900' and '00972') and
		(left(PFCItem,5) not between '20056' and '20972')


	 SELECT	HTILoc as Location,
		AltItem as ItemNo,
		isnull(HTICartonQty,0) as NoOfSales,
		isnull(HTICartonQty,0) as SalesQty,
		isnull(HTISalesDol,0) as SalesDol,
		isnull(HTICartonQty,0) * isnull(AltItemNetWght,0) as NetWght,
		isnull(HTICostDol,0) as CostDol





--5357 total items
select --distinct AltItem
	sum(isnull(HTISalesDol,0)) as SalesDol,
	sum(isnull(HTICostDol,0)) as CostDol,
	sum(isnull(HTICartonQty,0)) as CartonQty

--	sum(isnull(HTISalesDol,0)) * 0.6 as SalesDol,
--	sum(isnull(HTICostDol,0)) * 0.6 as CostDol,
--	sum(isnull(HTICartonQty,0)) * 0.6 as CartonQty

	 FROM	tWO2469_HTIUsage
	 WHERE	AltItemFlg='Y' AND
		--(PFCItemFlg = 'Y' AND AltItemFlg = 'N') and
--937 @ 60%
--		(left(AltItem,5) = '00086' or left(AltItem,5) = '00086' or 
--		left(AltItem,5) = '00153' or left(AltItem,5) = '00690' or
--		(left(AltItem,5) between '00900' and '00972') or
--		(left(AltItem,5) between '20056' and '20972'))
--4420 @ 100%
		left(AltItem,5) <> '00086' and left(AltItem,5) <> '00086' and 
		left(AltItem,5) <> '00153' and left(AltItem,5)<> '00690' and
		(left(AltItem,5) not between '00900' and '00972') and
		(left(AltItem,5) not between '20056' and '20972')




select	sum(isnull(NoOfSales,0)) as NoOfSales,
	sum(isnull(SalesQty,0)) as SalesQty,
	sum(isnull(SalesDol,0)) as SalesDol,
	sum(isnull(CostDol,0)) as CostDol

from tWO2469_HTI_IBU


select *
from tWO2469_HTIUsage
WHERE	(PFCItemFlg = 'Y' AND AltItemFlg = 'N') or AltItemFlg='Y'


select * from tWO2469_HTI_IBU



