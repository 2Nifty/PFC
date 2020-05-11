drop proc [dbo].[pLoadDashboardCustInvDaily]
go

CREATE procedure [dbo].[pLoadDashboardCustInvDaily]
as

----pLoadDashboardCustInvDaily
----Written By: Tod Dixon
----Application: Sales Management

DECLARE	@CurEndDay	DATETIME,	--Current DashBoard End Date
		@CurMthBeg	DATETIME	--Beginning Date for the Current Period

SET @CurEndDay = (SELECT EndDate FROM DashBoardRanges WHERE DashBoardParameter = 'CurrentDay')
SET @CurMthBeg = (SELECT CurFiscalMthBeginDt FROM FiscalCalendar WHERE CurrentDt = @CurEndDay)

truncate table DashboardCustInvDaily

--Daily records by Customer & Invoice (DashboardCustInvDaily)
INSERT	DashboardCustInvDaily
		(InvoiceNo,
		 RefSONo,
		 CustNo,
		 CustName,
		 Location,
		 ARPostDt,
		 ItemNo,
		 LineNumber,
		 OrderSource,
		 OrderSourceSeq,
		 SalesDollars,
		 Lbs,
		 SalesPerLb,
		 Cost,
		 MarginDollars,
		 MarginPct,
		 MarginPerLb,
		 EntryID,
		 EntryDt)
SELECT	tSales.InvoiceNo,
		tSales.OrderNo,
		tSales.CustNo,
		tSales.CustName,
		tSales.Location,
		tSales.ARPostDt,
		tSales.ItemNo,
		tSales.LineNumber,
		tSales.OrderSource,
		' ' AS OrderSourceSeq,
		isNULL(tSales.LineSales,0) AS SalesDollars,
		isNULL(tSales.LineWght,0) AS Lbs,
		isNULL(tSales.LineSalesPerLb,0) AS SalesPerLb,
		isNULL(tSales.LineCost,0) AS Cost,
		isNULL(tSales.LineMgn,0) AS MarginDollars,
		isNULL(tSales.LineMgnPct,0) AS MarginPct,
		isNULL(tSales.LineMgnPerLb,0) AS MarginPerLb,
		'NVLUNIGHT' AS EntryID,
		GETDATE() AS EntryDt
FROM	(SELECT	DISTINCT
				Hdr.InvoiceNo,
				Hdr.RefSONo AS OrderNo,
				Hdr.SellToCustNo AS CustNo,
				Hdr.SellToCustName AS CustName,
				--Hdr.CustShipLoc AS Location,
				isNULL(CM.CustShipLocation, Hdr.CustShipLoc) as Location,
				Hdr.ARPostDt,
				Dtl.ItemNo,
				Dtl.LineNumber,
				Hdr.OrderSource,
				Dtl.NetUnitPrice * Dtl.QtyShipped AS LineSales,
				Dtl.GrossWght * Dtl.QtyShipped AS LineWght,
				CASE (Dtl.GrossWght * Dtl.QtyShipped)
						WHEN 0 THEN 0
						ELSE (Dtl.NetUnitPrice * Dtl.QtyShipped) / (Dtl.GrossWght * Dtl.QtyShipped)
				END AS LineSalesPerLb,
				Dtl.UnitCost * Dtl.QtyShipped AS LineCost,
				(Dtl.NetUnitPrice * Dtl.QtyShipped) - (Dtl.UnitCost * Dtl.QtyShipped) AS LineMgn,
				CASE (Dtl.NetUnitPrice * Dtl.QtyShipped)
						WHEN 0 THEN 0
						ELSE ((Dtl.NetUnitPrice * Dtl.QtyShipped) - (Dtl.UnitCost * Dtl.QtyShipped)) / (Dtl.NetUnitPrice * Dtl.QtyShipped)
				END AS LineMgnPct,
				CASE (Dtl.GrossWght * Dtl.QtyShipped)
						WHEN 0 THEN 0
						ELSE ((Dtl.NetUnitPrice * Dtl.QtyShipped) - (Dtl.UnitCost * Dtl.QtyShipped)) / (Dtl.GrossWght * Dtl.QtyShipped)
				END AS LineMgnPerLb
		 FROM	SOHeaderHist Hdr (NoLock) FULL OUTER JOIN  --INNER JOIN
				SODetailHist Dtl (NoLock) 
		 ON		Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID LEFT OUTER JOIN
				CustomerMaster CM (NoLock)
		 ON		Hdr.SellToCustNo = CM.CustNo
		 WHERE	Hdr.ARPostDt between @CurMthBeg and @CurEndDay) tSales
ORDER BY CustNo, InvoiceNo, LineNumber

--Update BLANK or NULL OrderSource with Default Value from SOEOrderSource List
UPDATE	DashboardCustInvDaily
SET		OrderSource = List.ListValue
FROM	(SELECT	LD.ListValue
		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN
				OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD
		 ON		LM.pListMasterID = LD.fListMasterID
		 WHERE	LM.ListName = 'SOEOrderSource' AND LD.SequenceNo=9) List
WHERE	OrderSource is null OR OrderSource = ''

--Update OrderSourceSeq with SequenceNo from SOEOrderSource List
UPDATE	DashboardCustInvDaily
SET		OrderSourceSeq = List.SequenceNo
FROM	(SELECT	LD.ListValue, LD.SequenceNo
		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN
				OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD
		 ON	LM.pListMasterID = LD.fListMasterID
		 WHERE	LM.ListName = 'SOEOrderSource') List
WHERE	OrderSource = List.ListValue

GO
