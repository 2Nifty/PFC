
Select top 5000 * from [Porteous$Purchase Header]

select distinct [Shipment Method Code] from [Porteous$Sales Header]


Select [No_], [Posting Date], [Expected Receipt Date], [Requested Receipt Date], [Promised Receipt Date]  from [Porteous$Purchase Header]
--where [No_]>'18012500'
order by [No_]

select	DISTINCT
	[Document No_]--, [Outstanding Quantity], [Quantity], [Quantity Received], [Quantity] - [Quantity Received] 
from [Porteous$Purchase Line]
where [Quantity] - [Quantity Received] > 0 and [Outstanding Quantity] = 0
--where [Outstanding Quantity] <> 0
order by [Quantity] - [Quantity Received] 




select * from [Porteous$Purchase Line] where Type=0 and [No_]<>''


-----------------------------------------------------------------------------------------------


--[Porteous$Purchase Header]
SELECT	DISTINCT
	Hdr.[No_] as POOrderNo,
	Hdr.[Buy-from Vendor No_] as BuyFromVendorNo,
	Hdr.[Ship-to Name] as ShipToName,
	Hdr.[Ship-to Address] as ShipToAddress,
	Hdr.[Ship-to City] as ShipToCity,
	Hdr.[Ship-to Contact] as ShipToContactName,
	Hdr.[Order Date] as OrderDt,
	Hdr.[Posting Date] as AllocationDt,
	Hdr.[Expected Receipt Date] as ScheduledReceiptDt,
	Hdr.[Payment Terms Code] as OrderTermsCd,
	Hdr.[Shipment Method Code] as ShipMethodCd,
	Hdr.[Location Code] as LocationCd,
	Hdr.[Purchaser Code] as Buyer,
	Hdr.[Buy-from Address] as BuyFromAddress,
	Hdr.[Buy-from City] as BuyFromCity,
	Hdr.[Buy-from Post Code] as BuyFromZip,
	Hdr.[Buy-from County] as BuyFromState,
	Hdr.[Buy-from Country Code] as BuyFromCountry,
	Hdr.[Ship-to Post Code] as ShipToZip,
	Hdr.[Ship-to County] as ShipToState,
	Hdr.[Ship-to Country Code] as ShipToCountry,
	Hdr.[Document Date] as POPrintDt,
	Hdr.[Order Type] as POType,
	Hdr.[Entered User ID] as EntryID,
	Hdr.[Entered Date] as EntryDt,
	'N' as TaxStatus,
	Hdr.[Requested Receipt Date] as RequestedReceiptDt,
	Hdr.[Promised Receipt Date] as PromiseDt
FROM	[Porteous$Purchase Header] Hdr INNER JOIN
	[Porteous$Purchase Line] Line
ON	Hdr.[No_] = Line.[Document No_]
WHERE	Line.[Quantity] - Line.[Quantity Received] > 0 AND Line.[No_] <> '' AND
	Hdr.[Order Type] <> 0 AND (Line.Type = 1 OR Line.Type = 2)





--UPDATE POTypeName & POSubType
UPDATE	POHeader
SET	POTypeName = ListDtlDesc,
	POSubType = SequenceNo
FROM	ListMaster INNER JOIN
	ListDetail
ON	pListMasterID=fListMasterID INNER JOIN
	POHeader
ON	POType = ListValue
WHERE	ListName='poeordertypes'




--UPDATE LocationName
UPDATE	POHeader
SET	LocationName = LocName
FROM	(SELECT	DISTINCT LocID, LocName
	 FROM	LocMaster INNER JOIN
		POHeader
	 ON	LocID = LocationCd) Loc
WHERE	Loc.LocID = LocationCd


--UPDATE OrderTermsName
UPDATE	POHeader
SET	OrderTermsName = [Description]
FROM	(SELECT	DISTINCT Code, [Description]
	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Payment Terms] INNER JOIN
		POHeader
	 ON	Code = OrderTermsCd) Terms
WHERE	Terms.Code = OrderTermsCd

-----------------------------------------------------------------------------------------------


