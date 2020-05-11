CREATE VIEW vCatStkSummary as
----vCatStkSummary
----Written By: Tod Dixon
----Appliction: Inventory Management

--Summarize by Location/Category/Plating
SELECT	LocationCode, LEFT(ItemNo,5) AS Category,  PlatingNo,  Items.ItemCount AS ItemCount, COUNT(LocationCode) AS SKUCount, CAST(SUM(TotUse30) AS NUMERIC) AS TotUse30,
	CAST(SUM(AvailQty) AS NUMERIC) AS AvailQty, CAST(SUM(ExtSoldWght) AS DECIMAL(38, 6)) AS ExtSoldWght, CAST(SUM(AvailQtyWght) AS DECIMAL(38, 6)) AS AvailQtyWght,
	CASE SUM(ExtSoldWght)
	   WHEN 0 THEN 0
	   ELSE SUM(AvailQtyWght) / SUM(ExtSoldWght)
	END AS MonthsOH,
	CAST(SUM(Rop_Calc) AS DECIMAL(38, 6)) AS ROP_Calc
FROM	CatStkDetail INNER JOIN
	(SELECT	LocationCode AS Loc, LEFT(ItemNo,5) AS Cat,  PlatingNo AS Plt, COUNT(LocationCode) AS ItemCount
	 FROM	CatStkDetail
	 WHERE	(SUBSTRING(ItemNo, 12, 1) = '0' OR SUBSTRING(ItemNo, 12, 1) = '5')
	 GROUP BY LocationCode, LEFT(ItemNo,5), PlatingNo) Items
ON	(LocationCode=Loc AND LEFT(ItemNo,5)=CAT AND PlatingNo=Plt)
WHERE	(SUBSTRING(ItemNo, 12, 1) = '0' OR SUBSTRING(ItemNo, 12, 1) = '5') AND CorpFixedVelCode <> '' AND (SalesVelCode <> 'N' OR SalesVelCode IS NULL)
GROUP BY LocationCode, LEFT(ItemNo,5), PlatingNo, Items.ItemCount
--ORDER BY LEFT(ItemNo,5), LocationCode, PlatingNo
go