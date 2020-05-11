if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO1376_Daily_SO_EDI_To_ERP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO1376_Daily_SO_EDI_To_ERP]
GO

DECLARE	@LastEDISONo VARCHAR(20),
	@LastEDISWNo VARCHAR(20)

--Get Last EDI SO Order Number from AppPref
SELECT	@LastEDISONo = AppOptionValue
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
WHERE	ApplicationCd='SOE' and AppOptionType='LastEDISONo'

--Get Last EDI SW Order Number from AppPref
SELECT	@LastEDISWNo = AppOptionValue
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
WHERE	ApplicationCd='SOE' and AppOptionType='LastEDISWNo'

select @LastEDISONo
select @LastEDISWNo

--[Porteous$Sales Header] - EDI Orders
SELECT	DISTINCT
	NVHDR.[No_] as RefSONo, NVHDR.[External Document No_], NVHDR.[Sell-to Customer No_], NVHDR.[Sell-to Customer Name]
INTO	tWO1376_Daily_SO_EDI_To_ERP
FROM	[Porteous$Sales Header] NVHDR WITH (NOLOCK) INNER JOIN
	[Porteous$Sales Line] NVLINE WITH (NOLOCK)
ON	NVHDR.[No_] = NVLINE.[Document No_] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item
ON	NVLINE.[No_] = Item.ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemBranch ItemBr
ON	Item.pItemMasterID = ItemBr.fItemMasterID
WHERE	((LEFT(NVHDR.[No_],2) = 'SO' AND NVHDR.[No_] > @LastEDISONo) OR (LEFT(NVHDR.[No_],2) = 'SW' AND NVHDR.[No_] > @LastEDISWNo)) AND
	ROUND(NVLINE.[Quantity],0,1) > 0 AND NVLINE.[No_] <> '' AND --NVHDR.[Document Type] = 0  AND
	NVHDR.[Shipping Location] = ItemBr.Location COLLATE SQL_Latin1_General_CP1_CI_AS AND
	EXISTS (SELECT	CustNo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.EDITradingPartner INNER JOIN
			OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster 
		ON	pCustMstrID = fCustomerMasterID
		WHERE	CustNo = NVHDR.[Sell-to Customer No_] COLLATE SQL_Latin1_General_CP1_CI_AS)


--Find & UPDATE Last EDI SO Order Number that was processed
SELECT	@LastEDISONo = MAX(RefSONo)
FROM	tWO1376_Daily_SO_EDI_To_ERP
WHERE	LEFT(RefSONo,2) = 'SO'

IF (@LastEDISONo is not null)
	UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
	SET	AppOptionValue = @LastEDISONo, ChangeID=System_user, ChangeDt=GetDate()
	WHERE	ApplicationCd='SOE' and AppOptionType='LastEDISONo'


--Find & UPDATE Last EDI SW Order Number that was processed
SELECT	@LastEDISWNo = MAX(RefSONo)
FROM	tWO1376_Daily_SO_EDI_To_ERP
WHERE	LEFT(RefSONo,2) = 'SW'

IF (@LastEDISWNo is not null)
	UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
	SET	AppOptionValue = @LastEDISWNo, ChangeID=System_user, ChangeDt=GetDate()
	WHERE	ApplicationCd='SOE' and AppOptionType='LastEDISWNo'



---------------------------------------------------------------------------------------

select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.EDITradingPartner

delete from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.EDITradingPartner
where fCustomerMasterID=1

select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster 
where pCustMstrID=1 or pCustMstrID=10138 or pCustMstrID=8516



select MAX (No_)
from [Porteous$Sales Header]
WHERE	LEFT(No_,2) = 'SO'


select MAX(RefSONo) from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeader
WHERE	LEFT(RefSONo,2) = 'SO'

select MAX(No_) from [Porteous$Sales Header]
WHERE	LEFT(No_,2) = 'SW'

select MAX(RefSONo) from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeader
WHERE	LEFT(RefSONo,2) = 'SW'

select * from tWO1376_Daily_SO_EDI_To_ERP order by RefSONo



UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
SET	AppOptionValue = 'SO3107756', ChangeID=System_user, ChangeDt=GetDate()
WHERE	ApplicationCd='SOE' and AppOptionType='LastEDISONo'

UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
SET	AppOptionValue = 'SW5251930', ChangeID=System_user, ChangeDt=GetDate()
WHERE	ApplicationCd='SOE' and AppOptionType='LastEDISWNo'




