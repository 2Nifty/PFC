
-- **CustomerMaster
--SELECT * FROM ##tCustMaster_E4C831AB
--DROP TABLE ##tCustMaster_E4C831AB

------I don't think we need this Customer Table

SELECT	CustQuote.CustomerNumber, CM.CustShipLocation as SalesLocationCode 
--INTO	##tCustMaster_E4C831AB 
FROM	DTQ_CustomerQuotation CustQuote (NOLOCK) INNER JOIN
 	CustomerMaster CM 
ON	CM.CustNo = CustQuote.CustomerNumber COLLATE Latin1_General_CS_AS 
WHERE	CustQuote.DeleteFlag = 0 and 1=1 AND (Year(CustQuote.QuotationDate) = 2011 AND Month(CustQuote.QuotationDate) = 08) AND 

	CM.CustShipLocation like '%15%' AND CM.PriceCd <> 'X' 

GROUP BY CustQuote.CustomerNumber, CM.CustShipLocation


------------------------------------------------------------------------------------------------------------------------------ 



select * from WebActivityPosting


-- **eCommerce Quotes
--SELECT * FROM ##tECommQuote_451E3051
--DROP TABLE ##tECommQuote_451E3051
SELECT	ECommQuote.CustNo as CustomerNumber,
	ECommQuote.SalesLocationCode,
 		count(ECommQuote.NoOfECommQuotes) as NoOfECommQuotes,
 		sum(isnull(ECommQuote.eCommExtAmount,0)) as eCommExtAmount,
 		sum(isnull(ECommQuote.eCommExtWeight,0)) as eCommExtWeight 
--INTO	##tECommQuote_451E3051 
FROM	(SELECT	CM.CustNo,
		CM.CustShipLocation as SalesLocationCode,
		CustQuote.SessionID,
		count(CustQuote.QuoteNo) as NoOfECommQuotes,
		sum(CustQuote.SellPrice * CustQuote.Qty) as eCommExtAmount,
		sum(IM.GrossWght * CustQuote.Qty) as eCommExtWeight
	 FROM	WebActivityPosting CustQuote (NOLOCK) INNER JOIN
 		CustomerMaster  CM (NOLOCK)
 	 ON	CM.CustNo = CustQuote.CustNo INNER JOIN
		ItemMaster IM (NOLOCK)
	 ON	IM.ItemNo = CustQuote.ItemNo LEFT OUTER JOIN
 		(SELECT	LD.ListValue as OrdSrc,
 			isnull(LD.SequenceNo,0) as Sequence
 		 FROM	ListMaster LM (NOLOCK) INNER JOIN
 			ListDetail LD (NOLOCK)
 		 ON	LM.pListMasterID = LD.fListMasterID
 		 WHERE	LM.ListName = 'SOEOrderSource') Src 
 	 ON		isnull(CustQuote.OrderSource,'RQ') = Src.OrdSrc
 	 WHERE		--CustQuote.DeleteFlag = 0 and		--IGNORE per TomJr
			Src.Sequence = 1 and 1=1 AND (Year(CustQuote.QuoteDt) = 2011 AND Month(CustQuote.QuoteDt) = 08) AND 
			CM.CustShipLocation like '%15%' AND CM.PriceCd <> 'X' AND 1=1
	 GROUP BY	CM.CustNo, CM.CustShipLocation, CustQuote.SessionID) ECommQuote
GROUP BY  ECommQuote.CustNo, ECommQuote.SalesLocationCode


------------------------------------------------------------------------------------------------------------------------------  
-- **eCommerce Orders
--SELECT * FROM ##tECommOrder_C111D852
--DROP TABLE ##tECommOrder_C111D852
SELECT	ECommOrder.CustNo as CustomerNumber,
	ECommOrder.SalesLocationCode,
	count(ECommOrder.NoOfECommOrders) as NoOfECommOrders,
 		sum(isnull(ECommOrder.eCommExtOrdWeight,0)) as eCommExtOrdWeight,
 		sum(isnull(ECommOrder.eCommExtOrdAmount,0)) as eCommExtOrdAmount 
