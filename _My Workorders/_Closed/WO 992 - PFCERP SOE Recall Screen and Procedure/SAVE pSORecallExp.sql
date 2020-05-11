
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pSORecallExp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pSORecallExp]
GO

CREATE procedure [dbo].[pSORecallExp]
@RecID varchar(20),
@SOTable varchar(20)
as

----pSORecallExp
----Written By: Tod Dixon
----Application: Sales Management

--SOExpenseHist
IF (@SOTable = 'SOHist')
   BEGIN
	SELECT	'SOHist' AS SOTable, fSOHeaderHistID,
		cast(null AS numeric) AS OrderNo, '' AS InvoiceNo, TaxStatus AS OrderTypeDsc, cast(null AS datetime) AS OrderDt,
		'' AS ShipLoc, '' AS SellToCustName, '' AS SellToCustNo, '' AS SellToAddress1, '' AS SellToCity, '' AS SellToState,
		'' AS SellToZip, '' AS SellToCountry, '' AS SellToContactPhoneNo, '' As SellToContactName, '' AS OrderTermsCd, 
		'' AS OrderTermsName, '' AS ShipToName, '' AS ShipToCd, '' AS ShipToAddress1, '' AS City, '' AS State, '' AS Zip,
		'' AS Country, '' AS PhoneNo, '' AS ContactName, cast(null AS numeric) AS TotalOrder, cast(null AS numeric) AS TotalCost,
		cast(null AS numeric) AS ShipWght, '' AS CustPONo, cast(null AS datetime) AS CustReqDt, cast(null AS datetime) AS ConfirmShipDt,
		'' AS OrderExpdCd, '' AS OrderExpdCdName, '' AS ShipInstrCd, '' AS ShipInstrCdName, cast(null AS datetime) AS InvoiceDt,
		'' AS OrderCarrier, '' AS OrderCarName, '' AS BOLNO, '' AS OrderFreightCd, '' AS OrderFreightName, '' AS OrderPriorityCd,
		'' AS OrderPriName, '' AS HoldReason, '' AS HoldReasonName, cast(null AS datetime) AS AllocDt, cast(null AS datetime) AS PrintDt,
		cast(null AS datetime) AS DeleteDtHdr,
		'' AS CustItemNo, ExpenseCd AS ItemNo, '' AS ItemDsc, '' AS IMLoc, cast(null AS numeric) AS QtyOrdered,
		cast('' AS varchar(10)) AS BaseUOM, cast('' AS varchar(10)) AS SuperEQV, cast(null AS numeric) AS NetUnitPrice,
		cast(null AS numeric) AS ExtendedNetWght, '' AS LocName, cast(Amount AS decimal(18,6)) AS ExtendedPrice, LineNumber, 
		'' AS Remark, cast(null AS decimal(18,6)) AS AlternateUMQty, '' AS AlternateUM, cast(null AS numeric) AS PricePerLB,
		cast(null AS numeric) AS MarginPct, cast(null AS numeric) AS MarginPerLb, DeleteDt
	FROM	SOExpenseHist
	WHERE	fSOHeaderHistID=@RecID
   END


--SOExpense
IF (@SOTable = 'SO')
   BEGIN
	SELECT	*
	FROM	SOExpense
	WHERE	fSOHeaderID=@RecID
   END


--SOExpenseRel
IF (@SOTable = 'SORel')
   BEGIN
	SELECT	*
	FROM	SOExpenseRel
	WHERE	fSOHeaderRelID=@RecID
   END

GO