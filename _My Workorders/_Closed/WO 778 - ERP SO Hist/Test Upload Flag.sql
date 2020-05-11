--Update the existing records
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Invoice Header]
SET	[ERP Upload Flag]=1
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Invoice Header] NVHDR
WHERE	EXISTS
	(SELECT * FROM SOHeaderHist
	 WHERE InvoiceNo=NVHDR.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS)
	 
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Cr_Memo Header]
SET	[ERP Upload Flag]=1
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Cr_Memo Header] NVHDR
WHERE	EXISTS
	(SELECT * FROM SOHeaderHist
	 WHERE InvoiceNo=NVHDR.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS)
	 






UPDATE [Porteous$Sales Invoice Header]
SET [ERP Upload Flag]=1
FROM [Porteous$Sales Invoice Header]
WHERE [ERP Upload Flag]=0 







--[Porteous$Sales Invoice Header]
select
------	[Order No_]			as	OGOrderNo,
------	RIGHT([Order No_],7)		as	OrderNo,					
----	[timestamp]			as		,	
	[No_]				as	InvoiceNo	,	--CAST		
	[Sell-to Customer No_]		as	SellToCustNo	,	
	[Bill-to Customer No_]		as	BillToCustNo	,	
	[Bill-to Name]			as	BillToCustName	,	
----	[Bill-to Name 2]		as		,	
	[Bill-to Address]		as	BillToAddress1	,	
	[Bill-to Address 2]		as	BillToAddress2	,	
	[Bill-to City]			as	BillToCity	,	
	[Bill-to Contact]		as	BillToContactName	,	
	[Your Reference]		as	BillToAddress3	,	
	[Ship-to Code]			as	ShipToCd	,	
	[Ship-to Name]			as	ShipToName	,	
	[Ship-to Name 2]		as	ShipToAddress3	,	
	[Ship-to Address]		as	ShipToAddress1	,	
	[Ship-to Address 2]		as	ShipToAddress2	,	
	[Ship-to City]			as	City	,	
	[Ship-to Contact]		as	ContactName	,	
	[Order Date]			as	OrderDt	,	
	[Posting Date]			as	ArPostDt	,	
	[Shipment Date]			as	SchShipDt	,	
----	[Posting Description]		as		,	
	[Payment Terms Code]		as	OrderTermsCd	,	
	[Due Date]			as	OrderPromDt	,	
	[Payment Discount %]		as	DiscPct	,	
--	[Pmt_ Discount Date]		as		,	
	[Shipment Method Code]		as	OrderMethCd	,	
	[Location Code]			as	ShipLoc	,	
	[Shortcut Dimension 1 Code]	as	CustShipLoc	,
----	[Shortcut Dimension 1 Code]	as		,	
----	[Shortcut Dimension 2 Code]	as		,	
----	[Customer Posting Group]	as		,	
----	[Currency Code]			as		,	EMPTY
----	[Currency Factor]		as		,	EMPTY
--	[Customer Price Group]		as		,	
----	[Prices Including VAT]		as		,	EMPTY
	[Invoice Disc_ Code]		as	DiscountCd	,	
--	[Customer Disc_ Group]		as		,	
----	[Language Code]			as		,	EMPTY
	[Salesperson Code]		as	SalesRepNo	,	
	[Order No_]			as	RefSONo	,		
	[No_ Printed]			as	CopiestoPrint	,	
--	[On Hold]			as		,	
----	[Applies-to Doc_ Type]		as		,	
----	[Applies-to Doc_ No_]		as		,	
----	[Bal_ Account No_]		as		,	EMPTY
----	[Job No_]			as		,	EMPTY
----	[VAT Registration No_]		as		,	EMPTY
----	[Reason Code]			as		,	EMPTY
----	[Gen_ Bus_ Posting Group]	as		,	
----	[EU 3-Party Trade]		as		,	EMPTY
----	[Transaction Type]		as		,	EMPTY
----	[Transport Method]		as		,	EMPTY
--	[VAT Country Code]		as		,	
	[Sell-to Customer Name]		as	SellToCustName	,	
