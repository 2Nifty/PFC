--[Porteous$Sales Header] - EDI Orders
SELECT	DISTINCT
	CASE WHEN NVHDR.[Document Type] = 3  --Credit Memo
		  THEN 'CR'
		  ELSE CASE WHEN NVHDR.[Document Type] = 5  --Return Goods
				 THEN 'RGA'
				 ELSE CASE WHEN NVHDR.[Back Order] = 1  --Backorder
						THEN 'BO'
						ELSE 'PEDI'
				      END
		       END
	END as OrderType,
	NVHDR.[Invoice Disc_ Code] as DiscountCd,
	0 as CommDol,
	0 as TaxSum,
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
	CASE WHEN NVHDR.[Document Type] = 3 OR NVHDR.[Document Type] = 5 OR NVHDR.[Back Order] = 1
		  THEN NVHDR.[Order Date]
		  ELSE null
	END as HoldDt,
	NVHDR.[Order Date] as OrderDt,
	NVHDR.[Due Date] as OrderPromDt,
	CASE WHEN NVHDR.[Shortcut Dimension 1 Code] = 0 OR NVHDR.[Shortcut Dimension 1 Code] = '' OR NVHDR.[Shortcut Dimension 1 Code] is null
		  THEN CASE WHEN NVHDR.[Location Code] = 0 OR NVHDR.[Location Code] = '' OR NVHDR.[Location Code] is null
				 THEN '01'
				 ELSE NVHDR.[Location Code]
		       END
		  ELSE NVHDR.[Shortcut Dimension 1 Code]
	END as OrderLoc,
	CASE WHEN NVHDR.[Shipping Location] = 0 OR NVHDR.[Shipping Location] = '' OR NVHDR.[Shipping Location] is null
		  THEN '01'
		  ELSE NVHDR.[Shipping Location]
	END as ShipLoc,
	NVHDR.[Usage Location] as UsageLoc,
	CASE WHEN NVHDR.[Document Type] = 3  --Credit Memo
		  THEN 'HW'
		  ELSE CASE WHEN NVHDR.[Document Type] = 5  --Return Goods
				 THEN 'RG'
				 ELSE CASE WHEN NVHDR.[Back Order] = 1  --Backorder
						THEN '11'
						ELSE null
				      END
		       END
	END as HoldReason,
	'SO' as ReasonCd,
	CASE WHEN NVHDR.[Back Order] = 1
		  THEN 'BO'
		  ELSE null
	END as BOFlag,
	NVHDR.[Payment Terms Code] as OrderTermsCd,
	Terms.TermsName as OrderTermsName,
	'N' as TaxStat,
	NVHDR.[Salesperson Code] as SalesRepNo,
	NVHDR.[Inside Salesperson Code] as CustSvcRepNo,
	NVHDR.[No_ Printed] as CopiestoPrint,
	NVHDR.[Shipping Agent Code] as OrderCarrier,
	CASE NVHDR.[Status]
	    WHEN 1 THEN GETDATE()
	END as RlsWhseDt,				----?????
	CASE WHEN NVHDR.[Shortcut Dimension 1 Code] = 0 OR NVHDR.[Shortcut Dimension 1 Code] = '' OR NVHDR.[Shortcut Dimension 1 Code] is null
		  THEN CASE WHEN NVHDR.[Location Code] = 0 OR NVHDR.[Location Code] = '' OR NVHDR.[Location Code] is null
				 THEN '01'
				 ELSE NVHDR.[Location Code]
		       END
		  ELSE NVHDR.[Shortcut Dimension 1 Code]
	END as CustShipLoc,
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
	CASE WHEN NVHDR.[External Document No_] = '' OR NVHDR.[External Document No_] is null
		THEN 'No PO'
		ELSE NVHDR.[External Document No_]
	END as CustPONo,
	NVHDR.[No_] as RefSONo,
	NVHDR.[Shipment Method Code] as OrderFreightCd,
	NVHDR.[Shipment Date] as BranchReqDt,
	CASE WHEN NVHDR.[Requested Delivery Date] = '' OR NVHDR.[Requested Delivery Date] is null OR NVHDR.[Requested Delivery Date] < '1900-01-01'
		THEN NVHDR.[Order Date]
		ELSE NVHDR.[Requested Delivery Date]
	END as CustReqDt,
	'E' as DocumentSortInd,
	'EI' as OrderSource
FROM	[Porteous$Sales Header] NVHDR WITH (NOLOCK) INNER JOIN
	[Porteous$Sales Line] NVLINE WITH (NOLOCK)
ON	NVHDR.[No_] = NVLINE.[Document No_] INNER JOIN
	(SELECT	DISTINCT Code as TermsCd, [Description] as TermsName
	 FROM	[Porteous$Payment Terms]) Terms
ON	NVHDR.[Payment Terms Code] = Terms.TermsCd
WHERE	CASE WHEN NVLINE.[Quantity] > 0 AND NVLINE.[Quantity] < 1 THEN 1
	     ELSE ROUND(NVLINE.[Quantity],0,1)
	END > 0 AND
	NVLINE.[No_] <> '' AND
	EXISTS (SELECT	RefSONo
		FROM	tWO1376_Daily_SO_EDI_To_ERP
		WHERE	RefSONo = NVHDR.[No_])
