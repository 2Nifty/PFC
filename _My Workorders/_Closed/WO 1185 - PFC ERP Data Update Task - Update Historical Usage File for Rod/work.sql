

select *
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tRodItems) Rods
ON	AUE.[Item No_]=Rods.[Item No_] and AUE.[Usage Location]=Rods.[Location Code]
INNER JOIN tRodFactor RodFactor
ON	Rods.[Item No_]=RodFactor.Item
--WHERE	AUE.[Source Quantity] > 0



select *
FROM	[Porteous$Actual Usage Entry] AUE
INNER JOIN
(SELECT	*
FROM	tAUEVerify) Entry
ON	AUE.[Entry No_]=Entry.[EntryNo]






----Update Item Branch Usage CurSalesQty and CurNRSalesQty


select CurSalesQty, CurNRSalesQty, *
FROM	[ItemBranchUsage] AUE
INNER JOIN (SELECT * FROM tItemPointer) Rods
ON	AUE.[ItemNo]=Rods.[tItemNo] AND AUE.[Location]=Rods.[tLocation]
INNER JOIN tRodFactor RodFactor
ON	Rods.[tItemNo]=RodFactor.Item
WHERE	AUE.[CurNRSalesQty] < 0 OR [CurSalesQty] < 0




select CurSalesQty, CurNRSalesQty, *
FROM	[ItemBranchUsage] AUE
INNER JOIN (SELECT * FROM tItemPointer) Rods
ON	AUE.[ItemNo]=Rods.[tItemNo] AND AUE.[Location]=Rods.[tLocation]
INNER JOIN tRodFactor RodFactor
ON	Rods.[tItemNo]=RodFactor.Item
WHERE	AUE.[CurNRSalesQty] = 0 and [CurSalesQty] = 0