--INTO	##tECommOrder_C111D852 
FROM	(SELECT	CM.CustNo,
		CM.CustShipLocation as SalesLocationCode,
		PendOrdHdr.ID,
		count(CustQuote.QuoteNo) as NoOfECommOrders,
		Sum(IM.GrossWght * CustQuote.Qty) as eCommExtOrdWeight,
		Sum(PendOrdDtl.TotalPrice) as eCommExtOrdAmount
 	 FROM	DTQ_CustomerPendingOrderDetail PendOrdDtl (NOLOCK) INNER JOIN
 		WebActivityPosting CustQuote (NOLOCK)
 	 ON	PendOrdDtl.QuotationItemDetailID = CustQuote.QuoteNo INNER JOIN
 		DTQ_CustomerPendingOrder PendOrdHdr (NOLOCK)
 	 ON	PendOrdDtl.PurchaseOrderID = PendOrdHdr.ID AND PendOrdHdr.OrderCompletedStatus ='true' inner join
 		CustomerMaster CM (NOLOCK)
 	 ON	CM.CustNo = CustQuote.CustNo INNER JOIN
		ItemMaster IM (NOLOCK)
	 ON	IM.ItemNo = CustQuote.ItemNo LEFT OUTER JOIN
 		(SELECT	LD.ListValue as OrdSrc,
 			isnull(LD.SequenceNo,0) as Sequence
 		 FROM	ListMaster LM (NOLOCK) INNER JOIN
 			ListDetail LD (NOLOCK)
 		 ON	LM.pListMasterID = LD.fListMasterID
 		 WHERE	LM.ListName = 'SOEOrderSource') Src
 	 ON	isnull(CustQuote.OrderSource,'RQ') = Src.OrdSrc
 	 WHERE	Src.Sequence = 1 and 1=1 AND (Year(PendOrdHdr.PurchaseOrderDate) = 2011 AND Month(PendOrdHdr.PurchaseOrderDate) = 08) AND 
		CM.CustShipLocation like '%15%' AND CM.PriceCd <> 'X' AND 1=1
	 GROUP BY CM.CustNo, CM.CustShipLocation, PendOrdHdr.ID) ECommOrder
GROUP BY  ECommOrder.CustNo, ECommOrder.SalesLocationCode



------------------------------------------------------------------------------------------------------------------------------  
-- **Manual Quotes
--SELECT * FROM ##tManualQuote_E4454AD7
--DROP TABLE ##tManualQuote_E4454AD7
SELECT	ManualQuote.CustNo as CustomerNumber,
	ManualQuote.SalesLocationCode,
 	count(ManualQuote.NoOfManualQuotes) as NoOfManualQuotes,
 	sum(isnull(ManualQuote.ManualExtAmount,0)) as ManualExtAmount,
 	sum(isnull(ManualQuote.ManualExtWeight,0)) as ManualExtWeight 
--INTO	##tManualQuote_E4454AD7 
FROM	(SELECT	CM.CustNo,
		CM.CustShipLocation as SalesLocationCode,
 		CustQuote.SessionID,
 		count(CustQuote.QuoteNumber) as NoOfManualQuotes,
 		sum(CustQuote.UnitPrice * CustQuote.RequestQuantity) as ManualExtAmount,
 		sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as ManualExtWeight
 	 FROM	DTQ_CustomerQuotation CustQuote (NOLOCK) INNER JOIN
 		CustomerMaster CM (NOLOCK)
 	 ON	CM.CustNo = CustQuote.CustomerNumber LEFT OUTER JOIN
 		(SELECT	LD.ListValue as OrdSrc,
 			isnull(LD.SequenceNo,0) as Sequence
 		 FROM	ListMaster LM (NOLOCK) INNER JOIN
 			ListDetail LD (NOLOCK)
 		 ON	LM.pListMasterID = LD.fListMasterID
 		 WHERE	LM.ListName = 'SOEOrderSource') Src
 	 ON	isnull(CustQuote.OrderSource,'RQ') = Src.OrdSrc
 	 WHERE	--CustQuote.DeleteFlag = 0 and 		--IGNORE per TomJr
		Src.Sequence <> 1 and 1=1 AND (Year(CustQuote.QuotationDate) = 2011 AND Month(CustQuote.QuotationDate) = 08) AND 
		CM.CustShipLocation like '%15%' AND CM.PriceCd <> 'X' AND 1=1
 	 GROUP BY CM.CustNo, CM.CustShipLocation, CustQuote.SessionID) ManualQuote
