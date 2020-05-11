
SELECT * FROM CustomerMaster where pCustMstrID not in
(SELECT fCustomerMasterID FROM CustomerAddress WHERE Type = 'DSHP')


select * from CustomerAddress where fCustomerMasterID not in
(SELECT fCustomerMasterID FROM CustomerAddress WHERE Type = '' OR Type = 'P')



select * from CustomerMaster
where CustNo in ('1', '01', '012345', '043750', '110000', '123546', '190000')

select * from CustomerAddress
where fCustomerMasterID in (select pCustMstrID from CustomerMaster where CustNo in ('1', '01', '012345', '043750', '110000', '123546', '190000'))


-------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------
--Bogus Customers: '1', '01', '012345', '043750', '110000', '123546', '190000'
-------------------------------------------------------------------------------

--These do not exist in PFCDB02.PFCFinance
select	*
from	OpenDataSource('SQLOLEDB','Data Source=PFCDB02;User ID=pfcnormal;Password=pfcnormal').PFCFinance.dbo.[Porteous$Customer]
where	No_ in ('1', '01', '012345', '043750', '110000', '123546', '190000')
go

--Less than 5 seconds against DEVPERP - (14 row(s) affected)
--DELETE corresponding CustomerAddress records
DELETE FROM CustomerAddress
WHERE	    fCustomerMasterID in (SELECT pCustMstrID FROM CustomerMaster WHERE CustNo in ('1', '01', '012345', '043750', '110000', '123546', '190000'))
go

--Less than 5 seconds against DEVPERP - (8 row(s) affected)
--DELETE CustomerMaster records
DELETE FROM	CustomerMaster
WHERE		CustNo in ('1', '01', '012345', '043750', '110000', '123546', '190000')
go


-------------------------------------------------------------------------------------------------------


--Create missing BLANK address record for CustNo 201602
SELECT	CASE CustMast.CustCd
	   WHEN 'ST' THEN 'P'
	             ELSE ''
	   END AS Type,
	CustMast.pCustMstrID AS fCustomerMasterID,
	CustUpd.[Name 2] AS Name2,
	CustUpd.[Address] AS AddrLine1,
	CustUpd.[Address 2] AS AddrLine2,
	CustUpd.[City] AS City,
	CustUpd.[County] AS State,
	CustUpd.[Post Code] AS PostCd,
	CustUpd.[Country_Region Code] AS Country,
	CustUpd.[Phone No_] AS PhoneNo,
	CustUpd.[Contact] AS CustContacts,
	CAST(CustUpd.[UPS Zone] AS Int) AS UPSZone,
	CustUpd.[Fax No_] AS FaxPhoneNo,
	CustUpd.[E-Mail] AS Email,
	'WO1631' AS EntryID,
	CAST(FLOOR(CAST(GetDate() AS FLOAT)) AS DATETIME) AS EntryDt,
--	CustUpd.[Last Modified By] AS ChangeID,
--	CustUpd.[Last Date Modified] AS ChangeDt,
	Loc.[Name 2] AS LocationName,
	CASE CustUpd.[Name]
	   WHEN '' THEN CustUpd.[Name 2]
		   ELSE CustUpd.[Name]
	END AS Name1
FROM	CustomerMaster CustMast INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Customer] CustUpd
ON	CustUpd.[No_] = CustMast.CustNo COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
	OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Location] Loc
ON	Loc.[Code] = CustUpd.[Location Code]
WHERE	CustUpd.[No_] = '201602'


-------------------------------------------------------------------------------------------------------

--Less than 5 seconds against DEVPERP - (1312 row(s) affected)
--Update all existing DSHP records to be equal to the corresponding ‘P’ or BLANK record.
UPDATE	CustomerAddress
SET	Name2 = UPD.Name2,
	AddrLine1 = UPD.AddrLine1,
	AddrLine2 = UPD.AddrLine2,
	AddrLine3 = UPD.AddrLine3,
	AddrLine4 = UPD.AddrLine4,
	AddrLine5 = UPD.AddrLine5,
	City = UPD.City,
	State = UPD.State,
	PostCd = UPD.PostCd,
	Country = UPD.Country,
	PhoneNo = UPD.PhoneNo,
	CustContacts = UPD.CustContacts,
	fCustContactsID = UPD.fCustContactsID,
	UPSZone = UPD.UPSZone,
	FaxPhoneNo = UPD.FaxPhoneNo,
	EDIPhoneNo = UPD.EDIPhoneNo,
	UPSShipperNo = UPD.UPSShipperNo,
	Email = UPD.Email,
	ChangeID = 'WO1631',
	ChangeDt = CAST(FLOOR(CAST(GetDate() AS FLOAT)) AS DATETIME),
	StatusCd = UPD.StatusCd,
	LocationName = UPD.LocationName,
	Name1 = UPD.Name1
