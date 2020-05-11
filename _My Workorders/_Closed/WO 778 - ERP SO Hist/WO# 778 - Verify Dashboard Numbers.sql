

Declare	@LastDate DATETIME
SET @LastDate='2008-Jul-08'
--select CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))

select	* from OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.DashBoardInvoiceLineTemp DashBoard
where	NOT EXISTS (SELECT * FROM SODetailHist INNER JOIN
                                SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID
		  where DashBoard.[Document No_]=SOHeaderHist.InvoiceNo COLLATE SQL_Latin1_General_CP1_CI_AS)
AND	[Posting Date] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))



Declare	@LastDate DATETIME
SET @LastDate='2008-Jul-08'
--select CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))


select count(*) from OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.DashBoardInvoiceLineTemp where [Posting Date] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))
select count(*) from OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.DashBoardCreditLineTemp where [Posting Date] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))
SELECT COUNT(*) FROM SODetailHist INNER JOIN
                                SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID
where [ARPostDt] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))



-------------------------------------------------------------------------------------------------

Declare	@LastDate DATETIME
SET @LastDate='2008-Jul-07'
--select CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))



SELECT    HEADER.No_ as Document,
--	LINE.[Line No_], LINE.Quantity, LINE.[Unit Price]
SUM(LINE.Quantity * LINE.[Unit Price]) AS ExtPrice
--into tCheckInvoiceValueNV
--FROM         OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Line] LINE INNER JOIN
--OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Header] HEADER ON LINE.[Document No_] = HEADER.No_
FROM         [Porteous$Sales Cr_Memo Line] LINE INNER JOIN
		[Porteous$Sales Cr_Memo Header] HEADER ON LINE.[Document No_] = HEADER.No_
where HEADER.[Posting Date] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))
group by HEADER.No_
--order by HEADER.No_


--select count(*)
--from tCheckInvoiceValueDashBoard


Declare	@LastDate DATETIME
SET @LastDate='2008-Jul-07'
--select CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))

SELECT     HEADER.No_ as Document,
--LINE.[Line No_], LINE.Quantity, LINE.[Unit Price]
SUM(LINE.Quantity * LINE.[Unit Price]) AS ExtPrice
--into tCheckInvoiceValueDashBoard
FROM         DashBoardCreditLineTemp LINE INNER JOIN
                      DashBoardCreditHeaderTemp HEADER ON LINE.[Document No_] = HEADER.No_
where HEADER.[Posting Date] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))
group by HEADER.No_



Declare	@LastDate DATETIME
SET @LastDate='2008-Jul-07'
--select CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))



SELECT	HEADER.InvoiceNo AS Document,
--DETAIL.LineNumber, DETAIL.QtyOrdered, DETAIL.ListUnitPrice
SUM(DETAIL.QtyOrdered * DETAIL.ListUnitPrice) AS ExtPrice
--into tCheckInvoiceValueERP
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SODetailHist DETAIL INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SOHeaderHist HEADER ON DETAIL.fSOHeaderHistID = HEADER.pSOHeaderHistID
WHERE	LEFT(InvoiceNo,3)='SCR' and 
HEADER.[ARPostDt] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))
group by HEADER.InvoiceNo

--------------------------------------------------------------------------------------------------

                      


Declare	@LastDate DATETIME
SET @LastDate='2008-Jul-07'
--select CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))



SELECT    HEADER.No_ as Invoice, LINE.[Line No_], LINE.Quantity, LINE.[Unit Price]
--SUM([Porteous$Sales Invoice Line].Quantity * [Porteous$Sales Invoice Line].[Unit Price]) AS ExtPrice
into tCheckCreditValueNV
FROM         OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Cr_Memo Line] LINE INNER JOIN
OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Cr_Memo Header] HEADER ON LINE.[Document No_] = HEADER.No_

where HEADER.[Posting Date] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))



--select count(*)
--from tCheckInvoiceValueDashBoard



