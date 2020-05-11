
exec sp_columns [Porteous$Purch_ Line Comment Line]


select * from [Porteous$Purch_ Line Comment Line]
select * from [Porteous$Purchase Header]
select * from [Porteous$Sales Line Comment Line]
select * from [Porteous$Sales Comment Line]

select

--	[No_]				as	InvoiceNo	,	--CAST		
	[Sell-to Customer No_]		as	SellToCustNo	,	
	[Bill-to Customer No_]		as	BillToCustNo	,	
	[Bill-to Name]			as	BillToCustName	,	

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
--	CAST(@ARPostDt AS DATETIME)	as	ArPostDt	,	
--	CAST(@ARPostDt AS DATETIME)	as	InvoiceDt	,
	[Shipment Date]			as	SchShipDt	,	

	[Payment Terms Code]		as	OrderTermsCd	,	
	[Due Date]			as	OrderPromDt	,	
	[Payment Discount %]		as	DiscPct	,	

	[Shipment Method Code]		as	OrderMethCd	,	
	[Location Code]			as	ShipLoc	,	
	[Shortcut Dimension 1 Code]	as	CustShipLoc	,
	[Invoice Disc_ Code]		as	DiscountCd	,	
	[Salesperson Code]		as	SalesRepNo	,	
--	[Order No_]			as	RefSONo	,		
	[No_ Printed]			as	CopiestoPrint	,	
	[Sell-to Customer Name]		as	SellToCustName	,	
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
	[External Document No_] 	as		CustPONo,	--CAST		
	[Shipping Agent Code]		as	OrderCarName	,	
	[Usage Location]		as	UsageLoc	,	
--	[Sales Location]		as	OrderLoc	,	
	[Order Type]			as	OrderType	,	
	[Entered User ID]		as	EntryId	,	--CAST	
	[Entered Date]			as	EntryDt	,	
	[Inside Salesperson Code]	as	CustSvcRepName	,	
	[Phone No_]			as	PhoneNo	,	
	[Phone No_]			as	SellToContactPhoneNo	,	
	[Phone No_]			as	BillToContactPhoneNo	,	
	[Fax No_]			as	FaxNo		--,	

FROM	[Porteous$Sales Header]