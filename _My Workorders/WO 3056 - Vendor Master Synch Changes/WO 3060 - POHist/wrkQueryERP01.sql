exec sp_columns POHeader

select distinct CompleteDt from POHeader


select * from POdetail where fPOHeaderID in

--select * from POExpense where fPOHeaderID in
(select pPOHeaderID from POHeader where CompleteDt = '01/01/1980')

select distinct pPOHeaderID, POOrderNo from POHeader where CompleteDt = '01/01/1980' order by POOrderNo

select count(*) from POHeader

select DISTINCT POOrderNo from POHeader where POOrderNo in

('17010435-1',	--valid
'18013030AD',
'27111631AD',
'28022607',	--valid
'30012601',	--valid
'32101702C3',	--valid
'49062305C3',
'49062306C3',
'49072404C3',
'49073102C3',
'49080301C3',
'49081001C3',
'49082601C3',
'49082702C3',
'49082801C3',
'49090302C3',
'49092802C3',
'49092803C3',
'49093001C3',
'49100202C3',
'VERBAL LIN')

---------------------------------------------------------------------------------------------

UPDATE	POHeader
SET		CompleteDt = '01/01/1980'


UPDATE	POHeader
SET		CompleteDt = null
--select	*
FROM	POHeader Hdr INNER JOIN
		PODetail Line
ON		Hdr.pPOHeaderID = Line.fPOHeaderID
WHERE	Line.QtyOrdered - QtyReceived > 0

drop table #tPOCompleteDt

SELECT	fPOHeaderID, MAX(Line.CompleteDt) as CompleteDt
INTO	#tPOCompleteDt
FROM	POHeader Hdr INNER JOIN
		PODetail Line
ON		Hdr.pPOHeaderID = Line.fPOHeaderID
WHERE	Hdr.CompleteDt = '01/01/1980'
GROUP BY fPOHeaderID
--select * from #tPOCompleteDt


UPDATE	POHeader
SET		CompleteDt = tmp.CompleteDt
FROM	#tPOCompleteDt tmp
WHERE	POHeader.pPOHeaderID = tmp.fPOHeaderID AND POHeader.CompleteDt = '01/01/1980'


UPDATE	POHeader
SET		CompleteDt = EntryDt
WHERE	POHeader.CompleteDt = '01/01/1980' AND EntryDt < '01/01/2012'


UPDATE	POHeader
SET		CompleteDt = null
WHERE	POHeader.CompleteDt = '01/01/1980'


----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------




--[Porteous$Purchase Header]
SELECT	DISTINCT
	Hdr.[No_] as POOrderNo,
	Hdr.[Order Type] as POType,
	Hdr.[Buy-from Vendor No_] as BuyFromVendorNo,
	Hdr.[Buy-from Address] as BuyFromAddress,
	Hdr.[Buy-from City] as BuyFromCity,
	Hdr.[Buy-from County] as BuyFromState,
	Hdr.[Buy-from Post Code] as BuyFromZip,
	Hdr.[Buy-from Country Code] as BuyFromCountry,
	Hdr.[Buy-from Contact] as OrderContactName,
	Hdr.[Ship-to Name] as ShipToName,
	Hdr.[Ship-to Address] as ShipToAddress,
	Hdr.[Ship-to City] as ShipToCity,
	Hdr.[Ship-to County] as ShipToState,
	Hdr.[Ship-to Post Code] as ShipToZip,
	Hdr.[Ship-to Country Code] as ShipToCountry,
	Hdr.[Ship-to Contact] as ShipToContactName,
	'N' as TaxStatus,
	Hdr.[Buy-from Vendor No_] as POVendorNo,
	Hdr.[Location Code] as LocationCd,
	Hdr.[Payment Terms Code] as OrderTermsCd,
	Hdr.[Shipping Agent Code] as CarrierCd,
	Hdr.[Expected Receipt Date] as ScheduledReceiptDt,
	Hdr.[Ship-by Date] as ScheduledShipDt,
	Hdr.[Order Date] as OrderDt,
	Hdr.[Entered Date] as AllocationDt,
	Hdr.[Document Date] as POPrintDt,
	Hdr.[Purchaser Code] as Buyer,
	'N' as POCommentsInd,
	'N' as POExpenseInd,
	Hdr.[Entered User ID] as EntryID,
	Hdr.[Entered Date] as EntryDt,
	Hdr.[Status] as StatusCd,
