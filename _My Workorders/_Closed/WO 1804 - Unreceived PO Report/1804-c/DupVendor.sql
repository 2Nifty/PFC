
--SELECT * FROM VendorAddress (NoLock) where VendorNoNV='1002642'


--exec sp_columns VendorAddress
--exec sp_columns VendorContact


--40 duplicate records in the VendorAddress table
SELECT	DupCount.*
FROM	(SELECT count(*) as RecCount, 
		 --pVendAddrID,fBuyFromAddrID,fVendContactID,
		 fVendMstrID,VendorNoNV,Code,AlphaSearch,VendorType,Type,
		 LocationCd,LocationName,Name2,Line1,Line2,Line3,Line4,Line5,
		 City,State,PostCd,Country,PhoneNo,UPSZone,FAXPhoneNo,EDIPhoneNo,
		 UPSShipperNo,Email,WebPageAddr,TaxAreaCd,TaxLiableInd,CountryCd,
		 HoursCapacity,UnitsCapacity,DollarCapacity,RebateCd,LeadTimeCalc,
		 LandedCostCd,BrokerAgentCd,BaseCalendarCd,PriceIncludesVATind,
		 VATRegNo,VATBusPostingGrp,ShipVia,ShipMeth,FOB,CreditLimit,BuyerCd,
		 TransitDays,LimitCd,TypeOfOrder,MtlBdFactor,LbrBdFactor,
		 MtlEscalationFactor,LbrEscalationFactor,LandingFactor,NoStdCostFactor,
		 TransitTimeCalc,PTOverride,TransLoc,ProdType,Name1
	 FROM	 VendorAddress (NoLock)
	 GROUP BY
		 --pVendAddrID,fBuyFromAddrID,fVendContactID,
		 fVendMstrID,VendorNoNV,Code,AlphaSearch,VendorType,Type,
		 LocationCd,LocationName,Name2,Line1,Line2,Line3,Line4,Line5,
		 City,State,PostCd,Country,PhoneNo,UPSZone,FAXPhoneNo,EDIPhoneNo,
		 UPSShipperNo,Email,WebPageAddr,TaxAreaCd,TaxLiableInd,CountryCd,
		 HoursCapacity,UnitsCapacity,DollarCapacity,RebateCd,LeadTimeCalc,
		 LandedCostCd,BrokerAgentCd,BaseCalendarCd,PriceIncludesVATind,
		 VATRegNo,VATBusPostingGrp,ShipVia,ShipMeth,FOB,CreditLimit,BuyerCd,
		 TransitDays,LimitCd,TypeOfOrder,MtlBdFactor,LbrBdFactor,
		 MtlEscalationFactor,LbrEscalationFactor,LandingFactor,NoStdCostFactor,
		 TransitTimeCalc,PTOverride,TransLoc,ProdType,Name1) DupCount
WHERE	DupCount.RecCount > 1




--Since each of the duplicates points to a unique VendorContact,
--this causes us to have duplicate VendorContact records.
SELECT	Address.fVendMstrID,Address.VendorNoNV,Address.Code,Address.AlphaSearch,
	Address.VendorType,Address.Type,Address.fVendContactID,
	Contact.*
FROM	VendorAddress Address INNER JOIN
	VendorContact Contact
ON	Address.fVendContactID = Contact.pVendContactID
WHERE	EXISTS
	(SELECT fVendContactID
		 --fVendMstrID,VendorNoNV,Code,AlphaSearch,VendorType,Type,
		 --fBuyFromAddrID,fVendContactID
	 FROM	VendorAddress VA
	 WHERE	EXISTS
		(SELECT fVendMstrID
		 FROM	(SELECT count(*) as RecCount, 
				 --pVendAddrID,fBuyFromAddrID,fVendContactID,
				 fVendMstrID,VendorNoNV
			 FROM	 VendorAddress (NoLock)
			 GROUP BY
				 --pVendAddrID,fBuyFromAddrID,fVendContactID,
				 fVendMstrID,VendorNoNV) DupCount
		 WHERE	DupCount.RecCount > 1 and
			DupCount.fVendMstrID=VA.fVendMstrID and
			DupCount.VendorNoNV=VA.VendorNoNV and
			VA.fVendContactID=Contact.pVendContactID))
ORDER BY Address.fVendMstrID,Address.VendorNoNV

