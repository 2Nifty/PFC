select [Posting Date], 
* from [Porteous$Sales Cr_Memo Line]
where

[Document No_]='SCR168576' or
[Document No_]='SCR168577' or
[Document No_]='SCR169082' or
[Document No_]='SCR169084' or
[Document No_]='SCR169106' or
[Document No_]='SCR169800' or
[Document No_]='SCR169801' or
[Document No_]='SCR169802' or
[Document No_]='SCR169989' or
[Document No_]='SCR170824'


select [Posting Date], 
* from [Porteous$Sales Cr_Memo Line]
where
[Document No_]='SCR168576' or
[Document No_]='SCR168577' or
[Document No_]='SCR168827' or
[Document No_]='SCR169082' or
[Document No_]='SCR169084' or
[Document No_]='SCR169106' or
[Document No_]='SCR169800' or
[Document No_]='SCR169801' or
[Document No_]='SCR169802' or
[Document No_]='SCR169989' or
[Document No_]='SCR170633' or
[Document No_]='SCR170753' or
[Document No_]='SCR170754' or
[Document No_]='SCR170755' or
[Document No_]='SCR170756' or
[Document No_]='SCR170757' or
[Document No_]='SCR170824' or
[Document No_]='SCR172652' or
[Document No_]='SCR172653' or
[Document No_]='SCR172655' or
[Document No_]='SCR172656' or
[Document No_]='SCR172657' or
[Document No_]='SCR172659' or
[Document No_]='SCR172660' or
[Document No_]='SCR172661'




select [Posting Date], 
* from [Porteous$Sales Cr_Memo Header]
where
[No_]='SCR168576' or
[No_]='SCR168577' or
[No_]='SCR168827' or
[No_]='SCR169082' or
[No_]='SCR169084' or
[No_]='SCR169106' or
[No_]='SCR169800' or
[No_]='SCR169801' or
[No_]='SCR169802' or
[No_]='SCR169989' or
[No_]='SCR170633' or
[No_]='SCR170753' or
[No_]='SCR170754' or
[No_]='SCR170755' or
[No_]='SCR170756' or
[No_]='SCR170757' or
[No_]='SCR170824' or
[No_]='SCR172652' or
[No_]='SCR172653' or
[No_]='SCR172655' or
[No_]='SCR172656' or
[No_]='SCR172657' or
[No_]='SCR172659' or
[No_]='SCR172660' or
[No_]='SCR172661'




 [ERP Upload Flag]<>1
[No_]='SCR170753' or [No_]='SCR170754' or [No_]='SCR170757'
--[Document No_]='SCR170753' or [Document No_]='SCR170754' or [Document No_]='SCR170757'




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
	[Posting Date]		 as 	InvoiceDt	,
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
--	[Sell-to Contact No_]	 as 	SellToContactPhoneNo	,
--	[Bill-to Contact No_]	 as 	BillToContactPhoneNo	,
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
	[Phone No_]		 as 	SellToContactPhoneNo	,
	[Phone No_]		 as 	BillToContactPhoneNo	,
	[Fax No_]		 as 	FaxNo	
FROM	[Porteous$Sales Cr_Memo Header]
WHERE	[ERP Upload Flag]=0 AND [Posting Date] > Cast('2006-08-26 00:00:00.000' as DATETIME)





--[Porteous$Sales Cr_Memo Line]
select
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
	NVLINE.[Cross-Reference No_]	as	CustItemNo	,
	NVLINE.[Net Unit Price]	as	NetUnitPrice	,
	NVLINE.[Line Cost]	as	OECost,
	NVLINE.[Quantity] * NVLINE.[Net Unit Price] * -1 as ExtendedPrice ,
	NVLINE.[Quantity] * NVLINE.[Unit Cost] * -1 as ExtendedCost ,
	NVLINE.[Quantity] * NVLINE.[Net Weight] * -1 as ExtendedNetWght ,
	NVLINE.[Quantity] * NVLINE.[Gross Weight] * -1 as ExtendedGrossWght ,
	NVLINE.[Usage Location] as UsageLoc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Cr_Memo Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Cr_Memo Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_]
WHERE	NVHDR.[ERP Upload Flag]=0 AND NVLINE.Type=2 AND NVLINE.No_ <> ''






update [Porteous$Sales Cr_Memo Header]
set [ERP Upload Flag]=1
from [Porteous$Sales Cr_Memo Header]
where [No_]='SCR170753' or [No_]='SCR170754' or [No_]='SCR170757'



select ARPostDt, * from SOHeaderHist where 


--delete from SOHeaderHist where 
InvoiceNo='SCR168576' or
InvoiceNo='SCR168577' or
InvoiceNo='SCR168827' or
InvoiceNo='SCR169082' or
InvoiceNo='SCR169084' or
InvoiceNo='SCR169106' or
InvoiceNo='SCR169800' or
InvoiceNo='SCR169801' or
InvoiceNo='SCR169802' or
InvoiceNo='SCR169989' or
InvoiceNo='SCR170633' or
InvoiceNo='SCR170753' or
InvoiceNo='SCR170754' or
InvoiceNo='SCR170755' or
InvoiceNo='SCR170756' or
InvoiceNo='SCR170757' or
InvoiceNo='SCR170824' or
InvoiceNo='SCR172652' or
InvoiceNo='SCR172653' or
InvoiceNo='SCR172655' or
InvoiceNo='SCR172656' or
InvoiceNo='SCR172657' or
InvoiceNo='SCR172659' or
InvoiceNo='SCR172660' or
InvoiceNo='SCR172661'




[InvoiceNo]='SCR170753' or [InvoiceNo]='SCR170754' or [InvoiceNo]='SCR170757'



select * from SODetailHist where 
fSOHeaderHistID='880331' or
fSOHeaderHistID='880332' or
fSOHeaderHistID='954429' or
fSOHeaderHistID='954431' or
fSOHeaderHistID='954710' or
fSOHeaderHistID='954379' or
fSOHeaderHistID='954380' or
fSOHeaderHistID='954381' or
fSOHeaderHistID='958381' or
fSOHeaderHistID='981006'