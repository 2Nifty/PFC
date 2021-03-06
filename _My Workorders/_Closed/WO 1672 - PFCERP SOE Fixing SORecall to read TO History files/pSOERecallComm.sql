IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[pSOERecallComm]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[pSOERecallComm]
go


CREATE procedure [dbo].[pSOERecallComm]
@RecID varchar(20),
@SOTable varchar(20),
@TempTable varchar(50)
as

----pSOERecallComm
----Written By: Tod Dixon
----Application: Sales Management
----Change By: Tod 02/10/10
--------Read TOHist for Invoiced Transfers


DECLARE @Query nvarchar(4000),
	@Drop nvarchar(500),
	@CommentTable varchar(50),
	@SelColumn varchar(20)


SET @Drop = 	'IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id=object_id(N''[dbo].' + quotename(@TempTable) + ''') AND OBJECTPROPERTY(id, N''IsUserTable'')=1) DROP TABLE [dbo].' + quotename(@TempTable)
EXEC sp_ExecuteSQL @Drop

--SOCommentsHist
IF (@SOTable = 'SOHist')
   BEGIN
	SET	@CommentTable = 'SOCommentsHist'
	SET	@SelColumn = 'fSOHeaderHistID'
   END

--TOCommentsHist
IF (@SOTable = 'TOHist')
   BEGIN
	SET	@CommentTable = 'TOCommentsHist'
	SET	@SelColumn = 'fTOHeaderHistID'
   END

--SOComments
IF (@SOTable = 'SO')
   BEGIN
	SET	@CommentTable = 'SOComments'
	SET	@SelColumn = 'fSOHeaderID'
   END

--SOCommentsRel
IF (@SOTable = 'SORel')
   BEGIN
	SET	@CommentTable = 'SOCommentsRel'
	SET	@SelColumn = 'fSOHeaderRelID'
   END

SET @Query = 	' SELECT Type, CommLineNo, CommLineSeqNo, CommText, DeleteDt' +
		' INTO	 ' + quotename(@TempTable) +
		' FROM	 ' + quotename(@CommentTable) + ' WITH (NOLOCK)' +
		' WHERE  ' + @SelColumn + '=@SelRecID' +
		' ORDER BY Type, CommLineNo, CommLineSeqNo'
EXEC 	sp_ExecuteSQL @Query, N'@SelRecID varchar(20)', @RecID

SET	@Query = 'SELECT * FROM ' + quotename(@TempTable)
EXEC	sp_ExecuteSQL @Query

SET	@Drop = 'IF EXISTS (SELECT * FROM dbo.sysobjects WHERE id=object_id(N''[dbo].' + quotename(@TempTable) + ''') AND OBJECTPROPERTY(id, N''IsUserTable'')=1) DROP TABLE [dbo].' + quotename(@TempTable)
EXEC	sp_ExecuteSQL @Drop

