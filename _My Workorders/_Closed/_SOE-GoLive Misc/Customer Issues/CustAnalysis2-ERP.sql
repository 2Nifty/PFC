select CustCd, fBillToNo, * from CustomerMaster where CustNo='201523' or fBillToNo=201523
select Type as Ty, Name1, Name2, AddrLine1, AddrLine2, City, State, PostCd, Country, * from CustomerAddress where fCustomerMasterID=11357
Order by Type


select CustCd, fBillToNo, * from CustomerMaster where fBillToNo=201523




select CustCd, fBillToNo, * from CustomerMaster where CustNo='031171'
select Type as Ty, Name1, Name2, AddrLine1, AddrLine2, City, State, PostCd, Country, * from CustomerAddress where fCustomerMasterID=2338
Order by Type



select * from tERPCustUpdate

exec [pSOECustomerDetails] '201697'

select ChangeDt, CustCd, fBillToNo, * from CustomerMaster where CustNo='201697' or CustNo='201696' --or CustNo='100455'
select Type as Ty, Name1, Name2, AddrLine1, AddrLine2, City, State, PostCd, Country, * from CustomerAddress where fCustomerMasterID=11682 or fCustomerMasterID=11683 or fCustomerMasterID=11684
Order by Type


DECLARE @custNo varchar(20)
DECLARE @CustCd VARCHAR(20)
DECLARE @fBillTo VARCHAR(20)
DECLARE @customerID VARCHAR(20)

set @custNo='201697'

Select  @customerID=pCustMstrID, @fBillTo=fbilltoNo, @CustCd =CustCd from CustomerMaster where  CustNo = @custNo

SELECT     dbo.CustomerMaster.CreditInd, dbo.CustomerMaster.CustCd, dbo.CustomerMaster.ExpediteCd, dbo.CustomerMaster.ReasonCd, 
                      dbo.CustomerMaster.fBillToNo, dbo.CustomerMaster.CustCd AS CustCode, dbo.CustomerMaster.CustName AS Name, 
                      dbo.CustomerMaster.CustNo AS No_, dbo.CustomerMaster.UsageLocation AS [Usage Location], dbo.CustomerMaster.PriorityCd AS Priority, 
                      dbo.CustomerMaster.ShipTermsCd AS [Freight Code], dbo.CustomerMaster.ShipMethCd AS [Shipment Method Code], 
                      dbo.CustomerMaster.CustShipLocation AS [Shipping Location], dbo.CustomerMaster.PriceCd AS [Customer Price Code], 
                      dbo.CustomerMaster.TypeofOrder, dbo.CustomerMaster.TaxCd AS [Tax Area Code], dbo.CustomerMaster.ChainCd AS [Chain Name], 
                      dbo.CustomerMaster.ShipViaCd AS [Shipping Agent Code], '' AS [Free Freight], '' AS [Country Code], RepMaster.RepName, 
                      RepMaster.RepNo AS [Salesperson Code], dbo.CustomerMaster.TradeTermCd, SupportRepMaster.RepNo AS SupportRepNo, 
                      SupportRepMaster.RepName AS SupportRepName, 'P' as SODocSortInd, dbo.CustomerMaster.ShipLocation as CustLocation
FROM         dbo.CustomerMaster (NOLOCK) LEFT OUTER JOIN
                      dbo.RepMaster AS SupportRepMaster (NOLOCK) ON dbo.CustomerMaster.SupportRepNo = SupportRepMaster.RepNo LEFT OUTER JOIN
                      dbo.RepMaster AS RepMaster (NOLOCK) ON dbo.CustomerMaster.SlsRepNo = RepMaster.RepNo
WHERE     (dbo.CustomerMaster.CustNo = @custNo)

--Sold to address
IF @CustCd = 'ST'
BEGIN
Select 'ST IF', Name2 as 'Name',CustomerAddress.State,CustomerAddress.Country,CustomerAddress.AddrLine1 AS Address,CustomerAddress.AddrLine2 AS [Address 2], 
		CustomerAddress.City,CustomerAddress.PhoneNo AS [Phone No_], dbo.CustomerAddress.FaxPhoneNo AS [Fax No_], 
		dbo.CustomerAddress.Email AS [E-Mail],CustomerAddress.PostCd AS [Post Code],CustomerContact.Name as 'Contact',CustomerContact.pCustContactsID as 'ContactID',CustomerContact.[JobTitle] as CJobTitle,CustomerContact.[Phone] as CPhone,CustomerContact.[PhoneExt] as CPhoneExt,CustomerContact.[FaxNo] as CFaxNo,CustomerContact.[MobilePhone] as CMobilePhone,CustomerContact.[EmailAddr] as CEmailAddr,CustomerContact.[Department] as Department   
		from CustomerAddress (NOLOCK) left outer JOIN CustomerContact (NOLOCK) on CustomerAddress.fCustContactsID =CustomerContact.pCustContactsID
		where  fCustomerMasterID=@customerID and CustomerAddress.Type='P'	
