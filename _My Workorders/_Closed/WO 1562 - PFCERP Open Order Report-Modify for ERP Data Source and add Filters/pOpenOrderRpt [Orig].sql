
CREATE procedure [dbo].[pOpenOrderRpt]
@CustNo varchar(50),
@OrderType int
as

----pOpenOrderRpt
----Written By: Tod Dixon
----Application: Sales Order Management

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
