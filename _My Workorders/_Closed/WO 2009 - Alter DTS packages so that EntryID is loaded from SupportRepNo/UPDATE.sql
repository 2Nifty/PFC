

----------------------------------------------------------------------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tW2009_SOHeaderHist]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tW2009_SOHeaderHist]
GO


DECLARE	@ARPostDt VARCHAR(20)

SET @ARPostDt = CAST (FLOOR (CAST (GetDate() AS FLOAT)) AS DATETIME)


select
	[No_]				as	InvoiceNo	,	--CAST		
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
	CAST(@ARPostDt AS DATETIME)	as	ArPostDt	,	
	CAST(@ARPostDt AS DATETIME)	as	InvoiceDt	,
	[Shipment Date]			as	SchShipDt	,	
	[Payment Terms Code]		as	OrderTermsCd	,	
	[Due Date]			as	OrderPromDt	,	
	[Payment Discount %]		as	DiscPct	,	
	[Shipment Method Code]		as	OrderMethCd	,	
	[Location Code]			as	ShipLoc	,	
	[Shortcut Dimension 1 Code]	as	CustShipLoc	,
	[Invoice Disc_ Code]		as	DiscountCd	,	
	[Salesperson Code]		as	SalesRepNo	,	
	[Order No_]			as	RefSONo	,		
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
	[Sales Location]		as	OrderLoc	,	
	[Order Type]			as	OrderType	,	
	[Entered User ID]		as	EntryId	,	--CAST	
	[Entered Date]			as	EntryDt	,	
	[Inside Salesperson Code]	as	CustSvcRepName	,	
	[Phone No_]			as	PhoneNo	,	
	[Phone No_]			as	SellToContactPhoneNo	,	
	[Phone No_]			as	BillToContactPhoneNo	,	
	[Fax No_]			as	FaxNo
INTO	tW2009_SOHeaderHist
FROM	[Porteous$Sales Invoice Header]
WHERE	--[ERP Upload Flag]=0 AND
	--[Posting Date] > Cast('2006-08-26 00:00:00.000' as DATETIME)
	[Posting Date] > CAST (FLOOR (CAST (GetDate()-5 AS FLOAT)) AS DATETIME)
	and [Sell-to Customer No_] in ( '063881','200301')


select EntryId, * from tW2009_SOHeaderHist


select	left(convert(Varchar(255),Isnull(Rep.RepNotes,SO.EntryId)),50), SO.EntryId, SO.*
From	tW2009_SOHeaderHist SO (NOLOCK) INNER JOIN
	PFCReports.dbo.CustomerMaster Cust (NOLOCK)
ON	SO.SellToCustNo = Cust.CustNo COLLATE SQL_Latin1_General_CP1_CI_AS Left outer JOIN
	PFCReports.dbo.RepMaster Rep (NOLOCK)
ON 	Cust.SupportRepNo = Rep.RepNo COLLATE SQL_Latin1_General_CP1_CI_AS




--UPDATE Header EntryID
UPDATE	tW2009_SOHeaderHist
SET	EntryId = left(convert(Varchar(255),Isnull(Rep.RepNotes,SO.EntryId)),50)
FROM	tW2009_SOHeaderHist SO (NOLOCK) INNER JOIN
	CustomerMaster Cust (NOLOCK)
ON	SO.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
	RepMaster Rep (NOLOCK)
ON 	Cust.SupportRepNo = Rep.RepNo




----------------------------------------------------------------------------------------------------------------



--UPDATE Header EntryID from RepMaster based on CustomerMaster.SupportRepNo
UPDATE	tWO778_SOHeaderHist
SET	EntryId = left(convert(Varchar(255),Isnull(Rep.RepNotes,SO.EntryId)),50)
FROM	tWO778_SOHeaderHist SO (NOLOCK) INNER JOIN
	CustomerMaster Cust (NOLOCK)
ON	SO.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
	RepMaster Rep (NOLOCK)
ON 	Cust.SupportRepNo = Rep.RepNo



---------------------------------------------------------------------------------------------------------


--UPDATE SOHeader EntryID from RepMaster based on CustomerMaster.SupportRepNo
UPDATE	SOHeader
SET	EntryId = left(convert(Varchar(255),Isnull(Rep.RepNotes,SO.EntryId)),50)
FROM	SOHeader SO (NOLOCK) INNER JOIN
	CustomerMaster Cust (NOLOCK)
ON	SO.SellToCustNo = Cust.CustNo LEFT OUTER JOIN
	RepMaster Rep (NOLOCK)
ON 	Cust.SupportRepNo = Rep.RepNo
WHERE	EXISTS (SELECT	RefSONo
		FROM	tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SO.RefSONo)







UPDATE	tWO1376_Daily_SO_EDI_To_ERP
set RefSONo = left(RefSONo,9)


select * from tWO1376_Daily_SO_EDI_To_ERP


select EntryID, SellToCustNo, * from SOHeader
WHERE	EXISTS (SELECT	RefSONo
		FROM	tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


UPDATE SOHeader
SET EntryID='TOD'
FROM	SOHeader SO
WHERE	EXISTS (SELECT	RefSONo
		FROM	tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SO.RefSONo)