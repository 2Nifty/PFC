
exec pSORecallOrd 'IP2479093', 'I'
exec pSORecallExp '832412', 'SOHist'
exec pSORecallComm '832412'


	SELECT	*
	FROM	SOExpenseHist
	WHERE	fSOHeaderHistID=832412



SELECT    DISTINCT 'SOHeaderHist' AS HeaderTbl, SOHeaderHist.pSOHeaderHistID
FROM         SOHeaderHist
WHERE InvoiceNo='IP2479093'
--'IP2433936'



DECLARE @HeaderTbl varchar(50),
	@HeaderID int

SET @HeaderTbl=('SOHeaderHist')
SET @HeaderID=(832412)


IF (@HeaderTbl='SOHeaderHist')
   BEGIN
	SELECT    SODetailHist.fSOHeaderHistID, *
	FROM         SOHeaderHist inner JOIN
	                      SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID 
	WHERE pSOHeaderHistID=@HeaderID
   END




SELECT    SODetailHist.fSOHeaderHistID, *
FROM         SOHeaderHist inner JOIN
                      SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID 
WHERE InvoiceNo='IP2479093'
--'IP2433936'

IF @@RowCount = 0
   BEGIN
      print 'No Data'
   END
ELSE
   BEGIN
      print 'Data Found'
   END


Select * FROM SOExpenseHist
WHERE fSOHeaderHistID='832412'

Select * FROM SOComments
WHERE fSOHeaderID='832412'




SELECT    SOExpenseHist.fSOHeaderHistID, *
FROM         SOHeaderHist inner JOIN
                     SOExpenseHist ON SOHeaderHist.pSOHeaderHistID = SOExpenseHist.fSOHeaderHistID 
WHERE InvoiceNo='IP2479093'




SELECT     ItemNo, SODetailHist.LineNumber, SOExpenseHist.LineNumber, ExpenseCd, CommText, *
FROM         SOHeaderHist left outer JOIN
                      SODetailHist ON SOHeaderHist.pSOHeaderHistID = SODetailHist.fSOHeaderHistID full outer Join 
                      SOExpenseHist ON SOHeaderHist.pSOHeaderHistID = SOExpenseHist.fSOHeaderHistID full outer join 
                      SOComments ON SOHeaderHist.pSOHeaderHistID = SOComments.fSOHeaderID
WHERE InvoiceNo='IP2479093'
--'IP2433936'





select * from SOExpenseHist
where DocumentLoc='IP2479093'
--'IP2433936'





