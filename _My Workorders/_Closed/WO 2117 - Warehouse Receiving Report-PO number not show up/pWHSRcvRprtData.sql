drop procedure pWHSRcvRprtData
go

CREATE PROCEDURE [dbo].[pWHSRcvRprtData]
	@Branch VARCHAR(10),
	@Container VARCHAR(30),
	@LPN VARCHAR(30)
AS
BEGIN
/*
	=============================================
	Author:	 Tom Slater
	Created: 10/13/2009
	Desc:	 Runs in ERP system to return a data for LPN receiving report
		  - When only a container number is passed, ERP controls the data
		  - When only an LPN number is passed, RB controls the data
		  - When both are passed, INNER JOIN both RB and ERP

	--------------------------------------------------------------------------------------------------------------------
	-       OpenDataSource connections used by the procedure must be changed when moving between DEV/QA and PROD	   -
	--------------------------------------------------------------------------------------------------------------------
	[DEV/QA]  OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').rbtest.dbo.BINLOCAT 
	[Prod]    OpenDataSource('SQLOLEDB','Data Source=PFCRFDB;User ID=pfcnormal;Password=pfcnormal').rbeacon.dbo.BINLOCAT 
	--------------------------------------------------------------------------------------------------------------------

	=============================================

	exec pWHSRcvRprtData '05','','05POCU0564018'
*/

	IF @LPN = '' and @Container <> ''	--only a container number is passed, ERP controls the data
	   BEGIN
		SELECT	DISTINCT
			 LPNData.LPNNo as LPN
			,LPNData.LocatiON as Location
			,LPNData.ItemNo as ItemNo
			,LPNData.ReceiptBin as Bin
			,ItemMaster.ItemDesc
			,coalesce(LPNData.EntryDt, RBData.DateCreate) as PostDate
			,coalesce(LPNData.LPNQty,RBData.QUANTITY) as OrigQty
			,coalesce(LPNData.ReceivedQty,0) as RcvdQty
			,coalesce(LPNData.IntransitQty,0) as ShippedQty
			,coalesce(RBData.QUANTITY,0) as OpenQty
			,isnull(LPNData.BOLNo,'No LPN Data') as BOLNo
			,isnull(LPNData.ContainerNo,'') as ContainerNo
			,isnull(LPNData.DocumentNo,'') as Doc
			,isnull(LPNData.OriginalDocNo,'') as OrigDoc
			,isnull(LPNData.InTransitLocation,'') as InTransit
			,isnull(LPNData.VendorCustNo,'') as Vendor
			,isnull(LPNData.SourceDocumentID,'') as SourceDoc1
			,isnull(LPNData.SourceDocumentID2,'') as SourceDoc2
			,coalesce(LPNData.TransactionUM,ItemMaster.SellStkUM, '') as UOM
			,ToLoc.LocName as ToLocName
			,ToLoc.LocAdress1 as ToLocAdress1
			,ToLoc.LocAdress2 as ToLocAdress2
			,ToLoc.LocCity + ', ' + ToLoc.LocState + '.  ' + ToLoc.LocPostCode as ToLocCityStZip
			,coalesce(FromLocation,substring(RBData.BINLABEL,7,8)) as FromLoc
			,coalesce(FromLocTransit.LocName, FromLocRcpt.LocName, 'LocMaster Missing for '+ substring(RBData.BINLABEL,7,8)) as FromLocName
			,coalesce(FromLocTransit.LocAdress1,FromLocRcpt.LocAdress1,'') as FromLocAdress1
			,coalesce(FromLocTransit.LocAdress2,FromLocRcpt.LocAdress2,'') as FromLocAdress2
			,coalesce(FromLocTransit.LocCity,FromLocRcpt.LocCity,'') + ', ' + coalesce(FromLocTransit.LocState,FromLocRcpt.LocState,'') + '.  ' + coalesce(FromLocTransit.LocPostCode,FromLocRcpt.LocPostCode,'') as FromLocCityStZip
		FROM	LPNAuditControl LPNData (NoLock) INNER JOIN
			ItemMaster (NoLock)
		ON	ItemMaster.ItemNo = LPNData.ItemNo LEFT OUTER JOIN
			(SELECT	DISTINCT
				LOCATION,
				LICENSE_PLATE, 
				BINLABEL,
				PRODUCT,
				sum(QUANTITY) as QUANTITY,
				min(DATECREATE) as DateCreate
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').rbtest.dbo.BINLOCAT 
			 WHERE	LOCATION = @Branch AND QUANTITY <> 0
			 GROUP BY LOCATION, BINLABEL, LICENSE_PLATE, PRODUCT) RBData
		ON	LPNData.LPNNo = RBData.LICENSE_PLATE and
			LPNData.LocatiON = RBData.LOCATION and
			LPNData.ReceiptBin = RBData.BINLABEL and
			LPNData.ItemNo = RBData.PRODUCT LEFT OUTER JOIN
			LocMaster ToLoc (NoLock)
		ON	LPNData.LocatiON = ToLoc.LocID LEFT OUTER JOIN
			LocMaster FromLocTransit (NoLock)
		ON	LPNData.FromLocatiON = FromLocTransit.LocID LEFT OUTER JOIN
			LocMaster FromLocRcpt (NoLock)
		ON	substring(RBData.BINLABEL,7,8) = FromLocRcpt.LocID
		WHERE	LPNData.ContainerNo = @Container --and LPNData.FromLocatiON = @Branch
	   end

	IF @LPN <> '' and @Container = ''	--only an LPN number is passed, RB controls the data
	   BEGIN
		SELECT	DISTINCT
			 RBData.LICENSE_PLATE as LPN
			,RBData.LOCATION as Location
			,RBData.PRODUCT as ItemNo
			,RBData.BINLABEL as Bin
			,ItemMaster.ItemDesc
			,coalesce(LPNData.EntryDt, RBData.DateCreate) as PostDate
			,isnull(LPNData.LPNQty,RBData.QUANTITY) as OrigQty
			,isnull(LPNData.ReceivedQty,0) as RcvdQty
			,isnull(LPNData.IntransitQty,0) as ShippedQty
			,RBData.QUANTITY as OpenQty
			,isnull(LPNData.BOLNo,'No LPN Data') as BOLNo
			,isnull(LPNData.ContainerNo,'') as ContainerNo
			,isnull(LPNData.DocumentNo,@LPN) as Doc
			,isnull(LPNData.OriginalDocNo,'') as OrigDoc
			,isnull(LPNData.InTransitLocation,'') as InTransit
			,isnull(LPNData.VendorCustNo,'') as Vendor
			,isnull(LPNData.SourceDocumentID,'') as SourceDoc1
			,isnull(LPNData.SourceDocumentID2,'') as SourceDoc2
			,coalesce(LPNData.TransactionUM,ItemMaster.SellStkUM, '') as UOM
			,ToLoc.LocName as ToLocName
			,ToLoc.LocAdress1 as ToLocAdress1
			,ToLoc.LocAdress2 as ToLocAdress2
			,ToLoc.LocCity + ', ' + ToLoc.LocState + '.  ' + ToLoc.LocPostCode as ToLocCityStZip
			,substring(RBData.BINLABEL,7,8) as FromLoc
			,isnull(FromLoc.LocName, 'LocMaster Missing for '+ substring(RBData.BINLABEL,7,8)) as FromLocName
			,isnull(FromLoc.LocAdress1,'') as FromLocAdress1
			,isnull(FromLoc.LocAdress2,'') as FromLocAdress2
			,isnull(FromLoc.LocCity,'') + ', ' + isnull(FromLoc.LocState,'') + '.  ' + isnull(FromLoc.LocPostCode,'') as FromLocCityStZip
		FROM	(SELECT	DISTINCT
				LOCATION,
				LICENSE_PLATE, 
				BINLABEL,
				PRODUCT,
				sum(QUANTITY) as QUANTITY,
				min(DATECREATE) as DateCreate
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').rbtest.dbo.BINLOCAT 
			 WHERE	LICENSE_PLATE = @LPN and LOCATION = @Branch and QUANTITY <> 0
			 GROUP BY LOCATION, BINLABEL, LICENSE_PLATE, PRODUCT) RBData INNER JOIN
			ItemMaster (NoLock)
		ON	ItemMaster.ItemNo = RBData.PRODUCT LEFT OUTER JOIN
			LPNAuditControl LPNData (NoLock)
		ON	LPNData.LPNNo = RBData.LICENSE_PLATE and
			LPNData.LocatiON = RBData.LOCATION and
			LPNData.ReceiptBin = RBData.BINLABEL and
			LPNData.ItemNo = RBData.PRODUCT LEFT OUTER JOIN
			LocMaster ToLoc (NoLock)
		ON	RBData.LOCATION = ToLoc.LocID LEFT OUTER JOIN
			LocMaster FromLoc (NoLock)
		ON	substring(RBData.BINLABEL,7,8) = FromLoc.LocID
	   END

	IF @LPN <> '' and @Container <> ''	--both are passed, INNER JOIN both RB and ERP
	   BEGIN
		SELECT	DISTINCT
			 RBData.LICENSE_PLATE as LPN
			,RBData.LOCATION as Location
			,RBData.PRODUCT as ItemNo
			,RBData.BINLABEL as Bin
			,ItemMaster.ItemDesc
			,coalesce(LPNData.EntryDt, RBData.DateCreate) as PostDate
			,isnull(LPNData.LPNQty,RBData.QUANTITY) as OrigQty
			,isnull(LPNData.ReceivedQty,0) as RcvdQty
			,coalesce(LPNData.IntransitQty,0) as ShippedQty
			,RBData.QUANTITY as OpenQty
			,isnull(LPNData.BOLNo,'No LPN Data') as BOLNo
			,isnull(LPNData.ContainerNo,'') as ContainerNo
			,isnull(LPNData.DocumentNo,'') as Doc
			,isnull(LPNData.OriginalDocNo,@LPN) as OrigDoc
			,isnull(LPNData.InTransitLocation,'') as InTransit
			,isnull(LPNData.VendorCustNo,'') as Vendor
			,isnull(LPNData.SourceDocumentID,'') as SourceDoc1
			,isnull(LPNData.SourceDocumentID2,'') as SourceDoc2
			,coalesce(LPNData.TransactionUM,ItemMaster.SellStkUM, '') as UOM
			,ToLoc.LocName as ToLocName
			,ToLoc.LocAdress1 as ToLocAdress1
			,ToLoc.LocAdress2 as ToLocAdress2
			,ToLoc.LocCity + ', ' + ToLoc.LocState + '.  ' + ToLoc.LocPostCode as ToLocCityStZip
			,coalesce(FromLocation,substring(RBData.BINLABEL,7,8)) as FromLoc
			,coalesce(FromLocTransit.LocName, FromLocRcpt.LocName, 'LocMaster Missing for '+ substring(RBData.BINLABEL,7,8)) as FromLocName
			,coalesce(FromLocTransit.LocAdress1,FromLocRcpt.LocAdress1,'') as FromLocAdress1
			,coalesce(FromLocTransit.LocAdress2,FromLocRcpt.LocAdress2,'') as FromLocAdress2
			,coalesce(FromLocTransit.LocCity,FromLocRcpt.LocCity,'') + ', ' + coalesce(FromLocTransit.LocState,FromLocRcpt.LocState,'') + '.  ' + coalesce(FromLocTransit.LocPostCode,FromLocRcpt.LocPostCode,'') as FromLocCityStZip
		FROM	(SELECT	DISTINCT
				LOCATION,
				LICENSE_PLATE, 
				BINLABEL,
				PRODUCT,
				sum(QUANTITY) as QUANTITY,
				min(DATECREATE) as DateCreate
				FROM OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').rbtest.dbo.BINLOCAT 
			 WHERE LICENSE_PLATE = @LPN and LOCATION = @Branch and QUANTITY <> 0
			 GROUP BY LOCATION, BINLABEL, LICENSE_PLATE, PRODUCT) RBData INNER JOIN
			ItemMaster (NoLock)
		ON	ItemMaster.ItemNo = RBData.PRODUCT INNER JOIN
			LPNAuditControl LPNData (NoLock)
		ON	LPNData.LPNNo = RBData.LICENSE_PLATE and
			LPNData.LocatiON = RBData.LOCATION and
			LPNData.ReceiptBin = RBData.BINLABEL and
			LPNData.ItemNo = RBData.PRODUCT LEFT OUTER JOIN
			LocMaster ToLoc (NoLock)
		ON	RBData.LOCATION = ToLoc.LocID LEFT OUTER JOIN
			LocMaster FromLocTransit (NoLock)
		ON	LPNData.FromLocatiON = FromLocTransit.LocID LEFT OUTER JOIN
			LocMaster FromLocRcpt (NoLock)
		ON	substring(RBData.BINLABEL,7,8) = FromLocRcpt.LocID
		WHERE	LPNData.ContainerNo = @Container --and LPNData.FromLocatiON = @Branch
	   END
END