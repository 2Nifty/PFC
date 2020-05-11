
--27514 = 18634 + 8880
select * FROM tWO2469_HTI2009
where PFCItemFlg = 'Y' or AltItemFlg = 'Y' 
--where AltItemFlg='Y'
--where (PFCItemFlg = 'Y' AND AltItemFlg = 'N') 



--8880
SELECT	HTILoc as Location,
	PFCItem as ItemNo,
	sum(isnull(HTISalesDol,0)) as SalesDol,
	sum(isnull(HTICartonQty,0)) as CartonQty,
	sum(isnull(HTICostDol,0)) as CostDol
FROM	tWO2469_HTI2009
WHERE	(PFCItemFlg = 'Y' AND AltItemFlg = 'N')
GROUP BY HTILoc, PFCItem


--18634
SELECT	HTILoc as Location,
	AltItem as ItemNo,
	sum(isnull(HTISalesDol,0)) as SalesDol,
	sum(isnull(HTICartonQty,0)) as CartonQty,
	sum(isnull(HTICostDol,0)) as CostDol
FROM	tWO2469_HTI2009
WHERE	AltItemFlg='Y'
GROUP BY HTILoc, AltItem






--8880
SELECT	HTILoc as Location,
	PFCItem as ItemNo,
	HTISalesDol,
	HTICartonQty,
	HTICostDol
--	sum(isnull(HTISalesDol,0)) as SalesDol,
--	sum(isnull(HTICartonQty,0)) as CartonQty,
--	sum(isnull(HTICostDol,0)) as CostDol
INTO	#tPFCItem
FROM	tWO2469_HTI2009
WHERE	(PFCItemFlg = 'Y' AND AltItemFlg = 'N')


--18634
SELECT	HTILoc as Location,
	AltItem as ItemNo,
	HTISalesDol,
	HTICartonQty,
	HTICostDol
--	sum(isnull(HTISalesDol,0)) as SalesDol,
--	sum(isnull(HTICartonQty,0)) as CartonQty,
--	sum(isnull(HTICostDol,0)) as CostDol
INTO	#tAltItem
FROM	tWO2469_HTI2009
WHERE	AltItemFlg='Y'


SELECT	Location,
	ItemNo,
	sum(isnull(HTISalesDol,0)) as SalesDol,
	sum(isnull(HTICartonQty,0)) as CartonQty,
	sum(isnull(HTICostDol,0)) as CostDol
FROM
(
SELECT	*
FROM	#tPFCItem

UNION

SELECT	*
FROM	#tAltItem
) tmp
GROUP BY Location, ItemNo






SELECT	Location,
	ItemNo,
	sum(isnull(HTISalesDol,0)) as SalesDol,
	sum(isnull(HTICartonQty,0)) as CartonQty,
	sum(isnull(HTICostDol,0)) as CostDol
FROM
(
--8880
SELECT	HTILoc as Location,
	PFCItem as ItemNo,
	HTISalesDol,
	HTICartonQty,
	HTICostDol
FROM	tWO2469_HTI2009
WHERE	PFCItemFlg = 'Y' AND AltItemFlg = 'N'

UNION

--18634
SELECT	HTILoc as Location,
	AltItem as ItemNo,
	HTISalesDol,
	HTICartonQty,
	HTICostDol
FROM	tWO2469_HTI2009
WHERE	AltItemFlg='Y'
) tmp
GROUP BY Location, ItemNo









select * from tWO2469_HTIUsage


--select * from tWO2469_HTI2009
select * from tWO2469_HTI2009Summ

--select * from tWO2469_HTI2010
select * from tWO2469_HTI2010Summ






SELECT
	isnull([2009].Location,[2010].Location) as Location,
	isnull([2009].ItemNo,[2010].ItemNo) as ItemNo,

	CASE WHEN isnull([2009].CartonQty,0) > isnull([2010].CartonQty,0)
	     THEN isnull([2009].SalesDol,0)
	     ELSE isnull([2010].SalesDol,0)
	END as SalesDol,

	CASE WHEN isnull([2009].CartonQty,0) > isnull([2010].CartonQty,0)
	     THEN isnull([2009].CartonQty,0)
	     ELSE isnull([2010].CartonQty,0)
	END as CartonQty,

	CASE WHEN isnull([2009].CartonQty,0) > isnull([2010].CartonQty,0)
	     THEN isnull([2009].CostDol,0)
	     ELSE isnull([2010].CostDol,0)
	END as CostDol,

	CASE WHEN isnull([2009].CartonQty,0) > isnull([2010].CartonQty,0)
	     THEN '2009'
	     ELSE '2010'
	END as UsageYear
FROM	tWO2469_HTI2009Summ [2009] (nolock) full outer join
	tWO2469_HTI2010Summ [2010] (nolock)
ON	[2009].Location = [2010].Location and [2009].ItemNo = [2010].ItemNo
WHERE	isnull((isnull([2009].Location,[2010].Location)),'') <> '' AND isnull((isnull([2009].ItemNo,[2010].ItemNo)),'') <> '' 




select *
--	distinct ItemNo 
from tWO2469_HTIUsage
where HTICartonQty = CartonQty



