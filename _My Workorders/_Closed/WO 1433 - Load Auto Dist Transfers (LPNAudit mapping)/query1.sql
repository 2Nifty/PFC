
select Max([No_]) from [Porteous$Transfer Header]
select* from [Porteous$Transfer Header] where [No_]>'TO1214675' and [Transfer-from Code] <> '99'


select * from SOHeader where OrderType='TO'

---------------------------------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1433_LoadAutoTrf]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1433_LoadAutoTrf]
GO

DECLARE	@LastAutoTrfNo VARCHAR(20)

--Get Last AutoTrf Order Number from AppPref
SELECT	@LastAutoTrfNo = AppOptionValue
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
WHERE	ApplicationCd='SOE' and AppOptionType='LastAutoTrfNo'


select @LastAutoTrfNo


--[Porteous$Transfer Header] - Auto Transfer Orders
SELECT	DISTINCT
	NVHDR.[No_] as RefSONo
INTO	tWO1433_LoadAutoTrf
FROM	[Porteous$Transfer Header] NVHDR WITH (NOLOCK) INNER JOIN
	[Porteous$Transfer Line] NVLINE WITH (NOLOCK)
ON	NVHDR.[No_] = NVLINE.[Document No_] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item
ON	NVLINE.[Item No_] = Item.ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemBranch ItemBr
ON	Item.pItemMasterID = ItemBr.fItemMasterID
WHERE	NVHDR.[No_] > @LastAutoTrfNo AND
	ROUND(NVLINE.[Qty_ to Ship],0,1) > 0 AND [Item No_] <> '' AND NVHDR.[Transfer-from Code] <> '99' AND
	CASE WHEN NVHDR.[Transfer-from Code] = 0 OR NVHDR.[Transfer-from Code] = '' OR NVHDR.[Transfer-from Code] is null
		  THEN '01'
		  ELSE NVHDR.[Transfer-from Code]
	END = ItemBr.Location COLLATE SQL_Latin1_General_CP1_CI_AS


select * from tWO1433_LoadAutoTrf

DECLARE	@LastAutoTrfNo VARCHAR(20)

--Find & UPDATE Last EDI SO Order Number that was processed
SELECT	@LastAutoTrfNo = MAX(RefSONo)
FROM	tWO1433_LoadAutoTrf

IF (@LastAutoTrfNo is not null)
	UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
	SET	AppOptionValue = @LastAutoTrfNo, ChangeID=System_user, ChangeDt=GetDate()
	WHERE	ApplicationCd='SOE' and AppOptionType='LastAutoTrfNo'



-------------------------------------------------------------------------


--[Porteous$Transfer Header]
SELECT	DISTINCT
	'TO' as OrderType,
	0 as TotalOrder,
	0 as TotalCost,
	0 as TotalCost2,
	0 as CommDol,
