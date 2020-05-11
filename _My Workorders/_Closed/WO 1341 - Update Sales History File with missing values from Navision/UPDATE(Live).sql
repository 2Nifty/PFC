
--BACKUP both tables prior to UPDATES



--UPDATE Invoices  [3 minutes - 1133576 rows]
UPDATE	SOHeaderHist
SET	OrderNo = pSOHeaderHistID,
	fSOHeaderID = pSOHeaderHistID,
	DocumentSortInd = 'E',
	TaxStat = 'N',
	ReasonCd = 'SO',
	CommDol = 0,
----	0 as NonTaxExpAmt,
	TaxAmt = 0,
	TaxExpAmt = 0,
	DiscPct = null,
	OrderMethCd = null,
	OrderMethName = null,
	OrderFreightCd = NVHDR.[Shipment Method Code],
	OrderCarName = null,
	OrderCarrier = NVHDR.[Shipping Agent Code],
	OrderTypeDsc = null,
	MakeOrderDt = NVHDR.[Posting Date],
	CustReqDt = SchShipDt,
	RlsWhseDt = SchShipDt,
	AllocRelDt = SchShipDt,
	BranchReqDt = SchShipDt,
	StatusCd = '',
	CustPONo = CASE WHEN CustPONo = '' OR CustPONo is null
			     THEN 'No PO'
			     ELSE CustPONo
		   END,
	CustSvcRepNo = NVHDR.[Inside Salesperson Code],
	CustSvcRepName = null,
	BOLWght = ShipWght,
	ChangeDt = GETDATE(),
	ChangeID = 'WO1341'
FROM	PFCLive.dbo.[Porteous$Sales Invoice Header] NVHDR
WHERE	SOHeaderHist.InvoiceNo = NVHDR.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS


--UPDATE Credit Memos  [< 1 minute - 44189 rows]
UPDATE	SOHeaderHist
SET	OrderNo = pSOHeaderHistID,
	fSOHeaderID = pSOHeaderHistID,
	DocumentSortInd = 'E',
	TaxStat = 'N',
	ReasonCd = 'SO',
	CommDol = 0,
----	0 as NonTaxExpAmt,
	TaxAmt = 0,
	TaxExpAmt = 0,
	DiscPct = null,
	OrderMethCd = null,
	OrderMethName = null,
	OrderFreightCd = NVHDR.[Shipment Method Code],
	OrderCarName = null,
----	OrderCarrier = NVHDR.[Shipping Agent Code],
	OrderCarrier = null,
	OrderType = 'CR',
	OrderTypeDsc = null,
	OrderDt = SchShipDt,
	RefSONo = [Pre-Assigned No_],
	MakeOrderDt = NVHDR.[Posting Date],
	CustReqDt = SchShipDt,
	RlsWhseDt = SchShipDt,
	AllocRelDt = SchShipDt,
	BranchReqDt = SchShipDt,
	StatusCd = '',
	CustPONo = CASE WHEN CustPONo = '' OR CustPONo is null
			     THEN 'No PO'
			     ELSE CustPONo
		   END,
	CustSvcRepNo = NVHDR.[Inside Salesperson Code],
	CustSvcRepName = null,
	BOLWght = ShipWght,
	ChangeDt = GETDATE(),
	ChangeID = 'WO1341'
FROM	PFCLive.dbo.[Porteous$Sales Cr_Memo Header] NVHDR
WHERE	SOHeaderHist.InvoiceNo = NVHDR.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS




--UPDATE OrderLoc  (PFCQuote.Umbrella)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SOHeaderHist
SET	OrderLoc = [CompanyID]
FROM	(SELECT	DISTINCT UserName, RIGHT('00'+CAST([CompanyID] AS VARCHAR(2)),2) AS [CompanyID]
	 FROM	UCOR_UserSetup) Loc
WHERE	Loc.UserName = EntryID




--UPDATE OrderTermsName  [< 1 minute - 1154058 rows]
UPDATE	SOHeaderHist
SET	OrderTermsName = [Description]
FROM	(SELECT	DISTINCT Code, [Description]
--	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Payment Terms] INNER JOIN
	 FROM	PFCLive.dbo.[Porteous$Payment Terms]) Terms
WHERE	Terms.Code = OrderTermsCd COLLATE SQL_Latin1_General_CP1_CI_AS




