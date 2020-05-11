CREATE Function concat_spec(@CatNo varchar(10))
Returns nvarchar(4000) as
   BEGIN
      DECLARE	@str nvarchar(4000)

      SELECT	@str = coalesce(@str,'') + Comment
      FROM	tWO3014CategorySpecNotes
      WHERE	Category = @CatNo
      GROUP BY	LineNumber, Comment
      ORDER BY	LineNumber

      RETURN	@str
   END



select * from tWO3014CategorySpecNotes


      SELECT	--coalesce(@str+'|','') + Comment
		[No_] as SpecKey, RIGHT([No_],LEN([No_])-4) as Category, [Line No_] as LineNumber, Comment
      FROM	[Porteous$Standard Text Line Comment]
      WHERE	LEFT([No_],4) = 'SPEC' and RIGHT([No_],LEN([No_])-4) = '00001'

		AND
		RIGHT([No_], LEN([No_])-4) = @No AND 
		isnull(Comment,'') <> ''
      GROUP BY	[Line No_], Comment
      ORDER BY	[Line No_]