--[Porteous$Purchase Line]
SELECT	NVLINE.[Document No_] as POOrderNo,
	NVLINE.[Line No_] as POLineNo,
	NVLINE.[No_] as ItemNo,
	NVLINE.[Location Code] as ReceivingLocation,
	NVLINE.[Expected Receipt Date] as LastSchdReceiptDt,
	NVLINE.[Quantity] as QtyOrdered,
	NVLINE.[Quantity Received] as QtyReceived,
	NVLINE.[Vendor Item No_] as VendorItemNo,
	NVLINE.[Sales Order No_] as OrderRefNo,
	NVLINE.[Sales Order Line No_] as OrderLineRefNo,
	NVLINE.[Requested Receipt Date] as RequestedReceiptDt,
	NVLINE.[Promised Receipt Date] as PromiseDt,
	CASE WHEN CHARINDEX('D', NVLINE.[Lead Time Calculation]) > 0
		THEN Replace(NVLINE.[Lead Time Calculation], 'D','')*1
		ELSE Replace(NVLINE.[Lead Time Calculation], '','')*1
	     END as VendorLeadTime,
	NVLINE.[Alt_ Quantity] as PurchaseFactor,
	NVLINE.[Alt_ Qty_ UOM] as PurchaseUM,
	CASE WHEN CHARINDEX('D', NVLINE.[Transit Time Calculation]) > 0
		THEN Replace(NVLINE.[Transit Time Calculation], 'D','')*1
		ELSE Replace(NVLINE.[Transit Time Calculation], '','')*1
	     END as TransitDays,
	(NVLINE.[Quantity] - NVLINE.[Quantity Received]) * NVLINE.[Unit Cost] as ExtendedCost,
	POHeader.pPOHeaderID as fPOHeaderID,
	POHeader.EntryID as EntryID,
	POHeader.EntryDt as EntryDt
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Purchase Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Purchase Header] NVHDR
ON	NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	POHeader
ON	NVLINE.[Document No_] = POHeader.POOrderNo
WHERE	NVLINE.Type = 2 AND NVLINE.No_ <> '' AND
	NVLINE.[Quantity] - NVLINE.[Quantity Received] > 0




--UPDATE SuperEquivQty & SuperEquivUM
UPDATE	PODetail
SET	SuperEquivQty = ItemUM.QtyPerUM,
	SuperEquivUM = Item.SuperUM
FROM	ItemMaster Item INNER JOIN
	ItemUM
ON	pItemMasterID = fItemMasterID INNER JOIN
	PODetail
ON	PODetail.ItemNo = Item.ItemNo
WHERE	Item.SuperUM = ItemUM.UM



--[Porteous$Purchase Line] - Adjustments & Expenses
SELECT	NVLINE.[Line No_] as LineNumber,
	NVLINE.[Type] as ExpenseInd,
	NVLINE.[No_] as ExpenseCd,
	NVLINE.[Description] as ExpenseDesc,
	NVLINE.[Quantity] * [Unit Cost] as Amount,
	'N' as TaxStatus,
	POHeader.pPOHeaderID as fPOHeaderID,
	POHeader.POOrderNo as DocumentLoc,
	POHeader.EntryID as EntryID,
	POHeader.EntryDt as EntryDt
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Purchase Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Purchase Header] NVHDR
ON	NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	POHeader
ON	NVLINE.[Document No_] = POHeader.POOrderNo
WHERE	NVLINE.Type = 1 AND [Quantity] <> 0 AND [Unit Cost] <> 0



--TotalMaterialCost, TotalExpenseCost &TotalCost

--UPDATE TotalMaterialCost
UPDATE	POHeader
SET	TotalMaterialCost = Cost.TotExtCost
FROM	(SELECT	POHeader.POOrderNo, SUM(PODetail.ExtendedCost) as TotExtCost
	 FROM	PODetail INNER JOIN
		POHeader
	 ON	pPOHeaderID = fPOHeaderID
	 GROUP BY POHeader.POOrderNo) Cost
WHERE	Cost.POOrderNo = POHeader.POOrderNo


--SET NULL values to 0
UPDATE	POHeader
SET	TotalMaterialCost = 0
WHERE	TotalMaterialCost is null


--UPDATE TotalExpenseCost
UPDATE	POHeader
SET	TotalExpenseCost = Amount.TotExpAmount
FROM	(SELECT	POHeader.POOrderNo, SUM(POExpense.Amount) as TotExpAmount
	 FROM	POExpense INNER JOIN
		POHeader
	 ON	pPOHeaderID = fPOHeaderID
	 GROUP BY POHeader.POOrderNo) Amount
WHERE	Amount.POOrderNo = POHeader.POOrderNo


--SET NULL values to 0
UPDATE	POHeader
SET	TotalExpenseCost = 0
WHERE	TotalExpenseCost is null


--UPDATE TotalCost
UPDATE	POHeader
SET	TotalCost = isnull(TotalMaterialCost,0) + isnull(TotalExpenseCost,0)


