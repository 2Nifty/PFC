





SELECT	Quote.CustomerNumber,
-- 		Quote.CustomerName,
 		Quote.SessionID,
 		(CASE right(userid,2) WHEN '-U' 							  THEN 'Web Order' 							  ELSE (CASE left(userid,3) WHEN 'esv' 														THEN 'SDK' 														ELSE (CASE isnumeric(userid) WHEN 1 THEN 'Direct Connect' END) 									END) 		 END) as QuoteMethod,
 		count(Quote.PFCItemNo) as LineCount,
 		sum(Quote.UnitPrice * Quote.RequestQuantity) as ExtPrice,
 		sum(Quote.GrossWeight * Quote.RequestQuantity) as ExtWeight


--select distinct(SessionID)

 FROM	DTQ_CustomerQuotation Quote (NOLOCK) INNER JOIN
 		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM
 On		CM.CustNo = Quote.customerNumber COLLATE Latin1_General_CS_AS 
WHERE	DeleteFlag = 0 and  (Year(Quote.QuotationDate) = 2011 AND Month(Quote.QuotationDate) = 08) AND CM.CustShipLocation like '%15%' AND Quote.CustomerNumber like '%003081%' 

GROUP BY Quote.CustomerNumber, --Quote.CustomerName, 
Quote.SessionID, 
Quote.UserID 

ORDER BY Quote.CustomerNumber, Quote.UserID, Quote.SessionID






UPDATE DTQ_CustomerQuotation
set	ORDERSOURCE='RQ'
where sessionid in 
(
1108081985,
110810862,
1108221120,
1108181069,
1108191056,
1108302324

)



select distinct(ordersource)
--count(sessionid), sessionid, OrderSource

--distinct
--(
-- (CASE right(userid,2) WHEN '-U' 							  THEN 'Web Order' 							  ELSE (CASE left(userid,3) WHEN 'esv' 														THEN 'SDK' 														ELSE (CASE isnumeric(userid) WHEN 1 THEN 'Direct Connect' END) 									END) 		 END)
--)
-- as QuoteMethod
--	,* 

 FROM	DTQ_CustomerQuotation Quote (NOLOCK) INNER JOIN
 		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM
 On		CM.CustNo = Quote.customerNumber COLLATE Latin1_General_CS_AS 
WHERE	DeleteFlag = 0 and  (Year(Quote.QuotationDate) = 2011 AND Month(Quote.QuotationDate) = 08) AND CM.CustShipLocation like '%15%' AND Quote.CustomerNumber like '%003081%' 

group by sessionid, OrderSource







SELECT	DTQ_CustomerQuotation.CustomerNumber,
 		DTQ_CustomerQuotation.CustomerName,
 		DTQ_CustomerPendingOrder.PurchaseOrderNo,
 		(case right( DTQ_CustomerQuotation.userid,2) when '-U' then 'Web Order' else (case left( DTQ_CustomerQuotation.userid,3) when 'int' then 'SDK' when 'esv' then 'SDK' else(case isnumeric( DTQ_CustomerQuotation.userid) when 1 then 'Direct Connect' end) end) end) as OrderMethod
, 		DTQ_CustomerPendingOrder.PurchaseOrderDate,
 		DTQ_CustomerPendingOrderDetail.UserItemNo,
 		DTQ_CustomerPendingOrderDetail.PFCItemNo,
 		DTQ_RequestedQuantity.LocationCode,
 		DTQ_CustomerQuotation.Description,
 		CM.CustShipLocation as SalesLocationCode
, 		isnull(cast((round( DTQ_RequestedQuantity.RequestedQuantity,0)) as Decimal(25,0)),0) as RequestQuantity
, 		isnull(cast((round( DTQ_CustomerQuotation.AvailableQuantity,0)) as Decimal(25,0)),0) as AvailableQuantity,
 		isnull(cast((round( DTQ_CustomerPendingOrderDetail.UnitPrice,2)) as Decimal(25,2)),0) as UnitPrice,
 		0 as Margin,
 		DTQ_CustomerPendingOrderDetail.PriceUOM,
 		isnull(cast((round( DTQ_CustomerPendingOrderDetail.TotalPrice,2)) as Decimal(25,2)),0) as TotalPrice,
 		isnull(cast((round( DTQ_CustomerPendingOrderDetail.Weight,1)) as Decimal(25,1)),0) as Weight,
 		isnull(DTQ_CustomerPendingOrder.ECommUserName,'NA') as ECommUserName
