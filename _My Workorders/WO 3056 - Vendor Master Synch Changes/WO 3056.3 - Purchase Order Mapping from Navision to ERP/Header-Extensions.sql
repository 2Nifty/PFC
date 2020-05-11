--UPDATE TotalCost, TotalMaterialCost, TotalExpenseCost, OriginalCostOfMaterial & OpenMaterialCost

--TotalCost & TotalMaterialCost
UPDATE	POHeader
SET	TotalCost = isnull(Cost.TotCost,0),
	TotalMaterialCost = isnull(Cost.TotCost,0)
FROM	(SELECT	POHeader.POOrderNo, SUM(isnull(PODetail.ExtendedCost,0)) as TotCost
	 FROM	PODetail INNER JOIN
		POHeader
	 ON	pPOHeaderID = fPOHeaderID
	 GROUP BY POHeader.POOrderNo) Cost
WHERE	Cost.POOrderNo = POHeader.POOrderNo
go

UPDATE	POHeader
SET	TotalCost = 0
WHERE	TotalCost is null
go

UPDATE	POHeader
SET	TotalMaterialCost = 0
WHERE	TotalMaterialCost is null
go

----------------------------------------------------------

--TotalExpenseCost
UPDATE	POHeader
SET	TotalExpenseCost = Amount.TotExp
FROM	(SELECT	POHeader.POOrderNo, SUM(POExpense.Amount) as TotExp
	 FROM	POExpense INNER JOIN
		POHeader
	 ON	pPOHeaderID = fPOHeaderID
	 GROUP BY POHeader.POOrderNo) Amount
WHERE	Amount.POOrderNo = POHeader.POOrderNo
go

UPDATE	POHeader
SET	TotalExpenseCost = 0
WHERE	TotalExpenseCost is null
go

----------------------------------------------------------

--OriginalCostOfMaterial
UPDATE	POHeader
SET	OriginalCostOfMaterial = isnull(Cost.OrigCost,0)
FROM	(SELECT	POHeader.POOrderNo, SUM(isnull(PODetail.QtyOrdered,0) * isnull(PODetail.UnitCost,0)) as OrigCost
	 FROM	PODetail INNER JOIN
		POHeader
	 ON	pPOHeaderID = fPOHeaderID
	 GROUP BY POHeader.POOrderNo) Cost
WHERE	Cost.POOrderNo = POHeader.POOrderNo
go

UPDATE	POHeader
SET	OriginalCostOfMaterial = 0
WHERE	OriginalCostOfMaterial is null
go

----------------------------------------------------------

--OpenMaterialCost
UPDATE	POHeader
SET	OpenMaterialCost = isnull(Cost.OpenCost,0)
FROM	(SELECT	POHeader.POOrderNo, SUM((isnull(PODetail.QtyOrdered,0) - isnull(PODetail.QtyReceived,0)) * isnull(PODetail.UnitCost,0)) as OpenCost
	 FROM	PODetail INNER JOIN
		POHeader
	 ON	pPOHeaderID = fPOHeaderID
	 WHERE isnull(PODetail.CompleteDt,'') = ''
	 GROUP BY POHeader.POOrderNo) Cost
WHERE	Cost.POOrderNo = POHeader.POOrderNo
go

UPDATE	POHeader
SET	OpenMaterialCost = 0
WHERE	OpenMaterialCost is null
go

----------------------------------------------------------





--UPDATE TotalNetWeight & TotalGrossWeight
UPDATE	POHeader
SET	TotalNetWeight = isnull(Wght.NetWght,0),
	TotalGrossWeight = isnull(Wght.GrossWght,0)
FROM	(SELECT	POHeader.POOrderNo, SUM(isnull(PODetail.ExtendedWeight,0)) as NetWght, SUM(isnull(PODetail.ExtendedGrossWeight,0)) as GrossWght
	 FROM	PODetail INNER JOIN
		POHeader
	 ON	pPOHeaderID = fPOHeaderID
	 GROUP BY POHeader.POOrderNo) Wght
WHERE	Wght.POOrderNo = POHeader.POOrderNo
go

UPDATE	POHeader
SET	TotalNetWeight = 0
WHERE	TotalNetWeight is null
go

UPDATE	POHeader
SET	TotalGrossWeight = 0
WHERE	TotalGrossWeight is null
go