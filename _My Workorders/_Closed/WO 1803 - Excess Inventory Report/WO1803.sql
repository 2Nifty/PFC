select top 1000 * from CPR_Daily
select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.LocMaster
exec sp_columns CPR_Daily
exec sp_columns ItemMaster


select * from InventoryRptExcess order by itemNo, Branch

select * from InventoryRptExcess --where ExcessQty >= 4.9
order by itemNo, Branch

update InventoryRptExcess
set AvailableQty=9999999

update	InventoryRptExcess
set	ItemSize = replace(ItemSize,'  ','x '),
	[Description] = replace(Description,'  ',' x')


update	InventoryRptExcess
set	ItemSize = left(ItemSize+' ABCDEFGHIJ KLMNOPQRST UVWXYZ8',30),
	[Description] = left(Description+' ABCDEFGHIJ KLMNOPQRST UVWXYZ 88888 8888 8888 8888',50)



SELECT	'BULK' AS RecordType,
	CPR.LocationCode AS Branch,
	CPR.ItemNo,
	Item.ItemSize AS ItemSize,
	CPR.[Description],
	CPR.UOM,
	CPR.Avail_Qty AS AvailableQty,
	CPR.SupEqv_Qty AS SuperEquivQty,
	CPR.ROP_NV AS ReOrderPoint,
	CPR.Avail_Qty - (CPR.ROP_NV * 2) AS ExcessQty,
--	CPR.Net_Wgt,
	(CPR.Avail_Qty - (CPR.ROP_NV * 2)) * CPR.Net_Wgt AS ExcessWght,
	'WO1803' AS EntryID,
	GetDate() AS EntryDt

into tWO1803ExcessInventory

FROM	CPR_Daily CPR INNER JOIN
	ItemMaster Item
ON	CPR.ItemNo = Item.ItemNo
WHERE	CPR.ROP_NV is not null AND
	SUBSTRING(CPR.ItemNo,12,1) IN ('0','1','5') AND
	CPR.Avail_Qty - (CPR.ROP_NV * 2) > 0


--	LocationCode IN (SELECT LocId FROM OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.LocMaster)



SELECT	'PKG' AS RecordType,
	CPR.LocationCode AS Branch,
	CPR.ItemNo,
	Item.ItemSize AS ItemSize,
	CPR.[Description],
	CPR.UOM,
	CPR.Avail_Qty AS AvailableQty,
	CPR.SupEqv_Qty AS SuperEquivQty,
	CPR.ROP_NV AS ReOrderPoint,
	(CPR.Avail_Qty - (CPR.ROP_NV * 2)) - (CPR.SupEqv_Qty * 2) AS ExcessQty,
--	CPR.Net_Wgt,
	((CPR.Avail_Qty - (CPR.ROP_NV * 2)) - (CPR.SupEqv_Qty * 2)) * CPR.Net_Wgt AS ExcessWght,
	'WO1803' AS EntryID,
	GetDate() AS EntryDt
FROM	CPR_Daily CPR INNER JOIN
	ItemMaster Item
ON	CPR.ItemNo = Item.ItemNo
WHERE	CPR.ROP_NV is not null AND
	SUBSTRING(CPR.ItemNo,12,1) NOT IN ('0','1','5') AND
	(CPR.Avail_Qty - (CPR.ROP_NV * 2)) - (CPR.SupEqv_Qty * 2) > 0




--	LocationCode IN (SELECT LocId FROM OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.LocMaster)



---------------------------------------------------

select * from ItemMaster

select * from ItemBranch where Location=15


select * from ItemBranchUsage


select	*
from	ItemBranchUsage
where	Location = '15' and ItemNo='00050-3042-020'
order by CurPeriodNo


select * from tWO1803ExcessInventory
where	Location = '15' and ItemNo='00050-3042-020'

------------------------------------------------


drop table tWO1803ExcessInventory

SELECT	'???' AS RecordType,
	IB.Location,
	IM.ItemNo,
	IM.ItemSize,
	IM.CatDesc,
	IM.SellStkUm,
	0 AS AvailQty,
	IB.SuperEquivQty,
	IB.ReOrderPoint,
	0 AS ExcessQty,
	0 AS ExcessWght,
	'WO1803' AS EntryID,
	GetDate() AS EntryDt
INTO	tWO1803ExcessInventory
FROM	ItemMaster IM INNER JOIN
	ItemBranch IB
ON	IM.pItemMasterID = IB.fItemMasterID





select * from tWO1803ExcessInventory



UPDATE	tWO1803ExcessInventory
SET	AvailQty = isnull(IBU.CurBegOnHandQty,0) -- + CurReceivedQty + CurReturnQty - CurBackOrderQty - CurSalesQty - CurTransferQty - CurIssuesQty - CurAdjustQty - CurChangeQty + CurPOQty
FROM	ItemBranchUsage IBU INNER JOIN
	(SELECT	Location, ItemNo, MAX(CurPeriodNo) AS MaxPeriodNo
	 FROM	ItemBranchUsage
	 GROUP BY Location, ItemNo) MaxIBU
ON	IBU.Location = MaxIBU.Location AND
	IBU.ItemNo = MaxIBU.ItemNo
WHERE	IBU.Location = tWO1803ExcessInventory.Location AND
	IBU.ItemNo = tWO1803ExcessInventory.ItemNo AND
	IBU.CurPeriodNo = MaxIBu.MaxPeriodNo




select * from CPR_Daily


exec sp_columns ItembranchUsage


select	*
from	ItemBranchUsage
where	Location = '15' and ItemNo='00050-3042-020'
order by CurPeriodNo