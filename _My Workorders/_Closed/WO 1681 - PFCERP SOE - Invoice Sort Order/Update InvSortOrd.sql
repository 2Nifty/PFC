--Initial UPDATE to set all ERP Customers to 'L'
UPDATE	CustomerMaster
SET	InvSortOrd = 'L'

--Seconday UPDATE to set all ERP Customers based on NV5 Production (PFCDB02.PFCFinance)
UPDATE	CustomerMaster
SET	InvSortOrd = List.Listvalue
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').PFCFinance.dbo.[Porteous$Customer] INNER JOIN
--	OpenDataSource('SQLOLEDB','Data Source=PFCDB02;User ID=pfcnormal;Password=pfcnormal').PFCFinance.dbo.[Porteous$Customer] INNER JOIN
	(SELECT	SequenceNo, ListValue
	 FROM	ListMaster INNER JOIN ListDetail
	 ON	pListMasterID = fListMasterID
	 WHERE	ListName = 'InvoiceSortOrd') List
ON	[Invoice Detail Sort] = List.SequenceNo
WHERE	CustNo = [No_]


---------------------------------------------------------------------------------------

--UPDATE InvSortOrd for Customer Inserts--
UPDATE	CustomerMaster
SET	InvSortOrd = List.Listvalue
FROM	OpenDataSource('SQLOLEDB','Data Source=pfcdb05;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPCustInsert] CustUpd INNER JOIN
--	OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPCustInsert] CustUpd INNER JOIN
	(SELECT	SequenceNo, ListValue
	 FROM	ListMaster INNER JOIN ListDetail
	 ON	pListMasterID = fListMasterID
	 WHERE	ListName = 'InvoiceSortOrd') List
ON	[Invoice Detail Sort] = List.SequenceNo
WHERE	CustNo = [No_]


---------------------------------------------------------------------------------------

--UPDATE InvSortOrd for Customer Updates--
UPDATE	CustomerMaster
SET	InvSortOrd = List.Listvalue
FROM	OpenDataSource('SQLOLEDB','Data Source=pfcdb05;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPCustUpdate] CustUpd INNER JOIN
--	OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPCustUpdate] CustUpd INNER JOIN
	(SELECT	SequenceNo, ListValue
	 FROM	ListMaster INNER JOIN ListDetail
	 ON	pListMasterID = fListMasterID
	 WHERE	ListName = 'InvoiceSortOrd') List
ON	[Invoice Detail Sort] = List.SequenceNo
WHERE	CustNo = [No_]


---------------------------------------------------------------------------------------



--db02 = production
--db05 = test


select [Invoice Detail Sort], * from OpenDataSource('SQLOLEDB','Data Source=pfcdb05;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPCustUpdate]
select * 
into 	[tERPCustInsert]
from 	[Porteous$Customer]
where 	No_='002901'


UPDATE CustomerMaster set InvSortOrd=null where CustNo='002901'
select InvsortOrd, * from CustomerMaster where CustNo='002901'


select InvSortOrd, * from CustomerMaster order by custNo

--select distinct InvSortOrd from CustomerMaster

--11761 (db02)
--11482 (db05)
select * from CustomerMaster
Where CustNo in
(select No_ from OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').PFCFinance.dbo.[Porteous$Customer])

