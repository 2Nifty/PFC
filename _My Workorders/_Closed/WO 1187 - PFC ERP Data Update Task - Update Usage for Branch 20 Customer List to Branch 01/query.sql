------NV AUE------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1187Br20CustUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1187Br20CustUsage

--SELECT AUE Transactions for Update
SELECT	DISTINCT [Item No_], [Usage Location], [Customer No_] --,*
INTO	tWO1187Br20CustUsage
FROM	[Porteous$Actual Usage Entry]
WHERE	[Usage Location] = '20' AND
	([Customer No_] = '038917' OR 
	 [Customer No_] = '038928' OR 
	 [Customer No_] = '042071' OR 
	 [Customer No_] = '046431' OR 
	 [Customer No_] = '054021' OR 
	 [Customer No_] = '054023' OR 
	 [Customer No_] = '057461' OR 
	 [Customer No_] = '057471' OR 
	 [Customer No_] = '059227')
ORDER BY [Customer No_], [Item No_]

--select * from tWO1187Br20CustUsage


--Update Actual Usage Entry SET [Usage Location] = '01'
UPDATE	[Porteous$Actual Usage Entry]
SET	[Usage Location] = '01'
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tWO1187Br20CustUsage) Br20Cust
ON	AUE.[Item No_]=Br20Cust.[Item No_] AND AUE.[Usage Location]=Br20Cust.[Usage Location] AND AUE.[Customer No_]=Br20Cust.[Customer No_]




--------------------------------------------------------------------------------------------------------

------ERP ItemBranchUsage------

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1187Br20CustUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1187Br20CustUsage

--SELECT ERP Transactions for Update from SOHist WHERE ExcludedFromUsageFlag <> 1
SELECT	--InvoiceNo, SellToCustNo,  ARPostDt, Dtl.UsageLoc
	CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2) AS CurPerNo, ItemNo,
	SUM(QtyOrdered) AS QtyOrdered, Round(SUM(ExtendedPrice),2) AS ExtendedPrice,
	Round(SUM(ExtendedNetWght),4) AS ExtendedNetWght, Round(SUM(ExtendedCost),2) AS ExtendedCost,
	COUNT(LineNumber) AS LineCount --, ExcludedFromUsageFlag
INTO	tWO1187Br20CustUsage
FROM	SODetailHist Dtl INNER JOIN
	SOHeaderHist Hdr ON
	Dtl.fSOHeaderHistID = Hdr.pSOHeaderHistID
WHERE	Dtl.UsageLoc = '20' AND ISNULL(ExcludedFromUsageFlag,0) <> 1 AND
	(SellToCustNo = '038917' OR 
	 SellToCustNo = '038928' OR 
	 SellToCustNo = '042071' OR 
	 SellToCustNo = '046431' OR 
	 SellToCustNo = '054021' OR 
	 SellToCustNo = '054023' OR 
	 SellToCustNo = '057461' OR 
	 SellToCustNo = '057471' OR 
	 SellToCustNo = '059227')
GROUP BY CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2), ItemNo
ORDER BY ItemNo, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1187Br20NRCustUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1187Br20NRCustUsage

--SELECT ERP Transactions for Update from SOHist WHERE ExcludedFromUsageFlag = 1 (NR)
SELECT	--InvoiceNo, SellToCustNo,  ARPostDt, Dtl.UsageLoc
	CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2) AS CurPerNo, ItemNo,
	SUM(QtyOrdered) AS QtyOrdered, Round(SUM(ExtendedPrice),2) AS ExtendedPrice,
	Round(SUM(ExtendedNetWght),4) AS ExtendedNetWght, Round(SUM(ExtendedCost),2) AS ExtendedCost,
	COUNT(LineNumber) AS LineCount --, ExcludedFromUsageFlag
INTO	tWO1187Br20NRCustUsage
FROM	SODetailHist Dtl INNER JOIN
	SOHeaderHist Hdr ON
	Dtl.fSOHeaderHistID = Hdr.pSOHeaderHistID
WHERE	Dtl.UsageLoc = '20' AND ISNULL(ExcludedFromUsageFlag,0) = 1 AND
	(SellToCustNo = '038917' OR 
	 SellToCustNo = '038928' OR 
	 SellToCustNo = '042071' OR 
	 SellToCustNo = '046431' OR 
	 SellToCustNo = '054021' OR 
	 SellToCustNo = '054023' OR 
	 SellToCustNo = '057461' OR 
	 SellToCustNo = '057471' OR 
	 SellToCustNo = '059227')
GROUP BY CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2), ItemNo
ORDER BY ItemNo, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)


--select * from tWO1187Br20CustUsage

--select * from tWO1187Br20NRCustUsage


--Subtract USAGE from existing ItemBranchUsage Br20 transactions
UPDATE	ItemBranchUsage
SET	CurNoofSales = ISNULL(CurNoofSales,0) - LineCount,
	CurSalesQty = ISNULL(CurSalesQty,0) - QtyOrdered,
	CurSalesDol = ISNULL(CurSalesDol,0) - ExtendedPrice,
	CurSalesWght = ISNULL(CurSalesWght,0) - ExtendedNetWght,
	CurCostDol = ISNULL(CurCostDol,0) - ExtendedCost,
	ChangeDt = GetDate(),
	ChangeID = 'WO1187Br20toBr01Del'
