SELECT	[Back Order], [Document Type], [Order Type], RefSONo, ERPHdr.*
FROM	SOHeader ERPHdr INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] NVHdr
ON	ERPHdr.RefSONo = NVHdr.[No_]
WHERE	NVHdr.[Back Order]=1



--Update Backorders
UPDATE	SOHeader
SET	OrderType = 'BO',
	BOFlag = 'BO',
	HoldDt = NVHdr.[Order Date],
	HoldReason = '11'
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] NVHdr
WHERE	SOHeader.RefSONo = NVHdr.[No_] AND NVHdr.[Back Order] = 1 AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)



--UPDATE HoldReasonName
UPDATE	SOHeader
SET	HoldReasonName = Reas.ShortDsc
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.Tables Reas
WHERE	TableType = 'Reas' AND SOHeader.HoldReason = Reas.TableCd AND
	SOHeader.HoldReason <> '' AND SOHeader.HoldReason is not null AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)



-------------------------------------------------------------------


SELECT	[Document Type], [Order Type], RefSONo, 
	QtyOrdered, QtyShipped, OriginalQtyRequested,
	ERPHdr.*
FROM	SOHeader ERPHdr INNER JOIN
	SODetail ERPDtl
on	pSOHeaderID = ERPDtl.fSOHeaderID inner join
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] NVHdr
ON	ERPHdr.RefSONo = NVHdr.[No_]
WHERE	NVHdr.[Document Type]=5  --RGA
and QtyOrdered>0





--Update RGA
UPDATE	SOHeader
SET	OrderType = 'RGA',
	HoldDt = NVHdr.[Order Date],
	HoldReason = 'RG'
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] NVHdr
WHERE	SOHeader.RefSONo = NVHdr.[No_] AND NVHdr.[Document Type] = 5 AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


--UPDATE RGA Detail
UPDATE	SODetail
SET	QtyOrdered =		CASE WHEN QtyOrdered > 0 THEN QtyOrdered * -1
				     ELSE QtyOrdered
				END,

	QtyShipped =		CASE WHEN QtyShipped > 0 THEN QtyShipped * -1
				     ELSE QtyShipped
				END,

	OriginalQtyRequested =	CASE WHEN OriginalQtyRequested > 0 THEN OriginalQtyRequested * -1
				     ELSE OriginalQtyRequested
				END
FROM	SOHeader
WHERE	SOHeader.pSOHeaderID = SODetail.fSOHeaderID AND OrderType = 'RGA' AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)




-------------------------------------------------------------------


SELECT	[Document Type], [Order Type], RefSONo, 
	QtyOrdered, QtyShipped, OriginalQtyRequested,
	ERPHdr.*
FROM	SOHeader ERPHdr INNER JOIN
	SODetail ERPDtl
on	pSOHeaderID = ERPDtl.fSOHeaderID inner join
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] NVHdr
ON	ERPHdr.RefSONo = NVHdr.[No_]
WHERE	NVHdr.[Document Type]=3  --Credit Memo
and QtyOrdered<0



--Update Credit Memos (CR)
UPDATE	SOHeader
SET	OrderType = 'CR',
	HoldDt = NVHdr.[Order Date],
	HoldReason = 'HW'
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] NVHdr
WHERE	SOHeader.RefSONo = NVHdr.[No_] AND NVHdr.[Document Type] = 3 AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)



--UPDATE Credit Memo Detail
UPDATE	SODetail
SET	QtyOrdered =		CASE WHEN QtyOrdered > 0 THEN QtyOrdered * -1
				     ELSE QtyOrdered
				END,

	QtyShipped =		CASE WHEN QtyShipped > 0 THEN QtyShipped * -1
				     ELSE QtyShipped
				END,

	OriginalQtyRequested =	CASE WHEN OriginalQtyRequested > 0 THEN OriginalQtyRequested * -1
				     ELSE OriginalQtyRequested
				END
FROM	SOHeader
WHERE	SOHeader.pSOHeaderID = SODetail.fSOHeaderID AND OrderType = 'CR' AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)






-------------------------------------------------------------------





Detail

QtyOrdered = QtyOrdered * -1
QtyShipped = QtyShipped * -1
OriginalQtyRequested = OriginalQtyRequested * -1
ExtendedPrice = ExtendedPrice * -1
ExtendedCost = ExtendedCost * -1
ExtendedNetWght = ExtendedNetWght * -1
ExtendedGrossWght = ExtendedGrossWght * -1




Expense 
Amount







--UPDATE Credit Memos & Returns in SODetail
UPDATE	SODetail
SET	QtyOrdered = QtyOrdered * -1,
	QtyShipped = QtyShipped * -1,
	OriginalQtyRequested = OriginalQtyRequested * -1,
	ExtendedPrice = ExtendedPrice * -1,
	ExtendedCost = ExtendedCost * -1,
	ExtendedNetWght = ExtendedNetWght * -1,
	ExtendedGrossWght = ExtendedGrossWght * -1
FROM	SOHeader
WHERE	SOHeader.pSOHeaderID = SODetail.fSOHeaderID AND (OrderType = 'CR' OR OrderType = 'RGA') AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)


select * from SOHeader inner join SODetail on SOHeader.pSOHeaderID = SODetail.fSOHeaderID where (OrderType = 'CR' OR OrderType = 'RGA') 



--UPDATE Credit Memos & Returns in SOExpense
UPDATE	SOExpense
SET	Amount = Amount * -1
FROM	SOHeader
WHERE	SOHeader.pSOHeaderID = SOExpense.fSOHeaderID AND (OrderType = 'CR' OR OrderType = 'RGA') AND
	EXISTS (SELECT	RefSONo
		FROM	OpenDataSource('SQLOLEDB','Data Source=EnterpriseSQL;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.tWO1376_Daily_SO_EDI_To_ERP TempSO
		WHERE	TempSO.RefSONo = SOHeader.RefSONo)
		
		
select SOExpense.* from SOHeader inner join SOExpense on SOHeader.pSOHeaderID = SOExpense.fSOHeaderID where (OrderType = 'CR' OR OrderType = 'RGA') 
select * from SOExpense