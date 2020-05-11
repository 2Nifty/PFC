CREATE procedure [dbo].[pOpenMillOrders] as
----pOpenMillOrders
----Written By: Tod Dixon
----Application: Sales Order Management

SELECT	Hdr.[Sell-to Customer No_] AS CustNo, Hdr.[Sell-to Customer Name] AS CustName, Hdr.No_ AS SONumber, 
	Hdr.[External Document No_] AS PONumber, Hdr.[Your Reference] AS Ref, Line.No_ AS Item, 
	Line.Description, Line.Quantity, Line.[Unit of Measure] AS UOM, Line.[Unit Price] AS UnitPrice, 
	Hdr.[Order Date] AS OrderDt, Hdr.[Shipment Date] AS ShipDt, Hdr.[Shortcut Dimension 1 Code] AS SalesLoc, 
	Line.[Location Code] AS ShipLoc, Line.[Alt_ Price] AS AltPrice, Line.[Alt_ Price UOM] AS AltUOM, 
	Hdr.[Entered User ID] AS SalesPerson
FROM	[Porteous$Sales Header] Hdr INNER JOIN
	[Porteous$Sales Line] Line ON Hdr.No_ = Line.[Document No_]
WHERE	(Hdr.[Order Type] = 1 and Hdr.[Document Type] = 1)
GO