
Exec [pQuoteAndOrderV2] '12','2010','','','','032186','false','','false'

---------------------------------------------------------------------------------------------------------------------------------------------



-- whereWebActivity: 0=0 AND CM.CustShipLocation like '%15%' AND CM.CustNo like '%200836%' AND CM.PriceCd <> 'X' AND 1=1 AND Year(WebActivity.QuoteDt) = 2011 AND Month(WebActivity.QuoteDt) = 10 AND 2=2
-- whereQuote: 0=0 AND CM.CustShipLocation like '%15%' AND CM.CustNo like '%200836%' AND CM.PriceCd <> 'X' AND 11=11 AND Year(Quote.QuotationDate) = 2011 AND Month(Quote.QuotationDate) = 10 AND 22=22
 



-- BEGIN: Get eCommerce Quote & Order Data
--	**eCommerce Quotes FROM WebActivityPosting WHERE WebActivity.OrderSource[Sequence] = 1
			--SELECT * FROM ##tECommQuote_1FEC50FB
			--DROP TABLE ##tECommQuote_1FEC50FB
SELECT	ECommQuote.CustNo as CustomerNumber,
 		ECommQuote.SalesLocationCode,
 		count(ECommQuote.NoOfECommQuotes) as NoOfECommQuotes,
 		sum(isnull(ECommQuote.eCommExtAmount,0)) as eCommExtAmount,
 		sum(isnull(ECommQuote.eCommExtWeight,0)) as eCommExtWeight 
--INTO	##tECommQuote_1FEC50FB 
FROM	(

		 SELECT	CM.CustNo,
 				CM.CustShipLocation as SalesLocationCode,
 				WebActivity.SessionID,
WebActivity.QuoteRowID,
WebActivity.MakeOrderID

-- 				count(WebActivity.QuoteNo) as NoOfECommQuotes,
-- 				sum(WebActivity.SellPrice * WebActivity.Qty) as eCommExtAmount,
-- 				sum(IM.GrossWght * WebActivity.Qty) as eCommExtWeight
 		 FROM	WebActivityPosting WebActivity (NOLOCK) INNER JOIN
 				CustomerMaster  CM (NOLOCK)
 		 ON		CM.CustNo = WebActivity.CustNo INNER JOIN
 				ItemMaster IM (NOLOCK)
 		 ON		IM.ItemNo = WebActivity.ItemNo LEFT OUTER JOIN
 				(SELECT	LD.ListValue as OrdSrc,
 						isnull(LD.SequenceNo,0) as [Sequence]
 				 FROM	ListMaster LM (NOLOCK) INNER JOIN
 						ListDetail LD (NOLOCK)
 				 ON		LM.pListMasterID = LD.fListMasterID
 				 WHERE	LM.ListName = 'SOEOrderSource') Src
 		 ON		isnull(WebActivity.OrderSource,'RQ') = Src.OrdSrc
 		 WHERE	Src.[Sequence] = 1 AND 0=0 AND CM.CustShipLocation like '%15%' AND CM.CustNo like '%200836%' AND CM.PriceCd <> 'X' AND 1=1 AND 
				Year(WebActivity.QuoteDt) = 2011 AND Month(WebActivity.QuoteDt) = 10 AND 2=2
-- 		 GROUP BY	CM.CustNo, CM.CustShipLocation, WebActivity.SessionID

		) ECommQuote 
GROUP BY  ECommQuote.CustNo, ECommQuote.SalesLocationCode
 

--	**eCommerce Orders FROM WebActivityPosting WHERE WebActivity.OrderSource[Sequence] = 1 AND WebActivity.OrderCompletionStatus = 1
			--SELECT * FROM ##tECommOrder_8E240C64
			--DROP TABLE ##tECommOrder_8E240C64
SELECT	ECommOrder.CustNo as CustomerNumber,
 		ECommOrder.SalesLocationCode,
 		count(ECommOrder.NoOfECommOrders) as NoOfECommOrders,
 		sum(isnull(ECommOrder.eCommExtOrdAmount,0)) as eCommExtOrdAmount,
 		sum(isnull(ECommOrder.eCommExtOrdWeight,0)) as eCommExtOrdWeight 
