--Build Temp ERP Table for Customer Inserts
--Find Customer records that are in NV5 but not in PERP
--Uses OpenDataSource for PERP connection

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPCustInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPCustInsert
go

SELECT	*
INTO	tERPCustInsert
FROM	[Porteous$Customer] NV5 (NoLock)
WHERE	(NOT EXISTS	(SELECT	PERP.CustNo
--			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster PERP
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster PERP
			 WHERE	NV5.[No_] COLLATE Latin1_General_CS_AS = PERP.CustNo))
go
--Update tERPCustInsert
--Set [Inside Salesperson] = ''
--go


-------------------------------------------------------------------------------------

--Build Temp ERP Table for Customer Deletes
--Find Customer records that are in PERP but not in NV5
--Uses OpenDataSource for PERP connection

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPCustDelete') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPCustDelete
go


SELECT	*
INTO	tERPCustDelete
--	FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster PERP
	FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster PERP
WHERE	(NOT EXISTS	(SELECT	NV5.[No_]
			 FROM	[Porteous$Customer] NV5
			 WHERE	PERP.CustNo COLLATE Latin1_General_CS_AS = NV5.[No_]))
go

--------------------------------------------------------------------------------------

--Build Temp ERP Table for Customer Updates
--Find modified Customer records in NV5.0 based on [Last Modified Date] vs @LastDate from AppPref Table
--Uses OpenDataSource for AppPref table connection

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPCustUpdate') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPCustUpdate
go


Declare	@LastDate DATETIME
SET	@LastDate = (SELECT	AppOptionValue
--		     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
		     FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
		     WHERE	ApplicationCd = 'AR' AND AppOptionType = 'LastCustNV5.0CnvDt')

SELECT	*
INTO	[tERPCustUpdate]
FROM	[Porteous$Customer] NV5
WHERE	[Last Date Modified] >= CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))
go

-------------------------------------------------------------------------

--Add CustCd and fBillToNo columns to tERPCustInsert
IF EXISTS  (SELECT TABLE_NAME, COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME='tERPCustInsert' AND COLUMN_NAME = 'CustCd')
ALTER TABLE	tERPCustInsert
DROP COLUMN	CustCd, fBillToNo
GO

ALTER TABLE	tERPCustInsert
ADD		CustCd char(4) NULL, fBillToNo varchar(10) NULL
GO


--Set BT for [No_] that is assigned as [Bill-to Customer No_] on another account
UPDATE	tERPCustInsert
SET	CustCd='BT', fBillToNo=''
FROM	(SELECT [No_] AS Cust, [Bill-to Customer No_] AS BillTo
	 FROM [Porteous$Customer]) Cust
WHERE	[No_]=Cust.BillTo


--Set ST for [No_] <> [Bill-to Customer No_] and [Bill-to Customer No_] not blank
UPDATE	tERPCustInsert
SET	CustCd='ST', fBillToNo=[Bill-to Customer No_]
FROM	tERPCustInsert
WHERE	[No_]<>[Bill-to Customer No_] AND [Bill-to Customer No_]<>''


--Set BTST for all remaining unassigned records
UPDATE	tERPCustInsert
SET	CustCd='BTST', fBillToNo=[No_]
FROM	tERPCustInsert
WHERE	CustCd is NULL


--Set BTST for any BT that does not start with 1 
UPDATE	tERPCustInsert
SET	CustCd='BTST', fBillToNo=[No_]
FROM	tERPCustInsert
WHERE	CustCd='BT' AND LEFT([No_], 1) <> 1


--Add CustCd and fBillToNo columns to tERPCustUpdate
IF EXISTS  (SELECT TABLE_NAME, COLUMN_NAME
		FROM INFORMATION_SCHEMA.COLUMNS
		WHERE TABLE_NAME='tERPCustUpdate' AND COLUMN_NAME = 'CustCd')
ALTER TABLE	tERPCustUpdate
DROP COLUMN	CustCd, fBillToNo
GO

