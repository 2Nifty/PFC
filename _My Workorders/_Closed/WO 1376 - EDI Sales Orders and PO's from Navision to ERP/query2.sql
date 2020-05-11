


--UPDATE OrderLoc  (PFCQuote.Umbrella)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeader
SET	OrderLoc = [CompanyID]
FROM	(SELECT	DISTINCT UserName, RIGHT('00'+CAST([CompanyID] AS VARCHAR(2)),2) AS [CompanyID], Hdr.RefSONo AS NVSONo
	 FROM	UCOR_UserSetup INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeader Hdr
	 ON	UserName = EntryID INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
	 ON	TempSO.RefSONo = Hdr.RefSONo) Loc
WHERE	Loc.UserName = EntryID AND Loc.NVSONo = RefSONo


-----------------------------------------------------------------------------------------------


--UPDATE OrderTermsName
UPDATE	SOHeader
SET	OrderTermsName = [Description]
FROM	(SELECT	DISTINCT Code, [Description]
	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Payment Terms] INNER JOIN
		SOHeader
	 ON	OrderTermsCd = Code COLLATE SQL_Latin1_General_CP1_CI_AS) Terms
WHERE	Terms.Code = OrderTermsCd COLLATE SQL_Latin1_General_CP1_CI_AS AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


-----------------------------------------------------------------------------------------------

--UPDATE PriceCd
UPDATE	SOHeader
SET	PriceCd = Cust.PriceCd
FROM	CustomerMaster Cust
WHERE	SellToCustNo = CustNo AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)



--------------------------------------------------------------------------------------------------------


--[Porteous$Sales Line]
SELECT	SOHeader.pSOHeaderID as fSOHeaderID,
	NVLINE.[Line No_] as LineNumber,
	NVLINE.[Line No_] as LineSeq,
	'S' as LineType,
	CASE [Unit Price Origin]
	     WHEN '' THEN 'E'
	     WHEN 'CP' THEN 'P'
	     WHEN 'CPDP' THEN 'P'
	     WHEN 'IUP' THEN 'L'
	     WHEN 'OVERRIDE' THEN 'E'
	     WHEN 'OVR' THEN 'E'
	     WHEN 'SDUP' THEN 'D'
	     WHEN 'SPUP' THEN 'C'
	     ELSE 'E'
	END as LinePriceInd,
	SOHeader.ReasonCd as LineReason,
	SOHeader.OrderExpdCd as LineExpdCd,
	NVLINE.[No_] as ItemNo,
	NVLINE.[Description] as ItemDsc,
	'STOCK' as BinLoc,
	SOHeader.ShipLoc as IMLoc,
	NVLINE.[Allow Invoice Disc_] as DiscInd,
	'A' as CostInd,
	SOHeader.PriceCd as PriceCd,
	CASE [Unit Price Origin]
	     WHEN '' THEN 'E'
	     WHEN 'CP' THEN 'P'
	     WHEN 'CPDP' THEN 'P'
	     WHEN 'IUP' THEN 'L'
	     WHEN 'OVERRIDE' THEN 'E'
	     WHEN 'OVR' THEN 'E'
	     WHEN 'SDUP' THEN 'D'
	     WHEN 'SPUP' THEN 'C'
	     ELSE 'E'
	END as LISource,
	NVLINE.[Net Unit Price] as NetUnitPrice,
	NVLINE.[Unit Price] as ListUnitPrice,
	[Unit Price] - ([Unit Price] * [Line Discount %] * 0.01) as DiscUnitPrice,
	[Line Discount %] as DiscPct1,
	'' as QtyAvailLoc1,
	0 as QtyAvail1,
	NVLINE.[Shipment Date] as RqstdShipDt,
	NVLINE.[Shipment Date] as OrigShipDt,
	ROUND(NVLINE.[Quantity],0,1) as QtyOrdered,
	ROUND(NVLINE.[Quantity Shipped],0,1) as QtyShipped,
	ROUND(NVLINE.[Back Order Qty],0,1) as QtyBO,
