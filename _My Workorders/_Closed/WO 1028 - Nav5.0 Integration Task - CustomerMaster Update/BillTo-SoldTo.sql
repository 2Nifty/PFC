--exec sp_columns CustomerAddress



--UPDATE tERPCustInsert [Bill-to Customer No_]
update tERPCustInsert
set [Bill-to Customer No_]='Bill To'
from (select [No_] AS Cust, [Bill-to Customer No_] AS BillTo from tERPCustInsert) Cust
where [No_]=Cust.BillTo

update tERPCustInsert
set [Bill-to Customer No_]=[No_]
where [Bill-to Customer No_]=''

update tERPCustInsert
set [Bill-to Customer No_]=''
where [Bill-to Customer No_]='Bill To'


--UPDATE tERPCustUpdate [Bill-to Customer No_]
update tERPCustUpdate
set [Bill-to Customer No_]='Bill To'
from (select [No_] AS Cust, [Bill-to Customer No_] AS BillTo from tERPCustUpdate) Cust
where [No_]=Cust.BillTo

update tERPCustUpdate
set [Bill-to Customer No_]=[No_]
where [Bill-to Customer No_]=''

update tERPCustUpdate
set [Bill-to Customer No_]=''
where [Bill-to Customer No_]='Bill To'






select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tERPCustInsert




--UPDATE CustCd and GLPostCD for Customer Inserts--
---------------------------------------------------

--Sold To only
UPDATE	CustomerMaster
SET	CustCd ='ST'
FROM	CustomerMaster INNER JOIN
	PFCLive.dbo.[tERPCustInsert] CustUpd ON
	CustUpd.[No_] = CustomerMaster.CustNo COLLATE Latin1_General_CS_AS
WHERE	CustNo <> fBillToNo AND fBillToNo <> ''

--Bill To/Sold To
UPDATE	CustomerMaster
SET	CustCd ='BTST'
FROM	CustomerMaster INNER JOIN
	PFCLive.dbo.[tERPCustInsert] CustUpd ON
	CustUpd.[No_] = CustomerMaster.CustNo COLLATE Latin1_General_CS_AS
WHERE	CustNo <> fBillToNo AND fBillToNo = ''

--Bill To Only
UPDATE	CustomerMaster
SET	CustCd ='BT'
FROM	CustomerMaster INNER JOIN
	PFCLive.dbo.[tERPCustInsert] CustUpd ON
	CustUpd.[No_] = CustomerMaster.CustNo COLLATE Latin1_General_CS_AS
WHERE	CustNo = fBillToNo 

--Hard Code GLPostCd = '3010'
UPDATE	CustomerMaster
SET	GLPostCd = '3010'
FROM	CustomerMaster INNER JOIN
	PFCLive.dbo.[tERPCustInsert] CustUpd ON
	CustUpd.[No_] = CustomerMaster.CustNo COLLATE Latin1_General_CS_AS




SELECT	CustMast.CustCd, CustMast.pCustMstrID,
CustUpd.[Name],
CustUpd.[Name 2],
CustUpd.[Address],
CustUpd.[Address 2],
CustUpd.[City],
CustUpd.[County],
CustUpd.[Post Code],
CustUpd.[Country_Region Code],
CustUpd.[Phone No_],
CustUpd.[Contact],
CustUpd.[UPS Zone],
CustUpd.[Fax No_],
CustUpd.[E-Mail],
CustUpd.[Last Modified By],
CustUpd.[Account Opened],
CustUpd.[Last Modified By],
CustUpd.[Last Date Modified],
Loc.[Name 2]
FROM	CustomerMaster CustMast INNER JOIN
	PFCLive.dbo.[tERPCustInsert] CustUpd ON
	CustUpd.[No_] = CustMast.CustNo COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
	PFCLive.dbo.[Porteous 5_0$Location] Loc ON
	Loc.[Code] = CustUpd.[Location Code]