SELECT * FROM [Porteous$Sales Header]
where [External Document No_]='1570-40-4580-00' or  [External Document No_]='1570-40-4581-00'



select * from [Porteous$Sales Header]
where [Order Date] > GETDATE()-1
order by [No_]

---------------------------------------------------------------------------------------


--[Porteous$Sales Header] - EDI Orders
SELECT	DISTINCT
	--RIGHT('00'+CAST(NVHDR.[Order Type] AS VARCHAR(2)),2) AS OrderType,
	'PEDI' AS OrderType,
	NVHDR.[Invoice Disc_ Code] as DiscountCd,
	0 as CommDol,
--	NVHDR.[Payment Discount %] as DiscPct,
	0 as TaxExpAmt,
	0 as NonTaxExpAmt,
	0 as TaxAmt,
	NVHDR.[Bill-to Customer No_] as BillToCustNo,
	NVHDR.[Bill-to Name] as BillToCustName,
	NVHDR.[Bill-to Address] as BillToAddress1,
	NVHDR.[Bill-to Address 2] as BillToAddress2,
	NVHDR.[Your Reference] as BillToAddress3,
	NVHDR.[Bill-to City] as BillToCity,
	NVHDR.[Bill-to County] as BillToState,
	NVHDR.[Bill-to Post Code] as BillToZip,
	NVHDR.[Bill-to Country Code] as BillToCountry,
	NVHDR.[Bill-to Contact] as BillToContactName,
	NVHDR.[Phone No_] as BillToContactPhoneNo,
	NVHDR.[Sell-to Customer No_] as SellToCustNo,
	NVHDR.[Sell-to Customer Name] as SellToCustName,
	NVHDR.[Sell-to Address] as SellToAddress1,
	NVHDR.[Sell-to Address 2] as SellToAddress2,
	NVHDR.[Sell-to City] as SellToCity,
	NVHDR.[Sell-to County] as SellToState,
	NVHDR.[Sell-to Post Code] as SellToZip,
	NVHDR.[Sell-to Country Code] as SellToCountry,
	NVHDR.[Sell-to Contact] as SellToContactName,
	NVHDR.[Phone No_] as SellToContactPhoneNo,
	NVHDR.[Shipment Date] as SchShipDt,
	NVHDR.[Order Date] as OrderDt,
	NVHDR.[Due Date] as OrderPromDt,
	NVHDR.[Shipping Location] as ShipLoc,
	NVHDR.[Usage Location] as UsageLoc,
	'SO' as ReasonCd,
	NVHDR.[Payment Terms Code] as OrderTermsCd,
	'N' as TaxStat,
	NVHDR.[Salesperson Code] as SalesRepNo,
	NVHDR.[Inside Salesperson Code] as CustSvcRepNo,
	NVHDR.[No_ Printed] as CopiestoPrint,
	NVHDR.[Shipping Agent Code] as OrderCarrier,
	CASE NVHDR.[Status]
	    WHEN 1 THEN GETDATE()
	END as RlsWhseDt,				----?????
	NVHDR.[Shortcut Dimension 1 Code] as CustShipLoc,
	NVHDR.[Ship-to Code] as ShipToCd,
	NVHDR.[Ship-to Name] as ShipToName,
	NVHDR.[Ship-to Address] as ShipToAddress1,
	NVHDR.[Ship-to Address 2] as ShipToAddress2,
	NVHDR.[Ship-to Name 2] as ShipToAddress3,
	NVHDR.[Ship-to City] as City,
	NVHDR.[Ship-to County] as State,
	NVHDR.[Ship-to Post Code] as Zip,
	NVHDR.[Phone No_] as PhoneNo,
	NVHDR.[Fax No_] as FaxNo,
	NVHDR.[Ship-to Contact] as ContactName,
	NVHDR.[Ship-to Country Code] as Country,
	NVHDR.[Entered Date] as EntryDt,
	NVHDR.[Entered User ID] as EntryID,
	NVHDR.[Status] as StatusCd,
	NVHDR.[External Document No_] as CustPONo,
	NVHDR.[No_] as RefSONo,
	NVHDR.[Shipment Method Code] as OrderFreightCd,
----	NVHDR.[Posting Date] as MakeOrderDt,
----	GETDATE() as AllocRelDt,
	'E' as DocumentSortInd
