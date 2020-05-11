
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pSOERecallOrd]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pSOERecallOrd]
GO


CREATE procedure [dbo].[pSOERecallOrd]
@DocNo varchar(20),
@DocType char(2),
@TempTable varchar(50)
as
----pSOERecallOrd
----Written By: Tod Dixon
----Application: Sales Management
----Change By: Charle/Tod 08/18/09
----Commented out use of LocMaster


DECLARE @Query nvarchar(4000),
	@Drop nvarchar(500),
	@TableType varchar(10),
	@HeaderTable varchar(50),
	@DetailTable varchar(50),
	@HeaderID varchar(20),
	@DetailID varchar(20),
	@SelColumn varchar(20),
	@InvoiceDt datetime


IF (@DocType = 'I')
   BEGIN	--Search By Invoice
	SET	@SelColumn = 'InvoiceNo'
   END
ELSE
   BEGIN	--Search By Order
	SET	@SelColumn = 'OrderNo'
   END

IF (@DocType = 'NV') SET @SelColumn = 'RefSONo'

IF (@DocType = 'O') GOTO SOTables


---------------------------------------------------------------------------------------------------------------------

SET @Drop = 'IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id=object_id(N''[dbo].' + quotename(@TempTable) + ''') AND OBJECTPROPERTY(id, N''IsUserTable'')=1) DROP TABLE [dbo].' + quotename(@TempTable)
EXEC sp_ExecuteSQL @Drop

--SORel Tables
SET	@TableType = 'SORel'
SET	@HeaderTable = 'SOHeaderRel'
SET	@DetailTable = 'SODetailRel'
SET	@HeaderID = 'Hdr.pSOHeaderRelID'
SET	@DetailID = 'Dtl.fSOHeaderRelID'


--Check if Released Document has InvoiceDt set
SET @Query = ' SELECT @InvoiceDt=InvoiceDt FROM ' + quotename(@HeaderTable) + ' WHERE ' + @SelColumn + '=@SelDocNo'
EXEC sp_ExecuteSQL @Query, N'@InvoiceDt VARCHAR(20) OUTPUT, @SelDocNo varchar(20)', @InvoiceDt OUTPUT, @DocNo

--If InvoiceDt is set, read Hist Tables
IF ((@InvoiceDt) IS NOT NULL AND (@InvoiceDt) <> '') GOTO HistTables


SET @Query =	' SELECT @SelTableType AS SOTable, ' + @HeaderID + ' AS HeaderID, Hdr.fSOHeaderID AS OrigOrderNo, Hdr.BillToCustNo, Hdr.BillToCustName,' +
		'	Hdr.OrderNo, Hdr.InvoiceNo, Hdr.OrderTypeDsc, Hdr.OrderDt, Hdr.ShipLoc, Hdr.SellToCustName, Hdr.SellToCustNo,' +
		'	Hdr.SellToAddress1, Hdr.SellToCity, Hdr.SellToState, Hdr.SellToZip, Hdr.SellToCountry, Hdr.SellToContactPhoneNo,' +
		'	Hdr.SellToContactName, Hdr.OrderTermsCd, Hdr.OrderTermsName, Hdr.ShipToName, Hdr.ShipToCd, Hdr.ShipToAddress1,' +
		'	Hdr.City, Hdr.State, Hdr.Zip, Hdr.Country, Hdr.PhoneNo, Hdr.ContactName, Hdr.TotalOrder, Hdr.TotalCost, Hdr.ShipWght, Hdr.BolWght,' +
		'	Hdr.CustPONo, Hdr.CustReqDt, Hdr.ConfirmShipDt, Hdr.OrderExpdCd, Hdr.OrderExpdCdName, Hdr.ShipInstrCd, Hdr.ShipInstrCdName,' +
		'	Hdr.InvoiceDt, Hdr.OrderCarrier, Hdr.OrderCarName, Hdr.BOLNO, Hdr.OrderFreightCd, Hdr.OrderFreightName, Hdr.OrderPriorityCd,' +
		'	Hdr.OrderPriName, Hdr.HoldReason, Hdr.HoldReasonName, Hdr.AllocDt, Hdr.PrintDt, Hdr.DeleteDt AS DeleteDtHdr, Hdr.OrigShipDt,' +
		'	Hdr.TaxExpAmt, Hdr.NonTaxExpAmt, ShippingMark1, ShippingMark2, ShippingMark3, ShippingMark4, Hdr.Remarks, Hdr.NoCartons,' +
		'	Hdr.RefSONo, Hdr.ReferenceNo, Dtl.CustItemNo, Dtl.ItemNo, Dtl.ItemDsc, Dtl.QtyShipped, Dtl.IMLoc, Dtl.QtyOrdered, Dtl.QtyAvail1,' +
		'	cast(cast(Dtl.SellStkQty as decimal(18,0)) AS Varchar(10)) + ISNULL(Dtl.StkUM,''  '') + ''/'' + Dtl.SellStkUM AS BaseUOM,' +
		'	cast(cast(Dtl.SuperEquivQty as decimal(18,0)) AS Varchar(10)) + ''/'' + Dtl.SuperEquivUM AS SuperEQV,' +
		'	Dtl.NetUnitPrice, Dtl.AlternatePrice, Dtl.ExtendedNetWght, Dtl.ExtendedGrossWght, Dtl.IMLocName as LocName, Dtl.ExtendedPrice,' +
		'	Dtl.LineNumber, Dtl.Remark, Dtl.AlternateUMQty, Dtl.AlternateUM, Dtl.SellStkQty * Dtl.QtyShipped AS TotalPcs,' +
		'	CASE Dtl.ExtendedGrossWght' +
		'	   WHEN 0 THEN 0' +
		'		  ELSE Dtl.ExtendedPrice / Dtl.ExtendedGrossWght' +
		'	END AS PricePerLB,' +
		'	CASE Dtl.ExtendedPrice' +
		'	   WHEN 0 THEN 0' +
		'		  ELSE ((Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedPrice) * 100' +
		'	END AS MarginPct,' +
		'	CASE Dtl.ExtendedGrossWght' +
		'	   WHEN 0 THEN 0' +
		'		  ELSE (Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedGrossWght' +
		'	END AS MarginPerLb,' +
		'	Dtl.DeleteDt, Dtl.StkUM, Cust.MinBillAmt, Cust.ContractNo' +
		' INTO	' + quotename(@TempTable) +
		' FROM	' + quotename(@HeaderTable) + ' Hdr WITH (NOLOCK) LEFT OUTER JOIN' +
		'	' + quotename(@DetailTable) + ' Dtl WITH (NOLOCK) ON ' + @HeaderID + ' = ' + @DetailID + ' LEFT OUTER JOIN' +
--		'	LocMaster Loc WITH (NOLOCK) ON Loc.LocID = Dtl.IMLoc LEFT OUTER JOIN' +
		'	CustomerMaster Cust WITH (NOLOCK) ON Cust.CustNo = Hdr.SellToCustNo' +
		' WHERE ' + @SelColumn + '=@SelDocNo'

EXEC 	sp_ExecuteSQL @Query, N'@SelTableType varchar(10), @SelDocNo varchar(20)', @TableType, @DocNo

IF (@@RowCount > 0) GOTO FoundData

---------------------------------------------------------------------------------------------------------------------

HistTables:

SET @Drop = 'IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id=object_id(N''[dbo].' + quotename(@TempTable) + ''') AND OBJECTPROPERTY(id, N''IsUserTable'')=1) DROP TABLE [dbo].' + quotename(@TempTable)
EXEC sp_ExecuteSQL @Drop

