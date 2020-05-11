UPDATE	ItemBranchUsage



update	[Porteous$Actual Usage Entry]
set	[Porteous$Actual Usage Entry].[Item No_] = tempGrade8.[New number], [Porteous$Actual Usage Entry].[Source Item No_] = tempGrade8.[New number],
	[Porteous$Actual Usage Entry].[Cat_ No_] = SUBSTRING(tempGrade8.[New number], 1, 5),
	[Porteous$Actual Usage Entry].[Size No_] = SUBSTRING(tempGrade8.[New number], 7, 4),
	[Porteous$Actual Usage Entry].[Variance No_] = SUBSTRING(tempGrade8.[New number], 12, 3)
FROM         [Porteous$Actual Usage Entry] INNER JOIN
                      tempGrade8 ON [Porteous$Actual Usage Entry].[Item No_] = tempGrade8.[Old number]
WHERE     (tempGrade8.[Old number] <> tempGrade8.[New number])






select * from tWO2306_Grade8ItemList
select * from tWO2306_Grade8OldItem
drop table  tWO2306_Grade8NewItem



--DELETE existing OldItem transactions that were saved
DELETE
FROM	ItemBranchUsage
WHERE EXISTS	(SELECT	*
		 FROM	tWO2306_Grade8OldItem Grade8
		 WHERE	ItemBranchUsage.CurPeriodNo = Grade8.CurPeriodNo AND
			ItemBranchUsage.ItemNo = Grade8.NewItem AND
			ItemBranchUsage.Location = Grade8.Location)





SELECT	*
--INTO	tWO2306_Grade8OldItem
FROM	ItemBranchUsage
WHERE	ItemNo in (SELECT OldItem FROM tWO2306_Grade8ItemList)
go

SELECT	*
--INTO	tWO2306_Grade8NewItem
FROM	ItemBranchUsage
WHERE	ItemNo in (SELECT NewItem FROM tWO2306_Grade8ItemList)
go



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO2306_Grade8ItemList') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table dbo.tWO2306_Grade8ItemList

CREATE TABLE [tWO2306_Grade8ItemList] (
[OldItem] nvarchar (20) NULL, 
[NewItem] nvarchar (20) NULL )





select top 500 * from ItemBranchUsage






SELECT	ItemList.NewItem, OldItem.*
FROM	tWO2306_Grade8OldItem OldItem (NoLock) INNER JOIN
	tWO2306_Grade8ItemList ItemList (NoLock)
ON	OldItem.ItemNo = ItemList.OldItem




--UPDATE existing NewItem transactions
UPDATE	ItemBranchUsage
SET	ItemBranchUsage.CurNoofSales = ItemBranchUsage.CurNoofSales + TIBU.CurNoofSales,
	ItemBranchUsage.CurSalesQty = ItemBranchUsage.CurSalesQty + TIBU.CurSalesQty,
	ItemBranchUsage.CurSalesDol = ItemBranchUsage.CurSalesDol + TIBU.CurSalesDol,
	ItemBranchUsage.CurSalesWght = ItemBranchUsage.CurSalesWght + TIBU.CurSalesWght,
	ItemBranchUsage.CurCostDol = ItemBranchUsage.CurCostDol + TIBU.CurCostDol,
	ItemBranchUsage.CurNRSalesQty = ItemBranchUsage.CurNRSalesQty + TIBU.CurNRSalesQty,
	ItemBranchUsage.CurNRNoSales = ItemBranchUsage.CurNRNoSales + TIBU.CurNRNoSales,
	ItemBranchUsage.CurNRSalesDol = ItemBranchUsage.CurNRSalesDol + TIBU.CurNRSalesDol,
	ItemBranchUsage.CurNRSalesWght = ItemBranchUsage.CurNRSalesWght + TIBU.CurNRSalesWght,
	ItemBranchUsage.CurNRCostDol = ItemBranchUsage.CurNRCostDol + TIBU.CurNRCostDol,
	ItemBranchUsage.ChangeID = 'WO2306_Step01_ConvertGrade8IBU',
	ItemBranchUsage.ChangeDt = GETDATE()
FROM	(SELECT	ItemList.NewItem, OldItem.*
	 FROM	tWO2306_Grade8OldItem OldItem (NoLock) INNER JOIN
		tWO2306_Grade8ItemList ItemList (NoLock)
	 ON	OldItem.ItemNo = ItemList.OldItem) TIBU
WHERE	ItemBranchUsage.ItemNo = TIBU.NewItem AND
	ItemBranchUsage.Location = TIBU.Location AND
	ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo





--INSERT NewItem transactions saved items that did not have old usage
INSERT
INTO	ItemBranchUsage
	(Location, ItemNo,
	 CurPeriodNo, CurBegOnHandQty, CurBegOnHandDol, CurBegOnHandWght,
	 CurNoofReceipts, CurReceivedQty, CurReceivedDol, CurReceivedWght,
	 CurNoofReturns, CurReturnQty, CurReturnDol, CurReturnWght,
	 CurNoofBackOrders, CurBackOrderQty, CurBackOrderDol, CurBackOrderWght,
	 CurNoofSales, CurSalesQty, CurSalesDol, CurSalesWght, CurCostDol,
	 CurNoofTransfers, CurTransferQty, CurTransferDol, CurTransferWght,
	 CurNoofIssues, CurIssuesQty, CurIssuesDol, CurIssuesWght,
	 CurNoofAdjust, CurAdjustQty, CurAdjustDol, CurAdjustWght,
	 CurNoofChanges, CurChangeQty, CurChangeDol, CurChangeWght,
	 CurNoofPO, CurPOQty, CurPODol, CurPOWght,
	 CurNoofGER, CurGERQty, CurGERDol, CurGERWght,
	 CurNoofWorkOrders, CurWorkOrderQty, CurWorkOrderDol, CurWorkOrderWght,
	 CurLostSlsQty, CurDailySlsQty, CurDailyRetQty,
	 CurEndOHQty, CurEndOHDol, CurEndOHWght, CurNOofOrders,
	 CurNRSalesQty, EntryID, EntryDt, ChangeID, ChangeDt, StatusCd,
	 CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol)
SELECT	Location, NewItem,
	CurPeriodNo, CurBegOnHandQty, CurBegOnHandDol, CurBegOnHandWght,
	CurNoofReceipts, CurReceivedQty, CurReceivedDol, CurReceivedWght,
	CurNoofReturns, CurReturnQty, CurReturnDol, CurReturnWght,
	CurNoofBackOrders, CurBackOrderQty, CurBackOrderDol, CurBackOrderWght,
	CurNoofSales, CurSalesQty, CurSalesDol, CurSalesWght, CurCostDol,
	CurNoofTransfers, CurTransferQty, CurTransferDol, CurTransferWght,
	CurNoofIssues, CurIssuesQty, CurIssuesDol, CurIssuesWght,
	CurNoofAdjust, CurAdjustQty, CurAdjustDol, CurAdjustWght,
	CurNoofChanges, CurChangeQty, CurChangeDol, CurChangeWght,
	CurNoofPO, CurPOQty, CurPODol, CurPOWght,
	CurNoofGER, CurGERQty, CurGERDol, CurGERWght,
	CurNoofWorkOrders, CurWorkOrderQty, CurWorkOrderDol, CurWorkOrderWght,
	CurLostSlsQty, CurDailySlsQty, CurDailyRetQty,
	CurEndOHQty, CurEndOHDol, CurEndOHWght, CurNOofOrders,
	CurNRSalesQty, 'WO2306_Step01_ConvertGrade8IBU' as EntryID, GETDATE() as EntryDt, ChangeID, ChangeDt, StatusCd,
	CurNRNoSales, CurNRSalesDol, CurNRSalesWght, CurNRCostDol
FROM	(SELECT	ItemList.NewItem, OldItem.*
	 FROM	tWO2306_Grade8OldItem OldItem (NoLock) INNER JOIN
		tWO2306_Grade8ItemList ItemList (NoLock)
	 ON	OldItem.ItemNo = ItemList.OldItem) TIBU
WHERE	NOT EXISTS (SELECT	*
		    FROM	ItemBranchUsage IBU
		    WHERE	IBU.Location = TIBU.Location AND
				IBU.ItemNo = TIBU.NewItem AND
				IBU.CurPeriodNo = TIBU.CurPeriodNo)










select Hdr.OrderNo, Hdr.InvoiceNo, Hdr.ARPostDt, Dtl.ItemNo, Dtl.LineNumber from SOHeaderHist Hdr inner join SODetailHist Dtl on Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID
where left(Dtl.ItemNo,5)='00171' and    (left(right(Dtl.ItemNo,3),2)='02') --or left(right(Dtl.ItemNo,3),2)='50')
order by ARPostDt


select Hdr.OrderNo, Hdr.InvoiceNo, Dtl.ItemNo, Dtl.LineNumber 
into #tHist
from SOHeaderHist Hdr (Nolock) inner join SODetailHist Dtl (Nolock) on Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID
where	(LEFT(ItemNo,5)='00170' or LEFT(ItemNo,5)='00171' or LEFT(ItemNo,5)='04170' or
	 LEFT(ItemNo,5)='04171' or LEFT(ItemNo,5)='04172')


