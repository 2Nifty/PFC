select distinct (changedt) from LocMaster


select changedt, changeid, * from LocMaster order by locid


update LocMaster
set	changeid='test'
where locid=20



select ShiptoPhoneNo, LocationCd, * from POHeader

--UPDATE ShipToPhoneNo
UPDATE	POHeader
SET	ShipToPhoneNo = LM.LocPhone
FROM	LocMaster LM (NoLock)
WHERE	POHeader.LocationCd = LM.LocID




select * from Tables where tabletype='FGHT'


SELECT	TableCd as FghtCd,
	--Dsc as FghtDesc,
	ShortDsc as FghtDesc
FROM	Tables
WHERE	TableType='FGHT'


select * from tFghtTable


select 

select * from tVendAddr

-- UPDATE ShipToPhoneNo, BuyFromVendorID, VendorAlphaCd, ShipMethodCd, ShipMethodName, PayToEmailAddress & PayToFaxNo


------------------------------------------------------------------------
-- UPDATE ShipToPhoneNo, BuyFromVendorID, VendorAlphaCd,
--	  ShipMethodCd, ShipMethodName, PayToEmailAddress & PayToFaxNo
------------------------------------------------------------------------

--UPDATE ShipToPhoneNo
UPDATE	POHeader
SET	ShipToPhoneNo = LM.LocPhone
FROM	LocMaster LM (NoLock)
WHERE	POHeader.LocationCd = LM.LocID
go

--UPDATE BuyFromVendorID, VendorAlphaCd, ShipMethodCd & ShipMethodName
UPDATE	POHeader
SET	BuyFromVendorID = tVA.pVendMstrID,
	VendorAlphaCd = tVA.AlphaSearch,
	ShipMethodCd = tVA.ShipMethCd,
	ShipMethodName = tVA.ShipMethDsc
FROM	tVendAddr tVA (NoLock)
WHERE	POHeader.BuyFromVendorNo = tVA.VendNo
go

--UPDATE PayToEmailAddress & PayToFaxNo
UPDATE	POHeader
SET	PayToEmailAddress = tVA.EMail,
	PayToFaxNo = tVA.FaxPhoneNo
FROM	tVendAddr tVA (NoLock)
WHERE	POHeader.PayToVendorNo = tVA.VendNo
go





select PayToVendorNo from POHeader




-- 65749 ALL
-- 22780 OPEN

--[Porteous$Purchase Line]
SELECT
	POHeader.pPOHeaderID as fPOHeaderID,
	NVLINE.[Document No_] as POOrderNo,
	NVLINE.[Line No_] as POLineNo,
	CASE WHEN ROUND(isnull(NVLINE.[Quantity],0),0,1) - ROUND(isnull(NVLINE.[Quantity Received],0),0,1) <= 0
		THEN 'Y'
		ELSE 'N'
	END AS CompleteInd,
	CASE WHEN ROUND(isnull(NVLINE.[Quantity],0),0,1) - ROUND(isnull(NVLINE.[Quantity Received],0),0,1) <= 0
		THEN NVLine.[Expected Receipt Date]
		else null
	END AS CompleteDt,
	NVLINE.[Expected Receipt Date] as LastSchdReceiptDt,
	NVLINE.[Promised Receipt Date] as PromiseDt,
	NVLINE.[Location Code] as ReceivingLocation,
	ROUND(isnull(NVLINE.[Quantity Received],0),0,1) as QtyReceived,
	NVLINE.[Alt_ Qty_ UOM] as PurchaseUM,
	NVLINE.[Alt_ Quantity] as PurchaseFactor,
	CASE WHEN CHARINDEX('D', NVLINE.[Lead Time Calculation]) > 0
		THEN Replace(NVLINE.[Lead Time Calculation], 'D','')*1
		ELSE Replace(NVLINE.[Lead Time Calculation], '','')*1
	     END as VendorLeadTime,
	NVLINE.[Sales Order No_] as OrderRefNo,
	NVLINE.[Sales Order Line No_] as OrderLineRefNo,
	NVLINE.[Vendor Item No_] as VendorItemNo,
	POHeader.EntryID as EntryID,
	POHeader.EntryDt as EntryDt,
	NVLINE.[Status] as StatusCd,
	NVLINE.[No_] as ItemNo,
	ROUND(isnull(NVLINE.[Quantity],0),0,1) as QtyOrdered,
	(ROUND(isnull(NVLINE.[Quantity],0),0,1) - ROUND(isnull(NVLINE.[Quantity Received],0),0,1)) * NVLINE.[Unit Cost] as ExtendedCost,
	(ROUND(isnull(NVLINE.[Quantity],0),0,1) - ROUND(isnull(NVLINE.[Quantity Received],0),0,1)) * NVLINE.[Net Weight] as ExtendedWeight,
	CASE WHEN CHARINDEX('D', NVLINE.[Transit Time Calculation]) > 0
		THEN Replace(NVLINE.[Transit Time Calculation], 'D','')*1
		ELSE Replace(NVLINE.[Transit Time Calculation], '','')*1
	     END as TransitDays,
	NVLINE.[Alt_ Price] as AlternateCost,
	ItemMaster.CostPurUM as CostUM,
	ItemMaster.SellStkUM as BaseQtyUM,
	NVLINE.[Expected Receipt Date] as ScheduledReceiptDt,
	NVLINE.[Ship-by Date] as ScheduledShipDt,
	NVLINE.[Requested Receipt Date] as RequestedReceiptDt,
	(ROUND(isnull(NVLINE.[Quantity],0),0,1) - ROUND(isnull(NVLINE.[Quantity Received],0),0,1)) * NVLINE.[Gross Weight] as ExtendedGrossWeight,
	NVLINE.[PO Status Code] as POStatusCd,
	NVLINE.[Planned Receipt Date] as PlannedRcptDt
FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Purchase Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Purchase Header] NVHDR
ON	NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	POHeader
ON	NVLINE.[Document No_] = POHeader.POOrderNo INNER JOIN
	ItemMaster
ON	NVLINE.[No_] = ItemMaster.ItemNo
WHERE	NVLINE.Type = 2 AND NVLINE.No_ <> ''
	--AND ROUND(isnull(NVLINE.[Quantity],0),0,1) - ROUND(isnull(NVLINE.[Quantity Received],0),0,1) > 0





exec sp_columns [Porteous$Purchase Line]


exec sp_columns [Porteous$Purchase Line]





--UPDATE SuperEquivQty & SuperEquivUM
UPDATE	PODetail
SET	SuperEquivQty = ItemUM.QtyPerUM,
	SuperEquivUM = Item.SuperUM




select PODetail.ItemNo, Item.*
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item INNER JOIN
	PODetail
ON	PODetail.ItemNo = Item.ItemNo
--WHERE	Item.SuperUM = ItemUM.UM