UPDATE	tWO2469_HTIUsage
SET	SalesDol = SalesDol * 0.60,
	CartonQty = CartonQty * 0.60,
	CostDol = CostDol * 0.60
WHERE	left(ItemNo,5) <> '00086' and left(ItemNo,5) <> '00086' and 
	left(ItemNo,5) <> '00153' and left(ItemNo,5)<> '00690' and
	(left(ItemNo,5) not between '00900' and '00972') and
	(left(ItemNo,5) not between '20056' and '20972')



select * from tWO2469_HTI_IBU


-------------------------------------------------------------------------------------------------------------------------




--27174 = 18141 + 9033
select * FROM tWO2469_HTI2010
--where PFCItemFlg = 'Y' or AltItemFlg = 'Y' 
--where AltItemFlg='Y'
where (PFCItemFlg = 'Y' AND AltItemFlg = 'N') 

--9033
SELECT	HTILoc as Location,
	PFCItem as ItemNo,
	PFCItemNetWght as NetWght,
	sum(isnull(HTISalesDol,0)) as SalesDol,
	sum(isnull(HTICartonQty,0)) as CartonQty,
	sum(isnull(HTICostDol,0)) as CostDol
FROM	tWO2469_HTI2010
WHERE	(PFCItemFlg = 'Y' AND AltItemFlg = 'N')
GROUP BY HTILoc, PFCItem, PFCItemNetWght


--18141
SELECT	HTILoc as Location,
	AltItem as ItemNo,
	AltItemNetWght as NetWght,
	sum(isnull(HTISalesDol,0)) as SalesDol,
	sum(isnull(HTICartonQty,0)) as CartonQty,
	sum(isnull(HTICostDol,0)) as CostDol
FROM	tWO2469_HTI2010
WHERE	AltItemFlg='Y'
GROUP BY HTILoc, AltItem, AltItemNetWght



select * from tWO2469_HTI2009
where PFCItem='00086-2410-040' or AltItem='00086-2410-040'


select * from tWO2469_HTI2010
where PFCItem='00086-2410-040' or AltItem='00086-2410-040'


select * from tWO2469_HTIUsage
where PFCItem='00086-2410-040' or AltItem='00086-2410-040'


--------------
-- HTIUsage --
--------------
------------------------------------------------------------------------------
--ALT PFC ITEM: Build IBU Update records for 100% Cateogries
select
	distinct HTILoc, AltItem, HTICartonQty

	 FROM	tWO2469_HTIUsage
	 WHERE	AltItemFlg='Y' AND HTICartonQty < 12 AND
--937 @ 100%
		(left(AltItem,5) = '00086' or left(AltItem,5) = '00086' or 
		left(AltItem,5) = '00153' or left(AltItem,5) = '00690' or
		(left(AltItem,5) between '00900' and '00972') or
		(left(AltItem,5) between '20056' and '20972'))

------------------------------------------------------------------------------
--ALT PFC ITEM: Build IBU Update records for 60% Cateogries
select
	distinct HTILoc, AltItem, HTICartonQty, HTICartonQty * .6 as [60%]

	 FROM	tWO2469_HTIUsage
	 WHERE	AltItemFlg='Y' AND HTICartonQty < 20 AND
--4420 @ 60%
		left(AltItem,5) <> '00086' and left(AltItem,5) <> '00086' and 
		left(AltItem,5) <> '00153' and left(AltItem,5)<> '00690' and
		(left(AltItem,5) not between '00900' and '00972') and
		(left(AltItem,5) not between '20056' and '20972')

------------------------------------------------------------------------------

------------------------------------------------------------------------------
--HTI PFC ITEM (1??): Build IBU Update records for 100% Cateogries
select
	distinct HTILoc, PFCItem, HTICartonQty

	 FROM	tWO2469_HTIUsage
	 WHERE	(PFCItemFlg = 'Y' AND AltItemFlg = 'N') and HTICartonQty < 12 AND
--889 @ 100%
		(left(PFCItem,5) = '00086' or left(PFCItem,5) = '00086' or 
		left(PFCItem,5) = '00153' or left(PFCItem,5) = '00690' or
		(left(PFCItem,5) between '00900' and '00972') or
		(left(PFCItem,5) between '20056' and '20972'))

------------------------------------------------------------------------------
--ALT PFC ITEM: Build IBU Update records for 60% Cateogries
select
	distinct HTILoc, PFCItem, HTICartonQty, HTICartonQty * .6 as [60%]

	 FROM	tWO2469_HTIUsage
	 WHERE	(PFCItemFlg = 'Y' AND AltItemFlg = 'N') and HTICartonQty < 20 AND
--2868 @ 60%
		left(PFCItem,5) <> '00086' and left(PFCItem,5) <> '00086' and 
		left(PFCItem,5) <> '00153' and left(PFCItem,5)<> '00690' and
		(left(PFCItem,5) not between '00900' and '00972') and
		(left(PFCItem,5) not between '20056' and '20972')

------------------------------------------------------------------------------











select * from tWO2469_HTI_IBU
where SalesWght <1

exec sp_columns ItemMaster

UPDATE	tWO2469_HTI_IBU
SET	SalesWght = SalesQty + IM.Wght
FROM	ItemMaster IM
WHERE	tWO2469_HTI_IBU.ItemNo = IM.ItemNo



