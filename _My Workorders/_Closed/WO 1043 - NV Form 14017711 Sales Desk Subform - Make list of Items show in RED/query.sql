--SELECT	PriceWorkSheetColorInd, * 

UPDATE	[Porteous$Item]
SET	PriceWorkSheetColorInd = [Color Code]
FROM	[Porteous$Item] INNER JOIN
	tUpdPriceWorkSheetColorInd ON
	[No_] = Item
