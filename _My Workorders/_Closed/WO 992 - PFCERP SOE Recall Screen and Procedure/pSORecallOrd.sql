
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pSORecallOrd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pSORecallOrd]
GO

CREATE procedure [dbo].[pSORecallOrd]
@DocNo varchar(20),
@DocType char(1)
as

----pSORecallOrd
----Written By: Tod Dixon
----Application: Sales Management


IF (@DocType = 'O') GOTO SOTables


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tSORecall]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tSORecall]

--SORel Tables
IF (@DocType = 'I')
   BEGIN	--Search By Invoice
	SELECT	'SORel' AS SOTable, Hdr.pSOHeaderRelID AS HeaderID, Hdr.fSOHeaderID AS OrigOrderNo, Hdr.BillToCustNo,
		Hdr.OrderNo, Hdr.InvoiceNo, Hdr.OrderTypeDsc, Hdr.OrderDt, Hdr.ShipLoc, Hdr.SellToCustName, Hdr.SellToCustNo,
		Hdr.SellToAddress1, Hdr.SellToCity, Hdr.SellToState, Hdr.SellToZip, Hdr.SellToCountry, Hdr.SellToContactPhoneNo,
		Hdr.SellToContactName, Hdr.OrderTermsCd, Hdr.OrderTermsName, Hdr.ShipToName, Hdr.ShipToCd, Hdr.ShipToAddress1,
		Hdr.City, Hdr.State, Hdr.Zip, Hdr.Country, Hdr.PhoneNo, Hdr.ContactName, Hdr.TotalOrder, Hdr.TotalCost, Hdr.ShipWght,
		Hdr.CustPONo, Hdr.CustReqDt, Hdr.ConfirmShipDt, Hdr.OrderExpdCd, Hdr.OrderExpdCdName, Hdr.ShipInstrCd, Hdr.ShipInstrCdName,
		Hdr.InvoiceDt, Hdr.OrderCarrier, Hdr.OrderCarName, Hdr.BOLNO, Hdr.OrderFreightCd, Hdr.OrderFreightName, Hdr.OrderPriorityCd,
		Hdr.OrderPriName, Hdr.HoldReason, Hdr.HoldReasonName, Hdr.AllocDt, Hdr.PrintDt, Hdr.DeleteDt AS DeleteDtHdr, Hdr.OrigShipDt,
		Hdr.TaxExpAmt, Hdr.NonTaxExpAmt, ShippingMark1, ShippingMark2, ShippingMark3, ShippingMark4, Hdr.Remarks, Hdr.NoCartons,
		Dtl.CustItemNo, Dtl.ItemNo, Dtl.ItemDsc, Dtl.QtyShipped, Dtl.IMLoc, Dtl.QtyOrdered, Dtl.QtyAvail1,
		cast(cast(Dtl.SellStkFactor as decimal(18,0)) AS Varchar(10)) + '/' + Dtl.SellStkUM AS BaseUOM,
		cast(cast(Dtl.AlternateUMQty as decimal(18,0)) AS Varchar(10)) + '/' + Dtl.AlternateUM AS SuperEQV,
		Dtl.NetUnitPrice, Dtl.ExtendedNetWght, Dtl.ExtendedGrossWght, Loc.LocName, Dtl.ExtendedPrice,
		Dtl.LineNumber, Dtl.Remark, Dtl.AlternateUMQty, Dtl.AlternateUM,
		CASE Dtl.ExtendedGrossWght
		   WHEN 0 THEN 0
			  ELSE Dtl.ExtendedPrice / Dtl.ExtendedGrossWght
		END AS PricePerLB,
		CASE Dtl.ExtendedPrice
		   WHEN 0 THEN 0
			  ELSE ((Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedPrice) * 100
		END AS MarginPct,
		CASE Dtl.ExtendedGrossWght
		   WHEN 0 THEN 0
			  ELSE (Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedGrossWght
		END AS MarginPerLb,
		Dtl.DeleteDt, Cust.MinBillAmt, Cust.ContractNo
	INTO	tSORecall
	FROM	SOHeaderRel Hdr LEFT OUTER JOIN
		SODetailRel Dtl ON Hdr.pSOHeaderRelID = Dtl.fSOHeaderRelID LEFT OUTER JOIN
		LocMaster Loc ON Loc.LocID = Dtl.IMLoc LEFT OUTER JOIN
		CustomerMaster Cust ON Cust.CustNo = Hdr.SellToCustNo
	WHERE	InvoiceNo=@DocNo
   END
ELSE
   BEGIN	--Search By Order
	SELECT	'SORel' AS SOTable, Hdr.pSOHeaderRelID AS HeaderID, Hdr.fSOHeaderID AS OrigOrderNo, Hdr.BillToCustNo,
		Hdr.OrderNo, Hdr.InvoiceNo, Hdr.OrderTypeDsc, Hdr.OrderDt, Hdr.ShipLoc, Hdr.SellToCustName, Hdr.SellToCustNo,
		Hdr.SellToAddress1, Hdr.SellToCity, Hdr.SellToState, Hdr.SellToZip, Hdr.SellToCountry, Hdr.SellToContactPhoneNo,
		Hdr.SellToContactName, Hdr.OrderTermsCd, Hdr.OrderTermsName, Hdr.ShipToName, Hdr.ShipToCd, Hdr.ShipToAddress1,
		Hdr.City, Hdr.State, Hdr.Zip, Hdr.Country, Hdr.PhoneNo, Hdr.ContactName, Hdr.TotalOrder, Hdr.TotalCost, Hdr.ShipWght,
		Hdr.CustPONo, Hdr.CustReqDt, Hdr.ConfirmShipDt, Hdr.OrderExpdCd, Hdr.OrderExpdCdName, Hdr.ShipInstrCd, Hdr.ShipInstrCdName,
		Hdr.InvoiceDt, Hdr.OrderCarrier, Hdr.OrderCarName, Hdr.BOLNO, Hdr.OrderFreightCd, Hdr.OrderFreightName, Hdr.OrderPriorityCd,
		Hdr.OrderPriName, Hdr.HoldReason, Hdr.HoldReasonName, Hdr.AllocDt, Hdr.PrintDt, Hdr.DeleteDt AS DeleteDtHdr, Hdr.OrigShipDt,
		Hdr.TaxExpAmt, Hdr.NonTaxExpAmt, ShippingMark1, ShippingMark2, ShippingMark3, ShippingMark4, Hdr.Remarks, Hdr.NoCartons,
		Dtl.CustItemNo, Dtl.ItemNo, Dtl.ItemDsc, Dtl.QtyShipped, Dtl.IMLoc, Dtl.QtyOrdered, Dtl.QtyAvail1,
		cast(cast(Dtl.SellStkFactor as decimal(18,0)) AS Varchar(10)) + '/' + Dtl.SellStkUM AS BaseUOM,
		cast(cast(Dtl.AlternateUMQty as decimal(18,0)) AS Varchar(10)) + '/' + Dtl.AlternateUM AS SuperEQV,
		Dtl.NetUnitPrice, Dtl.ExtendedNetWght, Dtl.ExtendedGrossWght, Loc.LocName, Dtl.ExtendedPrice,
		Dtl.LineNumber, Dtl.Remark, Dtl.AlternateUMQty, Dtl.AlternateUM,
		CASE Dtl.ExtendedGrossWght
		   WHEN 0 THEN 0
			  ELSE Dtl.ExtendedPrice / Dtl.ExtendedGrossWght
		END AS PricePerLB,
		CASE Dtl.ExtendedPrice
		   WHEN 0 THEN 0
			  ELSE ((Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedPrice) * 100
		END AS MarginPct,
		CASE Dtl.ExtendedGrossWght
		   WHEN 0 THEN 0
			  ELSE (Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedGrossWght
		END AS MarginPerLb,
		Dtl.DeleteDt, Cust.MinBillAmt, Cust.ContractNo
	INTO	tSORecall
	FROM	SOHeaderRel Hdr LEFT OUTER JOIN
		SODetailRel Dtl ON Hdr.pSOHeaderRelID = Dtl.fSOHeaderRelID LEFT OUTER JOIN
		LocMaster Loc ON Loc.LocID = Dtl.IMLoc LEFT OUTER JOIN
		CustomerMaster Cust ON Cust.CustNo = Hdr.SellToCustNo
	WHERE	OrderNo=@DocNo
   END
IF (@@RowCount > 0) GOTO FoundData


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tSORecall]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tSORecall]

--SOHist Tables
IF (@DocType = 'I')
   BEGIN	--Search By Invoice
	SELECT	'SOHist' AS SOTable, Hdr.pSOHeaderHistID AS HeaderID, Hdr.fSOHeaderID AS OrigOrderNo, Hdr.BillToCustNo,
		Hdr.OrderNo, Hdr.InvoiceNo, Hdr.OrderTypeDsc, Hdr.OrderDt, Hdr.ShipLoc, Hdr.SellToCustName, Hdr.SellToCustNo,
		Hdr.SellToAddress1, Hdr.SellToCity, Hdr.SellToState, Hdr.SellToZip, Hdr.SellToCountry, Hdr.SellToContactPhoneNo,
		Hdr.SellToContactName, Hdr.OrderTermsCd, Hdr.OrderTermsName, Hdr.ShipToName, Hdr.ShipToCd, Hdr.ShipToAddress1,
		Hdr.City, Hdr.State, Hdr.Zip, Hdr.Country, Hdr.PhoneNo, Hdr.ContactName, Hdr.TotalOrder, Hdr.TotalCost, Hdr.ShipWght,
		Hdr.CustPONo, Hdr.CustReqDt, Hdr.ConfirmShipDt, Hdr.OrderExpdCd, Hdr.OrderExpdCdName, Hdr.ShipInstrCd, Hdr.ShipInstrCdName,
		Hdr.InvoiceDt, Hdr.OrderCarrier, Hdr.OrderCarName, Hdr.BOLNO, Hdr.OrderFreightCd, Hdr.OrderFreightName, Hdr.OrderPriorityCd,
		Hdr.OrderPriName, Hdr.HoldReason, Hdr.HoldReasonName, Hdr.AllocDt, Hdr.PrintDt, Hdr.DeleteDt AS DeleteDtHdr, Hdr.OrigShipDt,
		Hdr.TaxExpAmt, Hdr.NonTaxExpAmt, ShippingMark1, ShippingMark2, ShippingMark3, ShippingMark4, Hdr.Remarks, Hdr.NoCartons,
		Dtl.CustItemNo, Dtl.ItemNo, Dtl.ItemDsc, Dtl.QtyShipped, Dtl.IMLoc, Dtl.QtyOrdered, Dtl.QtyAvail1,
		cast(cast(Dtl.SellStkFactor as decimal(18,0)) AS Varchar(10)) + '/' + Dtl.SellStkUM AS BaseUOM,
		cast(cast(Dtl.AlternateUMQty as decimal(18,0)) AS Varchar(10)) + '/' + Dtl.AlternateUM AS SuperEQV,
		Dtl.NetUnitPrice, Dtl.ExtendedNetWght, Dtl.ExtendedGrossWght, Loc.LocName, Dtl.ExtendedPrice,
		Dtl.LineNumber, Dtl.Remark, Dtl.AlternateUMQty, Dtl.AlternateUM,
		CASE Dtl.ExtendedGrossWght
		   WHEN 0 THEN 0
			  ELSE Dtl.ExtendedPrice / Dtl.ExtendedGrossWght
		END AS PricePerLB,
		CASE Dtl.ExtendedPrice
		   WHEN 0 THEN 0
			  ELSE ((Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedPrice) * 100
		END AS MarginPct,
		CASE Dtl.ExtendedGrossWght
		   WHEN 0 THEN 0
			  ELSE (Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedGrossWght
		END AS MarginPerLb,
		Dtl.DeleteDt, Cust.MinBillAmt, Cust.ContractNo
	INTO	tSORecall
	FROM	SOHeaderHist Hdr LEFT OUTER JOIN
		SODetailHist Dtl ON Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID LEFT OUTER JOIN
		LocMaster Loc ON Loc.LocID = Dtl.IMLoc LEFT OUTER JOIN
		CustomerMaster Cust ON Cust.CustNo = Hdr.SellToCustNo
	WHERE	InvoiceNo=@DocNo
   END
ELSE
   BEGIN	--Search By Order
	SELECT	'SOHist' AS SOTable, Hdr.pSOHeaderHistID AS HeaderID, Hdr.fSOHeaderID AS OrigOrderNo, Hdr.BillToCustNo,
		Hdr.OrderNo, Hdr.InvoiceNo, Hdr.OrderTypeDsc, Hdr.OrderDt, Hdr.ShipLoc, Hdr.SellToCustName, Hdr.SellToCustNo,
		Hdr.SellToAddress1, Hdr.SellToCity, Hdr.SellToState, Hdr.SellToZip, Hdr.SellToCountry, Hdr.SellToContactPhoneNo,
		Hdr.SellToContactName, Hdr.OrderTermsCd, Hdr.OrderTermsName, Hdr.ShipToName, Hdr.ShipToCd, Hdr.ShipToAddress1,
		Hdr.City, Hdr.State, Hdr.Zip, Hdr.Country, Hdr.PhoneNo, Hdr.ContactName, Hdr.TotalOrder, Hdr.TotalCost, Hdr.ShipWght,
		Hdr.CustPONo, Hdr.CustReqDt, Hdr.ConfirmShipDt, Hdr.OrderExpdCd, Hdr.OrderExpdCdName, Hdr.ShipInstrCd, Hdr.ShipInstrCdName,
		Hdr.InvoiceDt, Hdr.OrderCarrier, Hdr.OrderCarName, Hdr.BOLNO, Hdr.OrderFreightCd, Hdr.OrderFreightName, Hdr.OrderPriorityCd,
		Hdr.OrderPriName, Hdr.HoldReason, Hdr.HoldReasonName, Hdr.AllocDt, Hdr.PrintDt, Hdr.DeleteDt AS DeleteDtHdr, Hdr.OrigShipDt,
		Hdr.TaxExpAmt, Hdr.NonTaxExpAmt, ShippingMark1, ShippingMark2, ShippingMark3, ShippingMark4, Hdr.Remarks, Hdr.NoCartons,
		Dtl.CustItemNo, Dtl.ItemNo, Dtl.ItemDsc, Dtl.QtyShipped, Dtl.IMLoc, Dtl.QtyOrdered, Dtl.QtyAvail1,
		cast(cast(Dtl.SellStkFactor as decimal(18,0)) AS Varchar(10)) + '/' + Dtl.SellStkUM AS BaseUOM,
		cast(cast(Dtl.AlternateUMQty as decimal(18,0)) AS Varchar(10)) + '/' + Dtl.AlternateUM AS SuperEQV,
		Dtl.NetUnitPrice, Dtl.ExtendedNetWght, Dtl.ExtendedGrossWght, Loc.LocName, Dtl.ExtendedPrice,
		Dtl.LineNumber, Dtl.Remark, Dtl.AlternateUMQty, Dtl.AlternateUM,
		CASE Dtl.ExtendedGrossWght
		   WHEN 0 THEN 0
			  ELSE Dtl.ExtendedPrice / Dtl.ExtendedGrossWght
		END AS PricePerLB,
		CASE Dtl.ExtendedPrice
		   WHEN 0 THEN 0
			  ELSE ((Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedPrice) * 100
		END AS MarginPct,
		CASE Dtl.ExtendedGrossWght
		   WHEN 0 THEN 0
			  ELSE (Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedGrossWght
		END AS MarginPerLb,
		Dtl.DeleteDt, Cust.MinBillAmt, Cust.ContractNo
	INTO	tSORecall
	FROM	SOHeaderHist Hdr LEFT OUTER JOIN
		SODetailHist Dtl ON Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID LEFT OUTER JOIN
		LocMaster Loc ON Loc.LocID = Dtl.IMLoc LEFT OUTER JOIN
		CustomerMaster Cust ON Cust.CustNo = Hdr.SellToCustNo
	WHERE	OrderNo=@DocNo
   END
IF (@@RowCount > 0) GOTO FoundData


SOTables:

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tSORecall]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tSORecall]

--SO Tables
IF (@DocType = 'I')
   BEGIN	--Search By Invoice
	SELECT	'SO' AS SOTable, Hdr.pSOHeaderID AS HeaderID, Hdr.fSOHeaderID AS OrigOrderNo, Hdr.BillToCustNo,
		Hdr.OrderNo, Hdr.InvoiceNo, Hdr.OrderTypeDsc, Hdr.OrderDt, Hdr.ShipLoc, Hdr.SellToCustName, Hdr.SellToCustNo,
		Hdr.SellToAddress1, Hdr.SellToCity, Hdr.SellToState, Hdr.SellToZip, Hdr.SellToCountry, Hdr.SellToContactPhoneNo,
		Hdr.SellToContactName, Hdr.OrderTermsCd, Hdr.OrderTermsName, Hdr.ShipToName, Hdr.ShipToCd, Hdr.ShipToAddress1,
		Hdr.City, Hdr.State, Hdr.Zip, Hdr.Country, Hdr.PhoneNo, Hdr.ContactName, Hdr.TotalOrder, Hdr.TotalCost, Hdr.ShipWght,
		Hdr.CustPONo, Hdr.CustReqDt, Hdr.ConfirmShipDt, Hdr.OrderExpdCd, Hdr.OrderExpdCdName, Hdr.ShipInstrCd, Hdr.ShipInstrCdName,
		Hdr.InvoiceDt, Hdr.OrderCarrier, Hdr.OrderCarName, Hdr.BOLNO, Hdr.OrderFreightCd, Hdr.OrderFreightName, Hdr.OrderPriorityCd,
		Hdr.OrderPriName, Hdr.HoldReason, Hdr.HoldReasonName, Hdr.AllocDt, Hdr.PrintDt, Hdr.DeleteDt AS DeleteDtHdr, Hdr.OrigShipDt,
		Hdr.TaxExpAmt, Hdr.NonTaxExpAmt, ShippingMark1, ShippingMark2, ShippingMark3, ShippingMark4, Hdr.Remarks, Hdr.NoCartons,
		Dtl.CustItemNo, Dtl.ItemNo, Dtl.ItemDsc, Dtl.QtyShipped, Dtl.IMLoc, Dtl.QtyOrdered, Dtl.QtyAvail1,
		cast(cast(Dtl.SellStkFactor as decimal(18,0)) AS Varchar(10)) + '/' + Dtl.SellStkUM AS BaseUOM,
		cast(cast(Dtl.AlternateUMQty as decimal(18,0)) AS Varchar(10)) + '/' + Dtl.AlternateUM AS SuperEQV,
		Dtl.NetUnitPrice, Dtl.ExtendedNetWght, Dtl.ExtendedGrossWght, Loc.LocName, Dtl.ExtendedPrice,
		Dtl.LineNumber, Dtl.Remark, Dtl.AlternateUMQty, Dtl.AlternateUM,
		CASE Dtl.ExtendedGrossWght
		   WHEN 0 THEN 0
			  ELSE Dtl.ExtendedPrice / Dtl.ExtendedGrossWght
		END AS PricePerLB,
		CASE Dtl.ExtendedPrice
		   WHEN 0 THEN 0
			  ELSE ((Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedPrice) * 100
		END AS MarginPct,
		CASE Dtl.ExtendedGrossWght
		   WHEN 0 THEN 0
			  ELSE (Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedGrossWght
		END AS MarginPerLb,
		Dtl.DeleteDt, Cust.MinBillAmt, Cust.ContractNo
	INTO	tSORecall
	FROM	SOHeader Hdr LEFT OUTER JOIN
		SODetail Dtl ON Hdr.pSOHeaderID = Dtl.fSOHeaderID LEFT OUTER JOIN
		LocMaster Loc ON Loc.LocID = Dtl.IMLoc LEFT OUTER JOIN
		CustomerMaster Cust ON Cust.CustNo = Hdr.SellToCustNo
	WHERE	InvoiceNo=@DocNo
   END
ELSE
   BEGIN	--Search By Order
	SELECT	'SO' AS SOTable, Hdr.pSOHeaderID AS HeaderID, Hdr.fSOHeaderID AS OrigOrderNo, Hdr.BillToCustNo,
		Hdr.OrderNo, Hdr.InvoiceNo, Hdr.OrderTypeDsc, Hdr.OrderDt, Hdr.ShipLoc, Hdr.SellToCustName, Hdr.SellToCustNo,
		Hdr.SellToAddress1, Hdr.SellToCity, Hdr.SellToState, Hdr.SellToZip, Hdr.SellToCountry, Hdr.SellToContactPhoneNo,
		Hdr.SellToContactName, Hdr.OrderTermsCd, Hdr.OrderTermsName, Hdr.ShipToName, Hdr.ShipToCd, Hdr.ShipToAddress1,
		Hdr.City, Hdr.State, Hdr.Zip, Hdr.Country, Hdr.PhoneNo, Hdr.ContactName, Hdr.TotalOrder, Hdr.TotalCost, Hdr.ShipWght,
		Hdr.CustPONo, Hdr.CustReqDt, Hdr.ConfirmShipDt, Hdr.OrderExpdCd, Hdr.OrderExpdCdName, Hdr.ShipInstrCd, Hdr.ShipInstrCdName,
		Hdr.InvoiceDt, Hdr.OrderCarrier, Hdr.OrderCarName, Hdr.BOLNO, Hdr.OrderFreightCd, Hdr.OrderFreightName, Hdr.OrderPriorityCd,
		Hdr.OrderPriName, Hdr.HoldReason, Hdr.HoldReasonName, Hdr.AllocDt, Hdr.PrintDt, Hdr.DeleteDt AS DeleteDtHdr, Hdr.OrigShipDt,
		Hdr.TaxExpAmt, Hdr.NonTaxExpAmt, ShippingMark1, ShippingMark2, ShippingMark3, ShippingMark4, Hdr.Remarks, Hdr.NoCartons,
		Dtl.CustItemNo, Dtl.ItemNo, Dtl.ItemDsc, Dtl.QtyShipped, Dtl.IMLoc, Dtl.QtyOrdered, Dtl.QtyAvail1,
		cast(cast(Dtl.SellStkFactor as decimal(18,0)) AS Varchar(10)) + '/' + Dtl.SellStkUM AS BaseUOM,
		cast(cast(Dtl.AlternateUMQty as decimal(18,0)) AS Varchar(10)) + '/' + Dtl.AlternateUM AS SuperEQV,
		Dtl.NetUnitPrice, Dtl.ExtendedNetWght, Dtl.ExtendedGrossWght, Loc.LocName, Dtl.ExtendedPrice,
		Dtl.LineNumber, Dtl.Remark, Dtl.AlternateUMQty, Dtl.AlternateUM,
		CASE Dtl.ExtendedGrossWght
		   WHEN 0 THEN 0
			  ELSE Dtl.ExtendedPrice / Dtl.ExtendedGrossWght
		END AS PricePerLB,
		CASE Dtl.ExtendedPrice
		   WHEN 0 THEN 0
			  ELSE ((Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedPrice) * 100
		END AS MarginPct,
		CASE Dtl.ExtendedGrossWght
		   WHEN 0 THEN 0
			  ELSE (Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedGrossWght
		END AS MarginPerLb,
		Dtl.DeleteDt, Cust.MinBillAmt, Cust.ContractNo
	INTO	tSORecall
	FROM	SOHeader Hdr LEFT OUTER JOIN
		SODetail Dtl ON Hdr.pSOHeaderID = Dtl.fSOHeaderID LEFT OUTER JOIN
		LocMaster Loc ON Loc.LocID = Dtl.IMLoc LEFT OUTER JOIN
		CustomerMaster Cust ON Cust.CustNo = Hdr.SellToCustNo
	WHERE	OrderNo=@DocNo
   END
IF (@@RowCount > 0) GOTO FoundData


FoundData:

SELECT	*
FROM	tSORecall

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tSORecall]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tSORecall]

GO