select * from SOHeaderRel

exec pOpenOrderRpt '000000', 'All', 'All', '0', '0'



SELECT	Hdr.pSOHeaderRelID, Line.pSODetailRelID, Hdr.SellToCustNo AS CustNo, Hdr.SellToCustName AS CustName, Hdr.OrderNo AS SONumber, Hdr.CustPONo AS PONumber, Hdr.BOLNO AS Ref, 
			Hdr.OrderDt AS OrderDt, Hdr.SchShipDt AS ShipDt, Hdr.CustShipLoc AS SalesLoc, Hdr.ShipLoc AS ShipLoc, Hdr.EntryID AS SalesPerson, 
			Line.ItemNo AS Item, Line.ItemDsc AS [Description], Line.QtyOrdered AS Quantity, Line.SellStkUM AS UOM, 
			Line.NetUnitPrice AS UnitPrice , Line.AlternatePrice AS AltPrice, Line.AlternateUM AS AltUOM, Line.UnitCost AS UnitCost, 
			CASE WHEN Line.NetUnitPrice = 0 THEN 0 ELSE (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice * 100 END AS [Mgn%] 
		FROM	SOHeaderRel Hdr (NoLock) INNER JOIN 
			SODetailRel Line (NoLock) 
		ON	Hdr.pSOHeaderRelID = Line.fSOHeaderRelID 


exec sp_columns SODetailRel

update SOHeaderRel
set SellToCustName = 'A/1 Nut & Bolt AAAAAAA AAAAAAAA AAAAAAA',
	CustPONo = 'A1NB-489-1 AAAA AAAA',
	BOLNO = 'AAAAA AAAAAAAA AAAAA',
                         
	EntryID = 'cparks AAAAAA AAAAAAA AAAAA AAAAAAA AAAAAAAA AAAAA'
where pSOHeaderRelID = 7


update SODetailRel set ItemDsc = '3/8-16 X 1 Hex Bolt PL AAAAA AAAAAA AAA AAAAAA AAA'
where pSODetailRelID=8


 AS SalesPerson, 
			Line.ItemNo AS Item, Line.ItemDsc AS [Description], Line.QtyOrdered AS Quantity, Line.SellStkUM AS UOM, 
			Line.NetUnitPrice AS UnitPrice , Line.AlternatePrice AS AltPrice, Line.AlternateUM AS AltUOM, Line.UnitCost AS UnitCost, 
			CASE WHEN Line.NetUnitPrice = 0 THEN 0 ELSE (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice * 100 END AS [Mgn%] 