----	[Sell-to Customer Name 2]	as		,	
	[Sell-to Address]		as	SellToAddress1	,	
	[Sell-to Address 2]		as	SellToAddress2	,	
	[Sell-to City]			as	SellToCity	,	
	[Sell-to Contact]		as	SellToContactName	,	
	[Bill-to Post Code]		as	BillToZip	,	
	[Bill-to County]		as	BillToState	,	
	[Bill-to Country Code]		as	BillToCountry	,	
	[Sell-to Post Code]		as	SellToZip	,	
	[Sell-to County]		as	SellToState	,	
	[Sell-to Country Code]		as	SellToCountry	,	
	[Ship-to Post Code]		as	Zip	,	
	[Ship-to County]		as	State	,	
	[Ship-to Country Code]		as	Country	,	
--	[Bal_ Account Type]		as		,	
----	[Exit Point]			as		,	EMPTY
----	[Correction]			as		,	EMPTY
--	[Document Date]			as		,	
	[External Document No_] 	as		CustPONo,	--CAST		
----	[Area]				as		,	EMPTY
----	[Transaction Specification]	as		,	EMPTY
--	[Payment Method Code]		as		,	
	[Shipping Agent Code]		as	OrderCarName	,	
--	[Package Tracking No_]		as		,	
----	[Pre-Assigned No_ Series]	as		,	
----	[No_ Series]			as		,	
----	[Order No_ Series]		as		,	
----	[Pre-Assigned No_]		as		,	
--	[User ID]			as	EntryId,	-- (or load with Entered User ID)
--	[Source Code]			as		,	
----	[Tax Area Code]			as		,	EMPTY
----	[Tax Liable]			as		,	EMPTY
----	[VAT Bus_ Posting Group]	as		,	EMPTY
----	[VAT Base Discount %]		as		,	EMPTY
----	[Campaign No_]			as		,	EMPTY
	[Sell-to Contact No_]		as	SellToContactPhoneNo	,	
	[Bill-to Contact No_]		as	BillToContactPhoneNo	,	
----	[Responsibility Center]		as		,	EMPTY
----	[Service Mgt_ Document]		as		,	EMPTY
--	[Allow Line Disc_]		as		,	
----	[Ship-to UPS Zone]		as		,	
--	[Tax Exemption No_]		as		,	
	[Usage Location]		as	UsageLoc	,	
	[Sales Location]		as	OrderLoc	,	
	[Order Type]			as	OrderType	,	
----	[Unit Price Orgin]		as		,	EMPTY
----	[EDI Order]			as		,	
----	[EDI Internal Doc_ No_]		as		,	
----	[EDI Invoice Generated]		as		,	
----	[EDI Inv_ Gen_ Date]		as		,	
----	[EDI Ack_ Generated]		as		,	EMPTY
----	[EDI Ack_ Gen_ Date]		as		,	
----	[EDI WHSE Shp_ Gen]		as		,	EMPTY
----	[EDI WHSE Shp_ Gen Date]	as		,	
----	[EDI Trade Partner]		as		,	
----	[EDI Sell-to Code]		as		,	
----	[EDI Ship-to Code]		as		,	EMPTY
----	[EDI Ship-for Code]		as		,	EMPTY
--	[E-Ship Agent Service]		as		,	
----	[Residential Delivery]		as		,	
--	[Free Freight]			as		,	
--	[COD Payment]			as		,	
--	[World Wide Service]		as		,	
----	[Blind Shipment]		as		,	
----	[Double Blind Shipment]		as		,	EMPTY
----	[Double Blind Ship-from Cust No]	as		,	EMPTY
----	[No Free Freight Lines on Order]	as		,	EMPTY
--	[Shipping Payment Type]		as		,	
--	[Third Party Ship_ Account No_]	as		,	
--	[Shipping Insurance]		as		,	
--	[Ship-for Code]			as		,	
--	[External Sell-to No_]		as		,	
--	[External Ship-to No_]		as		,	
--	[External Ship-for No_]		as		,	
--	[Invoice for Bill of Lading No_]	as		,	
----	[E-Mail Confirmation Handled]	as		,	
----	[E-Mail Invoice Notice Handled]	as		,	
	[Entered User ID]		as	EntryId	,	--CAST	
	[Entered Date]			as	EntryDt	,	
