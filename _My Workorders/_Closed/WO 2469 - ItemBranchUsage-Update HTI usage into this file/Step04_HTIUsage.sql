
--41,139 distinct Loc/Item
select distinct HTILOC, HTIITEM from tWO2469_HTI2009


--37,313 distinct Loc/Item
select distinct HTILOC, HTIITEM  from tWO2469_HTI2010



select * from tWO2469_HTI2009
select * from tWO2469_HTI2010


--48,977 unique/distinct Loc/Item between 2009/2010





--------------------------------------------------------------------------------------------


SELECT
--[2009].HTILOC as loc09, [2009].HTIItem as Item09,
--[2010].HTILOC as loc10, [2010].HTIItem as Item10,

	isnull([2009].HTILoc,[2010].HTILoc) as HTILoc,
	isnull([2009].HTIItem,[2010].HTIItem) as HTIItem,
	isnull([2009].HTIItemDesc,[2010].HTIItemDesc) as HTIDesc,
	isnull([2009].HTIPack,[2010].HTIPack) as HTIPack,

	isnull([2009].PFCItem,[2010].PFCItem) as PFCItem,
	isnull([2009].PFCItemNetWght,[2010].PFCItemNetWght) as PFCItemNetWght,
	isnull([2009].PFCItemFlg,[2010].PFCItemFlg) as PFCItemFlg,

	isnull([2009].AltItem,[2010].AltItem) as AltItem,
	isnull([2009].AltItemNetWght,[2010].AltItemNetWght) as AltItemNetWght,
	isnull([2009].AltItemFlg,[2010].AltItemFlg) as AltItemFlg,

--isnull([2009].HTISalesDol,0) as slsdol09,
--isnull([2010].HTISalesDol,0) as slsdol10,
--isnull([2009].HTICartonQty,0) as qty09,
--isnull([2010].HTICartonQty,0) as qty10,

	CASE WHEN isnull([2009].HTICartonQty,0) > isnull([2010].HTICartonQty,0)
	     THEN isnull([2009].HTISalesDol,0)
	     ELSE isnull([2010].HTISalesDol,0)
	END as HTISalesDol,

	CASE WHEN isnull([2009].HTICartonQty,0) > isnull([2010].HTICartonQty,0)
	     THEN isnull([2009].HTICartonQty,0)
	     ELSE isnull([2010].HTICartonQty,0)
	END as HTICartonQty,

	CASE WHEN isnull([2009].HTICartonQty,0) > isnull([2010].HTICartonQty,0)
	     THEN isnull([2009].HTICostDol,0)
	     ELSE isnull([2010].HTICostDol,0)
	END as HTICostDol,

--	CASE WHEN isnull([2009].HTICartonQty,0) > isnull([2010].HTICartonQty,0)
--	     THEN isnull([2009].HTISalesDol,0) / 52
--	     ELSE isnull([2010].HTISalesDol,0) / 52
--	END as HTIWkSalesDol,

--	CASE WHEN isnull([2009].HTICartonQty,0) > isnull([2010].HTICartonQty,0)
--	     THEN isnull([2009].HTICartonQty,0) / 52
--	     ELSE isnull([2010].HTICartonQty,0) / 52
--	END as HTIWkCartonQty,

--	CASE WHEN isnull([2009].HTICartonQty,0) > isnull([2010].HTICartonQty,0)
--	     THEN isnull([2009].HTICostDol,0) / 52
--	     ELSE isnull([2010].HTICostDol,0) / 52
--	END as HTIWkCostDol,

	CASE WHEN isnull([2009].HTICartonQty,0) > isnull([2010].HTICartonQty,0)
	     THEN '2009'
	     ELSE '2010'
	END as HTIUsageYear
FROM	tWO2469_HTI2009 [2009] (nolock) full outer join
	tWO2469_HTI2010 [2010] (nolock)
ON	[2009].HTILoc = [2010].HTILoc and [2009].HTIItem = [2010].HTIItem
WHERE	isnull((isnull([2009].HTILoc,[2010].HTILoc)),'') <> '' AND isnull((isnull([2009].HTIItem,[2010].HTIItem)),'') <> '' 



--------------------------------------------------------------------------------------------