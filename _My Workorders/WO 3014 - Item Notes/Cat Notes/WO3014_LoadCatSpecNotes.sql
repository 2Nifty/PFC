
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO3014CategorySpecNotes]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tWO3014CategorySpecNotes]
GO

CREATE TABLE [dbo].[tWO3014CategorySpecNotes] (
	[Category] [varchar] (10),
	[LineNumber] [int] NOT NULL,
	[Comment] [varchar] (4000)
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

		INSERT INTO tWO3014CategorySpecNotes (Category, LineNumber, Comment)
		VALUES (@SaveCat, @CommentCount, @NewComment)

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
go

--select * from tWO3014CategorySpecNotes
--go

--------------------------------------------------------------------------------------------------

--UPDATE Category Spec Notes - 1st pass - full category (285)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups
SET		Notes = CatNote.Note  --,ChangeID='pass1'
FROM	(SELECT	DISTINCT Category as Cat, dbo.concat_spec(Category) as Note
		 FROM	tWO3014CategorySpecNotes) CatNote
WHERE	CatNote.Cat COLLATE Latin1_General_CS_AS = Category
go

--UPDATE Category Spec Notes - 2nd pass - last digit wildcard (15)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups
SET		Notes = CatNote.Note  --,ChangeID='pass2'
FROM	(SELECT	DISTINCT Category as Cat, dbo.concat_spec(Category) as Note
		 FROM	tWO3014CategorySpecNotes
		 WHERE	RIGHT(Category,1) = '?') CatNote
WHERE	LEFT(CatNote.Cat,4) COLLATE Latin1_General_CS_AS = LEFT(Category,4) AND Notes is null
go

--UPDATE Category Spec Notes - 3rd pass - last 2 digits wildcard (84)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups
SET		Notes = CatNote.Note  --,ChangeID='pass3'
FROM	(SELECT	DISTINCT Category as Cat, dbo.concat_spec(Category) as Note
		 FROM	tWO3014CategorySpecNotes
		 WHERE	RIGHT(Category,2) = '??') CatNote
WHERE	LEFT(CatNote.Cat,3) COLLATE Latin1_General_CS_AS = LEFT(Category,3) AND Notes is null
go

--THERE ARE NO VALID ENTRIES WITH LAST 3 DIGIT WILDCARDS
--UPDATE Category Spec Notes - 4th pass - last 3 digits wildcard - THERE ARE NONE (0)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups
SET		Notes = CatNote.Note  --,ChangeID='pass4'
FROM	(SELECT	DISTINCT Category as Cat, dbo.concat_spec(Category) as Note
		 FROM	tWO3014CategorySpecNotes
		 WHERE	RIGHT(Category,3) = '???') CatNote
WHERE	LEFT(CatNote.Cat,2) COLLATE Latin1_General_CS_AS = LEFT(Category,2) AND Notes is null
go

--THERE ARE NO VALID ENTRIES WITH LAST 4 DIGIT WILDCARDS
--UPDATE Category Spec Notes - 5th pass - last 4 digits wildcard - THERE ARE NONE (0)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups
SET		Notes = CatNote.Note  --,ChangeID='pass5'
FROM	(SELECT	DISTINCT Category as Cat, dbo.concat_spec(Category) as Note
		 FROM	tWO3014CategorySpecNotes
		 WHERE	RIGHT(Category,4) = '????') CatNote
WHERE	LEFT(CatNote.Cat,1) COLLATE Latin1_General_CS_AS = LEFT(Category,1) AND Notes is null
go

--UPDATE Category Spec Notes - 6th pass - '?????' default (672)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups
SET		Notes = CatNote.Note  --,ChangeID='pass6'
FROM	(SELECT	DISTINCT Category as Cat, dbo.concat_spec(Category) as Note
		 FROM	tWO3014CategorySpecNotes
		 WHERE	RIGHT(Category,5) = '?????') CatNote
WHERE	Notes is null
go

--still NULL - should be none
--select * from OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups where Notes is null 
--go

--if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tWO3014CategorySpecNotes]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
--drop table [dbo].[tWO3014CategorySpecNotes]
--GO
