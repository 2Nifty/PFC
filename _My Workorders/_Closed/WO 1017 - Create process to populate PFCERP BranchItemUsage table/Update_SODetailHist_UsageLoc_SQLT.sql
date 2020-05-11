
Update	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.[SODetailHist]
Set	UsageLoc = NewUsageLoc
FROM
(Select Distinct UsageItemNo, NewUsageLoc, UsageInvoiceNo, pSOHeaderHistID
 From (	SELECT	AUE.[Item No_] as UsageItemNo, 
		AUE.[Usage Location] as NewUsageLoc, 
		SIH.No_ AS UsageInvoiceNo
	FROM	[Porteous$Actual Usage Entry] AUE
	INNER JOIN [Porteous$Sales Shipment Line] SSL ON 
		AUE.[Document No_] = SSL.[Document No_] 
		AND AUE.[Item No_] = SSL.[No_]
	INNER JOIN [Porteous$Sales Invoice Header] SIH ON 
		SSL.[Order No_] = SIH.[Order No_]
	WHERE	AUE.[Posting date] > CONVERT(DATETIME, '2006-12-31 00:00:00', 102)) tmp
	INNER JOIN OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.[SOHeaderHist] ON
		InvoiceNo=UsageInvoiceNo COLLATE SQL_Latin1_General_CP1_CI_AS) Usage
WHERE	fSOHeaderHistID = Usage.pSOHeaderHistID AND ItemNo = UsageItemNo COLLATE SQL_Latin1_General_CP1_CI_AS
