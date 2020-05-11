
select * from

OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Item Cross Reference]





UPDATE [Porteous$Customer]
SET [Name 2]='Tod Test'



update CustomerMaster
set AltCustName=''

select * from CustomerMaster
where AltCustName='Tod Test'




UPDATE	CustomerMaster
SET	CustName=Left(Name,40),			--String or Binary data would be truncated (VARCHAR 40 vs VARCHAR 50)
	AltCustName=[Name 2],
	SortName=LEFT([Search Name],40),	--String or Binary data would be truncated (VARCHAR 40 vs VARCHAR 50)
	CustSearchKey=No_,
	IMLoc=[Shipping Location],
--	BillToID=[Bill-to Customer No_],	--error converting VARCHAR to Binary (Numeric 5(9,0) vs VARCHAR 20)
--	ShipToID=[Default Ship-To Code],	--error converting VARCHAR to Binary (Numeric 5(9,0) vs VARCHAR 10)
	CustType=Left([Customer Type],4),	--String or Binary data would be truncated (VARCHAR 4 vs VARCHAR 10)
	Territory=[Territory Code],
	SlsRepNo=[Salesperson Code],
--	SupportRepNo=[Inside Salesperson],	--Syntax error converting the varchar value data type int. (Int 4 vs VARCHAR 10)
	ResaleNo=[Tax Exemption No_],
	InvCopies=[Invoice Copies],
	InvSortOrd=[Invoice Detail Sort],
	CreditLmt=[Credit Limit (LCY)],
	EntryDt=[Account Opened],
	EntryID=[Last Modified By], 
	ChangeDt=[Last Date Modified],
	ChangeID=[Last Modified By]
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[tERPCustUpdate]
INNER	JOIN CustomerMaster ON No_ = CustNo


select * from OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[ERPCustUpdate]
select * from CustomerMaster






where [Last Date Modified] > Getdate()-365 and
    (not EXISTS
                          (SELECT     *
                            FROM          PFCReports..CustomerMaster
                            WHERE      PFCReports..CustomerMaster.CustNo COLLATE Latin1_General_CS_AS = [Porteous$Customer].No_))



select * from tERPCustInsert
select * from tERPCustUpdate






--Build Temp ERP Table for Customer Inserts

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].ERPCustInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table ERPCustInsert

SELECT	*
INTO	[ERPCustInsert]
FROM	Porteous$Customer
WHERE	[Last Date Modified] > Getdate()-365 and
	(NOT EXISTS (SELECT	*
		     FROM	PFCReports..CustomerMaster
		     WHERE	PFCReports..CustomerMaster.CustNo COLLATE Latin1_General_CS_AS = [Porteous$Customer].No_))



--Build Temp ERP Table for Customer Updates

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].ERPCustUpdate') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table ERPCustUpdate

SELECT	*
INTO	[ERPCustUpdate]
FROM	Porteous$Customer
WHERE	[Last Date Modified] > Getdate()-365 and
	(EXISTS (SELECT	*
		     FROM	PFCReports..CustomerMaster
		     WHERE	PFCReports..CustomerMaster.CustNo COLLATE Latin1_General_CS_AS = [Porteous$Customer].No_))




select * from CustomerMaster
Where Custno='100355' or Custno='100356'



select * from [Porteous$Customer]
where [Last Date Modified] > Getdate()-365


CREATE TRIGGER [CustINS] ON [dbo].[Porteous$Customer] 
FOR INSERT 
AS

INSERT INTO [dbo].[ERPCustUpd]