SELECT     DashBoardCreditHeaderTemp.No_ as Invoice, DashBoardCreditLineTemp.[Line No_], DashBoardCreditLineTemp.Quantity, DashBoardCreditLineTemp.[Unit Price]
--SUM(DashBoardCreditLineTemp.Quantity * DashBoardCreditLineTemp.[Unit Price]) AS ExtPrice
into tCheckCreditValueDashBoard
FROM         DashBoardCreditLineTemp INNER JOIN
                      DashBoardCreditHeaderTemp ON DashBoardCreditLineTemp.[Document No_] = DashBoardCreditHeaderTemp.No_

where DashBoardCreditHeaderTemp.[Posting Date] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))
--group by DashBoardCreditHeaderTemp.No_



SELECT	HEADER.InvoiceNo AS Invoice, DETAIL.LineNumber, DETAIL.QtyOrdered, DETAIL.ListUnitPrice
--SUM(DETAIL.QtyOrdered * DETAIL.ListUnitPrice) AS ExtPrice
into tCheckCreditValueERP
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SODetailHist DETAIL INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SOHeaderHist HEADER ON DETAIL.fSOHeaderHistID = HEADER.pSOHeaderHistID
WHERE	LEFT(InvoiceNo,3)='SCR' and 
HEADER.[ARPostDt] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))
--group by HEADER.InvoiceNo



----------------------------------------------------------------------------------------------------------------------




select * from tCheckCreditValueERP
where NOT EXISTS (SELECT * FROM tCheckCreditValueDashBoard where tCheckCreditValueERP.Invoice=tCheckCreditValueDashBoard.Invoice)


select * from tCheckCreditValueNV
where NOT EXISTS (SELECT * FROM tCheckCreditValueERP where tCheckCreditValueERP.Invoice=tCheckCreditValueNV.Invoice)




SELECT     tCheckInvoiceValueDashBoard.Invoice, tCheckInvoiceValueDashBoard.[Line No_], 
                tCheckInvoiceValueDashBoard.[Unit Price] AS [DashBoard Unit Price],
		tCheckInvoiceValueERP.ListUnitPrice AS [ERP Unit Price]
FROM         tCheckInvoiceValueDashBoard INNER JOIN
                      tCheckInvoiceValueERP ON tCheckInvoiceValueDashBoard.Invoice = tCheckInvoiceValueERP.Invoice AND 
                      tCheckInvoiceValueDashBoard.[Line No_] = tCheckInvoiceValueERP.LineNumber
WHERE     (tCheckInvoiceValueDashBoard.Quantity <> tCheckInvoiceValueERP.QtyOrdered) OR
                      (tCheckInvoiceValueDashBoard.[Unit Price] <> tCheckInvoiceValueERP.ListUnitPrice)






SELECT     tCheckInvoiceValueNV.Invoice, tCheckInvoiceValueNV.[Line No_], 
                tCheckInvoiceValueNV.[Unit Price] AS [DashBoard Unit Price],
		tCheckInvoiceValueERP.ListUnitPrice AS [ERP Unit Price]
FROM         tCheckInvoiceValueNV INNER JOIN
                      tCheckInvoiceValueERP ON tCheckInvoiceValueNV.Invoice = tCheckInvoiceValueERP.Invoice AND 
                      tCheckInvoiceValueNV.[Line No_] = tCheckInvoiceValueERP.LineNumber
WHERE     (tCheckInvoiceValueNV.Quantity <> tCheckInvoiceValueERP.QtyOrdered) OR
                      (tCheckInvoiceValueNV.[Unit Price] <> tCheckInvoiceValueERP.ListUnitPrice)









SELECT     tCheckCreditValueDashBoard.Invoice, tCheckCreditValueDashBoard.[Line No_], 
tCheckCreditValueDashBoard.Quantity AS [DashBoard Qty],
                tCheckCreditValueDashBoard.[Unit Price] AS [DashBoard Unit Price],
tCheckCreditValueERP.QtyOrdered AS [ERP Qty],
		tCheckCreditValueERP.ListUnitPrice AS [ERP Unit Price]