GROUP BY ManualQuote.CustNo, ManualQuote.SalesLocationCode
 






------------------------------------------------------------------------------------------------------------------------------ 
-- **Manual Orders
--SELECT * FROM ##tManualOrder_D7DEC83B
--DROP TABLE ##tManualOrder_D7DEC83B
SELECT	ManualOrder.CustNo as CustomerNumber,
	ManualOrder.SalesLocationCode,
 		count(ManualOrder.NoOfManualOrders) as NoOfManualOrders,
 		sum(isnull(ManualOrder.ManualExtOrdWeight,0)) as ManualExtOrdWeight,
 		sum(isnull(ManualOrder.ManualExtOrdAmount,0)) as ManualExtOrdAmount 
--INTO	##tManualOrder_D7DEC83B 
FROM	(SELECT	CM.CustNo,
		CM.CustShipLocation as SalesLocationCode,
 		PendOrdHdr.ID,
 		count(CustQuote.QuoteNumber) as NoOfManualOrders,
 		Sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as ManualExtOrdWeight,
 		Sum(PendOrdDtl.TotalPrice) as ManualExtOrdAmount
 	 FROM	DTQ_CustomerPendingOrderDetail PendOrdDtl (NOLOCK) INNER JOIN
 		DTQ_CustomerQuotation CustQuote (NOLOCK)
 	 ON	PendOrdDtl.QuotationItemDetailID = CustQuote.QuoteNumber INNER JOIN
 		DTQ_CustomerPendingOrder PendOrdHdr (NOLOCK)
 	 ON	PendOrdDtl.PurchaseOrderID = PendOrdHdr.[ID] AND PendOrdHdr.OrderCompletedStatus ='true' INNER JOIN
 		CustomerMaster CM (NOLOCK)
 	 ON	CM.CustNo = CustQuote.CustomerNumber LEFT OUTER JOIN
 		(SELECT	LD.ListValue as OrdSrc,
 			isnull(LD.SequenceNo,0) as Sequence
 		 FROM	ListMaster LM (NOLOCK) INNER JOIN
 			ListDetail LD (NOLOCK)
 		 ON	LM.pListMasterID = LD.fListMasterID
 		 WHERE	LM.ListName = 'SOEOrderSource') Src
 	 ON	isnull(CustQuote.OrderSource,'RQ') = Src.OrdSrc
 	 WHERE	Src.Sequence <> 1 and 1=1 AND (Year(PendOrdHdr.PurchaseOrderDate) = 2011 AND Month(PendOrdHdr.PurchaseOrderDate) = 08) AND 
		CM.CustShipLocation like '%15%' AND CM.PriceCd <> 'X' AND 1=1
 	 GROUP BY CM.CustNo, CM.CustShipLocation, PendOrdHdr.ID) ManualOrder 
GROUP BY ManualOrder.CustNo, ManualOrder.SalesLocationCode




----USE THIS ONE
--NEW w/o SOE
SELECT	ManualOrder.CustNo as CustomerNumber,
	ManualOrder.SalesLocationCode,
 		count(ManualOrder.NoOfManualOrders) as NoOfManualOrders,
 		sum(isnull(ManualOrder.ManualExtOrdWeight,0)) as ManualExtOrdWeight,
 		sum(isnull(ManualOrder.ManualExtOrdAmount,0)) as ManualExtOrdAmount 
