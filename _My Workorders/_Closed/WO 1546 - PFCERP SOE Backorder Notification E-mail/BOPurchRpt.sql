SELECT	[Porteous$Sales Header].[Back Order],
	[Porteous$Sales Line].[Document No_],
	[Porteous$Sales Line].No_, 
	[Porteous$Sales Header].[Shipping Location], 
	[Porteous$Sales Line].Quantity
FROM	[Porteous$Sales Header] INNER JOIN
	[Porteous$Sales Line]
ON	[Porteous$Sales Header].No_ = [Porteous$Sales Line].[Document No_]
WHERE	([Porteous$Sales Header].[Back Order] = 1)


SELECT	BOFlag,
	OrderNo, RefSONo,
	ItemNo,
	ShipLoc,
	QtyOrdered
FROM	SOHeader INNER JOIN
	SODetail
ON	pSOHeaderID = SOdetail.fSOHeaderID
WHERE	BOFlag = 'BO'



SELECT     No_ AS No_, [Location Code], CASE WHEN [Location Code] = '01' THEN SUM(Quantity) ELSE 0 END AS Qty_01, 
                      CASE WHEN [Location Code] = '02' THEN SUM(Quantity) ELSE 0 END AS Qty_02, CASE WHEN [Location Code] = '03' THEN SUM(Quantity) 
                      ELSE 0 END AS Qty_03, CASE WHEN [Location Code] = '04' THEN SUM(Quantity) ELSE 0 END AS Qty_04, 
                      CASE WHEN [Location Code] = '05' THEN SUM(Quantity) ELSE 0 END AS Qty_05, CASE WHEN [Location Code] = '07' THEN SUM(Quantity) 
                      ELSE 0 END AS Qty_07, CASE WHEN [Location Code] = '08' THEN SUM(Quantity) ELSE 0 END AS Qty_08, 
                      CASE WHEN [Location Code] = '09' THEN SUM(Quantity) ELSE 0 END AS Qty_09, CASE WHEN [Location Code] = '10' THEN SUM(Quantity) 
                      ELSE 0 END AS Qty_10, CASE WHEN [Location Code] = '11' THEN SUM(Quantity) ELSE 0 END AS Qty_11, 
                      CASE WHEN [Location Code] = '12' THEN SUM(Quantity) ELSE 0 END AS Qty_12, CASE WHEN [Location Code] = '13' THEN SUM(Quantity) 
                      ELSE 0 END AS Qty_13, CASE WHEN [Location Code] = '14' THEN SUM(Quantity) ELSE 0 END AS Qty_14, 
                      CASE WHEN [Location Code] = '15' THEN SUM(Quantity) ELSE 0 END AS Qty_15, CASE WHEN [Location Code] = '16' THEN SUM(Quantity) 
                      ELSE 0 END AS Qty_16, CASE WHEN [Location Code] = '17' THEN SUM(Quantity) ELSE 0 END AS Qty_17, 
                      CASE WHEN [Location Code] = '18' THEN SUM(Quantity) ELSE 0 END AS Qty_18, CASE WHEN [Location Code] = '19' THEN SUM(Quantity) 
                      ELSE 0 END AS Qty_19, CASE WHEN [Location Code] = '20' THEN SUM(Quantity) ELSE 0 END AS Qty_20, 
                      CASE WHEN [Location Code] = '21' THEN SUM(Quantity) ELSE 0 END AS Qty_21
FROM         BO_History
GROUP BY No_, [Location Code]
ORDER BY No_