FROM         tCheckCreditValueDashBoard INNER JOIN
                      tCheckCreditValueERP ON tCheckCreditValueDashBoard.Invoice = tCheckCreditValueERP.Invoice AND 
                      tCheckCreditValueDashBoard.[Line No_] = tCheckCreditValueERP.LineNumber
WHERE     (tCheckCreditValueDashBoard.Quantity <> tCheckCreditValueERP.QtyOrdered) OR
                      (tCheckCreditValueDashBoard.[Unit Price] <> tCheckCreditValueERP.ListUnitPrice)






SELECT     tCheckCreditValueNV.Invoice, tCheckCreditValueNV.[Line No_], 
                tCheckCreditValueNV.[Unit Price] AS [NV Unit Price],
		tCheckCreditValueERP.ListUnitPrice AS [ERP Unit Price]
FROM         tCheckCreditValueNV INNER JOIN
                      tCheckCreditValueERP ON tCheckCreditValueNV.Invoice = tCheckCreditValueERP.Invoice AND 
                      tCheckCreditValueNV.[Line No_] = tCheckCreditValueERP.LineNumber
WHERE     (tCheckCreditValueNV.Quantity <> tCheckCreditValueERP.QtyOrdered) OR
                      (tCheckCreditValueNV.[Unit Price] <> tCheckCreditValueERP.ListUnitPrice)






----------------------------------------------------------------------------------------------------------------------------

Declare	@LastDate DATETIME
SET @LastDate='2008-Jul-02'
--select CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))

SELECT     DashBoardInvoiceHeaderTemp.No_ as Invoice, DashBoardInvoiceLineTemp.[Line No_], DashBoardInvoiceLineTemp.Quantity, DashBoardInvoiceLineTemp.[Unit Price]
--SUM(DashBoardInvoiceLineTemp.Quantity * DashBoardInvoiceLineTemp.[Unit Price]) AS ExtPrice
into tCheckInvoiceValueDashBoard
FROM         DashBoardInvoiceLineTemp INNER JOIN
                      DashBoardInvoiceHeaderTemp ON DashBoardInvoiceLineTemp.[Document No_] = DashBoardInvoiceHeaderTemp.No_

where DashBoardInvoiceHeaderTemp.[Posting Date] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))
--group by DashBoardInvoiceHeaderTemp.No_



SELECT	HEADER.InvoiceNo AS Invoice, DETAIL.LineNumber, DETAIL.QtyOrdered, DETAIL.ListUnitPrice
--SUM(DETAIL.QtyOrdered * DETAIL.ListUnitPrice) AS ExtPrice
into tCheckInvoiceValueERP
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SODetailHist DETAIL INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SOHeaderHist HEADER ON DETAIL.fSOHeaderHistID = HEADER.pSOHeaderHistID
WHERE	LEFT(InvoiceNo,3)<>'SCR' and 
HEADER.[ARPostDt] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))
--group by HEADER.InvoiceNo



select * from tCheckInvoiceValueERP
where NOT EXISTS (SELECT * FROM tCheckInvoiceValueDashBoard where tCheckInvoiceValueERP.Invoice=tCheckInvoiceValueDashBoard.Invoice)





SELECT     tCheckInvoiceValueDashBoard.Invoice, tCheckInvoiceValueDashBoard.[Line No_], 
                tCheckInvoiceValueDashBoard.[Unit Price] AS [DashBoard Unit Price],
		tCheckInvoiceValueERP.ListUnitPrice AS [ERP Unit Price]
FROM         tCheckInvoiceValueDashBoard INNER JOIN
                      tCheckInvoiceValueERP ON tCheckInvoiceValueDashBoard.Invoice = tCheckInvoiceValueERP.Invoice AND 
                      tCheckInvoiceValueDashBoard.[Line No_] = tCheckInvoiceValueERP.LineNumber
WHERE     (tCheckInvoiceValueDashBoard.Quantity <> tCheckInvoiceValueERP.QtyOrdered) OR
                      (tCheckInvoiceValueDashBoard.[Unit Price] <> tCheckInvoiceValueERP.ListUnitPrice)
                      
                      
                      
                      
                      
                      
                      