FROM	ItemBranchUsage IBU INNER JOIN
	tWO1187Br20CustUsage TempUse ON 
	IBU.ItemNo = TempUse.ItemNo AND IBU.CurPeriodNo = TempUse.CurPerNo
WHERE	IBU.Location = '20'


--Subtract USAGE from existing ItemBranchUsage Br20 transactions (NR)
UPDATE	ItemBranchUsage
SET	CurNRNoSales = ISNULL(CurNRNoSales,0) - LineCount,
	CurNRSalesQty = ISNULL(CurNRSalesQty,0) - QtyOrdered,
	CurNRSalesDol = ISNULL(CurNRSalesDol,0) - ExtendedPrice,
	CurNRSalesWght = ISNULL(CurNRSalesWght,0) - ExtendedNetWght,
	CurNRCostDol = ISNULL(CurNRCostDol,0) - ExtendedCost,
	ChangeDt = GetDate(),
	ChangeID = 'WO1187Br20toBr01Del'
FROM	ItemBranchUsage IBU INNER JOIN
	tWO1187Br20NRCustUsage TempUse ON 
	IBU.ItemNo = TempUse.ItemNo AND IBU.CurPeriodNo = TempUse.CurPerNo
WHERE	IBU.Location = '20'




--INSERt INTO ItemBranchUsage (Location, ItemNo, CurPeriodNo)
--values (99, '99999-9999-999', 999999)

--select * from ItemBranchUsage
--delete from ItemBranchUsage where Location=99



--Create empty Br01 USAGE Records that don't already exist
INSERT INTO	ItemBranchUsage
		(Location, ItemNo, CurPeriodNo, ChangeDt, ChangeID)
SELECT		'01', ItemNo, CurPerNo, GetDate(), 'WO1187Br20toBr01Ins'
FROM		tWO1187Br20CustUsage TempUse
WHERE		NOT EXISTS (SELECT * FROM ItemBranchUsage IBU
			    WHERE  IBU.Location = '01' AND TempUse.ItemNo = IBU.ItemNo AND TempUse.CurPerNo = IBU.CurPeriodNo)

--Create empty Br01 USAGE Records that don't already exist (NR)
INSERT INTO	ItemBranchUsage
		(Location, ItemNo, CurPeriodNo, ChangeDt, ChangeID)
SELECT		'01', ItemNo, CurPerNo, GetDate(), 'WO1187Br20toBr01Ins'
FROM		tWO1187Br20NRCustUsage TempUse
WHERE		NOT EXISTS (SELECT * FROM ItemBranchUsage IBU
			    WHERE  IBU.Location = '01' AND TempUse.ItemNo = IBU.ItemNo AND TempUse.CurPerNo = IBU.CurPeriodNo)


select * from ItemBranchUsage where ChangeID='WO1187Br20toBr01Upd'
order by CurNoofSales


--Add USAGE to ItemBranchUsage Br01 records
UPDATE	ItemBranchUsage
SET	CurNoofSales = ISNULL(CurNoofSales,0) + LineCount,
	CurSalesQty = ISNULL(CurSalesQty,0) + QtyOrdered,
	CurSalesDol = ISNULL(CurSalesDol,0) + ExtendedPrice,
	CurSalesWght = ISNULL(CurSalesWght,0) + ExtendedNetWght,
	CurCostDol = ISNULL(CurCostDol,0) + ExtendedCost,
	ChangeDt = GetDate(),
	ChangeID = 'WO1187Br20toBr01Upd'
FROM	ItemBranchUsage IBU INNER JOIN
	tWO1187Br20CustUsage TempUse ON 
	IBU.ItemNo = TempUse.ItemNo AND IBU.CurPeriodNo = TempUse.CurPerNo
WHERE	IBU.Location = '01'


--Add USAGE to ItemBranchUsage Br01 records (NR)
UPDATE	ItemBranchUsage
SET	CurNRNoSales = ISNULL(CurNRNoSales,0) + LineCount,
	CurNRSalesQty = ISNULL(CurNRSalesQty,0) + QtyOrdered,
	CurNRSalesDol = ISNULL(CurNRSalesDol,0) + ExtendedPrice,
	CurNRSalesWght = ISNULL(CurNRSalesWght,0) + ExtendedNetWght,
	CurNRCostDol = ISNULL(CurNRCostDol,0) + ExtendedCost,
	ChangeDt = GetDate(),
	ChangeID = 'WO1187Br20toBr01Upd'
FROM	ItemBranchUsage IBU INNER JOIN
	tWO1187Br20NRCustUsage TempUse ON 
	IBU.ItemNo = TempUse.ItemNo AND IBU.CurPeriodNo = TempUse.CurPerNo
WHERE	IBU.Location = '01'