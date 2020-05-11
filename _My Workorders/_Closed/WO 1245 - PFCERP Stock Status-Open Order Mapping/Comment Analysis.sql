

--[Porteous$Sales Line]
SELECT	NVLINE.[Document Type], [Document No_], NVLINE.[No_], [Line No_], [Type], [Description], [Quantity], [Unit Price], [Entered User ID]
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] --INNER JOIN
--	SOHeader ON [Document No_] = SOHeader.RefSONo
WHERE	
(NVHDR.[Document Type] = 1 OR NVHDR.[Document Type] = 3 OR NVHDR.[Document Type] = 5) and 

NVLINE.Type=2 AND NVLINE.No_ = '' AND NVLINE.[Description] <> '' --AND
	--SOHeader.[MakeOrderDt] > Cast('2006-08-26 00:00:00.000' as DATETIME) AND
	--NVHDR.[ERP Upload Flag]=0


--[Porteous$Sales Line] (Adjustments & Expenses)
SELECT	NVLINE.[Document Type], [Document No_], [Line No_], NVLINE.[Type] as ExpenseInd, NVLINE.[No_] as ExpenseCd, [Description], [Quantity], [Unit Price], [Entered User ID]
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] --INNER JOIN
	--SOHeader ON [Document No_] = SOHeader.RefSONo
WHERE
(NVHDR.[Document Type] = 1 OR NVHDR.[Document Type] = 3 OR NVHDR.[Document Type] = 5) and 
	NVLINE.Type <> 2 AND ([Quantity] = 0 or [Unit Price]=0) --AND NVLINE.[Description] <> '' AND
--	SOHeader.[MakeOrderDt] > Cast('2006-08-26 00:00:00.000' as DATETIME) AND
	--NVHDR.[ERP Upload Flag]=0









SELECT	Hdr.[Status], Hdr.[Order Date], Line.[Document No_], Line.[Line No_], Line.[Type], Hdr.[Order Type], Line.[No_], Line.[Description], Line.[Quantity], Line.[Unit Cost], [Entered User ID],
	Line.[Status], Line.[Quantity] - Line.[Quantity Received] as OutstandingQty
from [Porteous$Purchase Line] Line inner join [Porteous$Purchase Header] Hdr ON	Hdr.[No_] = Line.[Document No_]
inner join OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.POHeader on Hdr.[No_]=POOrderNo collate Latin1_General_CS_AS
where --Hdr.[Status]=3 and 
--Line.[Type]=0 and Hdr.[Order Type] <> 0 and

Line.Type = 1 AND ([Quantity] = 0 or [Unit Cost] = 0)

Line.[Type]<>1 and 
Line.[No_]='' and Description<>''
Order by --Hdr.[Status]
[Description] DESC


Line.[Type]=0 and Hdr.[Order Type] <> 0 and
(Line.[Status]=0 or Line.[Quantity] - Line.[Quantity Received] > 0)
Order by --Hdr.[Status]
[Description] DESC




select * from [Porteous$Prod_ Order Line] NVLINE inner join [Porteous$Production Order] NVHDR on NVHDR.[No_]=NVLINE.[Prod_ Order No_] 
where NVLINE.[Item No_]='' and NVLINE.[Description]<>''





select * from [Porteous$Sales Line Comment Line]
where [No_]='SO2922572'
order by [Doc_ Line No_]
--left([No_],2)='SO'
--order by [Date] DESC

select * from [Porteous$Sales Line]
where [Document No_]='SO2922572'


select * from [Porteous$Sales Line Comment Line]
where [No_]='SO2783731'
order by [Doc_ Line No_]
--left([No_],2)='SO'
--order by [Date] DESC

select * from [Porteous$Sales Line]
where [Document No_]='SO2783731'



--[Porteous$Sales Line]
SELECT
	'LC' as Type,
	MaxLine.DocLineNo as CommLineNo,
--	[Line No_] as CommLineSeqNo,
	[Description] as CommText,
	SOHeader.pSOHeaderID as fSOHeaderID,
	SOHeader.EntryID as EntryID,
	SOHeader.EntryDt as EntryDate
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	SOHeader ON [Document No_] = SOHeader.RefSONo INNER JOIN
	(SELECT	RefSoNo, MAX([Line No_]) AS DocLineNo
	 FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Line] NVLINE2 INNER JOIN
		OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] NVHDR2 ON NVHDR2.[No_]=NVLINE2.[Document No_] INNER JOIN
		SOHeader ON [Document No_] = SOHeader.RefSONo
	 Group By RefSoNo) MaxLine ON SOHeader.RefSONo = MaxLine.RefSONo
WHERE	NVLINE.Type=2 AND NVLINE.No_ = '' AND NVLINE.[Description] <> '' AND
	SOHeader.[MakeOrderDt] > Cast('2006-08-26 00:00:00.000' as DATETIME) --AND
	--NVHDR.[ERP Upload Flag]=0


select * from [Porteous$Sales Line] where [Document No_]='SO1945086'


SELECT	MAX([Line No_])
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Line] NVLINE2 INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] NVHDR2 ON NVHDR2.[No_]=NVLINE2.[Document No_] INNER JOIN
	SOHeader ERPHDR ON [Document No_] = ERPHDR.RefSONo

-----------------------------------------------------------------------------------------------

--[Porteous$Sales Line] (Adjustments & Expenses)
SELECT
NVLINE.*
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Line] NVLINE INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLP;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Header] NVHDR ON NVHDR.[No_]=NVLINE.[Document No_] INNER JOIN
	SOHeader ON [Document No_] = SOHeader.RefSONo
WHERE	NVLINE.Type <> 2 AND [Quantity] = 0 AND NVLINE.[Description] <> '' AND
	SOHeader.[MakeOrderDt] > Cast('2006-08-26 00:00:00.000' as DATETIME) --AND
	--NVHDR.[ERP Upload Flag]=0


select * from [Porteous$Sales Line]
where [Document No_]='SO2619054'



-----------------------------------------------------------------------------------------------

select * from [Porteous$Transfer Line] where [Item No_]='' order by [Document No_], [Line No_]


select * from [Porteous$Purchase Line] Line inner join [Porteous$Purchase Header] Hdr on Hdr.[No_]=Line.[Document No_]
where Line.[No_]='' and [Description]<>''


select * from [Porteous$Transfer Line] where [Item No_]='' and 
(Quantity<>0 or [Qty_ to Ship]<>0 or [Qty_ to Receive]<>0 or [Quantity Shipped]<>0 or [Quantity Received]<>0)


-----------------------------------------------------------------------------------------------




select * from SOHeader


select * from SODetail