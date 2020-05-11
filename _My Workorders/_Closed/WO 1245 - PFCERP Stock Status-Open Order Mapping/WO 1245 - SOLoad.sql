

select [Posting Date], * from [Porteous$Sales Header]

select * from [Porteous$Sales Line Comment Line] order by [Date]

-----------------------------------------------------------------------------------------------


--[Porteous$Sales Header] - Order; Credit Memo; Return Order
SELECT	[No_] as RefSONo,
	[Sell-to Customer No_] as SellToCustNo,
	[Bill-to Customer No_] as BillToCustNo,
	[Bill-to Name] as BillToCustName,
	[Bill-to Address] as BillToAddress1,
	[Bill-to Address 2] as BillToAddress2,
	[Bill-to City] as BillToCity,
	[Bill-to Contact] as BillToContactName,
	[Your Reference] as BillToAddress3,
	[Ship-to Code] as ShipToCd,
	[Ship-to Name] as ShipToName,
	[Ship-to Name 2] as ShipToAddress3,
	[Ship-to Address] as ShipToAddress1,
	[Ship-to Address 2] as ShipToAddress2,
	[Ship-to City] as City,
	[Ship-to Contact] as ContactName,
	[Order Date] as OrderDt,
	[Posting Date] as MakeOrderDt,
	[Shipment Date] as SchShipDt,
	[Payment Terms Code] as OrderTermsCd,
	[Due Date] as OrderPromDt,
	[Payment Discount %] as DiscPct,
	[Shipment Method Code] as OrderMethCd,
	[Location Code] as ShipLoc,
	[Shortcut Dimension 1 Code] as CustShipLoc,
	[Invoice Disc_ Code] as DiscountCd,
	[Salesperson Code] as SalesRepNo,
	[No_ Printed] as CopiestoPrint,
	[Sell-to Customer Name] as SellToCustName,
	[Sell-to Address] as SellToAddress1,
	[Sell-to Address 2] as SellToAddress2,
	[Sell-to City] as SellToCity,
	[Sell-to Contact] as SellToContactName,
	[Bill-to Post Code] as BillToZip,
	[Bill-to County] as BillToState,
	[Bill-to Country Code] as BillToCountry,
	[Sell-to Post Code] as SellToZip,
	[Sell-to County] as SellToState,
	[Sell-to Country Code] as SellToCountry,
	[Ship-to Post Code] as Zip,
	[Ship-to County] as State,
	[Ship-to Country Code] as Country,
	[External Document No_] as CustPONo,
	[Shipping Agent Code] as OrderCarName,
	[Status] as StatusCd,
	[Usage Location] as UsageLoc,
	--RIGHT('00'+CAST([Order Type] AS VARCHAR(2)),2) AS OrderType,
	[Order Type] AS OrderType,
	[Entered User ID] as EntryID,
	[Entered Date] as EntryDt,
	[Inside Salesperson Code] as CustSvcRepName,
	[Phone No_] as BillToContactPhoneNo,
	[Phone No_] as PhoneNo,
	[Phone No_] as SellToContactPhoneNo,
	[Fax No_] as FaxNo,
	'N' as TaxStat
FROM	[Porteous$Sales Header]
WHERE	([Document Type] = 1 OR [Document Type] = 3 OR [Document Type] = 5) AND
	([No_] < 'SRA' OR [No_] > 'SRA1178701') --AND

	--[No_] < 'SRA1178701' AND [No_] > 'SRA' AND

	--[Posting Date] > Cast('2006-08-26 00:00:00.000' as DATETIME) AND
	--[ERP Upload Flag]=0






--UPDATE OrderNo
UPDATE	SOHeader
SET	OrderNo = pSOHeaderID


--UPDATE OrderType

--Pallet Partners
UPDATE	SOHeader
SET	OrderType = 'PP'
WHERE	OrderType = '4'

--Special Processing
UPDATE	SOHeader
SET	OrderType = '0'
WHERE	OrderType = '3'

--Stock & Release
UPDATE	SOHeader
SET	OrderType = '4'
WHERE	OrderType = '2'