--INTO	##tManualOrder_D7DEC83B 
FROM	(SELECT	CM.CustNo,
		CM.CustShipLocation as SalesLocationCode,
 		CustQuote.SessionID,
 		count(CustQuote.QuoteNumber) as NoOfManualOrders,
 		sum(IM.GrossWght * CustQuote.RequestQuantity) as ManualExtOrdWeight,
		Sum(CustQuote.TotalPrice) as ManualExtOrdAmount
--select CustQuote.* 
	 FROM	DTQ_CustomerQuotation CustQuote (NOLOCK) INNER JOIN
		CustomerMaster CM (NOLOCK)
 	 ON	CM.CustNo = CustQuote.CustomerNumber INNER JOIN
		ItemMaster IM (NOLOCK)
	 ON	IM.ItemNo = CustQuote.PFCItemNo LEFT OUTER JOIN
 		(SELECT	LD.ListValue as OrdSrc,
 			isnull(LD.SequenceNo,0) as Sequence
 		 FROM	ListMaster LM (NOLOCK) INNER JOIN
 			ListDetail LD (NOLOCK)
 		 ON	LM.pListMasterID = LD.fListMasterID
 		 WHERE	LM.ListName = 'SOEOrderSource') Src
 	 ON	isnull(CustQuote.OrderSource,'RQ') = Src.OrdSrc
 	 WHERE	Src.Sequence <> 1 and 1=1 AND (Year(CustQuote.MakeOrderDt) = 2011 AND Month(CustQuote.MakeOrderDt) = 08) AND 
		CM.CustShipLocation like '%15%' AND CM.PriceCd <> 'X' AND 1=1
-- 		AND CustQuote.OrderCompletionStatus = 1
		AND isnull(MakeOrderID,'') <> ''	--this is a made order
 	 GROUP BY CM.CustNo, CM.CustShipLocation, CustQuote.SessionID) ManualOrder 
GROUP BY ManualOrder.CustNo, ManualOrder.SalesLocationCode





select MakeOrderId, MakeOrderDt, *
 from DTQ_CustomerQuotation where 

--isnull(MakeOrderID,'') <> '' --this is a made order
isnull(MakeOrderID,'') = '' --this is NOT a made order

----Don't use this one
--NEW with SOE
SELECT	ManualOrder.CustomerNumber,
 		count(ManualOrder.NoOfManualOrders) as NoOfManualOrders,
 		sum(isnull(ManualOrder.ManualExtOrdWeight,0)) as ManualExtOrdWeight,
 		sum(isnull(ManualOrder.ManualExtOrdAmount,0)) as ManualExtOrdAmount 
--INTO	##tManualOrder_D7DEC83B 
FROM	(SELECT	SOHead.SellToCustNo as CustomerNumber,
 		SOHead.OrderNo,
 		count(SOHead.OrderNo) as NoOfManualOrders,
 		Sum(SODtl.GrossWght * SODtl.QtyShipped) as ManualExtOrdWeight,
 		Sum(SODtl.NetUnitPrice * SODtl.QtyShipped) as ManualExtOrdAmount
 	 FROM	SOHeaderRel SOHead (NOLOCK) INNER JOIN
		SODetailRel SODtl (NOLOCK)
	 ON	SOHead.pSOHeaderRelID = SODtl.fSOHeaderRelID inner join
 		CustomerMaster CM (NOLOCK)
 	 ON	CM.CustNo = SOHead.SellToCustNo LEFT OUTER JOIN
 		(SELECT	LD.ListValue as OrdSrc,
 			isnull(LD.SequenceNo,0) as Sequence
 		 FROM	ListMaster LM (NOLOCK) INNER JOIN
 			ListDetail LD (NOLOCK)
 		 ON	LM.pListMasterID = LD.fListMasterID
 		 WHERE	LM.ListName = 'SOEOrderSource') Src
 	 ON	isnull(SOHead.OrderSource,'RQ') = Src.OrdSrc
 	 WHERE	Src.Sequence <> 1 and 1=1 AND (Year(SOHead.OrderDt) = 2011 AND Month(SOHead.OrderDt) = 08) AND 
		CM.CustShipLocation like '%15%' AND CM.PriceCd <> 'X' AND 1=1
 	 GROUP BY SOHead.SellToCustNo, SOHead.OrderNo) ManualOrder 
GROUP BY ManualOrder.CustomerNumber