--Empty Credit headers
SELECT     DashBoardCreditHeaderTemp.No_ AS Document, DashBoardCreditLineTemp.[Line No_], DashBoardCreditLineTemp.No_ AS Item, 
                      DashBoardCreditLineTemp.[Unit Price], DashBoardCreditLineTemp.Quantity
FROM         DashBoardCreditHeaderTemp INNER JOIN
                      DashBoardCreditLineTemp ON DashBoardCreditHeaderTemp.No_ = DashBoardCreditLineTemp.[Document No_]
WHERE     (DashBoardCreditHeaderTemp.No_ = 'SCR165210') OR
                      (DashBoardCreditHeaderTemp.No_ = 'SCR165249') OR
                      (DashBoardCreditHeaderTemp.No_ = 'SCR165213') OR
                      (DashBoardCreditHeaderTemp.No_ = 'SCR165248') OR
                      (DashBoardCreditHeaderTemp.No_ = 'SCR165231') OR
                      (DashBoardCreditHeaderTemp.No_ = 'SCR165230') OR
                      (DashBoardCreditHeaderTemp.No_ = 'SCR165247') OR
                      (DashBoardCreditHeaderTemp.No_ = 'SCR165211')
ORDER BY DashBoardCreditHeaderTemp.No_, DashBoardCreditLineTemp.[Line No_]




                      
SELECT     DashBoardInvoiceHeaderTemp.No_ AS Document, DashBoardInvoiceLineTemp.[Line No_], DashBoardInvoiceLineTemp.No_ AS Item, 
                      DashBoardInvoiceLineTemp.[Unit Price], DashBoardInvoiceLineTemp.Quantity
FROM         DashBoardInvoiceHeaderTemp INNER JOIN
                      DashBoardInvoiceLineTemp ON DashBoardInvoiceHeaderTemp.No_ = DashBoardInvoiceLineTemp.[Document No_]
WHERE     (DashBoardInvoiceHeaderTemp.No_ = 'IP2440437') OR
                      (DashBoardInvoiceHeaderTemp.No_ = 'IP2440436') OR
                      (DashBoardInvoiceHeaderTemp.No_ = 'IP2440443')
ORDER BY DashBoardInvoiceHeaderTemp.No_, DashBoardInvoiceLineTemp.[Line No_]


























SELECT     [Porteous$Sales Invoice Header].No_ as Invoice, [Porteous$Sales Invoice Line].[Line No_], [Porteous$Sales Invoice Line].Quantity, [Porteous$Sales Invoice Line].[Unit Price]
--SUM([Porteous$Sales Invoice Line].Quantity * [Porteous$Sales Invoice Line].[Unit Price]) AS ExtPrice
into tCheckInvoiceValueNV
FROM         OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Line] LINE INNER JOIN
OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Header] HEADER ON LINE.[Document No_] = HEADER.No_

where HEADER.[Posting Date] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))
--group by [Porteous$Sales Invoice Header].No_


OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SODetailHist





SELECT     tCheckInvoiceValueNV.Invoice, tCheckInvoiceValueNV.[Line No_], 
                tCheckInvoiceValueNV.[Unit Price] AS [DashBoard Unit Price],
		tCheckInvoiceValueERP.ListUnitPrice AS [ERP Unit Price]
FROM         tCheckInvoiceValueNV INNER JOIN
                      tCheckInvoiceValueERP ON tCheckInvoiceValueNV.Invoice = tCheckInvoiceValueERP.Invoice AND 
                      tCheckInvoiceValueNV.[Line No_] = tCheckInvoiceValueERP.LineNumber
WHERE     (tCheckInvoiceValueNV.Quantity <> tCheckInvoiceValueERP.QtyOrdered) OR
                      (tCheckInvoiceValueNV.[Unit Price] <> tCheckInvoiceValueERP.ListUnitPrice)
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      
                      


