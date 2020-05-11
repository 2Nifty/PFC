
--[Porteous$Sales Invoice Line]
select
	SOHeaderHist.pSOHeaderHistID as fSOHeaderHistID,
	[Line No_]	as	LineNumber	,
	[Type]	as	LineType	,
	[No_]	as	ItemNo	,
	[Location Code]	as	ImLoc	,
	[Shipment Date]	as	OrigShipDate	,
	[Description]	as	ItemDsc	,
	[Quantity]	as	QtyOrdered	,
	[Unit Price]	as	ListUnitPrice	,
--	[Line Discount %]	as	DiscPct1	,
	[Allow Invoice Disc_]	as	DiscInd	,
	[Unit Cost]	as	UnitCost	,
	[Bin Code]	as	BinLoc	,
	[Cross-Reference Type No_]	as	CustItemNo	,
	[Net Unit Price]	as	NetUnitPrice	,
	[Line Cost]	as	OECost
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Line] INNER JOIN
	SOHeaderHist ON [Document No_] = SOHeaderHist.InvoiceNo
WHERE	[Porteous$Sales Invoice Line].Type=2 and [Porteous$Sales Invoice Line].No_ <> ''


--[Porteous$Sales Cr_Memo Line]
select
	SOHeaderHist.pSOHeaderHistID as fSOHeaderHistID,
	[Line No_]	as	LineNumber	,
	[Type]	as	LineType	,
	[No_]	as	ItemNo	,
	[Location Code]	as	ImLoc	,
	[Shipment Date]	as	OrigShipDate	,
	[Description]	as	ItemDsc	,
	[Quantity]	as	QtyOrdered	,
	[Unit Price]	as	ListUnitPrice	,
--	[Line Discount %]	as	DiscPct1	,
	[Allow Invoice Disc_]	as	DiscInd	,
	[Unit Cost]	as	UnitCost	,
	[Bin Code]	as	BinLoc	,
	[Cross-Reference Type No_]	as	CustItemNo	,
	[Net Unit Price]	as	NetUnitPrice	,
	[Line Cost]	as	OECost
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Cr_Memo Line] INNER JOIN
	SOHeaderHist ON [Document No_] = SOHeaderHist.InvoiceNo
WHERE	Type=2 and No_ <> ''


--Delete Headers with no Lines
DELETE from SOHeaderHist
where NOT EXISTS 
(select *
FROM	SODetailHist
WHERE	SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID)





----------------------------------------------------------------------------------------------------------


select count(*) from SOHeaderHist



select * from SOHeaderHist
select * from SODetailHist