--drop procedure dbo.pOpenOrderRpt


CREATE procedure [dbo].[pOpenOrderRpt]
	@CustNo varchar(50),
	@OrderType char(4),
	@EntryID varchar(50),
	@CustShipLoc varchar(10),
	@ShipLoc varchar(10),
	@BadMgn varchar(5)
as

----pOpenOrderRpt
----Written By: Tod Dixon
----Application: Sales Order Management


DECLARE	@Query nvarchar(4000),
	@Where nvarchar(4000),
	@WhereFlg varchar(5),
	@MaxMargin decimal(9,2),
	@MinMargin decimal(9,2)

SET @MaxMargin = (SELECT AppOptionValue FROM AppPref WHERE ApplicationCd='SOE' AND AppOptionType='MaxMargin')
SET @MinMargin = (SELECT AppOptionValue FROM AppPref WHERE ApplicationCd='SOE' AND AppOptionType='MinMargin')

SET @Where = 'WHERE'
SET @WhereFlg = 'false'

IF @CustNo <> '000000'
   BEGIN
	SET @Where = @Where + ' Hdr.SellToCustNo = ''' + @CustNo + ''''
	SET @WhereFlg = 'true'
   END

IF @OrderType <> 'ALL'
   BEGIN
	IF (@WhereFlg = 'true')
		SET @Where = @Where + ' AND'
	ELSE
		SET @WhereFlg = 'true'
	SET @Where = @Where + ' Hdr.OrderType = ''' + @OrderType + ''''
   END

IF @EntryID <> ''
   BEGIN
	IF (@WhereFlg = 'true')
		SET @Where = @Where + ' AND'
	ELSE
		SET @WhereFlg = 'true'
	SET @Where = @Where + ' Hdr.EntryID = ''' + @EntryID + ''''
   END

IF @CustShipLoc <> 'All'
   BEGIN
	IF (@WhereFlg = 'true')
		SET @Where = @Where + ' AND'
	ELSE
		SET @WhereFlg = 'true'
	SET @Where = @Where + ' Hdr.CustShipLoc = ''' + @CustShipLoc + ''''
   END

IF @ShipLoc <> 'All'
   BEGIN
	IF (@WhereFlg = 'true')
		SET @Where = @Where + ' AND'
	ELSE
		SET @WhereFlg = 'true'
	SET @Where = @Where + ' Hdr.ShipLoc = ''' + @ShipLoc + ''''
   END

IF @BadMgn <> 'false'
   BEGIN
	IF (@WhereFlg = 'true')
		SET @Where = @Where + ' AND'
	ELSE
		SET @WhereFlg = 'true'
	SET @Where = @Where +
		'	CASE WHEN Line.NetUnitPrice = 0 THEN ''Zero''' +
		'	     ELSE CASE WHEN (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice > @Max2 THEN ''Hi''' +
		'		       WHEN (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice < @Min2 THEN ''Lo''' +
		'		       ELSE null ' +
		'		  END ' +
		'	END is not null'
   END

SET @Query = 	'SELECT	Hdr.SellToCustNo AS CustNo, Hdr.SellToCustName AS CustName, Hdr.OrderNo AS SONumber, Hdr.CustPONo AS PONumber, Hdr.BOLNO AS Ref, ' +
		'	Hdr.OrderDt AS OrderDt, Hdr.SchShipDt AS ShipDt, Hdr.CustShipLoc AS SalesLoc, Hdr.ShipLoc AS ShipLoc, Hdr.EntryID AS SalesPerson, ' +
		'	Line.LineNumber AS [LineNo], Line.ItemNo AS Item, Line.ItemDsc AS [Description], Line.QtyOrdered AS Quantity, Line.SellStkUM AS UOM, ' +
		'	Line.NetUnitPrice AS UnitPrice , Line.AlternatePrice AS AltPrice, Line.AlternateUM AS AltUOM, Line.UnitCost AS UnitCost, ' +
		'	CASE WHEN Line.NetUnitPrice = 0 THEN 0 ' +
		'	     ELSE (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice ' +
		'	END AS [Mgn%], ' +
		'	CASE WHEN Line.NetUnitPrice = 0 THEN ''Zero''' +
		'	     ELSE CASE WHEN (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice > @Max1 THEN ''Hi''' +
		'		       WHEN (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice < @Min1 THEN ''Lo''' +
		'		       ELSE null ' +
		'		  END ' +
		'	END AS MgnFlg ' +
		'FROM	SOHeaderRel Hdr (NoLock) INNER JOIN ' +
		'	SODetailRel Line (NoLock) ' +
		'ON	Hdr.pSOHeaderRelID = Line.fSOHeaderRelID '

IF @WhereFlg = 'true'
	SET @Query = @Query + @Where

SET @Query = @Query + ' Order By CustNo, SONumber'

EXEC 	sp_ExecuteSQL @Query, N'@Max1 decimal(9,2), @Min1 decimal(9,2), @Max2 decimal(9,2), @Min2 decimal(9,2)', @MaxMargin, @MinMargin, @MaxMargin, @MinMargin


GO