----	[Entered Time]			as		,	
----	[Tool Repair Tech]		as		,	EMPTY
	[Inside Salesperson Code]	as	CustSvcRepName	,	
	[Phone No_]			as	PhoneNo	,	
	[Fax No_]			as	FaxNo		--,	
----	[E-Mail]			as		,	
----	[Ship-to PO No_]		as		,	EMPTY
----	[Broker_Agent Code]		as		,	EMPTY
----	[FB Order No_]			as		,	EMPTY
----	[Tool Repair Priority]		as		,	
----	[Manufacturer Code]		as		,	EMPTY
----	[Serial No_]			as		,	EMPTY
----	[Tool Model No_]		as		,	EMPTY
----	[Tool Item No_]			as		,	EMPTY
----	[Tool Description]		as		,	EMPTY
----	[Tool Repair Ticket]		as		,	EMPTY
----	[Tool Repair Parts Warranty]	as		,	EMPTY
----	[Tool Repair Labor Warranty]	as		,	EMPTY
----	[Date Sent]			as		,	
----	[Time Sent]			as		,	
----	[BizTalk Sales Invoice]		as		,	EMPTY
----	[Customer Order No_]		as		,	EMPTY
----	[BizTalk Document Sent]		as		,	EMPTY
----	[Excl_ from Usage]		as		,	EMPTY
----	[eConnect Ref_ No_]		as		,	
----	[Total Freight]			as		,	EMPTY
----	[Total Tax]			as		,	EMPTY
----	[eConnect Order]		as		,	
----	[eConnect Order Status]		as		,	EMPTY
----	[Credit Card ID]		as		,	EMPTY
----	[Credit Card No]		as		,	EMPTY
----	[Credit Card Month]		as		,	EMPTY
----	[Credit Card Year]		as		,	EMPTY
----	[Credit Card Name]		as		,	EMPTY
----	[Get Shipment Used]		as		,	
----	[Invoice Detail Sort]		as		,	EMPTY
----	[ContractNo]			as
FROM	[Porteous$Sales Invoice Header]
WHERE	[ERP Upload Flag]=0 AND [Posting Date] > Cast('2006-08-26 00:00:00.000' as DATETIME)



--[Porteous$Sales Invoice Line]
select
	SOHeaderHist.pSOHeaderHistID as fSOHeaderHistID,
	NVLINE.[Line No_]	as	LineNumber	,
	NVLINE.[Type]	as	LineType	,
	NVLINE.[No_]	as	ItemNo	,
	NVLINE.[Location Code]	as	ImLoc	,
	NVLINE.[Shipment Date]	as	OrigShipDate	,
	NVLINE.[Description]	as	ItemDsc	,
	NVLINE.[Quantity]	as	QtyOrdered	,
	NVLINE.[Quantity]	as	QtyShipped	,
	NVLINE.[Unit Price]	as	ListUnitPrice	,
--	NVLINE.[Line Discount %]	as	DiscPct1	,
	NVLINE.[Allow Invoice Disc_]	as	DiscInd	,
	NVLINE.[Gross Weight]	as	GrossWght	,
	NVLINE.[Net Weight]	as	NetWght	,
	NVLINE.[Unit Cost]	as	UnitCost	,
	NVLINE.[Bin Code]	as	BinLoc	,
	NVLINE.[Cross-Reference Type No_]	as	CustItemNo	,
	NVLINE.[Net Unit Price]	as	NetUnitPrice	,
	NVLINE.[Line Cost]	as	OECost,
	SOHeaderHist.EntryID as EntryID,
	SOHeaderHist.EntryDt as EntryDt	
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Invoice Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Invoice Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	SOHeaderHist ON [Document No_] = SOHeaderHist.InvoiceNo
WHERE	NVHDR.[ERP Upload Flag]=0 AND NVLINE.Type=2 AND NVLINE.No_ <> '' AND
	SOHeaderHist.[ARPostDt] > Cast('2006-08-26 00:00:00.000' as DATETIME)





