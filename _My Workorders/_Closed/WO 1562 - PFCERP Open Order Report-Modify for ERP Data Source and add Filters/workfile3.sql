DECLARE	@MaxMargin decimal(9,2),
	@MinMargin decimal(9,2)

SET	@MaxMargin = CAST((SELECT AppOptionValue FROM AppPref WHERE ApplicationCd='SOE' AND AppOptionType='MaxMargin') AS decimal(9,2)) * 100
SET	@MinMargin = CAST((SELECT AppOptionValue FROM AppPref WHERE ApplicationCd='SOE' AND AppOptionType='MinMargin') AS decimal(9,2)) * 100


select @MaxMargin, @MinMargin





SELECT	Hdr.SellToCustNo AS CustNo, Hdr.SellToCustName AS CustName, Hdr.OrderNo AS SONumber, Hdr.CustPONo AS PONumber, Hdr.BOLNO AS Ref, 
	Hdr.OrderDt AS OrderDt, Hdr.SchShipDt AS ShipDt, Hdr.CustShipLoc AS SalesLoc, Hdr.ShipLoc AS ShipLoc, Hdr.EntryID AS SalesPerson, 
	Line.LineNumber AS [LineNo], Line.ItemNo AS Item, Line.ItemDsc AS [Description], Line.QtyOrdered AS Quantity, Line.SellStkUM AS UOM, 
	Line.NetUnitPrice AS UnitPrice , Line.AlternatePrice AS AltPrice, Line.AlternateUM AS AltUOM, Line.UnitCost AS UnitCost, 
	CASE WHEN Line.NetUnitPrice = 0 THEN 0 ELSE (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice * 100 END AS [Mgn%],

	CASE WHEN Line.NetUnitPrice = 0 THEN 'Zero'
		ELSE
		CASE WHEN (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice * 100 > @MaxMargin THEN 'Hi'
			WHEN (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice * 100 < @MinMargin THEN 'Lo'
			ELSE null
		end
	END AS MgnFlg

FROM	SOHeaderRel Hdr (NoLock) INNER JOIN 
	SODetailRel Line (NoLock) 
ON	Hdr.pSOHeaderRelID = Line.fSOHeaderRelID
where 	CASE WHEN Line.NetUnitPrice = 0 THEN 'Zero'
		ELSE
		CASE WHEN (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice * 100 > @MaxMargin THEN 'Hi'
			WHEN (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice * 100 < @MinMargin THEN 'Lo'
			ELSE null
		end
	END is not null



select * from AppPref where ApplicationCd='SOE'













DECLARE	@Query nvarchar(4000),
	@Where nvarchar(4000),
	@WhereFlg varchar(5),
	@MaxMargin decimal(9,2),
	@MinMargin decimal(9,2),
	@CustNo varchar(50),
	@OrderType char(4),
	@EntryID varchar(50),
	@CustShipLoc varchar(10),
	@ShipLoc varchar(10),
	@BadMgn varchar(5)

SET @MaxMargin = (SELECT AppOptionValue FROM AppPref WHERE ApplicationCd='SOE' AND AppOptionType='MaxMargin')
SET @MinMargin = (SELECT AppOptionValue FROM AppPref WHERE ApplicationCd='SOE' AND AppOptionType='MinMargin')

select @MaxMargin, @MinMargin

SET @Where = 'WHERE'
SET @WhereFlg = 'false'

set @BadMgn = 'false'

IF @BadMgn <> 'false'
   BEGIN
	SET @Where = @Where +
		'	CASE WHEN Line.NetUnitPrice = 0 THEN ''Zero''' +
		'	     ELSE CASE WHEN (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice > @Max2 THEN ''Hi''' +
		'		       WHEN (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice < @Min2 THEN ''Lo''' +
		'		       ELSE null ' +
		'		  END ' +
		'	END is not null'
	SET @WhereFlg = 'true'
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


