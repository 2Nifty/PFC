--Build Temp ERP Table for Customer Inserts
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPCustInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPCustInsert

--Find records that are in NV5.0 but not in NV3.7
SELECT	*
INTO	tERPCustInsert
FROM	[Porteous 5_0$Customer] [Cust5.0]
WHERE	(NOT EXISTS	(SELECT	*
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.Porteous$Customer [Cust3.7]
			 WHERE	[Cust3.7].[No_] COLLATE Latin1_General_CS_AS = [Cust5.0].[No_]))



---------------------------------------------------------------------------------------
--Build Temp ERP Table for Customer Deletes
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPCustDelete') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPCustDelete

--Find records that are in NV3.7 but not in NV5.0
SELECT	*
INTO	tERPCustDelete
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.Porteous$Customer [Cust3.7]
WHERE	(NOT EXISTS	(SELECT	*
			 FROM	[Porteous 5_0$Customer] [Cust5.0]
			 WHERE	[Cust3.7].[No_] COLLATE Latin1_General_CS_AS = [Cust5.0].[No_]))
--select * from tERPCustDelete


---------------------------------------------------------------------------------------
--Get Customer Updates--
------------------------
--SET @LastDate from AppPref Table
Declare	@LastDate DATETIME
SET	@LastDate = (SELECT	AppOptionValue
		     FROM	PERP.dbo.AppPref
		     WHERE	ApplicationCd = 'AR' AND AppOptionType = 'LastCustNV5.0CnvDt')
--SELECT @LastDate


--Build Temp ERP Table for Customer Updates
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPCustUpdate') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPCustUpdate

--Find modified records in NV5.0 based on [Last Modified Date]
SELECT	*
INTO	[tERPCustUpdate]
FROM	[Porteous 5_0$Customer] [Cust5.0]
WHERE	[Last Date Modified] >= CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2)) AND
	[Last Update] <> @LastDate
--SELECT * FROM tERPCustUpdate


--Set [Last Update] and UPDATE AppPref Table
Declare	@LastUpdate DATETIME
SET	@LastUpdate = (SELECT GETDATE())
--SELECT @LastUpdate

UPDATE	PERP.dbo.AppPref
SET	AppOptionValue = @LastUpdate
WHERE	ApplicationCd = 'AR' AND AppOptionType = 'LastCustNV5.0CnvDt'

--SELECT * 
--FROM	[Porteous 5_0$Customer]
--WHERE	(EXISTS	(SELECT	*
--		 FROM	[tERPCustUpdate]
--		 WHERE	[tERPCustUpdate].[No_] = [Porteous 5_0$Customer].[No_]))

UPDATE	[Porteous 5_0$Customer]
SET	[Last Update] = @LastUpdate
WHERE	(EXISTS	(SELECT	*
		 FROM	[tERPCustUpdate]
		 WHERE	[tERPCustUpdate].[No_] = [Porteous 5_0$Customer].[No_]))


---------------------------------------------------------------------------------------

--USE 3.7 Connection--
--Remove Customer Deletes from NV3.7 [Porteous$Customer]
DELETE
FROM	[Porteous$Customer]
WHERE	(EXISTS	(SELECT	*
		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[tERPCustDelete] CustDel
		 WHERE	CustDel.[No_] = [Porteous$Customer].[No_] COLLATE Latin1_General_CS_AS))



--USE ERP Connection--
--Remove Customer Deletes from ERP [CustomerMaster]
DELETE
FROM	[CustomerMaster]
WHERE	(EXISTS	(SELECT	*
		 FROM	PFCLive.dbo.[tERPCustDelete] CustDel
		 WHERE	CustDel.[No_] = [CustomerMaster].[CustNo] COLLATE Latin1_General_CS_AS))


---------------------------------------------------------------------------------------

