declare	@customer varchar(50)
Declare @strSql  nvarchar(4000)

set @customer = 'agco%'
--
--select @strSql ='SELECT a.CustNo,a.CustName,a.CreditInd,a.CustShipLocation + '' - '' + c.LocName as CustShipLocation,b.pCustomerAddressID,b.AddrLine1,b.City,b.State,b.PostCd,b.Country, b.Email from LocMaster c RIGHT OUTER JOIN 
--				CustomerMaster a (NOLOCK) ON c.LocID = a.CustShipLocation LEFT OUTER JOIN CustomerAddress b (NOLOCK) ON a.pCustMstrID = b.fCustomerMasterID
--				where (a.custname like '''+ @customer + ''' or a.custNo like ''' + @customer + ''') and b.Type<>''DSHP'' and b.Type<>''SHP'''
--print @strSql
--EXEC sp_executesql @strSql     



SELECT	Cust.CustNo
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
FROM	LocMaster Loc (NoLock) RIGHT OUTER JOIN
		CustomerMaster Cust (NoLock)
ON		Loc.LocID = Cust.CustShipLocation LEFT OUTER JOIN
		CustomerAddress Addr (NoLock)
ON		Cust.pCustMstrID = Addr.fCustomerMasterID
WHERE	Addr.[Type] <> 'DSHP' and Addr.[Type] <> 'SHP' and
		(Cust.custname like @customer or Cust.custNo like @customer)



--SELECT	distinct EDIStoreNo
--FROM	EDICustCrossReference EDI
--
--
--SELECT	*
--FROM	EDICustCrossReference EDI
--WHERE	EDI.EDIStoreNo like @customer