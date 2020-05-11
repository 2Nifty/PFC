


Declare	@LastDate DATETIME
SET @LastDate='2008-Jul-07'
--select CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))


select count(*) as Headers, SUM(TotalOrder) as Price, SUM(TotalCost) as Cost from SOHeaderHist 
WHERE	ARPostDt = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))


SELECT     COUNT(*)
FROM         SOHeaderHist INNER JOIN
                      SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
WHERE	ARPostDt = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))




Declare	@LastDate DATETIME
SET @LastDate='2008-Jul-07'

select * from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.[DashBoardCreditHeaderTemp] NVHDR
where NOT EXISTS (SELECT InvoiceNo from SOHeaderHist WHERE NVHDR.[No_]=InvoiceNo) and 
NVHDR.[Posting Date] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))


select count(*)
from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.[DashBoardInvoiceHeaderTemp] NVHDR
where NVHDR.[Posting Date] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))


select count(*) from SOHeaderHist where
ARPostDt = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))






----------------------------------------------------------------------------------------------------------------------------


Declare	@LastDate DATETIME
SET @LastDate='2008-Jul-01'
--select CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))


select count(*) as Headers, SUM(TotalOrder) as Price, SUM(TotalCost) as Cost from SOHeaderHist 
WHERE	ARPostDt = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))


SELECT     COUNT(*)
FROM         SOHeaderHist INNER JOIN
                      SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
WHERE	ARPostDt = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))




SELECT     InvoiceNo
FROM         SOHeaderHist INNER JOIN
                      SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
--WHERE	OrderType=51 and (SODetailHist.UnitCost < 0 or SODetailHist.ListUnitPrice < 0)
WHERE	SODetailHist.ItemNo='00000-0000-000'



ARPostDt = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))


UPDATE	SODetailHist
SET	UnitCost = UnitCost * -1
FROM	SOHeaderHist INNER JOIN
	SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
WHERE	OrderType=51 and SODetailHist.UnitCost is not null and SODetailHist.ListUnitPrice is not null



UPDATE SODetailHist
SET QtyOrdered = QtyOrdered * -1
FROM         SOHeaderHist INNER JOIN
                      SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
WHERE	OrderType=51


--UPDATE THE HEADER RECORDS
UPDATE	SOHeaderHist
SET	totalCost = ExtAvgCost
FROM	(SELECT	InvoiceNo, SUM(SODetailHist.QtyOrdered * SODetailHist.UnitCost) as ExtAvgCost
	 FROM	SODetailHist INNER JOIN
		SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID
	 Group By InvoiceNo) ExtCost 
WHERE	ExtCost.InvoiceNo = SoHeaderHist.InvoiceNo


UPDATE	SOHeaderHist
SET	TotalOrder = OrderExt
FROM	(SELECT	InvoiceNo, SUM(SODetailHist.QtyOrdered * SODetailHist.ListUnitPrice) as OrderExt
	 FROM	SODetailHist INNER JOIN
		SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID
	 Group By InvoiceNo) ExtOrder
WHERE	ExtOrder.InvoiceNo = SoHeaderHist.InvoiceNo






 and SODetailHist.UnitCost is not null and SODetailHist.ListUnitPrice is not null




Declare	@LastDate DATETIME

SET	@LastDate = '2008-Jun-30'

select
	SOHeaderHist.pSOHeaderHistID as fSOHeaderHistID,
	[Line No_]	as	LineNumber	,
	[Type]	as	LineType	,
	[No_]	as	ItemNo	,
	[Location Code]	as	ImLoc	,
	[Shipment Date]	as	OrigShipDate	,
	[Description]	as	ItemDsc	,
	[Quantity] * -1	as	QtyOrdered
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Cr_Memo Line] INNER JOIN
	SOHeaderHist ON [Document No_] = SOHeaderHist.InvoiceNo
WHERE	Type=2 and No_ <> '' and 
		[Posting Date] > CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))






select
	SOHeaderHist.pSOHeaderHistID as fSOHeaderHistID,
	[Line No_]	as	LineNumber	,
	[Type]	as	LineType	,
	'00000-0000-000'	as	ItemNo	,
	[Location Code]	as	ImLoc	,
	[Shipment Date]	as	OrigShipDate	,
	[Description]	as	ItemDsc	,
	[Quantity]	as	QtyOrdered	,
	[Unit Price]	as	ListUnitPrice	,
--	[Line Discount %]	as	DiscPct1	,
	[Allow Invoice Disc_]	as	DiscInd	,
--	[Unit Cost]	as	UnitCost	,
	[Bin Code]	as	BinLoc	,
	[Cross-Reference Type No_]	as	CustItemNo	,
	[Net Unit Price]	as	NetUnitPrice	,
	[Line Cost]	as	OECost
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Line] INNER JOIN
	SOHeaderHist ON [Document No_] = SOHeaderHist.InvoiceNo
WHERE	--Type=3 and 
No_ = '3021' and
		SOHeaderHist.[ARPostDt] > Cast('2006-08-26 00:00:00.000' as DATETIME)




select
	SOHeaderHist.pSOHeaderHistID as fSOHeaderHistID,
	[Line No_]	as	LineNumber	,
	[Type]	as	LineType	,
	'00000-0000-000'	as	ItemNo	,
	[Location Code]	as	ImLoc	,
	[Shipment Date]	as	OrigShipDate	,
	[Description]	as	ItemDsc	,
	[Quantity] * -1	as	QtyOrdered	,
	[Unit Price]	as	ListUnitPrice	,
--	[Line Discount %]	as	DiscPct1	,
	[Allow Invoice Disc_]	as	DiscInd	,
--	[Unit Cost]	as	UnitCost	,
	[Bin Code]	as	BinLoc	,
	[Cross-Reference Type No_]	as	CustItemNo	,
	[Net Unit Price]	as	NetUnitPrice	,
	[Line Cost]	as	OECost
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Cr_Memo Line] INNER JOIN
	SOHeaderHist ON [Document No_] = SOHeaderHist.InvoiceNo
WHERE	--Type=3 and 
No_ = '3021' and
		SOHeaderHist.[ARPostDt] > Cast('2006-08-26 00:00:00.000' as DATETIME)

