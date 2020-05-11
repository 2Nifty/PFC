
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pSORecallExp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pSORecallExp]
GO

CREATE procedure [dbo].[pSORecallExp]
@RecID varchar(20),
@SOTable varchar(20)
as

----pSORecallExp
----Written By: Tod Dixon
----Application: Sales Management


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tSORecall]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tSORecall]

--SOExpenseHist
IF (@SOTable = 'SOHist')
   BEGIN
	SELECT	LineNumber, ExpenseCd, Amount, Cost, ExpenseInd, TaxStatus, DocumentLoc, DeleteDt, ExpenseDesc
	INTO	tSORecall
	FROM	SOExpenseHist
	WHERE	fSOHeaderHistID=@RecID
	GOTO Done
   END


--SOExpense
IF (@SOTable = 'SO')
   BEGIN
	SELECT	LineNumber, ExpenseCd, Amount, Cost, ExpenseInd, TaxStatus, DocumentLoc, DeleteDt, ExpenseDesc
	INTO	tSORecall
	FROM	SOExpense
	WHERE	fSOHeaderID=@RecID
	GOTO Done
   END


--SOExpenseRel
IF (@SOTable = 'SORel')
   BEGIN
	SELECT	LineNumber, ExpenseCd, Amount, Cost, ExpenseInd, TaxStatus, DocumentLoc, DeleteDt, ExpenseDesc
	INTO	tSORecall
	FROM	SOExpenseRel
	WHERE	fSOHeaderRelID=@RecID
	GOTO Done
   END


Done:

SELECT	*
FROM	tSORecall

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tSORecall]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tSORecall]

GO