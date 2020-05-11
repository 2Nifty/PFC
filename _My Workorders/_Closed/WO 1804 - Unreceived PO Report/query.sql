drop table tWO1804_UnrcvdPO

--truncate table tWO1804_UnrcvdPO

SELECT	LD.ListValue as Category,
	LD.ListDtlDesc as CatDesc,
--	LEFT((LD.ListDtlDesc + '123456789 123456789 123456789 123456789 1234567890'),50) AS CatDesc,
	POD.ItemNo,
	IM.ItemSize,
--	LEFT((IM.ItemSize + '123456789 123456789 123456789 123456789 1234567890'),30) AS ItemSize,
	POH.POOrderNo as DocNo,
	--Need to add Bruce's Status Code field to POD and populate when DTS is run
	--POD.POStatusCd as POStatus,
	'st' as POStatus,
	VM.Code,
	ReceivingLocation as Brn,
	isnull(POD.SuperEquivQty,0) as QtySuperEquiv,
	POD.QtyOrdered,
	POD.QtyReceived,
	POD.RequestedReceiptDt as DateRequested,
	--'Need to add POD.PlannedReceiptDt to POD and to WO1245_LoadPO dts read NV' as DatePlanned
	--POD.PlannedReceiptDt,
	CAST('12/12/12' as DateTime) as PlannedReceiptDt,
	POD.LastSchdReceiptDt as DateExpected,
	POD.QtyOrdered - POD.QtyReceived as QtyDue,
	-- Need to add transformation to PO DTS that fills in AlternateCost with cost per alternate
	--POD.AlternateCost as CostPerAlt,
	POD.ExtendedCost as CostPerAlt,
	POD.CostUM,
	POD.ExtendedCost

into tWO1804_UnrcvdPO

FROM	POHeader POH (NoLock) INNER JOIN
	PODetail POD (NoLock)
ON	POH.pPOHeaderID = POD.fPOHeaderID INNER JOIN
	ItemMaster IM (NoLock)
ON	IM.ItemNo = POD.ItemNo INNER JOIN
	VendorMaster VM (NoLock)
ON	VM.VendNo = POH.BuyFromVendorNo INNER JOIN
	ListDetail LD (NoLock)
ON	LEFT(POD.ItemNo,5) = LD.ListValue INNER JOIN
	ListMaster LM (NoLock)
ON	LD.fListMasterID = LM.pListMasterID
WHERE	LM.ListName ='CategoryDesc' AND (POH.POSubType between '1' and '4') AND (POD.QtyOrdered - POD.QtyReceived > 0)


update	tWO1804_UnrcvdPO
set	CatDesc = REPLACE ( CatDesc , '  ' , ' ' ),
	ItemSize = REPLACE ( ItemSize , '  ' , ' ' )




update tWO1804_UnrcvdPO
set	CatDesc = LEFT((CatDesc + ' 23456789 123456789 123456789 123456789 1234567890'),50),
	ItemSize = LEFT((ItemSize + ' 23456789 123456789 123456789 123456789 1234567890'),30),
	DocNo = left((DocNo + ' xx xx xx'),10)

update tWO1804_UnrcvdPO
set	--QtySuperEquiv = 9999,
	--QtyOrdered = 9999,
	Qtyreceived = 0,
	--QtyDue = 9999,
	--CostPerAlt = 99999,
	ExtendedCost = 1

select * from tWO1804_UnrcvdPO --where Category='00020' and Category='00020'

exec sp_columns  tWO1804_UnrcvdPO

select * from ItemMaster


exec sp_columns ItemMaster

select max(len(ItemSize)) from ItemMaster



update tWO1804_UnrcvdPO
set	CatDesc = LEFT((CatDesc + '123456789 123456789 123456789 123456789 1234567890'),50),
	ItemSize = LEFT((ItemSize + '123456789 123456789 123456789 123456789 1234567890'),30)


'123456789 123456789 123456789 123456789 1234567890'



exec sp_columns PODetail





update	PODetail
set	POStatusCd = NV.[PO Status Code],
	PlannedRcptDt = NV.[Planned Receipt Date],
	AlternateCost = NV.[Alt_ Price]
from	PODetail POD inner join
	POHeader POH
on	POH.pPOHeaderID = POD.fPOHeaderID inner join
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLIVE.dbo.[Porteous$Purchase Line] NV
on	POH.POOrderNo=NV.[Document No_] and POD.POLineNo = NV.[Line No_]







select * from POHeader where POType='WO'




exec pPORptUnRcvd


	NVLINE.[Alt_ Price] as AlternateCost,

	NVLINE.[PO Status Code] as POStatusCd,
	NVLINE.[Planned Receipt Date] as PlannedRcptDt