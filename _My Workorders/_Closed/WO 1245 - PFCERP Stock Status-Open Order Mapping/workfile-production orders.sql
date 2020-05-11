--select RIGHT('000000'+[Location Code],6) AS LocationCd, * from [Porteous$Production Order]



--[Porteous$Production Order]
SELECT	Prod.[No_] as POOrderNo,
	'WO' as POType,
	RIGHT('000000'+Prod.[Location Code],6) as BuyFromVendorNo,
	Cust.[Address] as BuyFromAddress,
	Cust.[City] as BuyFromCity,
	Cust.[County] as BuyFromState,
	Cust.[Post Code] as BuyFromZip,
	Cust.[Country Code] as BuyFromCountry,
	Cust.[Phone No_] as OrderContactPhoneNo,
	Cust.[Contact] as OrderContactName,
	Cust.[Name] as ShipToName,
	Cust.[Address] as ShipToAddress,
	Cust.[City] as ShipToCity,
	Cust.[County] as ShipToState,
	Cust.[Post Code] as ShipToZip,
	Cust.[Country Code] as ShipToCountry,
	Cust.[Phone No_] as ShipToPhoneNo,
	Cust.[Contact] as ShipToContactName,
	'N' as TaxStatus,
	Prod.[Sales Order No_] as OrderRefNo,
	Prod.[Location Code] as LocationCd,
	Prod.[Creation Date] as OrderDt,
	Prod.[Source No_] as WOItemNo,
	RIGHT('000000'+Prod.[Location Code],6) as Buyer,
	Prod.[Creation Date] as EntryDt,
	Prod.[Last Date Modified] as ChangeDt
FROM	[Porteous$Production Order] Prod INNER JOIN
	[Porteous$Customer] Cust
ON	RIGHT('000000' + Prod.[Location Code],6) = Cust.[No_]
WHERE	Prod.[Status] = 3


--order by Cust.[No_]
--where [No_]='000001'



select [Quantity (Base)],* from [Porteous$Prod_ Order Line]
where [Status]=3 and [Finished Quantity]<>0


select OrderRefNo, * from POHeader
order by POType


select * from POHeader where POtype='WO'


--[Porteous$Purchase Line]
SELECT	POHeader.pPOHeaderID as fPOHeaderID,
	NVLINE.[Prod_ Order No_] as POOrderNo,
	NVLINE.[Line No_] as POLineNo,
	NVLINE.[Due Date] as LastSchdReceiptDt,
	NVLINE.[Location Code] as ReceivingLocation,
	NVLINE.[Unit of Measure Code] as PurchaseUM,
	NVLINE.[Quantity (Base)] as PurchaseFactor,
	POHeader.EntryDt as EntryDate,
	NVLINE.[Item No_] as ItemNo,
	NVLINE.[Quantity] as QtyOrdered,
	NVLINE.[Quantity] * NVLINE.[Unit Cost] as ExtendedCost
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Prod_ Order Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Production Order] NVHDR
ON	NVHDR.[No_]=NVLINE.[Prod_ Order No_] INNER JOIN
	POHeader
ON	NVLINE.[Prod_ Order No_] = POHeader.POOrderNo




select POOrderNo, TotalMaterialCost, TotalExpenseCost, TotalCost from POHeader where POtype='WO'
order by POOrderNo

select POHeader.POOrderNo, ExtendedCost, TotalMaterialCost, TotalExpenseCost, TotalCost from PODetail inner join POHeader on pPOHeaderID=fPOHeaderID
where POType='WO'
order by POHeader.POOrderNo



exec sp_columns [Porteous$Prod_ Order Comment Line]




--[Porteous$Prod_ Order Comment Line] - Header Comments
SELECT	POHeader.pPOHeaderID as fPOHeaderID,
	'CT' as Type,
	'A' as FormsCd,
	0 as CommLineNo,
	[Line No_] as CommLineSeqNo,
	[Comment] as CommText
	[Date] as EntryDt,
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Prod_ Order Comment Line] COMMLINE INNER JOIN
	POHeader ON COMMLINE.[Prod_ Order No_] = POHeader.POOrderNo



select * from POHeader where POOrderNo='MAPR1052739'


select * from POComments order by fPOHeaderID