
select	[No_] AS CustNo, [Name], [Name 2], [Address], [Address 2], [City], [County], [Country_Region Code], [Post Code]
from	Porteous$Customer
WHERE	LEN([County]) > 2
Order By [No_]



select	[No_] AS VendNo, [Name], [Name 2], [Address], [Address 2], [City], [County], [Country_Region Code], [Post Code]
from	Porteous$Vendor
WHERE	LEN([County]) > 2
Order By [No_]





select	[No_] AS CustNo, [Name], [Name 2], [Address], [Address 2], [City], [County], [Country_Region Code], [Post Code]
from	Porteous$Customer
WHERE	LEN([Post Code]) > 10
Order By [No_]



select	[No_] AS VendNo, [Name], [Name 2], [Address], [Address 2], [City], [County], [Country_Region Code], [Post Code]
from	Porteous$Vendor
WHERE	LEN([Post Code]) > 10
Order By [No_]