FROM	[Porteous$Sales Header] NVHDR WITH (NOLOCK) INNER JOIN
	[Porteous$Sales Line] NVLINE WITH (NOLOCK)
ON	NVHDR.[No_] = NVLINE.[Document No_] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item
ON	NVLINE.[No_] = Item.ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemBranch ItemBr
ON	Item.pItemMasterID = ItemBr.fItemMasterID
WHERE	ROUND(NVLINE.[Quantity],0,1) > 0 AND NVLINE.[No_] <> '' AND --NVHDR.[Document Type] = 0  AND
	NVHDR.[Shipping Location] = ItemBr.Location COLLATE SQL_Latin1_General_CP1_CI_AS AND
	EXISTS (SELECT	RefSONo
		FROM	tWO1376_Daily_SO_EDI_To_ERP
		WHERE	RefSONo = NVHDR.[No_])

--order by RefSO





DECLARE	@LastEDINo VARCHAR(20)

--Get Last EDI Order Number from AppPref
SELECT	@LastEDINo = AppOptionValue
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
WHERE	ApplicationCd='SOE' and AppOptionType='LastEDINo'


select NVLINE.*
FROM	[Porteous$Sales Header] NVHDR WITH (NOLOCK) INNER JOIN
	[Porteous$Sales Line] NVLINE WITH (NOLOCK)
ON	NVHDR.[No_] = NVLINE.[Document No_]
WHERE	ROUND(NVLINE.[Quantity],0,1) > 0 AND NVLINE.[No_] <> '' AND NVHDR.[Document Type] = 0  AND NVLINE.Type=2 AND NVHDR.[No_] > @LastEDINo AND
	EXISTS (SELECT	CustNo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.EDITradingPartner INNER JOIN
			OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster 
		ON	pCustMstrID = fCustomerMasterID
		WHERE	CustNo = NVHDR.[Sell-to Customer No_] COLLATE SQL_Latin1_General_CP1_CI_AS)



-----------------------------------------------------------------------------------



DECLARE	@LastEDINo VARCHAR(20)


--Get Last EDI Order Number from AppPref
SELECT	@LastEDINo = AppOptionValue
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
WHERE	ApplicationCd='SOE' and AppOptionType='LastEDINo'

--Get Last EDI Order Number that was processed
SELECT	@LastEDINo = MAX(NVHDR.[No_])
FROM	[Porteous$Sales Header] NVHDR WITH (NOLOCK) INNER JOIN
	[Porteous$Sales Line] NVLINE WITH (NOLOCK)
ON	NVHDR.[No_] = NVLINE.[Document No_]
WHERE	NVLINE.[Qty_ to Ship] > 0 AND NVLINE.[No_] <> '' AND NVHDR.[Document Type] = 0  AND NVHDR.[No_] > @LastEDINo AND
	EXISTS (SELECT	CustNo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.EDITradingPartner INNER JOIN
			OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster 
		ON	pCustMstrID = fCustomerMasterID
		WHERE	CustNo = NVHDR.[Sell-to Customer No_] COLLATE SQL_Latin1_General_CP1_CI_AS)

--select @LastEDINo

UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.AppPref
SET	AppOptionValue = @LastEDINo, ChangeID=System_user, ChangeDt=GetDate()
WHERE	ApplicationCd='SOE' and AppOptionType='LastEDINo'


-----------------------------------------------------------------------------------




select DISTINCT NVHDR.* from [Porteous$Sales Header] NVHDR
INNER JOIN
	[Porteous$Sales Line] NVLINE
ON	NVHDR.[No_] = [Document No_]
where  NVLINE.[Qty_ to Ship] > 0 AND NVLINE.[No_] <> '' AND (NVHDR.[Sell-to Customer No_]='100029' or NVHDR.[Sell-to Customer No_]='100158')





select [Customer Price Code] from [Porteous$Customer] where LEN([Customer Price Code]) > 2




delete from tWO1376_Daily_SO_EDI_To_ERP
where RefSONo < 'SW5033302' and left(RefSONo,2)='SW'



select [Order Date], * from [Porteous$Sales Header] where [No_]>='SW5007939' and
EXISTS (SELECT	CustNo
		FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.EDITradingPartner INNER JOIN
			OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster 
		ON	pCustMstrID = fCustomerMasterID
		WHERE	CustNo = [Sell-to Customer No_] COLLATE SQL_Latin1_General_CP1_CI_AS)
order by [Order Date], [No_]