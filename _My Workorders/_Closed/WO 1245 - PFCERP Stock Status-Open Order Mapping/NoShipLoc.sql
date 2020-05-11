
SELECT [Transfer-from Code], *
from [Porteous$Transfer Header]
where ([Transfer-from Code]='' or [Transfer-from Code] is null) 

select [Shipping Location], *
from [Porteous$Sales Header]
where ([Shipping Location]='' or [Shipping Location] is null) and [Document Type]=1
--[Location Code]<>[Shipping Location] and [Document Type]=1


-------------------------------------------------------------------


select [Shipping Location], * from [Porteous$Customer]
where [Shipping Location]='' or [Shipping Location] is null --or [Shipping Location]='0' or [Shipping Location]='00'



--update [Porteous$Sales Header]
--set [Shipping Location]='07'
--where [No_]='SO2148093'


--[Porteous$Sales Header] - Order; Credit Memo; Return Order
SELECT	DISTINCT [Shipping Location], NVHDR.*
FROM	[Porteous$Sales Header] NVHDR INNER JOIN
	[Porteous$Sales Line] NVLINE
ON	NVHDR.[No_] = NVLINE.[Document No_]
WHERE	NVLINE.[Qty_ to Ship] > 0 AND NVLINE.[No_] <> '' AND
	(NVHDR.[Document Type] = 1 OR NVHDR.[Document Type] = 3 OR NVHDR.[Document Type] = 5) AND
	(NVHDR.[No_] < 'SRA' OR NVHDR.[No_] > 'SRA1178701') AND
	([Shipping Location]='' or [Shipping Location] is null or [Shipping Location]='0' or [Shipping Location]='00')


--[Porteous$Transfer Header]
SELECT	DISTINCT NVHDR.[Transfer-from Code], NVHDR.*
FROM	[Porteous$Transfer Header] NVHDR INNER JOIN
	[Porteous$Transfer Line] NVLINE
ON	[No_] = [Document No_]
WHERE	[Qty_ to Ship] > 0 AND [Item No_]<>'' and 
	(NVHDR.[Transfer-from Code]='' or NVHDR.[Transfer-from Code] is null or NVHDR.[Transfer-from Code]='0' or NVHDR.[Transfer-from Code]='00') 



-------------------------------------------------------------------



SELECT	RefSONo, ShipLoc,
	ShipToCd, ShipToName, ShipToAddress3, ShipToAddress1, ShipToAddress2, City, State, Zip,
	SellToCustNo, SellToCustName, SellToAddress1, SellToAddress2, SellToCity, SellToState, SellToZip,
	CustSvcRepName, EntryID
FROM	SOHeader
WHERE	ShipLoc is NULL or ShipLoc = '' or ShipLoc='0' or ShipLoc='00'



IF ((SELECT COUNT(*) FROM SOHeader WHERE ShipLoc is NULL or ShipLoc = '' or ShipLoc='0' or ShipLoc='00') > 0)
   BEGIN
	PRINT 'Not ZERO'
   END
ELSE 
   BEGIN
	PRINT 'ZERO'
	RAISERROR (500000,10,1) WITH SETERROR
   END




