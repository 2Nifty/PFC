--[Porteous$Sales Comment Line] - Header Comments
SELECT	SOHeaderHist.pSOHeaderHistID as fSOHeaderHistID,
	'CT' as Type,
	'A' as FormsCd,
	0 as CommLineNo,
	[Line No_] as CommLineSeqNo,
	[Comment] as CommText,
	[User ID] as EntryID,
	[Date] as EntryDt
FROM	[Porteous$Sales Comment Line] COMMLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeaderHist SOHeaderHist
ON	COMMLINE.[No_] = SOHeaderHist.InvoiceNo COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	COMMLINE.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS IN (select InvoiceNo from PFCReports.dbo.tWO778_SOHeaderHist)


COMMLINE.[No_]='IP2896173' or 
	COMMLINE.[No_]='IP2896174' or 
	COMMLINE.[No_]='IP2896175' or 
	COMMLINE.[No_]='IP2896176' or 
	COMMLINE.[No_]='IP2896177' or 
	COMMLINE.[No_]='IP2896178' or 
	COMMLINE.[No_]='IP2896179' or 
	COMMLINE.[No_]='IP2896180' or 
	COMMLINE.[No_]='IP2896181' or 
	COMMLINE.[No_]='IP2896182' or 
	COMMLINE.[No_]='IP2896183' or 
	COMMLINE.[No_]='IP2896184' or 
	COMMLINE.[No_]='IP2896185' or 
	COMMLINE.[No_]='IP2896186' or 
	COMMLINE.[No_]='IP2896187' or 
	COMMLINE.[No_]='IP2896188' or 
	COMMLINE.[No_]='IP2896189' or 
	COMMLINE.[No_]='IP2896190' or 
	COMMLINE.[No_]='IP2896191' or 
	COMMLINE.[No_]='IP2896192' or 
	COMMLINE.[No_]='IP2896193' or 
	COMMLINE.[No_]='IP2896194' or 
	COMMLINE.[No_]='IP2896195' or 
	COMMLINE.[No_]='IP2896196' or 
	COMMLINE.[No_]='IP2896197' or 
	COMMLINE.[No_]='IP2896198' or 
	COMMLINE.[No_]='IP2896199' or 
	COMMLINE.[No_]='IP2896200'





--[Porteous$Sales Line Comment Line] - Line Comments
SELECT	SOHeaderHist.pSOHeaderHistID as fSOHeaderHistID,
	'LC' as Type,
	'A' as FormsCd,
	[Doc_ Line No_] as CommLineNo,
	[Line No_] as CommLineSeqNo,
	[Comment] as CommText,
	[User ID] as EntryID,
	[Date] as EntryDt
FROM	[Porteous$Sales Line Comment Line] COMMLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.SOHeaderHist SOHeaderHist
ON	COMMLINE.[No_] = SOHeaderHist.InvoiceNo COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	COMMLINE.[No_] COLLATE SQL_Latin1_General_CP1_CI_AS IN (select InvoiceNo from PFCReports.dbo.tWO778_SOHeaderHist)


WHERE	COMMLINE.[No_]='IP2896173' or 
	COMMLINE.[No_]='IP2896174' or 
	COMMLINE.[No_]='IP2896175' or 
	COMMLINE.[No_]='IP2896176' or 
	COMMLINE.[No_]='IP2896177' or 
	COMMLINE.[No_]='IP2896178' or 
	COMMLINE.[No_]='IP2896179' or 
	COMMLINE.[No_]='IP2896180' or 
	COMMLINE.[No_]='IP2896181' or 
	COMMLINE.[No_]='IP2896182' or 
	COMMLINE.[No_]='IP2896183' or 
	COMMLINE.[No_]='IP2896184' or 
	COMMLINE.[No_]='IP2896185' or 
	COMMLINE.[No_]='IP2896186' or 
	COMMLINE.[No_]='IP2896187' or 
	COMMLINE.[No_]='IP2896188' or 
	COMMLINE.[No_]='IP2896189' or 
	COMMLINE.[No_]='IP2896190' or 
	COMMLINE.[No_]='IP2896191' or 
	COMMLINE.[No_]='IP2896192' or 
	COMMLINE.[No_]='IP2896193' or 
	COMMLINE.[No_]='IP2896194' or 
	COMMLINE.[No_]='IP2896195' or 
	COMMLINE.[No_]='IP2896196' or 
	COMMLINE.[No_]='IP2896197' or 
	COMMLINE.[No_]='IP2896198' or 
	COMMLINE.[No_]='IP2896199' or 
	COMMLINE.[No_]='IP2896200'






COMMLINE.[No_] in (select InvoiceNo from tWO778_SOHeaderHist)



select ARPostDt, InvoiceNo AS NVInvoice, SellToCustNo, * from SOHeaderHist where left(InvoiceNo,2)='IP' and ARPostDt > getdate()-10
order by NVInvoice





select InvoiceNo from tWO778_SOHeaderHist