FROM	CustomerAddress ADDR INNER JOIN
	(SELECT * FROM CustomerAddress WHERE Type = '' OR Type = 'P') UPD
ON	ADDR.fCustomerMasterID = UPD.fCustomerMasterID
WHERE	ADDR.Type = 'DSHP' AND
	(ADDR.Name2 <> UPD.Name2 OR 
	 ADDR.AddrLine1 <> UPD.AddrLine1 OR 
	 ADDR.AddrLine2 <> UPD.AddrLine2 OR 
	 ADDR.AddrLine3 <> UPD.AddrLine3 OR 
	 ADDR.AddrLine4 <> UPD.AddrLine4 OR 
	 ADDR.AddrLine5 <> UPD.AddrLine5 OR 
	 ADDR.City <> UPD.City OR 
	 ADDR.State <> UPD.State OR 
	 ADDR.PostCd <> UPD.PostCd OR 
	 ADDR.Country <> UPD.Country OR 
	 ADDR.PhoneNo <> UPD.PhoneNo OR 
	 ADDR.CustContacts <> UPD.CustContacts OR 
	 ADDR.fCustContactsID <> UPD.fCustContactsID OR 
	 ADDR.UPSZone <> UPD.UPSZone OR 
	 ADDR.FaxPhoneNo <> UPD.FaxPhoneNo OR 
	 ADDR.EDIPhoneNo <> UPD.EDIPhoneNo OR 
	 ADDR.UPSShipperNo <> UPD.UPSShipperNo OR 
	 ADDR.Email <> UPD.Email OR 
	 ADDR.StatusCd <> UPD.StatusCd OR 
	 ADDR.LocationName <> UPD.LocationName OR 
	 ADDR.Name1 <> UPD.Name1)


-------------------------------------------------------------------------------------------------------

--Less than 5 seconds against DEVPERP - (35 row(s) affected)
--Find any existing Customers that do not have a DSHP record and create one with the info from the ‘P’ or BLANK record
INSERT INTO	CustomerAddress
		(Type,
		 fCustomerMasterID,
		 Name2,
		 AddrLine1,
		 AddrLine2,
		 AddrLine3,
		 AddrLine4,
		 AddrLine5,
		 City,
		 State,
		 PostCd,
		 Country,
		 PhoneNo,
		 CustContacts,
		 fCustContactsID,
		 UPSZone,
		 FaxPhoneNo,
		 EDIPhoneNo,
		 UPSShipperNo,
		 Email,
		 EntryID,
		 EntryDt,
		 StatusCd,
		 LocationName,
		 Name1)
SELECT	--CUST.pCustMstrID, CUST.CustNo, ADDR.*
	'DSHP', fCustomerMasterID, Name2, AddrLine1, AddrLine2, AddrLine3, AddrLine4, AddrLine5, City, State, PostCd,
	Country, PhoneNo, CustContacts, fCustContactsID, UPSZone, FaxPhoneNo, EDIPhoneNo, UPSShipperNo, Email, 'WO1631',
	CAST(FLOOR(CAST(GetDate() AS FLOAT)) AS DATETIME), Cust.StatusCd, LocationName, Name1
FROM	CustomerMaster CUST INNER JOIN
	CustomerAddress ADDR
ON	CUST.pCustMstrID = ADDR.fCustomerMasterID
WHERE	(ADDR.Type = '' or ADDR.Type = 'P') AND
	pCustMstrID not in (SELECT fCustomerMasterID FROM CustomerAddress WHERE Type = 'DSHP')


-------------------------------------------------------------------------------------------------------




select * from CustomerAddress where EntryID='WO1631'
select * from CustomerAddress where ChangeID='WO1631'



exec sp_columns CustomerAddress




select EntryID, ChangeID, * from CustomerAddress
where fCustomerMasterID in
(8357,
8892,
9820,
11502,
11603,
11644,
11711,
11712,
11717,
11718,
11719,
11720,
11721,
11722,
11723,
11724,
11725,
11726,
11727,
11728,
11729,
11730,
11731,
11732,
11733,
11734,
11735,
11736,
11737,
11738,
11739,
11740,
11741,
11742,
11743)
order by fCustomerMasterID, Type






select * from CustomerMaster where CustNo='024042'
select * from CustomerAddress where fCustomerMasterID=1807 order by pCustomerAddressID






select * from CustomerMaster where pCustMstrID=11487
select * from CustomerAddress where fCustomerMasterID=11487 order by pCustomerAddressID





select * from CustomerMaster where DeleteDt is not null




select * from CustomerMaster where CustNo not in
(select	No_
from	OpenDataSource('SQLOLEDB','Data Source=PFCDB02;User ID=pfcnormal;Password=pfcnormal').PFCFinance.dbo.[Porteous$Customer])
