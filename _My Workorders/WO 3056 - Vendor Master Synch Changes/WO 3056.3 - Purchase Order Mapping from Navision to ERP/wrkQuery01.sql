
select distinct POCommentsInd from POHeader



--UPDATE POExpenseInd
UPDATE	POHeader
SET	POExpenseInd = 'Y'
WHERE	pPOHeaderID IN (SELECT	Expense.pPOHeaderID
			FROM	(SELECT	pPOHeaderID, COUNT(POE.LineNumber) as ExpenseCount
				 FROM	POHeader POH (NoLock) INNER JOIN
					POExpense POE (NoLock)
				 ON	POH.pPOHeaderID = POE.fPOHeaderID
				 GROUP BY pPOHeaderID) Expense
			WHERE	Expense.ExpenseCount > 0)
go





select * from POExpense



exec sp_columns PODetail

--is the loc table on Reports up to date?
select distinct changedt from LocMaster
order by changedt


exec sp_columns POHeader
SELECT * FROM POHeader



UPDATE	POHeader
SET		ShipMethodCd = isnull(VA.ShipMeth,''),
		ShipMethodName = ''
--SELECT	VM.PVendMstrID, VM.VendNo, VM.VendorType, VA.Type, VA.fBuyFromAddrID, VA.AlphaSearch, VA.ShipMeth, VA.Email, VA.FaxPhoneNo
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorMaster VM INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.VendorAddress VA
ON		VM.pvendMstrID = VA.fVendMstrID
WHERE	




select OrderFreightCd, * from POHeader




select * from ListMaster
order by ListName