select Hdr.OrderNo, Hdr.InvoiceNo, Hdr.fSOHeaderID, Dtl.ItemNo, Dtl.LineNumber 
into #tRel
from SOHeaderRel Hdr inner join SODetailRel Dtl on Hdr.pSOHeaderRelID = Dtl.fSOHeaderRelID
where	(LEFT(ItemNo,5)='00170' or LEFT(ItemNo,5)='00171' or LEFT(ItemNo,5)='04170' or
	 LEFT(ItemNo,5)='04171' or LEFT(ItemNo,5)='04172')


select * from 
#tHist Hist

inner join 

#tRel Rel

on (Hist.OrderNo = Rel.OrderNo or Hist.OrderNo = Rel.fSOHeaderID or Hist.InvoiceNo = Rel.InvoiceNo) and Hist.LineNumber = Rel.LineNumber
where Hist.ItemNo <> Rel.ItemNo



select * from 
(select Hdr.OrderNo, Hdr.InvoiceNo, Dtl.ItemNo, Dtl.LineNumber from SOHeaderHist Hdr inner join SODetailHist Dtl on Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID) Hist

inner join 

(select Hdr.OrderNo, Hdr.InvoiceNo, Hdr.fSOHeaderID, Dtl.ItemNo, Dtl.LineNumber from SOHeaderRel Hdr inner join SODetailRel Dtl on Hdr.pSOHeaderRelID = Dtl.fSOHeaderRelID) Rel

on (Hist.OrderNo = Rel.OrderNo or Hist.OrderNo = Rel.fSOHeaderID or Hist.InvoiceNo = Rel.InvoiceNo) and Hist.LineNumber = Rel.LineNumber
where Hist.ItemNo <> Rel.ItemNo



select * from tWO2306_RodFactor

UPDATE	tWO2306_RodFactor
SET	NewItem = SUBSTRING(OldItem,1,11) + '02' + SUBSTRING(OldItem,14,1)


drop table tWO2306_RodFactor

select * from tWO2306_Grade8ItemList

select * from tWO2306_40PoundCnv


UPDATE	tWO2306_40PoundCnv
SET	OldItem = SUBSTRING(NewItem,1,11) + '02' + SUBSTRING(NewItem,14,1)



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO2306_Grade5OldItem') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table dbo.tWO2306_Grade5OldItem
go

SELECT	*
--INTO	tWO2306_Grade5OldItem
FROM	ItemBranchUsage (NoLock)
WHERE	ItemNo in (SELECT OldItem FROM tWO2306_Grade8ItemList)
go




--SELECT AUE Items for update
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].t40PoundSKU') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table t40PoundSKU

SELECT	OldSKU.[Item No_] AS OldItem, OldSKU.[Location Code] AS OldLoc
--INTO	t40PoundSKU
FROM	ItemBranch NewSKU (NoLock)
INNER JOIN
(select LEFT([Item No_],11) + RIGHT([Item No_],1) AS CheckItem02, * from [Porteous$Stockkeeping Unit]
 where SUBSTRING([Item No_],12,2)='02') OldSKU
ON	(LEFT(NewSKU.[Item No_],11) + RIGHT(NewSKU.[Item No_],1)=CheckItem02) AND NewSKU.[Location Code]=OldSKU.[Location Code]
INNER JOIN
(SELECT	*
 FROM	t40PoundCnv) [40Lb]
ON	NewSKU.[Item No_] = [40Lb].[Item]







SELECT	*
FROM	tWO2306_40PoundCnv t40Lb (NoLock) INNER JOIN



where exists



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO2306_40PoundSKU]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO2306_40PoundSKU]
GO

SELECT	IM.ItemNo as SKUItem, IB.Location as SKULoc, t40Lb.OldItem, t40Lb.NewItem
INTO	tWO2306_40PoundSKU
FROM	ItemMaster IM (NoLock) INNER JOIN
	ItemBranch IB (NoLock)
ON	IM.pItemMasterID = IB.fItemMasterID INNER JOIN
	tWO2306_40PoundCnv t40Lb (NoLock)
ON	IM.ItemNo = t40Lb.NewItem
ORDER BY IM.ItemNo, IB.Location
GO



select * from tWO2306_40PoundSKU


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO2306_Grade5NewItem') and OBJECTPROPERTY(id, N'IsUserTable') = 1) drop table dbo.tWO2306_Grade5NewItem
go