--SOHist Tables
SET	@TableType = 'SOHist'
SET	@HeaderTable = 'SOHeaderHist'
SET	@DetailTable = 'SODetailHist'
SET	@HeaderID = 'Hdr.pSOHeaderHistID'
SET	@DetailID = 'Dtl.fSOHeaderHistID'

SET @Query =	' SELECT @SelTableType AS SOTable, ' + @HeaderID + ' AS HeaderID, Hdr.fSOHeaderID AS OrigOrderNo, Hdr.BillToCustNo, Hdr.BillToCustName,' +
		'	Hdr.OrderNo, Hdr.InvoiceNo, Hdr.OrderTypeDsc, Hdr.OrderDt, Hdr.ShipLoc, Hdr.SellToCustName, Hdr.SellToCustNo,' +
		'	Hdr.SellToAddress1, Hdr.SellToCity, Hdr.SellToState, Hdr.SellToZip, Hdr.SellToCountry, Hdr.SellToContactPhoneNo,' +
		'	Hdr.SellToContactName, Hdr.OrderTermsCd, Hdr.OrderTermsName, Hdr.ShipToName, Hdr.ShipToCd, Hdr.ShipToAddress1,' +
		'	Hdr.City, Hdr.State, Hdr.Zip, Hdr.Country, Hdr.PhoneNo, Hdr.ContactName, Hdr.TotalOrder, Hdr.TotalCost, Hdr.ShipWght, Hdr.BolWght,' +
		'	Hdr.CustPONo, Hdr.CustReqDt, Hdr.ConfirmShipDt, Hdr.OrderExpdCd, Hdr.OrderExpdCdName, Hdr.ShipInstrCd, Hdr.ShipInstrCdName,' +
		'	Hdr.InvoiceDt, Hdr.OrderCarrier, Hdr.OrderCarName, Hdr.BOLNO, Hdr.OrderFreightCd, Hdr.OrderFreightName, Hdr.OrderPriorityCd,' +
		'	Hdr.OrderPriName, Hdr.HoldReason, Hdr.HoldReasonName, Hdr.AllocDt, Hdr.PrintDt, Hdr.DeleteDt AS DeleteDtHdr, Hdr.OrigShipDt,' +
		'	Hdr.TaxExpAmt, Hdr.NonTaxExpAmt, ShippingMark1, ShippingMark2, ShippingMark3, ShippingMark4, Hdr.Remarks, Hdr.NoCartons,' +
		'	Hdr.RefSONo, Hdr.ReferenceNo, Dtl.CustItemNo, Dtl.ItemNo, Dtl.ItemDsc, Dtl.QtyShipped, Dtl.IMLoc, Dtl.QtyOrdered, Dtl.QtyAvail1,' +
		'	cast(cast(Dtl.SellStkQty as decimal(18,0)) AS Varchar(10)) + ISNULL(Dtl.StkUM,''  '') + ''/'' + Dtl.SellStkUM AS BaseUOM,' +
		'	cast(cast(Dtl.SuperEquivQty as decimal(18,0)) AS Varchar(10)) + ''/'' + Dtl.SuperEquivUM AS SuperEQV,' +
		'	Dtl.NetUnitPrice, Dtl.AlternatePrice, Dtl.ExtendedNetWght, Dtl.ExtendedGrossWght, Dtl.IMLocName as LocName, Dtl.ExtendedPrice,' +
		'	Dtl.LineNumber, Dtl.Remark, Dtl.AlternateUMQty, Dtl.AlternateUM, Dtl.SellStkQty * Dtl.QtyShipped AS TotalPcs,' +
		'	CASE Dtl.ExtendedGrossWght' +
		'	   WHEN 0 THEN 0' +
		'		  ELSE Dtl.ExtendedPrice / Dtl.ExtendedGrossWght' +
		'	END AS PricePerLB,' +
		'	CASE Dtl.ExtendedPrice' +
		'	   WHEN 0 THEN 0' +
		'		  ELSE ((Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedPrice) * 100' +
		'	END AS MarginPct,' +
		'	CASE Dtl.ExtendedGrossWght' +
		'	   WHEN 0 THEN 0' +
		'		  ELSE (Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedGrossWght' +
		'	END AS MarginPerLb,' +
		'	Dtl.DeleteDt, Dtl.StkUM, Cust.MinBillAmt, Cust.ContractNo' +
		' INTO	' + quotename(@TempTable) +
		' FROM	' + quotename(@HeaderTable) + ' Hdr WITH (NOLOCK) LEFT OUTER JOIN' +
		'	' + quotename(@DetailTable) + ' Dtl WITH (NOLOCK) ON ' + @HeaderID + ' = ' + @DetailID + ' LEFT OUTER JOIN' +
