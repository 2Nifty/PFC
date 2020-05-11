select
	SOHeaderHist.pSOHeaderHistID as fSOHeaderHistID,
	[Line No_]	as	LineNumber	,
	[No_]		as	ExpenseCd	,
	[Quantity] * [Unit Price]		as	Amount		,
	[Type]		as	ExpenseInd	,
	'N'		as	TaxStatus	,
	SOHeaderHist.InvoiceNo	as	DocumentLoc,
	SOHeaderHist.EntryID as EntryID,
	SOHeaderHist.EntryDt as EntryDt	
FROM	OpenDataSource('SQLOLEDB','Data Source=PFCSQLp;User ID=pfcnormal;Password=pfcnormal').PFCLive.dbo.[Porteous$Sales Invoice Line] INNER JOIN
	SOHeaderHist ON [Document No_] = SOHeaderHist.InvoiceNo
WHERE	((Type=1 and No_<>'3021') or (Type<>1 and Type<>2)) and
		SOHeaderHist.[ARPostDt] > Cast('2006-08-26 00:00:00.000' as DATETIME)



SELECT     SOHeaderHist.InvoiceNo, SOHeaderHist.OrderType, SOHeaderHist.ARPostDt, SODetailHist.LineNumber, SODetailHist.LineType, SODetailHist.ItemNo, 
                      SODetailHist.NetUnitPrice, SODetailHist.ListUnitPrice, SODetailHist.QtyOrdered, SODetailHist.QtyShipped, SODetailHist.UnitCost, 
                      SOExpenseHist.ExpenseCd, SOExpenseHist.Amount, SOExpenseHist.ExpenseInd
FROM         SOExpenseHist RIGHT OUTER JOIN
                      SODetailHist ON SOExpenseHist.fSOHeaderHistID = SODetailHist.fSOHeaderHistID LEFT OUTER JOIN
                      SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID
WHERE		SOHeaderHist.InvoiceNo='IP2449445'




SELECT     SODetailHist.fSOHeaderHistID, SOExpenseHist.DocumentLoc, SODetailHist.LineNumber AS [LineNo], 
                      SOExpenseHist.LineNumber AS [Expense LineNo], SODetailHist.LineType, SOExpenseHist.ExpenseInd, SODetailHist.ItemNo, 
                      SOExpenseHist.ExpenseCd
FROM         SODetailHist INNER JOIN
                      SOExpenseHist ON SODetailHist.fSOHeaderHistID = SOExpenseHist.fSOHeaderHistID
WHERE     (SOExpenseHist.DocumentLoc = 'IP2449445')




SELECT     SODetailHist.fSOHeaderHistID, SOExpenseHist.DocumentLoc, SODetailHist.LineNumber AS [LineNo], 
                      SOExpenseHist.LineNumber AS [Expense LineNo], SODetailHist.LineType, SOExpenseHist.ExpenseInd, SODetailHist.ItemNo, 
                      SOExpenseHist.ExpenseCd
FROM         SODetailHist, SOExpenseHist
WHERE     (SOExpenseHist.DocumentLoc = 'IP2449445') and SODetailHist.fSOHeaderHistID = SOExpenseHist.fSOHeaderHistID







SELECT     *
FROM         SOExpenseHist
order by fSOHeaderHistID
WHERE     (SOExpenseHist.DocumentLoc >= 'IP2449440') AND (SOExpenseHist.DocumentLoc <= 'IP2449450')


SELECT     *
FROM         SOHeaderHist INNER JOIN
                      SOExpenseHist ON SOHeaderHist.pSOHeaderHistID = SOExpenseHist.fSOHeaderHistID
WHERE     (SOExpenseHist.DocumentLoc = 'IP2449445')


--Invoice Headers & Lines
SELECT     SOHeaderHist.InvoiceNo, SODetailHist.LineNumber, SODetailHist.ItemNo
FROM         SODetailHist INNER JOIN
                      SOHeaderHist ON SODetailHist.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID
WHERE     (SOHeaderHist.InvoiceNo >= 'IP2449440') AND (SOHeaderHist.InvoiceNo <= 'IP2449450')
Order By InvoiceNo






SELECT	fSOHeaderHistID, SUM(Amount) as ExtExpense
	 FROM	SOExpenseHist
	 Group By fSOHeaderHistID




--UPDATE THE HEADER RECORDS
UPDATE	SOHeaderHist
SET	NonTaxExpAmt = ExtExpense
FROM	(SELECT	fSOHeaderHistID, SUM(Amount) as ExtExpense
	 FROM	SOExpenseHist
	 Group By fSOHeaderHistID) ExtExp 
WHERE	ExtExp.fSOHeaderHistID = SOHeaderHist.pSOHeaderHistID




Order By fSOHeaderHistID
20237104