SELECT	IBU.*
INTO	tWO2306_Grade5NewItem
FROM	tWO2306_40PoundSKU t40Lb (NoLock) INNER JOIN
	ItemBranchUsage IBU (NoLock)
ON	t40Lb.NewItem = IBU.ItemNo AND t40Lb.SKULoc = IBU.Location
go


select * from tWO2306_Grade5NewItem




--DELETE existing NewItem transactions that were saved
DELETE
FROM	ItemBranchUsage
WHERE EXISTS	(SELECT	*
		 FROM	tWO2306_Grade5NewItem Grade5 (NoLock)
		 WHERE	ItemBranchUsage.CurPeriodNo = Grade5.CurPeriodNo AND
			ItemBranchUsage.ItemNo = Grade5.ItemNo AND
			ItemBranchUsage.Location = Grade5.Location)






--UPDATE existing OldItem ItemBranchUsage transactions: CurSales, CurNRSalesQty

--Negative quantity
UPDATE	ItemBranchUsage
SET	CurSalesQty =	CASE WHEN CurSalesQty < 0
			     THEN ISNULL(NULLIF(ROUND((CurSalesQty * 1.25),0),0),-1)
			     ELSE CurSalesQty
			END,
	CurNRSalesQty =	CASE WHEN CurNRSalesQty < 0
			     THEN ISNULL(NULLIF(ROUND((CurNRSalesQty * 1.25),0),0),-1)
			     ELSE CurNRSalesQty
			END,
	ChangeID = 'WO2306_Step02_ConvertGrade5IBU',
	ChangeDt = GETDATE()
FROM	ItemBranchUsage IBU (NoLock) INNER JOIN
	tWO2306_40PoundSKU t40Lb (NoLock) 
ON	IBU.ItemNo = t40Lb.OldItem AND IBU.Location = t40Lb.SKULoc
WHERE	IBU.CurNRSalesQty < 0 OR IBU.CurSalesQty < 0


--Positive quantity
UPDATE	ItemBranchUsage
SET	CurSalesQty =	CASE WHEN CurSalesQty > 0
			     THEN ISNULL(NULLIF(ROUND((CurSalesQty * 1.25),0),0),1)
			     ELSE CurSalesQty
			END,
	CurNRSalesQty =	CASE WHEN CurNRSalesQty > 0
			     THEN ISNULL(NULLIF(ROUND((CurNRSalesQty * 1.25),0),0),1)
			     ELSE CurNRSalesQty
			END,
	ChangeID = 'WO2306_Step02_ConvertGrade5IBU',
	ChangeDt = GETDATE()
FROM	ItemBranchUsage IBU (NoLock) INNER JOIN
	tWO2306_40PoundSKU t40Lb (NoLock) 
ON	IBU.ItemNo = t40Lb.OldItem AND IBU.Location = t40Lb.SKULoc
--WHERE	IBU.CurSalesQty > 0




--UPDATE existing OldItem ItemBranchUsage transactions: ItemNo
UPDATE	ItemBranchUsage
SET	ItemNo = t40Lb.NewItem,
	ChangeID = 'WO2306_Step02_ConvertGrade5IBU',
	ChangeDt = GETDATE()
FROM	ItemBranchUsage IBU (NoLock) INNER JOIN
	tWO2306_40PoundSKU t40Lb (NoLock) 
ON	IBU.ItemNo = t40Lb.OldItem AND IBU.Location = t40Lb.SKULoc







--Step05: UPDATE existing NewItem transactions
--Step06: INSERT NewItem transactions saved items that did not have old usage







--UPDATE existing NewItem transactions
UPDATE	ItemBranchUsage
SET	ItemBranchUsage.CurNoofSales = ItemBranchUsage.CurNoofSales + TIBU.CurNoofSales,
	ItemBranchUsage.CurSalesQty = ItemBranchUsage.CurSalesQty + TIBU.CurSalesQty,
	ItemBranchUsage.CurSalesDol = ItemBranchUsage.CurSalesDol + TIBU.CurSalesDol,
	ItemBranchUsage.CurSalesWght = ItemBranchUsage.CurSalesWght + TIBU.CurSalesWght,
	ItemBranchUsage.CurCostDol = ItemBranchUsage.CurCostDol + TIBU.CurCostDol,
	ItemBranchUsage.CurNRSalesQty = ItemBranchUsage.CurNRSalesQty + TIBU.CurNRSalesQty,
	ItemBranchUsage.CurNRNoSales = ItemBranchUsage.CurNRNoSales + TIBU.CurNRNoSales,
	ItemBranchUsage.CurNRSalesDol = ItemBranchUsage.CurNRSalesDol + TIBU.CurNRSalesDol,
	ItemBranchUsage.CurNRSalesWght = ItemBranchUsage.CurNRSalesWght + TIBU.CurNRSalesWght,
	ItemBranchUsage.CurNRCostDol = ItemBranchUsage.CurNRCostDol + TIBU.CurNRCostDol,
	ItemBranchUsage.ChangeID = 'WO2306_Step02_ConvertGrade5IBU',
	ItemBranchUsage.ChangeDt = GETDATE()
