

--wildcards
select distinct No_, charindex('?',No_) from [Porteous$Standard Text Line Comment]
where charindex('?',No_) > 0


--EnterpriseSQL.PFCLive
--all comment records (2971)
select	[No_] as SpecKey, RIGHT([No_],LEN([No_])-4) as Category, [Line No_] as LineNumber, Comment
From	[Porteous$Standard Text Line Comment] (Nolock)
where	left([No_],4) = 'SPEC'
ORDER BY RIGHT([No_], LEN([No_])-4  ), [Line No_]



--EnterpriseSQL.PFCLive
--concatenate all comments by category code (324)
select	DISTINCT [No_] as SpecKey, RIGHT([No_],LEN([No_])-4) as Category,
	--[Line No_] as LineNumber,
	dbo.concat_spec(RIGHT([No_],LEN([No_])-4)) as Notes
From	[Porteous$Standard Text Line Comment]
where	left([No_],4) = 'SPEC'



--EnterpriseSQL.PFCLive
--find long comments (64)
select * from
(select	[No_] as SpecKey, RIGHT([No_],LEN([No_])-4) as Category, SUM(LEN(Comment)) + (Count(Comment)) as TotComLen
From	[Porteous$Standard Text Line Comment]
where	left([No_],4) = 'SPEC'
group by [No_], RIGHT([No_], LEN([No_])-4  )) tmp
where TotComLen > 512
order by TotComLen



--ORDER BY RIGHT([No_], LEN([No_])-4  ), [Line No_]





--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

select Notes, * from OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups


--UPDATE Category Spec Notes - 1st pass - full category (285)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups
SET	Notes = CatNote.Note
	--,ChangeID='pass1'
FROM	(SELECT	DISTINCT [No_] as SpecKey, RIGHT([No_],LEN([No_])-4) as Cat,
		dbo.concat_spec(RIGHT([No_],LEN([No_])-4)) as Note
	 FROM	[Porteous$Standard Text Line Comment] NV
	 WHERE	left([No_],4) = 'SPEC') CatNote
WHERE	CatNote.Cat COLLATE Latin1_General_CS_AS = Category


--UPDATE Category Spec Notes - 2nd pass - last digit wildcard (15)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups
SET	Notes = CatNote.Note
	--,ChangeID='pass2'
FROM	(SELECT	DISTINCT [No_] as SpecKey, RIGHT([No_],LEN([No_])-4) as Cat,
		dbo.concat_spec(RIGHT([No_],LEN([No_])-4)) as Note
	 FROM	[Porteous$Standard Text Line Comment] NV
	 WHERE	LEFT([No_],4) = 'SPEC' and RIGHT([No_],1) = '?') CatNote
WHERE	LEFT(CatNote.Cat,4) COLLATE Latin1_General_CS_AS = LEFT(Category,4) AND Notes is null


--UPDATE Category Spec Notes - 3rd pass - last 2 digits wildcard (84)
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups
SET	Notes = CatNote.Note
	--,ChangeID='pass3'
FROM	(SELECT	DISTINCT [No_] as SpecKey, RIGHT([No_],LEN([No_])-4) as Cat,
		dbo.concat_spec(RIGHT([No_],LEN([No_])-4)) as Note
	 FROM	[Porteous$Standard Text Line Comment] NV
	 WHERE	LEFT([No_],4) = 'SPEC' and RIGHT([No_],2) = '??') CatNote
WHERE	LEFT(CatNote.Cat,3) COLLATE Latin1_General_CS_AS = LEFT(Category,3) AND Notes is null


--672 still NULL
select * from OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups where Notes is null 


--THERE ARE NO VALID ENTRIES WITH LAST 3 DIGIT WILDCARDS - NO MORE PASSES NEEDED
--UPDATE Category Spec Notes - 4th pass - last 3 digits wildcard - THERE ARE NONE
UPDATE	OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups
SET	Notes = CatNote.Note
	--,ChangeID='pass4'