--[Porteous$Sales Invoice Line] - Adjustments
select
	SOHeaderHist.pSOHeaderHistID as fSOHeaderHistID,
	NVLINE.[Line No_]	as	LineNumber	,
	NVLINE.[Type]	as	LineType	,
	'00000-0000-000'	as	ItemNo	,
	NVLINE.[Location Code]	as	ImLoc	,
	NVLINE.[Shipment Date]	as	OrigShipDate	,
	NVLINE.[Description]	as	ItemDsc	,
	NVLINE.[Quantity]	as	QtyOrdered	,
	NVLINE.[Quantity]	as	QtyShipped	,
	NVLINE.[Unit Price]	as	ListUnitPrice	,
--	NVLINE.[Line Discount %]	as	DiscPct1	,
	NVLINE.[Allow Invoice Disc_]	as	DiscInd	,
	NVLINE.[Gross Weight]	as	GrossWght	,
	NVLINE.[Net Weight]	as	NetWght	,
	NVLINE.[Unit Cost]	as	UnitCost	,
	NVLINE.[Bin Code]	as	BinLoc	,
	NVLINE.[Cross-Reference Type No_]	as	CustItemNo	,
	NVLINE.[Net Unit Price]	as	NetUnitPrice	,
	NVLINE.[Line Cost]	as	OECost,
	SOHeaderHist.EntryID as EntryID,
	SOHeaderHist.EntryDt as EntryDt	
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Invoice Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Invoice Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	SOHeaderHist ON [Document No_] = SOHeaderHist.InvoiceNo
WHERE	NVHDR.[ERP Upload Flag]=0 AND NVLINE.Type=1 and NVLINE.No_ = '3021' AND
	SOHeaderHist.[ARPostDt] > Cast('2006-08-26 00:00:00.000' as DATETIME)



--[Porteous$Sales Invoice Line] - Expense Lines
select
	SOHeaderHist.pSOHeaderHistID as fSOHeaderHistID,
	NVLINE.[Line No_]	as	LineNumber	,
	NVLINE.[No_]		as	ExpenseCd	,
	NVLINE.[Quantity] * [Unit Price]		as	Amount		,
	NVLINE.[Type]		as	ExpenseInd	,
	'N'		as	TaxStatus	,
	SOHeaderHist.InvoiceNo	as	DocumentLoc,
	SOHeaderHist.EntryID as EntryID,
	SOHeaderHist.EntryDt as EntryDt	
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Invoice Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Invoice Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	SOHeaderHist ON [Document No_] = SOHeaderHist.InvoiceNo
WHERE	NVHDR.[ERP Upload Flag]=0 AND ((NVLINE.Type=1 and NVLINE.No_<>'3021') OR (NVLINE.Type<>1 AND NVLINE.Type<>2)) AND
	SOHeaderHist.[ARPostDt] > Cast('2006-08-26 00:00:00.000' as DATETIME)







----------------------------------------------------------------------------------------------------------------------------------------------------------------


--[Porteous$Sales Cr_Memo Header]
Select
------	'9000'+RIGHT([No_],6)	 as	OrderNo,
	[No_]			 as 	InvoiceNo	,
	[Sell-to Customer No_]	 as 	SellToCustNo	,
	[Bill-to Customer No_]	 as 	BillToCustNo	,
	[Bill-to Name]		 as 	BillToCustName	,
	[Bill-to Address]	 as 	BillToAddress1	,
	[Bill-to Address 2]	 as 	BillToAddress2	,
	[Bill-to City]		 as 	BillToCity	,
	[Bill-to Contact]	 as 	BillToContactName	,
	[Your Reference]	 as 	BillToAddress3	,
	[Ship-to Code]		 as 	ShipToCd	,
	[Ship-to Name]		 as 	ShipToName	,
	[Ship-to Name 2]	 as 	ShipToAddress3	,
	[Ship-to Address]	 as 	ShipToAddress1	,
	[Ship-to Address 2]	 as 	ShipToAddress2	,
	[Ship-to City]		 as 	City	,
	[Ship-to Contact]	 as 	ContactName	,
------	[Order Date]		 as 	OrderDt	,
	[Posting Date]		 as 	ArPostDt	,
	[Shipment Date]		 as 	SchShipDt	,
	[Payment Terms Code]	 as 	OrderTermsCd	,
	[Due Date]		 as 	OrderPromDt	,
	[Payment Discount %]	 as 	DiscPct	,
