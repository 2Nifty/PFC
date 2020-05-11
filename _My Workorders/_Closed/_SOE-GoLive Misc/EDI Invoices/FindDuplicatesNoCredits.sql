
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






SELECT	ERP.*, NV.InvoiceNo AS [NV InvoiceNo], NV.NetSales AS [NV NetSales], NV.ARPostDt AS [NV ARPostDt],
	NV.DeleteDt AS [NV DeleteDt], NV.SellToCustNo, NV.SellToCustName
INTO	#tERPDuplicateInvoices
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



select * from #tERPDuplicateInvoices






IF ((SELECT COUNT(*)
     FROM   SOHeaderHist NV INNER JOIN
     (SELECT RefSONo, InvoiceNo AS [ERP InvoiceNo], CAST(OrderNo AS VARCHAR(10)) AS [ERP OrderNo],
	     NetSales AS [ERP NetSales], ARPostDt AS [ERP ARPostDt], DeleteDt AS [ERP DeleteDt]
      FROM   SOHeaderHist
      WHERE  LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP' AND LEFT(InvoiceNo,3) <> 'SCR' AND
	     RefSONo in (SELECT RefSONo
			 FROM   SOHeaderHist
			 WHERE  LEFT(RefSONo,2) = 'SO' AND (LEFT(InvoiceNo,2) = 'IP' OR LEFT(InvoiceNo,3) = 'SCR'))) ERP
     ON	    NV.RefSONo = ERP.RefSONo
     WHERE  LEFT(NV.RefSONo,2) = 'SO' AND (LEFT(NV.InvoiceNo,2) = 'IP' OR LEFT(NV.InvoiceNo,3) = 'SCR') AND
	    NV.RefSONo in (SELECT RefSONo
			   FROM	  SOHeaderHist 
			   WHERE  LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP' AND LEFT(InvoiceNo,3) <> 'SCR') AND
	    ERP.[ERP OrderNo] not in (SELECT RefSONo
				      FROM   SOHeader
				      WHERE  SubType='51' AND
					     RefSONo in (SELECT	CAST(OrderNo AS VARCHAR(10))
							 FROM	SOHeaderHist
							 WHERE	LEFT(RefSONo,2) = 'SO' AND LEFT(InvoiceNo,2) <> 'IP' AND LEFT(InvoiceNo,3) <> 'SCR'))) > 0)

--IF Duplicates are found, then send email
IF ((SELECT COUNT(*) FROM #tERPDuplicateInvoices) > 0)

   BEGIN
	PRINT 'Duplicates found'
	Exec DTQ_SP_SendMailWithAttachment 'it_ops@porteousfastener.com','it@porteousfastener.com, jtoves@porteousfastener.com',
					   'ERP Duplicate Invoices',
					   'Attached please find a list of Invoices that are duplicated in ERP.<br>One Invoice created by NV; the other created by ERP',
					   '\\pfcfiles\userdb\WO1341_ERP_Rejections.csv'
   END
ELSE 
   BEGIN
	PRINT 'No duplicates found'
   END



