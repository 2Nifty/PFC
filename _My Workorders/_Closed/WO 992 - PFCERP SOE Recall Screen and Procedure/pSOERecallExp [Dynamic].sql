
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pSOERecallExp]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pSOERecallExp]
GO


CREATE procedure [dbo].[pSOERecallExp]
@RecID varchar(20),
@SOTable varchar(20),
@TempTable varchar(50)
as

----pSOERecallExp
----Written By: Tod Dixon
----Application: Sales Management


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

GO