--	0 as DiscPct,
	0 as NetSales,
	0 as TaxSum,
	0 as NonTaxAmt,
	0 as TaxExpAmt,
	0 as NonTaxExpAmt,
	0 as TaxAmt,
	RIGHT('099500'+NVHDR.[Transfer-to Code],6) as SellToCustNo,
	NVHDR.[Transfer-to Name] as SellToCustName,
	NVHDR.[Transfer-to Address] as SellToAddress1,
	NVHDR.[Transfer-to Address 2] as SellToAddress2,
	NVHDR.[Transfer-to Name 2] as SellToAddress3,
	NVHDR.[Transfer-to City] as SellToCity,
	NVHDR.[Transfer-to County] as SellToState,
	NVHDR.[Transfer-to Post Code] as SellToZip,
	NVHDR.[Transfer-to Country Code] as SellToCountry,
	NVHDR.[Shipment Date] as SchShipDt,
	CASE WHEN NVHDR.[Transfer-from Code] = 0 OR NVHDR.[Transfer-from Code] = '' OR NVHDR.[Transfer-from Code] is null
		  THEN '01'
		  ELSE NVHDR.[Transfer-from Code]
	END as OrderLoc,
	CASE WHEN NVHDR.[Transfer-from Code] = 0 OR NVHDR.[Transfer-from Code] = '' OR NVHDR.[Transfer-from Code] is null
		  THEN '01'
		  ELSE NVHDR.[Transfer-from Code]
	END as ShipLoc,
	'SO' as ReasonCd,
	'N' as TaxStat,
	NVHDR.[Shipping Agent Code] as OrderCarrier,
	NVHDR.[Inbound Bill of Lading No_] as BOLNO,
	CASE WHEN NVHDR.[Transfer-to Code] = 0 OR NVHDR.[Transfer-to Code] = '' OR NVHDR.[Transfer-to Code] is null
		  THEN '01'
		  ELSE NVHDR.[Transfer-to Code]
	END as CustShipLoc,
	RIGHT('099500'+NVHDR.[Transfer-to Code],6) as ShipToCd,
	NVHDR.[Transfer-to Name] as ShipToName,
	NVHDR.[Transfer-to Address] as ShipToAddress1,
	NVHDR.[Transfer-to Address 2] as ShipToAddress2,
	NVHDR.[Transfer-to Name 2] as ShipToAddress3,
	NVHDR.[Transfer-to City] as City,
	NVHDR.[Transfer-to County] as State,
	NVHDR.[Transfer-to Post Code] as Zip,
	NVHDR.[Transfer-to Country Code] as Country,
	NVHDR.[Status] as StatusCd,
	CASE WHEN NVHDR.[No_] = '' OR NVHDR.[No_] is null
		THEN 'No PO'
		ELSE NVHDR.[No_]
	END as CustPONo,
	NVHDR.[No_] as RefSONo,
	NVHDR.[Shipment Method Code] as OrderFreightCd,
	NVHDR.[Shipment Date] as BranchReqDt,
	NVHDR.[Posting Date] as MakeOrderDt,
	'E' as DocumentSortInd
FROM	[Porteous$Transfer Header] NVHDR WITH (NOLOCK) INNER JOIN
	[Porteous$Transfer Line] NVLINE WITH (NOLOCK)
ON	NVHDR.[No_] = NVLINE.[Document No_] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item
ON	NVLINE.[Item No_] = Item.ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemBranch ItemBr
ON	Item.pItemMasterID = ItemBr.fItemMasterID
WHERE	ROUND(NVLINE.[Qty_ to Ship],0,1) > 0 AND [Item No_]<>'' AND NVHDR.[Transfer-from Code] <> '99' AND
	CASE WHEN NVHDR.[Transfer-from Code] = 0 OR NVHDR.[Transfer-from Code] = '' OR NVHDR.[Transfer-from Code] is null
		  THEN '01'
		  ELSE NVHDR.[Transfer-from Code]
	END = ItemBr.Location COLLATE SQL_Latin1_General_CP1_CI_AS AND
	EXISTS (SELECT	RefSONo
		FROM	tWO1433_LoadAutoTrf
		WHERE	RefSONo = NVHDR.[No_])


------------------------------------------------------------------------------

UPDATE	SOHeader
SET	OrderFreightCd = CASE
			    WHEN OrderFreightCd = 'BRNCHBEST' THEN 'BRANCHBEST'	--Do Not Use This Code
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
			    WHEN OrderFreightCd = 'PPD-ADD' THEN 'PPDADD'	--Do Not Use This Code
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
			    WHEN OrderFreightCd = 'UPS' THEN 'UPS'		--Do Not Use This Code
			    WHEN OrderFreightCd = 'WILL CALL' THEN 'WC'		--Do Not Use This Code
			    WHEN OrderFreightCd = '' THEN 'Blank'
			    WHEN OrderFreightCd is null THEN 'Blank'
			    ELSE OrderFreightCd
			 END
WHERE	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)



---------------------------------------------------------------


UPDATE	SOHeader
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
WHERE	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


--UPDATE OrderPriorityCd & OrderExpdCd
UPDATE	SOHeader
SET	OrderPriorityCd = CASE OrderCarrier
			     WHEN 'WC' THEN 'WC'
			     	       ELSE 'N'
			  END,
	OrderExpdCd =     CASE OrderCarrier
			     WHEN 'WC' THEN 'WC'
			     	       ELSE 'AR'
			  END
WHERE	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)



------------------------------------------------------------------------------------


--UPDATE PriceCd
UPDATE	SOHeader
SET	PriceCd = Cust.PriceCd
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster Cust
WHERE	SellToCustNo = CustNo AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)



