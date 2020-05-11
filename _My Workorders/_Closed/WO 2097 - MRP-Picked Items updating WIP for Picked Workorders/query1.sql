Select SubType, StatusCd, InvoiceNo, InvoiceDt, CustPONo, * from SOHeaderRel (nolock) Where OrderNo='357989' --OrderNo ='357985' or OrderNo ='357988'
--Where OrderNo ='357981' or OrderNo ='357982' or OrderNo ='357983' or OrderNo ='357984'

select WipDt, * from POHeader where POOrderNo='WO10428'
--select WipDt, * from POHeader where isnull(WipDt,'')<>''

--select * from SOHeaderRel where StatusCd='IP'

Select StatusCd, * from InvoiceFlags (nolock) 
Where OrderNo='357989' --OrderNo ='357985' or OrderNo ='357988'
--Where OrderNo ='357981' or OrderNo ='357982' or OrderNo ='357983' or OrderNo ='357984'
order by pInvFlagsID

--update SOHeaderRel set InvoiceNo=null, InvoiceDt = null where pSOHeaderRelID=357984
--update InvoiceFlags set InvoiceDt=null, InvoicePostedDt=null where pInvFlagsID=52903



select EntryDt, InvoiceDt, * from TOHeaderHist Where OrderNo ='357981' or OrderNo ='357982' or OrderNo ='357983' or OrderNo ='357984'


select * from TOHeaderHist where pTOHeaderHistid=24678
select * from TODetailHist where fTOHeaderHistid=24678
select * from TOExpenseHist where fTOHeaderHistid=24678
select * from TOCommentsHist where fTOHeaderHistid=24678



	UPDATE	InvoiceFlags
	SET	StatusCD = 'IP'
	FROM	SOHeaderRel [SOHR] (NOLOCK)
	WHERE	InvoiceFlags.InvoiceDt IS NULL
		AND InvoiceFlags.OrderNo = [SOHR].OrderNo
		AND [SOHR].HoldDt IS NULL
		AND [SOHR].InvoiceNo IS NULL


select * from InvoiceFlags where InvoiceFlags.InvoiceDt is null

	select * 
	FROM	SOHeaderRel [SOHR] (NOLOCK)
	WHERE	InvoiceFlags.InvoiceDt IS NULL
		AND InvoiceFlags.OrderNo = [SOHR].OrderNo
		AND [SOHR].HoldDt IS NULL
		AND [SOHR].InvoiceNo IS NULL



pSOEProcessWOInvoice @orderNo = 357985

select * from OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').rbtest.dbo.[DNLOAD]
--where Field013='357985'



select	License_Plate, *
from	OpenDataSource('SQLOLEDB','Data Source=PFCDB05;User ID=pfcnormal;Password=pfcnormal').rbtest.dbo.[BINLOCAT]
where	PRODUCT='00200-2500-021' and BinLabel = '01WIP01' and isnull(License_Plate,'') <> ''




select * from SOHeaderRel where OrderNo='357981'
select * from SODetailRel where fSOHeaderRelID=357981
select * from SOExpenseRel where fSOHeaderRelID=357981
select * from SOCommentsRel where fSOHeaderRelID=357981

select * from SOHeaderHist where OrderNo='357981'
select * from SODetailHist where fSOHeaderHistID=1591818
select * from SOExpenseHist where fSOHeaderHistID=1591818
select * from SOCommentsHist where fSOHeaderHistID=1591818



select * from POHeader where POOrderNo='WO10428'
select * from PODetail where fPOHeaderID=10428
select * from POExpense where fPOHeaderID=10428
select * from POComments where fPOHeaderID=10428

select CustPONo, * from SOHeaderRel where OrderNo='357989'
select * from SODetailRel where fSOHeaderRelID=357989

select CustPONo, * from TOHeaderHist where OrderNo='357989'
select * from TODetailHist where fTOHeaderHistID=24681



