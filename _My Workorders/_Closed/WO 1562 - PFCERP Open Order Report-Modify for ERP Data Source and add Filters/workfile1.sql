
CREATE procedure [dbo].[pOpenOrderRpt]
	@CustNo varchar(50),
	@OrderType char(4),
	@EntryID varchar(50),
	@CustShipLoc varchar(10),
	@ShipLoc varchar(10)
as

----pOpenOrderRpt
----Written By: Tod Dixon
----Application: Sales Order Management


DECLARE	@Query nvarchar(4000),
	@Where nvarchar(4000),
	@WhereFlg varchar(5),

--These will be passed parameters
	@CustNo varchar(50),
	@OrderType char(4),
	@EntryID varchar(50),
	@CustShipLoc varchar(10),
	@ShipLoc varchar(10)

set	@CustNo = '000000'
set	@OrderType = 'ALL'
set	@EntryID = 'ALL'
set	@CustShipLoc = '0'
set	@ShipLoc = '0'


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

IF @EntryID <> 'ALL'
   BEGIN
	IF (@WhereFlg = 'true')
		SET @Where = @Where + ' AND'
	ELSE
		SET @WhereFlg = 'true'
	SET @Where = @Where + ' Hdr.EntryID = ''' + @EntryID + ''''
   END

IF @CustShipLoc <> '0'
   BEGIN
	IF (@WhereFlg = 'true')
		SET @Where = @Where + ' AND'
	ELSE
		SET @WhereFlg = 'true'
	SET @Where = @Where + ' Hdr.CustShipLoc = ''' + @CustShipLoc + ''''
   END

IF @ShipLoc <> '0'
   BEGIN
	IF (@WhereFlg = 'true')
		SET @Where = @Where + ' AND'
	ELSE
		SET @WhereFlg = 'true'
	SET @Where = @Where + ' Hdr.ShipLoc = ''' + @ShipLoc + ''''
   END

SET @Query = 	'SELECT	Hdr.SellToCustNo AS CustNo, Hdr.SellToCustName AS CustName, Hdr.OrderNo AS SONumber, Hdr.CustPONo AS PONumber, Hdr.BOLNO AS Ref, ' +
		'	Hdr.OrderDt AS OrderDt, Hdr.SchShipDt AS ShipDt, Hdr.CustShipLoc AS SalesLoc, Hdr.ShipLoc AS ShipLoc, Hdr.EntryID AS SalesPerson, ' +
		'	Line.ItemNo AS Item, Line.ItemDsc AS [Description], Line.QtyOrdered AS Quantity, Line.SellStkUM AS UOM, ' +
		'	Line.NetUnitPrice AS UnitPrice , Line.AlternatePrice AS AltPrice, Line.AlternateUM AS AltUOM, Line.UnitCost AS UnitCost, ' +
		'	CASE WHEN Line.NetUnitPrice = 0 THEN 0 ELSE (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice * 100 END AS [Mgn%] ' +
',Hdr.OrderType '+
		'FROM	SOHeaderRel Hdr (NoLock) INNER JOIN ' +
		'	SODetailRel Line (NoLock) ' +
		'ON	Hdr.pSOHeaderRelID = Line.fSOHeaderRelID '

IF @WhereFlg = 'true'
	SET @Query = @Query + @Where

SET @Query = @Query + ' Order By CustNo, SONumber'

EXEC 	sp_ExecuteSQL @Query












select	ListValue as OrderType,
	ListDtlDesc as [Desc],
	SequenceNo as SubType
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail
ON	pListMasterID=fListMasterID 
WHERE	ListName='soeordertypes' --AND
--	SubType is null
order by OrderType






IF @CustNo = '000000'	--All Customers
   Begin
     IF @OrderType = 0	--Not MILL
	Begin	--This will SELECT all Customers for all Order Types that are not MILL ([Order Type] <> 1)
		SELECT	Hdr.[Sell-to Customer No_] AS CustNo, Hdr.[Sell-to Customer Name] AS CustName, Hdr.No_ AS SONumber, 
			Hdr.[External Document No_] AS PONumber, Hdr.[Your Reference] AS Ref, Line.No_ AS Item, 
			Line.Description, Line.Quantity, Line.[Unit of Measure] AS UOM, Line.[Unit Price] AS UnitPrice, 
			Hdr.[Order Date] AS OrderDt, Hdr.[Shipment Date] AS ShipDt, Hdr.[Shortcut Dimension 1 Code] AS SalesLoc, 
			Line.[Location Code] AS ShipLoc, Line.[Alt_ Price] AS AltPrice, Line.[Alt_ Price UOM] AS AltUOM, 
			Hdr.[Entered User ID] AS SalesPerson
		FROM	[Porteous$Sales Header] Hdr INNER JOIN
			[Porteous$Sales Line] Line ON Hdr.No_ = Line.[Document No_]
		WHERE	(Hdr.[Order Type] <> 1 and Hdr.[Document Type] = 1)
		Order By CustNo, SONumber
	End
     ELSE
	Begin	--This will SELECT all Customers for all Order Types that are MILL ([Order Type] = 1)
		SELECT	Hdr.[Sell-to Customer No_] AS CustNo, Hdr.[Sell-to Customer Name] AS CustName, Hdr.No_ AS SONumber, 
			Hdr.[External Document No_] AS PONumber, Hdr.[Your Reference] AS Ref, Line.No_ AS Item, 
			Line.Description, Line.Quantity, Line.[Unit of Measure] AS UOM, Line.[Unit Price] AS UnitPrice, 
			Hdr.[Order Date] AS OrderDt, Hdr.[Shipment Date] AS ShipDt, Hdr.[Shortcut Dimension 1 Code] AS SalesLoc, 
			Line.[Location Code] AS ShipLoc, Line.[Alt_ Price] AS AltPrice, Line.[Alt_ Price UOM] AS AltUOM, 
			Hdr.[Entered User ID] AS SalesPerson
		FROM	[Porteous$Sales Header] Hdr INNER JOIN
			[Porteous$Sales Line] Line ON Hdr.No_ = Line.[Document No_]
		WHERE	(Hdr.[Order Type] = 1 and Hdr.[Document Type] = 1)
		Order By CustNo, SONumber
	End
   End
ELSE
   Begin
     IF @OrderType = 0
	Begin	--This will SELECT the specific Customer for all Order Types that are not MILL ([Order Type] <> 1)
		SELECT	Hdr.[Sell-to Customer No_] AS CustNo, Hdr.[Sell-to Customer Name] AS CustName, Hdr.No_ AS SONumber, 
			Hdr.[External Document No_] AS PONumber, Hdr.[Your Reference] AS Ref, Line.No_ AS Item, 
			Line.Description, Line.Quantity, Line.[Unit of Measure] AS UOM, Line.[Unit Price] AS UnitPrice, 
			Hdr.[Order Date] AS OrderDt, Hdr.[Shipment Date] AS ShipDt, Hdr.[Shortcut Dimension 1 Code] AS SalesLoc, 
			Line.[Location Code] AS ShipLoc, Line.[Alt_ Price] AS AltPrice, Line.[Alt_ Price UOM] AS AltUOM, 
			Hdr.[Entered User ID] AS SalesPerson
		FROM	[Porteous$Sales Header] Hdr INNER JOIN
			[Porteous$Sales Line] Line ON Hdr.No_ = Line.[Document No_]
		WHERE	(Hdr.[Sell-to Customer No_]=@CustNo and Hdr.[Order Type] <> 1 and Hdr.[Document Type] = 1)
		Order By CustNo, SONumber
	End
     ELSE
	Begin	--This will SELECT the specific Customer for all Order Types that are MILL ([Order Type] = 1)
		SELECT	Hdr.[Sell-to Customer No_] AS CustNo, Hdr.[Sell-to Customer Name] AS CustName, Hdr.No_ AS SONumber, 
			Hdr.[External Document No_] AS PONumber, Hdr.[Your Reference] AS Ref, Line.No_ AS Item, 
			Line.Description, Line.Quantity, Line.[Unit of Measure] AS UOM, Line.[Unit Price] AS UnitPrice, 
			Hdr.[Order Date] AS OrderDt, Hdr.[Shipment Date] AS ShipDt, Hdr.[Shortcut Dimension 1 Code] AS SalesLoc, 
			Line.[Location Code] AS ShipLoc, Line.[Alt_ Price] AS AltPrice, Line.[Alt_ Price UOM] AS AltUOM, 
			Hdr.[Entered User ID] AS SalesPerson
		FROM	[Porteous$Sales Header] Hdr INNER JOIN
			[Porteous$Sales Line] Line ON Hdr.No_ = Line.[Document No_]
		WHERE	(Hdr.[Sell-to Customer No_]=@CustNo and Hdr.[Order Type] = 1 and Hdr.[Document Type] = 1)
		Order By CustNo, SONumber
	End
   End
GO
