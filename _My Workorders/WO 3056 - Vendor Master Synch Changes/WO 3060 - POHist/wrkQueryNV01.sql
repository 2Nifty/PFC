select * from [Porteous$Purchase Header] where
left([No_],10) in
('17010435-1',
'28022607',
'30012601',
'32101702C3')


select * from [Porteous$Purchase Line] where
left([Document No_],10) in
('17010435-1',
'28022607',
'30012601',
'32101702C3')




select * from [Porteous$Item] where [No_]='99999-7533-209'



--[Porteous$Purchase Header]
SELECT	DISTINCT
	Hdr.[No_] as POOrderNo,
	Hdr.[Order Type] as POType,
	Hdr.[Buy-from Vendor No_] as BuyFromVendorNo,
	Hdr.[Buy-from Address] as BuyFromAddress,
	Hdr.[Buy-from City] as BuyFromCity,
	Hdr.[Buy-from County] as BuyFromState,
	Hdr.[Buy-from Post Code] as BuyFromZip,
	Hdr.[Buy-from Country Code] as BuyFromCountry,
	Hdr.[Buy-from Contact] as OrderContactName,
	Hdr.[Ship-to Name] as ShipToName,
	Hdr.[Ship-to Address] as ShipToAddress,
	Hdr.[Ship-to City] as ShipToCity,
	Hdr.[Ship-to County] as ShipToState,
	Hdr.[Ship-to Post Code] as ShipToZip,
	Hdr.[Ship-to Country Code] as ShipToCountry,
	Hdr.[Ship-to Contact] as ShipToContactName,
	'N' as TaxStatus,
	Hdr.[Buy-from Vendor No_] as POVendorNo,
	Hdr.[Location Code] as LocationCd,
	Hdr.[Payment Terms Code] as OrderTermsCd,
	Hdr.[Shipping Agent Code] as CarrierCd,
	Hdr.[Expected Receipt Date] as ScheduledReceiptDt,
	Hdr.[Ship-by Date] as ScheduledShipDt,
	Hdr.[Order Date] as OrderDt,
	Hdr.[Entered Date] as AllocationDt,
	Hdr.[Document Date] as POPrintDt,
	Hdr.[Purchaser Code] as Buyer,
	'N' as POCommentsInd,
	'N' as POExpenseInd,
	Hdr.[Entered User ID] as EntryID,
	Hdr.[Entered Date] as EntryDt,
	Hdr.[Status] as StatusCd,
--	Hdr.[Order Date] as AllocReleaseDt,
--	Hdr.[Entered User ID]  as AllocReleaseUserID,
	Hdr.[Requested Receipt Date] as RequestedReceiptDt,
	Hdr.[Promised Receipt Date] as PromiseDt,
	Hdr.[Shipment Method Code] as OrderFreightCd,
	Hdr.[Buy-from Vendor Name] as BuyFromName,
	Hdr.[Buy-from Address 2] as BuyFromAddress2,
	Hdr.[Order Date] as MakeOrderDt,
	Hdr.[Location Code] as ShipToVendorNo,
	Hdr.[Pay-to Vendor No_] as PayToVendorNo,
	Hdr.[Pay-to Name] as PayToName,
	Hdr.[Pay-to Address] as PayToAddress,
	Hdr.[Pay-to Address 2] as PayToAddress2,
	Hdr.[Pay-to City] as PayToCity,
	Hdr.[Pay-to County] as PayToState,
	Hdr.[Pay-to Post Code] as PayToZip,
	Hdr.[Pay-to Country Code] as PayToCountry,
	Hdr.[Buy-from Country Code] as CountryOfOrigin
FROM	[Porteous$Purchase Header] Hdr INNER JOIN
	[Porteous$Purchase Line] Line
ON	Hdr.[No_] = Line.[Document No_]
WHERE	--ROUND(Line.[Quantity],0,1) - ROUND(Line.[Quantity Received],0,1) > 0 AND
--	Line.[No_] <> '' AND Hdr.[Order Type] <> 0 AND
--	Hdr.[Document Type]=1 AND
--	Hdr.[Posting Date] > '01/01/2007' AND
--	(Line.Type = 1 OR Line.Type = 2)

--and 
Hdr.[No_] in
('17010435-1',
'18013030AD',
'27111631AD',
'28022607',
'30012601',
'32101702C3',
'49062305C3',
'49062306C3',
'49072404C3',
'49073102C3',
'49080301C3',
'49081001C3',
'49082601C3',
'49082702C3',
'49082801C3',
'49090302C3',
'49092802C3',
'49092803C3',
'49093001C3',
'49100202C3',
'VERBAL LIN')


order by Hdr.[No_] 