ALTER TABLE	tERPCustUpdate
ADD		CustCd char(4) NULL, fBillToNo varchar(10) NULL
GO


--Set BT for [No_] that is assigned as [Bill-to Customer No_] on another account
UPDATE	tERPCustUpdate
SET	CustCd='BT', fBillToNo=''
FROM	(SELECT [No_] AS Cust, [Bill-to Customer No_] AS BillTo
	 FROM [Porteous$Customer]) Cust
WHERE	[No_]=Cust.BillTo


--Set ST for [No_] <> [Bill-to Customer No_] and [Bill-to Customer No_] not blank
UPDATE	tERPCustUpdate
SET	CustCd='ST', fBillToNo=[Bill-to Customer No_]
FROM	tERPCustUpdate
WHERE	[No_]<>[Bill-to Customer No_] AND [Bill-to Customer No_]<>''


--Set BTST for all remaining unassigned records
UPDATE	tERPCustUpdate
SET	CustCd='BTST', fBillToNo=[No_]
FROM	tERPCustUpdate
WHERE	CustCd is NULL


--Set BTST for any BT that does not start with 1 
UPDATE	tERPCustUpdate
SET	CustCd='BTST', fBillToNo=[No_]
FROM	tERPCustUpdate
WHERE	CustCd='BT' AND LEFT([No_], 1) <> 1


--------------------------------------------------------------------------------------------

--Set CustomerMaster.DeleteDt and CustomerMaster.CreditInd for Customer Deletes
UPDATE	[CustomerMaster]
SET	DeleteDt = GetDate(), CreditInd = 'X'
FROM	[CustomerMaster]
WHERE	(EXISTS	(SELECT	*
		 FROM	OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[tERPCustDelete] CustDel
		 WHERE	CustDel.[No_] = [CustomerMaster].[CustNo] COLLATE Latin1_General_CS_AS))


--Set DeleteDt
-- CSR 07/05/2012 - Per Sonia, remove check for Invioce and Payment when setting DeleteDt
UPDATE	[CustomerMaster]
SET	DeleteDt = GetDate(), CreditInd = 'X'
WHERE	isnull(DeleteDt,'') = '' AND
	CustNo IN (SELECT DISTINCT [Customer No_]
		   FROM	  OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Customer Soft Block]
		   WHERE  [Quote] = 1 AND [Blanket Order] = 1 AND [Order] = 1 AND
			  [Return] = 1 AND [Credit Memo] = 1 AND [Shipment] = 1)
GO

--Clear DeleteDt
UPDATE	[CustomerMaster]
SET	DeleteDt = null
WHERE	CustNo IN (SELECT DISTINCT [CustNo]
		   FROM	  [CustomerMaster] INNER JOIN
			  OpenDataSource('SQLOLEDB','Data Source=pfcdb02;User ID=pfcnormal;Password=pfcnormal').PFCFINANCE.dbo.[Porteous$Customer Soft Block]
		   ON	  [CustNo] = [Customer No_]
		   WHERE  isnull(DeleteDt,'') <> '' AND
			  ([Quote] <> 1 OR [Blanket Order] <> 1 OR [Order] <> 1 OR
			   [Return] <> 1 OR [Credit Memo] <> 1 OR [Shipment] <> 1))







------------------------------------------------------------------
------------------------------------------------------------------

--do this at the end

--Set [Last Update] and UPDATE AppPref Table
Declare	@LastUpdate DATETIME
SET	@LastUpdate = (SELECT GETDATE())
--SELECT @LastUpdate

UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
SET	AppOptionValue = @LastUpdate, ChangeID=System_user, ChangeDt=GetDate()
WHERE	ApplicationCd = 'AR' AND AppOptionType = 'LastCustNV5.0CnvDt'


UPDATE	[Porteous$Customer]
SET	[Last Update] = @LastUpdate
WHERE	(EXISTS	(SELECT	*
		 FROM	[tERPCustUpdate]
		 WHERE	[tERPCustUpdate].[No_] = [Porteous$Customer].[No_]))