--UPDATE OrderFreightCd  [< 1 minute - 1177765 rows]
UPDATE	SOHeaderHist
SET	OrderFreightCd = CASE
----			    WHEN OrderFreightCd = 'BRNCHBEST' THEN ''		--Do Not Use This Code
			    WHEN OrderFreightCd = 'COL-3RD' THEN 'COL-3RD'
			    WHEN OrderFreightCd = 'COL-COD' THEN 'COL-COD'
			    WHEN OrderFreightCd = 'COLLECT' THEN 'COL'
			    WHEN OrderFreightCd = 'CONTAINER' THEN 'CON'
			    WHEN OrderFreightCd = 'DELIVERY' THEN 'Delivery'
			    WHEN OrderFreightCd = 'PPD' THEN 'PPD'		--Do Not Use This Code
			    WHEN OrderFreightCd = 'PPD & $25' THEN 'PPD25'
			    WHEN OrderFreightCd = 'PPD & $35' THEN 'PPD35'
			    WHEN OrderFreightCd = 'PPD & $40' THEN 'PPD40'
			    WHEN OrderFreightCd = 'PPD & $50' THEN 'PPD50'
			    WHEN OrderFreightCd = 'PPD & $75' THEN 'PPD75'
			    WHEN OrderFreightCd = 'PPD & CHG' THEN 'PPDCHG'
			    WHEN OrderFreightCd = 'PPD-1000LB' THEN 'PPD-1000'
			    WHEN OrderFreightCd = 'PPD-1500LB' THEN 'PPD-1500'
			    WHEN OrderFreightCd = 'PPD-2000LB' THEN 'PPD-2000'
			    WHEN OrderFreightCd = 'PPD-2500LB' THEN 'PPD-2500'
			    WHEN OrderFreightCd = 'PPD-250LB' THEN 'PPD-250'
			    WHEN OrderFreightCd = 'PPD-3500LB' THEN 'PPD-3500'
			    WHEN OrderFreightCd = 'PPD-3RD' THEN 'PPD3rd'
			    WHEN OrderFreightCd = 'PPD-5000LB' THEN 'PPD-5000'
			    WHEN OrderFreightCd = 'PPD-500LB' THEN 'PPD-500'
			    WHEN OrderFreightCd = 'PPD-600LB' THEN 'PPD-600'
			    WHEN OrderFreightCd = 'PPD-750LB' THEN 'PPD-750'
----			    WHEN OrderFreightCd = 'PPD-ADD' THEN ''		--Do Not Use This Code
			    WHEN OrderFreightCd = 'PPD-ANCHOR' THEN 'PPDANC'
----			    WHEN OrderFreightCd = 'PPD-CLE' THEN ''		--Not in [Porteous$Shipment Method]
			    WHEN OrderFreightCd = 'PPD-DEV' THEN 'PPDDEV'
			    WHEN OrderFreightCd = 'PPD-HDWE' THEN 'PPDHDWE'
			    WHEN OrderFreightCd = 'PPD-LOCAL' THEN 'PPD-Local'
			    WHEN OrderFreightCd = 'PPD-MILL' THEN 'PPDMILL'
			    WHEN OrderFreightCd = 'PPD-NC-BO' THEN 'PPDBO'
			    WHEN OrderFreightCd = 'PPD-NC-ERR' THEN 'PPDERR'
			    WHEN OrderFreightCd = 'PPD-NC-TRN' THEN 'PPDTRN'
			    WHEN OrderFreightCd = 'P-PPD' THEN 'P-PPD'
			    WHEN OrderFreightCd = 'P-UPS' THEN 'P-UPS'
			    WHEN OrderFreightCd = 'P-WILL CAL' THEN 'P-WC'
----			    WHEN OrderFreightCd = 'UPS' THEN ''			--Do Not Use This Code
			    WHEN OrderFreightCd = 'WILL CALL' THEN 'WC'		--Do Not Use This Code
			    ELSE OrderFreightCd
			 END

