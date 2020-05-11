
Exec [pQuoteAndOrderHdrV2] '12','2010','','','','000001','','MANUAL','FALSE'
Exec [pQuoteAndOrderHdrV2] '12','2010','','','','032186','','ECOMM','FALSE'


select 
MakeOrderID, isnull(WebActivity.OrderSource,'RQ') as OrdSrc, *
from WebActivityPosting WebActivity
WHERE	--Src.[Sequence] = 1 AND 
		WebActivity.CustNo like '%032186%' and 
		Year(WebActivity.QuoteDt) = 2010 AND Month(WebActivity.QuoteDt) = 12

--and isnull(MakeOrderID,'')=''

order by SessionID




update WebActivityPosting set CustItemNo='NOTmade' where  isnull(MakeOrderID,'')=''
and 		CustNo like '%032186%' and 
		Year(QuoteDt) = 2010 AND Month(QuoteDt) = 12

-- pWebActivityPostingID in (1105173,1205173,1005173,905163,1005163,5164)



--------------------------------------------------------------------------------------------


select MakeOrderID, isnull(Quote.OrderSource,'RQ') as OrdSrc, * 
from DTQ_CustomerQuotation Quote
where Year(Quote.QuotationDate) = 2010 AND Month(Quote.QuotationDate) = 12 and CustomerNumber like '%000001%'
order by SessionID


update DTQ_CustomerQuotation
set UserItemNo='NOTMADE'
where Year(QuotationDate) = 2010 AND Month(.QuotationDate) = 12 and CustomerNumber like '%000001%' and isnull(MakeOrderID,'')=''


SELECT	LD.ListValue as OrdSrc,
 						isnull(LD.SequenceNo,0) as [Sequence]
 				 FROM	ListMaster LM (NOLOCK) INNER JOIN 
						ListDetail LD (NOLOCK)
 				 ON		LM.pListMasterID = LD.fListMasterID
 				 WHERE	LM.ListName = 'SOEOrderSource'