--INTO	##tECommOrder_8E240C64
FROM	(

		 SELECT	CM.CustNo,
 				CM.CustShipLocation as SalesLocationCode,
 				WebActivity.SessionID,
--WebActivity.QuoteRowID,
--WebActivity.MakeOrderID
 				count(WebActivity.QuoteNo) as NoOfECommOrders,
 				Sum(WebActivity.SellPrice * WebActivity.Qty) as eCommExtOrdAmount,
 				Sum(IM.GrossWght * WebActivity.Qty) as eCommExtOrdWeight
 		 FROM	WebActivityPosting WebActivity (NOLOCK) INNER JOIN
 				CustomerMaster CM (NOLOCK)
 		 ON		CM.CustNo = WebActivity.CustNo INNER JOIN
 				ItemMaster IM (NOLOCK)
 		 ON		IM.ItemNo = WebActivity.ItemNo LEFT OUTER JOIN
 				(SELECT	LD.ListValue as OrdSrc,
 						isnull(LD.SequenceNo,0) as [Sequence]
 				 FROM	ListMaster LM (NOLOCK) INNER JOIN
 						ListDetail LD (NOLOCK)
 				 ON		LM.pListMasterID = LD.fListMasterID
 				 WHERE	LM.ListName = 'SOEOrderSource') Src
 		 ON		isnull(WebActivity.OrderSource,'RQ') = Src.OrdSrc
 		 WHERE	Src.[Sequence] = 1 AND
 				isnull(WebActivity.MakeOrderID,'') <> '' AND 0=0 AND CM.CustShipLocation like '%15%' AND CM.CustNo like '%200836%' AND CM.PriceCd <> 'X' AND 1=1 AND
				Year(WebActivity.QuoteDt) = 2011 AND Month(WebActivity.QuoteDt) = 10 AND 2=2
 		 GROUP BY CM.CustNo, CM.CustShipLocation, WebActivity.SessionID

		) ECommOrder 
GROUP BY  ECommOrder.CustNo, ECommOrder.SalesLocationCode
-- END: Get eCommerce Quote & Order Data


*****************************************************


-- BEGIN: Get Manual Quote & Order Data
--	**Manual Quotes FROM DTQ_CustomerQuotation WHERE Quote.OrderSource[Sequence] <> 1
			--SELECT * FROM ##tManualQuote_94BAE556
			--DROP TABLE ##tManualQuote_94BAE556
SELECT	ManualQuote.CustNo as CustomerNumber,
 		ManualQuote.SalesLocationCode,
 		count(ManualQuote.NoOfManualQuotes) as NoOfManualQuotes,
 		sum(isnull(ManualQuote.ManualExtAmount,0)) as ManualExtAmount,
 		sum(isnull(ManualQuote.ManualExtWeight,0)) as ManualExtWeight 
--INTO	##tManualQuote_94BAE556 
FROM	(

		 SELECT	CM.CustNo,
 				CM.CustShipLocation as SalesLocationCode,
 				Quote.SessionID,
Quote.ID,
Quote.MakeOrderID
-- 				count(Quote.QuoteNumber) as NoOfManualQuotes,
-- 				sum(Quote.UnitPrice * Quote.RequestQuantity) as ManualExtAmount,
-- 				sum(Quote.GrossWeight * Quote.RequestQuantity) as ManualExtWeight
 		 FROM	DTQ_CustomerQuotation Quote (NOLOCK) INNER JOIN
 				CustomerMaster CM (NOLOCK)
 		 ON		CM.CustNo = Quote.CustomerNumber LEFT OUTER JOIN
 				(SELECT	LD.ListValue as OrdSrc,
 						isnull(LD.SequenceNo,0) as [Sequence]
 				 FROM	ListMaster LM (NOLOCK) INNER JOIN 
						ListDetail LD (NOLOCK)
 				 ON		LM.pListMasterID = LD.fListMasterID
 				 WHERE	LM.ListName = 'SOEOrderSource') Src
 		 ON		isnull(Quote.OrderSource,'RQ') = Src.OrdSrc
 		 WHERE	Src.[Sequence] <> 1 AND 0=0 AND CM.CustShipLocation like '%15%' AND CM.CustNo like '%200836%' AND CM.PriceCd <> 'X' AND 11=11 AND
				Year(Quote.QuotationDate) = 2011 AND Month(Quote.QuotationDate) = 10 AND 22=22
-- 		 GROUP BY CM.CustNo, CM.CustShipLocation, Quote.SessionID

		) ManualQuote 
