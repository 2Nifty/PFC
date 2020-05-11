--[Porteous$Transfer Header]
SELECT	DISTINCT
	NVHDR.[No_] as RefSONo,
	NVHDR.[Transfer-from Code] as OrderLoc,
	NVHDR.[Transfer-from Code] as ShipLoc,
	NVHDR.[Transfer-to Name] as ShipToName,
	NVHDR.[Transfer-to Name 2] as ShipToAddress3,
	NVHDR.[Transfer-to Address] as ShipToAddress1,
	NVHDR.[Transfer-to Address 2] as ShipToAddress2,
	NVHDR.[Transfer-to Post Code] as Zip,
	NVHDR.[Transfer-to City] as City,
	NVHDR.[Transfer-to County] as State,
	NVHDR.[Transfer-to Country Code] as Country,
	NVHDR.[Posting Date] as MakeOrderDt,
	NVHDR.[Shipment Date] as SchShipDt,
	NVHDR.[Status] as StatusCd,
	NVHDR.[Shortcut Dimension 1 Code] as CustShipLoc,
	NVHDR.[External Document No_] as CustPONo,
	NVHDR.[Shipping Agent Code] as OrderCarName,
	NVHDR.[Inbound Bill of Lading No_] as BOLNO,
	RIGHT('000000'+NVHDR.[Transfer-to Code],6) as ShipToCd,
	'N' as TaxStat,
	'TO' as OrderType
FROM	[Porteous$Transfer Header] NVHDR INNER JOIN
	[Porteous$Transfer Line] NVLINE
ON	[No_] = [Document No_]
WHERE	[Qty_ to Ship] > 0
ORDER BY [No_]




select NVLINE.*
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Transfer Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Transfer Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	SOHeader ON NVLINE.[Document No_] = SOHeader.RefSONo
WHERE	[Qty_ to Ship] > 0




select [Original Purchase Order], * from [Porteous$Transfer Header]
where [Original Purchase Order]<>''



select * from LocMaster



exec sp_columns [Porteous$Transfer Header]



select  * from [Porteous$Transfer Header]
where [Completely Shipped]=0




select COUNT([Qty_ to Ship]) as [count], SUM([Qty_ to Ship]) as Qty, [Document No_]
from [Porteous$Transfer Line]
group by [Document No_]
order by Qty


select * from  [Porteous$Transfer Line]
where [Document No_]='TO1174566'






select  * from [Porteous$Transfer Line]
--where [Quantity]-[Quantity Shipped] <> [Qty_ to Ship]



select Line.[Shortcut Dimension 1 Code], Hdr.* from [Porteous$Transfer Header] Hdr inner join [Porteous$Transfer Line] Line on Hdr.[No_]=Line.[Document No_]

where Line.[Shortcut Dimension 1 Code] <> Hdr.[Transfer-from Code]
order by Line.[Shortcut Dimension 1 Code]

