

select RefSONo, SellToCustNo, InvoiceNo, InvoiceDt, *
from SOHeader
where left(RefSONo,2)='SO' and (SellToCustNo='063881' or SellToCustNo='200301') and (InvoiceDt is null or InvoiceDt ='')





------------------------------------------------------------------------------------------------------


--Orig duplicate check
SELECT	ERP.*, NV.InvoiceNo AS [NV InvoiceNo], NV.NetSales AS [NV NetSales], NV.ARPostDt AS [NV ARPostDt],
	NV.DeleteDt AS [NV DeleteDt], NV.SellToCustNo, NV.SellToCustName
FROM	SOHeaderHist NV INNER JOIN
(SELECT	RefSONo, InvoiceNo AS [ERP InvoiceNo], CAST(OrderNo AS VARCHAR(10)) AS [ERP OrderNo],
	NetSales AS [ERP NetSales], ARPostDt AS [ERP ARPostDt], DeleteDt AS [ERP DeleteDt]
 FROM	SOHeaderHist
 WHERE	LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP' AND LEFT(InvoiceNo,3) <> 'SCR' AND
	RefSONo in (SELECT RefSONo
		    FROM   SOHeaderHist
		    WHERE  LEFT(RefSONo,2) = 'SO' AND (LEFT(InvoiceNo,2) = 'IP' OR LEFT(InvoiceNo,3) = 'SCR'))) ERP
ON	NV.RefSONo = ERP.RefSONo
WHERE	LEFT(NV.RefSONo,2) = 'SO' AND (LEFT(NV.InvoiceNo,2) = 'IP' OR LEFT(NV.InvoiceNo,3) = 'SCR') AND
	NV.RefSONo in (SELECT	RefSONo
		       FROM	SOHeaderHist 
		       WHERE	LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP' AND LEFT(InvoiceNo,3) <> 'SCR') AND
	ERP.[ERP OrderNo] not in (SELECT RefSONo
				  FROM	 SOHeader
				  WHERE	 SubType='51' AND
					 RefSONo in (SELECT CAST(OrderNo AS VARCHAR(10))
				  FROM	 SOHeaderHist
				  WHERE	 LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP' AND LEFT(InvoiceNo,3) <> 'SCR'))
Order By ERP.RefSONo


--Modified duplicate check
SELECT	ERP.*, NV.InvoiceNo AS [NV InvoiceNo], NV.NetSales AS [NV NetSales], NV.ARPostDt AS [NV ARPostDt],
	NV.DeleteDt AS [NV DeleteDt], NV.SellToCustNo, NV.SellToCustName
FROM	SOHeaderHist NV INNER JOIN
(SELECT	LEFT(RefSONo,9) AS RefSONo, InvoiceNo AS [ERP InvoiceNo], CAST(OrderNo AS VARCHAR(10)) AS [ERP OrderNo],
	NetSales AS [ERP NetSales], ARPostDt AS [ERP ARPostDt], DeleteDt AS [ERP DeleteDt]
 FROM	SOHeaderHist
 WHERE	LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP' AND LEFT(InvoiceNo,3) <> 'SCR' AND
	LEFT(RefSONo,9) in (SELECT RefSONo
			    FROM   SOHeaderHist
			    WHERE  LEFT(RefSONo,2) = 'SO' AND (LEFT(InvoiceNo,2) = 'IP' OR LEFT(InvoiceNo,3) = 'SCR'))) ERP
ON	NV.RefSONo = ERP.RefSONo
WHERE	LEFT(NV.RefSONo,2) = 'SO' AND (LEFT(NV.InvoiceNo,2) = 'IP' OR LEFT(NV.InvoiceNo,3) = 'SCR') AND
	NV.RefSONo in (SELECT	LEFT(RefSONo,9) AS RefSONo
		       FROM	SOHeaderHist 
		       WHERE	LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP' AND LEFT(InvoiceNo,3) <> 'SCR') AND
	ERP.[ERP OrderNo] not in (SELECT RefSONo
				  FROM	 SOHeader
				  WHERE	 SubType='51' AND
					 RefSONo in (SELECT CAST(OrderNo AS VARCHAR(10))
						     FROM   SOHeaderHist
						     WHERE  LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP' AND LEFT(InvoiceNo,3) <> 'SCR'))
Order By ERP.RefSONo



------------------------------------------------------------------------------------------------------

--235
SELECT	RefSONo, InvoiceDt, InvoiceNo, SellToCustNo, OrderType, EntryDt, EntryId, ChangeID, ChangeDt, *
FROM	SOHeader
WHERE	LEFT(RefSONo,2) = 'SO' AND RIGHT(RefSONo,4) <> '-ERP' AND
	(InvoiceDt = '' OR InvoiceDt is null) AND
	(SellToCustNo = '063881' OR SellToCustNo = '200301')


--(235 row(s) affected)
UPDATE	SOHeader
SET	RefSONo = RefSONo + '-ERP',
	ChangeID = 'TOD',
	ChangeDt = GetDate()
WHERE	LEFT(RefSONo,2) = 'SO' AND RIGHT(RefSONo,4) <> '-ERP' AND
	(InvoiceDt = '' OR InvoiceDt is null) AND
	(SellToCustNo = '063881' OR SellToCustNo = '200301')




--22
SELECT	RefSONo, InvoiceDt, InvoiceNo, SellToCustNo, OrderType, EntryDt, EntryId, ChangeID, ChangeDt, *
FROM	SOHeaderRel
WHERE	LEFT(RefSONo,2) = 'SO' AND --RIGHT(RefSONo,4) <> '-ERP' AND
	(InvoiceDt = '' OR InvoiceDt is null) AND
	(SellToCustNo = '063881' OR SellToCustNo = '200301')


--(22 row(s) affected)
UPDATE	SOHeaderRel
SET	RefSONo = RefSONo + '-ERP',
	ChangeID = 'TOD',
	ChangeDt = GetDate()
WHERE	LEFT(RefSONo,2) = 'SO' AND RIGHT(RefSONo,4) <> '-ERP' AND
	(InvoiceDt = '' OR InvoiceDt is null) AND
	(SellToCustNo = '063881' OR SellToCustNo = '200301')



------------------------------------------------------------------------------------------------------

UPDATE	SOHeader
SET	RefSONo = RefSONo + '-ERP',
	ChangeID = 'TOD',
	ChangeDt = GetDate()
WHERE	LEFT(RefSONo,2) = 'SO' AND RIGHT(RefSONo,4) <> '-ERP' AND
	(SellToCustNo = '063881' OR SellToCustNo = '200301') AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
--		FROM 	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)



--EnterpriseSQL
UPDATE	tWO1376_Daily_SO_EDI_To_ERP
SET	RefSONo = RefSONo + '-ERP'




------------------------------------------------------------------------------------------------------



select RefSONo as ref, * from SOHeader where RIGHT(RefSONo,4) = '-ERP'
order by RefSONo


UPDATE SOHeader set RefSONo=Left(RefSONo,9)
where  RIGHT(RefSONo,4) = '-ERP'

('SO3108300-ERP',
'SO3108301-ERP',
'SO3108303-ERP',
'SO3108304-ERP',
'SO3108305-ERP')




select RefSoNo, * from SOHeaderHist where InvoiceNo in
('107049',
'105400',
'105401',
'107051',
'90997')


update SOHeaderHist
set RefSONo = RefSONo + '-ERP'
where InvoiceNo in
('107049',
'105400',
'105401',
'107051',
'90997')