SELECT	ItemNo,
	ShipLoc,
	CASE WHEN ShipLoc = '01' THEN SUM(QtyOrdered) ELSE 0 END AS Qty01,
	CASE WHEN ShipLoc = '02' THEN SUM(QtyOrdered) ELSE 0 END AS Qty02,
	CASE WHEN ShipLoc = '03' THEN SUM(QtyOrdered) ELSE 0 END AS Qty03,
	CASE WHEN ShipLoc = '04' THEN SUM(QtyOrdered) ELSE 0 END AS Qty04,
	CASE WHEN ShipLoc = '05' THEN SUM(QtyOrdered) ELSE 0 END AS Qty05,
	CASE WHEN ShipLoc = '07' THEN SUM(QtyOrdered) ELSE 0 END AS Qty07,
	CASE WHEN ShipLoc = '08' THEN SUM(QtyOrdered) ELSE 0 END AS Qty08,
	CASE WHEN ShipLoc = '09' THEN SUM(QtyOrdered) ELSE 0 END AS Qty09,
	CASE WHEN ShipLoc = '10' THEN SUM(QtyOrdered) ELSE 0 END AS Qty10,
	CASE WHEN ShipLoc = '11' THEN SUM(QtyOrdered) ELSE 0 END AS Qty11,
	CASE WHEN ShipLoc = '12' THEN SUM(QtyOrdered) ELSE 0 END AS Qty12,
	CASE WHEN ShipLoc = '13' THEN SUM(QtyOrdered) ELSE 0 END AS Qty13,
	CASE WHEN ShipLoc = '14' THEN SUM(QtyOrdered) ELSE 0 END AS Qty14,
	CASE WHEN ShipLoc = '15' THEN SUM(QtyOrdered) ELSE 0 END AS Qty15,
	CASE WHEN ShipLoc = '16' THEN SUM(QtyOrdered) ELSE 0 END AS Qty16,
	CASE WHEN ShipLoc = '17' THEN SUM(QtyOrdered) ELSE 0 END AS Qty17,
	CASE WHEN ShipLoc = '18' THEN SUM(QtyOrdered) ELSE 0 END AS Qty18,
	CASE WHEN ShipLoc = '19' THEN SUM(QtyOrdered) ELSE 0 END AS Qty19,
	CASE WHEN ShipLoc = '20' THEN SUM(QtyOrdered) ELSE 0 END AS Qty20,
	CASE WHEN ShipLoc = '21' THEN SUM(QtyOrdered) ELSE 0 END AS Qty21
FROM	tWO1546_BOHistory
GROUP BY ItemNo, ShipLoc
ORDER BY ItemNo




SELECT     No_, SUM(Qty_01) + SUM(Qty_02) + SUM(Qty_03) + SUM(Qty_04) + SUM(Qty_05) + SUM(Qty_07) + SUM(Qty_08) + SUM(Qty_09) + SUM(Qty_10) 
                      + SUM(Qty_11) + SUM(Qty_12) + SUM(Qty_13) + SUM(Qty_14) + SUM(Qty_15) + SUM(Qty_16) + SUM(Qty_17) + SUM(Qty_18) + SUM(Qty_19) 
                      + SUM(Qty_20) + SUM(Qty_21) AS Qty_Total, SUM(Qty_01) AS Qty_01, SUM(Qty_02) AS Qty_02, SUM(Qty_03) AS Qty_03, SUM(Qty_04) AS Qty_04, 
                      SUM(Qty_05) AS Qty_05, SUM(Qty_07) AS Qty_07, SUM(Qty_08) AS Qty_08, SUM(Qty_09) AS Qty_09, SUM(Qty_10) AS Qty_10, SUM(Qty_11) AS Qty_11, 
                      SUM(Qty_12) AS Qty_12, SUM(Qty_13) AS Qty_13, SUM(Qty_14) AS Qty_14, SUM(Qty_15) AS Qty_15, SUM(Qty_16) AS Qty_16, SUM(Qty_17) AS Qty_17, 
                      SUM(Qty_18) AS Qty_18, SUM(Qty_19) AS Qty_19, SUM(Qty_20) AS Qty_20, SUM(Qty_21) AS Qty_21
FROM         BO_ReportSum
GROUP BY No_


