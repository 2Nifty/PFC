--select * from ItemMaster where ItemNo='99907-6005-699'


select CustCd, fbillToNo, * from CustomerMaster where CustNo='201696' or CustNo='100455' or fbillToNo='100455'--or CustNo='062651'

select * from CustomerAddress where fCustomerMasterID=11682 or fCustomerMasterID=11684




update CustomerMaster
set fbillToNo='100455', CustCd='ST'
where CustNo='201696'



select * from CustomerAddress where fCustomerMasterID=5863



select CustCd, fbillToNo,* from CustomerMaster where CustCd='BT' and CustNo='100000'


select CustCd, fbillToNo,* from CustomerMaster where fBillToNo='100000'



exec [pSOECustomerDetails] '201696'


DECLARE @custNo varchar(20)
DECLARE @CustCd VARCHAR(20)
DECLARE @fBillTo VARCHAR(20)
DECLARE @customerID VARCHAR(20)

set @custNo='201696'

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




Update CustomerAddress
set Type='P'
where pCustomerAddressID=2479576