--UPDATE OrderTypeDesc & SubType
UPDATE	SOHeader
SET	OrderTypeDsc = ListDtlDesc,
	SubType = SequenceNo
FROM	ListMaster INNER JOIN
	ListDetail
ON	pListMasterID=fListMasterID INNER JOIN
	SOHeader
ON	OrderType = ListValue
WHERE	ListName='soeordertypes'




--UPDATE OrderLoc  (PFCQuote.Umbrella)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SOHeader
SET	OrderLoc = RIGHT('00'&[CompanyID],2)
FROM	(SELECT	DISTINCT UserName, RIGHT('00'+CAST([CompanyID] AS VARCHAR(2)),2) AS [CompanyID]
	 FROM	UCOR_UserSetup INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SOHeader
	 ON	UserName = EntryID) Loc
WHERE	Loc.UserName = EntryID


--SET OrderLocName
UPDATE	SOHeader
SET	OrderLocName = LocName
FROM	(SELECT	DISTINCT LocID, LocName
	 FROM	LocMaster INNER JOIN
		SOHeader
	 ON	LocID = OrderLoc) Loc
WHERE	Loc.LocID = OrderLoc


--SET ShipLocName
UPDATE	SOHeader
SET	ShipLocName = LocName
FROM	(SELECT	DISTINCT LocID, LocName
	 FROM	LocMaster INNER JOIN
		SOHeader
	 ON	LocID = ShipLoc) Loc
WHERE	Loc.LocID = ShipLoc


--SET UsageLocName
UPDATE	SOHeader
SET	UsageLocName = LocName
FROM	(SELECT	DISTINCT LocID, LocName
	 FROM	LocMaster INNER JOIN
		SOHeader
	 ON	LocID = UsageLoc) Loc
WHERE	Loc.LocID = UsageLoc




--UPDATE OrderTermsName
UPDATE	SOHeader
SET	OrderTermsName = [Description]
FROM	(SELECT	DISTINCT Code, [Description]
	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Payment Terms] INNER JOIN
		SOHeader
	 ON	Code = OrderTermsCd) Terms
WHERE	Terms.Code = OrderTermsCd



-----------------------------------------------------------------------------------------------


--[Porteous$Sales Line]
SELECT	NVLINE.[Line No_] as LineNumber,
	NVLINE.[Type] as LineType,
	NVLINE.[No_] as ItemNo,
	NVLINE.[Location Code] as IMLoc,
	NVLINE.[Shipment Date] as OrigShipDt,
	NVLINE.[Description] as ItemDsc,
	NVLINE.[Quantity] as QtyOrdered,
	NVLINE.[Unit Price] as ListUnitPrice,
	NVLINE.[Allow Invoice Disc_] as DiscInd,
	NVLINE.[Gross Weight] as GrossWght,
	NVLINE.[Net Weight] as NetWght,
	NVLINE.[Quantity Shipped] as QtyShipped,
	NVLINE.[Unit Cost] as UnitCost,
	NVLINE.[Bin Code] as BinLoc,
	NVLINE.[Cross-Reference No_] as CustItemNo,
	NVLINE.[Usage Location] as UsageLoc,
	NVLINE.[Net Unit Price] as NetUnitPrice,
	NVLINE.[Line Cost] as OECost,
	isnull(NVLINE.[Excl_ from Usage],0) as ExcludeFromUsageFlag,
	NVLINE.[Back Order Qty] as QtyBO,
	NVLINE.[Quantity] * NVLINE.[Net Unit Price] as ExtendedPrice,
	NVLINE.[Quantity] * NVLINE.[Unit Cost] as ExtendedCost,
	NVLINE.[Quantity] * NVLINE.[Net Weight] as ExtendedNetWght,
	NVLINE.[Quantity] * NVLINE.[Gross Weight] as ExtendedGrossWght,
	SOHeader.pSOHeaderID as fSOHeaderID,
	SOHeader.EntryID as EntryID,
	SOHeader.EntryDt as EntryDate
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	SOHeader ON NVLINE.[Document No_] = SOHeader.RefSONo
WHERE	NVLINE.Type=2 AND NVLINE.No_ <> '' AND
	SOHeader.[MakeOrderDt] > Cast('2006-08-26 00:00:00.000' as DATETIME) --AND
	--NVHDR.[ERP Upload Flag]=0


