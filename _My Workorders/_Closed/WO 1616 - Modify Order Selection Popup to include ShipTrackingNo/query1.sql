select ShipTrackingNo, * from SOHeader where pSOHeaderID in
(select fSOHeaderID from SOHeaderRel) --and ShiptrackingNo is not null
 and InvoiceDt is null


exec pSOECheckOrderAvailability '1047393'


select * from SOHeader where OrderNo= '1071195'
select ShipTrackingNo, * from SOHeaderRel where fSOHeaderID=1071195

update SOHeaderRel
set ShipTrackingNo='ShipTrackingNo'
where fSOHeaderID=1071195





select BOLNO, * from	SOHeaderRel TOHDR INNER JOIN
	SODetailRel TOLIN
ON	TOHDR.pSOHeaderRelID = TOLIN.fSOHeaderRelID 
WHERE	TOHDR.OrderType = 'TO' and BOLNO is not null and BOLNO <> '' AND
	CASE WHEN TOHDR.ConfirmShipDt = '' OR TOHDR.ConfirmShipDt is null
		     THEN TOLIN.QtyOrdered
		     ELSE TOLIN.QtyOrdered - TOLIN.QtyShipped
	END > 0
order by OrderNo


exec pBOLRpt '8289300000001051328'