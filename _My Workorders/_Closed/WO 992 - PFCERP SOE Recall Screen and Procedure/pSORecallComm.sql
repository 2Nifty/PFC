
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[pSORecallComm]') and OBJECTPROPERTY(id, N'IsProcedure') = 1)
drop procedure [dbo].[pSORecallComm]
GO

CREATE procedure [dbo].[pSORecallComm]
@RecID varchar(20),
@SOTable varchar(20)
as

----pSORecallComm
----Written By: Tod Dixon
----Application: Sales Management


if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tSORecall]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tSORecall]

--SOCommentsHist
IF (@SOTable = 'SOHist')
   BEGIN
	SELECT	Type, CommLineNo, CommLineSeqNo, CommText, DeleteDt
	INTO	tSORecall
	FROM	SOCommentsHist
	WHERE	fSOHeaderHistID=@RecID
	ORDER BY Type, CommLineNo, CommLineSeqNo
	GOTO Done
   END


--SOComments
IF (@SOTable = 'SO')
   BEGIN
	SELECT	Type, CommLineNo, CommLineSeqNo, CommText, DeleteDt
	INTO	tSORecall
	FROM	SOComments
	WHERE	fSOHeaderID=@RecID
	ORDER BY Type, CommLineNo, CommLineSeqNo
	GOTO Done
   END


--SOCommentsRel
IF (@SOTable = 'SORel')
   BEGIN
	SELECT	Type, CommLineNo, CommLineSeqNo, CommText, DeleteDt
	INTO	tSORecall
	FROM	SOCommentsRel
	WHERE	fSOHeaderRelID=@RecID
	ORDER BY Type, CommLineNo, CommLineSeqNo
	GOTO Done
   END


Done:

SELECT	*
FROM	tSORecall

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tSORecall]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tSORecall]

GO