-------------------------------------------------------------------------------------


--[Porteous$Transfer Line]
SELECT	SOHeader.pSOHeaderID as fSOHeaderID,
	NVLINE.[Line No_] as LineNumber,
	NVLINE.[Line No_] as LineSeq,
	'S' as LineType,
	SOHeader.ReasonCd as LineReason,
	SOHeader.OrderExpdCd as LineExpdCd,
	NVLINE.[Item No_] as ItemNo,
	NVLINE.[Description] as ItemDsc,
	'STOCK' as BinLoc,
	SOHeader.ShipLoc as IMLoc,
	'A' as CostInd,
	SOHeader.PriceCd as PriceCd,
	'' as QtyStat,
	0 as ComPct,
	0 as ComDol,
	0 as NetUnitPrice,
	0 as ListUnitPrice,
	0 as DiscUnitPrice,
	0 as DiscPct1,
	0 as DiscPct2,
	0 as DiscPct3,
	'' as QtyAvailLoc1,
	0 as QtyAvail1,
	'' as QtyAvailLoc2,
	0 as QtyAvail2,
	'' as QtyAvailLoc3,
	0 as QtyAvail3,
	0 as OrigOrderLineNo,
	NVLINE.[Shipment Date] as RqstdShipDt,
	NVLINE.[Shipment Date] as OrigShipDt,
	ROUND(NVLINE.[Qty_ to Ship],0,1) as QtyOrdered,
	ROUND(NVLINE.[Qty_ to Ship],0,1) as QtyShipped,
	0 as QtyBO,
	0 as UnitCost,
	0 as UnitCost2,
	0 as UnitCost3,
	0 as RepCost,
	0 as OECost,
	'' as Remark,
	'' as CustItemNo,
	'' as CustItemDsc,
	NVLINE.[Status] as StatusCd,
	NVLINE.[Gross Weight] as GrossWght,
	NVLINE.[Net Weight] as NetWght,
	0 as ExtendedPrice,
	0 as ExtendedCost,
	ROUND(NVLINE.[Qty_ to Ship],0,1) * NVLINE.[Net Weight] as ExtendedNetWght,
	ROUND(NVLINE.[Qty_ to Ship],0,1) * NVLINE.[Gross Weight] as ExtendedGrossWght,
	'' as QtyStatus,
	1 as ExcludedFromUsageFlag,
	ROUND(NVLINE.[Qty_ to Ship],0,1) as OriginalQtyRequested,
	SOHeader.OrderCarrier as CarrierCd,
	SOHeader.OrderFreightCd as FreightCd
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Transfer Line] NVLINE INNER JOIN
	SOHeader
ON	NVLINE.[Document No_] = SOHeader.RefSONo INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item
ON	NVLINE.[Item No_] = Item.ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemBranch ItemBr
ON	Item.pItemMasterID = ItemBr.fItemMasterID
WHERE	ROUND(NVLINE.[Qty_ to Ship],0,1) > 0 AND NVLINE.[Item No_]<>'' AND SOHeader.ShipLoc = ItemBr.Location AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)



---------------------------------------------------------------------------------------


--[Porteous$Inventory Comment Line] - Transfer Header Comments
SELECT	SOHeader.pSOHeaderID as fSOHeaderID,
	'CT' as Type,
	'A' as FormsCd,
	0 as CommLineNo,
	[Line No_] as CommLineSeqNo,
	[Comment] as CommText,
	[Date] as EntryDt --,
	--[User ID] as EntryID
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Inventory Comment Line] COMMLINE INNER JOIN
	SOHeader ON COMMLINE.[No_] = SOHeader.RefSONo
WHERE	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


-------------------------------------------------------------------------------------------


--[Porteous$Transfer Line Comment Line] - Line Comments
SELECT	SOHeader.pSOHeaderID as fSOHeaderID,
	'LC' as Type,
	'A' as FormsCd,
	[Doc_ Line No_] as CommLineNo,
	[Line No_] as CommLineSeqNo,
	[Comment] as CommText,
	[User ID] as EntryID,
	[Date] as EntryDt
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Transfer Line Comment Line] COMMLINE INNER JOIN
	SOHeader ON COMMLINE.[No_] = SOHeader.RefSONo
