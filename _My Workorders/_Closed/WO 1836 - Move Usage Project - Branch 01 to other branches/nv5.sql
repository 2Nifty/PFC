--PFCDB05.PFCFinance


select * from tWO1836_CustList


SELECT	Cust.[No_], CustList.CustNo, Cust.[Usage Location], *
FROM	[Porteous$Customer] Cust INNER JOIN
	tWO1836_CustList CustList
ON	Cust.[No_] = CustList.CustNo


--NV5 [Porteous$Customer] - Less than 1 minute in DB05 (1,172 rows affected)
UPDATE	[Porteous$Customer]
SET	--[Usage Location] = '99'
	[Usage Location] = CustList.NewUsageLoc
FROM	tWO1836_CustList CustList INNER JOIN
	[Porteous$Customer] NV
ON	NV.[No_] = CustList.CustNo