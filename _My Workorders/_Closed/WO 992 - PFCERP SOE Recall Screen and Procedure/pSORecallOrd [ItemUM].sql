SELECT Hdr.fSOHeaderID AS OrigOrderNo, Hdr.BillToCustNo,
	Hdr.OrderNo, Hdr.InvoiceNo, Hdr.OrderTypeDsc, Hdr.OrderDt, Hdr.ShipLoc, Hdr.SellToCustName, Hdr.SellToCustNo,
	Hdr.SellToAddress1, Hdr.SellToCity, Hdr.SellToState, Hdr.SellToZip, Hdr.SellToCountry, Hdr.SellToContactPhoneNo,
	Hdr.SellToContactName, Hdr.OrderTermsCd, Hdr.OrderTermsName, Hdr.ShipToName, Hdr.ShipToCd, Hdr.ShipToAddress1,
	Hdr.City, Hdr.State, Hdr.Zip, Hdr.Country, Hdr.PhoneNo, Hdr.ContactName, Hdr.TotalOrder, Hdr.TotalCost, Hdr.ShipWght, Hdr.BolWght,
	Hdr.CustPONo, Hdr.CustReqDt, Hdr.ConfirmShipDt, Hdr.OrderExpdCd, Hdr.OrderExpdCdName, Hdr.ShipInstrCd, Hdr.ShipInstrCdName,
	Hdr.InvoiceDt, Hdr.OrderCarrier, Hdr.OrderCarName, Hdr.BOLNO, Hdr.OrderFreightCd, Hdr.OrderFreightName, Hdr.OrderPriorityCd,
	Hdr.OrderPriName, Hdr.HoldReason, Hdr.HoldReasonName, Hdr.AllocDt, Hdr.PrintDt, Hdr.DeleteDt AS DeleteDtHdr, Hdr.OrigShipDt,
	Hdr.TaxExpAmt, Hdr.NonTaxExpAmt, ShippingMark1, ShippingMark2, ShippingMark3, ShippingMark4, Hdr.Remarks, Hdr.NoCartons,
	Dtl.CustItemNo, Dtl.ItemNo, Dtl.ItemDsc, Dtl.QtyShipped, Dtl.IMLoc, Dtl.QtyOrdered, Dtl.QtyAvail1,
	cast(cast(Dtl.SellStkQty as decimal(18,0)) AS Varchar(10)) + '/' + Dtl.SellStkUM AS BaseUOM,
	cast(cast(Dtl.SuperEquivQty as decimal(18,0)) AS Varchar(10)) + '/' + Dtl.SuperEquivUM AS SuperEQV,
	Dtl.NetUnitPrice, Dtl.ExtendedNetWght, Dtl.ExtendedGrossWght, Loc.LocName, Dtl.ExtendedPrice,
	Dtl.LineNumber, Dtl.Remark, Dtl.AlternateUMQty, Dtl.AlternateUM, Dtl.SellStkQty * Dtl.QtyShipped AS TotalPcs,
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
	Dtl.DeleteDt, Cust.MinBillAmt, Cust.ContractNo, UM.UM

 FROM	 SOHeader Hdr LEFT OUTER JOIN
	 SODetail Dtl ON  pSOHeaderID =  Dtl.fSOHeaderID  LEFT OUTER JOIN
	LocMaster Loc ON Loc.LocID = Dtl.IMLoc LEFT OUTER JOIN
	CustomerMaster Cust ON Cust.CustNo = Hdr.SellToCustNo LEFT OUTER JOIN
	ItemMaster Item ON Item.ItemNo = Dtl.ItemNo LEFT OUTER JOIN
	ItemUM UM ON UM.fItemMasterID = Item.pItemMasterID AND UM.AltSellStkUMQty = Dtl.SellStkQty
 WHERE  OrderNo=1340