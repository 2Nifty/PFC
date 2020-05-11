select InvoiceNo, ARPostDt, ShipLoc, IMLoc
from	SOHeaderHist Hdr inner join
	SODetailHist Lin
on	Hdr.pSOHeaderHistID = Lin.fSOheaderHistID
where ShipLoc <> IMLoc and 
--	(ShipLoc='' or IMLoc='') and
 (ARPostDt BETWEEN CONVERT(DATETIME, '2009-08-30 00:00:00', 102) AND CONVERT(DATETIME, '2009-09-26 00:00:00', 102))
order by InvoiceNo




select ShipLoc, pSOHeaderHistID, InvoiceNo, ARPostDt, * from tSOHeaderHist where InvoiceNo='IP2847888' or InvoiceNo='IP2853049' or InvoiceNo='IP2857970' order by InvoiceNo
select IMLoc, fSOHeaderHistID, ItemNo, * from tSODetailHist where fSOHeaderHistID=1253109 or fSOHeaderHistID=1257804 or fSOHeaderHistID=1263747 order by fSOHeaderHistID

 
 
select * from tSOHeaderHist
WHERE	SubType is not null AND
	(CustShipLoc = 0 OR CustShipLoc = '' or CustShipLoc is null)


UPDATE	tSOHeaderHist
set	CustShipLoc=tmp.Loc
from	(select InvoiceNo as Invoice, CustShipLoc as Loc from SOHeaderHist
	 WHERE	SubType is not null AND
		(CustShipLoc = 0 OR CustShipLoc = '' or CustShipLoc is null)) tmp
where InvoiceNo = tmp.Invoice


-----------------------------------------------------------------------------------------------

--Reset ShipLoc, ShipLocName and IMLoc to null  (3 minutes)
UPDATE tSOHeaderHist SET ShipLoc = null, ShipLocName = null WHERE SubType is not null
UPDATE tSODetailHist SET IMLoc = null FROM tSOheaderHist WHERE pSOHeaderHistID = fSOHeaderHistID and SubType is not null


--UPDATE Empty SOHeaderHist.CustShipLoc from CustomerMaster  (3 minutes)
UPDATE	tSOHeaderHist
SET	CustShipLoc = CASE WHEN Cust.ShipLocation = 0 OR Cust.ShipLocation = '' or Cust.ShipLocation is null
			   THEN Cust.CustShipLocation
			   ELSE Cust.ShipLocation
		      END
FROM	CustomerMaster Cust
WHERE	SubType is not null AND Cust.CustNo = SellToCustNo AND
	(CustShipLoc = 0 OR CustShipLoc = '' or CustShipLoc is null)


--UPDATE SODetailHist.IMLoc FROM [Porteous$Sales Invoice Line].[Location Code]  (25 minutes)
UPDATE	tSODetailHist
SET	IMLoc = NVLINE.Loc
FROM	tSOHeaderHist INNER JOIN
	(SELECT	Lin.[Document No_] AS Doc, Lin.[Line No_] AS Line, Lin.[Location Code] AS Loc
	 FROM	PFCLive.dbo.[Porteous$Sales Invoice Header] Hdr Inner join
		PFCLive.dbo.[Porteous$Sales Invoice Line] Lin
	 ON	Hdr.[No_] = Lin.[Document No_]
	 WHERE  --Lin.Type=2 AND Lin.No_ <> '' AND
		Hdr.[Posting Date] > Cast('2006-08-26 00:00:00.000' as DATETIME)) NVLINE
ON	InvoiceNo = NVLINE.Doc COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	pSOHeaderHistID = fSOHeaderHistID and SubType is not null and LineNumber = NVLINE.Line


--UPDATE SODetailHist.IMLoc FROM [Porteous$Sales Cr_Memo Line].[Location Code]  (2 minutes)
UPDATE	tSODetailHist
SET	IMLoc = NVLINE.Loc
FROM	tSOHeaderHist INNER JOIN
	(SELECT	Lin.[Document No_] AS Doc, Lin.[Line No_] AS Line, Lin.[Location Code] AS Loc
	 FROM	PFCLive.dbo.[Porteous$Sales Cr_Memo Header] Hdr Inner join
		PFCLive.dbo.[Porteous$Sales Cr_Memo Line] Lin
	 ON	Hdr.[No_] = Lin.[Document No_]
	 WHERE  --Lin.Type=2 AND Lin.No_ <> '' AND
		Hdr.[Posting Date] > Cast('2006-08-26 00:00:00.000' as DATETIME)) NVLINE
