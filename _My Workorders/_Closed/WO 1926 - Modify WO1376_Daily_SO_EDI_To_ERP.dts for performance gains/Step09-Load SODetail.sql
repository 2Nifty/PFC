--[Porteous$Sales Line]
SELECT	SOHeader.pSOHeaderID as fSOHeaderID,
	NVLINE.[Line No_] as LineNumber,
	NVLINE.[Line No_] as LineSeq,
	'S' as LineType,
	CASE [Unit Price Origin]
	     WHEN '' THEN 'E'
	     WHEN 'CP' THEN 'P'
	     WHEN 'CPDP' THEN 'P'
	     WHEN 'IUP' THEN 'L'
	     WHEN 'OVERRIDE' THEN 'E'
	     WHEN 'OVR' THEN 'E'
	     WHEN 'SDUP' THEN 'D'
	     WHEN 'SPUP' THEN 'C'
	     ELSE 'E'
	END as LinePriceInd,
	SOHeader.ReasonCd as LineReason,
	SOHeader.OrderExpdCd as LineExpdCd,
	NVLINE.[No_] as ItemNo,
	NVLINE.[Description] as ItemDsc,
	'STOCK' as BinLoc,
--	SOHeader.ShipLoc as IMLoc,
	NVLINE.[Location Code] as IMLoc,
	NVLINE.[Allow Invoice Disc_] as DiscInd,
	'A' as CostInd,
	SOHeader.PriceCd as PriceCd,
	CASE [Unit Price Origin]
	     WHEN '' THEN 'E'
	     WHEN 'CP' THEN 'P'
	     WHEN 'CPDP' THEN 'P'
	     WHEN 'IUP' THEN 'L'
	     WHEN 'OVERRIDE' THEN 'E'
	     WHEN 'OVR' THEN 'E'
	     WHEN 'SDUP' THEN 'D'
	     WHEN 'SPUP' THEN 'C'
	     ELSE 'E'
	END as LISource,
	'' as QtyStat,
	0 as ComPct,
	0 as ComDol,
	NVLINE.[Net Unit Price] as NetUnitPrice,
	NVLINE.[Unit Price] as ListUnitPrice,
	CASE WHEN NVLINE.[Line Discount %] > 100 THEN NVLINE.[Unit Price] - (NVLINE.[Unit Price] * 100 * 0.01)
	     WHEN NVLINE.[Line Discount %] < -100 THEN NVLINE.[Unit Price] - (NVLINE.[Unit Price] * -100 * 0.01)
	     ELSE NVLINE.[Unit Price] - (NVLINE.[Unit Price] * ROUND(NVLINE.[Line Discount %],0,1) * 0.01)
	END as DiscUnitPrice,
	CASE WHEN NVLINE.[Line Discount %] > 100 THEN 100
	     WHEN NVLINE.[Line Discount %] < -100 THEN -100
	     ELSE NVLINE.[Line Discount %]
	END as DiscPct1,
	0 as DiscPct2,
	0 as DiscPct3,
	'' as QtyAvailLoc1,
	0 as QtyAvail1,
	'' as QtyAvailLoc2,
	0 as QtyAvail2,
	'' as QtyAvailLoc3,
	0 as QtyAvail3,
	0 as OrigOrderLineNo,
	NVLINE.[Shipment Date] as RqstdShipDt,
	NVLINE.[Shipment Date] as OrigShipDt,
	SOHeader.CustReqDt as SuggstdShipDt,
	CASE WHEN NVLINE.[Quantity] > 0 AND NVLINE.[Quantity] < 1 THEN 1
	     ELSE ROUND(NVLINE.[Quantity],0,1)
	END as QtyOrdered,
	CASE WHEN NVLINE.[Quantity] > 0 AND NVLINE.[Quantity] < 1 THEN 1
	     ELSE ROUND(NVLINE.[Quantity],0,1)
	END as QtyShipped,
	CASE WHEN NVLINE.[Quantity] > 0 AND NVLINE.[Quantity] < 1 THEN 1
	     ELSE ROUND(NVLINE.[Quantity],0,1)
	END as QtyBO,
	0 AS UnitCost,
	0 AS UnitCost2,
	0 AS UnitCost3,
	0 AS RepCost,
	0 as OECost,
	'' as Remark,
	NVLINE.[Cross-Reference No_] as CustItemNo,
	'' as CustItemDsc,
	SOHeader.EntryDt as EntryDate,
	SOHeader.EntryID as EntryID,
	NVLINE.[Status] as StatusCd,
	NVLINE.[Gross Weight] as GrossWght,
	NVLINE.[Net Weight] as NetWght,
	CASE WHEN NVLINE.[Quantity] > 0 AND NVLINE.[Quantity] < 1 THEN NVLINE.[Net Unit Price]
	     ELSE ROUND(NVLINE.[Quantity],0,1) * NVLINE.[Net Unit Price]
	END as ExtendedPrice,
	0 as ExtendedCost,
	CASE WHEN NVLINE.[Quantity] > 0 AND NVLINE.[Quantity] < 1 THEN NVLINE.[Net Weight]
	     ELSE ROUND(NVLINE.[Quantity],0,1) * NVLINE.[Net Weight]
	END as ExtendedNetWght,
	CASE WHEN NVLINE.[Quantity] > 0 AND NVLINE.[Quantity] < 1 THEN NVLINE.[Gross Weight]
	     ELSE ROUND(NVLINE.[Quantity],0,1) * NVLINE.[Gross Weight]
	END as ExtendedGrossWght,
	'' as QtyStatus,
	0 as ExcludeFromUsageFlag,
	CASE ROUND(NVLINE.[Original Qty],0,1)
	     WHEN 0 THEN CASE WHEN NVLINE.[Quantity] > 0 AND NVLINE.[Quantity] < 1 THEN 1
			      ELSE ROUND(NVLINE.[Quantity],0,1)
			 END
	     ELSE ROUND(NVLINE.[Original Qty],0,1)
	END as OriginalQtyRequested,
	NVLINE.[Usage Location] as UsageLoc,
	SOHeader.OrderCarrier as CarrierCd,
	SOHeader.OrderFreightCd as FreightCd
FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Line] NVLINE INNER JOIN
	SOHeader
ON	NVLINE.[Document No_] = SOHeader.RefSONo
WHERE	CASE WHEN NVLINE.[Quantity] > 0 AND NVLINE.[Quantity] < 1 THEN 1
	     ELSE ROUND(NVLINE.[Quantity],0,1)
	END > 0 AND
	NVLINE.No_ <> '' AND NVLINE.Type=2 AND
	EXISTS (SELECT	RefSONo
		FROM	tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)