--	[Pmt_ Discount Date]	 as 		,
	[Shipment Method Code]	 as 	OrderMethCd	,
	[Location Code]		 as 	ShipLoc	,
	[Shortcut Dimension 1 Code]	as	CustShipLoc	,
--	[Customer Price Group]	 as 		,
	[Invoice Disc_ Code]	 as 	DiscountCd	,
--	[Customer Disc_ Group]	 as 		,
	[Salesperson Code]	 as 	SalesRepNo	,
------	[Order No_]		 as 	OrderNo	,
	[No_ Printed]		 as 	CopiestoPrint	,
--	[On Hold]		 as 		,
--	[VAT Country Code]	 as 		,
	[Sell-to Customer Name]	 as 	SellToCustName	,
	[Sell-to Address]	 as 	SellToAddress1	,
	[Sell-to Address 2]	 as 	SellToAddress2	,
	[Sell-to City]		 as 	SellToCity	,
	[Sell-to Contact]	 as 	SellToContactName	,
	[Bill-to Post Code]	 as 	BillToZip	,
	[Bill-to County]	 as 	BillToState	,
	[Bill-to Country Code]	 as 	BillToCountry	,
	[Sell-to Post Code]	 as 	SellToZip	,
	[Sell-to County]	 as 	SellToState	,
	[Sell-to Country Code]	 as 	SellToCountry	,
	[Ship-to Post Code]	 as 	Zip	,
	[Ship-to County]	 as 	State	,
	[Ship-to Country Code]	 as 	Country	,
--	[Bal_ Account Type]	 as 		,
--	[Document Date]		 as 		,
	[External Document No_]	 as 	ReferenceNo	,
--	[Payment Method Code]	 as 		,
------	[Shipping Agent Code]	 as 	OrderCarName	,
--	[Package Tracking No_]	 as 		,
--	[User ID]		 as 	EntryId  (or load with Entered User ID)	,
--	[Source Code]		 as 		,
	[Sell-to Contact No_]	 as 	SellToContactPhoneNo	,
	[Bill-to Contact No_]	 as 	BillToContactPhoneNo	,
--	[Allow Line Disc_]	 as 		,
--	[Tax Exemption No_]	 as 		,
	[Usage Location]	 as 	UsageLoc	,
	[Sales Location]	 as 	OrderLoc	,
------	[Order Type]		 as 	OrderType	,
	'51'			 as 	OrderType	,
	'Credit Memo'		 as	OrderTypeDsc,	
--	[E-Ship Agent Service]	 as 		,
--	[Free Freight]		 as 		,
--	[COD Payment]		 as 		,
--	[World Wide Service]	 as 		,
--	[Shipping Payment Type]	 as 		,
--	[Third Party Ship_ Account No_]	 as 		,
--	[Shipping Insurance]	 as 		,
--	[Ship-for Code]		 as 		,
--	[External Sell-to No_]	 as 		,
--	[External Ship-to No_]	 as 		,
--	[External Ship-for No_]	 as 		,
--	[Invoice for Bill of Lading No_]	 as 		,
	[Entered User ID]	 as 	EntryId	,
	[Entered Date]		 as 	EntryDt	,
	[Inside Salesperson Code]	 as 	CustSvcRepName	,
	[Phone No_]		 as 	PhoneNo	,
	[Fax No_]		 as 	FaxNo	
FROM	[Porteous$Sales Cr_Memo Header]
WHERE	[ERP Upload Flag]=0 AND [Posting Date] > Cast('2006-08-26 00:00:00.000' as DATETIME)





--[Porteous$Sales Cr_Memo Line]
select
	SOHeaderHist.pSOHeaderHistID as fSOHeaderHistID,
[Document No_],
	NVLINE.[Line No_]	as	LineNumber	,
	NVLINE.[Type]	as	LineType	,
	NVLINE.[No_]	as	ItemNo	,
	NVLINE.[Location Code]	as	ImLoc	,
	NVLINE.[Shipment Date]	as	OrigShipDate	,
	NVLINE.[Description]	as	ItemDsc	,
	NVLINE.[Quantity] * -1	as	QtyOrdered	,
	NVLINE.[Quantity] * -1	as	QtyShipped	,
	NVLINE.[Unit Price]	as	ListUnitPrice	,