--	NVLINE.[Unit Cost] as UnitCost,
	ItemBr.UnitCost AS UnitCost,
	ItemBr.UnitCost AS UnitCost2,
	ItemBr.UnitCost AS UnitCost3,
	ItemBr.UnitCost AS RepCost,
	ROUND(NVLINE.[Quantity],0,1) * ItemBr.UnitCost as OECost,
	NVLINE.[Cross-Reference No_] as CustItemNo,
	SOHeader.EntryDt as EntryDate,
	SOHeader.EntryID as EntryID,
	NVLINE.[Status] as StatusCd,
	NVLINE.[Gross Weight] as GrossWght,
	NVLINE.[Net Weight] as NetWght,
	ROUND(NVLINE.[Quantity],0,1) * NVLINE.[Net Unit Price] as ExtendedPrice,
	ROUND(NVLINE.[Quantity],0,1) * ItemBr.UnitCost as ExtendedCost,
	ROUND(NVLINE.[Quantity],0,1) * NVLINE.[Net Weight] as ExtendedNetWght,
	ROUND(NVLINE.[Quantity],0,1) * NVLINE.[Gross Weight] as ExtendedGrossWght,
	isnull(NVLINE.[Excl_ from Usage],0) as ExcludeFromUsageFlag,
	ROUND(NVLINE.[Quantity],0,1) as OriginalQtyRequested,
	NVLINE.[Usage Location] as UsageLoc,
	SOHeader.OrderCarrier as CarrierCd,
	SOHeader.OrderFreightCd as FreightCd
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Line] NVLINE INNER JOIN
	SOHeader
ON	NVLINE.[Document No_] = SOHeader.RefSONo INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item
ON	NVLINE.[No_] = Item.ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemBranch ItemBr
ON	Item.pItemMasterID = ItemBr.fItemMasterID
WHERE	ROUND(NVLINE.[Quantity],0,1) > 0 AND NVLINE.No_ <> '' AND NVLINE.Type=2 AND SOHeader.ShipLoc = ItemBr.Location AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


-------------------------------------------------------------------------


--[Porteous$Sales Line] - Adjustments & Expenses
SELECT	SOHeader.pSOHeaderID as fSOHeaderID,
	NVLINE.[Line No_] as LineNumber,
	NVLINE.[No_] as ExpenseCd,
	ROUND(NVLINE.[Quantity],0,1) * [Unit Price] as Amount,
	NVLINE.[Type] as ExpenseInd,
	'N' as TaxStatus,
	SOHeader.RefSONo as DocumentLoc,
	SOHeader.EntryID as EntryID,
	SOHeader.EntryDt as EntryDt,
	NVLINE.[Description] as ExpenseDesc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	SOHeader ON NVLINE.[Document No_] = SOHeader.RefSONo
WHERE	ROUND(NVLINE.[Quantity],0,1) <> 0 AND [Unit Price] <> 0 AND NVLINE.Type <> 2 AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


-------------------------------------------------------------------------


--[Porteous$Sales Comment Line] - Header Comments
SELECT	SOHeader.pSOHeaderID as fSOHeaderID,
	'CT' as Type,
	'A' as FormsCd,
	0 as CommLineNo,
	[Line No_] as CommLineSeqNo,
	[Comment] as CommText,
	[User ID] as EntryID,
	[Date] as EntryDt
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Comment Line] COMMLINE INNER JOIN
	SOHeader ON COMMLINE.[No_] = SOHeader.RefSONo
WHERE	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)



-------------------------------------------------------------------------


--[Porteous$Sales Line Comment Line] - Line Comments
SELECT	SOHeader.pSOHeaderID as fSOHeaderID,
	'LC' as Type,
	'A' as FormsCd,
	[Doc_ Line No_] as CommLineNo,
	[Line No_] as CommLineSeqNo,
	[Comment] as CommText,
	[User ID] as EntryID,
	[Date] as EntryDt
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Line Comment Line] COMMLINE INNER JOIN
	SOHeader ON COMMLINE.[No_] = SOHeader.RefSONo
WHERE	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)




-------------------------------------------------------------------------



--UPDATE OrderNo
UPDATE	SOHeader
SET	OrderNo = pSOHeaderID
WHERE	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


