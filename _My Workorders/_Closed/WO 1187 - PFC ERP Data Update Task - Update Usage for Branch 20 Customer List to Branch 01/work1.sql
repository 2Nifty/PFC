select * from ItemBranchUsage
where [ItemNo]='00020-2408-020'


select DTL.UsageLoc, ARPostDt, QtyOrdered, ExtendedPrice, ExtendedNetWght, ExtendedCost, ExcludedFromUsageFlag, Dtl.*
FROM	SODetailHist Dtl INNER JOIN
	SOHeaderHist Hdr ON
	Dtl.fSOHeaderHistID = Hdr.pSOHeaderHistID
where [ItemNo]='00020-2408-020'
order by Dtl.UsageLoc, ArPostDt


select DTL.UsageLoc, ARPostDt, QtyOrdered, ExtendedPrice, ExtendedNetWght, ExtendedCost, ExcludedFromUsageFlag, Dtl.*
FROM	SODetailHist Dtl INNER JOIN
	SOHeaderHist Hdr ON
	Dtl.fSOHeaderHistID = Hdr.pSOHeaderHistID
WHERE ExcludedFromUsageFlag > 1


SELECT	InvoiceNo, SellToCustNo,  ARPostDt,
	CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2) AS CurPerNo,
	Dtl.UsageLoc, ItemNo, LineNumber, QtyOrdered, ExtendedPrice, ExtendedNetWght, ExtendedCost, ExcludedFromUsageFlag
--SELECT top 100 *
FROM	SODetailHist Dtl INNER JOIN
	SOHeaderHist Hdr ON
	Dtl.fSOHeaderHistID = Hdr.pSOHeaderHistID
WHERE	Dtl.UsageLoc = '20' AND --ISNULL(ExcludedFromUsageFlag,0) = 1 AND
	(SellToCustNo = '038917' OR 
	 SellToCustNo = '038928' OR 
	 SellToCustNo = '042071' OR 
	 SellToCustNo = '046431' OR 
	 SellToCustNo = '054021' OR 
	 SellToCustNo = '054023' OR 
	 SellToCustNo = '057461' OR 
	 SellToCustNo = '057471' OR 
	 SellToCustNo = '059227')
--ORDER BY SellToCustNo, ItemNo
ORDER BY ItemNo, CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2)







if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tWO1187Br20CustUsage') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tWO1187Br20CustUsage

--ExcludedFromUsageFlag <> 1
SELECT	--InvoiceNo, SellToCustNo,  ARPostDt, Dtl.UsageLoc
	CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2) AS CurPerNo, ItemNo,
	SUM(QtyOrdered) AS QtyOrdered, SUM(ExtendedPrice) AS ExtendedPrice,
	SUM(ExtendedNetWght) AS ExtendedNetWght, SUM(ExtendedCost) AS ExtendedCost, COUNT(LineNumber) AS LineCount --, ExcludedFromUsageFlag
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

--ExcludedFromUsageFlag = 1
SELECT	--InvoiceNo, SellToCustNo,  ARPostDt, Dtl.UsageLoc
	CAST(DATEPART(yyyy,ARPostDt) AS VARCHAR(4)) + RIGHT('00' + CAST(DATEPART(mm,ARPostDt) AS VARCHAR(2)),2) AS CurPerNo, ItemNo,
	SUM(QtyOrdered) AS QtyOrdered, SUM(ExtendedPrice) AS ExtendedPrice,
	SUM(ExtendedNetWght) AS ExtendedNetWght, SUM(ExtendedCost) AS ExtendedCost, COUNT(LineNumber) AS LineCount --, ExcludedFromUsageFlag
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


select * from tWO1187Br20CustUsage

select * from tWO1187Br20NRCustUsage