SELECT	ItemNo,
	SUM(Qty01) + SUM(Qty02) + SUM(Qty03) + SUM(Qty04) + SUM(Qty05) + SUM(Qty07) + SUM(Qty08) + SUM(Qty09) + SUM(Qty10) + SUM(Qty11) +
	SUM(Qty12) + SUM(Qty13) + SUM(Qty14) + SUM(Qty15) + SUM(Qty16) + SUM(Qty17) + SUM(Qty18) + SUM(Qty19) + SUM(Qty20) + SUM(Qty21) AS QtyTotal,
	SUM(Qty01) AS Qty01,
	SUM(Qty02) AS Qty02,
	SUM(Qty03) AS Qty03,
	SUM(Qty04) AS Qty04,
	SUM(Qty05) AS Qty05,
	SUM(Qty07) AS Qty07,
	SUM(Qty08) AS Qty08,
	SUM(Qty09) AS Qty09,
	SUM(Qty10) AS Qty10,
	SUM(Qty11) AS Qty11,
	SUM(Qty12) AS Qty12,
	SUM(Qty13) AS Qty13,
	SUM(Qty14) AS Qty14,
	SUM(Qty15) AS Qty15,
	SUM(Qty16) AS Qty16,
	SUM(Qty17) AS Qty17,
	SUM(Qty18) AS Qty18,
	SUM(Qty19) AS Qty19,
	SUM(Qty20) AS Qty20,
	SUM(Qty21) AS Qty21
FROM	tWO1546_BOReportSum
GROUP BY ItemNo




SELECT	[Porteous$Sales Header].[Back Order],
	[Porteous$Sales Line].[Document No_],
	[Porteous$Sales Line].No_, 
        [Porteous$Sales Header].[Shipping Location],
	[Porteous$Sales Line].Quantity,
	[Porteous$Sales Header].[Posting Date]
FROM	[Porteous$Sales Header] INNER JOIN
        [Porteous$Sales Line]
ON	[Porteous$Sales Header].No_ = [Porteous$Sales Line].[Document No_]
WHERE	([Porteous$Sales Header].[Back Order] = 1) AND
	([Porteous$Sales Header].[Posting Date] = CAST({ fn CURDATE() } AS DATETIME) - 1)


SELECT	[Porteous$Sales Header].[Back Order],
	[Porteous$Sales Line].[Document No_],
	[Porteous$Sales Line].No_, 
	[Porteous$Sales Header].[Shipping Location], 
	[Porteous$Sales Line].Quantity,
	[Porteous$Sales Header].[Posting Date]
FROM	[Porteous$Sales Header] INNER JOIN
        [Porteous$Sales Line]
ON	[Porteous$Sales Header].No_ = [Porteous$Sales Line].[Document No_]
WHERE   ([Porteous$Sales Header].[Back Order] = 1) AND
	([Porteous$Sales Header].[Posting Date] > CAST({ fn CURDATE() } AS DATETIME) - 4)



DECLARE	@BegDate as DATETIME,
	@EndDate as DATETIME

SET	@BegDate = (SELECT BegDate FROM OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.DashboardRanges WHERE DashBoardParameter = 'CurrentDay')
SET	@EndDate = (SELECT EndDate FROM OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.DashboardRanges WHERE DashBoardParameter = 'CurrentDay')

--Select @BegDate, @EndDate

SELECT	BOFlag,
	OrderNo, RefSONo,
	ItemNo,
	ShipLoc,
	QtyOrdered,
	EntryDt
FROM	SOHeader INNER JOIN
	SODetail
ON	pSOHeaderID = SOdetail.fSOHeaderID
WHERE	BOFlag = 'BO' AND
	CAST(FLOOR(CAST(EntryDt AS FLOAT)) AS DATETIME) BETWEEN @BegDate AND @EndDate

--	ARPostDt < CAST(FLOOR(CAST(GetDate() AS FLOAT)) AS DATETIME) AND
--	ARPostDt > CASE	WHEN DATENAME(dw, GetDate()) = 'Monday'
--			THEN CAST(FLOOR(CAST(GetDate()-3 AS FLOAT)) AS DATETIME)
--			ELSE CAST(FLOOR(CAST(GetDate()-1 AS FLOAT)) AS DATETIME)
--		   END