SELECT	CASE CustMast.CustCd
	   WHEN 'ST' THEN 'P'
	             ELSE ''
	   END AS Type,
	CustMast.pCustMstrID AS fCustomerMasterID, CustUpd.[Name 2] AS Name2, CustUpd.[Address] AS AddrLine1,
	CustUpd.[Address 2] AS AddrLine2, CustUpd.[City], CustUpd.[County] AS State, CustUpd.[Post Code] AS PostCd,
	CustUpd.[Country_Region Code] AS Country, CustUpd.[Phone No_] AS PhoneNo, CustUpd.[Contact] AS CustContacts,
	CAST(CustUpd.[UPS Zone] AS Int) AS UPSZone, CustUpd.[Fax No_] AS FaxPhoneNo, CustUpd.[E-Mail] AS Email,
	CustUpd.[Last Modified By] AS EntryID, CustUpd.[Account Opened] AS EntryDt, CustUpd.[Last Modified By] AS ChangeID,
	CustUpd.[Last Date Modified] AS ChangeDt, Loc.[Name 2] AS LocationName, CustUpd.[Name] AS Name1
FROM	CustomerMaster CustMast INNER JOIN
	PFCLive.dbo.[tERPCustInsert] CustUpd ON
	CustUpd.[No_] = CustMast.CustNo COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
	PFCLive.dbo.[Porteous 5_0$Location] Loc ON
	Loc.[Code] = CustUpd.[Location Code]




-----------------------------------------------------------------------------------------------------------------------


--UPDATE CustCd and GLPostCD for Customer Updates--
-------------------------------------------------------------------------------------------

--Sold To only
UPDATE	CustomerMaster
SET	CustCd ='ST'
FROM	CustomerMaster INNER JOIN
	PFCLive.dbo.[tERPCustUpdate] CustUpd ON
	CustUpd.[No_] = CustomerMaster.CustNo COLLATE Latin1_General_CS_AS
WHERE	CustNo <> fBillToNo AND fBillToNo <> ''

--Bill To/Sold To
UPDATE	CustomerMaster
SET	CustCd ='BTST'
FROM	CustomerMaster INNER JOIN
	PFCLive.dbo.[tERPCustUpdate] CustUpd ON
	CustUpd.[No_] = CustomerMaster.CustNo COLLATE Latin1_General_CS_AS
WHERE	CustNo <> fBillToNo AND fBillToNo = ''

--Bill To Only
UPDATE	CustomerMaster
SET	CustCd ='BT'
FROM	CustomerMaster INNER JOIN
	PFCLive.dbo.[tERPCustUpdate] CustUpd ON
	CustUpd.[No_] = CustomerMaster.CustNo COLLATE Latin1_General_CS_AS
WHERE	CustNo = fBillToNo 

--Hard Code GLPostCd = '3010'
UPDATE	CustomerMaster
SET	GLPostCd = '3010'
FROM	CustomerMaster INNER JOIN
	PFCLive.dbo.[tERPCustUpdate] CustUpd ON
	CustUpd.[No_] = CustomerMaster.CustNo COLLATE Latin1_General_CS_AS


--Update Bill To & Sold To records in ERP [CustomerAddress] for Customer Updates
UPDATE	CustomerAddress
SET	Type = CASE CustMast.CustCd
		WHEN 'ST' THEN 'P'
		          ELSE ''
		END,
	--fCustomerMasterID = CustMast.pCustMstrID,
	Name2 = CustUpd.[Name 2],
	AddrLine1 = CustUpd.[Address],
	AddrLine2 = CustUpd.[Address 2],
	City = CustUpd.[City],
	State = CustUpd.[County],
	PostCd = CustUpd.[Post Code],
	Country = CustUpd.[Country_Region Code],
	PhoneNo = CustUpd.[Phone No_],
	CustContacts = CustUpd.[Contact],
	UPSZone = CAST(CustUpd.[UPS Zone] AS Int),
	FaxPhoneNo = CustUpd.[Fax No_],
	Email = CustUpd.[E-Mail],
	EntryID = CustUpd.[Last Modified By],
	EntryDt = CustUpd.[Account Opened],
	ChangeID = CustUpd.[Last Modified By],
	ChangeDt = CustUpd.[Last Date Modified],
	LocationName = Loc.[Name 2],
	Name1 = CustUpd.[Name]
FROM	CustomerAddress CustAddr INNER JOIN
	CustomerMaster CustMast ON
	CustAddr.fCustomerMasterID = CustMast.pCustMstrID INNER JOIN
	PFCLive.dbo.[tERPCustUpdate] CustUpd ON
	CustUpd.[No_] = CustMast.CustNo COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
	PFCLive.dbo.[Porteous 5_0$Location] Loc ON
	Loc.[Code] = CustUpd.[Location Code]









select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tERPCustUpdate

select * from CustomerMaster where CustNo='024470'

select * from Customeraddress where fCustomerMasterID = '1846'