-----------------------------------------------------------------------------------------------


--[Porteous$Purch_ Comment Line] - Header Comments
SELECT	POHeader.pPOHeaderID as fPOHeaderID,
	'CT' as Type,
	'A' as FormsCd,
	0 as CommLineNo,
	[Line No_] as CommLineSeqNo,
	[Date] as EntryDt,
	[Comment] as CommText,
	[User ID] as EntryID
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Purch_ Comment Line] COMMLINE INNER JOIN
	POHeader ON COMMLINE.[No_] = POHeader.POOrderNo



--[Porteous$Purch_ Line Comment Line] - Line Comments
SELECT	POHeader.pPOHeaderID as fPOHeaderID,
	'LC' as Type,
	'A' as FormsCd,
	[Doc_ Line No_] as CommLineNo,
	[Line No_] as CommLineSeqNo,
	[Date] as EntryDt,
	[Comment] as CommText,
	[User ID] as EntryID
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Purch_ Line Comment Line] COMMLINE INNER JOIN
	POHeader ON COMMLINE.[No_] = POHeader.POOrderNo



-----------------------------------------------------------------------------------------------


--[Porteous$Production Order]
SELECT	Prod.[No_] as POOrderNo,
	'WO' as POType,
	RIGHT('000000'+Prod.[Location Code],6) as BuyFromVendorNo,
	Cust.[Address] as BuyFromAddress,
	Cust.[City] as BuyFromCity,
	Cust.[County] as BuyFromState,
	Cust.[Post Code] as BuyFromZip,
	Cust.[Country Code] as BuyFromCountry,
	Cust.[Phone No_] as OrderContactPhoneNo,
	Cust.[Contact] as OrderContactName,
	Cust.[Name] as ShipToName,
	Cust.[Address] as ShipToAddress,
	Cust.[City] as ShipToCity,
	Cust.[County] as ShipToState,
	Cust.[Post Code] as ShipToZip,
	Cust.[Country Code] as ShipToCountry,
	Cust.[Phone No_] as ShipToPhoneNo,
	Cust.[Contact] as ShipToContactName,
	'N' as TaxStatus,
	Prod.[Sales Order No_] as OrderRefNo,
	Prod.[Due Date] as ScheduledReceiptDt,
	Prod.[Location Code] as LocationCd,
	Prod.[Creation Date] as OrderDt,
	Prod.[Source No_] as WOItemNo,
	RIGHT('000000'+Prod.[Location Code],6) as Buyer,
	Prod.[Creation Date] as EntryDt,
	Prod.[Last Date Modified] as ChangeDt
FROM	[Porteous$Production Order] Prod INNER JOIN
	[Porteous$Customer] Cust
ON	RIGHT('000000' + Prod.[Location Code],6) = Cust.[No_]
WHERE	Prod.[Status] = 3





--[Porteous$Prod_ Order Line]
SELECT	POHeader.pPOHeaderID as fPOHeaderID,
	NVLINE.[Prod_ Order No_] as POOrderNo,
	NVLINE.[Line No_] as POLineNo,
	NVLINE.[Due Date] as LastSchdReceiptDt,
	NVLINE.[Location Code] as ReceivingLocation,
	NVLINE.[Unit of Measure Code] as PurchaseUM,
	NVLINE.[Quantity (Base)] as PurchaseFactor,
	POHeader.EntryDt as EntryDt,
	NVLINE.[Item No_] as ItemNo,
	NVLINE.[Quantity] as QtyOrdered,
	NVLINE.[Quantity] * NVLINE.[Unit Cost] as ExtendedCost
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Prod_ Order Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Production Order] NVHDR
ON	NVHDR.[No_]=NVLINE.[Prod_ Order No_] INNER JOIN
	POHeader
ON	NVLINE.[Prod_ Order No_] = POHeader.POOrderNo




--[Porteous$Prod_ Order Comment Line] - Header Comments
SELECT	POHeader.pPOHeaderID as fPOHeaderID,
	'CT' as Type,
	'A' as FormsCd,
	0 as CommLineNo,
	[Line No_] as CommLineSeqNo,
	[Comment] as CommText,
	[Date] as EntryDt
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Prod_ Order Comment Line] COMMLINE INNER JOIN
	POHeader ON COMMLINE.[Prod_ Order No_] = POHeader.POOrderNo



-----------------------------------------------------------------------------------------------


select [TotalMaterialCost], * from POHeader
order by POOrderNo
select [ExtendedCost], * from PODetail
order by POOrderNo

select * from POExpense