GROUP BY ManualQuote.CustNo, ManualQuote.SalesLocationCode
 
--	**Manual Orders FROM DTQ_CustomerQuotation WHERE Quote.OrderSource[Sequence] <> 1 AND isnull(Quote.MakeOrderID,'') <> ''
			--SELECT * FROM ##tManualOrder_207958B2
			--DROP TABLE ##tManualOrder_207958B2
SELECT	ManualOrder.CustNo as CustomerNumber,
 		ManualOrder.SalesLocationCode,
 		count(ManualOrder.NoOfManualOrders) as NoOfManualOrders,
 		sum(isnull(ManualOrder.ManualExtOrdAmount,0)) as ManualExtOrdAmount,
 		sum(isnull(ManualOrder.ManualExtOrdWeight,0)) as ManualExtOrdWeight 
--INTO	##tManualOrder_207958B2 
FROM	(

		 SELECT	CM.CustNo,
 				CM.CustShipLocation as SalesLocationCode,
 				Quote.SessionID,
Quote.ID,
Quote.MakeOrderID
-- 				count(Quote.QuoteNumber) as NoOfManualOrders,
-- 				Sum(Quote.UnitPrice * Quote.RequestQuantity) as ManualExtOrdAmount,
-- 				sum(IM.GrossWght * Quote.RequestQuantity) as ManualExtOrdWeight
 		 FROM	DTQ_CustomerQuotation Quote (NOLOCK) INNER JOIN
 				CustomerMaster CM (NOLOCK)
 		 ON		CM.CustNo = Quote.CustomerNumber INNER JOIN
 				ItemMaster IM (NOLOCK)
 		 ON		IM.ItemNo = Quote.PFCItemNo LEFT OUTER JOIN
 				(SELECT	LD.ListValue as OrdSrc,
 						isnull(LD.SequenceNo,0) as [Sequence]
 				 FROM	ListMaster LM (NOLOCK) INNER JOIN
 						ListDetail LD (NOLOCK)
 				 ON		LM.pListMasterID = LD.fListMasterID
 				 WHERE	LM.ListName = 'SOEOrderSource') Src
 		 ON		isnull(Quote.OrderSource,'RQ') = Src.OrdSrc
 		 WHERE	Src.[Sequence] <> 1 AND
 				isnull(Quote.MakeOrderID,'') <> '' AND 0=0 AND CM.CustShipLocation like '%15%' AND CM.CustNo like '%200836%' AND CM.PriceCd <> 'X' AND 11=11 AND
				Year(Quote.QuotationDate) = 2011 AND Month(Quote.QuotationDate) = 10 AND 22=22
-- 		 GROUP BY CM.CustNo, CM.CustShipLocation, Quote.SessionID

		) ManualOrder 
GROUP BY ManualOrder.CustNo, ManualOrder.SalesLocationCode
-- END: Get Manual Quote & Order Data
*****************************************************




-- BEGIN: Get Missed eCommerce Quote Data
--	**Missed eCommerce Quotes FROM WebActivityPosting WHERE WebActivity.OrderSource = 'WQ' AND WebActivity.OrderCompletionStatus <> 1
			--SELECT * FROM ##tMissedECommQuote_B70FECED
			--DROP TABLE ##tMissedECommQuote_B70FECED
SELECT	ECommQuote.CustNo as CustomerNumber,
 		ECommQuote.SalesLocationCode,
 		count(ECommQuote.NoOfECommQuotes) as NoOfECommQuotes,
 		sum(isnull(ECommQuote.eCommExtAmount,0)) as eCommExtAmount,
 		sum(isnull(ECommQuote.eCommExtWeight,0)) as eCommExtWeight 
