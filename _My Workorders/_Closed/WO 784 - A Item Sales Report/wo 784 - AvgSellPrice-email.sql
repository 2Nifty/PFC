
------------------------------------------------------------------------------------------------------

Declare	@BeginDate DATETIME
Declare	@EndDate   DATETIME

SET	@BeginDate = 
(SELECT	MIN(CurFiscalMthBeginDt) AS BeginDt
 FROM	(SELECT DISTINCT CurFiscalMthBeginDt, CurFiscalMthEndDt
	 FROM	FiscalCalendar
	 WHERE	(CurFiscalMthEndDt >= GETDATE() - (30.44*6)) AND (CurFiscalMthEndDt <= GETDATE())) SixMonth)

SET	@EndDate = 
(SELECT	MAX(CurFiscalMthEndDt) AS EndDt
 FROM	(SELECT DISTINCT CurFiscalMthBeginDt, CurFiscalMthEndDt
	 FROM	FiscalCalendar
	 WHERE	(CurFiscalMthEndDt >= GETDATE() - (30.44*6)) AND (CurFiscalMthEndDt <= GETDATE())) SixMonth)


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].t6MthAvgSellPrice') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table t6MthAvgSellPrice

------------------------------------------------------------------------------------------------------
----Corporate
--6 Month Avg Sell Price
SELECT	*, ItemNo as Location, SumLinePrice / SumQty as [6MthAvgSellPrice],
	CAST(0.0 as NUMERIC(38,6)) as [LastWkAvgSellPrice],
	CAST(0.0 as NUMERIC(38,6)) as [2ndWkAvgSellPrice],
	CAST(0.0 as NUMERIC(38,6)) as [3rdWkAvgSellPrice],
	CAST(0.0 as NUMERIC(38,6)) as [4thWkAvgSellPrice]
INTO	t6MthAvgSellPrice
FROM	(SELECT	SODetailHist.ItemNo as ItemNo,
		SUM(SODetailHist.QtyOrdered * SODetailHist.NetUnitPrice) as SumLinePrice,
		SUM(SODetailHist.QtyOrdered) as SumQty
	 FROM	SOHeaderHist INNER JOIN
		SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
	 Where	  OrderDt >= @BeginDate and OrderDt <= @EndDate
	 Group By SODetailHist.ItemNo) SumLine
Where	 SumQty > 0

--Last Week Avg Sell Price
UPDATE	t6MthAvgSellPrice
SET	[LastWkAvgSellPrice]=Price / Qty
FROM	(SELECT	SODetailHist.ItemNo as Item,
		SUM(SODetailHist.QtyOrdered * SODetailHist.NetUnitPrice) as Price,
		SUM(SODetailHist.QtyOrdered) as Qty
	 FROM	SOHeaderHist INNER JOIN
		SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
	 Where	  OrderDt >= GETDATE() - 7 and OrderDt <= GETDATE()
	 Group By SODetailHist.ItemNo) SumLine
Where	 Qty > 0 and ItemNo=Item and Location=Item

--2 Weeks Back Avg Sell Price
UPDATE	t6MthAvgSellPrice
SET	[2ndWkAvgSellPrice]=Price / Qty
FROM	(SELECT	SODetailHist.ItemNo as Item,
		SUM(SODetailHist.QtyOrdered * SODetailHist.NetUnitPrice) as Price,
		SUM(SODetailHist.QtyOrdered) as Qty
	 FROM	SOHeaderHist INNER JOIN
		SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
	 Where	  OrderDt >= GETDATE() - 14 and OrderDt <= GETDATE() - 7
	 Group By SODetailHist.ItemNo) SumLine
Where	 Qty > 0 and ItemNo=Item and Location=Item

--3 Weeks Back Avg Sell Price
UPDATE	t6MthAvgSellPrice
SET	[3rdWkAvgSellPrice]=Price / Qty
FROM	(SELECT	SODetailHist.ItemNo as Item,
		SUM(SODetailHist.QtyOrdered * SODetailHist.NetUnitPrice) as Price,
		SUM(SODetailHist.QtyOrdered) as Qty
	 FROM	SOHeaderHist INNER JOIN
		SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
	 Where	  OrderDt >= GETDATE() - 21 and OrderDt <= GETDATE() - 14
	 Group By SODetailHist.ItemNo) SumLine
Where	 Qty > 0 and ItemNo=Item and Location=Item

--4 Weeks Back Avg Sell Price
UPDATE	t6MthAvgSellPrice
SET	[4thWkAvgSellPrice]=Price / Qty
FROM	(SELECT	SODetailHist.ItemNo as Item,
		SUM(SODetailHist.QtyOrdered * SODetailHist.NetUnitPrice) as Price,
		SUM(SODetailHist.QtyOrdered) as Qty
	 FROM	SOHeaderHist INNER JOIN
		SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
	 Where	  OrderDt >= GETDATE() - 28 and OrderDt <= GETDATE() - 21
	 Group By SODetailHist.ItemNo) SumLine
Where	 Qty > 0 and ItemNo=Item and Location=Item