Declare	@LastDate DATETIME
SET @LastDate='2008-Jul-07'
--select CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))



SELECT    HEADER.No_ as Invoice, LINE.[Line No_], LINE.Quantity, LINE.[Unit Price]
--SUM([Porteous$Sales Invoice Line].Quantity * [Porteous$Sales Invoice Line].[Unit Price]) AS ExtPrice
into tCheckCreditValueNV
FROM         OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Cr_Memo Line] LINE INNER JOIN
OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Cr_Memo Header] HEADER ON LINE.[Document No_] = HEADER.No_

where HEADER.[Posting Date] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))



--select count(*)
--from tCheckInvoiceValueDashBoard



SELECT     DashBoardCreditHeaderTemp.No_ as Invoice, DashBoardCreditLineTemp.[Line No_], DashBoardCreditLineTemp.Quantity, DashBoardCreditLineTemp.[Unit Price]
--SUM(DashBoardCreditLineTemp.Quantity * DashBoardCreditLineTemp.[Unit Price]) AS ExtPrice
into tCheckCreditValueDashBoard
FROM         DashBoardCreditLineTemp INNER JOIN
                      DashBoardCreditHeaderTemp ON DashBoardCreditLineTemp.[Document No_] = DashBoardCreditHeaderTemp.No_

where DashBoardCreditHeaderTemp.[Posting Date] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))
--group by DashBoardCreditHeaderTemp.No_



SELECT	HEADER.InvoiceNo AS Invoice, DETAIL.LineNumber, DETAIL.QtyOrdered, DETAIL.ListUnitPrice
--SUM(DETAIL.QtyOrdered * DETAIL.ListUnitPrice) AS ExtPrice
into tCheckCreditValueERP
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SODetailHist DETAIL INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCSQLT;User ID=pfcnormal;Password=pfcnormal').PFCReports.dbo.SOHeaderHist HEADER ON DETAIL.fSOHeaderHistID = HEADER.pSOHeaderHistID
WHERE	LEFT(InvoiceNo,3)='SCR' and 
HEADER.[ARPostDt] = CAST(DATEPART(yyyy,@LastDate) as varchar(4)) + '-' + CAST(DATEPART(mm,@LastDate) as VARCHAR(2)) + '-' + CAST(DATEPART(dd,@LastDate) AS varchar(2))
--group by HEADER.InvoiceNo
















SELECT     tCheckCreditValueDashBoard.Invoice, tCheckCreditValueDashBoard.[Line No_], 
                tCheckCreditValueDashBoard.[Unit Price] AS [DashBoard Unit Price],
		tCheckCreditValueERP.ListUnitPrice AS [ERP Unit Price]
FROM         tCheckCreditValueDashBoard INNER JOIN
                      tCheckCreditValueERP ON tCheckCreditValueDashBoard.Invoice = tCheckCreditValueERP.Invoice AND 
                      tCheckCreditValueDashBoard.[Line No_] = tCheckCreditValueERP.LineNumber
WHERE     (tCheckCreditValueDashBoard.Quantity <> tCheckCreditValueERP.QtyOrdered) OR
                      (tCheckCreditValueDashBoard.[Unit Price] <> tCheckCreditValueERP.ListUnitPrice)






SELECT     tCheckCreditValueNV.Invoice, tCheckCreditValueNV.[Line No_], 
                tCheckCreditValueNV.[Unit Price] AS [DashBoard Unit Price],
		tCheckCreditValueERP.ListUnitPrice AS [ERP Unit Price]
FROM         tCheckCreditValueNV INNER JOIN
                      tCheckCreditValueERP ON tCheckCreditValueNV.Invoice = tCheckCreditValueERP.Invoice AND 
                      tCheckCreditValueNV.[Line No_] = tCheckCreditValueERP.LineNumber
WHERE     (tCheckCreditValueNV.Quantity <> tCheckCreditValueERP.QtyOrdered) OR
                      (tCheckCreditValueNV.[Unit Price] <> tCheckCreditValueERP.ListUnitPrice)