--	Hdr.[Order Date] as AllocReleaseDt,
--	Hdr.[Entered User ID]  as AllocReleaseUserID,
	Hdr.[Requested Receipt Date] as RequestedReceiptDt,
	Hdr.[Promised Receipt Date] as PromiseDt,
	Hdr.[Shipment Method Code] as OrderFreightCd,
	Hdr.[Buy-from Vendor Name] as BuyFromName,
	Hdr.[Buy-from Address 2] as BuyFromAddress2,
	Hdr.[Order Date] as MakeOrderDt,
	Hdr.[Location Code] as ShipToVendorNo,
	Hdr.[Pay-to Vendor No_] as PayToVendorNo,
	Hdr.[Pay-to Name] as PayToName,
	Hdr.[Pay-to Address] as PayToAddress,
	Hdr.[Pay-to Address 2] as PayToAddress2,
	Hdr.[Pay-to City] as PayToCity,
	Hdr.[Pay-to County] as PayToState,
	Hdr.[Pay-to Post Code] as PayToZip,
	Hdr.[Pay-to Country Code] as PayToCountry,
	Hdr.[Buy-from Country Code] as CountryOfOrigin
FROM	[Porteous$Purchase Header] Hdr INNER JOIN
	[Porteous$Purchase Line] Line
ON	Hdr.[No_] = Line.[Document No_]
WHERE	--ROUND(Line.[Quantity],0,1) - ROUND(Line.[Quantity Received],0,1) > 0 AND
	Line.[No_] <> '' AND Hdr.[Order Type] <> 0 AND (Line.Type = 1 OR Line.Type = 2)



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
	POHeader.CountryOfOrigin,
	POHeader.EntryID as EntryID,
	POHeader.EntryDt as EntryDt,
	NVLINE.[Status] as StatusCd,
	NVLINE.[No_] as ItemNo,
	ROUND(isnull(NVLINE.[Quantity],0),0,1) as QtyOrdered,
--	(ROUND(isnull(NVLINE.[Quantity],0),0,1) - ROUND(isnull(NVLINE.[Quantity Received],0),0,1)) * NVLINE.[Unit Cost] as ExtendedCost,
--	(ROUND(isnull(NVLINE.[Quantity],0),0,1) - ROUND(isnull(NVLINE.[Quantity Received],0),0,1)) * NVLINE.[Net Weight] as ExtendedWeight,
	ROUND(isnull(NVLINE.[Quantity],0),0,1) * NVLINE.[Unit Cost] as ExtendedCost,
	ROUND(isnull(NVLINE.[Quantity],0),0,1) * NVLINE.[Net Weight] as ExtendedWeight,
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
--	(ROUND(isnull(NVLINE.[Quantity],0),0,1) - ROUND(isnull(NVLINE.[Quantity Received],0),0,1)) * NVLINE.[Gross Weight] as ExtendedGrossWeight,
	ROUND(isnull(NVLINE.[Quantity],0),0,1) * NVLINE.[Gross Weight] as ExtendedGrossWeight,
	NVLINE.[PO Status Code] as POStatusCd,
	NVLINE.[Planned Receipt Date] as PlannedRcptDt,
	ItemMaster.ItemDesc,
	NVLINE.[Unit Cost] * NVLINE.[Net Weight] as CostPerLb,
	ItemMaster .SellStkUMQty as BaseQty,
	NVLINE.[Unit Cost] as UnitCost,
	NVLINE.[Net Weight] as NetWeight,
	NVLINE.[Gross Weight] as GrossWeight
FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Purchase Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Purchase Header] NVHDR
ON	NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	POHeader
ON	NVLINE.[Document No_] = POHeader.POOrderNo INNER JOIN
	ItemMaster
ON	NVLINE.[No_] = ItemMaster.ItemNo
WHERE	NVLINE.Type = 2 AND NVLINE.No_ <> ''
	--AND ROUND(isnull(NVLINE.[Quantity],0),0,1) - ROUND(isnull(NVLINE.[Quantity Received],0),0,1) > 0





select * from ItemMaster
where ItemNo='99999-7533-209'

