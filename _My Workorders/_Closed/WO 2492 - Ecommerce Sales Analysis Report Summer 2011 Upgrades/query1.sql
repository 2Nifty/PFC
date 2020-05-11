--SELECT	b.CustomerNumber, count(b.QuoteNumber) as NoofOrders,
--							Sum(b.GrossWeight*b.RequestQuantity) as ExtOrdWeight,
--							Sum(a.TotalPrice) as ExtOrdAmount --into ' + @strTempSold +




--drop table #tOrdSrcSeq
SELECT	LD.ListValue as OrdSrc,
		LD.SequenceNo as Sequence
INTO	#tOrdSrcSeq
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD
ON		LM.pListMasterID = LD.fListMasterID
WHERE	LM.ListName = 'SOEOrderSource'
--select * from #tOrdSrcSeq where Sequence=1

--150915
select a.LineSource as  [DTQ_CustomerPendingOrderDetail_SOURCE],
		b.OrderSource as OrderSource,-- Src.Sequence,		--use this one
		c.*
		
				  	FROM	DTQ_CustomerPendingOrderDetail a (NOLOCK) INNER JOIN
							DTQ_CustomerQuotation b (NOLOCK)
					ON		a.QuotationItemDetailID = b.QuoteNumber INNER JOIN
							DTQ_CustomerPendingOrder c (NOLOCK)
					ON		a.PurchaseOrderID = c.ID AND c.OrderCompletedStatus ='true' inner join
							OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM
					ON		CM.CustNo = b.CustomerNumber COLLATE Latin1_General_CS_AS --LEFT OUTER JOIN
--							#tOrdSrcSeq Src
--					ON		b.OrderSource = Src.OrdSrc
					--where	' + @strOrderWhere +
--				  	group by b.CustomerNumber 
--where b.OrderSource in ('MO','RQ','AD','AC')
order by b.OrderSource 



select a.LineSource as  [DTQ_CustomerPendingOrderDetail_SOURCE],
		b.OrderSource as OrderSource,-- Src.Sequence		--use this one
		c.*
		
				  	FROM	DTQ_CustomerPendingOrderDetail a (NOLOCK) INNER JOIN
							DTQ_CustomerQuotation b (NOLOCK)
					ON		a.QuotationItemDetailID = b.QuoteNumber INNER JOIN
							DTQ_CustomerPendingOrder c (NOLOCK)
					ON		a.PurchaseOrderID = c.ID AND c.OrderCompletedStatus ='true' inner join
							OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CustomerMaster CM
					ON		CM.CustNo = b.CustomerNumber COLLATE Latin1_General_CS_AS LEFT OUTER JOIN
							(SELECT	LD.ListValue as OrdSrc,
									LD.SequenceNo as Sequence
							 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN
									OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD
							 ON		LM.pListMasterID = LD.fListMasterID
							 WHERE	LM.ListName = 'SOEOrderSource') Src
					ON		b.OrderSource = Src.OrdSrc
					--where	' + @strOrderWhere +
--				  	group by b.CustomerNumber 
--where b.OrderSource in ('MO','RQ','AD','AC')
order by b.OrderSource 






SELECT	LD.ListValue, LD.SequenceNo
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListMaster LM INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.ListDetail LD
ON		LM.pListMasterID = LD.fListMasterID
WHERE	LM.ListName = 'SOEOrderSource'



select distinct TableType
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Tbl
order by TableType



select count(*) as SrcCnt, OrderSource from  DTQ_CustomerQuotation group by OrderSource





select distinct OrderSource from DTQ_CustomerQuotation

select OrderCompletionStatus, * from DTQ_CustomerQuotation


select OrderSource,* from DTQ_CustomerPendingOrder





SELECT	DTQ_CustomerQuotation.OrderSource,  PendOrdHdr.OrderSource

--update  DTQ_CustomerPendingOrder
--set DTQ_CustomerPendingOrder.OrderSource = DTQ_CustomerQuotation.OrderSource

FROM	DTQ_CustomerPendingOrderDetail PendOrdDtl (NOLOCK)  INNER JOIN
		DTQ_CustomerQuotation (NOLOCK) 
ON		PendOrdDtl.QuotationItemDetailID = DTQ_CustomerQuotation.QuoteNumber INNER JOIN
		DTQ_CustomerPendingOrder PendOrdHdr (NOLOCK) 
ON		PendOrdDtl.PurchaseOrderID = PendOrdHdr.ID 
where isnull(DTQ_CustomerQuotation.OrderSource,'')<>'' and isnull(PendOrdHdr.OrderSource,'') <> ''


