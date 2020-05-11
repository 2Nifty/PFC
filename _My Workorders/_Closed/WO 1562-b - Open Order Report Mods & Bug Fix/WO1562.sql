SELECT	Hdr.DeleteDt, InvoiceDt, Line.DeleteDt, Hdr.SellToCustNo AS CustNo, Hdr.SellToCustName AS CustName, Hdr.OrderNo AS SONumber, Hdr.CustPONo AS PONumber, Hdr.BOLNO AS Ref, 
	Hdr.OrderDt AS OrderDt, Hdr.SchShipDt AS ShipDt, Hdr.CustShipLoc AS SalesLoc, Hdr.ShipLoc AS ShipLoc, Hdr.EntryID AS SalesPerson, 
	Line.LineNumber AS [LineNo], Line.ItemNo AS Item, Line.ItemDsc AS [Description], Line.QtyOrdered AS Quantity, Line.SellStkUM AS UOM, 
	Line.NetUnitPrice AS UnitPrice , Line.AlternatePrice AS AltPrice, Line.AlternateUM AS AltUOM, Line.UnitCost AS UnitCost, 
	CASE WHEN Line.NetUnitPrice = 0 THEN 0 
	     ELSE (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice 
	END AS [Mgn%] --, 
--	CASE WHEN Line.NetUnitPrice = 0 THEN 'Zero'
--	     ELSE CASE WHEN (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice > @Max1 THEN 'Hi'
--		       WHEN (Line.NetUnitPrice - Line.UnitCost) / Line.NetUnitPrice < @Min1 THEN 'Lo' 
--		       ELSE null 
--		  END 
--	END AS MgnFlg 
FROM	SOHeaderRel Hdr (NoLock) INNER JOIN 
	SODetailRel Line (NoLock) 
ON	Hdr.pSOHeaderRelID = Line.fSOHeaderRelID
WHERE --Hdr.ShipLoc = '01' AND	
--  (Line.DeleteDt is NULL OR Line.DeleteDt='') AND (Hdr.DeleteDt is NULL OR Hdr.DeleteDt='') AND (Hdr.InvoiceDt is NULL OR Hdr.InvoiceDt='') and

Hdr.SellToCustNo='003671' and Hdr.OrderNo='20343'

exec pOpenOrderRpt '003671','ALL','','ALL','ALL', 'false'


select DeleteDt, InvoiceDt, * from SOHeaderRel where OrderNo='20343'

update SOHeaderRel set InvoiceDt=null, DeleteDt=null where OrderNo='20343'

select DeleteDt, * from SODetailRel where fSOHeaderrelID=20343




SELECT Hdr.DeleteDt, InvoiceDt, Line.DeleteDt,Hdr.SellToCustNo AS CustNo, Hdr.SellToCustName AS CustName, Hdr.OrderNo AS SONumber, Hdr.CustPONo AS PONumber, Hdr.BOLNO AS Ref,  Hdr.OrderDt AS OrderDt, Hdr.SchShipDt AS ShipDt, Hdr.CustShipLoc AS SalesLoc, Hdr.ShipLoc AS ShipLoc, Hdr.EntryID AS Sa
