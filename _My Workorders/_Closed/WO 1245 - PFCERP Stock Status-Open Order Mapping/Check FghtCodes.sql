--select * from [Porteous$Purchase Header] where [Shipment Method Code]='PPD' or [Shipment Method Code]='PPD-ADD' or [Shipment Method Code]='UPS' or [Shipment Method Code]='WILL CALL' or [Shipment Method Code]='PPD-CLE'



--[Porteous$Purchase Header]
SELECT	DISTINCT
	Hdr.[Shipment Method Code] as FreightCd, Hdr.[Shipping Agent Code] as CarCd, Hdr.*
FROM	[Porteous$Purchase Header] Hdr INNER JOIN
	[Porteous$Purchase Line] Line
ON	Hdr.[No_] = Line.[Document No_]
WHERE	Line.[Quantity] - Line.[Quantity Received] > 0 AND Line.[No_] <> '' AND
	([Shipment Method Code]='BRNCHBEST' or [Shipment Method Code]='PPD' or [Shipment Method Code]='PPD-ADD' or [Shipment Method Code]='UPS' or [Shipment Method Code]='WILL CALL' or [Shipment Method Code]='PPD-CLE') AND
--	([Shipment Method Code]='' or [Shipment Method Code] is null or [Shipping Agent Code]='' or [Shipping Agent Code] is null) AND
	Hdr.[Order Type] <> 0 AND (Line.Type = 1 OR Line.Type = 2)



--select * from [Porteous$Sales Header] where [Shipment Method Code]='PPD' or [Shipment Method Code]='PPD-ADD' or [Shipment Method Code]='UPS' or [Shipment Method Code]='WILL CALL' or [Shipment Method Code]='PPD-CLE'


--[Porteous$Sales Header] - Order; Credit Memo; Return Order
SELECT	DISTINCT
	NVHDR.[Shipment Method Code] as FreightCd, NVHDR.[Shipping Agent Code] as CarCd, NVHDR.*
FROM	[Porteous$Sales Header] NVHDR INNER JOIN
	[Porteous$Sales Line] NVLINE
ON	NVHDR.[No_] = NVLINE.[Document No_]
WHERE	NVLINE.[Qty_ to Ship] > 0 AND NVLINE.[No_] <> '' AND
	(NVHDR.[Document Type] = 1 OR NVHDR.[Document Type] = 3 OR NVHDR.[Document Type] = 5) AND
	(NVHDR.[Shipment Method Code]='BRNCHBEST' or NVHDR.[Shipment Method Code]='PPD' or NVHDR.[Shipment Method Code]='PPD-ADD' or NVHDR.[Shipment Method Code]='UPS' or NVHDR.[Shipment Method Code]='WILL CALL' or NVHDR.[Shipment Method Code]='PPD-CLE') AND
--	(NVHDR.[Shipment Method Code]='' or NVHDR.[Shipment Method Code] is null or NVHDR.[Shipping Agent Code]='' or NVHDR.[Shipping Agent Code] is null) AND
	(NVHDR.[No_] < 'SRA' OR NVHDR.[No_] > 'SRA1178701')






--select * from [Porteous$Sales Header] where [Shipment Method Code]='PPD' or [Shipment Method Code]='PPD-ADD' or [Shipment Method Code]='UPS' or [Shipment Method Code]='WILL CALL' or [Shipment Method Code]='PPD-CLE'


--[Porteous$Transfer Header]
SELECT	DISTINCT
	NVHDR.[Shipment Method Code] as FreightCd, NVHDR.[Shipping Agent Code] as CarCd, NVHDR.*
FROM	[Porteous$Transfer Header] NVHDR INNER JOIN
	[Porteous$Transfer Line] NVLINE
ON	[No_] = [Document No_]
WHERE	[Qty_ to Ship] > 0 AND [Item No_]<>'' and
	(NVHDR.[Shipment Method Code]='BRNCHBEST' or NVHDR.[Shipment Method Code]='PPD' or NVHDR.[Shipment Method Code]='PPD-ADD' or NVHDR.[Shipment Method Code]='UPS' or NVHDR.[Shipment Method Code]='WILL CALL' or NVHDR.[Shipment Method Code]='PPD-CLE')
--	(NVHDR.[Shipment Method Code]='' or NVHDR.[Shipment Method Code] is null or NVHDR.[Shipping Agent Code]='' or NVHDR.[Shipping Agent Code] is null)



--select * from [Porteous$Shipping Agent] where LEN([Name]) > 30