
select	--distinct
	[No_], count(*) as itemcount 
	--UM.[Code] as PCLBFT
from	[Porteous$Item] Item (NOLOCK) inner join 
	[Porteous$Item Unit of Measure] UM (NOLOCK)
on	Item.[No_] = UM.[Item No_] and Item.[Qty__Base UOM] = UM.[Alt_ Base Qty_]
group by [No_]
order by count(*)


--170445 total records
select	[No_] as ItemNo, 
	UM.[Code] as PCLBFT,
	CASE WHEN UM.[Code] = 'LB'
		THEN UM.[Alt_ Base Qty_]
		ELSE UM.[Alt_ Base Qty_] / 100 * [Weight_100]
	END as NEW_NetWght,
	[Net Weight], 
	[Qty__Base UOM] as SellStkUMQty,
	UM.[Alt_ Base Qty_] as AltSellStkUMQty,
	[Weight_100],
	[Gross Weight]
from	[Porteous$Item] Item (NOLOCK) inner join 
	[Porteous$Item Unit of Measure] UM (NOLOCK)
on	Item.[No_] = UM.[Item No_] and Item.[Qty__Base UOM] = UM.[Alt_ Base Qty_]
order by [No_]
--where [No_] in ('00928-3420-040','00900-0804-040','00912-1004-040')


--SELECT	[Item No_], [Code] as UM, [Alt_ Base Qty_] as AltSellStkUMQty, *
--FROM	[Porteous$Item Unit of Measure]  (NOLOCK)



select [No_] as Item, [Qty__Base UOM], * from [Porteous$Item] (NOLOCK) where [No_] in ('00026-4061-961', '00019-2412-021','00170-0603-021','00762-0718-409','00020-3450-400')

select [Item No_], [Code] as UM, [Alt_ Base Qty_], [Sales Qty Alt_], [Purchase Qty Alt_], * from [Porteous$Item Unit of Measure]  (NOLOCK) where [Item No_] in ('00026-4061-961', '00019-2412-021','00170-0603-021','00762-0718-409','00020-3450-400')



select * from [Porteous$Item Unit of Measure]  (NOLOCK)
where [Sales Qty Alt_] <> 0 and [Purchase Qty Alt_] = 0


select distinct [Code] from [Porteous$Item Unit of Measure]  (NOLOCK)
where [Purchase Qty Alt_] <> 0 



select distinct [Purchase Qty Alt_] from [Porteous$Item Unit of Measure]  (NOLOCK)