FROM	tWO2306_Grade5NewItem TIBU
WHERE	ItemBranchUsage.ItemNo = TIBU.ItemNo AND ItemBranchUsage.Location = TIBU.Location AND ItemBranchUsage.CurPeriodNo = TIBU.CurPeriodNo



select * from tWO2306_Grade5NewItem


--INSERT NewItem transactions saved items that did not have old usage
INSERT
INTO	ItemBranchUsage
	(Location,ItemNo,CurPeriodNo,
	 CurBegOnHandQty,CurBegOnHandDol,CurBegOnHandWght,
	 CurNoofReceipts,CurReceivedQty,CurReceivedDol,CurReceivedWght,
	 CurNoofReturns,CurReturnQty,CurReturnDol,CurReturnWght,
	 CurNoofBackOrders,CurBackOrderQty,CurBackOrderDol,CurBackOrderWght,
	 CurNoofSales,CurSalesQty,CurSalesDol,CurSalesWght,CurCostDol,
	 CurNoofTransfers,CurTransferQty,CurTransferDol,CurTransferWght,
	 CurNoofIssues,CurIssuesQty,CurIssuesDol,CurIssuesWght,
	 CurNoofAdjust,CurAdjustQty,CurAdjustDol,CurAdjustWght,
	 CurNoofChanges,CurChangeQty,CurChangeDol,CurChangeWght,
	 CurNoofPO,CurPOQty,CurPODol,CurPOWght,
	 CurNoofGER,CurGERQty,CurGERDol,CurGERWght,
	 CurNoofWorkOrders,CurWorkOrderQty,CurWorkOrderDol,CurWorkOrderWght,
	 CurLostSlsQty,CurDailySlsQty,CurDailyRetQty,
	 CurEndOHQty,CurEndOHDol,CurEndOHWght,CurNOofOrders,
	 CurNRSalesQty, EntryID,EntryDt,ChangeID,ChangeDt,StatusCd,
	 CurNRNoSales,CurNRSalesDol,CurNRSalesWght,CurNRCostDol)
SELECT	Location,ItemNo,
	CurPeriodNo,CurBegOnHandQty,CurBegOnHandDol,CurBegOnHandWght,
	CurNoofReceipts,CurReceivedQty,CurReceivedDol,CurReceivedWght,
	CurNoofReturns,CurReturnQty,CurReturnDol,CurReturnWght,
	CurNoofBackOrders,CurBackOrderQty,CurBackOrderDol,CurBackOrderWght,
	CurNoofSales,CurSalesQty,CurSalesDol,CurSalesWght,CurCostDol,
	CurNoofTransfers,CurTransferQty,CurTransferDol,CurTransferWght,
	CurNoofIssues,CurIssuesQty,CurIssuesDol,CurIssuesWght,
	CurNoofAdjust,CurAdjustQty,CurAdjustDol,CurAdjustWght,
	CurNoofChanges,CurChangeQty,CurChangeDol,CurChangeWght,
	CurNoofPO,CurPOQty,CurPODol,CurPOWght,
	CurNoofGER,CurGERQty,CurGERDol,CurGERWght,
	CurNoofWorkOrders,CurWorkOrderQty,CurWorkOrderDol,CurWorkOrderWght,
	CurLostSlsQty,CurDailySlsQty,CurDailyRetQty,
	CurEndOHQty,CurEndOHDol,CurEndOHWght,CurNOofOrders,
	CurNRSalesQty, 'WO2306_Step02_ConvertGrade5IBU' as EntryID,GETDATE() as EntryDt,ChangeID,ChangeDt,StatusCd,
	CurNRNoSales,CurNRSalesDol,CurNRSalesWght,CurNRCostDol
FROM	tWO2306_Grade5NewItem TIBU
WHERE	NOT EXISTS (SELECT *
		    FROM   ItemBranchUsage IBU
		    WHERE  IBU.Location = TIBU.Location AND
			   IBU.ItemNo = TIBU.ItemNo AND
			   IBU.CurPeriodNo = TIBU.CurPeriodNo)