--USE 3.7 Connection--
--Process Customer Updates in NV3.7 [Porteous$Customer]
UPDATE	[Porteous$Customer]
SET	--[timestamp] = CustUpd.[timestamp],
	--[No_] = CustUpd.[No_],
	[Name] = CustUpd.[Name],
	[Search Name] = CustUpd.[Search Name],
	[Name 2] = CustUpd.[Name 2],
	[Address] = CustUpd.[Address],
	[Address 2] = CustUpd.[Address 2],
	[City] = CustUpd.[City],
	[Contact] = CustUpd.[Contact],
	[Phone No_] = CustUpd.[Phone No_],
	[Telex No_] = CustUpd.[Telex No_],
	[Our Account No_] = CustUpd.[Our Account No_],
	[Territory Code] = CustUpd.[Territory Code],
	[Global Dimension 1 Code] = CustUpd.[Global Dimension 1 Code],
	[Global Dimension 2 Code] = CustUpd.[Global Dimension 2 Code],
	[Chain Name] = CustUpd.[Chain Name],
	[Budgeted Amount] = CustUpd.[Budgeted Amount],
	[Credit Limit (LCY)] = CustUpd.[Credit Limit (LCY)],
	[Customer Posting Group] = CustUpd.[Customer Posting Group],
	[Currency Code] = CustUpd.[Currency Code],
	[Customer Price Group] = CustUpd.[Customer Price Group],
	[Language Code] = CustUpd.[Language Code],
	[Statistics Group] = CustUpd.[Statistics Group],
	[Payment Terms Code] = CustUpd.[Payment Terms Code],
	[Fin_ Charge Terms Code] = CustUpd.[Fin_ Charge Terms Code],
	[Salesperson Code] = CustUpd.[Salesperson Code],
	[Shipment Method Code] = CustUpd.[Shipment Method Code],
	[Shipping Agent Code] = CustUpd.[Shipping Agent Code],
	[Place of Export] = CustUpd.[Place of Export],
	[Invoice Disc_ Code] = CustUpd.[Invoice Disc_ Code],
	[Customer Disc_ Group] = CustUpd.[Customer Disc_ Group],
	[Country Code] = CustUpd.[Country_Region Code],
	[Collection Method] = CustUpd.[Collection Method],
	[Amount] = CustUpd.[Amount],
	[Blocked] = CustUpd.[Blocked],
	[Invoice Copies] = CustUpd.[Invoice Copies],
	[Last Statement No_] = CustUpd.[Last Statement No_],
	[Print Statements] = CustUpd.[Print Statements],
	[Bill-to Customer No_] = CustUpd.[Bill-to Customer No_],
	[Priority] = CustUpd.[Priority],
	[Payment Method Code] = CustUpd.[Payment Method Code],
	[Last Date Modified] = CustUpd.[Last Date Modified],
	[Application Method] = CustUpd.[Application Method],
	[Prices Including VAT] = CustUpd.[Prices Including VAT],
	[Location Code] = CustUpd.[Location Code],
	[Fax No_] = CustUpd.[Fax No_],
	[Telex Answer Back] = CustUpd.[Telex Answer Back],
	[VAT Registration No_] = CustUpd.[VAT Registration No_],
	[Combine Shipments] = CustUpd.[Combine Shipments],
	[Gen_ Bus_ Posting Group] = CustUpd.[Gen_ Bus_ Posting Group],
	[Picture] = CustUpd.[Picture],
	[Post Code] = CustUpd.[Post Code],
	[County] = CustUpd.[County],
	[E-Mail] = CustUpd.[E-Mail],
	[Home Page] = CustUpd.[Home Page],
	[Reminder Terms Code] = CustUpd.[Reminder Terms Code],
	[No_ Series] = CustUpd.[No_ Series],
	[Tax Area Code] = CustUpd.[Tax Area Code],
	[Tax Liable] = CustUpd.[Tax Liable],
	[VAT Bus_ Posting Group] = CustUpd.[VAT Bus_ Posting Group],
	[Reserve] = CustUpd.[Reserve],
	[Block Payment Tolerance] = CustUpd.[Block Payment Tolerance],
	[Primary Contact No_] = CustUpd.[Primary Contact No_],
	[Responsibility Center] = CustUpd.[Responsibility Center],
	[Shipping Advice] = CustUpd.[Shipping Advice],
	[Shipping Time] = CustUpd.[Shipping Time],
	[Shipping Agent Service Code] = CustUpd.[Shipping Agent Service Code],
	[Service Zone Code] = CustUpd.[Service Zone Code],
	[Allow Line Disc_] = CustUpd.[Allow Line Disc_],
	[Base Calendar Code] = CustUpd.[Base Calendar Code],
	[UPS Zone] = CustUpd.[UPS Zone],
	[Tax Exemption No_] = CustUpd.[Tax Exemption No_],
	[Bank Communication] = CustUpd.[Bank Communication],
	[Inside Salesperson] = CustUpd.[Inside Salesperson],
	[Document Delivery] = CustUpd.[Document Delivery],
	[Account Opened] = CustUpd.[Account Opened],
	[Usage Location] = CustUpd.[Usage Location],
	[Last Modified By] = CustUpd.[Last Modified By],
	[Customer Type] = CustUpd.[Customer Type],
	[Shipping Location] = CustUpd.[Shipping Location] --,
	--[] = CustUpd.[IC Partner Code],
	--[] = CustUpd.[Prepayment %],
	--[] = CustUpd.[Copy Sell-to Addr_ to Qte From],
	--[] = CustUpd.[Check Date Format],
	--[] = CustUpd.[Check Date Separator],
	--[] = CustUpd.[Components on Sales Orders],
	--[] = CustUpd.[Components on Shipments],
	--[] = CustUpd.[Components on Invoices],
	--[Notification Process Code] = CustUpd.[],
	--[Queue Priority] = CustUpd.[],
	--[FQA Required] = CustUpd.[],
	--[Cert Required] = CustUpd.[],
	--[Rebate Group] = CustUpd.[],
	--[Backorder] = CustUpd.[],
	--[Delivery Route] = CustUpd.[],
	--[Delivery Stop] = CustUpd.[],
	--[EDI Invoice] = CustUpd.[],
	--[E-Ship Agent Service] = CustUpd.[],
	--[Free Freight] = CustUpd.[],
	--[Residential Delivery] = CustUpd.[],
	--[IRS EIN Number] = CustUpd.[],
	--[Blind Shipment] = CustUpd.[],
	--[Double Blind Shipment] = CustUpd.[],
	--[Double Blind Ship-from Cust No] = CustUpd.[],
	--[No Free Freight Lines on Order] = CustUpd.[],
	--[Shipping Payment Type] = CustUpd.[],
	--[Shipping Insurance] = CustUpd.[],
	--[External No_] = CustUpd.[],
	--[Default Ship-for Code] = CustUpd.[],
	--[Packing Rule Code] = CustUpd.[],
	--[E-Mail Rule Code] = CustUpd.[],
	--[E-Mail Cust_ Stat_ Send Date] = CustUpd.[],
	--[Use E-Mail Rule for ShipToAddr] = CustUpd.[],
	--[Review Days] = CustUpd.[],
	--[Call Days] = CustUpd.[],
	--[Hold Days] = CustUpd.[],
	--[Default Ship-To Code] = CustUpd.[],
	--[Purchase Order Required] = CustUpd.[],
	--[Credit Update] = CustUpd.[],
	--[Broker_Agent Code] = CustUpd.[],
	--[Tool Repair Priority] = CustUpd.[],
	--[Tool Repair Tech] = CustUpd.[],
	--[Invoice Detail Sort] = CustUpd.[],
	--[Customer Price Code] = CustUpd.[]