--INTO	##tMissedECommQuote_B70FECED 
FROM	(

		 SELECT	CM.CustNo,
 				CM.CustShipLocation as SalesLocationCode,
 				WebActivity.SessionID,
--WebActivity.QuoteRowID,
--WebActivity.MakeOrderID
 				count(WebActivity.QuoteNo) as NoOfECommQuotes,
 				sum(WebActivity.SellPrice * WebActivity.Qty) as eCommExtAmount,
 				sum(IM.GrossWght * WebActivity.Qty) as eCommExtWeight
 		 FROM	WebActivityPosting WebActivity (NOLOCK) INNER JOIN
 				CustomerMaster CM (NOLOCK)
 		 ON		CM.CustNo = WebActivity.CustNo INNER JOIN
 				ItemMaster IM (NOLOCK)
 		 ON		IM.ItemNo = WebActivity.ItemNo
 		 WHERE	--WebActivity.OrderSource = 'WQ' AND
 				isnull(WebActivity.MakeOrderID,'') = '' AND 0=0 AND CM.CustShipLocation like '%15%' AND CM.CustNo like '%200836%' AND CM.PriceCd <> 'X' AND 1=1 AND
				Year(WebActivity.QuoteDt) = 2011 AND Month(WebActivity.QuoteDt) = 10
 		 GROUP BY CM.CustNo, CM.CustShipLocation, WebActivity.SessionID

		) ECommQuote 
GROUP BY ECommQuote.CustNo, ECommQuote.SalesLocationCode
-- END: Get Missed eCommerce Quote Data



*****************************************************
-- BEGIN: Get Missed Manual Quote Data
--	**Missed Manual Quotes FROM DTQ_CustomerQuotation WHERE	Quote.OrderSource = 'RQ' AND isnull(Quote.MakeOrderID,'') = ''
			--SELECT * FROM ##tMissedManualQuote_7E46181F
			--DROP TABLE ##tMissedManualQuote_7E46181F
SELECT	ManualQuote.CustNo as CustomerNumber,
 		ManualQuote.SalesLocationCode,
 		count(ManualQuote.NoOfManualQuotes) as NoOfManualQuotes,
 		sum(isnull(ManualQuote.ManualExtAmount,0)) as ManualExtAmount,
 		sum(isnull(ManualQuote.ManualExtWeight,0)) as ManualExtWeight 
--INTO	##tMissedManualQuote_7E46181F 
FROM	(

		 SELECT	CM.CustNo,
 				CM.CustShipLocation as SalesLocationCode,
 				Quote.SessionID,
Quote.ID,
Quote.MakeOrderID
-- 				count(Quote.QuoteNumber) as NoOfManualQuotes,
-- 				sum(Quote.UnitPrice * Quote.RequestQuantity) as ManualExtAmount,
-- 				sum(Quote.GrossWeight * Quote.RequestQuantity) as ManualExtWeight
 		 FROM	DTQ_CustomerQuotation Quote (NOLOCK) INNER JOIN
 				CustomerMaster CM (NOLOCK)
 		 ON		CM.CustNo = Quote.CustomerNumber
 		 WHERE	--Quote.OrderSource = 'RQ' AND
 				isnull(Quote.MakeOrderID,'') = '' AND 0=0 AND CM.CustShipLocation like '%15%' AND CM.CustNo like '%200836%' AND CM.PriceCd <> 'X' AND 11=11 AND
				Year(Quote.QuotationDate) = 2011 AND Month(Quote.QuotationDate) = 10
-- 		 GROUP BY CM.CustNo, CM.CustShipLocation, Quote.SessionID

		) ManualQuote 
GROUP BY ManualQuote.CustNo, ManualQuote.SalesLocationCode
-- END: Get Missed Manual Quote Data
*****************************************************
-- BEGIN: Compile & return the complete dataset
--	**DISTINCT CustomerNumber/SalesLocation list
			--SELECT * FROM ##tCustMaster_8CCADD11
			--DROP TABLE ##tCustMaster_8CCADD11