select * from SODetailRel







select QuotationDate,ID, SessionID, QuoteNumber, 
* from DTQ_CustomerQuotation
where QuotationDate between getdate()-100 and getdate()-50


select * from SOHeader
where OrderDt > getdate()-125 and ordersource in ('RQ')









------------------------------------------------------------------------------------------------------------------------------  
-- **Missed eCommerce Quotes
--SELECT * FROM ##tMissedECommQuote_732386CE
--DROP TABLE ##tMissedECommQuote_732386CE
SELECT	ECommQuote.CustNo as CustomerNumber,
	ECommQuote.SalesLocationCode,
	count(ECommQuote.NoOfECommQuotes) as NoOfECommQuotes,
	sum(isnull(ECommQuote.eCommExtAmount,0)) as eCommExtAmount,
	sum(isnull(ECommQuote.eCommExtWeight,0)) as eCommExtWeight 
--INTO	##tMissedECommQuote_732386CE 
FROM	(SELECT	CM.CustNo,
		CM.CustShipLocation as SalesLocationCode,
 		CustQuote.SessionID,
 		count(CustQuote.QuoteNo) as NoOfECommQuotes,
 		sum(CustQuote.SellPrice * CustQuote.Qty) as eCommExtAmount,
		sum(IM.GrossWght * CustQuote.Qty) as eCommExtWeight
	 FROM	WebActivityPosting CustQuote (NOLOCK) INNER JOIN
 		CustomerMaster CM (NOLOCK)
 	 ON	CM.CustNo = CustQuote.CustNo INNER JOIN
		ItemMaster IM (NOLOCK)
	 ON	IM.ItemNo = CustQuote.ItemNo LEFT OUTER JOIN
 		(SELECT	LD.ListValue as OrdSrc,
 			isnull(LD.SequenceNo,0) as Sequence
 		 FROM	ListMaster LM (NOLOCK) INNER JOIN
 			ListDetail LD (NOLOCK)
 		 ON	LM.pListMasterID = LD.fListMasterID
 		 WHERE	LM.ListName = 'SOEOrderSource') Src
 	 ON	isnull(CustQuote.OrderSource,'RQ') = Src.OrdSrc
 	 WHERE	--CustQuote.DeleteFlag = 0 and		--IGNORE per TomJr
		Src.OrdSrc = 'WQ' and
		--CustQuote.OrderCompletionStatus <> 1 and 1=1 AND		--OrderCompletionStatus to be added to WebActivityPosting or add a MakeOrderID/Dt???
		(Year(CustQuote.QuoteDt) = 2011 AND Month(CustQuote.QuoteDt) = 08) AND 
		CM.CustShipLocation like '%15%' AND CM.PriceCd <> 'X'
 	 GROUP BY CM.CustNo, CM.CustShipLocation, CustQuote.SessionID) ECommQuote 
GROUP BY ECommQuote.CustNo, ECommQuote.SalesLocationCode

 



------------------------------------------------------------------------------------------------------------------------------ 
-- **Missed Manual Quotes
--SELECT * FROM ##tMissedManualQuote_2BBD2574
--DROP TABLE ##tMissedManualQuote_2BBD2574
SELECT	ManualQuote.CustNo as CustomerNumber,
	ManualQuote.SalesLocationCode,
	count(ManualQuote.NoOfManualQuotes) as NoOfManualQuotes,
	sum(isnull(ManualQuote.ManualExtAmount,0)) as ManualExtAmount,
	sum(isnull(ManualQuote.ManualExtWeight,0)) as ManualExtWeight 