WHERE	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)



-------------------------------------------------------------------------------------------


--UPDATE OrderNo
UPDATE	SOHeader
SET	OrderNo = pSOHeaderID,
	fSOHeaderID = pSOHeaderID
WHERE	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


--------------------------------------------------------------------------------------------



--UPDATE OrderTypeDesc & SubType
UPDATE	SOHeader
SET	OrderTypeDsc = ListDtlDesc,
	SubType = SequenceNo
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail
ON	pListMasterID=fListMasterID INNER JOIN
	SOHeader
ON	OrderType = ListValue
WHERE	ListName='soeordertypes' AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)



--------------------------------------------------------------------------------------------



--Update Location Names - OrderLocName, ShipLocName, UsageLocName

--SET OrderLocName
UPDATE	SOHeader
SET	OrderLocName = LocName
FROM	(SELECT	DISTINCT LocID, LocName
	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.LocMaster INNER JOIN
		SOHeader
	 ON	LocID = OrderLoc) Loc
WHERE	Loc.LocID = OrderLoc AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


--SET ShipLocName
UPDATE	SOHeader
SET	ShipLocName = LocName
FROM	(SELECT	DISTINCT LocID, LocName
	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.LocMaster INNER JOIN
		SOHeader
	 ON	LocID = ShipLoc) Loc
WHERE	Loc.LocID = ShipLoc AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


--SET UsageLocName
UPDATE	SOHeader
SET	UsageLocName = LocName
FROM	(SELECT	DISTINCT LocID, LocName
	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.LocMaster INNER JOIN
		SOHeader
	 ON	LocID = UsageLoc) Loc
WHERE	Loc.LocID = UsageLoc AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


----------------------------------------------------------------------------------

UPDATE	SOHeader
SET	OrderFreightName = Fght.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Fght
WHERE	TableType = 'Fght' AND OrderFreightCd = Fght.TableCd AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


--------------------------------------------------------------------------------


UPDATE	SOHeader
SET	OrderCarName = Car.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Car
WHERE	TableType = 'CAR' AND OrderCarrier = Car.TableCd AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


--------------------------------------------------------------------------------


--UPDATE ReasonCdName
UPDATE	SOHeader
SET	ReasonCdName = Reas.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Reas
WHERE	TableType = 'Reas' AND SOHeader.ReasonCd = Reas.TableCd AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


--UPDATE LineReasonDsc
UPDATE	SODetail
SET	LineReasonDsc = Reas.ShortDsc
FROM	SODetail INNER JOIN
	SOHeader
ON	pSOHeaderID = SODetail.fSOHeaderID INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Reas
ON	SODetail.LineReason = Reas.TableCd
WHERE	TableType = 'Reas' AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


--UPDATE HoldReasonName
UPDATE	SOHeader
SET	HoldReasonName = Reas.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Reas
WHERE	TableType = 'Reas' AND SOHeader.HoldReason = Reas.TableCd AND
	SOHeader.HoldReason <> '' AND SOHeader.HoldReason is not null AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


----------------------------------------------------------------------------------------


--UPDATE SalesRepName
UPDATE	SOHeader
SET	SalesRepName = LEFT([Name],40)
FROM	PFCLive.dbo.[Porteous$Salesperson_Purchaser]
WHERE	SalesRepNo = [Code] COLLATE SQL_Latin1_General_CP1_CI_AS AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


--UPDATE CustSvcRepName
UPDATE	SOHeader
SET	CustSvcRepName = LEFT([Name],40)
FROM	PFCLive.dbo.[Porteous$Salesperson_Purchaser]
WHERE	CustSvcRepNo = [Code] COLLATE SQL_Latin1_General_CP1_CI_AS AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


------------------------------------------------------------------------------------------


--UPDATE OrderPriName
UPDATE	SOHeader
SET	OrderPriName = Pri.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Pri
WHERE	TableType = 'Pri' AND SOHeader.OrderPriorityCd = Pri.TableCd AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


--UPDATE OrderExpdCdName
UPDATE	SOHeader
SET	OrderExpdCdName = Expd.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Expd
WHERE	TableType = 'Expd' AND SOHeader.OrderExpdCd = Expd.TableCd AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