SELECT	DISTINCT
		isnull(tECommQuote.CustomerNumber, isnull(tECommOrd.CustomerNumber, isnull(tManualQuote.CustomerNumber, isnull(tManualOrd.CustomerNumber, isnull(tMissedEcomm.CustomerNumber, isnull(tMissedManual.CustomerNumber,'No Cust')))))) as CustomerNumber,
		isnull(tECommQuote.SalesLocationCode, isnull(tECommOrd.SalesLocationCode, isnull(tManualQuote.SalesLocationCode, isnull(tManualOrd.SalesLocationCode, isnull(tMissedEcomm.SalesLocationCode, isnull(tMissedManual.SalesLocationCode,'No Loc')))))) as SalesLocationCode
--INTO	##tCustMaster_8CCADD11
FROM	##tECommOrder_8E240C64 tECommOrd FULL OUTER JOIN
		##tECommQuote_1FEC50FB tECommQuote
ON		tECommOrd.CustomerNumber = tECommQuote.CustomerNumber AND tECommOrd.SalesLocationCode = tECommQuote.SalesLocationCode FULL OUTER JOIN
		##tManualQuote_94BAE556 tManualQuote
ON		tECommQuote.CustomerNumber = tManualQuote.CustomerNumber AND tECommQuote.SalesLocationCode = tManualQuote.SalesLocationCode FULL OUTER JOIN
		##tManualOrder_207958B2 tManualOrd
ON		tManualQuote.CustomerNumber = tManualOrd.CustomerNumber AND tManualQuote.SalesLocationCode = tManualOrd.SalesLocationCode FULL OUTER JOIN
		##tMissedECommQuote_B70FECED tMissedEcomm
ON		tManualOrd.CustomerNumber = tMissedEcomm.CustomerNumber AND tManualOrd.SalesLocationCode = tMissedEcomm.SalesLocationCode FULL OUTER JOIN
		##tMissedManualQuote_7E46181F tMissedManual
ON		tMissedEcomm.CustomerNumber = tMissedManual.CustomerNumber AND tMissedEcomm.SalesLocationCode = tMissedManual.SalesLocationCode 
 
--	**Compile all recordsets by CustomerNumber/SalesLocation
			--SELECT * FROM ##tResult11722F87
			--DROP TABLE ##tResult11722F87
SELECT	isnull(tCust.CustomerNumber, 'No Cust') as CustomerNumber,
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
--INTO	##tResult11722F87
FROM	##tCustMaster_8CCADD11 tCust LEFT OUTER JOIN
		##tECommOrder_8E240C64 tECommOrd
ON		tCust.CustomerNumber = tECommOrd.CustomerNumber AND tCust.SalesLocationCode = tECommOrd.SalesLocationCode LEFT OUTER JOIN
		##tECommQuote_1FEC50FB tECommQuote
ON		tCust.CustomerNumber = tECommQuote.CustomerNumber AND tCust.SalesLocationCode = tECommQuote.SalesLocationCode LEFT OUTER JOIN
		##tManualQuote_94BAE556 tManualQuote
ON		tCust.CustomerNumber = tManualQuote.CustomerNumber AND tCust.SalesLocationCode = tManualQuote.SalesLocationCode LEFT OUTER JOIN
		##tManualOrder_207958B2 tManualOrd
ON		tCust.CustomerNumber = tManualOrd.CustomerNumber AND tCust.SalesLocationCode = tManualOrd.SalesLocationCode LEFT OUTER JOIN
		##tMissedECommQuote_B70FECED tMissedEcomm
ON		tCust.CustomerNumber = tMissedEcomm.CustomerNumber AND tCust.SalesLocationCode = tMissedEcomm.SalesLocationCode LEFT OUTER JOIN
		##tMissedManualQuote_7E46181F tMissedManual
ON		tCust.CustomerNumber = tMissedManual.CustomerNumber AND tCust.SalesLocationCode = tMissedManual.SalesLocationCode 
-- END: Compile & return the complete dataset