-----------------------------------------------------------------------------------------------

--[Porteous$Sales Line] - Adjustments & Expenses
SELECT	NVLINE.[Line No_] as LineNumber,
	NVLINE.[Type] as ExpenseInd,
	NVLINE.[No_] as ExpenseCd,
	NVLINE.[Description] as ExpenseDesc,
	NVLINE.[Quantity] * [Unit Price] as Amount,
	'N' as TaxStatus,
	SOHeader.pSOHeaderID as fSOHeaderID,
	SOHeader.RefSONo as DocumentLoc,
	SOHeader.EntryID as EntryID,
	SOHeader.EntryDt as EntryDt
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	SOHeader ON NVLINE.[Document No_] = SOHeader.RefSONo
WHERE	NVLINE.Type <> 2 AND [Quantity] <> 0 AND [Unit Price] <> 0 AND
	SOHeader.[MakeOrderDt] > Cast('2006-08-26 00:00:00.000' as DATETIME) --AND
	--NVHDR.[ERP Upload Flag]=0


-----------------------------------------------------------------------------------------------


--[Porteous$Sales Comment Line] - Header Comments
SELECT	SOHeader.pSOHeaderID as fSOHeaderID,
	'CT' as Type,
	'A' as FormsCd,
	0 as CommLineNo,
	[Line No_] as CommLineSeqNo,
	[Date] as EntryDt,
	[Comment] as CommText,
	[User ID] as EntryID,
	SOHeader.EntryDt as EntryDate
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Comment Line] COMMLINE INNER JOIN
	SOHeader ON COMMLINE.[No_] = SOHeader.RefSONo


-----------------------------------------------------------------------------------------------


--[Porteous$Sales Line Comment Line] - Line Comments
SELECT	SOHeader.pSOHeaderID as fSOHeaderID,
	'LC' as Type,
	'A' as FormsCd,
	[Doc_ Line No_] as CommLineNo,
	[Line No_] as CommLineSeqNo,
	[Date] as EntryDt,
	[Comment] as CommText,
	[User ID] as EntryID,
	SOHeader.EntryDt as EntryDate
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Line Comment Line] COMMLINE INNER JOIN
	SOHeader ON COMMLINE.[No_] = SOHeader.RefSONo



-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------


--[Porteous$Transfer Header]
SELECT	DISTINCT
	NVHDR.[No_] as RefSONo,
	NVHDR.[Transfer-from Code] as OrderLoc,
	NVHDR.[Transfer-from Code] as ShipLoc,
	NVHDR.[Transfer-to Name] as ShipToName,
	NVHDR.[Transfer-to Name 2] as ShipToAddress3,
	NVHDR.[Transfer-to Address] as ShipToAddress1,
	NVHDR.[Transfer-to Address 2] as ShipToAddress2,
	NVHDR.[Transfer-to Post Code] as Zip,
	NVHDR.[Transfer-to City] as City,
	NVHDR.[Transfer-to County] as State,
	NVHDR.[Transfer-to Country Code] as Country,
	NVHDR.[Posting Date] as MakeOrderDt,
	NVHDR.[Shipment Date] as SchShipDt,
	NVHDR.[Status] as StatusCd,
	NVHDR.[Shortcut Dimension 1 Code] as CustShipLoc,
	NVHDR.[External Document No_] as CustPONo,
	NVHDR.[Shipping Agent Code] as OrderCarName,
	NVHDR.[Inbound Bill of Lading No_] as BOLNO,
	RIGHT('000000'+NVHDR.[Transfer-to Code],6) as ShipToCd,
	'N' as TaxStat,
	'TO' as OrderType
FROM	[Porteous$Transfer Header] NVHDR INNER JOIN
	[Porteous$Transfer Line] NVLINE
ON	[No_] = [Document No_]
WHERE	[Qty_ to Ship] > 0
ORDER BY [No_]

-----------------------------------------------------------------------------------------------

