declare	@customer varchar(50)


set @customer = 'agco%'
  
SELECT	*
FROM	(SELECT	Cust.CustNo
				,Cust.CustName
				,Cust.CreditInd
				,Cust.CustShipLocation + ' - ' + Loc.LocName as CustShipLocation
				,Addr.pCustomerAddressID
				,Addr.AddrLine1
				,Addr.City
				,Addr.State
				,Addr.PostCd
				,Addr.Country
				,Addr.Email
				,'' as EDIStoreNo
				,'' as EDITradingPartnerNo
		 FROM	LocMaster Loc (NoLock) RIGHT OUTER JOIN
				CustomerMaster Cust (NoLock)
		 ON		Loc.LocID = Cust.CustShipLocation LEFT OUTER JOIN
				CustomerAddress Addr (NoLock)
		 ON		Cust.pCustMstrID = Addr.fCustomerMasterID
		 WHERE	Addr.[Type] <> 'DSHP' and Addr.[Type] <> 'SHP' and
				(Cust.CustName like @customer or Cust.CustNo like @customer)) CustomerMaster
UNION	(SELECT	Cust.CustNo
				,Cust.CustName
				,Cust.CreditInd
				,Cust.CustShipLocation + ' - ' + Loc.LocName as CustShipLocation
				,Addr.pCustomerAddressID
				,Addr.AddrLine1
				,Addr.City
				,Addr.State
				,Addr.PostCd
				,Addr.Country
				,Addr.Email
				,isnull(EDI.EDIStoreNo,'') as EDIStoreNo
				,isnull(EDI.EDITradingPartnerNo,'') as EDITradingPartnerNo
		 FROM	LocMaster Loc (NoLock) RIGHT OUTER JOIN
				CustomerMaster Cust (NoLock)
		 ON		Loc.LocID = Cust.CustShipLocation LEFT OUTER JOIN
				CustomerAddress Addr (NoLock)
		 ON		Cust.pCustMstrID = Addr.fCustomerMasterID LEFT OUTER JOIN
				EDICustCrossReference EDI (NoLock)
		 ON		Cust.CustNo = EDI.PFCSellToCustNo
		 WHERE	Addr.[Type] <> 'DSHP' and Addr.[Type] <> 'SHP' and EDI.EDIStoreNo like @customer)
ORDER BY CustNo



--SELECT	distinct EDIStoreNo
--FROM	EDICustCrossReference EDI
--
--
--SELECT	*
--FROM	EDICustCrossReference EDI
--WHERE	EDI.EDIStoreNo like @customer