--		'	LocMaster Loc WITH (NOLOCK) ON Loc.LocID = Dtl.IMLoc LEFT OUTER JOIN' +
		'	CustomerMaster Cust WITH (NOLOCK) ON Cust.CustNo = Hdr.SellToCustNo' +
		' WHERE ' + @SelColumn + '=@SelDocNo'

EXEC 	sp_ExecuteSQL @Query, N'@SelTableType varchar(10), @SelDocNo varchar(20)', @TableType, @DocNo

IF (@@RowCount > 0) GOTO FoundData
---------------------------------------------------------------------------------------------------------------------

SOTables:

SET @Drop = 'IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id=object_id(N''[dbo].' + quotename(@TempTable) + ''') AND OBJECTPROPERTY(id, N''IsUserTable'')=1) DROP TABLE [dbo].' + quotename(@TempTable)
EXEC sp_ExecuteSQL @Drop

--SO Tables
SET	@TableType = 'SO'
SET	@HeaderTable = 'SOHeader'
SET	@DetailTable = 'SODetail'
SET	@HeaderID = 'Hdr.pSOHeaderID'
SET	@DetailID = 'Dtl.fSOHeaderID'

SET @Query =	' SELECT @SelTableType AS SOTable, ' + @HeaderID + ' AS HeaderID, Hdr.fSOHeaderID AS OrigOrderNo, Hdr.BillToCustNo, Hdr.BillToCustName,' +
		'	Hdr.OrderNo, Hdr.InvoiceNo, Hdr.OrderTypeDsc, Hdr.OrderDt, Hdr.ShipLoc, Hdr.SellToCustName, Hdr.SellToCustNo,' +
		'	Hdr.SellToAddress1, Hdr.SellToCity, Hdr.SellToState, Hdr.SellToZip, Hdr.SellToCountry, Hdr.SellToContactPhoneNo,' +
		'	Hdr.SellToContactName, Hdr.OrderTermsCd, Hdr.OrderTermsName, Hdr.ShipToName, Hdr.ShipToCd, Hdr.ShipToAddress1,' +
		'	Hdr.City, Hdr.State, Hdr.Zip, Hdr.Country, Hdr.PhoneNo, Hdr.ContactName, Hdr.TotalOrder, Hdr.TotalCost, Hdr.ShipWght, Hdr.BolWght,' +
		'	Hdr.CustPONo, Hdr.CustReqDt, Hdr.ConfirmShipDt, Hdr.OrderExpdCd, Hdr.OrderExpdCdName, Hdr.ShipInstrCd, Hdr.ShipInstrCdName,' +
		'	Hdr.InvoiceDt, Hdr.OrderCarrier, Hdr.OrderCarName, Hdr.BOLNO, Hdr.OrderFreightCd, Hdr.OrderFreightName, Hdr.OrderPriorityCd,' +
		'	Hdr.OrderPriName, Hdr.HoldReason, Hdr.HoldReasonName, Hdr.AllocDt, Hdr.PrintDt, Hdr.DeleteDt AS DeleteDtHdr, Hdr.OrigShipDt,' +
		'	Hdr.TaxExpAmt, Hdr.NonTaxExpAmt, ShippingMark1, ShippingMark2, ShippingMark3, ShippingMark4, Hdr.Remarks, Hdr.NoCartons,' +
		'	Hdr.RefSONo, Hdr.ReferenceNo, Dtl.CustItemNo, Dtl.ItemNo, Dtl.ItemDsc, Dtl.QtyShipped, Dtl.IMLoc, Dtl.QtyOrdered, Dtl.QtyAvail1,' +
		'	cast(cast(Dtl.SellStkQty as decimal(18,0)) AS Varchar(10)) + ISNULL(Dtl.StkUM,''  '') + ''/'' + Dtl.SellStkUM AS BaseUOM,' +
		'	cast(cast(Dtl.SuperEquivQty as decimal(18,0)) AS Varchar(10)) + ''/'' + Dtl.SuperEquivUM AS SuperEQV,' +
		'	Dtl.NetUnitPrice, Dtl.AlternatePrice, Dtl.ExtendedNetWght, Dtl.ExtendedGrossWght, Dtl.IMLocName as LocName, Dtl.ExtendedPrice,' +
		'	Dtl.LineNumber, Dtl.Remark, Dtl.AlternateUMQty, Dtl.AlternateUM, Dtl.SellStkQty * Dtl.QtyShipped AS TotalPcs,' +
		'	CASE Dtl.ExtendedGrossWght' +
		'	   WHEN 0 THEN 0' +
		'		  ELSE Dtl.ExtendedPrice / Dtl.ExtendedGrossWght' +
		'	END AS PricePerLB,' +
		'	CASE Dtl.ExtendedPrice' +
		'	   WHEN 0 THEN 0' +
		'		  ELSE ((Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedPrice) * 100' +
		'	END AS MarginPct,' +
		'	CASE Dtl.ExtendedGrossWght' +
		'	   WHEN 0 THEN 0' +
		'		  ELSE (Dtl.ExtendedPrice - Dtl.ExtendedCost) / Dtl.ExtendedGrossWght' +
		'	END AS MarginPerLb,' +
		'	Dtl.DeleteDt, Dtl.StkUM, Cust.MinBillAmt, Cust.ContractNo' +
		' INTO	' + quotename(@TempTable) +
		' FROM	' + quotename(@HeaderTable) + ' Hdr WITH (NOLOCK) LEFT OUTER JOIN' +
		'	' + quotename(@DetailTable) + ' Dtl WITH (NOLOCK) ON ' + @HeaderID + ' = ' + @DetailID + ' LEFT OUTER JOIN' +
--		'	LocMaster Loc WITH (NOLOCK) ON Loc.LocID = Dtl.IMLoc LEFT OUTER JOIN' +
		'	CustomerMaster Cust WITH (NOLOCK) ON Cust.CustNo = Hdr.SellToCustNo' +
		' WHERE ' + @SelColumn + '=@SelDocNo'

EXEC 	sp_ExecuteSQL @Query, N'@SelTableType varchar(10), @SelDocNo varchar(20)', @TableType, @DocNo

IF (@@RowCount > 0) GOTO FoundData

---------------------------------------------------------------------------------------------------------------------

FoundData:

SET @Query = 'SELECT * FROM ' + quotename(@TempTable)
EXEC sp_ExecuteSQL @Query

SET @Drop = 'IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id=object_id(N''[dbo].' + quotename(@TempTable) + ''') AND OBJECTPROPERTY(id, N''IsUserTable'')=1) DROP TABLE [dbo].' + quotename(@TempTable)
EXEC sp_ExecuteSQL @Drop


GO