select * from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.DashboardRanges




SELECT     No_ AS No_, [Location Code], CASE WHEN [Location Code] = '01' THEN SUM(Quantity) ELSE 0 END AS Qty_01, 
                      CASE WHEN [Location Code] = '02' THEN SUM(Quantity) ELSE 0 END AS Qty_02, CASE WHEN [Location Code] = '03' THEN SUM(Quantity) 
                      ELSE 0 END AS Qty_03, CASE WHEN [Location Code] = '04' THEN SUM(Quantity) ELSE 0 END AS Qty_04, 
                      CASE WHEN [Location Code] = '05' THEN SUM(Quantity) ELSE 0 END AS Qty_05, CASE WHEN [Location Code] = '07' THEN SUM(Quantity) 
                      ELSE 0 END AS Qty_07, CASE WHEN [Location Code] = '08' THEN SUM(Quantity) ELSE 0 END AS Qty_08, 
                      CASE WHEN [Location Code] = '09' THEN SUM(Quantity) ELSE 0 END AS Qty_09, CASE WHEN [Location Code] = '10' THEN SUM(Quantity) 
                      ELSE 0 END AS Qty_10, CASE WHEN [Location Code] = '11' THEN SUM(Quantity) ELSE 0 END AS Qty_11, 
                      CASE WHEN [Location Code] = '12' THEN SUM(Quantity) ELSE 0 END AS Qty_12, CASE WHEN [Location Code] = '13' THEN SUM(Quantity) 
                      ELSE 0 END AS Qty_13, CASE WHEN [Location Code] = '14' THEN SUM(Quantity) ELSE 0 END AS Qty_14, 
                      CASE WHEN [Location Code] = '15' THEN SUM(Quantity) ELSE 0 END AS Qty_15, CASE WHEN [Location Code] = '16' THEN SUM(Quantity) 
                      ELSE 0 END AS Qty_16, CASE WHEN [Location Code] = '17' THEN SUM(Quantity) ELSE 0 END AS Qty_17, 
                      CASE WHEN [Location Code] = '18' THEN SUM(Quantity) ELSE 0 END AS Qty_18, CASE WHEN [Location Code] = '19' THEN SUM(Quantity) 
                      ELSE 0 END AS Qty_19, CASE WHEN [Location Code] = '20' THEN SUM(Quantity) ELSE 0 END AS Qty_20, 
                      CASE WHEN [Location Code] = '21' THEN SUM(Quantity) ELSE 0 END AS Qty_21
FROM         BO_History
GROUP BY No_, [Location Code]
ORDER BY No_





SELECT	ItemNo,
	ShipLoc,
	CASE WHEN ShipLoc = '01' THEN SUM(QtyOrdered) ELSE 0 END AS Qty01,
	CASE WHEN ShipLoc = '02' THEN SUM(QtyOrdered) ELSE 0 END AS Qty02,
	CASE WHEN ShipLoc = '03' THEN SUM(QtyOrdered) ELSE 0 END AS Qty03,
	CASE WHEN ShipLoc = '04' THEN SUM(QtyOrdered) ELSE 0 END AS Qty04,
	CASE WHEN ShipLoc = '05' THEN SUM(QtyOrdered) ELSE 0 END AS Qty05,
	CASE WHEN ShipLoc = '07' THEN SUM(QtyOrdered) ELSE 0 END AS Qty07,
	CASE WHEN ShipLoc = '08' THEN SUM(QtyOrdered) ELSE 0 END AS Qty08,
	CASE WHEN ShipLoc = '09' THEN SUM(QtyOrdered) ELSE 0 END AS Qty09,
	CASE WHEN ShipLoc = '10' THEN SUM(QtyOrdered) ELSE 0 END AS Qty10,
	CASE WHEN ShipLoc = '11' THEN SUM(QtyOrdered) ELSE 0 END AS Qty11,
	CASE WHEN ShipLoc = '12' THEN SUM(QtyOrdered) ELSE 0 END AS Qty12,
	CASE WHEN ShipLoc = '13' THEN SUM(QtyOrdered) ELSE 0 END AS Qty13,
	CASE WHEN ShipLoc = '14' THEN SUM(QtyOrdered) ELSE 0 END AS Qty14,
	CASE WHEN ShipLoc = '15' THEN SUM(QtyOrdered) ELSE 0 END AS Qty15,
	CASE WHEN ShipLoc = '16' THEN SUM(QtyOrdered) ELSE 0 END AS Qty16,
	CASE WHEN ShipLoc = '17' THEN SUM(QtyOrdered) ELSE 0 END AS Qty17,
	CASE WHEN ShipLoc = '18' THEN SUM(QtyOrdered) ELSE 0 END AS Qty18,
	CASE WHEN ShipLoc = '19' THEN SUM(QtyOrdered) ELSE 0 END AS Qty19,
	CASE WHEN ShipLoc = '20' THEN SUM(QtyOrdered) ELSE 0 END AS Qty20,
	CASE WHEN ShipLoc = '21' THEN SUM(QtyOrdered) ELSE 0 END AS Qty21
