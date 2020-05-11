--UPDATE Customer DeleteDt & CreditInd

--SET Customer Deleted
UPDATE	CustomerMaster
SET		DeleteDt = GetDate()
WHERE	CustNo IN (SELECT DISTINCT [Customer No_]
				   FROM	  OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Customer Soft Block]
				   WHERE  [Quote] = 1 AND [Blanket Order] = 1 AND [Order] = 1 AND [Return] = 1 AND [Credit Memo] = 1 AND [Shipment] = 1)
go

--SET Customer Not Deleted
UPDATE	CustomerMaster
SET		DeleteDt = null
WHERE	CustNo IN (SELECT DISTINCT [Customer No_]
				   FROM	  OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Customer Soft Block]
				   WHERE  [Quote] <> 1 AND [Blanket Order] <> 1 AND [Order] <> 1 AND [Return] <> 1 AND [Credit Memo] <> 1 AND [Shipment] <> 1)
go

--SET Customer On Hold
UPDATE	CustomerMaster
SET		CreditInd = 'X'
WHERE	CustNo IN (SELECT DISTINCT [Customer No_]
				   FROM	  OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Customer Soft Block]
				   WHERE  [Quote] = 1 AND [Blanket Order] = 1 AND [Order] = 1 AND [Shipment] = 1)
go

--SET Customer Not On Hold
UPDATE	CustomerMaster
SET		CreditInd = 'A'
WHERE	CustNo IN (SELECT DISTINCT [Customer No_]
				   FROM	  OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Customer Soft Block]
				   WHERE  [Quote] <> 1 OR [Blanket Order] <> 1 OR [Order] <> 1 OR [Shipment] <> 1)
go

--SET Customer Not On Hold when NV Soft Block does not exists
UPDATE	CustomerMaster
SET		CreditInd = 'A'
WHERE	isnull(DeleteDt,'') = '' AND
		CustNo NOT IN (SELECT	DISTINCT [Customer No_]
					   FROM		OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Customer Soft Block])
go

--SET Customer Not On Hold when not set
UPDATE	CustomerMaster
SET		CreditInd = 'A'
WHERE	isnull(CreditInd,'') = ''
go

--SET Blocked customer when NV Customer does not exist
UPDATE	CustomerMaster
SET		DeleteDt = GetDate(), CreditInd = 'X'
WHERE	CustNo NOT IN (SELECT	DISTINCT [No_]
					   FROM		OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Customer])
go
