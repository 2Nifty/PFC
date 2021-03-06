
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pSOERecallExp]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pSOERecallExp]
go


CREATE procedure [dbo].[pSOERecallExp]
@RecID varchar(20),
@SOTable varchar(20),
@TempTable varchar(50)
as

----pSOERecallExp
----Written By: Tod Dixon
----Application: Sales Management
----Change By: Tod 02/10/10
--------Read TOHist for Invoiced Transfers


DECLARE @Query nvarchar(4000),
	@Drop nvarchar(500),
	@ExpenseTable varchar(50),
	@SelColumn varchar(20)


SET @Drop = 	'IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id=object_id(N''[dbo].' + quotename(@TempTable) + ''') AND OBJECTPROPERTY(id, N''IsUserTable'')=1) DROP TABLE [dbo].' + quotename(@TempTable)
EXEC sp_ExecuteSQL @Drop

--SOExpenseHist
IF (@SOTable = 'SOHist')
   BEGIN
	SET	@ExpenseTable = 'SOExpenseHist'
	SET	@SelColumn = 'fSOHeaderHistID'
   END

--TOExpenseHist
IF (@SOTable = 'TOHist')
   BEGIN
	SET	@ExpenseTable = 'TOExpenseHist'
	SET	@SelColumn = 'fTOHeaderHistID'
   END

--SOExpense
IF (@SOTable = 'SO')
   BEGIN
	SET	@ExpenseTable = 'SOExpense'
	SET	@SelColumn = 'fSOHeaderID'
   END

--SOExpenseRel
IF (@SOTable = 'SORel')
   BEGIN
	SET	@ExpenseTable = 'SOExpenseRel'
	SET	@SelColumn = 'fSOHeaderRelID'
   END

SET @Query = 	' SELECT	LineNumber, ExpenseCd, Amount, Cost, ExpenseInd, TaxStatus, DocumentLoc, DeleteDt, ExpenseDesc' +
		' INTO	 ' + quotename(@TempTable) +
		' FROM	 ' + quotename(@ExpenseTable) + ' WITH (NOLOCK)' +
		' WHERE  ' + @SelColumn + '=@SelRecID'
EXEC 	sp_ExecuteSQL @Query, N'@SelRecID varchar(20)', @RecID

SET	@Query = 'SELECT * FROM ' + quotename(@TempTable)
EXEC	sp_ExecuteSQL @Query

SET	@Drop = 'IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id=object_id(N''[dbo].' + quotename(@TempTable) + ''') AND OBJECTPROPERTY(id, N''IsUserTable'')=1) DROP TABLE [dbo].' + quotename(@TempTable)
EXEC	sp_ExecuteSQL @Drop

