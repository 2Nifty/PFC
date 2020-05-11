select	PriceCd, TotalCost, TotalCost2, CommDol, DiscPct, NonTaxAmt, TaxExpAmt,NonTaxExpAmt, TaxAmt,
	ShipWght, BolWght, ReasonCd, ReasonCdName, OrderPriorityCd, OrderPriName, OrderExpdCd, OrderExpdCdName,
	SalesRepNo, SalesRepName, CustSvcrepNo, CustSvcRepName, OrderCarrier, OrderCarName, OrderFreightCd, OrderFreightName,
	DocumentSortInd, *
from	SOHeader


Select AlternatePrice,
AlternateUM,
AlternateUMQty,
BinLoc,
CostInd,
DiscUnitPrice,
LineExpdCd,
LineExpdCdDsc,
LinePriceInd,
LineReason,
LineReasonDsc,
LineSeq,
LineType,
LISource,
OriginalQtyRequested,
PriceCd,
QtyAvail1,
QtyAvailLoc1,
RepCost,
SellStkUM,
SellStkFactor,
SellStkQty,
SuperEquivQty,
SuperEquivUM,
UnitCost2,
UnitCost3,
UsageLoc,
OECost, *
from SODetail








--UPDATE SellStkUM, SellStkQty, AlternateUMQty, AlternateUM & SuperEquivUM
UPDATE	SODetail
SET	SellStkUM = Item.SellStkUM,
	SellStkQty = Item.SellStkUMQty,
	AlternateUMQty = Item.SellStkUMQty,
	AlternateUM = Item.SellUM,
	SuperEquivUM = Item.SuperUM
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item
WHERE	SODetail.ItemNo = Item.ItemNo




select 	--[SellStkQty],[AlternateUM], [AlternateUMQty], 
	[No_], [Quantity], [List Price], [Unit Price Origin],
	[Unit Price], [Line Discount %], [Line Discount Amount], * from PFCLive.dbo.[Porteous$Sales Line]
where 	[No_]='00680-1418-401' or 
	[No_]='00200-2500-021' or
	[No_]='00370-2500-021'


select distinct [Unit Price Origin] from PFCLive.dbo.[Porteous$Sales Line]



select SellStkUM, SellStkUMQty, SellUM, SuperUM, *
from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster
where 	[ItemNo]='00680-1418-401' or 
	[ItemNo]='00200-2500-021' or
	[ItemNo]='00370-2500-021'
Order By ItemNo

select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemUm
where 	fItemMasterID=53848 or
	fItemMasterID=63359 or 
	fItemMasterID=91564
Order by fItemMasterID


select SellStkUM, SellStkFactor, SellStkQty, AlternateUMQty, AlternateUM, SuperEquivUM, SuperEquivQty, NetUnitPrice, AlternatePrice, ItemNo
from SODetail
where 	[ItemNo]='00680-1418-401' or 
	[ItemNo]='00200-2500-021' or
	[ItemNo]='00370-2500-021'
Order By ItemNo




select  [Base Unit of Measure], [Qty__Base UOM], *
from 	PFCLive.dbo.[Porteous$Item]
where 	[No_]='00680-1418-401' or 
	[No_]='00200-2500-021' or
	[No_]='00370-2500-021'

select * from PFCLive.dbo.[Porteous$Item Unit of Measure]
where 	[Item No_]='00680-1418-401' or 
	[Item No_]='00200-2500-021' or
	[Item No_]='00370-2500-021'




select CustNo,SODocSortInd
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster Cust
WHERE	SellToCustNo = CustNo



----------------------------------------------------------------------------




select SellToCustNo, PriceCd,TotalCost,TotalCost2,CommDol,DiscPct,
NonTaxAmt,
TaxExpAmt,NonTaxExpAmt,TaxAmt,BOLWght,

 *
from SOHeader
where PriceCd is  null or
TotalCost is null or TotalCost2 is null or CommDol is null or DiscPct is not null or
NonTaxAmt is null or 
TaxExpAmt is null or NonTaxExpAmt is null or TaxAmt is null or 
BOLWght is null





--UPDATE OrderLoc  (PFCQuote.Umbrella)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SOHeader
SET	OrderLoc = [CompanyID]
FROM	(SELECT	DISTINCT UserName, RIGHT('00'+CAST([CompanyID] AS VARCHAR(2)),2) AS [CompanyID]
	 FROM	UCOR_UserSetup INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SOHeader
	 ON	UserName = EntryID) Loc
WHERE	Loc.UserName = EntryID



--UPDATE PriceCd
UPDATE	SOHeader
SET	PriceCd = [Customer Price Code]
FROM	PFCLive.dbo.[Porteous$Customer]
WHERE	SellToCustNo = [No_] COLLATE SQL_Latin1_General_CP1_CI_AS


select PriceCd from SOHeader

UPDATE	SOHeader
SET	NonTaxAmt = 0
from SOHeader
WHERE	SOHeader.OrderType = 'TO'


--UPDATE NonTaxAmt
UPDATE	SOHeader
SET	NonTaxAmt = OrderExt
FROM	(SELECT	RefSONo, SUM(SODetail.QtyOrdered * SODetail.NetUnitPrice) as OrderExt
	 FROM	SODetail INNER JOIN
		SOHeader
	 ON	SODetail.fSOHeaderID = SOHeader.pSOHeaderID
	 Group By RefSONo) ExtOrder
WHERE	SOHeader.OrderType <> 'TO' AND ExtOrder.RefSONo = SoHeader.RefSONo


update SOHeader set ReasonCd='SO'

select ReasonCd,ReasonCdName,* from SOHeader

--UPDATE ReasonCdName
UPDATE	SOHeader
SET	ReasonCdName = Reas.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Reas
WHERE	TableType = 'Reas' AND SOHeader.ReasonCd = Reas.TableCd





select DocumentSortInd,* from SOHeader
where DocumentSortInd is not null


select SODocSortInd,*
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster Cust
where SODocSortInd is not null





--UPDATE DocumentSortInd
UPDATE	SOHeader
SET	DocumentSortInd = SODocSortInd
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster Cust
WHERE	SellToCustNo = CustNo



select OrderCarrier, OrderPriorityCd,OrderPriName, OrderExpdCd, OrderExpdCdName,* from SOHeader
--where OrderCarrier='WC'



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


--UPDATE OrderPriName
UPDATE	SOHeader
SET	OrderPriName = Pri.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Pri
WHERE	TableType = 'Pri' AND SOHeader.OrderPriorityCd = Pri.TableCd

--UPDATE OrderExpdCdName
UPDATE	SOHeader
SET	OrderExpdCdName = Expd.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Expd
WHERE	TableType = 'Expd' AND SOHeader.OrderExpdCd = Expd.TableCd



select * from PFCLive.dbo.[Porteous$Salesperson_Purchaser]


select SalesRepNo, SalesRepName,* from SOHeader


--UPDATE SalesRepName
UPDATE	SOHeader
SET	SalesRepName = LEFT([Name],40)
FROM	PFCLive.dbo.[Porteous$Salesperson_Purchaser]
WHERE	SalesRepNo = [Code] COLLATE SQL_Latin1_General_CP1_CI_AS



update SOHeader set CustSvcRepNo = CustSvcRepName

select CustSvcRepNo, CustSvcRepName from SOHeader


--UPDATE CustSvcRepName
UPDATE	SOHeader
SET	CustSvcRepName = LEFT([Name],40)
FROM	PFCLive.dbo.[Porteous$Salesperson_Purchaser]
WHERE	CustSvcRepNo = [Code] COLLATE SQL_Latin1_General_CP1_CI_AS