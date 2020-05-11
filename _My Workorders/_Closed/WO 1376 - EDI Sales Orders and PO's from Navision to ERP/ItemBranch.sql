

--[Porteous$Sales Header] - EDI Orders
SELECT	--DISTINCT


NVLINE.[No_], NVHDR.[Shipping Location],

	NVHDR.[Shipping Agent Code] as Carrier,
	NVHDR.[Shipment Method Code] as Freight,


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
into t48lines
FROM	[Porteous$Sales Header] NVHDR WITH (NOLOCK) INNER JOIN
	[Porteous$Sales Line] NVLINE WITH (NOLOCK)
ON	NVHDR.[No_] = NVLINE.[Document No_] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item
ON	NVLINE.[No_] = Item.ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemBranch ItemBr
ON	Item.pItemMasterID = ItemBr.fItemMasterID
WHERE	ROUND(NVLINE.[Quantity],0,1) > 0 AND NVLINE.[No_] <> '' AND NVHDR.[Document Type] = 0  AND
	NVHDR.[Shipping Location] = ItemBr.Location COLLATE SQL_Latin1_General_CP1_CI_AS AND
	EXISTS (SELECT	RefSONo
		FROM	tWO1376_Daily_SO_EDI_To_ERP
		WHERE	RefSONo = NVHDR.[No_])
order by NVLINE.[No_], NVHDR.[Shipping Location]
--order by RefSO


select	distinct
	[No_],[Shipping Location] from t168lines t168
where not exists (select * from t48lines t48 where t48.[No_]=t168.[No_] and t48.[Shipping Location] = t168.[Shipping Location])
order by [No_],[Shipping Location]