FROM	tWO1546_BOHistory
GROUP BY ItemNo, ShipLoc
ORDER BY ItemNo





SELECT	[Porteous$Sales Header].[Back Order],
	[Porteous$Sales Line].[Document No_], 
	[Porteous$Sales Line].No_, 
        [Porteous$Sales Header].[Shipping Location], 
	[Porteous$Sales Line].Quantity,
	[Porteous$Sales Line].Description, 
	[Porteous$Sales Line].[Alt_ Price], 
	[Porteous$Sales Line].[Alt_ Price UOM],
	[Porteous$Sales Line].[Alt_ Qty_ UOM], 
	[Porteous$Sales Line].[Alt_ Quantity], 
	[Porteous$Sales Header].[Posting Date],
	[Porteous$Sales Header].[Sell-to Customer No_], 
	[Porteous$Sales Header].[Sell-to Customer Name], 
        [Porteous$Sales Line].[Line No_],
	[Porteous$Sales Line].[Unit Price], 
	[Porteous$Sales Line].[Unit of Measure Code], 
        [Porteous$Sales Header].[Entered User ID],
	[Porteous$Sales Header].[Inside Salesperson Code]
FROM	[Porteous$Sales Header] INNER JOIN
        [Porteous$Sales Line] ON [Porteous$Sales Header].No_ = [Porteous$Sales Line].[Document No_]
WHERE     ([Porteous$Sales Header].[Back Order] = 1) AND ([Porteous$Sales Line].Quantity <> 0)



SELECT	SOHeader.BOFlag AS [Back Order],
	SOHeader.OrderNo AS [Document No_],
--	SOHeader.RefSONo,
	SODetail.ItemNo AS [No_],
	SOHeader.ShipLoc AS [Shipping Location],
	SODetail.QtyOrdered AS Quantity,
	SODetail.ItemDsc AS [Description],
--[Porteous$Sales Line].[Alt_ Price], 
--[Porteous$Sales Line].[Alt_ Price UOM],
--[Porteous$Sales Line].[Alt_ Qty_ UOM], 
--[Porteous$Sales Line].[Alt_ Quantity], 
	SOHeader.EntryDt AS [Posting Date],
	SOHeader.SellToCustNo AS [Sell-to Customer No_],
	SOHeader.SellToCustName AS [Sell-to Customer Name],
	SODetail.LineNumber AS [Line No_],
	SODetail.ListUnitPrice AS [Unit Price],
--[Porteous$Sales Line].[Unit of Measure Code], 
	SOHeader.EntryID AS UserID,
	SOHeader.CustSvcRepNo AS InsideSales
FROM	SOHeader INNER JOIN
	SODetail
ON	SOHeader.pSOHeaderID = SODetail.fSOHeaderID
WHERE	SOHeader.BOFlag = 'BO' AND SODetail.QtyOrdered <> 0