--UPDATE OrderCarrier  [1 minute - 1177765 rows]
UPDATE	SOHeaderHist
SET	OrderCarrier = CASE
			WHEN OrderCarrier = '' THEN '01'
			WHEN OrderCarrier = 'A & B' THEN '01'
			WHEN OrderCarrier = 'A. DUIE' THEN '01'
			WHEN OrderCarrier = 'AAA' THEN '01'
			WHEN OrderCarrier = 'ARROW' THEN '01'
			WHEN OrderCarrier = 'AVERITT' THEN '01'
			WHEN OrderCarrier = 'CE FREIGHT' THEN '01'
			WHEN OrderCarrier = 'CE TRANS' THEN '01'
			WHEN OrderCarrier = 'CHILI' THEN '01'
			WHEN OrderCarrier = 'CHRIS' THEN '01'
			WHEN OrderCarrier = 'CLICK' THEN '01'
			WHEN OrderCarrier = 'CON WAY' THEN '01'
			WHEN OrderCarrier = 'CONNECTION' THEN '01'
			WHEN OrderCarrier = 'CRYSTAL' THEN '01'
			WHEN OrderCarrier = 'DANZAS' THEN '01'
			WHEN OrderCarrier = 'DATS' THEN '01'
			WHEN OrderCarrier = 'DAYTON' THEN '01'
			WHEN OrderCarrier = 'DHL' THEN '01'
			WHEN OrderCarrier = 'DIAMOND' THEN '01'
			WHEN OrderCarrier = 'DOHRN' THEN '01'
			WHEN OrderCarrier = 'DYNAMEX' THEN '01'
			WHEN OrderCarrier = 'ESTES' THEN '01'
			WHEN OrderCarrier = 'EXPRESS' THEN '01'
			WHEN OrderCarrier = 'F-HUB-WC' THEN '01'
			WHEN OrderCarrier = 'FED EX' THEN '01'
			WHEN OrderCarrier = 'FEDEX EAST' THEN '01'
			WHEN OrderCarrier = 'FRAMES' THEN '01'
			WHEN OrderCarrier = 'HERCULES F' THEN '01'
			WHEN OrderCarrier = 'HORIZON' THEN '01'
			WHEN OrderCarrier = 'KINDERSLEY' THEN '01'
			WHEN OrderCarrier = 'LA YUMA' THEN '01'
			WHEN OrderCarrier = 'LANTRAX' THEN '01'
			WHEN OrderCarrier = 'LTL' THEN '01'
			WHEN OrderCarrier = 'MAP' THEN '01'
			WHEN OrderCarrier = 'MAXIMUM' THEN '01'
			WHEN OrderCarrier = 'MERIDIAN' THEN '01'
			WHEN OrderCarrier = 'MIDWEST' THEN '01'
			WHEN OrderCarrier = 'MILAN' THEN '01'
			WHEN OrderCarrier = 'MONROE' THEN '01'
			WHEN OrderCarrier = 'N & M' THEN '01'
			WHEN OrderCarrier = 'NORTH PARK' THEN '01'
			WHEN OrderCarrier = 'OAK HARBOR' THEN '01'
			WHEN OrderCarrier = 'OLD DOM' THEN '01'
			WHEN OrderCarrier = 'OVERNITE' THEN '01'
			WHEN OrderCarrier = 'PARKE' THEN '01'
			WHEN OrderCarrier = 'PENINSULA' THEN '01'
			WHEN OrderCarrier = 'PITT OHIO' THEN '01'
			WHEN OrderCarrier = 'PJAX' THEN '01'
			WHEN OrderCarrier = 'POZAS BROS' THEN '01'
			WHEN OrderCarrier = 'PRIORITY' THEN '01'
			WHEN OrderCarrier = 'R & L' THEN '01'
			WHEN OrderCarrier = 'RAC' THEN '01'
			WHEN OrderCarrier = 'RJM' THEN '01'
			WHEN OrderCarrier = 'ROADWAY' THEN '01'
			WHEN OrderCarrier = 'RRR' THEN '01'
			WHEN OrderCarrier = 'SAIA' THEN '01'
			WHEN OrderCarrier = 'SOUTHEAST' THEN '01'
			WHEN OrderCarrier = 'SOUTHWEST' THEN '01'
			WHEN OrderCarrier = 'SPRINTER' THEN '01'
			WHEN OrderCarrier = 'STEVE' THEN '01'
			WHEN OrderCarrier = 'TEXOMA' THEN '01'
			WHEN OrderCarrier = 'TIGER' THEN '01'
			WHEN OrderCarrier = 'TRAVIS' THEN '01'
			WHEN OrderCarrier = 'UNASSIGNED' THEN '01'
			WHEN OrderCarrier = 'USF HOL' THEN '01'
			WHEN OrderCarrier = 'USF RED' THEN '01'
			WHEN OrderCarrier = 'VAN KAM' THEN '01'
			WHEN OrderCarrier = 'WILSON' THEN '01'
			WHEN OrderCarrier = 'YELLOW' THEN '01'
			WHEN OrderCarrier = 'UPS' THEN '02'
			WHEN OrderCarrier = 'UPS FREIGH' THEN '02'
			WHEN OrderCarrier = 'UPS RED' THEN '03'
			WHEN OrderCarrier = 'UPS BLUE' THEN '04'
			WHEN OrderCarrier = 'UPS EARLY' THEN '05'
			WHEN OrderCarrier = 'UPS ORANGE' THEN '06'
			WHEN OrderCarrier = 'UPS RED SA' THEN '07'
			WHEN OrderCarrier = 'MAERSK' THEN 'Mill'
			WHEN OrderCarrier = 'BR TR+FHUB' THEN 'PFC'
			WHEN OrderCarrier = 'BR TRK+ WC' THEN 'PFC'
			WHEN OrderCarrier = 'BR TRK+FRT' THEN 'PFC'
			WHEN OrderCarrier = 'BR TRK+OT' THEN 'PFC'
			WHEN OrderCarrier = 'BR TRK+UPS' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #10' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #100' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #11' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #2' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #5' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #553' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #566' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #577' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #578' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #595' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #596' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #599' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #6' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #602' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #603' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #605' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #606' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #607' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #608' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #609' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #610' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #611' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #612' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #7' THEN 'PFC'
			WHEN OrderCarrier = 'PFC #9' THEN 'PFC'
			WHEN OrderCarrier = 'PFCTRUCK' THEN 'PFC'
			WHEN OrderCarrier = 'W/C AT SFS' THEN 'WC'
			WHEN OrderCarrier = 'WILL CALL' THEN 'WC'
			ELSE '01'
		       END


--UPDATE OrderPriorityCd & OrderExpdCd  [< 1 minute - 1177765 rows]
UPDATE	SOHeaderHist
SET	OrderPriorityCd = CASE OrderCarrier
			     WHEN 'WC' THEN 'WC'
			     	       ELSE 'N'
			  END,
	OrderExpdCd =     CASE OrderCarrier
			     WHEN 'WC' THEN 'WC'
			     	       ELSE 'AR'
			  END


--UPDATE PriceCd  [< 1 minute - 1177764 rows]
UPDATE	SOHeaderHist
SET	PriceCd = Cust.PriceCd
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster Cust
WHERE	SellToCustNo = CustNo



-----------------------------------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1341ItemBranch]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[tWO1341ItemBranch]

SELECT	Item.ItemNo, ItemBr.Location, ItemBr.StdCost, ItemBr.ReplacementCost, ItemBr.PriceCost
INTO	tWO1341ItemBranch
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemBranch ItemBr
ON	Item.pItemMasterID = ItemBr.fItemMasterID

