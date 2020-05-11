--1--Reset ShipLoc, ShipLocName and IMLoc to null  (1 minute)
--2--UPDATE Empty SOHeader.CustShipLoc from CustomerMaster  (0 minutes [0 rows])
--3--UPDATE SODetail.IMLoc FROM [Porteous$Sales Line].[Location Code]  (1 minute)
--4--UPDATE SOHeader.ShipLoc FROM SODetail.IMLoc  (1 minute)
--5--UPDATE Empty SODetail.IMLoc FROM SOHeader.CustShipLoc  (1 minute)
--6--UPDATE Empty SOHeader.ShipLoc FROM SOHeader.CustShipLoc  (1 minute)
--7--UPDATE SOHeader.ShipLocName FROM LocMaster.LocName  (1 minute)


--Reset ShipLoc, ShipLocName and IMLoc to null  (1 minute)
UPDATE	SOHeader SET ShipLoc = null, ShipLocName = null
WHERE	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)

UPDATE	SODetail SET IMLoc = null FROM SOHeader
WHERE	pSOHeaderID = SODetail.fSOHeaderID AND 
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


--UPDATE Empty SOHeader.CustShipLoc from CustomerMaster  (0 minutes [0 rows])
UPDATE	SOHeader
SET	CustShipLoc = CASE WHEN Cust.ShipLocation = 0 OR Cust.ShipLocation = '' or Cust.ShipLocation is null
			   THEN Cust.CustShipLocation
			   ELSE Cust.ShipLocation
		      END
FROM	CustomerMaster Cust
WHERE	Cust.CustNo = SellToCustNo AND
	(CustShipLoc = 0 OR CustShipLoc = '' or CustShipLoc is null) AND 
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


--UPDATE SODetail.IMLoc FROM [Porteous$Sales Line].[Location Code]  (1 minute)
UPDATE	SODetail
SET	IMLoc = NVLINE.Loc
FROM	SOHeader INNER JOIN
	(SELECT	Lin.[Document No_] AS Doc, Lin.[Line No_] AS Line, Lin.[Location Code] AS Loc
	 FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] Hdr Inner join
		OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Line] Lin
	 ON	Hdr.[No_] = Lin.[Document No_]
	 WHERE	EXISTS (SELECT	RefSONo
			FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
			WHERE	TempSO.RefSONo = Hdr.[No_])) NVLINE
ON	RefSONo = NVLINE.Doc COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	pSOHeaderID = SODetail.fSOHeaderID and LineNumber = NVLINE.Line AND 
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


--UPDATE SOHeader.ShipLoc FROM SODetail.IMLoc  (1 minute)
UPDATE	SOHeader
SET	ShipLoc = Dtl.IMLoc
FROM	(SELECT	DISTINCT fSOHeaderID, IMLoc
	 FROM	SODetail
	 WHERE	IMLoc <> 0 and IMLoc <> '' and IMLoc is not null) Dtl
WHERE	pSOHeaderID = Dtl.fSOHeaderID AND 
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


--UPDATE Empty SODetail.IMLoc FROM SOHeader.CustShipLoc  (0 minutes [0 rows])
UPDATE	SODetail
SET	IMLoc = CustShipLoc
FROM	SOHeader
WHERE	pSOHeaderID = SODetail.fSOHeaderID and
	(IMLoc = 0 or IMLoc = '' or IMLoc is null) AND 
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


--UPDATE Empty SOHeader.ShipLoc FROM SOHeader.CustShipLoc  (0 minutes [0 rows])
UPDATE	SOHeader
SET	ShipLoc = CustShipLoc
WHERE	(ShipLoc = 0 or ShipLoc = '' or ShipLoc is null) AND 
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


--UPDATE SOHeader.ShipLocName FROM LocMaster.LocName  (1 minute)
UPDATE	SOHeader
SET	ShipLocName = LocName
FROM	LocMaster Loc
WHERE	Loc.LocID = ShipLoc AND 
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)