FROM	(SELECT	DISTINCT [No_] as SpecKey, RIGHT([No_],LEN([No_])-4) as Cat,
		dbo.concat_spec(RIGHT([No_],LEN([No_])-4)) as Note
	 FROM	[Porteous$Standard Text Line Comment] NV
	 WHERE	LEFT([No_],4) = 'SPEC' and RIGHT([No_],3) = '???') CatNote
WHERE	LEFT(CatNote.Cat,3) COLLATE Latin1_General_CS_AS = LEFT(Category,3) AND Notes is null






select Notes, * from OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups
where ChangeID='pass3' 
where Notes is null and left(Category,3) in ('004','005','005','006','014','064','065')




select Notes, * from OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups

select Notes, * from OpenDataSource('SQLOLEDB','Data Source=PFCDEVDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.CategoryBuyGroups where Notes is null





SELECT	DISTINCT [No_] as SpecKey, RIGHT([No_],LEN([No_])-4) as Cat, RIGHT([No_],1) as LastDig,
		dbo.concat_spec(RIGHT([No_],LEN([No_])-4)) as Notes
	 FROM	[Porteous$Standard Text Line Comment] NV
	 WHERE	left([No_],4) = 'SPEC' and RIGHT([No_],1) = '?'


-----------------------------------------------------------------------------------------------


SELECT	*
FROM	([No_] as No, SUM(LEN(Comment)) as ComLen, SUM(LEN(Comment)) + (Count(Comment) * 3) as TotComLen,
		dbo.concat_comment([Table Name], [No_]) as FullComment
	 FROM	[Porteous$Comment Line]
	 WHERE	[Table Name] = 1 or  --Customer
		[Table Name] = 2 or  --Vendor
		[Table Name] = 3     --Item
	 GROUP BY [Table Name], [No_]) Length
WHERE	TotComLen > 255







-----------------------------------------------------------------------------------------------------

ORDER BY RIGHT([No_], LEN([No_])-4  ), [Line No_]


select *  
FROM	[Porteous$Comment Line] 

SELECT	[Table Name], [No_] as ItemNo, 'I' as Type, dbo.concat_comment([Table Name], [No_]) as Notes
FROM	[Porteous$Comment Line] 

--------------------------------------------------------------------------------------

--Load ItemNotes
SELECT	--pItemMasterID as fItemMasterID, 
	[Table Name], [No_] as ItemNo, 'I' as Type, dbo.concat_comment([Table Name], [No_]) as Notes
FROM	[Porteous$Comment Line] INNER JOIN
	OpenDataSource('SQLOLEDB','Data Source=PFCERPDB;User ID=pfcnormal;Password=pfcnormal').PERP.dbo.[ItemMaster]
ON	[No_] = ItemNo COLLATE SQL_Latin1_General_CP1_CI_AS
WHERE	dbo.concat_comment([Table Name], [No_]) <> '' AND [Table Name] = 3  --Item
GROUP BY [Table Name], [No_], dbo.concat_comment([Table Name], [No_]), pItemMasterID
ORDER BY [No_]


-----------------------------------------------------------------


CREATE Function concat_spec(@No varchar(20))
Returns varchar(512) as
   BEGIN
      DECLARE	@str varchar(512)

      SELECT	@str = coalesce(@str+'|','') + Comment
      FROM	[Porteous$Standard Text Line Comment]
      WHERE	LEFT([No_],4) = 'SPEC' AND
		RIGHT([No_], LEN([No_])-4) = @No AND 
		isnull(Comment,'') <> ''
      GROUP BY	[Line No_], Comment
      ORDER BY	[Line No_]

      RETURN	@str
   END






select	[No_] as SpecKey, RIGHT([No_], LEN([No_])-4) as Category, [Line No_] as LineNumber, Comment
From	[Porteous$Standard Text Line Comment]
where	left([No_],4) = 'SPEC'




select * from 	[Porteous$Standard Text Line Comment] order by [No_]



select distinct No_, charindex('?',No_) from [Porteous$Standard Text Line Comment]
where charindex('?',No_) > 0