FROM	[Porteous$Customer] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[tERPCustUpdate] CustUpd ON
	CustUpd.[No_] = [Porteous$Customer].[No_] COLLATE Latin1_General_CS_AS



--USE ERP Connection--
--Process Customer Updates in ERP [CustomerMaster]
UPDATE	CustomerMaster
SET	CustName=Left(Name,40),				--String or Binary data would be truncated (VARCHAR 40 vs VARCHAR 50)
	AltCustName=[Name 2],
	SortName=LEFT([Search Name],40),		--String or Binary data would be truncated (VARCHAR 40 vs VARCHAR 50)
	CustSearchKey=No_,
	ShipLocation=[Shipping Location],
	fBillToNo=[Bill-to Customer No_],
--	ShipToNo=[Default Ship-To Code],
--	SoldToNo=[No_],
	CustType=Left([Customer Type],4),		--String or Binary data would be truncated (VARCHAR 4 vs VARCHAR 10)
	Territory=[Territory Code],
	SlsRepNo=[Salesperson Code],
	SupportRepNo=[Inside Salesperson],
	ResaleNo=[Tax Exemption No_],
	InvCopies=[Invoice Copies],
----	InvSortOrd=[Invoice Detail Sort],		--[Invoice Detail Sort] does not exist in NV5.0
	CreditLmt=[Credit Limit (LCY)],
	EntryDt=[Account Opened],
	EntryID=[Last Modified By], 
	ChangeDt=[Last Date Modified],
	ChangeID=[Last Modified By],
	TaxStat=[Tax Liable],
	TaxCd=[Tax Area Code],
	PriorityCd=Priority,
	ShipMethCd=LEFT([Shipment Method Code],4),	--String or Binary data would be truncated (CHAR 4 vs VARCHAR 10)
	ShipViaCd=LEFT([Shipping Agent Code],4),	--String or Binary data would be truncated (CHAR 4 vs VARCHAR 10)
	FirstActivityDt=[Account Opened],