--UPDATE LineExpdCdDsc
UPDATE	SODetail
SET	LineExpdCdDsc = Expd.ShortDsc
FROM	SODetail INNER JOIN
	SOHeader
ON	pSOHeaderID = SODetail.fSOHeaderID INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Expd
ON	SODetail.LineExpdCd = Expd.TableCd
WHERE	TableType = 'Expd' AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


--------------------------------------------------------------------------------------------


--UPDATE SellStkUM, SellStkQty, AlternateUMQty, AlternateUM & SuperEquivUM
UPDATE	SODetail
SET	SellStkUM = Item.SellStkUM,
	SellStkQty = Item.SellStkUMQty,
	AlternateUMQty = Item.SellStkUMQty,
	AlternateUM = Item.SellUM,
	SuperEquivUM = Item.SuperUM
FROM	SODetail INNER JOIN
	SOHeader
ON	pSOHeaderID = SODetail.fSOHeaderID INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item
ON	SODetail.ItemNo = Item.ItemNo
WHERE	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)



--------------------------------------------------------------------------------------------



--UPDATE SellStkFactor
UPDATE	SODetail
SET	SellStkFactor = UM.QtyPerUM
FROM	SODetail INNER JOIN
	SOHeader
ON	pSOHeaderID = SODetail.fSOHeaderID INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item
ON	SODetail.ItemNo = Item.ItemNo INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemUM UM
ON	Item.pItemMasterID = UM.fItemMasterID
WHERE	UM.UM = Item.SellStkUM AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


--UPDATE SuperEquivQty
UPDATE	SODetail
SET	SuperEquivQty = UM.QtyPerUM
FROM	SODetail INNER JOIN
	SOHeader
ON	pSOHeaderID = SODetail.fSOHeaderID INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item
ON	SODetail.ItemNo = Item.ItemNo INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemUM UM
ON	Item.pItemMasterID = UM.fItemMasterID
WHERE	UM.UM = Item.SuperUM AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


--UPDATE AlternatePrice
UPDATE	SODetail
SET	AlternatePrice = CASE UM.AltSellStkUMQty
				WHEN 0 THEN 0
				ELSE NetUnitPrice / UM.AltSellStkUMQty
			 END
FROM	SODetail INNER JOIN
	SOHeader
ON	pSOHeaderID = SODetail.fSOHeaderID INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item
ON	SODetail.ItemNo = Item.ItemNo INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemUM UM
ON	Item.pItemMasterID = UM.fItemMasterID
WHERE	UM.UM = Item.SellUM AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


-------------------------------------------------------------------------------------------------


--UPDATE TotalCost & TotalCost2
UPDATE	SOHeader
SET	TotalCost = OrderExt,
	TotalCost2 = OrderExt2
FROM	(SELECT	RefSONo,
		SUM(SODetail.QtyOrdered * SODetail.UnitCost) as OrderExt,
		SUM(SODetail.QtyOrdered * SODetail.UnitCost2) as OrderExt2
	 FROM	SODetail INNER JOIN
		SOHeader
	 ON	SODetail.fSOHeaderID = SOHeader.pSOHeaderID
	 Group By RefSONo) ExtOrder
WHERE	ExtOrder.RefSONo = SoHeader.RefSONo AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)



-------------------------------------------------------------------------------------------------


--UPDATE NetSales 
UPDATE	SOHeader
SET	NetSales = OrderExt
FROM	(SELECT	RefSONo, SUM(SODetail.QtyOrdered * SODetail.NetUnitPrice) as OrderExt
	 FROM	SODetail INNER JOIN
		SOHeader
	 ON	SODetail.fSOHeaderID = SOHeader.pSOHeaderID
	 Group By RefSONo) ExtOrder
WHERE	ExtOrder.RefSONo = SoHeader.RefSONo AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)



-------------------------------------------------------------------------------------------------



--UPDATE NonTaxAmt
UPDATE	SOHeader
SET	NonTaxAmt = OrderExt
FROM	(SELECT	RefSONo, SUM(SODetail.QtyOrdered * SODetail.NetUnitPrice) as OrderExt
	 FROM	SODetail INNER JOIN
		SOHeader
	 ON	SODetail.fSOHeaderID = SOHeader.pSOHeaderID
	 Group By RefSONo) ExtOrder