--select * from tWO1341ItemBranch
--Order By ItemNo, Location



--UPDATE Invoice Detail  [5-10 minutes - 3822619 rows]
UPDATE	SODetailHist
SET	LineType = 'S',
	BinLoc = 'STOCK',
	CostInd = 'A',
	QtyAvailLoc1 = '',
	QtyAvail1 = 0,
	QtyAvailLoc2 = '',
	QtyAvail2 = 0,
	QtyAvailLoc3 = '',
	QtyAvail3 = 0,
	LineSeq = NVLINE.[Line No_],
	IMLoc = SOHeaderHist.ShipLoc,
	OriginalQtyRequested = SODetailHist.QtyOrdered,
----	OriginalQtyRequested = ROUND(SODetailHist.QtyOrdered,0,1),
--	OriginalQtyRequested =	CASE ROUND(NVLINE.[Original Qty],0,1)
--				   WHEN 0 THEN ROUND(SODetailHist.QtyOrdered,0,1)
--				   ELSE ROUND(NVLINE.[Original Qty],0,1)
--				END,
----	QtyOrdered = ROUND(SODetailHist.QtyOrdered,0,1),
----	QtyShipped = ROUND(SODetailHist.QtyShipped,0,1),
	QtyBO = ROUND(NVLINE.[Back Order Qty],0,1),
----	ExtendedGrossWght = ROUND(SODetailHist.QtyShipped,0,1) * SODetailHist.GrossWght,
----	ExtendedNetWght = ROUND(SODetailHist.QtyShipped,0,1) * SODetailHist.NetWght,
----	ExtendedPrice = ROUND(SODetailHist.QtyShipped,0,1) * SODetailHist.NetUnitPrice,
----	ExtendedCost = ROUND(SODetailHist.QtyShipped,0,1) * SODetailHist.UnitCost,
	RqstdShipDt = NVLINE.[Shipment Date],
	StatusCd = '',
	LinePriceInd = null,
--	LinePriceInd =	CASE NVLINE.[Unit Price Origin]
--			   WHEN '' THEN 'E'
--			   WHEN 'CP' THEN 'P'
--			   WHEN 'CPDP' THEN 'P'
--			   WHEN 'IUP' THEN 'L'
--			   WHEN 'OVERRIDE' THEN 'E'
--			   WHEN 'OVR' THEN 'E'
--			   WHEN 'SDUP' THEN 'D'
--			   WHEN 'SPUP' THEN 'C'
--			   ELSE 'E'
--			END,
	LISource = null,
--	LISource =	CASE NVLINE.[Unit Price Origin]
--			   WHEN '' THEN 'E'
--			   WHEN 'CP' THEN 'P'
--			   WHEN 'CPDP' THEN 'P'
--			   WHEN 'IUP' THEN 'L'
--			   WHEN 'OVERRIDE' THEN 'E'
--			   WHEN 'OVR' THEN 'E'
--			   WHEN 'SDUP' THEN 'D'
--			   WHEN 'SPUP' THEN 'C'
--			   ELSE 'E'
--			END,
	DiscPct1 = 	CASE WHEN NVLINE.[Line Discount %] > 100 THEN 100
			     WHEN NVLINE.[Line Discount %] < -100 THEN -100
			     ELSE NVLINE.[Line Discount %]
			END,
--	DiscPct1 = NVLINE.[Line Discount %],
	DiscUnitPrice =	CASE WHEN NVLINE.[Line Discount %] > 100 THEN SODetailHist.ListUnitPrice - (SODetailHist.ListUnitPrice * 100 * 0.01)
			     WHEN NVLINE.[Line Discount %] < -100 THEN SODetailHist.ListUnitPrice - (SODetailHist.ListUnitPrice * -100 * 0.01)
			     ELSE SODetailHist.ListUnitPrice - (SODetailHist.ListUnitPrice * ROUND(NVLINE.[Line Discount %],0,1) * 0.01)
			END,
--	DiscUnitPrice = SODetailHist.ListUnitPrice - (SODetailHist.ListUnitPrice * NVLINE.[Line Discount %] * 0.01),
	UnitCost2 = 0,
	UnitCost3 = 0,
	RepCost = SODetailHist.UnitCost,
	OECost = 0,
	CarrierCd = SOHeaderHist.OrderCarrier,
	FreightCd = SOHeaderHist.OrderFreightCd,
	LineExpdCd = SOHeaderHist.OrderExpdCd,
	PriceCd = SOHeaderHist.PriceCd,
	LineReason = SOHeaderHist.ReasonCd,
----	UsageLoc = NVLINE.[Usage Location],
	ExcludedFromUsageFlag = isnull(NVLINE.[Excl_ from Usage],0),
	ChangeDate = GETDATE(),
	ChangeID = 'WO1341'
FROM	PFCLive.dbo.[Porteous$Sales Invoice Line] NVLINE INNER JOIN
	SOHeaderHist
ON	NVLINE.[Document No_] = SOHeaderHist.InvoiceNo COLLATE Latin1_General_CS_AS
WHERE	SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID AND NVLINE.[Line No_] = SODetailHist.LineNumber AND
	((NVLINE.Type = 2) OR (NVLINE.Type = 1 AND NVLINE.No_ = '3021')) AND NVLINE.No_ <> ''	--Do we need this WHERE?



