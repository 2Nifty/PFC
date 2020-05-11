



	SELECT	'SOHist' AS SOTable, Hdr.pSOHeaderHistID,
		Hdr.OrderNo, Hdr.InvoiceNo, Hdr.OrderTypeDsc, Hdr.OrderDt, Hdr.ShipLoc, Hdr.SellToCustName, Hdr.SellToCustNo, Hdr.SellToAddress1, 
		Hdr.SellToCity, Hdr.SellToState, Hdr.SellToZip, Hdr.SellToCountry, Hdr.SellToContactPhoneNo, Hdr.SellToContactName, Hdr.OrderTermsCd, 
		Hdr.OrderTermsName, Hdr.ShipToName, Hdr.ShipToCd, Hdr.ShipToAddress1, Hdr.City, Hdr.State, Hdr.Zip, Hdr.Country, Hdr.PhoneNo, 
		Hdr.ContactName, Hdr.TotalOrder, Hdr.TotalCost, Hdr.ShipWght, Hdr.CustPONo, Hdr.CustReqDt, Hdr.ConfirmShipDt, Hdr.OrderExpdCd, 
		Hdr.OrderExpdCdName, Hdr.ShipInstrCd, Hdr.ShipInstrCdName, Hdr.InvoiceDt, Hdr.OrderCarrier, Hdr.OrderCarName, Hdr.BOLNO, Hdr.OrderFreightCd, 
		Hdr.OrderFreightName, Hdr.OrderPriorityCd, Hdr.OrderPriName, Hdr.HoldReason, Hdr.HoldReasonName, Hdr.AllocDt, Hdr.PrintDt, Hdr.DeleteDt, 
		Dtl.CustItemNo, Dtl.ItemNo, Dtl.ItemDsc, Dtl.IMLoc, Dtl.QtyOrdered, Dtl.SellStkUM + '/' + Dtl.SellStkFactor AS BaseUOM, 
		Dtl.AlternateUM + '/' + Dtl.AlternateUMQty AS SuperEQV, Dtl.NetUnitPrice, Dtl.ExtendedNetWght, Loc.LocName, Dtl.ExtendedPrice, Dtl.LineNumber, 
		Dtl.Remark, Dtl.AlternateUMQty, Dtl.AlternateUM,
		CASE Dtl.ExtendedNetWght
		   WHEN 0 THEN 0
			  ELSE Dtl.ExtendedPrice / Dtl.ExtendedNetWght
		END AS PricePerLB,
		CASE Dtl.ExtendedPrice
		   WHEN 0 THEN 0
			  ELSE ((Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedPrice) * 100
		END AS MarginPct,
		CASE Dtl.ExtendedNetWght
		   WHEN 0 THEN 0
			  ELSE (Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedNetWght
		END AS MarginPerLb,
		Dtl.DeleteDt
	FROM	SOHeaderHist Hdr inner JOIN
		SODetailHist Dtl ON Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID left outer join
		LocMaster Loc ON Loc.LocID = Dtl.IMLoc
	WHERE	InvoiceNo='IP2433936'




	SELECT	*
	FROM	SOExpenseHist Ex
	WHERE	Ex.fSOHeaderHistID=832412

	SELECT	'SOHist' AS SOTable, Ex.fSOHeaderHistID, --*
		'' AS OrderNo, '' AS InvoiceNo,

		TaxStatus AS OrderTypeDsc, null AS OrderDt, '' AS ShipLoc, '' AS SellToCustName, '' AS SellToCustNo, '' AS SellToAddress1, 
		'' AS SellToCity, '' AS SellToState, '' AS SellToZip, '' AS SellToCountry, '' AS SellToContactPhoneNo, '' As SellToContactName,
		'' AS OrderTermsCd, 
		'' AS OrderTermsName, '' AS ShipToName, '' AS ShipToCd, '' AS ShipToAddress1, '' AS City, '' AS State, '' AS Zip, '' AS Country, '' AS PhoneNo, 
		'' AS ContactName, null AS TotalOrder, null AS TotalCost, null AS ShipWght, '' AS CustPONo, null AS CustReqDt, null AS ConfirmShipDt,
		'' AS OrderExpdCd, 
		'' AS OrderExpdCdName, '' AS ShipInstrCd, '' AS ShipInstrCdName, null AS InvoiceDt, '' AS OrderCarrier, '' AS OrderCarName, '' AS BOLNO,
		'' AS OrderFreightCd, 
		'' AS OrderFreightName, '' AS OrderPriorityCd, '' AS OrderPriName, '' AS HoldReason, '' AS HoldReasonName, null AS AllocDt, null AS PrintDt,
		null AS DeleteDtHdr, 
		'' AS CustItemNo, ExpenseCd AS ItemNo, '' AS ItemDsc, '' AS IMLoc, null AS QtyOrdered, '' AS BaseUOM, 
		'' AS SuperEQV, null AS NetUnitPrice, null AS ExtendedNetWght, '' AS LocName, Amount AS ExtendedPrice, LineNumber, 
		'' AS Remark, null AS AlternateUMQty, '' AS AlternateUM,
		null AS PricePerLB, null AS MarginPct, null AS MarginPerLb,
		DeleteDt
	FROM	SOExpenseHist Ex
	WHERE	Ex.fSOHeaderHistID=832412





	SELECT	'SOHist' AS SOTable, Hdr.pSOHeaderHistID,
		Hdr.OrderNo, Hdr.InvoiceNo, Hdr.OrderTypeDsc, Hdr.OrderDt, Hdr.ShipLoc, Hdr.SellToCustName, Hdr.SellToCustNo, Hdr.SellToAddress1, 
		Hdr.SellToCity, Hdr.SellToState, Hdr.SellToZip, Hdr.SellToCountry, Hdr.SellToContactPhoneNo, Hdr.SellToContactName, Hdr.OrderTermsCd, 
		Hdr.OrderTermsName, Hdr.ShipToName, Hdr.ShipToCd, Hdr.ShipToAddress1, Hdr.City, Hdr.State, Hdr.Zip, Hdr.Country, Hdr.PhoneNo, 
		Hdr.ContactName, Hdr.TotalOrder, Hdr.TotalCost, Hdr.ShipWght, Hdr.CustPONo, Hdr.CustReqDt, Hdr.ConfirmShipDt, Hdr.OrderExpdCd, 
		Hdr.OrderExpdCdName, Hdr.ShipInstrCd, Hdr.ShipInstrCdName, Hdr.InvoiceDt, Hdr.OrderCarrier, Hdr.OrderCarName, Hdr.BOLNO, Hdr.OrderFreightCd, 
		Hdr.OrderFreightName, Hdr.OrderPriorityCd, Hdr.OrderPriName, Hdr.HoldReason, Hdr.HoldReasonName, Hdr.AllocDt, Hdr.PrintDt, Hdr.DeleteDt, 

		' ' AS CustItemNo, Ex.ExpenseCd AS ItemNo, ' ' AS ItemDsc, ' ' AS IMLoc, Dtl.QtyOrdered, Dtl.SellStkUM + '/' + Dtl.SellStkFactor AS BaseUOM, 
		Dtl.AlternateUM + '/' + Dtl.AlternateUMQty AS SuperEQV, Dtl.NetUnitPrice, Dtl.ExtendedNetWght, ' ' AS LocName, Dtl.ExtendedPrice, Dtl.LineNumber, 
		Dtl.Remark, Dtl.AlternateUMQty, Dtl.AlternateUM,
		CASE Dtl.ExtendedNetWght
		   WHEN 0 THEN 0
			  ELSE Dtl.ExtendedPrice / Dtl.ExtendedNetWght
		END AS PricePerLB,
		CASE Dtl.ExtendedPrice
		   WHEN 0 THEN 0
			  ELSE ((Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedPrice) * 100
		END AS MarginPct,
		CASE Dtl.ExtendedNetWght
		   WHEN 0 THEN 0
			  ELSE (Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedNetWght
		END AS MarginPerLb,
		Dtl.DeleteDt

, Ex.LineNumber AS ExpenseLine, ExpenseNo, ExpenseCd, Ex.Amount AS ExpenseAmount, Ex.Cost AS ExpenseCost, ExpenseInd,
Ex.TaxStatus AS ExpenseTaxStatus, DeliveryCharge, HandlingCharge, PackagingCharge, MiscCharge, PhoneCharge, DocumentLoc, Ex.DeleteDt AS ExpenseDeleteDt,
Ex.StatusCd AS ExpenseStatusCd

	FROM	SOHeaderHist Hdr inner JOIN
		SOExpenseHist Ex ON Hdr.pSOHeaderHistID = Ex.fSOHeaderHistID
	WHERE	InvoiceNo='IP2433936'



	SELECT	'SOHist' AS SOTable, Hdr.pSOHeaderHistID,
		Hdr.OrderNo, Hdr.InvoiceNo, Hdr.OrderTypeDsc, Hdr.OrderDt, Hdr.ShipLoc, Hdr.SellToCustName, Hdr.SellToCustNo, Hdr.SellToAddress1, 
		Hdr.SellToCity, Hdr.SellToState, Hdr.SellToZip, Hdr.SellToCountry, Hdr.SellToContactPhoneNo, Hdr.SellToContactName, Hdr.OrderTermsCd, 
		Hdr.OrderTermsName, Hdr.ShipToName, Hdr.ShipToCd, Hdr.ShipToAddress1, Hdr.City, Hdr.State, Hdr.Zip, Hdr.Country, Hdr.PhoneNo, 
		Hdr.ContactName, Hdr.TotalOrder, Hdr.TotalCost, Hdr.ShipWght, Hdr.CustPONo, Hdr.CustReqDt, Hdr.ConfirmShipDt, Hdr.OrderExpdCd, 
		Hdr.OrderExpdCdName, Hdr.ShipInstrCd, Hdr.ShipInstrCdName, Hdr.InvoiceDt, Hdr.OrderCarrier, Hdr.OrderCarName, Hdr.BOLNO, Hdr.OrderFreightCd, 
		Hdr.OrderFreightName, Hdr.OrderPriorityCd, Hdr.OrderPriName, Hdr.HoldReason, Hdr.HoldReasonName, Hdr.AllocDt, Hdr.PrintDt, Hdr.DeleteDt, 
		Dtl.CustItemNo, Dtl.ItemNo, Dtl.ItemDsc, Dtl.IMLoc, Dtl.QtyOrdered, Dtl.SellStkUM + '/' + Dtl.SellStkFactor AS BaseUOM, 
		Dtl.AlternateUM + '/' + Dtl.AlternateUMQty AS SuperEQV, Dtl.NetUnitPrice, Dtl.ExtendedNetWght, Loc.LocName, Dtl.ExtendedPrice, Dtl.LineNumber, 
		Dtl.Remark, Dtl.AlternateUMQty, Dtl.AlternateUM,
		CASE Dtl.ExtendedNetWght
		   WHEN 0 THEN 0
			  ELSE Dtl.ExtendedPrice / Dtl.ExtendedNetWght
		END AS PricePerLB,
		CASE Dtl.ExtendedPrice
		   WHEN 0 THEN 0
			  ELSE ((Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedPrice) * 100
		END AS MarginPct,
		CASE Dtl.ExtendedNetWght
		   WHEN 0 THEN 0
			  ELSE (Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedNetWght
		END AS MarginPerLb,
		Dtl.DeleteDt

, 0 AS ExpenseLine, 0 AS ExpenseNo, ' ' AS ExpenseCd, 0 AS ExpenseAmount, 0 AS ExpenseCost, ' ' AS ExpenseInd,
' ' AS ExpenseTaxStatus, 0 AS DeliveryCharge, 0 AS HandlingCharge, 0 AS PackagingCharge, 0 AS MiscCharge, 0 AS PhoneCharge,
' ' AS DocumentLoc, ' ' AS ExpenseDeleteDt, ' ' AS ExpenseStatusCd

	FROM	SOHeaderHist Hdr inner JOIN
		SODetailHist Dtl ON Hdr.pSOHeaderHistID = Dtl.fSOHeaderHistID left outer join
		LocMaster Loc ON Loc.LocID = Dtl.IMLoc
	WHERE	InvoiceNo='IP2433936'