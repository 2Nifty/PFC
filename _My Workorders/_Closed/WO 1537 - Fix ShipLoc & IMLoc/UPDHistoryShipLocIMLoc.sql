--1--Reset ShipLoc, ShipLocName and IMLoc to null  (3 minutes)
--2--UPDATE Empty SOHeaderHist.CustShipLoc from CustomerMaster  (3 minutes)
--3--UPDATE SODetailHist.IMLoc FROM [Porteous$Sales Invoice Line].[Location Code]  (25 minutes)
--4--UPDATE SODetailHist.IMLoc FROM [Porteous$Sales Cr_Memo Line].[Location Code]  (2 minutes)
--5--UPDATE SOHeaderHist.ShipLoc FROM SODetailHist.IMLoc  (3 minutes)
--6--UPDATE Empty SODetailHist.IMLoc FROM SOHeaderHist.CustShipLoc  (1 minute)
--7--UPDATE Empty SOHeaderHist.ShipLoc FROM SOHeaderHist.CustShipLoc  (1 minute)
--8--UPDATE SOHeaderHist.ShipLocName FROM LocMaster.LocName  (3 minutes)


--Reset ShipLoc, ShipLocName and IMLoc to null  (3 minutes)
UPDATE SOHeaderHist SET ShipLoc = null, ShipLocName = null WHERE SubType is not null
UPDATE SODetailHist SET IMLoc = null FROM SOHeaderHist WHERE pSOHeaderHistID = fSOHeaderHistID and SubType is not null


--UPDATE Empty SOHeaderHist.CustShipLoc from CustomerMaster  (3 minutes)
UPDATE	SOHeaderHist
SET	CustShipLoc = CASE WHEN Cust.ShipLocation = 0 OR Cust.ShipLocation = '' or Cust.ShipLocation is null
			   THEN Cust.CustShipLocation
			   ELSE Cust.ShipLocation
		      END
FROM	CustomerMaster Cust
WHERE	SubType is not null AND Cust.CustNo = SellToCustNo AND
	(CustShipLoc = 0 OR CustShipLoc = '' or CustShipLoc is null)


--UPDATE SODetailHist.IMLoc FROM [Porteous$Sales Invoice Line].[Location Code]  (25 minutes)
UPDATE	SODetailHist
SET	IMLoc = NVLINE.Loc
FROM	SOHeaderHist INNER JOIN
	(SELECT	Lin.[Document No_] AS Doc, Lin.[Line No_] AS Line, Lin.[Location Code] AS Loc
	 FROM	PFCLive.dbo.[Porteous$Sales Invoice Header] Hdr Inner join
		PFCLive.dbo.[Porteous$Sales Invoice Line] Lin
	 ON	Hdr.[No_] = Lin.[Document No_]
	 WHERE  --Lin.Type=2 AND Lin.No_ <> '' AND
		Hdr.[Posting Date] > Cast('2006-08-26 00:00:00.000' as DATETIME)) NVLINE
ON	InvoiceNo = NVLINE.Doc COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	pSOHeaderHistID = fSOHeaderHistID and SubType is not null and LineNumber = NVLINE.Line


--UPDATE SODetailHist.IMLoc FROM [Porteous$Sales Cr_Memo Line].[Location Code]  (2 minutes)
UPDATE	SODetailHist
SET	IMLoc = NVLINE.Loc
FROM	SOHeaderHist INNER JOIN
	(SELECT	Lin.[Document No_] AS Doc, Lin.[Line No_] AS Line, Lin.[Location Code] AS Loc
	 FROM	PFCLive.dbo.[Porteous$Sales Cr_Memo Header] Hdr Inner join
		PFCLive.dbo.[Porteous$Sales Cr_Memo Line] Lin
	 ON	Hdr.[No_] = Lin.[Document No_]
	 WHERE  --Lin.Type=2 AND Lin.No_ <> '' AND
		Hdr.[Posting Date] > Cast('2006-08-26 00:00:00.000' as DATETIME)) NVLINE
ON	InvoiceNo = NVLINE.Doc COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	pSOHeaderHistID = fSOHeaderHistID and SubType is not null and LineNumber = NVLINE.Line


--UPDATE SOHeaderHist.ShipLoc FROM SODetailHist.IMLoc  (3 minutes)
UPDATE	SOHeaderHist
SET	ShipLoc = Dtl.IMLoc
FROM	(SELECT	DISTINCT fSOHeaderHistID, IMLoc
	 FROM	SODetailHist
	 WHERE	IMLoc <> 0 and IMLoc <> '' and IMLoc is not null) Dtl
WHERE	pSOHeaderHistID = Dtl.fSOHeaderHistID and SubType is not null


--UPDATE Empty SODetailHist.IMLoc FROM SOHeaderHist.CustShipLoc  (1 minute)
UPDATE	SODetailHist
SET	IMLoc = CustShipLoc
FROM	SOHeaderHist
WHERE	pSOHeaderHistID = fSOHeaderHistID and SubType is not null and 
	(IMLoc = 0 or IMLoc = '' or IMLoc is null)


--UPDATE Empty SOHeaderHist.ShipLoc FROM SOHeaderHist.CustShipLoc  (1 minute)
UPDATE	SOHeaderHist
SET	ShipLoc = CustShipLoc
WHERE	SubType is not null and 
	(ShipLoc = 0 or ShipLoc = '' or ShipLoc is null)


--UPDATE SOHeaderHist.ShipLocName FROM LocMaster.LocName  (3 minutes)
UPDATE	SOHeaderHist
SET	ShipLocName = LocName
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.LocMaster Loc
WHERE	Loc.LocID = ShipLoc and SubType is not null