--UPDATE Invoice Detail (ItemBranch Records)  [3 minutes - 3551533 rows]
UPDATE	SODetailHist
SET	UnitCost2 = ItemBr.StdCost,
	UnitCost3 = ItemBr.ReplacementCost,
	OECost = ItemBr.PriceCost,
	ChangeDate = GETDATE(),
	ChangeID = 'WO1341'
FROM	PFCLive.dbo.[Porteous$Sales Invoice Line] NVLINE INNER JOIN
	SOHeaderHist
ON	NVLINE.[Document No_] = SOHeaderHist.InvoiceNo COLLATE Latin1_General_CS_AS INNER JOIN
	tWO1341ItemBranch ItemBr
ON	NVLINE.[No_] = ItemBr.ItemNo COLLATE Latin1_General_CS_AS AND SOHeaderHist.ShipLoc = ItemBr.Location
WHERE	SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID AND NVLINE.[Line No_] = SODetailHist.LineNumber AND
	((NVLINE.Type = 2) OR (NVLINE.Type = 1 AND NVLINE.No_ = '3021')) AND NVLINE.No_ <> ''	--Do we need this WHERE?



--UPDATE Credit Memo Detail  [< 1 minute - 51007 rows]
UPDATE	SODetailHist
SET	LineType = 'S',
	BinLoc = 'STOCK',
	CostInd = 'A',
	QtyAvailLoc1 = '',
	QtyAvail1 = 0,
	QtyAvailLoc2 = '',
	QtyAvail2 = 0,
	QtyAvailLoc3 = '',
	QtyAvail3 = 0,
	LineSeq = NVLINE.[Line No_],
	IMLoc = SOHeaderHist.ShipLoc,
	OriginalQtyRequested = SODetailHist.QtyOrdered,
----	OriginalQtyRequested = ROUND(SODetailHist.QtyOrdered,0,1),
--	OriginalQtyRequested =	CASE ROUND(NVLINE.[Original Qty],0,1)
--				   WHEN 0 THEN ROUND(SODetailHist.QtyOrdered,0,1)
--				   ELSE ROUND(NVLINE.[Original Qty],0,1)
--				END,
----	QtyOrdered = ROUND(SODetailHist.QtyOrdered,0,1),
----	QtyShipped = ROUND(SODetailHist.QtyShipped,0,1),
	QtyBO = 0,
--	QtyBO = ROUND(NVLINE.[Back Order Qty],0,1),
----	ExtendedGrossWght = ROUND(SODetailHist.QtyShipped,0,1) * SODetailHist.GrossWght,
----	ExtendedNetWght = ROUND(SODetailHist.QtyShipped,0,1) * SODetailHist.NetWght,
----	ExtendedPrice = ROUND(SODetailHist.QtyShipped,0,1) * SODetailHist.NetUnitPrice,
----	ExtendedCost = ROUND(SODetailHist.QtyShipped,0,1) * SODetailHist.UnitCost,
	RqstdShipDt = NVLINE.[Shipment Date],
	StatusCd = '',
	LinePriceInd = null,
--	LinePriceInd =	CASE NVLINE.[Unit Price Origin]
--			   WHEN '' THEN 'E'
--			   WHEN 'CP' THEN 'P'
--			   WHEN 'CPDP' THEN 'P'
--			   WHEN 'IUP' THEN 'L'
--			   WHEN 'OVERRIDE' THEN 'E'
--			   WHEN 'OVR' THEN 'E'
--			   WHEN 'SDUP' THEN 'D'
--			   WHEN 'SPUP' THEN 'C'
--			   ELSE 'E'
--			END,
	LISource = null,
--	LISource =	CASE NVLINE.[Unit Price Origin]
--			   WHEN '' THEN 'E'
--			   WHEN 'CP' THEN 'P'
--			   WHEN 'CPDP' THEN 'P'
--			   WHEN 'IUP' THEN 'L'
--			   WHEN 'OVERRIDE' THEN 'E'
--			   WHEN 'OVR' THEN 'E'
--			   WHEN 'SDUP' THEN 'D'
--			   WHEN 'SPUP' THEN 'C'
--			   ELSE 'E'
--			END,
	DiscPct1 = 	CASE WHEN NVLINE.[Line Discount %] > 100 THEN 100
			     WHEN NVLINE.[Line Discount %] < -100 THEN -100
			     ELSE NVLINE.[Line Discount %]
			END,
--	DiscPct1 = NVLINE.[Line Discount %],
	DiscUnitPrice =	CASE WHEN NVLINE.[Line Discount %] > 100 THEN SODetailHist.ListUnitPrice - (SODetailHist.ListUnitPrice * 100 * 0.01)
			     WHEN NVLINE.[Line Discount %] < -100 THEN SODetailHist.ListUnitPrice - (SODetailHist.ListUnitPrice * -100 * 0.01)
			     ELSE SODetailHist.ListUnitPrice - (SODetailHist.ListUnitPrice * ROUND([Line Discount %],0,1) * 0.01)
			END,
--	DiscUnitPrice = SODetailHist.ListUnitPrice - (SODetailHist.ListUnitPrice * NVLINE.[Line Discount %] * 0.01),
	UnitCost2 = 0,
	UnitCost3 = 0,
	RepCost = SODetailHist.UnitCost,
	OECost = 0,
	CarrierCd = SOHeaderHist.OrderCarrier,
	FreightCd = SOHeaderHist.OrderFreightCd,
	LineExpdCd = SOHeaderHist.OrderExpdCd,
	PriceCd = SOHeaderHist.PriceCd,
	LineReason = SOHeaderHist.ReasonCd,