--INTO	##tMissedManualQuote_2BBD2574 
FROM	(SELECT	CM.CustNo,
		CM.CustShipLocation as SalesLocationCode,
 		CustQuote.SessionID,
 		count(CustQuote.QuoteNumber) as NoOfManualQuotes,
 		sum(CustQuote.UnitPrice * CustQuote.RequestQuantity) as ManualExtAmount,
 		sum(CustQuote.GrossWeight * CustQuote.RequestQuantity) as ManualExtWeight
 	 FROM	DTQ_CustomerQuotation CustQuote (NOLOCK) INNER JOIN
 		CustomerMaster CM (NOLOCK)
 	 ON	CM.CustNo = CustQuote.CustomerNumber LEFT OUTER JOIN
 		(SELECT	LD.ListValue as OrdSrc,
 			isnull(LD.SequenceNo,0) as Sequence
 		 FROM	ListMaster LM (NOLOCK) INNER JOIN
 			ListDetail LD (NOLOCK)
 		 ON	LM.pListMasterID = LD.fListMasterID
 		 WHERE	LM.ListName = 'SOEOrderSource') Src
 	 ON	isnull(CustQuote.OrderSource,'RQ') = Src.OrdSrc
 	 WHERE	--CustQuote.DeleteFlag = 0 and		--IGNORE per TomJr
		Src.OrdSrc = 'RQ' and 
		--CustQuote.OrderCompletionStatus <> 1 and 
		isnull(MakeOrderID,'') = '' AND --this is NOT a made order		

		1=1 AND 
		(Year(CustQuote.QuotationDate) = 2011 AND Month(CustQuote.QuotationDate) = 08) AND CM.CustShipLocation like '%15%' AND CM.PriceCd <> 'X'
 	 GROUP BY CM.CustNo, CM.CustShipLocation, CustQuote.SessionID) ManualQuote 
GROUP BY ManualQuote.CustNo, ManualQuote.SalesLocationCode

 



------------------------------------------------------------------------------------------------------------------------------  
-- **Compile & return the complete dataset
--SELECT * FROM ##tResult5CDB4F66
--DROP TABLE ##tResult5CDB4F66
--DROP table ##tCustMaster_E4C831AB 

SELECT	DISTINCT 
	isnull(tECommQuote.CustomerNumber, isnull(tECommOrd.CustomerNumber, isnull(tManualQuote.CustomerNumber, isnull(tManualOrd.CustomerNumber, isnull(tMissedEcomm.CustomerNumber, isnull(tMissedManual.CustomerNumber,'No Cust')))))) as CustomerNumber,
	isnull(tECommQuote.SalesLocationCode, isnull(tECommOrd.SalesLocationCode, isnull(tManualQuote.SalesLocationCode, isnull(tManualOrd.SalesLocationCode, isnull(tMissedEcomm.SalesLocationCode, isnull(tMissedManual.SalesLocationCode,'No Cust')))))) as SalesLocationCode


INTO	##tCustMaster_E4C831AB



FROM	##tECommOrder_C111D852 tECommOrd FULL OUTER JOIN
	##tECommQuote_451E3051 tECommQuote

ON	tECommOrd.CustomerNumber = tECommQuote.CustomerNumber AND tECommOrd.SalesLocationCode = tECommQuote.SalesLocationCode FULL OUTER JOIN

	##tManualQuote_E4454AD7 tManualQuote
ON	tECommQuote.CustomerNumber = tManualQuote.CustomerNumber AND tECommQuote.SalesLocationCode = tManualQuote.SalesLocationCode FULL OUTER JOIN
	##tManualOrder_D7DEC83B tManualOrd
ON	tManualQuote.CustomerNumber = tManualOrd.CustomerNumber AND tManualQuote.SalesLocationCode = tManualOrd.SalesLocationCode FULL OUTER JOIN
	##tMissedECommQuote_732386CE tMissedEcomm
ON	tManualOrd.CustomerNumber = tMissedEcomm.CustomerNumber AND tManualOrd.SalesLocationCode = tMissedEcomm.SalesLocationCode FULL OUTER JOIN
	##tMissedManualQuote_2BBD2574 tMissedManual
ON	tMissedEcomm.CustomerNumber = tMissedManual.CustomerNumber AND tMissedEcomm.SalesLocationCode = tMissedManual.SalesLocationCode


select * from ##tCustMaster_E4C831AB 



SELECT


