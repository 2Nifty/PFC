
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pSOERecallComm]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pSOERecallComm]
GO


CREATE procedure [dbo].[pSOERecallComm]
@RecID varchar(20),
@SOTable varchar(20),
@TempTable varchar(50)
as

----pSOERecallComm
----Written By: Tod Dixon
----Application: Sales Management


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

GO