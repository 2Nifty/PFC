USE [PERP]
GO
/****** Object:  StoredProcedure [dbo].[pSOEGetCustSel]    Script Date: 01/25/2012 11:29:58 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- ==================================================================================================
-- Procedure	:	[pSOEGetCustSel]
-- ----------------------------------------------------------------------------------------------------
-- Date					Developer  		         Action          Purpose
-- ----------------------------------------------------------------------------------------------------
--- 10/October/2008     Sathya                   Added           To Generate SOE Customer Select
-- ==================================================================================================== 
CREATE PROCEDURE [dbo].[pSOEGetCustSel]
	@customer varchar(50)
AS
BEGIN
Declare @strSql  nvarchar(4000)

select @strSql ='SELECT a.CustNo,a.CustName,a.CreditInd,a.CustShipLocation + '' - '' + c.LocName as CustShipLocation,b.pCustomerAddressID,b.AddrLine1,b.City,b.State,b.PostCd,b.Country, b.Email from LocMaster c RIGHT OUTER JOIN 
				CustomerMaster a (NOLOCK) ON c.LocID = a.CustShipLocation LEFT OUTER JOIN CustomerAddress b (NOLOCK) ON a.pCustMstrID = b.fCustomerMasterID
				where (a.custname like '''+ @customer + ''' or a.custNo like ''' + @customer + ''') and b.Type<>''DSHP'' and b.Type<>''SHP'''
print @strSql
EXEC sp_executesql @strSql        
END