------------------------------------------------------------------------------------------------------
----Location Specific
--6 Month Avg Sell Price
INSERT	INTO	t6MthAvgSellPrice
	Select	ItemNo,  SumLinePrice, SumQty, ShipLoc as Location, SumLinePrice / SumQty as [6MthAvgSellPrice],
		CAST(0.0 as NUMERIC(38,6)) as [LastWkAvgSellPrice],
		CAST(0.0 as NUMERIC(38,6)) as [2ndWkAvgSellPrice],
		CAST(0.0 as NUMERIC(38,6)) as [3rdWkAvgSellPrice],
		CAST(0.0 as NUMERIC(38,6)) as [4thWkAvgSellPrice]
	FROM	(SELECT	SODetailHist.ItemNo as ItemNo, ShipLoc,
			SUM(SODetailHist.QtyOrdered * SODetailHist.NetUnitPrice) as SumLinePrice,
			SUM(SODetailHist.QtyOrdered) as SumQty
		 FROM	SOHeaderHist INNER JOIN
			SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
--		 Where	OrderDt >= '2007-11-25' and OrderDt <= '2008-05-31'
	 	 Where	OrderDt >= @BeginDate and OrderDt <= @EndDate
	 	 Group By SODetailHist.ItemNo, ShipLoc) SumLine
	Where	 SumQty > 0

--Last Week Avg Sell Price
UPDATE	t6MthAvgSellPrice
SET	[LastWkAvgSellPrice]=Price / Qty
FROM	(SELECT	SODetailHist.ItemNo as Item, ShipLoc,
		SUM(SODetailHist.QtyOrdered * SODetailHist.NetUnitPrice) as Price,
		SUM(SODetailHist.QtyOrdered) as Qty
	 FROM	SOHeaderHist INNER JOIN
		SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
	 Where	  OrderDt >= GETDATE() - 7 and OrderDt <= GETDATE()
	 Group By SODetailHist.ItemNo, ShipLoc) SumLine
Where	 Qty > 0 and ItemNo=Item and Location=ShipLoc

--2 Weeks Back Avg Sell Price
UPDATE	t6MthAvgSellPrice
SET	[2ndWkAvgSellPrice]=Price / Qty
FROM	(SELECT	SODetailHist.ItemNo as Item, ShipLoc,
		SUM(SODetailHist.QtyOrdered * SODetailHist.NetUnitPrice) as Price,
		SUM(SODetailHist.QtyOrdered) as Qty
	 FROM	SOHeaderHist INNER JOIN
		SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
	 Where	  OrderDt >= GETDATE() - 14 and OrderDt <= GETDATE() - 7
	 Group By SODetailHist.ItemNo, ShipLoc) SumLine
Where	 Qty > 0 and ItemNo=Item and Location=ShipLoc

--3 Weeks Back Avg Sell Price
UPDATE	t6MthAvgSellPrice
SET	[3rdWkAvgSellPrice]=Price / Qty
FROM	(SELECT	SODetailHist.ItemNo as Item, ShipLoc,
		SUM(SODetailHist.QtyOrdered * SODetailHist.NetUnitPrice) as Price,
		SUM(SODetailHist.QtyOrdered) as Qty
	 FROM	SOHeaderHist INNER JOIN
		SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
	 Where	  OrderDt >= GETDATE() - 21 and OrderDt <= GETDATE() - 14
	 Group By SODetailHist.ItemNo, ShipLoc) SumLine
Where	 Qty > 0 and ItemNo=Item and Location=ShipLoc

--4 Weeks Back Avg Sell Price
UPDATE	t6MthAvgSellPrice
SET	[4thWkAvgSellPrice]=Price / Qty
FROM	(SELECT	SODetailHist.ItemNo as Item, ShipLoc,
		SUM(SODetailHist.QtyOrdered * SODetailHist.NetUnitPrice) as Price,
		SUM(SODetailHist.QtyOrdered) as Qty
	 FROM	SOHeaderHist INNER JOIN
		SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID
	 Where	  OrderDt >= GETDATE() - 28 and OrderDt <= GETDATE() - 21
	 Group By SODetailHist.ItemNo, ShipLoc) SumLine
Where	 Qty > 0 and ItemNo=Item and Location=ShipLoc


------------------------------------------------------------------------------------------------------
--Update CPR_Daily

UPDATE	CPR_Daily
SET	[6MthAvgSellPrice] = t6MthAvgSellPrice.[6MthAvgSellPrice],
	[LastWkAvgSellPrice] = t6MthAvgSellPrice.[LastWkAvgSellPrice],
	[2ndWkAvgSellPrice] = t6MthAvgSellPrice.[2ndWkAvgSellPrice],
	[3rdWkAvgSellPrice] = t6MthAvgSellPrice.[3rdWkAvgSellPrice],
	[4thWkAvgSellPrice] = t6MthAvgSellPrice.[4thWkAvgSellPrice]
FROM	t6MthAvgSellPrice
WHERE	CPR_Daily.ItemNo = t6MthAvgSellPrice.ItemNo and CPR_Daily.LocationCode = t6MthAvgSellPrice.Location

