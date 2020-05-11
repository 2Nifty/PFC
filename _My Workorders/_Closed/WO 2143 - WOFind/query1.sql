

SELECT	--*,
	POH.POOrderNo,	--varchar(20)
	POH.POType,	--varchar(20)
	POH.LocationCd,	--varchar(10)
	POD.ItemNo,
	POD.ItemDesc,
	POD.QtyOrdered,
	POD.BaseQtyUM,
	POH.SORefNo,	--numeric 10
	isnull(POH.ChangeID,POH.EntryID) AS UserId,	--varchar(50)
	POH.OrderDt,
	POH.PickSheetDt,
	POD.RequestedReceiptDt
FROM	POHeader POH (NoLock) INNER JOIN
	PODetail POD (NoLock)
ON	POH.pPOHeaderID = POD.fPOHeaderID
WHERE	POH.POType in  (SELECT	ListValue AS WOType
			FROM	ListMaster LM (NoLock) INNER JOIN
				ListDetail LD (NoLock)
			ON	LM.pListMasterID = LD.fListMasterID
			WHERE	ListName = 'WOOrderType')
and left(POH.POOrderNo,7)='WO09724'
--and isnull(POH.ChangeID,POH.EntryID) = 'tod m dixon - IT Dept'
--and isnull(POH.ChangeID,POH.EntryID) = 'tod' --'toms'
--and LocationCd='02'
--and MakeOrderDt is null and AllocationDt is null and POH.DeleteDt is null
--and BaseQtyUM='PC'

and POH.POOrderno='WO09745'
ORDER BY POH.POOrderNo



select * from POHeader
where POOrderno='WO09745'


exec sp_columns PODetail


update POHeader
--set MakeOrderDt=null, AllocationDt=null, DeleteDt=null, EntryID='tod', changeid='tod'
set MakeOrderDt=CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) , DeleteDt=CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) , CompleteDt=CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) , WIPDt=CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) , PickSheetDt=CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) , AllocationDt=CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME), EntryID='tod', changeid='tod'
--set OrderDt=CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) 
where POOrderNo='WO09724'

update POHeader set OrderDt=CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME) 
--select OrderDt, * from POHeader
where 
OrderDt >'2010-11-01' and 
isnull(ChangeID,EntryID) = 'toms' 


where POOrderno='WO09745'

update	POHeader
set	--SORefNo = 1276537	-- Orig
	SORefNo = 355576	-- REL
where	left(EntryID,3)='tod'


update	POHeader
set	POOrderNo='WO09745 - 12345',
	POType = 'WO - 12345',
	LocationCd = '02 - 12345',
	SORefNo = 1201366,
	EntryID='tod m dixon - IT Dept',
	ChangeID='tod m dixon - IT Dept',
	OrderDt = getdate(),
	PickSheetDt = getdate(),
	RequestedReceiptDt = getdate()
where	left(EntryID,3)='tod'

update PODetail
set	ItemDesc = '5/16-18 Finished Hex Nut NC ZB 123456789 123456789',
	QtyOrdered = -9999999.999,
	BaseQtyUM='PC BX',
	RequestedReceiptDt = getdate()
 where fPOHeaderID=9745

select SORefNo, LocationCd, * from POHeader where	left(EntryID,3)='tod'
select * from PODetail where fPOHeaderID=9745


exec sp_columns PODetail



select SQLRowWarn from SystemMaster where SystemMasterID='0'


update POHeader
set	MakeOrderDt = getdate(),
	AllocationDt = getdate(),
	PickSheetDt = getdate(),
	WipDt = getdate(),
	DeleteDt = null
where	pPOHeaderID = 9740


update POHeader
set	POType = 'WS'
where	POOrderNo='WO09744'





--03 (U)nallocated
--05 (A)llocated
--17 (W)arehouse
--02 (P)icked in WIP
--03 (C)omplete
--01 (D)elete
select	--POH.MakeOrderDt, POH.AllocationDt, POH.PickSheetDt, POH.WipDt, POH.CompleteDt, POH.DeleteDt,
	POH.POOrderNo,
	POH.POType,
	POH.LocationCd,
	POD.ItemNo,
	POD.ItemDesc,
	isnull(POD.QtyOrdered,0) AS QtyOrdered,
	POD.BaseQtyUM,
	POH.SORefNo,
	isnull(isnull(POH.ChangeID,POH.EntryID),'') AS UserId,
	POH.OrderDt,
	POH.PickSheetDt,
	POD.RequestedReceiptDt,
	POH.MakeOrderDt,
	POH.AllocationDt,
	POH.WIPDt,
	POH.CompleteDt,
	POH.DeleteDt
FROM	POHeader POH (NoLock) INNER JOIN
	PODetail POD (NoLock)
ON	POH.pPOHeaderID = POD.fPOHeaderID
Where
	POH.POType in  (SELECT	ListValue AS WOType
			FROM	ListMaster LM (NoLock) INNER JOIN
				ListDetail LD (NoLock)
			ON	LM.pListMasterID = LD.fListMasterID
			WHERE	ListName = 'WOOrderType') 
and isnull(OrderDt,'') <> ''
and LocationCd='02'
and isnull(POH.ChangeID,POH.EntryID) = 'toms'


and isnull(POH.MakeOrderDt,'') <> ''
and isnull(POH.AllocationDt,'') <> ''
and isnull(POH.PickSheetDt,'') <> ''
and isnull(POH.WIPDt,'') = ''
and isnull(POH.CompleteDt,'') = ''
and isnull(POH.DeleteDt,'') = ''






select min(OrderDt), max(OrderDt) from POHeader
Where
	POType in  (SELECT	ListValue AS WOType
			FROM	ListMaster LM (NoLock) INNER JOIN
				ListDetail LD (NoLock)
			ON	LM.pListMasterID = LD.fListMasterID
			WHERE	ListName = 'WOOrderType') 