----	UsageLoc = NVLINE.[Usage Location],
	ExcludedFromUsageFlag = 0,
	ChangeDate = GETDATE(),
	ChangeID = 'WO1341'
FROM	PFCLive.dbo.[Porteous$Sales Cr_Memo Line] NVLINE INNER JOIN
	SOHeaderHist
ON	NVLINE.[Document No_] = SOHeaderHist.InvoiceNo COLLATE Latin1_General_CS_AS
WHERE	SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID AND NVLINE.[Line No_] = SODetailHist.LineNumber AND
	((NVLINE.Type = 2) OR (NVLINE.Type = 1 AND NVLINE.No_ = '3021')) AND NVLINE.No_ <> ''	--Do we need this WHERE?



--UPDATE Credit Memo Detail (ItemBranch Records)  [< 1 minute - 35021 rows]
UPDATE	SODetailHist
SET	UnitCost2 = ItemBr.StdCost,
	UnitCost3 = ItemBr.ReplacementCost,
	OECost = ItemBr.PriceCost,
	ChangeDate = GETDATE(),
	ChangeID = 'WO1341'
FROM	PFCLive.dbo.[Porteous$Sales Cr_Memo Line] NVLINE INNER JOIN
	SOHeaderHist
ON	NVLINE.[Document No_] = SOHeaderHist.InvoiceNo COLLATE Latin1_General_CS_AS INNER JOIN
	tWO1341ItemBranch ItemBr
ON	NVLINE.[No_] = ItemBr.ItemNo COLLATE Latin1_General_CS_AS AND SOHeaderHist.ShipLoc = ItemBr.Location
WHERE	SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID AND NVLINE.[Line No_] = SODetailHist.LineNumber AND
	((NVLINE.Type = 2) OR (NVLINE.Type = 1 AND NVLINE.No_ = '3021')) AND NVLINE.No_ <> ''	--Do we need this WHERE?


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1341ItemBranch]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[tWO1341ItemBranch]



-----------------------------------------------------------------------------

--UPDATE Invoice Expenses  [< 1 minute - 263962 rows]
UPDATE	SOExpenseHist
SET	ExpenseDesc = NVLINE.[Description],
	ChangeDt = GETDATE(),
	ChangeID = 'WO1341'
FROM	PFCLive.dbo.[Porteous$Sales Invoice Line] NVLINE 
WHERE	NVLINE.[Document No_] = SOExpenseHist.DocumentLoc COLLATE Latin1_General_CS_AS AND NVLINE.[Line No_] = SOExpenseHist.LineNumber AND
	((NVLINE.Type = 1 and NVLINE.No_ <> '3021') OR (NVLINE.Type <> 1 AND NVLINE.Type <> 2))	--Do we need this WHERE?


--UPDATE Credit Memo Expenses  [< 1 minute - 9921 rows]
UPDATE	SOExpenseHist
SET	ExpenseDesc = NVLINE.[Description],
	ChangeDt = GETDATE(),
	ChangeID = 'WO1341'
FROM	PFCLive.dbo.[Porteous$Sales Cr_Memo Line] NVLINE
WHERE	NVLINE.[Document No_] = SOExpenseHist.DocumentLoc COLLATE Latin1_General_CS_AS AND NVLINE.[Line No_] = SOExpenseHist.LineNumber AND
	((NVLINE.Type = 1 and NVLINE.No_ <> '3021') OR (NVLINE.Type <> 1 AND NVLINE.Type <> 2))	--Do we need this WHERE?



-----------------------------------------------------------------------------

--UPDATE ExcludedFromUsageFlag  [< 1 minute - 30694 rows]
UPDATE	SODetailHist
SET	ExcludedFromUsageFlag = 1
FROM	SODetailHist INNER JOIN
	SOHeaderHist
ON	SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID
WHERE	(SOHeaderHist.OrderType IN ('1', '2'))


-----------------------------------------------------------------------------

--UPDATE OrderType  [< 1 minute - 71 + 0 + 13544 rows]

--Pallet Partners
UPDATE	SOHeaderHist
SET	OrderType = 'PP'
WHERE	OrderType = '4'

--Special Processing
UPDATE	SOHeaderHist
SET	OrderType = '0'
WHERE	OrderType = '3'

--Stock & Release
UPDATE	SOHeaderHist
SET	OrderType = '4'
WHERE	OrderType = '2'



--UPDATE OrderTypeDesc & SubType  [2 minutes - 1177765 rows]
UPDATE	SOHeaderHist
SET	OrderTypeDsc = ListDtlDesc,
	SubType = SequenceNo
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail
ON	pListMasterID=fListMasterID INNER JOIN
	SOHeaderHist
ON	OrderType = ListValue
WHERE	ListName='soeordertypes'


-----------------------------------------------------------------------------


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1341LocMaster]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[tWO1341LocMaster]

SELECT	DISTINCT LocID, LocName
INTO	tWO1341LocMaster
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.LocMaster


--Update Location Names - OrderLocName, ShipLocName, UsageLocName