--	NVLINE.[Line Discount %]	as	DiscPct1	,
	NVLINE.[Allow Invoice Disc_]	as	DiscInd	,
	NVLINE.[Gross Weight]	as	GrossWght	,
	NVLINE.[Net Weight]	as	NetWght	,
	NVLINE.[Unit Cost]	as	UnitCost	,
	NVLINE.[Bin Code]	as	BinLoc	,
	NVLINE.[Cross-Reference Type No_]	as	CustItemNo	,
	NVLINE.[Net Unit Price]	as	NetUnitPrice	,
	NVLINE.[Line Cost]	as	OECost,
	SOHeaderHist.EntryID as EntryID,
	SOHeaderHist.EntryDt as EntryDt	
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Cr_Memo Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Cr_Memo Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	SOHeaderHist ON [Document No_] = SOHeaderHist.InvoiceNo
WHERE	NVHDR.[ERP Upload Flag]=0 AND NVLINE.Type=2 AND NVLINE.No_ <> '' AND
	SOHeaderHist.[ARPostDt] > Cast('2006-08-26 00:00:00.000' as DATETIME)






--[Porteous$Sales Cr_Memo Line] - Adjustments
select
	SOHeaderHist.pSOHeaderHistID as fSOHeaderHistID,
--[Document No_],
	NVLINE.[Line No_]	as	LineNumber	,
	NVLINE.[Type]	as	LineType	,
	'00000-0000-000'	as	ItemNo	,
	NVLINE.[Location Code]	as	ImLoc	,
	NVLINE.[Shipment Date]	as	OrigShipDate	,
	NVLINE.[Description]	as	ItemDsc	,
	NVLINE.[Quantity] * -1	as	QtyOrdered	,
	NVLINE.[Quantity] * -1	as	QtyShipped	,
	NVLINE.[Unit Price]	as	ListUnitPrice	,
--	NVLINE.[Line Discount %]	as	DiscPct1	,
	NVLINE.[Allow Invoice Disc_]	as	DiscInd	,
	NVLINE.[Gross Weight]	as	GrossWght	,
	NVLINE.[Net Weight]	as	NetWght	,
	NVLINE.[Unit Cost]	as	UnitCost	,
	NVLINE.[Bin Code]	as	BinLoc	,
	NVLINE.[Cross-Reference Type No_]	as	CustItemNo	,
	NVLINE.[Net Unit Price]	as	NetUnitPrice	,
	NVLINE.[Line Cost]	as	OECost,
	SOHeaderHist.EntryID as EntryID,
	SOHeaderHist.EntryDt as EntryDt	
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Cr_Memo Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Cr_Memo Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	SOHeaderHist ON [Document No_] = SOHeaderHist.InvoiceNo
WHERE	NVHDR.[ERP Upload Flag]=0 AND NVLINE.Type=1 and NVLINE.No_ = '3021' AND
	SOHeaderHist.[ARPostDt] > Cast('2006-08-26 00:00:00.000' as DATETIME)





--[Porteous$Sales Cr_Memo Line] - Expense Lines
select
	SOHeaderHist.pSOHeaderHistID as fSOHeaderHistID,
--[Document No_],
	NVLINE.[Line No_]	as	LineNumber	,
	NVLINE.[No_]		as	ExpenseCd	,
	NVLINE.[Quantity] * [Unit Price] * -1		as	Amount		,
	NVLINE.[Type]		as	ExpenseInd	,
	'N'		as	TaxStatus	,
	SOHeaderHist.InvoiceNo	as	DocumentLoc,
	SOHeaderHist.EntryID as EntryID,
	SOHeaderHist.EntryDt as EntryDt	
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Cr_Memo Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLt;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Sales Cr_Memo Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	SOHeaderHist ON [Document No_] = SOHeaderHist.InvoiceNo
WHERE	NVHDR.[ERP Upload Flag]=0 AND ((NVLINE.Type=1 and NVLINE.No_<>'3021') OR (NVLINE.Type<>1 AND NVLINE.Type<>2)) AND
	SOHeaderHist.[ARPostDt] > Cast('2006-08-26 00:00:00.000' as DATETIME)