END
ELSE
	Select 'ST ELSE', Name2 as 'Name',CustomerAddress.State,CustomerAddress.Country,CustomerAddress.AddrLine1 AS Address,CustomerAddress.AddrLine2 AS [Address 2], 
		CustomerAddress.City,CustomerAddress.PhoneNo AS [Phone No_], dbo.CustomerAddress.FaxPhoneNo AS [Fax No_], 
		dbo.CustomerAddress.Email AS [E-Mail],CustomerAddress.PostCd AS [Post Code],CustomerContact.Name as 'Contact',CustomerContact.pCustContactsID as 'ContactID',CustomerContact.[JobTitle] as CJobTitle,CustomerContact.[Phone] as CPhone,CustomerContact.[PhoneExt] as CPhoneExt,CustomerContact.[FaxNo] as CFaxNo,CustomerContact.[MobilePhone] as CMobilePhone,CustomerContact.[EmailAddr] as CEmailAddr,CustomerContact.[Department] as Department   from CustomerAddress (NOLOCK) left outer JOIN CustomerContact (NOLOCK) on CustomerAddress.fCustContactsID =CustomerContact.pCustContactsID
		where  fCustomerMasterID=@customerID and CustomerAddress.Type=''

--Bill to address
Select 'BillTo', CustomerMaster.CreditInd as CreditInd,CustomerMaster.CustNo as 'CustNo',CustomerMaster.CustName as 'Name',CustomerAddress.State,CustomerAddress.Country,CustomerAddress.AddrLine1 AS Address,CustomerAddress.AddrLine2 AS [Address 2], 
       CustomerAddress.City,CustomerAddress.PhoneNo AS [Phone No_], dbo.CustomerAddress.FaxPhoneNo AS [Fax No_], 
       dbo.CustomerAddress.Email AS [E-Mail],CustomerAddress.PostCd AS [Post Code],CustomerContact.Name as 'Contact',CustomerContact.pCustContactsID as 'ContactID',CustomerContact.[JobTitle] as CJobTitle,CustomerContact.[Phone] as CPhone,CustomerContact.[PhoneExt] as CPhoneExt,CustomerContact.[FaxNo] as CFaxNo,CustomerContact.[MobilePhone] as CMobilePhone,CustomerContact.[EmailAddr] as CEmailAddr,CustomerContact.[Department] as Department
	from CustomerMaster (NOLOCK) left outer JOIN CustomerAddress (NOLOCK) on CustomerAddress.fCustomerMasterID=CustomerMaster.pCustMstrID left outer JOIN CustomerContact on CustomerAddress.fCustContactsID =CustomerContact.pCustContactsID
	where CustomerMaster.CustNo= +@fBillTo and (Type='') 

--Ship to address
Select 'Ship To', Name1 as 'Name',CustomerAddress.State,CustomerAddress.Country,CustomerAddress.AddrLine1 AS Address,CustomerAddress.AddrLine2 AS [Address 2], 
       CustomerAddress.City,CustomerAddress.PhoneNo AS [Phone No_], dbo.CustomerAddress.FaxPhoneNo AS [Fax No_], 
       dbo.CustomerAddress.Email AS [E-Mail],CustomerAddress.PostCd AS [Post Code],CustomerContact.Name as 'Contact',CustomerContact.pCustContactsID as 'ContactID',CustomerContact.[JobTitle] as CJobTitle,CustomerContact.[Phone] as CPhone,CustomerContact.[PhoneExt] as CPhoneExt,CustomerContact.[FaxNo] as CFaxNo,CustomerContact.[MobilePhone] as CMobilePhone,CustomerContact.[EmailAddr] as CEmailAddr,CustomerContact.[Department] as Department from CustomerMaster (NOLOCK) left outer JOIN CustomerAddress (NOLOCK) on CustomerAddress.fCustomerMasterID=CustomerMaster.pCustMstrID  left outer JOIN  CustomerContact (NOLOCK) on CustomerAddress.fCustContactsID =CustomerContact.pCustContactsID where  CustomerMaster.CustNo= +@custNo and (Type='DSHP') 











select CustNo,CustName,[pCustomerAddressID],[Type],[fCustomerMasterID],[Name1],[Name2],[AddrLine1],[AddrLine2],[AddrLine3],[AddrLine4],[AddrLine5],[City],[State],[PostCd],[Country],[PhoneNo],[CustContacts],[fCustContactsID],[UPSZone],[FaxPhoneNo],[EDIPhoneNo],[UPSShipperNo],[Email],CustomerAddress.[EntryID],CustomerAddress.[EntryDt],CustomerAddress.[ChangeID],CustomerAddress.[ChangeDt],CustomerAddress.[StatusCd],[LocationName]
from CustomerAddress, CustomerMaster
where (Type='P') And fCustomerMasterID in 
(select pCustMstrID from customerMaster where (fbilltoNo=201523 And CustCd='ST') or (fbilltoNo ='201523' and custno='201523' And CustCd='BTST'))



select * from CustomerMaster where CustNo='000001'
select * from CustomerAddress where fCustomerMasterID=1