ON	InvoiceNo = NVLINE.Doc COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	pSOHeaderHistID = fSOHeaderHistID and SubType is not null and LineNumber = NVLINE.Line


--UPDATE SOHeaderHist.ShipLoc FROM SODetailHist.IMLoc  (3 minutes)
UPDATE	tSOHeaderHist
SET	ShipLoc = Dtl.IMLoc
FROM	(SELECT	DISTINCT fSOHeaderHistID, IMLoc
	 FROM	tSODetailHist
	 WHERE	IMLoc <> 0 and IMLoc <> '' and IMLoc is not null) Dtl
WHERE	pSOHeaderHistID = Dtl.fSOHeaderHistID and SubType is not null


--UPDATE Empty SODetailHist.IMLoc FROM SOHeaderHist.CustShipLoc  (1 minute)
UPDATE	tSODetailHist
SET	IMLoc = CustShipLoc
FROM	tSOHeaderHist
WHERE	pSOHeaderHistID = fSOHeaderHistID and SubType is not null and 
	(IMLoc = 0 or IMLoc = '' or IMLoc is null)


--UPDATE Empty SOHeaderHist.ShipLoc FROM SOHeaderHist.CustShipLoc  (1 minute)
UPDATE	tSOHeaderHist
SET	ShipLoc = CustShipLoc
WHERE	SubType is not null and 
	(ShipLoc = 0 or ShipLoc = '' or ShipLoc is null)


--UPDATE SOHeaderHist.ShipLocName FROM LocMaster.LocName  (3 minutes)
UPDATE	tSOHeaderHist
SET	ShipLocName = LocName
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.LocMaster Loc
WHERE	Loc.LocID = ShipLoc and SubType is not null


-----------------------------------------------------------------------------------------------

select IMLoc, ShipLoc, ShipLocName, CustShipLoc
from	tSOHeaderHist inner join tSODetailHist
on	pSOHeaderHistID = fSOHeaderHistID
where SubType is not null
and (IMLoc = '' or IMLoc is null or IMLoc = 0 or ShipLoc = '' or ShipLoc is null or ShipLoc = 0)



select IMLoc, ShipLoc, ShipLocName, CustShipLoc, InvoiceNo, SellToCustNo, LineNumber
from	tSOHeaderHist left outer  join tSODetailHist
on	pSOHeaderHistID = fSOHeaderHistID
where  [InvoiceNo]='IP2301092' or [InvoiceNo]='IP1765857' or [InvoiceNo]='IP2847888' or [InvoiceNo]='IP2434538' or [InvoiceNo]='IP2853049'
order by InvoiceNo, LineNumber

select
CustNo,
CustShipLocation,
ShipLocation
from CustomerMaster where (CustShipLocation is null or CustShipLocation=0 or CustShipLocation='') and
(ShipLocation is null or ShipLocation=0 or ShipLocation='')
order by CustNo



select * from tSODetailHist where IMLoc = '' or IMLoc is null -- or IMLoc = 0
select CustShipLoc, * from tSOHeaderHist where ShipLoc = '' or ShipLoc is null --or ShipLoc = 0
select CustShipLoc, * from tSOHeaderHist where  ShipLoc = 0


SET	IMLoc = CASE WHEN NVLINE.Loc = 0 OR NVLINE.Loc = '' or NVLINE.Loc is null
		     THEN CustShipLoc
		     ELSE NVLINE.Loc
		END






select ShipLoc, * from tSOHeaderHist where (ShipLoc='' or ShipLoc is null) and pSOHeaderHistID=34798
select IMLoc, * from tSODetailHist where fSOHeaderHistID=34798
select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.LocMaster
order by LocId


select IMLoc, * from tSODetailHist where IMLoc='' --or IMLoc is null


--one line with no header
select * from tSOHeaderHist where pSOHeaderHistID=1043596



select IMLoc, * from tSODetailHist where fSOHeaderHistID=34798



update tSOHeaderHist set ShipLocName=null




--UPDATE SOHeaderHist.ShipLoc [3 minutes]
UPDATE	tSOHeaderHist
SET	ShipLoc = Dtl.IMLoc--,
--	ShipLocName = Dtl.LocName
FROM	(SELECT	DISTINCT fSOHeaderHistID, IMLoc--, LocName
	 FROM	tSODetailHist --INNER JOIN
--		 OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.LocMaster
--	 ON IMLoc = LocID
	 WHERE	IMLoc <> '') Dtl
WHERE	pSOHeaderHistID = Dtl.fSOHeaderHistID