----	CreditRvwDt=[Credit Update],			--[Credit Update] does not exist in NV5.0
----	ABCCd=[Customer Price Code],			--[Customer Price Code] does not exist in NV5.0
	ChainCd=ChainCd
FROM	CustomerMaster INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[tERPCustUpdate] CustUpd ON
	CustUpd.[No_] = CustomerMaster.CustNo COLLATE Latin1_General_CS_AS


---------------------------------------------------------------------------------------

--Build Temp ERP Table for Customer Soft Block Inserts
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPCustSoftBlockInsert') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPCustSoftBlockInsert

--Find records that are in NV5.0 but not in NV3.7
SELECT	*
INTO	tERPCustSoftBlockInsert
FROM	[Porteous 5_0$Customer Soft Block] [Cust5.0]
WHERE	(NOT EXISTS	(SELECT	*
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Customer Soft Block] [Cust3.7]
			 WHERE	[Cust3.7].[Customer No_] COLLATE Latin1_General_CS_AS = [Cust5.0].[Customer No_]))


select * from tERPCustSoftBlockInsert



----Execute against ERP
UPDATE	CustomerMaster
SET	CreditInd = 'X'
FROM	CustomerMaster INNER JOIN
	PFCLive.dbo.[tERPCustSoftBlockInsert] CustUpd ON
	CustUpd.[Customer No_] = CustomerMaster.CustNo COLLATE Latin1_General_CS_AS
WHERE	[Order] = 1 AND [Quote] = 1 AND [Blanket Order] = 1 AND [Shipment] = 1

UPDATE	CustomerMaster
SET	CreditInd = 'A'
FROM	CustomerMaster INNER JOIN
	PFCLive.dbo.[tERPCustSoftBlockInsert] CustUpd ON
	CustUpd.[Customer No_] = CustomerMaster.CustNo COLLATE Latin1_General_CS_AS
WHERE	[Order] <> 1 OR [Quote] <> 1 OR [Blanket Order] <> 1 OR [Shipment] <> 1



SELECT	CreditInd, CustomerMaster.*
FROM	CustomerMaster INNER JOIN
	PFCLive.dbo.[tERPCustSoftBlockInsert] CustUpd ON
	CustUpd.[Customer No_] = CustomerMaster.CustNo COLLATE Latin1_General_CS_AS



---------------------------------------------------------------------------------------

--Build Temp ERP Table for Customer Deletes
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPCustSoftBlockDelete') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPCustSoftBlockDelete

--Find records that are in NV3.7 but not in NV5.0
SELECT	*
INTO	tERPCustSoftBlockDelete
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Customer Soft Block] [Cust3.7]
WHERE	(NOT EXISTS	(SELECT	*
			 FROM	[Porteous 5_0$Customer Soft Block] [Cust5.0]
			 WHERE	[Cust3.7].[Customer No_] COLLATE Latin1_General_CS_AS = [Cust5.0].[Customer No_]))


select * from tERPCustSoftBlockDelete

----Execute against NV3.7
--Remove Soft Block Deletes from NV3.7 [Porteous$Customer Soft Block]
DELETE
FROM	[Porteous$Customer Soft Block]
WHERE	(EXISTS	(SELECT	*
		 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[tERPCustSoftBlockDelete] CustDel
		 WHERE	CustDel.[Customer No_] = [Porteous$Customer Soft Block].[Customer No_] COLLATE Latin1_General_CS_AS))



--Update CustomerMaster.CreditInd = 'A' for Soft Block Deletes
--select CreditInd, *
UPDATE	[CustomerMaster]
SET	CreditInd = 'A'
FROM	[CustomerMaster]
WHERE	(EXISTS	(SELECT	*
		 FROM	PFCLive.dbo.[tERPCustSoftBlockDelete] CustDel
		 WHERE	CustDel.[Customer No_] = [CustomerMaster].[CustNo] COLLATE Latin1_General_CS_AS))





---------------------------------------------------------------------------------------

--Build Temp ERP Table for Customer Updates
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].tERPCustSoftBlockUpdate') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table tERPCustSoftBlockUpdate

