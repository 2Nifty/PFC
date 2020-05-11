if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1376_Daily_SO_EDI_To_ERP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1376_Daily_SO_EDI_To_ERP]
GO

DECLARE	@LastEDISONo VARCHAR(20),
	@LastEDISWNo VARCHAR(20)

--Get Last EDI SO Order Number from AppPref
SELECT	@LastEDISONo = AppOptionValue
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
WHERE	ApplicationCd='SOE' and AppOptionType='LastEDISONo'

--Get Last EDI SW Order Number from AppPref
SELECT	@LastEDISWNo = AppOptionValue
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
WHERE	ApplicationCd='SOE' and AppOptionType='LastEDISWNo'


--[Porteous$Sales Header] - EDI Orders
SELECT	DISTINCT
	NVHDR.[No_] as RefSONo,
	NVHDR.[Sell-to Customer No_] as SellToCustNo
INTO	tWO1376_Daily_SO_EDI_To_ERP
FROM	[Porteous$Sales Header] NVHDR WITH (NOLOCK) INNER JOIN
	[Porteous$Sales Line] NVLINE WITH (NOLOCK)
ON	NVHDR.[No_] = NVLINE.[Document No_]
WHERE	((LEFT(NVHDR.[No_],2) = 'SO' AND NVHDR.[No_] > @LastEDISONo) OR (LEFT(NVHDR.[No_],2) = 'SW' AND NVHDR.[No_] > @LastEDISWNo)) AND
	CASE WHEN NVLINE.[Quantity] > 0 AND NVLINE.[Quantity] < 1 THEN 1
	     ELSE ROUND(NVLINE.[Quantity],0,1)
	END > 0 AND --NVHDR.[Sell-to Customer No_]='063881' and
	NVLINE.[No_] <> '' AND NVHDR.[Sell-to Customer No_] <> '200301' AND NVHDR.[Sell-to Customer No_] <> '004401' AND
	EXISTS (SELECT	CustNo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.EDITradingPartner INNER JOIN
			OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster 
		ON	pCustMstrID = fCustomerMasterID
		WHERE	CustNo = NVHDR.[Sell-to Customer No_] COLLATE SQL_Latin1_General_CP1_CI_AS)

order by NVHDR.[No_]




--Find & UPDATE Last EDI SO Order Number that was processed
SELECT	@LastEDISONo = MAX(RefSONo)
FROM	tWO1376_Daily_SO_EDI_To_ERP
WHERE	LEFT(RefSONo,2) = 'SO'

IF (@LastEDISONo is not null)
	UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
	SET	AppOptionValue = @LastEDISONo, ChangeID=System_user, ChangeDt=GetDate()
	WHERE	ApplicationCd='SOE' and AppOptionType='LastEDISONo'


--Find & UPDATE Last EDI SW Order Number that was processed
SELECT	@LastEDISWNo = MAX(RefSONo)
FROM	tWO1376_Daily_SO_EDI_To_ERP
WHERE	LEFT(RefSONo,2) = 'SW'

IF (@LastEDISWNo is not null)
	UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
	SET	AppOptionValue = @LastEDISWNo, ChangeID=System_user, ChangeDt=GetDate()
	WHERE	ApplicationCd='SOE' and AppOptionType='LastEDISWNo'