select *
from 	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemMaster Item INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ItemBranch ItemBr
ON	Item.pItemMasterID = ItemBr.fItemMasterID
where 
(Item.ItemNo = '00022-2826-021' and ItemBr.Location='20') or
(Item.ItemNo = '00022-3060-021' and ItemBr.Location='20') or
(Item.ItemNo = '00022-3240-021' and ItemBr.Location='20') or
(Item.ItemNo = '00022-3250-021' and ItemBr.Location='20') or
(Item.ItemNo = '00023-2416-021' and ItemBr.Location='20') or
(Item.ItemNo = '00023-2426-021' and ItemBr.Location='20') or
(Item.ItemNo = '00023-2618-021' and ItemBr.Location='20') or
(Item.ItemNo = '00023-2820-021' and ItemBr.Location='20') or
(Item.ItemNo = '00023-3024-021' and ItemBr.Location='20') or
(Item.ItemNo = '00023-3230-021' and ItemBr.Location='20') or
(Item.ItemNo = '00024-2462-021' and ItemBr.Location='20') or
(Item.ItemNo = '00024-2616-020' and ItemBr.Location='20') or
(Item.ItemNo = '00050-3230-021' and ItemBr.Location='20') or
(Item.ItemNo = '00050-3262-021' and ItemBr.Location='20') or
(Item.ItemNo = '00050-3462-021' and ItemBr.Location='20') or
(Item.ItemNo = '00051-2427-021' and ItemBr.Location='20') or
(Item.ItemNo = '00056-2408-041' and ItemBr.Location='20') or
(Item.ItemNo = '00057-2918-021' and ItemBr.Location='20') or
(Item.ItemNo = '00080-2527-042' and ItemBr.Location='20') or
(Item.ItemNo = '00080-3068-040' and ItemBr.Location='20') or
(Item.ItemNo = '00081-2861-040' and ItemBr.Location='20') or
(Item.ItemNo = '00100-2460-020' and ItemBr.Location='20') or
(Item.ItemNo = '00100-2464-021' and ItemBr.Location='20') or
(Item.ItemNo = '00100-2652-021' and ItemBr.Location='20') or
(Item.ItemNo = '00100-2866-021' and ItemBr.Location='20') or
(Item.ItemNo = '00100-3060-021' and ItemBr.Location='20') or
(Item.ItemNo = '00110-2426-021' and ItemBr.Location='20') or
(Item.ItemNo = '00110-2430-021' and ItemBr.Location='20') or
(Item.ItemNo = '00110-2440-021' and ItemBr.Location='20') or
(Item.ItemNo = '00110-2440-024' and ItemBr.Location='20') or
(Item.ItemNo = '00110-2626-024' and ItemBr.Location='20') or
(Item.ItemNo = '00110-2630-024' and ItemBr.Location='20') or
(Item.ItemNo = '00110-2640-021' and ItemBr.Location='20') or
(Item.ItemNo = '00110-2640-024' and ItemBr.Location='20') or
(Item.ItemNo = '00110-2650-021' and ItemBr.Location='20') or
(Item.ItemNo = '00110-2660-021' and ItemBr.Location='20') or
(Item.ItemNo = '00110-2664-021' and ItemBr.Location='20') or
(Item.ItemNo = '00110-2824-021' and ItemBr.Location='20') or
(Item.ItemNo = '00110-2850-021' and ItemBr.Location='20') or
(Item.ItemNo = '00110-2864-021' and ItemBr.Location='20') or
(Item.ItemNo = '00110-3040-021' and ItemBr.Location='20') or
(Item.ItemNo = '00110-3260-024' and ItemBr.Location='20') or
(Item.ItemNo = '00152-3042-000' and ItemBr.Location='20') or
(Item.ItemNo = '00200-2500-021' and ItemBr.Location='20') or
(Item.ItemNo = '00200-2600-021' and ItemBr.Location='20') or
(Item.ItemNo = '00200-2600-024' and ItemBr.Location='20') or
(Item.ItemNo = '00200-2800-024' and ItemBr.Location='20') or
(Item.ItemNo = '00200-3000-024' and ItemBr.Location='20') or
(Item.ItemNo = '00200-4000-024' and ItemBr.Location='20') or
(Item.ItemNo = '00201-2900-020' and ItemBr.Location='20') or
(Item.ItemNo = '00201-2900-021' and ItemBr.Location='20') or
(Item.ItemNo = '00206-4000-021' and ItemBr.Location='20') or
(Item.ItemNo = '00206-4400-021' and ItemBr.Location='20') or
(Item.ItemNo = '00220-0400-021' and ItemBr.Location='20') or
(Item.ItemNo = '00220-2500-021' and ItemBr.Location='20') or
(Item.ItemNo = '00240-4100-020' and ItemBr.Location='20') or
(Item.ItemNo = '00241-4100-020' and ItemBr.Location='20') or
(Item.ItemNo = '00270-2400-021' and ItemBr.Location='20') or
(Item.ItemNo = '00280-2405-021' and ItemBr.Location='20') or
(Item.ItemNo = '00350-0400-021' and ItemBr.Location='20') or
(Item.ItemNo = '00350-1000-020' and ItemBr.Location='20') or
(Item.ItemNo = '00350-1200-020' and ItemBr.Location='20') or
(Item.ItemNo = '00350-4400-020' and ItemBr.Location='20') or
(Item.ItemNo = '00355-2400-022' and ItemBr.Location='20') or
(Item.ItemNo = '00355-2800-022' and ItemBr.Location='20') or
(Item.ItemNo = '00356-4000-020' and ItemBr.Location='20') or
(Item.ItemNo = '00370-2400-024' and ItemBr.Location='20') or
(Item.ItemNo = '00370-2700-024' and ItemBr.Location='20') or
(Item.ItemNo = '00370-2900-024' and ItemBr.Location='20') or
(Item.ItemNo = '00370-3000-024' and ItemBr.Location='20') or
(Item.ItemNo = '00374-4000-022' and ItemBr.Location='20') or
(Item.ItemNo = '00375-1000-021' and ItemBr.Location='20') or
(Item.ItemNo = '00376-0600-027' and ItemBr.Location='20') or
(Item.ItemNo = '00501-0822-021' and ItemBr.Location='20') or
(Item.ItemNo = '00501-0830-021' and ItemBr.Location='20') or
(Item.ItemNo = '00501-1016-021' and ItemBr.Location='20') or
(Item.ItemNo = '00501-1020-021' and ItemBr.Location='20') or
(Item.ItemNo = '00501-1026-021' and ItemBr.Location='20') or
(Item.ItemNo = '00501-1418-021' and ItemBr.Location='20') or
(Item.ItemNo = '00601-0608-021' and ItemBr.Location='20') or
(Item.ItemNo = '00601-1218-021' and ItemBr.Location='20') or
(Item.ItemNo = '00601-1220-021' and ItemBr.Location='20') or
(Item.ItemNo = '00633-0812-021' and ItemBr.Location='20') or
(Item.ItemNo = '00680-1016-021' and ItemBr.Location='20') or
(Item.ItemNo = '00680-1020-021' and ItemBr.Location='20') or
(Item.ItemNo = '00685-0820-021' and ItemBr.Location='20') or
(Item.ItemNo = '00720-1012-021' and ItemBr.Location='20') or
(Item.ItemNo = '00720-1220-021' and ItemBr.Location='20') or
(Item.ItemNo = '00720-1224-021' and ItemBr.Location='20') or
(Item.ItemNo = '00720-1416-021' and ItemBr.Location='20') or
(Item.ItemNo = '00720-1424-021' and ItemBr.Location='20') or
(Item.ItemNo = '00720-1430-021' and ItemBr.Location='20') or
(Item.ItemNo = '00721-1420-021' and ItemBr.Location='20') or
(Item.ItemNo = '00742-0818-401' and ItemBr.Location='20') or
(Item.ItemNo = '00790-0616-020' and ItemBr.Location='20') or
(Item.ItemNo = '00790-0621-020' and ItemBr.Location='20') or
(Item.ItemNo = '00790-0624-029' and ItemBr.Location='20') or
(Item.ItemNo = '00791-0616-020' and ItemBr.Location='20') or
(Item.ItemNo = '00791-0618-020' and ItemBr.Location='20') or
(Item.ItemNo = '00791-0621-020' and ItemBr.Location='20') or
(Item.ItemNo = '00900-2412-020' and ItemBr.Location='20') or
(Item.ItemNo = '00900-2508-020' and ItemBr.Location='20') or
(Item.ItemNo = '00930-2416-020' and ItemBr.Location='20') or
(Item.ItemNo = '00930-2418-020' and ItemBr.Location='20') or
(Item.ItemNo = '00930-2420-020' and ItemBr.Location='20') or
(Item.ItemNo = '00930-2512-020' and ItemBr.Location='20') or
(Item.ItemNo = '01315-2431-400' and ItemBr.Location='20') or
(Item.ItemNo = '02301-0807-400' and ItemBr.Location='20') or
(Item.ItemNo = '02315-2633-021' and ItemBr.Location='20') or
(Item.ItemNo = '02315-2841-021' and ItemBr.Location='20') or
(Item.ItemNo = '02315-2852-021' and ItemBr.Location='20') or
(Item.ItemNo = '02315-2862-021' and ItemBr.Location='20') or
(Item.ItemNo = '02315-3060-021' and ItemBr.Location='20') or
(Item.ItemNo = '02315-3062-021' and ItemBr.Location='20') or
(Item.ItemNo = '02315-3262-021' and ItemBr.Location='20') or
(Item.ItemNo = '20900-0825-460' and ItemBr.Location='20')



