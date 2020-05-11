select EntryDt, CustCd, CustShipLocation, * from CustomerMaster where CustNo='201739'

select Type, * from CustomerAddress where fCustomerMasterID=11760





SELECT	'DSHP' AS Type,
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
	CustUpd.[Last Modified By] AS EntryID,
	CustUpd.[Account Opened] AS EntryDt,
	CustUpd.[Last Modified By] AS ChangeID,
	CustUpd.[Last Date Modified] AS ChangeDt,
	Loc.LocName AS LocationName,
	CASE CustUpd.[Name]
	   WHEN '' THEN CustUpd.[Name 2]
		   ELSE CustUpd.[Name]
	END AS Name1
FROM	CustomerMaster CustMast INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tTodTestCustIns] CustUpd
ON	CustUpd.[No_] = CustMast.CustNo COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
	LocMaster Loc
ON	Loc.LocID = CustUpd.[Location Code]
--	OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Location] Loc
--ON	Loc.[Code] = CustUpd.[Location Code]




select EntryDt as Entry, ChangeDt as Change, * from CustomerMaster where pCustMstrID not in
(select fCustomerMasterID from CustomerAddress where Type='DSHP')
order by CustNo

-----------------------------------------------------------------------------------------

--check deletes
select EntryDt, * from CustomerMaster where CustNo in
('1', '01', '012345', '043750', '110000', '123546', '190000' )

select * from CustomerAddress where fCustomerMasterID in
(11502,
11643,
11603,
8357,
8892,
11644,
9820)


--------------------------------------------------------------------------------------

--check 201602
select EntryDt, CustCd, CustShipLocation, * from CustomerMaster where CustNo='201602'

select Type, * from CustomerAddress where fCustomerMasterID=11487


--------------------------------------------------------------------------------------

--check DSHP records synched to P/BLANK
select ChangeDt as Change, ChangeID, * from CustomerAddress where Type='DSHP' and ChangeID='WO1631' order by ChangeDt


--------------------------------------------------------------------------------------

--check new DSHP records added
select  EntryDt as Entry, EntryID, * from CustomerAddress where Type='DSHP' and EntryID='WO1631' order by EntryDt


--------------------------------------------------------------------------------------

select * from CustomerAddress where ChangeID='WO1631'



select EntryDt as Entry, EntryID, ChangeDt as Change, ChangeId, * from CustomerAddress 
where ChangeID='ADDR_FIX' --and Type='DSHP'
order by ChangeDt







select *
into	tCustomerMaster
from	CustomerMaster


select *
into	tCustomerAddress
from	CustomerAddress