USE [PERP]
GO
/****** Object:  StoredProcedure [dbo].[pSOEGetCustSel]    Script Date: 02/24/2012 17:42:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[pSOEGetCustSel]
	@customer varchar(50)
AS
BEGIN

-- ==============================================
-- Proc:	[pSOEGetCustSel]
-- Author:	Sathya
-- Created:	2008-Oct-10
-- Desc:	To Generate SOE Customer Select
-- ============================================================================================
-- Mod:	01/09/2012 TMD:	Commented out original DYNAMIC SQL code
--						Re-created original query without dynamic SQL
--						Added new statement to query EDIStoreNo field in EDICustCrossReference table
--						Created UNION between the Customer query and the EDI Store query
-- ============================================================================================
--
-- exec [pSOEGetCustSel] 'agco%'
--
-- ============================================================================================

--Original DYNAMIC SQL code
/**
	Declare @strSql  nvarchar(4000)
	select @strSql ='SELECT a.CustNo,a.CustName,a.CreditInd,a.CustShipLocation + '' - '' + c.LocName as CustShipLocation,b.pCustomerAddressID,b.AddrLine1,b.City,b.State,b.PostCd,b.Country, b.Email from LocMaster c RIGHT OUTER JOIN 
					CustomerMaster a (NOLOCK) ON c.LocID = a.CustShipLocation LEFT OUTER JOIN CustomerAddress b (NOLOCK) ON a.pCustMstrID = b.fCustomerMasterID
					where (a.custname like '''+ @customer + ''' or a.custNo like ''' + @customer + ''') and b.Type<>''DSHP'' and b.Type<>''SHP'''
	print @strSql
	EXEC sp_executesql @strSql   
**/
  
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
					(Cust.CustName like @customer or Cust.CustNo like @customer)) tCust
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
     
END