WHERE	ExtOrder.RefSONo = SoHeader.RefSONo AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)




--UPDATE TotalOrder
UPDATE	SOHeader
SET	TotalOrder = ISNULL(TaxSum,0) + ISNULL(NonTaxAmt,0) + ISNULL(TaxExpAmt,0) + ISNULL(NonTaxExpAmt,0) + ISNULL(TaxAmt,0)
FROM	SOHeader
WHERE	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)




--UPDATE ShipWght & BOLWght
UPDATE	SOHeader
SET	ShipWght = ExtGrossWght,
	BOLWght = ExtGrossWght
FROM	(SELECT	RefSONo, SUM(SODetail.QtyOrdered * SODetail.GrossWght) as ExtGrossWght
	 FROM	SODetail INNER JOIN
		SOHeader
	 ON	SODetail.fSOHeaderID = SOHeader.pSOHeaderID
	 Group By RefSONo) ExtWght
WHERE	ExtWght.RefSONo = SoHeader.RefSONo AND
	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)


----------------------------------------------------------------------------------------------


SELECT	OrderNo AS [ERP Order No], RefSONo, ShipLoc AS [Trf From Loc], CustShipLoc AS [Trf To Loc],
	ShipToCd AS [Ship To Cust], ShipToName AS [Ship to Name], CustPONo AS [Cust PO No],
	CASE
	    WHEN DATEPART(yyyy,SchShipDt) < 1900 THEN ''
	    ELSE CAST(DATEPART(mm,SchShipDt) AS VARCHAR(2))+'/'+CAST(DATEPART(dd,SchShipDt) AS VARCHAR(2))+'/'+CAST(DATEPART(yyyy,SchShipDt) AS VARCHAR(4))
	END AS [Sched Ship Date],
	CASE
	    WHEN DATEPART(yyyy,CustReqDt) < 1900 THEN ''
	    ELSE CAST(DATEPART(mm,CustReqDt) AS VARCHAR(2))+'/'+CAST(DATEPART(dd,CustReqDt) AS VARCHAR(2))+'/'+CAST(DATEPART(yyyy,CustReqDt) AS VARCHAR(4))
	END AS [Req Delivery Date]
FROM	SOHeader
WHERE	EXISTS (SELECT	RefSONo
--		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		FROM	PFCLive.dbo.tWO1433_LoadAutoTrf Trf
		WHERE	Trf.RefSONo = SOHeader.RefSONo COLLATE Latin1_General_CS_AS)
Order By ShipLoc, CustShipLoc, RefSONo



----------------------------------------------------------------------------------------------



IF ((SELECT	COUNT(*)
--   FROM	SOHeader
     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SOHeader SOHeader
     WHERE	EXISTS (SELECT	RefSONo
--			FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
			FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1433_LoadAutoTrf Trf
			WHERE	Trf.RefSONo = SOHeader.RefSONo)) > 0)
  BEGIN
     PRINT 'Transfer Orders Found'
     Exec DTQ_SP_SendMailWithAttachment 'it_ops@porteousfastener.com','tdixon@porteousfastener.com',						--TO & FROM
     					'New Transfer Orders from NaVision  [WO1433_LoadAutoTrf]',						--Subject
     					'Please see the list (attached) of Auto Distribution Transfer orders moved from NaVision to ERP.',	--Body
     					'\\pfcfiles\userdb\WO1433_LoadAutoTrf.csv'								--Attachment
  END
ELSE 
  BEGIN
     PRINT 'No Transfer Orders Found'
--   Exec DTQ_SP_SendMailWithAttachment 'it_ops@porteousfastener.com','it_ops@porteousfastener.com',						--TO & FROM
     Exec DTQ_SP_SendMailWithAttachment 'it_ops@porteousfastener.com','tdixon@porteousfastener.com',						--TO & FROM
     					'Complete: WO1433_LoadAutoTrf',										--Subject
     					'WO1433_LoadAutoTrf.dts appears to have completed successfully.<br>No Transfer Orders found.',		--Body
     					''													--Attachment
  END