-------------------------------------------------------------------------

--UPDATE OrderTypeDesc & SubType
UPDATE	SOHeader
SET	OrderTypeDsc = ListDtlDesc,
	SubType = SequenceNo
FROM	ListMaster INNER JOIN
	ListDetail
ON	pListMasterID=fListMasterID INNER JOIN
	SOHeader
ON	OrderType = ListValue
WHERE	ListName='soeordertypes' AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


-------------------------------------------------------------------------

--Update Location Names - OrderLocName, ShipLocName, UsageLocName

--SET OrderLocName
UPDATE	SOHeader
SET	OrderLocName = LocName
FROM	(SELECT	DISTINCT LocID, LocName
	 FROM	LocMaster INNER JOIN
		SOHeader
	 ON	LocID = OrderLoc) Loc
WHERE	Loc.LocID = OrderLoc AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


--SET ShipLocName
UPDATE	SOHeader
SET	ShipLocName = LocName
FROM	(SELECT	DISTINCT LocID, LocName
	 FROM	LocMaster INNER JOIN
		SOHeader
	 ON	LocID = ShipLoc) Loc
WHERE	Loc.LocID = ShipLoc AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


--SET UsageLocName
UPDATE	SOHeader
SET	UsageLocName = LocName
FROM	(SELECT	DISTINCT LocID, LocName
	 FROM	LocMaster INNER JOIN
		SOHeader
	 ON	LocID = UsageLoc) Loc
WHERE	Loc.LocID = UsageLoc AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


-------------------------------------------------------------------------

UPDATE	SODetail
SET	QtyShipped = QtyOrdered
FROM	SODetail INNER JOIN
	SOHeader
ON	pSOHeaderID = SODetail.fSOHeaderID
WHERE	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


-------------------------------------------------------------------------


UPDATE	SOHeader
SET	OrderFreightName = Fght.ShortDsc
FROM	Tables Fght
WHERE	TableType = 'Fght' AND OrderFreightCd = Fght.TableCd AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)



-------------------------------------------------------------------------


UPDATE	SOHeader
SET	OrderCarName = Car.ShortDsc
FROM	Tables Car
WHERE	TableType = 'CAR' AND OrderCarrier = Car.TableCd AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


-------------------------------------------------------------------------


--UPDATE ReasonCdName
UPDATE	SOHeader
SET	ReasonCdName = Reas.ShortDsc
FROM	Tables Reas
WHERE	TableType = 'Reas' AND SOHeader.ReasonCd = Reas.TableCd AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


--UPDATE LineReasonDsc
UPDATE	SODetail
SET	LineReasonDsc = Reas.ShortDsc
FROM	SODetail INNER JOIN
	SOHeader
ON	pSOHeaderID = SODetail.fSOHeaderID INNER JOIN
	Tables Reas
ON	SODetail.LineReason = Reas.TableCd
WHERE	TableType = 'Reas' AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


-------------------------------------------------------------------------

--UPDATE SalesRepName
UPDATE	SOHeader
SET	SalesRepName = LEFT([Name],40)
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Salesperson_Purchaser]
WHERE	SalesRepNo = [Code] COLLATE SQL_Latin1_General_CP1_CI_AS AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


--UPDATE CustSvcRepName
UPDATE	SOHeader
SET	CustSvcRepName = LEFT([Name],40)
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Salesperson_Purchaser]
WHERE	CustSvcRepNo = [Code] COLLATE SQL_Latin1_General_CP1_CI_AS AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


-------------------------------------------------------------------------


--UPDATE OrderPriName
UPDATE	SOHeader
SET	OrderPriName = Pri.ShortDsc
FROM	Tables Pri
WHERE	TableType = 'Pri' AND SOHeader.OrderPriorityCd = Pri.TableCd AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


--UPDATE OrderExpdCdName
UPDATE	SOHeader
SET	OrderExpdCdName = Expd.ShortDsc
FROM	Tables Expd
WHERE	TableType = 'Expd' AND SOHeader.OrderExpdCd = Expd.TableCd AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


