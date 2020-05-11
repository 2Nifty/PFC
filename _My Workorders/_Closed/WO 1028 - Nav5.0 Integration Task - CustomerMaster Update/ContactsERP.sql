select count(*) from CustomerMaster

select CustomerAddress.* from 
CustomerMaster inner join
CustomerAddress on pCustMstrID=fCustomerMasterID
where type='P' or type=''



UPDATE	

Select * from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.CustomerContacts

select CustomerAddress.* from 
CustomerMaster inner join
CustomerAddress on pCustMstrID=fCustomerMasterID
where type='P' or type=''




select * from CustomerMaster where CustNo='042895'

select * from CustomerAddress where fCustomerMasterID='4341'


exec sp_columns CustomerContact




select * from tCustomerContact where fCustAddrID is null

update tCustomerContact
set fCustAddrID=null



UPDATE	tCustomerContact
SET	fCustAddrID = Addie.pCustomerAddressID
--select	Cust.pCustMstrID, Cust.CustNo, Cust.CustName, Addie.pCustomeraddressID, Addie.Type, Addie.fCustomerMasterID, Addie.Name1, Contact.*
FROM	tCustomerContact Contact INNER JOIN
	CustomerMaster Cust ON Contact.CustNo = Cust.CustNo INNER JOIN
	CustomerAddress Addie ON Cust.pCustMstrID = Addie.fCustomerMasterID
Where	Addie.Type = 'P' or Addie.Type = ''





-------------------------------------------------------------------------------------------

--Update CustomerContact: Set fCustAddrID = null
UPDATE	CustomerContact
SET	fCustAddrID = null

--Update CustomerContact: Set fCustAddrID = pCustomerAddressID WHERE Contact.CustNo = Cust.CustNo
UPDATE	CustomerContact
SET	fCustAddrID = Addie.pCustomerAddressID
FROM	CustomerContact Contact INNER JOIN
	CustomerMaster Cust ON Contact.CustNo = Cust.CustNo INNER JOIN
	CustomerAddress Addie ON Cust.pCustMstrID = Addie.fCustomerMasterID
Where	Addie.Type = 'P' or Addie.Type = ''


Select	*
FROM	tCustomerContact
WHERE	fCustAddrID IS NULL


-------------------------------------------------------------------------


select	Addie.pCustomerAddressID, Addie.fCustomerMasterID, Addie.fCustContactsID, Upd.UpdContactID AS NEW_fCustContactsID,
	Upd.UpdContactID AS pCustContactsID, Upd.UpdAddrID ASfCustAddrID


--Update CustomerAddress: SET fCustContactsID = pCustContactsID
UPDATE	CustomerAddress
SET	fCustContactsID = Upd.pCustContactsID
FROM	CustomerAddress Addie INNER JOIN
	(SELECT	fCustAddrID, MIN(pCustContactsID) AS pCustContactsID FROM CustomerContact GROUP BY fCustAddrID) Upd
ON	Addie.pCustomerAddressID = Upd.fCustAddrID



order by Upd.UpdAddrID, Upd.UpdContactID




--tCustomerContact
SELECT [pCustContactsID]
      ,[fCustAddrID]
  FROM [PERP].[dbo].[tCustomerContact]

where fCustAddrID IS NOT NULL
order by fCustAddrID, pCustContactsID


--CustomerAddress
SELECT [pCustomerAddressID]
      ,[fCustContactsID]
  FROM [PERP].[dbo].[CustomerAddress]
Where fCustContactsID IS NOT NULL





(SELECT	fCustAddrID AS UpdAddrID, MIN(pCustContactsID) AS UpdContactID FROM tCustomerContact GROUP BY [fCustAddrID]) Upd