--SET OrderLocName  [2 minutes - 1177765 rows]
UPDATE	SOHeaderHist
SET	OrderLocName = LocName
FROM	tWO1341LocMaster Loc
WHERE	Loc.LocID = OrderLoc


--SET ShipLocName  [2 minutes - 1151642 rows]
UPDATE	SOHeaderHist
SET	ShipLocName = LocName
FROM	tWO1341LocMaster Loc
WHERE	Loc.LocID = ShipLoc


--SET UsageLocName  [2 minutes - 1177699 rows]
UPDATE	SOHeaderHist
SET	UsageLocName = LocName
FROM	tWO1341LocMaster Loc
WHERE	Loc.LocID = UsageLoc


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1341LocMaster]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[tWO1341LocMaster]

-----------------------------------------------------------------------------

--UPDATE OrderFreightName  [2 minutes - 1120367 rows]
UPDATE	SOHeaderHist
SET	OrderFreightName = Fght.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Fght
WHERE	TableType = 'Fght' AND OrderFreightCd = Fght.TableCd


--UPDATE OrderCarName  [2 minutes - 1177765 rows]
UPDATE	SOHeaderHist
SET	OrderCarName = Car.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Car
WHERE	TableType = 'CAR' AND OrderCarrier = Car.TableCd


-----------------------------------------------------------------------------


--UPDATE ReasonCdName  [2 minutes - 1177765 rows]
UPDATE	SOHeaderHist
SET	ReasonCdName = Reas.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Reas
WHERE	TableType = 'Reas' AND SOHeaderHist.ReasonCd = Reas.TableCd


--UPDATE LineReasonDsc  [5 minutes - 3873626 rows]
UPDATE	SODetailHist
SET	LineReasonDsc = Reas.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Reas
WHERE	TableType = 'Reas' AND LineReason = Reas.TableCd


--UPDATE HoldReasonName  [0 rows]
UPDATE	SOHeaderHist
SET	HoldReasonName = Reas.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Reas
WHERE	TableType = 'Reas' AND HoldReason = Reas.TableCd AND
	HoldReason <> '' AND HoldReason is not null


-----------------------------------------------------------------------------


--UPDATE SalesRepName  [2 minutes - 1172788 rows]
UPDATE	SOHeaderHist
SET	SalesRepName = LEFT([Name],40)
FROM	PFCLive.dbo.[Porteous$Salesperson_Purchaser]
WHERE	SalesRepNo = [Code] COLLATE SQL_Latin1_General_CP1_CI_AS


--UPDATE CustSvcRepName  [2 minutes - 1158431 rows]
UPDATE	SOHeaderHist
SET	CustSvcRepName = LEFT([Name],40)
FROM	PFCLive.dbo.[Porteous$Salesperson_Purchaser]
WHERE	CustSvcRepNo = [Code] COLLATE SQL_Latin1_General_CP1_CI_AS



-----------------------------------------------------------------------------


--UPDATE OrderPriName  [2 minutes - 1177765 rows]
UPDATE	SOHeaderHist
SET	OrderPriName = Pri.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Pri
WHERE	TableType = 'Pri' AND SOHeaderHist.OrderPriorityCd = Pri.TableCd


--UPDATE OrderExpdCdName  [2 minutes - 1177765 rows]
UPDATE	SOHeaderHist
SET	OrderExpdCdName = Expd.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Expd
WHERE	TableType = 'Expd' AND SOHeaderHist.OrderExpdCd = Expd.TableCd


--UPDATE LineExpdCdDsc  [5 minutes - 3873626 rows]
UPDATE	SODetailHist
SET	LineExpdCdDsc = Expd.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Expd
WHERE	TableType = 'Expd' AND SODetailHist.LineExpdCd = Expd.TableCd


-----------------------------------------------------------------------------

--UPDATE SellStkUM, SellStkQty, AlternateUMQty, AlternateUM & SuperEquivUM  [6 minutes - 3857851 rows]
UPDATE	SODetailHist
SET	SellStkUM = Item.SellStkUM,
	SellStkQty = Item.SellStkUMQty,
	AlternateUMQty = Item.SellStkUMQty,
	AlternateUM = Item.SellUM,
	SuperEquivUM = Item.SuperUM
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item
WHERE	SODetailHist.ItemNo = Item.ItemNo


--UPDATE SellStkFactor  [3 minutes - 3857796 rows]
UPDATE	SODetailHist
SET	SellStkFactor = UM.QtyPerUM
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemUM UM ON Item.pItemMasterID = UM.fItemMasterID
WHERE	SODetailHist.ItemNo = Item.ItemNo AND UM.UM = Item.SellStkUM


--UPDATE SuperEquivQty  [3 minutes - 3772457 rows]
UPDATE	SODetailHist
SET	SuperEquivQty = UM.QtyPerUM
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemUM UM ON Item.pItemMasterID = UM.fItemMasterID
WHERE	SODetailHist.ItemNo = Item.ItemNo AND UM.UM = Item.SuperUM


--UPDATE AlternatePrice  [3 minutes - 3857102 rows]
UPDATE	SODetailHist
SET	AlternatePrice = CASE UM.AltSellStkUMQty
				WHEN 0 THEN 0
				ELSE NetUnitPrice / UM.AltSellStkUMQty
			 END
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemUM UM ON Item.pItemMasterID = UM.fItemMasterID
WHERE	SODetailHist.ItemNo = Item.ItemNo AND UM.UM = Item.SellUM