--UPDATE LineExpdCdDsc
UPDATE	SODetail
SET	LineExpdCdDsc = Expd.ShortDsc
FROM	SODetail INNER JOIN
	SOHeader
ON	pSOHeaderID = SODetail.fSOHeaderID INNER JOIN
	Tables Expd
ON	SODetail.LineExpdCd = Expd.TableCd
WHERE	TableType = 'Expd' AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


-------------------------------------------------------------------------


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
	ItemMaster Item
ON	SODetail.ItemNo = Item.ItemNo
WHERE	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


-------------------------------------------------------------------------


--UPDATE SellStkFactor
UPDATE	SODetail
SET	SellStkFactor = UM.QtyPerUM
FROM	SODetail INNER JOIN
	SOHeader
ON	pSOHeaderID = SODetail.fSOHeaderID INNER JOIN
	ItemMaster Item
ON	SODetail.ItemNo = Item.ItemNo INNER JOIN
	ItemUM UM ON Item.pItemMasterID = UM.fItemMasterID
WHERE	UM.UM = Item.SellStkUM AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


--UPDATE SuperEquivQty
UPDATE	SODetail
SET	SuperEquivQty = UM.QtyPerUM
FROM	SODetail INNER JOIN
	SOHeader
ON	pSOHeaderID = SODetail.fSOHeaderID INNER JOIN
	ItemMaster Item
ON	SODetail.ItemNo = Item.ItemNo INNER JOIN
	ItemUM UM ON Item.pItemMasterID = UM.fItemMasterID
WHERE	UM.UM = Item.SuperUM AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


--UPDATE AlternatePrice
UPDATE	SODetail
SET	AlternatePrice = CASE UM.AltSellStkUMQty
				WHEN 0 THEN 0
				ELSE NetUnitPrice / UM.AltSellStkUMQty
			 END
FROM	SODetail INNER JOIN
	SOHeader
ON	pSOHeaderID = SODetail.fSOHeaderID INNER JOIN
	ItemMaster Item
ON	SODetail.ItemNo = Item.ItemNo INNER JOIN
	ItemUM UM ON Item.pItemMasterID = UM.fItemMasterID
WHERE	UM.UM = Item.SellUM AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)



-------------------------------------------------------------------------

--UPDATE UnitCost
UPDATE	SODetail
SET	UnitCost = ISNULL(NULLIF(ISNULL(NULLIF (AvgCostTbl.EndAC, 0), AvgCostTbl.BegAC),0), SODetail.UnitCost)
FROM	SODetail INNER JOIN
	SOHeader ON SODetail.fSOHeaderID = SOHeader.pSOHeaderID INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCAC.dbo.[AvgCst_Daily] AvgCostTbl
ON	AvgCostTbl.Branch = SODetail.IMLoc AND AvgCostTbl.ItemNo = SODetail.ItemNo --AND AvgCostTbl.CurDate = MakeOrderDt
WHERE	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


--UPDATE UnitCost2 & UnitCost3
UPDATE	SODetail
SET	UnitCost2 = UnitCost,
	Unitcost3 = UnitCost,
	RepCost = UnitCost
FROM	SODetail INNER JOIN
	SOHeader ON SODetail.fSOHeaderID = SOHeader.pSOHeaderID
WHERE	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)



-------------------------------------------------------------------------

--UPDATE TotalCost & TotalCost2
UPDATE	SOHeader
SET	TotalCost = OrderExt,
	TotalCost2 = OrderExt
FROM	(SELECT	RefSONo, SUM(SODetail.QtyOrdered * SODetail.UnitCost) as OrderExt
	 FROM	SODetail INNER JOIN
		SOHeader
	 ON	SODetail.fSOHeaderID = SOHeader.pSOHeaderID
	 Group By RefSONo) ExtOrder
WHERE	ExtOrder.RefSONo = SoHeader.RefSONo AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


-------------------------------------------------------------------------

--UPDATE ExtendedCost & OECost
UPDATE	SODetail
SET	ExtendedCost = UnitCost * QtyOrdered,
	OECost = UnitCost * QtyOrdered
FROM	SODetail INNER JOIN
	SOHeader
ON	SODetail.fSOHeaderID = SOHeader.pSOHeaderID
WHERE	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)