isnull(tCust.CustomerNumber, 'No Cust') as CustomerNumber,
isnull(tCust.SalesLocationCode, 'No Loc') as SalesLocationCode,

 			ISNULL(tECommQuote.NoOfECommQuotes,0) as NoOfECommQuotes,
 			ISNULL(cast((round(tECommQuote.eCommExtAmount,2)) as Decimal(25,2)),0) as eCommExtAmount,
 			ISNULL(cast((round(tECommQuote.eCommExtWeight,1)) as Decimal(25,1)),0) as eCommExtWeight,
 			ISNULL(tECommOrd.NoOfECommOrders,0) as NoOfECommOrders,
 			ISNULL(cast((round(tECommOrd.eCommExtOrdAmount,2)) as Decimal(25,2)),0) as eCommExtOrdAmount,
 			ISNULL(cast((round(tECommOrd.eCommExtOrdWeight,1)) as Decimal(25,1)),0) as eCommExtOrdWeight,
 			ISNULL(tManualQuote.NoOfManualQuotes,0) as NoOfManualQuotes,
 			ISNULL(cast((round(tManualQuote.ManualExtAmount,2)) as Decimal(25,2)),0) as ManualExtAmount,
 			ISNULL(cast((round(tManualQuote.ManualExtWeight,1)) as Decimal(25,1)),0) as ManualExtWeight,
 			ISNULL(tManualOrd.NoOfManualOrders,0) as NoOfManualOrders,
 			ISNULL(cast((round(tManualOrd.ManualExtOrdAmount,2)) as Decimal(25,2)),0) as ManualExtOrdAmount,
 			ISNULL(cast((round(tManualOrd.ManualExtOrdWeight,1)) as Decimal(25,1)),0) as ManualExtOrdWeight,
 			ISNULL(tMissedEcomm.NoOfECommQuotes,0) as NoOfMissedECommQuotes,
 			ISNULL(cast((round(tMissedEcomm.eCommExtAmount,2)) as Decimal(25,2)),0) as MissedECommExtAmount,
 			ISNULL(cast((round(tMissedEcomm.eCommExtWeight,1)) as Decimal(25,1)),0) as MissedECommExtWeight,
 			ISNULL(tMissedManual.NoOfManualQuotes,0) as NoOfMissedManualQuotes,
 			ISNULL(cast((round(tMissedManual.ManualExtAmount,2)) as Decimal(25,2)),0) as MissedManualExtAmount,
 			ISNULL(cast((round(tMissedManual.ManualExtWeight,1)) as Decimal(25,1)),0) as MissedManualExtWeight 
--INTO	##tResult5CDB4F66 

FROM	##tCustMaster_E4C831AB tCust LEFT OUTER JOIN
	##tECommOrder_C111D852 tECommOrd
ON	tCust.CustomerNumber = tECommOrd.CustomerNumber AND tCust.SalesLocationCode = tECommOrd.SalesLocationCode LEFT OUTER JOIN
	##tECommQuote_451E3051 tECommQuote
ON	tECommOrd.CustomerNumber = tECommQuote.CustomerNumber AND tECommOrd.SalesLocationCode = tECommQuote.SalesLocationCode LEFT OUTER JOIN
	##tManualQuote_E4454AD7 tManualQuote
ON	tECommQuote.CustomerNumber = tManualQuote.CustomerNumber AND tECommQuote.SalesLocationCode = tManualQuote.SalesLocationCode LEFT OUTER JOIN
	##tManualOrder_D7DEC83B tManualOrd
ON	tManualQuote.CustomerNumber = tManualOrd.CustomerNumber AND tManualQuote.SalesLocationCode = tManualOrd.SalesLocationCode LEFT OUTER JOIN
	##tMissedECommQuote_732386CE tMissedEcomm
ON	tManualOrd.CustomerNumber = tMissedEcomm.CustomerNumber AND tManualOrd.SalesLocationCode = tMissedEcomm.SalesLocationCode LEFT OUTER JOIN
	##tMissedManualQuote_2BBD2574 tMissedManual
ON	tMissedEcomm.CustomerNumber = tMissedManual.CustomerNumber AND tMissedEcomm.SalesLocationCode = tMissedManual.SalesLocationCode

order by CustomerNumber