--UPDATE TotalCost2  [2 minutes - 1171032 rows]
UPDATE	SOHeaderHist
SET	TotalCost2 = OrderExt2
FROM	(SELECT	RefSONo,
		SUM(SODetailHist.QtyShipped * SODetailHist.UnitCost2) as OrderExt2
	 FROM	SODetailHist INNER JOIN
		SOHeaderHist
	 ON	SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID
	 Group By RefSONo) ExtOrder
WHERE	ExtOrder.RefSONo = SOHeaderHist.RefSONo





--UPDATE NonTaxAmt  [2 minutes - 1171032 rows]
UPDATE	SOHeaderHist
SET	NonTaxAmt = OrderExt
FROM	(SELECT	RefSONo, SUM(SODetailHist.QtyShipped * SODetailHist.NetUnitPrice) as OrderExt
	 FROM	SODetailHist INNER JOIN
		SOHeaderHist
	 ON	SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID
	 Group By RefSONo) ExtOrder
WHERE	ExtOrder.RefSONo = SOHeaderHist.RefSONo


--UPDATE TotalOrder  [< 1 minute - 1177765 rows]
UPDATE	SOHeaderHist
SET	TotalOrder = ISNULL(TaxSum,0) + ISNULL(NonTaxAmt,0) + ISNULL(TaxExpAmt,0) + ISNULL(NonTaxExpAmt,0) + ISNULL(TaxAmt,0)
FROM	SOHeaderHist


-----------------------------------------------------------------------------

select UnitCost2, QtyShipped from SODetailHist

select TotalCost2 from SOHeaderHist
Where TotalCost2 is not null and TotalCost2<>0



select  OrderType, OrderFreightCd, OrderFreightName from SOHeaderHist
where OrderFreightName is null and OrderFreightCd<>''


select TableCd, Dsc, ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Fght
WHERE	TableType = 'Fght'


select BillToCustName, ShipToName, * from SOHeaderHist where left([BillToCustName],8)='Porteous' and left([ShipToName],8)='Porteous'


exec sp_columns SOExpenseHist

select DocumentLoc, LineNumber, ExpenseDesc, * from SOExpenseHist
where (DocumentLoc='I1026672' or DocumentLoc='IP1679315' or DocumentLoc='IP1679322' or DocumentLoc='IP1679576')
order by DocumentLoc, LineNumber


select *
FROM	PFCLive.dbo.[Porteous$Sales Invoice Line] NVLINE
WHERE	
([Document No_]='I1026672' or [Document No_]='IP1679315' or [Document No_]='IP1679322' or [Document No_]='IP1679576') and

((NVLINE.Type = 1 and NVLINE.No_ <> '3021') OR (NVLINE.Type <> 1 AND NVLINE.Type <> 2))	--Do we need this WHERE?
order by [Document No_],  [Line No_]




select * from SOHeaderHist where ChangeID <> 'WO1341'
select * from SODetailHist where ChangeID <> 'WO1341'


select count(*) from SOHeaderHist

select OrderNo, fSOHeaderID,* from SOHeaderHist
where OrderNo is null or fSOHeaderID is null



select * from SODetailHist
where pSODetailHistID < 1001



select count(DISTINCT SODetailHist.pSODetailHistID)
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Line] NVLINE INNER JOIN
	SOHeaderHist
ON	NVLINE.[Document No_] = SOHeaderHist.InvoiceNo INNER JOIN
	SODetailHist on pSOHeaderHistID=SODetailHist.fSOHeaderHistID --inner join
--	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item
--ON	NVLINE.[No_] = Item.ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS INNER JOIN
--	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemBranch ItemBr
--ON	Item.pItemMasterID = ItemBr.fItemMasterID
WHERE	NVLINE.No_ <> '' AND NVLINE.Type = 2 --AND SOHeaderHist.ShipLoc = ItemBr.Location



select * from SODetailHist where ItemNo<>'' and LineType=2


select InvoiceNo, * from SOHeaderHist
order by InvoiceNo

select [Document No_], * FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Line] 
Order by [Document No_]


-----------------------------------------------------------------------------


	'E' as DocumentSortInd
	'N' as TaxStat,
	'SO' as ReasonCd,
	0 as CommDol,
----	0 as NonTaxExpAmt,
	0 as TaxAmt,
	0 as TaxExpAmt,



select
DocumentSortInd
TaxStat,
ReasonCd,
CommDol,
----NonTaxExpAmt,
TaxAmt,
TaxExpAmt
from SOHeaderHist

select PriceCd  from SOHeaderHist


select OrderMethCd, OrderMethName from SOHeader




select [Location Code],[Shipping Location] from PFCLive.dbo.[Porteous$Sales Invoice Header] where [Location Code]<>[Shipping Location]



select [Location Code],[Shipping Location] from PFCLive.dbo.[Porteous$Sales Header] where [Location Code]<>[Shipping Location]


select OrderDt, * from SOHeaderHist where OrderType=51 and OrderDt is not null

select * from PFCLive.dbo.[Porteous$Sales Cr_Memo Header]
where  [Posting Date] > Cast('2008-08-26 00:00:00.000' as DATETIME)


select * from PFCLive.dbo.[Porteous$Sales Header] where [Document Type]=3