-------------------------------------------------------------------------

-------NOT NEEDED, OrderType default to PEDI

--UPDATE ExcludedFromUsageFlag
UPDATE	SODetail
SET	ExcludedFromUsageFlag = 1
FROM	SODetail INNER JOIN
	SOHeader
ON	SODetail.fSOHeaderID = SOHeader.pSOHeaderID
WHERE	(SOHeader.OrderType IN ('1', '4')) AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


-------------------------------------------------------------------------


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
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


-------------------------------------------------------------------------

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
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)

-------------------------------------------------------------------------

--UPDATE NonTaxExpAmt
UPDATE	SOHeader
SET	NonTaxExpAmt = ExtExpense
FROM	(SELECT	SOExpense.fSOHeaderID, SUM(Amount) as ExtExpense
	 FROM	SOExpense INNER JOIN
		SOHeader
	 ON	SOExpense.fSOHeaderID = SOHeader.pSOHeaderID
	 Group By SOExpense.fSOHeaderID) ExtExp
WHERE	ExtExp.fSOHeaderID = SOHeader.pSOHeaderID AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)

-------------------------------------------------------------------------

--UPDATE TotalOrder
UPDATE	SOHeader
SET	TotalOrder = ISNULL(NetSales,0) + ISNULL(TaxSum,0) + ISNULL(NonTaxAmt,0) + ISNULL(TaxExpAmt,0) + ISNULL(NonTaxExpAmt,0) + ISNULL(TaxAmt,0)
FROM	SOHeader
WHERE	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)

-------------------------------------------------------------------------

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
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


-------------------------------------------------------------------------
-------------------------------------------------------------------------


\\pfcfiles\userdb\WO1376_NoShipLoc.csv

SELECT	RefSONo, ShipLoc,
	ShipToCd, ShipToName, ShipToAddress3, ShipToAddress1, ShipToAddress2, City, State, Zip,
	SellToCustNo, SellToCustName, SellToAddress1, SellToAddress2, SellToCity, SellToState, SellToZip,
	CustSvcRepName, EntryID
FROM	SOHeader
WHERE	ShipLoc is NULL or ShipLoc = '' or ShipLoc='0' or ShipLoc='00'


-------------------------------------------------------------------------


SELECT	OrderNo AS [ERP Order No], RefSONo, CustShipLoc AS [Sales Loc], ShipLoc AS [Shipping Loc], SellToCustNo AS [Sell To Cust], SellToCustName AS [Cust Name], CustPONo AS [Cust PO No],
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
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)
Order By CustShipLoc, RefSONo





IF ((SELECT	COUNT(*)
     FROM	SOHeader
     WHERE	EXISTS (SELECT	RefSONo
			FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
			WHERE	TempSO.RefSONo = SOHeader.RefSONo)) > 0)
 BEGIN
    PRINT 'Not ZERO'
    RAISERROR (500000,10,1) WITH SETERROR
 END
ELSE 
 BEGIN
    PRINT 'ZERO'
 END


-------------------------------------------------------------------------



select * from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP


select SalesRepNo,SalesRepName,CustSvcRepNo,CustSvcRepName,  * from SOHeader inner join SODetail on pSOHeaderID=SODetail.fSOHeaderID
where OrderType='PEDI'



SELECT *
FROM	Tables Reas
WHERE	TableType = 'Reas' 


select ListDetail.* 
FROM	ListMaster INNER JOIN
	ListDetail
ON	pListMasterID=fListMasterID
WHERE	ListName='soeordertypes'
order by ListValue




delete SODetail from SODetail inner join SOHeader on pSOHeaderID=SODetail.fSOHeaderID where OrderType='PEDI'

delete SOComments from SOComments inner join SOHeader on pSOHeaderID=SOComments.fSOHeaderID where OrderType='PEDI'

DELETE from SOHeader where OrderType='PEDI'



select * from CustomerMaster where CustNo='063881' or CustNo='081433' or CustNo='200301' or CustNo='004401'



select MAX(RefSONo) from SOHeader where left(RefSONo,2)='SO'





---------------------------------------------------------------------------