, 		isnull(DTQ_CustomerPendingOrder.ECommIPAddress,'NA') as ECommIPAddress,
 		isnull(DTQ_CustomerPendingOrder.ECommPhoneNo,'NA') as ECommPhoneNo,
 		isnull(DTQ_CustomerPendingOrder.OrderSource,'NA') as OrderSource 
FROM	DTQ_CustomerPendingOrder PendOrdHdr (NOLOCK) INNER JOIN
 		DTQ_CustomerPendingOrderDetail PendOrdDtl (NOLOCK) 
ON		DTQ_CustomerPendingOrder.ID = DTQ_CustomerPendingOrderDetail.PurchaseOrderID AND DTQ_CustomerPendingOrder.OrderCompletedStatus ='true' INNER JOIN
 		DTQ_RequestedQuantity ReqQty (NOLOCK) 
ON		DTQ_CustomerPendingOrderDetail.ID = DTQ_RequestedQuantity.PendingOrderID INNER JOIN
 		DTQ_CustomerQuotation Quote (NOLOCK) 
ON		DTQ_CustomerPendingOrderDetail.QuotationItemDetailID = DTQ_CustomerQuotation.QuoteNumber AND DTQ_RequestedQuantity.QuoteNumber = DTQ_CustomerQuotation.QuoteNumber INNER JOIN
 		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM 
ON		CM.CustNo = DTQ_CustomerQuotation.CustomerNumber COLLATE Latin1_General_CS_AS 
WHERE	1=1 (Year(DTQ_CustomerPendingOrder.PurchaseOrderDate) = 2011 AND Month(DTQ_CustomerPendingOrder.PurchaseOrderDate) = 08) 
	AND CM.CustShipLocation like '%15%' AND DTQ_CustomerPendingOrder.CustomerNumber like '%003081%'












SELECT	Quote.CustomerNumber, 		Quote.CustomerName, 		PendOrdHdr.PurchaseOrderNo, 		(case right( Quote.userid,2) when '-U' then 'Web Order' else (case left( Quote.userid,3) when 'int' then 'SDK' when 'esv' then 'SDK' else(case isnumeric( Quote.userid) when 1 then 'Direct Connect' end) end) end) as OrderMethod, 		PendOrdHdr.PurchaseOrderDate, 		PendOrdDtl.UserItemNo, 		PendOrdDtl.PFCItemNo, 		ReqQty.LocationCode, 		Quote.Description, 		CM.CustShipLocation as SalesLocationCode, 		isnull(cast((round( ReqQty.RequestedQuantity,0)) as Decimal(25,0)),0) as RequestQuantity, 		isnull(cast((round( Quote.AvailableQuantity,0)) as Decimal(25,0)),0) as AvailableQuantity, 		isnull(cast((round( PendOrdDtl.UnitPrice,2)) as Decimal(25,2)),0) as UnitPrice, 		0 as Margin, 		PendOrdDtl.PriceUOM, 		isnull(cast((round( PendOrdDtl.TotalPrice,2)) as Decimal(25,2)),0) as TotalPrice, 		isnull(cast((round( PendOrdDtl.Weight,1)) as Decimal(25,1)),0) as Weight, 		isnull(PendOrdHdr.ECommUserName,'NA') as ECommUserName, 		isnull(PendOrdHdr.ECommIPAddress,'NA') as ECommIPAddress, 		isnull(PendOrdHdr.ECommPhoneNo,'NA') as ECommPhoneNo, 		isnull(PendOrdHdr.OrderSource,'NA') as OrderSource 


select PendOrdHdr.*
FROM	DTQ_CustomerPendingOrder PendOrdHdr (NOLOCK) INNER JOIN
 		DTQ_CustomerPendingOrderDetail PendOrdDtl (NOLOCK) 
ON		PendOrdHdr.ID = PendOrdDtl.PurchaseOrderID AND PendOrdHdr.OrderCompletedStatus ='true' INNER JOIN
 		DTQ_RequestedQuantity ReqQty (NOLOCK) 
ON		PendOrdDtl.ID = ReqQty.PendingOrderID INNER JOIN
 		DTQ_CustomerQuotation Quote (NOLOCK) 
ON		PendOrdDtl.QuotationItemDetailID = Quote.QuoteNumber AND ReqQty.QuoteNumber = Quote.QuoteNumber --INNER JOIN
-- 		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM 
--ON		CM.CustNo = Quote.CustomerNumber COLLATE Latin1_General_CS_AS 
WHERE	1=1 AND (Year(PendOrdHdr.PurchaseOrderDate) = 2011 AND Month(PendOrdHdr.PurchaseOrderDate) = 08) --AND CM.CustShipLocation like '%15%'
and Quote.CustomerNumber='003081'
