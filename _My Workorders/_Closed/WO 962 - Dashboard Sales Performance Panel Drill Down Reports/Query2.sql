
DECLARE @@StartDt VARCHAR(10)
SET @@StartDt='200809'

SELECT	Loc_No, CurYear * 100 + CurMonth AS [Month],
	BUD_LbsShipped AS SepLbs, BUD_SalesDollar AS SepSalesDollars, 
	BUD_GrossMarginDollar AS SepMgnDollars, BUDBrnExp AS SepExpense
FROM	DashBoardBudgets
WHERE	(CurYear * 100 + CurMonth >= @@StartDt AND Cur)
--ORDER BY Location, [Month]










SELECT	Loc_No, CurYear * 100 + CurMonth AS [Month],
	BUD_LbsShipped AS Lbs, BUD_SalesDollar AS SalesDollars, 
	BUD_GrossMarginDollar AS MgnDollars, BUDBrnExp AS Expense
FROM	DashBoardBudgets
WHERE	(CurYear * 100 + CurMonth >= @@StartDt)
--ORDER BY Location, [Month]
