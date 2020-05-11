

--select * from [tWO3014CategorySpecNotes] where Category='01601'



if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO3014CategorySpecNotes]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO3014CategorySpecNotes]
GO

CREATE TABLE [dbo].[tWO3014CategorySpecNotes] (
	[Category] [varchar] (10),
	[LineNumber] [int] NOT NULL,
	[Comment] [varchar] (4000),

SaveCat varchar(10),
OGLineNo INT NOT NULL,
LineCount INT NOT NULL

)
GO


DECLARE	@SpecKey VARCHAR(10),
	@Category VARCHAR(5),
	@LineNumber INT,
	@Comment VARCHAR(50),
	@LineCount INT,
	@SaveCat VARCHAR(5),
	@CommentCount INT,
	@NewComment VARCHAR(4000)

SET	@LineCount = 999
SET	@CommentCount = 999
SET	@SaveCat = 'FIRST'
SET	@NewComment = ''

DECLARE	CatCursor CURSOR FOR
SELECT	[No_] as SpecKey, RIGHT([No_],LEN([No_])-4) as Category, [Line No_] as LineNumber, Comment
FROM	[Porteous$Standard Text Line Comment] (Nolock)
WHERE	left([No_],4) = 'SPEC'
ORDER BY RIGHT([No_], LEN([No_])-4  ), [Line No_]

OPEN CatCursor

FETCH NEXT FROM CatCursor
INTO @SpecKey, @Category, @LineNumber, @Comment

WHILE @@FETCH_STATUS = 0
   BEGIN
	IF (@SaveCat = 'FIRST') SET @SaveCat = @Category
	IF (@LineCount = 999) SET @LineCount = 1
	IF (@CommentCount = 999) SET @CommentCount = 1
	IF (@LineCount > 3 or @SaveCat <> @Category)
	   BEGIN

		IF (@SaveCat = @Category) SET @NewComment = @NewComment + '|'

--		INSERT INTO tWO3014CategorySpecNotes (Category, LineNumber, Comment)
--		VALUES (@Category, @CommentCount, @NewComment)

		INSERT INTO tWO3014CategorySpecNotes (Category, LineNumber, Comment, SaveCat, OGLineNo, LineCount)
		VALUES (@SaveCat, @CommentCount, @NewComment, @SaveCat, @LineNumber, @LineCount)

		IF (@SaveCat <> @Category)
		   BEGIN
			SET @SaveCat = @Category
			SET @CommentCount = 0
		   END
		SET @LineCount = 1
		SET @CommentCount = @CommentCount + 1

		SET @NewComment = ''
	   END
	SET @NewComment = @NewComment + @Comment
	SET @LineCount = @LineCount + 1

	FETCH NEXT FROM CatCursor
	INTO @SpecKey, @Category, @LineNumber, @Comment
   END
 
CLOSE CatCursor
DEALLOCATE CatCursor

select * from tWO3014CategorySpecNotes

--------------------------------------------------------------------------------------------------

--select Category as Cat,  from tWO3014CategorySpecNotes
select * from [Porteous$Standard Text Line Comment] where [No_]='SPEC00022'
select * from tWO3014CategorySpecNotes where Category='00022'
select * from OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups where ChangeID='pass1' and Category = '00022'


--UPDATE Category Spec Notes - 1st pass - full category (285)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups
SET	Notes = CatNote.Note
	,ChangeID='pass1'
FROM	(
--SELECT	DISTINCT [No_] as SpecKey, RIGHT([No_],LEN([No_])-4) as Cat,
--		dbo.concat_spec(RIGHT([No_],LEN([No_])-4)) as Note
--	 FROM	[Porteous$Standard Text Line Comment] NV
--	 WHERE	left([No_],4) = 'SPEC'

SELECT	DISTINCT Category as Cat, dbo.concat_spec(Category) as Note
FROM	tWO3014CategorySpecNotes

) CatNote
WHERE	CatNote.Cat COLLATE Latin1_General_CS_AS = Category


--UPDATE Category Spec Notes - 2nd pass - last digit wildcard (15)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups
SET	Notes = CatNote.Note
	--,ChangeID='pass2'
FROM	(
--SELECT	DISTINCT [No_] as SpecKey, RIGHT([No_],LEN([No_])-4) as Cat,
--		dbo.concat_spec(RIGHT([No_],LEN([No_])-4)) as Note
--	 FROM	[Porteous$Standard Text Line Comment] NV
--	 WHERE	LEFT([No_],4) = 'SPEC' and RIGHT([No_],1) = '?'

SELECT	DISTINCT Category as Cat, dbo.concat_spec(Category) as Note
FROM	tWO3014CategorySpecNotes
WHERE	RIGHT(Category,1) = '?'


) CatNote
WHERE	LEFT(CatNote.Cat,4) COLLATE Latin1_General_CS_AS = LEFT(Category,4) AND Notes is null


--UPDATE Category Spec Notes - 3rd pass - last 2 digits wildcard (84)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups
SET	Notes = CatNote.Note
	--,ChangeID='pass3'
FROM	(
--SELECT	DISTINCT [No_] as SpecKey, RIGHT([No_],LEN([No_])-4) as Cat,
--		dbo.concat_spec(RIGHT([No_],LEN([No_])-4)) as Note
--	 FROM	[Porteous$Standard Text Line Comment] NV
--	 WHERE	LEFT([No_],4) = 'SPEC' and RIGHT([No_],2) = '??'

SELECT	DISTINCT Category as Cat, dbo.concat_spec(Category) as Note
FROM	tWO3014CategorySpecNotes
WHERE	RIGHT(Category,2) = '??'

) CatNote
WHERE	LEFT(CatNote.Cat,3) COLLATE Latin1_General_CS_AS = LEFT(Category,3) AND Notes is null


--672 still NULL
select * from OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups where Notes is null 


--THERE ARE NO VALID ENTRIES WITH LAST 3 DIGIT WILDCARDS - NO MORE PASSES NEEDED
--UPDATE Category Spec Notes - 4th pass - last 3 digits wildcard - THERE ARE NONE
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups
SET	Notes = CatNote.Note
	--,ChangeID='pass4'
FROM	(
--SELECT	DISTINCT [No_] as SpecKey, RIGHT([No_],LEN([No_])-4) as Cat,
--		dbo.concat_spec(RIGHT([No_],LEN([No_])-4)) as Note
--	 FROM	[Porteous$Standard Text Line Comment] NV
--	 WHERE	LEFT([No_],4) = 'SPEC' and RIGHT([No_],3) = '???'

SELECT	DISTINCT Category as Cat, dbo.concat_spec(Category) as Note
FROM	tWO3014CategorySpecNotes
WHERE	RIGHT(Category,3) = '???'

) CatNote
WHERE	LEFT(CatNote.Cat,3) COLLATE Latin1_General_CS_AS = LEFT(Category,3) AND Notes is null






select *  FROM	[Porteous$Standard Text Line Comment]



select Notes, * from OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups

exec sp_columns CategoryBuyGroups