--Find modified records in NV5.0
SELECT	*
INTO	tERPCustSoftBlockUpdate
FROM	[Porteous 5_0$Customer Soft Block] [Cust5.0]
WHERE	(EXISTS		(SELECT	*
			 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCTnT.dbo.[Porteous$Customer Soft Block] [Cust3.7]
			 WHERE	[Cust3.7].[Customer No_] COLLATE Latin1_General_CS_AS = [Cust5.0].[Customer No_] AND 
				([Cust3.7].[Ship-to Address Code] COLLATE Latin1_General_CS_AS <> [Cust5.0].[Ship-to Address Code] OR
				[Cust3.7].[Order] <> [Cust5.0].[Order] OR
				[Cust3.7].[Quote] <> [Cust5.0].[Quote] OR
				[Cust3.7].[Blanket Order] <> [Cust5.0].[Blanket Order] OR
				[Cust3.7].[Invoice] <> [Cust5.0].[Invoice] OR
				[Cust3.7].[Return] <> [Cust5.0].[Return] OR
				[Cust3.7].[Credit Memo] <> [Cust5.0].[Credit Memo] OR
				[Cust3.7].[Shipment] <> [Cust5.0].[Shipment] OR
				[Cust3.7].[Payment] <> [Cust5.0].[Payment])))


--Process Soft Block Updates in NV3.7 [Porteous$Customer Soft Block]
UPDATE	[Porteous$Customer Soft Block]
SET	--[timestamp] = CustUpd.[timestamp],
	[Customer No_] = CustUpd.[Customer No_],
	[Ship-to Address Code] = CustUpd.[Ship-to Address Code],
	[Order] = CustUpd.[Order],
	[Quote] = CustUpd.[Quote],
	[Blanket Order] = CustUpd.[Blanket Order],
	[Invoice] = CustUpd.[Invoice],
	[Return] = CustUpd.[Return],
	[Credit Memo] = CustUpd.[Credit Memo],
	[Shipment] = CustUpd.[Shipment],
	[Payment] = CustUpd.[Payment]
FROM	[Porteous$Customer Soft Block] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[tERPCustSoftBlockUpdate] CustUpd ON
	CustUpd.[Customer No_] = [Porteous$Customer Soft Block].[Customer No_] COLLATE Latin1_General_CS_AS




--Customer Suspended No orders allowed
UPDATE	CustomerMaster
SET	CreditInd = 'X'
FROM	CustomerMaster INNER JOIN
	PFCLive.dbo.[tERPCustSoftBlockUpdate] CustUpd ON
	CustUpd.[Customer No_] = CustomerMaster.CustNo COLLATE Latin1_General_CS_AS
WHERE	[Order] = 1 AND [Quote] = 1 AND [Blanket Order] = 1 AND [Shipment] = 1

--All orders automatically approved
UPDATE	CustomerMaster
SET	CreditInd = 'A'
FROM	CustomerMaster INNER JOIN
	PFCLive.dbo.[tERPCustSoftBlockUpdate] CustUpd ON
	CustUpd.[Customer No_] = CustomerMaster.CustNo COLLATE Latin1_General_CS_AS
WHERE	[Order] <> 1 OR [Quote] <> 1 OR [Blanket Order] <> 1 OR [Shipment] <> 1





select * from tERPCustSoftBlockUpdate


---------------------------------------------------------------------------------------


--SELECT	*
--FROM	Porteous$Customer [Cust5.0]
--FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.Porteous$Customer [Cust3.7]
	

select * from tERPCustDelete






SELECT	[No_] AS CustNo, 
	[Name] AS CustName, 
	[Name 2] AS AltCustName, 
	[Search Name] AS SortName, 
	[No_] AS CustSearchKey,
	[Shipping Location] AS ShipLocation, 
	[Bill-to Customer No_] AS fBillToNo,
--	[Default Ship-To Code] AS ShipToNo,
--	[No_] AS SoldToNo,
	[Customer Type] AS CustType,
	[Territory Code] AS Territory,
	[Salesperson Code] AS SlsRepNo,
	[Inside Salesperson] AS SupportRepNo,
	[Tax Exemption No_] AS ResaleNo,
	[Tax Liable] AS TaxStat,
	[Invoice Copies] AS InvCopies,
	[Invoice Detail Sort] AS InvSortOrd,
	[Tax Area Code] AS TaxCd,
	[Priority] AS PriorityCd,
	[Shipment Method Code] AS ShipMethCd,
	[Shipping Agent Code] AS ShipViaCd,
	[Credit Limit (LCY)] AS CreditLmt,
	[Account Opened] AS FirstActivityDt,
	[Credit Update] AS CreditRvwDt,
	[Account Opened] AS EntryDt,
	[Last Modified By] AS EntryID,
	[Last Date Modified] AS ChangeDt,
	[Last Modified By] AS ChangeID,
	[Customer Price Code] AS ABCCd,
	[Chain Name]
FROM	tERPCustInsert


exec sp_columns [Porteous 5_0$Customer]

